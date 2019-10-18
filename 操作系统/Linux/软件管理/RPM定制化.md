# 定制化RPM包

## rpmbuild

## FPM

作者是jordansissel 
FPM的github：https://github.com/jordansissel/fpm 
FPM功能简单说就是将一种类型的包转换成另一种类型。

**支持的源类型包**

  ```bash
  dir         将目录打包成所需要的类型，可以用于源码编译安装的软件包
  rpm         对rpm进行转换
  gem         对rubygem包进行转换
  python      将python模块打包成相应的类型
  ```

**支持的目标类型包**

```bash
rpm         转换为rpm包
deb         转换为deb包
solaris     转换为solaris包
puppet      转换为puppet模块
```

**FPM安装**

fpm是ruby写的，因此系统环境需要ruby，且ruby版本号大于1.8.5。

```bash
# 安装ruby模块
yum -y install ruby rubygems ruby-devel
# 查看当前使用的rubygems仓库
gem sources list
# 添加淘宝的Rubygems仓库，外国的源慢，移除原生的Ruby仓库
gem sources --add https://ruby.taobao.org/ --remove http://rubygems.org/
# 安装fpm，gem从rubygem仓库安装软件,类似yum从yum仓库安装软件。首先安装低版本的json，高版本的json需要ruby2.0以上，然后安装低版本的fpm，够用。
# CentOS 6
gem install json -v 1.8.3
gem install fpm -v 1.3.3
# CentOS7
gem install fpm
```

**FPM参数**

```bash
-s                  指定源类型
-t                  指定目标类型
-n                  指定包的名字
-v                  指定包的版本号
-C                  指定打包的相对路径
-d                  指定依赖于哪些包
-f                  第二次打包时目录下如果有同名安装包存在，则覆盖它
-p                  输出的安装包的目录，不想放在当前目录下就需要指定
--post-install      软件包安装完成之后所要运行的脚本；同--after-install
--pre-install       软件包安装完成之前所要运行的脚本；同--before-install
--post-uninstall    软件包卸载完成之后所要运行的脚本；同--after-remove
--pre-uninstall     软件包卸载完成之前所要运行的脚本；同--before-remove
```

**实例-定制nginx的RPM包**

1. 安装nginx

```bash
yum -y install pcre-devel openssl-devel
useradd nginx -M -s /sbin/nologin
tar xf nginx-1.6.2.tar.gz
cd nginx-1.6.2
./configure --prefix=/application/nginx-1.6.2 --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module
make && make install
ln -s /application/nginx-1.6.2/ /application/nginx
```

2. 编写脚本

```bash
cd /server/scripts/
vim nginx_rpm.sh  # 这是安装完rpm包要执行的脚本

#!/bin/bash
useradd nginx -M -s /sbin/nologin
ln -s /application/nginx-1.6.2/ /application/nginx
```

3. 打包

```bash
fpm -s dir -t rpm -n nginx -v 1.6.2 -d 'pcre-devel,openssl-devel' --post-install /server/scripts/nginx_rpm.sh -f /application/nginx-1.6.2/

no value for epoch is set, defaulting to nil {:level=>:warn}
no value for epoch is set, defaulting to nil {:level=>:warn}
Created package {:path=>"nginx-1.6.2-1.x86_64.rpm"}
```

**注意事项**

1. 相对路径问题

```bash
# 相对路径
fpm -s dir -t rpm -n nginx -v 1.6.2 .
rpm -qpl nginx-1.6.2-1.x86_64.rpm    

/client_body_temp
/conf/extra/dynamic_pools
/conf/extra/static_pools
…………

# 绝对路径
fpm -s dir -t rpm -n nginx -v 1.6.2 /application/nginx-1.6.2/
rpm -qpl nginx-1.6.2-1.x86_64.rpm

/application/nginx-1.6.2/client_body_temp
/application/nginx-1.6.2/conf/extra/dynamic_pools
/application/nginx-1.6.2/conf/extra/static_pools
/application/nginx-1.6.2/conf/fastcgi.conf
/application/nginx-1.6.2/conf/fastcgi.conf.default
…………
```

2. 软链接问题

```bash
fpm -s dir -t rpm -n nginx -v 1.6.2 /application/nginx
no value for epoch is set, defaulting to nil {:level=>:warn}
File already exists, refusing to continue: nginx-1.6.2-1.x86_64.rpm {:level=>:fatal}
# 报错是因为当前目录存在同名的rpm包，可以使用-f参数强制覆盖。

fpm -s dir -t rpm -n nginx -v 1.6.2 -f /application/nginx
no value for epoch is set, defaulting to nil {:level=>:warn}
Force flag given. Overwriting package at nginx-1.6.2-1.x86_64.rpm {:level=>:warn}
no value for epoch is set, defaulting to nil {:level=>:warn}
Created package {:path=>"nginx-1.6.2-1.x86_64.rpm"}

打包看似成功，但查看包的内容，只是这一个软链接文件。
rpm -qpl nginx-1.6.2-1.x86_64.rpm
/application/nginx
原因：目录结尾的/问题，类似rm删除软链接目录
```
