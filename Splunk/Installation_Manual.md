# Installation Manual
## Welcome to the Splunk Enterprise Installation Manual
###  What's in this manual
Contents
   Find what you need

In the Installation Manual, you can find:
   System requirements
   Licensing information
   Procedures for installing
   Procedures for upgrading from a previous version 

...and more.

Note The Installation Manual details installing full Splunk Enterprise only. To install the Splunk universal forwarder, see "Universal forwarder deployment overview" in the Forwarding Data Manual. Unlike Splunk heavy and light forwarders, which are full Splunk Enterprise instances with some features changed or disabled, the universal forwarder is a separate executable with its own set of installation procedures. For an introduction to forwarders, see "About forwarding and receiving."
#### Find what you need

You can use the table of contents to the left of this panel, or search for what you want in the search box in the upper right.

If you're interested in more specific scenarios and best practices, go to the Splunk Community Wiki to see how other users Splunk IT. 
###  What happened to parts of this manual?

To better align our documentation and make it more accessible to our customers, we moved information not associated with installing Splunk Enterprise from this manual to other manuals.

Most of the material has moved to the new Capacity Planning manual, which takes content from both this and the Distributed Deployment manual and puts it all in one place. 
## Plan your Splunk Enterprise installation
###  Installation overview
Contents

     
    Installation basics
     
    Upgrading or migrating a Splunk Enterprise instance?

This topic discusses the steps required to install Splunk Enterprise on a computer. Read this topic and the contents of this chapter before you install Splunk Enterprise.
#### Installation basics

1. Review the system requirements for installation. Additional requirements might apply based on the operating system on which you install Splunk Enterprise and how you plan to use Splunk Enterprise.

2. See "Components of a Splunk Enterprise deployment" to learn about the Splunk Enterprise ecosystem, and "Splunk architecture and processes" to learn what the installer puts on your computer.

3. See "Secure your Splunk Enterprise installation" and, where appropriate, secure the machine on which you plan to install Splunk Enterprise.

4. Download the installation package for your system from the Splunk Enterprise download page.

5. Perform the installation by using the step-by-step installation instructions for your operating system.

6. If this is the first time you have installed Splunk Enterprise, see the Search Tutorial to learn how to index data into Splunk and search that data using the Splunk Enterprise search language.

7. After you install Splunk Enterprise, calculate how much space you need to index your data. See "Estimate your storage requirements" for more information.

8. To run Splunk Enterprise in a production environment and to understand how much hardware such an environment requires, see the Capacity Planning manual.
#### Upgrading or migrating a Splunk Enterprise instance?

To upgrade from an earlier version of Splunk Enterprise, see "How to upgrade Splunk Enterprise" in this manual for information and specific instructions. For tips on migrating from one version to another, see the "READ THIS FIRST" topic for the version that you want to upgrade to. This topic is in "Upgrade or Migrate Splunk Enterprise" in this manual.

If you want to know how to move a Splunk Enterprise instance from one system to another, see "Migrate a Splunk instance" in this manual. 
### System requirements
Contents

     
    Supported server hardware architectures
     
    Supported Operating Systems
     
    Supported browsers
     
    Recommended hardware
     
    Supported file systems

Before you download and install Splunk Enterprise, read this topic to learn about the computing environments that Splunk supports. See the download page for the latest version to download. See the release notes for details on known and resolved issues.

For a discussion of hardware planning for deployment, see the Capacity Planning manual.

If you have ideas or requests for new features to add to future releases, contact Splunk Support. You can also review our product road map.
Supported server hardware architectures

Splunk offers support for 32- and 64-bit architectures on some platforms. See the download page for details.
Supported Operating Systems

The following tables list the available computing platforms for Splunk Enterprise. The first table lists availability for *nix operating systems and the second lists availability for Windows operating systems.

Determine whether Splunk Enterprise is available for your platform.

1. Find the operating system on which you want to install Splunk Enterprise in the left column.

2. Read across the columns to find the computing architecture in the center column that matches your environment.

