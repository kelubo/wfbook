# 任务管理工具Taskwarrior

它维护一个任务列表，允许你针对你的任务列表进行添加、移除或者一些其他的操作。任务由丰富的子命令设定，允许你进行精准复杂的控制。它还有可制定报告，报表，时间管理，设备同步，文档，扩展，主题，假期文件以及更多。

## 安装
Ubuntu

    sudo apt-get install task

Mac with brew

    brew install task

## 基础用法
新增一个任务

    $ task add Buy a vps!
    $ task list

    ID Project Pri Due Active Age Description
     1                         3s Buy a vps!

    1 task

删除一个任务

    $ task
    [task next]

    ID Project Pri Due A Age Urgency Description
     1                   29s       0 Buy a vps!

    1 task
    $ task 1 delete
    Permanently delete task 1 'Buy a vps!'? (yes/no) yes
    Deleting task 1 'Buy a vps!'.
    Deleted 1 task.

将任务标记为完成

    $ task add Buy a vps!
    Created task 2.
    $ task
    [task next]

    ID Project Pri Due A Age Urgency Description
     1                    1s       0 Buy a vps!

    1 task
    $ task 1 done
    Completed task 1 'Buy a vps!'.
    Completed 1 task.

查看所有任务

    $ task all

将任务纳入隶属的项目

Taskwarrior的功能很强大，可以简单的为每个任务创建一个隶属的项目。可以有很多种方 法创建或修改任务隶属的项目组。

    可以在添加任务的同时指定任务所隶属的项目
    $ task add project:company Fix a bug
    $ task add proj:company Fix a bug # taskwarrior 会自动匹配唯一的子命令
    $ task add pro:company Fix a bug # taskwarrior 会自动匹配唯一的子命令
    $ task add project:company.server Fix a bug # 项目可以分类成子项目
    1
    2
    3
    4

    $ task add project:company Fix a bug
    $ task add proj:company Fix a bug # taskwarrior 会自动匹配唯一的子命令
    $ task add pro:company Fix a bug # taskwarrior 会自动匹配唯一的子命令
    $ task add project:company.server Fix a bug # 项目可以分类成子项目
    可以使用task <filter> modify proj:xx命令在已经创建的任务上添加或修改它的隶 属项目。
     $ task 2 modify proj:company
    1

     $ task 2 modify proj:company
    查看指定项目下的任务
     $ task proj:company list
    1

     $ task proj:company list
    删除任务的隶属项目
     $ task 1 modify proj:
    1

     $ task 1 modify proj:

高级用法
优先级（priority）

Taskwarrior允许设置任务的优先级。分别有L(Low)，M(Middle)和H(High)三个级别 。

    有了上面所讲到的project知识，理解优先级就不是什么难事了。
    $ task add project:Home priority:H Find the adjustable wrench
    $ task 1 modify priority:M
    $ task 1 modify pri:L # 同样的Taskwarrior可以自动理解子命令的简称
    $ task 1 modify pri: # 删除任务的优先级
    1
    2
    3
    4

    $ task add project:Home priority:H Find the adjustable wrench
    $ task 1 modify priority:M
    $ task 1 modify pri:L # 同样的Taskwarrior可以自动理解子命令的简称
    $ task 1 modify pri: # 删除任务的优先级
    值得一提的是针对优先级的选择器，也就是上面提到的filter
    $ task pri.below:H # High等级以下的任务
    $ task pri.over:L # Low等级以上的任务
    $ task pri.not:M # 不是Middle等级的其他所有任务
    1
    2
    3

    $ task pri.below:H # High等级以下的任务
    $ task pri.over:L # Low等级以上的任务
    $ task pri.not:M # 不是Middle等级的其他所有任务

截止日期（due）

