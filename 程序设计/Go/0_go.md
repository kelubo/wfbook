# Go

[TOC]

## 概述

Go 语言是由谷歌开发的一个编译型的静态语言。是非常年轻的一门语言，主要目标是“兼具 Python 等动态语言的开发速度和 C/C++ 等编译型语言的性能与安全性”。

Go 语言有着和 C 语言类似的语法外表。 但不仅仅是一个更新的 C 语言。还从其他语言借鉴了很多好的想法，同时避免引入过度的复杂性。 Go 语言中和并发编程相关的特性是全新的也是有效的，同时对数据抽象和面向对象编程的支持也很灵活。 Go 语言同时还集成了自动垃圾收集技术用于更好地管理内存。

Go 语言是一个开源的项目，可以免费获取编译器、库、配套工具的源代码。Go 语言可以运行在多种系统上—— 比如 Linux 、FreeBSD 、OpenBSD 、Mac OS X 、Plan9 和 Microsoft Windows 。 Go 语言编写的程序无需修改就可以运行在上面这些环境。

Go 语言没有类和继承的概念。通过接口（interface）的概念来实现多态性。

 ![img](../../Image/g/o/go.png)

**吉祥物：** Go Gopher，这是插画家 Renee French 设计的，她是 Go 设计者之一 Rob Pike 的妻子。

## 适用场景

优点：

- 并发是语言的一部分，所以编写多线程程序会是一件很容易的事。
- 是一种编译型语言。源代码会编译为二进制机器码。
- 语言规范十分简洁。所有规范都在一个页面展示，你甚至都可以用它来编写你自己的编译器。
- Go 编译器支持静态链接。所有 Go 代码都可以静态链接为一个大的二进制文件，并可以轻松部署到云服务器，而不必担心各种依赖性。

适用场景：

- 服务端开发
- 分布式系统，微服务
- 网络编程
- 区块链开发
- 内存KV数据库，例如 boltDB、levelDB
- 云平台

## Hello World 实例

Go 语言的基础组成有以下几个部分：

- 包声明
- 引入包
- 函数
- 变量
- 语句 & 表达式
- 注释

```go
package main
import "fmt"

func main() {
   /* 这是我的第一个简单的程序 */
   fmt.Println("Hello, World!")
}
```

1. 第一行代码 `package main` 定义了包名。必须在源文件中非注释的第一行指明这个文件属于哪个包。`package main` 表示一个可独立执行的程序，每个 Go 应用程序都包含一个名为 `main` 的包。
2. 下一行 `import "fmt"` 告诉 Go 编译器这个程序需要使用 `fmt` 包（的函数，或其他元素），`fmt` 包实现了格式化 IO（输入/输出）的函数。
3. 下一行 `func main()` 是程序开始执行的函数。`main` 函数是每一个可执行程序所必须包含的，一般来说都是在启动后第一个执行的函数（如果有 `init()` 函数则会先执行该函数）。man函数没有参数，且必须放在 main 包中。
4. 下一行 `/*...*/` 是注释，在程序执行时将被忽略。 
5. 下一行 `fmt.Println(...) `可以将字符串输出到控制台，并在最后自动增加换行字符 `\n`。 
   使用 `fmt.Print("hello, world\n")` 可以得到相同的结果。 `Print` 和 `Println ` 这两个函数也支持使用变量，如：`fmt.Println(arr)` 。如果没有特别指定，它们会以默认的打印格式将变量 `arr` 输出到控制台。
7. 源文件使用UTF-8编码，以 `.go` 作为文件扩展名，语句结束分号会被默认省略。
8. `{ ` 不能单独放在一行。
9. 不能存在未使用的导入，否则编译器会将其当做错误。

### 执行 Go 程序

1. 使用编辑器编辑代码。将代码保存为 `hello.go`

2. 打开命令行，并进入程序文件保存的目录中。

3. 执行代码。 

   ```bash
   go run hello.go
   Hello, World!
   ```

4. 还可以使用 `go build` 命令来生成二进制文件：

   ```bash
   go build hello.go 
   
   ls
   hello    hello.go
   
   ./hello 
   Hello, World!
   ```

5. 使用 `go install` 命令 - 运行 `go install hello`，接着可以用 `workspacepath/bin/hello` 来运行该程序。

   当输入 `go install hello` 时，go 工具会在工作区中搜索 hello 包（hello 称之为包）。接下来它会在工作区的 bin 目录下，创建一个名为 `hello`（Windows 下名为 `hello.exe`）的二进制文件。其目录结构如下所示：

   ```bash
   go
     bin
       hello
     src
       hello
         helloworld.go
   ```

可以生成一个 `build.sh` 脚本，用于在指定位置产生已编译好的可执文件:

```bash
#!/usr/bin/env bash

CURRENT_DIR=`pwd`
OLD_GO_PATH="$GOPATH"  #例如: /usr/local/go
OLD_GO_BIN="$GOBIN"    #例如: /usr/local/go/bin

export GOPATH="$CURRENT_DIR" 
export GOBIN="$CURRENT_DIR/bin"

#指定并整理当前的源码路径
gofmt -w src

go install test_hello

export GOPATH="$OLD_GO_PATH"
export GOBIN="$OLD_GO_BIN"
```

## 基础语法

### 标记

Go 程序可以由多个标记组成，可以是关键字、常量、变量、运算符、类型和函数。

程序中可能会使用到这些分隔符：括号 `()`，中括号 `[]` 和大括号 `{}`。

程序中可能会使用到这些标点符号：`.`、`,`、`;`、`:` 和 `…`。

如以下 GO 语句由 6 个标记组成：

```go
fmt.Println("Hello, World!")
```

6 个标记是(每行一个)：

```go
1. fmt
2. .
3. Println
4. (
5. "Hello, World!"
6. )
```

### 行分隔符

在 Go 程序中，一行代表一个语句结束。每个语句不需要以分号 ` ; ` 结尾，这些工作都将由 Go 编译器自动完成。

如果将多个语句写在同一行，则必须使用 `;` 人为区分，但在实际开发中并不鼓励这种做法。

### 注释

注释不会被编译，每一个包应该有相关注释。

单行注释是最常见的注释形式，可以在任何地方使用以 // 开头的单行注释。

多行注释也叫块注释，不可以嵌套使用，多行注释一般用于包的文档描述或注释成块的代码片段，均已以 /* 开头，并以 */ 结尾。如：

```go
// XXXX		单行注释
/* XXXX */	多行注释
```
### 标识符

用来命名变量、类型等程序实体。一个标识符实际上就是一个或是多个字母(A~Z 和 a~z)、数字(0~9)、下划线 `_` 组成的序列，但是第一个字符必须是字母或下划线而不能是数字。

区分大小写。

以下是有效的标识符：

```go
mahesh   kumar   abc   move_name   a_123
myname50   _temp   j   a23b9   retVal
```

以下是无效的标识符：

- 1ab（以数字开头）
- case（Go 语言的关键字）
- a+b（运算符是不允许的）

如一个名字是在函数内部定义，那么它只在函数内部有效。如果是在函数外部定义，那么将在当前包的所有文件中都可以访问。

名字的开头字母的大小写决定了名字在包外的可见性。如果一个名字是大写字母开头的（必须是在函数外部定义的包级名字；包级函数名本身也是包级名字），那么它将是导出的（像面向对象语言中的 public ），也就是说可以被外部的包访问（客户端程序需要先导入这个包）。如果以小写字母开头，则对包外是不可见的，但是他们在整个包的内部是可见并且可用的（像面向对象语言中的 protected ）。包本身的名字一般总是用小写字母。

名字的长度没有逻辑限制，但是Go语言的风格是尽量使用短小的名字，对于局部变量尤其是这样。

在习惯上，Go语言程序员推荐使用 **驼峰式**  命名，当名字有几个单词组成的时优先使用大小写分隔，而不是优先用下划线分隔。

#### 内置关键字 (25个)

```go
break            default              func            interface        select 
case             defer                go              map              struct 
chan             else                 goto            package          switch 
const            fallthrough          if              range            type
continue         for                  import          return           var
```
#### 预定义标识符（36个）

```go
// 内建常量
true  false  iota  nil
// 内建类型
int  int8  int16  int32  int64  uint  uint8  uint16  uint32  uint64  uintptr  float32  float64  complex64  complex128  bool  byte  rune  string  error 
// 内建函数
len  make  cap  new  append  copy  close  delete  complex  real  imag  panic  recover print println
```

### 字符串连接

Go 语言的字符串可以通过 `+` 实现：

```bash
package main
import "fmt"

func main() {
  fmt.Println("Google" + "Runoob")
}
```

输出结果为：

```go
GoogleRunoob
```

### 空格

Go 语言中变量的声明必须使用空格隔开，如：

```go
var age int;
```

语句中适当使用空格能让程序更易阅读。在变量与运算符间加入空格，程序看起来更加美观，如：

```go
fruit = apples + oranges; 
```

### 格式化字符串

Go 语言中使用 fmt.Sprintf 格式化字符串并赋值给新串：

```bash
package main
import (
  "fmt"
)

func main() {
  // %d 表示整型数字，%s 表示字符串
  var stockcode=123
  var enddate="2020-12-31"
  var url="Code=%d&endDate=%s"
  var target_url=fmt.Sprintf(url,stockcode,enddate)
  fmt.Println(target_url)
}
```

输出结果为：

```go
Code=123&endDate=2020-12-31
```

## 运算符

运算符用于在程序运行时执行数学或逻辑运算。

Go 语言内置的运算符有：

- 算术运算符
- 关系运算符
- 逻辑运算符
- 位运算符
- 赋值运算符
- 其他运算符

### 算术运算符

假定 A 值为 10，B 值为 20。

| 运算符 | 描述 | 实例               |
| ------ | ---- | ------------------ |
| +      | 相加 | A + B 输出结果 30  |
| -      | 相减 | A - B 输出结果 -10 |
| *      | 相乘 | A * B 输出结果 200 |
| /      | 相除 | B / A 输出结果 2   |
| %      | 求余 | B % A 输出结果 0   |
| ++     | 自增 | A++ 输出结果 11    |
| --     | 自减 | A-- 输出结果 9     |

### 关系运算符

下表列出了所有Go语言的关系运算符。假定 A 值为 10，B 值为 20。

| 运算符 | 描述                                                         | 实例               |
| ------ | ------------------------------------------------------------ | ------------------ |
| ==     | 检查两个值是否相等，如果相等返回 True 否则返回 False。       | (A == B)  为 False |
| !=     | 检查两个值是否不相等，如果不相等返回 True 否则返回 False。   | (A != B) 为 True   |
| >      | 检查左边值是否大于右边值，如果是返回 True 否则返回 False。   | (A > B) 为 False   |
| <      | 检查左边值是否小于右边值，如果是返回 True 否则返回 False。   | (A < B) 为 True    |
| >=     | 检查左边值是否大于等于右边值，如果是返回 True 否则返回 False。 | (A >= B) 为 False  |
| <=     | 检查左边值是否小于等于右边值，如果是返回 True 否则返回 False。 | (A <= B) 为 True   |

### 逻辑运算符

下表列出了所有Go语言的逻辑运算符。假定 A 值为 True，B 值为 False。

| 运算符 | 描述                                                         | 实例               |
| ------ | ------------------------------------------------------------ | ------------------ |
| &&     | 逻辑 AND 运算符。 如果两边的操作数都是 True，则条件 True，否则为 False。 | (A && B) 为 False  |
| \|\|   | 逻辑 OR 运算符。 如果两边的操作数有一个 True，则条件 True，否则为 False。 | (A \|\| B) 为 True |
| !      | 逻辑 NOT 运算符。 如果条件为 True，则逻辑 NOT 条件 False，否则为 True。 | !(A && B) 为 True  |

### 位运算符

位运算符对整数在内存中的二进制位进行操作。

下表列出了位运算符 `&`, `|`, 和 `^` 的计算：

| p    | q    | p & q | p \| q | p ^ q |
| ---- | ---- | ----- | ------ | ----- |
| 0    | 0    | 0     | 0      | 0     |
| 0    | 1    | 0     | 1      | 1     |
| 1    | 1    | 1     | 1      | 0     |
| 1    | 0    | 0     | 1      | 1     |

假定 A = 60  B = 13 其二进制数转换为：

```go
A = 0011 1100
B = 0000 1101
-----------------
A&B = 0000 1100
A|B = 0011 1101
A^B = 0011 0001
```

| 运算符 | 描述                                                         | 实例                                   |
| ------ | ------------------------------------------------------------ | -------------------------------------- |
| &      | 按位与运算符"&"是双目运算符。 其功能是参与运算的两数各对应的二进位相与。 | (A & B) 结果为 12,  二进制为 0000 1100 |
| \|     | 按位或运算符"\|"是双目运算符。 其功能是参与运算的两数各对应的二进位相或 | (A \| B) 结果为 61, 二进制为 0011 1101 |
| ^      | 按位异或运算符"^"是双目运算符。 其功能是参与运算的两数各对应的二进位相异或，当两对应的二进位相异时，结果为1。 | (A ^ B) 结果为 49, 二进制为 0011 0001  |
| <<     | 左移运算符"<<"是双目运算符。左移n位就是乘以2的n次方。 其功能把"<<"左边的运算数的各二进位全部左移若干位，由"<<"右边的数指定移动的位数，高位丢弃，低位补0。 | A << 2 结果为 240 ，二进制为 1111 0000 |
| >>     | 右移运算符">>"是双目运算符。右移n位就是除以2的n次方。 其功能是把">>"左边的运算数的各二进位全部右移若干位，">>"右边的数指定移动的位数。 | A >> 2 结果为 15 ，二进制为 0000 1111  |

### 赋值运算符

下表列出了所有Go语言的赋值运算符。

| 运算符 | 描述                                           | 实例                                  |
| ------ | ---------------------------------------------- | ------------------------------------- |
| =      | 简单的赋值运算符，将一个表达式的值赋给一个左值 | C = A + B 将 A + B 表达式结果赋值给 C |
| +=     | 相加后再赋值                                   | C += A 等于 C = C + A                 |
| -=     | 相减后再赋值                                   | C -= A 等于 C = C - A                 |
| *=     | 相乘后再赋值                                   | C *= A 等于 C = C * A                 |
| /=     | 相除后再赋值                                   | C /= A 等于 C = C / A                 |
| %=     | 求余后再赋值                                   | C %= A 等于 C = C % A                 |
| <<=    | 左移后赋值                                     | C <<= 2 等于  C = C << 2              |
| >>=    | 右移后赋值                                     | C >>= 2 等于  C = C >> 2              |
| &=     | 按位与后赋值                                   | C &= 2 等于  C = C & 2                |
| ^=     | 按位异或后赋值                                 | C ^= 2 等于  C = C ^ 2                |
| \|=    | 按位或后赋值                                   | C \|= 2 等于  C = C \| 2              |

### 其他运算符

| 运算符 | 描述             | 实例                      |
| ------ | ---------------- | ------------------------- |
| &      | 返回变量存储地址 | &a 将给出变量的实际地址。 |
| *      | 指针变量。       | *a  是一个指针变量        |

### 运算符优先级

有些运算符拥有较高的优先级，二元运算符的运算方向均是从左至右。下表列出了所有运算符以及它们的优先级，由上至下代表优先级由高到低：

| 优先级 | 运算符                 |
| ------ | ---------------------- |
| 5      | *  /  %  <<  >>  &  &^ |
| 4      | +  -  \|  ^            |
| 3      | ==  !=  <  <=  >  >=   |
| 2      | &&                     |
| 1      | \|\|                   |

可以通过使用括号来临时提升某个表达式的整体运算优先级。



## 数组

数组是具有相同唯一类型的一组已编号且长度固定的数据项序列，这种类型可以是任意的原始类型例如整型、字符串或者自定义类型。

相对于去声明 **number0, number1, ..., number99** 的变量，使用数组形式 **numbers[0], numbers[1] ..., numbers[99]** 更加方便且易于扩展。

数组元素可以通过索引（位置）来读取（或者修改），索引从 0 开始，第一个元素索引为 0，第二个索引为 1，以此类推。

![img](../../Image/g/goarray.png)

### 声明数组

Go 语言数组声明需要指定元素类型及元素个数，语法格式如下：

```go
var variable_name [SIZE] variable_type
```

以上为一维数组的定义方式。例如以下定义了数组 balance 长度为 10 类型为 float32：

```go
var balance [10] float32
```

### 初始化数组

以下演示了数组初始化：

```go
var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

我们也可以通过字面量在声明数组的同时快速初始化数组：

```go
balance := [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

如果数组长度不确定，可以使用 ... 代替数组的长度，编译器会根据元素个数自行推断数组的长度：

```go
var balance = [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
balance := [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

如果设置了数组的长度，我们还可以通过指定下标来初始化元素：

```go
//  将索引为 1 和 3 的元素初始化
balance := [5]float32{1:2.0,3:7.0}
```

 初始化数组中 {} 中的元素个数不能大于 [] 中的数字。

 如果忽略 [] 中的数字不设置数组大小，Go 语言会根据元素的个数来设置数组的大小：

```go
balance[4] = 50.0
```

以上实例读取了第五个元素。数组元素可以通过索引（位置）来读取（或者修改），索引从 0 开始，第一个元素索引为 0，第二个索引为 1，以此类推。

 ![img](../../Image/g/array_presentation.jpg)

### 访问数组元素

数组元素可以通过索引（位置）来读取。格式为数组名后加中括号，中括号中为索引的值。例如：

```go
var salary float32 = balance[9]
```

以上实例读取了数组 balance 第 10 个元素的值。

### 实例 1

```go
package main
import "fmt"

func main() {
  var n [10]int
  /* n 是一个长度为 10 的数组 */
  var i,j int

  /* 为数组 n 初始化元素 */     
  for i = 0; i < 10; i++ {
   n[i] = i + 100 
  /* 设置元素为 i + 100 */
  }

  /* 输出每个数组元素的值 */
  for** j = 0; j < 10; j++ {
   fmt.Printf("Element[%d] = %d\n", j, n[j] )
  }
}
```

以上实例执行结果如下：

```go
Element[0] = 100
Element[1] = 101
Element[2] = 102
Element[3] = 103
Element[4] = 104
Element[5] = 105
Element[6] = 106
Element[7] = 107
Element[8] = 108
Element[9] = 109
```

### 实例 2

```go
package main

import "fmt"

func main() {
  var i,j,k int
  // 声明数组的同时快速初始化数组
  balance := [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}

  /* 输出数组元素 */
  for i = 0; i < 5; i++ {
   fmt.Printf("balance[%d] = %f\n", i, balance[i] )
  }

  balance2 := [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
  /* 输出每个数组元素的值 */
  for j = 0; j < 5; j++ {
   fmt.Printf("balance2[%d] = %f\n", j, balance2[j] )
  }

  //  将索引为 1 和 3 的元素初始化
  balance3 := [5]float32{1:2.0,3:7.0}  
  for k = 0; k < 5; k++ {
   fmt.Printf("balance3[%d] = %f\n", k, balance3[k] )
  }
}
```

以上实例执行结果如下：

```go
balance[0] = 1000.000000
balance[1] = 2.000000
balance[2] = 3.400000
balance[3] = 7.000000
balance[4] = 50.000000
balance2[0] = 1000.000000
balance2[1] = 2.000000
balance2[2] = 3.400000
balance2[3] = 7.000000
balance2[4] = 50.000000
balance3[0] = 0.000000
balance3[1] = 2.000000
balance3[2] = 0.000000
balance3[3] = 7.000000
balance3[4] = 0.000000
```

### 更多内容

数组对 Go 语言来说是非常重要的，以下我们将介绍数组更多的内容：

| 内容                                                         | 描述                                            |
| ------------------------------------------------------------ | ----------------------------------------------- |
| [多维数组](https://www.runoob.com/go/go-multi-dimensional-arrays.html) | Go 语言支持多维数组，最简单的多维数组是二维数组 |
| [向函数传递数组](https://www.runoob.com/go/go-passing-arrays-to-functions.html) | 你可以向函数传递数组参数                        |

## 指针

变量是一种使用方便的占位符，用于引用计算机内存地址。

Go 语言的取地址符是 &，放到一个变量前使用就会返回相应变量的内存地址。

以下实例演示了变量在内存中地址：

```go
package main
import "fmt"

func main() {
  var a int = 10  

  fmt.Printf("变量的地址: %x\n", &a  )
}
```

执行以上代码输出结果为：

```
变量的地址: 20818a220
```

一个指针变量指向了一个值的内存地址。

在使用指针前你需要声明指针。指针声明格式如下：

```go
var var_name *var-type
```

var-type 为指针类型，var_name 为指针变量名，* 号用于指定变量是作为一个指针。以下是有效的指针声明：

```go
var ip *int        /* 指向整型*/
var fp *float32    /* 指向浮点型 */
```

### 使用指针

指针使用流程：

- 定义指针变量。
- 为指针变量赋值。
- 访问指针变量中指向地址的值。

在指针类型前面加上 * 号（前缀）来获取指针所指向的内容。

```go
package main
import "fmt"

func main() {
  var a int = 20  /* 声明实际变量 */
  var ip *int     /* 声明指针变量 */

  ip = &a         /* 指针变量的存储地址 */

  fmt.Printf("a 变量的地址是: %x\n", &a  )

  /* 指针变量的存储地址 */
  fmt.Printf("ip 变量储存的指针地址: %x\n", ip )

  /* 使用指针访问值 */
  fmt.Printf("*ip 变量的值: %d\n", *ip )
}
```

以上实例执行输出结果为：

```go
a 变量的地址是: 20818a220
ip 变量储存的指针地址: 20818a220
*ip 变量的值: 20
```

### 空指针

当一个指针被定义后没有分配到任何变量时，它的值为 nil。nil 指针也称为空指针。

nil在概念上和其它语言的null、None、nil、NULL一样，都指代零值或空值。

一个指针变量通常缩写为 ptr。

```go
package main
import "fmt"

func main() {
  var ptr *int

  fmt.Printf("ptr 的值为 : %x\n", ptr  )
}
```

以上实例输出结果为：

```
ptr 的值为 : 0
```

空指针判断：

```go
if(ptr != nil)     /* ptr 不是空指针 */
if(ptr == nil)     /* ptr 是空指针 */
```

### 更多内容

接下来我们将为大家介绍Go语言中更多的指针应用：

| 内容                                                         | 描述                                         |
| ------------------------------------------------------------ | -------------------------------------------- |
| [Go 指针数组](https://www.runoob.com/go/go-array-of-pointers.html) | 你可以定义一个指针数组来存储地址             |
| [Go 指向指针的指针](https://www.runoob.com/go/go-pointer-to-pointer.html) | Go 支持指向指针的指针                        |
| [Go 向函数传递指针参数](https://www.runoob.com/go/go-passing-pointers-to-functions.html) | 通过引用或地址传参，在函数调用时可以改变其值 |

## 结构体

数组可以存储同一类型的数据，在结构体中可以为不同项定义不同的数据类型。

结构体是由一系列具有相同类型或不同类型的数据构成的数据集合。

结构体表示一项记录，比如保存图书馆的书籍记录，每本书有以下属性：

- Title ：标题
- Author ： 作者
- Subject：学科
- ID：书籍ID

### 定义结构体

结构体定义需要使用 type 和 struct 语句。struct 语句定义一个新的数据类型，结构体中有一个或多个成员。type 语句设定了结构体的名称。结构体的格式如下：

```go
type struct_variable_type struct {
   member definition
   member definition
   ...
   member definition
}
```

一旦定义了结构体类型，它就能用于变量的声明，语法格式如下：

```go
variable_name := structure_variable_type {value1, value2...valuen}
variable_name := structure_variable_type { key1: value1, key2: value2..., keyn: valuen}
```

```go
package main
import "fmt"

type Books struct {
  title string
  author string
  subject string
  book_id int
}

func main() {

  // 创建一个新的结构体
  fmt.Println(Books{"Go 语言", "www.runoob.com", "Go 语言教程", 6495407})

  // 也可以使用 key => value 格式
  fmt.Println(Books{title: "Go 语言", author: "www.runoob.com", subject: "Go 语言教程", book_id: 6495407})

  // 忽略的字段为 0 或 空
  fmt.Println(Books{title: "Go 语言", author: "www.runoob.com"})
}
```

输出结果为：

```go
{Go 语言 www.runoob.com Go 语言教程 6495407}
{Go 语言 www.runoob.com Go 语言教程 6495407}
{Go 语言 www.runoob.com  0}
```

### 访问结构体成员

如果要访问结构体成员，需要使用点号 `.`  操作符，格式为： 

```go
结构体.成员名
```

结构体类型变量使用 struct 关键字定义，实例如下：

```go
package main
import "fmt"

type Books struct {
  title string
  author string
  subject string
  book_id int
}

func main() {
  var Book1 Books     /* 声明 Book1 为 Books 类型 */
  var Book2 Books     /* 声明 Book2 为 Books 类型 */

  /* book 1 描述 */
  Book1.title = "Go 语言"
  Book1.author = "www.runoob.com"
  Book1.subject = "Go 语言教程"
  Book1.book_id = 6495407

  /* book 2 描述 */
  Book2.title = "Python 教程"
  Book2.author = "www.runoob.com"
  Book2.subject = "Python 语言教程"
  Book2.book_id = 6495700

  /* 打印 Book1 信息 */
  fmt.Printf( "Book 1 title : %s\n", Book1.title)
  fmt.Printf( "Book 1 author : %s\n", Book1.author)
  fmt.Printf( "Book 1 subject : %s\n", Book1.subject)
  fmt.Printf( "Book 1 book_id : %d\n", Book1.book_id)

  /* 打印 Book2 信息 */
  fmt.Printf( "Book 2 title : %s\n", Book2.title)
  fmt.Printf( "Book 2 author : %s\n", Book2.author)
  fmt.Printf( "Book 2 subject : %s\n", Book2.subject)
  fmt.Printf( "Book 2 book_id : %d\n", Book2.book_id)
}
```

以上实例执行运行结果为：

```go
Book 1 title : Go 语言
Book 1 author : www.runoob.com
Book 1 subject : Go 语言教程
Book 1 book_id : 6495407
Book 2 title : Python 教程
Book 2 author : www.runoob.com
Book 2 subject : Python 语言教程
Book 2 book_id : 6495700
```

### 结构体作为函数参数

可以像其他数据类型一样将结构体类型作为参数传递给函数。并以以上实例的方式访问结构体变量：

```go
package main
import "fmt"

type Books struct {
  title string
  author string
  subject string
  book_id int
}

func main() {
  var Book1 Books     /* 声明 Book1 为 Books 类型 */
  var Book2 Books     /* 声明 Book2 为 Books 类型 */

  /* book 1 描述 */
  Book1.title = "Go 语言"
  Book1.author = "www.runoob.com"
  Book1.subject = "Go 语言教程"
  Book1.book_id = 6495407

  /* book 2 描述 */
  Book2.title = "Python 教程"
  Book2.author = "www.runoob.com"
  Book2.subject = "Python 语言教程"
  Book2.book_id = 6495700

  /* 打印 Book1 信息 */
  printBook(Book1)

  /* 打印 Book2 信息 */
  printBook(Book2)
}

func printBook( book Books ) {
  fmt.Printf( "Book title : %s\n", book.title)
  fmt.Printf( "Book author : %s\n", book.author)
  fmt.Printf( "Book subject : %s\n", book.subject)
  fmt.Printf( "Book book_id : %d\n", book.book_id)
}
```

以上实例执行运行结果为：

```
Book title : Go 语言
Book author : www.runoob.com
Book subject : Go 语言教程
Book book_id : 6495407
Book title : Python 教程
Book author : www.runoob.com
Book subject : Python 语言教程
Book book_id : 6495700
```

### 结构体指针

可以定义指向结构体的指针类似于其他指针变量，格式如下：

```go
var struct_pointer *Books
```

以上定义的指针变量可以存储结构体变量的地址。查看结构体变量地址，可以将 & 符号放置于结构体变量前：

```go
struct_pointer = &Book1
```

使用结构体指针访问结构体成员，使用 "." 操作符：

```go
struct_pointer.title
```

接下来让我们使用结构体指针重写以上实例，代码如下：

```go
package main
import "fmt"

type Books struct {
  title string
  author string
  subject string
  book_id int
}

func main() {
  var Book1 Books     /* Declare Book1 of type Book */
  var Book2 Books     /* Declare Book2 of type Book */

  /* book 1 描述 */
  Book1.title = "Go 语言"
  Book1.author = "www.runoob.com"
  Book1.subject = "Go 语言教程"
  Book1.book_id = 6495407
  /* book 2 描述 */
  Book2.title = "Python 教程"
  Book2.author = "www.runoob.com"
  Book2.subject = "Python 语言教程"
  Book2.book_id = 6495700

  /* 打印 Book1 信息 */
  printBook(&Book1)

  /* 打印 Book2 信息 */
  printBook(&Book2)
}

func printBook( book *Books ) {
  fmt.Printf( "Book title : %s\n", book.title)
  fmt.Printf( "Book author : %s\n", book.author)
  fmt.Printf( "Book subject : %s\n", book.subject)
  fmt.Printf( "Book book_id : %d\n", book.book_id)
}
```

以上实例执行运行结果为：

```
Book title : Go 语言
Book author : www.runoob.com
Book subject : Go 语言教程
Book book_id : 6495407
Book title : Python 教程
Book author : www.runoob.com
Book subject : Python 语言教程
Book book_id : 6495700
```

结构体是作为参数的值传递：

```go
package main

import "fmt"

type Books struct {
    title string
    author string
    subject string
    book_id int
}

func changeBook(book Books) {
    book.title = "book1_change"
}

func main() {
    var book1 Books
    book1.title = "book1"
    book1.author = "zuozhe"
    book1.book_id = 1
    changeBook(book1)
    fmt.Println(book1)
}
```

结果为：

```
{book1 zuozhe  1}
```

如果想在函数里面改变结果体数据内容，需要传入指针：

```go
package main

import "fmt"

type Books struct {
    title string
    author string
    subject string
    book_id int
}

func changeBook(book *Books) {
    book.title = "book1_change"
}

func main() {
    var book1 Books
    book1.title = "book1"
    book1.author = "zuozhe"
    book1.book_id = 1
    changeBook(&book1)
    fmt.Println(book1)
}
```

结果为：

```
{book1_change zuozhe  1}
```

## 切片(Slice)

Go 语言切片是对数组的抽象。

Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go中提供了一种灵活，功能强悍的内置类型切片("动态数组"),与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。

### 定义切片

你可以声明一个未指定大小的数组来定义切片：

```go
var identifier []type
```

切片不需要说明长度。

或使用make()函数来创建切片:

```go
var slice1 []type = make([]type, len)

slice1 := make([]type, len)
```

也可以指定容量，其中capacity为可选参数。

```go
make([]T, length, capacity)
```

这里 len 是数组的长度并且也是切片的初始长度。

### 切片初始化

```go
s :=[] int {1,2,3 } 
```

直接初始化切片，[]表示是切片类型，{1,2,3}初始化值依次是1,2,3.其cap=len=3

```go
s := arr[:] 
```

初始化切片s,是数组arr的引用

```go
s := arr[startIndex:endIndex] 
```

将arr中从下标startIndex到endIndex-1 下的元素创建为一个新的切片

```go
s := arr[startIndex:] 
```

默认 endIndex 时将表示一直到arr的最后一个元素

```go
s := arr[:endIndex] 
```

默认 startIndex 时将表示从arr的第一个元素开始

```go
s1 := s[startIndex:endIndex] 
```

通过切片s初始化切片s1

```go
s :=make([]int,len,cap) 
```

通过内置函数make()初始化切片s,[]int 标识为其元素类型为int的切片

### len() 和 cap() 函数

切片是可索引的，并且可以由 len() 方法获取长度。

切片提供了计算容量的方法 cap() 可以测量切片最长可以达到多少。

以下为具体实例：

```go
package main
import "fmt"

func main() {
  var numbers = make([]int,3,5)

  printSlice(numbers)
}

func printSlice(x []int){
  fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```

以上实例运行输出结果为:

```
len=3 cap=5 slice=[0 0 0]
```

### 空(nil)切片

一个切片在未初始化之前默认为 nil，长度为 0，实例如下：

```go
package main
import "fmt"

func main() {
  var numbers []int

  printSlice(numbers)

  if(numbers == nil){
   fmt.Printf("切片是空的")
  }
}

func printSlice(x []int){
  fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```

以上实例运行输出结果为:

```
len=0 cap=0 slice=[]
切片是空的
```

### 切片截取

可以通过设置下限及上限来设置截取切片 *[lower-bound:upper-bound]*，实例如下：

```go
package main
import "fmt"

func main() {
  /* 创建切片 */
  numbers := []int{0,1,2,3,4,5,6,7,8}  
  printSlice(numbers)

  /* 打印原始切片 */
  fmt.Println("numbers ==", numbers)

  /* 打印子切片从索引1(包含) 到索引4(不包含)*/
  fmt.Println("numbers[1:4] ==", numbers[1:4])

  /* 默认下限为 0*/
  fmt.Println("numbers[:3] ==", numbers[:3])

  /* 默认上限为 len(s)*/
  fmt.Println("numbers[4:] ==", numbers[4:])

  numbers1 := make([]int,0,5)
  printSlice(numbers1)

  /* 打印子切片从索引  0(包含) 到索引 2(不包含) */
  number2 := numbers[:2]
  printSlice(number2)

  /* 打印子切片从索引 2(包含) 到索引 5(不包含) */
  number3 := numbers[2:5]
  printSlice(number3)

}

func printSlice(x []int){
  fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```

执行以上代码输出结果为：

```
len=9 cap=9 slice=[0 1 2 3 4 5 6 7 8]
numbers == [0 1 2 3 4 5 6 7 8]
numbers[1:4] == [1 2 3]
numbers[:3] == [0 1 2]
numbers[4:] == [4 5 6 7 8]
len=0 cap=5 slice=[]
len=2 cap=9 slice=[0 1]
len=3 cap=7 slice=[2 3 4]
```

### append() 和 copy() 函数

如果想增加切片的容量，我们必须创建一个新的更大的切片并把原分片的内容都拷贝过来。

下面的代码描述了从拷贝切片的 copy 方法和向切片追加新元素的 append 方法。

```go
package main
import "fmt"

func main() {
  var numbers []int
  printSlice(numbers)

  /* 允许追加空切片 */
  numbers = append(numbers, 0)
  printSlice(numbers)

  /* 向切片添加一个元素 */
  numbers = append(numbers, 1)
  printSlice(numbers)

  /* 同时添加多个元素 */
  numbers = append(numbers, 2,3,4)
  printSlice(numbers)

  /* 创建切片 numbers1 是之前切片的两倍容量*/
  numbers1 := make([]int, len(numbers), (cap(numbers))*2)

  /* 拷贝 numbers 的内容到 numbers1 */
  copy(numbers1,numbers)
  printSlice(numbers1)  
}

func printSlice(x []int){
  fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```

以上代码执行输出结果为：

```
len=0 cap=0 slice=[]
len=1 cap=1 slice=[0]
len=2 cap=2 slice=[0 1]
len=5 cap=6 slice=[0 1 2 3 4]
len=5 cap=12 slice=[0 1 2 3 4]
```

## 范围(Range)

Go 语言中 range 关键字用于 for 循环中迭代数组(array)、切片(slice)、通道(channel)或集合(map)的元素。在数组和切片中它返回元素的索引和索引对应的值，在集合中返回 key-value 对。

```go
package main
import "fmt"

func main() {
  //这是我们使用range去求一个slice的和。使用数组跟这个很类似
  nums := []int{2, 3, 4}
  sum := 0
  for _, num := range nums {
    sum += num
  }
  fmt.Println("sum:", sum)
  //在数组上使用range将传入index和值两个变量。上面那个例子我们不需要使用该元素的序号，所以我们使用空白符"_"省略了。有时侯我们确实需要知道它的索引。
  for i, num := range nums {
    if num == 3 {
      fmt.Println("index:", i)
    }
  }
  //range也可以用在map的键值对上。
  kvs := map[string]string{"a": "apple", "b": "banana"}
  for k, v := range kvs {
    fmt.Printf("%s -> %s\n", k, v)
  }
  //range也可以用来枚举Unicode字符串。第一个参数是字符的索引，第二个是字符（Unicode的值）本身。
  for i, c := range "go" {
    fmt.Println(i, c)
  }
}
```

以上实例运行输出结果为：

```
sum: 9
index: 1
a -> apple
b -> banana
0 103
1 111
```

## Map(集合)

Map 是一种无序的键值对的集合。Map 最重要的一点是通过 key 来快速检索数据，key 类似于索引，指向数据的值。

Map 是一种集合，所以我们可以像迭代数组和切片那样迭代它。不过，Map 是无序的，我们无法决定它的返回顺序，这是因为 Map 是使用 hash 表来实现的。

### 定义 Map

可以使用内建函数 make 也可以使用 map 关键字来定义 Map:

```go
/* 声明变量，默认 map 是 nil */
var map_variable map[key_data_type]value_data_type

/* 使用 make 函数 */
map_variable := make(map[key_data_type]value_data_type)
```

如果不初始化 map，那么就会创建一个 nil map。nil map 不能用来存放键值对

### 实例

下面实例演示了创建和使用map:

```go
package main
import "fmt"

func main() {
  var countryCapitalMap map[string]string      /*创建集合 */
  countryCapitalMap = make(map[string]string)

  /* map插入key - value对,各个国家对应的首都 */
  countryCapitalMap [ "France" ] = "巴黎"
  countryCapitalMap [ "Italy" ] = "罗马"
  countryCapitalMap [ "Japan" ] = "东京"
  countryCapitalMap [ "India " ] = "新德里"

  /*使用键输出地图值 */ 
  for country := range countryCapitalMap {
    fmt.Println(country, "首都是", countryCapitalMap [country])
  }

  /*查看元素在集合中是否存在 */
  capital, ok := countryCapitalMap [ "American" ] /*如果确定是真实的,则存在,否则不存在 */
  /*fmt.Println(capital) */
  /*fmt.Println(ok) */
  if (ok) {
    fmt.Println("American 的首都是", capital)
  } else {
    fmt.Println("American 的首都不存在")
  }
}
```

以上实例运行结果为：

```
France 首都是 巴黎
Italy 首都是 罗马
Japan 首都是 东京
India  首都是 新德里
American 的首都不存在
```

### delete() 函数

delete() 函数用于删除集合的元素, 参数为 map 和其对应的 key。实例如下：
```go
package** main
import** "fmt"

func main() {
    */\* 创建map \*/*
    countryCapitalMap := map[string]string{"France": "Paris", "Italy": "Rome", "Japan": "Tokyo", "India": "New delhi"}

    fmt.Println("原始地图")
    
    */\* 打印地图 \*/*
    **for** country := **range** countryCapitalMap {
        fmt.Println(country, "首都是", countryCapitalMap [ country ])
    }
     
    */\*删除元素\*/* delete(countryCapitalMap, "France")
    fmt.Println("法国条目被删除")
     
    fmt.Println("删除元素后地图")
     
    */\*打印地图\*/*
    **for** country := **range** countryCapitalMap {
        fmt.Println(country, "首都是", countryCapitalMap [ country ])
    }
}
```

以上实例运行结果为：

```
原始地图
India 首都是 New delhi
France 首都是 Paris
Italy 首都是 Rome
Japan 首都是 Tokyo
法国条目被删除
删除元素后地图
Italy 首都是 Rome
Japan 首都是 Tokyo
India 首都是 New delhi
```

## 递归函数

递归，就是在运行的过程中调用自己。
语法格式如下：

```go
func recursion() {
   recursion() /* 函数调用自身 */
 }

 func main() {
   recursion()
 }
```
Go 语言支持递归。但我们在使用递归时，开发者需要设置退出条件，否则递归将陷入无限循环中。

递归函数对于解决数学上的问题是非常有用的，就像计算阶乘，生成斐波那契数列等。

### 阶乘

以下实例通过 Go 语言的递归函数实例阶乘：
```go
package main
import "fmt"

func Factorial(n uint64)(result uint64) {
  if (n > 0) {
    result = n * Factorial(n-1)
    return result
  }
  return 1
}

func main() {  
  var i int = 15
  fmt.Printf("%d 的阶乘是 %d\n", i, Factorial(uint64(i)))
}
```

以上实例执行输出结果为：

```
15 的阶乘是 1307674368000
```

### 斐波那契数列

以下实例通过 Go 语言的递归函数实现斐波那契数列：
```go
package main
import "fmt"

func fibonacci(n int) int {
 if n < 2 {
  return n
 }
 return fibonacci(n-2) + fibonacci(n-1)
}

func main() {
  var i int
  for i = 0; i < 10; i++ {
    fmt.Printf("%d\t", fibonacci(i))
  }
}
```

以上实例执行输出结果为：

```
0    1    1    2    3    5    8    13    21    34
```

## 类型转换

类型转换用于将一种数据类型的变量转换为另外一种类型的变量。Go 语言类型转换基本格式如下：

```go
type_name(expression)
```

type_name 为类型，expression 为表达式。

以下实例中将整型转化为浮点型，并计算结果，将结果赋值给浮点型变量：
```go
package main
import "fmt"

func main() {
  var sum int = 17
  var count int = 5
  var mean float32

  mean = float32(sum)/float32(count)
  fmt.Printf("mean 的值为: %f\n",mean)
}
```

以上实例执行输出结果为：

```
mean 的值为: 3.400000
```

## 接口

Go 语言提供了另外一种数据类型即接口，它把所有的具有共性的方法定义在一起，任何其他类型只要实现了这些方法就是实现了这个接口。

```go
/* 定义接口 */
**type** interface_name interface {
  method_name1 [return_type]
  method_name2 [return_type]
  method_name3 [return_type]
  **...**
  method_namen [return_type]
}

*/\* 定义结构体 \*/*
**type** struct_name struct {
  */\* variables \*/*
}

*/\* 实现接口方法 \*/*
func (struct_name_variable struct_name) method_name1() [return_type] {
  */\* 方法实现 \*/*
}
**...**
func (struct_name_variable struct_name) method_namen() [return_type] {
  */\* 方法实现\*/*
}
```

**实例：**

```go
**package** main

 **import** (
   "fmt"
 )

 **type** Phone interface {
   call()
 }

 **type** NokiaPhone struct {
 }

 func (nokiaPhone NokiaPhone) call() {
   fmt.Println("I am Nokia, I can call you!")
 }

 **type** IPhone struct {
 }

 func (iPhone IPhone) call() {
   fmt.Println("I am iPhone, I can call you!")
 }

 func main() {
   **var** phone Phone

   phone = new(NokiaPhone)
   phone.call()

   phone = new(IPhone)
   phone.call()

 }
```

在上面的例子中，我们定义了一个接口Phone，接口里面有一个方法call()。然后我们在main函数里面定义了一个Phone类型变量，并分别为之赋值为NokiaPhone和IPhone。然后调用call()方法，输出结果如下：

```
I am Nokia, I can call you!
I am iPhone, I can call you!
```

## 错误处理

Go 语言通过内置的错误接口提供了非常简单的错误处理机制。

error类型是一个接口类型，这是它的定义：

```go
type error interface {
    Error() string
}
```

我们可以在编码中通过实现 error 接口类型来生成错误信息。

函数通常在最后的返回值中返回错误信息。使用errors.New 可返回一个错误信息：

```go
func Sqrt(f float64) (float64, error) {
    if f < 0 {
        return 0, errors.New("math: square root of negative number")
    }
    // 实现
}
```

在下面的例子中，我们在调用Sqrt的时候传递的一个负数，然后就得到了non-nil的error对象，将此对象与nil比较，结果为true，所以fmt.Println(fmt包在处理error时会调用Error方法)被调用，以输出错误，请看下面调用的示例代码：

```go
result, err:= Sqrt(-1)

if err != nil {
   fmt.Println(err)
}
```

**实例：**

```go
**package** main

 **import** (
   "fmt"
 )

 *// 定义一个 DivideError 结构*
 **type** DivideError struct {
   dividee int
   divider int
 }

 *// 实现 `error` 接口*
 func (de *DivideError) Error() string {
   strFormat := `
   Cannot proceed, the divider is zero.
   dividee: %d
   divider: 0
 `
   **return** fmt.Sprintf(strFormat, de.dividee)
 }

 *// 定义 `int` 类型除法运算的函数*
 func Divide(varDividee int, varDivider int) (result int, errorMsg string) {
   **if** varDivider == 0 {
       dData := DivideError{
           dividee: varDividee,
           divider: varDivider,
       }
       errorMsg = dData.Error()
       **return**
   } **else** {
       **return** varDividee / varDivider, ""
   }

 }

 func main() {

   *// 正常情况*
   **if** result, errorMsg := Divide(100, 10); errorMsg == "" {
       fmt.Println("100/10 = ", result)
   }
   *// 当除数为零的时候会返回错误信息*
   **if** _, errorMsg := Divide(100, 0); errorMsg != "" {
       fmt.Println("errorMsg is: ", errorMsg)
   }

 }
```

执行以上程序，输出结果为：

```
100/10 =  10
errorMsg is:  
    Cannot proceed, the divider is zero.
    dividee: 100
    divider: 0
```



## 并发

Go 语言在多核并发上拥有原生的设计优势，Go 语言从底层原生支持并发，无须第三方库、开发者的编程技巧和开发经验。Go语言的并发是基于 `goroutine` 的，`goroutine` 类似于线程，但并非线程。可以将 `goroutine` 理解为一种虚拟线程。Go 语言运行时会参与调度 `goroutine`，并将 `goroutine` 合理地分配到每个 CPU 中，最大限度地使用CPU性能。开启一个goroutine的消耗非常小（大约2KB的内存），你可以轻松创建数百万个`goroutine`。

`goroutine`的特点：

```
    1.`goroutine`具有可增长的分段堆栈。这意味着它们只在需要时才会使用更多内存。
    2.`goroutine`的启动时间比线程快。
    3.`goroutine`原生支持利用channel安全地进行通信。
    4.`goroutine`共享数据结构时无需使用互斥锁。
```

## 异常机制：panic 和 recover

编程语言一般都会有异常捕获机制，在 Python 中 是使用`raise` 和 `try-except` 语句来实现的异常抛出和异常捕获的。

在 Golang 中，有不少常规错误，在编译阶段就能提前告警，比如语法错误或类型错误等，但是有些错误仅能在程序运行后才能发生，比如数组访问越界、空指针引用等，这些运行时错误会引起程序退出。

当然能触发程序宕机退出的，也可以是我们自己，比如经过检查判断，当前环境无法达到我们程序进行的预期条件时（比如一个服务指定监听端口被其他程序占用），可以手动触发 panic，让程序退出停止运行。

## 1. 触发panic

手动触发宕机，是非常简单的一件事，只需要调用 panic 这个内置函数即可，就像这样子

```
package main

func main() {
    panic("crash")
}
```

运行后，直接报错宕机

```
$ go run main.go
go run main.go
panic: crash

goroutine 1 [running]:
main.main()
        E:/Go-Code/main.go:4 +0x40
exit status 2
```

## 2. 捕获 panic

发生了异常，有时候就得捕获，就像 Python 中的`except` 一样，那 Golang 中是如何做到的呢？

这就不得不引出另外一个内建函数 – `recover`，它可以让程序在发生宕机后起生回生。

但是 recover 的使用，有一个条件，就是它必须在 defer 函数中才能生效，其他作用域下，它是不工作的。

这是一个简单的例子

```
import "fmt"

func set_data(x int) {
    defer func() {
        // recover() 可以将捕获到的panic信息打印
        if err := recover(); err != nil {
            fmt.Println(err)
        }
    }()

    // 故意制造数组越界，触发 panic
    var arr [10]int
    arr[x] = 88
}

func main() {
    set_data(20)

    // 如果能执行到这句，说明panic被捕获了
    // 后续的程序能继续运行
    fmt.Println("everything is ok")
}
```

运行后，输出如下

```
$ go run main.go
runtime error: index out of range [20] with length 10
everything is ok
```

通常来说，不应该对进入 panic 宕机的程序做任何处理，但有时，需要我们可以从宕机中恢复，至少我们可以在程序崩溃前，做一些操作，举个例子，当 web 服务器遇到不可预料的严重问题时，在崩溃前应该将所有的连接关闭，如果不做任何处理，会使得客户端一直处于等待状态，如果 web 服务器还在开发阶段，服务器甚至可以将异常信息反馈到客户端，帮助调试。

## 3. 无法跨协程

从上面的例子，可以看到，即使 panic 会导致整个程序退出，但在退出前，若有 defer 延迟函数，还是得执行完 defer 。

但是这个 defer 在多个协程之间是没有效果，在子协程里触发 panic，只能触发自己协程内的 defer，而不能调用 main 协程里的 defer 函数的。

来做个实验就知道了

```
import (
    "fmt"
    "time"
)

func main() {
    // 这个 defer 并不会执行
    defer fmt.Println("in main")

    go func() {
        defer println("in goroutine")
        panic("")
    }()

    time.Sleep(2 * time.Second)
}
```

输出如下

```
in goroutine
panic:

goroutine 6 [running]:
main.main.func1()
        E:/Go-Code/main.go:12 +0x7b
created by main.main
        E:/Go-Code/main.go:10 +0xbc
exit status 2
```

## 4. 总结一下

Golang 异常的抛出与捕获，依赖两个内置函数：

- panic：抛出异常，使程序崩溃
- recover：捕获异常，恢复程序或做收尾工作

revocer 调用后，抛出的 panic 将会在此处终结，不会再外抛，但是 recover，并不能任意使用，它有强制要求，必须得在 defer 下才能发挥用途。

------

# 1.15 语法规则：理解语句块与作用域



由于 Go 使用的是词法作用域，而词法作用域依赖于语句块。所以在讲作用域时，需要先了解一下 Go 中的语句块是怎么一回事？

## 1. 显示语句块与隐式语句块

通俗地说，语句块是由花括弧（`{}`）所包含的一系列语句。

语句块内部声明的名字是无法被外部块访问的。这个块决定了内部声明的名字的作用域范围，也就是作用域。

用花括弧包含的语句块，属于显示语句块。

在 Go 中还有很多的隐式语句块：

- 主语句块：包括所有源码，对应内置作用域
- 包语句块：包括该包中所有的源码（一个包可能会包括一个目录下的多个文件），对应包级作用域
- 文件语句块：包括该文件中的所有源码，对应文件级作用域
- for 、if、switch等语句本身也在它自身的隐式语句块中，对应局部作用域

前面三点好理解，第四点举几个例子

for 循环完后，不能再使用变量 i

```
for i := 0; i < 5; i++ {
    fmt.Println(i)
}
```

if 语句判断完后，同样不能再使用变量 i

```
if i := 0; i >= 0 {
    fmt.Println(i)
}
```

switch 语句完了后，也是不是再使用变量 i

```
switch i := 2; i * 4 {
case 8:
    fmt.Println(i)
default:
    fmt.Println(“default”)
}
```

且每个 switch 语句的子句都是一个隐式的语句块

```
switch i := 2; i * 4 {
case 8:
    j := 0
    fmt.Println(i, j)
default:
    // "j" is undefined here
    fmt.Println(“default”)
}
// "j" is undefined here
```

## 2. 四种作用域的理解

变量的声明，除了声明其类型，其声明的位置也有讲究，不同的位置决定了其拥有不同的作用范围，说白了就是我这个变量，在哪里可用，在哪里不可用。

根据声明位置的不同，作用域可以分为以下四个类型：

- 内置作用域：不需要自己声明，所有的关键字和内置类型、函数都拥有全局作用域
- 包级作用域：必須函数外声明，在该包内的所有文件都可以访问
- 文件级作用域：不需要声明，导入即可。一个文件中通过import导入的包名，只在该文件内可用
- 局部作用域：在自己的语句块内声明，包括函数，for、if 等语句块，或自定义的 {} 语句块形成的作用域，只在自己的局部作用域内可用

以上的四种作用域，从上往下，范围从大到小，为了表述方便，我这里自己将范围大的作用域称为高层作用域，而范围小的称为低层作用域。

对于作用域，有以下几点总结：

- 低层作用域，可以访问高层作用域
- 同一层级的作用域，是相互隔离的
- 低层作用域里声明的变量，会覆盖高层作用域里声明的变量

在这里要注意一下，不要将作用域和生命周期混为一谈。声明语句的作用域对应的是一个源代码的文本区域；它是一个编译时的属性。

而一个变量的生命周期是指程序运行时变量存在的有效时间段，在此时间区域内它可以被程序的其他部分引用；是一个运行时的概念。

## 3. 静态作用域与动态作用域

根据局部作用域内变量的可见性，是否是静态不变，可以将编程语言分为如下两种：

- 静态作用域，如 Go 语言
- 动态作用域，如 Shell 语言

具体什么是动态作用域，这里用 Shell 的代码演示一下，你就知道了

```
#!/bin/bash
func01() {
    local value=1
    func02
}
func02() {
    echo "func02 sees value as ${value}"
}

# 执行函数
func01
func02
```

从代码中，可以看到在 func01 函数中定义了个局部变量 value，按理说，这个 value 变量只在该函数内可用，但由于在 shell 中的作用域是动态的，所以在 func01中也可以调用 func02 时，func02 可以访问到 value 变量，此时的 func02 作用域可以当成是 局部作用域中（func01）的局部作用域。

但若脱离了 func01的执行环境，将其放在全局环境下或者其他函数中， func02 是访问不了 value 变量的。

所以此时的输出结果是

```
func02 sees value as 1
func02 sees value as
```

但在 Go 中并不存在这种动态作用域，比如这段代码，在func01函数中，要想取得 name 这个变量，只能从func01的作用域或者更高层作用域里查找（文件级作用域，包级作用域和内置作用域），而不能从调用它的另一个局部作用域中（因为他们在层级上属于同一级）查找。

```
import "fmt"

func func01() {
    fmt.Println("在 func01 函数中，name：", name)
}

func main()  {
    var name string = "Python编程时光"
    fmt.Println("在 main 函数中，name：", name)

    func01()
}
```

因此你在执行这段代码时，会报错，提示在func01中的name还未定义。



# 2.1 面向对象：结构体与继承



## 0. 什么是结构体？

在之前学过的数据类型中，数组与切片，只能存储同一类型的变量。若要存储多个类型的变量，就需要用到结构体，它是将多个任意类型的变量组合在一起的聚合数据类型。

每个变量都成为该结构体的成员变量。

可以理解为 Go语言 的结构体struct和其他语言的class有相等的地位，但是Go语言放弃大量面向对象的特性，所有的Go语言类型除了指针类型外，都可以有自己的方法,提高了可扩展性。

在 Go 语言中没有没有 class 类的概念，只有 struct 结构体的概念，因此也没有继承，本篇文章，带你学习一下结构体相关的内容。

## 1. 定义结构体

声明结构体

```
type 结构体名 struct {
    属性名   属性类型
    属性名   属性类型
    ...
}
```

比如我要定义一个可以存储个人资料名为 Profile 的结构体，可以这么写

```
type Profile struct {
    name   string
    age    int
    gender string
    mother *Profile // 指针
    father *Profile // 指针
}
```

## 2. 定义方法

在 Go 语言中，我们无法在结构体内定义方法，那如何给一个结构体定义方法呢，答案是可以使用组合函数的方式来定义结构体方法。它和普通函数的定义方式有些不一样，比如下面这个方法

```
func (person Profile) FmtProfile() {
    fmt.Printf("名字：%s\n", person.name)
    fmt.Printf("年龄：%d\n", person.age)
    fmt.Printf("性别：%s\n", person.gender)
}
```

其中`FmtProfile` 是方法名，而`(person Profile)` ：表示将 FmtProfile 方法与 Profile 的实例绑定。我们把 Profile 称为方法的接收者，而 person 表示实例本身，它相当于 Python 中的 self，在方法内可以使用 `person.属性名` 的方法来访问实例属性。

完整代码如下：

```
package main

import "fmt"

// 定义一个名为Profile 的结构体
type Profile struct {
    name   string
    age    int
    gender string
    mother *Profile // 指针
    father *Profile // 指针
}

// 定义一个与 Profile 的绑定的方法
func (person Profile) FmtProfile() {
    fmt.Printf("名字：%s\n", person.name)
    fmt.Printf("年龄：%d\n", person.age)
    fmt.Printf("性别：%s\n", person.gender)
}

func main() {
    // 实例化
    myself := Profile{name: "小明", age: 24, gender: "male"}
    // 调用函数
    myself.FmtProfile()
}
```

输出如下

```
名字：小明
年龄：24
性别：male
```

## 3. 方法的参数传递方式

当你想要在方法内改变实例的属性的时候，必须使用指针做为方法的接收者。

```
package main

import "fmt"

// 声明一个 Profile 的结构体
type Profile struct {
    name   string
    age    int
    gender string
    mother *Profile // 指针
    father *Profile // 指针
}

// 重点在于这个星号: *
func (person *Profile) increase_age() {
    person.age += 1
}

func main() {
    myself := Profile{name: "小明", age: 24, gender: "male"}
    fmt.Printf("当前年龄：%d\n", myself.age)
    myself.increase_age()
    fmt.Printf("当前年龄：%d", myself.age)
}
```

输出结果 如下，可以看到在方法内部对 age 的修改已经生效。你可以尝试去掉 `*`，使用值做为方法接收者，看看age是否会发生改变（答案是：不会改变）

```
当前年龄：24
当前年龄：25
```

至此，我们知道了两种定义方法的方式：

- 以值做为方法接收者
- 以指针做为方法接收者

那我们如何进行选择呢？以下几种情况，应当直接使用指针做为方法的接收者。

1. 你需要在方法内部改变结构体内容的时候
2. 出于性能的问题，当结构体过大的时候

有些情况下，以值或指针做为接收者都可以，但是考虑到代码一致性，建议都使用指针做为接收者。

不管你使用哪种方法定义方法，指针实例对象、值实例对象都可以直接调用，而没有什么约束。这一点Go语言做得非常好。

## 4. 结构体实现 “继承”

为什么标题的继承，加了双引号，因为Go 语言本身并不支持继承。

但我们可以使用组合的方法，实现类似继承的效果。

在生活中，组合的例子非常多，比如一台电脑，是由机身外壳，主板，CPU，内存等零部件组合在一起，最后才有了我们用的电脑。

同样的，在 Go 语言中，把一个结构体嵌入到另一个结构体的方法，称之为组合。

现在这里有一个表示公司（company）的结构体，还有一个表示公司职员（staff）的结构体。

```
type company struct {
    companyName string
    companyAddr string
}

type staff struct {
    name string
    age int
    gender string
    position string
}
```

若要将公司信息与公司职员关联起来，一般都会想到将 company 结构体的内容照抄到 staff 里。

```
type staff struct {
    name string
    age int
    gender string
    companyName string
    companyAddr string
    position string
}
```

虽然在实现上并没有什么问题，但在你对同一公司的多个staff初始化的时候，都得重复初始化相同的公司信息，这做得并不好，借鉴继承的思想，我们可以将公司的属性都“继承”过来。

但是在 Go 中没有类的概念，只有组合，你可以将 company 这个 结构体嵌入到 staff 中，做为 staff 的一个匿名字段，staff 就直接拥有了 company 的所有属性了。

```
type staff struct {
    name string
    age int
    gender string
    position string
    company   // 匿名字段
}
```

来写个完整的程序验证一下。

```
package main

import "fmt"

type company struct {
    companyName string
    companyAddr string
}

type staff struct {
    name string
    age int
    gender string
    position string
    company
}

func main()  {
    myCom := company{
        companyName: "Tencent",
        companyAddr: "深圳市南山区",
    }
    staffInfo := staff{
        name:     "小明",
        age:      28,
        gender:   "男",
        position: "云计算开发工程师",
        company: myCom,
    }

    fmt.Printf("%s 在 %s 工作\n", staffInfo.name, staffInfo.companyName)
    fmt.Printf("%s 在 %s 工作\n", staffInfo.name, staffInfo.company.companyName)
}
```

输出结果如下，可见`staffInfo.companyName` 和 `staffInfo.company.companyName` 的效果是一样的。

```
小明 在 Tencent 工作
小明 在 Tencent 工作
```

## 5. 内部方法与外部方法

在 Go 语言中，函数名的首字母大小写非常重要，它被来实现控制对方法的访问权限。

- 当方法的首字母为大写时，这个方法对于所有包都是Public，其他包可以随意调用
- 当方法的首字母为小写时，这个方法是Private，其他包是无法访问的。



# 2.2 面向对象：接口与多态



## 0. 接口是什么？

> 这一段摘自 Go语言中文网

在面向对象的领域里，接口一般这样定义：**接口定义一个对象的行为**。接口只指定了对象应该做什么，至于如何实现这个行为（即实现细节），则由对象本身去确定。

在 Go 语言中，接口就是方法签名（Method Signature）的集合。当一个类型定义了接口中的所有方法，我们称它实现了该接口。这与面向对象编程（OOP）的说法很类似。**接口指定了一个类型应该具有的方法，并由该类型决定如何实现这些方法**。

## 1. 如何定义接口

使用 type 关键字来定义接口。

如下代码，定义了一个电话接口，接口要求必须实现 call 方法。

```
type Phone interface {
   call()
}
```

## 2. 如何实现接口

如果有一个类型/结构体，实现了一个接口要求的所有方法，这里 Phone 接口只有 call方法，所以只要实现了 call 方法，我们就可以称它实现了 Phone 接口。

意思是如果有一台机器，可以给别人打电话，那么我们就可以把它叫做电话。

这个接口的实现是隐式的，不像 JAVA 中要用 implements 显示说明。

继续上面电话的例子，我们先定义一个 Nokia 的结构体，而它实现了 call 的方法，所以它也是一台电话。

```
type Nokia struct {
    name string
}

// 接收者为 Nokia
func (phone Nokia) call() {
    fmt.Println("我是 Nokia，是一台电话")
}
```

## 3. 接口实现多态

鸭子类型（Duck typing）的定义是，只要你长得像鸭子，叫起来也像鸭子，那我认为你就是一只鸭子。

举个通俗的例子

**什么样子的人可以称做老师呢？**

不同的人标准不一，有的人认为必须有一定的学历，有的人认为必须要有老师资格证。

而我认为只要能育人，能给传授给其他人知识的，都可以称之为老师。

而不管你教的什么学科？是体育竞技，还是教人烹饪。

也不管你怎么教？是在教室里手执教教鞭、拿着粉笔，还是追求真实，直接实战演练。

通通不管。

这就一个接口（老师）下，在不同对象（人）上的不同表现。这就是多态。

**在 Go 语言中，是通过接口来实现的多态。**

这里以商品接口来写一段代码演示一下。

先定义一个商品（Good）的接口，意思是一个类型或者结构体，只要实现了`settleAccount()` 和 `orderInfo()` 两个方法，那这个类型/结构体就是一个商品。

```
type Good interface {
    settleAccount() int
    orderInfo() string
}
```

然后我们定义两个结构体，分别是手机和赠品。

```
type Phone struct {
    name string
    quantity int
    price int
}

type FreeGift struct {
    name string
    quantity int
    price int
}
```

然后分别为他们实现 Good 接口的两个方法

```
// Phone
func (phone Phone) settleAccount() int {
    return phone.quantity * phone.price
}
func (phone Phone) orderInfo() string{
    return "您要购买" + strconv.Itoa(phone.quantity)+ "个" +
        phone.name + "计：" + strconv.Itoa(phone.settleAccount()) + "元"
}

// FreeGift
func (gift FreeGift) settleAccount() int {
    return 0
}
func (gift FreeGift) orderInfo() string{
    return "您要购买" + strconv.Itoa(gift.quantity)+ "个" +
        gift.name + "计：" + strconv.Itoa(gift.settleAccount()) + "元"
}
```

实现了 Good 接口要求的两个方法后，手机和赠品在Go语言看来就都是商品（Good）类型了。

这时候，我挑选了两件商品（实例化），分别是手机和耳机（赠品，不要钱）

```
iPhone := Phone{
    name:     "iPhone",
    quantity: 1,
    price:    8000,
}
earphones := FreeGift{
    name:     "耳机",
    quantity: 1,
    price:    200,
}
```

然后创建一个购物车（也就是类型为 Good的切片），来存放这些商品。

```
goods := []Good{iPhone, earphones}
```

最后，定义一个方法来计算购物车里的订单金额

```
func calculateAllPrice(goods []Good) int {
    var allPrice int
    for _,good := range goods{
        fmt.Println(good.orderInfo())
        allPrice += good.settleAccount()
    }
    return allPrice
}
```

完整代码，我贴在下面，供你参考。

```
package main

import (
    "fmt"
    "strconv"
)

// 定义一个接口
type Good interface {
    settleAccount() int
    orderInfo() string
}

type Phone struct {
    name string
    quantity int
    price int
}

func (phone Phone) settleAccount() int {
    return phone.quantity * phone.price
}
func (phone Phone) orderInfo() string{
    return "您要购买" + strconv.Itoa(phone.quantity)+ "个" +
        phone.name + "计：" + strconv.Itoa(phone.settleAccount()) + "元"
}

type FreeGift struct {
    name string
    quantity int
    price int
}

func (gift FreeGift) settleAccount() int {
    return 0
}
func (gift FreeGift) orderInfo() string{
    return "您要购买" + strconv.Itoa(gift.quantity)+ "个" +
        gift.name + "计：" + strconv.Itoa(gift.settleAccount()) + "元"
}

func calculateAllPrice(goods []Good) int {
    var allPrice int
    for _,good := range goods{
        fmt.Println(good.orderInfo())
        allPrice += good.settleAccount()
    }
    return allPrice
}
func main()  {
    iPhone := Phone{
        name:     "iPhone",
        quantity: 1,
        price:    8000,
    }
    earphones := FreeGift{
        name:     "耳机",
        quantity: 1,
        price:    200,
    }

    goods := []Good{iPhone, earphones}
    allPrice := calculateAllPrice(goods)
    fmt.Printf("该订单总共需要支付 %d 元", allPrice)
}
```

运行后，输出如下

```
您要购买1个iPhone计：8000元
您要购买1个耳机计：0元
该订单总共需要支付 8000 元
```

# 2.3 面向对象：结构体里的 Tag 用法



## 1. 抛砖引玉：什么是 Tag？

正常情况下，你定义的结构体是这样子的，每个字段都由名字和字段类型组成

```
type Person struct {
    Name string
    Age  int
    Addr string
}
```

也有例外，就像下面这样子，字段上还可以额外再加一个属性，用反引号（Esc键下面的那个键）包含的字符串，称之为 Tag，也就是标签。

```
type Person struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
    Addr string `json:"addr,omitempty"`
}
```

那么这个标签有什么用呢？

这边先以 `encoding/json` 库的用法抛砖引玉，看一下它能起到什么样的效果。

```
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
    Addr string `json:"addr,omitempty"`
}

func main() {
    p1 := Person{
        Name: "Jack",
        Age:  22,
    }

    data1, err := json.Marshal(p1)
    if err != nil {
        panic(err)
    }

    // p1 没有 Addr，就不会打印了
    fmt.Printf("%s\n", data1)

    // ================

    p2 := Person{
        Name: "Jack",
        Age:  22,
        Addr: "China",
    }

    data2, err := json.Marshal(p2)
    if err != nil {
        panic(err)
    }

    // p2 则会打印所有
    fmt.Printf("%s\n", data2)
}
```

由于 Person 结构体里的 Addr 字段有 omitempty 属性，因此 encoding/json 在将对象转化 json 字符串时，只要发现对象里的 Addr 为 false， 0， 空指针，空接口，空数组，空切片，空映射，空字符串中的一种，就会被忽略。

因此运行后，输出的结果如下

```
$ go run demo.go
{"name":"Jack","age":22}
{"name":"Jack","age":22,"addr":"China"}
```

## 2. 不懂就问：如何定义获取 Tag ？

Tag 由反引号包含，由一对或几对的键值对组成，通过空格来分割键值。格式如下

```
`key01:"value01" key02:"value02" key03:"value03"`
```

定义完后，如何从结构体中，取出 Tag 呢？

答案就是，我们上一节学过的 “反射”。

获取 Tag 可以分为三个步骤：

1. 获取字段 field
2. 获取标签 tag
3. 获取键值对 key:value

演示如下

```
// 三种获取 field
field := reflect.TypeOf(obj).FieldByName("Name")
field := reflect.ValueOf(obj).Type().Field(i)  // i 表示第几个字段
field := reflect.ValueOf(&obj).Elem().Type().Field(i)  // i 表示第几个字段

// 获取 Tag
tag := field.Tag

// 获取键值对
labelValue := tag.Get("label")
labelValue,ok := tag.Lookup("label")
```

获取键值对，有Get 和 Lookup 两种方法，但其实 Get 只是对 Lookup 函数的简单封装而已，当没有获取到对应 tag 的内容，会返回空字符串。

```
func (tag StructTag) Get(key string) string {
    v, _ := tag.Lookup(key)
    return v
}
```

空 Tag 和不设置 Tag 效果是一样的

```
package main

import (
    "fmt"
    "reflect"
)

type Person struct {
    Name string ``
    Age string
}
func main() {
    p := reflect.TypeOf(Person{})
    name, _ := p.FieldByName("Name")
    fmt.Printf("%q\n", name.Tag) //输出 ""
    age, _ := p.FieldByName("Age")
    fmt.Printf("%q\n", age.Tag) // 输出 ""
}
```

## 3. 实战一下：利用 Tag 搞点事情？

学会了如何定义 tag 和 获取 tag，可以试着利用 tag 来做一些事情，来练习一下。

这边我举个例子吧。

如果我想实现一个函数（就叫 Print 吧），在打印 person 对象时，能够美化输出

```
type Person struct {
    Name        string
    Age         int
    Gender      string
}

person := Person{
    Name:        "MING",
    Age:         29,
}

Print(person)
```

就像下面这样，key 和 value 之间有个 `is:`，如果没有指定 Gender 的值，那么显示为unknown（未知）。

```
Name is: MING
Age is: 29
Gender is: unknown
```

那该怎么做呢？

先改造下 Person 结构体，给每个字段加上 tag 标签，三个字段的tag 都有 label 属性，而 Gender 多了一个 default 属性，意在指定默认值。

```
type Person struct {
    Name        string `label:"Name is: "`
    Age         int    `label:"Age is: "`
    Gender      string `label:"Gender is: " default:"unknown"`
}
```

然后来写一下这个 Print 函数

```
func Print(obj interface{}) error {
    // 取 Value
    v := reflect.ValueOf(obj)

    // 解析字段
    for i := 0; i < v.NumField(); i++ {

        // 取tag
        field := v.Type().Field(i)
        tag := field.Tag

        // 解析label 和 default
        label := tag.Get("label")
        defaultValue := tag.Get("default")

        value := fmt.Sprintf("%v", v.Field(i))
        if value == "" {
            // 如果没有指定值，则用默认值替代
            value = defaultValue
        }

        fmt.Println(label + value)
    }

    return nil
}
```

最后执行一下，看了下输出，符合我们的预期：

```
$ go run demo.go
Name is: MING
Age is: 29
Gender is: unknown
```

到此，我们就把 Tag 的用法介绍完了。

# 2.4 学习接口：详解类型断言

![image0](http://image.iswbm.com/20200607145423.png)

## Type Assertion

Type Assertion（中文名叫：类型断言），通过它可以做到以下几件事情

1. 检查 `i` 是否为 nil
2. 检查 `i` 存储的值是否为某个类型

具体的使用方式有两种：

**第一种：**

```
t := i.(T)
```

这个表达式可以断言一个接口对象（i）里不是 nil，并且接口对象（i）存储的值的类型是 T，如果断言成功，就会返回值给 t，如果断言失败，就会触发 panic。

来写段代码试验一下

```
package main

import "fmt"

func main() {
    var i interface{} = 10
    t1 := i.(int)
    fmt.Println(t1)

    fmt.Println("=====分隔线=====")

    t2 := i.(string)
    fmt.Println(t2)
}
```

运行后输出如下，可以发现在执行第二次断言的时候失败了，并且触发了 panic

```
10
=====分隔线=====
panic: interface conversion: interface {} is int, not string

goroutine 1 [running]:
main.main()
        E:/GoPlayer/src/main.go:12 +0x10e
exit status 2
```

如果要断言的接口值是 nil，那我们来看看也是不是也如预期一样会触发panic

```
package main

func main() {
    var i interface{} // nil
    var _ = i.(interface{})
}
```

输出如下，确实是会 触发 panic

```
panic: interface conversion: interface is nil, not interface {}

goroutine 1 [running]:
main.main()
        E:/GoPlayer/src/main.go:5 +0x34
exit status 2
```

**第二种**

```
t, ok:= i.(T)
```

和上面一样，这个表达式也是可以断言一个接口对象（i）里不是 nil，并且接口对象（i）存储的值的类型是 T，如果断言成功，就会返回其类型给 t，并且此时 ok 的值 为 true，表示断言成功。

如果接口值的类型，并不是我们所断言的 T，就会断言失败，但和第一种表达式不同的事，这个不会触发 panic，而是将 ok 的值设为 false ，表示断言失败，此时t 为 T 的零值。

稍微修改下上面的例子，如下

```
package main

import "fmt"

func main() {
    var i interface{} = 10
    t1, ok := i.(int)
    fmt.Printf("%d-%t\n", t1, ok)

    fmt.Println("=====分隔线1=====")

    t2, ok := i.(string)
    fmt.Printf("%s-%t\n", t2, ok)

    fmt.Println("=====分隔线2=====")

    var k interface{} // nil
    t3, ok := k.(interface{})
    fmt.Println(t3, "-", ok)

    fmt.Println("=====分隔线3=====")
    k = 10
    t4, ok := k.(interface{})
    fmt.Printf("%d-%t\n", t4, ok)

    t5, ok := k.(int)
    fmt.Printf("%d-%t\n", t5, ok)
}
```

运行后输出如下，可以发现在执行第二次断言的时候，虽然失败了，但并没有触发了 panic。

```
10-true
=====分隔线1=====
-false
=====分隔线2=====
<nil> - false
=====分隔线3=====
10-true
10-true
```

上面这段输出，你要注意的是第二个断言的输出在`-false` 之前并不是有没有输出任何 t2 的值，而是由于断言失败，所以 t2 得到的是 string 的零值也是 `""` ，它是零长度的，所以你看不到其输出。

## Type Switch

如果需要区分多种类型，可以使用 type switch 断言，这个将会比一个一个进行类型断言更简单、直接、高效。

```
package main

import "fmt"

func findType(i interface{}) {
    switch x := i.(type) {
    case int:
        fmt.Println(x, "is int")
    case string:
        fmt.Println(x, "is string")
    case nil:
        fmt.Println(x, "is nil")
    default:
        fmt.Println(x, "not type matched")
    }
}

func main() {
    findType(10)      // int
    findType("hello") // string

    var k interface{} // nil
    findType(k)

    findType(10.23) //float64
}
```

输出如下

```
10 is int
hello is string
<nil> is nil
10.23 not type matched
```

额外说明一下：

- 如果你的值是 nil，那么匹配的是 `case nil`
- 如果你的值在 switch-case 里并没有匹配对应的类型，那么走的是 default 分支

此外，还有两点需要你格外注意

1. 类型断言，仅能对静态类型为空接口（interface{}）的对象进行断言，否则会抛出错误，具体内容可以参考：[关于接口的三个“潜规则”](http://golang.iswbm.com/en/latest/c02/c02_07.html)
2. 类型断言完成后，实际上会返回静态类型为你断言的类型的对象，而要清楚原来的静态类型为空接口类型（interface{}），这是 Go 的隐式转换。

## 参考文章

- [Explain Type Assertions in Go](https://stackoverflow.com/questions/38816843/explain-type-assertions-in-go)
- [Go interface 详解 (四) ：类型断言](https://sanyuesha.com/2017/12/01/go-interface-4/)

# 2.5 学习接口：Go 语言中的空接口



## 1. 什么是空接口？

空接口是特殊形式的接口类型，普通的接口都有方法，而空接口没有定义任何方法口，也因此，我们可以说所有类型都至少实现了空接口。

```
type empty_iface interface {
}
```

每一个接口都包含两个属性，一个是值，一个是类型。

而对于空接口来说，这两者都是 nil，可以使用 fmt 来验证一下

```
package main

import (
    "fmt"
)

func main() {
    var i interface{}
    fmt.Printf("type: %T, value: %v", i, i)
}
```

输出如下

```
type: <nil>, value: <nil>
```

## 2. 如何使用空接口？

**第一**，通常我们会直接使用 `interface{}` 作为类型声明一个实例，而这个实例可以承载任意类型的值。

```
package main

import (
    "fmt"
)

func main()  {
    // 声明一个空接口实例
    var i interface{}

    // 存 int 没有问题
    i = 1
    fmt.Println(i)

    // 存字符串也没有问题
    i = "hello"
    fmt.Println(i)

    // 存布尔值也没有问题
    i = false
    fmt.Println(i)
}
```

**第二**，如果想让你的函数可以接收任意类型的值 ，也可以使用空接口

接收一个任意类型的值 示例

```
package main

import (
    "fmt"
)

func myfunc(iface interface{}){
    fmt.Println(iface)
}

func main()  {
    a := 10
    b := "hello"
    c := true

    myfunc(a)
    myfunc(b)
    myfunc(c)
}
```

接收任意个任意类型的值 示例

```
package main

import (
    "fmt"
)

func myfunc(ifaces ...interface{}){
    for _,iface := range ifaces{
        fmt.Println(iface)
    }
}

func main()  {
    a := 10
    b := "hello"
    c := true

    myfunc(a, b, c)
}
```

**第三**，你也定义一个可以接收任意类型的 array、slice、map、strcut，例如这边定义一个切片

```
package main

import "fmt"

func main() {
    any := make([]interface{}, 5)
    any[0] = 11
    any[1] = "hello world"
    any[2] = []int{11, 22, 33, 44}
    for _, value := range any {
        fmt.Println(value)
    }
}
```

## 3. 空接口几个要注意的坑

**坑1**：空接口可以承载任意值，但不代表任意类型就可以承接空接口类型的值

从实现的角度看，任何类型的值都满足空接口。因此空接口类型可以保存任何值，也可以从空接口中取出原值。

但要是你把一个空接口类型的对象，再赋值给一个固定类型（比如 int, string等类型）的对象赋值，是会报错的。

```
package main

func main() {
    // 声明a变量, 类型int, 初始值为1
    var a int = 1

    // 声明i变量, 类型为interface{}, 初始值为a, 此时i的值变为1
    var i interface{} = a

    // 声明b变量, 尝试赋值i
    var b int = i
}
```

这个报错，它就好比可以放进行礼箱的东西，肯定能放到集装箱里，但是反过来，能放到集装箱的东西就不一定能放到行礼箱了，在 Go 里就直接禁止了这种反向操作。（**声明**：底层原理肯定还另有其因，但对于新手来说，这样解释也许会容易理解一些。）

```
.\main.go:11:6: cannot use i (type interface {}) as type int in assignment: need type assertion
```

**坑2：**：当空接口承载数组和切片后，该对象无法再进行切片

```
package main

import "fmt"

func main() {
    sli := []int{2, 3, 5, 7, 11, 13}

    var i interface{}
    i = sli

    g := i[1:3]
    fmt.Println(g)
}
```

执行会报错。

```
.\main.go:11:8: cannot slice i (type interface {})
```

**坑3**：当你使用空接口来接收任意类型的参数时，它的静态类型是 interface{}，但动态类型（是 int，string 还是其他类型）我们并不知道，因此需要使用类型断言。

```
package main

import (
    "fmt"
)

func myfunc(i interface{})  {

    switch i.(type) {
    case int:
        fmt.Println("参数的类型是 int")
    case string:
        fmt.Println("参数的类型是 string")
    }
}

func main() {
    a := 10
    b := "hello"
    myfunc(a)
    myfunc(b)
}
```

输出如下

```
参数的类型是 int
参数的类型是 string
```

# 2.6 学习接口：接口的三个“潜规则”



## 1. 对方法的调用限制

接口是一组固定的方法集，由于静态类型的限制，接口变量有时仅能调用其中特定的一些方法。

请看下面这段代码

```
package main

import "fmt"

type Phone interface {
    call()
}

type iPhone struct {
    name string
}

func (phone iPhone)call()  {
    fmt.Println("Hello, iPhone.")
}

func (phone iPhone)send_wechat()  {
    fmt.Println("Hello, Wechat.")
}

func main() {
    var phone Phone
    phone = iPhone{name:"ming's iphone"}
    phone.call()
    phone.send_wechat()
}
```

我定义了一个 Phone 的接口，只要求实现 call 方法即可，也就是只要能打电话的设备就是一个电话（好像是一句没用的废话）。

然后再定义了一个 iPhone 的结构体，该结构体接收两个方法，一个是打电话（ call 函数），一个是发微信（send_wechat 函数）。

最后一步是关键，我们定义了一个 Phone 接口类型的 phone 对象，该对象的内容是 iPhone 结构体。然后我们调用该对象的 call 方法，一切正常。

但是当你调用 `phone.send_wechat`方法，程序会报错，提示我们 Phone 类型的方法没有 send_wechat 的字段或方法。

```
# command-line-arguments
./demo.go:30:10: phone.send_wechat undefined (type Phone has no field or method send_wechat)
```

原因也很明显，因为我们的phone对象显示声明为 Phone 接口类型，因此 phone调用的方法会受到此接口的限制。

**那么如何让 phone 可以调用 send_wechat 方法呢？**

答案是可以不显示的声明为 Phone接口类型 ，但要清楚 phone 对象实际上是隐式的实现了 Phone 接口，如此一来，方法的调用就不会受到接口类型的约束。

修改 main 方法成如下

```
func main() {
    phone := iPhone{name:"ming's iphone"}
    phone.call()
    phone.send_wechat()
}
```

运行后，一切正常，没有报错。

```
Hello, iPhone.
Hello, Wechat.
```

## 2. 调用函数时的隐式转换

Go 语言中的函数调用都是值传递的，变量会在方法调用前进行类型转换。

比如下面这段代码

```
import (
    "fmt"
)

func printType(i interface{})  {

    switch i.(type) {
    case int:
        fmt.Println("参数的类型是 int")
    case string:
        fmt.Println("参数的类型是 string")
    }
}

func main() {
    a := 10
    printType(a)
}
```

如果你运行后，会发现一切都很正常

```
参数的类型是 int
```

但是如果你把函数内的内容搬到到外面来

```
package main

import "fmt"


func main() {
    a := 10

    switch a.(type) {
    case int:
        fmt.Println("参数的类型是 int")
    case string:
        fmt.Println("参数的类型是 string")
    }
}
```

就会有意想不到的结果，居然报错了。

```
# command-line-arguments
./demo.go:9:5: cannot type switch on non-interface value a (type int)
```

这个操作会让一个新人摸不着头脑，代码逻辑都是一样的，为什么一个不会报错，一个会报错呢？

原因其实很简单。

当一个函数接口 interface{} 空接口类型时，我们说它可以接收什么任意类型的参数（江湖上称之为无招胜有招）。

当你使用这种写法时，Go 会默默地为我们做一件事，就是把传入函数的参数值（注意：Go 语言中的函数调用都是值传递的）的类型隐式的转换成 interface{} 类型。

### 如何进行接口类型的显示转换

上面了解了函数中 接口类型的隐式转换后，你的心里可能开始有了疑问了，难道我使用类型断言，只能通过一个接收空接口类型的函数才能实现吗？

答案当然是 No.

如果你想手动对其进行类型转换，可以像下面这样子，就可以将变量 a 的静态类型转换为 interface{} 类型然后赋值给 b （此时 a 的静态类型还是 int，而 b 的静态类型为 interface{}）

```
var a int = 25
b := interface{}(a)
```

知道了方法后，将代码修改成如下：

```
package main

import "fmt"


func main() {
    a := 10

    switch interface{}(a).(type) {
    case int:
        fmt.Println("参数的类型是 int")
    case string:
        fmt.Println("参数的类型是 string")
    }
}
```

运行后，一切正常。

```
参数的类型是 int
```

## 3. 类型断言中的隐式转换

上面我们知道了，只有静态类型为接口类型的对象才可以进行类型断言。

而当类型断言完成后，会返回一个静态类型为你断言的类型的对象，也就是说，当我们使用了类型断言，Go 实际上又会默认为我们进行了一次隐式的类型转换。

验证方法也很简单，使用完一次类型断言后，对返回的对象再一次使用类型断言，Goland 立马就会提示我们新对象 b 不是一个接口类型的对象，不允许进行类型断言。

![image1](http://image.iswbm.com/image-20200614154343406.png)



# 2.7 学习反射：反射三定律



很多人都知道我是从 Python 转过来学习 Go 语言的，当我在使用 Python 的时候，我甚至可以做到不需要知道什么是内省，什么是反射，就可以立即使用内省去做一些事情。

而在学习 Go 语言后，反射在我这却变成了一个难点，一直感觉这个 **反射对象** 的概念异常的抽象。

这篇文章还是会跟上篇文章一样，尽量使用图解来解释一些抽象的概念，如果是我理解有误，还希望你在文章尾部给我留言指正，谢谢。

关于反射的内容，我分为了好几篇，这一篇是入门篇，会从经典的反射三大定律入手，写一些 demo 代码，告诉你反射的基本内容。

## 1. 真实世界与反射世界

在本篇文章里，为了区分反射前后的变量值类型，我将反射前环境称为 **真实世界**，而将反射后的环境称为 **反射世界**。这种比喻不严谨，但是对于我理解是有帮助的，也希望对你有用。

在反射的世界里，我们拥有了获取一个对象的类型，属性及方法的能力。

![image1](http://image.iswbm.com/20200614174556.png)

## 2. 两种类型：Type 和 Value

在 Go 反射的世界里，有两种类型非常重要，是整个反射的核心，在学习 reflect 包的使用时，先得学习下这两种类型：

1. reflect.Type
2. reflect.Value

它们分别对应着真实世界里的 type 和 value，只不过在反射对象里，它们拥有更多的内容。

从源码上来看，reflect.Type 是以一个接口的形式存在的

```
type Type interface {
    Align() int
    FieldAlign() int
    Method(int) Method
    MethodByName(string) (Method, bool)
    NumMethod() int
    Name() string
    PkgPath() string
    Size() uintptr
    String() string
    Kind() Kind
    Implements(u Type) bool
    AssignableTo(u Type) bool
    ConvertibleTo(u Type) bool
    Comparable() bool
    Bits() int
    ChanDir() ChanDir
    IsVariadic() bool
    Elem() Type
    Field(i int) StructField
    FieldByIndex(index []int) StructField
    FieldByName(name string) (StructField, bool)
    FieldByNameFunc(match func(string) bool) (StructField, bool)
    In(i int) Type
    Key() Type
    Len() int
    NumField() int
    NumIn() int
    NumOut() int
    Out(i int) Type
    common() *rtype
    uncommon() *uncommonType
}
```

而 reflect.Value 是以一个结构体的形式存在，

```
type Value struct {
    typ *rtype
    ptr unsafe.Pointer
    flag
}
```

同时它接收了很多的方法（见下表），这里出于篇幅的限制这里也没办法一一介绍。

```
Addr
Bool
Bytes
runes
CanAddr
CanSet
Call
CallSlice
call
Cap
Close
Complex
Elem
Field
FieldByIndex
FieldByName
FieldByNameFunc
Float
Index
Int
CanInterface
Interface
InterfaceData
IsNil
IsValid
IsZero
Kind
Len
MapIndex
MapKeys
MapRange
Method
NumMethod
MethodByName
NumField
OverflowComplex
OverflowFloat
OverflowInt
OverflowUint
Pointer
Recv
recv
Send
send
Set
SetBool
SetBytes
setRunes
SetComplex
SetFloat
SetInt
SetLen
SetCap
SetMapIndex
SetUint
SetPointer
SetString
Slice
Slice3
String
TryRecv
TrySend
Type
Uint
UnsafeAddr
assignTo
Convert
```

通过上一节的内容（[关于接口的三个 『潜规则』](http://golang.iswbm.com/en/latest/c02/c02_07.html)），我们知道了一个接口变量，实际上都是由一 pair 对（type 和 data）组合而成，pair 对中记录着实际变量的值和类型。也就是说在真实世界里，type 和 value 是合并在一起组成 接口变量的。

而在反射的世界里，type 和 data 却是分开的，他们分别由 reflect.Type 和 reflect.Value 来表现。

## 3. 解读反射的三大定律

Go 语言里有个反射三定律，是你在学习反射时，很重要的参考：

1. Reflection goes from interface value to reflection object.
2. Reflection goes from reflection object to interface value.
3. To modify a reflection object, the value must be settable.

翻译一下，就是：

1. 反射可以将接口类型变量 转换为“反射类型对象”；
2. 反射可以将 “反射类型对象”转换为 接口类型变量；
3. 如果要修改 “反射类型对象” 其类型必须是 可写的；

### 第一定律

> Reflection goes from interface value to reflection object.

为了实现从接口变量到反射对象的转换，需要提到 reflect 包里很重要的两个方法：

1. reflect.TypeOf(i) ：获得接口值的类型
2. reflect.ValueOf(i)：获得接口值的值

这两个方法返回的对象，我们称之为反射对象：Type object 和 Value object。

![golang reflection](http://image.iswbm.com/image-20200614175219320.png)

golang reflection

举个例子，看下这两个方法是如何使用的？

```
package main

import (
"fmt"
"reflect"
)

func main() {
    var age interface{} = 25

    fmt.Printf("原始接口变量的类型为 %T，值为 %v \n", age, age)

    t := reflect.TypeOf(age)
    v := reflect.ValueOf(age)

    // 从接口变量到反射对象
    fmt.Printf("从接口变量到反射对象：Type对象的类型为 %T \n", t)
    fmt.Printf("从接口变量到反射对象：Value对象的类型为 %T \n", v)

}
```

输出如下

```
原始接口变量的类型为 int，值为 25
从接口变量到反射对象：Type对象的类型为 *reflect.rtype
从接口变量到反射对象：Value对象的类型为 reflect.Value
```

如此我们完成了从接口类型变量到反射对象的转换。

等等，上面我们定义的 age 不是 int 类型的吗？第一法则里怎么会说是接口类型的呢？

关于这点，其实在上一节（[关于接口的三个 『潜规则』](http://golang.iswbm.com/en/latest/c02/c02_07.html)）已经提到过了，由于 TypeOf 和 ValueOf 两个函数接收的是 interface{} 空接口类型，而 Go 语言函数都是值传递，因此Go语言会将我们的类型隐式地转换成接口类型。

```
// TypeOf returns the reflection Type of the value in the interface{}.TypeOf returns nil.
func TypeOf(i interface{}) Type

// ValueOf returns a new Value initialized to the concrete value stored in the interface i. ValueOf(nil) returns the zero Value.
func ValueOf(i interface{}) Value
```

### 第二定律

> Reflection goes from reflection object to interface value.

和第一定律刚好相反，第二定律描述的是，从反射对象到接口变量的转换。

![golang reflection](http://image.iswbm.com/image-20200614175325721.png)

golang reflection

通过源码可知， reflect.Value 的结构体会接收 `Interface` 方法，返回了一个 `interface{}` 类型的变量（**注意：只有 Value 才能逆向转换，而 Type 则不行，这也很容易理解，如果 Type 能逆向，那么逆向成什么呢？**）

```
// Interface returns v's current value as an interface{}.
// It is equivalent to:
//  var i interface{} = (v's underlying value)
// It panics if the Value was obtained by accessing
// unexported struct fields.
func (v Value) Interface() (i interface{}) {
    return valueInterface(v, true)
}
```

这个函数就是我们用来实现将反射对象转换成接口变量的一个桥梁。

例子如下

```
package main

import (
"fmt"
"reflect"
)

func main() {
    var age interface{} = 25

    fmt.Printf("原始接口变量的类型为 %T，值为 %v \n", age, age)

    t := reflect.TypeOf(age)
    v := reflect.ValueOf(age)

    // 从接口变量到反射对象
    fmt.Printf("从接口变量到反射对象：Type对象的类型为 %T \n", t)
    fmt.Printf("从接口变量到反射对象：Value对象的类型为 %T \n", v)

    // 从反射对象到接口变量
    i := v.Interface()
    fmt.Printf("从反射对象到接口变量：新对象的类型为 %T 值为 %v \n", i, i)

}
```

输出如下

```
原始接口变量的类型为 int，值为 25
从接口变量到反射对象：Type对象的类型为 *reflect.rtype
从接口变量到反射对象：Value对象的类型为 reflect.Value
从反射对象到接口变量：新对象的类型为 int 值为 25
```

当然了，最后转换后的对象，静态类型为 `interface{}` ，如果要转成最初的原始类型，需要再类型断言转换一下，关于这点，我已经在上一节里讲解过了，你可以点此前往复习：（[关于接口的三个 『潜规则』](http://golang.iswbm.com/en/latest/c02/c02_07.html)）。

```
i := v.Interface().(int)
```

至此，我们已经学习了反射的两大定律，对这两个定律的理解，我画了一张图，你可以用下面这张图来加强理解，方便记忆。

![image2](http://image.iswbm.com/image-20200614194727218.png)

### 第三定律

> To modify a reflection object, the value must be settable.

反射世界是真实世界的一个『映射』，是我的一个描述，但这并不严格，因为并不是你在反射世界里所做的事情都会还原到真实世界里。

第三定律引出了一个 `settable` （可设置性，或可写性）的概念。

其实早在以前的文章中，我们就一直在说，Go 语言里的函数都是值传递，只要你传递的不是变量的指针，你在函数内部对变量的修改是不会影响到原始的变量的。

回到反射上来，当你使用 reflect.Typeof 和 reflect.Valueof 的时候，如果传递的不是接口变量的指针，反射世界里的变量值始终将只是真实世界里的一个拷贝，你对该反射对象进行修改，并不能反映到真实世界里。

因此在反射的规则里

- 不是接收变量指针创建的反射对象，是不具备『**可写性**』的
- 是否具备『**可写性**』，可使用 `CanSet()` 来获取得知
- 对不具备『**可写性**』的对象进行修改，是没有意义的，也认为是不合法的，因此会报错。

```
package main

import (
    "fmt"
    "reflect"
)

func main() {
    var name string = "Go编程时光"

    v := reflect.ValueOf(name)
    fmt.Println("可写性为:", v.CanSet())
}
```

输出如下

```
可写性为: false
```

要让反射对象具备可写性，需要注意两点

1. 创建反射对象时传入变量的指针
2. 使用 `Elem()`函数返回指针指向的数据

完整代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {
    var name string = "Go编程时光"
    v1 := reflect.ValueOf(&name)
    fmt.Println("v1 可写性为:", v1.CanSet())

    v2 := v1.Elem()
    fmt.Println("v2 可写性为:", v2.CanSet())
}
```

输出如下

```
v1 可写性为: false
v2 可写性为: true
```

知道了如何使反射的世界里的对象具有可写性后，接下来是时候了解一下如何对修改更新它。

反射对象，都会有如下几个以 `Set` 单词开头的方法

![image3](http://image.iswbm.com/image-20200614161613417.png)

这些方法就是我们修改值的入口。

来举个例子

```
package main

import (
    "fmt"
    "reflect"
)

func main() {
    var name string = "Go编程时光"
    fmt.Println("真实世界里 name 的原始值为：", name)

    v1 := reflect.ValueOf(&name)
    v2 := v1.Elem()

    v2.SetString("Python编程时光")
    fmt.Println("通过反射对象进行更新后，真实世界里 name 变为：", name)
}
```

输出如下

```
真实世界里 name 的原始值为： Go编程时光
通过反射对象进行更新后，真实世界里 name 变为： Python编程时光
```



# 2.8 学习反射：全面学习反射的函数

## 1. 获取类别：Kind()

Type 对象 和 Value 对象都可以通过 Kind() 方法返回对应的接口变量的基础类型。

```
reflect.TypeOf(m).Kind()
reflect.ValueOf(m).Kind()
```

在这里，要注意的是，Kind 和 Type 是有区别的，Kind 表示更基础，范围更广的分类。

有一个例子来表示， iPhone （接口变量）的 Type 是手机，Kind 是电子产品。

通过查看源码文件： `src/reflect/type.go` ，可以得知 Kind 表示的基本都是 Go 原生的基本类型（共有 25 种的合法类型），而不包含自定义类型。

```
type Kind uint

const (
  Invalid Kind = iota  // 非法类型
  Bool                 // 布尔型
  Int                  // 有符号整型
  Int8                 // 有符号8位整型
  Int16                // 有符号16位整型
  Int32                // 有符号32位整型
  Int64                // 有符号64位整型
  Uint                 // 无符号整型
  Uint8                // 无符号8位整型
  Uint16               // 无符号16位整型
  Uint32               // 无符号32位整型
  Uint64               // 无符号64位整型
  Uintptr              // 指针
  Float32              // 单精度浮点数
  Float64              // 双精度浮点数
  Complex64            // 64位复数类型
  Complex128           // 128位复数类型
  Array                // 数组
  Chan                 // 通道
  Func                 // 函数
  Interface            // 接口
  Map                  // 映射
  Ptr                  // 指针
  Slice                // 切片
  String               // 字符串
  Struct               // 结构体
  UnsafePointer        // 底层指针
)
```

下面来看一下 Kind 函数如何使用？

第一种：传入值

```
package main

import (
    "fmt"
    "reflect"
)

type Profile struct {
    name string
    age int
    gender string
}

func main() {
    m := Profile{}

    t := reflect.TypeOf(m)
    fmt.Println("Type: ",t)
    fmt.Println("Kind: ",t.Kind())
}
```

输出如下

```
Type:  main.Profile
Kind:  struct
```

第二种：传入指针，关于 Elem() 的使用上一篇文章已经讲过了，它会返回 Type 对象所表示的指针指向的数据。

```
package main

import (
    "fmt"
    "reflect"
)

type Profile struct {
    name string
    age int
    gender string
}

func main() {
    m := Profile{}

    t := reflect.TypeOf(&m)

    fmt.Println("&m Type: ",t)
    fmt.Println("&m Kind: ",t.Kind())

    fmt.Println("m Type: ",t.Elem())
    fmt.Println("m Kind: ",t.Elem().Kind())
}
```

输出如下

```
&m Type:  *main.Profile
&m Kind:  ptr
m Type:  main.Profile
m Kind:  struct
```

如果这里不使用 TypeOf 方法，而是使用 ValueOf 方法呢，应该这样子写

```
package main

import (
    "fmt"
    "reflect"
)

type Profile struct {
    name string
    age int
    gender string
}

func main() {
    m := Profile{}

    v := reflect.ValueOf(&m)

    fmt.Println("&m Type: ",v.Type())
    fmt.Println("&m Kind: ",v.Kind())

    fmt.Println("m Type: ",v.Elem().Type())
    fmt.Println("m Kind: ",v.Elem().Kind())
}
```

## 2. 进行类型的转换

### Int() ：转成 int

示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var age int = 25

    v1 := reflect.ValueOf(age)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)
    v2 := v1.Int()
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: 25
转换后， type: int64, value: 25
```

### Float()：转成 float

示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var score float64 = 99.5

    v1 := reflect.ValueOf(score)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)
    v2 := v1.Float()
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: 99.5
转换后， type: float64, value: 99.5
```

### String()：转成 string

示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var name string = "Go编程时光"

    v1 := reflect.ValueOf(name)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)
    v2 := v1.String()
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: Go编程时光
转换后， type: string, value: Go编程时光
```

### Bool()：转成布尔值

示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var isMale bool = true

    v1 := reflect.ValueOf(isMale)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)
    v2 := v1.Bool()
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: true
转换后， type: bool, value: true
```

### Pointer()：转成指针

示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var age int = 25

    v1 := reflect.ValueOf(&age)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)
    v2 := v1.Pointer()
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: 0xc0000b4008
转换后， type: uintptr, value: 824634458120
```

### Interface()：转成接口类型

由于空接口类型可以接收任意类型的值，所以上面介绍的各种方法，其实都可以用 Interface() 函数来代替。

区别只有一个，使用 Interface() 返回的对象，静态类型为 interface{}，而使用 Int ()、String() 等函数，返回的对象，其静态类型会是 int，string 等更具体的类型。

关于 Interface() 示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var age int = 25

    v1 := reflect.ValueOf(age)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)
    v2 := v1.Interface()
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: 25
转换后， type: int, value: 25
```

## 3. 对切片的操作

### Slice()：对切片再切片（两下标）

Slice() 函数与上面所有类型转换的函数都不一样，它返回还是 reflect.Value 反射对象，而不再是我们所想的真实世界里的切片对象。

通过以下示例代码可验证

```
package main

import (
    "fmt"
    "reflect"
)

func main() {

    var numList []int = []int{1,2}

    v1 := reflect.ValueOf(numList)
    fmt.Printf("转换前， type: %T, value: %v \n", v1, v1)

    // Slice 函数接收两个参数
    v2 := v1.Slice(0, 2)
    fmt.Printf("转换后， type: %T, value: %v \n", v2, v2)
}
```

输出如下

```
转换前， type: reflect.Value, value: [1 2]
转换后， type: reflect.Value, value: [1 2]
```

### Slice3()：对切片再切片（三下标）

Slice3() 与 Slice() 函数一样，都是对一个切片的反射对象

### Set() 和 Append()：更新切片

示例代码如下

```
package main

import (
    "fmt"
    "reflect"
)

func appendToSlice(arrPtr interface{}) {
    valuePtr := reflect.ValueOf(arrPtr)
    value := valuePtr.Elem()

    value.Set(reflect.Append(value, reflect.ValueOf(3)))

    fmt.Println(value)
    fmt.Println(value.Len())
}

func main() {
    arr := []int{1,2}

    appendToSlice(&arr)

    fmt.Println(arr)
}
```

输出如下

```
3
[1 2 3]
[1 2 3]
```

## 4. 对属性的操作

### NumField() 和 Field()

```
package main

import (
    "fmt"
    "reflect"
)

type Person struct {
    name string
    age int
    gender string
}

func (p Person)SayBye()  {
    fmt.Println("Bye")
}

func (p Person)SayHello()  {
    fmt.Println("Hello")
}



func main() {
    p := Person{"写代码的明哥", 27, "male"}

    v := reflect.ValueOf(p)

    fmt.Println("字段数:", v.NumField())
    fmt.Println("第 1 个字段：", v.Field(0))
    fmt.Println("第 2 个字段：", v.Field(1))
    fmt.Println("第 3 个字段：", v.Field(2))

    fmt.Println("==========================")
    // 也可以这样来遍历
    for i:=0;i<v.NumField();i++{
        fmt.Printf("第 %d 个字段：%v \n", i+1, v.Field(i))
    }
}
```

输出如下

```
字段数: 3
第 1 个字段： 写代码的明哥
第 2 个字段： 27
第 3 个字段： male
==========================
第 1 个字段：写代码的明哥
第 2 个字段：27
第 3 个字段：male
```

## 5. 对方法的操作

### NumMethod() 和 Method()

要获取 Name ，注意使用使用 TypeOf

```
package main

import (
    "fmt"
    "reflect"
)

type Person struct {
    name string
    age int
    gender string
}

func (p Person)SayBye()  {
    fmt.Println("Bye")
}

func (p Person)SayHello()  {
    fmt.Println("Hello")
}



func main() {
    p := &Person{"写代码的明哥", 27, "male"}

    t := reflect.TypeOf(p)

    fmt.Println("方法数（可导出的）:", t.NumMethod())
    fmt.Println("第 1 个方法：", t.Method(0).Name)
    fmt.Println("第 2 个方法：", t.Method(1).Name)

    fmt.Println("==========================")
    // 也可以这样来遍历
    for i:=0;i<t.NumMethod();i++{
       fmt.Printf("第 %d 个方法：%v \n", i+1, t.Method(i).Name)
    }
}
```

输出如下

```
方法数（可导出的）: 2
第 1 个方法： SayBye
第 2 个方法： SayHello
==========================
第 1 个方法：SayBye
第 2 个方法：SayHello
```

## 10. 动态调用函数（使用索引且无参数）

要调用 Call，注意要使用 ValueOf

```
package main

import (
    "fmt"
    "reflect"
)

type Person struct {
    name string
    age int
}

func (p Person)SayBye() string {
    return "Bye"
}

func (p Person)SayHello() string {
    return "Hello"
}


func main() {
    p := &Person{"wangbm", 27}

    t := reflect.TypeOf(p)
    v := reflect.ValueOf(p)


    for i:=0;i<v.NumMethod();i++{
       fmt.Printf("调用第 %d 个方法：%v ，调用结果：%v\n",
           i+1,
           t.Method(i).Name,
           v.Elem().Method(i).Call(nil))
    }
}
```

输出如下

```
调用第 1 个方法：SayBye ，调用结果：[Bye]
调用第 2 个方法：SayHello ，调用结果：[Hello]
```

## 11. 动态调用函数（使用函数名且无参数）

```
package main

import (
    "fmt"
    "reflect"
)

type Person struct {
    name string
    age int
    gender string
}

func (p Person)SayBye()  {
    fmt.Print("Bye")
}

func (p Person)SayHello()  {
    fmt.Println("Hello")
}



func main() {
    p := &Person{"写代码的明哥", 27, "male"}

    v := reflect.ValueOf(p)

    v.MethodByName("SayHello").Call(nil)
    v.MethodByName("SayBye").Call(nil)
}
```

## 12. 动态调用函数（使用函数且有参数）

```
package main

import (
    "fmt"
    "reflect"
)

type Person struct {
}

func (p Person)SelfIntroduction(name string, age int)  {
    fmt.Printf("Hello, my name is %s and i'm %d years old.", name, age)
}



func main() {
    p := &Person{}

    //t := reflect.TypeOf(p)
    v := reflect.ValueOf(p)
    name := reflect.ValueOf("wangbm")
    age := reflect.ValueOf(27)
    input := []reflect.Value{name, age}
    v.MethodByName("SelfIntroduction").Call(input)
}
```

输出如下

```
Hello, my name is wangbm and i'm 27 years old.
```

## 13. 如何看待反射？

**反射** 提供了一些在早期高级语言中难以实现的运行时特性

- 可以在一定程度上避免硬编码，提供灵活性和通用性。
- 可以作为一个[第一类对象](https://zh.wikipedia.org/wiki/第一類物件)发现并修改源代码的结构（如代码块、类、方法、协议等）。
- 可以在运行时像对待源代码语句一样动态解析字符串中可执行的代码（类似JavaScript的eval()函数），进而可将跟class或function匹配的字符串转换成class或function的调用或引用。
- 可以创建一个新的语言字节码解释器来给编程结构一个新的意义或用途。

### 劣势

- 此技术的学习成本高。面向反射的编程需要较多的高级知识，包括框架、关系映射和对象交互，以实现更通用的代码执行。
- 同样因为反射的概念和语法都比较抽象，过多地滥用反射技术会使得代码难以被其他人读懂，不利于合作与交流。
- 由于将部分信息检查工作从编译期推迟到了运行期，此举在提高了代码灵活性的同时，牺牲了一点点运行效率。

通过深入学习反射的特性和技巧，它的劣势可以尽量避免，但这需要许多时间和经验的积累。

## 几点说明

1. 有 reflect 的代码一般都较难理解，使用时请注意适当。
2. Golang 的反射很慢，这个和它的 API 设计有关
3. 反射是一个高级知识点，内容很多，不容易掌握，应该小心谨慎的使用它
4. 不到不得不用的地步，能避免使用反射就不用。

在开发中，你或许会碰到在有些情况下，你需要获取一个对象的类型，属性及方法，而这个过程其实就是 **反射**。

通过反射你可以实现一些动态的功能，提高了 Go 作为一门静态语言的灵活性。

Go 原生为我们内置了一个 reflect 包来为对象提供反射能力，本篇文章将重点于这个 reflect 包的使用。

## 参考文章

[Go 系列教程 ——第 34 篇：反射](https://mp.weixin.qq.com/s/dkgJ_fA0smvpv69t5Nv-7A)

[第001节：反射reflect](https://www.qfgolang.com/?special=fanshejizhi)

https://golang.org/pkg/reflect/

https://segmentfault.com/a/1190000016230264

https://studygolang.com/articles/12348?fr=sidebar

https://blog.golang.org/laws-of-reflection

# 2.9 详细图解：静态类型与动态类型

![image0](http://image.iswbm.com/20200607145423.png)

## 1. 静态类型

所谓的**静态类型**（即 static type），就是变量声明的时候的类型。

```
var age int   // int 是静态类型
var name string  // string 也是静态类型
```

它是你在编码时，肉眼可见的类型。

## 2. 动态类型

所谓的 **动态类型**（即 concrete type，也叫具体类型）是 程序运行时系统才能看见的类型。

这是什么意思呢？

我们都知道 **空接口** 可以承接任意类型的值，什么 int 呀，string 呀，都可以接收。

比如下面这几行代码

```
var i interface{}

i = 18
i = "Go编程时光"
```

第一行：我们在给 `i` 声明了 `interface{}` 类型，所以 `i` 的静态类型就是 `interface{}`

第二行：当我们给变量 `i` 赋一个 int 类型的值时，它的静态类型还是 interface{}，这是不会变的，但是它的动态类型此时变成了 int 类型。

第三行：当我们给变量 `i` 赋一个 string 类型的值时，它的静态类型还是 interface{}，它还是不会变，但是它的动态类型此时又变成了 string 类型。

从以上，可以知道，不管是 `i=18` ，还是 `i="Go编程时光"`，都是当程序运行到这里时，变量的类型，才发生了改变，这就是我们最开始所说的 动态类型是程序运行时系统才能看见的类型。

## 3. 接口组成

每个接口变量，实际上都是由一 pair 对（type 和 data）组合而成，pair 对中记录着实际变量的值和类型。

比如下面这条语句

```
var age int = 25
```

我们声明了一个 int 类型变量，变量名叫 age ，其值为 25

![image1](http://image.iswbm.com/20200610235106.png)

知道了接口的组成后，我们在定义一个变量时，除了使用常规的方法（可参考：[02. 学习五种变量创建的方法](http://mp.weixin.qq.com/s?__biz=MzU1NzU1MTM2NA==&mid=2247483669&idx=2&sn=e70a1400c094e981f15b8da552bd8fbf&chksm=fc355b7ecb42d26824985163a3ef0c3567134975637c4efc42161751f54ab10343b485b36e23&scene=21#wechat_redirect)）

也可以使用像下面这样的方式

```
package main

import "fmt"

func main() {
    age := (int)(25)
    //或者使用 age := (interface{})(25)

    fmt.Printf("type: %T, data: %v ", age, age)
}
```

输出如下

```
type: int, data: 25
```

## 4. 接口细分

根据接口是否包含方法，可以将接口分为 `iface` 和 `eface`。

### iface

第一种：**iface**，表示带有一组方法的接口。

比如

```
type Phone interface {
   call()
}
```

`iface` 的具体结构可用如下一张图来表示

![iface 结构](http://image.iswbm.com/20200610220830.png)

iface 结构

iface 的源码如下：

```
// runtime/runtime2.go
// 非空接口
type iface struct {
    tab  *itab
    data unsafe.Pointer
}

// 非空接口的类型信息
type itab struct {
    inter  *interfacetype  // 接口定义的类型信息
    _type  *_type      // 接口实际指向值的类型信息
    link   *itab
    bad    int32
    inhash int32
    fun    [1]uintptr   // 接口方法实现列表，即函数地址列表，按字典序排序
}

// runtime/type.go
// 非空接口类型，接口定义，包路径等。
type interfacetype struct {
   typ     _type
   pkgpath name
   mhdr    []imethod      // 接口方法声明列表，按字典序排序
}
// 接口的方法声明
type imethod struct {
   name nameOff          // 方法名
   ityp typeOff                // 描述方法参数返回值等细节
}
```

### eface

第二种：**eface**，表示不带有方法的接口

比如

```
var i interface{}
```

eface 的源码如下：

```
// src/runtime/runtime2.go
// 空接口
type eface struct {
    _type *_type
    data  unsafe.Pointer
}
```

![eface 结构组成](http://image.iswbm.com/20200610221213.png)

eface 结构组成

## 5.理解动态类型

前两节，我们知道了什么是动态类型？如何让一个对象具有动态类型？

后两节，我们知道了接口分两种，它们的内部结构各是什么样的？

那最后一节，可以将前面四节的内容结合起来，看看在给一个空接口类型的变量赋值时，接口的内部结构会发生怎样的变化 。



### iface

先来看看 iface，有如下一段代码：

```
var reader io.Reader

tty, err := os.OpenFile("/dev/tty", os.O_RDWR, 0)
if err != nil {
    return nil, err
}

reader = tty
```

第一行代码：var reader io.Reader ，由于 io.Reader 接口包含 Read 方法，所以 io.Reader 是 `iface`，此时 reader 对象的静态类型是 io.Reader，暂无动态类型。

![image2](http://image.iswbm.com/image-20200610225323018.png)

最后一行代码：reader = tty，tty 是一个 `*os.File` 类型的实例，此时reader 对象的静态类型还是 io.Reader，而动态类型变成了 `*os.File`。

![image3](http://image.iswbm.com/20200610230951.png)



### eface

再来看看 eface，有如下一段代码：

```
//不带函数的interface
var empty interface{}

tty, err := os.OpenFile("/dev/tty", os.O_RDWR, 0)
if err != nil {
    return nil, err
}

empty = tty
```

第一行代码：var empty interface{}，由于 `interface{}` 是一个 eface，其只有一个 `_type` 可以存放变量类型，此时 empty 对象的（静态）类型是 nil。

![image4](http://image.iswbm.com/image-20200610230819030.png)

最后一行代码：empty = tty，tty 是一个 `*os.File` 类型的实例，此时 `_type` 变成了 `*os.File`。

![image5](http://image.iswbm.com/image-20200610231015612.png)

## 6. 反射的必要性

由于动态类型的存在，在一个函数中接收的参数的类型有可能无法预先知晓，此时我们就要对参数进行反射，然后根据不同的类型做不同的处理。



# 2.10 关键字：make 和 new 的区别？

## 1. new 函数

在官方文档中，new 函数的描述如下

```
// The new built-in function allocates memory. The first argument is a type,
// not a value, and the value returned is a pointer to a newly
// allocated zero value of that type.
func new(Type) *Type
```

可以看到，new 只能传递一个参数，该参数为一个任意类型，可以是Go语言内建的类型，也可以是你自定义的类型

那么 new 函数到底做了哪些事呢：

- 分配内存
- 设置零值
- 返回指针（重要）

举个例子

```
import "fmt"

type Student struct {
   name string
   age int
}

func main() {
    // new 一个内建类型
    num := new(int)
    fmt.Println(*num) //打印零值：0

    // new 一个自定义类型
    s := new(Student)
    s.name = "wangbm"
}
```

## 2. make 函数

在官方文档中，make 函数的描述如下

```
//The make built-in function allocates and initializes an object
//of type slice, map, or chan (only). Like new, the first argument is
// a type, not a value. Unlike new, make's return type is the same as
// the type of its argument, not a pointer to it.

func make(t Type, size ...IntegerType) Type
```

翻译一下注释内容

1. 内建函数 make 用来为 slice，map 或 chan 类型（注意：也只能用在这三种类型上）分配内存和初始化一个对象
2. make 返回类型的本身而不是指针，而返回值也依赖于具体传入的类型，因为这三种类型就是引用类型，所以就没有必要返回他们的指针了

注意，因为这三种类型是引用类型，所以必须得初始化（size和cap），但不是置为零值，这个和new是不一样的。

举几个例子

```
//切片
a := make([]int, 2, 10)

// 字典
b := make(map[string]int)

// 通道
c := make(chan int, 10)
```

## 3. 总结

new：为所有的类型分配内存，并初始化为零值，返回指针。

make：只能为 slice，map，chan 分配内存，并初始化，返回的是类型。

另外，目前来看 new 函数并不常用，大家更喜欢使用短语句声明的方式。

```
a := new(int)
*a = 1
// 等价于
a := 1
```

但是 make 就不一样了，它的地位无可替代，在使用slice、map以及channel的时候，还是要使用make进行初始化，然后才可以对他们进行操作。

# 3.1 依赖管理：包导入很重要的 8 个知识点

![image0](http://image.iswbm.com/20200607145423.png)

## 1. 单行导入与多行导入

在 Go 语言中，一个包可包含多个 `.go` 文件（这些文件必须得在同一级文件夹中），只要这些 `.go` 文件的头部都使用 `package` 关键字声明了同一个包。

导入包主要可分为两种方式：

- 单行导入

```
import "fmt"
import "sync"
```

- 多行导入

```
import(
    "fmt"
    "sync"
)
```

> 如你所见，Go 语言中 导入的包，必须得用双引号包含，在这里吐槽一下。

## 2. 使用别名

在一些场景下，我们可能需要对导入的包进行重新命名，比如

- 我们导入了两个具有同一包名的包时产生冲突，此时这里为其中一个包定义别名

```
import (
    "crypto/rand"
    mrand "math/rand" // 将名称替换为mrand避免冲突
)
```

- 我们导入了一个名字很长的包，为了避免后面都写这么长串的包名，可以这样定义别名

```
import hw "helloworldtestmodule"
```

- 防止导入的包名和本地的变量发生冲突，比如 path 这个很常用的变量名和导入的标准包冲突。

```
import pathpkg "path"
```

## 3. 使用点操作

如里在我们程序内部里频繁使用了一个工具包，比如 fmt，那每次使用它的打印函数打印时，都要 包名+方法名。

对于这种使用高频的包，可以在导入的时，就把它定义会 “`自己人`”（方法是使用一个 `.` ），自己人的话，不分彼此，它的方法，就是我们的方法。

从此，我们打印再也不用加 fmt 了。

```
import . "fmt"

func main() {
    Println("hello, world")
}
```

但这种用法，会有一定的隐患，就是导入的包里可能有函数，会和我们自己的函数发生冲突。

## 4. 包的初始化

每个包都允许有一个 `init` 函数，当这个包被导入时，会执行该包的这个 `init` 函数，做一些初始化任务。

对于 `init` 函数的执行有几点需要注意

1. `init` 函数优先于 `main` 函数执行

2. 在一个包引用链中，包的初始化是深度优先的。比如，有这样一个包引用关系：main→A→B→C，那么初始化顺序为

   ```
   C.init→B.init→A.init→main
   ```

3. 同一个包甚至同一个源文件，可以有多个 init 函数

4. init 函数不能有入参和返回值

5. init 函数不能被其他函数调用

6. 同一个包内的多个 init 顺序是不受保证的

7. 在 init 之前，其实会先初始化包作用域的常量和变量（常量优先于变量），具体可参考如下代码

   ```
   package main
   
   import "fmt"
   
   func init()  {
    fmt.Println("init1:", a)
   }
   
   func init()  {
    fmt.Println("init2:", a)
   }
   
   var a = 10
   const b = 100
   
   func main() {
    fmt.Println("main:", a)
   }
   // 执行结果
   // init1: 10
   // init2: 10
   // main: 10
   ```

## 5. 包的匿名导入

当我们导入一个包时，如果这个包没有被使用到，在编译时，是会报错的。

但是有些情况下，我们导入一个包，只想执行包里的 `init` 函数，来运行一些初始化任务，此时怎么办呢？

可以使用匿名导入，用法如下，其中下划线为空白标识符，并不能被访问

```
// 注册一个PNG decoder
import _ "image/png"
```

由于导入时，会执行 init 函数，所以编译时，仍然会将这个包编译到可执行文件中。

## 6. 导入的是路径还是包？

当我们使用 import 导入 `testmodule/foo` 时，初学者，经常会问，这个 `foo` 到底是一个包呢，还是只是包所在目录名？

```
import "testmodule/foo"
```

为了得出这个结论，专门做了个试验（请看「第七点里的代码示例」），最后得出的结论是：

- 导入时，是按照目录导入。导入目录后，可以使用这个目录下的所有包。
- 出于习惯，包名和目录名通常会设置成一样，所以会让你有一种你导入的是包的错觉。

## 7. 相对导入和绝对导入

据我了解在 Go 1.10 之前，好像是不支持相对导入的，在 Go 1.10 之后才可以。

**绝对导入**：从 `$GOPATH/src` 或 `$GOROOT` 或者 `$GOPATH/pkg/mod` 目录下搜索包并导入

**相对导入**：从当前目录中搜索包并开始导入。就像下面这样

```
import (
    "./module1"
    "../module2"
    "../../module3"
    "../module4/module5"
)
```

分别举个例子吧

**一、使用绝对导入**

有如下这样的目录结构（注意确保当前目录在 GOPATH 下）

![image1](http://image.iswbm.com/image-20200319211407803.png)

其中 main.go 是这样的

```
package main

import (
    "app/utilset"   // 这种使用的就是绝对路径导入
)

func main() {
    utils.PrintHello()
}
```

而在 main.go 的同级目录下，还有另外一个文件夹 `utilset` ，为了让你理解 「**第六点：import 导入的是路径而不是包**」，我在 utilset 目录下定义了一个 `hello.go` 文件，这个go文件定义所属包为 `utils`。

```
package utils

import "fmt"

func PrintHello(){
    fmt.Println("Hello, 我在 utilset 目录下的 utils 包里")
}
```

运行结果如下

![image2](http://image.iswbm.com/image-20200320125058043.png)

**二、使用相对导入**

还是上面的代码，将绝对导入改为相对导入后

将 GOPATH 路径设置回去（请对比上面使用绝对路径的 GOPATH）

![image3](http://image.iswbm.com/image-20200320123745729.png)

然后再次运行

![image4](http://image.iswbm.com/image-20200320122730128.png)

总结一下，使用相对导入，有两点需要注意

- 项目不要放在 `$GOPATH/src` 下，否则会报错（比如我修改当前项目目录为GOPATH后，运行就会报错）

  ![image5](http://image.iswbm.com/image-20200320123057495.png)

- Go Modules 不支持相对导入，在你开启 GO111MODULE 后，无法使用相对导入。

最后，不得不说的是：使用相对导入的方式，项目可读性会大打折扣，不利用开发者理清整个引用关系。

所以一般更推荐使用绝对引用的方式。使用绝对引用的话，又要谈及优先级了

## 8. 包导入路径优先级

前面一节，介绍了三种不同的包依赖管理方案，不同的管理模式，存放包的路径可能都不一样，有的可以将包放在 GOPATH 下，有的可以将包放在 vendor 下，还有些包是内置包放在 GOROOT 下。

那么问题就来了，如果在这三个不同的路径下，有一个相同包名但是版本不同的包，我们导入的时候，是选择哪个进行导入呢？

这就需要我们搞懂，在 Golang 中包搜索路径优先级是怎样的？

这时候就需要区分，是使用哪种模式进行包的管理的。

**如果使用 govendor**

当我们导入一个包时，它会：

1. 先从项目根目录的 `vendor` 目录中查找
2. 最后从 `$GOROOT/src` 目录下查找
3. 然后从 `$GOPATH/src` 目录下查找
4. 都找不到的话，就报错。

为了验证这个过程，我在创建中创建一个 vendor 目录后，就开启了 vendor 模式了，我在 main.go 中随便导入一个包 pkg，由于这个包是我随便指定的，当然会找不到，找不到就会报错， Golang 会在报错信息中打印中搜索的过程，从这个信息中，就可以看到 Golang 的包查找优先级了。

![image6](http://image.iswbm.com/image-20200319222834534.png)

**如果使用 go modules**

你导入的包如果有域名，都会先在 `$GOPATH/pkg/mod` 下查找，找不到就连网去该网站上寻找，找不到或者找到的不是一个包，则报错。

而如果你导入的包没有域名（比如 “fmt”这种），就只会到 `$GOROOT` 里查找。

还有一点很重要，当你的项目下有 vendor 目录时，不管你的包有没有域名，都只会在 vendor 目录中想找。

![image7](http://image.iswbm.com/image-20200319225219195.png)

通常`vendor` 目录是通过 `go mod vendor` 命令生成的，这个命令会将项目依赖全部打包到你的项目目录下的 verdor 文件夹中。

## 延伸阅读

- [如何使用go module导入本地包](https://mp.weixin.qq.com/s/jvqjIzfBlGh3vty_qHl50w)

------

# 3.2 依赖管理：超详细解读 Go Modules 应用

在以前，Go 语言的的包依赖管理一直都被大家所诟病，Go官方也在一直在努力为开发者提供更方便易用的包管理方案，从最初的 GOPATH 到 GO VENDOR，再到最新的 GO Modules，虽然走了不少的弯路，但最终还是拿出了 Go Modules 这样像样的解决方案。

目前最主流的包依赖管理方式是使用官方推荐的 Go Modules ，这不前段时间 Go 1.14 版本发布，官方正式放话，强烈推荐你使用 Go Modules，并且有自信可以用于生产中。

本文会大篇幅的讲解 Go Modules 的使用，但是在那之前，我仍然会简要介绍一下前两个解决方案 GOPATH 和 go vendor 到底是怎么回事？我认为这是有必要的，因为只有了解它的发展历程，才能知道 Go Modules 的到来是有多么的不容易，多么的意义非凡。

## 1. 最古老的 GOPATH

GOPATH 应该很多人都很眼熟了，之前在配置环境的时候，都配置过吧？

你可以将其理解为工作目录，在这个工作目录下，通常有如下的目录结构

![image1](http://image.iswbm.com/image-20200311220825614.png)

每个目录存放的文件，都不相同

- bin：存放编译后生成的二进制可执行文件
- pkg：存放编译后生成的 `.a` 文件
- src：存放项目的源代码，可以是你自己写的代码，也可以是你 go get 下载的包

将你的包或者别人的包全部放在 `$GOPATH/src` 目录下进行管理的方式，我们称之为 GOPATH 模式。

在这个模式下，使用 go install 时，生成的可执行文件会放在 `$GOPATH/bin` 下

![image2](http://image.iswbm.com/image-20200312221011685.png)

如果你安装的是一个库，则会生成 `.a` 文件到 `$GOPATH/pkg` 下对应的平台目录中（由 GOOS 和 GOARCH 组合而成），生成 `.a` 为后缀的文件。

![image3](http://image.iswbm.com/image-20200312221141028.png)

GOOS，表示的是目标操作系统，有 darwin（Mac），linux，windows，android，netbsd，openbsd，solaris，plan9 等

而 GOARCH，表示目标架构，常见的有 arm，amd64 等

这两个都是 go env 里的变量，你可以通过 `go env 变量名` 进行查看

![image4](http://image.iswbm.com/image-20200314132614248.png)

至此，你可能不会觉得上面的方案会产生什么样的问题，直到你开始真正使用 GOPATH 去开发程序，就不得不开始面临各种各样的问题，其中最严重的就是版本管理问题，因为 GOPATH 根本没有版本的概念。

以下几点是你使用 GOPATH 一定会碰到的问题：

- 你无法在你的项目中，使用指定版本的包，因为不同版本的包的导入方法也都一样
- 其他人运行你的开发的程序时，无法保证他下载的包版本是你所期望的版本，当对方使用了其他版本，有可能导致程序无法正常运行
- 在本地，一个包只能保留一个版本，意味着你在本地开发的所有项目，都得用同一个版本的包，这几乎是不可能的。

## 2. go vendor 模式的过渡

为了解决 GOPATH 方案下不同项目下无法使用多个版本库的问题，Go v1.5 开始支持 vendor 。

以前使用 GOPATH 的时候，所有的项目都共享一个 GOPATH，需要导入依赖的时候，都来这里找，正所谓一山不容二虎，在 GOPATH 模式下只能有一个版本的第三方库。

解决的思路就是，在每个项目下都创建一个 vendor 目录，每个项目所需的依赖都只会下载到自己vendor目录下，项目之间的依赖包互不影响。在编译时，v1.5 的 Go 在你设置了开启 `GO15VENDOREXPERIMENT=1` （注：这个变量在 v1.6 版本默认为1，但是在 v1.7 后，已去掉该环境变量，默认开启 `vendor` 特性，无需你手动设置）后，会提升 vendor 目录的依赖包搜索路径的优先级（相较于 GOPATH）。

其搜索包的优先级顺序，由高到低是这样的

- 当前包下的 vendor 目录
- 向上级目录查找，直到找到 src 下的 vendor 目录
- 在 GOROOT 目录下查找
- 在 GOPATH 下面查找依赖包

虽然这个方案解决了一些问题，但是解决得并不完美。

- 如果多个项目用到了同一个包的同一个版本，这个包会存在于该机器上的不同目录下，不仅对磁盘空间是一种浪费，而且没法对第三方包进行集中式的管理（分散在各个角落）。
- 并且如果要分享开源你的项目，你需要将你的所有的依赖包悉数上传，别人使用的时候，除了你的项目源码外，还有所有的依赖包全部下载下来，才能保证别人使用的时候，不会因为版本问题导致项目不能如你预期那样正常运行。

这些看似不是问题的问题，会给我们的开发使用过程变得非常难受，虽然我是初学者，还未使用过 go vendor，但能有很明显的预感，这个方案照样会另我崩溃。

## 3. go mod 的横空出世

go modules 在 v1.11 版本正式推出，在最新发布的 v1.14 版本中，官方正式发话，称其已经足够成熟，可以应用于生产上。

从 v1.11 开始，`go env` 多了个环境变量： `GO111MODULE` ，这里的 111，其实就是 v1.11 的象征标志， go 里好像很喜欢这样的命名方式，比如当初 vendor 出现的时候，也多了个 `GO15VENDOREXPERIMENT`环境变量，其中 15，表示的vendor 是在 v1.5 时才诞生的。

`GO111MODULE` 是一个开关，通过它可以开启或关闭 go mod 模式。

它有三个可选值：`off`、`on`、`auto`，默认值是`auto`。

1. `GO111MODULE=off`禁用模块支持，编译时会从`GOPATH`和`vendor`文件夹中查找包。
2. `GO111MODULE=on`启用模块支持，编译时会忽略`GOPATH`和`vendor`文件夹，只根据 `go.mod`下载依赖。
3. `GO111MODULE=auto`，当项目在`$GOPATH/src`外且项目根目录有`go.mod`文件时，自动开启模块支持。

go mod 出现后， GOPATH（肯定没人使用了） 和 GOVENDOR 将会且正在被逐步淘汰，但是若你的项目仍然要使用那些即将过时的包依赖管理方案，请注意将 GO111MODULE 置为 off。

具体怎么设置呢？可以使用 go env 的命令，如我要开启 go mod ，就使用这条命令

```
$ go env -w GO111MODULE="on"
```

## 4. go mod 依赖的管理

接下来，来演示一下 go modules 是如何来管理包依赖的。

go mod 不再依靠 $GOPATH，使得它可以脱离 GOPATH 来创建项目，于是我们在家目录下创建一个 go_test 的目录，用来创建我的项目，详细操作如下：

![image5](http://image.iswbm.com/image-20200314000227914.png)

接下来，进入项目目录，执行如下命令进行 go modules 的初始化

![image6](http://image.iswbm.com/image-20200314000940825.png)

接下来很重要的一点，我们要看看 go install 把下载的包安装到哪里了？

![image7](http://image.iswbm.com/image-20200314001426817.png)

上面我们观察到，在使用 go modules 模式后，项目目录下会多生成两个文件也就是 `go.mod` 和 `go.sum` 。

这两个文件是 go modules 的核心所在，这里不得不好好介绍一下。

![image8](http://image.iswbm.com/image-20200314001708640.png)

### go.mod 文件

go.mod 的内容比较容易理解

- 第一行：模块的引用路径
- 第二行：项目使用的 go 版本
- 第三行：项目所需的直接依赖包及其版本

在实际应用上，你会看见更复杂的 go.mod 文件，比如下面这样

```
module github.com/BingmingWong/module-test

go 1.14

require (
    example.com/apple v0.1.2
    example.com/banana v1.2.3
    example.com/banana/v2 v2.3.4
    example.com/pear // indirect
    example.com/strawberry // incompatible
)

exclude example.com/banana v1.2.4
replace（
    golang.org/x/crypto v0.0.0-20180820150726-614d502a4dac => github.com/golang/crypto v0.0.0-20180820150726-614d502a4dac
    golang.org/x/net v0.0.0-20180821023952-922f4815f713 => github.com/golang/net v0.0.0-20180826012351-8a410e7b638d
    golang.org/x/text v0.3.0 => github.com/golang/text v0.3.0
)
```

主要是多出了两个 flag：

- `exclude`： 忽略指定版本的依赖包
- `replace`：由于在国内访问golang.org/x的各个包都需要翻墙，你可以在go.mod中使用replace替换成github上对应的库。

### go.sum 文件

反观 go.sum 文件，就比较复杂了，密密麻麻的。

可以看到，内容虽然多，但是也不难理解

每一行都是由 `模块路径`，`模块版本`，`哈希检验值` 组成，其中哈希检验值是用来保证当前缓存的模块不会被篡改。hash 是以`h1:`开头的字符串，表示生成checksum的算法是第一版的hash算法（sha256）。

值得注意的是，为什么有的包只有一行

```
<module> <version>/go.mod <hash>
```

而有的包却有两行呢

```
<module> <version> <hash>
<module> <version>/go.mod <hash>
```

那些有两行的包，区别就在于 hash 值不一行，一个是 `h1:hash`，一个是 `go.mod h1:hash`

而 `h1:hash` 和 `go.mod h1:hash`两者，要不就是同时存在，要不就是只存在 `go.mod h1:hash`。那什么情况下会不存在 `h1:hash` 呢，就是当 Go 认为肯定用不到某个模块版本的时候就会省略它的`h1 hash`，就会出现不存在 `h1 hash`，只存在 `go.mod h1:hash` 的情况。[引用自 3]

go.mod 和 go.sum 是 go modules 版本管理的指导性文件，因此 go.mod 和 go.sum 文件都应该提交到你的 Git 仓库中去，避免其他人使用你写项目时，重新生成的go.mod 和 go.sum 与你开发的基准版本的不一致。

## 5. go mod 命令的使用

- `go mod init`：初始化go mod， 生成go.mod文件，后可接参数指定 module 名，上面已经演示过。
- `go mod download`：手动触发下载依赖包到本地cache（默认为`$GOPATH/pkg/mod`目录）
- `go mod graph`： 打印项目的模块依赖结构

![image9](http://image.iswbm.com/image-20200314003442400.png)

- `go mod tidy` ：添加缺少的包，且删除无用的包
- `go mod verify` ：校验模块是否被篡改过
- `go mod why`： 查看为什么需要依赖
- `go mod vendor` ：导出项目所有依赖到vendor下

![image10](http://image.iswbm.com/image-20200314003913527.png)

- `go mod edit` ：编辑go.mod文件，接 -fmt 参数格式化 go.mod 文件，接 -require=golang.org/x/text 添加依赖，接 -droprequire=golang.org/x/text 删除依赖，详情可参考 `go help mod edit`

![image11](http://image.iswbm.com/image-20200314004643487.png)

- `go list -m -json all`：以 json 的方式打印依赖详情

![image12](http://image.iswbm.com/image-20200314005924877.png)

如何给项目添加依赖（写进 go.mod）呢？

有两种方法：

- 你只要在项目中有 import，然后 go build 就会 go module 就会自动下载并添加。
- 自己手工使用 go get 下载安装后，会自动写入 go.mod 。

![image13](http://image.iswbm.com/image-20200314005217447.png)

## 7. 总结写在最后

如果让我用一段话来评价 GOPATH 和 go vendor，我会说

GOPATH 做为 Golang 的第一个包管理模式，只能保证你能用，但不保证好用，而 go vendor 解决了 GOPATH 忽视包版的本管理，保证好用，但是还不够好用，直到 go mod 的推出后，才使 Golang 包的依赖管理有了一个能让 Gopher 都统一比较满意的方案，达到了能用且好用的标准。

如果是刚开始学习 Golang ，那么 GOPATH 和 go vendor 可以做适当了解，不必深入研究，除非你要接手的项目由于一些历史原因仍然在使用 go vender 械管理，除此之外，任何 Gopher 应该从此刻就投入 go modules 的怀抱。

以上是我在这几天的学习总结，希望对还未入门阶段的你，有所帮助。另外，本篇文章如有写得不对的，请后台批评指正，以免误导其他朋友，非常感谢。



# 3.4 代码规范：Go语言中编码规范

每个语言都有自己特色的编码规范，学习该语言的命名规范，能让你写出来的代码更加易读，更加不容易出现一些低级错误。

本文根据个人编码习惯以及网络上的一些文章，整理了一些大家能用上的编码规范，可能是一些主流方案，但不代表官方，这一点先声明一下。

## 1. 文件命名

1. 由于 Windows平台文件名不区分大小写，所以文件名应一律使用小写
2. 不同单词之间用下划线分词，不要使用驼峰式命名
3. 如果是测试文件，可以以 `_test.go` 结尾
4. 文件若具有平台特性，应以 `文件名_平台.go` 命名，比如 utils_ windows.go，utils_linux.go，可用的平台有：windows, unix, posix, plan9, darwin, bsd, linux, freebsd, nacl, netbsd, openbsd, solaris, dragonfly, bsd, notbsd， android，stubs
5. 一般情况下应用的主入口应为 main.go，或者以应用的全小写形式命名。比如MyBlog 的入口可以为 `myblog.go`

## 2. 常量命名

目前在网络上可以看到主要有两种风格的写法

1. 第一种是驼峰命名法，比如 appVersion
2. 第二种使用全大写且用下划线分词，比如 APP_VERSION

这两种风格，没有孰好孰弱，可自由选取，我个人更倾向于使用第二种，主要是能一眼与变量区分开来。

如果要定义多个变量，请使用 括号 来组织。

```
const (
    APP_VERSION = "0.1.0"
  CONF_PATH = "/etc/xx.conf"
)
```

## 3. 变量命名

和常量不同，变量的命名，开发者们的喜好就比较一致了，统一使用 `驼峰命名法`

1. 在相对简单的环境（对象数量少、针对性强）中，可以将完整单词简写为单个字母，例如：user写为u
2. 若该变量为 bool 类型，则名称应以 `Has`, `Is`, `Can` 或 `Allow` 开头。例如：isExist ，hasConflict 。
3. 其他一般情况下首单词全小写，其后各单词首字母大写。例如：numShips 和 startDate 。
4. 若变量中有特有名词（以下列出），且变量为私有，则首单词还是使用全小写，如 `apiClient`。
5. 若变量中有特有名词（以下列出），但变量不是私有，那首单词就要变成全大写。例如：`APIClient`，`URLString`

这里列举了一些常见的特有名词：

```
// A GonicMapper that contains a list of common initialisms taken from golang/lint
var LintGonicMapper = GonicMapper{
    "API":   true,
    "ASCII": true,
    "CPU":   true,
    "CSS":   true,
    "DNS":   true,
    "EOF":   true,
    "GUID":  true,
    "HTML":  true,
    "HTTP":  true,
    "HTTPS": true,
    "ID":    true,
    "IP":    true,
    "JSON":  true,
    "LHS":   true,
    "QPS":   true,
    "RAM":   true,
    "RHS":   true,
    "RPC":   true,
    "SLA":   true,
    "SMTP":  true,
    "SSH":   true,
    "TLS":   true,
    "TTL":   true,
    "UI":    true,
    "UID":   true,
    "UUID":  true,
    "URI":   true,
    "URL":   true,
    "UTF8":  true,
    "VM":    true,
    "XML":   true,
    "XSRF":  true,
    "XSS":   true,
}
```

## 4. 函数命名

1. 函数名还是使用 驼峰命名法
2. 但是有一点需要注意，在 Golang 中是用大小写来控制函数的可见性，因此当你需要在包外访问，请使用 大写字母开头
3. 当你不需要在包外访问，请使用小写字母开头

另外，函数内部的参数的排列顺序也有几点原则

1. 参数的重要程度越高，应排在越前面
2. 简单的类型应优先复杂类型
3. 尽可能将同种类型的参数放在相邻位置，则只需写一次类型

## 5. 接口命名

使用驼峰命名法，可以用 type alias 来定义大写开头的 type 给包外访问。

```
type helloWorld interface {
    func Hello();
}

type SayHello helloWorld
```

当你的接口只有一个函数时，接口名通常会以 er 为后缀

```
type Reader interface {
    Read(p []byte) (n int, err error)
}
```

## 6. 注释规范

注释分为

### 6.1 包注释

1. 位于 package 之前，如果一个包有多个文件，只需要在一个文件中编写即可
2. 如果你想在每个文件中的头部加上注释，需要在版权注释和 Package前面加一个空行，否则版权注释会作为Package的注释。

```
// Copyright 2009 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
package net
```

1. 如果是特别复杂的包，可单独创建 doc.go 文件说明

### 6.2 代码注释

用于解释代码逻辑，可以有两种写法

单行注释使用 `//` ，多行注释使用 `/* comment */`

```
// 单行注释

/*
多
行
注
释
*/
```

另外，对于代码注释还有一些更加苛刻的要求，这个看个人了，摘自网络：

- 所有导出对象都需要注释说明其用途；非导出对象根据情况进行注释。

- 如果对象可数且无明确指定数量的情况下，一律使用单数形式和一般进行时描述；否则使用复数形式。

- 包、函数、方法和类型的注释说明都是一个完整的句子。

- 句子类型的注释首字母均需大写；短语类型的注释首字母需小写。

- 注释的单行长度不能超过 80 个字符。

- 类型的定义一般都以单数形式描述：

  ```
  // Request represents a request to run a command.  type Request struct { ...
  ```

- 如果为接口，则一般以以下形式描述：

  ```
  // FileInfo is the interface that describes a file and is returned by Stat and Lstat.
  type FileInfo interface { ...
  ```

- 函数与方法的注释需以函数或方法的名称作为开头：

  ```
  // Post returns *BeegoHttpRequest with POST method.
  ```

- 如果一句话不足以说明全部问题，则可换行继续进行更加细致的描述：

  ```
  // Copy copies file from source to target path.
  // It returns false and error when error occurs in underlying function calls.
  ```

- 若函数或方法为判断类型（返回值主要为 `bool` 类型），则以 `<name> returns true if` 开头：

  ```
  // HasPrefix returns true if name has any string in given slice as prefix.
  func HasPrefix(name string, prefixes []string) bool { ...
  ```

### 6.3 特别注释

- TODO：提醒维护人员此部分代码待完成
- FIXME：提醒维护人员此处有BUG待修复
- NOTE：维护人员要关注的一些问题说明

## 7. 包的导入

单行的包导入

```
import "fmt"
```

多个包导入，请使用 `()` 来组织

```
import (
  "fmt"
  "os"
)
```

另外根据包的来源，对排版还有一定的要求

1. 标准库排最前面，第三方包次之、项目内的其它包和当前包的子包排最后，每种分类以一空行分隔。
2. 尽量不要使用相对路径来导入包。

```
import (
    "fmt"
    "html/template"
    "net/http"
    "os"

    "github.com/codegangsta/cli"
    "gopkg.in/macaron.v1"

    "github.com/gogits/git"
    "github.com/gogits/gfm"

    "github.com/gogits/gogs/routers"
    "github.com/gogits/gogs/routers/repo"
    "github.com/gogits/gogs/routers/user"
)
```

## 8. 善用 gofmt

除了命名规范外，Go 还有很多格式上的规范，比如

1. 使用 tab 进行缩进
2. 一行最长不要超过 80 个字符



# 4.2 学习 Go 协程：goroutine

说到Go语言，很多没接触过它的人，对它的第一印象，一定是它从语言层面天生支持并发，非常方便，让开发者能快速写出高性能且易于理解的程序。

在 Python （为Py为例，主要是我比较熟悉，其他主流编程语言也类似）中，并发编程的门槛并不低，你要学习多进程，多线程，还要掌握各种支持并发的库 asyncio，aiohttp 等，同时你还要清楚它们之间的区别及优缺点，懂得在不同的场景选择不同的并发模式。

而 Golang 作为一门现代化的编程语言，它不需要你直面这些复杂的问题。在 Golang 里，你不需要学习如何创建进程池/线程池，也不需要知道什么情况下使用多线程，什么时候使用多进程。因为你没得选，也不需要选，它原生提供的 goroutine （也即协程）已经足够优秀，能够自动帮你处理好所有的事情，而你要做的只是执行它，就这么简单。

一个 goroutine 本身就是一个函数，当你直接调用时，它就是一个普通函数，如果你在调用前加一个关键字 `go` ，那你就开启了一个 goroutine。

```
// 执行一个函数
func()

// 开启一个协程执行这个函数
go func()
```

## 1. 协程的初步使用

一个 Go 程序的入口通常是 main 函数,程序启动后，main 函数最先运行，我们称之为 `main goroutine`。

在 main 中或者其下调用的代码中才可以使用 `go + func()` 的方法来启动协程。

main 的地位相当于主线程，当 main 函数执行完成后，这个线程也就终结了，其下的运行着的所有协程也不管代码是不是还在跑，也得乖乖退出。

因此如下这段代码运行完，只会输出 `hello, world` ，而不会输出`hello, go`（因为协程的创建需要时间，当 `hello, world`打印后，协程还没来得及并执行）

```
import "fmt"

func mytest() {
    fmt.Println("hello, go")
}

func main() {
    // 启动一个协程
    go mytest()
    fmt.Println("hello, world")
}
```

对于刚学习Go的协程同学来说，可以使用 time.Sleep 来使 main 阻塞，使其他协程能够有机会运行完全，但你要注意的是，这并不是推荐的方式（后续我们会学习其他更优雅的方式）。

当我在代码中加入一行 time.Sleep 输出就符合预期了。

```
import (
    "fmt"
    "time"
)

func mytest() {
    fmt.Println("hello, go")
}

func main() {
    go mytest()
    fmt.Println("hello, world")
    time.Sleep(time.Second)
}
```

输出如下

```
hello, world
hello, go
```

## 2. 多个协程的效果

为了让你看到并发的效果，这里举个最简单的例子

```
import (
    "fmt"
    "time"
)

func mygo(name string) {
    for i := 0; i < 10; i++ {
        fmt.Printf("In goroutine %s\n", name)
        // 为了避免第一个协程执行过快，观察不到并发的效果，加个休眠
        time.Sleep(10 * time.Millisecond)
    }
}

func main() {
    go mygo("协程1号") // 第一个协程
    go mygo("协程2号") // 第二个协程
    time.Sleep(time.Second)
}
```

输出如下，可以观察到两个协程就如两个线程一样，并发执行

```
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程2号
In goroutine 协程1号
In goroutine 协程2号
```

通过以上简单的例子，是不是折服于Go的这种强大的并发特性，将同步代码转为异步代码，真的只要一个关键字就可以了，也不需要使用其他库，简单方便。

本篇只介绍了协程的简单使用，真正的并发程序还是要结合 信道 （channel）来实现。关于信道的内容，将在下一篇文章中介绍。

# 4.3 学习 Go 协程：详解信道/通道

Go 语言之所以开始流行起来，很大一部分原因是因为它自带的并发机制。

如果说 goroutine 是 Go语言程序的并发体的话，那么 channel（信道） 就是 它们之间的通信机制。channel，是一个可以让一个 goroutine 与另一个 goroutine 传输信息的通道，我把他叫做信道，也有人将其翻译成通道，二者都是一个概念。

信道，就是一个管道，连接多个goroutine程序 ，它是一种队列式的数据结构，遵循先入先出的规则。

## 1. 信道的定义与使用

每个信道都只能传递一种数据类型的数据，所以在你声明的时候，你得指定数据类型（string int 等等）

```
var 信道实例 chan 信道类型

// 定义容量为10的信道
var 信道实例 [10]chan 信道类型
```

声明后的信道，其零值是nil，无法直接使用，必须配合make函进行初始化。

```
信道实例 = make(chan 信道类型)
```

亦或者，上面两行可以合并成一句，以下我都使用这样的方式进行信道的声明

```
信道实例 := make(chan 信道类型)
```

假如我要创建一个可以传输int类型的信道，可以这样子写。

```
// 定义信道
pipline := make(chan int)
```

信道的数据操作，无非就两种：发送数据与读取数据

```
// 往信道中发送数据
pipline<- 200

// 从信道中取出数据，并赋值给mydata
mydata := <-pipline
```

信道用完了，可以对其进行关闭，避免有人一直在等待。但是你关闭信道后，接收方仍然可以从信道中取到数据，只是接收到的会永远是 0。

```
close(pipline)
```

对一个已关闭的信道再关闭，是会报错的。所以我们还要学会，如何判断一个信道是否被关闭？

当从信道中读取数据时，可以有多个返回值，其中第二个可以表示 信道是否被关闭，如果已经被关闭，ok 为 false，若还没被关闭，ok 为true。

```
x, ok := <-pipline
```

## 2. 信道的容量与长度

一般创建信道都是使用 make 函数，make 函数接收两个参数

- 第一个参数：必填，指定信道类型
- 第二个参数：选填，不填默认为0，指定信道的**容量**（可缓存多少数据）

对于信道的容量，很重要，这里要多说几点：

- 当容量为0时，说明信道中不能存放数据，在发送数据时，必须要求立马有人接收，否则会报错。此时的信道称之为**无缓冲信道**。
- 当容量为1时，说明信道只能缓存一个数据，若信道中已有一个数据，此时再往里发送数据，会造成程序阻塞。 利用这点可以利用信道来做锁。
- 当容量大于1时，信道中可以存放多个数据，可以用于多个协程之间的通信管道，共享资源。

至此我们知道，信道就是一个容器。

若将它比做一个纸箱子

- 它可以装10本书，代表其容量为10
- 当前只装了1本书，代表其当前长度为1

信道的容量，可以使用 cap 函数获取 ，而信道的长度，可以使用 len 长度获取。

```
package main

import "fmt"

func main() {
    pipline := make(chan int, 10)
    fmt.Printf("信道可缓冲 %d 个数据\n", cap(pipline))
    pipline<- 1
    fmt.Printf("信道中当前有 %d 个数据", len(pipline))
}
```

输出如下

```
信道可缓冲 10 个数据
信道中当前有 1 个数据
```

## 3. 缓冲信道与无缓冲信道

按照是否可缓冲数据可分为：**缓冲信道** 与 **无缓冲信道**

**缓冲信道**

允许信道里存储一个或多个数据，这意味着，设置了缓冲区后，发送端和接收端可以处于异步的状态。

```
pipline := make(chan int, 10)
```

**无缓冲信道**

在信道里无法存储数据，这意味着，接收端必须先于发送端准备好，以确保你发送完数据后，有人立马接收数据，否则发送端就会造成阻塞，原因很简单，信道中无法存储数据。也就是说发送端和接收端是同步运行的。

```
pipline := make(chan int)

// 或者
pipline := make(chan int, 0)
```

## 4. 双向信道与单向信道

通常情况下，我们定义的信道都是双向通道，可发送数据，也可以接收数据。

但有时候，我们希望对信道的数据流向做一些控制，比如这个信道只能接收数据或者这个信道只能发送数据。

因此，就有了 **双向信道** 和 **单向信道** 两种分类。

**双向信道**

默认情况下你定义的信道都是双向的，比如下面代码

```
import (
    "fmt"
    "time"
)

func main() {
    pipline := make(chan int)

    go func() {
        fmt.Println("准备发送数据: 100")
        pipline <- 100
    }()

    go func() {
        num := <-pipline
        fmt.Printf("接收到的数据是: %d", num)
    }()
    // 主函数sleep，使得上面两个goroutine有机会执行
    time.Sleep(time.Second)
}
```

**单向信道**

单向信道，可以细分为 **只读信道** 和 **只写信道**。

定义只读信道

```
var pipline = make(chan int)
type Receiver = <-chan int // 关键代码：定义别名类型
var receiver Receiver = pipline
```

定义只写信道

```
var pipline = make(chan int)
type Sender = chan<- int  // 关键代码：定义别名类型
var sender Sender = pipline
```

仔细观察，区别在于 `<-` 符号在关键字 `chan` 的左边还是右边。

- `<-chan` 表示这个信道，只能从里发出数据，对于程序来说就是只读
- `chan<-` 表示这个信道，只能从外面接收数据，对于程序来说就是只写

有同学可能会问：为什么还要先声明一个双向信道，再定义单向通道呢？比如这样写

```
type Sender = chan<- int
sender := make(Sender)
```

代码是没问题，但是你要明白信道的意义是什么？(**以下是我个人见解**

信道本身就是为了传输数据而存在的，如果只有接收者或者只有发送者，那信道就变成了只入不出或者只出不入了吗，没什么用。所以只读信道和只写信道，唇亡齿寒，缺一不可。

当然了，若你往一个只读信道中写入数据 ，或者从一个只写信道中读取数据 ，都会出错。

完整的示例代码如下，供你参考：

```
import (
    "fmt"
    "time"
)
 //定义只写信道类型
type Sender = chan<- int

//定义只读信道类型
type Receiver = <-chan int

func main() {
    var pipline = make(chan int)

    go func() {
        var sender Sender = pipline
        fmt.Println("准备发送数据: 100")
        sender <- 100
    }()

    go func() {
        var receiver Receiver = pipline
        num := <-receiver
        fmt.Printf("接收到的数据是: %d", num)
    }()
    // 主函数sleep，使得上面两个goroutine有机会执行
    time.Sleep(time.Second)
}
```

## 5. 遍历信道

遍历信道，可以使用 for 搭配 range关键字，在range时，要确保信道是处于关闭状态，否则循环会阻塞。

```
import "fmt"

func fibonacci(mychan chan int) {
    n := cap(mychan)
    x, y := 1, 1
    for i := 0; i < n; i++ {
        mychan <- x
        x, y = y, x+y
    }
    // 记得 close 信道
    // 不然主函数中遍历完并不会结束，而是会阻塞。
    close(mychan)
}

func main() {
    pipline := make(chan int, 10)

    go fibonacci(pipline)

    for k := range pipline {
        fmt.Println(k)
    }
}
```

## 6. 用信道来做锁

当信道里的数据量已经达到设定的容量时，此时再往里发送数据会阻塞整个程序。

利用这个特性，可以用当他来当程序的锁。

示例如下，详情可以看注释

```
package main

import (
    "fmt"
    "time"
)

// 由于 x=x+1 不是原子操作
// 所以应避免多个协程对x进行操作
// 使用容量为1的信道可以达到锁的效果
func increment(ch chan bool, x *int) {
    ch <- true
    *x = *x + 1
    <- ch
}

func main() {
    // 注意要设置容量为 1 的缓冲信道
    pipline := make(chan bool, 1)

    var x int
    for i:=0;i<1000;i++{
        go increment(pipline, &x)
    }

    // 确保所有的协程都已完成
    // 以后会介绍一种更合适的方法（Mutex），这里暂时使用sleep
    time.Sleep(time.Second)
    fmt.Println("x 的值：", x)
}
```

输出如下

```
x 的值：1000
```

如果不加锁，输出会小于1000。

## 7. 几个注意事项

1. 关闭一个未初始化的 channel 会产生 panic
2. 重复关闭同一个 channel 会产生 panic
3. 向一个已关闭的 channel 发送消息会产生 panic
4. 从已关闭的 channel 读取消息不会产生 panic，且能读出 channel 中还未被读取的消息，若消息均已被读取，则会读取到该类型的零值。
5. 从已关闭的 channel 读取消息永远不会阻塞，并且会返回一个为 false 的值，用以判断该 channel 是否已关闭（x,ok := <- ch）
6. 关闭 channel 会产生一个广播机制，所有向 channel 读取消息的 goroutine 都会收到消息
7. channel 在 Golang 中是一等公民，它是线程安全的，面对并发问题，应首先想到 channel。



# 4.4 学习 Go 协程：WaitGroup

在前两篇文章里，我们学习了 `协程` 和 `信道` 的内容，里面有很多例子，当时为了保证 main goroutine 在所有的 goroutine 都执行完毕后再退出，我使用了 time.Sleep 这种简单的方式。

由于写的 demo 都是比较简单的， sleep 个 1 秒，我们主观上认为是够用的。

但在实际开发中，开发人员是无法预知，所有的 goroutine 需要多长的时间才能执行完毕，sleep 多了吧主程序就阻塞了， sleep 少了吧有的子协程的任务就没法完成。

因此，使用time.Sleep 是一种极不推荐的方式，今天主要就要来介绍 一下如何优雅的处理这种情况。

## 1. 使用信道来标记完成

> “不要通过共享内存来通信，要通过通信来共享内存”

学习了信道后，我们知道，信道可以实现多个协程间的通信，那么我们只要定义一个信道，在任务完成后，往信道中写入true，然后在主协程中获取到true，就认为子协程已经执行完毕。

```
import "fmt"

func main() {
    done := make(chan bool)
    go func() {
        for i := 0; i < 5; i++ {
            fmt.Println(i)
        }
        done <- true
    }()
    <-done
}
```

输出如下

```
0
1
2
3
4
```

## 2. 使用 WaitGroup

上面使用信道的方法，在单个协程或者协程数少的时候，并不会有什么问题，但在协程数多的时候，代码就会显得非常复杂，有兴趣可以自己尝试一下。

那么有没有一种更加优雅的方式呢？

有，这就要说到 sync包 提供的 WaitGroup 类型。

WaitGroup 你只要实例化了就能使用

```
var 实例名 sync.WaitGroup
```

实例化完成后，就可以使用它的几个方法：

- Add：初始值为0，你传入的值会往计数器上加，这里直接传入你子协程的数量
- Done：当某个子协程完成后，可调用此方法，会从计数器上减一，通常可以使用 defer 来调用。
- Wait：阻塞当前协程，直到实例里的计数器归零。

举一个例子：

```
import (
    "fmt"
    "sync"
)

func worker(x int, wg *sync.WaitGroup) {
    defer wg.Done()
    for i := 0; i < 5; i++ {
        fmt.Printf("worker %d: %d\n", x, i)
    }
}

func main() {
    var wg sync.WaitGroup

    wg.Add(2)
    go worker(1, &wg)
    go worker(2, &wg)

    wg.Wait()
}
```

输出如下

```
worker 2: 0
worker 2: 1
worker 2: 2
worker 2: 3
worker 2: 4
worker 1: 0
worker 1: 1
worker 1: 2
worker 1: 3
worker 1: 4
```

以上就是我们在 Go 语言中实现一主多子的协程协作方式，推荐使用 sync.WaitGroup。。

# 4.5 学习 Go 协程：互斥锁和读写锁

在 「[4.3 学习 Go 协程：详解信道/通道](http://golang.iswbm.com/en/latest/c04/c04_03.html)」这一节里我详细地介绍信道的一些用法，要知道的是在 Go 语言中，信道的地位非常高，它是 first class 级别的，面对并发问题，我们始终应该优先考虑使用信道，如果通过信道解决不了的，不得不使用共享内存来实现并发编程的，那 Golang 中的锁机制，就是你绕不过的知识点了。

今天就来讲一讲 Golang 中的锁机制。

在 Golang 里有专门的方法来实现锁，还是上一节里介绍的 sync 包。

这个包有两个很重要的锁类型

一个叫 `Mutex`， 利用它可以实现互斥锁。

一个叫 `RWMutex`，利用它可以实现读写锁。

## 1. 互斥锁 ：Mutex

使用互斥锁（Mutex，全称 mutual exclusion）是为了来保护一个资源不会因为并发操作而引起冲突导致数据不准确。

举个例子，就像下面这段代码，我开启了三个协程，每个协程分别往 count 这个变量加1000次 1，理论上看，最终的 count 值应试为 3000

```
package main

import (
    "fmt"
    "sync"
)

func add(count *int, wg *sync.WaitGroup) {
    for i := 0; i < 1000; i++ {
        *count = *count + 1
    }
    wg.Done()
}

func main() {
    var wg sync.WaitGroup
    count := 0
    wg.Add(3)
    go add(&count, &wg)
    go add(&count, &wg)
    go add(&count, &wg)

    wg.Wait()
    fmt.Println("count 的值为：", count)
}
```

可运行多次的结果，都不相同

```
// 第一次
count 的值为： 2854

// 第二次
count 的值为： 2673

// 第三次
count 的值为： 2840
```

原因就在于这三个协程在执行时，先读取 count 再更新 count 的值，而这个过程并不具备原子性，所以导致了数据的不准确。

解决这个问题的方法，就是给 add 这个函数加上 Mutex 互斥锁，要求同一时刻，仅能有一个协程能对 count 操作。

在写代码前，先了解一下 Mutex 锁的两种定义方法

```
// 第一种
var lock *sync.Mutex
lock = new(sync.Mutex)

// 第二种
lock := &sync.Mutex{}
```

然后就可以修改你上面的代码，如下所示

```
import (
    "fmt"
    "sync"
)

func add(count *int, wg *sync.WaitGroup, lock *sync.Mutex) {
    for i := 0; i < 1000; i++ {
        lock.Lock()
        *count = *count + 1
        lock.Unlock()
    }
    wg.Done()
}

func main() {
    var wg sync.WaitGroup
    lock := &sync.Mutex{}
    count := 0
    wg.Add(3)
    go add(&count, &wg, lock)
    go add(&count, &wg, lock)
    go add(&count, &wg, lock)

    wg.Wait()
    fmt.Println("count 的值为：", count)
}
```

此时，不管你执行多少次，输出都只有一个结果

```
count 的值为： 3000
```

使用 Mutext 锁虽然很简单，但仍然有几点需要注意：

- 同一协程里，不要在尚未解锁时再次使加锁
- 同一协程里，不要对已解锁的锁再次解锁
- 加了锁后，别忘了解锁，必要时使用 defer 语句

## 2. 读写锁：RWMutex

Mutex 是最简单的一种锁类型，他提供了一个傻瓜式的操作，加锁解锁加锁解锁，让你不需要再考虑其他的。

**简单**同时意味着在某些特殊情况下有可能会造成时间上的浪费，导致程序性能低下。

举个例子，我们平时去图书馆，要嘛是去借书，要嘛去还书，借书的流程繁锁，没有办卡的还要让管理员给你办卡，因此借书通常都要排老长的队，假设图书馆里只有一个管理员，按照 Mutex（互斥锁）的思想， 这个管理员同一时刻只能服务一个人，这就意味着，还书的也要跟借书的一起排队。

可还书的步骤非常简单，可能就把书给管理员扫下码就可以走了。

如果让还书的人，跟借书的人一起排队，那估计有很多人都不乐意了。

因此，图书馆为了提高整个流程的效率，就允许还书的人，不需要排队，可以直接自助还书。

图书管将馆里的人分得更细了，对于读者的不同需求提供了不同的方案。提高了效率。

RWMutex，也是如此，它将程序对资源的访问分为读操作和写操作

- 为了保证数据的安全，它规定了当有人还在读取数据（即读锁占用）时，不允计有人更新这个数据（即写锁会阻塞）
- 为了保证程序的效率，多个人（线程）读取数据（拥有读锁）时，互不影响不会造成阻塞，它不会像 Mutex 那样只允许有一个人（线程）读取同一个数据。

理解了这个后，再来看看，如何使用 RWMutex？

定义一个 RWMuteux 锁，有两种方法

```
// 第一种
var lock *sync.RWMutex
lock = new(sync.RWMutex)

// 第二种
lock := &sync.RWMutex{}
```

RWMutex 里提供了两种锁，每种锁分别对应两个方法，为了避免死锁，两个方法应成对出现，必要时请使用 defer。

- 读锁：调用 RLock 方法开启锁，调用 RUnlock 释放锁
- 写锁：调用 Lock 方法开启锁，调用 Unlock 释放锁（和 Mutex类似）

接下来，直接看一下例子吧

```
package main

import (
    "fmt"
    "sync"
    "time"
)

func main() {
    lock := &sync.RWMutex{}
    lock.Lock()

    for i := 0; i < 4; i++ {
        go func(i int) {
            fmt.Printf("第 %d 个协程准备开始... \n", i)
            lock.RLock()
            fmt.Printf("第 %d 个协程获得读锁, sleep 1s 后，释放锁\n", i)
            time.Sleep(time.Second)
            lock.RUnlock()
        }(i)
    }

    time.Sleep(time.Second * 2)

    fmt.Println("准备释放写锁，读锁不再阻塞")
    // 写锁一释放，读锁就自由了
    lock.Unlock()

    // 由于会等到读锁全部释放，才能获得写锁
    // 因为这里一定会在上面 4 个协程全部完成才能往下走
    lock.Lock()
    fmt.Println("程序退出...")
    lock.Unlock()
}
```

输出如下

```
第 1 个协程准备开始...
第 0 个协程准备开始...
第 3 个协程准备开始...
第 2 个协程准备开始...
准备释放写锁，读锁不再阻塞
第 2 个协程获得读锁, sleep 1s 后，释放锁
第 3 个协程获得读锁, sleep 1s 后，释放锁
第 1 个协程获得读锁, sleep 1s 后，释放锁
第 0 个协程获得读锁, sleep 1s 后，释放锁
程序退出...
```

# 4.7 学习 Go 协程： 信道死锁经典错误案例

刚接触 Go 语言的信道的时候，经常会遇到死锁的错误，而导致这个错误的原因有很多种，这里整理了几种常见的。

```
fatal error: all goroutines are asleep - deadlock!
```

## 错误示例一

看下面这段代码

```
package main

import "fmt"

func main() {
    pipline := make(chan string)
    pipline <- "hello world"
    fmt.Println(<-pipline)
}
```

运行会抛出错误，如下

```
fatal error: all goroutines are asleep - deadlock!
```

看起来好像没有什么问题？先往信道中存入数据，再从信道中读取数据。

回顾前面的基础，我们知道使用 make 创建信道的时候，若不传递第二个参数，则你定义的是无缓冲信道，而对于无缓冲信道，在接收者未准备好之前，发送操作是阻塞的.

因此，对于解决此问题有两种方法：

1. 使接收者代码在发送者之前执行
2. 使用缓冲信道，而不使用无缓冲信道

**第一种方法**：

若要程序正常执行，需要保证接收者程序在发送数据到信道前就进行阻塞状态，修改代码如下

```
package main

import "fmt"

func main() {
    pipline := make(chan string)
    fmt.Println(<-pipline)
    pipline <- "hello world"
}
```

运行的时候还是报同样的错误。问题出在哪里呢？

原来我们将发送者和接收者写在了同一协程中，虽然保证了接收者代码在发送者之前执行，但是由于前面接收者一直在等待数据 而处于阻塞状态，所以无法执行到后面的发送数据。还是一样造成了死锁。

有了前面的经验，我们将接收者代码写在另一个协程里，并保证在发送者之前执行，就像这样的代码

```
package main

func hello(pipline chan string)  {
    <-pipline
}

func main()  {
    pipline := make(chan string)
    go hello(pipline)
    pipline <- "hello world"
}
```

运行之后 ，一切正常。

**第二种方法**：

接收者代码必须在发送者代码之前 执行，这是针对无缓冲信道才有的约束。

既然这样，我们改使用可缓冲信道不就OK了吗？

```
package main

import "fmt"

func main() {
    pipline := make(chan string, 1)
    pipline <- "hello world"
    fmt.Println(<-pipline)
}
```

运行之后，一切正常。

## 错误示例二

每个缓冲信道，都有容量，当信道里的数据量等于信道的容量后，此时再往信道里发送数据，就失造成阻塞，必须等到有人从信道中消费数据后，程序才会往下进行。

比如这段代码，信道容量为 1，但是往信道中写入两条数据，对于一个协程来说就会造成死锁。

```
package main

import "fmt"

func main() {
    ch1 := make(chan string, 1)

    ch1 <- "hello world"
    ch1 <- "hello China"

    fmt.Println(<-ch1)
}
```

## 错误示例三

当程序一直在等待从信道里读取数据，而此时并没有人会往信道中写入数据。此时程序就会陷入死循环，造成死锁。

比如这段代码，for 循环接收了两次消息（“hello world”和“hello China”）后，再也没有人发送数据了，接收者就会处于一个等待永远接收不到数据的囧境。陷入死循环，造成死锁。

```
package main

import "fmt"

func main() {
    pipline := make(chan string)
    go func() {
        pipline <- "hello world"
        pipline <- "hello China"
        // close(pipline)
    }()
    for data := range pipline{
        fmt.Println(data)
    }
}
```

包子铺里的包子已经卖完了，可还有人在排队等着买，如果不再做包子，就要告诉排队的人：不用等了，今天的包子已经卖完了，明日请早呀。

不能让人家死等呀，不跟客人说明一下，人家还以为你们店后面还在蒸包子呢。

所以这个问题，解决方法很简单，只要在发送完数据后，手动关闭信道，告诉 range 信道已经关闭，无需等待就行。

```
package main

import "fmt"

func main() {
    pipline := make(chan string)
    go func() {
        pipline <- "hello world"
        pipline <- "hello China"
        close(pipline)
    }()
    for data := range pipline{
        fmt.Println(data)
    }
}
```

------

# 4.7 学习 Go 协程：如何实现一个协程池？

在 Golang 中要创建一个协程是一件无比简单的事情，你只要定义一个函数，并使用 go 关键字去执行它就行了。

如果你接触过其他语言，会发现你在使用使用线程时，为了减少线程频繁创建销毁还来的开销，通常我们会使用线程池来复用线程。

**池化技术就是利用复用来提升性能的，那在 Golang 中需要协程池吗？**

在 Golang 中，goroutine 是一个轻量级的线程，他的创建、调度都是在用户态进行，并不需要进入内核，这意味着创建销毁协程带来的开销是非常小的。

因此，我认为大多数情况下，开发人员是不太需要使用协程池的。

但也不排除有某些场景下是需要这样做，因为我还没有遇到就不说了。

抛开**是否必要**这个问题，单纯从技术的角度来看，我们可以怎样实现一个通用的协程池呢？

下面就来一起学习一下我的写法

首先定义一个协程池（Pool）结构体，包含两个属性，都是 chan 类型的。

一个是 work，用于接收 task 任务

一个是 sem，用于设置协程池大小，即可同时执行的协程数量

```
type Pool struct {
    work chan func()   // 任务
    sem  chan struct{} // 数量
}
```

然后定义一个 New 函数，用于创建一个协程池对象，有一个细节需要注意

work 是一个无缓冲通道

而 sem 是一个缓冲通道，size 大小即为协程池大小

```
func New(size int) *Pool {
    return &Pool{
        work: make(chan func()),
        sem:  make(chan struct{}, size),
    }
}
```

最后给协程池对象绑定两个函数

1、**NewTask**：往协程池中添加任务

当第一次调用 NewTask 添加任务的时候，由于 work 是无缓冲通道，所以会一定会走第二个 case 的分支：使用 go worker 开启一个协程。

```
func (p *Pool) NewTask(task func()) {
    select {
        case p.work <- task:
        case p.sem <- struct{}{}:
            go p.worker(task)
    }
}
```

2、**worker**：用于执行任务

为了能够实现协程的复用，这个使用了 for 无限循环，使这个协程在执行完任务后，也不退出，而是一直在接收新的任务。

```
func (p *Pool) worker(task func()) {
    defer func() { <-p.sem }()
    for {
        task()
        task = <-p.work
    }
}
```

这两个函数是协程池实现的关键函数，里面的逻辑很值得推敲：

1、如果设定的协程池数大于 2，此时第二次传入往 NewTask 传入task，select case 的时候，如果第一个协程还在运行中，就一定会走第二个case，重新创建一个协程执行task

2、如果传入的任务数大于设定的协程池数，并且此时所有的任务都还在运行中，那此时再调用 NewTask 传入 task ，这两个 case 都不会命中，会一直阻塞直到有任务执行完成，worker 函数里的 work 通道才能接收到新的任务，继续执行。

以上便是协程池的实现过程。

使用它也很简单，看下面的代码你就明白了

```
func main()  {
    pool := New(128)
    pool.NewTask(func(){
        fmt.Println("run task")
    })
}
```

为了让你看到效果，我设置协程池数为 2，开启四个任务，都是 sleep 2 秒后，打印当前时间。

```
func main()  {
    pool := New(2)

    for i := 1; i <5; i++{
        pool.NewTask(func(){
            time.Sleep(2 * time.Second)
            fmt.Println(time.Now())
        })
    }

    // 保证所有的协程都执行完毕
    time.Sleep(5 * time.Second)
}
```

执行结果如下，可以看到总共 4 个任务，由于协程池大小为 2，所以 4 个任务分两批执行（从打印的时间可以看出）

```
2020-05-24 23:18:02.014487 +0800 CST m=+2.005207182
2020-05-24 23:18:02.014524 +0800 CST m=+2.005243650
2020-05-24 23:18:04.019755 +0800 CST m=+4.010435443
2020-05-24 23:18:04.019819 +0800 CST m=+4.010499440
```

# 4.8 理解 Go 语言中的 Context

## 1. 什么是 Context？

在 Go 1.7 版本之前，context 还是非编制的，它存在于 golang.org/x/net/context 包中。

后来，Golang 团队发现 context 还挺好用的，就把 context 收编了，在 Go 1.7 版本正式纳入了标准库。

Context，也叫上下文，它的接口定义如下

```
type Context interface {
    Deadline() (deadline time.Time, ok bool)
    Done() <-chan struct{}
    Err() error
    Value(key interface{}) interface{}
}
```

可以看到 Context 接口共有 4 个方法

- `Deadline`：返回的第一个值是 **截止时间**，到了这个时间点，Context 会自动触发 Cancel 动作。返回的第二个值是 一个布尔值，true 表示设置了截止时间，false 表示没有设置截止时间，如果没有设置截止时间，就要手动调用 cancel 函数取消 Context。
- `Done`：返回一个只读的通道（只有在被cancel后才会返回），类型为 `struct{}`。当这个通道可读时，意味着parent context已经发起了取消请求，根据这个信号，开发者就可以做一些清理动作，退出goroutine。
- `Err`：返回 context 被 cancel 的原因。
- `Value`：返回被绑定到 Context 的值，是一个键值对，所以要通过一个Key才可以获取对应的值，这个值一般是线程安全的。

## 2. 为何需要 Context？

当一个协程（goroutine）开启后，我们是无法强制关闭它的。

常见的关闭协程的原因有如下几种：

1. goroutine 自己跑完结束退出
2. 主进程crash退出，goroutine 被迫退出
3. 通过通道发送信号，引导协程的关闭。

第一种，属于正常关闭，不在今天讨论范围之内。

第二种，属于异常关闭，应当优化代码。

第三种，才是开发者可以手动控制协程的方法，代码示例如下：

```
func main() {
    stop := make(chan bool)

    go func() {
        for {
            select {
            case <-stop:
                fmt.Println("监控退出，停止了...")
                return
            default:
                fmt.Println("goroutine监控中...")
                time.Sleep(2 * time.Second)
            }
        }
    }()

    time.Sleep(10 * time.Second)
    fmt.Println("可以了，通知监控停止")
    stop<- true
    //为了检测监控过是否停止，如果没有监控输出，就表示停止了
    time.Sleep(5 * time.Second)

}
```

例子中我们定义一个`stop`的chan，通知他结束后台goroutine。实现也非常简单，在后台goroutine中，使用select判断`stop`是否可以接收到值，如果可以接收到，就表示可以退出停止了；如果没有接收到，就会执行`default`里的监控逻辑，继续监控，只到收到`stop`的通知。

以上是一个 goroutine 的场景，如果是多个 goroutine ，每个goroutine 底下又开启了多个 goroutine 的场景呢？在 [飞雪无情的博客](https://www.flysnow.org/2017/05/12/go-in-action-go-context.html) 里关于为何要使用 Context，他是这么说的

> chan+select的方式，是比较优雅的结束一个goroutine的方式，不过这种方式也有局限性，如果有很多goroutine都需要控制结束怎么办呢？如果这些goroutine又衍生了其他更多的goroutine怎么办呢？如果一层层的无穷尽的goroutine呢？这就非常复杂了，即使我们定义很多chan也很难解决这个问题，因为goroutine的关系链就导致了这种场景非常复杂。

在这里我不是很赞同他说的话，因为我觉得就算只使用一个通道也能达到控制（取消）多个 goroutine 的目的。下面就用例子来验证一下。

该例子的原理是：使用 close 关闭通道后，如果该通道是无缓冲的，则它会从原来的阻塞变成非阻塞，也就是可读的，只不过读到的会一直是零值，因此根据这个特性就可以判断 拥有该通道的 goroutine 是否要关闭。

```
package main

import (
    "fmt"
    "time"
)

func monitor(ch chan bool, number int)  {
    for {
        select {
        case v := <-ch:
            // 仅当 ch 通道被 close，或者有数据发过来(无论是true还是false)才会走到这个分支
            fmt.Printf("监控器%v，接收到通道值为：%v，监控结束。\n", number,v)
            return
        default:
            fmt.Printf("监控器%v，正在监控中...\n", number)
            time.Sleep(2 * time.Second)
        }
    }
}

func main() {
    stopSingal := make(chan bool)

    for i :=1 ; i <= 5; i++ {
        go monitor(stopSingal, i)
    }

    time.Sleep( 1 * time.Second)
    // 关闭所有 goroutine
    close(stopSingal)

    // 等待5s，若此时屏幕没有输出 <正在监控中> 就说明所有的goroutine都已经关闭
    time.Sleep( 5 * time.Second)

    fmt.Println("主程序退出！！")

}
```

输出如下

```
监控器4，正在监控中...
监控器1，正在监控中...
监控器2，正在监控中...
监控器3，正在监控中...
监控器5，正在监控中...
监控器2，接收到通道值为：false，监控结束。
监控器3，接收到通道值为：false，监控结束。
监控器5，接收到通道值为：false，监控结束。
监控器1，接收到通道值为：false，监控结束。
监控器4，接收到通道值为：false，监控结束。
主程序退出！！
```

上面的例子，说明当我们定义一个无缓冲通道时，如果要对所有的 goroutine 进行关闭，可以使用 close 关闭通道，然后在所有的 goroutine 里不断检查通道是否关闭(前提你得约定好，该通道你只会进行 close 而不会发送其他数据，否则发送一次数据就会关闭一个goroutine，这样会不符合咱们的预期，所以最好你对这个通道再做一层封装做个限制)来决定是否结束 goroutine。

所以你看到这里，我做为初学者还是没有找到使用 Context 的必然理由，我只能说 Context 是个很好用的东西，使用它方便了我们在处理并发时候的一些问题，但是它并不是不可或缺的。

换句话说，它解决的并不是 **能不能** 的问题，而是解决 **更好用** 的问题。

## 3. 简单使用 Context

如果不使用上面 close 通道的方式，还有没有其他更优雅的方法来实现呢？

**有，那就是本文要讲的 Context**

我使用 Context 对上面的例子进行了一番改造。

```
package main

import (
    "context"
    "fmt"
    "time"
)

func monitor(ctx context.Context, number int)  {
    for {
        select {
        // 其实可以写成 case <- ctx.Done()
        // 这里仅是为了让你看到 Done 返回的内容
        case v :=<- ctx.Done():
            fmt.Printf("监控器%v，接收到通道值为：%v，监控结束。\n", number,v)
            return
        default:
            fmt.Printf("监控器%v，正在监控中...\n", number)
            time.Sleep(2 * time.Second)
        }
    }
}

func main() {
    ctx, cancel := context.WithCancel(context.Background())

    for i :=1 ; i <= 5; i++ {
        go monitor(ctx, i)
    }

    time.Sleep( 1 * time.Second)
    // 关闭所有 goroutine
    cancel()

    // 等待5s，若此时屏幕没有输出 <正在监控中> 就说明所有的goroutine都已经关闭
    time.Sleep( 5 * time.Second)

    fmt.Println("主程序退出！！")

}
```

这里面的关键代码，也就三行

第一行：以 context.Background() 为 parent context 定义一个可取消的 context

```
ctx, cancel := context.WithCancel(context.Background())
```

第二行：然后你可以在所有的goroutine 里利用 for + select 搭配来不断检查 ctx.Done() 是否可读，可读就说明该 context 已经取消，你可以清理 goroutine 并退出了。

```
case <- ctx.Done():
```

第三行：当你想到取消 context 的时候，只要调用一下 cancel 方法即可。这个 cancel 就是我们在创建 ctx 的时候返回的第二个值。

```
cancel()
```

运行结果输出如下。可以发现我们实现了和 close 通道一样的效果。

```
监控器3，正在监控中...
监控器4，正在监控中...
监控器1，正在监控中...
监控器2，正在监控中...
监控器2，接收到通道值为：{}，监控结束。
监控器5，接收到通道值为：{}，监控结束。
监控器4，接收到通道值为：{}，监控结束。
监控器1，接收到通道值为：{}，监控结束。
监控器3，接收到通道值为：{}，监控结束。
主程序退出！！
```

## 4. 根Context 是什么？

创建 Context 必须要指定一个 父 Context，当我们要创建第一个Context时该怎么办呢？

不用担心，Go 已经帮我们实现了2个，我们代码中最开始都是以这两个内置的context作为最顶层的parent context，衍生出更多的子Context。

```
var (
    background = new(emptyCtx)
    todo       = new(emptyCtx)
)

func Background() Context {
    return background
}

func TODO() Context {
    return todo
}
```

一个是Background，主要用于main函数、初始化以及测试代码中，作为Context这个树结构的最顶层的Context，也就是根Context，它不能被取消。

一个是TODO，如果我们不知道该使用什么Context的时候，可以使用这个，但是实际应用中，暂时还没有使用过这个TODO。

他们两个本质上都是emptyCtx结构体类型，是一个不可取消，没有设置截止时间，没有携带任何值的Context。

```
type emptyCtx int

func (*emptyCtx) Deadline() (deadline time.Time, ok bool) {
    return
}

func (*emptyCtx) Done() <-chan struct{} {
    return nil
}

func (*emptyCtx) Err() error {
    return nil
}

func (*emptyCtx) Value(key interface{}) interface{} {
    return nil
}
```

## 5. Context 的继承衍生

上面在定义我们自己的 Context 时，我们使用的是 `WithCancel` 这个方法。

除它之外，context 包还有其他几个 With 系列的函数

```
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc)
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
func WithValue(parent Context, key, val interface{}) Context
```

这四个函数有一个共同的特点，就是第一个参数，都是接收一个 父context。

通过一次继承，就多实现了一个功能，比如使用 WithCancel 函数传入 根context ，就创建出了一个子 context，该子context 相比 父context，就多了一个 cancel context 的功能。

如果此时，我们再以上面的子context（context01）做为父context，并将它做为第一个参数传入WithDeadline函数，获得的子子context（context02），相比子context（context01）而言，又多出了一个超过 deadline 时间后，自动 cancel context 的功能。

接下来我会举例介绍一下这几种 context，其中 WithCancel 在上面已经讲过了，下面就不再举例了

### 例子 1：WithDeadline

```
package main

import (
    "context"
    "fmt"
    "time"
)

func monitor(ctx context.Context, number int)  {
    for {
        select {
        case <- ctx.Done():
            fmt.Printf("监控器%v，监控结束。\n", number)
            return
        default:
            fmt.Printf("监控器%v，正在监控中...\n", number)
            time.Sleep(2 * time.Second)
        }
    }
}

func main() {
    ctx01, cancel := context.WithCancel(context.Background())
    ctx02, cancel := context.WithDeadline(ctx01, time.Now().Add(1 * time.Second))

    defer cancel()

    for i :=1 ; i <= 5; i++ {
        go monitor(ctx02, i)
    }

    time.Sleep(5  * time.Second)
    if ctx02.Err() != nil {
        fmt.Println("监控器取消的原因: ", ctx02.Err())
    }

    fmt.Println("主程序退出！！")
}
```

输出如下

```
监控器5，正在监控中...
监控器1，正在监控中...
监控器2，正在监控中...
监控器3，正在监控中...
监控器4，正在监控中...
监控器3，监控结束。
监控器4，监控结束。
监控器2，监控结束。
监控器1，监控结束。
监控器5，监控结束。
监控器取消的原因:  context deadline exceeded
主程序退出！！
```

### 例子 2：WithTimeout

WithTimeout 和 WithDeadline 使用方法及功能基本一致，都是表示超过一定的时间会自动 cancel context。

唯一不同的地方，我们可以从函数的定义看出

```
func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc)

func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
```

WithDeadline 传入的第二个参数是 time.Time 类型，它是一个绝对的时间，意思是在什么时间点超时取消。

而 WithTimeout 传入的第二个参数是 time.Duration 类型，它是一个相对的时间，意思是多长时间后超时取消。

```
package main

import (
    "context"
    "fmt"
    "time"
)

func monitor(ctx context.Context, number int)  {
    for {
        select {
        case <- ctx.Done():
            fmt.Printf("监控器%v，监控结束。\n", number)
            return
        default:
            fmt.Printf("监控器%v，正在监控中...\n", number)
            time.Sleep(2 * time.Second)
        }
    }
}

func main() {
    ctx01, cancel := context.WithCancel(context.Background())

    // 相比例子1，仅有这一行改动
    ctx02, cancel := context.WithTimeout(ctx01, 1* time.Second)

    defer cancel()

    for i :=1 ; i <= 5; i++ {
        go monitor(ctx02, i)
    }

    time.Sleep(5  * time.Second)
    if ctx02.Err() != nil {
        fmt.Println("监控器取消的原因: ", ctx02.Err())
    }

    fmt.Println("主程序退出！！")
}
```

输出的结果和上面一样

```
监控器1，正在监控中...
监控器5，正在监控中...
监控器3，正在监控中...
监控器2，正在监控中...
监控器4，正在监控中...
监控器4，监控结束。
监控器2，监控结束。
监控器5，监控结束。
监控器1，监控结束。
监控器3，监控结束。
监控器取消的原因:  context deadline exceeded
主程序退出！！
```

### 例子 3：WithValue

通过Context我们也可以传递一些必须的元数据，这些数据会附加在Context上以供使用。

元数据以 Key-Value 的方式传入，Key 必须有可比性，Value 必须是线程安全的。

还是用上面的例子，以 ctx02 为父 context，再创建一个能携带 value 的ctx03，由于他的父context 是 ctx02，所以 ctx03 也具备超时自动取消的功能。

```
package main

import (
    "context"
    "fmt"
    "time"
)

func monitor(ctx context.Context, number int)  {
    for {
        select {
        case <- ctx.Done():
            fmt.Printf("监控器%v，监控结束。\n", number)
            return
        default:
            // 获取 item 的值
            value := ctx.Value("item")
            fmt.Printf("监控器%v，正在监控 %v \n", number, value)
            time.Sleep(2 * time.Second)
        }
    }
}

func main() {
    ctx01, cancel := context.WithCancel(context.Background())
    ctx02, cancel := context.WithTimeout(ctx01, 1* time.Second)
    ctx03 := context.WithValue(ctx02, "item", "CPU")

    defer cancel()

    for i :=1 ; i <= 5; i++ {
        go monitor(ctx03, i)
    }

    time.Sleep(5  * time.Second)
    if ctx02.Err() != nil {
        fmt.Println("监控器取消的原因: ", ctx02.Err())
    }

    fmt.Println("主程序退出！！")
}
```

输出如下

```
监控器4，正在监控 CPU
监控器5，正在监控 CPU
监控器1，正在监控 CPU
监控器3，正在监控 CPU
监控器2，正在监控 CPU
监控器2，监控结束。
监控器5，监控结束。
监控器3，监控结束。
监控器1，监控结束。
监控器4，监控结束。
监控器取消的原因:  context deadline exceeded
主程序退出！！
```

## 6. Context 使用注意事项

1. 通常 Context 都是做为函数的第一个参数进行传递（规范性做法），并且变量名建议统一叫 ctx
2. Context 是线程安全的，可以放心地在多个 goroutine 中使用。
3. 当你把 Context 传递给多个 goroutine 使用时，只要执行一次 cancel 操作，所有的 goroutine 就可以收到 取消的信号
4. 不要把原本可以由函数参数来传递的变量，交给 Context 的 Value 来传递。
5. 当一个函数需要接收一个 Context 时，但是此时你还不知道要传递什么 Context 时，可以先用 context.TODO 来代替，而不要选择传递一个 nil。
6. 当一个 Context 被 cancel 时，继承自该 Context 的所有 子 Context 都会被 cancel。



# 4.9 学习一些常见的并发模型

本篇内容主要是了解下并发编程中的一些概念，及讲述一些常用的并发模型都是什么样的，从而理解 Golang 中的 协程在这些众多模型中是一种什么样的存在及地位。可能和本系列的初衷（零基础学Go）有所出入，因此你读不读本篇都不会对你学习Go有影响，尽管我个人觉得这是有必要了解的。

你可以自行选择，若你只想学习 Golang 有关的内容，完全可以跳过本篇。

## 0. 并发与并行

讲到并发，那不防先了解下什么是并发，与之相对的并行有什么区别？

这里我用两个例子来形象描述：

- **并发**：当你在跑步时，发现鞋带松，要停下来系鞋带，这时候跑步和系鞋带就是并发状态。
- **并行**：你跑步时，可以同时听歌，那么跑步和听歌就是并行状态，谁也不影响谁。

在计算机的世界中，一个CPU核严格来说同一时刻只能做一件事，但由于CPU的频率实在太快了，人们根本感知不到其切换的过程，所以我们在编码的时候，实际上是可以在单核机器上写多进程的程序（但你要知道这是假象），这是相对意义上的并行。

而当你的机器有多个 CPU 核时，多个进程之间才能真正的实现并行，这是绝对意义上的并行。

接着来说并发，所谓的并发，就是多个任务之间可以在同一时间段里一起执行。

但是在单核CPU里，他同一时刻只能做一件事情 ，怎么办？

谁都不能偏坦，我就先做一会 A 的活，再做一会B 的活，接着去做一会 C 的活，然后再去做一会 A 的活，就这样不断的切换着，大家都很开心，其乐融融。

## 1. 并发编程的模型

在计算机的世界里，实现并发通常有几种方式：

1. 多进程模型：创建新的进程处理请求
2. 多线程模型：创建新的线程处理请求
3. 使用线程池：线程/进程创建销毁开销大
4. I/O 多路复用+单/多线程

## 2. 多进程与多线程

对于普通的用户来说，进程是最熟悉的存在，比如一个 QQ ，一个微信，它们都是一个进程。

进程是计算机资源分配的最小单位，而线程是比进程更小的执行单元，它不能脱离于进程单独存在。

在一个进程里，至少有一个线程，那个线程叫主线程，同时你也可以创建多个线程，多个线程之间是可以并发执行的。

线程是调度的基本单位，在多线程里，在调度过程中，需要由 CPU 和 内核层参与上下文的切换。如果你跑了A线程，然后切到B线程，内核调用开始，CPU需要对A线程的上下文保留，然后切到B线程，然后把控制权交给你的应用层调度。

而进程的切换，相比线程来说，会更加麻烦。

因为进程有自己的独立地址空间，多个进程之间的地址空间是相互隔离的，这和线程有很大的不同，单个进程内的多个线程 共享进程中的数据的，使用相同的地址空间，所以CPU切换一个线程的花费远比进程要小很多，同时创建一个线程的开销也比进程要小很多。

此外，由于同一进程下的线程共享全局变量、静态变量等数据，使得线程间的通信非常方便，相比之下，进程间的通信（IPC，InterProcess Communication）就略显复杂，通常的进程间的通信方式有：管道，消息队列，信号量，Socket，Streams 等

说了这么多，好像都在说线程优于进程，也不尽然。

比如多线程更多用于有IO密集型的业务场景，而对于计算密集型的场景，应该优先选择多进程。

同时，多进程程序更健壮，多线程程序只要有一个线程死掉，整个进程也死掉了，而一个进程死掉并不会对另外一个进程造成影响，因为进程有自己独立的地址空间。

## 3. I/O多路复用

`I/O多路复用` ，英文全称为 `I/O multiplexing`，这个中文翻译和把 socket 翻译成 套接字一样，影响了我对其概念的理解。

在互联网早期，为了实现一个服务器可以处理多个客户端的连接，程序猿是这样做的。服务器得知来了一个请求后，就去创建一个线程处理这个请求，假如有10个客户请求，就创建10个线程，这在当时联网设备还比较匮乏的时代，是没有任何问题的。

但随着科技的发展，人们越来越富裕，都买得起电脑了，网民也越来越多了，由于一台机器的能开启的线程数是有限制的，当请求非常集中量大到一定量时，服务器的压力就巨大无比。

终于到了 1983年，人们意识到这种问题，提出了一种最早的 I/O 多路复用的模型（select实现），这种模型，对比之前最大的不同就是，处理请求的线程不再是根据请求来定，后端请求的进程只有一个。虽然这种模型在现在看来还是不行，但在当时已经大大减小了服务器系统的开销，可以解决服务器压力太大的问题，毕竟当时的电脑都是很珍贵的。

再后来，家家都有了电脑，手机互联网的时代也要开始来了，联网设备爆炸式增长，之前的 select ，早已不能支撑用户请求了。

由于使用 select 最多只能接收 1024 个连接，后来程序猿们又改进了 select 发明了 pool，pool 使用的链表存储，没有最大连接数的限制。

select 和 pool ，除了解决了连接数的限制 ，其他似乎没有本质的区别。

都是服务器知道了有一个连接来了，由于并不知道是哪那几个流（可能有一个，多个，甚至全部），所以只能一个一个查过去（轮循），假如服务器上有几万个文件描述符（下称fd，file descriptor），而你要处理一个请求，却要遍历几万个fd，这样是不是很浪费时间和资源。

由此程序员不得不持续改进 I/O多路复用的策略，这才有了后来的 epoll 方法。

epoll 解决了前期 select 和 poll 出现的一系列的尴尬问题，比如：

- select 和 poll 无差别轮循fd，浪费资源，epool 使用通知回调机制，有流发生 IO事件时就会主动触发回调函数
- select 和 poll 线程不安全，epool 线程安全
- select 请求连接数的限制，epool 能打开的FD的上限远大于1024（1G的内存上能监听约10万个端口）
- select 和 pool 需要频繁地将fd复制到内核空间，开销大，epoll通过内核和用户空间共享一块内存来减少这方面的开销。

虽然 I/O 多路复用经历了三种实现：select -> pool -> epool，这也不是就说 epool 出现了， select 就会被淘汰掉。

epool 关注的是活跃的连接数，当连接数非常多但活跃连接少的情况下（比如长连接数较多），epool 的性能最好。

而 select 关注的是连接总数，当连接数多而且大部分的连接都很活跃的情况下，选择 select 会更好，因为 epool 的通知回调机制需要很多的函数回调。

另外还有一点是，select 是 POSIX 规定的，一般操作系统均有实现，而 epool 是 Linux 所有的，其他平台上没有。

IO多路复用除了以上三种不同的具体实现的区别外，还可以根据线程数的多少来分类

- 一个线程的IO多路复用，比如 Redis
- 多个线程的IO多路复用，比如 goroutine

IO多路复用 + 单进（线）程有个好处，就是不会有并发编程的各种坑问题，比如在nginx里，redis里，编程实现都会很简单很多。编程中处理并发冲突和一致性，原子性问题真的是很难，极易出错。

## 4. 三种线程模型？

实际上，goroutine 并非传统意义上的协程。

现在主流的线程模型分三种：

- 内核级线程模型
- 用户级线程模型
- 两级线程模型（也称混合型线程模型）

传统的协程库属于**用户级线程模型**，而 goroutine 和它的 `Go Scheduler` 在底层实现上其实是属于**两级线程模型**，因此，有时候为了方便理解可以简单把 goroutine 类比成协程，但心里一定要有个清晰的认知 — goroutine并不等同于协程。

关于这块，想详细了解的，可以前往：https://studygolang.com/articles/13344

## 5. 协程的优势在哪？

协程，可以认为是轻量级的“线程”。

对比线程，有如下几个明显的优势。

1. 协程的调度由 Go 的 runtime 管理，协程切换不需要经由操作系统内核，开销较小。
2. 单个协程的堆栈只有几个kb，可创建协程的数量远超线程数。

同时，在 Golang 里，我还体会到了这种现代化编程语言带来的优势，它考虑得面面俱到，让编码变得更加的傻瓜式，goroutine的定义不需要在定义时区分是否异步函数（相对Python的 async def 而言），运行时只需要一个关键字 `go`，就可以轻松创建一个协程。

使用 -race 来检测数据 访问的冲突

协程什么时候会切换

1. I/O,select
2. channel
3. 等待锁
4. 函数调用
5. runtime.Gosched()

# 5.1 fmt.Printf 方法速查指南

## 1. fmt 的三大函数对比

`fmt` 标准库是我们在学习和编写 Go 代码，使用最频繁的库之一。

在新手阶段，通常会使用 fmt 包的 打印函数来查看变量的信息。

这样的打印函数，有三个

1. `fmt.Print`：正常打印字符串和变量，不会进行格式化，不会自动换行，需要手动添加 `\n` 进行换行，多个变量值之间不会添加空格
2. `fmt.Println`：正常打印字符串和变量，不会进行格式化，多个变量值之间会添加空格，并且在每个变量值后面会进行自动换行
3. `fmt.Printf`：可以按照自己需求对变量进行格式化打印。需要手动添加 `\n` 进行换行

```
func main() {
    fmt.Print("hello", "world\n")
    fmt.Println("hello", "world")
    fmt.Printf("hello world\n")
}
```

输出如下

```
helloworld
hello world
hello world
```

前面两个函数，使用起来比较简单，容易上手。

而第三个函数，使用起来虽然灵活，却有一定的上手难度，想要完全掌握，需要不断的进行练习。

因此，我花了半天的时间，参考官方文档，对 `fmt.Printf` 的使用进行了系统学习，整理了这篇文章。

这篇文章足够全面，完全可以成为你在使用 `fmt.Printf` 时的中文手册，收藏起来，需要用到了就来查一查。

## 2. 初识 fmt.Prinf 函数

`Printf` 函数的定义如下

```
func Printf(format string, a ...interface{}) (n int, err error) {
    return Fprintf(os.Stdout, format, a...)
}
```

它的 **第一个参数**是需要格式化的字符串，这个字符串可以是不包含**占位符**的字符串，也可以是包含**占位符**的字符串。

**占位符** 是以 `%` 开头的 n 位短代码，这些短代码根据约定的格式决定着变量输出的格式。

先举个例子

我想知道10 进制的 1024 用 2 进制、8进制、16进制表示各是什么？

可以像下面这样子写，其中的 `%d`、`%b`、`%o`、`%x` 都是叫做占位符，它决定了要以怎样的形式打印后面的变量 n。

```
package main

import "fmt"

func main() {
    n := 1024
    fmt.Printf("%d 的 2 进制：%b \n", n, n)
    fmt.Printf("%d 的 8 进制：%o \n", n, n)
    fmt.Printf("%d 的 10 进制：%d \n", n, n)
    fmt.Printf("%d 的 16 进制：%x \n", n, n)
}
```

运行后，输出如下

```
1024 的 2 进制：10000000000
1024 的 8 进制：2000
1024 的 10 进制：1024
1024 的 16 进制：400
```

初步理解了它的运行原理后，接下我会详细的讲解 `fmt.Printf`中的占位符都有哪些，他们各表示着什么意思。

## 3. 详解 Printf 的占位符

### 通用占位符

- `%v`：以值的默认格式打印
- `%+v`：类似%v，但输出结构体时会添加字段名
- `%#v`：值的Go语法表示
- `%T`：打印值的类型
- `%%`： 打印百分号本身

```
type Profile struct {
    name string
    gender string
    age int
}

func main() {
    var people = Profile{name:"wangbm", gender: "male", age:27}
    fmt.Printf("%v \n", people)  // output: {wangbm male 27}
    fmt.Printf("%T \n", people)  // output: main.Profile

    // 打印结构体名和类型
    fmt.Printf("%#v \n", people) // output: main.Profile{name:"wangbm", gender:"male", age:27}
    fmt.Printf("%+v \n", people) // output: {name:wangbm gender:male age:27}
    fmt.Printf("%% \n") // output: %
}
```

运行后、输出如下

```
{wangbm male 27}
main.Profile
main.Profile{name:"wangbm", gender:"male", age:27}
{name:wangbm gender:male age:27}
%
```

### 打印布尔值

```
func main() {
    fmt.Printf("%t \n", true)   //output: true
    fmt.Printf("%t \n", false)  //output: false
}
```

### 打印字符串

- `%s`：输出字符串表示（string类型或[]byte)
- `%q`：双引号围绕的字符串，由Go语法安全地转义
- `%x`：十六进制，小写字母，每字节两个字符
- `%X`：十六进制，大写字母，每字节两个字符

```
func main() {
    fmt.Printf("%s \n", []byte("Hello, Golang"))  // output: Hello, Golang
    fmt.Printf("%s \n", "Hello, Golang")     // output: Hello, Golang

    fmt.Printf("%q \n", []byte("Hello, Golang"))  // output: "Hello, Golang"
    fmt.Printf("%q \n", "Hello, Golang")     // output: "Hello, Golang"
    fmt.Printf("%q \n", `hello \r\n world`)  // output: "hello \\r\\n world"

    fmt.Printf("%x \n", "Hello, Golang")     // output: 48656c6c6f2c20476f6c616e67
    fmt.Printf("%X \n", "Hello, Golang")     // output: 48656c6c6f2c20476f6c616e67
}
```

运行后、输出如下

```
Hello, Golang
Hello, Golang

"Hello, Golang"
"Hello, Golang"
"hello \\r\\n world"

48656c6c6f2c20476f6c616e67
48656C6C6F2C20476F6C616E67
```

### 打印指针

```
func main() {
    var people = Profile{name:"wangbm", gender: "male", age:27}
    fmt.Printf("%p", &people)  // output: 0xc0000a6150
}
```

### 打印整型

- `%b`：以二进制打印
- `%d`：以十进制打印
- `%o`：以八进制打印
- `%x`：以十六进制打印，使用小写：a-f
- `%X`：以十六进制打印，使用大写：A-F
- `%c`：打印对应的的unicode码值
- `%q`：该值对应的单引号括起来的go语法字符字面值，必要时会采用安全的转义表示
- `%U`：该值对应的 Unicode格式：U+1234，等价于”U+%04X”

```
func main() {
    n := 1024
    fmt.Printf("%d 的 2 进制：%b \n", n, n)
    fmt.Printf("%d 的 8 进制：%o \n", n, n)
    fmt.Printf("%d 的 10 进制：%d \n", n, n)
    fmt.Printf("%d 的 16 进制：%x \n", n, n)

    // 将 10 进制的整型转成 16 进制打印： %x 为小写， %X 为小写
    fmt.Printf("%x \n", 1024)
    fmt.Printf("%X \n", 1024)

    // 根据 Unicode码值打印字符
    fmt.Printf("ASCII 编码为%d 表示的字符是： %c \n", 65, 65)  // output: A

    // 根据 Unicode 编码打印字符
    fmt.Printf("%c \n", 0x4E2D)  // output: 中
    // 打印 raw 字符时
    fmt.Printf("%q \n", 0x4E2D)  // output: '中'

    // 打印 Unicode 编码
    fmt.Printf("%U \n", '中')   // output: U+4E2D
}
```

运行后，输出如下

```
1024 的 2 进制：10000000000
1024 的 8 进制：2000
1024 的 10 进制：1024
1024 的 16 进制：400
400
400
ASCII 编码为65 表示的字符是： A
中
'中'
U+4E2D
```

### 打印浮点数

- `%e`：科学计数法，如-1234.456e+78
- `%E`：科学计数法，如-1234.456E+78
- `%f`：有小数部分但无指数部分，如123.456
- `%F`：等价于%f
- `%g`：根据实际情况采用%e或%f格式（以获得更简洁、准确的输出）
- `%G`：根据实际情况采用%E或%F格式（以获得更简洁、准确的输出）

```
func main() {
    f := 12.34
    fmt.Printf("%b\n", f)
    fmt.Printf("%e\n", f)
    fmt.Printf("%E\n", f)
    fmt.Printf("%f\n", f)
    fmt.Printf("%g\n", f)
    fmt.Printf("%G\n", f)
}
```

输出如下

```
6946802425218990p-49
1.234000e+01
1.234000E+01
12.340000
12.34
12.34
```

### 宽度标识符

宽度通过一个紧跟在百分号后面的十进制数指定，如果未指定宽度，则表示值时除必需之外不作填充。精度通过（可选的）宽度后跟点号后跟的十进制数指定。

如果未指定精度，会使用默认精度；如果点号后没有跟数字，表示精度为0。举例如下：

```
func main() {
    n := 12.34
    fmt.Printf("%f\n", n)     // 以默认精度打印
    fmt.Printf("%9f\n", n)   // 宽度为9，默认精度
    fmt.Printf("%.2f\n", n)  // 默认宽度，精度2
    fmt.Printf("%9.2f\n", n)  //宽度9，精度2
    fmt.Printf("%9.f\n", n)    // 宽度9，精度0
}
```

输出如下

```
10.240000
10.240000
10.24
    10.24
       10
```

### 占位符：%+

- `%+v`：若值为结构体，则输出将包括结构体的字段名。
- `%+q`：保证只输出ASCII编码的字符，非 ASCII 字符则以unicode编码表示

```
func main() {
    // 若值为结构体，则输出将包括结构体的字段名。
    var people = Profile{name:"wangbm", gender: "male", age:27}
    fmt.Printf("%v \n", people) // output: {name:wangbm gender:male age:27}
    fmt.Printf("%+v \n", people) // output: {name:wangbm gender:male age:27}

    // 保证只输出ASCII编码的字符
    fmt.Printf("%q \n", "golang")  // output: "golang"
    fmt.Printf("%+q \n", "golang")  // output: "golang"

    // 非 ASCII 字符则以unicode编码表示
    fmt.Printf("%q \n", "中文")  // output: "中文"
    fmt.Printf("%+q \n", "中文") // output: "\u4e2d\u6587"
}
```

输出如下

```
{wangbm male 27}
{name:wangbm gender:male age:27}

"golang"
"golang"

"中文"
"\u4e2d\u6587"
```



### 占位符：%

- `%#x`：给打印出来的是 16 进制字符串加前缀 `0x`
- `%#q`：用反引号包含，打印原始字符串
- `%#U`：若是可打印的字符，则将其打印出来
- `%#p`：若是打印指针的内存地址，则去掉前缀 0x

```
func main() {
    // 对于打印出来的是 16 进制，则加前缀 0x
    fmt.Printf("%x \n", "Hello, Golang")     // output: 48656c6c6f2c20476f6c616e67
    fmt.Printf("%#x \n", "Hello, Golang")     // output: 0x48656c6c6f2c20476f6c616e67

    // 用反引号包含，打印原始字符串
    fmt.Printf("%q \n", "Hello, Golang")     // output: "Hello, Golang"
    fmt.Printf("%#q \n", "Hello, Golang")     // output: `Hello, Golang`

    // 若是可打印的字符，则将其打印出来
    fmt.Printf("%U \n", '中')     // output: U+4E2D
    fmt.Printf("%#U \n", '中')     // output: U+4E2D '中'

    // 若是打印指针的内存地址，则去掉前缀 0x
    a := 1024
    fmt.Printf("%p \n", &a)  // output: 0xc0000160e0
    fmt.Printf("%#p \n", &a)  // output: c0000160e0
}
```

### 对齐补全

**字符串**

```
func main() {
    // 打印的值宽度为5，若不足5个字符，则在前面补空格凑足5个字符。
    fmt.Printf("a%5sc\n", "b")   // output: a    bc
    // 打印的值宽度为5，若不足5个字符，则在后面补空格凑足5个字符。
    fmt.Printf("a%-5sc\n", "b")  //output: ab    c

    // 不想用空格补全，还可以指定0，其他数值不可以，注意：只能在前边补全，后边补全无法指定字符
    fmt.Printf("a%05sc\n", "b") // output: a0000bc
     // 若超过5个字符，不会截断
    fmt.Printf("a%5sd\n", "bbbccc") // output: abbbcccd
}
```

输出如下

```
a    bc
ab    c
a0000bc
abbbcccd
```

**浮点数**

```
func main() {
    // 保证宽度为6（包含小数点)，2位小数，右对齐
    // 不足6位时，整数部分空格补全，小数部分补零，超过6位时，小数部分四舍五入
    fmt.Printf("%6.2f,%6.2f\n", 12.3, 123.4567)

    // 保证宽度为6（包含小数点)，2位小数，- 表示左对齐
    // 不足6位时，整数部分空格补全，小数部分补零，超过6位时，小数部分四舍五入
    fmt.Printf("%-6.2f,%-6.2f\n", 12.2, 123.4567)
}
```

输出如下

```
 12.30,123.46
12.20 ,123.46
```

### 正负号占位

如果是正数，则留一个空格，表示正数

如果是负数，则在此位置，用 `-` 表示

```
func main() {
    fmt.Printf("1% d3\n", 22)
    fmt.Printf("1% d3\n", -22)
}
```

输出如下

```
1 223
1-223
```

以上就是参考 [golang - fmt 文档](https://golang.org/pkg/fmt/) 整理而成的 fmt.Printf 的使用手册。



# 5.2 os/exec 执行命令的五种姿势

在 Golang 中用于执行命令的库是 `os/exec`，exec.Command 函数返回一个 `Cmd` 对象，根据不同的需求，可以将命令的执行分为三种情况

1. 只执行命令，不获取结果
2. 执行命令，并获取结果（不区分 stdout 和 stderr）
3. 执行命令，并获取结果（区分 stdout 和 stderr）

## 第一种：只执行命令，不获取结果

直接调用 Cmd 对象的 Run 函数，返回的只有成功和失败，获取不到任何输出的结果。

```
package main

import (
    "log"
    "os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/")
    err := cmd.Run()
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
}
```

## 第二种：执行命令，并获取结果

有时候我们执行一个命令就是想要获取输出结果，此时你可以调用 Cmd 的 CombinedOutput 函数。

```
package main

import (
"fmt"
"log"
"os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/")
    out, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Printf("combined out:\n%s\n", string(out))
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Printf("combined out:\n%s\n", string(out))
}
```

CombinedOutput 函数，只返回 out，并不区分 stdout 和 stderr。如果你想区分他们，可以直接看第三种方法。

```
$ go run demo.go
combined out:
total 11540876
-rw-r--r--  2 root       root         4096 Oct 29  2018 yum.log
drwx------  2 root       root           94 Nov  6 05:56 audit
-rw-r--r--  1 root       root    185249234 Nov 28  2019 message
-rw-r--r--  2 root       root        16374 Aug 28 10:13 boot.log
```

不过在那之前，我却发现一个小问题：有时候，shell 命令能执行，并不代码 exec 也能执行。

比如我只想查看 `/var/log/` 目录下的 log 后缀名的文件呢？有点 Linux 基础的同学，都会用这个命令

```
$ ls -l /var/log/*.log
total 11540
-rw-r--r--  2 root       root         4096 Oct 29  2018 /var/log/yum.log
-rw-r--r--  2 root       root        16374 Aug 28 10:13 /var/log/boot.log
```

按照这个写法将它放入到 `exec.Command`

```
package main

import (
"fmt"
"log"
"os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/*.log")
    out, err := cmd.CombinedOutput()
    if err != nil {
        fmt.Printf("combined out:\n%s\n", string(out))
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Printf("combined out:\n%s\n", string(out))
}
```

什么情况？居然不行，报错了。

```
$ go run demo.go
combined out:
ls: cannot access /var/log/*.log: No such file or directory

2020/11/11 19:46:00 cmd.Run() failed with exit status 2
exit status 1
```

为什么会报错呢？shell 明明没有问题啊

其实很简单，原来 `ls -l /var/log/*.log` 并不等价于下面这段代码。

```
exec.Command("ls", "-l", "/var/log/*.log")
```

上面这段代码对应的 Shell 命令应该是下面这样，如果你这样子写，ls 就会把参数里的内容当成具体的文件名，而忽略通配符 `*`

```
$ ls -l "/var/log/*.log"
ls: cannot access /var/log/*.log: No such file or directory
```

## 第三种：执行命令，并区分stdout 和 stderr

上面的写法，无法实现区分标准输出和标准错误，只要换成下面种写法，就可以实现。

```
package main

import (
    "bytes"
    "fmt"
    "log"
    "os/exec"
)

func main() {
    cmd := exec.Command("ls", "-l", "/var/log/*.log")
    var stdout, stderr bytes.Buffer
    cmd.Stdout = &stdout  // 标准输出
    cmd.Stderr = &stderr  // 标准错误
    err := cmd.Run()
    outStr, errStr := string(stdout.Bytes()), string(stderr.Bytes())
    fmt.Printf("out:\n%s\nerr:\n%s\n", outStr, errStr)
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
}
```

输出如下，可以看到前面的报错内容被归入到标准错误里

```
$ go run demo.go
out:

err:
ls: cannot access /var/log/*.log: No such file or directory

2020/11/11 19:59:31 cmd.Run() failed with exit status 2
exit status 1
```

## 第四种：多条命令组合，请使用管道

将上一条命令的执行输出结果，做为下一条命令的参数。在 Shell 中可以使用管道符 `|` 来实现。

比如下面这条命令，统计了 message 日志中 ERROR 日志的数量。

```
$ grep ERROR /var/log/messages | wc -l
19
```

类似的，在 Golang 中也有类似的实现。

```
package main
import (
    "os"
    "os/exec"
)
func main() {
    c1 := exec.Command("grep", "ERROR", "/var/log/messages")
    c2 := exec.Command("wc", "-l")
    c2.Stdin, _ = c1.StdoutPipe()
    c2.Stdout = os.Stdout
    _ = c2.Start()
    _ = c1.Run()
    _ = c2.Wait()
}
```

输出如下

```
$ go run demo.go
19
```

## 第五种：设置命令级别的环境变量

使用 os 库的 Setenv 函数来设置的环境变量，是作用于整个进程的生命周期的。

```
package main
import (
    "fmt"
    "log"
    "os"
    "os/exec"
)
func main() {
    os.Setenv("NAME", "wangbm")
    cmd := exec.Command("echo", os.ExpandEnv("$NAME"))
    out, err := cmd.CombinedOutput()
    if err != nil {
        log.Fatalf("cmd.Run() failed with %s\n", err)
    }
    fmt.Printf("%s", out)
}
```

只要在这个进程里，`NAME` 这个变量的值都会是 `wangbm`，无论你执行多少次命令

```
$ go run demo.go
wangbm
```

如果想把环境变量的作用范围再缩小到命令级别，也是有办法的。

为了方便验证，我新建个 sh 脚本，内容如下

```
$ cat /home/wangbm/demo.sh
echo $NAME
$ bash /home/wangbm/demo.sh   # 由于全局环境变量中没有 NAME，所以无输出
```

另外，demo.go 里的代码如下

```
package main
import (
    "fmt"
    "os"
    "os/exec"
)


func ChangeYourCmdEnvironment(cmd * exec.Cmd) error {
    env := os.Environ()
    cmdEnv := []string{}

    for _, e := range env {
        cmdEnv = append(cmdEnv, e)
    }
    cmdEnv = append(cmdEnv, "NAME=wangbm")
    cmd.Env = cmdEnv

    return nil
}

func main() {
    cmd1 := exec.Command("bash", "/home/wangbm/demo.sh")
  ChangeYourCmdEnvironment(cmd1) // 添加环境变量到 cmd1 命令: NAME=wangbm
    out1, _ := cmd1.CombinedOutput()
    fmt.Printf("output: %s", out1)

    cmd2 := exec.Command("bash", "/home/wangbm/demo.sh")
    out2, _ := cmd2.CombinedOutput()
    fmt.Printf("output: %s", out2)
}
```

执行后，可以看到第二次执行的命令，是没有输出 NAME 的变量值。

```
$ go run demo.go
output: wangbm
output:
```



# 5.3 命令行参数的解析：flag 库详解

在 Golang 程序中有很多种方法来处理命令行参数。

简单的情况下可以不使用任何库，直接使用 `os.Args`

```
package main

import (
    "fmt"
    "os"
)

func main() {
    //os.Args是一个[]string
    if len(os.Args) > 0 {
        for index, arg := range os.Args {
            fmt.Printf("args[%d]=%v\n", index, arg)
        }
    }
}
```

试着运行一下，第一个参数是执行文件的路径。

```
$ go run demo.go hello world hello golang
args[0]=/var/folders/72/lkr7ltfd27lcf36d75jdyjr40000gp/T/go-build187785213/b001/exe/demo
args[1]=hello
args[2]=world
args[3]=hello
args[4]=golang
```

从上面你可以看到，`os.Args` 只能处理简单的参数，而且对于参数的位置有严格的要求。对于一些比较复杂的场景，就需要你自己定义解析规则，非常麻烦。

如果真的遇上了所谓的复杂场景，那么还可以使用 Golang 的标准库 flag 包来处理命令行参数。

本文将介绍 Golang 标准库中 flag 包的用法。

## 1. 参数种类

根据参数是否为布尔型，可以分为两种：

- 布尔型参数：如 `--debug`，后面不用再接具体的值，指定就为 True，不指定就为 False非布尔型参数
- 非布尔型参数：非布尔型，有可能是int，string 等其他类型，如 `--name jack` ，后面可以接具体的参数值

根据参数名的长短，还可以分为：

- 长参数：比如 `--name jack` 就是一个长参数，参数名前有两个 `-`
- 短参数：通常为一个或两个字母（是对应长参数的简写），比如 `-n` ，参数名前只有一个 `-`

## 2. 入门示例

我先用一个字符串类型的参数的示例，抛砖引玉

```
package main

import (
    "flag"
    "fmt"
)

func main(){
    var name string
    flag.StringVar(&name, "name", "jack", "your name")

flag.Parse()  // 解析参数
    fmt.Println(name)
}
```

`flag.StringVar` 定义了一个字符串参数，它接收几个参数

- 第一个参数 ：接收值后，存放在哪个变量里，需为指针
- 第二个参数 ：在命令行中使用的参数名，比如 `--name jack` 里的 name
- 第三个参数 ：若命令行中未指定该参数值，那么默认值为 `jack`
- 第四个参数：记录这个参数的用途或意义

运行以上程序，输出如下

```
$ go run demo.go
jack

$ go run demo.go --name wangbm
wangbm
```

## 3. 改进一下

如果你的程序只接收很少的几个参数时，上面那样写也没有什么问题。

但一旦参数数量多了以后，一大堆参数解析的代码堆积在 main 函数里，影响代码的可读性、美观性。

建议将参数解析的代码放入 `init` 函数中，`init` 函数会先于 `main` 函数执行。

```
package main

import (
    "flag"
    "fmt"
)

var name string

func init()  {
    flag.StringVar(&name, "name", "jack", "your name")
}

func main(){
    flag.Parse()
    fmt.Println(name)
}
```

## 4. 参数类型

当你在命令行中指定了参数，Go 如何解析这个参数，转化成何种类型，是需要你事先定义的。

不同的参数，对应着 `flag` 中不同的方法。

下面分别讲讲不同的参数类型，都该如何定义。

### 布尔型

**实现效果**：当不指定 `--debug` 时，debug 的默认值为 false，你一指定 `--debug`，debug 为赋值为 true。

```
var debug bool

func init()  {
    flag.BoolVar(&debug, "debug", false, "是否开启 DEBUG 模式")
}

func main(){
    flag.Parse()
    fmt.Println(debug)
}
```

运行后，执行结果如下

```
$ go run main.go
false

$ go run main.go --debug
true
```

### 数值型

定义一个 age 参数，不指定默认为 18

```
var age int

func init()  {
    flag.IntVar(&age, "age", 18, "你的年龄")
}

func main(){
    flag.Parse()
    fmt.Println(age)
}
```

运行后，执行结果如下

```
$ go run main.go
18

$ go run main.go --age 20
20
```

`int64`、 `uint` 和 `float64` 类型分别对应 Int64Var 、 UintVar、Float64Var 方法，也是同理，不再赘述。

### 字符串

定义一个 name参数，不指定默认为 jack

```
var name string

func init()  {
    flag.StringVar(&name, "name", "jack", "你的名字")
}

func main(){
    flag.Parse()
    fmt.Println(name)
}
```

运行后，执行结果如下

```
$ go run main.go
jack

$ go run main.go --name wangbm
wangbm
```

### 时间类型

定义一个 interval 参数，不指定默认为 1s

```
var interval time.Duration

func init()  {
    flag.DurationVar(&interval, "interval", 1 * time.Second, "循环间隔")
}

func main(){
    flag.Parse()
    fmt.Println(interval)
}
```

验证效果如下

```
$ go run main.go
1s
$ go run main.go --interval 2s
2s
```

## 5. 自定义类型

flag 包支持的类型有 Bool、Duration、Float64、Int、Int64、String、Uint、Uint64。

这些类型的参数被封装到其对应的后端类型中，比如 Int 类型的参数被封装为 intValue，String 类型的参数被封装为 stringValue。

这些后端的类型都实现了 flag.Value 接口，因此可以把一个命令行参数抽象为一个 Flag 类型的实例。下面是 Value 接口和 Flag 类型的代码：

```
type Value interface {
    String() string
    Set(string) error
}

// Flag 类型
type Flag struct {
    Name     string // name as it appears on command line
    Usage    string // help message
    Value    Value  // value as set 是个 interface，因此可以是不同类型的实例。
    DefValue string // default value (as text); for usage message
}

func Var(value Value, name string, usage string) {
    CommandLine.Var(value, name, usage)
}
```

想要实现自定义类型的参数，其实只要 Var 函数的第一个参数对象实现 flag.Value接口即可

```
type sliceValue []string


func newSliceValue(vals []string, p *[]string) *sliceValue {
    *p = vals
    return (*sliceValue)(p)
}

func (s *sliceValue) Set(val string) error {
         // 如何解析参数值
    *s = sliceValue(strings.Split(val, ","))
    return nil
}

func (s *sliceValue) String() string {
    return strings.Join([]string(*s), ",")
}
```

比如我想实现如下效果，传入的参数是一个字符串，以逗号分隔，flag 的解析时将其转成 slice。

```
$ go run demo.go -members "Jack,Tom"
[Jack Tom]
```

那我可以这样子编写代码

```
var members []string
type sliceValue []string


func newSliceValue(vals []string, p *[]string) *sliceValue {
    *p = vals
    return (*sliceValue)(p)
}

func (s *sliceValue) Set(val string) error {
         // 如何解析参数值
    *s = sliceValue(strings.Split(val, ","))
    return nil
}


func (s *sliceValue) String() string {
    return strings.Join([]string(*s), ",")
}

func init()  {
    flag.Var(newSliceValue([]string{}, &members), "members", "会员列表")
}

func main(){
    flag.Parse()
    fmt.Println(members)
}
```

有的朋友 可能会对 `(*sliceValue)(p)` 这行代码有所疑问，这是什么意思呢？

## 6. 长短选项

flag 包，在使用上，其实并没有没有长短选项之别，你可以看下面这个例子

```
package main

import (
    "flag"
    "fmt"
)

var name string

func init()  {
    flag.StringVar(&name, "name", "明哥", "你的名字")
}

func main(){
    flag.Parse()
    fmt.Println(name)
}
```

通过指定如下几种参数形式

```
$ go run main.go
明哥
$ go run main.go --name jack
jack
$ go run main.go -name jack
jack
```

一个 `-` 和两个 `-` 执行结果是相同的。

那么再加一个呢？

终于报错了。说明最多只能指定两个 `-`

```
$ go run main.go ---name jack
bad flag syntax: ---name
Usage of /tmp/go-build245956022/b001/exe/main:
  -name string
        你的名字 (default "明哥")
exit status 2
```

## 7. 总结一下

flag 在绝大多数场景下，它是够用的，但如果要支持更多的命令传入格式，flag 可能并不是最好的选择。

那些在标准库不能解决的场景，往往会有相应的Go爱好者提供第三方解决方案。我所了解到的 cobra 就是一个非常不错的库。

它能够支持 flag 不能支持的功能，比如 **支持短选项**，**支持子命令** 等等，后面找个机会再好好写一下。

## flag 的函数

### Lookup

从众多数参数中查取出 members 的参数值

```
m := flag.Lookup("members")
```

# 6.1 Go 命令：go test 工具详解

接下来几篇文章，我将介绍 下 Golang 中有关测试相关的一些文章。

在学习如何编写测试代码之前，需要先了解一下Go 提供的测试工具 ：go test

go test 本身可以携带很多的参数，熟悉这些参数，可以让我们的测试过程更加方便。

下面就根据场景来解释一下常用的几个参数：

（由于下一节才会讲到如何编写测试代码，所以请好结合下一篇文章进行学习）

1、运行整个项目的测试文件

```
$ go test
PASS
ok      _/home/wangbm/golang/math   0.003s
```

2、只运行某个测试文件（ math_test.go， math.go 是一对，缺一不可，前后顺序可对调）

```
$ go test math_test.go math.go
ok      command-line-arguments  0.002s
```

3、加 `-v` 查看详细的结果

```
$ go test math_test.go math.go
=== RUN   TestAdd
    TestAdd: main_test.go:22: the result is ok
    TestAdd: main_test.go:22: the result is ok
    TestAdd: main_test.go:22: the result is ok
    TestAdd: main_test.go:22: the result is ok
    TestAdd: main_test.go:22: the result is ok
--- PASS: TestAdd (0.00s)
PASS
ok      command-line-arguments  0.003s
```

4、只测试某个函数，-run 支持正则，如下例子中 TestAdd，如果还有一个测试函数为 TestAdd02，那么它也会被运行。

```
$ go test -v -run="TestAdd"
=== RUN   TestAdd
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
--- PASS: TestAdd (0.00s)
PASS
ok      _/home/wangbm/golang/math   0.003s
```

5、生成 test 的二进制文件：加 `-c` 参数

```
$ go test -v -run="TestAdd" -c
$
$ ls -l
total 3208
-rw-r--r-- 1 root root      95 May 25 20:56 math.go
-rwxr-xr-x 1 root root 3272760 May 25 21:00 math.test
-rw-r--r-- 1 root root     525 May 25 20:56 math_test.go
```

6、执行这个 test 测试文件：加 `-o` 参数

```
$ go test -v -o math.test
=== RUN   TestAdd
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
--- PASS: TestAdd (0.00s)
=== RUN   TestAum
    TestAum: math_test.go:30: 6
--- PASS: TestAum (0.00s)
PASS
ok      _/home/wangbm/golang/math   0.002s
```

7、只测试安装/重新安装 依赖包，而不运行代码：加 `-i` 参数

```
# 这里没有输出
$ go test -i
```

# 6.2 单元测试：如何进行单元测试？

在计算机编程中，单元测试（英语：Unit Testing）又称为模块测试，是针对程序模块（软件设计的最小单位）来进行正确性检验的测试工作。

程序单元是应用的最小可测试部件，一般来说都是对某一个函数方法进行测试，以尽可能的保证没有问题或者问题可被我们预知。为了达到这个目的，我们可以使用各种手段、逻辑，模拟不同的场景进行测试。

那么我们如何在写 Golang 代码时，进行单元测试呢？

由于实在是太简单了，我这里直接上例子吧

## 1. 单元测试

准备两个 Go 文件

**math.go**

```
package math

func Add(x,y int) int {
    return x+y
}
```

**math_test.go**

```
package math

import "testing"

func TestAdd(t *testing.T) {
    t.Log(Add(1, 2))
}
```

然后使用 `go test` 工具去执行

```
$ go test .
ok      _/home/wangbm/golang/math   0.003s
```

从上面这个例子中，可以总结中几点 Go 语言测试框架要遵循的规则

1. 单元测试代码的 go文件必须以`_test.go`结尾，而前面最好是被测试的文件名（不过并不是强制的），比如要测试 math.go 测试文件名就为 math_test.go
2. 单元测试的函数名必须以`Test`开头，后面直接跟要测试的函数名，比如要测试 Add函数，单元测试的函数名就得是 TestAdd
3. 单元测试的函数必须接收一个指向`testing.T`类型的指针，并且不能返回任何值。

## 2. 表组测试

Add(1, 2) 是一次单元测试的场景，而 Add(2, 4) ，Add(3, 6) 又是另外两种单元测试的场景。

对于多种输入场景的测试，我们可以同时放在 TestAdd 里进行测试，这种测试方法就是表组测试。

修改 **math_test.go** 如下

```
package math

import "testing"

func TestAdd(t *testing.T) {
    sum:=Add(1,2)
    if sum == 3 {
        t.Log("the result is ok")
    } else {
        t.Fatal("the result is wrong")
    }

    sum=Add(2,4)
    if sum == 6 {
        t.Log("the result is ok")
    } else {
        t.Fatal("the result is wrong")
    }
}
```

执行 `go test`

```
$ go test . -v
=== RUN   TestAdd
    TestAdd: math_test.go:8: the result is ok
    TestAdd: math_test.go:15: the result is ok
--- PASS: TestAdd (0.00s)
PASS
ok      _/home/wangbm/golang/math   0.003s
```

稍微如果输入的场景实在太多（比如下面用的五组输入），用上面的方法，可能需要写很多重复的代码，这时候可以利用 **表格测试法**

```
package math

import "testing"

type TestTable struct {
    xarg int
    yarg int
}

func TestAdd(t *testing.T){
    tables := []TestTable{
        {1,2},
        {2,4},
        {4,8},
        {5,10},
        {6,12},
    }

    for _, table := range tables{
        result := Add(table.xarg, table.yarg)
        if result == (table.xarg + table.yarg){
            t.Log("the result is ok")
        } else {
            t.Fatal("the result is wrong")
        }
    }
}
```

执行 `go test`

```
$ go test . -v
=== RUN   TestAdd
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
    TestAdd: math_test.go:22: the result is ok
--- PASS: TestAdd (0.00s)
PASS
ok      _/home/wangbm/golang/math   0.002s
```

# 6.3 调试技巧：使用 GDB 调试 Go 程序

做为新手，熟练掌握一个好的调试工具，对于我们学习语言或者排查问题的时候，非常有帮助。

你如果使用 VS Code 或者 Goland ，可以直接上手，我就不再写这方面的文章了。

其实相比有用户界面的 IDE 调试工具，我更喜欢简单直接的命令行调试，原因有三点：

1. 速度快，个人感觉在 Windows 下速度巨慢
2. 依赖少，在 Linux 服务器上 也能轻松调试
3. 指令简单，我习惯只使用快捷键就能操作

如果你有和我一样的感受和习惯，可以看下今天的文章，介绍的是 GDB 调试工具。

## 1. 下载安装 Go

在 Linux 上进行调试，那咱所以得先安装 Go ，由于第一节里只讲了 Windows 的下载安装，并没有讲到在 Linux 上如何安装。所以这里要先讲一下，已经安装过了可以直接跳过。

首先在 go 下载页面上（https://golang.org/dl/），查看并复制源码包的的下载地址

![image1](http://image.iswbm.com/20200428180632.png)

登陆 linux 机器 ，使用 wget 下载

```
$ wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
```

![image2](http://image.iswbm.com/20200428180713.png)

将下载的源码包解压到 `/usr/local` 目录下，并设置环境变量

```
[root@localhost ~]# tar -C /usr/local -xzf go1.14.2.linux-amd64.tar.gz
[root@localhost ~]#
[root@localhost ~]# export PATH=$PATH:/usr/local/go/bin
[root@localhost ~]# which go
/usr/local/go/bin/go
[root@localhost ~]#
[root@localhost ~]# go version
go version go1.14.2 linux/amd64
[root@localhost ~]#
```

## 2. 开始进行调试

调试使用的是 GDB （好像要求版本 7.1 + ），使用前，请先确保你的机器上已经安装 GDB

```
[root@localhost code]# which gdb
/usr/bin/gdb
```

准备就绪后，先在目录下写一个测试文件

```
package main

import "fmt"

func main(){
  msg := "hello, world"
  fmt.Println(msg)
}
```

然后执行 如下命令进行编译，里面有好多个参数，有疑问的可以自行搜索引擎

```
# 关闭内联优化，方便调试
$ go build -gcflags "-N -l" demo.go

# 发布版本删除调试符号
go build -ldflags “-s -w”
```

最后使用 GDB 命令进入调试界面

```
# 如果你喜欢这种界面的话，用这条命令
$ gdb -tui demo

# 如果你跟我一样不喜欢不习惯用界面，就使用这个命令
$ gdb demo
```

完整操作如下：

![image3](http://image.iswbm.com/20200428181902.png)

进入 GDB 调试界面后，并不是立即可用，你先需要回车，然后再你敲入几行命令，调试窗口就会出现代码。

```
(gdb) b main.main   # 在 main 包里的 main 函数 加断点
Breakpoint 1 at 0x4915c0: file /home/wangbm/code/demo.go, line 5.
(gdb) run  # 执行进程
Starting program: /home/wangbm/code/demo
Breakpoint 1, main.main () at /home/wangbm/code/demo.go:5
(gdb)
```

![image4](http://image.iswbm.com/20200428182620.png)

## 3. 详解调试指令

要熟练使用 GDB ，你得熟悉的掌握它的指令，这里列举一下

- `r`：run，执行程序
- `n`：next，下一步，不进入函数
- `s`：step，下一步，会进入函数
- `b`：breakponit，设置断点
- `l`：list，查看源码
- `c`：continue，继续执行到下一断点
- `bt`：backtrace，查看当前调用栈
- `p`：print，打印查看变量
- `q`：quit，退出 GDB
- `whatis`：查看对象类型
- `info breakpoints`：查看所有的断点
- `info locals`：查看局部变量
- `info args`：查看函数的参数值及要返回的变量值
- `info frame`：堆栈帧信息
- `info goroutines`：查看 goroutines 信息。在使用前 ，需要注意先执行 source /usr/local/go/src/runtime/runtime-gdb.py
- `goroutine 1 bt`：查看指定序号的 goroutine 调用堆栈
- 回车：重复执行上一次操作

其中有几个指令的使用比较灵活

比如 l - list，查看代码

```
# 查看指定行数上下5行
(gdb) l 8

# 查看指定范围的行数
(gdb) l 5:8

# 查看指定文件的行数上下5行
l demo.go:8

# 可以查看函数，记得加包名
l main.main
```

把上面的 `l` 换成 `b` ，大多数也同样适用

```
# 在指定行打断点
(gdb) b 8


# 在指定指定文件的行打断点
b demo.go:8

# 在指定函数打断点，记得加包名
b main.main
```

还有 p - print，打印变量

```
# 查看变量
(gdb) p var

# 查看对象长度或容量
(gdb) p $len(var)
(gdb) p $cap(var)

# 查看对象的动态类型
(gdb) p $dtype(var)
(gdb) iface var

# 举例如下
(gdb) p i
$4 = {str = "cbb"}
(gdb) whatis i
type = regexp.input
(gdb) p $dtype(i)
$26 = (struct regexp.inputBytes *) 0xf8400b4930
(gdb) iface i
regexp.input: struct regexp.inputBytes *
```

以上就是关于 GDB 的使用方法，非常简单，可以自己手动敲下体验一下。

# 6.4 Go 命令： Go 命令指南

## 1. 基本命令

查看版本

```
$ go version
go version go1.14 darwin/amd64
```

查看环境变量

```
$ go env
```

![仅截取部分内容](http://image.iswbm.com/image-20200311221418584.png)

仅截取部分内容

设置环境变量

```
$ go env -w GOPATH=/usr/loca
```

## 2. 执行 Go 程序

当前热门的编程语言 Python ，可以不用编译成 二进制文件，就可以直接运行。

但 Go 语言程序的执行，必须得先编译再执行。通常来说有如下两种方法

1. 先使用 go build 编译成二进制文件，再执行这个二进制文件

   ![image1](http://image.iswbm.com/image-20200313222620374.png)

2. 使用 go run “直接”运行，这个命令还是会去编译，但是不会在当前目录下生成二进制文件，而是编译成临时文件后直接运行。

   ![image2](http://image.iswbm.com/image-20200313222710998.png)

## 3. 编译文件

将 `.go` 文件编译成可执行文件，可以使用 `go build`

如下图所示，helloworld 文件夹下，包含两个 `.go` 文件，它们都归属于同一个包。

当使用 `go build` 可指定包里所有的文件，就你下面这样，默认会以第一个文件（main.go）名生成可执行文件（main）。

![image3](http://image.iswbm.com/image-20200312201759541.png)

当然，你也可以不指定，此时生成的可执行文件是以 文件夹名命名

![image4](http://image.iswbm.com/image-20200312202032363.png)

当然你也可以手动指定这个可执行文件名

![image5](http://image.iswbm.com/image-20200312202520902.png)

以上是编译单个文件，当然也可以编译多个文件

## 4. 清除编译文件

使用 go install 或 go install 有可能会生成很多的文件，如可执行文件，归档文件等，它们的后缀名非常多，有 `.exe`， `.a`， `.test`，`.o`，`.so`，`.5` ，`.6`，`.8`，如果要手动一个一个去清理他们，可以说是相当麻烦的，这里你可以通过使用 `go clean` 一键清理。

![image6](http://image.iswbm.com/image-20200313224148510.png)

实际开发中`go clean`命令使用的可能不是很多，一般都是利用`go clean`命令清除编译文件，然后再将源码递交到 github 上，方便对于源码的管理。

go clean 有不少的参数：

- `-i`：清除关联的安装的包和可运行文件，也就是通过`go install`安装的文件；
- `-n`： 把需要执行的清除命令打印出来，但是不执行，这样就可以很容易的知道底层是如何运行的；
- `-r`： 循环的清除在 import 中引入的包；
- `-x`： 打印出来执行的详细命令，其实就是 -n 打印的执行版本；
- `-cache`： 删除所有`go build`命令的缓存
- `-testcache`： 删除当前包所有的测试结果

## 4. 下载代码包

在 Golang 中，除了可以从官方网站（golang.org）下载包之外，还可以从一些代码仓库中下载，诸如 github.com，bitbucket.org 这样的代码托管网站。

`go get` 这条命令，你以后会最经常用到，它可以借助代码管理工具通过远程拉取或更新代码包及其依赖包，并自动完成编译和安装。整个过程就像安装一个 App 一样简单。

这个命令可以动态获取远程代码包，目前支持的有 BitBucket、GitHub、Google Code 和 Launchpad。在使用 go get 命令前，需要安装与远程包匹配的代码管理工具，如 Git、SVN等。

`go get` 会根据域名的不同，使用不同的工具去拉取代码包，具体可参考下图

![image-20200312203244402](http://image.iswbm.com/image-20200312203244402.png)

image-20200312203244402

下载和安装，原本是两个动作，但使用 `go get` 后，它默认会将下载（源码包）和安装（go install）合并起来，当然你也可以通过参数指定将拆散它们。

在终端执行 `go help get`，会弹出 `go get` 的帮助文档，我这里汉化总结一下，来帮助大家学习。

```
go get [-d] [-f] [-t] [-u] [-v] [-fix] [-insecure] [build flags] [packages]
```

其中几个参数详解如下

- `-u`：

  用于下载指定的路径包及其依赖包，默认情况下，不会下载本地已经存在的，只会下载本地不存在的代码包。就是口中常说的更新包 比如：go get -u github.com/jinzhu/gorm。会把最新的 gorm 包下载到你本地

- `-d`：

  让命令程序只执行下载动作，而不执行安装动作。

- `-t`

  让命令程序同时下载并安装指定的代码包中的测试源码文件中依赖的代码包

- `-fix`

  命令程序在下载代码包后先执行修正动作，而后再进行编译和安装。比如，我的代码是用1.7 开发的，现在go 版本已经是1.13 了，有些包已经发生了变化，那么我们在使用go get命令的时候可以加入-fix标记。这个标记的作用是在检出代码包之后，先对该代码包中不符合Go语言1.7版本的语言规范的语法进行修正，然后再下载它的依赖包，最后再对它们进行编译和安装。

- `-v`

  打印出那些下载的代码包的名字

- `-f`

  仅在使用-u标记时才有效。该标记会让命令程序忽略掉对已下载代码包的导入路径的检查。如果下载并安装的代码包所属的项目是你从别人那里Fork过来的，那么这样做就尤为重要了

- `-x`

  打印出整个过程使用了哪些命令

- `-insecure` 允许命令程序使用非安全的scheme（如HTTP）去下载指定的代码包。如果你用的代码仓库（如公司内部的Gitlab）没有HTTPS支持，可以添加此标记。请在确定安全的情况下使用它。（记得 使用工具 git 时，有个版本就是 http 升级为了https）

参数有点多，咱一个一个来。

指定 `-d`，只下载源码包而不进行安装

![image7](http://image.iswbm.com/image-20200312204335687.png)

由于此时，我们已经下载了 logging 包，当你再次执行 go get 时，并不会重复下载，只有当你指定 `-u` 时，不管你需不需要更新，都会触发重新下载强制更新。

![image8](http://image.iswbm.com/image-20200312204746007.png)

如果你想看，下载这个过程用到了哪几个命令，可以指定 `-x` 参数

![image9](http://image.iswbm.com/image-20200312205001161.png)

最后，你可能想说，为什么 golang 里的包含这么长，好难记呀，其实这个路径是有讲究的

![image10](http://image.iswbm.com/image-20200312210557326.png)

这样不同的人开发的包即使使用同一个名，也不会冲突了。

下载的包，可能有不同的版本，如何指定版本下载呢？

```
# 拉取最新
go get github.com/foo

# 最新的次要版本或者修订版本(x.y.z, z是修订版本号， y是次要版本号)
go get -u github.com/foo

# 升级到最新的修订版本
go get -u=patch github.com/foo

# 指定版本，若存在tag，则代行使用
go get github.com/foo@v1.2.3

# 指定分支
go get github.com/foo@master

# 指定git提交的hash值
go get github.com/foo@e3702bed2
```

## 6. 安装代码包

`go install` 这个命令，如果你安装的是一个可执行文件（包名是 main），它会生成可执行文件到 bin 目录下。这点和 `go build` 很相似，不同的是，`go build` 编译生成的可执行文件放在当前目录，而 `go install` 会将可执行文件统一放至 `$GOPATH/bin` 目录下。

![image11](http://image.iswbm.com/image-20200312221011685.png)

如果你安装的是一个库，它会将这个库安装到 pkg 目录下，生成 `.a` 为后缀的文件。

![image12](http://image.iswbm.com/image-20200312221141028.png)

## 7. 格式化 go 文件

Go语言的开发团队制定了统一的官方代码风格，并且推出了 gofmt 工具（gofmt 或 go fmt）来帮助开发者格式化他们的代码到统一的风格。

gofmt 是一个 cli 程序，会优先读取标准输入，如果传入了文件路径的话，会格式化这个文件，如果传入一个目录，会格式化目录中所有 .go 文件，如果不传参数，会格式化当前目录下的所有 .go 文件。

http://c.biancheng.net/view/4441.html

## 参考文章

https://studygolang.com/articles/25658

https://juejin.im/post/5d0b865c6fb9a07f050a6f45

# 7.2 Go 语言中边界检查

## 1. 什么是边界检查？

边界检查，英文名 `Bounds Check Elimination`，简称为 BCE。它是 Go 语言中防止数组、切片越界而导致内存不安全的检查手段。如果检查下标已经越界了，就会产生 Panic。

边界检查使得我们的代码能够安全地运行，但是另一方面，也使得我们的代码运行效率略微降低。

比如下面这段代码，会进行三次的边界检查

```
package main

func f(s []int) {
    _ = s[0]  // 检查第一次
    _ = s[1]  // 检查第二次
    _ = s[2]  // 检查第三次
}

func main() {}
```

你可能会好奇了，三次？我是怎么知道它要检查三次的。

实际上，你只要在编译的时候，加上参数即可，命令如下

```
$ go build -gcflags="-d=ssa/check_bce/debug=1" main.go
# command-line-arguments
./main.go:4:7: Found IsInBounds
./main.go:5:7: Found IsInBounds
./main.go:6:7: Found IsInBounds
```

## 2. 边界检查的条件？

并不是所有的对数组、切片进行索引操作都需要边界检查。

比如下面这个示例，就不需要进行边界检查，因为编译器根据上下文已经得知，`s` 这个切片的长度是多少，你的终止索引是多少，立马就能判断到底有没有越界，因此是不需要再进行边界检查，因为在编译的时候就已经知道这个地方会不会 panic。

```
package main

func f() {
    s := []int{1,2,3,4}
    _ = s[:9]  // 不需要边界检查
}
func main()  {}
```

因此可以得出结论，对于在编译阶段无法判断是否会越界的索引操作才会需要边界检查，比如这样子

```
package main


func f(s []int) {
    _ = s[:9]  // 需要边界检查
}
func main()  {}
```

## 3. 边界检查的特殊案例

### 3.1 案例一

在如下示例代码中，由于索引 2 在最前面已经检查过会不会越界，因此聪明的编译器可以推断出后面的索引 0 和 1 不用再检查啦

```
 package main

func f(s []int) {
    _ = s[2] // 检查一次
    _ = s[1]  // 不会检查
    _ = s[0]  // 不会检查
}

func main() {}
```

### 3.2 案例二

在下面这个示例中，可以在逻辑上保证不会越界的代码，同样是不会进行越界检查的。

```
package main

func f(s []int) {
    for index, _ := range s {
        _ = s[index]
        _ = s[:index+1]
        _ = s[index:len(s)]
    }
}

func main()  {}
```

### 3.3 案例三

在如下示例代码中，虽然数组的长度和容量可以确定，但是索引是通过 `rand.Intn()` 函数取得的随机数，在编译器看来这个索引值是不确定的，它有可能大于数组的长度，也有可能小于数组的长度。

因此第一次是需要进行检查的，有了第一次检查后，第二次索引从逻辑上就能推断，所以不会再进行边界检查。

```
package main

import (
    "math/rand"
)

func f()  {
    s := make([]int, 3, 3)
    index := rand.Intn(3)
     _ = s[:index]  // 第一次检查
    _ = s[index:]  // 不会检查
}

func main()  {}
```

但如果把上面的代码稍微改一下，让切片的长度和容量变得不一样，结果又会变得不一样了。

```
package main

import (
    "math/rand"
)

func f()  {
    s := make([]int, 3, 5)
    index := rand.Intn(3)
     _ = s[:index]  // 第一次检查
    _ = s[index:]  // 第二次检查
}

func main()  {}
```

我们只有当数组的长度和容量相等时， `:index` 成立，才能一定能推出 `index:` 也成立，这样的话，只要做一次检查即可

一旦数组的长度和容量不相等，那么 index 在编译器看来是有可能大于数组长度的，甚至大于数组的容量。

我们假设 index 取得的随机数为 4，那么它大于数组长度，此时 `s[:index]` 虽然可以成功，但是 `s[index:]` 是要失败的，因此第二次边界的检查是有必要的。

你可能会说， index 不是最大值为 3 吗？怎么可能是 4呢？

要知道编译器在编译的时候，并不知道 index 的最大值是 3 呢。

**小结一下**

1. 当数组的长度和容量相等时，`s[:index]` 成立能够保证 `s[index:]` 也成立，因为只要检查一次即可
2. 当数组的长度和容量不等时，`s[:index]` 成立不能保证 `s[index:]` 也成立，因为要检查两次才可以

### 3.4 案例四

有了上面的铺垫，再来看下面这个示例，由于数组是调用者传入的参数，所以编译器的编译的时候无法得知数组的长度和容量是否相等，因此只能保险一点，两个都检查。

```
package main

import (
    "math/rand"
)

func f(s []int, index int) {
    _ = s[:index] // 第一次检查
    _ = s[index:] // 第二次检查
}

func main()  {}
```

但是如果把两个表达式的顺序反过来，就只要做一次检查就行了，原因我就不赘述了。

```
package main

import (
    "math/rand"
)

func f(s []int, index int) {
    _ = s[index:] // 第一次检查
    _ = s[:index] // 不用检查
}

func main()  {}
```

## 5. 主动消除边界检查

虽然编译器已经非常努力去消除一些应该消除的边界检查，但难免会有一些遗漏。

这就需要“警民合作”，对于那些编译器还未考虑到的场景，但开发者又极力追求程序的运行效率的，可以使用一些小技巧给出一些暗示，告诉编译器哪些地方可以不用做边界检查。

比如下面这个示例，从代码的逻辑上来说，是完全没有必要做边界检查的，但是编译器并没有那么智能，实际上每个for循环，它都要做一次边界的检查，非常的浪费性能。

```
package main


func f(is []int, bs []byte) {
    if len(is) >= 256 {
        for _, n := range bs {
            _ = is[n] // 每个循环都要边界检查
        }
    }
}
func main()  {}
```

可以试着在 for 循环前加上这么一句 `is = is[:256]` 来告诉编译器新 is 的长度为 256，最大索引值为 255，不会超过 byte 的最大值，因为 `is[n]` 从逻辑上来说是一定不会越界的。

```
package main


func f(is []int, bs []byte) {
    if len(is) >= 256 {
        is = is[:256]
        for _, n := range bs {
            _ = is[n] // 不需要做边界检查
        }
    }
}
func main()  {}
```







## 并发

Go 语言支持并发，我们只需要通过 go 关键字来开启 goroutine 即可。

goroutine 是轻量级线程，goroutine 的调度是由 Golang 运行时进行管理的。

goroutine 语法格式：

```go
go 函数名( 参数列表 )
```

例如：

```go
go f(x, y, z)
```

开启一个新的 goroutine:

```go
f(x, y, z)
```

Go 允许使用 go 语句开启一个新的运行期线程， 即 goroutine，以一个不同的、新创建的 goroutine 来执行一个函数。 同一个程序中的所有 goroutine 共享同一个地址空间。


```go
**package** main

 **import** (
     "fmt"
     "time"
 )

 func say(s string) {
     **for** i := 0; i < 5; i++ {
         time.Sleep(100 * time.Millisecond)
         fmt.Println(s)
     }
 }

 func main() {
     **go** say("world")
     say("hello")
 }
```


执行以上代码，你会看到输出的 hello 和 world 是没有固定先后顺序。因为它们是两个 goroutine 在执行：

```
world
hello
hello
world
world
hello
hello
world
world
hello
```

## 通道（channel）

通道（channel）是用来传递数据的一个数据结构。

通道可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。操作符 `<-` 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

```go
ch <- v    // 把 v 发送到通道 ch
v := <-ch  // 从 ch 接收数据
           // 并把值赋给 v
```

声明一个通道很简单，我们使用chan关键字即可，通道在使用前必须先创建：

```go
ch := make(chan int)
```

**注意**：默认情况下，通道是不带缓冲区的。发送端发送数据，同时必须有接收端相应的接收数据。

以下实例通过两个 goroutine 来计算数字之和，在 goroutine 完成计算后，它会计算两个结果的和：

```go
**package** main

 **import** "fmt"

 func sum(s []int, c chan int) {
     sum := 0
     **for** _, v := **range** s {
         sum += v
     }
     c <- sum *// 把 sum 发送到通道 c*
 }

 func main() {
     s := []int{7, 2, 8, -9, 4, 0}
     c := make(chan int)
 **go** sum(s[:len(s)/2], c)
 **go** sum(s[len(s)/2:], c)
 x, y := <-c, <-c *// 从通道 c 中接收*
 
 fmt.Println(x, y, x+y)
      }
```

输出结果为：

```
-5 17 12
```

### 通道缓冲区

通道可以设置缓冲区，通过 make 的第二个参数指定缓冲区大小：

```go
ch := make(chan int, 100)
```

带缓冲区的通道允许发送端的数据发送和接收端的数据获取处于异步状态，就是说发送端发送的数据可以放在缓冲区里面，可以等待接收端去获取数据，而不是立刻需要接收端去获取数据。

不过由于缓冲区的大小是有限的，所以还是必须有接收端来接收数据的，否则缓冲区一满，数据发送端就无法再发送数据了。

**注意**：如果通道不带缓冲，发送方会阻塞直到接收方从通道中接收了值。如果通道带缓冲，发送方则会阻塞直到发送的值被拷贝到缓冲区内；如果缓冲区已满，则意味着需要等待直到某个接收方获取到一个值。接收方在有值可以接收之前会一直阻塞。


```go
**package** main

 **import** "fmt"

 func main() {
   *// 这里我们定义了一个可以存储整数类型的带缓冲通道*
     *// 缓冲区大小为2*
     ch := make(chan int, 2)
      *// 因为 ch 是带缓冲的通道，我们可以同时发送两个数据*
 *// 而不用立刻需要去同步读取数据*
 ch <- 1
 ch <- 2
 
 *// 获取这两个数据*
 fmt.Println(<-ch)
 fmt.Println(<-ch)
  }   
```
执行输出结果为：

```
1
2
```

### Go 遍历通道与关闭通道

Go 通过 range 关键字来实现遍历读取到的数据，类似于与数组或切片。格式如下：

```go
v, ok := <-ch
```

如果通道接收不到数据后 ok 就为 false，这时通道就可以使用 close() 函数来关闭。

```go
package main
import (
    "fmt"
)

func fibonacci(n int, c chan int) {
    x, y := 0, 1
    for i := 0; i < n; i++ {
        c <- x
        x, y = y, x+y
    }
    close(c)
}

func main() {
    c := make(chan int, 10)
    go fibonacci(cap(c), c)
    // range 函数遍历每个从通道接收到的数据，因为 c 在发送完 10 个*
    // 数据之后就关闭了通道，所以这里我们 range 函数在接收到 10 个数据*
    // 之后就结束了。如果上面的 c 通道不关闭，那么 range 函数就不*
    // 会结束，从而在接收第 11 个数据的时候就阻塞了。*
    for i := range c {
        fmt.Println(i)
    }
}
```



执行输出结果为：

```
0
1
1
2
3
5
8
13
21
34
```



==========================================			

## 标准库

在 Windows 下，标准库的位置在Go语言根目录下的子目录 pkg\windows_amd64 中；在 [Linux](http://c.biancheng.net/linux_tutorial/) 下，标准库在Go语言根目录下的子目录 pkg\linux_amd64 中（如果是安装的是 32 位，则在 linux_386 目录中）。一般情况下，标准包会存放在 $GOROOT/pkg/$GOOS_$GOARCH/ 目录下。

| Go语言标准库包名 | 功  能                                                       |
| ---------------- | ------------------------------------------------------------ |
| bufio            | 带缓冲的 I/O 操作                                            |
| bytes            | 实现字节操作                                                 |
| container        | 封装堆、列表和环形列表等容器                                 |
| crypto           | 加密算法                                                     |
| database         | 数据库驱动和接口                                             |
| debug            | 各种调试文件格式访问及调试功能                               |
| encoding         | 常见算法如 JSON、XML、Base64 等                              |
| flag             | 命令行解析                                                   |
| fmt              | 格式化操作                                                   |
| go               | Go语言的词法、语法树、类型等。可通过这个包进行代码信息提取和修改 |
| html             | HTML 转义及模板系统                                          |
| image            | 常见图形格式的访问及生成                                     |
| io               | 实现 I/O 原始访问接口及访问封装                              |
| math             | 数学库                                                       |
| net              | 网络库，支持 Socket、HTTP、邮件、RPC、SMTP 等                |
| os               | 操作系统平台不依赖平台操作封装                               |
| path             | 兼容各操作系统的路径操作实用函数                             |
| plugin           | Go 1.7 加入的插件系统。支持将代码编译为插件，按需加载        |
| reflect          | 语言反射支持。可以动态获得代码中的类型信息，获取和修改变量的值 |
| regexp           | 正则表达式封装                                               |
| runtime          | 运行时接口                                                   |
| sort             | 排序接口                                                     |
| strings          | 字符串转换、解析及实用函数                                   |
| time             | 时间接口                                                     |
| text             | 文本模板及 Token 词法器                                      |

## 代码风格

1）去掉循环冗余括号

```c
// C语言的for数值循环
for(int a = 0;a<10;a++){    
	// 循环代码
}
```

在Go语言中，这样的循环变为：

```go
for a := 0;a<10;a++{
	// 循环代码
}
```

for 两边的括号被去掉，int 声明被简化为`:=`，直接通过编译器右值推导获得 a 的变量类型并声明。

2) 去掉表达式冗余括号

```c
// C
if (表达式){
	// 表达式成立
}
```

```go
// Go
if 表达式{
	// 表达式成立
}
```

3) 强制的代码风格

左括号必须紧接着语句不换行。

4) 不再纠结于 i++ 和 ++i

在Go语言中，自增操作符不再是一个操作符，而是一个语句。只有一种写法：

i++

## 编译过程

### 预备知识

#### 1) 抽象语法树

在计算机科学中，抽象语法树（Abstract Syntax Tree，AST），或简称语法树（Syntax tree），是源代码语法结构的一种抽象表示。它以树状的形式表现编程语言的语法结构，树上的每个节点都表示源代码中的一种结构。

 之所以说语法是“抽象”的，是因为这里的语法并不会表示出真实语法中出现的每个细节。比如，嵌套括号被隐含在树的结构中，并没有以节点的形式呈现。而类似于 if else 这样的条件判断语句，可以使用带有两个分支的节点来表示。

 以算术表达式 1+3*(4-1)+2 为例，可以解析出的抽象语法树如下图所示：



![抽象语法树](../../Image\4-191115094600340.gif)
 抽象语法树可以应用在很多领域，比如浏览器，智能编辑器，编译器。

#### 2) 静态单赋值

在编译器设计中，静态单赋值形式（static single assignment form，通常简写为 SSA form 或是  SSA）是中介码（IR，intermediate  representation）的属性，它要求每个变量只分配一次，并且变量需要在使用之前定义。在实践中我们通常会用添加下标的方式实现每个变量只能被赋值一次的特性，这里以下面的代码举一个简单的例子：

x := 1
x := 2
y := x

从上面的描述所知，第一行赋值行为是不需要的，因为 x 在第二行被二度赋值并在第三行被使用，在 SSA 下，将会变成下列的形式：

x1 := 1
x2 := 2
y1 := x2

从使用 SSA 的中间代码我们就可以非常清晰地看出变量 y1 的值和 x1 是完全没有任何关系的，所以在机器码生成时其实就可以省略第一步，这样就能减少需要执行的指令来优化这一段代码。

在中间代码中使用 SSA 的特性能够为整个程序实现以下的优化：

- 常数传播（constant propagation）
- 值域传播（value range propagation）
- 稀疏有条件的常数传播（sparse conditional constant propagation）
- 消除无用的程式码（dead code elimination）
- 全域数值编号（global value numbering）
- 消除部分的冗余（partial redundancy elimination）
- 强度折减（strength reduction）
- 寄存器分配（register allocation）


 因为 SSA 的作用的主要作用就是代码的优化，所以是编译器后端（主要负责目标代码的优化和生成）的一部分。当然，除了 SSA 之外代码编译领域还有非常多的中间代码优化方法。

#### 3) 指令集架构

最后要介绍的一个预备知识就是指令集架构了，指令集架构（Instruction Set Architecture，简称  ISA），又称指令集或指令集体系，是计算机体系结构中与程序设计有关的部分，包含了基本数据类型，指令集，寄存器，寻址模式，存储体系，中断，异常处理以及外部 I/O。指令集架构包含一系列的 opcode 即操作码（机器语言），以及由特定处理器执行的基本命令。

 指令集架构常见种类如下：

- 复杂指令集运算（Complex Instruction Set Computing，简称 CISC）；
- 精简指令集运算（Reduced Instruction Set Computing，简称 RISC）；
- 显式并行指令集运算（Explicitly Parallel Instruction Computing，简称 EPIC）；
- 超长指令字指令集运算（VLIW）。


 不同的处理器（CPU）使用了大不相同的机器语言，所以我们的程序想要在不同的机器上运行，就需要将源代码根据架构编译成不同的机器语言。

### 编译原理

Go语言编译器的源代码在 cmd/compile  目录中，目录下的文件共同构成了Go语言的编译器，学过编译原理的人可能听说过编译器的前端和后端，编译器的前端一般承担着词法分析、语法分析、类型检查和中间代码生成几部分工作，而编译器后端主要负责目标代码的生成和优化，也就是将中间代码翻译成目标机器能够运行的机器码。



![img](../../Image\4-19111511533W48.gif)


 Go的编译器在逻辑上可以被分成四个阶段：词法与语法分析、类型检查和 AST 转换、通用 SSA 生成和最后的机器代码生成，下面我们来分别介绍一下这四个阶段做的工作。

#### 1) 词法与语法分析

所有的编译过程其实都是从解析代码的源文件开始的，词法分析的作用就是解析源代码文件，它将文件中的字符串序列转换成 Token 序列，方便后面的处理和解析，我们一般会把执行词法分析的程序称为词法解析器（lexer）。

 而语法分析的输入就是词法分析器输出的 Token 序列，这些序列会按照顺序被语法分析器进行解析，语法的解析过程就是将词法分析生成的 Token  按照语言定义好的文法（Grammar）自下而上或者自上而下的进行规约，每一个 Go 的源代码文件最终会被归纳成一个 SourceFile 结构：

SourceFile = PackageClause ";" { ImportDecl ";" } { TopLevelDecl ";" }

标准的 [Golang](http://c.biancheng.net/golang/) 语法解析器使用的就是 LALR(1) 的文法，语法解析的结果其实就是上面介绍过的抽象语法树（AST），每一个 AST 都对应着一个单独的Go语言文件，这个抽象语法树中包括当前文件属于的包名、定义的常量、结构体和函数等。

 如果在语法解析的过程中发生了任何语法错误，都会被语法解析器发现并将消息打印到标准输出上，整个编译过程也会随着错误的出现而被中止。

#### 2) 类型检查

当拿到一组文件的抽象语法树 AST 之后，Go语言的编译器会对语法树中定义和使用的类型进行检查，类型检查分别会按照顺序对不同类型的节点进行验证，按照以下的顺序进行处理：

- 常量、类型和函数名及类型；
- 变量的赋值和初始化；
- 函数和闭包的主体；
- 哈希键值对的类型；
- 导入函数体；
- 外部的声明；


 通过对每一棵抽象节点树的遍历，我们在每一个节点上都会对当前子树的类型进行验证保证当前节点上不会出现类型错误的问题，所有的类型错误和不匹配都会在这一个阶段被发现和暴露出来。

 类型检查的阶段不止会对树状结构的节点进行验证，同时也会对一些内建的函数进行展开和改写，例如 make 关键字在这个阶段会根据子树的结构被替换成 makeslice 或者 makechan 等函数。

 其实类型检查不止对类型进行了验证工作，还对 AST 进行了改写以及处理Go语言内置的关键字，所以，这一过程在整个编译流程中是非常重要的，没有这个步骤很多关键字其实就没有办法工作。

#### 3) 中间代码生成

当我们将源文件转换成了抽象语法树，对整个语法树的语法进行解析并进行类型检查之后，就可以认为当前文件中的代码基本上不存在无法编译或者语法错误的问题了，Go语言的编译器就会将输入的 AST 转换成中间代码。

 Go语言编译器的中间代码使用了 SSA(Static Single Assignment Form) 的特性，如果我们在中间代码生成的过程中使用这种特性，就能够比较容易的分析出代码中的无用变量和片段并对代码进行优化。

 在类型检查之后，就会通过一个名为 compileFunctions  的函数开始对整个Go语言项目中的全部函数进行编译，这些函数会在一个编译队列中等待几个后端工作协程的消费，这些 Goroutine  会将所有函数对应的 AST 转换成使用 SSA 特性的中间代码。

#### 4) 机器码生成

Go语言源代码的 cmd/compile/internal 目录中包含了非常多机器码生成相关的包，不同类型的 CPU 分别使用了不同的包进行生成 amd64、arm、arm64、mips、mips64、ppc64、s390x、x86 和 wasm，也就是说Go语言能够在几乎全部常见的  CPU 指令集类型上运行。

### 编译器入口

Go语言的编译器入口是 src/cmd/compile/internal/gc 包中的 main.go 文件，这个 600 多行的 Main  函数就是Go语言编译器的主程序，这个函数会先获取命令行传入的参数并更新编译的选项和配置，随后就会开始运行 parseFiles  函数对输入的所有文件进行词法与语法分析得到文件对应的抽象语法树：

func Main(archInit func(*Arch)) {
   // ...

   lines := parseFiles(flag.Args())

接下来就会分九个阶段对抽象语法树进行更新和编译，就像我们在上面介绍的，整个过程会经历类型检查、SSA 中间代码生成以及机器码生成三个部分：

- 检查常量、类型和函数的类型；
- 处理变量的赋值；
- 对函数的主体进行类型检查；
- 决定如何捕获变量；
- 检查内联函数的类型；
- 进行逃逸分析；
- 将闭包的主体转换成引用的捕获变量；
- 编译顶层函数；
- 检查外部依赖的声明；


 了解了剩下的编译过程之后，我们重新回到词法和语法分析后的具体流程，在这里编译器会对生成语法树中的节点执行类型检查，除了常量、类型和函数这些顶层声明之外，它还会对变量的赋值语句、函数主体等结构进行检查：

```go
for i := 0; i < len(xtop); i++ {
	n := xtop[i]
    if op := n.Op; op != ODCL && op != OAS && op != OAS2 && (op != ODCLTYPE || !n.Left.Name.Param.Alias) {
    	xtop[i] = typecheck(n, ctxStmt)
    }
}

for i := 0; i < len(xtop); i++ {
	n := xtop[i]
    if op := n.Op; op == ODCL || op == OAS || op == OAS2 || op == ODCLTYPE && n.Left.Name.Param.Alias {
    xtop[i] = typecheck(n, ctxStmt)
    }
}

for i := 0; i < len(xtop); i++ {
	n := xtop[i]
    if op := n.Op; op == ODCLFUNC || op == OCLOSURE {
    	typecheckslice(Curfn.Nbody.Slice(), ctxStmt)
    }
}

checkMapKeys()

for _, n := range xtop {
	if n.Op == ODCLFUNC && n.Func.Closure != nil {
    	capturevars(n)
    }
}

escapes(xtop)

for _, n := range xtop {
	if n.Op == ODCLFUNC && n.Func.Closure != nil {
    	transformclosure(n)
    }
}
```

类型检查会对传入节点的子节点进行遍历，这个过程会对 make 等关键字进行展开和重写，类型检查结束之后并没有输出新的[数据结构](http://c.biancheng.net/data_structure/)，只是改变了语法树中的一些节点，同时这个过程的结束也意味着源代码中已经不存在语法错误和类型错误，中间代码和机器码也都可以正常的生成了。

```go
initssaconfig()

peekitabs()

for i := 0; i < len(xtop); i++ {
	n := xtop[i]
    if n.Op == ODCLFUNC {
    	funccompile(n)
    }
}

compileFunctions()

for i, n := range externdcl {
	if n.Op == ONAME {
    	externdcl[i] = typecheck(externdcl[i], ctxExpr)
    }
}

checkMapKeys()
}
```

在主程序运行的最后，会将顶层的函数编译成中间代码并根据目标的 CPU 架构生成机器码，不过这里其实也可能会再次对外部依赖进行类型检查以验证正确性。

### 总结

Go语言的编译过程其实是非常有趣并且值得学习的，通过对Go语言四个编译阶段的分析和对编译器主函数的梳理，我们能够对 Golang 的实现有一些基本的理解，掌握编译的过程之后，Go语言对于我们来讲也不再那么神秘，所以学习其编译原理的过程还是非常有必要的。

## 工程结构详述

GOPATH，项目的构建主要是靠它来实现的。需要将这个项目的目录添加到 GOPATH 中，多个项目之间可以使用`;`分隔。

 如果不配置 GOPATH，即使处于同一目录，代码之间也无法通过绝对路径相互调用。

### 目录结构

一个Go语言项目的目录一般包含以下三个子目录：

- src 目录：放置项目和库的源文件；
- pkg 目录：放置编译后生成的包/库的归档文件；
- bin 目录：放置编译后生成的可执行文件。

#### src 目录

用于以包（package）的形式组织并存放 Go 源文件，这里的包与 src 下的每个子目录是一一对应。

包是Go语言管理代码的重要机制，其作用类似于[Java](http://c.biancheng.net/java/)中的 package 和 C/[C++](http://c.biancheng.net/cplus/) 的头文件。Go 源文件中第一段有效代码必须是`package <包名> `的形式，如 package hello。

Go语言会把通过`go get `命令获取到的库源文件下载到 src 目录下对应的文件夹当中。

#### pkg 目录

用于存放通过`go install `命令安装某个包后的归档文件。归档文件是指那些名称以“.a”结尾的文件。

该目录与 GOROOT 目录（也就是Go语言的安装目录）下的 pkg 目录功能类似，区别在于这里的 pkg 目录专门用来存放项目代码的归档文件。

编译和安装项目代码的过程一般会以代码包为单位进行，比如 log 包被编译安装后，将生成一个名为 log.a 的归档文件，并存放在当前项目的 pkg 目录下。

#### bin 目录

与 pkg 目录类似，在通过`go install `命令完成安装后，保存由 Go 命令源文件生成的可执行文件。在类 Unix 操作系统下，这个可执行文件的名称与命令源文件的文件名相同。而在 Windows 操作系统下，这个可执行文件的名称则是命令源文件的文件名加 .exe 后缀。

## 源文件

- 命令源文件：如果一个 Go 源文件被声明属于 main 包，并且该文件中包含 main 函数，则它就是命令源码文件。命令源文件属于程序的入口，可以通过Go语言的`go run `命令运行或者通过`go build `命令生成可执行文件。
- 库源文件：库源文件则是指存在于某个包中的普通源文件，并且库源文件中不包含 main 函数。

不管是命令源文件还是库源文件，在同一个目录下的所有源文件，其所属包的名称必须一致的。

## 依赖管理

### godep

godep 是一个Go语言官方提供的通过 vender 模式来管理第三方依赖的工具，类似的还有由社区维护的准官方包管理工具 dep。

 Go语言从 1.5 版本开始开始引入 vendor 模式，如果项目目录下有 vendor 目录，那么Go语言编译器会优先使用 vendor 内的包进行编译、测试等。

#### 安装godep工具

我们可以通过`go get `命令来获取 godep 工具。

go get github.com/tools/godep

命令执行成功后会将 godep 工具的源码下载到 GOPATH 的 src 目录下对应的文件夹中，同时还会在 GOPATH 的 bin 目录下生成一个名为 godep.exe 的可执行文件。

#### godep工具的基本命令

| 命令          | 作用                                    |
| ------------- | --------------------------------------- |
| godep save    | 将依赖包的信息保存到 Godeps.json 文件中 |
| godep go      | 使用保存的依赖项运行 go 工具            |
| godep get     | 下载并安装指定的包                      |
| godep path    | 打印依赖的 GOPATH 路径                  |
| godep restore | 在 GOPATH 中拉取依赖的版本              |
| godep update  | 更新选定的包或 go 版本                  |
| godep diff    | 显示当前和以前保存的依赖项集之间的差异  |
| godep version | 查看版本信息                            |


 使用`godep help [命令名称]`可以查看命令的帮助信息，如下所示。

C:\Users\Administrator>godep help go
 Args: godep go [-v] [-d] command [arguments]

 Go runs the go tool with a modified GOPATH giving access to
 dependencies saved in Godeps.

 Any go tool command can run this way, but "godep go get"
 is unnecessary and has been disabled. Instead, use
 "godep go install".

 If -v is given, verbose output is enabled.

 If -d is given, debug output is enabled (you probably don't want this, see -v).

#### 使用godep工具

执行`godep save `命令，会在当前目录中创建 Godeps 和 vender 两个文件夹。Godeps 文件夹下会生成一个 Godeps.json 文件，用来记录项目中所依赖的包信息；vender 目录则是用来保存当前项目所依赖的所有第三方包。
 生成的 Godeps.json 文件的结构如下所示：

{
   "ImportPath": "main",
   "GoVersion": "go1.13",
   "GodepVersion": "v80",
   "Deps": [
     {
       "ImportPath": "github.com/go-gomail/gomail",
       "Comment": "2.0.0-23-g81ebce5",
       "Rev": "81ebce5c23dfd25c6c67194b37d3dd3f338c98b1"
     }
   ]
 }

其中，“ImportPath”为项目的路径信息，“GoVersion”为Go语言的版本号，“GodepVersion”为 godep 工具的版本号，“Deps”为当前依赖包的路径、版本号信息等等。

提示：当引用的第三方包要升级时，只需要修改 Godep.json 里面的依赖包的版本号，然后再次执行 godep save 命令即可。

godep 工具的主要功能就是控制Go语言程序编译时依赖包搜索路径的优先级。例如查找项目的某个依赖包，首先会在项目根目录下的 vender 文件夹中查找，如果没有找到就会去 GOAPTH/src 目录下查找。

### go module

#### GO111MODULE

在Go语言 1.12 版本之前，要启用 go module 工具首先要设置环境变量 GO111MODULE，不过在Go语言 1.13 及以后的版本则不再需要设置环境变量。通过 GO111MODULE 可以开启或关闭 go module 工具。

- GO111MODULE=off 禁用 go module，编译时会从 GOPATH 和 vendor 文件夹中查找包。
- GO111MODULE=on 启用 go module，编译时会忽略 GOPATH 和 vendor 文件夹，只根据 go.mod下载依赖。
- GO111MODULE=auto（默认值），当项目在 GOPATH/src 目录之外，并且项目根目录有 go.mod 文件时，开启 go module。


 Windows 下开启 GO111MODULE 的命令为：

set GO111MODULE=on 或者 set GO111MODULE=auto

MacOS 或者 [Linux](http://c.biancheng.net/linux_tutorial/) 下开启 GO111MODULE 的命令为：

export GO111MODULE=on 或者 export GO111MODULE=auto

在开启 GO111MODULE 之后就可以使用 go module 工具了，也就是说在以后的开发中就没有必要在 GOPATH 中创建项目了，并且还能够很好的管理项目依赖的第三方包信息。

 使用 go module 的`go mod init `命令后会在当前目录下生成一个 go. mod 文件，并且在编译/运行当前目录下代码或者使用`go get `命令的时候会在当前目录下生成一个 go.sun 文件。


 go.mod 文件记录了项目所有的依赖信息，其结构大致如下：

module main.go

 go 1.13

 require (
   github.com/astaxie/beego v1.12.0
   github.com/shiena/ansicolor v0.0.0-20151119151921-a422bbe96644 // indirect
 )

其中，module 为 go.mod 文件所属的包，require 为项目所依赖的包及版本号，indirect 表示间接引用。

 go.sum 文件则是用来记录每个依赖包的版本及哈希值，如下所示。

github.com/Knetic/govaluate v3.0.0+incompatible/go.mod h1:r7JcOSlj0wfOMncg0iLm8Leh48TZaKVeNIfJntJ2wa0=
 github.com/OwnLocal/goes v1.0.0/go.mod h1:8rIFjBGTue3lCU0wplczcUgt9Gxgrkkrw7etMIcn8TM=
 github.com/astaxie/beego v1.12.0 h1:MRhVoeeye5N+Flul5PoVfD9CslfdoH+xqC/xvSQ5u2Y=
 github.com/astaxie/beego v1.12.0/go.mod h1:fysx+LZNZKnvh4GED/xND7jWtjCR6HzydR2Hh2Im57o=

常用的 go mod 命令如下表所示：



| 命令            | 作用                                           |
| --------------- | ---------------------------------------------- |
| go mod download | 下载依赖包到本地（默认为 GOPATH/pkg/mod 目录） |
| go mod edit     | 编辑 go.mod 文件                               |
| go mod graph    | 打印模块依赖图                                 |
| go mod init     | 初始化当前文件夹，创建 go.mod 文件             |
| go mod tidy     | 增加缺少的包，删除无用的包                     |
| go mod vendor   | 将依赖复制到 vendor 目录下                     |
| go mod verify   | 校验依赖                                       |
| go mod why      | 解释为什么需要依赖                             |

#### GOPROXY

proxy 顾名思义就是代理服务器的意思。大家都知道，国内的网络有防火墙的存在，这导致有些Go语言的第三方包我们无法直接通过`go get `命令获取。GOPROXY 是Go语言官方提供的一种通过中间代理商来为用户提供包下载服务的方式。要使用 GOPROXY 只需要设置环境变量 GOPROXY 即可。

 目前公开的代理服务器的地址有：

- goproxy.io
- goproxy.cn：（推荐）由国内的七牛云提供。


 Windows 下设置 GOPROXY 的命令为：

go env -w GOPROXY=https://goproxy.cn,direct

MacOS 或 Linux 下设置 GOPROXY 的命令为：

export GOPROXY=https://goproxy.cn

Go语言在 1.13 版本之后 GOPROXY 默认值为 https://proxy.golang.org，在国内可能会存在下载慢或者无法访问的情况，所以十分建议大家将 GOPROXY 设置为国内的 goproxy.cn。

#### 使用go get命令下载指定版本的依赖包

执行`go get `命令，在下载依赖包的同时还可以指定依赖包的版本。

- 运行`go get -u`命令会将项目中的包升级到最新的次要版本或者修订版本；
- 运行`go get -u=patch`命令会将项目中的包升级到最新的修订版本；
- 运行`go get [包名]@[版本号]`命令会下载对应包的指定版本或者将对应包升级到指定的版本。

提示：`go get [包名]@[版本号]`命令中版本号可以是 x.y.z 的形式，例如 go get foo@v1.2.3，也可以是 git 上的分支或 tag，例如 go get foo@master，还可以是 git 提交时的哈希值，例如 go get foo@e3702bed2。



## 声明

 主要有四种类型的声明语句：var、const、type和func，分别对应变量、常量、类型和函数实体对象的声明。

一个Go语言编写的程序对应一个或多个以.go为文件后缀名的源文件中。每个源文件以包的声明语句开始，说明该源文件是属于哪个包。包声明语句之后是import语句导入依赖的其它包，然后是包一级的类型、变量、常量、函数的声明语句，包一级的各种类型的声明语句的顺序无关紧要。

## Other

当两个或多个连续的函数命名参数是同一类型，则除了最后一个类型之外，其他都可以省略。

```go
x int, y int	==>		x, y int
```



 

指针变量 * 和地址值 & 的区别：指针变量保存的是一个地址值，会分配独立的内存来存储一个整型数字。当变量前面有 * 标识时，才等同于 & 的用法，否则会直接输出一个整型数字。

```
func main() {
   var a int = 4
   var ptr *int
   ptr = &a
   println("a的值为", a);    // 4
   println("*ptr为", *ptr);  // 4
   println("ptr为", ptr);    // 824633794744
}
```



Go 的自增，自减只能作为表达式使用，而不能用于赋值语句。

```
a++ // 这是允许的，类似 a = a + 1,结果与 a++ 相同
a-- //与 a++ 相似
a = a++ // 这是不允许的，会出现变异错误 syntax error: unexpected ++ at end of statement
```

​			

fmt 包的格式化功能

```
%b    表示为二进制
%c    该值对应的unicode码值
%d    表示为十进制
%o    表示为八进制
%q    该值对应的单引号括起来的go语法字符字面值，必要时会采用安全的转义表示
%x    表示为十六进制，使用a-f
%X    表示为十六进制，使用A-F
%U    表示为Unicode格式：U+1234，等价于"U+%04X"
%E    用科学计数法表示
%f    用浮点数表示
```



# 13. Maps 				

​					 					[ArisAries](https://studygolang.com/gctt/ArisAries) 				 					 · 2018-01-20 09:59:02 · 24628 次点击 · 					预计阅读时间 7 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-01-20 09:59:02 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 13 个教程。 

## 什么是 map ？

map 是在 Go 中将值（value）与键（key）关联的内置类型。通过相应的键可以获取到值。

## 如何创建 map ？

通过向 `make` 函数传入键和值的类型，可以创建 map。`make(map[type of key]type of value)` 是创建 map 的语法。

```go
personSalary := make(map[string]int)
```

上面的代码创建了一个名为 `personSalary` 的 map，其中键是 string 类型，而值是 int 类型。

map 的零值是 `nil`。如果你想添加元素到 nil map 中，会触发运行时 panic。因此 map 必须使用 `make` 函数初始化。

```go
package main

import (
    "fmt"
)

func main() {  
    var personSalary map[string]int
    if personSalary == nil {
        fmt.Println("map is nil. Going to make one.")
        personSalary = make(map[string]int)
    }
}
```

[在线运行程序](https://play.golang.org/p/IwJnXMGc1M)

上面的程序中，personSalary 是 nil，因此需要使用 make 方法初始化，程序将输出 `map is nil. Going to make one.`。

## 给 map 添加元素

给 map 添加新元素的语法和数组相同。下面的程序给 `personSalary` map 添加了几个新元素。

```go
package main

import (
    "fmt"
)

func main() {
    personSalary := make(map[string]int)
    personSalary["steve"] = 12000
    personSalary["jamie"] = 15000
    personSalary["mike"] = 9000
    fmt.Println("personSalary map contents:", personSalary)
}
```

[在线运行程序](https://play.golang.org/p/V1lnQ4Igw1)

上面的程序输出：`personSalary map contents: map[steve:12000 jamie:15000 mike:9000]`

你也可以在声明的时候初始化 map。

```go
package main

import (  
    "fmt"
)

func main() {  
    personSalary := map[string]int {
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    fmt.Println("personSalary map contents:", personSalary)
}
```

[在线运行程序](https://play.golang.org/p/nlH_ADhO9f)

上面的程序声明了 personSalary，并在声明的同时添加两个元素。之后又添加了键 `mike`。程序输出：

```
personSalary map contents: map[steve:12000 jamie:15000 mike:9000]
```

键不一定只能是 string 类型。所有可比较的类型，如 boolean，interger，float，complex，string 等，都可以作为键。关于可比较的类型，如果你想了解更多，请访问 http://golang.org/ref/spec#Comparison_operators。

## 获取 map 中的元素

目前我们已经给 map 添加了几个元素，现在学习下如何获取它们。获取 map 元素的语法是 `map[key]` 。

```go
package main

import (
    "fmt"
)

func main() {
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    employee := "jamie"
    fmt.Println("Salary of", employee, "is", personSalary[employee])
}
```

[在线运行程序](https://play.golang.org/p/-TSBac7F1v)

上面的程序很简单。获取并打印员工 `jamie` 的薪资。程序输出 `Salary of jamie is 15000`。

如果获取一个不存在的元素，会发生什么呢？map 会返回该元素类型的零值。在 `personSalary` 这个 map 里，如果我们获取一个不存在的元素，会返回 `int` 类型的零值 `0`。

```go
package main

import (  
    "fmt"
)

func main() {
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    employee := "jamie"
    fmt.Println("Salary of", employee, "is", personSalary[employee])
    fmt.Println("Salary of joe is", personSalary["joe"])
}
```

[在线运行程序](https://play.golang.org/p/EhUJhIkYJU)

上面程序输出：

```
Salary of jamie is 15000
Salary of joe is 0
```

上面程序返回 `joe` 的薪资是 0。`personSalary` 中不包含 `joe` 的情况下我们不会获取到任何运行时错误。

如果我们想知道 map 中到底是不是存在这个 `key`，该怎么做：

```go
value, ok := map[key]
```

上面就是获取 map 中某个 key 是否存在的语法。如果 `ok` 是 true，表示 key 存在，key 对应的值就是 `value` ，反之表示 key 不存在。

```go
package main

import (
    "fmt"
)

func main() {
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    newEmp := "joe"
    value, ok := personSalary[newEmp]
    if ok == true {
        fmt.Println("Salary of", newEmp, "is", value)
    } else {
        fmt.Println(newEmp,"not found")
    }
}
```

[在线运行程序](https://play.golang.org/p/q8fL6MeVZs)

上面的程序中，第 15 行，`joe` 不存在，所以 `ok` 是 false。程序将输出：

```
joe not found
```

遍历 map 中所有的元素需要用 `for range` 循环。

```go
package main

import (
    "fmt"
)

func main() {
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    fmt.Println("All items of a map")
    for key, value := range personSalary {
        fmt.Printf("personSalary[%s] = %d\n", key, value)
    }

}
```

[在线运行程序](https://play.golang.org/p/gq9ZOKsI9b)

上面程序输出：

```
All items of a map
personSalary[mike] = 9000
personSalary[steve] = 12000
personSalary[jamie] = 15000
```

**有一点很重要，当使用 `for range` 遍历 map 时，不保证每次执行程序获取的元素顺序相同。**

## 删除 map 中的元素

删除 `map` 中 `key` 的语法是 [*delete(map, key)*](https://golang.org/pkg/builtin/#delete)。这个函数没有返回值。

```go
package main

import (  
    "fmt"
)

func main() {  
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    fmt.Println("map before deletion", personSalary)
    delete(personSalary, "steve")
    fmt.Println("map after deletion", personSalary)

}
```

[在线运行程序](https://play.golang.org/p/nroJzeF-a7)

上述程序删除了键 "steve"，输出：

```
map before deletion map[steve:12000 jamie:15000 mike:9000]
map after deletion map[mike:9000 jamie:15000]
```

## 获取 map 的长度

获取 map 的长度使用 [len](https://golang.org/pkg/builtin/#len) 函数。

```go
package main

import (
    "fmt"
)

func main() {
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    fmt.Println("length is", len(personSalary))

}
```

[在线运行程序](https://play.golang.org/p/8O1WnKUuDP)

上述程序中的 *len(personSalary)* 函数获取了 map 的长度。程序输出 `length is 3`。

## Map 是引用类型

和 [slices](https://golangbot.com/arrays-and-slices/) 类似，map 也是引用类型。当 map 被赋值为一个新变量的时候，它们指向同一个内部数据结构。因此，改变其中一个变量，就会影响到另一变量。

```go
package main

import (
    "fmt"
)

func main() {
    personSalary := map[string]int{
        "steve": 12000,
        "jamie": 15000,
    }
    personSalary["mike"] = 9000
    fmt.Println("Original person salary", personSalary)
    newPersonSalary := personSalary
    newPersonSalary["mike"] = 18000
    fmt.Println("Person salary changed", personSalary)

}
```

[在线运行程序](https://play.golang.org/p/OGFl3addq1)

上面程序中的第 14 行，`personSalary` 被赋值给 `newPersonSalary`。下一行 ，`newPersonSalary` 中 `mike` 的薪资变成了 `18000` 。`personSalary` 中 `Mike` 的薪资也会变成 `18000`。程序输出：

```
Original person salary map[steve:12000 jamie:15000 mike:9000]
Person salary changed map[steve:12000 jamie:15000 mike:18000]
```

当 map 作为函数参数传递时也会发生同样的情况。函数中对 map 的任何修改，对于外部的调用都是可见的。

## Map 的相等性

map 之间不能使用 `==` 操作符判断，`==` 只能用来检查 map 是否为 `nil`。

```go
package main

func main() {
    map1 := map[string]int{
        "one": 1,
        "two": 2,
    }

    map2 := map1

    if map1 == map2 {
    }
}
```

[在线运行程序](https://play.golang.org/p/MALqDyWkcT)

上面程序抛出编译错误 **invalid operation: map1 == map2 (map can only be compared to nil)**。

判断两个 map 是否相等的方法是遍历比较两个 map 中的每个元素。我建议你写一段这样的程序实现这个功能 ![:smile:](https://cdnjs.cloudflare.com/ajax/libs/emojify.js/1.1.0/images/basic/smile.png)。

我在一个程序里实现了我们讨论过的所有概念。你可以从 [github](https://github.com/golangbot/maps) 下载代码。

这就是 map 。谢谢你的阅读。祝好。

**上一教程 - [可变参数函数](https://studygolang.com/articles/12173)**

**下一教程 - [字符串](https://studygolang.com/articles/12261)**

------

# 14. 字符串 				

​					 					[jliu666](https://studygolang.com/gctt/jliu666) 				 					 · 2018-01-22 16:53:54 · 18598 次点击 · 					预计阅读时间 8 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-01-22 16:53:54 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎阅读 [Golang 系列教程](https://studygolang.com/subject/2)第 14 部分。

由于和其他语言相比，字符串在 Go 语言中有着自己特殊的实现，因此在这里需要被特别提出来。

## 什么是字符串？

Go 语言中的字符串是一个字节切片。把内容放在双引号""之间，我们可以创建一个字符串。让我们来看一个创建并打印字符串的简单示例。

```go
package main

import (
    "fmt"
)

func main() {
    name := "Hello World"
    fmt.Println(name)
}
```

[在线运行程序](https://play.golang.org/p/o9OVDgEMU0)

上面的程序将会输出 `Hello World`。

Go 中的字符串是兼容 Unicode 编码的，并且使用 UTF-8 进行编码。

## 单独获取字符串的每一个字节

由于字符串是一个字节切片，所以我们可以获取字符串的每一个字节。

```go
package main

import (
    "fmt"
)

func printBytes(s string) {
    for i:= 0; i < len(s); i++ {
        fmt.Printf("%x ", s[i])
    }
}

func main() {
    name := "Hello World"
    printBytes(name)
}
```

[在线运行程序](https://play.golang.org/p/XbJO2b0ZDW)

上面程序的第 8 行，**`len(s)` 返回字符串中字节的数量**，然后我们用了一个 for 循环以 16 进制的形式打印这些字节。`%x` 格式限定符用于指定 16 进制编码。上面的程序输出 `48 65 6c 6c 6f 20 57 6f 72 6c 64`。这些打印出来的字符是 "Hello World" 以 [Unicode UTF-8 编码](https://mothereff.in/utf-8#Hello World)的结果。为了更好的理解 go 中的字符串，需要对 Unicode 和 UTF-8 有基础的理解。我推荐阅读一下 https://naveenr.net/unicode-character-set-and-utf-8-utf-16-utf-32-encoding/ 来理解一下什么是 Unicode 和 UTF-8。

让我们稍微修改一下上面的程序，让它打印字符串的每一个字符。

```go
package main

import (
    "fmt"
)

func printBytes(s string) {
    for i:= 0; i < len(s); i++ {
        fmt.Printf("%x ", s[i])
    }
}


func printChars(s string) {
    for i:= 0; i < len(s); i++ {
        fmt.Printf("%c ",s[i])
    }
}

func main() {
    name := "Hello World"
    printBytes(name)
    fmt.Printf("\n")
    printChars(name)
}
```

[在线运行程序](https://play.golang.org/p/Jss0HG1q80)

在 `printChars` 方法(第 16 行中)中，`%c` 格式限定符用于打印字符串的字符。这个程序输出结果是：

```
48 65 6c 6c 6f 20 57 6f 72 6c 64  
H e l l o   W o r l d
```

上面的程序获取字符串的每一个字符，虽然看起来是合法的，但却有一个严重的 bug。让我拆解这个代码来看看我们做错了什么。

```go
package main

import (
    "fmt"
)

func printBytes(s string) {
    for i:= 0; i < len(s); i++ {
        fmt.Printf("%x ", s[i])
    }
}

func printChars(s string) {
    for i:= 0; i < len(s); i++ {
        fmt.Printf("%c ",s[i])
    }
}

func main() {
    name := "Hello World"
    printBytes(name)
    fmt.Printf("\n")
    printChars(name)
    fmt.Printf("\n")
    name = "Señor"
    printBytes(name)
    fmt.Printf("\n")
    printChars(name)
}
```

[在线运行程序](https://play.golang.org/p/UQOVvRVaFH)

上面代码输出的结果是：

```
48 65 6c 6c 6f 20 57 6f 72 6c 64  
H e l l o   W o r l d  
53 65 c3 b1 6f 72  
S e Ã ± o r
```

在上面程序的第 28 行，我们尝试输出 **Señor** 的字符，但却输出了错误的 **S e Ã ± o r**。 为什么程序分割 `Hello World` 时表现完美，但分割 `Señor` 就出现了错误呢？这是因为 `ñ` 的 Unicode 代码点（Code Point）是 `U+00F1`。它的 [UTF-8 编码](https://mothereff.in/utf-8#ñ)占用了 c3 和 b1 两个字节。它的 UTF-8 编码占用了两个字节 c3 和  b1。而我们打印字符时，却假定每个字符的编码只会占用一个字节，这是错误的。在 UTF-8  编码中，一个代码点可能会占用超过一个字节的空间。那么我们该怎么办呢？rune 能帮我们解决这个难题。

## rune

rune 是 Go 语言的内建类型，它也是 int32 的别称。在 Go 语言中，rune 表示一个代码点。代码点无论占用多少个字节，都可以用一个 rune 来表示。让我们修改一下上面的程序，用 rune 来打印字符。

```go
package main

import (
    "fmt"
)

func printBytes(s string) {
    for i:= 0; i < len(s); i++ {
        fmt.Printf("%x ", s[i])
    }
}

func printChars(s string) {
    runes := []rune(s)
    for i:= 0; i < len(runes); i++ {
        fmt.Printf("%c ",runes[i])
    }
}

func main() {
    name := "Hello World"
    printBytes(name)
    fmt.Printf("\n")
    printChars(name)
    fmt.Printf("\n\n")
    name = "Señor"
    printBytes(name)
    fmt.Printf("\n")
    printChars(name)
}
```

[在线运行程序](https://play.golang.org/p/t4z-f8I-ih)

在上面代码的第 14 行，字符串被转化为一个 rune 切片。然后我们循环打印字符。程序的输出结果是

```
48 65 6c 6c 6f 20 57 6f 72 6c 64  
H e l l o   W o r l d 

53 65 c3 b1 6f 72  
S e ñ o r
```

上面的输出结果非常完美，就是我们想要的结果:)。

## 字符串的 for range 循环

上面的程序是一种遍历字符串的好方法，但是 Go 给我们提供了一种更简单的方法来做到这一点：使用 **for range** 循环。

```go
package main

import (
    "fmt"
)

func printCharsAndBytes(s string) {
    for index, rune := range s {
        fmt.Printf("%c starts at byte %d\n", rune, index)
    }
}

func main() {
    name := "Señor"
    printCharsAndBytes(name)
}
```

[在线运行程序](https://play.golang.org/p/BPpQ0dZr8W)

在上面程序中的第8行，使用 `for range` 循环遍历了字符串。循环返回的是是当前 rune 的字节位置。程序的输出结果为：

```
S starts at byte 0  
e starts at byte 1  
ñ starts at byte 2
o starts at byte 4  
r starts at byte 5
```

从上面的输出中可以清晰的看到 `ñ` 占了两个字节:)。

## 用字节切片构造字符串

```go
package main

import (  
    "fmt"
)

func main() {  
    byteSlice := []byte{0x43, 0x61, 0x66, 0xC3, 0xA9}
    str := string(byteSlice)
    fmt.Println(str)
}
```

[在线运行程序](https://play.golang.org/p/Vr9pf8X8xO)

上面的程序中 `byteSlice` 包含字符串 `Café` 用 UTF-8 编码后的 16 进制字节。程序输出结果是 `Café`。

如果我们把 16 进制换成对应的 10 进制值会怎么样呢？上面的程序还能工作吗？让我们来试一试：

```go
package main

import (  
    "fmt"
)

func main() {  
    byteSlice := []byte{67, 97, 102, 195, 169}//decimal equivalent of {'\x43', '\x61', '\x66', '\xC3', '\xA9'}
    str := string(byteSlice)
    fmt.Println(str)
}
```

[在线运行程序](https://play.golang.org/p/jgsRowW6XN)

上面程序的输出结果也是`Café`

## 用 rune 切片构造字符串

```go
package main

import (  
    "fmt"
)

func main() {  
    runeSlice := []rune{0x0053, 0x0065, 0x00f1, 0x006f, 0x0072}
    str := string(runeSlice)
    fmt.Println(str)
}
```

[在线运行程序](https://play.golang.org/p/m8wTMOpYJP)

在上面的程序中 `runeSlice` 包含字符串 `Señor`的 16 进制的 Unicode 代码点。这个程序将会输出`Señor`。

## 字符串的长度

[utf8 package](https://golang.org/pkg/unicode/utf8/#RuneCountInString) 包中的 `func RuneCountInString(s string) (n int)` 方法用来获取字符串的长度。这个方法传入一个字符串参数然后返回字符串中的 rune 的数量。

```go
package main

import (  
    "fmt"
    "unicode/utf8"
)

func length(s string) {  
    fmt.Printf("length of %s is %d\n", s, utf8.RuneCountInString(s))
}
func main() { 
    word1 := "Señor" 
    length(word1)
    word2 := "Pets"
    length(word2)
}
```

[在线运行程序](https://play.golang.org/p/QGYlHmF7tn)

上面程序的输出结果是：

```
length of Señor is 5  
length of Pets is 4
```

## 字符串是不可变的

Go 中的字符串是不可变的。一旦一个字符串被创建，那么它将无法被修改。

```go
package main

import (  
    "fmt"
)

func mutate(s string)string {  
    s[0] = 'a'//any valid unicode character within single quote is a rune 
    return s
}
func main() {  
    h := "hello"
    fmt.Println(mutate(h))
}
```

[在线运行程序](https://play.golang.org/p/bv4SlSd_hp)

在上面程序中的第 8 行，我们试图把这个字符串中的第一个字符修改为 'a'。由于字符串是不可变的，因此这个操作是非法的。所以程序抛出了一个错误 **main.go:8: cannot assign to s[0]**。

为了修改字符串，可以把字符串转化为一个 rune 切片。然后这个切片可以进行任何想要的改变，然后再转化为一个字符串。

```go
package main

import (  
    "fmt"
)

func mutate(s []rune) string {  
    s[0] = 'a' 
    return string(s)
}
func main() {  
    h := "hello"
    fmt.Println(mutate([]rune(h)))
}
```

[在线运行程序](https://play.golang.org/p/GL1cm17IP1)

在上面程序的第 7 行，`mutate` 函数接收一个 rune 切片参数，它将切片的第一个元素修改为 `'a'`，然后将 rune 切片转化为字符串，并返回该字符串。程序的第 13 行调用了该函数。我们把 `h` 转化为一个 rune 切片，并传递给了 `mutate`。这个程序输出 `aello`。

我已经在 github 上创建了一个程序，里面包含所有我们讨论过的内容。你可以在这[下载](https://github.com/golangbot/stringsexplained)它。

# 15. 指针 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-01-22 17:37:19 · 19429 次点击 · 					预计阅读时间 5 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-01-22 17:37:19 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 15 个教程。

### 什么是指针？

指针是一种存储变量内存地址（Memory Address）的变量。

![指针示意图](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/pointer-explained.png)

如上图所示，变量 `b` 的值为 `156`，而 `b` 的内存地址为 `0x1040a124`。变量 `a` 存储了 `b` 的地址。我们就称 `a` 指向了 `b`。

### 指针的声明

指针变量的类型为 **`\*T`**，该指针指向一个 **T** 类型的变量。

接下来我们写点代码。

```go
package main

import (
    "fmt"
)

func main() {
    b := 255
    var a *int = &b
    fmt.Printf("Type of a is %T\n", a)
    fmt.Println("address of b is", a)
}
```

[在线运行程序](https://play.golang.org/p/A4vmlgxAy8)

**&** 操作符用于获取变量的地址。上面程序的第 9 行我们把 `b` 的地址赋值给 **`\*int`** 类型的 `a`。我们称 `a` 指向了 `b`。当我们打印 `a` 的值时，会打印出 `b` 的地址。程序将输出：

```
Type of a is *int  
address of b is 0x1040a124
```

由于 b 可能处于内存的任何位置，你应该会得到一个不同的地址。

### 指针的零值（Zero Value）

指针的零值是 `nil`。

```go
package main

import (  
    "fmt"
)

func main() {  
    a := 25
    var b *int
    if b == nil {
        fmt.Println("b is", b)
        b = &a
        fmt.Println("b after initialization is", b)
    }
}
```

[在线运行程序](https://play.golang.org/p/yAeGhzgQE1)

上面的程序中，`b` 初始化为 `nil`，接着将 `a` 的地址赋值给 `b`。程序会输出：

```
b is <nil>  
b after initialisation is 0x1040a124
```

### 指针的解引用

指针的解引用可以获取指针所指向的变量的值。将 `a` 解引用的语法是 `*a`。

通过下面的代码，可以看到如何使用解引用。

```go
package main  
import (  
    "fmt"
)

func main() {  
    b := 255
    a := &b
    fmt.Println("address of b is", a)
    fmt.Println("value of b is", *a)
}
```

[在线运行程序](https://play.golang.org/p/m5pNbgFwbM)

在上面程序的第 10 行，我们将 `a` 解引用，并打印了它的值。不出所料，我们会打印出 `b` 的值。程序会输出：

```
address of b is 0x1040a124  
value of b is 255
```

我们再编写一个程序，用指针来修改 b 的值。

```go
package main

import (  
    "fmt"
)

func main() {  
    b := 255
    a := &b
    fmt.Println("address of b is", a)
    fmt.Println("value of b is", *a)
    *a++
    fmt.Println("new value of b is", b)
}
```

[在线运行程序](https://play.golang.org/p/cdmvlpBNmb)

在上面程序的第 12 行中，我们把 `a` 指向的值加 1，由于 `a` 指向了 `b`，因此 `b` 的值也发生了同样的改变。于是 `b` 的值变为 256。程序会输出：

```
address of b is 0x1040a124  
value of b is 255  
new value of b is 256
```

### 向函数传递指针参数

```go
package main

import (  
    "fmt"
)

func change(val *int) {  
    *val = 55
}
func main() {  
    a := 58
    fmt.Println("value of a before function call is",a)
    b := &a
    change(b)
    fmt.Println("value of a after function call is", a)
}
```

[在线运行程序](https://play.golang.org/p/3n2nHRJJqn)

在上面程序中的第 14 行，我们向函数 `change` 传递了指针变量 `b`，而 `b` 存储了 `a` 的地址。程序的第 8 行在 `change` 函数内使用解引用，修改了 a 的值。该程序会输出：

```
value of a before function call is 58  
value of a after function call is 55
```

### 不要向函数传递数组的指针，而应该使用切片

假如我们想要在函数内修改一个数组，并希望调用函数的地方也能得到修改后的数组，一种解决方案是把一个指向数组的指针传递给这个函数。

```go
package main

import (  
    "fmt"
)

func modify(arr *[3]int) {  
    (*arr)[0] = 90
}

func main() {  
    a := [3]int{89, 90, 91}
    modify(&a)
    fmt.Println(a)
}
```

[在线运行程序](https://play.golang.org/p/lOIznCbcvs)

在上面程序的第 13 行中，我们将数组的地址传递给了 `modify` 函数。在第 8 行，我们在 `modify` 函数里把 `arr` 解引用，并将 `90` 赋值给这个数组的第一个元素。程序会输出 `[90 90 91]`。

**`a[x]` 是 `(\*a)[x]` 的简写形式，因此上面代码中的 `(\*arr)[0]` 可以替换为 `arr[0]`**。下面我们用简写形式重写以上代码。

```go
package main

import (  
    "fmt"
)

func modify(arr *[3]int) {  
    arr[0] = 90
}

func main() {  
    a := [3]int{89, 90, 91}
    modify(&a)
    fmt.Println(a)
}
```

[在线运行程序](https://play.golang.org/p/k7YR0EUE1G)

该程序也会输出 `[90 90 91]`。

**这种方式向函数传递一个数组指针参数，并在函数内修改数组。尽管它是有效的，但却不是 Go 语言惯用的实现方式。我们最好使用[切片](https://golangbot.com/arrays-and-slices/)来处理。**

接下来我们用[切片](https://golangbot.com/arrays-and-slices/)来重写之前的代码。

```go
package main

import (  
    "fmt"
)

func modify(sls []int) {  
    sls[0] = 90
}

func main() {  
    a := [3]int{89, 90, 91}
    modify(a[:])
    fmt.Println(a)
}
```

[在线运行程序](https://play.golang.org/p/rRvbvuI67W)

在上面程序的第 13 行，我们将一个切片传递给了 `modify` 函数。在 `modify` 函数中，我们把切片的第一个元素修改为 `90`。程序也会输出 `[90 90 91]`。**所以别再传递数组指针了，而是使用切片吧**。上面的代码更加简洁，也更符合 Go 语言的习惯。

### Go 不支持指针运算

Go 并不支持其他语言（例如 C）中的指针运算。

```go
package main

func main() {  
    b := [...]int{109, 110, 111}
    p := &b
    p++
}
```

[在线运行程序](https://play.golang.org/p/WRaj4pkqRD)

上面的程序会抛出编译错误：**`main.go:6: invalid operation: p++ (non-numeric type \*[3]int)`**。

我在 [github](https://github.com/golangbot/pointers) 上创建了一个程序，涵盖了所有我们讨论过的内容。

# 16. 结构体 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-01-22 17:52:48 · 22489 次点击 · 					预计阅读时间 13 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-01-22 17:52:48 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 16 个教程。  

### 什么是结构体？

结构体是用户定义的类型，表示若干个字段（Field）的集合。有时应该把数据整合在一起，而不是让这些数据没有联系。这种情况下可以使用结构体。

例如，一个职员有 `firstName`、`lastName` 和 `age` 三个属性，而把这些属性组合在一个结构体 `employee` 中就很合理。

### 结构体的声明

```go
type Employee struct {
    firstName string
    lastName  string
    age       int
}
```

在上面的代码片段里，声明了一个结构体类型 `Employee`，它有 `firstName`、`lastName` 和 `age` 三个字段。通过把相同类型的字段声明在同一行，结构体可以变得更加紧凑。在上面的结构体中，`firstName` 和 `lastName` 属于相同的 `string` 类型，于是这个结构体可以重写为：

```go
type Employee struct {
    firstName, lastName string
    age, salary         int
}
```

上面的结构体 `Employee` 称为 **命名的结构体（Named Structure）**。我们创建了名为 `Employee` 的新类型，而它可以用于创建 `Employee` 类型的结构体变量。  

声明结构体时也可以不用声明一个新类型，这样的结构体类型称为 **匿名结构体（Anonymous Structure）**。

```go
var employee struct {
    firstName, lastName string
    age int
}
```

上述代码片段创建一个**匿名结构体** `employee`。

### 创建命名的结构体

通过下面代码，我们定义了一个**命名的结构体 `Employee`**。

```go
package main

import (  
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {

    //creating structure using field names
    emp1 := Employee{
        firstName: "Sam",
        age:       25,
        salary:    500,
        lastName:  "Anderson",
    }

    //creating structure without using field names
    emp2 := Employee{"Thomas", "Paul", 29, 800}

    fmt.Println("Employee 1", emp1)
    fmt.Println("Employee 2", emp2)
}
```

[在线运行程序](https://play.golang.org/p/uhPAHeUwvK)  

在上述程序的第 7 行，我们创建了一个命名的结构体 `Employee`。而在第 15 行，通过指定每个字段名的值，我们定义了结构体变量 `emp1`。字段名的顺序不一定要与声明结构体类型时的顺序相同。在这里，我们改变了 `lastName` 的位置，将其移到了末尾。这样做也不会有任何的问题。

在上面程序的第 23 行，定义 `emp2` 时我们省略了字段名。在这种情况下，就需要保证字段名的顺序与声明结构体时的顺序相同。

该程序将输出：

```
Employee 1 {Sam Anderson 25 500}
Employee 2 {Thomas Paul 29 800}
```

### 创建匿名结构体

```go
package main

import (
    "fmt"
)

func main() {
    emp3 := struct {
        firstName, lastName string
        age, salary         int
    }{
        firstName: "Andreah",
        lastName:  "Nikola",
        age:       31,
        salary:    5000,
    }

    fmt.Println("Employee 3", emp3)
}
```

[在线运行程序](https://play.golang.org/p/TEMFM3oZiq)  

在上述程序的第 3 行，我们定义了一个**匿名结构体变量** `emp3`。上面我们已经提到，之所以称这种结构体是匿名的，是因为它只是创建一个新的结构体变量 `em3`，而没有定义任何结构体类型。

该程序会输出：

```
Employee 3 {Andreah Nikola 31 5000}
```

### 结构体的零值（Zero Value）

当定义好的结构体并没有被显式地初始化时，该结构体的字段将默认赋为零值。

```go
package main

import (  
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {  
    var emp4 Employee //zero valued structure
    fmt.Println("Employee 4", emp4)
}
```

[在线运行程序](https://play.golang.org/p/p7_OpVdFXJ)  

该程序定义了 `emp4`，却没有初始化任何值。因此 `firstName` 和 `lastName` 赋值为 string 的零值（`""`）。而 `age` 和 `salary` 赋值为 int 的零值（0）。该程序会输出：

```
Employee 4 { 0 0}
```

当然还可以为某些字段指定初始值，而忽略其他字段。这样，忽略的字段名会赋值为零值。  

```go
package main

import (  
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {  
    emp5 := Employee{
        firstName: "John",
        lastName:  "Paul",
    }
    fmt.Println("Employee 5", emp5)
}
```

[在线运行程序](https://play.golang.org/p/w2gPoCnlZ1)  

在上面程序中的第 14 行和第 15 行，我们初始化了 `firstName` 和 `lastName`，而 `age` 和 `salary` 没有进行初始化。因此 `age` 和 `salary` 赋值为零值。该程序会输出：

```
Employee 5 {John Paul 0 0}
```

### 访问结构体的字段

点号操作符 `.` 用于访问结构体的字段。

```go
package main

import (  
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {  
    emp6 := Employee{"Sam", "Anderson", 55, 6000}
    fmt.Println("First Name:", emp6.firstName)
    fmt.Println("Last Name:", emp6.lastName)
    fmt.Println("Age:", emp6.age)
    fmt.Printf("Salary: $%d", emp6.salary)
}
```

[在线运行程序](https://play.golang.org/p/GPd_sT85IS)  

上面程序中的 **emp6.firstName** 访问了结构体 `emp6` 的字段 `firstName`。该程序输出：

```
First Name: Sam  
Last Name: Anderson  
Age: 55  
Salary: $6000
```

还可以创建零值的 `struct`，以后再给各个字段赋值。

```go
package main

import (
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {  
    var emp7 Employee
    emp7.firstName = "Jack"
    emp7.lastName = "Adams"
    fmt.Println("Employee 7:", emp7)
}
```

[在线运行程序](https://play.golang.org/p/ZEOx10g7nN)  

在上面程序中，我们定义了 `emp7`，接着给 `firstName` 和 `lastName` 赋值。该程序会输出：  

```
Employee 7: {Jack Adams 0 0}
```

### 结构体的指针

还可以创建指向结构体的指针。

```go
package main

import (  
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {  
    emp8 := &Employee{"Sam", "Anderson", 55, 6000}
    fmt.Println("First Name:", (*emp8).firstName)
    fmt.Println("Age:", (*emp8).age)
}
```

[在线运行程序](https://play.golang.org/p/xj87UCnBtH)  

在上面程序中，**emp8** 是一个指向结构体 `Employee` 的指针。`(*emp8).firstName` 表示访问结构体 `emp8` 的 `firstName` 字段。该程序会输出：

```
First Name: Sam
Age: 55
```

**Go 语言允许我们在访问 `firstName` 字段时，可以使用 `emp8.firstName` 来代替显式的解引用 `(\*emp8).firstName`**。  

```go
package main

import (  
    "fmt"
)

type Employee struct {  
    firstName, lastName string
    age, salary         int
}

func main() {  
    emp8 := &Employee{"Sam", "Anderson", 55, 6000}
    fmt.Println("First Name:", emp8.firstName)
    fmt.Println("Age:", emp8.age)
}
```

[在线运行程序](https://play.golang.org/p/0ZE265qQ1h)  

在上面的程序中，我们使用 `emp8.firstName` 来访问 `firstName` 字段，该程序会输出：  

```
First Name: Sam
Age: 55
```

### 匿名字段

当我们创建结构体时，字段可以只有类型，而没有字段名。这样的字段称为匿名字段（Anonymous Field）。  

以下代码创建一个 `Person` 结构体，它含有两个匿名字段 `string` 和 `int`。  

```go
type Person struct {  
    string
    int
}
```

我们接下来使用匿名字段来编写一个程序。  

```go
package main

import (  
    "fmt"
)

type Person struct {  
    string
    int
}

func main() {  
    p := Person{"Naveen", 50}
    fmt.Println(p)
}
```

[在线运行程序](https://play.golang.org/p/YF-DgdVSrC)  

在上面的程序中，结构体 `Person` 有两个匿名字段。`p := Person{"Naveen", 50}` 定义了一个 `Person` 类型的变量。该程序输出 `{Naveen 50}`。  

**虽然匿名字段没有名称，但其实匿名字段的名称就默认为它的类型**。比如在上面的 `Person` 结构体里，虽说字段是匿名的，但 Go 默认这些字段名是它们各自的类型。所以 `Person` 结构体有两个名为 `string` 和 `int` 的字段。  

```go
package main

import (  
    "fmt"
)

type Person struct {  
    string
    int
}

func main() {  
    var p1 Person
    p1.string = "naveen"
    p1.int = 50
    fmt.Println(p1)
}
```

[在线运行程序](https://play.golang.org/p/K-fGNxVyiA)  

在上面程序的第 14 行和第 15 行，我们访问了 `Person` 结构体的匿名字段，我们把字段类型作为字段名，分别为 "string" 和 "int"。上面程序的输出如下：  

```
{naveen 50}
```

### 嵌套结构体（Nested Structs）

结构体的字段有可能也是一个结构体。这样的结构体称为嵌套结构体。  

```go
package main

import (  
    "fmt"
)

type Address struct {  
    city, state string
}
type Person struct {  
    name string
    age int
    address Address
}

func main() {  
    var p Person
    p.name = "Naveen"
    p.age = 50
    p.address = Address {
        city: "Chicago",
        state: "Illinois",
    }
    fmt.Println("Name:", p.name)
    fmt.Println("Age:",p.age)
    fmt.Println("City:",p.address.city)
    fmt.Println("State:",p.address.state)
}
```

[在线运行程序](https://play.golang.org/p/46jkQFdTPO)  

上面的结构体 `Person` 有一个字段 `address`，而 `address` 也是结构体。该程序输出：  

```
Name: Naveen  
Age: 50  
City: Chicago  
State: Illinois
```

### 提升字段（Promoted Fields）

如果是结构体中有匿名的结构体类型字段，则该匿名结构体里的字段就称为提升字段。这是因为提升字段就像是属于外部结构体一样，可以用外部结构体直接访问。我知道这种定义很复杂，所以我们直接研究下代码来理解吧。  

```go
type Address struct {  
    city, state string
}
type Person struct {  
    name string
    age  int
    Address
}
```

在上面的代码片段中，`Person` 结构体有一个匿名字段 `Address`，而 `Address` 是一个结构体。现在结构体 `Address` 有 `city` 和 `state` 两个字段，访问这两个字段就像在 `Person` 里直接声明的一样，因此我们称之为提升字段。

```go
package main

import (
    "fmt"
)

type Address struct {
    city, state string
}
type Person struct {
    name string
    age  int
    Address
}

func main() {  
    var p Person
    p.name = "Naveen"
    p.age = 50
    p.Address = Address{
        city:  "Chicago",
        state: "Illinois",
    }
    fmt.Println("Name:", p.name)
    fmt.Println("Age:", p.age)
    fmt.Println("City:", p.city) //city is promoted field
    fmt.Println("State:", p.state) //state is promoted field
}
```

[在线运行程序](https://play.golang.org/p/OgeHCJYoEy)  

在上面代码中的第 26 行和第 27 行，我们使用了语法 `p.city` 和 `p.state`，访问提升字段 `city` 和 `state` 就像它们是在结构体 `p` 中声明的一样。该程序会输出：

```
Name: Naveen  
Age: 50  
City: Chicago  
State: Illinois
```

### 导出结构体和字段

如果结构体名称以大写字母开头，则它是其他包可以访问的导出类型（Exported Type）。同样，如果结构体里的字段首字母大写，它也能被其他包访问到。  

让我们使用自定义包，编写一个程序来更好地去理解它。  

在你的 Go 工作区的 `src` 目录中，创建一个名为 `structs` 的文件夹。另外在 `structs` 中再创建一个目录 `computer`。  

在 `computer` 目录中，在名为 `spec.go` 的文件中保存下面的程序。  

```go
package computer

type Spec struct { //exported struct  
    Maker string //exported field
    model string //unexported field
    Price int //exported field
}
```

上面的代码片段中，创建了一个 `computer` 包，里面有一个导出结构体类型 `Spec`。`Spec` 有两个导出字段 `Maker` 和 `Price`，和一个未导出的字段 `model`。接下来我们会在 main 包中导入这个包，并使用 `Spec` 结构体。

```go
package main

import "structs/computer"  
import "fmt"

func main() {  
    var spec computer.Spec
    spec.Maker = "apple"
    spec.Price = 50000
    fmt.Println("Spec:", spec)
}
```

包结构如下所示：  

```
src  
   structs
        computer
            spec.go
        main.go
```

在上述程序的第 3 行，我们导入了 `computer` 包。在第 8 行和第 9 行，我们访问了结构体 `Spec` 的两个导出字段 `Maker` 和 `Price`。执行命令 `go install structs` 和 `workspacepath/bin/structs`，运行该程序。  

如果我们试图访问未导出的字段 `model`，编译器会报错。将 `main.go` 的内容替换为下面的代码。  

```go
package main

import "structs/computer"  
import "fmt"

func main() {  
    var spec computer.Spec
    spec.Maker = "apple"
    spec.Price = 50000
    spec.model = "Mac Mini"
    fmt.Println("Spec:", spec)
}
```

在上面程序的第 10 行，我们试图访问未导出的字段 `model`。如果运行这个程序，编译器会产生错误：**spec.model undefined (cannot refer to unexported field or method model)**。  

### 结构体相等性（Structs Equality）

**结构体是值类型。如果它的每一个字段都是可比较的，则该结构体也是可比较的。如果两个结构体变量的对应字段相等，则这两个变量也是相等的**。

```go
package main

import (  
    "fmt"
)

type name struct {  
    firstName string
    lastName string
}


func main() {  
    name1 := name{"Steve", "Jobs"}
    name2 := name{"Steve", "Jobs"}
    if name1 == name2 {
        fmt.Println("name1 and name2 are equal")
    } else {
        fmt.Println("name1 and name2 are not equal")
    }

    name3 := name{firstName:"Steve", lastName:"Jobs"}
    name4 := name{}
    name4.firstName = "Steve"
    if name3 == name4 {
        fmt.Println("name3 and name4 are equal")
    } else {
        fmt.Println("name3 and name4 are not equal")
    }
}
```

[在线运行程序](https://play.golang.org/p/AU1FkdsPk7)  

在上面的代码中，结构体类型 `name` 包含两个 `string` 类型。由于字符串是可比较的，因此可以比较两个 `name` 类型的结构体变量。  

上面代码中 `name1` 和 `name2` 相等，而 `name3` 和 `name4` 不相等。该程序会输出：  

```
name1 and name2 are equal  
name3 and name4 are not equal
```

**如果结构体包含不可比较的字段，则结构体变量也不可比较。**  

```go
package main

import (  
    "fmt"
)

type image struct {  
    data map[int]int
}

func main() {  
    image1 := image{data: map[int]int{
        0: 155,
    }}
    image2 := image{data: map[int]int{
        0: 155,
    }}
    if image1 == image2 {
        fmt.Println("image1 and image2 are equal")
    }
}
```

[在线运行程序](https://play.golang.org/p/T4svXOTYSg)  

在上面代码中，结构体类型 `image` 包含一个 `map` 类型的字段。由于 `map` 类型是不可比较的，因此 `image1` 和 `image2` 也不可比较。如果运行该程序，编译器会报错：**`main.go:18: invalid operation: image1 == image2 (struct containing map[int]int cannot be compared)`**。  

[github](https://github.com/golangbot/structs) 上有本教程的源代码。  

# 17. 方法 				

​					 					[MDGSF](https://studygolang.com/gctt/MDGSF) 				 					 · 2018-01-22 18:00:02 · 26117 次点击 · 					预计阅读时间 11 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-01-22 18:00:02 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2) 的第 17 个教程。

### 什么是方法？

方法其实就是一个函数，在 `func` 这个关键字和方法名中间加入了一个特殊的接收器类型。接收器可以是结构体类型或者是非结构体类型。接收器是可以在方法的内部访问的。

下面就是创建一个方法的语法。

```go
func (t Type) methodName(parameter list) {
}
```

上面的代码片段创建了一个接收器类型为 `Type` 的方法 `methodName`。

### 方法示例

让我们来编写一个简单的小程序，它会在结构体类型上创建一个方法并调用它。

```go
package main

import (
    "fmt"
)

type Employee struct {
    name     string
    salary   int
    currency string
}

/*
  displaySalary() 方法将 Employee 做为接收器类型
*/
func (e Employee) displaySalary() {
    fmt.Printf("Salary of %s is %s%d", e.name, e.currency, e.salary)
}

func main() {
    emp1 := Employee {
        name:     "Sam Adolf",
        salary:   5000,
        currency: "$",
    }
    emp1.displaySalary() // 调用 Employee 类型的 displaySalary() 方法
}
```

[在线运行程序](https://play.golang.org/p/rRsI_sWAOZ)

在上面程序的第 16 行，我们在 `Employee` 结构体类型上创建了一个 `displaySalary` 方法。displaySalary()方法在方法的内部访问了接收器 `e Employee`。在第 17 行，我们使用接收器 `e`，并打印 employee 的 name、currency 和 salary 这 3 个字段。

在第 26 行，我们调用了方法 `emp1.displaySalary()`。

程序输出：`Salary of Sam Adolf is $5000`。

### 为什么我们已经有函数了还需要方法呢？

上面的程序已经被重写为只使用函数，没有方法。

```go
package main

import (
    "fmt"
)

type Employee struct {
    name     string
    salary   int
    currency string
}

/*
displaySalary()方法被转化为一个函数，把 Employee 当做参数传入。
*/
func displaySalary(e Employee) {
    fmt.Printf("Salary of %s is %s%d", e.name, e.currency, e.salary)
}

func main() {
    emp1 := Employee{
        name:     "Sam Adolf",
        salary:   5000,
        currency: "$",
    }
    displaySalary(emp1)
}
```

[在线运行程序](https://play.golang.org/p/dFwObgCUU0)

在上面的程序中，`displaySalary` 方法被转化为一个函数，`Employee` 结构体被当做参数传递给它。这个程序也产生完全相同的输出：`Salary of Sam Adolf is $5000`。

既然我们可以使用函数写出相同的程序，那么为什么我们需要方法？这有着几个原因，让我们一个个的看看。

- [ Go 不是纯粹的面向对象编程语言](https://golang.org/doc/faq#Is_Go_an_object-oriented_language)，而且Go不支持类。因此，基于类型的方法是一种实现和类相似行为的途径。
- 相同的名字的方法可以定义在不同的类型上，而相同名字的函数是不被允许的。假设我们有一个 `Square` 和 `Circle` 结构体。可以在 `Square` 和 `Circle` 上分别定义一个 `Area` 方法。见下面的程序。

```go
package main

import (
    "fmt"
    "math"
)

type Rectangle struct {
    length int
    width  int
}

type Circle struct {
    radius float64
}

func (r Rectangle) Area() int {
    return r.length * r.width
}

func (c Circle) Area() float64 {
    return math.Pi * c.radius * c.radius
}

func main() {
    r := Rectangle{
        length: 10,
        width:  5,
    }
    fmt.Printf("Area of rectangle %d\n", r.Area())
    c := Circle{
        radius: 12,
    }
    fmt.Printf("Area of circle %f", c.Area())
}
```

[在线运行程序](https://play.golang.org/p/0hDM3E3LiP)

该程序输出：

```
Area of rectangle 50
Area of circle 452.389342
```

上面方法的属性被使用在接口中。我们将在接下来的教程中讨论这个问题。

### 指针接收器与值接收器

到目前为止，我们只看到了使用值接收器的方法。还可以创建使用指针接收器的方法。值接收器和指针接收器之间的区别在于，在指针接收器的方法内部的改变对于调用者是可见的，然而值接收器的情况不是这样的。让我们用下面的程序来帮助理解这一点。

```go
package main

import (
    "fmt"
)

type Employee struct {
    name string
    age  int
}

/*
使用值接收器的方法。
*/
func (e Employee) changeName(newName string) {
    e.name = newName
}

/*
使用指针接收器的方法。
*/
func (e *Employee) changeAge(newAge int) {
    e.age = newAge
}

func main() {
    e := Employee{
        name: "Mark Andrew",
        age:  50,
    }
    fmt.Printf("Employee name before change: %s", e.name)
    e.changeName("Michael Andrew")
    fmt.Printf("\nEmployee name after change: %s", e.name)

    fmt.Printf("\n\nEmployee age before change: %d", e.age)
    (&e).changeAge(51)
    fmt.Printf("\nEmployee age after change: %d", e.age)
}
```

[在线运行程序](https://play.golang.org/p/tTO100HmUX)

在上面的程序中，`changeName` 方法有一个值接收器 `(e Employee)`，而 `changeAge` 方法有一个指针接收器 `(e *Employee)`。在 `changeName` 方法中对 `Employee` 结构体的字段 `name` 所做的改变对调用者是不可见的，因此程序在调用 `e.changeName("Michael Andrew")` 这个方法的前后打印出相同的名字。由于 `changeAge` 方法是使用指针 `(e *Employee)` 接收器的，所以在调用 `(&e).changeAge(51)` 方法对 `age` 字段做出的改变对调用者将是可见的。该程序输出如下：

```
Employee name before change: Mark Andrew
Employee name after change: Mark Andrew

Employee age before change: 50
Employee age after change: 51
```

在上面程序的第 36 行，我们使用 `(&e).changeAge(51)` 来调用 `changeAge` 方法。由于 `changeAge` 方法有一个指针接收器，所以我们使用 `(&e)` 来调用这个方法。其实没有这个必要，Go语言让我们可以直接使用 `e.changeAge(51)`。`e.changeAge(51)` 会自动被Go语言解释为 `(&e).changeAge(51)`。

下面的[程序](https://play.golang.org/p/nnXBsR3Uc8)重写了，使用 `e.changeAge(51)` 来代替 `(&e).changeAge(51)`，它输出相同的结果。

```go
package main

import (
    "fmt"
)

type Employee struct {
    name string
    age  int
}

/*
使用值接收器的方法。
*/
func (e Employee) changeName(newName string) {
    e.name = newName
}

/*
使用指针接收器的方法。
*/
func (e *Employee) changeAge(newAge int) {
    e.age = newAge
}

func main() {
    e := Employee{
        name: "Mark Andrew",
        age:  50,
    }
    fmt.Printf("Employee name before change: %s", e.name)
    e.changeName("Michael Andrew")
    fmt.Printf("\nEmployee name after change: %s", e.name)

    fmt.Printf("\n\nEmployee age before change: %d", e.age)
    e.changeAge(51)
    fmt.Printf("\nEmployee age after change: %d", e.age)
}
```

[在线运行程序](https://play.golang.org/p/nnXBsR3Uc8)

### 那么什么时候使用指针接收器，什么时候使用值接收器？

一般来说，指针接收器可以使用在：对方法内部的接收器所做的改变应该对调用者可见时。

指针接收器也可以被使用在如下场景：当拷贝一个结构体的代价过于昂贵时。考虑下一个结构体有很多的字段。在方法内使用这个结构体做为值接收器需要拷贝整个结构体，这是很昂贵的。在这种情况下使用指针接收器，结构体不会被拷贝，只会传递一个指针到方法内部使用。

在其他的所有情况，值接收器都可以被使用。

### 匿名字段的方法

属于结构体的匿名字段的方法可以被直接调用，就好像这些方法是属于定义了匿名字段的结构体一样。

```go
package main

import (
    "fmt"
)

type address struct {
    city  string
    state string
}

func (a address) fullAddress() {
    fmt.Printf("Full address: %s, %s", a.city, a.state)
}

type person struct {
    firstName string
    lastName  string
    address
}

func main() {
    p := person{
        firstName: "Elon",
        lastName:  "Musk",
        address: address {
            city:  "Los Angeles",
            state: "California",
        },
    }

    p.fullAddress() //访问 address 结构体的 fullAddress 方法
}
```

[在线运行程序](https://play.golang.org/p/vURnImw4_9)

在上面程序的第 32 行，我们通过使用 `p.fullAddress()` 来访问 `address` 结构体的 `fullAddress()` 方法。明确的调用 `p.address.fullAddress()` 是没有必要的。该程序输出：

```
Full address: Los Angeles, California
```

### 在方法中使用值接收器 与 在函数中使用值参数

这个话题很多Go语言新手都弄不明白。我会尽量讲清楚。

当一个函数有一个值参数，它只能接受一个值参数。

当一个方法有一个值接收器，它可以接受值接收器和指针接收器。

让我们通过一个例子来理解这一点。

```go
package main

import (
    "fmt"
)

type rectangle struct {
    length int
    width  int
}

func area(r rectangle) {
    fmt.Printf("Area Function result: %d\n", (r.length * r.width))
}

func (r rectangle) area() {
    fmt.Printf("Area Method result: %d\n", (r.length * r.width))
}

func main() {
    r := rectangle{
        length: 10,
        width:  5,
    }
    area(r)
    r.area()

    p := &r
    /*
       compilation error, cannot use p (type *rectangle) as type rectangle
       in argument to area
    */
    //area(p)

    p.area()//通过指针调用值接收器
}
```

[在线运行程序](https://play.golang.org/p/gLyHMd2iie)

第 12 行的函数 `func area(r rectangle)` 接受一个值参数，方法 `func (r rectangle) area()` 接受一个值接收器。

在第 25 行，我们通过值参数 `area(r)` 来调用 area 这个函数，这是合法的。同样，我们使用值接收器来调用 area 方法 `r.area()`，这也是合法的。

在第 28 行，我们创建了一个指向 `r` 的指针 `p`。如果我们试图把这个指针传递到只能接受一个值参数的函数 area，编译器将会报错。所以我把代码的第 33 行注释了。如果你把这行的代码注释去掉，编译器将会抛出错误 `compilation error, cannot use p (type *rectangle) as type rectangle in argument to area.`。这将会按预期抛出错误。

现在到了棘手的部分了，在第35行的代码 `p.area()` 使用指针接收器 `p` 调用了只接受一个值接收器的方法 `area`。这是完全有效的。原因是当 `area` 有一个值接收器时，为了方便Go语言把 `p.area()` 解释为 `(*p).area()`。

该程序将会输出：

```
Area Function result: 50
Area Method result: 50
Area Method result: 50
```

### 在方法中使用指针接收器 与 在函数中使用指针参数

和值参数相类似，函数使用指针参数只接受指针，而使用指针接收器的方法可以使用值接收器和指针接收器。

```go
package main

import (
    "fmt"
)

type rectangle struct {
    length int
    width  int
}

func perimeter(r *rectangle) {
    fmt.Println("perimeter function output:", 2*(r.length+r.width))

}

func (r *rectangle) perimeter() {
    fmt.Println("perimeter method output:", 2*(r.length+r.width))
}

func main() {
    r := rectangle{
        length: 10,
        width:  5,
    }
    p := &r //pointer to r
    perimeter(p)
    p.perimeter()

    /*
        cannot use r (type rectangle) as type *rectangle in argument to perimeter
    */
    //perimeter(r)

    r.perimeter()//使用值来调用指针接收器
}
```

[在线运行程序](https://play.golang.org/p/Xy5wW9YZMJ)

在上面程序的第 12 行，定义了一个接受指针参数的函数 `perimeter`。第 17 行定义了一个有一个指针接收器的方法。

在第 27 行，我们调用 perimeter 函数时传入了一个指针参数。在第 28 行，我们通过指针接收器调用了 perimeter 方法。所有一切看起来都这么完美。

在被注释掉的第 33 行，我们尝试通过传入值参数 `r` 调用函数 `perimeter`。这是不被允许的，因为函数的指针参数不接受值参数。如果你把这行的代码注释去掉并把程序运行起来，编译器将会抛出错误 `main.go:33: cannot use r (type rectangle) as type *rectangle in argument to perimeter.`。

在第 35 行，我们通过值接收器 `r` 来调用有指针接收器的方法 `perimeter`。这是被允许的，为了方便Go语言把代码 `r.perimeter()` 解释为 `(&r).perimeter()`。该程序输出：

```
perimeter function output: 30
perimeter method output: 30
perimeter method output: 30
```

### 在非结构体上的方法

到目前为止，我们只在结构体类型上定义方法。也可以在非结构体类型上定义方法，但是有一个问题。**为了在一个类型上定义一个方法，方法的接收器类型定义和方法的定义应该在同一个包中。到目前为止，我们定义的所有结构体和结构体上的方法都是在同一个 `main` 包中，因此它们是可以运行的。**

```go
package main

func (a int) add(b int) {
}

func main() {

}
```

[在线运行程序](https://play.golang.org/p/ybXLf5o_lA)

在上面程序的第 3 行，我们尝试把一个 `add` 方法添加到内置的类型 `int`。这是不允许的，因为 `add` 方法的定义和 `int` 类型的定义不在同一个包中。该程序会抛出编译错误 `cannot define new methods on non-local type int`。

让该程序工作的方法是为内置类型 int 创建一个类型别名，然后创建一个以该类型别名为接收器的方法。

```go
package main

import "fmt"

type myInt int

func (a myInt) add(b myInt) myInt {
    return a + b
}

func main() {
    num1 := myInt(5)
    num2 := myInt(10)
    sum := num1.add(num2)
    fmt.Println("Sum is", sum)
}
```

[在线运行程序](https://play.golang.org/p/sTe7i1qAng)

在上面程序的第5行，我们为 `int` 创建了一个类型别名 `myInt`。在第7行，我们定义了一个以 `myInt` 为接收器的的方法 `add`。

该程序将会打印出 `Sum is 15`。

我已经创建了一个程序，包含了我们迄今为止所讨论的所有概念，详见[github](https://github.com/golangbot/methods)。

这就是Go中的方法。祝你有美好的一天。

# 18. 接口（一） 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-01-22 20:09:55 · 28271 次点击 · 					预计阅读时间 10 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-01-22 20:09:55 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 18 个教程。接口共有两个教程，这是我们接口的第一个教程。  

### 什么是接口？

在面向对象的领域里，接口一般这样定义：**接口定义一个对象的行为**。接口只指定了对象应该做什么，至于如何实现这个行为（即实现细节），则由对象本身去确定。  

在 Go 语言中，接口就是方法签名（Method Signature）的集合。当一个类型定义了接口中的所有方法，我们称它实现了该接口。这与面向对象编程（OOP）的说法很类似。**接口指定了一个类型应该具有的方法，并由该类型决定如何实现这些方法**。  

例如，`WashingMachine` 是一个含有 `Cleaning()` 和 `Drying()` 两个方法的接口。任何定义了 `Cleaning()` 和 `Drying()` 的类型，都称它实现了 `WashingMachine` 接口。  

### 接口的声明与实现

让我们编写代码，创建一个接口并且实现它。

```go
package main

import (  
    "fmt"
)

//interface definition
type VowelsFinder interface {  
    FindVowels() []rune
}

type MyString string

//MyString implements VowelsFinder
func (ms MyString) FindVowels() []rune {  
    var vowels []rune
    for _, rune := range ms {
        if rune == 'a' || rune == 'e' || rune == 'i' || rune == 'o' || rune == 'u' {
            vowels = append(vowels, rune)
        }
    }
    return vowels
}

func main() {  
    name := MyString("Sam Anderson")
    var v VowelsFinder
    v = name // possible since MyString implements VowelsFinder
    fmt.Printf("Vowels are %c", v.FindVowels())

}
```

[在线运行程序](https://play.golang.org/p/F-T3S_wNNB)  

在上面程序的第 8 行，创建了一个名为 `VowelsFinder` 的接口，该接口有一个 `FindVowels() []rune` 的方法。  

在接下来的一行，我们创建了一个 `MyString` 类型。  

**在第 15 行，我们给接受者类型（Receiver Type） `MyString` 添加了方法 `FindVowels() []rune`。现在，我们称 `MyString` 实现了 `VowelsFinder` 接口。这就和其他语言（如 Java）很不同，其他一些语言要求一个类使用 `implement` 关键字，来显式地声明该类实现了接口。而在 Go 中，并不需要这样。如果一个类型包含了接口中声明的所有方法，那么它就隐式地实现了 Go 接口**。  

在第 28 行，`v` 的类型为 `VowelsFinder`，`name` 的类型为 `MyString`，我们把 `name` 赋值给了 `v`。由于 `MyString` 实现了 `VowelFinder`，因此这是合法的。在下一行，`v.FindVowels()` 调用了 `MyString` 类型的 `FindVowels` 方法，打印字符串 `Sam Anderson` 里所有的元音。该程序输出 `Vowels are [a e o]`。  

祝贺！你已经创建并实现了你的第一个接口。  

### 接口的实际用途

前面的例子教我们创建并实现了接口，但还没有告诉我们接口的实际用途。在上面的程序里，如果我们使用 `name.FindVowels()`，而不是 `v.FindVowels()`，程序依然能够照常运行，但接口并没有体现出实际价值。  

因此，我们现在讨论一下接口的实际应用场景。  

我们编写一个简单程序，根据公司员工的个人薪资，计算公司的总支出。为了简单起见，我们假定支出的单位都是美元。  

```go
package main

import (  
    "fmt"
)

type SalaryCalculator interface {  
    CalculateSalary() int
}

type Permanent struct {  
    empId    int
    basicpay int
    pf       int
}

type Contract struct {  
    empId  int
    basicpay int
}

//salary of permanent employee is sum of basic pay and pf
func (p Permanent) CalculateSalary() int {  
    return p.basicpay + p.pf
}

//salary of contract employee is the basic pay alone
func (c Contract) CalculateSalary() int {  
    return c.basicpay
}

/*
total expense is calculated by iterating though the SalaryCalculator slice and summing  
the salaries of the individual employees  
*/
func totalExpense(s []SalaryCalculator) {  
    expense := 0
    for _, v := range s {
        expense = expense + v.CalculateSalary()
    }
    fmt.Printf("Total Expense Per Month $%d", expense)
}

func main() {  
    pemp1 := Permanent{1, 5000, 20}
    pemp2 := Permanent{2, 6000, 30}
    cemp1 := Contract{3, 3000}
    employees := []SalaryCalculator{pemp1, pemp2, cemp1}
    totalExpense(employees)

}
```

[在线运行程序](https://play.golang.org/p/5t6GgQ2TSU)  

上面程序的第 7 行声明了一个 `SalaryCalculator` 接口类型，它只有一个方法 `CalculateSalary() int`。  

在公司里，我们有两类员工，即第 11 行和第 17 行定义的结构体：`Permanent` 和 `Contract`。长期员工（`Permanent`）的薪资是 `basicpay` 与 `pf` 相加之和，而合同员工（`Contract`）只有基本工资 `basicpay`。在第 23 行和第 28 行中，方法 `CalculateSalary` 分别实现了以上关系。由于 `Permanent` 和 `Contract` 都声明了该方法，因此它们都实现了 `SalaryCalculator` 接口。  

第 36 行声明的 `totalExpense` 方法体现出了接口的妙用。该方法接收一个 `SalaryCalculator` 接口的切片（`[]SalaryCalculator`）作为参数。在第 49 行，我们向 `totalExpense` 方法传递了一个包含 `Permanent` 和 `Contact` 类型的切片。在第 39 行中，通过调用不同类型对应的 `CalculateSalary` 方法，`totalExpense` 可以计算得到支出。  

这样做最大的优点是：`totalExpense` 可以扩展新的员工类型，而不需要修改任何代码。假如公司增加了一种新的员工类型 `Freelancer`，它有着不同的薪资结构。`Freelancer`只需传递到 `totalExpense` 的切片参数中，无需 `totalExpense` 方法本身进行修改。只要 `Freelancer` 也实现了 `SalaryCalculator` 接口，`totalExpense` 就能够实现其功能。  

该程序输出 `Total Expense Per Month $14050`。  

### 接口的内部表示

我们可以把接口看作内部的一个元组 `(type, value)`。 `type` 是接口底层的具体类型（Concrete Type），而 `value` 是具体类型的值。  

我们编写一个程序来更好地理解它。  

```go
package main

import (  
    "fmt"
)

type Test interface {  
    Tester()
}

type MyFloat float64

func (m MyFloat) Tester() {  
    fmt.Println(m)
}

func describe(t Test) {  
    fmt.Printf("Interface type %T value %v\n", t, t)
}

func main() {  
    var t Test
    f := MyFloat(89.7)
    t = f
    describe(t)
    t.Tester()
}
```

[在线运行程序](https://play.golang.org/p/Q40Omtewlh)  

`Test` 接口只有一个方法 `Tester()`，而 `MyFloat` 类型实现了该接口。在第 24 行，我们把变量 `f`（`MyFloat` 类型）赋值给了 `t`（`Test` 类型）。现在 `t` 的具体类型为 `MyFloat`，而 `t` 的值为 `89.7`。第 17 行的 `describe` 函数打印出了接口的具体类型和值。该程序输出：  

```
Interface type main.MyFloat value 89.7  
89.7
```

### 空接口

没有包含方法的接口称为空接口。空接口表示为 `interface{}`。由于空接口没有方法，因此所有类型都实现了空接口。  

```go
package main

import (  
    "fmt"
)

func describe(i interface{}) {  
    fmt.Printf("Type = %T, value = %v\n", i, i)
}

func main() {  
    s := "Hello World"
    describe(s)
    i := 55
    describe(i)
    strt := struct {
        name string
    }{
        name: "Naveen R",
    }
    describe(strt)
}
```

[在线运行程序](https://play.golang.org/p/Fm5KescoJb)  

在上面的程序的第 7 行，`describe(i interface{})` 函数接收空接口作为参数，因此，可以给这个函数传递任何类型。  

在第 13 行、第 15 行和第 21 行，我们分别给 `describe` 函数传递了 `string`、`int` 和 `struct`。该程序打印：  

```
Type = string, value = Hello World  
Type = int, value = 55  
Type = struct { name string }, value = {Naveen R}
```

### 类型断言

类型断言用于提取接口的底层值（Underlying Value）。  

在语法 `i.(T)` 中，接口 `i` 的具体类型是 `T`，该语法用于获得接口的底层值。  

一段代码胜过千言。下面编写个关于类型断言的程序。  

```go
package main

import (  
    "fmt"
)

func assert(i interface{}) {  
    s := i.(int) //get the underlying int value from i
    fmt.Println(s)
}
func main() {  
    var s interface{} = 56
    assert(s)
}
```

[在线运行程序](https://play.golang.org/p/YstKXEeSBL)  

在第 12 行，`s` 的具体类型是 `int`。在第 8 行，我们使用了语法 `i.(int)` 来提取 `i` 的底层 int 值。该程序会打印 `56`。  

在上面程序中，如果具体类型不是 int，会发生什么呢？接下来看看。  

```go
package main

import (  
    "fmt"
)

func assert(i interface{}) {  
    s := i.(int) 
    fmt.Println(s)
}
func main() {  
    var s interface{} = "Steven Paul"
    assert(s)
}
```

[在线运行程序](https://play.golang.org/p/88KflSceHK)  

在上面程序中，我们把具体类型为 `string` 的 `s` 传递给了 `assert` 函数，试图从它提取出 int 值。该程序会报错：`panic: interface conversion: interface {} is string, not int.`。  

要解决该问题，我们可以使用以下语法：  

```go
v, ok := i.(T)
```

如果 `i` 的具体类型是 `T`，那么 `v` 赋值为 `i` 的底层值，而 `ok` 赋值为 `true`。  

如果 `i` 的具体类型不是 `T`，那么 `ok` 赋值为 `false`，`v` 赋值为 `T` 类型的零值，**此时程序不会报错**。  

```go
package main

import (  
    "fmt"
)

func assert(i interface{}) {  
    v, ok := i.(int)
    fmt.Println(v, ok)
}
func main() {  
    var s interface{} = 56
    assert(s)
    var i interface{} = "Steven Paul"
    assert(i)
}
```

[在线运行程序](https://play.golang.org/p/0sB-KlVw8A)  

当给 `assert` 函数传递 `Steven Paul` 时，由于 `i` 的具体类型不是 `int`，`ok` 赋值为 `false`，而 `v` 赋值为 0（int 的零值）。该程序打印：  

```
56 true  
0 false
```

### 类型选择（Type Switch）

类型选择用于将接口的具体类型与很多 case 语句所指定的类型进行比较。它与一般的 switch 语句类似。唯一的区别在于类型选择指定的是类型，而一般的 switch 指定的是值。  

类型选择的语法类似于类型断言。类型断言的语法是 `i.(T)`，而对于类型选择，类型 `T` 由关键字 `type` 代替。下面看看程序是如何工作的。  

```go
package main

import (  
    "fmt"
)

func findType(i interface{}) {  
    switch i.(type) {
    case string:
        fmt.Printf("I am a string and my value is %s\n", i.(string))
    case int:
        fmt.Printf("I am an int and my value is %d\n", i.(int))
    default:
        fmt.Printf("Unknown type\n")
    }
}
func main() {  
    findType("Naveen")
    findType(77)
    findType(89.98)
}
```

[在线运行程序](https://play.golang.org/p/XYPDwOvoCh)  

在上述程序的第 8 行，`switch i.(type)` 表示一个类型选择。每个 case 语句都把 `i` 的具体类型和一个指定类型进行了比较。如果 case 匹配成功，会打印出相应的语句。该程序输出：  

```
I am a string and my value is Naveen  
I am an int and my value is 77  
Unknown type
```

第 20 行中的 `89.98` 的类型是 `float64`，没有在 case 上匹配成功，因此最后一行打印了 `Unknown type`。  

**还可以将一个类型和接口相比较。如果一个类型实现了接口，那么该类型与其实现的接口就可以互相比较**。  

为了阐明这一点，下面写一个程序。  

```go
package main

import "fmt"

type Describer interface {  
    Describe()
}
type Person struct {  
    name string
    age  int
}

func (p Person) Describe() {  
    fmt.Printf("%s is %d years old", p.name, p.age)
}

func findType(i interface{}) {  
    switch v := i.(type) {
    case Describer:
        v.Describe()
    default:
        fmt.Printf("unknown type\n")
    }
}

func main() {  
    findType("Naveen")
    p := Person{
        name: "Naveen R",
        age:  25,
    }
    findType(p)
}
```

[在线运行程序](https://play.golang.org/p/o6aHzIz4wC)  

在上面程序中，结构体 `Person` 实现了 `Describer` 接口。在第 19 行的 case 语句中，`v` 与接口类型 `Describer` 进行了比较。`p` 实现了 `Describer`，因此满足了该 case 语句，于是当程序运行到第 32 行的 `findType(p)` 时，程序调用了 `Describe()` 方法。  

该程序输出：

```
unknown type  
Naveen R is 25 years old
```

接口（一）的内容到此结束。在接口（二）中我们还会继续讨论接口。祝您愉快！  

**上一教程 - [方法](https://studygolang.com/articles/12264)**

# 19. 接口（二） 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-02-01 15:44:37 · 18574 次点击 · 					预计阅读时间 7 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-02-01 15:44:37 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 19 个教程。接口共有两个教程，这是我们第二个教程。如果你还没有阅读前面的教程，请你阅读[接口（一）](https://studygolang.com/articles/12266)。

### 实现接口：指针接受者与值接受者

在[接口（一）](https://studygolang.com/articles/12266)上的所有示例中，我们都是使用值接受者（Value Receiver）来实现接口的。我们同样可以使用指针接受者（Pointer Receiver）来实现接口。只不过在用指针接受者实现接口时，还有一些细节需要注意。我们通过下面的代码来理解吧。 

```go
package main

import "fmt"

type Describer interface {  
    Describe()
}
type Person struct {  
    name string
    age  int
}

func (p Person) Describe() { // 使用值接受者实现  
    fmt.Printf("%s is %d years old\n", p.name, p.age)
}

type Address struct {
    state   string
    country string
}

func (a *Address) Describe() { // 使用指针接受者实现
    fmt.Printf("State %s Country %s", a.state, a.country)
}

func main() {  
    var d1 Describer
    p1 := Person{"Sam", 25}
    d1 = p1
    d1.Describe()
    p2 := Person{"James", 32}
    d1 = &p2
    d1.Describe()

    var d2 Describer
    a := Address{"Washington", "USA"}

    /* 如果下面一行取消注释会导致编译错误：
       cannot use a (type Address) as type Describer
       in assignment: Address does not implement
       Describer (Describe method has pointer
       receiver)
    */
    //d2 = a

    d2 = &a // 这是合法的
    // 因为在第 22 行，Address 类型的指针实现了 Describer 接口
    d2.Describe()

}
```

[在线运行程序](https://play.golang.org/p/IzspYiAQ82)  

在上面程序中的第 13 行，结构体 `Person` 使用值接受者，实现了 `Describer` 接口。  

我们在讨论[方法](https://studygolang.com/articles/12264)的时候就已经提到过，使用值接受者声明的方法，既可以用值来调用，也能用指针调用。**不管是一个值，还是一个可以解引用的指针，调用这样的方法都是合法的**。

`p1` 的类型是 `Person`，在第 29 行，`p1` 赋值给了 `d1`。由于 `Person` 实现了接口变量 `d1`，因此在第 30 行，会打印 `Sam is 25 years old`。

接下来在第 32 行，`d1` 又赋值为 `&p2`，在第 33 行同样打印输出了 `James is 32 years old`。棒棒哒。:) 

在 22 行，结构体 `Address` 使用指针接受者实现了 `Describer` 接口。 

在上面程序里，如果去掉第 45 行的注释，我们会得到编译错误：`main.go:42: cannot use a (type  Address) as type Describer in assignment: Address does not implement  Describer (Describe method has pointer receiver)`。这是因为在第 22 行，我们使用 `Address` 类型的指针接受者实现了接口 `Describer`，而接下来我们试图用 `a` 来赋值 `d2`。然而 `a` 属于值类型，它并没有实现 `Describer` 接口。你应该会很惊讶，因为我们曾经学习过，使用指针接受者的[方法](https://studygolang.com/articles/12264)，无论指针还是值都可以调用它。那么为什么第 45 行的代码就不管用呢？

**其原因是：对于使用指针接受者的方法，用一个指针或者一个可取得地址的值来调用都是合法的。但接口中存储的具体值（Concrete Value）并不能取到地址，因此在第 45 行，对于编译器无法自动获取 `a` 的地址，于是程序报错**。  

第 47 行就可以成功运行，因为我们将 `a` 的地址 `&a` 赋值给了 `d2`。  

程序的其他部分不言而喻。该程序会打印：  

```
Sam is 25 years old  
James is 32 years old  
State Washington Country USA
```

### 实现多个接口

类型可以实现多个接口。我们看看下面程序是如何做到的。  

```go
package main

import (  
    "fmt"
)

type SalaryCalculator interface {  
    DisplaySalary()
}

type LeaveCalculator interface {  
    CalculateLeavesLeft() int
}

type Employee struct {  
    firstName string
    lastName string
    basicPay int
    pf int
    totalLeaves int
    leavesTaken int
}

func (e Employee) DisplaySalary() {  
    fmt.Printf("%s %s has salary $%d", e.firstName, e.lastName, (e.basicPay + e.pf))
}

func (e Employee) CalculateLeavesLeft() int {  
    return e.totalLeaves - e.leavesTaken
}

func main() {  
    e := Employee {
        firstName: "Naveen",
        lastName: "Ramanathan",
        basicPay: 5000,
        pf: 200,
        totalLeaves: 30,
        leavesTaken: 5,
    }
    var s SalaryCalculator = e
    s.DisplaySalary()
    var l LeaveCalculator = e
    fmt.Println("\nLeaves left =", l.CalculateLeavesLeft())
}
```

[在线运行程序](https://play.golang.org/p/DJxS5zxBcV)  

上述程序在第 7 行和第 11 行分别声明了两个接口：`SalaryCalculator` 和 `LeaveCalculator`。  

第 15 行定义了结构体 `Employee`，它在第 24 行实现了 `SalaryCalculator` 接口的 `DisplaySalary` 方法，接着在第 28 行又实现了 `LeaveCalculator` 接口里的 `CalculateLeavesLeft` 方法。于是 `Employee` 就实现了 `SalaryCalculator` 和 `LeaveCalculator` 两个接口。  

第 41 行，我们把 `e` 赋值给了 `SalaryCalculator` 类型的接口变量 ，而在 43 行，我们同样把 `e` 赋值给 `LeaveCalculator` 类型的接口变量 。由于 `e` 的类型 `Employee` 实现了 `SalaryCalculator` 和 `LeaveCalculator` 两个接口，因此这是合法的。  

该程序会输出：

```
Naveen Ramanathan has salary $5200  
Leaves left = 25
```

### 接口的嵌套

尽管 Go 语言没有提供继承机制，但可以通过嵌套其他的接口，创建一个新接口。  

我们来看看这如何实现。  

```go
package main

import (  
    "fmt"
)

type SalaryCalculator interface {  
    DisplaySalary()
}

type LeaveCalculator interface {  
    CalculateLeavesLeft() int
}

type EmployeeOperations interface {  
    SalaryCalculator
    LeaveCalculator
}

type Employee struct {  
    firstName string
    lastName string
    basicPay int
    pf int
    totalLeaves int
    leavesTaken int
}

func (e Employee) DisplaySalary() {  
    fmt.Printf("%s %s has salary $%d", e.firstName, e.lastName, (e.basicPay + e.pf))
}

func (e Employee) CalculateLeavesLeft() int {  
    return e.totalLeaves - e.leavesTaken
}

func main() {  
    e := Employee {
        firstName: "Naveen",
        lastName: "Ramanathan",
        basicPay: 5000,
        pf: 200,
        totalLeaves: 30,
        leavesTaken: 5,
    }
    var empOp EmployeeOperations = e
    empOp.DisplaySalary()
    fmt.Println("\nLeaves left =", empOp.CalculateLeavesLeft())
}
```

[在线运行程序](https://play.golang.org/p/Hia7D-WbZp)

在上述程序的第 15 行，我们创建了一个新的接口 `EmployeeOperations`，它嵌套了两个接口：`SalaryCalculator` 和 `LeaveCalculator`。

如果一个类型定义了 `SalaryCalculator` 和 `LeaveCalculator` 接口里包含的方法，我们就称该类型实现了 `EmployeeOperations` 接口。

在第 29 行和第 33 行，由于 `Employee` 结构体定义了 `DisplaySalary` 和 `CalculateLeavesLeft` 方法，因此它实现了接口 `EmployeeOperations`。

在 46 行，`empOp` 的类型是 `EmployeeOperations`，`e` 的类型是 `Employee`，我们把 `empOp` 赋值为 `e`。接下来的两行，`empOp` 调用了 `DisplaySalary()` 和 `CalculateLeavesLeft()` 方法。

该程序输出：

```
Naveen Ramanathan has salary $5200
Leaves left = 25
```

### 接口的零值

接口的零值是 `nil`。对于值为 `nil` 的接口，其底层值（Underlying Value）和具体类型（Concrete Type）都为 `nil`。

```go
package main

import "fmt"

type Describer interface {  
    Describe()
}

func main() {  
    var d1 Describer
    if d1 == nil {
        fmt.Printf("d1 is nil and has type %T value %v\n", d1, d1)
    }
}
```

[在线运行程序](https://play.golang.org/p/vwYHC6Y78H)  

上面程序里的 `d1` 等于 `nil`，程序会输出：

```
d1 is nil and has type <nil> value <nil>
```

对于值为 `nil` 的接口，由于没有底层值和具体类型，当我们试图调用它的方法时，程序会产生 `panic` 异常。

```go
package main

type Describer interface {
    Describe()
}

func main() {  
    var d1 Describer
    d1.Describe()
}
```

[在线运行程序](https://play.golang.org/p/rM-rY0uGTI)  

在上述程序中，`d1` 等于 `nil`，程序产生运行时错误 `panic`： **`panic: runtime error: invalid memory address or nil pointer dereference  [signal SIGSEGV: segmentation violation code=0xffffffff addr=0x0 pc=0xc8527]`** 。  

接口的介绍到此结束。祝你愉快。

**上一教程 - [接口 - I](https://studygolang.com/articles/12266)**

# 20. 并发入门 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-02-03 12:25:58 · 20981 次点击 · 					预计阅读时间 1 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-02-03 12:25:58 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到我们 [Golang 系列教程](https://studygolang.com/subject/2)的第 20 篇。  

**Go 是并发式语言，而不是并行式语言**。在讨论 Go 如何处理并发之前，我们必须理解何为并发，以及并发与并行的区别。  

## 并发是什么？

并发是指立即处理多个任务的能力。一个例子就能很好地说明这一点。  

我们可以想象一个人正在跑步。假如在他晨跑时，鞋带突然松了。于是他停下来，系一下鞋带，接下来继续跑。这个例子就是典型的并发。这个人能够一下搞定跑步和系鞋带两件事，即立即处理多个任务。  

## 并行是什么？并行和并发有何区别？

并行是指同时处理多个任务。这听起来和并发差不多，但其实完全不同。  

我们同样用这个跑步的例子来帮助理解。假如这个人在慢跑时，还在用他的 iPod 听着音乐。在这里，他是在跑步的同时听音乐，也就是同时处理多个任务。这称之为并行。  

## 从技术上看并发和并行

通过现实中的例子，我们已经明白了什么是并发，以及并发与并行的区别。作为一名极客，我们接下来从技术的角度来考察并发和并行。:)  

假如我们正在编写一个 web 浏览器。这个 web 浏览器有各种组件。其中两个分别是 web  页面的渲染区和从网上下载文件的下载器。假设我们已经构建好了浏览器代码，各个组件也都可以相互独立地运行（通过像 Java  里的线程，或者通过即将介绍的 Go 语言中的 [Go 协程](https://studygolang.com/articles/12342)来实现）。当浏览器在单核处理器中运行时，处理器会在浏览器的两个组件间进行上下文切换。它可能在一段时间内下载文件，转而又对用户请求的 web 页面进行渲染。这就是并发。并发的进程从不同的时间点开始，分别交替运行。在这里，就是在不同的时间点开始进行下载和渲染，并相互交替运行的。  

如果该浏览器在一个多核处理器上运行，此时下载文件的组件和渲染 HTML 的组件可能会在不同的核上同时运行。这称之为并行。  

![image](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/concurrency-parallelism-copy.png)

并行不一定会加快运行速度，因为并行运行的组件之间可能需要相互通信。在我们浏览器的例子里，当文件下载完成后，应当对用户进行提醒，比如弹出一个窗口。于是，在负责下载的组件和负责渲染用户界面的组件之间，就产生了通信。在并发系统上，这种通信开销很小。但在多核的并行系统上，组件间的通信开销就很高了。所以，并行不一定会加快运行速度！

## Go 对并发的支持

Go 编程语言原生支持并发。Go 使用 [Go 协程](https://studygolang.com/articles/12342)（Goroutine） 和信道（Channel）来处理并发。在接下来的教程里，我们还会详细介绍它们。  

并发的介绍到此结束。请留下你的反馈和评论。祝你愉快。  

# 21. Go 协程 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-02-03 12:28:28 · 37155 次点击 · 					预计阅读时间 4 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-02-03 12:28:28 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 21 篇。  

在前面的教程里，我们探讨了并发，以及并发与并行的区别。本教程则会介绍在 Go 语言里，如何使用 Go 协程（Goroutine）来实现并发。

## Go 协程是什么？

Go 协程是与其他函数或方法一起并发运行的函数或方法。Go 协程可以看作是轻量级线程。与线程相比，创建一个 Go 协程的成本很小。因此在 Go 应用中，常常会看到有数以千计的 Go 协程并发地运行。  

## Go 协程相比于线程的优势

- 相比线程而言，Go 协程的成本极低。堆栈大小只有若干 kb，并且可以根据应用的需求进行增减。而线程必须指定堆栈的大小，其堆栈是固定不变的。
- Go 协程会复用（Multiplex）数量更少的 OS 线程。即使程序有数以千计的 Go 协程，也可能只有一个线程。如果该线程中的某一  Go 协程发生了阻塞（比如说等待用户输入），那么系统会再创建一个 OS 线程，并把其余 Go 协程都移动到这个新的 OS  线程。所有这一切都在运行时进行，作为程序员，我们没有直接面临这些复杂的细节，而是有一个简洁的 API 来处理并发。  
- Go 协程使用信道（Channel）来进行通信。信道用于防止多个协程访问共享内存时发生竞态条件（Race Condition）。信道可以看作是 Go 协程之间通信的管道。我们会在下一教程详细讨论信道。

## 如何启动一个 Go 协程？

调用函数或者方法时，在前面加上关键字 `go`，可以让一个新的 Go 协程并发地运行。

让我们创建一个 Go 协程吧。

```go
package main

import (
    "fmt"
)

func hello() {
    fmt.Println("Hello world goroutine")
}
func main() {
    go hello()
    fmt.Println("main function")
}
```

[在线运行程序](https://play.golang.org/p/zC78_fc1Hn)

在第 11 行，`go hello()` 启动了一个新的 Go 协程。现在 `hello()` 函数与 `main()` 函数会并发地执行。主函数会运行在一个特有的 Go 协程上，它称为 Go 主协程（Main Goroutine）。

**运行一下程序，你会很惊讶！**

该程序只会输出文本 `main function`。我们启动的 Go 协程究竟出现了什么问题？要理解这一切，我们需要理解两个 Go 协程的主要性质。  

- **启动一个新的协程时，协程的调用会立即返回。与函数不同，程序控制不会去等待 Go 协程执行完毕。在调用 Go 协程之后，程序控制会立即返回到代码的下一行，忽略该协程的任何返回值。**  
- **如果希望运行其他 Go 协程，Go 主协程必须继续运行着。如果 Go 主协程终止，则程序终止，于是其他 Go 协程也不会继续运行。**  

现在你应该能够理解，为何我们的 Go 协程没有运行了吧。在第 11 行调用了 `go hello()` 之后，程序控制没有等待 `hello` 协程结束，立即返回到了代码下一行，打印 `main function`。接着由于没有其他可执行的代码，Go 主协程终止，于是 `hello` 协程就没有机会运行了。

我们现在修复这个问题。

```go
package main

import (  
    "fmt"
    "time"
)

func hello() {  
    fmt.Println("Hello world goroutine")
}
func main() {  
    go hello()
    time.Sleep(1 * time.Second)
    fmt.Println("main function")
}
```

[在线运行程序](https://play.golang.org/p/U9ZZuSql8-)  

在上面程序的第 13 行，我们调用了 time 包里的函数 [`Sleep`](https://golang.org/pkg/time/#Sleep)，该函数会休眠执行它的 Go 协程。在这里，我们使 Go 主协程休眠了 1 秒。因此在主协程终止之前，调用 `go hello()` 就有足够的时间来执行了。该程序首先打印 `Hello world goroutine`，等待 1 秒钟之后，接着打印 `main function`。  

在 Go 主协程中使用休眠，以便等待其他协程执行完毕，这种方法只是用于理解 Go 协程如何工作的技巧。信道可用于在其他协程结束执行之前，阻塞 Go 主协程。我们会在下一教程中讨论信道。  

## 启动多个 Go 协程

为了更好地理解 Go 协程，我们再编写一个程序，启动多个 Go 协程。  

```go
package main

import (  
    "fmt"
    "time"
)

func numbers() {  
    for i := 1; i <= 5; i++ {
        time.Sleep(250 * time.Millisecond)
        fmt.Printf("%d ", i)
    }
}
func alphabets() {  
    for i := 'a'; i <= 'e'; i++ {
        time.Sleep(400 * time.Millisecond)
        fmt.Printf("%c ", i)
    }
}
func main() {  
    go numbers()
    go alphabets()
    time.Sleep(3000 * time.Millisecond)
    fmt.Println("main terminated")
}
```

[在线运行程序](https://play.golang.org/p/U9ZZuSql8-)  

在上面程序中的第 21 行和第 22 行，启动了两个 Go 协程。现在，这两个协程并发地运行。`numbers` 协程首先休眠 250 微秒，接着打印 `1`，然后再次休眠，打印 `2`，依此类推，一直到打印 `5` 结束。`alphabete` 协程同样打印从 `a` 到 `e` 的字母，并且每次有 400 微秒的休眠时间。 Go 主协程启动了 `numbers` 和 `alphabete` 两个 Go 协程，休眠了 3000 微秒后终止程序。  

该程序会输出：  

```
1 a 2 3 b 4 c 5 d e main terminated
```

程序的运作如下图所示。为了更好地观看图片，请在新标签页中打开。  

![image](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/Goroutines-explained.png)

第一张蓝色的图表示 `numbers` 协程，第二张褐红色的图表示 `alphabets` 协程，第三张绿色的图表示 Go 主协程，而最后一张黑色的图把以上三种协程合并了，表明程序是如何运行的。在每个方框顶部，诸如 `0 ms` 和 `250 ms` 这样的字符串表示时间（以微秒为单位）。在每个方框的底部，`1`、`2`、`3` 等表示输出。蓝色方框表示：`250 ms` 打印出 `1`，`500 ms` 打印出 `2`，依此类推。最后黑色方框的底部的值会是 `1 a 2 3 b 4 c 5 d e main terminated`，这同样也是整个程序的输出。以上图片非常直观，你可以用它来理解程序是如何运作的。  

Go 协程的介绍到此结束。祝你愉快。

**上一教程 - [并发入门](https://studygolang.com/articles/12341)**

#  22. 信道（channel） 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-02-14 09:41:18 · 33591 次点击 · 					预计阅读时间 11 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-02-14 09:41:18 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 22 篇。  

在[上一教程](https://studygolang.com/articles/12342)里，我们探讨了如何使用 Go 协程（Goroutine）来实现并发。我们接着在本教程里学习信道（Channel），学习如何通过信道来实现 Go 协程间的通信。  

## 什么是信道？

信道可以想像成 Go 协程之间通信的管道。如同管道中的水会从一端流到另一端，通过使用信道，数据也可以从一端发送，在另一端接收。  

## 信道的声明

所有信道都关联了一个类型。信道只能运输这种类型的数据，而运输其他类型的数据都是非法的。  

`chan T` 表示 `T` 类型的信道。  

信道的零值为 `nil`。信道的零值没有什么用，应该像对 map 和切片所做的那样，用 `make` 来定义信道。  

下面编写代码，声明一个信道。  

```go
package main

import "fmt"

func main() {  
    var a chan int
    if a == nil {
        fmt.Println("channel a is nil, going to define it")
        a = make(chan int)
        fmt.Printf("Type of a is %T", a)
    }
}
```

[在线运行程序](https://play.golang.org/p/QDtf6mvymD)  

由于信道的零值为 `nil`，在第 6 行，信道 `a` 的值就是 `nil`。于是，程序执行了 if 语句内的语句，定义了信道 `a`。程序中 `a` 是一个 int 类型的信道。该程序会输出：  

```
channel a is nil, going to define it  
Type of a is chan int
```

简短声明通常也是一种定义信道的简洁有效的方法。  

```go
a := make(chan int)
```

这一行代码同样定义了一个 int 类型的信道 `a`。  

## 通过信道进行发送和接收

如下所示，该语法通过信道发送和接收数据。  

```go
data := <- a // 读取信道 a  
a <- data // 写入信道 a
```

信道旁的箭头方向指定了是发送数据还是接收数据。  

在第一行，箭头对于 `a` 来说是向外指的，因此我们读取了信道 `a` 的值，并把该值存储到变量 `data`。  

在第二行，箭头指向了 `a`，因此我们在把数据写入信道 `a`。  

## 发送与接收默认是阻塞的

发送与接收默认是阻塞的。这是什么意思？当把数据发送到信道时，程序控制会在发送数据的语句处发生阻塞，直到有其它 Go 协程从信道读取到数据，才会解除阻塞。与此类似，当读取信道的数据时，如果没有其它的协程把数据写入到这个信道，那么读取过程就会一直阻塞着。  

信道的这种特性能够帮助 Go 协程之间进行高效的通信，不需要用到其他编程语言常见的显式锁或条件变量。  

## 信道的代码示例

理论已经够了:)。接下来写点代码，看看协程之间通过信道是怎么通信的吧。  

我们其实可以重写上章学习 [Go 协程](https://studygolang.com/articles/12342) 时写的程序，现在我们在这里用上信道。  

首先引用前面教程里的程序。  

```go
package main

import (  
    "fmt"
    "time"
)

func hello() {  
    fmt.Println("Hello world goroutine")
}
func main() {  
    go hello()
    time.Sleep(1 * time.Second)
    fmt.Println("main function")
}
```

[在线运行程序](https://play.golang.org/p/U9ZZuSql8-)  

这是上一篇的代码。我们使用到了休眠，使 Go 主协程等待 hello 协程结束。如果你看不懂，建议你阅读上一教程 [Go 协程](https://studygolang.com/articles/12342)。  

我们接下来使用信道来重写上面代码。  

```go
package main

import (  
    "fmt"
)

func hello(done chan bool) {  
    fmt.Println("Hello world goroutine")
    done <- true
}
func main() {  
    done := make(chan bool)
    go hello(done)
    <-done
    fmt.Println("main function")
}
```

[在线运行程序](https://play.golang.org/p/I8goKv6ZMF)  

在上述程序里，我们在第 12 行创建了一个 bool 类型的信道 `done`，并把 `done` 作为参数传递给了 `hello` 协程。在第 14 行，我们通过信道 `done` 接收数据。这一行代码发生了阻塞，除非有协程向 `done` 写入数据，否则程序不会跳到下一行代码。于是，这就不需要用以前的 `time.Sleep` 来阻止 Go 主协程退出了。  

`<-done` 这行代码通过协程（译注：原文笔误，信道）`done` 接收数据，但并没有使用数据或者把数据存储到变量中。这完全是合法的。  

现在我们的 Go 主协程发生了阻塞，等待信道 `done` 发送的数据。该信道作为参数传递给了协程 `hello`，`hello` 打印出 `Hello world goroutine`，接下来向 `done` 写入数据。当完成写入时，Go 主协程会通过信道 `done` 接收数据，于是它解除阻塞状态，打印出文本 `main function`。  

该程序输出如下：  

```
Hello world goroutine  
main function
```

我们稍微修改一下程序，在 `hello` 协程里加入休眠函数，以便更好地理解阻塞的概念。  

```go
package main

import (  
    "fmt"
    "time"
)

func hello(done chan bool) {  
    fmt.Println("hello go routine is going to sleep")
    time.Sleep(4 * time.Second)
    fmt.Println("hello go routine awake and going to write to done")
    done <- true
}
func main() {  
    done := make(chan bool)
    fmt.Println("Main going to call hello go goroutine")
    go hello(done)
    <-done
    fmt.Println("Main received data")
}
```

[在线运行程序](https://play.golang.org/p/EejiO-yjUQ)  

在上面程序里，我们向 `hello` 函数里添加了 4 秒的休眠（第 10 行）。  

程序首先会打印 `Main going to call hello go goroutine`。接着会开启 `hello` 协程，打印 `hello go routine is going to sleep`。打印完之后，`hello` 协程会休眠 4 秒钟，而在这期间，主协程会在 `<-done` 这一行发生阻塞，等待来自信道 `done` 的数据。4 秒钟之后，打印 `hello go routine awake and going to write to done`，接着再打印 `Main received data`。  

## 信道的另一个示例

我们再编写一个程序来更好地理解信道。该程序会计算一个数中每一位的平方和与立方和，然后把平方和与立方和相加并打印出来。

例如，如果输出是 123，该程序会如下计算输出：  

```
squares = (1 * 1) + (2 * 2) + (3 * 3) 
cubes = (1 * 1 * 1) + (2 * 2 * 2) + (3 * 3 * 3) 
output = squares + cubes = 50
```

我们会这样去构建程序：在一个单独的 Go 协程计算平方和，而在另一个协程计算立方和，最后在 Go 主协程把平方和与立方和相加。  

```go
package main

import (  
    "fmt"
)

func calcSquares(number int, squareop chan int) {  
    sum := 0
    for number != 0 {
        digit := number % 10
        sum += digit * digit
        number /= 10
    }
    squareop <- sum
}

func calcCubes(number int, cubeop chan int) {  
    sum := 0 
    for number != 0 {
        digit := number % 10
        sum += digit * digit * digit
        number /= 10
    }
    cubeop <- sum
} 

func main() {  
    number := 589
    sqrch := make(chan int)
    cubech := make(chan int)
    go calcSquares(number, sqrch)
    go calcCubes(number, cubech)
    squares, cubes := <-sqrch, <-cubech
    fmt.Println("Final output", squares + cubes)
}
```

[在线运行程序](https://play.golang.org/p/4RKr7_YO_B)  

在第 7 行，函数 `calcSquares` 计算一个数每位的平方和，并把结果发送给信道 `squareop`。与此类似，在第 17 行函数 `calcCubes` 计算一个数每位的立方和，并把结果发送给信道 `cubop`。  

这两个函数分别在单独的协程里运行（第 31 行和第 32 行），每个函数都有传递信道的参数，以便写入数据。Go 主协程会在第 33 行等待两个信道传来的数据。一旦从两个信道接收完数据，数据就会存储在变量 `squares` 和 `cubes` 里，然后计算并打印出最后结果。该程序会输出：  

```
Final output 1536
```

## 死锁

使用信道需要考虑的一个重点是死锁。当 Go 协程给一个信道发送数据时，照理说会有其他 Go 协程来接收数据。如果没有的话，程序就会在运行时触发 panic，形成死锁。  

同理，当有 Go 协程等着从一个信道接收数据时，我们期望其他的 Go 协程会向该信道写入数据，要不然程序就会触发 panic。 

```go
package main

func main() {  
    ch := make(chan int)
    ch <- 5
}
```

[在线运行程序](https://play.golang.org/p/q1O5sNx4aW)  

在上述程序中，我们创建了一个信道 `ch`，接着在下一行 `ch <- 5`，我们把 `5` 发送到这个信道。对于本程序，没有其他的协程从 `ch` 接收数据。于是程序触发 panic，出现如下运行时错误。  

```
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan send]:  
main.main()  
    /tmp/sandbox249677995/main.go:6 +0x80
```

## 单向信道

我们目前讨论的信道都是双向信道，即通过信道既能发送数据，又能接收数据。其实也可以创建单向信道，这种信道只能发送或者接收数据。  

```go
package main

import "fmt"

func sendData(sendch chan<- int) {  
    sendch <- 10
}

func main() {  
    sendch := make(chan<- int)
    go sendData(sendch)
    fmt.Println(<-sendch)
}
```

[在线运行程序](https://play.golang.org/p/PRKHxM-iRK)  

上面程序的第 10 行，我们创建了唯送（Send Only）信道 `sendch`。`chan<- int` 定义了唯送信道，因为箭头指向了 `chan`。在第 12 行，我们试图通过唯送信道接收数据，于是编译器报错：  

```
main.go:11: invalid operation: <-sendch (receive from send-only type chan<- int)
```

**一切都很顺利，只不过一个不能读取数据的唯送信道究竟有什么意义呢？**  

**这就需要用到信道转换（Channel Conversion）了。把一个双向信道转换成唯送信道或者唯收（Receive Only）信道都是行得通的，但是反过来就不行。**  

```go
package main

import "fmt"

func sendData(sendch chan<- int) {  
    sendch <- 10
}

func main() {  
    cha1 := make(chan int)
    go sendData(cha1)
    fmt.Println(<-cha1)
}
```

[在线运行程序](https://play.golang.org/p/aqi_rJ1U8j)  

在上述程序的第 10 行，我们创建了一个双向信道 `cha1`。在第 11 行 `cha1` 作为参数传递给了 `sendData` 协程。在第 5 行，函数 `sendData` 里的参数 `sendch chan<- int` 把 `cha1` 转换为一个唯送信道。于是该信道在 `sendData` 协程里是一个唯送信道，而在 Go 主协程里是一个双向信道。该程序最终打印输出 `10`。  

## 关闭信道和使用 for range 遍历信道

数据发送方可以关闭信道，通知接收方这个信道不再有数据发送过来。  

当从信道接收数据时，接收方可以多用一个变量来检查信道是否已经关闭。  

```
v, ok := <- ch
```

上面的语句里，如果成功接收信道所发送的数据，那么 `ok` 等于 true。而如果 `ok` 等于 false，说明我们试图读取一个关闭的通道。从关闭的信道读取到的值会是该信道类型的零值。例如，当信道是一个 `int` 类型的信道时，那么从关闭的信道读取的值将会是 `0`。  

```go
package main

import (  
    "fmt"
)

func producer(chnl chan int) {  
    for i := 0; i < 10; i++ {
        chnl <- i
    }
    close(chnl)
}
func main() {  
    ch := make(chan int)
    go producer(ch)
    for {
        v, ok := <-ch
        if ok == false {
            break
        }
        fmt.Println("Received ", v, ok)
    }
}
```

[在线运行程序](https://play.golang.org/p/XWmUKDA2Ri)  

在上述的程序中，`producer` 协程会从 0 到 9 写入信道 `chn1`，然后关闭该信道。主函数有一个无限的 for 循环（第 16 行），使用变量 `ok`（第 18 行）检查信道是否已经关闭。如果 `ok` 等于 false，说明信道已经关闭，于是退出 for 循环。如果 `ok` 等于 true，会打印出接收到的值和 `ok` 的值。  

```
Received  0 true  
Received  1 true  
Received  2 true  
Received  3 true  
Received  4 true  
Received  5 true  
Received  6 true  
Received  7 true  
Received  8 true  
Received  9 true
```

for range 循环用于在一个信道关闭之前，从信道接收数据。  

接下来我们使用 for range 循环重写上面的代码。  

```go
package main

import (  
    "fmt"
)

func producer(chnl chan int) {  
    for i := 0; i < 10; i++ {
        chnl <- i
    }
    close(chnl)
}
func main() {  
    ch := make(chan int)
    go producer(ch)
    for v := range ch {
        fmt.Println("Received ",v)
    }
}
```

[在线运行程序](https://play.golang.org/p/JJ3Ida1r_6)  

在第 16 行，for range 循环从信道 `ch` 接收数据，直到该信道关闭。一旦关闭了 `ch`，循环会自动结束。该程序会输出：  

```
Received  0  
Received  1  
Received  2  
Received  3  
Received  4  
Received  5  
Received  6  
Received  7  
Received  8  
Received  9
```

我们可以使用 for range 循环，重写[信道的另一个示例](https://studygolang.com/articles/12402#)这一节里面的代码，提高代码的可重用性。  

如果你仔细观察这段代码，会发现获得一个数里的每位数的代码在 `calcSquares` 和 `calcCubes` 两个函数内重复了。我们将把这段代码抽离出来，放在一个单独的函数里，然后并发地调用它。  

```go
package main

import (  
    "fmt"
)

func digits(number int, dchnl chan int) {  
    for number != 0 {
        digit := number % 10
        dchnl <- digit
        number /= 10
    }
    close(dchnl)
}
func calcSquares(number int, squareop chan int) {  
    sum := 0
    dch := make(chan int)
    go digits(number, dch)
    for digit := range dch {
        sum += digit * digit
    }
    squareop <- sum
}

func calcCubes(number int, cubeop chan int) {  
    sum := 0
    dch := make(chan int)
    go digits(number, dch)
    for digit := range dch {
        sum += digit * digit * digit
    }
    cubeop <- sum
}

func main() {  
    number := 589
    sqrch := make(chan int)
    cubech := make(chan int)
    go calcSquares(number, sqrch)
    go calcCubes(number, cubech)
    squares, cubes := <-sqrch, <-cubech
    fmt.Println("Final output", squares+cubes)
}
```

[在线运行程序](https://play.golang.org/p/oL86W9Ui03)  

上述程序里的 `digits` 函数，包含了获取一个数的每位数的逻辑，并且 `calcSquares` 和 `calcCubes` 两个函数并发地调用了 `digits`。当计算完数字里面的每一位数时，第 13 行就会关闭信道。`calcSquares` 和 `calcCubes` 两个协程使用 for range 循环分别监听了它们的信道，直到该信道关闭。程序的其他地方不变，该程序同样会输出：  

```
Final output 1536
```

本教程的内容到此结束。关于信道还有一些其他的概念，比如缓冲信道（Buffered Channel）、工作池（Worker Pool）和 select。我们会在接下来的教程里专门介绍它们。感谢阅读。祝你愉快。  

**上一教程 - [Go 协程](https://studygolang.com/articles/12342)**

# 23. 缓冲信道和工作池（Buffered Channels and Worker Pools） 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-06 23:15:05 · 28015 次点击 · 					预计阅读时间 12 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-06 23:15:05 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 23 篇。  

## 什么是缓冲信道？

在[上一教程](https://studygolang.com/articles/12402)里，我们讨论的主要是无缓冲信道。我们在[信道](https://studygolang.com/articles/12402)的教程里详细讨论了，无缓冲信道的发送和接收过程是阻塞的。  

我们还可以创建一个有缓冲（Buffer）的信道。只在缓冲已满的情况，才会阻塞向缓冲信道（Buffered Channel）发送数据。同样，只有在缓冲为空的时候，才会阻塞从缓冲信道接收数据。  

通过向 `make` 函数再传递一个表示容量的参数（指定缓冲的大小），可以创建缓冲信道。  

```go
ch := make(chan type, capacity)
```

要让一个信道有缓冲，上面语法中的 `capacity` 应该大于 0。无缓冲信道的容量默认为 0，因此我们在[上一教程](https://studygolang.com/articles/12402)创建信道时，省略了容量参数。  

我们开始编写代码，创建一个缓冲信道。  

## 示例一

```go
package main

import (  
    "fmt"
)


func main() {  
    ch := make(chan string, 2)
    ch <- "naveen"
    ch <- "paul"
    fmt.Println(<- ch)
    fmt.Println(<- ch)
}
```

[在线运行程序](https://play.golang.org/p/It-em11etK)  

在上面程序里的第 9 行，我们创建了一个缓冲信道，其容量为 2。由于该信道的容量为 2，因此可向它写入两个字符串，而且不会发生阻塞。在第  10 行和第 11 行，我们向信道写入两个字符串，该信道并没有发生阻塞。我们又在第 12 行和第 13 行分别读取了这两个字符串。该程序输出：  

```
naveen  
paul
```

## 示例二

我们再看一个缓冲信道的示例，其中有一个并发的 Go 协程来向信道写入数据，而 Go 主协程负责读取数据。该示例帮助我们进一步理解，在向缓冲信道写入数据时，什么时候会发生阻塞。  

```go
package main

import (  
    "fmt"
    "time"
)

func write(ch chan int) {  
    for i := 0; i < 5; i++ {
        ch <- i
        fmt.Println("successfully wrote", i, "to ch")
    }
    close(ch)
}
func main() {  
    ch := make(chan int, 2)
    go write(ch)
    time.Sleep(2 * time.Second)
    for v := range ch {
        fmt.Println("read value", v,"from ch")
        time.Sleep(2 * time.Second)

    }
}
```

[在线运行程序](https://play.golang.org/p/bKe5GdgMK9)  

在上面的程序中，第 16 行在 Go 主协程中创建了容量为 2 的缓冲信道 `ch`，而第 17 行把 `ch` 传递给了 `write` 协程。接下来 Go 主协程休眠了两秒。在这期间，`write` 协程在并发地运行。`write` 协程有一个 for 循环，依次向信道 `ch` 写入 0～4。而缓冲信道的容量为 2，因此 `write` 协程里立即会向 `ch` 写入 0 和 1，接下来发生阻塞，直到 `ch` 内的值被读取。因此，该程序立即打印出下面两行：  

```
successfully wrote 0 to ch  
successfully wrote 1 to ch
```

打印上面两行之后，`write` 协程中向 `ch` 的写入发生了阻塞，直到 `ch` 有值被读取到。而 Go 主协程休眠了两秒后，才开始读取该信道，因此在休眠期间程序不会打印任何结果。主协程结束休眠后，在第 19 行使用 for range 循环，开始读取信道 `ch`，打印出了读取到的值后又休眠两秒，这个循环一直到 `ch` 关闭才结束。所以该程序在两秒后会打印下面两行：  

```
read value 0 from ch  
successfully wrote 2 to ch
```

该过程会一直进行，直到信道读取完所有的值，并在 `write` 协程中关闭信道。最终输出如下：  

```
successfully wrote 0 to ch  
successfully wrote 1 to ch  
read value 0 from ch  
successfully wrote 2 to ch  
read value 1 from ch  
successfully wrote 3 to ch  
read value 2 from ch  
successfully wrote 4 to ch  
read value 3 from ch  
read value 4 from ch
```

## 死锁

```go
package main

import (  
    "fmt"
)

func main() {  
    ch := make(chan string, 2)
    ch <- "naveen"
    ch <- "paul"
    ch <- "steve"
    fmt.Println(<-ch)
    fmt.Println(<-ch)
}
```

[在线运行程序](https://play.golang.org/p/FW-LHeH7oD)  

在上面程序里，我们向容量为 2 的缓冲信道写入 3 个字符串。当在程序控制到达第 3 次写入时（第 11  行），由于它超出了信道的容量，因此这次写入发生了阻塞。现在想要这次写操作能够进行下去，必须要有其它协程来读取这个信道的数据。但在本例中，并没有并发协程来读取这个信道，因此这里会发生**死锁**（deadlock）。程序会在运行时触发 panic，信息如下：  

```
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan send]:  
main.main()  
    /tmp/sandbox274756028/main.go:11 +0x100
```

## 长度 vs 容量

缓冲信道的容量是指信道可以存储的值的数量。我们在使用 `make` 函数创建缓冲信道的时候会指定容量大小。  

缓冲信道的长度是指信道中当前排队的元素个数。  

代码可以把一切解释得很清楚。:)  

```go
package main

import (  
    "fmt"
)

func main() {  
    ch := make(chan string, 3)
    ch <- "naveen"
    ch <- "paul"
    fmt.Println("capacity is", cap(ch))
    fmt.Println("length is", len(ch))
    fmt.Println("read value", <-ch)
    fmt.Println("new length is", len(ch))
}
```

[在线运行程序](https://play.golang.org/p/2ggC64yyvr)  

在上面的程序里，我们创建了一个容量为 3 的信道，于是它可以保存 3 个字符串。接下来，我们分别在第 9 行和第 10  行向信道写入了两个字符串。于是信道有两个字符串排队，因此其长度为 2。在第 13  行，我们又从信道读取了一个字符串。现在该信道内只有一个字符串，因此其长度变为 1。该程序会输出：  

```
capacity is 3  
length is 2  
read value naveen  
new length is 1
```

## WaitGroup

在本教程的下一节里，我们会讲到**工作池**（Worker Pools）。而 `WaitGroup` 用于实现工作池，因此要理解工作池，我们首先需要学习 `WaitGroup`。  

`WaitGroup` 用于等待一批 Go 协程执行结束。程序控制会一直阻塞，直到这些协程全部执行完毕。假设我们有 3 个并发执行的 Go 协程（由 Go 主协程生成）。Go 主协程需要等待这 3 个协程执行结束后，才会终止。这就可以用 `WaitGroup` 来实现。  

理论说完了，我们编写点儿代码吧。:)  

```go
package main

import (  
    "fmt"
    "sync"
    "time"
)

func process(i int, wg *sync.WaitGroup) {  
    fmt.Println("started Goroutine ", i)
    time.Sleep(2 * time.Second)
    fmt.Printf("Goroutine %d ended\n", i)
    wg.Done()
}

func main() {  
    no := 3
    var wg sync.WaitGroup
    for i := 0; i < no; i++ {
        wg.Add(1)
        go process(i, &wg)
    }
    wg.Wait()
    fmt.Println("All go routines finished executing")
}
```

[在线运行程序](https://play.golang.org/p/CZNtu8ktQh)  

[WaitGroup](https://golang.org/pkg/sync/#WaitGroup) 是一个结构体类型，我们在第 18 行创建了 `WaitGroup` 类型的变量，其初始值为零值。`WaitGroup` 使用计数器来工作。当我们调用 `WaitGroup` 的 `Add` 并传递一个 `int` 时，`WaitGroup` 的计数器会加上 `Add` 的传参。要减少计数器，可以调用 `WaitGroup` 的 `Done()` 方法。`Wait()` 方法会阻塞调用它的 Go 协程，直到计数器变为 0 后才会停止阻塞。  

上述程序里，for 循环迭代了 3 次，我们在循环内调用了 `wg.Add(1)`（第 20 行）。因此计数器变为 3。for 循环同样创建了 3 个 `process` 协程，然后在第 23 行调用了 `wg.Wait()`，确保 Go 主协程等待计数器变为 0。在第 13 行，`process` 协程内调用了 `wg.Done`，可以让计数器递减。一旦 3 个子协程都执行完毕（即 `wg.Done()` 调用了 3 次），那么计数器就变为 0，于是主协程会解除阻塞。  

**在第 21 行里，传递 `wg` 的地址是很重要的。如果没有传递 `wg` 的地址，那么每个 Go 协程将会得到一个 `WaitGroup` 值的拷贝，因而当它们执行结束时，`main` 函数并不会知道**。  

该程序输出：  

```
started Goroutine  2  
started Goroutine  0  
started Goroutine  1  
Goroutine 0 ended  
Goroutine 2 ended  
Goroutine 1 ended  
All go routines finished executing
```

由于 Go 协程的执行顺序不一定，因此你的输出可能和我不一样。:)  

## 工作池的实现

缓冲信道的重要应用之一就是实现[工作池](https://en.wikipedia.org/wiki/Thread_pool)。  

一般而言，工作池就是一组等待任务分配的线程。一旦完成了所分配的任务，这些线程可继续等待任务的分配。  

我们会使用缓冲信道来实现工作池。我们工作池的任务是计算所输入数字的每一位的和。例如，如果输入 234，结果会是 9（即 2 + 3 + 4）。向工作池输入的是一列伪随机数。  

我们工作池的核心功能如下：  

- 创建一个 Go 协程池，监听一个等待作业分配的输入型缓冲信道。  
- 将作业添加到该输入型缓冲信道中。  
- 作业完成后，再将结果写入一个输出型缓冲信道。  
- 从输出型缓冲信道读取并打印结果。  

我们会逐步编写这个程序，让代码易于理解。  

第一步就是创建一个结构体，表示作业和结果。  

```go
type Job struct {  
    id       int
    randomno int
}
type Result struct {  
    job         Job
    sumofdigits int
}
```

所有 `Job` 结构体变量都会有 `id` 和 `randomno` 两个字段，`randomno` 用于计算其每位数之和。  

而 `Result` 结构体有一个 `job` 字段，表示所对应的作业，还有一个 `sumofdigits` 字段，表示计算的结果（每位数字之和）。  

第二步是分别创建用于接收作业和写入结果的缓冲信道。  

```go
var jobs = make(chan Job, 10)  
var results = make(chan Result, 10)
```

工作协程（Worker Goroutine）会监听缓冲信道 `jobs` 里更新的作业。一旦工作协程完成了作业，其结果会写入缓冲信道 `results`。

如下所示，`digits` 函数的任务实际上就是计算整数的每一位之和，最后返回该结果。为了模拟出 `digits` 在计算过程中花费了一段时间，我们在函数内添加了两秒的休眠时间。  

```go
func digits(number int) int {  
    sum := 0
    no := number
    for no != 0 {
        digit := no % 10
        sum += digit
        no /= 10
    }
    time.Sleep(2 * time.Second)
    return sum
}
```

然后，我们写一个创建工作协程的函数。  

```go
func worker(wg *sync.WaitGroup) {  
    for job := range jobs {
        output := Result{job, digits(job.randomno)}
        results <- output
    }
    wg.Done()
}
```

上面的函数创建了一个工作者（Worker），读取 `jobs` 信道的数据，根据当前的 `job` 和 `digits` 函数的返回值，创建了一个 `Result` 结构体变量，然后将结果写入 `results` 缓冲信道。`worker` 函数接收了一个 `WaitGroup` 类型的 `wg` 作为参数，当所有的 `jobs` 完成的时候，调用了 `Done()` 方法。  

`createWorkerPool` 函数创建了一个 Go 协程的工作池。  

```go
func createWorkerPool(noOfWorkers int) {  
    var wg sync.WaitGroup
    for i := 0; i < noOfWorkers; i++ {
        wg.Add(1)
        go worker(&wg)
    }
    wg.Wait()
    close(results)
}
```

上面函数的参数是需要创建的工作协程的数量。在创建 Go 协程之前，它调用了 `wg.Add(1)` 方法，于是 `WaitGroup` 计数器递增。接下来，我们创建工作协程，并向 `worker` 函数传递 `wg` 的地址。创建了需要的工作协程后，函数调用 `wg.Wait()`，等待所有的 Go 协程执行完毕。所有协程完成执行之后，函数会关闭 `results` 信道。因为所有协程都已经执行完毕，于是不再需要向 `results` 信道写入数据了。  

现在我们已经有了工作池，我们继续编写一个函数，把作业分配给工作者。  

```go
func allocate(noOfJobs int) {  
    for i := 0; i < noOfJobs; i++ {
        randomno := rand.Intn(999)
        job := Job{i, randomno}
        jobs <- job
    }
    close(jobs)
}
```

上面的 `allocate` 函数接收所需创建的作业数量作为输入参数，生成了最大值为 998 的伪随机数，并使用该随机数创建了 `Job` 结构体变量。这个函数把 for 循环的计数器 `i` 作为 id，最后把创建的结构体变量写入 `jobs` 信道。当写入所有的 `job` 时，它关闭了 `jobs` 信道。  

下一步是创建一个读取 `results` 信道和打印输出的函数。  

```go
func result(done chan bool) {  
    for result := range results {
        fmt.Printf("Job id %d, input random no %d , sum of digits %d\n", result.job.id, result.job.randomno, result.sumofdigits)
    }
    done <- true
}
```

`result` 函数读取 `results` 信道，并打印出 `job` 的 `id`、输入的随机数、该随机数的每位数之和。`result` 函数也接受 `done` 信道作为参数，当打印所有结果时，`done` 会被写入 true。  

现在一切准备充分了。我们继续完成最后一步，在 `main()` 函数中调用上面所有的函数。  

```go
func main() {  
    startTime := time.Now()
    noOfJobs := 100
    go allocate(noOfJobs)
    done := make(chan bool)
    go result(done)
    noOfWorkers := 10
    createWorkerPool(noOfWorkers)
    <-done
    endTime := time.Now()
    diff := endTime.Sub(startTime)
    fmt.Println("total time taken ", diff.Seconds(), "seconds")
}
```

我们首先在 `main` 函数的第 2 行，保存了程序的起始时间，并在最后一行（第 12 行）计算了 `endTime` 和 `startTime` 的差值，显示出程序运行的总时间。由于我们想要通过改变协程数量，来做一点基准指标（Benchmark），所以需要这么做。  

我们把 `noOfJobs` 设置为 100，接下来调用了 `allocate`，向 `jobs` 信道添加作业。  

我们创建了 `done` 信道，并将其传递给 `result` 协程。于是该协程会开始打印结果，并在完成打印时发出通知。  

通过调用 `createWorkerPool` 函数，我们最终创建了一个有 10 个协程的工作池。`main` 函数会监听 `done` 信道的通知，等待所有结果打印结束。  

为了便于参考，下面是整个程序。我还引用了必要的包。  

```go
package main

import (  
    "fmt"
    "math/rand"
    "sync"
    "time"
)

type Job struct {  
    id       int
    randomno int
}
type Result struct {  
    job         Job
    sumofdigits int
}

var jobs = make(chan Job, 10)  
var results = make(chan Result, 10)

func digits(number int) int {  
    sum := 0
    no := number
    for no != 0 {
        digit := no % 10
        sum += digit
        no /= 10
    }
    time.Sleep(2 * time.Second)
    return sum
}
func worker(wg *sync.WaitGroup) {  
    for job := range jobs {
        output := Result{job, digits(job.randomno)}
        results <- output
    }
    wg.Done()
}
func createWorkerPool(noOfWorkers int) {  
    var wg sync.WaitGroup
    for i := 0; i < noOfWorkers; i++ {
        wg.Add(1)
        go worker(&wg)
    }
    wg.Wait()
    close(results)
}
func allocate(noOfJobs int) {  
    for i := 0; i < noOfJobs; i++ {
        randomno := rand.Intn(999)
        job := Job{i, randomno}
        jobs <- job
    }
    close(jobs)
}
func result(done chan bool) {  
    for result := range results {
        fmt.Printf("Job id %d, input random no %d , sum of digits %d\n", result.job.id, result.job.randomno, result.sumofdigits)
    }
    done <- true
}
func main() {  
    startTime := time.Now()
    noOfJobs := 100
    go allocate(noOfJobs)
    done := make(chan bool)
    go result(done)
    noOfWorkers := 10
    createWorkerPool(noOfWorkers)
    <-done
    endTime := time.Now()
    diff := endTime.Sub(startTime)
    fmt.Println("total time taken ", diff.Seconds(), "seconds")
}
```

[在线运行程序](https://play.golang.org/p/au5islUIbx)  

为了更精确地计算总时间，请在你的本地机器上运行该程序。  

该程序输出：  

```
Job id 1, input random no 636, sum of digits 15  
Job id 0, input random no 878, sum of digits 23  
Job id 9, input random no 150, sum of digits 6  
...
total time taken  20.01081009 seconds
```

程序总共会打印 100 行，对应着 100 项作业，然后最后会打印一行程序消耗的总时间。你的输出会和我的不同，因为 Go 协程的运行顺序不一定，同样总时间也会因为硬件而不同。在我的例子中，运行程序大约花费了 20 秒。  

现在我们把 `main` 函数里的 `noOfWorkers` 增加到 20。我们把工作者的数量加倍了。由于工作协程增加了（准确说来是两倍），因此程序花费的总时间会减少（准确说来是一半）。在我的例子里，程序会打印出 10.004364685 秒。  

```
...
total time taken  10.004364685 seconds
```

现在我们可以理解了，随着工作协程数量增加，完成作业的总时间会减少。你们可以练习一下：在 `main` 函数里修改 `noOfJobs` 和 `noOfWorkers` 的值，并试着去分析一下结果。  

本教程到此结束。祝你愉快。   

**上一教程 - [信道](https://studygolang.com/articles/12402)**

# 24. Select 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-08 22:47:36 · 18489 次点击 · 					预计阅读时间 6 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-08 22:47:36 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 24 篇。  

## 什么是 select？

`select` 语句用于在多个发送/接收信道操作中进行选择。`select` 语句会一直阻塞，直到发送/接收操作准备就绪。如果有多个信道操作准备完毕，`select` 会随机地选取其中之一执行。该语法与 `switch` 类似，所不同的是，这里的每个 `case` 语句都是信道操作。我们好好看一些代码来加深理解吧。  

## 示例

```go
package main

import (  
    "fmt"
    "time"
)

func server1(ch chan string) {  
    time.Sleep(6 * time.Second)
    ch <- "from server1"
}
func server2(ch chan string) {  
    time.Sleep(3 * time.Second)
    ch <- "from server2"

}
func main() {  
    output1 := make(chan string)
    output2 := make(chan string)
    go server1(output1)
    go server2(output2)
    select {
    case s1 := <-output1:
        fmt.Println(s1)
    case s2 := <-output2:
        fmt.Println(s2)
    }
}
```

[在线运行程序](https://play.golang.org/p/3_yaJSoSpG)  

在上面程序里，`server1` 函数（第 8 行）休眠了 6 秒，接着将文本 `from server1` 写入信道 `ch`。而 `server2` 函数（第 12 行）休眠了 3 秒，然后把 `from server2` 写入了信道 `ch`。  

而 `main` 函数在第 20 行和第 21 行，分别调用了 `server1` 和 `server2` 两个 Go 协程。  

在第 22 行，程序运行到了 `select` 语句。`select` 会一直发生阻塞，除非其中有 case 准备就绪。在上述程序里，`server1` 协程会在 6 秒之后写入 `output1` 信道，而`server2` 协程在 3 秒之后就写入了 `output2` 信道。因此 `select` 语句会阻塞 3 秒钟，等着 `server2` 向 `output2` 信道写入数据。3 秒钟过后，程序会输出：  

```
from server2
```

然后程序终止。  

## select 的应用

在上面程序中，函数之所以取名为 `server1` 和 `server2`，是为了展示 `select` 的实际应用。  

假设我们有一个关键性应用，需要尽快地把输出返回给用户。这个应用的数据库复制并且存储在世界各地的服务器上。假设函数 `server1` 和 `server2` 与这样不同区域的两台服务器进行通信。每台服务器的负载和网络时延决定了它的响应时间。我们向两台服务器发送请求，并使用 `select` 语句等待相应的信道发出响应。`select` 会选择首先响应的服务器，而忽略其它的响应。使用这种方法，我们可以向多个服务器发送请求，并给用户返回最快的响应了。:）  

## 默认情况

在没有 case 准备就绪时，可以执行 `select` 语句中的默认情况（Default Case）。这通常用于防止 `select` 语句一直阻塞。  

```go
package main

import (  
    "fmt"
    "time"
)

func process(ch chan string) {  
    time.Sleep(10500 * time.Millisecond)
    ch <- "process successful"
}

func main() {  
    ch := make(chan string)
    go process(ch)
    for {
        time.Sleep(1000 * time.Millisecond)
        select {
        case v := <-ch:
            fmt.Println("received value: ", v)
            return
        default:
            fmt.Println("no value received")
        }
    }

}
```

[在线运行程序](https://play.golang.org/p/8xS5r9g1Uy)  

上述程序中，第 8 行的 `process` 函数休眠了 10500 毫秒（10.5 秒），接着把 `process successful` 写入 `ch` 信道。在程序中的第 15 行，并发地调用了这个函数。  

在并发地调用了 `process` 协程之后，主协程启动了一个无限循环。这个无限循环在每一次迭代开始时，都会先休眠 1000 毫秒（1 秒），然后执行一个 select 操作。在最开始的 10500 毫秒中，由于 `process` 协程在 10500 毫秒后才会向 `ch` 信道写入数据，因此 `select` 语句的第一个 case（即 `case v := <-ch:`）并未就绪。所以在这期间，程序会执行默认情况，该程序会打印 10 次 `no value received`。  

在 10.5 秒之后，`process` 协程会在第 10 行向 `ch` 写入 `process successful`。现在，就可以执行 `select` 语句的第一个 case 了，程序会打印 `received value:  process successful`，然后程序终止。该程序会输出：  

```
no value received  
no value received  
no value received  
no value received  
no value received  
no value received  
no value received  
no value received  
no value received  
no value received  
received value:  process successful
```

## 死锁与默认情况

```go
package main

func main() {  
    ch := make(chan string)
    select {
    case <-ch:
    }
}
```

[在线运行程序](https://play.golang.org/p/za0GZ4o7HH)  

上面的程序中，我们在第 4 行创建了一个信道 `ch`。我们在 `select` 内部（第 6 行），试图读取信道 `ch`。由于没有 Go 协程向该信道写入数据，因此 `select` 语句会一直阻塞，导致死锁。该程序会触发运行时 `panic`，报错信息如下：  

```
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan receive]:  
main.main()  
    /tmp/sandbox416567824/main.go:6 +0x80
```

如果存在默认情况，就不会发生死锁，因为在没有其他 case 准备就绪时，会执行默认情况。我们用默认情况重写后，程序如下：  

```go
package main

import "fmt"

func main() {  
    ch := make(chan string)
    select {
    case <-ch:
    default:
        fmt.Println("default case executed")
    }
}
```

[在线运行程序](https://play.golang.org/p/Pxsh_KlFUw)  

以上程序会输出：  

```
default case executed
```

如果 `select` 只含有值为 `nil` 的信道，也同样会执行默认情况。  

```go
package main

import "fmt"

func main() {  
    var ch chan string
    select {
    case v := <-ch:
        fmt.Println("received value", v)
    default:
        fmt.Println("default case executed")

    }
}
```

[在线运行程序](https://play.golang.org/p/IKmGpN61m1)  

在上面程序中，`ch` 等于 `nil`，而我们试图在 `select` 中读取 `ch`（第 8 行）。如果没有默认情况，`select` 会一直阻塞，导致死锁。由于我们在 `select` 内部加入了默认情况，程序会执行它，并输出：  

```
default case executed
```

## 随机选取

当 `select` 由多个 case 准备就绪时，将会随机地选取其中之一去执行。  

```go
package main

import (  
    "fmt"
    "time"
)

func server1(ch chan string) {  
    ch <- "from server1"
}
func server2(ch chan string) {  
    ch <- "from server2"

}
func main() {  
    output1 := make(chan string)
    output2 := make(chan string)
    go server1(output1)
    go server2(output2)
    time.Sleep(1 * time.Second)
    select {
    case s1 := <-output1:
        fmt.Println(s1)
    case s2 := <-output2:
        fmt.Println(s2)
    }
}
```

[在线运行程序](https://play.golang.org/p/vJ6VhVl9YY)  

在上面程序里，我们在第 18 行和第 19 行分别调用了 `server1` 和 `server2` 两个 Go 协程。接下来，主程序休眠了 1 秒钟（第 20 行）。当程序控制到达第 21 行的 `select` 语句时，`server1` 已经把 `from server1` 写到了 `output1` 信道上，而 `server2` 也同样把 `from server2` 写到了 `output2` 信道上。因此这个 `select` 语句中的两种情况都准备好执行了。如果你运行这个程序很多次的话，输出会是 `from server1` 或者 `from server2`，这会根据随机选取的结果而变化。  

请在你的本地系统上运行这个程序，获得程序的随机结果。因为如果你在 playground 上在线运行的话，它的输出总是一样的，这是由于 playground 不具有随机性所造成的。  

## 这下我懂了：空 select

```go
package main

func main() {  
    select {}
}
```

[在线运行程序](https://play.golang.org/p/u8hErIxgxs)  

你认为上面代码会输出什么？  

我们已经知道，除非有 case 执行，select 语句就会一直阻塞着。在这里，`select` 语句没有任何 case，因此它会一直阻塞，导致死锁。该程序会触发 panic，输出如下：  

```
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [select (no cases)]:  
main.main()  
    /tmp/sandbox299546399/main.go:4 +0x20
```

本教程到此结束。祝你愉快。  

**上一教程 - [缓冲信道和工作池](https://studygolang.com/articles/12512)**

**下一教程 - [Mutex](https://studygolang.com/articles/12598)**

------

via: https://golangbot.com/select/

# 25. Mutex 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-15 11:41:13 · 22484 次点击 · 					预计阅读时间 6 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-15 11:41:13 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 25 篇。  

本教程我们学习 Mutex。我们还会学习怎样通过 Mutex 和[信道](https://studygolang.com/articles/12402)来处理竞态条件（Race Condition）。  

## 临界区

在学习 Mutex 之前，我们需要理解并发编程中临界区（Critical Section）的概念。当程序并发地运行时，多个 [Go 协程](https://studygolang.com/articles/12342)不应该同时访问那些修改共享资源的代码。这些修改共享资源的代码称为临界区。例如，假设我们有一段代码，将一个变量 `x` 自增 1。  

```go
x = x + 1
```

如果只有一个 Go 协程访问上面的代码段，那都没有任何问题。  

但当有多个协程并发运行时，代码却会出错，让我们看看究竟是为什么吧。简单起见，假设在一行代码的前面，我们已经运行了两个 Go 协程。  

在上一行代码的内部，系统执行程序时分为如下几个步骤（这里其实还有很多包括寄存器的技术细节，以及加法的工作原理等，但对于我们的系列教程，只需认为只有三个步骤就好了）：  

1. 获得 x 的当前值
2. 计算 x + 1
3. 将步骤 2 计算得到的值赋值给 x

如果只有一个协程执行上面的三个步骤，不会有问题。  

我们讨论一下当有两个并发的协程执行该代码时，会发生什么。下图描述了当两个协程并发地访问代码行 `x = x + 1` 时，可能出现的一种情况。  

![one-scenario](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/cs5.png)  

我们假设 `x` 的初始值为 0。而协程 1 获取 `x` 的初始值，并计算 `x + 1`。而在协程 1 将计算值赋值给 `x` 之前，系统上下文切换到了协程 2。于是，协程 2 获取了 `x` 的初始值（依然为 0），并计算 `x + 1`。接着系统上下文又切换回了协程 1。现在，协程 1 将计算值 1 赋值给 `x`，因此 `x` 等于 1。然后，协程 2 继续开始执行，把计算值（依然是 1）复制给了 `x`，因此在所有协程执行完毕之后，`x` 都等于 1。  

现在我们考虑另外一种可能发生的情况。  

![another-scenario](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/cs-6.png)  

在上面的情形里，协程 1 开始执行，完成了三个步骤后结束，因此 `x` 的值等于 1。接着，开始执行协程 2。目前 `x` 的值等于 1。而当协程 2 执行完毕时，`x` 的值等于 2。  

所以，从这两个例子你可以发现，根据上下文切换的不同情形，`x` 的最终值是 1 或者 2。这种不太理想的情况称为竞态条件（Race Condition），其程序的输出是由协程的执行顺序决定的。  

**在上例中，如果在任意时刻只允许一个 Go 协程访问临界区，那么就可以避免竞态条件。而使用 Mutex 可以达到这个目的**。  

## Mutex

Mutex 用于提供一种加锁机制（Locking Mechanism），可确保在某时刻只有一个协程在临界区运行，以防止出现竞态条件。  

Mutex 可以在 [sync](https://golang.org/pkg/sync/) 包内找到。[Mutex](https://tip.golang.org/pkg/sync/#Mutex) 定义了两个方法：[Lock](https://tip.golang.org/pkg/sync/#Mutex.Lock) 和 [Unlock](https://tip.golang.org/pkg/sync/#Mutex.Unlock)。所有在 `Lock` 和 `Unlock` 之间的代码，都只能由一个 Go 协程执行，于是就可以避免竞态条件。  

```go
mutex.Lock()  
x = x + 1  
mutex.Unlock()
```

在上面的代码中，`x = x + 1` 只能由一个 Go 协程执行，因此避免了竞态条件。  

如果有一个 Go 协程已经持有了锁（Lock），当其他协程试图获得该锁时，这些协程会被阻塞，直到 Mutex 解除锁定为止。  

## 含有竞态条件的程序

在本节里，我们会编写一个含有竞态条件的程序，而在接下来一节，我们再修复竞态条件的问题。  

```go
package main  
import (  
    "fmt"
    "sync"
    )
var x  = 0  
func increment(wg *sync.WaitGroup) {  
    x = x + 1
    wg.Done()
}
func main() {  
    var w sync.WaitGroup
    for i := 0; i < 1000; i++ {
        w.Add(1)        
        go increment(&w)
    }
    w.Wait()
    fmt.Println("final value of x", x)
}
```

在上述程序里，第 7 行的 `increment` 函数把 `x` 的值加 1，并调用 [WaitGroup](https://studygolang.com/articles/12512) 的 `Done()`，通知该函数已结束。  

在上述程序的第 15 行，我们生成了 1000 个 `increment` 协程。每个 Go 协程并发地运行，由于第 8 行试图增加 `x` 的值，因此多个并发的协程试图访问 `x` 的值，这时就会发生竞态条件。  

由于 [playground](http://play.golang.org) 具有确定性，竞态条件不会在 playground 发生，请在你的本地运行该程序。请在你的本地机器上多运行几次，可以发现由于竞态条件，每一次输出都不同。我其中遇到的几次输出有 `final value of x 941`、`final value of x 928`、`final value of x 922` 等。  

## 使用 Mutex

在前面的程序里，我们创建了 1000 个 Go 协程。如果每个协程对 `x` 加 1，最终 `x` 期望的值应该是 1000。在本节，我们会在程序里使用 Mutex，修复竞态条件的问题。  

```go
package main  
import (  
    "fmt"
    "sync"
    )
var x  = 0  
func increment(wg *sync.WaitGroup, m *sync.Mutex) {  
    m.Lock()
    x = x + 1
    m.Unlock()
    wg.Done()   
}
func main() {  
    var w sync.WaitGroup
    var m sync.Mutex
    for i := 0; i < 1000; i++ {
        w.Add(1)        
        go increment(&w, &m)
    }
    w.Wait()
    fmt.Println("final value of x", x)
}
```

[在 playground 中运行](https://play.golang.org/p/VX9dwGhR62)  

[Mutex](https://golang.org/pkg/sync/#Mutex) 是一个结构体类型，我们在第 15 行创建了 `Mutex` 类型的变量 `m`，其值为零值。在上述程序里，我们修改了 `increment` 函数，将增加 `x` 的代码（`x = x + 1`）放置在 `m.Lock()` 和 `m.Unlock()`之间。现在这段代码不存在竞态条件了，因为任何时刻都只允许一个协程执行这段代码。  

于是如果运行该程序，会输出：  

```
final value of x 1000
```

在第 18 行，传递 Mutex 的地址很重要。如果传递的是 Mutex 的值，而非地址，那么每个协程都会得到 Mutex 的一份拷贝，竞态条件还是会发生。  

## 使用信道处理竞态条件

我们还能用信道来处理竞态条件。看看是怎么做的。  

```go
package main  
import (  
    "fmt"
    "sync"
    )
var x  = 0  
func increment(wg *sync.WaitGroup, ch chan bool) {  
    ch <- true
    x = x + 1
    <- ch
    wg.Done()   
}
func main() {  
    var w sync.WaitGroup
    ch := make(chan bool, 1)
    for i := 0; i < 1000; i++ {
        w.Add(1)        
        go increment(&w, ch)
    }
    w.Wait()
    fmt.Println("final value of x", x)
}
```

[在 playground 中 运行](https://play.golang.org/p/M1fPEK9lYz)  

在上述程序中，我们创建了容量为 1 的[缓冲信道](https://studygolang.com/articles/12512)，并在第 18 行将它传入 `increment` 协程。该缓冲信道用于保证只有一个协程访问增加 `x` 的临界区。具体的实现方法是在 `x` 增加之前（第 8 行），传入 `true` 给缓冲信道。由于缓冲信道的容量为 1，所以任何其他协程试图写入该信道时，都会发生阻塞，直到 `x` 增加后，信道的值才会被读取（第 10 行）。实际上这就保证了只允许一个协程访问临界区。  

该程序也输出：  

```
final value of x 1000
```

## Mutex vs 信道

通过使用 Mutex  和信道，我们已经解决了竞态条件的问题。那么我们该选择使用哪一个？答案取决于你想要解决的问题。如果你想要解决的问题更适用于 Mutex，那么就用  Mutex。如果需要使用 Mutex，无须犹豫。而如果该问题更适用于信道，那就使用信道。:)  

由于信道是 Go 语言很酷的特性，大多数 Go 新手处理每个并发问题时，使用的都是信道。这是不对的。Go 给了你选择 Mutex 和信道的余地，选择其中之一都可以是正确的。  

总体说来，当 Go 协程需要与其他协程通信时，可以使用信道。而当只允许一个协程访问临界区时，可以使用 Mutex。  

就我们上面解决的问题而言，我更倾向于使用 Mutex，因为该问题并不需要协程间的通信。所以 Mutex 是很自然的选择。  

我的建议是去选择针对问题的工具，而别让问题去将就工具。:)  

本教程到此结束。祝你愉快。  

**上一教程 - [Select](https://studygolang.com/articles/12522)**

# 26. 结构体取代类 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-20 09:56:47 · 19113 次点击 · 					预计阅读时间 6 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-20 09:56:47 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 26 篇。

## Go 支持面向对象吗？

Go 并不是完全面向对象的编程语言。Go 官网的 [FAQ](https://golang.org/doc/faq#Is_Go_an_object-oriented_language) 回答了 Go 是否是面向对象语言，摘录如下。

> 可以说是，也可以说不是。虽然 Go 有类型和方法，支持面向对象的编程风格，但却没有类型的层次结构。Go  中的“接口”概念提供了一种不同的方法，我们认为它易于使用，也更为普遍。Go  也可以将结构体嵌套使用，这与子类化（Subclassing）类似，但并不完全相同。此外，Go 提供的特性比 C++ 或 Java  更为通用：子类可以由任何类型的数据来定义，甚至是内建类型（如简单的“未装箱的”整型）。这在结构体（类）中没有受到限制。

在接下来的教程里，我们会讨论如何使用 Go 来实现面向对象编程概念。与其它面向对象语言（如 Java）相比，Go 有很多完全不同的特性。

## 使用结构体，而非类

Go 不支持类，而是提供了[结构体](https://studygolang.com/articles/12263)。结构体中可以添加[方法](https://studygolang.com/articles/12264)。这样可以将数据和操作数据的方法绑定在一起，实现与类相似的效果。

为了加深理解，我们来编写一个示例吧。

在示例中，我们创建一个自定义[包](https://studygolang.com/articles/11893)，它帮助我们更好地理解，结构体是如何有效地取代类的。

在你的 Go 工作区创建一个名为 `oop` 的文件夹。在 `opp` 中再创建子文件夹 `employee`。在 `employee` 内，创建一个名为 `employee.go` 的文件。

文件夹结构会是这样：

```
workspacepath -> oop -> employee -> employee.go
```

请将 `employee.go` 里的内容替换为如下所示的代码。

```go
package employee

import (  
    "fmt"
)

type Employee struct {  
    FirstName   string
    LastName    string
    TotalLeaves int
    LeavesTaken int
}

func (e Employee) LeavesRemaining() {  
    fmt.Printf("%s %s has %d leaves remaining", e.FirstName, e.LastName, (e.TotalLeaves - e.LeavesTaken))
}
```

在上述程序里，第 1 行指定了该文件属于 `employee` 包。而第 7 行声明了一个 `Employee` 结构体。在第 14 行，结构体 `Employee` 添加了一个名为 `LeavesRemaining` 的方法。该方法会计算和显示员工的剩余休假数。于是现在我们有了一个结构体，并绑定了结构体的方法，这与类很相似。

接着在 `oop` 文件夹里创建一个文件，命名为 `main.go`。

现在目录结构如下所示：  

```
workspacepath -> oop -> employee -> employee.go  
workspacepath -> oop -> main.go
```

`main.go` 的内容如下所示：

```go
package main

import "oop/employee"

func main() {  
    e := employee.Employee {
        FirstName: "Sam",
        LastName: "Adolf",
        TotalLeaves: 30,
        LeavesTaken: 20,
    }
    e.LeavesRemaining()
}
```

我们在第 3 行引用了 `employee` 包。在 `main()`（第 12 行），我们调用了 `Employee` 的 `LeavesRemaining()` 方法。

由于有自定义包，这个程序不能在 go playground 上运行。你可以在你的本地运行，在 `workspacepath/bin/oop` 下输入命令 `go install opp`，程序会打印输出：

```bash
Sam Adolf has 10 leaves remaining
```

## 使用 New() 函数，而非构造器

我们上面写的程序看起来没什么问题，但还是有一些细节问题需要注意。我们看看当定义一个零值的 `employee` 结构体变量时，会发生什么。将 `main.go` 的内容修改为如下代码：

```go
package main

import "oop/employee"

func main() {  
    var e employee.Employee
    e.LeavesRemaining()
}
```

我们的修改只是创建一个零值的 `Employee` 结构体变量（第 6 行）。该程序会输出：

```bash
has 0 leaves remaining
```

你可以看到，使用 `Employee` 创建的零值变量没有什么用。它没有合法的姓名，也没有合理的休假细节。

在像 Java 这样的 OOP 语言中，是使用构造器来解决这种问题的。一个合法的对象必须使用参数化的构造器来创建。

Go 并不支持构造器。如果某类型的零值不可用，需要程序员来隐藏该类型，避免从其他包直接访问。程序员应该提供一种名为 `NewT(parameters)` 的 [函数](https://studygolang.com/articles/11892)，按照要求来初始化 `T` 类型的变量。按照 Go 的惯例，应该把创建 `T` 类型变量的函数命名为 `NewT(parameters)`。这就类似于构造器了。如果一个包只含有一种类型，按照 Go 的惯例，应该把函数命名为 `New(parameters)`， 而不是 `NewT(parameters)`。

让我修改一下原先的代码，使得每当创建 `employee` 的时候，它都是可用的。

首先应该让 `Employee` 结构体不可引用，然后创建一个 `New` 函数，用于创建 `Employee` 结构体变量。在 `employee.go` 中输入下面代码：  

```go
package employee

import (  
    "fmt"
)

type employee struct {  
    firstName   string
    lastName    string
    totalLeaves int
    leavesTaken int
}

func New(firstName string, lastName string, totalLeave int, leavesTaken int) employee {  
    e := employee {firstName, lastName, totalLeave, leavesTaken}
    return e
}

func (e employee) LeavesRemaining() {  
    fmt.Printf("%s %s has %d leaves remaining", e.firstName, e.lastName, (e.totalLeaves - e.leavesTaken))
}
```

我们进行了一些重要的修改。我们把 `Employee` 结构体的首字母改为小写 `e`，也就是将 `type Employee struct` 改为了 `type employee struct`。通过这种方法，我们把 `employee` 结构体变为了不可引用的，防止其他包对它的访问。除非有特殊需求，否则也要隐藏所有不可引用的结构体的所有字段，这是 Go 的最佳实践。由于我们不会在外部包需要 `employee` 的字段，因此我们也让这些字段无法引用。

同样，我们还修改了 `LeavesRemaining()` 的方法。

现在由于 `employee` 不可引用，因此不能在其他包内直接创建 `Employee` 类型的变量。于是我们在第 14 行提供了一个可引用的 `New` 函数，该函数接收必要的参数，返回一个新创建的 `employee` 结构体变量。

这个程序还需要一些必要的修改，但现在先运行这个程序，理解一下当前的修改。如果运行当前程序，编译器会报错，如下所示：

```bash
go/src/constructor/main.go:6: undefined: employee.Employee
```

这是因为我们将 `Employee` 设置为不可引用，因此编译器会报错，提示该类型没有在 `main.go` 中定义。很完美，正如我们期望的一样，其他包现在不能轻易创建零值的 `employee` 变量了。我们成功地避免了创建不可用的 `employee` 结构体变量。现在创建 `employee` 变量的唯一方法就是使用 `New` 函数。

如下所示，修改 `main.go` 里的内容。

```go
package main  

import "oop/employee"

func main() {  
    e := employee.New("Sam", "Adolf", 30, 20)
    e.LeavesRemaining()
}
```

该文件唯一的修改就是第 6 行。通过向 `New` 函数传入所需变量，我们创建了一个新的 `employee` 结构体变量。

下面是修改后的两个文件的内容。

employee.go

```go
package employee

import (  
    "fmt"
)

type employee struct {  
    firstName   string
    lastName    string
    totalLeaves int
    leavesTaken int
}

func New(firstName string, lastName string, totalLeave int, leavesTaken int) employee {  
    e := employee {firstName, lastName, totalLeave, leavesTaken}
    return e
}

func (e employee) LeavesRemaining() {  
    fmt.Printf("%s %s has %d leaves remaining", e.firstName, e.lastName, (e.totalLeaves - e.leavesTaken))
}
```

main.go

```go
package main  

import "oop/employee"

func main() {  
    e := employee.New("Sam", "Adolf", 30, 20)
    e.LeavesRemaining()
}
```

运行该程序，会输出：

```bash
Sam Adolf has 10 leaves remaining
```

现在你能明白了，虽然 Go 不支持类，但结构体能够很好地取代类，而以 `New(parameters)` 签名的方法可以替代构造器。

关于 Go 中的类和构造器到此结束。祝你愉快。

**上一教程 - [Mutex](https://studygolang.com/articles/12598)**

# 27. 组合取代继承 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-25 21:42:49 · 14826 次点击 · 					预计阅读时间 6 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-25 21:42:49 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 27 篇。

Go 不支持继承，但它支持组合（Composition）。组合一般定义为“合并在一起”。汽车就是一个关于组合的例子：一辆汽车由车轮、引擎和其他各种部件组合在一起。

## 通过嵌套结构体进行组合

在 Go 中，通过在结构体内嵌套结构体，可以实现组合。

组合的典型例子就是博客帖子。每一个博客的帖子都有标题、内容和作者信息。使用组合可以很好地表示它们。通过学习本教程后面的内容，我们会知道如何实现组合。

我们首先创建一个 `author` 结构体。

```go
package main

import (  
    "fmt"
)

type author struct {  
    firstName string
    lastName  string
    bio       string
}

func (a author) fullName() string {  
    return fmt.Sprintf("%s %s", a.firstName, a.lastName)
}
```

在上面的代码片段中，我们创建了一个 `author` 结构体，`author` 的字段有 `firstname`、`lastname` 和 `bio`。我们还添加了一个 `fullName()` 方法，其中 `author` 作为接收者类型，该方法返回了作者的全名。

下一步我们创建 `post` 结构体。

```go
type post struct {  
    title     string
    content   string
    author
}

func (p post) details() {  
    fmt.Println("Title: ", p.title)
    fmt.Println("Content: ", p.content)
    fmt.Println("Author: ", p.author.fullName())
    fmt.Println("Bio: ", p.author.bio)
}
```

`post` 结构体的字段有 `title` 和 `content`。它还有一个嵌套的匿名字段 `author`。该字段指定 `author` 组成了 `post` 结构体。现在 `post` 可以访问 `author` 结构体的所有字段和方法。我们同样给 `post` 结构体添加了 `details()` 方法，用于打印标题、内容和作者的全名与简介。

一旦结构体内嵌套了一个结构体字段，Go 可以使我们访问其嵌套的字段，好像这些字段属于外部结构体一样。所以上面第 11 行的 `p.author.fullName()` 可以替换为 `p.fullName()`。于是，`details()` 方法可以重写，如下所示：

```go
func (p post) details() {  
    fmt.Println("Title: ", p.title)
    fmt.Println("Content: ", p.content)
    fmt.Println("Author: ", p.fullName())
    fmt.Println("Bio: ", p.bio)
}
```

现在，我们的 `author` 和 `post` 结构体都已准备就绪，我们来创建一个博客帖子来完成这个程序。

```go
package main

import (  
    "fmt"
)

type author struct {  
    firstName string
    lastName  string
    bio       string
}

func (a author) fullName() string {  
    return fmt.Sprintf("%s %s", a.firstName, a.lastName)
}

type post struct {  
    title   string
    content string
    author
}

func (p post) details() {  
    fmt.Println("Title: ", p.title)
    fmt.Println("Content: ", p.content)
    fmt.Println("Author: ", p.fullName())
    fmt.Println("Bio: ", p.bio)
}

func main() {  
    author1 := author{
        "Naveen",
        "Ramanathan",
        "Golang Enthusiast",
    }
    post1 := post{
        "Inheritance in Go",
        "Go supports composition instead of inheritance",
        author1,
    }
    post1.details()
}
```

[在 playground 上运行](https://play.golang.org/p/sskWaTpJgr)

在上面程序中，main 函数在第 31 行新建了一个 `author` 结构体变量。而在第 36 行，我们通过嵌套 `author1` 来创建一个 `post`。该程序输出：

```bash
Title:  Inheritance in Go  
Content:  Go supports composition instead of inheritance  
Author:  Naveen Ramanathan  
Bio:  Golang Enthusiast
```

## 结构体切片的嵌套

我们可以进一步处理这个示例，使用博客帖子的切片来创建一个网站。![:smile:](https://cdnjs.cloudflare.com/ajax/libs/emojify.js/1.1.0/images/basic/smile.png)

我们首先定义 `website` 结构体。请在上述代码里的 main 函数中，添加下面的代码，并运行它。

```go
type website struct {  
        []post
}
func (w website) contents() {  
    fmt.Println("Contents of Website\n")
    for _, v := range w.posts {
        v.details()
        fmt.Println()
    }
}
```

在你添加上述代码后，当你运行程序时，编译器将会报错，如下所示：

```bash
main.go:31:9: syntax error: unexpected [, expecting field name or embedded type
```

这项错误指出了嵌套的结构体切片 `[]post`。错误的原因是结构体不能嵌套一个匿名切片。我们需要一个字段名。所以我们来修复这个错误，让编译器顺利通过。

```go
type website struct {  
        posts []post
}
```

可以看到，我给帖子的切片 `[]post` 添加了字段名 `posts`。

现在我们来修改主函数，为我们的新网站创建一些帖子吧。

修改后的完整代码如下所示：

```go
package main

import (  
    "fmt"
)

type author struct {  
    firstName string
    lastName  string
    bio       string
}

func (a author) fullName() string {  
    return fmt.Sprintf("%s %s", a.firstName, a.lastName)
}

type post struct {  
    title   string
    content string
    author
}

func (p post) details() {  
    fmt.Println("Title: ", p.title)
    fmt.Println("Content: ", p.content)
    fmt.Println("Author: ", p.fullName())
    fmt.Println("Bio: ", p.bio)
}

type website struct {  
 posts []post
}
func (w website) contents() {  
    fmt.Println("Contents of Website\n")
    for _, v := range w.posts {
        v.details()
        fmt.Println()
    }
}

func main() {  
    author1 := author{
        "Naveen",
        "Ramanathan",
        "Golang Enthusiast",
    }
    post1 := post{
        "Inheritance in Go",
        "Go supports composition instead of inheritance",
        author1,
    }
    post2 := post{
        "Struct instead of Classes in Go",
        "Go does not support classes but methods can be added to structs",
        author1,
    }
    post3 := post{
        "Concurrency",
        "Go is a concurrent language and not a parallel one",
        author1,
    }
    w := website{
        posts: []post{post1, post2, post3},
    }
    w.contents()
}
```

[在 playground 中运行](https://play.golang.org/p/gKaa0RbeAE)

在上面的主函数中，我们创建了一个作者 `author1`，以及三个帖子 `post1`、`post2` 和 `post3`。我们最后通过嵌套三个帖子，在第 62 行创建了网站 `w`，并在下一行显示内容。

程序会输出：

```bash
Contents of Website

Title:  Inheritance in Go  
Content:  Go supports composition instead of inheritance  
Author:  Naveen Ramanathan  
Bio:  Golang Enthusiast

Title:  Struct instead of Classes in Go  
Content:  Go does not support classes but methods can be added to structs  
Author:  Naveen Ramanathan  
Bio:  Golang Enthusiast

Title:  Concurrency  
Content:  Go is a concurrent language and not a parallel one  
Author:  Naveen Ramanathan  
Bio:  Golang Enthusiast
```

本教程到此结束。祝你愉快。

# 28. 多态 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-25 21:47:13 · 17540 次点击 · 					预计阅读时间 9 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-25 21:47:13 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 28 篇。

Go 通过[接口](https://studygolang.com/articles/12266)来实现多态。我们已经讨论过，在 Go 语言中，我们是隐式地实现接口。一个类型如果定义了接口所声明的全部[方法](https://studygolang.com/articles/12264)，那它就实现了该接口。现在我们来看看，利用接口，Go 是如何实现多态的。

## 使用接口实现多态

一个类型如果定义了接口的所有方法，那它就隐式地实现了该接口。

**所有实现了接口的类型，都可以把它的值保存在一个接口类型的变量中。在 Go 中，我们使用接口的这种特性来实现多态**。

通过一个程序我们来理解 Go 语言的多态，它会计算一个组织机构的净收益。为了简单起见，我们假设这个虚构的组织所获得的收入来源于两个项目：`fixed billing` 和 `time and material`。该组织的净收益等于这两个项目的收入总和。同样为了简单起见，我们假设货币单位是美元，而无需处理美分。因此货币只需简单地用 `int` 来表示。（我建议阅读 https://forum.golangbridge.org/t/what-is-the-proper-golang-equivalent-to-decimal-when-dealing-with-money/413 上的文章，学习如何表示美分。感谢 Andreas Matuschek 在评论区指出这一点。）

我们首先定义一个接口 `Income`。

```go
type Income interface {  
    calculate() int
    source() string
}
```

上面定义了接口 `Interface`，它包含了两个方法：`calculate()` 计算并返回项目的收入，而 `source()` 返回项目名称。

下面我们定义一个表示 `FixedBilling` 项目的结构体类型。

```go
type FixedBilling struct {  
    projectName string
    biddedAmount int
}
```

项目 `FixedBillin` 有两个字段：`projectName` 表示项目名称，而 `biddedAmount` 表示组织向该项目投标的金额。

`TimeAndMaterial` 结构体用于表示项目 Time and Material。

```go
type TimeAndMaterial struct {  
    projectName string
    noOfHours  int
    hourlyRate int
}
```

结构体 `TimeAndMaterial` 拥有三个字段名：`projectName`、`noOfHours` 和 `hourlyRate`。

下一步我们给这些结构体类型定义方法，计算并返回实际收入和项目名称。

```go
func (fb FixedBilling) calculate() int {  
    return fb.biddedAmount
}

func (fb FixedBilling) source() string {  
    return fb.projectName
}

func (tm TimeAndMaterial) calculate() int {  
    return tm.noOfHours * tm.hourlyRate
}

func (tm TimeAndMaterial) source() string {  
    return tm.projectName
}
```

在项目 `FixedBilling` 里面，收入就是项目的投标金额。因此我们返回 `FixedBilling` 类型的 `calculate()` 方法。

而在项目 `TimeAndMaterial` 里面，收入等于 `noOfHours` 和 `hourlyRate` 的乘积，作为 `TimeAndMaterial` 类型的 `calculate()` 方法的返回值。

我们还通过 `source()` 方法返回了表示收入来源的项目名称。

由于 `FixedBilling` 和 `TimeAndMaterial` 两个结构体都定义了 `Income` 接口的两个方法：`calculate()` 和 `source()`，因此这两个结构体都实现了 `Income` 接口。

我们来声明一个 `calculateNetIncome` 函数，用来计算并打印总收入。

```go
func calculateNetIncome(ic []Income) {  
    var netincome int = 0
    for _, income := range ic {
        fmt.Printf("Income From %s = $%d\n", income.source(), income.calculate())
        netincome += income.calculate()
    }
    fmt.Printf("Net income of organisation = $%d", netincome)
}
```

上面的[函数](https://studygolang.com/articles/11892)接收一个 `Income` 接口类型的[切片](https://studygolang.com/articles/12121)作为参数。该函数会遍历这个接口切片，并依个调用 `calculate()` 方法，计算出总收入。该函数同样也会通过调用 `source()` 显示收入来源。根据 `Income` 接口的具体类型，程序会调用不同的 `calculate()` 和 `source()` 方法。于是，我们在 `calculateNetIncome` 函数中就实现了多态。

如果在该组织以后增加了新的收入来源，`calculateNetIncome` 无需修改一行代码，就可以正确地计算总收入了。![:smile:](https://cdnjs.cloudflare.com/ajax/libs/emojify.js/1.1.0/images/basic/smile.png)

最后就剩下这个程序的 `main` 函数了。

```go
func main() {  
    project1 := FixedBilling{projectName: "Project 1", biddedAmount: 5000}
    project2 := FixedBilling{projectName: "Project 2", biddedAmount: 10000}
    project3 := TimeAndMaterial{projectName: "Project 3", noOfHours: 160, hourlyRate: 25}
    incomeStreams := []Income{project1, project2, project3}
    calculateNetIncome(incomeStreams)
}
```

在上面的 `main` 函数中，我们创建了三个项目，有两个是 `FixedBilling` 类型，一个是 `TimeAndMaterial` 类型。接着我们创建了一个 `Income` 类型的切片，存放了这三个项目。由于这三个项目都实现了 `Interface` 接口，因此可以把这三个项目放入 `Income` 切片。最后我们将该切片作为参数，调用了 `calculateNetIncome` 函数，显示了项目不同的收益和收入来源。

以下完整的代码供你参考。

```go
package main

import (  
    "fmt"
)

type Income interface {  
    calculate() int
    source() string
}

type FixedBilling struct {  
    projectName string
    biddedAmount int
}

type TimeAndMaterial struct {  
    projectName string
    noOfHours  int
    hourlyRate int
}

func (fb FixedBilling) calculate() int {  
    return fb.biddedAmount
}

func (fb FixedBilling) source() string {  
    return fb.projectName
}

func (tm TimeAndMaterial) calculate() int {  
    return tm.noOfHours * tm.hourlyRate
}

func (tm TimeAndMaterial) source() string {  
    return tm.projectName
}

func calculateNetIncome(ic []Income) {  
    var netincome int = 0
    for _, income := range ic {
        fmt.Printf("Income From %s = $%d\n", income.source(), income.calculate())
        netincome += income.calculate()
    }
    fmt.Printf("Net income of organisation = $%d", netincome)
}

func main() {  
    project1 := FixedBilling{projectName: "Project 1", biddedAmount: 5000}
    project2 := FixedBilling{projectName: "Project 2", biddedAmount: 10000}
    project3 := TimeAndMaterial{projectName: "Project 3", noOfHours: 160, hourlyRate: 25}
    incomeStreams := []Income{project1, project2, project3}
    calculateNetIncome(incomeStreams)
}
```

[在 playground 上运行](https://play.golang.org/p/UClAagvLFT)

该程序会输出：

```
Income From Project 1 = $5000  
Income From Project 2 = $10000  
Income From Project 3 = $4000  
Net income of organisation = $19000
```

## 新增收益流

假设前面的组织通过广告业务，建立了一个新的收益流（Income Stream）。我们可以看到添加它非常简单，并且计算总收益也很容易，我们无需对 `calculateNetIncome` 函数进行任何修改。这就是多态的好处。

我们首先定义 `Advertisement` 类型，并在 `Advertisement` 类型中定义 `calculate()` 和 `source()` 方法。

```go
type Advertisement struct {  
    adName     string
    CPC        int
    noOfClicks int
}

func (a Advertisement) calculate() int {  
    return a.CPC * a.noOfClicks
}

func (a Advertisement) source() string {  
    return a.adName
}
```

`Advertisement` 类型有三个字段，分别是 `adName`、`CPC`（每次点击成本）和 `noOfClicks`（点击次数）。广告的总收益等于 `CPC` 和 `noOfClicks` 的乘积。

现在我们稍微修改一下 `main` 函数，把新的收益流添加进来。

```go
func main() {  
    project1 := FixedBilling{projectName: "Project 1", biddedAmount: 5000}
    project2 := FixedBilling{projectName: "Project 2", biddedAmount: 10000}
    project3 := TimeAndMaterial{projectName: "Project 3", noOfHours: 160, hourlyRate: 25}
    bannerAd := Advertisement{adName: "Banner Ad", CPC: 2, noOfClicks: 500}
    popupAd := Advertisement{adName: "Popup Ad", CPC: 5, noOfClicks: 750}
    incomeStreams := []Income{project1, project2, project3, bannerAd, popupAd}
    calculateNetIncome(incomeStreams)
}
```

我们创建了两个广告项目，即 `bannerAd` 和 `popupAd`。`incomeStream` 切片包含了这两个创建的广告项目。

```go
package main

import (  
    "fmt"
)

type Income interface {  
    calculate() int
    source() string
}

type FixedBilling struct {  
    projectName  string
    biddedAmount int
}

type TimeAndMaterial struct {  
    projectName string
    noOfHours   int
    hourlyRate  int
}

type Advertisement struct {  
    adName     string
    CPC        int
    noOfClicks int
}

func (fb FixedBilling) calculate() int {  
    return fb.biddedAmount
}

func (fb FixedBilling) source() string {  
    return fb.projectName
}

func (tm TimeAndMaterial) calculate() int {  
    return tm.noOfHours * tm.hourlyRate
}

func (tm TimeAndMaterial) source() string {  
    return tm.projectName
}

func (a Advertisement) calculate() int {  
    return a.CPC * a.noOfClicks
}

func (a Advertisement) source() string {  
    return a.adName
}
func calculateNetIncome(ic []Income) {  
    var netincome int = 0
    for _, income := range ic {
        fmt.Printf("Income From %s = $%d\n", income.source(), income.calculate())
        netincome += income.calculate()
    }
    fmt.Printf("Net income of organisation = $%d", netincome)
}

func main() {  
    project1 := FixedBilling{projectName: "Project 1", biddedAmount: 5000}
    project2 := FixedBilling{projectName: "Project 2", biddedAmount: 10000}
    project3 := TimeAndMaterial{projectName: "Project 3", noOfHours: 160, hourlyRate: 25}
    bannerAd := Advertisement{adName: "Banner Ad", CPC: 2, noOfClicks: 500}
    popupAd := Advertisement{adName: "Popup Ad", CPC: 5, noOfClicks: 750}
    incomeStreams := []Income{project1, project2, project3, bannerAd, popupAd}
    calculateNetIncome(incomeStreams)
}
```

[在 playground 中运行](https://play.golang.org/p/BYRYGjSxFN)

上面程序会输出：

```
Income From Project 1 = $5000  
Income From Project 2 = $10000  
Income From Project 3 = $4000  
Income From Banner Ad = $1000  
Income From Popup Ad = $3750  
Net income of organisation = $23750
```

你会发现，尽管我们新增了收益流，但却完全没有修改 `calculateNetIncome` 函数。这就是多态带来的好处。由于新的 `Advertisement` 同样实现了 `Income` 接口，所以我们能够向 `incomeStreams` 切片添加 `Advertisement`。`calculateNetIncome` 无需修改，因为它能够调用 `Advertisement` 类型的 `calculate()` 和 `source()` 方法。

本教程到此结束。祝你愉快。

# 29. Defer 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-30 23:05:21 · 13764 次点击 · 					预计阅读时间 7 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-30 23:05:21 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 29 篇。

## 什么是 defer？

`defer` 语句的用途是：含有 `defer` 语句的函数，会在该函数将要返回之前，调用另一个函数。这个定义可能看起来很复杂，我们通过一个示例就很容易明白了。

## 示例

```go
package main

import (  
    "fmt"
)

func finished() {  
    fmt.Println("Finished finding largest")
}

func largest(nums []int) {  
    defer finished()
    fmt.Println("Started finding largest")
    max := nums[0]
    for _, v := range nums {
        if v > max {
            max = v
        }
    }
    fmt.Println("Largest number in", nums, "is", max)
}

func main() {  
    nums := []int{78, 109, 2, 563, 300}
    largest(nums)
}
```

[在 playground 上运行](https://play.golang.org/p/IlccOsuSUE)

上面的程序很简单，就是找出一个给定切片的最大值。`largest` 函数接收一个 int 类型的[切片](https://studygolang.com/articles/12121)作为参数，然后打印出该切片中的最大值。`largest` 函数的第一行的语句为 `defer finished()`。这表示在 `finished()` 函数将要返回之前，会调用 `finished()` 函数。运行该程序，你会看到有如下输出：

```
Started finding largest  
Largest number in [78 109 2 563 300] is 563  
Finished finding largest
```

`largest` 函数开始执行后，会打印上面的两行输出。而就在 `largest` 将要返回的时候，又调用了我们的延迟函数（Deferred Function），打印出 `Finished finding largest` 的文本。![:smile:](https://cdnjs.cloudflare.com/ajax/libs/emojify.js/1.1.0/images/basic/smile.png)

## 延迟方法

`defer` 不仅限于[函数](https://studygolang.com/articles/11892)的调用，调用[方法](https://studygolang.com/articles/12264)也是合法的。我们写一个小程序来测试吧。

```go
package main

import (  
    "fmt"
)


type person struct {  
    firstName string
    lastName string
}

func (p person) fullName() {  
    fmt.Printf("%s %s",p.firstName,p.lastName)
}

func main() {  
    p := person {
        firstName: "John",
        lastName: "Smith",
    }
    defer p.fullName()
    fmt.Printf("Welcome ")  
}
```

[在 playground 上运行](https://play.golang.org/p/lZ74OAwnRD)

在上面的例子中，我们在第 22 行延迟了一个方法调用。而其他的代码很直观，这里不再解释。该程序输出：

```
Welcome John Smith
```

## 实参取值（Arguments Evaluation）

在 Go 语言中，并非在调用延迟函数的时候才确定实参，而是当执行 `defer` 语句的时候，就会对延迟函数的实参进行求值。

通过一个例子就能够理解了。

```go
package main

import (  
    "fmt"
)

func printA(a int) {  
    fmt.Println("value of a in deferred function", a)
}
func main() {  
    a := 5
    defer printA(a)
    a = 10
    fmt.Println("value of a before deferred function call", a)

}
```

[在 playground 上运行](https://play.golang.org/p/sBnwrUgObd)

在上面的程序里的第 11 行，`a` 的初始值为 5。在第 12 行执行 `defer` 语句的时候，由于 `a` 等于 5，因此延迟函数 `printA` 的实参也等于 5。接着我们在第 13 行将 `a` 的值修改为 10。下一行会打印出 `a` 的值。该程序输出：

```
value of a before deferred function call 10  
value of a in deferred function 5
```

从上面的输出，我们可以看出，在调用了 `defer` 语句后，虽然我们将 `a` 修改为 10，但调用延迟函数 `printA(a)`后，仍然打印的是 5。

## defer 栈

当一个函数内多次调用 `defer` 时，Go 会把 `defer` 调用放入到一个栈中，随后按照后进先出（Last In First Out, LIFO）的顺序执行。

我们下面编写一个小程序，使用 `defer` 栈，将一个字符串逆序打印。

```go
package main

import (  
    "fmt"
)

func main() {  
    name := "Naveen"
    fmt.Printf("Orignal String: %s\n", string(name))
    fmt.Printf("Reversed String: ")
    for _, v := range []rune(name) {
        defer fmt.Printf("%c", v)
    }
}
```

[在 playground 上运行](https://play.golang.org/p/HDk623ozuw)

在上述程序中的第 11 行，`for range` 循环会遍历一个字符串，并在第 12 行调用了 `defer fmt.Printf("%c", v)`。这些延迟调用会添加到一个栈中，按照后进先出的顺序执行，因此，该字符串会逆序打印出来。该程序会输出：

```
Orignal String: Naveen  
Reversed String: neevaN
```

## defer 的实际应用

目前为止，我们看到的代码示例，都没有体现出 `defer` 的实际用途。本节我们会看看 `defer` 的实际应用。

当一个函数应该在与当前代码流（Code Flow）无关的环境下调用时，可以使用 `defer`。我们通过一个用到了 [`WaitGroup`](https://studygolang.com/articles/12512) 代码示例来理解这句话的含义。我们首先会写一个没有使用 `defer` 的程序，然后我们会用 `defer` 来修改，看到 `defer` 带来的好处。

```go
package main

import (  
    "fmt"
    "sync"
)

type rect struct {  
    length int
    width  int
}

func (r rect) area(wg *sync.WaitGroup) {  
    if r.length < 0 {
        fmt.Printf("rect %v's length should be greater than zero\n", r)
        wg.Done()
        return
    }
    if r.width < 0 {
        fmt.Printf("rect %v's width should be greater than zero\n", r)
        wg.Done()
        return
    }
    area := r.length * r.width
    fmt.Printf("rect %v's area %d\n", r, area)
    wg.Done()
}

func main() {  
    var wg sync.WaitGroup
    r1 := rect{-67, 89}
    r2 := rect{5, -67}
    r3 := rect{8, 9}
    rects := []rect{r1, r2, r3}
    for _, v := range rects {
        wg.Add(1)
        go v.area(&wg)
    }
    wg.Wait()
    fmt.Println("All go routines finished executing")
}
```

[在 playground 上运行](https://play.golang.org/p/kXL85U0Dd_)

在上面的程序里，我们在第 8 行创建了 `rect` 结构体，并在第 13 行创建了 `rect` 的方法 `area`，计算出矩形的面积。`area` 检查了矩形的长宽是否小于零。如果矩形的长宽小于零，它会打印出对应的提示信息，而如果大于零，它会打印出矩形的面积。

`main` 函数创建了 3 个 `rect` 类型的变量：`r1`、`r2` 和 `r3`。在第 34 行，我们把这 3 个变量添加到了 `rects` 切片里。该切片接着使用 `for range` 循环遍历，把 `area` 方法作为一个并发的 Go 协程进行调用（第 37 行）。我们用 `WaitGroup wg` 来确保 `main` 函数在其他协程执行完毕之后，才会结束执行。`WaitGroup` 作为参数传递给 `area` 方法后，在第 16 行、第 21 行和第 26 行通知 `main` 函数，表示现在协程已经完成所有任务。**如果你仔细观察，会发现 `wg.Done()` 只在 `area` 函数返回的时候才会调用。`wg.Done()` 应该在 `area` 将要返回之前调用，并且与代码流的路径（Path）无关，因此我们可以只调用一次 `defer`，来有效地替换掉 `wg.Done()` 的多次调用**。

我们来用 `defer` 来重写上面的代码。

在下面的代码中，我们移除了原先程序中的 3 个 `wg.Done` 的调用，而是用一个单独的 `defer wg.Done()` 来取代它（第 14 行）。这使得我们的代码更加简洁易懂。

```go
package main

import (  
    "fmt"
    "sync"
)

type rect struct {  
    length int
    width  int
}

func (r rect) area(wg *sync.WaitGroup) {  
    defer wg.Done()
    if r.length < 0 {
        fmt.Printf("rect %v's length should be greater than zero\n", r)
        return
    }
    if r.width < 0 {
        fmt.Printf("rect %v's width should be greater than zero\n", r)
        return
    }
    area := r.length * r.width
    fmt.Printf("rect %v's area %d\n", r, area)
}

func main() {  
    var wg sync.WaitGroup
    r1 := rect{-67, 89}
    r2 := rect{5, -67}
    r3 := rect{8, 9}
    rects := []rect{r1, r2, r3}
    for _, v := range rects {
        wg.Add(1)
        go v.area(&wg)
    }
    wg.Wait()
    fmt.Println("All go routines finished executing")
}
```

[在 playground 上运行](https://play.golang.org/p/JuUvytLfBv)

该程序会输出：

```
rect {8 9}'s area 72  
rect {-67 89}'s length should be greater than zero  
rect {5 -67}'s width should be greater than zero  
All go routines finished executing
```

在上面的程序中，使用 `defer` 还有一个好处。假设我们使用 `if` 条件语句，又给 `area` 方法添加了一条返回路径（Return Path）。如果没有使用 `defer` 来调用 `wg.Done()`，我们就得很小心了，确保在这条新添的返回路径里调用了 `wg.Done()`。由于现在我们延迟调用了 `wg.Done()`，因此无需再为这条新的返回路径添加 `wg.Done()` 了。

本教程到此结束。祝你愉快。

#  30. 错误处理 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-03-31 22:49:56 · 14588 次点击 · 					预计阅读时间 7 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-03-31 22:49:56 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 30 篇。

## 什么是错误？

错误表示程序中出现了异常情况。比如当我们试图打开一个文件时，文件系统里却并没有这个文件。这就是异常情况，它用一个错误来表示。

在 Go 中，错误一直是很常见的。错误用内建的 `error` 类型来表示。

就像其他的内建类型（如 `int`、`float64` 等），错误值可以存储在变量里、作为函数的返回值等等。

## 示例

现在我们开始编写一个示例，该程序试图打开一个并不存在的文件。

```go
package main

import (  
    "fmt"
    "os"
)

func main() {  
    f, err := os.Open("/test.txt")
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(f.Name(), "opened successfully")
}
```

[在 playground 中运行](https://play.golang.org/p/yOhAviFM05)

在程序的第 9 行，我们试图打开路径为 `/test.txt` 的文件（playground 显然并不存在这个文件）。`os` 包里的 [`Open`](https://golang.org/pkg/os/#Open) 函数有如下签名：

```go
func Open(name string) (file *File, err error)
```

**如果成功打开文件，`Open` 函数会返回一个文件句柄（File Handler）和一个值为 `nil` 的错误。而如果打开文件时发生了错误，会返回一个不等于 `nil` 的错误**。

如果一个[函数](https://studygolang.com/articles/11892) 或[方法](https://studygolang.com/articles/12264) 返回了错误，按照惯例，错误会作为最后一个值返回。于是 `Open` 函数也是将 `err` 作为最后一个返回值。

**按照 Go 的惯例，在处理错误时，通常都是将返回的错误与 `nil` 比较。`nil` 值表示了没有错误发生，而非 `nil` 值表示出现了错误**。在这里，我们第 10 行检查了错误值是否为 `nil`。如果不是 `nil`，我们会简单地打印出错误，并在 `main` 函数中返回。

运行该程序会输出：

```
open /test.txt: No such file or directory
```

很棒！我们得到了一个错误，它指出该文件并不存在。

## 错误类型的表示

让我们进一步深入，理解 `error` 类型是如何定义的。`error` 是一个[接口](https://studygolang.com/articles/12266)类型，定义如下：

```go
type error interface {  
    Error() string
}
```

`error` 有了一个签名为 `Error() string` 的方法。所有实现该接口的类型都可以当作一个错误类型。`Error()` 方法给出了错误的描述。

`fmt.Println` 在打印错误时，会在内部调用 `Error() string` 方法来得到该错误的描述。上一节示例中的第 11 行，就是这样打印出错误的描述的。

## 从错误获取更多信息的不同方法

现在，我们知道了 `error` 是一个接口类型，让我们看看如何从一个错误获取更多信息。

在前面的示例里，我们只是打印出错误的描述。如果我们想知道这个错误的文件路径，该怎么做呢？一种选择是直接解析错误的字符串。这是前面示例的输出：

```
open /test.txt: No such file or directory
```

**我们解析了这条错误信息，虽然获取了发生错误的文件路径，但是这种方法很不优雅。随着语言版本的更新，这条错误的描述随时都有可能变化，使我们程序出错**。

有没有更加可靠的方法来获取文件名呢？答案是肯定的，这是可以做到的，Go 标准库给出了各种提取错误相关信息的方法。我们一个个来看看吧。

### 1. 断言底层结构体类型，使用结构体字段获取更多信息

如果你仔细阅读了 [`Open`](https://golang.org/pkg/os/#OpenFile) 函数的文档，你可以看见它返回的错误类型是 `*PathError`。[`PathError`](https://golang.org/pkg/os/#PathError) 是[结构体](https://studygolang.com/articles/12263)类型，它在标准库中的实现如下：

```go
type PathError struct {  
    Op   string
    Path string
    Err  error
}

func (e *PathError) Error() string { return e.Op + " " + e.Path + ": " + e.Err.Error() }
```

如果你有兴趣了解上述源代码出现的位置，可以在这里找到：https://golang.org/src/os/error.go?s=653:716#L11。

通过上面的代码，你就知道了 `*PathError` 通过声明 `Error() string` 方法，实现了 `error` 接口。`Error() string` 将文件操作、路径和实际错误拼接，并返回该字符串。于是我们得到该错误信息：

```
open /test.txt: No such file or directory
```

结构体 `PathError` 的 `Path` 字段，就有导致错误的文件路径。我们修改前面写的程序，打印出该路径。

```go
package main

import (  
    "fmt"
    "os"
)

func main() {  
    f, err := os.Open("/test.txt")
    if err, ok := err.(*os.PathError); ok {
        fmt.Println("File at path", err.Path, "failed to open")
        return
    }
    fmt.Println(f.Name(), "opened successfully")
}
```

[在 playground 上运行](https://play.golang.org/p/JQrqWU7Jf9)

在上面的程序里，我们在第 10 行使用了[类型断言](https://studygolang.com/articles/12266)（Type Assertion）来获取 `error` 接口的底层值（Underlying Value）。接下来在第 11 行，我们使用 `err.Path` 来打印该路径。该程序会输出：

```
File at path /test.txt failed to open
```

很棒！我们已经使用类型断言成功获取到了该错误的文件路径。

### 2. 断言底层结构体类型，调用方法获取更多信息

第二种获取更多错误信息的方法，也是对底层类型进行断言，然后通过调用该结构体类型的方法，来获取更多的信息。

我们通过一个实例来理解这一点。

标准库中的 `DNSError` 结构体类型定义如下：

```go
type DNSError struct {  
    ...
}

func (e *DNSError) Error() string {  
    ...
}
func (e *DNSError) Timeout() bool {  
    ... 
}
func (e *DNSError) Temporary() bool {  
    ... 
}
```

从上述代码可以看到，`DNSError` 结构体还有 `Timeout() bool` 和 `Temporary() bool` 两个方法，它们返回一个布尔值，指出该错误是由超时引起的，还是临时性错误。

接下来我们编写一个程序，断言 `*DNSError` 类型，并调用这些方法来确定该错误是临时性错误，还是由超时导致的。

```go
package main

import (  
    "fmt"
    "net"
)

func main() {  
    addr, err := net.LookupHost("golangbot123.com")
    if err, ok := err.(*net.DNSError); ok {
        if err.Timeout() {
            fmt.Println("operation timed out")
        } else if err.Temporary() {
            fmt.Println("temporary error")
        } else {
            fmt.Println("generic error: ", err)
        }
        return
    }
    fmt.Println(addr)
}
```

**注：在 playground 无法进行 DNS 解析。请在你的本地运行该程序**。

在上述程序中，我们在第 9 行，试图获取 `golangbot123.com`（无效的域名） 的 ip。在第 10 行，我们通过 `*net.DNSError` 的类型断言，获取到了错误的底层值。接下来的第 11 行和第 13 行，我们分别检查了该错误是由超时引起的，还是一个临时性错误。

在本例中，我们的错误既不是临时性错误，也不是由超时引起的，因此该程序输出：

```
generic error:  lookup golangbot123.com: no such host
```

如果该错误是临时性错误，或是由超时引发的，那么对应的 if 语句会执行，于是我们就可以适当地处理它们。

### 3. 直接比较

第三种获取错误的更多信息的方式，是与 `error` 类型的变量直接比较。我们通过一个示例来理解。

`filepath` 包中的 [`Glob`](https://golang.org/pkg/path/filepath/#Glob) 用于返回满足 glob 模式的所有文件名。如果模式写的不对，该函数会返回一个错误 `ErrBadPattern`。

`filepath` 包中的 `ErrBadPattern` 定义如下：

```go
var ErrBadPattern = errors.New("syntax error in pattern")
```

`errors.New()` 用于创建一个新的错误。我们会在下一教程中详细讨论它。

当模式不正确时，`Glob` 函数会返回 `ErrBadPattern`。

我们来写一个小程序来看看这个错误。

```go
package main

import (  
    "fmt"
    "path/filepath"
)

func main() {  
    files, error := filepath.Glob("[")
    if error != nil && error == filepath.ErrBadPattern {
        fmt.Println(error)
        return
    }
    fmt.Println("matched files", files)
}
```

[在 playground 上运行](https://play.golang.org/p/zbVDDHnMZU)

在上述程序里，我们查询了模式为 `[` 的文件，然而这个模式写的不正确。我们检查了该错误是否为 `nil`。为了获取该错误的更多信息，我们在第 10 行将 `error` 直接与 `filepath.ErrBadPattern` 相比较。如果该条件满足，那么该错误就是由模式错误导致的。该程序会输出：

```
syntax error in pattern
```

标准库在提供错误的详细信息时，使用到了上述提到的三种方法。在下一教程里，我们会通过这些方法来创建我们自己的自定义错误。

## 不可忽略错误

绝不要忽略错误。忽视错误会带来问题。接下来我重写上面的示例，在列出所有满足模式的文件名时，我省略了错误处理的代码。

```go
package main

import (  
    "fmt"
    "path/filepath"
)

func main() {  
    files, _ := filepath.Glob("[")
    fmt.Println("matched files", files)
}
```

[在 playground 上运行](https://play.golang.org/p/2k8r_Qg_lc)

我们已经从前面的示例知道了这个模式是错误的。在第 9 行，通过使用 `_` 空白标识符，我忽略了 `Glob` 函数返回的错误。我在第 10 行简单打印了所有匹配的文件。该程序会输出：

```
matched files []
```

由于我忽略了错误，输出看起来就像是没有任何匹配了 glob 模式的文件，但实际上这是因为模式的写法不对。所以绝不要忽略错误。

本教程到此结束。

这一教程我们讨论了该如何处理程序中出现的错误，也讨论了如何查询关于错误的更多信息。简单概括一下本教程讨论的内容：

- 什么是错误？
- 错误的表示
- 获取错误详细信息的各种方法
- 不能忽视错误

在下一教程，我们会创建我们自己的自定义错误，并给标准错误增加更多的语境（Context）。

祝你愉快。

# 31. 自定义错误 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-04-12 22:09:51 · 20154 次点击 · 					预计阅读时间 10 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-04-12 22:09:51 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

![custom errors](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/custom-errors-golang-1.png)

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 31 篇。

在[上一教程](https://studygolang.com/articles/12724)里，我们学习了 Go 中的错误是如何表示的，并学习了如何处理标准库里的错误。我们还学习了从标准库的错误中提取更多的信息。

在本教程中，我们会学习如何创建我们自己的自定义错误，并在我们创建的函数和包中使用它。我们会使用与标准库中相同的技术，来提供自定义错误的更多细节信息。

## 使用 New 函数创建自定义错误

创建自定义错误最简单的方法是使用 [`errors`](https://golang.org/pkg/errors/) 包中的 [`New`](https://golang.org/pkg/errors/#New) 函数。

在使用 New [函数](https://studygolang.com/articles/11892) 创建自定义错误之前，我们先来看看 `New` 是如何实现的。如下所示，是 [`errors` 包](https://golang.org/src/errors/errors.go?s=293:320#L1) 中的 `New` 函数的实现。

```go
// Package errors implements functions to manipulate errors.
package errors

// New returns an error that formats as the given text.
func New(text string) error {
    return &errorString{text}
}

// errorString is a trivial implementation of error.
type errorString struct {
    s string
}

func (e *errorString) Error() string {
    return e.s
}
```

`New` 函数的实现很简单。`errorString` 是一个[结构体](https://studygolang.com/articles/12263)类型，只有一个字符串字段 `s`。第 14 行使用了 `errorString` 指针接受者（Pointer Receiver），来实现 `error` 接口的 `Error() string` [方法](https://studygolang.com/articles/12264)。

第 5 行的 `New` 函数有一个字符串参数，通过这个参数创建了 `errorString` 类型的变量，并返回了它的地址。于是它就创建并返回了一个新的错误。

现在我们已经知道了 `New` 函数是如何工作的，我们开始在程序里使用 `New` 来创建自定义错误吧。

我们将创建一个计算圆半径的简单程序，如果半径为负，它会返回一个错误。

```go
package main

import (  
    "errors"
    "fmt"
    "math"
)

func circleArea(radius float64) (float64, error) {  
    if radius < 0 {
        return 0, errors.New("Area calculation failed, radius is less than zero")
    }
    return math.Pi * radius * radius, nil
}

func main() {  
    radius := -20.0
    area, err := circleArea(radius)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Printf("Area of circle %0.2f", area)
}
```

[在 glayground 上运行](https://play.golang.org/p/_vuf6fgkqm)

在上面的程序中，我们检查半径是否小于零（第 10 行）。如果半径小于零，我们会返回等于 0 的面积，以及相应的错误信息。如果半径大于零，则会计算出面积，并返回值为 `nil` 的错误（第 13 行）。

在 `main` 函数里，我们在第 19 行检查错误是否等于 `nil`。如果不是 `nil`，我们会打印出错误并返回，否则我们会打印出圆的面积。

在我们的程序中，半径小于零，因此打印出：

```
Area calculation failed, radius is less than zero
```

## 使用 Errorf 给错误添加更多信息

上面的程序效果不错，但是如果我们能够打印出当前圆的半径，那就更好了。这就要用到 [`fmt`](https://golang.org/pkg/fmt/) 包中的 [`Errorf`](https://golang.org/pkg/fmt/#Errorf) 函数了。`Errorf` 函数会根据格式说明符，规定错误的格式，并返回一个符合该错误的[字符串](https://studygolang.com/articles/12261)。

接下来我们使用 `Errorf` 函数来改进我们的程序。

```go
package main

import (  
    "fmt"
    "math"
)

func circleArea(radius float64) (float64, error) {  
    if radius < 0 {
        return 0, fmt.Errorf("Area calculation failed, radius %0.2f is less than zero", radius)
    }
    return math.Pi * radius * radius, nil
}

func main() {  
    radius := -20.0
    area, err := circleArea(radius)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Printf("Area of circle %0.2f", area)
}
```

[在 playground 上运行](https://play.golang.org/p/HQ7bvjT4o2)

在上面的程序中，我们使用 `Errorf`（第 10 行）打印了发生错误的半径。程序运行后会输出：

```
Area calculation failed, radius -20.00 is less than zero
```

## 使用结构体类型和字段提供错误的更多信息

错误还可以用实现了 `error` [接口](https://studygolang.com/articles/12266)的结构体来表示。这种方式可以更加灵活地处理错误。在上面例子中，如果我们希望访问引发错误的半径，现在唯一的方法就是解析错误的描述信息 `Area calculation failed, radius -20.00 is less than zero`。这样做不太好，因为一旦描述信息发生变化，程序就会出错。

我们会使用标准库里采用的方法，在上一教程中“断言底层结构体类型，使用结构体字段获取更多信息”这一节，我们讲解了这一方法，可以使用结构体字段来访问引发错误的半径。我们会创建一个实现 `error` 接口的结构体类型，并使用它的字段来提供关于错误的更多信息。

第一步就是创建一个表示错误的结构体类型。错误类型的命名约定是名称以 `Error` 结尾。因此我们不妨把结构体类型命名为 `areaError`。

```go
type areaError struct {  
    err    string
    radius float64
}
```

上面的结构体类型有一个 `radius` 字段，它存储了与错误有关的半径，而 `err` 字段存储了实际的错误信息。

下一步是实现 `error` 接口。

```go
func (e *areaError) Error() string {  
    return fmt.Sprintf("radius %0.2f: %s", e.radius, e.err)
}
```

在上面的代码中，我们使用指针接收者 `*areaError`，实现了 `error` 接口的 `Error() string` 方法。该方法打印出半径和关于错误的描述。

现在我们来编写 `main` 函数和 `circleArea` 函数来完成整个程序。

```go
package main

import (  
    "fmt"
    "math"
)

type areaError struct {  
    err    string
    radius float64
}

func (e *areaError) Error() string {  
    return fmt.Sprintf("radius %0.2f: %s", e.radius, e.err)
}

func circleArea(radius float64) (float64, error) {  
    if radius < 0 {
        return 0, &areaError{"radius is negative", radius}
    }
    return math.Pi * radius * radius, nil
}

func main() {  
    radius := -20.0
    area, err := circleArea(radius)
    if err != nil {
        if err, ok := err.(*areaError); ok {
            fmt.Printf("Radius %0.2f is less than zero", err.radius)
            return
        }
        fmt.Println(err)
        return
    }
    fmt.Printf("Area of rectangle1 %0.2f", area)
}
```

[在 playground 上运行](https://play.golang.org/p/OTs7J0adQg)

在上面的程序中，`circleArea`（第 17 行）用于计算圆的面积。该函数首先检查半径是否小于零，如果小于零，它会通过错误半径和对应错误信息，创建一个 `areaError` 类型的值，然后返回 `areaError` 值的地址，与此同时 `area` 等于 0（第 19 行）。**于是我们提供了更多的错误信息（即导致错误的半径），我们使用了自定义错误的结构体字段来定义它**。

如果半径是非负数，该函数会在第 21 行计算并返回面积，同时错误值为 `nil`。

在 `main` 函数的 26 行，我们试图计算半径为 -20 的圆的面积。由于半径小于零，因此会导致一个错误。

我们在第 27 行检查了错误是否为 `nil`，并在下一行断言了 `*areaError` 类型。**如果错误是 `\*areaError` 类型，我们就可以用 `err.radius` 来获取错误的半径（第 29 行），打印出自定义错误的消息，最后程序返回退出**。

如果断言错误，我们就在第 32 行打印该错误，并返回。如果没有发生错误，在第 35 行会打印出面积。

该程序会输出：

```
Radius -20.00 is less than zero
```

下面我们来使用上一教程提到的[第二种方法](https://studygolang.com/articles/12724)，使用自定义错误类型的方法来提供错误的更多信息。

## 使用结构体类型的方法来提供错误的更多信息

在本节里，我们会编写一个计算矩形面积的程序。如果长或宽小于零，程序就会打印出错误。

第一步就是创建一个表示错误的结构体。

```go
type areaError struct {  
    err    string //error description
    length float64 //length which caused the error
    width  float64 //width which caused the error
}
```

上面的结构体类型除了有一个错误描述字段，还有可能引发错误的宽和高。

现在我们有了错误类型，我们来实现 `error` 接口，并给该错误类型添加两个方法，使它提供了更多的错误信息。

```go
func (e *areaError) Error() string {  
    return e.err
}

func (e *areaError) lengthNegative() bool {  
    return e.length < 0
}

func (e *areaError) widthNegative() bool {  
    return e.width < 0
}
```

在上面的代码片段中，我们从 `Error() string` 方法中返回了关于错误的描述。当 `length` 小于零时，`lengthNegative() bool` 方法返回 `true`，而当 `width` 小于零时，`widthNegative() bool` 方法返回 `true`。**这两个方法都提供了关于错误的更多信息，在这里，它提示我们计算面积失败的原因（长度为负数或者宽度为负数）。于是我们就有了两个错误类型结构体的方法，来提供更多的错误信息**。

下一步就是编写计算面积的函数。

```go
func rectArea(length, width float64) (float64, error) {  
    err := ""
    if length < 0 {
        err += "length is less than zero"
    }
    if width < 0 {
        if err == "" {
            err = "width is less than zero"
        } else {
            err += ", width is less than zero"
        }
    }
    if err != "" {
        return 0, &areaError{err, length, width}
    }
    return length * width, nil
}
```

上面的 `rectArea` 函数检查了长或宽是否小于零，如果小于零，`rectArea` 会返回一个错误信息，否则 `rectArea` 会返回矩形的面积和一个值为 `nil` 的错误。

让我们创建 `main` 函数来完成整个程序。

```go
func main() {  
    length, width := -5.0, -9.0
    area, err := rectArea(length, width)
    if err != nil {
        if err, ok := err.(*areaError); ok {
            if err.lengthNegative() {
                fmt.Printf("error: length %0.2f is less than zero\n", err.length)

            }
            if err.widthNegative() {
                fmt.Printf("error: width %0.2f is less than zero\n", err.width)

            }
            return
        }
        fmt.Println(err)
        return
    }
    fmt.Println("area of rect", area)
}
```

在 `main` 程序中，我们检查了错误是否为 `nil`（第 4 行）。如果错误值不是 `nil`，我们会在下一行断言 `*areaError` 类型。然后，我们使用 `lengthNegative()` 和 `widthNegative()` 方法，检查错误的原因是长度小于零还是宽度小于零。这样我们就使用了错误结构体类型的方法，来提供更多的错误信息。

如果没有错误发生，就会打印矩形的面积。

下面是整个程序的代码供你参考。

```go
package main

import "fmt"

type areaError struct {  
    err    string  //error description
    length float64 //length which caused the error
    width  float64 //width which caused the error
}

func (e *areaError) Error() string {  
    return e.err
}

func (e *areaError) lengthNegative() bool {  
    return e.length < 0
}

func (e *areaError) widthNegative() bool {  
    return e.width < 0
}

func rectArea(length, width float64) (float64, error) {  
    err := ""
    if length < 0 {
        err += "length is less than zero"
    }
    if width < 0 {
        if err == "" {
            err = "width is less than zero"
        } else {
            err += ", width is less than zero"
        }
    }
    if err != "" {
        return 0, &areaError{err, length, width}
    }
    return length * width, nil
}

func main() {  
    length, width := -5.0, -9.0
    area, err := rectArea(length, width)
    if err != nil {
        if err, ok := err.(*areaError); ok {
            if err.lengthNegative() {
                fmt.Printf("error: length %0.2f is less than zero\n", err.length)

            }
            if err.widthNegative() {
                fmt.Printf("error: width %0.2f is less than zero\n", err.width)

            }
            return
        }
        fmt.Println(err)
        return
    }
    fmt.Println("area of rect", area)
}
```

[在 playground 上运行](https://play.golang.org/p/iJv2V8pZ7c)

该程序会打印输出：

```
error: length -5.00 is less than zero  
error: width -9.00 is less than zero
```

在上一教程[错误处理](https://studygolang.com/articles/12724)中，我们介绍了三种提供更多错误信息的方法，现在我们已经看了其中两个示例。

第三种方法使用的是直接比较，比较简单。我留给读者作为练习，你们可以试着使用这种方法来给出自定义错误的更多信息。

本教程到此结束。

简单概括一下本教程讨论的内容：

- 使用 `New` 函数创建自定义错误
- 使用 `Error` 添加更多错误信息
- 使用结构体类型和字段，提供更多错误信息
- 使用结构体类型和方法，提供更多错误信息

祝你愉快。

# 32. panic 和 recover 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-04-12 22:58:17 · 22240 次点击 · 					预计阅读时间 13 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-04-12 22:58:17 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

![panic 和 recover](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/panic-recover-golang-2-2.png)

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 32 篇。

## 什么是 panic？

在 Go 语言中，程序中一般是使用[错误](https://studygolang.com/articles/12724)来处理异常情况。对于程序中出现的大部分异常情况，错误就已经够用了。

但在有些情况，当程序发生异常时，无法继续运行。在这种情况下，我们会使用 `panic` 来终止程序。当[函数](https://studygolang.com/articles/11892)发生 panic 时，它会终止运行，在执行完所有的[延迟](https://studygolang.com/articles/12719)函数后，程序控制返回到该函数的调用方。这样的过程会一直持续下去，直到当前[协程](https://studygolang.com/articles/12342)的所有函数都返回退出，然后程序会打印出 panic 信息，接着打印出堆栈跟踪（Stack Trace），最后程序终止。在编写一个示例程序后，我们就能很好地理解这个概念了。

在本教程里，我们还会接着讨论，当程序发生 panic 时，使用 `recover` 可以重新获得对该程序的控制。

可以认为 `panic` 和 `recover` 与其他语言中的 `try-catch-finally` 语句类似，只不过一般我们很少使用 `panic` 和 `recover`。而当我们使用了 `panic` 和 `recover` 时，也会比 `try-catch-finally` 更加优雅，代码更加整洁。

## 什么时候应该使用 panic？

**需要注意的是，你应该尽可能地使用[错误](https://studygolang.com/articles/12724)，而不是使用 panic 和 recover。只有当程序不能继续运行的时候，才应该使用 panic 和 recover 机制**。

panic 有两个合理的用例。

1. **发生了一个不能恢复的错误，此时程序不能继续运行**。 一个例子就是 web 服务器无法绑定所要求的端口。在这种情况下，就应该使用 panic，因为如果不能绑定端口，啥也做不了。
2. **发生了一个编程上的错误**。 假如我们有一个接收指针参数的方法，而其他人使用 `nil` 作为参数调用了它。在这种情况下，我们可以使用 panic，因为这是一个编程错误：用 `nil` 参数调用了一个只能接收合法指针的方法。

## panic 示例

内建函数 `panic` 的签名如下所示：

```go
func panic(interface{})
```

当程序终止时，会打印传入 `panic` 的参数。我们写一个示例，你就会清楚它的用途了。我们现在就开始吧。

我们会写一个例子，来展示 `panic` 如何工作。

```go
package main

import (  
    "fmt"
)

func fullName(firstName *string, lastName *string) {  
    if firstName == nil {
        panic("runtime error: first name cannot be nil")
    }
    if lastName == nil {
        panic("runtime error: last name cannot be nil")
    }
    fmt.Printf("%s %s\n", *firstName, *lastName)
    fmt.Println("returned normally from fullName")
}

func main() {  
    firstName := "Elon"
    fullName(&firstName, nil)
    fmt.Println("returned normally from main")
}
```

[在 playground 上运行](https://play.golang.org/p/xQJYRSCu8S)

上面的程序很简单，会打印一个人的全名。第 7 行的 `fullName` 函数会打印出一个人的全名。该函数在第 8 行和第 11 行分别检查了 `firstName` 和 `lastName` 的指针是否为 `nil`。如果是 `nil`，`fullName` 函数会调用含有不同的错误信息的 `panic`。当程序终止时，会打印出该错误信息。

运行该程序，会有如下输出：

```
panic: runtime error: last name cannot be nil

goroutine 1 [running]:  
main.fullName(0x1040c128, 0x0)  
    /tmp/sandbox135038844/main.go:12 +0x120
main.main()  
    /tmp/sandbox135038844/main.go:20 +0x80
```

我们来分析这个输出，理解一下 panic 是如何工作的，并且思考当程序发生 panic 时，会怎样打印堆栈跟踪。

在第 19 行，我们将 `Elon` 赋值给了 `firstName`。在第 20 行，我们调用了 `fullName` 函数，其中 `lastName` 等于 `nil`。因此，满足了第 11 行的条件，程序发生 panic。当出现了 panic 时，程序就会终止运行，打印出传入 panic 的参数，接着打印出堆栈跟踪。因此，第 14 行和第 15 行的代码并不会在发生 panic 之后执行。程序首先会打印出传入 `panic` 函数的信息：

```
panic: runtime error: last name cannot be empty
```

接着打印出堆栈跟踪。

程序在 `fullName` 函数的第 12 行发生 panic，因此，首先会打印出如下所示的输出。

```
main.fullName(0x1040c128, 0x0)  
    /tmp/sandbox135038844/main.go:12 +0x120
```

接着会打印出堆栈的下一项。在本例中，堆栈跟踪中的下一项是第 20 行（因为发生 panic 的 `fullName` 调用就在这一行），因此接下来会打印出：

```
main.main()  
    /tmp/sandbox135038844/main.go:20 +0x80
```

现在我们已经到达了导致 panic 的顶层函数，这里没有更多的层级，因此结束打印。

## 发生 panic 时的 defer

我们重新总结一下 panic 做了什么。**当函数发生 panic 时，它会终止运行，在执行完所有的延迟函数后，程序控制返回到该函数的调用方。这样的过程会一直持续下去，直到当前协程的所有函数都返回退出，然后程序会打印出 panic 信息，接着打印出堆栈跟踪，最后程序终止**。

在上面的例子中，我们没有延迟调用任何函数。如果有延迟函数，会先调用它，然后程序控制返回到函数调用方。

我们来修改上面的示例，使用一个延迟语句。

```go
package main

import (  
    "fmt"
)

func fullName(firstName *string, lastName *string) {  
    defer fmt.Println("deferred call in fullName")
    if firstName == nil {
        panic("runtime error: first name cannot be nil")
    }
    if lastName == nil {
        panic("runtime error: last name cannot be nil")
    }
    fmt.Printf("%s %s\n", *firstName, *lastName)
    fmt.Println("returned normally from fullName")
}

func main() {  
    defer fmt.Println("deferred call in main")
    firstName := "Elon"
    fullName(&firstName, nil)
    fmt.Println("returned normally from main")
}
```

[在 playground 上运行](https://play.golang.org/p/oUFnu-uTmC)

上述代码中，我们只修改了两处，分别在第 8 行和第 20 行添加了延迟函数的调用。

该函数会打印：

```
This program prints,

deferred call in fullName  
deferred call in main  
panic: runtime error: last name cannot be nil

goroutine 1 [running]:  
main.fullName(0x1042bf90, 0x0)  
    /tmp/sandbox060731990/main.go:13 +0x280
main.main()  
    /tmp/sandbox060731990/main.go:22 +0xc0
```

当程序在第 13 行发生 panic 时，首先执行了延迟函数，接着控制返回到函数调用方，调用方的延迟函数继续运行，直到到达顶层调用函数。

在我们的例子中，首先执行 `fullName` 函数中的 `defer` 语句（第 8 行）。程序打印出：

```
deferred call in fullName
```

接着程序返回到 `main` 函数，执行了 `main` 函数的延迟调用，因此会输出：

```
deferred call in main
```

现在程序控制到达了顶层函数，因此该函数会打印出 panic 信息，然后是堆栈跟踪，最后终止程序。

## recover

`recover` 是一个内建函数，用于重新获得 panic 协程的控制。

`recover` 函数的标签如下所示：

```go
func recover() interface{}
```

只有在延迟函数的内部，调用 `recover` 才有用。在延迟函数内调用 `recover`，可以取到 `panic` 的错误信息，并且停止 panic 续发事件（Panicking Sequence），程序运行恢复正常。如果在延迟函数的外部调用 `recover`，就不能停止 panic 续发事件。

我们来修改一下程序，在发生 panic 之后，使用 `recover` 来恢复正常的运行。

```go
package main

import (  
    "fmt"
)

func recoverName() {  
    if r := recover(); r!= nil {
        fmt.Println("recovered from ", r)
    }
}

func fullName(firstName *string, lastName *string) {  
    defer recoverName()
    if firstName == nil {
        panic("runtime error: first name cannot be nil")
    }
    if lastName == nil {
        panic("runtime error: last name cannot be nil")
    }
    fmt.Printf("%s %s\n", *firstName, *lastName)
    fmt.Println("returned normally from fullName")
}

func main() {  
    defer fmt.Println("deferred call in main")
    firstName := "Elon"
    fullName(&firstName, nil)
    fmt.Println("returned normally from main")
}
```

[在 playground 上运行](https://play.golang.org/p/I9pp8N55c1)

在第 7 行，`recoverName()` 函数调用了 `recover()`，返回了调用 `panic` 的传参。在这里，我们只是打印出 `recover` 的返回值（第 8 行）。在 `fullName` 函数内，我们在第 14 行延迟调用了 `recoverNames()`。

当 `fullName` 发生 panic 时，会调用延迟函数 `recoverName()`，它使用了 `recover()` 来停止 panic 续发事件。

该程序会输出：

```
recovered from  runtime error: last name cannot be nil  
returned normally from main  
deferred call in main
```

当程序在第 19 行发生 panic 时，会调用延迟函数 `recoverName`，它反过来会调用 `recover()` 来重新获得 panic 协程的控制。第 8 行调用了 `recover`，返回了 `panic` 的传参，因此会打印：

```
recovered from  runtime error: last name cannot be nil
```

在执行完 `recover()` 之后，panic 会停止，程序控制返回到调用方（在这里就是 `main` 函数），程序在发生 panic 之后，从第 29 行开始会继续正常地运行。程序会打印 `returned normally from main`，之后是 `deferred call in main`。

## panic，recover 和 Go 协程

只有在相同的 [Go 协程](https://studygolang.com/articles/12342)中调用 recover 才管用。`recover` 不能恢复一个不同协程的 panic。我们用一个例子来理解这一点。

```go
package main

import (  
    "fmt"
    "time"
)

func recovery() {  
    if r := recover(); r != nil {
        fmt.Println("recovered:", r)
    }
}

func a() {  
    defer recovery()
    fmt.Println("Inside A")
    go b()
    time.Sleep(1 * time.Second)
}

func b() {  
    fmt.Println("Inside B")
    panic("oh! B panicked")
}

func main() {  
    a()
    fmt.Println("normally returned from main")
}
```

[在 playground 上运行](https://play.golang.org/p/pEVzTLz36Y)

在上面的程序中，函数 `b()` 在第 23 行发生 panic。函数 `a()` 调用了一个延迟函数 `recovery()`，用于恢复 panic。在第 17 行，函数 `b()` 作为一个不同的协程来调用。下一行的 `Sleep` 只是保证 `a()` 在 `b()` 运行结束之后才退出。

你认为程序会输出什么？panic 能够恢复吗？答案是否定的，panic 并不会恢复。因为调用 `recovery` 的协程和 `b()` 中发生 panic 的协程并不相同，因此不可能恢复 panic。

运行该程序会输出：

```
Inside A  
Inside B  
panic: oh! B panicked

goroutine 5 [running]:  
main.b()  
    /tmp/sandbox388039916/main.go:23 +0x80
created by main.a  
    /tmp/sandbox388039916/main.go:17 +0xc0
```

从输出可以看出，panic 没有恢复。

如果函数 `b()` 在相同的协程里调用，panic 就可以恢复。

如果程序的第 17 行由 `go b()` 修改为 `b()`，就可以恢复 panic 了，因为 panic 发生在与 recover 相同的协程里。如果运行这个修改后的程序，会输出：

```
Inside A  
Inside B  
recovered: oh! B panicked  
normally returned from main
```

## 运行时 panic

运行时错误（如数组越界）也会导致 panic。这等价于调用了内置函数 `panic`，其参数由接口类型 [runtime.Error](https://golang.org/src/runtime/error.go?s=267:503#L1) 给出。`runtime.Error` 接口的定义如下：

```go
type Error interface {  
    error
    // RuntimeError is a no-op function but
    // serves to distinguish types that are run time
    // errors from ordinary errors: a type is a
    // run time error if it has a RuntimeError method.
    RuntimeError()
}
```

而 `runtime.Error` 接口满足内建接口类型 [`error`](https://golangbot.com/error-handling/#errortyperepresentation)。

我们来编写一个示例，创建一个运行时 panic。

```go
package main

import (  
    "fmt"
)

func a() {  
    n := []int{5, 7, 4}
    fmt.Println(n[3])
    fmt.Println("normally returned from a")
}
func main() {  
    a()
    fmt.Println("normally returned from main")
}
```

[在 playground 上运行](https://play.golang.org/p/CBsK2xXzGg)

在上面的程序中，第 9 行我们试图访问 `n[3]`，这是一个对[切片](https://studygolang.com/articles/12121)的错误引用。该程序会发生 panic，输出如下：

```
panic: runtime error: index out of range

goroutine 1 [running]:  
main.a()  
    /tmp/sandbox780439659/main.go:9 +0x40
main.main()  
    /tmp/sandbox780439659/main.go:13 +0x20
```

你也许想知道，是否可以恢复一个运行时 panic？当然可以！我们来修改一下上面的代码，恢复这个 panic。

```go
package main

import (  
    "fmt"
)

func r() {  
    if r := recover(); r != nil {
        fmt.Println("Recovered", r)
    }
}

func a() {  
    defer r()
    n := []int{5, 7, 4}
    fmt.Println(n[3])
    fmt.Println("normally returned from a")
}

func main() {  
    a()
    fmt.Println("normally returned from main")
}
```

[在 playground 上运行](https://play.golang.org/p/qusvZe5rft)

运行上面程序会输出：

```
Recovered runtime error: index out of range  
normally returned from main
```

从输出可以知道，我们已经恢复了这个 panic。

## 恢复后获得堆栈跟踪

当我们恢复 panic 时，我们就释放了它的堆栈跟踪。实际上，在上述程序里，恢复 panic 之后，我们就失去了堆栈跟踪。

有办法可以打印出堆栈跟踪，就是使用 [`Debug`](https://golang.org/pkg/runtime/debug/) 包中的 [`PrintStack`](https://golang.org/pkg/runtime/debug/#PrintStack) 函数。

```go
package main

import (  
    "fmt"
    "runtime/debug"
)

func r() {  
    if r := recover(); r != nil {
        fmt.Println("Recovered", r)
        debug.PrintStack()
    }
}

func a() {  
    defer r()
    n := []int{5, 7, 4}
    fmt.Println(n[3])
    fmt.Println("normally returned from a")
}

func main() {  
    a()
    fmt.Println("normally returned from main")
}
```

[在 playground 上运行](https://play.golang.org/p/D-QlDmumHV)

在上面的程序中，我们在第 11 行使用了 `debug.PrintStack()` 打印堆栈跟踪。

该程序会输出：

```
Recovered runtime error: index out of range  
goroutine 1 [running]:  
runtime/debug.Stack(0x1042beb8, 0x2, 0x2, 0x1c)  
    /usr/local/go/src/runtime/debug/stack.go:24 +0xc0
runtime/debug.PrintStack()  
    /usr/local/go/src/runtime/debug/stack.go:16 +0x20
main.r()  
    /tmp/sandbox949178097/main.go:11 +0xe0
panic(0xf0a80, 0x17cd50)  
    /usr/local/go/src/runtime/panic.go:491 +0x2c0
main.a()  
    /tmp/sandbox949178097/main.go:18 +0x80
main.main()  
    /tmp/sandbox949178097/main.go:23 +0x20
normally returned from main
```

从输出我们可以看出，首先已经恢复了 panic，打印出 `Recovered runtime error: index out of range`。此外，我们也打印出了堆栈跟踪。在恢复了 panic 之后，还打印出 `normally returned from main`。

本教程到此结束。

简单概括一下本教程讨论的内容：

- 什么是 panic？
- 什么时候应该使用 panic？
- panic 示例
- 发生 panic 时的 defer
- recover
- panic，recover 和 Go 协程
- 运行时 panic
- 恢复后获得堆栈跟踪

祝你愉快。

**上一教程 - [自定义错误](https://studygolang.com/articles/12784)**

**下一教程 - [头等函数](https://studygolang.com/articles/12789)**

------

via: https://golangbot.com/panic-and-recover/

#  33. 函数是一等公民（头等函数） 				

​					 					[Noluye](https://studygolang.com/gctt/Noluye) 				 					 · 2018-04-13 21:35:15 · 16892 次点击 · 					预计阅读时间 9 分钟 · 					大约19小时之前 开始浏览   					 				

这是一个创建于 2018-04-13 21:35:15 的文章，其中的信息可能已经有所发展或是发生改变。

​						[第一次，站长亲自招 Gopher 了>>> ](https://studygolang.com/topics/15255) 				

------

![custom errors](https://raw.githubusercontent.com/studygolang/gctt-images/master/golang-series/first-class-functions-golang.png)

欢迎来到 [Golang 系列教程](https://studygolang.com/subject/2)的第 33 篇。

## 什么是头等（第一类）函数？

**支持头等函数（First Class Function）的编程语言，可以把函数赋值给变量，也可以把函数作为其它函数的参数或者返回值。Go 语言支持头等函数的机制**。

本教程我们会讨论头等函数的语法和用例。

## 匿名函数

我们来编写一个简单的示例，把[函数](https://studygolang.com/articles/11892)赋值给一个[变量](https://studygolang.com/articles/11756)。

```go
package main

import (  
    "fmt"
)

func main() {  
    a := func() {
        fmt.Println("hello world first class function")
    }
    a()
    fmt.Printf("%T", a)
}
```

[在 playground 上运行](https://play.golang.org/p/Xm_ihamhlEv)

在上面的程序中，我们将一个函数赋值给了变量 `a`（第 8 行）。这是把函数赋值给变量的语法。你如果观察得仔细的话，会发现赋值给 `a` 的函数没有名称。**由于没有名称，这类函数称为匿名函数（Anonymous Function）**。

调用该函数的唯一方法就是使用变量 `a`。我们在下一行调用了它。`a()` 调用了这个函数，打印出 `hello world first class function`。在第 12 行，我们打印出 `a` 的类型。这会输出 `func()`。

运行该程序，会输出：

```
hello world first class function
func()
```

要调用一个匿名函数，可以不用赋值给变量。通过下面的例子，我们看看这是怎么做到的。

```go
package main

import (  
    "fmt"
)

func main() {  
    func() {
        fmt.Println("hello world first class function")
    }()
}
```

[在 playground 上运行](https://play.golang.org/p/c0AjB3g8UEn)

在上面的程序中，第 8 行定义了一个匿名函数，并在定义之后，我们使用 `()` 立即调用了该函数（第 10 行）。该程序会输出：

```
hello world first class function
```

就像其它函数一样，还可以向匿名函数传递参数。

```go
package main

import (  
    "fmt"
)

func main() {  
    func(n string) {
        fmt.Println("Welcome", n)
    }("Gophers")
}
```

[在 playground 上运行](https://play.golang.org/p/9ttJ5Wi4fj4)

在上面的程序中，我们向匿名函数传递了一个字符串参数（第 10 行）。运行该程序后会输出：

```
Welcome Gophers
```

## 用户自定义的函数类型

正如我们定义自己的[结构体](https://studygolang.com/articles/12263)类型一样，我们可以定义自己的函数类型。

```go
type add func(a int, b int) int
```

以上代码片段创建了一个新的函数类型 `add`，它接收两个整型参数，并返回一个整型。现在我们来定义 `add` 类型的变量。

我们来编写一个程序，定义一个 `add` 类型的变量。

```go
package main

import (  
    "fmt"
)

type add func(a int, b int) int

func main() {  
    var a add = func(a int, b int) int {
        return a + b
    }
    s := a(5, 6)
    fmt.Println("Sum", s)
}
```

[在 playground 上运行](https://play.golang.org/p/n3yPQ7hG7ip)

在上面程序的第 10 行，我们定义了一个 `add` 类型的变量 `a`，并向它赋值了一个符合 `add` 类型签名的函数。我们在第 13 行调用了该函数，并将结果赋值给 `s`。该程序会输出：

```
Sum 11
```

## 高阶函数

[wiki](https://en.wikipedia.org/wiki/Higher-order_function) 把高阶函数（Hiher-order Function）定义为：**满足下列条件之一的函数**：

- **接收一个或多个函数作为参数**
- **返回值是一个函数**

针对上述两种情况，我们看看一些简单实例。

### 把函数作为参数，传递给其它函数

```go
package main

import (  
    "fmt"
)

func simple(a func(a, b int) int) {  
    fmt.Println(a(60, 7))
}

func main() {  
    f := func(a, b int) int {
        return a + b
    }
    simple(f)
}
```

[在 playground 上运行](https://play.golang.org/p/C0MNwz2TSGU)

在上面的实例中，第 7 行我们定义了一个函数 `simple`，`simple` 接收一个函数参数（该函数接收两个 `int` 参数，返回一个 `a` 整型）。在 `main` 函数的第 12 行，我们创建了一个匿名函数 `f`，其签名符合 `simple` 函数的参数。我们在下一行调用了 `simple`，并传递了参数 `f`。该程序打印输出 67。

### 在其它函数中返回函数

现在我们重写上面的代码，在 `simple` 函数中返回一个函数。

```go
package main

import (  
    "fmt"
)

func simple() func(a, b int) int {  
    f := func(a, b int) int {
        return a + b
    }
    return f
}

func main() {  
    s := simple()
    fmt.Println(s(60, 7))
}
```

[在 playground 上运行](https://play.golang.org/p/82y2caejUy8)

在上面程序中，第 7 行的 `simple` 函数返回了一个函数，并接受两个 `int` 参数，返回一个 `int`。

在第 15 行，我们调用了 `simple` 函数。我们把 `simple` 的返回值赋值给了 `s`。现在 `s` 包含了 `simple` 函数返回的函数。我们调用了 `s`，并向它传递了两个 int 参数（第 16 行）。该程序输出 67。

## 闭包

闭包（Closure）是匿名函数的一个特例。当一个匿名函数所访问的变量定义在函数体的外部时，就称这样的匿名函数为闭包。

看看一个示例就明白了。

```go
package main

import (  
    "fmt"
)

func main() {  
    a := 5
    func() {
        fmt.Println("a =", a)
    }()
}
```

[在 playground 上运行](https://play.golang.org/p/6QriMs-zbnf)

在上面的程序中，匿名函数在第 10 行访问了变量 `a`，而 `a` 存在于函数体的外部。因此这个匿名函数就是闭包。

每一个闭包都会绑定一个它自己的外围变量（Surrounding Variable）。我们通过一个简单示例来体会这句话的含义。

```go
package main

import (  
    "fmt"
)

func appendStr() func(string) string {  
    t := "Hello"
    c := func(b string) string {
        t = t + " " + b
        return t
    }
    return c
}

func main() {  
    a := appendStr()
    b := appendStr()
    fmt.Println(a("World"))
    fmt.Println(b("Everyone"))

    fmt.Println(a("Gopher"))
    fmt.Println(b("!"))
}
```

[在 playground 上运行](https://play.golang.org/p/134NiQGPOcS)

在上面程序中，函数 `appendStr` 返回了一个闭包。这个闭包绑定了变量 `t`。我们来理解这是什么意思。

在第 17 行和第 18 行声明的变量 `a` 和 `b` 都是闭包，它们绑定了各自的 `t` 值。

我们首先用参数 `World` 调用了 `a`。现在 `a` 中 `t` 值变为了 `Hello World`。

在第 20 行，我们又用参数 `Everyone` 调用了 `b`。由于 `b` 绑定了自己的变量 `t`，因此 `b` 中的 `t` 还是等于初始值 `Hello`。于是该函数调用之后，`b` 中的 `t` 变为了 `Hello Everyone`。程序的其他部分很简单，不再解释。

该程序会输出：

```
Hello World  
Hello Everyone  
Hello World Gopher  
Hello Everyone !
```

## 头等函数的实际用途

迄今为止，我们已经定义了什么是头等函数，也看了一些专门设计的示例，来学习它们如何工作。现在我们来编写一些实际的程序，来展现头等函数的实际用处。

我们会创建一个程序，基于一些条件，来过滤一个 `students` 切片。现在我们来逐步实现它。

首先定义一个 `student` 类型。

```go
type student struct {  
    firstName string
    lastName string
    grade string
    country string
}
```

下一步是编写一个 `filter` 函数。该函数接收一个 `students` 切片和一个函数作为参数，这个函数会计算一个学生是否满足筛选条件。写出这个函数后，你很快就会明白，我们继续吧。

```go
func filter(s []student, f func(student) bool) []student {  
    var r []student
    for _, v := range s {
        if f(v) == true {
            r = append(r, v)
        }
    }
    return r
}
```

在上面的函数中，`filter` 的第二个参数是一个函数。这个函数接收 `student` 参数，返回一个 `bool` 值。这个函数计算了某一学生是否满足筛选条件。我们在第 3 行遍历了 `student` 切片，将每个学生作为参数传递给了函数 `f`。如果该函数返回 `true`，就表示该学生通过了筛选条件，接着将该学生添加到了结果切片 `r` 中。你可能会很困惑这个函数的实际用途，等我们完成程序你就知道了。我添加了 `main` 函数，整个程序如下所示：

```go
package main

import (  
    "fmt"
)

type student struct {  
    firstName string
    lastName  string
    grade     string
    country   string
}

func filter(s []student, f func(student) bool) []student {  
    var r []student
    for _, v := range s {
        if f(v) == true {
            r = append(r, v)
        }
    }
    return r
}

func main() {  
    s1 := student{
        firstName: "Naveen",
        lastName:  "Ramanathan",
        grade:     "A",
        country:   "India",
    }
    s2 := student{
        firstName: "Samuel",
        lastName:  "Johnson",
        grade:     "B",
        country:   "USA",
    }
    s := []student{s1, s2}
    f := filter(s, func(s student) bool {
        if s.grade == "B" {
            return true
        }
        return false
    })
    fmt.Println(f)
}
```

[在 playground 上运行](https://play.golang.org/p/YUL1CqSrvfc)

在 `main` 函数中，我们首先创建了两个学生 `s1` 和 `s2`，并将他们添加到了切片 `s`。现在假设我们想要查询所有成绩为 `B` 的学生。为了实现这样的功能，我们传递了一个检查学生成绩是否为 `B` 的函数，如果是，该函数会返回 `true`。我们把这个函数作为参数传递给了 `filter` 函数（第 38 行）。上述程序会输出：

```
[{Samuel Johnson B USA}]
```

假设我们想要查找所有来自印度的学生。通过修改传递给 `filter` 的函数参数，就很容易地实现了。

实现它的代码如下所示：

```go
c := filter(s, func(s student) bool {  
    if s.country == "India" {
        return true
    }
    return false
})
fmt.Println(c)
```

请将该函数添加到 `main` 函数，并检查它的输出。

我们最后再编写一个程序，来结束这一节的讨论。这个程序会对切片的每个元素执行相同的操作，并返回结果。例如，如果我们希望将切片中的所有整数乘以 5，并返回出结果，那么通过头等函数可以很轻松地实现。我们把这种对集合中的每个元素进行操作的函数称为 `map` 函数。相关代码如下所示，它们很容易看懂。

```go
package main

import (  
    "fmt"
)

func iMap(s []int, f func(int) int) []int {  
    var r []int
    for _, v := range s {
        r = append(r, f(v))
    }
    return r
}
func main() {  
    a := []int{5, 6, 7, 8, 9}
    r := iMap(a, func(n int) int {
        return n * 5
    })
    fmt.Println(r)
}
```

[在 playground 上运行](https://play.golang.org/p/cs37QwCQ_0H)

该程序会输出：

```
[25 30 35 40 45]
```

现在简单概括一下本教程讨论的内容：

- 什么是头等函数？
- 匿名函数
- 用户自定义的函数类型
- 高阶函数
  - 把函数作为参数，传递给其它函数
  - 在其它函数中返回函数
- 闭包
- 头等函数的实际用途

