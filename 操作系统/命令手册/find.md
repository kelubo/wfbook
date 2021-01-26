# find

[TOC]

find命令的工作方式：沿着文件层次结构向下遍历，匹配符合条件的文件，并执行相应的操作。
要列出当前目录及子目录下所有的文件和文件夹，可以采用下面的写法：

```bash
find base_path
#bash_path可以是任何位置，find会从该位置开始向下查找。
```

例如： 

```bash
find . -print
# 打印文件和目录的列表
# -print指明打印出匹配文件的文件名（路径）。当使用-print时，'\n'作为用于分隔文件的定界符。
# -print0指明使用'\0'作为定界符来打印每一个匹配的文件名。当文件名中包含换行符时，这个方法适用。
```

## 据文件名或正则表达式匹配搜索

选项 `-name` 的参数指定了文件名所必须匹配的字符串。可以将通配符作为参数使用。`*.txt` 能够匹配所有以 `.txt` 结尾的文件名。

选项 `-print` 在终端中打印出符合条件（例如-name）的文件名或文件路径，这些匹配条件作为find命令的选项给出。

```bash
find /home/slynux -name "*.txt" -print
```

find命令有一个选项 `-iname` （忽略字母大小写），该选项的作用和 `-name` 类似，只不过在匹配名字的时候会忽略大小写。
例如： 

```bash
ls
example.txt EXAMPLE.txt file.txt

find . -iname "example*" -print
./example.txt
./EXAMPLE.txt
```

如果想匹配多个条件中的一个，可以采用OR条件操作：

```bash
ls
new.txt some.jpg text.pdf

find . \( -name "*.txt" -o -name "*.pdf" \) -print
./text.pdf
./new.txt

# 打印出所有的 .txt和 .pdf文件，是因为这个find命令能够匹配所有这两类文件。
# (  )用于将 -name "*.txt" -o -name "*.pdf" 视为一个整体。
```


选项-path的参数可以使用通配符来匹配文件路径或文件。-name总是用给定的文件名进行匹配。-path则将文件路径作为一个整体进行匹配。例如：

```bash
find /home/users -path "*slynux*" -print

/home/users/list/slynux.txt
/home/users/slynux/eg.css
```

选项-regex的参数和-path的类似，只不过-regex是基于正则表达式来匹配文件路径的。

正则表达式是通配符匹配的高级形式，它可以指定文本模式。借助这种模式来匹配并打印文本。
下面的命令匹配.py或.sh文件：

```bash
ls
new.PY next.jpg test.py

find . -regex ".*\(\.py\|\.sh\)$"
./test.py
```

类似地，-iregex用于忽略正则表达式的大小写。例如：

```bash
find . -iregex ".*\(\.py\|\.sh\)$"
./test.py
./new.PY
```

## 否定参数

find也可以用“!”否定参数的含义。例如：

```bash
find . ! -name "*.txt" -print
```

示例：

```bash
ls
list.txt new.PY new.txt next.jpg test.py

find . ! -name "*.txt" -print
.
./next.jpg
./test.py
./new.PY
```

## 基于目录深度的搜索

可以采用一些深度参数来限制find命令遍历的深度。-maxdepth和 -mindepth
多数情况下，只需要在当前目录中进行搜素，无须再继续向下查找。对于这种情况，使用深度参数来限制find命令向下查找的深度。如果只允许find在当前目录中查找，深度可以设置为1；当需要向下两级时，深度可以设置为2；其他情况可以依次类推。

用-maxdepth参数指定最大深度。与此相似，也可以指定一个最小的深度，告诉find应该从此处开始向下查找。如果我们想从第二级目录开始搜素，那么使用-mindepth参数设置最小深度。使用下列命令将find命令向下的最大深度限制为1：

```bash
find . -maxdepth 1 -type f -print
```

该命令只列出当前目录下的所有普通文件。即使有子目录，也不会被打印或遍历。

-mindepth类似于 -maxdepth，不过它设置的是find遍历的最小深度。这个选项可以用来查找并打印那些距离起始路径超过一定深度的所有文件。例如，打印出深度距离当前目录至少两个子目录的所有文件： 

```bash
find . -mindepth 2 -type f -print
./dir1/dir2/file1
./dir3/dir4/f2
# 即使当前目录或dir1和dir3中包含有文件，它们也不会被打印出来。
```

> -maxdepth和-mindepth应该作为find的第3个参数出现。如果作为第4个或之后的参数，就可能会影响到find的效率，因为它不得不进行一些不必要的检查。例如，如果-maxdepth作为第4个参数，-type作为第三个参数，find首先会找出符合-type的所有文件，然后在所有匹配的文件中再找出符合指定深度的那些。但是如果反过来，目录深度作为第三个参数，-type作为第四个参数，那么find就能够在找到所有符合指定深度的文件后，再检查这些文件的类型，这才是最有效的搜索顺序。

## 根据文件类型搜索

类UNIX系统将一切都视为文件。文件具有不同的类型，例如普通文件、目录、字符设备、块设备、符号链接、硬链接、套接字以及FIFO等。
-type可以对文件搜素进行过滤。借助这个选项，我们可以为find命令指明特定的文件匹配类型。
只列出所有的目录：

```bash
find . -type d -print
```

只列出普通文件：

```bash
find . -type f -print
```

