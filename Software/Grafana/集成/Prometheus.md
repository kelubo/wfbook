# Prometheus

[TOC]

## 概述

Prometheus 是一个开源监控系统，Grafana 为其提供开箱即用的支持。

## 为 Grafana 配置 Prometheus



## 在 Grafana Explore 视图中检查 Prometheus 指标

In your Grafana instance, go to the [Explore](https://grafana.com/docs/grafana/latest/explore/) view and build queries to experiment with the metrics you want to  monitor. Here you can also debug issues related to collecting metrics  from Prometheus.
在您的 Grafana 实例中，转到 Explore （[浏览](https://grafana.com/docs/grafana/latest/explore/)） 视图并构建查询以试验要监控的指标。在这里，您还可以调试与从 Prometheus 收集指标相关的问题。

## 开始构建仪表板

Now that you have a curated list of queries, create [dashboards](https://grafana.com/docs/grafana/latest/dashboards/) to render system metrics monitored by Prometheus. When you install  Prometheus and node_exporter or windows_exporter, you will find  recommended dashboards for use.
现在，您已拥有精选的查询列表，请创建[控制面板](https://grafana.com/docs/grafana/latest/dashboards/)来呈现 Prometheus 监控的系统指标。当您安装 Prometheus 和 node_exporter 或 windows_exporter 时，您将找到推荐使用的控制面板。

The following image shows a dashboard with three panels showing some system metrics.
下图显示了一个控制面板，其中包含三个面板，其中显示了一些系统指标。

![Prometheus dashboards](https://grafana.com/static/img/docs/getting-started/simple_grafana_prom_dashboard.png)

