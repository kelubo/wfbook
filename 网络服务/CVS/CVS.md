# 版本控制系统

[TOC]

## 概述

版本控制是一种记录一个或若干文件内容变化，以便将来查阅特定版本修订情况的系统。

## 分类

### 本地版本控制系统

大多都是采用某种简单的数据库来记录文件的历次更新差异。

其中最流行的一种叫做 RCS，现今许多计算机系统上都还看得到它的踪影。 [RCS](https://www.gnu.org/software/rcs/) 的工作原理是在硬盘上保存补丁集（补丁是指文件修订前后的变化），通过应用所有的补丁，可以重新计算出各个版本的文件内容。

 ![](../../Image/l/o/local.png)

### 集中化的版本控制系统

让在不同系统上的开发者协同工作，集中化的版本控制系统（Centralized Version Control Systems，CVCS）应运而生。这类系统，诸如 CVS、Subversion 以及 Perforce 等，都有一个单一的集中管理的服务器，保存所有文件的修订版本，而协同工作的人们都通过客户端连到这台服务器，取出最新的文件或者提交更新。 多年以来，这已成为版本控制系统的标准做法。

 ![](../../Image/c/centralized.png)

这种做法带来了许多好处，特别是相较于老式的本地 VCS 来说。现在，每个人都可以在一定程度上看到项目中的其他人正在做些什么。 而管理员也可以轻松掌控每个开发者的权限，并且管理一个 CVCS 要远比在各个客户端上维护本地数据库来得轻松容易。

最显而易见的缺点是中央服务器的单点故障。

### 分布式版本控制系统

布式版本控制系统（Distributed Version Control System，简称 DVCS），在这类系统中，像 Git、Mercurial、Bazaar 以及 Darcs 等，客户端并不只提取最新版本的文件快照， 而是把代码仓库完整地镜像下来，包括完整的历史记录。 这么一来，任何一处协同工作用的服务器发生故障，事后都可以用任何一个镜像出来的本地仓库恢复。 因为每一次的克隆操作，实际上都是一次对代码仓库的完整备份。

 ![](../../Image/d/distributed.png)



| 软件              | 语言                | 时间 | 代数 | 备注       |
| ----------------- | ------------------- | ---- | ---- | ---------- |
| SCCS              |                     | 1972 | 1    | 本地       |
| RCS               |                     | 1982 | 1    | 本地       |
| CVS               |                     | 1986 | 2    | 中心服务器 |
| ClearCase         |                     | 1992 | 2    | 中心服务器 |
| Visual SourceSafe |                     | 1994 | 2    | 中心服务器 |
| Perforce          |                     | 1995 | 2    | 中心服务器 |
| Subversion        |                     | 2000 | 2    | 中心服务器 |
| Git               | C Shell Perl Python | 2005 | 3    | 分布式     |
| Mercurial         | Python C            | 2005 | 3    | 分布式     |
| BitKeeper         |                     |      |      |            |
| Monotone          |                     |      |      |            |
| TFS               |                     |      |      |            |

## CVS
![](../../Image/a/r.png)
## SVN
![](../../Image/a/s.png)

## 协同模式对比
**集中式**  
![](../../Image/a/u.png)  
**分布式**  
![](../../Image/a/v.png)  
**Github**  
![](../../Image/a/w.png)

## 命令对照

| 比较项目 | Git命令 | Hg命令 |
|----------|---------|--------|
| URL      | git://host/path/to/repos.git <br> ssh://user@host/path/to/repos.git <br> user@host:path/to/repos.git <br> file:///path/to/repos.git <br> /path/to/repos.git | http://host/path/to/repos <br> ssh://user@host/path/to/repos <br> file:///path/to/repos <br> /path/to/repos |
| 配置 | [user] <br> name = Fristname Lastname <br> email = mail@addr | [ui] <br> username = Firstname Lastname <mail@addr> |
| 版本库初始化| git init [-bare] `<path>` | hg init `<path>` |
| 版本库克隆| git clone `<url>` `<path>` | hg clone `<url>` `<path>` |
||||
||||
||||
||||
||||
||||
||||
||||
