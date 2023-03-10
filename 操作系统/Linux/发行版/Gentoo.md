# Gentoo

[TOC]

## 概述

Gentoo Linux 是一个适用于多种计算机系统架构的发行版。

Gentoo 是一个快速、现代化的元发行版，它的设计简洁、灵活。Gentoo  围绕自由软件建立，它不会对它的用户隐瞒“引擎盖下的细节”。Gentoo 所使用的软件包维护系统 Portage 是用 Python  编写的，这意味着用户可以轻松地查看和修改它的源代码。 Gentoo  的软件包管理系统使用源代码包（虽然也支持预编译软件包），并通过标准的文本文件配置Gentoo。换句话说，开放无处不在。

“自由选择”是 Gentoo 运行的关键，这点很重要，大家要理解。我们尽量不强迫用户去做任何他们不喜欢的事情。

## 架构

* x86
* x86_64（amd64）
* mips
* arm

* arm64
* Alpha

- HPPA（PA-RISC）

- IA64

- PPC

- PPC64

- RISC-V

- SPARC

## 安装

### 安装步骤

Gentoo的安装可以被分成 10 个步骤。执行完每个步骤，都会让系统进入某种确定的状态：

| 步骤 | 结果                                                         |
| ---- | ------------------------------------------------------------ |
| 1    | 用户处于一个准备好安装 Gentoo 的工作环境中。                 |
| 2    | 用于安装 Gentoo 的互联网连接已经准备完毕。                   |
| 3    | 硬盘已经为 Gentoo 的安装初始化完毕。                         |
| 4    | 安装环境已经准备好，用户准备 [chroot](https://wiki.gentoo.org/wiki/Chroot) 到新环境中去。 |
| 5    | 那些在所有Gentoo安装中都相同的核心软件包已经安装完毕。       |
| 6    | Linux内核已经安装完毕。                                      |
| 7    | 用户已经创建好大部分的 Gentoo 系统配置文件。                 |
| 8    | 必要的系统工具已经安装完毕。                                 |
| 9    | 合适的启动引导程序 (Bootloader) 已经安装配置完毕。           |
| 10   | 登录系统，你就可以在已经全新安装完毕的 Gentoo Linux 系统中尽情探索了！ |

### 硬件需求

|          | 最小化 CD                                                    | LiveDVD |
| -------- | ------------------------------------------------------------ | ------- |
| CPU      | 任何 AMD64 CPU 或者 EM64T CPU (Core i3, i5, and i7 都是 EM64T) |         |
| 内存     | 256 MB                                                       | 512 MB  |
| 磁盘空间 | 8 GB（不包括swap空间）                                       |         |
| Swap空间 | 至少 2 GB                                                    |         |

## 使用Gentoo Linux安装光盘

### 最小化安装CD

Gentoo最小化安装CD是一张可引导镜像：包含有完整Gentoo环境的。它允许用户从CD或其它安装媒介引导进入Linux。在引导过程中将检测硬件并加载适当的驱动。这个镜像由Gentoo开发人员维护，能让任何有Internet连接的人来安装Gentoo。

最小化安装CD叫做install-amd64-minimal-<release>.iso。

### 偶尔用到的Gentoo LiveDVD

有时，需要用一张特制的DVD安装Gentoo。本章的介绍是针对最小化安装CD的，因此从LiveDVD引导可能会有一点不同。不管怎么样，LiveDVD（或任何其他可引导的Linux环境）支持通过在终端输入 **sudo su -** 或者 **sudo -i** 来获取root权限。

### stage又是什么？

stage3压缩包是一个包含有最小化的特定profile的Gentoo环境的压缩包，Stage3可用来按照本手册介绍继续安装Gentoo。以前的Gentoo手册描述了使用三个 [stage tarballs](https://wiki.gentoo.org/wiki/Stage_tarball) 的其中一个来进行安装。Gentoo不再提供stage1和stage2压缩包供下载，因为它们主要用于内部使用和在新架构上对Gentoo进行bootstrap。

Stage 文件更新比较频繁并且不在官方安装镜像中提供，但可以在任意一个[Gentoo官方镜像站 ](https://www.gentoo.org/downloads/mirrors/)的releases/amd64/autobuilds/ 路径下选择下载。

## 下载

### 获得安装媒介

Gentoo Linux使用*最小化安装CD*做为默认安装媒介，它带有一个非常小的可引导的Gentoo Linux环境。此环境包含所有正确的安装工具. CD镜像本身可以从[官方下载页](https://www.gentoo.org/downloads/)（推荐）或任意一个[镜像站](https://www.gentoo.org/downloads/mirrors/)下载。

在这些镜像站上，最小化安装CD可以通过以下方式找到：

1. 进入 releases/ 目录
2. 选择相应的架构, 如 **amd64/**
3. 选择 autobuilds/ 目录
4. 对于 **amd64** 和 **x86** 平台的用户，请选择 current-install-amd64-minimal/ 或 current-install-x86-minimal/ 目录。如果需要所有其它平台的，请进入 current-iso/ 目录。

 **附注**
一些架构例如**arm**，**mips**，和**s390** 是没有最小化安装 CD 的。 这是因为 [Gentoo 发行工程项目 （ Gentoo Release Engineering project ）](https://wiki.gentoo.org/wiki/Project:RelEng) 不支持构建这些平台的.iso文件。

在这个位置，安装媒体文件是那些带有.iso扩展名的文件。比如下面的清单：

CODE **releases/中的文件样本amd64/autobuilds/current-iso/**

```
[DIR] hardened/                                          05-Dec-2014 01:42    -   
[   ] install-amd64-minimal-20141204.iso                 04-Dec-2014 21:04  208M  
[   ] install-amd64-minimal-20141204.iso.CONTENTS        04-Dec-2014 21:04  3.0K  
[   ] install-amd64-minimal-20141204.iso.DIGESTS         04-Dec-2014 21:04  740   
[TXT] install-amd64-minimal-20141204.iso.DIGESTS.asc     05-Dec-2014 01:42  1.6K  
[   ] stage3-amd64-20141204.tar.bz2                      04-Dec-2014 21:04  198M  
[   ] stage3-amd64-20141204.tar.bz2.CONTENTS             04-Dec-2014 21:04  4.6M  
[   ] stage3-amd64-20141204.tar.bz2.DIGESTS              04-Dec-2014 21:04  720   
[TXT] stage3-amd64-20141204.tar.bz2.DIGESTS.asc          05-Dec-2014 01:42  1.5K
```

在上面的例子中， install-amd64-minimal-20141204.iso文件是最小化安装CD。但可以看到,还有其他相关文件存在:

- .CONTENTS 文件是一个文本文件，它列出了安装媒介中的所有文件。这个文件可用于在下载前确认安装媒介是否包含特定的固件和驱动程序。
- .DIGESTS 文件包含了ISO文件的Hash值，有不同的Hash格式／算法。这个文件可以用来验证已下载的ISO文件有没有损坏。
- .DIGESTS.asc 文件不仅包含了ISO文件的Hash值（和 .DIGESTS 文件一样），还包含了它的加密签名。这个文件即可用于验证已下载的ISO文件是否损坏，也可验证文件确实是由Gentoo发行工程组（Gentoo Release Engineering Team）发布而没有被篡改。

现在可以先忽略当前位置的其他文件——它们在安装的后续步骤中会被提到。下载 .ISO，另外如果想要验证下载的文件，同时下载ISO文件对应的  .DIGESTS.asc。 .CONTENTS 文件不需要下载，因为安装指南后续不会用到这个文件。 .DIGESTS 这个文件和.DIGESTS.asc 文件包含相同的信息，除此以外后者还包含有上面文件的数字签名。

### 校验下载的文件

 **附注**
这是一个可选步骤，并不是安装 Gentoo Linux 所必须的。但是，我们仍然推荐这么做，以此来确保下载的文件没有损坏，以及确保下载文件确实由 [Gentoo基础设施团队](https://wiki.gentoo.org/wiki/Project:Infrastructure)提供。

通过 .DIGESTS 和 .DIGESTS.asc 文件，可以使用合适的工具来校验 ISO 文件的有效性。校验通常有两个步骤：　　

1. 首先，验证加密签名，确保安装文件是由Gentoo发行工程组（ Gentoo Release Engineering team ） 提供
2. 如果加密签名是有效的，就验证它的文件校验值 （比如 SHA512,WHIRLPOOL），以此来确认下载的文件没有损坏。

#### 在微软 Windows 操作系统上校验

在微软 Windows 系统上，已经安装用来验证校验和加密签名工具的可能性很低。

首先验证文件数字（ GPG ）签名，可以使用类似 [GPG4Win](http://www.gpg4win.org/) 这样的工具。安装完工具后，需要导入 Gentoo 发行工程组（Gentoo Release Engineering Team）的公钥。  公钥列表在： [数字签名页](https://www.gentoo.org/downloads/signatures/)。 一但导入完成，用户就可以验证 .DIGESTS.asc 文件的数字签名。

 **重要**
这并不能验证 .DIGESTS 文件是否正确，只是验证有.DIGESTS.asc 文件。这同时也意味着 .DIGESTS.asc 文件所包含的校验和的值也一起被验证了，这就是为什么上面的说明只要求下载 .DIGESTS.asc 文件。

可以使用 [Hashcalc 应用](https://www.slavasoft.com/hashcalc/) 来计算校验和，当然还有许多其他工具也可以用。在大多数情况下，这些工具将向用户显示计算出来的校验值，用户需要将它和 .DIGESTS.asc 文件中的值进行比对验证。

#### 在已有的 Linux 系统上校验

在 Linux 系统上,最常用的验证加密签名的方法就是使用 [app-crypt/gnupg](https://packages.gentoo.org/packages/app-crypt/gnupg) 这个软件。安装了这个程序,就可以使用以下命令来验证 .DIGESTS.asc 文件中的数字（GPG）签名。

首先，下载 [数字签名页](https://www.gentoo.org/downloads/signatures/) 中正确的密匙：

```
user $``gpg --keyserver hkps://keys.gentoo.org --recv-keys 0xBB572E0E2D182910
gpg: requesting key 0xBB572E0E2D182910 from hkp server pool.sks-keyservers.net
gpg: key 0xBB572E0E2D182910: "Gentoo Linux Release Engineering (Automated Weekly Release Key) <releng@gentoo.org>" 1 new signature
gpg: 3 marginal(s) needed, 1 complete(s) needed, classic trust model
gpg: depth: 0  valid:   3  signed:  20  trust: 0-, 0q, 0n, 0m, 0f, 3u
gpg: depth: 1  valid:  20  signed:  12  trust: 9-, 0q, 0n, 9m, 2f, 0u
gpg: next trustdb check due at 2018-09-15
gpg: Total number processed: 1
gpg:         new signatures: 1
```

或者，您可以使用[WKD](https://wiki.gentoo.org/wiki/WKD)来下载密钥：

```
user $``wget -O- https://gentoo.org/.well-known/openpgpkey/hu/wtktzo4gyuhzu8a4z5fdj3fgmr1u6tob?l=releng | gpg --import
--2019-04-19 20:46:32--  https://gentoo.org/.well-known/openpgpkey/hu/wtktzo4gyuhzu8a4z5fdj3fgmr1u6tob?l=releng
Resolving gentoo.org (gentoo.org)... 89.16.167.134
Connecting to gentoo.org (gentoo.org)|89.16.167.134|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 35444 (35K) [application/octet-stream]
Saving to: 'STDOUT'
 
     0K .......... .......... .......... ....                 100% 11.9M=0.003s
 
2019-04-19 20:46:32 (11.9 MB/s) - written to stdout [35444/35444]
 
gpg: key 9E6438C817072058: 84 signatures not checked due to missing keys
gpg: /tmp/test2/trustdb.gpg: trustdb created
gpg: key 9E6438C817072058: public key "Gentoo Linux Release Engineering (Gentoo Linux Release Signing Key) <releng@gentoo.org>" imported
gpg: key BB572E0E2D182910: 12 signatures not checked due to missing keys
gpg: key BB572E0E2D182910: 1 bad signature
gpg: key BB572E0E2D182910: public key "Gentoo Linux Release Engineering (Automated Weekly Release Key) <releng@gentoo.org>" imported
gpg: Total number processed: 2
gpg:               imported: 2
gpg: no ultimately trusted keys found
```

下一步验证 .DIGESTS.asc 文件的数字（GPG）签名：

```
user $``gpg --verify install-amd64-minimal-20141204.iso.DIGESTS.asc
gpg: Signature made Fri 05 Dec 2014 02:42:44 AM CET
gpg:                using RSA key 0xBB572E0E2D182910
gpg: Good signature from "Gentoo Linux Release Engineering (Automated Weekly Release Key) <releng@gentoo.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 13EB BDBE DE7A 1277 5DFD  B1BA BB57 2E0E 2D18 2910
```

为了绝对确定所有文件都是有效的，验证上面显示的密匙指纹信息是否和 [数字签名页](https://www.gentoo.org/downloads/signatures/) 的密匙指纹信息一致。

确认数字签名有效后，接下来就是验证校验值，以确保下载的ISO文件没有损坏。 .DIGESTS.asc 文件包含了多个哈希算法，所以验证正确校验和的方法之一是先找到登记在文件 .DIGESTS.asc 中的相应的校验值。例如，获取 SHA512 的校验值：

```
user $``grep -A 1 -i sha512 install-amd64-minimal-20141204.iso.DIGESTS.asc
# SHA512 HASH
364d32c4f8420605f8a9fa3a0fc55864d5b0d1af11aa62b7a4d4699a427e5144b2d918225dfb7c5dec8d3f0fe2cddb7cc306da6f0cef4f01abec33eec74f3024  install-amd64-minimal-20141204.iso
--
# SHA512 HASH
0719a8954dc7432750de2e3076c8b843a2c79f5e60defe43fcca8c32ab26681dfb9898b102e211174a895ff4c8c41ddd9e9a00ad6434d36c68d74bd02f19b57f  install-amd64-minimal-20141204.iso.CONTENTS
```

在上面的输出中，显示了两个SHA512校验和：一个用于文件：install-amd64-minimal-20141204.iso，一个用于与之对应的 .CONTENTS 文件。只有第一个校验值有用，因为要用它来和下面计算出来的 SHA512 的校验值进行比较：

```
user $``sha512sum install-amd64-minimal-20141204.iso
364d32c4f8420605f8a9fa3a0fc55864d5b0d1af11aa62b7a4d4699a427e5144b2d918225dfb7c5dec8d3f0fe2cddb7cc306da6f0cef4f01abec33eec74f3024  install-amd64-minimal-20141204.iso
```

如果两个校验值匹配，那么表明文件没有损坏，安装可以继续进行。损坏的文件会导致安装出现问题，请重新下载。

### 刻录光盘

当然,只是下载一个 ISO 文件是无法开始 Gentoo Linux 的安装的。需要将这个ISO文件刻录成一张用来启动的 CD  光盘，是要将 ISO 文件里的内容而不是 ISO 文件本身刻录到CD光盘上。下面介绍了一些常见的方式 - 这里可以找到其他更复杂的方式：[[如何刻录ISO文件](https://wiki.gentoo.org/wiki/FAQ/zh-cn#.E5.A6.82.E4.BD.95.E5.88.BB.E5.BD.95ISO.E6.96.87.E4.BB.B6.EF.BC.9F|)].

#### 在Microsoft Windows 7和更高版本上刻录

Microsoft Windows 7 及更高版本可以将 ISO 映像装载和刻录到光学媒体，无需第三方软件。 只需插入可刻录磁盘，浏览到下载的 ISO 文件，在 Windows 资源管理器中右键单击该文件，然后选择“刻录磁盘映像”。

#### 在已有的 Linux 系统上刻录

[app-cdr/cdrtools](https://packages.gentoo.org/packages/app-cdr/cdrtools)中的**cdrecord**可以在Linux下烧录ISO镜像

将ISO文件刻录到 /dev/sr0 设备的 CD 光碟上（这是系统上的第一个 CD 设备-在必要时将其替换为正确的设备）:

```
user $``cdrecord dev=/dev/sr0 install-amd64-minimal-20141204.iso
```

喜欢使用图形化界面的用户可以使用 K3B ，它由 [kde-app/k3b](https://packages.gentoo.org/packages/kde-app/k3b)  软件包提供。在 K3B 软件中，选择“工具”（Tools）菜单，然后选择“刻录CD镜像”（Burn CD Image）。

## 启动

### 启动安装媒介

安装媒介准备就绪后，就可以启动了。 将安装媒介插入系统中，重启，然后进入主板的固件用户界面。 通常是在开机自检（POST）过程中通过在键盘上按DEL, F1, F10, 或 ESC 进入，“触发”键取决于系统和主板。 如果使用主板的型号作为关键字在互联网搜索引擎进行搜索，  结果应该很容易确定。进入主板的固件菜单后，更改引导顺序，以便在内部磁盘设备之前尝试外部可启动媒介（CD / DVD盘或USB驱动器）。  否则，系统很可能会重新启动到内部磁盘设备，从而忽略外部启动媒介。

 **重要**
如果想安装使用 UEFI 引导的 Gentoo  ，建议立即使用UEFI启动。如果不用 UEFI 来启动，可能就要在最后完成 Gentoo Linux 的安装之前制作一个可以启动的 UEFI U盘（或其他介质）。

如果启动没有成功，请确保将安装媒介插入系统，然后重新启动。这是会显示一个启动提示符。 此时按Enter键将使用默认的启动选项启动。如果要使用自定义引导选项引导安装媒介，请按照启动选项指定一个内核，然后按Enter键。

 **Note**
在大多数情况下，默认的Gentoo内核可以像之前提到的那样可以在没有任何指定参数的情况下正常工作，有关启动故障排除和专家选项，请继续执行此部分。否则，只需按Enter并跳转至[额外的硬件配置](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Media/zh-cn#Extra_hardware_configuration).

在启动提示符下，用户可以按 F1 键显示可用的内核，按 F2 按键显示可用的启动选项。如果在15秒内没做任何选择（既不显示信息，也不选择内核）安装媒介将会从硬盘启动。这样不用将 CD 光盘从光盘驱动器里拿出来，也可以在安装过程中重启和尝试已安装好的环境（这有时在远程安装的时候很有用）。

提到了指定一个内核。 在最小安装介质上，只提供了两个预定义的内核启动选项。 默认选项叫**gentoo**。 另一个是“-nofb”变量; 这会禁用内核帧缓冲区支持。

下一节将简要介绍可用的内核及其说明：

#### 内核选择

- gentoo

  默认内核，支持K8 CPU（包括NUMA支持）和EM64T CPU。

- gentoo-nofb

  与“gentoo”相同，但没有framebuffer支持。

- memtest86

  测试本地RAM的错误。

引导选项可以配合内核进一步调整引导过程的行为。 

#### 硬件选择

- acpi=on

  这个选项载入对 ACPI 的支持，同时也会让 CD 光盘在启动时运行 acpid 守护进程。在系统需要 ACPI 才能正常工作的情况下才需要设置此选项。超线程（Hyperthreading）的支持不需要此选项。

- acpi=off

  彻底禁用 ACPI。这个选项在一些较老的系统上比较有用，同样也是使用 APM 功能的必需项。这个选项也会禁用处理器的超线程支持。

- console=X

  这会启用对一些终端的访问许可。它的第一个参数是设备，默认是 ttyS0， 之后的其它选项请使用逗号分割。默认参数是 9600,8,n,1 。

- dmraid=X

  这会传递参数给 device-mapper RAID 子系统。需要在参数两端加上括号。

- doapm

  这会加载对 APM 驱动的支持。这同时需要 `acpi=off`.

- dopcmcia

  这会加载对 PCMCIA 和 Cardbus 硬件的支持，并且会使  pcmcia cardmgr 在 CD 启动时被启用. 这只有在从 PCMCIA/Cardbus 设备启动时才需要。

- doscsi

  这会加载对大部分 SCSI 控制器的支持。当从使用 SCSI 内核子系统的 USB 设备启动时需要这个参数。

- sda=stroke

  这会允许用户对整块硬盘进行分区，即使是 BIOS 无法控制的大容量硬盘。这个选项只有在使用老的 BIOS 的机器上才需要。注意，请把 “sda” 替换为需要这么做的设备。

- ide=nodma

  这会强制内核禁用 DMA ，一些 IDE 芯片组和一些 CDROM 的驱动需要这么做才能工作。如果系统无法正常读取 IDE 的 CDROM，可以试试这个选项。这同时也会禁止默认的 hdpram 设置被执行。

- noapic

  这会禁用一些新主板上的高级程序中断控制器（Advanced Programmable Interrupt Controller，APIC），因为这可能会造成一些旧的硬件无法正常工作。

- nodetect

  这会禁止 CD 的全部自动检测功能，包括对硬件的检测和 DHCP 探测。 这有助于对启动失败的 CD 或驱动器进行查错。

- nodhcp

  这会禁用在被发现的网卡上进行 DHCP 探测。这在需要使用固定 IP 的时候很有用。

- nodmraid

  禁用对 device-mapper RAID 的支持，比如板载的IDE/SATA RAID控制器。

- nofirewire

  这禁用了对 “火线”（ Firewire ） 模块的加载。该选项只在“火线”（Firewire）造成 CD 无法正常启动时才需要。

- nogpm

  这禁用对 gpm 控制台的鼠标（gpm console mouse）的支持。

- nohotplug

  这会禁止在启动时加载对热插拔和冷插拔的脚本。这有助于对启动失败的 CD 或驱动器进行查错。

- nokeymap

  这会禁用选择键盘映射（只有不是 US 键盘时才需要进行对键盘映射的设置）。

- nolapic

  这会在单处理器内核里禁用本地APIC。

- nosata

  这会禁止加载 Serial ATA 模块. 这在 SATA 子系统出错时才需要。

- nosmp

  这会在支持 SMP 的内核上禁用 SMP（Symmetric Multiprocessing）。这在为排查与 SMP 相关的驱动或内核错误时很有用。

- nosound

  这会禁止对音频的支持和音量控制。这在音频系统造成问题时很有用。

- nousb

  这会禁止自动加载的 USB 模块。这在 USB 出现问题时很有用。

- slowusb

  这会为慢速的USB CDROM 在启动时添加更多额外的中断，就像 IBM BladeCenter 那样。

#### 逻辑卷／设备管理

- dolvm

  这会启用 Linux 的逻辑分区管理器（Logical Volume Management）。

#### 其他选项

- debug

  启用调试代码。这可能会显得乱糟糟的，因为这会向输出大量的数据。

- docache

  这会把整个 CD 运行环境缓存到内存中，这会使用户可以卸载 /mnt/cdrom 并挂载另外一个 CDROM 。这个选项需要至少两倍于 CD 大小的内存空间。

- doload=X

  这会使启动时内存盘（initial ramdisk，initrd）加载这之后列出来的模块和它们的依赖。把“X”替换为模块名称，当需要加载多个模块时请用逗号分割。

- dosshd

  在启动时启用 sshd 服务，这在无人值守安装时很有用。

- passwd=foo

  这会将等号后的字符设置为 root 用户的密码，当使用“dosshd”参数时需要这么做因为默认的 root 密码是留空的。

- noload=X

  这会使启动时内存盘（initial ramdisk，initrd）跳过对某些会造成问题的特定模块的加载。使用方法和“doload”相同。

- nonfs

  禁止在启动时启用 portmap/nfsmount 。

- nox

  这会使启用X的 LiveCD 不自动启动X，而是使用命令行。

- scandelay

  这会使 CD 在启动过程中等待十秒来使一些初始化很慢的设备完成初始化。

- scandelay=X

  这允许用户指定 CD 在启动过程中等待一些初始化很慢的设备完成初始化所需的延迟的时间。把X替换为所需要等待的时间（以秒为单位，只需要填写数字）。

 **附注**
启动媒介将先检查`no*`选项，再检查`do*`选项，所以那些选项可以按照这个顺序覆盖。

现在启动安装媒介，选择一个内核（如果默认的 **gentoo** 的内核不能满足）和引导选项。作为示例，我们引导 **gentoo** 内核启动，并带有`dopcmcia`作为内核参数：

```
boot:``gentoo dopcmcia
```

接下来迎接用户的是一个引导屏幕和进度条。如果用来安装系统的是一个非US键盘，确保马上按Alt + F1来切换到详细模式并遵照提示。如果在10秒钟内什么都没有选，则接受默认（US键盘）并继续引导过程。一旦引导过程完成，用户将自动以*root*超级用户身份登录到“Live”Gentoo Linux环境。当前控制台将显示一个root提示符，并且可以通过按Alt + F2、Alt + F3和Alt + F4切换到其他控制台。按Alt + F1返回到启动时的那个。



### 额外的硬件配置

当安装媒介启动时，它会尝试检测所有的硬件设备并加载合适的内核模块来支持硬件。在绝大多数的情况下，它工作得很好。然而，在某些情况下它可能没有自动加载系统所需的内核模块。如果 PCI 自动检测错过了一些系统硬件，相应的内核模块就必须手动加载了。

下面例子手工加载了 8139too 模块（它提供对某些类型的网卡的支持）：

```
root #``modprobe 8139too
```

### 可选：用户账号

如果其他人需要访问安装环境，或者需要以非 root 用户的身份在安装媒介上运行命令（例如出于安全原因使用没有  root 特权的 **irssi** 聊天），这时就需要创建额外的用户帐户，并将 root 用户密码设为强密码。

使用 **passwd** 命令来修改 root 用户密码：

```
root #``passwd
New password: (Enter the new password)
Re-enter password: (Re-enter the password)
```

要创建一个用户账户，先输入他们的信息，然后设置密码。用 **useradd**  和 **passwd** 命令来完成这些操作。

在下面的例子中，创建了一个名为“john”的用户。

```
root #``useradd -m -G users john 
root #``passwd john
New password: (Enter john's password)
Re-enter password: (Re-enter john's password)
```

使用 **su** 命令可以从 root 用户（当前用户）切换到新建的用户：

```
root #``su - john
```

### 可选：在安装时查看文档

#### TTYs

要在安装期间查看 Gentoo 安装手册，首先要按照上面的方法创建一个新的用户帐户。然后按 Alt+F2 进入一个新的终端。

在安装期间， 可以用 **links** 命令来浏览 Gentoo 安装手册 - 当然，只有在互联网连接可用的时候才行。

```
user $``links https://wiki.gentoo.org/wiki/Handbook:AMD64/zh-cn
```

要回到原来的终端，请按 Alt+F1 。

#### GNU Screen

```
Screen是官方Gentoo安装介质中默认安装的实用程序。对于经验丰富的Linux爱好者来说，使用 screen 分割窗口查看安装说明，而不是上面提到的多个TTY的方法， 这可能更高效。
```

### 可选：启动SSH服务

要在安装期间允许其他用户访问你的系统（可能是为了在安装过程中提供技术支持，甚至远程安装），需要添加一个用户账户（就像之前的文档描述的那样）同时 SSH 服务也要启动。

若要在 OpenRC init 启动 SSH 服务,请执行以下命令:

```
root #``rc-service sshd start
```

 **附注**
如果用户登录到系统，他们将看到一个本系统主机密钥需要确认的信息（也就是我们说的密匙指纹）。此行为是典型的并且可以像预期一样与SSH服务器进行初始连接。但是，以后当系统设置好，并有人登录到新安装的系统时，SSH客户端会警告主机密钥已被更改。这是因为现在用户登录 - 对于SSH来讲 -  是一个不同的服务器（即新安装的Gentoo系统，而不是现在正在使用的安装系统环境）。请按照屏幕上的指示，去替换用户端的主机密钥

网络需要能正常工作，sshd 才能使用。请参照 [配置网络](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn) 的内容继续安装。

## 自动网络检测

它能够自动检测到么？

如果系统接入到一个有 DHCP 服务器的以太网络，那么很可能会自动配置好网络。这样的话，安装媒介所包含的很多网络命令，比如**ssh**、**scp**、**ping**、**irssi**、**wget**、**links**，以及其他的一些命令, 都可以立即工作。

### 识别接口名称

#### ifconfig命令

如果网络已配置，**ifconfig**命令应该会列出一个或多个网络接口（围绕着lo）。在下面的示例中显示为eth0：

```
root #``ifconfig
eth0      Link encap:Ethernet  HWaddr 00:50:BA:8F:61:7A
          inet addr:192.168.0.2  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::50:ba8f:617a/10 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1498792 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1284980 errors:0 dropped:0 overruns:0 carrier:0
          collisions:1984 txqueuelen:100
          RX bytes:485691215 (463.1 Mb)  TX bytes:123951388 (118.2 Mb)
          Interrupt:11 Base address:0xe800 
```

作为[预测的网络接口名称](http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/)控制的结果, 系统的接口名称可以和旧的eth0命名规则很不一样。近期的安装媒介可能显示常规网络接口名字像是eno0、ens1或enp5s0。查看**ifconfig**输出中找到有你本地网络相关的IP地址的接口。

 **Tip**
如果使用标准的**ifconfig**命令没有显示出接口，尝试使用带有`-a`选项的相同的命令。这个选项强制这个工具去显示系统检测到的所有的网络接口，不管他们是up或down状态。如果**ifconfig -a**没有提供结果，则硬件有错误或者接口驱动没有加载到内核中。这些情况都超过本手册的范围。联系[#gentoo](ircs://irc.libera.chat/#gentoo) ([webchat](https://web.libera.chat/#gentoo))需求支持。

#### ip命令

作为**ifconfig**的一个备选，**ip**命令可以用来识别接口名称。下面的示例展示了**ip addr**（由于是另外一个系统，所以显示的信息不同于前一个示例）的输出:

```
root #``ip addr
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether e8:40:f2:ac:25:7a brd ff:ff:ff:ff:ff:ff
    inet 10.0.20.77/22 brd 10.0.23.255 scope global eno1
       valid_lft forever preferred_lft forever
    inet6 fe80::ea40:f2ff:feac:257a/64 scope link 
       valid_lft forever preferred_lft forever
```

上面的输出读起来可能比另外的更乱一点。在上面的示例中，接口名称直接跟在数字后面；它是eno1。

在本文档的其余部分，手册中假设要操作的网络接口叫作eth0。

### 可选：配置代理

如果要通过代理访问互联网，则在安装过程中需要设置代理信息。定义一个代理十分容易：只需要定义一个包含代理服务器信息的变量即可。

大多数情况下，只要将这个变量定义为代理服务器主机名。作为示例，我们假定代理叫作proxy.gentoo.org并且端口为8080。

设置一个HTTP代理（用于HTTP或HTTPS流量）:

```
root #``export http_proxy="http://proxy.gentoo.org:8080"
```

设置一个FTP代理：

```
root #``export ftp_proxy="ftp://proxy.gentoo.org:8080"
```

设置一个RSYNC代理：

```
root #``export RSYNC_PROXY="proxy.gentoo.org:8080"
```

如果代理要求用户名和密码，针对变量使用下面语言：

CODE **添加用户名/密码到代理变量**

```
http://username:password@proxy.gentoo.org:8080
```

### 测试网络

尝试ping你的ISP的DNS服务器（可在/etc/resolv.conf中找到）和选择一个网站。这可确信网络正常工作并且网络包可以到达网络，DNS名称解析能正常工作等等。

```
root #``ping -c 3 www.gentoo.org
```

如果这些都工作，则本章节中其余的部分可跳过，直接跳到安装介绍的下一步骤（[准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)）。

## 自动网络配置

如果网络没有立即工作，一些安装媒介允许用户使用**net-setup**（针对常规或无线网络），**pppoe-setup**（针对ADSL用户）或**pptp**（针对PPTP用户）。

如果安装媒介没有包含这些工具，继续[手动配置网络](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#.E6.89.8B.E5.8A.A8.E9.85.8D.E7.BD.AE.E7.BD.91.E7.BB.9C)。

- 常规以太网用户应该继续[默认：使用net-setup](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Default:_Using_net-setup)
- ADSL用户应该继续[备选：使用PPP](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Alternative:_Using_PPP)
- PPTP用户应该继续[备选：使用PPTP](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Alternative:_Using_PPTP)

### 默认：使用net-setup

如果网络没有自动配置，最简单的方式是运行**net-setup**脚本来设置：

```
root #``net-setup eth0
```

**net-setup**将会询问关于网络环境的一些问题。当所有这些完成后，网络连接就应该工作。以前面的方式测试网络连接。如果测试通过，恭喜！跳过本章节剩余部分并继续[准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)。

如果网络还是不能工作，继续[手动配置网络](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Manual_network_configuration)。

### 可选：使用PPP

假设需要使用PPPoE连接到互联网，安装CD（任何版本）包含ppp来使这件事变得容易。使用提供的**pppoe-setup**脚本来配置连接。设置过程中将询问已连接到你的ADSL调制解调器的以太网设备、用户名和密码、DNS服务器的IP地址，以及是否需要一个简单的防火墙。

```
root #``pppoe-setup 
root #``pppoe-start
```

如果还是有什么错误，再次在etc/ppp/pap-secrets或/etc/ppp/chap-secrets中检查用户名和密码都是正确的，并且确保使用了正确的以太网设备。如果以太网设备不存在，则需要加载合适的网络模块。如果是那样，继续[手动网络配置](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Manual_network_configuration)将解释如何加载合适的网络模块。

如果所有事都还，继续[准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)。

### 可选：使用PPTP

如果需要PPTP支持，使用安装CD提供的**pptpclient**。但是首先确保配置是正确的。编辑/etc/ppp/pap-secrets或/etc/ppp/chap-secrets让它包含正确的用户名/密码组合：

```
root #``nano -w /etc/ppp/chap-secrets
```

如果需要，继续调整/etc/ppp/options.pptp：

```
root #``nano -w /etc/ppp/options.pptp
```

当所有事都已完成，运行**pptp**（带着一些options.pptp无法设定的选项）来连接到服务器：

```
root #``pptp <server ipv4 address>
```

现在继续[准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)。

## 手动配置网络

### 加载适当的内核网络模块

安装光盘在启动时，会尝试检测所有硬件设备并加载适当的内核模块（驱动程序）以支持你的硬件。绝大多数情况下，它都做得非常好。尽管如此，在某些情况下它可能还是无法为当前网络设备自动载入需要的内核模块。

如果**net-setup**或**pppoe-setup**都失败，则可能是网络没有立即被找到。也就是说用户可能需要手动加载合适的内核模块。

要找出什么内核模块提供网络，使用**ls**命令：

```
root #``ls /lib/modules/`uname -r`/kernel/drivers/net
```

如果找到一个针对网络设备的驱动，使用**modprobe**来加载内核模块。比如，要加载pcnet32模块：

```
root #``modprobe pcnet32
```

要检查网卡现在是否检测到，使用**ifconfig**。一个检测到的网卡应该在结果中像这样（再一次，这里的eth0只是一个示例）：

```
root #``ifconfig eth0
eth0      Link encap:Ethernet  HWaddr FE:FD:00:00:00:00  
          BROADCAST NOARP MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
```

不过如果你得到如下错误信息，说明没有检测到网卡：

```
root #``ifconfig eth0
eth0: error fetching interface information: Device not found
```

系统中可用网络接口命名可以通过/sys文件系统列出。

```
root #``ls /sys/class/net
dummy0  eth0  lo  sit0  tap0  wlan0
```

在上面的示例中，找到了6个接口。eth0是最像（有线）以太网络适配器，而wlan0 是无线的。

假设现在网络已经检测到了，重新尝试**net-setup**或**pppoe-setup**（现在应该工作了），但是对于铁杆的人，我们还是要解释如何手动配置网络。

基于你的网络从下面的章节中选择一个进行设置：

- [使用DHCP](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Using_DHCP) 针对自动获取IP
- [准备无线访问](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Preparing_for_wireless_access) 如果使用无线网络
- [了解网络术语](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Understanding_network_terminology) 解释了关于网络的基础
- [使用ifconfig和route](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Using_ifconfig_and_route) 解释了如何手动设置网络

### 使用DHCP

DHCP（动态主机配置协议）使自动接受网络信息（IP地址、掩码、广播地址、网关、名称服务器等）变得容易。这只在网络中有DHCP服务器（或者如果ISP提供商提供一个DHCP服务）时有用。要使一个网络接口自动接受信息，使用**dhcpcd**：

```
root #``dhcpcd eth0
```

一些网络管理员要求你使用DHCP服务器所提供的主机名和域名。 这种情况下请用：

```
root #``dhcpcd -HD eth0
```

如果这个工作的话（试着ping一些Internet服务器，像Google的8.8.8.8 或者 Cloudflare的 1.1.1.1 译者注：中国的114.114.114.114），则所有事情都设置好了并可以继续。跳过剩下的章节并继续到[准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)。

### 准备无线网络链接

 **附注**
可能只有特定的架构支持**iw**命令。如果这个命令不可用，检查[net-wireless/iw](https://packages.gentoo.org/packages/net-wireless/iw)包是否可用于当前架构。除非安装[net-wireless/iw](https://packages.gentoo.org/packages/net-wireless/iw)包，否则**iw**命令将一直不可用。

当使用一块无线（802.11）网卡，在继续之前需要先配置无线设置。要查看当前无线网卡的设置，你可以使用**iw**。运行**iw**可能会显示如下：

```
root #``iw dev wlp9s0 info
Interface wlp9s0
	ifindex 3
	wdev 0x1
	addr 00:00:00:00:00:00
	type managed
	wiphy 0
	channel 11 (2462 MHz), width: 20 MHz (no HT), center1: 2462 MHz
	txpower 30.00 dBm
```

检查当前连接：

```
root #``iw dev wlp9s0 link
Not connected.
```

或

```
root #``iw dev wlp9s0 link
Connected to 00:00:00:00:00:00 (on wlp9s0)
	SSID: GentooNode
	freq: 2462
	RX: 3279 bytes (25 packets)
	TX: 1049 bytes (7 packets)
	signal: -23 dBm
	tx bitrate: 1.0 MBit/s
```

 **附注**
一些无线网卡的设备名可能是wlan0或ra0而不是wlp9s0。运行**ip link** 来识别正确的设备名称。

对于大多数用户，只需要两个设置来连接，即ESSID（也称无线网络名称）和可选的WEP密钥。

- 首先，确保接口处于活动状态：



- 连接到名为“GentooNode”的开放网络：



- 设置一个WEP密钥：使用`d:`前缀：



- 使用ASCII WEP密钥连接：



 **附注**
如果无线网络配置为WPA或WPA2，则需要使用**wpa_supplicant**。关于为Gentoo Linux配置无线网络的更多信息，请阅读Gentoo手册中的[无线网络章节](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Wireless/zh-cn)。

使用**iw dev wlp9s0 link**确认无线设置。如果无线已经工作，继续按下一章节（[了解网络术语](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Understanding_network_terminology)）配置IP级别的网络选项或者使用前面描述的**net-setup**工具。

### 网络术语解读

 **附注**
如果IP地址、广播地址、掩码和名称服务器这些全都了解，则可以跳过这个子章节，进入到[使用**ifconfig**和**route**](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking/zh-cn#Using_ifconfig_and_route)。

如果以上所做的全部失败，你将不得不手动配置你的网络。这其实一点也不难。不过，你需要熟悉一些网络术语，才能配置好网络令自己满意。读完本节之后，你将了解到什么是网关，子网掩码是作什么用的，广播地址是如何形成的，以及为什么需要名称服务器。

在网络中，主机通过它们的IP地址（互联网协议地址）来标识。这个地址被看为是由四个0到255的数字来组成。很好，至少在使用IPv4（IP版本4）时。实事上，这样的一个IPv4地址包括32个位（1和0）。让我们来看一个示例：

CODE **一个IPv4地址示例**

```
IP地址（数字）：   192.168.0.2
IP地址（位）：     11000000 10101000 00000000 00000010
                   -------- -------- -------- --------
                      192      168       0        2
```

 **附注**
比IPv4更成功的IPv6使用128位（1和0）。在这章节中，我们只关注IPv4地址。

在所有可访问到的网络里，这样的IP地址跟主机是一一对应的（比如你能够连接到的每台主机必须拥有一个唯一的IP地址）。为了区别一个网络内部和外部的主机，IP地址被分为两个部分：网络部分和主机部分。

由一堆1后面跟着一堆0的掩码写出了网络的分离。IP映射到1的部分是网络部分，剩下的是主机部分。通常，掩码可以写成IP地址。

CODE **网络/主机分离示例**

```
IP地址：       192      168       0        2
            11000000 10101000 00000000 00000010
掩码：      11111111 11111111 11111111 00000000
               255      255      255       0
           +--------------------------+--------+
                       网络              主机
```

换句话说，192.168.0.14是示例网络的一部分，但192.168.1.2不是。

广播地址是一个拥有相同网络部分，但是主机部分全是1的IP地址。网络上的每一个主机都监听这个IP地址。它的真正用途是用来广播包。

CODE **广播地址**

```
IP地址：       192      168       0        2
            11000000 10101000 00000000 00000010
广播：      11000000 10101000 00000000 11111111
               192      168       0       255
           +--------------------------+--------+
                       网络              主机
```

为了能在互联网上冲浪，网络中的每个主机必须知道哪个主机共享着互联网连接。这个主机叫作网关。它同样是一台常规主机，它有一个常规IP地址（比如192.168.0.1）。

之前我们说每台主机都有它自己的IP地址。要通过名称来到达这台主机（代替一个IP地址）我们需要一个服务去翻译一个名称（比如dev.gentoo.org）到一个IP地址（64.5.62.82）。这样的服务叫做*名称服务*。要使用这样的服务，需要在/etc/resolv.conf中定义所需的名称服务器。

有些情况下，网关同时也是名称服务器。不然的话，需要在这个文件中添加ISP提供的名称服务器。

总结一下，在继续之前需要下面的信息：

| 网络项目   | 示例                           |
| ---------- | ------------------------------ |
| 系统IP地址 | 192.168.0.2                    |
| 掩码       | 255.255.255.0                  |
| 广播       | 192.168.0.255                  |
| 网关       | 192.168.0.1                    |
| 名称服务器 | 195.130.130.5, 195.130.130.133 |

### 使用ifconfig和route

使用[sys-apps/net-tools](https://packages.gentoo.org/packages/sys-apps/net-tools)包中的工具，手动设置网络通常包括三个步骤：

1. 使用**ifconfig**指派一个IP地址
2. 使用**route**设置到网关的路由
3. 通过/etc/resolv.conf设置名称服务器的IP完成

要指派一个IP地址，需要IP地址、广播地址和掩码。运行下面的命令，替换${IP_ADDR}为正确的IP地址、${BROADCAST}为正确的广播地址以及${NETMASK}为正确的掩码：

```
root #``ifconfig eth0 ${IP_ADDR} broadcast ${BROADCAST} netmask ${NETMASK} up
```

使用**route**设置路由。替换${GATEWAY}为正确的网关IP地址：

```
root #``route add default gw ${GATEWAY} 
```

现在用文本编辑器打开/etc/resolv.conf：

```
root #``nano -w /etc/resolv.conf
```

使用下面的模板填入名称服务器。修改${NAMESERVER1}和${NAMESERVER2}为名称服务器的IP地址。可以添加多个名称服务器：

FILE **`/etc/resolv.conf`****默认 /etc/resolv.conf 的模板**

```
nameserver ${NAMESERVER1}
nameserver ${NAMESERVER2}
```

就是这样。现在通过ping一些互联网服务器（像Google的8.8.8.8 或者 Cloudflare的 1.1.1.1）来测试网络。如果这个工作的话，再次恭喜。继续到[准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)。

- [准备磁盘](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks/zh-cn)

  在安装 Gentoo 之前，必须创建一些必须的分区。本章说明了如何分区磁盘。

- [安装Gentoo的安装文件](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage/zh-cn)

  下载的 stage3 归档是基本的 Gentoo 系统，在这一章里我们描述了如何下载和提取 stage3 归档文件，以及配置 Portage- Gentoo 的软件包管理程序。

- [安装Gentoo基本系统](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base/zh-cn)

  在安装和配置完 stage3 文件后基本系统就搭建好了，这样我们就有了一个可用的最小化环境。

- [配置Linux内核](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel/zh-cn)

  Linux内核是每一个发行版的核心。本章说明了应该如何配置内核。

- [配置系统](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/System/zh-cn)

  系统安装过程中必须创建一些重要的配置文件，本章提供了这些文件和解释以及如何剪裁。

- [安装系统工具](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Tools/zh-cn)

  本章指导选择和安装一些重要的系统工具。

- [配置系统引导程序Bootloader](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Bootloader/zh-cn)

  本章指导安装和配置正确的系统引导程序。

- [收尾安装工作](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Finalizing/zh-cn)

  安装现在已经基本完成，本章记录了最后的收尾工作。

## 使用

- [Portage介绍](https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/Portage)

  本章介绍了读者必须了解的简单步骤，以便在其系统上维护软件。

- [USE标记](https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/USE/zh-cn)

  USE标记是Gentoo里面一个非常重要的概念，读者可以在本章学会如何使用USE标记以及USE标记如何和系统互动。

- [Portage功能特性](https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/Features/zh-cn)

  探索Portage所拥有的功能特性，例如支持分布式编译、ccache，等等。

- [初始化脚本（Init script）系统](https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/Initscripts/zh-cn)

  Gentoo使用一种特殊的初始化脚本格式，除了应有功能还允许依赖驱动的决策以及虚拟初始化脚本。本章说明了所有的这些概念和如何处理这些脚本。

- [环境变量](https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/EnvVar/zh-cn)

  本章说明了如何轻松地在 Gentoo 上管理环境变量，同时也介绍了一些常用的变量。

## 使用 Portage

- [文件和目录](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Files/zh-cn)

  想深入了解Portage，首先就要知道它把文件和数据存在哪里。

- [变量](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Variables/zh-cn)

  Portage 是完全可配置的，可以在配置文件中设置几个选项，也可以将其设置为环境变量。

- [混合使用软件分支](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Branches/zh-cn)

  Gentoo 提供的软件分布在不同的分支，取决于它的稳定性和所支持的架构。“混合使用软件分支”解释了如何配置这些分支，以及如何进行个别调整。

- [额外的工具](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Tools/zh-cn)

  Portage 带了几个额外的工具能让 Gentoo 有更好的使用体验。仔细阅读以了解如何使用 `dispatch-conf` 和其他工具。

- [定制包 repository](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/CustomTree/zh-cn)

  本章给出了一些提示和技巧，关于如何使用定制的包 repository、如何仅同步需要的分类、如何添加包，等等。

- [高级特性](https://wiki.gentoo.org/wiki/Handbook:AMD64/Portage/Advanced/zh-cn)

  随着时间的推移，Portage 发展得越来越成熟，新特性不断被添加。其中许多特性仅对更有经验的用户有用。本章介绍了这些 Portage 的新特性。



## 网络配置

- [入门](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Introduction/zh-cn)

  在最常见的使用环境中快速激活和使用网络端口的指南。

- [高级配置](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Advanced/zh-cn)

  在这里我们将了解到配置是如何起作用的——这是继续了解模块化网络所需的预备知识。

- [模块化网络](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Modular/zh-cn)

  学习如何选择不同的 DHCP 客户端，配置端口捆绑、桥接、VLANs，和其他内容。

- [无线](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Wireless/zh-cn)

  配置 Gentoo 的无线网络。

- [添加功能](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Extending/zh-cn)

  高级用户可以在网络工具中添加他们自己的功能。

- [动态管理](https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Dynamic/zh-cn)

  写给笔记本用户或者那些需要在不同网络中移动他们计算机的人。
