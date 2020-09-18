Red Hat Enterprise Linux 8.0

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



