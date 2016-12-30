# gcc 升级
CentOS6.8自带的gcc版本为4.4.7，有些年代了，一些新软件要用到的库没有，最新的gcc4.8.2已经放出来了，于是下载源代码安装了一个试试。

1.首先把旧的gcc相关的编译工具安装好


cd /mnt/Packages/

#rpm -ivh openssl-devel-1.0.1e-48.el6.x86_64.rpm  krb5-devel-1.10.3-57.el6.x86_64.rpm  zlib-devel-1.2.3-29.el6.x86_64.rpm  keyutils-libs-devel-1.4-5.el6.x86_64.rpm  libcom_err-devel-1.41.12-22.el6.x86_64.rpm libselinux-devel-2.0.94-7.el6.x86_64.rpm  libsepol-devel-2.0.41-4.el6.x86_64.rpm


rpm -ivh gcc-c++-4.4.7-17.el6.x86_64.rpm  libstdc++-devel-4.4.7-17.el6.x86_64.rpm
yum install bison makeinfo
yum groupinstall "Development Tools"


[javascript] viewplaincopy在CODE上查看代码片派生到我的代码片

   yum install gcc gcc-c++ glibc-static -y  


2.下载gcc 4.8.2源代码
[html] viewplaincopy在CODE上查看代码片派生到我的代码片

   wget ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.8.2/gcc-4.8.2.tar.bz2  


解压缩源代码包，进入gcc-4.8.2目录，执行./contrib/download_prerequisities脚本会自动下载三个依赖库别为gmp-4.3.2、mpfr-2.4.2、mpc-0.8.1，也可以通过如下地址离线下载安装：

ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.bz2
http://www.mpfr.org/mpfr-2.4.2/mpfr-2.4.2.tar.bz2
http://www.multiprecision.org/mpc/download/mpc-0.8.1.tar.gz

如果是通过脚本自动下载的依赖库，则会在gcc-4.8.2目录下生成gmp、mpfr和mpc三个目录，分别安装即可

3.安装gmp
[plain] viewplaincopy在CODE上查看代码片派生到我的代码片

   cd gmp  
   mkdir build  
   cd build  
   ../configure --prefix=/usr/local/gcc/gmp-4.3.2  


su获取root权限，执行安装
[plain] viewplaincopy在CODE上查看代码片派生到我的代码片

   make && make install  

4.安装mpfr

回到gcc-4.8.2目录进入mpfr目录
[html] viewplaincopy在CODE上查看代码片派生到我的代码片

   cd ../../mpfr  
   mkdir build  
   cd build  
   ../configure --prefix=/usr/local/gcc/mpfr-2.4.2 --with-gmp=/usr/local/gcc/gmp-4.3.2  


su获取root权限，执行安装
[plain] viewplaincopy在CODE上查看代码片派生到我的代码片

   make && make install  


5.安装mpc

回到gcc-4.8.2目录进入mpc目录
[plain] viewplaincopy在CODE上查看代码片派生到我的代码片

   cd ../../mpc  
   mkdir build  
   cd build  
   ../configure --prefix=/usr/local/gcc/mpc-0.8.1 --with-mpfr=/usr/local/gcc/mpfr-2.4.2 --with-gmp=/usr/local/gcc/gmp-4.3.2  


su获取root权限，执行安装
[plain] viewplaincopy在CODE上查看代码片派生到我的代码片

   make && make install  


6.添加共享库路径，su到root编辑ld.so.conf文件，添加如下内容到文件中：

/usr/local/gcc/gmp-4.3.2/lib
/usr/local/gcc/mpfr-2.4.2/lib
/usr/local/gcc/mpc-0.8.1/lib

保存退出，执行ldconfig命令

7.编译GCC4.8.2
[html] viewplaincopy在CODE上查看代码片派生到我的代码片

   cd ../..  
   mkdir build  
   cd build  
   ../configure --prefix=/usr/local/gcc --enable-threads=posix --disable-checking --enable-languages=c,c++ --disable-multilib  


换root，执行make && make install，开始漫长的等待......
[html] viewplaincopy在CODE上查看代码片派生到我的代码片

   make && make install  


8.卸载旧版本
[plain] viewplaincopy在CODE上查看代码片派生到我的代码片

   yum remove gcc  
   yum remove gcc-c++  
   updatedb  
