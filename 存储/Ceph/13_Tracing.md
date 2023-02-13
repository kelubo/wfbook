# Tracing 服务

[TOC]

## Jaeger Tracing

Ceph 使用 Jaeger 作为跟踪后端。Ceph uses Jaeger as the tracing backend. 为了使用跟踪，需要部署这些服务。

## 部署

Jaeger 服务包括 3 项服务：

* Jaeger Agent
* Jaeger Collector
* Jaeger Query

Jaeger 需要一个数据库用于追踪。我们默认使用 ElasticSearch（版本 6）。

在不使用自己的 ElasticSearch 时，部署 jaeger 跟踪服务：

```bash
ceph orch apply jaeger
```

使用现有的 elasticsearch 集群和现有的 jaeger 查询（部署代理和收集器）部署jaeger服务：

```bash
ceph orch apply jaeger --without-query --es_nodes=ip:port,..
```