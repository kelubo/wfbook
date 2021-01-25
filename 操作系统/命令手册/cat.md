# cat

[TOC]

cat命令本身表示concatenate（拼接）。

## 读取文件内容

```bash
cat file1 file2 file3 ...
```

## 从标准输入中进行读取

```bash
OUTPUT_FROM_SOME COMMANDS | cat
```

## 将输入文件的内容与标准输入拼接在一起

```bash
echo 'Text through stdin' | cat - file.txt
# - 被作为来自stdin文本的文件名
```

## 压缩空白行

出于可读性或是别的一些原因，有时文本中的多个空行需要被压缩成单个。

```bash
cat -s file
```

用tr移除空白行： 

```bash
cat multi_blanks.txt | tr -s '\n'
# 将连续多个'\n'字符压缩成单个'\n'（换行符）
```

## 将制表符显示为 ^|

单从视觉上很难将制表符同连续的空格区分开。将制表符重点标记出来，对排除缩进错误非常有用。

用cat命令的-T选项能够将制表符标记成^|。

例如：

```bash
cat file.py
def function():
    var = 5
        next = 6
    third = 7

cat -T file.py
def function():
^Ivar = 5
next = 6
^Ithird = 7^I
```

## 行号

使用cat命令的-n选项会在输出的每一行内容之前加上行号。cat命令不会修改文件，只是根据用户提供的选项在stdout生成一个修改过的输出而已。例如：

```bash
cat lines.txt
line
line
line

cat -n lines.txt
1 line
2 line
3 line
```

