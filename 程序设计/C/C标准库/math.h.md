# <math.h>

## 简介

**math.h** 头文件定义了各种数学函数和一个宏。在这个库中所有可用的功能都带有一个 **double** 类型的参数，且都返回 **double** 类型的结果。

`<math.h>` 是 C 标准库中的一个头文件，包含了大量用于数学运算的函数和宏。这些函数和宏提供了基本的算术运算、三角函数、指数函数、对数函数、幂函数、舍入函数等。

## 库宏

在 `<math.h>` 中，有一些宏用于表示数学函数的错误状态：

| 宏             | 描述                                                         |
| -------------- | ------------------------------------------------------------ |
| `HUGE_VAL`     | 当函数结果溢出时返回的值（正无穷大）。此宏代表一个非常大的双精度浮点数，通常用来作为某些数学函数在结果超出可表示范围时的返回值。当一个函数的结果太大以至于无法用正常的浮点数表示（即发生上溢）时，会设置 errno 为 ERANGE（范围错误），并返回 HUGE_VAL 或其负值（对于负无穷大）。 |
| `HUGE_VALF`    | 当函数结果溢出时返回的值（正无穷大，浮点型）                 |
| `HUGE_VALL`    | 当函数结果溢出时返回的值（正无穷大，长双精度）               |
| `INFINITY`     | 正无穷大                                                     |
| `NAN`          | 非数字值（Not-A-Number）                                     |
| `FP_INFINITE`  | 表示无穷大                                                   |
| `FP_NAN`       | 表示非数字值                                                 |
| `FP_NORMAL`    | 表示正常的浮点数                                             |
| `FP_SUBNORMAL` | 表示次正规数                                                 |
| `FP_ZERO`      | 表示零                                                       |

## 库函数

下面列出了头文件 math.h 中定义的函数：

