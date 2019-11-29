# Gradle

打包 Android Studio 项目生成 apk 文件，以 CentOS 7 为例。

## 配置 Java

**下载 jdk** 
 jdk-8u231-linux-x64.rpm到本地

**安装**

```bash
yum install ./jdk-8u231-linux-x64.rpm
```

确认

```bash
java -version
```

## 配置Gradle  

**下载**
 下载地址https://gradle.org/releases 
 Gradle Distribution地址http://services.gradle.org/distributions 
**解压**

```bash
unzip gradle-4.1-all.zip
mv gradle-4.1 gradle && mv gradle /opt/
```

**环境变量配置**

```bash
vim /etc/profile  #打开配置文件
export GRADLE_HOME=/opt/gradle       #添加的内容
export PATH=$GRADLE_HOME/bin:$PATH   #添加的内容
```

运行命令 source /etc/profile 使环境变量生效. 
**验证** 

```bash
gradle -v
```

![这里写图片描述](https://img-blog.csdn.net/20180828141938112?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIxNjI1MDM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 配置Android SDK
**下载Android文件** 
**解压**

```bash
unzip sdk.zip
```

**配置文件**

```bash
vim /etc/profile
export ANDROID_SDK_HOME=/home/lcw/android_develop_tools/sdk  
export PATH=$PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools
```

运行命令 source /etc/profile 使环境变量生效. 
**验证**

```bash
android
```

没有报错就说明配置好了。

## 配合项目输出apk安装包 
项目配置签名信息 
 ![这里写图片描述](https://img-blog.csdn.net/20180828143141980?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIxNjI1MDM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 
 ![这里写图片描述](https://img-blog.csdn.net/20180828143237760?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTIxNjI1MDM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70) 
 确保项目里能看到，就基本配置完成。 
 项目上传到云服务器 
 首先cd到项目路径下 
 然后执行gradle assembleRelease  完成打包命令 
 出现success 说明完成 
 3.查看apk项目输出 
 项目名/app/build/outputs/apk/release/app-release.apk