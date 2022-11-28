# Tracing 服务

[TOC]

## Jaeger Tracing

Ceph 使用 Jaeger 作为跟踪后端。Ceph uses Jaeger as the tracing backend. 为了使用跟踪，我们需要部署这些服务。in order to use tracing

有关 ceph 中 tracing 的更多详细信息：

[Ceph Tracing documentation](https://docs.ceph.com/en/latest/jaegertracing/#jaeger-distributed-tracing/)

## 部署

Jaeger 服务包括 3 项服务：

* Jaeger Agent
* Jaeger Collector
* Jaeger Query

Jaeger requires a database for the traces. we use ElasticSearch (version 6) by default.Jaeger需要一个追踪数据库。我们默认使用弹性搜索（版本6）。

To deploy jaeger tracing service, when not using your own ElasticSearch:

在不使用自己的Elastic Search时部署jaeger跟踪服务：

1. Deploy jaeger services, with a new elasticsearch container:

   ```bash
   ceph orch apply jaeger
   ```

2. Deploy jaeger services, with existing elasticsearch cluster and existing jaeger query (deploy agents and collectors):

   ```bash
   ceph orch apply jaeger --without-query --es_nodes=ip:port,..
   ```