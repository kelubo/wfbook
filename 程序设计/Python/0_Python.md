# Python

[TOC]

## 概述

Python 是一个高层次的结合了解释性、编译性、互动性和面向对象的脚本语言。

Python 是一种高级编程语言，支持多种编程模式，如面向对象、所需功能以及程序式范式。Python 具有动态语义，可用于通用编程。

Python 是一门易于学习、功能强大的编程语言。它提供了高效的高级数据结构，还能简单有效地面向对象编程。Python 优雅的语法和动态类型以及解释型语言的本质，使它成为多数平台上写脚本和快速开发应用的理想语言。

创始人 Guido van Rossum。拥有者是 Python Software Foundation (PSF)，非盈利组织，致力于保护 Python 语言开放、开源和发展。

Python 官网（https://www.python.org/）上免费提供了 Python 解释器和扩展的标准库，包括源码和适用于各操作系统的机器码形式，并可自由地分发。Python 官网还包含许多免费的第三方 Python 模块、程序和工具发布包及文档链接。

Python 解释器易于扩展，使用 C 或 C++（或其他 C 能调用的语言）即可为 Python 扩展新功能和数据类型。Python 也可用作定制软件中的扩展程序语言。

Python 的 3.0 版本，常被称为 Python 3000，或简称 Py3k。相对于 Python 的早期版本，这是一个较大的升级。为了不带入过多的累赘，Python 3.0 在设计的时候没有考虑向下兼容。

Python 的设计具有很强的可读性，相比其他语言经常使用英文关键字，其他语言的一些标点符号，它具有比其他语言更有特色语法结构。

- **Python 是一种解释型语言**

  这意味着开发过程中没有了编译这个环节。类似于 PHP 和 Perl 语言。

- **Python 是交互式语言**

  这意味着，您可以在一个 Python 提示符 >>> 后直接执行代码。

- **Python 是面向对象语言**

  这意味着 Python 支持面向对象的风格或代码封装在对象的编程技术。

- **Python 是初学者的语言**

  Python 对初级程序员而言，是一种伟大的语言，它支持广泛的应用程序开发，从简单的文字处理到 WWW 浏览器再到游戏。 	

Python 是一种解释型语言，不需要编译和链接，可以节省大量开发时间。它的解释器实现了交互式操作，轻而易举地就能试用各种语言功能，编写临时程序，或在自底向上的程序开发中测试功能。同时，它还是一个超好用的计算器。

Python 程序简洁、易读，通常比实现同种功能的 C、C++、Java 代码短很多，原因如下：

- 高级数据类型允许在单一语句中表述复杂操作；
- 使用缩进，而不是括号实现代码块分组；
- 无需预声明变量或参数。

Python “可以扩展”：会开发 C 语言程序，就能快速上手为解释器增加新的内置函数或模块，不论是让核心程序以最高速度运行，还是把  Python 程序链接到只提供预编译程序的库（比如，硬件图形库）。只要下点功夫，就能把 Python 解释器和用 C  开发的应用链接在一起，用它来扩展和控制该应用。

顺便提一句，本语言的命名源自 BBC 的 “Monty Python 飞行马戏团”，与爬行动物无关（Python 原义为“蟒蛇”）。

## Python 版本

**Python 3.9** 是 RHEL 9 中的默认 **Python** 实现。**Python 3.9** 在 BaseOS 存储库中的非模块化 `python3` RPM 软件包中分发，通常默认安装。**Python 3.9** 将支持 RHEL 9 的整个生命周期。

其他版本的 **Python 3** 作为非模块化 RPM 软件包发布，且在一个次版本的 RHEL 9 版本中通过 AppStream 软件仓库提供较短的生命周期。您可以与 Python 3.9 并行安装这些额外的 **Python 3** 版本。

**Python 2** 不随 RHEL 9 提供。

| Version         | 要安装的软件包 | 命令示例                | 此后提供 | 生命周期      |
| --------------- | -------------- | ----------------------- | -------- | ------------- |
| **Python 3.9**  | `python3`      | `python3`, `pip3`       | RHEL 9.0 | 完整的 RHEL 9 |
| **Python 3.11** | `python3.11`   | `python3.11`, `pip3.11` | RHEL 9.2 | 较短          |

## 自 RHEL 8 开始的 Python 生态系统的主要区别

本节总结了 RHEL 9 中 Python 生态系统与 RHEL 8 相比的显著变化。 		

**unversioned `python` 命令**

​					`python` 命令的未指定版本形式(`/usr/bin/python`)在 `python-unversioned-command` 软件包中提供。在某些系统中，默认情况下不安装此软件包。要手动安装 `python` 命令的未指定版本形式，请使用 `dnf install /usr/bin/python` 命令。 			

​				在 RHEL 9 中，`python` 命令的未指定版本形式指向默认的 **Python 3.9** 版本，它相当于 `python3` 和 `python3.9` 命令。在 RHEL 9 中，无法将未指定版本的命令配置为指向与 **Python 3.9** 不同的版本。 		

​				`python` 命令用于交互式会话。在生产环境中，建议明确使用 `python3、` `python3.9` 或 `python3.11`。 		

​				您可以使用 `dnf remove /usr/bin/python` 命令卸载未指定版本的 `python` 命令。 		

​				如果需要不同的 python 命令，您可以在 `/usr/local/bin` 或 `~/.local/bin` 中创建自定义符号链接。 		

​				还有其他未指定版本的命令，如 `python3- pip 软件包中的 /usr/bin/ pip`。在 RHEL 9 中，所有未指定版本的命令都指向默认的 **Python 3.9** 版本。 		

**特定于架构的 Python `wheels`**

​					在 RHEL 9 上 构建的特定于体系结构的 Python `wheel` 新建了上游架构命名，允许客户在 RHEL 9 上构建其 Python `wheel` 并在非 RHEL 系统中安装它们。在以前的 RHEL 版本构建的 Python `wheel` 与更新的版本兼容，可以在 RHEL 9 上安装。请注意，这仅影响包含 Python 扩展的 `wheel`，这些扩展针对每个架构构建，而不影响包含纯 Python 代码的 Python `wheels`，这不是特定于架构的 Python wheel。 			

## Python 解释器

### 调用解释器

Python 解释器通常以 `/usr/local/bin/python3.11` 的形式安装在可用的机器上；将 `/usr/local/bin` 放在 Unix shell 的搜索路径中，可以通过键入以下命令启动它：

```bash
python3.11
# Unix 系统中，为了不与同时安装的 Python 2.x 冲突，Python 3.x 解释器默认安装的执行文件名不是 python 。
```

> 备注：
>
> Unix 系统中，为了不与同时安装的 Python 2.x 冲突，Python 3.x 解释器默认安装的执行文件名不是 `python`。

在主提示符中，输入文件结束符（Unix 里是 Control-D，Windows 里是 Control-Z），就会退出解释器，退出状态码为 0。如果不能退出，还可以输入这个命令：`quit()`。

在支持 [GNU Readline](https://tiswww.case.edu/php/chet/readline/rltop.html) 库的系统中，解释器的行编辑功能包括交互式编辑、历史替换、代码补全等。检测是否支持命令行编辑最快速的方式是，在首次出现 Python 提示符时，输入 Control-P。听到“哔”提示音，说明支持行编辑。如果没有反应，或回显了 `^P`，则说明不支持行编辑；只能用退格键删除当前行的字符。

解释器的操作方式类似 Unix Shell：用与 tty 设备关联的标准输入调用时，可以交互式地读取和执行命令；以文件名参数，或标准输入文件调用时，则读取并执行文件中的 *脚本*。

启动解释器的第二种方法是 `python -c command [arg] ...` ，它执行命令中的语句，类似于 shell 的 `-c` 选项。由于 Python 语句通常包含空格或其他shell特有的字符，因此通常建议用单引号完整引用命令。

Python 模块也可以当作脚本使用。输入：`python -m module [arg] ...`，会执行 *module* 的源文件，这跟在命令行把路径写全了一样。

在交互模式下运行脚本文件，只要在脚本名称参数前，加上选项 `-i` 就可以了。

### 传入参数

解释器读取命令行参数，把脚本名与其他参数转化为字符串列表存到 `sys` 模块的 `argv` 变量里。执行 `import sys`，可以导入这个模块，并访问该列表。该列表最少有一个元素；未给定输入参数时，`sys.argv[0]` 是空字符串。给定脚本名是 `'-'` （标准输入）时，`sys.argv[0]` 是 `'-'`。使用 [`-c`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-c) *command* 时，`sys.argv[0]` 是 `'-c'`。如果使用选项 [`-m`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-m) *module*，`sys.argv[0]` 就是包含目录的模块全名。解释器不处理 [`-c`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-c) *command* 或 [`-m`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-m) *module* 之后的选项，而是直接留在 `sys.argv` 中由命令或模块来处理。

### 交互模式

在终端（tty）输入并执行指令时，解释器在 *交互模式（interactive mode）* 中运行。在这种模式中，会显示 *主提示符*，提示输入下一条指令，主提示符通常用三个大于号（`>>>`）表示；输入连续行时，显示 *次要提示符*，默认是三个点（`...`）。进入解释器时，首先显示欢迎信息、版本信息、版权声明，然后才是提示符：

```python
python3.11
Python 3.11 (default, April 4 2021, 09:25:04)
[GCC 10.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

输入多行架构的语句时，要用连续行。以 [`if`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#if) 为例：

```python
>>> the_world_is_flat = True
>>> if the_world_is_flat:
...    print("Be careful not to fall off!")
...
Be careful not to fall off!
```

### 源文件的字符编码

默认情况下，Python 源码文件的编码是 UTF-8。这种编码支持世界上大多数语言的字符，可以用于字符串字面值、变量、函数名及注释 —— 尽管标准库只用常规的 ASCII 字符作为变量名或函数名，可移植代码都应遵守此约定。要正确显示这些字符，编辑器必须能识别 UTF-8  编码，而且必须使用支持文件中所有字符的字体。

如果不使用默认编码，则要声明文件的编码，文件的 *第一* 行要写成特殊注释。句法如下：

```python
# -*- coding: encoding -*-
```

其中，*encoding* 可以是 Python 支持的任意一种 [`codecs`](https://docs.python.org/zh-cn/3.11/library/codecs.html#module-codecs)。

比如，声明使用 Windows-1252 编码，源码文件要写成：

```python
# -*- coding: cp1252 -*-
```

*第一行* 的规则也有一种例外情况，源码以 [UNIX "shebang" 行](https://docs.python.org/zh-cn/3.11/tutorial/appendix.html#tut-scripts) 开头。此时，编码声明要写在文件的第二行。例如：

```python
#!/usr/bin/env python3
# -*- coding: cp1252 -*-
```

## 注释

Python 注释以 `#` 开头，直到该物理行结束。注释可以在行开头，或空白符与代码之后，但不能在字符串里面。字符串中的 # 号就是 # 号。注释用于阐明代码，Python 不解释注释，键入例子时，可以不输入注释。

示例如下：

```python
# this is the first comment
spam = 1  # and this is the second comment
          # ... and now a third!
text = "# This is not a comment because it's inside quotes."
```

## Python 用作计算器

### 数字

解释器像一个简单的计算器：输入表达式，就会给出答案。表达式的语法很直接：运算符 `+`、`-`、`*`、`/` 的用法和其他大部分语言一样（比如，Pascal 或 C）；括号 (`()`) 用来分组。例如：

\>>>

```

2 + 2
4
50 - 5*6
20
(50 - 5*6) / 4
5.0
8 / 5  # division always returns a floating point number
1.6
```

整数（如，`2`、`4`、`20` ）的类型是 [`int`](https://docs.python.org/zh-cn/3.11/library/functions.html#int)，带小数（如，`5.0`、`1.6` ）的类型是 [`float`](https://docs.python.org/zh-cn/3.11/library/functions.html#float)。本教程后半部分将介绍更多数字类型。

Division (`/`) always returns a float.  To do [floor division](https://docs.python.org/zh-cn/3.11/glossary.html#term-floor-division) and get an integer result you can use the `//` operator; to calculate the remainder you can use `%`:

\>>>

```

17 / 3  # classic division returns a float
5.666666666666667
>>>
17 // 3  # floor division discards the fractional part
5
17 % 3  # the % operator returns the remainder of the division
2
5 * 3 + 2  # floored quotient * divisor + remainder
17
```

Python 用 `**` 运算符计算乘方 [1](https://docs.python.org/zh-cn/3.11/tutorial/introduction.html#id3)：

\>>>

```

5 ** 2  # 5 squared
25
2 ** 7  # 2 to the power of 7
128
```

等号（`=`）用于给变量赋值。赋值后，下一个交互提示符的位置不显示任何结果：

\>>>

```

width = 20
height = 5 * 9
width * height
900
```

如果变量未定义（即，未赋值），使用该变量会提示错误：

\>>>

```

n  # try to access an undefined variable
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'n' is not defined
```

Python 全面支持浮点数；混合类型运算数的运算会把整数转换为浮点数：

\>>>

```

4 * 3.75 - 1
14.0
```

交互模式下，上次输出的表达式会赋给变量 `_`。把 Python 当作计算器时，用该变量实现下一步计算更简单，例如：

\>>>

```

tax = 12.5 / 100
price = 100.50
price * tax
12.5625
price + _
113.0625
round(_, 2)
113.06
```

最好把该变量当作只读类型。不要为它显式赋值，否则会创建一个同名独立局部变量，该变量会用它的魔法行为屏蔽内置变量。

除了 [`int`](https://docs.python.org/zh-cn/3.11/library/functions.html#int) 和 [`float`](https://docs.python.org/zh-cn/3.11/library/functions.html#float)，Python 还支持其他数字类型，例如 [`Decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#decimal.Decimal) 或 [`Fraction`](https://docs.python.org/zh-cn/3.11/library/fractions.html#fractions.Fraction)。Python 还内置支持 [复数](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#typesnumeric)，后缀 `j` 或 `J` 用于表示虚数（例如 `3+5j` ）。



### 3.1.2. 字符串

除了数字，Python 还可以操作字符串。字符串有多种表现形式，用单引号（`'……'`）或双引号（`"……"`）标注的结果相同 [2](https://docs.python.org/zh-cn/3.11/tutorial/introduction.html#id4)。反斜杠 `\` 用于转义：

\>>>

```

'spam eggs'  # single quotes
'spam eggs'
'doesn\'t'  # use \' to escape the single quote...
"doesn't"
"doesn't"  # ...or use double quotes instead
"doesn't"
'"Yes," they said.'
'"Yes," they said.'
"\"Yes,\" they said."
'"Yes," they said.'
'"Isn\'t," they said.'
'"Isn\'t," they said.'
```

交互式解释器会为输出的字符串加注引号，特殊字符使用反斜杠转义。虽然，有时输出的字符串看起来与输入的字符串不一样（外加的引号可能会改变），但两个字符串是相同的。如果字符串中有单引号而没有双引号，该字符串外将加注双引号，反之，则加注单引号。[`print()`](https://docs.python.org/zh-cn/3.11/library/functions.html#print) 函数输出的内容更简洁易读，它会省略两边的引号，并输出转义后的特殊字符：

\>>>

```

'"Isn\'t," they said.'
'"Isn\'t," they said.'
print('"Isn\'t," they said.')
"Isn't," they said.
s = 'First line.\nSecond line.'  # \n means newline
s  # without print(), \n is included in the output
'First line.\nSecond line.'
print(s)  # with print(), \n produces a new line
First line.
Second line.
```

如果不希望前置 `\` 的字符转义成特殊字符，可以使用 *原始字符串*，在引号前添加 `r` 即可：

\>>>

```

print('C:\some\name')  # here \n means newline!
C:\some
ame
print(r'C:\some\name')  # note the r before the quote
C:\some\name
```

There is one subtle aspect to raw strings: a raw string may not end in an odd number of `\` characters; see [the FAQ entry](https://docs.python.org/zh-cn/3.11/faq/programming.html#faq-programming-raw-string-backslash) for more information and workarounds.

字符串字面值可以包含多行。 一种实现方式是使用三重引号：`"""..."""` 或 `'''...'''`。 字符串中将自动包括行结束符，但也可以在换行的地方添加一个 `\` 来避免此情况。 参见以下示例：

```
print("""\
Usage: thingy [OPTIONS]
     -h                        Display this usage message
     -H hostname               Hostname to connect to
""")
```

输出如下（请注意开始的换行符没有被包括在内）：

```
Usage: thingy [OPTIONS]
     -h                        Display this usage message
     -H hostname               Hostname to connect to
```

字符串可以用 `+` 合并（粘到一起），也可以用 `*` 重复：

\>>>

```

# 3 times 'un', followed by 'ium'
3 * 'un' + 'ium'
'unununium'
```

相邻的两个或多个 *字符串字面值* （引号标注的字符）会自动合并：

\>>>

```

'Py' 'thon'
'Python'
```

拼接分隔开的长字符串时，这个功能特别实用：

\>>>

```

text = ('Put several strings within parentheses '
        'to have them joined together.')
text
'Put several strings within parentheses to have them joined together.'
```

这项功能只能用于两个字面值，不能用于变量或表达式：

\>>>

```

prefix = 'Py'
prefix 'thon'  # can't concatenate a variable and a string literal
  File "<stdin>", line 1
    prefix 'thon'
           ^^^^^^
SyntaxError: invalid syntax
('un' * 3) 'ium'
  File "<stdin>", line 1
    ('un' * 3) 'ium'
               ^^^^^
SyntaxError: invalid syntax
```

合并多个变量，或合并变量与字面值，要用 `+`：

\>>>

```

prefix + 'thon'
'Python'
```

字符串支持 *索引* （下标访问），第一个字符的索引是 0。单字符没有专用的类型，就是长度为一的字符串：

\>>>

```

word = 'Python'
word[0]  # character in position 0
'P'
word[5]  # character in position 5
'n'
```

索引还支持负数，用负数索引时，从右边开始计数：

\>>>

```

word[-1]  # last character
'n'
word[-2]  # second-last character
'o'
word[-6]
'P'
```

注意，-0 和 0 一样，因此，负数索引从 -1 开始。

除了索引，字符串还支持 *切片*。索引可以提取单个字符，*切片* 则提取子字符串：

\>>>

```

word[0:2]  # characters from position 0 (included) to 2 (excluded)
'Py'
word[2:5]  # characters from position 2 (included) to 5 (excluded)
'tho'
```

切片索引的默认值很有用；省略开始索引时，默认值为 0，省略结束索引时，默认为到字符串的结尾：

\>>>

```

word[:2]   # character from the beginning to position 2 (excluded)
'Py'
word[4:]   # characters from position 4 (included) to the end
'on'
word[-2:]  # characters from the second-last (included) to the end
'on'
```

注意，输出结果包含切片开始，但不包含切片结束。因此，`s[:i] + s[i:]` 总是等于 `s`：

\>>>

```

word[:2] + word[2:]
'Python'
word[:4] + word[4:]
'Python'
```

还可以这样理解切片，索引指向的是字符 *之间* ，第一个字符的左侧标为 0，最后一个字符的右侧标为 *n* ，*n* 是字符串长度。例如：

```
 +---+---+---+---+---+---+
 | P | y | t | h | o | n |
 +---+---+---+---+---+---+
 0   1   2   3   4   5   6
-6  -5  -4  -3  -2  -1
```

第一行数字是字符串中索引 0...6 的位置，第二行数字是对应的负数索引位置。*i* 到 *j* 的切片由 *i* 和 *j* 之间所有对应的字符组成。

对于使用非负索引的切片，如果两个索引都不越界，切片长度就是起止索引之差。例如， `word[1:3]` 的长度是 2。

索引越界会报错：

\>>>

```

word[42]  # the word only has 6 characters
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
IndexError: string index out of range
```

但是，切片会自动处理越界索引：

\>>>

```

word[4:42]
'on'
word[42:]
''
```

Python 字符串不能修改，是  [immutable](https://docs.python.org/zh-cn/3.11/glossary.html#term-immutable) 的。因此，为字符串中某个索引位置赋值会报错：

\>>>

```

word[0] = 'J'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'str' object does not support item assignment
word[2:] = 'py'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'str' object does not support item assignment
```

要生成不同的字符串，应新建一个字符串：

\>>>

```

'J' + word[1:]
'Jython'
word[:2] + 'py'
'Pypy'
```

内置函数 [`len()`](https://docs.python.org/zh-cn/3.11/library/functions.html#len) 返回字符串的长度：

\>>>

```

s = 'supercalifragilisticexpialidocious'
len(s)
34
```

参见

- [文本序列类型 --- str](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#textseq)

  字符串是 *序列类型* ，支持序列类型的各种操作。

- [字符串的方法](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#string-methods)

  字符串支持很多变形与查找方法。

- [格式字符串字面值](https://docs.python.org/zh-cn/3.11/reference/lexical_analysis.html#f-strings)

  内嵌表达式的字符串字面值。

- [格式字符串语法](https://docs.python.org/zh-cn/3.11/library/string.html#formatstrings)

  使用 [`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 格式化字符串。

- [printf 风格的字符串格式化](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#old-string-formatting)

  这里详述了用 `%` 运算符格式化字符串的操作。



### 3.1.3. 列表

Python 支持多种 *复合* 数据类型，可将不同值组合在一起。最常用的 *列表* ，是用方括号标注，逗号分隔的一组值。*列表* 可以包含不同类型的元素，但一般情况下，各个元素的类型相同：

\>>>

```

squares = [1, 4, 9, 16, 25]
squares
[1, 4, 9, 16, 25]
```

和字符串（及其他内置 [sequence](https://docs.python.org/zh-cn/3.11/glossary.html#term-sequence) 类型）一样，列表也支持索引和切片：

\>>>

```

squares[0]  # indexing returns the item
1
squares[-1]
25
squares[-3:]  # slicing returns a new list
[9, 16, 25]
```

切片操作返回包含请求元素的新列表。以下切片操作会返回列表的 [浅拷贝](https://docs.python.org/zh-cn/3.11/library/copy.html#shallow-vs-deep-copy)：

\>>>

```

squares[:]
[1, 4, 9, 16, 25]
```

列表还支持合并操作：

\>>>

```

squares + [36, 49, 64, 81, 100]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```

与 [immutable](https://docs.python.org/zh-cn/3.11/glossary.html#term-immutable) 字符串不同, 列表是 [mutable](https://docs.python.org/zh-cn/3.11/glossary.html#term-mutable) 类型，其内容可以改变：

\>>>

```

cubes = [1, 8, 27, 65, 125]  # something's wrong here
4 ** 3  # the cube of 4 is 64, not 65!
64
cubes[3] = 64  # replace the wrong value
cubes
[1, 8, 27, 64, 125]
```

`append()` *方法* 可以在列表结尾添加新元素（详见后文）:

\>>>

```

cubes.append(216)  # add the cube of 6
cubes.append(7 ** 3)  # and the cube of 7
cubes
[1, 8, 27, 64, 125, 216, 343]
```

为切片赋值可以改变列表大小，甚至清空整个列表：

\>>>

```

letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
letters
['a', 'b', 'c', 'd', 'e', 'f', 'g']
# replace some values
letters[2:5] = ['C', 'D', 'E']
letters
['a', 'b', 'C', 'D', 'E', 'f', 'g']
# now remove them
letters[2:5] = []
letters
['a', 'b', 'f', 'g']
# clear the list by replacing all the elements with an empty list
letters[:] = []
letters
[]
```

内置函数 [`len()`](https://docs.python.org/zh-cn/3.11/library/functions.html#len) 也支持列表：

\>>>

```

letters = ['a', 'b', 'c', 'd']
len(letters)
4
```

还可以嵌套列表（创建包含其他列表的列表），例如：

\>>>

```

a = ['a', 'b', 'c']
n = [1, 2, 3]
x = [a, n]
x
[['a', 'b', 'c'], [1, 2, 3]]
x[0]
['a', 'b', 'c']
x[0][1]
'b'
```



## 走向编程的第一步

当然，Python 还可以完成比二加二更复杂的任务。 例如，可以编写 [斐波那契数列](https://en.wikipedia.org/wiki/Fibonacci_number) 的初始子序列，如下所示：

\>>>

```

# Fibonacci series:
# the sum of two elements defines the next
a, b = 0, 1
while a < 10:
    print(a)
    a, b = b, a+b
0
1
1
2
3
5
8
```

本例引入了几个新功能。

- 第一行中的 *多重赋值*：变量 `a` 和 `b` 同时获得新值 0 和 1。最后一行又用了一次多重赋值，这体现在右表达式在赋值前就已经求值了。右表达式求值顺序为从左到右。

- [`while`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#while) 循环只要条件（这里指：`a < 10`）保持为真就会一直执行。Python 和 C 一样，任何非零整数都为真，零为假。这个条件也可以是字符串或列表的值，事实上，任何序列都可以；长度非零就为真，空序列则为假。示例中的判断只是最简单的比较。比较操作符的标准写法和 C 语言一样： `<` （小于）、 `>` （大于）、 `==` （等于）、 `<=` （小于等于)、 `>=` （大于等于）及 `!=` （不等于）。

- *循环体* 是 *缩进的* ：缩进是 Python  组织语句的方式。在交互式命令行里，得为每个缩输入制表符或空格。使用文本编辑器可以实现更复杂的输入方式；所有像样的文本编辑器都支持自动缩进。交互式输入复合语句时, 要在最后输入空白行表示结束（因为解析器不知道哪一行代码是最后一行）。注意，同一块语句的每一行的缩进相同。

- [`print()`](https://docs.python.org/zh-cn/3.11/library/functions.html#print) 函数输出给定参数的值。与表达式不同（比如，之前计算器的例子），它能处理多个参数，包括浮点数与字符串。它输出的字符串不带引号，且各参数项之间会插入一个空格，这样可以实现更好的格式化操作：

  \>>>

  ```
  
  ```

```
i = 256*256
print('The value of i is', i)
The value of i is 65536
```

关键字参数 *end* 可以取消输出后面的换行, 或用另一个字符串结尾：

\>>>

```

a, b = 0, 1
while a < 1000:
    print(a, end=',')
    a, b = b, a+b
```

- ```
  0,1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,
  ```

备注

- [1](https://docs.python.org/zh-cn/3.11/tutorial/introduction.html#id1)

  `**` 比 `-` 的优先级更高, 所以 `-3**2` 会被解释成 `-(3**2)` ，因此，结果是 `-9`。要避免这个问题，并且得到 `9`, 可以用 `(-3)**2`。

- [2](https://docs.python.org/zh-cn/3.11/tutorial/introduction.html#id2)

  和其他语言不一样，特殊字符如 `\n` 在单引号（`'...'`）和双引号（`"..."`）里的意义一样。这两种引号唯一的区别是，不需要在单引号里转义双引号 `"`，但必须把单引号转义成 `\'`，反之亦然。



# 4. 其他流程控制工具

除了上一章介绍的 [`while`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#while) 语句，Python 还支持其他语言中常见的流程控制语句，只是稍有不同。



## 4.1. `if` 语句

最让人耳熟能详的应该是 [`if`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#if) 语句。例如：

\>>>

```

x = int(input("Please enter an integer: "))
Please enter an integer: 42
if x < 0:
    x = 0
    print('Negative changed to zero')
elif x == 0:
    print('Zero')
elif x == 1:
    print('Single')
else:
    print('More')
More
```

if 语句包含零个或多个 [`elif`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#elif) 子句及可选的 [`else`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#else) 子句。关键字 '`elif`' 是 'else if' 的缩写，适用于避免过多的缩进。`if` ... `elif` ... `elif` ... 序列可以当作其他语言中 `switch` 或 `case` 语句的替代品。

如果要把一个值与多个常量进行比较，或者检查特定类型或属性，`match` 语句更实用。详见 [match 语句](https://docs.python.org/zh-cn/3.11/tutorial/controlflow.html#tut-match)。



## 4.2. `for` 语句

Python 的 [`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 语句与 C 或 Pascal 中的不同。Python 的 `for` 语句不迭代算术递增数值（如 Pascal），或是给予用户定义迭代步骤和暂停条件的能力（如 C），而是迭代列表或字符串等任意序列，元素的迭代顺序与在序列中出现的顺序一致。 例如：

\>>>

```

# Measure some strings:
words = ['cat', 'window', 'defenestrate']
for w in words:
    print(w, len(w))
cat 3
window 6
defenestrate 12
```

遍历集合时修改集合的内容，会很容易生成错误的结果。因此不能直接进行循环，而是应遍历该集合的副本或创建新的集合：

```
# Create a sample collection
users = {'Hans': 'active', 'Éléonore': 'inactive', '景太郎': 'active'}

# Strategy:  Iterate over a copy
for user, status in users.copy().items():
    if status == 'inactive':
        del users[user]

# Strategy:  Create a new collection
active_users = {}
for user, status in users.items():
    if status == 'active':
        active_users[user] = status
```



## 4.3. [`range()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#range) 函数

内置函数 [`range()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#range) 常用于遍历数字序列，该函数可以生成算术级数：

\>>>

```

for i in range(5):
    print(i)
0
1
2
3
4
```

生成的序列不包含给定的终止数值；`range(10)` 生成 10 个值，这是一个长度为 10 的序列，其中的元素索引都是合法的。range 可以不从 0 开始，还可以按指定幅度递增（递增幅度称为 '步进'，支持负数）：

\>>>

```

list(range(5, 10))
[5, 6, 7, 8, 9]
list(range(0, 10, 3))
[0, 3, 6, 9]
list(range(-10, -100, -30))
[-10, -40, -70]
```

[`range()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#range) 和 [`len()`](https://docs.python.org/zh-cn/3.11/library/functions.html#len) 组合在一起，可以按索引迭代序列：

\>>>

```

a = ['Mary', 'had', 'a', 'little', 'lamb']
for i in range(len(a)):
    print(i, a[i])
0 Mary
1 had
2 a
3 little
4 lamb
```

不过，大多数情况下，[`enumerate()`](https://docs.python.org/zh-cn/3.11/library/functions.html#enumerate) 函数更便捷，详见 [循环的技巧](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#tut-loopidioms) 。

如果只输出 range，会出现意想不到的结果：

\>>>

```

range(10)
range(0, 10)
```

[`range()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#range) 返回对象的操作和列表很像，但其实这两种对象不是一回事。迭代时，该对象基于所需序列返回连续项，并没有生成真正的列表，从而节省了空间。

这种对象称为可迭代对象 [iterable](https://docs.python.org/zh-cn/3.11/glossary.html#term-iterable)，函数或程序结构可通过该对象获取连续项，直到所有元素全部迭代完毕。[`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 语句就是这样的架构，[`sum()`](https://docs.python.org/zh-cn/3.11/library/functions.html#sum) 是一种把可迭代对象作为参数的函数：

\>>>

```

sum(range(4))  # 0 + 1 + 2 + 3
6
```

下文将介绍更多返回可迭代对象或把可迭代对象当作参数的函数。 在 [数据结构](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#tut-structures) 这一章节中，我们将讨论有关 [`list()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#list) 的更多细节。



## 4.4. 循环中的 `break`、`continue` 语句及 `else` 子句

[`break`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#break) 语句和 C 中的类似，用于跳出最近的 [`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 或 [`while`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#while) 循环。

循环语句支持 `else` 子句；[`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 循环中，可迭代对象中的元素全部循环完毕，或 [`while`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#while) 循环的条件为假时，执行该子句；[`break`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#break) 语句终止循环时，不执行该子句。 请看下面这个查找素数的循环示例：

\>>>

```

for n in range(2, 10):
    for x in range(2, n):
        if n % x == 0:
            print(n, 'equals', x, '*', n//x)
            break
    else:
        # loop fell through without finding a factor
        print(n, 'is a prime number')
2 is a prime number
3 is a prime number
4 equals 2 * 2
5 is a prime number
6 equals 2 * 3
7 is a prime number
8 equals 2 * 4
9 equals 3 * 3
```

（没错，这段代码就是这么写。仔细看：`else` 子句属于 [`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 循环，**不属于** [`if`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#if) 语句。）

与 [`if`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#if) 语句相比，循环的 `else` 子句更像 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 的 `else` 子句： [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 的 `else` 子句在未触发异常时执行，循环的 `else` 子句则在未运行 `break` 时执行。`try` 语句和异常详见 [异常的处理](https://docs.python.org/zh-cn/3.11/tutorial/errors.html#tut-handling)。

[`continue`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#continue) 语句也借鉴自 C 语言，表示继续执行循环的下一次迭代：

\>>>

```

for num in range(2, 10):
    if num % 2 == 0:
        print("Found an even number", num)
        continue
    print("Found an odd number", num)
Found an even number 2
Found an odd number 3
Found an even number 4
Found an odd number 5
Found an even number 6
Found an odd number 7
Found an even number 8
Found an odd number 9
```



## 4.5. `pass` 语句

[`pass`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#pass) 语句不执行任何操作。语法上需要一个语句，但程序不实际执行任何动作时，可以使用该语句。例如：

\>>>

```

while True:
    pass  # Busy-wait for keyboard interrupt (Ctrl+C)
```

下面这段代码创建了一个最小的类：

\>>>

```

class MyEmptyClass:
    pass
```

[`pass`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#pass) 还可以用作函数或条件子句的占位符，让开发者聚焦更抽象的层次。此时，程序直接忽略 `pass`：

\>>>

```

def initlog(*args):
    pass   # Remember to implement this!
```



## 4.6. `match` 语句

A [`match`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#match) statement takes an expression and compares its value to successive patterns given as one or more case blocks.  This is superficially similar to a switch statement in C, Java or JavaScript (and many other languages), but it's more similar to pattern matching in languages like Rust or Haskell. Only the first pattern that matches gets executed and it can also extract components (sequence elements or object attributes) from the value into variables.

最简单的形式是将一个目标值与一个或多个字面值进行比较：

```
def http_error(status):
    match status:
        case 400:
            return "Bad request"
        case 404:
            return "Not found"
        case 418:
            return "I'm a teapot"
        case _:
            return "Something's wrong with the internet"
```

注意最后一个代码块：“变量名” `_` 被作为 *通配符* 并必定会匹配成功。 如果没有 case 语句匹配成功，则不会执行任何分支。

使用 `|` （“ or ”）在一个模式中可以组合多个字面值：

```
case 401 | 403 | 404:
    return "Not allowed"
```

模式的形式类似解包赋值，并可被用于绑定变量：

```
# point is an (x, y) tuple
match point:
    case (0, 0):
        print("Origin")
    case (0, y):
        print(f"Y={y}")
    case (x, 0):
        print(f"X={x}")
    case (x, y):
        print(f"X={x}, Y={y}")
    case _:
        raise ValueError("Not a point")
```

请仔细研究此代码！ 第一个模式有两个字面值，可以看作是上面所示字面值模式的扩展。但接下来的两个模式结合了一个字面值和一个变量，而变量 **绑定** 了一个来自目标的值（`point`）。第四个模式捕获了两个值，这使得它在概念上类似于解包赋值 `(x, y) = point`。

如果使用类实现数据结构，可在类名后加一个类似于构造器的参数列表，这样做可以把属性放到变量里：

```
class Point:
    x: int
    y: int

def where_is(point):
    match point:
        case Point(x=0, y=0):
            print("Origin")
        case Point(x=0, y=y):
            print(f"Y={y}")
        case Point(x=x, y=0):
            print(f"X={x}")
        case Point():
            print("Somewhere else")
        case _:
            print("Not a point")
```

可在 dataclass 等支持属性排序的内置类中使用位置参数。还可在类中设置 `__match_args__` 特殊属性为模式的属性定义指定位置。如果它被设为 ("x", "y")，则以下模式均为等价的，并且都把 `y` 属性绑定到 `var` 变量：

```
Point(1, var)
Point(1, y=var)
Point(x=1, y=var)
Point(y=var, x=1)
```

读取模式的推荐方式是将它们看做是你会在赋值操作左侧放置的内容的扩展形式，以便理解各个变量将会被设置的值。 只有单独的名称（例如上面的 `var`）会被 match 语句所赋值。 带点号的名称 (例如 `foo.bar`)、属性名称（例如上面的 `x=` 和 `y=`）或类名称（通过其后的 "(...)" 来识别，例如上面的 `Point`）都绝不会被赋值。

模式可以任意地嵌套。例如，如果有一个由点组成的短列表，则可使用如下方式进行匹配：

```
match points:
    case []:
        print("No points")
    case [Point(0, 0)]:
        print("The origin")
    case [Point(x, y)]:
        print(f"Single point {x}, {y}")
    case [Point(0, y1), Point(0, y2)]:
        print(f"Two on the Y axis at {y1}, {y2}")
    case _:
        print("Something else")
```

为模式添加成为守护项的 `if` 子句。如果守护项的值为假，则 `match` 继续匹配下一个 case 语句块。注意，值的捕获发生在守护项被求值之前：

```
match point:
    case Point(x, y) if x == y:
        print(f"Y=X at {x}")
    case Point(x, y):
        print(f"Not on the diagonal")
```

match 语句的其他特性：

- 与解包赋值类似，元组和列表模式具有完全相同的含义，并且实际上能匹配任意序列。 但它们不能匹配迭代器或字符串。

- 序列模式支持扩展解包操作：`[x, y, *rest]` 和 `(x, y, *rest)` 的作用类似于解包赋值。 在 `*` 之后的名称也可以为 `_`，因此，`(x, y, *_)` 可以匹配包含至少两个条目的序列，而不必绑定其余的条目。

- 映射模式：`{"bandwidth": b, "latency": l}` 从字典中捕获 `"bandwidth"` 和 `"latency"` 的值。与序列模式不同，额外的键会被忽略。`**rest` 等解包操作也支持。但 `**_` 是冗余的，不允许使用。

- 使用 `as` 关键字可以捕获子模式：

  ```
  case (Point(x1, y1), Point(x2, y2) as p2): ...
  ```

  将把输入的第二个元素捕获为 `p2` (只要输入是包含两个点的序列)

- 大多数字面值是按相等性比较的，但是单例对象 `True`, `False` 和 `None` 则是按标识号比较的。

- 模式可以使用命名常量。 这些命名常量必须为带点号的名称以防止它们被解读为捕获变量:

  ```
  from enum import Enum
  class Color(Enum):
      RED = 'red'
      GREEN = 'green'
      BLUE = 'blue'
  
  color = Color(input("Enter your choice of 'red', 'blue' or 'green': "))
  
  match color:
      case Color.RED:
          print("I see red!")
      case Color.GREEN:
          print("Grass is green")
      case Color.BLUE:
          print("I'm feeling the blues :(")
  ```

要获取更详细的说明和额外的示例，你可以参阅以教程格式撰写的 [**PEP 636**](https://peps.python.org/pep-0636/)。



## 4.7. 定义函数

下列代码创建一个可以输出限定数值内的斐波那契数列函数：

\>>>

```

def fib(n):    # write Fibonacci series up to n
    """Print a Fibonacci series up to n."""
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print()

# Now call the function we just defined:
fib(2000)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597
```

*定义* 函数使用关键字 [`def`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#def)，后跟函数名与括号内的形参列表。函数语句从下一行开始，并且必须缩进。

函数内的第一条语句是字符串时，该字符串就是文档字符串，也称为 *docstring*，详见 [文档字符串](https://docs.python.org/zh-cn/3.11/tutorial/controlflow.html#tut-docstrings)。利用文档字符串可以自动生成在线文档或打印版文档，还可以让开发者在浏览代码时直接查阅文档；Python 开发者最好养成在代码中加入文档字符串的好习惯。

函数在 *执行* 时使用函数局部变量符号表，所有函数变量赋值都存在局部符号表中；引用变量时，首先，在局部符号表里查找变量，然后，是外层函数局部符号表，再是全局符号表，最后是内置名称符号表。因此，尽管可以引用全局变量和外层函数的变量，但最好不要在函数内直接赋值（除非是 [`global`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#global) 语句定义的全局变量，或 [`nonlocal`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#nonlocal) 语句定义的外层函数变量）。

在调用函数时会将实际参数（实参）引入到被调用函数的局部符号表中；因此，实参是使用 *按值调用* 来传递的（其中的 *值* 始终是对象的 *引用* 而不是对象的值）。 [1](https://docs.python.org/zh-cn/3.11/tutorial/controlflow.html#id2) 当一个函数调用另外一个函数时，会为该调用创建一个新的局部符号表。

函数定义在当前符号表中把函数名与函数对象关联在一起。解释器把函数名指向的对象作为用户自定义函数。还可以使用其他名称指向同一个函数对象，并访问访该函数：

\>>>

```

fib
<function fib at 10042ed0>
f = fib
f(100)
0 1 1 2 3 5 8 13 21 34 55 89
```

`fib` 不返回值，因此，其他语言不把它当作函数，而是当作过程。事实上，没有 [`return`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#return) 语句的函数也返回值，只不过这个值比较是 `None` （是一个内置名称）。一般来说，解释器不会输出单独的返回值 `None` ，如需查看该值，可以使用 [`print()`](https://docs.python.org/zh-cn/3.11/library/functions.html#print)：

\>>>

```

fib(0)
print(fib(0))
None
```

编写不直接输出斐波那契数列运算结果，而是返回运算结果列表的函数也非常简单：

\>>>

```

def fib2(n):  # return Fibonacci series up to n
    """Return a list containing the Fibonacci series up to n."""
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)    # see below
        a, b = b, a+b
    return result

f100 = fib2(100)    # call it
f100                # write the result
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
```

本例也新引入了一些 Python 功能：

- [`return`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#return) 语句返回函数的值。`return` 语句不带表达式参数时，返回 `None`。函数执行完毕退出也返回 `None`。
- `result.append(a)` 语句调用了列表对象 `result` 的 *方法* 。方法是“从属于”对象的函数，命名为 `obj.methodname`，`obj` 是对象（也可以是表达式），`methodname` 是对象类型定义的方法名。不同类型定义不同的方法，不同类型的方法名可以相同，且不会引起歧义。（用 *类* 可以自定义对象类型和方法，详见 [类](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#tut-classes) ）示例中的方法 `append()` 是为列表对象定义的，用于在列表末尾添加新元素。本例中，该方法相当于 `result = result + [a]` ，但更有效。



## 4.8. 函数定义详解

函数定义支持可变数量的参数。这里列出三种可以组合使用的形式。



### 4.8.1. 默认值参数

为参数指定默认值是非常有用的方式。调用函数时，可以使用比定义时更少的参数，例如：

```
def ask_ok(prompt, retries=4, reminder='Please try again!'):
    while True:
        ok = input(prompt)
        if ok in ('y', 'ye', 'yes'):
            return True
        if ok in ('n', 'no', 'nop', 'nope'):
            return False
        retries = retries - 1
        if retries < 0:
            raise ValueError('invalid user response')
        print(reminder)
```

该函数可以用以下方式调用：

- 只给出必选实参：`ask_ok('Do you really want to quit?')`
- 给出一个可选实参：`ask_ok('OK to overwrite the file?', 2)`
- 给出所有实参：`ask_ok('OK to overwrite the file?', 2, 'Come on, only yes or no!')`

本例还使用了关键字 [`in`](https://docs.python.org/zh-cn/3.11/reference/expressions.html#in) ，用于确认序列中是否包含某个值。

默认值在 *定义* 作用域里的函数定义中求值，所以：

```
i = 5

def f(arg=i):
    print(arg)

i = 6
f()
```

上例输出的是 `5`。

**重要警告：** 默认值只计算一次。默认值为列表、字典或类实例等可变对象时，会产生与该规则不同的结果。例如，下面的函数会累积后续调用时传递的参数：

```
def f(a, L=[]):
    L.append(a)
    return L

print(f(1))
print(f(2))
print(f(3))
```

输出结果如下：

```
[1]
[1, 2]
[1, 2, 3]
```

不想在后续调用之间共享默认值时，应以如下方式编写函数：

```
def f(a, L=None):
    if L is None:
        L = []
    L.append(a)
    return L
```



### 4.8.2. 关键字参数

`kwarg=value` 形式的 [关键字参数](https://docs.python.org/zh-cn/3.11/glossary.html#term-keyword-argument) 也可以用于调用函数。函数示例如下：

```
def parrot(voltage, state='a stiff', action='voom', type='Norwegian Blue'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.")
    print("-- Lovely plumage, the", type)
    print("-- It's", state, "!")
```

该函数接受一个必选参数（`voltage`）和三个可选参数（`state`, `action` 和 `type`）。该函数可用下列方式调用：

```
parrot(1000)                                          # 1 positional argument
parrot(voltage=1000)                                  # 1 keyword argument
parrot(voltage=1000000, action='VOOOOOM')             # 2 keyword arguments
parrot(action='VOOOOOM', voltage=1000000)             # 2 keyword arguments
parrot('a million', 'bereft of life', 'jump')         # 3 positional arguments
parrot('a thousand', state='pushing up the daisies')  # 1 positional, 1 keyword
```

以下调用函数的方式都无效：

```
parrot()                     # required argument missing
parrot(voltage=5.0, 'dead')  # non-keyword argument after a keyword argument
parrot(110, voltage=220)     # duplicate value for the same argument
parrot(actor='John Cleese')  # unknown keyword argument
```

函数调用时，关键字参数必须跟在位置参数后面。所有传递的关键字参数都必须匹配一个函数接受的参数（比如，`actor` 不是函数 `parrot` 的有效参数），关键字参数的顺序并不重要。这也包括必选参数，（比如，`parrot(voltage=1000)` 也有效）。不能对同一个参数多次赋值，下面就是一个因此限制而失败的例子：

\>>>

```

def function(a):
    pass

function(0, a=0)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: function() got multiple values for argument 'a'
```

最后一个形参为 `**name`  形式时，接收一个字典（详见 [映射类型 --- dict](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#typesmapping)），该字典包含与函数中已定义形参对应之外的所有关键字参数。`**name` 形参可以与 `*name` 形参（下一小节介绍）组合使用（`*name` 必须在 `**name` 前面）， `*name` 形参接收一个 [元组](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#tut-tuples)，该元组包含形参列表之外的位置参数。例如，可以定义下面这样的函数：

```
def cheeseshop(kind, *arguments, **keywords):
    print("-- Do you have any", kind, "?")
    print("-- I'm sorry, we're all out of", kind)
    for arg in arguments:
        print(arg)
    print("-" * 40)
    for kw in keywords:
        print(kw, ":", keywords[kw])
```

该函数可以用如下方式调用：

```
cheeseshop("Limburger", "It's very runny, sir.",
           "It's really very, VERY runny, sir.",
           shopkeeper="Michael Palin",
           client="John Cleese",
           sketch="Cheese Shop Sketch")
```

输出结果如下：

```
-- Do you have any Limburger ?
-- I'm sorry, we're all out of Limburger
It's very runny, sir.
It's really very, VERY runny, sir.
----------------------------------------
shopkeeper : Michael Palin
client : John Cleese
sketch : Cheese Shop Sketch
```

注意，关键字参数在输出结果中的顺序与调用函数时的顺序一致。

### 4.8.3. 特殊参数

默认情况下，参数可以按位置或显式关键字传递给 Python 函数。为了让代码易读、高效，最好限制参数的传递方式，这样，开发者只需查看函数定义，即可确定参数项是仅按位置、按位置或关键字，还是仅按关键字传递。

函数定义如下：

```
def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2):
      -----------    ----------     ----------
        |             |                  |
        |        Positional or keyword   |
        |                                - Keyword only
         -- Positional only
```

`/` 和 `*` 是可选的。这些符号表明形参如何把参数值传递给函数：位置、位置或关键字、关键字。关键字形参也叫作命名形参。

#### 4.8.3.1. 位置或关键字参数

函数定义中未使用 `/` 和 `*` 时，参数可以按位置或关键字传递给函数。

#### 4.8.3.2. 仅位置参数

此处再介绍一些细节，特定形参可以标记为 *仅限位置*。*仅限位置* 时，形参的顺序很重要，且这些形参不能用关键字传递。仅限位置形参应放在 `/`  （正斜杠）前。`/` 用于在逻辑上分割仅限位置形参与其它形参。如果函数定义中没有 `/`，则表示没有仅限位置形参。

`/` 后可以是 *位置或关键字* 或 *仅限关键字* 形参。

#### 4.8.3.3. 仅限关键字参数

把形参标记为 *仅限关键字*，表明必须以关键字参数形式传递该形参，应在参数列表中第一个 *仅限关键字* 形参前添加 `*`。

#### 4.8.3.4. 函数示例

请看下面的函数定义示例，注意 `/` 和 `*` 标记：

\>>>

```

def standard_arg(arg):
    print(arg)

def pos_only_arg(arg, /):
    print(arg)

def kwd_only_arg(*, arg):
    print(arg)

def combined_example(pos_only, /, standard, *, kwd_only):
    print(pos_only, standard, kwd_only)
```

第一个函数定义 `standard_arg` 是最常见的形式，对调用方式没有任何限制，可以按位置也可以按关键字传递参数：

\>>>

```

standard_arg(2)
2
standard_arg(arg=2)
2
```

第二个函数 `pos_only_arg` 的函数定义中有 `/`，仅限使用位置形参：

\>>>

```

pos_only_arg(1)
1
pos_only_arg(arg=1)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: pos_only_arg() got some positional-only arguments passed as keyword arguments: 'arg'
```

第三个函数 `kwd_only_args` 的函数定义通过 `*` 表明仅限关键字参数：

\>>>

```

kwd_only_arg(3)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: kwd_only_arg() takes 0 positional arguments but 1 was given
kwd_only_arg(arg=3)
3
```

最后一个函数在同一个函数定义中，使用了全部三种调用惯例：

\>>>

```

combined_example(1, 2, 3)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: combined_example() takes 2 positional arguments but 3 were given
combined_example(1, 2, kwd_only=3)
1 2 3
combined_example(1, standard=2, kwd_only=3)
1 2 3
combined_example(pos_only=1, standard=2, kwd_only=3)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: combined_example() got some positional-only arguments passed as keyword arguments: 'pos_only'
```

下面的函数定义中，`kwds` 把 `name` 当作键，因此，可能与位置参数 `name` 产生潜在冲突：

```
def foo(name, **kwds):
    return 'name' in kwds
```

调用该函数不可能返回 `True`，因为关键字 `'name'` 总与第一个形参绑定。例如：

\>>>

```

foo(1, **{'name': 2})
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: foo() got multiple values for argument 'name'
>>>
```

加上 `/` （仅限位置参数）后，就可以了。此时，函数定义把 `name` 当作位置参数，`'name'` 也可以作为关键字参数的键：

\>>>

```

def foo(name, /, **kwds):
    return 'name' in kwds

foo(1, **{'name': 2})
True
```

换句话说，仅限位置形参的名称可以在 `**kwds` 中使用，而不产生歧义。

#### 4.8.3.5. 小结

以下用例决定哪些形参可以用于函数定义：

```
def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2):
```

说明：

- 使用仅限位置形参，可以让用户无法使用形参名。形参名没有实际意义时，强制调用函数的实参顺序时，或同时接收位置形参和关键字时，这种方式很有用。
- 当形参名有实际意义，且显式名称可以让函数定义更易理解时，阻止用户依赖传递实参的位置时，才使用关键字。
- 对于 API，使用仅限位置形参，可以防止未来修改形参名时造成破坏性的 API 变动。



### 4.8.4. 任意实参列表

调用函数时，使用任意数量的实参是最少见的选项。这些实参包含在元组中（详见 [元组和序列](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#tut-tuples) ）。在可变数量的实参之前，可能有若干个普通参数：

```
def write_multiple_items(file, separator, *args):
    file.write(separator.join(args))
```

*variadic* 参数用于采集传递给函数的所有剩余参数，因此，它们通常在形参列表的末尾。`*args` 形参后的任何形式参数只能是仅限关键字参数，即只能用作关键字参数，不能用作位置参数：

\>>>

```

def concat(*args, sep="/"):
    return sep.join(args)

concat("earth", "mars", "venus")
'earth/mars/venus'
concat("earth", "mars", "venus", sep=".")
'earth.mars.venus'
```



### 4.8.5. 解包实参列表

函数调用要求独立的位置参数，但实参在列表或元组里时，要执行相反的操作。例如，内置的 [`range()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#range) 函数要求独立的 *start* 和 *stop* 实参。如果这些参数不是独立的，则要在调用函数时，用 `*` 操作符把实参从列表或元组解包出来：

\>>>

```

list(range(3, 6))            # normal call with separate arguments
[3, 4, 5]
args = [3, 6]
list(range(*args))            # call with arguments unpacked from a list
[3, 4, 5]
```

同样，字典可以用 `**` 操作符传递关键字参数：

\>>>

```

def parrot(voltage, state='a stiff', action='voom'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.", end=' ')
    print("E's", state, "!")

d = {"voltage": "four million", "state": "bleedin' demised", "action": "VOOM"}
parrot(**d)
-- This parrot wouldn't VOOM if you put four million volts through it. E's bleedin' demised !
```



### 4.8.6. Lambda 表达式

[`lambda`](https://docs.python.org/zh-cn/3.11/reference/expressions.html#lambda) 关键字用于创建小巧的匿名函数。`lambda a, b: a+b` 函数返回两个参数的和。Lambda 函数可用于任何需要函数对象的地方。在语法上，匿名函数只能是单个表达式。在语义上，它只是常规函数定义的语法糖。与嵌套函数定义一样，lambda 函数可以引用包含作用域中的变量：

\>>>

```

def make_incrementor(n):
    return lambda x: x + n

f = make_incrementor(42)
f(0)
42
f(1)
43
```

上例用 lambda 表达式返回函数。还可以把匿名函数用作传递的实参：

\>>>

```

pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
pairs.sort(key=lambda pair: pair[1])
pairs
[(4, 'four'), (1, 'one'), (3, 'three'), (2, 'two')]
```



### 4.8.7. 文档字符串

以下是文档字符串内容和格式的约定。

第一行应为对象用途的简短摘要。为保持简洁，不要在这里显式说明对象名或类型，因为可通过其他方式获取这些信息（除非该名称碰巧是描述函数操作的动词）。这一行应以大写字母开头，以句点结尾。

文档字符串为多行时，第二行应为空白行，在视觉上将摘要与其余描述分开。后面的行可包含若干段落，描述对象的调用约定、副作用等。

Python 解析器不会删除 Python 中多行字符串字面值的缩进，因此，文档处理工具应在必要时删除缩进。这项操作遵循以下约定：文档字符串第一行 *之后*  的第一个非空行决定了整个文档字符串的缩进量（第一行通常与字符串开头的引号相邻，其缩进在字符串中并不明显，因此，不能用第一行的缩进），然后，删除字符串中所有行开头处与此缩进“等价”的空白符。不能有比此缩进更少的行，但如果出现了缩进更少的行，应删除这些行的所有前导空白符。转化制表符后（通常为 8 个空格），应测试空白符的等效性。

下面是多行文档字符串的一个例子：

\>>>

```

def my_function():
    """Do nothing, but document it.

    No, really, it doesn't do anything.
    """
    pass

print(my_function.__doc__)
Do nothing, but document it.

    No, really, it doesn't do anything.
```



### 4.8.8. 函数注解

[函数注解](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#function) 是可选的用户自定义函数类型的元数据完整信息（详见 [**PEP 3107**](https://peps.python.org/pep-3107/) 和 [**PEP 484**](https://peps.python.org/pep-0484/) ）。

[标注](https://docs.python.org/zh-cn/3.11/glossary.html#term-function-annotation) 以字典的形式存放在函数的 `__annotations__` 属性中，并且不会影响函数的任何其他部分。 形参标注的定义方式是在形参名后加冒号，后面跟一个表达式，该表达式会被求值为标注的值。 返回值标注的定义方式是加组合符号 `->`，后面跟一个表达式，该标注位于形参列表和表示 [`def`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#def) 语句结束的冒号之间。  下面的示例有一个必须的参数，一个可选的关键字参数以及返回值都带有相应的标注:

\>>>

```

def f(ham: str, eggs: str = 'eggs') -> str:
    print("Annotations:", f.__annotations__)
    print("Arguments:", ham, eggs)
    return ham + ' and ' + eggs

f('spam')
Annotations: {'ham': <class 'str'>, 'return': <class 'str'>, 'eggs': <class 'str'>}
Arguments: spam eggs
'spam and eggs'
```



## 4.9. 小插曲：编码风格

现在你将要写更长，更复杂的 Python 代码，是时候讨论一下 *代码风格* 了。 大多数语言都能以不同的风格被编写（或更准确地说，被格式化）；有些比其他的更具有可读性。 能让其他人轻松阅读你的代码总是一个好主意，采用一种好的编码风格对此有很大帮助。

Python 项目大多都遵循 [**PEP 8**](https://peps.python.org/pep-0008/) 的风格指南；它推行的编码风格易于阅读、赏心悦目。Python 开发者均应抽时间悉心研读；以下是该提案中的核心要点：

- 缩进，用 4 个空格，不要用制表符。

  4 个空格是小缩进（更深嵌套）和大缩进（更易阅读）之间的折中方案。制表符会引起混乱，最好别用。

- 换行，一行不超过 79 个字符。

  这样换行的小屏阅读体验更好，还便于在大屏显示器上并排阅读多个代码文件。

- 用空行分隔函数和类，及函数内较大的代码块。

- 最好把注释放到单独一行。

- 使用文档字符串。

- 运算符前后、逗号后要用空格，但不要直接在括号内使用： `a = f(1, 2) + g(3, 4)`。

- 类和函数的命名要一致；按惯例，命名类用 `UpperCamelCase`，命名函数与方法用 `lowercase_with_underscores`。命名方法中第一个参数总是用 `self` (类和方法详见 [初探类](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#tut-firstclasses))。

- 编写用于国际多语环境的代码时，不要用生僻的编码。Python 默认的 UTF-8 或纯 ASCII 可以胜任各种情况。

- 同理，就算多语阅读、维护代码的可能再小，也不要在标识符中使用非 ASCII 字符。

备注

- [1](https://docs.python.org/zh-cn/3.11/tutorial/controlflow.html#id1)

  实际上，*对象引用调用* 这种说法更好，因为，传递的是可变对象时，调用者能发现被调者做出的任何更改（插入列表的元素）。

# 5. 数据结构

本章深入讲解之前学过的一些内容，同时，还增加了新的知识点。



## 5.1. 列表详解

列表数据类型支持很多方法，列表对象的所有方法所示如下：

- list.append(*x*)

  在列表末尾添加一个元素，相当于 `a[len(a):] = [x]` 。

- list.extend(*iterable*)

  用可迭代对象的元素扩展列表。相当于  `a[len(a):] = iterable` 。

- list.insert(*i*, *x*)

  在指定位置插入元素。第一个参数是插入元素的索引，因此，`a.insert(0, x)` 在列表开头插入元素， `a.insert(len(a), x)` 等同于 `a.append(x)` 。

- list.remove(*x*)

  从列表中删除第一个值为 *x* 的元素。未找到指定元素时，触发 [`ValueError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#ValueError) 异常。

- list.pop([*i*])

  删除列表中指定位置的元素，并返回被删除的元素。未指定位置时，`a.pop()` 删除并返回列表的最后一个元素。（方法签名中 *i* 两边的方括号表示该参数是可选的，不是要求输入方括号。这种表示法常见于 Python 参考库）。

- list.clear()

  删除列表里的所有元素，相当于 `del a[:]` 。

- list.index(*x*[, *start*[, *end*]])

  返回列表中第一个值为 *x* 的元素的零基索引。未找到指定元素时，触发 [`ValueError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#ValueError) 异常。 可选参数 *start* 和 *end* 是切片符号，用于将搜索限制为列表的特定子序列。返回的索引是相对于整个序列的开始计算的，而不是 *start* 参数。

- list.count(*x*)

  返回列表中元素 *x* 出现的次数。

- list.sort(***, *key=None*, *reverse=False*)

  就地排序列表中的元素（要了解自定义排序参数，详见 [`sorted()`](https://docs.python.org/zh-cn/3.11/library/functions.html#sorted)）。

- list.reverse()

  翻转列表中的元素。

- list.copy()

  返回列表的浅拷贝。相当于 `a[:]`  。

多数列表方法示例：

\>>>

```

fruits = ['orange', 'apple', 'pear', 'banana', 'kiwi', 'apple', 'banana']
fruits.count('apple')
2
fruits.count('tangerine')
0
fruits.index('banana')
3
fruits.index('banana', 4)  # Find next banana starting at position 4
6
fruits.reverse()
fruits
['banana', 'apple', 'kiwi', 'banana', 'pear', 'apple', 'orange']
fruits.append('grape')
fruits
['banana', 'apple', 'kiwi', 'banana', 'pear', 'apple', 'orange', 'grape']
fruits.sort()
fruits
['apple', 'apple', 'banana', 'banana', 'grape', 'kiwi', 'orange', 'pear']
fruits.pop()
'pear'
```

You might have noticed that methods like `insert`, `remove` or `sort` that only modify the list have no return value printed -- they return the default `None`. [1](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#id2)  This is a design principle for all mutable data structures in Python.

还有，不是所有数据都可以排序或比较。例如，`[None, 'hello', 10]` 就不可排序，因为整数不能与字符串对比，而 *None* 不能与其他类型对比。有些类型根本就没有定义顺序关系，例如，`3+4j < 5+7j` 这种对比操作就是无效的。



### 5.1.1. 用列表实现堆栈

使用列表方法实现堆栈非常容易，最后插入的最先取出（“后进先出”）。把元素添加到堆栈的顶端，使用 `append()` 。从堆栈顶部取出元素，使用 `pop()` ，不用指定索引。例如：

\>>>

```

stack = [3, 4, 5]
stack.append(6)
stack.append(7)
stack
[3, 4, 5, 6, 7]
stack.pop()
7
stack
[3, 4, 5, 6]
stack.pop()
6
stack.pop()
5
stack
[3, 4]
```



### 5.1.2. 用列表实现队列

列表也可以用作队列，最先加入的元素，最先取出（“先进先出”）；然而，列表作为队列的效率很低。因为，在列表末尾添加和删除元素非常快，但在列表开头插入或移除元素却很慢（因为所有其他元素都必须移动一位）。

实现队列最好用 [`collections.deque`](https://docs.python.org/zh-cn/3.11/library/collections.html#collections.deque)，可以快速从两端添加或删除元素。例如：

\>>>

```

from collections import deque
queue = deque(["Eric", "John", "Michael"])
queue.append("Terry")           # Terry arrives
queue.append("Graham")          # Graham arrives
queue.popleft()                 # The first to arrive now leaves
'Eric'
queue.popleft()                 # The second to arrive now leaves
'John'
queue                           # Remaining queue in order of arrival
deque(['Michael', 'Terry', 'Graham'])
```



### 5.1.3. 列表推导式

列表推导式创建列表的方式更简洁。常见的用法为，对序列或可迭代对象中的每个元素应用某种操作，用生成的结果创建新的列表；或用满足特定条件的元素创建子序列。

例如，创建平方值的列表：

\>>>

```

squares = []
for x in range(10):
    squares.append(x**2)

squares
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

注意，这段代码创建（或覆盖）变量 `x`，该变量在循环结束后仍然存在。下述方法可以无副作用地计算平方列表：

```
squares = list(map(lambda x: x**2, range(10)))
```

或等价于：

```
squares = [x**2 for x in range(10)]
```

上面这种写法更简洁、易读。

列表推导式的方括号内包含以下内容：一个表达式，后面为一个 `for` 子句，然后，是零个或多个 `for` 或 `if` 子句。结果是由表达式依据 `for` 和 `if` 子句求值计算而得出一个新列表。 举例来说，以下列表推导式将两个列表中不相等的元素组合起来：

\>>>

```

[(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]
[(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]
```

等价于：

\>>>

```

combs = []
for x in [1,2,3]:
    for y in [3,1,4]:
        if x != y:
            combs.append((x, y))

combs
[(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]
```

注意，上面两段代码中，[`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 和 [`if`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#if) 的顺序相同。

表达式是元组（例如上例的 `(x, y)`）时，必须加上括号：

\>>>

```

vec = [-4, -2, 0, 2, 4]
# create a new list with the values doubled
[x*2 for x in vec]
[-8, -4, 0, 4, 8]
# filter the list to exclude negative numbers
[x for x in vec if x >= 0]
[0, 2, 4]
# apply a function to all the elements
[abs(x) for x in vec]
[4, 2, 0, 2, 4]
# call a method on each element
freshfruit = ['  banana', '  loganberry ', 'passion fruit  ']
[weapon.strip() for weapon in freshfruit]
['banana', 'loganberry', 'passion fruit']
# create a list of 2-tuples like (number, square)
[(x, x**2) for x in range(6)]
[(0, 0), (1, 1), (2, 4), (3, 9), (4, 16), (5, 25)]
# the tuple must be parenthesized, otherwise an error is raised
[x, x**2 for x in range(6)]
  File "<stdin>", line 1
    [x, x**2 for x in range(6)]
     ^^^^^^^
SyntaxError: did you forget parentheses around the comprehension target?
# flatten a list using a listcomp with two 'for'
vec = [[1,2,3], [4,5,6], [7,8,9]]
[num for elem in vec for num in elem]
[1, 2, 3, 4, 5, 6, 7, 8, 9]
```

列表推导式可以使用复杂的表达式和嵌套函数：

\>>>

```

from math import pi
[str(round(pi, i)) for i in range(1, 6)]
['3.1', '3.14', '3.142', '3.1416', '3.14159']
```

### 5.1.4. 嵌套的列表推导式

列表推导式中的初始表达式可以是任何表达式，甚至可以是另一个列表推导式。

下面这个 3x4 矩阵，由 3 个长度为 4 的列表组成：

\>>>

```

matrix = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
]
```

下面的列表推导式可以转置行列：

\>>>

```

[[row[i] for row in matrix] for i in range(4)]
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
```

As we saw in the previous section, the inner list comprehension is evaluated in the context of the [`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) that follows it, so this example is equivalent to:

\>>>

```

transposed = []
for i in range(4):
    transposed.append([row[i] for row in matrix])

transposed
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
```

反过来说，也等价于：

\>>>

```

transposed = []
for i in range(4):
    # the following 3 lines implement the nested listcomp
    transposed_row = []
    for row in matrix:
        transposed_row.append(row[i])
    transposed.append(transposed_row)

transposed
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
```

实际应用中，最好用内置函数替代复杂的流程语句。此时，[`zip()`](https://docs.python.org/zh-cn/3.11/library/functions.html#zip) 函数更好用：

\>>>

```

list(zip(*matrix))
[(1, 5, 9), (2, 6, 10), (3, 7, 11), (4, 8, 12)]
```

关于本行中星号的详细说明，参见 [解包实参列表](https://docs.python.org/zh-cn/3.11/tutorial/controlflow.html#tut-unpacking-arguments)。



## 5.2. `del` 语句

[`del`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#del) 语句按索引，而不是值从列表中移除元素。与返回值的 `pop()` 方法不同， `del` 语句也可以从列表中移除切片，或清空整个列表（之前是将空列表赋值给切片）。 例如：

\>>>

```

a = [-1, 1, 66.25, 333, 333, 1234.5]
del a[0]
a
[1, 66.25, 333, 333, 1234.5]
del a[2:4]
a
[1, 66.25, 1234.5]
del a[:]
a
[]
```

[`del`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#del) 也可以用来删除整个变量：

\>>>

```

del a
```

此后，再引用 `a` 就会报错（直到为它赋与另一个值）。后文会介绍 [`del`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#del) 的其他用法。



## 5.3. 元组和序列

列表和字符串有很多共性，例如，索引和切片操作。这两种数据类型是 *序列* （参见 [序列类型 --- list, tuple, range](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#typesseq)）。随着 Python 语言的发展，其他的序列类型也被加入其中。本节介绍另一种标准序列类型：*元组*。

元组由多个用逗号隔开的值组成，例如：

\>>>

```

t = 12345, 54321, 'hello!'
t[0]
12345
t
(12345, 54321, 'hello!')
# Tuples may be nested:
u = t, (1, 2, 3, 4, 5)
u
((12345, 54321, 'hello!'), (1, 2, 3, 4, 5))
# Tuples are immutable:
t[0] = 88888
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'tuple' object does not support item assignment
# but they can contain mutable objects:
v = ([1, 2, 3], [3, 2, 1])
v
([1, 2, 3], [3, 2, 1])
```

输出时，元组都要由圆括号标注，这样才能正确地解释嵌套元组。输入时，圆括号可有可无，不过经常是必须的（如果元组是更大的表达式的一部分）。不允许为元组中的单个元素赋值，当然，可以创建含列表等可变对象的元组。

虽然，元组与列表很像，但使用场景不同，用途也不同。元组是 [immutable](https://docs.python.org/zh-cn/3.11/glossary.html#term-immutable) （不可变的），一般可包含异质元素序列，通过解包（见本节下文）或索引访问（如果是 [`namedtuples`](https://docs.python.org/zh-cn/3.11/library/collections.html#collections.namedtuple)，可以属性访问）。列表是 [mutable](https://docs.python.org/zh-cn/3.11/glossary.html#term-mutable) （可变的），列表元素一般为同质类型，可迭代访问。

构造 0 个或 1 个元素的元组比较特殊：为了适应这种情况，对句法有一些额外的改变。用一对空圆括号就可以创建空元组；只有一个元素的元组可以通过在这个元素后添加逗号来构建（圆括号里只有一个值的话不够明确）。丑陋，但是有效。例如：

\>>>

```

empty = ()
singleton = 'hello',    # <-- note trailing comma
len(empty)
0
len(singleton)
1
singleton
('hello',)
```

语句 `t = 12345, 54321, 'hello!'` 是 *元组打包* 的例子：值 `12345`, `54321` 和 `'hello!'` 一起被打包进元组。逆操作也可以：

\>>>

```

x, y, z = t
```

称之为 *序列解包*  也是妥妥的，适用于右侧的任何序列。序列解包时，左侧变量与右侧序列元素的数量应相等。注意，多重赋值其实只是元组打包和序列解包的组合。



## 5.4. 集合

Python 还支持 *集合* 这种数据类型。集合是由不重复元素组成的无序容器。基本用法包括成员检测、消除重复元素。集合对象支持合集、交集、差集、对称差分等数学运算。

创建集合用花括号或 [`set()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#set) 函数。注意，创建空集合只能用 `set()`，不能用 `{}`，`{}` 创建的是空字典，下一小节介绍数据结构：字典。

以下是一些简单的示例

\>>>

```

basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
print(basket)                      # show that duplicates have been removed
{'orange', 'banana', 'pear', 'apple'}
'orange' in basket                 # fast membership testing
True
'crabgrass' in basket
False
# Demonstrate set operations on unique letters from two words

a = set('abracadabra')
b = set('alacazam')
a                                  # unique letters in a
{'a', 'r', 'b', 'c', 'd'}
a - b                              # letters in a but not in b
{'r', 'd', 'b'}
a | b                              # letters in a or b or both
{'a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'}
a & b                              # letters in both a and b
{'a', 'c'}
a ^ b                              # letters in a or b but not both
{'r', 'd', 'b', 'm', 'z', 'l'}
```

与 [列表推导式](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#tut-listcomps) 类似，集合也支持推导式：

\>>>

```

a = {x for x in 'abracadabra' if x not in 'abc'}
a
{'r', 'd'}
```



## 5.5. 字典

*字典* （参见 [映射类型 --- dict](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#typesmapping)） 也是一种常用的 Python 內置数据类型。其他语言可能把字典称为 *联合内存* 或 *联合数组*。与以连续整数为索引的序列不同，字典以 *关键字* 为索引，关键字通常是字符串或数字，也可以是其他任意不可变类型。只包含字符串、数字、元组的元组，也可以用作关键字。但如果元组直接或间接地包含了可变对象，就不能用作关键字。列表不能当关键字，因为列表可以用索引、切片、`append()` 、`extend()` 等方法修改。

可以把字典理解为 *键值对* 的集合，但字典的键必须是唯一的。花括号 `{}` 用于创建空字典。另一种初始化字典的方式是，在花括号里输入逗号分隔的键值对，这也是字典的输出方式。

字典的主要用途是通过关键字存储、提取值。用 `del` 可以删除键值对。用已存在的关键字存储值，与该关键字关联的旧值会被取代。通过不存在的键提取值，则会报错。

对字典执行 `list(d)` 操作，返回该字典中所有键的列表，按插入次序排列（如需排序，请使用 `sorted(d)`）。检查字典里是否存在某个键，使用关键字 [`in`](https://docs.python.org/zh-cn/3.11/reference/expressions.html#in)。

以下是一些字典的简单示例：

\>>>

```

tel = {'jack': 4098, 'sape': 4139}
tel['guido'] = 4127
tel
{'jack': 4098, 'sape': 4139, 'guido': 4127}
tel['jack']
4098
del tel['sape']
tel['irv'] = 4127
tel
{'jack': 4098, 'guido': 4127, 'irv': 4127}
list(tel)
['jack', 'guido', 'irv']
sorted(tel)
['guido', 'irv', 'jack']
'guido' in tel
True
'jack' not in tel
False
```

[`dict()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#dict) 构造函数可以直接用键值对序列创建字典：

\>>>

```

dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
{'sape': 4139, 'guido': 4127, 'jack': 4098}
```

字典推导式可以用任意键值表达式创建字典：

\>>>

```

{x: x**2 for x in (2, 4, 6)}
{2: 4, 4: 16, 6: 36}
```

关键字是比较简单的字符串时，直接用关键字参数指定键值对更便捷：

\>>>

```

dict(sape=4139, guido=4127, jack=4098)
{'sape': 4139, 'guido': 4127, 'jack': 4098}
```



## 5.6. 循环的技巧

在字典中循环时，用 `items()` 方法可同时取出键和对应的值：

\>>>

```

knights = {'gallahad': 'the pure', 'robin': 'the brave'}
for k, v in knights.items():
    print(k, v)
gallahad the pure
robin the brave
```

在序列中循环时，用 [`enumerate()`](https://docs.python.org/zh-cn/3.11/library/functions.html#enumerate) 函数可以同时取出位置索引和对应的值：

\>>>

```

for i, v in enumerate(['tic', 'tac', 'toe']):
    print(i, v)
0 tic
1 tac
2 toe
```

同时循环两个或多个序列时，用 [`zip()`](https://docs.python.org/zh-cn/3.11/library/functions.html#zip) 函数可以将其内的元素一一匹配：

\>>>

```

questions = ['name', 'quest', 'favorite color']
answers = ['lancelot', 'the holy grail', 'blue']
for q, a in zip(questions, answers):
    print('What is your {0}?  It is {1}.'.format(q, a))
What is your name?  It is lancelot.
What is your quest?  It is the holy grail.
What is your favorite color?  It is blue.
```

逆向循环序列时，先正向定位序列，然后调用 [`reversed()`](https://docs.python.org/zh-cn/3.11/library/functions.html#reversed) 函数：

\>>>

```

for i in reversed(range(1, 10, 2)):
    print(i)
9
7
5
3
1
```

按指定顺序循环序列，可以用 [`sorted()`](https://docs.python.org/zh-cn/3.11/library/functions.html#sorted) 函数，在不改动原序列的基础上，返回一个重新的序列：

\>>>

```

basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
for i in sorted(basket):
    print(i)
apple
apple
banana
orange
orange
pear
```

使用 [`set()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#set) 去除序列中的重复元素。使用 [`sorted()`](https://docs.python.org/zh-cn/3.11/library/functions.html#sorted) 加 [`set()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#set) 则按排序后的顺序，循环遍历序列中的唯一元素：

\>>>

```

basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
for f in sorted(set(basket)):
    print(f)
apple
banana
orange
pear
```

一般来说，在循环中修改列表的内容时，创建新列表比较简单，且安全：

\>>>

```

import math
raw_data = [56.2, float('NaN'), 51.7, 55.3, 52.5, float('NaN'), 47.8]
filtered_data = []
for value in raw_data:
    if not math.isnan(value):
        filtered_data.append(value)

filtered_data
[56.2, 51.7, 55.3, 52.5, 47.8]
```



## 5.7. 深入条件控制

`while` 和 `if` 条件句不只可以进行比较，还可以使用任意运算符。

比较运算符 `in` 和 `not in` 用于执行确定一个值是否存在（或不存在）于某个容器中的成员检测。 运算符 `is` 和 `is not` 用于比较两个对象是否是同一个对象。 所有比较运算符的优先级都一样，且低于任何数值运算符。

比较操作支持链式操作。例如，`a < b == c` 校验 `a` 是否小于 `b`，且 `b` 是否等于 `c`。

比较操作可以用布尔运算符 `and` 和 `or` 组合，并且，比较操作（或其他布尔运算）的结果都可以用 `not` 取反。这些操作符的优先级低于比较操作符；`not` 的优先级最高， `or` 的优先级最低，因此，`A and not B or C` 等价于 `(A and (not B)) or C`。与其他运算符操作一样，此处也可以用圆括号表示想要的组合。

布尔运算符 `and` 和 `or` 也称为 *短路* 运算符：其参数从左至右解析，一旦可以确定结果，解析就会停止。例如，如果 `A` 和 `C` 为真，`B` 为假，那么 `A and B and C` 不会解析 `C`。用作普通值而不是布尔值时，短路操作符返回的值通常是最后一个变量。

还可以把比较操作或逻辑表达式的结果赋值给变量，例如：

\>>>

```

string1, string2, string3 = '', 'Trondheim', 'Hammer Dance'
non_null = string1 or string2 or string3
non_null
'Trondheim'
```

注意，Python 与 C 不同，在表达式内部赋值必须显式使用 [海象运算符](https://docs.python.org/zh-cn/3.11/faq/design.html#why-can-t-i-use-an-assignment-in-an-expression) `:=`。 这避免了 C 程序中常见的问题：要在表达式中写 `==` 时，却写成了 `=`。



## 5.8. 序列和其他类型的比较

序列对象可以与相同序列类型的其他对象比较。这种比较使用 *字典式*  顺序：首先，比较前两个对应元素，如果不相等，则可确定比较结果；如果相等，则比较之后的两个元素，以此类推，直到其中一个序列结束。如果要比较的两个元素本身是相同类型的序列，则递归地执行字典式顺序比较。如果两个序列中所有的对应元素都相等，则两个序列相等。如果一个序列是另一个的初始子序列，则较短的序列可被视为较小（较少）的序列。 对于字符串来说，字典式顺序使用 Unicode 码位序号排序单个字符。下面列出了一些比较相同类型序列的例子：

```
(1, 2, 3)              < (1, 2, 4)
[1, 2, 3]              < [1, 2, 4]
'ABC' < 'C' < 'Pascal' < 'Python'
(1, 2, 3, 4)           < (1, 2, 4)
(1, 2)                 < (1, 2, -1)
(1, 2, 3)             == (1.0, 2.0, 3.0)
(1, 2, ('aa', 'ab'))   < (1, 2, ('abc', 'a'), 4)
```

注意，对不同类型的对象来说，只要待比较的对象提供了合适的比较方法，就可以使用 `<` 和 `>` 进行比较。例如，混合数值类型通过数值进行比较，所以，0 等于 0.0，等等。否则，解释器不会随便给出一个对比结果，而是触发 [`TypeError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#TypeError) 异常。

备注

- [1](https://docs.python.org/zh-cn/3.11/tutorial/datastructures.html#id1)

  别的语言可能会返回可变对象，允许方法连续执行，例如，`d->insert("a")->remove("b")->sort();`。



# 6. 模块

退出 Python 解释器后，再次进入时，之前在 Python 解释器中定义的函数和变量就丢失了。因此，编写较长程序时，建议用文本编辑器代替解释器，执行文件中的输入内容，这就是编写 *脚本* 。随着程序越来越长，为了方便维护，最好把脚本拆分成多个文件。编写脚本还一个好处，不同程序调用同一个函数时，不用每次把函数复制到各个程序。

为实现这些需求，Python 把各种定义存入一个文件，在脚本或解释器的交互式实例中使用。这个文件就是 *模块* ；模块中的定义可以 *导入* 到其他模块或 *主* 模块（在顶层和计算器模式下，执行脚本中可访问的变量集）。

模块是包含 Python 定义和语句的文件。其文件名是模块名加后缀名 `.py` 。在模块内部，通过全局变量 `__name__` 可以获取模块名（即字符串）。例如，用文本编辑器在当前目录下创建 `fibo.py` 文件，输入以下内容：

```
# Fibonacci numbers module

def fib(n):    # write Fibonacci series up to n
    a, b = 0, 1
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print()

def fib2(n):   # return Fibonacci series up to n
    result = []
    a, b = 0, 1
    while a < n:
        result.append(a)
        a, b = b, a+b
    return result
```

现在，进入 Python 解释器，用以下命令导入该模块：

\>>>

```

import fibo
```

This does not add the names of the functions defined in `fibo`  directly to the current [namespace](https://docs.python.org/zh-cn/3.11/glossary.html#term-namespace) (see [Python 作用域和命名空间](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#tut-scopes) for more details); it only adds the module name `fibo` there. Using the module name you can access the functions:

\>>>

```

fibo.fib(1000)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987
fibo.fib2(100)
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
fibo.__name__
'fibo'
```

如果经常使用某个函数，可以把它赋值给局部变量：

\>>>

```

fib = fibo.fib
fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```



## 6.1. 模块详解

模块包含可执行语句及函数定义。这些语句用于初始化模块，且仅在 import 语句 *第一次* 遇到模块名时执行。[1](https://docs.python.org/zh-cn/3.11/tutorial/modules.html#id3) (文件作为脚本运行时，也会执行这些语句。)

Each module has its own private namespace, which is used as the global namespace by all functions defined in the module. Thus, the author of a module can use global variables in the module without worrying about accidental clashes with a user's global variables. On the other hand, if you know what you are doing you can touch a module's global variables with the same notation used to refer to its functions, `modname.itemname`.

Modules can import other modules.  It is customary but not required to place all [`import`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#import) statements at the beginning of a module (or script, for that matter).  The imported module names, if placed at the top level of a module (outside any functions or classes), are added to the module's global namespace.

There is a variant of the [`import`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#import) statement that imports names from a module directly into the importing module's namespace.  For example:

\>>>

```

from fibo import fib, fib2
fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

This does not introduce the module name from which the imports are taken in the local namespace (so in the example, `fibo` is not defined).

还有一种变体可以导入模块内定义的所有名称：

\>>>

```

from fibo import *
fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

这种方式会导入所有不以下划线（`_`）开头的名称。大多数情况下，不要用这个功能，这种方式向解释器导入了一批未知的名称，可能会覆盖已经定义的名称。

注意，一般情况下，不建议从模块或包内导入 `*`， 因为，这项操作经常让代码变得难以理解。不过，为了在交互式编译器中少打几个字，这么用也没问题。

模块名后使用 `as` 时，直接把 `as` 后的名称与导入模块绑定。

\>>>

```

import fibo as fib
fib.fib(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

与 `import fibo` 一样，这种方式也可以有效地导入模块，唯一的区别是，导入的名称是 `fib`。

[`from`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#from) 中也可以使用这种方式，效果类似：

\>>>

```

from fibo import fib as fibonacci
fibonacci(500)
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

备注

为了保证运行效率，每次解释器会话只导入一次模块。如果更改了模块内容，必须重启解释器；仅交互测试一个模块时，也可以使用 [`importlib.reload()`](https://docs.python.org/zh-cn/3.11/library/importlib.html#importlib.reload)，例如 `import importlib; importlib.reload(modulename)`。



### 6.1.1. 以脚本方式执行模块

可以用以下方式运行 Python 模块：

```
python fibo.py <arguments>
```

这项操作将执行模块里的代码，和导入模块一样，但会把 `__name__` 赋值为 `"__main__"`。 也就是把下列代码添加到模块末尾：

```
if __name__ == "__main__":
    import sys
    fib(int(sys.argv[1]))
```

既可以把这个文件当脚本使用，也可以用作导入的模块， 因为，解析命令行的代码只有在模块以 “main” 文件执行时才会运行：

```
python fibo.py 50
0 1 1 2 3 5 8 13 21 34
```

导入模块时，不运行这些代码：

\>>>

```

import fibo
>>>
```

这种操作常用于为模块提供便捷用户接口，或用于测试（把模块当作执行测试套件的脚本运行）。



### 6.1.2. 模块搜索路径

当一个名为 `spam` 的模块被导入时，解释器首先搜索具有该名称的内置模块。这些模块的名字被列在 [`sys.builtin_module_names`](https://docs.python.org/zh-cn/3.11/library/sys.html#sys.builtin_module_names) 中。如果没有找到，它就在变量 [`sys.path`](https://docs.python.org/zh-cn/3.11/library/sys.html#sys.path) 给出的目录列表中搜索一个名为 `spam.py` 的文件， [`sys.path`](https://docs.python.org/zh-cn/3.11/library/sys.html#sys.path) 从这些位置初始化:

- 输入脚本的目录（或未指定文件时的当前目录）。
- [`PYTHONPATH`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#envvar-PYTHONPATH) （目录列表，与 shell 变量 `PATH` 的语法一样）。
- 依赖于安装的默认值（按照惯例包括一个 `site-packages` 目录，由 [`site`](https://docs.python.org/zh-cn/3.11/library/site.html#module-site) 模块处理）。

More details are at [The initialization of the sys.path module search path](https://docs.python.org/zh-cn/3.11/library/sys_path_init.html#sys-path-init).

备注

在支持 symlink 的文件系统中，输入脚本目录是在追加 symlink 后计算出来的。换句话说，包含 symlink 的目录并 **没有** 添加至模块搜索路径。

初始化后，Python 程序可以更改 [`sys.path`](https://docs.python.org/zh-cn/3.11/library/sys.html#sys.path)。运行脚本的目录在标准库路径之前，置于搜索路径的开头。即，加载的是该目录里的脚本，而不是标准库的同名模块。 除非刻意替换，否则会报错。详见 [标准模块](https://docs.python.org/zh-cn/3.11/tutorial/modules.html#tut-standardmodules)。



### 6.1.3. “已编译的” Python 文件

为了快速加载模块，Python 把模块的编译版缓存在 `__pycache__` 目录中，文件名为 `module.*version*.pyc`，version 对编译文件格式进行编码，一般是 Python 的版本号。例如，CPython 的 3.3 发行版中，spam.py 的编译版本缓存为 `__pycache__/spam.cpython-33.pyc`。使用这种命名惯例，可以让不同 Python 发行版及不同版本的已编译模块共存。

Python 对比编译版本与源码的修改日期，查看它是否已过期，是否要重新编译，此过程完全自动化。此外，编译模块与平台无关，因此，可在不同架构系统之间共享相同的支持库。

Python 在两种情况下不检查缓存。其一，从命令行直接载入模块，只重新编译，不存储编译结果；其二，没有源模块，就不会检查缓存。为了支持无源文件（仅编译）发行版本， 编译模块必须在源目录下，并且绝不能有源模块。

给专业人士的一些小建议：

- 在 Python 命令中使用 [`-O`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-O) 或 [`-OO`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-OO) 开关，可以减小编译模块的大小。`-O` 去除断言语句，`-OO` 去除断言语句和 __doc__ 字符串。有些程序可能依赖于这些内容，因此，没有十足的把握，不要使用这两个选项。“优化过的”模块带有 `opt-` 标签，并且文件通常会一小些。将来的发行版或许会改进优化的效果。
- 从 `.pyc` 文件读取的程序不比从 `.py` 读取的执行速度快，`.pyc` 文件只是加载速度更快。
- [`compileall`](https://docs.python.org/zh-cn/3.11/library/compileall.html#module-compileall) 模块可以为一个目录下的所有模块创建 .pyc 文件。
- 本过程的细节及决策流程图，详见 [**PEP 3147**](https://peps.python.org/pep-3147/)。



## 6.2. 标准模块

Python 自带一个标准模块的库，它在 Python 库参考（此处以下称为"库参考" ）里另外描述。   一些模块是内嵌到编译器里面的， 它们给一些虽并非语言核心但却内嵌的操作提供接口，要么是为了效率，要么是给操作系统基础操作例如系统调入提供接口。  这些模块集是一个配置选项， 并且还依赖于底层的操作系统。 例如，[`winreg`](https://docs.python.org/zh-cn/3.11/library/winreg.html#module-winreg) 模块只在 Windows 系统上提供。一个特别值得注意的模块 [`sys`](https://docs.python.org/zh-cn/3.11/library/sys.html#module-sys)，它被内嵌到每一个 Python 编译器中。`sys.ps1` 和 `sys.ps2` 变量定义了一些字符，它们可以用作主提示符和辅助提示符:

\>>>

```

import sys
sys.ps1
'>>> '
sys.ps2
'... '
sys.ps1 = 'C> '
C> print('Yuck!')
Yuck!
C>
```

只有解释器用于交互模式时，才定义这两个变量。

变量 `sys.path` 是字符串列表，用于确定解释器的模块搜索路径。该变量以环境变量 [`PYTHONPATH`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#envvar-PYTHONPATH) 提取的默认路径进行初始化，如未设置 [`PYTHONPATH`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#envvar-PYTHONPATH)，则使用内置的默认路径。可以用标准列表操作修改该变量：

\>>>

```

import sys
sys.path.append('/ufs/guido/lib/python')
```



## 6.3. [`dir()`](https://docs.python.org/zh-cn/3.11/library/functions.html#dir) 函数

内置函数 [`dir()`](https://docs.python.org/zh-cn/3.11/library/functions.html#dir) 用于查找模块定义的名称。返回结果是经过排序的字符串列表：

\>>>

```

import fibo, sys
dir(fibo)
['__name__', 'fib', 'fib2']
dir(sys)  
['__breakpointhook__', '__displayhook__', '__doc__', '__excepthook__',
 '__interactivehook__', '__loader__', '__name__', '__package__', '__spec__',
 '__stderr__', '__stdin__', '__stdout__', '__unraisablehook__',
 '_clear_type_cache', '_current_frames', '_debugmallocstats', '_framework',
 '_getframe', '_git', '_home', '_xoptions', 'abiflags', 'addaudithook',
 'api_version', 'argv', 'audit', 'base_exec_prefix', 'base_prefix',
 'breakpointhook', 'builtin_module_names', 'byteorder', 'call_tracing',
 'callstats', 'copyright', 'displayhook', 'dont_write_bytecode', 'exc_info',
 'excepthook', 'exec_prefix', 'executable', 'exit', 'flags', 'float_info',
 'float_repr_style', 'get_asyncgen_hooks', 'get_coroutine_origin_tracking_depth',
 'getallocatedblocks', 'getdefaultencoding', 'getdlopenflags',
 'getfilesystemencodeerrors', 'getfilesystemencoding', 'getprofile',
 'getrecursionlimit', 'getrefcount', 'getsizeof', 'getswitchinterval',
 'gettrace', 'hash_info', 'hexversion', 'implementation', 'int_info',
 'intern', 'is_finalizing', 'last_traceback', 'last_type', 'last_value',
 'maxsize', 'maxunicode', 'meta_path', 'modules', 'path', 'path_hooks',
 'path_importer_cache', 'platform', 'prefix', 'ps1', 'ps2', 'pycache_prefix',
 'set_asyncgen_hooks', 'set_coroutine_origin_tracking_depth', 'setdlopenflags',
 'setprofile', 'setrecursionlimit', 'setswitchinterval', 'settrace', 'stderr',
 'stdin', 'stdout', 'thread_info', 'unraisablehook', 'version', 'version_info',
 'warnoptions']
```

没有参数时，[`dir()`](https://docs.python.org/zh-cn/3.11/library/functions.html#dir) 列出当前定义的名称：

\>>>

```

a = [1, 2, 3, 4, 5]
import fibo
fib = fibo.fib
dir()
['__builtins__', '__name__', 'a', 'fib', 'fibo', 'sys']
```

注意，该函数列出所有类型的名称：变量、模块、函数等。

[`dir()`](https://docs.python.org/zh-cn/3.11/library/functions.html#dir) 不会列出内置函数和变量的名称。这些内容的定义在标准模块 [`builtins`](https://docs.python.org/zh-cn/3.11/library/builtins.html#module-builtins) 里：

\>>>

```

import builtins
dir(builtins)  
['ArithmeticError', 'AssertionError', 'AttributeError', 'BaseException',
 'BlockingIOError', 'BrokenPipeError', 'BufferError', 'BytesWarning',
 'ChildProcessError', 'ConnectionAbortedError', 'ConnectionError',
 'ConnectionRefusedError', 'ConnectionResetError', 'DeprecationWarning',
 'EOFError', 'Ellipsis', 'EnvironmentError', 'Exception', 'False',
 'FileExistsError', 'FileNotFoundError', 'FloatingPointError',
 'FutureWarning', 'GeneratorExit', 'IOError', 'ImportError',
 'ImportWarning', 'IndentationError', 'IndexError', 'InterruptedError',
 'IsADirectoryError', 'KeyError', 'KeyboardInterrupt', 'LookupError',
 'MemoryError', 'NameError', 'None', 'NotADirectoryError', 'NotImplemented',
 'NotImplementedError', 'OSError', 'OverflowError',
 'PendingDeprecationWarning', 'PermissionError', 'ProcessLookupError',
 'ReferenceError', 'ResourceWarning', 'RuntimeError', 'RuntimeWarning',
 'StopIteration', 'SyntaxError', 'SyntaxWarning', 'SystemError',
 'SystemExit', 'TabError', 'TimeoutError', 'True', 'TypeError',
 'UnboundLocalError', 'UnicodeDecodeError', 'UnicodeEncodeError',
 'UnicodeError', 'UnicodeTranslateError', 'UnicodeWarning', 'UserWarning',
 'ValueError', 'Warning', 'ZeroDivisionError', '_', '__build_class__',
 '__debug__', '__doc__', '__import__', '__name__', '__package__', 'abs',
 'all', 'any', 'ascii', 'bin', 'bool', 'bytearray', 'bytes', 'callable',
 'chr', 'classmethod', 'compile', 'complex', 'copyright', 'credits',
 'delattr', 'dict', 'dir', 'divmod', 'enumerate', 'eval', 'exec', 'exit',
 'filter', 'float', 'format', 'frozenset', 'getattr', 'globals', 'hasattr',
 'hash', 'help', 'hex', 'id', 'input', 'int', 'isinstance', 'issubclass',
 'iter', 'len', 'license', 'list', 'locals', 'map', 'max', 'memoryview',
 'min', 'next', 'object', 'oct', 'open', 'ord', 'pow', 'print', 'property',
 'quit', 'range', 'repr', 'reversed', 'round', 'set', 'setattr', 'slice',
 'sorted', 'staticmethod', 'str', 'sum', 'super', 'tuple', 'type', 'vars',
 'zip']
```



## 6.4. 包

包是一种用“点式模块名”构造 Python 模块命名空间的方法。例如，模块名 `A.B` 表示包 `A` 中名为 `B` 的子模块。正如模块可以区分不同模块之间的全局变量名称一样，点式模块名可以区分 NumPy 或 Pillow 等不同多模块包之间的模块名称。

假设要为统一处理声音文件与声音数据设计一个模块集（“包”）。声音文件的格式很多（通常以扩展名来识别，例如：`.wav`， `.aiff`， `.au`），因此，为了不同文件格式之间的转换，需要创建和维护一个不断增长的模块集合。为了实现对声音数据的不同处理（例如，混声、添加回声、均衡器功能、创造人工立体声效果），还要编写无穷无尽的模块流。下面这个分级文件树展示了这个包的架构：

```
sound/                          Top-level package
      __init__.py               Initialize the sound package
      formats/                  Subpackage for file format conversions
              __init__.py
              wavread.py
              wavwrite.py
              aiffread.py
              aiffwrite.py
              auread.py
              auwrite.py
              ...
      effects/                  Subpackage for sound effects
              __init__.py
              echo.py
              surround.py
              reverse.py
              ...
      filters/                  Subpackage for filters
              __init__.py
              equalizer.py
              vocoder.py
              karaoke.py
              ...
```

导入包时，Python 搜索 `sys.path` 里的目录，查找包的子目录。

The `__init__.py` files are required to make Python treat directories containing the file as packages.  This prevents directories with a common name, such as `string`, from unintentionally hiding valid modules that occur later on the module search path. In the simplest case, `__init__.py` can just be an empty file, but it can also execute initialization code for the package or set the `__all__` variable, described later.

还可以从包中导入单个模块，例如：

```
import sound.effects.echo
```

这段代码加载子模块 `sound.effects.echo` ，但引用时必须使用子模块的全名：

```
sound.effects.echo.echofilter(input, output, delay=0.7, atten=4)
```

另一种导入子模块的方法是 ：

```
from sound.effects import echo
```

这段代码还可以加载子模块 `echo` ，不加包前缀也可以使用。因此，可以按如下方式使用：

```
echo.echofilter(input, output, delay=0.7, atten=4)
```

Import 语句的另一种变体是直接导入所需的函数或变量：

```
from sound.effects.echo import echofilter
```

同样，这样也会加载子模块 `echo`，但可以直接使用函数 `echofilter()`：

```
echofilter(input, output, delay=0.7, atten=4)
```

注意，使用 `from package import item` 时，item 可以是包的子模块（或子包），也可以是包中定义的函数、类或变量等其他名称。`import` 语句首先测试包中是否定义了 item；如果未在包中定义，则假定 item 是模块，并尝试加载。如果找不到 item，则触发 [`ImportError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#ImportError) 异常。

相反，使用 `import item.subitem.subsubitem` 句法时，除最后一项外，每个 item 都必须是包；最后一项可以是模块或包，但不能是上一项中定义的类、函数或变量。



### 6.4.1. 从包中导入 *

使用 `from sound.effects import *` 时会发生什么？理想情况下，该语句在文件系统查找并导入包的所有子模块。这项操作花费的时间较长，并且导入子模块可能会产生不必要的副作用，这种副作用只有在显式导入子模块时才会发生。

唯一的解决方案是提供包的显式索引。[`import`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#import) 语句使用如下惯例：如果包的 `__init__.py` 代码定义了列表 `__all__`，运行 `from package import *` 时，它就是用于导入的模块名列表。发布包的新版本时，包的作者应更新此列表。如果包的作者认为没有必要在包中执行导入 * 操作，也可以不提供此列表。例如，`sound/effects/__init__.py` 文件包含以下代码：

```
__all__ = ["echo", "surround", "reverse"]
```

这将意味着将 `from sound.effects import *` 导入 `sound.effects` 包的三个命名的子模块。

如果没有定义 `__all__`，`from sound.effects import *` 语句 *不会* 把包 `sound.effects` 中所有子模块都导入到当前命名空间；该语句只确保导入包 `sound.effects` （可能还会运行 `__init__.py` 中的初始化代码），然后，再导入包中定义的名称。这些名称包括 `__init__.py` 中定义的任何名称（以及显式加载的子模块），还包括之前 [`import`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#import) 语句显式加载的包里的子模块。请看以下代码：

```
import sound.effects.echo
import sound.effects.surround
from sound.effects import *
```

本例中，执行 `from...import` 语句时，将把 `echo` 和 `surround` 模块导入至当前命名空间，因为，它们是在 `sound.effects` 包里定义的。（该导入操作在定义了 `__all__` 时也有效。）

虽然，可以把模块设计为用 `import *` 时只导出遵循指定模式的名称，但仍不提倡在生产代码中使用这种做法。

记住，使用 `from package import specific_submodule` 没有任何问题！ 实际上，除了导入模块使用不同包的同名子模块之外，这种方式是推荐用法。



### 6.4.2. 子包参考

包中含有多个子包时（与示例中的 `sound` 包一样），可以使用绝对导入引用兄弟包中的子模块。例如，要在模块 `sound.filters.vocoder` 中使用 `sound.effects` 包的 `echo` 模块时，可以用 `from sound.effects import echo` 导入。

还可以用 import 语句的 `from module import name` 形式执行相对导入。这些导入语句使用前导句点表示相对导入中的当前包和父包。例如，相对于 `surround` 模块，可以使用：

```
from . import echo
from .. import formats
from ..filters import equalizer
```

注意，相对导入基于当前模块名。因为主模块名是 `"__main__"` ，所以 Python 程序的主模块必须始终使用绝对导入。

### 6.4.3. 多目录中的包

包支持一个更特殊的属性 [`__path__`](https://docs.python.org/zh-cn/3.11/reference/import.html#path__) 。在包的 :[file:__init__.py](file:__init__.py) 文件中的代码被执行前，该属性被初始化为包含 :[file:__init__.py](file:__init__.py) 文件所在的目录名在内的列表。可以修改此变量；但这样做会影响在此包中搜索子模块和子包。

这个功能虽然不常用，但可用于扩展包中的模块集。

备注

- [1](https://docs.python.org/zh-cn/3.11/tutorial/modules.html#id1)

  In fact function definitions are also 'statements' that are 'executed'; the execution of a module-level function definition adds the function name to the module's global namespace.

# 7. 输入与输出

程序输出有几种显示方式；数据既可以输出供人阅读的形式，也可以写入文件备用。本章探讨一些可用的方式。



## 7.1. 更复杂的输出格式

至此，我们已学习了两种写入值的方法：*表达式语句* 和 [`print()`](https://docs.python.org/zh-cn/3.11/library/functions.html#print) 函数。第三种方法是使用文件对象的 `write()` 方法；标准输出文件称为 `sys.stdout`。详见标准库参考。

对输出格式的控制不只是打印空格分隔的值，还需要更多方式。格式化输出包括以下几种方法。

- 使用 [格式化字符串字面值](https://docs.python.org/zh-cn/3.11/tutorial/inputoutput.html#tut-f-strings) ，要在字符串开头的引号/三引号前添加 `f` 或 `F` 。在这种字符串中，可以在 `{` 和 `}` 字符之间输入引用的变量，或字面值的 Python 表达式。

  \>>>

  ```
  
  ```

```
year = 2016
event = 'Referendum'
f'Results of the {year} {event}'
'Results of the 2016 Referendum'
```

字符串的 [`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 方法需要更多手动操作。该方法也用 `{` 和 `}` 标记替换变量的位置，虽然这种方法支持详细的格式化指令，但需要提供格式化信息。

\>>>

```

yes_votes = 42_572_654
no_votes = 43_132_495
percentage = yes_votes / (yes_votes + no_votes)
```

- ```
  '{:-9} YES votes  {:2.2%}'.format(yes_votes, percentage)
  ' 42572654 YES votes  49.67%'
  ```

- 最后，还可以用字符串切片和合并操作完成字符串处理操作，创建任何排版布局。字符串类型还支持将字符串按给定列宽进行填充，这些方法也很有用。

如果不需要花哨的输出，只想快速显示变量进行调试，可以用 [`repr()`](https://docs.python.org/zh-cn/3.11/library/functions.html#repr) 或 [`str()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str) 函数把值转化为字符串。

[`str()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str) 函数返回供人阅读的值，[`repr()`](https://docs.python.org/zh-cn/3.11/library/functions.html#repr) 则生成适于解释器读取的值（如果没有等效的语法，则强制执行 [`SyntaxError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#SyntaxError)）。对于没有支持供人阅读展示结果的对象， [`str()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str) 返回与 [`repr()`](https://docs.python.org/zh-cn/3.11/library/functions.html#repr) 相同的值。一般情况下，数字、列表或字典等结构的值，使用这两个函数输出的表现形式是一样的。字符串有两种不同的表现形式。

示例如下：

\>>>

```

s = 'Hello, world.'
str(s)
'Hello, world.'
repr(s)
"'Hello, world.'"
str(1/7)
'0.14285714285714285'
x = 10 * 3.25
y = 200 * 200
s = 'The value of x is ' + repr(x) + ', and y is ' + repr(y) + '...'
print(s)
The value of x is 32.5, and y is 40000...
# The repr() of a string adds string quotes and backslashes:
hello = 'hello, world\n'
hellos = repr(hello)
print(hellos)
'hello, world\n'
# The argument to repr() may be any Python object:
repr((x, y, ('spam', 'eggs')))
"(32.5, 40000, ('spam', 'eggs'))"
```

[`string`](https://docs.python.org/zh-cn/3.11/library/string.html#module-string) 模块包含 [`Template`](https://docs.python.org/zh-cn/3.11/library/string.html#string.Template) 类，提供了将值替换为字符串的另一种方法。该类使用 `$x` 占位符，并用字典的值进行替换，但对格式控制的支持比较有限。



### 7.1.1. 格式化字符串字面值

[格式化字符串字面值](https://docs.python.org/zh-cn/3.11/reference/lexical_analysis.html#f-strings) （简称为 f-字符串）在字符串前加前缀 `f` 或 `F`，通过 `{expression}` 表达式，把 Python 表达式的值添加到字符串内。

格式说明符是可选的，写在表达式后面，可以更好地控制格式化值的方式。下例将 pi 舍入到小数点后三位：

\>>>

```

import math
print(f'The value of pi is approximately {math.pi:.3f}.')
The value of pi is approximately 3.142.
```

在 `':'` 后传递整数，为该字段设置最小字符宽度，常用于列对齐：

\>>>

```

table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
for name, phone in table.items():
    print(f'{name:10} ==> {phone:10d}')
Sjoerd     ==>       4127
Jack       ==>       4098
Dcab       ==>       7678
```

还有一些修饰符可以在格式化前转换值。 `'!a'` 应用 [`ascii()`](https://docs.python.org/zh-cn/3.11/library/functions.html#ascii) ，`'!s'` 应用 [`str()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str)，`'!r'` 应用 [`repr()`](https://docs.python.org/zh-cn/3.11/library/functions.html#repr)：

\>>>

```

animals = 'eels'
print(f'My hovercraft is full of {animals}.')
My hovercraft is full of eels.
print(f'My hovercraft is full of {animals!r}.')
My hovercraft is full of 'eels'.
```

The `=` specifier can be used to expand an expression to the text of the expression, an equal sign, then the representation of the evaluated expression:

\>>>

```

bugs = 'roaches'
count = 13
area = 'living room'
print(f'Debugging {bugs=} {count=} {area=}')
Debugging bugs='roaches' count=13 area='living room'
```

See [self-documenting expressions](https://docs.python.org/zh-cn/3.11/whatsnew/3.8.html#bpo-36817-whatsnew) for more information on the `=` specifier. For a reference on these format specifications, see the reference guide for the [格式规格迷你语言](https://docs.python.org/zh-cn/3.11/library/string.html#formatspec).



### 7.1.2. 字符串 format() 方法

[`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 方法的基本用法如下所示：

\>>>

```

print('We are the {} who say "{}!"'.format('knights', 'Ni'))
We are the knights who say "Ni!"
```

花括号及之内的字符（称为格式字段）被替换为传递给 [`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 方法的对象。花括号中的数字表示传递给 [`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 方法的对象所在的位置。

\>>>

```

print('{0} and {1}'.format('spam', 'eggs'))
spam and eggs
print('{1} and {0}'.format('spam', 'eggs'))
eggs and spam
```

[`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 方法中使用关键字参数名引用值。

\>>>

```

print('This {food} is {adjective}.'.format(
      food='spam', adjective='absolutely horrible'))
This spam is absolutely horrible.
```

位置参数和关键字参数可以任意组合：

\>>>

```

print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred',
                                                   other='Georg'))
The story of Bill, Manfred, and Georg.
```

如果不想分拆较长的格式字符串，最好按名称引用变量进行格式化，不要按位置。这项操作可以通过传递字典，并用方括号 `'[]'` 访问键来完成。

\>>>

```

table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
print('Jack: {0[Jack]:d}; Sjoerd: {0[Sjoerd]:d}; '
      'Dcab: {0[Dcab]:d}'.format(table))
Jack: 4098; Sjoerd: 4127; Dcab: 8637678
```

This could also be done by passing the `table` dictionary as keyword arguments with the `**` notation.

\>>>

```

table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
print('Jack: {Jack:d}; Sjoerd: {Sjoerd:d}; Dcab: {Dcab:d}'.format(**table))
Jack: 4098; Sjoerd: 4127; Dcab: 8637678
```

与内置函数 [`vars()`](https://docs.python.org/zh-cn/3.11/library/functions.html#vars) 结合使用时，这种方式非常实用，可以返回包含所有局部变量的字典。

As an example, the following lines produce a tidily aligned set of columns giving integers and their squares and cubes:

\>>>

```

for x in range(1, 11):
    print('{0:2d} {1:3d} {2:4d}'.format(x, x*x, x*x*x))
 1   1    1
 2   4    8
 3   9   27
 4  16   64
 5  25  125
 6  36  216
 7  49  343
 8  64  512
 9  81  729
10 100 1000
```

[`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 进行字符串格式化的完整概述详见 [格式字符串语法](https://docs.python.org/zh-cn/3.11/library/string.html#formatstrings) 。

### 7.1.3. 手动格式化字符串

下面是使用手动格式化方式实现的同一个平方和立方的表：

\>>>

```

for x in range(1, 11):
    print(repr(x).rjust(2), repr(x*x).rjust(3), end=' ')
    # Note use of 'end' on previous line
    print(repr(x*x*x).rjust(4))
 1   1    1
 2   4    8
 3   9   27
 4  16   64
 5  25  125
 6  36  216
 7  49  343
 8  64  512
 9  81  729
10 100 1000
```

（注意，每列之间的空格是通过使用 [`print()`](https://docs.python.org/zh-cn/3.11/library/functions.html#print) 添加的：它总在其参数间添加空格。）

字符串对象的 [`str.rjust()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.rjust) 方法通过在左侧填充空格，对给定宽度字段中的字符串进行右对齐。同类方法还有 [`str.ljust()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.ljust) 和 [`str.center()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.center) 。这些方法不写入任何内容，只返回一个新字符串，如果输入的字符串太长，它们不会截断字符串，而是原样返回；虽然这种方式会弄乱列布局，但也比另一种方法好，后者在显示值时可能不准确（如果真的想截断字符串，可以使用 `x.ljust(n)[:n]` 这样的切片操作 。）

另一种方法是 [`str.zfill()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.zfill) ，该方法在数字字符串左边填充零，且能识别正负号：

\>>>

```

'12'.zfill(5)
'00012'
'-3.14'.zfill(7)
'-003.14'
'3.14159265359'.zfill(5)
'3.14159265359'
```

### 7.1.4. 旧式字符串格式化方法

% 运算符（求余符）也可用于字符串格式化。给定 `'string' % values`，则 `string` 中的 `%` 实例会以零个或多个 `values` 元素替换。此操作被称为字符串插值。例如：

\>>>

```

import math
print('The value of pi is approximately %5.3f.' % math.pi)
The value of pi is approximately 3.142.
```

[printf 风格的字符串格式化](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#old-string-formatting) 小节介绍更多相关内容。



## 7.2. 读写文件

[`open()`](https://docs.python.org/zh-cn/3.11/library/functions.html#open) 返回一个 [file object](https://docs.python.org/zh-cn/3.11/glossary.html#term-file-object) ，最常使用的是两个位置参数和一个关键字参数：`open(filename, mode, encoding=None)`

\>>>

```

f = open('workfile', 'w', encoding="utf-8")
```

第一个实参是文件名字符串。第二个实参是包含描述文件使用方式字符的字符串。*mode* 的值包括 `'r'` ，表示文件只能读取；`'w'` 表示只能写入（现有同名文件会被覆盖）；`'a'` 表示打开文件并追加内容，任何写入的数据会自动添加到文件末尾。`'r+'` 表示打开文件进行读写。*mode* 实参是可选的，省略时的默认值为 `'r'`。

通常情况下，文件是以 *text mode* 打开的，也就是说，你从文件中读写字符串，这些字符串是以特定的 *encoding* 编码的。如果没有指定 *encoding* ，默认的是与平台有关的（见 [`open()`](https://docs.python.org/zh-cn/3.11/library/functions.html#open) ）。因为 UTF-8 是现代事实上的标准，除非你知道你需要使用一个不同的编码，否则建议使用 `encoding="utf-8"` 。在模式后面加上一个 `'b'` ，可以用 *binary mode* 打开文件。二进制模式的数据是以 [`bytes`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#bytes) 对象的形式读写的。在二进制模式下打开文件时，你不能指定 *encoding* 。

在文本模式下读取文件时，默认把平台特定的行结束符（Unix 上为 `\n`, Windows 上为 `\r\n`）转换为 `\n`。在文本模式下写入数据时，默认把 `\n` 转换回平台特定结束符。这种操作方式在后台修改文件数据对文本文件来说没有问题，但会破坏 `JPEG` 或 `EXE` 等二进制文件中的数据。注意，在读写此类文件时，一定要使用二进制模式。

在处理文件对象时，最好使用 [`with`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#with) 关键字。优点是，子句体结束后，文件会正确关闭，即便触发异常也可以。而且，使用 `with` 相比等效的 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try)-[`finally`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#finally) 代码块要简短得多：

\>>>

```

with open('workfile', encoding="utf-8") as f:
    read_data = f.read()
# We can check that the file has been automatically closed.
f.closed
True
```

如果没有使用 [`with`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#with) 关键字，则应调用 `f.close()` 关闭文件，即可释放文件占用的系统资源。

警告

调用 `f.write()` 时，未使用 `with` 关键字，或未调用 `f.close()`，即使程序正常退出，也**可能** 导致 `f.write()` 的参数没有完全写入磁盘。

通过 [`with`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#with) 语句，或调用 `f.close()` 关闭文件对象后，再次使用该文件对象将会失败。

\>>>

```

f.close()
f.read()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ValueError: I/O operation on closed file.
```



### 7.2.1. 文件对象的方法

本节下文中的例子假定已创建 `f` 文件对象。

`f.read(size)` 可用于读取文件内容，它会读取一些数据，并返回字符串（文本模式），或字节串对象（在二进制模式下）。 *size* 是可选的数值参数。省略 *size* 或 *size* 为负数时，读取并返回整个文件的内容；文件大小是内存的两倍时，会出现问题。*size* 取其他值时，读取并返回最多 *size* 个字符（文本模式）或 *size* 个字节（二进制模式）。如已到达文件末尾，`f.read()` 返回空字符串（`''`）。

\>>>

```

f.read()
'This is the entire file.\n'
f.read()
''
```

`f.readline()` 从文件中读取单行数据；字符串末尾保留换行符（`\n`），只有在文件不以换行符结尾时，文件的最后一行才会省略换行符。这种方式让返回值清晰明确；只要 `f.readline()` 返回空字符串，就表示已经到达了文件末尾，空行使用 `'\n'` 表示，该字符串只包含一个换行符。

\>>>

```

f.readline()
'This is the first line of the file.\n'
f.readline()
'Second line of the file\n'
f.readline()
''
```

从文件中读取多行时，可以用循环遍历整个文件对象。这种操作能高效利用内存，快速，且代码简单：

\>>>

```

for line in f:
    print(line, end='')
This is the first line of the file.
Second line of the file
```

如需以列表形式读取文件中的所有行，可以用 `list(f)` 或 `f.readlines()`。

`f.write(string)` 把 *string* 的内容写入文件，并返回写入的字符数。

\>>>

```

f.write('This is a test\n')
15
```

写入其他类型的对象前，要先把它们转化为字符串（文本模式）或字节对象（二进制模式）：

\>>>

```

value = ('the answer', 42)
s = str(value)  # convert the tuple to string
f.write(s)
18
```

`f.tell()` 返回整数，给出文件对象在文件中的当前位置，表示为二进制模式下时从文件开始的字节数，以及文本模式下的意义不明的数字。

`f.seek(offset, whence)` 可以改变文件对象的位置。通过向参考点添加 *offset* 计算位置；参考点由 *whence* 参数指定。 *whence* 值为 0 时，表示从文件开头计算，1 表示使用当前文件位置，2 表示使用文件末尾作为参考点。省略 *whence* 时，其默认值为 0，即使用文件开头作为参考点。

\>>>

```

f = open('workfile', 'rb+')
f.write(b'0123456789abcdef')
16
f.seek(5)      # Go to the 6th byte in the file
5
f.read(1)
b'5'
f.seek(-3, 2)  # Go to the 3rd byte before the end
13
f.read(1)
b'd'
```

在文本文件（模式字符串未使用 `b` 时打开的文件）中，只允许相对于文件开头搜索（使用 `seek(0, 2)` 搜索到文件末尾是个例外），唯一有效的 *offset* 值是能从 `f.tell()` 中返回的，或 0。其他 *offset* 值都会产生未定义的行为。

文件对象还支持 `isatty()` 和 `truncate()`  等方法，但不常用；文件对象的完整指南详见库参考。



### 7.2.2. 使用 [`json`](https://docs.python.org/zh-cn/3.11/library/json.html#module-json) 保存结构化数据

从文件写入或读取字符串很简单，数字则稍显麻烦，因为 `read()` 方法只返回字符串，这些字符串必须传递给 [`int()`](https://docs.python.org/zh-cn/3.11/library/functions.html#int) 这样的函数，接受 `'123'` 这样的字符串，并返回数字值 123。保存嵌套列表、字典等复杂数据类型时，手动解析和序列化的操作非常复杂。

Rather than having users constantly writing and debugging code to save complicated data types to files, Python allows you to use the popular data interchange format called [JSON (JavaScript Object Notation)](https://json.org).  The standard module called [`json`](https://docs.python.org/zh-cn/3.11/library/json.html#module-json) can take Python data hierarchies, and convert them to string representations; this process is called *serializing*.  Reconstructing the data from the string representation is called *deserializing*.  Between serializing and deserializing, the string representing the object may have been stored in a file or data, or sent over a network connection to some distant machine.

备注

JSON 格式通常用于现代应用程序的数据交换。程序员早已对它耳熟能详，可谓是交互操作的不二之选。

只需一行简单的代码即可查看某个对象的 JSON 字符串表现形式：

\>>>

```

import json
x = [1, 'simple', 'list']
json.dumps(x)
'[1, "simple", "list"]'
```

[`dumps()`](https://docs.python.org/zh-cn/3.11/library/json.html#json.dumps) 函数还有一个变体， [`dump()`](https://docs.python.org/zh-cn/3.11/library/json.html#json.dump) ，它只将对象序列化为 [text file](https://docs.python.org/zh-cn/3.11/glossary.html#term-text-file) 。因此，如果 `f` 是 [text file](https://docs.python.org/zh-cn/3.11/glossary.html#term-text-file) 对象，可以这样做：

```
json.dump(x, f)
```

要再次解码对象，如果 `f` 是已打开、供读取的 [binary file](https://docs.python.org/zh-cn/3.11/glossary.html#term-binary-file) 或 [text file](https://docs.python.org/zh-cn/3.11/glossary.html#term-text-file) 对象：

```
x = json.load(f)
```

备注

JSON文件必须以UTF-8编码。当打开JSON文件作为一个 [text file](https://docs.python.org/zh-cn/3.11/glossary.html#term-text-file) 用于读写时，使用 `encoding="utf-8"` 。

这种简单的序列化技术可以处理列表和字典，但在 JSON 中序列化任意类的实例，则需要付出额外努力。[`json`](https://docs.python.org/zh-cn/3.11/library/json.html#module-json) 模块的参考包含对此的解释。

参见

[`pickle`](https://docs.python.org/zh-cn/3.11/library/pickle.html#module-pickle) - 封存模块

与 [JSON](https://docs.python.org/zh-cn/3.11/tutorial/inputoutput.html#tut-json) 不同，*pickle* 是一种允许对复杂 Python 对象进行序列化的协议。因此，它为 Python  所特有，不能用于与其他语言编写的应用程序通信。默认情况下它也是不安全的：如果解序化的数据是由手段高明的攻击者精心设计的，这种不受信任来源的  pickle 数据可以执行任意代码。

# 8. 错误和异常

至此，本教程还未深入介绍错误信息，但如果您输入过本教程前文中的例子，应该已经看到过一些错误信息。目前，（至少）有两种不同错误：*句法错误* 和 *异常*。



## 8.1. 句法错误

句法错误又称解析错误，是学习 Python 时最常见的错误：

\>>>

```

while True print('Hello world')
  File "<stdin>", line 1
    while True print('Hello world')
                   ^
SyntaxError: invalid syntax
```

解析器会复现出现句法错误的代码行，并用小“箭头”指向行里检测到的第一个错误。错误是由箭头 *上方* 的 token 触发的（至少是在这里检测出的）：本例中，在 [`print()`](https://docs.python.org/zh-cn/3.11/library/functions.html#print) 函数中检测到错误，因为，在它前面缺少冒号（`':'`） 。错误信息还输出文件名与行号，在使用脚本文件时，就可以知道去哪里查错。



## 8.2. 异常

即使语句或表达式使用了正确的语法，执行时仍可能触发错误。执行时检测到的错误称为 *异常*，异常不一定导致严重的后果：很快我们就能学会如何处理 Python 的异常。大多数异常不会被程序处理，而是显示下列错误信息：

\>>>

```

10 * (1/0)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ZeroDivisionError: division by zero
4 + spam*3
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'spam' is not defined
'2' + 2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: can only concatenate str (not "int") to str
```

错误信息的最后一行说明程序遇到了什么类型的错误。异常有不同的类型，而类型名称会作为错误信息的一部分中打印出来：上述示例中的异常类型依次是：[`ZeroDivisionError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#ZeroDivisionError)， [`NameError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#NameError) 和 [`TypeError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#TypeError)。作为异常类型打印的字符串是发生的内置异常的名称。对于所有内置异常都是如此，但对于用户定义的异常则不一定如此（虽然这种规范很有用）。标准的异常类型是内置的标识符（不是保留关键字）。

此行其余部分根据异常类型，结合出错原因，说明错误细节。

错误信息开头用堆栈回溯形式展示发生异常的语境。一般会列出源代码行的堆栈回溯；但不会显示从标准输入读取的行。

[内置异常](https://docs.python.org/zh-cn/3.11/library/exceptions.html#bltin-exceptions) 列出了内置异常及其含义。



## 8.3. 异常的处理

可以编写程序处理选定的异常。下例会要求用户一直输入内容，直到输入有效的整数，但允许用户中断程序（使用 Control-C 或操作系统支持的其他操作）；注意，用户中断程序会触发 [`KeyboardInterrupt`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#KeyboardInterrupt) 异常。

\>>>

```

while True:
    try:
        x = int(input("Please enter a number: "))
        break
    except ValueError:
        print("Oops!  That was no valid number.  Try again...")
```

[`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句的工作原理如下：

- 首先，执行 *try 子句* （[`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 和 [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 关键字之间的（多行）语句）。
- 如果没有触发异常，则跳过 *except 子句*，[`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句执行完毕。
- 如果在执行 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 子句时发生了异常，则跳过该子句中剩下的部分。  如果异常的类型与 [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 关键字后指定的异常相匹配，则会执行 *except 子句*，然后跳到 try/except 代码块之后继续执行。
- 如果发生的异常与 *except 子句* 中指定的异常不匹配，则它会被传递到外部的 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句中；如果没有找到处理程序，则它是一个 *未处理异常* 且执行将终止并输出如上所示的消息。

[`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句可以有多个 *except 子句* 来为不同的异常指定处理程序。 但最多只有一个处理程序会被执行。 处理程序只处理对应的 *try 子句* 中发生的异常，而不处理同一 `try` 语句内其他处理程序中的异常。 *except 子句* 可以用带圆括号的元组来指定多个异常，例如:

```
... except (RuntimeError, TypeError, NameError):
...     pass
```

如果发生的异常与 [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 子句中的类是同一个类或是它的基类时，则该类与该异常相兼容（反之则不成立 --- 列出派生类的 *except 子句* 与基类不兼容）。 例如，下面的代码将依次打印 B, C, D:

```
class B(Exception):
    pass

class C(B):
    pass

class D(C):
    pass

for cls in [B, C, D]:
    try:
        raise cls()
    except D:
        print("D")
    except C:
        print("C")
    except B:
        print("B")
```

请注意如果颠倒 *except 子句* 的顺序（把 `except B` 放在最前），则会输出 B, B, B --- 即触发了第一个匹配的 *except 子句*。

When an exception occurs, it may have associated values, also known as the exception's *arguments*. The presence and types of the arguments depend on the exception type.

The *except clause* may specify a variable after the exception name.  The variable is bound to the exception instance which typically has an `args` attribute that stores the arguments. For convenience, builtin exception types define `__str__()` to print all the arguments without explicitly accessing `.args`.

\>>>

```

try:
    raise Exception('spam', 'eggs')
except Exception as inst:
    print(type(inst))    # the exception type
    print(inst.args)     # arguments stored in .args
    print(inst)          # __str__ allows args to be printed directly,
                         # but may be overridden in exception subclasses
    x, y = inst.args     # unpack args
    print('x =', x)
    print('y =', y)
<class 'Exception'>
('spam', 'eggs')
('spam', 'eggs')
x = spam
y = eggs
```

The exception's `__str__()` output is printed as the last part ('detail') of the message for unhandled exceptions.

[`BaseException`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#BaseException) is the common base class of all exceptions. One of its subclasses, [`Exception`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#Exception), is the base class of all the non-fatal exceptions. Exceptions which are not subclasses of [`Exception`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#Exception) are not typically handled, because they are used to indicate that the program should terminate. They include [`SystemExit`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#SystemExit) which is raised by [`sys.exit()`](https://docs.python.org/zh-cn/3.11/library/sys.html#sys.exit) and [`KeyboardInterrupt`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#KeyboardInterrupt) which is raised when a user wishes to interrupt the program.

[`Exception`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#Exception) can be used as a wildcard that catches (almost) everything. However, it is good practice to be as specific as possible with the types of exceptions that we intend to handle, and to allow any unexpected exceptions to propagate on.

The most common pattern for handling [`Exception`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#Exception) is to print or log the exception and then re-raise it (allowing a caller to handle the exception as well):

```
import sys

try:
    f = open('myfile.txt')
    s = f.readline()
    i = int(s.strip())
except OSError as err:
    print("OS error:", err)
except ValueError:
    print("Could not convert data to an integer.")
except Exception as err:
    print(f"Unexpected {err=}, {type(err)=}")
    raise
```

[`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) ... [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 语句具有可选的 *else 子句*，该子句如果存在，它必须放在所有 *except 子句* 之后。 它适用于 *try 子句* 没有引发异常但又必须要执行的代码。 例如:

```
for arg in sys.argv[1:]:
    try:
        f = open(arg, 'r')
    except OSError:
        print('cannot open', arg)
    else:
        print(arg, 'has', len(f.readlines()), 'lines')
        f.close()
```

使用 `else` 子句比向 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 子句添加额外的代码要好，可以避免意外捕获非 `try` ... `except` 语句保护的代码触发的异常。

Exception handlers do not handle only exceptions that occur immediately in the *try clause*, but also those that occur inside functions that are called (even indirectly) in the *try clause*. For example:

\>>>

```

def this_fails():
    x = 1/0

try:
    this_fails()
except ZeroDivisionError as err:
    print('Handling run-time error:', err)
Handling run-time error: division by zero
```



## 8.4. 触发异常

[`raise`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#raise) 语句支持强制触发指定的异常。例如：

\>>>

```

raise NameError('HiThere')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: HiThere
```

The sole argument to [`raise`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#raise) indicates the exception to be raised. This must be either an exception instance or an exception class (a class that derives from [`BaseException`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#BaseException), such as [`Exception`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#Exception) or one of its subclasses).  If an exception class is passed, it will be implicitly instantiated by calling its constructor with no arguments:

```
raise ValueError  # shorthand for 'raise ValueError()'
```

如果只想判断是否触发了异常，但并不打算处理该异常，则可以使用更简单的 [`raise`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#raise) 语句重新触发异常：

\>>>

```

try:
    raise NameError('HiThere')
except NameError:
    print('An exception flew by!')
    raise
An exception flew by!
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
NameError: HiThere
```



## 8.5. 异常链

If an unhandled exception occurs inside an [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) section, it will have the exception being handled attached to it and included in the error message:

\>>>

```

try:
    open("database.sqlite")
except OSError:
    raise RuntimeError("unable to handle error")
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
FileNotFoundError: [Errno 2] No such file or directory: 'database.sqlite'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "<stdin>", line 4, in <module>
RuntimeError: unable to handle error
```

To indicate that an exception is a direct consequence of another, the [`raise`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#raise) statement allows an optional [`from`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#raise) clause:

```
# exc must be exception instance or None.
raise RuntimeError from exc
```

转换异常时，这种方式很有用。例如：

\>>>

```

def func():
    raise ConnectionError

try:
    func()
except ConnectionError as exc:
    raise RuntimeError('Failed to open database') from exc
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
  File "<stdin>", line 2, in func
ConnectionError

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "<stdin>", line 4, in <module>
RuntimeError: Failed to open database
```

It also allows disabling automatic exception chaining using the `from None` idiom:

\>>>

```

try:
    open('database.sqlite')
except OSError:
    raise RuntimeError from None
Traceback (most recent call last):
  File "<stdin>", line 4, in <module>
RuntimeError
```

异常链机制详见 [内置异常](https://docs.python.org/zh-cn/3.11/library/exceptions.html#bltin-exceptions)。



## 8.6. 用户自定义异常

程序可以通过创建新的异常类命名自己的异常（Python 类的内容详见 [类](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#tut-classes)）。不论是以直接还是间接的方式，异常都应从 [`Exception`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#Exception) 类派生。

异常类可以被定义成能做其他类所能做的任何事，但通常应当保持简单，它往往只提供一些属性，允许相应的异常处理程序提取有关错误的信息。

大多数异常命名都以 “Error” 结尾，类似标准异常的命名。

Many standard modules define their own exceptions to report errors that may occur in functions they define.



## 8.7. 定义清理操作

[`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句还有一个可选子句，用于定义在所有情况下都必须要执行的清理操作。例如：

\>>>

```

try:
    raise KeyboardInterrupt
finally:
    print('Goodbye, world!')
Goodbye, world!
KeyboardInterrupt
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
```

如果存在 [`finally`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#finally) 子句，则 `finally` 子句是 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句结束前执行的最后一项任务。不论 `try` 语句是否触发异常，都会执行 `finally` 子句。以下内容介绍了几种比较复杂的触发异常情景：

- 如果执行 `try` 子句期间触发了某个异常，则某个 [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 子句应处理该异常。如果该异常没有 `except` 子句处理，在 `finally` 子句执行后会被重新触发。
- `except` 或 `else` 子句执行期间也会触发异常。 同样，该异常会在 `finally` 子句执行之后被重新触发。
- 如果 `finally` 子句中包含 [`break`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#break)、[`continue`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#continue) 或 [`return`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#return) 等语句，异常将不会被重新引发。
- 如果执行 `try` 语句时遇到 [`break`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#break),、[`continue`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#continue) 或 [`return`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#return) 语句，则 `finally` 子句在执行 `break`、`continue` 或 `return` 语句之前执行。
- 如果 `finally` 子句中包含 `return` 语句，则返回值来自 `finally` 子句的某个 `return` 语句的返回值，而不是来自 `try` 子句的 `return` 语句的返回值。

例如：

\>>>

```

def bool_return():
    try:
        return True
    finally:
        return False

bool_return()
False
```

这是一个比较复杂的例子：

\>>>

```

def divide(x, y):
    try:
        result = x / y
    except ZeroDivisionError:
        print("division by zero!")
    else:
        print("result is", result)
    finally:
        print("executing finally clause")

divide(2, 1)
result is 2.0
executing finally clause
divide(2, 0)
division by zero!
executing finally clause
divide("2", "1")
executing finally clause
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 3, in divide
TypeError: unsupported operand type(s) for /: 'str' and 'str'
```

如上所示，任何情况下都会执行 [`finally`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#finally) 子句。[`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 子句不处理两个字符串相除触发的 [`TypeError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#TypeError)，因此会在 `finally` 子句执行后被重新触发。

在实际应用程序中，[`finally`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#finally) 子句对于释放外部资源（例如文件或者网络连接）非常有用，无论是否成功使用资源。



## 8.8. 预定义的清理操作

某些对象定义了不需要该对象时要执行的标准清理操作。无论使用该对象的操作是否成功，都会执行清理操作。比如，下例要打开一个文件，并输出文件内容：

```
for line in open("myfile.txt"):
    print(line, end="")
```

这个代码的问题在于，执行完代码后，文件在一段不确定的时间内处于打开状态。在简单脚本中这没有问题，但对于较大的应用程序来说可能会出问题。[`with`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#with) 语句支持以及时、正确的清理的方式使用文件对象：

```
with open("myfile.txt") as f:
    for line in f:
        print(line, end="")
```

语句执行完毕后，即使在处理行时遇到问题，都会关闭文件 *f*。和文件一样，支持预定义清理操作的对象会在文档中指出这一点。



## 8.9. Raising and Handling Multiple Unrelated Exceptions

There are situations where it is necessary to report several exceptions that have occurred. This is often the case in concurrency frameworks, when several tasks may have failed in parallel, but there are also other use cases where it is desirable to continue execution and collect multiple errors rather than raise the first exception.

The builtin [`ExceptionGroup`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#ExceptionGroup) wraps a list of exception instances so that they can be raised together. It is an exception itself, so it can be caught like any other exception.

\>>>

```

def f():
    excs = [OSError('error 1'), SystemError('error 2')]
    raise ExceptionGroup('there were problems', excs)

f()
  + Exception Group Traceback (most recent call last):
  |   File "<stdin>", line 1, in <module>
  |   File "<stdin>", line 3, in f
  | ExceptionGroup: there were problems
  +-+---------------- 1 ----------------
    | OSError: error 1
    +---------------- 2 ----------------
    | SystemError: error 2
    +------------------------------------
try:
    f()
except Exception as e:
    print(f'caught {type(e)}: e')
caught <class 'ExceptionGroup'>: e
>>>
```

By using `except*` instead of `except`, we can selectively handle only the exceptions in the group that match a certain type. In the following example, which shows a nested exception group, each `except*` clause extracts from the group exceptions of a certain type while letting all other exceptions propagate to other clauses and eventually to be reraised.

\>>>

```

def f():
    raise ExceptionGroup("group1",
                         [OSError(1),
                          SystemError(2),
                          ExceptionGroup("group2",
                                         [OSError(3), RecursionError(4)])])

try:
    f()
except* OSError as e:
    print("There were OSErrors")
except* SystemError as e:
    print("There were SystemErrors")
There were OSErrors
There were SystemErrors
  + Exception Group Traceback (most recent call last):
  |   File "<stdin>", line 2, in <module>
  |   File "<stdin>", line 2, in f
  | ExceptionGroup: group1
  +-+---------------- 1 ----------------
    | ExceptionGroup: group2
    +-+---------------- 1 ----------------
      | RecursionError: 4
      +------------------------------------
>>>
```

Note that the exceptions nested in an exception group must be instances, not types. This is because in practice the exceptions would typically be ones that have already been raised and caught by the program, along the following pattern:

\>>>

```

excs = []
for test in tests:
    try:
        test.run()
    except Exception as e:
        excs.append(e)

if excs:
   raise ExceptionGroup("Test Failures", excs)
```

## 8.10. Enriching Exceptions with Notes

When an exception is created in order to be raised, it is usually initialized with information that describes the error that has occurred. There are cases where it is useful to add information after the exception was caught. For this purpose, exceptions have a method `add_note(note)` that accepts a string and adds it to the exception's notes list. The standard traceback rendering includes all notes, in the order they were added, after the exception.

\>>>

```

try:
    raise TypeError('bad type')
except Exception as e:
    e.add_note('Add some information')
    e.add_note('Add some more information')
    raise
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
TypeError: bad type
Add some information
Add some more information
>>>
```

For example, when collecting exceptions into an exception group, we may want to add context information for the individual errors. In the following each exception in the group has a note indicating when this error has occurred.

\>>>

```

def f():
    raise OSError('operation failed')

excs = []
for i in range(3):
    try:
        f()
    except Exception as e:
        e.add_note(f'Happened in Iteration {i+1}')
        excs.append(e)

raise ExceptionGroup('We have some problems', excs)
  + Exception Group Traceback (most recent call last):
  |   File "<stdin>", line 1, in <module>
  | ExceptionGroup: We have some problems (3 sub-exceptions)
  +-+---------------- 1 ----------------
    | Traceback (most recent call last):
    |   File "<stdin>", line 3, in <module>
    |   File "<stdin>", line 2, in f
    | OSError: operation failed
    | Happened in Iteration 1
    +---------------- 2 ----------------
    | Traceback (most recent call last):
    |   File "<stdin>", line 3, in <module>
    |   File "<stdin>", line 2, in f
    | OSError: operation failed
    | Happened in Iteration 2
    +---------------- 3 ----------------
    | Traceback (most recent call last):
    |   File "<stdin>", line 3, in <module>
    |   File "<stdin>", line 2, in f
    | OSError: operation failed
    | Happened in Iteration 3
    +------------------------------------
>>>
```

# 9. 类

类把数据与功能绑定在一起。创建新类就是创建新的对象 **类型**，从而创建该类型的新 **实例** 。类实例支持维持自身状态的属性，还支持（由类定义的）修改自身状态的方法。

和其他编程语言相比，Python 的类只使用了很少的新语法和语义。Python 的类有点类似于 C++ 和 Modula-3  中类的结合体，而且支持面向对象编程（OOP）的所有标准特性：类的继承机制支持多个基类、派生的类能覆盖基类的方法、类的方法能调用基类中的同名方法。对象可包含任意数量和类型的数据。和模块一样，类也支持 Python 动态特性：在运行时创建，创建后还可以修改。

如果用 C++ 术语来描述的话，类成员（包括数据成员）通常为 *public* （例外的情况见下文 [私有变量](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#tut-private)），所有成员函数都是 *virtual*。与在 Modula-3 中一样，没有用于从对象的方法中引用对象成员的简写形式：方法函数在声明时，有一个显式的参数代表本对象，该参数由调用隐式提供。  与在 Smalltalk 中一样，Python 的类也是对象，这为导入和重命名提供了语义支持。与 C++ 和 Modula-3  不同，Python 的内置类型可以用作基类，供用户扩展。 此外，与 C++  一样，算术运算符、下标等具有特殊语法的内置运算符都可以为类实例而重新定义。

由于缺乏关于类的公认术语，本章中偶尔会使用 Smalltalk 和 C++ 的术语。本章还会使用 Modula-3 的术语，Modula-3 的面向对象语义比 C++ 更接近 Python，但估计听说过这门语言的读者很少。



## 9.1. 名称和对象

对象之间相互独立，多个名称（在多个作用域内）可以绑定到同一个对象。 其他语言称之为别名。Python  初学者通常不容易理解这个概念，处理数字、字符串、元组等不可变基本类型时，可以不必理会。 但是，对涉及可变对象，如列表、字典等大多数其他类型的  Python  代码的语义，别名可能会产生意料之外的效果。这样做，通常是为了让程序受益，因为别名在某些方面就像指针。例如，传递对象的代价很小，因为实现只传递一个指针；如果函数修改了作为参数传递的对象，调用者就可以看到更改 --- 无需 Pascal 用两个不同参数的传递机制。



## 9.2. Python 作用域和命名空间

在介绍类前，首先要介绍 Python 的作用域规则。类定义对命名空间有一些巧妙的技巧，了解作用域和命名空间的工作机制有利于加强对类的理解。并且，即便对于高级 Python 程序员，这方面的知识也很有用。

接下来，我们先了解一些定义。

*namespace* （命名空间）是映射到对象的名称。现在，大多数命名空间都使用 Python 字典实现，但除非涉及到优化性能，我们一般不会关注这方面的事情，而且将来也可能会改变这种方式。命名空间的几个常见示例： [`abs()`](https://docs.python.org/zh-cn/3.11/library/functions.html#abs) 函数、内置异常等的内置函数集合；模块中的全局名称；函数调用中的局部名称。对象的属性集合也算是一种命名空间。关于命名空间的一个重要知识点是，不同命名空间中的名称之间绝对没有关系；例如，两个不同的模块都可以定义 `maximize` 函数，且不会造成混淆。用户使用函数时必须要在函数名前面附加上模块名。

点号之后的名称是 **属性**。例如，表达式 `z.real` 中，`real` 是对象 `z` 的属性。严格来说，对模块中名称的引用是属性引用：表达式 `modname.funcname` 中，`modname` 是模块对象，`funcname` 是模块的属性。模块属性和模块中定义的全局名称之间存在直接的映射：它们共享相同的命名空间！ [1](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#id2)

属性可以是只读或者可写的。如果可写，则可对属性赋值。模块属性是可写时，可以使用 `modname.the_answer = 42` 。[`del`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#del) 语句可以删除可写属性。例如， `del modname.the_answer` 会删除 `modname` 对象中的 `the_answer` 属性。

命名空间是在不同时刻创建的，且拥有不同的生命周期。内置名称的命名空间是在 Python  解释器启动时创建的，永远不会被删除。模块的全局命名空间在读取模块定义时创建；通常，模块的命名空间也会持续到解释器退出。从脚本文件读取或交互式读取的，由解释器顶层调用执行的语句是 [`__main__`](https://docs.python.org/zh-cn/3.11/library/__main__.html#module-__main__) 模块调用的一部分，也拥有自己的全局命名空间。内置名称实际上也在模块里，即 [`builtins`](https://docs.python.org/zh-cn/3.11/library/builtins.html#module-builtins) 。

函数的本地命名空间在调用该函数时创建，并在函数返回或抛出不在函数内部处理的错误时被删除。 （实际上，用“遗忘”来描述实际发生的情况会更好一些。） 当然，每次递归调用都会有自己的本地命名空间。

**作用域** 是命名空间可直接访问的 Python 程序的文本区域。 “可直接访问” 的意思是，对名称的非限定引用会在命名空间中查找名称。

作用域虽然是静态确定的，但会被动态使用。执行期间的任何时刻，都会有 3 或 4 个命名空间可被直接访问的嵌套作用域：

- 最内层作用域，包含局部名称，并首先在其中进行搜索
- the scopes of any enclosing functions, which are searched starting with the nearest enclosing scope, contain non-local, but also non-global names
- 倒数第二个作用域，包含当前模块的全局名称
- 最外层的作用域，包含内置名称的命名空间，最后搜索

If a name is declared global, then all references and assignments go directly to the next-to-last scope containing the module's global names.  To rebind variables found outside of the innermost scope, the [`nonlocal`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#nonlocal) statement can be used; if not declared nonlocal, those variables are read-only (an attempt to write to such a variable will simply create a *new* local variable in the innermost scope, leaving the identically named outer variable unchanged).

通常，当前局部作用域将（按字面文本）引用当前函数的局部名称。在函数之外，局部作用域引用与全局作用域一致的命名空间：模块的命名空间。 类定义在局部命名空间内再放置另一个命名空间。

划重点，作用域是按字面文本确定的：模块内定义的函数的全局作用域就是该模块的命名空间，无论该函数从什么地方或以什么别名被调用。另一方面，实际的名称搜索是在运行时动态完成的。但是，Python 正在朝着“编译时静态名称解析”的方向发展，因此不要过于依赖动态名称解析！（局部变量已经是被静态确定了。）

Python 有一个特殊规定。如果不存在生效的 [`global`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#global) 或 [`nonlocal`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#nonlocal) 语句，则对名称的赋值总是会进入最内层作用域。赋值不会复制数据，只是将名称绑定到对象。删除也是如此：语句 `del x` 从局部作用域引用的命名空间中移除对 `x` 的绑定。所有引入新名称的操作都是使用局部作用域：尤其是 [`import`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#import) 语句和函数定义会在局部作用域中绑定模块或函数名称。

[`global`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#global) 语句用于表明特定变量在全局作用域里，并应在全局作用域中重新绑定；[`nonlocal`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#nonlocal) 语句表明特定变量在外层作用域中，并应在外层作用域中重新绑定。



### 9.2.1. 作用域和命名空间示例

下例演示了如何引用不同作用域和名称空间，以及 [`global`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#global) 和 [`nonlocal`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#nonlocal) 对变量绑定的影响：

```
def scope_test():
    def do_local():
        spam = "local spam"

    def do_nonlocal():
        nonlocal spam
        spam = "nonlocal spam"

    def do_global():
        global spam
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

scope_test()
print("In global scope:", spam)
```

示例代码的输出是：

```
After local assignment: test spam
After nonlocal assignment: nonlocal spam
After global assignment: nonlocal spam
In global scope: global spam
```

注意，**局部** 赋值（这是默认状态）不会改变 *scope_test* 对 *spam* 的绑定。 [`nonlocal`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#nonlocal) 赋值会改变 *scope_test* 对 *spam* 的绑定，而 [`global`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#global) 赋值会改变模块层级的绑定。

而且，[`global`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#global) 赋值前没有 *spam* 的绑定。



## 9.3. 初探类

类引入了一点新语法，三种新的对象类型和一些新语义。



### 9.3.1. 类定义语法

最简单的类定义形式如下：

```
class ClassName:
    <statement-1>
    .
    .
    .
    <statement-N>
```

与函数定义 ([`def`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#def) 语句) 一样，类定义必须先执行才能生效。把类定义放在 [`if`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#if) 语句的分支里或函数内部试试。

在实践中，类定义内的语句通常都是函数定义，但也可以是其他语句。这部分内容稍后再讨论。类里的函数定义一般是特殊的参数列表，这是由方法调用的约定规范所指明的 --- 同样，稍后再解释。

当进入类定义时，将创建一个新的命名空间，并将其用作局部作用域 --- 因此，所有对局部变量的赋值都是在这个新命名空间之内。 特别的，函数定义会绑定到这里的新函数名称。

当（从结尾处）正常离开类定义时，将创建一个 *类对象*。 这基本上是一个包围在类定义所创建命名空间内容周围的包装器；我们将在下一节了解有关类对象的更多信息。 原始的（在进入类定义之前起作用的）局部作用域将重新生效，类对象将在这里被绑定到类定义头所给出的类名称 (在这个示例中为 `ClassName`)。



### 9.3.2. Class 对象

类对象支持两种操作：属性引用和实例化。

*属性引用* 使用 Python 中所有属性引用所使用的标准语法: `obj.name`。 有效的属性名称是类对象被创建时存在于类命名空间中的所有名称。 因此，如果类定义是这样的:

```
class MyClass:
    """A simple example class"""
    i = 12345

    def f(self):
        return 'hello world'
```

那么 `MyClass.i` 和 `MyClass.f` 就是有效的属性引用，将分别返回一个整数和一个函数对象。 类属性也可以被赋值，因此可以通过赋值来更改 `MyClass.i` 的值。 `__doc__` 也是一个有效的属性，将返回所属类的文档字符串: `"A simple example class"`。

类的 *实例化* 使用函数表示法。 可以把类对象视为是返回该类的一个新实例的不带参数的函数。 举例来说（假设使用上述的类）:

```
x = MyClass()
```

创建类的新 *实例* 并将此对象分配给局部变量 `x`。

实例化操作（“调用”类对象）会创建一个空对象。 许多类喜欢创建带有特定初始状态的自定义实例。 为此类定义可能包含一个名为 `__init__()` 的特殊方法，就像这样:

```
def __init__(self):
    self.data = []
```

When a class defines an `__init__()` method, class instantiation automatically invokes `__init__()` for the newly created class instance.  So in this example, a new, initialized instance can be obtained by:

```
x = MyClass()
```

当然，`__init__()` 方法还可以有额外参数以实现更高灵活性。 在这种情况下，提供给类实例化运算符的参数将被传递给 `__init__()`。 例如，:

\>>>

```

class Complex:
    def __init__(self, realpart, imagpart):
        self.r = realpart
        self.i = imagpart

x = Complex(3.0, -4.5)
x.r, x.i
(3.0, -4.5)
```



### 9.3.3. 实例对象

现在我们能用实例对象做什么？ 实例对象所能理解的唯一操作是属性引用。 有两种有效的属性名称：数据属性和方法。

*数据属性* 对应于 Smalltalk 中的“实例变量”，以及 C++ 中的“数据成员”。 数据属性不需要声明；像局部变量一样，它们将在第一次被赋值时产生。 例如，如果 `x` 是上面创建的 `MyClass` 的实例，则以下代码段将打印数值 `16`，且不保留任何追踪信息:

```
x.counter = 1
while x.counter < 10:
    x.counter = x.counter * 2
print(x.counter)
del x.counter
```

另一类实例属性引用称为 *方法*。 方法是“从属于”对象的函数。 （在 Python  中，方法这个术语并不是类实例所特有的：其他对象也可以有方法。 例如，列表对象具有 append, insert, remove, sort  等方法。 然而，在以下讨论中，我们使用方法一词将专指类实例对象的方法，除非另外显式地说明。）

实例对象的有效方法名称依赖于其所属的类。 根据定义，一个类中所有是函数对象的属性都是定义了其实例的相应方法。 因此在我们的示例中，`x.f` 是有效的方法引用，因为 `MyClass.f` 是一个函数，而 `x.i` 不是方法，因为 `MyClass.i` 不是函数。 但是 `x.f` 与 `MyClass.f` 并不是一回事 --- 它是一个 *方法对象*，不是函数对象。



### 9.3.4. 方法对象

通常，方法在绑定后立即被调用:

```
x.f()
```

在 `MyClass` 示例中，这将返回字符串 `'hello world'`。 但是，立即调用一个方法并不是必须的: `x.f` 是一个方法对象，它可以被保存起来以后再调用。 例如:

```
xf = x.f
while True:
    print(xf())
```

将持续打印 `hello world`，直到结束。

当一个方法被调用时到底发生了什么？ 你可能已经注意到上面调用 `x.f()` 时并没有带参数，虽然 `f()` 的函数定义指定了一个参数。 这个参数发生了什么事？ 当不带参数地调用一个需要参数的函数时 Python 肯定会引发异常 --- 即使参数实际未被使用...

实际上，你可能已经猜到了答案：方法的特殊之处就在于实例对象会作为函数的第一个参数被传入。 在我们的示例中，调用 `x.f()` 其实就相当于 `MyClass.f(x)`。 总之，调用一个具有 *n* 个参数的方法就相当于调用再多一个参数的对应函数，这个参数值为方法所属实例对象，位置在其他参数之前。

如果你仍然无法理解方法的运作原理，那么查看实现细节可能会弄清楚问题。 当一个实例的非数据属性被引用时，将搜索实例所属的类。  如果被引用的属性名称表示一个有效的类属性中的函数对象，会通过打包（指向）查找到的实例对象和函数对象到一个抽象对象的方式来创建方法对象：这个抽象对象就是方法对象。 当附带参数列表调用方法对象时，将基于实例对象和参数列表构建一个新的参数列表，并使用这个新参数列表调用相应的函数对象。



### 9.3.5. 类和实例变量

一般来说，实例变量用于每个实例的唯一数据，而类变量用于类的所有实例共享的属性和方法:

```
class Dog:

    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.name = name    # instance variable unique to each instance

>>> d = Dog('Fido')
>>> e = Dog('Buddy')
>>> d.kind                  # shared by all dogs
'canine'
>>> e.kind                  # shared by all dogs
'canine'
>>> d.name                  # unique to d
'Fido'
>>> e.name                  # unique to e
'Buddy'
```

正如 [名称和对象](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#tut-object) 中已讨论过的，共享数据可能在涉及 [mutable](https://docs.python.org/zh-cn/3.11/glossary.html#term-mutable) 对象例如列表和字典的时候导致令人惊讶的结果。 例如以下代码中的 *tricks* 列表不应该被用作类变量，因为所有的 *Dog* 实例将只共享一个单独的列表:

```
class Dog:

    tricks = []             # mistaken use of a class variable

    def __init__(self, name):
        self.name = name

    def add_trick(self, trick):
        self.tricks.append(trick)

>>> d = Dog('Fido')
>>> e = Dog('Buddy')
>>> d.add_trick('roll over')
>>> e.add_trick('play dead')
>>> d.tricks                # unexpectedly shared by all dogs
['roll over', 'play dead']
```

正确的类设计应该使用实例变量:

```
class Dog:

    def __init__(self, name):
        self.name = name
        self.tricks = []    # creates a new empty list for each dog

    def add_trick(self, trick):
        self.tricks.append(trick)

>>> d = Dog('Fido')
>>> e = Dog('Buddy')
>>> d.add_trick('roll over')
>>> e.add_trick('play dead')
>>> d.tricks
['roll over']
>>> e.tricks
['play dead']
```



## 9.4. 补充说明

如果同样的属性名称同时出现在实例和类中，则属性查找会优先选择实例:

\>>>

```

class Warehouse:
   purpose = 'storage'
   region = 'west'

w1 = Warehouse()
print(w1.purpose, w1.region)
storage west
w2 = Warehouse()
w2.region = 'east'
print(w2.purpose, w2.region)
storage east
```

数据属性可以被方法以及一个对象的普通用户（“客户端”）所引用。 换句话说，类不能用于实现纯抽象数据类型。 实际上，在 Python  中没有任何东西能强制隐藏数据 --- 它是完全基于约定的。 （而在另一方面，用 C 语言编写的 Python  实现则可以完全隐藏实现细节，并在必要时控制对象的访问；此特性可以通过用 C 编写 Python 扩展来使用。）

客户端应当谨慎地使用数据属性 --- 客户端可能通过直接操作数据属性的方式破坏由方法所维护的固定变量。  请注意客户端可以向一个实例对象添加他们自己的数据属性而不会影响方法的可用性，只要保证避免名称冲突 ---  再次提醒，在此使用命名约定可以省去许多令人头痛的麻烦。

在方法内部引用数据属性（或其他方法！）并没有简便方式。 我发现这实际上提升了方法的可读性：当浏览一个方法代码时，不会存在混淆局部变量和实例变量的机会。

方法的第一个参数常常被命名为 `self`。 这也不过就是一个约定: `self` 这一名称在 Python 中绝对没有特殊含义。 但是要注意，不遵循此约定会使得你的代码对其他 Python 程序员来说缺乏可读性，而且也可以想像一个 *类浏览器* 程序的编写可能会依赖于这样的约定。

任何一个作为类属性的函数都为该类的实例定义了一个相应方法。 函数定义的文本并非必须包含于类定义之内：将一个函数对象赋值给一个局部变量也是可以的。 例如:

```
# Function defined outside the class
def f1(self, x, y):
    return min(x, x+y)

class C:
    f = f1

    def g(self):
        return 'hello world'

    h = g
```

现在 `f`, `g` 和 `h` 都是 `C` 类的引用函数对象的属性，因而它们就都是 `C` 的实例的方法 --- 其中 `h` 完全等同于 `g`。 但请注意，本示例的做法通常只会令程序的阅读者感到迷惑。

方法可以通过使用 `self` 参数的方法属性调用其他方法:

```
class Bag:
    def __init__(self):
        self.data = []

    def add(self, x):
        self.data.append(x)

    def addtwice(self, x):
        self.add(x)
        self.add(x)
```

方法可以通过与普通函数相同的方式引用全局名称。 与方法相关联的全局作用域就是包含其定义的模块。 （类永远不会被作为全局作用域。）  虽然我们很少会有充分的理由在方法中使用全局作用域，但全局作用域存在许多合理的使用场景：举个例子，导入到全局作用域的函数和模块可以被方法所使用，在其中定义的函数和类也一样。 通常，包含该方法的类本身是在全局作用域中定义的，而在下一节中我们将会发现为何方法需要引用其所属类的很好的理由。

每个值都是一个对象，因此具有 *类* （也称为 *类型*），并存储为 `object.__class__` 。



## 9.5. 继承

当然，如果不支持继承，语言特性就不值得称为“类”。派生类定义的语法如下所示:

```
class DerivedClassName(BaseClassName):
    <statement-1>
    .
    .
    .
    <statement-N>
```

名称 `BaseClassName` 必须定义于包含派生类定义的作用域中。 也允许用其他任意表达式代替基类名称所在的位置。 这有时也可能会用得上，例如，当基类定义在另一个模块中的时候:

```
class DerivedClassName(modname.BaseClassName):
```

派生类定义的执行过程与基类相同。 当构造类对象时，基类会被记住。 此信息将被用来解析属性引用：如果请求的属性在类中找不到，搜索将转往基类中进行查找。 如果基类本身也派生自其他某个类，则此规则将被递归地应用。

派生类的实例化没有任何特殊之处: `DerivedClassName()` 会创建该类的一个新实例。 方法引用将按以下方式解析：搜索相应的类属性，如有必要将按基类继承链逐步向下查找，如果产生了一个函数对象则方法引用就生效。

派生类可能会重写其基类的方法。 因为方法在调用同一对象的其他方法时没有特殊权限，所以调用同一基类中定义的另一方法的基类方法最终可能会调用覆盖它的派生类的方法。 （对 C++ 程序员的提示：Python 中所有的方法实际上都是 `virtual` 方法。）

在派生类中的重载方法实际上可能想要扩展而非简单地替换同名的基类方法。 有一种方式可以简单地直接调用基类方法：即调用 `BaseClassName.methodname(self, arguments)`。 有时这对客户端来说也是有用的。 （请注意仅当此基类可在全局作用域中以 `BaseClassName` 的名称被访问时方可使用此方式。）

Python有两个内置函数可被用于继承机制：

- 使用 [`isinstance()`](https://docs.python.org/zh-cn/3.11/library/functions.html#isinstance) 来检查一个实例的类型: `isinstance(obj, int)` 仅会在 `obj.__class__` 为 [`int`](https://docs.python.org/zh-cn/3.11/library/functions.html#int) 或某个派生自 [`int`](https://docs.python.org/zh-cn/3.11/library/functions.html#int) 的类时为 `True`。
- 使用 [`issubclass()`](https://docs.python.org/zh-cn/3.11/library/functions.html#issubclass) 来检查类的继承关系: `issubclass(bool, int)` 为 `True`，因为 [`bool`](https://docs.python.org/zh-cn/3.11/library/functions.html#bool) 是 [`int`](https://docs.python.org/zh-cn/3.11/library/functions.html#int) 的子类。 但是，`issubclass(float, int)` 为 `False`，因为 [`float`](https://docs.python.org/zh-cn/3.11/library/functions.html#float) 不是 [`int`](https://docs.python.org/zh-cn/3.11/library/functions.html#int) 的子类。



### 9.5.1. 多重继承

Python 也支持一种多重继承。 带有多个基类的类定义语句如下所示:

```
class DerivedClassName(Base1, Base2, Base3):
    <statement-1>
    .
    .
    .
    <statement-N>
```

对于多数应用来说，在最简单的情况下，你可以认为搜索从父类所继承属性的操作是深度优先、从左至右的，当层次结构中存在重叠时不会在同一个类中搜索两次。 因此，如果某一属性在 `DerivedClassName` 中未找到，则会到 `Base1` 中搜索它，然后（递归地）到 `Base1` 的基类中搜索，如果在那里未找到，再到 `Base2` 中搜索，依此类推。

真实情况比这个更复杂一些；方法解析顺序会动态改变以支持对 [`super()`](https://docs.python.org/zh-cn/3.11/library/functions.html#super) 的协同调用。 这种方式在某些其他多重继承型语言中被称为后续方法调用，它比单继承型语言中的 super 调用更强大。

动态改变顺序是有必要的，因为所有多重继承的情况都会显示出一个或更多的菱形关联（即至少有一个父类可通过多条路径被最底层类所访问）。 例如，所有类都是继承自 [`object`](https://docs.python.org/zh-cn/3.11/library/functions.html#object)，因此任何多重继承的情况都提供了一条以上的路径可以通向 [`object`](https://docs.python.org/zh-cn/3.11/library/functions.html#object)。 为了确保基类不会被访问一次以上，动态算法会用一种特殊方式将搜索顺序线性化，  保留每个类所指定的从左至右的顺序，只调用每个父类一次，并且保持单调（即一个类可以被子类化而不影响其父类的优先顺序）。  总而言之，这些特性使得设计具有多重继承的可靠且可扩展的类成为可能。 要了解更多细节，请参阅 https://www.python.org/download/releases/2.3/mro/。



## 9.6. 私有变量

那种仅限从一个对象内部访问的“私有”实例变量在 Python 中并不存在。 但是，大多数 Python 代码都遵循这样一个约定：带有一个下划线的名称 (例如 `_spam`) 应该被当作是 API 的非公有部分 (无论它是函数、方法或是数据成员)。 这应当被视为一个实现细节，可能不经通知即加以改变。

由于存在对于类私有成员的有效使用场景（例如避免名称与子类所定义的名称相冲突），因此存在对此种机制的有限支持，称为 *名称改写*。 任何形式为 `__spam` 的标识符（至少带有两个前缀下划线，至多一个后缀下划线）的文本将被替换为 `_classname__spam`，其中 `classname` 为去除了前缀下划线的当前类名称。 这种改写不考虑标识符的句法位置，只要它出现在类定义内部就会进行。

名称改写有助于让子类重载方法而不破坏类内方法调用。例如:

```
class Mapping:
    def __init__(self, iterable):
        self.items_list = []
        self.__update(iterable)

    def update(self, iterable):
        for item in iterable:
            self.items_list.append(item)

    __update = update   # private copy of original update() method

class MappingSubclass(Mapping):

    def update(self, keys, values):
        # provides new signature for update()
        # but does not break __init__()
        for item in zip(keys, values):
            self.items_list.append(item)
```

上面的示例即使在 `MappingSubclass` 引入了一个 `__update` 标识符的情况下也不会出错，因为它会在 `Mapping` 类中被替换为 `_Mapping__update` 而在 `MappingSubclass` 类中被替换为 `_MappingSubclass__update`。

请注意，改写规则的设计主要是为了避免意外冲突；访问或修改被视为私有的变量仍然是可能的。这在特殊情况下甚至会很有用，例如在调试器中。

请注意传递给 `exec()` 或 `eval()` 的代码不会将发起调用类的类名视作当前类；这类似于 `global` 语句的效果，因此这种效果仅限于同时经过字节码编译的代码。 同样的限制也适用于 `getattr()`, `setattr()` 和 `delattr()`，以及对于 `__dict__` 的直接引用。



## 9.7. 杂项说明

Sometimes it is useful to have a data type similar to the Pascal "record" or C "struct", bundling together a few named data items. The idiomatic approach is to use [`dataclasses`](https://docs.python.org/zh-cn/3.11/library/dataclasses.html#module-dataclasses) for this purpose:

```
from dataclasses import dataclass

@dataclass
class Employee:
    name: str
    dept: str
    salary: int
```

\>>>

```

john = Employee('john', 'computer lab', 1000)
john.dept
'computer lab'
john.salary
1000
```

一段需要特定抽象数据类型的 Python 代码往往可以被传入一个模拟了该数据类型的方法的类作为替代。 例如，如果你有一个基于文件对象来格式化某些数据的函数，你可以定义一个带有 `read()` 和 `readline()` 方法从字符串缓存获取数据的类，并将其作为参数传入。

实例方法对象也具有属性: `m.__self__` 就是带有 `m()` 方法的实例对象，而 `m.__func__` 则是该方法所对应的函数对象。



## 9.8. 迭代器

到目前为止，您可能已经注意到大多数容器对象都可以使用 [`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 语句:

```
for element in [1, 2, 3]:
    print(element)
for element in (1, 2, 3):
    print(element)
for key in {'one':1, 'two':2}:
    print(key)
for char in "123":
    print(char)
for line in open("myfile.txt"):
    print(line, end='')
```

这种访问风格清晰、简洁又方便。 迭代器的使用非常普遍并使得 Python 成为一个统一的整体。 在幕后，[`for`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#for) 语句会在容器对象上调用 [`iter()`](https://docs.python.org/zh-cn/3.11/library/functions.html#iter)。 该函数返回一个定义了 [`__next__()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#iterator.__next__) 方法的迭代器对象，此方法将逐一访问容器中的元素。 当元素用尽时，[`__next__()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#iterator.__next__) 将引发 [`StopIteration`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#StopIteration) 异常来通知终止 `for` 循环。 你可以使用 [`next()`](https://docs.python.org/zh-cn/3.11/library/functions.html#next) 内置函数来调用 [`__next__()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#iterator.__next__) 方法；这个例子显示了它的运作方式:

\>>>

```

s = 'abc'
it = iter(s)
it
<str_iterator object at 0x10c90e650>
next(it)
'a'
next(it)
'b'
next(it)
'c'
next(it)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    next(it)
StopIteration
```

看过迭代器协议的幕后机制，给你的类添加迭代器行为就很容易了。 定义一个 `__iter__()` 方法来返回一个带有 [`__next__()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#iterator.__next__) 方法的对象。 如果类已定义了 `__next__()`，则 `__iter__()` 可以简单地返回 `self`:

```
class Reverse:
    """Iterator for looping over a sequence backwards."""
    def __init__(self, data):
        self.data = data
        self.index = len(data)

    def __iter__(self):
        return self

    def __next__(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.data[self.index]
```

\>>>

```

rev = Reverse('spam')
iter(rev)
<__main__.Reverse object at 0x00A1DB50>
for char in rev:
    print(char)
m
a
p
s
```



## 9.9. 生成器

[生成器](https://docs.python.org/zh-cn/3.11/glossary.html#term-generator) 是一个用于创建迭代器的简单而强大的工具。 它们的写法类似于标准的函数，但当它们要返回数据时会使用 [`yield`](https://docs.python.org/zh-cn/3.11/reference/simple_stmts.html#yield) 语句。 每次在生成器上调用 [`next()`](https://docs.python.org/zh-cn/3.11/library/functions.html#next) 时，它会从上次离开的位置恢复执行（它会记住上次执行语句时的所有数据值）。 一个显示如何非常容易地创建生成器的示例如下:

```
def reverse(data):
    for index in range(len(data)-1, -1, -1):
        yield data[index]
```

\>>>

```

for char in reverse('golf'):
    print(char)
f
l
o
g
```

可以用生成器来完成的操作同样可以用前一节所描述的基于类的迭代器来完成。 但生成器的写法更为紧凑，因为它会自动创建 `__iter__()` 和 [`__next__()`](https://docs.python.org/zh-cn/3.11/reference/expressions.html#generator.__next__) 方法。

另一个关键特性在于局部变量和执行状态会在每次调用之间自动保存。 这使得该函数相比使用 `self.index` 和 `self.data` 这种实例变量的方式更易编写且更为清晰。

除了会自动创建方法和保存程序状态，当生成器终结时，它们还会自动引发 [`StopIteration`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#StopIteration)。 这些特性结合在一起，使得创建迭代器能与编写常规函数一样容易。



## 9.10. 生成器表达式

某些简单的生成器可以写成简洁的表达式代码，所用语法类似列表推导式，但外层为圆括号而非方括号。 这种表达式被设计用于生成器将立即被外层函数所使用的情况。 生成器表达式相比完整的生成器更紧凑但较不灵活，相比等效的列表推导式则更为节省内存。

示例:

\>>>

```

sum(i*i for i in range(10))                 # sum of squares
285
xvec = [10, 20, 30]
yvec = [7, 5, 3]
sum(x*y for x,y in zip(xvec, yvec))         # dot product
260
unique_words = set(word for line in page  for word in line.split())
valedictorian = max((student.gpa, student.name) for student in graduates)
data = 'golf'
list(data[i] for i in range(len(data)-1, -1, -1))
['f', 'l', 'o', 'g']
```

备注

- [1](https://docs.python.org/zh-cn/3.11/tutorial/classes.html#id1)

  存在一个例外。 模块对象有一个秘密的只读属性 [`__dict__`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#object.__dict__)，它返回用于实现模块命名空间的字典；[`__dict__`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#object.__dict__) 是属性但不是全局名称。 显然，使用这个将违反命名空间实现的抽象，应当仅被用于事后调试器之类的场合。

# 10. 标准库简介



## 10.1. 操作系统接口

[`os`](https://docs.python.org/zh-cn/3.11/library/os.html#module-os) 模块提供了许多与操作系统交互的函数:

\>>>

```

import os
os.getcwd()      # Return the current working directory
'C:\\Python311'
os.chdir('/server/accesslogs')   # Change current working directory
os.system('mkdir today')   # Run the command mkdir in the system shell
0
```

一定要使用 `import os` 而不是 `from os import *` 。这将避免内建的 [`open()`](https://docs.python.org/zh-cn/3.11/library/functions.html#open) 函数被 [`os.open()`](https://docs.python.org/zh-cn/3.11/library/os.html#os.open) 隐式替换掉，因为它们的使用方式大不相同。

内置的 [`dir()`](https://docs.python.org/zh-cn/3.11/library/functions.html#dir) 和 [`help()`](https://docs.python.org/zh-cn/3.11/library/functions.html#help) 函数可用作交互式辅助工具，用于处理大型模块，如 [`os`](https://docs.python.org/zh-cn/3.11/library/os.html#module-os):

\>>>

```

import os
dir(os)
<returns a list of all module functions>
help(os)
<returns an extensive manual page created from the module's docstrings>
```

对于日常文件和目录管理任务， [`shutil`](https://docs.python.org/zh-cn/3.11/library/shutil.html#module-shutil) 模块提供了更易于使用的更高级别的接口:

\>>>

```

import shutil
shutil.copyfile('data.db', 'archive.db')
'archive.db'
shutil.move('/build/executables', 'installdir')
'installdir'
```



## 10.2. 文件通配符

[`glob`](https://docs.python.org/zh-cn/3.11/library/glob.html#module-glob) 模块提供了一个在目录中使用通配符搜索创建文件列表的函数:

\>>>

```

import glob
glob.glob('*.py')
['primes.py', 'random.py', 'quote.py']
```



## 10.3. 命令行参数

通用实用程序脚本通常需要处理命令行参数。这些参数作为列表存储在 [`sys`](https://docs.python.org/zh-cn/3.11/library/sys.html#module-sys) 模块的 *argv* 属性中。例如，以下输出来自在命令行运行 `python demo.py one two three`

\>>>

```

import sys
print(sys.argv)
['demo.py', 'one', 'two', 'three']
```

[`argparse`](https://docs.python.org/zh-cn/3.11/library/argparse.html#module-argparse) 模块提供了一种更复杂的机制来处理命令行参数。 以下脚本可提取一个或多个文件名，并可选择要显示的行数:

```
import argparse

parser = argparse.ArgumentParser(
    prog='top',
    description='Show top lines from each file')
parser.add_argument('filenames', nargs='+')
parser.add_argument('-l', '--lines', type=int, default=10)
args = parser.parse_args()
print(args)
```

当在通过 `python top.py --lines=5 alpha.txt beta.txt` 在命令行运行时，该脚本会将 `args.lines` 设为 `5` 并将 `args.filenames` 设为 `['alpha.txt', 'beta.txt']`。



## 10.4. 错误输出重定向和程序终止

[`sys`](https://docs.python.org/zh-cn/3.11/library/sys.html#module-sys) 模块还具有 *stdin* ， *stdout* 和 *stderr* 的属性。后者对于发出警告和错误消息非常有用，即使在 *stdout* 被重定向后也可以看到它们:

\>>>

```

sys.stderr.write('Warning, log file not found starting a new one\n')
Warning, log file not found starting a new one
```

终止脚本的最直接方法是使用 `sys.exit()` 。



## 10.5. 字符串模式匹配

[`re`](https://docs.python.org/zh-cn/3.11/library/re.html#module-re) 模块为高级字符串处理提供正则表达式工具。对于复杂的匹配和操作，正则表达式提供简洁，优化的解决方案:

\>>>

```

import re
re.findall(r'\bf[a-z]*', 'which foot or hand fell fastest')
['foot', 'fell', 'fastest']
re.sub(r'(\b[a-z]+) \1', r'\1', 'cat in the the hat')
'cat in the hat'
```

当只需要简单的功能时，首选字符串方法因为它们更容易阅读和调试:

\>>>

```

'tea for too'.replace('too', 'two')
'tea for two'
```



## 10.6. 数学

[`math`](https://docs.python.org/zh-cn/3.11/library/math.html#module-math) 模块提供对浮点数学的底层C库函数的访问:

\>>>

```

import math
math.cos(math.pi / 4)
0.70710678118654757
math.log(1024, 2)
10.0
```

[`random`](https://docs.python.org/zh-cn/3.11/library/random.html#module-random) 模块提供了进行随机选择的工具:

\>>>

```

import random
random.choice(['apple', 'pear', 'banana'])
'apple'
random.sample(range(100), 10)   # sampling without replacement
[30, 83, 16, 4, 8, 81, 41, 50, 18, 33]
random.random()    # random float
0.17970987693706186
random.randrange(6)    # random integer chosen from range(6)
4
```

[`statistics`](https://docs.python.org/zh-cn/3.11/library/statistics.html#module-statistics) 模块计算数值数据的基本统计属性（均值，中位数，方差等）:

\>>>

```

import statistics
data = [2.75, 1.75, 1.25, 0.25, 0.5, 1.25, 3.5]
statistics.mean(data)
1.6071428571428572
statistics.median(data)
1.25
statistics.variance(data)
1.3720238095238095
```

SciPy项目 <https://scipy.org> 有许多其他模块用于数值计算。



## 10.7. 互联网访问

有许多模块可用于访问互联网和处理互联网协议。其中两个最简单的 [`urllib.request`](https://docs.python.org/zh-cn/3.11/library/urllib.request.html#module-urllib.request) 用于从URL检索数据，以及 [`smtplib`](https://docs.python.org/zh-cn/3.11/library/smtplib.html#module-smtplib) 用于发送邮件:

\>>>

```

from urllib.request import urlopen
with urlopen('http://worldtimeapi.org/api/timezone/etc/UTC.txt') as response:
    for line in response:
        line = line.decode()             # Convert bytes to a str
        if line.startswith('datetime'):
            print(line.rstrip())         # Remove trailing newline
datetime: 2022-01-01T01:36:47.689215+00:00
import smtplib
server = smtplib.SMTP('localhost')
server.sendmail('soothsayer@example.org', 'jcaesar@example.org',
"""To: jcaesar@example.org
From: soothsayer@example.org

Beware the Ides of March.
""")
server.quit()
```

（请注意，第二个示例需要在localhost上运行的邮件服务器。）



## 10.8. 日期和时间

[`datetime`](https://docs.python.org/zh-cn/3.11/library/datetime.html#module-datetime) 模块提供了以简单和复杂的方式操作日期和时间的类。虽然支持日期和时间算法，但实现的重点是有效的成员提取以进行输出格式化和操作。该模块还支持可感知时区的对象。

\>>>

```

# dates are easily constructed and formatted
from datetime import date
now = date.today()
now
datetime.date(2003, 12, 2)
now.strftime("%m-%d-%y. %d %b %Y is a %A on the %d day of %B.")
'12-02-03. 02 Dec 2003 is a Tuesday on the 02 day of December.'
# dates support calendar arithmetic
birthday = date(1964, 7, 31)
age = now - birthday
age.days
14368
```



## 10.9. 数据压缩

常见的数据存档和压缩格式由模块直接支持，包括：[`zlib`](https://docs.python.org/zh-cn/3.11/library/zlib.html#module-zlib), [`gzip`](https://docs.python.org/zh-cn/3.11/library/gzip.html#module-gzip), [`bz2`](https://docs.python.org/zh-cn/3.11/library/bz2.html#module-bz2), [`lzma`](https://docs.python.org/zh-cn/3.11/library/lzma.html#module-lzma), [`zipfile`](https://docs.python.org/zh-cn/3.11/library/zipfile.html#module-zipfile) 和 [`tarfile`](https://docs.python.org/zh-cn/3.11/library/tarfile.html#module-tarfile)。:

\>>>

```

import zlib
s = b'witch which has which witches wrist watch'
len(s)
41
t = zlib.compress(s)
len(t)
37
zlib.decompress(t)
b'witch which has which witches wrist watch'
zlib.crc32(s)
226805979
```



## 10.10. 性能测量

一些Python用户对了解同一问题的不同方法的相对性能产生了浓厚的兴趣。 Python提供了一种可以立即回答这些问题的测量工具。

例如，元组封包和拆包功能相比传统的交换参数可能更具吸引力。[`timeit`](https://docs.python.org/zh-cn/3.11/library/timeit.html#module-timeit) 模块可以快速演示在运行效率方面一定的优势:

\>>>

```

from timeit import Timer
Timer('t=a; a=b; b=t', 'a=1; b=2').timeit()
0.57535828626024577
Timer('a,b = b,a', 'a=1; b=2').timeit()
0.54962537085770791
```

与 [`timeit`](https://docs.python.org/zh-cn/3.11/library/timeit.html#module-timeit) 的精细粒度级别相反， [`profile`](https://docs.python.org/zh-cn/3.11/library/profile.html#module-profile) 和 [`pstats`](https://docs.python.org/zh-cn/3.11/library/profile.html#module-pstats) 模块提供了用于在较大的代码块中识别时间关键部分的工具。



## 10.11. 质量控制

开发高质量软件的一种方法是在开发过程中为每个函数编写测试，并在开发过程中经常运行这些测试。

[`doctest`](https://docs.python.org/zh-cn/3.11/library/doctest.html#module-doctest) 模块提供了一个工具，用于扫描模块并验证程序文档字符串中嵌入的测试。测试构造就像将典型调用及其结果剪切并粘贴到文档字符串一样简单。这通过向用户提供示例来改进文档，并且它允许doctest模块确保代码保持对文档的真实:

```
def average(values):
    """Computes the arithmetic mean of a list of numbers.

    >>> print(average([20, 30, 70]))
    40.0
    """
    return sum(values) / len(values)

import doctest
doctest.testmod()   # automatically validate the embedded tests
```

[`unittest`](https://docs.python.org/zh-cn/3.11/library/unittest.html#module-unittest) 模块不像 [`doctest`](https://docs.python.org/zh-cn/3.11/library/doctest.html#module-doctest) 模块那样易于使用，但它允许在一个单独的文件中维护更全面的测试集:

```
import unittest

class TestStatisticalFunctions(unittest.TestCase):

    def test_average(self):
        self.assertEqual(average([20, 30, 70]), 40.0)
        self.assertEqual(round(average([1, 5, 7]), 1), 4.3)
        with self.assertRaises(ZeroDivisionError):
            average([])
        with self.assertRaises(TypeError):
            average(20, 30, 70)

unittest.main()  # Calling from the command line invokes all tests
```



## 10.12. 自带电池

Python有“自带电池”的理念。通过其包的复杂和强大功能可以最好地看到这一点。例如:

- [`xmlrpc.client`](https://docs.python.org/zh-cn/3.11/library/xmlrpc.client.html#module-xmlrpc.client) 和 [`xmlrpc.server`](https://docs.python.org/zh-cn/3.11/library/xmlrpc.server.html#module-xmlrpc.server) 模块使得实现远程过程调用变成了小菜一碟。 尽管存在于模块名称中，但用户不需要直接了解或处理 XML。
-  [`email`](https://docs.python.org/zh-cn/3.11/library/email.html#module-email) 包是一个用于管理电子邮件的库，包括MIME和其他符合 [**RFC 2822**](https://datatracker.ietf.org/doc/html/rfc2822.html) 规范的邮件文档。与 [`smtplib`](https://docs.python.org/zh-cn/3.11/library/smtplib.html#module-smtplib) 和 [`poplib`](https://docs.python.org/zh-cn/3.11/library/poplib.html#module-poplib) 不同（它们实际上做的是发送和接收消息），电子邮件包提供完整的工具集，用于构建或解码复杂的消息结构（包括附件）以及实现互联网编码和标头协议。
-  [`json`](https://docs.python.org/zh-cn/3.11/library/json.html#module-json) 包为解析这种流行的数据交换格式提供了强大的支持。 [`csv`](https://docs.python.org/zh-cn/3.11/library/csv.html#module-csv) 模块支持以逗号分隔值格式直接读取和写入文件，这种格式通常为数据库和电子表格所支持。 XML 处理由 [`xml.etree.ElementTree`](https://docs.python.org/zh-cn/3.11/library/xml.etree.elementtree.html#module-xml.etree.ElementTree) ， [`xml.dom`](https://docs.python.org/zh-cn/3.11/library/xml.dom.html#module-xml.dom) 和 [`xml.sax`](https://docs.python.org/zh-cn/3.11/library/xml.sax.html#module-xml.sax) 包支持。这些模块和软件包共同大大简化了 Python 应用程序和其他工具之间的数据交换。
-  [`sqlite3`](https://docs.python.org/zh-cn/3.11/library/sqlite3.html#module-sqlite3) 模块是 SQLite 数据库库的包装器，提供了一个可以使用稍微非标准的 SQL 语法更新和访问的持久数据库。
- 国际化由许多模块支持，包括 [`gettext`](https://docs.python.org/zh-cn/3.11/library/gettext.html#module-gettext) ， [`locale`](https://docs.python.org/zh-cn/3.11/library/locale.html#module-locale) ，以及 [`codecs`](https://docs.python.org/zh-cn/3.11/library/codecs.html#module-codecs) 包。

# 11. 标准库简介 —— 第二部分

第二部分涵盖了专业编程所需要的更高级的模块。这些模块很少用在小脚本中。



## 11.1. 格式化输出

[`reprlib`](https://docs.python.org/zh-cn/3.11/library/reprlib.html#module-reprlib) 模块提供了一个定制化版本的 [`repr()`](https://docs.python.org/zh-cn/3.11/library/functions.html#repr) 函数，用于缩略显示大型或深层嵌套的容器对象:

\>>>

```

import reprlib
reprlib.repr(set('supercalifragilisticexpialidocious'))
"{'a', 'c', 'd', 'e', 'f', 'g', ...}"
```

[`pprint`](https://docs.python.org/zh-cn/3.11/library/pprint.html#module-pprint) 模块提供了更加复杂的打印控制，其输出的内置对象和用户自定义对象能够被解释器直接读取。当输出结果过长而需要折行时，“美化输出机制”会添加换行符和缩进，以更清楚地展示数据结构:

\>>>

```

import pprint
t = [[[['black', 'cyan'], 'white', ['green', 'red']], [['magenta',
    'yellow'], 'blue']]]

pprint.pprint(t, width=30)
[[[['black', 'cyan'],
   'white',
   ['green', 'red']],
  [['magenta', 'yellow'],
   'blue']]]
```

[`textwrap`](https://docs.python.org/zh-cn/3.11/library/textwrap.html#module-textwrap) 模块能够格式化文本段落，以适应给定的屏幕宽度:

\>>>

```

import textwrap
doc = """The wrap() method is just like fill() except that it returns
a list of strings instead of one big string with newlines to separate
the wrapped lines."""

print(textwrap.fill(doc, width=40))
The wrap() method is just like fill()
except that it returns a list of strings
instead of one big string with newlines
to separate the wrapped lines.
```

[`locale`](https://docs.python.org/zh-cn/3.11/library/locale.html#module-locale) 模块处理与特定地域文化相关的数据格式。locale 模块的 format 函数包含一个 grouping 属性，可直接将数字格式化为带有组分隔符的样式:

\>>>

```

import locale
locale.setlocale(locale.LC_ALL, 'English_United States.1252')
'English_United States.1252'
conv = locale.localeconv()          # get a mapping of conventions
x = 1234567.8
locale.format("%d", x, grouping=True)
'1,234,567'
locale.format_string("%s%.*f", (conv['currency_symbol'],
                     conv['frac_digits'], x), grouping=True)
'$1,234,567.80'
```



## 11.2. 模板

[`string`](https://docs.python.org/zh-cn/3.11/library/string.html#module-string) 模块包含一个通用的 [`Template`](https://docs.python.org/zh-cn/3.11/library/string.html#string.Template) 类，具有适用于最终用户的简化语法。它允许用户在不更改应用逻辑的情况下定制自己的应用。

上述格式化操作是通过占位符实现的，占位符由 `$` 加上合法的 Python 标识符（只能包含字母、数字和下划线）构成。一旦使用花括号将占位符括起来，就可以在后面直接跟上更多的字母和数字而无需空格分割。`$$` 将被转义成单个字符 `$`:

\>>>

```

from string import Template
t = Template('${village}folk send $$10 to $cause.')
t.substitute(village='Nottingham', cause='the ditch fund')
'Nottinghamfolk send $10 to the ditch fund.'
```

如果在字典或关键字参数中未提供某个占位符的值，那么 [`substitute()`](https://docs.python.org/zh-cn/3.11/library/string.html#string.Template.substitute) 方法将抛出 [`KeyError`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#KeyError)。对于邮件合并类型的应用，用户提供的数据有可能是不完整的，此时使用 [`safe_substitute()`](https://docs.python.org/zh-cn/3.11/library/string.html#string.Template.safe_substitute) 方法更加合适 —— 如果数据缺失，它会直接将占位符原样保留。

\>>>

```

t = Template('Return the $item to $owner.')
d = dict(item='unladen swallow')
t.substitute(d)
Traceback (most recent call last):
  ...
KeyError: 'owner'
t.safe_substitute(d)
'Return the unladen swallow to $owner.'
```

Template 的子类可以自定义分隔符。例如，以下是某个照片浏览器的批量重命名功能，采用了百分号作为日期、照片序号和照片格式的占位符:

\>>>

```

import time, os.path
photofiles = ['img_1074.jpg', 'img_1076.jpg', 'img_1077.jpg']
class BatchRename(Template):
    delimiter = '%'

fmt = input('Enter rename style (%d-date %n-seqnum %f-format):  ')
Enter rename style (%d-date %n-seqnum %f-format):  Ashley_%n%f
t = BatchRename(fmt)
date = time.strftime('%d%b%y')
for i, filename in enumerate(photofiles):
    base, ext = os.path.splitext(filename)
    newname = t.substitute(d=date, n=i, f=ext)
    print('{0} --> {1}'.format(filename, newname))

img_1074.jpg --> Ashley_0.jpg
img_1076.jpg --> Ashley_1.jpg
img_1077.jpg --> Ashley_2.jpg
```

模板的另一个应用是将程序逻辑与多样的格式化输出细节分离开来。这使得对 XML 文件、纯文本报表和 HTML 网络报表使用自定义模板成为可能。



## 11.3. 使用二进制数据记录格式

[`struct`](https://docs.python.org/zh-cn/3.11/library/struct.html#module-struct) 模块提供了 [`pack()`](https://docs.python.org/zh-cn/3.11/library/struct.html#struct.pack) 和 [`unpack()`](https://docs.python.org/zh-cn/3.11/library/struct.html#struct.unpack) 函数，用于处理不定长度的二进制记录格式。下面的例子展示了在不使用 [`zipfile`](https://docs.python.org/zh-cn/3.11/library/zipfile.html#module-zipfile) 模块的情况下，如何循环遍历一个 ZIP 文件的所有头信息。Pack 代码 `"H"` 和 `"I"` 分别代表两字节和四字节无符号整数。`"<"` 代表它们是标准尺寸的小端字节序:

```
import struct

with open('myfile.zip', 'rb') as f:
    data = f.read()

start = 0
for i in range(3):                      # show the first 3 file headers
    start += 14
    fields = struct.unpack('<IIIHH', data[start:start+16])
    crc32, comp_size, uncomp_size, filenamesize, extra_size = fields

    start += 16
    filename = data[start:start+filenamesize]
    start += filenamesize
    extra = data[start:start+extra_size]
    print(filename, hex(crc32), comp_size, uncomp_size)

    start += extra_size + comp_size     # skip to the next header
```



## 11.4. 多线程

线程是一种对于非顺序依赖的多个任务进行解耦的技术。多线程可以提高应用的响应效率，当接收用户输入的同时，保持其他任务在后台运行。一个有关的应用场景是，将 I/O 和计算运行在两个并行的线程中。

以下代码展示了高阶的 [`threading`](https://docs.python.org/zh-cn/3.11/library/threading.html#module-threading) 模块如何在后台运行任务，且不影响主程序的继续运行:

```
import threading, zipfile

class AsyncZip(threading.Thread):
    def __init__(self, infile, outfile):
        threading.Thread.__init__(self)
        self.infile = infile
        self.outfile = outfile

    def run(self):
        f = zipfile.ZipFile(self.outfile, 'w', zipfile.ZIP_DEFLATED)
        f.write(self.infile)
        f.close()
        print('Finished background zip of:', self.infile)

background = AsyncZip('mydata.txt', 'myarchive.zip')
background.start()
print('The main program continues to run in foreground.')

background.join()    # Wait for the background task to finish
print('Main program waited until background was done.')
```

多线程应用面临的主要挑战是，相互协调的多个线程之间需要共享数据或其他资源。为此，threading 模块提供了多个同步操作原语，包括线程锁、事件、条件变量和信号量。

尽管这些工具非常强大，但微小的设计错误却可以导致一些难以复现的问题。因此，实现多任务协作的首选方法是将所有对资源的请求集中到一个线程中，然后使用 [`queue`](https://docs.python.org/zh-cn/3.11/library/queue.html#module-queue) 模块向该线程供应来自其他线程的请求。 应用程序使用 [`Queue`](https://docs.python.org/zh-cn/3.11/library/queue.html#queue.Queue) 对象进行线程间通信和协调，更易于设计，更易读，更可靠。



## 11.5. 日志记录

[`logging`](https://docs.python.org/zh-cn/3.11/library/logging.html#module-logging) 模块提供功能齐全且灵活的日志记录系统。在最简单的情况下，日志消息被发送到文件或 `sys.stderr`

```
import logging
logging.debug('Debugging information')
logging.info('Informational message')
logging.warning('Warning:config file %s not found', 'server.conf')
logging.error('Error occurred')
logging.critical('Critical error -- shutting down')
```

这会产生以下输出:

```
WARNING:root:Warning:config file server.conf not found
ERROR:root:Error occurred
CRITICAL:root:Critical error -- shutting down
```

默认情况下，informational 和 debugging 消息被压制，输出会发送到标准错误流。其他输出选项包括将消息转发到电子邮件，数据报，套接字或 HTTP 服务器。新的过滤器可以根据消息优先级选择不同的路由方式：`DEBUG`，`INFO`，`WARNING`，`ERROR`，和 `CRITICAL`。

日志系统可以直接从 Python 配置，也可以从用户配置文件加载，以便自定义日志记录而无需更改应用程序。



## 11.6. 弱引用

Python 会自动进行内存管理（对大多数对象进行引用计数并使用 [garbage collection](https://docs.python.org/zh-cn/3.11/glossary.html#term-garbage-collection) 来清除循环引用）。 当某个对象的最后一个引用被移除后不久就会释放其所占用的内存。

此方式对大多数应用来说都适用，但偶尔也必须在对象持续被其他对象所使用时跟踪它们。 不幸的是，跟踪它们将创建一个会令其永久化的引用。 [`weakref`](https://docs.python.org/zh-cn/3.11/library/weakref.html#module-weakref) 模块提供的工具可以不必创建引用就能跟踪对象。 当对象不再需要时，它将自动从一个弱引用表中被移除，并为弱引用对象触发一个回调。 典型应用包括对创建开销较大的对象进行缓存:

\>>>

```

import weakref, gc
class A:
    def __init__(self, value):
        self.value = value
    def __repr__(self):
        return str(self.value)

a = A(10)                   # create a reference
d = weakref.WeakValueDictionary()
d['primary'] = a            # does not create a reference
d['primary']                # fetch the object if it is still alive
10
del a                       # remove the one reference
gc.collect()                # run garbage collection right away
0
d['primary']                # entry was automatically removed
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
    d['primary']                # entry was automatically removed
  File "C:/python311/lib/weakref.py", line 46, in __getitem__
    o = self.data[key]()
KeyError: 'primary'
```



## 11.7. 用于操作列表的工具

许多对于数据结构的需求可以通过内置列表类型来满足。 但是，有时也会需要具有不同效费比的替代实现。

[`array`](https://docs.python.org/zh-cn/3.11/library/array.html#module-array) 模块提供了一种 [`array()`](https://docs.python.org/zh-cn/3.11/library/array.html#array.array) 对象，它类似于列表，但只能存储类型一致的数据且存储密集更高。 下面的例子演示了一个以两个字节为存储单元的无符号二进制数值的数组 (类型码为 `"H"`)，而对于普通列表来说，每个条目存储为标准 Python 的 int 对象通常要占用16 个字节:

\>>>

```

from array import array
a = array('H', [4000, 10, 700, 22222])
sum(a)
26932
a[1:3]
array('H', [10, 700])
```

[`collections`](https://docs.python.org/zh-cn/3.11/library/collections.html#module-collections) 模块提供了一种 [`deque()`](https://docs.python.org/zh-cn/3.11/library/collections.html#collections.deque) 对象，它类似于列表，但从左端添加和弹出的速度较快，而在中间查找的速度较慢。 此种对象适用于实现队列和广度优先树搜索:

\>>>

```

from collections import deque
d = deque(["task1", "task2", "task3"])
d.append("task4")
print("Handling", d.popleft())
Handling task1
unsearched = deque([starting_node])
def breadth_first_search(unsearched):
    node = unsearched.popleft()
    for m in gen_moves(node):
        if is_goal(m):
            return m
        unsearched.append(m)
```

在替代的列表实现以外，标准库也提供了其他工具，例如 [`bisect`](https://docs.python.org/zh-cn/3.11/library/bisect.html#module-bisect) 模块具有用于操作有序列表的函数:

\>>>

```

import bisect
scores = [(100, 'perl'), (200, 'tcl'), (400, 'lua'), (500, 'python')]
bisect.insort(scores, (300, 'ruby'))
scores
[(100, 'perl'), (200, 'tcl'), (300, 'ruby'), (400, 'lua'), (500, 'python')]
```

[`heapq`](https://docs.python.org/zh-cn/3.11/library/heapq.html#module-heapq) 模块提供了基于常规列表来实现堆的函数。 最小值的条目总是保持在位置零。 这对于需要重复访问最小元素而不希望运行完整列表排序的应用来说非常有用:

\>>>

```

from heapq import heapify, heappop, heappush
data = [1, 3, 5, 7, 9, 2, 4, 6, 8, 0]
heapify(data)                      # rearrange the list into heap order
heappush(data, -5)                 # add a new entry
[heappop(data) for i in range(3)]  # fetch the three smallest entries
[-5, 0, 1]
```



## 11.8. 十进制浮点运算

[`decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#module-decimal) 模块提供了一种 [`Decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#decimal.Decimal) 数据类型用于十进制浮点运算。 相比内置的 [`float`](https://docs.python.org/zh-cn/3.11/library/functions.html#float) 二进制浮点实现，该类特别适用于

- 财务应用和其他需要精确十进制表示的用途，
- 控制精度，
- 控制四舍五入以满足法律或监管要求，
- 跟踪有效小数位，或
- 用户期望结果与手工完成的计算相匹配的应用程序。

例如，使用十进制浮点和二进制浮点数计算70美分手机和5％税的总费用，会产生的不同结果。如果结果四舍五入到最接近的分数差异会更大:

\>>>

```

from decimal import *
round(Decimal('0.70') * Decimal('1.05'), 2)
Decimal('0.74')
round(.70 * 1.05, 2)
0.73
```

[`Decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#decimal.Decimal) 表示的结果会保留尾部的零，并根据具有两个有效位的被乘数自动推出四个有效位。 Decimal 可以模拟手工运算来避免当二进制浮点数无法精确表示十进制数时会导致的问题。

精确表示特性使得 [`Decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#decimal.Decimal) 类能够执行对于二进制浮点数来说不适用的模运算和相等性检测:

\>>>

```

Decimal('1.00') % Decimal('.10')
Decimal('0.00')
1.00 % 0.10
0.09999999999999995
sum([Decimal('0.1')]*10) == Decimal('1.0')
True
sum([0.1]*10) == 1.0
False
```

[`decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#module-decimal) 模块提供了运算所需要的足够精度:

\>>>

```

getcontext().prec = 36
Decimal(1) / Decimal(7)
Decimal('0.142857142857142857142857142857142857')
```

# 12. 虚拟环境和包

## 12.1. 概述

Python应用程序通常会使用不在标准库内的软件包和模块。应用程序有时需要特定版本的库，因为应用程序可能需要修复特定的错误，或者可以使用库的过时版本的接口编写应用程序。

这意味着一个Python安装可能无法满足每个应用程序的要求。如果应用程序A需要特定模块的1.0版本但应用程序B需要2.0版本，则需求存在冲突，安装版本1.0或2.0将导致某一个应用程序无法运行。

这个问题的解决方案是创建一个 [virtual environment](https://docs.python.org/zh-cn/3.11/glossary.html#term-virtual-environment)，一个目录树，其中安装有特定Python版本，以及许多其他包。

然后，不同的应用将可以使用不同的虚拟环境。 要解决先前需求相冲突的例子，应用程序 A 可以拥有自己的 安装了 1.0  版本的虚拟环境，而应用程序 B 则拥有安装了 2.0 版本的另一个虚拟环境。 如果应用程序 B 要求将某个库升级到 3.0  版本，也不会影响应用程序 A 的环境。

## 12.2. 创建虚拟环境

用于创建和管理虚拟环境的模块称为 [`venv`](https://docs.python.org/zh-cn/3.11/library/venv.html#module-venv)。[`venv`](https://docs.python.org/zh-cn/3.11/library/venv.html#module-venv) 通常会安装你可用的最新版本的 Python。如果您的系统上有多个版本的 Python，您可以通过运行 `python3` 或您想要的任何版本来选择特定的Python版本。

要创建虚拟环境，请确定要放置它的目录，并将 [`venv`](https://docs.python.org/zh-cn/3.11/library/venv.html#module-venv) 模块作为脚本运行目录路径:

```
python -m venv tutorial-env
```

这将创建 `tutorial-env` 目录，如果它不存在的话，并在其中创建包含 Python 解释器副本和各种支持文件的目录。

虚拟环境的常用目录位置是 `.venv`。 这个名称通常会令该目录在你的终端中保持隐藏，从而避免需要对所在目录进行额外解释的一般名称。 它还能防止与某些工具所支持的 `.env` 环境变量定义文件发生冲突。

创建虚拟环境后，您可以激活它。

在Windows上，运行:

```
tutorial-env\Scripts\activate.bat
```

在Unix或MacOS上，运行:

```
source tutorial-env/bin/activate
```

（这个脚本是为bash shell编写的。如果你使用 **csh** 或 **fish** shell，你应该改用 `activate.csh` 或 `activate.fish` 脚本。）

激活虚拟环境将改变你所用终端的提示符，以显示你正在使用的虚拟环境，并修改环境以使 `python` 命令所运行的将是已安装的特定 Python 版本。 例如：

```
$ source ~/envs/tutorial-env/bin/activate
(tutorial-env) $ python
Python 3.5.1 (default, May  6 2016, 10:59:36)
  ...
>>> import sys
>>> sys.path
['', '/usr/local/lib/python35.zip', ...,
'~/envs/tutorial-env/lib/python3.5/site-packages']
>>>
```

To deactivate a virtual environment, type:

```
deactivate
```

into the terminal.

## 12.3. 使用pip管理包

You can install, upgrade, and remove packages using a program called **pip**.  By default `pip` will install packages from the [Python Package Index](https://pypi.org).  You can browse the Python Package Index by going to it in your web browser.

`pip` 有许多子命令: "install", "uninstall", "freeze" 等等。 （请在 [安装 Python 模块](https://docs.python.org/zh-cn/3.11/installing/index.html#installing-index) 指南页查看完整的 `pip` 文档。）

您可以通过指定包的名称来安装最新版本的包：

```
(tutorial-env) $ python -m pip install novas
Collecting novas
  Downloading novas-3.1.1.3.tar.gz (136kB)
Installing collected packages: novas
  Running setup.py install for novas
Successfully installed novas-3.1.1.3
```

您还可以通过提供包名称后跟 `==` 和版本号来安装特定版本的包：

```
(tutorial-env) $ python -m pip install requests==2.6.0
Collecting requests==2.6.0
  Using cached requests-2.6.0-py2.py3-none-any.whl
Installing collected packages: requests
Successfully installed requests-2.6.0
```

If you re-run this command, `pip` will notice that the requested version is already installed and do nothing.  You can supply a different version number to get that version, or you can run `python -m pip install --upgrade` to upgrade the package to the latest version:

```
(tutorial-env) $ python -m pip install --upgrade requests
Collecting requests
Installing collected packages: requests
  Found existing installation: requests 2.6.0
    Uninstalling requests-2.6.0:
      Successfully uninstalled requests-2.6.0
Successfully installed requests-2.7.0
```

`python -m pip uninstall` followed by one or more package names will remove the packages from the virtual environment.

`python -m pip show` will display information about a particular package:

```
(tutorial-env) $ python -m pip show requests
---
Metadata-Version: 2.0
Name: requests
Version: 2.7.0
Summary: Python HTTP for Humans.
Home-page: http://python-requests.org
Author: Kenneth Reitz
Author-email: me@kennethreitz.com
License: Apache 2.0
Location: /Users/akuchling/envs/tutorial-env/lib/python3.4/site-packages
Requires:
```

`python -m pip list` will display all of the packages installed in the virtual environment:

```
(tutorial-env) $ python -m pip list
novas (3.1.1.3)
numpy (1.9.2)
pip (7.0.3)
requests (2.7.0)
setuptools (16.0)
```

`python -m pip freeze` will produce a similar list of the installed packages, but the output uses the format that `python -m pip install` expects. A common convention is to put this list in a `requirements.txt` file:

```
(tutorial-env) $ python -m pip freeze > requirements.txt
(tutorial-env) $ cat requirements.txt
novas==3.1.1.3
numpy==1.9.2
requests==2.7.0
```

然后可以将 `requirements.txt` 提交给版本控制并作为应用程序的一部分提供。然后用户可以使用 `install -r` 安装所有必需的包：

```
(tutorial-env) $ python -m pip install -r requirements.txt
Collecting novas==3.1.1.3 (from -r requirements.txt (line 1))
  ...
Collecting numpy==1.9.2 (from -r requirements.txt (line 2))
  ...
Collecting requests==2.7.0 (from -r requirements.txt (line 3))
  ...
Installing collected packages: novas, numpy, requests
  Running setup.py install for novas
Successfully installed novas-3.1.1.3 numpy-1.9.2 requests-2.7.0
```

`pip` 有更多选择。有关 `pip` 的完整文档，请参阅 [安装 Python 模块](https://docs.python.org/zh-cn/3.11/installing/index.html#installing-index) 指南。当您编写一个包并希望在 Python 包索引中使它可用时，请参考 [分发 Python 模块](https://docs.python.org/zh-cn/3.11/distributing/index.html#distributing-index) 指南。

# 14. 交互式编辑和编辑历史

某些版本的 Python 解释器支持编辑当前输入行和编辑历史记录，类似 Korn shell 和 GNU Bash shell 的功能 。这个功能使用了 [GNU Readline](https://tiswww.case.edu/php/chet/readline/rltop.html) 来实现，一个支持多种编辑方式的库。这个库有它自己的文档，在这里我们就不重复说明了。



## 14.1. Tab 补全和编辑历史

在解释器启动的时候，补全变量和模块名的功能将 [自动打开](https://docs.python.org/zh-cn/3.11/library/site.html#rlcompleter-config)，以便在按下 Tab 键的时候调用补全函数。它会查看 Python 语句名称，当前局部变量和可用的模块名称。处理像 `string.a` 的表达式，它会求值在最后一个 `'.'` 之前的表达式，接着根据求值结果对象的属性给出补全建议。如果拥有 `__getattr__()` 方法的对象是表达式的一部分，注意这可能会执行程序定义的代码。默认配置下会把编辑历史记录保存在用户目录下名为 `.python_history` 的文件。在下一次 Python 解释器会话期间，编辑历史记录仍旧可用。



## 14.2. 默认交互式解释器的替代品

Python 解释器与早期版本的相比，向前迈进了一大步；无论怎样，还有些希望的功能：如果能在编辑连续行时建议缩进（解析器知道接下来是否需要缩进符号），那将很棒。补全机制可以使用解释器的符号表。有命令去检查（甚至建议）括号，引号以及其他符号是否匹配。

一个可选的增强型交互式解释器是 [IPython](https://ipython.org/)，它已经存在了有一段时间，它具有 tab 补全，探索对象和高级历史记录管理功能。它还可以彻底定制并嵌入到其他应用程序中。另一个相似的增强型交互式环境是 [bpython](https://www.bpython-interpreter.org/)。

# 15. 浮点算术：争议和限制

Floating-point numbers are represented in computer hardware as base 2 (binary) fractions.  For example, the **decimal** fraction `0.125` has value 1/10 + 2/100 + 5/1000, and in the same way the **binary** fraction `0.001` has value 0/2 + 0/4 + 1/8. These two fractions have identical values, the only real difference being that the first is written in base 10 fractional notation, and the second in base 2.

不幸的是，大多数的十进制小数都不能精确地表示为二进制小数。这导致在大多数情况下，你输入的十进制浮点数都只能近似地以二进制浮点数形式储存在计算机中。

用十进制来理解这个问题显得更加容易一些。考虑分数 1/3 。我们可以得到它在十进制下的一个近似值

```
0.3
```

或者，更近似的，:

```
0.33
```

或者，更近似的，:

```
0.333
```

以此类推。结果是无论你写下多少的数字，它都永远不会等于 1/3 ，只是更加更加地接近 1/3 。

同样的道理，无论你使用多少位以 2 为基数的数码，十进制的 0.1 都无法精确地表示为一个以 2 为基数的小数。 在以 2 为基数的情况下， 1/10 是一个无限循环小数

```
0.0001100110011001100110011001100110011001100110011...
```

在任何一个位置停下，你都只能得到一个近似值。因此，在今天的大部分架构上，浮点数都只能近似地使用二进制小数表示，对应分数的分子使用每 8 字节的前 53 位表示，分母则表示为 2 的幂次。在 1/10 这个例子中，相应的二进制分数是 `3602879701896397 / 2 ** 55` ，它很接近 1/10 ，但并不是 1/10 。

大部分用户都不会意识到这个差异的存在，因为 Python 只会打印计算机中存储的二进制值的十进制近似值。在大部分计算机中，如果 Python 想把 0.1 的二进制对应的精确十进制打印出来，将会变成这样

\>>>

```

0.1
0.1000000000000000055511151231257827021181583404541015625
```

这比大多数人认为有用的数字更多，因此Python通过显示舍入值来保持可管理的位数

\>>>

```

1 / 10
0.1
```

牢记，即使输出的结果看起来好像就是 1/10 的精确值，实际储存的值只是最接近 1/10 的计算机可表示的二进制分数。

有趣的是，有许多不同的十进制数共享相同的最接近的近似二进制小数。例如， `0.1` 、 `0.10000000000000001` 、 `0.1000000000000000055511151231257827021181583404541015625` 全都近似于 `3602879701896397 / 2 ** 55` 。由于所有这些十进制值都具有相同的近似值，因此可以显示其中任何一个，同时仍然保留不变的 `eval(repr(x)) == x` 。

在历史上，Python 提示符和内置的 [`repr()`](https://docs.python.org/zh-cn/3.11/library/functions.html#repr) 函数会选择具有 17 位有效数字的来显示，即 `0.10000000000000001`。 从 Python 3.1 开始，Python（在大多数系统上）现在能够选择这些表示中最短的并简单地显示 `0.1` 。

请注意这种情况是二进制浮点数的本质特性：它不是 Python 的错误，也不是你代码中的错误。 你会在所有支持你的硬件中的浮点运算的语言中发现同样的情况（虽然某些语言在默认状态或所有输出模块下都不会 *显示* 这种差异）。

想要更美观的输出，你可能会希望使用字符串格式化来产生限定长度的有效位数:

\>>>

```

format(math.pi, '.12g')  # give 12 significant digits
'3.14159265359'
format(math.pi, '.2f')   # give 2 digits after the point
'3.14'
repr(math.pi)
'3.141592653589793'
```

必须重点了解的是，这在实际上只是一个假象：你只是将真正的机器码值进行了舍入操作再 *显示* 而已。

一个假象还可能导致另一个假象。 例如，由于这个 0.1 并非真正的 1/10，将三个 0.1 的值相加也不一定能恰好得到 0.3:

\>>>

```

.1 + .1 + .1 == .3
False
```

而且，由于这个 0.1 无法精确表示 1/10 的值而这个 0.3 也无法精确表示 3/10 的值，使用 [`round()`](https://docs.python.org/zh-cn/3.11/library/functions.html#round) 函数进行预先舍入也是没用的:

\>>>

```

round(.1, 1) + round(.1, 1) + round(.1, 1) == round(.3, 1)
False
```

虽然这些小数无法精确表示其所要代表的实际值，[`round()`](https://docs.python.org/zh-cn/3.11/library/functions.html#round) 函数还是可以用来“事后舍入”，使得实际的结果值可以做相互比较:

\>>>

```

round(.1 + .1 + .1, 10) == round(.3, 10)
True
```

Binary floating-point arithmetic holds many surprises like this.  The problem with "0.1" is explained in precise detail below, in the "Representation Error" section.  See [Examples of Floating Point Problems](https://jvns.ca/blog/2023/01/13/examples-of-floating-point-problems/) for a pleasant summary of how binary floating-point works and the kinds of problems commonly encountered in practice.  Also see [The Perils of Floating Point](https://www.lahey.com/float.htm) for a more complete account of other common surprises.

正如那篇文章的结尾所言，“对此问题并无简单的答案。” 但是也不必过于担心浮点数的问题！ Python  浮点运算中的错误是从浮点运算硬件继承而来，而在大多数机器上每次浮点运算得到的 2**53 数码位都会被作为 1 个整体来处理。  这对大多数任务来说都已足够，但你确实需要记住它并非十进制算术，且每次浮点运算都可能会导致新的舍入错误。

虽然病态的情况确实存在，但对于大多数正常的浮点运算使用来说，你只需简单地将最终显示的结果舍入为你期望的十进制数值即可得到你期望的结果。 [`str()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str) 通常已足够，对于更精度的控制可参看 [格式字符串语法](https://docs.python.org/zh-cn/3.11/library/string.html#formatstrings) 中 [`str.format()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#str.format) 方法的格式描述符。

对于需要精确十进制表示的使用场景，请尝试使用 [`decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#module-decimal) 模块，该模块实现了适合会计应用和高精度应用的十进制运算。

另一种形式的精确运算由 [`fractions`](https://docs.python.org/zh-cn/3.11/library/fractions.html#module-fractions) 模块提供支持，该模块实现了基于有理数的算术运算（因此可以精确表示像 1/3 这样的数值）。

If you are a heavy user of floating-point operations you should take a look at the NumPy package and many other packages for mathematical and statistical operations supplied by the SciPy project. See <https://scipy.org>.

Python 也提供了一些工具，可以在你真的 *想要* 知道一个浮点数精确值的少数情况下提供帮助。 例如 [`float.as_integer_ratio()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#float.as_integer_ratio) 方法会将浮点数表示为一个分数:

\>>>

```

x = 3.14159
x.as_integer_ratio()
(3537115888337719, 1125899906842624)
```

由于这是一个精确的比值，它可以被用来无损地重建原始值:

\>>>

```

x == 3537115888337719 / 1125899906842624
True
```

[`float.hex()`](https://docs.python.org/zh-cn/3.11/library/stdtypes.html#float.hex) 方法会以十六进制（以 16 为基数）来表示浮点数，同样能给出保存在你的计算机中的精确值:

\>>>

```

x.hex()
'0x1.921f9f01b866ep+1'
```

这种精确的十六进制表示法可被用来精确地重建浮点值:

\>>>

```

x == float.fromhex('0x1.921f9f01b866ep+1')
True
```

由于这种表示法是精确的，它适用于跨越不同版本（平台无关）的 Python 移植数值，以及与支持相同格式的其他语言（例如 Java 和 C99）交换数据.

另一个有用的工具是 [`math.fsum()`](https://docs.python.org/zh-cn/3.11/library/math.html#math.fsum) 函数，它有助于减少求和过程中的精度损失。 它会在数值被添加到总计值的时候跟踪“丢失的位”。 这可以很好地保持总计值的精确度， 使得错误不会积累到能影响结果总数的程度:

\>>>

```

sum([0.1] * 10) == 1.0
False
math.fsum([0.1] * 10) == 1.0
True
```



## 15.1. 表示性错误

本小节将详细解释 "0.1" 的例子，并说明你可以怎样亲自对此类情况进行精确分析。 假定前提是已基本熟悉二进制浮点表示法。

*表示性错误* 是指某些（其实是大多数）十进制小数无法以二进制（以 2 为基数的计数制）精确表示这一事实造成的错误。 这就是为什么 Python（或者 Perl、C、C++、Java、Fortran 以及许多其他语言）经常不会显示你所期待的精确十进制数值的主要原因。

Why is that?  1/10 is not exactly representable as a binary fraction.  Since at least 2000, almost all machines use IEEE 754 binary floating-point arithmetic, and almost all platforms map Python floats to IEEE 754 binary64 "double precision" values.  IEEE 754 binary64 values contain 53 bits of precision, so on input the computer strives to convert 0.1 to the closest fraction it can of the form *J*/2***N* where *J* is an integer containing exactly 53 bits. Rewriting

```
1 / 10 ~= J / (2**N)
```

写为

```
J ~= 2**N / 10
```

并且由于 *J* 恰好有 53 位 (即 `>= 2**52` 但 `< 2**53`)，*N* 的最佳值为 56:

\>>>

```

2**52 <=  2**56 // 10  < 2**53
True
```

也就是说，56 是唯一的 *N* 值能令 *J* 恰好有 53 位。 这样 *J* 的最佳可能值就是经过舍入的商:

\>>>

```

q, r = divmod(2**56, 10)
r
6
```

由于余数超过 10 的一半，最佳近似值可通过四舍五入获得:

\>>>

```

q+1
7205759403792794
```

Therefore the best possible approximation to 1/10 in IEEE 754 double precision is:

```
7205759403792794 / 2 ** 56
```

分子和分母都除以二则结果小数为:

```
3602879701896397 / 2 ** 55
```

请注意由于我们做了向上舍入，这个结果实际上略大于 1/10；如果我们没有向上舍入，则商将会略小于 1/10。 但无论如何它都不会是 *精确的* 1/10！

So the computer never "sees" 1/10:  what it sees is the exact fraction given above, the best IEEE 754 double approximation it can get:

\>>>

```

0.1 * 2 ** 55
3602879701896397.0
```

如果我们将该小数乘以 10**55，我们可以看到该值输出为 55 位的十进制数:

\>>>

```

3602879701896397 * 10 ** 55 // 2 ** 55
1000000000000000055511151231257827021181583404541015625
```

这意味着存储在计算机中的确切数值等于十进制数值  0.1000000000000000055511151231257827021181583404541015625。 许多语言（包括较旧版本的  Python）都不会显示这个完整的十进制数值，而是将结果舍入为 17 位有效数字:

\>>>

```

format(0.1, '.17f')
'0.10000000000000001'
```

[`fractions`](https://docs.python.org/zh-cn/3.11/library/fractions.html#module-fractions) 和 [`decimal`](https://docs.python.org/zh-cn/3.11/library/decimal.html#module-decimal) 模块可令进行此类计算更加容易:

\>>>

```

from decimal import Decimal
from fractions import Fraction
Fraction.from_float(0.1)
Fraction(3602879701896397, 36028797018963968)
(0.1).as_integer_ratio()
(3602879701896397, 36028797018963968)
Decimal.from_float(0.1)
Decimal('0.1000000000000000055511151231257827021181583404541015625')
format(Decimal.from_float(0.1), '.17')
'0.10000000000000001'
```

# 16. 附录



## 16.1. 交互模式



### 16.1.1. 错误处理

当发生错误时，解释器会打印错误信息和错误堆栈。在交互模式下，将返回到主命令提示符；如果输入内容来自文件，在打印错误堆栈之后，程序会以非零状态退出。（这里所说的错误不包括 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句中由 [`except`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#except) 所捕获的异常。）有些错误是无条件致命的，会导致程序以非零状态退出；比如内部逻辑矛盾或内存耗尽。所有错误信息都会被写入标准错误流；而命令的正常输出则被写入标准输出流。

将中断字符（通常为 Control-C 或 Delete ）键入主要或辅助提示会取消输入并返回主提示符。 [1](https://docs.python.org/zh-cn/3.11/tutorial/appendix.html#id2) 在执行命令时键入中断引发的 [`KeyboardInterrupt`](https://docs.python.org/zh-cn/3.11/library/exceptions.html#KeyboardInterrupt) 异常，可以由 [`try`](https://docs.python.org/zh-cn/3.11/reference/compound_stmts.html#try) 语句处理。



### 16.1.2. 可执行的Python脚本

在BSD等类Unix系统上，Python脚本可以直接执行，就像shell脚本一样，第一行添加:

```
#!/usr/bin/env python3.5
```

（假设解释器位于用户的 `PATH` ）脚本的开头，并将文件设置为可执行。 `#!` 必须是文件的前两个字符。在某些平台上，第一行必须以Unix样式的行结尾（`'\n'`）结束，而不是以Windows（`'\r\n'`）行结尾。请注意，散列或磅字符 `'#'` 在Python中代表注释开始。

可以使用 **chmod** 命令为脚本提供可执行模式或权限。

```
chmod +x myscript.py
```

在Windows系统上，没有“可执行模式”的概念。 Python安装程序自动将 `.py` 文件与 `python.exe` 相关联，这样双击Python文件就会将其作为脚本运行。扩展也可以是 `.pyw` ，在这种情况下，会隐藏通常出现的控制台窗口。



### 16.1.3. 交互式启动文件

当您以交互方式使用Python时，每次启动解释器时都会执行一些标准命令，这通常很方便。您可以通过将名为 [`PYTHONSTARTUP`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#envvar-PYTHONSTARTUP) 的环境变量设置为包含启动命令的文件名来实现。这类似于Unix shell的 `.profile` 功能。

此文件只会在交互式会话时读取，而非在 Python 从脚本读取指令或是在给定 `/dev/tty` 为指令的明确来源时（后者反而表现得像是一个交互式会话）。 该文件执行时所在的命名空间与交互式指令相同，所以它定义或导入的对象可以在交互式会话中直接使用。 你也可以在该文件中更改提示符 `sys.ps1` 和 `sys.ps2`。

如果你想从当前目录中读取一个额外的启动文件，你可以使用像 `if os.path.isfile('.pythonrc.py'): exec(open('.pythonrc.py').read())` 这样的代码在全局启动文件中对它进行编程。如果要在脚本中使用启动文件，则必须在脚本中显式执行此操作:

```
import os
filename = os.environ.get('PYTHONSTARTUP')
if filename and os.path.isfile(filename):
    with open(filename) as fobj:
        startup_file = fobj.read()
    exec(startup_file)
```



### 16.1.4. 定制模块

Python提供了两个钩子来让你自定义它：`sitecustomize` 和 `usercustomize`。要查看其工作原理，首先需要找到用户site-packages目录的位置。启动Python并运行此代码:

\>>>

```

import site
site.getusersitepackages()
'/home/user/.local/lib/python3.5/site-packages'
```

现在，您可以在该目录中创建一个名为 `usercustomize.py` 的文件，并将所需内容放入其中。它会影响Python的每次启动，除非它以 [`-s`](https://docs.python.org/zh-cn/3.11/using/cmdline.html#cmdoption-s) 选项启动，以禁用自动导入。

`sitecustomize` 以相同的方式工作，但通常由计算机管理员在全局 site-packages 目录中创建，并在 `usercustomize` 之前被导入。有关详情请参阅 [`site`](https://docs.python.org/zh-cn/3.11/library/site.html#module-site) 模块的文档。

备注

- [1](https://docs.python.org/zh-cn/3.11/tutorial/appendix.html#id1)

  GNU Readline 包的问题可能会阻止这种情况。



# 安装 Python 模块

- 电子邮箱

  [distutils-sig@python.org](mailto:distutils-sig@python.org)

作为一个流行的开源开发项目，Python拥有一个活跃的贡献者和用户支持社区，这些社区也可以让他们的软件可供其他Python开发人员在开源许可条款下使用。

这允许Python用户有效地共享和协作，从其他人已经创建的解决方案中受益于常见（有时甚至是罕见的）问题，以及可以提供他们自己的解决方案。

本指南涵盖了分发部分的流程。有关安装其他Python项目的指南，请参阅 [安装指南](https://docs.python.org/zh-cn/3.11/distributing/index.html#distributing-index)。

备注

对于企业和其他机构用户，请注意许多组织都有自己的政策来使用和贡献开源软件。在使用Python提供的分发和安装工具时，请考虑这些政策。

## 关键术语

- `pip` 是首选的安装程序。从Python 3.4开始，它默认包含在Python二进制安装程序中。
- *virtual environment* 是一种半隔离的 Python 环境，允许为特定的应用安装各自的包，而不是安装到整个系统。
- `venv` 是创建虚拟环境的标准工具，从 Python 3.3 开始成为 Python 的组成部分。 从 Python 3.4 开始，它会默认安装 `pip` 到所创建的全部虚拟环境。
- `virtualenv` 是 `venv` 的第三方替代（及其前身）。 它允许在 Python 3.4 之前的版本中使用虚拟环境，那些版本或是完全不提供 `venv`，或是不会自动安装 `pip` 到所创建的虚拟环境。
- [Python Package Index](https://pypi.org) 是一个开源许可的软件包公共存储库，可供所有 Python 用户使用。
- [Python Packaging Authority](https://www.pypa.io/) 是负责标准打包工具以及相关元数据和文件格式标准维护与改进的开发人员和文档作者团队。 他们基于 [GitHub](https://github.com/pypa) 和 [Bitbucket](https://bitbucket.org/pypa/) 这两个平台维护着各种工具、文档和问题追踪系统。
- `distutils` 是最初的构建和分发系统，于 1998 年首次加入 Python 标准库。 虽然直接使用 `distutils` 的方式已被淘汰，它仍然是当前打包和分发架构的基础，而且它不仅仍然是标准库的一部分，这个名称还以其他方式存在（例如用于协调 Python 打包标准开发流程的邮件列表就以此命名）。

在 3.5 版更改: 现在推荐使用 `venv` 来创建虚拟环境。

参见

[Python 软件包用户指南：创建和使用虚拟环境](https://packaging.python.org/installing/#creating-virtual-environments)

## 基本使用

标准打包工具完全是针对命令行使用方式来设计的。

以下命令将从 Python Package Index 安装一个模块的最新版本及其依赖项:

```
python -m pip install SomePackage
```

备注

对于 POSIX 用户（包括 macOS 和 Linux 用户）本指南中的示例假定使用了 [virtual environment](https://docs.python.org/zh-cn/3.11/glossary.html#term-virtual-environment)。

对于 Windows 用户，本指南中的示例假定在安装 Python 时选择了修改系统 PATH 环境变量。

在命令行中指定一个准确或最小版本也是可以的。 当使用比较运算符例如 `>`, `<` 或其他某些可以被终端所解析的特殊字符时，包名称与版本号应当用双引号括起来:

```
python -m pip install SomePackage==1.0.4    # specific version
python -m pip install "SomePackage>=1.0.4"  # minimum version
```

通常，如果一个匹配的模块已安装，尝试再次安装将不会有任何效果。 要升级现有模块必须显式地发出请求:

```
python -m pip install --upgrade SomePackage
```

更多有关 `pip` 及其功能的信息和资源可以在 [Python 软件包用户指南](https://packaging.python.org) 中找到。

虚拟环境的创建可使用 [`venv`](https://docs.python.org/zh-cn/3.11/library/venv.html#module-venv) 模块来完成。 向已激活虚拟环境安装软件包可使用上文所介绍的命令。

参见

[Python 软件包用户指南：安装 Python 分发包](https://packaging.python.org/installing/)

## 我应如何 ...？

这是一些常见任务的快速解答或相关链接。

### ... 在 Python 3.4 之前的 Python 版本中安装 `pip` ？

Python 捆绑 `pip` 是从 Python 3.4 才开始的。 对于更早的版本，`pip` 需要“引导安装”，具体说明参见 Python 软件包用户指南。

参见

[Python 软件包用户指南：安装软件包的前提要求](https://packaging.python.org/installing/#requirements-for-installing-packages)

### ... 只为当前用户安装软件包？

将 `--user` 选项传入 `python -m pip install` 将只为当前用户而非为系统中的所有用户安装软件包。

### ... 安装科学计算类 Python 软件包？

许多科学计算类 Python 软件包都有复杂的二进制编译文件依赖，直接使用 `pip` 安装目前并不太容易。 在当前情况下，通过 [其他方式](https://packaging.python.org/science/) 而非尝试用 `pip` 安装这些软件包对用户来说通常会更容易。

参见

[Python 软件包用户指南：安装科学计算类软件包](https://packaging.python.org/science/)

### ... 使用并行安装的多个 Python 版本？

在 Linux, macOS 以及其他 POSIX 系统中，使用带版本号的 Python 命令配合 `-m` 开关选项来运行特定版本的 `pip`:

```
python2   -m pip install SomePackage  # default Python 2
python2.7 -m pip install SomePackage  # specifically Python 2.7
python3   -m pip install SomePackage  # default Python 3
python3.4 -m pip install SomePackage  # specifically Python 3.4
```

也可以使用带特定版本号的 `pip` 命令。

在 Windows 中，使用 `py` Python 启动器命令配合 `-m` 开关选项:

```
py -2   -m pip install SomePackage  # default Python 2
py -2.7 -m pip install SomePackage  # specifically Python 2.7
py -3   -m pip install SomePackage  # default Python 3
py -3.4 -m pip install SomePackage  # specifically Python 3.4
```

## 常见的安装问题

### 在 Linux 的系统 Python 版本上安装

Linux 系统通常会将某个 Python 版本作为发行版的一部分包含在内。 将软件包安装到这个 Python 版本上需要系统 root 权限，并可能会干扰到系统包管理器和其他系统组件的运作，如果这些组件在使用 `pip` 时被意外升级的话。

在这样的系统上，通过 `pip` 安装软件包通常最好是使用虚拟环境或分用户安装。

### 未安装 pip

默认情况下可能未安装 `pip`，一种可选解决方案是:

```
python -m ensurepip --default-pip
```

There are also additional resources for [installing pip.](https://packaging.python.org/en/latest/tutorials/installing-packages/#ensure-pip-setuptools-and-wheel-are-up-to-date)

### 安装二进制编译扩展

Python 通常非常依赖基于源代码的发布方式，也就是期望最终用户在安装过程中使用源码来编译生成扩展模块。

随着对二进制码 `wheel` 格式支持的引入，以及通过 Python Package Index 至少发布 Windows 和 macOS 版的 wheel 文件，预计此问题将逐步得到解决，因为用户将能够更频繁地安装预编译扩展，而不再需要自己编译它们。

某些用来安装 [科学计算类软件包](https://packaging.python.org/science/) 的解决方案对于尚未提供预编译 `wheel` 文件的那些扩展模块来说，也有助于用户在无需进行本机编译的情况下获取二进制码扩展模块。



# 分发 Python 模块

- 电子邮箱

  [distutils-sig@python.org](mailto:distutils-sig@python.org)

作为一个流行的开源开发项目，Python拥有一个活跃的贡献者和用户支持社区，这些社区也可以让他们的软件可供其他Python开发人员在开源许可条款下使用。

这允许Python用户有效地共享和协作，从其他人已经创建的解决方案中受益于常见（有时甚至是罕见的）问题，以及可以提供他们自己的解决方案。

本指南涵盖了分发部分的流程。有关安装其他Python项目的指南，请参阅 [安装指南](https://docs.python.org/zh-cn/3.11/installing/index.html#installing-index)。

备注

对于企业和其他机构用户，请注意许多组织都有自己的政策来使用和贡献开源软件。在使用Python提供的分发和安装工具时，请考虑这些政策。

## 关键术语

- [Python Package Index](https://pypi.org) 是一个开源许可的软件包公共存储库，可供所有 Python 用户使用。
- [Python Packaging Authority](https://www.pypa.io/) 是负责标准打包工具以及相关元数据和文件格式标准维护与改进的开发人员和文档作者团队。 他们基于 [GitHub](https://github.com/pypa) 和 [Bitbucket](https://bitbucket.org/pypa/) 这两个平台维护着各种工具、文档和问题追踪系统。
- [`distutils`](https://docs.python.org/zh-cn/3.11/library/distutils.html#module-distutils) 是 1998 年首次添加到 Python 标准库的原始构建和分发系统。 虽然直接使用 [`distutils`](https://docs.python.org/zh-cn/3.11/library/distutils.html#module-distutils) 正在逐步淘汰，但它仍然为当前的打包和分发基础架构奠定了基础它不仅仍然是标准库的一部分，而且它的名称还以其他方式存在（例如用于协调 Python 打包标准开发的邮件列表的名称）。
- [setuptools](https://setuptools.readthedocs.io/en/latest/) （在很大程度上）是作为 [`distutils`](https://docs.python.org/zh-cn/3.11/library/distutils.html#module-distutils) 的取代者，于 2004 年首次发布。 它对未经修改的 [`distutils`](https://docs.python.org/zh-cn/3.11/library/distutils.html#module-distutils) 工具最重要的补充是能够声明对其他包的依赖。 目前它被推荐用来替代 [`distutils`](https://docs.python.org/zh-cn/3.11/library/distutils.html#module-distutils)，其更新更为频繁，在更为多样的 Python 版本之上为最新的打包标准提供持续支持。
- [wheel](https://wheel.readthedocs.io/) （在此上下文中）是一个将 `bdist_wheel` 命令添加到 [`distutils`](https://docs.python.org/zh-cn/3.11/library/distutils.html#module-distutils)/[setuptools](https://setuptools.readthedocs.io/en/latest/) 的项目。这产生了一个跨平台的二进制打包格式（称为“轮子”或“轮子文件”，并在 [**PEP 427**](https://peps.python.org/pep-0427/) 中定义），它允许在系统上安装Python库，甚至包括二进制扩展的库，而不需在本地进行构建。

## 开源许可与协作

在世界上大多数地方，软件自动受版权保护。这意味着其他开发人员需要明确的权限来复制，使用，修改和重新分发软件。

开源许可是一种以相对一致的方式明确授予此类权限的方式，允许开发人员通过为各种问题免费提供通用解决方案来有效地共享和协作。这使得许多开发人员可以将更多时间用于关注他们特定情况相对独特的问题。

Python提供的分发工具旨在使开发人员选择开源时，可以合理地直接将其自己的贡献回馈到该公共软件池。

无论该软件是否作为开源软件发布，相同的分发工具也可用于在组织内分发软件。

## 安装相关工具

标准库不包括支持现代Python打包标准的构建工具，因为核心开发团队已经发现，即使在旧版本的Python上，使用一致工作的标准工具也很重要。

可以通过在命令行调用 `pip` 模块来安装当前推荐的构建和分发工具:

```
python -m pip install setuptools wheel twine
```

备注

对于 POSIX 用户（包括 macOS 和 Linux 用户），这些说明假定使用了 [virtual environment](https://docs.python.org/zh-cn/3.11/glossary.html#term-virtual-environment) 。

对于Windows用户，这些说明假定在安装Python时选择了调整系统PATH环境变量的选项。

Python 打包用户指南包含有关 [当前推荐工具的](https://packaging.python.org/guides/tool-recommendations/#packaging-tool-recommendations) 的更多详细信息。



## 阅读 Python 打包用户指南

“Python 打包用户指南”介绍了创建和发布项目所涉及的各个关键步骤和元素：

- [项目的结构](https://packaging.python.org/tutorials/packaging-projects/#packaging-python-projects)
- [项目的构建与打包](https://packaging.python.org/tutorials/packaging-projects/#creating-the-package-files)
- [Uploading the project to the Python Package Index](https://packaging.python.org/tutorials/packaging-projects/#uploading-the-distribution-archives)
- [The .pypirc file](https://packaging.python.org/specifications/pypirc/)

## 我该如何...？

这是一些常见任务的快速解答或相关链接。

### ...为我的项目选择一个名字？

这不是一个简单的主题，但这里有一些提示：

- 检查 Python Package Index 以查看该名称是否已被使用
- 检查流行的托管网站如 GitHub，Bitbucket 等等，看是否已有一个该名称的项目
- 检查您正在考虑的名称在网络搜索中出现的内容
- 避免使用特别常见的单词，尤其是具有多重含义的单词，因为它们会使用户在搜索时难以找到您的软件

### ...创建和分发二进制扩展？

这实际上是一个非常复杂的主题，根据您的目标，可以提供各种替代方案。 有关更多信息和建议，请参阅 Python 打包用户指南。

# 第 2 章 安装和使用 Python

​			在 RHEL 9 中，**Python 3.9** 是默认的 **Python** 实施。从 RHEL 9.2 开始，**Python 3.11** 作为 `python3.11` 软件包套件提供。 	

​			unversioned `python` 命令指向默认的 **Python 3.9** 版本。 	

## 2.1. 安装 Python 3

​				默认 **Python** 实现通常默认安装。要手动安装它，请使用以下步骤。 		

**步骤**

- ​						要安装 **Python 3.9**，请使用： 				

  

  ```none
  # dnf install python3
  ```

- ​						要安装 **Python 3.11**，请使用： 				

  

  ```none
  # dnf install python3.11
  ```

**验证步骤**

- ​						要验证系统上安装的 **Python** 版本，请使用 `--version` 选项以及特定于您所需版本的 **Python** 命令的 `python` 命令。 				

- ​						对于 **Python 3.9** ： 				

  

  ```none
  $ python3 --version
  ```

- ​						对于 **Python 3.11** ： 				

  

  ```none
  $ python3.11 --version
  ```

## 2.2. 安装其他 Python 3 软件包

​				前缀为 `python3-` 的软件包包含默认 **Python 3.9** 版本的附加组件模块。前缀为 `python3.11-` 的软件包包含 **Python 3.11** 的附加组件模块。 		

**步骤**

- ​						要为 **Python 3.9** 安装 `Requests` 模块，请使用： 				

  

  ```none
  # dnf install python3-requests
  ```

- ​						要从 **Python 3.9** 安装 `pip` 软件包安装程序，请使用： 				

  

  ```none
  # dnf install python3-pip
  ```

- ​						要从 **Python 3.11** 安装 `pip` 软件包安装程序，请使用： 				

  

  ```none
  # dnf install python3.11-pip
  ```

**其他资源**

- ​						[有关 Python 附加组件模块的上游文档](https://docs.python.org/3/tutorial/modules.html) 				

## 2.3. 为开发人员安装其他 Python 3 工具

​				开发人员的其他 **Python** 工具主要通过 CodeReady Linux Builder (CRB)存储库分发。 		

​				`python3-pytest` 软件包及其依赖项包括在 AppStream 存储库中。 		

​				例如，CRB 存储库包含以下软件包： 		

- ​						`python3*-idle` 				
- ​						`python3*-debug` 				
- ​						`python3*-Cython` 				
- ​						`python3.11-pytest` 及其依赖项。 				

重要

​					红帽不支持 CodeReady Linux Builder 存储库中的内容。 			

​				要从 CRB 存储库安装软件包，请使用以下步骤。 		

**步骤**

1. ​						启用 CodeReady Linux Builder 存储库： 				

   

   ```none
   # subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
   ```

2. ​						安装 `python3114-Cython` 软件包： 				

   - ​								对于 **Python 3.9** ： 						

     

     ```none
     # dnf install python3-Cython
     ```

   - ​								对于 **Python 3.11** ： 						

     

     ```none
     # dnf install python3.11-Cython
     ```

**其他资源**

- ​						[如何在 CodeReady Linux Builder 中启用和使用内容](https://access.redhat.com/articles/4348511) 				
- ​						[软件包清单](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/package_manifest/index) 				

## 2.4. 使用 Python

​				以下流程包含运行 **Python** 解释器或 **Python**相关命令的示例。 		

**先决条件**

- ​						确保已安装 **Python**。 				
- ​						如果要为 **Python 3.11** 下载并安装第三方应用程序，请安装 `python3.11-pip` 软件包。 				

**步骤**

- ​						要运行 **Python 3.9** 解释器或相关命令，请使用： 				

  

  ```none
  $ python3
  $ python3 -m venv --help
  $ python3 -m pip install package
  $ pip3 install package
  ```

- ​						要运行 **Python 3.11** 解释器或相关命令，请使用： 				

  

  ```none
  $ python3.11
  $ python3.11 -m venv --help
  $ python3.11 -m pip install package
  $ pip3.11 install package
  ```

# 第 3 章 打包 Python 3 RPM

​			您可以使用 `pip` 安装程序，或使用 DNF 软件包管理器在系统中安装 Python 软件包。DNF 使用 RPM 软件包格式，它提供了更好的软件下游控制。 	

​			原生 Python 软件包的打包格式由 [Python Packaging Authority (PyPA) 规范](https://www.pypa.io/en/latest/specifications/)定义。大多数 Python 项目使用 `distutils` 或 `setuptools` 实用程序进行打包，并在 `setup.py` 文件中定义的软件包信息。然而，创建原生 Python 软件包可能会随着时间而有新的演变。有关新兴打包标准的更多信息，请参阅 [pyproject-rpm-macros](https://gitlab.com/redhat/centos-stream/rpms/pyproject-rpm-macros/)。 	

​			本章论述了如何将 `setup.py` 的 Python 项目打包到一个 RPM 软件包中。与原生 Python 软件包相比，此方法提供以下优点： 	

- ​					可以对 Python 和非 Python 软件包的依赖项，并严格由 `DNF` 软件包管理器强制执行。 			
- ​					您可以用加密的方式为软件包签名。使用加密签名，您可以验证、集成和测试 RPM 软件包的内容与操作系统的其余部分。 			
- ​					您可以在构建过程中执行测试。 			

## 3.1. SPEC 文件是 Python 软件包的描述

​				SPEC 文件包含 `rpmbuild` 实用程序用于构建 RPM 的指令。这些指令包含在不同的部分。SPEC 文件有两个主要部分用于定义构建指令： 		

- ​						Preamble（包含一系列在 Body 中使用的元数据项） 				
- ​						Body（包含指令的主要部分） 				

​				与非 Python RPM SPEC 文件相比，Python 项目的 RPM SPEC 文件有一些特定信息。 		

重要

​					Python 库的任何 RPM 软件包的名称必须包括 `python3-` 或 `python3.11-` 前缀。 			

​				以下 SPEC 文件示例中显示了 `其他具体信息`。有关此类特定描述，请查看示例中的备注。 		

```specfile
%global python3_pkgversion 3.11                                       1

Name:           python-pello                                          2
Version:        1.0.2
Release:        1%{?dist}
Summary:        Example Python library

License:        MIT
URL:            https://github.com/fedora-python/Pello
Source:         %{url}/archive/v%{version}/Pello-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  python%{python3_pkgversion}-devel                     3

# Build dependencies needed to be specified manually
BuildRequires:  python%{python3_pkgversion}-setuptools

# Test dependencies needed to be specified manually
# Also runtime dependencies need to be BuildRequired manually to run tests during build
BuildRequires:  python%{python3_pkgversion}-pytest >= 3


%global _description %{expand:
Pello is an example package with an executable that prints Hello World! on the command line.}

%description %_description

%package -n python%{python3_pkgversion}-pello                         4
Summary:        %{summary}

%description -n python%{python3_pkgversion}-pello %_description


%prep
%autosetup -p1 -n Pello-%{version}


%build
# The macro only supported projects with setup.py
%py3_build                                                            5


%install
# The macro only supported projects with setup.py
%py3_install


%check                                                                6
%{pytest}


# Note that there is no %%files section for the unversioned python module
%files -n python%{python3_pkgversion}-pello
%doc README.md
%license LICENSE.txt
%{_bindir}/pello_greeting

# The library files needed to be listed manually
%{python3_sitelib}/pello/

# The metadata files needed to be listed manually
%{python3_sitelib}/Pello-*.egg-info/
```

- [*1*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-1) 

  ​						通过定义 `python3_pkgversion` 宏，您可以设置将为哪个 Python 版本构建哪个 Python 版本。要为默认的 Python 版本 3.9 构建，请将宏设置为默认值 `3` 或完全删除行。 				

- [*2*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-2) 

  ​						将 Python 项目打包到 RPM 中时，需要将 `python-` 前缀添加到项目的原始名称中。此处的原始名称为 `pello`，因此 **Source RPM (SRPM)的名称是** `python-pello`。 				

- [*3*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-3) 

  ​						**BuildRequires** 指定了构建和测试此软件包所需的软件包。在 **BuildRequires** 中，始终包括提供构建 Python 软件包所需的工具： `python3-devel` （或 `python3.11-devel`）以及软件包的特定软件所需的相关项目，如 `python3-setuptools` （或 `python3.11-setuptools`）或运行测试所需的运行时和测试依赖项。 				

- [*4*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-4) 

  ​						当为二进制 RPM 选择名称（用户必须安装的软件包）时，请添加版本化的 Python 前缀。将 `python3-` 前缀用于默认的 Python 3.9 或 Python 3.11 的 `python3.11-` 前缀。您可以使用 `%{python3_pkgversion}` 宏，它针对默认的 Python 版本 3.9 评估为 `3`，除非您将其设置为显式版本，例如 `3.11` （请参阅 footnote 1）。 				

- [*5*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-5) 

  ​						**%py3_build** 和 **%py3_install** 宏会分别运行 `setup.py build` 和 `setup.py install` 命令，使用附加参数来指定安装位置、要使用的解释器以及其他详情。 				

- [*6*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-6) 

  ​						**%check** 部分应该运行打包项目的测试。确切的命令取决于项目本身，但可以使用 **%pytest** 宏以 RPM 友好的方式运行 `pytest` 命令。 				

## 3.2. Python 3 RPM 的常见宏

​				在 SPEC 文件中，使用*用于 Python 3 RPM 的宏*表中的内容来使用宏而不是使用硬编码。您可以通过在 SPEC 文件之上定义 `python3_pkgversion` 宏来重新定义这些宏中使用的 Python 3 版本（请参阅 [第 3.1 节 “SPEC 文件是 Python 软件包的描述”](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#con_spec-file-description-for-a-python-package_assembly_packaging-python-3-rpms)）。如果您定义了 `python3_pkgversion` 宏，则下表中描述的宏值将反映指定的 Python 3 版本。 		

表 3.1. Python 3 RPM 宏

| Macro                 | 常规定义                           | 描述                                                         |
| --------------------- | ---------------------------------- | ------------------------------------------------------------ |
| %{python3_pkgversion} | 3                                  | 所有其他宏使用的 Python 版本。可以重新定义为 `3.11` 以使用 Python 3.11 |
| %{python3}            | /usr/bin/python3                   | Python 3 解释器                                              |
| %{python3_version}    | 3.9                                | Python 3 解释器的 major.minor 版本                           |
| %{python3_sitelib}    | /usr/lib/python3.9/site-packages   | 安装纯 Python 模块的位置                                     |
| %{python3_sitearch}   | /usr/lib64/python3.9/site-packages | 安装包含特定于架构扩展模块的模块的位置                       |
| %py3_build            |                                    | 使用适用于 RPM 软件包的参数运行 `setup.py build` 命令        |
| %py3_install          |                                    | 使用适用于 RPM 软件包的参数运行 `setup.py install` 命令      |
| %{py3_shebang_flags}  | s                                  | Python 解释器指令宏的默认标记集，`%py3_shebang_fix`          |
| %py3_shebang_fix      |                                    | 将 Python 解释器指令改为 `#! %{python3}`，保留任何现有标志（如果找到），并添加在 `%{py3_shebang_flags}` 宏中定义的标记 |

**其它资源**

- ​						[上游文档中的 Python 宏](https://docs.fedoraproject.org/en-US/packaging-guidelines/Python_201x/#_macros) 				

## 3.3. 为 Python RPM 使用自动生成的依赖项

​				以下流程描述了如何在将 Python 项目打包为 RPM 时使用自动生成的依赖项。 		

**先决条件**

- ​						RPM 的 SPEC 文件存在。如需更多信息，请参阅 [Python 软件包的 SPEC 文件描述](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#con_spec-file-description-for-a-python-package_assembly_packaging-python-3-rpms)。 				

**步骤**

1. ​						确保以下包含上游提供元数据的目录之一包含在生成的 RPM 中： 				

   - ​								`.dist-info` 						

   - ​								`.egg-info` 						

     ​								RPM 构建过程会自动从这些目录中生成虚拟 `pythonX.Ydist`，例如： 						

     

     ```none
     python3.9dist(pello)
     ```

     ​								然后，Python 依赖项生成器读取上游元数据，并使用生成的 `pythonX.Ydist` 虚拟提供为每个 RPM 软件包生成运行时要求。例如，生成的要求标签可能如下所示： 						

     

     ```none
     Requires: python3.9dist(requests)
     ```

2. ​						检查生成的要求。 				

3. ​						要删除其中的一些生成的需要，请使用以下方法之一： 				

   1. ​								在 SPEC 文件的 `%prep` 部分中修改上游提供的元数据。 						
   2. ​								使用[上游文档](https://fedoraproject.org/w/index.php?title=Packaging:AutoProvidesAndRequiresFiltering&oldid=530706)中描述的依赖项自动过滤。 						

4. ​						要禁用自动依赖项生成器，请在主软件包的 `%description` 声明中包含 `%{?python_disable_dependency_generator}` 宏。 				

**其它资源**

- ​						[自动生成的依赖项](https://docs.fedoraproject.org/en-US/packaging-guidelines/Python_201x/#_automatically_generated_dependencies) 				

# 第 4 章 在 Python 脚本中处理解释器指令

​			在 Red Hat Enterprise Linux 9 中，可执行 Python 脚本应该使用解析程序指令（也称为 hashbangs 或 shebangs），至少指定主 Python 版本。例如： 	



```none
#!/usr/bin/python3
#!/usr/bin/python3.9
#!/usr/bin/python3.11
```

​			在构建任何 RPM 软件包时，`/usr/lib/rpm/redhat/brp-mangle-shebangs` buildroot 策略 (BRP) 脚本会自动运行，并尝试在所有可执行文件中更正解释器指令。 	

​			当遇到带有模糊的解释解释器指令的 Python 脚本时，BRP 脚本会生成错误，例如： 	



```none
#!/usr/bin/python
```

​			或者 	



```none
#!/usr/bin/env python
```

## 4.1. 修改 Python 脚本中的解释器指令

​				使用以下步骤修改 Python 脚本中的解释器指令，以便在 RPM 构建时出现错误。 		

**先决条件**

- ​						Python 脚本中的一些解释器指令会导致构建错误。 				

**步骤**

- ​						要修改解释器指令，请完成以下任务之一： 				

  - ​								在您的 SPEC 文件的 `%prep` 部分中使用以下宏： 						

    

    ```none
    # %py3_shebang_fix SCRIPTNAME …
    ```

    ​								*SCRIPTNAME* 可以是任何文件、目录或文件和目录列表。 						

    ​								因此，列出的所有文件以及列出目录中所有 `.py` 文件都会修改其解释器指令以指向 `%{python3}`。将保留原始解释器指令的现有标记，并将添加 `%{py3_shebang_flags}` 宏中定义的其他标志。您可以在 SPEC 文件中重新定义 `%{py3_shebang_flags}` 宏，以更改将要添加的标志。 						

  - ​								从 `python3-devel` 软件包应用 `pathfix.py` 脚本： 						

    

    ```none
    # pathfix.py -pn -i %{python3} PATH …
    ```

    ​								您可以指定多个路径。如果 `*PATH*` 是一个目录，则 `pathfix.py` 会递归扫描与模式 `^[a-zA-Z0-9_]+\.py$` 匹配的 Python 脚本，而不仅仅是具有模糊的解释器指令。将上述命令添加到 `%prep` 的上面，或添加到 `%install` 部分的末尾。 						

  - ​								修改打包的 Python 脚本，以便它们符合预期格式。为此，您也可以使用 RPM 构建进程之外的 `pathfix.py` 脚本。在 RPM 构建外运行 `pathfix.py` 时，将上例中的 `%{python3}` 替换为解释器指令的路径，如 `/usr/bin/python3` 或 `/usr/bin/python3.11`。 						

**其它资源**

- ​						[解释器调用](https://docs.fedoraproject.org/en-US/packaging-guidelines/Python/#_interpreter_invocation) 				

## 版本

**Python 3.9** 是 RHEL 9 中的默认 **Python** 实现。**Python 3.9** 在 BaseOS 存储库中的非模块化 `python3` RPM 软件包中分发，通常默认安装。**Python 3.9** 将支持 RHEL 9 的整个生命周期。 		

未来，其它版本的 **Python 3** 将作为 RPM 软件包发布，且带有较短的生命周期（通过 AppStream 软件仓库）。这些版本将与 Python 3.9 并行安装。

**Python 2** 不随 RHEL 9 提供。 		

## 2.4. 使用 Python

​				以下流程包含运行 Python 解释器或 Python 相关命令的示例。 		

**先决条件**

- ​						确保已安装 Python。 				

**步骤**

- ​						要运行 Python 解释器或相关命令，请使用： 				

  ```none
  $ python3
  $ python3 -m pip --help
  $ python3 -m pip install package
  ```

# 第 3 章 打包 Python 3 RPM

​			您可以使用 `pip` 安装程序，或使用 DNF 软件包管理器在系统中安装 Python 软件包。DNF 使用 RPM 软件包格式，它提供对软件的下游控制。 	

​			原生 Python 软件包的打包格式由 [Python 打包授权机构(PyPA)规范定义](https://www.pypa.io/en/latest/specifications/)。大多数 Python 项目使用 `distutils` 或 `setuptools` 实用程序进行打包，并在 `setup.py` 文件中定义的软件包信息。然而，创建原生 Python 软件包的可能性随着时间推移而演进。有关新兴打包标准的更多信息，请参阅 [pyproject-rpm-macros](https://gitlab.com/redhat/centos-stream/rpms/pyproject-rpm-macros/)。 	

​			本章论述了如何将 `setup.py` 的 Python 项目打包到一个 RPM 软件包中。与原生 Python 软件包相比，此方法提供以下优点： 	

- ​					可以对 Python 和非 Python 软件包的依赖项，并严格由 `DNF` 软件包管理器强制执行。 			
- ​					您可以用加密的方式为软件包签名。使用加密签名，您可以验证、集成和测试 RPM 软件包的内容与操作系统的其余部分。 			
- ​					您可以在构建过程中执行测试。 			

## 3.1. Python 软件包的 SPEC 文件描述

​				SPEC 文件包含 `rpmbuild` 实用程序用于构建 RPM 的指令。这些说明包含在一系列部分中。SPEC 文件有两个主要部分，它们定义了该部分： 		

- ​						preamble（包含一系列在 Body 中使用的元数据项） 				
- ​						正文（包含指令的主要部分） 				

​				与非 Python RPM SPEC 文件相比，适用于 Python 项目的 RPM SPEC 文件有一些特定信息。 		

重要

​					Python 库的任何 RPM 软件包的名称必须始终包含 `python3-` 前缀。 			

​				其他具体信息可在以下 **适用于 `python3-pello` 软件包 的 SPEC 文件示例** 中显示。有关此类特定描述，请查看示例中的备注。 		

```specfile
Name:           python-pello                                          1
Version:        1.0.2
Release:        1%{?dist}
Summary:        Example Python library

License:        MIT
URL:            https://github.com/fedora-python/Pello
Source:         %{url}/archive/v%{version}/Pello-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  python3-devel                                         2

# Build dependencies needed to be specified manually
BuildRequires:  python3-setuptools

# Test dependencies needed to be specified manually
# Also runtime dependencies need to be BuildRequired manually to run tests during build
BuildRequires:  python3-pytest >= 3


%global _description %{expand:
Pello is an example package with an executable that prints Hello World! on the command line.}

%description %_description

%package -n python3-pello                                             3
Summary:        %{summary}

%description -n python3-pello %_description


%prep
%autosetup -p1 -n Pello-%{version}


%build
# The macro only supported projects with setup.py
%py3_build                                                            4


%install
# The macro only supported projects with setup.py
%py3_install


%check                                                                5
%{pytest}


# Note that there is no %%files section for the unversioned python module
%files -n python3-pello
%doc README.md
%license LICENSE.txt
%{_bindir}/pello_greeting

# The library files needed to be listed manually
%{python3_sitelib}/pello/

# The metadata files needed to be listed manually
%{python3_sitelib}/Pello-*.egg-info/
```

- [*1*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-1) 

  ​						将 Python 项目打包到 RPM 中时，始终将 `python-` 前缀添加到项目的原始名称。这里的原始名称为 `pello`，因此 **源 RPM(SRPM)** 的名称是 `python-pello`。 				

- [*2*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-2) 

  ​						**BuildRequires** 指定构建并测试此软件包所需的软件包。在 **BuildRequires** 中，始终包括提供构建 Python 软件包所需工具的项目： `python3-devel` 和您软件包所需的相关项目，如 `python3-setuptools` 或在 **%check** 部分中运行测试所需的运行时和测试依赖关系。 				

- [*3*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-3) 

  ​						当为二进制 RPM 选择名称时（用户可以安装的软件包）时，添加版本化的 Python 前缀，即当前 `python3-`。因此，生成的二进制 RPM 将命名为 `python3-pello`。 				

- [*4*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-4) 

  ​						**%py3_build** 和 **%py3_install** macros 宏分别运行 `setup.py build` 和 `setup.py install` 命令，使用附加参数来指定安装位置、要使用的解释器以及其他详情。 				

- [*5*](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#CO1-5) 

  ​						**%check** 部分应该运行打包项目的测试。确切的命令取决于项目本身，但可以使用 **%pytest** 宏以 RPM 友好的方式运行 `pytest` 命令。**%{python3}** 宏包含 Python 3 解释器的路径，即 `/usr/bin/python3`。我们建议使用宏，而不是字面上的路径。 				

## 3.2. Python 3 RPM 的常见宏

​				在 SPEC 文件中，始终使用以下 Macros *用于 Python 3 RPM* 表而不是硬编码其值的宏。 		

**表 3.1. Python 3 RPM 宏**

| Macro                | 常规定义                           | 描述                                                         |
| -------------------- | ---------------------------------- | ------------------------------------------------------------ |
| %{python3}           | /usr/bin/python3                   | Python 3 解释器                                              |
| %{python3_version}   | 3.9                                | Python 3 解释器的 major.minor 版本                           |
| %{python3_sitelib}   | /usr/lib/python3.9/site-packages   | 安装纯 Python 模块的位置                                     |
| %{python3_sitearch}  | /usr/lib64/python3.9/site-packages | 安装包含特定于架构扩展模块的模块的位置                       |
| %py3_build           |                                    | 使用适用于 RPM 软件包的参数运行 `setup.py build` 命令        |
| %py3_install         |                                    | 使用适用于 RPM 软件包的参数运行 `setup.py install` 命令      |
| %{py3_shebang_flags} | s                                  | Python 解释器指令宏的默认标记集，`%py3_shebang_fix`          |
| %py3_shebang_fix     |                                    | 将 Python 解释器指令改为 `#! %{python3}`，保留任何现有标志（如果找到），并添加在 `%{py3_shebang_flags}` 宏中定义的标记 |

**其他资源**

- ​						[上游文档中的 Python 宏](https://docs.fedoraproject.org/en-US/packaging-guidelines/Python_201x/#_macros) 				

## 3.3. 为 Python RPM 使用自动生成的依赖项

​				以下流程描述了如何在将 Python 项目打包为 RPM 时使用自动生成的依赖项。 		

**先决条件**

- ​						RPM 的 SPEC 文件存在。如需更多信息，请参阅 [Python 软件包的 SPEC 文件描述](https://access.redhat.com/documentation/zh-cn/red_hat_enterprise_linux/9/html-single/installing_and_using_dynamic_programming_languages/index#con_spec-file-description-for-a-python-package_assembly_packaging-python-3-rpms)。 				

**步骤**

1. ​						确保以下包含上游提供元数据的目录之一包含在生成的 RPM 中： 				

   - ​								`.dist-info` 						

   - ​								`.egg-info` 						

     ​								RPM 构建过程会自动从这些目录中生成虚拟 `pythonX.Ydist`，例如： 						

     ```none
     python3.9dist(pello)
     ```

     ​								然后，Python 依赖项生成器读取上游元数据，并使用生成的 `pythonX.Ydist` 虚拟提供为每个 RPM 软件包生成运行时要求。例如，生成的要求标签可能如下所示： 						

     ```none
     Requires: python3.9dist(requests)
     ```

2. ​						检查生成的要求。 				

3. ​						要删除其中的一些生成的需要，请使用以下方法之一： 				

   1. ​								在 SPEC 文件的 `%prep` 部分中修改上游提供的元数据。 						
   2. ​								使用 [上游文档](https://fedoraproject.org/w/index.php?title=Packaging:AutoProvidesAndRequiresFiltering&oldid=530706) 中描述的依赖项自动过滤。 						

4. ​						要禁用自动依赖项生成器，请在主软件包的 `%description` 声明中包含 `%{?python_disable_dependency_generator}` 宏。 				

**其他资源**

- ​						[自动生成的依赖项](https://docs.fedoraproject.org/en-US/packaging-guidelines/Python_201x/#_automatically_generated_dependencies) 				

# 第 4 章 在 Python 脚本中处理解释器指令

​			在 Red Hat Enterprise Linux 9 中，可执行 Python 脚本应该使用解析程序指令（也称为 hashbangs 或 shebangs），至少指定主要 Python 版本。例如： 	

```none
#!/usr/bin/python3
#!/usr/bin/python3.9
```

​			在构建任何 RPM 软件包时，`/usr/lib/rpm/redhat/brp-mangle-shebangs` buildroot 策略(BRP)脚本会自动运行，并尝试在所有可执行文件中更正解释器指令。 	

​			当遇到带有模糊的解释解释器指令的 Python 脚本时，BRP 脚本会生成错误，例如： 	

```none
#!/usr/bin/python
```

​			或者 	

```none
#!/usr/bin/env python
```

## 4.1. 修改 Python 脚本中的解释器指令

​				使用以下步骤修改 Python 脚本中的解释器指令，以便在 RPM 构建时出现错误。 		

**先决条件**

- ​						Python 脚本中的一些解释器指令会导致构建错误。 				

**步骤**

- ​						要修改解释器指令，请完成以下任务之一： 				

  - ​								在您的 SPEC 文件的 `%prep` 部分中使用以下宏： 						

    ```none
    # %py3_shebang_fix SCRIPTNAME …
    ```

    ​								*SCRIPTNAME* 可以是任何文件、目录或文件和目录列表。 						

    ​								因此，列出的所有文件以及列出目录中所有 `.py` 文件都会修改其解释器指令以指向 `%{python3}`。将保留原始解释器指令的现有标记，并将添加 `%{py3_shebang_flags}` 宏中定义的其他标志。您可以在 SPEC 文件中重新定义 `%{py3_shebang_flags}` 宏，以更改将要添加的标志。 						

  - ​								从 `python3-devel` 软件包应用 `pathfix.py` 脚本： 						

    ```none
    # pathfix.py -pn -i %{python3} PATH …
    ```

    ​								您可以指定多个路径。如果 `*PATH*` 是一个目录，则 `pathfix.py` 会递归扫描与模式 `^[a-zA-Z0-9_]+\.py$` 匹配的 Python 脚本，而不仅仅是具有模糊的解释器指令。将上述命令添加到 `%prep` 部分，或者在 `%install` 部分的末尾。 						

  - ​								修改打包的 Python 脚本，以便它们符合预期格式。为此，您也可以使用 RPM 构建进程之外的 `pathfix.py` 脚本。在 RPM 构建之外运行 `pathfix.py` 时，将上面的示例中的 `%{python3}` 替换为解释器指令的路径，如 `/usr/bin/python3`。 						

**其它资源**

- ​						[解释器调用](https://docs.fedoraproject.org/en-US/packaging-guidelines/Python/#_interpreter_invocation) 				



    在 Windows 下可以不写第一行注释:
    
    #!/usr/bin/python3
    
    第一行注释标的是指向 python 的路径，告诉操作系统执行这个脚本的时候，调用 /usr/bin 下的 python 解释器。
    
    此外还有以下形式（推荐写法）：
    
    #!/usr/bin/env python3
    
    这种用法先在 env（环境变量）设置里查找 python 的安装路径，再调用对应路径下的解释器程序完成操作。


​    
​    help() 函数
​    
​    调用 python 的 help() 函数可以打印输出一个函数的文档字符串：
​    
​    # 如下实例，查看 max 内置函数的参数列表和规范的文档
​    >>> help(max)
​    ……显示帮助信息……
​    
​    按下 : q 两个按键即退出说明文档
​    
​    如果仅仅想得到文档字符串：
​    
​    >>> print(max.__doc__)    # 注意，doc的前后分别是两个下划线
​    max(iterable, *[, default=obj, key=func]) -> value
​    max(arg1, arg2, *args, *[, key=func]) -> value
​    
​    With a single iterable argument, return its biggest item. The
​    default keyword-only argument specifies an object to return if
​    the provided iterable is empty.
​    With two or more arguments, return the largest argument

## Python 环境变量

程序和可执行文件可以在许多目录，而这些路径很可能不在操作系统提供可执行文件的搜索路径中。

path(路径)存储在环境变量中，这是由操作系统维护的一个命名的字符串。这些变量包含可用的命令行解释器和其他程序的信息。

Unix 或 Windows 中路径变量为 PATH（UNIX 区分大小写，Windows 不区分大小写）。

在 Mac OS 中，安装程序过程中改变了 Python 的安装路径。如果你需要在其他目录引用 Python，你必须在 path 中添加 Python 目录。

### 在 Unix/Linux 设置环境变量

- 在 csh shell:

   输入 

  ```
  setenv PATH "$PATH:/usr/local/bin/python"
  ```

   , 按下 

  Enter

  。

- 在 bash shell (Linux) 输入 :

  ```
  export PATH="$PATH:/usr/local/bin/python" 
  ```

  按下 

  Enter

   。

- 在 sh 或者 ksh shell 输入:

  ```
  PATH="$PATH:/usr/local/bin/python" 
  ```

   按下 Enter。

**注意:** /usr/local/bin/python 是 Python 的安装目录。

### 在 Windows 设置环境变量

在环境变量中添加Python目录：

**在命令提示框中(cmd) :** 输入 

```
path=%path%;C:\Python 
```

 按下"Enter"。



**注意:** C:\Python 是Python的安装目录。

也可以通过以下方式设置：

- 右键点击"计算机"，然后点击"属性"
- 然后点击"高级系统设置"
- 选择"系统变量"窗口下面的"Path",双击即可！
- 
- 然后在"Path"行，添加python安装路径即可(我的D:\Python32)，所以在后面，添加该路径即可。 **ps：记住，路径直接用分号"；"隔开！**
- 最后设置成功以后，在cmd命令行，输入命令"python"，就可以有相关显示。

![img](https://www.runoob.com/wp-content/uploads/2013/11/201209201707594792.png)

下面几个重要的环境变量，它应用于Python：

| 变量名        | 描述                                                         |
| ------------- | ------------------------------------------------------------ |
| PYTHONPATH    | PYTHONPATH是Python搜索路径，默认我们import的模块都会从PYTHONPATH里面寻找。 |
| PYTHONSTARTUP | Python启动后，先寻找PYTHONSTARTUP环境变量，然后执行此变量指定的文件中的代码。 |
| PYTHONCASEOK  | 加入PYTHONCASEOK的环境变量, 就会使python导入模块的时候不区分大小写. |
| PYTHONHOME    | 另一种模块搜索路径。它通常内嵌于的PYTHONSTARTUP或PYTHONPATH目录中，使得两个模块库更容易切换。 |

## 运行Python

1、交互式解释器：

通过命令行窗口进入python并开在交互式解释器中开始编写Python代码。

Python命令行参数：

```bash
选项	           描述
-d	            在解析时显示调试信息
-O	            生成优化代码 ( .pyo 文件 )
-S	            启动时不引入查找Python路径的位置
-V,--version	输出Python版本号
-X	            从 1.6版本之后基于内建的异常（仅仅用于字符串）已过时。
-c cmd	        执行 Python 脚本，并将运行结果作为 cmd 字符串。
file	        在给定的python文件执行python脚本。
```

2、命令行脚本

```bash
python  script.py          # Unix/Linux
```

## Python 字符编码

默认情况下，Python 3 源码文件以 UTF-8 编码，所有字符串都是 unicode 字符串。 

如果不使用默认编码，则要声明文件的编码，文件的第一 行要写成特殊注释。句法如下：

```python
# -*- coding: encoding -*-
```

其中，*encoding* 可以是 Python 支持的任意一种 [`codecs`](https://docs.python.org/zh-cn/3.10/library/codecs.html#module-codecs)。

比如，声明使用 Windows-1252 编码，源码文件要写成：

```python
# -*- coding: cp1252 -*-
```

第一行的规则也有一种例外情况，源码以 [UNIX "shebang" 行](https://docs.python.org/zh-cn/3.10/tutorial/appendix.html#tut-scripts) 开头。此时，编码声明要写在文件的第二行。例如：

```python
#!/usr/bin/env python3
# -*- coding: cp1252 -*-
```
## Python 标识符

标识符由字母、数字、下划线组成，不能以数字开头，区分大小写，不能包含空格。在Python 3中，非-ASCII 标识符也是允许的。慎用小写字母 l 和大写字母 O。

以下划线开头的标识符是有特殊意义的。以单下划线开头（`_foo`）的代表不能直接访问的类属性，需通过类提供的接口进行访问，不能用 `from xxx import *` 而导入。 

以双下划线开头的（`__foo`）代表类的私有成员；以双下划线开头和结尾的（`__foo__`）代表python里特殊方法专用的标识，如  `__init__（）` 代表类的构造函数。

### 保留字符

Python 的标准库提供了一个 keyword 模块，可以输出当前版本的所有关键字：

```python
>>> import keyword
>>> keyword.kwlist
```

|     1    |    2    |    3   |
|----------|---------|--------|
| and      | False	| not    |
| as | finally	| or |
| assert   | for | pass |
| break    | from | print |
| class	   | global | raise |
| continue | if | return |
| def      | import	| True |
| del | in	| try |
| elif  | is | while |
| else | lambda	| with |
| except	| None	| yield |
| exec | nonlocal |        |

## 行和缩进

在每个缩进层次使用 **单个制表符** 或 **两个空格** 或 **四个空格**，不能混用。

### 多行语句

```python
total = item_one + \
        item_two + \
        item_three
```

语句中包含[], {} 或 () 括号就不需要使用多行连接符。如下实例：

```python
days = ['Monday', 'Tuesday', 'Wednesday',
        'Thursday', 'Friday']
```

### 空行

函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。

空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构。

### 同一行显示多条语句
Python可以在同一行中使用多条语句，语句之间使用分号(;)分割：

```python
#!/usr/bin/python3
import sys; x = 'runoob'; sys.stdout.write(x + '\n')
```

### 代码组

缩进相同的一组语句构成一个代码块，称之代码组。

像 if、while、def 和 class这 样的复合语句，首行以关键字开始，以冒号( : )结束，该行之后的一行或多行代码构成代码组。

将首行及后面的代码组称为一个子句 (clause)。

如下实例：

```python
if expression :
   suite
elif expression :
   suite
else :
   suite
```

## Python 引号

Python 接收单引号(' )，双引号(" )，三引号(''' """) 来表示字符串，引号的开始与结束必须的相同类型的。 
三引号可以由多行组成，编写多行文本的快捷语法，常用语文档字符串，在文件的特定地点，被当做注释。

eg:
word = '字符串'
sentence = "这是一个句子。"
paragraph = """这是一个段落，
可以由多行组成"""

## 注释

单行注释采用 `#` 开头。 
多行注释使用三个单引号( `''' `) 或三个双引号 (` """` )。

```python
#!/usr/bin/python3
 
# 第一个注释
# 第二个注释
 
'''
第三注释
第四注释
'''
 
"""
第五注释
第六注释
"""
print ("Hello, Python!")
```


## 输入和输出
### 输入

优先使用 `raw_input`

```python
raw_input("\n\nPress the enter key to exit.")
input("\n\nPress the enter key to exit.")

# 以上代码中 ，"\n\n"在结果输出前会输出两个新的空行。
# 一旦用户按下键时，程序将退出。
```

### 输出

使用 print() 函数。

```python
print("x")
```

print 默认输出是换行的，如果要实现不换行需要在变量末尾加上 `end=""`。

```python
# 换行输出
print( x )

# 不换行输出
print( x, end=" " )
```

## 命令行参数

使用-h参数查看各参数帮助信息：

```bash
$ python -h
usage: python [option] ... [-c cmd | -m mod | file | -] [arg] ...
Options and arguments (and corresponding environment variables):
-c cmd : program passed in as string (terminates option list)
-d     : debug output from parser (also PYTHONDEBUG=x)
-E     : ignore environment variables (such as PYTHONPATH)
-h     : print this help message and exit
```

## 常量

值不可改变。通常用全部大写的名表示常量。

两个比较常见的常量：

* PI

  数学常量 pi，圆周率，一般用 π 表示。

* E

  数学常量 e ，即自然对数。

## 变量

Python 中的变量不需要声明。每个变量在使用前都必须赋值，变量赋值以后该变量才会被创建。

在 Python 中，变量就是变量，它没有类型，所说的"类型"是变量所指的内存中对象的类型。

变量名是由数字或字符组成的任意长度的字符串，必须以字母开头。区分大小写。可以使用下划线 `_` 。不可用关键字作为变量名。

等号（=）用来给变量赋值。

### 多个变量赋值

Python允许同时为多个变量赋值。例如：

```python
a = b = c = 1
```

以上实例，创建一个整型对象，值为 1，从后向前赋值，三个变量被赋予相同的数值。

您也可以为多个对象指定多个变量。例如：

```python
a, b, c = 1, 2, "roob"
```

以上实例，两个整型对象 1 和 2 的分配给变量 a 和 b，字符串对象 "roob" 分配给变量 c。

### 删除变量

可以使用del语句删除一些对象的引用。

```python
del var1[,var2[,var3[....,varN]]]
```

## 运算符

### 算术运算符

```python
+		加
-		减
*		乘
/		除（结果是浮点数）
//		整除（返回商的整数部分）
%       取模（返回除法的余数）
**		幂
```

### 比较运算符

返回 True 和 False 两个值。

```python
==      等于
!=      不等于
>       大于
<       小于
>=      大于等于
<=      小于等于
```

Pyhton3 已不支持 <>  运算符，可以使用 != 代替，如果一定要使用这种比较运算符，可以使用以下的方式：

```python
>>> from __future__ import barry_as_FLUFL
>>> 1 <> 2
True
```

### 赋值运算符

```python
=	 	简单的赋值
+= 		加法赋值
-= 		减法赋值
*= 		乘法赋值
/= 		除法赋值
%= 		取模赋值
**= 	幂赋值
//= 	取整除赋值
:=	    海象运算符，可在表达式内部为变量赋值。
        Python3.8 版本新增运算符。	
```

```python
# 在这个示例中，赋值表达式可以避免调用 len() 两次:

if (n := len(a)) > 10:
    print(f"List is too long ({n} elements, expected <= 10)")
```

### 位运算符

```python
& 	按位与运算符：参与运算的两个值,如果两个相应位都为1,则该位的结果为1,否则为0。
| 	按位或运算符：只要对应的二个二进位有一个为1时，结果位就为1。
^ 	按位异或运算符：当两对应的二进位相异时，结果为1。
~ 	按位取反运算符：对数据的每个二进制位取反,即把1变为0,把0变为1。
<< 	左移动运算符：运算数的各二进位全部左移若干位，高位丢弃，低位补0。
>> 	右移动运算符：把">>"左边的运算数的各二进位全部右移若干位。
```
### 逻辑运算符

```python
and 	布尔"与" - 如果 x 为 False，x and y 返回 False，否则它返回 y 的计算值。
or 	 	布尔"或" - 如果 x 是 True，x or y 它返回 x 的值，否则它返回 y 的计算值。
not 	布尔"非" - 如果 x 为 True，not x 返回 False 。如果 x 为 False，它返回 True。
```

### 成员运算符

```python
in 	    如果在指定的序列中找到值返回 True，否则返回 False。
not in 	如果在指定的序列中没有找到值返回 True，否则返回 False。
```

### 身份运算符

```python
is      判断两个标识符是不是引用自一个对象
is not  判断两个标识符是不是引用自不同对象                 
```

### 优先级

以下表格列出了从最高到最低优先级的所有运算符：

| 运算符                   | 描述                                                   |
| ------------------------ | ------------------------------------------------------ |
| **                       | 指数 (最高优先级)                                      |
| ~ + -                    | 按位翻转, 一元加号和减号 (最后两个的方法名为 +@ 和 -@) |
| * / % //                 | 乘，除，取模和取整除                                   |
| + -                      | 加法减法                                               |
| >> <<                    | 右移，左移运算符                                       |
| &                        | 位 'AND'                                               |
| ^ \|                     | 位运算符                                               |
| <= < > >=                | 比较运算符                                             |
| <> == !=                 | 等于运算符                                             |
| = %= /= //= -= += *= **= | 赋值运算符                                             |
| is  is not               | 身份运算符                                             |
| in  not in               | 成员运算符                                             |
| not or and               | 逻辑运算符                                             |

## 条件控制

### if 语句

```python
if condition_1:
    statement_block_1
elif condition_2:
    statement_block_2
else:
    statement_block_3
```

Python中用elif代替了else if，所以if语句的关键字为：if – elif – else。 

 **注意：**

-  1、每个条件后面要使用冒号（:），表示接下来是满足条件后要执行的语句块。
-  2、使用缩进来划分语句块，相同缩进数的语句在一起组成一个语句块。
-  3、在Python中没有switch – case语句。

Python 条件语句是通过一条或多条语句的执行结果（True 或者 False）来决定执行的代码块。

可以通过下图来简单了解条件语句的执行过程:

 ![img](https://www.runoob.com/wp-content/uploads/2013/11/if-condition.jpg) 

代码执行过程：

![img](https://static.runoob.com/images/mix/python-if.webp)

------

## if 语句

Python中if语句的一般形式如下所示：

if condition_1:    statement_block_1 elif condition_2:    statement_block_2 else:    statement_block_3

- 如果 "condition_1" 为 True 将执行 "statement_block_1" 块语句
- 如果 "condition_1" 为False，将判断 "condition_2"
- 如果"condition_2" 为 True 将执行 "statement_block_2" 块语句
- 如果 "condition_2" 为False，将执行"statement_block_3"块语句

Python 中用 **elif** 代替了 **else if**，所以if语句的关键字为：**if – elif – else**。

**注意：**

- 1、每个条件后面要使用冒号 :，表示接下来是满足条件后要执行的语句块。
- 2、使用缩进来划分语句块，相同缩进数的语句在一起组成一个语句块。
- 3、在Python中没有switch – case语句。

Gif 演示：

![img](https://www.runoob.com/wp-content/uploads/2014/05/006faQNTgw1f5wnm0mcxrg30ci07o47l.gif)

### 实例

以下是一个简单的 if 实例：

## 实例

\#!/usr/bin/python3  var1 = 100 if var1:    print ("1 - if 表达式条件为 true")    print (var1)  var2 = 0 if var2:    print ("2 - if 表达式条件为 true")    print (var2) print ("Good bye!")

执行以上代码，输出结果为：

```
1 - if 表达式条件为 true
100
Good bye!
```

从结果可以看到由于变量 var2 为 0，所以对应的 if 内的语句没有执行。

以下实例演示了狗的年龄计算判断：

## 实例

\#!/usr/bin/python3  age = int(input("请输入你家狗狗的年龄: ")) print("") if age <= 0:    print("你是在逗我吧!") elif age == 1:    print("相当于 14 岁的人。") elif age == 2:    print("相当于 22 岁的人。") elif age > 2:    human = 22 + (age -2)*5    print("对应人类年龄: ", human)  ### 退出提示 input("点击 enter 键退出")

将以上脚本保存在dog.py文件中，并执行该脚本：

```
$ python3 dog.py 
请输入你家狗狗的年龄: 1

相当于 14 岁的人。
点击 enter 键退出
```

以下为if中常用的操作运算符:

| 操作符 | 描述                     |
| ------ | ------------------------ |
| `<`    | 小于                     |
| `<=`   | 小于或等于               |
| `>`    | 大于                     |
| `>=`   | 大于或等于               |
| `==`   | 等于，比较两个值是否相等 |
| `!=`   | 不等于                   |

## 实例

\#!/usr/bin/python3  # 程序演示了 == 操作符 # 使用数字 print(5 == 6) # 使用变量 x = 5 y = 8 print(x == y)

以上实例输出结果：

```
False
False
```

high_low.py文件演示了数字的比较运算：

## 实例

\#!/usr/bin/python3   # 该实例演示了数字猜谜游戏 number = 7 guess = -1 print("数字猜谜游戏!") while guess != number:    guess = int(input("请输入你猜的数字："))     if guess == number:        print("恭喜，你猜对了！")    elif guess < number:        print("猜的数字小了...")    elif guess > number:        print("猜的数字大了...")

执行以上脚本，实例输出结果如下：

```
$ python3 high_low.py 
数字猜谜游戏!
请输入你猜的数字：1
猜的数字小了...
请输入你猜的数字：9
猜的数字大了...
请输入你猜的数字：7
恭喜，你猜对了！
```

------

## if 嵌套

在嵌套 if 语句中，可以把 if...elif...else 结构放在另外一个 if...elif...else 结构中。

```
if 表达式1:
    语句
    if 表达式2:
        语句
    elif 表达式3:
        语句
    else:
        语句
elif 表达式4:
    语句
else:
    语句
```

## 实例

\# !/usr/bin/python3  num=int(input("输入一个数字：")) if num%2==0:    if num%3==0:        print ("你输入的数字可以整除 2 和 3")    else:        print ("你输入的数字可以整除 2，但不能整除 3") else:    if num%3==0:        print ("你输入的数字可以整除 3，但不能整除 2")    else:        print  ("你输入的数字不能整除 2 和 3")

将以上程序保存到 test_if.py  文件中，执行后输出结果为：

```
$ python3 test.py 
输入一个数字：6
你输入的数字可以整除 2 和 3
```

## 循环

Python 中的循环语句有 for 和 while。

Python 循环语句的控制结构图如下所示：

![img](https://www.runoob.com/wp-content/uploads/2015/12/loop.png)

------

## while 循环

Python 中 while 语句的一般形式：

```
while 判断条件(condition)：
    执行语句(statements)……
```

执行流程图如下：

![img](https://www.runoob.com/wp-content/uploads/2013/11/886A6E10-58F1-4A9B-8640-02DBEFF0EF9A.jpg)

执行 Gif 演示：

![img](https://www.runoob.com/wp-content/uploads/2014/05/006faQNTgw1f5wnm06h3ug30ci08cake.gif)

同样需要注意冒号和缩进。另外，在 Python 中没有 do..while 循环。

以下实例使用了 while 来计算 1 到 100 的总和：

## 实例

\#!/usr/bin/env python3  n = 100  sum = 0 counter = 1 while counter <= n:    sum = sum + counter    counter += 1  print("1 到 %d 之和为: %d" % (n,sum))

执行结果如下：

```
1 到 100 之和为: 5050
```

### 无限循环

我们可以通过设置条件表达式永远不为 false 来实现无限循环，实例如下：

## 实例

\#!/usr/bin/python3  var = 1 while var == 1 :  # 表达式永远为 true   num = int(input("输入一个数字  :"))   print ("你输入的数字是: ", num)  print ("Good bye!")

执行以上脚本，输出结果如下：

```
输入一个数字  :5
你输入的数字是:  5
输入一个数字  :
```

你可以使用  **CTRL+C** 来退出当前的无限循环。

无限循环在服务器上客户端的实时请求非常有用。

### while 循环使用 else 语句

如果 while 后面的条件语句为 false 时，则执行 else 的语句块。

语法格式如下：

```
while <expr>:
    <statement(s)>
else:
    <additional_statement(s)>
```

expr 条件语句为 true 则执行 statement(s) 语句块，如果为 false，则执行 additional_statement(s)。

循环输出数字，并判断大小：

## 实例

\#!/usr/bin/python3  count = 0 while count < 5:   print (count, " 小于 5")   count = count + 1 else:   print (count, " 大于或等于 5")

执行以上脚本，输出结果如下：

```
0  小于 5
1  小于 5
2  小于 5
3  小于 5
4  小于 5
5  大于或等于 5
```

### 简单语句组

类似if语句的语法，如果你的while循环体中只有一条语句，你可以将该语句与while写在同一行中， 如下所示：

## 实例

\#!/usr/bin/python  flag = 1  while (flag): print ('欢迎访问菜鸟教程!')  print ("Good bye!")

**注意：**以上的无限循环你可以使用 CTRL+C 来中断循环。

执行以上脚本，输出结果如下：

```
欢迎访问菜鸟教程!
欢迎访问菜鸟教程!
欢迎访问菜鸟教程!
欢迎访问菜鸟教程!
欢迎访问菜鸟教程!
……
```

------

## for 语句

Python for 循环可以遍历任何可迭代对象，如一个列表或者一个字符串。

for循环的一般格式如下：

for <variable> in <sequence>:    <statements> else:    <statements>

**流程图：**

![img](https://www.runoob.com/wp-content/uploads/2013/11/A71EC47E-BC53-4923-8F88-B027937EE2FF.jpg)

Python for 循环实例：

## 实例

\>>>languages = ["C", "C++", "Perl", "Python"]  >>> for x in languages: ...     print (x) ...  C C++ Perl Python >>>

以下 for 实例中使用了 break 语句，break 语句用于跳出当前循环体：

## 实例

\#!/usr/bin/python3  sites = ["Baidu", "Google","Runoob","Taobao"] for site in sites:    if site == "Runoob":        print("菜鸟教程!")        break    print("循环数据 " + site) else:    print("没有循环数据!") print("完成循环!")

执行脚本后，在循环到 "Runoob"时会跳出循环体：

```
循环数据 Baidu
循环数据 Google
菜鸟教程!
完成循环!
```

------

## range()函数

如果你需要遍历数字序列，可以使用内置range()函数。它会生成数列，例如:

## 实例

\>>>for i in range(5): ...     print(i) ... 0 1 2 3 4

你也可以使用range指定区间的值：

## 实例

\>>>for i in range(5,9) :    print(i)      5 6 7 8 >>>

也可以使range以指定数字开始并指定不同的增量(甚至可以是负数，有时这也叫做'步长'): 

## 实例

\>>>for i in range(0, 10, 3) :    print(i)      0 3 6 9 >>>

负数：

## 实例

\>>>for i in range(-10, -100, -30) :    print(i)      -10 -40 -70 >>>

您可以结合range()和len()函数以遍历一个序列的索引,如下所示:

## 实例

\>>>a = ['Google', 'Baidu', 'Runoob', 'Taobao', 'QQ'] >>> for i in range(len(a)): ...     print(i, a[i]) ...  0 Google 1 Baidu 2 Runoob 3 Taobao 4 QQ >>>

还可以使用range()函数来创建一个列表：

## 实例

\>>>list(range(5)) [0, 1, 2, 3, 4] >>>

------

## break 和 continue 语句及循环中的 else 子句

**break 执行流程图：**

![img](https://www.runoob.com/wp-content/uploads/2014/09/E5A591EF-6515-4BCB-AEAA-A97ABEFC5D7D.jpg)

**continue 执行流程图：**

![img](https://www.runoob.com/wp-content/uploads/2014/09/8962A4F1-B78C-4877-B328-903366EA1470.jpg)

while 语句代码执行过程：

![img](https://static.runoob.com/images/mix/python-while.webp)

for 语句代码执行过程：

![img](https://www.runoob.com/wp-content/uploads/2014/05/break-continue-536.png)

**break** 语句可以跳出 for 和 while 的循环体。如果你从 for 或 while 循环中终止，任何对应的循环 else 块将不执行。

**continue** 语句被用来告诉 Python 跳过当前循环块中的剩余语句，然后继续进行下一轮循环。

### 实例

while 中使用 break：

## 实例

n = 5
 **while** n > 0:
   n -= 1
   **if** n == 2:
     **break**
   **print**(n)
 **print**('循环结束。')

输出结果为：

```
4
3
循环结束。
```

while 中使用 continue：

## 实例

n = 5
 **while** n > 0:
   n -= 1
   **if** n == 2:
     **continue**
   **print**(n)
 **print**('循环结束。')

输出结果为：

```
4
3
1
0
循环结束。
```

更多实例如下：

## 实例

\#!/usr/bin/python3  for letter in 'Runoob':     # 第一个实例   if letter == 'b':      break   print ('当前字母为 :', letter)   var = 10                    # 第二个实例 while var > 0:                 print ('当前变量值为 :', var)   var = var -1   if var == 5:      break  print ("Good bye!")

执行以上脚本输出结果为：

```
当前字母为 : R
当前字母为 : u
当前字母为 : n
当前字母为 : o
当前字母为 : o
当前变量值为 : 10
当前变量值为 : 9
当前变量值为 : 8
当前变量值为 : 7
当前变量值为 : 6
Good bye!
```

以下实例循环字符串 Runoob，碰到字母 o 跳过输出：

## 实例

\#!/usr/bin/python3  for letter in 'Runoob':     # 第一个实例   if letter == 'o':        # 字母为 o 时跳过输出      continue   print ('当前字母 :', letter)  var = 10                    # 第二个实例 while var > 0:                 var = var -1   if var == 5:             # 变量为 5 时跳过输出      continue   print ('当前变量值 :', var) print ("Good bye!")

执行以上脚本输出结果为：

```
当前字母 : R
当前字母 : u
当前字母 : n
当前字母 : b
当前变量值 : 9
当前变量值 : 8
当前变量值 : 7
当前变量值 : 6
当前变量值 : 4
当前变量值 : 3
当前变量值 : 2
当前变量值 : 1
当前变量值 : 0
Good bye!
```

循环语句可以有 else 子句，它在穷尽列表(以for循环)或条件变为 false (以while循环)导致循环终止时被执行，但循环被 break 终止时不执行。

如下实例用于查询质数的循环例子:

## 实例

\#!/usr/bin/python3  for n in range(2, 10):    for x in range(2, n):        if n % x == 0:            print(n, '等于', x, '*', n//x)            break    else:        # 循环中没有找到元素        print(n, ' 是质数')

执行以上脚本输出结果为：

```
2  是质数
3  是质数
4 等于 2 * 2
5  是质数
6 等于 2 * 3
7  是质数
8 等于 2 * 4
9 等于 3 * 3
```

------

## pass 语句

Python pass是空语句，是为了保持程序结构的完整性。

pass 不做任何事情，一般用做占位语句，如下实例

## 实例

\>>>while True: ...     pass  # 等待键盘中断 (Ctrl+C)

最小的类:

## 实例

\>>>class MyEmptyClass: ...     pass

以下实例在字母为 o 时 执行 pass 语句块:

## 实例

\#!/usr/bin/python3  for letter in 'Runoob':    if letter == 'o':      pass      print ('执行 pass 块')   print ('当前字母 :', letter)  print ("Good bye!")

执行以上脚本输出结果为：

```
当前字母 : R
当前字母 : u
当前字母 : n
执行 pass 块
当前字母 : o
执行 pass 块
当前字母 : o
当前字母 : b
Good bye!
```

------

### while 循环 

```python
while 判断条件：
    statements
```

需要注意冒号和缩进。另外，在Python中没有do..while循环。 

### for语句

```python
for <variable> in <sequence>:
  <statements>
else:
 <statements>
```

#### range()函数

```python
>>> for i in range(5):
...     print(i)
...
0
1
2
3
4
```

使用range指定区间的值：

```python
>>> for i in range(5,9) :
  print(i)
    
5
6
7
8
```

指定数字开始并指定不同的增量(甚至可以是负数): 

```python
>>> for i in range(0, 10, 3) :
    print(i)
   
0
3
6
9
```

负数：

```python
>>> for i in range(-10, -100, -30) :
   print(i)
  
-10
-40
-70
```

您可以结合range()和len()函数以遍历一个序列的索引,如下所示:

```python
>>> a = ['Mary', 'had', 'a', 'little', 'lamb']
>>> for i in range(len(a)):
...     print(i, a[i])
...
0 Mary
1 had
2 a
3 little
4 lamb
```

还可以使用range()函数来创建一个列表：

```python
>>> list(range(5))
[0, 1, 2, 3, 4]
>>>
```

#### break和continue语句及循环中的else子句 

break语句可以跳出for和while的循环体。如果你从for或while循环中终止，任何对应的循环else块将不执行。 

continue语句被用来告诉Python跳过当前循环块中的剩余语句，然后继续进行下一轮循环。 

循环语句可以有else子句;它在穷尽列表(以for循环)或条件变为假(以while循环)循环终止时被执行,但循环被break终止时不执行。

#### pass语句

pass语句什么都不做。它只在语法上需要一条语句但程序不需要任何操作时使用.例如: 

```python
>>> while True:
...     pass  # 等待键盘中断 (Ctrl+C)
```

最小的类:

```python
>>> class MyEmptyClass:
...     pass
```

## 迭代器与生成器

## 迭代器

迭代是Python最强大的功能之一，是访问集合元素的一种方式。

迭代器是一个可以记住遍历的位置的对象。

迭代器对象从集合的第一个元素开始访问，直到所有的元素被访问完结束。迭代器只能往前不会后退。

迭代器有两个基本的方法：**iter()** 和 **next()**。

字符串，列表或元组对象都可用于创建迭代器：

## 实例(Python 3.0+)

\>>> list=[1,2,3,4]
 \>>> it = iter(list)   # 创建迭代器对象
 \>>> **print** (next(it))  # 输出迭代器的下一个元素
 1
 \>>> **print** (next(it))
 2
 \>>> 

迭代器对象可以使用常规for语句进行遍历：

## 实例(Python 3.0+)

\#!/usr/bin/python3  list=[1,2,3,4] it = iter(list)    # 创建迭代器对象 for x in it:    print (x, end=" ")

执行以上程序，输出结果如下：

```
1 2 3 4
```

也可以使用  next() 函数：

## 实例(Python 3.0+)

\#!/usr/bin/python3  import sys         # 引入 sys 模块  list=[1,2,3,4] it = iter(list)    # 创建迭代器对象  while True:    try:        print (next(it))    except StopIteration:        sys.exit()

执行以上程序，输出结果如下：

```
1
2
3
4
```

### 创建一个迭代器

把一个类作为一个迭代器使用需要在类中实现两个方法 __iter__() 与 __next__() 。

如果你已经了解的面向对象编程，就知道类都有一个构造函数，Python 的构造函数为 __init__(), 它会在对象初始化的时候执行。

更多内容查阅：[Python3 面向对象](https://www.runoob.com/python3/python3-class.html)

__iter__() 方法返回一个特殊的迭代器对象， 这个迭代器对象实现了 __next__() 方法并通过 StopIteration 异常标识迭代的完成。

__next__() 方法（Python 2 里是 next()）会返回下一个迭代器对象。

创建一个返回数字的迭代器，初始值为 1，逐步递增 1：

## 实例(Python 3.0+)

class MyNumbers:  def __iter__(self):    self.a = 1    return self   def __next__(self):    x = self.a    self.a += 1    return x  myclass = MyNumbers() myiter = iter(myclass)  print(next(myiter)) print(next(myiter)) print(next(myiter)) print(next(myiter)) print(next(myiter))

执行输出结果为：

```
1
2
3
4
5
```

### StopIteration

StopIteration 异常用于标识迭代的完成，防止出现无限循环的情况，在  __next__() 方法中我们可以设置在完成指定循环次数后触发 StopIteration 异常来结束迭代。

在 20 次迭代后停止执行：

## 实例(Python 3.0+)

class MyNumbers:  def __iter__(self):    self.a = 1    return self   def __next__(self):    if self.a <= 20:      x = self.a      self.a += 1      return x    else:      raise StopIteration  myclass = MyNumbers() myiter = iter(myclass)  for x in myiter:  print(x)

执行输出结果为：

```
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
```

------

## 生成器



在 Python 中，使用了 yield 的函数被称为生成器（generator）。

跟普通函数不同的是，生成器是一个返回迭代器的函数，只能用于迭代操作，更简单点理解生成器就是一个迭代器。 

在调用生成器运行的过程中，每次遇到 yield 时函数会暂停并保存当前所有的运行信息，返回 yield 的值, 并在下一次执行 next() 方法时从当前位置继续运行。

调用一个生成器函数，返回的是一个迭代器对象。

以下实例使用 yield 实现斐波那契数列：

## 实例(Python 3.0+)

\#!/usr/bin/python3  import sys  def fibonacci(n): # 生成器函数 - 斐波那契    a, b, counter = 0, 1, 0    while True:        if (counter > n):             return        yield a        a, b = b, a + b        counter += 1 f = fibonacci(10) # f 是一个迭代器，由生成器返回生成  while True:    try:        print (next(f), end=" ")    except StopIteration:        sys.exit()

执行以上程序，输出结果如下：

```
0 1 1 2 3 5 8 13 21 34 55
```

### 迭代器

访问集合元素的一种方式。是一个可以记住遍历的位置的对象。

迭代器对象从集合的第一个元素开始访问，直到所有的元素被访问完结束。迭代器只能往前不会后退。

 迭代器有两个基本的方法：**iter()** 和 **next()**。 

字符串，列表或元组对象都可用于创建迭代器：

```python
>>> list=[1,2,3,4]
>>> it = iter(list)    # 创建迭代器对象
>>> print (next(it))   # 输出迭代器的下一个元素
1
>>> print (next(it))
2
```

迭代器对象可以使用常规for语句进行遍历：

```python
#!/usr/bin/python3

list=[1,2,3,4]
it = iter(list)    # 创建迭代器对象
for x in it:
    print (x, end=" ")
```

也可以使用  next() 函数：

```python
#!/usr/bin/python3

import sys         # 引入 sys 模块

list=[1,2,3,4]
it = iter(list)    # 创建迭代器对象

while True:
    try:
        print (next(it))
    except StopIteration:
        sys.exit()
```

### 生成器

使用了 yield 的函数被称为生成器（generator）。

跟普通函数不同的是，生成器是一个返回迭代器的函数，只能用于迭代操作，更简单点理解生成器就是一个迭代器。 

在调用生成器运行的过程中，每次遇到 yield 时函数会暂停并保存当前所有的运行信息，返回yield的值。并在下一次执行 next()方法时从当前位置继续运行。

以下实例使用 yield 实现斐波那契数列：

```python
#!/usr/bin/python3

import sys

def fibonacci(n): # 生成器函数 - 斐波那契
    a, b, counter = 0, 1, 0
    while True:
        if (counter > n): 
            return
        yield a
        a, b = b, a + b
        counter += 1
f = fibonacci(10) # f 是一个迭代器，由生成器返回生成

while True:
    try:
        print (next(f), end=" ")
    except StopIteration:
        sys.exit()
```

## Python3 函数

函数是组织好的，可重复使用的，用来实现单一，或相关联功能的代码段。

函数能提高应用的模块性，和代码的重复利用率。你已经知道Python提供了许多内建函数，比如print()。但你也可以自己创建函数，这被叫做用户自定义函数。

------

## 定义一个函数

你可以定义一个由自己想要功能的函数，以下是简单的规则：

- 函数代码块以 **def** 关键词开头，后接函数标识符名称和圆括号 **()**。
- 任何传入参数和自变量必须放在圆括号中间，圆括号之间可以用于定义参数。
- 函数的第一行语句可以选择性地使用文档字符串—用于存放函数说明。
- 函数内容以冒号 : 起始，并且缩进。
- **return [表达式]** 结束函数，选择性地返回一个值给调用方，不带表达式的 return 相当于返回 None。

![img](https://www.runoob.com/wp-content/uploads/2014/05/py-tup-10-26-1.png)

------

### 语法

Python 定义函数使用 def 关键字，一般格式如下：

```
def 函数名（参数列表）:
    函数体
```

默认情况下，参数值和参数名称是按函数声明中定义的顺序匹配起来的。

### 实例

让我们使用函数来输出"Hello World！"：

\#!/usr/bin/python3

 **def** hello() :
   **print**("Hello World!")

 hello()

更复杂点的应用，函数中带上参数变量:

## 实例(Python 3.0+)

比较两个数，并返回较大的数:

\#!/usr/bin/python3  def max(a, b):    if a > b:        return a    else:        return b  a = 4 b = 5 print(max(a, b))

以上实例输出结果：

```
5
```

## 实例(Python 3.0+)

计算面积函数:

\#!/usr/bin/python3  # 计算面积函数 def area(width, height):    return width * height  def print_welcome(name):    print("Welcome", name)  print_welcome("Runoob") w = 4 h = 5 print("width =", w, " height =", h, " area =", area(w, h))

以上实例输出结果：

```
Welcome Runoob
width = 4  height = 5  area = 20
```

------

## 函数调用

定义一个函数：给了函数一个名称，指定了函数里包含的参数，和代码块结构。

这个函数的基本结构完成以后，你可以通过另一个函数调用执行，也可以直接从 Python 命令提示符执行。

如下实例调用了 **printme()** 函数：

## 实例(Python 3.0+)

\#!/usr/bin/python3  # 定义函数 def printme( str ):   # 打印任何传入的字符串   print (str)   return  # 调用函数 printme("我要调用用户自定义函数!") printme("再次调用同一函数")

以上实例输出结果：

```
我要调用用户自定义函数!
再次调用同一函数
```

------

## 参数传递

在 python 中，类型属于对象，对象有不同类型的区分，变量是没有类型的：

```
a=[1,2,3]

a="Runoob"
```

以上代码中，**[1,2,3]** 是 List 类型，**"Runoob"** 是 String 类型，而变量 a 是没有类型，她仅仅是一个对象的引用（一个指针），可以是指向 List 类型对象，也可以是指向 String 类型对象。

### 可更改(mutable)与不可更改(immutable)对象

在 python 中，strings, tuples, 和 numbers 是不可更改的对象，而 list,dict 等则是可以修改的对象。

- **不可变类型：**变量赋值 **a=5** 后再赋值 **a=10**，这里实际是新生成一个 int 值对象 10，再让 a 指向它，而 5 被丢弃，不是改变 a 的值，相当于新生成了 a。
- **可变类型：**变量赋值 **la=[1,2,3,4]** 后再赋值 **la[2]=5** 则是将 list la 的第三个元素值更改，本身la没有动，只是其内部的一部分值被修改了。

python 函数的参数传递：

- **不可变类型：**类似 C++ 的值传递，如整数、字符串、元组。如 fun(a)，传递的只是 a 的值，没有影响 a 对象本身。如果在 fun(a) 内部修改 a 的值，则是新生成一个 a 的对象。
- **可变类型：**类似 C++ 的引用传递，如 列表，字典。如 fun(la)，则是将 la 真正的传过去，修改后 fun 外部的 la 也会受影响

python 中一切都是对象，严格意义我们不能说值传递还是引用传递，我们应该说传不可变对象和传可变对象。

### python 传不可变对象实例

通过 **id()** 函数来查看内存地址变化：

## 实例(Python 3.0+)

def change(a):    print(id(a))   # 指向的是同一个对象    a=10    print(id(a))   # 一个新对象  a=1 print(id(a)) change(a)

以上实例输出结果为：

```
4379369136
4379369136
4379369424
```

可以看见在调用函数前后，形参和实参指向的是同一个对象（对象 id 相同），在函数内部修改形参后，形参指向的是不同的 id。

### 传可变对象实例

可变对象在函数里修改了参数，那么在调用这个函数的函数里，原始的参数也被改变了。例如：

## 实例(Python 3.0+)

\#!/usr/bin/python3  # 可写函数说明 def changeme( mylist ):   "修改传入的列表"   mylist.append([1,2,3,4])   print ("函数内取值: ", mylist)   return  # 调用changeme函数 mylist = [10,20,30] changeme( mylist ) print ("函数外取值: ", mylist)

传入函数的和在末尾添加新内容的对象用的是同一个引用。故输出结果如下：

```
函数内取值:  [10, 20, 30, [1, 2, 3, 4]]
函数外取值:  [10, 20, 30, [1, 2, 3, 4]]
```

------

## 参数

以下是调用函数时可使用的正式参数类型：

- 必需参数
- 关键字参数
- 默认参数
- 不定长参数

### 必需参数

必需参数须以正确的顺序传入函数。调用时的数量必须和声明时的一样。

调用 printme() 函数，你必须传入一个参数，不然会出现语法错误：

## 实例(Python 3.0+)

\#!/usr/bin/python3  #可写函数说明 def printme( str ):   "打印任何传入的字符串"   print (str)   return  # 调用 printme 函数，不加参数会报错 printme()

以上实例输出结果：

```
Traceback (most recent call last):
  File "test.py", line 10, in <module>
    printme()
TypeError: printme() missing 1 required positional argument: 'str'
```

### 关键字参数

关键字参数和函数调用关系紧密，函数调用使用关键字参数来确定传入的参数值。

使用关键字参数允许函数调用时参数的顺序与声明时不一致，因为 Python 解释器能够用参数名匹配参数值。

以下实例在函数 printme() 调用时使用参数名：

## 实例(Python 3.0+)

\#!/usr/bin/python3  #可写函数说明 def printme( str ):   "打印任何传入的字符串"   print (str)   return  #调用printme函数 printme( str = "菜鸟教程")

以上实例输出结果：

```
菜鸟教程
```

以下实例中演示了函数参数的使用不需要使用指定顺序：

## 实例(Python 3.0+)

\#!/usr/bin/python3  #可写函数说明 def printinfo( name, age ):   "打印任何传入的字符串"   print ("名字: ", name)   print ("年龄: ", age)   return  #调用printinfo函数 printinfo( age=50, name="runoob" )

以上实例输出结果：

```
名字:  runoob
年龄:  50
```

### 默认参数

调用函数时，如果没有传递参数，则会使用默认参数。以下实例中如果没有传入 age 参数，则使用默认值：

## 实例(Python 3.0+)

\#!/usr/bin/python3  #可写函数说明 def printinfo( name, age = 35 ):   "打印任何传入的字符串"   print ("名字: ", name)   print ("年龄: ", age)   return  #调用printinfo函数 printinfo( age=50, name="runoob" ) print ("------------------------") printinfo( name="runoob" )

以上实例输出结果：

```
名字:  runoob
年龄:  50
------------------------
名字:  runoob
年龄:  35
```

### 不定长参数

你可能需要一个函数能处理比当初声明时更多的参数。这些参数叫做不定长参数，和上述 2 种参数不同，声明时不会命名。基本语法如下：

```
def functionname([formal_args,] *var_args_tuple ):
   "函数_文档字符串"
   function_suite
   return [expression]
```

加了星号 * 的参数会以元组(tuple)的形式导入，存放所有未命名的变量参数。

## 实例(Python 3.0+)

\#!/usr/bin/python3   # 可写函数说明 def printinfo( arg1, *vartuple ):   "打印任何传入的参数"   print ("输出: ")   print (arg1)   print (vartuple)  # 调用printinfo 函数 printinfo( 70, 60, 50 )

以上实例输出结果：

```
输出: 
70
(60, 50)
```



如果在函数调用时没有指定参数，它就是一个空元组。我们也可以不向函数传递未命名的变量。如下实例：



## 实例(Python 3.0+)

\#!/usr/bin/python3  # 可写函数说明 def printinfo( arg1, *vartuple ):   "打印任何传入的参数"   print ("输出: ")   print (arg1)   for var in vartuple:      print (var)   return  # 调用printinfo 函数 printinfo( 10 ) printinfo( 70, 60, 50 )

以上实例输出结果：

```
输出:
10
输出:
70
60
50
```

还有一种就是参数带两个星号 **基本语法如下：

```
def functionname([formal_args,] **var_args_dict ):
   "函数_文档字符串"
   function_suite
   return [expression]
```

加了两个星号 ** 的参数会以字典的形式导入。

## 实例(Python 3.0+)

\#!/usr/bin/python3   # 可写函数说明 def printinfo( arg1, **vardict ):   "打印任何传入的参数"   print ("输出: ")   print (arg1)   print (vardict)  # 调用printinfo 函数 printinfo(1, a=2,b=3)

以上实例输出结果：

```
输出: 
1
{'a': 2, 'b': 3}
```

声明函数时，参数中星号 * 可以单独出现，例如:

```
def f(a,b,*,c):
    return a+b+c
```

如果单独出现星号 * 后的参数必须用关键字传入。

```
>>> def f(a,b,*,c):
...     return a+b+c
... 
>>> f(1,2,3)   # 报错
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: f() takes 2 positional arguments but 3 were given
>>> f(1,2,c=3) # 正常
6
>>>
```

------

## 匿名函数

Python 使用 lambda 来创建匿名函数。

所谓匿名，意即不再使用 **def** 语句这样标准的形式定义一个函数。

- lambda 只是一个表达式，函数体比 **def** 简单很多。
- lambda 的主体是一个表达式，而不是一个代码块。仅仅能在 lambda 表达式中封装有限的逻辑进去。
- lambda 函数拥有自己的命名空间，且不能访问自己参数列表之外或全局命名空间里的参数。
- 虽然 lambda 函数看起来只能写一行，却不等同于 C 或 C++ 的内联函数，后者的目的是调用小函数时不占用栈内存从而增加运行效率。

### 语法

lambda 函数的语法只包含一个语句，如下：

```
lambda [arg1 [,arg2,.....argn]]:expression
```

设置参数 a 加上 10:

## 实例

x = lambda a : a + 10 print(x(5))

以上实例输出结果：

```
15
```

以下实例匿名函数设置两个参数：

## 实例(Python 3.0+)

\#!/usr/bin/python3  # 可写函数说明 sum = lambda arg1, arg2: arg1 + arg2  # 调用sum函数 print ("相加后的值为 : ", sum( 10, 20 )) print ("相加后的值为 : ", sum( 20, 20 ))

以上实例输出结果：

```
相加后的值为 :  30
相加后的值为 :  40
```

我们可以将匿名函数封装在一个函数内，这样可以使用同样的代码来创建多个匿名函数。

以下实例将匿名函数封装在 myfunc 函数中，通过传入不同的参数来创建不同的匿名函数：

## 实例

def myfunc(n):  return lambda a : a * n  mydoubler = myfunc(2) mytripler = myfunc(3)  print(mydoubler(11)) print(mytripler(11))

以上实例输出结果：

```
22
33
```

------

## return 语句

**return [表达式]** 语句用于退出函数，选择性地向调用方返回一个表达式。不带参数值的 return 语句返回 None。之前的例子都没有示范如何返回数值，以下实例演示了 return 语句的用法：

## 实例(Python 3.0+)

\#!/usr/bin/python3  # 可写函数说明 def sum( arg1, arg2 ):   # 返回2个参数的和."   total = arg1 + arg2   print ("函数内 : ", total)   return total  # 调用sum函数 total = sum( 10, 20 ) print ("函数外 : ", total)

以上实例输出结果：

```
函数内 :  30
函数外 :  30
```

------

## 强制位置参数

Python3.8 新增了一个函数形参语法 / 用来指明函数形参必须使用指定位置参数，不能使用关键字参数的形式。

在以下的例子中，形参 a 和 b 必须使用指定位置参数，c 或 d 可以是位置形参或关键字形参，而 e 和 f 要求为关键字形参:

```
def f(a, b, /, c, d, *, e, f):
    print(a, b, c, d, e, f)
```

以下使用方法是正确的:

```
f(10, 20, 30, d=40, e=50, f=60)
```

以下使用方法会发生错误:

```
f(10, b=20, c=30, d=40, e=50, f=60)   # b 不能使用关键字参数的形式
f(10, 20, 30, 40, 50, f=60)           # e 必须使用关键字参数的形式
```

```python
def  函数名（参数列表）：
    函数体
```

让我们使用函数来输出"Hello World！"：

```python
>>> def hello() :
  print("Hello World!")

>>> hello()
Hello World!
>>> 
```

更复杂点的应用，函数中带上参数变量:

```python
def area(width, height):
    return width * height
 
def print_welcome(name):
    print("Welcome", name)

print_welcome("Fred")
w = 4
h = 5
print("width =", w, " height =", h, " area =", area(w, h))
```

### 函数变量作用域

定义在函数内部的变量拥有一个局部作用域，定义在函数外的拥有全局作用域。

### 关键字参数

函数也可以使用 kwarg=value 的关键字参数形式被调用。

```python
def parrot(voltage, state='a stiff', action='voom', type='Norwegian Blue'):
    print("-- This parrot wouldn't", action, end=' ')
    print("if you put", voltage, "volts through it.")
    print("-- Lovely plumage, the", type)
    print("-- It's", state, "!")
```

可以以下几种方式被调用: 

```python
parrot(1000)                                          # 1 positional argument
parrot(voltage=1000)                                  # 1 keyword argument
parrot(voltage=1000000, action='VOOOOOM')             # 2 keyword arguments
parrot(action='VOOOOOM', voltage=1000000)             # 2 keyword arguments
parrot('a million', 'bereft of life', 'jump')         # 3 positional arguments
parrot('a thousand', state='pushing up the daisies')  # 1 positional, 1 keyword
```

以下为错误调用方法：

```python
parrot()                     # required argument missing
parrot(voltage=5.0, 'dead')  # non-keyword argument after a keyword argument
parrot(110, voltage=220)     # duplicate value for the same argument
parrot(actor='John Cleese')  # unknown keyword argument
```

### 返回值

Python的函数的返回值使用return语句，可以将函数作为一个值赋值给指定变量：

```python
def return_sum(x,y):
    c = x + y
    return c

res = return_sum(4,5)
print(res)
```

你也可以让函数返回空值：

```python
def empty_return(x,y):
    c = x + y
    return

res = empty_return(4,5)
print(res)
```

### 可变参数列表

一个最不常用的选择是可以让函数调用可变个数的参数.这些参数被包装进一个元组(查看元组和序列).在这些可变个数的参数之前,可以有零到多个普通的参数: 

```
def arithmetic_mean(*args):
    sum = 0
    for x in args:
        sum += x
    return sum

print(arithmetic_mean(45,32,89,78))
print(arithmetic_mean(8989.8,78787.78,3453,78778.73))
print(arithmetic_mean(45,32))
print(arithmetic_mean(45))
print(arithmetic_mean())
```

## Python 数据结构

## 列表

Python中列表是可变的，这是它区别于字符串和元组的最重要的特点，一句话概括即：列表可以修改，而字符串和元组不能。

以下是 Python 中列表的方法：

| 方法              | 描述                                                         |
| ----------------- | ------------------------------------------------------------ |
| list.append(x)    | 把一个元素添加到列表的结尾，相当于 a[len(a):] = [x]。        |
| list.extend(L)    | 通过添加指定列表的所有元素来扩充列表，相当于 a[len(a):] = L。 |
| list.insert(i, x) | 在指定位置插入一个元素。第一个参数是准备插入到其前面的那个元素的索引，例如 a.insert(0, x) 会插入到整个列表之前，而 a.insert(len(a), x) 相当于 a.append(x) 。 |
| list.remove(x)    | 删除列表中值为 x 的第一个元素。如果没有这样的元素，就会返回一个错误。 |
| list.pop([i])     | 从列表的指定位置移除元素，并将其返回。如果没有指定索引，a.pop()返回最后一个元素。元素随即从列表中被移除。（方法中 i 两边的方括号表示这个参数是可选的，而不是要求你输入一对方括号，你会经常在 Python 库参考手册中遇到这样的标记。） |
| list.clear()      | 移除列表中的所有项，等于del a[:]。                           |
| list.index(x)     | 返回列表中第一个值为 x 的元素的索引。如果没有匹配的元素就会返回一个错误。 |
| list.count(x)     | 返回 x 在列表中出现的次数。                                  |
| list.sort()       | 对列表中的元素进行排序。                                     |
| list.reverse()    | 倒排列表中的元素。                                           |
| list.copy()       | 返回列表的浅复制，等于a[:]。                                 |

下面示例演示了列表的大部分方法：

## 实例

\>>> a = [66.25, 333, 333, 1, 1234.5]
 \>>> **print**(a.count(333), a.count(66.25), a.count('x'))
 2 1 0
 \>>> a.insert(2, -1)
 \>>> a.append(333)
 \>>> a
 [66.25, 333, -1, 333, 1, 1234.5, 333]
 \>>> a.index(333)
 1
 \>>> a.remove(333)
 \>>> a
 [66.25, -1, 333, 1, 1234.5, 333]
 \>>> a.reverse()
 \>>> a
 [333, 1234.5, 1, 333, -1, 66.25]
 \>>> a.sort()
 \>>> a
 [-1, 1, 66.25, 333, 333, 1234.5]

注意：类似 insert, remove 或 sort 等修改列表的方法没有返回值。

------

## 将列表当做堆栈使用

列表方法使得列表可以很方便的作为一个堆栈来使用，堆栈作为特定的数据结构，最先进入的元素最后一个被释放（后进先出）。用 append() 方法可以把一个元素添加到堆栈顶。用不指定索引的 pop() 方法可以把一个元素从堆栈顶释放出来。例如： 

## 实例

\>>> stack = [3, 4, 5]
 \>>> stack.append(6)
 \>>> stack.append(7)
 \>>> stack
 [3, 4, 5, 6, 7]
 \>>> stack.pop()
 7
 \>>> stack
 [3, 4, 5, 6]
 \>>> stack.pop()
 6
 \>>> stack.pop()
 5
 \>>> stack
 [3, 4]

------

## 将列表当作队列使用

也可以把列表当做队列用，只是在队列里第一加入的元素，第一个取出来；但是拿列表用作这样的目的效率不高。在列表的最后添加或者弹出元素速度快，然而在列表里插入或者从头部弹出速度却不快（因为所有其他的元素都得一个一个地移动）。

## 实例

\>>> **from** collections **import** deque
 \>>> queue = deque(["Eric", "John", "Michael"])
 \>>> queue.append("Terry")      # Terry arrives
 \>>> queue.append("Graham")      # Graham arrives
 \>>> queue.popleft()         # The first to arrive now leaves
 'Eric'
 \>>> queue.popleft()         # The second to arrive now leaves
 'John'
 \>>> queue              # Remaining queue in order of arrival
 deque(['Michael', 'Terry', 'Graham'])

------

## 列表推导式

列表推导式提供了从序列创建列表的简单途径。通常应用程序将一些操作应用于某个序列的每个元素，用其获得的结果作为生成新列表的元素，或者根据确定的判定条件创建子序列。 

每个列表推导式都在 for 之后跟一个表达式，然后有零到多个 for 或 if 子句。返回结果是一个根据表达从其后的 for 和 if 上下文环境中生成出来的列表。如果希望表达式推导出一个元组，就必须使用括号。

这里我们将列表中每个数值乘三，获得一个新的列表：

\>>> vec = [2, 4, 6]
 \>>> [3*x **for** x **in** vec]
 [6, 12, 18]

现在我们玩一点小花样：

\>>> [[x, x**2] **for** x **in** vec]
 [[2, 4], [4, 16], [6, 36]]

这里我们对序列里每一个元素逐个调用某方法：

## 实例

\>>> freshfruit = ['  banana', '  loganberry ', 'passion fruit  ']
 \>>> [weapon.strip() **for** weapon **in** freshfruit]
 ['banana', 'loganberry', 'passion fruit']

我们可以用 if 子句作为过滤器： 

\>>> [3*x **for** x **in** vec **if** x > 3]
 [12, 18]
 \>>> [3*x **for** x **in** vec **if** x < 2]
 []

以下是一些关于循环和其它技巧的演示：

\>>> vec1 = [2, 4, 6]
 \>>> vec2 = [4, 3, -9]
 \>>> [x*y **for** x **in** vec1 **for** y **in** vec2]
 [8, 6, -18, 16, 12, -36, 24, 18, -54]
 \>>> [x+y **for** x **in** vec1 **for** y **in** vec2]
 [6, 5, -7, 8, 7, -5, 10, 9, -3]
 \>>> [vec1[i]*vec2[i] **for** i **in** range(len(vec1))]
 [8, 12, -54]

列表推导式可以使用复杂表达式或嵌套函数：

\>>> [str(round(355/113, i)) **for** i **in** range(1, 6)]
 ['3.1', '3.14', '3.142', '3.1416', '3.14159']

------

## 嵌套列表解析

Python的列表还可以嵌套。

以下实例展示了3X4的矩阵列表：

\>>> matrix = [
 ...   [1, 2, 3, 4],
 ...   [5, 6, 7, 8],
 ...   [9, 10, 11, 12],
 ... ]

以下实例将3X4的矩阵列表转换为4X3列表：

\>>> [[row[i] **for** row **in** matrix] **for** i **in** range(4)]
 [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]

以下实例也可以使用以下方法来实现：

\>>> transposed = []
 \>>> **for** i **in** range(4):
 ...   transposed.append([row[i] **for** row **in** matrix])
 ...
 \>>> transposed
 [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]

另外一种实现方法：

\>>> transposed = []
 \>>> **for** i **in** range(4):
 ...   # the following 3 lines implement the nested listcomp
 ...   transposed_row = []
 ...   **for** row **in** matrix:
 ...     transposed_row.append(row[i])
 ...   transposed.append(transposed_row)
 ...
 \>>> transposed
 [[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]

------

## del 语句

使用 del 语句可以从一个列表中根据索引来删除一个元素，而不是值来删除元素。这与使用 pop() 返回一个值不同。可以用 del 语句从列表中删除一个切割，或清空整个列表（我们以前介绍的方法是给该切割赋一个空列表）。例如：

\>>> a = [-1, 1, 66.25, 333, 333, 1234.5]
 \>>> **del** a[0]
 \>>> a
 [1, 66.25, 333, 333, 1234.5]
 \>>> **del** a[2:4]
 \>>> a
 [1, 66.25, 1234.5]
 \>>> **del** a[:]
 \>>> a
 []

也可以用 del 删除实体变量： 

```
>>> del a
```

------

##  元组和序列 

元组由若干逗号分隔的值组成，例如：

\>>> t = 12345, 54321, 'hello!'
 \>>> t[0]
 12345
 \>>> t
 (12345, 54321, 'hello!')
 \>>> # Tuples may be nested:
 ... u = t, (1, 2, 3, 4, 5)
 \>>> u
 ((12345, 54321, 'hello!'), (1, 2, 3, 4, 5))

如你所见，元组在输出时总是有括号的，以便于正确表达嵌套结构。在输入时可能有或没有括号， 不过括号通常是必须的（如果元组是更大的表达式的一部分）。

------

## 集合

集合是一个无序不重复元素的集。基本功能包括关系测试和消除重复元素。

可以用大括号({})创建集合。注意：如果要创建一个空集合，你必须用 set() 而不是 {} ；后者创建一个空的字典，下一节我们会介绍这个数据结构。

以下是一个简单的演示：

\>>> basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
 \>>> **print**(basket)            # 删除重复的
 {'orange', 'banana', 'pear', 'apple'}
 \>>> 'orange' **in** basket         # 检测成员
 True
 \>>> 'crabgrass' **in** basket
 False

 \>>> # 以下演示了两个集合的操作
 ...
 \>>> a = set('abracadabra')
 \>>> b = set('alacazam')
 \>>> a                  # a 中唯一的字母
 {'a', 'r', 'b', 'c', 'd'}
 \>>> a - b                # 在 a 中的字母，但不在 b 中
 {'r', 'd', 'b'}
 \>>> a | b                # 在 a 或 b 中的字母
 {'a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'}
 \>>> a & b                # 在 a 和 b 中都有的字母
 {'a', 'c'}
 \>>> a ^ b                # 在 a 或 b 中的字母，但不同时在 a 和 b 中
 {'r', 'd', 'b', 'm', 'z', 'l'}

集合也支持推导式：

\>>> a = {x **for** x **in** 'abracadabra' **if** x **not** **in** 'abc'}
 \>>> a
 {'r', 'd'}

------

## 字典

另一个非常有用的 Python 内建数据类型是字典。

序列是以连续的整数为索引，与此不同的是，字典以关键字为索引，关键字可以是任意不可变类型，通常用字符串或数值。

理解字典的最佳方式是把它看做无序的键=>值对集合。在同一个字典之内，关键字必须是互不相同。

一对大括号创建一个空的字典：{}。

这是一个字典运用的简单例子： 

\>>> tel = {'jack': 4098, 'sape': 4139}
 \>>> tel['guido'] = 4127
 \>>> tel
 {'sape': 4139, 'guido': 4127, 'jack': 4098}
 \>>> tel['jack']
 4098
 \>>> **del** tel['sape']
 \>>> tel['irv'] = 4127
 \>>> tel
 {'guido': 4127, 'irv': 4127, 'jack': 4098}
 \>>> list(tel.keys())
 ['irv', 'guido', 'jack']
 \>>> sorted(tel.keys())
 ['guido', 'irv', 'jack']
 \>>> 'guido' **in** tel
 True
 \>>> 'jack' **not** **in** tel
 False

构造函数 dict() 直接从键值对元组列表中构建字典。如果有固定的模式，列表推导式指定特定的键值对：

\>>> dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
 {'sape': 4139, 'jack': 4098, 'guido': 4127}

此外，字典推导可以用来创建任意键和值的表达式词典：

\>>> {x: x**2 **for** x **in** (2, 4, 6)}
 {2: 4, 4: 16, 6: 36}

如果关键字只是简单的字符串，使用关键字参数指定键值对有时候更方便： 

\>>> dict(sape=4139, guido=4127, jack=4098)
 {'sape': 4139, 'jack': 4098, 'guido': 4127}

------

## 遍历技巧

在字典中遍历时，关键字和对应的值可以使用 items() 方法同时解读出来：

\>>> knights = {'gallahad': 'the pure', 'robin': 'the brave'}
 \>>> **for** k, v **in** knights.items():
 ...   **print**(k, v)
 ...
 gallahad the pure
 robin the brave

在序列中遍历时，索引位置和对应值可以使用 enumerate() 函数同时得到：

\>>> **for** i, v **in** enumerate(['tic', 'tac', 'toe']):
 ...   **print**(i, v)
 ...
 0 tic
 1 tac
 2 toe

同时遍历两个或更多的序列，可以使用 zip() 组合： 

\>>> questions = ['name', 'quest', 'favorite color']
 \>>> answers = ['lancelot', 'the holy grail', 'blue']
 \>>> **for** q, a **in** zip(questions, answers):
 ...   **print**('What is your {0}?  It is {1}.'.format(q, a))
 ...
 What **is** your name?  It **is** lancelot.
 What **is** your quest?  It **is** the holy grail.
 What **is** your favorite color?  It **is** blue.

要反向遍历一个序列，首先指定这个序列，然后调用 reversed() 函数： 

\>>> **for** i **in** reversed(range(1, 10, 2)):
 ...   **print**(i)
 ...
 9
 7
 5
 3
 1

要按顺序遍历一个序列，使用 sorted() 函数返回一个已排序的序列，并不修改原值： 

\>>> basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
 \>>> **for** f **in** sorted(set(basket)):
 ...   **print**(f)
 ...
 apple
 banana
 orange
 pear

### 列表

Python中列表是可变的，这是它区别于字符串和元组的最重要的特点，一句话概括即：列表可以修改，而字符串和元组不能。 

以下是 Python 中列表的方法：

| 方法              | 描述                                                         |
| ----------------- | ------------------------------------------------------------ |
| list.append(x)    | 把一个元素添加到列表的结尾，相当于 a[len(a):] = [x]。        |
| list.extend(L)    | 通过添加指定列表的所有元素来扩充列表，相当于 a[len(a):] = L。 |
| list.insert(i, x) | 在指定位置插入一个元素。第一个参数是准备插入到其前面的那个元素的索引，例如 a.insert(0, x) 会插入到整个列表之前，而 a.insert(len(a), x) 相当于 a.append(x) 。 |
| list.remove(x)    | 删除列表中值为 x 的第一个元素。如果没有这样的元素，就会返回一个错误。 |
| list.pop([i])     | 从列表的指定位置删除元素，并将其返回。如果没有指定索引，a.pop()返回最后一个元素。元素随即从列表中被删除。（方法中 i 两边的方括号表示这个参数是可选的，而不是要求你输入一对方括号，你会经常在 Python 库参考手册中遇到这样的标记。） |
| list.clear()      | 移除列表中的所有项，等于del a[:]。                           |
| list.index(x)     | 返回列表中第一个值为 x 的元素的索引。如果没有匹配的元素就会返回一个错误。 |
| list.count(x)     | 返回 x 在列表中出现的次数。                                  |
| list.sort()       | 对列表中的元素进行排序。                                     |
| list.reverse()    | 倒排列表中的元素。                                           |
| list.copy()       | 返回列表的浅复制，等于a[:]。                                 |

下面示例演示了列表的大部分方法：

```
>>> a = [66.25, 333, 333, 1, 1234.5]
>>> print(a.count(333), a.count(66.25), a.count('x'))
2 1 0
>>> a.insert(2, -1)
>>> a.append(333)
>>> a
[66.25, 333, -1, 333, 1, 1234.5, 333]
>>> a.index(333)
1
>>> a.remove(333)
>>> a
[66.25, -1, 333, 1, 1234.5, 333]
>>> a.reverse()
>>> a
[333, 1234.5, 1, 333, -1, 66.25]
>>> a.sort()
>>> a
[-1, 1, 66.25, 333, 333, 1234.5]
```

注意：类似 insert, remove 或 sort 等修改列表的方法没有返回值。

将列表当做堆栈使用

 列表方法使得列表可以很方便的作为一个堆栈来使用，堆栈作为特定的数据结构，最先进入的元素最后一个被释放（后进先出）。用 append() 方法可以把一个元素添加到堆栈顶。用不指定索引的 pop() 方法可以把一个元素从堆栈顶释放出来。例如： 

```
>>> stack = [3, 4, 5]
>>> stack.append(6)
>>> stack.append(7)
>>> stack
[3, 4, 5, 6, 7]
>>> stack.pop()
7
>>> stack
[3, 4, 5, 6]
>>> stack.pop()
6
>>> stack.pop()
5
>>> stack
[3, 4]
```

将列表当作队列使用

也可以把列表当做队列用，只是在队列里第一加入的元素，第一个取出来；但是拿列表用作这样的目的效率不高。在列表的最后添加或者弹出元素速度快，然而在列表里插入或者从头部弹出速度却不快（因为所有其他的元素都得一个一个地移动）。 

```
>>> from collections import deque
>>> queue = deque(["Eric", "John", "Michael"])
>>> queue.append("Terry")           # Terry arrives
>>> queue.append("Graham")          # Graham arrives
>>> queue.popleft()                 # The first to arrive now leaves
'Eric'
>>> queue.popleft()                 # The second to arrive now leaves
'John'
>>> queue                           # Remaining queue in order of arrival
deque(['Michael', 'Terry', 'Graham'])
```

列表推导式

列表推导式提供了从序列创建列表的简单途径。通常应用程序将一些操作应用于某个序列的每个元素，用其获得的结果作为生成新列表的元素，或者根据确定的判定条件创建子序列。 

 每个列表推导式都在 for 之后跟一个表达式，然后有零到多个 for 或 if 子句。返回结果是一个根据表达从其后的 for 和 if 上下文环境中生成出来的列表。如果希望表达式推导出一个元组，就必须使用括号。 

这里我们将列表中每个数值乘三，获得一个新的列表：

```
>>> vec = [2, 4, 6]
>>> [3*x for x in vec]
[6, 12, 18]
```

现在我们玩一点小花样：

```
>>> [[x, x**2] for x in vec]
[[2, 4], [4, 16], [6, 36]]
```

 这里我们对序列里每一个元素逐个调用某方法： 

```
>>> freshfruit = ['  banana', '  loganberry ', 'passion fruit  ']
>>> [weapon.strip() for weapon in freshfruit]
['banana', 'loganberry', 'passion fruit']
```

我们可以用 if 子句作为过滤器： 

```
>>> [3*x for x in vec if x > 3]
[12, 18]
>>> [3*x for x in vec if x < 2] [] 
```

以下是一些关于循环和其它技巧的演示：

```
>>> vec1 = [2, 4, 6]
>>> vec2 = [4, 3, -9]
>>> [x*y for x in vec1 for y in vec2]
[8, 6, -18, 16, 12, -36, 24, 18, -54]
>>> [x+y for x in vec1 for y in vec2]
[6, 5, -7, 8, 7, -5, 10, 9, -3]
>>> [vec1[i]*vec2[i] for i in range(len(vec1))]
[8, 12, -54]
```

列表推导式可以使用复杂表达式或嵌套函数： 

```
>>> [str(round(355/113, i)) for i in range(1, 6)]
['3.1', '3.14', '3.142', '3.1416', '3.14159']
```

嵌套列表解析

 Python的列表还可以嵌套。 

以下实例展示了3X4的矩阵列表：

```
>>> matrix = [
...     [1, 2, 3, 4],
...     [5, 6, 7, 8],
...     [9, 10, 11, 12],
... ]
```

以下实例将3X4的矩阵列表转换为4X3列表：

```
>>> [[row[i] for row in matrix] for i in range(4)]
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
```

以下实例也可以使用以下方法来实现：

```
>>> transposed = []
>>> for i in range(4):
...     transposed.append([row[i] for row in matrix])
...
>>> transposed
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
```

另外一种实现方法：

```
>>> transposed = []
>>> for i in range(4):
...     # the following 3 lines implement the nested listcomp
...     transposed_row = []
...     for row in matrix:
...         transposed_row.append(row[i])
...     transposed.append(transposed_row)
...
>>> transposed
[[1, 5, 9], [2, 6, 10], [3, 7, 11], [4, 8, 12]]
```

del 语句

 使用 del 语句可以从一个列表中依索引而不是值来删除一个元素。这与使用 pop() 返回一个值不同。可以用 del 语句从列表中删除一个切割，或清空整个列表（我们以前介绍的方法是给该切割赋一个空列表）。例如： 

```
>>> a = [-1, 1, 66.25, 333, 333, 1234.5]
>>> del a[0]
>>> a
[1, 66.25, 333, 333, 1234.5]
>>> del a[2:4]
>>> a
[1, 66.25, 1234.5]
>>> del a[:]
>>> a
[]
```

也可以用 del 删除实体变量： 

```
>>> del a
```

### 元组和序列 

 元组由若干逗号分隔的值组成，例如： 

```
>>> t = 12345, 54321, 'hello!'
>>> t[0]
12345
>>> t
(12345, 54321, 'hello!')
>>> # Tuples may be nested:
... u = t, (1, 2, 3, 4, 5)
>>> u
((12345, 54321, 'hello!'), (1, 2, 3, 4, 5))
```

如你所见，元组在输出时总是有括号的，以便于正确表达嵌套结构。在输入时可能有或没有括号， 不过括号通常是必须的（如果元组是更大的表达式的一部分）。 

### 集合

集合是一个无序不重复元素的集。基本功能包括关系测试和消除重复元素。

可以用大括号({})创建集合。注意：如果要创建一个空集合，你必须用 set() 而不是 {} ；后者创建一个空的字典，下一节我们会介绍这个数据结构。

以下是一个简单的演示：

```
>>> basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
>>> print(basket)                      # show that duplicates have been removed
{'orange', 'banana', 'pear', 'apple'}
>>> 'orange' in basket                 # fast membership testing
True
>>> 'crabgrass' in basket
False

>>> # Demonstrate set operations on unique letters from two words
...
>>> a = set('abracadabra')
>>> b = set('alacazam')
>>> a                                  # unique letters in a
{'a', 'r', 'b', 'c', 'd'}
>>> a - b                              # letters in a but not in b
{'r', 'd', 'b'}
>>> a | b                              # letters in either a or b
{'a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'}
>>> a & b                              # letters in both a and b
{'a', 'c'}
>>> a ^ b                              # letters in a or b but not both
{'r', 'd', 'b', 'm', 'z', 'l'}>>> basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
>>> print(basket)                      # show that duplicates have been removed
{'orange', 'banana', 'pear', 'apple'}
>>> 'orange' in basket                 # fast membership testing
True
>>> 'crabgrass' in basket
False

>>> # Demonstrate set operations on unique letters from two words
...
>>> a = set('abracadabra')
>>> b = set('alacazam')
>>> a                                  # unique letters in a
{'a', 'r', 'b', 'c', 'd'}
>>> a - b                              # letters in a but not in b
{'r', 'd', 'b'}
>>> a | b                              # letters in either a or b
{'a', 'c', 'r', 'd', 'b', 'm', 'z', 'l'}
>>> a & b                              # letters in both a and b
{'a', 'c'}
>>> a ^ b                              # letters in a or b but not both
{'r', 'd', 'b', 'm', 'z', 'l'}
```

集合也支持推导式：

```
>>> a = {x for x in 'abracadabra' if x not in 'abc'}
>>> a
{'r', 'd'}
```

### 字典

另一个非常有用的 Python 内建数据类型是字典。

序列是以连续的整数为索引，与此不同的是，字典以关键字为索引，关键字可以是任意不可变类型，通常用字符串或数值。

理解字典的最佳方式是把它看做无序的键=>值对集合。在同一个字典之内，关键字必须是互不相同。

一对大括号创建一个空的字典：{}。

这是一个字典运用的简单例子： 

```
>>> tel = {'jack': 4098, 'sape': 4139}
>>> tel['guido'] = 4127
>>> tel
{'sape': 4139, 'guido': 4127, 'jack': 4098}
>>> tel['jack']
4098
>>> del tel['sape']
>>> tel['irv'] = 4127
>>> tel
{'guido': 4127, 'irv': 4127, 'jack': 4098}
>>> list(tel.keys())
['irv', 'guido', 'jack']
>>> sorted(tel.keys())
['guido', 'irv', 'jack']
>>> 'guido' in tel
True
>>> 'jack' not in tel
False
```

构造函数 dict() 直接从键值对元组列表中构建字典。如果有固定的模式，列表推导式指定特定的键值对：

```
>>> dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
{'sape': 4139, 'jack': 4098, 'guido': 4127}
```

此外，字典推导可以用来创建任意键和值的表达式词典：

```
>>> {x: x**2 for x in (2, 4, 6)}
{2: 4, 4: 16, 6: 36}
```

如果关键字只是简单的字符串，使用关键字参数指定键值对有时候更方便： 

```
>>> dict(sape=4139, guido=4127, jack=4098)
{'sape': 4139, 'jack': 4098, 'guido': 4127}
```

遍历技巧

 在字典中遍历时，关键字和对应的值可以使用 items() 方法同时解读出来： 

```
>>> knights = {'gallahad': 'the pure', 'robin': 'the brave'}
>>> for k, v in knights.items():
...     print(k, v)
...
gallahad the pure
robin the brave
```

在序列中遍历时，索引位置和对应值可以使用 enumerate() 函数同时得到：

```
>>> for i, v in enumerate(['tic', 'tac', 'toe']):
...     print(i, v)
...
0 tic
1 tac
2 toe
```

同时遍历两个或更多的序列，可以使用 zip() 组合： 

```
>>> questions = ['name', 'quest', 'favorite color']
>>> answers = ['lancelot', 'the holy grail', 'blue']
>>> for q, a in zip(questions, answers):
...     print('What is your {0}?  It is {1}.'.format(q, a))
...
What is your name?  It is lancelot.
What is your quest?  It is the holy grail.
What is your favorite color?  It is blue.
```

要反向遍历一个序列，首先指定这个序列，然后调用 reversesd() 函数： 

```
>>> for i in reversed(range(1, 10, 2)):
...     print(i)
...
9
7
5
3
1
```

要按顺序遍历一个序列，使用 sorted() 函数返回一个已排序的序列，并不修改原值： 

```
>>> basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
>>> for f in sorted(set(basket)):
...     print(f)
...
apple
banana
orange
pear
```

## 模块

模块是一个包含所有你定义的函数和变量的文件，其后缀名是.py。模块可以被别的程序引入，以使用该模块中的函数等功能。这也是使用python标准库的方法。

在 python 用 import 或者 from...import 来导入相应的模块。

```python
#!/usr/bin/python3
# Filename: using_sys.py

import sys

print('命令行参数如下:')
for i in sys.argv:
   print(i)

print('\n\nPython 路径为：', sys.path, '\n')
```

执行结果如下所示：

```shell
$ python using_sys.py 参数1 参数2
命令行参数如下:
using_sys.py
参数1
参数2

Python 路径为： ['/root', '/usr/lib/python3.4', '/usr/lib/python3.4/plat-x86_64-linux-gnu', '/usr/lib/python3.4/lib-dynload', '/usr/local/lib/python3.4/dist-packages', '/usr/lib/python3/dist-packages']
```

- import sys引入python标准库中的sys.py模块；这是引入某一模块的方法。
- sys.argv是一个包含命令行参数的列表。
- sys.path包含了一个Python解释器自动查找所需模块的路径的列表。

### import语句

如果要使用 Python 源文件，只需在另一个源文件里执行 import 语句：

```python
import module1[,module2[, ... moduleN]
```

当解释器遇到 import 语句，如果模块在当前的搜索路径就会被导入。

搜索路径是一个解释器会先进行搜索的所有目录的列表。如果想要导入模块 support，需要把命令放在脚本的顶端。

一个模块只会被导入一次。这样可以防止导入模块被一遍又一遍地执行。

当我们使用import语句的时候，Python解释器是怎样找到对应的文件的呢？

搜索路径是在Python编译或安装的时候确定的，安装新的库应该也会修改。搜索路径被存储在sys模块中的path变量： 

```
>>> import sys
>>> sys.path
['', '/usr/lib/python3.4', '/usr/lib/python3.4/plat-x86_64-linux-gnu', '/usr/lib/python3.4/lib-dynload', '/usr/local/lib/python3.4/dist-packages', '/usr/lib/python3/dist-packages']
>>> 
```

sys.path输出是一个列表，其中第一项是空串''，代表当前目录。

### from ... import 语句

Python 的 from 语句让你从模块中导入一个指定的部分到当前命名空间中，语法如下：

```python
from modname import name1[, name2[, ... nameN]
```

### from ... import * 语句

把一个模块的所有内容全都导入到当前的命名空间也是可行的，只需使用如下声明：

```python
from modname import *
```

这提供了一个简单的方法来导入一个模块中的所有项目。然而这种声明不该被过多的使用。

### 深入模块

模块除了方法定义，还可以包括可执行的代码。这些代码一般用来初始化这个模块。这些代码只有在第一次被导入时才会被执行。

每个模块有各自独立的符号表，在模块内部为所有的函数当作全局符号表来使用。

所以，模块的作者可以放心大胆的在模块内部使用这些全局变量，而不用担心把其他用户的全局变量搞花。

从另一个方面，当你确实知道你在做什么的话，你也可以通过 modname.itemname 这样的表示法来访问模块内的函数。

模块是可以导入其他模块的。在一个模块（或者脚本，或者其他地方）的最前面使用 import 来导入一个模块，当然这只是一个惯例，而不是强制的。被导入的模块的名称将被放入当前操作的模块的符号表中。

还有一种导入的方法，可以使用 import 直接把模块内（函数，变量的）名称导入到当前操作模块。比如:

```
>>> from fibo import fib, fib2
>>> fib(500)
1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

这种导入的方法不会把被导入的模块的名称放在当前的字符表中（所以在这个例子里面，fibo 这个名称是没有定义的）。

这还有一种方法，可以一次性的把模块中的所有（函数，变量）名称都导入到当前模块的字符表:

```
>>> from fibo import *
>>> fib(500)
1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

这将把所有的名字都导入进来，但是那些由单一下划线（_）开头的名字不在此例。大多数情况， Python程序员不使用这种方法，因为引入的其它来源的命名，很可能覆盖了已有的定义。

### `__name__`属性

一个模块被另一个程序第一次引入时，其主程序将运行。如果我们想在模块被引入时，模块中的某一程序块不执行，我们可以用__name__属性来使该程序块仅在该模块自身运行时执行。

```
#!/usr/bin/python3
# Filename: using_name.py

if __name__ == '__main__':
 print('程序自身在运行')
else:
 print('我来自另一模块')
```

运行输出如下：

```
$ python using_name.py
程序自身在运行
$ python
>>> import using_name
我来自另一模块
>>>
```

 **说明：**

1. 每个模块都有一个__name__属性，当其值是'__main__'时，表明该模块自身在运行，否则是被引入。
2. __name__ 与 __main__ 底下是双下划线，是“_ _”去掉中间的空格。

### dir() 函数

```
内置的函数 dir() 可以找到模块内定义的所有名称。以一个字符串列表的形式返回:
</p>
<pre>
>>> import fibo, sys
>>> dir(fibo)
['__name__', 'fib', 'fib2']
>>> dir(sys)  
['__displayhook__', '__doc__', '__excepthook__', '__loader__', '__name__',
 '__package__', '__stderr__', '__stdin__', '__stdout__',
 '_clear_type_cache', '_current_frames', '_debugmallocstats', '_getframe',
 '_home', '_mercurial', '_xoptions', 'abiflags', 'api_version', 'argv',
 'base_exec_prefix', 'base_prefix', 'builtin_module_names', 'byteorder',
 'call_tracing', 'callstats', 'copyright', 'displayhook',
 'dont_write_bytecode', 'exc_info', 'excepthook', 'exec_prefix',
 'executable', 'exit', 'flags', 'float_info', 'float_repr_style',
 'getcheckinterval', 'getdefaultencoding', 'getdlopenflags',
 'getfilesystemencoding', 'getobjects', 'getprofile', 'getrecursionlimit',
 'getrefcount', 'getsizeof', 'getswitchinterval', 'gettotalrefcount',
 'gettrace', 'hash_info', 'hexversion', 'implementation', 'int_info',
 'intern', 'maxsize', 'maxunicode', 'meta_path', 'modules', 'path',
 'path_hooks', 'path_importer_cache', 'platform', 'prefix', 'ps1',
 'setcheckinterval', 'setdlopenflags', 'setprofile', 'setrecursionlimit',
 'setswitchinterval', 'settrace', 'stderr', 'stdin', 'stdout',
 'thread_info', 'version', 'version_info', 'warnoptions']
```

如果没有给定参数，那么 dir() 函数会罗列出当前定义的所有名称:

```
>>> a = [1, 2, 3, 4, 5]
>>> import fibo
>>> fib = fibo.fib
>>> dir() # 得到一个当前模块中定义的属性列表
['__builtins__', '__name__', 'a', 'fib', 'fibo', 'sys']
>>> a = 5 # 建立一个新的变量 'a'
>>> dir()
['__builtins__', '__doc__', '__name__', 'a', 'sys']
>>>
>>> del a # 删除变量名a
>>>
>>> dir()
['__builtins__', '__doc__', '__name__', 'sys']
>>>
```

### 标准模块 

Python 本身带着一些标准的模块库。

有些模块直接被构建在解析器里，这些虽然不是一些语言内置的功能，但是他却能很高效的使用，甚至是系统级调用也没问题。

这些组件会根据不同的操作系统进行不同形式的配置，比如 winreg 这个模块就只会提供给 Windows 系统。

应该注意到这有一个特别的模块 sys ，它内置在每一个 Python 解析器中。变量 sys.ps1 和 sys.ps2 定义了主提示符和副提示符所对应的字符串:

```
>>> import sys
>>> sys.ps1
'>>> '
>>> sys.ps2
'... '
>>> sys.ps1 = 'C> '
C> print('Yuck!')
Yuck!
C>
```

## 包

包是一种管理 Python 模块命名空间的形式，采用"点模块名称"。

比如一个模块的名称是 A.B， 那么他表示一个包 A中的子模块 B 。

就好像使用模块的时候，你不用担心不同模块之间的全局变量相互影响一样，采用点模块名称这种形式也不用担心不同库之间的模块重名的情况。

并且针对这些音频数据，还有很多不同的操作（比如混音，添加回声，增加均衡器功能，创建人造立体声效果），所以你还需要一组怎么也写不完的模块来处理这些操作。

这里给出了一种可能的包结构（在分层的文件系统中）:

```
sound/                          顶层包
      __init__.py               初始化 sound 包
      formats/                  文件格式转换子包
              __init__.py
              wavread.py
              wavwrite.py
              aiffread.py
              aiffwrite.py
              auread.py
              auwrite.py
              ...
      effects/                  声音效果子包
              __init__.py
              echo.py
              surround.py
              reverse.py
              ...
      filters/                  filters 子包
              __init__.py
              equalizer.py
              vocoder.py
              karaoke.py
              ...
```

在导入一个包的时候，Python 会根据 sys.path 中的目录来寻找这个包中包含的子目录。

目录只有包含一个叫做 __init__.py 的文件才会被认作是一个包，主要是为了避免一些滥俗的名字（比如叫做 string）不小心的影响搜索路径中的有效模块。

最简单的情况，放一个空的 :file:__init__.py就可以了。当然这个文件中也可以包含一些初始化代码或者为（将在后面介绍的） __all__变量赋值。

用户可以每次只导入一个包里面的特定模块，比如:

```
import sound.effects.echo
```

这将会导入子模块:mod:song.effects.echo。 他必须使用全名去访问:

```
sound.effects.echo.echofilter(input, output, delay=0.7, atten=4)
```

还有一种导入子模块的方法是：

```
from sound.effects import echo
```

这同样会导入子模块 echo ，并且他不需要那些冗长的前缀，所以他可以这样使用：

```
echo.echofilter(input, output, delay=0.7, atten=4)
```

还有一种变化就是直接导入一个函数或者变量：

```
from sound.effects.echo import echofilter
```

同样的，这种方法会导入子模块 echo ，并且可以直接使用他的 echofilter() 函数：

echofilter(input, output, delay=0.7, atten=4)

注意当使用from package import item这种形式的时候，对应的item既可以是包里面的子模块（子包），或者包里面定义的其他名称，比如函数，类或者变量。

import语法会首先把item当作一个包定义的名称，如果没找到，再试图按照一个模块去导入。如果还没找到，恭喜，一个:exc:ImportError 异常被抛出了。

反之，如果使用形如import item.subitem.subsubitem这种导入形式，除了最后一项，都必须是包，而最后一项则可以是模块或者是包，但是不可以是类，函数或者变量的名字。

### 从一个包中导入* 

设想一下，如果我们使用 from sound.effects import *会发生什么？

Python 会进入文件系统，找到这个包里面所有的子模块，一个一个的把它们都导入进来。

但是很不幸，这个方法在 Windows平台上工作的就不是非常好，因为Windows是一个大小写不区分的系统。

在这类平台上，没有人敢担保一个叫做 ECHO.py 的文件导入为模块 echo 还是 Echo 甚至 ECHO 。

（例如，Windows 95就很讨厌的把每一个文件的首字母大写显示）而且 DOS 的 8+3 命名规则对长模块名称的处理会把问题搞得更纠结。

为了解决这个问题，只能烦劳包作者提供一个精确的包的索引了。

导入语句遵循如下规则：如果包定义文件 __init__.py 存在一个叫做 __all__ 的列表变量，那么在使用 from package import * 的时候就把这个列表中的所有名字作为包内容导入。

作为包的作者，可别忘了在更新包之后保证 __all__ 也更新了啊。你说我就不这么做，我就不使用导入*这种用法，好吧，没问题，谁让你是老板呢。这里有一个例子，在:file:sounds/effects/__init__.py中包含如下代码：

```
__all__ = ["echo", "surround", "reverse"]
```

这表示当你使用from sound.effects import *这种用法时，你只会导入包里面这三个子模块。

如果__all__真的而没有定义，那么使用from sound.effects import *这种语法的时候，就不会导入包  sound.effects 里的任何子模块。他只是把包 sound.effects 和它里面定义的所有内容导入进来（可能运行  __init__.py 里定义的初始化代码）。

这会把 __init__.py 里面定义的所有名字导入进来。并且他不会破坏掉我们在这句话之前导入的所有明确指定的模块。看下这部分代码:

```
import sound.effects.echo
import sound.effects.surround
from sound.effects import *
```

这个例子中，在执行from...import前，包 sound.effects 中的echo和surround模块都被导入到当前的命名空间中了。（当然如果定义了__all__就更没问题了）

通常我们并不主张使用*这种方法来导入模块，因为这种方法经常会导致代码的可读性降低。不过这样倒的确是可以省去不少敲键的功夫，而且一些模块都设计成了只能通过特定的方法导入。

记住，使用from Package import specific_submodule这种方法永远不会有错。事实上，这也是推荐的方法。除非是你要导入的子模块有可能和其他包的子模块重名。

如果在结构中包是一个子包（比如这个例子中对于包 sound  来说），而你又想导入兄弟包（同级别的包）你就得使用导入绝对的路径来导入。比如，如果模块 sound.filters.vocoder 要使用包  sound.effects 中的模块 echo ，你就要写成 from sound.effects import echo。

```
from . import echo
from .. import formats
from ..filters import equalizer
```

无论是隐式的还是显式的相对导入都是从当前模块开始的。主模块的名字永远是"__main__"，一个Python应用程序的主模块，应当总是使用绝对路径引用。

包还提供一个额外的属性 __path__ 。这是一个目录列表，里面每一个包含的目录都有为这个包服务的 __init__.py ，你得在其他 __init__.py 被执行前定义哦。可以修改这个变量，用来影响包含在包里面的模块和子包。

这个功能并不常用，一般用来扩展包里面的模块。

## Python 输入和输出

在前面几个章节中，我们其实已经接触了 Python 的输入输出的功能。本章节我们将具体介绍 Python 的输入输出。

### 输入

### 输出

## 输出格式美化

 Python 两种输出值的方式: 表达式语句和 print() 函数。(第三种方式是使用文件对象的 write() 方法; 标准输出文件可以用 sys.stdout 引用。) 

如果你希望输出的形式更加多样，可以使用 str.format() 函数来格式化输出值。

如果你希望将输出的值转成字符串，可以使用 repr() 或 str() 函数来实现。

 str() 函数返回一个用户易读的表达形式。 

 repr() 产生一个解释器易读的表达形式。 

###  例如 

```
>>> s = 'Hello, world.'
>>> str(s)
'Hello, world.'
>>> repr(s)
"'Hello, world.'"
>>> str(1/7)
'0.14285714285714285'
>>> x = 10 * 3.25
>>> y = 200 * 200
>>> s = 'The value of x is ' + repr(x) + ', and y is ' + repr(y) + '...'
>>> print(s)
The value of x is 32.5, and y is 40000...
>>> #  repr() 函数可以转义字符串中的特殊字符
... hello = 'hello, world\n'
>>> hellos = repr(hello)
>>> print(hellos)
'hello, world\n'
>>> # repr() 的参数可以是 Python 的任何对象
... repr((x, y, ('spam', 'eggs')))
"(32.5, 40000, ('spam', 'eggs'))"
```

 这里有两种方式输出一个平方与立方的表: 

```
>>> for x in range(1, 11):
...     print(repr(x).rjust(2), repr(x*x).rjust(3), end=' ')
...     # 注意前一行 'end' 的使用
...     print(repr(x*x*x).rjust(4))
...
 1   1    1
 2   4    8
 3   9   27
 4  16   64
 5  25  125
 6  36  216
 7  49  343
 8  64  512
 9  81  729
10 100 1000

>>> for x in range(1, 11):
...     print('{0:2d} {1:3d} {2:4d}'.format(x, x*x, x*x*x))
...
 1   1    1
 2   4    8
 3   9   27
 4  16   64
 5  25  125
 6  36  216
 7  49  343
 8  64  512
 9  81  729
10 100 1000
```

**注意：**在第一个例子中, 每列间的空格由 print() 添加。

 这个例子展示了字符串对象的 rjust() 方法, 它可以将字符串靠右, 并在左边填充空格。

 还有类似的方法, 如 ljust() 和 center()。 这些方法并不会写任何东西, 它们仅仅返回新的字符串。

 另一个方法 zfill(), 它会在数字的左边填充 0，如下所示：

```
>>> '12'.zfill(5)
'00012'
>>> '-3.14'.zfill(7)
'-003.14'
>>> '3.14159265359'.zfill(5)
'3.14159265359'
```

str.format() 的基本使用如下:

```
>>> print('We are the {} who say "{}!"'.format('knights', 'Ni'))
We are the knights who say "Ni!"
```

括号及其里面的字符 (称作格式化字段) 将会被 format() 中的参数替换。 

在括号中的数字用于指向传入对象在 format() 中的位置，如下所示：

```
>>> print('{0} and {1}'.format('spam', 'eggs'))
spam and eggs
>>> print('{1} and {0}'.format('spam', 'eggs'))
eggs and spam
```

 如果在 format() 中使用了关键字参数, 那么它们的值会指向使用该名字的参数。

```
>>> print('This {food} is {adjective}.'.format(
...       food='spam', adjective='absolutely horrible'))
This spam is absolutely horrible.
```

 位置及关键字参数可以任意的结合: 

```
>>> print('The story of {0}, {1}, and {other}.'.format('Bill', 'Manfred',
                                                       other='Georg'))
The story of Bill, Manfred, and Georg.
```

 '!a' (使用 ascii()), '!s' (使用 str()) 和 '!r' (使用 repr()) 可以用于在格式化某个值之前对其进行转化: 

```
>>> import math
>>> print('The value of PI is approximately {}.'.format(math.pi))
The value of PI is approximately 3.14159265359.
>>> print('The value of PI is approximately {!r}.'.format(math.pi))
The value of PI is approximately 3.141592653589793.
```

可选项 ':' 和格式标识符可以跟着字段名。 这就允许对值进行更好的格式化。 下面的例子将 Pi 保留到小数点后三位： 

```
>>> import math
>>> print('The value of PI is approximately {0:.3f}.'.format(math.pi))
The value of PI is approximately 3.142.
```

 在 ':' 后传入一个整数, 可以保证该域至少有这么多的宽度。 用于美化表格时很有用。 

```
>>> table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 7678}
>>> for name, phone in table.items():
...     print('{0:10} ==> {1:10d}'.format(name, phone))
...
Jack       ==>       4098
Dcab       ==>       7678
Sjoerd     ==>       4127
```

 如果你有一个很长的格式化字符串, 而你不想将它们分开, 那么在格式化时通过变量名而非位置会是很好的事情。 

最简单的就是传入一个字典, 然后使用方括号 '[]' 来访问键值 :

```
>>> table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
>>> print('Jack: {0[Jack]:d}; Sjoerd: {0[Sjoerd]:d}; '
          'Dcab: {0[Dcab]:d}'.format(table))
Jack: 4098; Sjoerd: 4127; Dcab: 8637678
```

 也可以通过在 table 变量前使用 '**' 来实现相同的功能：

```
>>> table = {'Sjoerd': 4127, 'Jack': 4098, 'Dcab': 8637678}
>>> print('Jack: {Jack:d}; Sjoerd: {Sjoerd:d}; Dcab: {Dcab:d}'.format(**table))
Jack: 4098; Sjoerd: 4127; Dcab: 8637678
```

------

## 旧式字符串格式化

 % 操作符也可以实现字符串格式化。 它将左边的参数作为类似 sprintf() 式的格式化字符串, 而将右边的代入, 然后返回格式化后的字符串. 例如: 

```
>>> import math
>>> print('The value of PI is approximately %5.3f.' % math.pi)
The value of PI is approximately 3.142.
```

 因为 str.format() 比较新的函数， 大多数的 Python 代码仍然使用 % 操作符。但是因为这种旧式的格式化最终会从该语言中移除, 应该更多的使用 str.format(). 

------

## 读和写文件 

 open() 将会返回一个 file 对象，基本语法格式如下: 

```
open(filename, mode)
```

实例:

```
>>> f = open('/tmp/workfile', 'w')
```

- 第一个参数为要打开的文件名。 

- 第二个参数描述文件如何使用的字符。 mode  可以是 'r' 如果文件只读, 'w' 只用于写 (如果存在同名文件则将被删除), 和 'a' 用于追加文件内容;  所写的任何数据都会被自动增加到末尾. 'r+' 同时用于读写。 mode 参数是可选的; 'r' 将是默认值。 

open() 将会返回一个 file 对象，基本语法格式如下: 

```
open(filename, mode)
```

- filename：包含了你要访问的文件名称的字符串值。
- mode：决定了打开文件的模式：只读，写入，追加等。所有可取值见如下的完全列表。这个参数是非强制的，默认文件访问模式为只读(r)。

不同模式打开文件的完全列表：

| 模式 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| r    | 以只读方式打开文件。文件的指针将会放在文件的开头。这是默认模式。 |
| rb   | 以二进制格式打开一个文件用于只读。文件指针将会放在文件的开头。 |
| r+   | 打开一个文件用于读写。文件指针将会放在文件的开头。           |
| rb+  | 以二进制格式打开一个文件用于读写。文件指针将会放在文件的开头。 |
| w    | 打开一个文件只用于写入。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。 |
| wb   | 以二进制格式打开一个文件只用于写入。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。 |
| w+   | 打开一个文件用于读写。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。 |
| wb+  | 以二进制格式打开一个文件用于读写。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。 |
| a    | 打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。 |
| ab   | 以二进制格式打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。 |
| a+   | 打开一个文件用于读写。如果该文件已存在，文件指针将会放在文件的结尾。文件打开时会是追加模式。如果该文件不存在，创建新文件用于读写。 |
| ab+  | 以二进制格式打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。如果该文件不存在，创建新文件用于读写。 |

下图很好的总结了这几种模式：

![img](https://www.runoob.com/wp-content/uploads/2013/11/2112205-861c05b2bdbc9c28.png)

|    模式    |  r   |  r+  |  w   |  w+  |  a   |  a+  |
| :--------: | :--: | :--: | :--: | :--: | :--: | :--: |
|     读     |  +   |  +   |      |  +   |      |  +   |
|     写     |      |  +   |  +   |  +   |  +   |  +   |
|    创建    |      |      |  +   |  +   |  +   |  +   |
|    覆盖    |      |      |  +   |  +   |      |      |
| 指针在开始 |  +   |  +   |  +   |  +   |      |      |
| 指针在结尾 |      |      |      |      |  +   |  +   |

以下实例将字符串写入到文件 foo.txt 中：

## 实例

\#!/usr/bin/python3

 \# 打开一个文件
 f = open("/tmp/foo.txt", "w")

 f.write( "Python 是一个非常好的语言。**\n**是的，的确非常好!!**\n**" )

 \# 关闭打开的文件
 f.close()

- 第一个参数为要打开的文件名。 
- 第二个参数描述文件如何使用的字符。 mode 可以是 'r' 如果文件只读, 'w' 只用于写 (如果存在同名文件则将被删除), 和  'a' 用于追加文件内容; 所写的任何数据都会被自动增加到末尾. 'r+' 同时用于读写。 mode 参数是可选的; 'r' 将是默认值。

此时打开文件 foo.txt,显示如下：

```
$ cat /tmp/foo.txt 
Python 是一个非常好的语言。
是的，的确非常好!!
```

### 文件对象的方法

 本节中剩下的例子假设已经创建了一个称为 f 的文件对象。 

### f.read()

 为了读取一个文件的内容，调用 f.read(size), 这将读取一定数目的数据, 然后作为字符串或字节对象返回。

size 是一个可选的数字类型的参数。 当 size 被忽略了或者为负, 那么该文件的所有内容都将被读取并且返回。

```
>>> f.read()
'This is the entire file.\n'
>>> f.read()
''
```

### f.readline()

 f.readline() 会从文件中读取单独的一行。换行符为 '\n'。f.readline() 如果返回一个空字符串, 说明已经已经读取到最后一行。

```
>>> f.readline()
'This is the first line of the file.\n'
>>> f.readline()
'Second line of the file\n'
>>> f.readline()
''
```

### f.readlines()

 f.readlines() 将返回该文件中包含的所有行。 

 如果设置可选参数 sizehint, 则读取指定长度的字节, 并且将这些字节按行分割。 

```
>>> f.readlines()
['This is the first line of the file.\n', 'Second line of the file\n']
```

 另一种方式是迭代一个文件对象然后读取每行: 

```
>>> for line in f:
...     print(line, end='')
...
This is the first line of the file.
Second line of the file
```

 这个方法很简单, 但是并没有提供一个很好的控制。 因为两者的处理机制不同, 最好不要混用。 

### f.write()

 f.write(string) 将 string 写入到文件中, 然后返回写入的字符数。 

```
>>> f.write('This is a test\n')
15
```

 如果要写入一些不是字符串的东西, 那么将需要先进行转换: 

```
>>> value = ('the answer', 42)
>>> s = str(value)
>>> f.write(s)
18
```

### f.tell()

 f.tell() 返回文件对象当前所处的位置, 它是从文件开头开始算起的字节数。 

### f.seek()

如果要改变文件当前的位置, 可以使用 f.seek(offset, from_what) 函数。

 from_what 的值, 如果是 0 表示开头, 如果是 1 表示当前位置, 2 表示文件的结尾，例如：



-  seek(x,0) ： 从起始位置即文件首行首字符开始移动 x 个字符
-  seek(x,1) ： 表示从当前位置往后移动x个字符
-  seek(-x,2)：表示从文件的结尾往前移动x个字符 

 from_what 值为默认为0，即文件开头。下面给出一个完整的例子：

```
>>> f = open('/tmp/workfile', 'rb+')
>>> f.write(b'0123456789abcdef')
16
>>> f.seek(5)     # 移动到文件的第六个字节
5
>>> f.read(1)
b'5'
>>> f.seek(-3, 2) # 移动到文件的倒数第三字节
13
>>> f.read(1)
b'd'
```

 

### f.close()

 在文本文件中 (那些打开文件的模式下没有 b 的), 只会相对于文件起始位置进行定位。



 当你处理完一个文件后, 调用 f.close() 来关闭文件并释放系统的资源，如果尝试再调用该文件，则会抛出异常。

```
>>> f.close()
>>> f.read()
Traceback (most recent call last):
  File "<stdin>", line 1, in ?
ValueError: I/O operation on closed file
<pre>
<p>
当处理一个文件对象时, 使用 with 关键字是非常好的方式。在结束后, 它会帮你正确的关闭文件。 而且写起来也比 try - finally 语句块要简短:</p>
<pre>
>>> with open('/tmp/workfile', 'r') as f:
...     read_data = f.read()
>>> f.closed
True
```

 文件对象还有其他方法, 如 isatty() 和 trucate(), 但这些通常比较少用。

------

## pickle 模块 

 python的pickle模块实现了基本的数据序列和反序列化。

通过pickle模块的序列化操作我们能够将程序中运行的对象信息保存到文件中去，永久存储。

通过pickle模块的反序列化操作，我们能够从文件中创建上一次程序保存的对象。 

基本接口： 

```
pickle.dump(obj, file, [,protocol])
```

 有了 pickle 这个对象, 就能对 file 以读取的形式打开: 

```
x = pickle.load(file)
```

**注解：**从 file 中读取一个字符串，并将它重构为原来的python对象。

**file:** 类文件对象，有read()和readline()接口。

实例1：

```
#使用pickle模块将数据对象保存到文件

import pickle

data1 = {'a': [1, 2.0, 3, 4+6j],
         'b': ('string', u'Unicode string'),
         'c': None}

selfref_list = [1, 2, 3]
selfref_list.append(selfref_list)

output = open('data.pkl', 'wb')

# Pickle dictionary using protocol 0.
pickle.dump(data1, output)

# Pickle the list using the highest protocol available.
pickle.dump(selfref_list, output, -1)

output.close()
```

实例2：

```
#使用pickle模块从文件中重构python对象

import pprint, pickle

pkl_file = open('data.pkl', 'rb')

data1 = pickle.load(pkl_file)
pprint.pprint(data1)

data2 = pickle.load(pkl_file)
pprint.pprint(data2)

pkl_file.close()
```

# Python3 File 方法

## Python3 File(文件) 方法

 file 对象使用 open 函数来创建，下表列出了 file 对象常用的函数： 

| 序号 | 方法及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [file.close()](https://www.w3cschool.cn/python3/python3-file-close.html)关闭文件。关闭后文件不能再进行读写操作。 |
| 2    | [file.flush()](https://www.w3cschool.cn/python3/python3-file-flush.html)刷新文件内部缓冲，直接把内部缓冲区的数据立刻写入文件, 而不是被动的等待输出缓冲区写入。 |
| 3    | [file.fileno()](https://www.w3cschool.cn/python3/python3-file-fileno.html) 返回一个整型的文件描述符(file descriptor FD 整型), 可以用在如os模块的read方法等一些底层操作上。 |
| 4    | [file.isatty()](https://www.w3cschool.cn/python3/python3-file-isatty.html)如果文件连接到一个终端设备返回 True，否则返回 False。 |
| 5    | [file.next()](https://www.w3cschool.cn/python3/python3-file-next.html)返回文件下一行。 |
| 6    | [file.read([size\])](https://www.w3cschool.cn/python3/python3-file-read.html)从文件读取指定的字节数，如果未给定或为负则读取所有。 |
| 7    | [file.readline([size\])](https://www.w3cschool.cn/python3/python3-file-readline.html)读取整行，包括 "\n" 字符。 |
| 8    | [file.readlines([sizehint\])](https://www.w3cschool.cn/python3/python3-file-readlines.html)读取所有行并返回列表，若给定sizeint>0，返回总和大约为sizeint字节的行, 实际读取值可能比sizeint较大, 因为需要填充缓冲区。 |
| 9    | [file.seek(offset[, whence\])](https://www.w3cschool.cn/python3/python3-file-seek.html)设置文件当前位置 |
| 10   | [file.tell()](https://www.w3cschool.cn/python3/python3-file-tell.html)返回文件当前位置。 |
| 11   | [file.truncate([size\])](https://www.w3cschool.cn/python3/python3-file-truncate.html)截取文件，截取的字节通过size指定，默认为当前文件位置。 |
| 12   | [file.write(str)](https://www.w3cschool.cn/python3/python3-file-write.html)将字符串写入文件，返回的是写入的字符长度。 |
| 13   | [file.writelines(sequence)](https://www.w3cschool.cn/python3/python3-file-writelines.html)向文件写入一个序列字符串列表，如果需要换行则要自己加入每行的换行符 |

# Python3 OS 文件/目录方法

## Python3 OS 文件/目录方法

**os** 模块提供了非常丰富的方法用来处理文件和目录。常用的方法如下表所示：

| 序号 | 方法及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | [os.access(path, mode)](https://www.w3cschool.cn/python3/python3-os-access.html) 检验权限模式 |
| 2    | [os.chdir(path)](https://www.w3cschool.cn/python3/python3-os-chdir.html) 改变当前工作目录 |
| 3    | [os.chflags(path, flags)](https://www.w3cschool.cn/python3/python3-os-chflags.html) 设置路径的标记为数字标记。 |
| 4    | [os.chmod(path, mode)](https://www.w3cschool.cn/python3/python3-os-chmod.html) 更改权限 |
| 5    | [os.chown(path, uid, gid)](https://www.w3cschool.cn/python3/python3-os-chown.html) 更改文件所有者 |
| 6    | [os.chroot(path)](https://www.w3cschool.cn/python3/python3-os-chroot.html) 改变当前进程的根目录 |
| 7    | [os.close(fd)](https://www.w3cschool.cn/python3/python3-os-close.html) 关闭文件描述符 fd |
| 8    | [os.closerange(fd_low, fd_high)](https://www.w3cschool.cn/python3/python3-os-closerange.html) 关闭所有文件描述符，从 fd_low (包含) 到 fd_high (不包含), 错误会忽略 |
| 9    | [os.dup(fd)](https://www.w3cschool.cn/python3/python3-os-dup.html) 复制文件描述符 fd |
| 10   | [os.dup2(fd, fd2)](https://www.w3cschool.cn/python3/python3-os-dup2.html) 将一个文件描述符 fd 复制到另一个 fd2 |
| 11   | [os.fchdir(fd)](https://www.w3cschool.cn/python3/python3-os-fchdir.html) 通过文件描述符改变当前工作目录 |
| 12   | [os.fchmod(fd, mode)](https://www.w3cschool.cn/python3/python3-os-fchmod.html) 改变一个文件的访问权限，该文件由参数fd指定，参数mode是Unix下的文件访问权限。 |
| 13   | [os.fchown(fd, uid, gid)](https://www.w3cschool.cn/python3/python3-os-fchown.html) 修改一个文件的所有权，这个函数修改一个文件的用户ID和用户组ID，该文件由文件描述符fd指定。 |
| 14   | [os.fdatasync(fd)](https://www.w3cschool.cn/python3/python3-os-fdatasync.html) 强制将文件写入磁盘，该文件由文件描述符fd指定，但是不强制更新文件的状态信息。 |
| 15   | [os.fdopen(fd[, mode[, bufsize\]])](https://www.w3cschool.cn/python3/python3-os-fdopen.html) 通过文件描述符 fd 创建一个文件对象，并返回这个文件对象 |
| 16   | [os.fpathconf(fd, name)](https://www.w3cschool.cn/python3/python3-os-fpathconf.html) 返回一个打开的文件的系统配置信息。name为检索的系统配置的值，它也许是一个定义系统值的字符串，这些名字在很多标准中指定（POSIX.1, Unix 95, Unix 98, 和其它）。 |
| 17   | [os.fstat(fd)](https://www.w3cschool.cn/python3/python3-os-fstat.html) 返回文件描述符fd的状态，像stat()。 |
| 18   | [os.fstatvfs(fd)](https://www.w3cschool.cn/python3/python3-os-fstatvfs.html) 返回包含文件描述符fd的文件的文件系统的信息，像 statvfs() |
| 19   | [os.fsync(fd)](https://www.w3cschool.cn/python3/python3-os-fsync.html) 强制将文件描述符为fd的文件写入硬盘。 |
| 20   | [os.ftruncate(fd, length)](https://www.w3cschool.cn/python3/python3-os-ftruncate.html) 裁剪文件描述符fd对应的文件, 所以它最大不能超过文件大小。 |
| 21   | [os.getcwd()](https://www.w3cschool.cn/python3/python3-os-getcwd.html) 返回当前工作目录 |
| 22   | [os.getcwdu()](https://www.w3cschool.cn/python3/python3-os-getcwdu.html) 返回一个当前工作目录的Unicode对象 |
| 23   | [os.isatty(fd)](https://www.w3cschool.cn/python3/python3-os-isatty.html) 如果文件描述符fd是打开的，同时与tty(-like)设备相连，则返回true, 否则False。 |
| 24   | [os.lchflags(path, flags)](https://www.w3cschool.cn/python3/python3-os-lchflags.html) 设置路径的标记为数字标记，类似 chflags()，但是没有软链接 |
| 25   | [os.lchmod(path, mode)](https://www.w3cschool.cn/python3/python3-os-lchmod.html) 修改连接文件权限 |
| 26   | [os.lchown(path, uid, gid)](https://www.w3cschool.cn/python3/python3-os-lchown.html) 更改文件所有者，类似 chown，但是不追踪链接。 |
| 27   | [os.link(src, dst)](https://www.w3cschool.cn/python3/python3-os-link.html) 创建硬链接，名为参数 dst，指向参数 src |
| 28   | [os.listdir(path)](https://www.w3cschool.cn/python3/python3-os-listdir.html) 返回path指定的文件夹包含的文件或文件夹的名字的列表。 |
| 29   | [os.lseek(fd, pos, how)](https://www.w3cschool.cn/python3/python3-os-lseek.html) 设置文件描述符 fd当前位置为pos, how方式修改: SEEK_SET 或者 0 设置从文件开始的计算的pos; SEEK_CUR或者 1 则从当前位置计算; os.SEEK_END或者2则从文件尾部开始. 在unix，Windows中有效 |
| 30   | [os.lstat(path)](https://www.w3cschool.cn/python3/python3-os-lstat.html) 像stat(),但是没有软链接 |
| 31   | [os.major(device)](https://www.w3cschool.cn/python3/python3-os-major.html) 从原始的设备号中提取设备major号码 (使用stat中的st_dev或者st_rdev field)。 |
| 32   | [os.makedev(major, minor)](https://www.w3cschool.cn/python3/python3-os-makedev.html) 以major和minor设备号组成一个原始设备号 |
| 33   | [os.makedirs(path[, mode\])](https://www.w3cschool.cn/python3/python3-os-makedirs.html) 递归文件夹创建函数。像mkdir(), 但创建的所有intermediate-level文件夹需要包含子文件夹。 |
| 34   | [os.minor(device)](https://www.w3cschool.cn/python3/python3-os-minor.html) 从原始的设备号中提取设备minor号码 (使用stat中的st_dev或者st_rdev field )。 |
| 35   | [os.mkdir(path[, mode\])](https://www.w3cschool.cn/python3/python3-os-mkdir.html) 以数字mode的mode创建一个名为path的文件夹.默认的 mode 是 0777 (八进制)。 |
| 36   | [os.mkfifo(path[, mode\])](https://www.w3cschool.cn/python3/python3-os-mkfifo.html) 创建命名管道，mode 为数字，默认为 0666 (八进制) |
| 37   | [os.mknod(filename[, mode=0600, device\])](https://www.w3cschool.cn/python3/python3-os-mknod.html) 创建一个名为filename文件系统节点（文件，设备特别文件或者命名pipe）。 |
| 38   | [os.open(file, flags[, mode\])](https://www.w3cschool.cn/python3/python3-os-open.html) 打开一个文件，并且设置需要的打开选项，mode参数是可选的 |
| 39   | [os.openpty()](https://www.w3cschool.cn/python3/python3-os-openpty.html) 打开一个新的伪终端对。返回 pty 和 tty的文件描述符。 |
| 40   | [os.pathconf(path, name)](https://www.w3cschool.cn/python3/python3-os-pathconf.html)  返回相关文件的系统配置信息。 |
| 41   | [os.pipe()](https://www.w3cschool.cn/python3/python3-os-pipe.html) 创建一个管道. 返回一对文件描述符(r, w) 分别为读和写 |
| 42   | [os.popen(command[, mode[, bufsize\]])](https://www.w3cschool.cn/python3/python3-os-popen.html) 从一个 command 打开一个管道 |
| 43   | [os.read(fd, n)](https://www.w3cschool.cn/python3/python3-os-read.html) 从文件描述符 fd 中读取最多 n 个字节，返回包含读取字节的字符串，文件描述符 fd对应文件已达到结尾, 返回一个空字符串。 |
| 44   | [os.readlink(path)](https://www.w3cschool.cn/python3/python3-os-readlink.html) 返回软链接所指向的文件 |
| 45   | [os.remove(path)](https://www.w3cschool.cn/python3/python3-os-remove.html) 删除路径为path的文件。如果path 是一个文件夹，将抛出OSError; 查看下面的rmdir()删除一个 directory。 |
| 46   | [os.removedirs(path)](https://www.w3cschool.cn/python3/python3-os-removedirs.html) 递归删除目录。 |
| 47   | [os.rename(src, dst)](https://www.w3cschool.cn/python3/python3-os-rename.html) 重命名文件或目录，从 src 到 dst |
| 48   | [os.renames(old, new)](https://www.w3cschool.cn/python3/python3-os-renames.html) 递归地对目录进行更名，也可以对文件进行更名。 |
| 49   | [os.rmdir(path)](https://www.w3cschool.cn/python3/python3-os-rmdir.html) 删除path指定的空目录，如果目录非空，则抛出一个OSError异常。 |
| 50   | [os.stat(path)](https://www.w3cschool.cn/python3/python3-os-stat.html) 获取path指定的路径的信息，功能等同于C API中的stat()系统调用。 |
| 51   | [os.stat_float_times([newvalue\])](https://www.w3cschool.cn/python3/python3-os-stat_float_times.html) 决定stat_result是否以float对象显示时间戳 |
| 52   | [os.statvfs(path)](https://www.w3cschool.cn/python3/python3-os-statvfs.html) 获取指定路径的文件系统统计信息 |
| 53   | [os.symlink(src, dst)](https://www.w3cschool.cn/python3/python3-os-symlink.html) 创建一个软链接 |
| 54   | [os.tcgetpgrp(fd)](https://www.w3cschool.cn/python3/python3-os-tcgetpgrp.html) 返回与终端fd（一个由os.open()返回的打开的文件描述符）关联的进程组 |
| 55   | [os.tcsetpgrp(fd, pg)](https://www.w3cschool.cn/python3/python3-os-tcsetpgrp.html) 设置与终端fd（一个由os.open()返回的打开的文件描述符）关联的进程组为pg。 |
| 56   | [os.tempnam([dir[, prefix\]])](https://www.w3cschool.cn/python3/python3-os-tempnam.html) 返回唯一的路径名用于创建临时文件。 |
| 57   | [os.tmpfile()](https://www.w3cschool.cn/python3/python3-os-tmpfile.html) 返回一个打开的模式为(w+b)的文件对象 .这文件对象没有文件夹入口，没有文件描述符，将会自动删除。 |
| 58   | [os.tmpnam()](https://www.w3cschool.cn/python3/python3-os-tmpnam.html) 为创建一个临时文件返回一个唯一的路径 |
| 59   | [os.ttyname(fd)](https://www.w3cschool.cn/python3/python3-os-ttyname.html) 返回一个字符串，它表示与文件描述符fd 关联的终端设备。如果fd 没有与终端设备关联，则引发一个异常。 |
| 60   | [os.unlink(path)](https://www.w3cschool.cn/python3/python3-os-unlink.html) 删除文件路径 |
| 61   | [os.utime(path, times)](https://www.w3cschool.cn/python3/python3-os-utime.html) 返回指定的path文件的访问和修改的时间。 |
| 62   | [os.walk(top[, topdown=True[, onerror=None[, followlinks=False\]]])](https://www.w3cschool.cn/python3/python3-os-walk.html) 输出在文件夹中的文件名通过在树中游走，向上或者向下。 |
| 63   | [os.write(fd, str)](https://www.w3cschool.cn/python3/python3-os-write.html) 写入字符串到文件描述符 fd中. 返回实际写入的字符串长度 |

# Python3 命名空间和作用域

## 命名空间

先看看官方文档的一段话：

> A namespace is a mapping from names to objects.Most namespaces are currently implemented as Python dictionaries。

命名空间(Namespace)是从名称到对象的映射，大部分的命名空间都是通过 Python 字典来实现的。

命名空间提供了在项目中避免名字冲突的一种方法。各个命名空间是独立的，没有任何关系的，所以一个命名空间中不能有重名，但不同的命名空间是可以重名而没有任何影响。

我们举一个计算机系统中的例子，一个文件夹(目录)中可以包含多个文件夹，每个文件夹中不能有相同的文件名，但不同文件夹中的文件可以重名。

![img](https://www.runoob.com/wp-content/uploads/2019/09/0129A8E9-30FE-431D-8C48-399EA4841E9D.jpg)

一般有三种命名空间：

- **内置名称（built-in names**）， Python 语言内置的名称，比如函数名 abs、char 和异常名称 BaseException、Exception 等等。
- **全局名称（global names）**，模块中定义的名称，记录了模块的变量，包括函数、类、其它导入的模块、模块级的变量和常量。
- **局部名称（local names）**，函数中定义的名称，记录了函数的变量，包括函数的参数和局部定义的变量。（类中定义的也是）

![img](https://www.runoob.com/wp-content/uploads/2014/05/types_namespace-1.png)

命名空间查找顺序: 

假设我们要使用变量 runoob，则 Python 的查找顺序为：**局部的命名空间去 -> 全局命名空间 -> 内置命名空间**。

如果找不到变量 runoob，它将放弃查找并引发一个 NameError 异常:

```
NameError: name 'runoob' is not defined。
```

命名空间的生命周期：

命名空间的生命周期取决于对象的作用域，如果对象执行完成，则该命名空间的生命周期就结束。

因此，我们无法从外部命名空间访问内部命名空间的对象。

## 实例

\# var1 是全局名称
 var1 = 5
 **def** some_func(): 

   \# var2 是局部名称
   var2 = 6
   **def** some_inner_func(): 

     \# var3 是内嵌的局部名称
     var3 = 7

如下图所示，相同的对象名称可以存在于多个命名空间中。

![img](https://www.runoob.com/wp-content/uploads/2014/05/namespaces.png)

------

## 作用域

> A scope is a textual region of a Python program where a namespace is  directly accessible. "Directly accessible" here means that an  unqualified reference to a name attempts to find the name in the  namespace.

作用域就是一个 Python 程序可以直接访问命名空间的正文区域。

在一个 python 程序中，直接访问一个变量，会从内到外依次访问所有的作用域直到找到，否则会报未定义的错误。

Python 中，程序的变量并不是在哪个位置都可以访问的，访问权限决定于这个变量是在哪里赋值的。

变量的作用域决定了在哪一部分程序可以访问哪个特定的变量名称。Python 的作用域一共有4种，分别是：

有四种作用域：

- **L（Local）**：最内层，包含局部变量，比如一个函数/方法内部。
- **E（Enclosing）**：包含了非局部(non-local)也非全局(non-global)的变量。比如两个嵌套函数，一个函数（或类） A 里面又包含了一个函数 B ，那么对于 B 中的名称来说 A 中的作用域就为 nonlocal。
- **G（Global）**：当前脚本的最外层，比如当前模块的全局变量。
- **B（Built-in）**： 包含了内建的变量/关键字等，最后被搜索。

规则顺序： **L –> E –> G –> B**。

在局部找不到，便会去局部外的局部找（例如闭包），再找不到就会去全局找，再者去内置中找。

![img](https://www.runoob.com/wp-content/uploads/2014/05/1418490-20180906153626089-1835444372.png)

```
g_count = 0  # 全局作用域
def outer():
    o_count = 1  # 闭包函数外的函数中
    def inner():
        i_count = 2  # 局部作用域
```

内置作用域是通过一个名为 builtin 的标准模块来实现的，但是这个变量名自身并没有放入内置作用域内，所以必须导入这个文件才能够使用它。在Python3.0中，可以使用以下的代码来查看到底预定义了哪些变量:

```
>>> import builtins
>>> dir(builtins)
```

Python 中只有模块（module），类（class）以及函数（def、lambda）才会引入新的作用域，其它的代码块（如  if/elif/else/、try/except、for/while等）是不会引入新的作用域的，也就是说这些语句内定义的变量，外部也可以访问，如下代码：

```
>>> if True:
...  msg = 'I am from Runoob'
... 
>>> msg
'I am from Runoob'
>>> 
```

实例中 msg 变量定义在 if 语句块中，但外部还是可以访问的。

如果将 msg 定义在函数中，则它就是局部变量，外部不能访问：

```
>>> def test():
...     msg_inner = 'I am from Runoob'
... 
>>> msg_inner
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'msg_inner' is not defined
>>> 
```

从报错的信息上看，说明了 msg_inner 未定义，无法使用，因为它是局部变量，只有在函数内可以使用。

### 全局变量和局部变量

定义在函数内部的变量拥有一个局部作用域，定义在函数外的拥有全局作用域。

局部变量只能在其被声明的函数内部访问，而全局变量可以在整个程序范围内访问。调用函数时，所有在函数内声明的变量名称都将被加入到作用域中。如下实例：

## 实例(Python 3.0+)

\#!/usr/bin/python3  total = 0 # 这是一个全局变量 # 可写函数说明 def sum( arg1, arg2 ):    #返回2个参数的和."    total = arg1 + arg2 # total在这里是局部变量.    print ("函数内是局部变量 : ", total)    return total  #调用sum函数 sum( 10, 20 ) print ("函数外是全局变量 : ", total)

以上实例输出结果：

```
函数内是局部变量 :  30
函数外是全局变量 :  0
```

### global 和 nonlocal关键字 

当内部作用域想修改外部作用域的变量时，就要用到 global 和 nonlocal 关键字了。

以下实例修改全局变量 num：

## 实例(Python 3.0+)

\#!/usr/bin/python3  num = 1 def fun1():    global num  # 需要使用 global 关键字声明    print(num)     num = 123    print(num) fun1() print(num)

以上实例输出结果：

```
1
123
123
```

如果要修改嵌套作用域（enclosing 作用域，外层非全局作用域）中的变量则需要 nonlocal 关键字了，如下实例：

## 实例(Python 3.0+)

\#!/usr/bin/python3  def outer():    num = 10    def inner():        nonlocal num   # nonlocal关键字声明        num = 100        print(num)    inner()    print(num) outer()

以上实例输出结果：

```
100
100
```

另外有一种特殊情况，假设下面这段代码被运行：

## 实例(Python 3.0+)

\#!/usr/bin/python3  a = 10 def test():    a = a + 1    print(a) test()

以上程序执行，报错信息如下：

```
Traceback (most recent call last):
  File "test.py", line 7, in <module>
    test()
  File "test.py", line 5, in test
    a = a + 1
UnboundLocalError: local variable 'a' referenced before assignment
```

错误信息为局部作用域引用错误，因为 test 函数中的 a 使用的是局部，未定义，无法修改。

修改 a 为全局变量：

## 实例

\#!/usr/bin/python3  a = 10 def test():    global a    a = a + 1    print(a) test()

执行输出结果为：

11

也可以通过函数参数传递：

## 实例(Python 3.0+)

\#!/usr/bin/python3  a = 10 def test(a):    a = a + 1    print(a) test(a)

执行输出结果为：

11

​			

# Python3 面向对象

Python从设计之初就已经是一门面向对象的语言，正因为如此，在Python中创建一个类和对象是很容易的。本章节我们将详细介绍Python的面向对象编程。

如果你以前没有接触过面向对象的编程语言，那你可能需要先了解一些面向对象语言的一些基本特征，在头脑里头形成一个基本的面向对象的概念，这样有助于你更容易的学习Python的面向对象编程。

接下来我们先来简单的了解下面向对象的一些基本特征。

------

## 面向对象技术简介

- **类(Class):** 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。
- **类变量：**类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。
- **数据成员：**类变量或者实例变量用于处理类及其实例对象的相关的数据。
- **方法重写：**如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
- **局部变量：**定义在方法中的变量，只作用于当前实例的类。
- **实例变量：**在类的声明中，属性是用变量来表示的。这种变量就称为实例变量，是在类声明的内部但是在类的其他成员方法之外声明的。
- **继承：**即一个派生类（derived class）继承基类（base  class）的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。例如，有这样一个设计：一个Dog类型的对象派生自Animal类，这是模拟"是一个（is-a）"关系（例图，Dog是一个Animal）。
- **实例化：**创建一个类的实例，类的具体对象。
- **方法：**类中定义的函数。
- **对象：**通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。

和其它编程语言相比，Python 在尽可能不增加新的语法和语义的情况下加入了类机制。

Python中的类提供了面向对象编程的所有基本功能：类的继承机制允许多个基类，派生类可以覆盖基类中的任何方法，方法中可以调用基类中的同名方法。

对象可以包含任意数量和类型的数据。

## 类定义

语法格式如下：

```
class ClassName:
    <statement-1>
    .
    .
    .
    <statement-N>
```

类实例化后，可以使用其属性，实际上，创建一个类之后，可以通过类名访问其属性。

## 类对象

类对象支持两种操作：属性引用和实例化。

属性引用使用和 Python 中所有的属性引用一样的标准语法：**obj.name**。

类对象创建后，类命名空间中所有的命名都是有效属性名。所以如果类定义是这样:

```
#!/usr/bin/python3

class MyClass:
    """一个简单的类实例"""
    i = 12345
    def f(self):
        return 'hello world'

# 实例化类
x = MyClass()

# 访问类的属性和方法
print("MyClass 类的属性 i 为：", x.i)
print("MyClass 类的方法 f 输出为：", x.f())
```

实例化类：

```
# 实例化类
x = MyClass()
# 访问类的属性和方法
```

以上创建了一个新的类实例并将该对象赋给局部变量 x，x 为空的对象。

执行以上程序输出结果为：

```
MyClass 类的属性 i 为： 12345
MyClass 类的方法 f 输出为： hello world
```

------

很多类都倾向于将对象创建为有初始状态的。因此类可能会定义一个名为 __init__() 的特殊方法（构造方法），像下面这样：

```
def __init__(self):
    self.data = []
```

类定义了 __init__() 方法的话，类的实例化操作会自动调用 __init__() 方法。所以在下例中，可以这样创建一个新的实例:

```
x = MyClass()
```

当然， __init__() 方法可以有参数，参数通过 __init__() 传递到类的实例化操作上。例如:

```
>>> class Complex:
...     def __init__(self, realpart, imagpart):
...         self.r = realpart
...         self.i = imagpart
...
>>> x = Complex(3.0, -4.5)
>>> x.r, x.i
(3.0, -4.5)
```

## 类的方法

在类地内部，使用def关键字可以为类定义一个方法，与一般函数定义不同，类方法必须包含参数self,且为第一个参数:

```
#!/usr/bin/python3

#类定义
class people:
    #定义基本属性
    name = ''
    age = 0
    #定义私有属性,私有属性在类外部无法直接进行访问
    __weight = 0
    #定义构造方法
    def __init__(self,n,a,w):
        self.name = n
        self.age = a
        self.__weight = w
    def speak(self):
        print("%s 说: 我 %d 岁。" %(self.name,self.age))

# 实例化类
p = people('W3Cschool',10,30)
p.speak()
```

执行以上程序输出结果为：

```
W3Cschool 说: 我 10 岁。
```

------

## 继承

Python 同样支持类的继承，如果一种语言不支持继承，类就没有什么意义。派生类的定义如下所示:

```
class DerivedClassName(BaseClassName1):
    <statement-1>
    .
    .
    .
    <statement-N>
```

需要注意圆括号中基类的顺序，若是基类中有相同的方法名，而在子类使用时未指定，python从左至右搜索 即方法在子类中未找到时，从左到右查找基类中是否包含方法。

BaseClassName（示例中的基类名）必须与派生类定义在一个作用域内。除了类，还可以用表达式，基类定义在另一个模块中时这一点非常有用:

```
class DerivedClassName(modname.BaseClassName):
```

### 实例

```
#!/usr/bin/python3

#类定义
class people:
    #定义基本属性
    name = ''
    age = 0
    #定义私有属性,私有属性在类外部无法直接进行访问
    __weight = 0
    #定义构造方法
    def __init__(self,n,a,w):
        self.name = n
        self.age = a
        self.__weight = w
    def speak(self):
        print("%s 说: 我 %d 岁。" %(self.name,self.age))

#单继承示例
class student(people):
    grade = ''
    def __init__(self,n,a,w,g):
        #调用父类的构函
        people.__init__(self,n,a,w)
        self.grade = g
    #覆写父类的方法
    def speak(self):
        print("%s 说: 我 %d 岁了，我在读 %d 年级"%(self.name,self.age,self.grade))



s = student('ken',10,60,3)
s.speak()
```

执行以上程序输出结果为：

```
ken 说: 我 10 岁了，我在读 3 年级
```

------

## 多继承

Python同样有限的支持多继承形式。多继承的类定义形如下例:

```
class DerivedClassName(Base1, Base2, Base3):
    <statement-1>
    .
    .
    .
    <statement-N>
```

需要注意圆括号中父类的顺序，若是父类中有相同的方法名，而在子类使用时未指定，python从左至右搜索 即方法在子类中未找到时，从左到右查找父类中是否包含方法。

```
#!/usr/bin/python3

#类定义
class people:
    #定义基本属性
    name = ''
    age = 0
    #定义私有属性,私有属性在类外部无法直接进行访问
    __weight = 0
    #定义构造方法
    def __init__(self,n,a,w):
        self.name = n
        self.age = a
        self.__weight = w
    def speak(self):
        print("%s 说: 我 %d 岁。" %(self.name,self.age))

#单继承示例
class student(people):
    grade = ''
    def __init__(self,n,a,w,g):
        #调用父类的构函
        people.__init__(self,n,a,w)
        self.grade = g
    #覆写父类的方法
    def speak(self):
        print("%s 说: 我 %d 岁了，我在读 %d 年级"%(self.name,self.age,self.grade))

#另一个类，多重继承之前的准备
class speaker():
    topic = ''
    name = ''
    def __init__(self,n,t):
        self.name = n
        self.topic = t
    def speak(self):
        print("我叫 %s，我是一个演说家，我演讲的主题是 %s"%(self.name,self.topic))

#多重继承
class sample(speaker,student):
    a =''
    def __init__(self,n,a,w,g,t):
        student.__init__(self,n,a,w,g)
        speaker.__init__(self,n,t)

test = sample("Tim",25,80,4,"Python")
test.speak()   #方法名同，默认调用的是在括号中排前地父类的方法
```

执行以上程序输出结果为：

```
我叫 Tim，我是一个演说家，我演讲的主题是 Python
```

------

## 方法重写

如果你的父类方法的功能不能满足你的需求，你可以在子类重写你父类的方法，实例如下：

```
#!/usr/bin/python3

class Parent:        # 定义父类
   def myMethod(self):
      print ('调用父类方法')

class Child(Parent): # 定义子类
   def myMethod(self):
      print ('调用子类方法')

c = Child()          # 子类实例
c.myMethod()         # 子类调用重写方法
```

执行以上程序输出结果为：

```
调用子类方法
```

------

## 类属性与方法

### 类的私有属性

**__private_attrs**：两个下划线开头，声明该属性为私有，不能在类地外部被使用或直接访问。在类内部的方法中使用时**self.__private_attrs**。

### 类的方法

在类地内部，使用def关键字可以为类定义一个方法，与一般函数定义不同，类方法必须包含参数self,且为第一个参数

### 类的私有方法

**__private_method**：两个下划线开头，声明该方法为私有方法，不能在类地外部调用。在类的内部调用 **slef.__private_methods**。

实例如下：

```
#!/usr/bin/python3

class JustCounter:
    __secretCount = 0  # 私有变量
    publicCount = 0    # 公开变量

    def count(self):
        self.__secretCount += 1
        self.publicCount += 1
        print (self.__secretCount)

counter = JustCounter()
counter.count()
counter.count()
print (counter.publicCount)
print (counter.__secretCount)  # 报错，实例不能访问私有变量
```

执行以上程序输出结果为：

```
1
2
2
Traceback (most recent call last):
  File "test.py", line 16, in <module>
    print (counter.__secretCount)  # 报错，实例不能访问私有变量
AttributeError: 'JustCounter' object has no attribute '__secretCount'
```

### 类的专有方法：

- **__init__ :** 构造函数，在生成对象时调用
- **__del__ :** 析构函数，释放对象时使用
- **__repr__ :** 打印，转换
- **__setitem__ :** 按照索引赋值
- **__getitem__:** 按照索引获取值
- **__len__:** 获得长度
- **__cmp__:** 比较运算
- **__call__:** 函数调用
- **__add__:** 加运算
- **__sub__:** 减运算
- **__mul__:** 乘运算
- **__div__:** 除运算
- **__mod__:** 求余运算
- **__pow__:** 乘方

### 运算符重载

Python同样支持运算符重载，我么可以对类的专有方法进行重载，实例如下：

```
#!/usr/bin/python3

class Vector:
   def __init__(self, a, b):
      self.a = a
      self.b = b

   def __str__(self):
      return 'Vector (%d, %d)' % (self.a, self.b)
   
   def __add__(self,other):
      return Vector(self.a + other.a, self.b + other.b)

v1 = Vector(2,10)
v2 = Vector(5,-2)
print (v1 + v2)
```

以上代码执行结果如下所示:

```
Vector(7,8)
```

# Python3 标准库概览

## Python 标准库概览

## 操作系统接口

os模块提供了不少与操作系统相关联的函数。

```
>>> import os
>>> os.getcwd()      # 返回当前的工作目录
'C:\\Python34'
>>> os.chdir('/server/accesslogs')   # 修改当前的工作目录
>>> os.system('mkdir today')   # 执行系统命令 mkdir 
0
```

建议使用 "import os" 风格而非 "from os import *"。这样可以保证随操作系统不同而有所变化的 os.open() 不会覆盖内置函数 open()。 

在使用 os 这样的大型模块时内置的 dir() 和 help() 函数非常有用:

```
>>> import os
>>> dir(os)
<returns a list of all module functions>
>>> help(os)
<returns an extensive manual page created from the module's docstrings>
```

针对日常的文件和目录管理任务，:mod:shutil 模块提供了一个易于使用的高级接口:

```
>>> import shutil
>>> shutil.copyfile('data.db', 'archive.db')
>>> shutil.move('/build/executables', 'installdir')
```

------

##  文件通配符

glob模块提供了一个函数用于从目录通配符搜索中生成文件列表: 

```
>>> import glob
>>> glob.glob('*.py')
['primes.py', 'random.py', 'quote.py']
```

------

## 命令行参数

通用工具脚本经常调用命令行参数。这些命令行参数以链表形式存储于 sys 模块的 argv 变量。例如在命令行中执行 "python demo.py one two three" 后可以得到以下输出结果: 

```
>>> import sys
>>> print(sys.argv)
['demo.py', 'one', 'two', 'three']
```

------

## 错误输出重定向和程序终止

sys 还有 stdin，stdout 和 stderr 属性，即使在 stdout 被重定向时，后者也可以用于显示警告和错误信息。

```
>>> sys.stderr.write('Warning, log file not found starting a new one\n')
Warning, log file not found starting a new one
```

大多脚本的定向终止都使用 "sys.exit()"。

------

## 字符串正则匹配

re模块为高级字符串处理提供了正则表达式工具。对于复杂的匹配和处理，正则表达式提供了简洁、优化的解决方案: 

```
>>> import re
>>> re.findall(r'\bf[a-z]*', 'which foot or hand fell fastest')
['foot', 'fell', 'fastest']
>>> re.sub(r'(\b[a-z]+) \1', r'\1', 'cat in the the hat')
'cat in the hat'
```

如果只需要简单的功能，应该首先考虑字符串方法，因为它们非常简单，易于阅读和调试: 

```
>>> 'tea for too'.replace('too', 'two')
'tea for two'
```

------

## 数学 

math模块为浮点运算提供了对底层C函数库的访问: 

```
>>> import math
>>> math.cos(math.pi / 4)
0.70710678118654757
>>> math.log(1024, 2)
10.0
```

random提供了生成随机数的工具。

```
>>> import random
>>> random.choice(['apple', 'pear', 'banana'])
'apple'
>>> random.sample(range(100), 10)   # sampling without replacement
[30, 83, 16, 4, 8, 81, 41, 50, 18, 33]
>>> random.random()    # random float
0.17970987693706186
>>> random.randrange(6)    # random integer chosen from range(6)
4
```

------

## 访问 互联网

有几个模块用于访问互联网以及处理网络通信协议。其中最简单的两个是用于处理从 urls 接收的数据的 urllib.request 以及用于发送电子邮件的 smtplib: 

```
>>> from urllib.request import urlopen
>>> for line in urlopen('http://tycho.usno.navy.mil/cgi-bin/timer.pl'):
...     line = line.decode('utf-8')  # Decoding the binary data to text.
...     if 'EST' in line or 'EDT' in line:  # look for Eastern Time
...         print(line)

<BR>Nov. 25, 09:43:32 PM EST

>>> import smtplib
>>> server = smtplib.SMTP('localhost')
>>> server.sendmail('soothsayer@example.org', 'jcaesar@example.org',
... """To: jcaesar@example.org
... From: soothsayer@example.org
...
... Beware the Ides of March.
... """)
>>> server.quit()
```

注意第二个例子需要本地有一个在运行的邮件服务器。

------

## 日期和时间

datetime模块为日期和时间处理同时提供了简单和复杂的方法。

支持日期和时间算法的同时，实现的重点放在更有效的处理和格式化输出。 

该模块还支持时区处理: 

```
>>> # dates are easily constructed and formatted
>>> from datetime import date
>>> now = date.today()
>>> now
datetime.date(2003, 12, 2)
>>> now.strftime("%m-%d-%y. %d %b %Y is a %A on the %d day of %B.")
'12-02-03. 02 Dec 2003 is a Tuesday on the 02 day of December.'

>>> # dates support calendar arithmetic
>>> birthday = date(1964, 7, 31)
>>> age = now - birthday
>>> age.days
14368
```

------

## 数据压缩

以下模块直接支持通用的数据打包和压缩格式：zlib，gzip，bz2，zipfile，以及 tarfile。

```
>>> import zlib
>>> s = b'witch which has which witches wrist watch'
>>> len(s)
41
>>> t = zlib.compress(s)
>>> len(t)
37
>>> zlib.decompress(t)
b'witch which has which witches wrist watch'
>>> zlib.crc32(s)
226805979
```

------

## 性能度量

有些用户对了解解决同一问题的不同方法之间的性能差异很感兴趣。Python 提供了一个度量工具，为这些问题提供了直接答案。

例如，使用元组封装和拆封来交换元素看起来要比使用传统的方法要诱人的多,timeit 证明了现代的方法更快一些。

```
>>> from timeit import Timer
>>> Timer('t=a; a=b; b=t', 'a=1; b=2').timeit()
0.57535828626024577
>>> Timer('a,b = b,a', 'a=1; b=2').timeit()
0.54962537085770791
```

相对于 timeit 的细粒度，:mod:profile 和 pstats 模块提供了针对更大代码块的时间度量工具。

------

## 测试模块

开发高质量软件的方法之一是为每一个函数开发测试代码，并且在开发过程中经常进行测试 

doctest模块提供了一个工具，扫描模块并根据程序中内嵌的文档字符串执行测试。 

测试构造如同简单的将它的输出结果剪切并粘贴到文档字符串中。 

通过用户提供的例子，它强化了文档，允许 doctest 模块确认代码的结果是否与文档一致: 

```
def average(values):
    """Computes the arithmetic mean of a list of numbers.

    >>> print(average([20, 30, 70]))
    40.0
    """
    return sum(values) / len(values)

import doctest
doctest.testmod()   # 自动验证嵌入测试
```

unittest模块不像 doctest模块那么容易使用，不过它可以在一个独立的文件里提供一个更全面的测试集: 

```
import unittest

class TestStatisticalFunctions(unittest.TestCase):

    def test_average(self):
        self.assertEqual(average([20, 30, 70]), 40.0)
        self.assertEqual(round(average([1, 5, 7]), 1), 4.3)
        self.assertRaises(ZeroDivisionError, average, [])
        self.assertRaises(TypeError, average, 20, 30, 70)

unittest.main() # Calling from the command line invokes all tests
```

 Python3 正则表达式

正则表达式是一个特殊的字符序列，它能帮助你方便的检查一个字符串是否与某种模式匹配。

Python 自1.5版本起增加了re 模块，它提供 Perl 风格的正则表达式模式。

re 模块使 Python 语言拥有全部的正则表达式功能。 

compile 函数根据一个模式字符串和可选的标志参数生成一个正则表达式对象。该对象拥有一系列方法用于正则表达式匹配和替换。 

re 模块也提供了与这些方法功能完全一致的函数，这些函数使用一个模式字符串做为它们的第一个参数。

本章节主要介绍Python中常用的正则表达式处理函数。

------

## 正则表达式

## re.match函数

re.match 尝试从字符串的起始位置匹配一个模式，如果不是起始位置匹配成功的话，match()就返回none。

**函数语法**：

```
re.match(pattern, string, flags=0)
```

函数参数说明：

| 参数    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| pattern | 匹配的正则表达式                                             |
| string  | 要匹配的字符串。                                             |
| flags   | 标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。 |

匹配成功re.match方法返回一个匹配的对象，否则返回None。

我们可以使用group(num) 或  groups() 匹配对象函数来获取匹配表达式。

| 匹配对象方法 | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| group(num=0) | 匹配的整个表达式的字符串，group() 可以一次输入多个组号，在这种情况下它将返回一个包含那些组所对应值的元组。 |
| groups()     | 返回一个包含所有小组字符串的元组，从 1 到 所含的小组号。     |

实例 1：

```
#!/usr/bin/python

import re
print(re.match('www', 'www.w3cschool.cn').span())  # 在起始位置匹配
print(re.match('cn', 'www.w3cschool.cn'))         # 不在起始位置匹配
```

以上实例运行输出结果为：

```
(0, 3)
None
```

实例 2：

```
#!/usr/bin/python3
import re

line = "Cats are smarter than dogs"

matchObj = re.match( r'(.*) are (.*?) .*', line, re.M|re.I)

if matchObj:
   print ("matchObj.group() : ", matchObj.group())
   print ("matchObj.group(1) : ", matchObj.group(1))
   print ("matchObj.group(2) : ", matchObj.group(2))
else:
   print ("No match!!")
```

以上实例执行结果如下：

```
matchObj.group() :  Cats are smarter than dogs
matchObj.group(1) :  Cats
matchObj.group(2) :  smarter
```

------

## re.search方法

re.search 扫描整个字符串并返回第一个成功的匹配。

函数语法：

```
re.search(pattern, string, flags=0)
```

函数参数说明：

| 参数    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| pattern | 匹配的正则表达式                                             |
| string  | 要匹配的字符串。                                             |
| flags   | 标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。 |

匹配成功re.search方法返回一个匹配的对象，否则返回None。

我们可以使用group(num) 或  groups() 匹配对象函数来获取匹配表达式。

| 匹配对象方法 | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| group(num=0) | 匹配的整个表达式的字符串，group() 可以一次输入多个组号，在这种情况下它将返回一个包含那些组所对应值的元组。 |
| groups()     | 返回一个包含所有小组字符串的元组，从 1 到 所含的小组号。     |

实例 1：

```
#!/usr/bin/python3

import re

print(re.search('www', 'www.w3cschool.cn').span())  # 在起始位置匹配
print(re.search('cn', 'www.w3cschool.cn').span())         # 不在起始位置匹配
```

以上实例运行输出结果为：

```
(0, 3)
(14, 16)
```

实例 2：

```
#!/usr/bin/python3

import re

line = "Cats are smarter than dogs";

searchObj = re.search( r'(.*) are (.*?) .*', line, re.M|re.I)

if searchObj:
   print ("searchObj.group() : ", searchObj.group())
   print ("searchObj.group(1) : ", searchObj.group(1))
   print ("searchObj.group(2) : ", searchObj.group(2))
else:
   print ("Nothing found!!")
```

 以上实例执行结果如下： 

```
searchObj.group() :  Cats are smarter than dogs
searchObj.group(1) :  Cats
searchObj.group(2) :  smarter
```

------

## re.match与re.search的区别

re.match只匹配字符串的开始，如果字符串开始不符合正则表达式，则匹配失败，函数返回None；而re.search匹配整个字符串，直到找到一个匹配。

实例：

```
#!/usr/bin/python3

import re

line = "Cats are smarter than dogs";

matchObj = re.match( r'dogs', line, re.M|re.I)
if matchObj:
   print ("match --> matchObj.group() : ", matchObj.group())
else:
   print ("No match!!")

matchObj = re.search( r'dogs', line, re.M|re.I)
if matchObj:
   print ("search --> matchObj.group() : ", matchObj.group())
else:
   print ("No match!!")
```

 以上实例运行结果如下： 

```
No match!!
search --> matchObj.group() :  dogs
```

------

## 检索和替换

Python 的re模块提供了re.sub用于替换字符串中的匹配项。

语法：

```
re.sub(pattern, repl, string, max=0)
```

返回的字符串是在字符串中用 RE 最左边不重复的匹配来替换。如果模式没有发现，字符将被没有改变地返回。

可选参数 count 是模式匹配后替换的最大次数；count 必须是非负整数。缺省值是 0 表示替换所有的匹配。

实例：

```
#!/usr/bin/python3

import re

phone = "2004-959-559 # 这是一个电话号码"

# 删除注释
num = re.sub(r'#.*$', "", phone)
print ("电话号码 : ", num)

# 移除非数字的内容
num = re.sub(r'\D', "", phone)
print ("电话号码 : ", num)
```

 以上实例执行结果如下： 

```
电话号码 :  2004-959-559 
电话号码 :  2004959559
```

------

正则表达式是一个特殊的字符序列，它能帮助你方便的检查一个字符串是否与某种模式匹配。

Python 自1.5版本起增加了re 模块，它提供 Perl 风格的正则表达式模式。

re 模块使 Python 语言拥有全部的正则表达式功能。 

compile 函数根据一个模式字符串和可选的标志参数生成一个正则表达式对象。该对象拥有一系列方法用于正则表达式匹配和替换。 

re 模块也提供了与这些方法功能完全一致的函数，这些函数使用一个模式字符串做为它们的第一个参数。

本章节主要介绍 Python 中常用的正则表达式处理函数，如果你对正则表达式不了解，可以查看我们的 [正则表达式 - 教程](https://www.runoob.com/regexp/regexp-tutorial.html)。

------

## re.match函数

re.match 尝试从字符串的起始位置匹配一个模式，如果不是起始位置匹配成功的话，match()就返回none。

**函数语法**：

```
re.match(pattern, string, flags=0)
```

函数参数说明：

| 参数    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| pattern | 匹配的正则表达式                                             |
| string  | 要匹配的字符串。                                             |
| flags   | 标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。参见：[正则表达式修饰符 - 可选标志](https://www.runoob.com/python3/python3-reg-expressions.html#flags) |

匹配成功re.match方法返回一个匹配的对象，否则返回None。

我们可以使用group(num) 或  groups() 匹配对象函数来获取匹配表达式。

| 匹配对象方法 | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| group(num=0) | 匹配的整个表达式的字符串，group() 可以一次输入多个组号，在这种情况下它将返回一个包含那些组所对应值的元组。 |
| groups()     | 返回一个包含所有小组字符串的元组，从 1 到 所含的小组号。     |

## 实例

\#!/usr/bin/python  import re print(re.match('www', 'www.runoob.com').span())  # 在起始位置匹配 print(re.match('com', 'www.runoob.com'))         # 不在起始位置匹配

以上实例运行输出结果为：

```
(0, 3)
None
```

## 实例

\#!/usr/bin/python3 import re  line = "Cats are smarter than dogs" # .* 表示任意匹配除换行符（\n、\r）之外的任何单个或多个字符 # (.*?) 表示"非贪婪"模式，只保存第一个匹配到的子串 matchObj = re.match( r'(.*) are (.*?) .*', line, re.M|re.I)  if matchObj:   print ("matchObj.group() : ", matchObj.group())   print ("matchObj.group(1) : ", matchObj.group(1))   print ("matchObj.group(2) : ", matchObj.group(2)) else:   print ("No match!!")

以上实例执行结果如下：

```
matchObj.group() :  Cats are smarter than dogs
matchObj.group(1) :  Cats
matchObj.group(2) :  smarter
```

------

## re.search方法

re.search 扫描整个字符串并返回第一个成功的匹配。

函数语法：

```
re.search(pattern, string, flags=0)
```

函数参数说明：

| 参数    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| pattern | 匹配的正则表达式                                             |
| string  | 要匹配的字符串。                                             |
| flags   | 标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。参见：[正则表达式修饰符 - 可选标志](https://www.runoob.com/python3/python3-reg-expressions.html#flags) |

匹配成功re.search方法返回一个匹配的对象，否则返回None。

我们可以使用group(num) 或  groups() 匹配对象函数来获取匹配表达式。

| 匹配对象方法 | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| group(num=0) | 匹配的整个表达式的字符串，group() 可以一次输入多个组号，在这种情况下它将返回一个包含那些组所对应值的元组。 |
| groups()     | 返回一个包含所有小组字符串的元组，从 1 到 所含的小组号。     |

## 实例

\#!/usr/bin/python3  import re  print(re.search('www', 'www.runoob.com').span())  # 在起始位置匹配 print(re.search('com', 'www.runoob.com').span())         # 不在起始位置匹配

以上实例运行输出结果为：

```
(0, 3)
(11, 14)
```

## 实例 

\#!/usr/bin/python3  import re  line = "Cats are smarter than dogs"  searchObj = re.search( r'(.*) are (.*?) .*', line, re.M|re.I)  if searchObj:   print ("searchObj.group() : ", searchObj.group())   print ("searchObj.group(1) : ", searchObj.group(1))   print ("searchObj.group(2) : ", searchObj.group(2)) else:   print ("Nothing found!!")

以上实例执行结果如下：

```
searchObj.group() :  Cats are smarter than dogs
searchObj.group(1) :  Cats
searchObj.group(2) :  smarter
```

------

## re.match与re.search的区别

re.match 只匹配字符串的开始，如果字符串开始不符合正则表达式，则匹配失败，函数返回 None，而 re.search 匹配整个字符串，直到找到一个匹配。

## 实例 

\#!/usr/bin/python3  import re  line = "Cats are smarter than dogs"  matchObj = re.match( r'dogs', line, re.M|re.I) if matchObj:   print ("match --> matchObj.group() : ", matchObj.group()) else:   print ("No match!!")  matchObj = re.search( r'dogs', line, re.M|re.I) if matchObj:   print ("search --> matchObj.group() : ", matchObj.group()) else:   print ("No match!!")

以上实例运行结果如下：

```
No match!!
search --> matchObj.group() :  dogs
```

------

## 检索和替换

Python 的re模块提供了re.sub用于替换字符串中的匹配项。

语法：

```
re.sub(pattern, repl, string, count=0, flags=0)
```

参数：

- pattern : 正则中的模式字符串。
- repl : 替换的字符串，也可为一个函数。
- string : 要被查找替换的原始字符串。
- count : 模式匹配后替换的最大次数，默认 0 表示替换所有的匹配。
- flags : 编译时用的匹配模式，数字形式。

前三个为必选参数，后两个为可选参数。

## 实例 

\#!/usr/bin/python3 import re  phone = "2004-959-559 # 这是一个电话号码"  # 删除注释 num = re.sub(r'#.*$', "", phone) print ("电话号码 : ", num)  # 移除非数字的内容 num = re.sub(r'\D', "", phone) print ("电话号码 : ", num)

以上实例执行结果如下：

```
电话号码 :  2004-959-559 
电话号码 :  2004959559
```

### repl 参数是一个函数

以下实例中将字符串中的匹配的数字乘于 2：

## 实例 

\#!/usr/bin/python  import re  # 将匹配的数字乘于 2 def double(matched):    value = int(matched.group('value'))    return str(value * 2)  s = 'A23G4HFD567' print(re.sub('(?P<value>\d+)', double, s))

执行输出结果为：

```
A46G8HFD1134
```

### compile 函数

compile 函数用于编译正则表达式，生成一个正则表达式（ Pattern ）对象，供 match() 和 search() 这两个函数使用。

语法格式为：

```
re.compile(pattern[, flags])
```

参数：

- pattern : 一个字符串形式的正则表达式
- flags 可选，表示匹配模式，比如忽略大小写，多行模式等，具体参数为：
- - re.I 忽略大小写

  - re.L 表示特殊字符集 \w, \W, \b, \B, \s, \S 依赖于当前环境
  - re.M 多行模式
  - re.S 即为' . '并且包括换行符在内的任意字符（' . '不包括换行符）
  - re.U 表示特殊字符集 \w, \W, \b, \B, \d, \D, \s, \S 依赖于 Unicode 字符属性数据库
  - re.X 为了增加可读性，忽略空格和' # '后面的注释

### 实例

## 实例

\>>>import re >>> pattern = re.compile(r'\d+')                    # 用于匹配至少一个数字 >>> m = pattern.match('one12twothree34four')        # 查找头部，没有匹配 >>> print( m ) None >>> m = pattern.match('one12twothree34four', 2, 10) # 从'e'的位置开始匹配，没有匹配 >>> print( m ) None >>> m = pattern.match('one12twothree34four', 3, 10) # 从'1'的位置开始匹配，正好匹配 >>> print( m )                                        # 返回一个 Match 对象 <_sre.SRE_Match object at 0x10a42aac0> >>> m.group(0)   # 可省略 0 '12' >>> m.start(0)   # 可省略 0 3 >>> m.end(0)     # 可省略 0 5 >>> m.span(0)    # 可省略 0 (3, 5)

在上面，当匹配成功时返回一个 Match 对象，其中：

- `group([group1, …])` 方法用于获得一个或多个分组匹配的字符串，当要获得整个匹配的子串时，可直接使用 `group()` 或 `group(0)`；
- `start([group])` 方法用于获取分组匹配的子串在整个字符串中的起始位置（子串第一个字符的索引），参数默认值为 0；
- `end([group])` 方法用于获取分组匹配的子串在整个字符串中的结束位置（子串最后一个字符的索引+1），参数默认值为 0；
- `span([group])` 方法返回 `(start(group), end(group))`。

再看看一个例子：

## 实例

\>>>import re >>> pattern = re.compile(r'([a-z]+) ([a-z]+)', re.I)   # re.I 表示忽略大小写 >>> m = pattern.match('Hello World Wide Web') >>> print( m )                            # 匹配成功，返回一个 Match 对象 <_sre.SRE_Match object at 0x10bea83e8> >>> m.group(0)                            # 返回匹配成功的整个子串 'Hello World' >>> m.span(0)                             # 返回匹配成功的整个子串的索引 (0, 11) >>> m.group(1)                            # 返回第一个分组匹配成功的子串 'Hello' >>> m.span(1)                             # 返回第一个分组匹配成功的子串的索引 (0, 5) >>> m.group(2)                            # 返回第二个分组匹配成功的子串 'World' >>> m.span(2)                             # 返回第二个分组匹配成功的子串索引 (6, 11) >>> m.groups()                            # 等价于 (m.group(1), m.group(2), ...) ('Hello', 'World') >>> m.group(3)                            # 不存在第三个分组 Traceback (most recent call last):  File "<stdin>", line 1, in <module> IndexError: no such group

### findall

在字符串中找到正则表达式所匹配的所有子串，并返回一个列表，如果有多个匹配模式，则返回元组列表，如果没有找到匹配的，则返回空列表。

**注意：** match 和 search  是匹配一次 findall 匹配所有。

语法格式为：

```
re.findall(pattern, string, flags=0)
或
pattern.findall(string[, pos[, endpos]])
```

参数：

- pattern 匹配模式。
- string 待匹配的字符串。
- pos 可选参数，指定字符串的起始位置，默认为 0。
- endpos 可选参数，指定字符串的结束位置，默认为字符串的长度。

查找字符串中的所有数字：

## 实例

import re  result1 = re.findall(r'\d+','runoob 123 google 456')  pattern = re.compile(r'\d+')   # 查找数字 result2 = pattern.findall('runoob 123 google 456') result3 = pattern.findall('run88oob123google456', 0, 10)  print(result1) print(result2) print(result3)

输出结果：

```
['123', '456']
['123', '456']
['88', '12']
```

多个匹配模式，返回元组列表：

## 实例

**import** re

 result = re.findall(r'(**\w**+)=(**\d**+)', 'set width=20 and height=10')
 **print**(result)

```
[('width', '20'), ('height', '10')]
```

### re.finditer

和 findall 类似，在字符串中找到正则表达式所匹配的所有子串，并把它们作为一个迭代器返回。

```
re.finditer(pattern, string, flags=0)
```

参数：

| 参数    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| pattern | 匹配的正则表达式                                             |
| string  | 要匹配的字符串。                                             |
| flags   | 标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。参见：[正则表达式修饰符 - 可选标志](https://www.runoob.com/python3/python3-reg-expressions.html#flags) |

## 实例

import re  it = re.finditer(r"\d+","12a32bc43jf3")  for match in it:     print (match.group() )

输出结果：

```
12 
32 
43 
3
```

### re.split

split 方法按照能够匹配的子串将字符串分割后返回列表，它的使用形式如下：

```
re.split(pattern, string[, maxsplit=0, flags=0])
```

参数：

| 参数     | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| pattern  | 匹配的正则表达式                                             |
| string   | 要匹配的字符串。                                             |
| maxsplit | 分割次数，maxsplit=1 分割一次，默认为 0，不限制次数。        |
| flags    | 标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。参见：[正则表达式修饰符 - 可选标志](https://www.runoob.com/python3/python3-reg-expressions.html#flags) |

## 实例

\>>>import re >>> re.split('\W+', 'runoob, runoob, runoob.') ['runoob', 'runoob', 'runoob', ''] >>> re.split('(\W+)', ' runoob, runoob, runoob.')  ['', ' ', 'runoob', ', ', 'runoob', ', ', 'runoob', '.', ''] >>> re.split('\W+', ' runoob, runoob, runoob.', 1)  ['', 'runoob, runoob, runoob.']  >>> re.split('a*', 'hello world')   # 对于一个找不到匹配的字符串而言，split 不会对其作出分割 ['hello world']

------

## 正则表达式对象

### re.RegexObject

re.compile() 返回 RegexObject 对象。

### re.MatchObject

group() 返回被 RE 匹配的字符串。

- start() 返回匹配开始的位置
- end() 返回匹配结束的位置
- span() 返回一个元组包含匹配 (开始,结束) 的位置

------

## 正则表达式修饰符 - 可选标志

正则表达式可以包含一些可选标志修饰符来控制匹配的模式。修饰符被指定为一个可选的标志。多个标志可以通过按位 OR(|) 它们来指定。如 re.I | re.M 被设置成 I 和 M 标志：

| 修饰符 | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| re.I   | 使匹配对大小写不敏感                                         |
| re.L   | 做本地化识别（locale-aware）匹配                             |
| re.M   | 多行匹配，影响 ^ 和 $                                        |
| re.S   | 使 . 匹配包括换行在内的所有字符                              |
| re.U   | 根据Unicode字符集解析字符。这个标志影响 \w, \W, \b, \B.      |
| re.X   | 该标志通过给予你更灵活的格式以便你将正则表达式写得更易于理解。 |

------

## 正则表达式模式

模式字符串使用特殊的语法来表示一个正则表达式。

字母和数字表示他们自身。一个正则表达式模式中的字母和数字匹配同样的字符串。

多数字母和数字前加一个反斜杠时会拥有不同的含义。

标点符号只有被转义时才匹配自身，否则它们表示特殊的含义。

反斜杠本身需要使用反斜杠转义。

由于正则表达式通常都包含反斜杠，所以你最好使用原始字符串来表示它们。模式元素(如 r'\t'，等价于 \\t )匹配相应的特殊字符。

下表列出了正则表达式模式语法中的特殊元素。如果你使用模式的同时提供了可选的标志参数，某些模式元素的含义会改变。

| 模式         | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| ^            | 匹配字符串的开头                                             |
| $            | 匹配字符串的末尾。                                           |
| .            | 匹配任意字符，除了换行符，当re.DOTALL标记被指定时，则可以匹配包括换行符的任意字符。 |
| [...]        | 用来表示一组字符,单独列出：[amk] 匹配 'a'，'m'或'k'          |
| [^...]       | 不在[]中的字符：[^abc] 匹配除了a,b,c之外的字符。             |
| re*          | 匹配0个或多个的表达式。                                      |
| re+          | 匹配1个或多个的表达式。                                      |
| re?          | 匹配0个或1个由前面的正则表达式定义的片段，非贪婪方式         |
| re{ n}       | 匹配n个前面表达式。例如，"o{2}"不能匹配"Bob"中的"o"，但是能匹配"food"中的两个o。 |
| re{ n,}      | 精确匹配n个前面表达式。例如，"o{2,}"不能匹配"Bob"中的"o"，但能匹配"foooood"中的所有o。"o{1,}"等价于"o+"。"o{0,}"则等价于"o*"。 |
| re{ n, m}    | 匹配 n 到 m 次由前面的正则表达式定义的片段，贪婪方式         |
| a\| b        | 匹配a或b                                                     |
| (re)         | 匹配括号内的表达式，也表示一个组                             |
| (?imx)       | 正则表达式包含三种可选标志：i, m, 或 x 。只影响括号中的区域。 |
| (?-imx)      | 正则表达式关闭 i, m, 或 x 可选标志。只影响括号中的区域。     |
| (?: re)      | 类似 (...), 但是不表示一个组                                 |
| (?imx: re)   | 在括号中使用i, m, 或 x 可选标志                              |
| (?-imx: re)  | 在括号中不使用i, m, 或 x 可选标志                            |
| (?#...)      | 注释.                                                        |
| (?= re)      | 前向肯定界定符。如果所含正则表达式，以 ... 表示，在当前位置成功匹配时成功，否则失败。但一旦所含表达式已经尝试，匹配引擎根本没有提高；模式的剩余部分还要尝试界定符的右边。 |
| (?! re)      | 前向否定界定符。与肯定界定符相反；当所含表达式不能在字符串当前位置匹配时成功。 |
| (?> re)      | 匹配的独立模式，省去回溯。                                   |
| \w           | 匹配数字字母下划线                                           |
| \W           | 匹配非数字字母下划线                                         |
| \s           | 匹配任意空白字符，等价于 [\t\n\r\f]。                        |
| \S           | 匹配任意非空字符                                             |
| \d           | 匹配任意数字，等价于 [0-9]。                                 |
| \D           | 匹配任意非数字                                               |
| \A           | 匹配字符串开始                                               |
| \Z           | 匹配字符串结束，如果是存在换行，只匹配到换行前的结束字符串。 |
| \z           | 匹配字符串结束                                               |
| \G           | 匹配最后匹配完成的位置。                                     |
| \b           | 匹配一个单词边界，也就是指单词和空格间的位置。例如， 'er\b' 可以匹配"never" 中的 'er'，但不能匹配 "verb" 中的 'er'。 |
| \B           | 匹配非单词边界。'er\B' 能匹配 "verb" 中的 'er'，但不能匹配 "never" 中的 'er'。 |
| \n, \t, 等。 | 匹配一个换行符。匹配一个制表符, 等                           |
| \1...\9      | 匹配第n个分组的内容。                                        |
| \10          | 匹配第n个分组的内容，如果它经匹配。否则指的是八进制字符码的表达式。 |

------

## 正则表达式实例

#### 字符匹配

| 实例   | 描述           |
| ------ | -------------- |
| python | 匹配 "python". |

#### 字符类

| 实例        | 描述                              |
| ----------- | --------------------------------- |
| [Pp]ython   | 匹配 "Python" 或 "python"         |
| rub[ye]     | 匹配 "ruby" 或 "rube"             |
| [aeiou]     | 匹配中括号内的任意一个字母        |
| [0-9]       | 匹配任何数字。类似于 [0123456789] |
| [a-z]       | 匹配任何小写字母                  |
| [A-Z]       | 匹配任何大写字母                  |
| [a-zA-Z0-9] | 匹配任何字母及数字                |
| [^aeiou]    | 除了aeiou字母以外的所有字符       |
| [^0-9]      | 匹配除了数字外的字符              |

#### 特殊字符类

| 实例 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| .    | 匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用象 '[.\n]' 的模式。 |
| \d   | 匹配一个数字字符。等价于 [0-9]。                             |
| \D   | 匹配一个非数字字符。等价于 [^0-9]。                          |
| \s   | 匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。 |
| \S   | 匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。                  |
| \w   | 匹配包括下划线的任何单词字符。等价于'[A-Za-z0-9_]'。         |
| \W   | 匹配任何非单词字符。等价于 '[^A-Za-z0-9_]'。                 |

## 正则表达式修饰符 - 可选标志

正则表达式可以包含一些可选标志修饰符来控制匹配的模式。修饰符被指定为一个可选的标志。多个标志可以通过按位 OR(|) 它们来指定。如 re.I | re.M 被设置成 I 和 M 标志：

| 修饰符 | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| re.I   | 使匹配对大小写不敏感                                         |
| re.L   | 做本地化识别（locale-aware）匹配                             |
| re.M   | 多行匹配，影响 ^ 和 $                                        |
| re.S   | 使 . 匹配包括换行在内的所有字符                              |
| re.U   | 根据Unicode字符集解析字符。这个标志影响 \w, \W, \b, \B.      |
| re.X   | 该标志通过给予你更灵活的格式以便你将正则表达式写得更易于理解。 |

------

## 正则表达式模式

模式字符串使用特殊的语法来表示一个正则表达式：

字母和数字表示他们自身。一个正则表达式模式中的字母和数字匹配同样的字符串。

多数字母和数字前加一个反斜杠时会拥有不同的含义。

标点符号只有被转义时才匹配自身，否则它们表示特殊的含义。

反斜杠本身需要使用反斜杠转义。

由于正则表达式通常都包含反斜杠，所以你最好使用原始字符串来表示它们。模式元素(如 r'/t'，等价于'//t')匹配相应的特殊字符。

下表列出了正则表达式模式语法中的特殊元素。如果你使用模式的同时提供了可选的标志参数，某些模式元素的含义会改变。

| 模式        | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| ^           | 匹配字符串的开头                                             |
| $           | 匹配字符串的末尾。                                           |
| .           | 匹配任意字符，除了换行符，当re.DOTALL标记被指定时，则可以匹配包括换行符的任意字符。 |
| [...]       | 用来表示一组字符,单独列出：[amk] 匹配 'a'，'m'或'k'          |
| [^...]      | 不在[]中的字符：[^abc] 匹配除了a,b,c之外的字符。             |
| re*         | 匹配0个或多个的表达式。                                      |
| re+         | 匹配1个或多个的表达式。                                      |
| re?         | 匹配0个或1个由前面的正则表达式定义的片段，非贪婪方式         |
| re{ n}      | 匹配n个前面表达式。例如，"o{2}"不能匹配"Bob"中的"o"，但是能匹配"food"中的两个o。 |
| re{ n,}     | 精确匹配n个前面表达式。例如，"o{2,}"不能匹配"Bob"中的"o"，但能匹配"foooood"中的所有o。"o{1,}"等价于"o+"。"o{0,}"则等价于"o*"。 |
| re{ n, m}   | 匹配 n 到 m 次由前面的正则表达式定义的片段，贪婪方式         |
| a\| b       | 匹配a或b                                                     |
| (re)        | G匹配括号内的表达式，也表示一个组                            |
| (?imx)      | 正则表达式包含三种可选标志：i, m, 或 x 。只影响括号中的区域。 |
| (?-imx)     | 正则表达式关闭 i, m, 或 x 可选标志。只影响括号中的区域。     |
| (?: re)     | 类似 (...), 但是不表示一个组                                 |
| (?imx: re)  | 在括号中使用i, m, 或 x 可选标志                              |
| (?-imx: re) | 在括号中不使用i, m, 或 x 可选标志                            |
| (?#...)     | 注释.                                                        |
| (?= re)     | 前向肯定界定符。如果所含正则表达式，以 ... 表示，在当前位置成功匹配时成功，否则失败。但一旦所含表达式已经尝试，匹配引擎根本没有提高；模式的剩余部分还要尝试界定符的右边。 |
| (?! re)     | 前向否定界定符。与肯定界定符相反；当所含表达式不能在字符串当前位置匹配时成功 |
| (?> re)     | 匹配的独立模式，省去回溯。                                   |
| \w          | 匹配字母数字                                                 |
| \W          | 匹配非字母数字                                               |
| \s          | 匹配任意空白字符，等价于 [\t\n\r\f].                         |
| \S          | 匹配任意非空字符                                             |
| \d          | 匹配任意数字，等价于 [0-9].                                  |
| \D          | 匹配任意非数字                                               |
| \A          | 匹配字符串开始                                               |
| \Z          | 匹配字符串结束，如果是存在换行，只匹配到换行前的结束字符串。c |
| \z          | 匹配字符串结束                                               |
| \G          | 匹配最后匹配完成的位置。                                     |
| \b          | 匹配一个单词边界，也就是指单词和空格间的位置。例如， 'er\b' 可以匹配"never" 中的 'er'，但不能匹配 "verb" 中的 'er'。 |
| \B          | 匹配非单词边界。'er\B' 能匹配 "verb" 中的 'er'，但不能匹配 "never" 中的 'er'。 |
| \n, \t, 等. | 匹配一个换行符。匹配一个制表符。等                           |
| \1...\9     | 匹配第n个分组的子表达式。                                    |
| \10         | 匹配第n个分组的子表达式，如果它经匹配。否则指的是八进制字符码的表达式。 |

------

##  正则表达式实例 

#### 字符匹配

| 实例   | 描述           |
| ------ | -------------- |
| python | 匹配 "python". |

#### 字符类

| 实例        | 描述                              |
| ----------- | --------------------------------- |
| [Pp]ython   | 匹配 "Python" 或 "python"         |
| rub[ye]     | 匹配 "ruby" 或 "rube"             |
| [aeiou]     | 匹配中括号内的任意一个字母        |
| [0-9]       | 匹配任何数字。类似于 [0123456789] |
| [a-z]       | 匹配任何小写字母                  |
| [A-Z]       | 匹配任何大写字母                  |
| [a-zA-Z0-9] | 匹配任何字母及数字                |
| [^aeiou]    | 除了aeiou字母以外的所有字符       |
| [^0-9]      | 匹配除了数字外的字符              |

#### 特殊字符类

| 实例 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| .    | 匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用象 '[.\n]' 的模式。 |
| \d   | 匹配一个数字字符。等价于 [0-9]。                             |
| \D   | 匹配一个非数字字符。等价于 [^0-9]。                          |
| \s   | 匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。 |
| \S   | 匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。                  |
| \w   | 匹配包括下划线的任何单词字符。等价于'[A-Za-z0-9_]'。         |
| \W   | 匹配任何非单词字符。等价于 '[^A-Za-z0-9_]'。                 |

## uWSGI  安装配置

# Python uWSGI  安装配置

本文主要介绍如何部署简单的 WSGI 应用和常见的 Web 框架。

以 Ubuntu/Debian 为例，先安装依赖包：

```
apt-get install build-essential python-dev
```

### Python 安装 uWSGI

**1、通过 pip 命令：**

```
pip install uwsgi
```

**2、下载安装脚本：**

```
curl http://uwsgi.it/install | bash -s default /tmp/uwsgi
```

将 uWSGI 二进制安装到 /tmp/uwsgi ，你可以修改它。

**3、源代码安装：**

```
wget http://projects.unbit.it/downloads/uwsgi-latest.tar.gz
tar zxvf uwsgi-latest.tar.gz
cd uwsgi-latest
make
```

安装完成后，在当前目录下，你会获得一个 uwsgi 二进制文件。

------

## 第一个 WSGI 应用

让我们从一个简单的 "Hello World" 开始，创建文件 foobar.py，代码如下：

```
def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    return [b"Hello World"]
```

uWSGI Python 加载器将会搜索的默认函数 application 。

接下来我们启动 uWSGI 来运行一个 HTTP 服务器，将程序部署在HTTP端口 9090 上：

```
uwsgi --http :9090 --wsgi-file foobar.py
```

### 添加并发和监控

默认情况下，uWSGI 启动一个单一的进程和一个单一的线程。

你可以用 --processes 选项添加更多的进程，或者使用 --threads 选项添加更多的线程 ，也可以两者同时使用。

```
uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2
```

以上命令将会生成 4 个进程, 每个进程有 2 个线程。

如果你要执行监控任务，可以使用 stats 子系统，监控的数据格式是 JSON：

```
uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
```

我们可以安装 uwsgitop（类似 Linux top 命令） 来查看监控数据：

```
pip install uwsgitop
```

------

## 结合 Web 服务器使用

我们可以将 uWSGI 和 Nginx Web 服务器结合使用，实现更高的并发性能。

一个常用的nginx配置如下：

```
location / {
    include uwsgi_params;
    uwsgi_pass 127.0.0.1:3031;
}
```

以上代码表示使用 nginx 接收的 Web 请求传递给端口为 3031 的 uWSGI 服务来处理。

现在，我们可以生成 uWSGI 来本地使用 uwsgi 协议：

```
uwsgi --socket 127.0.0.1:3031 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
```

如果你的 Web 服务器使用 HTTP，那么你必须告诉 uWSGI 本地使用 http 协议 (这与会自己生成一个代理的–http不同):

```
uwsgi --http-socket 127.0.0.1:3031 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
```

### 部署 Django

Django 是最常使用的 Python web 框架，假设 Django 项目位于 /home/foobar/myproject:

uwsgi --socket 127.0.0.1:3031 --chdir /home/foobar/myproject/  --wsgi-file myproject/wsgi.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191

--chdir 用于指定项目路径。

我们可以把以上的命令弄成一个 yourfile.ini 配置文件:

```
[uwsgi]
socket = 127.0.0.1:3031
chdir = /home/foobar/myproject/
wsgi-file = myproject/wsgi.py
processes = 4
threads = 2
stats = 127.0.0.1:9191
```

接下来你只需要执行以下命令即可：

```
uwsgi yourfile.ini
```

### 部署 Flask

Flask 是一个流行的 Python web 框架。

创建文件 myflaskapp.py ，代码如下：

```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return "<span style='color:red'>I am app 1</span>"
```

执行以下命令：

```
uwsgi --socket 127.0.0.1:3031 --wsgi-file myflaskapp.py --callable app --processes 4 --threads 2 --stats 127.0.0.1:9191
```

### 安装

安装依赖包：

```
apt-get install build-essential python-dev
```

**1、通过 pip 命令：**

```
pip install uwsgi
```

**2、下载安装脚本：**

```
curl http://uwsgi.it/install | bash -s default /tmp/uwsgi
```

将 uWSGI 二进制安装到 /tmp/uwsgi ，你可以修改它。

**3、源代码安装：**

```
wget http://projects.unbit.it/downloads/uwsgi-latest.tar.gz
tar zxvf uwsgi-latest.tar.gz
cd uwsgi-latest
make
```

安装完成后，在当前目录下，你会获得一个 uwsgi 二进制文件。

------

## 第一个 WSGI 应用

让我们从一个简单的 "Hello World" 开始，创建文件 foobar.py，代码如下：

```
def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    return [b"Hello World"]
```

uWSGI Python 加载器将会搜索的默认函数 application 。

接下来我们启动 uWSGI 来运行一个 HTTP 服务器，将程序部署在HTTP端口 9090 上：

```
uwsgi --http :9090 --wsgi-file foobar.py
```

### 添加并发和监控

默认情况下，uWSGI 启动一个单一的进程和一个单一的线程。

你可以用 --processes 选项添加更多的进程，或者使用 --threads 选项添加更多的线程 ，也可以两者同时使用。

```
uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2
```

以上命令将会生成 4 个进程, 每个进程有 2 个线程。

如果你要执行监控任务，可以使用 stats 子系统，监控的数据格式是 JSON：

```
uwsgi --http :9090 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
```

我们可以安装 uwsgitop（类似 Linux top 命令） 来查看监控数据：

```
pip install uwsgitop
```

------

## 结合 Web 服务器使用

我们可以将 uWSGI 和 Nginx Web 服务器结合使用，实现更高的并发性能。

一个常用的nginx配置如下：

```
location / {
    include uwsgi_params;
    uwsgi_pass 127.0.0.1:3031;
}
```

以上代码表示使用 nginx 接收的 Web 请求传递给端口为 3031 的 uWSGI 服务来处理。

现在，我们可以生成 uWSGI 来本地使用 uwsgi 协议：

```
uwsgi --socket 127.0.0.1:3031 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
```

如果你的 Web 服务器使用 HTTP，那么你必须告诉 uWSGI 本地使用 http 协议 (这与会自己生成一个代理的–http不同):

```
uwsgi --http-socket 127.0.0.1:3031 --wsgi-file foobar.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191
```

### 部署 Django

Django 是最常使用的 Python web 框架，假设 Django 项目位于 /home/foobar/myproject:

uwsgi --socket 127.0.0.1:3031 --chdir /home/foobar/myproject/  --wsgi-file myproject/wsgi.py --master --processes 4 --threads 2 --stats 127.0.0.1:9191

--chdir 用于指定项目路径。

我们可以把以上的命令弄成一个 yourfile.ini 配置文件:

```
[uwsgi]
socket = 127.0.0.1:3031
chdir = /home/foobar/myproject/
wsgi-file = myproject/wsgi.py
processes = 4
threads = 2
stats = 127.0.0.1:9191
```

接下来你只需要执行以下命令即可：

```
uwsgi yourfile.ini
```

### 部署 Flask

Flask 是一个流行的 Python web 框架。

创建文件 myflaskapp.py ，代码如下：

```
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return "<span style='color:red'>I am app 1</span>"
```

执行以下命令：

```
uwsgi --socket 127.0.0.1:3031 --wsgi-file myflaskapp.py --callable app --processes 4 --threads 2 --stats 127.0.0.1:9191
```

​			

# Python3 CGI编程

## 什么是CGI

CGI 目前由NCSA维护，NCSA定义CGI如下：

CGI(Common Gateway Interface),通用网关接口,它是一段程序,运行在服务器上如：HTTP服务器，提供同客户端HTML页面的接口。

------

## 网页浏览

为了更好的了解CGI是如何工作的，我们可以从在网页上点击一个链接或URL的流程：

- 1、使用你的浏览器访问URL并连接到HTTP web 服务器。
- 2、Web服务器接收到请求信息后会解析URL，并查找访问的文件在服务器上是否存在，如果存在返回文件的内容，否则返回错误信息。
- 3、浏览器从服务器上接收信息，并显示接收的文件或者错误信息。

CGI程序可以是Python脚本，PERL脚本，SHELL脚本，C或者C++程序等。

------

## CGI架构图

![cgiarch](https://www.runoob.com/wp-content/uploads/2013/11/Cgi01.png)

------

## Web服务器支持及配置

在你进行CGI编程前，确保您的Web服务器支持CGI及已经配置了CGI的处理程序。

Apache 支持CGI 配置：

设置好CGI目录：

```
ScriptAlias /cgi-bin/ /var/www/cgi-bin/
```

所有的HTTP服务器执行CGI程序都保存在一个预先配置的目录。这个目录被称为CGI目录，并按照惯例，它被命名为/var/www/cgi-bin目录。

CGI文件的扩展名为.cgi，python也可以使用.py扩展名。

默认情况下，Linux服务器配置运行的cgi-bin目录中为/var/www。

如果你想指定其他运行CGI脚本的目录，可以修改httpd.conf配置文件，如下所示：

```
<Directory "/var/www/cgi-bin">
   AllowOverride None
   Options +ExecCGI
   Order allow,deny
   Allow from all
</Directory>
```

在 AddHandler 中添加 .py 后缀，这样我们就可以访问 .py 结尾的 python 脚本文件：

```
AddHandler cgi-script .cgi .pl .py
```

------

## 第一个CGI程序

我们使用Python创建第一个CGI程序，文件名为hello.py，文件位于/var/www/cgi-bin目录中，内容如下：

## 实例

\#!/usr/bin/python3

 **print** ("Content-type:text/html")
 **print** ()               # 空行，告诉服务器结束头部
 **print** ('<html>')
 **print** ('<head>')
 **print** ('<meta charset="utf-8">')
 **print** ('<title>Hello Word - 我的第一个 CGI 程序！</title>')
 **print** ('</head>')
 **print** ('<body>')
 **print** ('<h2>Hello Word! 我是来自菜鸟教程的第一CGI程序</h2>')
 **print** ('</body>')
 **print** ('</html>')

文件保存后修改 hello.py，修改文件权限为 755：

```
chmod 755 hello.py 
```

以上程序在浏览器访问显示结果如下：

![img](https://www.runoob.com/wp-content/uploads/2013/11/3E82A06B-FE1F-49B9-969C-183FABD56363.jpg)

这个的hello.py脚本是一个简单的Python脚本，脚本第一行的输出内容"Content-type:text/html"发送到浏览器并告知浏览器显示的内容类型为"text/html"。

用 print 输出一个空行用于告诉服务器结束头部信息。

------

## HTTP头部

hello.py文件内容中的" Content-type:text/html"即为HTTP头部的一部分，它会发送给浏览器告诉浏览器文件的内容类型。

HTTP头部的格式如下：

```
HTTP 字段名: 字段内容
```

例如：

```
Content-type: text/html
```

以下表格介绍了CGI程序中HTTP头部经常使用的信息：

| 头                  | 描述                                                      |
| ------------------- | --------------------------------------------------------- |
| Content-type:       | 请求的与实体对应的MIME信息。例如: Content-type:text/html  |
| Expires: Date       | 响应过期的日期和时间                                      |
| Location: URL       | 用来重定向接收方到非请求URL的位置来完成请求或标识新的资源 |
| Last-modified: Date | 请求资源的最后修改时间                                    |
| Content-length: N   | 请求的内容长度                                            |
| Set-Cookie: String  | 设置Http Cookie                                           |

------

## CGI环境变量

所有的CGI程序都接收以下的环境变量，这些变量在CGI程序中发挥了重要的作用：

| 变量名          | 描述                                                         |
| --------------- | ------------------------------------------------------------ |
| CONTENT_TYPE    | 这个环境变量的值指示所传递来的信息的MIME类型。目前，环境变量CONTENT_TYPE一般都是：application/x-www-form-urlencoded,他表示数据来自于HTML表单。 |
| CONTENT_LENGTH  | 如果服务器与CGI程序信息的传递方式是POST，这个环境变量即使从标准输入STDIN中可以读到的有效数据的字节数。这个环境变量在读取所输入的数据时必须使用。 |
| HTTP_COOKIE     | 客户机内的 COOKIE 内容。                                     |
| HTTP_USER_AGENT | 提供包含了版本数或其他专有数据的客户浏览器信息。             |
| PATH_INFO       | 这个环境变量的值表示紧接在CGI程序名之后的其他路径信息。它常常作为CGI程序的参数出现。 |
| QUERY_STRING    | 如果服务器与CGI程序信息的传递方式是GET，这个环境变量的值即使所传递的信息。这个信息经跟在CGI程序名的后面，两者中间用一个问号'?'分隔。 |
| REMOTE_ADDR     | 这个环境变量的值是发送请求的客户机的IP地址，例如上面的192.168.1.67。这个值总是存在的。而且它是Web客户机需要提供给Web服务器的唯一标识，可以在CGI程序中用它来区分不同的Web客户机。 |
| REMOTE_HOST     | 这个环境变量的值包含发送CGI请求的客户机的主机名。如果不支持你想查询，则无需定义此环境变量。 |
| REQUEST_METHOD  | 提供脚本被调用的方法。对于使用 HTTP/1.0 协议的脚本，仅 GET 和 POST 有意义。 |
| SCRIPT_FILENAME | CGI脚本的完整路径                                            |
| SCRIPT_NAME     | CGI脚本的的名称                                              |
| SERVER_NAME     | 这是你的 WEB 服务器的主机名、别名或IP地址。                  |
| SERVER_SOFTWARE | 这个环境变量的值包含了调用CGI程序的HTTP服务器的名称和版本号。例如，上面的值为Apache/2.2.14(Unix) |

以下是一个简单的CGI脚本输出CGI的环境变量：

## 实例

\#!/usr/bin/python3

 **import** os

 **print** ("Content-type: text/html")
 **print** ()
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<b>环境变量</b><br>")
 **print** ("<ul>")
 **for** key **in** os.environ.keys():
   **print** ("<li><span style='color:green'>%30s </span> : %s </li>" % (key,os.environ[key]))
 **print** ("</ul>")

将以上点保存为 test.py ,并修改文件权限为 755，执行结果如下：

![img](https://www.runoob.com/wp-content/uploads/2013/11/0B7EB575-8393-43A0-949A-E46DCFB840FE.jpg)

------

## GET和POST方法

浏览器客户端通过两种方法向服务器传递信息，这两种方法就是 GET 方法和 POST 方法。

### 使用GET方法传输数据

GET方法发送编码后的用户信息到服务端，数据信息包含在请求页面的URL上，以"?"号分割, 如下所示：

```
http://www.test.com/cgi-bin/hello.py?key1=value1&key2=value2
```

有关 GET 请求的其他一些注释：

- GET 请求可被缓存
- GET 请求保留在浏览器历史记录中
- GET 请求可被收藏为书签
- GET 请求不应在处理敏感数据时使用
- GET 请求有长度限制
- GET 请求只应当用于取回数据

### 简单的url实例：GET方法

以下是一个简单的URL，使用GET方法向hello_get.py程序发送两个参数：

```
/cgi-bin/test.py?name=菜鸟教程&url=http://www.runoob.com
```

以下为 hello_get.py 文件的代码：

## 实例

\#!/usr/bin/python3

 \# CGI处理模块
 **import** cgi, cgitb 

 \# 创建 FieldStorage 的实例化
 form = cgi.FieldStorage() 

 \# 获取数据
 site_name = form.getvalue('name')
 site_url  = form.getvalue('url')

 **print** ("Content-type:text/html")
 **print** ()
 **print** ("<html>")
 **print** ("<head>")
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<title>菜鸟教程 CGI 测试实例</title>")
 **print** ("</head>")
 **print** ("<body>")
 **print** ("<h2>%s官网：%s</h2>" % (site_name, site_url))
 **print** ("</body>")
 **print** ("</html>")

文件保存后修改 hello_get.py，修改文件权限为 755：

```
chmod 755 hello_get.py 
```

浏览器请求输出结果：

![img](https://www.runoob.com/wp-content/uploads/2013/11/4C034008-B0B0-452F-AC97-C2BE37B9C7AF.jpg)

### 简单的表单实例：GET方法

以下是一个通过HTML的表单使用GET方法向服务器发送两个数据，提交的服务器脚本同样是hello_get.py文件，hello_get.html 代码如下：

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body> <form action="/cgi-bin/hello_get.py" method="get"> 站点名称: <input type="text" name="name">  <br />  站点 URL: <input type="text" name="url" /> <input type="submit" value="提交" /> </form> </body> </html>

默认情况下 cgi-bin 目录只能存放脚本文件，我们将 hello_get.html 存储在 test 目录下，修改文件权限为 755：

```
chmod 755 hello_get.html
```

Gif 演示如下所示：

![img](https://www.runoob.com/wp-content/uploads/2013/11/hello_get.gif)

### 使用POST方法传递数据

使用POST方法向服务器传递数据是更安全可靠的，像一些敏感信息如用户密码等需要使用POST传输数据。

以下同样是hello_get.py ，它也可以处理浏览器提交的POST表单数据:

## 实例

\#!/usr/bin/python3

 \# CGI处理模块
 **import** cgi, cgitb 

 \# 创建 FieldStorage 的实例化
 form = cgi.FieldStorage() 

 \# 获取数据
 site_name = form.getvalue('name')
 site_url  = form.getvalue('url')

 **print** ("Content-type:text/html")
 **print** ()
 **print** ("<html>")
 **print** ("<head>")
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<title>菜鸟教程 CGI 测试实例</title>")
 **print** ("</head>")
 **print** ("<body>")
 **print** ("<h2>%s官网：%s</h2>" % (site_name, site_url))
 **print** ("</body>")
 **print** ("</html>")

以下为表单通过POST方法（**method="post"**）向服务器脚本 hello_get.py 提交数据:

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body> <form action="/cgi-bin/hello_get.py" method="post"> 站点名称: <input type="text" name="name">  <br />  站点 URL: <input type="text" name="url" /> <input type="submit" value="提交" /> </form> </body> </html> </form>

Gif 演示如下所示：

![img](https://www.runoob.com/wp-content/uploads/2013/11/hello_post.gif)

### 通过CGI程序传递checkbox数据

checkbox用于提交一个或者多个选项数据，HTML代码如下：

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body> <form action="/cgi-bin/checkbox.py" method="POST" target="_blank"> <input type="checkbox" name="runoob" value="on" /> 菜鸟教程 <input type="checkbox" name="google" value="on" /> Google <input type="submit" value="选择站点" /> </form> </body> </html>

以下为 checkbox.py 文件的代码：

## 实例

\#!/usr/bin/python3

 \# 引入 CGI 处理模块 
 **import** cgi, cgitb 

 \# 创建 FieldStorage的实例 
 form = cgi.FieldStorage() 

 \# 接收字段数据
 **if** form.getvalue('google'):
   google_flag = "是"
 **else**:
   google_flag = "否"

 **if** form.getvalue('runoob'):
   runoob_flag = "是"
 **else**:
   runoob_flag = "否"

 **print** ("Content-type:text/html")
 **print** ()
 **print** ("<html>")
 **print** ("<head>")
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<title>菜鸟教程 CGI 测试实例</title>")
 **print** ("</head>")
 **print** ("<body>")
 **print** ("<h2> 菜鸟教程是否选择了 : %s</h2>" % runoob_flag)
 **print** ("<h2> Google 是否选择了 : %s</h2>" % google_flag)
 **print** ("</body>")
 **print** ("</html>")

修改 checkbox.py 权限：

```
chmod 755 checkbox.py
```

浏览器访问 Gif 演示图：

![img](https://www.runoob.com/wp-content/uploads/2013/11/checkbox.gif)

### 通过CGI程序传递Radio数据

Radio 只向服务器传递一个数据，HTML代码如下：

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body> <form action="/cgi-bin/radiobutton.py" method="post" target="_blank"> <input type="radio" name="site" value="runoob" /> 菜鸟教程 <input type="radio" name="site" value="google" /> Google <input type="submit" value="提交" /> </form> </body> </html>

radiobutton.py 脚本代码如下：

## 实例

\#!/usr/bin/python3

 \# 引入 CGI 处理模块 
 **import** cgi, cgitb 

 \# 创建 FieldStorage的实例 
 form = cgi.FieldStorage() 

 \# 接收字段数据
 **if** form.getvalue('site'):
   site = form.getvalue('site')
 **else**:
   site = "提交数据为空"

 **print** ("Content-type:text/html")
 **print** ()
 **print** ("<html>")
 **print** ("<head>")
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<title>菜鸟教程 CGI 测试实例</title>")
 **print** ("</head>")
 **print** ("<body>")
 **print** ("<h2> 选中的网站是 %s</h2>" % site)
 **print** ("</body>")
 **print** ("</html>")

修改 radiobutton.py 权限：

```
chmod 755 radiobutton.py
```

浏览器访问 Gif 演示图：

![img](https://www.runoob.com/wp-content/uploads/2013/11/radiobutton.gif)

### 通过CGI程序传递 Textarea 数据

Textarea 向服务器传递多行数据，HTML 代码如下：

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body> <form action="/cgi-bin/textarea.py" method="post" target="_blank"> <textarea name="textcontent" cols="40" rows="4"> 在这里输入内容... </textarea> <input type="submit" value="提交" /> </form> </body> </html>

textarea.py 脚本代码如下：

## 实例

\#!/usr/bin/python3

 \# 引入 CGI 处理模块 
 **import** cgi, cgitb 

 \# 创建 FieldStorage的实例 
 form = cgi.FieldStorage() 

 \# 接收字段数据
 **if** form.getvalue('textcontent'):
   text_content = form.getvalue('textcontent')
 **else**:
   text_content = "没有内容"

 **print** ("Content-type:text/html")
 **print** ()
 **print** ("<html>")
 **print** ("<head>")
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<title>菜鸟教程 CGI 测试实例</title>")
 **print** ("</head>")
 **print** ("<body>")
 **print** ("<h2> 输入的内容是：%s</h2>" % text_content)
 **print** ("</body>")
 **print** ("</html>")

\>

修改 textarea.py 权限：

```
chmod 755 textarea.py
```

浏览器访问 Gif 演示图：

![img](https://www.runoob.com/wp-content/uploads/2013/11/textarea.gif)

### 通过CGI程序传递下拉数据。

HTML 下拉框代码如下：

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body> <form action="/cgi-bin/dropdown.py" method="post" target="_blank"> <select name="dropdown"> <option value="runoob" selected>菜鸟教程</option> <option value="google">Google</option> </select> <input type="submit" value="提交"/> </form> </body> </html>

dropdown.py 脚本代码如下所示：

## 实例

\#!/usr/bin/python3

 \# 引入 CGI 处理模块 
 **import** cgi, cgitb 

 \# 创建 FieldStorage的实例 
 form = cgi.FieldStorage() 

 \# 接收字段数据
 **if** form.getvalue('dropdown'):
   dropdown_value = form.getvalue('dropdown')
 **else**:
   dropdown_value = "没有内容"

 **print** ("Content-type:text/html")
 **print** ()
 **print** ("<html>")
 **print** ("<head>")
 **print** ("<meta charset=**\"**utf-8**\"**>")
 **print** ("<title>菜鸟教程 CGI 测试实例</title>")
 **print** ("</head>")
 **print** ("<body>")
 **print** ("<h2> 选中的选项是：%s</h2>" % dropdown_value)
 **print** ("</body>")
 **print** ("</html>")

修改 dropdown.py 权限：

```
chmod 755 dropdown.py
```

浏览器访问 Gif 演示图：

![img](https://www.runoob.com/wp-content/uploads/2013/11/dropdown.gif)

------

## CGI中使用Cookie

在 http 协议一个很大的缺点就是不对用户身份的进行判断，这样给编程人员带来很大的不便， 而 cookie 功能的出现弥补了这个不足。

  cookie 就是在客户访问脚本的同时，通过客户的浏览器，在客户硬盘上写入纪录数据  ，当下次客户访问脚本时取回数据信息，从而达到身份判别的功能，cookie 常用在身份校验中。

### cookie的语法

http cookie的发送是通过http头部来实现的，他早于文件的传递，头部set-cookie的语法如下：

```
Set-cookie:name=name;expires=date;path=path;domain=domain;secure 
```

-   **name=name:** 需要设置cookie的值(name不能使用"**;**"和"**,**"号),有多个name值时用 "**;**" 分隔，例如：**name1=name1;name2=name2;name3=name3**。 
- **expires=date:** cookie的有效期限,格式： expires="Wdy,DD-Mon-YYYY HH:MM:SS"
- 
- **path=path:** 设置cookie支持的路径,如果path是一个路径，则cookie对这个目录下的所有文件及子目录生效，例如：  path="/cgi-bin/"，如果path是一个文件，则cookie指对这个文件生效，例如：path="/cgi-bin/cookie.cgi"。
- **domain=domain:** 对cookie生效的域名，例如：domain="www.runoob.com"
- **secure:** 如果给出此标志，表示cookie只能通过SSL协议的https服务器来传递。 
- cookie的接收是通过设置环境变量HTTP_COOKIE来实现的，CGI程序可以通过检索该变量获取cookie信息。

------

## Cookie设置 

Cookie的 设置非常简单，cookie 会在 http 头部单独发送。以下实例在 cookie 中设置了 name 和 expires：

## 实例

\#!/usr/bin/python3

 **print** ('Set-Cookie: name="菜鸟教程";expires=Wed, 28 Aug 2016 18:30:00 GMT')
 **print** ('Content-Type: text/html')

 **print** ()
 **print** ("""
 <html>
  <head>
   <meta charset="utf-8">
   <title>菜鸟教程(runoob.com)</title>
  </head>
   <body>
     <h1>Cookie set OK!</h1>
   </body>
 </html>
 """)

将以上代码保存到 cookie_set.py，并修改 cookie_set.py 权限：

```
chmod 755 cookie_set.py
```

以上实例使用了 Set-Cookie 头信息来设置 Cookie 信息，可选项中设置了 Cookie 的其他属性，如过期时间 Expires，域名 Domain，路径 Path。这些信息设置在 **"Content-type:text/html"** 之前。

------

## 检索Cookie信息

Cookie信息检索页非常简单，Cookie信息存储在CGI的环境变量HTTP_COOKIE中，存储格式如下：

```
key1=value1;key2=value2;key3=value3....
```

以下是一个简单的CGI检索cookie信息的程序：

## 实例

\#!/usr/bin/python3

 \# 导入模块
 **import** os
 **import** http.cookies

 **print** ("Content-type: text/html")
 **print** ()

 **print** ("""
 <html>
 <head>
 <meta charset="utf-8">
 <title>菜鸟教程(runoob.com)</title>
 </head>
 <body>
 <h1>读取cookie信息</h1>
 """)

 **if** 'HTTP_COOKIE' **in** os.environ:
   cookie_string=os.environ.get('HTTP_COOKIE')
   c= http.cookies.SimpleCookie()
   \# c=Cookie.SimpleCookie()
   c.load(cookie_string)

   **try**:
     data=c['name'].value
     **print** ("cookie data: "+data+"<br>")
   **except** KeyError:
     **print** ("cookie 没有设置或者已过去<br>")
 **print** ("""
 </body>
 </html>
 """)

将以上代码保存到 cookie_get.py，并修改 cookie_get.py 权限：

```
chmod 755 cookie_get.py
```

以上 cookie 设置演示 Gif 如下所示：

![img](https://www.runoob.com/wp-content/uploads/2013/11/cookie.gif)

### 文件上传实例

HTML设置上传文件的表单需要设置 **enctype** 属性为 **multipart/form-data**，代码如下所示：

## 实例

<!DOCTYPE html> <html> <head> <meta charset="utf-8"> <title>菜鸟教程(runoob.com)</title> </head> <body>  <form enctype="multipart/form-data"                       action="/cgi-bin/save_file.py" method="post">    <p>选中文件: <input type="file" name="filename" /></p>    <p><input type="submit" value="上传" /></p>    </form> </body> </html>

save_file.py 脚本文件代码如下：

## 实例

\#!/usr/bin/python3

 **import** cgi, os
 **import** cgitb; cgitb.enable()

 form = cgi.FieldStorage()

 \# 获取文件名
 fileitem = form['filename']

 \# 检测文件是否上传
 **if** fileitem.filename:
   \# 设置文件路径 
   fn = os.path.basename(fileitem.filename)
   open('/tmp/' + fn, 'wb').write(fileitem.file.read())

   message = '文件 "' + fn + '" 上传成功'

 **else**:
   message = '文件没有上传'

 **print** ("""**\**
 Content-Type: text/html**\n**
 <html>
 <head>
 <meta charset="utf-8">
 <title>菜鸟教程(runoob.com)</title>
 </head>
 <body>
   <p>%s</p>
 </body>
 </html>
 """ % (message,))

将以上代码保存到 save_file.py，并修改 save_file.py 权限：

```
chmod 755 save_file.py
```

以上 cookie 设置演示 Gif 如下所示：

![img](https://www.runoob.com/wp-content/uploads/2013/11/savefile.gif)

如果你使用的系统是Unix/Linux，你必须替换文件分隔符，在window下只需要使用open()语句即可：

```
fn = os.path.basename(fileitem.filename.replace("\\", "/" ))
```

------

## 文件下载对话框

我们先在当前目录下创建 foo.txt 文件，用于程序的下载。

文件下载通过设置HTTP头信息来实现，功能代码如下：

## 实例

\#!/usr/bin/python3

 \# HTTP 头部
 **print** ("Content-Disposition: attachment; filename=**\"**foo.txt**\"**")
 **print** ()
 \# 打开文件
 fo = open("foo.txt", "rb")

 str = fo.read();
 **print** (str)

 \# 关闭文件
 fo.close()

## Python CGI编程

------

## 什么是CGI

CGI 目前由NCSA维护，NCSA定义CGI如下：

CGI(Common Gateway Interface),通用网关接口,它是一段程序,运行在服务器上如：HTTP服务器，提供同客户端HTML页面的接口。

------

## 网页浏览

为了更好的了解CGI是如何工作的，我们可以从在网页上点击一个链接或URL的流程：

- 1、使用你的浏览器访问URL并连接到HTTP web 服务器。
- 2、Web服务器接收到请求信息后会解析URL，并查找访问的文件在服务器上是否存在，如果存在返回文件的内容，否则返回错误信息。
- 3、浏览器从服务器上接收信息，并显示接收的文件或者错误信息。

CGI程序可以是Python脚本，PERL脚本，SHELL脚本，C或者C++程序等。

------

## CGI架构图

![cgiarch](https://atts.w3cschool.cn/attachments/image/Cgi01.png)

------

## Web服务器支持及配置

在你进行CGI编程前，确保您的Web服务器支持CGI及已经配置了CGI的处理程序。

Apache 支持CGI 配置：

设置好CGI目录：

```
ScriptAlias /cgi-bin/ /var/www/cgi-bin/
```

所有的HTTP服务器执行CGI程序都保存在一个预先配置的目录。这个目录被称为CGI目录，并按照惯例，它被命名为/var/www/cgi-bin目录。

CGI文件的扩展名为.cgi，python也可以使用.py扩展名。

默认情况下，Linux服务器配置运行的cgi-bin目录中为/var/www。

如果你想指定其他运行CGI脚本的目录，可以修改httpd.conf配置文件，如下所示：

```
<Directory "/var/www/cgi-bin">
   AllowOverride None
   Options +ExecCGI
   Order allow,deny
   Allow from all
</Directory>
```

在 AddHandler 中添加 .py 后缀，这样我们就可以访问 .py 结尾的 python 脚本文件：

```
AddHandler cgi-script .cgi .pl .py
```

------

## 第一个CGI程序

我们使用Python创建第一个CGI程序，文件名为hello.py，文件位于/var/www/cgi-bin目录中，内容如下：

```
#!/usr/bin/python3
#coding=utf-8
print ('<html>')
print ('<head>')
print ('<meta charset="utf-8">')
print ('<title>Hello Word - 我的第一个 CGI 程序！</title>')
print ('</head>')
print ('<body>')
print ('<h2>Hello Word! 我的第一CGI程序</h2>')
print ('</body>')
print ('</html>')
```

文件保存后修改 hello.py，修改文件权限为 755：

```
chmod 755 hello.py 
```

以上程序在浏览器访问显示结果如下：

![3E82A06B-FE1F-49B9-969C-183FABD56363](https://atts.w3cschool.cn/attachments/image/20180620/1529462971160746.jpg)

这个的hello.py脚本是一个简单的Python脚本，脚本第一行的输出内容"Content-type:text/html"发送到浏览器并告知浏览器显示的内容类型为"text/html"。

用 print 输出一个空行用于告诉服务器结束头部信息。

------

## HTTP头部

hello.py文件内容中的" Content-type:text/html"即为HTTP头部的一部分，它会发送给浏览器告诉浏览器文件的内容类型。

HTTP头部的格式如下：

```
HTTP 字段名: 字段内容
```

例如：

```
Content-type: text/html
```

以下表格介绍了CGI程序中HTTP头部经常使用的信息：

| 头                  | 描述                                                      |
| ------------------- | --------------------------------------------------------- |
| Content-type:       | 请求的与实体对应的MIME信息。例如: Content-type:text/html  |
| Expires: Date       | 响应过期的日期和时间                                      |
| Location: URL       | 用来重定向接收方到非请求URL的位置来完成请求或标识新的资源 |
| Last-modified: Date | 请求资源的最后修改时间                                    |
| Content-length: N   | 请求的内容长度                                            |
| Set-Cookie: String  | 设置Http Cookie                                           |

------

## CGI环境变量

所有的CGI程序都接收以下的环境变量，这些变量在CGI程序中发挥了重要的作用：

| 变量名          | 描述                                                         |
| --------------- | ------------------------------------------------------------ |
| CONTENT_TYPE    | 这个环境变量的值指示所传递来的信息的MIME类型。目前，环境变量CONTENT_TYPE一般都是：application/x-www-form-urlencoded,他表示数据来自于HTML表单。 |
| CONTENT_LENGTH  | 如果服务器与CGI程序信息的传递方式是POST，这个环境变量即使从标准输入STDIN中可以读到的有效数据的字节数。这个环境变量在读取所输入的数据时必须使用。 |
| HTTP_COOKIE     | 客户机内的 COOKIE 内容。                                     |
| HTTP_USER_AGENT | 提供包含了版本数或其他专有数据的客户浏览器信息。             |
| PATH_INFO       | 这个环境变量的值表示紧接在CGI程序名之后的其他路径信息。它常常作为CGI程序的参数出现。 |
| QUERY_STRING    | 如果服务器与CGI程序信息的传递方式是GET，这个环境变量的值即使所传递的信息。这个信息经跟在CGI程序名的后面，两者中间用一个问号'?'分隔。 |
| REMOTE_ADDR     | 这个环境变量的值是发送请求的客户机的IP地址，例如上面的192.168.1.67。这个值总是存在的。而且它是Web客户机需要提供给Web服务器的唯一标识，可以在CGI程序中用它来区分不同的Web客户机。 |
| REMOTE_HOST     | 这个环境变量的值包含发送CGI请求的客户机的主机名。如果不支持你想查询，则无需定义此环境变量。 |
| REQUEST_METHOD  | 提供脚本被调用的方法。对于使用 HTTP/1.0 协议的脚本，仅 GET 和 POST 有意义。 |
| SCRIPT_FILENAME | CGI脚本的完整路径                                            |
| SCRIPT_NAME     | CGI脚本的的名称                                              |
| SERVER_NAME     | 这是你的 WEB 服务器的主机名、别名或IP地址。                  |
| SERVER_SOFTWARE | 这个环境变量的值包含了调用CGI程序的HTTP服务器的名称和版本号。例如，上面的值为Apache/2.2.14(Unix) |

以下是一个简单的CGI脚本输出CGI的环境变量：

```
#!/usr/bin/python3
#coding=utf-8
import os

print ("Content-type: text/html")
print ()
print ("<meta charset=\"utf-8\">")
print ("<b>环境变量</b><br>")
print ("<ul>")
for key in os.environ.keys():
    print ("<li><span style='color:green'>%30s </span> : %s </li>" % (key,os.environ[key]))
print ("</ul>")
```

将以上点保存为 test.py ,并修改文件权限为 755，执行结果如下：

![img](https://atts.w3cschool.cn/attachments/image/0B7EB575-8393-43A0-949A-E46DCFB840FE.jpg)

------

## GET和POST方法

浏览器客户端通过两种方法向服务器传递信息，这两种方法就是 GET 方法和 POST 方法。

### 使用GET方法传输数据

GET方法发送编码后的用户信息到服务端，数据信息包含在请求页面的URL上，以"?"号分割, 如下所示：

```
http://www.test.com/cgi-bin/hello.py?key1=value1&key2=value2
```

有关 GET 请求的其他一些注释：

- GET 请求可被缓存
- GET 请求保留在浏览器历史记录中
- GET 请求可被收藏为书签
- GET 请求不应在处理敏感数据时使用
- GET 请求有长度限制
- GET 请求只应当用于取回数据

### 简单的url实例：GET方法

以下是一个简单的URL，使用GET方法向hello_get.py程序发送两个参数：

```
/cgi-bin/test.py?name=W3Cschool教程&url=http://www.w3cschool.cn
```

以下为hello_get.py文件的代码：

```
#!/usr/bin/python3
#coding=utf-8

# CGI处理模块
import cgi, cgitb 

# 创建 FieldStorage 的实例化
form = cgi.FieldStorage() 

# 获取数据
site_name = form.getvalue('name')
site_url  = form.getvalue('url')

print ("Content-type:text/html")
print ()
print ("<html>")
print ("<head>")
print ("<meta charset=\"utf-8\">")
print ("<title>W3Cschool教程 CGI 测试实例</title>")
print ("</head>")
print ("<body>")
print ("<h2>%s官网：%s</h2>" % (site_name, site_url))
print ("</body>")
print ("</html>")
```

文件保存后修改 hello_get.py，修改文件权限为 755：

```
chmod 755 hello_get.py 
```

浏览器请求输出结果：

![img](https://atts.w3cschool.cn/attachments/image/4C034008-B0B0-452F-AC97-C2BE37B9C7AF.jpg)

### 简单的表单实例：GET方法

以下是一个通过HTML的表单使用GET方法向服务器发送两个数据，提交的服务器脚本同样是hello_get.py文件，hello_get.html 代码如下：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<form action="/cgi-bin/hello_get.py" method="get">
站点名称: <input type="text" name="name">  <br />

站点 URL: <input type="text" name="url" />
<input type="submit" value="提交" />
</form>
</body>
</html>
```

默认情况下 cgi-bin 目录只能存放脚本文件，我们将 hello_get.html 存储在 test 目录下，修改文件权限为 755：

```
chmod 755 hello_get.html
```

Gif 演示如下所示：

![img](https://atts.w3cschool.cn/attachments/image/hello_get.gif)

### 使用POST方法传递数据

使用POST方法向服务器传递数据是更安全可靠的，像一些敏感信息如用户密码等需要使用POST传输数据。

以下同样是hello_get.py ，它也可以处理浏览器提交的POST表单数据:

```
#!/usr/bin/python3
#coding=utf-8

# CGI处理模块
import cgi, cgitb 

# 创建 FieldStorage 的实例化
form = cgi.FieldStorage() 

# 获取数据
site_name = form.getvalue('name')
site_url  = form.getvalue('url')

print ("Content-type:text/html")
print ()
print ("<html>")
print ("<head>")
print ("<meta charset=\"utf-8\">")
print ("<title>W3Cschool教程 CGI 测试实例</title>")
print ("</head>")
print ("<body>")
print ("<h2>%s官网：%s</h2>" % (site_name, site_url))
print ("</body>")
print ("</html>")
```

以下为表单通过POST方法（**method="post"**）向服务器脚本 hello_get.py 提交数据:

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<form action="/cgi-bin/hello_get.py" method="post">
站点名称: <input type="text" name="name">  <br />

站点 URL: <input type="text" name="url" />
<input type="submit" value="提交" />
</form>
</body>
</html>
</form>
```

Gif 演示如下所示：

![img](https://atts.w3cschool.cn/attachments/image/hello_post.gif)

### 通过CGI程序传递checkbox数据

checkbox用于提交一个或者多个选项数据，HTML代码如下：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<form action="/cgi-bin/checkbox.py" method="POST" target="_blank">
<input type="checkbox" name="youj" value="on" /> W3Cschool教程
<input type="checkbox" name="google" value="on" /> Google
<input type="submit" value="选择站点" />
</form>
</body>
</html>
```

以下为 checkbox.py 文件的代码：

```
#!/usr/bin/python3

# 引入 CGI 处理模块 
import cgi, cgitb 

# 创建 FieldStorage的实例 
form = cgi.FieldStorage() 

# 接收字段数据
if form.getvalue('google'):
   google_flag = "是"
else:
   google_flag = "否"

if form.getvalue('youj'):
   youj_flag = "是"
else:
   youj_flag = "否"

print ("Content-type:text/html")
print ()
print ("<html>")
print ("<head>")
print ("<meta charset=\"utf-8\">")
print ("<title>W3Cschool教程 CGI 测试实例</title>")
print ("</head>")
print ("<body>")
print ("<h2> W3Cschool教程是否选择了 : %s</h2>" % youj_flag)
print ("<h2> Google 是否选择了 : %s</h2>" % google_flag)
print ("</body>")
print ("</html>")
```

修改 checkbox.py 权限：

```
chmod 755 checkbox.py
```

浏览器访问 Gif 演示图：

![img](https://atts.w3cschool.cn/attachments/image/checkbox.gif)

### 通过CGI程序传递Radio数据

Radio 只向服务器传递一个数据，HTML代码如下：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<form action="/cgi-bin/radiobutton.py" method="post" target="_blank">
<input type="radio" name="site" value="youj" /> W3Cschool教程
<input type="radio" name="site" value="google" /> Google
<input type="submit" value="提交" />
</form>
</body>
</html>
```

radiobutton.py 脚本代码如下：

```
#!/usr/bin/python3

# 引入 CGI 处理模块 
import cgi, cgitb 

# 创建 FieldStorage的实例 
form = cgi.FieldStorage() 

# 接收字段数据
if form.getvalue('site'):
   site = form.getvalue('site')
else:
   site = "提交数据为空"

print ("Content-type:text/html")
print ()
print ("<html>")
print ("<head>")
print ("<meta charset=\"utf-8\">")
print ("<title>W3Cschool教程 CGI 测试实例</title>")
print ("</head>")
print ("<body>")
print ("<h2> 选中的网站是 %s</h2>" % site)
print ("</body>")
print ("</html>")
```

修改 radiobutton.py 权限：

```
chmod 755 radiobutton.py
```

浏览器访问 Gif 演示图：

![img](https://atts.w3cschool.cn/attachments/image/radiobutton.gif)

### 通过CGI程序传递 Textarea 数据

Textarea 向服务器传递多行数据，HTML代码如下：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<form action="/cgi-bin/textarea.py" method="post" target="_blank">
<textarea name="textcontent" cols="40" rows="4">
在这里输入内容...
</textarea>
<input type="submit" value="提交" />
</form>
</body>
</html>
```

textarea.py 脚本代码如下：

```
#!/usr/bin/python3

# 引入 CGI 处理模块 
import cgi, cgitb 

# 创建 FieldStorage的实例 
form = cgi.FieldStorage() 

# 接收字段数据
if form.getvalue('textcontent'):
   text_content = form.getvalue('textcontent')
else:
   text_content = "没有内容"

print ("Content-type:text/html")
print ()
print ("<html>")
print ("<head>")
print ("<meta charset=\"utf-8\">")
print ("<title>W3Cschool教程 CGI 测试实例</title>")
print ("</head>")
print ("<body>")
print ("<h2> 输入的内容是：%s</h2>" % text_content)
print ("</body>")
print ("</html>")
```

修改 textarea.py 权限：

```
chmod 755 textarea.py
```

浏览器访问 Gif 演示图：

![img](https://atts.w3cschool.cn/attachments/image/textarea.gif)

### 通过CGI程序传递下拉数据。

HTML 下拉框代码如下：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<form action="/cgi-bin/dropdown.py" method="post" target="_blank">
<select name="dropdown">
<option value="youj" selected>W3Cschool教程</option>
<option value="google">Google</option>
</select>
<input type="submit" value="提交"/>
</form>
</body>
</html>
```

dropdown.py 脚本代码如下所示：

```
#!/usr/bin/python3

# 引入 CGI 处理模块 
import cgi, cgitb 

# 创建 FieldStorage的实例 
form = cgi.FieldStorage() 

# 接收字段数据
if form.getvalue('dropdown'):
   dropdown_value = form.getvalue('dropdown')
else:
   dropdown_value = "没有内容"

print ("Content-type:text/html")
print ()
print ("<html>")
print ("<head>")
print ("<meta charset=\"utf-8\">")
print ("<title>W3Cschool教程 CGI 测试实例</title>")
print ("</head>")
print ("<body>")
print ("<h2> 选中的选项是：%s</h2>" % dropdown_value)
print ("</body>")
print ("</html>")
```

修改 dropdown.py 权限：

```
chmod 755 dropdown.py
```

浏览器访问 Gif 演示图：

![img](https://atts.w3cschool.cn/attachments/image/dropdown.gif)

------

## CGI中使用Cookie

在 http 协议一个很大的缺点就是不对用户身份的进行判断，这样给编程人员带来很大的不便，而 cookie 功能的出现弥补了这个不足。

 cookie 就是在客户访问脚本的同时，通过客户的浏览器，在客户硬盘上写入纪录数据 ，当下次客户访问脚本时取回数据信息，从而达到身份判别的功能，cookie 常用在身份校验中。

### cookie的语法

http cookie的发送是通过http头部来实现的，他早于文件的传递，头部set-cookie的语法如下：

```
Set-cookie:name=name;expires=date;path=path;domain=domain;secure 
```

-  **name=name:** 需要设置cookie的值(name不能使用"**;**"和"**,**"号),有多个name值时用 "**;**" 分隔，例如：**name1=name1;name2=name2;name3=name3**。 
- **expires=date:** cookie的有效期限,格式： expires="Wdy,DD-Mon-YYYY HH:MM:SS"
- 
- **path=path:** 设置cookie支持的路径,如果path是一个路径，则cookie对这个目录下的所有文件及子目录生效，例如：  path="/cgi-bin/"，如果path是一个文件，则cookie指对这个文件生效，例如：path="/cgi-bin/cookie.cgi"。
- **domain=domain:** 对cookie生效的域名，例如：domain="www.w3cschool.cn"
- **secure:** 如果给出此标志，表示cookie只能通过SSL协议的https服务器来传递。 
- cookie的接收是通过设置环境变量HTTP_COOKIE来实现的，CGI程序可以通过检索该变量获取cookie信息。

------

## Cookie设置 

Cookie的设置非常简单，cookie会在http头部单独发送。以下实例在cookie中设置了name 和 expires：

```
#!/usr/bin/python3
# 
print ('Content-Type: text/html')
print ('Set-Cookie: name="W3Cschool教程";expires=Wed, 28 Aug 2016 18:30:00 GMT')
print ()
print ("""
<html>
  <head>
    <meta charset="utf-8">
    <title>W3Cschool教程(w3cschool.cn)</title>
  </head>
    <body>
        <h1>Cookie set OK!</h1>
    </body>
</html>
""")
```

将以上代码保存到 cookie_set.py，并修改 cookie_set.py 权限：

```
chmod 755 cookie_set.py
```

以上实例使用了 Set-Cookie 头信息来设置Cookie信息，可选项中设置了Cookie的其他属性，如过期时间Expires，域名Domain，路径Path。这些信息设置在 "Content-type:text/html"之前。

------

## 检索Cookie信息

Cookie信息检索页非常简单，Cookie信息存储在CGI的环境变量HTTP_COOKIE中，存储格式如下：

```
key1=value1;key2=value2;key3=value3....
```

以下是一个简单的CGI检索cookie信息的程序：

```
#!/usr/bin/python3

# 导入模块
import os
import Cookie

print ("Content-type: text/html")
print ()

print ("""
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
<h1>读取cookie信息</h1>
""")

if 'HTTP_COOKIE' in os.environ:
    cookie_string=os.environ.get('HTTP_COOKIE')
    c=Cookie.SimpleCookie()
    c.load(cookie_string)

    try:
        data=c['name'].value
        print ("cookie data: "+data+"<br>")
    except KeyError:
        print ("cookie 没有设置或者已过去<br>")
print ("""
</body>
</html>
""")
```

将以上代码保存到 cookie_get.py，并修改 cookie_get.py 权限：

```
chmod 755 cookie_get.py
```

以上 cookie 设置颜色 Gif 如下所示：

![img](https://atts.w3cschool.cn/attachments/image/.gif)

### 文件上传实例

HTML设置上传文件的表单需要设置 **enctype** 属性为 **multipart/form-data**，代码如下所示：

```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
 <form enctype="multipart/form-data" 
                     action="/cgi-bin/save_file.py" method="post">
   <p>选中文件: <input type="file" name="filename" /></p>
   <p><input type="submit" value="上传" /></p>
   </form>
</body>
</html>
```

save_file.py脚本文件代码如下：

```
#!/usr/bin/python3

import cgi, os
import cgitb; cgitb.enable()

form = cgi.FieldStorage()

# 获取文件名
fileitem = form['filename']

# 检测文件是否上传
if fileitem.filename:
   # 设置文件路径 
   fn = os.path.basename(fileitem.filename)
   open('/tmp/' + fn, 'wb').write(fileitem.file.read())

   message = '文件 "' + fn + '" 上传成功'
   
else:
   message = '文件没有上传'
   
print ("""\
Content-Type: text/html\n
<html>
<head>
<meta charset="utf-8">
<title>W3Cschool教程(w3cschool.cn)</title>
</head>
<body>
   <p>%s</p>
</body>
</html>
""" % (message,))
```

将以上代码保存到 save_file.py，并修改 save_file.py 权限：

```
chmod 755 save_file.py
```

以上 cookie 设置颜色 Gif 如下所示：

![img](https://atts.w3cschool.cn/attachments/image/savefile.gif)

如果你使用的系统是Unix/Linux，你必须替换文件分隔符，在window下只需要使用open()语句即可：

```
fn = os.path.basename(fileitem.filename.replace("\\", "/" ))
```

------

## 文件下载对话框

我们先在当前目录下创建 foo.txt 文件，用于程序的下载。

文件下载通过设置HTTP头信息来实现，功能代码如下：

```
#!/usr/bin/python3

# HTTP 头部
print ("Content-Disposition: attachment; filename=\"foo.txt\"")
print ()
# 打开文件
fo = open("foo.txt", "rb")

str = fo.read();
print (str)

# 关闭文件
fo.close()
```



# Python3 网络编程

## Python3 网络编程

Python 提供了两个级别访问的网络服务。：

- 低级别的网络服务支持基本的 Socket，它提供了标准的 BSD Sockets API，可以访问底层操作系统Socket接口的全部方法。
- 高级别的网络服务模块 SocketServer， 它提供了服务器中心类，可以简化网络服务器的开发。

------

## 什么是 Socket?

Socket又称"套接字"，应用程序通常通过"套接字"向网络发出请求或者应答网络请求，使主机间或者一台计算机上的进程间可以通讯。

------

## socket()函数

Python 中，我们用 socket（）函数来创建套接字，语法格式如下：

```
socket.socket([family[, type[, proto]]])
```

### 参数

- family: 套接字家族可以使AF_UNIX或者AF_INET
- type: 套接字类型可以根据是面向连接的还是非连接分为`SOCK_STREAM`或`SOCK_DGRAM`
- protocol: 一般不填默认为0.

### Socket 对象(内建)方法

| 函数                                 | 描述                                                         |
| ------------------------------------ | ------------------------------------------------------------ |
| 服务器端套接字                       |                                                              |
| s.bind()                             | 绑定地址（host,port）到套接字， 在AF_INET下,以元组（host,port）的形式表示地址。 |
| s.listen()                           | 开始TCP监听。backlog指定在拒绝连接之前，操作系统可以挂起的最大连接数量。该值至少为1，大部分应用程序设为5就可以了。 |
| s.accept()                           | 被动接受TCP客户端连接,(阻塞式)等待连接的到来                 |
| 客户端套接字                         |                                                              |
| s.connect()                          | 主动初始化TCP服务器连接，。一般address的格式为元组（hostname,port），如果连接出错，返回socket.error错误。 |
| s.connect_ex()                       | connect()函数的扩展版本,出错时返回出错码,而不是抛出异常      |
| 公共用途的套接字函数                 |                                                              |
| s.recv()                             | 接收TCP数据，数据以字符串形式返回，bufsize指定要接收的最大数据量。flag提供有关消息的其他信息，通常可以忽略。 |
| s.send()                             | 发送TCP数据，将string中的数据发送到连接的套接字。返回值是要发送的字节数量，该数量可能小于string的字节大小。 |
| s.sendall()                          | 完整发送TCP数据，完整发送TCP数据。将string中的数据发送到连接的套接字，但在返回之前会尝试发送所有数据。成功返回None，失败则抛出异常。 |
| s.recvform()                         | 接收UDP数据，与recv()类似，但返回值是（data,address）。其中data是包含接收数据的字符串，address是发送数据的套接字地址。 |
| s.sendto()                           | 发送UDP数据，将数据发送到套接字，address是形式为（ipaddr，port）的元组，指定远程地址。返回值是发送的字节数。 |
| s.close()                            | 关闭套接字                                                   |
| s.getpeername()                      | 返回连接套接字的远程地址。返回值通常是元组（ipaddr,port）。  |
| s.getsockname()                      | 返回套接字自己的地址。通常是一个元组(ipaddr,port)            |
| s.setsockopt(level,optname,value)    | 设置给定套接字选项的值。                                     |
| s.getsockopt(level,optname[.buflen]) | 返回套接字选项的值。                                         |
| s.settimeout(timeout)                | 设置套接字操作的超时期，timeout是一个浮点数，单位是秒。值为None表示没有超时期。一般，超时期应该在刚创建套接字时设置，因为它们可能用于连接的操作（如connect()） |
| s.gettimeout()                       | 返回当前超时期的值，单位是秒，如果没有设置超时期，则返回None。 |
| s.fileno()                           | 返回套接字的文件描述符。                                     |
| s.setblocking(flag)                  | 如果flag为0，则将套接字设为非阻塞模式，否则将套接字设为阻塞模式（默认值）。非阻塞模式下，如果调用recv()没有发现任何数据，或send()调用无法立即发送数据，那么将引起socket.error异常。 |
| s.makefile()                         | 创建一个与该套接字相关连的文件                               |

------

## 简单实例

### 服务端

我们使用 socket 模块的 **socket** 函数来创建一个 socket 对象。socket 对象可以通过调用其他函数来设置一个 socket 服务。

现在我们可以通过调用 **bind(hostname, port)** 函数来指定服务的 *port(端口)*。

接着，我们调用 socket 对象的 *accept* 方法。该方法等待客户端的连接，并返回 *connection* 对象，表示已连接到客户端。

完整代码如下：

```
#!/usr/bin/python3
# 文件名：server.py

# 导入 socket、sys 模块
import socket
import sys

# 创建 socket 对象
serversocket = socket.socket(
            socket.AF_INET, socket.SOCK_STREAM) 

# 获取本地主机名
host = socket.gethostname()

port = 9999

# 绑定端口
serversocket.bind((host, port))

# 设置最大连接数，超过后排队
serversocket.listen(5)

while True:
    # 建立客户端连接
    clientsocket,addr = serversocket.accept()      

    print("连接地址: %s" % str(addr))
    
    msg='欢迎访问W3Cschool教程！'+ "\r\n"
    clientsocket.send(msg.encode('utf-8'))
    clientsocket.close()
```

### 客户端

接下来我们写一个简单的客户端实例连接到以上创建的服务。端口号为 12345。

**socket.connect(hosname, port )** 方法打开一个 TCP 连接到主机为 *hostname* 端口为 *port* 的服务商。连接后我们就可以从服务端后期数据，记住，操作完成后需要关闭连接。

完整代码如下：

```
#!/usr/bin/python3
# 文件名：client.py

# 导入 socket、sys 模块
import socket
import sys

# 创建 socket 对象
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 

# 获取本地主机名
host = socket.gethostname() 

# 设置端口好
port = 9999

# 连接服务，指定主机和端口
s.connect((host, port))

# 接收小于 1024 字节的数据
msg = s.recv(1024)

s.close()

print (msg.decode('utf-8'))
```

现在我们打开连个终端，第一个终端执行 server.py 文件：

```
$ python3 server.py
```

第二个终端执行 client.py 文件：

```
$ python3 client.py 
欢迎访问W3Cschool教程！
```

这是我们再打开第一个终端，就会看到有以下信息输出：

```
连接地址： ('192.168.0.118', 33397)
```

------

## Python Internet 模块

以下列出了 Python 网络编程的一些重要模块：

| 协议   | 功能用处                         | 端口号 | Python 模块                |
| ------ | -------------------------------- | ------ | -------------------------- |
| HTTP   | 网页访问                         | 80     | httplib, urllib, xmlrpclib |
| NNTP   | 阅读和张贴新闻文章，俗称为"帖子" | 119    | nntplib                    |
| FTP    | 文件传输                         | 20     | ftplib, urllib             |
| SMTP   | 发送邮件                         | 25     | smtplib                    |
| POP3   | 接收邮件                         | 110    | poplib                     |
| IMAP4  | 获取邮件                         | 143    | imaplib                    |
| Telnet | 命令行                           | 23     | telnetlib                  |
| Gopher | 信息查找                         | 70     | gopherlib, urllib          |

更多内容可以参阅官网的 [Python Socket Library and Modules](https://docs.python.org/3.0/library/socket.html)。

# Python3 SMTP发送邮件

## Python3 SMTP发送邮件

SMTP（Simple Mail Transfer Protocol）即简单邮件传输协议,它是一组用于由源地址到目的地址传送邮件的规则，由它来控制信件的中转方式。

python的smtplib提供了一种很方便的途径发送电子邮件。它对smtp协议进行了简单的封装。

Python创建 SMTP 对象语法如下：

```
import smtplib

smtpObj = smtplib.SMTP( [host [, port [, local_hostname]]] )
```

参数说明：

-  host:  SMTP 服务器主机。 你可以指定主机的ip地址或者域名如:w3cschool.cn，这个是可选参数。 
-  port: 如果你提供了 host 参数, 你需要指定 SMTP 服务使用的端口号，一般情况下SMTP端口号为25。  
-  local_hostname: 如果SMTP在你的本机上，你只需要指定服务器地址为 localhost 即可。 

Python SMTP对象使用sendmail方法发送邮件，语法如下：

```
SMTP.sendmail(from_addr, to_addrs, msg[, mail_options, rcpt_options]
```

参数说明：

-  from_addr:  邮件发送者地址。 
-  to_addrs: 字符串列表，邮件发送地址。 
-  msg: 发送消息 

这里要注意一下第三个参数，msg是字符串，表示邮件。我们知道邮件一般由标题，发信人，收件人，邮件内容，附件等构成，发送邮件的时候，要注意msg的格式。这个格式就是smtp协议中定义的格式。

### 实例

以下是一个使用Python发送邮件简单的实例：

```
#!/usr/bin/python3

import smtplib
from email.mime.text import MIMEText
from email.header import Header

sender = 'from@w3cschool.cn'
receivers = ['429240967@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

# 三个参数：第一个为文本内容，第二个 plain 设置文本格式，第三个 utf-8 设置编码
message = MIMEText('Python 邮件发送测试...', 'plain', 'utf-8')
message['From'] = Header("W3Cschool教程", 'utf-8')
message['To'] =  Header("测试", 'utf-8')

subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')


try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message.as_string())
    print ("邮件发送成功")
except smtplib.SMTPException:
    print ("Error: 无法发送邮件")
```

我们使用三个引号来设置邮件信息，标准邮件需要三个头部信息： **From**, **To**, 和 **Subject** ，每个信息直接使用空行分割。

我们通过实例化 smtplib 模块的 SMTP 对象 *smtpObj* 来连接到 SMTP 访问，并使用 *sendmail* 方法来发送信息。

执行以上程序，如果你本机安装sendmail，就会输出：

```
$ python3 test.py 
邮件发送成功
```

查看我们的收件箱(一般在垃圾箱)，就可以查看到邮件信息：

![img](https://atts.w3cschool.cn/attachments/image/smtp1.jpg)

如果我们本机没有 sendmail 访问，也可以使用其他服务商的 SMTP 访问（QQ、网易、Google等）。

```
#!/usr/bin/python3

import smtplib
from email.mime.text import MIMEText
from email.header import Header

# 第三方 SMTP 服务
mail_host="smtp.XXX.com"  #设置服务器
mail_user="XXXX"    #用户名
mail_pass="XXXXXX"   #口令 


sender = 'from@w3cschool.cn'
receivers = ['429240967@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

message = MIMEText('Python 邮件发送测试...', 'plain', 'utf-8')
message['From'] = Header("W3Cschool教程", 'utf-8')
message['To'] =  Header("测试", 'utf-8')

subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')


try:
    smtpObj = smtplib.SMTP() 
    smtpObj.connect(mail_host, 25)    # 25 为 SMTP 端口号
    smtpObj.login(mail_user,mail_pass)
    smtpObj.sendmail(sender, receivers, message.as_string())
    print ("邮件发送成功")
except smtplib.SMTPException:
    print ("Error: 无法发送邮件")
```

------

## 使用Python发送HTML格式的邮件

Python发送HTML格式的邮件与发送纯文本消息的邮件不同之处就是将MIMEText中_subtype设置为html。具体代码如下：

```
#!/usr/bin/python3

import smtplib
from email.mime.text import MIMEText
from email.header import Header

sender = 'from@w3cschool.cn'
receivers = ['429240967@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

mail_msg = """
<p>Python 邮件发送测试...</p>
<p><a href="http://www.w3cschool.cn">这是一个链接</a></p>
"""
message = MIMEText(mail_msg, 'html', 'utf-8')
message['From'] = Header("W3Cschool教程", 'utf-8')
message['To'] =  Header("测试", 'utf-8')

subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')


try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message.as_string())
    print ("邮件发送成功")
except smtplib.SMTPException:
    print ("Error: 无法发送邮件")
```

执行以上程序，如果你本机安装sendmail，就会输出：

```
$ python3 test.py 
邮件发送成功
```

查看我们的收件箱(一般在垃圾箱)，就可以查看到邮件信息：

![img](https://atts.w3cschool.cn/attachments/image/smtp2.jpg)

------

## Python 发送带附件的邮件

发送带附件的邮件，首先要创建MIMEMultipart()实例，然后构造附件，如果有多个附件，可依次构造，最后利用smtplib.smtp发送。

```
#!/usr/bin/python3

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.header import Header

sender = 'from@w3cschool.cn'
receivers = ['429240967@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

#创建一个带附件的实例
message = MIMEMultipart()
message['From'] = Header("W3Cschool教程", 'utf-8')
message['To'] =  Header("测试", 'utf-8')
subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')

#邮件正文内容
message.attach(MIMEText('这是W3Cschool教程Python 邮件发送测试……', 'plain', 'utf-8'))

# 构造附件1，传送当前目录下的 test.txt 文件
att1 = MIMEText(open('test.txt', 'rb').read(), 'base64', 'utf-8')
att1["Content-Type"] = 'application/octet-stream'
# 这里的filename可以任意写，写什么名字，邮件中显示什么名字
att1["Content-Disposition"] = 'attachment; filename="test.txt"'
message.attach(att1)

# 构造附件2，传送当前目录下的 w3cschool.txt 文件
att2 = MIMEText(open('w3cschool.txt', 'rb').read(), 'base64', 'utf-8')
att2["Content-Type"] = 'application/octet-stream'
att2["Content-Disposition"] = 'attachment; filename="w3cschool.txt"'
message.attach(att2)

try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message.as_string())
    print ("邮件发送成功")
except smtplib.SMTPException:
    print ("Error: 无法发送邮件")
$ python3 test.py 
邮件发送成功
```

查看我们的收件箱(一般在垃圾箱)，就可以查看到邮件信息：

![img](https://atts.w3cschool.cn/attachments/image/smtp3.jpg)

------

## 在 HTML 文本中添加图片

邮件的 HTML 文本中一般邮件服务商添加外链是无效的，正确添加突破的实例如下所示：

```
#!/usr/bin/python3

import smtplib
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header

sender = 'from@w3cschool.cn'
receivers = ['429240967@qq.com']  # 接收邮件，可设置为你的QQ邮箱或者其他邮箱

msgRoot = MIMEMultipart('related')
msgRoot['From'] = Header("W3Cschool教程", 'utf-8')
msgRoot['To'] =  Header("测试", 'utf-8')
subject = 'Python SMTP 邮件测试'
msgRoot['Subject'] = Header(subject, 'utf-8')

msgAlternative = MIMEMultipart('alternative')
msgRoot.attach(msgAlternative)


mail_msg = """
<p>Python 邮件发送测试...</p>
<p><a href="http://www.w3cschool.cn">W3Cschool教程链接</a></p>
<p>图片演示：</p>
<p><img src="cid:image1"></p>
"""
msgAlternative.attach(MIMEText(mail_msg, 'html', 'utf-8'))

# 指定图片为当前目录
fp = open('test.png', 'rb')
msgImage = MIMEImage(fp.read())
fp.close()

# 定义图片 ID，在 HTML 文本中引用
msgImage.add_header('Content-ID', '<image1>')
msgRoot.attach(msgImage)

try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, msgRoot.as_string())
    print ("邮件发送成功")
except smtplib.SMTPException:
    print ("Error: 无法发送邮件")
$ python3 test.py 
邮件发送成功
```

查看我们的收件箱(如果在垃圾箱可能需要移动到收件箱才可正常显示)，就可以查看到邮件信息：

![img](https://atts.w3cschool.cn/attachments/image/smtp4.jpg)

更多内容请参阅：https://docs.python.org/3/library/email-examples.html。

# Python3 多线程

## Python3 多线程

多线程类似于同时执行多个不同程序，多线程运行有如下优点：

- 使用线程可以把占据长时间的程序中的任务放到后台去处理。
- 用户界面可以更加吸引人，这样比如用户点击了一个按钮去触发某些事件的处理，可以弹出一个进度条来显示处理的进度
- 程序的运行速度可能加快
- 在一些等待的任务实现上如用户输入、文件读写和网络收发数据等，线程就比较有用了。在这种情况下我们可以释放一些珍贵的资源如内存占用等等。

线程在执行过程中与进程还是有区别的。每个独立的线程有一个程序运行的入口、顺序执行序列和程序的出口。但是线程不能够独立执行，必须依存在应用程序中，由应用程序提供多个线程执行控制。 

每个线程都有他自己的一组CPU寄存器，称为线程的上下文，该上下文反映了线程上次运行该线程的CPU寄存器的状态。 

指令指针和堆栈指针寄存器是线程上下文中两个最重要的寄存器，线程总是在进程得到上下文中运行的，这些地址都用于标志拥有线程的进程地址空间中的内存。 

- 线程可以被抢占（中断）。
- 在其他线程正在运行时，线程可以暂时搁置（也称为睡眠） -- 这就是线程的退让。 

线程可以分为:

- **内核线程：**由操作系统内核创建和撤销。
- **用户线程：**不需要内核支持而在用户程序中实现的线程。

Python3 线程中常用的两个模块为：

- **_thread**
- **threading(推荐使用)**

 thread 模块已被废弃。用户可以使用 threading 模块代替。所以，在 Python3 中不能再使用"thread" 模块。为了兼容性，Python3 将 thread 重命名为 "_thread"。 



## 开始学习Python线程

Python中使用线程有两种方式：函数或者用类来包装线程对象。

函数式：调用 _thread 模块中的start_new_thread()函数来产生新线程。语法如下:

```
_thread.start_new_thread ( function, args[, kwargs] )
```

参数说明:

- function - 线程函数。
- args - 传递给线程函数的参数,他必须是个tuple类型。
- kwargs - 可选参数。

实例：

```
#!/usr/bin/python3

import _thread
import time

# 为线程定义一个函数
def print_time( threadName, delay):
   count = 0
   while count < 5:
      time.sleep(delay)
      count += 1
      print ("%s: %s" % ( threadName, time.ctime(time.time()) ))

# 创建两个线程
try:
   _thread.start_new_thread( print_time, ("Thread-1", 2, ) )
   _thread.start_new_thread( print_time, ("Thread-2", 4, ) )
except:
   print ("Error: 无法启动线程")

while 1:
   pass
```

执行以上程序输出结果如下：

```
Thread-1: Wed Apr  6 11:36:31 2016
Thread-1: Wed Apr  6 11:36:33 2016
Thread-2: Wed Apr  6 11:36:33 2016
Thread-1: Wed Apr  6 11:36:35 2016
Thread-1: Wed Apr  6 11:36:37 2016
Thread-2: Wed Apr  6 11:36:37 2016
Thread-1: Wed Apr  6 11:36:39 2016
Thread-2: Wed Apr  6 11:36:41 2016
Thread-2: Wed Apr  6 11:36:45 2016
Thread-2: Wed Apr  6 11:36:49 2016
```

执行以上程后可以按下 ctrl-c to 退出。

 

------

## 线程模块

Python3 通过两个标准库 _thread 和 threading 提供对线程的支持。

 _thread 提供了低级别的、原始的线程以及一个简单的锁，它相比于 threading 模块的功能还是比较有限的。

threading 模块除了包含 _thread 模块中的所有方法外，还提供的其他方法： 

- threading.currentThread(): 返回当前的线程变量。 
- threading.enumerate(): 返回一个包含正在运行的线程的list。正在运行指线程启动后、结束前，不包括启动前和终止后的线程。 
- threading.activeCount(): 返回正在运行的线程数量，与len(threading.enumerate())有相同的结果。

除了使用方法外，线程模块同样提供了Thread类来处理线程，Thread类提供了以下方法:

- **run():** 用以表示线程活动的方法。

- start():

  启动线程活动。

  

-  **join([time]):** 等待至线程中止。这阻塞调用线程直至线程的join() 方法被调用中止-正常退出或者抛出未处理的异常-或者是可选的超时发生。

-  **isAlive():** 返回线程是否活动的。

-  **getName():** 返回线程名。

-  **setName():** 设置线程名。

------

## 使用 threading 模块创建线程

我们可以通过直接从 threading.Thread 继承创建一个新的子类，并实例化后调用 start() 方法启动新线程，即它调用了线程的 run()  方法：

```
#!/usr/bin/python3

import threading
import time

exitFlag = 0

class myThread (threading.Thread):
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
    def run(self):
        print ("开始线程：" + self.name)
        print_time(self.name, self.counter, 5)
        print ("退出线程：" + self.name)

def print_time(threadName, delay, counter):
    while counter:
        if exitFlag:
            threadName.exit()
        time.sleep(delay)
        print ("%s: %s" % (threadName, time.ctime(time.time())))
        counter -= 1

# 创建新线程
thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 2)

# 开启新线程
thread1.start()
thread2.start()
thread1.join()
thread2.join()
print ("退出主线程")
```

以上程序执行结果如下；

```
开始线程：Thread-1
开始线程：Thread-2
Thread-1: Wed Apr  6 11:46:46 2016
Thread-1: Wed Apr  6 11:46:47 2016
Thread-2: Wed Apr  6 11:46:47 2016
Thread-1: Wed Apr  6 11:46:48 2016
Thread-1: Wed Apr  6 11:46:49 2016
Thread-2: Wed Apr  6 11:46:49 2016
Thread-1: Wed Apr  6 11:46:50 2016
退出线程：Thread-1
Thread-2: Wed Apr  6 11:46:51 2016
Thread-2: Wed Apr  6 11:46:53 2016
Thread-2: Wed Apr  6 11:46:55 2016
退出线程：Thread-2
退出主线程
```

------

## 线程同步

如果多个线程共同对某个数据修改，则可能出现不可预料的结果，为了保证数据的正确性，需要对多个线程进行同步。 

 使用 Thread 对象的 Lock 和 Rlock 可以实现简单的线程同步，这两个对象都有 acquire 方法和 release 方法，对于那些需要每次只允许一个线程操作的数据，可以将其操作放到 acquire 和 release 方法之间。如下： 

多线程的优势在于可以同时运行多个任务（至少感觉起来是这样）。但是当线程需要共享数据时，可能存在数据不同步的问题。

 考虑这样一种情况：一个列表里所有元素都是0，线程"set"从后向前把所有元素改成1，而线程"print"负责从前往后读取列表并打印。

 那么，可能线程"set"开始改的时候，线程"print"便来打印列表了，输出就成了一半0一半1，这就是数据的不同步。为了避免这种情况，引入了锁的概念。 

 锁有两种状态——锁定和未锁定。每当一个线程比如"set"要访问共享数据时，必须先获得锁定；如果已经有别的线程比如"print"获得锁定了，那么就让线程"set"暂停，也就是同步阻塞；等到线程"print"访问完毕，释放锁以后，再让线程"set"继续。 

 经过这样的处理，打印列表时要么全部输出0，要么全部输出1，不会再出现一半0一半1的尴尬场面。

实例：

```
#!/usr/bin/python3

import threading
import time

class myThread (threading.Thread):
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
    def run(self):
        print ("开启线程： " + self.name)
        # 获取锁，用于线程同步
        threadLock.acquire()
        print_time(self.name, self.counter, 3)
        # 释放锁，开启下一个线程
        threadLock.release()

def print_time(threadName, delay, counter):
    while counter:
        time.sleep(delay)
        print ("%s: %s" % (threadName, time.ctime(time.time())))
        counter -= 1

threadLock = threading.Lock()
threads = []

# 创建新线程
thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 2)

# 开启新线程
thread1.start()
thread2.start()

# 添加线程到线程列表
threads.append(thread1)
threads.append(thread2)

# 等待所有线程完成
for t in threads:
    t.join()
print ("退出主线程")
```

执行以上程序，输出结果为：

```
开启线程： Thread-1
开启线程： Thread-2
Thread-1: Wed Apr  6 11:52:57 2016
Thread-1: Wed Apr  6 11:52:58 2016
Thread-1: Wed Apr  6 11:52:59 2016
Thread-2: Wed Apr  6 11:53:01 2016
Thread-2: Wed Apr  6 11:53:03 2016
Thread-2: Wed Apr  6 11:53:05 2016
退出主线程
```

------

## 线程优先级队列（ Queue） 

Python 的 Queue 模块中提供了同步的、线程安全的队列类，包括FIFO（先入先出)队列Queue，LIFO（后入先出）队列LifoQueue，和优先级队列 PriorityQueue。 

这些队列都实现了锁原语，能够在多线程中直接使用，可以使用队列来实现线程间的同步。

Queue 模块中的常用方法:

 

- Queue.qsize() 返回队列的大小 
- Queue.empty() 如果队列为空，返回True,反之False 
- Queue.full() 如果队列满了，返回True,反之False
- Queue.full 与 maxsize 大小对应 
- Queue.get([block[, timeout]])获取队列，timeout等待时间 
- Queue.get_nowait() 相当Queue.get(False)
- Queue.put(item) 写入队列，timeout等待时间 
- Queue.put_nowait(item) 相当Queue.put(item, False)
- Queue.task_done() 在完成一项工作之后，Queue.task_done()函数向任务已经完成的队列发送一个信号
- Queue.join() 实际上意味着等到队列为空，再执行别的操作

实例:

```
#!/usr/bin/python3

import queue
import threading
import time

exitFlag = 0

class myThread (threading.Thread):
    def __init__(self, threadID, name, q):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.q = q
    def run(self):
        print ("开启线程：" + self.name)
        process_data(self.name, self.q)
        print ("退出线程：" + self.name)

def process_data(threadName, q):
    while not exitFlag:
        queueLock.acquire()
        if not workQueue.empty():
            data = q.get()
            queueLock.release()
            print ("%s processing %s" % (threadName, data))
        else:
            queueLock.release()
        time.sleep(1)

threadList = ["Thread-1", "Thread-2", "Thread-3"]
nameList = ["One", "Two", "Three", "Four", "Five"]
queueLock = threading.Lock()
workQueue = queue.Queue(10)
threads = []
threadID = 1

# 创建新线程
for tName in threadList:
    thread = myThread(threadID, tName, workQueue)
    thread.start()
    threads.append(thread)
    threadID += 1

# 填充队列
queueLock.acquire()
for word in nameList:
    workQueue.put(word)
queueLock.release()

# 等待队列清空
while not workQueue.empty():
    pass

# 通知线程是时候退出
exitFlag = 1

# 等待所有线程完成
for t in threads:
    t.join()
print ("退出主线程")
```

以上程序执行结果：

```
开启线程：Thread-1
开启线程：Thread-2
开启线程：Thread-3
Thread-3 processing One
Thread-1 processing Two
Thread-2 processing Three
Thread-3 processing Four
Thread-1 processing Five
退出线程：Thread-3
退出线程：Thread-2
退出线程：Thread-1
退出主线程
```

 Python3 XML解析

## Python3 XML解析

------

## 什么是XML？

XML 指可扩展标记语言（e**X**tensible **M**arkup **L**anguage），标准通用标记语言的子集，是一种用于标记电子文件使其具有结构性的标记语言。 你可以通过本站学习[XML教程](https://www.w3cschool.cn/xml/) 

XML 被设计用来传输和存储数据。

XML是一套定义语义标记的规则，这些标记将文档分成许多部件并对这些部件加以标识。

它也是元标记语言，即定义了用于定义其他与特定领域有关的、语义的、结构化的标记语言的句法语言。

------

## python对XML的解析

常见的XML编程接口有DOM和SAX，这两种接口处理XML文件的方式不同，当然使用场合也不同。

python有三种方法解析XML，SAX，DOM，以及ElementTree:

### 1.SAX (simple API for XML )

python 标准库包含SAX解析器，SAX用事件驱动模型，通过在解析XML的过程中触发一个个的事件并调用用户定义的回调函数来处理XML文件。

### 2.DOM(Document Object Model)

将XML数据在内存中解析成一个树，通过对树的操作来操作XML。

本章节使用到的XML实例文件movies.xml内容如下：

```
<collection shelf="New Arrivals">
<movie title="Enemy Behind">
   <type>War, Thriller</type>
   <format>DVD</format>
   <year>2003</year>
   <rating>PG</rating>
   <stars>10</stars>
   <description>Talk about a US-Japan war</description>
</movie>
<movie title="Transformers">
   <type>Anime, Science Fiction</type>
   <format>DVD</format>
   <year>1989</year>
   <rating>R</rating>
   <stars>8</stars>
   <description>A schientific fiction</description>
</movie>
   <movie title="Trigun">
   <type>Anime, Action</type>
   <format>DVD</format>
   <episodes>4</episodes>
   <rating>PG</rating>
   <stars>10</stars>
   <description>Vash the Stampede!</description>
</movie>
<movie title="Ishtar">
   <type>Comedy</type>
   <format>VHS</format>
   <rating>PG</rating>
   <stars>2</stars>
   <description>Viewable boredom</description>
</movie>
</collection>
```

------

## python使用SAX解析xml

SAX是一种基于事件驱动的API。

利用SAX解析XML文档牵涉到两个部分:解析器和事件处理器。

解析器负责读取XML文档,并向事件处理器发送事件,如元素开始跟元素结束事件;

而事件处理器则负责对事件作出相应,对传递的XML数据进行处理。    

# Python3 JSON 数据解析

## Python3 JSON 数据解析

JSON (JavaScript Object Notation)  是一种轻量级的数据交换格式。它基于ECMAScript的一个子集。

Python3 中可以使用 json 模块来对 JSON 数据进行编解码，它包含了两个函数：

- **json.dumps():** 对数据进行编码。
- **json.loads():** 对数据进行解码。

 在json的编解码过程中，python 的原始类型与json类型会相互转换，具体的转化对照如下：

### Python 编码为 JSON 类型转换对应表：

| Python                                 | JSON   |
| -------------------------------------- | ------ |
| dict                                   | object |
| list, tuple                            | array  |
| str                                    | string |
| int, float, int- & float-derived Enums | number |
| True                                   | true   |
| False                                  | false  |
| None                                   | null   |

### JSON 解码为 Python 类型转换对应表：

| JSON          | Python |
| ------------- | ------ |
| object        | dict   |
| array         | list   |
| string        | str    |
| number (int)  | int    |
| number (real) | float  |
| true          | True   |
| false         | False  |
| null          | None   |

### json.dumps 与 json.loads 实例

以下实例演示了 Python 数据结构转换为JSON：

```
#!/usr/bin/python3

import json

# Python 字典类型转换为 JSON 对象
data = {
    'no' : 1,
    'name' : 'W3CSchool',
    'url' : 'http://www.w3cschool.cn'
}

json_str = json.dumps(data)
print ("Python 原始数据：", repr(data))
print ("JSON 对象：", json_str)
```

执行以上代码输出结果为：

```
Python 原始数据： {'url': 'http://www.w3cschool.cn', 'no': 1, 'name': 'W3CSchool'}
JSON 对象： {"url": "http://www.w3cschool.cn", "no": 1, "name": "W3CSchool"}
```

通过输出的结果可以看出，简单类型通过编码后跟其原始的repr()输出结果非常相似。

接着以上实例，我们可以将一个JSON编码的字符串转换回一个Python数据结构：

```
#!/usr/bin/python3

import json

# Python 字典类型转换为 JSON 对象
data1 = {
    'no' : 1,
    'name' : 'W3CSchool',
    'url' : 'http://www.w3cschool.cn'
}

json_str = json.dumps(data1)
print ("Python 原始数据：", repr(data1))
print ("JSON 对象：", json_str)

# 将 JSON 对象转换为 Python 字典
data2 = json.loads(json_str)
print ("data2['name']: ", data2['name'])
print ("data2['url']: ", data2['url'])
```

执行以上代码输出结果为：

```
ython 原始数据： {'name': 'W3CSchool', 'no': 1, 'url': 'http://www.w3cschool.cn'}
JSON 对象： {"name": "W3CSchool", "no": 1, "url": "http://www.w3cschool.cn"}
data2['name']:  W3CSchool
data2['url']:  http://www.w3cschool.cn
```

如果你要处理的是文件而不是字符串，你可以使用 **json.dump()** 和 **json.load()** 来编码和解码JSON数据。例如：

```
# 写入 JSON 数据
with open('data.json', 'w') as f:
    json.dump(data, f)

# 读取数据
with open('data.json', 'r') as f:
    data = json.load(f)
```

更多资料请参考：https://docs.python.org/3/library/json.html			 		 		

# Python3 日期和时间

## Python3  日期和时间

Python 程序能用很多方式处理日期和时间，转换日期格式是一个常见的功能。

Python 提供了一个 time 和 calendar 模块可以用于格式化日期和时间。

时间间隔是以秒为单位的浮点小数。

每个时间戳都以自从1970年1月1日午夜（历元）经过了多长时间来表示。

Python 的 time 模块下有很多函数可以转换常见日期格式。如函数time.time()用于获取当前时间戳, 如下实例:



```
#!/usr/bin/python3import time;  # 引入time模块ticks = time.time()print ("当前时间戳为:", ticks)
```

以上实例输出结果：

```
当前时间戳为: 1459996086.7115328
```

时间戳单位最适于做日期运算。但是1970年之前的日期就无法以此表示了。太遥远的日期也不行，UNIX和Windows只支持到2038年。



------

## 什么是时间元组？

很多Python函数用一个元组装起来的9组数字处理时间:

| 序号 | 字段         | 值                                   |
| ---- | ------------ | ------------------------------------ |
| 0    | 4位数年      | 2008                                 |
| 1    | 月           | 1 到 12                              |
| 2    | 日           | 1到31                                |
| 3    | 小时         | 0到23                                |
| 4    | 分钟         | 0到59                                |
| 5    | 秒           | 0到61 (60或61 是闰秒)                |
| 6    | 一周的第几日 | 0到6 (0是周一)                       |
| 7    | 一年的第几日 | 1到366 (儒略历)                      |
| 8    | 夏令时       | -1, 0, 1, -1是决定是否为夏令时的旗帜 |

上述也就是struct_time元组。这种结构具有如下属性：

| 序号 | 属性     | 值                                                           |
| ---- | -------- | ------------------------------------------------------------ |
| 0    | tm_year  | 2008                                                         |
| 1    | tm_mon   | 1 到 12                                                      |
| 2    | tm_mday  | 1 到 31                                                      |
| 3    | tm_hour  | 0 到 23                                                      |
| 4    | tm_min   | 0 到 59                                                      |
| 5    | tm_sec   | 0 到 61 (60或61 是闰秒)                                      |
| 6    | tm_wday  | 0到6 (0是周一)                                               |
| 7    | tm_yday  | 一年中的第几天，1 到 366                                     |
| 8    | tm_isdst | 是否为夏令时，值有：1(夏令时)、0(不是夏令时)、-1(未知)，默认 -1 |



------

## 获取当前时间

从返回浮点数的时间辍方式向时间元组转换，只要将浮点数传递给如localtime之类的函数。

```
#!/usr/bin/python3import timelocaltime = time.localtime(time.time())print ("本地时间为 :", localtime)
```

以上实例输出结果：

```
本地时间为 : time.struct_time(tm_year=2016, tm_mon=4, tm_mday=7, tm_hour=10, tm_min=28, tm_sec=49, tm_wday=3, tm_yday=98, tm_isdst=0)
```



------

## 获取格式化的时间

你可以根据需求选取各种格式，但是最简单的获取可读的时间模式的函数是asctime():

```
#!/usr/bin/python3import timelocaltime = time.asctime( time.localtime(time.time()) )print ("本地时间为 :", localtime)
```

以上实例输出结果：

```
本地时间为 : Thu Apr  7 10:29:13 2016
```

------

## 格式化日期

我们可以使用 time 模块的 strftime 方法来格式化日期，：

```
time.strftime(format[, t])
#!/usr/bin/python3import time# 格式化成2016-03-20 11:45:39形式print
    (time.strftime("%Y-%m-%d %H:%M:%S", time
        .localtime()))# 格式化成Sat Mar 28 22:24:24 2016形式print 
            (time.strftime("%a %b %d %H:%M:%S %Y", time.
                localtime()))  # 将格式字符串转换为时间戳a = "Sat Mar 28 22:24:24 2016"
                    print (time.mktime(time.
                        strptime(a,"%a %b %d %H:%M:%S %Y")))
                            
```

以上实例输出结果：

```
2016-04-07 10:29:46Thu Apr 07 10:29:46 20161459175064.0
```

python中时间日期格式化符号：

- %y 两位数的年份表示（00-99）
- %Y 四位数的年份表示（000-9999）
- %m 月份（01-12）
- %d 月内中的一天（0-31）
- %H 24小时制小时数（0-23）
- %I 12小时制小时数（01-12）
- %M 分钟数（00=59）
- %S 秒（00-59）
- %a 本地简化星期名称
- %A 本地完整星期名称
- %b 本地简化的月份名称
- %B 本地完整的月份名称
- %c 本地相应的日期表示和时间表示
- %j 年内的一天（001-366）
- %p 本地A.M.或P.M.的等价符
- %U 一年中的星期数（00-53）星期天为星期的开始
- %w 星期（0-6），星期天为星期的开始
- %W 一年中的星期数（00-53）星期一为星期的开始
- %x 本地相应的日期表示
- %X 本地相应的时间表示
- %Z 当前时区的名称
- %% %号本身

------

## 获取某月日历

Calendar模块有很广泛的方法用来处理年历和月历，例如打印某月的月历：

```
#!/usr/bin/python3import calendarcal = calendar.month(2016, 1)print ("以下输出2016年1月份的日历:")print (cal)
```

以上实例输出结果：

```
以下输出2016年1月份的日历:        January 2016Mo Tu We Th Fr Sa Su                         1  2  3 4  5  6  7  8  9  1011 12 13 14 15 16 1718 19 20 21 22 23 2425 26 27 28 29 30 31
```



------

## Time 模块

Time 模块包含了以下内置函数，既有时间处理相的，也有转换时间格式的：

| 序号 | 函数及描述                                                   | 实例                                                         |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | time.altzone                                             返回格林威治西部的夏令时地区的偏移秒数。如果该地区在格林威治东部会返回负值（如西欧，包括英国）。对夏令时启用地区才能使用。 | 以下实例展示了 altzone()函数的使用方法：`>>> import time>>> print ("time.altzone %d " % time.altzone)time.altzone -28800 ` |
| 2    | time.asctime([tupletime])                                             接受时间元组并返回一个可读的形式为"Tue Dec 11 18:07:14 2008"（2008年12月11日 周二18时07分14秒）的24个字符的字符串。 | 以下实例展示了 asctime()函数的使用方法：`>>> import time>>> t = time.localtime()>>> print ("time.asctime(t): %s " % time.asctime(t))time.asctime(t): Thu Apr  7 10:36:20 2016 ` |
| 3    | [time.clock()](https://www.w3cschool.cn/python3/python3-att-time-clock.html)                                             用以浮点数计算的秒数返回当前的CPU时间。用来衡量不同程序的耗时，比time.time()更有用。 | [实例](https://www.w3cschool.cn/python3/python3-att-time-clock.html) |
| 4    | time.ctime([secs])                                             作用相当于asctime(localtime(secs))，未给参数相当于asctime() | 以下实例展示了 ctime()函数的使用方法：`>>> import time>>> print ("time.ctime() : %s" % time.ctime())time.ctime() : Thu Apr  7 10:51:58 2016` |
| 5    | time.gmtime([secs])                                             接收时间辍（1970纪元后经过的浮点秒数）并返回格林威治天文时间下的时间元组t。注：t.tm_isdst始终为0 | 以下实例展示了 gmtime()函数的使用方法：`>>> import time>>> print ("gmtime :", time.gmtime(1455508609.34375))gmtime : time.struct_time(tm_year=2016, tm_mon=2, tm_mday=15, tm_hour=3, tm_min=56, tm_sec=49, tm_wday=0, tm_yday=46, tm_isdst=0)` |
| 6    | time.localtime([secs]                                             接收时间辍（1970纪元后经过的浮点秒数）并返回当地时间下的时间元组t（t.tm_isdst可取0或1，取决于当地当时是不是夏令时）。 | 以下实例展示了 localtime()函数的使用方法：`>>> import time>>> print ("localtime(): ", time.localtime(1455508609.34375))localtime():  time.struct_time(tm_year=2016, tm_mon=2, tm_mday=15, tm_hour=11, tm_min=56, tm_sec=49, tm_wday=0, tm_yday=46, tm_isdst=0)` |
| 7    | [time.mktime(tupletime)](https://www.w3cschool.cn/python3/python3-att-time-mktime-html.html)                                             接受时间元组并返回时间辍（1970纪元后经过的浮点秒数）。 | [实例](https://www.w3cschool.cn/python3/python3-att-time-mktime-html.html) |
| 8    | time.sleep(secs)                                             推迟调用线程的运行，secs指秒数。 | 以下实例展示了 sleep()函数的使用方法：`#!/usr/bin/python3import timeprint ("Start : %s" % time.ctime())time.sleep( 5 )print ("End : %s" % time.ctime())` |
| 9    | time.strftime(fmt[,tupletime])                                             接收以时间元组，并返回以可读字符串表示的当地时间，格式由fmt决定。 | 以下实例展示了 strftime()函数的使用方法：`>>> import time>>> print (time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))2016-04-07 11:18:05` |
| 10   | time.strptime(str,fmt='%a %b %d %H:%M:%S %Y')                                             根据fmt的格式把一个时间字符串解析为时间元组。 | 以下实例展示了 strftime()函数的使用方法：`>>> import time>>> struct_time = time.strptime("30 Nov 00", "%d %b %y")>>> print ("返回元组: ", struct_time)返回元组:  time.struct_time(tm_year=2000, tm_mon=11, tm_mday=30, tm_hour=0, tm_min=0, tm_sec=0, tm_wday=3, tm_yday=335, tm_isdst=-1)` |
| 11   | time.time( )                                             返回当前时间的时间戳（1970纪元后经过的浮点秒数）。 | 以下实例展示了 time()函数的使用方法：`>>> import time>>> print(time.time())1459999336.1963577` |
| 12   | [time.tzset()](https://www.w3cschool.cn/python3/python3-att-time-tzset-html.html)                                             根据环境变量TZ重新初始化时间相关设置。 | [实例](https://www.w3cschool.cn/python3/python3-att-time-tzset-html.html) |

Time模块包含了以下2个非常重要的属性：

| 序号 | 属性及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | **time.timezone**                                             属性time.timezone是当地时区（未启动夏令时）距离格林威治的偏移秒数（>0，美洲;<=0大部分欧洲，亚洲，非洲）。 |
| 2    | **time.tzname**                                             属性time.tzname包含一对根据情况的不同而不同的字符串，分别是带夏令时的本地时区名称，和不带的。 |



------

## 日历（Calendar）模块

此模块的函数都是日历相关的，例如打印某月的字符月历。

星期一是默认的每周第一天，星期天是默认的最后一天。更改设置需调用calendar.setfirstweekday()函数。模块包含了以下内置函数：

| 序号 | 函数及描述                                                   |
| ---- | ------------------------------------------------------------ |
| 1    | **calendar.calendar(year,w=2,l=1,c=6)**                                             返回一个多行字符串格式的year年年历，3个月一行，间隔距离为c。 每日宽度间隔为w字符。每行长度为21* W+18+2* C。l是每星期行数。 |
| 2    | **calendar.firstweekday( )**                                             返回当前每周起始日期的设置。默认情况下，首次载入calendar模块时返回0，即星期一。 |
| 3    | **calendar.isleap(year)**                                             是闰年返回True，否则为false。 |
| 4    | **calendar.leapdays(y1,y2)**                                             返回在Y1，Y2两年之间的闰年总数。 |
| 5    | **calendar.month(year,month,w=2,l=1)**                                             返回一个多行字符串格式的year年month月日历，两行标题，一周一行。每日宽度间隔为w字符。每行的长度为7* w+6。l是每星期的行数。 |
| 6    | **calendar.monthcalendar(year,month)**                                             返回一个整数的单层嵌套列表。每个子列表装载代表一个星期的整数。Year年month月外的日期都设为0;范围内的日子都由该月第几日表示，从1开始。 |
| 7    | **calendar.monthrange(year,month)**                                             返回两个整数。第一个是该月的星期几的日期码，第二个是该月的日期码。日从0（星期一）到6（星期日）;月从1到12。 |
| 8    | **calendar.prcal(year,w=2,l=1,c=6)**                                             相当于 print calendar.calendar(year,w,l,c). |
| 9    | **calendar.prmonth(year,month,w=2,l=1)**                                             相当于 print calendar.calendar（year，w，l，c）。 |
| 10   | **calendar.setfirstweekday(weekday)**                                             设置每周的起始日期码。0（星期一）到6（星期日）。 |
| 11   | **calendar.timegm(tupletime)**                                             和time.gmtime相反：接受一个时间元组形式，返回该时刻的时间辍（1970纪元后经过的浮点秒数）。 |
| 12   | **calendar.weekday(year,month,day)**                                             返回给定日期的日期码。0（星期一）到6（星期日）。月份为 1（一月） 到 12（12月）。 |



------

## 其他相关模块和函数

在Python中，其他处理日期和时间的模块还有：

- [time 模块](https://docs.python.org/3/library/time.html)                                
- [datetime模块](https://docs.python.org/3/library/datetime.html)                                

# Python3 内置函数

## Python3 内置函数

本节介绍了Python3中的内置函数。

|                                                              |                                                              | 内置函数                                                     |                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [abs()](https://www.w3cschool.cn/python3/python3-func-abs.html) | [dict()](https://www.w3cschool.cn/python/python-func-dict.html) | [help()](https://www.w3cschool.cn/python/python-func-help.html) | [min()](https://www.w3cschool.cn/python3/python3-func-number-min.html) | [setattr()](https://www.w3cschool.cn/python/python-func-setattr.html) |
| [all()](https://www.w3cschool.cn/python/python-func-all.html) | [dir()](https://www.w3cschool.cn/python/python-func-dir.html) | [hex()](https://www.w3cschool.cn/python3/python3-func-hex.html) | [next()](https://www.w3cschool.cn/python/python-func-next.html) | [slice()](https://www.w3cschool.cn/python/python-func-slice.html) |
| [any()](https://www.w3cschool.cn/python/python-func-any.html) | [divmod()](https://www.w3cschool.cn/python/python-func-divmod.html) | [id()](https://www.w3cschool.cn/python/python-func-id.html)  | object()                                                     | [sorted()](https://www.w3cschool.cn/python3/python3-func-sorted.html) |
| [ascii()](https://www.w3cschool.cn/python3/python3-func-ascii.html) | [enumerate()](https://www.w3cschool.cn/python3/python3-func-enumerate.html) | [input()](https://www.w3cschool.cn/python3/python3-func-input.html) | [oct()](https://www.w3cschool.cn/python/python-func-oct.html) | [staticmethod()](https://www.w3cschool.cn/python/python-func-staticmethod.html) |
| [bin()](https://www.w3cschool.cn/python/python-func-bin.html) | [eval()](https://www.w3cschool.cn/python/python-func-eval.html) | [int()](https://www.w3cschool.cn/python/python-func-int.html) | [open()](https://www.w3cschool.cn/python3/python3-func-open.html) | [str()](https://www.w3cschool.cn/python/python-func-str.html) |
| [bool()](https://www.w3cschool.cn/python/python-func-bool.html) | [exec()](https://www.w3cschool.cn/python3/python3-func-exec.html) | [isinstance()](https://www.w3cschool.cn/python/python-func-isinstance.html) | [ord()](https://www.w3cschool.cn/python3/python3-func-ord.html) | [sum()](https://www.w3cschool.cn/python/python-func-sum.html) |
| [bytearray()](https://www.w3cschool.cn/python/python-func-bytearray.html) | [filter()](https://www.w3cschool.cn/python3/python3-func-filter.html) | [issubclass()](https://www.w3cschool.cn/python/python-func-issubclass.html) | [pow()](https://www.w3cschool.cn/python3/python3-func-number-pow.html) | [super()](https://www.w3cschool.cn/python/python-func-super.html) |
| [bytes()](https://www.w3cschool.cn/python3/python3-func-bytes.html) | [float()](https://www.w3cschool.cn/python/python-func-float.html) | [iter()](https://www.w3cschool.cn/python/python-func-iter.html) | [print()](https://www.w3cschool.cn/python/python-func-print.html) | [tuple()](https://www.w3cschool.cn/python3/python3-func-tuple.html) |
| [callable()](https://www.w3cschool.cn/python/python-func-callable.html) | [format()](https://www.w3cschool.cn/python/att-string-format.html) | [len()](https://www.w3cschool.cn/python3/python3-string-len.html) | [property()](https://www.w3cschool.cn/python/python-func-property.html) | [type()](https://www.w3cschool.cn/python/python-func-type.html) |
| [chr()](https://www.w3cschool.cn/python3/python3-func-chr-html.html) | [frozenset()](https://www.w3cschool.cn/python/python-func-frozenset.html) | [list()](https://www.w3cschool.cn/python3/python3-att-list-list.html) | [range()](https://www.w3cschool.cn/python3/python3-func-range.html) | [vars()](https://www.w3cschool.cn/python/python-func-vars.html) |
| [classmethod()](https://www.w3cschool.cn/python/python-func-classmethod.html) | [getattr()](https://www.w3cschool.cn/python/python-func-getattr.html) | [locals()](https://www.w3cschool.cn/python/python-func-locals.html) | [repr()](https://www.w3cschool.cn/python/python-func-repr.html) | [zip()](https://www.w3cschool.cn/python3/python3-func-zip.html) |
| [compile()](https://www.w3cschool.cn/python/python-func-compile.html) | [globals()](https://www.w3cschool.cn/python/python-func-globals.html) | [map()](https://www.w3cschool.cn/python/python-func-map.html) | [reversed()](https://www.w3cschool.cn/python3/python3-func-reversed.html) | [__import__()](https://www.w3cschool.cn/python/python-func-__import__.html) |
| [complex()](https://www.w3cschool.cn/python/python-func-complex.html) | [hasattr()](https://www.w3cschool.cn/python/python-func-hasattr.html) | [max()](https://www.w3cschool.cn/python3/python3-func-number-max.html) | [round()](https://www.w3cschool.cn/python3/python3-func-number-round.html) |                                                              |
| [delattr()](https://www.w3cschool.cn/python/python-func-delattr.html) | [hash()](https://www.w3cschool.cn/python/python-func-hash.html) | [memoryview()](https://www.w3cschool.cn/python/python-func-memoryview.html) | [set()](https://www.w3cschool.cn/python/python-func-set.html) |                                                              |

# Python MongoDB

MongoDB 是目前最流行的 NoSQL 数据库之一，使用的数据类型 BSON（类似 JSON）。

MongoDB 数据库安装与介绍可以查看我们的 [MongoDB 教程。](https://www.runoob.com/mongodb/mongodb-tutorial.html)

------

## PyMongo

Python 要连接 MongoDB 需要 MongoDB 驱动，这里我们使用 PyMongo 驱动来连接。

### pip 安装

pip 是一个通用的 Python 包管理工具，提供了对 Python 包的查找、下载、安装、卸载的功能。

安装 pymongo:

```
$ python3 -m pip3 install pymongo
```

也可以指定安装的版本:

```
$ python3 -m pip3 install pymongo==3.5.1
```

更新 pymongo 命令：

```
$ python3 -m pip3 install --upgrade pymongo
```

### easy_install 安装

旧版的 Python 可以使用 easy_install 来安装，easy_install 也是 Python 包管理工具。

```
$ python -m easy_install pymongo
```

更新 pymongo 命令：

```
$ python -m easy_install -U pymongo
```

### 测试 PyMongo

接下来我们可以创建一个测试文件 demo_test_mongodb.py，代码如下：

## demo_test_mongodb.py 文件代码：

\#!/usr/bin/python3  import pymongo

执行以上代码文件，如果没有出现错误，表示安装成功。

------

## 创建数据库

### 创建一个数据库

创建数据库需要使用 MongoClient 对象，并且指定连接的 URL 地址和要创建的数据库名。

如下实例中，我们创建的数据库 runoobdb : 

## 实例

\#!/usr/bin/python3  import pymongo  myclient = pymongo.MongoClient("mongodb://localhost:27017/") mydb = myclient["runoobdb"]

> **注意:** 在 MongoDB 中，数据库只有在内容插入后才会创建! 就是说，数据库创建后要创建集合(数据表)并插入一个文档(记录)，数据库才会真正创建。

### 判断数据库是否已存在

我们可以读取 MongoDB 中的所有数据库，并判断指定的数据库是否存在：

## 实例

\#!/usr/bin/python3  import pymongo  myclient = pymongo.MongoClient('mongodb://localhost:27017/')  dblist = myclient.list_database_names() # dblist = myclient.database_names()  if "runoobdb" in dblist:  print("数据库已存在！")

> **注意：**database_names 在最新版本的 Python 中已废弃，Python3.7+ 之后的版本改为了 list_database_names()。

------

## 创建集合

MongoDB 中的集合类似 SQL 的表。

### 创建一个集合

MongoDB 使用数据库对象来创建集合，实例如下：

## 实例

\#!/usr/bin/python3  import pymongo  myclient = pymongo.MongoClient("mongodb://localhost:27017/") mydb = myclient["runoobdb"]  mycol = mydb["sites"]

> **注意:** 在 MongoDB 中，集合只有在内容插入后才会创建! 就是说，创建集合(数据表)后要再插入一个文档(记录)，集合才会真正创建。

### 判断集合是否已存在

我们可以读取 MongoDB 数据库中的所有集合，并判断指定的集合是否存在：

## 实例

\#!/usr/bin/python3  import pymongo  myclient = pymongo.MongoClient('mongodb://localhost:27017/')  mydb = myclient['runoobdb']  collist = mydb. list_collection_names() # collist = mydb.collection_names() if "sites" in collist:   # 判断 sites 集合是否存在  print("集合已存在！")

> **注意：**collection_names 在最新版本的 Python 中已废弃，Python3.7+ 之后的版本改为了 list_collection_names()。

------

## 增、删、改、查等操作

下表列出了 MongoDB 的更多操作，详情可点击具体链接：

| 序号 | 功能                                                         |
| ---- | ------------------------------------------------------------ |
| 1    | [添加数据](https://www.runoob.com/python3/python-mongodb-insert-document.html) |
| 2    | [查询数据](https://www.runoob.com/python3/python-mongodb-query-document.html) |
| 3    | [修改数据](https://www.runoob.com/python3/python-mongodb-update-document.html) |
| 4    | [数据排序](https://www.runoob.com/python3/python-mongodb-sort.html) |
| 5    | [删除数据](https://www.runoob.com/python3/python-mongodb-delete-document.html) |

​			

# Python urllib

Python urllib 库用于操作网页 URL，并对网页的内容进行抓取处理。

本文主要介绍 Python3 的 urllib。

urllib 包 包含以下几个模块：

- urllib.request - 打开和读取 URL。
- urllib.error - 包含 urllib.request 抛出的异常。
- urllib.parse - 解析 URL。
- urllib.robotparser - 解析 robots.txt 文件。

![img](https://www.runoob.com/wp-content/uploads/2021/04/ulrib-py3.svg)

------

## urllib.request

urllib.request 定义了一些打开 URL 的函数和类，包含授权验证、重定向、浏览器 cookies等。

urllib.request 可以模拟浏览器的一个请求发起过程。

我们可以使用 urllib.request 的 urlopen 方法来打开一个 URL，语法格式如下：

```
urllib.request.urlopen(url, data=None, [timeout, ]*, cafile=None, capath=None, cadefault=False, context=None)
```

- **url**：url 地址。
- **data**：发送到服务器的其他数据对象，默认为 None。
- **timeout**：设置访问超时时间。
- **cafile 和 capath**：cafile 为 CA 证书， capath 为 CA 证书的路径，使用 HTTPS 需要用到。
- **cadefault**：已经被弃用。
- **context**：ssl.SSLContext类型，用来指定 SSL 设置。

实例如下：

## 实例

**from** urllib.request **import** urlopen

 myURL = urlopen("https://www.runoob.com/")
 **print**(myURL.read())

以上代码使用 urlopen 打开一个 URL，然后使用 read() 函数获取网页的 HTML 实体代码。

read() 是读取整个网页内容，我们可以指定读取的长度：

## 实例

**from** urllib.request **import** urlopen

 myURL = urlopen("https://www.runoob.com/")
 **print**(myURL.read(300))

除了 read() 函数外，还包含以下两个读取网页内容的函数：

- **readline()** - 读取文件的一行内容

  ```
  from urllib.request import urlopen
  
  myURL = urlopen("https://www.runoob.com/")
  print(myURL.readline()) #读取一行内容
  ```

- **readlines()** - 读取文件的全部内容，它会把读取的内容赋值给一个列表变量。

  ```
  from urllib.request import urlopen
  
  myURL = urlopen("https://www.runoob.com/")
  lines = myURL.readlines()
  for line in lines:
      print(line) 
  ```

我们在对网页进行抓取时，经常需要判断网页是否可以正常访问，这里我们就可以使用 getcode() 函数获取网页状态码，返回 200 说明网页正常，返回 404 说明网页不存在:

## 实例

**import** urllib.request

 myURL1 = urllib.request.urlopen("https://www.runoob.com/")
 **print**(myURL1.getcode())  # 200

 **try**:
   myURL2 = urllib.request.urlopen("https://www.runoob.com/no.html")
 **except** urllib.error.HTTPError **as** e:
   **if** e.code == 404:
     **print**(404)  # 404

更多网页状态码可以查阅：https://www.runoob.com/http/http-status-codes.html。

如果要将抓取的网页保存到本地，可以使用 [Python3 File write() 方法](https://www.runoob.com/python3/python3-file-write.html) 函数：

## 实例

**from** urllib.request **import** urlopen

 myURL = urlopen("https://www.runoob.com/")
 f = open("runoob_urllib_test.html", "wb")
 content = myURL.read()  # 读取网页内容
 f.write(content)
 f.close()

执行以上代码，在本地就会生成一个 runoob_urllib_test.html 文件，里面包含了 https://www.runoob.com/ 网页的内容。

更多Python File 处理，可以参阅：https://www.runoob.com/python3/python3-file-methods.html

。

URL 的编码与解码可以使用 **urllib.request.quote()** 与 **urllib.request.unquote()** 方法：

## 实例

**import** urllib.request 

 encode_url = urllib.request.quote("https://www.runoob.com/")  # 编码
 **print**(encode_url)

 unencode_url = urllib.request.unquote(encode_url)   # 解码
 **print**(unencode_url)

输出结果为：

```
https%3A//www.runoob.com/
https://www.runoob.com/
```

### 模拟头部信息

我们抓取网页一般需要对 headers（网页头信息）进行模拟，这时候需要使用到 urllib.request.Request 类：

```
class urllib.request.Request(url, data=None, headers={}, origin_req_host=None, unverifiable=False, method=None)
```

- **url**：url 地址。
- **data**：发送到服务器的其他数据对象，默认为 None。
- **headers**：HTTP 请求的头部信息，字典格式。
- **origin_req_host**：请求的主机地址，IP 或域名。
- **unverifiable**：很少用整个参数，用于设置网页是否需要验证，默认是False。。
- **method**：请求方法， 如 GET、POST、DELETE、PUT等。

## 实例 - py3_urllib_test.php 文件代码

**import** urllib.request
 **import** urllib.parse

 url = 'https://www.runoob.com/?s='  # 菜鸟教程搜索页面
 keyword = 'Python 教程' 
 key_code = urllib.request.quote(keyword)  # 对请求进行编码
 url_all = url+key_code
 header = {
   'User-Agent':'Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
 }  #头部信息
 request = urllib.request.Request(url_all,headers=header)
 reponse = urllib.request.urlopen(request).read()

 fh = open("./urllib_test_runoob_search.html","wb")   # 将文件写入到当前目录中
 fh.write(reponse)
 fh.close()

打开 urllib_test_runoob_search.html 文件（可以使用浏览器打开），内容如下：

![img](https://www.runoob.com/wp-content/uploads/2021/04/6BD0D456-E929-4C11-9118-F09C85AEA427.jpg)

表单 POST 传递数据，我们先创建一个表单，代码如下，我这里使用了 PHP 代码来获取表单的数据：

## 实例

<!DOCTYPE html>
 <**html**>
 <**head**>
 <**meta** charset="utf-8">
 <**title**>菜鸟教程(runoob.com) urllib POST  测试</**title**>
 </**head**>
 <**body**>
 <**form** action="" method="post" name="myForm">
   Name: <**input** type="text" name="name"><**br**>
   Tag: <**input** type="text" name="tag"><**br**>
   <**input** type="submit" value="提交">
 </**form**>
 <**hr**>
 <?php
 // 使用 PHP 来获取表单提交的数据，你可以换成其他的
 if(isset($_POST['name']) && $_POST['tag'] ) {
   echo $_POST["name"] . ', ' . $_POST['tag'];
 }
 ?>
 </**body**>
 </**html**>

## 实例

**import** urllib.request
 **import** urllib.parse

 url = 'https://www.runoob.com/try/py3/py3_urllib_test.php'  # 提交到表单页面
 data = {'name':'RUNOOB', 'tag' : '菜鸟教程'}  # 提交数据
 header = {
   'User-Agent':'Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
 }  #头部信息
 data = urllib.parse.urlencode(data).encode('utf8')  # 对参数进行编码，解码使用 urllib.parse.urldecode
 request=urllib.request.Request(url, data, header)  # 请求处理
 reponse=urllib.request.urlopen(request).read()    # 读取结果

 fh = open("./urllib_test_post_runoob.html","wb")   # 将文件写入到当前目录中
 fh.write(reponse)
 fh.close()

打开 urllib_test_post_runoob.html 文件（可以使用浏览器打开），显示结果如下：

![img](https://www.runoob.com/wp-content/uploads/2021/04/CFE5A0A5-6E9C-4CBF-B866-0C559F239DF8.jpg)

------

## urllib.error

urllib.error 模块为 urllib.request 所引发的异常定义了异常类，基础异常类是 URLError。

urllib.error 包含了两个方法，URLError 和 HTTPError。

URLError 是 OSError 的一个子类，用于处理程序在遇到问题时会引发此异常（或其派生的异常），包含的属性 reason 为引发异常的原因。

HTTPError 是 URLError 的一个子类，用于处理特殊 HTTP 错误例如作为认证请求的时候，包含的属性 code 为 HTTP 的状态码， reason 为引发异常的原因，headers 为导致 HTTPError 的特定 HTTP 请求的 HTTP 响应头。

对不存在的网页抓取并处理异常:

## 实例

**import** urllib.request
 **import** urllib.error

 myURL1 = urllib.request.urlopen("https://www.runoob.com/")
 **print**(myURL1.getcode())  # 200

 **try**:
   myURL2 = urllib.request.urlopen("https://www.runoob.com/no.html")
 **except** urllib.error.HTTPError **as** e:
   **if** e.code == 404:
     **print**(404)  # 404



------

## urllib.parse

urllib.parse 用于解析 URL，格式如下：

```
urllib.parse.urlparse(urlstring, scheme='', allow_fragments=True)
```

urlstring 为 字符串的 url 地址，scheme 为协议类型，

allow_fragments 参数为 false，则无法识别片段标识符。相反，它们被解析为路径，参数或查询组件的一部分，并 fragment 在返回值中设置为空字符串。

## 实例

**from** urllib.parse **import** urlparse

 o = urlparse("https://www.runoob.com/?s=python+%E6%95%99%E7%A8%8B")
 **print**(o)

以上实例输出结果为：

```
ParseResult(scheme='https', netloc='www.runoob.com', path='/', params='', query='s=python+%E6%95%99%E7%A8%8B', fragment='')
```

从结果可以看出，内容是一个元组，包含 6 个字符串：协议，位置，路径，参数，查询，判断。

我们可以直接读取协议内容：

## 实例

**from** urllib.parse **import** urlparse

 o = urlparse("https://www.runoob.com/?s=python+%E6%95%99%E7%A8%8B")
 **print**(o.scheme)

以上实例输出结果为：

```
https
```

完整内容如下：

| 属性       | 索引 | 值                       | 值（如果不存在） |
| ---------- | ---- | ------------------------ | ---------------- |
| `scheme`   | 0    | URL协议                  | *scheme* 参数    |
| `netloc`   | 1    | 网络位置部分             | 空字符串         |
| `path`     | 2    | 分层路径                 | 空字符串         |
| `params`   | 3    | 最后路径元素的参数       | 空字符串         |
| `query`    | 4    | 查询组件                 | 空字符串         |
| `fragment` | 5    | 片段识别                 | 空字符串         |
| `username` |      | 用户名                   | `None`           |
| `password` |      | 密码                     | `None`           |
| `hostname` |      | 主机名（小写）           | `None`           |
| `port`     |      | 端口号为整数（如果存在） | `None`           |

------

## urllib.robotparser

urllib.robotparser 用于解析 robots.txt 文件。

robots.txt（统一小写）是一种存放于网站根目录下的 robots 协议，它通常用于告诉搜索引擎对网站的抓取规则。

urllib.robotparser 提供了 RobotFileParser 类，语法如下：

```
class urllib.robotparser.RobotFileParser(url='')
```

这个类提供了一些可以读取、解析 robots.txt 文件的方法：

- set_url(url) - 设置 robots.txt 文件的 URL。
- read() - 读取 robots.txt URL 并将其输入解析器。
- parse(lines) - 解析行参数。
- can_fetch(useragent, url) - 如果允许 useragent 按照被解析 robots.txt 文件中的规则来获取 url 则返回 True。
- mtime() -返回最近一次获取 robots.txt 文件的时间。 这适用于需要定期检查 robots.txt 文件更新情况的长时间运行的网页爬虫。
- modified() - 将最近一次获取 robots.txt 文件的时间设置为当前时间。
- crawl_delay(useragent) -为指定的 useragent 从 robots.txt 返回 Crawl-delay  形参。 如果此形参不存在或不适用于指定的 useragent 或者此形参的 robots.txt 条目存在语法错误，则返回 None。
- request_rate(useragent) -以 named tuple RequestRate(requests, seconds) 的形式从 robots.txt 返回 Request-rate 形参的内容。 如果此形参不存在或不适用于指定的 useragent  或者此形参的 robots.txt 条目存在语法错误，则返回 None。
- site_maps() - 以 list() 的形式从 robots.txt 返回 Sitemap 形参的内容。 如果此形参不存在或者此形参的 robots.txt 条目存在语法错误，则返回 None。

## 实例

\>>> **import** urllib.robotparser
 \>>> rp = urllib.robotparser.RobotFileParser()
 \>>> rp.set_url("http://www.musi-cal.com/robots.txt")
 \>>> rp.read()
 \>>> rrate = rp.request_rate("*")
 \>>> rrate.requests
 3
 \>>> rrate.seconds
 20
 \>>> rp.crawl_delay("*")
 6
 \>>> rp.can_fetch("*", "http://www.musi-cal.com/cgi-bin/search?city=San+Francisco")
 False
 \>>> rp.can_fetch("*", "http://www.musi-cal.com/")
 True





### Python 调试方法

**1、print** 

```
print('here')
# 可以发现某段逻辑是否执行
# 打印出变量的内容
```

**2、assert** 

```
assert false, 'blabla'
# 如果条件不成立，则打印出 'blabla' 并抛出AssertionError异常
```

**3、debugger** 

可以通过 pdb、IDE 等工具进行调试。

调试的具体方法这里不展开。

Python 中有两个内置方法在这里也很有帮助：

-  locals: 执行 locals() 之后, 返回一个字典, 包含(current scope)当前范围下的局部变量。
-  globals: 执行 globals() 之后, 返回一个字典, 包含(current scope)当前范围下的全局变量。

## 发行版

```bash
ActivePython
#由 ActiveState 发布的 Python 版本。内核与标准 Python 发布版本相同，包含了许多额外独立的可用工具。
CPython
# Python官方版本。这个解释器是用C语言开发的，所以叫CPython。使用最广。用>>>作为提示符
IPython
#基于CPython之上的一个交互式解释器。用In [序号]:作为提示符。
IronPython
# Jython 类似，是运行在微软 .Net 平台上的 Python 解释器，可以直接把 Python 代码编译成 .Net 的字节码。
Jython
#是运行在 Java 平台上的 Python 解释器，可以直接把 Python 代码编译成 Java 字节码执行。
PyPy
#目标是执行速度。采用JIT技术，对Python代码进行动态编译，可以显著提高Python代码的执行速度。绝大部分Python代码都可以在PyPy下运行，但是PyPy和CPython有一些是不同的，这就导致相同的Python代码在两种解释器下执行可能会有不同的结果。
Stackless Python
# 重新实现版本，基于原始的代码，包含一些重要的内部改动。允许深层次递归，而且多线程执行更加高效。
```

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

# Python3 operator 模块

Python2.x 版本中，使用 [cmp()](https://www.runoob.com/python/func-number-cmp.html) 函数来比较两个列表、数字或字符串等的大小关系。

Python 3.X 的版本中已经没有 cmp() 函数，如果你需要实现比较功能，需要引入 operator 模块，适合任何对象，包含的方法有：

## operator 模块包含的方法

operator.lt(a, b)
 operator.le(a, b)
 operator.eq(a, b)
 operator.ne(a, b)
 operator.ge(a, b)
 operator.gt(a, b)
 operator.__lt__(a, b)
 operator.__le__(a, b)
 operator.__eq__(a, b)
 operator.__ne__(a, b)
 operator.__ge__(a, b)
 operator.__gt__(a, b)

**operator.lt(a, b)** 与 **a < b** 相同， **operator.le(a, b)** 与 **a <= b** 相同，**operator.eq(a, b)** 与 **a == b** 相同，**operator.ne(a, b)** 与 **a != b** 相同，**operator.gt(a, b)** 与 **a > b** 相同，**operator.ge(a, b)** 与  **a >= b** 相同。

## 实例

\# 导入 operator 模块
 **import** operator

 \# 数字
 x = 10
 y = 20

 **print**("x:",x, ", y:",y)
 **print**("operator.lt(x,y): ", operator.lt(x,y))
 **print**("operator.gt(y,x): ", operator.gt(y,x))
 **print**("operator.eq(x,x): ", operator.eq(x,x))
 **print**("operator.ne(y,y): ", operator.ne(y,y))
 **print**("operator.le(x,y): ", operator.le(x,y))
 **print**("operator.ge(y,x): ", operator.ge(y,x))
 **print**()

 \# 字符串
 x = "Google"
 y = "Runoob"

 **print**("x:",x, ", y:",y)
 **print**("operator.lt(x,y): ", operator.lt(x,y))
 **print**("operator.gt(y,x): ", operator.gt(y,x))
 **print**("operator.eq(x,x): ", operator.eq(x,x))
 **print**("operator.ne(y,y): ", operator.ne(y,y))
 **print**("operator.le(x,y): ", operator.le(x,y))
 **print**("operator.ge(y,x): ", operator.ge(y,x))
 **print**()

 \# 查看返回值
 **print**("type((operator.lt(x,y)): ", type(operator.lt(x,y)))

以上代码输出结果为：

```
x: 10 , y: 20
operator.lt(x,y):  True
operator.gt(y,x):  True
operator.eq(x,x):  True
operator.ne(y,y):  False
operator.le(x,y):  True
operator.ge(y,x):  True

x: Google , y: Runoob
operator.lt(x,y):  True
operator.gt(y,x):  True
operator.eq(x,x):  True
operator.ne(y,y):  False
operator.le(x,y):  True
operator.ge(y,x):  True
```

比较两个列表：

## 实例

\# 导入 operator 模块
 **import** operator

 a = [1, 2]
 b = [2, 3]
 c = [2, 3]
 **print**("operator.eq(a,b): ", operator.eq(a,b))
 **print**("operator.eq(c,b): ", operator.eq(c,b))

以上代码输出结果为：

```
operator.eq(a,b):  False
operator.eq(c,b):  True
```

### 运算符函数

operator 模块提供了一套与 Python 的内置运算符对应的高效率函数。例如，**operator.add(x, y)** 与表达式 **x+y** 相同。

函数包含的种类有：对象的比较运算、逻辑运算、数学运算以及序列运算。

对象比较函数适用于所有的对象，函数名根据它们对应的比较运算符命名。

许多函数名与特殊方法名相同，只是没有双下划线。为了向后兼容性，也保留了许多包含双下划线的函数，为了表述清楚，建议使用没有双下划线的函数。

## 实例

\# Python 实例
 \# add(), sub(), mul()

 \# 导入  operator 模块
 **import** operator

 \# 初始化变量
 a = 4

 b = 3

 \# 使用 add() 让两个值相加
 **print** ("add() 运算结果 :",end="");
 **print** (operator.add(a, b))

 \# 使用 sub() 让两个值相减
 **print** ("sub() 运算结果 :",end="");
 **print** (operator.sub(a, b))

 \# 使用 mul() 让两个值相乘
 **print** ("mul() 运算结果 :",end="");
 **print** (operator.mul(a, b))

以上代码输出结果为：

```
add() 运算结果 :7
sub() 运算结果 :1
mul() 运算结果 :12
```

| 运算         | 语法                | 函数                                |
| ------------ | ------------------- | ----------------------------------- |
| 加法         | `a + b`             | `add(a, b)`                         |
| 字符串拼接   | `seq1 + seq2`       | `concat(seq1, seq2)`                |
| 包含测试     | `obj in seq`        | `contains(seq, obj)`                |
| 除法         | `a / b`             | `truediv(a, b)`                     |
| 除法         | `a // b`            | `floordiv(a, b)`                    |
| 按位与       | `a & b`             | `and_(a, b)`                        |
| 按位异或     | `a ^ b`             | `xor(a, b)`                         |
| 按位取反     | `~ a`               | `invert(a)`                         |
| 按位或       | `a | b`             | `or_(a, b)`                         |
| 取幂         | `a ** b`            | `pow(a, b)`                         |
| 标识         | `a is b`            | `is_(a, b)`                         |
| 标识         | `a is not b`        | `is_not(a, b)`                      |
| 索引赋值     | `obj[k] = v`        | `setitem(obj, k, v)`                |
| 索引删除     | `del obj[k]`        | `delitem(obj, k)`                   |
| 索引取值     | `obj[k]`            | `getitem(obj, k)`                   |
| 左移         | `a << b`            | `lshift(a, b)`                      |
| 取模         | `a % b`             | `mod(a, b)`                         |
| 乘法         | `a * b`             | `mul(a, b)`                         |
| 矩阵乘法     | `a @ b`             | `matmul(a, b)`                      |
| 取反（算术） | `- a`               | `neg(a)`                            |
| 取反（逻辑） | `not a`             | `not_(a)`                           |
| 正数         | `+ a`               | `pos(a)`                            |
| 右移         | `a >> b`            | `rshift(a, b)`                      |
| 切片赋值     | `seq[i:j] = values` | `setitem(seq, slice(i, j), values)` |
| 切片删除     | `del seq[i:j]`      | `delitem(seq, slice(i, j))`         |
| 切片取值     | `seq[i:j]`          | `getitem(seq, slice(i, j))`         |
| 字符串格式化 | `s % obj`           | `mod(s, obj)`                       |
| 减法         | `a - b`             | `sub(a, b)`                         |
| 真值测试     | `obj`               | `truth(obj)`                        |
| 比较         | `a < b`             | `lt(a, b)`                          |
| 比较         | `a <= b`            | `le(a, b)`                          |
| 相等         | `a == b`            | `eq(a, b)`                          |
| 不等         | `a != b`            | `ne(a, b)`                          |
| 比较         | `a >= b`            | `ge(a, b)`                          |
| 比较         | `a > b`             | `gt(a, b)`                          |

​			

## Python 特点

- **易于学习：**Python有相对较少的关键字，结构简单，和一个明确定义的语法，学习起来更加简单。
- **易于阅读：**Python代码定义的更清晰。
- **易于维护：**Python的成功在于它的源代码是相当容易维护的。
- **一个广泛的标准库：**Python的最大的优势之一是丰富的库，跨平台的，在UNIX，Windows和Macintosh兼容很好。
- **互动模式：**互动模式的支持，您可以从终端输入执行代码并获得结果的语言，互动的测试和调试代码片断。
- **可移植：**基于其开放源代码的特性，Python已经被移植（也就是使其工作）到许多平台。
- **可扩展：**如果你需要一段运行很快的关键代码，或者是想要编写一些不愿开放的算法，你可以使用C或C++完成那部分程序，然后从你的Python程序中调用。
- **数据库：**Python提供所有主要的商业数据库的接口。
- **GUI编程：**Python支持GUI可以创建和移植到许多系统调用。
- **可嵌入:** 你可以将Python嵌入到C/C++程序，让你的程序的用户获得"脚本化"的能力。

## 历史

Python 是由 Guido van Rossum 在八十年代末和九十年代初，在荷兰国家数学和计算机科学研究所设计出来的。

Python 本身也是由诸多其他语言发展而来的,这包括 ABC、Modula-3、C、C++、Algol-68、SmallTalk、Unix shell 和其他的脚本语言等等。

像 Perl 语言一样，Python 源代码同样遵循 GPL(GNU General Public License)协议。

现在 Python 是由一个核心开发团队在维护，Guido van Rossum 仍然占据着至关重要的作用，指导其进展。

Python 2.0 于 2000 年 10 月 16 日发布，增加了实现完整的垃圾回收，并且支持 Unicode。

Python 3.0 于 2008 年 12 月 3 日发布，此版不完全兼容之前的 Python 源代码。不过，很多新特性后来也被移植到旧的Python 2.6/2.7版本。

Python 3.0 版本，常被称为 Python 3000，或简称 Py3k。相对于 Python 的早期版本，这是一个较大的升级。

Python 2.7 被确定为最后一个 Python 2.x 版本，它除了支持 Python 2.x 语法外，还支持部分 Python 3.1 语法。官方宣布，2020 年 1 月 1 日， 停止 Python 2 的更新。

## Python 之禅

```python
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

