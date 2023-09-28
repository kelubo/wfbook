# dd

[TOC]

## 概述

用于复制文件并对原文件的内容进行转换和格式化处理。

用的比较多的是用 dd 来备份裸设备。建议在有需要的时候使用dd 对物理磁盘操作，如果是文件系统的话还是使用tar backup cpio等其他命令更加方便。另外，使用dd对磁盘操作时，最好使用块设备文件。


## 语法格式
```bash
dd [option]

if=file                       输入文件或源设备，缺省为标准输入。
of=file                       输出文件名，缺省为标准输出
ibs=bytes                     一次读入 bytes 个字节（即一个块大小为 bytes 个字节）
obs=bytes                     一次写 bytes 个字节（即一个块大小为 bytes 个字节）
bs=bytes                      同时设置读写块的大小为 bytes ，可代替 ibs 和 obs
cbs=bytes                     一次转换 bytes 个字节，即转换缓冲区大小
skip=blocks                   从输入文件开头跳过 blocks 个块后再开始复制
seek=blocks                   从输出文件开头跳过 blocks 个块后再开始复制。（通常只有当输出文件是磁盘或磁带时才有效）
count=blocks                  仅拷贝 blocks 个块，块大小等于 ibs 指定的字节数
conv=ASCII                    把EBCDIC码转换为ASCIl码。
conv=ebcdic                   把ASCIl码转换为EBCDIC码。
conv=ibm                      把ASCIl码转换为alternate EBCDIC码。
conv=block                    把变动位转换成固定字符。
conv=ublock                   把固定位转换成变动位。
conv=ucase                    把字母由小写转换为大写。
conv=lcase                    把字母由大写转换为小写。
conv=notrunc                  不截短输出文件。
conv=swab                     交换每一对输入字节。
conv=noerror                  出错时不停止处理。
conv=sync                     把每个输入记录的大小都调到ibs的大小（用NUL填充）。
注意：指定数字的地方若以下列字符结尾乘以相应的数字：b=512, c=1, k=1024, w=2, xm=number m，kB=1000，K=1024，MB=1000*1000，M=1024*1024，GB=1000*1000*1000，G=1024*1024*1024
```





cbs=<字节数>：转换时，每次只转换指定的字节数； conv=<关键字>：指定文件转换的方式； count=<区块数>：仅读取指定的区块数； ibs=<字节数>：每次读取的字节数； obs=<字节数>：每次输出的字节数； of=<文件>：输出到文件； seek=<区块数>：一开始输出时，跳过指定的区块数； skip=<区块数>：一开始读取时，跳过指定的区块数； --help：帮助； --version：显示版本信息。 实例 [root@localhost text]# dd if=/dev/zero of=sun.txt bs=1M count=1 1+0 records in 1+0 records out 1048576 bytes (1.0 MB) copied, 0.006107 seconds, 172 MB/s [root@localhost text]# du -sh sun.txt 1.1M sun.txt 该命令创建了一个1M大小的文件sun.txt，其中参数解释： if 代表输入文件。如果不指定if，默认就会从stdin中读取输入。 of 代表输出文件。如果不指定of，默认就会将stdout作为默认输出。 bs 代表字节为单位的块大小。 count 代表被复制的块数。 /dev/zero 是一个字符设备，会不断返回0值字节（\0）。 块大小可以使用的计量单位表 单元大小 代码 字节（1B） c 字节（2B） w 块（512B） b 千字节（1024B） k 兆字节（1024KB） M 吉字节（1024MB） G 以上命令可以看出dd命令来测试内存操作速度： 1048576 bytes (1.0 MB) copied, 0.006107 seconds, 172 MB/s

