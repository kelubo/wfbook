# <stddef.h>

## 简介

**stddef .h** 头文件定义了各种变量类型和宏，这些定义和宏主要用于内存管理、对象大小、和指针算术等方面。

## 库变量

下面是头文件 stddef.h 中定义的变量类型：

| 序号 | 变量 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | **ptrdiff_t** `ptrdiff_t` 是一种有符号整数类型，用于表示两个指针之间的差值。其定义同样依赖于实现，通常是 `int` 或 `long`。 `ptrdiff_t diff = ptr2 - ptr1; // 计算两个指针之间的差值` |
| 2    | **size_t**  这是无符号整数类型，它是 **sizeof** 关键字的结果，通常用来表示对象的大小或数组的索引。其定义依赖于实现，通常是 unsigned int 或 unsigned long。 `size_t size = sizeof(int); // 获取 int 类型的大小` |
| 3    | **wchar_t**  这是一个宽字符常量大小的整数类型，用于表示多字节字符。其大小和表示方式依赖于具体实现。`wchar_t wideChar = L'A'; // 宽字符常量` |

## 库宏

下面是头文件 stddef.h 中定义的宏：

| 序号 | 宏 & 描述                                                    |
| ---- | ------------------------------------------------------------ |
| 1    | [NULL](https://www.runoob.com/cprogramming/c-macro-null.html) 这个宏是一个空指针常量的值。 |
| 2    | [offsetof(type, member-designator)](https://www.runoob.com/cprogramming/c-macro-offsetof.html) 这会生成一个类型为 size_t 的整型常量，它是一个结构成员相对于结构开头的字节偏移量。成员是由 *member-designator* 给定的，结构的名称是在 *type* 中给定的。 |