The tables show availability for several types of Splunk software, as shown in the two columns on the right: Splunk Enterprise, Splunk Free, Splunk Trial, and Splunk Universal Forwarder. A '✔' in the box that intersects your computing platform and the Splunk software type means that Splunk software is available for that platform. An empty box means that Splunk is not available for that platform. If you do not see your platform or architecture listed, the software is not available for that platform and architecture.

Some boxes have other characters. See the bottom of each table to find out what the additional characters represent.
Unix operating systems
Operating system 	Architecture 	Enterprise 	Free 	Trial 	Universal Forwarder
Solaris 10 and 11* 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
SPARC 	✔ 	✔ 	✔ 	✔
x86 (32-bit) 	* 	* 	* 	*
Linux, 2.6+ 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
x86 (32-bit) 	✔ 	✔ 	✔ 	✔
Linux, 3.0+ 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
x86 (32-bit) 	✔ 	✔ 	✔ 	✔
PowerLinux, 2.6+ 	PowerPC 				✔
zLinux, 2.6+ 	s390x 				✔
FreeBSD 7** 	x86 (32-bit) 				✔
FreeBSD 8 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
x86 (32-bit) 				✔
FreeBSD 9 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
Mac OS X 10.8, 10.9, and 10.10 	Intel 		✔ 	✔ 	✔
AIX 6.1 and 7.1 	PowerPC 	✔ 	✔ 	✔ 	✔
HP/UX† 11i v2 and 11i v3 	Itanium 				✔

* Splunk Enterprise is available for Solaris 10. Solaris 11 does not support 32-bit Splunk Enterprise installs.
** See the notes on FreeBSD 7 compatibility below.
† You must use gnu tar to unpack the HP/UX installation archive.
Windows operating systems

The table lists the Windows computing platforms that Splunk Enterprise supports.
Operating system 	Architecture 	Enterprise 	Free 	Trial 	Universal Forwarder
Windows Server 2003 and Server 2003 R2 	x86 (64-bit) 				✔
x86 (32-bit) 				✔
Windows Server 2008 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
x86 (32-bit) 	*** 	*** 	*** 	✔
Windows Server 2008 R2, Server 2012, and Server 2012 R2 	x86 (64-bit) 	✔ 	✔ 	✔ 	✔
Windows 7 	x86 (64-bit) 		✔ 	✔ 	✔
x86 (32-bit) 		*** 	*** 	✔
Windows 8 	x86 (64-bit) 		✔ 	✔ 	✔
x86 (32-bit) 		*** 	*** 	✔
Windows 8.1 	x86 (64-bit) 		✔ 	✔ 	✔
x86 (32-bit) 		*** 	*** 	✔

*** Splunk supports but does not recommend using Splunk Enterprise on this platform and architecture.
Operating system notes and additional information
Windows

Certain parts of Splunk Enterprise on Windows require elevated user permissions to function properly. For information about what is required, see the following topics:

    "Splunk architecture and processes" in this manual.
    "Choose the user Splunk should run as" in this manual.
    "Considerations for deciding how to monitor remote Windows data" in the Getting Data In manual. 

FreeBSD 7.x

To run Splunk 6.x on 32-bit FreeBSD 7.x, install the compat6x libraries. Splunk Support supplies best effort support for users running on FreeBSD 7.x. See "Install Splunk on FreeBSD 7" in the Community Wiki.
Deprecated operating systems and features

As we version the Splunk product, we gradually deprecate support of older operating systems. See "Deprecated features" in the Release Notes for information on which platforms and features have been deprecated or removed entirely.
Creating and editing configuration files on non-UTF-8 OSes

Splunk Enterprise expects configuration files to be in ASCII or Universal Character Set Transformation Format-8-bit (UTF-8) format. If you edit or create a configuration file on an OS that does not use UTF-8 character set encoding, then ensure that the editor you are using is configured to save in ASCII/UTF-8.
IPv6 platform support

