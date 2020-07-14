# Go 语言开发工具

## GoLand

Jetbrains 家族的 Go 语言 IDE，有 30 天的免费试用期。

支持的操作系统：Mac、Linux、Windows 

下载页面 https://www.jetbrains.com/go/

![img](../../Image/g/o/GoLand.jpg)

## LiteIDE

一款开源、跨平台的轻量级 Go 语言集成开发环境（IDE）。

支持的 操作系统

- Windows x86 (32-bit or 64-bit)
- Linux x86 (32-bit or 64-bit)

下载地址 ：http://sourceforge.net/projects/liteide/files/

源码地址 ：https://github.com/visualfc/liteide

![img](../../Image/l/i/liteide.png)

## Eclipse



![1.4.eclipse1](../../Image/e/c/eclipse1.png)

1. 下载 [goclipse](http://goclipse.github.io/) 插件 https://github.com/GoClipse/goclipse/blob/latest/documentation/Installation.md#installation

3. 下载 gocode，用于 go 的代码补全提示

   gocode 的 github 地址：

   ```http
   https://github.com/nsf/gocode
   ```

   再在 cmd 下安装：

   ```bash
go get -u github.com/nsf/gocode
   ```
   
   也可以下载代码，直接用 go build 来编译，会生成 gocode.exe

4. 下载 [MinGW](http://sourceforge.net/projects/mingw/files/MinGW/) 并按要求装好

5. 配置插件

   Windows->Reference->Go

   (1)、配置 Go 的编译器

   ![](../../Image/e/c/eclipse2.png)

   设置 Go 的一些基础信息

   (2)、配置 Gocode（可选，代码补全），设置 Gocode 路径为之前生成的 gocode.exe 文件

   ![](../../Image/e/c/eclipse3.png)

   设置 gocode 信息

   (3)、配置 GDB（可选，做调试用），设置 GDB 路径为 MingW 安装目录下的 gdb.exe 文件

   ![](../../Image/e/c/eclipse4.png)

   设置 GDB 信息

6. 测试是否成功

   新建一个 go 工程，再建立一个 hello.go。如下图：

   ![](../../Image/e/c/eclipse5.png)

   新建项目编辑文件

   调试如下（要在 console 中用输入命令来调试）：

   ![](../../Image/e/c/eclipse6.png)

   图 1.16 调试 Go 程序

## Sublime Text

## GoClipse

## Visual Studio Code