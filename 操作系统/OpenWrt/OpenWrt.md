# OpenWrt

[TOC]

## 概述

OpenWrt 项目是一个针对嵌入式设备的 Linux 操作系统。OpenWrt  不是一个单一且不可更改的固件，而是提供了具有软件包管理功能的完全可写的文件系统。这使您可以从供应商提供的应用范围和配置中解脱出来，并且让您通过使用适配任何应用的软件包来定制设备。对于开发人员来说，OpenWrt 是一个无需围绕它构建完整固件就能开发应用程序的框架; 对于普通用户来说，这意味着拥有了完全定制的能力，能以意想不到的方式使用该设备。

OpenWrt 是一个为嵌入式设备（通常是无线路由器）开发的高扩展度的 GNU/Linux 发行版。与许多其他路由器的发行版不同，OpenWrt 是一个完全为嵌入式设备构建的功能全面、易于修改、由现代 Linux  内核驱动的操作系统。在实践中，这意味着您可以得到需要的所有功能，却仍能避免臃肿。

## OpenWrt One 路由器

 ![](https://openwrt.org/_media/inbox/toh/openwrt/openwrt_one_top_400.png?w=400&tok=bd5b35)

2024 年 11 月 29 日正式发售 [OpenWrt One](https://one.openwrt.org) ，这是第一款自己可以 DIY 硬件和软件为设计理念的路由器。Openwrt One 搭载了联发科 MT7981B SoC 芯片组，并提供双频 WiFi-6（3×3/2×2）、PoE [以太网供电]、双以太网端口以及 mikroBUS 扩展头等特性。[带外壳 89 美元](https://www.aliexpress.com/item/1005007795779282.html)

无论你从哪里购买，每购买一台新的 [OpenWrt One](https://one.openwrt.org)，都会有一笔 **10 美元的捐款**汇入 Software Freedom Conservancy（软件自由保护组织）为 OpenWrt  设立的专用基金。你的购买不仅得到一个可以完整 DIY 的路由器，还帮助 OpenWrt 和 Software Freedom  Conservancy（软件自由保护组织）继续改进我们都依赖的重要软件和软件自由。

## 版本

### 当前稳定版: OpenWrt 24.10

**当前稳定版本 - OpenWrt 24.10.0**

OpenWrt 的当前稳定版本系列是 24.10，其中“v24.10.0”是该系列的最新版本。它于 2025 年 2 月 6 日发布。

### 旧的稳定版：OpenWrt 23.05

当前 OpenWrt 稳定版本的版本号为 23.05，其中 **v23.05.5** 是这个系列的最新稳定版。此版本发布于 2024 年 09 月 25 日。

## 为何使用 OpenWrt ?

OpenWrt 相比制造商的原厂固件更加出色，才使得人们更倾向于使用 OpenWrt 。人们发现 OpenWrt 不仅更加稳定、提供更多的功能，并且更加安全和更好的技术支持。

-  **可扩展性：** OpenWrt 提供了许多以往只在高端设备上才提供的各种功能。它拥有超过 3000 个标准化应用软件包，让您可以轻松地将他们应用于各种支持的设备，包括两年甚至五年前的路由器。
-  **高安全性：** 禁用 Wi-Fi、不能使用弱密码、没有任何后门程序的默认配置确保了 OpenWrt 标准安装程序的牢固。OpenWrt 的系统组件始终保持最新，因此[漏洞一旦被发现后会很快得到解决](https://openwrt.org/advisory/start)。
-  **高性能、高稳定性** OpenWrt 固件是由所支持设备的标准化组件制作而成。这意味着相比原厂为特定产品线优化后就不闻不问的不可更改固件，OpenWrt 的每个组件都会接受更多的测试和错误修复。
-  **给力的社区支持：** OpenWrt 团队成员会经常参与到 [OpenWrt 论坛](https://forum.openwrt.org)、[OpenWrt 开发者](https://lists.openwrt.org/mailman/listinfo/openwrt-devel)、[OpenWrt 管理员](https://lists.openwrt.org/mailman/listinfo/openwrt-adm)以及 [OpenWrt's 的 IRC 频道](https://openwrt.org/zh/contact#irc_channels)中。您可以直接与开发人员、管理软件模块的志愿者和其他资深 OpenWrt 用户互动，大大增加您解决问题的机会。
-  **研发：** 许多团队使用 OpenWrt 作为他们对网络性能研究的平台。这意味着他们的成功实验案例将会首先在 OpenWrt 上实现，而原厂固件将会滞后许多。
-  **开源/无额外支出：** 使用 OpenWrt 没有任何金钱成本。它完全是由开发者、维护人员、个人、公司组成的一个志愿者团队创建的。如果您喜欢 OpenWrt，可以[让它变得更好](https://openwrt.org/zh/start#openwrt期待您的参与)。因为 OpenWrt 作为开源社区的一部分，由 Linux 内核驱动，以下都将成为可能，比如 [获取源代码...](https://git.openwrt.org)。 

## 支持的设备

### OpenWrt 所支持设备的一般要求

1. 受 OpenWrt 支持的 SoC 或 [架构](https://openwrt.org/zh/docs/techref/targets/start)
2. 有足够的闪存来储存 OpenWrt 固件镜像
   * 最少 4MB ，无法安装 GUI（LuCI）
   * 推荐 8MB 及以上，能安装 GUI 和其他应用程序
3. 有足够的内存（RAM）来保证稳定运行
   * 最少 32MB，推荐 64MB 或以上

> **注意：**
>
> 如果打算刷入最新且安全的 OpenWrt 版本，**请勿购买具有 4MB 闪存 / 32MB RAM 的设备！** 参阅**[4/32警告](https://openwrt.org/zh/supported_devices/432_warning)**以便获取更多信息。
>
> 1)  4/32 设备没有足够的资源（闪存和/或 RAM）来提供安全可靠的操作。see **[OpenWrt on 4/32 devices](https://openwrt.org/supported_devices/openwrt_on_432_devices)** what you can do now.
> 2)  OpenWrt 对 4/32 设备的支持已于 2022 年终止。[19.07.10](https://openwrt.org/zh/releases/19.07/start) 是针对 4/32 设备的最后一个官方版本。

### 答疑解惑

搜索完整的[硬件表格 (ToH)](https://openwrt.org/toh/start)来查看您的设备是否得到 OpenWrt 的支持。

以下可以帮助您选择要购买的设备：

-  [我想购买支持 OpenWrt 的路由器](https://openwrt.org/zh/toh/views/toh_available_16128)
-  [从哪里可以下载适合我的路由器的 OpenWrt 固件？](https://openwrt.org/zh/toh/views/toh_fwdownload)
-  [受支持的 WiFi 6 的路由器列表](https://openwrt.org/zh/toh/views/toh_available_16128_ax-wifi)
-  [受支持的交换机列表](https://openwrt.org/zh/toh/views/switches)
-  [更多](https://openwrt.org/zh/toh/views/start)，例如[电池供电](https://openwrt.org/zh/toh/views/toh_battery-powered)、[USB 供电](https://openwrt.org/zh/toh/views/toh_usb-powered) 或 [PoE 供电](https://openwrt.org/zh/toh/views/toh_poe-powered)，具有 [SFP 端口](https://openwrt.org/zh/toh/views/toh_sfp_ports) 或 [LTE 调制解调器](https://openwrt.org/zh/toh/views/toh_lte_modem_supported)。
-  [购买指南](https://openwrt.org/toh/buyerguide)

### 获取硬件数据 CSV 文件

以 CSV 文件存储的硬件数据库, 将每天更新，可以从以下链接获得:

-  [包含硬件数据库 CSV 的 zip 文件](https://openwrt.org/_media/toh_dump_tab_separated.zip)
-  [包含硬件数据库 CSV 的 gzip 文件](https://openwrt.org/_media/toh_dump_tab_separated.gz)

可以使用 LibreOffice 表格、微软 Excel 或其他程序来查看数据。

## 软件包

OpenWrt 发行版提供了数千个软件包来扩展您设备的功能. 

### 软件包数据库

-  按类型分组的所有可用软件包的概述: [软件包索引](https://openwrt.org/packages/index/start)
-  全面且可搜索的软件包列表: [软件包列表](https://openwrt.org/packages/table/start) 
-  软件包数据库的 CSV 转储，每日更新: [软件包数据库](https://openwrt.org/_media/packages_dump_tab_separated.zip)

### 软件包管理备忘单

将 OpenWrt 固件刷入设备后，您可以通过 [WebUI](https://openwrt.org/zh/docs/guide-quick-start/walkthrough_login) 或 [CLI](https://openwrt.org/zh/docs/guide-quick-start/sshadministration) 安装其他插件包。

如果不确定如何在您的环境中访问或配置您的路由器，请参阅: [guide-quick-start](https://openwrt.org/zh/docs/guide-quick-start/start)

#### 网页界面（LuCI）

通过网页界面管理软件包：

1.  依次点击 **LuCI → 系统 → 软件包**；
2.  点击 **更新列表** 按钮获得可用软件包列表；
3.  填写 **过滤器** 字段内容后点击 **查找** 按钮搜索特定的软件包；
4.  切换至 **可用** 可展示并安装可用的软件包；
5.  切换至 **已安装** 可展示并卸载已安装的软件包。

如果您想使用 LuCI 来配置服务，请搜索并安装 `luci-app-*` 相关软件包。

#### 命令行界面（CLI）

在命令行中，使用 [opkg](https://openwrt.org/zh/docs/guide-user/additional-software/opkg) 命令管理软件包。

| 命名                           | 说明                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| `opkg update`                  | 从 OpenWrt 软件包存储库获取可用软件包列表。                  |
| `opkg list`                    | 显示可用软件包及其描述信息。                                 |
| `opkg list | grep -e <search>` | 显示以 `<search>` 为关键字在软件包名称或描述信息中过滤的结果 |
| `opkg install <packages>`      | 安装一个软件包                                               |
| `opkg remove <packages>`       | 卸载一个已安装的软件包                                       |

### 旧版软件包

不再与当前稳定版或快照版 OpenWrt 相关的信息。 本节中的软件包索引不再更新，因为旧版本中的软件包不会更改。

要下载旧软件包，请参阅[包存储库](https://downloads.openwrt.org/) `packages/` 上的版本存档中给定版本和目标的目录。 

| Release | Package index                                                | Package table                                                | Package DB                                                   |
| ------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 21.02   | [Package index](https://openwrt.org/packages/index_owrt21_2/start) | [Package table](https://openwrt.org/packages/table_owrt21_2/start) | [Package DB](https://openwrt.org/_media/packages/packages_dump_tab_separated_21.02.zip) |
| 19.07   | [Package index](https://openwrt.org/packages/index_owrt19_7/start) | [Package table](https://openwrt.org/packages/table_owrt19_7/start) | [Package DB](https://openwrt.org/_media/packages/packages_dump_tab_separated_19.07.zip) |
| 18.06   | [Package index](https://openwrt.org/packages/index_owrt18_6/start) | [Package table](https://openwrt.org/packages/table_owrt18_6/start) | [Package DB](https://openwrt.org/_media/packages/packages_dump_tab_separated_csv.18.06.zip) |

-  **Package index** - 按类型分组的所有可用软件包的概述。
-  **Package table** - 全面且可搜索的软件包列表。
-  **Package DB** - 软件包数据库的 CSV 转储，您可以将其导入 LibreOffice Calc, MS Excel 或其他程序以可视化数据。

### 第三方软件包

第三方软件包未经 OpenWrt 开发人员测试且不受支持，OpenWrt 对其安全性或可用性不作任何保证。

仅安装来自您信任的来源的软件包。 请从这些包的维护者而不是 OpenWrt 开发者那里获得对第三方软件包的支持。

此类软件包的常见来源包括 [ipkg.be](http://www.ipkg.be/) 和 [NSLU2 optware](http://ipkg.nslu2-linux.org/feeds/optware/ddwrt/cross/stable)。

## 下载

### 浏览 OpenWrt 固件存储库

这些链接会将您带到当前硬件的下载目录，按设备的处理器类型分组。

OpenWrt 固件有两个分支：一个**稳定版**适合应用于生产。另一个**开发版**则包括不断更新的增强功能。

| [稳定版](https://downloads.openwrt.org/releases/)            | [开发版](https://downloads.openwrt.org/snapshots/targets/)   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **稳定版**都经过严格的测试。适合应用于生产，或为您和家人提供正常工作的路由。 | **开发版**包含最新技术，但它可能不够稳定甚至无法工作，做好报告漏洞的准备。 |

### 下载您设备专用的 OpenWrt 固件

请前往 **[硬件列表](https://openwrt.org/zh/toh/views/toh_fwdownload)** ，找到您的设备专用的官方发行版本。您还可以使用[固件选择器](https://firmware-selector.openwrt.org/) 以更便捷的找到想要的固件。

-  请参阅[文件签名](https://openwrt.org/docs/guide-user/security/release_signatures)以了解如何验证下载固件的完整性。
-  请参阅[快速入门](https://openwrt.org/zh/docs/guide-quick-start/start)或[使用手册](https://openwrt.org/zh/docs/guide-user/start), 以便在您的设备上安装固件。
-  诸如 [GL.iNet, Turris](https://openwrt.org/zh/docs/guide-user/installation/openwrt-as-stock-firmware) 及其他路由已经刷入基于 OpenWrt 的固件，因此，您无需手动安装。

### 获取附加软件包

在您将 OpenWrt 固件安装到您的设备上之后, 您可以安装附加的应用程序到 OpenWrt 设备上。

-  已预装的软件包可在此处找到: https://downloads.openwrt.org/releases/
-  [确认您的设备属于哪种硬件架构](https://openwrt.org/zh/toh/views/toh_packagedownload)

### 构建您的固件

OpenWrt 拥有完备的构建系统，您可以在创建版本前往已下载的源代码中加入更高级的优化或修改，然后就能编译您自己的固件了。 OpenWrt 的构建系统能够通过 checksum 和 git 版本可重复性的生成完全一致的固件，除非您改变编译配置或更新 OpenWrt 源码。 如果您想创建您的固件，可以从 [这里](https://openwrt.org/docs/guide-developer/toolchain/start) 开始。

### 组装您的固件

OpenWrt 提供方便的工具以便将预构建的软件包集成到定制固件中，以便让定制和时间（或资源）要求达到完美平衡。 以这种方式集成的软件包将从更新相同的存储库中下载，所以在性能不佳的 PC 该过程也只需要数分钟。 如果您想创建您的固件，可以从[这里](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)开始。

### 创建您的软件包

如果您仅想编译您的程序并创建一个定制软件包，而不是从完整源码编译一个功能完整的固件, 您可以使用 OpenWrt 提供的 SDK 包。 如果您想创建您的您的软件包，可以从[这里](https://openwrt.org/docs/guide-developer/toolchain/using_the_sdk)开始。

### Buildbot 活动

OpenWrt 拥有一些 buildbot 计算机用以构建固件版本。如果您对最新的开发快照版更改了什么感兴趣，您可以在以下链接中找到 Buildbot 活动:

-  Phase 1: [target/subtargets](http://phase1.builds.lede-project.org/builders)
-  Phase 2: [软件包](http://phase2.builds.lede-project.org/builders)

### 源代码 - Git 存储库

[主 OpenWrt 源代码存储库](https://git.openwrt.org/)托管在 OpenWrt 项目 Git 服务器上。

### 源代码 - GitHub 镜像

GitHub 上有一份 OpenWrt [主存储库的镜像](https://github.com/openwrt)。

### 镜像

下载服务器的内容也可以在以下几个镜像服务器上使用，请根据地理位置选择。

| **国家**                | **HTTP**                                               | **HTTPS**                                                | **FTP**                                            | **RSYNC**                                | **赞助者**                                                   | **备注**                                |
| ----------------------- | ------------------------------------------------------ | -------------------------------------------------------- | -------------------------------------------------- | ---------------------------------------- | ------------------------------------------------------------ | --------------------------------------- |
| **奥地利**              | [HTTP](http://mirror.kumi.systems/openwrt/)            | [HTTPS](https://mirror.kumi.systems/openwrt/)            | -                                                  | rsync://mirror.kumi.systems/openwrt/     | [Kumi Systems e.U.](https://kumi.systems/)                   |                                         |
| **比利时**              | [HTTP](http://mirror.tiguinet.net/openwrt/)            | [HTTPS](https://mirror.tiguinet.net/openwrt/)            | -                                                  | -                                        | [Arnold Dechamps](https://adechamps.net/)                    | Synced every 12 hours                   |
| **巴西**                | [HTTP](http://openwrt.c3sl.ufpr.br/)                   | [HTTPS](https://openwrt.c3sl.ufpr.br/)                   | -                                                  | rsync://openwrt.c3sl.ufpr.br/openwrt/    | [Universidade Federal do Paraná](http://www.ufpr.br/portalufpr/) | Only releases                           |
| **中国**                | [HTTP](http://mirror.sjtu.edu.cn/openwrt/)             | [HTTPS](https://mirror.sjtu.edu.cn/openwrt/)             | -                                                  | -                                        | [Shanghai Jiao Tong University Linux User Group](https://sjtug.org) | Only releases                           |
| **中国**                | [HTTP](http://mirrors.ustc.edu.cn/openwrt/)            | [HTTPS](https://mirrors.ustc.edu.cn/openwrt/)            | -                                                  | -                                        | [中国科学技术大学](https://mirrors.ustc.edu.cn/)             |                                         |
| **中国**                | [HTTP](http://mirrors.aliyun.com/openwrt/)             | [HTTPS](https://mirrors.aliyun.com/openwrt/)             | -                                                  | -                                        | [阿里巴巴云计算（北京）有限公司](https://developer.aliyun.com/mirror/) | Only releases                           |
| **中国**                | [HTTP](http://mirrors.cloud.tencent.com/openwrt/)      | [HTTPS](https://mirrors.cloud.tencent.com/openwrt/)      | -                                                  | -                                        | [腾讯](https://mirrors.cloud.tencent.com/)                   |                                         |
| **中国**                | [HTTP](http://mirrors.cernet.edu.cn/openwrt)           | [HTTPS](https://mirrors.cernet.edu.cn/openwrt)           | -                                                  | -                                        | [MirrorZ](https://help.mirrors.cernet.edu.cn/openwrt/)       | 10+ mirrors                             |
| **法国**                | [HTTP](http://openwrt.tetaneutral.net/)                | [HTTPS](https://openwrt.tetaneutral.net/)                | -                                                  | rsync://openwrt.tetaneutral.net/openwrt/ | [tetaneutral.net](http://tetaneutral.net/)                   |                                         |
| **意大利**              | [HTTP](http://openwrt.mirror.garr.it/mirrors/openwrt/) | [HTTPS](https://openwrt.mirror.garr.it/mirrors/openwrt/) | -                                                  |                                          | [GARR Mirror](https://mirror.garr.it/)                       |                                         |
| **日本**                | [HTTP](http://repo.jing.rocks/openwrt/)                | [HTTPS](https://repo.jing.rocks/openwrt/)                | -                                                  | rsync://repo.jing.rocks/openwrt/         | [Jing Luo](https://jing.rocks)                               | Synced every 23 hours                   |
| **哈萨克斯坦**          | [HTTP](http://mirror.hoster.kz/openwrt)                | [HTTPS](https://mirror.hoster.kz/openwrt)                | -                                                  | rsync://mirror.hoster.kz/openwrt/        | [hoster.kz](https://hoster.kz/)                              |                                         |
| **哈萨克斯坦/阿拉木图** | [HTTP](http://mirror.ps.kz/openwrt)                    | [HTTPS](https://mirror.ps.kz/openwrt)                    | [FTP](ftp://mirror.ps.kz/openwrt)                  | -                                        | [PS Internet Company](https://www.ps.kz/)                    |                                         |
| **摩洛哥**              | [HTTP](http://mirror.marwan.ma/openwrt)                | [HTTPS](https://mirror.marwan.ma/openwrt)                | -                                                  | rsync://mirror.marwan.ma/openwrt/        | [Moroccan National Research and Education Network](https://marwan.ma) |                                         |
| **荷兰**                | [HTTP](http://ftp.snt.utwente.nl/pub/software/lede/)   | [HTTPS](https://ftp.snt.utwente.nl/pub/software/lede/)   | [FTP](ftp://ftp.snt.utwente.nl/pub/software/lede/) | rsync://ftp.snt.utwente.nl/lede/         | [SNT, University of Twente](http://www.snt.utwente.nl/)      |                                         |
| **罗马尼亚**            | [HTTP](http://mirrors.linux.ro/lede/downloads/)        | -                                                        | [FTP](ftp://mirrors.linux.ro/lede/downloads/)      | rsync://mirrors.linux.ro/lede/downloads/ | [RCS&RDS](http://www.rcs-rds.ro)                             |                                         |
| **新加坡**              | [HTTP](http://mirror.0x.sg/openwrt/)                   | [HTTPS](https://mirror.0x.sg/openwrt/)                   | [FTP](ftp://mirror.0x.sg/openwrt/)                 | rsync://mirror.0x.sg/lede/               | Andrew Yong                                                  |                                         |
| **美国**                | [HTTP](http://openwrt.mcn.us.ssimn.org/)               | [HTTPS](https://openwrt.mcn.us.ssimn.org/)               | -                                                  | -                                        | [Starburst Services](https://starburstservices.com/)         | ~~Only releases~~ Temporarily suspended |
| **CDN (Cloudflare)**    | [HTTP](http://mirrors.cicku.me/openwrt/)               | [HTTPS](https://mirrors.cicku.me/openwrt/)               | -                                                  | -                                        | cicku.me                                                     |                                         |

#### 如何创建镜像站点

请仅在确实需要的情况下设置镜像：例如，如果您与现有镜像的连接不佳，或者如果您有许多下游用户。在任何情况下，OpenWrt 官方下载服务都不会自动使用您的镜像。

请使用 ~~`rsync://downloads.openwrt.org/downloads`~~ `rsync://rsync.openwrt.org/downloads` 以获取下载库的副本。

>  通过将 DNS 更改为 CDN，我们必须从 2023/12/18 起更改 `rsync` 使用的域名！

截止2022年11月，下载库数据量为 1.6 TB，并且每年增加 300-400 GB。快照占用 150-250 GB，18.06 版本占用  249 GB，19.07 占用 342 GB，21.02 占用 454 GB，22.03 占用 462  GB。您可以排除部分存储库以节省空间（例如忽略快照或忽略旧版本）。

由于当前的带宽限制，我们希望在最初提取数据时使用类似`rsync --bwlimit 8000`的内容。每12到24小时同步一次下载共享是最理想的。

一旦镜像建立，随时可以在 `openwrt-adm@lists.openwrt.org` 上公布，以便及时更新到当前页面。这样可以为用户方便找到可用镜像站点，因为没有利用镜像的自动负载均衡系统。 当用户发现与某个镜像的连接性更好时，可以手动选择使用该镜像。

#### 下载统计

通过访问[统计](https://downloads.openwrt.org/stats/)，您能了解最近月份的下载情况。在打开页面的“OpenWrt firmware image downloads”章节中，您可以知晓最流行的路由型号。