# Go

## 标识符

用来命名变量、类型等程序实体。一个标识符实际上就是一个或是多个字母(A~Z和a~z)数字(0~9)、下划线_组成的序列，但是第一个字符必须是字母或者下划线而不能是数字。 

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
append  bool     byte     cap      close   complex  complex64  complex128  uint16
copy    false    float32  float64  imag    int      int8       int16       uint32
int32   int64    iota     len      make    new      nil        panic       uint64
print   println  real     recover  string  true     uint       uint8       uintptr
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
```

### 包

每个Go程序都是有包组成的。程序运行的入口是包"main"。
### 导入
```go
import "XXX"
```
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
v3 := 10
```
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
## Other
当两个或多个连续的函数命名参数是同一类型，则除了最后一个类型之外，其他都可以省略。

```go
x int, y int	==>		x, y int
```

## IDE

LiteIDE

Goland

VS Code