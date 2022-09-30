# Shell 脚本

[TOC]

## 指定命令解释器

```bash
#!/bin/bash

#! -- sh-bang 或 she-bang
```

## 执行

```bash
# 方法1
sh script.sh
sh /home/path/script.sh
# 该方法，不需要在第一行指定解释器信息。

# 方法2
chmod +x script.sh
./script.sh
/home/path/script.sh

# 方法3
source script.sh
# 方法3可能因脚本内cd命令存在，改变脚本结束后所处的工作目录。
```

## 变量

每个变量的值都是字符串。

### 定义变量

```bash
var_name="xxx"
# 显式地直接赋值
# 变量名和等号之间不能有空格。
# var_name = "xxx"	是相等操作。

# 用语句赋值
for file in `ls /etc`
for file in $(ls /etc)

# 只读变量
# 使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。
readonly var_name
```

**变量名命名规则：** 

-  命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
-  中间不能有空格，可以使用下划线（_）。
-  不能使用标点符号。
-  不能使用 bash 里的关键字。

### 使用变量

```bash
var_name="xxxx"
echo $var_name
echo ${var_name}
```

 变量名外面的花括号是可选的，加花括号是为了帮助解释器识别变量的边界，比如下面这种情况： 

```bash
for skill in Ada Coffe Action Java;
do
    echo "I am good at ${skill}Script"
done 
```

### 删除变量

```bash
unset var_name
```

变量被删除后不能再次使用。unset 命令不能删除只读变量。

### 变量类型

-  **局部变量**  局部变量在脚本或命令中定义，仅在当前 shell 实例中有效，其他 shell 启动的程序不能访问局部变量。
-  **环境变量**  所有的程序，包括 shell 启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候 shell 脚本也可以定义环境变量。
-  **shell变量**  shell 变量是由 shell 程序设置的特殊变量。shell 变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了 shell 的正常运行

#### 环境变量

在终端中查看所有与此终端进程相关的环境变量：

```bash
env
```

对于每个进程，查看在其运行时的环境变量：

```bash
cat /proc/$PID/environ
cat /proc/$PID/environ | tr '\0' '\n'	#格式化
```

设置环境变量：

```bash
export var_name
```

##### PATH

通常定义在 /etc/environment 或 /etc/profile 或 ~/.bashrc 中。

添加一个新路径：

```bash
export PATH="$PATH:/home/user/bin"

PATH="$PATH:/home/user/bin"
export PATH
```

##### $?

当一个命令发生错误并退回时，返回一个非 0 的退出状态；当成功时，返回一个 0 。

### 补充内容

1. 获取字符串长度

   ```bash
   length=${#var}
   
   var=12345678901234567890
   echo ${#var}
   ```

2. 识别当前的shell版本

   ```bash
   echo $SHELL
   echo $0
   ```

3. 检查是否为超级用户

   ```bash
   if [ $UID -ne 0 ]; then
     echo Non root user.Please run as root.
   else
     echo "Root user"
   fi
   ```

4. 修改Bash提示字符串（username@hostname:~$）

   ```bash
   # 查看PS1设置
   cat ~/.bashrc | grep PS1
   
   # 设置提示符
   PS1="PROMPT>"
   PROMPT>
   
   
   \e[1;31   设置彩色提示符
   \u	      用户名
   \h	      主机名
   \w	      当前工作目录
   ```


## 流程控制 

 bash的流程控制不可为空。 例如，如果 else 分支没有语句执行，就不要写这个 else 。 

### if else 

#### if

```bash
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```

 写成一行（适用于终端命令提示符）： 

```bash
if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
```

#### if else 

```bash
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```

#### if else-if else 

```bash
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

### while

while 循环用于不断执行一系列命令，也用于从输入文件中读取数据；命令通常为测试条件。

```bash
while condition
do
    command
done
```

while 循环可用于读取键盘信息。下面的例子中，输入信息被设置为变量 FILM，按 <Ctrl-D> 结束循环。 

```bash
echo '按下 <CTRL-D> 退出'
echo -n '输入你最喜欢的网站名: '
while read FILM
do
    echo "是的！$FILM 是一个好网站"
done
```

### until

until 循环执行一系列命令直至条件为 true 时停止。与 while 循环在处理方式上刚好相反。

一般 while 循环优于 until 循环，但在某些时候—也只是极少数情况下，until 循环更加有用。 

```bash
until condition
do
    command
done

# condition 一般为条件表达式，如果返回值为 false，则继续执行循环体内的语句，否则跳出循环。
```

### case 

case 语句为多选择语句。可以用 case 语句匹配一个值与一个模式，如果匹配成功，执行相匹配的命令。

```bash
case 值 in
	模式1)
	    command1
	    command2
	    ...
	    commandN
	;;
	模式2）
	    command1
	    command2
	    ...
	    commandN
	;;
	*)  
		command_default
    ;;
