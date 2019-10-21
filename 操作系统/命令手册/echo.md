# echo

用于字符串的输出

```bash
echo string
```



1.显示普通字符串:

```bash
echo "It is a test"
这里的双引号完全可以省略，以下命令与上面实例效果一致：
echo It is a test
```

2.显示转义字符

```bash
echo "\"It is a test\""
结果将是:
"It is a test"
同样，双引号也可以省略
```

 3.显示变量

```bash
read 命令从标准输入中读取一行,并把输入行的每个字段的值指定给 shell 变量

#!/bin/sh
read name 
echo "$name It is a test"
```

 4.显示换行

```bash
echo -e "OK! \n" # -e 开启转义
echo "It it a test"
```

 5.显示不换行

```bash
echo -e "OK! \c" # -e 开启转义 \c 不换行
echo "It is a test"
```

- 转义

　　　　\a 发出警告声； 

　　　　\b 删除前一个字符； 

　　　　\c 最后不加上换行符号； 

　　　　\f 换行但光标仍旧停留在原来的位置； 

　　　　\n 换行且光标移至行首； 

　　　　\r 光标移至行首，但不换行； 

　　　　\t 插入tab； 

　　　　\v 与\f相同； 

　　　　\\ 插入\字符； 

　　　　\nnn 插入nnn（八进制）所代表的ASCII字符；

6.显示结果定向至文件

```bash
echo "It is a test" > myfile
```

 7.原样输出字符串，不进行转义或取变量(用单引号)

```bash
echo '$name\"'
输出结果：
$name\"
```

8.显示命令执行结果

```bash
echo `date`
结果将显示当前日期
```