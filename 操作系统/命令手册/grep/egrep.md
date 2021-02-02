# Linux egrep命令

[![Linux 命令大全](https://www.runoob.com/images/up.gif) Linux 命令大全](https://www.runoob.com/linux/linux-command-manual.html)

Linux egrep命令用于在文件内查找指定的字符串。

egrep执行效果与"grep-E"相似，使用的语法及参数可参照grep指令，与grep的不同点在于解读字符串的方法。

egrep是用extended regular expression语法来解读的，而grep则用basic regular  expression 语法解读，extended regular expression比basic regular  expression的表达更规范。

### 语法

```
egrep [范本模式] [文件或目录] 
```

**参数说明：**

- [范本模式] ：查找的字符串规则。
- [文件或目录] ：查找的目标文件或目录。

### 实例

显示文件中符合条件的字符。例如，查找当前目录下所有文件中包含字符串"Linux"的文件，可以使用如下命令：

```
egrep Linux *
```

结果如下所示：

```
$ egrep Linux * #查找当前目录下包含字符串“Linux”的文件  
testfile:hello Linux! #以下五行为testfile 中包含Linux字符的行  
testfile:Linux is a free Unix-type operating system.  
testfile:This is a Linux testfile!  
testfile:Linux  
testfile:Linux  
testfile1:helLinux! #以下两行为testfile1中含Linux字符的行  
testfile1:This a Linux testfile!  
#以下两行为testfile_2 中包含Linux字符的行  
testfile_2:Linux is a free unix-type opterating system.  
testfile_2:Linux test  
xx00:hello Linux! #xx00包含Linux字符的行  
xx01:Linux is a free Unix-type operating system. #以下三行为xx01包含Linux字符的行  
xx01:This is a Linux testfile!  
xx01:Linux 
```