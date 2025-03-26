# Tracing 服务

[TOC]

## Jaeger Tracing

Jaeger 为分布式系统提供随时可用的跟踪服务。https://www.jaegertracing.io/

Ceph 使用其作为跟踪后端。Ceph uses Jaeger as the tracing backend. 为了使用跟踪，需要部署这些服务。

## 部署

Jaeger 包括 3 项服务：

* Jaeger Agent
* Jaeger Collector
* Jaeger Query

Jaeger 需要一个数据库用于追踪。默认使用 ElasticSearch（版本 6）。

在不使用自己的 ElasticSearch 时，部署 jaeger 跟踪服务：

```bash
ceph orch apply jaeger
```

使用现有的 elasticsearch 集群和现有的 jaeger 查询（部署代理和收集器）部署jaeger服务：

```bash
ceph orch apply jaeger --without-query --es_nodes=ip:port,..
```

## 基本架构和术语

- TRACE跟踪：A trace shows the data/execution path through a system.跟踪显示通过系统的数据/执行路径。
- SPAN: A single unit of a trace. A data structure that stores information such as the operation name, timestamps, and the ordering within a trace.跨度：轨迹的单个单位。一种数据结构，用于存储操作名称、时间戳和跟踪中的顺序等信息。
- JAEGER CLIENT: Language-specific implementations of the OpenTracing API.JAEGER CLIENT：开放跟踪API的特定语言实现。
- JAEGER AGENT: A daemon that listens for spans sent over User Datagram Protocol. The agent is meant to be placed on the same host as the instrumented application. (The Jaeger agent acts like a sidecar listener.)JAEGER AGENT：一个监听通过用户数据报协议发送的跨度的守护进程。代理应与插入指令的应用程序放置在同一主机上。（Jaeger经纪人的行为就像一个侧面的听众。）
- JAEGER COLLECTOR: A daemon that receives spans sent by the Jaeger agent. The Jaeger collector then stitches the spans together to form a trace. (A databse can be enabled to persist a database for these traces).JAEGER COLLECTOR：接收JAEGER代理发送的跨度的守护进程。然后，Jaeger收集器将跨度缝合在一起，形成一条轨迹。（可以启用数据库来持久化这些跟踪的数据库）。
- JAEGER QUERY AND CONSOLE FRONTEND: The UI-based frontend that presents reports of the jaeger traces. 可访问 http://<jaeger frontend host>:16686 。JAEGER QUERY AND CONSOLE FRONTEND：基于UI的前端，显示JAEGER跟踪报告。

## JAEGER DEPLOYMENT[](https://docs.ceph.com/en/latest/jaegertracing/#jaeger-deployment)

Jaeger can be deployed using cephadm, and Jaeger can be deployed manually.

Refer to one of the following:

[Cephadm Jaeger Services Deployment](https://docs.ceph.com/en/latest/cephadm/services/tracing/)

[Jaeger Deployment](https://www.jaegertracing.io/docs/1.25/deployment/)

[Jaeger Performance Tuning](https://www.jaegertracing.io/docs/1.25/performance-tuning/)

### Important Notes:[](https://docs.ceph.com/en/latest/jaegertracing/#important-notes)

- The Jaeger agent must be running on each host (and not running in all-in-one mode). This is because spans are sent to the local Jaeger agent. Spans of hosts that do not have active Jaeger agents will be lost.
- Ceph tracers are configured to send tracers to agents that listen to port 6799. Use the option “--processor.jaeger-compact.server-host-port=6799” for manual Jaeger deployments.

## HOW TO ENABLE TRACING IN CEPH[](https://docs.ceph.com/en/latest/jaegertracing/#how-to-enable-tracing-in-ceph)

Tracing in Ceph is disabled by default.

Tracing can be enabled globally, and tracing can also be enabled separately for each entity (for example, for rgw).

Enable tracing globally:

```
ceph config set global jaeger_tracing_enable true
```

Enable tracing for each entity:

```
ceph config set <entity> jaeger_tracing_enable true
```

## TRACES IN RGW[](https://docs.ceph.com/en/latest/jaegertracing/#traces-in-rgw)

Traces run on RGW can be found under the Service rgw in the Jaeger Frontend.

### REQUESTS[](https://docs.ceph.com/en/latest/jaegertracing/#requests)

Every user request is traced. Each trace contains tags for Operation name, User id, Object name and Bucket name.

There is also an Upload id tag for Multipart upload operations.

The names of request traces have the following format: <command> <transaction id>.

### MULTIPART UPLOAD[](https://docs.ceph.com/en/latest/jaegertracing/#multipart-upload)

There is a kind of trace that consists of a span for each request made by a multipart upload, and it includes all Put Object requests.

The names of multipart traces have the following format: multipart_upload <upload id>.

rgw service in Jaeger Frontend:

[![../_images/rgw_jaeger.png](https://docs.ceph.com/en/latest/_images/rgw_jaeger.png)](https://docs.ceph.com/en/latest/_images/rgw_jaeger.png)

osd service in Jaeger Frontend:

[![../_images/osd_jaeger.png](https://docs.ceph.com/en/latest/_images/osd_jaeger.png)](https://docs.ceph.com/en/latest/_images/osd_jaeger.png)