# Go

[TOC]

Go语言是谷歌推出的一种全新的编程语言，旨在不损失应用程序性能的情况下降低代码的复杂性，具有“部署简单、并发性好、语言设计良好、执行性能好”等优势。

Golang，从2007年末，由 Robert Griesemer、Rob Pike 和 Ken Thompson主持开发，后来加入了 Ian  Lance Taylor、Russ Cox 等人，最终于2009年11月开源，在2012年早些时候发布了Go  1稳定版本。

Go语言没有类和继承的概念。通过接口（interface）的概念来实现多态性。

![img](../../Image/g/o/go.png)

**吉祥物：**在会议、文档页面和博文中，大多会包含上图所示的 Go Gopher，这是才华横溢的插画家 Renee French 设计的，她也是 Go 设计者之一 Rob Pike 的妻子。

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
3. 下一行 `func main()` 是程序开始执行的函数。`main` 函数是每一个可执行程序所必须包含的，一般来说都是在启动后第一个执行的函数（如果有 `init()` 函数则会先执行该函数）。man函数没有参数，且必须放在main包中。
4. 下一行 `/*...*/` 是注释，在程序执行时将被忽略。 
5. 下一行 `fmt.Println(...) `可以将字符串输出到控制台，并在最后自动增加换行字符 `\n`。 
   使用 `fmt.Print("hello, world\n")` 可以得到相同的结果。 `Print` 和 `Println ` 这两个函数也支持使用变量，如：`fmt.Println(arr)` 。如果没有特别指定，它们会以默认的打印格式将变量 `arr` 输出到控制台。
6. 当标识符（包括常量、变量、类型、函数名、结构字段等等）以一个大写字母开头，如：Group1，那么使用这种形式的标识符的对象就可以被外部包的代码所使用（客户端程序需要先导入这个包），这被称为导出（像面向对象语言中的 public）；标识符如果以小写字母开头，则对包外是不可见的，但是他们在整个包的内部是可见并且可用的（像面向对象语言中的 protected  ）。
7. 源文件使用UTF-8编码，以`.go`作为文件扩展名，语句结束分号会被默认省略。
8. `{ ` 不能单独放在一行。
9. 不能存在未使用的导入，否则编译器会将其当做错误。

**执行 Go 程序**

1. 使用编辑器编辑代码。

2. 将代码保存为 `hello.go`

3. 打开命令行，并进入程序文件保存的目录中。

4. 输入命令 `go run hello.go` 并按回车执行代码。 

   ```bash
   go run hello.go
   
   Hello, World!
   ```

6. 还可以使用 `go build` 命令来生成二进制文件：

   ```bash
   go build hello.go 
   
   ls
   hello    hello.go
   
   ./hello 
   Hello, World!
   ```

可以生成一个 `build.sh` 脚本，用于在指定位置产生已编译好的可执文件:

```
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



关于包，根据本地测试得出以下几点：

- 文件名与包名没有直接关系，不一定要将文件名与包名定成同一个。
- 文件夹名与包名没有直接关系，并非需要一致。
- 同一个文件夹下的文件只能有一个包名，否则编译报错。

文件结构:

```
Test
--helloworld.go

myMath
--myMath1.go
--myMath2.go
```

测试代码:

```
// helloworld.go
package main

import (
"fmt"
"./myMath"
)

func main(){
    fmt.Println("Hello World!")
    fmt.Println(mathClass.Add(1,1))
    fmt.Println(mathClass.Sub(1,1))
}
```

```
// myMath1.go
package mathClass
func Add(x,y int) int {
    return x + y
}
```

```
// myMath2.go
package mathClass
func Sub(x,y int) int {
    return x - y
}
```







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



![抽象语法树](D:\wfbook\Image\4-191115094600340.gif)
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



![img](D:\wfbook\Image\4-19111511533W48.gif)


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

## 标识符

用来命名变量、类型等程序实体。

一个标识符实际上就是一个或是多个字母(A~Z和a~z)数字(0~9)、下划线_组成的序列，但是第一个字符必须是字母或者下划线而不能是数字。 区分大小写。

如一个名字是在函数内部定义，那么它只在函数内部有效。如果是在函数外部定义，那么将在当前包的所有文件中都可以访问。名字的开头字母的大小写决定了名字在包外的可见性。如果一个名字是大写字母开头的（必须是在函数外部定义的包级名字；包级函数名本身也是包级名字），那么它将是导出的，也就是说可以被外部的包访问。包本身的名字一般总是用小写字母。

名字的长度没有逻辑限制，但是Go语言的风格是尽量使用短小的名字，对于局部变量尤其是这样。

在习惯上，Go语言程序员推荐使用 **驼峰式**  命名，当名字有几个单词组成的时优先使用大小写分隔，而不是优先用下划线分隔。

### 内置关键字

```go
break            default              func            interface        select 
case             defer                go              map              struct 
chan             else                 goto            package          switch 
const            fallthrough          if              range            type
continue         for                  import          return           var
```
### 预定义标识符（36个）

```go
// 内建常量
true  false  iota  nil
// 内建类型
int  int8  int16  int32  int64  uint  uint8  uint16  uint32  uint64  uintptr  float32  float64  complex64  complex128  bool  byte  rune  string  error 
// 内建函数
len  make  cap  new  append  copy  close  delete  complex  real  imag  panic  recover print println
```
## 注释方法

单行注释是最常见的注释形式，可以在任何地方使用。注释不会被编译，每一个包应该有相关注释。

多行注释也叫块注释，不可以嵌套使用，多行注释一般用于包的文档描述或注释成块的代码片段。

```go
// XXXX		单行注释
/* XXXX */	多行注释
```
## 示例

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello,World.")
}
```

执行

```bash
go run hello_world.go

go build hello_world.go
./hello-world
# 编译成二进制文件后执行。
```

## 包

每个Go程序都是有包组成的。程序运行的入口是包"main"。
### 导入
```go
import "XXX"

import (
    "XXX"
    "XXX"
)
```
### 导出名

​    在导入了一个包之后，就可以用其导出的名称来调用它。首字母大写的名称是被导出的。  

### 可见性规则

使用大小写来决定该**常量**、**变量**、**类型**、**接口**、**结构**或**函数**是否可以被外部包所调用。  
函数名首字母**小写**即为private;函数名首字母**大写**即为public.

### 别名
```go
import (
	io "fmt"
)

io.Println("hello world!")
```
### 省略调用
不可与别名同时使用。

```go
import (
	. "fmt"
)

func main() {
Println("hello world!")
}
```
## 声明

 主要有四种类型的声明语句：var、const、type和func，分别对应变量、常量、类型和函数实体对象的声明。

一个Go语言编写的程序对应一个或多个以.go为文件后缀名的源文件中。每个源文件以包的声明语句开始，说明该源文件是属于哪个包。包声明语句之后是import语句导入依赖的其它包，然后是包一级的类型、变量、常量、函数的声明语句，包一级的各种类型的声明语句的顺序无关紧要。


## 常量
### 定义常量
```go
const Pi float64 = 3.14159265358979323846
const zero  = 0.0
const (
	size int64 = 1024
	eof = -1
)
const u, v float32 = 0, 3
const a, b, c = 3, 4, "foo"
```
### 预定义常量
**true**  
**false**  
**iota**  

> 在每一个const关键字出现时被重置为0，在下一个const出现之前，每出现一次iota,所代表的数字会自动增1。



## 运算符
| 运算 | 含义 |
|----|----|
| x << y | 左移 |
| x >> y |右移 |
| x ^ y | 异或 |
| x & y | 与 |
| x | y | 或 |
| ^x | 取反 |
## 循环

只有for循环这一种循环语句。

```go
for initialization; condition; post {
    // zero or more statements
}
```

for循环三个部分不需括号包围。大括号强制要求, 左大括号必须和*post*语句在同一行。

*initialization*语句是可选的，在循环开始前执行。*initalization*如果存在，必须是一条*简单语句*（simple statement），即，短变量声明、自增语句、赋值语句或函数调用。`condition`是一个布尔表达式（boolean expression），其值在每次循环迭代开始时计算。如果为`true`则执行循环体语句。`post`语句在循环体执行结束后执行，之后再次对`conditon`求值。`condition`值为`false`时，循环结束。

for循环的这三个部分每个都可以省略，如果省略`initialization`和`post`，分号也可以省略：

```go
// a traditional "while" loop
for condition {
    // ...
}
```

如果连`condition`也省略了，像下面这样：

```go
// a traditional infinite loop
for {
    // ...
}
```

就变成一个无限循环，尽管如此，还可以用其他方式终止循环, 如一条`break`或`return`语句。

## Other

当两个或多个连续的函数命名参数是同一类型，则除了最后一个类型之外，其他都可以省略。

```go
x int, y int	==>		x, y int
```























## Go 标记

Go 程序可以由多个标记组成，可以是关键字，标识符，常量，字符串，符号。如以下 GO 语句由 6 个标记组成：

```
fmt.Println("Hello, World!")
```

6 个标记是(每行一个)：

```
1. fmt
2. .
3. Println
4. (
5. "Hello, World!"
6. )
```

------

## 行分隔符

在 Go 程序中，一行代表一个语句结束。每个语句不需要像 C 家族中的其它语言一样以分号 ; 结尾，因为这些工作都将由 Go 编译器自动完成。

如果你打算将多个语句写在同一行，它们则必须使用 ; 人为区分，但在实际开发中我们并不鼓励这种做法。

以下为两个语句：

