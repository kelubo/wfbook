# Go

也称 Golang，起源于 2007 年，并在 2009 年正式对外发布。

Go语言没有类和继承的概念。通过接口（interface）的概念来实现多态性。

**Go语言创始人：** Ken Thompson 和 Rob Pike、Robert Griesemer

## Go语言吉祥物

Go语言有一个吉祥物，在会议、文档页面和博文中，大多会包含下图所示的 Go Gopher，这是才华横溢的插画家 Renee French 设计的，她也是 Go 设计者之一 Rob Pike 的妻子。



![img](..\..\Image\g\go.jpg)

## 特性

语法简单

并发模型

内存分配

垃圾回收

静态链接

标准库

工具链

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



![抽象语法树](http://c.biancheng.net/uploads/allimg/191115/4-191115094600340.gif)
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



![img](http://c.biancheng.net/uploads/allimg/191115/4-19111511533W48.gif)


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
### 预定义标识符

```go
// 内建常量
true  false  iota  nil
// 内建类型
int  int8  int16  int32  int64  uint  uint8  uint16  uint32  uint64  uintptr  float32  float64  complex64  complex128  bool  byte  rune  string  error 
// 内建函数
len  make  cap  new  append  copy  close  delete  complex  real  imag  panic  recover 
```

## 注释方法

```go
//		单行注释
/**/	多行注释
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

## 变量

### 变量声明

```go
var v1 int
var v2 string
var v3 [10]int            // 数组
var v4 []int              // 数组切片
var v5 struct {
	f int
}
var v6 *int               // 指针
var v7 map[string]int     // map,key为string类型，value为int类型
var v8 func(a int) int

var (                     // 声明多个变量，只能声明全局变量
	v1 int
	v2 string
)
```

### 变量初始化
```go
var v1 int = 10
var v2 = 10
v3 := 10               //只能用在函数内部，不能用于函数外
```
变量会在声明时直接初始化。如果变量没有显式初始化，则被隐式地赋予其类型的*零值*（zero value），数值类型是0，字符串类型是空字符串"" 

### 匿名变量

在调用函数时为了获取一个值，但该函数返回多个值，不希望定义一堆没用的变量。eg:

```go
func GetName() (firstName,lastName,nickName string) {
	return "May", "Chan", "Chibi Maruko"
}
_, _, nickName := GetName()
```
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

### 类型
**布尔类型：**bool  

```go
true false
```

**整形：**  

| 类型 | 长度（字节） | 值范围 |
|----|--------|--|
| int8 | 1 | -128~127 |
| uint8(byte) | 1 | 0~255 |
| int16 | 2 | -32768~32767 |
| uint16 | 2 | 0~65535 |
| int32 | 4 | -2147483648~2147483647 |
| uint32 | 4 | 0~4294967295 |
| int64 | 8 | -9223372036854775808~9223372036854775807 |
| uint64 | 8 | 0~18446744073709551615 |
| int | 平台相关 | 平台相关 |
| uint | 平台相关 | 平台相关 |
| uintptr | 同指针 | 在32位平台下为4字节，64位平台下为8字节 |

**浮点类型：**float32,float64  

```go
import "match"
// p为用户自定义的比较精度，比如0.00001
func IsEqual(f1, f2, p float64) bool {
	return math.Fdim(f1, f2) <p
}
```

**复数类型：**complex64,complex128  
**字符串：**string  

 对string类型，`+`运算符连接字符串 

**字符类型：**rune  
**错误类型：**error  
**指针**  
**数组**  
**切片**  
**字典**  
**通道**  
**结构体**  
**接口**

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

## IDE

LiteIDE

Goland

Sublime Text

GoClipse

Visual Studio Code