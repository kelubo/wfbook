# Pushing metrics推送指标

Occasionally you will need to monitor components which cannot be scraped. The [Prometheus Pushgateway](https://github.com/prometheus/pushgateway) allows you to push time series from [short-lived service-level batch jobs](https://prometheus.io/docs/practices/pushing/) to an intermediary job which Prometheus can scrape. Combined with Prometheus's simple text-based exposition format, this makes it easy to instrument even shell scripts without a client library.有时，您需要监控无法抓取的组件。[Prometheus Pushgateway](https://github.com/prometheus/pushgateway) 允许您将时间序列从[短期服务级别批处理作业](https://prometheus.io/docs/practices/pushing/)推送到 Prometheus 可以抓取的中间作业。结合 Prometheus 基于文本的简单公开格式，这使得在没有客户端库的情况下，甚至可以轻松插桩 shell 脚本。

- For more information on using the Pushgateway and use from a Unix shell, see the project's [README.md](https://github.com/prometheus/pushgateway/blob/master/README.md).
- For use from Java see the [PushGateway](https://prometheus.github.io/client_java/io/prometheus/client/exporter/PushGateway.html) class.
- For use from Go see the [Push](https://godoc.org/github.com/prometheus/client_golang/prometheus/push#Pusher.Push) and [Add](https://godoc.org/github.com/prometheus/client_golang/prometheus/push#Pusher.Add) methods.
- For use from Python see [Exporting to a Pushgateway](https://github.com/prometheus/client_python#exporting-to-a-pushgateway).
- For use from Ruby see the [Pushgateway documentation](https://github.com/prometheus/client_ruby#pushgateway).
  - To find out about Pushgateway support of [client libraries maintained outside of the Prometheus project](https://prometheus.io/docs/instrumenting/clientlibs/), refer to their respective documentation.