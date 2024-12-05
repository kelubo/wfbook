#  <assert.h>

## 简介

C 标准库的 **assert.h**头文件提供了一个名为 **assert** 的宏，它可用于验证程序做出的假设，并在假设为假时输出诊断消息。

assert.h 标准库主要用于在程序运行时进行断言断言是一种用于测试假设的手段，通常用于调试阶段，以便在程序出现不符合预期的状态时立即发现问题。

`<assert.h>` 提供的断言机制是 C 语言中一个有用的工具，帮助开发人员在早期发现和修复程序中的错误。

已定义的宏 **assert** 指向另一个宏 **NDEBUG**，宏 **NDEBUG** 不是 <assert.h> 的一部分。如果已在引用 <assert.h> 的源文件中定义 NDEBUG 为宏名称，则 **assert** 宏的定义如下：

```
assert(expression)
```

assert 宏用于测试表达式 expression 是否为真。如果 expression 为假（即结果为 0），assert 会输出一条错误信息并终止程序的执行。这个错误信息包括以下内容：

- 触发断言失败的表达式
- 源文件名
- 行号

在发布版本中，可以通过定义 NDEBUG 来禁用所有的 assert 断言。例如：

```
#define NDEBUG
#include <assert.h>
```

一旦定义了 NDEBUG，assert 宏将被预处理为一个空语句，不会有任何运行时开销。

以下是一个简单的示例，演示了 assert 的基本用法：

## 实例

\#include <stdio.h>
 \#include <assert.h>
 
 void test_positive(int x) {
   assert(x > 0);
 }
 
 int main() {
   int a = 5;
   int b = -3;
 
   test_positive(a); // 这个断言通过
   test_positive(b); // 这个断言失败，程序终止
 
   printf("This line will not be executed if an assertion fails.**\n**");
 
   return 0;
 }

在上面的例子中，当调用 test_positive(b) 时，由于 b 是一个负数，断言 x > 0 将失败，程序会输出类似如下的信息并终止：

```
Assertion failed: (x > 0), file example.c, line 6
```

### 断言的作用

- **调试**：在开发阶段，通过断言可以快速发现程序中的逻辑错误或假设不成立的情况。
- **文档**：断言可以作为文档的一部分，描述函数的前置条件和后置条件。
- **防御性编程**：虽然不建议在生产代码中使用断言来进行参数检查，但在某些情况下，断言可以作为最后的防线。

### 注意事项

- **性能**：在性能敏感的代码中，断言可能会增加额外的开销，尤其是在大量调用的情况下。因此，发布版本中通常会禁用断言。
- **错误处理**：断言不应该用于处理可以预期并且可以恢复的错误情况。断言更多地用于捕获程序员的错误。

## 库宏

下面列出了头文件 assert.h 中定义的唯一的函数：

| 序号 | 函数 & 描述                                                  |
| ---- | ------------------------------------------------------------ |
| 1    | [void assert(int expression)](https://www.runoob.com/cprogramming/c-macro-assert.html) 这实际上是一个宏，不是一个函数，可用于在 C 程序中添加诊断。 |