fmt.Println("Hello, World!")
 fmt.Println("菜鸟教程：runoob.com")

------




## 字符串连接

Go 语言的字符串可以通过 + 实现：

## 实例

**package** main
 **import** "fmt"
 func main() {
   fmt.Println("Google" + "Runoob")
 }

以上实例输出结果为：

```
GoogleRunoob
```

------



## Go 语言的空格

Go 语言中变量的声明必须使用空格隔开，如：

```
var age int;
```

语句中适当使用空格能让程序更易阅读。

无空格：

```
fruit=apples+oranges;
```

在变量与运算符间加入空格，程序看起来更加美观，如：

```
fruit = apples + oranges; 
```


# Go 语言变量

变量来源于数学，是计算机语言中能储存计算结果或能表示值抽象概念。

变量可以通过变量名访问。

Go 语言变量名由字母、数字、下划线组成，其中首个字符不能为数字。

声明变量的一般形式是使用 var 关键字：

```
var identifier type
```

可以一次声明多个变量：

```
var identifier1, identifier2 type
```

## 实例

**package** main
 **import** "fmt"
 func main() {
   **var** a string = "Runoob"
   fmt.Println(a)

   **var** b, c int = 1, 2
   fmt.Println(b, c)
 }

以上实例输出结果为：

```
Runoob
1 2
```

### 变量声明

**第一种，指定变量类型，如果没有初始化，则变量默认为零值**。

```
var v_name v_type
v_name = value
```

零值就是变量没有做初始化时系统默认设置的值。

## 实例

**package** main
 **import** "fmt"
 func main() {

   *// 声明一个变量并初始化*
   **var** a = "RUNOOB"
   fmt.Println(a)

   *// 没有初始化就为零值*
   **var** b int
   fmt.Println(b)

   *// bool 零值为 false*
   **var** c bool
   fmt.Println(c)
 }

以上实例执行结果为：

```
RUNOOB
0
false
```

- 数值类型（包括complex64/128）为 **0**

- 布尔类型为 **false**

- 字符串为 **""**（空字符串）

- 以下几种类型为 **nil**：

  ```
  var a *int
  var a []int
  var a map[string] int
  var a chan int
  var a func(string) int
  var a error // error 是接口
  ```

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** i int
   **var** f float64
   **var** b bool
   **var** s string
   fmt.Printf("%v %v %v %q**\n**", i, f, b, s)
 }

输出结果是：

```
0 0 false ""
```

**第二种，根据值自行判定变量类型。**

```
var v_name = value
```

## 实例

**package** main
 **import** "fmt"
 func main() {
   **var** d = **true**
   fmt.Println(d)
 }

输出结果是：

```
true
```

**第三种，省略 var, 注意 := 左侧如果没有声明新的变量，就产生编译错误，格式：**

```
v_name := value
```

例如：

```
var intVal int 

intVal :=1 // 这时候会产生编译错误

intVal,intVal1 := 1,2 // 此时不会产生编译错误，因为有声明新的变量，因为 := 是一个声明语句
```

可以将 var f string = "Runoob" 简写为 f := "Runoob"：

## 实例

**package** main
 **import** "fmt"
 func main() {
   f := "Runoob" *// var f string = "Runoob"*

   fmt.Println(f)
 }

输出结果是：

```
Runoob
```

### 多变量声明

```
//类型相同多个变量, 非全局变量
var vname1, vname2, vname3 type
vname1, vname2, vname3 = v1, v2, v3

var vname1, vname2, vname3 = v1, v2, v3 // 和 python 很像,不需要显示声明类型，自动推断

vname1, vname2, vname3 := v1, v2, v3 // 出现在 := 左侧的变量不应该是已经被声明过的，否则会导致编译错误


// 这种因式分解关键字的写法一般用于声明全局变量
var (
    vname1 v_type1
    vname2 v_type2
)
```

## 实例

**package** main

 **var** x, y int
 **var** (  *// 这种因式分解关键字的写法一般用于声明全局变量*
   a int
   b bool
 )

 **var** c, d int = 1, 2
 **var** e, f = 123, "hello"

 *//这种不带声明格式的只能在函数体中出现*
 *//g, h := 123, "hello"*

 func main(){
   g, h := 123, "hello"
   println(x, y, a, b, c, d, e, f, g, h)
 }

以上实例执行结果为：

```
0 0 0 false 1 2 123 hello 123 hello
```

------

## 值类型和引用类型

所有像 int、float、bool 和 string 这些基本类型都属于值类型，使用这些类型的变量直接指向存在内存中的值：

![4.4.2_fig4.1](D:\wfbook\Image\g\o\4.4.2_fig4.1.jpgrawtrue)

当使用等号 `=` 将一个变量的值赋值给另一个变量时，如：`j = i`，实际上是在内存中将 i 的值进行了拷贝：

![4.4.2_fig4.2](D:\wfbook\Image\g\o\4.4.2_fig4.2.jpgrawtrue)

你可以通过 &i 来获取变量 i 的内存地址，例如：0xf840000040（每次的地址都可能不一样）。值类型的变量的值存储在栈中。

内存地址会根据机器的不同而有所不同，甚至相同的程序在不同的机器上执行后也会有不同的内存地址。因为每台机器可能有不同的存储器布局，并且位置分配也可能不同。

更复杂的数据通常会需要使用多个字，这些数据一般使用引用类型保存。

一个引用类型的变量 r1 存储的是 r1 的值所在的内存地址（数字），或内存地址中第一个字所在的位置。

![4.4.2_fig4.3](D:\wfbook\Image\g\o\4.4.2_fig4.3.jpgrawtrue)

这个内存地址为称之为指针，这个指针实际上也被存在另外的某一个字中。

同一个引用类型的指针指向的多个字可以是在连续的内存地址中（内存布局是连续的），这也是计算效率最高的一种存储形式；也可以将这些字分散存放在内存中，每个字都指示了下一个字所在的内存地址。

当使用赋值语句 r2 = r1 时，只有引用（地址）被复制。

如果 r1 的值被改变了，那么这个值的所有引用都会指向被修改后的内容，在这个例子中，r2 也会受到影响。

------

## 简短形式，使用 := 赋值操作符

我们知道可以在变量的初始化时省略变量的类型而由系统自动推断，声明语句写上 var 关键字其实是显得有些多余了，因此我们可以将它们简写为 a := 50 或 b := false。

a 和 b 的类型（int 和 bool）将由编译器自动推断。

这是使用变量的首选形式，但是它只能被用在函数体内，而不可以用于全局变量的声明与赋值。使用操作符 := 可以高效地创建一个新的变量，称之为初始化声明。

### 注意事项

如果在相同的代码块中，我们不可以再次对于相同名称的变量使用初始化声明，例如：a := 20 就是不被允许的，编译器会提示错误 no new  variables on left side of :=，但是 a = 20 是可以的，因为这是给相同的变量赋予一个新的值。

如果你在定义变量 a 之前使用它，则会得到编译错误 undefined: a。

如果你声明了一个局部变量却没有在相同的代码块中使用它，同样会得到编译错误，例如下面这个例子当中的变量 a：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a string = "abc"
   fmt.Println("hello, world")
 }

尝试编译这段代码将得到错误 **a declared and not used**。

此外，单纯地给 a 赋值也是不够的，这个值必须被使用，所以使用

```
fmt.Println("hello, world", a)
```

 会移除错误。

但是全局变量是允许声明但不使用的。 同一类型的多个变量可以声明在同一行，如：

```
var a, b, c int
```

多变量可以在同一行进行赋值，如：

```
var a, b int
var c string
a, b, c = 5, 7, "abc"
```

上面这行假设了变量 a，b 和 c 都已经被声明，否则的话应该这样使用：

```
a, b, c := 5, 7, "abc"
```

右边的这些值以相同的顺序赋值给左边的变量，所以 a 的值是 5， b 的值是 7，c 的值是 "abc"。

这被称为 并行 或 同时 赋值。

如果你想要交换两个变量的值，则可以简单地使用 a, b = b, a，两个变量的类型必须是相同。

空白标识符 _ 也被用于抛弃值，如值 5 在：_, b = 5, 7 中被抛弃。

_ 实际上是一个只写变量，你不能得到它的值。这样做是因为 Go 语言中你必须使用所有被声明的变量，但有时你并不需要使用从一个函数得到的所有返回值。

并行赋值也被用于当一个函数返回多个返回值时，比如这里的 val 和错误 err 是通过调用 Func1 函数同时得到：val, err = Func1(var1)。

​			

# Go 语言常量

常量是一个简单值的标识符，在程序运行时，不会被修改的量。

常量中的数据类型只可以是布尔型、数字型（整数型、浮点型和复数）和字符串型。

常量的定义格式：

```
const identifier [type] = value
```

你可以省略类型说明符 [type]，因为编译器可以根据变量的值来推断其类型。

- 显式类型定义： `const b string = "abc"`
- 隐式类型定义： `const b = "abc"`

多个相同类型的声明可以简写为：

```
const c_name1, c_name2 = value1, value2
```

以下实例演示了常量的应用：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **const** LENGTH int = 10
   **const** WIDTH int = 5  
   **var** area int
   **const** a, b, c = 1, **false**, "str" *//多重赋值*

   area = LENGTH * WIDTH
   fmt.Printf("面积为 : %d", area)
   println()
   println(a, b, c)  
 }

以上实例运行结果为：

```
面积为 : 50
1 false str
```

常量还可以用作枚举：

