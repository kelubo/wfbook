# Citrix Licensing 系统要求
## Licensing for Windows 的要求
许可证服务器不支持多宿（插入到不同网络中的两个网卡）。  
许可证管理控制台负责管理安装了许可证服务器的计算机上对应的许可证服务器，但不负责管理远程许可证服务器。Simple License Service 只能在其所在的许可证服务器上安装许可证。  

操作系统

    Windows Server 2008 系列
    Windows Server 2008 R2 系列
    Windows Server 2012 系列
    Windows Server 2012 R2 系列
    Windows 7（32 位和 64 位版本）
    Windows 8（32 位和 64 位版本）
    Windows 8.1（32 位和 64 位版本）

磁盘空间要求
	
    许可组件需要 55 MB
    用户/设备许可需要 2 GB

Microsoft .NET Framework 要求
	
    需要安装 Microsoft .NET Framework 3.5 SP1 或更高版本。

浏览器

    Internet Explorer 10 和 11
    Internet Explorer 8 和 9（兼容模式）
    Mozilla Firefox 14.0 和 15.0
    Chrome 14.0 和 15.0
    Safari 5.1

## 安装 License Server VPX 的要求
内存

    512 MB。足以满足多达 500 台 Citrix 服务器和大约 50000 个许可证服务器的需求，但操作过程中应监视可用内存，以确定是否需要增加更多内存。对于大型环境，Citrix 建议分配更多内存。

XenServer 版本

    XenServer 6.1、6.2 和 XenServer 6.5。

最低存储要求

    XenServer 池中的默认存储库需要有 8 GB 存储空间。

虚拟 CPU (VCPU)

    1 个 VCPU。对于更大型的环境或这些可利用的用户/设备许可，请考虑再增加一个 VCPU。

浏览器
	

    Internet Explorer 10.0（适用于 32 位）和 11.0（适用于 64 位）
    Mozilla Firefox 26.0 和 27.0
    Chrome 31.0 和 32.0
    Safari 3.0.3 和 5.1.7