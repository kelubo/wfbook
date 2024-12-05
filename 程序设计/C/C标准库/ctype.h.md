# <ctype.h>

## 简介

C 标准库的 **ctype.h** 头文件提供了一些函数，可用于测试和转换字符，这些函数主要用于检查字符的类型（如字母、数字、空白字符等）以及进行字符大小写转换。

`<ctype.h>` 提供了一组方便的函数，用于处理字符的分类和转换操作，是 C 标准库中处理字符操作的重要工具。

以下是一个简单的示例，演示了如何使用 `<ctype.h>` 提供的函数：

## 实例

\#include <stdio.h>
 \#include <ctype.h>
 
 int main() {
   char ch;
 
   // 示例字符
   char chars[] = "a1 B? **\n**";
 
   // 检查每个字符的类型
   for (int i = 0; chars[i] != '**\0**'; i++) {
     ch = chars[i];
     printf("Character: '%c'**\n**", ch);
     if (isalpha(ch)) {
       printf(" - isalpha: Yes**\n**");
     } else {
       printf(" - isalpha: No**\n**");
     }
     if (isdigit(ch)) {
       printf(" - isdigit: Yes**\n**");
     } else {
       printf(" - isdigit: No**\n**");
     }
     if (isspace(ch)) {
       printf(" - isspace: Yes**\n**");
     } else {
       printf(" - isspace: No**\n**");
     }
     if (isprint(ch)) {
       printf(" - isprint: Yes**\n**");
     } else {
       printf(" - isprint: No**\n**");
     }
     if (ispunct(ch)) {
       printf(" - ispunct: Yes**\n**");
     } else {
       printf(" - ispunct: No**\n**");
     }
   }
 
   // 字符大小写转换示例
   char lower = 'a';
   char upper = 'A';
 
   printf("tolower('%c') = '%c'**\n**", upper, tolower(upper));
   printf("toupper('%c') = '%c'**\n**", lower, toupper(lower));
 
   return 0;
 }

输出结果为：

```
Character: 'a'
 - isalpha: Yes
 - isdigit: No
 - isspace: No
 - isprint: Yes
 - ispunct: No
Character: '1'
 - isalpha: No
 - isdigit: Yes
 - isspace: No
 - isprint: Yes
 - ispunct: No
Character: ' '
 - isalpha: No
 - isdigit: No
 - isspace: Yes
 - isprint: Yes
 - ispunct: No
Character: 'B'
 - isalpha: Yes
 - isdigit: No
 - isspace: No
 - isprint: Yes
 - ispunct: No
Character: '?'
 - isalpha: No
 - isdigit: No
 - isspace: No
 - isprint: Yes
 - ispunct: Yes
Character: '
'
 - isalpha: No
 - isdigit: No
 - isspace: Yes
 - isprint: No
 - ispunct: No
tolower('A') = 'a'
toupper('a') = 'A'
```

## 库函数

下面列出了头文件 ctype.h 中定义的函数。

这些函数用于测试字符是否属于某种类型，这些函数接受 **int** 作为参数，它的值必须是 EOF 或表示为一个无符号字符。

如果参数 c 满足描述的条件，则这些函数返回非零（true）。如果参数 c 不满足描述的条件，则这些函数返回零。

| 序号 | 函数 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | [int isalnum(int c)](https://www.runoob.com/cprogramming/c-function-isalnum.html) 该函数检查所传的字符是否是字母和数字。 |
| 2    | [int isalpha(int c)](https://www.runoob.com/cprogramming/c-function-isalpha.html) 该函数检查所传的字符是否是字母。 |
| 3    | [int iscntrl(int c)](https://www.runoob.com/cprogramming/c-function-iscntrl.html) 该函数检查所传的字符是否是控制字符。 |
| 4    | [int isdigit(int c)](https://www.runoob.com/cprogramming/c-function-isdigit.html) 该函数检查所传的字符是否是十进制数字。 |
| 5    | [int isgraph(int c)](https://www.runoob.com/cprogramming/c-function-isgraph.html) 该函数检查所传的字符是否有图形表示法。 |
| 6    | [int islower(int c)](https://www.runoob.com/cprogramming/c-function-islower.html) 该函数检查所传的字符是否是小写字母。 |
| 7    | [int isprint(int c)](https://www.runoob.com/cprogramming/c-function-isprint.html) 该函数检查所传的字符是否是可打印的。 |
| 8    | [int ispunct(int c)](https://www.runoob.com/cprogramming/c-function-ispunct.html) 该函数检查所传的字符是否是标点符号字符。 |
| 9    | [int isspace(int c)](https://www.runoob.com/cprogramming/c-function-isspace.html) 该函数检查所传的字符是否是空白字符。 |
| 10   | [int isupper(int c)](https://www.runoob.com/cprogramming/c-function-isupper.html) 该函数检查所传的字符是否是大写字母。 |
| 11   | [int isxdigit(int c)](https://www.runoob.com/cprogramming/c-function-isxdigit.html) 该函数检查所传的字符是否是十六进制数字。 |

标准库还包含了两个转换函数，它们接受并返回一个 "int"

| 序号 | 函数 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | [int tolower(int c)](https://www.runoob.com/cprogramming/c-function-tolower.html) 该函数把大写字母转换为小写字母。 |
| 2    | [int toupper(int c)](https://www.runoob.com/cprogramming/c-function-toupper.html) 该函数把小写字母转换为大写字母。 |

## 字符类

| 序号 | 字符类 & 描述                                                |
| ---- | ------------------------------------------------------------ |
| 1    | **数字** 完整的数字集合 { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }     |
| 2    | **十六进制数字** 集合 { 0 1 2 3 4 5 6 7 8 9 A B C D E F a b c d e f } |
| 3    | **小写字母** 集合 { a b c d e f g h i j k l m n o p q r s t u v w x y z } |
| 4    | **大写字母** 集合 {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z } |
| 5    | **字母** 小写字母和大写字母的集合                            |
| 6    | **字母数字字符** 数字、小写字母和大写字母的集合              |
| 7    | **标点符号字符** 集合 ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { \| } ~ |
| 8    | **图形字符** 字母数字字符和标点符号字符的集合                |
| 9    | **空格字符** 制表符、换行符、垂直制表符、换页符、回车符、空格符的集合。 |
| 10   | **可打印字符** 字母数字字符、标点符号字符和空格字符的集合。  |
| 11   | **控制字符** 在 ASCII 编码中，这些字符的八进制代码是从 000 到 037，以及 177（DEL）。 |
| 12   | **空白字符** 包括空格符和制表符。                            |
| 13   | **字母字符** 小写字母和大写字母的集合。                      |