# Tcl/Tk

[TOC]

## 概述

`Tcl` 是一个动态编程语言，`Tk` 是一个图形用户界面(GUI)工具包。它们为开发带有图形界面的跨平台应用程序提供了强大而易用的平台。作为动态编程语言，"Tcl" 为编写脚本提供了简单而灵活的语法。`tcl` 软件包为此语言和 C 库提供了解释器。您可以使用 `Tk` 作为 GUI 工具包，其为创建图形界面提供一组工具和小部件。您可以使用各种用户界面元素，如按钮、菜单、对话框、文本框及画布来画图。`Tk` 是许多动态编程语言的 GUI。 		

## 安装 Tcl

- 要安装 `Tcl`，请使用： 				

  ```bash
  dnf install tcl
  ```

- 要验证系统上是否安装了 Tcl 版本，请运行解释器 `tclsh` 。 				

  ```bash
  tclsh
  ```

  在解释器中运行这个命令：

  ```tcl
  % info patchlevel
  8.6
  ```

  可以通过按 Ctrl+C 退出解释器界面 				

## 安装 Tk

- 要安装 `Tk`，请使用： 				

  ```bash
  dnf install tk
  ```

- 要验证系统上是否安装了 `Tk` 版本，请运行 window shell `wish` 。需要运行一个图形显示。 				

  ```bash
  wish
  ```

  在 shell 中运行这个命令：

  ```bash
  % puts $tk_version
  8.6
  ```

  可以通过按 Ctrl+C 退出解释器界面 				