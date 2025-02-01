# KVM

[TOC]

## 概述

KVM（Kernel-based Virtual Machine），基于内核的虚拟机，是 Linux 内核的一部分（2.6.20 开始）。

是基于 x86 硬件虚拟化扩展（Intel VT 或 AMD-V）的全虚拟化解决方案，包含一个可加载的内核模块 kvm.ko，提供核心的虚拟化基础架构，还有一个处理器特定模块 kvm-intel.ko 或 kvm-amd.ko 。

## 什么是虚拟化？

​				RHEL 9 提供了*虚拟化*功能，它允许运行 RHEL 9 的机器 *托管*多个虚拟机(VM)，也称为*客户机（guest）*。VM 使用主机的物理硬件和计算资源，在主机操作系统中作为用户空间进程运行一个独立的虚拟操作系统（*客户机操作系统*）。 		

​				换句话说，虚拟化功能使在一个操作系统中执行其他操作系统成为可能。 		

​				VM 可让您安全地测试软件配置和功能，运行旧的软件或优化硬件的工作负载效率。有关优点的更多信息，请参阅 [虚拟化 的优势](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#advantages-of-virtualization_introducing-virtualization-in-rhel)。 		

​				有关虚拟化的更多信息，请参阅[红帽客户门户网站](https://www.redhat.com/en/topics/virtualization/what-is-virtualization)。 		

**后续步骤**

- ​						要在 Red Hat Enterprise Linux 9 中使用虚拟化，[请参阅在 Red Hat Enterprise Linux 9 中启用虚拟化](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)。 				
- ​						除了 Red Hat Enterprise Linux 9 虚拟化外，红帽还提供很多特殊的虚拟化解决方案，每个解决方案都有不同的用户重点和功能。如需更多信息，请参阅 [Red Hat 虚拟化解决方案](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#red-hat-virtualization-solutions_introducing-virtualization-in-rhel)。 				

## 1.2. 虚拟化的优点

​				与使用物理机器相比，使用虚拟机（VM）有以下优点： 		

- ​						**灵活精细的资源分配** 				

  ​						一个虚拟机在主机机器（通常是物理机器）上运行，主机的硬件也可以分配给客户机操作系统使用。但是，物理资源分配是在软件级别上完成的，因此非常灵活。虚拟机使用的主机内存、CPU 或存储空间的比例是可以配置的，可以指定非常精细的资源请求。 				

  ​						例如：客户机操作系统的磁盘可以在主机的文件系统中以一个文件代表，且该磁盘的大小限制比物理磁盘的限制要小。 				

- ​						**软件控制的配置** 				

  ​						虚拟机的整个配置都作为数据保存在主机上，并由软件控制。因此，虚拟机可轻松创建、删除、克隆、迁移、远程操作或连接到远程存储。 				

- ​						**与主机分离** 				

  ​						在虚拟内核中运行的客户机操作系统与主机操作系统分开。这意味着可在虚拟机中安装任何操作系统，即使虚拟机操作系统不稳定或受损，主机也不会受到任何影响。 				

- ​						**空间及成本效率** 				

  ​						单个物理机器可以托管大量虚拟机。因此，无需多个物理机器执行同样的任务，因此降低了与物理硬件关联的空间、电源和维护的要求。 				

- ​						**软件兼容性** 				

  ​						因为虚拟机可以使用不同于其主机的操作系统，所以通过虚拟化，可以运行最初没有为主机操作系统发布的应用程序。例如，通过使用 RHEL 7 客户机操作系统，您可以在 RHEL 9 主机系统上运行为 RHEL 7 发布的应用程序。 				

  注意

  ​							不是所有操作系统都作为 RHEL 9 主机中的客户机操作系统被支持。详情请查看 [RHEL 9 虚拟化中的推荐功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization)。 					

## 1.3. 虚拟机组件及其交互

​				RHEL 9 中的虚拟化由以下主要软件组件组成： 		

**虚拟机监控程序**

​					在 RHEL 9 中创建虚拟机(VM)的基础是 *hypervisor*，它是一个软件层，用于控制硬件并在主机中运行多个操作系统。 			

​				虚拟机监控程序包括 **Kernel-based Virtual Machine（KVM）** 模块和虚拟化内核驱动。这些组件可确保主机中的 Linux 内核为用户空间软件提供虚拟化资源。 		

​				在用户空间级别，**QEMU** 模拟器会模拟一个客户机操作系统可以在上面运行的完整虚拟硬件平台，并管理如何在主机中分配资源并提供给客户机。 		

​				此外，`libvirt` 软件套件充当管理和通信层，使 与 QEMU 更容易交互、实施安全规则，并提供用于配置和运行 VM 的许多其他工具。 		

**XML 配置**

​					基于主机的 XML 配置文件（也称*域 XML* 文件）决定了特定虚拟机中的所有设置和设备。配置包括： 			

- ​						元数据，如虚拟机名称、时区和其他有关虚拟机的信息。 				
- ​						对虚拟机中的设备的描述，包括虚拟 CPU（vCPUS）、存储设备、输入/输出设备、网络接口卡及其他真实和虚拟硬件。 				
- ​						虚拟机设置，如它可以使用的最大内存量、重启设置和其他有关虚拟机行为的设置。 				

​				有关 XML 配置内容的更多信息，请参阅查看虚拟机的信息。 		

**组件交互**

​					当虚拟机启动时，虚拟机监控程序使用 XML 配置在主机上以用户空间进程的形式创建虚拟机实例。hypervisor 还使虚拟机进程能被基于主机的接口访问，如 `virsh`、`virt-install` 和 `guestfish` 工具，或者 Web 控制台 GUI。 			

​				当使用这些虚拟化工具时，libvirt 会将它们的输入转换成 QEMU 的指令。QEMU 将指令信息发送到  KVM，这样可确保内核正确分配执行该指令所需的资源。因此，QEMU  可以执行相应的用户空间更改，如创建或修改虚拟机或在虚拟机的客户机操作系统中执行操作。 		

注意

​					尽管 QEMU 是架构的一个基本组件，但由于安全原因，它并适合于直接在 RHEL 9 系统中使用。因此，红帽不支持使用 `qemu-*` 命令，强烈建议您使用 libvirt 与 QEMU 进行交互。 			

​				有关基于主机的接口的更多信息，请参阅 [虚拟化管理的工具和接口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#con_tools-and-interfaces-for-virtualization-management_introducing-virtualization-in-rhel)。 		

**图 1.1. RHEL 9 虚拟化架构**

[![virt 构架](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/7372587533ceed7db8956de504f54d85/virt-architecture.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/7372587533ceed7db8956de504f54d85/virt-architecture.png)

## 1.4. 用于虚拟化管理的工具和界面

​				您可以使用命令行界面(CLI)或几个图形用户界面(GUI)管理 RHEL 9 中的虚拟化。 		

**命令行界面**

​					CLI 是 RHEL 9 中管理虚拟化的最强大的方法。虚拟机（VM）管理的 CLI 命令包括： 			

- ​						**virsh** - 一个多用途的虚拟化命令行工具程序和 shell，根据提供的参数，可以实现不同功能。例如： 				

  - ​								启动和关闭虚拟机 - `virsh start` 和 `virsh shutdown` 						
  - ​								列出可用的虚拟机 - `virsh list` 						
  - ​								从配置文件创建虚拟机 - `virsh create` 						
  - ​								进入虚拟化 shell - `virsh` 						

  ​						如需更多信息，请参阅 `virsh(1)` 手册页。 				

- ​						`virt-install` - 用于创建新虚拟机的 CLI 工具。如需更多信息，请参阅 `virt-install(1)` 手册页。 				

- ​						`virt-xml` - 用于编辑虚拟机配置的工具。 				

- ​						`guestfish` - 用于检查和修改虚拟机磁盘镜像的工具。如需更多信息，请参阅 `guestfish(1)` 手册页。 				

**图形界面**

​					您可以使用以下 GUI 在 RHEL 9 中管理虚拟化： 			

- ​						**RHEL 9 web 控制台** （也称为 *Cockpit* ）提供了一个可以远程访问的、易于使用的图形用户界面，用于管理虚拟机和虚拟化主机。 				

  ​						有关使用 web 控制台进行基本虚拟化管理的步骤请参考 [第 8 章 *在 web 控制台中管理虚拟机*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization)。 				

## 1.5. 红帽虚拟化解决方案

​				以下红帽产品基于 RHEL 9 虚拟化功能构建，并扩展了 RHEL 9 中的 KVM 虚拟化功能。另外，RHEL 9 虚拟化的许多限制不适用于这些产品： 		

- OpenShift Virtualization

  ​							OpenShift Virtualization 基于 KubeVirt 技术，作为 Red Hat OpenShift Container Platform 的一部分，并可在容器中运行虚拟机。 					 						有关 OpenShift Virtualization 的更多信息，请参阅[红帽混合云](https://cloud.redhat.com/learn/topics/virtualization/)页面。 					

- Red Hat OpenStack Platform（RHOSP）

  ​							Red Hat OpenStack Platform 为创建、部署并扩展一个安全可靠的公共或私有 [OpenStack](https://www.redhat.com/en/topics/openstack) 云环境提供了一个集成的基础。 					 						如需有关 Red Hat OpenStack Platform 的更多信息，请参阅[红帽客户门户网站](https://www.redhat.com/en/technologies/linux-platforms/openstack-platform)或 [Red Hat OpenStack Platform 文档套件](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/)。 					

注意

​					有关在 RHEL 中不被支持但在其他 Red Hat 虚拟化解决方案中被支持的虚拟化功能的详情，请参阅 RHEL 9 虚拟化中不支持的功能。 			

# 第 2 章 启用虚拟化

​			要在 RHEL 9 中使用虚拟化，您必须安装虚拟化软件包并确保将您的系统配置为托管虚拟机(VM)。具体步骤根据您的 CPU 架构而有所不同。 	

## 2.1. 在 AMD64 和 Intel 64 中启用虚拟化

​				要在运行 RHEL 9 的 AMD64 或者 Intel 64 系统中设置 KVM 管理程序并创建虚拟机(VM)，请按照以下步骤操作。 		

**先决条件**

- ​						Red Hat Enterprise Linux 9 已在主机中[安装并注册](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performing_a_standard_rhel_9_installation/index)。 				
- ​						您的系统满足以下硬件要求以作为虚拟主机工作： 				
  - ​								主机的构架[支持 KVM 虚拟化](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization)。 						
  - ​								有以下最小系统资源可用： 						
    - ​										主机有 6 GB 可用磁盘空间，以及每个预期的虚拟机需要额外 6 GB 空间。 								
    - ​										主机需要 2 GB RAM，以及每个预期的虚拟机需要额外 2 GB。 								

**流程**

1. ​						安装虚拟化 hypervisor 软件包。 				

   ```none
   # dnf install qemu-kvm libvirt virt-install virt-viewer
   ```

2. ​						启动虚拟化服务： 				

   ```none
   # for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done
   ```

**验证**

1. ​						确认您的系统已准备好成为虚拟化主机： 				

   ```none
   # virt-host-validate
   [...]
   QEMU: Checking for device assignment IOMMU support         : PASS
   QEMU: Checking if IOMMU is enabled by kernel               : WARN (IOMMU appears to be disabled in kernel. Add intel_iommu=on to kernel cmdline arguments)
   LXC: Checking for Linux >= 2.6.26                          : PASS
   [...]
   LXC: Checking for cgroup 'blkio' controller mount-point    : PASS
   LXC: Checking if device /sys/fs/fuse/connections exists    : FAIL (Load the 'fuse' module to enable /proc/ overrides)
   ```

2. ​						如果所有 **virt-host-validate** 检查返回 `PASS` 值，则您的系统已准备好 [创建虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization) 。 				

   ​						如果有任何检查返回 `FAIL` 值，请按照显示的说明来修复问题。 				

   ​						如果有任何检查返回 `WARN` 值，请考虑按照显示的说明改进虚拟化功能。 				

**故障排除**

- ​						如果您的主机 CPU 不支持 KVM 虚拟化，**virt-host-validate** 会生成以下输出： 				

  ```none
  QEMU: Checking for hardware virtualization: FAIL (Only emulated CPUs are available, performance will be significantly limited)
  ```

  ​						但是，在这样的主机系统上的虚拟机将无法引导，而不是只存在性能问题。 				

  ​						要临时解决这个问题，您可以将虚拟机的 XML 配置中的 `<domain type>` 值更改为 `qemu`。但请注意，红帽不支持使用 `qemu` 域类型的虚拟机，在生产环境中不建议这样做。 				

**后续步骤**

- ​						[在 RHEL 9 主机上创建虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization) 				

## 2.2. 在 IBM Z 中启用虚拟化

​				要在运行 RHEL 9 的 IBM Z 系统上设置 KVM 管理程序并创建虚拟机(VM)，请按照以下步骤操作。 		

**先决条件**

- ​						有以下最小系统资源可用： 				

  - ​								主机有 6 GB 可用磁盘空间，以及每个预期的虚拟机需要额外 6 GB 空间。 						
  - ​								主机需要 2 GB RAM，以及每个预期的虚拟机需要额外 2 GB。 						
  - ​								主机上有 4 个 CPU。虚拟机通常可以使用单个分配的 vCPU 运行，但红帽建议为每个虚拟机分配 2 个或更多 vCPU，以避免虚拟机在高负载期间变得无响应。 						

- ​						您的 IBM Z 主机系统使用 z13 CPU 或更高版本。 				

- ​						RHEL 9 安装在逻辑分区(LPAR)上。另外，LPAR 支持 *启动阶段执行*（SIE）虚拟化功能。 				

  ​						要验证这一点，请在 `/proc/cpuinfo` 文件中搜索 `sie`。 				

  ```none
  # grep sie /proc/cpuinfo/
  features        : esan3 zarch stfle msa ldisp eimm dfp edat etf3eh highgprs te sie
  ```

**流程**

1. ​						安装虚拟化软件包： 				

   ```none
   # dnf install qemu-kvm libvirt virt-install
   ```

2. ​						启动虚拟化服务： 				

   ```none
   # for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done
   ```

**验证**

1. ​						验证您的系统已准备好成为虚拟化主机。 				

   ```none
   # virt-host-validate
   [...]
   QEMU: Checking if device /dev/kvm is accessible             : PASS
   QEMU: Checking if device /dev/vhost-net exists              : PASS
   QEMU: Checking if device /dev/net/tun exists                : PASS
   QEMU: Checking for cgroup 'memory' controller support       : PASS
   QEMU: Checking for cgroup 'memory' controller mount-point   : PASS
   [...]
   ```

2. ​						如果所有 **virt-host-validate** 检查返回 `PASS` 值，则您的系统已准备好 [创建虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization) 。 				

   ​						如果有任何检查返回 `FAIL` 值，请按照显示的说明来修复问题。 				

   ​						如果有任何检查返回 `WARN` 值，请考虑按照显示的说明改进虚拟化功能。 				

**故障排除**

- ​						如果您的主机 CPU 不支持 KVM 虚拟化，**virt-host-validate** 会生成以下输出： 				

  ```none
  QEMU: Checking for hardware virtualization: FAIL (Only emulated CPUs are available, performance will be significantly limited)
  ```

  ​						但是，在这样的主机系统上的虚拟机将无法引导，而不是只存在性能问题。 				

  ​						要临时解决这个问题，您可以将虚拟机的 XML 配置中的 `<domain type>` 值更改为 `qemu`。但请注意，红帽不支持使用 `qemu` 域类型的虚拟机，在生产环境中不建议这样做。 				

## 2.3. 在 ARM 64 中启用虚拟化

​				要在运行 RHEL 9 的 ARM 64 系统中创建虚拟机的 KVM 管理程序，请遵循以下步骤。 		

重要

​					ARM 64 上的虚拟化仅作为技术预览在 RHEL 9 中提供，因此不受支持。https://access.redhat.com/support/offerings/techpreview/ 			

**先决条件**

- ​						有以下最小系统资源可用： 				
  - ​								主机有 6 GB 的可用磁盘空间，以及每个预期的客户机的 6 GB 空间。 						
  - ​								主机需要 4 GB RAM，以及每个预期的虚拟机需要 4 GB。 						

**步骤**

1. ​						安装虚拟化软件包： 				

   ```none
   # dnf install qemu-kvm libvirt virt-install
   ```

2. ​						启动虚拟化服务： 				

   ```none
   # for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done
   ```

**验证**

1. ​						确认您的系统已准备好成为虚拟化主机： 				

   ```none
   # virt-host-validate
   [...]
   QEMU: Checking if device /dev/vhost-net exists              : PASS
   QEMU: Checking if device /dev/net/tun exists                : PASS
   QEMU: Checking for cgroup 'memory' controller support       : PASS
   QEMU: Checking for cgroup 'memory' controller mount-point   : PASS
   [...]
   QEMU: Checking for cgroup 'blkio' controller support        : PASS
   QEMU: Checking for cgroup 'blkio' controller mount-point    : PASS
   QEMU: Checking if IOMMU is enabled by kernel                : WARN (Unknown if this platform has IOMMU support)
   ```

2. ​						如果所有 **virt-host-validate** 检查都返回 `PASS` 值，则代表您的系统已准备好 [创建虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 				

   ​						如果有任何检查返回 `FAIL` 值，请按照显示的说明来修复问题。 				

   ​						如果有任何检查返回 `WARN` 值，请考虑按照显示的说明改进虚拟化功能。 				

**故障排除**

- ​						如果您的主机 CPU 不支持 KVM 虚拟化，**virt-host-validate** 会生成以下输出： 				

  ```none
  QEMU: Checking for hardware virtualization: FAIL (Only emulated CPUs are available, performance will be significantly limited)
  ```

  ​						但是，在这样的主机系统上的虚拟机将无法引导，而不是只存在性能问题。 				

  ​						要临时解决这个问题，您可以将虚拟机的 XML 配置中的 `<domain type>` 值更改为 `qemu`。但请注意，红帽不支持使用 `qemu` 域类型的虚拟机，在生产环境中不建议这样做。 				

**后续步骤**

- ​						[创建虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization) 				

**其他资源**

- ​						[ARM 64 上的虚拟化与 AMD64 和 Intel 64 的不同](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#how-virtualization-on-arm-64-differs-from-amd64-and-intel64_feature-support-and-limitations-in-rhel-9-virtualization) 				

# 第 3 章 创建虚拟机

​			要在 RHEL 9 中创建虚拟机(VM)，请使用[命令行界面（CLI）](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-virtual-machines-using-the-command-line-interface_assembly_creating-virtual-machines)或 [RHEL 9 web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-vms-and-installing-an-os-using-the-rhel-web-console_assembly_creating-virtual-machines)。 	

**先决条件**

- ​					已在您的系统中[安装并启用](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)虚拟化。 			

- ​					您有足够的系统资源来分配给您的虚拟机，如磁盘空间、RAM 或 CPU。根据虚拟机的预期任务和工作负载，推荐的值可能会有很大不同。 			

  警告

  ​						RHEL 9 无法从主机 CD-ROM 或者 DVD-ROM 设备安装。如果您在使用 RHEL 9 中的任何 VM 安装方法时选择了 CD-ROM 或者 DVD-ROM 作为安装源，则安装将失败。如需更多信息，请参阅[红帽知识库](https://access.redhat.com/solutions/1185913)。 				

## 3.1. 使用命令行界面创建虚拟机

​				要使用 `virt-install` 程序在 RHEL 9 主机上创建虚拟机(VM)，请按照以下步骤操作。 		

**先决条件**

- ​						虚拟化[已在您的主机系统中启用](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)。 				

- ​						您有足够的系统资源可以分配给虚拟机，如磁盘空间、RAM 或 CPU。根据虚拟机的预期任务和工作负载，推荐的值可能会有很大不同。 				

- ​						操作系统（OS）安装源可存在于本地或者网络中。可以是以下之一： 				

  - ​								安装介质的 ISO 镜像 						

  - ​								现有虚拟机安装的磁盘镜像 						

    警告

    ​									在 RHEL 9 中无法从主机 CD-ROM 或者 DVD-ROM 设备安装。当使用 RHEL 9 中的任何虚拟机安装方法时，如果选择了 CD-ROM 或者 DVD-ROM 作为安装源，则安装将失败。如需更多信息，请参阅[红帽知识库](https://access.redhat.com/solutions/1185913)。 							

- ​						可选：可以提供一个 Kickstart 文件，以便更快地配置安装。 				

**步骤**

​					要创建虚拟机并启动其操作系统安装，请使用 `virt-install` 命令以及以下强制参数： 			

- ​						新机器的名称(`--name`) 				
- ​						分配的内存量(`--memory`) 				
- ​						分配的虚拟 CPU 数量(`--vcpus`) 				
- ​						所分配的存储的类型和大小(`--disk`) 				
- ​						OS 安装源的类型和位置（`--cdrom` 或 `--location`） 				

​				根据所选安装方法，所需选项和值可能会有所不同。请参阅以下的示例： 		

- ​						下面创建一个名为 **demo-guest1** 的虚拟机，它从本地存储在 **/home/username/Downloads/Win10install.iso** 文件中的 ISO 镜像安装 Windows 10 OS。此虚拟机还可分配 2048 MiB RAM 和 2 个 vCPU，为虚拟机自动配置 80 GiB qcow2 虚拟磁盘。 				

  ```none
  # virt-install --name demo-guest1 --memory 2048 --vcpus 2 --disk size=80 --os-variant win10 --cdrom /home/username/Downloads/Win10install.iso
  ```

- ​						下面创建一个名为 **demo-guest2** 的虚拟机，它使用 **/home/username/Downloads/rhel9.iso** 镜像从 live CD 运行 RHEL 9 OS。没有为这个虚拟机分配磁盘空间，因此在此会话中所做的更改不会被保留。另外，虚拟机被分配 4096 MiB RAM 和 4 个 vCPU。 				

  ```none
  # virt-install --name demo-guest2 --memory 4096 --vcpus 4 --disk none --livecd --os-variant rhel9.0 --cdrom /home/username/Downloads/rhel9.iso
  ```

- ​						下面创建一个名为 **demo-guest3** 的 RHEL 9 虚拟机，它连接到现有磁盘镜像 **/home/username/backup/disk.qcow2**。这和在不同的机器间物理地移动硬盘驱动器类似，因此 demo-guest3 可用的操作系统和数据由之前处理镜像的方式决定。另外，这个虚拟机还会分配 2048 MiB RAM 和 2 个 vCPU。 				

  ```none
  # virt-install --name demo-guest3 --memory 2048 --vcpus 2 --os-variant rhel9.0 --import --disk /home/username/backup/disk.qcow2
  ```

  ​						请注意，在导入磁盘镜像时，强烈建议使用 `--os-variant` 选项。如果没有提供，创建虚拟机的性能将会受到负面影响。 				

- ​						下面创建了一个名为 **demo-guest4** 的虚拟机，该虚拟机可从 `http://example.com/OS-install` URL 安装。要使安装成功启动，URL 必须包含可正常工作的操作系统安装树。另外，操作系统是使用 **/home/username/ks.cfg** kickstart 文件自动配置的。此虚拟机还可分配 2048 MiB RAM、2 个 vCPU 和 160 GiB qcow2 虚拟磁盘。 				

  ```none
  # virt-install --name demo-guest4 --memory 2048 --vcpus 2 --disk size=160 --os-variant rhel9.0 --location http://example.com/OS-install --initrd-inject /home/username/ks.cfg --extra-args="inst.ks=file:/ks.cfg console=tty0 console=ttyS0,115200n8"
  ```

- ​						下面创建一个名为 **demo-guest5** 的虚拟机，它使用文本模式安装 `RHEL9.iso` 镜像文件，而无需图形界面。它将客户端控制台连接到串行控制台。虚拟机有 16384 MiB 内存、16 个 vCPU 和 280 GiB 磁盘。当通过慢速网络连接连接到主机时这种安装很有用。 				

  ```none
  # virt-install --name demo-guest5 --memory 16384 --vcpus 16 --disk size=280 --os-variant rhel9.0 --location RHEL9.iso --graphics none --extra-args='console=ttyS0'
  ```

- ​						下面创建一个名为 **demo-guest6** 的虚拟机，其配置与 demo-guest5 相同，但会位于 10.0.0.1 远程主机上。 				

  ```none
  # virt-install --connect qemu+ssh://root@10.0.0.1/system --name demo-guest6 --memory 16384 --vcpus 16 --disk size=280 --os-variant rhel9.0 --location RHEL9.iso --graphics none --extra-args='console=ttyS0'
  ```

- ​						以下会创建一个名为 **demo-guest-7** 的虚拟机，它与 demo-guest5 的配置相同，但对于其存储，使用 DASD 介质设备 `mdev_30820a6f_b1a5_4503_91ca_0c10ba12345a_0_0_29a8`，并为其分配设备编号 `1111`。 				

  ```none
  # virt-install --name demo-guest7 --memory 16384 --vcpus 16 --disk size=280 --os-variant rhel9.0 --location RHEL9.iso --graphics none --disk none --hostdev mdev_30820a6f_b1a5_4503_91ca_0c10ba12345a_0_0_29a8,address.type=ccw,address.cssid=0xfe,address.ssid=0x0,address.devno=0x1111,boot-order=1 --extra-args 'rd.dasd=0.0.1111'
  ```

  ​						请注意，可以使用 `virsh nodedev-list --cap mdev` 命令来检索可用的介质设备的名称。 				

**验证**

- ​						如果成功创建虚拟机，则使用虚拟机的图形控制台打开 [virt-viewer](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-graphical-console-using-virt-viewer_assembly_connecting-to-virtual-machines) 窗口并启动客户端操作系统安装。 				

**故障排除**

- ​						如果 `virt-install` 失败，且出现 `cannot find default network` 错误： 				

  1. ​								确定 *libvirt-daemon-config-network* 软件包已安装： 						

     ```none
     # dnf info libvirt-daemon-config-network
     Installed Packages
     Name         : libvirt-daemon-config-network
     [...]
     ```

  2. ​								验证 `libvirt` 默认网络是否处于活动状态，并且已配置为自动启动： 						

     ```none
     # virsh net-list --all
      Name      State    Autostart   Persistent
     --------------------------------------------
      default   active   yes         yes
     ```

  3. ​								如果没有，激活默认网络并将其设置为 auto-start： 						

     ```none
     # virsh net-autostart default
     Network default marked as autostarted
     
     # virsh net-start default
     Network default started
     ```

     1. ​										如果激活默认网络失败并显示以下错误，则代表还没有正确安装 *libvirt-daemon-config-network* 软件包。 								

        ```none
        error: failed to get network 'default'
        error: Network not found: no network with matching name 'default'
        ```

        ​										要解决这个问题，请重新安装 *libvirt-daemon-config-network*。 								

        ```none
        # dnf reinstall libvirt-daemon-config-network
        ```

     2. ​										如果激活默认网络失败并显示类似如下的错误，则默认网络子网和主机上现有接口之间出现了冲突。 								

        ```none
        error: Failed to start network default
        error: internal error: Network is already in use by interface ens2
        ```

        ​										要解决这个问题，请使用 `virsh net-edit default` 命令，并将配置中的 `192.168.122.*` 值更改为主机上尚未使用的子网。 								

**其他资源**

- ​						`man virt-install` 命令 				

## 3.2. 使用 web 控制台创建虚拟机并安装客户端操作系统

​				要在 RHEL 9 主机上的 GUI 中管理虚拟机(VM)，请使用 web 控制台。以下小节介绍了如何使用 RHEL 9 web 控制台创建虚拟机并安装客户机操作系统。 		

### 3.2.1. 使用 web 控制台创建虚拟机

​					要在连接 web 控制台的主机机器中创建虚拟机（VM），请遵循以下步骤。 			

**先决条件**

- ​							虚拟化[已在您的主机系统中启用](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)。 					
- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							您有足够的系统资源可以分配给虚拟机，如磁盘空间、RAM 或 CPU。根据虚拟机的预期任务和工作负载，推荐的值可能会有很大不同。 					

**流程**

1. ​							在 web 控制台的 Virtual Machines 界面中，点 **Create VM**。 					

   ​							此时会出现 Create new virtual machine 对话框。 					

   [![显示创建新虚拟机对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/c5b8ac2ecad47333d0b1729dc5c61165/virt-cockpit-create-new.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/c5b8ac2ecad47333d0b1729dc5c61165/virt-cockpit-create-new.png)

2. ​							输入您要创建的虚拟机的基本配置。 					

   - ​									**Name** - 虚拟机的名称。 							
   - ​									**Connection** - libvirt 连接、系统或者会话的类型。如需了解更多详细信息，请参阅系统和会话连接。 							
   - ​									**安装类型** - 安装可以使用本地安装介质、URL、PXE 网络引导、云基础镜像，或者从有限的操作系统中下载操作系统。 							
   - ​									**Operating system** - 虚拟机的操作系统.请注意，红帽只为 [有限的客户机操作系统集](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 提供支持。 							
   - ​									**Storage** - 用于配置虚拟机的存储的类型。 							
   - ​									**Size** - 用于配置虚拟机的存储空间的大小。 							
   - ​									**Memory** - 用于配置虚拟机的内存量。 							
   - ​									**Run unattended installation** - 是否运行无人值守安装。只有在 **安装类型** 为 **Download an OS** 时，这个选项才可用。 							
   - ​									**Immediately Start VM** - 虚拟机是否在创建后立即启动。 							

3. ​							点击 Create。 					

   ​							虚拟机已创建。如果选择了**立即启动虚拟机**复选框，则虚拟机将立即启动并开始安装客户端操作系统。 					

**其他资源**

- ​							[在虚拟机上安装操作系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-an-os-using-the-rhel-web-console_creating-vms-and-installing-an-os-using-the-rhel-web-console) 					

### 3.2.2. 使用 web 控制台导入磁盘镜像来创建虚拟机

​					要通过导入现有虚拟机安装的磁盘镜像来创建虚拟机（VM），请遵循以下步骤。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							您有足够的系统资源可以分配给虚拟机，如磁盘空间、RAM 或 CPU。根据虚拟机的预期任务和工作负载，推荐的值可能会有很大不同。 					
- ​							确保已有虚拟机安装的磁盘镜像 					

**流程**

1. ​							在 web 控制台的 `Virtual Machines` 界面中，单击 **Import VM**。 					

   ​							这时将出现 Import a virtual machine 对话框。 					

   [![显示导入虚拟机对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a6cf45e70b4d4d0b844b1d0551d28f31/virt-cockpit-import.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a6cf45e70b4d4d0b844b1d0551d28f31/virt-cockpit-import.png)

2. ​							输入您要创建的虚拟机的基本配置。 					

   - ​									**Name** - 虚拟机的名称。 							
   - ​									**Connection** - libvirt 连接、系统或者会话的类型。如需了解更多详细信息，请参阅系统和会话连接。 							
   - ​									**Disk image** - 主机系统上虚拟机现有磁盘映像的路径。 							
   - ​									**Operating system** - 虚拟机的操作系统.请注意，红帽只为 [有限的客户机操作系统集](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 提供支持。 							
   - ​									**Memory** - 用于配置虚拟机的内存量。 							
   - ​									**Immediately start VM** - 虚拟机是否在创建后立即启动。 							

3. ​							点击 Import。 					

### 3.2.3. 使用 Web 控制台安装客户端操作系统

​					第一次载入虚拟机（VM）时，您必须在虚拟机上安装操作系统。 			

注意

​						如果选中 *Create New Virtual Machine 对话框中的 Immediately Start VM* 复选框，则在创建虚拟机时自动启动操作系统的安装过程。 				

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							在其中安装操作系统的虚拟机必须可用。 					

**步骤**

1. ​							在 Virtual Machines 界面中，单击要在其上安装客户机操作系统的虚拟机。 					

   ​							此时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及管理虚拟机各方面的控制。 					

   [![显示有关虚拟机的详细信息的页面。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/5ad3104b520af79ea98a67459ffaedcd/virt-cockpit-VM-home.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/5ad3104b520af79ea98a67459ffaedcd/virt-cockpit-VM-home.png)

2. ​							**可选** ：更改固件。 					

   注意

   ​								只有在 **Create New Virtual Machine** 对话框中没有选择 Immediately *Start VM* 复选框且虚拟机上还没有安装操作系统时，才能更改固件。 						

   1. ​									点击固件。 							
   2. ​									在 Change Firmware 窗口中，选择所需固件。 							
   3. ​									点击 Save。 							

3. ​							点 Install。 					

   ​							在 VM 控制台中运行的操作系统的安装过程。 					

**故障排除**

- ​							如果安装过程失败，则必须删除虚拟机并重新创建。 					

### 3.2.4. 使用 web 控制台使用云镜像身份验证创建虚拟机

​					默认情况下，不同的云镜像没有登录帐户。但是，使用 RHEL web 控制台，您现在可以创建虚拟机(VM)，并指定 root 和用户帐户登录凭证，然后传递给 cloud-init。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							虚拟化[已在您的主机系统中启用](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)。 					
- ​							您有足够的系统资源来分配给您的虚拟机，如磁盘空间、RAM 或 CPU。根据虚拟机的预期任务和工作负载，推荐的值可能会有很大不同。 					

**流程**

1. ​							在 web 控制台的 Virtual Machines 界面中，点 **Create VM**。 					

   ​							此时会出现 Create new virtual machine 对话框。 					

   [![显示创建新虚拟机对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/c5b8ac2ecad47333d0b1729dc5c61165/virt-cockpit-create-new.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/c5b8ac2ecad47333d0b1729dc5c61165/virt-cockpit-create-new.png)

2. ​							在 **Name** 字段中输入虚拟机的名称。 					

3. ​							在 **Installation type** 字段中，选择 **Cloud base image**。 					

   [![显示使用 cloud-init 创建新虚拟机对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/4b6dc038d28f539a71120d5702c27363/virt-cockpit-create-cloud-vm.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/4b6dc038d28f539a71120d5702c27363/virt-cockpit-create-cloud-vm.png)

4. ​							在 **Installation source** 字段中，设置主机系统中镜像文件的路径。 					

5. ​							输入您要创建的虚拟机的配置。 					

   - ​									**Operating system** - 虚拟机的操作系统.请注意，红帽只为 [有限的客户机操作系统集](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 提供支持。 							
   - ​									**Storage** - 用于配置虚拟机的存储的类型。 							
   - ​									**Size** - 用于配置虚拟机的存储空间的大小。 							
   - ​									**Memory** - 用于配置虚拟机的内存量。 							

6. ​							选择 **Set cloud init 参数**。 					

   ​							设置云身份验证凭证。 					

   - ​									**Root 密码** - 输入虚拟机的 root 密码。如果您不想设置 root 密码，请将该字段留空。 							
   - ​									**User login** - 输入 cloud-init 用户登录。 							
   - ​									**User password** - 输入密码。如果您不想设置密码，请将该字段留空。 							

7. ​							点击 Create。 					

   ​							虚拟机已创建。 					

**其他资源**

- ​							[在虚拟机上安装操作系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-an-os-using-the-rhel-web-console_creating-vms-and-installing-an-os-using-the-rhel-web-console) 					

# 第 4 章 启动虚拟机

​			要在 RHEL 9 中启动虚拟机（VM），您可以使用 [命令行界面](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-a-virtual-machine-using-the-command-line-interface_assembly_starting-virtual-machines) 或 [web 控制台 GUI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines)。 	

**先决条件**

- ​					在启动虚拟机前，它必须被创建，理想情况下，还要使用操作系统进行安装。有关操作请参考 [第 3 章 *创建虚拟机*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 			

## 4.1. 使用命令行界面启动虚拟机

​				您可以使用命令行界面（CLI）来启动关闭的虚拟机(VM)或恢复保存的虚拟机。使用 CLI，您可以启动本地和远程虚拟机。 		

**先决条件**

- ​						已定义的一个不活跃地虚拟机。 				
- ​						虚拟机的名称。 				
- ​						对于远程虚拟机： 				
  - ​								虚拟机所在主机的 IP 地址。 						
  - ​								对主机的 root 访问权限。 						

**步骤**

- ​						对于本地虚拟机，请使用 `virsh start` 工具。 				

  ​						例如，以下命令启动 *demo-guest1* 虚拟机。 				

  ```none
  # virsh start demo-guest1
  Domain 'demo-guest1' started
  ```

- ​						对于位于远程主机上的虚拟机，请使用 `virsh start` 工具以及与主机的 QEMU+SSH 连接。 				

  ​						例如，以下命令在 192.168.123.123 主机上启动 *demo-guest1* 虚拟机。 				

  ```none
  # virsh -c qemu+ssh://root@192.168.123.123/system start demo-guest1
  
  root@192.168.123.123's password:
  
  Domain 'demo-guest1' started
  ```

**其他资源**

- ​						`virsh start --help` 命令 				
- ​						[设置对远程虚拟化主机的简单访问](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-easy-access-to-remote-virtualization-hosts_assembly_connecting-to-virtual-machines) 				
- ​						[当主机启动时自动启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-virtual-machines-automatically-when-the-host-starts_assembly_starting-virtual-machines) 				

## 4.2. 使用 web 控制台启动虚拟机

​				如果虚拟机（VM）处于*关闭*状态，您可以使用 RHEL 9 web 控制台启动它。您还可以将虚拟机配置为在主机启动时自动启动。 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						已定义的一个不活跃地虚拟机。 				
- ​						虚拟机的名称。 				

**步骤**

1. ​						在 Virtual Machines 界面中，点击您要启动的虚拟机。 				

   ​						此时将打开一个新页面，其中包含有关所选虚拟机的详细信息，以及关闭和删除虚拟机的控制。 				

2. ​						点 Run。 				

   ​						虚拟机启动，您可以[连接到其控制台或图形输出](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/assembly_connecting-to-virtual-machines_configuring-and-managing-virtualization)。 				

3. ​						**可选：**要将虚拟机配置为在主机启动时自动启动，请单击 `Autostart` 复选框。 				

   ​						如果使用不由 libvirt 管理的网络接口，您还必须对 systemd 配置进行额外的更改。否则，受影响的虚拟机可能无法启动，请参阅 [当主机启动时自动启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-virtual-machines-automatically-when-the-host-starts_assembly_starting-virtual-machines)。 				

**其他资源**

- ​						[在 web 控制台中关闭虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 				
- ​						[使用 web 控制台重启虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#restarting-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 				

## 4.3. 当主机启动时自动启动虚拟机

​				当一个运行的虚拟机(VM)重启时，虚拟机将关闭，且必须默认手动启动。要确保虚拟机在其主机运行时都处于活跃状态，您可以将虚拟机配置为自动启动。 		

**先决条件**

- ​						[已创建了虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization) 				

**流程**

1. ​						使用 `virsh autostart` 工具将虚拟机配置为在主机启动时自动启动。 				

   ​						例如，以下命令将 *demo-guest1* 虚拟机配置为自动启动： 				

   ```none
   # virsh autostart demo-guest1
   Domain 'demo-guest1' marked as autostarted
   ```

2. ​						如果使用不由 `libvirt` 管理的网络接口，您还必须对 systemd 配置进行额外的更改。否则，受影响的虚拟机可能无法启动。 				

   注意

   ​							例如，这些接口包括： 					

   - ​									`NetworkManager` 创建的网桥设备 							
   - ​									网络配置为使用 `<forward mode='bridge'/>` 							

   1. ​								在 systemd 配置目录树中，如果 `virtqemud.service.d` 目录尚不存在，则创建该目录。 						

      ```none
      # mkdir -p /etc/systemd/system/virtqemud.service.d/
      ```

   2. ​								在之前创建的目录中创建一个 `10-network-online.conf` systemd 单元覆盖文件。此文件的内容覆盖 `virtqemud` 服务的默认 systemd 配置。 						

      ```none
      # touch /etc/systemd/system/virtqemud.service.d/10-network-online.conf
      ```

   3. ​								将以下行添加到 `10-network-online.conf` 文件中：这个配置更改可确保 systemd 仅在主机上的网络就绪后启动 `virtqemud` 服务。 						

      ```none
      [Unit]
      After=network-online.target
      ```

**验证**

1. ​						查看虚拟机配置，并检查是否启用了 *autostart* 选项。 				

   ​						例如，以下命令显示有关 *demo-guest1* 虚拟机的基本信息，包括 *autostart* 选项： 				

   ```none
   # virsh dominfo demo-guest1
   Id:             2
   Name:           demo-guest1
   UUID:           e46bc81c-74e2-406e-bd7a-67042bae80d1
   OS Type:        hvm
   State:          running
   CPU(s):         2
   CPU time:       385.9s
   Max memory:     4194304 KiB
   Used memory:    4194304 KiB
   Persistent:     yes
   Autostart:      enable
   Managed save:   no
   Security model: selinux
   Security DOI:   0
   Security label: system_u:system_r:svirt_t:s0:c873,c919 (enforcing)
   ```

2. ​						如果您使用不由 libvirt 管理的网络接口，请检查 `10-network-online.conf` 文件的内容是否与以下输出匹配： 				

   ```none
   $ cat /etc/systemd/system/virtqemud.service.d/10-network-online.conf
   [Unit]
   After=network-online.target
   ```

**其他资源**

- ​						`virsh autostart --help` 命令 				
- ​						[使用 web 控制台启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines)。 				

# 第 5 章 连接至虚拟机

​			要在 RHEL 9 中与虚拟机(VM)交互，您需要通过以下方法之一连接它： 	

- ​					使用 Web 控制台界面时，请在 web 控制台界面中使用 Virtual Machines 窗格。更多信息请参阅 [第 5.1 节 “使用 web 控制台与虚拟机交互”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-consoles-using-the-rhel-web-console_assembly_connecting-to-virtual-machines)。 			
- ​					如果您需要在不使用 Web 控制台的情况下与虚拟机图形显示交互，请使用 Virt Viewer 应用程序。详情请查看 [第 5.2 节 “使用 Virt Viewer 打开虚拟机图形控制台”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-graphical-console-using-virt-viewer_assembly_connecting-to-virtual-machines)。 			
- ​					如果不需要图形显示，请使用 [SSH 终端连接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_connecting-to-a-virtual-machine-using-ssh_assembly_connecting-to-virtual-machines)。 			
- ​					当使用网络无法从您的系统访问虚拟机时，请使用 [virsh 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-serial-console_assembly_connecting-to-virtual-machines)。 			

​			如果您要连接的虚拟机位于远程主机而不是本地主机，您可以选择配置您的系统[以更方便地访问远程主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-easy-access-to-remote-virtualization-hosts_assembly_connecting-to-virtual-machines)。 	

**先决条件**

- ​					已[安装](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)并[启动](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_starting-virtual-machines_configuring-and-managing-virtualization)您要与之交互的虚拟机。 			

## 5.1. 使用 web 控制台与虚拟机交互

​				要在 RHEL 9 web 控制台中与虚拟机(VM)交互，您需要连接到虚拟机的控制台。这包括图形和串行控制台。 		

- ​						要在 web 控制台中与虚拟机的图形界面交互，请使用[图形控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-guest-graphical-console-in-the-rhel-web-console_viewing-vm-consoles-using-the-rhel-web-console)。 				
- ​						要在远程 viewer 中与虚拟机的图形界面交互，请使用[remote viewers 中的图形控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-graphical-console-in-remote-viewer_viewing-vm-consoles-using-the-rhel-web-console)。 				
- ​						要在 web 控制台中与虚拟机的 CLI 交互，请使用 [串行控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-serial-console-in-the-rhel-web-console_viewing-vm-consoles-using-the-rhel-web-console)。 				

### 5.1.1. 在 web 控制台中查看虚拟机图形控制台

​					使用虚拟机(VM)控制台界面，您可以在 RHEL 9 web 控制台中查看所选虚拟机的图形输出。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							确保主机和虚拟机支持图形界面。 					

**步骤**

1. ​							在 Virtual Machines 界面中，单击您要查看其图形控制台的虚拟机。 					

   ​							此时将打开一个新页面，其中包含虚拟机的 **Overview** 和 **Console** 部分。 					

2. ​							在控制台下拉菜单中选择 VNC 控制台。 					

   ​							VNC 控制台在 Web 界面中的菜单下方显示。 					

   ​							图形控制台会出现在 web 界面中。 					

   [![显示所选虚拟机的界面的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/105c287e0248bc90ea878b83fc82f12b/virt-cockpit-VM-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/105c287e0248bc90ea878b83fc82f12b/virt-cockpit-VM-details.png)

3. ​							单击 Expand 					

   ​							现在，您可以使用鼠标和键盘与虚拟机控制台进行交互，其方式与您与真实机器进行交互的方式相同。VM 控制台中的显示反映了虚拟机上正在执行的操作。 					

注意

​						运行 web 控制台的主机可能会截获特定的组合键，如 **Ctrl**+**Alt**+**Del**，阻止它们发送到虚拟机。 				

​						要发送此类组合键，请单击 Send key 菜单并选择要发送的键序列。 				

​						例如，要将 **Ctrl**+**Alt**+**Del** 组合发送给虚拟机，请单击 Send key 并选择 Ctrl+Alt+Del 菜单条目。 				

**故障排除**

- ​							如果在图形控制台中点击没有任何效果，请将控制台扩展为全屏显示。这是使用鼠标光标偏移的一个已知问题。 					

**其他资源**

- ​							[使用 Web 控制台在远程 viewer 中查看图形控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-graphical-console-in-remote-viewer_viewing-vm-consoles-using-the-rhel-web-console) 					
- ​							[在 web 控制台中查看虚拟机串口控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-serial-console-in-the-rhel-web-console_viewing-vm-consoles-using-the-rhel-web-console) 					

### 5.1.2. 使用 Web 控制台在远程 viewer 中查看图形控制台

​					使用 web 控制台界面，您可以在远程查看器（如 Virt Viewer）中显示所选虚拟机(VM)的图形控制台。 			

注意

​						您可以在 web 控制台中启动 Virt Viewer。其他 VNC 远程查看器可以被手动启动。 				

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

- ​							确保主机和虚拟机支持图形界面。 					

- ​							在 Virt Viewer 中查看图形控制台前，您必须在 web 控制台连接的机器上安装 Virt Viewer。 					

  1. ​									单击 Launch remote viewer。 							

     ​									`.vv` 文件下载。 							

  2. ​									打开文件以启动 Virt Viewer。 							

注意

​						远程查看器在大多数操作系统上提供。但是，一些浏览器扩展和插件不允许 Web 控制台打开 Virt Viewer。 				

**步骤**

1. ​							在 Virtual Machines 界面中，单击您要查看其图形控制台的虚拟机。 					

   ​							此时将打开一个新页面，其中包含虚拟机的 **Overview** 和 **Console** 部分。 					

2. ​							在控制台下拉菜单中选择 Desktop Viewer。 					

   [![显示虚拟机接口控制台部分以及其他虚拟机详细信息的页面。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b9a4e891fa710095fa5d70c36f010728/virt-cockpit-graphical-console.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b9a4e891fa710095fa5d70c36f010728/virt-cockpit-graphical-console.png)

3. ​							点击 Launch Remote Viewer。 					

   ​							图形控制台在 Virt Viewer 中打开。 					

   [![显示 RHEL 9 虚拟机操作系统桌面的 Virt Viewer 窗口。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a45547a1b2c59caf8d2f64248912d501/virt-cockpit-viewer-GUI.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a45547a1b2c59caf8d2f64248912d501/virt-cockpit-viewer-GUI.png)

   ​							您可以使用鼠标和键盘与虚拟机控制台以与实际机器交互的方式与 VM 控制台进行交互。VM 控制台中的显示反映了虚拟机上正在执行的操作。 					

注意

​						运行 web 控制台的服务器可以截获特定的组合键，如 **Ctrl**+**Alt**+**Del**，阻止它们发送到虚拟机。 				

​						要发送这样的组合键，点 Send key 菜单并选择要使用地键序列。 				

​						例如：要将 **Ctrl**+**Alt**+**Del** 组合发送到 VM，点 Send key 菜单并选择 Ctrl+Alt+Del 菜单。 				

**故障排除**

- ​							如果在图形控制台中点击没有任何效果，请将控制台扩展为全屏显示。这是使用鼠标光标偏移的一个已知问题。 					
- ​							如果在 web 控制台中启动 Remote Viewer 不起作用或者不佳，您可以使用以下协议手动与任何 viewer 应用程序连接： 					
  - ​									**Address** - 默认地址为 `127.0.0.1`。您可以修改 `/etc/libvirt/qemu.conf` 中的 `vnc_listen` 参数，将它更改为主机的 IP 地址。 							
  - ​									**VNC port** - 5901 							

**其他资源**

- ​							[在 web 控制台中查看虚拟机图形控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-guest-graphical-console-in-the-rhel-web-console_viewing-vm-consoles-using-the-rhel-web-console) 					
- ​							[在 web 控制台中查看虚拟机串口控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-serial-console-in-the-rhel-web-console_viewing-vm-consoles-using-the-rhel-web-console) 					

### 5.1.3. 在 web 控制台中查看虚拟机串口控制台

​					您可以在 RHEL 9 web 控制台中查看所选虚拟机(VM)的串行控制台。这在主机机器或者虚拟机没有使用图形界面配置时很有用。 			

​					有关串行控制台的详情，请参考 [第 5.4 节 “打开虚拟机串口控制台”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-serial-console_assembly_connecting-to-virtual-machines)。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 窗格中，单击您要查看其串行控制台的虚拟机。 					

   ​							此时将打开一个新页面，其中包含虚拟机的 **Overview** 和 **Console** 部分。 					

2. ​							在控制台下拉菜单中选择 Serial console。 					

   ​							图形控制台会出现在 web 界面中。 					

   [![显示虚拟机串行控制台以及其他虚拟机详细信息的页面。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/7f90b98fd581d94f18a134d0fc2f03fa/virt-cockpit-serial-console.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/7f90b98fd581d94f18a134d0fc2f03fa/virt-cockpit-serial-console.png)

​					您可以断开串行控制台与虚拟机的连接和重新连接。 			

- ​							要断开串行控制台与虚拟机的连接，请点 Disconnect。 					
- ​							要将串行控制台重新连接到虚拟机，请点 Reconnect。 					

**其他资源**

- ​							[在 web 控制台中查看虚拟机图形控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-guest-graphical-console-in-the-rhel-web-console_viewing-vm-consoles-using-the-rhel-web-console) 					
- ​							[使用 Web 控制台在远程 viewer 中查看图形控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-graphical-console-in-remote-viewer_viewing-vm-consoles-using-the-rhel-web-console) 					

## 5.2. 使用 Virt Viewer 打开虚拟机图形控制台

​				要连接到 KVM 虚拟机(VM)的图形控制台并在 `Virt Viewer` 桌面应用程序中打开它，请按照以下流程操作。 		

**先决条件**

- ​						您的系统以及您要连接的虚拟机必须支持图形显示。 				
- ​						如果目标虚拟机位于远程主机上，则需要对主机有连接和 root 访问权限。 				
- ​						**可选：**如果目标虚拟机位于远程主机上，请设置 libvirt 和 SSH [以更方便地访问远程主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-easy-access-to-remote-virtualization-hosts_assembly_connecting-to-virtual-machines)。 				

**步骤**

- ​						要连接到本地虚拟机，请使用以下命令，并将 *guest-name* 替换为您要连接的虚拟机的名称： 				

  ```none
  # virt-viewer guest-name
  ```

- ​						要连接到远程虚拟机，请使用 `virt-viewer` 命令及 SSH 协议。例如，以下命令以 root 身份连接到位于远程系统 10.0.0.1 的名为 *guest-name* 的虚拟机。此连接还需要为 10.0.0.1 进行 root 身份验证。 				

  ```none
  # virt-viewer --direct --connect qemu+ssh://root@10.0.0.1/system guest-name
  root@10.0.0.1's password:
  ```

**验证**

​					如果连接正常工作，则虚拟机将显示在 `Virt Viewer` 窗口中。 			

[![virt Viewer 显示 RHEL 9 客户机操作系统](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a45547a1b2c59caf8d2f64248912d501/virt-cockpit-viewer-GUI.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a45547a1b2c59caf8d2f64248912d501/virt-cockpit-viewer-GUI.png)

​				您可以使用鼠标和键盘与虚拟机控制台以与实际机器交互的方式与 VM 控制台进行交互。VM 控制台中的显示反映了虚拟机上正在执行的操作。 		

**故障排除**

- ​						如果在图形控制台中点击没有任何效果，请将控制台扩展为全屏显示。这是使用鼠标光标偏移的一个已知问题。 				

**其他资源**

- ​						`virt-viewer` man page 				
- ​						[设置对远程虚拟化主机的简单访问](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-easy-access-to-remote-virtualization-hosts_assembly_connecting-to-virtual-machines) 				
- ​						[使用 web 控制台与虚拟机交互](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-consoles-using-the-rhel-web-console_assembly_connecting-to-virtual-machines) 				

## 5.3. 使用 SSH 连接到虚拟机

​				要使用 SSH 连接协议与虚拟机（VM）终端交互，请遵循以下步骤： 		

**先决条件**

- ​						有对目标虚拟机的网络连接和 root 访问权限。 				

- ​						如果目标虚拟机位于远程主机上，您也可以拥有对该主机的连接和 root 访问权限。 				

- ​						您的虚拟机网络由 `libvirt` 生成的 `dnsmasq` 分配 IP 地址。这是 `libvirt` [NAT 网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-default-configuration_understanding-virtual-networking-overview)中的示例。 				

- ​						在虚拟机主机上已安装并启用了 `libvirt-nss` 组件。如果没有，请执行以下操作： 				

  1. ​								安装 `libvirt-nss` 软件包： 						

     ```none
     # dnf install libvirt-nss
     ```

  2. ​								编辑 `/etc/nsswitch.conf` 文件，并将 `libvirt_guest` 添加到 `hosts` 行中： 						

     ```none
     [...]
     passwd:      compat
     shadow:      compat
     group:       compat
     hosts:       files libvirt_guest dns
     [...]
     ```

**流程**

1. ​						当连接到远程虚拟机时，请首先 SSH 到其物理主机。以下示例演示了使用其 root 凭证连接到主机 10.0.0.1： 				

   ```none
   # ssh root@10.0.0.1
   root@10.0.0.1's password:
   Last login: Mon Sep 24 12:05:36 2021
   root~#
   ```

2. ​						使用虚拟机的名称和用户访问凭证来连接它。例如，以下命令使用其 root 凭证连接到 `testguest1` 虚拟机： 				

   ```none
   # ssh root@testguest1
   root@testguest1's password:
   Last login: Wed Sep 12 12:05:36 2018
   root~]#
   ```

**故障排除**

- ​						如果您不知道虚拟机的名称，可以使用 `virsh list --all` 命令列出主机上所有可用的虚拟机： 				

  ```none
  # virsh list --all
  Id    Name                           State
  ----------------------------------------------------
  2     testguest1                    running
  -     testguest2                    shut off
  ```

**其他资源**

- ​						[上游 libvirt 文档](https://libvirt.org/nss.html) 				

## 5.4. 打开虚拟机串口控制台

​				使用 `virsh console` 命令，可以连接到虚拟机的串行控制台(VM)。 		

​				但虚拟机有以下情况时很有用： 		

- ​						没有提供 VNC 协议，因此没有为 GUI 工具提供视频显示。 				
- ​						没有网络连接，因此无法[使用 SSH](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_connecting-to-a-virtual-machine-using-ssh_assembly_connecting-to-virtual-machines) 进行交互。 				

**先决条件**

- ​						虚拟机必须配置有串口控制台设备，如 `console type='pty'`。要验证，请执行以下操作： 				

  ```none
  # *virsh dumpxml vm-name | grep console
  
  <console type='pty' tty='/dev/pts/2'>
  </console>
  ```

- ​						虚拟机必须在内核命令行中配置串口控制台。要进行验证，VM 上的 `cat /proc/cmdline` 命令输出应包含 *console=ttyS0* 。例如： 				

  ```none
  # cat /proc/cmdline
  BOOT_IMAGE=/vmlinuz-3.10.0-948.el7.x86_64 root=/dev/mapper/rhel-root ro console=tty0 console=ttyS0,9600n8 rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap rhgb
  ```

  ​						如果没有在虚拟机中正确设置串口控制台，请使用 **virsh 控制台**连接到虚拟机，请将您连接到无响应的客户端控制台。然而，您仍然可以使用 **Ctrl+]** 快捷键退出无响应控制台。 				

  - ​								要在虚拟机上设置串行控制台，请执行以下操作： 						

    1. ​										在虚拟机上，编辑 `/etc/default/grub` 文件，并将 **console=ttyS0** 添加到以 **GRUB_CMDLINE_LINUX** 开头的行。 								

    2. ​										清除可能会阻止您更改生效的内核选项。 								

       ```none
       # grub2-editenv - unset kernelopts
       ```

    3. ​										重新载入 Grub 配置： 								

       ```none
       # grub2-mkconfig -o /boot/grub2/grub.cfg
       Generating grub configuration file ...
       Found linux image: /boot/vmlinuz-3.10.0-948.el7.x86_64
       Found initrd image: /boot/initramfs-3.10.0-948.el7.x86_64.img
       [...]
       done
       ```

    4. ​										重启虚拟机。 								

**步骤**

1. ​						在您的主机系统上，使用 `virsh console` 命令。如果 libvirt 驱动程序支持安全控制台处理，以下示例连接到 *guest1* 虚拟机： 				

   ```none
   # virsh console guest1 --safe
   Connected to domain 'guest1'
   Escape character is ^]
   
   Subscription-name
   Kernel 3.10.0-948.el7.x86_64 on an x86_64
   
   localhost login:
   ```

2. ​						您还可以使用与标准命令行界面相同的方法与 virsh 控制台互动。 				

**其他资源**

- ​						`virsh` man page 				

## 5.5. 设置对远程虚拟化主机的简单访问

​				当使用 libvirt 工具在远程主机系统上管理虚拟机时，建议使用 `-c qemu+ssh://root@hostname/system` 语法。例如，要在 10.0.0.1 主机上以 root 用户身份使用 `virsh list` 命令： 		

```none
# virsh -c qemu+ssh://root@10.0.0.1/system list

root@10.0.0.1's password:

Id   Name              State
---------------------------------
1    remote-guest      running
```

​				然而，为方便起见，您可以通过修改 SSH 和 libvirt 配置来完全删除需要指定连接详情。例如，您可以： 		

```none
# virsh -c remote-host list

root@10.0.0.1's password:

Id   Name              State
---------------------------------
1    remote-guest      running
```

​				要进行改进，请按照以下步骤操作。 		

**流程**

1. ​						编辑或创建 `~/.ssh/config` 文件并添加以下内容，其中 *host-alias* 是与特定远程主机关联的短名称，*hosturl* 是主机的 URL 地址： 				

   ```none
   Host host-alias
           User                    root
           Hostname                hosturl
   ```

   ​						例如，下面的命令为 root@10.0.0.1 设置 *tyrannosaurus* 别名： 				

   ```none
   Host tyrannosaurus
           User                    root
           Hostname                10.0.0.1
   ```

2. ​						编辑或创建 `/etc/libvirt/libvirt.conf` 文件，并添加以下内容，其中 *qemu-host-alias* 是 QEMU 和 libvirt 工具将与预期主机关联的主机别名： 				

   ```none
   uri_aliases = [
     "qemu-host-alias=qemu+ssh://host-alias/system",
   ]
   ```

   ​						例如，以下命令使用上一步中配置的 *tyrannosaurus* 别名来设置 *t-rex* 别名，它代表 `qemu+ssh://10.0.0.1/system` ： 				

   ```none
   uri_aliases = [
     "t-rex=qemu+ssh://tyrannosaurus/system",
   ]
   ```

**验证**

1. ​						确认您可以在本地系统上使用添加了 `-c *qemu-host-alias*` 参数的基于 libvirt 的工具来管理远程虚拟机。这会在远程主机中使用 SSH 自动执行命令。 				

   ​						例如，验证以下列出了 10.0.0.1 远程主机上的虚拟机，其连接在前面的步骤中被设置为 *t-rex*： 				

   ```none
   $ virsh -c t-rex list
   
   root@10.0.0.1's password:
   
   Id   Name              State
   ---------------------------------
   1    velociraptor      running
   ```

   注意

   ​							除了 `virsh` 之外，`-c` （或 `--connect`）选项以及上述远程主机访问配置也可以被以下工具使用： 					

   - ​									[virt-install](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-virtual-machines-using-the-command-line-interface_assembly_creating-virtual-machines) 							
   - ​									[virt-viewer](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-graphical-console-using-virt-viewer_assembly_connecting-to-virtual-machines) 							

**后续步骤**

- ​						如果要在单一远程主机中只使用 libvirt 工具，您也可以为基于 libvirt 的实用程序设置特定的连接作为默认目标。为此，请编辑 `/etc/libvirt/libvirt.conf` 文件，并将 `uri_default` 参数的值设为 *qemu-host-alias*。例如：以下命令使用在前面的步骤中设置的 *t-rex* 主机别名作为默认的 libvirt 目标。 				

  ```none
  # These can be used in cases when no URI is supplied by the application
  # (@uri_default also prevents probing of the hypervisor driver).
  #
  uri_default = "t-rex"
  ```

  ​						因此，所有基于 libvirt 的命令都会在指定的远程主机中自动执行。 				

  ```none
  $ virsh list
  root@10.0.0.1's password:
  
  Id   Name              State
  ---------------------------------
  1    velociraptor      running
  ```

  ​						但是，如果您也要管理本地主机或不同远程主机上的虚拟机，则不建议这样做。 				

- ​						当连接到远程主机时，您可以避免向远程系统提供 root 密码。要做到这一点，请使用以下一个或多个方法： 				

  - ​								[设置对远程主机的基于密钥的 SSH 访问](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_basic_system_settings/assembly_using-secure-communications-between-two-systems-with-openssh_configuring-basic-system-settings) 						
  - ​								使用 SSH 连接多路来连接到远程系统 						
  - ​								[身份管理中的 Kerberos 身份验证](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_identity_management/index#kerberos-authentication-in-identity-management_login-web-ui-krb) 						

- ​						`-c` （或 `--connect`）选项可用于在远程主机上运行 [`virt-install`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-virtual-machines-using-the-command-line-interface_assembly_creating-virtual-machines)、[`virt-viewer`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-graphical-console-using-virt-viewer_assembly_connecting-to-virtual-machines) 和 `virsh` 命令。 				

# 第 6 章 关闭虚拟机

​			要关闭 RHEL 9 上托管的正在运行的虚拟机，请使用[命令行界面](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#shutting-down-a-virtual-machine-using-the-command-line-interface_assembly_shutting-down-virtual-machines)或 [web 控制台 GUI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-and-restarting-vms-using-the-rhel-web-console_assembly_shutting-down-virtual-machines)。 	

## 6.1. 使用命令行界面关闭虚拟机

​				要关闭响应的虚拟机（VM），请执行以下操作之一： 		

- ​						在[连接到客户端](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_connecting-to-virtual-machines_configuring-and-managing-virtualization)时，使用适合客户端操作系统的 shutdown 命令。 				

- ​						在主机上使用 `virsh shutdown` 命令： 				

  - ​								如果虚拟机位于本地主机上： 						

    ```none
    # virsh shutdown demo-guest1
    Domain 'demo-guest1' is being shutdown
    ```

  - ​								如果虚拟机位于远程主机上，在本例中为 10.0.0.1: 						

    ```none
    # virsh -c qemu+ssh://root@10.0.0.1/system shutdown demo-guest1
    
    root@10.0.0.1's password:
    Domain 'demo-guest1' is being shutdown
    ```

​				要强制虚拟机关闭（例如，如果其机已变得无响应），请在主机上使用 `virsh destroy` 命令： 		

```none
# virsh destroy demo-guest1
Domain 'demo-guest1' destroyed
```

注意

​					`virsh destroy` 命令实际上不会删除虚拟机配置或磁盘镜像。它只会终止虚拟机的正在运行的虚拟机实例，类似于从物理机拉取电源。因此，在个别情况下，`virsh destroy` 可能会导致虚拟机文件系统崩溃，因此仅在所有其他关闭方法都失败时才建议使用这个命令。 			

## 6.2. 使用 web 控制台关闭和重启虚拟机

​				使用 RHEL 9 web 控制台，您可以 [关闭](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 或 [重启](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#restarting-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 正在运行的虚拟机。您还可以向无响应的虚拟机发送不可屏蔽中断。 		

### 6.2.1. 在 web 控制台中关闭虚拟机

​					如果虚拟机(VM)处于 **running** 状态，您可以使用 RHEL 9 web 控制台关闭它。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，找到您要关闭的虚拟机行。 					

2. ​							在行的右侧，点 Shut Down。 					

   ​							虚拟机关机。 					

**故障排除**

- ​							如果虚拟机没有关闭，请点 Shut Down 按钮旁边的 Menu ⋮ 按钮，然后选择 Force Shut Down。 					
- ​							要关闭无响应虚拟机，您还可以[发送一个不可屏蔽的中断](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sending-NMIs-to-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console)。 					

**其他资源**

- ​							[使用 web 控制台启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines) 					
- ​							[使用 web 控制台重启虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#restarting-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 					

### 6.2.2. 使用 web 控制台重启虚拟机

​					如果虚拟机(VM)处于 **running** 状态，您可以使用 RHEL 9 web 控制台重启它。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，找到您要重启的虚拟机行。 					

2. ​							在行的右侧，点击 Menu 按钮 ⋮。 					

   ​							此时会显示一个操作下拉菜单。 					

3. ​							在下拉菜单中，单击 Reboot。 					

   ​							虚拟机将关机并重启。 					

**故障排除**

- ​							如果虚拟机没有重启，点重启按钮旁边的 Menu ⋮ 按钮，然后选择 Force Restart。 					
- ​							要关闭无响应虚拟机，您还可以[发送一个不可屏蔽的中断](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sending-NMIs-to-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console)。 					

**其他资源**

- ​							[使用 web 控制台启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines) 					
- ​							[在 web 控制台中关闭虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 					

### 6.2.3. 使用 web 控制台向虚拟机发送不可屏蔽中断

​					发送不可屏蔽中断（NMI）可能会导致无响应运行的虚拟机（VM）响应或关闭。例如，您可以将 **Ctrl**+**Alt**+**Del** NMI 发送到不响应标准输入的虚拟机。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，找到您要将 NMI 发送到的虚拟机行。 					

2. ​							在行的右侧，点击 Menu 按钮 ⋮。 					

   ​							此时会显示一个操作下拉菜单。 					

3. ​							在下拉菜单中，点击 Send Non-Maskable Interrupt。 					

   ​							一个 NMI 发送到虚拟机。 					

**其他资源**

- ​							[使用 web 控制台启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines) 					
- ​							[使用 web 控制台重启虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#restarting-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 					
- ​							[在 web 控制台中关闭虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 					

# 第 7 章 删除虚拟机

​			要删除 RHEL 9 中的虚拟机，请使用 [命令行界面](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deleting-virtual-machines-using-cli_assembly_deleting-virtual-machines) 或 [Web 控制台 GUI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deleting-vms-using-the-rhel-web-console_assembly_deleting-virtual-machines)。 	

## 7.1. 使用命令行界面删除虚拟机

​				要删除虚拟机（VM），您可以使用命令行从主机中删除它的 XML 配置和相关存储文件。按照以下步骤操作： 		

**先决条件**

- ​						备份虚拟机中的重要数据。 				
- ​						关闭虚拟机。 				
- ​						确保没有其他虚拟机使用相同的关联的存储。 				

**步骤**

- ​						使用 `virsh undefine` 工具。 				

  ​						例如：以下命令删除 *guest1* 虚拟机、与其关联的存储卷以及非电压 RAM（若有）。 				

  ```none
  # virsh undefine guest1 --remove-all-storage --nvram
  Domain 'guest1' has been undefined
  Volume 'vda'(/home/images/guest1.qcow2) removed.
  ```

**其他资源**

- ​						`virsh undefine --help` 命令 				
- ​						`virsh` man page 				

## 7.2. 使用 web 控制台删除虚拟机

​				要从 RHEL 9 web 控制台连接的主机中删除虚拟机(VM)及其关联的存储文件，请按照以下步骤操作： 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						备份虚拟机中的重要数据。 				
- ​						确保没有其他虚拟机使用相同的关联存储。 				
- ​						**可选：**关闭虚拟机。 				

**步骤**

1. ​						在虚拟机界面中，点击您要删除 的虚拟机的 Menu 按钮 ⋮。 				

   ​						此时会出现一个下拉菜单，控制各种虚拟机操作。 				

   [![显示关闭时可用的虚拟机操作的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/6a6fef34d5fc061d7af5e3e5e79efe53/virt-cockpit-shut-VM-operations.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/6a6fef34d5fc061d7af5e3e5e79efe53/virt-cockpit-shut-VM-operations.png)

2. ​						点击 Delete。 				

   ​						此时会出现确认对话框。 				

   [![显示确认删除虚拟机对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/65a48de5251bb87903bdebcb9de9c521/virt-cockpit-vm-delete-confirm.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/65a48de5251bb87903bdebcb9de9c521/virt-cockpit-vm-delete-confirm.png)

3. ​						**可选：**要删除与虚拟机关联的所有或部分存储文件，请选择您要删除的存储文件旁边的复选框。 				

4. ​						点击 Delete。 				

   ​						虚拟机和任何选择的存储文件都将被删除。 				

# 第 8 章 在 web 控制台中管理虚拟机

​			要在 RHEL 9 主机上的图形界面管理虚拟机，您可以在 RHEL 9 web 控制台中使用 `Virtual Machines` 窗格。 	

[![显示 web 控制台的虚拟机选项卡的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)

## 8.1. 使用 web 控制台管理虚拟机概述

​				RHEL 9 web 控制台是一个用于系统管理的基于 web 的界面。作为其功能之一，Web 控制台提供主机系统中虚拟机（VM）的图形视图，并可创建、访问和配置这些虚拟机。 		

​				请注意，要使用 Web 控制台在 RHEL 9 上管理虚拟机，您必须首先为虚拟化安装 [web 控制台插件](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 		

**后续步骤**

- ​						有关在 web 控制台中启用虚拟机管理的说明，请参阅 [设置 web 控制台来管理虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				

## 8.2. 设置 web 控制台以管理虚拟机

​				在使用 RHEL 9 web 控制台管理虚拟机(VM)之前，您必须在主机上安装 web 控制台虚拟机插件。 		

**先决条件**

- ​						确保机器上安装并启用了 Web 控制台。 				

  ```none
  # systemctl status cockpit.socket
  cockpit.socket - Cockpit Web Service Socket
  Loaded: loaded (/usr/lib/systemd/system/cockpit.socket
  [...]
  ```

  ​						如果这个命令返回 `Unit cockpit.socket could not be found`，请按照[安装 Web 控制台](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9-beta/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_managing-systems-using-the-web-console#installing-the-web-console_getting-started-with-the-rhel-9-web-console)文档启用 Web 控制台。 				

**步骤**

- ​						安装 `cockpit-machines` 插件。 				

  ```none
  # dnf install cockpit-machines
  ```

**验证**

1. ​						访问 Web 控制台，例如在浏览器中输入 `https://localhost:9090` 地址。 				

2. ​						登录。 				

3. ​						如果安装成功，Virtual Machines 会出现在 web 控制台侧菜单中。 				

   [![显示 web 控制台的虚拟机选项卡的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)

**其他资源**

- ​						[使用 RHEL 9 web 控制台管理系统](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_systems_using_the_rhel_9_web_console/getting-started-with-the-rhel-9-web-console_managing-systems-using-the-web-console#connecting-to-the-web-console-from-a-remote-machine_getting-started-with-the-rhel-9-web-console). 				

## 8.3. 使用 web 控制台重命名虚拟机

​				创建虚拟机(VM)后，您可能想要重命名虚拟机以避免冲突，或者根据您的用例分配新的唯一名称。您可以使用 RHEL web 控制台重命名虚拟机。 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						确保虚拟机已关闭。 				

**流程**

1. ​						在 Virtual Machines 界面中，点您要重命名的虚拟机的 Menu 按钮 ⋮。 				

   ​						此时会出现一个下拉菜单，控制各种虚拟机操作。 				

   [![显示关闭时可用的虚拟机操作的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/6a6fef34d5fc061d7af5e3e5e79efe53/virt-cockpit-shut-VM-operations.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/6a6fef34d5fc061d7af5e3e5e79efe53/virt-cockpit-shut-VM-operations.png)

2. ​						点 Rename。 				

   ​						此时会出现 Rename a VM 对话框。 				

   [![显示重命名虚拟机对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/771f1470b3a2af2374ec2d96ccbed15a/virt-cockpit-vm-rename-confirm.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/771f1470b3a2af2374ec2d96ccbed15a/virt-cockpit-vm-rename-confirm.png)

3. ​						在 **New name** 字段中输入虚拟机的名称。 				

4. ​						点 Rename。 				

**验证**

- ​						新虚拟机名称应该出现在 Virtual Machines 界面中。 				

## 8.4. web 控制台中提供的虚拟机管理功能

​				使用 RHEL 9 web 控制台，您可以执行以下操作来管理系统中的虚拟机(VM)。 		

**表 8.1. 您可以在 RHEL 9 web 控制台中执行的虚拟机管理任务**

| 任务                                                 | 详情请查看                                                   |
| ---------------------------------------------------- | ------------------------------------------------------------ |
| 创建虚拟机并将其安装到客户端操作系统                 | [使用 web 控制台创建虚拟机并安装客户端操作系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-vms-and-installing-an-os-using-the-rhel-web-console_assembly_creating-virtual-machines) |
| 删除虚拟机                                           | [使用 web 控制台删除虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deleting-vms-using-the-rhel-web-console_assembly_deleting-virtual-machines) |
| 启动、关闭和重启虚拟机                               | [使用 web 控制台启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_assembly_starting-virtual-machines) 以及[使用 web 控制台关闭和重启虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-and-restarting-vms-using-the-rhel-web-console_assembly_shutting-down-virtual-machines) |
| 使用各种控制台连接到虚拟机并与虚拟机交互             | [使用 web 控制台与虚拟机交互](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-consoles-using-the-rhel-web-console_assembly_connecting-to-virtual-machines) |
| 查看有关虚拟机的各种信息                             | [使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) |
| 调整分配给虚拟机的主机内存                           | [使用 web 控制台添加和删除虚拟机内存](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-machine-ram-using-the-web-console_configuring-virtual-machine-ram) |
| 管理虚拟机的网络连接                                 | [使用 web 控制台管理虚拟机网络接口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machine-network-interfaces-using-the-web-console_configuring-virtual-machine-network-connections) |
| 管理主机上可用的虚拟机存储，并将虚拟磁盘附加到虚拟机 | [使用 web 控制台管理虚拟机的存储](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-storage-for-virtual-machines_configuring-and-managing-virtualization) |
| 配置虚拟机的虚拟 CPU 设置                            | [使用 web 控制台管理 virtal CPU](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-cpus-using-the-web-console_optimizing-virtual-machine-cpu-performance) |
| 实时迁移虚拟机                                       | [使用 web 控制台实时迁移虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_live-migrating-a-virtual-machine-using-the-web-console_migrating-virtual-machines) |
| 管理主机设备                                         | [使用 Web 控制台管理主机设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_managing-virtual-devices-using-the-web-console_managing-virtual-devices) |

# 第 9 章 查看有关虚拟机的信息

​			当您需要在 RHEL 9 上调整或排除虚拟化部署的任何方面时，您需要执行的第一个步骤通常是查看有关虚拟机当前状态和配置的信息。要做到这一点，您可以使用 [命令行界面](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-virtual-machine-information-using-the-command-line-interface_viewing-information-about-virtual-machines) 或 [Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines)。您还可以查看虚拟机 [XML 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sample-virtual-machine-xml-configuration_viewing-information-about-virtual-machines)中的信息。 	

## 9.1. 使用命令行界面查看虚拟机信息

​				要检索主机上虚拟机（VM）的信息，请使用以下一个或多个命令。 		

**流程**

- ​						获取主机上的虚拟机列表： 				

  ```none
  # virsh list --all
  Id   Name              State
  ----------------------------------
  1    testguest1             running
  -    testguest2             shut off
  -    testguest3             shut off
  -    testguest4             shut off
  ```

- ​						要获取有关特定虚拟机的基本信息： 				

  ```none
  # virsh dominfo testguest1
  Id:             1
  Name:           testguest1
  UUID:           a973666f-2f6e-415a-8949-75a7a98569e1
  OS Type:        hvm
  State:          running
  CPU(s):         2
  CPU time:       188.3s
  Max memory:     4194304 KiB
  Used memory:    4194304 KiB
  Persistent:     yes
  Autostart:      disable
  Managed save:   no
  Security model: selinux
  Security DOI:   0
  Security label: system_u:system_r:svirt_t:s0:c486,c538 (enforcing)
  ```

- ​						要获得特定虚拟机的完整 XML 配置： 				

  ```none
  # virsh dumpxml testguest2
  
  <domain type='kvm' id='1'>
    <name>testguest2</name>
    <uuid>a973434f-2f6e-4ěša-8949-76a7a98569e1</uuid>
    <metadata>
  [...]
  ```

- ​						有关虚拟机磁盘和其它块设备的详情： 				

  ```none
  # virsh domblklist testguest3
   Target   Source
  ---------------------------------------------------------------
   vda      /var/lib/libvirt/images/testguest3.qcow2
   sda      -
   sdb      /home/username/Downloads/virt-p2v-1.36.10-1.el7.iso
  ```

- ​						要获取有关虚拟机文件系统及其挂载点的信息： 				

  ```none
  # virsh domfsinfo testguest3
  Mountpoint   Name   Type   Target
  ------------------------------------
   /            dm-0   xfs
   /boot        vda1   xfs
  ```

- ​						要获取有关特定虚拟机 vCPU 的详细信息： 				

  ```none
  # virsh vcpuinfo testguest4
  VCPU:           0
  CPU:            3
  State:          running
  CPU time:       103.1s
  CPU Affinity:   yyyy
  
  VCPU:           1
  CPU:            0
  State:          running
  CPU time:       88.6s
  CPU Affinity:   yyyy
  ```

  ​						要在虚拟机中配置和优化 vCPU，请参阅[优化虚拟机 CPU 性能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-cpu-performance_optimizing-virtual-machine-performance-in-rhel)。 				

- ​						列出主机上的所有虚拟网络接口： 				

  ```none
  # virsh net-list --all
   Name       State    Autostart   Persistent
  ---------------------------------------------
   default    active   yes         yes
   labnet     active   yes         yes
  ```

  ​						有关特定接口的详情： 				

  ```none
  # virsh net-info default
  Name:           default
  UUID:           c699f9f6-9202-4ca8-91d0-6b8cb9024116
  Active:         yes
  Persistent:     yes
  Autostart:      yes
  Bridge:         virbr0
  ```

  ​						有关网络接口、虚拟机网络和配置它们的说明，请参阅[配置虚拟机网络连接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-virtual-machine-network-connections_configuring-and-managing-virtualization)。 				

## 9.2. 使用 web 控制台查看虚拟机信息

​				使用 RHEL 9 web 控制台，您可以查看 web 控制台会话可以访问的所有[虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-state-and-connection-information-in-the-rhel-web-console_viewing-vm-information-using-the-rhel-web-console)和[存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_viewing-vm-information-using-the-rhel-web-console)的信息。 		

​				您可以查看 [web 控制台会话连接到的所选虚拟机的信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-basic-vm-information-in-the-rhel-web-console_viewing-vm-information-using-the-rhel-web-console)。这包括其 [磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-disk-information-in-the-web-console_viewing-vm-information-using-the-rhel-web-console)、[虚拟网络接口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-and-editing-virtual-network-interface-information-in-the-web-console_viewing-vm-information-using-the-rhel-web-console)和[资源使用情况](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-resource-usage-in-the-rhel-web-console_viewing-vm-information-using-the-rhel-web-console) 的信息。 		

### 9.2.1. 在 web 控制台中查看虚拟化概述

​					使用 web 控制台，您可以访问一个虚拟化概述，其中包含有关可用虚拟机(VM)、存储池和网络的总结信息。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

- ​							在 web 控制台侧菜单中点击 Virtual Machines。 					

  ​							此时会出现一个对话框，其中包含有关可用存储池、可用网络和 web 控制台连接的虚拟机的信息。 					

  [![显示 web 控制台的虚拟机选项卡的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddcbcaeac28425e7ec429fb5ed91787/virt-cockpit-main-page.png)

​					该信息包括： 			

- ​							**存储池** - 可通过 web 控制台访问的存储池数（活跃或不活跃）。 					
- ​							**网络** - 可以被 Web 控制台及其状态访问的网络数量（活跃或不活跃）。 					
- ​							**Name** - 虚拟机的名称。 					
- ​							**Connection** - libvirt 连接、系统或者会话的类型。 					
- ​							**State** - 虚拟机的状态。 					

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 9.2.2. 使用 Web 控制台查看存储池信息

​					使用 Web 控制台，您可以查看系统中可用的存储池的详细信息。存储池可用于为您的虚拟机创建磁盘镜像。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							点 Virtual Machines 接口顶部的 Storage Pools。 					

   ​							此时会出现存储池窗口，显示配置的存储池列表。 					

   [![图像显示 web 控制台的存储池标签页，其中包含现有存储池的信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

   ​							该信息包括： 					

   - ​									**名称** - 存储池的名称。 							
   - ​									**大小** - 存储池的当前分配和总容量。 							
   - ​									**connection** - 用于访问存储池的连接。 							
   - ​									**State** - 存储池的状态。 							

2. ​							点击您要查看信息的存储池旁的箭头。 					

   ​							行会展开，以显示包含所选存储池详细信息的 Overview 窗格。 					

   [![镜像显示所选存储池的详细信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)

   ​							该信息包括： 					

   - ​									**目标路径** - 由目录支持的存储池类型的源（如 `dir` 或 `netfs` ）。 							
   - ​									**Persistent** - 指示存储池是否有持久配置。 							
   - ​									**Autostart** - 说明存储池是否在系统引导时自动启动。 							
   - ​									**类型** - 存储池的类型。 							

3. ​							要查看与存储池关联的存储卷列表，请点击 存储卷。 					

   ​							此时会出现 Storage Volumes 窗格，显示配置的存储卷列表。 					

   [![显示与所选存储池关联的存储卷列表的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddf5950143181cdfd03af8fa276d32c/web-console-storage-pool-storage-volumes.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddf5950143181cdfd03af8fa276d32c/web-console-storage-pool-storage-volumes.png)

   ​							该信息包括： 					

   - ​									**名称** - 存储卷的名称。 							
   - ​									**Used by** - 当前使用存储卷的虚拟机。 							
   - ​									**size** - 卷的大小。 							

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 9.2.3. 在 web 控制台中查看基本虚拟机信息

​					使用 web 控制台，您可以查看所选虚拟机(VM)的基本信息，如分配的资源或虚拟机监控程序详情。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 web 控制台侧菜单中点击 Virtual Machines。 					

2. ​							点击您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

   [![显示所选虚拟机的界面的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/105c287e0248bc90ea878b83fc82f12b/virt-cockpit-VM-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/105c287e0248bc90ea878b83fc82f12b/virt-cockpit-VM-details.png)

   ​							Overview 部分包括以下常规虚拟机详情： 					

   - ​									**State** - 虚拟机状态，运行或关闭。 							
   - ​									**内存** - 分配给虚拟机的内存量。 							
   - ​									**vCPU** - 为虚拟机配置的虚拟 CPU 数量。 							
   - ​									**CPU 类型** - 为虚拟机配置的虚拟 CPU 的构架。 							
   - ​									**启动顺序** - 为虚拟机配置的引导顺序。 							
   - ​									**autostart** - 是否为虚拟机启用自动启动。 							

   ​							该信息还包括以下管理程序详情： 					

   - ​									**模拟的机器** - 虚拟机模拟的机器类型。 							
   - ​									**固件** - 虚拟机的固件。 							

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					
- ​							[使用 Web 控制台管理虚拟 CPU](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-cpus-using-the-web-console_optimizing-virtual-machine-cpu-performance) 					

### 9.2.4. 在 web 控制台中查看虚拟机资源使用情况

​					使用 web 控制台，您可以查看所选虚拟机的内存和虚拟 CPU 用量。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动至 Usage。 					

   ​							Usage 部分显示有关虚拟机内存和虚拟 CPU 用量的信息。 					

   ![显示所选虚拟机的内存和 CPU 用量的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/3e6ab23d521fdc4887d2aeb5da789efc/virt-cockpit-resource-usage.png)

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 9.2.5. 在 web 控制台中查看虚拟机磁盘信息

​					 			

​					使用 web 控制台，您可以查看分配给所选虚拟机(VM)的详细信息。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							点击您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 磁盘。 					

   ​							Disks 部分显示分配给虚拟机的磁盘的信息，以及用于 **添加**、**删除** 或**编辑**磁盘的选项。 					

   [![显示所选虚拟机的磁盘用量的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)

​					该信息包括： 			

- ​							**Device** - 该磁盘的设备类型。 					
- ​							**Used** - 当前分配的磁盘数量。 					
- ​							**Capacity** - 存储卷的最大大小。 					
- ​							**Bus** - 模拟的磁盘设备类型。 					
- ​							**Access** - 磁盘为 **Writeable** 或 **Read-only**。对于 `raw` 磁盘，您也可以将访问权限设置为 **Writeable and shared**。 					
- ​							**Source** - 磁盘设备或者文件。 					

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 9.2.6. 在 web 控制台中查看和编辑虚拟网络接口信息

​					使用 RHEL 9 web 控制台，您可以在所选虚拟机(VM)上查看和修改虚拟网络接口： 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 网络接口. 					

   ​							Networks Interfaces 部分显示关于为虚拟机配置的虚拟网络接口的信息，以及用于 **添加**、**删除**、**编辑** 或**拔出**网络接口的选项。 					

   [![显示所选虚拟机的网络接口详细信息的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/986ffadd1eddbd6f7c8f5de0010fe49e/virt-cockpit-vNIC-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/986ffadd1eddbd6f7c8f5de0010fe49e/virt-cockpit-vNIC-info.png)

   ​							+ 该信息包括： 					

   - ​									**类型** - 虚拟机的网络接口类型。类型包括虚拟网络、网桥到 LAN 以及直接附加。 							

     注意

     ​										RHEL 9 及更高版本不支持通用以太网连接。 								

   - ​									**型号类型** - 虚拟网络接口的型号。 							

   - ​									**MAC 地址** - 虚拟网络接口的 MAC 地址。 							

   - ​									**IP 地址** - 虚拟网络接口的 IP 地址。 							

   - ​									**Source** - 网络接口源。这取决于网络类型。 							

   - ​									**State** - 虚拟网络接口的状态。 							

3. ​							要编辑虚拟网络接口设置，请点 Edit。此时会打开「虚拟网络接口设置」对话框。 					

   [![镜像显示可为所选网络接口编辑的各种选项。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/9783ff22db053b2d7939f2dd555695f1/virt-cockpit-edit-network-if.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/9783ff22db053b2d7939f2dd555695f1/virt-cockpit-edit-network-if.png)

4. ​							更改接口类型、源、型号或 MAC 地址。 					

5. ​							点击 Save。已修改网络接口。 					

   注意

   ​								对虚拟网络接口设置的更改仅在重启虚拟机后生效。 						

   ​								另外，只有在虚拟机关闭时，才能修改 MAC 地址。 						

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

## 9.3. 虚拟机 XML 配置示例

​				虚拟机的 XML 配置（也称为 *域 XML* ）决定虚拟机的设置和组件。下表显示了虚拟机（VM）的 XML 配置示例并解释了其内容。 		

​				要获取虚拟机的 XML 配置，您可以使用 `virsh dumpxml` 命令后跟虚拟机的名称。 		

```none
# virsh dumpxml testguest1
```

**表 9.1. XML 配置示例**

| 域 XML 部分                                                  | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `<domain type='kvm'> <name>Testguest1</name> <uuid>ec6fbaa1-3eb4-49da-bf61-bb02fbec4967</uuid> <memory unit='KiB'>1048576</memory> <currentMemory unit='KiB'>1048576</currentMemory>` | 这是一个名为 *Testguest1* 的 KVM 虚拟机，内存为 1024 MiB。   |
| ` <vcpu placement='static'>1</vcpu>`                         | 虚拟机被分配为单个虚拟 CPU（vCPU）。 						 						  							有关配置 vCPU 的详情，请参考[优化虚拟机 CPU 性能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-cpu-performance_optimizing-virtual-machine-performance-in-rhel)。 |
| ` <os>  <type arch='x86_64' machine='pc-q35-rhel9.0.0'>hvm</type>  <boot dev='hd'/> </os>` | 机器构架被设置为 AMD64 和 Intel 64 架构，并使用 Intel Q35 机器类型来决定功能兼容性。将该操作系统设定为从硬盘引导。 						 						  							有关使用安装的操作系统创建虚拟机的详情，请参考[使用 web 控制台创建虚拟机并安装客户机操作系统](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-vms-and-installing-an-os-using-the-rhel-web-console_assembly_creating-virtual-machines)。 |
| ` <features>  <acpi/>  <apic/> </features>`                  | **acpi** 和 **apic** hypervisor 功能被禁用。                 |
| ` <cpu mode='host-model' check='partial'/>`                  | 功能 XML 中的主机 CPU 定义（可通过 `virsh domcapabilities` 可自动复制到虚拟机的 XML 配置中）。因此，当虚拟机引导时，`libvirt` 会选择类似主机 CPU 的 CPU 模型，然后尽可能向大约主机模型添加额外的功能。 |
| ` <clock offset='utc'>  <timer name='rtc' tickpolicy='catchup'/>  <timer name='pit' tickpolicy='delay'/>  <timer name='hpet' present='no'/> </clock>` | VM 的虚拟硬件时钟使用 UTC 时区。另外，设置了三个不同的计时器以便与 QEMU 管理程序同步。 |
| ` <on_poweroff>destroy</on_poweroff> <on_reboot>restart</on_reboot> <on_crash>destroy</on_crash>` | 当虚拟机关闭或者其操作系统意外终止时，`libvirt` 会终止虚拟机并释放其分配的所有资源。当虚拟机重启时，`libvirt` 会使用相同的配置重启它。 |
| ` <pm>  <suspend-to-mem enabled='no'/>  <suspend-to-disk enabled='no'/> </pm>` | 这个虚拟机禁用 S3 和 S4 ACPI 睡眠状态。                      |
| ` <devices>  <emulator>/usr/libexec/qemu-kvm</emulator>  <disk type='file' device='disk'>   <driver name='qemu' type='qcow2'/>   <source file='/var/lib/libvirt/images/Testguest.qcow2'/>   <target dev='vda' bus='virtio'/>  </disk>  <disk type='file' device='cdrom'>   <driver name='qemu' type='raw'/>   <target dev='sdb' bus='sata'/>   <readonly/>  </disk>` | 虚拟机使用 `/usr/libexec/qemu-kvm` 二进制文件模拟，它连接了两个磁盘设备。 						 						  							第一个磁盘是基于主机上存储的 `/var/lib/libvirt/images/Testguest.qcow2` 的虚拟硬盘，其逻辑设备名称设置为 `vda`。在 Windows 虚拟机中，建议您使用 `sata` 总线而不是 `virtio`。 						 						  							第二个磁盘是虚拟化 CD-ROM，其逻辑设备名称被设置为 `sdb`。 |
| `  <controller type='usb' index='0' model='qemu-xhci' ports='15'/>  <controller type='sata' index='0'/>  <controller type='pci' index='0' model='pcie-root'/>  <controller type='pci' index='1' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='1' port='0x10'/>  </controller>  <controller type='pci' index='2' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='2' port='0x11'/>  </controller>  <controller type='pci' index='3' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='3' port='0x12'/>  </controller>  <controller type='pci' index='4' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='4' port='0x13'/>  </controller>  <controller type='pci' index='5' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='5' port='0x14'/>  </controller>  <controller type='pci' index='6' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='6' port='0x15'/>  </controller>  <controller type='pci' index='7' model='pcie-root-port'>   <model name='pcie-root-port'/>   <target chassis='7' port='0x16'/>  </controller>  <controller type='virtio-serial' index='0'/>` | VM 使用单个控制器来附加 USB 设备，而用于 PCI-Express（PCIe）设备的根控制器。另外，提供 `virtio-serial` 控制器，它允许虚拟机以各种方式与主机交互，如串行控制台。 						 						  							有关虚拟设备的更多信息，请参阅[虚拟设备的类型](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#types-of-virtual-devices_managing-virtual-devices)。 |
| ` <interface type='network'>  <mac address='52:54:00:65:29:21'/>  <source network='default'/>  <model type='virtio'/> </interface>` | 在虚拟机中设置了网络接口，它使用 `default` 虚拟网络和 `virtio` 网络设备模型。在 Windows 虚拟机中，建议您使用 `e1000e` 模型而不是 `virtio`。 						 						  							有关配置网络接口的详情，请参考[优化虚拟机网络性能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-network-performance_optimizing-virtual-machine-performance-in-rhel)。 |
| `  <serial type='pty'>   <target type='isa-serial' port='0'>    <model name='isa-serial'/>   </target>  </serial>  <console type='pty'>   <target type='serial' port='0'/>  </console>  <channel type='unix'>   <target type='virtio' name='org.qemu.guest_agent.0'/>   <address type='virtio-serial' controller='0' bus='0' port='1'/>  </channel>` | 在虚拟机上设置了一个 `pty` 串行控制台，它可启用与主机的不便虚拟机通信。控制台使用端口 1 上的 `UNIX` 频道。这个设置是自动设置的，我们不推荐修改这些设置。 						 						  							有关与虚拟机交互的更多信息，请参阅[使用 web 控制台与虚拟机交互](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-consoles-using-the-rhel-web-console_assembly_connecting-to-virtual-machines)。 |
| `  <input type='tablet' bus='usb'>   <address type='usb' bus='0' port='1'/>  </input>  <input type='mouse' bus='ps2'/>  <input type='keyboard' bus='ps2'/>` | 虚拟机使用虚拟 **usb** 端口，该端口设定为接收表格输入，并设置了一个虚拟 **ps2** 端口以接收鼠标和键盘输入。这个设置是自动设置的，我们不推荐修改这些设置。 |
| `  <graphics type='vnc' port='-1' autoport='yes' listen='127.0.0.1'>   <listen type='address' address='127.0.0.1'/>  </graphics>` | 虚拟机使用 `vnc` 协议渲染其图形输出。                        |
| `  <redirdev bus='usb' type='tcp'>   <source mode='connect' host='localhost' service='4000'/>   <protocol type='raw'/>  </redirdev>  <memballoon model='virtio'>   <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>  </memballoon> </devices> </domain>` | 虚拟机使用 `tcp` re-director 远程附加 USB 设备，并启用内存气球功能。这个设置是自动设置的，我们不推荐修改这些设置。 |

# 第 10 章 保存和恢复虚拟机

​			 要释放系统资源，您可以关闭该系统中运行的虚拟机（VM）。然而，当您再次需要虚拟机时，您必须引导客户端操作系统（OS）并重启应用程序，这可能需要大量时间。要减少这个停机时间并让虚拟机工作负载更早开始运行，您可以使用保存和恢复功能来完全避免操作系统关闭和引导序列。 	

​			本节提供有关保存虚拟机的信息，以及在没有完全引导虚拟机的情况下将虚拟机恢复到同一状态的信息。 	

## 10.1. 保存和恢复虚拟机的工作方式

​				保存虚拟机（VM）会将其内存和设备状态保存到主机的磁盘中，并立即停止虚拟机进程。您可以保存处于运行状态或暂停状态的虚拟机，在恢复后，虚拟机将返回到那个状态。 		

​				这个过程释放了主机系统中的 RAM 和 CPU 资源以交换磁盘空间，这样可提高主机系统的性能。当虚拟机被恢复时，因为不需要引导客户机操作系统，也避免使用较长的启动周期。 		

​				要保存虚拟机，您可以使用命令行界面（CLI）。具体步骤请参阅[使用命令行界面保存虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#saving-a-virtual-machines-using-cli_saving-and-restoring-virtual-machines)。 		

​				要恢复虚拟机，您可以使用 [CLI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-a-virtual-machine-using-the-command-line-interface_saving-and-restoring-virtual-machines) 或 [Web 控制台 GUI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_saving-and-restoring-virtual-machines)。 		

## 10.2. 使用命令行界面保存虚拟机

​				您可以将虚拟机(VM)及其当前状态保存到主机的磁盘中。这很有用，例如您需要将主机的资源用于其他目的。然后，保存的虚拟机可以快速恢复到其以前的运行状态。 		

​				要使用命令行保存虚拟机，请按照以下步骤执行。 		

**先决条件**

- ​						确保有足够的磁盘空间来保存虚拟机及其配置。请注意，虚拟机消耗的空间取决于分配给该虚拟机的 RAM 量。 				
- ​						确保虚拟机具有持久性。 				
- ​						**可选：**如果需要，请备份虚拟机中的重要数据。 				

**流程**

- ​						使用 `virsh managedsave` 实用程序。 				

  ​						例如，以下命令可停止 *demo-guest1* 虚拟机并保存其配置。 				

  ```none
  # virsh managedsave demo-guest1
  Domain 'demo-guest1' saved by libvirt
  ```

  ​						保存的虚拟机文件默认位于 **/var/lib/libvirt/qemu/save** 目录中，即 **demo-guest1.save**。 				

  ​						下次[启动](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-a-virtual-machine-using-the-command-line-interface_saving-and-restoring-virtual-machines)虚拟机时，它将自动从上述文件中恢复保存的状态。 				

**验证**

- ​						您可以确保虚拟机处于保存的状态，或使用 `virsh list` 实用程序关闭。 				

  ​						要列出已启用了保存的受管虚拟机，请使用以下命令。列为 *saved* 的虚拟机启用了受管保存。 				

  ```none
  # virsh list --managed-save --all
  Id    Name                           State
  ----------------------------------------------------
  -     demo-guest1                    saved
  -     demo-guest2                    shut off
  ```

  ​						列出具有受管保存镜像的虚拟机： 				

  ```none
  # virsh list --with-managed-save --all
  Id    Name                           State
  ----------------------------------------------------
  -     demo-guest1                    shut off
  ```

  ​						请注意，要列出处于关闭状态的保存的虚拟机，您必须使用 `--all` 或 `--inactive` 选项。 				

**故障排除**

- ​						如果保存的虚拟机文件变得损坏或不可读，恢复虚拟机将启动标准虚拟机引导。 				

**其他资源**

- ​						`virsh managedsave --help` 命令 				
- ​						[使用命令行界面恢复保存的虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-a-virtual-machine-using-the-command-line-interface_saving-and-restoring-virtual-machines) 				
- ​						[使用 Web 控制台恢复保存的虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-up-vms-using-the-rhel-web-console_saving-and-restoring-virtual-machines) 				

## 10.3. 使用命令行界面启动虚拟机

​				您可以使用命令行界面（CLI）来启动关闭的虚拟机(VM)或恢复保存的虚拟机。使用 CLI，您可以启动本地和远程虚拟机。 		

**先决条件**

- ​						已定义的一个不活跃地虚拟机。 				
- ​						虚拟机的名称。 				
- ​						对于远程虚拟机： 				
  - ​								虚拟机所在主机的 IP 地址。 						
  - ​								对主机的 root 访问权限。 						

**步骤**

- ​						对于本地虚拟机，请使用 `virsh start` 工具。 				

  ​						例如，以下命令启动 *demo-guest1* 虚拟机。 				

  ```none
  # virsh start demo-guest1
  Domain 'demo-guest1' started
  ```

- ​						对于位于远程主机上的虚拟机，请使用 `virsh start` 工具以及与主机的 QEMU+SSH 连接。 				

  ​						例如，以下命令在 192.168.123.123 主机上启动 *demo-guest1* 虚拟机。 				

  ```none
  # virsh -c qemu+ssh://root@192.168.123.123/system start demo-guest1
  
  root@192.168.123.123's password:
  
  Domain 'demo-guest1' started
  ```

**其他资源**

- ​						`virsh start --help` 命令 				
- ​						[设置对远程虚拟化主机的简单访问](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-easy-access-to-remote-virtualization-hosts_assembly_connecting-to-virtual-machines) 				
- ​						[当主机启动时自动启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-virtual-machines-automatically-when-the-host-starts_assembly_starting-virtual-machines) 				

## 10.4. 使用 web 控制台启动虚拟机

​				如果虚拟机（VM）处于*关闭*状态，您可以使用 RHEL 9 web 控制台启动它。您还可以将虚拟机配置为在主机启动时自动启动。 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						已定义的一个不活跃地虚拟机。 				
- ​						虚拟机的名称。 				

**步骤**

1. ​						在 Virtual Machines 界面中，点击您要启动的虚拟机。 				

   ​						此时将打开一个新页面，其中包含有关所选虚拟机的详细信息，以及关闭和删除虚拟机的控制。 				

2. ​						点 Run。 				

   ​						虚拟机启动，您可以[连接到其控制台或图形输出](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/assembly_connecting-to-virtual-machines_configuring-and-managing-virtualization)。 				

3. ​						**可选：**要将虚拟机配置为在主机启动时自动启动，请单击 `Autostart` 复选框。 				

   ​						如果使用不由 libvirt 管理的网络接口，您还必须对 systemd 配置进行额外的更改。否则，受影响的虚拟机可能无法启动，请参阅 [当主机启动时自动启动虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-virtual-machines-automatically-when-the-host-starts_assembly_starting-virtual-machines)。 				

**其他资源**

- ​						[在 web 控制台中关闭虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#powering-down-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 				
- ​						[使用 web 控制台重启虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#restarting-vms-using-the-rhel-web-console_powering-down-and-restarting-vms-using-the-rhel-web-console) 				

# 第 11 章 克隆虚拟机

​			要使用特定属性集合快速创建新虚拟机，您可以*克隆*现有虚拟机。 	

​			克隆会创建一个使用其自身磁盘镜像保存存储的新虚拟机，但大多数克隆的配置和源虚拟机的数据都是一样的。这样就可以准备很多虚拟机来满足特定的任务，而无需单独优化每个虚拟机。 	

## 11.1. 克隆虚拟机的方式

​				克隆虚拟机会复制源虚拟机及其磁盘镜像的 XML 配置，并对配置进行修改以确保新虚拟机的唯一性。这包括更改虚拟机的名称，并确保它使用磁盘镜像克隆。存储在克隆的虚拟磁盘上的数据与源虚拟机是一致的。 		

​				这个过程比创建新虚拟机要快，并使用客户端操作系统安装它，并可用于快速生成带有特定配置和内容的虚拟机。 		

​				如果您计划为虚拟机创建多个克隆，首先请创建一个不包含以下内容的虚拟机*模板*： 		

- ​						唯一设置，如持久性网络 MAC 配置，这可阻止克隆正常工作。 				
- ​						敏感数据，如 SSH 密钥和密码文件。 				

​				具体步骤请参阅[创建虚拟机模板](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machine-templates_cloning-virtual-machines)。 		

**其他资源**

- ​						[使用命令行界面克隆虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#cloning-a-virtual-machine-using-the-command-line-interface_cloning-virtual-machines) 				
- ​						[使用 web 控制台克隆虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#cloning-a-virtual-machine-using-the-web-console_cloning-virtual-machines) 				

## 11.2. 创建虚拟机模板

​				要创建可正常工作的多个虚拟机(VM)克隆，您可以删除源虚拟机的唯一信息和配置，如 SSH 密钥或持久性网络 MAC 配置。这会创建一个*虚拟机模板*，供您用来轻松和安全地创建虚拟机克隆。 		

​				您可以使用 [ `virt-sysrep` 实用程序创建虚拟机模板](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#preparing-a-virtual-machine-template_assembly_creating-virtual-machine-templates)，或者根据您的要求[手动创建它们](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_creating-a-virtual-machine-template-manually_assembly_creating-virtual-machine-templates)。 		

### 11.2.1. 使用 virt-sysrep 创建虚拟机模板

​					要从现有虚拟机(VM)创建模板，您可以使用 `virt-sysprep` 实用程序快速取消配置客户机虚拟机以将其做好克隆准备。`virt-sysprep` 实用程序会自动从不应复制到克隆的虚拟机中删除某些配置来创建模板。 			

**先决条件**

- ​							`virt-sysprep` 程序已安装在您的主机上： 					

  ```none
  # dnf install /usr/bin/virt-sysprep
  ```

- ​							用作模板的虚拟机将被关闭。 					

- ​							您必须知道源虚拟机的磁盘镜像位于哪里，并且需要是虚拟机磁盘镜像文件的拥有者。 					

  ​							请注意，在 libvirt [系统连接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#automatic-features-for-virtual-machine-security_securing-virtual-machines-in-rhel) 中创建的虚拟机的磁盘镜像默认位于 `/var/lib/libvirt/images` 目录中，并由 root 用户拥有： 					

  ```none
  # ls -la /var/lib/libvirt/images
  -rw-------.  1 root root  9665380352 Jul 23 14:50 a-really-important-vm.qcow2
  -rw-------.  1 root root  8591507456 Jul 26  2017 an-actual-vm-that-i-use.qcow2
  -rw-------.  1 root root  8591507456 Jul 26  2017 totally-not-a-fake-vm.qcow2
  -rw-------.  1 root root 10739318784 Sep 20 17:57 another-vm-example.qcow2
  ```

- ​							**可选：**VM 磁盘上的任何重要数据都已备份。如果要保留源虚拟机，请首先[克隆](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#cloning-a-virtual-machine-using-the-command-line-interface_cloning-virtual-machines)它，并编辑克隆以创建模板。 					

**流程**

1. ​							确保您已作为虚拟机磁盘镜像的所有者登录： 					

   ```none
   # whoami
   root
   ```

2. ​							**可选：**复制虚拟机的磁盘镜像。 					

   ```none
   # cp /var/lib/libvirt/images/a-really-important-vm.qcow2 /var/lib/libvirt/images/a-really-important-vm-original.qcow2
   ```

   ​							这用于验证虚拟机被成功转换为模板。 					

3. ​							使用以下命令，将 */var/lib/libvirt/images/a-really-important-vm.qcow2* 替换为源虚拟机磁盘镜像的路径。 					

   ```none
   # virt-sysprep -a /var/lib/libvirt/images/a-really-important-vm.qcow2
   [   0.0] Examining the guest ...
   [   7.3] Performing "abrt-data" ...
   [   7.3] Performing "backup-files" ...
   [   9.6] Performing "bash-history" ...
   [   9.6] Performing "blkid-tab" ...
   [...]
   ```

**验证**

- ​							要确认进程成功，请将修改的磁盘镜像与原始镜像进行比较。以下示例显示了成功创建模板： 					

  ```none
  # virt-diff -a /var/lib/libvirt/images/a-really-important-vm-orig.qcow2 -A /var/lib/libvirt/images/a-really-important-vm.qcow2
  - - 0644       1001 /etc/group-
  - - 0000        797 /etc/gshadow-
  = - 0444         33 /etc/machine-id
  [...]
  - - 0600        409 /home/username/.bash_history
  - d 0700          6 /home/username/.ssh
  - - 0600        868 /root/.bash_history
  [...]
  ```

**其他资源**

- ​							`virt-sysprep` man page 中的 **OPERATIONS** 部分 					
- ​							[使用命令行界面克隆虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#cloning-a-virtual-machine-using-the-command-line-interface_cloning-virtual-machines) 					

### 11.2.2. 手动创建虚拟机模板

​					要从现有虚拟机(VM)创建模板，您可以手动重置或取消配置客户机虚拟机，以便为克隆准备它。 			

**先决条件**

- ​							确保您知道源虚拟机的磁盘镜像的位置，并且是虚拟机磁盘镜像文件的所有者。 					

  ​							请注意，在 libvirt [系统连接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#automatic-features-for-virtual-machine-security_securing-virtual-machines-in-rhel) 中创建的虚拟机的磁盘镜像默认位于 `/var/lib/libvirt/images` 目录中，并由 root 用户拥有： 					

  ```none
  # ls -la /var/lib/libvirt/images
  -rw-------.  1 root root  9665380352 Jul 23 14:50 a-really-important-vm.qcow2
  -rw-------.  1 root root  8591507456 Jul 26  2017 an-actual-vm-that-i-use.qcow2
  -rw-------.  1 root root  8591507456 Jul 26  2017 totally-not-a-fake-vm.qcow2
  -rw-------.  1 root root 10739318784 Sep 20 17:57 another-vm-example.qcow2
  ```

- ​							确保虚拟机已关闭。 					

- ​							**可选：**VM 磁盘上的任何重要数据都已备份。如果要保留源虚拟机，请首先[克隆](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#cloning-a-virtual-machine-using-the-command-line-interface_cloning-virtual-machines)它，并编辑克隆以创建模板。 					

**流程**

1. ​							配置虚拟机以进行克隆： 					

   1. ​									在克隆上安装任何软件。 							
   2. ​									为操作系统配置任何非唯一设置。 							
   3. ​									配置任何非唯一应用设置。 							

2. ​							删除网络配置： 					

   1. ​									使用以下命令删除任何持久性 udev 规则： 							

      ```none
      # rm -f /etc/udev/rules.d/70-persistent-net.rules
      ```

      注意

      ​										如果没有删除 udev 规则，则第一个 NIC 的名称可能是 `eth1`，而不是 `eth0`。 								

   2. ​									通过编辑 `/etc/sysconfig/network-scripts/ifcfg-eth[x]` 从 ifcfg 脚本中删除唯一网络详情，如下所示： 							

      1. ​											删除 HWADDR 和 Static 行： 									

         注意

         ​												如果 HWADDR 与新 guest 的 MAC 地址不匹配，则将忽略 `ifcfg`。 										

         ```none
         DEVICE=eth[x] BOOTPROTO=none ONBOOT=yes #NETWORK=10.0.1.0 <- REMOVE #NETMASK=255.255.255.0 <- REMOVE #IPADDR=10.0.1.20 <- REMOVE #HWADDR=xx:xx:xx:xx:xx <- REMOVE #USERCTL=no <- REMOVE # Remove any other *unique or non-desired settings, such as UUID.*
         ```

      2. ​											配置 DHCP，但不包括 HWADDR 或任何其他唯一信息： 									

         ```none
         DEVICE=eth[x] BOOTPROTO=dhcp ONBOOT=yes
         ```

   3. ​									如果您的系统中存在相同的内容，请确保以下文件还包含以下内容： 							

      - ​											`/etc/sysconfig/networking/devices/ifcfg-eth[x]` 									

      - ​											`/etc/sysconfig/networking/profiles/default/ifcfg-eth[x]` 									

        注意

        ​												如果您已在虚拟机中使用 `NetworkManager` 或者任何特殊设置，请确保从 `ifcfg` 脚本中删除任何其他唯一信息。 										

3. ​							删除注册详情： 					

   - ​									对于在 Red Hat Network(RHN)上注册的虚拟机： 							

     ```none
     # rm /etc/sysconfig/rhn/systemid
     ```

   - ​									对于在 Red Hat Subscription Manager(RHSM)中注册的虚拟机： 							

     - ​											如果您不计划使用原始虚拟机： 									

       ```none
       # subscription-manager unsubscribe --all # subscription-manager unregister # subscription-manager clean
       ```

     - ​											如果您计划使用原始虚拟机： 									

       ```none
       # subscription-manager clean
       ```

       注意

       ​												原始 RHSM 配置集以及您的 ID 代码也是如此。在克隆虚拟机后，使用以下命令重新激活您的 RHSM 注册： 										

       ```none
       #subscription-manager register --consumerid=71rd64fx-6216-4409-bf3a-e4b7c7bd8ac9
       ```

4. ​							删除其他唯一详情： 					

   1. ​									删除 ssh 公钥/私钥对： 							

      ```none
      # rm -rf /etc/ssh/ssh_host_example
      ```

   2. ​									删除任何其他应用程序特定标识符或配置，如果在多个机器上运行时可能会导致冲突。 							

5. ​							删除 `gnome-initial-setup-done` 文件，将 VM 配置为在下次引导时运行配置向导： 					

   ```none
   # rm ~/.config/gnome-initial-setup-done
   ```

   注意

   ​								在下次引导时运行的向导取决于从虚拟机中删除的配置。另外，在克隆第一次引导时，建议您更改主机名。 						

## 11.3. 使用命令行界面克隆虚拟机

​				要使用特定属性集（如为测试目的）快速创建新虚拟机，您可以克隆现有的虚拟机。要使用 CLI 完成此操作，请遵循以下步骤。 		

**先决条件**

- ​						源虚拟机被关闭。 				
- ​						确保有足够的磁盘空间来存储克隆的磁盘镜像。 				
- ​						**可选：**在创建多个虚拟机克隆时，从源虚拟机中删除唯一数据和设置，以确保克隆的虚拟机正常工作。具体步骤请参阅[创建虚拟机模板](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machine-templates_cloning-virtual-machines)。 				

**流程**

1. ​						使用 `virt-clone` 实用程序以及适合您的环境和用例的选项。 				

   ​						**使用案例示例** 				

   - ​								以下命令克隆一个名为 *doppelganger* 的本地虚拟机 ，并创建 *doppelganger-clone* 虚拟机。它还在与原始虚拟机磁盘镜像相同的位置，使用相同的数据创建 *doppelganger-clone.qcow2* 磁盘镜像： 						

     ```none
     # virt-clone --original doppelganger --auto-clone
     Allocating 'doppelganger-clone.qcow2'                            | 50.0 GB  00:05:37
     
     Clone 'doppelganger-clone' created successfully.
     ```

   - ​								以下命令克隆一个名为 *geminus1* 的虚拟机，并创建一个名为 *geminus2* 的本地虚拟机，它只使用 *geminus1*的多个磁盘中的两个。 						

     ```none
     # virt-clone --original geminus1 --name geminus2 --file /var/lib/libvirt/images/disk1.qcow2 --file /var/lib/libvirt/images/disk2.qcow2
     Allocating 'disk1-clone.qcow2'                                      | 78.0 GB  00:05:37
     Allocating 'disk2-clone.qcow2'                                      | 80.0 GB  00:05:37
     
     Clone 'geminus2' created successfully.
     ```

   - ​								要将虚拟机克隆到其他主机，请迁移虚拟机而无需在本地主机上取消它。例如，以下命令将之前创建的 *geminus2* 虚拟机克隆到 10.0.0.1 远程系统，包括本地磁盘。请注意，使用这些命令还需要 100.0.1 的 root 权限。 						

     ```none
     # virsh migrate --offline --persistent geminus2 qemu+ssh://root@10.0.0.1/system
     root@10.0.0.1's password:
     
     # scp /var/lib/libvirt/images/disk1-clone.qcow2 root@10.0.0.1/user@remote_host.com://var/lib/libvirt/images/
     
     # scp /var/lib/libvirt/images/disk2-clone.qcow2 root@10.0.0.1/user@remote_host.com://var/lib/libvirt/images/
     ```

**验证**

​					验证虚拟机是否已成功克隆，且正在正常工作： 			

1. ​						确认克隆已添加到主机上的虚拟机列表中。 				

   ```none
   # virsh list --all
   Id   Name                  State
   ---------------------------------------
   -    doppelganger          shut off
   -    doppelganger-clone    shut off
   ```

2. ​						启动克隆并观察它是否引导。 				

   ```none
   # virsh start doppelganger-clone
   Domain 'doppelganger-clone' started
   ```

**其他资源**

- ​						`virt-clone` man page 				
- ​						[迁移虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#migrating-virtual-machines_configuring-and-managing-virtualization) 				

## 11.4. 使用 web 控制台克隆虚拟机

​				要使用特定属性集合快速创建新虚拟机，您可以克隆之前配置的虚拟机。以下说明如何使用 Web 控制台进行此操作。 		

注意

​					克隆虚拟机也会克隆与该虚拟机关联的磁盘。 			

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						确定您要克隆的虚拟机已关闭。 				

**流程**

1. ​						在 web 控制台的 Virtual Machines 界面中，点您要克隆的虚拟机的 Menu 按钮 ⋮。 				

   ​						此时会出现一个下拉菜单，控制各种虚拟机操作。 				

   [![虚拟机主页中显示了虚拟机关闭时可用选项。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/dee64ce022825d7594e946138103836f/virt-cockpit-VM-shutdown-menu.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/dee64ce022825d7594e946138103836f/virt-cockpit-VM-shutdown-menu.png)

2. ​						单击 Clone。 				

   ​						此时会出现 Create a clone VM 对话框。 				

   [![使用选项创建克隆虚拟机对话框，以为虚拟机输入新名称。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b23ad9e8040882ea2ac2b14463dd5d13/virt-cockpit-vm-clone.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b23ad9e8040882ea2ac2b14463dd5d13/virt-cockpit-vm-clone.png)

3. ​						**可选：**输入虚拟机克隆的新名称。 				

4. ​						单击 Clone。 				

   ​						基于源虚拟机创建新虚拟机。 				

**验证**

- ​						确认克隆的虚拟机列表中是否出现在主机上的可用虚拟机列表中。 				

# 第 12 章 迁移虚拟机

​			如果虚拟机所在的当前主机变得不适合或者无法再使用，或者要重新分发托管工作负载，您可以将该虚拟机迁移到另一个 KVM 主机中。 	

## 12.1. 迁移虚拟机的工作方式

​				虚拟机迁移的基本部分是将虚拟机的 XML 配置复制到不同的主机机器中。如果没有关闭迁移的虚拟机，迁移还会将虚拟机内存和任何虚拟设备的状态传送到目标主机机器中。要使虚拟机在目标主机上正常工作，虚拟机的磁盘镜像必须仍可用。 		

​				默认情况下，迁移的虚拟机在目标主机上是临时的，虚拟机在源主机上仍然被定义。 		

​				您可以使用 *实时*或*非实时*迁移对运行的虚拟机进行迁移。要迁移关闭虚拟机，必须使用*离线*迁移。详情请查看下表。 		

**表 12.1. VM 迁移类型**

| 迁移类型       | 描述                                                         | 使用案例                                                     | 存储要求                                                     |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **实时迁移**   | VM 将继续在源主机中运行，而 KVM 会将虚拟机的内存页面传送到目标主机。当迁移接近完成后，KVM 会非常简单地挂起虚拟机，并在目标主机上恢复它。 | 对于需要一直保持运行的虚拟机，这个方法非常有用。但是，如果虚拟机修改内存页面的速度比 KVM 可以传输它们的速度更快，比如 I/O 负载较重的虚拟机，则不能进行实时迁移，这需要使用*非实时迁移*。 | VM 的磁盘镜像必须位于 [共享网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-virtual-machine-disk-images-with-other-hosts_migrating-virtual-machines)中，同时可访问源主机和目标主机。 |
| **非实时迁移** | 挂起虚拟机，将其配置及其内存复制到目标主机，并恢复虚拟机。   | 这个迁移方式需要虚拟机停机，但通常比实时迁移更可靠。建议有高 I/O 负载的虚拟机使用这个方法。 | VM 的磁盘镜像必须位于 [共享网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-virtual-machine-disk-images-with-other-hosts_migrating-virtual-machines)中，同时可访问源主机和目标主机。 |
| **离线迁移**   | 将虚拟机的配置移到目标主机                                   | 建议关闭虚拟机。                                             | VM 的磁盘镜像不必在共享网络中可用，并可手动复制或移动到目标主机。 |

**其他资源**

- ​						[迁移虚拟机的好处](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#benefits-of-migrating-virtual-machines_migrating-virtual-machines) 				
- ​						[将虚拟机磁盘镜像与其他主机共享](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-virtual-machine-disk-images-with-other-hosts_migrating-virtual-machines) 				

## 12.2. 迁移虚拟机的好处

​				迁移虚拟机对以下情况非常有用： 		

- 负载均衡

  ​							如果主机超载或者另一台主机使用不足，则可将虚拟机移动到使用率较低的主机中。 					

- 硬件独立

  ​							当您需要升级、添加或删除主机中的硬件设备时，您可以安全地将虚拟机重新定位到其他主机。这意味着，在改进硬件时虚拟机不需要停机。 					

- 节能

  ​							虚拟机可重新分发到其他主机，因此可关闭未载入的主机系统以便在低用量时节约能源并降低成本。 					

- 地理迁移

  ​							可将虚拟机移动到另一个物理位置，以减少延迟，或者因为其他原因需要。 					

## 12.3. 迁移虚拟机的限制

​				在 RHEL 9 中迁移虚拟机前，请确定您了解迁移的限制。 		

- ​						可以在 RHEL 9 上执行实时存储迁移。但是，只有 Red Hat Virtualization 支持订阅即可获得对实时存储迁移的支持。 				

- ​						将虚拟机迁移到或从 [`libvirt` 会话连接](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#system-and-session-connections_securing-virtual-machines-in-rhel)迁移不可靠，因此不推荐使用。 				

- ​						使用以下功能和配置的虚拟机在迁移时将无法正常工作，或者迁移失败。这些特性包括： 				

  - ​								设备透传 						
  - ​								SR-IOV 设备分配 						
  - ​								介质设备，如 vGPU 						

- ​						只有在主机有类似的拓扑时，使用 Non-Uniform Memory Access(NUMA)固定的主机间迁移才起作用。但是，运行工作负载的性能可能会对迁移造成负面影响。 				

- ​						源虚拟机和目标虚拟机上的模拟 CPU 必须相同，否则迁移可能会失败。以下 CPU 相关区域中的虚拟机间的任何区别可能导致迁移问题： 				

  - ​								CPU 型号 						

    注意

    ​									不支持在 Intel 64 主机和 AMD64 主机间迁移，即使它们共享 x86-64 指令集。 							

  - ​								固件设置 						

  - ​								Microcode 版本 						

  - ​								BIOS 版本 						

  - ​								BIOS 设置 						

  - ​								QEMU 版本 						

  - ​								内核版本 						

- ​						在一些情况下，实时迁移使用超过 1 TB 内存的虚拟机可能无法正常工作。此类迁移的稳定性取决于以下方面： 				

  - ​								虚拟机的当前工作负载 						
  - ​								主机可用于迁移的网络带宽 						
  - ​								部署可以支持的停机时间 						

  ​						对于涉及超过 1 TB 内存的虚拟机的实时迁移场景，客户应咨询红帽。 				

## 12.4. 将虚拟机磁盘镜像与其他主机共享

​				要在 [支持的 KVM 主机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#supported-hosts-for-virtual-machine-migration_migrating-virtual-machines) 间执行虚拟机实时迁移，需要共享虚拟机存储。本节提供将本地存储的虚拟机镜像与源主机以及使用 NFS 协议的目标主机共享的信息。 		

**先决条件**

- ​						旨在迁移的虚拟机被关闭。 				

- ​						**可选：**主机系统可用于托管不是源或目标主机的存储，但源和目标主机都可以通过网络访问它。这是共享存储的最佳解决方案，红帽推荐使用它。 				

- ​						请确定 NFS 文件锁定没有被使用，因为在 KVM 中不支持它。 				

- ​						在源主机和目标主机上安装并启用 NFS。如果没有： 				

  1. ​								安装 NFS 软件包： 						

     ```none
     # dnf install nfs-utils
     ```

  2. ​								确保防火墙中打开了 NFS 的端口，如 2049。 						

     ```none
     # firewall-cmd --permanent --add-service=nfs
     # firewall-cmd --permanent --add-service=mountd
     # firewall-cmd --permanent --add-service=rpc-bind
     # firewall-cmd --permanent --add-port=2049/tcp
     # firewall-cmd --permanent --add-port=2049/udp
     # firewall-cmd --reload
     ```

  3. ​								启动 NFS 服务。 						

     ```none
     # systemctl start nfs-server
     ```

**流程**

1. ​						连接到提供共享存储的主机。在本例中，是 `cargo-bay` 主机： 				

   ```none
   # ssh root@cargo-bay
   root@cargo-bay's password:
   Last login: Mon Sep 24 12:05:36 2019
   root~#
   ```

2. ​						创建存放磁盘镜像的目录，并将与迁移主机共享。 				

   ```none
   # mkdir /var/lib/libvirt/shared-images
   ```

3. ​						将虚拟机的磁盘镜像从源主机复制到新创建的目录。例如，以下命令将 `wander1` 虚拟机的磁盘镜像复制到'cargo-bay' 主机上的 `/var/lib/libvirt/shared-images/` 目录中： 				

   ```none
   # scp /var/lib/libvirt/images/wanderer1.qcow2 root@cargo-bay:/var/lib/libvirt/shared-images/wanderer1.qcow2
   ```

4. ​						在您要用于共享存储的主机上，将共享目录添加到 `/etc/exports` 文件中。以下示例将 `/var/lib/libvirt/shared-images` 目录与 `source-example` 和 `dest-example` 主机共享： 				

   ```none
   /var/lib/libvirt/shared-images source-example(rw,no_root_squash) dest-example(rw,no_root_squash)
   ```

5. ​						在源和目标主机上，将共享目录挂载到 `/var/lib/libvirt/images` 目录中： 				

   ```none
   # mount cargo-bay:/var/lib/libvirt/shared-images /var/lib/libvirt/images
   ```

**验证**

- ​						要验证进程是否成功，在源主机上启动虚拟机并观察它是否正确引导。 				

## 12.5. 使用命令行界面迁移虚拟机

​				如果虚拟机所在的当前主机变得不适合或者无法再使用，或者要重新分发托管工作负载，您可以将该虚拟机迁移到另一个 KVM 主机中。本节介绍了各种迁移情境的信息和示例。 		

**先决条件**

- ​						源主机和目标主机都使用 KVM 管理程序。 				

- ​						源主机和目标主机可以通过网络相互访问。使用 `ping` 程序进行验证。 				

- ​						确保目标主机上打开了以下端口： 				

  - ​								使用 SSH 连接到目标主机需要端口 22。 						
  - ​								使用 TLS 连接到目标主机需要端口 16509。 						
  - ​								使用 TCP 连接到目标主机需要端口 16514。 						
  - ​								QEMU 需要端口 49152-49215 来传输内存和磁盘迁移数据。 						

- ​						要让红帽支持迁移，源主机和目标主机必须使用特定的操作系统和机器类型。要确定这种情况，请参阅 [第 12.7 节 “虚拟机迁移支持的主机”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#supported-hosts-for-virtual-machine-migration_migrating-virtual-machines)。 				

- ​						将虚拟机的磁盘镜像迁移到源主机和目标主机都可以访问的独立联网位置中。这在离线迁移中是可选的，但在迁移运行的虚拟机时是必需的。 				

  ​						有关设置这样的共享虚拟机存储的步骤，请参阅 [第 12.4 节 “将虚拟机磁盘镜像与其他主机共享”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-virtual-machine-disk-images-with-other-hosts_migrating-virtual-machines)。 				

- ​						迁移正在运行的虚拟机时，您的网络带宽必须高于虚拟机生成脏内存页的速度。 				

  ​						要在启动实时迁移前获取虚拟机的脏页面率，请执行以下操作： 				

  1. ​								在一个短的时间段内监控 VM 的脏页面生成速度。 						

     ```none
     # virsh domdirtyrate-calc vm-name 30
     ```

  2. ​								监控完成后，获取其结果： 						

     ```none
     # virsh domstats vm-name --dirtyrate
     Domain: 'vm-name'
       dirtyrate.calc_status=2
       dirtyrate.calc_start_time=200942
       dirtyrate.calc_period=30
       dirtyrate.megabytes_per_second=2
     ```

     ​								在本例中，虚拟机每秒生成 2 MB 脏内存页。如果不暂停虚拟机或降低其工作负载，试图在带有 2 MB/s 或更少的带宽的网络上进行实时迁移会导致实时迁移不会进行。 						

     ​								为确保实时迁移成功完成，红帽建议您的网络带宽明显大于虚拟机的脏页面生成率。 						

- ​						当迁移公共网桥中现有虚拟机时，源和目标主机必须位于同一网络中。否则，迁移后 VM 网络将不会操作。 				

- ​						在执行虚拟机迁移时，源主机上的 `virsh` 客户端可以使用多种协议之一连接到目标主机上的 libvirt 守护进程。以下流程中的示例使用 SSH 连接，但您可以选择不同的连接。 				

  - ​								如果您希望 libvirt 使用 SSH 连接，请确保启用 `virtqemud` 套接字并在目标主机上运行。 						

    ```none
    # systemctl enable --now virtqemud.socket
    ```

  - ​								如果您希望 libvirt 使用 TLS 连接，请确保启用 `virtproxyd-tls` 套接字并在目标主机上运行。 						

    ```none
    # systemctl enable --now virtproxyd-tls.socket
    ```

  - ​								如果您希望 libvirt 使用 TCP 连接，请确保 `virtproxyd-tcp` 套接字已经启用并在目标主机上运行。 						

    ```none
    # systemctl enable --now virtproxyd-tcp.socket
    ```

**步骤**

1. ​						使用 `virsh migrate` 命令以及适合您的迁移要求的选项。 				

   - ​								下面使用 SSH 隧道将 `wanderer1` 虚拟机从本地主机迁移到 `dest-example` 主机的系统连接。虚拟机将在迁移过程中继续运行。 						

     ```none
     # virsh migrate --persistent --live wanderer1 qemu+ssh://dest-example/system
     ```

   - ​								以下操作可让您手动调整本地主机上运行的 `wanderer2` 虚拟机的配置，然后将虚拟机迁移到 `dest-example` 主机。迁移的虚拟机将自动使用更新的配置。 						

     ```none
     # virsh dumpxml --migratable wanderer2 >wanderer2.xml
     # vi wanderer2.xml
     # virsh migrate --live --persistent --xml wanderer2.xml wanderer2 qemu+ssh://dest-example/system
     ```

     ​								当目标主机需要使用不同路径访问共享虚拟机存储或配置特定于目标主机的功能时，这个过程很有用。 						

   - ​								以下命令会从 `source-example` 主机挂起 `wander3` 虚拟机，将其迁移到 `dest-example` 主机，并指示它使用由 `wander3-alt.xml` 文件提供的经过调整的 XML 配置。迁移完成后，`libvirt` 会在目标主机上恢复虚拟机。 						

     ```none
     # virsh migrate wanderer3 qemu+ssh://source-example/system qemu+ssh://dest-example/system --xml wanderer3-alt.xml
     ```

     ​								迁移后，虚拟机在源主机上处于关闭状态，并在关闭后删除迁移的副本。 						

   - ​								以下从 `source-example` 主机中删除已关闭的 `wanderer4` 虚拟机，并将其配置移到 `dest-example` 主机。 						

     ```none
     # virsh migrate --offline --persistent --undefinesource wanderer4 qemu+ssh://source-example/system qemu+ssh://dest-example/system
     ```

     ​								请注意，这种类型的迁移不需要将虚拟机的磁盘镜像移到共享存储中。但是，为了使虚拟机在目标主机上可用，您还需要迁移虚拟机的磁盘镜像。例如： 						

     ```none
     # scp root@source-example:/var/lib/libvirt/images/wanderer4.qcow2 root@dest-example:/var/lib/libvirt/images/wanderer4.qcow2
     ```

2. ​						等待迁移完成。这个过程可能需要一些时间，具体要看网络带宽、系统负载和虚拟机的大小。如果 `virsh migrate` 没有使用 `--verbose` 选项，CLI 不会显示任何进度指示符，除了错误外。 				

   ​						当迁移进行时，您可以使用 `virsh domjobinfo` 实用程序来显示迁移统计信息。 				

**验证**

- ​						在目标主机上，列出可用虚拟机以验证虚拟机是否已迁移： 				

  ```none
  # virsh list
  Id Name                 State
  ----------------------------------
  10 wanderer1              running
  ```

  ​						请注意，如果迁移仍然在运行，这个命令会列出虚拟机状态为 `paused（暂停）`。 				

**故障排除**

- ​						在某些情况下，目标主机与迁移虚拟机 XML 配置的某些值不兼容，比如网络名称或 CPU 类型。因此，虚拟机将无法在目标主机上引导。要修复这些问题，您可以使用 `virsh edit` 命令更新有问题的值。在更新值后，您必须重启虚拟机才能应用更改。 				

- ​						如果实时迁移需要很长时间才能完成，这可能是因为虚拟机负载很重，且有太多的内存页面改变使得实时迁移不可能实现。要解决这个问题，请挂起虚拟机，将迁移改为非实时迁移。 				

  ```none
  # virsh suspend wanderer1
  ```

**其他资源**

- ​						`virsh migrate --help` 命令 				
- ​						`virsh` man page 				

## 12.6. 使用 web 控制台实时迁移虚拟机

​				如果要迁移正在执行需要持续运行的任务的虚拟机(VM)，您可以在不关闭的情况下将该虚拟机迁移到另一个 KVM 主机。这也被称为实时迁移。以下说明如何使用 Web 控制台进行此操作。 		

警告

​					如果任务修改内存页面的速度比 KVM 可以传输的速度快（如重度 I/O 负载任务），建议不要实时迁移虚拟机。 			

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				

- ​						源和目标主机正在运行。 				

- ​						确保目标主机上打开了以下端口： 				

  - ​								使用 SSH 连接到目标主机需要端口 22。 						
  - ​								使用 TLS 连接到目标主机需要端口 16509。 						
  - ​								使用 TCP 连接到目标主机需要端口 16514。 						
  - ​								QEMU 需要端口 49152-49215 来传输内存和磁盘迁移数据。 						

- ​						虚拟机的磁盘镜像位于一个[共享存储](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-virtual-machine-disk-images-with-other-hosts_migrating-virtual-machines)中，该存储可以被源主机以及目标主机访问。 				

- ​						迁移正在运行的虚拟机时，您的网络带宽必须高于虚拟机生成脏内存页的速度。 				

  ​						要在启动实时迁移前获取虚拟机的脏页面率，请在命令行界面中执行以下操作： 				

  1. ​								在一个短的时间段内监控 VM 的脏页面生成速度。 						

     ```none
     # virsh domdirtyrate-calc vm-name 30
     ```

  2. ​								监控完成后，获取其结果： 						

     ```none
     # virsh domstats vm-name --dirtyrate
     Domain: 'vm-name'
       dirtyrate.calc_status=2
       dirtyrate.calc_start_time=200942
       dirtyrate.calc_period=30
       dirtyrate.megabytes_per_second=2
     ```

     ​								在本例中，虚拟机每秒生成 2 MB 脏内存页。如果不暂停虚拟机或降低其工作负载，试图在带有 2 MB/s 或更少的带宽的网络上进行实时迁移会导致实时迁移不会进行。 						

     ​								为确保实时迁移成功完成，红帽建议您的网络带宽明显大于虚拟机的脏页面生成率。 						

**步骤**

1. ​						在 web 控制台的 Virtual Machines 界面中，点您要迁移的虚拟机的 Menu 按钮 ⋮。 				

   ​						此时会出现一个下拉菜单，控制各种虚拟机操作。 				

   [![虚拟机主页中显示虚拟机运行时可用选项。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/91e478e619e8da31d1c80511fb976426/virt-cockpit-VM-running-menu.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/91e478e619e8da31d1c80511fb976426/virt-cockpit-VM-running-menu.png)

2. ​						点 Migrate 				

   ​						此时会出现 Migrate VM to another host 对话框。 				

   [![Migrate VM to another host 对话框，带有字段，输入目标主机的 URI，并设置迁移持续时间。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/759224676d9d914a9cbd76ee8bfd7e78/virt-cockpit-VM-migrate.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/759224676d9d914a9cbd76ee8bfd7e78/virt-cockpit-VM-migrate.png)

3. ​						输入目标主机的 URI。 				

4. ​						配置迁移的持续时间： 				

   - ​								**Permanent** - 如果您想永久迁移虚拟机，请不要选中这个框。永久迁移从源主机完全删除虚拟机配置。 						
   - ​								**Temporary** - 临时迁移将虚拟机副本迁移到目标主机。当虚拟机关闭时，此副本将从目标主机中删除。原始虚拟机保留在源主机上。 						

5. ​						点 Migrate 				

   ​						您的虚拟机将迁移到目标主机。 				

**验证**

​					验证虚拟机是否已成功迁移，且正常工作： 			

- ​						确认虚拟机是否出现在目标主机上可用虚拟机列表中。 				
- ​						启动迁移的虚拟机并观察它是否引导。 				

## 12.7. 虚拟机迁移支持的主机

​				要使虚拟机迁移可以正常工作并被红帽支持，则源和目标主机必须是特定的 RHEL 版本和机器类型。下表显示了支持的虚拟机迁移路径。 		

**表 12.2. 实时迁移兼容性**

| 迁移方法 | 发行类型   | 将来的版本示例 | 支持状态                                    |
| -------- | ---------- | -------------- | ------------------------------------------- |
| 向前     | 次发行版本 | 9.0.1 → 9.1    | 在支持的 RHEL 9 系统上： 机器类型 **q35**。 |
| 向后     | 次发行版本 | 9.1 → 9.0.1    | 在支持的 RHEL 9 系统上： 机器类型 **q35**。 |

注意

​					对于红帽提供的其他虚拟化解决方案，支持级别有所不同，包括 RHOSP 和 OpenShift Virtualization。 			

# 第 13 章 管理虚拟设备

​			管理虚拟机功能、特性和性能的最有效的方法之一是调整其*虚拟设备*。 	

​			以下小节介绍了虚拟设备的[一般信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#how-virtual-devices-work_managing-virtual-devices)，以及如何使用 [CLI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_managing-virtual-devices-using-the-cli_managing-virtual-devices) 或 [Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_managing-virtual-devices-using-the-web-console_managing-virtual-devices)管理它们的说明。 	

## 13.1. 虚拟设备的工作原理

​				与物理计算机一样，虚拟机(VM)要求特殊的设备提供系统的功能，如处理能力、内存、存储、网络或图形。物理系统通常将硬件设备用于这些目的。但是，因为虚拟机作为软件实施，因此需要使用此类设备的软件抽象，而称为 *虚拟设备*。 		

**基础知识**

​					附加到虚拟机的虚拟设备可在[创建虚拟机时](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)配置，也可以在现有虚拟机上管理。通常，只有在虚拟机关闭时，才能从虚拟机附加或分离虚拟设备，但一些可以在虚拟机运行时添加或删除。这个功能被称为设备*热插（hot plug）*和*热拔（hot unplug）*。 			

​				在创建新虚拟机时，`libvirt` 会自动创建和配置默认基本虚拟设备集合，除非用户另有指定。它们基于主机系统架构和机器类型，通常包括： 		

- ​						CPU 				
- ​						内存 				
- ​						键盘 				
- ​						网络接口控制器（NIC） 				
- ​						各种设备控制器 				
- ​						一个视频卡 				
- ​						一个声卡 				

​				要在创建虚拟机后管理虚拟设备，请使用命令行界面(CLI)。但是，要管理虚拟存储设备和 NIC，您还可以使用 RHEL 9 web 控制台。 		

**性能或灵活性**

​					对于某些类型的设备，RHEL 9 支持多种实施，通常具有性能和灵活性之间的利弊。 			

​				例如，用于虚拟磁盘的物理存储可由各种格式（如 `qcow2` 或 `raw` ）的文件表示，并使用各种控制器向虚拟机呈现： 		

- ​						模拟控制器 				
- ​						`virtio-scsi` 				
- ​						`virtio-blk` 				

​				模拟控制器比 `virtio` 控制器慢，因为 `virtio` 设备专为虚拟化目的而设计。另一方面，模拟控制器可以运行没有 `virtio` 设备驱动程序的操作系统。同样，`virtio-scsi` 提供了对 SCSI 命令提供更完整的支持，并可将大量磁盘附加到虚拟机。最后，`virtio-blk` 提供比 `virtio-scsi` 和模拟控制器都更好的性能，但用例的范围有限。例如，在使用 `virtio-blk` 时无法将物理磁盘作为 LUN 设备附加到虚拟机。 		

​				有关虚拟设备类型的详情，请参考 [第 13.2 节 “虚拟设备类型”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#types-of-virtual-devices_managing-virtual-devices)。 		

## 13.2. 虚拟设备类型

​				RHEL 9 中的虚拟化可显示可附加到虚拟机的几种不同类型的虚拟设备： 		

- 模拟设备

  ​							模拟设备是广泛使用的物理设备的软件实现。为物理设备设计的驱动程序还与模拟设备兼容。因此可非常灵活地使用模拟设备。 					 						但是，由于他们需要严格模拟特定类型的硬件，与相应物理设备或更优化的虚拟设备相比，模拟设备的性能损失可能会显著降低。 					 						支持以下模拟设备类型： 					 								虚拟 CPU(vCPU)，有大量可用的 CPU 型号。模拟的性能影响很大程度上取决于主机 CPU 和模拟的 vCPU 之间的区别。 							 								模拟系统组件，如 PCI 总线控制器。 							 								模拟存储控制器，如 SATA、SCSI 甚至 IDE。 							 								模拟声音设备，如 ICH9、ICH6 或 AC97。 							 								模拟图形卡，如 VGA 卡。 							 								模拟网络设备，如 rtl8139。 							

- 半虚拟设备

  ​							半虚拟（Paravirtualization）提供了向虚拟机公开虚拟设备的速度。半虚拟设备公开专用于虚拟机使用的接口，因此可显著提高设备的性能。RHEL 9 为虚拟机提供半虚拟设备，使用 *virtio* API 作为管理程序和虚拟机之间的层。这个方法的缺陷在于它需要在客户端操作系统中使用特定的设备驱动程序。 					 						建议您尽可能为虚拟机使用半虚拟设备而不是模拟设备，特别是当它们运行大量 I/O 的应用程序时。半虚拟设备减少 I/O 延迟并增加 I/O 吞吐量，在某些情况下可使其非常接近裸机性能。其它半虚拟设备还会在不能使用的虚拟机中添加功能。 					 						支持以下半虚拟设备类型： 					 								半虚拟设备(`virtio-net`)。 							 								半虚拟化存储控制器： 							 										`virtio-blk` - 提供块设备模拟。 									 										`virtio-scsi` - 提供更完整的 SCSI 模拟。 									 								半虚拟时钟。 							 								半虚拟串行设备(`virtio-serial`)。 							 								气球（balloon）设备(`virtio-balloon`)用于在虚拟机及其主机之间动态分配内存。 							 								半虚拟随机数字生成器(`virtio-rng`)。 							

- 物理共享设备

  ​							某些硬件平台可让虚拟机直接访问各种硬件设备和组件。这个过程被称为*设备分配*或者*透传（passthrough）*。 					 						以这种方式连接后，物理设备的某些方面可直接供虚拟机使用，因为它们是物理计算机。这为虚拟机中使用的设备提供了出众的性能。但是，物理附加到虚拟机的设备对主机不可用，也不能迁移。 					 						然而，一些设备可以在多个虚拟机间*共享*。例如，一个物理设备在某些情况下可以提供多个*介质设备*，然后将其分配给不同的虚拟机。 					 						支持以下 passthrough 设备类型： 					

- ​						USB、PCI 和 SCSI 透传 - 直接向虚拟机公开通用行业标准总线，以便将其特定功能提供给客户机软件。 				
- ​						单根 I/O 虚拟化(SR-IOV)- 一个规范，允许对 PCI Express 资源进行硬件强制隔离。这使得单个物理 PCI 资源分区成虚拟 PCI 功能更加安全且高效。它通常用于网络接口卡(NIC)。 				
- ​						N_Port ID 虚拟化(NPIV)- 一个光纤通道技术，可与多个虚拟端口共享单一物理主机总线适配器(HBA)。 				
- ​						GPU 和 vGPU - 特定图形或计算工作负载的加速器。有些 GPU 可以直接附加到虚拟机，而某些类型还提供共享底层物理硬件的虚拟 GPU(vGPU)的功能。 				

## 13.3. 使用 CLI 管理附加到虚拟机的设备

​				要修改虚拟机的功能，您可以使用命令行界面(CLI)管理附加到虚拟机的设备。 		

​				您可以使用 CLI： 		

- ​						[附加设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-devices-to-virtual-machines_assembly_managing-virtual-devices-using-the-cli) 				
- ​						[修改设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#modifying-devices-attached-to-virtual-machines_assembly_managing-virtual-devices-using-the-cli) 				
- ​						[删除设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#removing-devices-from-virtual-machines_assembly_managing-virtual-devices-using-the-cli) 				

### 13.3.1. 将设备附加到虚拟机

​					您可以通过附加新虚拟设备来向虚拟机(VM)添加特定功能。 			

​					以下步骤演示了如何使用命令行界面(CLI)创建虚拟机和附加虚拟设备。一些设备也可以使用 [RHEL web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization)附加到虚拟机。 			

​					例如，您可以通过向虚拟机附加新虚拟磁盘设备来增加虚拟机的存储容量。这也被称为**内存热插拔**。 			

警告

​						RHEL 9 不支持从虚拟机中删除内存设备（也称为**内存热拔**）。红帽不建议使用它。 				

**先决条件**

- ​							获取您要附加到虚拟机的设备所需的选项。要查看特定设备的可用选项，请使用 `virt-xml --*device*=?` 命令。例如： 					

  ```none
  # virt-xml --network=?
  --network options:
  [...]
  address.unit
  boot_order
  clearxml
  driver_name
  [...]
  ```

**步骤**

1. ​							要将设备附加到虚拟机，请使用 `virt-xml --add-device` 命令，包括设备的定义和所需选项： 					

   - ​									例如，以下命令在 `/var/lib/libvirt/images/` 目录中创建 20GB *newdisk* qcow2 磁盘镜像，并将其作为虚拟磁盘附加到虚拟机下次启动时运行的 *testguest* 虚拟机： 							

     ```none
     # virt-xml testguest --add-device --disk /var/lib/libvirt/images/newdisk.qcow2,format=qcow2,size=20
     Domain 'testguest' defined successfully.
     Changes will take effect after the domain is fully powered off.
     ```

   - ​									在虚拟机运行时，下面的命令会将一个 USB 盘（在主机的 002 总线中作为设备 004）附加到 *testguest2* 虚拟机： 							

     ```none
     # virt-xml testguest2 --add-device --update --hostdev 002.004
     Device hotplug successful.
     Domain 'testguest2' defined successfully.
     ```

     ​									可以使用 `lsusb` 命令获取用于定义 USB 的 bus-device 组合。 							

**验证**

​						要验证设备已被添加，请执行以下任一操作： 				

- ​							使用 `virsh dumpxml` 命令并查看设备的 XML 定义是否已添加到虚拟机 XML 配置的 `<devices>` 部分。 					

  ​							例如，以下输出显示了 *testguest* 虚拟机的配置，并确认 002.004 USB 闪存磁盘设备已被添加。 					

  ```none
  # virsh dumpxml testguest
  [...]
  <hostdev mode='subsystem' type='usb' managed='yes'>
    <source>
      <vendor id='0x4146'/>
      <product id='0x902e'/>
      <address bus='2' device='4'/>
    </source>
    <alias name='hostdev0'/>
    <address type='usb' bus='0' port='3'/>
  </hostdev>
  [...]
  ```

- ​							运行虚拟机并测试该设备是否存在并正常工作。 					

**其他资源**

- ​							`man virt-xml` 命令 					

### 13.3.2. 修改附加到虚拟机的设备

​					您可以通过编辑附加虚拟设备的配置来更改虚拟机的功能。例如，如果您想要优化虚拟机的性能，您可以更改其虚拟 CPU 型号以更好地与主机的 CPU 匹配。 			

​					以下流程提供了使用命令行界面(CLI)修改虚拟设备的常规说明。附加到虚拟机的一些设备，如磁盘和 NIC，也可以使用 [RHEL 9 web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization)进行修改。 			

**先决条件**

- ​							获取您要附加到虚拟机的设备所需的选项。要查看特定设备的可用选项，请使用 `virt-xml --*device*=?` 命令。例如： 					

```none
# virt-xml --network=?
--network options:
[...]
address.unit
boot_order
clearxml
driver_name
[...]
```

- ​							**可选：**使用 `virsh dumpxml *vm-name*` 将输出发送到文件来备份虚拟机的 XML 配置。例如，以下命令将 *Motoko* 虚拟机的配置备份为 `motoko.xml` 文件： 					

```none
# virsh dumpxml Motoko > motoko.xml
# cat motoko.xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <name>Motoko</name>
  <uuid>ede29304-fe0c-4ca4-abcd-d246481acd18</uuid>
  [...]
</domain>
```

**步骤**

1. ​							使用 `virt-xml --edit` 命令，包括设备的定义和所需选项： 					

   ​							例如，以下可清除关闭的 *testguest* 虚拟机的 *<cpu>* 配置，并将其设置为 *host-model*： 					

   ```none
   # virt-xml testguest --edit --cpu host-model,clearxml=yes
   Domain 'testguest' defined successfully.
   ```

**验证**

​						要校验设备已被修改，请执行以下任一操作： 				

- ​							运行虚拟机并测试该设备是否存在并反映了所做的修改。 					

- ​							使用 `virsh dumpxml` 命令并查看是否在虚拟机 XML 配置中修改了设备的 XML 定义。 					

  ​							例如,以下输出显示了 *testguest* 虚拟机的 配置，并确认 CPU 模式已被配置为 *host-model*。 					

  ```none
  # virsh dumpxml testguest
  [...]
  <cpu mode='host-model' check='partial'>
    <model fallback='allow'/>
  </cpu>
  [...]
  ```

**故障排除**

- ​							如果删除设备导致您的虚拟机无法引导，使用 `virsh define` 工具通过重新载入之前备份的 XML 配置文件来恢复 XML 配置。 					

  ```none
  # virsh define testguest.xml
  ```

注意

​						对于虚拟机的 XML 配置的小更改，您可以使用 `virsh edit` 命令 - 例如 `virsh edit testguest`。但是，不要使用这个方法进行更广泛的更改，因为它可能会以阻止虚拟机引导的方式破坏配置。 				

**其他资源**

- ​							`man virt-xml` 命令 					

### 13.3.3. 从虚拟机中删除设备

​					您可以通过删除虚拟设备来更改虚拟机(VM)的功能。例如，如果不再需要，您可以从其中一个虚拟机中删除虚拟磁盘设备。 			

​					以下步骤演示了如何使用命令行界面(CLI)从虚拟机(VM)中删除虚拟设备。还可 [使用 RHEL 9 web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization)从虚拟机中删除一些设备，如磁盘或 NIC。 			

**先决条件**

- ​							**可选：**使用 `virsh dumpxml *vm-name*` 将输出发送到文件来备份虚拟机的 XML 配置。例如，以下命令将 *Motoko* 虚拟机的配置备份为 `motoko.xml` 文件： 					

```none
# virsh dumpxml Motoko > motoko.xml
# cat motoko.xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <name>Motoko</name>
  <uuid>ede29304-fe0c-4ca4-abcd-d246481acd18</uuid>
  [...]
</domain>
```

**步骤**

1. ​							使用 `virt-xml --remove-device` 命令，包括设备的定义。例如： 					

   - ​									以下会在运行的 *testguest* 虚拟机关闭后，从其中删除标记为 *vdb* 的存储设备： 							

     ```none
     # virt-xml testguest --remove-device --disk target=vdb
     Domain 'testguest' defined successfully.
     Changes will take effect after the domain is fully powered off.
     ```

   - ​									以下命令会立即从运行的 *testguest2* 虚拟机中删除 USB 闪存驱动器设备： 							

     ```none
     # virt-xml testguest2 --remove-device --update --hostdev type=usb
     Device hotunplug successful.
     Domain 'testguest2' defined successfully.
     ```

**故障排除**

- ​							如果删除设备导致您的虚拟机无法引导，使用 `virsh define` 工具通过重新载入之前备份的 XML 配置文件来恢复 XML 配置。 					

  ```none
  # virsh define testguest.xml
  ```

**其他资源**

- ​							`man virt-xml` 命令 					

## 13.4. 使用 Web 控制台管理主机设备

​				要修改虚拟机的功能，您可以使用 Red Hat Enterprise Linux 9 web 控制台管理附加到虚拟机的主机设备。 		

​				主机设备是附加到主机系统的物理设备。根据您的要求，您可以让虚拟机直接访问这些硬件设备和组件。 		

​				您可以使用 Web 控制台： 		

- ​						[查看设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_viewing-devices-attached-to-virtual-machines-using-the-web-console_assembly_managing-virtual-devices-using-the-web-console) 				
- ​						[附加设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_attaching-devices-to-virtual-machines-using-the-web-console_assembly_managing-virtual-devices-using-the-web-console) 				
- ​						[删除设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_removing-devices-from-virtual-machines-using-the-web-console_assembly_managing-virtual-devices-using-the-web-console) 				

### 13.4.1. 使用 web 控制台查看附加到虚拟机的设备

​					在添加或修改附加到虚拟机的设备前，您可能想查看已附加到虚拟机的设备。以下流程提供了使用 Web 控制台查看这些设备的说明。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							此时会打开一个新页面，其中包含有关虚拟机的详细信息。 					

   [![显示虚拟机界面的页面。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/105c287e0248bc90ea878b83fc82f12b/virt-cockpit-VM-details.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/105c287e0248bc90ea878b83fc82f12b/virt-cockpit-VM-details.png)

2. ​							滚动到 **Host devices** 部分。 					

   [![显示虚拟机的主机设备部分的页面。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/692a30076fe07c36ed009d34876ca3e3/virt-cockpit-host-devices.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/692a30076fe07c36ed009d34876ca3e3/virt-cockpit-host-devices.png)

**其他资源**

- ​							[管理虚拟设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-devices_configuring-and-managing-virtualization) 					

### 13.4.2. 使用 web 控制台将设备附加到虚拟机

​					要为虚拟机添加特定的功能，您可以使用 web 控制台将主机设备附加到虚拟机。 			

注意

​						同时附加多个主机设备无法正常工作。一次只能附加一个设备。 				

​						如需更多信息，请参阅 [RHEL 9 已知问题。](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/9.0_release_notes/known-issues#known-issue_virtualization) 				

**先决条件**

- ​							如果您要附加 PCI 设备，请确保 `hostdev` 元素的 `managed` 属性的状态设置为 `yes`。 					

  注意

  ​								将 PCI 设备附加到虚拟机时，请不要省略 `hostdev` 元素的 `managed` 属性，或者将它设置为 `no`。如果您这样做，PCI 设备在传递给虚拟机时无法自动从主机分离。当您关闭虚拟机时，它们也不能自动重新附加到主机。 						

  ​								因此，主机可能会意外变得无响应，或者意外关闭。 						

  ​							您可以在虚拟机 XML 配置中找到 `受管` 属性的状态。以下示例打开 *Ag47* 虚拟机的 XML 配置： 					

  ```none
  # virsh edit Ag47
  ```

- ​							备份虚拟机中的重要数据。 					

- ​							**可选：**备份虚拟机的 XML 配置。例如，备份 `Centurion` 虚拟机： 					

  ```none
  # virsh dumpxml Centurion > Centurion.xml
  ```

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，点您要将主机设备附加到的虚拟机。 					

   ​							这时将打开一个新页面，它带有一个 **Overview** 项，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 **Console** 部分。 					

2. ​							滚动到主机设备部分。 					

   ​							**Host devices** 部分显示有关附加到虚拟机的设备的信息，以及用于**添加**或**删除**设备的选项。 					

   [![显示所选虚拟机的主机设备部分的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/692a30076fe07c36ed009d34876ca3e3/virt-cockpit-host-devices.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/692a30076fe07c36ed009d34876ca3e3/virt-cockpit-host-devices.png)

3. ​							点 Add host device。 					

   ​							此时会出现 **Add host device** 对话框。 					

   [![显示添加主机设备对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/c0205789c58fb59910acc03b2a23394f/virt-cockpit-host-add-device.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/c0205789c58fb59910acc03b2a23394f/virt-cockpit-host-add-device.png)

4. ​							选择您要附加到虚拟机的设备。 					

5. ​							点 添加 					

   ​							所选设备附加到虚拟机。 					

**验证**

- ​							运行虚拟机并检查该设备是否出现在 **Host devices** 部分中。 					

### 13.4.3. 使用 web 控制台从虚拟机中删除设备

​					要释放资源，请修改虚拟机的功能或两者，您可以使用 Web 控制台修改虚拟机并删除不再需要的主机设备。 			

警告

​						使用 Web 控制台删除连接的 USB 主机设备可能会失败，因为 USB 设备的设备和总线号不正确。 				

​						如需更多信息，请参阅 [RHEL 9 已知问题。](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/9.0_release_notes/known-issues#known-issue_virtualization) 				

​						作为临时解决方案，使用 "virsh" 程序从虚拟机的 XML 配置中删除 <hostdev> 的一部分。以下示例打开 *Ag47* 虚拟机的 XML 配置： 				

```none
# virsh edit Ag47
```

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							**可选：**使用 `virsh dumpxml *vm-name*` 将输出发送到文件来备份虚拟机的 XML 配置。例如，以下命令将 *Motoko* 虚拟机的配置备份为 `motoko.xml` 文件： 					

```none
# virsh dumpxml Motoko > motoko.xml
# cat motoko.xml
<domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
  <name>Motoko</name>
  <uuid>ede29304-fe0c-4ca4-abcd-d246481acd18</uuid>
  [...]
</domain>
```

**流程**

1. ​							在 Virtual Machines 接口中，点您要从中删除主机设备的虚拟机。 					

   ​							这时将打开一个新页面，它带有一个 **Overview** 项，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 **Console** 部分。 					

2. ​							滚动到主机设备部分。 					

   ​							**Host devices** 部分显示有关附加到虚拟机的设备的信息，以及用于**添加**或**删除**设备的选项。 					

   [![显示所选虚拟机的主机 dvices 部分的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/692a30076fe07c36ed009d34876ca3e3/virt-cockpit-host-devices.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/692a30076fe07c36ed009d34876ca3e3/virt-cockpit-host-devices.png)

3. ​							点击您要从虚拟机中删除的设备旁边的 删除按钮。 					

   ​							此时会出现删除设备确认对话框。 					

   [![显示用来移除附加虚拟设备的选项。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/08772d0973cf03d2183b5d967ddbccfe/virt-cockpit-host-remove-device.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/08772d0973cf03d2183b5d967ddbccfe/virt-cockpit-host-remove-device.png)

4. ​							单击 Remove。 					

   ​							该设备已从虚拟机中移除。 					

**故障排除**

- ​							如果删除主机设备导致您的虚拟机无法引导，使用 `virsh define` 工具通过重新载入之前备份的 XML 配置文件来恢复 XML 配置。 					

  ```none
  # virsh define motoko.xml
  ```

## 13.5. 管理虚拟 USB 设备

​				在使用虚拟机时，您可以访问和控制 USB 设备，如闪存驱动器或 web 摄像机（附加到主机系统）。在这种情况下，主机系统会将设备的控制权传递给虚拟机。这也被称为 USB-passthrough。 		

​				以下部分提供有关使用命令行的信息： 		

- ​						[将 USB 设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-usb-devices-to-virtual-machines_managing-virtual-usb-devices)附加到虚拟机 				
- ​						从虚拟机中[删除 USB 设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#removing-usb-devices-from-virtual-machines_managing-virtual-usb-devices) 				

### 13.5.1. 将 USB 设备附加到虚拟机

​					要将 USB 设备附加到虚拟机，您可以在虚拟机 XML 配置文件中包含 USB 设备信息。 			

**先决条件**

- ​							确定您要传递给虚拟机的设备已附加到主机。 					

**流程**

1. ​							找到您要附加到虚拟机的 USB 总线和设备值。 					

   ​							例如：以下命令显示附加到该主机的 USB 设备列表。在这个示例中，使用的设备作为设备 005 总线附加到总线 001 中。 					

   ```none
   # lsusb
   [...]
   Bus 001 Device 003: ID 2567:0a2b Intel Corp.
   Bus 001 Device 005: ID 0407:6252 Kingston River 2.0
   [...]
   ```

2. ​							使用 `virt-xml` 实用程序以及 `--add-device` 参数。 					

   ​							例如，以下命令将 USB 闪存驱动器附加到 `Library` 虚拟机。 					

   ```none
   # virt-xml Library --add-device --hostdev 001.005
   Domain 'Library' defined successfully.
   ```

注意

​						要将 USB 设备附加到正在运行的虚拟机中，请在上一个命令中添加 `--update` 参数。 				

**验证**

- ​							运行虚拟机并测试该设备是否存在并正常工作。 					

- ​							使用 `virsh dumpxml` 命令查看设备的 XML 定义是否已添加到虚拟机 XML 配置文件的 <devices> 部分。 					

  ```none
  # virsh dumpxml Library
  [...]
  <hostdev mode='subsystem' type='usb' managed='yes'>
    <source>
      <vendor id='0x0407'/>
      <product id='0x6252'/>
      <address bus='1' device='5'/>
    </source>
    <alias name='hostdev0'/>
    <address type='usb' bus='0' port='3'/>
  </hostdev>
  [...]
  ```

**其他资源**

- ​							`man virt-xml` 命令 					
- ​							[将设备附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-devices-to-virtual-machines_assembly_managing-virtual-devices-using-the-cli) 					

### 13.5.2. 从虚拟机中删除 USB 设备

​					要从虚拟机中删除 USB 设备，您可以从虚拟机 XML 配置中删除 USB 设备信息。 			

**流程**

1. ​							找到您要从虚拟机中删除的 USB 的 bus 和 device 值。 					

   ​							例如：以下命令显示附加到该主机的 USB 设备列表。在这个示例中，使用的设备作为设备 005 总线附加到总线 001 中。 					

   ```none
   # lsusb
   [...]
   Bus 001 Device 003: ID 2567:0a2b Intel Corp.
   Bus 001 Device 005: ID 0407:6252 Kingston River 2.0
   [...]
   ```

2. ​							使用 `virt-xml` 实用程序以及 `--remove-device` 参数。 					

   ​							例如，以下命令从 `Library` 虚拟机中删除作为设备 005 附加到主机总线 001 的 USB 闪存驱动器。 					

   ```none
   # virt-xml Library --remove-device --hostdev 001.005
   Domain 'Library' defined successfully.
   ```

注意

​						要从正在运行的虚拟机中删除 USB 设备，请在上一个命令中添加 `--update` 参数。 				

**验证**

- ​							运行虚拟机并检查该设备是否已从设备列表中删除。 					

**其他资源**

- ​							`man virt-xml` 命令 					
- ​							[将设备附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-devices-to-virtual-machines_assembly_managing-virtual-devices-using-the-cli) 					

## 13.6. 管理虚拟光驱

​				当使用虚拟机时，您可以访问保存在主机中 ISO 镜像中的信息。要做到这一点，请将 ISO 镜像作为虚拟光驱附加到虚拟机，比如 CD 驱动器或者 DVD 驱动器。 		

​				以下部分提供有关使用命令行的信息： 		

- ​						[将驱动器和 ISO 镜像附加](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-optical-drives-to-virtual-machines_managing-virtual-optical-drives)到虚拟机 				
- ​						[替换虚拟光驱中的 ISO 镜像](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#replacing-iso-images-in-virtual-optical-drives_managing-virtual-optical-drives) 				
- ​						从虚拟光驱中[删除 ISO 镜像](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#removing-iso-images-from-virtual-optical-drives_managing-virtual-optical-drives) 				
- ​						从虚拟机中[删除驱动器](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#removing-optical-drives-from-virtual-machines_managing-virtual-optical-drives) 				

### 13.6.1. 为虚拟机附加光驱

​					要将 ISO 镜像作为虚拟光驱附加，请编辑虚拟机的 XML 配置文件并添加新驱动器。 			

**先决条件**

- ​							您必须将 ISO 镜像保存在本地主机中。 					
- ​							您必须知道 ISO 镜像的路径。 					

**步骤**

- ​							使用带有 `--add-device` 参数的 `virt-xml` 实用程序。 					

  ​							例如，以下命令将存储在 `/MC/tank/` 目录中的 `Doc10` ISO 镜像附加到 `DN1` 虚拟机。 					

  ```none
  # virt-xml DN1 --add-device --disk /MC/tank/Doc10.iso,device=cdrom
  Domain 'DN1' defined successfully.
  ```

**验证**

- ​							运行虚拟机并测试该设备是否存在并正常工作。 					

**其他资源**

- ​							`man virt-xml` 命令 					
- ​							[将设备附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-devices-to-virtual-machines_assembly_managing-virtual-devices-using-the-cli) 					

### 13.6.2. 使用虚拟光驱替换 ISO 镜像

​					要替换作为虚拟光驱附加到虚拟机的 ISO 镜像，请编辑虚拟机的 XML 配置文件并指定替换。 			

**先决条件**

- ​							您必须将 ISO 镜像保存在本地主机中。 					
- ​							您必须知道 ISO 镜像的路径。 					

**流程**

1. ​							定位 CD-ROM 附加到虚拟机的目标设备。您可以在虚拟机 XML 配置文件中找到这些信息。 					

   ​							例如，以下命令显示 `DN1` 虚拟机的 XML 配置文件，其中 CD-ROM 的目标设备为 `sda`。 					

   ```none
   # virsh dumpxml DN1
   ...
   <disk>
     ...
     <source file='/MC/tank/Doc10.iso'/>
     <target dev='sda' bus='sata'/>
     ...
   </disk>
   ...
   ```

2. ​							使用 `virt-xml` 实用程序以及 `--edit` 参数。 					

   ​							例如，以下命令可将 `Doc10` ISO 镜像（附加到目标 `sda` 的 `DN1` 虚拟机）替换为保存在 `/Dvrs/current/` 目录中的 `DrDN` ISO 镜像。 					

   ```none
   # virt-xml DN1 --edit target=sda --disk /Dvrs/current/DrDN.iso
   Domain 'DN1' defined successfully.
   ```

**验证**

- ​							运行虚拟机并测试是否替换该设备并正常工作。 					

**其他资源**

- ​							`man virt-xml` 命令 					

### 13.6.3. 从虚拟光驱中删除 ISO 镜像

​					要从附加到虚拟机的虚拟光驱中删除 ISO 镜像，请编辑虚拟机的 XML 配置文件。 			

**流程**

1. ​							定位 CD-ROM 附加到虚拟机的目标设备。您可以在虚拟机 XML 配置文件中找到这些信息。 					

   ​							例如，以下命令显示 `DN1` 虚拟机的 XML 配置文件，其中 CD-ROM 的目标设备为 `sda`。 					

   ```none
   # virsh dumpxml DN1
   ...
   <disk>
     ...
     <source file='/Dvrs/current/DrDN'/>
     <target dev='sda' bus='sata'/>
     ...
   </disk>
   ...
   ```

2. ​							使用 `virt-xml` 实用程序以及 `--edit` 参数。 					

   ​							例如，以下命令会删除附加到 `DN1` 虚拟机的 CD 驱动器中的 `DrDN` ISO 镜像。 					

   ```none
   # virt-xml DN1 --edit target=sda --disk path=
   Domain 'DN1' defined successfully.
   ```

**验证**

- ​							运行虚拟机，检查镜像已不再可用。 					

**其他资源**

- ​							`man virt-xml` 命令 					

### 13.6.4. 从虚拟机中删除光驱

​					要删除附加到虚拟机的光驱，编辑虚拟机的 XML 配置文件。 			

**流程**

1. ​							定位 CD-ROM 附加到虚拟机的目标设备。您可以在虚拟机 XML 配置文件中找到这些信息。 					

   ​							例如，以下命令显示 `DN1` 虚拟机的 XML 配置文件，其中 CD-ROM 的目标设备为 `sda`。 					

   ```none
   # virsh dumpxml DN1
   ...
   <disk type='file' device='cdrom'>
     <driver name='qemu' type='raw'/>
     <target dev='sda' bus='sata'/>
     ...
   </disk>
   ...
   ```

2. ​							使用带有 `--remove-device` 参数的 `virt-xml` 工具。 					

   ​							例如，以下命令从 `DN1` 虚拟机中删除作为目标 `sda` 的光驱。 					

   ```none
   # virt-xml DN1 --remove-device --disk target=sda
   Domain 'DN1' defined successfully.
   ```

**验证**

- ​							确认该设备不再列在虚拟机 XML 配置文件中。 					

**其他资源**

- ​							`man virt-xml` 命令 					

## 13.7. 管理 SR-IOV 设备

​				模拟虚拟设备通常使用比硬件网络设备更多的 CPU 和内存。这可能会限制虚拟机的性能。但是，如果您的虚拟化主机上的任何设备都支持单根 I/O 虚拟化(SR-IOV)，您可以使用此功能提高设备性能，还可能使用虚拟机的整体性能。 		

### 13.7.1. 什么是 SR-IOV?

​					单根 I/O 虚拟化(SR-IOV)是一种规范，它允许单个 PCI Express(PCIe)设备向主机系统呈现多个单独的 PCI 设备，称为 *虚拟功能* (VF)。这样的每个设备： 			

- ​							提供与原始 PCI 设备相同的或类似的服务。 					
- ​							出现在主机 PCI 总线的不同地址上。 					
- ​							可使用 VFIO 分配功能分配到不同的虚拟机。 					

​					例如，单个具有 SR-IOV 的网络设备可以向多个虚拟机显示 VF。虽然所有 VF 都使用相同的物理卡、相同的网络连接和同一网络电缆，每个虚拟机直接控制自己的硬件网络设备，并且不使用来自主机的额外资源。 			

**SR-IOV 的工作原理**

​						SR-IOV 功能可能会因为引进了以下 PCI 功能： 				

- ​							**物理功能(PF)** - 一个 PCIe 功能向主机提供设备的功能（如联网），但也能够创建和管理一组 VF。每个具有 SR-IOV 功能的设备都有一个或多个 PF。 					
- ​							**虚拟功能(VF)** - 充当独立设备的轻量级 PCIe 功能。每个 VF 都是从 PF 中派生的。一个设备可依赖于设备硬件的最大 VF 数。每个 VF 每次只能分配给一个虚拟机，但虚拟机可以分配多个 VF。 					

​					VM 将 VF 识别为虚拟设备。例如，SR-IOV 网络设备创建的 VF 显示为分配的虚拟机的网卡，其方式与物理网卡出现在主机系统一样。 			

**图 13.1. SR-IOV 架构**

[![Virt SR IOV](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/2ca7c118cafe8e2cd184b16620b18393/virt_SR-IOV.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/2ca7c118cafe8e2cd184b16620b18393/virt_SR-IOV.png)

**优点**

​						使用 SR-IOV VF 而不是模拟设备的主要优点是： 				

- ​							提高的性能 					
- ​							减少主机 CPU 和内存资源使用量 					

​					例如，附加到虚拟机作为 vNIC 的 VF 在与物理 NIC 几乎相同级别执行，比半虚拟化或模拟 NIC 更好。特别是，当在单一主机上同时使用多个 VF 时，性能会非常显著。 			

**缺点**

- ​							要修改 PF 的配置，您必须首先将 PF 公开的 VF 数更改为零。因此，您还需要从虚拟机中删除这些 VF 提供的设备。 					
- ​							附加了 VFIO 分配设备的虚拟机（包括 SR-IOV VF）无法迁移到另一台主机。在某些情况下，您可以使用模拟设备对分配的设备进行约束。例如，您可以将分配的网络 VF [绑定](https://access.redhat.com/solutions/67546)到模拟 vNIC，并在迁移前删除 VF。 					
- ​							此外，VFS 分配的设备需要固定虚拟机内存，这会增加虚拟机的内存消耗并防止在虚拟机上使用内存膨胀。 					

**其他资源**

- ​							[SR-IOV 分配支持的设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#supported-devices-for-sr-iov-assignment-in-rhel_managing-sr-iov-devices) 					

### 13.7.2. 将 SR-IOV 网络设备附加到虚拟机

​					要将 SR-IOV 网络设备附加到 Intel 或 AMD 主机上的虚拟机(VM)，您必须从主机上具有 SR-IOV 的网络接口创建一个虚拟功能(VF)，并将 VF 分配为指定虚拟机。详情请查看以下步骤。 			

**先决条件**

- ​							您的主机的 CPU 和固件支持 I/O 内存管理单元(IOMMU)。 					

  - ​									如果使用 Intel CPU，它需要支持 Intel Virtualization Technology for Directed I/O (VT-d)。 							
  - ​									如果使用 AMD CPU，则必须支持 AMD-Vi 功能。 							

- ​							主机系统使用访问控制服务(ACS)为 PCIe 拓扑提供直接内存访问(DMA)隔离。使用系统厂商验证这一点。 					

  ​							如需更多信息，请参阅[实施 SR-IOV 的硬件注意事项](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.0/html/hardware_considerations_for_implementing_sr-iov/index)。 					

- ​							物理网络设备支持 SR-IOV。要验证系统中的任何网络设备是否支持 SR-IOV，请使用 `lspci -v` 命令并在输出中查找 `Single Root I/O Virtualization (SR-IOV)`。 					

  ```none
  # lspci -v
  [...]
  02:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network Connection (rev 01)
  	Subsystem: Intel Corporation Gigabit ET Dual Port Server Adapter
  	Flags: bus master, fast devsel, latency 0, IRQ 16, NUMA node 0
  	Memory at fcba0000 (32-bit, non-prefetchable) [size=128K]
  [...]
  	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
  	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
  	Kernel driver in use: igb
  	Kernel modules: igb
  [...]
  ```

- ​							用于创建 VF 的主机网络接口正在运行。例如：要激活 *eth1* 接口并验证它正在运行： 					

  ```none
  # ip link set eth1 up
  # ip link show eth1
  8: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT qlen 1000
     link/ether a0:36:9f:8f:3f:b8 brd ff:ff:ff:ff:ff:ff
     vf 0 MAC 00:00:00:00:00:00, spoof checking on, link-state auto
     vf 1 MAC 00:00:00:00:00:00, spoof checking on, link-state auto
     vf 2 MAC 00:00:00:00:00:00, spoof checking on, link-state auto
     vf 3 MAC 00:00:00:00:00:00, spoof checking on, link-state auto
  ```

- ​							要使 SR-IOV 设备分配正常工作，必须在主机 BIOS 和内核中启用 IOMMU 功能。要做到这一点： 					

  - ​									在 Intel 主机上启用 VT-d： 							

    - ​											如果您的 Intel 主机使用多个引导条目： 									

      1. ​													编辑 `/etc/default/grub` 文件，并在 *GRUB_CMDLINE_LINUX* 行末尾添加 `intel_iommu=on` 和 `iommu=pt` 参数： 											

         ```bash
         GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rhel_dell-per730-27-swap rd.lvm.lv=rhel_dell-per730-27/root rd.lvm.lv=rhel_dell-per730-27/swap console=ttyS0,115200n81 intel_iommu=on iommu=pt"
         ```

      2. ​													重新生成 GRUB 配置： 											

         ```none
         # grub2-mkconfig -o /boot/grub2/grub.cfg
         ```

      3. ​													重启主机。 											

    - ​											如果您的 Intel 主机使用单个引导条目： 									

      1. ​													使用 `intel_iommu=on iommu=pt` 参数重新生成 GRUB 配置： 											

         ```none
         # grubby --args="intel_iommu=on iommu=pt" --update-kernel DEFAULT
         ```

      2. ​													重启主机。 											

  - ​									在 AMD 主机上启用 AMD-Vi： 							

    - ​											如果您的 AMD 主机使用多个引导条目： 									

      1. ​													编辑 `/etc/default/grub` 文件，并在 *GRUB_CMDLINE_LINUX* 行末尾添加 `iommu=pt` 参数： 											

         ```bash
         GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rhel_dell-per730-27-swap rd.lvm.lv=rhel_dell-per730-27/root rd.lvm.lv=rhel_dell-per730-27/swap console=ttyS0,115200n81 iommu=pt"
         ```

      2. ​													重新生成 GRUB 配置： 											

         ```none
         # grub2-mkconfig -o /boot/grub2/grub.cfg
         ```

      3. ​													重启主机。 											

    - ​											如果您的 AMD 主机使用单个引导条目： 									

      1. ​													使用 `iommu=pt` 参数重新生成 GRUB 配置： 											

         ```none
         # grubby --args="iommu=pt" --update-kernel DEFAULT
         ```

      2. ​													重启主机。 											

**步骤**

1. ​							**可选：**确认您的网络设备可以使用的 VF 的最大数量。要做到这一点，请使用以下命令，将 *eth1* 替换为您的 SR-IOV 兼容网络设备。 					

   ```none
   # cat /sys/class/net/eth1/device/sriov_totalvfs
   7
   ```

2. ​							使用以下命令来创建虚拟功能(VF)： 					

   ```none
   # echo VF-number > /sys/class/net/network-interface/device/sriov_numvfs
   ```

   ​							在命令中，替换： 					

   - ​									使用您要在其上创建 PF 的 VF 数替换 *VF-number*。 							
   - ​									使用 VF 要创建的网络接口的名称替换 *network-interface*。 							

   ​							以下示例从 eth1 网络接口创建 2 个 VF： 					

   ```none
   # echo 2 > /sys/class/net/eth1/device/sriov_numvfs
   ```

3. ​							确定已添加了 VF： 					

   ```none
   # lspci | grep Ethernet
   82:00.0 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
   82:00.1 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
   82:10.0 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function (rev 01)
   82:10.2 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function (rev 01)
   ```

4. ​							通过为创建 VF 的网络接口创建 udev 规则，使创建的 VF 持久。例如，对于 *eth1* 接口，创建 `/etc/udev/rules.d/eth1.rules` 文件，并添加以下行： 					

   ```bash
   ACTION=="add", SUBSYSTEM=="net", ENV{ID_NET_DRIVER}=="ixgbe", ATTR{device/sriov_numvfs}="2"
   ```

   ​							这样可确保在主机启动时，使用 `ixgbe` 驱动程序的两个 VF 将自动用于 `eth1` 接口。如果不需要持久性 SR-IOV 设备，请跳过这一步。 					

   警告

   ​								目前，当试图在 Broadcom NetXtreme II BCM57810 适配器上保留 VF 时，上述设置无法正常工作。另外，基于这些适配器将 VF 附加到 Windows 虚拟机当前还不可靠。 						

5. ​							将新添加的 VF 接口设备热插到正在运行的虚拟机中。 					

   ```none
   # virsh attach-interface testguest1 hostdev 0000:82:10.0 --managed --live --config
   ```

**验证**

- ​							如果这个过程成功，客户端操作系统会检测到一个新的网卡。 					

### 13.7.3. SR-IOV 分配支持的设备

​					并非所有设备都可用于 SR-IOV。在 RHEL 9 中，以下设备已被测试并验证为与 SR-IOV 兼容。 			

**网络设备**

- ​							Intel 82599ES 10 Gigabit Ethernet Controller - 使用 `ixgbe` 驱动程序 					
- ​							Intel Ethernet Controller XL710 系列 - 使用 `i40e` 驱动程序 					
- ​							Mellanox ConnectX-5 以太网适配器卡 - 使用 `mlx5_core` 驱动程序 					
- ​							Intel 以太网网络适配器 XXV710 - 使用 `i40e` 驱动程序 					
- ​							Intel 82576 Gigabit Ethernet Controller - 使用 `igb` 驱动程序 					
- ​							Broadcom NetXtreme II BCM57810 - 使用 `bnx2x` 驱动程序 					

## 13.8. 将 DASD 设备附加到 IBM Z 中的虚拟机

​				使用 `vfio-ccw` 功能，您可以将直接访问存储设备(DASD)作为介质设备分配给 IBM Z 主机上的虚拟机(VM)。例如，虚拟机可以访问 z/OS 数据集，或向 z/OS 机器提供分配的 DASD。 		

**先决条件**

- ​						您的主机系统使用 IBM Z 硬件构架并支持 FICON 协议。 				

- ​						目标虚拟机使用 Linux 客户机操作系统。 				

- ​						已安装 *mdevctl* 软件包。 				

  ```none
  # dnf install mdevctl
  ```

- ​						已安装 *driverctl* 软件包。 				

  ```none
  # dnf install driverctl
  ```

- ​						在主机中载入了必要的内核模块。要验证，请使用： 				

  ```none
  # lsmod | grep vfio
  ```

  ​						输出应包含以下模块： 				

  - ​								`vfio_ccw` 						
  - ​								`vfio_mdev` 						
  - ​								`vfio_iommu_type1` 						

- ​						您有一个备用 DASD 设备供虚拟机独占使用，且您知道设备的标识符。 				

  ​						这个过程使用 `0.0.002c` 作为示例。当执行命令时，将 `0.0.002c` 替换为 DASD 设备的标识符。 				

**步骤**

1. ​						获取 DASD 设备的子通道标识符。 				

   ```none
   # lscss -d 0.0.002c
   Device   Subchan.  DevType CU Type Use  PIM PAM POM  CHPIDs
   ----------------------------------------------------------------------
   0.0.002c 0.0.29a8  3390/0c 3990/e9 yes  f0  f0  ff   02111221 00000000
   ```

   ​						在本例中，子通道标识符被检测到为 `0.0.29a8`。在以下命令中，将 `0.0.29a8` 替换为设备检测到的子频道标识符。 				

2. ​						如果上一步中的 `lscss` 命令仅显示标头输出且没有设备信息，请执行以下步骤： 				

   1. ​								从 `cio_ignore` 列表中删除该设备。 						

      ```none
      # cio_ignore -r 0.0.002c
      ```

   2. ​								在客户机操作系统中，[编辑虚拟机的内核命令行](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-parameters-at-runtime_managing-monitoring-and-updating-the-kernel)，将带有 `!` 标记的设备标识符添加到以 `cio_ignore=` 开头的行（如果它还没有存在）。 						

      ```none
      cio_ignore=all,!condev,!0.0.002c
      ```

   3. ​								在主机上重复第 1 步，以获取子通道标识符。 						

3. ​						将子通道绑定到 `vfio_ccw` passthrough 驱动程序。 				

   ```none
   # driverctl -b css set-override 0.0.29a8 vfio_ccw
   ```

   注意

   ​							这会将 *0.0.29a8* 子频道绑定到 `vfio_ccw`，这意味着 DASD 将无法在主机上使用。如果您需要使用主机上的设备，您必须首先删除到 'vfio_ccw' 的自动绑定，并将子通道重新绑定到默认驱动程序： 					

   ​							**# driverctl -b css unset-override \*0.0.29a8\*** 					

4. ​						生成 UUID。 				

   ```none
   # uuidgen
   30820a6f-b1a5-4503-91ca-0c10ba12345a
   ```

5. ​						使用生成的 UUID 创建 DASD 介质设备。 				

   ```none
   # mdevctl start --uuid 30820a6f-b1a5-4503-91ca-0c10ba12345a --parent 0.0.29a8 --type vfio_ccw-io
   ```

6. ​						使介质设备永久有效。 				

   ```none
   # mdevctl define --auto --uuid 30820a6f-b1a5-4503-91ca-0c10ba12345a
   ```

7. ​						如果虚拟机正在运行，请关闭虚拟机。 				

8. ​						将介质设备附加到虚拟机。为此，请使用 `virsh edit` 实用程序编辑虚拟机的 XML 配置，将以下部分添加到 XML 中，然后将 `uuid` 值替换为您在上一步中生成的 UUID。 				

   ```xml
   <hostdev mode='subsystem' type='mdev' model='vfio-ccw'>
     <source>
       <address uuid="30820a6f-b1a5-4503-91ca-0c10ba12345a"/>
     </source>
   </hostdev>
   ```

**验证**

1. ​						获取 `libvirt` 分配给介质 DASD 设备的标识符。要做到这一点，显示虚拟机的 XML 配置并查找 `vfio-ccw` 设备。 				

   ```none
   # virsh dumpxml vm-name
   
   <domain>
   [...]
       <hostdev mode='subsystem' type='mdev' managed='no' model='vfio-ccw'>
         <source>
           <address uuid='10620d2f-ed4d-437b-8aff-beda461541f9'/>
         </source>
         <alias name='hostdev0'/>
         <address type='ccw' cssid='0xfe' ssid='0x0' devno='0x0009'/>
       </hostdev>
   [...]
   </domain>
   ```

   ​						在本例中，该设备分配的标识符是 `0.0.0009`。 				

2. ​						启动虚拟机并登录到其客户端操作系统。 				

3. ​						在客户端操作系统中，确认 DASD 设备已被列出。例如： 				

   ```none
   # lscss | grep 0.0.0009
   0.0.0009 0.0.0007  3390/0c 3990/e9      f0  f0  ff   12212231 00000000
   ```

4. ​						在客户端操作系统中，在线设置设备。例如： 				

   ```none
   # chccwdev -e 0.0009
   Setting device 0.0.0009 online
   Done
   ```

**其他资源**

- ​						[IBM 的 `cio_ignore` 文档](https://www.ibm.com/docs/en/linux-on-systems?topic=parameters-cio-ignore) 				
- ​						[在运行时配置内核参数](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-parameters-at-runtime_managing-monitoring-and-updating-the-kernel) 				

# 第 14 章 为虚拟机管理存储

​			虚拟机(VM)与物理计算机一样，需要存储数据、程序和系统文件。作为虚拟机管理员，您可以为虚拟机分配物理或基于网络的存储，作为虚拟存储。您还可以修改虚拟机显示存储的方式，无论底层硬件是什么。 	

​			以下小节提供了有关不同类型的虚拟机存储、它们的工作原理，以及如何使用 CLI 或 Web 控制台管理它们。 	

## 14.1. 了解虚拟机存储

​				如果您对于虚拟机(VM)存储的新存储，或者不确定其工作方式，以下小节提供了有关虚拟机存储的各种组件的一般概述、工作方式、管理基础知识以及红帽提供的受支持解决方案。 		

​				您可以找到与以下相关的信息： 		

- ​						[存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#understanding-storage-pools_understanding-virtual-machine-storage) 				
- ​						[存储卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#storage-volumes_understanding-virtual-machine-storage) 				
- ​						[使用 libvirt 管理存储](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#con_storage-management-using-libvirt_understanding-virtual-machine-storage) 				
- ​						[虚拟机存储概述](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#con_overview-of-storage-management_understanding-virtual-machine-storage) 				
- ​						[支持和不支持的存储池类型](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#ref_supported-and-unsupported-storage-pool-types_understanding-virtual-machine-storage) 				

### 14.1.1. 存储池简介

​					存储池是由 `libvirt` 管理的文件、目录或存储设备，用于为虚拟机(VM)提供存储。您可以将存储池分为多个存储卷，用于存储虚拟机镜像或作为额外存储附加到虚拟机。 			

​					此外，多个虚拟机可以共享同一个存储池，从而更好地分配存储资源。 			

- ​							存储池可以是持久的或临时的： 					
  - ​									主机系统重启后，持久性存储池会保留下来。您可以使用 `virsh pool-define` 创建持久性存储池。 							
  - ​									临时存储池仅在主机重启前存在。您可以使用 `virsh pool-create` 命令创建临时存储池。 							

**存储池存储类型**

​						存储池可以是本地的也可以基于网络的（共享）: 				

- ​							**本地存储池** 					

  ​							本地存储池直接附加到主机服务器。它们包括本地设备中的本地目录、直接附加磁盘、物理分区以及逻辑卷管理（LVM）卷组。 					

  ​							本地存储池对不需要迁移或具有大量虚拟机的部署非常有用。 					

- ​							**联网的（共享）存储池** 					

  ​							联网的存储池包括使用标准协议通过网络共享的存储设备。 					

### 14.1.2. 存储卷简介

​					存储池被分为多个`存储卷`。存储卷是物理分区、LVM 逻辑卷、基于文件的磁盘镜像以及 `libvirt` 处理的其他存储类型的抽象。无论底层硬件是什么，存储卷都以本地存储设备（如磁盘）的形式出现在虚拟机中。 			

​					在主机机器中，存储卷的名称由其名称和存储池的标识符来引用。在 `virsh` 命令行上，格式为 `--pool *storage_pool* *volume_name*`。 			

​					例如：要在 *guest_images* 池中显示名为 *firstimage* 的卷信息。 			

```none
# virsh vol-info --pool guest_images firstimage
  Name:             firstimage
  Type:             block
  Capacity:         20.00 GB
  Allocation:       20.00 GB
```

### 14.1.3. 使用 libvirt 进行存储管理

​					使用 `libvirt` 远程协议，您可以管理虚拟机存储的所有方面。这些操作也可以在远程主机上执行。因此，可以使用 `libvirt` （如 RHEL web 控制台）的管理应用程序来执行虚拟机存储所需的所有任务。 			

​					您可以使用 `libvirt` API 查询存储池中的卷列表，或者获取有关该存储池中容量、分配和可用存储的信息。对于支持它的存储池，您还可以使用 `libvirt` API 创建、克隆、调整大小和删除存储卷。另外，您可以使用 `libvirt` API 将数据上传到存储卷，从存储卷下载数据，或者从存储卷中擦除数据。 			

### 14.1.4. 存储管理概述

​					为了说明可用于管理存储的可用选项，以下示例讨论使用 `mount -t nfs nfs.example.com:/path/to/share /path/to/data` 的 NFS 服务器示例。 			

​					作为存储管理员： 			

- ​							您可以在虚拟化主机上定义 NFS 存储池来描述导出的服务器路径和客户端目标路径。因此，`libvirt` 可在 `libvirt` 启动时或者根据需要在 `libvirt` 运行时自动挂载存储。 					

- ​							您只需按名称将存储池和存储卷添加到虚拟机中。您不需要添加目标路径到卷。因此，即使目标客户端路径改变，它不会影响虚拟机。 					

- ​							您可以将存储池配置为 autostart。当您这样做时，` libvirt ` 会在启动 libvirt 时自动挂载 NFS 共享磁盘。`libvirt` 在指定目录中挂载共享，类似于 `挂载 nfs.example.com:/path/to/share /vmdata`。 					

- ​							您可以使用 `libvirt` API 查询存储卷路径。这些存储卷基本上是 NFS 共享磁盘中存在的文件。然后，您可以将这些路径复制到虚拟机 XML 定义的部分，该部分描述了虚拟机块设备的源存储。 					

- ​							如果是 NFS，您可以使用使用 `libvirt` API 的应用程序创建和删除存储池中的存储卷（NFS 共享中的文件）到池大小的限制（共享存储容量）。 					

  ​							请注意，并非所有存储池类型都支持创建和删除卷。 					

- ​							当不再需要时，您可以停止存储池。停止存储池(`pool-destroy`)会撤消启动操作，在这种情况下，卸载 NFS 共享。销毁操作不会修改共享中的数据，即使该命令的名称看似象要删除。如需更多信息，请参阅 `man virsh`。 					

### 14.1.5. 支持和不支持的存储池类型

​					**支持的存储池类型** 			

​					以下是 RHEL 支持的存储池类型列表： 			

- ​							基于目录的存储池 					
- ​							基于磁盘的存储池 					
- ​							基于分区的存储池 					
- ​							基于 iSCSI 的存储池 					
- ​							基于 LVM 的存储池 					
- ​							基于 NFS 的存储池 					
- ​							使用 vHBA 设备基于 SCSI 的存储池 					
- ​							基于多路径的存储池 					
- ​							基于 RBD 的存储池 					

​					**不支持的存储池类型** 			

​					以下是 RHEL 不支持的 `libvirt` 存储池类型列表： 			

- ​							基于 Sheepdog 的存储池 					
- ​							基于 Vstorage 的存储池 					
- ​							基于 ZFS 的存储池 					
- ​							iscsi-direct 存储池 					
- ​							glusterfs 存储池 					

## 14.2. 使用 CLI 管理虚拟机存储池

​				您可以使用 CLI 管理存储池的以下方面来为虚拟机分配存储： 		

- ​						[查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 				
- ​						创建存储池 				
  - ​								[使用 CLI 创建基于目录的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-directory-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
  - ​								[使用 CLI 创建基于磁盘的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-disk-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
  - ​								[使用 CLI 创建基于文件系统的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-filesystem-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
  - ​								[使用 CLI 创建基于 iSCSI 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-iscsi-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
  - ​								[使用 CLI 创建基于 LVM 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-lvm-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
  - ​								[使用 CLI 创建基于 NFS 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-nfs-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
  - ​								[使用 CLI 创建带有 vHBA 设备的基于 SCSI 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-scsi-based-storage-pools-with-vhba-devices-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 						
- ​						[删除存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deleting-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 				

### 14.2.1. 使用 CLI 查看存储池信息

​					使用 CLI，您可以查看所有具有有限或关于存储池的详情的存储池列表。您还可以过滤列出的存储池。 			

**流程**

- ​							使用 `virsh pool-list` 命令查看存储池信息。 					

  ```none
  # virsh pool-list --all --details
   Name                State    Autostart  Persistent    Capacity  Allocation   Available
   default             running  yes        yes          48.97 GiB   23.93 GiB   25.03 GiB
   Downloads           running  yes        yes         175.62 GiB   62.02 GiB  113.60 GiB
   RHEL-Storage-Pool   running  yes        yes         214.62 GiB   93.02 GiB  168.60 GiB
  ```

**其他资源**

- ​							`virsh pool-list --help` 命令 					

### 14.2.2. 使用 CLI 创建基于目录的存储池

​					基于目录的存储池基于现有挂载的文件系统中的目录。这很有用，例如您要使用文件系统上的剩余空间来满足其他目的。您可以使用 `virsh` 实用程序创建基于目录的存储池。 			

**先决条件**

- ​							确定您的管理程序支持目录存储池： 					

  ```none
  # virsh pool-capabilities | grep "'dir' supported='yes'"
  ```

  ​							如果命令显示任何输出结果，则代表支持目录池。 					

**流程**

1. ​							**创建存储池** 					

   ​							使用 `virsh pool-define-as` 命令定义和创建目录类型存储池。例如，要创建一个名为 `guest_images_dir` 的存储池，它使用 **/guest_images** 目录： 					

   ```none
   # virsh pool-define-as guest_images_dir dir --target "/guest_images"
   Pool guest_images_dir defined
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.1 节 “基于目录的存储池参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#directory-based-storage-pool-parameters_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**创建存储池目标路径** 					

   ​							使用 `virsh pool-build` 命令为预格式化的文件系统存储池创建存储池目标路径，初始化存储源设备，然后定义数据的格式。 					

   ```none
   # virsh pool-build guest_images_dir
     Pool guest_images_dir built
   
   # ls -la /guest_images
     total 8
     drwx------.  2 root root 4096 May 31 19:38 .
     dr-xr-xr-x. 25 root root 4096 May 31 19:38 ..
   ```

3. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                 State      Autostart
     -----------------------------------------
     default              active     yes
     guest_images_dir     inactive   no
   ```

4. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_dir
     Pool guest_images_dir started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

5. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_dir
     Pool guest_images_dir marked as autostarted
   ```

**验证**

- ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

  ```none
  # virsh pool-info guest_images_dir
    Name:           guest_images_dir
    UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
    State:          running
    Persistent:     yes
    Autostart:      yes
    Capacity:       458.39 GB
    Allocation:     197.91 MB
    Available:      458.20 GB
  ```

### 14.2.3. 使用 CLI 创建基于磁盘的存储池

​					在基于磁盘的存储池中，池基于磁盘分区。这很有用，例如，当您想让整个磁盘分区专用为虚拟机(VM)存储时。您可以使用 `virsh` 实用程序创建基于磁盘的存储池。 			

**先决条件**

- ​							确定您的管理程序支持基于磁盘的存储池： 					

  ```none
  # virsh pool-capabilities | grep "'disk' supported='yes'"
  ```

  ​							如果命令显示任何输出结果，则代表支持基于磁盘的池。 					

- ​							准备一个用于基础存储池的设备。因此，首选分区（例如 `/dev/sdb1）`或 LVM 卷。如果您提供对整个磁盘或块设备（例如 `/dev/sdb`）的写入访问权限的虚拟机，则虚拟机可能会对其分区或创建自己的 LVM 组。这可能导致主机上的系统错误。 					

  ​							但是，如果您需要将整个块设备用于存储池，红帽建议防止设备中的所有重要分区被 GRUB 的 `os-prober` 功能保护。要做到这一点，请编辑 `/etc/default/grub` 文件并应用以下配置之一： 					

  - ​									禁用 `os-prober`。 							

    ```none
    GRUB_DISABLE_OS_PROBER=true
    ```

  - ​									防止 `os-prober` 发现特定分区。例如： 							

    ```none
    GRUB_OS_PROBER_SKIP_LIST="5ef6313a-257c-4d43@/dev/sdb1"
    ```

- ​							创建存储池前备份所选存储设备中的任何数据。根据所使用的 `libvirt` 版本，在存储池中指定一个磁盘可能会重新格式化并清除当前存储在磁盘设备上的所有数据。 					

**流程**

1. ​							**创建存储池** 					

   ​							使用 `virsh pool-define-as` 命令定义和创建磁盘类型存储池。以下示例创建一个名为 `guest_images_disk` 的存储池，它使用 **/dev/sdb** 设备并挂载到 /dev 目录。 					

   ```none
   # virsh pool-define-as guest_images_disk disk --source-format=gpt --source-dev=/dev/sdb --target /dev
   Pool guest_images_disk defined
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.2 节 “基于磁盘的存储池参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#disk-based-storage-pool-parameters_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**创建存储池目标路径** 					

   ​							使用 `virsh pool-build` 命令为预格式化的文件系统存储池创建存储池目标路径，初始化存储源设备，然后定义数据的格式。 					

   ```none
   # virsh pool-build guest_images_disk
     Pool guest_images_disk built
   ```

   注意

   ​								构建目标路径只适用于基于磁盘、基于文件系统的逻辑存储池。如果 `libvirt` 检测到源存储设备的数据格式与所选存储池类型不同，则构建将失败，除非指定了 `*覆盖*` 选项。 						

3. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                 State      Autostart
     -----------------------------------------
     default              active     yes
     guest_images_disk    inactive   no
   ```

4. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_disk
     Pool guest_images_disk started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

5. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_disk
     Pool guest_images_disk marked as autostarted
   ```

**验证**

- ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

  ```none
  # virsh pool-info guest_images_disk
    Name:           guest_images_disk
    UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
    State:          running
    Persistent:     yes
    Autostart:      yes
    Capacity:       458.39 GB
    Allocation:     197.91 MB
    Available:      458.20 GB
  ```

### 14.2.4. 使用 CLI 创建基于文件系统的存储池

​					当您想在未挂载的文件系统中创建存储池时，请使用基于文件系统的存储池。这个存储池基于给定的文件系统挂载点。您可以使用 `virsh` 实用程序创建基于文件系统的存储池。 			

**先决条件**

- ​							确保您的管理程序支持基于文件系统的存储池： 					

  ```none
  # virsh pool-capabilities | grep "'fs' supported='yes'"
  ```

  ​							如果该命令显示任何输出结果，则代表支持基于文件的池。 					

- ​							准备一个用于基础存储池的设备。因此，首选分区（例如 `/dev/sdb1）`或 LVM 卷。如果您提供对整个磁盘或块设备（例如 `/dev/sdb`）的写入访问权限的虚拟机，则虚拟机可能会对其分区或创建自己的 LVM 组。这可能导致主机上的系统错误。 					

  ​							但是，如果您需要将整个块设备用于存储池，红帽建议防止设备中的所有重要分区被 GRUB 的 `os-prober` 功能保护。要做到这一点，请编辑 `/etc/default/grub` 文件并应用以下配置之一： 					

  - ​									禁用 `os-prober`。 							

    ```none
    GRUB_DISABLE_OS_PROBER=true
    ```

  - ​									防止 `os-prober` 发现特定分区。例如： 							

    ```none
    GRUB_OS_PROBER_SKIP_LIST="5ef6313a-257c-4d43@/dev/sdb1"
    ```

**流程**

1. ​							**创建存储池** 					

   ​							使用 `virsh pool-define-as` 命令定义和创建文件系统类型的存储池。例如，要创建一个名为 `guest_images_fs` 的存储池，它使用 **/dev/sdc1** 分区，并挂载到 /guest_images 目录中： 					

   ```none
   # virsh pool-define-as guest_images_fs fs --source-dev /dev/sdc1 --target /guest_images
   Pool guest_images_fs defined
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.3 节 “基于文件系统的存储池参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#filesystem-based-storage-pool-parameters_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**定义存储池目标路径** 					

   ​							使用 `virsh pool-build` 命令为预格式化的文件系统存储池创建存储池目标路径，初始化存储源设备，然后定义数据的格式。 					

   ```none
   # virsh pool-build guest_images_fs
     Pool guest_images_fs built
   
   # ls -la /guest_images
     total 8
     drwx------.  2 root root 4096 May 31 19:38 .
     dr-xr-xr-x. 25 root root 4096 May 31 19:38 ..
   ```

3. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                 State      Autostart
     -----------------------------------------
     default              active     yes
     guest_images_fs      inactive   no
   ```

4. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_fs
     Pool guest_images_fs started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

5. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_fs
     Pool guest_images_fs marked as autostarted
   ```

**验证**

1. ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

   ```none
   # virsh pool-info guest_images_fs
     Name:           guest_images_fs
     UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
     State:          running
     Persistent:     yes
     Autostart:      yes
     Capacity:       458.39 GB
     Allocation:     197.91 MB
     Available:      458.20 GB
   ```

2. ​							验证文件系统的目标路径中存在 `lost+found` 目录，这表示挂载该设备。 					

   ```none
   # mount | grep /guest_images
     /dev/sdc1 on /guest_images type ext4 (rw)
   
   # ls -la /guest_images
     total 24
     drwxr-xr-x.  3 root root  4096 May 31 19:47 .
     dr-xr-xr-x. 25 root root  4096 May 31 19:38 ..
     drwx------.  2 root root 16384 May 31 14:18 lost+found
   ```

### 14.2.5. 使用 CLI 创建基于 iSCSI 的存储池

​					互联网小型计算机系统接口(iSCSI)是一种基于 IP 的存储网络标准，用于连接数据存储设施。如果要在 iSCSI 服务器上具有存储池，您可以使用 `virsh` 实用程序创建基于 iSCSI 的存储池。 			

**先决条件**

- ​							确定您的管理程序支持基于 iSCSI 的存储池： 					

  ```none
  # virsh pool-capabilities | grep "'iscsi' supported='yes'"
  ```

  ​							如果该命令显示任何输出结果，则代表支持基于 iSCSI 的池。 					

**流程**

1. ​							**创建存储池** 					

   ​							使用 `virsh pool-define-as` 命令定义并创建 iSCSI 类型的存储池。例如，要创建一个名为 `guest_images_iscsi` 的存储池，它使用 `iqn.2010-05.com.example.server1:iscsirhel7guest` IQN 到 `server1.example.com` 上的 `/dev/disk/by-path` 路径： 					

   ```none
   # virsh pool-define-as --name guest_images_iscsi --type iscsi --source-host server1.example.com --source-dev iqn.2010-05.com.example.server1:iscsirhel7guest --target /dev/disk/by-path
   Pool guest_images_iscsi defined
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.4 节 “基于 iSCSI 的存储池参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#iscsi-based-storage-pool-parameters_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                 State      Autostart
     -----------------------------------------
     default              active     yes
     guest_images_iscsi   inactive   no
   ```

3. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_iscsi
     Pool guest_images_iscsi started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

4. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_iscsi
     Pool guest_images_iscsi marked as autostarted
   ```

**验证**

- ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

  ```none
  # virsh pool-info guest_images_iscsi
    Name:           guest_images_iscsi
    UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
    State:          running
    Persistent:     yes
    Autostart:      yes
    Capacity:       458.39 GB
    Allocation:     197.91 MB
    Available:      458.20 GB
  ```

### 14.2.6. 使用 CLI 创建基于 LVM 的存储池

​					如果要有一个作为 LVM 卷组一部分的存储池，您可以使用 `virsh` 实用程序创建基于 LVM 的存储池。 			

**建议**

​						在创建基于 LVM 的存储池前请注意以下几点： 				

- ​							基于 LVM 的存储池不能为 LVM 提供完整的灵活性。 					

- ​							`libvirt` 支持精简逻辑卷，但不提供精简存储池的功能。 					

- ​							基于 LVM 的存储池是卷组。您可以使用 `virsh` 实用程序创建卷组，但是这样，您可以在创建的卷组中只有一个设备。要创建带有多个设备的卷组，请使用 LVM 工具，请参阅 [如何使用 LVM 在 Linux 中创建卷组](https://www.redhat.com/sysadmin/create-volume-group)。 					

  ​							有关卷组的详情，请参考 *Red Hat Enterprise Linux Logical Volume Manager Administration Guide*。 					

- ​							基于 LVM 的存储池需要一个完整磁盘分区。如果您使用 `virsh` 命令激活新分区或设备，分区将被格式化并擦除所有数据。如果您使用主机的现有卷组，如这些步骤中一样，则不会删除任何内容。 					

**先决条件**

- ​							确定您的管理程序支持基于 LVM 的存储池： 					

  ```none
  # virsh pool-capabilities | grep "'logical' supported='yes'"
  ```

  ​							如果命令显示任何输出结果，则支持基于 LVM 的池。 					

**流程**

1. ​							**创建存储池** 					

   ​							使用 `virsh pool-define-as` 命令定义并创建 LVM 类型的存储池。例如，以下命令会创建一个名为 `guest_images_lvm` 的存储池，它使用 `lvm_vg` 卷组，并挂载到 `/dev/lvm_vg` 目录中： 					

   ```none
   # virsh pool-define-as guest_images_lvm logical --source-name lvm_vg --target /dev/lvm_vg
   Pool guest_images_lvm defined
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.5 节 “基于 LVM 的存储池参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#lvm-based-storage-pool-parameters_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                   State      Autostart
     -------------------------------------------
     default                active     yes
     guest_images_lvm       inactive   no
   ```

3. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_lvm
     Pool guest_images_lvm started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

4. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_lvm
     Pool guest_images_lvm marked as autostarted
   ```

**验证**

- ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

  ```none
  # virsh pool-info guest_images_lvm
    Name:           guest_images_lvm
    UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
    State:          running
    Persistent:     yes
    Autostart:      yes
    Capacity:       458.39 GB
    Allocation:     197.91 MB
    Available:      458.20 GB
  ```

### 14.2.7. 使用 CLI 创建基于 NFS 的存储池

​					如果要在网络文件系统(NFS)服务器上拥有存储池，您可以使用 `virsh` 实用程序创建基于 NFS 的存储池。 			

**先决条件**

- ​							确定您的管理程序支持基于 NFS 的存储池： 					

  ```none
  # virsh pool-capabilities | grep "<value>nfs</value>"
  ```

  ​							如果该命令显示任何输出结果，则代表支持基于 NFS 的池。 					

**流程**

1. ​							**创建存储池** 					

   ​							使用 virsh `pool-define-as` 命令定义并创建 NFS 类型的存储池。例如，要创建一个名为 `guest_images_netfs` 的存储池，它使用使用目标目录 ` /var/lib/ libvirt/images/nfspool` 的带有 IP `111.222.111.222` 的 NFS 服务器： 					

   ```none
   # virsh pool-define-as --name guest_images_netfs --type netfs --source-host='111.222.111.222' --source-path='/home/net_mount' --source-format='nfs' --target='/var/lib/libvirt/images/nfspool'
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.6 节 “基于 NFS 的存储池参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#nfs-based-storage-pool-parameters_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                 State      Autostart
     -----------------------------------------
     default              active     yes
     guest_images_netfs   inactive   no
   ```

3. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_netfs
     Pool guest_images_netfs started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

4. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_netfs
     Pool guest_images_netfs marked as autostarted
   ```

**验证**

- ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

  ```none
  # virsh pool-info guest_images_netfs
    Name:           guest_images_netfs
    UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
    State:          running
    Persistent:     yes
    Autostart:      yes
    Capacity:       458.39 GB
    Allocation:     197.91 MB
    Available:      458.20 GB
  ```

### 14.2.8. 通过 CLI，创建带有 vHBA 设备的基于 SCSI 的存储池

​					如果要在小型计算机系统接口(SCSI)设备中有一个存储池，您的主机必须能够使用虚拟主机总线适配器(vHBA)连接到 SCSI 设备。然后，您可以使用 `virsh` 实用程序创建基于 SCSI 的存储池。 			

**先决条件**

- ​							确定您的管理程序支持基于 SCSI 的存储池： 					

  ```none
  # virsh pool-capabilities | grep "'scsi' supported='yes'"
  ```

  ​							如果该命令显示任何输出结果，则代表支持基于 SCSI 的池。 					

- ​							在使用 vHBA 设备创建基于 SCSI 的存储池前，先创建一个 vHBA。如需更多信息，请参阅 [创建 vHBA](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-vhbas_managing-storage-for-virtual-machines)。 					

**流程**

1. ​							**创建存储池** 					

   ​							使用 `virsh pool-define-as` 命令使用 vHBA 定义并创建 SCSI 存储池。例如，以下命令会创建一个名为 `guest_images_vhba` 的存储池，它使用 `scsi_host3` 父适配器指定的 vHBA，全局范围端口为 `5001a4ace3ee047d`，以及全局节点范围为 `5001a4a93526d0a1`。存储池挂载到 `/dev/disk/` 目录中： 					

   ```none
   # virsh pool-define-as guest_images_vhba scsi --adapter-parent scsi_host3 --adapter-wwnn 5001a4a93526d0a1 --adapter-wwpn 5001a4ace3ee047d --target /dev/disk/
   Pool guest_images_vhba defined
   ```

   ​							如果您已经有要创建的存储池的 XML 配置，也可以根据 XML 定义池。详情请查看 [第 14.4.7 节 “使用 vHBA 设备的基于 SCSI 的存储池的参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#parameters-for-scsi-based-storage-pools-with-vhba-devices_assembly_parameters-for-creating-storage-pools)。 					

2. ​							**验证是否已创建池** 					

   ​							使用 `virsh pool-list` 命令验证池是否已创建。 					

   ```none
   # virsh pool-list --all
   
     Name                 State      Autostart
     -----------------------------------------
     default              active     yes
     guest_images_vhba    inactive   no
   ```

3. ​							**启动存储池** 					

   ​							使用 `virsh pool-start` 命令挂载存储池。 					

   ```none
   # virsh pool-start guest_images_vhba
     Pool guest_images_vhba started
   ```

   注意

   ​								`virsh pool-start` 命令仅适用于持久性存储池。临时存储池创建时会自动启动。 						

4. ​							**[可选]自动启动过程** 					

   ​							默认情况下，使用 `virsh` 命令定义的存储池不会被设置为在每次虚拟化服务启动时自动启动。使用 `virsh pool-autostart` 命令将存储池配置为 autostart。 					

   ```none
   # virsh pool-autostart guest_images_vhba
     Pool guest_images_vhba marked as autostarted
   ```

**验证**

- ​							使用 `virsh pool-info` 命令来验证存储池是否处于 `*running*` 状态。检查报告的大小是否如预期，以及是否正确配置了自动启动。 					

  ```none
  # virsh pool-info guest_images_vhba
    Name:           guest_images_vhba
    UUID:           c7466869-e82a-a66c-2187-dc9d6f0877d0
    State:          running
    Persistent:     yes
    Autostart:      yes
    Capacity:       458.39 GB
    Allocation:     197.91 MB
    Available:      458.20 GB
  ```

### 14.2.9. 使用 CLI 删除存储池

​					要从主机系统中删除存储池，您必须停止池并删除它的 XML 定义。 			

**流程**

1. ​							使用 `virsh pool-list` 命令列出定义的存储池。 					

   ```none
   # virsh pool-list --all
   Name                 State      Autostart
   -------------------------------------------
   default              active     yes
   Downloads            active     yes
   RHEL-Storage-Pool   active     yes
   ```

2. ​							使用 `virsh pool-destroy` 命令停止您要删除的存储池。 					

   ```none
   # virsh pool-destroy Downloads
   Pool Downloads destroyed
   ```

3. ​							**可选** ：对于某些类型的存储池，您可以使用 `virsh pool-delete` 命令删除存储池所在的目录。请注意，要这样做，该目录必须为空。 					

   ```none
   # virsh pool-delete Downloads
   Pool Downloads deleted
   ```

4. ​							使用 `virsh pool-undefine` 命令删除存储池的定义。 					

   ```none
   # virsh pool-undefine Downloads
   Pool Downloads has been undefined
   ```

**验证**

- ​							确认删除了存储池。 					

  ```none
  # virsh pool-list --all
  Name                 State      Autostart
  -------------------------------------------
  default              active     yes
  RHEL-Storage-Pool   active     yes
  ```

## 14.3. 使用 web 控制台管理虚拟机存储池

​				使用 RHEL web 控制台，您可以管理存储池来为虚拟机分配存储。 		

​				您可以使用 Web 控制台： 		

- ​						[查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 				
- ​						创建存储池： 				
  - ​								[创建基于目录的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-directory-based-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 						
  - ​								[创建基于 NFS 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_creating-nfs-based-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 						
  - ​								[创建基于 iSCSI 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_creating-iscsi-based-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 						
  - ​								[创建基于 LVM 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_creating-lvm-based-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 						
- ​						[删除存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#removing-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 				
- ​						[取消激活存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deactivating-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console)。 				

### 14.3.1. 使用 Web 控制台查看存储池信息

​					使用 Web 控制台，您可以查看系统中可用的存储池的详细信息。存储池可用于为您的虚拟机创建磁盘镜像。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							点 Virtual Machines 接口顶部的 Storage Pools。 					

   ​							此时会出现存储池窗口，显示配置的存储池列表。 					

   [![图像显示 web 控制台的存储池标签页，其中包含现有存储池的信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

   ​							该信息包括： 					

   - ​									**名称** - 存储池的名称。 							
   - ​									**大小** - 存储池的当前分配和总容量。 							
   - ​									**connection** - 用于访问存储池的连接。 							
   - ​									**State** - 存储池的状态。 							

2. ​							点击您要查看信息的存储池旁的箭头。 					

   ​							行会展开，以显示包含所选存储池详细信息的 Overview 窗格。 					

   [![镜像显示所选存储池的详细信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)

   ​							该信息包括： 					

   - ​									**目标路径** - 由目录支持的存储池类型的源（如 `dir` 或 `netfs` ）。 							
   - ​									**Persistent** - 指示存储池是否有持久配置。 							
   - ​									**Autostart** - 说明存储池是否在系统引导时自动启动。 							
   - ​									**类型** - 存储池的类型。 							

3. ​							要查看与存储池关联的存储卷列表，请点击 存储卷。 					

   ​							此时会出现 Storage Volumes 窗格，显示配置的存储卷列表。 					

   [![显示与所选存储池关联的存储卷列表的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddf5950143181cdfd03af8fa276d32c/web-console-storage-pool-storage-volumes.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fddf5950143181cdfd03af8fa276d32c/web-console-storage-pool-storage-volumes.png)

   ​							该信息包括： 					

   - ​									**名称** - 存储卷的名称。 							
   - ​									**Used by** - 当前使用存储卷的虚拟机。 							
   - ​									**size** - 卷的大小。 							

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 14.3.2. 使用 Web 控制台创建基于目录的存储池

​					基于目录的存储池基于现有挂载的文件系统中的目录。这很有用，例如您要使用文件系统上的剩余空间来满足其他目的。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 RHEL web 控制台中，点 **Virtual Machines** 选项卡中的 Storage pool。 					

   ​							此时会出现 **存储池** 窗口，显示配置的存储池列表（若有）。 					

   [![显示主机上当前配置的所有存储池的镜像](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							单击 Create storage pool。 					

   ​							此时会出现 **Create 存储池** 对话框。 					

3. ​							输入存储池的名称。 					

4. ​							在 **Type** 下拉菜单中选择 **Filesystem directory**。 					

   [![显示 Create 存储池对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/44b6aa955f1810a3a325a6d7a3a5361d/virt-cockpit-create-dir-storage-pool.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/44b6aa955f1810a3a325a6d7a3a5361d/virt-cockpit-create-dir-storage-pool.png)

   注意

   ​								如果您没有在下拉菜单中选择 **Filesystem 目录** 选项，则您的管理程序不支持基于目录的存储池。 						

5. ​							输入以下信息： 					

   - ​									**目标路径** - 由目录支持的存储池类型的源（如 `dir` 或 `netfs` ）。 							
   - ​									**启动**」 - 主机引导时是否启动存储池。 							

6. ​							点击 Create。 					

   ​							创建存储池时，**Create Storage Pool** 对话框将关闭，新的存储池会出现在存储池列表中。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

### 14.3.3. 使用 Web 控制台创建基于 NFS 的存储池

​					基于 NFS 的存储池是基于服务器上托管的文件系统。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 RHEL web 控制台中，点 **Virtual Machines** 选项卡中的 Storage pool。 					

   ​							此时会出现 **存储池** 窗口，显示配置的存储池列表（若有）。 					

   [![显示主机上当前配置的所有存储池的镜像](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							单击 Create storage pool。 					

   ​							此时会出现 **Create 存储池** 对话框。 					

3. ​							输入存储池的名称。 					

4. ​							在 **Type** 下拉菜单中选择 **Network File System**。 					

   [![显示 Create 存储池对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/d857cf84ec3d53e05114a693ad59ad12/virt-cockpit-create-nfs-storage-pool.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/d857cf84ec3d53e05114a693ad59ad12/virt-cockpit-create-nfs-storage-pool.png)

   注意

   ​								如果您在下拉菜单中选择 **网络文件系统** 选项，则您的管理程序不支持基于 NFS 的存储池。 						

5. ​							输入其他信息： 					

   - ​									**目标路径** - 指定目标的路径。这将是用于存储池的路径。 							
   - ​									**主机** - 挂载点所在的网络服务器的主机名。这可以是主机名或 IP 地址。 							
   - ​									**源路径** - 网络服务器中使用的目录。 							
   - ​									**启动**」 - 主机引导时是否启动存储池。 							

6. ​							点击 Create。 					

   ​							已创建存储池。这会关闭 **Create storage pool** 对话框，新的存储池会出现在存储池列表中。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

### 14.3.4. 使用 Web 控制台创建基于 iSCSI 的存储池

​					基于 iSCSI 的存储池是基于互联网小型计算机系统接口(iSCSI)，这是一种基于 IP 的存储网络标准，用于连接数据存储设施。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 RHEL web 控制台中，点 **Virtual Machines** 选项卡中的 Storage pool。 					

   ​							此时会出现 **存储池** 窗口，显示配置的存储池列表（若有）。 					

   [![显示主机上当前配置的所有存储池的镜像](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							单击 Create storage pool。 					

   ​							此时会出现 **Create 存储池** 对话框。 					

3. ​							输入存储池的名称。 					

4. ​							在 **Type** 下拉菜单中选择 **iSCSI 目标**。 					

   [![显示 Create 存储池对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/44a9e3c77933238985c631021973ee53/virt-cockpit-create-iscsi-storage-pool.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/44a9e3c77933238985c631021973ee53/virt-cockpit-create-iscsi-storage-pool.png)

5. ​							输入其他信息： 					

   - ​									**目标路径** - 指定目标的路径。这将是用于存储池的路径。 							
   - ​									**主机** - ISCSI 服务器的主机名或 IP 地址。 							
   - ​									**源路径** - iSCSI 目标的唯一 iSCSI 限定名称(IQN)。 							
   - ​									**启动**」 - 主机引导时是否启动存储池。 							

6. ​							点击 Create。 					

   ​							已创建存储池。这会关闭 **Create storage pool** 对话框，新的存储池会出现在存储池列表中。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

### 14.3.5. 使用 Web 控制台创建基于磁盘的存储池

​					基于磁盘的存储池使用整个磁盘分区。 			

警告

- ​								根据所使用的 libvirt 版本，在存储池中指定一个磁盘可能会重新格式化并清除当前存储在磁盘设备上的所有数据。强烈建议您在创建存储池前备份存储设备中的数据。 						

- ​								当整个磁盘或块设备传递给虚拟机时，虚拟机可能会对其分区或者创建自己的 LVM 组。这可能导致主机机器检测到这些分区或者 LVM 组并导致错误。 						

  ​								在手动创建分区或 LVM 组并将其传递给虚拟机时，也可以发生这些错误。 						

  ​								要避免这些错误，请改为使用基于文件的存储池。 						

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 RHEL web 控制台中，点 **Virtual Machines** 选项卡中的 Storage pool。 					

   ​							此时会出现 **存储池** 窗口，显示配置的存储池列表（若有）。 					

   [![显示主机上当前配置的所有存储池的镜像](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							单击 Create storage pool。 					

   ​							此时会出现 **Create 存储池** 对话框。 					

3. ​							输入存储池的名称。 					

4. ​							在 **Type** 下拉菜单中选择 **物理磁盘设备**。 					

   [![显示 Create 存储池对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/6027f8d3fa0d1e746ecdee8b7ef30c41/virt-cockpit-create-disk-storage-pool.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/6027f8d3fa0d1e746ecdee8b7ef30c41/virt-cockpit-create-disk-storage-pool.png)

   注意

   ​								如果您在下拉菜单中选择 **物理磁盘设备** 选项，则您的管理程序不支持基于磁盘的存储池。 						

5. ​							输入其他信息： 					

   - ​									**目标路径** - 指定目标设备的路径。这将是用于存储池的路径。 							
   - ​									**源路径** - 指定存储设备的路径。例如： `/dev/sdb`。 							
   - ​									**格式** - 分区表的类型。 							
   - ​									**启动**」 - 主机引导时是否启动存储池。 							

6. ​							点击 Create。 					

   ​							已创建存储池。这会关闭 **Create storage pool** 对话框，新的存储池会出现在存储池列表中。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

### 14.3.6. 使用 Web 控制台创建基于 LVM 的存储池

​					基于 LVM 的存储池是基于卷组，您可以使用逻辑卷管理器(LVM)进行管理。卷组是多个物理卷的组合，它可创建单个存储结构。 			

注意

- ​								基于 LVM 的存储池不能为 LVM 提供完整的灵活性。 						

- ​								`libvirt` 支持精简逻辑卷，但不提供精简存储池的功能。 						

- ​								基于 LVM 的存储池需要一个完整磁盘分区。如果您使用 `virsh` 命令激活新分区或设备，分区将被格式化并擦除所有数据。如果您使用主机的现有卷组，如这些步骤中一样，则不会删除任何内容。 						

- ​								要创建带有多个设备的卷组，请使用 LVM 工具，请参阅 [如何使用 LVM 在 Linux 中创建卷组](https://www.redhat.com/sysadmin/create-volume-group)。 						

  ​								有关卷组的详情，请参考 *Red Hat Enterprise Linux Logical Volume Manager Administration Guide*。 						

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 RHEL web 控制台中，点 **Virtual Machines** 选项卡中的 Storage pool。 					

   ​							此时会出现 **存储池** 窗口，显示配置的存储池列表（若有）。 					

   [![显示主机上当前配置的所有存储池的镜像](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							单击 Create storage pool。 					

   ​							此时会出现 **Create 存储池** 对话框。 					

3. ​							输入存储池的名称。 					

4. ​							在 **Type** 下拉菜单中选择 **LVM 卷组**。 					

   [![显示 Create 存储池对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ebc6eacf244bbe6f26cf069bb9b13d44/virt-cockpit-create-lvm-storage-pool.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ebc6eacf244bbe6f26cf069bb9b13d44/virt-cockpit-create-lvm-storage-pool.png)

   注意

   ​								如果您在下拉菜单中选择 **LVM 卷组** 选项，则您的管理程序不支持基于 LVM 的存储池。 						

5. ​							输入其他信息： 					

   - ​									**源卷组** - 要使用的 LVM 卷组名称。 							
   - ​									**启动**」 - 主机引导时是否启动存储池。 							

6. ​							点击 Create。 					

   ​							已创建存储池。这会关闭 **Create storage pool** 对话框，新的存储池会出现在存储池列表中。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

### 14.3.7. 使用 Web 控制台删除存储池

​					您可以删除存储池来释放主机或网络上的资源来提高系统性能。删除存储池也会释放资源，然后供其他虚拟机使用。 			

重要

​						除非明确指定，否则删除存储池不会同时删除该池中的存储卷。 				

​					要使用 RHEL web 控制台删除存储池，请参阅以下步骤。 			

注意

​						如果要临时取消激活存储池而不是删除它，请参阅[使用 Web 控制台取消激活存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deactivating-storage-pools-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 				

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							如果要删除池中的存储卷，您必须首先从虚拟机中[分离该磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#detaching-disks-from-virtual-machines_assembly_managing-virtual-machine-storage-disks-using-the-web-console)。 					

**流程**

1. ​							点 **Virtual Machines** 选项卡上的 Storage Pools。 					

   ​							此时会出现**存储池**窗口，显示配置的存储池列表。 					

   [![显示在主机上当前配置的所有存储池的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							在 Storage Pools 窗口中，点击您要删除的存储池。 					

   ​							行会展开，以显示 **Overview** 窗格，其中包含有关所选存储池的基本信息，以及用于停用或删除存储池的控件。 					

   [![镜像显示所选存储池的详细信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)

3. ​							点击 Menu 按钮 ⋮ 并点 Delete。 					

   ​							此时会出现确认对话框。 					

   [![显示 Delete Storage Pool 默认对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/d208dda3af5d9c7f50f62a29bb279f55/virt-cockpit-storage-pool-delete-confirm.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/d208dda3af5d9c7f50f62a29bb279f55/virt-cockpit-storage-pool-delete-confirm.png)

4. ​							**可选：**要删除池中的存储卷，请在对话框中选择复选框。 					

5. ​							点击 Delete。 					

   ​							存储池已删除。如果您在上一步中选择了复选框，相关的存储卷也会被删除。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

### 14.3.8. 使用 Web 控制台取消激活存储池

​					如果您不想永久删除存储池，您可以临时取消激活它。 			

​					当您取消激活存储池时，无法在那个池中创建新卷。但是，该池中具有卷的任何虚拟机都将继续运行。这对于多种原因非常有用，例如，您可以限制池中创建的卷数量来提升系统性能。 			

​					要使用 RHEL web 控制台取消激活存储池，请参阅以下步骤。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							点击 Virtual Machines 选项卡顶部的 Storage Pools。此时会出现存储池窗口，显示配置的存储池列表。 					

   [![显示在主机上当前配置的所有存储池的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							在 Storage Pools 窗口中，点击您要取消激活的存储池。 					

   ​							行会展开，以显示 Overview 窗格，其中包含有关所选存储池的基本信息，以及用于取消激活和删除虚拟机的控制信息。 					

   [![镜像显示所选存储池的详细信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)

3. ​							点取消激活。 					

   ​							存储池将停用。 					

**其他资源**

- ​							[了解存储池](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#understanding-storage-pools_understanding-virtual-machine-storage) 					
- ​							[使用 Web 控制台查看存储池信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-pool-information-using-the-web-console_assembly_managing-virtual-machine-storage-pools-using-the-web-console) 					

## 14.4. 创建存储池的参数

​				根据您需要的存储池类型，您可以修改其 XML 配置文件并定义特定类型的存储池。这部分提供了创建各种存储池类型所需的 XML 参数以及示例。 		

### 14.4.1. 基于目录的存储池参数

​					当使用 XML 配置文件创建或修改基于目录的存储池时，您必须包括特定的必要参数。有关这些参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_dir
```

**参数**

​						下表提供了基于目录的存储池 XML 文件所需的参数列表。 				

**表 14.1. 基于目录的存储池参数**

| 描述                                     | XML                                               |
| ---------------------------------------- | ------------------------------------------------- |
| 存储池的类型                             | `<pool type='dir'>`                               |
| 存储池的名称                             | `<name>*name*</name>`                             |
| 指定目标的路径。这将是用于存储池的路径。 | `<target>   <path>*target_path*</path> </target>` |

**示例**

​						以下是基于 `/guest_images` 目录的存储池的 XML 文件示例： 				

```xml
<pool type='dir'>
  <name>dirpool</name>
  <target>
    <path>/guest_images</path>
  </target>
</pool>
```

**其他资源**

- ​							[使用 CLI 创建基于目录的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-directory-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

### 14.4.2. 基于磁盘的存储池参数

​					当使用 XML 配置文件创建或修改基于磁盘的存储池时，您必须包括特定的必要参数。有关这些参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_disk
```

**参数**

​						下表提供了基于磁盘存储池的 XML 文件所需的参数列表。 				

**表 14.2. 基于磁盘的存储池参数**

| 描述                                         | XML                                               |
| -------------------------------------------- | ------------------------------------------------- |
| 存储池的类型                                 | `<pool type='disk'>`                              |
| 存储池的名称                                 | `<name>*name*</name>`                             |
| 指定存储设备的路径。例如： `/dev/sdb`。      | `<source>   <path>*source_path*</path> </source>` |
| 指定目标设备的路径。这将是用于存储池的路径。 | `<target>   <path>*target_path*</path> </target>` |

**示例**

​						以下是基于磁盘存储池的 XML 文件示例： 				

```xml
<pool type='disk'>
  <name>phy_disk</name>
  <source>
    <device path='/dev/sdb'/>
    <format type='gpt'/>
  </source>
  <target>
    <path>/dev</path>
  </target>
</pool>
```

**其他资源**

- ​							[使用 CLI 创建基于磁盘的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-disk-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

### 14.4.3. 基于文件系统的存储池参数

​					当使用 XML 配置文件创建或修改基于文件系统的存储池时，您必须包括特定的必要参数。有关这些参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_fs
```

**参数**

​						下表提供了基于文件系统的存储池 XML 文件所需的参数列表。 				

**表 14.3. 基于文件系统的存储池参数**

| 描述                                     | XML                                                 |
| ---------------------------------------- | --------------------------------------------------- |
| 存储池的类型                             | `<pool type='fs'>`                                  |
| 存储池的名称                             | `<name>*name*</name>`                               |
| 指定分区的路径。例如： `/dev/sdc1`       | `<source>   <device path=*device_path* />`          |
| 文件系统类型，例如 **ext4**。            | `<format type=*fs_type* /> </source>`               |
| 指定目标的路径。这将是用于存储池的路径。 | `<target>   <path>*path-to-pool*</path>  </target>` |

**示例**

​						以下是基于 `/dev/sdc1` 分区的存储池的 XML 文件示例： 				

```xml
<pool type='fs'>
  <name>guest_images_fs</name>
  <source>
    <device path='/dev/sdc1'/>
    <format type='auto'/>
  </source>
  <target>
    <path>/guest_images</path>
  </target>
</pool>
```

**其他资源**

- ​							[使用 CLI 创建基于文件系统的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-filesystem-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

### 14.4.4. 基于 iSCSI 的存储池参数

​					当使用 XML 配置文件创建或修改基于 iSCSI 的存储池时，您必须包括特定的必要参数。有关这些参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_iscsi
```

**参数**

​						下表提供了基于 iSCSI 存储池的 XML 文件所需的参数列表。 				

**表 14.4. 基于 iSCSI 的存储池参数**

| 描述                                                         | XML                                                        |
| ------------------------------------------------------------ | ---------------------------------------------------------- |
| 存储池的类型                                                 | `<pool type='iscsi'>`                                      |
| 存储池的名称                                                 | `<name>*name*</name>`                                      |
| 主机的名称                                                   | `<source>  <host name=*hostname* />`                       |
| iSCSI IQN                                                    | `<device path= *iSCSI_IQN* />  </source>`                  |
| 指定目标的路径。这将是用于存储池的路径。                     | `<target>    <path>*/dev/disk/by-path*</path>  </target>`  |
| [可选] iSCSI initiator 的 IQN。只有 ACL 将 LUN 限制为特定发起方时才需要。 | `<initiator>    <iqn name='*initiator0*' />  </initiator>` |

注意

​						iSCSI initiator 的 IQN 可使用 `virsh find-storage-pool-sources-as` iscsi 命令确定。 				

**示例**

​						以下是基于指定 iSCSI 设备的存储池的 XML 文件示例： 				

```xml
<pool type='iscsi'>
  <name>iSCSI_pool</name>
  <source>
    <host name='server1.example.com'/>
    <device path='iqn.2010-05.com.example.server1:iscsirhel7guest'/>
  </source>
  <target>
    <path>/dev/disk/by-path</path>
  </target>
</pool>
```

**其他资源**

- ​							[使用 CLI 创建基于 iSCSI 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-iscsi-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

### 14.4.5. 基于 LVM 的存储池参数

​					当使用 XML 配置文件创建或修改基于 LVM 的存储池时，您必须包括特定的必要参数。有关这些参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_logical
```

**参数**

​						下表提供了基于 LVM 的存储池 XML 文件所需的参数列表。 				

**表 14.5. 基于 LVM 的存储池参数**

| 描述             | XML                                            |
| ---------------- | ---------------------------------------------- |
| 存储池的类型     | `<pool type='logical'>`                        |
| 存储池的名称     | `<name>*name*</name>`                          |
| 存储池设备的路径 | `<source>    <device path='*device_path*' />`` |
| 卷组名称         | `<name>*VG-name*</name>`                       |
| 虚拟组格式       | `<format type='lvm2' />  </source>`            |
| 目标路径         | `<target>    <path=*target_path* /> </target>` |

注意

​						如果逻辑卷组由多个磁盘分区组成，则可能会列出多个源设备。例如： 				

```none
<source>
  <device path='/dev/sda1'/>
  <device path='/dev/sdb3'/>
  <device path='/dev/sdc2'/>
  ...
</source>
```

**示例**

​						以下是基于指定 LVM 的存储池的 XML 文件示例： 				

```xml
<pool type='logical'>
  <name>guest_images_lvm</name>
  <source>
    <device path='/dev/sdc'/>
    <name>libvirt_lvm</name>
    <format type='lvm2'/>
  </source>
  <target>
    <path>/dev/libvirt_lvm</path>
  </target>
</pool>
```

**其他资源**

- ​							[使用 CLI 创建基于 LVM 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-lvm-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

### 14.4.6. 基于 NFS 的存储池参数

​					当使用 XML 配置文件创建或修改基于 NFS 的存储池时，您必须包括特定的必要参数。有关这些参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_netfs
```

**参数**

​						下表提供了基于 NFS 的存储池 XML 文件所需的参数列表。 				

**表 14.6. 基于 NFS 的存储池参数**

| 描述                                                       | XML                                                          |
| ---------------------------------------------------------- | ------------------------------------------------------------ |
| 存储池的类型                                               | `<pool type='netfs'>`                                        |
| 存储池的名称                                               | `<name>*name*</name>`                                        |
| 挂载点所在的网络服务器的主机名。这可以是主机名或 IP 地址。 | `<source>    <host name=*hostname*` `/>`                     |
| 存储池的格式                                               | 下面是其中之一： 							 							  								  `<format type='nfs' />` 							 							  								  `<format type='cifs' />` |
| 网络服务器上使用的目录                                     | `<dir path=*source_path*` `/>  </source>`                    |
| 指定目标的路径。这将是用于存储池的路径。                   | `<target>    <path>*target_path*</path>  </target>`          |

**示例**

​						以下是基于 `file_server` NFS 服务器的 `/home/net_mount` 目录的存储池的 XML 文件示例： 				

```xml
<pool type='netfs'>
  <name>nfspool</name>
  <source>
    <host name='file_server'/>
    <format type='nfs'/>
    <dir path='/home/net_mount'/>
  </source>
  <target>
    <path>/var/lib/libvirt/images/nfspool</path>
  </target>
</pool>
```

**其他资源**

- ​							[使用 CLI 创建基于 NFS 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-nfs-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

### 14.4.7. 使用 vHBA 设备的基于 SCSI 的存储池的参数

​					要为基于 SCSi 的存储池创建或修改 XML 配置文件，它使用虚拟主机适配器总线(vHBA)设备，必须在 XML 配置文件中包括特定的参数。有关所需参数的更多信息，请参阅下表。 			

​					您可以使用 `virsh pool-define` 命令，根据指定文件中的 XML 配置创建存储池。例如： 			

```none
# virsh pool-define ~/guest_images.xml
  Pool defined from guest_images_vhba
```

**参数**

​						下表提供了使用 vHBA 的基于 SCSI 的存储池 XML 文件所需的参数列表。 				

**表 14.7. 使用 vHBA 设备的基于 SCSI 的存储池的参数**

| 描述                                   | XML                                                          |
| -------------------------------------- | ------------------------------------------------------------ |
| 存储池的类型                           | `<pool type='scsi'>`                                         |
| 存储池的名称                           | `<name>*name*</name>`                                        |
| vHBA 的标识符。`parent` 属性是可选的。 | `<source>    <adapter type='fc_host'   [parent=*parent_scsi_device*]   wwnn='*WWNN*'   wwpn='*WWPN*' /> </source>` |
| 目标路径。这将是用于存储池的路径。     | `<target>    <path=*target_path* /> </target>`               |

重要

​						当 `<path>` 字段是 `**/dev/**` 时，`libvirt` 为卷设备路径生成唯一的简短设备路径。例如： `**/dev/sdc**`。否则会使用物理主机路径。例如： `**/dev/disk/by-path/pci-0000:10:00.0-fc-0x5006016044602198-lun-0**`。唯一的短设备路径允许多个存储池在多个虚拟机(VM)中列出相同的卷。如果多个虚拟机使用了物理主机路径，则可能会出现重复的设备类型警告。 				

注意

​						`parent` 属性可在 `<adapter>` 字段中使用，以标识可用不同路径 NPIV LUN 的物理 HBA 父项。此字段 `scsi_hostN` 与 `vports` 和 `max_vports` 属性相结合，以完成父身份。`parent`, `parent_wwnn`, `parent_wwpn`, or `parent_fabric_wwn` 属性提供在主机重启使用相同的 HBA 后的不同保证程度。 				

- ​								如果没有指定 `parent`，`libvirt` 将使用支持 NPIV 的第一个 `scsi_hostN` 适配器。 						
- ​								如果只指定 `parent` 设备，则在配置中添加额外的 SCSI 主机适配器时可能会出现问题。 						
- ​								如果指定了 `parent_wwnn` 或 `parent_wwpn`，则在主机重启后会使用相同的 HBA。 						
- ​								如果使用 `parent_fabric_wwn`，在主机重启同一光纤中的 HBA 后，无论使用的 `scsi_hostN` 是什么，都会选择同一光纤中的 HBA。 						

**例子**

​						以下是使用 vHBA 的基于 SCSI 的存储池的 XML 文件示例。 				

- ​							它是 HBA 中唯一存储池的存储池： 					

  ```xml
  <pool type='scsi'>
    <name>vhbapool_host3</name>
    <source>
      <adapter type='fc_host' wwnn='5001a4a93526d0a1' wwpn='5001a4ace3ee047d'/>
    </source>
    <target>
      <path>/dev/disk/by-path</path>
    </target>
  </pool>
  ```

- ​							存储池是使用单一 vHBA 并使用 `parent` 属性识别 SCSI 主机设备的几个存储池之一： 					

  ```xml
  <pool type='scsi'>
    <name>vhbapool_host3</name>
    <source>
      <adapter type='fc_host' parent='scsi_host3' wwnn='5001a4a93526d0a1' wwpn='5001a4ace3ee047d'/>
    </source>
    <target>
      <path>/dev/disk/by-path</path>
    </target>
  </pool>
  ```

**其他资源**

- ​							[通过 CLI，创建带有 vHBA 设备的基于 SCSI 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-scsi-based-storage-pools-with-vhba-devices-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 					

## 14.5. 使用 CLI 管理虚拟机存储卷

​				您可以使用 CLI 管理存储卷的以下方面来为虚拟机分配存储： 		

- ​						[查看存储卷信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-storage-volume-information-using-the-cli_assembly_managing-virtual-machine-storage-volumes-using-the-cli) 				
- ​						[创建存储卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-and-assigning-storage-volumes-using-the-cli_assembly_managing-virtual-machine-storage-volumes-using-the-cli) 				
- ​						[删除存储卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#deleting-storage-volumes-using-the-cli_assembly_managing-virtual-machine-storage-volumes-using-the-cli) 				

### 14.5.1. 使用 CLI 查看存储卷信息

​					使用命令行，您可以查看主机上可用的所有存储池的列表，以及指定存储池的详情 			

**流程**

1. ​							使用 `virsh vol-list` 命令列出指定存储池中的存储卷。 					

   ```none
   # virsh vol-list --pool RHEL-Storage-Pool --details
    Name                Path                                               Type   Capacity  Allocation
   ---------------------------------------------------------------------------------------------
    .bash_history       /home/VirtualMachines/.bash_history       file  18.70 KiB   20.00 KiB
    .bash_logout        /home/VirtualMachines/.bash_logout        file    18.00 B    4.00 KiB
    .bash_profile       /home/VirtualMachines/.bash_profile       file   193.00 B    4.00 KiB
    .bashrc             /home/VirtualMachines/.bashrc             file   1.29 KiB    4.00 KiB
    .git-prompt.sh      /home/VirtualMachines/.git-prompt.sh      file  15.84 KiB   16.00 KiB
    .gitconfig          /home/VirtualMachines/.gitconfig          file   167.00 B    4.00 KiB
    RHEL_Volume.qcow2   /home/VirtualMachines/RHEL8_Volume.qcow2  file  60.00 GiB   13.93 GiB
   ```

2. ​							使用 `virsh vol-info` 命令列出指定存储池中的存储卷。 					

   ```none
   # vol-info --pool RHEL-Storage-Pool --vol RHEL_Volume.qcow2
   Name:           RHEL_Volume.qcow2
   Type:           file
   Capacity:       60.00 GiB
   Allocation:     13.93 GiB
   ```

### 14.5.2. 使用 CLI 创建并分配存储卷

​					要获取磁盘镜像并将其附加到虚拟机(VM)作为虚拟磁盘，请创建一个存储卷并将其 XML 配置分配给虚拟机。 			

**先决条件**

- ​							主机上存在带有未分配空间的存储池。 					

  - ​									要验证，列出主机上的存储池： 							

    ```none
    # virsh pool-list --details
    
    Name               State     Autostart   Persistent   Capacity     Allocation   Available
    --------------------------------------------------------------------------------------------
    default            running   yes         yes          48.97 GiB    36.34 GiB    12.63 GiB
    Downloads          running   yes         yes          175.92 GiB   121.20 GiB   54.72 GiB
    VM-disks           running   yes         yes          175.92 GiB   121.20 GiB   54.72 GiB
    ```

  - ​									如果您没有现有的存储池，请创建一个。如需更多信息，请参阅 [第 14 章 *为虚拟机管理存储*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-storage-for-virtual-machines_configuring-and-managing-virtualization)。 							

**流程**

1. ​							使用 `virsh vol-create-as` 命令创建存储卷。例如，基于 `guest-images-fs` 存储池创建 20 GB qcow2 卷： 					

   ```none
   # virsh vol-create-as --pool guest-images-fs --name vm-disk1 --capacity 20 --format qcow2
   ```

   ​							**重要**：特定的存储池类型不支持 `virsh vol-create-as` 命令，而是需要特定的进程来创建存储卷： 					

   - ​									**基于 iSCSI** - 事先在 iSCSI 服务器中准备 iSCSI LUN。 							
   - ​									**基于多路径** - 使用 `multipathd` 命令准备或管理多路径。 							
   - ​									**基于 vHBA**  - 事先准备光纤通道卡。 							

2. ​							创建一个 XML 文件，并在其中添加以下几行。此文件将用于将存储卷作为磁盘添加到虚拟机。 					

   ```xml
   <disk type='volume' device='disk'>
       <driver name='qemu' type='qcow2'/>
       <source pool='guest-images-fs' volume='vm-disk1'/>
       <target dev='hdk' bus='ide'/>
   </disk>
   ```

   ​							这个示例指定了使用在上一步中创建的 `vm-disk1` 卷的虚拟磁盘，并将卷设置为 `ide` bus 上的磁盘 `hdk`。根据您的环境修改对应的参数。 					

   ​							**重要**：使用特定的存储池类型，必须使用不同的 XML 格式来描述存储卷磁盘。 					

   - ​									对于 *基于多路径的*池： 							

     ```xml
     <disk type='block' device='disk'>
     <driver name='qemu' type='raw'/>
     <source dev='/dev/mapper/mpatha' />
     <target dev='sda' bus='scsi'/>
     </disk>
     ```

   - ​									对于 *基于 RBD 存储的*池： 							

     ```xml
       <disk type='network' device='disk'>
         <driver name='qemu' type='raw'/>
         <source protocol='rbd' name='pool/image'>
           <host name='mon1.example.org' port='6321'/>
         </source>
         <target dev='vdc' bus='virtio'/>
       </disk>
     ```

3. ​							使用 XML 文件为虚拟机分配存储卷。例如，要将 `~/vm-disk1.xml` 中定义的磁盘分配给 `testguest1` 虚拟机： 					

   ```none
   # attach-device --config testguest1 ~/vm-disk1.xml
   ```

**验证**

- ​							在虚拟机的客户机操作系统中，确认磁盘镜像已作为未格式化的磁盘和未分配的磁盘可用。 					

### 14.5.3. 使用 CLI 删除存储卷

​					要从主机系统中删除存储卷，您必须停止池并删除它的 XML 定义。 			

**先决条件**

- ​							任何使用您要删除的存储卷的虚拟机都会被关闭。 					

**流程**

1. ​							使用 `virsh vol-list` 命令列出指定存储池中的存储卷。 					

   ```none
   # virsh vol-list --pool RHEL-SP
    Name                 Path
   ---------------------------------------------------------------
    .bash_history        /home/VirtualMachines/.bash_history
    .bash_logout         /home/VirtualMachines/.bash_logout
    .bash_profile        /home/VirtualMachines/.bash_profile
    .bashrc              /home/VirtualMachines/.bashrc
    .git-prompt.sh       /home/VirtualMachines/.git-prompt.sh
    .gitconfig           /home/VirtualMachines/.gitconfig
    vm-disk1             /home/VirtualMachines/vm-disk1
   ```

2. ​							**可选** ：使用 `virsh vol-wipe` 命令擦除存储卷。例如，要擦除与存储池 `RHEL-SP` 关联的名为 `vm-disk1` 的存储卷： 					

   ```none
   # virsh vol-wipe --pool RHEL-SP vm-disk1
   Vol vm-disk1 wiped
   ```

3. ​							使用 `virsh vol-delete` 命令删除存储卷。例如，要删除与存储池 `RHEL-SP` 关联的名为 `vm-disk1` 的存储卷： 					

   ```none
   # virsh vol-delete --pool RHEL-SP vm-disk1
   Vol vm-disk1 deleted
   ```

**验证**

- ​							再次使用 `virsh vol-list` 命令，验证存储卷已被删除。 					

  ```none
  # virsh vol-list --pool RHEL-SP
   Name                 Path
  ---------------------------------------------------------------
   .bash_history        /home/VirtualMachines/.bash_history
   .bash_logout         /home/VirtualMachines/.bash_logout
   .bash_profile        /home/VirtualMachines/.bash_profile
   .bashrc              /home/VirtualMachines/.bashrc
   .git-prompt.sh       /home/VirtualMachines/.git-prompt.sh
   .gitconfig           /home/VirtualMachines/.gitconfig
  ```

## 14.6. 使用 web 控制台管理虚拟机存储卷

​				使用 RHEL，您可以管理为虚拟机(VM)分配存储的存储卷。 		

​				您可以使用 RHEL web 控制台进行： 		

- ​						[创建存储卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-storage-volumes-using-the-web-console_assembly_managing-virtual-machine-storage-volumes-using-the-web-console)。 				
- ​						[删除存储卷](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#removing-storage-volumes-using-the-web-console_assembly_managing-virtual-machine-storage-volumes-using-the-web-console)。 				

### 14.6.1. 使用 Web 控制台创建存储卷

​					要创建可正常工作的虚拟机(VM)，您需要分配了本地存储设备来保存虚拟机镜像和与虚拟机相关的数据。您可以在存储池中创建存储卷，并将其分配为作为存储磁盘的虚拟机。 			

​					要使用 Web 控制台创建存储卷，请参阅以下步骤。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							点击 Virtual Machines 选项卡顶部的 Storage Pools。此时会出现存储池窗口，显示配置的存储池列表。 					

   [![显示在主机上当前配置的所有存储池的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							在 Storage Pools 窗口中，点击您要创建存储卷的存储池。 					

   ​							行会展开，以显示包含所选存储池基本信息的 Overview 窗格。 					

   [![镜像显示所选存储池的详细信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)

3. ​							点展开行中的 Overview 选项卡旁的 Storage Volumes。 					

   ​							Storage Volume 选项卡会出现有关现有存储卷的基本信息。 					

   [![显示与所选存储池关联的存储卷列表的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc247223cd36c27e01b9382bba2b240a/cockpit_storage_volume_overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc247223cd36c27e01b9382bba2b240a/cockpit_storage_volume_overview.png)

4. ​							点创建卷。 					

   ​							此时会出现 Create Storage Volume 对话框。 					

   [![显示创建卷对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a21bb2cbb89ba46b41b31fab29b11a91/virt-cockpit-create-storage-volume.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a21bb2cbb89ba46b41b31fab29b11a91/virt-cockpit-create-storage-volume.png)

5. ​							在 Create Storage Volume 对话框中输入以下信息： 					

   - ​									**名称** - 存储卷的名称。 							
   - ​									**size** - MiB 或 GiB 存储卷的大小。 							
   - ​									**格式** - 存储卷的格式。支持的类型是 `qcow2` 和 `raw`。 							

6. ​							点击 Create。 					

   ​							存储卷已创建，创建存储卷对话框会关闭，新的存储卷会出现在存储卷列表中。 					

**其他资源**

- ​							[了解存储卷](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#storage-volumes_understanding-virtual-machine-storage) 					
- ​							[使用 web 控制台向虚拟机添加新磁盘](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#creating-and-attaching-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					

### 14.6.2. 使用 Web 控制台删除存储卷

​					您可以删除存储卷来释放存储池中的空间，或删除与失效虚拟机(VM)关联的存储项目。 			

​					要使用 RHEL web 控制台删除存储卷，请参阅以下步骤。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							任何使用您要删除的存储卷的虚拟机都会被关闭。 					

**流程**

1. ​							点击 Virtual Machines 选项卡顶部的 Storage Pools。此时会出现存储池窗口，显示配置的存储池列表。 					

   [![显示在主机上当前配置的所有存储池的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc0e5aceb979b18204dc4f6b1d5869e4/web-console-storage-pools-window.png)

2. ​							在 Storage Pools 窗口中，点击您要从中删除存储卷的存储池。 					

   ​							行会展开，以显示包含所选存储池基本信息的 Overview 窗格。 					

   [![镜像显示所选存储池的详细信息。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f4bf8f9cbfe66765e0a687dfae82409a/virt-cockpit-storage-pool-overview.png)

3. ​							点展开行中的 Overview 选项卡旁的 Storage Volumes。 					

   ​							Storage Volume 选项卡会出现有关现有存储卷的基本信息。 					

   [![显示与所选存储池关联的存储卷列表的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc247223cd36c27e01b9382bba2b240a/cockpit_storage_volume_overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/bc247223cd36c27e01b9382bba2b240a/cockpit_storage_volume_overview.png)

4. ​							选择您要删除的存储卷。 					

   [![显示选项的镜像，用于删除所选存储卷。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/879f6bfe1aab23b034439a2e8a7e3a08/cockpit_delete_storage_volume.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/879f6bfe1aab23b034439a2e8a7e3a08/cockpit_delete_storage_volume.png)

5. ​							点 Delete 1 Volume 					

**其他资源**

- ​							[了解存储卷](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/managing-storage-for-virtual-machines_configuring-and-managing-virtualization#storage-volumes_understanding-virtual-machine-storage) 					

## 14.7. 使用 web 控制台管理虚拟机存储磁盘

​				使用 RHEL，您可以管理附加到虚拟机的存储磁盘。 		

​				您可以使用 RHEL web 控制台进行： 		

- ​						[查看虚拟机磁盘信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-disk-information-in-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console)。 				
- ​						[向虚拟机添加新磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-and-attaching-disks-to-virtual-machines-using-the-rhel-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console)。 				
- ​						[将磁盘附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-existing-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console)。 				
- ​						[从虚拟机中分离磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#detaching-disks-from-virtual-machines_assembly_managing-virtual-machine-storage-disks-using-the-web-console)。 				

### 14.7.1. 在 web 控制台中查看虚拟机磁盘信息

​					 			

​					使用 web 控制台，您可以查看分配给所选虚拟机(VM)的详细信息。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							点击您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 磁盘。 					

   ​							Disks 部分显示分配给虚拟机的磁盘的信息，以及用于 **添加**、**删除** 或**编辑**磁盘的选项。 					

   [![显示所选虚拟机的磁盘用量的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)

​					该信息包括： 			

- ​							**Device** - 该磁盘的设备类型。 					
- ​							**Used** - 当前分配的磁盘数量。 					
- ​							**Capacity** - 存储卷的最大大小。 					
- ​							**Bus** - 模拟的磁盘设备类型。 					
- ​							**Access** - 磁盘为 **Writeable** 或 **Read-only**。对于 `raw` 磁盘，您也可以将访问权限设置为 **Writeable and shared**。 					
- ​							**Source** - 磁盘设备或者文件。 					

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 14.7.2. 使用 web 控制台向虚拟机添加新磁盘

​					 			

​					您可以通过创建新存储卷并使用 RHEL 9 web 控制台将其附加到虚拟机来向虚拟机添加新磁盘。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，点击您要为其创建并附加新磁盘的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 磁盘。 					

   ​							Disks 部分显示分配给虚拟机的磁盘的信息，以及用于 **添加**、**删除** 或**编辑**磁盘的选项。 					

   [![显示所选虚拟机的磁盘用量的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)

3. ​							点 Add Disk。 					

   ​							此时会出现 Add Disk 对话框。 					

   ​							[![Image displaying the Add Disk dialog box.](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ae4927e577648165eb71d741cde570c9/virt-cockpit-add-disk.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ae4927e577648165eb71d741cde570c9/virt-cockpit-add-disk.png) 						

4. ​							选择 *Create New* 选项。 					

5. ​							配置新磁盘。 					

   - ​									**Pool** - 选择创建虚拟磁盘的存储池。 							

   - ​									**Name** - 为要创建的虚拟磁盘输入一个名称。 							

   - ​									**Size** - 输入大小并选择要创建的虚拟磁盘的单元（MiB 或 GiB）。 							

   - ​									**Format** - 选择要创建的虚拟磁盘的格式。支持的类型是 `qcow2` 和 `raw`。 							

   - ​									**Persistence** - 如果选中，虚拟磁盘是持久的。如果没有选择，虚拟磁盘就是临时的。 							

     注意

     ​										临时磁盘只能添加到正在运行的虚拟机中。 								

   - ​									**其它选项** - 为虚拟磁盘设置附加配置。 							

     - ​											**Cache** - 选择缓存机制。 									
     - ​											**Bus** - 选择要模拟的磁盘设备类型。 									

6. ​							点击 Add。 					

   ​							虚拟磁盘已创建并连接到虚拟机。 					

**其他资源**

- ​							[在 web 控制台中查看虚拟机磁盘信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-disk-information-in-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					
- ​							[使用 web 控制台将现有磁盘附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-existing-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					
- ​							[使用 web 控制台从虚拟机中分离磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#detaching-disks-from-virtual-machines_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					

### 14.7.3. 使用 web 控制台将现有磁盘附加到虚拟机

​					 			

​					使用 web 控制台，您可以将现有存储卷作为磁盘附加到虚拟机。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，点击您要为其创建并附加新磁盘的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 磁盘。 					

   ​							Disks 部分显示分配给虚拟机的磁盘的信息，以及用于 **添加**、**删除** 或**编辑**磁盘的选项。 					

   [![显示所选虚拟机的磁盘用量的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)

3. ​							点 Add Disk。 					

   ​							此时会出现 Add Disk 对话框。 					

   [![显示 Add Disk 对话框的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ae4927e577648165eb71d741cde570c9/virt-cockpit-add-disk.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ae4927e577648165eb71d741cde570c9/virt-cockpit-add-disk.png)

4. ​							点**使用现有**按钮。 					

   ​							正确的配置字段会出现在 Add Disk 对话框中。 					

   [![图像显示 Add Disk 对话框，选择了 Use Existing 选项。width=100%](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/e76f2c36a0c9d1182dde132b4fd80d72/virt-cockpit-attach-disk.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/e76f2c36a0c9d1182dde132b4fd80d72/virt-cockpit-attach-disk.png)

5. ​							为虚拟机配置磁盘。 					

   - ​									**池** - 选择要从中附加虚拟磁盘的存储池。 							
   - ​									**Volume** - 选择将被附加的存储卷。 							
   - ​									**持久性** - 虚拟机运行时可用。选中 **Always attach** 复选框，使虚拟磁盘持久存在。清除复选框，使虚拟磁盘临时设为临时。 							
   - ​									**其它选项** - 为虚拟磁盘设置附加配置。 							
     - ​											**Cache** - 选择缓存机制。 									
     - ​											**Bus** - 选择要模拟的磁盘设备类型。 									

6. ​							点 添加 					

   ​							所选虚拟磁盘附加到虚拟机。 					

**其他资源**

- ​							[在 web 控制台中查看虚拟机磁盘信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-disk-information-in-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					
- ​							[使用 web 控制台向虚拟机添加新磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-and-attaching-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					
- ​							[使用 web 控制台从虚拟机中分离磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#detaching-disks-from-virtual-machines_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					

### 14.7.4. 使用 web 控制台从虚拟机中分离磁盘

​					使用 web 控制台，您可以从虚拟机(VM)中分离磁盘。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**流程**

1. ​							在 Virtual Machines 接口中，点您要从中分离磁盘的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 磁盘。 					

   ​							Disks 部分显示分配给虚拟机的磁盘的信息，以及用于 **添加**、**删除** 或**编辑**磁盘的选项。 					

   [![显示所选虚拟机的磁盘用量的图像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/8e50855fbd710e15578ed4f41f814c8b/virt-cockpit-disk-info.png)

3. ​							点您要从虚拟机中分离的磁盘旁的删除按钮。此时会出现 `Remove Disk` 确认对话框。 					

4. ​							在确认对话框中，单击 Remove。 					

   ​							虚拟磁盘与虚拟机分离。 					

**其他资源**

- ​							[在 web 控制台中查看虚拟机磁盘信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-disk-information-in-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					
- ​							[使用 web 控制台向虚拟机添加新磁盘](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-and-attaching-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					
- ​							[使用 web 控制台将现有磁盘附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-existing-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console) 					

## 14.8. 使用 libvirt secret 保护 iSCSI 存储池

​				可以使用 `virsh` 配置用户名和密码参数来保护 iSCSI 存储池的安全。您可以在定义池之前或之后配置它，但必须启动池才能使验证设置生效。 		

​				以下提供了使用 `libvirt` secret 保护基于 iSCSI 的存储池的说明。 		

注意

​					如果在创建 iSCSI 目标时定义了 `*user_ID*` 和 `*password*`，则需要这个过程。 			

**先决条件**

- ​						确保您已创建了基于 iSCSI 的存储池。如需更多信息，请参阅 [第 14.2.5 节 “使用 CLI 创建基于 iSCSI 的存储池”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-iscsi-based-storage-pools-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli)。 				

**流程**

1. ​						使用质询身份验证协议(CHAP)用户名创建 libvirt secret 文件。例如： 				

   ```xml
   <secret ephemeral='no' private='yes'>
       <description>Passphrase for the iSCSI example.com server</description>
       <usage type='iscsi'>
           <target>iscsirhel7secret</target>
       </usage>
   </secret>
   ```

2. ​						使用 `virsh secret-define` 命令定义 libvirt secret。 				

   ​						`# **virsh secret-define** *secret.xml*` 				

3. ​						使用 `virsh secret-list` 命令验证 UUID。 				

   ```none
   # virsh secret-list
   UUID                                  Usage
   -------------------------------------------------------------------
   2d7891af-20be-4e5e-af83-190e8a922360  iscsi iscsirhel7secret
   ```

4. ​						使用 `virsh secret-set-value` 命令，为上一步输出中的 UUID 分配 secret。这样可保证 CHAP 用户名和密码位于由 libvirt 控制的 secret 列表中。例如： 				

   ```none
   # virsh secret-set-value --interactive 2d7891af-20be-4e5e-af83-190e8a922360
   Enter new value for secret:
   Secret value set
   ```

5. ​						使用 `virsh edit` 命令在存储池的 XML 文件中添加身份验证条目，并添加 `**<auth>**` 元素，指定 `**authentication type**`, `**username**`, 和 `**secret usage**`。 				

   ​						例如： 				

   ```xml
   <pool type='iscsi'>
     <name>iscsirhel7pool</name>
       <source>
          <host name='192.168.122.1'/>
          <device path='iqn.2010-05.com.example.server1:iscsirhel7guest'/>
          <auth type='chap' username='redhat'>
             <secret usage='iscsirhel7secret'/>
          </auth>
       </source>
     <target>
       <path>/dev/disk/by-path</path>
     </target>
   </pool>
   ```

   注意

   ​							`**<auth>**` 子元素存在于虚拟机的 `**<pool>**` 和 `**<disk>**` XML 元素的不同位置。对于 `**<pool>**`，`**<auth>**` 在 `**<source>**` 元素中指定，这描述了查找池源的位置，因为身份验证是某些池源（iSCSI 和 RBD）的属性。对于 `**<disk>**`，它是域的子元素，对 iSCSI 或 RBD 磁盘的身份验证是磁盘的属性。另外，磁盘的 `**<auth>**` 子元素与存储池的不同。 					

   ```xml
   <auth username='redhat'>
     <secret type='iscsi' usage='iscsirhel7secret'/>
   </auth>
   ```

6. ​						要激活更改，激活存储池。如果池已启动，停止并重启存储池： 				

   ```none
   # virsh pool-destroy iscsirhel7pool
   # virsh pool-start iscsirhel7pool
   ```

## 14.9. 创建 vHBA

​				虚拟主机总线适配器(vHBA)设备将主机系统连接到 SCSI 设备，这是创建基于 SCSI 的存储池所需要的。 		

​				您可以通过在 XML 配置文件中定义来创建 vHBA 设备。 		

**流程**

1. ​						使用 `virsh nodedev-list --cap vports` 命令在主机系统中找到 HBA。 				

   ​						以下示例显示了支持 vHBA 的两个 HBA 的主机： 				

   ```none
   # virsh nodedev-list --cap vports
   scsi_host3
   scsi_host4
   ```

2. ​						使用 `virsh nodedev-dumpxml *HBA_device*命令查看 HBA` 的详情。 				

   ```none
   # virsh nodedev-dumpxml scsi_host3
   ```

   ​						命令的输出列出了 `<name>`, `<wwnn>`, 和 `<wwpn>` 字段，用于创建 vHBA。`<max_vports>` 显示支持的 vHBA 的最大数量。例如： 				

   ```xml
   <device>
     <name>scsi_host3</name>
     <path>/sys/devices/pci0000:00/0000:00:04.0/0000:10:00.0/host3</path>
     <parent>pci_0000_10_00_0</parent>
     <capability type='scsi_host'>
       <host>3</host>
       <unique_id>0</unique_id>
       <capability type='fc_host'>
         <wwnn>20000000c9848140</wwnn>
         <wwpn>10000000c9848140</wwpn>
         <fabric_wwn>2002000573de9a81</fabric_wwn>
       </capability>
       <capability type='vport_ops'>
         <max_vports>127</max_vports>
         <vports>0</vports>
       </capability>
     </capability>
   </device>
   ```

   ​						在这个示例中，`<max_vports>` 值显示在 HBA 配置中可以使用总计 127 个虚拟端口。`<vports>` 值显示当前使用的虚拟端口数。这些值在创建 vHBA 后更新。 				

3. ​						为 vHBA 主机创建类似如下的 XML 文件。在这些示例中，该文件名为 `vhba_host3.xml`。 				

   ​						这个示例使用 `**scsi_host3**` 来描述父 vHBA。 				

   ```xml
   <device>
     <parent>scsi_host3</parent>
     <capability type='scsi_host'>
       <capability type='fc_host'>
       </capability>
     </capability>
   </device>
   ```

   ​						这个示例使用 WWNN/WWPN 对描述父 vHBA。 				

   ```xml
   <device>
     <name>vhba</name>
     <parent wwnn='20000000c9848140' wwpn='10000000c9848140'/>
     <capability type='scsi_host'>
       <capability type='fc_host'>
       </capability>
     </capability>
   </device>
   ```

   注意

   ​							WWNN 和 WWPN 值必须与上一步中 HBA 详情中的值匹配。 					

   ​						`<parent>` 字段指定要与这个 vHBA 设备关联的 HBA 设备。`<device>` 标签中的详情在下一步中使用，为主机创建新 vHBA 设备。如需有关 `nodedev` XML 格式的更多信息，请参阅 [libvirt 上游页面](https://libvirt.org/formatnode.html)。 				

   注意

   ​							`virsh` 命令不提供定义 `parent_wwnn`, `parent_wwpn`, or `parent_fabric_wwn` 属性的方法。 					

4. ​						使用 `virsh nodev-create` 命令，基于上一步中创建的 XML 文件创建 VHBA。 				

   ```none
   # virsh nodedev-create vhba_host3
   Node device scsi_host5 created from vhba_host3.xml
   ```

**验证**

- ​						使用 `virsh nodedev-dumpxml` 命令验证新的 vHBA 的详情(scsi_host5)）： 				

  ```none
  # virsh nodedev-dumpxml scsi_host5
  <device>
    <name>scsi_host5</name>
    <path>/sys/devices/pci0000:00/0000:00:04.0/0000:10:00.0/host3/vport-3:0-0/host5</path>
    <parent>scsi_host3</parent>
    <capability type='scsi_host'>
      <host>5</host>
      <unique_id>2</unique_id>
      <capability type='fc_host'>
        <wwnn>5001a4a93526d0a1</wwnn>
        <wwpn>5001a4ace3ee047d</wwpn>
        <fabric_wwn>2002000573de9a81</fabric_wwn>
      </capability>
    </capability>
  </device>
  ```

**其他资源**

- ​						[通过 CLI，创建带有 vHBA 设备的基于 SCSI 的存储池](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-scsi-based-storage-pools-with-vhba-devices-using-the-cli_assembly_managing-virtual-machine-storage-pools-using-the-cli) 				

# 第 15 章 在虚拟机中管理 GPU 设备

​			要在 RHEL 9 主机上增强虚拟机(VM)的图形性能，您可以将主机 GPU 分配给虚拟机。 	

- ​					您可以从主机中分离 GPU，并将 GPU 直接控制传递给虚拟机。 			
- ​					您可以从物理 GPU 创建多个介质设备，并将这些设备指定为虚拟 GPU(vGPU)到多个客户端。这目前只在所选 NVIDIA GPU 上被支持，一个介质设备只能分配给一个客户端。 			

## 15.1. 为虚拟机分配 GPU

​				要访问和控制附加到主机系统的 GPU，您必须配置主机系统，将 GPU 直接控制传递给虚拟机(VM)。 		

注意

​					如果您要查找有关分配虚拟 GPU 的信息，请参阅 [第 15.2 节 “管理 NVIDIA vGPU 设备”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_managing-nvidia-vgpu-devices_assembly_managing-gpu-devices-in-virtual-machines)。 			

**先决条件**

- ​						您必须在主机机器内核中启用 IOMMU 支持。 				

  - ​								在 Intel 主机上，您必须启用 VT-d： 						

    1. ​										使用 `intel_iommu=on` 和 `iommu=pt` 参数重新生成 GRUB 配置： 								

       ```none
       # grubby --args="intel_iommu=on iommu_pt" --update-kernel DEFAULT
       ```

    2. ​										重启主机。 								

  - ​								在 AMD 主机上，您必须启用 AMD-Vi。 						

    ​								请注意，在 AMD 主机上，IOMMU 被默认启用，您可以添加 `iommu=pt` 来将其切换到 pass-through 模式： 						

    1. ​										使用 `iommu=pt` 参数重新生成 GRUB 配置： 								

       ```none
       # grubby --args="iommu=pt" --update-kernel DEFAULT
       ```

       注意

       ​											`pt` 选项只为使用直通模式的设备启用 IOMMU，并提供更高的主机性能。但是，并非所有硬件都支持这个选项。您仍然可以分配是否启用了这个选项的设备。 									

    2. ​										重启主机。 								

**流程**

1. ​						防止驱动程序绑定到 GPU。 				

   1. ​								识别 GPU 附加到的 PCI 总线地址。 						

      ```none
      # lspci -Dnn | grep VGA
      0000:02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK106GL [Quadro K4000] [10de:11fa] (rev a1)
      ```

   2. ​								防止主机的图形驱动程序使用 GPU。要做到这一点，使用 GPU 的 PCI ID 和 pci-stub 驱动程序。 						

      ​								例如，以下命令可防止驱动程序绑定到 **10de:11fa** 总线附加的 GPU： 						

      ```none
      # grubby --args="pci-stub.ids=10de:11fa" --update-kernel DEFAULT
      ```

   3. ​								重启主机。 						

2. ​						**可选：**如果某些 GPU 功能（如音频）因为支持限制而无法传递给虚拟机，您可以在 IOMMU 组中修改端点的驱动程序绑定，以只通过所需的 GPU 功能。 				

   1. ​								将 GPU 设置转换为 XML，并记录您要阻止附加到主机驱动程序的端点的 PCI 地址。 						

      ​								要做到这一点，通过将 `pci_` 前缀添加到地址，并将 GPU 的 PCI 总线地址转换为 libvirt 兼容格式，并将分隔符转换为下划线。 						

      ​								例如，以下命令显示在 `0000:02:00.0` 总线地址附加的 GPU 的 XML 配置。 						

      ```none
      # virsh nodedev-dumpxml pci_0000_02_00_0
      ```

      ```xml
      <device>
       <name>pci_0000_02_00_0</name>
       <path>/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0</path>
       <parent>pci_0000_00_03_0</parent>
       <driver>
        <name>pci-stub</name>
       </driver>
       <capability type='pci'>
        <domain>0</domain>
        <bus>2</bus>
        <slot>0</slot>
        <function>0</function>
        <product id='0x11fa'>GK106GL [Quadro K4000]</product>
        <vendor id='0x10de'>NVIDIA Corporation</vendor>
        <iommuGroup number='13'>
         <address domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
         <address domain='0x0000' bus='0x02' slot='0x00' function='0x1'/>
        </iommuGroup>
        <pci-express>
         <link validity='cap' port='0' speed='8' width='16'/>
         <link validity='sta' speed='2.5' width='16'/>
        </pci-express>
       </capability>
      </device>
      ```

   2. ​								防止端点附加到主机驱动程序。 						

      ​								在本例中，要将 GPU 分配给虚拟机，防止与音频功能对应的端点，`<address domain='0x0000' bus='0x02' slot='0x00' function='0x1'/>`，连接至主机音频驱动程序，而是将端点附加到 VFIO-PCI。 						

      ```none
      # driverctl set-override 0000:02:00.1 vfio-pci
      ```

3. ​						将 GPU 附加到虚拟机 				

   1. ​								使用 PCI 总线地址为 GPU 创建 XML 配置文件。 						

      ​								例如，您可以使用来自 GPU 总线地址的参数，创建以下 XML 文件 GPU-Assign.xml。 						

      ```xml
      <hostdev mode='subsystem' type='pci' managed='yes'>
       <driver name='vfio'/>
       <source>
        <address domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
       </source>
      </hostdev>
      ```

   2. ​								将文件保存到主机系统中。 						

   3. ​								将文件与虚拟机的 XML 配置合并。 						

      ​								例如，以下命令将 GPU XML 文件 GPU-Assign.xml 与 `System1` 虚拟机的 XML 配置文件合并。 						

      ```none
      # virsh attach-device System1 --file /home/GPU-Assign.xml --persistent
      Device attached successfully.
      ```

      注意

      ​									GPU 作为二级图形设备附加到虚拟机。不支持将 GPU 分配为主图形设备，红帽不推荐在虚拟机 XML 配置中删除主仿真图形设备。 							

**验证**

- ​						该设备会出现在虚拟机的 XML 配置中。 				

**已知问题**

- ​						将 NVIDIA GPU 设备附加到使用 RHEL 9 客户机操作系统的虚拟机当前禁用该虚拟机上的 Wayland 会话，并改为加载 Xorg 会话。这是因为 NVIDIA 驱动程序和 Wayland 之间的不兼容。 				

## 15.2. 管理 NVIDIA vGPU 设备

​				vGPU 功能可使物理 NVIDIA GPU 设备划分为多个虚拟设备，称为 `介质设备`。然后可将这些 mediated devices 分配给多个虚拟机（VM）作为虚拟 GPU。因此，这些虚拟机可以共享单个物理 GPU 的性能。 		

重要

​					为虚拟机分配物理 GPU，使用介质设备或不使用介质设备，使得主机无法使用 GPU。 			

### 15.2.1. 设置 NVIDIA vGPU 设备

​					要设置 NVIDIA vGPU 功能，您需要为 GPU 设备下载 NVIDIA vGPU 驱动程序，创建介质设备，并将其分配给预期的虚拟机。具体步骤请查看以下说明。 			

**先决条件**

- ​							您的 GPU 支持 vGPU 介质设备。有关支持创建 vGPU 的 NVIDIA GPU 的最新列表，请参阅 [NVIDIA vGPU 软件文档](https://docs.nvidia.com/grid/latest/grid-vgpu-release-notes-red-hat-el-kvm/index.html#validated-platforms)。 					

  - ​									如果您不知道您的主机正在使用哪个 GPU，请安装 *lshw* 软件包并使用 `lshw -C display` 命令。以下示例显示系统使用与 vGPU 兼容的 NVIDIA Tesla P4 GPU。 							

    ```none
    # lshw -C display
    
    *-display
           description: 3D controller
           product: GP104GL [Tesla P4]
           vendor: NVIDIA Corporation
           physical id: 0
           bus info: pci@0000:01:00.0
           version: a1
           width: 64 bits
           clock: 33MHz
           capabilities: pm msi pciexpress cap_list
           configuration: driver=vfio-pci latency=0
           resources: irq:16 memory:f6000000-f6ffffff memory:e0000000-efffffff memory:f0000000-f1ffffff
    ```

**流程**

1. ​							下载 NVIDIA vGPU 驱动程序并在您的系统中安装它们。具体步骤请查看 [NVIDIA 文档](https://docs.nvidia.com/grid/latest/grid-software-quick-start-guide/index.html#getting-your-nvidia-grid-software)。 					

2. ​							如果 NVIDIA 软件安装程序没有创建 **/etc/modprobe.d/nvidia-installer-disable-nouveau.conf** 文件，请在 **/etc/modprobe.d/** 中创建任意名称的 `conf` 文件，并在文件中添加以下行： 					

   ```none
   blacklist nouveau
   options nouveau modeset=0
   ```

3. ​							为当前内核重新生成初始 ramdisk，然后重新启动。 					

   ```none
   # dracut --force
   # reboot
   ```

4. ​							检查内核是否已加载 `nvidia_vgpu_vfio` 模块，并且 `nvidia-vgpu-mgr.service` 服务正在运行。 					

   ```none
   # lsmod | grep nvidia_vgpu_vfio
   nvidia_vgpu_vfio 45011 0
   nvidia 14333621 10 nvidia_vgpu_vfio
   mdev 20414 2 vfio_mdev,nvidia_vgpu_vfio
   vfio 32695 3 vfio_mdev,nvidia_vgpu_vfio,vfio_iommu_type1
   
   # systemctl status nvidia-vgpu-mgr.service
   nvidia-vgpu-mgr.service - NVIDIA vGPU Manager Daemon
      Loaded: loaded (/usr/lib/systemd/system/nvidia-vgpu-mgr.service; enabled; vendor preset: disabled)
      Active: active (running) since Fri 2018-03-16 10:17:36 CET; 5h 8min ago
    Main PID: 1553 (nvidia-vgpu-mgr)
    [...]
   ```

   ​							另外，如果基于 NVIDIA Ampere GPU 设备创建 vGPU，请确保为物理 GPU 启用虚拟功能。具体步骤请查看 [NVIDIA 文档](https://docs.nvidia.com/grid/latest/grid-vgpu-user-guide/index.html#creating-sriov-vgpu-device-red-hat-el-kvm)。 					

5. ​							生成设备 UUID。 					

   ```none
   # uuidgen
   30820a6f-b1a5-4503-91ca-0c10ba58692a
   ```

6. ​							根据检测到的 GPU 硬件，使用 mediated 设备配置准备 XML 文件。例如，以下命令会在 0000:01:00.0 PCI 总线上运行的 NVIDIA Tesla P4 卡中配置 `nvidia-63` vGPU 类型的介质设备，并使用上一步中生成的 UUID。 					

   ```xml
   <device>
       <parent>pci_0000_01_00_0</parent>
       <capability type="mdev">
           <type id="nvidia-63"/>
           <uuid>30820a6f-b1a5-4503-91ca-0c10ba58692a</uuid>
       </capability>
   </device>
   ```

7. ​							根据您准备的 XML 文件定义 vGPU 介质设备。例如： 					

   ```none
   # virsh nodedev-define vgpu-test.xml
   Node device mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0 created from vgpu-test.xml
   ```

8. ​							**可选：**验证介质设备是否被列为 inactive。 					

   ```none
   # virsh nodedev-list --cap mdev --inactive
   mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   ```

9. ​							启动您创建的 vGPU 介质设备。 					

   ​							 					

   ```none
   # virsh nodedev-start mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Device mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0 started
   ```

10. ​							**可选：**确保介质设备被列为 active。 					

    ```none
    # virsh nodedev-list --cap mdev
    mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
    ```

11. ​							将 vGPU 设备设置为在主机重启后自动启动 					

    ```none
    # virsh nodedev-autostart mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
    Device mdev_d196754e_d8ed_4f43_bf22_684ed698b08b_0000_9b_00_0 marked as autostarted
    ```

12. ​							将 mediated 设备附加到要共享 vGPU 资源的虚拟机。要做到这一点，请将以下行以及之前生成的 UUID 添加到虚拟机 XML 配置的 **<devices/>** 部分。 					

    ​							 					

    ```xml
    <hostdev mode='subsystem' type='mdev' managed='no' model='vfio-pci' display='on'>
      <source>
        <address uuid='30820a6f-b1a5-4503-91ca-0c10ba58692a'/>
      </source>
    </hostdev>
    ```

    ​							请注意，每个 UUID 每次只能分配给一个虚拟机。另外，如果虚拟机没有 QEMU 视频设备，如 `virtio-vga`，在 `<hostdev>` 行中添加 `ramfb='on'` 参数。 					

13. ​							有关在分配的虚拟机上可用的 vGPU 介质设备的完整功能，请在虚拟机上设置 NVIDIA vGPU 客户端软件许可。有关详情和说明，请参阅 [NVIDIA Virtual GPU Software License Server User Guide](https://docs.nvidia.com/grid/ls/latest/grid-license-server-user-guide/index.html#installing-nvidia-grid-license-server)。 					

**验证**

1. ​							查询您创建的 vGPU 的功能，并确保它列为 active 和 persistent。 					

   ```none
   # virsh nodedev-info mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Name:           virsh nodedev-autostart mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Parent:         pci_0000_01_00_0
   Active:         yes
   Persistent:     yes
   Autostart:      yes
   ```

2. ​							启动虚拟机并验证客户端操作系统是否检测到 mediated device 作为 NVIDIA GPU。例如，如果虚拟机使用 Linux： 					

   ```none
   # lspci -d 10de: -k
   07:00.0 VGA compatible controller: NVIDIA Corporation GV100GL [Tesla V100 SXM2 32GB] (rev a1)
           Subsystem: NVIDIA Corporation Device 12ce
           Kernel driver in use: nvidia
           Kernel modules: nouveau, nvidia_drm, nvidia
   ```

**已知问题**

- ​							将 NVIDIA vGPU 介质设备分配给使用 RHEL 9 客户机操作系统的虚拟机当前禁用该虚拟机上的 Wayland 会话，并改为载入 Xorg 会话。这是因为 NVIDIA 驱动程序和 Wayland 之间的不兼容。 					

**其他资源**

- ​							[NVIDIA vGPU 软件文档](https://docs.nvidia.com/grid/latest/grid-vgpu-release-notes-red-hat-el-kvm/index.html#validated-platforms) 					
- ​							`man virsh` 命令 					

### 15.2.2. 删除 NVIDIA vGPU 设备

​					要更改[分配的 vGPU 介质设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_setting-up-nvidia-vgpu-devices_assembly_managing-nvidia-vgpu-devices) 的配置，您需要从分配的虚拟机中删除现有设备。具体步骤请查看以下操作： 			

**先决条件**

- ​							要从中删除该设备的虚拟机关闭。 					

**流程**

1. ​							获取您要删除的介质设备的 ID。 					

   ```none
   # virsh nodedev-list --cap mdev
   mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   ```

2. ​							停止 vGPU mediated 设备的运行实例。 					

   ```none
   # virsh nodedev-destroy mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Destroyed node device 'mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0'
   ```

3. ​							**可选：**确定已取消激活介质设备。 					

   ```none
   # virsh nodedev-info mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Name:           virsh nodedev-autostart mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Parent:         pci_0000_01_00_0
   Active:         no
   Persistent:     yes
   Autostart:      yes
   ```

4. ​							从虚拟机 XML 配置中删除该设备。要做到这一点，使用 `virsh edit` 实用程序编辑虚拟机的 XML 配置，并删除 mdev 的配置片段。这个片段类似如下： 					

   ```xml
   <hostdev mode='subsystem' type='mdev' managed='no' model='vfio-pci'>
     <source>
       <address uuid='30820a6f-b1a5-4503-91ca-0c10ba58692a'/>
     </source>
   </hostdev>
   ```

   ​							请注意，停止和分离 mediated 设备不会删除它，而是将其保留为 **defined**。因此，您可以[重启](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#starting-nvidia-vgpu-devices_assembly_managing-nvidia-vgpu-devices)并把设备[附加](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-nvidia-vgpu-devices_assembly_managing-nvidia-vgpu-devices)到不同的虚拟机。 					

5. ​							**可选：**要删除已停止的介质设备，请删除其定义。 					

   ```none
   # virsh nodedev-undefine mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
   Undefined node device 'mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0'
   ```

**验证**

- ​							如果您只停止和分离该设备，请确保介质设备被列为 inactive。 					

  ```none
  # virsh nodedev-list --cap mdev --inactive
  mdev_30820a6f_b1a5_4503_91ca_0c10ba58692a_0000_01_00_0
  ```

- ​							如果您也删除了该设备，请确保以下命令不会显示它。 					

  ```none
  # virsh nodedev-list --cap mdev
  ```

**其他资源**

- ​							`man virsh` 命令 					

### 15.2.3. 获取有关您系统的 NVIDIA vGPU 信息

​					要评估可用的 vGPU 功能的功能，您可以获取有关系统中介质设备的附加信息，例如： 			

- ​							可创建给定类型的 mediated 设备 					
- ​							您的系统中已经配置了哪些介质设备。 					

**流程**

- ​							要查看您主机上可以支持 vGPU 介质设备的可用 GPU 设备，请使用 `virsh nodedev-list --cap mdev_types` 命令。例如，下面显示了有两个 NVIDIA Quadro RTX6000 设备的系统。 					

  ```none
  # virsh nodedev-list --cap mdev_types
  pci_0000_5b_00_0
  pci_0000_9b_00_0
  ```

- ​							要显示特定 GPU 设备支持的 vGPU 类型以及其他元数据，请使用 `virsh nodedev-dumpxml` 命令。 					

  ```none
  # virsh nodedev-dumpxml pci_0000_9b_00_0
  <device>
    <name>pci_0000_9b_00_0</name>
    <path>/sys/devices/pci0000:9a/0000:9a:00.0/0000:9b:00.0</path>
    <parent>pci_0000_9a_00_0</parent>
    <driver>
      <name>nvidia</name>
    </driver>
    <capability type='pci'>
      <class>0x030000</class>
      <domain>0</domain>
      <bus>155</bus>
      <slot>0</slot>
      <function>0</function>
      <product id='0x1e30'>TU102GL [Quadro RTX 6000/8000]</product>
      <vendor id='0x10de'>NVIDIA Corporation</vendor>
      <capability type='mdev_types'>
        <type id='nvidia-346'>
          <name>GRID RTX6000-12C</name>
          <deviceAPI>vfio-pci</deviceAPI>
          <availableInstances>2</availableInstances>
        </type>
        <type id='nvidia-439'>
          <name>GRID RTX6000-3A</name>
          <deviceAPI>vfio-pci</deviceAPI>
          <availableInstances>8</availableInstances>
        </type>
        [...]
        <type id='nvidia-440'>
          <name>GRID RTX6000-4A</name>
          <deviceAPI>vfio-pci</deviceAPI>
          <availableInstances>6</availableInstances>
        </type>
        <type id='nvidia-261'>
          <name>GRID RTX6000-8Q</name>
          <deviceAPI>vfio-pci</deviceAPI>
          <availableInstances>3</availableInstances>
        </type>
      </capability>
      <iommuGroup number='216'>
        <address domain='0x0000' bus='0x9b' slot='0x00' function='0x3'/>
        <address domain='0x0000' bus='0x9b' slot='0x00' function='0x1'/>
        <address domain='0x0000' bus='0x9b' slot='0x00' function='0x2'/>
        <address domain='0x0000' bus='0x9b' slot='0x00' function='0x0'/>
      </iommuGroup>
      <numa node='2'/>
      <pci-express>
        <link validity='cap' port='0' speed='8' width='16'/>
        <link validity='sta' speed='2.5' width='8'/>
      </pci-express>
    </capability>
  </device>
  ```

**其他资源**

- ​							`man virsh` 命令 					

### 15.2.4. 用于 NVIDIA vGPU 的远程桌面流服务

​					在启用了 NVIDIA vGPU 或 NVIDIA GPU passthrough 的 RHEL 9 管理程序中支持以下远程桌面流服务： 			

- ​							**HP ZCentral Remote Boost/Teradici** 					
- ​							**NICE DCV** 					
- ​							**Mechdyne TGX** 					

​					有关支持详情请查看适当的供应商支持列表。 			

### 15.2.5. 其他资源

- ​							[NVIDIA vGPU 软件文档](https://docs.nvidia.com/grid/latest/grid-vgpu-release-notes-red-hat-el-kvm/index.html#validated-platforms) 					

# 第 16 章 配置虚拟机网络连接

​			要使虚拟机(VM)通过网络连接到主机、主机上的其他虚拟机以及外部网络中的位置，必须相应地配置虚拟机网络。为了提供虚拟机网络，RHEL 9 管理程序和新创建的虚拟机具有默认网络配置，也可以进一步修改。例如： 	

- ​					您可以在主机上启用虚拟机，并通过主机以外的位置发现和连接到主机，就像虚拟机与主机位于同一个网络中。 			
- ​					您可以部分或完全将虚拟机与入站网络流量隔离，以提高其安全性，并最大程度降低出现虚拟机影响主机的风险。 			

​			以下小节解释了各种类型的虚拟机网络配置，并提供了设置所选虚拟机网络配置的说明。 	

## 16.1. 了解虚拟网络

​				虚拟机(VM)连接到网络中的其他设备和位置必须被主机硬件辅助。以下小节解释了虚拟机网络连接的机制，并描述了默认虚拟机网络设置。 		

### 16.1.1. 虚拟网络的工作方式

​					虚拟网络使用了虚拟网络交换机的概念。虚拟网络交换机是在主机机器中运行的软件构造。VM 通过虚拟网络交换机连接到网络。根据虚拟交换机的配置，虚拟机可以使用由虚拟机监控程序管理的现有虚拟网络，或者不同的网络连接方法。 			

​					下图显示了将两个虚拟机连接到网络的虚拟网络交换机： 			

[![vn 02 switchandtwoguests](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fc76a191270bd678fb6272a73e7a1014/vn-02-switchandtwoguests.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/fc76a191270bd678fb6272a73e7a1014/vn-02-switchandtwoguests.png)

​					从客户端操作系统的角度来看，虚拟网络连接与物理网络连接相同。主机虚拟机将虚拟网络交换机视为网络接口。当 `virtnetworkd` 服务首次安装并启动时，它会创建 **virbr0**，即虚拟机的默认网络接口。 			

​					要查看有关此接口的信息，请使用主机上的 `ip` 工具。 			

```none
$ ip addr show virbr0
3: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state
 UNKNOWN link/ether 1b:c4:94:cf:fd:17 brd ff:ff:ff:ff:ff:ff
 inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
```

​					默认情况下，单一主机上的所有虚拟机都连接到名为 **default** 的同一 [NAT-type](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-network-address-translation_types-of-virtual-machine-network-connections) 虚拟网络，它使用 **virbr0** 接口。详情请查看 [第 16.1.2 节 “虚拟网络默认配置”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-default-configuration_understanding-virtual-networking-overview)。 			

​					对于从虚拟机进行基础出站网络访问，通常不需要额外的网络设置，因为默认网络会与 `libvirt-daemon-config-network` 软件包一起安装，并在启动 `virtnetworkd` 服务时自动启动。 			

​					如果需要不同的虚拟机网络功能，您可以创建额外的虚拟网络和网络接口，并将虚拟机配置为使用它们。除了默认的 NAT 外，也可以将这些网络和接口配置为使用以下模式之一： 			

- ​							[路由模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-routed-mode_types-of-virtual-machine-network-connections) 					
- ​							[网桥模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-bridged-mode_types-of-virtual-machine-network-connections) 					
- ​							[隔离模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-isolated-mode_types-of-virtual-machine-network-connections) 					
- ​							[开放模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-open-mode_types-of-virtual-machine-network-connections) 					

### 16.1.2. 虚拟网络默认配置

​					当在虚拟化主机上安装 `virtnetworkd` 服务时，它会在网络地址转换(NAT)模式中包含初始虚拟网络配置。默认情况下，主机上的所有虚拟机都连接到同一 `libvirt` 虚拟网络，名为 **default**。此网络上的虚拟机可以连接到主机以及主机之外的网络中的位置，但有以下限制： 			

- ​							网络中的虚拟机对于主机及主机上的其他虚拟机是可见的，但网络流量会受到客户端操作系统网络堆栈中的防火墙的控制，并可以由附加到客户端接口的 `libvirt` 网络过滤规则进行控制。 					
- ​							网络上的虚拟机可以连接到主机以外的位置，但对它们不可见。出站流量受 NAT 规则以及主机系统的防火墙影响。 					

​					下图演示了默认虚拟机网络配置： 			

[![vn 08 网络概述](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/107d0a45e24f098d2ea64be62898e9dc/vn-08-network-overview.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/107d0a45e24f098d2ea64be62898e9dc/vn-08-network-overview.png)

## 16.2. 使用 web 控制台管理虚拟机网络接口

​				使用 RHEL 9 web 控制台，您可以管理连接到 web 控制台的虚拟机的虚拟网络接口。您可以： 		

- ​						[查看网络接口信息并编辑它们](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-and-editing-virtual-network-interface-information-in-the-web-console_managing-virtual-machine-network-interfaces-using-the-web-console)。 				
- ​						[将网络接口添加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-connecting-virtual-network-interfaces-in-the-web-console_managing-virtual-machine-network-interfaces-using-the-web-console)，并[断开连接或删除接口](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#disconnecting-and-removing-virtual-network-interfaces-in-the-web-console_managing-virtual-machine-network-interfaces-using-the-web-console)。 				

### 16.2.1. 在 web 控制台中查看和编辑虚拟网络接口信息

​					使用 RHEL 9 web 控制台，您可以在所选虚拟机(VM)上查看和修改虚拟网络接口： 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 网络接口. 					

   ​							Networks Interfaces 部分显示关于为虚拟机配置的虚拟网络接口的信息，以及用于 **添加**、**删除**、**编辑** 或**拔出**网络接口的选项。 					

   [![显示所选虚拟机的网络接口详细信息的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/986ffadd1eddbd6f7c8f5de0010fe49e/virt-cockpit-vNIC-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/986ffadd1eddbd6f7c8f5de0010fe49e/virt-cockpit-vNIC-info.png)

   ​							+ 该信息包括： 					

   - ​									**类型** - 虚拟机的网络接口类型。类型包括虚拟网络、网桥到 LAN 以及直接附加。 							

     注意

     ​										RHEL 9 及更高版本不支持通用以太网连接。 								

   - ​									**型号类型** - 虚拟网络接口的型号。 							

   - ​									**MAC 地址** - 虚拟网络接口的 MAC 地址。 							

   - ​									**IP 地址** - 虚拟网络接口的 IP 地址。 							

   - ​									**Source** - 网络接口源。这取决于网络类型。 							

   - ​									**State** - 虚拟网络接口的状态。 							

3. ​							要编辑虚拟网络接口设置，请点 Edit。此时会打开「虚拟网络接口设置」对话框。 					

   [![镜像显示可为所选网络接口编辑的各种选项。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/9783ff22db053b2d7939f2dd555695f1/virt-cockpit-edit-network-if.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/9783ff22db053b2d7939f2dd555695f1/virt-cockpit-edit-network-if.png)

4. ​							更改接口类型、源、型号或 MAC 地址。 					

5. ​							点击 Save。已修改网络接口。 					

   注意

   ​								对虚拟网络接口设置的更改仅在重启虚拟机后生效。 						

   ​								另外，只有在虚拟机关闭时，才能修改 MAC 地址。 						

**其他资源**

- ​							[使用 web 控制台查看虚拟机信息](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-vm-information-using-the-rhel-web-console_viewing-information-about-virtual-machines) 					

### 16.2.2. 在 web 控制台中添加和连接虚拟网络接口

​					使用 RHEL 9 web 控制台，您可以创建一个虚拟网络接口并连接虚拟机(VM)。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 网络接口. 					

   ​							Networks Interfaces 部分显示关于为虚拟机配置的虚拟网络接口的信息，以及用于 **添加**、**删除**、**编辑**或**插入**网络接口的选项。 					

3. ​							点您要连接的虚拟网络接口行中的 Plug。 					

   ​							所选虚拟网络接口连接至虚拟机。 					

### 16.2.3. 在 web 控制台中断开和删除虚拟网络接口

​					使用 RHEL 9 web 控制台，您可以断开连接到所选虚拟机的虚拟网络接口。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							滚动到 网络接口. 					

   ​							Networks Interfaces 部分显示关于为虚拟机配置的虚拟网络接口的信息，以及用于 **添加**、**删除**、**编辑** 或**拔出**网络接口的选项。 					

   [![显示所选虚拟机的网络接口详细信息的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/986ffadd1eddbd6f7c8f5de0010fe49e/virt-cockpit-vNIC-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/986ffadd1eddbd6f7c8f5de0010fe49e/virt-cockpit-vNIC-info.png)

3. ​							在您要断开连接的虚拟网络接口行中点 Unplug。 					

   ​							所选虚拟网络接口断开与虚拟机的连接。 					

## 16.3. 推荐的虚拟机联网配置使用命令行界面

​				在很多情况下，默认的 VM 网络配置已经足够了。但是，如果需要调整配置，您可以使用命令行界面(CLI)来实现。以下小节描述了针对这种情况选择的虚拟机网络设置。 		

### 16.3.1. 使用命令行界面配置外部可见虚拟机

​					默认情况下，新创建的虚拟机连接到使用 `virbr0` （主机上的默认虚拟网桥）的 NAT 类型网络。这样可确保虚拟机可以使用主机的网络接口控制器(NIC)连接到外部网络，但虚拟机无法从外部系统访问。 			

​					如果您需要虚拟机出现在与虚拟机监控程序相同的外部网络中，则必须使用[桥接模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-bridged-mode_types-of-virtual-machine-network-connections)。要做到这一点，将虚拟机附加到连接到虚拟机监控程序物理网络设备的桥接设备。要使用命令行界面，请遵循以下步骤。 			

**先决条件**

- ​							带有默认 NAT 设置的[现有虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 					

- ​							管理程序的 IP 配置。这根据主机的网络连接而有所不同。例如，这个过程使用以太网电缆连接到网络的一个场景，主机的物理 NIC MAC 地址被分配给 DHCP 服务器上的静态 IP。因此，以太网接口被视为虚拟机监控程序 IP。 					

  ​							要获得以太网接口的 IP 配置，请使用 `ip addr` 实用程序： 					

  ```none
  # ip addr
  [...]
  enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
      link/ether 54:ee:75:49:dc:46 brd ff:ff:ff:ff:ff:ff
      inet 10.0.0.148/24 brd 10.0.0.255 scope global dynamic noprefixroute enp0s25
  ```

**步骤**

1. ​							为主机上的物理接口创建并设置一个桥接连接。具体步骤请参阅 [配置网络桥接](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking#configuring-a-network-bridge-using-nmcli-commands_configuring-a-network-bridge)。 					

   ​							请注意，在使用静态 IP 分配的情况下，您必须将物理以太网接口的 IPv4 设置移到网桥接口。 					

2. ​							修改虚拟机的网络，以使用创建的网桥接口。例如,以下设置 *testguest* 使用 *bridge0*。 					

   ```none
   # virt-xml testguest --edit --network bridge=bridge0
   Domain 'testguest' defined successfully.
   ```

3. ​							启动虚拟机。 					

   ```none
   # virsh start testguest
   ```

4. ​							在客户端操作系统中，调整系统网络接口的 IP 和 DHCP 设置，就像虚拟机在与虚拟机监控程序相同的网络中的另一个物理系统一样。 					

   ​							具体步骤将因虚拟机使用的客户端操作系统而异。例如，如果客户机操作系统是 RHEL 9，请参阅[配置以太网连接](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_networking/index#configuring-an-ethernet-connection_configuring-and-managing-networking)。 					

**验证**

1. ​							确保新创建的网桥正在运行，并且包含主机的物理接口和虚拟机接口。 					

   ```none
   # ip link show master bridge0
   2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bridge0 state UP mode DEFAULT group default qlen 1000
       link/ether 54:ee:75:49:dc:46 brd ff:ff:ff:ff:ff:ff
   10: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bridge0 state UNKNOWN mode DEFAULT group default qlen 1000
       link/ether fe:54:00:89:15:40 brd ff:ff:ff:ff:ff:ff
   ```

2. ​							确定虚拟机出现在与虚拟机监控程序相同的外部网络中： 					

   1. ​									在客户端操作系统中，获取系统的网络 ID。例如，如果它是 Linux 客户机： 							

      ```none
      # ip addr
      [...]
      enp0s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          link/ether 52:54:00:09:15:46 brd ff:ff:ff:ff:ff:ff
          inet 10.0.0.150/24 brd 10.0.0.255 scope global dynamic noprefixroute enp0s0
      ```

   2. ​									从连接到本地网络的外部系统中，使用获取的 ID 连接到虚拟机。 							

      ```none
      # ssh root@10.0.0.150
      root@10.0.0.150's password:
      Last login: Mon Sep 24 12:05:36 2019
      root~#*
      ```

      ​									如果连接有效，则代表网络已配置成功。 							

**故障排除**

- ​							在某些情况下，比如使用客户端到站点 VPN 时，当虚拟机托管在客户端上时，使用桥接模式使虚拟机可用于外部位置。 					

  ​							要临时解决这个问题，您可以为虚拟机[使用 `nftables` 设置目标 NAT](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_firewalls_and_packet_filters/getting-started-with-nftables_firewall-packet-filters#doc-wrapper)。 					

**其他资源**

- ​							[使用 web 控制台配置外部可见虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-externally-visible-virtual-machines-using-the-web-console_recommended-virtual-machine-networking-configurations-using-the-web-console) 					
- ​							[网桥模式中的虚拟网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-bridged-mode_types-of-virtual-machine-network-connections) 					

### 16.3.2. 使用命令行界面相互隔离虚拟机

​					要防止虚拟机(VM)与主机上的其他虚拟机通信，例如避免数据共享或提高系统安全，您可以完全将虚拟机与主机间的网络流量隔离开来。 			

​					默认情况下，新创建的虚拟机连接到使用 `virbr0`  （主机上的默认虚拟网桥）的 NAT 类型网络。这样可确保虚拟机可以使用主机的 NIC  连接到外部网络，以及主机上的其他虚拟机。在通常情况下，这是一个安全的连接。但在某些情况下，与其它虚拟机连接可能存在安全或者数据隐私隐患。在这种情况下，您可以在私有模式中使用直接 `macvtap` 连接而不是默认网络来隔离虚拟机。 			

​					在私有模式中，虚拟机对外部系统可见，并可接收主机的子网中的一个公共 IP，但虚拟机和主机无法相互访问，虚拟机也对主机上的其他虚拟机不可见。 			

​					有关使用 CLI 在虚拟机上设置 `macvtap` 私有模式的说明，请参考以下。 			

**先决条件**

- ​							[现有带有默认 NAT 设置的虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 					

- ​							要用于 `macvtap` 连接的主机接口名称。您必须选择的接口会根据您的用例和主机上的网络配置而有所不同。例如，这个过程使用主机的物理以太网接口。 					

  ​							要获得目标接口的名称： 					

  ```none
  $ ip addr
  [...]
  2: enp0s31f6: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
      link/ether 54:e1:ad:42:70:45 brd ff:ff:ff:ff:ff:ff
  [...]
  ```

**步骤**

- ​							使用所选接口在所选虚拟机上设置私有 `macvtap`。以下示例在名为 *panic- room* 的虚拟机的 `enp0s31f6` 接口上以私有模式配置 `macvtap`。 					

  ```none
  # virt-xml panic-room --edit --network type=direct,source=enp0s31f6,source.mode=private
  Domain 'panic-room' XML defined successfully
  ```

**验证**

1. ​							启动更新的虚拟机。 					

   ```none
   # virsh start panic-room
   Domain 'panic-room' started
   ```

2. ​							列出虚拟机的接口统计数据。 					

   ```none
   # virsh domstats panic-room --interface
   Domain: 'panic-room'
     net.count=1
     net.0.name=macvtap0
     net.0.rx.bytes=0
     net.0.rx.pkts=0
     net.0.rx.errs=0
     net.0.rx.drop=0
     net.0.tx.bytes=0
     net.0.tx.pkts=0
     net.0.tx.errs=0
     net.0.tx.drop=0
   ```

   ​							如果命令显示类似的输出结果，则代表虚拟机已被成功隔离。 					

**其他资源**

- ​							[使用 web 控制台隔离虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#isolating-virtual-machines-from-each-other-using-the-web-console_recommended-virtual-machine-networking-configurations-using-the-web-console) 					
- ​							[在私有模式中使用 `macvtap`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#direct-attachment-of-the-virtual-network-device_types-of-virtual-machine-network-connections) 					
- ​							[保护虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#securing-virtual-machines-in-rhel_configuring-and-managing-virtualization) 					

## 16.4. 推荐的虚拟机联网配置使用 web 控制台

​				在很多情况下，默认的 VM 网络配置已经足够了。但是，如果需要调整配置，您可以使用 RHEL 9 web 控制台进行此操作。以下小节描述了针对这种情况选择的虚拟机网络设置。 		

### 16.4.1. 使用 web 控制台配置外部可见虚拟机

​					默认情况下，新创建的虚拟机连接到使用 `virbr0` （主机上的默认虚拟网桥）的 NAT 类型网络。这样可确保虚拟机可以使用主机的网络接口控制器(NIC)连接到外部网络，但虚拟机无法从外部系统访问。 			

​					如果您需要虚拟机出现在与虚拟机监控程序相同的外部网络中，则必须使用[桥接模式](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-bridged-mode_types-of-virtual-machine-network-connections)。要做到这一点，将虚拟机附加到连接到虚拟机监控程序物理网络设备的桥接设备。要使用 RHEL 9 web 控制台，请遵循以下步骤。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

- ​							带有默认 NAT 设置的[现有虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 					

- ​							管理程序的 IP 配置。这根据主机的网络连接而有所不同。例如，这个过程使用以太网电缆连接到网络的一个场景，主机的物理 NIC MAC 地址被分配给 DHCP 服务器上的静态 IP。因此，以太网接口被视为虚拟机监控程序 IP。 					

  ​							要获取以太网接口的 IP 配置，请转至 web 控制台中的 `Networking` 选项卡，并查看 `接口` 部分。 					

  **步骤**

  1. ​									为主机上的物理接口创建并设置一个桥接连接。具体步骤请参阅[在 web 控制台中配置网络桥接](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/managing_systems_using_the_rhel_8_web_console/index#configuring-network-bridges-in-the-web-console_system-management-using-the-RHEL-8-web-console)。 							

     ​									请注意，在使用静态 IP 分配的情况下，您必须将物理以太网接口的 IPv4 设置移到网桥接口。 							

  2. ​									修改虚拟机的网络以使用桥接接口。在虚拟机的 [Network Interfaces](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#viewing-and-editing-virtual-network-interface-information-in-the-web-console_managing-virtual-machine-network-interfaces-using-the-web-console) 选项卡中： 							

     1. ​											点 Add Network Interface 									
     2. ​											在 `Add Virtual Network Interface` 对话框中设置： 									
        - ​													**Interface Type** 到 `Bridge to LAN` 											
        - ​													Source 到新创建的网桥，如 `bridge0` 											
     3. ​											点 添加 									
     4. ​											**可选** ：对于连接到虚拟机的所有其他接口，点 Unplug。 									

  3. ​									点 Run 启动虚拟机。 							

  4. ​									在客户端操作系统中，调整系统网络接口的 IP 和 DHCP 设置，就像虚拟机在与虚拟机监控程序相同的网络中的另一个物理系统一样。 							

     ​									具体步骤将因虚拟机使用的客户端操作系统而异。例如，如果客户机操作系统是 RHEL 9，请参阅[配置以太网连接](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_networking/index#configuring-an-ethernet-connection_configuring-and-managing-networking)。 							

**验证**

1. ​							在主机 Web 控制台的 **Networking** 选项卡中，单击新创建的网桥所在的行，以确保它正在运行，并且包含主机的物理接口和虚拟机接口。 					

2. ​							确保虚拟机出现在与虚拟机监控程序相同的外部网络中。 					

   1. ​									在客户端操作系统中，获取系统的网络 ID。例如，如果它是 Linux 客户机： 							

      ```none
      # ip addr
      [...]
      enp0s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
          link/ether 52:54:00:09:15:46 brd ff:ff:ff:ff:ff:ff
          inet 10.0.0.150/24 brd 10.0.0.255 scope global dynamic noprefixroute enp0s0
      ```

   2. ​									从连接到本地网络的外部系统中，使用获取的 ID 连接到虚拟机。 							

      ```none
      # ssh root@10.0.0.150
      root@110.34.5.18's password:
      Last login: Mon Sep 24 12:05:36 2019
      root~#*
      ```

      ​									如果连接有效，则代表网络已配置成功。 							

**故障排除**

- ​							在某些情况下，比如使用客户端到站点 VPN 时，当虚拟机托管在客户端上时，使用桥接模式使虚拟机可用于外部位置。 					

  ​							要临时解决这个问题，您可以为虚拟机[使用 `nftables` 设置目标 NAT](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/getting-started-with-nftables_configuring-and-managing-networking#configuring-destination-nat-using-nftables_configuring-nat-using-nftables)。 					

**其他资源**

- ​							[使用命令行界面配置外部可见虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-externally-visible-virtual-machines-using-the-command-line-interface_recommended-virtual-machine-networking-configurations-using-the-command-line-interface) 					
- ​							[网桥模式中的虚拟网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-networking-bridged-mode_types-of-virtual-machine-network-connections) 					

### 16.4.2. 使用 web 控制台隔离虚拟机

​					要防止虚拟机(VM)与主机上的其他虚拟机通信，例如避免数据共享或提高系统安全，您可以完全将虚拟机与主机间的网络流量隔离开来。 			

​					默认情况下，新创建的虚拟机连接到使用 `virbr0`  （主机上的默认虚拟网桥）的 NAT 类型网络。这样可确保虚拟机可以使用主机的 NIC  连接到外部网络，以及主机上的其他虚拟机。在通常情况下，这是一个安全的连接。但在某些情况下，与其它虚拟机连接可能存在安全或者数据隐私隐患。在这种情况下，您可以在私有模式中使用直接 `macvtap` 连接而不是默认网络来隔离虚拟机。 			

​					在私有模式中，虚拟机对外部系统可见，并可接收主机的子网中的一个公共 IP，但虚拟机和主机无法相互访问，虚拟机也对主机上的其他虚拟机不可见。 			

​					有关使用 Web 控制台在虚拟机上设置 `macvtap` 私有模式的说明，请参考以下。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					
- ​							[现有带有默认 NAT 设置的虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 					

**流程**

1. ​							在 **Virtual Machines** 窗格中，点您要隔离的虚拟机所在的行。 					

   ​							打开虚拟机基本信息的窗格。 					

2. ​							点 **Network Interfaces** 选项卡。 					

3. ​							点 Edit。 					

   ​							此时会打开 `Virtual Machine Interface Settings` 对话框。 					

4. ​							将 **接口** 类型设置为 **Direct Attachment** 					

5. ​							将 **Source** 设置为您选择的主机接口。 					

   ​							请注意，您选择的接口会根据您的用例和主机上的网络配置而有所不同。 					

**验证**

1. ​							点 Run 启动虚拟机。 					

2. ​							在 web 控制台的 **Terminal** 窗格中，列出虚拟机的接口统计信息。例如，查看 *panic- room* VM 的网络接口流量： 					

   ```none
   # virsh domstats panic-room --interface
   Domain: 'panic-room'
     net.count=1
     net.0.name=macvtap0
     net.0.rx.bytes=0
     net.0.rx.pkts=0
     net.0.rx.errs=0
     net.0.rx.drop=0
     net.0.tx.bytes=0
     net.0.tx.pkts=0
     net.0.tx.errs=0
     net.0.tx.drop=0
   ```

   ​							如果命令显示类似的输出结果，则代表虚拟机已被成功隔离。 					

**其他资源**

- ​							[使用命令行界面相互隔离虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#isolating-virtual-machines-from-each-other-using-the-command-line-interface_recommended-virtual-machine-networking-configurations-using-the-command-line-interface) 					
- ​							[在私有模式中使用 `macvtap`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#direct-attachment-of-the-virtual-network-device_types-of-virtual-machine-network-connections) 					
- ​							[保护虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#securing-virtual-machines-in-rhel_configuring-and-managing-virtualization) 					

## 16.5. 虚拟机网络连接的类型

​				要修改虚拟机的网络属性和行为，更改虚拟机使用的虚拟网络或接口类型。以下小节描述了 RHEL 9 中虚拟机可用的连接类型。 		

### 16.5.1. 使用网络地址转换进行虚拟联网

​					默认情况下，虚拟网络交换机在网络地址转换(NAT)模式中操作。它们使用 IP 伪装而不是 Source-NAT(SNAT)或  Destination-NAT(DNAT)。IP 伪装可让连接的虚拟机使用主机机器的 IP 地址与任何外部网络通信。当虚拟网络切换以 NAT  模式运行时，主机外部的计算机无法与主机中的虚拟机通信。 			

[![vn 04 hostwithnatswitch](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/1319bd0237b46101e4af18dcff3447d3/vn-04-hostwithnatswitch.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/1319bd0237b46101e4af18dcff3447d3/vn-04-hostwithnatswitch.png)

警告

​						虚拟网络交换机使用防火墙规则配置的 NAT。不建议在交换机运行时编辑这些规则，因为不正确的规则可能会导致交换机无法进行通信。 				

### 16.5.2. 路由模式下的虚拟网络

​					当使用 *Routed*  模式时，虚拟交换机会连接到连接到主机的物理 LAN 中，并在不使用 NAT  的情况下传输数据。虚拟交换机可以检查所有流量，并使用网络数据包中包含的信息来做出路由决策。使用此模式时，虚拟机(VM)全部在一个子网中，与主机计算机分开。VM 子网通过虚拟交换机路由，该交换机存在于主机机器中。这可启用进入的连接，但需要外部网络中系统的额外可路由条目。 			

​					路由模式使用基于 IP 地址的路由： 			

[![vn 06 路由交换机](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/89e500f462be47a38d07f228a3911688/vn-06-routed-switch.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/89e500f462be47a38d07f228a3911688/vn-06-routed-switch.png)

​					使用路由模式的通用拓扑包括 DMZs 和虚拟服务器托管。 			

- DMZ

  ​								您可以创建一个网络，并处于安全考虑，将一个或多个节点放在这个受控的子网络中。这样的子网络被称为“非军事区（DMZ）”。 						[![vn 09 路由模式 DMZ](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b8df0cf23c87e2fcc0e5d70c685bb43f/vn-09-routed-mode-DMZ.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b8df0cf23c87e2fcc0e5d70c685bb43f/vn-09-routed-mode-DMZ.png) 							DMZ 中的主机机器通常为 WAN（外部）主机机器和 LAN（内部）主机机器提供服务。由于这需要它们可以被多个位置访问，并考虑这些位置可根据其安全性和信任级别以不同的方式控制和操作，因此路由模式是此环境的最佳配置。 						

- 虚拟服务器托管

  ​								托管供应商的虚拟服务器可能具有多个主机计算机，各自具有两个物理网络连接。一个接口用于管理并核算，另一个用于虚拟机进行连接。每个虚拟机都有自己的公共 IP 地址，但主机计算机使用专用 IP 地址，以便只有内部管理员可以管理虚拟机。 						[![vn 10 路由模式数据中心](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/22da7ff1d584efda76a94e916ca0a839/vn-10-routed-mode-datacenter.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/22da7ff1d584efda76a94e916ca0a839/vn-10-routed-mode-datacenter.png)

### 16.5.3. 网桥模式中的虚拟网络

​					在大多数虚拟机网络模式中，虚拟机会自动创建和连接到 `virbr0` 虚拟网桥。相反，在*桥接*模式中，VM 会连接到主机上的一个已存在的 Linux 网桥。因此，虚拟机可以在物理网络中直接看到。这就可以允许进入的连接，但不需要任何额外的路由表条目。 			

​					网桥模式使用基于 MAC 地址的连接切换： 			

[![vn 桥接模式图](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f6693f99168773256a540c6efe33fda5/vn-Bridged-Mode-Diagram.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/f6693f99168773256a540c6efe33fda5/vn-Bridged-Mode-Diagram.png)

​					在桥接模式中，虚拟机将显示在与主机机器相同的子网中。同一物理网络中的所有其他物理机器都可以检测虚拟机并访问它。 			

**网桥网络绑定**

​						通过将多个物理网桥接口绑定在一起，可以在 hypervisor 中使用多个物理网桥接口。然后可将绑定添加到桥接中，然后也可以将虚拟机添加到网桥中。但是，绑定驱动程序有多种操作模式，而所有这些模式都可用于虚拟机正在使用的网桥。 				

​					可用的 [绑定模式](https://access.redhat.com/solutions/67546) 如下： 			

- ​							模式 1 					
- ​							模式 2 					
- ​							模式 4 					

​					相反，使用模式 0、3、5 或 6 可能会导致连接失败。另请注意，依赖介质的接口(MII)监控应该用于监控绑定模式，因为地址解析协议(ARP)监控无法正常工作。 			

​					有关绑定模式的详情，请参考[红帽知识库](https://access.redhat.com/solutions/67546)。 			

**常见情况**

​						使用桥接模式的最常见用例包括： 				

- ​							主机机器和虚拟机一起出现在现有网络中，最终用户看不到虚拟机和物理机器之间的不同。 					
- ​							在不更改现有物理网络配置设置的情况下部署虚拟机。 					
- ​							部署需要被现有物理网络轻松访问的虚拟机。将虚拟机放置到必须访问 DHCP 服务的物理网络中。 					
- ​							将虚拟机连接到使用虚拟 LAN(VLAN)的现有网络。 					

**其他资源**

- ​							[使用命令行界面配置外部可见虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-externally-visible-virtual-machines-using-the-command-line-interface_recommended-virtual-machine-networking-configurations-using-the-command-line-interface) 					
- ​							[使用 web 控制台配置外部可见虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-externally-visible-virtual-machines-using-the-web-console_recommended-virtual-machine-networking-configurations-using-the-web-console) 					
- ​							[`bridge_opts` 参数的说明](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.1/html/administration_guide/appe-custom_network_properties#Explanation_of_bridge_opts_Parameters) 					

### 16.5.4. 处于隔离模式的虚拟网络

​					使用 *isolated（隔离）*模式时，连接到虚拟交换机的虚拟机可以相互通信，并与主机虚拟机通信，但其流量不会在主机机器外传递，且无法从主机外部接收流量。在这个模式中需要使用 `dnsmasq` 的基本功能，如 DHCP。 			

[![vn 07 隔离交换](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ad58f56e3f39b5ffa9271100b3ccfe7d/vn-07-isolated-switch.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ad58f56e3f39b5ffa9271100b3ccfe7d/vn-07-isolated-switch.png)

### 16.5.5. 处于开放模式的虚拟网络

​					在使用 *开放* 模式进行联网时，`libvirt` 不会为网络生成任何防火墙规则。因此，`libvirt` 不会覆盖主机提供的防火墙规则，因此用户可以手动管理虚拟机的防火墙规则。 			

### 16.5.6. 虚拟网络设备的直接附加

​					您可以使用 `macvtap` 驱动程序将虚拟机 NIC 直接连接到主机机器的指定物理接口。`macvtap` 连接具有多种模式，包括 **私有模式**。 			

​					在这种模式中，所有数据包都发送到外部交换机，然后仅发送到同一主机上的目标虚拟机。如果它们通过外部路由器或网关发送，它们会被发送回主机）。私有模式可用于防止单一主机上的单个虚拟机相互通信。 			

[![virt macvtap 模式私有](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ba0c985d6f3a10c9e96767d7a2a18a30/virt-macvtap-modes-private.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ba0c985d6f3a10c9e96767d7a2a18a30/virt-macvtap-modes-private.png)

**其他资源**

- ​							[使用命令行界面相互隔离虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#isolating-virtual-machines-from-each-other-using-the-command-line-interface_recommended-virtual-machine-networking-configurations-using-the-command-line-interface) 					
- ​							[使用 web 控制台隔离虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#isolating-virtual-machines-from-each-other-using-the-web-console_recommended-virtual-machine-networking-configurations-using-the-web-console) 					

### 16.5.7. 虚拟机连接类型比较

​					下表提供了有关所选虚拟机(VM)网络配置可以连接的位置以及可见的位置的信息。 			

**表 16.1. 虚拟机连接类型**

|              | 连接到主机               | 连接到主机上的其他虚拟机 | 连接到外部位置 | 可查看外部位置 |
| ------------ | ------------------------ | ------------------------ | -------------- | -------------- |
| **网桥模式** | 是                       | 是                       | 是             | 是             |
| **NAT**      | 是                       | 是                       | 是             | *否*           |
| **路由模式** | 是                       | 是                       | 是             | 是             |
| **隔离模式** | 是                       | 是                       | *否*           | *否*           |
| **私有模式** | *否*                     | *否*                     | 是             | 是             |
| **开放模式** | *取决于主机的防火墙规则* |                          |                |                |

## 16.6. 从 PXE 服务器引导虚拟机

​				使用 Preboot Execution Environment(PXE)的虚拟机(VM)可以从网络引导和加载其配置。本章论述了如何使用 `libvirt` 从虚拟或桥接网络中的 PXE 服务器引导虚拟机。 		

警告

​					这些程序仅作为示例提供。在继续操作前，请确保您已有足够的备份。 			

### 16.6.1. 在虚拟网络中设置 PXE 引导服务器

​					这个步骤描述了如何配置 `libvirt` 虚拟网络以提供预启动执行环境(PXE)。这可让主机上的虚拟机配置为从虚拟网络中提供的引导镜像引导。 			

**先决条件**

- ​							本地 PXE 服务器（DHCP 和 TFTP），例如： 					
  - ​									libvirt 内部服务器 							
  - ​									手动配置 dhcpd 和 tftpd 							
  - ​									dnsmasq 							
  - ​									Cobbler 服务器 							
- ​							PXE 引导镜像，如 Cobbler 配置或者手动配置 `PXELINUX`。 					

**步骤**

1. ​							将 PXE 引导镜像和配置放在 `/var/lib/tftpboot` 文件夹中。 					

2. ​							设置文件夹权限： 					

   ```none
   # chmod -R a+r /var/lib/tftpboot
   ```

3. ​							设置文件夹所有权： 					

   ```none
   # chown -R nobody: /var/lib/tftpboot
   ```

4. ​							更新 SELinux 上下文： 					

   ```none
   # chcon -R --reference /usr/sbin/dnsmasq /var/lib/tftpboot
   # chcon -R --reference /usr/libexec/libvirt_leaseshelper /var/lib/tftpboot
   ```

5. ​							关闭虚拟网络： 					

   ```none
   # virsh net-destroy default
   ```

6. ​							在默认编辑器中打开虚拟网络配置文件： 					

   ```none
   # virsh net-edit default
   ```

7. ​							编辑 `<ip>` 元素，使其包含适当的地址、网络掩码、DHCP 地址范围和引导文件，其中 *BOOT_FILENAME* 是引导镜像文件的名称。 					

   ```none
   <ip address='192.168.122.1' netmask='255.255.255.0'>
      <tftp root='/var/lib/tftpboot' />
      <dhcp>
         <range start='192.168.122.2' end='192.168.122.254' />
         <bootp file='BOOT_FILENAME' />
      </dhcp>
   </ip>
   ```

8. ​							启动虚拟网络： 					

   ```none
   # virsh net-start default
   ```

**验证**

- ​							验证 `default` 虚拟网络是否活跃： 					

  ```none
  # virsh net-list
  Name             State    Autostart   Persistent
  ---------------------------------------------------
  default          active   no          no
  ```

**其他资源**

- ​							[在 PXE 服务器上配置 TFTP 和 DHCP](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/performing_a_standard_rhel_9_installation/preparing-for-a-network-install_installing-rhel) 					

### 16.6.2. 使用 PXE 和虚拟网络引导虚拟机

​					要从虚拟网络中提供的 Preboot Execution Environment(PXE)服务器引导虚拟机(VM)，您必须启用 PXE 引导。 			

**先决条件**

- ​							在虚拟网络上设置 PXE 引导服务器，如 [第 16.6.1 节 “在虚拟网络中设置 PXE 引导服务器”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_setting-up-a-pxe-boot-server-on-a-virtual-network_assembly_booting-virtual-machines-from-a-pxe-server) 所述。 					

**步骤**

- ​							创建启用 PXE 引导的新虚拟机。例如，若要从 `default` 虚拟网络中提供的 PXE 安装，到新的 10 GB qcow2 镜像文件： 					

  ```none
  # virt-install --pxe --network network=default --memory 2048 --vcpus 2 --disk size=10
  ```

  - ​									另外，您可以手动编辑现有虚拟机的 XML 配置文件： 							

    1. ​											确保 `<os>` 元素中具有一个 `<boot dev='network'/>` 元素： 									

       ```none
       <os>
          <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
          <boot dev='network'/>
          <boot dev='hd'/>
       </os>
       ```

    2. ​											确定将客户端网络配置为使用您的虚拟网络： 									

       ```none
       <interface type='network'>
          <mac address='52:54:00:66:79:14'/>
          <source network='default'/>
          <target dev='vnet0'/>
          <alias name='net0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
       </interface>
       ```

**验证**

- ​							使用 `virsh start` 命令启动虚拟机。如果正确配置了 PXE，则虚拟机从 PXE 服务器上的引导镜像引导。 					

### 16.6.3. 使用 PXE 和桥接网络引导虚拟机

​					要从桥接网络中的预启动执行环境(PXE)服务器引导虚拟机，您必须启用 PXE 启动。 			

**先决条件**

- ​							启用网络桥接。 					
- ​							网桥网络上提供了 PXE 引导服务器。 					

**步骤**

- ​							创建启用 PXE 引导的新虚拟机。例如，要从 `breth0` 网桥网络上的 PXE 安装，到新的 10 GB qcow2 镜像文件： 					

  ```none
  # virt-install --pxe --network bridge=breth0 --memory 2048 --vcpus 2 --disk size=10
  ```

  - ​									另外，您可以手动编辑现有虚拟机的 XML 配置文件： 							

    1. ​											确保 `<os>` 元素中具有一个 `<boot dev='network'/>` 元素： 									

       ```none
       <os>
          <type arch='x86_64' machine='pc-i440fx-rhel7.0.0'>hvm</type>
          <boot dev='network'/>
          <boot dev='hd'/>
       </os>
       ```

    2. ​											确保虚拟机配置为使用桥接网络： 									

       ```none
       <interface type='bridge'>
          <mac address='52:54:00:5a:ad:cb'/>
          <source bridge='breth0'/>
          <target dev='vnet0'/>
          <alias name='net0'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
       </interface>
       ```

**验证**

- ​							使用 `virsh start` 命令启动虚拟机。如果正确配置了 PXE，则虚拟机从 PXE 服务器上的引导镜像引导。 					

**其他资源**

- ​							[配置网络桥接](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking) 					

## 16.7. 其他资源

- ​						[配置和管理网络](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/index) 				
- ​						[将特定的网络接口卡作为 SR-IOV 设备](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-sr-iov-devices_managing-virtual-devices) 来提高虚拟机性能。 				

# 第 17 章 优化虚拟机性能

​			与主机相比，虚拟机的性能总会有所降低。以下小节解释了这个冲突的原因，并提供了有关如何在 RHEL 9 中最小化虚拟化性能影响的说明，以便您的硬件基础架构资源可以尽可能高效地使用。 	

## 17.1. 影响虚拟机性能的因素

​				虚拟机作为用户空间进程在主机上运行。因此管理程序需要转换主机的系统资源，以便虚拟机可使用它们。因此，部分资源会被转换消耗，因此虚拟机无法获得与主机相同的性能效率。 		

#### 虚拟化对系统性能的影响

​				体虚拟机性能损失的原因包括： 		

- ​						虚拟 CPU（vCPU）是主机上的线，,由 Linux 调度程序处理。 				
- ​						VM 不会自动继承主机内核的优化功能，比如 NUMA 或巨页。 				
- ​						主机的磁盘和网络 I/O 设置可能会对虚拟机有显著的性能影响。 				
- ​						网络流量通常通过基于软件的网桥到达虚拟机。 				
- ​						根据主机设备及其模型，由于特定硬件模拟，可能会有大量开销。 				

​				虚拟化对虚拟机性能的影响的严重性由各种因素影响，其中包括： 		

- ​						并行运行的虚拟机数量。 				
- ​						每个虚拟机使用的虚拟设备数量。 				
- ​						虚拟机使用的设备类型。 				

#### 降低虚拟机性能损失

​				RHEL 9 提供了很多功能，可用于降低虚拟化的负面影响。值得注意的是： 		

- ​						[ `tuned` 服务](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-performance-using-tuned_optimizing-virtual-machine-performance-in-rhel) 可自动优化虚拟机的资源分布和性能。 				
- ​						[块 I/O 调优](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-i-o-performance_optimizing-virtual-machine-performance-in-rhel)可提高虚拟机块设备的性能，如磁盘。 				
- ​						[NUMA 调优](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-cpu-performance_optimizing-virtual-machine-performance-in-rhel)可提高 vCPU 性能。 				
- ​						可使用各种方法优化[虚拟网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-network-performance_optimizing-virtual-machine-performance-in-rhel)。 				

重要

​					调整虚拟机性能会对其他虚拟化功能造成负面影响。例如，它可以使迁移修改过的虚拟机更为困难。 			

## 17.2. 使用 tuned 优化虚拟机性能

​				`tuned` 实用程序是调优的配置文件交付机制，可适应某些工作负载特性的  RHEL，如 CPU  密集型任务或存储网络吞吐量响应的要求。它提供了一些预配置调优配置文件，以增强性能并减少在很多特定用例中的能耗。您可以编辑这些配置集，或创建新配置集来创建适合您的环境的性能解决方案，包括虚拟环境。 		

​				要为虚拟化优化 RHEL 9，请使用以下配置集： 		

- ​						对于 RHEL 9 虚拟机，请使用 **virtual-guest** 配置集。它基于通常适用的 `*throughput-performance*` 配置集，但也会降低虚拟内存的交换性。 				
- ​						对于 RHEL 9 虚拟化主机，请使用 **virtual-host** 配置集。这可提高脏内存页面的主动回写，这有助于主机性能。 				

**先决条件**

- ​						`tuned` 服务 [已安装并启用](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/monitoring_and_managing_system_status_and_performance/getting-started-with-tuned_monitoring-and-managing-system-status-and-performance#installing-and-enabling-tuned_getting-started-with-tuned)。 				

**步骤**

​					启用特定的 `tuned` 配置集 ： 			

1. ​						列出可用的 `tuned` 配置集。 				

   ```none
   # tuned-adm list
   
   Available profiles:
   - balanced             - General non-specialized tuned profile
   - desktop              - Optimize for the desktop use-case
   [...]
   - virtual-guest        - Optimize for running inside a virtual guest
   - virtual-host         - Optimize for running KVM guests
   Current active profile: balanced
   ```

2. ​						**可选：**创建新的 `tuned` 配置集或编辑现有的 `tuned` 配置集。 				

   ​						如需更多信息，请参阅[自定义 tuned 配置集](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/monitoring_and_managing_system_status_and_performance/customizing-tuned-profiles_monitoring-and-managing-system-status-and-performance)。 				

3. ​						激活 `tuned` 配置集。 				

   ```none
   # tuned-adm profile selected-profile
   ```

   - ​								要优化虚拟化主机，请使用 *virtual-host* 配置集。 						

     ```none
     # tuned-adm profile virtual-host
     ```

   - ​								在 RHEL 虚拟机操作系统中，使用 *virtual-guest* 配置集。 						

     ```none
     # tuned-adm profile virtual-guest
     ```

**其他资源**

- ​						[监控和管理系统状态和性能](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/monitoring_and_managing_system_status_and_performance/) 				

## 17.3. 优化 libvirt 守护进程

​				`libvirt` 虚拟化套件作为 RHEL hypervisor 的管理层，`libvirt` 配置对您的虚拟化主机有很大影响。值得注意的是，RHEL 9 包含两种不同类型的 `libvirt` 守护进程，即单体或模块化，您使用的守护进程类型会影响您可以配置单独的虚拟化驱动程序。 		

### 17.3.1. libvirt 守护进程的类型

​					RHEL 9 支持以下 `libvirt` 守护进程类型： 			

- 单体 libvirt

  ​								传统的 `libvirt` 守护进程 `libvirtd`，使用单一配置文件 - `/etc/libvirt/libvirtd.conf` 控制各种虚拟化驱动程序。 						 							因此，`libvirtd` 允许使用集中的虚拟机监控程序配置，但可能会导致对系统资源的使用效率低。因此，`libvirtd` 在以后的 RHEL 主发行版本中将不被支持。 						 							但是，如果您从 RHEL 8 更新至 RHEL 9，您的主机仍然默认使用 `libvirtd`。 						

- 模块 libvirt

  ​								RHEL 9 中新引入的模块 `libvirt` 为各个虚拟化驱动程序提供一个特定的守护进程。其中包括： 						 									**virtqemud** - hypervisor 管理的主要守护进程 								 									**virtinterfaced** - 用于主机 NIC 管理的辅助守护进程 								 									**virtnetworkd** - 用于虚拟网络管理的辅助守护进程 								 									**virtnodedevd** - 主机物理设备管理的辅助守护进程 								 									**virtnwfilterd** - 主机防火墙管理的辅助守护进程 								 									**virtsecretd** - 用于主机 secret 管理的辅助守护进程 								 									**virtstoraged** - 用于存储管理的辅助守护进程 								 							每个守护进程都有单独的配置文件 - 例如 `/etc/libvirt/virtqemud.conf`。因此，模块化的 `libvirt` 守护进程可以为调优 `libvirt` 资源管理提供更好的选项。 						 							如果您执行了全新的 RHEL 9 安装，则会默认配置模块化的 `libvirt`。 						

**后续步骤**

- ​							如果您的 RHEL 9 使用 `libvirtd`，红帽建议切换到模块化守护进程。具体步骤请参阅[启用模块化 libvirt 守护进程](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_enabling-modular-libvirt-daemons_assembly_optimizing-libvirt-daemons)。 					

### 17.3.2. 启用模块化 libvirt 守护进程

​					在 RHEL 9 中，`libvirt` 库使用 modular 守护进程来处理您主机上的单个虚拟化驱动程序集。例如，`virtqemud` 守护进程处理 QEMU 驱动程序。 			

​					如果您执行了 RHEL 9 主机的全新安装，您的虚拟机监控程序默认使用模块化 `libvirt` 守护进程。但是，如果您将主机从 RHEL 8 升级到 RHEL 9，您的管理程序将使用单体 `libvirtd` 守护进程，这是 RHEL 8 中的默认设置。 			

​					如果出现这种情况，红帽建议改为启用模块化 `libvirt` 守护进程，因为它们为微调 `libvirt` 资源管理提供了更好的选项。另外，`libvirtd` 在以后的 RHEL 主发行版本中将不被支持。 			

**先决条件**

- ​							您的管理程序使用单体的 `libvirtd` 服务。要了解这一点是否如此： 					

  ```none
  # systemctl is-active libvirtd.service
  active
  ```

  ​							如果这个命令显示 `active`，则代表在使用 `libvirtd`。 					

- ​							您的虚拟机已关闭。 					

**流程**

1. ​							停止 `libvirtd` 及其套接字。 					

   ```none
   # systemctl stop libvirtd.service
   # systemctl stop libvirtd{,-ro,-admin,-tcp,-tls}.socket
   ```

2. ​							禁用 `libvirtd` 以防止它在引导时启动。 					

   ```none
   $ systemctl disable libvirtd.service
   $ systemctl disable libvirtd{,-ro,-admin,-tcp,-tls}.socket
   ```

3. ​							启用模块 `libvirt` 守护进程。 					

   ```none
   # for drv in qemu interface network nodedev nwfilter secret storage do systemctl unmask virt${drv}d.service systemctl unmask virt${drv}d{,-ro,-admin}.socket systemctl enable virt${drv}d.service systemctl enable virt${drv}d{,-ro,-admin}.socket done
   ```

4. ​							启动模块守护进程的套接字。 					

   ```none
   # for drv in qemu network nodedev nwfilter secret storage do systemctl start virt${drv}d{,-ro,-admin}.socket done
   ```

5. ​							**可选：**如果您需要从远程主机连接到主机，请启用并启动虚拟化代理守护进程。 					

   ```none
   # systemctl unmask virtproxyd.service
   # systemctl unmask virtproxyd{,-ro,-admin,-tls}.socket
   # systemctl enable virtproxyd.service
   # systemctl enable virtproxyd{,-ro,-admin,-tls}.socket
   # systemctl start virtproxyd{,-ro,-admin,tls}.socket
   ```

**验证**

1. ​							激活已启用的虚拟化守护进程。 					

   ```none
   # virsh uri
   qemu:///system
   ```

2. ​							确保您的主机使用 `virtqemud` 模块守护进程。 					

   ```none
   # systemctl is-active virtqemud.service
   active
   ```

   ​							如果这个命令显示 `active`，则代表您成功启用了模块 `libvirt` 守护进程。 					

## 17.4. 配置虚拟机内存

​				要提高虚拟机的性能，您可以为虚拟机分配额外的主机 RAM。同样，您可以减少分配给虚拟机的内存量，以便主机内存可以分配给其他虚拟机或任务。 		

​				要执行这些操作，您可以[使用 Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-machine-ram-using-the-web-console_configuring-virtual-machine-ram)或[命令行界面](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-machine-ram-using-the-command-line-interface_configuring-virtual-machine-ram)。 		

### 17.4.1. 使用 web 控制台添加和删除虚拟机内存

​					要提高虚拟机的性能或释放所使用的主机资源，您可以使用 web 控制台来调整分配给虚拟机的内存量。 			

**先决条件**

- ​							客户端操作系统正在运行内存 balloon 驱动程序。请执行以下命令校验： 					

  1. ​									确保虚拟机的配置包含 `memballoon` 设备： 							

     ```none
     # virsh dumpxml testguest | grep memballoon
     <memballoon model='virtio'>
         </memballoon>
     ```

     ​									如果这个命令显示任何输出结果，且模型没有设置为 `none`，则代表存在 `memballoon` 设备。 							

  2. ​									确保客户机操作系统中正在运行 balloon 驱动程序。 							

     - ​											在 Windows 客户端中，这些驱动程序作为 `virtio-win` 驱动程序软件包的一部分安装。具体步骤请参阅 为 Windows 虚拟机安装半虚拟化 KVM 驱动程序。 									
     - ​											在 Linux 客户端中，默认情况下，这些驱动程序通常默认包含，并在 `memballoon` 设备存在时激活。 									

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							**可选：**获取关于虚拟机的最大内存和当前使用的内存的信息。这将作为您更改的基准，并进行验证。 					

   ```none
   # virsh dominfo testguest
   Max memory:     2097152 KiB
   Used memory:    2097152 KiB
   ```

2. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

3. ​							在 Overview 窗格中，单击 `Memory` 行旁边的 编辑。 					

   ​							此时会出现 `Memory Adjustment` 对话框。 					

   [![显示虚拟机内存调整对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/839e2ecc24d24759503df5eeb06e6888/virt-cockpit-memory.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/839e2ecc24d24759503df5eeb06e6888/virt-cockpit-memory.png)

4. ​							为所选虚拟机配置虚拟 CPU。 					

   - ​									**最大分配** - 设置虚拟机可用于其进程的最大主机内存量。您可以在创建虚拟机时指定最大内存，或者在以后增加它。您可以将内存指定为 MiB 或 GiB 的倍数。 							

     ​									只有在关闭虚拟机上才能调整最大内存分配。 							

   - ​									**当前分配** - 设置分配给虚拟机的实际内存量。这个值可以小于最大分配，但不能超过它。您可以调整该值来规定虚拟机可用于其进程的内存。您可以将内存指定为 MiB 或 GiB 的倍数。 							

     ​									如果没有指定这个值，则默认分配是 **Maximum allocation** 值。 							

5. ​							点击 Save。 					

   ​							调整了虚拟机的内存分配。 					

**其他资源**

- ​							[使用命令行界面添加和删除虚拟机内存](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-machine-ram-using-the-command-line-interface_configuring-virtual-machine-ram) 					
- ​							[优化虚拟机 CPU 性能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-cpu-performance_optimizing-virtual-machine-performance-in-rhel) 					

### 17.4.2. 使用命令行界面添加和删除虚拟机内存

​					要提高虚拟机的性能或释放所使用的主机资源，您可以使用 CLI 调整分配给虚拟机的内存量。 			

**先决条件**

- ​							客户端操作系统正在运行内存 balloon 驱动程序。请执行以下命令校验： 					

  1. ​									确保虚拟机的配置包含 `memballoon` 设备： 							

     ```none
     # virsh dumpxml testguest | grep memballoon
     <memballoon model='virtio'>
         </memballoon>
     ```

     ​									如果这个命令显示任何输出结果，且模型没有设置为 `none`，则代表存在 `memballoon` 设备。 							

  2. ​									确定 ballon 驱动程序正在客户端操作系统中运行。 							

     - ​											在 Windows 客户端中，这些驱动程序作为 `virtio-win` 驱动程序软件包的一部分安装。具体步骤请参阅 为 Windows 虚拟机安装半虚拟化 KVM 驱动程序。 									
     - ​											在 Linux 客户端中，默认情况下，这些驱动程序通常默认包含，并在 `memballoon` 设备存在时激活。 									

**步骤**

1. ​							**可选：**获取关于虚拟机的最大内存和当前使用的内存的信息。这将作为您更改的基准，并进行验证。 					

   ```none
   # virsh dominfo testguest
   Max memory:     2097152 KiB
   Used memory:    2097152 KiB
   ```

2. ​							调整分配给虚拟机的最大内存。增加这个值可以提高虚拟机的性能风险，降低这个值会降低虚拟机在主机上的性能占用空间。请注意，这个更改只能在关闭的虚拟机上执行，因此调整正在运行的虚拟机需要重启才能生效。 					

   ​							例如，要将 *testguest* 虚拟机可以使用的最大内存改为 4096 MiB： 					

   ```none
   # virt-xml testguest --edit --memory memory=4096,currentMemory=4096
   Domain 'testguest' defined successfully.
   Changes will take effect after the domain is fully powered off.
   ```

   ​							要增加正在运行的虚拟机的最大内存，您可以将内存设备附加到虚拟机。这也被称为**内存热插拔**。详情请参阅将内存设备附加到虚拟机。 					

   警告

   ​								不支持从正在运行的虚拟机中删除内存设备（也称为内存热拔），因此红帽不建议这样做。 						

3. ​							**可选：**您还可以调整虚拟机当前使用的内存，最多不超过最大分配量。这样可保证虚拟机在主机上拥有的内存负载，直到下次重启为止，而不会更改最大虚拟机分配。 					

   ```none
   # virsh setmem testguest --current 2048
   ```

**验证**

1. ​							确认虚拟机使用的内存已更新： 					

   ```none
   # virsh dominfo testguest
   Max memory:     4194304 KiB
   Used memory:    2097152 KiB
   ```

2. ​							**可选：**如果您调整了当前虚拟机内存，您可以获取虚拟机的内存 balloon 统计，以评估它如何有效地调整其内存使用。 					

   ```none
    # virsh domstats --balloon testguest
   Domain: 'testguest'
     balloon.current=365624
     balloon.maximum=4194304
     balloon.swap_in=0
     balloon.swap_out=0
     balloon.major_fault=306
     balloon.minor_fault=156117
     balloon.unused=3834448
     balloon.available=4035008
     balloon.usable=3746340
     balloon.last-update=1587971682
     balloon.disk_caches=75444
     balloon.hugetlb_pgalloc=0
     balloon.hugetlb_pgfail=0
     balloon.rss=1005456
   ```

**其他资源**

- ​							[使用 web 控制台添加和删除虚拟机内存](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-machine-ram-using-the-web-console_configuring-virtual-machine-ram) 					
- ​							[优化虚拟机 CPU 性能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-cpu-performance_optimizing-virtual-machine-performance-in-rhel) 					

### 17.4.3. 其他资源

- ​							[将设备附加到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-devices-to-virtual-machines_assembly_managing-virtual-devices-using-the-cli). 					

## 17.5. 优化虚拟机 I/O 性能

​				虚拟机(VM)的输入和输出(I/O)功能可能会显著限制虚拟机的整体效率。要解决这个问题，您可以通过配置块 I/O 参数来优化虚拟机的 I/O。 		

### 17.5.1. 在虚拟机中调整块 I/O

​					当一个或多个虚拟机正在使用多个块设备时,可能需要通过修改虚拟设备的 I/O 优先级来调整虚拟设备的 *I/O 权重*。 			

​					增加设备的 I/O 权重会增加设备的 I/O 带宽的优先级，从而为它提供更多主机资源。同样的，降低设备的权重可使其消耗较少的主机资源。 			

注意

​						每个设备的 `weight` 值都必须在 `100` 到 `1000` 范围内。或者，该值可以是 `0`，这会从每个设备列表中删除该设备。 				

**步骤**

​						显示和设置虚拟机的块 I/O 参数： 				

1. ​							显示虚拟机的当前 `<blkio>` 参数： 					

   ​							`# **virsh dumpxml \*VM-name\***` 					

   ```xml
   <domain>
     [...]
     <blkiotune>
       <weight>800</weight>
       <device>
         <path>/dev/sda</path>
         <weight>1000</weight>
       </device>
       <device>
         <path>/dev/sdb</path>
         <weight>500</weight>
       </device>
     </blkiotune>
     [...]
   </domain>
   ```

2. ​							编辑指定设备的 I/O 加权： 					

   ```none
   # virsh blkiotune VM-name --device-weights device, I/O-weight
   ```

   ​							例如：以下将 *liftrul* 虚拟机中的 */dev/sda* 设备的权重改为 500。 					

   ```none
   # virsh blkiotune liftbrul --device-weights /dev/sda, 500
   ```

### 17.5.2. 虚拟机中的磁盘 I/O 节流

​					当多个虚拟机同时运行时，它们可能会干扰使用过量磁盘 I/O 的系统性能。KVM 虚拟化中的磁盘 I/O 节流提供了设置从虚拟机发送到主机机器的磁盘 I/O 请求的限制。这可以防止虚拟机过度利用共享资源并影响其他虚拟机的性能。 			

​					要启用磁盘 I/O 节流，对从附加到虚拟机的每个块设备发送到主机机器时发送的磁盘 I/O 请求设置限制。 			

**步骤**

1. ​							使用 `virsh domblklist` 命令列出指定虚拟机上所有磁盘设备的名称。 					

   ```none
   # virsh domblklist rollin-coal
   Target     Source
   ------------------------------------------------
   vda        /var/lib/libvirt/images/rollin-coal.qcow2
   sda        -
   sdb        /home/horridly-demanding-processes.iso
   ```

2. ​							找到您要节流的虚拟磁盘挂载的主机块设备。 					

   ​							例如，如果您想要减慢上一步中的 `sdb` 虚拟磁盘，以下输出表明磁盘已挂载到 `/dev/nvme0n1p3` 分区。 					

   ```none
   $ lsblk
   NAME                                          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
   zram0                                         252:0    0     4G  0 disk  [SWAP]
   nvme0n1                                       259:0    0 238.5G  0 disk
   ├─nvme0n1p1                                   259:1    0   600M  0 part  /boot/efi
   ├─nvme0n1p2                                   259:2    0     1G  0 part  /boot
   └─nvme0n1p3                                   259:3    0 236.9G  0 part
     └─luks-a1123911-6f37-463c-b4eb-fxzy1ac12fea 253:0    0 236.9G  0 crypt /home
   ```

3. ​							使用 `virsh blkiotune` 命令为块设备设置 I/O 限制。 					

   ```none
   # virsh blkiotune VM-name --parameter device,limit
   ```

   ​							以下示例将 `rollin-coal` 上的 `sdb` 磁盘节流为每秒 1000 个读写 I/O 操作，每秒的读写 I/O 操作吞吐量 50 MB。 					

   ```none
   # virsh blkiotune rollin-coal --device-read-iops-sec /dev/nvme0n1p3,1000 --device-write-iops-sec /dev/nvme0n1p3,1000 --device-write-bytes-sec /dev/nvme0n1p3,52428800 --device-read-bytes-sec /dev/nvme0n1p3,52428800
   ```

**附加信息**

- ​							在各种情况下，磁盘 I/O 节流非常有用，例如，属于不同客户的虚拟机在同一主机上运行，或者在为不同的虚拟机提供服务质量时。磁盘 I/O 节流还可用来模拟较慢的磁盘。 					
- ​							I/O 节流可以独立于附加到虚拟机的每个块设备应用，并支持对吞吐量和 I/O 操作的限制。 					
- ​							红帽不支持使用 `virsh blkdeviotune` 命令在虚拟机上配置 I/O 节流。如需了解在使用 RHEL 9 作为虚拟机主机时不支持的功能的更多信息，请参阅 [第 22.3 节 “RHEL 9 虚拟化不支持的功能”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#unsupported-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization)。 					

### 17.5.3. 启用多队列 virtio-scsi

​					在虚拟机(VM)中使用 `virtio-scsi` 存储设备时，*multi-queue virtio-scsi* 功能可提高存储性能和可扩展性。它使每个虚拟 CPU(vCPU)可以有一个单独的队列，并在不影响其他 vCPU 的情况下使用中断。 			

**流程**

- ​							要为特定虚拟机启用多队列 virtio-scsi 支持，请将以下内容添加到虚拟机 XML 配置中，其中 *N* 是 vCPU 队列总数： 					

  ```xml
  <controller type='scsi' index='0' model='virtio-scsi'>
     <driver queues='N' />
  </controller>
  ```

## 17.6. 优化虚拟机 CPU 性能

​				与主机机器中的物理 CPU 类似，vCPU 对于虚拟机(VM)性能至关重要。因此，优化 vCPU 可能会对虚拟机的资源效率产生重大影响。优化 vCPU： 		

1. ​						调整分配给虚拟机的主机 CPU 数。您可以使用 [CLI](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-cpus-using-the-command-line-interface_optimizing-virtual-machine-cpu-performance) 或 [Web 控制台](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-cpus-using-the-web-console_optimizing-virtual-machine-cpu-performance)进行此操作。 				

2. ​						确保 vCPU 模型与主机的 CPU 型号一致。例如，将 *testguest1* 虚拟机设置为使用主机的 CPU 型号： 				

   ```none
   # virt-xml testguest1 --edit --cpu host-model
   ```

3. ​						[管理内核相同的页面合并(KSM)](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_managing-ksm_optimizing-virtual-machine-cpu-performance) 				

4. ​						如果您的主机使用非一致性内存访问(NUMA)，您也可以为其虚拟机**配置 NUMA**。这会尽可能将主机的 CPU 和内存进程映射到虚拟机的 CPU 和内存进程。实际上，NUMA 调优为 vCPU 提供更简化的访问分配给虚拟机的系统内存，从而可提高 vCPU 处理效率。 				

   ​						详情请参阅 [在虚拟机中配置 NUMA](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-numa-in-a-virtual-machine_optimizing-virtual-machine-cpu-performance) 以及 [Sample vCPU 性能调优场景](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sample-vcpu-performance-tuning-scenario_optimizing-virtual-machine-cpu-performance)。 				

### 17.6.1. 使用命令行界面添加和删除虚拟 CPU

​					要增加或优化虚拟机(VM)的 CPU 性能，您可以添加或删除分配给虚拟机的虚拟 CPU(vCPU)。 			

​					当在运行的虚拟机上执行时，这也被称为 vCPU 热插和热拔。但请注意，RHEL 9 不支持 vCPU 热拔，红帽不建议使用它。 			

**先决条件**

- ​							**可选：**查看目标虚拟机中的 vCPU 的当前状态。例如，显示 *testguest* 虚拟机上的 vCPU 数量： 					

  ```none
  # virsh vcpucount testguest
  maximum      config         4
  maximum      live           2
  current      config         2
  current      live           1
  ```

  ​							此输出显示 *testguest* 目前使用 1 个 vCPU，另外 1 个 vCPu 可以热插入以提高虚拟机性能。但是，重新引导后，vCPU *testguest* 使用的数量会改为 2，而且能够热插 2 个 vCPU。 					

**流程**

1. ​							调整可附加到虚拟机的 vCPU 数量上限，该数量对虚拟机下次引导生效。 					

   ​							例如，要将 *testguest* 虚拟机的最大 vCPU 数量增加到 8: 					

   ```none
   # virsh setvcpus testguest 8 --maximum --config
   ```

   ​							请注意，最大可能受 CPU 拓扑、主机硬件、虚拟机监控程序和其他因素的限制。 					

2. ​							调整附加到虚拟机的当前 vCPU 数量，最多调整上一步中配置的最大值。例如： 					

   - ​									将附加到正在运行的 *testguest* 虚拟机的 vCPU 数量增加到 4: 							

     ```none
     # virsh setvcpus testguest 4 --live
     ```

     ​									这会增加虚拟机的性能和主机的 *testguest* 负载占用，直到虚拟机下次引导为止。 							

   - ​									将附加到 *testguest* 虚拟机的 vCPU 数量永久减少至 1： 							

     ```none
     # virsh setvcpus testguest 1 --config
     ```

     ​									这会降低虚拟机的性能和 *testguest* 的主机负载占用。但是，如果需要可热插入虚拟机以暂时提高性能。 							

**验证**

- ​							确认虚拟机的 vCPU 的当前状态反映了您的更改。 					

  ```none
  # virsh vcpucount testguest
  maximum      config         8
  maximum      live           4
  current      config         1
  current      live           4
  ```

**其他资源**

- ​							[使用 Web 控制台管理虚拟 CPU](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-cpus-using-the-web-console_optimizing-virtual-machine-cpu-performance) 					

### 17.6.2. 使用 Web 控制台管理虚拟 CPU

​					使用 RHEL 9 web 控制台，您可以查看并配置 web 控制台连接的虚拟机使用的虚拟 CPU。 			

**先决条件**

- ​							Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 					

**步骤**

1. ​							在 Virtual Machines 界面中，点您要查看信息的虚拟机。 					

   ​							这时将打开一个新页面，其中包含有关所选虚拟机的基本信息，以及访问虚拟机的图形界面的 Console 部分。 					

2. ​							点 Overview 窗格中的 vCPU 数量旁边的编辑。 					

   ​							此时会出现 vCPU 详情对话框。 					

   [![显示 VM CPU 详情对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/822593b143a5fe3f23f61dc63a892afb/virt-cockpit-configure-vCPUs.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/822593b143a5fe3f23f61dc63a892afb/virt-cockpit-configure-vCPUs.png)

1. ​							为所选虚拟机配置虚拟 CPU。 					

   - ​									**vCPU 数量** - 当前正在使用的 vCPU 数量。 							

     注意

     ​										vCPU 数量不能超过 vCPU 的最大值。 								

   - ​									**vCPU 最大** - 可为虚拟机配置的最大虚拟 CPU 数。如果这个值大于 **vCPU Count**，可以为虚拟机附加额外的 vCPU。 							

   - ​									**插槽** - 向虚拟机公开的插槽数量。 							

   - ​									**每个插槽的内核数** - 向虚拟机公开的每个插槽的内核数。 							

   - ​									**每个内核的线程数** - 向虚拟机公开的每个内核的线程数。 							

     ​									请注意， **插槽**、**每个插槽的内核数**和**每个内核的线程数**选项调整了虚拟机的 CPU 拓扑。这对 vCPU 性能可能有用，并可能会影响客户机操作系统中特定软件的功能。如果您的部署不需要不同的设置，请保留默认值。 							

2. ​							点应用。 					

   ​							配置了虚拟机的虚拟 CPU。 					

   注意

   ​								对虚拟 CPU 设置的更改仅在重启虚拟机后生效。 						

**其他资源**

- ​							[使用命令行界面添加和删除虚拟 CPU](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#adding-and-removing-virtual-cpus-using-the-command-line-interface_optimizing-virtual-machine-cpu-performance) 					

### 17.6.3. 在虚拟机中配置 NUMA

​					以下方法可用于在 RHEL 9 主机上配置虚拟机(VM)的非一致性内存访问(NUMA)设置。 			

**先决条件**

- ​							主机是一个与 NUMA 兼容的机器。要检测是否是这种情况，请使用 `virsh nodeinfo` 命令并查看 `NUMA cell(s)` 行： 					

  ```none
  # virsh nodeinfo
  CPU model:           x86_64
  CPU(s):              48
  CPU frequency:       1200 MHz
  CPU socket(s):       1
  Core(s) per socket:  12
  Thread(s) per core:  2
  NUMA cell(s):        2
  Memory size:         67012964 KiB
  ```

  ​							如果行的值为 2 或更高，则主机与 NUMA 兼容。 					

**流程**

​						为了便于使用，您可以使用自动化实用程序和服务设置虚拟机的 NUMA 配置。但是，手动 NUMA 设置可能会显著提高性能。 				

​					**自动方法** 			

- ​							将虚拟机的 NUMA 策略设置为 `Preferred`。例如，对于 *testguest5* 虚拟机要这样做： 					

  ```none
  # virt-xml testguest5 --edit --vcpus placement=auto
  # virt-xml testguest5 --edit --numatune mode=preferred
  ```

- ​							在主机上启用自动 NUMA 均衡： 					

  ```none
  # echo 1 > /proc/sys/kernel/numa_balancing
  ```

- ​							使用 `numad` 命令自动将 VM CPU 与内存资源匹配。 					

  ```none
  # numad
  ```

​					**手动方法** 			

1. ​							将特定 vCPU 线程固定到特定主机 CPU 或者 CPU 范围。在非 NUMA 主机和虚拟机上也可以这样做，我们推荐您使用一种安全的方法来提高 vCPU 性能。 					

   ​							例如，以下命令将 *testguest6* 虚拟机的 vCPU 线程 0 到 5 分别固定到主机 CPU 1、3、5、7、9 和 11： 					

   ```none
   # virsh vcpupin testguest6 0 1
   # virsh vcpupin testguest6 1 3
   # virsh vcpupin testguest6 2 5
   # virsh vcpupin testguest6 3 7
   # virsh vcpupin testguest6 4 9
   # virsh vcpupin testguest6 5 11
   ```

   ​							之后，您可以验证操作是否成功： 					

   ```none
   # virsh vcpupin testguest6
   VCPU   CPU Affinity
   ----------------------
   0      1
   1      3
   2      5
   3      7
   4      9
   5      11
   ```

2. ​							固定 vCPU 线程后，您还可以将与指定虚拟机关联的 QEMU 进程线程固定到特定的主机 CPU 或 CPU 范围。例如：以下命令将 *testguest6* 的 QEMU 进程线程 固定到 CPU 13 和 15，确认成功： 					

   ```none
   # virsh emulatorpin testguest6 13,15
   # virsh emulatorpin testguest6
   emulator: CPU Affinity
   ----------------------------------
          *: 13,15
   ```

3. ​							最后，您还可以指定将具体分配给特定虚拟机的主机 NUMA 节点。这可提高虚拟机 vCPU 的主机内存用量。例如，以下命令将 *testguest6* 设置为使用主机 NUMA 节点 3 到 5，确认成功： 					

   ```none
   # virsh numatune testguest6 --nodeset 3-5
   # virsh numatune testguest6
   ```

注意

​						为了获得最佳性能，建议使用以上列出的所有手动调优方法 				

**已知问题**

- ​							[目前无法在 IBM Z 主机上执行 NUMA 调整](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#how-virtualization-on-ibm-z-differs-from-amd64-and-intel64_feature-support-and-limitations-in-rhel-9-virtualization)。 					

**其他资源**

- ​							[vCPU 性能调整场景示例](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sample-vcpu-performance-tuning-scenario_optimizing-virtual-machine-cpu-performance) 					
- ​							使用 `numastat` 程序[查看系统的当前 NUMA 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-machine-performance-monitoring-tools_optimizing-virtual-machine-performance-in-rhel) 					

### 17.6.4. vCPU 性能调整场景示例

​					为了获得最佳 vCPU 性能，红帽建议一起使用手动 `vcpupin`、`emulatorpin` 和 `numatune` 设置，例如在以下场景中。 			

**起始场景**

- ​							您的主机有以下与硬件相关的信息： 					

  - ​									2 个 NUMA 节点 							
  - ​									每个节点上的 3 个 CPU 内核 							
  - ​									每个内核有 2 个线程 							

  ​							此类机器的 `virsh nodeinfo` 的输出类似如下： 					

  ```none
  # virsh nodeinfo
  CPU model:           x86_64
  CPU(s):              12
  CPU frequency:       3661 MHz
  CPU socket(s):       2
  Core(s) per socket:  3
  Thread(s) per core:  2
  NUMA cell(s):        2
  Memory size:         31248692 KiB
  ```

- ​							您要修改一个现有的、带有 8 个 vCPU 的虚拟机，这意味着它并不适用于一个 NUMA 节点。 					

  ​							因此，您应该在每个 NUMA 节点上分发 4 个 vCPU，并使 vCPU 拓扑尽可能地与主机拓扑类似。这意味着，作为给定物理 CPU 的同级线程运行的 vCPU 应该固定到同一内核上的主机线程。详情请查看以下*解决方案*: 					

**解决方案**

1. ​							获取主机拓扑的信息： 					

   ```none
   # virsh capabilities
   ```

   ​							输出应包含类似如下的部分： 					

   ```xml
   <topology>
     <cells num="2">
       <cell id="0">
         <memory unit="KiB">15624346</memory>
         <pages unit="KiB" size="4">3906086</pages>
         <pages unit="KiB" size="2048">0</pages>
         <pages unit="KiB" size="1048576">0</pages>
         <distances>
           <sibling id="0" value="10" />
           <sibling id="1" value="21" />
         </distances>
         <cpus num="6">
           <cpu id="0" socket_id="0" core_id="0" siblings="0,3" />
           <cpu id="1" socket_id="0" core_id="1" siblings="1,4" />
           <cpu id="2" socket_id="0" core_id="2" siblings="2,5" />
           <cpu id="3" socket_id="0" core_id="0" siblings="0,3" />
           <cpu id="4" socket_id="0" core_id="1" siblings="1,4" />
           <cpu id="5" socket_id="0" core_id="2" siblings="2,5" />
         </cpus>
       </cell>
       <cell id="1">
         <memory unit="KiB">15624346</memory>
         <pages unit="KiB" size="4">3906086</pages>
         <pages unit="KiB" size="2048">0</pages>
         <pages unit="KiB" size="1048576">0</pages>
         <distances>
           <sibling id="0" value="21" />
           <sibling id="1" value="10" />
         </distances>
         <cpus num="6">
           <cpu id="6" socket_id="1" core_id="3" siblings="6,9" />
           <cpu id="7" socket_id="1" core_id="4" siblings="7,10" />
           <cpu id="8" socket_id="1" core_id="5" siblings="8,11" />
           <cpu id="9" socket_id="1" core_id="3" siblings="6,9" />
           <cpu id="10" socket_id="1" core_id="4" siblings="7,10" />
           <cpu id="11" socket_id="1" core_id="5" siblings="8,11" />
         </cpus>
       </cell>
     </cells>
   </topology>
   ```

2. ​							**可选：**使用[适用的工具和实用程序](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-machine-performance-monitoring-tools_optimizing-virtual-machine-performance-in-rhel)测试虚拟机的性能。 					

3. ​							在主机上设置并挂载 1 GiB 巨页： 					

   1. ​									在主机的内核命令行中添加以下行： 							

      ```none
      default_hugepagesz=1G hugepagesz=1G
      ```

   2. ​									使用以下内容创建 `/etc/systemd/system/hugetlb-gigantic-pages.service` 文件： 							

      ```none
      [Unit]
      Description=HugeTLB Gigantic Pages Reservation
      DefaultDependencies=no
      Before=dev-hugepages.mount
      ConditionPathExists=/sys/devices/system/node
      ConditionKernelCommandLine=hugepagesz=1G
      
      [Service]
      Type=oneshot
      RemainAfterExit=yes
      ExecStart=/etc/systemd/hugetlb-reserve-pages.sh
      
      [Install]
      WantedBy=sysinit.target
      ```

   3. ​									使用以下内容创建 `/etc/systemd/hugetlb-reserve-pages.sh` 文件： 							

      ```none
      #!/bin/sh
      
      nodes_path=/sys/devices/system/node/
      if [ ! -d $nodes_path ]; then
      	echo "ERROR: $nodes_path does not exist"
      	exit 1
      fi
      
      reserve_pages()
      {
      	echo $1 > $nodes_path/$2/hugepages/hugepages-1048576kB/nr_hugepages
      }
      
      reserve_pages 4 node1
      reserve_pages 4 node2
      ```

      ​									这会从 *node1* 保留 4 个 1GiB 巨页，并在 *node2* 中保留 4 个 1GiB 巨页。 							

   4. ​									使在上一步中创建的脚本可执行： 							

      ```none
      # chmod +x /etc/systemd/hugetlb-reserve-pages.sh
      ```

   5. ​									在引导时启用巨页保留： 							

      ```none
      # systemctl enable hugetlb-gigantic-pages
      ```

4. ​							使用 `virsh edit` 命令编辑您要优化的虚拟机的 XML 配置，在这个示例中 *super-VM* ： 					

   ```none
   # virsh edit super-vm
   ```

5. ​							用以下方法调整虚拟机的 XML 配置： 					

   1. ​									将虚拟机设置为使用 8 个静态 vCPU。使用 `<vcpu/>` 元素进行此操作。 							

   2. ​									将每个 vCPU 线程固定到拓扑中镜像的对应主机 CPU 线程。要做到这一点，使用 `<cputune>` 部分中的 `<vcpupin/>` 元素。 							

      ​									请注意，如上面的 `virsh capabilities` 工具程序所示，主机 CPU 线程不会按其对应的内核按顺序排序。另外，vCPU 线程应固定到同一 NUMA 节点上的可用主机内核集合。有关表图，请查看以下**示例拓扑**部分。 							

      ​									步骤 a. 和 b. 的 XML 配置类似： 							

      ```xml
      <cputune>
        <vcpupin vcpu='0' cpuset='1'/>
        <vcpupin vcpu='1' cpuset='4'/>
        <vcpupin vcpu='2' cpuset='2'/>
        <vcpupin vcpu='3' cpuset='5'/>
        <vcpupin vcpu='4' cpuset='7'/>
        <vcpupin vcpu='5' cpuset='10'/>
        <vcpupin vcpu='6' cpuset='8'/>
        <vcpupin vcpu='7' cpuset='11'/>
        <emulatorpin cpuset='6,9'/>
      </cputune>
      ```

   3. ​									将虚拟机设置为使用 1 GiB 巨页： 							

      ```xml
      <memoryBacking>
        <hugepages>
          <page size='1' unit='GiB'/>
        </hugepages>
      </memoryBacking>
      ```

   4. ​									配置虚拟机的 NUMA 节点，使其使用主机上对应的 NUMA 节点的内存。要做到这一点，使用 `<cputune>` 部分中的 `<memnode/>` 元素： 							

      ```xml
      <numatune>
        <memory mode="preferred" nodeset="1"/>
        <memnode cellid="0" mode="strict" nodeset="0"/>
        <memnode cellid="1" mode="strict" nodeset="1"/>
      </numatune>
      ```

   5. ​									确保 CPU 模式被设置为 `host-passthrough`，且 CPU 在 `passthrough` 模式中使用缓存： 							

      ```xml
      <cpu mode="host-passthrough">
        <topology sockets="2" cores="2" threads="2"/>
        <cache mode="passthrough"/>
      ```

**验证**

1. ​							确认虚拟机生成的 XML 配置包括以下部分： 					

   ```xml
   [...]
     <memoryBacking>
       <hugepages>
         <page size='1' unit='GiB'/>
       </hugepages>
     </memoryBacking>
     <vcpu placement='static'>8</vcpu>
     <cputune>
       <vcpupin vcpu='0' cpuset='1'/>
       <vcpupin vcpu='1' cpuset='4'/>
       <vcpupin vcpu='2' cpuset='2'/>
       <vcpupin vcpu='3' cpuset='5'/>
       <vcpupin vcpu='4' cpuset='7'/>
       <vcpupin vcpu='5' cpuset='10'/>
       <vcpupin vcpu='6' cpuset='8'/>
       <vcpupin vcpu='7' cpuset='11'/>
       <emulatorpin cpuset='6,9'/>
     </cputune>
     <numatune>
       <memory mode="preferred" nodeset="1"/>
       <memnode cellid="0" mode="strict" nodeset="0"/>
       <memnode cellid="1" mode="strict" nodeset="1"/>
     </numatune>
     <cpu mode="host-passthrough">
       <topology sockets="2" cores="2" threads="2"/>
       <cache mode="passthrough"/>
       <numa>
         <cell id="0" cpus="0-3" memory="2" unit="GiB">
           <distances>
             <sibling id="0" value="10"/>
             <sibling id="1" value="21"/>
           </distances>
         </cell>
         <cell id="1" cpus="4-7" memory="2" unit="GiB">
           <distances>
             <sibling id="0" value="21"/>
             <sibling id="1" value="10"/>
           </distances>
         </cell>
       </numa>
     </cpu>
   </domain>
   ```

2. ​							**可选：**使用[适用的工具和实用程序](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtual-machine-performance-monitoring-tools_optimizing-virtual-machine-performance-in-rhel)测试虚拟机的性能，以评估虚拟机优化的影响。 					

**拓扑示例**

- ​							下表演示了 vCPU 和主机 CPU 之间的连接： 					

  **表 17.1. 主机拓扑**

  | **CPU 线程**  | 0    | 3    | 1    | 4    | 2    | 5    | 6    | 9    | 7    | 10   | 8    | 11   |
  | ------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
  | **内核**      | 0    | 1    | 2    | 3    | 4    | 5    |      |      |      |      |      |      |
  | **插槽**      | 0    | 1    |      |      |      |      |      |      |      |      |      |      |
  | **NUMA 节点** | 0    | 1    |      |      |      |      |      |      |      |      |      |      |

  **表 17.2. VM 拓扑**

  | **vCPU 线程** | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    |
  | ------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
  | **内核**      | 0    | 1    | 2    | 3    |      |      |      |      |
  | **插槽**      | 0    | 1    |      |      |      |      |      |      |
  | **NUMA 节点** | 0    | 1    |      |      |      |      |      |      |

  **表 17.3. 合并主机和虚拟机拓扑**

  | **vCPU 线程**     |      | 0    | 1    | 2    | 3    |      | 4    | 5    | 6    | 7    |      |      |
  | ----------------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
  | **主机 CPU 线程** | 0    | 3    | 1    | 4    | 2    | 5    | 6    | 9    | 7    | 10   | 8    | 11   |
  | **内核**          | 0    | 1    | 2    | 3    | 4    | 5    |      |      |      |      |      |      |
  | **插槽**          | 0    | 1    |      |      |      |      |      |      |      |      |      |      |
  | **NUMA 节点**     | 0    | 1    |      |      |      |      |      |      |      |      |      |      |

  ​							在这种情况下，有 2 个 NUMA 节点和 8 个 vCPU。因此，应该为每个节点固定 4 个 vCPU 线程。 					

  ​							另外，红帽建议在每个节点中保留至少一个 CPU 线程用于主机系统操作。 					

  ​							因为在这个示例中，每个 NUMA 节点都托管了 3 个内核，每个内核都有 2 个主机 CPU 线程，所以为节点 0 设置的值如下： 					

  ```xml
  <vcpupin vcpu='0' cpuset='1'/>
  <vcpupin vcpu='1' cpuset='4'/>
  <vcpupin vcpu='2' cpuset='2'/>
  <vcpupin vcpu='3' cpuset='5'/>
  ```

### 17.6.5. 管理内核相同的页面合并

​					内核同页合并(KSM)通过在虚拟机(VM)间共享相同的内存页面来提高内存密度。但是，启用 KSM 会增加 CPU 使用率，并会根据工作负载造成负面影响。 			

​					根据您的要求，您可以为单个会话启用或禁用 KSM。 			

注意

​						在 RHEL 9 及更高版本中，默认为禁用 KSM。 				

**先决条件**

- ​							对主机系统的 root 访问权限。 					

**步骤**

- ​							禁用 KSM： 					

  - ​									要在一个会话中取消激活 KSM，请使用 `systemctl` 实用程序停止 `ksm` 和 `ksmtuned` 服务。 							

    ```none
    # systemctl stop ksm
    
    # systemctl stop ksmtuned
    ```

  - ​									要永久取消激活 KSM，请使用 `systemctl` 实用程序禁用 `ksm` 和 `ksmtuned` 服务。 							

    ```none
    # systemctl disable ksm
    Removed /etc/systemd/system/multi-user.target.wants/ksm.service.
    # systemctl disable ksmtuned
    Removed /etc/systemd/system/multi-user.target.wants/ksmtuned.service.
    ```

注意

​						取消激活 KSM 前在虚拟机间共享的内存页将保持共享。要停止共享，请使用以下命令删除系统中的所有 `PageKSM` 页面： 				

```none
# echo 2 > /sys/kernel/mm/ksm/run
```

​						在匿名页面替换了 KSM 页面后，`khugepaged` 内核服务将在虚拟机物理内存上重建透明巨页。 				

- ​							启用 KSM： 					

警告

​						启用 KSM 提高 CPU 使用率并影响总体 CPU 性能。 				

1. ​							安装 `ksmtuned` 服务： 					

   ```none
   # yum install ksmtuned
   ```

2. ​							启动服务： 					

   - ​									要为一个会话启用 KSM，请使用 `systemctl` 实用程序启动 `ksm` 和 `ksmtuned` 服务。 							

     ```none
     # systemctl start ksm
     # systemctl start ksmtuned
     ```

   - ​									要永久启用 KSM，请使用 `systemctl` 实用程序启用 `ksm` 和 `ksmtuned` 服务。 							

     ```none
     # systemctl enable ksm
     Created symlink /etc/systemd/system/multi-user.target.wants/ksm.service → /usr/lib/systemd/system/ksm.service
     
     # systemctl enable ksmtuned
     Created symlink /etc/systemd/system/multi-user.target.wants/ksmtuned.service → /usr/lib/systemd/system/ksmtuned.service
     ```

## 17.7. 优化虚拟机网络性能

​				由于虚拟机网络接口卡(NIC)的虚拟性质，虚拟机丢失了其分配的主机网络带宽的一部分，这可以降低虚拟机的整体工作负载效率。以下提示可以最小化虚拟化对虚拟 NIC(vNIC)吞吐量的影响。 		

**流程**

​					使用以下任一方法并观察它是否对虚拟机网络性能有帮助： 			

- 启用 vhost_net 模块

  ​							在主机上，确保 `vhost_net` 内核功能已启用： 					`# **lsmod | grep vhost** vhost_net              32768  1 vhost                  53248  1 vhost_net tap                    24576  1 vhost_net tun                    57344  6 vhost_net` 						如果这个命令的输出为空，请启用 `vhost_net` 内核模块： 					`# **modprobe vhost_net**`

- 设置多队列 virtio-net

  ​							要为虚拟机设置 *多队列 virtio-net* 功能，请使用 `virsh edit` 命令编辑虚拟机的 XML 配置。在 XML 中，将以下内容添加到 `<devices>` 部分，并使用虚拟机中的 vCPU 数量替换 `N`，最多为 16： 					`<interface type='network'>      <source network='default'/>      <model type='virtio'/>      <driver name='vhost' queues='N'/> </interface>` 						如果虚拟机正在运行，重启它以使更改生效。 					

- 批量网络数据包

  ​							在带有长传输路径的 Linux 虚拟机配置中，在将数据包提交到内核前，对数据包进行批处理可能会提高缓存利用率。要设置数据包批处理，在主机上使用以下命令，并将 *tap0* 替换为虚拟机使用的网络接口的名称： 					`# **ethtool -C \*tap0\* rx-frames 64**`

- SR-IOV

  ​							如果您的主机 NIC 支持 SR-IOV，请为您的 vNIC 使用 SR-IOV 设备分配。如需更多信息，请参阅管理 SR-IOV 设备。 					

**其他资源**

- ​						[了解虚拟网络](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#understanding-virtual-networking-overview_configuring-virtual-machine-network-connections) 				

## 17.8. 虚拟机性能监控工具

​				要识别哪些因素会占用最多 VM 资源，以及虚拟机性能需要优化的方面，可以使用一般和虚拟机特定工具。 		

**默认操作系统性能监控工具**

​					对于标准性能评估，您可以使用主机和虚拟机操作系统默认提供的实用程序： 			

- ​						在 RHEL 9 主机上，以 root 用户身份使用 `top` 实用程序或 **系统监控** 应用程序，并在输出中查找 `qemu` 和 `virt`。这显示了您的虚拟机消耗的主机系统资源量。 				
  - ​								如果监控工具显示任何 `qemu` 或 `virt` 进程消耗大量主机 CPU 或内存容量，请使用 `perf` 实用程序进行调查。详情请查看以下信息。 						
  - ​								另外，如果 `vhost_net` 线程进程（如 *vhost_net-1234* ）被显示为消耗大量主机 CPU 容量，请考虑使用 [虚拟网络优化功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-network-performance_optimizing-virtual-machine-performance-in-rhel)，如 `multi-queue virtio-net`。 						
- ​						在客户端操作系统中，使用系统中可用的性能实用程序和应用程序来评估哪些进程会占用最多系统资源。 				
  - ​								在 Linux 系统中，您可以使用 `top` 实用程序。 						
  - ​								在 Windows 系统中，您可以使用 **Task Manager** 应用程序。 						

**perf kvm**

​					您可以使用 `perf` 实用程序收集有关 RHEL 9 主机性能的特定虚拟化统计。要做到这一点： 			

1. ​						在主机上安装 *perf* 软件包： 				

   ```none
   # dnf install perf
   ```

2. ​						使用 `perf kvm stat` 命令之一显示虚拟化主机的 perf 统计： 				

   - ​								对于虚拟机监控程序的实时监控，请使用 `perf kvm stat live` 命令。 						
   - ​								要在一段时间内记录虚拟机监控程序的 perf 数据，请使用 `perf kvm stat record` 命令激活日志。在命令被取消或中断后，数据保存在 `perf.data.guest` 文件中，可以使用 `perf kvm stat report` 命令进行分析。 						

3. ​						分析 `VM-EXIT` 事件及其分布的类型的 `perf` 输出。例如，`PAUSE_INSTRUCTION` 事件应该不经常发生，但在以下输出中，这个事件出现的频率较高，这代表主机 CPU 没有很好地处理正在运行的 vCPU。在这种情况下，请考虑关闭部分运行的虚拟机、从这些虚拟机中移除 vCPU，或 [调整 vCPU 的性能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-cpu-performance_optimizing-virtual-machine-performance-in-rhel)。 				

   ```none
   # perf kvm stat report
   
   Analyze events for all VMs, all VCPUs:
   
   
                VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time
   
     EXTERNAL_INTERRUPT     365634    31.59%    18.04%      0.42us  58780.59us    204.08us ( +-   0.99% )
              MSR_WRITE     293428    25.35%     0.13%      0.59us  17873.02us      1.80us ( +-   4.63% )
       PREEMPTION_TIMER     276162    23.86%     0.23%      0.51us  21396.03us      3.38us ( +-   5.19% )
      PAUSE_INSTRUCTION     189375    16.36%    11.75%      0.72us  29655.25us    256.77us ( +-   0.70% )
                    HLT      20440     1.77%    69.83%      0.62us  79319.41us  14134.56us ( +-   0.79% )
                 VMCALL      12426     1.07%     0.03%      1.02us   5416.25us      8.77us ( +-   7.36% )
          EXCEPTION_NMI         27     0.00%     0.00%      0.69us      1.34us      0.98us ( +-   3.50% )
          EPT_MISCONFIG          5     0.00%     0.00%      5.15us     10.85us      7.88us ( +-  11.67% )
   
   Total Samples:1157497, Total events handled time:413728274.66us.
   ```

   ​						其他可以在 `perf kvm stat` 输出中指出问题的事件类型包括： 				

   - ​								`INSN_EMULATION` - 建议子优化 [VM I/O 配置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-virtual-machine-i-o-performance_optimizing-virtual-machine-performance-in-rhel). 						

​				有关使用 `perf` 监控虚拟化性能的更多信息，请参阅 `perf-kvm` man page。 		

**numastat**

​					要查看系统的当前 NUMA 配置，您可以使用 `numastat` 实用程序，该实用程序通过安装 **numactl** 软件包来提供。 			

​				以下显示了一个有 4 个运行虚拟机的主机，各自从多个 NUMA 节点获取内存。这不是 vCPU 性能的最佳方案，并[保证调整](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-numa-in-a-virtual-machine_optimizing-virtual-machine-cpu-performance)： 		

```none
# numastat -c qemu-kvm

Per-node process memory usage (in MBs)
PID              Node 0 Node 1 Node 2 Node 3 Node 4 Node 5 Node 6 Node 7 Total
---------------  ------ ------ ------ ------ ------ ------ ------ ------ -----
51722 (qemu-kvm)     68     16    357   6936      2      3    147    598  8128
51747 (qemu-kvm)    245     11      5     18   5172   2532      1     92  8076
53736 (qemu-kvm)     62    432   1661    506   4851    136     22    445  8116
53773 (qemu-kvm)   1393      3      1      2     12      0      0   6702  8114
---------------  ------ ------ ------ ------ ------ ------ ------ ------ -----
Total              1769    463   2024   7462  10037   2672    169   7837 32434
```

​				相反，以下显示单个节点为每个虚拟机提供内存，这效率显著提高。 		

```none
# numastat -c qemu-kvm

Per-node process memory usage (in MBs)
PID              Node 0 Node 1 Node 2 Node 3 Node 4 Node 5 Node 6 Node 7 Total
---------------  ------ ------ ------ ------ ------ ------ ------ ------ -----
51747 (qemu-kvm)      0      0      7      0   8072      0      1      0  8080
53736 (qemu-kvm)      0      0      7      0      0      0   8113      0  8120
53773 (qemu-kvm)      0      0      7      0      0      0      1   8110  8118
59065 (qemu-kvm)      0      0   8050      0      0      0      0      0  8051
---------------  ------ ------ ------ ------ ------ ------ ------ ------ -----
Total                 0      0   8072      0   8072      0   8114   8110 32368
```

## 17.9. 其他资源

- ​						[优化 Windows 虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-windows-virtual-machines-on-rhel_installing-and-managing-windows-virtual-machines-on-rhel) 				

# 第 18 章 保护虚拟机

​			作为使用虚拟机(VM)的 RHEL 9 系统管理员，保护虚拟机的安全可尽可能降低您的客户端和主机操作系统被恶意软件破坏的风险。 	

​			本文档概述了在 RHEL 9 主机上[保护虚拟机的机制 ，并提供提高虚拟机安全性的方法列表](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#how-security-works-in-virtual-machines_securing-virtual-machines-in-rhel)。 	

## 18.1. 虚拟机中的安全性是如何工作的

​				通过使用虚拟机，可在单一主机机器中托管多个操作系统。这些系统通过 hypervisor 与主机连接，通常也通过虚拟网络连接。因此，每个虚拟机可用作使用恶意软件攻击主机的向量，主机可以用作攻击任何虚拟机的向量。 		

**图 18.1. 在虚拟化主机上潜在的恶意软件攻击向量**

[![virt sec 成功攻击](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b3cca47c27c373413843c7b5cca0f90c/virt-sec_successful-attack.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/b3cca47c27c373413843c7b5cca0f90c/virt-sec_successful-attack.png)

​				因为虚拟机监控程序使用主机内核来管理虚拟机，所以在虚拟机操作系统中运行的服务通常会被利用来将恶意代码注入主机系统。但是，您可以使用主机和您的客体系统中的[安全功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#best-practices-for-securing-virtual-machines_securing-virtual-machines-in-rhel)来保护您的系统不受此类安全隐患。 		

​				这些功能（如 SELinux 或 QEMU 沙盒）提供了各种措施，使恶意代码难以攻击 hypervisor 并在您的主机和虚拟机之间进行传输。 		

**图 18.2. 防止对虚拟化主机进行恶意软件攻击**

[![Virt sec 阻止安全攻击](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a638209744e4c2c5c7ae8fe82818c6a5/virt-sec_prevented-attack.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a638209744e4c2c5c7ae8fe82818c6a5/virt-sec_prevented-attack.png)

​				RHEL 9 为虚拟机安全性提供的许多功能始终处于活动状态，且不必启用或配置。详情请查看 [第 18.5 节 “虚拟机安全性的自动功能”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#automatic-features-for-virtual-machine-security_securing-virtual-machines-in-rhel)。 		

​				另外，您可以遵循各种最佳实践来最小化虚拟机和虚拟机监控程序的漏洞。更多信息请参阅 [第 18.2 节 “保护虚拟机的最佳实践”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#best-practices-for-securing-virtual-machines_securing-virtual-machines-in-rhel)。 		

## 18.2. 保护虚拟机的最佳实践

​				根据以下步骤，您的虚拟机被恶意代码利用，并用作攻击向量攻击您的主机系统的风险会大幅降低。 		

​				**在客户端中：** 		

- ​						象保护物理机器一样保护虚拟机的安全。增强安全性的具体方法取决于客户端操作系统。 				

  ​						如果您的虚拟机正在运行 RHEL 9，请参阅[保护 Red Hat Enterprise Linux 9](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/) 的安全以改进客户端系统的安全性。 				

​				**在主机端：** 		

- ​						当远程管理虚拟机时，请使用加密的工具（如 **SSH**）和网络协议（如 **SSL**）连接到虚拟机。 				

- ​						确定 SELinux 处于 Enforcing 模式： 				

  ```none
  # getenforce
  Enforcing
  ```

  ​						如果 SELinux 被禁用或者处于 *Permissive* 模式，请参阅[使用 SELinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/changing-selinux-states-and-modes_using-selinux#changing-to-enforcing-mode_changing-selinux-states-and-modes) 文档来激活 Enforcing 模式。 				

  注意

  ​							SELinux Enforcing 模式还启用 sVirt RHEL 9 功能。这是用于虚拟化的一组特殊的 SELinux 布尔值，可[手动调整](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtualization-booleans-in-rhel_securing-virtual-machines-in-rhel)，以便进行细致的虚拟机安全管理。 					

- ​						使用带有 *SecureBoot* 的虚拟机： 				

  ​						SecureBoot 是一个功能，可确保您的虚拟机正在运行加密签名的操作系统。这可防止因为恶意软件攻击而更改了操作系统的虚拟机引导。 				

  ​						SecureBoot 只能在安装使用 OVMF 固件的 Linux 虚拟机时使用。具体说明请查看 [第 18.3 节 “创建 SecureBoot 虚拟机”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-a-secureboot-virtual-machine_securing-virtual-machines-in-rhel)。 				

- ​						不要使用 `qemu-*` 命令，如 `qemu-kvm`。 				

  ​						QEMU 是 RHEL 9 中虚拟化架构的基本组件，但难以手动管理，而且不正确的 QEMU 配置可能会导致安全漏洞。因此，红帽不支持使用 `qemu-*` 命令。反之，使用 `virsh`、`virt-install` 和 `virt-xml` 等 *libvirt* 实用程序，根据最佳实践来编排 QEMU。 				

**其他资源**

- ​						[RHEL 中虚拟化的 SELinux 布尔值](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#virtualization-booleans-in-rhel_securing-virtual-machines-in-rhel) 				

## 18.3. 创建 SecureBoot 虚拟机

​				您可以创建一个使用 *SecureBoot* 功能的 Linux 虚拟机(VM)，以确保您的虚拟机正在运行加密签名的操作系统。如果由于恶意软件更改了虚拟机的客户机操作系统，这很有用。在这种情况下，SecureBoot 可防止虚拟机引导，从而停止潜在的恶意软件分散到主机机器。 		

**先决条件**

- ​						虚拟机使用 Q35 机器类型。 				

- ​						已安装 `edk2-OVMF` 软件包： 				

  ```none
  # dnf install edk2-ovmf
  ```

- ​						操作系统（OS）安装源可存在于本地或者网络中。可以是以下格式之一： 				

  - ​								安装介质的 ISO 镜像 						

  - ​								现有虚拟机安装的磁盘镜像 						

    警告

    ​									在 RHEL 9 中无法从主机 CD-ROM 或者 DVD-ROM 设备安装。当使用 RHEL 9 中的任何虚拟机安装方法时，如果选择了 CD-ROM 或者 DVD-ROM 作为安装源，则安装将失败。如需更多信息，请参阅[红帽知识库](https://access.redhat.com/solutions/1185913)。 							

- ​						可选：可以提供一个 Kickstart 文件，以便更快地配置安装。 				

**流程**

1. ​						使用 `virt-install` 命令创建 [第 3.1 节 “使用命令行界面创建虚拟机”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-virtual-machines-using-the-command-line-interface_assembly_creating-virtual-machines) 中详述的虚拟机。对于 `--boot` 选项，使用 `uefi,nvram_template=/usr/share/OVMF/OVMF_VARS.secboot.fd` 值。这使用 `OVMF_VARS.secboot.fd` 和 `OVMF_CODE.secboot.fd` 文件作为虚拟机非易失性 RAM(NVRAM)设置的模板，它启用了 SecureBoot 功能。 				

   ​						例如： 				

   ```none
   # virt-install --name rhel8sb --memory 4096 --vcpus 4 --os-variant rhel9.0 --boot uefi,nvram_template=/usr/share/OVMF/OVMF_VARS.secboot.fd --disk boot_order=2,size=10 --disk boot_order=1,device=cdrom,bus=scsi,path=/images/RHEL-9.0-installation.iso
   ```

2. ​						根据屏幕中的说明进行操作 OS 安装过程。 				

**验证**

1. ​						安装客户机操作系统后，[在图形 guest 控制台中](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-graphical-console-using-virt-viewer_assembly_connecting-to-virtual-machines) 打开终端 或[使用 SSH](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_connecting-to-a-virtual-machine-using-ssh_assembly_connecting-to-virtual-machines) 连接到客户端操作系统，以访问虚拟机的命令行。 				

2. ​						要确认虚拟机上启用了 SecureBoot，请使用 `mokutil --sb-state` 命令： 				

   ```none
   # mokutil --sb-state
   SecureBoot enabled
   ```

**其他资源**

- ​						[在 AMD64、Intel 64 和 64 位 ARM 上安装 RHEL 9](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/performing_a_standard_rhel_9_installation/index#installing-rhel-on-adm64-intel-64-and-64-bit-arm) 				

## 18.4. 限制虚拟机用户可以使用什么操作

​				在某些情况下，在 RHEL 9 中托管的虚拟机(VM)用户可以默认执行。如果是这种情况，您可以通过将 `libvirt` 守护进程配置为在主机上使用 `polkit` 策略工具包来限制虚拟机用户可用的操作。 		

**流程**

1. ​						**可选：**请确定根据您的具体情况设置了与 `libvirt` 相关的 `polkit` 控制策略。 				

   1. ​								在 `/usr/share/polkit-1/actions/` 和 `/usr/share/polkit-1/rules.d/` 目录中查找与 libvirt 相关的文件。 						

      ```none
      # ls /usr/share/polkit-1/actions | grep libvirt
      # ls /usr/share/polkit-1/rules.d | grep libvirt
      ```

   2. ​								打开文件并查看规则设置。 						

      ​								有关读取 `polkit` 控制策略语法的详情，请使用 `man polkit`。 						

   3. ​								修改 `libvirt` 控制策略。要做到这一点： 						

      1. ​										在 `/etc/polkit-1/rules.d/` 目录中创建一个新的 `.conf` 文件。 								

      2. ​										将自定义策略添加到此文件，并保存它。 								

         ​										有关 `libvirt` 控制策略的更多信息和示例，请参阅 [ `libvirt` 上游文档](https://libvirt.org/aclpolkit.html#writing-access-control-policies)。 								

2. ​						配置虚拟机，以使用由 `polkit` 决定的访问策略。 				

   1. ​								查找 `/etc/libvirt/` 目录中的所有虚拟化驱动程序配置文件。 						

      ```none
      # ls /etc/libvirt/ | grep virt*d.conf
      ```

   2. ​								在每个文件中，取消对 `access_drivers = [ "polkit" ]` 行的注释，然后保存文件。 						

3. ​						对于您在上一步中修改的每个文件，请重新启动对应的服务。 				

   ​						例如，如果您修改了 `/etc/libvirt/virtqemud.conf`，请重新启动 `virtqemud` 服务。 				

   ```none
   # systemctl try-restart virtqemud
   ```

**验证**

- ​						作为您要限制的虚拟机操作的用户，请执行其中一个受限操作。 				

  ​						例如，如果非特权用户无法查看在系统会话中创建的虚拟机： 				

  ```none
  $ virsh -c qemu:///system list --all
  Id   Name           State
  -------------------------------
  ```

  ​						如果系统中的一个或多个虚拟机没有列出任何虚拟机，则 `polkit` 成功限制非特权用户的操作。 				

**故障排除**

- ​						目前，将 `libvirt` 配置为使用 `polkit` 便能够使用 [RHEL 9 web 控制台连接到虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization)，因为与 `libvirt-dbus` 服务不兼容。 				

  ​						如果您需要在 web 控制台中对虚拟机进行精细访问控制，红帽建议创建自定义 D-Bus 策略。具体步骤请查看[如何在红帽知识库中的 Cockpit 中配置对虚拟机进行精细的控制](https://access.redhat.com/solutions/6106401)。 				

**其他资源**

- ​						`man polkit` 命令 				
- ​						[polkit 访问控制策略的](https://libvirt.org/aclpolkit.html#writing-access-control-policies) `libvirt` man page 				

## 18.5. 虚拟机安全性的自动功能

​				除了手动改进 [第 18.2 节 “保护虚拟机的最佳实践”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#best-practices-for-securing-virtual-machines_securing-virtual-machines-in-rhel) 中列出的虚拟机安全性外，**libvirt** 软件套件还提供了一些安全功能，在 RHEL 9 中使用虚拟化时会自动启用。它们是： 		

- 系统和会话连接

  ​							要访问 RHEL 9 中虚拟机管理的所有可用实用程序，您需要使用 libvirt 的*系统连接* (`qemu:///system`)。要做到这一点，必须在系统中具有 root 权限，或者作为 *libvirt* 用户组的一部分。 					 						不位于 *libvirt* 组中的非 root 用户只能访问 libvirt 的*会话连接* (`qemu:///session`)，在访问资源时必须遵守本地用户的访问权限。例如，使用会话连接，您无法检测或访问在系统连接或者其他用户中创建的虚拟机。另外，可用的 VM 网络配置选项也有很大限制。 					注意 							RHEL 9 文档假定您有系统连接权限。 						

- 虚拟机分离

  ​							单个虚拟机作为隔离进程在主机上运行，并依赖于主机内核强制的安全性。因此，虚拟机不能读取或访问同一主机上其他虚拟机的内存或存储。 					

- QEMU 沙盒

  ​							防止 QEMU 代码执行系统调用的功能，这些调用可能会破坏主机的安全性。 					

- 内核地址空间 Randomization(KASLR)

  ​							启用随机调整内核镜像解压缩的物理和虚拟地址。因此，KASLR 可防止基于内核对象位置的客户机安全漏洞。 					

## 18.6. 用于虚拟化的 SELinux 布尔值

​				要在 RHEL 9 系统中对虚拟机安全性进行精细配置，您可以在主机上配置 SELinux 布尔值，以确保管理程序以特定方式执行。 		

​				要列出所有与虚拟化相关的布尔值及其状态，请使用 `getsebool -a | grep virt` 命令： 		

```none
$ getsebool -a | grep virt
[...]
virt_sandbox_use_netlink --> off
virt_sandbox_use_sys_admin --> off
virt_transition_userdomain --> off
virt_use_comm --> off
virt_use_execmem --> off
virt_use_fusefs --> off
[...]
```

​				要启用特定的布尔值，请以 root 用户身份使用 `setsebool -P *boolean_name* on` 命令。要禁用布尔值，请使用 `setsebool -P *boolean_name* off`。 		

​				下表列出了 RHEL 9 中可用的与虚拟化相关的布尔值以及启用后的功能： 		

**表 18.1. SELinux 虚拟化布尔值**

| SELinux 布尔值             | 描述                                               |
| -------------------------- | -------------------------------------------------- |
| staff_use_svirt            | 启用非 root 用户创建并转换虚拟机至 sVirt。         |
| unprivuser_use_svirt       | 启用非特权用户创建虚拟机并将其转换至 sVirt。       |
| virt_sandbox_use_audit     | 启用沙盒容器来发送审核信息。                       |
| virt_sandbox_use_netlink   | 启用沙盒容器使用 netlink 系统调用。                |
| virt_sandbox_use_sys_admin | 启用沙盒容器使用 sys_admin 系统调用，如 mount。    |
| virt_transition_userdomain | 启用虚拟进程作为用户域运行。                       |
| virt_use_comm              | 启用 virt 使用串行/并行通信端口。                  |
| virt_use_execmem           | 启用受限制的虚拟客户机使用可执行内存和可执行堆栈。 |
| virt_use_fusefs            | 启用 virt 读取 FUSE 挂载的文件。                   |
| virt_use_nfs               | 启用 virt 管理 NFS 挂载的文件。                    |
| virt_use_rawip             | 启用 virt 与 rawip 套接字交互。                    |
| virt_use_samba             | 启用 virt 管理 CIFS 挂载的文件。                   |
| virt_use_sanlock           | 启用受限制的虚拟客户机与 sanlock 交互。            |
| virt_use_usb               | 启用 virt 使用 USB 设备。                          |
| virt_use_xserver           | 启用虚拟机与 X 窗口系统交互。                      |

## 18.7. 在 IBM Z 中设置 IBM Secure Execution

​				当使用 IBM Z 硬件运行 RHEL 9 主机时，您可以通过为虚拟机配置 IBM Secure Execution 来提高虚拟机(VM)的安全性。 		

​				IBM Secure Execution（也称 Protected  Virtualization）可防止主机系统访问虚拟机的状态和内存内容。因此，即使主机被攻击，也无法用作攻击客户端操作系统的向量。另外，安全执行也可以用来防止不可信主机从虚拟机获取敏感信息。 		

​				以下流程描述了如何将 IBM Z 主机上的现有虚拟机转换为安全虚拟机。 		

**先决条件**

- ​						系统硬件是以下之一： 				

  - ​								IBM z15 或更高版本 						
  - ​								IBM LinuxONE III 或更高版本 						

- ​						为您的系统启用安全执行功能。要验证，请使用： 				

  ```none
  # grep facilities /proc/cpuinfo | grep 158
  ```

  ​						如果这个命令显示任何输出，代表您的 CPU 与安全执行兼容。 				

- ​						内核包含对安全执行的支持。要确认，请使用： 				

  ```none
  # ls /sys/firmware | grep uv
  ```

  ​						如果该命令生成任何输出，内核支持安全执行。 				

- ​						主机 CPU 模型包含 `unpack` 功能。要确认，请使用： 				

  ```none
  # virsh domcapabilities | grep unpack
  <feature policy='require' name='unpack'/>
  ```

  ​						如果命令生成以上输出，您的 CPU 主机模型与安全执行兼容。 				

- ​						虚拟机的 CPU 模式设置为 `host-model`。要确认这一点，请使用以下内容并将 `vm-name` 替换为您的虚拟机的名称。 				

  ```none
  # virsh dumpxml vm-name | grep "<cpu mode='host-model'/>"
  ```

  ​						如果命令生成任何输出，则会正确设置虚拟机的 CPU 模式。 				

- ​						主机上必须安装 *genprotimg* 软件包。 				

  ```none
  # dnf install genprotimg
  ```

- ​						您已获取并验证了 IBM Z 主机密钥文档。有关这样做的步骤，请参阅 IBM 文档中的[验证主机密钥文档](https://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lxse/lxse_t_verify.html#lxse_verify)。 				

**流程**

​					**在主机中**执行以下步骤： 			

1. ​						将 `prot_virt=1` 内核参数添加到主机的[引导配置](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel#changing-kernel-command-line-parameters-for-all-boot-entries_setting-kernel-command-line-parameters)。 				

   ```none
   # grubby --update-kernel=ALL --args="prot_virt=1"
   ```

2. ​						启用 virtio 设备，以便在您要保护的虚拟机中使用共享缓冲区。要做到这一点，使用 `virsh edit` 修改虚拟机的 XML 配置，并将 `iommu='on'` 添加到所有设备的 `<driver>` 行中。例如： 				

   ```xml
   <interface type='network'>
     <source network='default'/>
     <model type='virtio'/>
     <driver name='vhost' iommu='on'/>
   </interface>
   ```

   ​						如果设备配置不包含任何 `<driver>` 行，请添加 `<driver iommu='on'\>`。 				

3. ​						禁用虚拟机上的内存 Ballooning，因为此功能与安全执行不兼容。要做到这一点，请在虚拟机 XML 配置中添加以下行。 				

   ```xml
   <memballoon model='none'/>
   ```

​				在您要保护的虚拟机的**客户机操作系统中**执行以下步骤。 		

1. ​						创建参数文件。例如： 				

   ```none
   # touch ~/secure-parameters
   ```

2. ​						在 `/boot/loader/entries` 目录中，使用最新版本识别引导装载程序条目： 				

   ```none
   # ls /boot/loader/entries -l
   [...]
   -rw-r--r--. 1 root root  281 Oct  9 15:51 3ab27a195c2849429927b00679db15c1-4.18.0-240.el8.s390x.conf
   ```

3. ​						检索引导装载程序条目的内核选项行： 				

   ```none
   # cat /boot/loader/entries/3ab27a195c2849429927b00679db15c1-4.18.0-240.el8.s390x.conf | grep options
   options root=/dev/mapper/rhel-root
   rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap
   ```

4. ​						将选项行和 `swiotlb=262144` 的内容添加到创建的参数文件。 				

   ```none
   # echo "root=/dev/mapper/rhel-root rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap swiotlb=262144" > ~/secure-parameters
   ```

5. ​						生成 IBM 安全执行镜像。 				

   ​						例如，以下命令基于 `/boot/vmlinuz-4.18.0-240.el8.s390x` 镜像创建一个 `/boot/secure-image` 安全镜像（使用 `secure-parameters` 文件），`/boot/initramfs-4.18.0-240.el8.s390x.img` 初始 RAM 磁盘文件和 `HKD-8651-000201C048.crt` 主机密钥文档。 				

   ```none
   # genprotimg -i /boot/vmlinuz-4.18.0-240.el8.s390x -r /boot/initramfs-4.18.0-240.el8.s390x.img -p ~/secure-parameters -k HKD-8651-00020089A8.crt -o /boot/secure-image
   ```

   ​						使用 `genprotimg` 实用程序创建安全镜像，其中包含内核参数、初始 RAM 磁盘和引导镜像。 				

6. ​						更新虚拟机的引导菜单，以从安全镜像引导。此外，删除以 `initrd` 和 `options` 开头的行，因为它们不需要。 				

   ​						例如，在 RHEL 8.3 虚拟机中，可以在 `/boot/loader/entries/` 目录中编辑引导菜单： 				

   ```none
   # cat /boot/loader/entries/3ab27a195c2849429927b00679db15c1-4.18.0-240.el8.s390x.conf
   title Red Hat Enterprise Linux 8.3
   version 4.18.0-240.el8.s390x
   linux /boot/secure-image
   [...]
   ```

7. ​						创建可引导磁盘镜像 				

   ```none
   # zipl -V
   ```

8. ​						安全地删除原始的未保护的文件。例如： 				

   ```none
   # shred /boot/vmlinuz-4.18.0-240.el8.s390x
   # shred /boot/initramfs-4.18.0-240.el8.s390x.img
   # shred secure-parameters
   ```

   ​						原始引导镜像、初始 RAM 镜像和内核参数文件不受保护，如果未移除，启用了安全执行的虚拟机仍然容易受到攻击，导致尝试或敏感数据最小。 				

**验证**

- ​						在主机上，使用 `virsh dumpxml` 程序确认安全虚拟机的 XML 配置。配置必须包含 `<driver iommu='on'/>` 和 `<memballoon model='none'/>` 元素。 				

  ```none
  # virsh dumpxml vm-name
  [...]
    <cpu mode='host-model'/>
    <devices>
      <disk type='file' device='disk'>
        <driver name='qemu' type='qcow2' cache='none' io='native' iommu='on'>
        <source file='/var/lib/libvirt/images/secure-guest.qcow2'/>
        <target dev='vda' bus='virtio'/>
      </disk>
      <interface type='network'>
        <driver iommu='on'/>
        <source network='default'/>
        <model type='virtio'/>
      </interface>
      <console type='pty'/>
      <memballoon model='none'/>
    </devices>
  </domain>
  ```

**其他资源**

- ​						[配置内核命令行参数](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel) 				
- ​						[`genprotimg`上的 IBM 文档](https://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lxse/lxse_r_cmd.html#cmd_genprotimg) 				

## 18.8. 将加密 coprocessors 附加到 IBM Z 上的虚拟机

​				要在 IBM Z 主机上的虚拟机中使用硬件加密，请从加密的 coprocessor 设备创建介质设备并将其分配给预期的虚拟机。具体步骤请查看以下说明。 		

**先决条件**

- ​						您的主机运行在 IBM Z 硬件上。 				

- ​						加密 coprocessor 与设备分配兼容。要确认这一点，请确保您的 coprocessor 的 `type` 列为 `CEX4` 或更高版本。 				

  ```none
  # lszcrypt -V
  
  CARD.DOMAIN TYPE  MODE        STATUS  REQUESTS  PENDING HWTYPE QDEPTH FUNCTIONS  DRIVER
  --------------------------------------------------------------------------------------------
  05         CEX5C CCA-Coproc  online         1        0     11     08 S--D--N--  cex4card
  05.0004    CEX5C CCA-Coproc  online         1        0     11     08 S--D--N--  cex4queue
  05.00ab    CEX5C CCA-Coproc  online         1        0     11     08 S--D--N--  cex4queue
  ```

- ​						已安装 *mdevctl* 软件包。 				

- ​						载入 `vfio_ap` 内核模块。要验证，请使用： 				

  ```none
  # lsmod | grep vfio_ap
  vfio_ap         24576  0
  [...]
  ```

  ​						要载入模块，请使用： 				

  ```none
  # modprobe vfio_ap
  ```

**流程**

1. ​						在主机上，将加密设备重新分配给 `vfio-ap` 驱动程序。以下示例将两个带有位掩码 ID `(0x05, 0x0004)` 和 `(0x05, 0x00ab)` 的加密设备分配给 `vfio-ap`。 				

   ```none
   #  echo -0x05 > /sys/bus/ap/apmask
   #  echo -0x0004, -0x00ab > /sys/bus/ap/aqmask
   ```

   ​						有关识别位掩码 ID 值的信息，请参阅 IBM 的 KVM Virtual Server Management 文档中的[为加密适配器资源准备直通设备](http://public.dhe.ibm.com/software/dw/linux390/docu/l19bva05.pdf)。 				

2. ​						验证是否正确分配了加密设备。 				

   ```none
   # lszcrypt -V
   
   CARD.DOMAIN TYPE  MODE        STATUS  REQUESTS  PENDING HWTYPE QDEPTH FUNCTIONS  DRIVER
   --------------------------------------------------------------------------------------------
   05          CEX5C CCA-Coproc  -              1        0     11     08 S--D--N--  cex4card
   05.0004     CEX5C CCA-Coproc  -              1        0     11     08 S--D--N--  vfio_ap
   05.00ab     CEX5C CCA-Coproc  -              1        0     11     08 S--D--N--  vfio_ap
   ```

   ​						如果域队列的 DRIVER 值变为 `vfio_ap`，则重新分配成功。 				

3. ​						生成设备 UUID。 				

   ```none
   # uuidgen
   669d9b23-fe1b-4ecb-be08-a2fabca99b71
   ```

   ​						在以下步骤中，将 `669d9b23-fe1b-4ecb-be08-a2fabca99b71` 替换为您的生成的 UUID。 				

4. ​						使用 UUID，新建 `vfio_ap` 设备。 				

   ​						以下示例演示了创建永久介质设备并为它分配队列。例如，以下命令将域适配器 `0x05` 和域队列 `0x0004` 和 `0x00ab` 分配给设备 `669d9b23-fe1b-4ecb-be08-a2fabca99b71`。 				

   ```none
   # mdevctl define --uuid 669d9b23-fe1b-4ecb-be08-a2fabca99b71 --parent matrix --type vfio_ap-passthrough
   # mdevctl modify --uuid 669d9b23-fe1b-4ecb-be08-a2fabca99b71 --addattr=assign_adapter --value=0x05
   # mdevctl modify --uuid 669d9b23-fe1b-4ecb-be08-a2fabca99b71 --addattr=assign_domain --value=0x0004
   # mdevctl modify --uuid 669d9b23-fe1b-4ecb-be08-a2fabca99b71 --addattr=assign_domain --value=0x00ab
   ```

5. ​						启动介质设备。 				

   ```none
   # mdevctl start --uuid 669d9b23-fe1b-4ecb-be08-a2fabca99b71
   ```

6. ​						检查配置是否已正确应用 				

   ```none
   # cat /sys/devices/vfio_ap/matrix/mdev_supported_types/vfio_ap-passthrough/devices/669d9b23-fe1b-4ecb-be08-a2fabca99b71/matrix
   05.0004
   05.00ab
   ```

   ​						如果输出包含您之前分配给 `vfio-ap` 的队列的数字值，该过程会成功。 				

7. ​						使用 `virsh edit` 命令打开您要使用加密设备的虚拟机的 XML 配置。 				

   ```none
   # virsh edit vm-name
   ```

8. ​						在 XML 配置的 `<devices>` 部分添加以下行，并保存它。 				

   ```xml
   <hostdev mode='subsystem' type='mdev' managed='no' model='vfio-ap'>
     <source>
       <address uuid='669d9b23-fe1b-4ecb-be08-a2fabca99b71'/>
     </source>
   </hostdev>
   ```

   ​						请注意，每个 UUID 每次只能分配给一个虚拟机。 				

**验证**

1. ​						启动您为其分配该介质设备的虚拟机。 				

2. ​						客户端操作系统引导后，请确定它检测到分配的加密设备。 				

   ```none
   # lszcrypt -V
   
   CARD.DOMAIN TYPE  MODE        STATUS  REQUESTS  PENDING HWTYPE QDEPTH FUNCTIONS  DRIVER
   --------------------------------------------------------------------------------------------
   05          CEX5C CCA-Coproc  online         1        0     11     08 S--D--N--  cex4card
   05.0004     CEX5C CCA-Coproc  online         1        0     11     08 S--D--N--  cex4queue
   05.00ab     CEX5C CCA-Coproc  online         1        0     11     08 S--D--N--  cex4queue
   ```

   ​						客户机操作系统中的这个命令的输出，与在有相同加密的 coprocessor 设备的主机逻辑分区中是一致的。 				

## 18.9. 在 Windows 虚拟机中启用标准硬件安全性

​				要保护 Windows 虚拟机，您可以使用 Windows 设备的标准硬件功能启用基本级别的安全性。 		

**先决条件**

- ​						请确定您安装了最新的 WHQL 认证的 VirtIO 驱动程序。 				

- ​						确保虚拟机固件支持 UEFI 引导。 				

- ​						在主机机器上安装 `edk2-OVMF` 软件包。 				

  ```none
  # dnf install edk2-ovmf
  ```

- ​						在主机机器上安装 `vTPM` 软件包。 				

  ```none
  # dnf install swtpm libtpms
  ```

- ​						确保虚拟机使用 Q35 机器架构。 				

- ​						请确定您有 Windows 安装介质。 				

**流程**

1. ​						通过在虚拟机 XML 配置的 `<devices>` 部分添加以下参数来启用 TPM 2.0。 				

   ```xml
   <devices>
   [...]
     <tpm model='tpm-crb'>
       <backend type='emulator' version='2.0'/>
     </tpm>
   [...]
   </devices>
   ```

2. ​						在 UEFI 模式中安装 Windows。有关如何操作的更多信息，请参阅 [第 18.3 节 “创建 SecureBoot 虚拟机”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-a-secureboot-virtual-machine_securing-virtual-machines-in-rhel)。 				

3. ​						在 Windows 虚拟机上安装 VirtIO 驱动程序。有关如何操作的更多信息，请参阅在 Windows 客户端中安装 KVM 驱动程序。 				

4. ​						在 UEFI 中，启用安全引导。有关如何进行此操作的更多信息，请参阅 [安全引导](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/secure-boot-landing)。 				

**验证**

- ​						确定 Windows 机器中的**设备安全性**页面显示以下信息： 				

  ​						**Settings > Update & Security > Windows Security > Device Security** 				

  ```none
  Your device meets the requirements for standard hardware security.
  ```

## 18.10. 在 Windows 虚拟机上启用增强的硬件安全性

​				要进一步保护 Windows 虚拟机，您可以启用基于虚拟化的代码完整性保护，也称为 Hypervisor-Protected Code Integrity(HVCI)。 		

**先决条件**

- ​						确保启用了标准硬件安全性。如需更多信息，请参阅在 [Windows 虚拟机上启用标准硬件安全性](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-standard-harware-security-on-windows-virtual-machines_securing-virtual-machines-in-rhel)。 				

- ​						确保启用 KVM 嵌套功能。如需更多信息，请参阅[创建嵌套虚拟机](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-nested-virtual-machines_configuring-and-managing-virtualization)。 				

- ​						在 KVM 命令行上， 				

  - ​								指定 CPU 模型。 						

  - ​								启用虚拟机扩展(VMX)功能。 						

  - ​								启用 Hyper-V enlightenments。 						

    ```none
    # -cpu Skylake-Client-v3,hv_stimer,hv_synic,hv_relaxed,hv_reenlightenment,hv_spinlocks=0xfff,hv_vpindex,hv_vapic,hv_time,hv_frequencies,hv_runtime,+kvm_pv_unhalt,+vmx
    ```

**流程**

1. ​						在 Windows 虚拟机上，进入 **Core 隔离详情页面** ： 				

   ​						**Settings > Update & Security > Windows Security > Device Security > Core isolation details** 				

2. ​						切换开关以启用**内存完整性**。 				

3. ​						重启虚拟机。 				

注意

​					有关启用 HVCI 的其他方法，请查看相关的 Microsoft 文档。 			

**验证**

- ​						确定 Windows 虚拟机上的**设备安全性**页面显示以下信息： 				

  ​						**Settings > Update & Security > Windows Security > Device Security** 				

  ```none
  Your device meets the requirements for enhanced hardware security.
  ```

- ​						或者，在 Windows 虚拟机上检查系统信息： 				

  1. ​								在命令提示符中运行 `msinfo32.exe`。 						
  2. ​								检查 **Credential Guard, Hypervisor enforced Code Integrity** 是否在 **Virtualization-based security Services Running** 下列出。 						

# 第 19 章 在主机及其虚拟机间共享文件

​			您可能需要在主机系统和其运行的虚拟机(VM)间共享数据。要快速有效地完成此操作，您可以在系统中设置 NFS 或 Samba 文件共享。作为 RHEL 9 中新支持的功能，您还可以使用 `virtiofs` 文件系统与 Linux 虚拟机共享数据。 	

## 19.1. 使用 virtiofs 在主机及其虚拟机间共享文件

​				当使用 RHEL 9 作为管理程序时，您可以使用 `virtiofs` 功能在主机系统及其虚拟机(VM)之间高效地共享文件。 		

**先决条件**

- ​						虚拟化已在 RHEL 9 主机 [上安装并启用](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)。 				

- ​						要与虚拟机共享的目录。如果您不想共享任何现有目录，请创建一个新目录，例如： *shared-files*。 				

  ```none
  # mkdir /root/shared-files
  ```

- ​						要共享数据的虚拟机使用 Linux 发行版作为其客户机操作系统。 				

**步骤**

1. ​						对于您要与虚拟机共享的主机的每个目录，请在虚拟机 XML 配置中将其设置为 virtiofs 文件系统。 				

   1. ​								打开预期虚拟机的 XML 配置。 						

      ```none
      # virsh edit vm-name
      ```

   2. ​								在虚拟机 XML 配置的 `<devices>` 部分添加类似于以下内容的条目。 						

      ```xml
      <filesystem type='mount' accessmode='passthrough'>
        <driver type='virtiofs'/>
        <binary path='/usr/libexec/virtiofsd' xattr='on'/>
        <source dir='/root/shared-files'/>
        <target dir='host-file-share'/>
      </filesystem>
      ```

      ​								本例设置主机上的 `/root/shared-files` 目录，使其作为 `host-file-share` 呈现给虚拟机。 						

2. ​						为 XML 配置添加共享内存的 NUMA 拓扑。以下示例为所有 CPU 和所有 RAM 添加基本拓扑。 				

   ```xml
   <cpu mode='host-passthrough' check='none'>
     <numa>
       <cell id='0' cpus='0-{number-vcpus - 1}' memory='{ram-amount-KiB}' unit='KiB' memAccess='shared'/>
     </numa>
   </cpu>
   ```

3. ​						将共享内存支持添加到 XML 配置的 `<domain>` 部分： 				

   ```xml
   <domain>
    [...]
    <memoryBacking>
      <access mode='shared'/>
    </memoryBacking>
    [...]
   </domain>
   ```

4. ​						引导虚拟机。 				

   ```none
   # virsh start vm-name
   ```

5. ​						在客户端操作系统(OS)中挂载文件系统。以下示例使用 Linux 客户机操作系统挂载之前配置的 `host-file-share` 目录。 				

   ```none
   # mount -t virtiofs host-file-share /mnt
   ```

**验证**

- ​						确保共享目录可在虚拟机上访问，且您现在可以打开文件存储在 目录中。 				

**限制和已知问题**

- ​						与访问时间相关的文件系统挂载选项（如 `noatime` 和 `strictatime` ）可能不适用于 virtiofs，红帽不建议使用它。 				

**故障排除**

- ​						如果 `virtiofs` 不适用于您的用例或系统支持，您可以使用 [NFS](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-files-between-the-host-and-linux-virtual-machines_sharing-files-between-the-host-and-its-virtual-machines) 或者 [Samba](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-files-between-the-host-and-windows-virtual-machines_sharing-files-between-the-host-and-its-virtual-machines)。 				

## 19.2. 使用 web 控制台使用 virtiofs 在主机及其虚拟机间共享文件

​				您可以使用 RHEL web 控制台使用 `virtiofs` 功能在主机系统及其虚拟机(VM)之间高效地共享文件。 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				

- ​						要与虚拟机共享的目录。如果您不想共享任何现有目录，请创建一个新目录，例如，名为 *centurion*。 				

  ```none
  # mkdir /home/centurion
  ```

- ​						要共享数据的虚拟机使用 Linux 发行版作为其客户机操作系统。 				

**流程**

1. ​						在 Virtual Machines 接口中，点击您要共享文件的虚拟机。 				

   ​						这时将打开一个新页面，其中有一个 **Overview** 部分，其中包含有关所选虚拟机和 **Console** 部分的基本信息。 				

2. ​						滚动到共享目录。 				

   ​						**Shared directories** 部分显示由该虚拟机共享的主机文件和目录的信息，以及用于 **Add** 或 **Remove** 共享目录的选项。 				

   [![显示所选虚拟机共享的目录的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ad19f004c4560f7e5f32a114629e7b3e/virt-cockpit-shared-directory-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ad19f004c4560f7e5f32a114629e7b3e/virt-cockpit-shared-directory-info.png)

3. ​						点 Add shared directory。 				

   ​						此时会出现 **Share a host directory with the guest** 对话框。 				

   [![使用 guest 对话框显示共享主机目录的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/170264f3a13e4c99f71f9ea8a8ca5b31/virt-cockpit-shared-directory-add.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/170264f3a13e4c99f71f9ea8a8ca5b31/virt-cockpit-shared-directory-add.png)

4. ​						输入以下信息： 				

   - ​								**Source path** - 您要共享的主机目录的路径。 						
   - ​								**Mount tag** - 虚拟机用来挂载目录的标签。 						

5. ​						设置附加选项： 				

   - ​								**扩展属性** - 设置是否在共享文件和目录上启用扩展属性 `xattr`。 						

6. ​						单击 Share。 				

   ​						所选目录与虚拟机共享。 				

**验证**

- ​						确保共享目录可在虚拟机上访问，您现在可以打开存储在该目录中的文件。 				

## 19.3. 使用 web 控制台使用 virtiofs 删除主机及其虚拟机之间的共享文件

​				您可以使用 RHEL web 控制台删除主机系统及其虚拟机(VM)使用 `virtiofs` 功能共享的文件。 		

**先决条件**

- ​						Web 控制台 VM 插件 [已安装在您的系统上](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#setting-up-the-rhel-web-console-to-manage-vms_managing-virtual-machines-in-the-web-console)。 				
- ​						虚拟机不再使用该目录。 				

**流程**

1. ​						在 Virtual Machines 接口中，点您要从中删除共享文件的虚拟机。 				

   ​						这时将打开一个新页面，其中有一个 **Overview** 部分，其中包含有关所选虚拟机和 **Console** 部分的基本信息。 				

2. ​						滚动到共享目录。 				

   ​						**Shared directories** 部分显示由该虚拟机共享的主机文件和目录的信息，以及用于 **Add** 或 **Remove** 共享目录的选项。 				

   [![显示所选虚拟机共享的目录的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ad19f004c4560f7e5f32a114629e7b3e/virt-cockpit-shared-directory-info.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/ad19f004c4560f7e5f32a114629e7b3e/virt-cockpit-shared-directory-info.png)

3. ​						点击您要与虚拟机未共享的目录旁边的 Remove。 				

   ​						此时会出现 **Remove filesystem** 对话框。 				

   [![显示删除文件系统对话框的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/d3dc5f2b5e8cd5468cd930062e4f1803/virt-cockpit-shared-directory-remove.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/d3dc5f2b5e8cd5468cd930062e4f1803/virt-cockpit-shared-directory-remove.png)

4. ​						单击 Remove。 				

   ​						所选目录与虚拟机不共享。 				

**验证**

- ​						共享目录不再可用，并可从虚拟机访问。 				

## 19.4. 使用 NFS 在主机和 Linux 虚拟机间共享文件

​				为了在您的 RHEL 9 主机系统和连接到的 Linux 虚拟机间有效文件共享，请使用 [`virtiofs`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/sharing-files-between-the-host-and-its-virtual-machines-using-virtiofs_sharing-files-between-the-host-and-its-virtual-machines) 功能。但是，如果 `virtiofs` 不适用于您的用例，也可以导出虚拟机可以挂载和访问的 NFS 共享。 		

**先决条件**

- ​						`nfs-utils` 软件包已安装在主机上。 				

- ​						要与虚拟机共享的目录。如果您不想共享任何现有目录，请创建一个新目录，例如： *shared-files*。 				

  ```none
  # mkdir shared-files
  ```

- ​						主机可以通过虚拟机的网络可见并可访问。通常情况下，如果虚拟机使用 *NAT* 和*网桥*类型虚拟网络进行连接，则会出现这种情况。然而，对于 *macvtap* 连接，您必须首先在主机上设置 *macvlan* 功能。要做到这一点： 				

  1. ​								在主机的 `/etc/systemd/network/` 目录中创建一个网络设备文件，如 `vm-macvlan.netdev`。 						

     ```none
     # vim /etc/systemd/network/vm-macvlan.netdev
     ```

  2. ​								编辑网络设备文件，使其包含以下内容。您可以将 `vm-macvlan` 替换为您为网络设备选择的名称。 						

     ```none
     [NetDev]
     Name=vm-macvlan
     Kind=macvlan
     
     [MACVLAN]
     Mode=bridge
     ```

  3. ​								为 macvlan 网络设备创建网络配置文件，如 `vm-macvlan.network`。 						

     ```none
     # vim /etc/systemd/network/vm-macvlan.network
     ```

  4. ​								编辑网络配置文件使其包含以下内容。您可以将 `vm-macvlan` 替换为您为网络设备选择的名称。 						

     ```none
     [Match]
     Name=_vm-macvlan_
     
     [Network]
     IPForward=yes
     Address=192.168.250.33/24
     Gateway=192.168.250.1
     DNS=192.168.250.1
     ```

  5. ​								为您的物理网络接口创建网络配置文件。例如，如果您的接口是 `enp4s0` ： 						

     ```none
     # vim /etc/systemd/network/enp4s0.network
     ```

     ​								如果您不确定要使用的接口名称，您可以使用主机上的 `ifconfig` 命令获取活跃网络接口列表。 						

  6. ​								编辑物理网络配置文件，使物理网络成为 macvlan 接口的一部分，在本例中为 *vm-macvlan*： 						

     ```none
     [Match]
     Name=enp4s0
     
     [Network]
     MACVLAN=vm-macvlan
     ```

  7. ​								重启您的主机。 						

- ​						**可选：**为了提高安全性，请确保您的虚拟机与 NFS 版本 4 或更高版本兼容。 				

**步骤**

1. ​						在主机上，导出包含您要作为网络文件系统(NFS)共享的文件的目录。 				

   1. ​								获取您要共享文件的每个虚拟机的 IP 地址。以下示例获取 *testguest1* 和 *testguest2* 的 IP 地址。 						

      ```none
      # virsh domifaddr testguest1
      Name       MAC address          Protocol     Address
      ----------------------------------------------------------------
      vnet0      52:53:00:84:57:90    ipv4         192.168.124.220/24
      
      # virsh domifaddr testguest2
      Name       MAC address          Protocol     Address
      ----------------------------------------------------------------
      vnet1      52:53:00:65:29:21    ipv4         192.168.124.17/24
      ```

   2. ​								编辑主机上的 `/etc/exports` 文件，再添加一个行，其中包含您要共享的目录、您想要共享的虚拟机 IP 和共享选项。 						

      ```none
      Shared directory VM1-IP(options) VM2-IP(options) [...]
      ```

      ​								例如，以下将主机上的 `/usr/local/shared-files` 目录与 *testguest1* 和 *testguest2* 共享，并允许虚拟机编辑目录的内容： 						

      ```none
      /usr/local/shared-files/ 192.168.124.220(rw,sync) 192.168.124.17(rw,sync)
      ```

   3. ​								导出更新的文件系统。 						

      ```none
      # exportfs -a
      ```

   4. ​								确定启动 NFS 进程： 						

      ```none
      # systemctl start nfs-server
      ```

   5. ​								获取主机系统的 IP 地址。这可用于以后在虚拟机上挂载共享目录。 						

      ```none
      # ip addr
      [...]
      5: virbr0: [BROADCAST,MULTICAST,UP,LOWER_UP] mtu 1500 qdisc noqueue state UP group default qlen 1000
          link/ether 52:54:00:32:ff:a5 brd ff:ff:ff:ff:ff:ff
          inet 192.168.124.1/24 brd 192.168.124.255 scope global virbr0
             valid_lft forever preferred_lft forever
      [...]
      ```

      ​								请注意，相关的网络是您要共享文件的虚拟机用来连接到主机所使用的网络。通常，这是 `virbr0`。 						

2. ​						在 `/etc/exports` 文件中指定的虚拟机的客户机操作系统中挂载导出的文件系统。 				

   1. ​								创建您要用作共享文件系统挂载点的目录，例如 `/mnt/host-share` ： 						

      ```none
      # mkdir /mnt/host-share
      ```

   2. ​								在挂载点挂载主机导出的目录。这个示例在客户机的 `/mnt/host-share` 上挂载 `/usr/local/shared-files` 目录，它由 `192.168.124.1` 主机导出： 						

      ```none
      # mount 192.168.124.1:/usr/local/shared-files /mnt/host-share
      ```

**验证**

- ​						要验证挂载是否成功，请访问和浏览挂载点的共享目录： 				

  ```none
  # cd /mnt/host-share
  # ls
  shared-file1  shared-file2  shared-file3
  ```

## 19.5. 使用 Samba 在主机和 Windows 虚拟机间共享文件

​				为了在您的 RHEL 9 主机系统和连接到的 Windows 虚拟机间有效文件共享，请使用 [`virtiofs`](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/sharing-files-between-the-host-and-its-virtual-machines-using-virtiofs_sharing-files-between-the-host-and-its-virtual-machines) 功能。但是，如果 `virtiofs` 不适用于您或不适合您的用例，您可以改为准备一个可以被虚拟机访问的 Samba 服务器。 		

**先决条件**

- ​						`samba` 软件包安装到您的主机上。如果没有： 				

  ```none
  # dnf install samba
  ```

- ​						主机可以通过虚拟机的网络可见并可访问。通常情况下，如果虚拟机使用 *NAT* 和*网桥*类型虚拟网络进行连接，则会出现这种情况。然而，对于 *macvtap* 连接，您必须首先在主机上设置 *macvlan* 功能。要做到这一点： 				

  1. ​								在主机的 `/etc/systemd/network/` 目录中创建一个网络设备文件，如 `vm-macvlan.netdev`。 						

     ```none
     # vim /etc/systemd/network/vm-macvlan.netdev
     ```

  2. ​								编辑网络设备文件，使其包含以下内容。您可以将 `vm-macvlan` 替换为您为网络设备选择的名称。 						

     ```none
     [NetDev]
     Name=vm-macvlan
     Kind=macvlan
     
     [MACVLAN]
     Mode=bridge
     ```

  3. ​								为 macvlan 网络设备创建网络配置文件，如 `vm-macvlan.network`。 						

     ```none
     # vim /etc/systemd/network/vm-macvlan.network
     ```

  4. ​								编辑网络配置文件使其包含以下内容。您可以将 `vm-macvlan` 替换为您为网络设备选择的名称。 						

     ```none
     [Match]
     Name=_vm-macvlan_
     
     [Network]
     IPForward=yes
     Address=192.168.250.33/24
     Gateway=192.168.250.1
     DNS=192.168.250.1
     ```

  5. ​								为您的物理网络接口创建网络配置文件。例如，如果您的接口是 `enp4s0` ： 						

     ```none
     # vim /etc/systemd/network/enp4s0.network
     ```

     ​								如果您不确定要使用的接口，您可以使用主机上的 `ifconfig` 命令获取活跃网络接口列表。 						

  6. ​								编辑物理网络配置文件，使物理网络成为 macvlan 接口的一部分，在本例中为 *vm-macvlan*： 						

     ```none
     [Match]
     Name=enp4s0
     
     [Network]
     MACVLAN=vm-macvlan
     ```

  7. ​								重启您的主机。 						

**流程**

1. ​						在主机中，创建一个 Samba 共享并使其可以被外部系统访问。 				

   1. ​								为 Samba 添加防火墙权限。 						

      ```none
      # firewall-cmd --permanent --zone=public --add-service=samba
      success
      # firewall-cmd --reload
      success
      ```

   2. ​								编辑 `/etc/samba/smb.conf` 文件： 						

      1. ​										将以下内容添加到 `[global]` 部分： 								

         ```none
         map to guest = Bad User
         ```

      2. ​										在文件的末尾添加以下内容： 								

         ```none
         #=== Share Definitions ===
         [VM-share]
         path = /samba/VM-share
         browsable = yes
         guest ok = yes
         read only = no
         hosts allow = 192.168.122.0/24
         ```

         ​										请注意，`hosts allow` 行限制了共享仅可以被 VM 网络上的主机访问。如果您希望共享可以被任何人访问，请删除该行。 								

   3. ​								创建 `/samba/VM-share` 目录。 						

      ```none
      # mkdir -p /samba/VM-share
      ```

   4. ​								启用 Samba 服务。 						

      ```none
      # systemctl enable smb.service
      Created symlink /etc/systemd/system/multi-user.target.wants/smb.service → /usr/lib/systemd/system/smb.service.
      ```

   5. ​								重启 Samba 服务。 						

      ```none
      # systemctl restart smb.service
      ```

   6. ​								允许用户访问 `VM-share` 目录并进行修改。 						

      ```none
      # chmod -R 0755 /samba/VM-share/
      # chown -R nobody:nobody /samba/VM-share/
      ```

   7. ​								将 SELinux Samba 共享标签添加到 `/etc/samba/VM-share/` 						

      ```none
      # chcon -t samba_share_t /samba/VM-share/
      ```

2. ​						在 Windows 客户机操作系统中，将 Samba 共享作为网络位置附加。 				

   1. ​								打开文件 Explorer 并右键点击 "This PC"。 						

   2. ​								在上下文菜单中，单击 `Add a network location`。 						

      [![virt Win10 network loc1](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a3530412f71dc2a8baf8cf7a22af7b51/virt-Win10_network_loc1.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a3530412f71dc2a8baf8cf7a22af7b51/virt-Win10_network_loc1.png)

   3. ​								在打开的 *Add Network Location* 向导中，选择"选择自定义网络位置"并单击下一步。 						

   4. ​								在"Internet 或网络地址"字段中，键入 *host-IP*/VM-share，其中 *host-IP* 是主机的 IP 地址。通常，主机 IP 是虚拟机的默认网关。之后，单击 Next。 						

      ![virt Win10 network loc2](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/2e928a2f14d73c4ae855e80a78a42cc0/virt-Win10_network_loc2.png)

   5. ​								当向导询问您是否要重命名共享目录时，请保留默认名称。这样可确保在虚拟机和客户机间文件共享配置的一致性。点 Next。 						

   6. ​								如果访问网络位置成功，您现在可以单击 Finish 并打开共享目录。 						

# 第 20 章 安装和管理 Windows 虚拟机

​			要在 RHEL 9 主机上使用 Microsoft Windows 作为虚拟机(VM)中的客户机操作系统，红帽建议执行额外的步骤以确保这些虚拟机正确运行。 	

​			为此，以下部分提供有关在主机上安装和配置 Windows 虚拟机的信息，以及在这些虚拟机中安装和配置驱动程序。 	

## 20.1. 安装 Windows 虚拟机

​				您可以在 RHEL 9 主机上创建完全虚拟化的 Windows 机器，在虚拟机(VM)中启动图形 Windows 安装程序，并优化已安装的 Windows 虚拟机操作系统(OS)。 		

​				要创建虚拟机并安装 Windows 客户机操作系统，请使用 `virt-install` 命令或 RHEL 9 web 控制台。 		

**先决条件**

- ​						Windows OS 安装源，可以是以下之一，可在本地或网络上提供： 				

  - ​								安装介质的 ISO 镜像 						
  - ​								现有虚拟机安装的磁盘镜像 						

- ​						使用 KVM `virtio` 驱动程序的存储介质。 				

  ​						要创建这个介质，请参考 [第 20.2.1.2 节 “在主机中准备 virtio 驱动程序安装介质”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-drivers-on-a-host-machine_installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines)。 				

- ​						**可选：**如果要安装 Windows 11，您必须在主机机器上安装 vTPM 软件包。 				

  ```none
  # yum install swtpm libtpms
  ```

**流程**

1. ​						创建虚拟机。具体说明请查看 [第 3 章 *创建虚拟机*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_creating-virtual-machines_configuring-and-managing-virtualization)。 				

   - ​								如果使用 `virt-install` 工具创建虚拟机，请在该命令中添加以下选项： 						

     - ​										使用 KVM `virtio` 驱动程序的存储介质。例如： 								

       ```none
       --disk path=/usr/share/virtio-win/virtio-win.iso,device=cdrom
       ```

     - ​										要安装的 Windows 版本。例如：对于 Windows 11： 								

       ```none
       --os-variant win11
       ```

       ​										要获得可用 Windows 版本列表以及相应的选项，请使用以下命令： 								

       ```none
       # osinfo-query os
       ```

   - ​								如果使用 Web 控制台创建虚拟机，请在 **Create New Virtual Machine** 窗口的 **Operating System** 字段中指定您的 Windows 版本。 						

     ​								创建虚拟机并安装客户机操作系统后，使用 **Disks** 接口将带有 virtio 驱动程序的存储介质附加到虚拟机。具体说明请查看 [第 14.7.3 节 “使用 web 控制台将现有磁盘附加到虚拟机”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-existing-disks-to-virtual-machines-using-the-web-console_assembly_managing-virtual-machine-storage-disks-using-the-web-console)。 						

2. ​						在虚拟机中安装 Windows OS。 				

   ​						有关如何安装 Windows 操作系统的详情，请参考相关微软安装文档。 				

3. ​						在 Windows 客户机操作系统中配置 KVM `virtio` 驱动程序。详情请查看 [第 20.2.1 节 “为 Windows 虚拟机安装 KVM 半虚拟驱动程序”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines_optimizing-windows-virtual-machines-on-rhel)。 				

**其他资源**

- ​						[优化 Windows 虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-windows-virtual-machines-on-rhel_installing-and-managing-windows-virtual-machines-on-rhel) 				
- ​						[在 Windows 虚拟机中启用标准硬件安全性](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-standard-harware-security-on-windows-virtual-machines_installing-and-managing-windows-virtual-machines-on-rhel) 				
- ​						[在 Windows 虚拟机上启用增强的硬件安全性](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_enabling-enhanced-hardware-security-on-windows-virtual-machines_installing-and-managing-windows-virtual-machines-on-rhel) 				

## 20.2. 优化 Windows 虚拟机

​				当在 RHEL 9 中托管的虚拟机(VM)中使用 Microsoft Windows 作为客户机操作系统时，客户机的性能可能会受到负面影响。 		

​				因此,红帽建议您使用以下组合来优化 Windows 虚拟机： 		

- ​						使用半虚拟驱动程序。 				
- ​						启用 Hyper-V enlightenments。更多信息请参阅 [第 20.2.2 节 “启用 Hyper-Vlightenments”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-hyper-v-enlightenments_optimizing-windows-virtual-machines-on-rhel)。 				
- ​						配置 NetKVM 驱动程序参数。更多信息请参阅 [第 20.2.3 节 “配置 NetKVM 驱动程序参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-netkvm-driver-parameters_optimizing-windows-virtual-machines-on-rhel)。 				
- ​						优化或禁用 Windows 后台进程。更多信息请参阅 [第 20.2.5 节 “在 Windows 虚拟机中优化后台进程”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#optimizing-background-processes-on-windows-virtual-machines_optimizing-windows-virtual-machines-on-rhel)。 				

### 20.2.1. 为 Windows 虚拟机安装 KVM 半虚拟驱动程序

​					改进 Windows 虚拟机的性能的主要方法是，在客户机操作系统(OS)上为 Windows 安装 KVM 半虚拟化(`virtio`)驱动程序。 			

​					要做到这一点： 			

1. ​							准备主机机器上的安装介质。更多信息请参阅 [第 20.2.1.2 节 “在主机中准备 virtio 驱动程序安装介质”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-drivers-on-a-host-machine_installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines)。 					
2. ​							将安装介质附加到现有 Windows 虚拟机中，或者在[创建新 Windows 虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-windows-virtual-machines-on-rhel_installing-and-managing-windows-virtual-machines-on-rhel)时附加该介质。 					
3. ​							在 Windows 客户机操作系统中安装 `virtio` 驱动程序。如需更多信息，请参阅 [第 20.2.1.3 节 “在 Windows 客户端中安装 virtio 驱动程序”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-drivers-on-a-windows-guest_installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines)。 					

#### 20.2.1.1. Windows virtio 驱动程序如何工作

​						半虚拟化驱动程序通过降低 I/O 延迟并增加到几乎裸机级别的吞吐量来增强虚拟机的性能。红帽建议将半虚拟化驱动程序用于运行 I/O 密集型任务和应用程序的虚拟机。 				

​						`VirtIO` 驱动程序是 KVM 的半虚拟化设备驱动程序，适用于在 KVM 主机上运行的虚拟机。这些驱动程序由 `virtio-win` 软件包提供，其中包括用于以下目的的驱动程序： 				

- ​								块（存储）设备 						
- ​								网络接口控制器 						
- ​								视频控制器 						
- ​								内存 ballooning 设备 						
- ​								半虚拟串口设备 						
- ​								熵源设备 						
- ​								半虚拟 panic 设备 						
- ​								输入设备，如鼠标、键盘、平板 						
- ​								一组小型模拟设备 						

注意

​							有关模拟、`virtio` 和分配的设备的附加信息，请参考 [第 13 章 *管理虚拟设备*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-devices_configuring-and-managing-virtualization)。 					

​						使用 KVM virtio 驱动程序时，应该与物理系统类似以下 Microsoft Windows 版本： 				

- ​								Windows Server 版本：请参阅红帽知识库中的 [带有 KVM 的 Red Hat Enterprise Linux 认证的客户机操作系统](https://access.redhat.com/articles/973133)。 						
- ​								Windows Desktop（非服务器）版本： 						
  - ​										Windows 7（32 位和 64 位版本） 								
  - ​										Windows 8（32 位和 64 位版本） 								
  - ​										Windows 8.1（32 位和 64 位版本） 								
  - ​										Windows 10（32 位和 64 位版本） 								
  - ​										Windows 11（64 位） 								

#### 20.2.1.2. 在主机中准备 virtio 驱动程序安装介质

​						要在 Windows 虚拟机(VM)上安装 KVM virtio 驱动程序，您必须首先为主机机器上的 virtio 驱动程序准备安装介质。为此，请在主机机器上安装 `virtio-win` 软件包，并使用它提供的 `.iso` 文件作为虚拟机存储。 				

**先决条件**

- ​								确定在 RHEL 9 主机系统中启用了虚拟化。如需更多信息，请参阅 [第 2 章 *启用虚拟化*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#assembly_enabling-virtualization-in-rhel-9_configuring-and-managing-virtualization)。 						

**流程**

1. ​								下载驱动程序 						

   1. ​										浏览 [下载 Red Hat Enterprise Linux](https://access.redhat.com/downloads/content/479/ver=/rhel---8/8.1/x86_64/packages)。 								

   2. ​										选择与您的系统架构相关的`产品变体`。例如，对于 Intel 64 和 AMD64，请选择 **Red Hat Enterprise Linux for x86_64**。 								

   3. ​										选择主机系统的 `Version`。 								

   4. ​										在 `Packages` 选项卡中，搜索 **virtio-win**。 								

   5. ​										点 **virtio-win AppStream** 软件包旁边的 `Download Latest`。 								

      ​										`RPM` 文件下载。 								

2. ​								从下载目录中安装 `virtio-win` 软件包。例如： 						

   ```none
   # dnf install ~/Downloads/virtio-win-1.9.9-3.el8.noarch.rpm
   [...]
   Installed:
     virtio-win-1.9.9-3.el8.noarch
   ```

   ​								如果安装成功，则 `virtio-win` 驱动程序文件会在 `/usr/share/virtio-win/` 目录中准备。这包括 `ISO` 文件和包含驱动程序文件的 `drivers` 目录，每个体系结构和支持 Windows 版本对应一个。 						

   ```none
   # ls /usr/share/virtio-win/
   drivers/  guest-agent/  virtio-win-1.9.9.iso  virtio-win.iso
   ```

3. ​								将 `virtio-win.iso` 文件附加到 Windows 虚拟机。要做到这一点，请执行以下操作之一： 						

   - ​										在[创建新 Windows 虚拟机时](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-windows-virtual-machines-on-rhel_installing-and-managing-windows-virtual-machines-on-rhel)，使用该文件作为磁盘。 								

   - ​										将文件作为光盘添加到现有 Windows 虚拟机中。例如： 								

     ```none
     # virt-xml WindowsVM --add-device --disk virtio-win.iso,device=cdrom
     Domain 'WindowsVM' defined successfully.
     ```

**后续步骤**

- ​								当 `virtio-win.iso` 附加到 Windows 虚拟机时，您可以继续 [在 Windows 客户机操作系统上安装 virtio 驱动程序](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-drivers-on-a-windows-guest_installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines)。 						

#### 20.2.1.3. 在 Windows 客户端中安装 virtio 驱动程序

​						要在 Windows 客户机操作系统(OS)中安装 KVM `virtio` 驱动程序，您必须添加一个包含驱动程序的存储设备 - 在创建虚拟机(VM)或之后，并在 Windows 客户机操作系统中安装驱动程序。 				

​						本例演示了如何使用图形界面安装驱动程序。您还可以使用 [Microsoft Windows 安装程序(MSI)](https://docs.microsoft.com/en-us/windows/win32/msi/about-windows-installer) 命令行界面。 				

**先决条件**

- ​								虚拟机必须附加带有 KVM `virtio` 驱动程序的安装介质。有关准备该介质的步骤，请参考 [第 20.2.1.2 节 “在主机中准备 virtio 驱动程序安装介质”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-drivers-on-a-host-machine_installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines)。 						

**流程**

1. ​								在 Windows 客户机操作系统中，打开 `File Explorer` 应用程序。 						

2. ​								点 `这个 PC`。 						

3. ​								在 `Devices and drives` 窗格中，打开 `virtio-win`。 						

4. ​								根据虚拟机 vCPU 的架构，在介质中运行安装程序之一。 						

   - ​										如果使用 32 位 vCPU，请运行 `virtio-win-gt-x86` 安装程序。 								
   - ​										如果使用 64 位 vCPU，请运行 `virtio-win-gt-x64` 安装程序。 								

   [![显示 Windows File Explorer 的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a01276245b0a639e039aab9e2ac06fd6/virtio-win-installer-1.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/a01276245b0a639e039aab9e2ac06fd6/virtio-win-installer-1.png)

5. ​								在打开的 `Virtio-win-guest-tools` 设置向导中，按照显示的说明进行操作，直到您到达 `Custom Setup` 步骤。 						

   ![显示 Virtio-win-guest-tools 设置向导的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/57cc6401619b6875c72e99258eb62f53/virtio-win-installer-2.png)

6. ​								在 Custom Setup 窗口中，选择要安装的设备驱动程序。推荐的驱动程序集会被自动选择，驱动程序描述会在列表右侧显示。 						

7. ​								点下一步，然后点 Install。 						

8. ​								安装完成后，点完成。 						

9. ​								重启虚拟机以完成驱动程序安装。 						

**验证**

1. ​								在 `这个 PC` 中，打开系统磁盘。这通常为 `(C:)`。 						

2. ​								在 `程序文件` 目录中，打开 `Virtio-Win` 目录。 						

   ​								如果 `Virtio-Win` 目录存在并包含每个所选驱动程序的子目录，则安装可以成功。 						

   [![在 Windows File Explorer 中显示 Virtio-Win 目录的镜像。](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/40ac5340e01d87bfff583818d7706919/virtio-win-installer-3.png)](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-9-Configuring_and_managing_virtualization-zh-CN/images/40ac5340e01d87bfff583818d7706919/virtio-win-installer-3.png)

**后续步骤**

- ​								如果您安装 NetKVM 驱动程序，可能还需要[配置 Windows 客户机的网络参数](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#configuring-netkvm-driver-parameters_optimizing-windows-virtual-machines-on-rhel)。 						

### 20.2.2. 启用 Hyper-Vlightenments

​					hyper-Vlightenments 为 KVM 提供了一个模拟 Microsoft Hyper-V 管理程序的方法。这提高了 Windows 虚拟机的性能。 			

​					以下小节提供了有关支持的 Hyper-Vlightenments 以及如何启用它们的信息。 			

#### 20.2.2.1. 在 Windows 虚拟机上启用 Hyper-V 激活

​						Hyper-Vlightenments 在 RHEL 9 主机中运行的 Windows 虚拟机(VM)中提供更好的性能。有关如何启用它们的步骤，请查看以下操作。 				

**流程**

1. ​								使用 `virsh edit` 命令打开虚拟机的 XML 配置。例如： 						

   ```none
   # virsh edit windows-vm
   ```

2. ​								将以下 `<hyperv>` 子部分添加到 XML 的 `<features>` 部分： 						

   ```xml
   <features>
     [...]
     <hyperv>
       <relaxed state='on'/>
       <vapic state='on'/>
       <spinlocks state='on' retries='8191'/>
       <vpindex state='on'/>
       <runtime state='on' />
       <synic state='on'/>
       <stimer state='on'>
         <direct state='on'/>
       </stimer>
       <frequencies state='on'/>
       <reset state='on'/>
       <relaxed state='on'/>
       <time state='on'/>
       <tlbflush state='on'/>
       <reenlightenment state='on'/>
       <stimer_direct state='on'/>
       <ipi state='on'/>
       <crash state='on'/>
       <evmcs state='on'/>
     </hyperv>
     [...]
   </features>
   ```

   ​								如果 XML 已包含 `<hyperv>` 子部分，请按上面所示修改它。 						

3. ​								更改配置的 `clock` 部分，如下所示： 						

   ```xml
   <clock offset='localtime'>
     ...
     <timer name='hypervclock' present='yes'/>
   </clock>
   ```

4. ​								保存并退出 XML 配置。 						

5. ​								如果虚拟机正在运行，重启它。 						

**验证**

- ​								使用 `virsh dumpxml` 命令显示正在运行的虚拟机的 XML 配置。如果包括以下片段，则虚拟机上会启用 Hyper-Vlightenments。 						

  ```xml
  <hyperv>
    <relaxed state='on'/>
    <vapic state='on'/>
    <spinlocks state='on' retries='8191'/>
    <vpindex state='on'/>
    <runtime state='on' />
    <synic state='on'/>
    <stimer state='on'/>
    <frequencies state='on'/>
    <reset state='on'/>
    <relaxed state='on'/>
    <time state='on'/>
    <tlbflush state='on'/>
    <reenlightenment state='on'/>
    <stimer state='on'>
      <direct state='on'/>
    </stimer>
    <ipi state='on'/>
    <crash state='on'/>
    <evmcs state='on'/>
  </hyperv>
  
  <clock offset='localtime'>
    ...
    <timer name='hypervclock' present='yes'/>
  </clock>
  ```

#### 20.2.2.2. 可配置 Hyper-V enlightenments

​						您可以配置特定的 Hyper-V 功能来优化 Windows 虚拟机。下表提供了有关这些可配置 Hyper-V 功能及其值的信息。 				

**表 20.1. 可配置 Hyper-V 功能**

| Enlightenment          | 描述                                                         | 值                                                           |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| crash                  | 向虚拟机提供 MSR，可用于存储信息和日志的虚拟机（如果虚拟机崩溃）。QEMU 日志中提供的信息。 								 								 注意 										如果启用了 hv_crash，则不会创建 Windows 崩溃转储。 | on, off                                                      |
| evmcs                  | 在 L0(KVM)和 L1(Hyper-V)虚拟机监控程序之间实现半虚拟化协议，使得 L2 能够更快地退出管理程序。 								 								 注意 										这个功能只供 Intel 处理器使用。 | on, off                                                      |
| frequencies            | 启用 Hyper-V Specific Registers(MSRs)。                      | on, off                                                      |
| ipi                    | 启用半虚拟化处理器中断(IPI)支持。                            | on, off                                                      |
| no-nonarch-coresharing | 通知客户机操作系统，虚拟处理器永远不会共享物理内核，除非它们被报告为同级 SMT 线程。Windows 和 Hyper-V 客户机需要此信息来正确缓解与并发多线程(SMT)相关的 CPU 漏洞。 | on, off, auto                                                |
| reenlightenment        | 通知何时有时间戳计数器(TSC)频率更改，这只会在迁移过程中发生。它还允许客户机继续使用旧频率，直到它准备好切换到新频率。 | on, off                                                      |
| relaxed                | 禁用 Windows 完整性检查，当虚拟机在大量加载的主机上运行时通常会产生 BSOD。这和 Linux 内核选项 no_timer_check 类似，它会在 Linux 在 KVM 中运行时自动启用。 | on, off                                                      |
| runtime                | 设定运行客户机代码以及代表客户端代码的处理器时间。           | on, off                                                      |
| spinlock               | 供虚拟机操作系统用来通知 Hyper-V，调用虚拟处理器试图获取可能由同一分区内的另一个虚拟处理器持有的资源。 										 											供 Hyper-V 用于指明虚拟机的操作系统在表示对 Hyper-V 发生过过度的故障发生前，应尝试 spinlock 收购的次数。 | on, off                                                      |
| stimer                 | 为虚拟处理器启用合成计时器。请注意，某些 Windows 版本恢复到使用 HPET（当 HPET 不可用时甚至 RTC），当没有提供这个调整时，这可能会导致大量 CPU 消耗，即使虚拟 CPU 闲置也是如此。 | on, off                                                      |
| stimer-direct          | 当通过普通的中断提供过期事件时，启用合成计时器。             | on, off.                                                     |
| synic                  | 与 stimer 一起，激活 synthetic 计时器。Windows 8 以周期性模式使用此功能。 | on, off                                                      |
| time                   | 启用以下虚拟机可用的特定于 Hyper-V 的时钟源, 								 								  											MSR-based 82 Hyper-V 时钟源(HV_X64_MSR_TIME_REF_COUNT, 0x40000020) 										 											参考通过 MSR 启用的 TSC 83 页面(HV_X64_MSR_REFERENCE_TSC，0x40000021) | on, off                                                      |
| tlbflush               | 清除虚拟处理器的 TLB。                                       | on, off                                                      |
| vapic                  | 启用虚拟 APIC，它提供对高使用、内存映射的高级程序中断控制器(APIC)寄存器的加速 MSR 访问权限。 | on, off                                                      |
| vendor_id              | 设置 Hyper-V 厂商 id。                                       | on, off 										 											id 值 - 最多 12 个字符的字符串 |
| vpindex                | 启用虚拟处理器索引。                                         | on, off                                                      |

### 20.2.3. 配置 NetKVM 驱动程序参数

​					安装 NetKVM 驱动程序后，您可以将它配置为更好地适合您的环境。本节中列出的参数可以使用 Windows Device Manager(devmgmt.msc)配置。 			

重要

​						修改驱动程序的参数会导致 Windows 重新加载该驱动程序。这会中断现有的网络活动。 				

**先决条件**

- ​							NetKVM 驱动程序安装在虚拟机上。 					

  ​							更多信息请参阅 [第 20.2.1 节 “为 Windows 虚拟机安装 KVM 半虚拟驱动程序”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#installing-kvm-paravirtualized-drivers-for-rhel-virtual-machines_optimizing-windows-virtual-machines-on-rhel)。 					

**流程**

1. ​							打开 Windows Device Manager。 					

   ​							有关打开设备管理器的详情，请参考 Windows 文档。 					

2. ​							找到 **Red Hat VirtIO Ethernet Adapter**。 					

   1. ​									在 Device Manager 窗口中，点 Network adapters 旁边的 +。 							

   2. ​									在网络适配器列表中，双击 **Red Hat VirtIO Ethernet Adapter**。 							

      ​									该设备的 **Properties** 窗口将打开。 							

3. ​							查看设备参数。 					

   ​							在 **Properties** 窗口中点击 **Advanced** 选项卡。 					

4. ​							修改设备参数。 					

   1. ​									点击您要修改的参数。 							

      ​									此时会显示那个参数的选项。 							

   2. ​									根据需要修改选项。 							

      ​									有关 NetKVM 参数选项的详情，请参考 [第 20.2.4 节 “NetKVM 驱动程序参数”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#netkvm-driver-parameters_optimizing-windows-virtual-machines-on-rhel)。 							

   3. ​									点 OK 保存更改。 							

### 20.2.4. NetKVM 驱动程序参数

​					下表提供了可配置的 NetKVM 驱动程序日志记录参数。 			

**表 20.2. 日志参数**

| 参数           | 描述 2                                                       |
| -------------- | ------------------------------------------------------------ |
| Logging.Enable | 确定是否启用日志记录的布尔值。默认值为 Enabled。             |
| Logging.Level  | 定义日志级别的整数。当整数增加时，日志的详细程度也会增加。 							 							  										默认值为 0（仅错误）。 									 										1-2 添加配置信息。 									 										3-4 添加数据包流信息。 									 										5-6 添加中断以及 DPC 级别追踪信息。 									 							 注意 									高日志级别会减慢您的虚拟机速度。 |

​					下表提供了可配置的 NetKVM 驱动程序初始参数信息。 			

**表 20.3. 初始参数**

| 参数                    | 描述                                                         |
| ----------------------- | ------------------------------------------------------------ |
| 分配 MAC                | 为半虚拟 NIC 定义本地管理的 MAC 地址的字符串。默认不设置。   |
| Init.ConnectionRate(Mb) | 代表每秒（以 MB 为单位）的连接率的整数。Windows 2008 及之后的版本的默认值为 10G（每秒10,000MB）。 |
| Init.Do802.1PQ          | 启用 Priority/VLAN 标签填充和删除支持的布尔值。默认值为 Enabled。 |
| Init.MTUSize            | 定义最大传输单元（MTU）的整数。默认值为 1500。从 500 到 65500 的值都可以接受。 |
| Init.MaxTxBuffers       | 代表将被分配的 TX 环描述符数的整数。 							 							  								默认值为 1024。 							 							  								有效值为：16、32、64、128、256、512 和 1024. |
| Init.MaxRxBuffers       | 代表将要分配的 RX 环描述符数的整数。 							 							  								默认值为 256。 							 							  								有效值为：16、32、64、128、256、512 和 1024. |
| Offload.Tx.Checksum     | 指定 TX checksum 卸载模式。 							 							  								在 Red Hat Enterprise Linux 9 中，这个参数的有效值为： 							 							  								* All（默认），为 IPv4 和 IPv6 都启用 IP、TCP 和 UDP checksum offloading 							 							  								* TCP/UDP(v4,v6) ，为 IPv4 和 IPv6 都启用 TCP 和 UDP checksum offloading 							 							  								* TCP/UDP(v4)，只为 IPv4 启用 TCP 和 UDP checksum offloading 							 							  								* TCP(v4)，只为 IPv4 启用 TCP checksum |

### 20.2.5. 在 Windows 虚拟机中优化后台进程

​					要优化运行 Windows 操作系统的虚拟机的性能，您可以配置或禁用各种 Windows 进程。 			

警告

​						如果您更改配置，某些进程可能无法按预期工作。 				

**流程**

​						您可以通过执行以下任一组合来优化 Windows 虚拟机： 				

- ​							删除未使用的设备，如 USB 或 CD-ROM，并禁用端口。 					

- ​							禁用后台服务，如 SuperFetch 和 Windows Search。有关停止服务的详情，请参考[禁用系统服务](https://docs.microsoft.com/en-us/windows-server/security/windows-services/security-guidelines-for-disabling-system-services-in-windows-server)或 [Stop-Service](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/stop-service?view=powershell-7)。 					

- ​							禁用 `useplatformclock`。为此，请运行以下命令： 					

  ```none
  # bcdedit /set useplatformclock No
  ```

- ​							检查和禁用不必要的调度任务，如调度的磁盘清除。有关如何操作的更多信息，请参阅[禁用调度任务](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/disable-scheduledtask?view=win10-ps)。 					

- ​							确定磁盘没有加密。 					

- ​							减少服务器应用程序的周期性活动。您可以编辑对应的计时器。如需更多信息，请参阅[多媒体计时器](https://docs.microsoft.com/en-us/windows/win32/multimedia/multimedia-timers)。 					

- ​							关闭虚拟机上的 Server Manager 应用程序。 					

- ​							禁用 antivirus 软件。请注意，禁用 antivirus 可能会破坏虚拟机的安全。 					

- ​							禁用屏保。 					

- ​							在没有使用时，仍然将 Windows OS 保持在登录屏幕中。 					

## 20.3. 在 Windows 虚拟机中启用标准硬件安全性

​				要保护 Windows 虚拟机，您可以使用 Windows 设备的标准硬件功能启用基本级别的安全性。 		

**先决条件**

- ​						请确定您安装了最新的 WHQL 认证的 VirtIO 驱动程序。 				

- ​						确保虚拟机固件支持 UEFI 引导。 				

- ​						在主机机器上安装 `edk2-OVMF` 软件包。 				

  ```none
  # dnf install edk2-ovmf
  ```

- ​						在主机机器上安装 `vTPM` 软件包。 				

  ```none
  # dnf install swtpm libtpms
  ```

- ​						确保虚拟机使用 Q35 机器架构。 				

- ​						请确定您有 Windows 安装介质。 				

**流程**

1. ​						通过在虚拟机 XML 配置的 `<devices>` 部分添加以下参数来启用 TPM 2.0。 				

   ```xml
   <devices>
   [...]
     <tpm model='tpm-crb'>
       <backend type='emulator' version='2.0'/>
     </tpm>
   [...]
   </devices>
   ```

2. ​						在 UEFI 模式中安装 Windows。有关如何操作的更多信息，请参阅 [第 18.3 节 “创建 SecureBoot 虚拟机”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-a-secureboot-virtual-machine_securing-virtual-machines-in-rhel)。 				

3. ​						在 Windows 虚拟机上安装 VirtIO 驱动程序。有关如何操作的更多信息，请参阅在 Windows 客户端中安装 KVM 驱动程序。 				

4. ​						在 UEFI 中，启用安全引导。有关如何进行此操作的更多信息，请参阅 [安全引导](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/secure-boot-landing)。 				

**验证**

- ​						确定 Windows 机器中的**设备安全性**页面显示以下信息： 				

  ​						**Settings > Update & Security > Windows Security > Device Security** 				

  ```none
  Your device meets the requirements for standard hardware security.
  ```

## 20.4. 在 Windows 虚拟机上启用增强的硬件安全性

​				要进一步保护 Windows 虚拟机，您可以启用基于虚拟化的代码完整性保护，也称为 Hypervisor-Protected Code Integrity(HVCI)。 		

**先决条件**

- ​						确保启用了标准硬件安全性。如需更多信息，请参阅在 [Windows 虚拟机上启用标准硬件安全性](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-standard-harware-security-on-windows-virtual-machines_securing-virtual-machines-in-rhel)。 				

- ​						确保启用 KVM 嵌套功能。如需更多信息，请参阅[创建嵌套虚拟机](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-nested-virtual-machines_configuring-and-managing-virtualization)。 				

- ​						在 KVM 命令行上， 				

  - ​								指定 CPU 模型。 						

  - ​								启用虚拟机扩展(VMX)功能。 						

  - ​								启用 Hyper-V enlightenments。 						

    ```none
    # -cpu Skylake-Client-v3,hv_stimer,hv_synic,hv_relaxed,hv_reenlightenment,hv_spinlocks=0xfff,hv_vpindex,hv_vapic,hv_time,hv_frequencies,hv_runtime,+kvm_pv_unhalt,+vmx
    ```

**流程**

1. ​						在 Windows 虚拟机上，进入 **Core 隔离详情页面** ： 				

   ​						**Settings > Update & Security > Windows Security > Device Security > Core isolation details** 				

2. ​						切换开关以启用**内存完整性**。 				

3. ​						重启虚拟机。 				

注意

​					有关启用 HVCI 的其他方法，请查看相关的 Microsoft 文档。 			

**验证**

- ​						确定 Windows 虚拟机上的**设备安全性**页面显示以下信息： 				

  ​						**Settings > Update & Security > Windows Security > Device Security** 				

  ```none
  Your device meets the requirements for enhanced hardware security.
  ```

- ​						或者，在 Windows 虚拟机上检查系统信息： 				

  1. ​								在命令提示符中运行 `msinfo32.exe`。 						
  2. ​								检查 **Credential Guard, Hypervisor enforced Code Integrity** 是否在 **Virtualization-based security Services Running** 下列出。 						

## 20.5. 后续步骤

- ​						要使用用于访问、编辑和创建 Windows 虚拟机的虚拟机磁盘或其他磁盘镜像的工具，请在主机机器上安装 `libguestfs-tools` 和 `libguestfs-winsupport` 软件包： 				

  ```none
  $ sudo dnf install libguestfs-tools libguestfs-winsupport
  ```

- ​						要使用用于访问、编辑和创建 Windows 虚拟机的虚拟机磁盘或其他磁盘镜像的工具，请在主机机器上安装 `guestfs-tools` 和 `guestfs-winsupport` 软件包： 				

  ```none
  $ sudo dnf install guestfs-tools guestfs-winsupport
  ```

- ​						要在 RHEL 9 主机及其 Windows 虚拟机间共享文件，您可以使用 [virtiofs](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-files-between-the-host-and-its-virtual-machines-using-virtiofs_sharing-files-between-the-host-and-its-virtual-machines) 或者 [Samba](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#sharing-files-between-the-host-and-windows-virtual-machines_sharing-files-between-the-host-and-its-virtual-machines)。 				

# 第 21 章 诊断虚拟机问题

​			在使用虚拟机时，您可能会遇到与不同严重级别相关的问题。有些问题可能会快速轻松地修复，而对于其他来说，您可能必须捕获与虚拟机相关的数据和日志来报告或诊断问题。 	

​			以下小节提供有关生成日志和诊断一些常见虚拟机问题的详细信息，以及报告这些问题的信息。 	

## 21.1. 生成 libvirt 调试日志

​				要诊断虚拟机(VM)问题，生成和查看 libvirt 调试日志会很有帮助。当要求支持解决虚拟机相关问题时，附加调试日志也很有用。 		

​				以下小节解释了 [什么是调试日志](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#understanding-virtual-machine-debug-logs_generating-virtual-machine-debug-logs)，如何 [将其设置为持久的](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-persistent-settings-for-virtual-machine-debug-logs_generating-virtual-machine-debug-logs)，[在运行时启用它们](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-virtual-machine-debug-logs-during-runtime_generating-virtual-machine-debug-logs)，并在报告问题时[附加它们](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-virtual-machine-debug-logs_generating-virtual-machine-debug-logs)。 		

### 21.1.1. 了解 libvirt 调试日志

​					debug 日志是文本文件，其中包含虚拟机(VM)运行时发生的事件的数据。日志提供有关基本的服务器端功能的信息，如主机库和 libvirt 守护进程。日志文件还包含所有正在运行的虚拟机的标准输出(`stderr`)。 			

​					默认不启用 debug 日志记录，且必须在 libvirt 启动时启用。您可以为单个会话或[永久启用](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-persistent-settings-for-virtual-machine-debug-logs_generating-virtual-machine-debug-logs)日志记录。您还可以通过 [修改守护进程运行时设置](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#enabling-virtual-machine-debug-logs-during-runtime_generating-virtual-machine-debug-logs)，在 libvirt 守护进程会话已在运行时启用日志。 			

​					在请求对虚拟机问题的支持时，[附加 libvirt 调试日志](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#attaching-virtual-machine-debug-logs_generating-virtual-machine-debug-logs)也很有用。 			

### 21.1.2. 为 libvirt 调试日志启用持久性设置

​					您可以将 libvirt debug 日志记录配置为在 libvirt 启动时自动启用。默认情况下，`virtqemud` 是 RHEL 9 中的主要 libvirt 守护进程。要在 libvirt 配置中进行持久更改，您必须编辑位于 `/etc/libvirt` 目录中的 `virtqemud.conf` 文件。 			

注意

​						在某些情况下，例如，当您从 RHEL 8 升级时，`libvirtd` 可能仍为已启用的 libvirt 守护进程。在这种情况下，您必须编辑 `libvirtd.conf` 文件。 				

**流程**

1. ​							在编辑器中打开 `virtqemud.conf` 文件。 					

2. ​							根据您的要求替换或设置过滤器。 					

   **表 21.1. 调试过滤器值**

   | **1** | 记录 libvirt 生成的所有消息。        |
   | ----- | ------------------------------------ |
   | **2** | 记录所有非调试的信息。               |
   | **3** | 记录所有警告和错误消息。这是默认值。 |
   | **4** | 仅记录错误消息。                     |

   **例 21.1. 日志过滤器的守护进程设置示例**

   ​								以下设置： 						

   - ​										记录来自 `remote`、`util.json` 和 `rpc` 层的所有错误和警告信息 								
   - ​										仅记录来自 `event` 层的错误消息。 								
   - ​										将过滤的日志保存到 `/var/log/libvirt/libvirt.log` 								

   ```none
   log_filters="3:remote 4:event 3:util.json 3:rpc"
   log_outputs="1:file:/var/log/libvirt/libvirt.log"
   ```

3. ​							保存并退出。 					

4. ​							重启 libvirt 守护进程。 					

   ```none
   $ systemctl restart virtqemud.service
   ```

### 21.1.3. 在运行时启用 libvirt 调试日志

​					您可以修改 libvirt 守护进程的运行时设置，以启用调试日志并将其保存到输出文件中。 			

​					这在无法重启 libvirt 守护进程时非常有用，因为重启解决了这个问题，或者因为有另一个进程（如迁移或备份）同时运行。如果您要在不编辑配置文件或重启守护进程的情况下尝试命令，修改运行时设置也很有用。 			

**先决条件**

- ​							确保已安装了 `libvirt-admin` 软件包。 					

**流程**

1. ​							**可选：**备份活跃的日志过滤器集合。 					

   ```none
   # virt-admin -c virtqemud:///system daemon-log-filters >> virt-filters-backup
   ```

   注意

   ​								建议您备份活跃的过滤器集合，以便在生成日志后恢复它们。如果您没有恢复过滤器，信息将继续记录可能会影响系统性能。 						

2. ​							使用 `virt-admin` 实用程序根据您的要求启用调试和设置过滤器。 					

   **表 21.2. 调试过滤器值**

   | **1** | 记录 libvirt 生成的所有消息。        |
   | ----- | ------------------------------------ |
   | **2** | 记录所有非调试的信息。               |
   | **3** | 记录所有警告和错误消息。这是默认值。 |
   | **4** | 仅记录错误消息。                     |

   **例 21.2. 日志记录过滤器的 virt-admin 设置示例**

   ​								以下命令： 						

   - ​										记录来自 `remote`、`util.json` 和 `rpc` 层的所有错误和警告信息 								
   - ​										仅记录来自 `event` 层的错误消息。 								

   ```none
   # virt-admin -c virtqemud:///system daemon-log-filters "3:remote 4:event 3:util.json 3:rpc"
   ```

3. ​							使用 `virt-admin` 实用程序将日志保存到特定文件或目录中。 					

   ​							例如，以下命令将日志输出保存到 `/var/log/libvirt/` 目录中的 `libvirt.log` 文件中。 					

   ```none
   # virt-admin -c virtqemud:///system daemon-log-outputs "1:file:/var/log/libvirt/libvirt.log"
   ```

4. ​							**可选：**您还可以删除过滤器来生成包含所有与虚拟机相关的信息的日志文件。但不建议您这样做，因为这个文件可能包含由 libvirt 模块生成的大量冗余信息。 					

   - ​									使用 `virt-admin` 实用程序指定一组空的过滤器。 							

     ```none
     # virt-admin -c virtqemud:///system daemon-log-filters
       Logging filters:
     ```

5. ​							**可选：**使用备份文件将过滤器恢复到其原始状态。
   使用保存的值执行第二步，以恢复过滤器。 					

### 21.1.4. 附加 libvirt debug 日志来支持请求

​					您可能需要请求额外的支持来诊断和解决虚拟机(VM)问题。强烈建议您将调试日志附加到支持请求，以确保支持团队能够访问所需的全部信息，以快速解决问题。 			

**流程**

- ​							要报告问题并请求支持，[创建一个支持问题单](https://access.redhat.com/support/cases/#/case/new?intcmp=hp|a|a3|case&)。 					

- ​							根据遇到的问题，将以下日志与您的报告一起附加： 					

  - ​									对于 libvirt 服务的问题，请从主机附加 `/var/log/libvirt/libvirt.log` 文件。 							

  - ​									对于特定虚拟机的问题，请附加对应的日志文件。 							

    ​									例如，对于 *testguest1* 虚拟机，附加 `testguest1.log` 文件，该文件可在 `/var/log/libvirt/qemu/testguest1.log` 中找到。 							

**其他资源**

- ​							[如何为红帽支持提供日志文件？](https://access.redhat.com/solutions/2112) 					

## 21.2. 转储虚拟机内核

​				要分析虚拟机(VM)崩溃或出现故障的原因，您可以将虚拟机内核转储到磁盘上的文件，以便稍后分析和诊断。 		

​				这部分提供了[内核转储的简介](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#how-virtual-machine-core-dumping-works_dumping-a-virtual-machine-core)，并解释了如何[将虚拟机内核转储](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-a-virtual-machine-core-dump-file_dumping-a-virtual-machine-core)到特定文件。 		

### 21.2.1. 虚拟机内核转储的工作原理

​					虚拟机(VM)需要多个运行的进程来准确高效地工作。在某些情况下，运行的虚拟机在您在使用时可能会意外终止或出现故障。重启虚拟机可能会导致数据重置或丢失，从而很难诊断导致虚拟机崩溃的确切问题。 			

​					在这种情况下，您可以在重启虚拟机前使用 `virsh dump` 实用程序（或 *dump*）将虚拟机的核心保存到文件中。核心转储文件包含虚拟机的原始物理内存镜像，其中包含有关虚拟机的详细信息。这些信息可用于手动诊断虚拟机问题，也可以使用 `crash` 实用程序等工具进行诊断。 			

**其他资源**

- ​							`crash` man page 					
- ​							[`crash` Github 仓库](https://github.com/crash-utility/crash) 					

### 21.2.2. 创建虚拟机内核转储文件

​					虚拟机(VM)内核转储在任何给定时间包含有关虚拟机状态的详细信息。这些信息类似于虚拟机快照，这有助于在 VM 出现故障或突然关闭时检测到问题。 			

**先决条件**

- ​							请确定您有足够的磁盘空间保存该文件。请注意，虚拟机消耗的空间取决于分配给虚拟机的 RAM 量。 					

**流程**

- ​							使用 `virsh dump` 程序。 					

  ​							例如，以下命令将 `lander1` 虚拟机的内核、其内存和 CPU 通用注册文件转储到 `/core/file` 目录中的 `gargantua.file`。 					

  ```none
  # virsh dump lander1 /core/file/gargantua.file --memory-only
  Domain 'lander1' dumped to /core/file/gargantua.file
  ```

重要

​						`crash` 工具不再支持 virsh dump 命令的默认文件格式。要使用 `crash` 分析内核转储文件，您必须使用 `--memory-only` 选项创建该文件。 				

​						另外，在创建内核转储文件时，必须使用 `--memory-only` 选项附加到红帽支持问题单中。 				

**故障排除**

​						如果 `virsh dump` 命令失败并显示 `System is deadlocked on memory` 错误，请确保为内核转储文件分配足够的内存。要做到这一点，请使用以下 `crashkernel` 选项值。或者，请勿使用 `crashkernel`，它会自动分配内核转储内存。 				

```none
crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M
```

**其他资源**

- ​							`virsh dump --help` 命令 					
- ​							`virsh` man page 					
- ​							[创建支持问题单](https://access.redhat.com/support/cases/#/case/new?intcmp=hp|a|a3|case&) 					

## 21.3. 回溯虚拟机进程

​				当与虚拟机(VM)出现故障相关的进程时，您可以使用 `gstack` 命令和进程标识符(PID)生成故障功能进程的执行堆栈跟踪。如果该进程是线程组的一部分，那么也会跟踪所有线程。 		

**先决条件**

- ​						确定安装了 `GDB` 软件包。 				

  ​						有关安装 `GDB` 和可用组件的详情，请参阅[安装 GNU Debugger](https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/10/html/user_guide/chap-gdb#sect-GDB-Install)。 				

- ​						请确定您知道要追踪进程的 PID。 				

  ​						您可以使用 `pgrep` 命令（后跟进程的名称）找到 PID。例如： 				

  ```none
  # pgrep libvirt
  22014
  22025
  ```

**流程**

- ​						使用 `gstack` 实用程序以及您想要备份的进程的 PID。 				

  ​						例如：以下命令追踪 PID 为 22014 的 libvirt 进程。 				

  ```none
  # gstack 22014
  Thread 3 (Thread 0x7f33edaf7700 (LWP 22017)):
  #0  0x00007f33f81aef21 in poll () from /lib64/libc.so.6
  #1  0x00007f33f89059b6 in g_main_context_iterate.isra () from /lib64/libglib-2.0.so.0
  #2  0x00007f33f8905d72 in g_main_loop_run () from /lib64/libglib-2.0.so.0
  ...
  ```

**其他资源**

- ​						`gstack` man page 				
- ​						[GNU Debugger(GDB)](https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/10/html/user_guide/chap-gdb) 				

**用于报告虚拟机问题并提供日志的其他资源**

​					要请求额外的帮助和支持，您可以： 			

- ​						使用 **redhat-support-tool** 命令行选项、Red Hat Portal UI 或使用 FTP 的不同方法，引发服务请求。 				

  - ​								要报告问题并请求支持,请参阅创建[支持问题单](https://access.redhat.com/support/cases/#/case/new?intcmp=hp|a|a3|case&)。 						

- ​						提交服务请求时上传 SOS 报告以及日志文件。 				

  ​						这样可保证红帽支持工程师具有参考所需的全部诊断信息。 				

  - ​								有关 SOS 报告的更多信息，请参阅[什么是 SOS 报告以及如何在 Red Hat Enterprise Linux 中创建？](https://access.redhat.com/solutions/3592#command) 						
  - ​								有关附加日志文件的详情，请参考[如何为红帽支持提供文件？](https://access.redhat.com/solutions/2112) 						

# 第 22 章 RHEL 9 虚拟化的功能支持和限制

​			本文档提供有关 Red Hat Enterprise Linux 9(RHEL 9)虚拟化的功能支持和限制的信息。 	

## 22.1. RHEL 虚拟化支持如何工作

​				一组支持限制适用于 Red Hat Enterprise Linux 9(RHEL 9)的虚拟化。这意味着，当您使用某些功能，或在 RHEL 9 中使用虚拟机时超过特定分配的资源时，红帽将不支持这些客户机，除非您有特定的订阅计划。 		

​				红帽已测试并认证了 [第 22.2 节 “RHEL 9 虚拟化中推荐的功能”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 中列出的功能，以便与 RHEL 9 系统中的 KVM 管理程序一起工作。因此，它们被完全支持，推荐在 RHEL 9 中的虚拟化中使用它们。 		

​				[第 22.3 节 “RHEL 9 虚拟化不支持的功能”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#unsupported-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 中列出的功能可以正常工作，但不被支持，且不推荐在 RHEL 9 中使用。因此，红帽强烈建议您在 RHEL 9 中使用 KVM 中的这些功能。 		

​				[第 22.4 节 “RHEL 9 虚拟化中的资源分配限制”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#resource-allocation-limits-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 列出 RHEL 9 中 KVM 客户机上支持的最大特定资源量。红帽不支持超过这些限制的客户端。 		

​				此外，除非另有说明，RHEL 9 虚拟化文档使用的所有功能和解决方案均受支持。然而，其中有些还没有进行充分测试，因此可能无法完全优化。 		

重要

​					许多这些限制不适用于红帽提供的其他虚拟化解决方案，如 OpenShift Virtualization 或 Red Hat OpenStack Platform(RHOSP)。 			

## 22.2. RHEL 9 虚拟化中推荐的功能

​				对于 Red Hat Enterprise Linux 9(RHEL 9)中包含的 KVM 管理程序，建议使用以下功能： 		

**主机系统构架**

​					只有在以下主机构架中才支持带有 KVM 的 RHEL 9： 			

- ​						AMD64 和 Intel 64 				
- ​						IBM Z - IBM z13 系统及更新版本 				

​				任何其它硬件架构都不支持将 RHEL 9 用作 KVM 虚拟化主机，红帽不建议这样做。值得注意的是，这包括 64 位 ARM 架构(ARM 64)，它仅作为技术预览提供。 		

**客户机操作系统**

​					红帽支持使用以下操作系统(OS)的 KVM 虚拟机： 			

- ​						Red Hat Enterprise Linux 7 及更新的版本 				
- ​						Microsoft Windows 10 及更新的版本 				
- ​						Microsoft Windows Server 2016 及更新的版本 				

​				但请注意，默认情况下您的客户机操作系统不使用与您的主机相同的订阅。因此，您必须激活单独的许可或者订阅方可使客户机操作系统正常工作。 		

**机器类型**

​					要确保您的虚拟机与您的主机架构兼容并且客户机操作系统以最佳方式运行，虚拟机必须使用适当的机器类型。 			

​				[使用命令行创建虚拟机](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#creating-virtual-machines-using-the-command-line-interface_assembly_creating-virtual-machines)时，`virt-install` 实用程序提供多种设置机器类型的方法。 		

- ​						当您使用 `--os-variant` 选项时，`virt-install` 会自动选择主机 CPU 推荐的机器类型，并由客户端操作系统支持。 				
- ​						如果不使用 `--os-variant` 或需要不同的机器类型，请使用 `--machine` 选项明确指定机器类型。 				
- ​						如果您指定一个不支持或与主机不兼容的 `--machine` 值，`virt-install` 会失败并显示出错信息。 				

​				在支持的构架中为 KVM 虚拟机提供推荐的机器类型，以及 `--machine` 选项的对应值，如下所示。*Y* 代表 RHEL 9 的最新次版本。 		

- ​						在 **Intel 64 and AMD64** (x86_64): `pc-q35-rhel9.*Y*.0` → `--machine=q35` 				
- ​						在 **IBM Z** (s390x): `s390-ccw-virtio-rhel9.*Y*.0` → `--machine=s390-ccw-virtio` 				

​				获取现有虚拟机的机器类型： 		

```none
# virsh dumpxml VM-name | grep machine=
```

​				查看主机上支持的机器类型的完整列表： 		

```none
# /usr/libexec/qemu-kvm -M help
```

**其他资源**

- ​						[RHEL 9 虚拟化不支持的功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#unsupported-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 				
- ​						[RHEL 9 虚拟化中的资源分配限制](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#resource-allocation-limits-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 				

## 22.3. RHEL 9 虚拟化不支持的功能

​				Red Hat Enterprise Linux 9(RHEL 9)包括的 KVM 管理程序不支持以下功能： 		

重要

​					这些限制可能不适用于红帽提供的其他虚拟化解决方案，如 OpenShift Virtualization 或 Red Hat OpenStack Platform(RHOSP)。 			

​					其他虚拟化解决方案支持的功能如下： 			

**主机系统构架**

​					任何没有在 [第 22.2 节 “RHEL 9 虚拟化中推荐的功能”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 中列出的主机构架中不支持带有 KVM 的 RHEL 9。 			

​				值得注意的是，64 位 ARM 架构(ARM 64)只作为 RHEL 9 中 KVM 虚拟化的技术预览提供，因此红帽不建议在生产环境中使用。 		

**客户机操作系统**

​					不支持在 RHEL 9 主机上使用以下客户机操作系统(OS)的 KVM 虚拟机： 			

- ​						Microsoft Windows 8.1 及更早版本 				
- ​						Microsoft Windows Server 2012 及更早版本 				
- ​						macOS 				
- ​						用于 x86 系统的 Solaris 				
- ​						2009 年之前发布的所有操作系统 				

​				有关 RHEL 主机上支持的客户机操作系统列表，请参阅[使用 KVM 的 Red Hat Enterprise Linux 认证的客户机操作系统](https://access.redhat.com/articles/973133)。 		

​				其他解决方案： 		

- ​						如需红帽提供的其他虚拟化解决方案支持客户机操作系统的列表，请参见 [Red Hat OpenStack Platform、Red Hat Virtualization 和 OpenShift Virtualization 中的经认证的客户机操作系统](https://access.redhat.com/articles/973163)。 				

**在容器中创建虚拟机**

​					红帽不支持在任意类型的容器中创建 KVM 虚拟机，其中包括 RHEL 9 管理程序的元素（如 `QEMU` 模拟器或 `libvirt` 软件包）。 			

​				其他解决方案： 		

- ​						要在容器中创建虚拟机，红帽建议使用 [OpenShift Virtualization](https://docs.openshift.com/container-platform/4.5/virt/about-virt.html) 产品。 				

**未记录的 virsh 命令和选项**

​					红帽文档中未明确推荐的任何 `virsh` 命令和选项都无法正常工作，红帽不建议在生产环境中使用它们。 			

**QEMU 命令行**

​					QEMU 是 RHEL 9 中虚拟化架构的基本组件，但难以手动管理，而且不正确的 QEMU 配置可能会导致安全漏洞。因此，红帽不支持使用 `qemu-*` 命令行工具，如 `qemu-kvm`。 			

​				反之，使用 `virsh`、`virt-install` 和 `virt-xml` 等 *libvirt* 实用程序，根据最佳实践来编排 QEMU。 		

**vCPU 热拔**

​					RHEL 9 不支持从正在运行的虚拟机中移除虚拟 CPU(vCPU)。 			

**内存热拔**

​					RHEL 9 不支持删除附加到正在运行的虚拟机的内存设备（也称为内存热拔）。 			

**QEMU 端的 I/O 节流**

​					RHEL 9 不支持使用 `virsh blkdeviotune` 实用程序为虚拟磁盘上的操作（也称为 QEMU 端 I/O 节流）配置最大输入和输出级别。 			

​				要在 RHEL 9 中设置 I/O 节流，请使用 `virsh blkiotune`。这也被称为 libvirt-side I/O 节流。具体说明请查看 [第 17.5.2 节 “虚拟机中的磁盘 I/O 节流”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#disk-i-o-throttling-in-virtual-machines_optimizing-virtual-machine-i-o-performance)。 		

​				其他解决方案： 		

- ​						RHOSP 还支持 QEMU 边的 I/O 节流。详情请参阅 [RHOSP Storage 指南中](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html/storage_guide/index)的[设置资源限值](https://access.redhat.com/solutions/875363) 和**使用服务质量规格** 部分。 				
- ​						另外，OpenShift Virtualizaton 还支持 QEMU 端的 I/O 节流。 				

**存储动态迁移**

​					RHEL 9 不支持在主机间迁移正在运行的虚拟机的磁盘镜像。 			

​				其他解决方案： 		

- ​						RHOSP 还支持存储实时迁移，但有一些限制。详情请参阅[迁移卷](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html/storage_guide/ch-cinder#section-volumes-advanced-migrate)。 				
- ​						在使用 OpenShift Virtualization 时，也可以实时迁移虚拟机存储。有关更多规范，请参阅[虚拟机实时迁移](https://docs.openshift.com/container-platform/4.9/virt/live_migration/virt-live-migration.html)。 				

**实时快照**

​					RHEL 9 不支持创建或载入正在运行的虚拟机的快照（也称为实时快照）。 			

​				另外请注意，在 RHEL 9 中弃用了非实时虚拟机快照。因此，虽然可以为关闭的虚拟机创建或载入快照，但红帽建议不要使用它。 		

​				其他解决方案： 		

- ​						RHOSP 还支持实时快照。详情请参阅[把虚拟机导入到 overcloud](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.0/html-single/director_installation_and_usage/index#importing-virtual-machines-into-the-overcloud) 部分。 				

**vhost 数据路径加速**

​					在 RHEL 9 主机上，可以为 virtio 设备配置 vHost Data Path Acceleration(vDPA)，但红帽目前不支持此功能，并且强烈建议在生产环境中使用它。 			

**vhost-user**

​					RHEL 9 不支持实现用户空间 vHost 接口。 			

​				其他解决方案： 		

- ​						RHOSP 支持 `vhost-user`，但只适用于 `virtio-net` 接口。详情请查看 [virtio-net 实现](https://access.redhat.com/solutions/3394851)和 [vhost 用户端口](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/10/html/network_functions_virtualization_planning_guide/ch-vhost-user-ports)。 				
- ​						OpenShift Virtualization 还支持 `vhost-user`。 				

**S3 和 S4 系统电源状态**

​					不支持将虚拟机挂起到 **Suspend to RAM** (S3)或 **Suspend to disk** (S4)系统电源状态。请注意，这些功能默认为禁用，启用这些功能将使您的虚拟机不受红帽支持。 			

​				请注意，S3 和 S4 状态目前还不支持红帽提供的其它虚拟化解决方案。 		

**多路径 vDisk 中的 s3-PR**

​					RHEL 9 不支持多路径 vDisk 上的 SCSI3 持久保留(S3-PR)。因此，RHEL 9 不支持 Windows 集群。 			

**virtio-crypto**

​					*virtio-crypto* 设备的驱动程序在 RHEL 9.0 内核中可用，因此在某些情况下可在 KVM 管理程序中启用该设备。但是，不支持在 RHEL 9 中使用 *virtio-crypto* 设备，因此不建议使用它。 			

​				请注意，红帽提供的其他虚拟化解决方案还不支持 *virtio-crypto* 设备。 		

**增量实时备份**

​					RHEL 9 不支持配置仅保存自上次备份（也称为增量实时备份）以来虚拟机更改的虚拟机备份，红帽强烈不建议使用它。 			

**net_failover**

​					RHEL 9 不支持使用 `net_failover` 驱动程序设置自动网络设备故障转移机制。 			

​				请注意，红帽提供的其他虚拟化解决方案目前还不支持 `net_failover`。 		

**多 FD 迁移**

​					RHEL 9 不支持使用多描述符(FD)迁移虚拟机（也称为多FD 迁移）。 			

​				请注意，红帽提供的其他虚拟化解决方案目前还不支持多FD 迁移。 		

**NVMe 设备**

​					不支持将 Non-volatile Memory express(NVMe)设备附加到 RHEL 9 中托管的虚拟机。 			

​				请注意，红帽目前还不支持将 `NVMe` 设备附加到虚拟机。 		

**TCG**

​					QEMU 和 libvirt 包括使用 QEMU Tiny Code Generator(TCG)的动态转换模式。这个模式不需要硬件虚拟化支持。但是，红帽不支持 TCG。 			

​				通过检查其 XML 配置可识别基于 TCG 的客户机，例如使用 `virsh dumpxml` 命令。 		

- ​						TCG 客户端的配置文件包括以下行： 				

  ```xml
  <domain type='qemu'>
  ```

- ​						KVM 客户端的配置文件包含以下行： 				

  ```xml
  <domain type='kvm'>
  ```

**其他资源**

- ​						[RHEL 9 虚拟化中推荐的功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#recommended-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 				
- ​						[RHEL 9 虚拟化中的资源分配限制](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#resource-allocation-limits-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 				

## 22.4. RHEL 9 虚拟化中的资源分配限制

​				以下限制适用于可分配给 Red Hat Enterprise Linux 9(RHEL 9)主机上的单个 KVM 虚拟机(VM)的虚拟化资源。 		

重要

​					许多这些限制不适用于红帽提供的其他虚拟化解决方案，如 OpenShift Virtualization 或 Red Hat OpenStack Platform(RHOSP)。 			

**每个虚拟机的最大 vCPU**

​					RHEL 9 支持最多 **384** 个 vCPU 到单个虚拟机。 			

**每个虚拟机的 PCI 设备**

​					RHEL 9 每个虚拟机总线支持 **32** 个 PCI 设备插槽，以及每个设备插槽的 **8** 个 PCI 功能。当虚拟机中启用了多功能且没有使用 PCI 桥接时，每个总线最多可以提供 256 个 PCI 功能。 			

​				每个 PCI 网桥都添加了一个新的总线，可能会启用其它 256 设备地址。但是，对于一些总线，用户不能使用所有 256 个设备地址，例如： root 总线有几个内置设备占用的插槽。 		

**虚拟 IDE 设备**

​					KVM 限制为每个虚拟机最多 **4** 个虚拟化 IDE 设备。 			

## 22.5. IBM Z 上的虚拟化与 AMD64 和 Intel 64 有什么不同

​				IBM Z 系统上的 RHEL 9 中的 KVM 虚拟化与 AMD64 和 Intel 64 系统的 KVM 不同，如下所示： 		

- PCI 和 USB 设备

  ​							IBM Z 不支持虚拟 PCI 和 USB 设备。这也意味着 `virtio-***-pci` 设备不受支持，应使用 `virtio-***-ccw` 设备。例如，使用 `virtio-net-ccw` 而不是 `virtio-net-pci`。 					 						请注意，支持直接附加 PCI 设备（也称 PCI 透传）。 					

- 支持的客户端操作系统

  ​							如果红帽只使用 RHEL 7、8 或 9 作为客户机操作系统，红帽只支持在 IBM Z 上托管的虚拟机。 					

- 设备引导顺序

  ​							IBM Z 不支持 `<boot dev='*device*'>` XML 配置元素。要定义设备引导顺序，使用 XML 的 `<boot order='*number*'>` element in the `<devices>` 元素。例如： 					`<disk type='file' device='disk'>  <driver name='qemu' type='qcow2'/>  <source file='/path/to/qcow2'/>  <target dev='vda' bus='virtio'/>  <address type='ccw' cssid='0xfe' ssid='0x0' devno='0x0000'/>  <boot order='2'> </disk>`注意 							在 AMD64 和 Intel 64 主机上也首选使用 `<boot order='*number*'>` 进行引导顺序管理。 						

- 内存热插拔

  ​							在 IBM Z 上无法将内存添加到正在运行的虚拟机。请注意，在 IBM Z 上，以及 AMD64 和 Intel64 上，从正在运行的虚拟机（*内存热插拔*）中不可能删除内存。 					

- NUMA 拓扑

  ​							IBM Z 上的 `libvirt` 不支持 CPU 的非统一内存访问(NUMA)拓扑。因此，在这些系统中无法使用 NUMA 调整 vCPU 性能。 					

- vfio-ap

  ​							IBM Z 主机上的虚拟机可以使用 *vfio-ap* 加密设备透传，其它架构都不支持它。 					

- SMBIOOS

  ​							IBM Z 不提供 SMBIOS 配置。 					

- watchdog 设备

  ​							如果在 IBM Z 主机上使用 VM 中的 watchdog 设备，请使用 `diag288` 模型。例如： 					`<devices>  <watchdog model='diag288' action='poweroff'/> </devices>`

- kvm-clock

  ​							`kvm-clock` 服务特定于 AMD64 和 Intel 64 系统，且不必为 IBM Z 上的虚拟机时间管理配置。 					

- v2v 和 p2v

  ​							`virt-v2v` 和 `virt-p2v` 工具只在 AMD64 和 Intel 64 构架中被支持，且没有在 IBM Z 中提供。 					

- 迁移

  ​							要成功迁移到后续主机模型（例如，从 IBM z14 升级到 z15），或者使用 `host-model` CPU 模式。不建议使用 `host-passthrough` 和 `maximum` CPU 模式，因为它们通常不是迁移安全状态。 					 						如果要在 `自定义` CPU 模式中指定显式 CPU 模型，请按照以下步骤操作： 					 								不要使用以 `-base` 结尾的 CPU 型号。 							 								不要使用 `qemu`、`max` 或 `host` CPU 模型。 							 						要成功迁移到较旧的主机模型（如从 z15 到 z14），或迁移到早期版本的 QEMU、KVM 或 RHEL 内核，请使用最老的可用主机模型（在最后没有 `-base`）。 					 								如果您同时运行源主机和目标主机，您可以在目标主机上使用 `virsh cpu-baseline` 命令来获取适当的 CPU 模型。 							

**其它资源**

- ​						[跨构架支持的虚拟化功能概述](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#an-overview-of-virtualization-features-support-in-rhel-9_feature-support-and-limitations-in-rhel-9-virtualization) 				

## 22.6. ARM 64 上的虚拟化与 AMD64 和 Intel 64 的不同

​				ARM 64 系统上的 RHEL 9 中的 KVM 虚拟化与 AMD64 和 Intel 64 系统中的 KVM 虚拟化在很多方面有所不同。这包括但不限于： 		

- 支持

  ​							ARM 64 上的虚拟化仅作为技术预览在 RHEL 9 中提供，因此不受支持。https://access.redhat.com/support/offerings/techpreview/ 					

- 客户机操作系统

  ​							目前唯一在 ARM 64 虚拟机(VM)上操作的客户机操作系统是 RHEL 9。 					

- Web 控制台管理

  ​							[RHEL 9 web 控制台中虚拟机管理的某些功能在](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#managing-virtual-machines-in-the-web-console_configuring-and-managing-virtualization) ARM 64 硬件上无法正常工作。 					

- vCPU 热插和热拔

  ​							在 ARM 64 主机上不支持将虚拟 CPU(vCPU)附加到正在运行的虚拟机（也称为 vCPU 热插）。另外，与 AMD64 和 Intel 64 主机类似，ARM 64 不支持从正在运行的虚拟机（vCPU 热拔）中删除 vCPU。 					

- SecureBoot

  ​							SecureBoot 功能在 ARM 64 系统中不可用。 					

- PXE

  ​							在 Preboot Execution Environment(PXE)中引导只能使用 `virtio-net-pci` 网络接口控制器(NIC)。另外，需要使用虚拟机 UEFI 平台固件（带有 `edk2-aarch64` 软件包安装的）内置 `VirtioNetDxe` 驱动程序进行 PXE 引导。请注意，不支持 iPXE 选项 ROM。 					

- 设备内存

  ​							设备内存特性（如双线内存模块(DIMM)和非易失性 DIMM）在 ARM 64 上不起作用。 					

- pvpanic

  ​							pvpanic 设备目前在 ARM 64 上无法正常工作。确保从 ARM 64 上的客户机 XML 配置的 < `devices&` gt; 部分删除 < `panic` > 元素，因为它存在可能会导致虚拟机无法引导。 					

- OVMF

  ​							ARM 64 主机上的虚拟机无法使用 AMD64 和 Intel 64 使用的 OVMF UEFI 固件，包括在 `edk2-ovmf` 软件包中。相反，这些虚拟机使用 `edk2-aarch64` 软件包中包含的 UEFI 固件，它提供类似的接口并实施类似的功能集。 					 						具体来说，`edk2-aarch64` 提供了一个内置的 UEFI shell，但不支持以下功能： 					 								SecureBoot 							 								管理模式 							 								TPM-1.2 支持 							

- kvm-clock

  ​							`kvm-clock` 服务不必为 ARM 64 的虚拟机中的时间管理配置。 					

- 外设设备

  ​							ARM 64 系统不支持 AMD64 和 Intel 64 系统支持的所有外设设备。在某些情况下，设备功能并根本不支持，其他情况下，支持不同的设备来实现相同的功能。 					

- 串行控制台配置

  ​							[在虚拟机上设置串行控制台时，请在](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#proc_opening-a-virtual-machine-serial-console_assembly_connecting-to-virtual-machines) `/etc/default/grub` 文件中使用 **console=ttyAMA0** 参数而不是 **console=ttyS0**。 					

- 不可屏蔽中断

  ​							目前无法向 ARM 64 虚拟机发送不可屏蔽中断(NMI)。 					

- 嵌套虚拟化

  ​							目前在 ARM 64 主机上无法创建嵌套虚拟机。 					

- v2v 和 p2v

  ​							`virt-v2v` 和 `virt-p2v` 实用程序只在 AMD64 和 Intel 64 构架中被支持，因此不是在 ARM 64 中提供。 					

## 22.7. RHEL 9 支持虚拟化功能概述

​				下表提供了在可用系统构架中 RHEL 9 中所选虚拟化功能的支持状态的信息。 		

**表 22.1. 常规支持**

| Intel 64 和 AMD64 | IBM Z | ARM 64                                                       |
| ----------------- | ----- | ------------------------------------------------------------ |
| 支持              | 支持  | *不支持* 						 						  							（[技术预览](https://access.redhat.com/support/offerings/techpreview)） |

**表 22.2. 设备热插和热拔**

|                                                              | Intel 64 和 AMD64 | IBM Z                                                        | ARM 64                 |
| ------------------------------------------------------------ | ----------------- | ------------------------------------------------------------ | ---------------------- |
| **CPU 热插**                                                 | 支持              | 支持                                                         | *不可用*               |
| **CPU 热拔**                                                 | *不支持*          | *不支持*                                                     | *不可用*               |
| **内存热插拔**                                               | 支持              | *不支持*                                                     | *不可用*               |
| **内存热拔**                                                 | *不支持*          | *不支持*                                                     | *不可用*               |
| **外设设备热插拔**                                           | 支持              | 支持 [[a\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#ftn.idm140487960019040) | 可用，但 *UNSUPPORTED* |
| **外设设备热拔**                                             | 支持              | 支持 [[b\]](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#ftn.idm140487960942432) | 可用，但 *UNSUPPORTED* |
| [[a\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#idm140487960019040) 								需要使用 `virtio-***-ccw` 设备而不是 `virtio-***-pci` 							[[b\] ](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#idm140487960942432) 								需要使用 `virtio-***-ccw` 设备而不是 `virtio-***-pci` |                   |                                                              |                        |

**表 22.3. 其他选择的功能**

|                     | Intel 64 和 AMD64 | IBM Z    | ARM 64   |
| ------------------- | ----------------- | -------- | -------- |
| **NUMA 调整**       | 支持              | *不支持* | *不可用* |
| **SR-IOV 设备**     | 支持              | *不支持* | *不可用* |
| **virt-v2v 和 p2v** | 支持              | *不支持* | *不可用* |

​				请注意，一些不被支持的功能可能会被其他红帽产品（如 Red Hat Virtualization 和 Red Hat OpenStack 平台）支持。如需更多信息，请参阅 [第 22.3 节 “RHEL 9 虚拟化不支持的功能”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#unsupported-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization)。 		

**其他资源**

- ​						[RHEL 9 虚拟化不支持的功能](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/configuring_and_managing_virtualization/index#unsupported-features-in-rhel-9-virtualization_feature-support-and-limitations-in-rhel-9-virtualization) 				

​                

## 管理工具

1. virsh

2. Cockpit虚拟机工具

   ```bash
   yum install cockpit-machines
   systemctl enable --now cockpit.socket
   ```

## 系统需求
### 主机系统
1. one core or thread for each virtualized CPU and one for the host
2. 2GB RAM，plus additional RAM for virtual machines.
3. 6GB disk space for the host, plus the required disk place for the virtual machines.

### KVM hypervisor

Intel处理器（Intel VT-x和基于x86的系统的Intel64扩展）或者AMD处理器（AMD-V及AMD64扩展）

```bash
方法1：
# lscpu
Virtualization:   VT-x
Virtualization:   AMD-V
# egrep 'svm|vmx' /proc/cpuinfo
# svm Intel  vmx AMD

方法2：
virt-host-validate
# 系统必须通过所有验证项
```
### BIOS Enable Virtualization

## 安装

### CentOS

```bash
# 安装virt Yum模块
yum module list virt
yum module install virt

yum -y groupinstall "Virtualization Host"
yum -y install virt-{install,viewer,manager}

echo "net,ipv4.ip_forward = 1" > /etc/sysctl.d/99-ipforward.conf
sysctl -p /etc/sysctl.d/99-ipforward.conf

lsmod | grep kvm
```

## 故障处理
1. 修改网络相关信息，网卡不可用。
修改虚拟机配置文件　`/etc/udev/rules.d/70-persistent-net.rules`

## 发展历程

以色列创业公司 Qumranet员工 Avi Kivity 等人开发，2006 年 8 月完全开源，10 月 19 日首次发布在 Linux 内核的邮件列表里。

KVM 补丁集的第一个版本一经发布就支持了英特尔 CPU 刚刚引入的 VMX 指令。对 AMD 的 SVM 指令的支持紧随其后。KVM 补丁集在 2006 年 12 月合并进上游内核。

2007 年 2 月，Linux Kernel-2.6.20 中第一次包含了 KVM。

2008 年 9 月，红帽收购了 Qumranet ，由此入手了 KVM 的虚拟化技术。在之前，红帽是将 Xen 加入到自己的默认特性当中。那是2006 年，因为当时Xen技术脱离了内核的维护方式，也许是因为采用 Xen 的 RHEL  在企业级虚拟化方面没有赢得太多的市场，也许是因为思杰跟微软走的太近了，种种原因，导致其萌生了放弃 Xen。而且在正式采用 KVM 一年后，就宣布在新的产品线中彻底放弃 Xen ，集中资源和精力进行 KVM 的工作。

2009 年 9 月，红帽发布 RHEL5.4 ，在原先的 Xen 虚拟化机制之上，将 KVM 添加了进来。

2010 年 11 月，红帽发布 RHEL6.0 ，将默认安装的 Xen 虚拟化机制彻底去除，仅提供 KVM 虚拟化机制。

2011 年初，红帽的老搭档 IBM 找上红帽，表示 KVM 这个东西值得加大力度去做。于是到了 5 月， IBM  和红帽，联合惠普和英特尔一起，成立了开放虚拟化联盟（ Open Virtualization Alliance ），一起声明要提升 KVM  的形象，加速 KVM 投入市场的速度，由此避免 VMware 一家独大的情况出现。联盟成立之时，红帽的发言人表示， 大家都希望除 “  VMware 之外还有一种开源选择。未来的云基础设施一定会基于开源。自 Linux 2.6.20 之后逐步取代 Xen 被集成在Linux 的各个主要发行版本中，使用 Linux 自身的调度器进行管理。