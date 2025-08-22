# SQLite

[TOC]

## 概述

### 摘要

-  [Full-featured SQL 功能齐全的 SQL](https://www.sqlite.org/fullsql
-  [Billions and billions of deployments
  数十亿次部署](https://www.sqlite.org/mostdeployed.html)
-  [Single-file database 单文件数据库](https://www.sqlite.org/onefile.html)
-  [Public domain source code
  公共领域源代码](https://www.sqlite.org/copyright.html)
-  All source code in one file ([sqlite3.c](https://www.sqlite.org/amalgamation.html)) 
  所有源代码都在一个文件中 （[sqlite3.c](https://www.sqlite.org/amalgamation.html)）
-  [Small footprint 占地面积小](https://www.sqlite.org/footprint.html)
-  Max DB size: [281 terabytes](https://www.sqlite.org/limits.html)     (248 bytes) 
  最大数据库大小：[281 TB](https://www.sqlite.org/limits.html) （248 字节）
-  Max row size: [1 gigabyte](https://www.sqlite.org/limits.html)
  最大行大小：[1 GB](https://www.sqlite.org/limits.html)
-  [Faster than direct file I/O
  比直接文件 I/O 更快](https://www.sqlite.org/fasterthanfs.html)
-  [Aviation-grade quality and testing
  航空级质量和测试](https://www.sqlite.org/testing.html)
-  [Zero-configuration 零配置](https://www.sqlite.org/zeroconf.html)
-  [ACID transactions, even after power loss
  ACID 事务，即使在断电后](https://www.sqlite.org/transactional.html)
-  [Stable, enduring file format
  稳定、持久的文件格式](https://www.sqlite.org/fileformat.html)
-  [Extensive, detailed documentation
  广泛、详细的文档](https://www.sqlite.org/doclist.html)
-  [Long-term support 长期支持](https://www.sqlite.org/lts.html)

SQLite is a C-language library that implements a [small](https://www.sqlite.org/footprint.html), [fast](https://www.sqlite.org/fasterthanfs.html), [self-contained](https://www.sqlite.org/selfcontained.html), [high-reliability](https://www.sqlite.org/hirely.html), [full-featured](https://www.sqlite.org/fullsql.html), SQL database engine.
SQLite 是一个 C 语言库，它实现了 [小 ](https://www.sqlite.org/footprint.html)、 [快速 ](https://www.sqlite.org/fasterthanfs.html)、 [自成一体 ](https://www.sqlite.org/selfcontained.html)， [高可靠性 ](https://www.sqlite.org/hirely.html) / [功能齐全](https://www.sqlite.org/fullsql.html)的 SQL 数据库引擎。SQLite 是世界上[使用最广泛的](https://www.sqlite.org/mostdeployed.html)数据库引擎。 SQLite 内置于所有手机和大多数计算机中，并且捆绑在无数人们每天在使用的其他应用程序中。

SQLite database files are commonly used as containers to transfer rich content between systems [[1\]](https://www.sqlite.org/aff_short.html) [[2\]](https://www.sqlite.org/sqlar.html) [[3\]](https://www.sqlite.org/appfileformat.html) and as a long-term archival format for data [[4\]](https://www.sqlite.org/locrsf.html). There are over 1 trillion (1e12) SQLite databases in active use [[5\]](https://www.sqlite.org/mostdeployed.html). 
SQLite [ 文件格式](https://www.sqlite.org/fileformat2.html)是稳定的、跨平台的和向后兼容的，开发人员承诺在 [2050 年](https://www.sqlite.org/lts.html)之前保持这种状态。 SQLite 数据库文件通常用作容器来传输丰富的系统之间的内容 [[1\]](https://www.sqlite.org/aff_short.html)[[2\]](https://www.sqlite.org/sqlar.html)[[3\]](https://www.sqlite.org/appfileformat.html) 以及作为长期存档格式 对于数据 [[4\]。](https://www.sqlite.org/locrsf.html) 有超过 1 万亿 （1e12） 积极使用的 SQLite 数据库 [[5\]](https://www.sqlite.org/mostdeployed.html)。

SQLite 的代码位于 [公共领域 ](https://www.sqlite.org/copyright.html)，因此可以免费用于任何目的，无论是商业目的还是私人目的。

SQLite is an in-process library that implements a [self-contained](https://www.sqlite.org/selfcontained.html),  [serverless](https://www.sqlite.org/serverless.html), [zero-configuration](https://www.sqlite.org/zeroconf.html), [transactional](https://www.sqlite.org/transactional.html) SQL database engine. SQLite is the [most widely deployed](https://www.sqlite.org/mostdeployed.html) database in the world with more applications than we can count, including several [high-profile projects.](https://www.sqlite.org/famous.html)
SQLite 是一个进程内库，它实现了 [自成一体 ](https://www.sqlite.org/selfcontained.html)， [无服务器 ](https://www.sqlite.org/serverless.html)， [零配置 ](https://www.sqlite.org/zeroconf.html) / [事务](https://www.sqlite.org/transactional.html) SQL 数据库引擎。 SQLite 是世界上[部署最广泛的](https://www.sqlite.org/mostdeployed.html)数据库，其应用程序数不胜数，包括几个[备受瞩目的项目。](https://www.sqlite.org/famous.html)

The database [file format](https://www.sqlite.org/fileformat2.html) is cross-platform - you can freely copy a database between 32-bit and 64-bit systems or between  [big-endian](http://en.wikipedia.org/wiki/Endianness) and [little-endian](http://en.wikipedia.org/wiki/Endianness) architectures.  These features make SQLite a popular choice as an [Application File Format](https://www.sqlite.org/appfileformat.html).  SQLite database files are a [recommended storage format](https://www.sqlite.org/locrsf.html) by the US Library of Congress. Think of SQLite not as a replacement for  [Oracle](http://www.oracle.com/database/index.html) but as a replacement for [fopen()](http://man.he.net/man3/fopen)
SQLite 是一个嵌入式 SQL 数据库引擎。与大多数其他 SQL 数据库不同，SQLite 没有单独的服务器进程。SQLite 直接读取和写入普通磁盘文件。具有多个表、索引、触发器和视图的完整 SQL 数据库包含在单个磁盘文件中。数据库[文件格式](https://www.sqlite.org/fileformat2.html)是跨平台的 - 您可以自由复制数据库 在 32 位和 64 位系统之间或介于 [big-endian](http://en.wikipedia.org/wiki/Endianness) 和 [小端](http://en.wikipedia.org/wiki/Endianness) 架构。 这些功能使 SQLite 成为流行的选择，因为 [应用程序文件格式 ](https://www.sqlite.org/appfileformat.html)。 SQLite 数据库文件是一个 美国国会图书馆[推荐的存储格式 ](https://www.sqlite.org/locrsf.html)。 将 SQLite 视为 [Oracle](http://www.oracle.com/database/index.html) 但作为 [fopen（）](http://man.he.net/man3/fopen) 的替代品

With all features enabled, the [library size](https://www.sqlite.org/footprint.html) can be less than 750KiB, depending on the target platform and compiler optimization settings. (64-bit code is larger.  And some compiler optimizations such as aggressive function inlining and loop unrolling can cause the object code to be much larger.) There is a tradeoff between memory usage and speed.   SQLite generally runs faster the more memory you give it.  Nevertheless, performance is usually quite good even in low-memory environments.  Depending on how it is used, SQLite can be [faster than direct filesystem I/O](https://www.sqlite.org/fasterthanfs.html).
SQLite 是一个紧凑的库。启用所有功能后，[ 库大小](https://www.sqlite.org/footprint.html)可以小于 750KiB， 取决于 Target Platform 和 Compiler Optimization 设置。 （64 位代码更大。 以及一些编译器优化 例如激进的函数内联和循环展开可能会导致 object 代码要大得多。 内存使用和速度之间存在权衡。 SQLite 通常运行得越快，内存越多 你给它。 尽管如此，性能通常甚至相当不错 在低内存环境中。 根据它的使用方式，SQLite 可以是 [比直接文件系统 I/O 更快 ](https://www.sqlite.org/fasterthanfs.html)。

SQLite is  [very carefully tested](https://www.sqlite.org/testing.html) prior to every release and has a reputation for being very reliable. Most of the SQLite source code is devoted purely to testing and verification.  An automated test suite runs millions and millions of test cases involving hundreds of millions of individual SQL statements and achieves [100% branch test coverage](https://www.sqlite.org/testing.html#coverage).   SQLite responds gracefully to memory allocation failures and disk I/O errors.  Transactions are [ACID](http://en.wikipedia.org/wiki/ACID) even if interrupted by system crashes or power failures.   All of this is verified by the automated tests using special test harnesses which simulate  system failures. Of course, even with all this testing, there are still bugs. But unlike some similar projects (especially commercial competitors) SQLite is open and honest about all bugs and provides [bugs lists](https://sqlite.org/src/rptview?rn=1) and minute-by-minute [ chronologies](https://sqlite.org/src/timeline) of code changes.
SQLite 是 在每次发布之前都经过[非常仔细的测试 ](https://www.sqlite.org/testing.html)，并以非常可靠而著称。大多数 SQLite 源代码纯粹用于测试和验证。自动化测试套件运行数以百万计的测试用例，涉及数亿个单独的 SQL 语句，并实现 [100% 的分支测试覆盖率 ](https://www.sqlite.org/testing.html#coverage)。  SQLite 优雅地响应内存 分配失败和磁盘 I/O 错误。 交易包括 [酸](http://en.wikipedia.org/wiki/ACID) 即使因系统崩溃或电源故障而中断。 所有这些都由 使用模拟的特殊测试工具 （Automate Tests for Analog） 进行自动化测试 系统故障。 当然，即使进行了所有这些测试，仍然存在错误。 但与一些类似的项目（尤其是商业竞争对手）不同的是 SQLite 对所有错误都开诚布公，并提供 [错误列表](https://sqlite.org/src/rptview?rn=1)和代码更改的每分钟[年表 ](https://sqlite.org/src/timeline)。

The SQLite code base is supported by an [international team](https://www.sqlite.org/crew.html) of developers who work on SQLite full-time. The developers continue to expand the capabilities of SQLite and enhance its reliability and performance while maintaining backwards compatibility with the  [published interface spec](https://www.sqlite.org/c3ref/intro.html), [SQL syntax](https://www.sqlite.org/lang.html), and database [file format](https://www.sqlite.org/fileformat2.html). The source code is absolutely free to anybody who wants it, but [professional support](https://www.sqlite.org/prosupport.html) is also available.
SQLite 代码库由 [致力于](https://www.sqlite.org/crew.html) SQLite 全职。 开发人员不断扩展 SQLite 的功能 并提高其可靠性和性能，同时保持 向后兼容 [已发布的接口规范 ](https://www.sqlite.org/c3ref/intro.html)， [SQL 语法](https://www.sqlite.org/lang.html)和数据库[文件格式 ](https://www.sqlite.org/fileformat2.html)。源代码对任何需要它的人都是完全免费的，但也提供[专业支持 ](https://www.sqlite.org/prosupport.html)。

The SQLite project was started on  [2000-05-09](https://sqlite.org/src/timeline?c=2000-05-29+14:26:00). The future is always hard to predict, but the intent of the developers is to support SQLite through the year 2050.  Design decisions are made with that objective in mind.
SQLite 项目是在 [2000-05-09](https://sqlite.org/src/timeline?c=2000-05-29+14:26:00). 未来总是难以预测，但开发人员的目标是在 2050 年之前支持 SQLite。设计决策是考虑到该目标的。

We the developers hope that you find SQLite useful and we entreat you to use it well: to make good and beautiful products that are fast, reliable, and simple to use.  Seek forgiveness for yourself as you forgive others.  And just as you have received SQLite for free, so also freely give, paying the debt forward.
我们开发人员希望您发现 SQLite 有用，我们恳请您好好使用它：制作快速、可靠且易于使用的优质产品。像原谅他人一样，为自己寻求宽恕。就像您免费获得 SQLite 一样，也可以免费给予，提前偿还债务。