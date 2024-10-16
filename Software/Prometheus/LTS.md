# 长期支持

[TOC]

Prometheus LTS 是 Prometheus 的选定版本，可以在较长时间内接收错误修复。

每 6 周，一个新的 Prometheus 次要版本周期开始。在这 6 周之后，次要版本通常不再接受错误修复。如果用户在小版本中受到错误的影响，他们通常需要升级到最新的 Prometheus 版本。

升级 Prometheus 应该很简单，这要归功于我们的 API 稳定性保证。然而，有一种风险是，新的功能和增强也可能带来倒退，需要再次升级。

Prometheus LTS 只接受 bug 、安全性和文档修复，但时间窗口为一年。构建工具链也将保持最新。This allows companies that rely on Prometheus to limit the upgrade risks while still having a Prometheus server maintained by the community.这使得依赖 Prometheus 的公司能够限制升级风险，同时仍然由社区维护 Prometheus 服务器。

## LTS 版本列表

| Release         | Date       | End of support |
| --------------- | ---------- | -------------- |
| Prometheus 2.37 | 2022-07-14 | 2023-07-31     |
| Prometheus 2.45 | 2023-06-23 | 2024-07-31     |
| Prometheus 2.53 | 2024-06-16 | 2025-07-31     |

## LTS 支持的局限性

某些功能不包括在 LTS 支持中：

- Things listed as unstable in our [API stability guarantees](https://prometheus.io/docs/prometheus/latest/stability/).在我们的 API 稳定性保证中被列为不稳定的东西。
- [Experimental features](https://prometheus.io/docs/prometheus/latest/feature_flags/).实验性功能。
- OpenBSD 支持。