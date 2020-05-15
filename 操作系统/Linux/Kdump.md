# kdump
kdump是在系统崩溃、死锁或者死机的时候用来转储内存运行参数的一个工具和服务。

如果系统一旦崩溃那么正常的内核就没有办法工作了，在这个时候将由kdump产生一个用于capture当前运行信息的内核，该内核会将此时的内存中的所有运行状态和数据信息收集到一个dump core文件中以便于Red Hat工程师分析崩溃原因，一旦内存信息收集完成，系统将自动重启。这和以前的diskdump，netdump是同样道理。只不过kdump是RHEL6特有的。

查看Linux系统是否打开kdump

```bash
ulimit -c
#如果输出为 0 ，则代表没有打开。如果为unlimited则已经打开。
```

临时打开/关闭Linux的kdump方法

```bash
ulimit -c unlimited #打开
ulimit -c 0         #关闭
```


修改配置文件进行打开/关闭kdump方法

```bash
echo "ulimit -S -c unlimited> /dev/null 2>&1" >> /etc/profile
source /etc/profile
```

系统崩溃时kdump文件位置及查看方法

```bash
# 修改生成的日志文件的路径到/var/log下
echo “/var/log” > /proc/sys/kernel/core_pattern
kdump文件名为core.xxxx
执行gdb core.xxx进行调试。
```

