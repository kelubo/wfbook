# /proc

在GNU/Linux操作系统中，/proc是一个位于内存中的伪文件系统（in-memory pseudo flesystem）。它的引入是为了提供一个可以从用户空间（user space）读取系统参数的接口。我们能够从中收集到大量的系统信息。

如果查看/proc的话，你会发现很多文件和目录。

系统中每一个运行的进程在/proc中都有一个对应的目录。进程的目录名和进程ID相同。
以Bash为例，它的进程ID是4295（pgrep bash），那么将存在对应的目录 /proc/4295中。进程对应的目录包含了大量有关进程的信息。目录 /proc/PID中一些重要的文件如下所示。
environ——包含与进程相关联的环境变量。
使用cat /proc/4295/environ，可以显示所有传递给该进程的环境变量。
cwd——是一个到进程工作目录的符号链接。

```bash
readlink /proc/4295/exe/bin/bash
```


fd——包含了由进程所使用的文件描述符。