#  <locale.h>

## 简介

`<locale.h>` 是 C 标准库中的一个头文件，用于支持程序的国际化和本地化。它提供了一组函数和宏来设置或查询程序的本地化信息，例如日期、时间、货币、数字格式等。

接下来我们将介绍一些宏，以及一个重要的结构 **struct lconv** 和两个重要的函数。

## 库宏

下面列出了头文件 locale.h 中定义的宏，这些宏将在下列的两个函数中使用：

| 序号 | 宏 & 描述                                                    |
| ---- | ------------------------------------------------------------ |
| 1    | **LC_ALL** 用于设置或查询所有本地化类别。                    |
| 2    | **LC_COLLATE** 用于设置或查询字符串比较的本地化信息。        |
| 3    | **LC_CTYPE** 用于设置或查询字符处理的本地化信息。            |
| 4    | **LC_MONETARY** 用于设置或查询货币格式的本地化信息。         |
| 5    | **LC_NUMERIC** 用于设置或查询数字格式的本地化信息（例如小数点的符号）。 |
| 6    | **LC_TIME** 用于设置或查询时间格式的本地化信息。             |
| 7    | **locale_t** 表示区域设置信息的类型。                        |

## 库函数

下面列出了头文件 locale.h 中定义的函数：

| 序号 | 函数 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | [char *setlocale(int category, const char *locale)](https://www.runoob.com/cprogramming/c-function-setlocale.html) 设置或读取地域化信息。 |
| 2    | [struct lconv *localeconv(void)](https://www.runoob.com/cprogramming/c-function-localeconv.html) 设置或读取地域化信息。 |
| 3    | [locale_t newlocale(int category_mask, const char *locale, locale_t base)](https://www.runoob.com/cprogramming/c-function-newlocale.html) 创建一个新的本地化对象。 |
| 4    | [freelocale(locale_t locale)](https://www.runoob.com/cprogramming/c-function-freelocale.html) 释放一个本地化对象。 |
| 5    | [locale_t uselocale(locale_t newloc)](https://www.runoob.com/cprogramming/c-function-uselocale.html) 设置或查询线程的本地化对象。 |

### 实例

设置和查询本地化信息:

## 实例

\#include <stdio.h>
 \#include <locale.h>
 
 int main() {
   *// 设置本地化信息为用户环境变量中的默认设置*
   setlocale(LC_ALL, "");
 
   *// 获取和打印当前的本地化信息*
   printf("Current locale for LC_ALL: %s**\n**", setlocale(LC_ALL, NULL));
   printf("Current locale for LC_TIME: %s**\n**", setlocale(LC_TIME, NULL));
   printf("Current locale for LC_NUMERIC: %s**\n**", setlocale(LC_NUMERIC, NULL));
 
   return 0;
 }

编译输出结果为：

```
Current locale for LC_ALL: zh_CN.UTF-8
Current locale for LC_TIME: zh_CN.UTF-8
Current locale for LC_NUMERIC: zh_CN.UTF-8
```

获取数字和货币格式信息:

## 实例

\#include <stdio.h>
 \#include <locale.h>
 
 int main() {
   *// 设置本地化信息为用户环境变量中的默认设置*
   setlocale(LC_ALL, "");
 
   *// 获取本地化的数字和货币格式信息*
   struct lconv *lc = localeconv();
 
   *// 打印数字和货币格式信息*
   printf("Decimal point character: %s**\n**", lc->decimal_point);
   printf("Thousands separator: %s**\n**", lc->thousands_sep);
   printf("Currency symbol: %s**\n**", lc->currency_symbol);
 
   return 0;
 }

编译输出结果为：

```
Decimal point character: .
Thousands separator: ,
Currency symbol: ￥
```

使用自定义本地化对象:

## 实例

\#include <stdio.h>
 \#include <locale.h>
 \#include <xlocale.h>
 
 int main() {
   *// 创建一个新的本地化对象，使用 "en_US.UTF-8" 区域设置*
   locale_t newloc = newlocale(LC_ALL_MASK, "en_US.UTF-8", (locale_t)0);
 
   *// 将当前线程的本地化对象设置为新的本地化对象*
   locale_t oldloc = uselocale(newloc);
 
   *// 获取和打印当前线程的本地化信息*
   printf("Current locale for LC_NUMERIC: %s**\n**", setlocale(LC_NUMERIC, NULL));
 
   *// 释放新的本地化对象*
   uselocale(oldloc);
   freelocale(newloc);
 
   return 0;
 }

编译输出结果为：

```
Current locale for LC_NUMERIC: C
```



## 库结构

```
typedef struct {
   char *decimal_point;
   char *thousands_sep;
   char *grouping;    
   char *int_curr_symbol;
   char *currency_symbol;
   char *mon_decimal_point;
   char *mon_thousands_sep;
   char *mon_grouping;
   char *positive_sign;
   char *negative_sign;
   char int_frac_digits;
   char frac_digits;
   char p_cs_precedes;
   char p_sep_by_space;
   char n_cs_precedes;
   char n_sep_by_space;
   char p_sign_posn;
   char n_sign_posn;
} lconv
```

以下是各字段的描述：

| 序号 | 字段 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | **decimal_point** 用于非货币值的小数点字符。                 |
| 2    | **thousands_sep** 用于非货币值的千位分隔符。                 |
| 3    | **grouping** 一个表示非货币量中每组数字大小的字符串。每个字符代表一个整数值，每个整数指定当前组的位数。值为 0 意味着前一个值将应用于剩余的分组。 |
| 4    | **int_curr_symbol** 国际货币符号使用的字符串。前三个字符是由 ISO 4217:1987 指定的，第四个字符用于分隔货币符号和货币量。 |
| 5    | **currency_symbol** 用于货币的本地符号。                     |
| 6    | **mon_decimal_point** 用于货币值的小数点字符。               |
| 7    | **mon_thousands_sep** 用于货币值的千位分隔符。               |
| 8    | **mon_grouping** 一个表示货币值中每组数字大小的字符串。每个字符代表一个整数值，每个整数指定当前组的位数。值为 0 意味着前一个值将应用于剩余的分组。 |
| 9    | **positive_sign** 用于正货币值的字符。                       |
| 10   | **negative_sign** 用于负货币值的字符。                       |
| 11   | **int_frac_digits** 国际货币值中小数点后要显示的位数。       |
| 12   | **frac_digits** 货币值中小数点后要显示的位数。               |
| 13   | **p_cs_precedes** 如果等于 1，则 currency_symbol 出现在正货币值之前。如果等于 0，则 currency_symbol 出现在正货币值之后。 |
| 14   | **p_sep_by_space** 如果等于 1，则 currency_symbol 和正货币值之间使用空格分隔。如果等于 0，则 currency_symbol 和正货币值之间不使用空格分隔。 |
| 15   | **n_cs_precedes** 如果等于 1，则 currency_symbol 出现在负货币值之前。如果等于 0，则 currency_symbol 出现在负货币值之后。 |
| 16   | **n_sep_by_space** 如果等于 1，则 currency_symbol 和负货币值之间使用空格分隔。如果等于 0，则 currency_symbol 和负货币值之间不使用空格分隔。 |
| 17   | **p_sign_posn** 表示正货币值中正号的位置。                   |
| 18   | **n_sign_posn** 表示负货币值中负号的位置。                   |

下面的值用于 **p_sign_posn** 和 **n_sign_posn**:

| 值   | 描述                                          |
| ---- | --------------------------------------------- |
| 0    | 封装值和 currency_symbol 的括号。             |
| 1    | 放置在值和 currency_symbol 之前的符号。       |
| 2    | 放置在值和 currency_symbol 之后的符号。       |
| 3    | 紧挨着放置在值和 currency_symbol 之前的符号。 |
| 4    | 紧挨着放置在值和 currency_symbol 之后的符号。 |

​			