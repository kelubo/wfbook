# <limits.h>

## 简介

`<limits.h>` 是 C 标准库中的一个头文件，定义了各种数据类型的限制。这些宏提供了有关整数类型（`char`、`short`、`int`、`long` 和 `long long` 等）和其他数据类型的最大值和最小值的信息。

这些限制指定了变量不能存储任何超出这些限制的值，例如一个无符号可以存储的最大值是 255。

## 库宏

下面的值是特定实现的，且是通过 #define 指令来定义的，这些值都不得低于下边所给出的值。

| **宏**           | **描述**                              | **值**                  |
| ---------------- | ------------------------------------- | ----------------------- |
| **字符类型**     |                                       |                         |
| `CHAR_BIT`       | `char` 类型的位数                     | 通常为 8                |
| `CHAR_MIN`       | `char` 类型的最小值（有符号或无符号） | -128 或 0               |
| `CHAR_MAX`       | `char` 类型的最大值（有符号或无符号） | 127 或 255              |
| `SCHAR_MIN`      | `signed char` 类型的最小值            | -128                    |
| `SCHAR_MAX`      | `signed char` 类型的最大值            | 127                     |
| `UCHAR_MAX`      | `unsigned char` 类型的最大值          | 255                     |
| **短整数类型**   |                                       |                         |
| `SHRT_MIN`       | `short` 类型的最小值                  | -32768                  |
| `SHRT_MAX`       | `short` 类型的最大值                  | 32767                   |
| `USHRT_MAX`      | `unsigned short` 类型的最大值         | 65535                   |
| **整数类型**     |                                       |                         |
| `INT_MIN`        | `int` 类型的最小值                    | -2147483648             |
| `INT_MAX`        | `int` 类型的最大值                    | 2147483647              |
| `UINT_MAX`       | `unsigned int` 类型的最大值           | 4294967295              |
| **长整数类型**   |                                       |                         |
| `LONG_MIN`       | `long` 类型的最小值                   | -9223372036854775808L   |
| `LONG_MAX`       | `long` 类型的最大值                   | 9223372036854775807L    |
| `ULONG_MAX`      | `unsigned long` 类型的最大值          | 18446744073709551615UL  |
| **长长整数类型** |                                       |                         |
| `LLONG_MIN`      | `long long` 类型的最小值              | -9223372036854775808LL  |
| `LLONG_MAX`      | `long long` 类型的最大值              | 9223372036854775807LL   |
| `ULLONG_MAX`     | `unsigned long long` 类型的最大值     | 18446744073709551615ULL |

## 实例

下面的实例演示了 limit.h 文件中定义的一些常量的使用。

## 实例

\#include <stdio.h>
 \#include <limits.h>
 
 int main() {
   printf("Character types:**\n**");
   printf("CHAR_BIT: %d**\n**", CHAR_BIT);
   printf("CHAR_MIN: %d**\n**", CHAR_MIN);
   printf("CHAR_MAX: %d**\n**", CHAR_MAX);
   printf("SCHAR_MIN: %d**\n**", SCHAR_MIN);
   printf("SCHAR_MAX: %d**\n**", SCHAR_MAX);
   printf("UCHAR_MAX: %u**\n**", UCHAR_MAX);
 
   printf("**\n**Short integer types:**\n**");
   printf("SHRT_MIN: %d**\n**", SHRT_MIN);
   printf("SHRT_MAX: %d**\n**", SHRT_MAX);
   printf("USHRT_MAX: %u**\n**", USHRT_MAX);
 
   printf("**\n**Integer types:**\n**");
   printf("INT_MIN: %d**\n**", INT_MIN);
   printf("INT_MAX: %d**\n**", INT_MAX);
   printf("UINT_MAX: %u**\n**", UINT_MAX);
 
   printf("**\n**Long integer types:**\n**");
   printf("LONG_MIN: %ld**\n**", LONG_MIN);
   printf("LONG_MAX: %ld**\n**", LONG_MAX);
   printf("ULONG_MAX: %lu**\n**", ULONG_MAX);
 
   printf("**\n**Long long integer types:**\n**");
   printf("LLONG_MIN: %lld**\n**", LLONG_MIN);
   printf("LLONG_MAX: %lld**\n**", LLONG_MAX);
   printf("ULLONG_MAX: %llu**\n**", ULLONG_MAX);
 
   return 0;
 }
 

让我们编译和运行上面的程序，这将产生下列结果：

```
Character types:
CHAR_BIT: 8
CHAR_MIN: -128
CHAR_MAX: 127
SCHAR_MIN: -128
SCHAR_MAX: 127
UCHAR_MAX: 255

Short integer types:
SHRT_MIN: -32768
SHRT_MAX: 32767
USHRT_MAX: 65535

Integer types:
INT_MIN: -2147483648
INT_MAX: 2147483647
UINT_MAX: 4294967295

Long integer types:
LONG_MIN: -9223372036854775808
LONG_MAX: 9223372036854775807
ULONG_MAX: 18446744073709551615

Long long integer types:
LLONG_MIN: -9223372036854775808
LLONG_MAX: 9223372036854775807
ULLONG_MAX: 18446744073709551615
```

`<limits.h>` 提供了许多与整数类型相关的宏，用于描述各种数据类型的限制。这些宏对于编写健壮和移植性强的代码非常有用，因为它们允许程序员在不同平台上轻松获取数据类型的限制值。