# Auditd - Linux 服务器安全审计工具

auditd（或 auditd 守护进程）是Linux审计系统中用户空间的一个组件，其负责将审计记录写入磁盘。

audit是linux安全体系的重要组成部分，是一种“被动”的防御体系。在内核里有内核审计模块，记录系统中的各种动作和事件，比如系统调用，文件修改，执行的程序，系统登入登出和记录所有系统中所有的事件，它的主要目的是方便管理员根据日记审计系统是否允许有异常，是否有入侵等等，就是把和系统安全有关的事件记录下来。

源码地址：https://github.com/linux-audit/audit-userspace

审计能够记录到日志的内容:

* 事件发生的日期和结果，触发事件的用户

* 远程连接记录，如访问ssh，ftp

* 对标记目录或文件的修改行为

* 监控调用的系统资源

* 记录用户的运行的命令

* 监控网络访问行为

## 安装

### CentOS

```bash
yum -y install audit                  #安装软件包
cat /etc/audit/auditd.conf            #查看配置文件，确定日志位置
  log_file = /var/log/audit/audit.log
systemctl start auditd                #启动服务
systemctl enable auditd               #设置开机自启
```
### Ubuntu

```bash
sudo wajig install auditd
```

## 组件

- auditctl					                 即时控制审计守护进程的行为的工具，如添加规则等
- /etc/audit/audit.rules	        记录审计规则的文件，默认为空。
- aureport					              查看和生成审计报告的工具。
- ausearch					              查找审计事件的工具
- auditspd					               转发事件通知给其他应用程序，而不是写入到审计日志文件中。
- autrace					                 一个用于跟踪进程的命令。
- /etc/audit/auditd.conf		   auditd工具的配置文件。

## 使用
### 查看审计规则

```bash
auditctl -l
```


### 文件和目录访问审计

```bash
auditctl -w path -p rwxa -k key_name
auditctl -w directory

选项 :
-w path 	:指定要监控的路径
-p      	:指定触发审计的文件/目录的访问权限
rwxa    	:指定的触发条件，r 读取权限，w 写入权限，x 执行权限，a 属性（attr）
-k key_name	:可选项，方便识别哪些规则生成特定的日志项
```

### 查看审计日志

使用 ausearch 工具可以查看auditd日志。

```bash
ausearch -f path
ausearch -k key_name -i    
#根据key搜索日志，-i选项表示以交互式方式操作
```

下面是输出 ：

```bash
tail -f /var/log/audit/audit.log
  type=SYSCALL msg=audit(1517557590.644:229228): arch=c000003e
  syscall=2 success=yes exit=3
  a0=7fff71721839 a1=0 a2=1fffffffffff0000 a3=7fff717204c0
  items=1 ppid=7654 pid=7808 auid=0 uid=0 gid=0 euid=0 suid=0
  fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="cat"
  exe="/usr/bin/cat"
  subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="sshd_config"
    .. ..
#内容分析
# time						审计时间
# name						审计对象
# cwd						当前路径
# syscall					相关的系统调用
# auid						审计用户ID
# uid 和 gid				    访问文件的用户ID和用户组ID
# comm						用户访问文件的命令
# exe						上面命令的可执行文件路径
# type						类型
# msg						为(time_stamp:ID)，时间是date +%s（1970-1-1至今的秒数）
# arch=c000003e				代表x86_64（16进制）
# success=yes/no			事件是否成功
# a0-a3						是程序调用时前4个参数，16进制编码了
# ppid						父进程ID，如bash，pid进程ID，如cat命令
# auid					    审核用户的id，su - test, 依然可以追踪su前的账户
# tty						从哪个终端执行的命令
# comm="cat"         		用户在命令行执行的指令
# key="sshd_config"    		管理员定义的策略关键字key
# type=CWD        			用来记录当前工作目录
# cwd="/home/username"
# ouid(owner's user id）    对象所有者id
# guid(owner's groupid）    对象所有者id
```

### 查看审计报告

aureport 是使用系统审计日志生成简要报告的工具。

生成审计报告，我们可以使用aureport工具。

```bash
aureport
# 不带参数运行的话，可以生成审计活动的概述。
-au	#查看授权失败的详细信息
-m	#查看所有账户修改相关的事件
```
### 其他
```bash
auditctl -s                     #查询状态
auditctl -D                     #删除所有规则
```
### 配置文件

将策略添加到/etc/audit/audit.rules中使得规则永久有效。

```bash
-w path -p rwxa
```

重启auditd守护程序

```bash
/etc/init.d/auditd restart
service auditd restart
```