| 序号 | 函数 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | [double acos(double x)](https://www.runoob.com/cprogramming/c-function-acos.html) 返回以弧度表示的 x 的反余弦。 |
| 2    | [double asin(double x)](https://www.runoob.com/cprogramming/c-function-asin.html) 返回以弧度表示的 x 的反正弦。 |
| 3    | [double atan(double x)](https://www.runoob.com/cprogramming/c-function-atan.html) 返回以弧度表示的 x 的反正切。 |
| 4    | [double atan2(double y, double x)](https://www.runoob.com/cprogramming/c-function-atan2.html) 返回以弧度表示的 y/x 的反正切。y 和 x 的值的符号决定了正确的象限。 |
| 5    | [double cos(double x)](https://www.runoob.com/cprogramming/c-function-cos.html) 返回弧度角 x 的余弦。 |
| 6    | [double cosh(double x)](https://www.runoob.com/cprogramming/c-function-cosh.html) 返回 x 的双曲余弦。 |
| 7    | [double sin(double x)](https://www.runoob.com/cprogramming/c-function-sin.html) 返回弧度角 x 的正弦。 |
| 8    | [double sinh(double x)](https://www.runoob.com/cprogramming/c-function-sinh.html) 返回 x 的双曲正弦。 |
| 9    | [double tanh(double x)](https://www.runoob.com/cprogramming/c-function-tanh.html) 返回 x 的双曲正切。 |
| 10   | [double exp(double x)](https://www.runoob.com/cprogramming/c-function-exp.html) 返回 e 的 x 次幂的值。 |
| 11   | [double frexp(double x, int *exponent)](https://www.runoob.com/cprogramming/c-function-frexp.html) 把浮点数 x 分解成尾数和指数。返回值是尾数，并将指数存入 exponent 中。所得的值是 x = mantissa * 2 ^ exponent。 |
| 12   | [double ldexp(double x, int exponent)](https://www.runoob.com/cprogramming/c-function-ldexp.html) 返回 x 乘以 2 的 exponent 次幂。 |
| 13   | [double log(double x)](https://www.runoob.com/cprogramming/c-function-log.html) 返回 x 的自然对数（基数为 e 的对数）。 |
| 14   | [double log10(double x)](https://www.runoob.com/cprogramming/c-function-log10.html) 返回 x 的常用对数（基数为 10 的对数）。 |
| 15   | [double modf(double x, double *integer)](https://www.runoob.com/cprogramming/c-function-modf.html) 返回值为小数部分（小数点后的部分），并设置 integer 为整数部分。 |
| 16   | [double pow(double x, double y)](https://www.runoob.com/cprogramming/c-function-pow.html) 返回 x 的 y 次幂。 |
| 17   | [double sqrt(double x)](https://www.runoob.com/cprogramming/c-function-sqrt.html) 返回 x 的平方根。 |
| 18   | [double ceil(double x)](https://www.runoob.com/cprogramming/c-function-ceil.html) 返回大于或等于 x 的最小的整数值。 |
| 19   | [double fabs(double x)](https://www.runoob.com/cprogramming/c-function-fabs.html) 返回 x 的绝对值。 |
| 20   | [double floor(double x)](https://www.runoob.com/cprogramming/c-function-floor.html) 返回小于或等于 x 的最大的整数值。 |
| 21   | [double fmod(double x, double y)](https://www.runoob.com/cprogramming/c-function-fmod.html) 返回 x 除以 y 的余数。 |

### 常用数学常量

以下是 `<math.h>` 中定义的一些常用数学常量：

| 常量         | 值                     | 描述             |
| ------------ | ---------------------- | ---------------- |
| `M_PI`       | 3.14159265358979323846 | 圆周率 π         |
| `M_E`        | 2.71828182845904523536 | 自然对数的底数 e |
| `M_LOG2E`    | 1.44269504088896340736 | log2(e)          |
| `M_LOG10E`   | 0.43429448190325182765 | log10(e)         |
| `M_LN2`      | 0.69314718055994530942 | ln(2)            |
| `M_LN10`     | 2.30258509299404568402 | ln(10)           |
| `M_PI_2`     | 1.57079632679489661923 | π/2              |
| `M_PI_4`     | 0.78539816339744830962 | π/4              |
| `M_1_PI`     | 0.31830988618379067154 | 1/π              |
| `M_2_PI`     | 0.63661977236758134308 | 2/π              |
| `M_2_SQRTPI` | 1.12837916709551257390 | 2/√π             |
| `M_SQRT2`    | 1.41421356237309504880 | √2               |
| `M_SQRT1_2`  | 0.70710678118654752440 | 1/√2             |

以下是使用 `<math.h>` 中的函数和常量的示例代码：

## 实例

\#include <stdio.h>
 \#include <math.h>
 
 int main() {
   double x = 2.0;
   double y = 3.0;
 
   *// 基本运算*
   printf("sqrt(%.1f) = %.2f**\n**", x, sqrt(x));
   printf("pow(%.1f, %.1f) = %.2f**\n**", x, y, pow(x, y));
   printf("exp(%.1f) = %.2f**\n**", x, exp(x));
   printf("log(%.1f) = %.2f**\n**", x, log(x));
   printf("log10(%.1f) = %.2f**\n**", x, log10(x));
 
   *// 三角函数*
   double angle = M_PI / 4; *// 45 degrees*
   printf("sin(%.2f) = %.2f**\n**", angle, sin(angle));
   printf("cos(%.2f) = %.2f**\n**", angle, cos(angle));
   printf("tan(%.2f) = %.2f**\n**", angle, tan(angle));
 
   *// 舍入函数*
   double z = 5.8;
   printf("ceil(%.1f) = %.1f**\n**", z, ceil(z));
   printf("floor(%.1f) = %.1f**\n**", z, floor(z));
   printf("fabs(%.1f) = %.1f**\n**", z, fabs(z));
 
   return 0;
 }

运行上述程序将输出类似以下内容：

```
sqrt(2.0) = 1.41
pow(2.0, 3.0) = 8.00
exp(2.0) = 7.39
log(2.0) = 0.69
log10(2.0) = 0.30
sin(0.79) = 0.71
cos(0.79) = 0.71
tan(0.79) = 1.00
ceil(5.8) = 6.0
floor(5.8) = 5.0
fabs(5.8) = 5.8
```

`<math.h>` 提供了一系列的数学函数和常量，帮助程序员在 C 语言中进行各种数学计算。通过使用这些函数和常量，可以轻松实现复杂的数学运算，从而提高程序的效率和可读性。