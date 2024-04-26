#### Welcome to The Khronos Project 欢迎来到 Khronos 项目



The Khronos Project aims to provide an extension to the [NTPv4](https://www.ntp.org/) client, designed to achieve:
Khronos 项目旨在为 NTPv4 客户端提供扩展，旨在实现：

- Provable security in the face of fairly powerful MitM attacks with negligible probability for successful timeshifting attacks.
  面对相当强大的 MitM 攻击，可证明的安全性，成功的时移攻击概率可以忽略不计。
- Backwards-compatibility so that there are no changes to NTP servers and limited software  changes to the NTP client's system process.
  向后兼容性，因此不会对 NTP 服务器进行更改，并且对 NTP 客户端的系统进程进行有限的软件更改。
- Low computational and communication overhead with few queries to NTP servers.
  计算和通信开销低，对 NTP 服务器的查询很少。

Since Khronos does not affect the wire protocol, the Khronos mechanism is applicable to any current or future time protocol.
由于 Khronos 不影响有线协议，因此 Khronos 机制适用于任何当前或未来的时间协议。

Khronos is described by [RFC 9523](https://datatracker.ietf.org/doc/rfc9523/). A Python and a C implementation are [available](https://github.com/nwtime/khronos).
Khronos 由 RFC 9523 描述。可以使用 Python 和 C 实现。