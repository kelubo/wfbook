# PostgreSQL简史

[TOC]

## Ingres

BSD 于 1977 年开始 Ingres 项目。这个项目是 Michael  Stonebraker 教授领导的。在 1982 年，Michael Stonebraker 离开伯克利商业化了 Ingres，成为  Relational Technologies 公司的一个产品，后来 Relational Tecchnologies 被 Computer  Associates（CA）收购。Ingres 是一个非关系型的数据库（数据关系需要由用户有意识地维护），在 1985 年，Michael  Stonebraker 回到伯克利开始一个后-Ingres（post-Ingres）的项目，目的是解决 Ingres 中，同时也是 1980  年代的数据库系统中的主要问题：数据关系维护的问题。这就是 Postgres 的开端。

而随后 Michael Stonebraker 教授再次去创业，成立 Illustra 公司提供  Postgres 的商业支持，后来 Illustra 在 1997 年被 Informix 收购，而 Michael 教授成为 Informix 的 CTO；再后来 Informix 在 2001 年被 IBM 收购。

## 伯克利的POSTGRES项目

从1986年开始，Michael Stonebraker 教授发表了一系列论文，探讨了新的数据库的结构设计和扩展设计，然后在  1988 年有了一个原型设计。

由Michael Stonebraker教授领导的POSTGRES项目是由防务高级研究项目局（DARPA）、陆军研究办公室（ARO）、国家科学基金（NSF） 以及 ESL, Inc 共同赞助的。 该系统最初的概念详见[[ston86\]](http://www.postgres.cn/docs/12/biblio.html#STON86) 。 最初的数据模型定义见[[rowe87\]](http://www.postgres.cn/docs/12/biblio.html#ROWE87)。当时的规则系统设计在[[ston87a\]](http://www.postgres.cn/docs/12/biblio.html#STON87A)里描述。存储管理器的理论基础和体系结构在[[ston87b\]](http://www.postgres.cn/docs/12/biblio.html#STON87B)里有详细描述。  

第一个“演示性”系统在 1987 年便可使用了， 并且在 1988 年的ACM-SIGMOD大会上展出。在 1989 年6月发布了版本 1（见[[ston90a\]](http://www.postgres.cn/docs/12/biblio.html#STON90A)）给一些外部的用户使用。 为了回应用户对第一个规则系统（[[ston89\]](http://www.postgres.cn/docs/12/biblio.html#STON89)）的批评，规则系统被重新设计了（[[ston90b\]](http://www.postgres.cn/docs/12/biblio.html#STON90B)），在1990年6月发布了使用新规则系统的版本 2。 版本 3 在1991年出现，增加了多存储管理器的支持， 并且改进了查询执行器、重写了规则系统。直到Postgres95发布前的后续版本大多把工作都集中在移植性和可靠性上。  

POSTGRES已经被用于实现很多不同的研究和生产应用。这些应用包括： 一个财务数据分析系统、一个喷气引擎性能监控软件包、一个小行星跟踪数据库、一个医疗信息数据库和一些地理信息系统。POSTGRES还被许多大学用于教学用途。最后，Illustra Information Technologies（后来并入[Informix](https://www.ibm.com/analytics/informix)， 而[Informix](https://www.ibm.com/analytics/informix)现在被[IBM](https://www.ibm.com/)所拥有） 拿到代码并使之商业化。在 1992 年末POSTGRES成为[Sequoia 2000科学计算项目](http://meteora.ucsd.edu/s2k/s2k_home.html)的主要数据管理器。  

在 1993 年间，外部用户社区的数量几乎翻番。随着用户的增加， 用于源代码维护的时间日益增加并占用了太多本应该用于数据库研究的时间，为了减少支持的负担，伯克利的POSTGRES项目在版本 4.2 时正式终止。  

## Postgres95

在 1994 年，两名伯克利的研究生（Andrew Yu 和 Jolly Chen）在做研究生课题的时候，向POSTGRES中增加了 SQL 语言的解释器。并随后用新名字Postgres95将源代码发布到互联网上供大家使用， 成为最初POSTGRES伯克利代码的开源继承者。  这里需要解释一下：E.F Code  的关系模型提出之后，对这个模型的实现有非常多的变种，相互之间并不兼容，比如Postgres用的是 QUEL/Postquel 语言，而 SQL  自身作为语言，一直到1992年才形成真正的国际标准（还是草案），当时称为 SQL2，但是人们常称为 SQL92。两位研究生是来自中国香港的  Andrew Yu 和 Jolly Chen 用 bison 和 flex 工具的组合，把Postgres 的Postquel查询语言替换成了  SQL92，然后将Postgres改名为 Postgres95。

Postgres95的源代码都是完全的 ANSI C，而且代码量减少了25%。许多内部修改提高了性能和可维护性。Postgres95的1.0.x版本在进行 Wisconsin Benchmark 测试时大概比POSTGRES的版本4.2 快 30-50%。除了修正了一些错误，下面的是一些主要提升：    

- 原来的查询语言 PostQUEL 被SQL取代（在服务器端实现）。接口库[libpq](http://www.postgres.cn/docs/12/libpq.html)被按照PostQUEL命名。在PostgreSQL之前还不支持子查询（见下文），但它们可以在Postgres95中由用户定义的SQL函数模拟。聚集函数被重新实现。同时还增加了对`GROUP BY` 查询子句的支持。     
- 新增加了一个利用GNU的Readline进行交互 SQL 查询的程序（psql）。这个程序很大程度上取代了老的monitor程序。     
- 增加了新的前端库（`libpgtcl`）， 用以支持基于Tcl的客户端。一个样本 shell（`pgtclsh`），提供了新的 Tcl 命令用于Tcl程序和Postgres95服务器之间的交互。     
- 彻底重写了大对象的接口。保留了将大对象倒转（Inversion ）作为存储大对象的唯一机制（去掉了倒转（Inversion ）文件系统）。     
- 去掉了实例级的规则系统。但规则仍然以重写规则的形式存在。     
- 在发布的源码中增加了一个介绍SQL和Postgres95特性的简短教程。     
- 用GNU的make（取代了BSD的make）来编译。Postgres95可以使用不打补丁的GCC编译（修正了双精度数据对齐问题）。     

## PostgreSQL

很多人会因为传统或者更容易发音而继续用“Postgres”来指代PostgreSQL（现在很少用全大写字母）。这种用法也被广泛接受为一种昵称或别名。  

Postgres95的开发重点放在标识和理解后端代码的现有问题上。PostgreSQL的开发重点则转到了一些有争议的特性和功能上面，当然各个方面的工作同时都在进行。

Andrew Yu 和 Jolly Chen 最大的贡献在于，完成了 Postgres95 之后，将其发布到了互联网上。随后的 1996  年，加拿大的 Hub.Org Networking Services的 Marc Fournier（一名 FreeBSD  黑客）提供了第一个非大学的开发服务器平台，然后 Bruce Momjian（美国）和 Vadim B.  Mikheev（俄国）开始修改以及稳定伯克利发布的代码，并于1996年8月发布了第一个开源版本。

随后，这些黑客把项目名称改变为 PostgreSQL，来反映与最初的POSTGRES和最新的具有SQL能力的版本之间的关系，并且把 PostgreSQL 的版本号重新放到了原先 Postgres 项目的顺序中去，从 6.0 开 始（Postgres 本身到4.2，Postgres95 算5.0）。自 1996 年 8  月到现在的 2008 年，到今年北京奥运会开始的时候，PostgreSQL 项目将已经有 12 年的历史，而 Postgres  的年龄也会超过23岁，已经进入成熟的青年期。