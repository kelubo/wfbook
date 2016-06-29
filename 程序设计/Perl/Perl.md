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
