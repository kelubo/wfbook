# Perl

[TOC]

## 概述

Perl 是 Practical Extraction and Report Language 的缩写，可翻译为 "实用报表提取语言"。

Perl 是高级、通用、直译式、动态的程序语言。

Perl 最初的设计者为拉里·沃尔（Larry Wall），于 1987 年 12 月 18 日发表，并由他不断更新和维护的编程语言。

Perl 借用了 C、sed、awk、shell 脚本以及很多其他编程语言的特性。

Perl 最重要的特性是 Perl 内部集成了正则表达式的功能，以及巨大的第三方代码库 CPAN 。

Perl，一种功能丰富的计算机程序语言，运行在超过 100 种计算机平台上，适用广泛，从大型机到便携设备，从快速原型创建到大规模可扩展开发。

Perl 语言的应用范围很广，除 CGI 以外，Perl 被用于图形编程、系统管理、网络编程、金融、生物以及其他领域。由于其灵活性，Perl 被称为脚本语言中的瑞士军刀。

Perl具有高级语言（如 C）的强大能力和灵活性。事实上，你将看到，它的许多特性是从 C 语言中借用来的。

Perl 与脚本语言一样，Perl 不需要编译器和链接器来运行代码，要做的只是写出程序并告诉 Perl 来运行而已。这意味着 Perl 对于小的编程问题的快速解决方案和为大型事件创建原型来测试潜在的解决方案是十分理想的。

Perl 提供脚本语言（如 sed 和 awk）的所有功能，还具有它们所不具备的很多功能。Perl 还支持 sed 到 Perl 及 awk 到 Perl 的翻译器。

简而言之，Perl 像 C 一样强大，像 awk、sed 等脚本描述语言一样方便。

### 优点

- 相比 C、Pascal 这样的"高级"语言而言，Perl 语言直接提供泛型变量、动态数组、Hash 表等更加便捷的编程元素。
- Perl 具有动态语言的强大灵活的特性，并且还从 C/C++、Basic、Pascal 等语言中分别借鉴了语法规则，从而提供了许多冗余语法。
- 在统一变量类型和掩盖运算细节方面，Perl 做得比其他高级语言(如：Python）更为出色。
- 由于从其他语言大量借鉴了语法，使得从其他编程语言转到 Perl 语言的程序员可以迅速上手写程序并完成任务，这使得 Perl 语言是一门容易用的语言。
- Perl 是可扩展的，我们可以通过[CPAN（"the Comprehensive Perl Archive Network"全面的 Perl 存档网络）](http://cpan.perl.org/)中心仓库找到很多我们需要的模块。
- Perl 的 [mod_perl](http://perl.apache.org) 的模块允许 Apache web 服务器使用 Perl 解释器。

### 缺点

也正是因为 Perl 的灵活性和"过度"的冗余语法，也因此获得了仅写（write-only）的"美誉"，因为 Perl 程序可以写得很随意（例如，变量不经声明就可以直接使用），但是可能少写一些字母就会得到意想不到的结果（而不报错），许多 Perl 程序的代码令人难以阅读，实现相同功能的程序代码长度可以相差十倍百倍，这就令程序的维护者（甚至是编写者）难以维护。

同样的，因为 Perl 这样随意的特点，可能会导致一些 Perl 程序员遗忘语法，以至于不得不经常查看 Perl 手册。

建议的解决方法是在程序里使用 `use strict;` 以及 `use warnings;` ，并统一代码风格，使用库，而不是自己使用"硬编码"。Perl 同样可以将代码书写得像 Python 或 Ruby 等语言一样优雅。

很多时候，perl.exe 进程会占用很多的内存空间，虽然只是一时，但是感觉不好。

## Hello World

```perl
#!/usr/bin/perl 
 
print "Hello, World!\n";
```



## Perl模块安装

CPAN(Comprehensive Perl Archive Network)是Perl模块最大的集散地，包含了现今公布的几乎所有的perl模块。
### 手工安装
从CPAN上下载需要的模块，手工编译、安装。
从 CPAN (http://search.cpan.org/) 下载了模块压缩文件，假设放在/usr/local/src/下。

    cd /usr/local/src

解压缩这个文件。

    tar xvzf Net-Server-0.97.tar.gz

换到解压后的目录：

    cd Net-Server-0.97

生成 makefile：

    perl Makefile.PL

生成模块：

    make

测试模块：

    make test
安装模块：

    make install

有的时候如果是build.pl的需要以下安装步骤：（需要Module::Build模块支持）

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

### 使用CPAN模块自动安装方法一

安装前需要先联上网，并且您需要取得root权限。

     perl -MCPAN -e shell

获得帮助

    cpan>help

列出CPAN上所有模块的列表

    cpan>m

安装模块，自动完成Net::Server模块从下载到安装的全过程。

    cpan>install Net::Server

退出

    cpan>quit

### 使用CPAN模块自动安装方法二

    cpan -i 模块名

　　例如：

    cpan -i Net::Server





# `perl` 搜索与替换[¶](https://docs.rockylinux.org/zh/gemstones/perl_search_replace/#perl)

有时您需要快速搜索与替换文件或者文件组中的字符串。有很多方法可以做到这一点 ，但在这里使用`perl`

要在目录下的多个文件中搜索和替换特定字符串，命令应该为：

```
perl -pi -w -e 's/search_for/replace_with/g;' ~/Dir_to_search/*.html
```

对于可能有多个字符串实例的单个文件，可以指定该文件：

```
perl -pi -w -e 's/search_for/replace_with/g;' /var/www/htdocs/bigfile.html
```

此命令使用vi语法进行搜索和替换，以查找字符串的任何匹配项，并在单个或多个特定类型的文件中将其替换为另一个字符串。用于替换嵌入在这些类型文件中的html/php链接更改，以及许多其他内容。

## 选项说明[¶](https://docs.rockylinux.org/zh/gemstones/perl_search_replace/#_1)

| 选项 | 解释                                                         |
| ---- | ------------------------------------------------------------ |
| -p   | 循环遍历指定的文件，同时打印所有的行                         |
| -i   | 原地替换文件，并将旧文件用指定的扩展名备份，不指定扩展名则不备份 |
| -w   | 打印警告信息                                                 |
| -e   | 使用命令行                                                   |
| -s   | 在程序文件之后启用基本解析的开关                             |
| -g   | 全局替换                                                     |

## 结尾[¶](https://docs.rockylinux.org/zh/gemstones/perl_search_replace/#_2)

使用`perl`替换一个或多个文件中的字符串的一种简单方法。

Author: Steven Spencer