dd使用实例
假设了如下的情况：
要备份的数据文件：30720KB
block 0 =8 KB.
raw offset 64 KB.
设定 bs=8k
1、从raw设备备份到raw设备
dd if=/dev/rsd1b of=/dev/rsd2b bs=8k skip=8 seek=8 count=3841
2、裸设备到文件系统
dd if=/dev/rsd1b of=/backup/df1.dbf bs=8k skip=8 count=3841
3、文件系统到裸设备
dd if=/backup/df1.dbf of=/dev/rsd2b bs=8k seek=8
4、文件系统到文件系统，你可以为了提升I/O把bs设为较高的数值
dd if=/oracle/dbs/df1.dbf of=/backup/df1.dbf bs=1024k
5、备份/dev/hdx全盘数据，并利用gzip工具进行压缩，保存到指定路径（bzip2工具也一样可使用）
dd  if=/dev/hdx  |  gzip > /path/to/image.gz

6、生成1G的虚拟块设备Sparse File(稀疏文件)
dd if=/dev/zero of=1G.img bs=1M seek=1000 count=0

Sparse File是什么，稀疏文件，也就是说，是一个拥有空的空间的文件，磁盘块将并没分配给这些文件。如果这些空的空间填满ASCII的NULL字符，那么文件才会是实际的大小。
7、拷贝光盘数据到backup文件夹下，并保存为cd.iso文件，再进行刻录
dd  if=/dev/cdrom  of=/backup/cd.iso
cdrecord -v cd.iso
8、将内存里的数据拷贝到backup目录下的mem.bin文件
dd if=/dev/mem of=/backup/mem.bin bs=1024
9、将软驱数据备份到当前目录的disk.img文件
dd if=/dev/fd0 of=disk.img count=1 bs=1440k
10、将备份文件恢复到指定盘
dd if=/backup/df1.dbf of=/dev/rsd1b
11、将压缩的备份文件恢复到指定盘
gzip -dc /path/to/image.gz | dd of=/dev/hdx

12、测试磁盘写能力

time dd if=/dev/zero of=/test.dbf bs=8k count=300000
因为/dev/zero是一个伪设备，它只产生空字符流，对它不会产生IO，所以，IO都会集中在of文件中，of文件只用于写，所以这个命令相当于测试磁盘的写能力。
13、测试磁盘读能力
time dd if=/dev/sdb1 of=/dev/null bs=8k
因为/dev/sdb1是一个物理分区，对它的读取会产生IO，/dev/null是伪设备，相当于黑洞，of到该设备不会产生IO，所以，这个命令的IO只发生在/dev/sdb1上，也相当于测试磁盘的读能力。
14、测试同时读写能力
time dd if=/dev/sdb1 of=/test1.dbf bs=8k
这个命令下，一个是物理分区，一个是实际的文件，对它们的读写都会产生IO（对/dev/sdb1是读，对/test1.dbf是写），假设他们都在一个磁盘中，这个命令就相当于测试磁盘的同时读写能力

15、备份磁盘开始的512Byte大小的MBR信息到指定文件
dd  if=/dev/hdx  of=/path/to/image  count=1  bs=512
16、恢复MBR
dd if=/mnt/windows/linux.lnx of=/dev/hda bs=512 count=1

17、 得到最恰当的block size。 通过比较dd指令输出中所显示的命令执行时间（选时间最少的那个），即可确定系统最佳的block size大小
dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file
dd if=/dev/zero bs=2048 count=500000 of=/root/1Gb.file
dd if=/dev/zero bs=4096 count=250000 of=/root/1Gb.file
dd if=/dev/zero bs=8192 count=125000 of=/root/1Gb.file




## 显示dd命令的进度
查看dd命令的执行进度，可以使用下面几种方法：
比如：每5秒输出dd的进度

方法一：

watch -n 5 pkill -USR1 ^dd$

方法二：

watch -n 5 killall -USR1 dd

方法三：

while killall -USR1 dd; do sleep 5; done

方法四：

while (ps auxww |grep " dd " |grep -v grep |awk '{print $2}' |while read pid; do kill -USR1 $pid; done) ; do sleep 5; done

上述四种方法中使用三个命令：pkill、killall、kill向dd命令发送SIGUSR1信息，dd命令进程接收到信号之后就打印出自己当前的进度。
