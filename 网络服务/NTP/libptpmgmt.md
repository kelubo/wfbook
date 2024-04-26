#### Welcome to The libptpmgmt Project 欢迎来到 libptpmgmt 项目



The libptpmgmt Project provides a library to communicate with [LinuxPTP](https://linuxptp.nwtime.org) using IEEE 1558 management messages over a network. It supports `get`, `set`, and `command` of all management TLVs that are described in [IEEE 1588-2019](https://standards.ieee.org/ieee/1588/6825/). In addition, the library supports LinuxPTP specific implementation management TLVs.
libptpmgmt 项目提供了一个库，用于通过网络使用 IEEE 1558 管理消息与 LinuxPTP 进行通信。它支持 `get` `set` 、 和 `command` IEEE 1588-2019 中描述的所有管理 TLV。此外，该库还支持特定于 LinuxPTP 的实现管理 TLV。

The library is written in C++ using a data-oriented model and supports  native scripting using SWIG wrappers for Python, ruby, Lua, Perl, PHP,  and TCL. libptpmgmt is published under the LGPL 3.0 license.
该库使用面向数据的模型用 C++ 编写，并支持使用 Python、ruby、Lua、Perl、PHP 和 TCL 的 SWIG 包装器编写本机脚本。libptpmgmt 在 LGPL 3.0 许可下发布。