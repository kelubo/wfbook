# Management API

- [Health check ](https://prometheus.io/docs/prometheus/latest/management_api/#health-check)
- [Readiness check ](https://prometheus.io/docs/prometheus/latest/management_api/#readiness-check)
- [Reload ](https://prometheus.io/docs/prometheus/latest/management_api/#reload)
- [Quit ](https://prometheus.io/docs/prometheus/latest/management_api/#quit)

Prometheus provides a set of management APIs to facilitate automation and integration.

### Health check

```
GET /-/healthy
HEAD /-/healthy
```

This endpoint always returns 200 and should be used to check Prometheus health.

### Readiness check

```
GET /-/ready
HEAD /-/ready
```

This endpoint returns 200 when Prometheus is ready to serve traffic (i.e. respond to queries).

### Reload

```
PUT  /-/reload
POST /-/reload
```

This endpoint triggers a reload of the Prometheus configuration and  rule files. It's disabled by default and can be enabled via the `--web.enable-lifecycle` flag.

Alternatively, a configuration reload can be triggered by sending a `SIGHUP` to the Prometheus process.

### Quit

```
PUT  /-/quit
POST /-/quit
```

This endpoint triggers a graceful shutdown of Prometheus. It's disabled by default and can be enabled via the `--web.enable-lifecycle` flag.

Alternatively, a graceful shutdown can be triggered by sending a `SIGTERM` to the Prometheus process.

管理API

    健康检查
    准备就绪检查
    重新载入
    结束

Prometheus提供了一组管理API来促进自动化和集成。
健康检查

GET /-/健康
HEAD /-/健康

这个端点总是返回200，应该用来检查Prometheus的健康状况。
准备就绪检查

GET /-/ready
HEAD /-/就绪

当Prometheus准备好为流量提供服务时，此端点返回200（即回答查询）。
重新载入

PUT /-/reload
POST /-/reload

此端点触发重新加载Prometheus配置和规则文件。默认情况下它是禁用的，可以通过--web.enable-lifecycle标志启用。

或者，可以通过向Prometheus进程发送SIGHUP来触发配置重新加载。
结束

PUT /-/quit
POST /-/quit

这个端点触发Prometheus的正常关闭。默认情况下它是禁用的，可以通过--web.enable-lifecycle标志启用。

或者，可以通过向Prometheus进程发送SIGTERM来触发优雅关闭。