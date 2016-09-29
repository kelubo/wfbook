# Python

## 安装

### Debian Linux

    $ sudo apt install python

### Gentoo Linux

    $ emerge python

## 运行Python

1、交互式解释器：

通过命令行窗口进入python并开在交互式解释器中开始编写Python代码。

Python命令行参数：

    选项	描述
    -d	在解析时显示调试信息
    -O	生成优化代码 ( .pyo 文件 )
    -S	启动时不引入查找Python路径的位置
    -V	输出Python版本号
    -X	从 1.6版本之后基于内建的异常（仅仅用于字符串）已过时。
    -c cmd	执行 Python 脚本，并将运行结果作为 cmd 字符串。
    file	在给定的python文件执行python脚本。

2、命令行脚本

## 集成开发环境

| IDE             | URL                             |
|-----------------|---------------------------------|
| IDLE            | www.python.org/idle             |
| PythonWin       | www.python.org/download/windows |
| ActivePython    | www.activepython.com            |
| Komodo          | www.activepython.com            |
| Wingware        | www.wingware.com                |
| BlackAdder      | www.thekompany.com              |
| Boa Constructor | boa-constructor.sf.net          |
| Anjuta          | anjuta.sf.net                   |
| Arachno Python  | www.python-ide.com              |
| Code Crusader   | www.newplanetsoftware.com       |
| Code Forge      | www.codeforge.com               |
| Eclipse         | www.eclipse.org                 |
| eric            | eric-ied.sf.net                 |
| KDevelop        | www.kedvelop.org                |
| VisualWx        | visualwx.altervista.org         |
| wxDesigner      | www.roebling.de                 |
| wxGlade         | wxglade.sf.net                  |

## Python 中文编码

默认的编码格式是 ASCII 格式。  
要支持UTF-8，在文件开头加入 `# -*- coding: UTF-8 -*- `或者` #coding=utf-8 `就行了。  
Python3.X 源码文件默认使用utf-8编码，可以正常解析中文，无需指定 UTF-8 编码。

## Python 标识符

标识符有字母、数字、下划线组成，不能以数字开头，区分大小写。  
以下划线开头的标识符是有特殊意义的。以单下划线开头（`_foo`）的代表不能直接访问的类属性，需通过类提供的接口进行访问，不能用`from xxx import *`而导入。  
以双下划线开头的（`__foo`）代表类的私有成员；以双下划线开头和结尾的（`__foo__`）代表python里特殊方法专用的标识，如__init__（）代表类的构造函数。

Python保留字符

|     1    |    2    |    3   |
|----------|---------|--------|
| and      | exec	   | not    |
| assert   | finally | or     |
| break    | for  	 | pass   |
| class	   | from    | print  |
| continue | global  | raise  |
| def      | if	     | return |
| del      | import  | try    |
| elif     | in	     | while  |
| else	   | is	     | with   |
| except   | lambda  | yield  |

## 行和缩进

在每个缩进层次使用 单个制表符 或 两个空格 或 四个空格，不能混用。  
可以使用斜杠（ \）将一行的语句分为多行显示，如下所示：

    total = item_one + \
            item_two + \
            item_three

语句中包含[], {} 或 () 括号就不需要使用多行连接符。如下实例：

    days = ['Monday', 'Tuesday', 'Wednesday',
            'Thursday', 'Friday']

## Python 引号

Python 接收单引号(' )，双引号(" )，三引号(''' """) 来表示字符串，引号的开始与结束必须的相同类型的。  
三引号可以由多行组成，编写多行文本的快捷语法，常用语文档字符串，在文件的特定地点，被当做注释。

## Python注释

单行注释采用 # 开头。  
多行注释使用三个单引号(''')或三个双引号(""")。

## Python空行

函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。  
空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构。

## 等待用户输入

优先使用raw_input

    raw_input("\n\nPress the enter key to exit.")
    input("\n\nPress the enter key to exit.")

