# R

[TOC]

## 概述

R is a free software environment for statistical computing and graphics. R 是用于统计计算和图形的自由软件环境。

它是一个 [GNU 项目 ](http://www.gnu.org)，类似于由 John Chambers 和同事在 Bell 实验室（以前的 AT&T，现在的 Lucent Technologies）开发的 S  语言和环境。R 可以被认为是 S 的不同实现。虽然有一些重要的区别，但是为 S 编写的许多代码在 R 下运行时没有改变。

R provides a wide variety of statistical (linear and nonlinear modelling, classical statistical tests, time-series analysis, classification, clustering, …) and graphical techniques, and is highly extensible. The S language is often the vehicle of choice for research in statistical methodology, and R provides an Open Source route to participation in that activity.
R 提供了各种各样的统计（线性和非线性建模，经典统计测试，时间序列分析，分类，聚类等）和图形技术，并且具有高度的可扩展性。S 语言通常是统计方法研究的首选工具，而 R 提供了参与该活动的开源途径。 

One of R’s strengths is the ease with which well-designed publication-quality plots can be produced, including mathematical symbols and formulae where needed. Great care has been taken over the defaults for the minor design choices in graphics, but the user retains full control.
R 的优势之一是可以轻松地生成精心设计的出版质量图，包括需要的数学符号和公式。在图形设计中，对于次要设计选择的默认设置已经非常小心，但用户保留完全的控制权。 

R 是在[自由软件基金会](http://www.gnu.org)的 [GNU 通用公共许可证](https://www.r-project.org/COPYING)条款下以源代码形式提供的自由软件。它可以在各种 UNIX 平台和类似系统（包括 FreeBSD 和 Linux）、Windows 和 MacOS 上编译和运行。

## R 环境 

R 是一套集成的软件设施，用于数据处理，计算和图形显示。它包括 

- 有效的数据处理和存储设施， 
- 一套运算符，用于计算数组，特别是矩阵， 
- a large, coherent, integrated collection of intermediate tools for data analysis,
  用于数据分析的大量、连贯、综合的中间工具集， 
- graphical facilities for data analysis and display either on-screen or on hardcopy, and
  用于数据分析的图形工具，并在屏幕上或硬拷贝上显示，以及 
- a well-developed, simple and effective programming language which includes conditionals, loops, user-defined recursive functions and input and output facilities.
  一种开发良好、简单有效的编程语言，包括条件、循环、用户定义的递归函数以及输入和输出设施。 

The term “environment” is intended to characterize it as a fully planned and coherent system, rather than an incremental accretion of very specific and inflexible tools, as is frequently the case with other data analysis software.
“环境”一词旨在将其描述为一个完全规划和连贯的系统，而不是像其他数据分析软件那样，由非常具体和不灵活的工具逐步增加。 

Much of the system is itself written in the R dialect of S, which makes it easy for users to follow the algorithmic choices made.  

R 和 S 一样，是围绕真正的计算机语言设计的，它允许用户通过定义新函数来添加额外的功能。系统的大部分内容本身是用 S 的 R  方言编写的，这使得用户很容易遵循算法的选择。对于计算密集型任务，可以在运行时链接和调用 C、C++ 和 Fortran 代码。高级用户可以编写 C 代码来直接操作 R 对象。 

许多用户认为 R 是一个统计系统。我们更愿意把它看作是一个实施统计技术的环境。R 可以通过*包* （很容易）扩展。R 发行版提供了大约八个软件包，还有更多的软件包可以通过 CRAN 家族的互联网网站获得，涵盖了非常广泛的现代统计数据。

R has its own LaTeX-like documentation format, which is used to supply comprehensive documentation, both on-line in a number of formats and in hardcopy.
R 有自己的类似 LaTeX 的文档格式，用于提供全面的文档，包括在线的多种格式和硬拷贝。 

## 