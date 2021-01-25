# 子shell

[TOC]

## 利用子shell生成一个独立的进程

子shell本身就是独立的进程。可以使用 `()`操作符来定义一个子shell：

```bash
pwd;
(cd /bin; ls);
pwd;
```


当命令在子shell中执行时，不会对当前shell有任何影响；所有的改变仅限于子shell内。

## 通过引用子shell的方式保留空格和换行符

假设我们使用子shell或反引用的方法将命令的输出读入一个变量中，可以将它放入双引号中，以保留空格和换行符（\n）。例如：

```bash
cat text.txt
1
2
3

out=$(cat text.txt)
echo $out
1 2 3                 # 丟失了換行符 \n

out="$(cat tex.txt)"
echo $out1
1
2
3
```

