# <errno.h>

## 简介

C 标准库的 **errno.h** 头文件定义了整数变量 **errno**，它是通过系统调用设置的，在错误事件中的某些库函数表明了什么发生了错误。该宏扩展为类型为 int 的可更改的左值，因此它可以被一个程序读取和修改。

`<errno.h>` 是 C 标准库中的一个头文件，提供了一种在程序中报告和处理错误的机制。这个头文件定义了宏和变量，用于指示和描述运行时错误的类型。

**errno.h** 头文件定义了一系列表示不同错误代码的宏，这些宏应扩展为类型为 **int** 的整数常量表达式。

`errno` 是一个全局变量，用于存储最近发生的错误代码。这个变量的类型为 `int`。当一个库函数发生错误时，它通常会设置 `errno` 以指示错误类型。

例如，在文件操作中，如果 `fopen` 函数因为文件不存在而失败，它会将 `errno` 设置为 `ENOENT`。

### 常用错误码

以下是一些常见的错误码，它们在 `<errno.h>` 中定义为宏：

- `EPERM`：操作不允许
- `ENOENT`：没有这样的文件或目录
- `ESRCH`：没有这样的进程
- `EINTR`：中断的系统调用
- `EIO`：输入/输出错误
- `ENXIO`：没有这样的设备或地址
- `E2BIG`：参数列表太长
- `ENOMEM`：内存不足
- `EACCES`：权限被拒绝
- `EFAULT`：坏的地址
- `EBUSY`：资源忙
- `EEXIST`：文件已存在
- `EXDEV`：跨设备链接
- `ENODEV`：没有这样的设备
- `ENOTDIR`：不是一个目录
- `EISDIR`：是一个目录
- `EINVAL`：无效的参数
- `ENFILE`：系统文件表溢出
- `EMFILE`：打开的文件过多
- `ENOTTY`：不是终端设备
- `ETXTBSY`：文本文件忙
- `EFBIG`：文件过大
- `ENOSPC`：设备上没有空间
- `ESPIPE`：非法的寻址
- `EROFS`：只读文件系统
- `EMLINK`：链接过多
- `EPIPE`：管道破裂

### 使用示例

以下是一个使用 errno 的简单示例，演示如何处理文件打开错误：

## 实例

\#include <stdio.h>
 \#include <errno.h>
 \#include <string.h>
 
 int main() {
   FILE *file = fopen("nonexistent_file.txt", "r");
   if (file == NULL) {
     printf("Error opening file: %s**\n**", strerror(errno));
     return 1;
   }
 
   // 文件处理代码
   fclose(file);
   return 0;
 }

在这个示例中，如果 `fopen` 函数失败，`errno` 将被设置为相应的错误码。`strerror` 函数用于将 `errno` 转换为人类可读的错误消息。

### 注意事项

1. **线程安全**：在多线程程序中，`errno` 通常实现为线程局部存储（Thread-Local Storage, TLS），以确保每个线程有独立的错误码。
2. **初始值**：在成功调用的情况下，库函数通常不会修改 `errno` 的值。因此在检查错误之前，应确保 `errno` 被设置为 0。
3. **错误码范围**：不同的操作系统和 C 标准库实现可能会定义额外的错误码。程序应避免依赖特定错误码的数值。

### 错误处理建议

1. **检查返回值**：在调用可能失败的函数时，总是检查其返回值。
2. **设定 `errno` 为 0**：在调用一个函数前，可以将 `errno` 设定为 0，以便在调用后检查 `errno` 是否被修改。
3. **使用 `strerror`**：通过 `strerror` 将 `errno` 转换为可读的字符串，便于调试和日志记录。

总之，`<errno.h>` 提供了一种标准化的方式来报告和处理程序中的错误，使得错误处理代码更为一致和可维护。

## 库宏

下面列出了头文件 errno.h 中定义的宏：

| 序号 | 宏 & 描述                                                    |
| ---- | ------------------------------------------------------------ |
| 1    | [extern int errno](https://www.runoob.com/cprogramming/c-macro-errno.html) 这是通过系统调用设置的宏，在错误事件中的某些库函数表明了什么发生了错误。 |
| 2    | [EDOM Domain Error](https://www.runoob.com/cprogramming/c-macro-edom.html) 这个宏表示一个域错误，它在输入参数超出数学函数定义的域时发生，errno 被设置为 EDOM。 |
| 3    | [ERANGE Range Error](https://www.runoob.com/cprogramming/c-macro-erange.html) 这个宏表示一个范围错误，它在输入参数超出数学函数定义的范围时发生，errno 被设置为 ERANGE。 |