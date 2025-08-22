# ClamAV

[TOC]

## 概述

 ![](../../../Image/c/clamav_logo.png)

ClamAV® 是一个开源（GPL）的防病毒引擎，用于检测特洛伊木马、病毒、恶意软件和其他恶意威胁。用于各种情况，包括电子邮件和 Web 扫描以及端点安全。该软件包的核心是一个防病毒引擎，以共享库的形式提供。

> **提示：**
>
> ClamAV 不是传统的防病毒或端点安全套件。有关功能齐全的现代终端安全套件，请查看 *Cisco Secure Endpoint*。

ClamAV 由 Cisco Systems,Inc. 提供。

* The Standard

  ClamAV® 是邮件网关扫描软件的开源标准。

* 高性能

  ClamAV 包括一个多线程扫描程序守护程序、用于按需文件扫描和自动签名更新的命令行实用程序。

* 多才多艺

  ClamAV 支持多种文件格式和签名语言，以及文件和存档解包。

* 开源  

## 特征

- 命令行扫描程序。
- sendmail 的 Milter 接口。
- 高级数据库更新程序，支持脚本化更新和数字签名。
- 病毒数据库每天更新多次。
- 内置支持所有标准邮件文件格式。
- Built-in support for ELF executables and Portable Executable files packed with UPX, FSG, Petite, NsPack, wwpack32, MEW, Upack and obfuscated with SUE, Y0da Cryptor and others.
  内置对 ELF 可执行文件和可移植可执行文件的支持，这些文件与 UPX、FSG、Petite、NsPack、wwpack32、MEW、Upack 打包在一起，并与 SUE、Y0da Cryptor 等进行混淆。
- 内置对常用文档格式的支持，包括 MS Office 和 MacOffice 文件、HTML、Flash、RTF 和 PDF 。
- ClamAV 旨在快速扫描文件。
- The ClamOnAcc client for the ClamD  scanning daemon provides on-access scanning on modern versions of Linux. This includes an optional capability to block file access until a file  has been scanned (on-access prevention).
  实时保护（仅限 Linux ）。用于 ClamD 扫描守护程序的 ClamOnAcc 客户端在现代版本的 Linux 上提供按访问扫描。这包括一项可选功能，用于在扫描文件之前阻止文件访问（访问时防护）。
- ClamAV 可检测数百万种病毒、蠕虫、特洛伊木马和其他恶意软件，包括 Microsoft Office 宏病毒、移动恶意软件和其他威胁。
- ClamAV's bytecode signature runtime, powered by either LLVM or our custom  bytecode interpreter, allows the ClamAV signature writers to create and  distribute very complex detection routines and remotely enhance the  scanner’s functionality.
  ClamAV 的字节码签名运行时由 LLVM 或我们的自定义字节码解释器提供支持，允许 ClamAV 签名编写器创建和分发非常复杂的检测例程，并远程增强扫描程序的功能。
- Signed signature databases ensure that ClamAV will only execute trusted signature definitions.
  签名签名数据库确保 ClamAV 仅执行受信任的签名定义。
- ClamAV 扫描档案和压缩文件，但也可以防止档案炸弹。内置的存档提取功能包括：
  - Zip（包括 SFX，不包括一些较新或更复杂的扩展）
  - RAR（包括 SFX，大多数版本）
  - 7Zip
  - ARJ（包括 SFX）
  - Tar
  - CPIO
  - Gzip
  - Bzip2
  - DMG
  - IMG
  - ISO 9660
  - PKG
  - HFS+ 分区
  - HFSX 分区
  - APM 磁盘映像
  - GPT 磁盘映像
  - MBR 磁盘映像
  - XAR
  - XZ
  - Microsoft OLE2 （Office 文档）
  - Microsoft OOXML （Office 文档）
  - Microsoft Cabinet 文件（包括 SFX）
  - Microsoft CHM（编译的 HTML）
  - Microsoft SZDD 压缩格式
  - HWP (Hangul Word Processor documents)（谚文文字处理器文档）
  - BinHex
  - SIS（SymbianOS 软件包）
  - AutoIt
  - InstallShield
  - ESTsoft EGG
- 支持 Windows 可执行文件解析，也称为 32/64 位可移植可执行文件 （PE），包括使用以下方法压缩或混淆的 PE 文件：
  - AsPack
  - UPX
  - FSG
  - Petite
  - PeSpin
  - NsPack
  - wwpack32
  - MEW
  - Upack
  - Y0da Cryptor
- 支持 ELF 和 Mach-O 文件（32 位和 64 位）
- 支持几乎所有邮件文件格式
- 对其他特殊文件/格式的支持包括：
  - HTML
  - RTF
  - PDF
  - 使用 CryptFF 和 ScrEnc 加密的文件
  - uuencode
  - TNEF (winmail.dat)
- Advanced database updater with support for scripted updates, digital signatures and DNS based database version queries
  高级数据库更新程序，支持脚本更新、数字签名和基于 DNS 的数据库版本查询

> **免责声明 ：**
>
> 上述许多文件格式仍在不断发展。尤其是可执行文件打包和混淆工具在不断变化。我们不能保证我们可以解压缩或提取所列格式的每个版本或变体。

## 社区项目

