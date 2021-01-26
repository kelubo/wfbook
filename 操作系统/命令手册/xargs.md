# xargs

[TOC]

可以用管道将一个命令的stdout（标准输出）重定向到另一个命令的stdin（标准输入）。有些命令只能以命令行参数的形式接受数据，而无法通过stdin接受数据流。在这种情况下，没法用管道提供那些只有通过命令行参数才能提供的数据。

xargs能够处理stdin并将其转换为特定命令的命令行参数。xargs也可以将单行或多行文本输入转换成其他格式，例如单行变多行或是多行变单行。

xargs命令应该紧跟在管道操作符之后。以标准输入作为主要的源数据流，并使用stdin并通过提供命令行参数来执行其他命令。例如：

```bash
command | xargs
```

xargs命令把从stdin接收到的数据重新格式化，再将其作为参数提供给其他命令。作为一种替换方式，作用类似于find命令中的-exec参数。

## 将多行输入转换成单行输出

只需要将换行符移除，再用" "（空格）进行代替，就可以实现多行输入的转换。'\n'被解释成一个换行符，换行符其实就是多行文本之间的定界符。

```bash
cat example.txt # 样例文件
1 2 3 4 5 6
7 8 9 10
11 12

cat example.txt | xargs
1 2 3 4 5 6 7 8 9 10 11 12 
```

## 将单行输入转换成多行输出

指定每行最大的参数数量n，我们可以将任何来自stdin的文本划分成多行，每行n个参数。
每一个参数都是由" "（空格）隔开的字符串。空格是默认的定界符。

```bash
cat example.txt | xargs -n 3
1 2 3
4 5 6
7 8 9
10 11 12
```

## 用自己的定界符来分隔参数

用 -d选项为输入指定一个定制的定界符

```bash
echo "splitXsplitXsplitXsplit" | xargs -d X
split split split split
```

在默认情况下，xargs采用内部字段分隔符（IFS）作为输入定界符。
同时结合-n，我们可以将输入划分成多行，而每行包含两个参数

```bash
echo "splitXsplitXsplitXsplit" | xargs -d X -n 2
split split
split split
```

## 读取stdin，将格式化参数传递给命令

编写一个小型的定制版echo来更好地理解用xargs提供命令行参数的方法

```bash
#!/bin/bash
#文件名: cecho.sh
echo $*'#'
```

当参数被传递给文件cecho.sh后，它会将这些参数打印出来，并以#字符作为结尾。

例如：

```bash
./cecho.sh arg1 arg2
arg1 arg2 #
```

有一个包含着参数列表的文件（每行一个参数）。我需要用两种方法将这些参数传递给一个命令（比如cecho.sh）。

第一种方法，需要每次提供一个参数

```bash
./cecho.sh arg1
./cecho.sh arg2
./cecho.sh arg3
```

或者，每次需要提供两个或三个参数。提供两个参数时，可采用类似于下面这种形式的方法

```bash
./cecho.sh arg1 arg2
./cecho.sh arg3
```

第二种方法，需要一次性提供所有的命令参数

```bash
./cecho.sh arg1 arg2 arg3
```

上面的问题也可以用xargs来解决。我们有一个名为args.txt的参数列表文件，这个文件的内容如下

```bash
cat args.txt
arg1
arg2
arg3
```

就第一个问题，我们可以将这个命令执行多次，每次使用一个参数

```bash
cat args.txt | xargs -n 1 ./cecho.sh
arg1 #
arg2 #
arg3 #
```

每次执行需要X个参数的命令时，使用

```bash
INPUT | xargs -n X
```


例如：

```bash
cat args.txt | xargs -n 2 ./cecho.sh
arg1 arg2 #
arg3 #
```

 就第二个问题，我们可以执行这个命令，并一次性提供所有的参数

```bash
cat args.txt | xargs ./ccat.sh
arg1 arg2 arg3 #
```

在上面的例子中，我们直接为特定的命令（例如cecho.sh）提供命令行参数。这些参数都只源于args.txt文件。但实际上除了它们外，我们还需要一些固定不变的命令参数。思考下面这种命令格式

```bash
./cecho.sh -p arg1 -l
```

在上面的命令执行过程中，arg1是唯一的可变文本，其余部分都保持不变。我们应该从文件（args.txt）中读取参数，并按照下面的方式提供给命令：

```bash
./cecho.sh -p arg1 -l
./cecho.sh -p arg2 -l
./cecho.sh -p arg3 -l
```

xargs有一个选项-I，可以提供上面这种形式的命令执行序列。我们可以用-I指定一个替换字符串，这个字符串在xargs扩展时会被替换掉。当-I与xargs结合使用时，对于每一个参数，命令都会被执行一次。

```bash
cat args.txt | xargs -I {} ./cecho.sh -p {} -l
 
-p arg1 -l #
-p arg2 -l #
-p arg3 -l # 
```

-I {} 指定了替换字符串。对于每一个命令参数，字符串{}会被从stdin读取到的参数所替换。使用-I的时候，命令就似乎是在一个循环中执行一样。如果有三个参数，那么命令就会连同{}一起被执行三次，而{}在每一次执行中都会被替换为相应的参数

## 结合find使用xargs

错误示例：

```bash
find . -type f -name "*.txt" -print | xargs rm -f
```

这样做很危险。有时可能会删除不必要删除的文件。没法预测分隔find命令输出结果的定界符究竟是'\n'还是' '。很多文件名中都可能会包含空格符，而xargs很可能会误认为它们是定界符（例如，hell text.txt会被xargs误认为hell和text.txt）。
只要我们把find的输出作为xargs的输入，就必须将-print0与find结合使用，以字符null来分隔输出。
用find匹配并列出所有的.txt文件，然后用xargs将这些文件删除：

```bash
find . -type f -name "*.txt" -print0 | xargs -0 rm -f
```

这样就可以删除所有的.txt文件。xargs -0将\0作为输入定界符。

## 统计源代码目录中所有C程序文件的行数

```bash
find source_code_dir_path -type f -name "*.c" -print0 | xargs -0 wc -l
```

## 结合stdin，巧妙运用while语句和子shell

xargs只能以有限的几种方式来提供参数，而且也不能为多组命令提供参数。要执行一些包含来自标准输入的多个参数的命令，可采用一种非常灵活的方法。我将这个方法称为子shell妙招（subshell hack）。

一个包含while循环的子shell可以用来读取参数，并通过一种巧妙的方式执行命令：

```bash
cat files.txt | ( while read arg; do cat $arg; done )
# 等同于
cat files.txt | xargs -I {} cat {}
```

在while循环中，可以将cat  arg替换成任意数量的命令，这样我们就可以对同一个参数执行多项命令。我们也可以不借助管道，将输出传递给其他命令。这个技巧能适用于各种问题环境。子shell内部的多个命令可作为一个整体来运行。

```bash
cmd0 | ( cmd1;cmd2;cmd3) | cmd4
```


如果cmd1是cd /，那么就会改变子shell工作目录，然而这种改变仅局限于子shell内部。cmd4则完全不知道工作目录发生了变化。

