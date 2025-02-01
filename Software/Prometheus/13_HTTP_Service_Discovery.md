# Writing HTTP Service Discovery

[TOC]

Prometheus provides a generic [HTTP Service Discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#http_sd_config), that enables it to discover targets over an HTTP endpoint.

The HTTP Service Discovery is complimentary to the supported service discovery mechanisms, and is an alternative to [File-based Service Discovery](https://prometheus.io/docs/guides/file-sd/#use-file-based-service-discovery-to-discover-scrape-targets).

## Comparison between File-Based SD and HTTP SD

Here is a table comparing our two generic Service Discovery implementations.

| Item             | File SD                    | HTTP SD                                       |
| ---------------- | -------------------------- | --------------------------------------------- |
| Event Based      | Yes, via inotify           | No                                            |
| Update frequency | Instant, thanks to inotify | Following refresh_interval                    |
| Format           | Yaml or JSON               | JSON                                          |
| Transport        | Local file                 | HTTP/HTTPS                                    |
| Security         | File-Based security        | TLS, Basic auth, Authorization header, OAuth2 |

## Requirements of HTTP SD endpoints

If you implement an HTTP SD endpoint, here are a few requirements you should be aware of.

The response is consumed as is, unmodified. On each refresh interval (default: 1 minute), Prometheus will perform a GET request to the HTTP SD endpoint. The GET request contains a `X-Prometheus-Refresh-Interval-Seconds` HTTP header with the refresh interval.

The SD endpoint must answer with an HTTP 200 response, with the HTTP Header `Content-Type: application/json`. The answer must be UTF-8 formatted. If no targets should be transmitted, HTTP 200 must also be emitted, with an empty list `[]`. Target lists are unordered.

Prometheus caches target lists. If an error occurs while fetching an updated targets list, Prometheus keeps using the current targets list. The targets list is not saved across restart. The `prometheus_sd_http_failures_total` counter  metric tracks the number of refresh failures.

The whole list of targets must be returned on every scrape. There is no support for incremental updates. A Prometheus instance does not send its hostname and it is not possible for a SD endpoint to know if the SD requests is the first one after a restart or not.

The URL to the HTTP SD is not considered secret. The authentication and any API keys should be passed with the appropriate authentication mechanisms. Prometheus supports TLS authentication, basic authentication, OAuth2, and authorization headers.

编写HTTP服务发现

    基于文件的SD与HTTP SD的比较
    HTTP SD端点的要求
    HTTP_SD格式

Prometheus提供了一个通用的HTTP服务发现，使其能够通过HTTP端点发现目标。

HTTP服务发现是对支持的服务发现机制的补充，是基于文件的服务发现的替代方案。
基于文件的SD与HTTP SD的比较

下面的表格比较了我们的两个通用服务发现实现。
项目名称 	文件SD 	HTTP SD
基于事件 	是的，通过inotify 	不想
更新频率 	即时，感谢inotify 	在refresh_interval之后
格式设置 	Yaml或JSON 	JSON
运输工具 	本地文件 	HTTP/HTTPS
安全性 	基于文件的安全性 	TLS、基本身份验证、授权标头、OAuth2
HTTP SD端点的要求

如果你实现了一个HTTP SD端点，这里有一些你应该知道的要求。

响应按原样使用，未修改。在每个刷新间隔（默认值：1分钟），Prometheus将向HTTP SD端点执行GET请求。GET请求包含带有刷新间隔的X-Prometheus-Refresh-Interval-Seconds HTTP标头。

SD端点必须使用HTTP 200响应进行应答，HTTP报头内容类型：application/json.答案必须是UTF-8格式。如果没有目标应该被传输，HTTP 200也必须发出，一个空的list []。目标列表是无序的。

普罗米修斯缓存目标列表。如果在获取更新的目标列表时发生错误，Prometheus将继续使用当前的目标列表。重新启动后不会保存目标列表。prometheus_sd_http_failures_total计数器度量跟踪刷新失败的次数。

每次刮都必须返回整个目标列表。不支持增量更新。Prometheus实例不发送其主机名，并且SD端点不可能知道SD请求是否是重启后的第一个请求。

HTTP SD的URL不被视为机密。身份验证和任何API密钥都应该通过适当的身份验证机制进行传递。Prometheus支持TLS身份验证、基本身份验证、OAuth2和授权头。

## HTTP_SD format

```
[
  {
    "targets": [ "<host>", ... ],
    "labels": {
      "<labelname>": "<labelvalue>", ...
    }
  },
  ...
]
```

Examples:

```
[
    {
        "targets": ["10.0.10.2:9100", "10.0.10.3:9100", "10.0.10.4:9100", "10.0.10.5:9100"],
        "labels": {
            "__meta_datacenter": "london",
            "__meta_prometheus_job": "node"
        }
    },
    {
        "targets": ["10.0.40.2:9100", "10.0.40.3:9100"],
        "labels": {
            "__meta_datacenter": "london",
            "__meta_prometheus_job": "alertmanager"
        }
    },
    {
        "targets": ["10.0.40.2:9093", "10.0.40.3:9093"],
        "labels": {
            "__meta_datacenter": "newyork",
            "__meta_prometheus_job": "alertmanager"
        }
    }
]
```