All Splunk-supported OS platforms are supported for use with IPv6 configurations except for the following:

    AIX
    HP/UX on PA-RISC architecture
    Solaris 9 

See "Configure Splunk for IPv6" in the Admin Manual for details on Splunk IPv6 support.
Supported browsers

Splunk Enterprise supports the following browsers:

    Firefox ESR (31.2) and latest
    Internet Explorer 9, 10, and 11
    Safari (latest)
    Chrome (latest) 

Confirm that you have the latest version of Adobe Flash installed to render any charts that use options that the JSChart module does not support. For information, see "About JSChart" in Developing Views and Apps for Splunk Web.

Do not use Internet Explorer in Compatibility Mode when you access Splunk Web. Splunk Web warns you that your browser is not supported. If you must use IE in compatibility mode for other applications, you must use a supported browser for Splunk Web.

Internet Explorer version 9 does not support file uploads. Use IE version 10 or later.
Recommended hardware

If you are performing a comprehensive evaluation of Splunk Enterprise for production deployment, use hardware typical of your production environment. This hardware should meet or exceed the recommended hardware capacity specifications below.

For a discussion of hardware planning for production deployment, see "Introduction to capacity planning for Splunk Enterprise" in the Capacity Planning manual.
Splunk Enterprise and virtual machines

If you run Splunk Enterprise in a virtual machine (VM) on any platform, performance decreases. This is because virtualization works by abstracting the hardware on a system into resource pools from which VMs defined on the system draw as needed. Splunk Enterprise needs sustained access to a number of resources, particularly disk I/O, for indexing operations. Running Splunk in a VM or alongside other VMs can cause reduced indexing and search performance.
Recommended and minimum hardware capacity

The following requirements are accurate for a single instance installation with light to moderate use. For significant enterprise and distributed deployments, see the Capacity Planning manual.
Platform 	Recommended hardware capacity/configuration 	Minimum supported hardware capacity
Non-Windows platforms 	2x six-core, 2+ GHz CPU, 12GB RAM, Redundant Array of Independent Disks (RAID) 0 or 1+0, with a 64 bit OS installed. 	1x1.4GHz CPU, 1GB RAM
Windows platforms 	2x six-core, 2+ GHz CPU, 12GB RAM, RAID 0 or 1+0, with a 64-bit OS installed. 	Intel Nehalem CPU or equivalent at 2GHz, 2GB RAM

RAID 0 disk configurations do not provide fault-tolerance. Confirm that a RAID 0 configuration meets your data reliability needs before deploying a Splunk Enterprise indexer on a system configured with RAID 0.

    All configurations other than universal and light forwarder instances require at least the recommended hardware configuration.
    The minimum supported hardware guidelines are designed for personal use of Splunk. The requirements for Splunk in a production environment are significantly higher. 

Splunk recommends that you maintain a minimum of 5GB of hard disk space available on any Splunk instance, including forwarders, in addition to the space required for any indexes. See "Estimate your storage requirements" in the Capacity Planning Manual for more information. Failure to maintain this level of free space can result in degraded performance, operating system failure, and data loss.
Hardware requirements for universal and light forwarders
Recommended 	Dual-core 1.5GHz+ processor, 1GB+ RAM
Minimum 	1.0Ghz processor, 512MB RAM
Supported file systems
Platform 	File systems
Linux 	ext2/3/4, reiser3, XFS, NFS 3/4
Solaris 	UFS, ZFS, VXFS, NFS 3/4
FreeBSD 	FFS, UFS, NFS 3/4, ZFS
Mac OS X 	HFS, NFS 3/4
AIX 	JFS, JFS2, NFS 3/4
HP-UX 	VXFS, NFS 3/4
Windows 	NTFS, FAT32

If you run Splunk Enterprise on a file system that is not listed, the software might run a startup utility named locktest to test the viability of the file system. Locktest is a program that tests the start up process. If locktest fails, then the file system is not suitable for running Splunk Enterprise.
Considerations regarding file descriptor limits (FDs) on *nix systems

