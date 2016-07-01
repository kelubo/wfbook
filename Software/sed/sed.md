# sed
流编辑器

## 基本语法

    # sed 's/term/replacement/flag' file

flag:

    g	表示sed应该替换文件没一行中所有应当替换的实例。省略该标志，只会替换没一行中第一次出现的实例。