esac
```

取值后面必须为单词 in，每一模式必须以右括号结束。取值可以为变量或常数。匹配发现取值符合某一模式后，其间所有命令开始执行直至 ;; 。 

取值将检测匹配的每一个模式。一旦模式匹配，则执行完匹配模式相应命令后不再继续其他模式。如果无一匹配模式，使用星号 * 捕获该值，再执行后面的命令。 

### for

```bash
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

 写成一行： 

```bash
for var in item1 item2 ... itemN; do command1; command2… ; done
```

当变量值在列表里，for 循环即执行一次所有命令，使用变量名获取列表中的当前取值。命令可为任何有效的 shell 命令和语句。in 列表可以包含替换、字符串和文件名。 

 in 列表是可选的，如果不用它，for 循环使用命令行的位置参数。 

 例如，顺序输出当前列表中的数字：

```bash
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```

 输出结果： 

```bash
The value is: 1
The value is: 2
The value is: 3
The value is: 4
The value is: 5
```

顺序输出字符串中的字符：

```bash
for str in 'This is a string'
do
    echo $str
done
```

 输出结果：

```bash
This is a string
```

### 跳出循环

在循环过程中，有时候需要在未达到循环结束条件时强制跳出循环，Shell 使用两个命令来实现该功能：break 和 continue 。 

#### break

 break 命令允许跳出所有循环（终止执行后面的所有循环）。 

 下面的例子中，脚本进入死循环直至用户输入数字大于5。要跳出这个循环，返回到shell提示符下，需要使用break命令。 

```bash
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
            break
        ;;
    esac
done
```

#### continue 

与break命令类似，只有一点差别，它不会跳出所有循环，仅仅跳出当前循环。 

对上面的例子进行修改： 

```bash
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的!"
            continue
            echo "游戏结束"
        ;;
    esac
done
```

 运行代码发现，当输入大于5的数字时，该例中的循环不会结束，语句  **echo "游戏结束"** 永远不会被执行。 

### 无限循环 

```bash
while :
do
    command
done
```

 或者 

```bash
while true
do
    command
done
```

 或者 

```bash
for (( ; ; ))
```

## 字符串

单引号

```bash
str='this is a string'
```

 单引号字符串的限制： 

-  单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
-  单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。

双引号 

```bash
your_name='runoob'
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str
```

输出结果为：

```bash
Hello, I know you are "runoob"! 
```

 双引号的优点：

-  双引号里可以有变量。
- 双引号里可以出现转义字符。

拼接字符串 

```bash
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1
# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3
```

输出结果为：

```bash
hello, runoob ! hello, runoob !
hello, runoob ! hello, ${your_name} !
```

获取字符串长度 

```bash
string="abcd"
echo ${#string} #输出 4
# 变量为数组时，${#string} 等价于 ${#string[0]}
```

提取子字符串 

以下实例从字符串第 **2** 个字符开始截取 **4** 个字符：

```bash
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
# 第一个字符的索引值为 0。
```

查找子字符串 

查找字符 **i** 或 **o** 的位置(哪个字母先出现就计算哪个)：

```bash
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```

## 数组

数组中可以存放多个值。Bash Shell 只支持一维数组（不支持多维数组），初始化时不需要定义数组大小 ，并且没有限定数组的大小。数组元素的下标由 0 开始编号。

在 Shell 中，用括号来表示数组，数组元素用"空格"符号分割开。定义数组的一般形式为： 

```bash
array_name=(value1 ... valuen)
```

实例：

```bash
array_name=(value0 value1 value2 value3)

array_name=(
value0
value1
value2
value3
)
```

 还可以单独定义数组的各个分量： 

```bash
array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen
```

 可以不使用连续的下标，而且下标的范围没有限制。 

读取数组 

```bash
${array_name[index]}
```

 例如：

```bash
valuen=${array_name[n]}
```

 获取数组中的所有元素，例如： 

```bash
echo ${array_name[@]}
echo ${array_name[*]}
```

获取数组的长度  

```bash
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```

## 注释

以 # 开头的行就是注释，会被解释器忽略。通过每一行加一个 **#** 号设置多行注释。

如果在开发过程中，遇到大段的代码需要临时注释起来，可以把这一段要注释的代码用一对花括号括起来，定义成一个函数，没有地方调用这个函数，这块代码就不会执行，达到了和注释一样的效果。 

多行注释还可以使用以下格式：

```bash
:<<EOF
注释内容...
注释内容...
注释内容...
EOF
```

EOF 也可以使用其他符号:

```bash
:<<'
注释内容...
注释内容...
注释内容...
'

:<<!
注释内容...
注释内容...
注释内容...
!
```

## 传递参数

可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：**$n**。**n** 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……

以下实例我们向脚本传递三个参数，并分别输出，其中 **$0** 为执行的文件名：

```bash
#!/bin/bash

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```

为脚本设置可执行权限，并执行脚本，输出结果如下所示：

```bash
chmod +x test.sh 
./test.sh 1 2 3

Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

特殊变量：

| 参数处理 | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| $#       | 传递到脚本的参数个数                                         |
| $*       |                                                              |
| $@       |                                                              |
| $$       | 脚本运行的当前进程ID号                                       |
| $!       | 后台运行的最后一个进程的ID号                                 |
| $-       | 显示Shell使用的当前选项，与[set命令](https://www.runoob.com/linux/linux-comm-set.html)功能相同。 |
| $?       | 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。 |

`$*` 与 `$@` 区别：

- 相同点：都是引用所有参数。
-  不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。 

```bash
#!/bin/bash
echo "-- \$* 演示 ---"
for i in "$*"; do
    echo $i
done

echo "-- \$@ 演示 ---"
for i in "$@"; do
    echo $i
done
```

执行脚本，输出结果如下所示：

```bash
chmod +x test.sh 
./test.sh 1 2 3

-- $* 演示 ---
1 2 3
-- $@ 演示 ---
1
2
3
```

在为shell脚本传递的参数中 **如果包含空格，应该使用单引号或者双引号将该参数括起来，以便于脚本将这个参数作为整体来接收**。

在有参数时，可以使用对参数进行校验的方式处理以减少错误发生：

```bash
if [ -n "$1" ]; then
    echo "包含第一个参数"
else
    echo "没有包含第一参数"
fi
```

**注意**：中括号 [] 与其中间的代码应该有空格隔开

Shell 里面的中括号（包括单中括号与双中括号）可用于一些条件的测试：

- 算术比较, 比如一个变量是否为0, `[ $var -eq 0 ]`。
- 文件属性测试，比如一个文件是否存在，`[ -e $var ]`, 是否是目录，`[ -d $var ]`。
- 字符串比较, 比如两个字符串是否相同， `[[ $var1 = $var2 ]]`。

> [] 常常可以使用 test 命令来代替。

## echo

```bash
echo string
```

实例：

1.显示普通字符串:

```bash
echo "It is a test"
echo It is a test
```

2.显示转义字符

```bash
echo "\"It is a test\""

"It is a test"
```

双引号也可以省略

3.显示变量

```bash
echo $name
```

4.显示换行

```bash
echo -e "OK! \n"     # -e 开启转义
echo "It is a test"

OK!

It is a test
```

5.显示不换行

```bash
echo -e "OK! \c"     # -e 开启转义 \c 不换行
echo "It is a test"

OK! It is a test
```

6.显示结果定向至文件

```bash
echo "It is a test" > myfile
```

7.原样输出字符串，不进行转义或取变量(用单引号)

```bash
echo '$name\"'

$name\"
```

8.显示命令执行结果

```bash
echo `date`

Thu Jul 24 10:08:46 CST 2014
```

## test

用于检查某个条件是否成立，它可以进行数值、字符和文件三个方面的测试。

### 数值测试

```bash
-eq		等于则为真
-ne		不等于则为真
-gt		大于则为真
-ge		大于等于则为真
-lt		小于则为真
-le		小于等于则为真
```

### 字符串测试

```bash
=		等于则为真
!=		不相等则为真
-z 		字符串字符串的长度为零则为真
-n 		字符串字符串的长度不为零则为真
```

### 文件测试

```bash
-e 	文件名		如果文件存在则为真
-r 	文件名		如果文件存在且可读则为真
-w 	文件名		如果文件存在且可写则为真
-x 	文件名		如果文件存在且可执行则为真
-s 	文件名		如果文件存在且至少有一个字符则为真
-d 	文件名		如果文件存在且为目录则为真
-f 	文件名		如果文件存在且为普通文件则为真
-c 	文件名		如果文件存在且为字符型特殊文件则为真
-b 	文件名		如果文件存在且为块特殊文件则为真
```

另外，Shell还提供了与( -a )、或( -o )、非( ! )三个逻辑操作符用于将测试条件连接起来，其优先级为："!"最高，"-a"次之，"-o"最低。例如：

```bash
cd /bin
if test -e ./notFile -o -e ./bash
then
    echo '至少有一个文件存在!'
else
    echo '两个文件都不存在'
fi