Splunk Enterprise allocates file descriptors on *nix systems for actively monitored files, forwarder connections, deployment clients, users running searches, and so on.

Usually, the default file descriptor limit (controlled by the ulimit -n command on a *nix-based OS) is 1024. Your Splunk administrator determines the correct level, but it should be at least 8192. Even if Splunk Enterprise allocates a single file descriptor for each of the activities, it is easy to see how a few hundred files being monitored, a few hundred forwarders sending data, and a handful of very active users on top of reading and writing to and from the datastore can exhaust the default setting.

The more tasks your Splunk Enterprise instance does, the more FDs it needs. You should increase the ulimit value if you start to see your instance run into problems with low FD limits.

See about ulimit in the Troubleshooting Manual.

This consideration is not applicable to Windows-based systems.
Considerations regarding Network File System (NFS)

When you use Network File System (NFS) as a storage medium for Splunk indexing, consider all of the ramifications of file level storage.

Use block level storage rather than file level storage for indexing your data.

In environments with reliable, high-bandwidth, low-latency links, or with vendors that provide high-availability, clustered network storage, NFS can be an appropriate choice. However, customers who choose this strategy should work with their hardware vendor to confirm that the storage platform they choose operates to the specification in terms of both performance and data integrity.

If you use NFS, be aware of the following issues:

    Splunk Enterprise does not support "soft" NFS mounts. These are mounts that cause a program attempting a file operation on the mount to report an error and continue in case of a failure.
    Only "hard" NFS mounts (mounts where the client continues to attempt to contact the server in case of a failure) are reliable with Splunk Enterprise.
    Do not disable attribute caching. If you have other applications that require disabling or reducing attribute caching, then you must provide Splunk Enterprise with a separate mount with attribute caching enabled.
    Do not use NFS mounts over a wide area network (WAN). Doing so causes performance issues and can lead to data loss. 

Considerations regarding solid state drives

Solid state drives (SSDs) deliver significant performance gains over conventional hard drives for Splunk in "rare" searches - searches that request small sets of results over large swaths of data - when used in combination with bloom filters. They also deliver performance gains with concurrent searches overall.
Considerations regarding Common Internet File System (CIFS)/Server Message Block (SMB)

Splunk Enterprise supports the use of the CIFS/SMB protocol for the following purposes, on shares hosted by Windows hosts only:

    Search head pooling.
    Storage of cold or frozen Index buckets. 

When you use a CIFS resource for storage, confirm that the resource has write permissions for the user that connects to the resource at both the file and share levels. If you use a third-party storage device, ensure that its implementation of CIFS is compatible with the implementation that your Splunk Enterprise instance runs as a client.

