# <string.h>

## 简介

**string .h** 头文件定义了一个变量类型、一个宏和各种操作字符数组的函数。

`<string.h>` 是 C 标准库中的一个头文件，提供了一组用于处理字符串和内存块的函数。这些函数涵盖了字符串复制、连接、比较、搜索和内存操作等。

## 库变量

下面是头文件 string.h 中定义的变量类型：

| 序号 | 变量 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | **size_t**  这是无符号整数类型，它是 **sizeof** 关键字的结果。 |

## 库宏

下面是头文件 string.h 中定义的宏：

| 序号 | 宏 & 描述                             |
| ---- | ------------------------------------- |
| 1    | **NULL** 这个宏是一个空指针常量的值。 |

## 库函数

下面是头文件 string.h 中定义的函数：

| 序号 | 函数 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | [void *memchr(const void *str, int c, size_t n)](https://www.runoob.com/cprogramming/c-function-memchr.html) 在参数 *str* 所指向的字符串的前 n 个字节中搜索第一次出现字符 c（一个无符号字符）的位置。 |
| 2    | [int memcmp(const void *str1, const void *str2, size_t n)](https://www.runoob.com/cprogramming/c-function-memcmp.html) 把 *str1* 和 *str2* 的前 n 个字节进行比较。 |
| 3    | [void *memcpy(void *dest, const void *src, size_t n)](https://www.runoob.com/cprogramming/c-function-memcpy.html) 从 src 复制 n 个字符到 *dest*。 |
| 4    | [void *memmove(void *dest, const void *src, size_t n)](https://www.runoob.com/cprogramming/c-function-memmove.html) 另一个用于从 *src* 复制 n 个字符到 *dest* 的函数。 |
| 5    | [void *memset(void *str, int c, size_t n)](https://www.runoob.com/cprogramming/c-function-memset.html) 将指定的值 c 复制到 str 所指向的内存区域的前 n 个字节中。 |
| 6    | [char *strcat(char *dest, const char *src)](https://www.runoob.com/cprogramming/c-function-strcat.html) 把 *src* 所指向的字符串追加到 *dest* 所指向的字符串的结尾。 |
| 7    | [char *strncat(char *dest, const char *src, size_t n)](https://www.runoob.com/cprogramming/c-function-strncat.html) 把 *src* 所指向的字符串追加到 *dest* 所指向的字符串的结尾，直到 n 字符长度为止。 |
| 8    | [char *strchr(const char *str, int c)](https://www.runoob.com/cprogramming/c-function-strchr.html) 在参数 *str* 所指向的字符串中搜索第一次出现字符 c（一个无符号字符）的位置。 |
| 9    | [int strcmp(const char *str1, const char *str2)](https://www.runoob.com/cprogramming/c-function-strcmp.html) 把 *str1* 所指向的字符串和 *str2* 所指向的字符串进行比较。 |
| 10   | [int strncmp(const char *str1, const char *str2, size_t n)](https://www.runoob.com/cprogramming/c-function-strncmp.html) 把 *str1* 和 *str2* 进行比较，最多比较前 n 个字节。 |
| 11   | [int strcoll(const char *str1, const char *str2)](https://www.runoob.com/cprogramming/c-function-strcoll.html) 把 *str1* 和 *str2* 进行比较，结果取决于 LC_COLLATE 的位置设置。 |
| 12   | [char *strcpy(char *dest, const char *src)](https://www.runoob.com/cprogramming/c-function-strcpy.html) 把 *src* 所指向的字符串复制到 *dest*。 |
| 13   | [char *strncpy(char *dest, const char *src, size_t n)](https://www.runoob.com/cprogramming/c-function-strncpy.html) 把 *src* 所指向的字符串复制到 *dest*，最多复制 n 个字符。 |
| 14   | [size_t strcspn(const char *str1, const char *str2)](https://www.runoob.com/cprogramming/c-function-strcspn.html) 检索字符串 str1 开头连续有几个字符都不含字符串 str2 中的字符。 |
| 15   | [char *strerror(int errnum)](https://www.runoob.com/cprogramming/c-function-strerror.html) 从内部数组中搜索错误号 errnum，并返回一个指向错误消息字符串的指针。 |
| 16   | [size_t strlen(const char *str)](https://www.runoob.com/cprogramming/c-function-strlen.html) 计算字符串 str 的长度，直到空结束字符，但不包括空结束字符。 |
| 17   | [char *strpbrk(const char *str1, const char *str2)](https://www.runoob.com/cprogramming/c-function-strpbrk.html) 检索字符串 *str1* 中第一个匹配字符串 *str2* 中字符的字符，不包含空结束字符。也就是说，依次检验字符串 str1 中的字符，当被检验字符在字符串 str2 中也包含时，则停止检验，并返回该字符位置。 |
| 18   | [char *strrchr(const char *str, int c)](https://www.runoob.com/cprogramming/c-function-strrchr.html) 在参数 *str* 所指向的字符串中搜索最后一次出现字符 c（一个无符号字符）的位置。 |
| 19   | [size_t strspn(const char *str1, const char *str2)](https://www.runoob.com/cprogramming/c-function-strspn.html) 检索字符串 *str1* 中第一个不在字符串 *str2* 中出现的字符下标。 |
| 20   | [char *strstr(const char *haystack, const char *needle)](https://www.runoob.com/cprogramming/c-function-strstr.html) 在字符串 *haystack* 中查找第一次出现字符串 *needle*（不包含空结束字符）的位置。 |
| 21   | [char *strtok(char *str, const char *delim)](https://www.runoob.com/cprogramming/c-function-strtok.html) 分解字符串 *str* 为一组字符串，*delim* 为分隔符。 |
| 22   | [size_t strxfrm(char *dest, const char *src, size_t n)](https://www.runoob.com/cprogramming/c-function-strxfrm.html) 根据程序当前的区域选项中的 LC_COLLATE 来转换字符串 **src** 的前 **n** 个字符，并把它们放置在字符串 **dest** 中。 |

### 实例

以下是使用 `<string.h>` 中一些函数的示例。

复制字符串：

## 实例

\#include <stdio.h>
 \#include <string.h>
 
 int main() {
   char src[] = "Hello, World!";
   char dest[50];
 
   strcpy(dest, src);
   printf("Copied string: %s**\n**", dest);
 
   return 0;
 }

连接字符串:

## 实例

\#include <stdio.h>
 \#include <string.h>
 
 int main() {
   char str1[50] = "Hello";
   char str2[] = ", World!";
 
   strcat(str1, str2);
   printf("Concatenated string: %s**\n**", str1);
 
   return 0;
 }

比较字符串:

## 实例

\#include <stdio.h>
 \#include <string.h>
 
 int main() {
   char str1[] = "Hello";
   char str2[] = "World";
 
   int result = strcmp(str1, str2);
   if (result == 0) {
     printf("Strings are equal**\n**");
   } else {
     printf("Strings are not equal**\n**");
   }
 
   return 0;
 }

查找字符在字符串中的第一次出现:

## 实例

\#include <stdio.h>
 \#include <string.h>
 
 int main() {
   char str[] = "Hello, World!";
   char *ptr = strchr(str, 'o');
 
   if (ptr != NULL) {
     printf("First occurrence of 'o' found at position: %ld**\n**", ptr - str);
   } else {
     printf("Character not found**\n**");
   }
 
   return 0;
 }

复制内存块:

## 实例

\#include <stdio.h>
 \#include <string.h>
 
 int main() {
   char src[] = "Hello, World!";
   char dest[50];
 
   memcpy(dest, src, strlen(src) + 1);
   printf("Copied memory: %s**\n**", dest);
 
   return 0;
 }

### 注意事项

- 使用字符串函数时，需要确保目标缓冲区有足够的空间来存储结果，以避免缓冲区溢出。
- `strncpy` 和 `strncat` 可以指定要复制或连接的最大字符数，有助于防止缓冲区溢出。
- `strtok` 函数不是线程安全的，因为它在内部使用静态变量来保存上下文。如果在多线程环境中使用，需要使用 `strtok_r` 函数。
- 使用 `memcpy` 时，源和目标内存区域不应重叠。如果可能会重叠，应该使用 `memmove`。

通过理解和使用 `<string.h>` 提供的函数，可以方便地进行字符串和内存操作，编写更加高效和可靠的 C 程序。