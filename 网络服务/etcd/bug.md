# 报告错误

How to file issue reports for the etcd project
如何为 etcd 项目提交问题报告



If any part of the etcd project has bugs or documentation mistakes, please let us know by [opening an issue](https://github.com/etcd-io/etcd/issues/new). We treat bugs and mistakes very seriously and believe no issue is too  small. Before creating a bug report, please check that an issue  reporting the same problem does not already exist.
如果 etcd 项目的任何部分有错误或文档错误，请通过提出问题告诉我们。我们非常认真地对待错误和错误，并相信没有问题太小。在创建错误报告之前，请检查报告相同问题的问题是否尚不存在。

To make the bug report accurate and easy to understand, please try to create bug reports that are:
为了使错误报告准确且易于理解，请尝试创建以下错误报告：

- Specific. Include as much details as possible: which version, what environment,  what configuration, etc. If the bug is related to running the etcd  server, please attach the etcd log (the starting log with etcd  configuration is especially important).
  特定。包括尽可能多的详细信息：哪个版本、什么环境、什么配置等。如果 bug 与运行 etcd 服务器有关，请附上 etcd 日志（带有 etcd 配置的起始日志尤为重要）。
- Reproducible. Include the steps to reproduce the problem. We understand some issues  might be hard to reproduce, please includes the steps that might lead to the problem. If possible, please attach the affected etcd data dir and  stack strace to the bug report.
  重现。包括重现问题的步骤。我们理解某些问题可能难以重现，请包括可能导致问题的步骤。如果可能，请将受影响的 etcd 数据目录和堆栈标记附加到错误报告中。
- Isolated. Please try to isolate and reproduce the bug with minimum dependencies.  It would significantly slow down the speed to fix a bug if too many  dependencies are involved in a bug report. Debugging external systems  that rely on etcd is out of scope, but we are happy to provide guidance  in the right direction or help with using etcd itself.
  孤立。请尝试以最小的依赖性隔离和重现错误。如果错误报告中涉及太多依赖项，则修复错误的速度会大大降低。调试依赖 etcd 的外部系统超出了范围，但我们很乐意提供正确方向的指导或帮助使用 etcd 本身。
- Unique. Do not duplicate existing bug report.
  独特。不要复制现有的错误报告。
- Scoped. One bug per report. Do not follow up with another bug inside one report.
  范围。每个报告一个错误。不要在一个报告中跟进另一个错误。

It may be worthwhile to read [Elika Etemad’s article on filing good bug reports](http://fantasai.inkedblade.net/style/talks/filing-good-bugs/) before creating a bug report.
在创建错误报告之前，阅读 Elika Etemad 关于提交良好错误报告的文章可能是值得的。

We might ask for further information to locate a bug. A duplicated bug report will be closed.
我们可能会要求提供更多信息以查找错误。将关闭重复的错误报告。

## Frequently asked questions 常见问题

### How to get a stack trace 如何获取堆栈跟踪

```bash
$ kill -QUIT $PID
```

### How to get etcd version 如何获取 etcd 版本

```bash
$ etcd --version
```

### How to get etcd configuration and log when it runs as systemd service ‘etcd2.service’ 如何获取 etcd 配置并在它作为 systemd 服务“etcd2.service”运行时记录

```bash
$ sudo systemctl cat etcd2
$ sudo journalctl -u etcd2
```

Due to an upstream systemd bug, journald may miss the last few log lines  when its processes exit. If journalctl says etcd stopped without fatal  or panic message, try `sudo journalctl -f -t etcd2` to get full log.
由于上游 systemd 错误，journald 在其进程退出时可能会错过最后几行日志。如果 journalctl 说 etcd 停止而没有致命或恐慌消息，请尝试 `sudo journalctl -f -t etcd2` 获取完整日志。