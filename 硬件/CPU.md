# CPU

[TOC]

## 指令集架构 (ISA) 

是指支持相同指令集的 CPU 系列。

### CISC（Complex Instruction Set Computer）

复杂指令集。早期的CPU都是CISC架构。设计目的是要用最少的机器语言指令来完成所需的计算任务。这种架构会增加CPU结构的复杂性和对CPU工艺的要求，但对于编译器的开发十分有利。

| 架构名称        | 推出公司   | 推出时间 | 主要授权商 | 描述                                                         |
| --------------- | ---------- | -------- | ---------- | ------------------------------------------------------------ |
| IA64            |            |          |            | 是英特尔设计的64位架构，用在英特尔安腾系列处理器上。这个架构不兼容 **x86** 和 **x86_64** ，它主要用于中、高端服务器系列。包括：英特尔安腾。 |
| x86             | Intel，AMD | 1978     | 海光，兆芯 | 是用于“Intel 兼容” CPU 的 32 位架构。直到现在它还是台式 PC 最流行的架构。Gentoo 提供了用于  i486（支持所有系列 CPU）和 i686（支持兼容 Pentium 及以上系列的CPU）的安装包。包括： i486, i686, AMD  速龙，英特尔酷睿和一些英特尔凌动。 |
| x86_64  (AMD64) |            |          |            | 是一个兼容 **x86** 架构的 64 位架构。最早是 AMD (AMD64) 和 Intel (EM64T) 使用，现在已经成为中、高端台式 PC 的主流架构，一些服务器也使用这一架构。包括：AMD 速龙 64，皓龙，闪龙，羿龙，FX，锐龙，线程撕裂者以及霄龙，还有英特尔奔腾 4，酷睿 2，酷睿 i3、i5、i7、i9，至强和一些凌动。 |



### RISC（Reduced Instruction Set Computer）

精简指令集。要求软件来指定各个操作步骤。这种架构可以降低CPU结构的复杂性以及云霄在相同的工艺水平下生产出功能更强大的CPU，但对于编译器的设计有更高的要求。


| 架构名称          | 推出公司 | 推出时间 | 主要授权商                             | 描述                                                         |
| ----------------- | -------- | -------- | -------------------------------------- | ------------------------------------------------------------ |
| Alpha             |          |          |                                        | 是由 DEC 开发的一种 64 位架构。虽然一些中档和高端服务器依然使用这一架构，但它正在慢慢淡出历史舞台。包括：ES40, AlphaPC, UP1000 和 Noname 。 |
| ARM               | ARM      | 1985     | Apple，三星，Nvidia，高通，海思，TI 等 | 这种32位架构在嵌入式和小型系统上非常流行。子架构涵盖 ARMv2 到  ARMv6（旧版），到ARMv6-M（Cortex）以及ARMv8-R和ARMv8-M，此架构经常在被用于智能手机、平板、手持设备和终端用户  GPS 导航系统等。包括: StrongARM 和 Cortex-M。 |
| ARM64             |          |          |                                        | 这种64位架构是一种新的 ARM 变种，用于嵌入式和服务器系统。主要的子架构 AArch64 （也称之为 ARMv8-A  ）是由多家制造商生产的。Arch64芯片出现在各种各样的 SoC 中，包括开发板、智能手机、平板电脑、智能电视等。包括：安谋控股的  Cortex-A53, A57, A72, A73 和高通的 Kryo 和 Falkor。 |
| HPPA  （PA-RISC） |          |          |                                        | 是惠普开发的一套指令集，用于他们自己的中、高端服务器系列，直到2008年（在那以后 HP 开始使用英特尔安腾）。包括：HP 9000 和 PA-8600。 |
| MIPS              | MIPS     | 1981     | 龙芯、炬力等                           | 由美普思科技开发, 包括多个 subfamilie (称为步进等级（revisions）) 例如 MIPS I，MIPS  III，MIPS32，MIPS64 等等。MIPS 最常见于嵌入式系统。包括：MIPS32 1074K 和 R16000。 |
| PowerPC  (ppc)    | IBM      | 1991     | IBM                                    | 一种用在许多 Apple、IBM 和 Motorola 处理器上的32位架构，基本主要用于嵌入式系统。包括：苹果  OldWorld，苹果 NewWorld, generi Pegasos, Efika, 较早的IBM iSeries 和 pSeries。 |
| PPC64             |          |          |                                        | 是 PCC 架构的64位变种，同时流行于嵌入式系统和高性能服务器。包括：IBM RS/6000s, IBM pSeries, 和 IBM iSeries. |
| RISC-V            |          |          |                                        | 是即将到来的32位、64位和128位架构，具有一套开源指令集。      |
| SPARC             | SUN      |          |                                        | 以它的生产商而著称，它最常见的生产商是太阳计算机系统（现在叫甲骨文公司）和富士通。它主要用于服务器，但也在与少量的工作站中使用。Gentoo 只支持兼容 SPARC64 的CPU。包括：E3000, Blade 1000 和 Ultra 2。 |

### 对比

#### CISC  RISC

| 对比项      | CISC                   | RISC                     |
| ----------- | ---------------------- | ------------------------ |
| 指令系统    | 复杂                   | 精简                     |
| 存储器操作  | 控制指令多             | 控制简单                 |
| 程序        | 编程效率高             | 需要大内存空间，不易设计 |
| CPU芯片电路 | 功能强、面积大、功耗大 | 面积小，功耗低           |
| 应用范围    | 通用机                 | 专用机                   |

#### X86   ARM   Power

|            | X86                      | ARM                        | Power                       |
| ---------- | ------------------------ | -------------------------- | --------------------------- |
| 指令集     | CISC                     | RISC                       | RISC                        |
| 架构       | 重核架构，高性能高功耗   | 多核架构，均衡的性能功耗比 | 重核架构，高性能内核        |
| 工艺及技术 | 14nm，摩尔定律放缓       | 7nm，业界最领先的制程工艺  | 14nm                        |
| 生态       | 生态非常成熟，通用性强   | 生态正在快速发展与完备     | 生态局限，聚集大小型机和HPC |
| 开放性     | 封闭架构，Intel及AMD主导 | 开放平台，IP授权的商业模式 | 封闭架构，IBM主导           |

## 主流CPU发展路径

![](../Image/c/cpu_map.png)

## ARM

Advanced RISC Machines

**arm **和 **arm64**

### 授权

1. 架构/指令集授权

   按照所授权的架构和指令集自行编写代码、设计芯片。

2. 处理器授权

   * 提供RTL代码，处理器的核数、缓存可配置。
   * 自主后端设计（主频、工艺、代工厂等）。

3. 处理器优化包/物理IP包授权（POP）

   只能按照ARM设计好的处理器类型、在指定的代工厂和工艺进行生产。