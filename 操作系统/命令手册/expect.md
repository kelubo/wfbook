linux中expect的用法是什么

expect是一个自动化交互套件，主要应用于执行命令和程序时，系统以交互形式要求输入指定字符串，实现交互通信。

expect自动交互流程：

spawn启动指定进程---expect获取指定关键字---send向指定程序发送指定字符---执行完成退出.

注意该脚本能够执行的前提是安装了expect

yum install -y expect

expect常用命令总结:

    spawn 交互程序开始后面跟命令或者指定程序

    expect 获取匹配信息匹配成功则执行expect后面的程序动作

    send exp_send 用于发送指定的字符串信息

    exp_continue 在expect中多次匹配就需要用到

    send_user 用来打印输出 相当于shell中的echo

    exit 退出expect脚本

    eof expect执行结束 退出

    set 定义变量

    puts 输出变量

    set timeout 设置超时时间

示例：

1.ssh登录远程主机执行命令,执行方法 expect 1.sh 或者 ./1.sh

# vim 1.sh 

#!/usr/bin/expect

spawn ssh saneri@192.168.56.103 df -Th

expect "*password"

send "123456\n"

expect eof

2. ssh远程登录主机执行命令，在shell脚本中执行expect命令,执行方法sh 2.sh、bash 2.sh 或./2.sh都可以执行.

#!/bin/bash

passwd='123456'

/usr/bin/expect <<-EOF

set time 30

spawn ssh saneri@192.168.56.103 df -Th

expect {

"*yes/no" { send "yes\r"; exp_continue }

"*password:" { send "$passwd\r" }

}

expect eof

EOF