Do not attempt to index data to a mapped network drive on Windows (for example "Y:\" mapped to an external share.) Splunk Enterprise disables any index it encounters with a non-physical drive letter.
Considerations regarding environments that use the transparent huge pages memory management scheme

If you run a Unix environment that makes use of transparent huge memory pages, see "Transparent huge memory pages and Splunk performance" before you attempt to install Splunk Enterprise.

No such scheme exists on Windows operating systems. 
###  Splunk Enterprise architecture and processes
Contents

     
    Splunk Enterprise Processes
     
    Additional processes for Splunk Enterprise on Windows
     
    Architecture diagram

This topic discusses the internal architecture and processes of Splunk Enterprise at a high level. If you're looking for information about third-party components used in Splunk Enterprise, see the credits section in the Release notes.
Splunk Enterprise Processes

A Splunk Enterprise server installs a process on your host, splunkd.

splunkd is a distributed C/C++ server that accesses, processes and indexes streaming IT data. It also handles search requests. splunkd processes and indexes your data by streaming it through a series of pipelines, each made up of a series of processors.

    Pipelines are single threads inside the splunkd process, each configured with a single snippet of XML.
    Processors are individual, reusable C or C++ functions that act on the stream of IT data that passes through a pipeline. Pipelines can pass data to one another through queues.
    New for version 6.2, splunkd also provides the Splunk Web user interface. It lets users search and navigate data and manage Splunk Enterprise deployment through a Web interface. It communicates with your Web browser through REpresentational State Transfer (REST).
    splunkd runs a Web server on port 8089 with SSL/HTTPS turned on by default.
    It also runs a Web server on port 8000 with SSL/HTTPS turned off by default. 

splunkweb installs as a legacy service on Windows only. Prior to version 6.2, it provided the Web interface for Splunk Enterprise. Now, it installs and runs, but quits immediately. You can configure it to run in "legacy mode" by changing a configuration parameter.

On Windows systems, splunkweb.exe is a third-party, open-source executable that Splunk renames from pythonservice.exe. Because it is a renamed file, it does not contain the same file version information as other Splunk Enterprise for Windows binaries.

Read information on other Windows third-party binaries that come with Splunk Enterprise.
Splunk Enterprise and Windows in Safe Mode

Neither the splunkd, the splunkweb, nor the SplunkForwarder services starts if Windows is in Safe Mode. If you attempt to start Splunk Enterprise from the Start Menu while in Safe Mode, Splunk Enterprise does not alert you to the fact that its services are not running.
Additional processes for Splunk Enterprise on Windows

On Windows instances of Splunk Enterprise, in addition to the two services described, Splunk Enterprise uses additional processes when you create specific data inputs on a Splunk Enterprise instance. These inputs run when configured by certain types of Windows-specific data input.
splunk.exe

splunk.exe is the control application for the Windows version of Splunk Enterprise. It provides the command-line interface (CLI) for the program. It lets you start, stop, and configure Splunk Enterprise, similar to the *nix splunk program.

The splunk.exe binary requires an elevated context to run because of how it controls the splunkd and splunkweb processes. Splunk Enterprise might not function correctly if this program does not have the appropriate permissions on your Windows system. This is not an issue if you install Splunk Enterprise as the Local System user.
splunk-admon

splunk-admon.exe runs whenever you configure an Active Directory (AD) monitoring input. splunkd spawns splunk-admon, which attaches to the nearest available AD domain controller and gathers change events generated by AD. Splunk Enterprise stores these events in an index.
splunk-perfmon

splunk-perfmon.exe runs when you configure Splunk Enterprise to monitor performance data on the local Windows machine. This binary attaches to the Performance Data Helper libraries, which query the performance libraries on the system and extract performance metrics both instantaneously and over time.
splunk-netmon

splunk-netmon runs when you configure Splunk Enterprise to monitor Windows network information on the local machine.
splunk-regmon

splunk-regmon.exe runs when you configure a Registry monitoring input in Splunk. This input initially writes a baseline for the Registry in its current state (if requested), then monitors changes to the Registry over time.
splunk-winevtlog

You can use this utility to test defined event log collections, and it outputs events as they are collected for investigation. Splunk Enterprise has a Windows event log input processor built into the engine.
splunk-winhostmon

splunk-winhostmon runs when you configure a Windows host monitoring input in Splunk. This input gets detailed information about Windows hosts.
splunk-winprintmon

splunk-winprintmon runs when you configure a Windows print monitoring input in Splunk. This input gets detailed information about Windows printers and print jobs on the local system.
splunk-wmi

When you configure a performance monitoring, event log or other input against a remote computer, this program runs. Depending on how you configure the input, it either attempts to attach to and read Windows event logs as they come over the wire, or executes a Windows Query Language (WQL) query against the Windows Management Instrumentation (WMI) provider on the specified remote machine.
Architecture diagram
![](./image/Architecture-new.png)
## Secure your Splunk Enterprise installation
## Install Splunk Enterprise on Windows
## Install Splunk Enterprise on Unix,Linux or Mac OS X
## Start using Splunk Enterprise
## Install a Splunk Enterprise license
## Upgrade or migrate Splunk Enterprise
## Uninstall Splunk Enterprise
## Reference