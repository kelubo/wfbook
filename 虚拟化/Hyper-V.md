# How to set up Ubuntu on Hyper-V 如何在 Hyper-V 上设置 Ubuntu

Hyper-V is a native [type 1 hypervisor](https://en.wikipedia.org/wiki/Hypervisor#Classification) developed by Microsoft for the Windows family of operating systems,  similar to Xen or VMWare ESXi. It was first released for Windows Server  in 2008, and has been available without additional charge since Windows  Server 2012 and Windows 8.
Hyper-V 是 Microsoft 为 Windows 系列操作系统开发的本机 1 类虚拟机管理程序，类似于 Xen 或 VMWare ESXi。它于  2008 年首次针对 Windows Server 发布，自 Windows Server 2012 和 Windows 8 以来一直免费提供。

Hyper-V allows Ubuntu to be run in parallel or in isolation on Windows  operating systems. There are several use-cases for running Ubuntu on  Hyper-V:
Hyper-V 允许 Ubuntu 在 Windows 操作系统上并行或隔离运行。在 Hyper-V 上运行 Ubuntu 有几个用例：

- To introduce Ubuntu in a Windows-centric IT environment.
  在以 Windows 为中心的 IT 环境中引入 Ubuntu。
- To have access to a complete Ubuntu desktop environment without dual-booting a PC.
  无需双启动 PC 即可访问完整的 Ubuntu 桌面环境。
- To use Linux software on Ubuntu that is not yet supported on the[ Windows Subsystem for Linux](https://learn.microsoft.com/windows/wsl/about).
  在 Ubuntu 上使用适用于 Linux 的 Windows 子系统尚不支持的 Linux 软件。

## Hyper-V system requirements Hyper-V 系统要求

The following are typical [system requirements for Hyper-V](https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows):
以下是 Hyper-V 的典型系统要求：

- A 64-bit processor with Second Level Address Translation (SLAT)
  具有二级地址转换 （SLAT） 的 64 位处理器
- CPU support for virtualization extensions and virtualization enabled in the system BIOS/EFI
  在系统 BIOS/EFI 中启用虚拟化扩展和虚拟化的 CPU 支持
- Minimum of 4 GB of memory, recommended 8 GB
  至少 4 GB 内存，建议 8 GB
- Minimum of 5 GB of disk space, recommended 15 GB
  至少 5 GB 磁盘空间，建议 15 GB

## Install Hyper-V 安装 Hyper-V

Our first step in enabling Ubuntu is to install Hyper-V, which can be used  on the Windows 11 Pro, Enterprise, Education and Server operating  systems.
我们启用 Ubuntu 的第一步是安装 Hyper-V，它可以在 Windows 11 专业版、企业版、教育和服务器操作系统上使用。

Hyper-V is not included in Windows 11 Home, which [would need to be upgraded](https://support.microsoft.com/en-us/windows/upgrade-windows-home-to-windows-pro-ef34d520-e73f-3198-c525-d1a218cc2818) to Windows 11 Pro.
Hyper-V 不包含在 Windows 11 家庭版中，需要升级到 Windows 11 专业版。

### Install Hyper-V graphically 以图形方式安装 Hyper-V

1. Right click on the Windows Start button and select ‘Apps and Features’.
   右键单击Windows“开始”按钮，然后选择“应用程序和功能”。
2. Select ‘Programs and Features’ under Related Settings.
   在“相关设置”下选择“程序和功能”。
3. Select ‘Turn Windows Features on or off’.
   选择“打开或关闭 Windows 功能”。
4. Select ‘Hyper-V’ and click OK.
   选择“Hyper-V”，然后单击“确定”。
5. Restart when prompted. 出现提示时重新启动。

### Install Hyper-V using PowerShell 使用 PowerShell 安装 Hyper-V

1. Open a PowerShell console as Administrator.
   以管理员身份打开 PowerShell 控制台。

2. Run the following command:
   运行以下命令：

   ```auto
   Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
   ```

3. Restart when prompted. 出现提示时重新启动。

## Install Ubuntu on Hyper-V 在 Hyper-V 上安装 Ubuntu

There are two main methods for installing Ubuntu on Hyper-V depending on your use case. Read each of the descriptions of the following methods and  then determine the best for your situation.
根据用例，在 Hyper-V 上安装 Ubuntu 有两种主要方法。阅读以下方法的每种说明，然后确定最适合您的情况的方法。

### Using Quick Create 使用快速创建

The recommended method is to use the curated Ubuntu image from the Hyper-V  Quick Create Gallery. This is ideal for desktop development on Ubuntu  and for users interested in running a complete Ubuntu desktop  environment. The Ubuntu image from the Quick Create Gallery includes  pre-configured features, such as clipboard sharing, dynamic resolution  display, and shared folders.
建议的方法是使用 Hyper-V 快速创建库中的特选 Ubuntu 映像。这非常适合在 Ubuntu 上进行桌面开发，也非常适合对运行完整的 Ubuntu  桌面环境感兴趣的用户。快速创建库中的 Ubuntu 映像包括预配置的功能，例如剪贴板共享、动态分辨率显示和共享文件夹。

1. Enable Hyper-V as described above.
   如上所述启用 Hyper-V。

2. Open ‘Hyper-V Manager’ by either:
   通过以下任一方式打开“Hyper-V 管理器”：

   - Selecting the Windows Start button, then
     选择 Windows“开始”按钮，然后选择
      → Expanding the ‘Windows Administrative Tools’ folder
     → 展开“Windows 管理工具”文件夹
      → Selecting ‘Hyper-V Manager’
     →选择“Hyper-V 管理器”

   or

   - Selecting the Windows key, then
     选择 Windows 键，然后
      → typing ‘Hyper-V’ →键入“Hyper-V”
      → selecting ‘Hyper-V Manager’
     →选择“Hyper-V 管理器”

   In the future, the Quick Create tool can be accessed directly using the  above methods, but it is useful to know where Hyper-V Manager is because it is what you will use to manage your Ubuntu VM.
   将来，可以使用上述方法直接访问快速创建工具，但了解 Hyper-V 管理器的位置很有用，因为它是用于管理 Ubuntu VM 的工具。

3. On the ‘Actions’ pane select ‘Quick Create’ and the Quick Create tool will open.
   在“操作”窗格中，选择“快速创建”，将打开快速创建工具。

4. Select a version of Ubuntu from the versions on the list. A build of the [most recent LTS](https://wiki.ubuntu.com/LTS) version of Ubuntu and the [most recent interim release](https://wiki.ubuntu.com/Releases) are provided.
   从列表中的版本中选择 Ubuntu 的版本。提供了 Ubuntu 的最新 LTS 版本和最新的临时版本的构建。

   - The **LTS version** is recommended if you are developing for Ubuntu Server or an enterprise environment.
     如果您正在为 Ubuntu Server 或企业环境进行开发，则建议使用 LTS 版本。
   - The **interim release** is recommended if you would like to use the latest versions of software in Ubuntu.
     如果您想在 Ubuntu 中使用最新版本的软件，建议使用临时版本。

5. Select ‘Create Virtual Machine’ and wait for the VM image to be downloaded.
   选择“创建虚拟机”，然后等待下载虚拟机映像。

6. Select ‘Connect’ to open a connection to your VM.
   选择“连接”以打开与 VM 的连接。

7. Select ‘Start’ to run your VM.
   选择“开始”以运行 VM。

8. Complete the final stages of the Ubuntu install, including username selection.
   完成 Ubuntu 安装的最后阶段，包括用户名选择。

### Using an Ubuntu CD image 使用 Ubuntu CD 映像

It is possible to install Ubuntu on Hyper-V using a CD image ISO. This is  useful if you are running Ubuntu Server and do not need an enhanced  desktop experience. Note that the enhanced features of the Quick Create  images are not enabled by default when you perform a manual install from an ISO.
可以使用 CD 映像 ISO 在 Hyper-V 上安装 Ubuntu。如果您运行的是 Ubuntu Server 并且不需要增强的桌面体验，这将非常有用。请注意，当您从 ISO 执行手动安装时，默认情况下不会启用快速创建映像的增强功能。

1. Download an Ubuntu ISO from an [official Ubuntu source](https://ubuntu.com/download/server).
   从官方 Ubuntu 源下载 Ubuntu ISO。

2. Install Hyper-V as described above.
   如上所述安装 Hyper-V。

3. Open ‘Hyper-V Manager’ by either:
   通过以下任一方式打开“Hyper-V 管理器”：

   - Selecting the Windows Start button, then
     选择 Windows“开始”按钮，然后选择
      → Expanding the ‘Windows Administrative Tools’ folder
     → 展开“Windows 管理工具”文件夹
      → Selecting ‘Hyper-V Manager’
     →选择“Hyper-V 管理器”

     or

   - Selecting the Windows key, then
     选择 Windows 键，然后
      → Typing ‘Hyper-V’ →键入“Hyper-V”
      → Selecting ‘Hyper-V Manager’
     →选择“Hyper-V 管理器”

4. On the ‘Actions’ pane click ‘Quick Create’ and the Quick Create tool will open.
   在“操作”窗格中，单击“快速创建”，将打开快速创建工具。

5. Select ‘Change installation source’ and choose the ISO file you downloaded before.
   选择“更改安装源”，然后选择您之前下载的 ISO 文件。

   If you want to give your virtual machine a more descriptive name, select  the ‘More options’ down-arrow and change ‘New Virtual Machine’ to  something more useful, e.g. ‘Ubuntu Server 18.04 LTS’.
   如果要为虚拟机提供更具描述性的名称，请选择“更多选项”向下箭头，并将“新建虚拟机”更改为更有用的名称，例如“Ubuntu Server 18.04 LTS”。

6. Select ‘Create Virtual Machine’ and wait for the virtual machine to be created.
   选择“创建虚拟机”并等待虚拟机创建。

7. Select ‘Connect’ to open a connection to your VM.
   选择“连接”以打开与 VM 的连接。

8. Select ‘File’ in the menu bar, then
   在菜单栏中选择“文件”，然后
    → Choose ‘Settings’ and select the ‘Security’ tab
   → 选择“设置”，然后选择“安全”选项卡
    → Under Secure Boot choose ‘Microsoft UEFI Certificate Authority’
   → 在“安全启动”下，选择“Microsoft UEFI 证书颁发机构”
    → Then select ‘Apply’ and ‘OK’ to return to your VM.
   → 然后选择“应用”和“确定”以返回到 VM。

9. Select ‘Start’ to run your VM.
   选择“开始”以运行 VM。

10. Complete the manual installation of Ubuntu.
    完成 Ubuntu 的手动安装。