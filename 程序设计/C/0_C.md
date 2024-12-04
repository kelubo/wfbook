# C
## 历史

C 最初是由丹尼斯·里奇在贝尔实验室为开发 UNIX 操作系统而设计的。C 语言最开始是于 1972 年在 DEC PDP-11 计算机上被首次实现。

在 1978 年，布莱恩·柯林汉（Brian Kernighan）和丹尼斯·里奇（Dennis Ritchie）制作了 C 的第一个公开可用的描述，现在被称为 K&R 标准。

CPL-->BCPL-->B-->C

## 基本结构

    #include <stdio.h>

    int main()
    {
        printf("Hello, World! \n");
        return 0;
    }

## C11

C11 指ISO标准ISO/IEC 9899:2011，是当前最新的C语言标准。在它之前的C语言标准为C99。

## 标识符
一个标识符以字母 A-Z 或 a-z 或下划线 _ 开始，后跟零个或多个字母、下划线和数字（0-9）。

### 关键字

| 1        | 2              | 3         | 4             |
|----------|----------------|-----------|---------------|
| auto     | else           |	long      | switch        |
| break    | enum           |	register  | typedef       |
| case     | extern         |	return    | union         |
| char     | float 	        | short 	  | unsigned      |
| const    | for 	          | signed 	  | void          |
| continue | goto           | sizeof    | volatile      |
| default  | if             | static    | while         |
| do       | inline	        | struct 	  | _Packed       |
| double   | int            |	restrict  | _Bool         |
| _Complex | _Imaginary     | _Alignas  | _Alignof      |
| _Atomic  | _Static_assert | _Noreturn | _Thread_local |
| _Generic |