ClamAV 拥有由[社区项目、产品和其他工具](https://docs.clamav.net/manual/Installing/Community-projects.html)组成的多元化生态系统，这些工具要么依赖 ClamAV 提供恶意软件检测功能，要么通过新功能补充 ClamAV ，例如改进对第三方签名数据库、图形用户界面 （GUI） 等的支持。

## 许可证

ClamAV 根据 GNU 通用公共许可证第 2 版获得许可。

## 支持的平台

Clam AntiVirus is highly cross-platform. The development team cannot test  every OS, so we have chosen to test ClamAV using the two most recent  Long Term Support (LTS) versions of each of the most popular desktop  operating systems. Our regularly tested operating systems include:
Clam AntiVirus 是高度跨平台的。开发团队无法测试每个操作系统，因此选择使用每个最流行的桌面作系统的两个最新长期支持 （LTS） 版本来测试 ClamAV 。定期测试的操作系统包括：

- GNU/Linux
  - Alpine
    - 3.21 (x86_64, arm64)
  - Ubuntu
    - 24.04 (x86_64, arm64)
    - 22.04 (x86_64, arm64)
  - Debian
    - 12 (x86_64, arm64)
    - 11 (x86_64, arm64)
  - AlmaLinux
    - 8.10 (x86_64, arm64)
  - Fedora
    - 41 (x86_64, arm64)
    - 40 (x86_64, arm64)
  - openSUSE
    - 15 Leap (x86_64, arm64)
- UNIX
  - FreeBSD
    - 14 (x86_64)
    - 13 (x86_64)
  - macOS
    - 15.3 Sequoia (x86_64, arm64)
    - 14.7 Sonoma (x86_64, arm64)
    - 13.7 Ventura (x86_64, arm64)
- Windows
  - 11 (x86_64, arm64)
  - 10 (i386, x86_64)

> **免责声明：**
>
> 除上述平台和作系统外，ClamAV 开发团队并未对其进行充分测试。特别是，不支持不常见的操作系统（如 HP-UX 和 Solaris）和不常见的处理器体系结构（如 sparc64、armhf、pp64le 等）。

## 建议的系统要求

以下建议的最低系统要求适用于将 ClamScan 或 ClamD 应用程序与 Cisco 提供的标准 ClamAV 签名数据库一起使用。

ClamAV 的最低推荐 RAM：

- FreeBSD 和 Linux 服务器版：3 GiB+
- Linux 非服务器版：3 GiB+
- Windows 10 & 11：3 GiB+
- MacOS：3 GiB+

> *提示* ：服务器环境（如 Docker）以及嵌入式运行时环境通常受资源限制。建议使用 3-4 GiB 的 RAM，但如果愿意接受一些限制，可能会用更少的 RAM。您可以在此处找到[更多信息 ](https://docs.clamav.net/manual/Installing/Docker.html#memory-ram-requirements)。

ClamAV 的最低推荐 CPU：

- 1 个 2.0 Ghz+ 的 CPU

所需的最小可用硬盘空间：

对于 ClamAV 应用程序，建议有 5 GiB 的可用空间。此建议是对每个操作系统的建议磁盘空间的补充。

> *注* ： 确定这些最低要求的测试是在未运行其他应用程序的系统上执行的。如果系统上运行其他应用程序，则除了我们建议的最低要求外，还需要额外的资源。

## 提交新的或未检测到的恶意软件

If you've got a virus which is not detected by the current version of  ClamAV using the latest signature databases, please submit the sample  for review at our website:
如果您的病毒使用最新的签名数据库无法被当前版本的 ClamAV 检测到，请在我们的网站上提交样本以供审核：

https://www.clamav.net/reports/malware

Likewise, if you have a benign file that is flagging as a virus and you wish to  report a False Positive, please submit the sample for review at our  website:
同样，如果您有一个标记为病毒的良性文件，并且您希望报告误报，请在我们的网站上提交样本以供审核：

https://www.clamav.net/reports/fp

如果您对提交流程有任何疑问，请阅读[恶意软件和误报报告常见问题解答](https://docs.clamav.net/faq/faq-malware-fp-reports.html)

提交新的恶意软件或提交误报报告后，需要多长时间才能更改签名？

> 在大多数情况下，从首次提交开始，至少需要 48 小时才能在官方 ClamAV 签名数据库中发布任何更改。

谁会分析恶意软件和误报文件上传？

> 考虑到提交的数量，绝大多数文件都是由自动化处理的。

谁有权访问上传的文件？

> All engineers and analysts within Cisco's Talos organization have access to the files.
> Cisco Talos 组织内的所有工程师和分析师都可以访问这些文件。

Are malware or false positive file uploads shared with other companies?
恶意软件或误报文件上传是否与其他公司共享？

> No. Files that are submitted for review through the ClamAV Malware and  False Positive web forms (or the clamsubmit tool), are not shared  outside of Cisco. However, sample sharing is fair game if we've already  received the same file from a different source (VirusTotal, Cisco SMA,  various feeds, etc.).
> 不。通过 ClamAV 恶意软件和误报 Web 表单（或 clamsubmit 工具）提交以供审核的文件不会在 Cisco  外部共享。但是，如果我们已经从不同的来源（VirusTotal、Cisco SMA、各种源等）收到了相同的文件，那么样本共享是公平的。

分析后文件是否已删除？

> 不。上传的文件将无限期保留。

在此过程中的任何时候都可以使用公共 URL 访问文件吗？

> 不。无法使用公共 URL 访问上传的文件。它们在内部处理，并保留在 Cisco Talos 内部。

## 相关产品

[Cisco Secure Endpoint](https://www.cisco.com/c/en/us/products/security/amp-for-endpoints/index.html)（以前称为 AMP for Endpoints）是 Cisco 面向商业和企业客户的基于云的安全套件。安全终端适用于 Windows、Linux 和  macOS，并提供卓越的恶意软件检测功能、行为监控、动态文件分析、终端隔离、分析和威胁搜寻。安全终端采用现代管理 Web 界面（控制面板）。