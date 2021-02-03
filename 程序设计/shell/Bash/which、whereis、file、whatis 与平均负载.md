which、whereis、file、whatis 与平均负载
这则攻略旨在讲解我们通常会碰到的几个命令。掌握这些命令对于用户来说很有益处。实战演练
让我们看看以下这些命令及其用例。which
which命令用来找出某个命令的位置。我们在终端输入命令的时候无需知道对应的可执行文件位于何处。终端会在一组位置中查找这个命令，如果能够找到，那么就执行该可执行文件。这一组位置由环境变量PATH指定。例如： echo  PATH/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
我们可以导出并添加我们自己的命令搜素位置。例如，要将 /home/slynux/bin添加到PATH中，可以使用以下命令： export PATH=  PATH:/home/slynux/bin# /home/slynux/bin被添加到PATH中
which命令输出作为参数的命令的所在位置。例如： which ls/bin/lswhereis

whereis与which命令类似，但是它不仅返回命令的路径，还能够打印出其对应的命令手册的位置以及命令源代码的路径（如果有的话）。例如： whereis lsls: /bin/ls /usr/share/man/man1/ls.1.gzfile
file命令是一个既有趣又使用频繁的命令。它用来确定文件的类型： file FILENAME
该命令会打印出与该文件类型相关的细节信息。
例如： file /bin/ls/bin/ls: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),dynamically linked (uses shared libs), for GNU/Linux 2.6.15, strippedwhatis
whatis命令会输出作为参数的命令的简短描述信息。这些信息是从命令手册中解析得来的。例如： whatis lsls (1)　　　　- list directory contentsapropos

有时候我们需要搜索和某个单词相关的命令是否存在。那么可以搜索包含该字符串命令的手册页。为此，我们使用：apropos COMMAND平均负载
平均负载（load average）是系统运行总负载量的一个重要参数。它指明了系统中可运行进程总量的平均值。平均负载由三个值来指定，第一个值指明了1分钟内的平均值，第二个值指明了5分钟内的平均值，第三个值指明了15分钟内的平均值。
这三个值可以通过运行uptime获得。例如： uptime12:40:53 up 6:16, 2 users, load average: 0.00, 0.00, 0.00