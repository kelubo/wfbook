# Python

行与缩进

python最具特色的就是使用缩进来表示代码块，不需要使用大括号({})。

缩进的空格数是可变的，但是同一个代码块的语句必须包含相同的缩进空格数。实例如下：

if True:
	print ("True")
else:
	print ("False")

以下代码最后一行语句缩进数的空格数不一致，会导致运行错误：

if True:
    print ("Answer")
    print ("True")
else:
    print ("Answer")
  print ("False")    # 缩进不一致，会导致运行错误

以上程序由于缩进不一致，执行后会出现类似以下错误：

 File "test.py", line 6
    print ("False")    # 缩进不一致，会导致运行错误
                                      ^
IndentationError: unindent does not match any outer indentation level

多行语句

Python 通常是一行写完一条语句，但如果语句很长，我们可以使用反斜杠(\)来实现多行语句，例如：

total = item_one + \
        item_two + \
        item_three

在 [], {}, 或 () 中的多行语句，不需要使用反斜杠(\)，例如：

total = ['item_one', 'item_two', 'item_three',
        'item_four', 'item_five']

数据类型

python中数有四种类型：整数、长整数、浮点数和复数。

    整数， 如 1
    长整数 是比较大的整数
    浮点数 如 1.23、3E-2
    复数 如 1 + 2j、 1.1 + 2.2j



空行

函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。

空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构。

记住：空行也是程序代码的一部分。
等待用户输入

执行下面的程序在按回车键后就会等待用户输入：

#!/usr/bin/python3

input("\n\n按下 enter 键后退出。")

以上代码中 ，"\n\n"在结果输出前会输出两个新的空行。一旦用户按下键时，程序将退出。
同一行显示多条语句
Python可以在同一行中使用多条语句，语句之间使用分号(;)分割，以下是一个简单的实例：

#!/usr/bin/python3

import sys; x = 'runoob'; sys.stdout.write(x + '\n')

执行以上代码，输入结果为：

$ python3 test.py
runoob

多个语句构成代码组

缩进相同的一组语句构成一个代码块，我们称之代码组。

像if、while、def和class这样的复合语句，首行以关键字开始，以冒号( : )结束，该行之后的一行或多行代码构成代码组。

我们将首行及后面的代码组称为一个子句(clause)。

如下实例：

if expression :
   suite
elif expression :
   suite
else :
   suite

Print 输出

print 默认输出是换行的，如果要实现不换行需要在变量末尾加上 end=""：

#!/usr/bin/python3

x="a"
y="b"
# 换行输出
print( x )
print( y )

print('---------')
# 不换行输出
print( x, end=" " )
print( y, end=" " )
print()

以上实例执行结果为：

a
b
---------
a b

import 与 from...import

在 python 用 import 或者 from...import 来导入相应的模块。

将整个模块(somemodule)导入，格式为： import somemodule

从某个模块中导入某个函数,格式为： from somemodule import somefunction

从某个模块中导入多个函数,格式为： from somemodule import firstfunc, secondfunc, thirdfunc

将某个模块中的全部函数导入，格式为： from somemodule import *
导入 sys 模块
import sys
print('================Python import mode==========================');
print ('命令行参数为:')
for i in sys.argv:
    print (i)
print ('\n python 路径为',sys.path)
导入 sys 模块的 argv,path 成员
from sys import argv,path  #  导入特定的成员

print('================python from import===================================')
print('path:',path) # 因为已经导入path成员，所以此处引用时不需要加sys.path
命令行参数

很多程序可以执行一些操作来查看一些基本信，Python可以使用-h参数查看各参数帮助信息：

$ python -h
usage: python [option] ... [-c cmd | -m mod | file | -] [arg] ...
Options and arguments (and corresponding environment variables):
-c cmd : program passed in as string (terminates option list)
-d     : debug output from parser (also PYTHONDEBUG=x)
-E     : ignore environment variables (such as PYTHONPATH)
-h     : print this help message and exit

[ etc. ]