只列出符号链接：

```bash
find . -type l -print
```

 

| 文件类型 | 类型参数 |
| -------- | -------- |
| 普通文件 | f        |
| 符号链接 | l        |
| 目录     | d        |
| 字符设备 | c        |
| 块设备   | b        |
| 套接字   | s        |
| Fifo     | p        |

## 根据文件时间进行搜索

UNIX/Linux文件系统中的每一个文件都有三种时间戳（timestamp），如下所示。

* 访问时间（-atime）：用户最近一次访问文件的时间。
* 修改时间（-mtime）：文件内容最后一次被修改的时间。
* 变化时间（-ctime）：文件元数据（metadata，例如权限或所有权）最后一次改变的时间。

在UNIX中并没有所谓“创建时间”的概念。
-atime、-mtime、-ctime可作为find的时间参数。它们可以整数值给出，单位是天。这些整数值通常还带有-或+：-表示小于，+表示大于，如下所示。

```bash
find . -type f -atime -7 -print   #打印出在最近七天内被访问过的所有文件
find . -type f -atime 7 -print    #打印出恰好在七天前被访问过的所有文件
find . -type f -atime +7 -print   #打印出访问时间超过七天的所有文件
```

类似地，可以根据修改时间，用-mtime进行搜素，也可以根据变化时间，用-ctime进行搜素。
还有其他一些基于时间的参数是以分钟作为计量单位的。这些参数包括：

* -amin （访问时间）
* -mmin（修改时间）
* -cmin  （变化时间）

示例：

```bash
find . -type f -amin +7 -print   #打印出访问时间超过7分钟的所有文件 
```

find另一个漂亮的特性是 -newer参数。使用 -newer，我们可以指定一个用于比较时间戳的参考文件，然后找出比参考文件更新的（更长的修改时间）所有文件。
例如，找出比file.txt修改时间更长的所有文件：

```bash
find . -type f -newer file.txt -print
```

## 基于文件大小的搜索

根据文件的大小，搜索：

```bash
find . -type f -size +2k     # 大于2KB的文件
find . -type f -size -2k     # 小于2KB的文件
find . -type f -size 2k      # 大小等于2KB的文件
```

除了k之外，还可以用其他文件大小单元。

* b —— 块（512字节）

* c —— 字节。

* w —— 字（2字节）

* k —— 千字节

* M —— 兆字节

* G —— 吉字节

## 删除匹配的文件

-delete可以用来删除find查找到的匹配文件。
删除当前目录下所有的 .swp文件：

```bash
find . -type f -name "*.swp" -delete*
```

## 基于文件权限和所有权的匹配

文件匹配可以根据文件权限进行。列出具有特定权限的所有文件：

```bash
find . -type f -perm 644 -print   # 打印出权限为644的文件
```

找出那些没有设置好执行权限的PHP文件：

```bash
find . -type f -name "*.php" ! -perm 644 -print
```

也可以根据文件的所有权进行搜素。用选项-user USER就能够找出由某个特定用户所拥有的文件,参数USER可以是用户名或UID。
例如，打印出用户slynux拥有的所有文件：

```bash
find . -type f -user slynux -print
```

## 结合find执行命令或动作

find命令可以借助选项-exec与其他命名进行结合。
用-user找出root拥有的所有文件，然后用-exec更改所有权。

```bash
find . -type f -user root -exec chown slynux {} \;

# { }是一个特殊的字符串，与 -exec选项结合使用。对于每一个匹配的文件，{ }会被替换成相应的文件名。
# 例如，find命令找到两个文件test1.txt和test2.txt，其所有者均为slynux，那么find将会执行：
# chown slynux {}
# 它会被解析为:
# chown slynux test1.txt
# chown slynux test2.txt。
```

将给定目录中的所有C程序文件拼接起来写入单个文件all_c_files.txt。我们可以用find找到所有的C文件，然后结合-exec使用cat命令：

```bash
find . -type f -name "*.c" -exec cat {} \; ＞all_c_files.txt

# 使用＞操作符将来自find的数据重定向到all_c_files.txt文件，没有使用＞＞（追加）的原因是因为
# find命令的全部输出只是一个单数据流（stdin），而只有当多个数据流被追加到单个文件中的时候才有
# 必要使用＞＞。
```

将10天前的 .txt文件复制到OLD目录中：

```bash
find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD \;

```

-exec结合多个命令

把多个命令写到一个shell脚本中（例如command.sh），然后在-exec中使用这个脚本：

```bash
-exec ./commands.sh {} \;
```

-exec能够同printf结合来生成有用的输出信息。

```bash
find . -type f -name "*.txt" -exec printf "Text file: %s\n" {} \;
```

## 让find跳过特定的目录

在搜素目录并执行某些操作的时候，有时为了提高性能，需要跳过一些子目录。将某些文件或目录从搜素过程中排除的技术被称为“修剪”，其操作方法如下：

```bash
find devel/source_path \( -name ".git" -prune \) -o \( -type f -print \)
# 不使用\( -type -print \)，而是选择需要的过滤器
# 打印出不包括在 .git目录中的所有文件的名称（路径）。
# \( -name ".git" -prune \)的作用是用于进行排除，它指明了.git目录应该被排除掉
# \(-type f -print \)指明了需要执行的动作。这些动作需要被放置在第二个语句块中
```