```
const (
    Unknown = 0
    Female = 1
    Male = 2
)
```

数字 0、1 和 2 分别代表未知性别、女性和男性。

常量可以用len(), cap(), unsafe.Sizeof()函数计算表达式的值。常量表达式中，函数必须是内置函数，否则编译不过：

## 实例

**package** main

 **import** "unsafe"
 **const** (
   a = "abc"
   b = len(a)
   c = unsafe.Sizeof(a)
 )

 func main(){
   println(a, b, c)
 }

以上实例运行结果为：

```
abc 3 16
```

------

## iota

iota，特殊常量，可以认为是一个可以被编译器修改的常量。

iota 在 const关键字出现时将被重置为 0(const 内部的第一行之前)，const 中每新增一行常量声明将使 iota 计数一次(iota 可理解为 const 语句块中的行索引)。

iota 可以被用作枚举值：

```
const (
    a = iota
    b = iota
    c = iota
)
```

第一个 iota 等于 0，每当 iota 在新的一行被使用时，它的值都会自动加 1；所以 a=0, b=1, c=2 可以简写为如下形式：

```
const (
    a = iota
    b
    c
)
```

### iota 用法

## 实例

**package** main

 **import** "fmt"

 func main() {
   **const** (
       a = iota  *//0*
       b      *//1*
       c      *//2*
       d = "ha"  *//独立值，iota += 1*
       e      *//"ha"  iota += 1*
       f = 100   *//iota +=1*
       g      *//100  iota +=1*
       h = iota  *//7,恢复计数*
       i      *//8*
   )
   fmt.Println(a,b,c,d,e,f,g,h,i)
 }

以上实例运行结果为：

```
0 1 2 ha ha 100 100 7 8
```

再看个有趣的的 iota 实例：

## 实例

**package** main

 **import** "fmt"
 **const** (
   i=1<<iota
   j=3<<iota
   k
   l
 )

 func main() {
   fmt.Println("i=",i)
   fmt.Println("j=",j)
   fmt.Println("k=",k)
   fmt.Println("l=",l)
 }

以上实例运行结果为：

```
i= 1
j= 6
k= 12
l= 24
```

iota 表示从 0 开始自动加 1，所以 i=1<<0, j=3<<1（**<<** 表示左移的意思），即：i=1, j=6，这没问题，关键在 k 和 l，从输出结果看 k=3<<2，l=3<<3。

简单表述:

- i=1

- ：左移 0 位,不变仍为 1;

- **j=3**：左移 1 位,变为二进制 110, 即 6;
- **k=3**：左移 2 位,变为二进制 1100, 即 12;
- **l=3**：左移 3 位,变为二进制 11000,即 24。

注：<<n==*(2^n)。

​			

# Go 语言运算符

运算符用于在程序运行时执行数学或逻辑运算。

Go 语言内置的运算符有：

- 算术运算符
- 关系运算符
- 逻辑运算符
- 位运算符
- 赋值运算符
- 其他运算符

接下来让我们来详细看看各个运算符的介绍。

------

## 算术运算符

下表列出了所有Go语言的算术运算符。假定 A 值为 10，B 值为 20。

| 运算符 | 描述 | 实例               |
| ------ | ---- | ------------------ |
| +      | 相加 | A + B 输出结果 30  |
| -      | 相减 | A - B 输出结果 -10 |
| *      | 相乘 | A * B 输出结果 200 |
| /      | 相除 | B / A 输出结果 2   |
| %      | 求余 | B % A 输出结果 0   |
| ++     | 自增 | A++ 输出结果 11    |
| --     | 自减 | A-- 输出结果 9     |

以下实例演示了各个算术运算符的用法：

## 实例

**package** main

 **import** "fmt"

 func main() {

   **var** a int = 21
   **var** b int = 10
   **var** c int

   c = a + b
   fmt.Printf("第一行 - c 的值为 %d**\n**", c )
   c = a - b
   fmt.Printf("第二行 - c 的值为 %d**\n**", c )
   c = a * b
   fmt.Printf("第三行 - c 的值为 %d**\n**", c )
   c = a / b
   fmt.Printf("第四行 - c 的值为 %d**\n**", c )
   c = a % b
   fmt.Printf("第五行 - c 的值为 %d**\n**", c )
   a++
   fmt.Printf("第六行 - a 的值为 %d**\n**", a )
   a=21  *// 为了方便测试，a 这里重新赋值为 21*
   a--
   fmt.Printf("第七行 - a 的值为 %d**\n**", a )
 }

以上实例运行结果：

```
第一行 - c 的值为 31
第二行 - c 的值为 11
第三行 - c 的值为 210
第四行 - c 的值为 2
第五行 - c 的值为 1
第六行 - a 的值为 22
第七行 - a 的值为 20
```

------

## 关系运算符

下表列出了所有Go语言的关系运算符。假定 A 值为 10，B 值为 20。

| 运算符 | 描述                                                         | 实例               |
| ------ | ------------------------------------------------------------ | ------------------ |
| ==     | 检查两个值是否相等，如果相等返回 True 否则返回 False。       | (A == B)  为 False |
| !=     | 检查两个值是否不相等，如果不相等返回 True 否则返回 False。   | (A != B) 为 True   |
| >      | 检查左边值是否大于右边值，如果是返回 True 否则返回 False。   | (A > B) 为 False   |
| <      | 检查左边值是否小于右边值，如果是返回 True 否则返回 False。   | (A < B) 为 True    |
| >=     | 检查左边值是否大于等于右边值，如果是返回 True 否则返回 False。 | (A >= B) 为 False  |
| <=     | 检查左边值是否小于等于右边值，如果是返回 True 否则返回 False。 | (A <= B) 为 True   |