至少有一个文件存在!
```



## Other

每个命令或命令序列是通过使用分号或换行符来分隔的。

```bash
$ cmd1;cmd2
#等同于
$ cmd1
$ cmd2
```

## 输入/输出重定向

大多数 UNIX 系统命令从终端接受输入并将所产生的输出发送回到终端。一个命令通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是终端。同样，一个命令通常将其输出写入到标准输出，默认情况下，这也是终端。 

重定向命令列表如下：

| 命令            | 说明                                               |
| --------------- | -------------------------------------------------- |
| command > file  | 将输出重定向到 file。                              |
| command < file  | 将输入重定向到 file。                              |
| command >> file | 将输出以追加的方式重定向到 file。                  |
| n > file        | 将文件描述符为 n 的文件重定向到 file。             |
| n >> file       | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
| n >& m          | 将输出文件 m 和 n 合并。                           |
| n <& m          | 将输入文件 m 和 n 合并。                           |
| << tag          | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |

> 需要注意的是文件描述符 0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。

### 输出重定向

```
command1 > file1
```

 上面这个命令执行command1然后将输出的内容存入file1。

注意任何file1内的已经存在的内容将被新内容替代。如果要将新内容添加在文件末尾，请使用>>操作符。 

执行后，并没有在终端输出信息，这是因为输出已被从默认的标准输出设备（终端）重定向到指定的文件。

### 输入重定向

 Unix 命令也可以从文件获取输入： 

```bash
command1 < file1
```

```bash
command1 < infile > outfile
```

同时替换输入和输出，执行command1，从文件infile读取内容，然后将输出写入到outfile中。

重定向深入讲解

一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：

-  		标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
-  		标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
-  		标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。

 默认情况下，command > file 将 stdout 重定向到 file，command < file 将stdin 重定向到 file。

如果希望 stderr 重定向到 file，可以这样写：

```bash
$ command 2 > file
```

如果希望 stderr 追加到 file 文件末尾，可以这样写：

```bash
$ command 2 >> file
```

**2** 表示标准错误文件(stderr)。

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：

```bash
$ command > file 2>&1
或者
$ command >> file 2>&1
```

如果希望对 stdin 和 stdout 都重定向，可以这样写：

```bash
$ command < file1 >file2
```

command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。 

## Here Document

 Here Document 是 Shell 中的一种特殊的重定向方式，用来将输入重定向到一个交互式 Shell 脚本或程序。 

基本的形式如下：

```bash
command << delimiter
    document
delimiter
```

它的作用是将两个 delimiter 之间的内容(document) 作为输入传递给 command。

**注意：**

-  		结尾的delimiter 一定要顶格写，前面不能有任何字符，后面也不能有任何字符，包括空格和 tab 缩进。
-  		开始的delimiter前后的空格会被忽略掉。

```bash
cat << EOF
	XXXXX
EOF
```

## /dev/null 文件

如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：

```bash
$ command > /dev/null
```

/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到"禁止输出"的效果。

如果希望屏蔽 stdout 和 stderr，可以这样写：

```
$ command > /dev/null 2>&1
```

**注意：**0 是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。

## 文件包含

包含外部脚本。这样可以很方便的封装一些公用的代码作为一个独立的文件。

```bash
. filename   # 注意点号(.)和文件名中间有一空格
或
source filename
```

**注：**被包含的文件不需要可执行权限。

## 调试

使用选项-x，启动跟踪调试shell脚本

```bash
bash -x script.sh
```

-x 标识将脚本中执行过的每一行都输出到stdout。也可以要求只关注脚本某些部分的命令及参数的打印输出。针对这种情况，可以在脚本中使用setbuilt-in来启用或禁止调试打印。

```bash
set -x   在执行时显示参数和命令。
set +x   禁止调试。
set -v   当命令进行读取时显示输入。
set +v   禁止打印输入。
```

例如：

```bash
#!/bin/bash
#文件名: debug.sh
for i in {1..6}
do
set -x
echo $i
set +x
done
echo "Script executed"

#仅在-x 和+x 所限制的区域内，echo  i的调试信息才会被打印出来。
```

以自定义格式显示调试信息，可以通过传递`_DEBUG`环境变量来建立这类调试风格。

```bash
#!/bin/bash
function DEBUG()
{
[ "$_DEBUG" == "on" ] && $@ || :
}

for i in {1..10}
do
DEBUG echo $i
done
```

可以将调试功能置为"on"来运行上面的脚本

```bash
 _DEBUG=on ./script.sh
```

在每一个需要打印调试信息的语句前加上DEBUG。如果没有把`_DEBUG=on`传递给脚本，那么调试信息就不会打印出来。在Bash中，命令`:`告诉shell不要进行任何操作。

**shebang的妙用**
把shebang从` #!/bin/bash`改成` #!/bin/bash -xv`，不用任何其他选项就可以启用调试功能。