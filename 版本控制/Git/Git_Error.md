# Git 异常处理
## 乱码
使用git add添加要提交的文件的时候，如果文件名是中文，会显示形如 274\232\350\256\256\346\200\273\347\273\223.png 的乱码。

在bash提示符下输入：

    git config --global core.quotepath false

core.quotepath设为false的话，就不会对0x80以上的字符进行quote。中文显示正常。