以下实例演示了关系运算符的用法：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a int = 21
   **var** b int = 10

   **if**( a == b ) {
    fmt.Printf("第一行 - a 等于 b**\n**" )
   } **else** {
    fmt.Printf("第一行 - a 不等于 b**\n**" )
   }
   **if** ( a < b ) {
    fmt.Printf("第二行 - a 小于 b**\n**" )
   } **else** {
    fmt.Printf("第二行 - a 不小于 b**\n**" )
   } 

   **if** ( a > b ) {
    fmt.Printf("第三行 - a 大于 b**\n**" )
   } **else** {
    fmt.Printf("第三行 - a 不大于 b**\n**" )
   }
   */\* Lets change value of a and b \*/*
   a = 5
   b = 20
   **if** ( a <= b ) {
    fmt.Printf("第四行 - a 小于等于 b**\n**" )
   }
   **if** ( b >= a ) {
    fmt.Printf("第五行 - b 大于等于 a**\n**" )
   }
 }

以上实例运行结果：

```
第一行 - a 不等于 b
第二行 - a 不小于 b
第三行 - a 大于 b
第四行 - a 小于等于 b
第五行 - b 大于等于 a
```

------

## 逻辑运算符

下表列出了所有Go语言的逻辑运算符。假定 A 值为 True，B 值为 False。

| 运算符 | 描述                                                         | 实例               |
| ------ | ------------------------------------------------------------ | ------------------ |
| &&     | 逻辑 AND 运算符。 如果两边的操作数都是 True，则条件 True，否则为 False。 | (A && B) 为 False  |
| \|\|   | 逻辑 OR 运算符。 如果两边的操作数有一个 True，则条件 True，否则为 False。 | (A \|\| B) 为 True |
| !      | 逻辑 NOT 运算符。 如果条件为 True，则逻辑 NOT 条件 False，否则为 True。 | !(A && B) 为 True  |

以下实例演示了逻辑运算符的用法：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a bool = **true**
   **var** b bool = **false**
   **if** ( a && b ) {
    fmt.Printf("第一行 - 条件为 true**\n**" )
   }
   **if** ( a || b ) {
    fmt.Printf("第二行 - 条件为 true**\n**" )
   }
   */\* 修改 a 和 b 的值 \*/*
   a = **false**
   b = **true**
   **if** ( a && b ) {
    fmt.Printf("第三行 - 条件为 true**\n**" )
   } **else** {
    fmt.Printf("第三行 - 条件为 false**\n**" )
   }
   **if** ( !(a && b) ) {
    fmt.Printf("第四行 - 条件为 true**\n**" )
   }
 }

以上实例运行结果：

```
第二行 - 条件为 true
第三行 - 条件为 false
第四行 - 条件为 true
```

------

## 位运算符

位运算符对整数在内存中的二进制位进行操作。

下表列出了位运算符 &, |, 和 ^ 的计算：

| p    | q    | p & q | p \| q | p ^ q |
| ---- | ---- | ----- | ------ | ----- |
| 0    | 0    | 0     | 0      | 0     |
| 0    | 1    | 0     | 1      | 1     |
| 1    | 1    | 1     | 1      | 0     |
| 1    | 0    | 0     | 1      | 1     |

假定 A = 60;  B = 13; 其二进制数转换为：

```
A = 0011 1100

B = 0000 1101

-----------------

A&B = 0000 1100

A|B = 0011 1101

A^B = 0011 0001
```



Go 语言支持的位运算符如下表所示。假定 A 为60，B 为13：

| 运算符 | 描述                                                         | 实例                                   |
| ------ | ------------------------------------------------------------ | -------------------------------------- |
| &      | 按位与运算符"&"是双目运算符。 其功能是参与运算的两数各对应的二进位相与。 | (A & B) 结果为 12,  二进制为 0000 1100 |
| \|     | 按位或运算符"\|"是双目运算符。 其功能是参与运算的两数各对应的二进位相或 | (A \| B) 结果为 61, 二进制为 0011 1101 |
| ^      | 按位异或运算符"^"是双目运算符。 其功能是参与运算的两数各对应的二进位相异或，当两对应的二进位相异时，结果为1。 | (A ^ B) 结果为 49, 二进制为 0011 0001  |
| <<     | 左移运算符"<<"是双目运算符。左移n位就是乘以2的n次方。 其功能把"<<"左边的运算数的各二进位全部左移若干位，由"<<"右边的数指定移动的位数，高位丢弃，低位补0。 | A << 2 结果为 240 ，二进制为 1111 0000 |
| >>     | 右移运算符">>"是双目运算符。右移n位就是除以2的n次方。 其功能是把">>"左边的运算数的各二进位全部右移若干位，">>"右边的数指定移动的位数。 | A >> 2 结果为 15 ，二进制为 0000 1111  |

以下实例演示了位运算符的用法：

## 实例

**package** main

 **import** "fmt"

 func main() {

   **var** a uint = 60   */\* 60 = 0011 1100 \*/*  
   **var** b uint = 13   */\* 13 = 0000 1101 \*/*
   **var** c uint = 0      

   c = a & b    */\* 12 = 0000 1100 \*/* 
   fmt.Printf("第一行 - c 的值为 %d**\n**", c )

   c = a | b    */\* 61 = 0011 1101 \*/*
   fmt.Printf("第二行 - c 的值为 %d**\n**", c )

   c = a ^ b    */\* 49 = 0011 0001 \*/*
   fmt.Printf("第三行 - c 的值为 %d**\n**", c )

   c = a << 2   */\* 240 = 1111 0000 \*/*
   fmt.Printf("第四行 - c 的值为 %d**\n**", c )

   c = a >> 2   */\* 15 = 0000 1111 \*/*
   fmt.Printf("第五行 - c 的值为 %d**\n**", c )
 }

以上实例运行结果：

```
第一行 - c 的值为 12
第二行 - c 的值为 61
第三行 - c 的值为 49
第四行 - c 的值为 240
第五行 - c 的值为 15
```

------

## 赋值运算符

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

以下实例演示了赋值运算符的用法：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a int = 21
   **var** c int

   c =  a
   fmt.Printf("第 1 行 - =  运算符实例，c 值为 = %d**\n**", c )

   c +=  a
   fmt.Printf("第 2 行 - += 运算符实例，c 值为 = %d**\n**", c )

   c -=  a
   fmt.Printf("第 3 行 - -= 运算符实例，c 值为 = %d**\n**", c )

   c *=  a
   fmt.Printf("第 4 行 - *= 运算符实例，c 值为 = %d**\n**", c )

   c /=  a
   fmt.Printf("第 5 行 - /= 运算符实例，c 值为 = %d**\n**", c )

   c  = 200; 

   c <<=  2
   fmt.Printf("第 6行  - <<= 运算符实例，c 值为 = %d**\n**", c )

   c >>=  2
   fmt.Printf("第 7 行 - >>= 运算符实例，c 值为 = %d**\n**", c )

   c &=  2
   fmt.Printf("第 8 行 - &= 运算符实例，c 值为 = %d**\n**", c )

   c ^=  2
   fmt.Printf("第 9 行 - ^= 运算符实例，c 值为 = %d**\n**", c )

   c |=  2
   fmt.Printf("第 10 行 - |= 运算符实例，c 值为 = %d**\n**", c )

 }

以上实例运行结果：

```
第 1 行 - =  运算符实例，c 值为 = 21
第 2 行 - += 运算符实例，c 值为 = 42
第 3 行 - -= 运算符实例，c 值为 = 21
第 4 行 - *= 运算符实例，c 值为 = 441
第 5 行 - /= 运算符实例，c 值为 = 21
第 6行  - <<= 运算符实例，c 值为 = 800
第 7 行 - >>= 运算符实例，c 值为 = 200
第 8 行 - &= 运算符实例，c 值为 = 0
第 9 行 - ^= 运算符实例，c 值为 = 2
第 10 行 - |= 运算符实例，c 值为 = 2
```

------

## 其他运算符

下表列出了Go语言的其他运算符。

| 运算符 | 描述             | 实例                       |
| ------ | ---------------- | -------------------------- |
| &      | 返回变量存储地址 | &a; 将给出变量的实际地址。 |
| *      | 指针变量。       | *a; 是一个指针变量         |

以下实例演示了其他运算符的用法：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a int = 4
   **var** b int32
   **var** c float32
   **var** ptr *int

   */\* 运算符实例 \*/*
   fmt.Printf("第 1 行 - a 变量类型为 = %T**\n**", a );
   fmt.Printf("第 2 行 - b 变量类型为 = %T**\n**", b );
   fmt.Printf("第 3 行 - c 变量类型为 = %T**\n**", c );

   */\*  & 和 \* 运算符实例 \*/*
   ptr = &a   */\* 'ptr' 包含了 'a' 变量的地址 \*/*
   fmt.Printf("a 的值为  %d**\n**", a);
   fmt.Printf("*ptr 为 %d**\n**", *ptr);
 }

以上实例运行结果：

```
第 1 行 - a 变量类型为 = int
第 2 行 - b 变量类型为 = int32
第 3 行 - c 变量类型为 = float32
a 的值为  4
*ptr 为 4
```

------

## 运算符优先级

有些运算符拥有较高的优先级，二元运算符的运算方向均是从左至右。下表列出了所有运算符以及它们的优先级，由上至下代表优先级由高到低：

| 优先级 | 运算符                 |
| ------ | ---------------------- |
| 5      | *  /  %  <<  >>  &  &^ |
| 4      | +  -  \|  ^            |
| 3      | ==  !=  <  <=  >  >=   |
| 2      | &&                     |
| 1      | \|\|                   |

当然，你可以通过使用括号来临时提升某个表达式的整体运算优先级。

以上实例运行结果：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a int = 20
   **var** b int = 10
   **var** c int = 15
   **var** d int = 5
   **var** e int;

   e = (a + b) * c / d;    *// ( 30 \* 15 ) / 5*
   fmt.Printf("(a + b) * c / d 的值为 : %d**\n**",  e );

   e = ((a + b) * c) / d;   *// (30 \* 15 ) / 5*
   fmt.Printf("((a + b) * c) / d 的值为  : %d**\n**" ,  e );

   e = (a + b) * (c / d);  *// (30) \* (15/5)*
   fmt.Printf("(a + b) * (c / d) 的值为  : %d**\n**",  e );

   e = a + (b * c) / d;   *//  20 + (150/5)*
   fmt.Printf("a + (b * c) / d 的值为  : %d**\n**" ,  e );  
 }

以上实例运行结果：

