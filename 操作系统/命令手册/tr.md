# tr

[TOC]

tr可以对来自标准输入的字符进行替换、删除以及压缩。它可以将一组字符变成另一组字符，因而通常也被称为转换（translate）命令。

tr只能通过stdin（标准输入），而无法通过命令行参数来接受输入。调用格式如下：

```bash
tr [options] set1 set2
```

将来自stdin的输入字符从set1映射到set2，并将其输出写入stdout（标准输出）。set1和set2是字符类或字符集。如果两个字符集的长度不相等，那么set2会不断重复其最后一个字符，直到长度与set1相同。如果set2的长度大于set1，那么在set2中超出set1长度的那部分字符则全部被忽略。

## 将输入字符由大写转换成小写

```bash
echo "HELLO WHO IS THIS" | tr 'A-Z' 'a-z''
```

A-Z' 和 'a-z'都是集合。
'ABD-}'、'aA.,'、'a-ce-x'以及'a-c0-9'等均是合法的集合。定义集合也很简单，不需要去书写一长串连续的字符序列，相反，我们可以使用“起始字符―终止字符”这种格式。这种写法也可以和其他字符或字符类结合使用。如果“起始字符―终止字符”不是一个连续的字符序列，那么它就会被视为一个包含了三个元素的集合（“起始字符―终止字符”）。你可以使用像'\t'、'\n'这种特殊字符，也可以使用其他ASCII字符。

将字符从一个集合映射到另一个集合中。用tr进行数字加密和解密。

```bash
echo 12345 | tr '0-9' '9876543210'
87654                                   #已加密

echo 87654 | tr '9876543210' '0-9'
12345                                   #已解密
```

## 加解密

ROT13是一个著名的加密算法。在ROT13算法中，文本加密和解密都使用同一个函数。ROT13按照字母表排列顺序执行13个字母的转换。用tr进行ROT13加密：

```bash
echo "tr came, tr saw, tr conquered." | tr'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  'NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm'

ge pnzr, ge fnj, ge pbadhrerq.
```
对加密后的密文再次使用同样的ROT13函数： 

```bash
echo ge pnzr, ge fnj, ge pbadhrerq. | tr'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  'NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm.

tr came, tr saw, tr conquered.
```

## 将制表符转换成空格

```bash
cat text | tr '\t' ' '
```

## 用tr删除字符

tr有一个选项-d，可以通过指定需要被删除的字符集合，将出现在stdin中的特定字符清除掉

```bash
cat file.txt | tr -d '[set1]'              #只使用set1，不使用set2

echo "Hello 123 world 456" | tr -d '0-9'
Hello world                                # 将stdin中的数字删除并打印出来
```

## 字符集补集

利用选项-c来使用set1的补集。-c [set]等同于定义了一个集合（补集），这个集合中的字符不包含在[set]中

```bash
tr -c [set1] [set2]
```

set1的补集意味着这个集合中包含set1中没有的所有字符。
最典型的用法是从输入文本中将不在补集中的所有字符全部删除。

```bash
echo hello 1 char 2 next 4 | tr -d -c '0-9 \n'
1 2 4
```

## 压缩字符

tr的-s选项可以压缩输入中重复的字符

```bash
# tr -s '[set]'

echo "GNU is not UNIX. Recursive right ?" | tr -s ' '
GNU is not UNIX. Recursive right ?
```

用tr将文件中的数字列表进行相加：

```bash
cat sum.txt
1
2
3
4
5

cat sum.txt | echo $[ $(tr '\n' '+' ) 0 ]
15
```

在上面的命令中，tr用来将'\n'替换成'+'，因此我们得到了字符串"1+2+3+…5+"，但是在字符串的尾部多了一个操作符+。为了抵消这个多出来的操作符，我们再追加一个0。$[ operation ]执行算术运算，因此得到下面的字符串：echo  [ 1+2+3+4+5+0 ]

## 字符类

tr可以像使用集合一样使用各种不同的字符类。

* alnum：字母和数字。
* alpha：字母。
* cntrl：控制（非打印）字符。
* digit：数字。
* graph：图形字符。
* lower：小写字母。
* print：可打印字符。
* punct：标点符号。
* space：空白字符。
* upper：大写字母。
* xdigit：十六进制字符。

可以按照下面的方式选择并使用所需的字符类

```bash
tr [:class:] [:class:]

# eg:
tr '[:lower:]' '[:upper:]'
```