我们在使用脚本形式执行 Python 时，可以接收命令行输入的参数，具体使用可以参照 Python 3 命令行参数。
Python3 教程
Python3 基本数据类型
笔记列表

       淡然感世
    
      107***5530@qq.com
    
    在 Windows 下可以不写第一行注释:
    
    #!/usr/bin/python3
    
    第一行注释标的是指向 python 的路径，告诉操作系统执行这个脚本的时候，调用 /usr/bin 下的 python 解释器。
    
    此外还有以下形式（推荐写法）：
    
    #!/usr/bin/env python3
    
    这种用法先在 env（环境变量）设置里查找 python 的安装路径，再调用对应路径下的解释器程序完成操作。
    淡然感世
    
       淡然感世
    
      107***5530@qq.com
    5个月前 (04-09)
    
       荆棘乱
    
      llc***n@gmail.com
    
    关于注释，也可以使用 ''' ''' 的格式在三引号之间书写较长的注释；
    
    ''' ''' 还可以用于在函数的首部对函数进行一个说明：
    
    def example(anything):
        '''形参为任意类型的对象，
           这个示例函数会将其原样返回。
        '''
        return anything
    
    help() 函数
    
    调用 python 的 help() 函数可以打印输出一个函数的文档字符串：
    
    # 如下实例，查看 max 内置函数的参数列表和规范的文档
    >>> help(max)
    ……显示帮助信息……
    
    按下 : q 两个按键即退出说明文档
    
    如果仅仅想得到文档字符串：
    
    >>> print(max.__doc__)    # 注意，doc的前后分别是两个下划线
    max(iterable, *[, default=obj, key=func]) -> value
    max(arg1, arg2, *args, *[, key=func]) -> value
    
    With a single iterable argument, return its biggest item. The
    default keyword-only argument specifies an object to return if
    the provided iterable is empty.
    With two or more arguments, return the largest argument

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

## Python 编码

默认的编码格式是 ASCII 格式。  
要支持UTF-8，在文件开头加入 `# -*- coding: UTF-8 -*- `或者` #coding=utf-8 `。  

默认情况下，Python 3 源码文件以 UTF-8 编码，所有字符串都是 unicode 字符串。 可以为源码文件指定不同的编码：

    # -*- coding: cp-1252 -*-

## Python 标识符

标识符由字母、数字、下划线组成，不能以数字开头，区分大小写，不能包含空格。在Python 3中，非-ASCII 标识符也是允许的。慎用小写字母l和大写字母O。

以下划线开头的标识符是有特殊意义的。以单下划线开头（`_foo`）的代表不能直接访问的类属性，需通过类提供的接口进行访问，不能用`from xxx import *`而导入。 

以双下划线开头的（`__foo`）代表类的私有成员；以双下划线开头和结尾的（`__foo__`）代表python里特殊方法专用的标识，如__init__（）代表类的构造函数。

Python保留字符

Python 的标准库提供了一个 keyword 模块，可以输出当前版本的所有关键字：

    >>> import keyword
    >>> keyword.kwlist
    ['False', 'None', 'True', 'and', 'as', 'assert', 'break', 'class', 'continue', \
     'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', \
     'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', \
     'raise', 'return', 'try', 'while', 'with', 'yield']

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

要取得一段子串，可以用到 **变量[头下标:尾下标]** ，就可以截取相应的字符串，其中下标是从0开始算起，可以是正数或负数，下标可以为空表示取到头或尾。

加号（+）是字符串连接运算符，星号（`*`）是重复操作。

**方法：**

```python
title()      单词首字母大写
upper()      字母转为大写
lower()      字母转为小写
lstrip()     删除头部空白
rstrip()     删除末尾空白
strip()      删除两端空白
```

python中单引号和双引号使用完全相同。
使用三引号('''或""")可以指定一个多行字符串。
转义符 `\`
自然字符串， 通过在字符串前加r或R。 如 r"this is a line with \n" 则\n会显示，并不是换行。
python允许处理unicode字符串，加前缀u或U， 如 u"this is an unicode string"。
字符串是不可变的。
按字面意义级联字符串，如"this " "is " "string"会被自动转换为this is string。

eg:
word = '字符串'
sentence = "这是一个句子。"
paragraph = """这是一个段落，
可以由多行组成"""

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