```
(a + b) * c / d 的值为 : 90
((a + b) * c) / d 的值为  : 90
(a + b) * (c / d) 的值为  : 90
a + (b * c) / d 的值为  : 50
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

[Gidot](javascript:;)  Gidot gid***qq.com2年前 (2018-12-20)

2. 

     凉月

    130***6594@qq.com

    51

   Go 的自增，自减只能作为表达式使用，而不能用于赋值语句。

   ```
   a++ // 这是允许的，类似 a = a + 1,结果与 a++ 相同
   a-- //与 a++ 相似
   a = a++ // 这是不允许的，会出现变异错误 syntax error: unexpected ++ at end of statement
   ```

   [凉月](javascript:;)  凉月 130***6594@qq.com10个月前 (09-04)

​			

  	Go 语言条件语句

条件语句需要开发者通过指定一个或多个条件，并通过测试条件是否为 true 来决定是否执行指定语句，并在条件为 false 的情况在执行另外的语句。

下图展示了程序语言中条件语句的结构：

![Go 语言条件语句](D:\wfbook\Image\g\o\decision_making.jpg)

Go 语言提供了以下几种条件判断语句：

| 语句                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [if 语句](https://www.runoob.com/go/go-if-statement.html)    | **if 语句** 由一个布尔表达式后紧跟一个或多个语句组成。       |
| [if...else 语句](https://www.runoob.com/go/go-if-else-statement.html) | **if 语句** 后可以使用可选的 **else 语句**, else 语句中的表达式在布尔表达式为 false 时执行。 |
| [ if 嵌套语句](https://www.runoob.com/go/go-nested-if-statements.html) | 你可以在 **if** 或 **else if** 语句中嵌入一个或多个 **if** 或 **else if** 语句。 |
| [switch 语句](https://www.runoob.com/go/go-switch-statement.html) | **switch** 语句用于基于不同条件执行不同动作。                |
| [select 语句](https://www.runoob.com/go/go-select-statement.html) | **select** 语句类似于 **switch** 语句，但是select会随机执行一个可运行的case。如果没有case可运行，它将阻塞，直到有case可运行。 |

> 注意：Go 没有三目运算符，所以不支持 **?:** 形式的条件判断。

# Go 语言循环语句

在不少实际问题中有许多具有规律性的重复操作，因此在程序中就需要重复执行某些语句。

以下为大多编程语言循环程序的流程图： ![img](D:\wfbook\Image\g\o\loop_architecture.jpg)

Go 语言提供了以下几种类型循环处理语句：

| 循环类型                                                   | 描述                                 |
| ---------------------------------------------------------- | ------------------------------------ |
| [for 循环](https://www.runoob.com/go/go-for-loop.html)     | 重复执行语句块                       |
| [循环嵌套](https://www.runoob.com/go/go-nested-loops.html) | 在 for 循环中嵌套一个或多个 for 循环 |

------

## 循环控制语句

循环控制语句可以控制循环体内语句的执行过程。

GO 语言支持以下几种循环控制语句：

| 控制语句                                                     | 描述                                             |
| ------------------------------------------------------------ | ------------------------------------------------ |
| [break 语句](https://www.runoob.com/go/go-break-statement.html) | 经常用于中断当前 for 循环或跳出 switch 语句      |
| [continue 语句](https://www.runoob.com/go/go-continue-statement.html) | 跳过当前循环的剩余语句，然后继续进行下一轮循环。 |
| [goto 语句](https://www.runoob.com/go/go-goto-statement.html) | 将控制转移到被标记的语句。                       |

------

## 无限循环

如果循环中条件语句永远不为 false 则会进行无限循环，我们可以通过 for 循环语句中只设置一个条件表达式来执行无限循环：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **for** **true**  {
     fmt.Printf("这是无限循环。**\n**");
   }
 }

​			

# Go 语言函数

函数是基本的代码块，用于执行一个任务。

Go 语言最少有个 main() 函数。

你可以通过函数来划分不同功能，逻辑上每个函数执行的是指定的任务。

函数声明告诉了编译器函数的名称，返回类型，和参数。

Go 语言标准库提供了多种可动用的内置的函数。例如，len() 函数可以接受不同类型参数并返回该类型的长度。如果我们传入的是字符串则返回字符串的长度，如果传入的是数组，则返回数组中包含的元素个数。

------

## 函数定义

Go 语言函数定义格式如下：

```
func function_name( [parameter list] ) [return_types] {
   函数体
}
```

函数定义解析：

- func：函数由 func 开始声明
- function_name：函数名称，函数名和参数列表一起构成了函数签名。
- parameter list：参数列表，参数就像一个占位符，当函数被调用时，你可以将值传递给参数，这个值被称为实际参数。参数列表指定的是参数类型、顺序、及参数个数。参数是可选的，也就是说函数也可以不包含参数。
- return_types：返回类型，函数返回一列值。return_types 是该列值的数据类型。有些功能不需要返回值，这种情况下 return_types 不是必须的。
- 函数体：函数定义的代码集合。

### 实例

以下实例为 max() 函数的代码，该函数传入两个整型参数 num1 和 num2，并返回这两个参数的最大值：

## 实例

*/\* 函数返回两个数的最大值 \*/*
 func max(num1, num2 int) int {
   */\* 声明局部变量 \*/*
   **var** result int

   **if** (num1 > num2) {
    result = num1
   } **else** {
    result = num2
   }
   **return** result 
 }

## 函数调用

当创建函数时，你定义了函数需要做什么，通过调用该函数来执行指定任务。

调用函数，向函数传递参数，并返回值，例如：

## 实例

**package** main

 **import** "fmt"

 func main() {
   */\* 定义局部变量 \*/*
   **var** a int = 100
   **var** b int = 200
   **var** ret int

   */\* 调用函数并返回最大值 \*/*
   ret = max(a, b)

   fmt.Printf( "最大值是 : %d**\n**", ret )
 }

 */\* 函数返回两个数的最大值 \*/*
 func max(num1, num2 int) int {
   */\* 定义局部变量 \*/*
   **var** result int

   **if** (num1 > num2) {
    result = num1
   } **else** {
    result = num2
   }
   **return** result 
 }

以上实例在 main() 函数中调用 max（）函数，执行结果为：

```
最大值是 : 200
```

------

## 函数返回多个值

Go 函数可以返回多个值，例如：

## 实例

**package** main

 **import** "fmt"

 func swap(x, y string) (string, string) {
   **return** y, x
 }

 func main() {
   a, b := swap("Google", "Runoob")
   fmt.Println(a, b)
 }

以上实例执行结果为：

```
Runoob Google
```

------

## 函数参数

函数如果使用参数，该变量可称为函数的形参。

形参就像定义在函数体内的局部变量。

调用函数，可以通过两种方式来传递参数：

| 传递类型                                                     | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [值传递](https://www.runoob.com/go/go-function-call-by-value.html) | 值传递是指在调用函数时将实际参数复制一份传递到函数中，这样在函数中如果对参数进行修改，将不会影响到实际参数。 |
| [引用传递](https://www.runoob.com/go/go-function-call-by-reference.html) | 引用传递是指在调用函数时将实际参数的地址传递到函数中，那么在函数中对参数所进行的修改，将影响到实际参数。 |

默认情况下，Go 语言使用的是值传递，即在调用过程中不会影响到实际参数。

------

## 函数用法

| 函数用法                                                     | 描述                                     |
| ------------------------------------------------------------ | ---------------------------------------- |
| [函数作为另外一个函数的实参](https://www.runoob.com/go/go-function-as-values.html) | 函数定义后可作为另外一个函数的实参数传入 |
| [闭包](https://www.runoob.com/go/go-function-closures.html)  | 闭包是匿名函数，可在动态编程中使用       |
| [方法](https://www.runoob.com/go/go-method.html)             | 方法就是一个包含了接受者的函数           |

# Go 语言变量作用域

作用域为已声明标识符所表示的常量、类型、变量、函数或包在源代码中的作用范围。

Go 语言中变量可以在三个地方声明：

- 函数内定义的变量称为局部变量
- 函数外定义的变量称为全局变量
- 函数定义中的变量称为形式参数

接下来让我们具体了解局部变量、全局变量和形式参数。

------

## 局部变量

在函数体内声明的变量称之为局部变量，它们的作用域只在函数体内，参数和返回值变量也是局部变量。

以下实例中 main() 函数使用了局部变量 a, b, c：

## 实例

**package** main

 **import** "fmt"

 func main() {
   */\* 声明局部变量 \*/*
   **var** a, b, c int 

   */\* 初始化参数 \*/*
   a = 10
   b = 20
   c = a + b

   fmt.Printf ("结果： a = %d, b = %d and c = %d**\n**", a, b, c)
 }

以上实例执行输出结果为：

```
结果： a = 10, b = 20 and c = 30
```

------

## 全局变量

在函数体外声明的变量称之为全局变量，全局变量可以在整个包甚至外部包（被导出后）使用。

全局变量可以在任何函数中使用，以下实例演示了如何使用全局变量：

## 实例

**package** main

 **import** "fmt"

 */\* 声明全局变量 \*/*
 **var** g int

 func main() {

   */\* 声明局部变量 \*/*
   **var** a, b int

   */\* 初始化参数 \*/*
   a = 10
   b = 20
   g = a + b

   fmt.Printf("结果： a = %d, b = %d and g = %d**\n**", a, b, g)
 }

以上实例执行输出结果为：

```
结果： a = 10, b = 20 and g = 30
```

Go 语言程序中全局变量与局部变量名称可以相同，但是函数内的局部变量会被优先考虑。实例如下：

## 实例

**package** main

 **import** "fmt"

 */\* 声明全局变量 \*/*
 **var** g int = 20

 func main() {
   */\* 声明局部变量 \*/*
   **var** g int = 10

   fmt.Printf ("结果： g = %d**\n**",  g)
 }

以上实例执行输出结果为：

```
结果： g = 10
```

------

## 形式参数

形式参数会作为函数的局部变量来使用。实例如下：

## 实例

**package** main

 **import** "fmt"

 */\* 声明全局变量 \*/*
 **var** a int = 20;

 func main() {
   */\* main 函数中声明局部变量 \*/*
   **var** a int = 10
   **var** b int = 20
   **var** c int = 0

   fmt.Printf("main()函数中 a = %d**\n**",  a);
   c = sum( a, b);
   fmt.Printf("main()函数中 c = %d**\n**",  c);
 }

 */\* 函数定义-两数相加 \*/*
 func sum(a, b int) int {
   fmt.Printf("sum() 函数中 a = %d**\n**",  a);
   fmt.Printf("sum() 函数中 b = %d**\n**",  b);

   **return** a + b;
 }

以上实例执行输出结果为：

```
main()函数中 a = 10
sum() 函数中 a = 10
sum() 函数中 b = 20
main()函数中 c = 30
```

------

## 初始化局部和全局变量

不同类型的局部和全局变量默认值为：

| 数据类型 | 初始化默认值 |
| -------- | ------------ |
| int      | 0            |
| float32  | 0            |
| pointer  | nil          |

# Go 语言数组

Go 语言提供了数组类型的数据结构。

数组是具有相同唯一类型的一组已编号且长度固定的数据项序列，这种类型可以是任意的原始类型例如整形、字符串或者自定义类型。

相对于去声明 **number0, number1, ..., number99** 的变量，使用数组形式 **numbers[0], numbers[1] ..., numbers[99]** 更加方便且易于扩展。

数组元素可以通过索引（位置）来读取（或者修改），索引从 0 开始，第一个元素索引为 0，第二个索引为 1，以此类推。

![img](D:\wfbook\Image\g\o\goarray.png)

------

## 声明数组

Go 语言数组声明需要指定元素类型及元素个数，语法格式如下：

```
var variable_name [SIZE] variable_type
```

以上为一维数组的定义方式。例如以下定义了数组 balance 长度为 10 类型为 float32：

```
var balance [10] float32
```

------

## 初始化数组

以下演示了数组初始化：

```
var balance = [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

 初始化数组中 {} 中的元素个数不能大于 [] 中的数字。

 如果忽略 [] 中的数字不设置数组大小，Go 语言会根据元素的个数来设置数组的大小：

```
 var balance = [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

 该实例与上面的实例是一样的，虽然没有设置数组的大小。

```
 balance[4] = 50.0
```

以上实例读取了第五个元素。数组元素可以通过索引（位置）来读取（或者修改），索引从0开始，第一个元素索引为 0，第二个索引为 1，以此类推。

 ![img](D:\wfbook\Image\g\o\array_presentation.jpg)

------

## 访问数组元素

数组元素可以通过索引（位置）来读取。格式为数组名后加中括号，中括号中为索引的值。例如：

```
var salary float32 = balance[9]
```

以上实例读取了数组balance第10个元素的值。

以下演示了数组完整操作（声明、赋值、访问）的实例：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** n [10]int */\* n 是一个长度为 10 的数组 \*/*
   **var** i,j int

   */\* 为数组 n 初始化元素 \*/*     
   **for** i = 0; i < 10; i++ {
    n[i] = i + 100 */\* 设置元素为 i + 100 \*/*
   }

   */\* 输出每个数组元素的值 \*/*
   **for** j = 0; j < 10; j++ {
    fmt.Printf("Element[%d] = %d**\n**", j, n[j] )
   }
 }

以上实例执行结果如下：

```
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

------

## 更多内容

数组对 Go 语言来说是非常重要的，以下我们将介绍数组更多的内容：

| 内容                                                         | 描述                                            |
| ------------------------------------------------------------ | ----------------------------------------------- |
| [多维数组](https://www.runoob.com/go/go-multi-dimensional-arrays.html) | Go 语言支持多维数组，最简单的多维数组是二维数组 |
| [向函数传递数组](https://www.runoob.com/go/go-passing-arrays-to-functions.html) | 你可以向函数传递数组参数                        |

# Go 语言指针

Go 语言中指针是很容易学习的，Go 语言中使用指针可以更简单的执行一些任务。

接下来让我们来一步步学习 Go 语言指针。

我们都知道，变量是一种使用方便的占位符，用于引用计算机内存地址。

Go 语言的取地址符是 &，放到一个变量前使用就会返回相应变量的内存地址。

以下实例演示了变量在内存中地址：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a int = 10  

   fmt.Printf("变量的地址: %x**\n**", &a  )
 }

执行以上代码输出结果为：

```
变量的地址: 20818a220
```

现在我们已经了解了什么是内存地址和如何去访问它。接下来我们将具体介绍指针。

------

## 什么是指针

一个指针变量指向了一个值的内存地址。

类似于变量和常量，在使用指针前你需要声明指针。指针声明格式如下：

```
var var_name *var-type
```

var-type 为指针类型，var_name 为指针变量名，* 号用于指定变量是作为一个指针。以下是有效的指针声明：

```
var ip *int        /* 指向整型*/
var fp *float32    /* 指向浮点型 */
```

本例中这是一个指向 int 和 float32 的指针。

------

## 如何使用指针

指针使用流程：

- 定义指针变量。
- 为指针变量赋值。
- 访问指针变量中指向地址的值。

在指针类型前面加上 * 号（前缀）来获取指针所指向的内容。

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** a int= 20  */\* 声明实际变量 \*/*
   **var** ip *int     */\* 声明指针变量 \*/*

   ip = &a  */\* 指针变量的存储地址 \*/*

   fmt.Printf("a 变量的地址是: %x**\n**", &a  )

   */\* 指针变量的存储地址 \*/*
   fmt.Printf("ip 变量储存的指针地址: %x**\n**", ip )

   */\* 使用指针访问值 \*/*
   fmt.Printf("*ip 变量的值: %d**\n**", *ip )
 }

以上实例执行输出结果为：

```
a 变量的地址是: 20818a220
ip 变量储存的指针地址: 20818a220
*ip 变量的值: 20
```

------

## Go 空指针

当一个指针被定义后没有分配到任何变量时，它的值为 nil。

nil 指针也称为空指针。

nil在概念上和其它语言的null、None、nil、NULL一样，都指代零值或空值。

一个指针变量通常缩写为 ptr。

查看以下实例：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var**  ptr *int

   fmt.Printf("ptr 的值为 : %x**\n**", ptr  )
 }

以上实例输出结果为：

```
ptr 的值为 : 0
```

空指针判断：

```
if(ptr != nil)     /* ptr 不是空指针 */
if(ptr == nil)    /* ptr 是空指针 */
```

------

## Go指针更多内容

接下来我们将为大家介绍Go语言中更多的指针应用：

| 内容                                                         | 描述                                         |
| ------------------------------------------------------------ | -------------------------------------------- |
| [Go 指针数组](https://www.runoob.com/go/go-array-of-pointers.html) | 你可以定义一个指针数组来存储地址             |
| [Go 指向指针的指针](https://www.runoob.com/go/go-pointer-to-pointer.html) | Go 支持指向指针的指针                        |
| [Go 向函数传递指针参数](https://www.runoob.com/go/go-passing-pointers-to-functions.html) | 通过引用或地址传参，在函数调用时可以改变其值 |

# Go 语言结构体

Go 语言中数组可以存储同一类型的数据，但在结构体中我们可以为不同项定义不同的数据类型。

结构体是由一系列具有相同类型或不同类型的数据构成的数据集合。

结构体表示一项记录，比如保存图书馆的书籍记录，每本书有以下属性：

- Title ：标题
- Author ： 作者
- Subject：学科
- ID：书籍ID

------

## 定义结构体

结构体定义需要使用 type 和 struct 语句。struct 语句定义一个新的数据类型，结构体中有一个或多个成员。type 语句设定了结构体的名称。结构体的格式如下：

```
type struct_variable_type struct {
   member definition
   member definition
   ...
   member definition
}
```

一旦定义了结构体类型，它就能用于变量的声明，语法格式如下：

```
variable_name := structure_variable_type {value1, value2...valuen}
或
variable_name := structure_variable_type { key1: value1, key2: value2..., keyn: valuen}
```

实例如下：

## 实例

**package** main

 **import** "fmt"

 **type** Books struct {
   title string
   author string
   subject string
   book_id int
 }


 func main() {

   *// 创建一个新的结构体*
   fmt.Println(Books{"Go 语言", "www.runoob.com", "Go 语言教程", 6495407})

   *// 也可以使用 key => value 格式*
   fmt.Println(Books{title: "Go 语言", author: "www.runoob.com", subject: "Go 语言教程", book_id: 6495407})

   *// 忽略的字段为 0 或 空*
   fmt.Println(Books{title: "Go 语言", author: "www.runoob.com"})
 }

输出结果为：

```
{Go 语言 www.runoob.com Go 语言教程 6495407}
{Go 语言 www.runoob.com Go 语言教程 6495407}
{Go 语言 www.runoob.com  0}
```

------

## 访问结构体成员

如果要访问结构体成员，需要使用点号 .  操作符，格式为： 

```
结构体.成员名"
```

结构体类型变量使用 struct 关键字定义，实例如下：

## 实例

**package** main

 **import** "fmt"

 **type** Books struct {
   title string
   author string
   subject string
   book_id int
 }

 func main() {
   **var** Book1 Books     */\* 声明 Book1 为 Books 类型 \*/*
   **var** Book2 Books     */\* 声明 Book2 为 Books 类型 \*/*

   */\* book 1 描述 \*/*
   Book1.title = "Go 语言"
   Book1.author = "www.runoob.com"
   Book1.subject = "Go 语言教程"
   Book1.book_id = 6495407

   */\* book 2 描述 \*/*
   Book2.title = "Python 教程"
   Book2.author = "www.runoob.com"
   Book2.subject = "Python 语言教程"
   Book2.book_id = 6495700

   */\* 打印 Book1 信息 \*/*
   fmt.Printf( "Book 1 title : %s**\n**", Book1.title)
   fmt.Printf( "Book 1 author : %s**\n**", Book1.author)
   fmt.Printf( "Book 1 subject : %s**\n**", Book1.subject)
   fmt.Printf( "Book 1 book_id : %d**\n**", Book1.book_id)

   */\* 打印 Book2 信息 \*/*
   fmt.Printf( "Book 2 title : %s**\n**", Book2.title)
   fmt.Printf( "Book 2 author : %s**\n**", Book2.author)
   fmt.Printf( "Book 2 subject : %s**\n**", Book2.subject)
   fmt.Printf( "Book 2 book_id : %d**\n**", Book2.book_id)
 }

以上实例执行运行结果为：

```
Book 1 title : Go 语言
Book 1 author : www.runoob.com
Book 1 subject : Go 语言教程
Book 1 book_id : 6495407
Book 2 title : Python 教程
Book 2 author : www.runoob.com
Book 2 subject : Python 语言教程
Book 2 book_id : 6495700
```

------

## 结构体作为函数参数

你可以像其他数据类型一样将结构体类型作为参数传递给函数。并以以上实例的方式访问结构体变量：

## 实例

**package** main

 **import** "fmt"

 **type** Books struct {
   title string
   author string
   subject string
   book_id int
 }

 func main() {
   **var** Book1 Books     */\* 声明 Book1 为 Books 类型 \*/*
   **var** Book2 Books     */\* 声明 Book2 为 Books 类型 \*/*

   */\* book 1 描述 \*/*
   Book1.title = "Go 语言"
   Book1.author = "www.runoob.com"
   Book1.subject = "Go 语言教程"
   Book1.book_id = 6495407

   */\* book 2 描述 \*/*
   Book2.title = "Python 教程"
   Book2.author = "www.runoob.com"
   Book2.subject = "Python 语言教程"
   Book2.book_id = 6495700

   */\* 打印 Book1 信息 \*/*
   printBook(Book1)

   */\* 打印 Book2 信息 \*/*
   printBook(Book2)
 }

 func printBook( book Books ) {
   fmt.Printf( "Book title : %s**\n**", book.title)
   fmt.Printf( "Book author : %s**\n**", book.author)
   fmt.Printf( "Book subject : %s**\n**", book.subject)
   fmt.Printf( "Book book_id : %d**\n**", book.book_id)
 }

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

------

## 结构体指针

你可以定义指向结构体的指针类似于其他指针变量，格式如下：

```
var struct_pointer *Books
```

以上定义的指针变量可以存储结构体变量的地址。查看结构体变量地址，可以将 & 符号放置于结构体变量前：

```
struct_pointer = &Book1
```

使用结构体指针访问结构体成员，使用 "." 操作符：

```
struct_pointer.title
```

接下来让我们使用结构体指针重写以上实例，代码如下：

## 实例

**package** main

 **import** "fmt"

 **type** Books struct {
   title string
   author string
   subject string
   book_id int
 }

 func main() {
   **var** Book1 Books     */\* Declare Book1 of type Book \*/*
   **var** Book2 Books     */\* Declare Book2 of type Book \*/*

   */\* book 1 描述 \*/*
   Book1.title = "Go 语言"
   Book1.author = "www.runoob.com"
   Book1.subject = "Go 语言教程"
   Book1.book_id = 6495407

   */\* book 2 描述 \*/*
   Book2.title = "Python 教程"
   Book2.author = "www.runoob.com"
   Book2.subject = "Python 语言教程"
   Book2.book_id = 6495700

   */\* 打印 Book1 信息 \*/*
   printBook(&Book1)

   */\* 打印 Book2 信息 \*/*
   printBook(&Book2)
 }
 func printBook( book *Books ) {
   fmt.Printf( "Book title : %s**\n**", book.title)
   fmt.Printf( "Book author : %s**\n**", book.author)
   fmt.Printf( "Book subject : %s**\n**", book.subject)
   fmt.Printf( "Book book_id : %d**\n**", book.book_id)
 }

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

 [Go 语言指针](https://www.runoob.com/go/go-pointers.html) 

[Go 语言切片(Slice)](https://www.runoob.com/go/go-slice.html) 

##      	    	    	        2  篇笔记   写笔记    

1. 

     星海

    yan***anbao12@163.com

    52

   结构体是作为参数的值传递：

   ```
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

   ```
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

   [星海](javascript:;)  星海 yan***anbao12@163.com1年前 (2019-02-25)

2. 

     Ng Li

    ngl***163.com

    21

   struct 类似于 java 中的类，可以在 struct 中定义成员变量。

   要访问成员变量，可以有两种方式：

   - 1.通过 struct 变量.成员 变量来访问。
   - 2.通过s 

   - truct 指针.成员

   -  变量来访问。

   - 不需要通过 getter, setter 来设置访问权限。

   - ```
     type Rect struct{   //定义矩形类
         x,y float64       //类型只包含属性，并没有方法
         width,height float64
     }
     func (r *Rect) Area() float64{    //为Rect类型绑定Area的方法，*Rect为指针引用可以修改传入参数的值
         return r.width*r.height         //方法归属于类型，不归属于具体的对象，声明该类型的对象即可调用该类型的方法
     }
     ```

   - [Ng Li](javascript:;)  Ng Li ngl***163.com1年前 (2019-05-08)

# Go 语言切片(Slice)

Go 语言切片是对数组的抽象。

Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go中提供了一种灵活，功能强悍的内置类型切片("动态数组"),与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。

------

## 定义切片

你可以声明一个未指定大小的数组来定义切片：

```
var identifier []type
```

切片不需要说明长度。

或使用make()函数来创建切片:

```
var slice1 []type = make([]type, len)

也可以简写为

slice1 := make([]type, len)
```

也可以指定容量，其中capacity为可选参数。

```
make([]T, length, capacity)
```

这里 len 是数组的长度并且也是切片的初始长度。

### 切片初始化

```
s :=[] int {1,2,3 } 
```

直接初始化切片，[]表示是切片类型，{1,2,3}初始化值依次是1,2,3.其cap=len=3

```
s := arr[:] 
```

初始化切片s,是数组arr的引用

```
s := arr[startIndex:endIndex] 
```

将arr中从下标startIndex到endIndex-1 下的元素创建为一个新的切片

```
s := arr[startIndex:] 
```

默认 endIndex 时将表示一直到arr的最后一个元素

```
s := arr[:endIndex] 
```

默认 startIndex 时将表示从arr的第一个元素开始

```
s1 := s[startIndex:endIndex] 
```

通过切片s初始化切片s1

```
s :=make([]int,len,cap) 
```

通过内置函数make()初始化切片s,[]int 标识为其元素类型为int的切片

------

## len() 和 cap() 函数

切片是可索引的，并且可以由 len() 方法获取长度。

切片提供了计算容量的方法 cap() 可以测量切片最长可以达到多少。

以下为具体实例：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** numbers = make([]int,3,5)

   printSlice(numbers)
 }

 func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v**\n**",len(x),cap(x),x)
 }

以上实例运行输出结果为:

```
len=3 cap=5 slice=[0 0 0]
```

------

## 空(nil)切片

一个切片在未初始化之前默认为 nil，长度为 0，实例如下：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** numbers []int

   printSlice(numbers)

   **if**(numbers == **nil**){
    fmt.Printf("切片是空的")
   }
 }

 func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v**\n**",len(x),cap(x),x)
 }

以上实例运行输出结果为:

```
len=0 cap=0 slice=[]
切片是空的
```

------

## 切片截取

可以通过设置下限及上限来设置截取切片 *[lower-bound:upper-bound]*，实例如下：

## 实例

**package** main

 **import** "fmt"

 func main() {
   */\* 创建切片 \*/*
   numbers := []int{0,1,2,3,4,5,6,7,8}  
   printSlice(numbers)

   */\* 打印原始切片 \*/*
   fmt.Println("numbers ==", numbers)

   */\* 打印子切片从索引1(包含) 到索引4(不包含)\*/*
   fmt.Println("numbers[1:4] ==", numbers[1:4])

   */\* 默认下限为 0\*/*
   fmt.Println("numbers[:3] ==", numbers[:3])

   */\* 默认上限为 len(s)\*/*
   fmt.Println("numbers[4:] ==", numbers[4:])

   numbers1 := make([]int,0,5)
   printSlice(numbers1)

   */\* 打印子切片从索引  0(包含) 到索引 2(不包含) \*/*
   number2 := numbers[:2]
   printSlice(number2)

   */\* 打印子切片从索引 2(包含) 到索引 5(不包含) \*/*
   number3 := numbers[2:5]
   printSlice(number3)

 }

 func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v**\n**",len(x),cap(x),x)
 }

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

------

## append() 和 copy() 函数

如果想增加切片的容量，我们必须创建一个新的更大的切片并把原分片的内容都拷贝过来。

下面的代码描述了从拷贝切片的 copy 方法和向切片追加新元素的 append 方法。

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** numbers []int
   printSlice(numbers)

   */\* 允许追加空切片 \*/*
   numbers = append(numbers, 0)
   printSlice(numbers)

   */\* 向切片添加一个元素 \*/*
   numbers = append(numbers, 1)
   printSlice(numbers)

   */\* 同时添加多个元素 \*/*
   numbers = append(numbers, 2,3,4)
   printSlice(numbers)

   */\* 创建切片 numbers1 是之前切片的两倍容量\*/*
   numbers1 := make([]int, len(numbers), (cap(numbers))*2)

   */\* 拷贝 numbers 的内容到 numbers1 \*/*
   copy(numbers1,numbers)
   printSlice(numbers1)  
 }

 func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v**\n**",len(x),cap(x),x)
 }

以上代码执行输出结果为：

```
len=0 cap=0 slice=[]
len=1 cap=1 slice=[0]
len=2 cap=2 slice=[0 1]
len=5 cap=6 slice=[0 1 2 3 4]
len=5 cap=12 slice=[0 1 2 3 4]
```

# Go 语言范围(Range)

Go 语言中 range 关键字用于 for 循环中迭代数组(array)、切片(slice)、通道(channel)或集合(map)的元素。在数组和切片中它返回元素的索引和索引对应的值，在集合中返回 key-value 对。

### 实例

## 实例

**package** main
 **import** "fmt"
 func main() {
   *//这是我们使用range去求一个slice的和。使用数组跟这个很类似*
   nums := []int{2, 3, 4}
   sum := 0
   **for** _, num := **range** nums {
     sum += num
   }
   fmt.Println("sum:", sum)
   *//在数组上使用range将传入index和值两个变量。上面那个例子我们不需要使用该元素的序号，所以我们使用空白符"_"省略了。有时侯我们确实需要知道它的索引。*
   **for** i, num := **range** nums {
     **if** num == 3 {
       fmt.Println("index:", i)
     }
   }
   *//range也可以用在map的键值对上。*
   kvs := map[string]string{"a": "apple", "b": "banana"}
   **for** k, v := **range** kvs {
     fmt.Printf("%s -> %s**\n**", k, v)
   }
   *//range也可以用来枚举Unicode字符串。第一个参数是字符的索引，第二个是字符（Unicode的值）本身。*
   **for** i, c := **range** "go" {
     fmt.Println(i, c)
   }
 }

以上实例运行输出结果为：

```
sum: 9
index: 1
a -> apple
b -> banana
0 103
1 111
```

# Go 语言Map(集合)

Map 是一种无序的键值对的集合。Map 最重要的一点是通过 key 来快速检索数据，key 类似于索引，指向数据的值。

Map 是一种集合，所以我们可以像迭代数组和切片那样迭代它。不过，Map 是无序的，我们无法决定它的返回顺序，这是因为 Map 是使用 hash 表来实现的。

### 定义 Map

可以使用内建函数 make 也可以使用 map 关键字来定义 Map:

```
/* 声明变量，默认 map 是 nil */
var map_variable map[key_data_type]value_data_type

/* 使用 make 函数 */
map_variable := make(map[key_data_type]value_data_type)
```

如果不初始化 map，那么就会创建一个 nil map。nil map 不能用来存放键值对

### 实例

下面实例演示了创建和使用map:

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** countryCapitalMap map[string]string */\*创建集合 \*/*
   countryCapitalMap = make(map[string]string)

   */\* map插入key - value对,各个国家对应的首都 \*/*
   countryCapitalMap [ "France" ] = "巴黎"
   countryCapitalMap [ "Italy" ] = "罗马"
   countryCapitalMap [ "Japan" ] = "东京"
   countryCapitalMap [ "India " ] = "新德里"

   */\*使用键输出地图值 \*/* 
   **for** country := **range** countryCapitalMap {
     fmt.Println(country, "首都是", countryCapitalMap [country])
   }

   */\*查看元素在集合中是否存在 \*/*
   capital, ok := countryCapitalMap [ "American" ] */\*如果确定是真实的,则存在,否则不存在 \*/*
   */\*fmt.Println(capital) \*/*
   */\*fmt.Println(ok) \*/*
   **if** (ok) {
     fmt.Println("American 的首都是", capital)
   } **else** {
     fmt.Println("American 的首都不存在")
   }
 }

以上实例运行结果为：

```
France 首都是 巴黎
Italy 首都是 罗马
Japan 首都是 东京
India  首都是 新德里
American 的首都不存在
```

------

## delete() 函数

delete() 函数用于删除集合的元素, 参数为 map 和其对应的 key。实例如下：

## 实例

**package** main

 **import** "fmt"

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

# Go 语言递归函数

递归，就是在运行的过程中调用自己。

语法格式如下：

func recursion() {
   recursion() */\* 函数调用自身 \*/*
 }

 func main() {
   recursion()
 }

Go 语言支持递归。但我们在使用递归时，开发者需要设置退出条件，否则递归将陷入无限循环中。

递归函数对于解决数学上的问题是非常有用的，就像计算阶乘，生成斐波那契数列等。

------

## 阶乘

以下实例通过 Go 语言的递归函数实例阶乘：

## 实例

**package** main

 **import** "fmt"

 func Factorial(n uint64)(result uint64) {
   **if** (n > 0) {
     result = n * Factorial(n-1)
     **return** result
   }
   **return** 1
 }

 func main() {  
   **var** i int = 15
   fmt.Printf("%d 的阶乘是 %d**\n**", i, Factorial(uint64(i)))
 }

以上实例执行输出结果为：

```
15 的阶乘是 1307674368000
```

------

## 斐波那契数列

以下实例通过 Go 语言的递归函数实现斐波那契数列：

## 实例

**package** main

 **import** "fmt"

 func fibonacci(n int) int {
  **if** n < 2 {
   **return** n
  }
  **return** fibonacci(n-2) + fibonacci(n-1)
 }

 func main() {
   **var** i int
   **for** i = 0; i < 10; i++ {
     fmt.Printf("%d**\t**", fibonacci(i))
   }
 }

以上实例执行输出结果为：

```
0    1    1    2    3    5    8    13    21    34
```

# Go 语言类型转换

类型转换用于将一种数据类型的变量转换为另外一种类型的变量。Go 语言类型转换基本格式如下：

```
type_name(expression)
```

type_name 为类型，expression 为表达式。

### 实例

以下实例中将整型转化为浮点型，并计算结果，将结果赋值给浮点型变量：

## 实例

**package** main

 **import** "fmt"

 func main() {
   **var** sum int = 17
   **var** count int = 5
   **var** mean float32

   mean = float32(sum)/float32(count)
   fmt.Printf("mean 的值为: %f**\n**",mean)
 }

以上实例执行输出结果为：

```
mean 的值为: 3.400000
```

# Go 语言接口

Go 语言提供了另外一种数据类型即接口，它把所有的具有共性的方法定义在一起，任何其他类型只要实现了这些方法就是实现了这个接口。

### 实例

## 实例

*/\* 定义接口 \*/*
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

### 实例

## 实例

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

在上面的例子中，我们定义了一个接口Phone，接口里面有一个方法call()。然后我们在main函数里面定义了一个Phone类型变量，并分别为之赋值为NokiaPhone和IPhone。然后调用call()方法，输出结果如下：

```
I am Nokia, I can call you!
I am iPhone, I can call you!
```

# Go 错误处理

Go 语言通过内置的错误接口提供了非常简单的错误处理机制。

error类型是一个接口类型，这是它的定义：

```
type error interface {
    Error() string
}
```

我们可以在编码中通过实现 error 接口类型来生成错误信息。

函数通常在最后的返回值中返回错误信息。使用errors.New 可返回一个错误信息：

```
func Sqrt(f float64) (float64, error) {
    if f < 0 {
        return 0, errors.New("math: square root of negative number")
    }
    // 实现
}
```

在下面的例子中，我们在调用Sqrt的时候传递的一个负数，然后就得到了non-nil的error对象，将此对象与nil比较，结果为true，所以fmt.Println(fmt包在处理error时会调用Error方法)被调用，以输出错误，请看下面调用的示例代码：

```
result, err:= Sqrt(-1)

if err != nil {
   fmt.Println(err)
}
```

### 实例

## 实例

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

执行以上程序，输出结果为：

```
100/10 =  10
errorMsg is:  
    Cannot proceed, the divider is zero.
    dividee: 100
    divider: 0
```

# Go 并发

Go 语言支持并发，我们只需要通过 go 关键字来开启 goroutine 即可。

goroutine 是轻量级线程，goroutine 的调度是由 Golang 运行时进行管理的。

goroutine 语法格式：

```
go 函数名( 参数列表 )
```

例如：

```
go f(x, y, z)
```

开启一个新的 goroutine:

```
f(x, y, z)
```

Go 允许使用 go 语句开启一个新的运行期线程， 即 goroutine，以一个不同的、新创建的 goroutine 来执行一个函数。 同一个程序中的所有 goroutine 共享同一个地址空间。

## 实例

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

------

## 通道（channel）

通道（channel）是用来传递数据的一个数据结构。

通道可用于两个 goroutine 之间通过传递一个指定类型的值来同步运行和通讯。操作符 `<-` 用于指定通道的方向，发送或接收。如果未指定方向，则为双向通道。

```
ch <- v    // 把 v 发送到通道 ch
v := <-ch  // 从 ch 接收数据
           // 并把值赋给 v
```

声明一个通道很简单，我们使用chan关键字即可，通道在使用前必须先创建：

```
ch := make(chan int)
```

**注意**：默认情况下，通道是不带缓冲区的。发送端发送数据，同时必须有接收端相应的接收数据。

以下实例通过两个 goroutine 来计算数字之和，在 goroutine 完成计算后，它会计算两个结果的和：

## 实例

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

输出结果为：

```
-5 17 12
```

### 通道缓冲区

通道可以设置缓冲区，通过 make 的第二个参数指定缓冲区大小：

```
ch := make(chan int, 100)
```

带缓冲区的通道允许发送端的数据发送和接收端的数据获取处于异步状态，就是说发送端发送的数据可以放在缓冲区里面，可以等待接收端去获取数据，而不是立刻需要接收端去获取数据。

不过由于缓冲区的大小是有限的，所以还是必须有接收端来接收数据的，否则缓冲区一满，数据发送端就无法再发送数据了。

**注意**：如果通道不带缓冲，发送方会阻塞直到接收方从通道中接收了值。如果通道带缓冲，发送方则会阻塞直到发送的值被拷贝到缓冲区内；如果缓冲区已满，则意味着需要等待直到某个接收方获取到一个值。接收方在有值可以接收之前会一直阻塞。

## 实例

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

执行输出结果为：

```
1
2
```

### Go 遍历通道与关闭通道

Go 通过 range 关键字来实现遍历读取到的数据，类似于与数组或切片。格式如下：

```
v, ok := <-ch
```

如果通道接收不到数据后 ok 就为 false，这时通道就可以使用 close() 函数来关闭。

## 实例

**package** main

 **import** (
     "fmt"
 )

 func fibonacci(n int, c chan int) {
     x, y := 0, 1
     **for** i := 0; i < n; i++ {
         c <- x
         x, y = y, x+y
     }
     close(c)
 }

 func main() {
     c := make(chan int, 10)
     **go** fibonacci(cap(c), c)
     *// range 函数遍历每个从通道接收到的数据，因为 c 在发送完 10 个*
     *// 数据之后就关闭了通道，所以这里我们 range 函数在接收到 10 个数据*
     *// 之后就结束了。如果上面的 c 通道不关闭，那么 range 函数就不*
     *// 会结束，从而在接收第 11 个数据的时候就阻塞了。*
     **for** i := **range** c {
         fmt.Println(i)
     }
 }

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