既然是任务管理，没有截止日期还能算强大么？所以，理所当然的，Taskwarrior的due就 应运而生了（其实我一点儿都不觉得理所当然，时时刻刻感谢Taskwarrior开发者们的良苦 用心）。

    为一个任务添加截止日期
    $ task add This is an urgent task due:tomorrow # 将到期时间设置为明天
    $ task 1 modify due:tomorrow # 将到期时间设置为明天
    $ task 1 modify due:2013-03-12 # 将到期时间设置为指定时间
    $ task 1 modify due:eom # 将到期时间设置为当月的最后一天（end-of-mouth）
    $ task 1 modify due:eoy # 将到期时间设置为今年的最后一天（end-of-year）
    $ task 1 modify due: # 删除任务的到期时间
    1
    2
    3
    4
    5
    6

    $ task add This is an urgent task due:tomorrow # 将到期时间设置为明天
    $ task 1 modify due:tomorrow # 将到期时间设置为明天
    $ task 1 modify due:2013-03-12 # 将到期时间设置为指定时间
    $ task 1 modify due:eom # 将到期时间设置为当月的最后一天（end-of-mouth）
    $ task 1 modify due:eoy # 将到期时间设置为今年的最后一天（end-of-year）
    $ task 1 modify due: # 删除任务的到期时间
    due过滤器的使用方法
    $ task due:tomorrow # 明天截止的任务
    $ task due:eom # 当月月末截止的任务
    $ task due.before:today # 今天之前截止的任务
    $ task overdue # 已过期的任务
    1
    2
    3
    4

    $ task due:tomorrow # 明天截止的任务
    $ task due:eom # 当月月末截止的任务
    $ task due.before:today # 今天之前截止的任务
    $ task overdue # 已过期的任务

注释（annotate/denotate）

$ task add Create a blog.
$ task 1 annotate I need a linux server
$ task 1 annotate I gotta learn php
$ task 1
[task next 1]

ID Project Pri Due A Age Urgency Description
 1                   15s     0.9 Create a blog.
                                 8/8/2013 I need a linux server
                                 8/8/2013 I gotta learn php

1 task
1
2
3
4
5
6
7
8
9
10
11
12

$ task add Create a blog.
$ task 1 annotate I need a linux server
$ task 1 annotate I gotta learn php
$ task 1
[task next 1]

ID Project Pri Due A Age Urgency Description
 1                   15s     0.9 Create a blog.
                                 8/8/2013 I need a linux server
                                 8/8/2013 I gotta learn php

1 task

标签

$ task add Create a blog.
$ task 1 modify +blog # 为任务添加标签
$ task +blog list # 标签过滤器
$ task 1 modify -blog # 删除任务的某一个标签
1
2
3
4

$ task add Create a blog.
$ task 1 modify +blog # 为任务添加标签
$ task +blog list # 标签过滤器
$ task 1 modify -blog # 删除任务的某一个标签

追加（prepend/append）

有时候，想要给任务追加一些描述，但是又不想重新把任务的描述打一次的话，可以使用prepend和append功能。
$ task add music
$ task 1 prepend Download some
$ task 1 append into my iPod
$ task 1
[task next 1]

ID Project Pri Due A Age Urgency Description
 1                   13s       0 Download some music into my iPod

1 task
1
2
3
4
5
6
7
8
9
10

$ task add music
$ task 1 prepend Download some
$ task 1 append into my iPod
$ task 1
[task next 1]

ID Project Pri Due A Age Urgency Description
 1                   13s       0 Download some music into my iPod

1 task

重复任务（recur/until）

$ task 1 modify due:eom recur:monthly
$ task 2 modify due:eom recur:yearly
$ task 3 modify due:eom recur:monthly until:eoy
$ task recurring
1
2
3
4

$ task 1 modify due:eom recur:monthly
$ task 2 modify due:eom recur:yearly
$ task 3 modify due:eom recur:monthly until:eoy
$ task recurring

日历（cal）

$ task cal
1

$ task cal

关于这个命令，我就不放运行结果了，反正是相当的惊艳。好了，再见吧，少年们！

MORE

本来还想写一点高级<filter>和高级查询相关的命令。但是我觉得相对于强大的 Taskwarrior，再多的解释都是冰山一角。如果想了解更多，就看手册吧。写的相当详尽可 靠。
$ man task
$ man task-tutorial
1
2

$ man task
$ man task-tutorial
