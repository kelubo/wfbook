# <stdarg.h>

`<stdarg.h>` 是 C 标准库中的一个头文件，提供了一组宏，用于访问可变数量的参数。

**stdarg.h** 头文件定义了一个变量类型 **va_list** 和三个宏，这三个宏可用于在参数个数未知（即参数个数可变）时获取函数中的参数。

可变参数的函数通在参数列表的末尾是使用省略号 ... 定义的。

## 库变量

下面是头文件 stdarg.h 中定义的变量类型：

| 序号 | 变量 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | **va_list**  这是一个适用于 **va_start()、va_arg()** 和 **va_end()** 这三个宏存储信息的类型。用于存储可变参数信息的类型。 |

## 库宏

下面是头文件 stdarg.h 中定义的宏：

| 序号 | 宏 & 描述                                                    |
| ---- | ------------------------------------------------------------ |
| 1    | [void va_start(va_list ap, last_arg)](https://www.runoob.com/cprogramming/c-macro-va_start.html) 这个宏初始化 **ap** 变量，它与 **va_arg** 和 **va_end** 宏是一起使用的。**last_arg** 是最后一个传递给函数的已知的固定参数，即省略号之前的参数。 |
| 2    | [type va_arg(va_list ap, type)](https://www.runoob.com/cprogramming/c-macro-va_arg.html) 这个宏检索函数参数列表中类型为 **type** 的下一个参数。 |
| 3    | [void va_end(va_list ap)](https://www.runoob.com/cprogramming/c-macro-va_end.html) 这个宏允许使用了 **va_start** 宏的带有可变参数的函数返回。如果在从函数返回之前没有调用 **va_end**，则结果为未定义。 |

### 实例

以下是一个使用 `<stdarg.h>` 实现可变参数函数的示例。该函数计算所有参数的总和：

## 实例

\#include <stdio.h>
 \#include <stdarg.h>
 
 *// 计算可变参数的和*
 int sum(int count, ...) {
   int total = 0;
   va_list args;
   
   *// 初始化 args 以访问可变参数*
   va_start(args, count);
   
   *// 逐个访问可变参数*
   for (int i = 0; i < count; i++) {
     total += va_arg(args, int);
   }
   
   *// 清理 args*
   va_end(args);
   
   return total;
 }
 
 int main() {
   printf("Sum of 1, 2, 3: %d**\n**", sum(3, 1, 2, 3)); *// 输出 6*
   printf("Sum of 4, 5, 6, 7: %d**\n**", sum(4, 4, 5, 6, 7)); *// 输出 22*
   return 0;
 }

输出结果:

```
Sum of 1, 2, 3: 6
Sum of 4, 5, 6, 7: 22
```

### 解析

- `va_list args;`：声明一个 `va_list` 变量，用于访问可变参数。
- `va_start(args, count);`：初始化 `args` 以遍历可变参数列表，从 `count` 之后的第一个参数开始。
- `total += va_arg(args, int);`：获取可变参数列表中的下一个参数，并将其累加到 `total` 中。参数类型为 `int`。
- `va_end(args);`：清理 `args`。

### 注意事项

- 可变参数列表中的每个参数类型必须明确，且必须一致地传递给 `va_arg`。
- 使用 `va_start` 后，必须使用 `va_end` 清理 `va_list` 变量。
- `va_start`、`va_arg` 和 `va_end` 宏在一个函数中应成对使用，以避免未定义行为。