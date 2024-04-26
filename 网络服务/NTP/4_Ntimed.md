# Ntimed 项目

**NEW!** Now you can report bugs and request enhancements and new features using the Network Time Foundation Jira. Anyone can browse the [ntimed issue database](https://jira.ntfo.org/projects/NTIM/issues) without creating an account. Users who wish to open tickets can create a free account and log in to do so.
新增功能！现在，您可以使用 Network Time Foundation Jira 报告错误并请求增强功能和新功能。任何人都可以在不创建帐户的情况下浏览 ntimed 问题数据库。希望开票的用户可以创建一个免费帐户并登录。

In the future, your NTF Jira account will also give you access to bug/issue reporting for other projects hosted by NTF.
将来，您的 NTF Jira 帐户还将允许您访问 NTF 托管的其他项目的错误/问题报告。

------

Ntimed is a tightly-focused NTP implementation designed for high security and  high performance. The NTP Project’s software is most likely the longest-running software project on the Internet. It was designed as a  Reference Implementation, so it does as much as it can to make sure that the complete NTP Protocol specification can be demonstrably proven to be  portable and robust. This is a good and necessary thing. And while the  codebase has been wildly successful and has had an enviable security record, it  is very big and has had some rare problems (which have been made worse  by the fact that its codebase is so very widely used) and there are an  increasing number of cases where a highly-focused tool is preferred.  Enter the Ntimed Project.
Ntimed 是一种高度集中的 NTP  实现，旨在实现高安全性和高性能。NTP项目的软件很可能是互联网上运行时间最长的软件项目。它被设计为参考实现，因此它尽可能地确保完整的NTP协议规范可以被证明是可移植和健壮的。这是一件好事，也是一件必要的事情。虽然代码库取得了巨大的成功，并拥有令人羡慕的安全记录，但它非常庞大，并且存在一些罕见的问题（由于其代码库被广泛使用，这些问题变得更糟），并且越来越多的情况是首选高度集中的工具。输入 Ntimed 项目。

The Ntimed Project is the result of decades of Poul-Henning Kamp’s  experience as an NTP Project Developer, a “time nut”, and his vast  experience with computer network timekeeping.
Ntimed 项目是 Poul-Henning Kamp 数十年来作为 NTP 项目开发人员、“时间狂人”的经验以及他在计算机网络计时方面的丰富经验的结果。

The Ntimed Project is comprised of three packages:
Ntimed 项目由三个包组成：

- `ntimed-client` is run on “leaf nodes”. Its job is to talk to upstream NTP servers and adjust the local clock. The preview release of `ntimed-client` happened in December of 2014, and the first release of the code happened in April of 2015.
   `ntimed-client` 在“叶节点”上运行。它的工作是与上游NTP服务器通信并调整本地时钟。预览版 `ntimed-client` 发布于 2014 年 12 月，代码的第一个版本发布于 2015 年 4 月。
- `ntimed-slave` is run in the “middle layers”. Its job is to query upstream servers, adjust the local clock, and to provide time to downstream clients. This project was 30% complete as of April 2015. The preview release for `ntimed-slave` is currently unscheduled, awaiting funding.
   `ntimed-slave` 在“中间层”运行。它的工作是查询上游服务器，调整本地时钟，并为下游客户端提供时间。截至 2015 年 4 月，该项目已完成 30%。的 `ntimed-slave` 预览版目前未计划，正在等待资金。
- `ntimed-master` runs at the top layer. Its job is to talk to reference clocks and to provide time to clients and slaves. The preview release of `ntimed-master` is currently unscheduled, awaiting funding.
   `ntimed-master` 在顶层运行。它的工作是与参考时钟通信，并为客户端和从属设备提供时间。的 `ntimed-master` 预览版目前未计划，正在等待资金。

At some point in the future the ability to use PTP will likely enter the picture.