# PostgreSQL简史 

## 伯克利的POSTGRES项目

由Michael Stonebraker教授领导的POSTGRES项目是由防务高级研究项目局（DARPA）、陆军研究办公室（ARO）、国家科学基金（NSF） 以及 ESL, Inc 共同赞助的。 POSTGRES的实现始于 1986 年。该系统最初的概念详见[[ston86\]](http://www.postgres.cn/docs/12/biblio.html#STON86) 。 最初的数据模型定义见[[rowe87\]](http://www.postgres.cn/docs/12/biblio.html#ROWE87)。当时的规则系统设计在[[ston87a\]](http://www.postgres.cn/docs/12/biblio.html#STON87A)里描述。存储管理器的理论基础和体系结构在[[ston87b\]](http://www.postgres.cn/docs/12/biblio.html#STON87B)里有详细描述。  

第一个“演示性”系统在 1987 年便可使用了， 并且在 1988 年的ACM-SIGMOD大会上展出。在 1989 年6月发布了版本 1（见[[ston90a\]](http://www.postgres.cn/docs/12/biblio.html#STON90A)）给一些外部的用户使用。 为了回应用户对第一个规则系统（[[ston89\]](http://www.postgres.cn/docs/12/biblio.html#STON89)）的批评，规则系统被重新设计了（[[ston90b\]](http://www.postgres.cn/docs/12/biblio.html#STON90B)），在1990年6月发布了使用新规则系统的版本 2。 版本 3 在1991年出现，增加了多存储管理器的支持， 并且改进了查询执行器、重写了规则系统。直到Postgres95发布前的后续版本大多把工作都集中在移植性和可靠性上。  

POSTGRES已经被用于实现很多不同的研究和生产应用。这些应用包括： 一个财务数据分析系统、一个喷气引擎性能监控软件包、一个小行星跟踪数据库、一个医疗信息数据库和一些地理信息系统。POSTGRES还被许多大学用于教学用途。最后，Illustra Information Technologies（后来并入[Informix](https://www.ibm.com/analytics/informix)， 而[Informix](https://www.ibm.com/analytics/informix)现在被[IBM](https://www.ibm.com/)所拥有） 拿到代码并使之商业化。在 1992 年末POSTGRES成为[Sequoia 2000科学计算项目](http://meteora.ucsd.edu/s2k/s2k_home.html)的主要数据管理器。  

在 1993 年间，外部用户社区的数量几乎翻番。随着用户的增加， 用于源代码维护的时间日益增加并占用了太多本应该用于数据库研究的时间，为了减少支持的负担，伯克利的POSTGRES项目在版本 4.2 时正式终止。  

## Postgres95

在 1994 年，Andrew Yu 和 Jolly Chen 向POSTGRES中增加了 SQL 语言的解释器。并随后用新名字Postgres95将源代码发布到互联网上供大家使用， 成为最初POSTGRES伯克利代码的开源继承者。  

Postgres95的源代码都是完全的 ANSI C，而且代码量减少了25%。许多内部修改提高了性能和可维护性。Postgres95的1.0.x版本在进行 Wisconsin Benchmark 测试时大概比POSTGRES的版本4.2 快 30-50%。除了修正了一些错误，下面的是一些主要提升：    

- 原来的查询语言 PostQUEL 被SQL取代（在服务器端实现）。接口库[libpq](http://www.postgres.cn/docs/12/libpq.html)被按照PostQUEL命名。在PostgreSQL之前还不支持子查询（见下文），但它们可以在Postgres95中由用户定义的SQL函数模拟。聚集函数被重新实现。同时还增加了对`GROUP BY` 查询子句的支持。     
- 新增加了一个利用GNU的Readline进行交互 SQL 查询的程序（psql）。这个程序很大程度上取代了老的monitor程序。     
- 增加了新的前端库（`libpgtcl`）， 用以支持基于Tcl的客户端。一个样本 shell（`pgtclsh`），提供了新的 Tcl 命令用于Tcl程序和Postgres95服务器之间的交互。     
- 彻底重写了大对象的接口。保留了将大对象倒转（Inversion ）作为存储大对象的唯一机制（去掉了倒转（Inversion ）文件系统）。     
- 去掉了实例级的规则系统。但规则仍然以重写规则的形式存在。     
- 在发布的源码中增加了一个介绍SQL和Postgres95特性的简短教程。     
- 用GNU的make（取代了BSD的make）来编译。Postgres95可以使用不打补丁的GCC编译（修正了双精度数据对齐问题）。     

## PostgreSQL

到了 1996 年， 很明显“Postgres95”这个名字已经跟不上时代了。于是选择了一个新名字PostgreSQL来反映与最初的POSTGRES和最新的具有SQL能力的版本之间的关系。同时版本号也从 6.0 开始， 将版本号放回到最初由伯克利POSTGRES项目开始的序列中。  

很多人会因为传统或者更容易发音而继续用“Postgres”来指代PostgreSQL（现在很少用全大写字母）。这种用法也被广泛接受为一种昵称或别名。  

Postgres95的开发重点放在标识和理解后端代码的现有问题上。PostgreSQL的开发重点则转到了一些有争议的特性和功能上面，当然各个方面的工作同时都在进行。
