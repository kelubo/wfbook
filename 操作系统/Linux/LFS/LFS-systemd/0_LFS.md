# Linux From Scratch
## version 7.7-systemd
### 创建者 Gerard Beekmans
### 编辑者 Matthew Burgess 和 Armin K.
<u>Copyright</u> © 1999-2015 Gerard Beekmans

目录

    序章
        前言
        致读者
        LFS 的目标架构
        LFS 和标准
        本书中的软件包逻辑
        前置需求
        宿主系统需求
        排版约定
        本书结构
        勘误表
    第一部分 介绍
        第一章 介绍
            如何构建 LFS 系统
            上次发布以来的更新
            更新日志
            资源
            帮助
    第二部分 准备构建
        第二章 准备新分区
            简介
            创建新分区
            在分区上创建文件系统
            挂载新分区
            设置 $LFS 变量
        第三章 软件包与补丁
            简介
            所有软件包
            所需补丁
        第四章 最后的准备
            简介
            创建 $LFS/tools 目录
            添加 LFS 用户
            设置环境
            关于 SBU
            关于测试套件
        第五章 构建临时文件系统
            简介
            工具链技术备注
            通用编译指南
            Binutils-2.25 - 第一遍
            GCC-4.9.2 - 第一遍
            Linux-3.19 API 头文件
            Glibc-2.21
            Libstdc++-4.9.2
            Binutils-2.25 - 第二遍
            GCC-4.9.2 - 第二遍
            Tcl-8.6.3
            Expect-5.45
            DejaGNU-1.5.2
            Check-0.9.14
            Ncurses-5.9
            Bash-4.3.30
            Bzip2-1.0.6
            Coreutils-8.23
            Diffutils-3.3
            File-5.22
            Findutils-4.4.2
            Gawk-4.1.1
            Gettext-0.19.4
            Grep-2.21
            Gzip-1.6
            M4-1.4.17
            Make-4.1
            Patch-2.7.4
            Perl-5.20.2
            Sed-4.2.2
            Tar-1.28
            Texinfo-5.2
            Util-linux-2.26
            Xz-5.2.0
            清理无用内容
            改变属主
    第三部分 构建 LFS 系统
        第六章 安装基本的系统软件
            简介
            准备虚拟内核文件系统
            软件包管理
            进入 chroot 环境
            创建目录
            创建必需的文件和符号链接
            Linux-3.19 API Headers
            Man-pages-3.79
            Glibc-2.21
            调整工具链
            Zlib-1.2.8
            File-5.22
            Binutils-2.25
            GMP-6.0.0a
            MPFR-3.1.2
            MPC-1.0.2
            GCC-4.9.2
            Bzip2-1.0.6
            Pkg-config-0.28
            Ncurses-5.9
            Attr-2.4.47
            Acl-2.2.52
            Libcap-2.24
            Sed-4.2.2
            Shadow-4.2.1
            Psmisc-22.21
            Procps-ng-3.3.10
            E2fsprogs-1.42.12
            Coreutils-8.23
            Iana-Etc-2.30
            M4-1.4.17
            Flex-2.5.39
            Bison-3.0.4
            Grep-2.21
            Readline-6.3
            Bash-4.3.30
            Bc-1.06.95
            Libtool-2.4.6
            GDBM-1.11
            Expat-2.1.0
            Inetutils-1.9.2
            Perl-5.20.2
            XML::Parser-2.44
            Autoconf-2.69
            Automake-1.15
            Diffutils-3.3
            Gawk-4.1.1
            Findutils-4.4.2
            Gettext-0.19.4
            Intltool-0.50.2
            Gperf-3.0.4
            Groff-1.22.3
            Xz-5.2.0
            GRUB-2.02~beta2
            Less-458
            Gzip-1.6
            IPRoute2-3.19.0
            Kbd-2.0.2
            Kmod-19
            Libpipeline-1.4.0
            Make-4.1
            Patch-2.7.4
            Systemd-219
            D-Bus-1.8.16
            Util-linux-2.26
            Man-DB-2.7.1
            Tar-1.28
            Texinfo-5.2
            Vim-7.4
            关于调试符号
            再次清理无用内容
            清理
        第七章 基本系统配置
            简介
            通用网络配置
            LFS 系统中的设备和模块控制
            定制设备的符号链接
            配置系统时钟
            配置 Linux 主控台
            配置系统本地化
            创建 /etc/inputrc 文件
            创建 /etc/shells 文件
            使用及配置 Systemd
        第八章 让 LFS 系统可引导
            简介
            创建 /etc/fstab 文件
            Linux-3.19
            用 GRUB 设置引导过程
        第九章 尾声
            最后的最后
            为 LFS 用户数添砖加瓦
            重启系统
            接下来做什么呢？
    第四部分 附录
        附录 A. 缩略词和术语
        附录 B. 荣誉榜
        附录 C. 依赖关系
        附录 D. LFS 许可协议
            Creative Commons License
            The MIT License
    索引