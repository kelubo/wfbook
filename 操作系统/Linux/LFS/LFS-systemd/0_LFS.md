# Linux From Scratch 11.2-systemd

[TOC]

## 概述

LFS 系统必须在一个已经安装好的 Linux 发行版 (如 Debian、OpenMandriva、Fedora 或者        openSUSE) 中构建。这个安装好的 Linux 系统 (称为宿主) 提供包括编译器、链接器和 shell        在内的必要程序，作为构建新系统的起点。请在安装发行版的过程中选择“development” (开发) 选项，以使用这些工具。

也可以选择不安装一个单独的发行版，而是使用某个商业发行版的 LiveCD。

## 目标架构

LFS 的主要目标架构是 AMD/Intel 的 x86 (32 位) 和 x86_64 (64 位) CPU。

## LFS 和标准

LFS 的结构尽可能遵循 Linux 的各项标准。主要的标准有：

* [POSIX.1-2008](http://pubs.opengroup.org/onlinepubs/9699919799/)
* [Filesystem Hierarchy Standard (FHS) Version 3.0](http://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
* [Linux Standard Base (LSB) Version 5.0 (2015)](http://refspecs.linuxfoundation.org/lsb.shtml)            

- LSB 由 4 个独立的标准组成：Core、Desktop、Runtime Language 和 Imaging。除了通用要求外，还有架构特定的要求。另外，还有两个处于试用阶段的标准：Gtk3 和 Graphics。LFS              试图遵循 LSB 对前一节讨论的那些架构的要求。

### LSB 要求的，由 LFS 提供的软件包

| 标准                            | 软件包                                                       |
| ------------------------------- | ------------------------------------------------------------ |
| LSB Core                        | Bash, Bc, Binutils, Coreutils, Diffutils, File, Findutils, Gawk, Grep, Gzip, M4, Man-DB, Ncurses, Procps, Psmisc, Sed, Shadow, Tar, Util-linux, Zlib |
| LSB Desktop                     | 无                                                           |
| LSB Runtime Languages           | Perl, Python                                                 |
| LSB Imaging                     | 无                                                           |
| LSB Gtk3 和 LSB Graphics (试用) | 无                                                           |

### LSB 要求的，由 BLFS 提供的软件包

| 标准                                   | 软件包                                                       |
| -------------------------------------- | ------------------------------------------------------------ |
| LSB Core                               | At, Batch (At 的一部分), Cpio, Ed, Fcrontab, LSB-Tools, NSPR,  NSS, PAM, Pax, Sendmail (或 Postfix，或 Exim), time |
| LSB Desktop                            | Alsa, ATK, Cairo, Desktop-file-utils, Freetype, Fontconfig, Gdk-pixbuf, Glib2, GTK+2, Icon-naming-utils, Libjpeg-turbo, Libpng, Libtiff, Libxml2, MesaLib, Pango, Xdg-utils, Xorg |
| LSB Runtime                  Languages | Libxml2, Libxslt                                             |
| LSB Imaging                            | CUPS, Cups-filters, Ghostscript, SANE                        |
| LSB Gtk3 和 LSB Graphics (试用)        | GTK+3                                                        |

### LSB 要求的，LFS 和 BLFS 均不提供的软件包

| 标准                            | 软件包             |
| ------------------------------- | ------------------ |
| LSB Core                        | 无                 |
| LSB Desktop                     | Qt4 (但提供了 Qt5) |
| LSB Runtime Languages           | 无                 |
| LSB Imaging                     | 无                 |
| LSB Gtk3 和 LSB Graphics (试用) | 无                 |

## 选择软件包的逻辑

LFS 的目标是构建一个完整且基本可用的系统。这包含所有重复构建 LFS 系统所需的软件包，以及在 LFS 提供的相对小的基础上根据用户需求，继续定制更完备的系统所必须的软件包。因此，LFS 并不是最小可用系统。LFS 中一些重要的软件包甚至不是必须安装的。

| 软件包    | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| Acl       | 包含管理访问控制列表 (ACL) 的工具，用来对文件和目录提供更细粒度的访问权限控制。 |
| Attr      | 包含管理文件系统对象的扩展属性的程序。                       |
| Autoconf  | 包含能根据软件开发者提供的模板，自动生成配置源代码的 shell 脚本的程序。如果修改了软件包的构建过程，一般需要该软件包的支持才能重新构建被修改的软件包。 |
| Automake  | 包含能根据软件开发者提供的模板，自动生成 Makefile              的程序。如果修改了软件包的构建过程，一般需要该软件包的支持才能重新构建被修改的软件包。 |
| Bash      | 为系统提供一个 LSB core 要求的 Bourne Shell 接口。与其他 shell              软件包相比，它更加常用，且在基本 shell 功能的基础上有更好的扩展能力，因此在各种 shell 软件包中选择了它。 |
| Bc        | 提供了一个任意精度数值处理语言。在编译 Linux 内核时需要该软件包。 |
| Binutils  | 包含链接器、汇编器，以及其他处理目标文件的工具。编译 LFS 系统以及运行在 LFS              之上的大多数软件包都需要该软件包中的程序。 |
| Bison     | 提供了 yacc (Yet Another Compiler Compiler) 的 GNU 版本。一些 LFS              程序的编译过程需要该软件包。 |
| Bzip2     | 包含用于压缩和解压缩文件的程序。许多 LFS 软件包的解压需要该软件包。 |
| Check     | 包含通用的文本宏处理器。它被其他程序用于构建工具。           |
| Coreutils | 包含一些用于查看和操作文件和目录的基本程序。这些程序被用于在命令行下管理文件，以及每个 LFS 软件包的安装过程。 |
| D-Bus     | 包含一些用于提供消息总线系统的程序，是一种应用程序之间通信的简单方式。 |
| DejaGNU   | 包含用于测试其他程序的框架。                                 |
| Diffutils | 包含用于显示文件或目录之间的差异的程序。这些程序可以被用于创建补丁，很多软件包的编译过程也需要该软件包。 |
| E2fsprogs | 包含用于处理 ext2, ext3 和 ext4 文件系统的工具。它们是 Linux              支持的最常用且久经考验的文件系统。 |
| Expat     | 包含一个相对轻量级的 XML 解析库。Perl 模块 XML::Parser 需要该软件包。 |
| Expect    | 包含一个自动和其他交互程序交互的脚本执行程序。一般用它测试其他程序。 |
| File      | 包含用于判定给定文件类型的工具。一些软件包的构建脚本需要它。 |
| Findutils | 包含用于在文件系统中寻找文件的程序。它被许多软件包的编译脚本使用。 |
| Flex      | 包含用于生成词法分析器的程序。它是 lex (lexical analyzer) 程序的 GNU 版本。许多 LFS              软件包的编译过程需要该软件包。 |
| Gawk      | 包含用于操作文本文件的程序。它是 awk (Aho-Weinberg-Kernighan) 的 GNU              版本。它被许多其他软件包的编译脚本使用。 |
| GCC       | 是 GNU 编译器的集合。它包含 C 和 C++ 的编译器，以及其他一些在 LFS 中不会涉及的编译器。 |
| GDBM      | 包含 GNU 数据库管理库。LFS 的另一个软件包 Man-DB 需要该软件包。 |
| Gettext   | 包含用于许多其他软件包的国际化和本地化的工具和库。           |
| Glibc     | 包含主要的 C 语言库。Linux 程序没有该软件包的支持根本无法运行。 |
| GMP       | 包含一些数学库，提供了用于任意精度算术的函数。编译 GCC 需要该软件包。 |
| Gperf     | 包含一个能够根据键值集合生成完美散列函数的程序。Eudev 需要该软件包。 |
| Grep      | 包含在文本中搜索指定模式的程序。它被多数软件包的编译脚本所使用。 |
| Groff     | 包含用于处理和格式化文本的程序。它们的一项重要功能是生成 man 页面。 |
| GRUB      | 是 Grand Unified Boot Loader。Linux 可以使用其他引导加载器，但 GRUB 最灵活。 |
| Gzip      | 包含用于压缩和解压缩文件的程序。许多 LFS 软件包的解压需要该软件包。 |
| Iana-etc  | 包含网络服务和协议的描述数据。网络功能的正确运作需要该软件包。 |
| Inetutils | 包含基本网络管理程序。                                       |
| Intltool  | 包含能够从源代码中提取可翻译字符串的工具。                   |
| IProute2  | 提供了用于 IPv4 和 IPv6 网络的基础和高级管理程序。和另一个常见的网络工具包 net-tools              相比，它具有管理 IPv6 网络的能力。 |
| Jinja2    | 是一个处理文本文件模板的 Python 模块。构建 Systemd 需要它。  |
| Kbd       | 包含键盘映射文件，用于非美式键盘的键盘工具，以及一些控制台字体。 |
| Kmod      | 包含用于管理 Linux 内核模块的程序。                          |
| Less      | 包含一个很好的文本文件查看器，它支持在查看文件时上下滚动。此外，Man-DB 使用该软件包来显示 man 页面。 |
| Libcap    | 实现了用于访问 Linux 内核中 POSIX 1003.1e 权能字功能的用户空间接口。 |
| Libelf    | Elfutils 项目提供了用于 ELF 文件和 DWARF              数据的工具和库。该软件包的大多数工具已经由其他软件包提供，但使用默认 (也是最高效的) 配置构建 Linux              内核时，需要使用该软件包的库。 |
|           |                                                              |
|           |                                                              |
|           |                                                              |
|           |                                                              |
|           |                                                              |
|           |                                                              |
|           |                                                              |

- ​              Libffi            

  ​              这个软件包实现了一个可移植的高级编程接口，用于处理不同的调用惯例。某些程序在编译时并不知道如何向函数传递参数，例如解释器在运行时才得到函数的参数个数和类型信息。它们可以使用              libffi 作为解释语言和编译语言之间的桥梁。            

- ​              Libpipeline            

  ​              Libpipeline 包含一个能够灵活、方便地操作子进程流水线的库。Man-DB 软件包要求这个库。            

- ​              Libtool            

  ​              这个软件包包含 GNU 通用库支持脚本。它将共享库的使用封装成一个一致、可移植的接口。在其他 LFS              软件包的测试套件中需要该软件包。            

- ​              Linux Kernel            

  ​              这个软件包就是操作系统。我们平常说的 “GNU/Linux” 环境中的 “Linux” 就指的是它。            

- ​              M4            

  ​              这个软件包包含通用的文本宏处理器。它被其他程序用于构建工具。            

- ​              Make            

  ​              这个软件包包含用于指导软件包编译过程的程序。LFS 中几乎每个软件包都需要它。            

- ​              MarkupSafe            

  ​              该软件包是一个安全地处理 HTML/XHTML/XML 中的字符串的 Python 模块。Jinja2 需要该软件包。            

- ​              Man-DB            

  ​              这个软件包包含用于查找和浏览 man 页面的程序。与 man              软件包相比，该软件包的国际化功能更为强大。该软件包提供了 man 程序。            

- ​              Man-pages            

  ​              这个软件包包含基本的 Linux man 页面的实际内容。            

- ​              Meson            

  ​              这个软件包提供一个自动编译软件的工具。它的设计目标是最小化软件开发者不得不用于配置构建系统的时间。该软件包在构建              Systemd 和很多 BLFS 软件包时是必要的。            

- ​              MPC            

  ​              这个软件包包含用于复数算术的函数。GCC 需要该软件包。            

- ​              MPFR            

  ​              这个软件包包含用于多精度算术的函数。GCC 需要该软件包。            

- ​              Ninja            

  ​              这个软件包包含一个注重执行速度的小型构建系统。它被设计为读取高级构建系统输出的配置文件，并以尽量高的速度运行。Meson              需要该软件包。            

- ​              Ncurses            

  ​              这个软件包包含用于处理字符界面的不依赖特定终端的库。它一般被用于为菜单系统提供光标控制。一些 LFS 软件包需要该软件包。            

- ​              Openssl            

  ​              这个软件包包含关于密码学的管理工具和库，它们被用于为 Linux 内核等其他软件包提供密码学功能。            

- ​              Patch            

  ​              这个软件包包含一个通过 *补丁*              文件修改或创建文件的程序。补丁文件通常由 diff              程序创建。一些 LFS 软件包的编译过程需要该软件包。            

- ​              Perl            

  ​              这个软件包是运行时语言 PERL 的解释器。几个 LFS 软件包的安装和测试过程需要该软件包。            

- ​              Pkg-config            

  ​              这个软件包提供一个查询已经安装的库和软件包的元数据信息的程序。            

- ​              Procps-NG            

  ​              这个软件包包含用于监控系统进程的程序，对系统管理非常有用。另外 LFS 引导脚本也需要该软件包。            

- ​              Psmisc            

  ​              这个软件包包含一些显示当前运行的系统进程信息的程序，对系统管理非常有用。            

- ​              Python 3            

  ​              这个软件包提供了一种解释性语言支持，它围绕代码可读性这一重点而设计。            

- ​              Readline            

  ​              这个软件包包含一组库，提供命令行编辑和历史记录支持。Bash 需要该软件包。            

- ​              Sed            

  ​              这个软件包可以在没有文本编辑器的情况下编辑文本文件。另外，大多数 LFS 软件包的配置脚本需要该软件包。            

- ​              Shadow            

  ​              这个软件包包含用于安全地处理密码的程序。            

- ​              Systemd            

  ​              这个软件包包含一个init程序，和一些附加的引导和系统控制支持。它能够替代              Sysvinit。许多商业发行版使用该软件包。            

- ​              Tar            

  ​              这个软件包提供存档和提取功能，几乎每个 LFS 软件包都需要它才能被提取。            

- ​              Tcl            

  ​              这个软件包包含在 LFS 软件包的测试套件中广泛使用的工具控制语言 (Tool Command Language)。            

- ​              Texinfo            

  ​              这个软件包包含用于阅读、编写和转换 info 页面的程序。它被用于许多 LFS 软件包的安装过程中。            

- ​              Util-linux            

  ​              这个软件包包含许多工具程序，其中有处理文件系统、终端、分区和消息的工具。            

- ​              Wheel            

  ​              该软件包包含一个 Python 模块，该模块是 Python wheel 软件包标准格式的参考实现。            

- ​              Vim            

  ​              这个软件包包含一个编辑器，由于它与经典的 vi              编辑器相兼容，且拥有许多强大的功能，我们选择这个编辑器。编辑器的选择是非常主观的，如果希望的话，读者可以选择其他编辑器。            

- ​              XML::Parser            

  ​              这个软件包是和 Expat 交互的 Perl 模块。            

- ​              XZ Utils            

  ​              这个软件包包含用于压缩和解压缩文件的程序。在所有这类程序中，该软件包提供了最高的压缩率。该软件包被用于解压 XZ 或 LZMA              格式的压缩文件。            

- ​              Zlib            

  ​              这个软件包包含一些程序使用的压缩和解压缩子程序。            

- ​              Zstd            

  ​              这个软件包包含一些程序使用的压缩和解压缩子程序。它具有较高的压缩比，以及很宽的压缩比/速度权衡范围。            

## 准备工作            

### 准备宿主系统

#### 宿主系统需求

宿主系统必须拥有下列软件，且版本不能低于给出的最低版本。对于大多数现代 Linux 发行版来说这不成问题。要注意的是，很多发行版会把软件的头文件放在单独的软件包中，这些软件包的名称往往是 “<软件包名>-devel” 或者 “<软件包名>-dev”。如果您的发行版为下列软件提供了这类软件包，一定要安装它们。

比下列最低版本更古老的版本可能正常工作，但作者没有进行测试。

| 软件包          | 描述                                     |
| --------------- | ---------------------------------------- |
| Bash-3.2        | /bin/sh 必须是到 bash 的符号链接或硬连接 |
| Binutils-2.13.1 | 比 2.39 更新的版本未经测试，不推荐使用   |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |
|                 |                                          |

- ​              **Bison-2.7**              (/usr/bin/yacc 必须是到 bison 的链接，或者是一个执行 bison 的小脚本)            

- ​              **Coreutils-6.9**            

- ​              **Diffutils-2.8.1**            

- ​              **Findutils-4.2.31**            

- ​              **Gawk-4.0.1**              (/usr/bin/awk 必须是到 gawk 的链接)            

- ​              **GCC-4.8**，包括 C++ 编译器              **g++** (比 12.2.0              更新的版本未经测试，不推荐使用)。C 和 C++ 标准库 (包括头文件) 也必须可用，这样 C++              编译器才能构建宿主环境的程序            

- ​              **Grep-2.5.1a**            

- ​              **Gzip-1.3.12**            

- ​              **Linux Kernel-3.2**            

  ​              内核版本的要求是为了符合[第 5 章](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/chapter05.html)和[第 8 章](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/chapter08.html)中编译 glibc 时开发者推荐的配置选项。udev 也要求一定的内核版本。            

  ​              如果宿主内核比 3.2 更早，您需要将内核升级到较新的版本。升级内核有两种方法，如果您的发行版供应商提供了 3.2              或更新的内核软件包，您可以直接安装它。如果供应商没有提供一个足够新的内核包，或者您不想安装它，您可以自己编译内核。编译内核和配置启动引导器              (假设宿主使用 GRUB) 的步骤在[第 10 章](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter10/chapter10.html)中。            

- ​              **M4-1.4.10**            

- ​              **Make-4.0**            

- ​              **Patch-2.5.4**            

- ​              **Perl-5.8.8**            

- ​              **Python-3.4**            

- ​              **Sed-4.1.5**            

- ​              **Tar-1.22**            

- ​              **Texinfo-4.7**            

- ​              **Xz-5.0.0**            

>  重要：
>
> 上面要求的符号链接是根据本书构建 LFS 的充分条件，不是必要条件。链接指向其他软件 (如 dash 或 mawk 等)          可能不会引发问题，但 LFS          开发团队没有尝试过这种做法，也无法提供帮助。对于一些软件包来说，您可能需要修改本书中的指令或者使用额外的补丁，才能在这类宿主环境成功构建。                 

为了确定您的宿主系统拥有每个软件的合适版本，且能够编译程序，请运行下列脚本。      

```bash
cat > version-check.sh << "EOF"
#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found"
fi

echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else
  echo "awk not found"
fi

gcc --version | head -n1
g++ --version | head -n1
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1  # texinfo version
xz --version | head -n1

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy
EOF

bash version-check.sh
```

#### 创建新的分区

推荐为 LFS 选择一个可用的空分区，或者在有充足未划分空间的情况下，创建一个新分区。      

一个最小的系统需要大小约 10 GB 的分区。这足够保存所有源代码压缩包，并且编译所有软件包。然而，如果希望用 LFS 作为日常的 Linux 系统，很可能需要安装额外软件，需要更多空间。一个 30 GB 的分区是比较合理的。LFS 系统本身用不了太多空间，但大分区可以提供足够的临时存储空间，以及在 LFS 构建完成后增添附加功能需要的空间。另外，编译软件包可能需要大量磁盘空间，但在软件包安装完成后可以回收这些空间。

计算机未必有足够满足编译过程要求的内存 (RAM) 空间，因此可以使用一个小的磁盘分区作为 `swap` 空间。内核使用此分区存储很少使用的数据，从而为活动进程留出更多内存。LFS 的 `swap` 分区可以和宿主系统共用，这样就不用专门为 LFS 创建一个。         

​          经常有人在 LFS 邮件列表询问如何进行系统分区。这是一个相当主观的问题。许多发行版在默认情况下会使用整个磁盘，只留下一个小的          swap 分区。对于 LFS 来说，这往往不是最好的方案。它削弱了系统的灵活性，使得我们难以在多个发行版或 LFS          系统之间共享数据，增加系统备份时间，同时导致文件系统结构的不合理分配，浪费磁盘空间。        

###             2.4.1.1. 根分区          

​            一个 LFS 根分区 (不要与 `/root` 目录混淆) 一般分配 20            GB 的空间就足以保证多数系统的运行。它提供了构建 LFS 以及 BLFS            的大部分软件包的充足空间，但又不太大，因此能够创建多个分区，多次尝试构建 LFS 系统。          

###             2.4.1.2. 交换 (Swap) 分区          

​            许多发行版自动创建交换空间。一般来说，推荐采用两倍于物理内存的交换空间，然而这几乎没有必要。如果磁盘空间有限，可以创建不超过            2GB 的交换空间，并注意它的使用情况。          

​            如果您希望使用 Linux 的休眠功能            (挂起到磁盘)，它会在关机前将内存内容写入到交换分区。这种情况下，交换分区的大小应该至少和系统内存相同。          

​            交换到磁盘从来就不是一件好事。对于机械硬盘，通过听硬盘的工作噪声，同时观察系统的响应速度，就能分辨出系统是否在交换。对于            SSD，您无法听到工作噪声，但可以使用 **top** 或 **free** 命令查看使用了多少交换空间。应该尽量避免使用 SSD            设备上建立的交换分区。一旦发生交换，首先检查是否输入了不合理的命令，例如试图编辑一个 5GB            的文件。如果交换时常发生，最好的办法是为你的系统添置内存。          

###             2.4.1.3. Grub Bios 分区          

​            如果*启动磁盘*采用 GUID 分区表            (GPT)，那么必须创建一个小的，一般占据 1MB 的分区，除非它已经存在。这个分区不能格式化，在安装启动引导器时必须能够被            GRUB 发现。这个分区在 **fdisk**            下显示为 'BIOS Boot' 分区，在 **gdisk** 下显示分区类型代号为 *EF02*。          

![[注意]](https://lfs.xry111.site/zh_CN/11.2-systemd/images/note.png)

###               注意            

​              Grub Bios 分区必须位于 BIOS 引导系统使用的磁盘上。这个磁盘未必是 LFS              根分区所在的磁盘。不同磁盘可以使用不同分区表格式，只有引导盘采用 GPT 时才必须创建该分区。            

###             2.4.1.4. 常用分区          

​            还有其他几个并非必须，但在设计磁盘布局时应当考虑的分区。下面的列表并不完整，但可以作为一个参考。          

- ​                  /boot – 高度推荐。这个分区可以存储内核和其他引导信息。为了减少大磁盘可能引起的问题，建议将 /boot                  分区设为第一块磁盘的第一个分区。为它分配 200 MB 就绰绰有余。                
- ​                  /boot/efi – EFI 系统分区，在使用 UEFI 引导系统时是必要的。阅读 [                   BLFS 页面](https://www.linuxfromscratch.org/blfs/view/stable-systemd/postlfs/grub-setup.html) 以获得详细信息。                
- ​                  /home – 高度推荐。独立的 /home 分区可以在多个发行版或 LFS 系统之间共享 home                  目录和用户设置。它的尺寸一般很大，取决于硬盘的可用空间。                
- ​                  /usr – 在 LFS 中，`/bin`，`/lib`，以及 `/sbin` 是指向 `/usr` 中对应目录的符号链接。因此，`/usr` 包含系统运行需要的所有二进制程序和库。对于 LFS，通常不需要为                  `/usr`                  创建单独的分区。如果仍然需要这种配置，需要为其建立一个能够容纳系统中所有程序和库的分区。同时，在这种配置下，根分区可以非常小                  (可能只需要一吉字节)，因此它适用于瘦客户端或者无盘工作站 (此时 `/usr` 从远程服务器挂载)。然而，需要注意的是，必须使用 initramfs                  (LFS 没有包含)，才能引导具有单独的 `/usr`                  分区的系统。                
- ​                  /opt – 这个目录往往被用于在 BLFS 中安装 Gnome 或 KDE 等大型软件，以免把大量文件塞进 /usr                  目录树。如果将它划分为独立分区，5 到 10 GB 一般就足够了。                
- ​                  /tmp – 一个独立的 /tmp 分区是很少见的，但在配置瘦客户端时很有用。如果分配了这个分区，大小一般不会超过几个                  GB。                
- ​                  /usr/src – 将它划分为独立分区，可以用于存储 BLFS 源代码，并在多个 LFS                  系统之间共享它们。它也可以用于编译 BLFS 软件包。30-50 GB 的分区可以提供足够的空间。                

​            如果您希望在启动时自动挂载任何一个独立的分区，就要在 `/etc/fstab` 文件中说明。有关指定分区的细节将在[第 10.2 节 “创建 /etc/fstab             文件”](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter10/fstab.html) 中讨论。          

- ​                    [在分区上建立文件系统](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter02/creatingfilesystem.html)                  
- ​                    [设置 $LFS 环境变量](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter02/aboutlfs.html)                  
- ​                    [挂载新的分区](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter02/mounting.html)                  

### 软件包和补丁                

- ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter03/introduction.html)                  
- ​                    [全部软件包](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter03/packages.html)                  
- ​                    [必要的补丁](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter03/patches.html)                  

### 最后准备工作                

- ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter04/introduction.html)                  
- ​                    [在 LFS                     文件系统中创建有限目录布局](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter04/creatingminlayout.html)                  
- ​                    [添加 LFS 用户](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter04/addinguser.html)                  
- ​                    [配置环境](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter04/settingenvironment.html)                  
- ​                    [关于 SBU](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter04/aboutsbus.html)                  
- ​                    [关于测试套件](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter04/abouttestsuites.html)                  

- ###               III. 构建 LFS 交叉工具链和临时工具            

  - ####                   重要的提前阅读资料                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/partintro/introduction.html)                  
    - ​                    [工具链技术说明](https://lfs.xry111.site/zh_CN/11.2-systemd/partintro/toolchaintechnotes.html)                  
    - ​                    [编译过程的一般说明](https://lfs.xry111.site/zh_CN/11.2-systemd/partintro/generalinstructions.html)                  

  - ####                   5. 编译交叉工具链                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/introduction.html)                  
    - ​                    [Binutils-2.39 -                     第一遍](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/binutils-pass1.html)                  
    - ​                    [GCC-12.2.0 - 第一遍](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/gcc-pass1.html)                  
    - ​                    [Linux-5.19.2 API                     头文件](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/linux-headers.html)                  
    - ​                    [Glibc-2.36](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/glibc.html)                  
    - ​                    [GCC-12.2.0 中的                     Libstdc++](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter05/gcc-libstdc++.html)                  

  - ####                   6. 交叉编译临时工具                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/introduction.html)                  
    - ​                    [M4-1.4.19](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/m4.html)                  
    - ​                    [Ncurses-6.3](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/ncurses.html)                  
    - ​                    [Bash-5.1.16](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/bash.html)                  
    - ​                    [Coreutils-9.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/coreutils.html)                  
    - ​                    [Diffutils-3.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/diffutils.html)                  
    - ​                    [File-5.42](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/file.html)                  
    - ​                    [Findutils-4.9.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/findutils.html)                  
    - ​                    [Gawk-5.1.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/gawk.html)                  
    - ​                    [Grep-3.7](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/grep.html)                  
    - ​                    [Gzip-1.12](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/gzip.html)                  
    - ​                    [Make-4.3](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/make.html)                  
    - ​                    [Patch-2.7.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/patch.html)                  
    - ​                    [Sed-4.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/sed.html)                  
    - ​                    [Tar-1.34](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/tar.html)                  
    - ​                    [Xz-5.2.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/xz.html)                  
    - ​                    [Binutils-2.39 -                     第二遍](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/binutils-pass2.html)                  
    - ​                    [GCC-12.2.0 - 第二遍](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter06/gcc-pass2.html)                  

  - ####                   7. 进入 Chroot 并构建其他临时工具                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/introduction.html)                  
    - ​                    [改变所有者](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/changingowner.html)                  
    - ​                    [准备虚拟内核文件系统](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/kernfs.html)                  
    - ​                    [进入 Chroot 环境](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/chroot.html)                  
    - ​                    [创建目录](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/creatingdirs.html)                  
    - ​                    [创建必要的文件和符号链接](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/createfiles.html)                  
    - ​                    [Gettext-0.21](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/gettext.html)                  
    - ​                    [Bison-3.8.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/bison.html)                  
    - ​                    [Perl-5.36.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/perl.html)                  
    - ​                    [Python-3.10.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/Python.html)                  
    - ​                    [Texinfo-6.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/texinfo.html)                  
    - ​                    [Util-linux-2.38.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/util-linux.html)                  
    - ​                    [清理和备份临时系统](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter07/cleanup.html)                  

- ###               IV. 构建 LFS 系统            

  - ####                   8. 安装基本系统软件                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/introduction.html)                  
    - ​                    [软件包管理](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/pkgmgt.html)                  
    - ​                    [Man-pages-5.13](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/man-pages.html)                  
    - ​                    [Iana-Etc-20220812](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/iana-etc.html)                  
    - ​                    [Glibc-2.36](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/glibc.html)                  
    - ​                    [Zlib-1.2.12](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/zlib.html)                  
    - ​                    [Bzip2-1.0.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/bzip2.html)                  
    - ​                    [Xz-5.2.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/xz.html)                  
    - ​                    [Zstd-1.5.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/zstd.html)                  
    - ​                    [File-5.42](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/file.html)                  
    - ​                    [Readline-8.1.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/readline.html)                  
    - ​                    [M4-1.4.19](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/m4.html)                  
    - ​                    [Bc-6.0.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/bc.html)                  
    - ​                    [Flex-2.6.4](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/flex.html)                  
    - ​                    [Tcl-8.6.12](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/tcl.html)                  
    - ​                    [Expect-5.45.4](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/expect.html)                  
    - ​                    [DejaGNU-1.6.3](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/dejagnu.html)                  
    - ​                    [Binutils-2.39](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/binutils.html)                  
    - ​                    [GMP-6.2.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gmp.html)                  
    - ​                    [MPFR-4.1.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/mpfr.html)                  
    - ​                    [MPC-1.2.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/mpc.html)                  
    - ​                    [Attr-2.5.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/attr.html)                  
    - ​                    [Acl-2.3.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/acl.html)                  
    - ​                    [Libcap-2.65](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/libcap.html)                  
    - ​                    [Shadow-4.12.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/shadow.html)                  
    - ​                    [GCC-12.2.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gcc.html)                  
    - ​                    [Pkg-config-0.29.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/pkg-config.html)                  
    - ​                    [Ncurses-6.3](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/ncurses.html)                  
    - ​                    [Sed-4.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/sed.html)                  
    - ​                    [Psmisc-23.5](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/psmisc.html)                  
    - ​                    [Gettext-0.21](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gettext.html)                  
    - ​                    [Bison-3.8.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/bison.html)                  
    - ​                    [Grep-3.7](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/grep.html)                  
    - ​                    [Bash-5.1.16](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/bash.html)                  
    - ​                    [Libtool-2.4.7](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/libtool.html)                  
    - ​                    [GDBM-1.23](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gdbm.html)                  
    - ​                    [Gperf-3.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gperf.html)                  
    - ​                    [Expat-2.4.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/expat.html)                  
    - ​                    [Inetutils-2.3](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/inetutils.html)                  
    - ​                    [Less-590](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/less.html)                  
    - ​                    [Perl-5.36.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/perl.html)                  
    - ​                    [XML::Parser-2.46](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/xml-parser.html)                  
    - ​                    [Intltool-0.51.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/intltool.html)                  
    - ​                    [Autoconf-2.71](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/autoconf.html)                  
    - ​                    [Automake-1.16.5](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/automake.html)                  
    - ​                    [OpenSSL-3.0.5](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/openssl.html)                  
    - ​                    [Kmod-30](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/kmod.html)                  
    - ​                    [Elfutils-0.187 中的                     Libelf](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/libelf.html)                  
    - ​                    [Libffi-3.4.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/libffi.html)                  
    - ​                    [Python-3.10.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/Python.html)                  
    - ​                    [Wheel-0.37.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/wheel.html)                  
    - ​                    [Ninja-1.11.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/ninja.html)                  
    - ​                    [Meson-0.63.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/meson.html)                  
    - ​                    [Coreutils-9.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/coreutils.html)                  
    - ​                    [Check-0.15.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/check.html)                  
    - ​                    [Diffutils-3.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/diffutils.html)                  
    - ​                    [Gawk-5.1.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gawk.html)                  
    - ​                    [Findutils-4.9.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/findutils.html)                  
    - ​                    [Groff-1.22.4](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/groff.html)                  
    - ​                    [GRUB-2.06](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/grub.html)                  
    - ​                    [Gzip-1.12](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/gzip.html)                  
    - ​                    [IPRoute2-5.19.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/iproute2.html)                  
    - ​                    [Kbd-2.5.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/kbd.html)                  
    - ​                    [Libpipeline-1.5.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/libpipeline.html)                  
    - ​                    [Make-4.3](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/make.html)                  
    - ​                    [Patch-2.7.6](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/patch.html)                  
    - ​                    [Tar-1.34](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/tar.html)                  
    - ​                    [Texinfo-6.8](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/texinfo.html)                  
    - ​                    [Vim-9.0.0228](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/vim.html)                  
    - ​                    [MarkupSafe-2.1.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/markupsafe.html)                  
    - ​                    [Jinja2-3.1.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/jinja2.html)                  
    - ​                    [Systemd-251](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/systemd.html)                  
    - ​                    [D-Bus-1.14.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/dbus.html)                  
    - ​                    [Man-DB-2.10.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/man-db.html)                  
    - ​                    [Procps-ng-4.0.0](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/procps-ng.html)                  
    - ​                    [Util-linux-2.38.1](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/util-linux.html)                  
    - ​                    [E2fsprogs-1.46.5](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/e2fsprogs.html)                  
    - ​                    [关于调试符号](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/aboutdebug.html)                  
    - ​                    [移除调试符号](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/stripping.html)                  
    - ​                    [清理系统](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter08/cleanup.html)                  

  - ####                   9. 系统配置                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/introduction.html)                  
    - ​                    [一般网络配置](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/network.html)                  
    - ​                    [设备和模块管理概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/udev.html)                  
    - ​                    [管理设备](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/symlinks.html)                  
    - ​                    [配置系统时钟](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/clock.html)                  
    - ​                    [配置 Linux 控制台](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/console.html)                  
    - ​                    [配置系统 Locale](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/locale.html)                  
    - ​                    [创建 /etc/inputrc 文件](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/inputrc.html)                  
    - ​                    [创建 /etc/shells 文件](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/etcshells.html)                  
    - ​                    [Systemd 使用和配置](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter09/systemd-custom.html)                  

  - ####                   10. 使 LFS 系统可引导                

    - ​                    [概述](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter10/introduction.html)                  
    - ​                    [创建 /etc/fstab 文件](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter10/fstab.html)                  
    - ​                    [Linux-5.19.2](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter10/kernel.html)                  
    - ​                    [使用 GRUB 设定引导过程](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter10/grub.html)                  

  - ####                   11. 尾声                

    - ​                    [收尾工作](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter11/theend.html)                  
    - ​                    [增加 LFS 用户计数](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter11/getcounted.html)                  
    - ​                    [重启系统](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter11/reboot.html)                  
    - ​                    [下面该做什么？](https://lfs.xry111.site/zh_CN/11.2-systemd/chapter11/whatnow.html)                  

- ###               V. 附录            

  - ​                [A. 缩写和术语](https://lfs.xry111.site/zh_CN/11.2-systemd/appendices/acronymlist.html)              
  - ​                [B. 致谢](https://lfs.xry111.site/zh_CN/11.2-systemd/appendices/acknowledgments.html)              
  - ​                [C. 依赖关系](https://lfs.xry111.site/zh_CN/11.2-systemd/appendices/dependencies.html)              
  - D. LFS 授权许可
    - ​                    [Creative Commons                     License](https://lfs.xry111.site/zh_CN/11.2-systemd/appendices/creat-comm.html)                  
    - ​                    [The MIT License](https://lfs.xry111.site/zh_CN/11.2-systemd/appendices/mit.html)                  