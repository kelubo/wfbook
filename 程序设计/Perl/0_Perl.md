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

### 交互式编程

可以在命令行中使用 **-e** 选项来输入语句来执行代码，实例如下：

```bash
perl -e 'print "Hello World\n"'
```

输入以上命令，回车后，输出结果为：

```bash
Hello World
```

### 脚本式编程

将代码放到 hello.pl 文件中（以 .pl、.PL 作为后缀）。文件名可以包含数字，符号和字母，但不能包含空格，可以使用下划线（_）来替代空格。

代码中 `/usr/bin/perl` 是 perl 解释器的路径。在执行该脚本前要先确保文件有可执行权限，可以先将文件权限修改为 0755 ：

```bash
chmod 0755 hello.pl 
./hello.pl
```

print 也可以使用括号来输出字符串，以下两个语句输出相同的结果：

```perl
print("Hello, world\n");
print "Hello, world\n";
```

## 运行 Perl

Perl 有不同的执行方式。

### 交互式

可以在命令行中直接执行 perl 代码，语法格式如下：

```bash
$perl  -e <perl code>           # Unix/Linux

C:>perl -e <perl code>          # Windows/DOS
```

命令行参数如下所示：

| 选项          | 描述                    |
| ------------- | ----------------------- |
| -d[:debugger] | 在调试模式下运行程序    |
| -Idirectory   | 指定 @INC/#include 目录 |
| -T            | 允许污染检测            |
| -t            | 允许污染警告            |
| -U            | 允许不安全操作          |
| -w            | 允许很多有用的警告      |
| -W            | 允许所有警告            |
| -X            | 禁用使用警告            |
| -e program    | 执行 perl 代码          |
| file          | 执行 perl 脚本文件      |

### 脚本执行

可以将 perl 代码放在脚本文件中，通过以下命令来执行文件代码：

```bash
$perl  script.pl          # Unix/Linux

C:>perl script.pl         # Windows/DOS
```

### 集成开发环境（IDE:Integrated Development Environment）

也可以在一些图形用户界面（GUI）环境上执行 perl 脚本。以下推荐两款常用的 Perl 集成开发环境：

-  [Padre](http://padre.perlide.org/)：Padre 是一个为 Perl 语言开发者提供的集成开发环境，提供了语法高亮和代码重构功能。

- [EPIC](http://www.epic-ide.org/) : EPIC  是 Perl Eclipse IDE 的插件，如果你熟悉 Eclipse ，你可以使用它。

  安装步骤：Help --> Eclipse Marketplace --> 输入 EPIC --> 选择安装并更新即可。


## 基础语法

Perl 借用了C、sed、awk、shel l脚本以及很多其他编程语言的特性，语法与这些语言有些类似，也有自己的特点。

Perl 程序由声明与语句组成，程序自上而下执行，包含了循环，条件控制，每个语句以分号 `;` 结束。

Perl 语言没有严格的格式规范，可以根据自己喜欢的风格来缩进。

### 注释

使用注释使程序易读，这是好的编程习惯。

perl 注释的方法为在语句的开头用字符 `#` ，如：

```perl
# 这一行是 perl 中的注释
```

perl 也支持多行注释，最常用的方法是使用 POD(Plain Old Documentations) 来进行多行注释。方法如下: 

```perl
#!/usr/bin/perl

# 这是一个单行注释
print "Hello, world\n";

=pod 注释
这是一个多行注释
这是一个多行注释
这是一个多行注释
这是一个多行注释
=cut
```

执行以上程序，输出结果为：

```bash
Hello, world
```

> **注意：**
>
> - =pod、 =cut 只能在行首。
> - 以 = 开头，以 =cut 结尾。 
> - = 后面要紧接一个字符，=cut 后面可以不用。 

### 空白

Perl 解释器不会关心有多少个空白，以下程序也能正常运行：

```perl
#!/usr/bin/perl

print       "Hello, world\n";
```

执行以上程序，输出结果为：

```bash
Hello, world
```

但是如果空格和分行出现在字符串内，他会原样输出：

```perl
#!/usr/bin/perl

# 会输出分行
print "Hello
             world\n";
```

执行以上程序，输出结果为：

```bash
Hello
      world
```

所有类型的空白如：空格，tab ，空行等如果在引号外解释器会忽略它，如果在引号内会原样输出。

### 单引号和双引号

perl 输出字符串可以使用单引号和双引号，如下所示：

```perl
#!/usr/bin/perl

print "Hello, world\n";    # 双引号
print 'Hello, world\n';    # 单引号
```

输出结果如下：

```bash
Hello, world
Hello, world\n
```

从结果中可以看出，双引号 \n 输出了换行，而单引号没有。

Perl 双引号和单引号的区别：双引号可以正常解析一些转义字符与变量，而单引号无法解析会原样输出。

```perl
#!/usr/bin/perl

$a = 10;
print "a = $a\n";
print 'a = $a\n';
```

输出结果如下：

```bash
a = 10
a = $a\n
```

### Here 文档

Here 文档又称作 heredoc、hereis、here-字串 或 here-脚本，是一种在命令行 shell（如 sh、csh、ksh、bash、PowerShell 和 zsh）和程序语言（像 Perl、PHP、Python 和 Ruby）里定义一个字串的方法。

使用概述：

- 必须后接分号，否则编译通不过。
- EOF 可以用任意其它字符代替，只需保证结束标识与开始标识一致。
- 结束标识必须顶格独自占一行（即必须从行首开始，前后不能衔接任何空白和字符）。
- 开始标识可以不带引号号或带单双引号，不带引号与带双引号效果一致，解释内嵌的变量和转义符号，带单引号则不解释内嵌的变量和转义符号。
- 当内容需要内嵌引号（单引号或双引号）时，不需要加转义符，本身对单双引号转义，此处相当与 q 和 qq 的用法。

```perl
#!/usr/bin/perl

$a = 10;
$var = <<"EOF";
这是一个 Here 文档实例，使用双引号。
可以在这输入字符串和变量。
例如：a = $a
EOF
print "$var\n";

$var = <<'EOF';
这是一个 Here 文档实例，使用单引号。
例如：a = $a
EOF
print "$var\n";
```

执行以上程序输出结果为：

```bash
这是一个 Here 文档实例，使用双引号。
可以在这输入字符串和变量。
例如：a = 10

这是一个 Here 文档实例，使用单引号。
例如：a = $a
```

### 转义字符

如果需要输出一个特殊的字符，可以使用反斜线（\）来转义，例如输出美元符号 ($) :

```perl
#!/usr/bin/perl

$result = "test \"test\"";
print "$result\n";
print "\$result\n";
```

执行以上程序输出结果为：

```bash
test "test"
$result
```

### 标识符

Perl 标识符是用户编程时使用的名字，在程序中使用的变量名，常量名，函数名，语句块名等统称为标识符。

- 标识符组成单元：英文字母（a~z，A~Z），数字（0~9）和下划线（_）。
- 标识符由英文字母或下划线开头。
- 标识符区分大小写，`$runoob` 与 `$Runoob` 表示两个不同变量。

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
