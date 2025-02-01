# Security Requirements and Precautions 安全要求和预防措施

**IMPORTANT**: If you want to use VeraCrypt, you must follow the security requirements and security precautions listed in this chapter. **重要提示**：如果您想使用VeraCrypt，您必须遵守本章中列出的安全要求和安全预防措施。

The sections in this chapter specify security requirements for using  VeraCrypt and give information about things that adversely affect or  limit the ability of VeraCrypt to secure data and to provide plausible  deniability. Disclaimer: This chapter is not guaranteed to contain a list of *all* security issues and attacks that might adversely affect or limit the  ability of VeraCrypt to secure data and to provide plausible  deniability.
本章中的部分详细说明了使用VeraCrypt的安全要求，并提供了有关对VeraCrypt保护数据和提供合理否认能力产生不利影响或限制的信息。免责声明：本章不保证包含*所有*可能对VeraCrypt保护数据和提供合理否认的能力产生不利影响或限制的安全问题和攻击的列表。

- Data Leaks 数据泄露
  - [Paging File 分页文件](https://veracrypt.fr/en/Paging File.html)
  - [Hibernation File 休眠文件](https://veracrypt.fr/en/Hibernation File.html)
  - [Memory Dump Files 内存转储文件](https://veracrypt.fr/en/Memory Dump Files.html)
- [Unencrypted Data in RAM RAM中的未加密数据](https://veracrypt.fr/en/Unencrypted Data in RAM.html)
- [VeraCrypt Memory Protection
  VeraCrypt内存保护](https://veracrypt.fr/en/VeraCrypt Memory Protection.html)
- [Physical Security 物理安全](https://veracrypt.fr/en/Physical Security.html)
- [Malware 恶意软件](https://veracrypt.fr/en/Malware.html)
- [Multi-User Environment 多用户环境](https://veracrypt.fr/en/Multi-User Environment.html)
- [Authenticity and Integrity
  真实性和完整性](https://veracrypt.fr/en/Authenticity and Integrity.html)
- [Choosing Passwords and Keyfiles
  选择密码和密钥文件](https://veracrypt.fr/en/Choosing Passwords and Keyfiles.html)
- [Changing Passwords and Keyfiles
  更改密码和密钥文件](https://veracrypt.fr/en/Changing Passwords and Keyfiles.html)
- [Trim Operation 修剪操作](https://veracrypt.fr/en/Trim Operation.html)
- [Wear-Leveling 损耗均衡](https://veracrypt.fr/en/Wear-Leveling.html)
- [Reallocated Sectors 重新分配的部门](https://veracrypt.fr/en/Reallocated Sectors.html)
- [Defragmenting 碎片整理](https://veracrypt.fr/en/Defragmenting.html)
- [Journaling File Systems 日志文件系统](https://veracrypt.fr/en/Journaling File Systems.html)
- [Volume Clones 卷克隆](https://veracrypt.fr/en/Volume Clones.html)
- [Additional Security Requirements and Precautions
  其他安全要求和预防措施](https://veracrypt.fr/en/Additional Security Requirements and Precautions.html)

## Data Leaks 数据泄露

When a VeraCrypt volume is mounted, the operating system and third-party  applications may write to unencrypted volumes (typically, to the  unencrypted system volume) unencrypted information about the data stored in the VeraCrypt volume (e.g. filenames and locations of recently accessed files, databases created by file  indexing tools, etc.), or the data itself in an unencrypted form  (temporary files, etc.), or unencrypted information about the filesystem residing in the VeraCrypt volume.
当安装VeraCrypt加密卷时，操作系统和第三方应用程序可能会向未加密的加密卷（通常是未加密的系统加密卷）写入有关存储在VeraCrypt加密卷中的数据的未加密信息（例如，最近访问的文件的文件名和位置，文件索引工具创建的数据库等），或未加密形式的数据本身（临时文件等），或未加密的关于VeraCrypt卷中文件系统的信息。

Note that Windows automatically records large amounts of potentially  sensitive data, such as the names and locations of files you open,  applications you run, etc. For example, Windows uses a set of Registry  keys known as “shellbags” to store the name, size, view, icon, and  position of a folder when using Explorer. Each time you open a folder, this information is updated including the  time and date of access. Windows Shellbags may be found in a few  locations, depending on operating system version and user profile. On a Windows XP system, shellbags may be found under **"HKEY_USERS\{USERID}\Software\Microsoft\Windows\Shell\"** and **"HKEY_USERS\{USERID}\Software\Microsoft\Windows\ShellNoRoam\"**. On a Windows 7 system, shellbags may be found under **"HEKY_USERS\{USERID}\Local Settings\Software\Microsoft\Windows\Shell\"**. More information available at https://www.sans.org/reading-room/whitepapers/forensics/windows-shellbag-forensics-in-depth-34545. 
请注意，Windows会自动记录大量潜在的敏感数据，例如您打开的文件的名称和位置，您运行的应用程序等。例如，Windows使用一组称为“shellbags”的注册表项来存储使用资源管理器时文件夹的名称，大小，视图，图标和位置。每次打开文件夹时，此信息都会更新，包括访问的时间和日期。根据操作系统版本和用户配置文件的不同，Windows Shellbags可能会出现在几个位置。在Windows XP系统上，可以在**“HKEY_USERS\{USERID}\Software\Microsoft\Windows\Shell\”**和**“HKEY_USERS\{USERID}\Software\Microsoft\Windows\ShellNoRoam\”**下找到shellbag。在Windows 7系统上，可以在**“HEKY_USERS\{USERID}\Local Settings\Software\Microsoft\Windows\Shell\”**下找到shellbag。更多信息请访问[https://www.sans。org/reading-room/whitepapers/forensics/windows-shellbag-forensics-in-depth-34545](https://www.sans.org/reading-room/whitepapers/forensics/windows-shellbag-forensics-in-depth-34545).

Also, starting from Windows 8, every time a VeraCrypt volume that is  formatted using NTFS is mounted, an Event 98 is written for the system  Events Log and it will contain the device name  (\\device\VeraCryptVolumeXX) of the volume. This event log "feature" was introduced in Windows 8 as part of newly introduced NTFS health  checks as explained [ here](https://blogs.msdn.microsoft.com/b8/2012/05/09/redesigning-chkdsk-and-the-new-ntfs-health-model/). To avoid this leak, the VeraCrypt volume must be mounted [ as a removable medium](https://veracrypt.fr/en/Removable Medium Volume.html). Big thanks to Liran Elharar for discovering this leak and its workaround.
此外，从Windows 8开始，每次挂载使用VRAM格式化的VeraCrypt卷时，都会在系统事件日志中写入事件98，其中包含卷的设备名称（\\device\VeraCryptVolumeXX）。此事件日志“功能” 在Windows 8中作为新引入的Windows运行状况检查的一部分引入， [这里](https://blogs.msdn.microsoft.com/b8/2012/05/09/redesigning-chkdsk-and-the-new-ntfs-health-model/).为了避免这种泄漏，VeraCrypt加密卷必须[作为可移动介质](https://veracrypt.fr/en/Removable Medium Volume.html)挂载。非常感谢Liran Elharar发现了这个漏洞及其解决方案。
 
 In order to prevent data leaks, you must follow these steps (alternative steps may exist):
为了防止数据泄露，您必须遵循以下步骤（可能存在替代步骤）：

- If you do 

  not

   need plausible deniability:

  
  如果你*不*需要合理的否认：

  - Encrypt the system partition/drive (for information on how to do so, see the chapter [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)) and ensure that only encrypted or read-only filesystems are mounted during each session in which you work with sensitive data.
    加密系统分区/驱动器（有关如何执行此操作的信息，请参阅 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)），并确保在处理敏感数据的每个会话期间只装载加密或只读文件系统。
     
     or,  或者，在一个实施例中，
  - If you cannot do the above, download or create a "live CD" version of your operating system (i.e. a "live" system entirely stored on and booted  from a CD/DVD) that ensures that any data written to the system volume  is written to a RAM disk. When you need to work with sensitive data, boot such a live CD/DVD and ensure that  only encrypted and/or read-only filesystems are mounted during the  session. 
    如果你不能做到以上几点，请下载或创建一个“live  CD”版本的操作系统（即一个完全存储在CD/DVD上并从CD/DVD引导的“live”系统），以确保写入系统卷的任何数据都写入RAM磁盘。当您需要处理敏感数据时，请靴子这样的活动CD/DVD，并确保在会话期间仅装载加密和/或只读文件系统。

- If you need plausible deniability:

  
  如果你需要合理的否认：

  - Create a hidden operating system. VeraCrypt will provide automatic data leak protection. For more information, see the section [ *Hidden Operating System*](https://veracrypt.fr/en/Hidden Operating System.html).
    创建隐藏的操作系统。VeraCrypt将提供自动数据泄漏保护。有关详细信息，请参阅 [*隐藏的操作系统*](https://veracrypt.fr/en/Hidden Operating System.html)。
     
     or,  或者，在一个实施例中，
  - If you cannot do the above, download or create a "live CD" version of your operating system (i.e. a "live" system entirely stored on and booted  from a CD/DVD) that ensures that any data written to the system volume  is written to a RAM disk. When you need to work with sensitive data, boot such a live CD/DVD. If you use hidden volumes, follow the security requirements and precautions listed in the subsection [ *Security Requirements and Precautions Pertaining to Hidden Volumes*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html). If you do not use hidden volumes, ensure that only non-system  partition-hosted VeraCrypt volumes and/or read-only filesystems are  mounted during the session. 
    如果你不能做到以上几点，请下载或创建一个“live CD”版本的操作系统（即一个完全存储在CD/DVD上并从CD/DVD引导的“live”系统），以确保写入系统卷的任何数据都写入RAM磁盘。当你需要 要处理敏感数据，请靴子这样的活动CD/DVD。如果使用隐藏卷，请遵循小节中列出的安全要求和预防措施 [*与隐藏的恶意软件有关的安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)。如果您不使用隐藏加密卷，请确保在会话期间只挂载非系统分区托管的VeraCrypt加密卷和/或只读文件系统。

# Paging File 分页文件

*Note: The issue described below does  **not** affect you if the system partition or system drive is encrypted (for more information, see the chapter [ System Encryption](https://veracrypt.fr/en/System Encryption.html)) and if all paging files are located on one or more of the partitions within the key scope of [ system encryption](https://veracrypt.fr/en/System Encryption.html), for example, on the partition where Windows is installed (for more information, see the fourth paragraph in this subsection**).*
*注意：如果系统分区或系统驱动器已加密（有关详细信息，请参阅"系统加密“一章），并且所有分页文件都位于系统加密密钥范围内的一个或多个分区上，例如，安装Windows的分区上（有关详细信息，请参阅本小节中的第四段**），则下面描述的问题不会影响您。*

Paging files, also called swap files, are used by Windows to hold parts  of programs and data files that do not fit in memory. This means that  sensitive data, which you believe are only stored in RAM, can actually  be written *unencrypted* to a hard drive by Windows without you knowing. 
分页文件，也称为交换文件，由Windows用来保存程序和数据文件中不适合内存的部分。这意味着您认为仅存储在RAM中的敏感数据实际上可以写入 在你不知情的情况下被*Windows加密*到硬盘上
 
 Note that VeraCrypt *cannot* prevent the contents of sensitive files that are opened in RAM from being saved *unencrypted* to a paging file (note that when you open a file stored on a VeraCrypt  volume, for example, in a text editor, then the content of the file is  stored *unencrypted* in RAM).
请注意，VeraCrypt*无法*阻止在RAM中打开的敏感文件的内容被保存 *未加密*的分页文件（请注意，当您打开存储在VeraCrypt卷上的文件时，例如，在文本编辑器中，文件的内容将被存储 在RAM中*未加密*）。

**To prevent the issues described above**, encrypt the system partition/drive (for information on how to do so, see the chapter [ System Encryption](https://veracrypt.fr/en/System Encryption.html)) and make sure that all paging files are located  on one or more of the partitions within the key scope of system  encryption (for example, on the partition where Windows is installed).  Note that the last condition is typically met on Windows XP by default. However, Windows Vista and later versions of Windows are configured by default to create paging files on any suitable volume.  Therefore, before, you start using VeraCrypt, you must follow these  steps: Right-click the '*Computer*' (or '*My Computer*') icon on the desktop or in the *Start Menu*, and then select  *Properties* > (on Windows Vista or later: > *Advanced System Settings* >)  *Advanced* tab > section *Performance* >  *Settings > Advanced* tab > section *Virtual memory* > *Change*. On Windows Vista or later, disable '*Automatically manage paging file size for all drives*'. Then make sure that the list of volumes available for paging file  creation contains only volumes within the intended key scope of system encryption (for  example, the volume where Windows is installed). To disable paging file  creation on a particular volume, select it, then select '*No paging file*' and click *Set*. When done, click  *OK* and restart the computer. 
**要防止出现上述问题**，请加密系统分区/驱动器（有关如何执行此操作的信息，请参阅 [系统加密](https://veracrypt.fr/en/System Encryption.html)），并确保所有分页文件都位于系统加密密钥范围内的一个或多个分区上（例如，安装Windows的分区上）。请注意，在Windows上通常满足最后一个条件 XP默认。但是，Windows Vista和更高版本的Windows默认配置为在任何合适的卷上创建分页文件。因此，在开始使用VeraCrypt之前，您必须遵循以下步骤：右键单击“*计算机*” (or“*我的电脑*”）图标， *开始菜单*，然后选择*属性*>（在Windows Vista或更高版本上：> *高级系统设置*>）*高级*选项卡>部分*性能*>*设置>高级*选项卡>部分*虚拟内存*>*更改*。在Windows Vista或更高版本上，禁用“*自动管理所有驱动器的分页文件大小*”。然后确保可用于创建分页文件的卷列表包含 仅在系统加密的预期密钥范围内的卷（例如，安装Windows的卷）。要在特定卷上禁用分页文件创建，请选择该卷，然后选择“*无分页文件*”并单击 集完成后，单击*确定*并重新启动计算机。

 *Note: You may also want to consider creating a hidden operating system (for more information, see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html))*.
*注意：您可能还需要考虑创建一个隐藏的操作系统（有关详细信息，请参阅[隐藏的操作系统一](https://veracrypt.fr/en/Hidden Operating System.html)节）*。

# Hibernation File 休眠文件

Note: The issue described below does not affect you if the system partition or system drive is encrypted* (for more information, see the chapter [ *System Encryption*](https://veracrypt.fr/en/System Encryption.html)) and if the hibernation file is located on one the partitions within the key scope of system encryption (which it typically is, by default), for example, on the partition where Windows is installed. When the computer hibernates, data are encrypted on the fly before they are written to the  hibernation file.
注意：如果系统分区或系统驱动器已加密*（有关详细信息，请参阅"[*系统加密“一*](https://veracrypt.fr/en/System Encryption.html)章），并且休眠文件位于系统加密密钥范围内的分区之一（默认情况下通常是这样），例如安装Windows的分区上，则下面描述的问题不会影响您。当计算机休眠时，数据在写入休眠文件之前被动态加密。

When a computer hibernates (or enters a power-saving mode), the content of  its system memory is written to a so-called hibernation file on the hard drive. You can configure VeraCrypt (*Settings* > *Preferences* > *Dismount all when: Entering power saving mode*) to automatically dismount all mounted VeraCrypt volumes, erase their  master keys stored in RAM, and cached passwords (stored in RAM), if  there are any, before a computer hibernates (or enters a power-saving mode). However, keep in mind, that if you do  not use system encryption (see the chapter [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)), VeraCrypt still cannot reliably prevent the contents of sensitive files opened in RAM from being saved unencrypted to a hibernation file. Note  that when you open a file stored on a VeraCrypt volume, for example, in a  text editor, then the content of the file is stored unencrypted in RAM  (and it may remain unencrypted in RAM until the computer is turned off).
当计算机休眠（或进入省电模式）时，其系统内存的内容被写入硬盘驱动器上的所谓休眠文件。您可以配置VeraCrypt（*设置*> *参数设置*>*全部卸载：进入省电模式*）在电脑休眠前自动卸载所有已安装的VeraCrypt加密卷，清除存储在RAM中的主密钥和缓存密码（存储在RAM中）（如果有的话） (or进入节电模式）。然而，请记住，如果您不使用系统加密（请参阅本章 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)），VeraCrypt仍然不能可靠地防止在RAM中打开的敏感文件的内容被保存为未加密的休眠文件。注意 当您打开一个存储在VeraCrypt加密卷上的文件时，例如，在文本编辑器中，文件的内容将以未加密的方式存储在RAM中（并且在计算机关闭之前，它可能会一直保持未加密的状态）。
 
 Note that when Windows enters Sleep mode, it may be actually configured  to enter so-called Hybrid Sleep mode, which involves hibernation. Also  note that the operating system may be configured to hibernate or enter  the Hybrid Sleep mode when you click or select "Shut down" (for more information, please see the documentation for  your operating system).
请注意，当Windows进入睡眠模式时，它实际上可能被配置为进入所谓的混合睡眠模式，其中涉及休眠。还请注意，操作系统可能会配置为休眠或进入混合睡眠模式，当您单击或选择 “关闭”（有关详细信息，请参阅操作系统的文档）。
 
 **To prevent the issues described above**, encrypt the system partition/drive (for information on how to do so, see the chapter [*System Encryption*](https://veracrypt.fr/en/System Encryption.html)) and make sure that the hibernation file is located on one of the  partitions within the key scope of system encryption (which it typically is, by default), for example, on the partition where Windows is installed. When the  computer hibernates, data will be encrypted on the fly before they are  written to the hibernation file.
**要防止出现上述问题**，请加密系统分区/驱动器（有关如何执行此操作的信息，请参阅 [*系统加密*](https://veracrypt.fr/en/System Encryption.html)），并确保休眠文件位于系统加密密钥范围内的一个分区上（默认情况下通常是这样）， 例如，在安装Windows的分区上。当计算机休眠时，数据将在写入休眠文件之前进行动态加密。

Note: You may also want to consider creating a hidden operating system (for more information, see the section [ *Hidden Operating System*](https://veracrypt.fr/en/Hidden Operating System.html)).
注意：您可能还需要考虑创建一个隐藏的操作系统（有关详细信息，请参阅 [隐藏*的操作系统*](https://veracrypt.fr/en/Hidden Operating System.html)）。

Alternatively, if you cannot use system encryption, disable or prevent hibernation on  your computer at least for each session during which you work with any  sensitive data and during which you mount a VeraCrypt volume.
或者，如果您无法使用系统加密，请至少在您处理任何敏感数据以及装载VeraCrypt卷的每个会话期间禁用或阻止计算机休眠。

\* Disclaimer: As Windows XP and Windows 2003 do not provide any API for encryption of hibernation files, VeraCrypt has to modify undocumented components of  Windows XP/2003 in order to allow users to encrypt hibernation files.  Therefore, VeraCrypt cannot guarantee that Windows XP/2003 hibernation files will always be  encrypted. In response to our public complaint regarding the missing  API, Microsoft began providing a public API for encryption of  hibernation files on Windows Vista and later versions of Windows. VeraCrypt has used this API and therefore is able to safely encrypt hibernation files under Windows Vista and later versions of  Windows. Therefore, if you use Windows XP/2003 and want the hibernation  file to be safely encrypted, we strongly recommend that you upgrade to Windows Vista or later.
\* 免责声明：由于Windows XP和Windows 2003不提供任何API来加密休眠文件，VeraCrypt不得不修改Windows  XP/2003中未记录的组件，以允许用户加密休眠文件。因此，VeraCrypt不能保证Windows  XP/2003休眠文件总是被加密。为了回应我们关于丢失API的公开投诉，微软开始提供一个公共API，用于在Windows  Vista和更高版本的Windows上加密休眠文件。VeraCrypt已经使用了这个API，因此能够在Windows  Vista和更高版本的Windows下安全地加密休眠文件。因此，如果您使用的是Windows  XP/2003，并且希望安全地加密休眠文件，我们强烈建议您升级到Windows Vista或更高版本。

# Memory Dump Files 内存转储文件

*Note: The issue described below does  **not** affect you if the system partition or system drive is encrypted (for more information, see the chapter [ System Encryption](https://veracrypt.fr/en/System Encryption.html)) and if the system is configured to write memory dump files to the system drive (which it typically is, by default).
注意：如果系统分区或系统驱动器已加密，则以下描述的问题**不会**影响您（有关详细信息，请参阅 [系统加密](https://veracrypt.fr/en/System Encryption.html)）以及系统是否配置为将内存转储文件写入系统驱动器（默认情况下通常如此）。*

Most operating systems, including Windows, can be configured to write  debugging information and contents of the system memory to so-called  memory dump files (also called crash dump files) when an error occurs  (system crash, "blue screen," bug check). Therefore, memory dump files may contain sensitive data. VeraCrypt  *cannot* prevent cached passwords, encryption keys, and the contents of sensitive files opened in RAM from being saved *unencrypted* to memory dump files. Note that when you open a file stored on a  VeraCrypt volume, for example, in a text editor, then the content of the file is stored *unencrypted* in RAM (and it may remain  *unencrypted* in RAM until the computer is turned off). Also note that when a VeraCrypt volume is mounted, its master key is stored *unencrypted* in RAM. Therefore, you must disable memory dump file generation on your computer at least for each session during which you work with any  sensitive data and during which you mount a VeraCrypt volume. To do so  in Windows XP or later, right-click the '*Computer*' (or '*My Computer*') icon on the desktop or in the *Start Menu*, and then select  *Properties* > (on Windows Vista or later: >  *Advanced System Settings* >) *Advanced* tab > section *Startup and Recovery* >  *Settings >* section *Write debugging information* > select *(none)* >  *OK*.
大多数操作系统，包括Windows，都可以配置为在发生错误（系统崩溃、“蓝屏”、错误检查）时将调试信息和系统内存的内容写入所谓的内存转储文件（也称为崩溃转储文件）。因此，内存转储文件可能包含敏感数据。VeraCrypt*无法*阻止保存缓存的密码、加密密钥和在RAM中打开的敏感文件的内容 *未加密*的内存转储文件。请注意，当您打开存储在VeraCrypt加密卷上的文件时，例如，在文本编辑器中，文件的内容将被存储 在RAM中*未加密*（并且它可能在RAM中保持*未加密状态，*直到计算机关闭）。另外请注意，当VeraCrypt加密卷被挂载时，它的主密钥会被存储 RAM中*未加密*。因此，您必须至少在每次使用敏感数据和挂载VeraCrypt加密卷的会话中禁用内存转储文件生成功能。要在Windows XP或更高版本中执行此操作，请右键单击桌面上或 *开始菜单*，然后选择*属性*>（在Windows Vista或更高版本上：>*高级系统设置*>）*高级*选项卡>部分 *启动和恢复*>*设置>*部分*写入调试信息*>选择*（无）*>*确定*。

*Note for users of Windows XP/2003*: As Windows XP and Windows 2003 do not provide any API for encryption of memory dump files, if the system partition/drive is encrypted by  VeraCrypt and your Windows XP system is configured to write memory dump files to the system drive, the VeraCrypt driver  automatically prevents Windows from writing any data to memory dump  files*.*
*Windows XP/2003用户注意*：由于Windows XP和Windows 2003不提供任何API来加密内存转储文件，如果系统分区/驱动器被VeraCrypt加密，并且您的Windows  XP系统被配置为将内存转储文件写入系统驱动器，VeraCrypt驱动程序会自动阻止Windows将任何数据写入内存转储文件*。*

# Unencrypted Data in RAM RAM中的未加密数据

It is important to note that VeraCrypt is *disk* encryption software, which encrypts only disks, not RAM (memory).
需要注意的是，VeraCrypt是*磁盘*加密软件，它只加密磁盘，而不加密RAM（内存）。

Keep in mind that most programs do not clear the memory area (buffers)  in which they store unencrypted (portions of) files they load from a  VeraCrypt volume. This means that after you exit such a program,  unencrypted data it worked with may remain in memory (RAM) until the computer is turned off (and, according to some  researchers, even for some time after the power is turned off*). Also  note that if you open a file stored on a VeraCrypt volume, for example,  in a text editor and then force dismount on the VeraCrypt volume, then the file will remain unencrypted in the area of memory  (RAM) used by (allocated to) the text editor. This also applies to  forced auto-dismount.
请记住，大多数程序不会清除存储从VeraCrypt加密卷加载的未加密文件的内存区域（缓冲区）。这意味着，退出此类程序后，它所处理的未加密数据可能会保留在内存（RAM）中，直到计算机关闭（根据一些研究人员的说法，甚至在电源关闭后的一段时间内  *）。另外请注意，如果您打开一个存储在VeraCrypt加密卷上的文件，例如，在一个文本编辑器中，然后在VeraCrypt加密卷上强制解密，那么该文件将在文本编辑器使用（分配给）的内存区域（RAM）中保持未加密状态。这也适用于强制自动重定向。

Inherently, unencrypted master keys have to be stored in RAM too. When a non-system VeraCrypt volume is dismounted, VeraCrypt erases its master  keys (stored in RAM). When the computer is cleanly restarted (or cleanly shut down), all non-system VeraCrypt volumes are automatically dismounted and, thus, all master keys stored in RAM  are erased by the VeraCrypt driver (except master keys for system  partitions/drives — see below). However, when power supply is abruptly  interrupted, when the computer is reset (not cleanly restarted), or when the system crashes,  **VeraCrypt naturally stops running and therefore cannot** erase  any keys or any other sensitive data. Furthermore, as Microsoft does not provide any appropriate API for handling hibernation and shutdown,  master keys used for system encryption cannot be reliably (and are not) erased from RAM when the computer hibernates, is shut down or restarted.**
本质上，未加密的主密钥也必须存储在RAM中。当一个非系统VeraCrypt加密卷被删除时，VeraCrypt会删除它的主密钥（存储在RAM中）。当计算机完全重启（或完全关机）时，所有非系统VeraCrypt卷都会被自动删除，因此，存储在RAM中的所有主密钥都会被VeraCrypt驱动程序删除（系统分区/驱动器的主密钥除外-见下文）。然而，当电源突然中断，当计算机被重置（不是干净地重新启动），或当系统崩溃时，**VeraCrypt会自然停止运行，因此无法**删除任何密钥或任何其他敏感数据。此外，由于Microsoft没有提供任何适当的API来处理休眠和关机，因此当计算机休眠、关机或重新启动时，用于系统加密的主密钥无法可靠地（并且不会）从RAM中删除。

Starting from version 1.24, VeraCrypt introduces a mechanism to encrypt  master keys and cached passwords in RAM. This RAM encryption mechanism  must be activated manually in "Performance/Driver Configuration" dialog. RAM encryption comes with a performance overhead (between 5% and 15%  depending on the CPU speed) and it disables Windows hibernate. 
从1.24版开始，VeraCrypt引入了一种机制来加密主密钥和RAM中的缓存密码。此RAM加密机制必须在“性能/驱动程序配置”对话框中手动激活。RAM加密会带来性能开销（取决于CPU速度，在5%到15%之间），并且它会禁用Windows休眠。
 Moreover, VeraCrypt 1.24 and above provide an additional security  mechanism when system encryption is used that makes VeraCrypt erase  master keys from RAM when a new device is connected to the PC. This  additional mechanism can be activated using an option in System Settings dialog.
此外，VeraCrypt 1.24及以上版本在使用系统加密时提供了额外的安全机制，当新设备连接到PC时，VeraCrypt会从RAM中删除主密钥。可以使用系统设置对话框中的选项激活此附加机制。
 Even though both above mechanisms provides strong protection for  masterskeys and cached password, users should still take usual  precautions related for the safery of sensitive data in RAM.
尽管上述两种机制都为主密钥和缓存密码提供了强大的保护，但用户仍然应该采取与RAM中敏感数据安全相关的常规预防措施。

To summarize, VeraCrypt **cannot** and does  **not** ensure that RAM contains no sensitive data (e.g. passwords, master keys, or decrypted data). Therefore, after each session in which you work with a VeraCrypt volume or in which an encrypted operating  system is running, you must shut down (or, if the [ hibernation file](https://veracrypt.fr/en/Hibernation File.html) is [ encrypted](https://veracrypt.fr/en/System Encryption.html), hibernate) the computer and then leave it powered off for at least several minutes (the longer, the better) before turning it on  again. This is required to clear the RAM (also see the section [ Hibernation File](https://veracrypt.fr/en/Hibernation File.html)). 总而言之，VeraCrypt**不能**也**不会**确保RAM中不包含敏感数据（例如密码、主密钥或解密数据）。因此，在每次使用VeraCrypt加密卷或运行加密操作系统的会话后，您必须关闭计算机（或者，如果[休眠文件](https://veracrypt.fr/en/Hibernation File.html)是[加密的](https://veracrypt.fr/en/System Encryption.html)，则休眠），然后在重新打开计算机之前关闭计算机至少几分钟（时间越长越好）。这是清除RAM所必需的（另请参见 [休眠文件](https://veracrypt.fr/en/Hibernation File.html)）。

 

------

\* Allegedly, for 1.5-35 seconds under normal operating temperatures  (26-44 °C) and up to several hours when the memory modules are cooled  (when the computer is running) to very low temperatures (e.g. -50 °C). New types of memory modules allegedly exhibit a much  shorter decay time (e.g. 1.5-2.5 seconds) than older types (as of 2008).
\* 在正常工作温度（26-44 °C）下，持续时间为1.5-35秒，当内存模块冷却（计算机运行时）至非常低的温度（例如-50 °C）时，持续时间长达数小时。据称，新类型的存储器模块表现出比旧类型（截至2008年）更短的衰减时间（例如1.5-2.5秒）。
 ** Before a key can be erased from RAM, the corresponding VeraCrypt volume must be dismounted. For non-system volumes, this does not cause any  problems. However, as Microsoft currently does not provide any appropriate API for handling the final phase of the system  shutdown process, paging files located on encrypted system volumes that  are dismounted during the system shutdown process may still contain  valid swapped-out memory pages (including portions of Windows system files). This could cause 'blue screen' errors.  Therefore, to prevent 'blue screen' errors, VeraCrypt does not dismount  encrypted system volumes and consequently cannot clear the master keys  of the system volumes when the system is shut down or restarted.
**  在从RAM中删除密钥之前，必须先删除相应的VeraCrypt加密卷。对于非系统卷，这不会导致任何问题。但是，由于Microsoft目前没有提供任何适当的API来处理系统关闭过程的最后阶段，因此在系统关闭过程中被删除的加密系统卷上的分页文件可能仍然包含有效的换出内存页面（包括Windows系统文件的部分）。这可能会导致“蓝屏”错误。因此，为了防止“蓝屏”错误，VeraCrypt不会解密加密的系统卷，因此在系统关闭或重新启动时无法清除系统卷的主密钥。

# VeraCrypt Memory Protection Mechanism VeraCrypt内存保护机制

## Introduction 介绍

VeraCrypt always strives to enhance user experience while maintaining the highest level of security. The memory protection mechanism is one such security feature. However, understanding the need for accessibility, we have  also provided an option to disable this mechanism for certain users.  This page provides in-depth information on both.
VeraCrypt始终致力于在保持最高安全级别的同时提升用户体验。存储器保护机制就是这样一种安全特征。然而，理解对可访问性的需求，我们还提供了一个选项来为某些用户禁用此机制。本页提供了关于两者的深入信息。

## Memory Protection Mechanism: An Overview 内存保护机制综述

The memory protection mechanism ensures that non-administrator processes are prohibited from accessing the VeraCrypt process memory. This serves two primary purposes: 
内存保护机制确保禁止非管理员进程访问VeraCrypt进程内存。这有两个主要目的：

- Security Against Malicious Activities: The mechanism prevents non-admin  processes from injecting harmful data or code inside the VeraCrypt  process.
  防止恶意活动：该机制防止非管理员进程向VeraCrypt进程中注入有害数据或代码。
- Protection of Sensitive Data: Although VeraCrypt is designed to not leave  sensitive data in memory, this feature offers an extra layer of  assurance by ensuring other non-admin processes cannot access or extract potentially sensitive information.
  敏感数据的保护：虽然VeraCrypt的设计目的是不将敏感数据留在内存中，但此功能通过确保其他非管理进程无法访问或提取潜在的敏感信息，提供了额外的保证。



## Why Introduce An Option To Disable Memory Protection? 为什么要引入一个选项来禁用内存保护？

​	Some accessibility tools, like screen readers, require access to a  software's process memory to effectively interpret and interact with its user interface (UI). VeraCrypt's memory protection unintentionally  hindered the functioning of such tools. To ensure that users relying on  accessibility tools can still use VeraCrypt without impediments, we  introduced this option. 
某些辅助工具（如屏幕阅读器）需要访问软件的进程内存，以有效地解释其用户界面（UI）并与之交互。VeraCrypt的内存保护无意中阻碍了这些工具的运行。为了确保依赖辅助工具的用户仍然可以毫无障碍地使用VeraCrypt，我们引入了这个选项。

## How to Enable/Disable the Memory Protection Mechanism? 如何启用/禁用内存保护机制？

​	By default, the memory protection mechanism is enabled. However, you  can disable through VeraCrypt main UI or during installation. 
默认情况下，内存保护机制处于启用状态。但是，您可以通过VeraCrypt主界面或在安装过程中禁用。

1. During installation: 		

    安装期间：

   - In the setup wizard, you'll encounter the **"Disable memory protection for Accessibility tools compatibility"** checkbox.
     在安装向导中，您将遇到**“禁用内存保护以兼容辅助工具”**复选框。
   - Check the box if you want to disable the memory protection. Leave it unchecked to keep using memory protection.
     如果要禁用内存保护，请选中此框。保持未选中状态以继续使用内存保护。
   - Proceed with the rest of the installation.
     继续安装的其余部分。

2. Post-Installation: 		

    安装后：

   - Open VeraCrypt main UI and navigate to the menu Settings -> "Performance/Driver Configuration".
     打开VeraCrypt主界面，导航到菜单设置->“性能/驱动程序配置”.
   - Locate and check/uncheck the **"Disable memory protection for Accessibility tools compatibility"** option as per your needs. You will be notified that an OS reboot is required for the change to take effect.
     根据您的需要找到并选中/取消选中**“禁用内存保护以兼容辅助工具”**选项。系统将通知您需要重新启动操作系统才能使更改生效。
   - Click **OK**. 单击“**确定”（**OK）。

3. During Upgrade or Repair/Reinstall 		

   
   在升级或维修/升级期间

   - In the setup wizard, you'll encounter the **"Disable memory protection for Accessibility tools compatibility"** checkbox.
     在安装向导中，您将遇到**“禁用内存保护以兼容辅助工具”**复选框。
   - Check/uncheck the **"Disable memory protection for Accessibility tools compatibility"** option as per your needs.
     根据您的需要选中/取消选中**“禁用内存保护以实现辅助功能工具兼容性”**选项。
   - Proceed with the rest of the upgrade or repair/reinstall.
     继续升级或修复/重新安装的其余部分。
   - You will be notified that an OS reboot is required if you have changed the memory protection setting.
     如果您更改了内存保护设置，系统将通知您需要重新启动操作系统。

## Risks and Considerations 风险和考虑

While disabling the memory protection mechanism can be essential for some users, it's crucial to understand the risks: 
虽然禁用内存保护机制对某些用户来说是必不可少的，但了解风险至关重要：

- **Potential Exposure:** Disabling the mechanism could expose the VeraCrypt process memory to malicious processes.
  **潜在暴露：**禁用该机制可能会将VeraCrypt进程内存暴露给恶意进程。
- **Best Practice:** If you don't require accessibility tools to use VeraCrypt, it's recommended to leave the memory protection enabled.
  **最佳实践：**如果您不需要辅助工具来使用VeraCrypt，建议您启用内存保护。



## FAQ

​	**Q: What is the default setting for the memory protection mechanism?
问：内存保护机制的默认设置是什么？**
 **A:** The memory protection mechanism is enabled by default. 
**答：**默认情况下，内存保护机制是启用的。

​	**Q: How do I know if the memory protection mechanism is enabled or disabled?
问：如何知道内存保护机制是否已启用或禁用？**
 **A:** You can check the status of the memory protection mechanism in the  VeraCrypt main UI. Navigate to the menu Settings ->  "Performance/Driver Configuration". If the **"Disable memory protection for Accessibility tools compatibility"** option is checked, the memory protection mechanism is disabled. If the  option is unchecked, the memory protection mechanism is enabled. 
**A：**您可以在VeraCrypt主界面查看内存保护机制的状态。导航到菜单设置->“性能/驱动程序配置”。如果勾选**“Disable memory protection for Accessibility tools compatibility”**选项，则内存保护机制将被禁用。如果未选中该选项，则启用内存保护机制。

​	**Q: Will disabling memory protection reduce the encryption strength of VeraCrypt?
Q：禁用内存保护会降低VeraCrypt的加密强度吗？**
 **A:** No, the encryption algorithms and their strength remain the same. Only  the protection against potential memory snooping and injection by  non-admin processes is affected. 
**答：**不，加密算法及其强度保持不变。只有防止潜在的内存窥探和非管理进程注入的保护受到影响。

​	**Q: I don't use accessibility tools. Should I disable this feature?
问：我不使用辅助工具。我应该禁用此功能吗？**
 **A:** No, it's best to keep the memory protection mechanism enabled for added security. 
**答：**不，最好保持内存保护机制启用，以增加安全性。

# VeraCrypt RAM加密机制

## Introduction 介绍

​    VeraCrypt RAM Encryption aims to protect disk encryption keys stored in volatile memory against certain types of attacks. The primary  objectives of this mechanism are:    
VeraCrypt RAM Encryption旨在保护存储在易失性存储器中的磁盘加密密钥免受某些类型的攻击。该机制的主要目标是：

- To protect against cold boot attacks.
  防止冷靴子袭击。
- To add an obfuscation layer to significantly complicate the recovery of  encryption master keys from memory dumps, be it live or offline.
  添加一个模糊处理层，使从内存转储中恢复加密主密钥的过程变得非常复杂，无论是实时还是离线。



### Implementation Overview 实施概述

Here's a summary of how RAM encryption is achieved:
以下是如何实现RAM加密的摘要：

1. At Windows startup, the VeraCrypt driver allocates a 1MiB memory region.  If this fails, we device the size by two until allocation succeeds  (minimal size being 8KiB). All these variables are allocated in  non-paged Kernel memory space.
   在Windows启动时，VeraCrypt驱动程序会分配一个1MiB的内存区域。如果这失败了，我们就将大小设为2，直到分配成功（最小大小为8KiB）。所有这些变量都分配在非分页内核内存空间中。
2. This memory region is then populated with random bytes generated by a CSPRNG based on ChaCha20.
   然后，该存储器区域填充有由CSPRNG基于ChaCha20生成的随机字节。
3. Two random 64-bit integers, `HashSeedMask` and `CipherIVMask`, are generated.
   生成两个随机的64位整数`HashSeedMask`和`CipherIVMask`。
4. For every master key of a volume, the RAM encryption algorithm derives a  unique key from a combination of the memory region and unique values  extracted from the memory to be encrypted. This ensures a distinct key  for each encrypted memory region. The use of location-dependent keys and IVs prevents master keys from being easily extracted from memory dumps.
   对于卷的每个主密钥，RAM加密算法从存储器区域和从要加密的存储器提取的唯一值的组合中导出唯一密钥。这确保了每个加密的存储器区域的不同密钥。使用与位置相关的密钥和IV可以防止从内存转储中轻松提取主密钥。
5. The master keys are decrypted for every request, requiring a fast decryption algorithm. For this, ChaCha12 is utilized.
   每次请求都要解密主密钥，这需要快速解密算法。为此，ChaCha 12被使用。
6. Once a volume is mounted, its master keys are immediately encrypted using the described algorithm.
   一旦卷被装载，其主密钥立即使用所描述的算法加密。
7. For each I/O request for a volume, the master keys are decrypted only for the duration of that request and then securely wiped.
   对于卷的每个I/O请求，主密钥仅在该请求的持续时间内解密，然后安全地擦除。
8. Upon volume dismounting, the encrypted master keys are securely removed from memory.
   在卷加密时，加密的主密钥被安全地从存储器中移除。
9. At Windows shutdown or reboot, the memory region allocated during startup is securely wiped.
   在Windows关机或重新启动时，启动期间分配的内存区域将被安全擦除。

### Protection against Cold Boot Attacks 防止冷靴子攻击

​    The mitigation of cold boot attacks is achieved by utilizing a large memory page for key derivation. This ensures that attackers cannot  recover the master key since parts of this large memory area would  likely be corrupted and irrecoverable after shutdown. Further details on cold boot attacks and mitigation techniques can be found in the  referenced papers: 
冷靴子攻击的缓解是通过利用大的存储器页面进行密钥导出来实现的。这确保了攻击者无法恢复主密钥，因为这个大内存区域的一部分可能会在关机后损坏和无法恢复。有关冷靴子攻击和缓解技术的更多详细信息，请参阅参考文献：

- [Cold Boot Attacks (BlackHat)
  冷靴子攻击（BlackHat）](https://www.blackhat.com/presentations/bh-usa-08/McGregor/BH_US_08_McGregor_Cold_Boot_Attacks.pdf)
- [RAM Hijacks 内存劫持](https://www.grc.com/sn/files/RAM_Hijacks.pdf)

### Incompatibility with Windows Hibernate and Fast Startup 与Windows Hibernate和Fast Startup不兼容

​	RAM Encryption in VeraCrypt is not compatible with the Windows  Hibernate and Fast Startup features. Before activating RAM Encryption,  these features will be disabled by VeraCrypt to ensure the security and  functionality of the encryption mechanism. 
VeraCrypt中的RAM加密与Windows休眠和快速启动功能不兼容。在激活RAM加密之前，VeraCrypt将禁用这些功能，以确保加密机制的安全性和功能性。

### Algorithm Choices 算法选择

​    The choice of algorithms was based on a balance between security and performance: 
算法的选择基于安全性和性能之间的平衡：

- **t1ha2:** A non-cryptographic hash function chosen for its impressive speed and  ability to achieve GiB/s hashing rates. This is vital since keys are  derived from a 1MB memory region for every encryption/decryption  request. It also respects the strict avalanche criteria which is crucial for this use case.
  **t1 ha 2：**一个非加密哈希函数，因为它令人印象深刻的速度和实现GiB/s哈希率的能力而被选中。这是至关重要的，因为密钥是从每个加密/解密请求的1 MB内存区域中导出的。它还遵守严格的雪崩标准，这对该用例至关重要。
- **ChaCha12:** Chosen over ChaCha20 for performance reasons, it offers sufficient  encryption strength while maintaining fast encryption/decryption speeds.
  **ChaCha 12：**由于性能原因而选择ChaCha 20，它提供了足够的加密强度，同时保持了快速的加密/解密速度。

### Key Algorithms 关键算法

​    Two core algorithms are fundamental to the RAM encryption process: [                                          ](javascript:void(0))

[                      重试                                           ](javascript:void(0))

[                      错误原因                           ](javascript:void(0))

#### 1. VcGetEncryptionID[                                          ](javascript:void(0))

#### [                      重试                                           ](javascript:void(0))

#### [                      错误原因                           ](javascript:void(0))

​    Computes a unique ID for the RAM buffer set to be encrypted. [                                          ](javascript:void(0))

[                      重试                                           ](javascript:void(0))

[                      错误原因                           ](javascript:void(0))

```
    - Input: pCryptoInfo, a CRYPTO_INFO variable to encrypt/decrypt
    - Output: A 64-bit integer identifying the pCryptoInfo variable
    - Steps:
      - Compute the sum of the virtual memory addresses of the fields ks and ks2 of pCryptoInfo: encID = ((uint64) pCryptoInfo->ks) + ((uint64) pCryptoInfo->ks2)
      - Return the result
    
```

#### 2. VcProtectMemory[                                          ](javascript:void(0))

#### [                      重试                                           ](javascript:void(0))

#### [                      错误原因                           ](javascript:void(0))

​    Encrypts the RAM buffer using the unique ID generated by VcGetEncryptionID. [                                          ](javascript:void(0))

[                      重试                                           ](javascript:void(0))

[                      错误原因                           ](javascript:void(0))

```
    - Input:
      - encID, unique ID for memory to be encrypted
      - pbData, pointer to the memory to be encrypted
      - pbKeyDerivationArea, memory area allocated by the driver at startup
      - HashSeedMask and CipherIVMask, two 64-bit random integers from startup
    - Output:
      - None; memory at pbData is encrypted in place
    - Steps:
      - Derive hashSeed: hashSeed = (((uint64) pbKeyDerivationArea) + encID) ^ HashSeedMask
      - Compute 128-bit hash: hash128 = t1h2 (pbKeyDerivationArea,hashSeed). 
      - Decompose hash128 into two 64-bit integers: hash128 = hash128_1 || hash128_2
      - Create a 256-bit key for ChaCha12: chachaKey = hash128_1 || hash128_2 || (hash128_1 OR hash128_2) || (hash128_1 + hash128_2)
      - Encrypt chachaKey by itself using ChaCha12 using hashSeed as an IV: ChaCha256Encrypt (chachaKey, hashSeed, chachaKey)
      - Derive the 64-bit IV for ChaCha12: chachaIV = (((uint64) pbKeyDerivationArea) + encID) ^ CipherIVMask
      - Encrypt memory at pbData using ChaCha12: ChaCha256Encrypt (chachaKey, chachaIV, pbData)
      - Securely erase temporary values
    
```

​    It's important to note that, due to ChaCha12 being a stream cipher,  encryption and decryption processes are identical, and the `VcProtectMemory` function can be used for both. [                                          ](javascript:void(0))

[                      重试                                           ](javascript:void(0))

[                      错误原因                           ](javascript:void(0))

​    For a deeper understanding and a look into the codebase, one can  visit the VeraCrypt repository and explore the mentioned functions in  the `src/Common/Crypto.c` file. [                                          ](javascript:void(0))

[                      重试                                           ](javascript:void(0))

[                      错误原因                           ](javascript:void(0))

### Additional Security Measures[                                          ](javascript:void(0))

### [                      重试                                           ](javascript:void(0))

### [                      错误原因                           ](javascript:void(0))

​    Starting from version 1.24, VeraCrypt has integrated a mechanism  that detects the insertion of new devices into the system when System  Encryption is active. If a new device is inserted, master keys are  immediately purged from memory, resulting in a Windows BSOD. This  protects against attacks using specialized devices to extract memory  from running systems. However, for maximum efficiency, this feature  should be paired with RAM encryption.
从1.24版开始，VeraCrypt集成了一种机制，当系统加密激活时，可以检测到新设备插入系统。如果插入新设备，主密钥将立即从内存中清除，从而导致Windows BSOD。这可以防止使用专用设备从运行的系统中提取内存的攻击。但是，为了最大限度地提高效率，此功能应与RAM加密配对。
 To enable this feature, navigate to the menu System -> Settings and check the **"Clear encryption keys from memory if a new device is inserted"** option. 
要启用此功能，请导航到菜单“系统->设置”并选中**“如果插入新设备，则从内存中清除加密密钥”**选项。

### Technical Limitations with Hibernation and Fast Startup 休眠和快速启动的技术限制

The Windows Hibernate and Fast Startup features save the content of RAM  to the hard drive. In the context of VeraCrypt's RAM Encryption,  supporting these features presents a significant challenge, namely a  chicken-egg problem.
Windows休眠和快速启动功能将RAM的内容保存到硬盘驱动器。在VeraCrypt的RAM加密背景下，支持这些功能提出了一个重大挑战，即鸡与蛋的问题。
 To maintain security, the large memory region used for key derivation in RAM Encryption would have to be stored in an encrypted format, separate from the usual VeraCrypt encryption applied to the current drive. This  separate encrypted storage must also be unlockable using the same  password as the one used for Pre-Boot Authentication. Moreover, this  process must happen early in the boot sequence before filesystem access  is available, necessitating the raw storage of encrypted data in  specific sectors of a different disk.
为了保持安全性，RAM加密中用于密钥导出的大内存区域必须以加密格式存储，与应用于当前驱动器的通常VeraCrypt加密分开。此单独的加密存储还必须使用与用于预引导身份验证的密码相同的密码解锁。此外，这个过程必须在靴子序列的早期发生，然后才能访问文件系统，这就需要将加密数据原始存储在不同磁盘的特定扇区中。
 While this is technically feasible, the complexity and  user-unfriendliness of such a solution make it impractical for standard  deployments. Therefore, enabling RAM Encryption necessitates the  disabling of the Windows Hibernate and Fast Startup features.
虽然这在技术上是可行的，但这种解决方案的复杂性和用户不友好性使其对于标准部署来说不切实际。因此，启用RAM加密需要禁用Windows休眠和快速启动功能。

# Physical Security 物理安全

If an attacker can physically access the computer hardware  **and** you use it after the attacker has physically accessed it,  then VeraCrypt may become unable to secure data on the computer.* This  is because the attacker may modify the hardware or attach a malicious  hardware component to it (such as a hardware keystroke logger) that will capture the password or encryption key  (e.g. when you mount a VeraCrypt volume) or otherwise compromise the  security of the computer. Therefore, you must not use VeraCrypt on a  computer that an attacker has physically accessed. Furthermore, you must ensure that VeraCrypt (including its device  driver) is not running when the attacker physically accesses the  computer. Additional information pertaining to hardware attacks where  the attacker has direct physical access is contained in the section [ Unencrypted Data in RAM](https://veracrypt.fr/en/Unencrypted Data in RAM.html).
如果攻击者可以物理访问计算机硬件**，而**您在攻击者物理访问之后使用它，那么VeraCrypt可能无法保护计算机上的数据。*这是因为攻击者可能会修改硬件或附加恶意硬件组件（例如硬件恶意日志记录器），以捕获密码或加密密钥（例如当您安装VeraCrypt卷时）或以其他方式危及计算机的安全性。因此，您不能在攻击者物理访问过的计算机上使用VeraCrypt。此外，您必须确保当攻击者物理访问计算机时VeraCrypt（包括其设备驱动程序）没有运行。有关攻击者具有直接物理访问权限的硬件攻击的其他信息包含在[RAM中的未加密数据](https://veracrypt.fr/en/Unencrypted Data in RAM.html)部分中。

Furthermore, even if the attacker cannot physically access the computer hardware  *directly*, he or she may be able to breach the physical security of  the computer by remotely intercepting and analyzing emanations from the  computer hardware (including the monitor and cables). For example,  intercepted emanations from the cable connecting the keyboard with the computer can reveal passwords you type. It is  beyond the scope of this document to list all of the kinds of such  attacks (sometimes called TEMPEST attacks) and all known ways to prevent them (such as shielding or radio jamming). It is your responsibility to prevent such attacks. If you do not, VeraCrypt  may become unable to secure data on the computer.
此外，即使攻击者不能*直接*物理访问计算机硬件，他或她也可以通过远程拦截和分析来自计算机硬件（包括监视器和电缆）的辐射来破坏计算机的物理安全。例如，从连接键盘和计算机的电缆上截取的辐射可以泄露你输入的密码。列出所有类型的此类攻击（有时称为TEMPEST攻击）以及所有已知的预防方法（例如屏蔽或无线电干扰）超出了本文的范围。你有责任阻止这种攻击。如果您不这样做，VeraCrypt可能无法保护计算机上的数据。



------

\* In this section (*Physical Security*), the phrase "data on the computer" means data on internal and external storage devices/media (including removable devices and network drives) connected to the computer.
\* 在本节（*物理安全*）中，短语“计算机上的数据”是指连接到计算机的内部和外部存储设备/介质（包括可移动设备和网络驱动器）上的数据。

# Malware 恶意软件

The term 'malware' refers collectively to all types of malicious  software, such as computer viruses, Trojan horses, spyware, or generally any piece of software (including VeraCrypt or an operating system  component) that has been altered, prepared, or can be controlled, by an attacker. Some kinds of malware are designed e.g. to  log keystrokes, including typed passwords (such captured passwords are  then either sent to the attacker over the Internet or saved to an  unencrypted local drive from which the attacker might be able to read it later, when he or she gains physical access to the computer). If you use VeraCrypt on a computer infected with any  kind of malware, VeraCrypt may become unable to secure data on the  computer.* Therefore, you must *not* use VeraCrypt on such a computer.
术语“恶意软件”是指所有类型的恶意软件，如计算机病毒，特洛伊木马，间谍软件，或一般的任何软件（包括VeraCrypt或操作系统组件），已经改变，准备，或可以 被攻击者控制某些类型的恶意软件被设计为例如记录黑客行为，包括键入的密码（然后将此类捕获的密码通过互联网发送给攻击者或保存到未加密的本地驱动器，攻击者可以从该驱动器中 当他或她获得对计算机的物理访问权时，他或她可能稍后能够阅读它）。如果您在感染了任何恶意软件的计算机上使用VeraCrypt，VeraCrypt可能无法保护计算机上的数据。*因此必须 *不要*在这样的计算机上使用VeraCrypt。

It is important to note that VeraCrypt is encryption software,  *not* anti-malware software. It is your responsibility to prevent  malware from running on the computer. If you do not, VeraCrypt may  become unable to secure data on the computer.
需要注意的是，VeraCrypt是加密软件，而*不是*反恶意软件。您有责任防止恶意软件在计算机上运行。如果您不这样做，VeraCrypt可能无法保护计算机上的数据。

There are many rules that you should follow to help prevent malware from running on your computer. Among the most important rules are the  following: Keep your operating system, Internet browser, and other  critical software, up-to-date. In Windows XP or later, turn on DEP for all programs.** Do not open suspicious email  attachments, especially executable files, even if they appear to have  been sent by your relatives or friends (their computers might be  infected with malware sending malicious emails from their  computers/accounts without their knowledge). Do not follow suspicious links contained in  emails or on websites (even if the email/website appears to be harmless  or trustworthy). Do not visit any suspicious websites. Do not download  or install any suspicious software. Consider using good, trustworthy, anti-malware software.
您应该遵循许多规则来帮助防止恶意软件在您的计算机上运行。其中最重要的规则如下：保持您的操作系统，互联网浏览器和其他关键软件是最新的。在Windows  XP或更高版本中，为所有程序打开DEP。**不要打开可疑的电子邮件附件，特别是可执行文件，即使它们似乎是由您的亲戚或朋友发送的（他们的计算机可能会感染恶意软件，在他们不知情的情况下从他们的计算机/帐户发送恶意电子邮件）。不要跟踪电子邮件或网站中包含的可疑链接（即使电子邮件/网站看起来无害或值得信赖）。不要访问任何可疑网站。不要下载或安装任何可疑软件。考虑使用好的、值得信赖的反恶意软件。



------

\* In this section (*Malware*), the phrase "data on the computer" means data on internal and external  storage devices/media (including removable devices and network drives) connected to the computer.
\* 在本节（*恶意软件*）中，短语“计算机上的数据”是指连接到计算机的内部和外部存储设备/介质（包括可移动设备和网络驱动器）上的数据。
 ** DEP stands for Data Execution Prevention. For more information about DEP, please visit [ https://support.microsoft.com/kb/875352](https://support.microsoft.com/kb/875352) and [ http://technet.microsoft.com/en-us/library/cc700810.aspx](http://technet.microsoft.com/en-us/library/cc700810.aspx).
** DEP是Data Execution Prevention的缩写。有关DEP的更多信息，请访问 https://support.microsoft.com/kb/875352和http://technet.microsoft.com/en-us/library/cc700810.aspx。

# Multi-User Environment 多用户环境

Keep in mind, that the content of a mounted VeraCrypt volume is visible  (accessible) to all logged on users. NTFS file/folder permissions can be set to prevent this, unless the volume is mounted as removable medium  (see section [ *Volume Mounted as Removable Medium*](https://veracrypt.fr/en/Removable Medium Volume.html)) under a desktop edition of Windows Vista or later (sectors of a volume  mounted as removable medium may be accessible at the volume level to  users without administrator privileges, regardless of whether it is accessible to them at the file-system level).
请记住，所有登录用户都可以看到（访问）已安装的VeraCrypt卷的内容。可以设置卷文件/文件夹权限来防止这种情况，除非卷是作为可移动介质装载的（请参见 在Windows Vista或更高版本的桌面版下[*，作为可移动介质装载的卷）*](https://veracrypt.fr/en/Removable Medium Volume.html)（作为可移动介质装载的卷的扇区可以由没有管理员权限的用户在卷级别访问，无论它是否 可在文件系统级别访问它们）。

 Moreover, on Windows, the password cache is shared by all logged on users (for more information, please see the section *Settings -> Preferences*, subsection *Cache passwords in driver memory*).
此外，在Windows上，密码缓存由所有登录用户共享（有关详细信息，请参阅 *设置->首选项*，子部分*在驱动程序内存中缓存密码*）。

 Also note that switching users in Windows XP or later (*Fast User Switching* functionality) does *not* dismount a successfully mounted VeraCrypt volume (unlike system restart, which dismounts all mounted VeraCrypt volumes).
另请注意，在Windows XP或更高版本中切换用户（*快速用户切换*功能） *不*卸载一个成功挂载的VeraCrypt加密卷（不像系统重启，它会卸载所有挂载的VeraCrypt加密卷）。

 On Windows 2000, the container file permissions are ignored when a  file-hosted VeraCrypt volume is to be mounted. On all supported versions of Windows, users without administrator privileges can mount any  partition/device-hosted VeraCrypt volume (provided that they supply the correct password and/or keyfiles). A user without  administrator privileges can dismount only volumes that he or she  mounted. However, this does not apply to system favorite volumes unless  you enable the option (disabled by default) *Settings* > ‘*System Favorite Volumes*’ > ‘*Allow only administrators to view and dismount system favorite volumes in VeraCrypt*’.
在Windows 2000上，当要装载文件托管的VeraCrypt卷时，将忽略容器文件权限。在所有受支持的Windows版本上，没有管理员权限的用户可以挂载任何分区/设备托管的VeraCrypt加密卷（前提是 它们提供正确的密码和/或密钥文件）。没有管理员权限的用户只能卸载他或她装载的卷。但是，这不适用于系统收藏卷，除非您启用该选项（默认情况下禁用） *设置*>“*系统收藏夹加密*”>“*仅允许管理员查看和加密VeraCrypt中的系统收藏夹加密卷*”.

# Authenticity and Integrity 真实性和完整性

VeraCrypt uses encryption to preserve the *confidentiality* of data it encrypts. VeraCrypt neither preserves nor verifies the  integrity or authenticity of data it encrypts or decrypts. Hence, if you allow an adversary to modify data encrypted by VeraCrypt, he can set the value of any 16-byte block of the data to a random value or to a previous value, which he was able to obtain in the past. Note  that the adversary cannot choose the value that you will obtain when  VeraCrypt decrypts the modified block — the value will be random — unless the attacker restores an older  version of the encrypted block, which he was able to obtain in the past. It is your responsibility to verify the integrity and authenticity of  data encrypted or decrypted by VeraCrypt (for example, by using appropriate third-party software).
VeraCrypt使用加密来保护其加密数据的*机密性*。VeraCrypt既不保留也不验证其加密或解密的数据的完整性或真实性。因此，如果您允许攻击者修改VeraCrypt加密的数据， 他可以将任何16字节数据块的值设置为随机值或设置为他过去能够获得的先前值。请注意，当VeraCrypt解密修改后的区块时，攻击者不能选择您将获得的值- 该值将是随机的-除非攻击者恢复他在过去能够获得的加密块的较旧版本。您有责任验证VeraCrypt加密或解密的数据的完整性和真实性（对于 例如，通过使用适当的第三方软件）。

 See also: [ *Physical Security*](https://veracrypt.fr/en/Physical Security.html), [ *Security Model*](https://veracrypt.fr/en/Security Model.html)
参见：[*物理安全*](https://veracrypt.fr/en/Physical Security.html)，[*安全模型*](https://veracrypt.fr/en/Security Model.html)

# Choosing Passwords and Keyfiles 选择密码和密钥文件

It is very important that you choose a good password. You must avoid  choosing one that contains only a single word that can be found in a  dictionary (or a combination of such words). It must not contain any  names, dates of birth, account numbers, or any other items that could be easy to guess. A good password is a random  combination of upper and lower case letters, numbers, and special  characters, such as @ ^ = $ * + etc. We strongly recommend choosing a  password consisting of more than 20 characters (the longer, the better). Short passwords are easy to crack using  brute-force techniques.
选择一个好的密码是非常重要的。你必须避免选择一个只包含一个可以在字典中找到的单词（或这些单词的组合）。它不能包含任何姓名，出生日期，帐户号码，或任何 其他容易猜到的东西一个好的密码是大小写字母、数字和特殊字符的随机组合，例如@ ^ = $ * +等。我们强烈建议选择由20个以上字符组成的密码（ 越长越好）。短密码很容易用暴力破解技术破解。
 
 To make brute-force attacks on a keyfile infeasible, the size of the  keyfile must be at least 30 bytes. If a volume uses multiple keyfiles,  then at least one of the keyfiles must be 30 bytes in size or larger.  Note that the 30-byte limit assumes a large amount of entropy in the keyfile. If the first 1024 kilobytes of a file  contain only a small amount of entropy, it must not be used as a keyfile (regardless of the file size). If you are not sure what entropy means,  we recommend that you let VeraCrypt generate a file with random content and that you use it as a keyfile (select *Tools -> Keyfile Generator*).
要使对密钥文件的暴力攻击不可行，密钥文件的大小必须至少为30个字节。如果一个卷使用多个密钥文件，则至少有一个密钥文件的大小必须大于或等于30字节。请注意，30字节的限制假定了 密钥文件中的熵。如果一个文件的前1024个字节只包含少量的熵，它不能被用作密钥文件（不管文件大小）。如果您不确定熵的含义，我们建议您让VeraCrypt生成一个 具有随机内容的文件，并将其用作密钥文件（选择“工具”-“%3 E密钥文件生成器”）。

When creating a volume, encrypting a system partition/drive, or changing  passwords/keyfiles, you must not allow any third party to choose or  modify the password/keyfile(s) before/while the volume is created or the password/keyfiles(s) changed. For example, you must not use any password generators (whether website applications  or locally run programs) where you are not sure that they are  high-quality and uncontrolled by an attacker, and keyfiles must not be  files that you download from the internet or that are accessible to other users of the computer (whether they are  administrators or not).
创建卷、加密系统分区/驱动器或更改密码/密钥文件时，在创建卷或更改密码/密钥文件之前/期间，您不得允许任何第三方选择或修改密码/密钥文件。例如，您不能使用任何密码生成器（无论是网站应用程序还是本地运行的程序），如果您不确定它们是高质量的并且不受攻击者控制，并且密钥文件不能是您从互联网下载的文件或计算机的其他用户（无论他们是否是管理员）可以访问的文件。

# Changing Passwords and Keyfiles 更改密码和密钥文件

Note that the volume header (which is encrypted with a header key derived  from a password/keyfile) contains the master key (not to be confused  with the password) with which the volume is encrypted. If an adversary  is allowed to make a copy of your volume before you change the volume password and/or keyfile(s), he may be able to use his copy or fragment (the old header) of the VeraCrypt volume to mount your volume using a compromised password and/or compromised  keyfiles that were necessary to mount the volume before you changed the volume password and/or keyfile(s).
请注意，卷头（使用从密码/密钥文件导出的头密钥加密）包含用于加密卷的主密钥（不要与密码混淆）。如果允许对手复制您的卷 在您更改加密卷密码和/或密钥文件之前，他可能会使用他的VeraCrypt加密卷的副本或片段（旧的头文件），使用破解的密码和/或破解的密钥文件来挂载您的加密卷 在您更改卷密码和/或密钥文件之前。
 
 If you are not sure whether an adversary knows your password (or has  your keyfiles) and whether he has a copy of your volume when you need to change its password and/or keyfiles, it is strongly recommended that  you create a new VeraCrypt volume and move files from the old volume to the new volume (the new volume will have a  different master key).
如果您不确定攻击者是否知道您的密码（或拥有您的密钥文件），以及当您需要更改加密卷的密码和/或密钥文件时，他是否拥有您加密卷的副本，强烈建议您创建一个新的VeraCrypt加密卷并移动文件 从旧卷到新卷（新卷将具有不同的主密钥）。
 
 Also note that if an adversary knows your password (or has your  keyfiles) and has access to your volume, he may be able to retrieve and  keep its master key. If he does, he may be able to decrypt your volume  even after you change its password and/or keyfile(s) (because the master key does not change when you change the volume  password and/or keyfiles). In such a case, create a new VeraCrypt volume and move all files from the old volume to this new one.
另外请注意，如果对手知道您的密码（或拥有您的密钥文件）并可以访问您的卷，他可能能够检索并保留其主密钥。如果他这样做，他可能能够解密您的卷，甚至在您更改其密码和/或密钥文件 （因为当您更改卷密码和/或密钥文件时，主密钥不会更改）。在这种情况下，创建一个新的VeraCrypt加密卷，并将旧加密卷中的所有文件移动到新加密卷中。
 
 The following sections of this chapter contain additional information  pertaining to possible security issues connected with changing passwords and/or keyfiles:
本章的以下部分包含与更改密码和/或密钥文件有关的可能安全问题的其他信息：

- [*Security Requirements and Precautions
  安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)
- [*Journaling File Systems 日志文件系统*](https://veracrypt.fr/en/Journaling File Systems.html)
- [*Defragmenting 碎片整理*](https://veracrypt.fr/en/Defragmenting.html)
- [*Reallocated Sectors 重新分配的部门*](https://veracrypt.fr/en/Reallocated Sectors.html)

# Trim Operation 修剪操作

Some storage devices (e.g., some solid-state drives, including USB flash drives) use so-called 'trim' operation to mark drive sectors as free  e.g. when a file is deleted. Consequently, such sectors may contain  unencrypted zeroes or other undefined data (unencrypted) even if they are located within a part of the drive that is encrypted  by VeraCrypt.
一些存储设备（例如，某些固态驱动器（包括USB闪存驱动器）使用所谓的“修剪”操作来将驱动器扇区标记为空闲，例如，当文件被删除时。因此，这些扇区可能包含未加密的零或其他未定义的数据（未加密） 即使它们位于由VeraCrypt加密的驱动器的一部分中。

 On Windows, VeraCrypt allows users to control the trim operation for both non-system and system volumes: 
在Windows上，VeraCrypt允许用户控制非系统和系统加密卷的修剪操作：

- For non-system volumes, trim is blocked by default. Users can enable trim  through VeraCrypt's interface by navigating to "Settings ->  Performance/Driver Configuration" and checking the option "Allow TRIM  command for non-system SSD partition/drive."
  对于非系统卷，默认情况下会阻止修剪。用户可以通过VeraCrypt的界面导航到“设置->性能/驱动程序配置”并选中“允许对非系统SSD分区/驱动器使用TRIM命令”选项来启用修剪。"
- For [system encryption](https://veracrypt.fr/en/System Encryption.html), trim is enabled by default (unless a [hidden operating system](https://veracrypt.fr/en/Hidden Operating System.html) is running). Users can disable trim by navigating to "System ->  Settings" and checking the option "Block TRIM command on system  partition/drive."
  对于[系统加密](https://veracrypt.fr/en/System Encryption.html)，修剪默认启用（除非正在运行[隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)）。用户可以通过导航到“系统->设置”并选中选项“块TRIM命令系统分区/驱动器禁用修剪。"

Under Linux, VeraCrypt does not block the trim operation on volumes  using the native Linux kernel cryptographic services, which is the  default setting. To block TRIM on Linux, users should either enable the  "do not use kernel cryptographic services" option in VeraCrypt's  Preferences (applicable only to volumes mounted afterward) or use the `--mount-options=nokernelcrypto` switch in the command line when mounting. 
在Linux下，VeraCrypt不会阻止使用本机Linux内核加密服务的卷上的修剪操作，这是默认设置。要在Linux上阻止TRIM，用户应该在VeraCrypt的首选项中启用“不使用内核加密服务”选项（仅适用于之后挂载的卷），或者在挂载时使用命令行中的 `--mount-options=nokernelcrypto` 开关。

 Under macOS, VeraCrypt does not support the trim operation. Therefore, trim is always blocked on all volumes. 
在macOS下，VeraCrypt不支持修剪操作。因此，在所有卷上始终阻止修剪。

 In cases where trim operations occur, the adversary will be able to tell which sectors contain free space (and may be able to use this  information for further analysis and attacks) and [ plausible deniability](https://veracrypt.fr/en/Plausible Deniability.html) may be negatively affected. In order to avoid  these issues, users should either disable trim in VeraCrypt settings as  previously described or make sure VeraCrypt volumes are not located on  drives that use the trim operation.
在发生修剪操作的情况下，对手将能够辨别哪些扇区包含自由空间（并且可能能够使用该信息来进行攻击）。 进一步的分析和攻击）和[合理的否认](https://veracrypt.fr/en/Plausible Deniability.html)可能会受到负面影响。为了避免这些问题，用户应该在VeraCrypt设置中禁用修剪，或者确保VeraCrypt加密卷不在使用修剪操作的驱动器上。

To find out whether a device uses the trim operation, please refer to  documentation supplied with the device or contact the  vendor/manufacturer.
要了解设备是否使用微调操作，请参阅设备随附的文档或联系供应商/制造商。

# Wear-Leveling 损耗均衡

Some storage devices (e.g., some solid-state drives, including USB flash drives) and some file systems utilize so-called wear-leveling  mechanisms to extend the lifetime of the storage device or medium. These mechanisms ensure that even if an application repeatedly writes data to the same logical sector, the data is distributed evenly  across the medium (logical sectors are remapped to different physical  sectors). Therefore, multiple "versions" of a single sector may be  available to an attacker. This may have various security implications. For instance, when you change a volume  password/keyfile(s), the volume header is, under normal conditions,  overwritten with a re-encrypted version of the header. However, when the volume resides on a device that utilizes a wear-leveling mechanism, VeraCrypt cannot ensure that the older header is really  overwritten. If an adversary found the old volume header (which was to  be overwritten) on the device, he could use it to mount the volume using an old compromised password (and/or using compromised keyfiles that were necessary to mount the volume before the volume  header was re-encrypted). Due to security reasons, we recommend that [ VeraCrypt volumes](https://veracrypt.fr/en/VeraCrypt Volume.html) are not created/stored on devices (or in file  systems) that utilize a wear-leveling mechanism (and that VeraCrypt is  not used to encrypt any portions of such devices or filesystems).
一些存储设备（例如，包括USB闪存驱动器的某些固态驱动器）和某些文件系统利用所谓的损耗均衡机制来延长存储设备或介质的寿命。这些机制确保即使应用程序反复 将数据写入相同的逻辑扇区，数据在介质上均匀分布（逻辑扇区重新映射到不同的物理扇区）。因此，单个扇区的多个“版本”可能对攻击者可用。这可能有各种各样的 安全影响。例如，当您更改卷密码/密钥文件时，在正常情况下，卷标头将被重新加密的标头版本覆盖。然而，当卷驻留在利用损耗均衡的设备上时， 由于这种机制，VeraCrypt无法确保旧的头文件确实被覆盖。如果攻击者在设备上发现旧的卷标头（将被覆盖），则他可以使用旧的泄露密码（和/或使用泄露密码）来装载卷。 在重新加密卷头之前安装卷所必需的密钥文件）。出于安全考虑，我们建议 [VeraCrypt加密卷](https://veracrypt.fr/en/VeraCrypt Volume.html)不会创建/存储在使用损耗均衡机制的设备（或文件系统）上（并且VeraCrypt不会用于加密这些设备或文件系统的任何部分）。

If you decide not to follow this recommendation and you intend to use  in-place encryption on a drive that utilizes wear-leveling mechanisms,  make sure the partition/drive does not contain any sensitive data before you fully encrypt it (VeraCrypt cannot reliably perform secure in-place encryption of existing data on such a drive;  however, after the partition/drive has been fully encrypted, any new  data that will be saved to it will be reliably encrypted on the fly).  That includes the following precautions: Before you run VeraCrypt to set up pre-boot authentication, disable the paging files and restart the operating system (you can enable the [ paging files](https://veracrypt.fr/en/Paging File.html) after the system partition/drive has been fully encrypted). [ Hibernation](https://veracrypt.fr/en/Hibernation File.html) must be prevented during the period between the moment  when you start VeraCrypt to set up pre-boot authentication and the  moment when the system partition/drive has been fully encrypted.  However, note that even if you follow those steps, it is *not* guaranteed that you will prevent data leaks and that sensitive data on  the device will be securely encrypted. For more information, see the  sections [ Data Leaks](https://veracrypt.fr/en/Data Leaks.html), [ Paging File](https://veracrypt.fr/en/Paging File.html), [ Hibernation File](https://veracrypt.fr/en/Hibernation File.html), and [ Memory Dump Files](https://veracrypt.fr/en/Memory Dump Files.html).
如果您决定不遵循此建议，并且打算在使用损耗均衡机制的驱动器上使用就地加密，请在完全加密之前确保分区/驱动器不包含任何敏感数据（VeraCrypt无法可靠地加密分区/驱动器）。 对此类驱动器上的现有数据执行安全的就地加密;但是，在分区/驱动器完全加密后，将保存到其中的任何新数据都将实时可靠地加密）。这包括以下预防措施： 运行VeraCrypt设置预启动验证，禁用分页文件并重新启动操作系统（您可以启用 在系统分区/驱动器已被完全加密[之后分页文件](https://veracrypt.fr/en/Paging File.html)）。在您启动VeraCrypt设置预启动认证和系统分区/驱动器完全加密之间的这段时间内，必须防止[休眠](https://veracrypt.fr/en/Hibernation File.html)。但是，请注意，即使您遵循这些步骤，也*不能*保证您将防止数据泄漏，并且设备上的敏感数据将被安全加密。有关详细信息，请参阅 [数据泄漏](https://veracrypt.fr/en/Data Leaks.html)、[分页文件](https://veracrypt.fr/en/Paging File.html)、[休眠文件](https://veracrypt.fr/en/Hibernation File.html)和[内存转储文件](https://veracrypt.fr/en/Memory Dump Files.html)。

If you need [ plausible deniability](https://veracrypt.fr/en/Plausible Deniability.html), you must not use VeraCrypt to encrypt any  part of (or create encrypted containers on) a device (or file system)  that utilizes a wear-leveling mechanism.
如果您需要[合理的可否认性](https://veracrypt.fr/en/Plausible Deniability.html)，则不得使用VeraCrypt加密使用损耗均衡机制的设备（或文件系统）的任何部分（或在其上创建加密容器）。

To find out whether a device utilizes a wear-leveling mechanism, please  refer to documentation supplied with the device or contact the  vendor/manufacturer.
要了解设备是否采用磨损均衡机制，请参阅设备随附的文档或联系供应商/制造商。

# Reallocated Sectors 重新分配的部门

Some storage devices, such as hard drives, internally reallocate/remap bad  sectors. Whenever the device detects a sector to which data cannot be  written, it marks the sector as bad and remaps it to a sector in a  hidden reserved area on the drive. Any subsequent read/write operations from/to the bad sector are redirected to the  sector in the reserved area. This means that any existing data in the  bad sector remains on the drive and it cannot be erased (overwritten  with other data). This may have various security implications. For instance, data that is to be encrypted in place may remain  unencrypted in the bad sector. Likewise, data to be erased (for example, during the process of creation of a hidden operating system) may remain in the bad sector. Plausible deniability (see section [*Plausible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)) may be adversely affected whenever a sector is reallocated. Additional  examples of possible security implications are listed in the section [ *Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html). Please note that this list is not exhaustive (these are just examples). Also note that VeraCrypt *cannot* prevent any security issues related to or caused by reallocated  sectors. To find out the number of reallocated sectors on a hard drive,  you can use e.g. a third-party software tool for reading so-called  S.M.A.R.T. data.
某些存储设备（如硬盘驱动器）会在内部重新分配/重新映射坏扇区。每当设备检测到无法写入数据的扇区时，它会将该扇区标记为坏扇区，并将其重新映射到驱动器上隐藏的保留区中的扇区。任何后续 来自/去往坏扇区的读/写操作被重定向到保留区中的扇区。这意味着坏扇区中的任何现有数据都保留在驱动器上，并且无法擦除（用其他数据覆盖）。这可能会产生各种安全影响。 例如，要就地加密的数据可能在坏扇区中保持未加密。同样，要擦除的数据（例如，在创建隐藏操作系统的过程中）可能会保留在坏扇区中。合理否认（见第 当一个扇区被重新分配时，可能会受到不利影响。部分中列出了可能的安全影响的其他示例 [*安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements and Precautions.html)。请注意，此列表并不详尽（这些只是示例）。还请注意，VeraCrypt *不能*防止与重新分配的扇区相关或由重新分配的扇区引起的任何安全问题。要了解硬盘上重新分配的扇区数，您可以使用第三方软件工具来阅读所谓的S.M.A.R.T.数据

# Defragmenting 碎片整理

When you (or the operating system) defragment the file system in which a  file-hosted VeraCrypt container is stored, a copy of the VeraCrypt  container (or of its fragment) may remain in the free space on the host  volume (in the defragmented file system). This may have various security implications. For example, if you change the volume password/keyfile(s) afterwards, and an adversary finds the  old copy or fragment (the old header) of the VeraCrypt volume, he might  use it to mount the volume using an old compromised password (and/or using compromised keyfiles that were necessary to  mount the volume before the volume header was re-encrypted). To prevent  this and other possible security issues (such as those mentioned in the  section [*Volume Clones*](https://veracrypt.fr/en/Volume Clones.html)), do one of the following:
当您（或操作系统）对存储文件托管的VeraCrypt容器的文件系统进行碎片整理时，VeraCrypt容器（或其碎片）的副本可能会保留在主机卷（碎片整理文件系统）的可用空间中。 这可能会产生各种安全影响。例如，如果您更改了加密卷密码/密钥文件，攻击者发现了VeraCrypt加密卷的旧副本或片段（旧头），他可能会使用旧的受损加密卷来挂载加密卷。 密码（和/或使用在卷头重新加密之前装载卷所需的受损密钥文件）。为了防止此问题和其他可能的安全问题（例如， [*卷克隆*](https://veracrypt.fr/en/Volume Clones.html)），请执行以下操作之一：

- Use a partition/device-hosted VeraCrypt volume instead of file-hosted. 
  使用分区/设备托管的VeraCrypt加密卷，而不是文件托管的加密卷。
- *Securely* erase free space on the host volume (in the defragmented file system)  after defragmenting. On Windows, this can be done using the Microsoft  free utility `SDelete` (https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx). On Linux, the `shred` utility from GNU coreutils package can be used for this purpose. 
  在碎片整理后*，安全*擦除主机卷（在碎片整理文件系统中）上的可用空间。在Windows上，这可以使用Microsoft免费实用程序来完成 `SDelete`（https://technet.microsoft.com/en-us/sysinternals/bb897443.aspx）。在Linux上， GNU coreutils包中`shred`实用程序可用于此目的。
- Do not defragment file systems in which you store VeraCrypt volumes. 
  不要对存储VeraCrypt加密卷的文件系统进行碎片整理。

# Journaling File Systems 日志文件系统

When a file-hosted VeraCrypt container is stored in a journaling file system (such as NTFS or Ext3), a copy of the VeraCrypt container (or of its  fragment) may remain in the free space on the host volume. This may have various security implications. For example, if you change the volume password/keyfile(s) and an adversary  finds the old copy or fragment (the old header) of the VeraCrypt volume, he might use it to mount the volume using an old compromised password  (and/or using compromised keyfiles using an old compromised password (and/or using compromised keyfiles that were  necessary to mount the volume before the volume header was re-  encrypted). Some journaling file systems also internally record file  access times and other potentially sensitive information. If you need plausible deniability (see section [ *Plausible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)), you must not store file-hosted VeraCrypt containers in journaling file  systems. To prevent possible security issues related to journaling file  systems, do one the following:
当文件托管的VeraCrypt容器存储在日志文件系统（如NTFS或Ext  3）中时，VeraCrypt容器（或其片段）的副本可能会保留在主机卷的可用空间中。这可能会产生各种安全影响。例如，如果您更改了加密卷的密码/密钥文件，攻击者发现了旧的VeraCrypt加密卷的副本或片段（旧的头文件），他可能会使用旧的密码（和/或使用旧密码的密钥文件（和/或使用在重新加密卷头文件之前安装加密卷所需的密钥文件））来挂载加密卷。一些日志文件系统还在内部记录文件访问时间和其他潜在的敏感信息。如果您需要合理的可否认性（请参阅[*合理的可否认性一*](https://veracrypt.fr/en/Plausible Deniability.html)节），您不能将文件托管的VeraCrypt容器存储在日志文件系统中。 若要防止可能出现的与日志文件系统相关的安全问题，请执行以下操作之一：

- Use a partition/device-hosted VeraCrypt volume instead of file-hosted. 
  使用分区/设备托管的VeraCrypt加密卷，而不是文件托管的加密卷。
- Store the container in a non-journaling file system (for example, FAT32). 
  将容器存储在非日志文件系统（例如，FAT32）中。

## Volume Clones 卷克隆

Never create a new VeraCrypt volume by cloning an existing VeraCrypt volume.  Always use the VeraCrypt Volume Creation Wizard to create a new  VeraCrypt volume. If you clone a volume and then start using both this  volume and its clone in a way that both eventually contain different data, then you might aid cryptanalysis (both volumes  will share a single key set). This is especially critical when the  volume contains a hidden volume. Also note that plausible deniability  (see section [*Plausible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)) is impossible in such cases. See also the chapter [ *How to Back Up Securely*](https://veracrypt.fr/en/How to Back Up Securely.html).
永远不要通过克隆一个已经存在的VeraCrypt加密卷来创建一个新的VeraCrypt加密卷。总是使用VeraCrypt加密卷创建向导来创建一个新的VeraCrypt加密卷。如果您克隆一个卷，然后开始同时使用该卷及其克隆， 包含不同的数据，那么您可能会帮助密码分析（两个卷将共享一个密钥集）。当卷包含隐藏卷时，这一点尤其重要。还要注意，合理的否认（见第 在这种情况下是不可能的。另见本章 [*如何备份*](https://veracrypt.fr/en/How to Back Up Securely.html)Secret

# Additional Security Requirements and Precautions 其他安全要求和预防措施

In addition to the requirements and precautions described in this chapter ([*Security Requirements and Precautions*](https://veracrypt.fr/en/Security Requirements and Precautions.html)), you must follow and keep in mind the security requirements, precautions, and limitations listed in the following chapters and sections:
除了本章（[*安全要求和注意事项*](https://veracrypt.fr/en/Security Requirements and Precautions.html)）中所述的要求和注意事项外，您还必须遵守并牢记以下章节中列出的安全要求、注意事项和限制：

- [***How to Back Up Securely
  如何备份Secret***](https://veracrypt.fr/en/How to Back Up Securely.html)
- [***Limitations 限制***](https://veracrypt.fr/en/Issues and Limitations.html)
- [***Security Model 安全模型***](https://veracrypt.fr/en/Security Model.html)
- [***Security Requirements and Precautions Pertaining to Hidden Volumes
  与隐藏式网络有关的安全要求和预防措施***](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html)
- [***Plausible Deniability 合理推诿***](https://veracrypt.fr/en/Plausible Deniability.html)

See also: [ *Digital Signatures*](https://veracrypt.fr/en/Digital Signatures.html)
参见：[*数字签名*](https://veracrypt.fr/en/Digital Signatures.html)

## How to Back Up Securely 如何备份Secret

Due to hardware or software errors/malfunctions, files stored on a  VeraCrypt volume may become corrupted. Therefore, we strongly recommend  that you backup all your important files regularly (this, of course,  applies to any important data, not just to encrypted data stored on VeraCrypt volumes).
由于硬件或软件错误/故障，存储在VeraCrypt加密卷上的文件可能会损坏。因此，我们强烈建议您定期备份所有重要文件（当然，这适用于任何重要数据，而不仅仅是存储在VeraCrypt加密卷上的加密数据）。

### Non-System Volumes 非系统故障

To back up a non-system VeraCrypt volume securely, it is recommended to follow these steps:
要安全地备份非系统VeraCrypt加密卷，建议遵循以下步骤：

1. Create a new VeraCrypt volume using the VeraCrypt Volume Creation Wizard (do not enable the *Quick Format* option or the *Dynamic* option). It will be your  *backup* volume so its size should match (or be greater than) the size of your *main* volume.
   使用VeraCrypt加密卷创建向导创建一个新的VeraCrypt加密卷（不要启用 *“快速格式化*”选项或“*动态*”选项）。它将是您*的备份*卷，因此它的大小应匹配（或大于） *主*卷。
    
    If the *main* volume is a hidden VeraCrypt volume (see the section [ *Hidden Volume*](https://veracrypt.fr/en/Hidden Volume.html)), the *backup* volume must be a hidden VeraCrypt volume too. Before you create the hidden *backup* volume, you must create a new host (outer) volume for it without enabling the *Quick Format* option. In addition, especially if the *backup* volume is file-hosted, the hidden *backup* volume should occupy only a very small portion of the container and the outer volume should be almost completely filled with files (otherwise,  the plausible deniability of the hidden volume might be adversely  affected). 
   如果*主*加密卷是一个隐藏的VeraCrypt加密卷（参见[*隐藏加密卷一*](https://veracrypt.fr/en/Hidden Volume.html)节），*备份加密*卷也必须是一个隐藏的VeraCrypt加密卷。在创建隐藏的 *备份*卷，则必须为其创建新的主机（外部）卷，而不启用 *快速格式化*选项。此外，特别是如果*备份*卷是文件托管的， *备份*卷应该只占据容器的很小一部分，外部卷应该几乎完全充满文件（否则，隐藏卷的合理可否认性可能会受到不利影响）。
2. Mount the newly created *backup* volume. 
   装载新创建的*备份*卷。
3. Mount the *main* volume. 
   装载*主*卷。
4. Copy all files from the mounted *main* volume directly to the mounted  *backup* volume. 
   将所有文件从挂载的*主*卷直接复制到挂载的*备份*卷。

#### IMPORTANT: If you store the backup volume in any location that an adversary can  repeatedly access (for example, on a device kept in a bank’s safe  deposit box), you should repeat all of the above steps (including the  step 1) each time you want to back up the volume (see below). 请注意：如果您将备份卷存储在攻击者可以反复访问的任何位置（例如，存储在银行保险箱存款箱中的设备上），则每次要备份卷时都应重复上述所有步骤（包括步骤1）（请参阅下文）。

If you follow the above steps, you will help prevent adversaries from finding out:
如果你遵循上述步骤，你将有助于防止对手发现：

- Which sectors of the volumes are changing (because you always follow step 1). This is particularly important, for example, if you store the backup  volume on a device kept in a bank’s safe deposit box (or in any other  location that an adversary can repeatedly access) and the volume contains a hidden volume (for more  information, see the subsection [ *Security Requirements and Precautions Pertaining to Hidden Volumes*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) in the chapter [*Plausible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)). 
  卷的哪些部分正在发生变化（因为您始终遵循步骤1）。这一点尤其重要，例如，如果您将备份卷存储在银行的保险存款箱（或攻击者可以使用的任何其他位置）中的设备上 重复访问），并且该卷包含隐藏卷（有关详细信息，请参阅小节 本章中与隐藏的[*恶意软件有关的安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) [*可否认性（Prolasible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)）。
- That one of the volumes is a backup of the other. 
  其中一卷是另一卷的备份。

### System Partitions 系统分区

Note: In addition to backing up files, we recommend that you also back up your VeraCrypt Rescue Disk (select *System* > *Create Rescue Disk*). For more information, see the section Vera*Crypt Rescue Disk*.
注意：除了备份文件，我们建议您也备份您的VeraCrypt救援盘（选择 *系统*>*创建修复盘*）。欲了解更多信息，请参阅部分维拉*地穴救援磁盘*.

To back up an encrypted system partition securely and safely, it is recommended to follow these steps:
要安全可靠地备份加密的系统分区，建议执行以下步骤：

1. If you have multiple operating systems installed on your computer, boot the one that does not require pre-boot authentication.
   如果计算机上安装了多个操作系统，请靴子引导不需要预靴子身份验证的操作系统。
    
    If you do not have multiple operating systems installed on your  computer, you can boot a WinPE or BartPE CD/DVD (‘live’ Windows entirely stored on and booted from a CD/DVD; for more information, search the  section [*Frequently Asked Questions*](https://veracrypt.fr/en/FAQ.html) for the keyword ‘BartPE’).
   如果计算机上没有安装多个操作系统，则可以靴子引导WinPE或BartPE CD/DVD（“live”Windows完全存储在CD/DVD上并从CD/DVD引导;有关详细信息，请搜索 关键字“BartPE”[*的常见问题*](https://veracrypt.fr/en/FAQ.html)。
    
    If none of the above is possible, connect your system drive as a  secondary drive to another computer and then boot the operating system  installed on the computer.
   如果以上都不可能，请将系统驱动器作为辅助驱动器连接到另一台计算机，然后靴子计算机上安装的操作系统。
    
    Note: For security reasons, if the operating system that you want to  back up resides in a hidden VeraCrypt volume (see the section [ *Hidden Operating System*](https://veracrypt.fr/en/Hidden Operating System.html)), then the operating system that you boot in this step must be either  another hidden operating system or a "live- CD" operating system (see  above). For more information, see the subsection [ *Security Requirements and Precautions Pertaining to Hidden Volumes*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) in the chapter [*Plausible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html). 
   注意：出于安全考虑，如果您要备份的操作系统位于隐藏的VeraCrypt加密卷中（请参阅 [*Hidden Operating System*](https://veracrypt.fr/en/Hidden Operating System.html)），则您在此步骤中靴子的操作系统必须是另一个隐藏的操作系统或“live- CD”操作系统（参见上文）。有关详细信息，请参阅 本章中与隐藏的[*恶意软件有关的安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) [*合理的否认*](https://veracrypt.fr/en/Plausible Deniability.html)。

2. Create a new non-system VeraCrypt volume using the VeraCrypt Volume Creation Wizard (do not enable the *Quick Format* option or the *Dynamic* option). It will be your  *backup* volume so its size should match (or be greater than) the size of the system partition that you want to back up.
   使用VeraCrypt加密卷创建向导创建一个新的非系统加密卷（不要启用 *“快速格式化*”选项或“*动态*”选项）。它将是您*的备份*卷，因此其大小应匹配（或大于）您要备份的系统分区的大小。
    
    If the operating system that you want to back up is installed in a hidden VeraCrypt volume (see the section *Hidden Operating System*), the *backup* volume must be a hidden VeraCrypt volume too. Before you create the hidden *backup* volume, you must create a new host (outer) volume for it without enabling the *Quick Format* option. In addition, especially if the *backup* volume is file-hosted, the hidden *backup* volume should occupy only a very small portion of the container and the outer volume should be almost completely filled with files (otherwise,  the plausible deniability of the hidden volume might be adversely  affected). 
   如果您要备份的操作系统安装在隐藏的VeraCrypt加密卷中（请参阅 *隐藏操作系统*），*备份*卷也必须是隐藏的VeraCrypt加密卷。在创建隐藏的 *备份*卷，则必须为其创建新的主机（外部）卷，而不启用 *快速格式化*选项。此外，特别是如果*备份*卷是文件托管的， *备份*卷应该只占据容器的很小一部分，外部卷应该几乎完全充满文件（否则，隐藏卷的合理可否认性可能会受到不利影响）。

3. Mount the newly created *backup* volume. 
   装载新创建的*备份*卷。

4. Mount the system partition that you want to back up by following these steps:

   
   按照以下步骤装载要备份的系统分区：

   1. Click *Select Device* and then select the system partition that you want to back up (in case  of a hidden operating system, select the partition containing the hidden volume in which the operating system is installed). 
      单击*选择设备*，然后选择要备份的系统分区（如果是隐藏操作系统，请选择包含安装操作系统的隐藏卷的分区）。
   2. Click *OK*.  单击“*确定”（*OK）。
   3. Select *System* > *Mount Without Pre-Boot Authentication*. 
      选择*System*>*Mount Without Pre-Boot Authentication*。
   4. Enter your pre-boot authentication password and click *OK*. 
      输入您的预引导身份验证密码，然后单击*确定*。

5. Mount the *backup* volume and then use a third-party program or a Windows tool to create  an image of the filesystem that resides on the system partition (which  was mounted as a regular VeraCrypt volume in the previous step) and  store the image directly on the mounted backup volume. 
   挂载*备份*卷，然后使用第三方程序或Windows工具创建系统分区上的文件系统映像（在上一步中作为常规VeraCrypt卷挂载），并将映像直接存储在挂载的备份卷上。

#### IMPORTANT: If you store the backup volume in any location that an adversary can  repeatedly access (for example, on a device kept in a bank’s safe  deposit box), you should repeat all of the above steps (including the  step 2) each time you want to back up the volume (see below). 重要提示：如果您将备份卷存储在攻击者可以反复访问的任何位置（例如，存储在银行保险箱存款箱中的设备上），则每次要备份卷时都应重复上述所有步骤（包括步骤2）（请参阅下文）。

If you follow the above steps, you will help prevent adversaries from finding out:
如果你遵循上述步骤，你将有助于防止对手发现：

- Which sectors of the volumes are changing (because you always follow step 2). This is particularly important, for example, if you store the backup  volume on a device kept in a bank’s safe deposit box (or in any other  location that an adversary can repeatedly access) and the volume contains a hidden volume (for more  information, see the subsection [ *Security Requirements and Precautions Pertaining to Hidden Volumes*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) in the chapter [*Plausible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)). 
  卷的哪些扇区正在更改（因为您始终遵循步骤2）。这一点尤其重要，例如，如果您将备份卷存储在银行的保险存款箱（或攻击者可以使用的任何其他位置）中的设备上 重复访问），并且该卷包含隐藏卷（有关详细信息，请参阅小节 本章中与隐藏的[*恶意软件有关的安全要求和预防措施*](https://veracrypt.fr/en/Security Requirements for Hidden Volumes.html) [*可否认性（Prolasible Deniability*](https://veracrypt.fr/en/Plausible Deniability.html)）。
- That one of the volumes is a backup of the other. 
  其中一卷是另一卷的备份。

### General Notes 一般注释

If you store the backup volume in any location where an adversary can make a copy of the volume, consider encrypting the volume with a cascade of  ciphers (for example, with AES-Twofish- Serpent). Otherwise, if the  volume is encrypted only with a single encryption algorithm and the algorithm is later broken (for example, due to  advances in cryptanalysis), the attacker might be able to decrypt his  copies of the volume. The probability that three distinct encryption  algorithms will be broken is significantly lower than the probability that only one of them will be broken.
如果您将备份卷存储在攻击者可以复制该卷的任何位置，请考虑使用级联密码（例如，使用AES-Twofish-  Serpent）加密该卷。否则，如果该卷仅使用单个加密算法加密，并且该算法后来被破解（例如，由于密码分析的进步），则攻击者可能能够解密该卷的副本。三种不同的加密算法被破解的概率明显低于其中一种算法被破解的概率。

# Miscellaneous 杂项

- [Use Without Admin Rights 使用无管理员权限](https://veracrypt.fr/en/Using VeraCrypt Without Administrator Privileges.html)
- [Sharing over Network 通过网络共享](https://veracrypt.fr/en/Sharing over Network.html)
- [Background Task 后台任务](https://veracrypt.fr/en/VeraCrypt Background Task.html)
- [Removable Medium Volumes 中](https://veracrypt.fr/en/Removable Medium Volume.html)
- [VeraCrypt System Files VeraCrypt系统文件](https://veracrypt.fr/en/VeraCrypt System Files.html)
- [Removing Encryption 删除加密](https://veracrypt.fr/en/Removing Encryption.html)
- [Uninstalling VeraCrypt 卸载VeraCrypt](https://veracrypt.fr/en/Uninstalling VeraCrypt.html)
- [Digital Signatures 数字签名](https://veracrypt.fr/en/Digital Signatures.html)

## Using VeraCrypt Without Administrator Privileges 在没有管理员权限的情况下使用VeraCrypt

In Windows, a user who does not have administrator privileges *can* use VeraCrypt, but only after a system administrator installs VeraCrypt on the system. The reason for that is that VeraCrypt needs a device  driver to provide transparent on-the-fly encryption/decryption, and users without administrator privileges  cannot install/start device drivers in Windows.
在Windows系统中，没有管理员权限的用户*可以*使用VeraCrypt，但必须由系统管理员在系统上安装VeraCrypt。原因是VeraCrypt需要一个设备驱动程序来提供透明的动态加密 加密/解密，没有管理员权限的用户无法在Windows中安装/启动设备驱动程序。
 
 After a system administrator installs VeraCrypt on the system, users  without administrator privileges will be able to run VeraCrypt,  mount/dismount any type of VeraCrypt volume, load/save data from/to it,  and create file-hosted VeraCrypt volumes on the system. However, users without administrator privileges cannot encrypt/format  partitions, cannot create NTFS volumes, cannot install/uninstall  VeraCrypt, cannot change passwords/keyfiles for VeraCrypt  partitions/devices, cannot backup/restore headers of VeraCrypt partitions/devices, and they cannot run VeraCrypt in ‘portable’ mode.
当系统管理员在系统上安装VeraCrypt后，没有管理员权限的用户将可以运行VeraCrypt，挂载/卸载任何类型的VeraCrypt加密卷，加载/保存数据，以及在系统上创建文件托管的VeraCrypt加密卷。 但是，没有管理员权限的用户无法加密/格式化分区，无法创建NTFS卷，无法安装/卸载VeraCrypt，无法更改VeraCrypt分区/设备的密码/密钥文件，无法备份/恢复VeraCrypt的标头 分区/设备，它们不能在“便携”模式下运行VeraCrypt。

Warning: No matter what kind of software you use, as regards personal privacy in most cases, it is *not* safe to work with sensitive data under systems where you do not have  administrator privileges, as the administrator can easily capture and  copy your sensitive data, including passwords and keys. 警告：无论您使用哪种软件，在大多数情况下， 在您没有管理员权限的系统下使用敏感数据*并不*安全，因为管理员可以轻松捕获和复制您的敏感数据，包括密码和密钥。

# Sharing over Network 通过网络共享

If there is a need to access a single VeraCrypt volume simultaneously from multiple operating systems, there are two options:
如果需要从多个操作系统同时访问一个VeraCrypt加密卷，有两种选择：

1. A VeraCrypt volume is mounted only on a single computer (for example, on a server) and only the content of the mounted VeraCrypt volume (i.e., the file system within the VeraCrypt volume) is shared over a network.  Users on other computers or systems will not mount the volume (it is already mounted on the server).

   
   一个VeraCrypt加密卷只能安装在一台计算机上（例如，服务器上），并且只有安装的VeraCrypt加密卷的内容（即，VeraCrypt卷中的文件系统）通过网络共享。其他计算机或系统上的用户将 不挂载卷（它已经挂载在服务器上）。

   **Advantages**: All users can write data to the VeraCrypt volume. The shared volume may be both file-hosted and partition/device-hosted.
   **优点**：所有用户都可以将数据写入VeraCrypt加密卷。共享卷可以是文件托管的和分区/设备托管的。

   **Disadvantage**: Data sent over the network will not be encrypted. However, it is still  possible to encrypt them using e.g. SSL, TLS, VPN, or other  technologies.
   **缺点**：通过网络发送的数据不会被加密。但是，仍然可以使用例如SSL，TLS，VPN或其他技术对其进行加密。

   **Remarks**: Note that, when you restart the system, the network share will be  automatically restored only if the volume is a system favorite volume or an encrypted system partition/drive (for information on how to  configure a volume as a system favorite volume, see the chapter [ *System Favorite Volumes*](https://veracrypt.fr/en/System Favorite Volumes.html)).
   **备注**：请注意，当您重新启动系统时，仅当卷是系统收藏夹卷或加密的系统分区/驱动器时，网络共享才会自动恢复（有关如何将卷配置为系统收藏夹卷的信息，请参阅[*系统收藏夹卷一章*](https://veracrypt.fr/en/System Favorite Volumes.html)）。

2. A dismounted VeraCrypt file container is stored on a single computer (for example, on a server). This encrypted file is shared over a network.  Users on other computers or systems will locally mount the shared file.  Thus, the volume will be mounted simultaneously under multiple operating systems.

   
   VeraCrypt文件容器存储在一台计算机上（例如，在服务器上）。此加密文件通过网络共享。其他计算机或系统上的用户将在本地挂载共享文件。因此，将同时装入卷 在多个操作系统下。

   **Advantage**: Data sent over the network will be encrypted (however, it is still  recommended to encrypt them using e.g. SSL, TLS, VPN, or other  appropriate technologies to make traffic analysis more difficult and to  preserve the integrity of the data).
   **优势**：通过网络发送的数据将被加密（但是，仍然建议使用SSL，TLS，VPN或其他适当的技术进行加密，以使流量分析更加困难并保持数据的完整性）。

   **Disadvantages**: The shared volume may be only file-hosted (not  partition/device-hosted). The volume must be mounted in read-only mode  under each of the systems (see the section *Mount Options* for information on how to mount a volume in read-only mode). Note that  this requirement applies to unencrypted volumes too. One of the reasons  is, for example, the fact that data read from a conventional file system under one OS while the file system is being modified by another OS might be inconsistent  (which could result in data corruption).
   **缺点**：共享卷可能只托管文件（而不是托管分区/设备）。卷必须在每个系统下以只读模式装载（请参见 *Mount Options*（有关如何以只读模式装入卷的信息）。请注意，此要求也适用于未加密的卷。其中一个原因是，例如，在一个OS下从常规文件系统读取的数据在文件系统被另一个OS修改时可能不一致（这可能导致数据损坏）。

# VeraCrypt后台任务

When the main VeraCrypt window is closed, the VeraCrypt Background Task takes care of the following tasks/functions:
当VeraCrypt主窗口关闭时，VeraCrypt后台任务会处理以下任务/功能：

1. Hot keys  热键
2. Auto-dismount (e.g., upon logoff, inadvertent host device removal, time-out, etc.) 
   自动切换（例如，注销、无意中移除主机设备、超时等）
3. Auto-mount of favorite volumes 
   自动挂载收藏的卷
4. Notifications (e.g., when damage to hidden volume is prevented) 
   （例如，当防止对隐藏卷的损坏时）
5. Tray icon  托盘图标

WARNING: If neither the VeraCrypt Background Task nor VeraCrypt is running, the above- mentioned tasks/functions are disabled.
提示：如果VeraCrypt后台任务和VeraCrypt都没有运行，则上述任务/功能将被禁用。

 The VeraCrypt Background Task is actually the Vera*Crypt.exe* application, which continues running in the background after you close  the main VeraCrypt window. Whether it is running or not can be  determined by looking at the system tray area. If you can see the VeraCrypt icon there, then the VeraCrypt Background Task is running. You can click the icon to open the main VeraCrypt window.  Right-click on the icon opens a popup menu with various  VeraCrypt-related functions.
VeraCrypt后台任务实际上是Vera*Crypt.exe*应用程序，它在您关闭VeraCrypt主窗口后继续在后台运行。它是否正在运行可以通过查看系统托盘区域来确定。如果你 可以看到VeraCrypt图标，那么VeraCrypt后台任务正在运行。您可以点击图标打开VeraCrypt主窗口。右键点击图标会打开一个包含各种VeraCrypt相关功能的弹出菜单。

 You can shut down the Background Task at any time by right-clicking the VeraCrypt tray icon and selecting *Exit*. If you need to disable the VeraCrypt Background Task completely and permanently, select *Settings* -> *Preferences* and uncheck the option *Enabled* in the Vera*Crypt Background Task* area of the *Preferences* dialog window.
您可以在任何时候关闭后台任务，方法是右键单击VeraCrypt托盘图标并选择 *退出*.如果您需要完全永久地禁用VeraCrypt后台任务，选择 *设置*->*首选项*，并取消选中选项启用在维拉*地穴背景任务*区*的* *首选项*对话框窗口。

## Volume Mounted as Removable Medium 安装的卷作为介质

This section applies to VeraCrypt volumes mounted when one of the following options is enabled (as applicable):
本节适用于启用以下选项之一时挂载的VeraCrypt加密卷（如适用）：

- *Settings* > *Preferences* > *Mount volumes as removable media*
  *设置*>*首选项*>*将卷装载为可移动媒体*
- *Mount Options* > *Mount volume as removable medium*
  *挂载选项*>*将卷挂载为可移动介质* 
- *Favorites* > *Organize Favorite Volumes* > *Mount selected volume as removable medium*
  *收藏夹*>*组织收藏夹文件夹*>*将所选卷装载为可移动介质*
- *Favorites* > *Organize System Favorite Volumes* > *Mount selected volume as removable medium*
  *收藏夹*>*组织系统收藏夹目录*>*将所选卷装载为可移动介质*

VeraCrypt Volumes that are mounted as removable media have the following advantages and disadvantages:
作为可移动介质安装的VeraCrypt加密货币有以下优点和缺点：

- Windows is prevented from automatically creating the ‘*Recycled*’ and/or the ‘*System Volume Information*’ folders on VeraCrypt volumes (in Windows, these folders are used by the Recycle Bin and System Restore features). 
  Windows无法在VeraCrypt加密卷上自动创建“*已删除*”和/或“*系统加密卷信息*”文件夹（在Windows中，这些文件夹由回收站和系统还原功能使用）。
- Windows 8 and later is prevented from writing an Event 98 to the Events Log  that contains the device name (\\device\VeraCryptVolumeXX) of VeraCrypt  volumes formatted using NTFS. This event log "feature" was introduced in Windows 8 as part of newly introduced NTFS health checks as [ explained here](https://blogs.msdn.microsoft.com/b8/2012/05/09/redesigning-chkdsk-and-the-new-ntfs-health-model/). Big thanks to Liran Elharar for discovering this. 
  Windows  8及更高版本被禁止将事件98写入事件日志，该日志包含使用加密格式化的VeraCrypt卷的设备名称（\\device\VeraCryptVolumeXX）。此事件日志“功能”在Windows 8中作为新引入的Windows健康检查的一部分引入，如[此处所述](https://blogs.msdn.microsoft.com/b8/2012/05/09/redesigning-chkdsk-and-the-new-ntfs-health-model/)。非常感谢Liran Elharar发现了这一点。
- Windows may use caching methods and write delays that are normally used for  removable media (for example, USB flash drives). This might slightly  decrease the performance but at the same increase the likelihood that it will be possible to dismount the volume quickly without having to force the dismount. 
  Windows可能会使用通常用于可移动媒体（例如USB闪存驱动器）的缓存方法和写入延迟。这可能会略微降低性能，但同时增加了在不必强制执行卷重调的情况下快速重调卷重调的可能性。
- The operating system may tend to keep the number of handles it opens to  such a volume to a minimum. Hence, volumes mounted as removable media  might require fewer forced dismounts than other volumes. 
  操作系统可能倾向于将其打开到这样的卷的句柄的数量保持为最小。因此，作为可移动介质装载的卷可能比其他卷需要更少的强制卸载。
- Under Windows Vista and earlier, the ‘*Computer*’ (or ‘*My Computer*’) list does not show the amount of free space on volumes mounted as  removable (note that this is a Windows limitation, not a bug in  VeraCrypt). 
  在Windows Vista及更早版本下，“*电脑*”（或“*我的电脑*”）列表不显示挂载为可移动的卷的可用空间量（请注意，这是Windows限制，而不是VeraCrypt的错误）。
- Under desktop editions of Windows Vista or later, sectors of a volume mounted as removable medium may be accessible to all users (including users  without administrator privileges; see section [ *Multi-User Environment*](https://veracrypt.fr/en/Multi-User Environment.html)). 
  在Windows Vista或更高版本的桌面版下，所有用户（包括没有管理员权限的用户;请参见 [*多用户环境*](https://veracrypt.fr/en/Multi-User Environment.html)）。

# VeraCrypt System Files & Application Data VeraCrypt系统文件和应用程序数据

Note: %windir% is the main Windows installation path (e.g., C:\WINDOWS)
注意：%windir%是Windows的主安装路径（例如，C：\WINDOWS）

#### VeraCrypt Driver VeraCrypt驱动程序

%windir%\SYSTEM32\DRIVERS\veracrypt.sys
%windir%\EM32\DRIVERS\veracrypt.sys

Note: This file is not present when VeraCrypt is run in portable mode.
注意：当VeraCrypt在可移植模式下运行时，该文件不存在。

#### VeraCrypt Settings, Application Data, and Other System Files VeraCrypt设置、应用程序数据和其他系统文件

WARNING: Note that VeraCrypt does *not* encrypt any of the files listed in this section (unless it encrypts the system partition/drive).
注意：VeraCrypt*不会*加密本节中列出的任何文件（除非加密系统分区/驱动器）。
 
 The following files are saved in the folder %APPDATA%\VeraCrypt\. In  portable mode, these files are saved to the folder from which you run  the file Vera*Crypt.exe* (i.e., the folder in which Vera*Crypt.exe* resides):
以下文件保存在文件夹%APPDATA%\VeraCrypt\中。在便携模式下，这些文件将保存到您运行文件Vera*Crypt.exe*的文件夹中（即，Vera*Crypt.exe*所在的文件夹）：

- "Configuration.xml" (the main configuration file). 
  “configuration. xml”（主配置文件）。

- "System Encryption.xml" (temporary configuration file used during the initial  process of in-place encryption/decryption of the system  partition/drive). 
  “System Encryption.xml”（系统分区/驱动器的就地加密/解密初始过程中使用的临时配置文件）。

- "Default Keyfiles.xml"

   “Default Keyfiles.xml”

  - Note: This file may be absent if the corresponding VeraCrypt feature is not used. 
    注意：如果没有使用VeraCrypt的相应功能，这个文件可能会丢失。

- "Favorite Volumes.xml"

   “收藏卷. xml”

  - Note: This file may be absent if the corresponding VeraCrypt feature is not used. 
    注意：如果没有使用VeraCrypt的相应功能，这个文件可能会丢失。

- "History.xml" (the list of last twenty files/devices attempted to be mounted as  VeraCrypt volumes or attempted to be used as hosts for VeraCrypt  volumes; this feature can be disabled – for more information, see the  section

  Never Save History

  )

  
  “History.xml”（最后二十个文件/设备被尝试挂载为VeraCrypt加密卷或被尝试用作VeraCrypt加密卷的主机的列表;此功能可以被禁用-更多信息，请参阅 *从不保存历史记录*）

  - Note: This file may be absent if the corresponding VeraCrypt feature is not used. 
    注意：如果没有使用VeraCrypt的相应功能，这个文件可能会丢失。

- "In-Place Encryption" (temporary configuration file used during the initial  process of in-place encryption/decryption of a non-system volume). 
  “就地加密”（在非系统卷的就地加密/解密的初始过程中使用的临时配置文件）。

- "In-Place Encryption Wipe Algo" (temporary configuration file used during the  initial process of in-place encryption/decryption of a non-system  volume). 
  “就地加密擦除算法”（在非系统卷的就地加密/解密的初始过程中使用的临时配置文件）。

- "Post-Install Task - Tutorial" (temporary configuration file used during the process of installation or upgrade of VeraCrypt). 
  “安装后任务-配置文件”（VeraCrypt安装或升级过程中使用的临时配置文件）。

- "Post-Install Task - Release Notes" (temporary configuration file used during the  process of installation or upgrade of VeraCrypt). 
  "安装后任务发行说明"（temporary configuration file used during the process of installation or upgrade of VeraCrypt）。

The following files are saved in the folder %ALLUSERSPROFILE%\VeraCrypt\:
以下文件已保存在% Allusersprofile %\VeraCrypt文件夹中

- "Original System Loader" (a backup of the original content of the first drive  track made before the VeraCrypt Boot Loader was written to it).

  
  "Original System Loader"（在VeraCrypt引导加载器被写入之前，第一个驱动器轨道的原始内容的备份）。

  - Note: This file is absent if the system partition/drive has not been encrypted. 
    Note：如果系统分区/驱动器尚未加密，则此文件已丢失。

The following files are saved in the folder %windir%\system32 (32-bit systems) or %windir%\SysWOW64 (64-bit systems):
以下文件已保存在%windir%\system32（32位系统）或%windir%\SysWOW64（64位系统）文件夹中：

- "VeraCrypt System Favorite Volumes.xml"

  
  VeraCrypt系统Favorite Volumes.xml文件

  - Note: This file may be absent if the corresponding VeraCrypt feature is not used. 
    注：如果相应的VeraCrypt功能未使用，则此文件可能会被拒绝。

- VeraCrypt.exe
  - Note: A copy of this file is located in this folder only when mounting of system favorite volumes is enabled. 
    Note：A copy of this file is located in this folder only when mounting of  system favorite volume is enabled.这个文件的一个副本仅在挂载系统最喜欢的卷时位于此文件夹中。

# How to Remove Encryption 如何删除加密

Please note that VeraCrypt can in-place decrypt only **partitions and drives** (select *System* > *Permanently Decrypt System Partition/Drive* for system partition/drive and select *Volumes -> Permanently Decrypt*  for non-system partition/drive). If you need to remove encryption (e.g., if you no longer need encryption) from a **file-hosted volume**, please follow these steps:
请注意，VeraCrypt只能就地解密**分区和驱动器**（对于系统分区/驱动器，选择*系统*>*永久解密系统分区/驱动器*，然后*选择加密->永久解密* 对于非系统分区/驱动器）。如果您需要删除加密（例如，如果您不再需要加密）， **文件托管卷**，请执行以下步骤：

1. Mount the VeraCrypt volume. 
   挂载VeraCrypt加密卷。
2. Move all files from the VeraCrypt volume to any location outside the  VeraCrypt volume (note that the files will be decrypted on the fly). 
   将所有文件从VeraCrypt加密卷移动到VeraCrypt加密卷以外的任何位置（请注意，文件将被动态解密）。
3. Dismount the VeraCrypt volume. 
   卸载VeraCrypt加密卷。
4. delete it (the container) just like you delete any other file. 
   删除它（容器）就像删除任何其他文件一样。

If in-place decryption of non-system partitions/drives is not desired, it  is also possible in this case to follow the steps 1-3 described above.
如果不需要对非系统分区/驱动器进行就地解密，则在这种情况下也可以遵循上述步骤1-3。
 
 In all cases, if the steps 1-3 are followed, the following extra operations can be performed:
在所有情况下，如果遵循步骤1-3，则可以执行以下额外操作：

- **If the volume is partition-hosted (applies also to USB flash drives)
  如果卷是分区托管的（也适用于USB闪存驱动器）**

1. Right-click the ‘*Computer*’ (or ‘*My Computer*’) icon on your desktop, or in the Start Menu, and select *Manage*. The ‘*Computer Management*’ window should appear. 
   右键单击桌面上或开始菜单中的“*计算机*”（或“*我的电脑*”）图标，然后选择 *管好*。“*计算机管理*”窗口将出现。
2. In the *Computer Management* window, from the list on the left, select ‘*Disk Management*’ (within the *Storage* sub-tree). 
   在“*计算机管理”*窗口中，从左侧的列表中选择“*磁盘管理*”（在 *存储*子树）。
3. Right-click the partition you want to decrypt and select ‘*Change Drive Letter and Paths*’. 
   右键单击要解密的分区，然后选择“*更改驱动器号和路径*”。
4. The ‘*Change Drive Letter and Paths*’ window should appear. If no drive letter is displayed in the window, click *Add*. Otherwise, click *Cancel*.
   “*更改驱动器号和路径*”窗口应出现。如果窗口中未显示驱动器号，请单击 *Add*.否则，单击*“取消*”。
    
    If you clicked *Add*, then in the ‘*Add Drive Letter or Path*’ (which should have appeared), select a drive letter you want to assign to the partition and click *OK*. 
   如果您单击*了“添加*”，则在“*添加驱动器号或路径*”（应该已经出现）中，选择要分配给该分区的驱动器号，然后单击 *好*的.
5. In the *Computer Management* window, right-click the partition you want to decrypt again and select *Format*. The *Format* window should appear. 
   在“*计算机管理”*窗口中，右键单击要再次解密的分区，然后选择 *格式*.应该出现“*格式”*窗口。
6. In the *Format* window, click *OK*. After the partition is formatted, it will no longer be required to  mount it with VeraCrypt to be able to save or load files to/from the  partition. 
   在“*格式”*窗口中，单击*“确定*”。分区格式化后，将不再需要使用VeraCrypt挂载分区，以便能够在分区中保存或加载文件。

- **If the volume is device-hosted
  如果卷由设备托管** 

> 1. Right-click the ‘*Computer*’ (or ‘*My Computer*’) icon on your desktop, or in the Start Menu, and select *Manage*. The ‘*Computer Management*’ window should appear. 
>    右键单击桌面上或开始菜单中的“*计算机*”（或“*我的电脑*”）图标，然后选择 *管好*。“*计算机管理*”窗口将出现。
> 2. In the *Computer Management* window, from the list on the left, select ‘*Disk Management*’ (within the *Storage* sub-tree). 
>    在“*计算机管理”*窗口中，从左侧的列表中选择“*磁盘管理*”（在 *存储*子树）。
> 3. The ‘*Initialize Disk*’ window should appear. Use it to initialize the disk. 
>    应出现“*初始化磁盘*”窗口。使用它来初始化磁盘。
> 4. In the ‘*Computer Management*’ window, right-click the area representing the storage space of the encrypted device and select ‘*New Partition*’ or ‘*New Simple Volume*’. 
>    在“*计算机管理*”窗口中，右键单击代表加密设备存储空间的区域，然后选择“*新建分区*”或“*新建简单卷*”。
> 5. WARNING: Before you continue, make sure you have selected the correct device, as all files stored on it will be lost. The ‘*New Partition Wizard*’ or ‘*New Simple Volume Wizard*’ window should appear now; follow its instructions to create a new partition on the device. After the  partition is created, it will no longer be required to mount the device  with VeraCrypt to be able to save or load files to/from the device. 
>    警告：继续之前，请确保您选择了正确的设备，因为存储在它上面的所有文件都将丢失。现在应该会出现“*新建分区向导*”或“*新建简单卷向导*”窗口;按照其说明在设备上创建新分区。创建分区后，就不再需要使用VeraCrypt挂载设备来保存文件或从设备加载文件。

# Uninstalling VeraCrypt 卸载VeraCrypt

To uninstall VeraCrypt on Windows XP, select *Start* menu > *Settings* > *Control Panel* > *Add or Remove Programs*> *VeraCrypt* > *Change/Remove*.
要在Windows XP上卸载VeraCrypt，选择*开始*菜单>*设置*> *控制面板*>*添加或删除程序*>*VeraCrypt*> *更改/删除*。

To uninstall VeraCrypt on Windows Vista or later, select *Start* menu > *Computer* > *Uninstall or change a program* > *VeraCrypt* > *Uninstall*.
要在Windows Vista或更高版本上卸载VeraCrypt，请选择*开始*菜单> *计算机*>*升级或更改程序*>*VeraCrypt*> *卸载*.

To uninstall VeraCrypt on Linux, you have to run the following command as  root: veracrypt-uninstall.sh. For example, on Ubuntu, you can type the  following in Terminal: sudo veracrypt-uninstall.sh
要在Linux上卸载VeraCrypt，您必须以root用户身份运行以下命令：veracrypt-uninstall.sh。例如，在Ubuntu上，您可以在终端中输入以下内容：sudo veracrypt-uninstall.sh

 No VeraCrypt volume will be removed when you uninstall VeraCrypt. You  will be able to mount your VeraCrypt volume(s) again after you install  VeraCrypt or when you run it in portable mode.
卸载VeraCrypt时不会删除任何VeraCrypt加密卷。在安装VeraCrypt之后或者在便携模式下运行时，您可以再次挂载您的VeraCrypt加密卷。

# Digital Signatures 数字签名

### Why Verify Digital Signatures 为什么要验证数字签名

It might happen that a VeraCrypt installation package you download from  our server was created or modified by an attacker. For example, the  attacker could exploit a vulnerability in the server software we use and alter the installation packages stored on the server, or he/she could alter any of the files en route to you.
您从我们的服务器下载的VeraCrypt安装包可能被攻击者创建或修改。例如，攻击者可以利用我们使用的服务器软件中的漏洞，并更改存储在 服务器，或者他/她可以改变任何文件的途中给你。
 
 Therefore, you should always verify the integrity and authenticity of  each VeraCrypt distribution package you download or otherwise obtain  from any source. In other words, you should always make sure that the  file was created by us and it was not altered by an attacker. One way to do so is to verify so-called digital  signature(s) of the file.
因此，您应该始终验证您下载或从任何来源获得的每个VeraCrypt分发包的完整性和真实性。换句话说，您应该始终确保文件是由我们创建的，并且没有被更改。 一个袭击者这样做的一种方法是验证文件的所谓数字签名。

### Types of Digital Signatures We Use 我们使用的数字签名类型

We currently use two types of digital signatures:
我们目前使用两种类型的数字签名：

- **PGP** signatures (available for all binary and source code packages for all supported systems). 
  **PGP**签名（适用于所有支持系统的所有二进制和源代码包）。
- **X.509** signatures (available for binary packages for Windows). 
  **X.509**签名（适用于Windows的二进制包）。

### Advantages of X.509 Signatures X.509签名的优势

X.509 signatures have the following advantages, in comparison to PGP signatures:
与PGP签名相比，X.509签名具有以下优点：

- It is much easier to verify that the key that signed the file is really ours (not attacker’s). 
  验证签名文件的密钥确实是我们的（而不是攻击者的）要容易得多。
- You do not have to download or install any extra software to verify an X.509 signature (see below). 
  您不必下载或安装任何额外的软件来验证X.509签名（见下文）。
- You do not have to download and import our public key (it is embedded in the signed file). 
  您不必下载和导入我们的公钥（它嵌入在签名文件中）。
- You do not have to download any separate signature file (the signature is embedded in the signed file). 
  您不必下载任何单独的签名文件（签名嵌入在签名文件中）。

### Advantages of PGP Signatures PGP签名的优势

PGP signatures have the following advantages, in comparison to X.509 signatures:
与X.509签名相比，PGP签名具有以下优点：

- They do not depend on any certificate authority (which might be e.g.  infiltrated or controlled by an adversary, or be untrustworthy for other reasons). 
  它们不依赖于任何证书颁发机构（例如，可能被对手渗透或控制，或者由于其他原因而不可信）。

### How to Verify X.509 Signatures 如何验证X.509签名

Please note that X.509 signatures are currently available only for the  VeraCrypt self-extracting installation packages for Windows. An X.509  digital signature is embedded in each of those files along with the  digital certificate of the VeraCrypt Foundation issued by a public certification authority. To verify the integrity and authenticity of a self-extracting installation package for Windows,  follow these steps:
请注意，X.509签名目前仅适用于Windows版VeraCrypt自解压安装包。X.509数字签名与由公共证书颁发机构颁发的VeraCrypt基金会数字证书一起沿着嵌入在每个文件中。要验证Windows自解压安装包的完整性和真实性，请执行以下步骤：

1. Download the VeraCrypt self-extracting installation package. 
   下载VeraCrypt自解压安装包。
2. In the Windows Explorer, click the downloaded file (‘*VeraCrypt Setup.exe*’) with the right mouse button and select ‘*Properties*’ from the context menu. 
   在Windows资源管理器中，用鼠标右键点击下载的文件（“*VeraCrypt Setup.exe*”），然后从上下文菜单中选择“*属性*”。
3. In the *Properties* dialog window, select the ‘*Digital Signatures*’ tab. 
   在“*属性”*对话框窗口中，选择“*数字签名*”选项卡。
4. On the ‘*Digital Signatures*’ tab, in the ‘*Signature list*’, double click the line saying "*IDRIX*" or *"IDRIX SARL"*. 
   在“*数字签名*”选项卡上的“*签名列表*”中，双击“*IDRIX*“或 *IDRIX SARL*
5. The ‘*Digital Signature Details*’ dialog window should appear now. If you see the following sentence at  the top of the dialog window, then the integrity and authenticity of the package have been successfully verified:
   现在应该会出现“*数字签名详细信息*”对话框窗口。如果您在对话框窗口的顶部看到以下句子，则已成功验证软件包的完整性和真实性：
    
    "*This digital signature is OK.*"
   “*这个数字签名没问题。*"
    
    If you do not see the above sentence, the file is very likely corrupted. Note: On some obsolete versions of Windows, some of the necessary  certificates are missing, which causes the signature verification to  fail. 
   如果您没有看到上面的句子，则文件很可能已损坏。注意：在某些过时的Windows版本上，缺少某些必要的证书，这会导致签名验证失败。

### How to Verify PGP Signatures 如何验证PGP签名

To verify a PGP signature, follow these steps:
要验证PGP签名，请执行以下步骤：

1. Install any public-key encryption software that supports PGP signatures. For Windows, you can download [Gpg4win](http://www.gpg4win.org/). For more information, you can visit https://www.gnupg.org/. 
   安装任何支持PGP签名的公钥加密软件。在Windows中，您可以下载[Gpg4win](http://www.gpg4win.org/)。欲了解更多信息，请访问https://www.gnupg.org/。

2. Create a private key (for information on how to do so, please see the documentation for the public-key encryption software).
   创建私钥（有关如何执行此操作的信息，请参阅公钥加密软件的文档）。

3. Download our PGP public key from 

   IDRIX

    website (

   https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key.asc

   ) or from a trusted public key repository (ID=0x680D16DE), and import the downloaded key to your keyring (for  information on how to do so, please see the documentation for the  public-key encryption software). Please check that its fingerprint is

   5069A233D55A0EEB174A5FC3821ACD02680D16DE

   .

   
   从**IDRIX**网站（https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key.asc）或可信的公钥存储库下载我们的PGP公钥 (ID= 0x 680 D16 DE），并将下载的密钥导入到您的密钥环（有关如何操作的信息，请参阅公钥加密软件的文档）。请检查其指纹是否 **5069A233D55A0EEB174A5FC3821ACD02680D16DE**。

   - For VeraCrypt version 1.22 and below, the verification must use the PGP public key available at https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key_2014.asc or from a trusted public key repository (ID=0x54DDD393), whose fingerprint is **993B7D7E8E413809828F0F29EB559C7C54DDD393**. 
     对于VeraCrypt 1.22及以下版本，验证必须使用https://www.idrix.fr/VeraCrypt/VeraCrypt_PGP_public_key_2014.asc上提供的PGP公钥或可信公钥库（ID=0x54DDD393），其指纹为**993B7D7E8E413809828F0F29EB559C7C54DDD393**。

4. Sign the imported key with your private key to mark it as trusted (for  information on how to do so, please see the documentation for the  public-key encryption software).
   使用您的私钥对导入的密钥进行签名，将其标记为受信任（有关如何执行此操作的信息，请参阅公钥加密软件的文档）。
    
    Note: If you skip this step and attempt to verify any of our PGP  signatures, you will receive an error message stating that the signing  key is invalid. 
   注意事项：如果您跳过此步骤并尝试验证我们的任何PGP签名，您将收到一条错误消息，指出签名密钥无效。

5. Download the digital signature by downloading the *PGP Signature* of the file you want to verify (on the [Downloads page](https://www.veracrypt.fr/en/Downloads.html)). 
   通过下载要验证的文件的*PGP签名来*下载数字签名（在[下载页面](https://www.veracrypt.fr/en/Downloads.html)上）。

6. Verify the downloaded signature (for information on how to do so, please see  the documentation for the public-key encryption software).
   验证下载的签名（有关如何执行此操作的信息，请参阅公钥加密软件的文档）。

Under Linux, these steps can be achieved using the following commands:
在Linux下，可以使用以下命令实现这些步骤：

- Check that the fingerprint of the public key is **5069A233D55A0EEB174A5FC3821ACD02680D16DE**:**gpg --import --import-options show-only VeraCrypt_PGP_public_key.asc** (for older gpg versions, type instead: **gpg --with-fingerprint VeraCrypt_PGP_public_key.asc**)
  检查公钥的指纹是否为**5069 A233 D55 A0 EEB 174 A5 FC 3821 ACD 02680 D16 DE**：**gpg --import --import-options show-only VeraCrypt_PGP_public_key.asc**（对于旧的gpg版本，键入： **VeraCrypt_PGP_public_key.asc**）
- If the fingerprint is the expected one, import the public key: **gpg --import VeraCrypt_PGP_public_key.asc**
  如果指纹是预期的指纹，导入公钥：**gpg --import VeraCrypt_PGP_public_key.asc**
- Verify the signature of the Linux setup archive (here for version 1.23):  **gpg --verify veracrypt-1.23-setup.tar.bz2.sig veracrypt-1.23-setup.tar.bz2**
  验证Linux安装归档文件的签名（此处为1.23版）：**gpg --verify veracrypt-1.23-setup.tar.bz2.sig veracrypt-1.23-setup.tar.bz2**

# Troubleshooting 故障排除

This section presents possible solutions to common problems that you may run into when using VeraCrypt.
本节介绍了您在使用VeraCrypt时可能遇到的常见问题的可能解决方案。

Note: If your problem is not listed here, it might be listed in one of the following sections:
注意：如果您的问题未在此处列出，则可能会在以下部分之一中列出：

- [Incompatibilities 不兼容](https://veracrypt.fr/en/Incompatibilities.html)
- [Known Issues & Limitations
  已知问题与限制](https://veracrypt.fr/en/Issues and Limitations.html)
- [Frequently Asked Questions
  常见问题](https://veracrypt.fr/en/FAQ.html)

Make sure you use the latest stable version of VeraCrypt. If the problem is caused by a bug in an old version of VeraCrypt, it may have already  been fixed. Note: Select ***Help*** > ***About*** to find out which version you use. 请确保您使用的是最新稳定版本的VeraCrypt。如果问题是由旧版本的VeraCrypt中的bug引起的，那么它可能已经被修复了。注意：选择 ***帮助***> ***看看***你用的是哪个版本。

 

------

**Problem:  问题：**

*Writing/reading to/from volume is very slow even though, according to the benchmark,  the speed of the cipher that I'm using is higher than the speed of the  hard drive.
写/阅读到/从卷是非常慢的，即使根据基准，我使用的密码的速度高于硬盘驱动器的速度。*

**Probable Cause:  可能原因：**

This is probably caused by an interfering application.
这可能是由干扰应用程序引起的。

**Possible Solution:  可能的解决方案：**

First, make sure that your VeraCrypt container does not have a file  extension that is reserved for executable files (for example, .exe,  .sys, or .dll). If it does, Windows and antivirus software may interfere with the container and adversely affect the performance of the volume.
首先，确保您的VeraCrypt容器没有为可执行文件保留的文件扩展名（例如，.exe，.sys或.dll）。如果出现这种情况，Windows和防病毒软件可能会干扰容器，并对卷的性能产生不利影响。

Second, disable or uninstall any application that might be interfering,  which usually is antivirus software or automatic disk defragmentation  tool, etc. In case of antivirus software, it often helps to turn off  real-time (on-access) scanning in the preferences of the antivirus software. If it does not help, try temporarily  disabling the virus protection software. If this does not help either,  try uninstalling it completely and restarting your computer  subsequently.
第二，禁用或卸载任何可能干扰的应用程序，通常是防病毒软件或自动磁盘碎片整理工具等。在防病毒软件的情况下，关闭防病毒软件首选项中的实时（访问时）扫描通常会有所帮助。如果没有帮助，请尝试暂时禁用病毒防护软件。如果这也没有帮助，请尝试完全卸载它，然后重新启动计算机。

------

**Problem:  问题：**

*VeraCrypt volume cannot be mounted; VeraCrypt reports "*Incorrect password or not a VeraCrypt volume*".*
*无法挂载VeraCrypt加密卷; VeraCrypt报告“*密码错误或不是VeraCrypt加密卷*“。*

**Possible Cause:  可能原因：**

The volume header may have been damaged by a third-party application or malfunctioning hardware component.
卷头可能已被第三方应用程序或故障硬件组件损坏。

**Possible Solutions:  可能的解决方案：**

- You can try to restore the volume header from the backup embedded in the volume by following these steps:

  
  您可以尝试通过以下步骤从卷中嵌入的备份恢复卷标头：

  1. Run VeraCrypt.  运行VeraCrypt。
  2. Click *Select Device* or  *Select File* to select your volume. 
     单击*选择设备*或*选择文件*以选择卷。
  3. Select *[Tools > Restore Volume Header](https://veracrypt.fr/en/Program Menu.html#tools-restore-volume-header)*. 
     选择*[工具>还原卷标题](https://veracrypt.fr/en/Program Menu.html#tools-restore-volume-header)*。

------

**Problem: 问题：**

*After successfully mounting a volume, Windows reports "*This device does not contain a valid file system*" or a similar error.*
*成功挂载卷后，Windows报告“*此设备不包含有效的文件系统*“或类似错误。*

**Probable Cause:  可能原因：**

The file system on the VeraCrypt volume may be corrupted (or the volume is unformatted).
VeraCrypt卷上的文件系统可能已损坏（或者卷未格式化）。

**Possible Solution:  可能的解决方案：**

You can use filesystem repair tools supplied with your operating system  to attempt to repair the filesystem on the VeraCrypt volume. In Windows, it is the '*chkdsk*' tool. VeraCrypt provides an easy way to use this tool on a VeraCrypt volume: First, make a backup copy of the VeraCrypt volume (because the '*chkdsk*' tool might damage the filesystem even more) and then mount it.  Right-click the mounted volume in the main VeraCrypt window (in the  drive list) and from the context menu select '*Repair Filesystem*'.
您可以使用操作系统提供的文件系统修复工具来尝试修复VeraCrypt卷上的文件系统。在Windows中，它是“*chkdsk*”工具。VeraCrypt提供了一个在VeraCrypt加密卷上使用此工具的简单方法：首先，创建一个VeraCrypt加密卷的备份（因为'*chkdsk*'工具可能会对文件系统造成更大的破坏），然后挂载它。在VeraCrypt主窗口中右键单击挂载的加密卷（在驱动器列表中），然后从上下文菜单中选择'*修复文件系统*'。

------

**Problem: 问题：**

*When trying to create a hidden volume, its maximum possible size is  unexpectedly small (there is much more free space than this on the outer volume).
当试图创建一个隐藏卷时，它的最大可能大小出乎意料地小（外部卷上的可用空间比这多得多）。*

**Probable Causes:  可能原因：**

1. The outer volume has been formatted as NTFS 
   外卷已格式化为
2. Fragmentation  碎片化
3. Too small cluster size + too many files/folders in the root directory of the outer volume. 
   群集太小+外部卷根目录中的文件/文件夹太多。

**Possible Solutions:  可能的解决方案：**

Solution Related to Cause 1:
原因1相关解决方案：

> Unlike the FAT filesystem, the NTFS filesystem always stores internal  data exactly in the middle of the volume. Therefore, the hidden volume  can reside only in the second half of the outer volume. If this  constraint is unacceptable, do one of the following:
> 与FAT文件系统不同，NTFS文件系统总是将内部数据精确地存储在卷的中间。因此，隐藏体积只能位于外部体积的第二半部分。如果此约束不可接受，请执行以下操作之一：
>
> - Reformat the outer volume as FAT and then create a hidden volume within it. 
>   将外部卷重新格式化为FAT，然后在其中创建一个隐藏卷。
> - If the outer volume is too large to be formatted as FAT, split the  volume to several 2-terabyte volumes (or 16-terabyte volumes if the  device uses 4-kilobyte sectors) and format each of them as FAT. 
>   如果外部卷太大，无法格式化为FAT，请将该卷拆分为几个2 TB的卷（如果设备使用4 TB扇区，则拆分为16 TB的卷），并将每个卷格式化为FAT。

Solution Related to Cause 2:
原因2相关解决方案：

> Create a new outer volume (defragmentation is not a solution, because it would adversely affect plausible deniability – see section [ Defragmenting](https://veracrypt.fr/en/Defragmenting.html)).
> 创建一个新的外部卷（碎片整理不是解决方案，因为它会对合理的可否认性产生不利影响-请参见 [碎片整理](https://veracrypt.fr/en/Defragmenting.html)）。

Solution Related to Cause 3:
原因3相关解决方案：

> Note: The following solution applies only to hidden volumes created within FAT volumes.
> 注意：以下解决方案仅适用于在FAT卷中创建的隐藏卷。
>
> Defragment the outer volume (mount it, right-click its drive letter in the '*Computer*' or '*My Computer*' window, click *Properties*, select the  *Tools* tab, and click '*Defragment Now*'). After the volume is defragmented, exit *Disk Defragmenter* and try to create the hidden volume again. 
> 对外部卷进行碎片整理（挂载它，在“*计算机*”或“*我的电脑*”窗口中右键单击它的驱动器号，单击 *属性*，选择*工具*选项卡，然后单击“*立即碎片整理*”）。对卷进行碎片整理后，退出 *磁盘碎片整理程序*并尝试再次创建隐藏卷。
>  
>  If this does not help, delete *all* files and folders on the outer volume by pressing Shift+Delete, not by  formatting, (do not forget to disable the Recycle Bin and System Restore for this drive beforehand) and try creating the hidden volume on this *completely empty* outer volume again (for testing purposes only). If the maximum possible size  of the hidden volume does not change even now, the cause of the problem  is very likely an extended root directory. If you did not use the '*Default*' cluster size (the last step in the Wizard), reformat the outer volume and this time leave the cluster size at '*Default*'.
> 如果这没有帮助，请按Shift+Delete删除外部卷上*的所有*文件和文件夹，而不是格式化，（不要忘记事先禁用此驱动器的回收站和系统还原），并尝试创建 隐藏卷在这个*完全空的*外部卷再次（仅用于测试目的）。如果隐藏卷的最大可能大小即使现在也没有改变，那么问题的原因很可能是扩展的根目录。 如果您没有使用“*默认*”群集大小（向导中的最后一步），请重新格式化外部卷，这次将群集大小保留为“*默认*”。
>
> If it does not help, reformat the outer volume again and copy less  files/folders to its root folder than you did last time. If it does not  help, keep reformatting and decreasing the number of files/folders in  the root folder. If this is unacceptable or if it does not help, reformat the outer volume and select a larger cluster  size. If it does not help, keep reformatting and increasing the cluster  size, until the problem is solved. Alternatively, try creating a hidden  volume within an NTFS volume.
> 如果没有帮助，请再次格式化外部卷，并将比上次更少的文件/文件夹复制到其根文件夹。如果没有帮助，请继续重新格式化并减少根文件夹中的文件/文件夹数量。如果这是不可接受的或没有帮助，请重新格式化外部卷并选择更大的集群大小。如果没有帮助，请继续重新格式化并增加群集大小，直到问题得到解决。或者，尝试在加密卷中创建隐藏卷。

------

**Problem:  问题：**

One of the following problems occurs:
出现以下问题之一：

- A VeraCrypt volume cannot be mounted. 
  VeraCrypt加密卷无法挂载。
- NTFS VeraCrypt volumes cannot be created. 
  无法创建VeraCrypt加密卷。

In addition, the following error may be reported: "*The process cannot access the file because it is being used by another process.*"
此外，可能会报告以下错误：“*进程无法访问该文件，因为它正被另一个进程使用。*"

**Probable Cause:  可能原因：**

This is probably caused by an interfering application. Note that this is not a bug in VeraCrypt. The operating system reports to VeraCrypt that  the device is locked for an exclusive access by an application (so  VeraCrypt is not allowed to access it).
这可能是由干扰应用程序引起的。请注意，这不是VeraCrypt中的一个bug。操作系统向VeraCrypt报告设备已被锁定，应用程序无法访问（因此VeraCrypt无法访问）。

**Possible Solution:  可能的解决方案：**

It usually helps to disable or uninstall the interfering application,  which is usually an anti-virus utility, a disk management application,  etc.
它通常有助于禁用或卸载干扰应用程序，通常是反病毒实用程序，磁盘管理应用程序等。

------

**Problem:  问题：**

*In the VeraCrypt Boot Loader screen, I'm trying to type my password and/or pressing other keys but the VeraCrypt boot loader is not responding.
在VeraCrypt靴子加载程序界面，我尝试输入密码和/或按其他键，但是VeraCrypt靴子加载程序没有响应。*

**Probable Cause:  可能原因：**

You have a USB keyboard (not a PS/2 keyboard) and pre-boot support for USB keyboards is disabled in your BIOS settings.
您有一个USB键盘（不是PS/2键盘），并且在BIOS设置中禁用了对USB键盘的预引导支持。

**Possible Solution:  可能的解决方案：**

You need to enable pre-boot support for USB keyboards in your BIOS settings. To do so, follow the below steps:
您需要在BIOS设置中启用USB键盘的预引导支持。要执行此操作，请执行以下步骤：

Restart your computer, press F2 or Delete (as soon as you see a BIOS  start-up screen), and wait until a BIOS configuration screen appears. If no BIOS configuration screen appears, restart (reset) the computer  again and start pressing F2 or Delete repeatedly as soon as you restart (reset) the computer. When a BIOS configuration  screen appears, enable pre-boot support for USB keyboards. This can  typically be done by selecting: *Advanced* > '*USB Configuration*' > '*Legacy USB Support*' (or '*USB Legacy*') > *Enabled*. (Note that the word 'legacy' is in fact misleading, because pre-boot  components of modern versions of MS Windows require this option to be  enabled to allow user interaction/control.) Then save the BIOS settings  (typically by pressing F10) and restart your computer. For more information,  please refer to the documentation for your BIOS/motherboard or contact  your computer vendor's technical support team for assistance.
重新启动计算机，按F2或Delete（一旦看到BIOS启动屏幕），然后等待BIOS配置屏幕出现。如果没有BIOS配置屏幕出现，重新启动（重置）计算机，并开始反复按F2或Delete 重新启动（重置）计算机。当BIOS配置屏幕出现时，启用USB键盘的预引导支持。这通常可以通过选择来完成： *高级*>“*USB配置*”>“*传统USB支持*”（或“*USB传统*”）> *启用*. (Note“遗留”这个词实际上是误导，因为现代版本的MS  Windows的预引导组件需要启用此选项以允许用户交互/控制。然后保存BIOS设置（通常按F10）并重新启动计算机。有关详细信息，请参阅BIOS/主板的文档，或联系计算机供应商的技术支持团队寻求帮助。

------

**Problem:  问题：**

*After the system partition/drive is encrypted, the computer cannot boot after it is restarted (it is also impossible to enter the BIOS configuration  screen).
系统分区/驱动器加密后，电脑重新启动后无法靴子（也无法进入BIOS配置画面）。*

**Probable Cause: 可能原因：**

A bug in the BIOS of your computer.
你电脑BIOS里的一个bug。

**Possible Solutions:  可能的解决方案：**

Follow these steps: 请执行下列步骤：

1. Disconnect the encrypted drive. 
   断开加密驱动器的连接。
2. Connect an unencrypted drive with an installed operating system (or install it on the drive). 
   将未加密的驱动器与已安装的操作系统连接（或将其安装在驱动器上）。
3. Upgrade the BIOS.  升级BIOS。
4. If it does not help, please report this bug to the manufacturer or vendor of the computer. 
   如果没有帮助，请向计算机的制造商或供应商报告此错误。

OR 或

- If the BIOS/motherboard/computer manufacturer/vendor does not provide  any updates that resolve the issue and you use Windows 7 or later and  there is an extra boot partition (whose size is less than 1 GB) on the  drive, you can try reinstalling Windows without this extra boot partition (to work around a bug in the BIOS). 
  如果BIOS/主板/计算机制造商/供应商未提供任何更新来解决此问题，并且您使用的是Windows 7或更高版本，并且驱动器上有额外的靴子分区（其大小小于1 GB），则可以尝试重新安装Windows，而不使用此额外的靴子分区（以解决BIOS中的错误）。

------

**Problem:  问题：**

One of the following problems occurs:
出现以下问题之一：

- *After the pre-boot authentication password is entered during the system  encryption pretest, the computer hangs (after the message '*Booting...*' is displayed).*
  *在系统加密预测试期间输入预引导身份验证密码后，计算机挂起（在出现“*正在引导. *”显示）。*
- *When the system partition/drive is encrypted (partially or fully) and the  system is restarted for the first time since the process of encryption  of the system partition/drive started, the computer hangs after you  enter the pre-boot authentication password (after the message '*Booting...*' is displayed).*
  *当系统分区/驱动器被加密（部分或全部），并重新启动系统的第一次，因为系统分区/驱动器的加密过程开始，计算机挂起后，您输入预启动身份验证密码（后消息'*引导. *”显示）。*
- *After the hidden operating system is cloned and the password for it entered, the computer hangs (after the message '*Booting...' *is displayed).*
  *在克隆隐藏的操作系统并输入密码后，计算机挂起（在消息“*启动.”*显示）。*

**Probable Cause:  可能原因：**

A bug in the BIOS of your computer or an issue with Windows bootloader.
计算机BIOS中的错误或Windows引导加载程序的问题。

**Possible Solution: 可能的解决方案：**

- Upgrade your BIOS (for information on how to do so, please refer to the  documentation for your BIOS/motherboard or contact your computer  vendor's technical support team for assistance). 
  升级您的BIOS（有关如何升级的信息，请参阅您的BIOS/主板的文档或联系您的计算机供应商的技术支持团队以获得帮助）。

- Use a different motherboard model/brand. 
  使用不同的主板型号/品牌。

- If the BIOS/motherboard/computer manufacturer/vendor does not provide  any updates that resolve the issue and you use Windows 7 or later and  there is an extra boot partition (whose size is less than 1 GB) on the  drive, you can try reinstalling Windows without this extra boot partition (to work around a bug in the BIOS). 
  如果BIOS/主板/计算机制造商/供应商未提供任何更新来解决此问题，并且您使用的是Windows 7或更高版本，并且驱动器上有额外的靴子分区（其大小小于1 GB），则可以尝试重新安装Windows，而不使用此额外的靴子分区（以解决BIOS中的错误）。

- There two other known workarounds for this issue that require having a Windows Installation disk:

  
  此问题的其他两种已知解决方法需要Windows安装磁盘：

  - Boot your machine using a Windows Installation disk and select to repair your computer. Choose "Command Prompt" option and when it opens, type  the commands below and then restart your system:

    
    使用Windows安装盘靴子引导计算机，然后选择修复计算机。选择“命令提示符”选项，当它打开时，键入下面的命令，然后重新启动系统：

    - BootRec /fixmbr 
    - BootRec /FixBoot 

  - Delete the 100 MB System Reserved partition located at the beginning of  your drive, set the system partition next to it as the active partition  (both can be done using diskpart utility available in Windows  Installation disk repair option). After that, run Startup Repair after rebooting on Windows Installation disk. The following link contains detailed instructions: [ https://www.sevenforums.com/tutorials/71363-system-reserved-partition-delete.html](https://www.sevenforums.com/tutorials/71363-system-reserved-partition-delete.html)
    删除位于驱动器开头的100 MB系统保留分区，将其旁边的系统分区设置为活动分区（两者都可以使用Windows安装磁盘修复选项中提供的diskpart实用程序完成）。之后，运行Startup 在Windows安装磁盘上重新启动后进行修复。以下链接包含详细说明： https://www.sevenforums.com/tutorials/71363-system-reserved-partition-delete.html

------

**Problem:  问题：**

*When trying to encrypt the system partition/drive, during the pretest, the  VeraCrypt Boot Loader always reports that the pre-boot authentication  password I entered is incorrect (even though I'm sure it is correct).
当尝试加密系统分区/驱动器时，在预测试期间，VeraCrypt靴子加载程序总是报告我输入的预靴子验证密码不正确（即使我确信它是正确的）。*

**Possible Causes: 可能的原因：**

- Different state of the *Num Lock* and/or  *Caps Lock* key 
  *大写锁定键*和/或*大写锁定*键的不同状态
- Data corruption  数据损坏

**Possible Solution:  可能的解决方案：**

1. When you *set* a pre-boot authentication password, remember whether the *Num Lock* and *Caps Lock* keys are on or off (depending on the manufacturer, the keys may have different labels, such as *Num LK*). Note: You can change the state of each of the keys as desired before  you set the password, but you need to remember the states. 
   *设置*预引导身份验证密码时，请记住 *Caps Lock*和*Caps Lock*键打开或关闭（取决于制造商，这些键可能有不同的标签，例如 *（图*）。注意：您可以在设置密码之前根据需要更改每个键的状态，但您需要记住这些状态。
2. When you enter the password in the VeraCrypt Boot Loader screen, make  sure the state of each of the keys is the same as when you set the  password. 
   当您在VeraCrypt靴子加载程序界面中输入密码时，请确保每个密钥的状态与您设置密码时的状态相同。

Note: For other possible solutions to this problem, see the other sections of this chapter.
注：有关此问题的其他可能解决方案，请参阅本章的其他部分。

------

**Problem: 问题：**

*When the system partition/drive is encrypted, the operating system 'freezes' for approx. 10-60 seconds every 5-60 minutes (100% CPU usage may  co-occur).
当系统分区/驱动器被加密时，操作系统会“冻结”大约10分钟。每5-60分钟10-60秒（可能同时发生100% CPU使用率）。*

**Probable Cause:  可能原因：**

A CPU and/or motherboard issue.
CPU和/或主板问题。

**Possible Solutions:  可能的解决方案：**

- Try disabling all power-saving-related features (including any special  CPU enhanced halt functions) in the BIOS settings and in the 'Power  Options' Windows control panel. 
  尝试在BIOS设置和“电源选项”Windows控制面板中禁用所有与节能相关的功能（包括任何特殊的CPU增强暂停功能）。
- Replace the processor with a different one (different type and/or brand). 
  更换不同的处理器（不同类型和/或品牌）。
- Replace the motherboard with a different one (different type and/or brand). 
  更换主板（不同类型和/或品牌）。

------

**Problem: 问题：**

*When mounting or dismounting a VeraCrypt volume, the system crashes (a 'blue screen' error screen appears or the computer abruptly restarts).
安装或卸载VeraCrypt加密卷时，系统崩溃（出现“蓝屏”错误屏幕或 计算机突然重启）。*

OR 或

*Since I installed VeraCrypt, the operating system has been crashing frequently.
自从我安装VeraCrypt后，操作系统经常崩溃。*

**Possible Causes:  可能的原因：**

- A bug in a third-party application (e.g. antivirus, system "tweaker", driver, etc.) 
  第三方应用程序中的错误（例如防病毒、系统“调整程序”、驱动程序等）
- A bug in VeraCrypt  VeraCrypt中的一个bug
- A bug in Windows or a malfunctioning hardware component 
  Windows中的错误或硬件组件故障

**Possible Solutions:  可能的解决方案：**

- Try disabling any antivirus tools, system "tweakers", and any other  similar applications. If it does not help, try uninstalling them and  restarting Windows. 
  尝试禁用任何防病毒工具，系统“调整器”，以及任何其他类似的应用程序。如果没有帮助，请尝试卸载它们并重新启动Windows。
   
   If the problem persists, run VeraCrypt and select *Help* > '*Analyze a System Crash*' shortly after the system crashes or restarts. VeraCrypt will then  analyze crash dump files that Windows automatically created when it crashed (if any). If VeraCrypt determines that a bug in a third party driver is likely to have caused the crash, it will show  the name and provider of the driver (note that updating or uninstalling  the driver might resolve the issue). Whatever the results, you will be able to choose to send us essential  information about the system crash to help us determine whether it was  caused by a bug in VeraCrypt. 
  如果问题仍然存在，请在系统崩溃或重启后立即运行VeraCrypt并选择*帮助*>“*分析系统崩溃*”。VeraCrypt将分析Windows自动生成的崩溃转储文件 当它被创造出来的时候，如果VeraCrypt确定第三方驱动程序中的错误可能导致崩溃，它将显示驱动程序的名称和提供商（请注意，更新或卸载驱动程序可能会解决问题）。无论 如果您没有收到任何关于系统崩溃的信息，您可以选择向我们发送有关系统崩溃的重要信息，以帮助我们确定是否由VeraCrypt中的错误引起。

------

**Problem: 问题：**

*On Windows 7/Vista (and possibly later versions), the Microsoft Windows  Backup tool cannot be used to backup data to a non-system VeraCrypt  Volume.
在Windows 7/Vista（可能还有更高版本）上，Microsoft Windows备份工具不能用于将数据备份到非系统VeraCrypt加密卷。*

**Cause:  原因：**

A bug in the Windows Backup tool.
Windows备份工具中的一个错误。

**Possible Solution:  可能的解决方案：**

1. Mount the VeraCrypt volume to which you want to back up data. 
   挂载您想要备份数据的VeraCrypt加密卷。
2. Right-click a folder located on the volume (or right-click its drive letter in the '*Computer*' list) and select an item from the '*Share with*' submenu (on Windows Vista, select '*Share*'). 
   右键单击卷上的文件夹（或在“*计算机*”列表中右键单击其驱动器号），然后从“*共享对象”*选项卡中选择一个项目（在Windows Vista上，选择“*共享*”）。
3. Follow the instructions to share the folder with your user account. 
   按照说明与您的用户帐户共享文件夹。
4. In the Windows Backup tool, select the shared folder (the network location/path) as the destination. 
   在Windows备份工具中，选择共享文件夹（网络位置/路径）作为目标。
5. Start the backup process. 
   启动备份过程。

Note: The above solution does not apply to the *Starter* and *Home* editions of Windows 7 (and possibly later versions).
注：上述解决方案不适用于*Starter*， Windows 7的*家庭*版（可能还有更高版本）。

------

**Problem: 问题：**

*The label of a filesystem in a VeraCrypt volume cannot be changed from  within the 'Computer' window under Windows Vista or a later version of  Windows.
VeraCrypt卷中文件系统的标签不能在Windows Vista或更高版本的Windows下的“计算机”窗口中更改。*

**Cause:  原因：**

A Windows issue causes the label to be written only to the Windows registry file, instead of being written to the filesystem.
Windows问题导致标签仅写入Windows注册表文件，而不是写入文件系统。

**Possible Solutions:  可能的解决方案：**

- Right-click the mounted volume in the '*Computer*' window, select *Properties*, and enter a new label for the volume. 
  在“*计算机*”窗口中右键单击已装入的卷，选择 *属性*，然后输入卷的新标签。

------

**Problem:  问题：**

*I cannot encrypt a partition/device because VeraCrypt Volume Creation Wizard says it is in use.
我无法加密分区/设备，因为VeraCrypt加密卷创建向导说它正在使用中。*

**Possible Solution:  可能的解决方案：**

Close, disable, or uninstall all programs that might be using the  partition/device in any way (for example an anti-virus utility). If it  does not help, right-click the '*Computer*' (or '*My Computer*') icon on your desktop and select *Manage* -> *Storage* -> *Disk Management.* Then right-click the partition that you want to encrypt, and click *Change Drive Letter and Paths.* Then click  *Remove* and *OK.* Restart the operating system.
关闭、禁用或卸载可能以任何方式使用分区/设备的所有程序（例如防病毒实用程序）。如果没有帮助，请右键单击桌面上的“*计算机*”（或“*我的电脑*”）图标，然后选择*管理*->*存储*->*磁盘管理。*然后右键单击要加密的分区，并单击 *更改驱动器号和路径。*然后单击*删除*和*确定。*重新启动操作系统。

------

**Problem:  问题：**

*When creating a hidden volume, the Wizard reports that the outer volume cannot be locked.
创建隐藏卷时，向导报告无法锁定外部卷。*

**Probable Cause:  可能原因：**

The outer volume contains files being used by one or more applications.
外部卷包含一个或多个应用程序正在使用的文件。

**Possible Solution:  可能的解决方案：**

Close all applications that are using files on the outer volume. If it  does not help, try disabling or uninstalling any anti-virus utility you  use and restarting the system subsequently.
关闭所有使用外部卷上文件的应用程序。如果没有帮助，请尝试禁用或卸载您使用的任何防病毒实用程序，然后重新启动系统。

------

**Problem:  问题：**

When accessing a file-hosted container shared over a network, you receive one or both of the following error messages: 
访问通过网络共享的文件托管容器时，您会收到以下一条或两条错误消息：
 "*Not enough server storage is available to process this command.*" and/or,
“*没有足够的服务器存储来处理此命令。*“和/或，
 "*Not enough memory to complete transaction.*"
“*内存不足，无法完成交易。*"

**Probable Cause:  可能原因：**

*IRPStackSize* in the Windows registry may have been set to a too small value.
Windows注册表中*的IRPStackSize*可能设置为太小的值。

**Possible Solution:  可能的解决方案：**

Locate the *IRPStackSize* key in the Windows registry and set it to a higher value. Then restart the  system. If the key does not exist in the Windows registry, create it at *HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters* and set its value to 16 or higher. Then restart the system. For more information, see: [ https://support.microsoft.com/kb/285089/ ](https://support.microsoft.com/kb/285089/)and [ https://support.microsoft.com/kb/177078/](https://support.microsoft.com/kb/177078/)
在Windows注册表中找到*IRPStackSize*项并将其设置为更高的值。然后重新启动系统。如果Windows注册表中不存在该键，请在以下位置创建它 *HKEY_BLOCK_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters*并将其值设置为16或更高。然后重新启动系统。如需详细信息，请参阅： https://support.microsoft.com/kb/285089/和https://support.microsoft.com/kb/177078/

------

# Incompatibilities 不兼容

## Activation of Adobe Photoshop® and Other Products Using FLEXnet Publisher® / SafeCast 使用FLEXnet Publisher® / Safecast激活Adobe Photoshop®和其他产品

*Note: The issue described below does  **not** affect you if you use a non-cascade encryption algorithm (i.e., AES, Serpent, or Twofish).\* The issue also does **not** affect you if you do not use [ system encryption](https://veracrypt.fr/en/System Encryption.html) (pre-boot authentication).
注意：如果您使用非级联加密算法（即，AES、Serpent或Twofish）。这个问题也 如果您不使用[系统加密](https://veracrypt.fr/en/System Encryption.html)（预引导身份验证）**，则不会**影响您。*

Acresso FLEXnet Publisher activation software, formerly Macrovision  SafeCast, (used for activation of third-party software, such as Adobe  Photoshop) writes data to the first drive track. If this happens when  your system partition/drive is encrypted by VeraCrypt, a portion of the VeraCrypt Boot Loader will be damaged and you will not be able to start Windows. In that case, please use your [ VeraCrypt Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html) to regain access to your system. There are two ways to do so:
Acresso FLEXnet Publisher激活软件（以前称为Macrovision SafeCast）（用于激活第三方软件，如Adobe  Photoshop）将数据写入第一个驱动器磁道。如果在您的系统分区/驱动器被VeraCrypt加密时发生这种情况， VeraCrypt靴子Loader的一部分将被损坏，您将无法启动Windows。如果是这样的话，请使用 [VeraCrypt Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)重新访问您的系统。有两种方法可以做到这一点：

1. You may keep the third-party software activated but you will need to boot your system from the VeraCrypt Rescue Disk CD/DVD *every time*. Just insert your Rescue Disk into your CD/DVD drive and then enter your password in the Rescue Disk screen. 
   您可以保持第三方软件的激活状态，但您需要从VeraCrypt救援盘CD/DVD靴子引导系统 每次只需将救援盘插入CD/DVD驱动器，然后在救援盘屏幕中输入密码。
2. If you do not want to boot your system from the VeraCrypt Rescue Disk  CD/DVD every time, you can restore the VeraCrypt Boot Loader on the  system drive. To do so, in the Rescue Disk screen, select *Repair Options* >  *Restore VeraCrypt Boot Loader*. However, note that this will deactivate the third-party software. 
   如果您不想每次都从VeraCrypt救援盘CD/DVD靴子系统，您可以在系统驱动器上恢复VeraCrypt靴子Loader。要执行此操作，请在救援盘屏幕中选择 *修复选项*>*恢复VeraCrypt靴子加载程序*。但是，请注意，这将停用第三方软件。

For information on how to use your VeraCrypt Rescue Disk, please see the chapter [ VeraCrypt Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html).
有关如何使用VeraCrypt救援盘的信息，请参阅[VeraCrypt救援盘](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)一章。

**Possible permanent solution**: decrypt the system partition/drive, and then re-encrypt it using a  non-cascade encryption algorithm (i.e., AES, Serpent, or Twofish).*
**可能的永久解决方案**：解密系统分区/驱动器，然后使用非级联加密算法（即，AES、Serpent或Twofish）。

Please note that this not a bug in VeraCrypt (the issue is caused by  inappropriate design of the third-party activation software).
请注意，这不是VeraCrypt中的一个bug（该问题是由第三方激活软件的设计不当引起的）。

## Outpost Firewall and Outpost Security Suite Outpost防火墙和Outpost安全套件

If Outpost Firewall or Outpost Security Suite is installed with  Proactive Protection enabled, the machine freezes completely for 5-10  seconds during the volume mount/dismount operation. This is caused by a  conflict between Outpost System Guard option that protects "Active  Desktop" objects and VeraCrypt waiting dialog displayed during  mount/dismount operations.
如果Outpost Firewall或Outpost Security  Suite安装时启用了主动防护，则在卷装载/卸载操作期间，计算机将完全冻结5-10秒。这是由于保护“Active  Desktop”对象的Outpost系统防护选项与挂载/解密操作期间显示的VeraCrypt等待对话框之间的冲突造成的。

A workaround that fixes this issue is to disable VeraCrypt waiting  dialog in the Preferences: use menu "Settings -> Preferences" and  check the option "Don't show wait message dialog when performing  operations".
解决这个问题的一个方法是在首选项中禁用VeraCrypt等待对话框：使用菜单“设置->首选项”并选中“执行操作时不显示等待消息对话框”选项。

More information can be found at https://sourceforge.net/p/veracrypt/tickets/100/
更多信息请访问https://sourceforge.net/p/veracrypt/tickets/100/

------

\* The reason is that the VeraCrypt Boot Loader is smaller than the one  used for cascades of ciphers and, therefore, there is enough space in  the first drive track for a backup of the VeraCrypt Boot Loader. Hence, whenever the VeraCrypt Boot Loader is damaged, its  backup copy is run automatically instead.
\* 原因是VeraCrypt靴子Loader比用于密码级联的要小，因此第一个磁盘磁道中有足够的空间来备份VeraCrypt靴子Loader。因此，每当VeraCrypt靴子Loader损坏时，它的备份副本会自动运行。

 

# Known Issues & Limitations 已知问题与限制

### Known Issues 已知问题

- On Windows, it may happen that two drive letters are assigned to a mounted volume instead of a single one. This is caused by an issue with Windows Mount Manager cache and it can be solved by typing the command "

  mountvol.exe /r

  " in an elevated command prompt (run as an administrator) before mounting any volume. If the issue persists after rebooting, the following procedure can be used to solve it:

  
  在Windows上，可能会发生两个驱动器号被分配给一个挂载的卷，而不是一个单一的。这是由Windows装载管理器缓存的问题引起的，可以通过在提升的 命令提示符（以管理员身份运行）。如果重新启动后问题仍然存在，可使用以下步骤解决：

  - Check the registry key "HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices" using  regedit. Scroll down and you'll find entries starting with  "\DosDevices\" or "\Global??\" which indicate the drive letters that are taken by the system. Before mounting any volume, double click on each one and remove the ones contains the name  "VeraCrypt" and "TrueCrypt". 
    使用regedit检查注册表项“HKEY_MACHINE\SYSTEM\MountedDevices”。向下滚动，您会发现以“\DosDevices\”或“\Global？？\”开头的条目“，指示系统采用的驱动器号。在装入任何卷之前， 双击每一个并删除包含名称“VeraCrypt”和“TrueCrypt”的。
     Also, there are other entries whose name start with "#{" and  "\??\Volume{": double click on each one of them and remove the ones  whose data value contains the name "VeraCrypt" and "TrueCrypt". 
    此外，还有其他名称以“#{”和“\？？\"开头的条目Volume{"：双击每一个加密卷并删除其数据值包含名称“VeraCrypt”和“TrueCrypt”的加密卷。

- On some Windows machines, VeraCrypt may hang intermittently when mounting  or dismounting a volume. Similar hanging may affect other running  applications during VeraCrypt mounting or dismounting operations. This issue is caused by a conflict between VeraCrypt waiting dialog  displayed during mount/dismount operations and other software installed  on the machine (e.g. Outpost Firewall Pro). In such situations, the issue can be solved by disabling VeraCrypt  waiting dialog in the Preferences: use menu "Settings -> Preferences" and check the option "Don't show wait message dialog when performing  operations". 
  在某些Windows机器上，VeraCrypt在挂载或卸载卷时可能会间歇性挂起。类似的挂起可能会在VeraCrypt挂载或卸载操作期间影响其他正在运行的应用程序。这个问题是由挂载/卸载操作中显示的VeraCrypt等待对话框和机器上安装的其他软件（例如Outpost Firewall  Pro）之间的冲突引起的。在这种情况下，这个问题可以通过在首选项中禁用VeraCrypt等待对话框来解决：使用菜单“设置->首选项”并选中“执行操作时不显示等待消息对话框”选项。

### Limitations 限制

- [*Note: This limitation does not apply to users of Windows Vista and later versions of Windows.*] On Windows XP/2003, VeraCrypt does not support encrypting an entire  system drive that contains extended (logical) partitions. You can  encrypt an entire system drive provided that it contains only primary partitions.  Extended (logical) partitions must not be created on any system drive  that is partially or fully encrypted (only primary partitions may be  created on it). *Note*: If you need to encrypt an entire drive containing extended partitions,  you can encrypt the system partition and, in addition, create  partition-hosted VeraCrypt volumes within any non- system partitions on  the drive. Alternatively, you may want to consider upgrading to Windows Vista or a later version of Windows. 
  [*注意：此限制不适用于Windows Vista和更高版本的Windows用户。*在Windows XP/2003上，VeraCrypt不支持加密包含扩展（逻辑）分区的整个系统驱动器。您可以加密整个 系统驱动器，前提是它只包含主分区。扩展（逻辑）分区不能在任何部分或完全加密的系统驱动器上创建（只能在其上创建主分区）。 *注意*：如果您需要加密包含扩展分区的整个驱动器，您可以加密系统分区，此外，还可以在驱动器上的任何非系统分区中创建分区托管的VeraCrypt卷。或者，您可能需要考虑升级到Windows Vista或更高版本的Windows。

- VeraCrypt currently does not support encrypting a system drive that has been converted to a dynamic disk. 
  VeraCrypt目前不支持加密已转换为动态磁盘的系统驱动器。

- To work around a Windows XP issue, the VeraCrypt boot loader is always  automatically configured for the version of the operating system under  which it is installed. When the version of the system changes (for  example, the VeraCrypt boot loader is installed when Windows Vista is running but it is later used to boot Windows XP)  you may encounter various known and unknown issues (for example, on some notebooks, Windows XP may fail to display the log-on screen). Note that this affects multi-boot configurations, VeraCrypt Rescue Disks, and decoy/hidden operating systems (therefore,  if the hidden system is e.g. Windows XP, the decoy system should be  Windows XP too). 
  为了解决Windows  XP问题，VeraCrypt靴子加载程序总是自动配置为安装它的操作系统版本。当系统版本发生变化时（例如，VeraCrypt靴子加载程序在Windows Vista运行时安装，但后来用于靴子Windows XP），您可能会遇到各种已知和未知的问题（例如，在某些笔记本电脑上，Windows  XP可能无法显示登录屏幕）。请注意，这会影响多重启动配置、VeraCrypt  Rescue和诱饵/隐藏操作系统（因此，如果隐藏系统是Windows XP，诱饵系统也应该是Windows XP）。

- The ability to mount a partition that is within the key scope of system  encryption without pre- boot authentication (for example, a partition  located on the encrypted system drive of another operating system that  is not running), which can be done e.g. by selecting *System* > *Mount Without Pre-Boot Authentication,* is limited to primary partitions (extended/logical partitions cannot be mounted this way). 
  在没有预靴子身份验证的情况下挂载系统加密的密钥范围内的分区（例如，位于未运行的另一个操作系统的加密系统驱动器上的分区）的能力（例如，可以通过选择*系统*>*挂载而没有预靴子身份验证）*仅限于主分区（扩展/逻辑分区不能以这种方式挂载）。

- Due to a Windows 2000 issue, VeraCrypt does not support the Windows Mount  Manager under Windows 2000. Therefore, some Windows 2000 built-in tools, such as Disk Defragmenter, do not work on VeraCrypt volumes.  Furthermore, it is not possible to use the Mount Manager services under Windows 2000, e.g., assign a mount point to a  VeraCrypt volume (i.e., attach a VeraCrypt volume to a folder). 
  由于Windows 2000的问题，VeraCrypt不支持Windows 2000下的挂载管理器。因此，某些Windows  2000内置工具，如磁盘碎片整理程序，不能在VeraCrypt加密卷上工作。此外，无法在Windows 2000下使用Mount  Manager服务，例如，为VeraCrypt卷分配挂载点（即，将VeraCrypt加密卷附加到文件夹）。

- VeraCrypt does not support pre-boot authentication for operating systems  installed within VHD files, except when booted using appropriate  virtual-machine software such as Microsoft Virtual PC. 
  VeraCrypt不支持安装在VHD文件中的操作系统的预启动认证，除非使用适当的虚拟机软件（如Microsoft Virtual PC）启动。

- The Windows Volume Shadow Copy Service is currently supported only for  partitions within the key scope of system encryption (e.g. a system  partition encrypted by VeraCrypt, or a non- system partition located on a system drive encrypted by VeraCrypt, mounted when the encrypted operating system is running). Note: For other types  of volumes, the Volume Shadow Copy Service is not supported because the  documentation for the necessary API is not available. 
  Windows卷影复制服务目前仅支持系统加密密钥范围内的分区（例如，由VeraCrypt加密的系统分区，或位于由VeraCrypt加密的系统驱动器上的非系统分区，当加密操作系统运行时安装）。注意：对于其他类型的卷，不支持卷影复制服务，因为没有必要的API文档。

- Windows boot settings cannot be changed from within a hidden operating system  if the system does not boot from the partition on which it is installed. This is due to the fact that, for security reasons, the boot partition  is mounted as read-only when the hidden system is running. To be able to change the boot settings,  please start the decoy operating system. 
  如果系统不是从安装了Windows启动设置的分区靴子，则无法从隐藏的操作系统中更改Windows靴子设置。这是因为出于安全原因，当隐藏系统运行时，靴子分区被挂载为只读。为了能够更改靴子设置，请启动诱饵操作系统。

- Encrypted partitions cannot be resized except partitions on an entirely encrypted system drive that are resized while the encrypted operating system is  running. 
  加密分区不能调整大小，但完全加密的系统驱动器上的分区在加密操作系统运行时调整大小除外。

- When the system partition/drive is encrypted, the system cannot be upgraded  (for example, from Windows XP to Windows Vista) or repaired from within  the pre-boot environment (using a Windows setup CD/DVD or the Windows  pre-boot component). In such cases, the system partition/drive must be decrypted first.  Note: A running operating system can be *updated* (security patches, service packs, etc.) without any problems even when the system partition/drive is encrypted. 
  当系统分区/驱动器被加密时，系统无法从预引导环境中升级（例如，从Windows XP升级到Windows Vista）或修复（使用Windows安装CD/DVD或Windows预引导组件）。 在这种情况下，必须首先解密系统分区/驱动器。注意：运行的操作系统可以 *更新*（安全补丁、服务包等）即使当系统分区/驱动器被加密时也没有任何问题。

- System encryption is supported only on drives that are connected locally via  an ATA/SCSI interface (note that the term ATA also refers to SATA and  eSATA). 
  仅在通过ATA/SCSI接口本地连接的驱动器上支持系统加密（请注意，术语ATA也指SATA和eSATA）。

- When system encryption is used (this also applies to hidden operating  systems), VeraCrypt does not support multi-boot configuration changes  (for example, changes to the number of operating systems and their  locations). Specifically, the configuration must remain the same as it was when the VeraCrypt Volume Creation Wizard  started to prepare the process of encryption of the system  partition/drive (or creation of a hidden operating system).
  当使用系统加密时（这也适用于隐藏的操作系统），VeraCrypt不支持多引导配置更改（例如，更改操作系统的数量及其位置）。具体而言，配置必须 保持与VeraCrypt卷创建向导开始准备系统分区/驱动器加密过程（或创建隐藏操作系统）时相同。
   
   Note: The only exception is the multi-boot configuration where a running VeraCrypt-encrypted operating system is always located on drive #0, and it is the only operating system located on the drive (or there is one  VeraCrypt-encrypted decoy and one VeraCrypt-encrypted hidden operating system and no other operating system on the drive),  and the drive is connected or disconnected before the computer is turned on (for example, using the power switch on an external eSATA drive  enclosure). There may be any additional operating systems (encrypted or unencrypted) installed on other drives connected  to the computer (when drive #0 is disconnected, drive #1 becomes drive  #0, etc.) 
  注意事项：唯一的例外是多引导配置，其中运行的VeraCrypt加密的操作系统始终位于驱动器#0上，并且它是唯一位于驱动器上的操作系统（或者有一个VeraCrypt加密的诱饵和一个VeraCrypt加密的 隐藏的操作系统，驱动器上没有其他操作系统），并在计算机打开之前连接或断开驱动器（例如，使用外部eSATA驱动器盘柜上的电源开关）。可能有任何额外的操作 安装在连接到计算机的其他驱动器上的系统（加密或未加密）（当驱动器#0断开连接时，驱动器#1变为驱动器#0，等等）

- When the notebook battery power is low, Windows may omit sending the  appropriate messages to running applications when the computer is  entering power saving mode. Therefore, VeraCrypt may fail to  auto-dismount volumes in such cases. 
  当笔记本电池电量不足时，Windows可能会在计算机进入省电模式时忽略向正在运行的应用程序发送相应的消息。因此，在这种情况下，VeraCrypt可能无法自动加密卷。

- Preserving of any timestamp of any file (e.g. a container or keyfile) is not  guaranteed to be reliably and securely performed (for example, due to  filesystem journals, timestamps of file attributes, or the operating  system failing to perform it for various documented and undocumented reasons). Note: When you write to a  file-hosted hidden volume, the timestamp of the container may change.  This can be plausibly explained as having been caused by changing the  (outer) volume password. Also note that VeraCrypt never preserves timestamps of system favorite volumes (regardless of the  settings). 
  任何文件（例如容器或密钥文件）的任何时间戳的保存都不能保证可靠和安全地执行（例如，由于文件系统日志，文件属性的时间戳，或操作系统由于各种记录和未记录的原因无法执行它）。注意：当您写入文件托管的隐藏卷时，容器的时间戳可能会更改。这可以合理地解释为更改（外部）卷密码引起的。还要注意的是，VeraCrypt不会保留系统收藏卷的时间戳（无论设置如何）。

- Special software (e.g., a low-level disk editor) that writes data to a disk  drive in a way that circumvents drivers in the driver stack of the class ‘DiskDrive’ (GUID of the class is 4D36E967-  E325-11CE-BFC1-08002BE10318) can write unencrypted data to a non-system drive hosting a mounted VeraCrypt volume  (‘Partition0’) and to encrypted partitions/drives that are within the  key scope of active system encryption (VeraCrypt does not encrypt such  data written that way). Similarly, software that writes data to a disk drive circumventing drivers in the driver  stack of the class ‘Storage Volume’ (GUID of the class is  71A27CDD-812A-11D0-BEC7-08002BE2092F) can write unencrypted data to  VeraCrypt partition-hosted volumes (even if they are mounted). 
  特殊软件（例如，低级磁盘编辑器），它以绕过类“磁盘驱动器”的驱动程序堆栈中的驱动程序的方式将数据写入磁盘驱动器（类的GUID为4D 36 E967- E325- 11 CE-BFC 1 - 08002 BE  10318）可以将未加密的数据写入托管已安装VeraCrypt卷的非系统驱动器（'Partition  0'）和加密的分区/驱动器，这些分区/驱动器在主动系统加密的密钥范围内（VeraCrypt不加密以这种方式写入的数据）。类似地，将数据写入磁盘驱动器的软件绕过了“存储卷”类（该类的驱动程序为71 A27 CDD-812 A-11 D 0-BEC 7 - 08002 BE 2092  F）的驱动程序堆栈，可以将未加密的数据写入VeraCrypt分区托管的卷（即使它们已挂载）。

- For security reasons, when a hidden operating system is running, VeraCrypt  ensures that all local unencrypted filesystems and non-hidden VeraCrypt  volumes are read-only. However, this does not apply to filesystems on  CD/DVD-like media and on custom, atypical, or non-standard devices/media (for example, any devices/media whose  class is other than the Windows device class ‘Storage Volume’ or that do not meet the requirements of this class (GUID of the class is  71A27CDD-812A-11D0-BEC7-08002BE2092F)). 
  出于安全考虑，当隐藏操作系统运行时，VeraCrypt会确保所有本地未加密文件系统和非隐藏VeraCrypt卷都是只读的。但是，这不适用于CD/DVD类介质和自定义、非典型或非标准设备/介质上的文件系统（例如，其类别不是Windows设备类别“存储卷”或不符合此类要求的任何设备/介质（类别的类别是71 A27 CDD-812 A-11 D 0-BEC 7 - 08002 BE 2092 F））。

- Device-hosted VeraCrypt volumes located on floppy disks are not supported. Note: You  can still create file-hosted VeraCrypt volumes on floppy disks. 
  不支持位于软盘上的设备托管VeraCrypt加密卷。注意：您仍然可以在软盘上创建文件托管的VeraCrypt加密卷。

- Windows Server editions don't allow the use of mounted VeraCrypt volumes as a  path for server backup. This can solved by activating sharing on the  VeraCrypt volume through Explorer interface (of course, you have to put  the correct permission to avoid unauthorized access) and then choosing the option "Remote shared folder" (it is not  remote of course but Windows needs a network path). There, you can type  the path of the shared drive (for example \\ServerName\sharename) and  the backup will be configured correctly. 
  Windows  Server版本不允许使用挂载的VeraCrypt加密卷作为服务器备份的路径。这可以通过在资源管理器界面激活VeraCrypt加密卷上的共享来解决（当然，您必须设置正确的权限以避免未经授权的访问），然后选择“远程共享文件夹”选项（当然它不是远程的，但Windows需要网络路径）。在那里，您可以键入共享驱动器的路径（例如\\ServerName\sharename），备份将被正确配置。

- Due to Microsoft design flaws in NTFS sparse files handling, you may  encounter system errors when writing data to large Dynamic volumes (more than few hundreds GB). To avoid this, the recommended size for a  Dynamic volume container file for maximum compatibility is 300 GB. The following link gives more details concerning this  limitation: [ http://www.flexhex.com/docs/articles/sparse-files.phtml#msdn](http://www.flexhex.com/docs/articles/sparse-files.phtml#msdn)
  由于Microsoft在处理稀疏文件时存在设计缺陷，因此在将数据写入大型动态卷（超过数百GB）时可能会遇到系统错误。为了避免这种情况，建议动态卷容器文件的最大兼容性大小为300 GB。以下链接提供了有关此限制的更多详细信息：http://www.flexhex.com/docs/articles/sparse-files.phtml#msdn 

- In Windows 8 and Windows 10, a feature was introduced with the name "

  Hybrid boot and shutdown

  " and "

  Fast Startup

  " and which make Windows boot more quickly. This feature is enabled by  default and it has side effects on VeraCrypt volumes usage. It is  advised to disable this feature (e.g. this 

  link 

  explains how to disable it in Windows 8 and this 

  link

   gives equivalent instructions for Windows 10). Some examples of issues:

  
  在Windows 8和Windows 10中，引入了名为"混合靴子和关机"和"快速启动"的功能，使Windows靴子启动更快。此功能默认启用，它对VeraCrypt加密卷的使用有副作用.建议禁用此功能 功能（例如，此链接解释了如何在Windows 8中禁用它，此链接提供了Windows 10的等效说明）。一些问题的例子：

  - after a shutdown and a restart, mounted volume will continue to be mounted  without typing the password: this due to the fact the new Windows 8  shutdown is not a real shutdown but a disguised hibernate/sleep. 
    关机和重新启动后，挂载卷将继续挂载而不键入密码：这是由于新的Windows 8关机并不是真实的关机，而是伪装的休眠/睡眠。
  - when using system encryption and when there are System Favorites configured  to be mounted at boot time: after shutdown and restart, these system  favorites will not be mounted. 
    当使用系统加密和当有系统收藏夹配置为在靴子时挂载：关机和重新启动后，这些系统收藏夹将不会被挂载。

- Windows system Repair/Recovery Disk can't be created when a VeraCrypt volume is mounted as a fixed disk (which is the default). To solve this, either  dismount all volumes or mount volumes are removable media. 
  当VeraCrypt加密卷被挂载为固定磁盘时，Windows系统无法创建修复/恢复盘（默认设置）。要解决此问题，请卸载所有卷或将卷装载为可移动媒体。

- Further limitations are listed in the section [ *Security Model*](https://veracrypt.fr/en/Security Model.html). 
  [*安全模型*](https://veracrypt.fr/en/Security Model.html)一节中列出了更多限制。

# Frequently Asked Questions 常见问题

Last Updated July 2nd, 2017
最后更新于2017年7月2日

*This document is not guaranteed to be error-free and is provided "as is" without warranty of any kind. For more information, see [ Disclaimers](https://veracrypt.fr/en/Disclaimers.html).
本文档不保证无错误，并且“按原样”提供，不提供任何形式的保证。详细信息请参见 [声明](https://veracrypt.fr/en/Disclaimers.html)。*

**Can TrueCrypt and VeraCrypt be running on the same machine?
TrueCrypt和VeraCrypt可以在同一台机器上运行吗？**

Yes. There are generally no conflicts between TrueCrypt and VeraCrypt,  thus they can be installed and used on the same machine. On Windows  however, if they are both used to mount the same volume, two drives may  appear when mounting it. This can be solved by running the following command in an elevated command prompt (using Run  as an administrator) before mounting any volume: **mountvol.exe /r**.
是的TrueCrypt和VeraCrypt之间通常不存在冲突，因此它们可以在同一台机器上安装和使用。但是，在Windows上，如果它们都用于挂载同一卷，则在挂载时可能会出现两个驱动器。 在装载任何卷之前，在提升的命令提示符下运行以下命令（使用“以管理员身份运行”）： **mountvol. exe/r**.

**Can I use my TrueCrypt volumes in VeraCrypt?
我可以在VeraCrypt中使用我的TrueCrypt卷吗？**

Yes. Starting from version 1.0f, VeraCrypt supports mounting TrueCrypt volumes.
是的从版本1.0f开始，VeraCrypt支持挂载TrueCrypt加密卷。

**Can I convert my TrueCrypt volumes to VeraCrypt format?
我可以将我的TrueCrypt加密卷转换为VeraCrypt格式吗？**

Yes. Starting from version 1.0f, VeraCrypt offers the possibility to  convert TrueCrypt containers and non-system partitions to VeraCrypt  format. This can achieved using the "Change Volume Password" or "Set  Header Key Derivation Algorithm" actions. Just check the "TrueCrypt Mode", enter you TrueCrypt password and perform the  operation. After that, you volume will have the VeraCrypt format.
是的从1.0f版开始，VeraCrypt提供了将TrueCrypt容器和非系统分区转换为VeraCrypt格式的可能性。这可以使用“更改卷密码”或“设置头密钥推导算法”操作来实现。只是检查 在“TrueCrypt模式”，输入您的TrueCrypt密码，并执行操作.之后，您的加密卷将具有VeraCrypt格式。
 Before doing the conversion, it is advised to backup the volume header  using TrueCrypt. You can delete this backup safely once the conversion  is done and after checking that the converted volume is mounted properly by VeraCrypt.
在进行转换之前，建议使用TrueCrypt备份卷标头。一旦转换完成，并检查转换后的加密卷是否被VeraCrypt正确挂载，您就可以安全地删除此备份。

**What's the difference between TrueCrypt and VeraCrypt?
TrueCrypt和VeraCrypt有什么区别？**

VeraCrypt adds enhanced security to the algorithms used for system and  partitions encryption making it immune to new developments in  brute-force attacks.
VeraCrypt增强了用于系统和分区加密的算法的安全性，使其免受暴力破解攻击的新发展。
 It also solves many vulnerabilities and security issues found in TrueCrypt.
它还解决了TrueCrypt中发现的许多漏洞和安全问题。
 As an example, when the system partition is encrypted, TrueCrypt uses  PBKDF2-RIPEMD160 with 1000 iterations whereas in VeraCrypt we use 327661. And for standard containers and other partitions, TrueCrypt uses at most 2000 iterations but VeraCrypt uses 500000 iterations.
例如，当系统分区被加密时，TrueCrypt使用PBKDF 2-RIPEMD 160进行1000次迭代，而在VeraCrypt中我们使用 327661。对于标准容器和其他分区，TrueCrypt最多使用2000次迭代，而VeraCrypt使用 50万次迭代。
 This enhanced security adds some delay only to the opening of encrypted  partitions without any performance impact to the application use phase.  This is acceptable to the legitimate owner but it makes it much harder  for an attacker to gain access to the encrypted data.
这种增强的安全性只会在打开加密分区时增加一些延迟，而不会对应用程序使用阶段产生任何性能影响。这对合法所有者来说是可以接受的，但这使得攻击者更难访问加密的 数据

**I forgot my password – is there any way ('backdoor') to recover the files from my VeraCrypt volume?
我忘记了我的密码-有什么方法（“后门”）可以从我的VeraCrypt加密卷中恢复文件吗？**

We have not implemented any 'backdoor' in VeraCrypt (and will never  implement any even if asked to do so by a government agency), because it would defeat the purpose of the software. VeraCrypt does not allow  decryption of data without knowing the correct password or key. We cannot recover your data because we do not know and cannot  determine the password you chose or the key you generated using  VeraCrypt. The only way to recover your files is to try to "crack" the  password or the key, but it could take thousands or millions of years (depending on the length and quality of the password  or keyfiles, on the software/hardware performance, algorithms, and other factors). Back in 2010, there was news about the [ FBI failing to decrypt a TrueCrypt volume after a year of trying](http://www.webcitation.org/query?url=g1.globo.com/English/noticia/2010/06/not-even-fbi-can-de-crypt-files-daniel-dantas.html).  While we can't verify if this is true or just a "psy-op" stunt, in  VeraCrypt we have increased the security of the key derivation to a  level where any brute-force of the password is virtually impossible, provided that all security requirements are respected.
我们没有在VeraCrypt中实现任何“后门”（即使政府机构要求我们这样做，我们也不会实现任何后门），因为这会破坏软件的功能。VeraCrypt不允许在不知道正确密码的情况下解密数据 或者钥匙我们无法恢复您的数据，因为我们不知道也无法确定您选择的密码或您使用VeraCrypt生成的密钥。恢复文件的唯一方法是尝试“破解”密码或密钥，但这可能需要数千或 数百万年（取决于密码或密钥文件的长度和质量，软件/硬件性能，算法和其他因素）。早在2010年，就有消息称， [FBI在尝试一年后未能解密TrueCrypt卷](http://www.webcitation.org/query?url=g1.globo.com/English/noticia/2010/06/not-even-fbi-can-de-crypt-files-daniel-dantas.html)。虽然我们无法验证这是真的还是只是一个“心理战”噱头，但在VeraCrypt中，我们已经将密钥推导的安全性提高到了一个几乎不可能使用暴力破解密码的水平，前提是所有的安全要求都得到了尊重。


 **Is there a "Quick Start Guide" or some tutorial for beginners?
有没有“快速入门指南”或一些初学者的教程？**

Yes. The first chapter, **[Beginner's Tutorial](https://veracrypt.fr/en/Beginner's Tutorial.html)**, in the VeraCrypt User Guide contains screenshots and step-by-step instructions on how to create, mount, and use a VeraCrypt volume.
是的VeraCrypt用户指南的第一章，**[初学者指南，](https://veracrypt.fr/en/Beginner's Tutorial.html)**包含了截图和如何创建、挂载和使用VeraCrypt加密卷的分步说明。


 **Can I encrypt a partition/drive where Windows is installed?
我可以加密安装Windows的分区/驱动器吗？**

Yes, see the chapter [ System Encryption](https://veracrypt.fr/en/System Encryption.html) in the VeraCrypt User Guide.
是的，请参阅VeraCrypt用户指南中的[系统加密](https://veracrypt.fr/en/System Encryption.html)一章。

**The system encryption Pre Test fails because the bootloader hangs with the  messaging "booting" after successfully verifying the password. How to  make the Pre Test succeed?
系统加密预测试失败，因为在成功验证密码后，引导加载程序挂起并显示消息“引导”。如何使预测试成功？**

There two known workarounds for this issue (Both require having a Windows Installation disk):
此问题有两种已知的解决方法（都需要有Windows安装磁盘）：

1. Boot your machine using a Windows Installation disk and select to repair  your computer. Choose "Command Prompt" option and when it opens, type  the commands below and then restart your system:

   
   使用Windows安装盘靴子引导计算机，然后选择修复计算机。选择“命令提示符”选项，当它打开时，键入下面的命令，然后重新启动系统：

   - BootRec /fixmbr 
   - BootRec /FixBoot 

2. Delete the 100 MB System Reserved partition located at the beginning of your  drive and set the system partition next to it as the active partition  (both can be done using diskpart utility available in Windows  Installation disk repair option). After that, run Startup Repair after rebooting on Windows Installation disk. The  following link contains detailed instructions: [ https://www.sevenforums.com/tutorials/71363-system-reserved-partition-delete.html](https://www.sevenforums.com/tutorials/71363-system-reserved-partition-delete.html)
   删除位于驱动器开头的100 MB系统保留分区，并将其旁边的系统分区设置为活动分区（两者都可以使用Windows安装磁盘修复选项中提供的diskpart实用程序完成）。在那之后， 在Windows安装磁盘上重新启动后运行启动修复。以下链接包含详细说明： https://www.sevenforums.com/tutorials/71363-system-reserved-partition-delete.html

**The system encryption Pre Test fails even though the password was correctly entered in the bootloader. How to make the Pre Test succeed?
即使在引导加载程序中正确输入了密码，系统加密预测试仍失败。如何使预测试成功？**

This can be caused by the TrueCrypt driver that clears BIOS memory  before VeraCrypt is able to read it. In this case, uninstalling  TrueCrypt solves the issue.
这可能是由于TrueCrypt驱动程序在VeraCrypt能够读取BIOS内存之前清除了它。在这种情况下，卸载TrueCrypt可以解决这个问题。
 This can also be caused by some hardware drivers and other software that access BIOS memory. There is no generic solution for this and affected  users should identify such software and remove it from the system.
这也可能是由某些硬件驱动程序和访问BIOS内存的其他软件引起的。对此没有通用的解决方案，受影响的用户应识别此类软件并将其从系统中删除。


 **Can I directly play a video (.avi, .mpg, etc.) stored on a VeraCrypt volume?
我可以直接播放视频（.avi，.mpg等）吗？存储在VeraCrypt加密卷上**

Yes, VeraCrypt-encrypted volumes are like normal disks. You provide the  correct password (and/or keyfile) and mount (open) the VeraCrypt volume. When you double click the icon of the video file, the operating system  launches the application associated with the file type – typically a media player. The media player then begins  loading a small initial portion of the video file from the  VeraCrypt-encrypted volume to RAM (memory) in order to play it. While  the portion is being loaded, VeraCrypt is automatically decrypting it (in RAM). The decrypted portion of the video (stored in  RAM) is then played by the media player. While this portion is being  played, the media player begins loading another small portion of the  video file from the VeraCrypt-encrypted volume to RAM (memory) and the process repeats.
是的，VeraCrypt加密的卷就像普通磁盘一样。您提供正确的密码（和/或密钥文件）并挂载（打开）VeraCrypt加密卷。双击视频文件的图标时，操作系统将启动与 文件类型-通常是媒体播放器。然后媒体播放器开始从VeraCrypt加密的卷中加载视频文件的一小部分到RAM（内存）中以便播放。当加载这部分时，VeraCrypt会自动 解密它（在RAM中）。视频的解密部分（存储在RAM中）然后由媒体播放器播放。播放这部分内容时，媒体播放器开始从VeraCrypt加密卷加载另一小部分视频文件， RAM（内存）和过程重复。
 
 The same goes for video recording: Before a chunk of a video file is  written to a VeraCrypt volume, VeraCrypt encrypts it in RAM and then  writes it to the disk. This process is called on-the-fly  encryption/decryption and it works for all file types (not only for video files).
视频录制也是如此：在视频文件的一部分被写入VeraCrypt加密卷之前，VeraCrypt会先在RAM中对其进行加密，然后再将其写入磁盘。此过程称为动态加密/解密，它适用于所有文件类型（不仅 视频文件）。


 **Will VeraCrypt be open-source and free forever?
VeraCrypt会永远开源和免费吗？**

Yes, it will. We will never create a commercial version of VeraCrypt, as we believe in open-source and free security software.
会的我们永远不会创建VeraCrypt的商业版本，因为我们相信开源和免费的安全软件。


 **Is it possible to donate to the VeraCrypt project?
可以向VeraCrypt项目捐款吗？**

Yes. You can use the donation buttons at [ https://www.veracrypt.fr/en/Donation.html](https://www.veracrypt.fr/en/Donation.html).
是的您可以使用https://www.veracrypt.fr/en/Donation.html上的捐赠按钮。


 **Why is VeraCrypt open-source? What are the advantages?
为什么VeraCrypt是开源的？有哪些优势？**

As the source code for VeraCrypt is publicly available, independent  researchers can verify that the source code does not contain any  security flaw or secret 'backdoor'. If the source code were not  available, reviewers would need to reverse-engineer the executable files. However, analyzing and understanding such reverse-engineered  code is so difficult that it is practically *impossible* to do (especially when the code is as large as the VeraCrypt code).
由于VeraCrypt的源代码是公开的，独立研究人员可以验证源代码不包含任何安全漏洞或秘密“后门”。如果源代码不可用，评审人员需要对可执行文件进行反向工程 文件.然而，分析和理解这样的逆向工程代码是如此困难， *这是不可能*做到的（特别是当代码和VeraCrypt代码一样大的时候）。
 
 Remark: A similar problem also affects cryptographic hardware (for  example, a self-encrypting storage device). It is very difficult to  reverse-engineer it to verify that it does not contain any security flaw or secret 'backdoor'.
注：类似的问题也会影响加密硬件（例如，自加密存储设备）。这是非常困难的反向工程，以验证它不包含任何安全漏洞或秘密的“后门”。


 **VeraCrypt is open-source, but has anybody actually reviewed the source code?
VeraCrypt是开源的，但有人真正审查过源代码吗？**

Yes. An [ audit](http://blog.quarkslab.com/security-assessment-of-veracrypt-fixes-and-evolutions-from-truecrypt.html) has been performed by [ Quarkslab](https://quarkslab.com/). The technical report can be downloaded from [here](http://blog.quarkslab.com/resources/2016-10-17-audit-veracrypt/16-08-215-REP-VeraCrypt-sec-assessment.pdf). VeraCrypt 1.19 addressed the issues found by this audit.
是的已由Quarkslab进行稽查。技术报告可以从这里下载。VeraCrypt 1.19解决了本次审计发现的问题。


 **As VeraCrypt is open-source software, independent researchers can verify  that the source code does not contain any security flaw or secret  'backdoor'. Can they also verify that the official executable files were built from the published source code and contain no additional code?
由于VeraCrypt是开源软件，独立研究人员可以验证源代码不包含任何安全漏洞或秘密"后门"。他们是否也可以验证官方的可执行文件是从发布的源代码构建的，并且不包含任何额外的代码？**

Yes, they can. In addition to reviewing the source code, independent  researchers can compile the source code and compare the resulting  executable files with the official ones. They may find some differences  (for example, timestamps or embedded digital signatures) but they can analyze the differences and verify that they do not form  malicious code.
他们可以而且除了审查源代码外，独立研究人员还可以编译源代码，并将生成的可执行文件与官方文件进行比较。他们可能会发现一些差异（例如，时间戳或嵌入式数字签名），但他们可以分析差异并验证它们不会形成恶意代码。


 **How can I use VeraCrypt on a USB flash drive? 
如何在U盘上使用VeraCrypt？**

You have three options: 你有三个选择：

1. Encrypt the entire USB flash drive. However, you will not be able run VeraCrypt from the USB flash drive. 
   加密整个USB闪存驱动器。但是，您将无法从U盘运行VeraCrypt。
2. Create two or more partitions on your USB flash drive. Leave the first  partition non encrypted and encrypt the other partition(s). You can  store VeraCrypt on the first partition in order to run it directly from  the USB flash drive.
   在USB闪存驱动器上创建两个或更多分区。保持第一个分区不加密，并加密其他分区。您可以将VeraCrypt存储在第一个分区，以便直接从U盘运行。
    Note: Windows can only access the primary partition of a USB flash  drive, nevertheless the extra partitions remain accessible through  VeraCrypt. 
   注意：Windows只能访问USB闪存盘的主分区，但是额外的分区仍然可以通过VeraCrypt访问。
3. Create a VeraCrypt file container on the USB flash drive (for information on how to do so, see the chapter **[Beginner's Tutorial](https://veracrypt.fr/en/Beginner's Tutorial.html)**, in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html)). If you leave enough space on the USB flash  drive (choose an appropriate size for the VeraCrypt container), you will also be able to store VeraCrypt on the USB flash drive (along with the  container – not *in* the container) and you will be able to run VeraCrypt from the USB flash drive (see also the chapter [ Portable Mode](https://veracrypt.fr/en/Portable Mode.html) in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html)). 
   在U盘上创建一个VeraCrypt文件容器（有关如何操作的信息，请参阅 **[初学者的摇篮](https://veracrypt.fr/en/Beginner's Tutorial.html)**，在 [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)）。如果您在U盘上留有足够的空间（为VeraCrypt容器选择一个合适的大小），您也可以将VeraCrypt存储在U盘上（沿着容器-不 *在容器中*），您将能够从USB闪存驱动器运行VeraCrypt（另请参阅章节 [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)中的[便携模式](https://veracrypt.fr/en/Portable Mode.html)）。


 **Does VeraCrypt also encrypt file names and folder names? 
VeraCrypt也加密文件名和文件夹名吗？**

Yes. The entire file system within a VeraCrypt volume is encrypted  (including file names, folder names, and contents of every file). This  applies to both types of VeraCrypt volumes – i.e., to file containers  (virtual VeraCrypt disks) and to VeraCrypt-encrypted partitions/devices.
是的VeraCrypt加密卷中的整个文件系统都是加密的（包括文件名、文件夹名和每个文件的内容）。这适用于两种类型的VeraCrypt加密卷-即，文件容器（虚拟VeraCrypt磁盘）和VeraCrypt加密的分区/设备。


 **Does VeraCrypt use parallelization?
VeraCrypt使用并行化吗？**

Yes. Increase in encryption/decryption speed is directly proportional to the number of cores/processors your computer has. For more information, please see the chapter [ Parallelization](https://veracrypt.fr/en/Parallelization.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
是的加密/解密速度的提高与计算机的核心/处理器数量成正比。有关详细信息，请参阅 在[文档](https://www.veracrypt.fr/en/Documentation.html)中[进行标记](https://veracrypt.fr/en/Parallelization.html)。


 **Can data be read from and written to an encrypted volume/drive as fast as if the drive was not encrypted?
从加密卷/驱动器读取数据和向其写入数据的速度是否与驱动器未加密时一样快？**

Yes, since VeraCrypt uses pipelining and parallelization. For more information, please see the chapters [ Pipelining](https://veracrypt.fr/en/Pipelining.html) and [ Parallelization](https://veracrypt.fr/en/Parallelization.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
是的，因为VeraCrypt使用流水线和并行化。欲了解更多信息，请参阅章节 [文档](https://www.veracrypt.fr/en/Documentation.html)中的[流水线](https://veracrypt.fr/en/Pipelining.html)和[并行化](https://veracrypt.fr/en/Parallelization.html)。


 **Does VeraCrypt support hardware-accelerated encryption?
VeraCrypt支持硬件加速加密吗？**

Yes. For more information, please see the chapter [ Hardware Acceleration](https://veracrypt.fr/en/Hardware Acceleration.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
是的有关详细信息，请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的[硬件加速](https://veracrypt.fr/en/Hardware Acceleration.html)一章。


 **Is it possible to boot Windows installed in a hidden VeraCrypt volume?
可以靴子安装在隐藏VeraCrypt加密卷中的Windows吗？**

Yes, it is. For more information, please see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
是的.有关详细信息，请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的[隐藏操作系统](https://veracrypt.fr/en/Hidden Operating System.html)部分。


 **Will I be able to mount my VeraCrypt volume (container) on any computer?
我可以将我的VeraCrypt加密卷（容器）安装在任何计算机上吗？**

Yes, [ VeraCrypt volumes](https://veracrypt.fr/en/VeraCrypt Volume.html) are independent of the operating system. You will  be able to mount your VeraCrypt volume on any computer on which you can  run VeraCrypt (see also the question '*Can I use VeraCrypt on Windows if I do not have administrator privileges?*').
是的，[VeraCrypt加密卷](https://veracrypt.fr/en/VeraCrypt Volume.html)独立于操作系统。您可以将您的VeraCrypt加密卷挂载到任何一台可以运行VeraCrypt的计算机上（请参阅问题“*如果我没有管理员权限，我可以在Windows上使用VeraCrypt吗？*').


 **Can I unplug or turn off a hot-plug device (for example, a USB flash drive  or USB hard drive) when there is a mounted VeraCrypt volume on it?
当热插拔设备（例如USB闪存盘或USB硬盘）上有VeraCrypt加密卷时，我可以拔下或关闭它吗？**

Before you unplug or turn off the device, you should always dismount the VeraCrypt volume in VeraCrypt first, and then perform the '*Eject*' operation if available (right-click the device in the '*Computer*' or '*My Computer*' list), or use the '*Safely Remove Hardware*' function (built in Windows, accessible via the taskbar notification area). Otherwise, data loss may occur.
在拔出或关闭设备之前，您应该首先在VeraCrypt中删除VeraCrypt加密卷，然后执行“*弹出*”操作（如果可用的话）（右键单击“*计算机*”或“*我的电脑*”列表中的设备），或者使用“*安全删除硬件*”功能（内置于Windows中，可通过删除通知区域访问）。否则，可能会发生数据丢失。


 **What is a hidden operating system?
什么是隐藏操作系统？**

See the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的[隐藏操作系统](https://veracrypt.fr/en/Hidden Operating System.html)一节。


 **What is plausible deniability?
什么是合理否认？**

See the chapter [ Plausible Deniability](https://veracrypt.fr/en/Plausible Deniability.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中[的合理否认](https://veracrypt.fr/en/Plausible Deniability.html)一章。


 **Will I be able to mount my VeraCrypt partition/container after I reinstall or upgrade the operating system?
在我重新安装或升级操作系统后，我可以挂载我的VeraCrypt分区/容器吗？**

Yes, [ VeraCrypt volumes](https://veracrypt.fr/en/VeraCrypt Volume.html) are independent of the operating system. However,  you need to make sure your operating system installer does not format  the partition where your VeraCrypt volume resides.
是的，[VeraCrypt加密卷](https://veracrypt.fr/en/VeraCrypt Volume.html)独立于操作系统。但是，您需要确保操作系统安装程序不会格式化VeraCrypt加密卷所在的分区。
 
 Note: If the system partition/drive is encrypted and you want to  reinstall or upgrade Windows, you need to decrypt it first (select *System* > *Permanently Decrypt System Partition/Drive*). However, a running operating system can be *updated* (security patches, service packs, etc.) without any problems even when the system partition/drive is encrypted.
注意：如果系统分区/驱动器已加密，并且您要重新安装或升级Windows，则需要先对其进行解密（选择 *系统*>*永久解密系统分区/驱动器*）。但是，运行的操作系统可以 *更新*（安全补丁、服务包等）即使当系统分区/驱动器被加密时也没有任何问题。


 **Can I upgrade from an older version of VeraCrypt to the latest version without any problems?
我可以从旧版本的VeraCrypt升级到最新版本吗？**

Generally, yes. However, before upgrading, please read the [ release notes](https://veracrypt.fr/en/Release Notes.html) for all versions of VeraCrypt that have been released  since your version was released. If there are any known issues or  incompatibilities related to upgrading from your version to a newer one, they will be listed in the [ release notes](https://veracrypt.fr/en/Release Notes.html).
一般来说是的但是，在升级之前，请阅读自您的版本发布以来发布的所有VeraCrypt版本的[发行说明](https://veracrypt.fr/en/Release Notes.html)。如果存在与从您的版本升级到较新版本相关的任何已知问题或不兼容性， [发行说明](https://veracrypt.fr/en/Release Notes.html)。


 **Can I upgrade VeraCrypt if the system partition/drive is encrypted or do I have to decrypt it first?
如果系统分区/驱动器被加密了，我可以升级VeraCrypt吗？还是必须先解密？**

Generally, you can upgrade to the latest version without decrypting the  system partition/drive (just run the VeraCrypt installer and it will  automatically upgrade VeraCrypt on the system). However, before  upgrading, please read the [ release notes](https://veracrypt.fr/en/Release Notes.html) for all versions of VeraCrypt that have been released  since your version was released. If there are any known issues or  incompatibilities related to upgrading from your version to a newer one, they will be listed in the [ release notes](https://veracrypt.fr/en/Release Notes.html). Note that this FAQ answer is also valid for users of a [ hidden operating system](https://veracrypt.fr/en/Hidden Operating System.html). Also note that you cannot  *down*grade VeraCrypt if the system partition/drive is encrypted.
一般来说，您可以升级到最新版本而无需解密系统分区/驱动器（只需运行VeraCrypt安装程序，它将自动升级系统上的VeraCrypt）。但是，在升级之前，请阅读 自您的版本发布以来，VeraCrypt所有版本的[发行说明](https://veracrypt.fr/en/Release Notes.html)。如果存在与从您的版本升级到较新版本相关的任何已知问题或不兼容性， [发行说明](https://veracrypt.fr/en/Release Notes.html)。请注意，此常见问题解答也适用于[隐藏操作系统](https://veracrypt.fr/en/Hidden Operating System.html)的用户。另外请注意，如果系统分区/驱动器被加密，您不能*降低*VeraCrypt的等级。


 **I use pre-boot authentication. Can I prevent a person (adversary) that is watching me start my computer from knowing that I use VeraCrypt?
我使用预启动身份验证。我可以阻止监视我启动计算机的人（对手）知道我使用VeraCrypt吗？**

Yes. To do so, boot the encrypted system, start VeraCrypt, select  *Settings* > *System Encryption*, enable the option '*Do not show any texts in the pre-boot authentication screen*' and click *OK*. Then, when you start the computer, no texts will be displayed by the  VeraCrypt boot loader (not even when you enter the wrong password). The  computer will appear to be "frozen" while you can type your password. It is, however, important to note that if the adversary can analyze the content of the  hard drive, he can still find out that it contains the VeraCrypt boot  loader.
是的为此，靴子引导加密系统，启动VeraCrypt，选择*设置*>*系统加密*，启用选项“*在预靴子验证屏幕中不显示任何文本*”，然后点击 *好*的.然后，当您启动计算机时，VeraCrypt靴子加载程序将不会显示任何文本（即使您输入了错误的密码）。当您输入密码时，计算机将显示为“冻结”状态。然而，需要注意的是，如果攻击者能够分析硬盘的内容，他仍然可以发现它包含VeraCrypt靴子加载程序。


 **I use pre-boot authentication. Can I configure the VeraCrypt Boot Loader to display only a fake error message?
我使用预启动身份验证。我可以将VeraCrypt靴子加载程序设置为只显示虚假的错误消息吗？**

Yes. To do so, boot the encrypted system, start VeraCrypt, select  *Settings* > *System Encryption*, enable the option '*Do not show any texts in the pre-boot authentication screen*' and enter the fake error message in the corresponding field (for example, the "*Missing operating system*" message, which is normally displayed by the Windows boot loader if it  finds no Windows boot partition). It is, however, important to note that if the adversary can analyze the content of the hard drive, he can still find out that it contains the VeraCrypt boot  loader.
是的为此，靴子引导加密的系统，启动VeraCrypt，选择*设置*>*系统加密*，启用选项“*在预靴子验证屏幕中不显示任何文本*”，并在相应的字段中输入虚假的错误消息（例如，“*缺少操作系统*“消息，通常由Windows靴子加载程序在没有找到Windows靴子分区时显示）。然而，需要注意的是，如果攻击者能够分析硬盘的内容，他仍然可以发现它包含VeraCrypt靴子加载程序。


 **Can I configure VeraCrypt to mount automatically whenever Windows starts a  non-system VeraCrypt volume that uses the same password as my system  partition/drive (i.e. my pre-boot authentication password)?
我可以配置VeraCrypt在Windows启动非系统VeraCrypt加密卷时自动挂载吗？该加密卷使用与我的系统分区/驱动器相同的密码（即我的预启动验证密码）？**

Yes. To do so, follow these steps:
是的为此，请按照下列步骤操作：

1. Mount the volume (to the drive letter to which you want it to be mounted every time). 
   装载卷（到您希望每次将其装载到的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select '*Add to System Favorites*'. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到系统收藏夹*”。
3. The System Favorites Organizer window should appear now. In this window, enable the option '*Mount system favorite volumes when Windows starts*' and click *OK*. 
   现在应该出现“系统收藏夹管理器”窗口。在此窗口中，启用选项“*Mount system favorite volumes when Windows starts*”并单击 *好*的.

For more information, see the chapter [ System Favorite Volumes](https://veracrypt.fr/en/System Favorite Volumes.html).
有关详细信息，请参阅“[系统收藏夹”一章](https://veracrypt.fr/en/System Favorite Volumes.html)。


 **Can a volume be automatically mounted whenever I log on to Windows?
每当我登录到Windows时，是否可以自动挂载卷？**

Yes. To do so, follow these steps:
是的为此，请按照下列步骤操作：

1. Mount the volume (to the drive letter to which you want it to be mounted every time). 
   装载卷（到您希望每次将其装载到的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select '*Add to Favorites*'. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到收藏夹*”。
3. The [ Favorites](https://veracrypt.fr/en/Favorite Volumes.html) Organizer window should appear now. In this window, enable the option '*Mount selected volume upon logon*' and click *OK*. 
   现在应该会出现“[收藏夹](https://veracrypt.fr/en/Favorite Volumes.html)管理器”窗口。在此窗口中，启用“*登录时装入选定卷”*选项，然后单击 *好*的.

Then, when you log on to Windows, you will be asked for the volume  password (and/or keyfiles) and if it is correct, the volume will be  mounted.
然后，当您登录到Windows时，您将被要求输入卷密码（和/或密钥文件），如果正确，则将挂载卷。
 
 Alternatively, if the volumes are partition/device-hosted and if you do  not need to mount them to particular drive letters every time, you can  follow these steps:
或者，如果卷是分区/设备托管的，并且您不需要每次都将它们挂载到特定的驱动器号，则可以执行以下步骤：

1. Select *Settings* >  *Preferences.* The *Preferences* window should appear now. 
   选择*设置*>*首选项。*现在应该会出现“*首选项”*窗口。
2. In the section '*Actions to perform upon logon to Windows*', enable the option '*Mount all devices-hosted VeraCrypt volumes*' and click *OK*. 
   在“*登录Windows时执行的操作*”部分，启用“*挂载所有设备托管的VeraCrypt卷*”选项，然后点击 *好*的.

Note: VeraCrypt will not prompt you for a password if you have enabled caching of the [ pre-boot authentication](https://veracrypt.fr/en/System Encryption.html) password (*Settings* > '*System Encryption*') and the volumes use the same password as the system partition/drive.
注意：如果您启用了密码缓存，VeraCrypt将不会提示您输入密码 [预启动身份验证](https://veracrypt.fr/en/System Encryption.html)密码（*设置*>“*系统加密*”）和卷使用相同的密码作为系统分区/驱动器。


 **Can a volume be automatically mounted whenever its host device gets connected to the computer?
卷是否可以在主机设备连接到计算机时自动装入？**

Yes. For example, if you have a VeraCrypt container on a USB flash drive and you want VeraCrypt to mount it automatically when you insert the  USB flash drive into the USB port, follow these steps:
是的例如，如果您的U盘上有一个VeraCrypt容器，并且您希望VeraCrypt在您将U盘插入USB端口时自动挂载它，请按照以下步骤操作：

1. Mount the volume (to the drive letter to which you want it to be mounted every time). 
   装载卷（到您希望每次将其装载到的驱动器号）。
2. Right-click the mounted volume in the drive list in the main VeraCrypt window and select '*Add to Favorites*'. 
   在VeraCrypt主窗口的驱动器列表中右键单击已挂载的加密卷，然后选择“*添加到收藏夹*”。
3. The [ Favorites](https://veracrypt.fr/en/Favorite Volumes.html) Organizer window should appear now. In this window, enable the option '*Mount selected volume when its host device gets connected*' and click *OK*. 
   现在应该会出现“[收藏夹](https://veracrypt.fr/en/Favorite Volumes.html)管理器”窗口。在此窗口中，启用选项“*Mount selected volume when its host device gets connected*”，然后单击 *好*的.

Then, when you insert the USB flash drive into the USB port, you will be asked for the volume password (and/or keyfiles) (unless it is cached)  and if it is correct, the volume will be mounted.
然后，当您将USB闪存驱动器插入USB端口时，您将被要求输入卷密码（和/或密钥文件）（除非它被缓存），如果它是正确的，卷将被挂载。
 
 Note: VeraCrypt will not prompt you for a password if you have enabled caching of the [ pre-boot authentication](https://veracrypt.fr/en/System Encryption.html) password (*Settings* > '*System Encryption*') and the volume uses the same password as the system partition/drive.
注意：如果您启用了密码缓存，VeraCrypt将不会提示您输入密码 [预启动身份验证](https://veracrypt.fr/en/System Encryption.html)密码（*设置*>“*系统加密*”）和卷使用相同的密码作为系统分区/驱动器。


 **Can my pre-boot authentication password be cached so that I can use it mount non-system volumes during the session?
我的预引导身份验证密码是否可以缓存，以便我可以在会话期间使用它挂载非系统卷？**

Yes. Select *Settings* > '*System Encryption*' and enable the following option: '*Cache pre-boot authentication password in driver memory*'.
是的选择*设置*>“*系统加密*”并启用以下选项：“*在驱动程序内存中缓存预启动身份验证密码*”。


 **I live in a country that violates basic human rights of its people. Is it possible to use VeraCrypt without leaving any 'traces' on unencrypted  Windows?
我生活在一个侵犯人民基本人权的国家。是否可以在未加密的Windows上使用VeraCrypt而不留下任何“痕迹”？**

Yes. This can be achieved by running VeraCrypt in [ portable mode](https://veracrypt.fr/en/Portable Mode.html) under [ BartPE](http://www.nu2.nu/pebuilder/) or in a similar environment. BartPE stands for "Bart's  Preinstalled Environment", which is essentially the Windows operating  system prepared in a way that it can be entirely stored on and booted  from a CD/DVD (registry, temporary files, etc., are stored in RAM – hard drive is not used at all and does not even have to be present). The freeware [ Bart's PE Builder](http://www.nu2.nu/pebuilder/) can transform a Windows XP installation CD into a  BartPE CD. Note that you do not even need any special VeraCrypt plug-in  for BartPE. Follow these steps:
是的这可以通过在[BartPE](http://www.nu2.nu/pebuilder/)或类似环境下以[可移植模式](https://veracrypt.fr/en/Portable Mode.html)运行VeraCrypt来实现。BartPE代表“Bart's Preinstalled Environment”，本质上是Windows操作系统，其准备方式是可以完全存储在CD/DVD上并从CD/DVD启动（注册表、临时文件等，是 存储在RAM中-硬盘驱动器根本不使用，甚至不必存在）。免费软件 [Bart的PE Builder](http://www.nu2.nu/pebuilder/)可以将Windows XP安装CD转换为BartPE CD。请注意，BartPE甚至不需要任何特殊的VeraCrypt插件。请执行下列步骤：

1. Create a BartPE CD and boot it. (Note: You must perform each of the following steps from within BartPE.) 
   创建BartPE CD并靴子。（注意：您必须从BartPE中执行以下每个步骤。）
2. Download the VeraCrypt self-extracting package to the RAM disk (which BartPE automatically creates). 
   下载VeraCrypt自解压包到RAM磁盘（BartPE自动创建）。
    
    **Note**: If the adversary can intercept data you send or receive over the  Internet and you need to prevent the adversary from knowing you  downloaded VeraCrypt, consider downloading it via [ **I2P**](https://geti2p.net/en/), [ **Tor**](http://www.torproject.org/), or a similar anonymizing network. 
   **注意**：如果攻击者可以拦截您通过互联网发送或接收的数据，而您需要防止攻击者知道您下载了VeraCrypt，请考虑通过 [**I2P**](https://geti2p.net/en/)、[**Tor**](http://www.torproject.org/)或类似的匿名网络。
3. Verify the digital signatures of the downloaded file (see [ this](https://veracrypt.fr/en/Digital Signatures.html) section of the documentation for more information). 
   验证下载文件的数字签名（有关详细信息，请参阅文档的[此](https://veracrypt.fr/en/Digital Signatures.html)部分）。
4. Run the downloaded file, and select *Extract* (instead of *Install*) on the second page of the VeraCrypt Setup wizard. Extract the contents to the RAM disk. 
   运行下载的文件，然后选择*Extract*（而不是 *安装*）在VeraCrypt安装向导的第二页。将内容提取到RAM磁盘。
5. Run the file *VeraCrypt.exe* from the RAM disk. 
   从RAM磁盘运行文件*VeraCrypt.exe*。

Note: You may also want to consider creating a hidden operating system (see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html)). See also the chapter [ Plausible Deniability](https://veracrypt.fr/en/Plausible Deniability.html).
注意：您可能还需要考虑创建一个隐藏的操作系统（请参阅 在[文档](https://www.veracrypt.fr/en/Documentation.html)中[隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)）。另见[合理否认](https://veracrypt.fr/en/Plausible Deniability.html)一章。


 **Can I encrypt my system partition/drive if I don't have a US keyboard?
如果我没有美国键盘，我可以加密我的系统分区/驱动器吗？**

Yes, VeraCrypt supports all keyboard layouts. Because of BIOS requirement, the pre-boot password is typed using **US keyboard layout.** During the system encryption process, VeraCrypt automatically and  transparently switches the keyboard to US layout in order to ensure that the password value typed will match the one typed in pre-boot mode.  Thus, in order to avoid wrong password errors, one must type the password using the  same keys as when creating the system encryption.
是的，VeraCrypt支持所有键盘布局。由于BIOS要求，预引导密码使用 **美国键盘布局。**在系统加密过程中，VeraCrypt会自动透明地将键盘切换为美式键盘，以确保输入的密码值与预启动模式下输入的密码值一致。因此，为了避免错误的密码错误，必须使用与创建系统加密时相同的密钥键入密码。


 **Can I save data to the decoy system partition without risking damage to the hidden system partition?
我可以将数据保存到诱饵系统分区而不冒损坏隐藏系统分区的风险吗？**

Yes. You can write data to the decoy system partition anytime without  any risk that the hidden volume will get damaged (because the decoy  system is *not* installed within the same partition as the hidden system). For more information, see the section [ Hidden Operating System](https://veracrypt.fr/en/Hidden Operating System.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
是的您可以随时将数据写入诱饵系统分区，而不会有任何隐藏卷损坏的风险（因为诱饵系统 *未*安装在与隐藏系统相同的分区内）。有关详细信息，请参阅 [文档](https://www.veracrypt.fr/en/Documentation.html)中[隐藏的操作系统](https://veracrypt.fr/en/Hidden Operating System.html)。


 **Can I use VeraCrypt on Windows if I do not have administrator privileges?
如果我没有管理员权限，可以在Windows上使用VeraCrypt吗？**

See the chapter '[Using VeraCrypt Without Administrator Privileges](https://veracrypt.fr/en/Using VeraCrypt Without Administrator Privileges.html)' in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的“在[没有管理员权限的情况下使用VeraCrypt](https://veracrypt.fr/en/Using VeraCrypt Without Administrator Privileges.html)”章节。


 **Does VeraCrypt save my password to a disk?
VeraCrypt会将我的密码保存到磁盘吗？**

No. 号


 **How does VeraCrypt verify that the correct password was entered?
VeraCrypt如何验证输入的密码是否正确？**

See the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html) (chapter [ Technical Details](https://veracrypt.fr/en/Technical Details.html)) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的[加密方案一](https://veracrypt.fr/en/Encryption Scheme.html)节（[技术详细信息](https://veracrypt.fr/en/Technical Details.html)一章）。


 **Can I encrypt a partition/drive without losing the data currently stored on it?
我可以加密分区/驱动器而不丢失当前存储在其上的数据吗？**

Yes, but the following conditions must be met:
可以，但必须满足以下条件：

- If you want to encrypt an entire system drive (which may contain  multiple partitions) or a system partition (in other words, if you want  to encrypt a drive or partition where Windows is installed), you can do  so provided that you use Windows XP or a later version of Windows (such as Windows 7)  (select '*System*' > '*Encrypt System Partition/Drive*' and then follow the instructions in the wizard). 
  如果要加密整个系统驱动器（可能包含多个分区）或系统分区（换句话说，如果要加密安装Windows的驱动器或分区），只要使用Windows XP或更高版本的Windows（如Windows 7），就可以执行此操作（选择“*系统*”>“*加密系统分区/驱动器*”，然后按照向导中的说明操作）。
- If you want to encrypt a non-system partition in place, you can do so  provided that it contains an NTFS filesystem and that you use Windows  Vista or a later version of Windows (for example, Windows 7) (click '*Create Volume*' > '*Encrypt a non-system partition*' > '*Standard volume*' > '*Select Device*' > '*Encrypt partition in place*' and then follow the instructions in the wizard). 
  如果要就地加密非系统分区，只要它包含一个NTFS文件系统，并且您使用的是Windows Vista或更高版本的Windows（例如Windows 7），就可以这样做 （单击“*创建卷*' > '*加密非系统分区*' > '*标准卷*' > '*选择设备*' > '就地*加密分区*'，然后按照向导中的说明进行操作）。


 **Can I run VeraCrypt if I don't install it?
如果我没有安装VeraCrypt，我可以运行它吗？**

Yes, see the chapter [ Portable Mode](https://veracrypt.fr/en/Portable Mode.html) in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
是的，请参阅[VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)中的[便携模式](https://veracrypt.fr/en/Portable Mode.html)一章。


 **Some encryption programs use TPM to prevent attacks. Will VeraCrypt use it too?
一些加密程序使用TPM来防止攻击。VeraCrypt也会使用它吗？**

No. Those programs use TPM to protect against attacks that  *require* the attacker to have administrator privileges, or physical  access to the computer, and the attacker needs you to use the computer  after such an access. *However, if any of these conditions is met, it is actually impossible to secure the computer* (see below) and, therefore, you must stop using it (instead of relying on TPM). 
号这些程序使用TPM来防御攻击，*这些攻击要求*攻击者具有管理员权限或对计算机的物理访问权限，并且攻击者需要您在这样的访问之后使用计算机。 *但是，如果满足这些条件中的任何一个，实际上就不可能保护计算机*（见下文），因此，您必须停止使用它（而不是依赖TPM）。
 
 If the attacker has administrator privileges, he can, for example, reset the TPM, capture the content of RAM (containing master keys) or content of files stored on mounted VeraCrypt volumes (decrypted on the fly),  which can then be sent to the attacker over the Internet or saved to an unencrypted local drive (from which the  attacker might be able to read it later, when he gains physical access  to the computer). 
如果攻击者具有管理员权限，他可以重置TPM、捕获RAM的内容（包含主密钥）或存储在已安装的VeraCrypt卷上的文件内容（动态解密），然后可以将其发送给攻击者通过 互联网或保存到未加密的本地驱动器（当攻击者稍后获得对计算机的物理访问权限时，他可能能够从中读取它）。
 
 If the attacker can physically access the computer hardware (and you use it after such an access), he can, for example, attach a malicious  component to it (such as a hardware keystroke logger) that will capture  the password, the content of RAM (containing master keys) or content of files stored on mounted VeraCrypt volumes  (decrypted on the fly), which can then be sent to the attacker over the  Internet or saved to an unencrypted local drive (from which the attacker might be able to read it later, when he gains physical access to the computer again). 
如果攻击者可以物理访问计算机硬件（并且您在这样的访问之后使用它），则他可以例如将恶意组件附加到它（例如硬件恶意日志记录器），该恶意组件将捕获密码、RAM（包含主 密钥）或存储在挂载的VeraCrypt卷上的文件内容（动态解密），然后可以通过互联网发送给攻击者或保存到未加密的本地驱动器（攻击者可以在稍后获得物理信息时从中读取）。 再次访问计算机）。
 
 The only thing that TPM is almost guaranteed to provide is a false sense of security (even the name itself, "Trusted Platform Module", is  misleading and creates a false sense of security). As for real security, TPM is actually redundant (and implementing redundant features is usually a way to create so-called bloatware). 
TPM几乎可以保证提供的唯一一件事是一种虚假的安全感（甚至名称本身，“可信平台模块”，也是误导性的，会产生一种虚假的安全感）。至于真实的安全性，TPM实际上是冗余的（并且实现了冗余 功能通常是创建所谓的bloatware的一种方式）。
 
 For more information, please see the sections  Physical Security and [ Malware](https://veracrypt.fr/en/Malware.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
有关详细信息，请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的物理安全和[恶意软件](https://veracrypt.fr/en/Malware.html)部分。


 **Do I have to dismount VeraCrypt volumes before shutting down or restarting Windows?
在关闭或重新启动Windows之前，我是否需要重新安装VeraCrypt加密卷？**

No. VeraCrypt automatically dismounts all mounted VeraCrypt volumes on system shutdown/restart.
不可以。VeraCrypt会在系统关机/重启时自动卸载所有挂载的VeraCrypt加密卷。


 **Which type of VeraCrypt volume is better – partition or file container?
哪种类型的VeraCrypt加密卷更好-分区还是文件容器？**

[File containers](https://veracrypt.fr/en/VeraCrypt Volume.html) are normal files so you can work with them as with any normal files (file containers can be, for example, moved, renamed, and deleted the same way as normal files). [ Partitions/drives](https://veracrypt.fr/en/VeraCrypt Volume.html) may be better as regards performance. Note that  reading and writing to/from a file container may take significantly  longer when the container is heavily fragmented. To solve this problem,  defragment the file system in which the container is stored (when the VeraCrypt volume is dismounted).
[文件容器](https://veracrypt.fr/en/VeraCrypt Volume.html)是普通文件，因此您可以像处理任何普通文件一样处理它们（例如，可以像处理普通文件一样移动、重命名和删除文件容器）。[分区/驱动器](https://veracrypt.fr/en/VeraCrypt Volume.html)可能在性能方面更好。请注意，当容器碎片严重时，从文件容器阅读和写入文件容器可能需要更长的时间。要解决此问题，请对存储容器的文件系统进行碎片整理（当VeraCrypt卷被加密时）。


 **What's the recommended way to back up a VeraCrypt volume?
备份VeraCrypt加密卷的推荐方法是什么？**

See the chapter [ How to Back Up Securely](https://veracrypt.fr/en/How to Back Up Securely.html) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的“[如何备份Secret”一](https://veracrypt.fr/en/How to Back Up Securely.html)章。


 **What will happen if I format a VeraCrypt partition?
如果我格式化VeraCrypt分区会发生什么？**

See the question '*[Is it possible to change the file system of an encrypted volume?](https://veracrypt.fr/en/FAQ.html#changing-filesystem)*'
请参阅问题“*[是否可以更改加密卷的文件系统？](https://veracrypt.fr/en/FAQ.html#changing-filesystem)*'


 **Is it possible to change the file system of an encrypted volume?
是否可以更改加密卷的文件系统？**

Yes, when mounted, VeraCrypt volumes can be formatted as FAT12, FAT16,  FAT32, NTFS, or any other file system. VeraCrypt volumes behave as  standard disk devices so you can right-click the device icon (for  example in the '*Computer*' or '*My Computer*' list) and select '*Format*'. The actual volume contents will be lost. However, the whole volume will remain encrypted. If you format a VeraCrypt-encrypted partition when  the VeraCrypt volume that the partition hosts is not mounted, then the volume will be destroyed, and the partition will not be encrypted anymore (it will be  empty).
是的，在挂载时，VeraCrypt加密卷可以被格式化为FAT12，FAT16，FAT32，NTFS或任何其他文件系统。VeraCrypt加密卷和标准磁盘设备一样，所以你可以右键点击设备图标（例如在“*电脑*”或“*我的电脑*”列表中），然后选择“*格式化*”。实际卷内容将丢失。但是，整个卷将保持加密。如果您格式化一个VeraCrypt加密的分区，而该分区所承载的VeraCrypt卷没有挂载，那么该卷将被销毁，并且该分区将不再被加密（它将是空的）。


 **Is it possible to mount a VeraCrypt container that is stored on a CD or DVD?
可以挂载存储在CD或DVD上的VeraCrypt容器吗？**

Yes. However, if you need to mount a VeraCrypt volume that is stored on a read-only medium (such as a CD or DVD) under Windows 2000, the file  system within the VeraCrypt volume must be FAT (Windows 2000 cannot  mount an NTFS file system on read-only media).
是的但是，如果您需要在Windows 2000下挂载存储在只读介质（如CD或DVD）上的VeraCrypt卷，则VeraCrypt卷中的文件系统必须是FAT（Windows 2000不能在只读介质上挂载NTFS文件系统）。


 **Is it possible to change the password for a hidden volume?
可以更改隐藏卷的密码吗？**

Yes, the password change dialog works both for standard and [ hidden volumes](https://veracrypt.fr/en/Hidden Volume.html). Just type the password for the hidden volume in the 'Current Password' field of the 'Volume Password Change' dialog.
是的，密码更改对话框适用于标准卷和[隐藏卷](https://veracrypt.fr/en/Hidden Volume.html)。只需在“卷密码更改”对话框的“当前密码”字段中键入隐藏卷的密码。

Remark: VeraCrypt first attempts to decrypt the standard [ volume header](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html) and if it fails, it attempts to decrypt the area  within the volume where the hidden volume header may be stored (if there is a hidden volume within). In case it is successful, the password  change applies to the hidden volume. (Both attempts use the password typed in the 'Current Password' field.)
注：VeraCrypt首先尝试解密标准[卷头](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)，如果失败，它会尝试解密隐藏卷头可能存储的区域（如果其中有隐藏卷）。如果成功，密码更改将应用于隐藏卷。(Both尝试使用在“当前密码”字段中键入的密码。


 **How do I burn a VeraCrypt container larger than 2 GB onto a DVD?
如何将大于2 GB的VeraCrypt容器刻录到DVD上？**
 
 The DVD burning software you use should allow you to select the format  of the DVD. If it does, select the UDF format (ISO format does not  support files larger than 2 GB).
您使用的DVD刻录软件应该允许您选择DVD的格式。如果是，请选择UDF格式（ISO格式不支持大于2 GB的文件）。


 **Can I use tools like  \*chkdsk\*, Disk Defragmenter, etc. on the contents of a mounted VeraCrypt volume?
我可以对挂载的VeraCrypt加密卷的内容使用\*chkdsk\*，磁盘碎片整理程序等工具吗？**

Yes, VeraCrypt volumes behave like real physical disk devices, so it is  possible to use any filesystem checking/repairing/defragmenting tools on the contents of a mounted VeraCrypt volume.
是的，VeraCrypt加密卷的行为就像真实的物理磁盘设备，因此可以使用任何文件系统检查/修复/碎片整理工具来检查已挂载的VeraCrypt加密卷的内容。


 **Does VeraCrypt support 64-bit versions of Windows?
VeraCrypt是否支持64位版本的Windows？**

Yes, it does. Note: 64-bit versions of Windows load only drivers that are digitally signed  with a digital certificate issued by a certification authority approved  for issuing kernel-mode code signing certificates. VeraCrypt complies with this requirement (the VeraCrypt  driver is [ digitally signed](https://veracrypt.fr/en/Digital Signatures.html) with the digital certificate of IDRIX, which was issued by the certification authority Thawte).
是的，是的。注意事项：64位版本的Windows仅加载使用由批准颁发内核模式代码签名证书的证书颁发机构颁发的数字证书进行数字签名的驱动程序。VeraCrypt符合这一要求（VeraCrypt驱动程序使用IDRIX的数字证书[进行数字签名](https://veracrypt.fr/en/Digital Signatures.html)，该证书由认证机构Thawte颁发）。


 **Can I mount my VeraCrypt volume under Windows, Mac OS X, and Linux?
我可以在Windows、Mac OS X和Linux下挂载VeraCrypt加密卷吗？**

Yes, VeraCrypt volumes are fully cross-platform.
是的，VeraCrypt加密卷是完全跨平台的。

**How can I uninstall VeraCrypt on Linux?
如何在Linux上卸载VeraCrypt？**

To uninstall VeraCrypt on Linux, run the following command in Terminal as root:  **veracrypt-uninstall.sh**. On Ubuntu, you can use "**sudo veracrypt-uninstall.sh**".
要在Linux上卸载VeraCrypt，请以root用户身份在终端中运行以下命令：**veracrypt-uninstall.sh**。在Ubuntu上，您可以使用“**sudo veracrypt-uninstall.sh**“。


 **Is there a list of all operating systems that VeraCrypt supports?
是否有VeraCrypt支持的所有操作系统的列表？**

Yes, see the chapter [ Supported Operating Systems](https://veracrypt.fr/en/Supported Operating Systems.html) in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
是的，请参阅[VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)中[支持的操作系统](https://veracrypt.fr/en/Supported Operating Systems.html)一章。


 **Is it possible to install an application to a VeraCrypt volume and run it from there?
是否可以将应用程序安装到VeraCrypt加密卷并从那里运行它？**

Yes. 是的


 **What will happen when a part of a VeraCrypt volume becomes corrupted?
当VeraCrypt卷的一部分损坏时会发生什么？**

In encrypted data, one corrupted bit usually corrupts the whole  ciphertext block in which it occurred. The ciphertext block size used by VeraCrypt is 16 bytes (i.e., 128 bits). The [ mode of operation](https://veracrypt.fr/en/Modes of Operation.html) used by VeraCrypt ensures that if data corruption  occurs within a block, the remaining blocks are not affected. See also  the question '*What do I do when the encrypted filesystem on my VeraCrypt volume is corrupted?*
在加密数据中，一个损坏的比特通常会损坏整个密文块。VeraCrypt使用的密文块大小为16字节（即，128位）。的 VeraCrypt使用[的一种操作模式](https://veracrypt.fr/en/Modes of Operation.html)确保了如果一个区块内发生数据损坏，其余区块不受影响。另请参阅问题“*当我的VeraCrypt加密卷上的加密文件系统损坏时我该怎么办？*


 **What do I do when the encrypted filesystem on my VeraCrypt volume is corrupted?
当我的VeraCrypt加密卷上的加密文件系统损坏时，我该怎么办？**

File system within a VeraCrypt volume may become corrupted in the same  way as any normal unencrypted file system. When that happens, you can  use filesystem repair tools supplied with your operating system to fix  it. In Windows, it is the '*chkdsk*' tool. VeraCrypt provides an easy way to use this tool on a VeraCrypt  volume: Right-click the mounted volume in the main VeraCrypt window (in  the drive list) and from the context menu select '*Repair Filesystem*'.
VeraCrypt卷中的文件系统可能会像任何正常的未加密文件系统一样被损坏。当这种情况发生时，你可以使用操作系统提供的文件系统修复工具来修复它。在Windows中，它是'*chkdsk*'工具。VeraCrypt提供了一个在VeraCrypt加密卷上使用此工具的简单方法：在VeraCrypt主窗口中右键单击已挂载的加密卷（在驱动器列表中），然后从上下文菜单中选择“*修复文件加密*”。


 **We use VeraCrypt in a corporate/enterprise environment. Is there a way for an administrator to reset a volume password or pre-boot authentication  password when a user forgets it (or loses a keyfile)?
我们在公司/企业环境中使用VeraCrypt。当用户忘记卷密码或引导前身份验证密码（或丢失密钥文件）时，管理员是否有办法重置该密码？**

Yes. Note that there is no "backdoor" implemented in VeraCrypt. However, there is a way to "reset" volume passwords/[keyfiles](https://veracrypt.fr/en/Keyfiles.html) and [ pre-boot authentication](https://veracrypt.fr/en/System Encryption.html) passwords. After you create a volume, back up its header to a file (select *Tools* -> *Backup Volume Header*) before you allow a [ non-admin user](https://veracrypt.fr/en/Using VeraCrypt Without Administrator Privileges.html) to use the volume. Note that the [ volume header](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html) (which is encrypted with a [ header key](https://veracrypt.fr/en/Header Key Derivation.html) derived from a password/keyfile) contains the [ master key](https://veracrypt.fr/en/Encryption Scheme.html) with which the volume is encrypted. Then ask the user to choose a password, and set it for him/her (*Volumes* -> *Change Volume Password*); or generate a user keyfile for him/her. Then you can allow the user to  use the volume and to change the password/keyfiles without your  assistance/permission. In case he/she forgets his/her password or loses his/her keyfile, you can "reset" the volume password/keyfiles to  your original admin password/keyfiles by restoring the volume header  from the backup file (*Tools* -> *Restore Volume Header*). 
是的请注意，VeraCrypt中没有实现“后门”。但是，有一种方法可以“重置”卷密码/[密钥文件](https://veracrypt.fr/en/Keyfiles.html) 和[预启动身份验证](https://veracrypt.fr/en/System Encryption.html)密码。创建卷后，将卷头备份到文件（选择 *工具*->*备份卷头*），然后才允许 [非管理员](https://veracrypt.fr/en/Using VeraCrypt Without Administrator Privileges.html)用户使用卷。请注意，[卷标头](https://veracrypt.fr/en/VeraCrypt Volume Format Specification.html)（使用从密码/密钥文件导出的[标头密钥](https://veracrypt.fr/en/Header Key Derivation.html)加密）包含用于加密卷的[主密钥](https://veracrypt.fr/en/Encryption Scheme.html)。然后要求用户选择一个密码，并为他/她设置密码*（*-> *更改卷密码*）;或者为他/她生成一个用户密钥文件。然后，您可以允许用户使用卷，并在没有您的帮助/许可的情况下更改密码/密钥文件。如果他/她忘记了密码， 丢失了他/她的密钥文件，你可以“重置”卷密码/keyfiles到您原来的管理员密码/keyfiles通过恢复卷头从备份文件（*工具*-> *还原卷标题*）。
 
 Similarly, you can reset a [ pre-boot authentication](https://veracrypt.fr/en/System Encryption.html) password[. ](https://veracrypt.fr/en/System Encryption.html)To create a backup of the master key data (that will be stored on a [ VeraCrypt Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html) and encrypted with your administrator password), select '*System*' > '[*Create  Rescue Disk*](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)'. To set a user [ pre-boot authentication](https://veracrypt.fr/en/System Encryption.html) password, select '*System*' > '*Change Password*'. To restore your administrator password, boot the VeraCrypt Rescue Disk, select '*Repair Options*' > '*Restore key data*' and enter your administrator password. 
同样，您可以重置[预引导身份验证](https://veracrypt.fr/en/System Encryption.html)密码[。](https://veracrypt.fr/en/System Encryption.html)要创建主密钥数据的备份（将存储在[VeraCrypt救援盘](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)上并使用您的管理员密码加密），选择“*系统*”>“[*创建救援盘*](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)”。要设置用户[预启动身份验证](https://veracrypt.fr/en/System Encryption.html)密码，请选择“*系统*”>“*更改密码*”。要恢复您的管理员密码，请靴子启动VeraCrypt救援盘，选择“*修复选项*”>“*恢复密钥数据*”，然后输入您的管理员密码。
 Note: It is not required to burn each [ VeraCrypt Rescue Disk](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html) ISO image to a CD/DVD. You can maintain a  central repository of ISO images for all workstations (rather than a  repository of CDs/DVDs). For more information see the section [ Command Line Usage](https://veracrypt.fr/en/Command Line Usage.html) (option */noisocheck*).
注意：不需要每次都燃烧 [VeraCrypt救援盘](https://veracrypt.fr/en/VeraCrypt Rescue Disk.html)ISO镜像到CD/DVD。您可以为所有工作站维护ISO映像的中央存储库（而不是CD/DVD存储库）。有关详细信息，请参阅 [命令行用法](https://veracrypt.fr/en/Command Line Usage.html)（option*/noisocheck*）。


 **Can our commercial company use VeraCrypt free of charge?
我们的商业公司可以免费使用VeraCrypt吗？**

Provided that you comply with the terms and conditions of the [ VeraCrypt License](https://veracrypt.fr/en/VeraCrypt License.html), you can install and run VeraCrypt free of charge on an arbitrary number of your computers.
只要您遵守[VeraCrypt许可证](https://veracrypt.fr/en/VeraCrypt License.html)的条款和条件，您就可以在任意数量的计算机上免费安装和运行VeraCrypt。


 **We share a volume over a network. Is there a way to have the network share automatically restored when the system is restarted?
我们通过网络共享卷。当系统重新启动时，是否有一种方法可以自动恢复网络共享？**

Please see the chapter '[Sharing over Network](https://veracrypt.fr/en/Sharing over Network.html)' in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
请参阅“[网络共享](https://veracrypt.fr/en/Sharing over Network.html)”一章， [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)


 **It is possible to access a single VeraCrypt volume simultaneously from  multiple operating systems (for example, a volume shared over a  network)?
可以从多个操作系统同时访问一个VeraCrypt加密卷吗（例如，通过网络共享的加密卷）？**

Please see the chapter '[Sharing over Network](https://veracrypt.fr/en/Sharing over Network.html)' in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
请参阅“[网络共享](https://veracrypt.fr/en/Sharing over Network.html)”一章， [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)


 **Can a user access his or her VeraCrypt volume via a network?
用户可以通过网络访问他/她的VeraCrypt加密卷吗？**

Please see the chapter '[Sharing over Network](https://veracrypt.fr/en/Sharing over Network.html)' in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
请参阅“[网络共享](https://veracrypt.fr/en/Sharing over Network.html)”一章， [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)


 **I encrypted a non-system partition, but its original drive letter is still visible in the '\*My Computer\*' list. When I double click this drive letter, Windows asks if I want to format the drive. Is there a way to hide or free this drive letter? 
我加密了一个非系统分区，但它的原始驱动器号仍然在“\*我的电脑\*”列表中可见。当我双击此驱动器号时，Windows询问我是否要格式化驱动器。是否有方法隐藏或释放此驱动器号？**

Yes, to free the drive letter follow these steps:
是的，要释放驱动器号，请执行以下步骤：

1. Right-click the '*Computer*' (or '*My Computer*') icon on your desktop or in the Start Menu and select *Manage*. The '*Computer Management*' window should appear. 
   右键单击桌面或开始菜单中的“*计算机*”（或“*我的电脑*”）图标，然后选择 *管理*。“*计算机管理*”窗口将出现。
2. From the list on the left, select '*Disk Management*' (within the *Storage* sub-tree). 
   从左侧的列表中，选择“*磁盘管理*”（在 *存储*子树）。
3. Right-click the encrypted partition/device and select  *Change Drive Letter and Paths*. 
   右键单击加密的分区/设备，然后选择*更改驱动器号和路径*。
4. Click *Remove*. 
   单击“*删除*”。
5. If Windows prompts you to confirm the action, click  *Yes*. 
   如果Windows提示您确认操作，请单击*“是*”。

**
 When I plug in my encrypted USB flash drive, Windows asks me if I want to format it. Is there a way to prevent that?
当我插入加密的USB闪存驱动器时，Windows询问我是否要格式化它。有什么方法可以防止这种情况发生吗？**

Yes, but you will need to remove the drive letter assigned to the device. For information on how to do so, see the question '*I encrypted a non-system partition, but its original drive letter is still visible in the 'My Computer' list.*'
可以，但您需要删除分配给该设备的驱动器号。有关如何执行此操作的信息，请参阅问题“*我加密了一个非系统分区，但其原始驱动器号仍然在“我的电脑”列表中可见。*'

**
 How do I remove or undo encryption if I do not need it anymore? How do I permanently decrypt a volume? 
如果我不再需要加密，如何删除或撤消加密？如何永久解密卷？**

Please see the section '[How to Remove Encryption](https://veracrypt.fr/en/Removing Encryption.html)' in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
请参阅 [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)


 **What will change when I enable the option '\*Mount volumes as removable media\*'?
当我启用“\*将卷装载为可移动媒体\*”选项时，会发生什么变化？**

Please see the section '[Volume Mounted as Removable Medium](https://veracrypt.fr/en/Removable Medium Volume.html)' in the [ VeraCrypt User Guide](https://www.veracrypt.fr/en/Documentation.html).
请参阅“[卷装载为介质](https://veracrypt.fr/en/Removable Medium Volume.html)”一节， [VeraCrypt用户指南](https://www.veracrypt.fr/en/Documentation.html)


 **Is the online documentation available for download as a single file?
在线文档是否可作为单个文件下载？**

Yes, the documentation is contained in the file *VeraCrypt User Guide.chm* that is included in official VeraCrypt installer for Windows. You can  also download the CHM using the link available at the home page [https://www.veracrypt.fr/en/downloads/](https://www.veracrypt.fr/en/Downloads.html). Note that you do *not* have to install VeraCrypt to obtain the CHM documentation. Just run the self-extracting installation package and then select *Extract* (instead of  *Install*) on the second page of the VeraCrypt Setup wizard. Also note that when you *do* install VeraCrypt, the CHM documentation is automatically copied to the folder to which VeraCrypt is installed, and is accessible via the  VeraCrypt user interface (by pressing F1 or choosing *Help* > *User's Guide*).
是的，文档包含在*VeraCrypt用户指南. chm*文件中，该文件包含在Windows官方VeraCrypt安装程序中。您也可以使用主页上的链接下载CHM [https://www.veracrypt.fr/en/downloads/](https://www.veracrypt.fr/en/Downloads.html)网站。请注意， *不*需要安装VeraCrypt来获取CHM文档。只需运行自解压安装包，然后选择 在VeraCrypt安装向导的第二页*进行解压*（而不是*安装*）。还请注意，当您 安装VeraCrypt后，CHM文档会自动复制到安装VeraCrypt的文件夹中，并且可以通过VeraCrypt用户界面访问（按F1或选择 *帮助*>*用户指南*）。


 **Do I have to "wipe" free space and/or files on a VeraCrypt volume?
我必须“擦除”VeraCrypt加密卷上的可用空间和/或文件吗？**

Remark: to "wipe" = to securely erase; to overwrite sensitive data in order to render them unrecoverable. 
注：“wipe”=安全地擦除;覆盖敏感数据，使其无法恢复。
 
 If you believe that an adversary will be able to decrypt the volume (for example that he will make you reveal the password), then the answer is  yes. Otherwise, it is not necessary, because the volume is entirely  encrypted.
如果你相信对手能够解密卷（例如，他会让你透露密码），那么答案是肯定的。否则，这是不必要的，因为卷是完全加密的。


 **How does VeraCrypt know which encryption algorithm my VeraCrypt volume has been encrypted with?
VeraCrypt如何知道我的VeraCrypt加密卷使用的是哪种加密算法？**

Please see the section [ Encryption Scheme](https://veracrypt.fr/en/Encryption Scheme.html) (chapter [ Technical Details](https://veracrypt.fr/en/Technical Details.html)) in the [ documentation](https://www.veracrypt.fr/en/Documentation.html).
请参阅[文档](https://www.veracrypt.fr/en/Documentation.html)中的[加密方案](https://veracrypt.fr/en/Encryption Scheme.html)一节（[技术详细信息](https://veracrypt.fr/en/Technical Details.html)一章）。

**How can I perform a Windows built-in backup on a VeraCrypt volume? The  VeraCrypt volume doesn't show up in the list of available backup paths.
如何在VeraCrypt加密卷上执行Windows内置备份？VeraCrypt加密卷没有显示在可用备份路径列表中。
**

Windows built-in backup utility looks only for physical driver, that's  why it doesn't display the VeraCrypt volume. Nevertheless, you can still backup on a VeraCrypt volume by using a trick: activate sharing on the  VeraCrypt volume through Explorer interface (of course, you have to put the correct permission to avoid  unauthorized access) and then choose the option "Remote shared folder"  (it is not remote of course but Windows needs a network path). There you can type the path of the shared drive (for example  \\ServerName\sharename) and the backup will be configured correctly.
Windows内置的备份工具只查找物理驱动程序，这就是为什么它不显示VeraCrypt加密卷。然而，您仍然可以使用一个技巧在VeraCrypt加密卷上进行备份：通过资源管理器界面激活VeraCrypt加密卷上的共享（当然，您必须设置正确的权限以避免未经授权的访问），然后选择“远程共享文件夹”选项（当然不是远程的，但Windows需要网络路径）。在那里，您可以键入共享驱动器的路径（例如\\ServerName\sharename），备份将被正确配置。

**Is the encryption used by VeraCrypt vulnerable to Quantum attacks?
VeraCrypt使用的加密方式容易受到Quantum攻击吗？**

VeraCrypt uses block ciphers (AES, Serpent, Twofish) for its encryption. Quantum attacks against these block ciphers are just a faster  brute-force since the best know attack against these algorithms is  exhaustive search (related keys attacks are irrelevant to our case because all keys are random and independent from each  other).
VeraCrypt使用块密码（AES，Serpent，Twofish）进行加密。针对这些分组密码的量子攻击只是一种更快的蛮力攻击，因为针对这些算法的最佳已知攻击是穷举搜索（相关密钥攻击是不相关的 对于我们的情况来说，因为所有密钥都是随机的并且相互独立）。
 Since VeraCrypt always uses 256-bit random and independent keys, we are assured of a 128-bit security
由于VeraCrypt始终使用256位随机和独立密钥，因此我们可以保证128位安全性
 level against quantum algorithms which makes VeraCrypt encryption immune to such attacks.
这使得VeraCrypt加密对此类攻击免疫。

**How to make a VeraCrypt volume available for Windows Search indexing?
如何将VeraCrypt加密卷用于Windows搜索索引？**

In order to be able to index a VeraCrypt volume through Windows Search,  the volume must be mounted at boot time (System Favorite) or the Windows Search services must be restart after the volume is mounted. This is  needed because Windows Search can only index drives that are available when it starts.
为了能够通过Windows搜索对VeraCrypt加密卷进行索引，加密卷必须在靴子引导时挂载（系统收藏夹），或者在挂载加密卷后重启Windows搜索服务。这是必要的，因为Windows Search只能索引启动时可用的驱动器。

**I'm encountering an "Operation not permitted" error with VeraCrypt on macOS when trying to mount a file container. How can I resolve this?
我在macOS上尝试挂载文件容器时遇到VeraCrypt“Operation not permitted”错误。我该如何解决这个问题？**

This specific error, which appears in the form "Operation not permitted:  /var/folders/w6/d2xssyzx.../T/.veracrypt_aux_mnt1/control  VeraCrypt::File::Open:232", has been reported by some users. It is the  result of macOS not granting the necessary permissions to VeraCrypt.  Here are a couple of solutions you can try:
此特定错误以“不允许操作：/var/folders/w 6/d2 xssyzx./”形式出现T/.veracrypt_aux_mnt1/control  VeraCrypt：：File：：Open：232”，已被一些用户报告。这是由于macOS没有授予VeraCrypt必要的权限。这里有几个你可以尝试的解决方案：

- A. Granting Full Disk Access to VeraCrypt:

  
  A.授予对VeraCrypt的完整磁盘访问权限：

  

  1. Go to `Apple Menu` > `System Settings`.
     前往`Apple菜单`>`系统设置`。
  2. Click on the `Privacy & Security` tab.
     单击`隐私安全`选项卡。
  3. Scroll down and select `Full Disk Access`.
     向下滚动并选择`完整磁盘访问`。
  4. Click the `+` button, navigate to your Applications folder, select `VeraCrypt`, and click `Open`.
     点击`+`按钮，导航到您的应用程序文件夹，选择`VeraCrypt`，然后点击`打开`。
  5. Ensure that the checkbox next to VeraCrypt is ticked.
     确保VeraCrypt旁边的复选框被选中。
  6. Close the System Settings window and try using VeraCrypt again.
     关闭系统设置窗口，然后再次尝试使用VeraCrypt。
  7. 

- B. Using the sudo approach to launch VeraCrypt:

  
  B。使用sudo方法启动VeraCrypt：

  You can launch VeraCrypt from the Terminal using elevated permissions: 
  您可以使用提升的权限从终端启动VeraCrypt：

  ```
  sudo /Applications/VeraCrypt.app/Contents/MacOS/VeraCrypt
  ```

  Running VeraCrypt with sudo often bypasses certain permission-related  issues, but it's always a good practice to grant the necessary  permissions via the system settings whenever possible.

  
  使用sudo运行VeraCrypt通常会绕过某些与权限相关的问题，但最好尽可能通过系统设置授予必要的权限。

  

**Why does VeraCrypt show an unknown device in its list that doesn't appear  as a physical disk in Windows Disk Management or in DiskPart output?
为什么VeraCrypt会在列表中显示一个未知的设备，而该设备在Windows磁盘管理或加密部分的输出中并不显示为物理磁盘？**

Starting from Windows 10 version 1903 and later, Microsoft introduced a feature called **Windows Sandbox**. This is an isolated environment designed to run untrusted applications  safely. As part of this feature, Windows generates a dynamic virtual  hard disk (VHDX) which represents a clean Windows installation. This  VHDX contains a base system image, user data, and the runtime state, and its size can vary depending on system configurations and usage.	 
从Windows 10版本1903及更高版本开始，微软推出了一项名为**Windows Sandbox的**功能。这是一个隔离的环境，旨在安全地运行不受信任的应用程序。作为该功能的一部分，Windows生成一个动态虚拟硬盘（VHDX），它代表全新的Windows安装。此VHDX包含基本系统映像、用户数据和运行时状态，其大小可能因系统配置和使用情况而异。

When VeraCrypt enumerates devices on a system, it identifies all available disk devices using device path formats like **\Device\HardDiskX\PartitionY**. VeraCrypt lists these devices, including virtual ones such as those  associated with Windows Sandbox, without making distinctions based on  their physical or virtual nature. Therefore, you might observe an  unexpected device in VeraCrypt, even if it doesn't appear as a physical  disk in tools like diskpart. 
当VeraCrypt枚举系统上的设备时，它使用设备路径格式如**\Device\Hardware X\PartitionY来**标识所有可用的磁盘设备。VeraCrypt列出了这些设备，包括与Windows  Sandbox相关的虚拟设备，但没有根据它们的物理或虚拟性质进行区分。因此，您可能会在VeraCrypt中观察到一个意外的设备，即使它在diskpart等工具中没有显示为物理磁盘。

For more details on the Windows Sandbox feature and its associated virtual hard disk, you can refer to this [official Microsoft article](https://techcommunity.microsoft.com/t5/windows-os-platform-blog/windows-sandbox/ba-p/301849). 
有关Windows Sandbox功能及其相关虚拟硬盘的更多详细信息，您可以参考此[Microsoft官方文章](https://techcommunity.microsoft.com/t5/windows-os-platform-blog/windows-sandbox/ba-p/301849)。

**I haven't found any answer to my question in the FAQ – what should I do?
我在常见问题解答中没有找到我的问题的答案-我该怎么办？**

Please search the VeraCrypt documentation and website.
请搜索VeraCrypt文档和网站。