## 同一行显示多条语句
在同一行中使用多条语句，语句之间使用分号(;)分割。

## 代码组

缩进相同的一组语句构成一个代码块，称之代码组。

## 命令行参数

使用-h参数查看各参数帮助信息：

    $ python -h
    usage: python [option] ... [-c cmd | -m mod | file | -] [arg] ...
    Options and arguments (and corresponding environment variables):
    -c cmd : program passed in as string (terminates option list)
    -d     : debug output from parser (also PYTHONDEBUG=x)
    -E     : ignore environment variables (such as PYTHONPATH)
    -h     : print this help message and exit

## Python 变量类型

五个标准的数据类型：

    Numbers（数字）
    String（字符串）
    List（列表）
    Tuple（元组）
    Dictionary（字典）

### 数字

不可改变的数据类型，意味着改变数字数据类型会分配一个新的对象。  
可以使用del语句删除一些对象的引用。

    del var1[,var2[,var3[....,varN]]]]

支持四种不同的数字类型：

    int（有符号整型）
    long（长整型[也可以代表八进制和十六进制]）
    float（浮点型）
    complex（复数）

使用"L"来显示长整型。  
复数由实数部分和虚数部分构成，可以用a + bj,或者complex(a,b)表示， 复数的实部a和虚部b都是浮点型。  
十六进制　0x  
八进制   0

### 字符串

字符串或串(String)是由数字、字母、下划线组成的一串字符。

字串列表有2种取值顺序:

    从左到右索引默认0开始的，最大范围是字符串长度少1
    从右到左索引默认-1开始的，最大范围是字符串开头

要取得一段子串，可以用到变量[头下标:尾下标]，就可以截取相应的字符串，其中下标是从0开始算起，可以是正数或负数，下标可以为空表示取到头或尾。

加号（+）是字符串连接运算符，星号（`*`）是重复操作。

### 列表

列表用[ ]标识。

列表中的值得分割用到变量[头下标:尾下标]，就可以截取相应的列表，从左到右索引默认0开始的，从右到左索引默认-1开始，下标可以为空表示取到头或尾。

加号（+）是列表连接运算符，星号（`*`）是重复操作。

### 元组

元组用"()"标识。内部元素用逗号隔开。元组不能二次赋值，相当于只读列表。

### 元字典

字典是无序的对象集合。

区别在于：字典当中的元素是通过键来存取的，而不是通过偏移存取。

字典用"{ }"标识。字典由索引(key)和它对应的值value组成。

### 数据类型转换

| 函数                   | 描述                                          |
|-----------------------|----------------------------------------------|
| int(x [,base])        | 将x转换为一个整数                               |
| long(x [,base] )      | 将x转换为一个长整数                             |
| float(x)              | 将x转换到一个浮点数                             |
| complex(real [,imag]) | 创建一个复数                                   |
| str(x)                | 将对象 x 转换为字符串                           |
| repr(x)               | 将对象 x 转换为表达式字符串                      |
| eval(str)             | 用来计算在字符串中的有效Python表达式,并返回一个对象 |
| tuple(s)              | 将序列 s 转换为一个元组                         |
| list(s)               | 将序列 s 转换为一个列表                         |
| set(s)                | 转换为可变集合                                 |
| dict(d)               | 创建一个字典。d 必须是一个序列 (key,value)元组    |
| frozenset(s)          | 转换为不可变集合                               |
| chr(x)                | 将一个整数转换为一个字符                         |
| unichr(x)             | 将一个整数转换为Unicode字符                     |
| ord(x)                | 将一个字符转换为它的整数值                       |
| hex(x)                | 将一个整数转换为一个十六进制字符串                |
| oct(x)                | 将一个整数转换为一个八进制字符串                  |

## 发行版

    ActivePython
    Stackless Python
    Jython
    IronPython

## 除法

    /     整除

### 使用普通除法

    from _future_ import division
    或者命令行开关
    -Qnew
    整除符号变为 //

## 模块

## 未来新特征

    _future_

##
