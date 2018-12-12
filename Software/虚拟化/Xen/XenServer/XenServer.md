# XenServer
## XenServer系统要求
| 硬件 | 要求 |
|----|----|
| CPU | 一个和多个64位x86 CPU，主频最低为1.5GHz，建议使用2GHz或更快的多核CPU。要支持运行Windows的VM，需要使用带有一个或多个CPU的Intel VT或AMD-V 64位x86系统，BIOS中启用虚拟化支持。 |
| RAM | 最低2GB，建议4GB或更高容量。 |
| 磁盘空间 | 本地连接的存储(PATA,SATA,SCSI)，最低磁盘空间为16GB，建议使用60GB磁盘空间。如果从SAN通过多路径引导进行安装，则使用通过HBA的SAN。安装过程会产生两个4GB的XenServer主机控制域分区。 |
| 网络 | 100Mbit/s或更快的NIC |
## XenCenter系统要求
| 类型 | 要求 |
|----|----|
| 操作系统 | Windows 8.1,Windows 8,Windows 7 SP1,Windows Vista SP2,Windows Server 2012 R2,Windows Server 2012,Windows Server 2008 R2 SP1,Windows Server 2008 SP2,Windows Server 2003 SP2 |
| .NET Framework | 4 |
| CPU | 最低750MHz |
| RAM | 最低1GB |
| 磁盘空间 | 最低100MB |
| 网络 | 100Mb或者更快的NIC |
| 屏幕分辨率 | 最低1024*768 |
## XenServer主机
>* **Xen虚拟机管理程序**(XenServer 6.5使用Xen v4.4.1)
>* **控制域**(Domain0或dom0)是一个安全的特权Linux VM(基于CentOS v5.10发行版)，运行XenServer管理toolstack。运行驱动程序堆栈，提供对物理设备的用户创建虚拟机访问。
>* **管理toolstack**也叫作xapi，可以控制VM生命周期操作、主机和VM网络连接、VM存储、用户身份验证，并允许管理XenServer资源池。提供公开记录的XenAPI管理接口，以供管理VM和资源池的所有工具使用。
>* **VM模板**
>* **为VM预留的本地存储库(SR)**

##存储池
>* NFS VHD存储池
>* 软件iSCSI存储
>* 硬件HBA存储
