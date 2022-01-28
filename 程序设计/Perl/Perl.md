# Perl
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
