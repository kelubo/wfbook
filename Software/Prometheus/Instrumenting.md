[Instrumenting](https://prometheus.io/docs/visualization/consoles/#)

# Client libraries

Before you can monitor your services, you need to add instrumentation to their code via one of the Prometheus client libraries. These implement the Prometheus [metric types](https://prometheus.io/docs/concepts/metric_types/).

Choose a Prometheus client library that matches the language in which your application is written. This lets you define and expose internal metrics via an HTTP endpoint on your application’s instance:

- [Go](https://github.com/prometheus/client_golang)
- [Java or Scala](https://github.com/prometheus/client_java)
- [Python](https://github.com/prometheus/client_python)
- [Ruby](https://github.com/prometheus/client_ruby)
- [Rust](https://github.com/prometheus/client_rust)

Unofficial third-party client libraries:

- [Bash](https://github.com/aecolley/client_bash)
- [C](https://github.com/digitalocean/prometheus-client-c)
- [C++](https://github.com/jupp0r/prometheus-cpp)
- [Common Lisp](https://github.com/deadtrickster/prometheus.cl)
- [Dart](https://github.com/tentaclelabs/prometheus_client)
- [Elixir](https://github.com/deadtrickster/prometheus.ex)
- [Erlang](https://github.com/deadtrickster/prometheus.erl)
- [Haskell](https://github.com/fimad/prometheus-haskell)
- [Lua](https://github.com/knyar/nginx-lua-prometheus) for Nginx
- [Lua](https://github.com/tarantool/metrics) for Tarantool
- [.NET / C#](https://github.com/prometheus-net/prometheus-net)
- [Node.js](https://github.com/siimon/prom-client)
- [OCaml](https://github.com/mirage/prometheus)
- [Perl](https://metacpan.org/pod/Net::Prometheus)
- [PHP](https://github.com/promphp/prometheus_client_php)
- [R](https://github.com/cfmack/pRometheus)

When Prometheus scrapes your instance's HTTP endpoint, the client library sends the current state of all tracked metrics to the server.

If no client library is available for your language, or you want to avoid dependencies, you may also implement one of the supported [exposition formats](https://prometheus.io/docs/instrumenting/exposition_formats/) yourself to expose metrics.

When implementing a new Prometheus client library, please follow the [guidelines on writing client libraries](https://prometheus.io/docs/instrumenting/writing_clientlibs). Note that this document is still a work in progress. Please also consider consulting the [development mailing list](https://groups.google.com/forum/#!forum/prometheus-developers). We are happy to give advice on how to make your library as useful and consistent as possible.

# Writing client libraries

- [Conventions ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#conventions)

- [Overall structure ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#overall-structure)

- - [Naming ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#naming)

- [Metrics ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#metrics)

- - [Counter ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#counter)
  - [Gauge ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#gauge)
  - [Summary ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#summary)
  - [Histogram ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#histogram)
  - [Labels ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#labels)
  - [Metric names ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#metric-names)
  - [Metric description and help ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#metric-description-and-help)

- [Exposition ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#exposition)

- [Standard and runtime collectors ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#standard-and-runtime-collectors)

- - [Process metrics ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#process-metrics)
  - [Runtime metrics ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#runtime-metrics)

- [Unit tests ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#unit-tests)

- [Packaging and dependencies ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#packaging-and-dependencies)

- [Performance considerations ](https://prometheus.io/docs/instrumenting/writing_clientlibs/#performance-considerations)

This document covers what functionality and API Prometheus client libraries should offer, with the aim of consistency across libraries, making the easy use cases easy and avoiding offering functionality that may lead users down the wrong path.

There are [10 languages already supported](https://prometheus.io/docs/instrumenting/clientlibs) at the time of writing, so we’ve gotten a good sense by now of how to write a client. These guidelines aim to help authors of new client libraries produce good libraries.

## Conventions

MUST/MUST NOT/SHOULD/SHOULD NOT/MAY have the meanings given in https://www.ietf.org/rfc/rfc2119.txt

In addition ENCOURAGED means that a feature is desirable for a library to have, but it’s okay if it’s not present. In other words, a nice to have.

Things to keep in mind:

- Take advantage of each language’s features.
- The common use cases should be easy.
- The correct way to do something should be the easy way.
- More complex use cases should be possible.

The common use cases are (in order):

- Counters without labels spread liberally around libraries/applications.
- Timing functions/blocks of code in Summaries/Histograms.
- Gauges to track current states of things (and their limits).
- Monitoring of batch jobs.

## Overall structure

Clients MUST be written to be callback based internally. Clients SHOULD generally follow the structure described here.

The key class is the Collector. This has a method (typically called ‘collect’) that returns zero or more metrics and their samples. Collectors get registered with a CollectorRegistry. Data is exposed by passing a CollectorRegistry to a class/method/function "bridge", which returns the metrics in a format Prometheus supports. Every time the CollectorRegistry is scraped it must callback to each of the Collectors’ collect method.

The interface most users interact with are the Counter, Gauge, Summary, and Histogram Collectors. These represent a single metric, and should cover the vast majority of use cases where a user is instrumenting their own code.

More advanced uses cases (such as proxying from another monitoring/instrumentation system) require writing a custom Collector. Someone may also want to write a "bridge" that takes a CollectorRegistry and produces data in a format a different monitoring/instrumentation system understands, allowing users to only have to think about one instrumentation system.

CollectorRegistry SHOULD offer `register()`/`unregister()` functions, and a Collector SHOULD be allowed to be registered to multiple CollectorRegistrys.

Client libraries MUST be thread safe.

For non-OO languages such as C, client libraries should follow the spirit of this structure as much as is practical.

### Naming

Client libraries SHOULD follow function/method/class names mentioned in this document, keeping in mind the naming conventions of the language they’re working in. For example, `set_to_current_time()` is good for a method name Python, but `SetToCurrentTime()` is better in Go and `setToCurrentTime()` is the convention in Java. Where names differ for technical reasons (e.g. not allowing function overloading), documentation/help strings SHOULD point users towards the other names.

Libraries MUST NOT offer functions/methods/classes with the same or similar names to ones given here, but with different semantics.

## Metrics

The Counter, Gauge, Summary and Histogram [metric types](https://prometheus.io/docs/concepts/metric_types/) are the primary interface by users.

Counter and Gauge MUST be part of the client library. At least one of Summary and Histogram MUST be offered.

These should be primarily used as file-static variables, that is, global variables defined in the same file as the code they’re instrumenting. The client library SHOULD enable this. The common use case is instrumenting a piece of code overall, not a piece of code in the context of one instance of an object. Users shouldn’t have to worry about plumbing their metrics throughout their code, the client library should do that for them (and if it doesn’t, users will write a wrapper around the library to make it "easier" - which rarely tends to go well).

There MUST be a default CollectorRegistry, the standard metrics MUST by default implicitly register into it with no special work required by the user. There MUST be a way to have metrics not register to the default CollectorRegistry, for use in batch jobs and unittests. Custom collectors SHOULD also follow this.

Exactly how the metrics should be created varies by language. For some (Java, Go) a builder approach is best, whereas for others (Python) function arguments are rich enough to do it in one call.

For example in the Java Simpleclient we have:

```
class YourClass {
  static final Counter requests = Counter.build()
      .name("requests_total")
      .help("Requests.").register();
}
```

This will register requests with the default CollectorRegistry. By calling `build()` rather than `register()` the metric won’t be registered (handy for unittests), you can also pass in a CollectorRegistry to `register()` (handy for batch jobs).

### Counter

[Counter](https://prometheus.io/docs/concepts/metric_types/#counter) is a monotonically increasing counter. It MUST NOT allow the value to decrease, however it MAY be reset to 0 (such as by server restart).

A counter MUST have the following methods:

- `inc()`: Increment the counter by 1
- `inc(double v)`: Increment the counter by the given amount. MUST check that v >= 0.

A counter is ENCOURAGED to have:

A way to count exceptions throw/raised in a given piece of code, and optionally only certain types of exceptions. This is count_exceptions in Python.

Counters MUST start at 0.

### Gauge

[Gauge](https://prometheus.io/docs/concepts/metric_types/#gauge) represents a value that can go up and down.

A gauge MUST have the following methods:

- `inc()`: Increment the gauge by 1
- `inc(double v)`: Increment the gauge by the given amount
- `dec()`: Decrement the gauge by 1
- `dec(double v)`: Decrement the gauge by the given amount
- `set(double v)`: Set the gauge to the given value

Gauges MUST start at 0, you MAY offer a way for a given gauge to start at a different number.

A gauge SHOULD have the following methods:

- `set_to_current_time()`: Set the gauge to the current unixtime in seconds.

A gauge is ENCOURAGED to have:

A way to track in-progress requests in some piece of code/function. This is `track_inprogress` in Python.

A way to time a piece of code and set the gauge to its duration in seconds. This is useful for batch jobs. This is startTimer/setDuration in Java and the `time()` decorator/context manager in Python. This SHOULD match the pattern in Summary/Histogram (though `set()` rather than `observe()`).

### Summary

A [summary](https://prometheus.io/docs/concepts/metric_types/#summary) samples observations (usually things like request durations) over sliding windows of time and provides instantaneous insight into their distributions, frequencies, and sums.

A summary MUST NOT allow the user to set "quantile" as a label name, as this is used internally to designate summary quantiles. A summary is ENCOURAGED to offer quantiles as exports, though these can’t be aggregated and tend to be slow. A summary MUST allow not having quantiles, as just `_count`/`_sum` is quite useful and this MUST be the default.

A summary MUST have the following methods:

- `observe(double v)`: Observe the given amount

A summary SHOULD have the following methods:

Some way to time code for users in seconds. In Python this is the `time()` decorator/context manager. In Java this is startTimer/observeDuration. Units other than seconds MUST NOT be offered (if a user wants something else, they can do it by hand). This should follow the same pattern as Gauge/Histogram.

Summary `_count`/`_sum` MUST start at 0.

### Histogram

[Histograms](https://prometheus.io/docs/concepts/metric_types/#histogram) allow aggregatable distributions of events, such as request latencies. This is at its core a counter per bucket.

A histogram MUST NOT allow `le` as a user-set label, as `le` is used internally to designate buckets.

A histogram MUST offer a way to manually choose the buckets. Ways to set buckets in a `linear(start, width, count)` and `exponential(start, factor, count)` fashion SHOULD be offered. Count MUST include the `+Inf` bucket.

A histogram SHOULD have the same default buckets as other client libraries. Buckets MUST NOT be changeable once the metric is created.

A histogram MUST have the following methods:

- `observe(double v)`: Observe the given amount

A histogram SHOULD have the following methods:

Some way to time code for users in seconds. In Python this is the `time()` decorator/context manager. In Java this is `startTimer`/`observeDuration`. Units other than seconds MUST NOT be offered (if a user wants something else, they can do it by hand). This should follow the same pattern as Gauge/Summary.

Histogram  `_count`/`_sum` and the buckets MUST start at 0.

**Further metrics considerations**

Providing additional functionality in metrics beyond what’s documented above as makes sense for a given language is ENCOURAGED.

If there’s a common use case you can make simpler then go for it, as long as it won’t encourage undesirable behaviours (such as suboptimal metric/label layouts, or doing computation in the client).

### Labels

Labels are one of the [most powerful aspects](https://prometheus.io/docs/practices/instrumentation/#use-labels) of Prometheus, but [easily abused](https://prometheus.io/docs/practices/instrumentation/#do-not-overuse-labels). Accordingly client libraries must be very careful in how labels are offered to users.

Client libraries MUST NOT allow users to have different label names for the same metric for Gauge/Counter/Summary/Histogram or any other Collector offered by the library.

Metrics from custom collectors should almost always have consistent label names. As there are still rare but valid use cases where this is not the case, client libraries should not verify this.

While labels are powerful, the majority of metrics will not have labels. Accordingly the API should allow for labels but not dominate it.

A client library MUST allow for optionally specifying a list of label names at Gauge/Counter/Summary/Histogram creation time. A client library SHOULD support any number of label names. A client library MUST validate that label names meet the [documented requirements](https://prometheus.io/docs/concepts/data_model/#metric-names-and-labels).

The general way to provide access to labeled dimension of a metric is via a `labels()` method that takes either a list of the label values or a map from label name to label value and returns a "Child". The usual `.inc()`/`.dec()`/`.observe()` etc. methods can then be called on the Child.

The Child returned by `labels()` SHOULD be cacheable by the user, to avoid having to look it up again - this matters in latency-critical code.

Metrics with labels SHOULD support a `remove()` method with the same signature as `labels()` that will remove a Child from the metric no longer exporting it, and a `clear()` method that removes all Children from the metric. These invalidate caching of Children.

There SHOULD be a way to initialize a given Child with the default value, usually just calling `labels()`. Metrics without labels MUST always be initialized to avoid [problems with missing metrics](https://prometheus.io/docs/practices/instrumentation/#avoid-missing-metrics).

### Metric names

Metric names must follow the [specification](https://prometheus.io/docs/concepts/data_model/#metric-names-and-labels). As with label names, this MUST be met for uses of Gauge/Counter/Summary/Histogram and in any other Collector offered with the library.

Many client libraries offer setting the name in three parts: `namespace_subsystem_name` of which only the `name` is mandatory.

Dynamic/generated metric names or subparts of metric names MUST be discouraged, except when a custom Collector is proxying from other instrumentation/monitoring systems. Generated/dynamic metric names are a sign that you should be using labels instead.

### Metric description and help

Gauge/Counter/Summary/Histogram MUST require metric descriptions/help to be provided.

Any custom Collectors provided with the client libraries MUST have descriptions/help on their metrics.

It is suggested to make it a mandatory argument, but not to check that it’s of a certain length as if someone really doesn’t want to write docs we’re not going to convince them otherwise. Collectors offered with the library (and indeed everywhere we can within the ecosystem) SHOULD have good metric descriptions, to lead by example.

## Exposition

Clients MUST implement the text-based exposition format outlined in the [exposition formats](https://prometheus.io/docs/instrumenting/exposition_formats) documentation.

Reproducible order of the exposed metrics is ENCOURAGED (especially for human readable formats) if it can be implemented without a significant resource cost.

## Standard and runtime collectors

Client libraries SHOULD offer what they can of the Standard exports, documented below.

These SHOULD be implemented as custom Collectors, and registered by default on the default CollectorRegistry. There SHOULD be a way to disable these, as there are some very niche use cases where they get in the way.

### Process metrics

These metrics have the prefix `process_`. If obtaining a necessary value is problematic or even impossible with the used language or runtime, client libraries SHOULD prefer leaving out the corresponding metric over exporting bogus, inaccurate, or special values (like `NaN`). All memory values in bytes, all times in unixtime/seconds.

| Metric name                        | Help string                                            | Unit             |
| ---------------------------------- | ------------------------------------------------------ | ---------------- |
| `process_cpu_seconds_total`        | Total user and system CPU time spent in seconds.       | seconds          |
| `process_open_fds`                 | Number of open file descriptors.                       | file descriptors |
| `process_max_fds`                  | Maximum number of open file descriptors.               | file descriptors |
| `process_virtual_memory_bytes`     | Virtual memory size in bytes.                          | bytes            |
| `process_virtual_memory_max_bytes` | Maximum amount of virtual memory available in bytes.   | bytes            |
| `process_resident_memory_bytes`    | Resident memory size in bytes.                         | bytes            |
| `process_heap_bytes`               | Process heap size in bytes.                            | bytes            |
| `process_start_time_seconds`       | Start time of the process since unix epoch in seconds. | seconds          |
| `process_threads`                  | Number of OS threads in the process.                   | threads          |

### Runtime metrics

In addition, client libraries are ENCOURAGED to also offer whatever makes sense in terms of metrics for their language’s runtime (e.g. garbage collection stats), with an appropriate prefix such as `go_`, `hotspot_` etc.

## Unit tests

Client libraries SHOULD have unit tests covering the core instrumentation library and exposition.

Client libraries are ENCOURAGED to offer ways that make it easy for users to unit-test their use of the instrumentation code. For example, the `CollectorRegistry.get_sample_value` in Python.

## Packaging and dependencies

Ideally, a client library can be included in any application to add some instrumentation without breaking the application.

Accordingly, caution is advised when adding dependencies to the client library. For example, if you add a library that uses a Prometheus client that requires version x.y of a library but the application uses x.z elsewhere, will that have an adverse impact on the application?

It is suggested that where this may arise, that the core instrumentation is separated from the bridges/exposition of metrics in a given format. For example, the Java simpleclient `simpleclient` module has no dependencies, and the `simpleclient_servlet` has the HTTP bits.

## Performance considerations

As client libraries must be thread-safe, some form of concurrency control is required and consideration must be given to performance on multi-core machines and applications.

In our experience the least performant is mutexes.

Processor atomic instructions tend to be in the middle, and generally acceptable.

Approaches that avoid different CPUs mutating the same bit of RAM work best, such as the DoubleAdder in Java’s simpleclient. There is a memory cost though.

As noted above, the result of `labels()` should be cacheable. The concurrent maps that tend to back metric with labels tend to be relatively slow. Special-casing metrics without labels to avoid `labels()`-like lookups can help a lot.

Metrics SHOULD avoid blocking when they are being incremented/decremented/set etc. as it’s undesirable for the whole application to be held up while a scrape is ongoing.

Having benchmarks of the main instrumentation operations, including labels, is ENCOURAGED.

Resource consumption, particularly RAM, should be kept in mind when performing exposition. Consider reducing the memory footprint by streaming results, and potentially having a limit on the number of concurrent scrapes.

​           This documentation is [open-source](https://github.com/prometheus/docs#contributing-changes). Please help improve it by filing issues or pull requests.      

# Pushing metrics

Occasionally you will need to monitor components which cannot be scraped. The [Prometheus Pushgateway](https://github.com/prometheus/pushgateway) allows you to push time series from [short-lived service-level batch jobs](https://prometheus.io/docs/practices/pushing/) to an intermediary job which Prometheus can scrape. Combined with Prometheus's simple text-based exposition format, this makes it easy to instrument even shell scripts without a client library.

- For more information on using the Pushgateway and use from a Unix shell, see the project's [README.md](https://github.com/prometheus/pushgateway/blob/master/README.md).
- For use from Java see the [PushGateway](https://prometheus.github.io/client_java/io/prometheus/client/exporter/PushGateway.html) class.
- For use from Go see the [Push](https://godoc.org/github.com/prometheus/client_golang/prometheus/push#Pusher.Push) and [Add](https://godoc.org/github.com/prometheus/client_golang/prometheus/push#Pusher.Add) methods.
- For use from Python see [Exporting to a Pushgateway](https://github.com/prometheus/client_python#exporting-to-a-pushgateway).
- For use from Ruby see the [Pushgateway documentation](https://github.com/prometheus/client_ruby#pushgateway).
  - To find out about Pushgateway support of [client libraries maintained outside of the Prometheus project](https://prometheus.io/docs/instrumenting/clientlibs/), refer to their respective documentation.

# Exporters and integrations

- [Third-party exporters ](https://prometheus.io/docs/instrumenting/exporters/#third-party-exporters)

- - [Databases ](https://prometheus.io/docs/instrumenting/exporters/#databases)
  - [Hardware related ](https://prometheus.io/docs/instrumenting/exporters/#hardware-related)
  - [Issue trackers and continuous integration ](https://prometheus.io/docs/instrumenting/exporters/#issue-trackers-and-continuous-integration)
  - [Messaging systems ](https://prometheus.io/docs/instrumenting/exporters/#messaging-systems)
  - [Storage ](https://prometheus.io/docs/instrumenting/exporters/#storage)
  - [HTTP ](https://prometheus.io/docs/instrumenting/exporters/#http)
  - [APIs ](https://prometheus.io/docs/instrumenting/exporters/#apis)
  - [Logging ](https://prometheus.io/docs/instrumenting/exporters/#logging)
  - [Other monitoring systems ](https://prometheus.io/docs/instrumenting/exporters/#other-monitoring-systems)
  - [Miscellaneous ](https://prometheus.io/docs/instrumenting/exporters/#miscellaneous)

- [Software exposing Prometheus metrics ](https://prometheus.io/docs/instrumenting/exporters/#software-exposing-prometheus-metrics)

- [Other third-party utilities ](https://prometheus.io/docs/instrumenting/exporters/#other-third-party-utilities)

There are a number of libraries and servers which help in exporting existing metrics from third-party systems as Prometheus metrics. This is useful for cases where it is not feasible to instrument a given system with Prometheus metrics directly (for example, HAProxy or Linux system stats).

## Third-party exporters

Some of these exporters are maintained as part of the official [Prometheus GitHub organization](https://github.com/prometheus), those are marked as *official*, others are externally contributed and maintained.

We encourage the creation of more exporters but cannot vet all of them for [best practices](https://prometheus.io/docs/instrumenting/writing_exporters/). Commonly, those exporters are hosted outside of the Prometheus GitHub organization.

The [exporter default port](https://github.com/prometheus/prometheus/wiki/Default-port-allocations) wiki page has become another catalog of exporters, and may include exporters not listed here due to overlapping functionality or still being in development.

The [JMX exporter](https://github.com/prometheus/jmx_exporter) can export from a wide variety of JVM-based applications, for example [Kafka](http://kafka.apache.org/) and [Cassandra](http://cassandra.apache.org/).

### Databases

- [Aerospike exporter](https://github.com/aerospike/aerospike-prometheus-exporter)
- [ClickHouse exporter](https://github.com/f1yegor/clickhouse_exporter)
- [Consul exporter](https://github.com/prometheus/consul_exporter) (**official**)
- [Couchbase exporter](https://github.com/blakelead/couchbase_exporter)
- [CouchDB exporter](https://github.com/gesellix/couchdb-exporter)
- [Druid Exporter](https://github.com/opstree/druid-exporter)
- [Elasticsearch exporter](https://github.com/prometheus-community/elasticsearch_exporter)
- [EventStore exporter](https://github.com/marcinbudny/eventstore_exporter)
- [IoTDB exporter](https://github.com/fagnercarvalho/prometheus-iotdb-exporter)
- [KDB+ exporter](https://github.com/KxSystems/prometheus-kdb-exporter)
- [Memcached exporter](https://github.com/prometheus/memcached_exporter) (**official**)
- [MongoDB exporter](https://github.com/dcu/mongodb_exporter)
- [MongoDB query exporter](https://github.com/raffis/mongodb-query-exporter)
- [MSSQL server exporter](https://github.com/awaragi/prometheus-mssql-exporter)
- [MySQL router exporter](https://github.com/rluisr/mysqlrouter_exporter)
- [MySQL server exporter](https://github.com/prometheus/mysqld_exporter) (**official**)
- [OpenTSDB Exporter](https://github.com/cloudflare/opentsdb_exporter)
- [Oracle DB Exporter](https://github.com/iamseth/oracledb_exporter)
- [PgBouncer exporter](https://github.com/prometheus-community/pgbouncer_exporter)
- [PostgreSQL exporter](https://github.com/prometheus-community/postgres_exporter)
- [Presto exporter](https://github.com/yahoojapan/presto_exporter)
- [ProxySQL exporter](https://github.com/percona/proxysql_exporter)
- [RavenDB exporter](https://github.com/marcinbudny/ravendb_exporter)
- [Redis exporter](https://github.com/oliver006/redis_exporter)
- [RethinkDB exporter](https://github.com/oliver006/rethinkdb_exporter)
- [SQL exporter](https://github.com/burningalchemist/sql_exporter)
- [Tarantool metric library](https://github.com/tarantool/metrics)
- [Twemproxy](https://github.com/stuartnelson3/twemproxy_exporter)

### Hardware related

- [apcupsd exporter](https://github.com/mdlayher/apcupsd_exporter)
- [BIG-IP exporter](https://github.com/ExpressenAB/bigip_exporter)
- [Bosch Sensortec BMP/BME exporter](https://github.com/David-Igou/bsbmp-exporter)
- [Collins exporter](https://github.com/soundcloud/collins_exporter)
- [Dell Hardware OMSA exporter](https://github.com/galexrt/dellhw_exporter)
- [Disk usage exporter](https://github.com/dundee/disk_usage_exporter)
- [Fortigate exporter](https://github.com/bluecmd/fortigate_exporter)
- [IBM Z HMC exporter](https://github.com/zhmcclient/zhmc-prometheus-exporter)
- [IoT Edison exporter](https://github.com/roman-vynar/edison_exporter)
- [InfiniBand exporter](https://github.com/treydock/infiniband_exporter)
- [IPMI exporter](https://github.com/soundcloud/ipmi_exporter)
- [knxd exporter](https://github.com/RichiH/knxd_exporter)
- [Modbus exporter](https://github.com/RichiH/modbus_exporter)
- [Netgear Cable Modem Exporter](https://github.com/ickymettle/netgear_cm_exporter)
- [Netgear Router exporter](https://github.com/DRuggeri/netgear_exporter)
- [Network UPS Tools (NUT) exporter](https://github.com/DRuggeri/nut_exporter)
- [Node/system metrics exporter](https://github.com/prometheus/node_exporter) (**official**)
- [NVIDIA GPU exporter](https://github.com/mindprince/nvidia_gpu_prometheus_exporter)
- [ProSAFE exporter](https://github.com/dalance/prosafe_exporter)
- [Waveplus Radon Sensor Exporter](https://github.com/jeremybz/waveplus_exporter)
- [Weathergoose Climate Monitor Exporter](https://github.com/branttaylor/watchdog-prometheus-exporter)
- [Windows exporter](https://github.com/prometheus-community/windows_exporter)
- [Intel® Optane™ Persistent Memory Controller Exporter](https://github.com/intel/ipmctl-exporter)

### Issue trackers and continuous integration

- [Bamboo exporter](https://github.com/AndreyVMarkelov/bamboo-prometheus-exporter)
- [Bitbucket exporter](https://github.com/AndreyVMarkelov/prom-bitbucket-exporter)
- [Confluence exporter](https://github.com/AndreyVMarkelov/prom-confluence-exporter)
- [Jenkins exporter](https://github.com/lovoo/jenkins_exporter)
- [JIRA exporter](https://github.com/AndreyVMarkelov/jira-prometheus-exporter)

### Messaging systems

- [Beanstalkd exporter](https://github.com/messagebird/beanstalkd_exporter)
- [EMQ exporter](https://github.com/nuvo/emq_exporter)
- [Gearman exporter](https://github.com/bakins/gearman-exporter)
- [IBM MQ exporter](https://github.com/ibm-messaging/mq-metric-samples/tree/master/cmd/mq_prometheus)
- [Kafka exporter](https://github.com/danielqsj/kafka_exporter)
- [NATS exporter](https://github.com/nats-io/prometheus-nats-exporter)
- [NSQ exporter](https://github.com/lovoo/nsq_exporter)
- [Mirth Connect exporter](https://github.com/vynca/mirth_exporter)
- [MQTT blackbox exporter](https://github.com/inovex/mqtt_blackbox_exporter)
- [MQTT2Prometheus](https://github.com/hikhvar/mqtt2prometheus)
- [RabbitMQ exporter](https://github.com/kbudde/rabbitmq_exporter)
- [RabbitMQ Management Plugin exporter](https://github.com/deadtrickster/prometheus_rabbitmq_exporter)
- [RocketMQ exporter](https://github.com/apache/rocketmq-exporter)
- [Solace exporter](https://github.com/solacecommunity/solace-prometheus-exporter)

### Storage

- [Ceph exporter](https://github.com/digitalocean/ceph_exporter)
- [Ceph RADOSGW exporter](https://github.com/blemmenes/radosgw_usage_exporter)
- [Gluster exporter](https://github.com/ofesseler/gluster_exporter)
- [GPFS exporter](https://github.com/treydock/gpfs_exporter)
- [Hadoop HDFS FSImage exporter](https://github.com/marcelmay/hadoop-hdfs-fsimage-exporter)
- [HPE CSI info metrics provider](https://scod.hpedev.io/csi_driver/metrics.html)
- [HPE storage array exporter](https://hpe-storage.github.io/array-exporter/)
- [Lustre exporter](https://github.com/HewlettPackard/lustre_exporter)
- [NetApp E-Series exporter](https://github.com/treydock/eseries_exporter)
- [Pure Storage exporter](https://github.com/PureStorage-OpenConnect/pure-exporter)
- [ScaleIO exporter](https://github.com/syepes/sio2prom)
- [Tivoli Storage Manager/IBM Spectrum Protect exporter](https://github.com/treydock/tsm_exporter)

### HTTP

- [Apache exporter](https://github.com/Lusitaniae/apache_exporter)
- [HAProxy exporter](https://github.com/prometheus/haproxy_exporter) (**official**)
- [Nginx metric library](https://github.com/knyar/nginx-lua-prometheus)
- [Nginx VTS exporter](https://github.com/hnlq715/nginx-vts-exporter)
- [Passenger exporter](https://github.com/stuartnelson3/passenger_exporter)
- [Squid exporter](https://github.com/boynux/squid-exporter)
- [Tinyproxy exporter](https://github.com/igzivkov/tinyproxy_exporter)
- [Varnish exporter](https://github.com/jonnenauha/prometheus_varnish_exporter)
- [WebDriver exporter](https://github.com/mattbostock/webdriver_exporter)

### APIs

- [AWS ECS exporter](https://github.com/slok/ecs-exporter)
- [AWS Health exporter](https://github.com/Jimdo/aws-health-exporter)
- [AWS SQS exporter](https://github.com/jmal98/sqs_exporter)
- [Azure Health exporter](https://github.com/FXinnovation/azure-health-exporter)
- [BigBlueButton](https://github.com/greenstatic/bigbluebutton-exporter)
- [Cloudflare exporter](https://gitlab.com/gitlab-org/cloudflare_exporter)
- [Cryptowat exporter](https://github.com/nbarrientos/cryptowat_exporter)
- [DigitalOcean exporter](https://github.com/metalmatze/digitalocean_exporter)
- [Docker Cloud exporter](https://github.com/infinityworksltd/docker-cloud-exporter)
- [Docker Hub exporter](https://github.com/infinityworksltd/docker-hub-exporter)
- [Fastly exporter](https://github.com/peterbourgon/fastly-exporter)
- [GitHub exporter](https://github.com/infinityworksltd/github-exporter)
- [Gmail exporter](https://github.com/jamesread/prometheus-gmail-exporter/)
- [InstaClustr exporter](https://github.com/fcgravalos/instaclustr_exporter)
- [Mozilla Observatory exporter](https://github.com/Jimdo/observatory-exporter)
- [OpenWeatherMap exporter](https://github.com/RichiH/openweathermap_exporter)
- [Pagespeed exporter](https://github.com/foomo/pagespeed_exporter)
- [Rancher exporter](https://github.com/infinityworksltd/prometheus-rancher-exporter)
- [Speedtest exporter](https://github.com/nlamirault/speedtest_exporter)
- [Tankerkönig API Exporter](https://github.com/lukasmalkmus/tankerkoenig_exporter)

### Logging

- [Fluentd exporter](https://github.com/V3ckt0r/fluentd_exporter)
- [Google's mtail log data extractor](https://github.com/google/mtail)
- [Grok exporter](https://github.com/fstab/grok_exporter)

### Other monitoring systems

- [Akamai Cloudmonitor exporter](https://github.com/ExpressenAB/cloudmonitor_exporter)
- [Alibaba Cloudmonitor exporter](https://github.com/aylei/aliyun-exporter)
- [AWS CloudWatch exporter](https://github.com/prometheus/cloudwatch_exporter) (**official**)
- [Azure Monitor exporter](https://github.com/RobustPerception/azure_metrics_exporter)
- [Cloud Foundry Firehose exporter](https://github.com/cloudfoundry-community/firehose_exporter)
- [Collectd exporter](https://github.com/prometheus/collectd_exporter) (**official**)
- [Google Stackdriver exporter](https://github.com/frodenas/stackdriver_exporter)
- [Graphite exporter](https://github.com/prometheus/graphite_exporter) (**official**)
- [Heka dashboard exporter](https://github.com/docker-infra/heka_exporter)
- [Heka exporter](https://github.com/imgix/heka_exporter)
- [Huawei Cloudeye exporter](https://github.com/huaweicloud/cloudeye-exporter)
- [InfluxDB exporter](https://github.com/prometheus/influxdb_exporter) (**official**)
- [ITM exporter](https://github.com/rafal-szypulka/itm_exporter)
- [JavaMelody exporter](https://github.com/fschlag/javamelody-prometheus-exporter)
- [JMX exporter](https://github.com/prometheus/jmx_exporter) (**official**)
- [Munin exporter](https://github.com/pvdh/munin_exporter)
- [Nagios / Naemon exporter](https://github.com/Griesbacher/Iapetos)
- [New Relic exporter](https://github.com/mrf/newrelic_exporter)
- [NRPE exporter](https://github.com/robustperception/nrpe_exporter)
- [Osquery exporter](https://github.com/zwopir/osquery_exporter)
- [OTC CloudEye exporter](https://github.com/tiagoReichert/otc-cloudeye-prometheus-exporter)
- [Pingdom exporter](https://github.com/giantswarm/prometheus-pingdom-exporter)
- [Promitor (Azure Monitor)](https://promitor.io)
- [scollector exporter](https://github.com/tgulacsi/prometheus_scollector)
- [Sensu exporter](https://github.com/reachlin/sensu_exporter)
- [site24x7_exporter](https://github.com/svenstaro/site24x7_exporter)
- [SNMP exporter](https://github.com/prometheus/snmp_exporter) (**official**)
- [StatsD exporter](https://github.com/prometheus/statsd_exporter) (**official**)
- [TencentCloud monitor exporter](https://github.com/tencentyun/tencentcloud-exporter)
- [ThousandEyes exporter](https://github.com/sapcc/1000eyes_exporter)

### Miscellaneous

- [ACT Fibernet Exporter](https://git.captnemo.in/nemo/prometheus-act-exporter)
- [BIND exporter](https://github.com/prometheus-community/bind_exporter)
- [BIND query exporter](https://github.com/DRuggeri/bind_query_exporter)
- [Bitcoind exporter](https://github.com/LePetitBloc/bitcoind-exporter)
- [Blackbox exporter](https://github.com/prometheus/blackbox_exporter) (**official**)
- [Bungeecord exporter](https://github.com/weihao/bungeecord-prometheus-exporter)
- [BOSH exporter](https://github.com/cloudfoundry-community/bosh_exporter)
- [cAdvisor](https://github.com/google/cadvisor)
- [Cachet exporter](https://github.com/ContaAzul/cachet_exporter)
- [ccache exporter](https://github.com/virtualtam/ccache_exporter)
- [c-lightning exporter](https://github.com/lightningd/plugins/tree/master/prometheus)
- [DHCPD leases exporter](https://github.com/DRuggeri/dhcpd_leases_exporter)
- [Dovecot exporter](https://github.com/kumina/dovecot_exporter)
- [Dnsmasq exporter](https://github.com/google/dnsmasq_exporter)
- [eBPF exporter](https://github.com/cloudflare/ebpf_exporter)
- [Ethereum Client exporter](https://github.com/31z4/ethereum-prometheus-exporter)
- [JFrog Artifactory Exporter](https://github.com/peimanja/artifactory_exporter)
- [Hostapd Exporter](https://github.com/Fundacio-i2CAT/hostapd_prometheus_exporter)
- [IRCd exporter](https://github.com/dgl/ircd_exporter)
- [Linux HA ClusterLabs exporter](https://github.com/ClusterLabs/ha_cluster_exporter)
- [JMeter plugin](https://github.com/johrstrom/jmeter-prometheus-plugin)
- [JSON exporter](https://github.com/prometheus-community/json_exporter)
- [Kannel exporter](https://github.com/apostvav/kannel_exporter)
- [Kemp LoadBalancer exporter](https://github.com/giantswarm/prometheus-kemp-exporter)
- [Kibana Exporter](https://github.com/pjhampton/kibana-prometheus-exporter)
- [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
- [Locust Exporter](https://github.com/ContainerSolutions/locust_exporter)
- [Meteor JS web framework exporter](https://atmospherejs.com/sevki/prometheus-exporter)
- [Minecraft exporter module](https://github.com/Baughn/PrometheusIntegration)
- [Minecraft exporter](https://github.com/dirien/minecraft-prometheus-exporter)
- [Nomad exporter](https://gitlab.com/yakshaving.art/nomad-exporter)
- [nftables exporter](https://github.com/Intrinsec/nftables_exporter)
- [OpenStack exporter](https://github.com/openstack-exporter/openstack-exporter)
- [OpenStack blackbox exporter](https://github.com/infraly/openstack_client_exporter)
- [oVirt exporter](https://github.com/czerwonk/ovirt_exporter)
- [Pact Broker exporter](https://github.com/ContainerSolutions/pactbroker_exporter)
- [PHP-FPM exporter](https://github.com/bakins/php-fpm-exporter)
- [PowerDNS exporter](https://github.com/ledgr/powerdns_exporter)
- [Podman exporter](https://github.com/containers/prometheus-podman-exporter)
- [Process exporter](https://github.com/ncabatoff/process-exporter)
- [rTorrent exporter](https://github.com/mdlayher/rtorrent_exporter)
- [Rundeck exporter](https://github.com/phsmith/rundeck_exporter)
- [SABnzbd exporter](https://github.com/msroest/sabnzbd_exporter)
- [Script exporter](https://github.com/adhocteam/script_exporter)
- [Shield exporter](https://github.com/cloudfoundry-community/shield_exporter)
- [Smokeping prober](https://github.com/SuperQ/smokeping_prober)
- [SMTP/Maildir MDA blackbox prober](https://github.com/cherti/mailexporter)
- [SoftEther exporter](https://github.com/dalance/softether_exporter)
- [SSH exporter](https://github.com/treydock/ssh_exporter)
- [Teamspeak3 exporter](https://github.com/hikhvar/ts3exporter)
- [Transmission exporter](https://github.com/metalmatze/transmission-exporter)
- [Unbound exporter](https://github.com/kumina/unbound_exporter)
- [WireGuard exporter](https://github.com/MindFlavor/prometheus_wireguard_exporter)
- [Xen exporter](https://github.com/lovoo/xenstats_exporter)

When implementing a new Prometheus exporter, please follow the [guidelines on writing exporters](https://prometheus.io/docs/instrumenting/writing_exporters) Please also consider consulting the [development mailing list](https://groups.google.com/forum/#!forum/prometheus-developers).  We are happy to give advice on how to make your exporter as useful and consistent as possible.

## Software exposing Prometheus metrics

Some third-party software exposes metrics in the Prometheus format, so no separate exporters are needed:

- [Ansible Tower (AWX)](https://docs.ansible.com/ansible-tower/latest/html/administration/metrics.html)
- [App Connect Enterprise](https://github.com/ot4i/ace-docker)
- [Ballerina](https://ballerina.io/)
- [BFE](https://github.com/baidu/bfe)
- [Caddy](https://caddyserver.com/docs/metrics) (**direct**)
- [Ceph](https://docs.ceph.com/en/latest/mgr/prometheus/)
- [CockroachDB](https://www.cockroachlabs.com/docs/stable/monitoring-and-alerting.html#prometheus-endpoint)
- [Collectd](https://collectd.org/wiki/index.php/Plugin:Write_Prometheus)
- [Concourse](https://concourse-ci.org/)
- [CRG Roller Derby Scoreboard](https://github.com/rollerderby/scoreboard) (**direct**)
- [Diffusion](https://docs.pushtechnology.com/docs/latest/manual/html/administratorguide/systemmanagement/r_statistics.html)
- [Docker Daemon](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-metrics)
- [Doorman](https://github.com/youtube/doorman) (**direct**)
- [Dovecot](https://doc.dovecot.org/configuration_manual/stats/openmetrics/)
- [Envoy](https://www.envoyproxy.io/docs/envoy/latest/operations/admin.html#get--stats?format=prometheus)
- [Etcd](https://github.com/coreos/etcd) (**direct**)
- [Flink](https://github.com/apache/flink)
- [FreeBSD Kernel](https://www.freebsd.org/cgi/man.cgi?query=prometheus_sysctl_exporter&apropos=0&sektion=8&manpath=FreeBSD+12-current&arch=default&format=html)
- [GitLab](https://docs.gitlab.com/ee/administration/monitoring/prometheus/gitlab_metrics.html)
- [Grafana](https://grafana.com/docs/grafana/latest/administration/view-server/internal-metrics/)
- [JavaMelody](https://github.com/javamelody/javamelody/wiki/UserGuideAdvanced#exposing-metrics-to-prometheus)
- [Kong](https://github.com/Kong/kong-plugin-prometheus)
- [Kubernetes](https://github.com/kubernetes/kubernetes) (**direct**)
- [Linkerd](https://github.com/BuoyantIO/linkerd)
- [mgmt](https://github.com/purpleidea/mgmt/blob/master/docs/prometheus.md)
- [MidoNet](https://github.com/midonet/midonet)
- [midonet-kubernetes](https://github.com/midonet/midonet-kubernetes) (**direct**)
- [MinIO](https://docs.minio.io/docs/how-to-monitor-minio-using-prometheus.html)
- [PATROL with Monitoring Studio X](https://www.sentrysoftware.com/library/swsyx/prometheus/exposing-patrol-parameters-in-prometheus.html)
- [Netdata](https://github.com/firehol/netdata)
- [OpenZiti](https://openziti.github.io)
- [Pomerium](https://pomerium.com/reference/#metrics-address)
- [Pretix](https://pretix.eu/)
- [Quobyte](https://www.quobyte.com/) (**direct**)
- [RabbitMQ](https://rabbitmq.com/prometheus.html)
- [RobustIRC](http://robustirc.net/)
- [ScyllaDB](https://github.com/scylladb/scylla)
- [Skipper](https://github.com/zalando/skipper)
- [SkyDNS](https://github.com/skynetservices/skydns) (**direct**)
- [Telegraf](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/prometheus_client)
- [Traefik](https://github.com/containous/traefik)
- [Vector](https://vector.dev)
- [VerneMQ](https://github.com/vernemq/vernemq)
- [Weave Flux](https://github.com/weaveworks/flux)
- [Xandikos](https://www.xandikos.org/) (**direct**)
- [Zipkin](https://github.com/openzipkin/zipkin/tree/master/zipkin-server#metrics)

The software marked *direct* is also directly instrumented with a Prometheus client library.

## Other third-party utilities

This section lists libraries and other utilities that help you instrument code in a certain language. They are not Prometheus client libraries themselves but make use of one of the normal Prometheus client libraries under the hood. As for all independently maintained software, we cannot vet all of them for best practices.

- Clojure: [iapetos](https://github.com/clj-commons/iapetos)
- Go: [go-metrics instrumentation library](https://github.com/armon/go-metrics)
- Go: [gokit](https://github.com/peterbourgon/gokit)
- Go: [prombolt](https://github.com/mdlayher/prombolt)
- Java/JVM: [EclipseLink metrics collector](https://github.com/VitaNuova/eclipselinkexporter)
- Java/JVM: [Hystrix metrics publisher](https://github.com/ahus1/prometheus-hystrix)
- Java/JVM: [Jersey metrics collector](https://github.com/VitaNuova/jerseyexporter)
- Java/JVM: [Micrometer Prometheus Registry](https://micrometer.io/docs/registry/prometheus)
- Python-Django: [django-prometheus](https://github.com/korfuri/django-prometheus)
- Node.js: [swagger-stats](https://github.com/slanatech/swagger-stats)

# Writing exporters

- [Maintainability and purity ](https://prometheus.io/docs/instrumenting/writing_exporters/#maintainability-and-purity)

- [Configuration ](https://prometheus.io/docs/instrumenting/writing_exporters/#configuration)

- [Metrics ](https://prometheus.io/docs/instrumenting/writing_exporters/#metrics)

- - [Naming ](https://prometheus.io/docs/instrumenting/writing_exporters/#naming)
  - [Labels ](https://prometheus.io/docs/instrumenting/writing_exporters/#labels)
  - [Target labels, not static scraped labels ](https://prometheus.io/docs/instrumenting/writing_exporters/#target-labels-not-static-scraped-labels)
  - [Types ](https://prometheus.io/docs/instrumenting/writing_exporters/#types)
  - [Help strings ](https://prometheus.io/docs/instrumenting/writing_exporters/#help-strings)
  - [Drop less useful statistics ](https://prometheus.io/docs/instrumenting/writing_exporters/#drop-less-useful-statistics)
  - [Dotted strings ](https://prometheus.io/docs/instrumenting/writing_exporters/#dotted-strings)

- [Collectors ](https://prometheus.io/docs/instrumenting/writing_exporters/#collectors)

- - [Metrics about the scrape itself ](https://prometheus.io/docs/instrumenting/writing_exporters/#metrics-about-the-scrape-itself)
  - [Machine and process metrics ](https://prometheus.io/docs/instrumenting/writing_exporters/#machine-and-process-metrics)

- [Deployment ](https://prometheus.io/docs/instrumenting/writing_exporters/#deployment)

- - [Scheduling ](https://prometheus.io/docs/instrumenting/writing_exporters/#scheduling)
  - [Pushes ](https://prometheus.io/docs/instrumenting/writing_exporters/#pushes)
  - [Failed scrapes ](https://prometheus.io/docs/instrumenting/writing_exporters/#failed-scrapes)
  - [Landing page ](https://prometheus.io/docs/instrumenting/writing_exporters/#landing-page)
  - [Port numbers ](https://prometheus.io/docs/instrumenting/writing_exporters/#port-numbers)

- [Announcing ](https://prometheus.io/docs/instrumenting/writing_exporters/#announcing)

If you are instrumenting your own code, the [general rules of how to instrument code with a Prometheus client library](https://prometheus.io/docs/practices/instrumentation/) should be followed. When taking metrics from another monitoring or instrumentation system, things tend not to be so black and white.

This document contains things you should consider when writing an exporter or custom collector. The theory covered will also be of interest to those doing direct instrumentation.

If you are writing an exporter and are unclear on anything here, please contact us on IRC (#prometheus on libera) or the [mailing list](https://prometheus.io/community).

## Maintainability and purity

The main decision you need to make when writing an exporter is how much work you’re willing to put in to get perfect metrics out of it.

If the system in question has only a handful of metrics that rarely change, then getting everything perfect is an easy choice, a good example of this is the [HAProxy exporter](https://github.com/prometheus/haproxy_exporter).

On the other hand, if you try to get things perfect when the system has hundreds of metrics that change frequently with new versions, then you’ve signed yourself up for a lot of ongoing work. The [MySQL exporter](https://github.com/prometheus/mysqld_exporter) is on this end of the spectrum.

The [node exporter](https://github.com/prometheus/node_exporter) is a mix of these, with complexity varying by module. For example, the `mdadm` collector hand-parses a file and exposes metrics created specifically for that collector, so we may as well get the metrics right. For the `meminfo` collector the results vary across kernel versions so we end up doing just enough of a transform to create valid metrics.

## Configuration

When working with applications, you should aim for an exporter that requires no custom configuration by the user beyond telling it where the application is.  You may also need to offer the ability to filter out certain metrics if they may be too granular and expensive on large setups, for example the [HAProxy exporter](https://github.com/prometheus/haproxy_exporter) allows filtering of per-server stats. Similarly, there may be expensive metrics that are disabled by default.

When working with other monitoring systems, frameworks and protocols you will often need to provide additional configuration or customization to generate metrics suitable for Prometheus. In the best case scenario, a monitoring system has a similar enough data model to Prometheus that you can automatically determine how to transform metrics. This is the case for [Cloudwatch](https://github.com/prometheus/cloudwatch_exporter), [SNMP](https://github.com/prometheus/snmp_exporter) and [collectd](https://github.com/prometheus/collectd_exporter). At most, we need the ability to let the user select which metrics they want to pull out.

In other cases, metrics from the system are completely non-standard, depending on the usage of the system and the underlying application.  In that case the user has to tell us how to transform the metrics. The [JMX exporter](https://github.com/prometheus/jmx_exporter) is the worst offender here, with the [Graphite](https://github.com/prometheus/graphite_exporter) and [StatsD](https://github.com/prometheus/statsd_exporter) exporters also requiring configuration to extract labels.

Ensuring the exporter works out of the box without configuration, and providing a selection of example configurations for transformation if required, is advised.

YAML is the standard Prometheus configuration format, all configuration should use YAML by default.

## Metrics

### Naming

Follow the [best practices on metric naming](https://prometheus.io/docs/practices/naming).

Generally metric names should allow someone who is familiar with Prometheus but not a particular system to make a good guess as to what a metric means.  A metric named `http_requests_total` is not extremely useful - are these being measured as they come in, in some filter or when they get to the user’s code?  And `requests_total` is even worse, what type of requests?

With direct instrumentation, a given metric should exist within exactly one file. Accordingly, within exporters and collectors, a metric should apply to exactly one subsystem and be named accordingly.

Metric names should never be procedurally generated, except when writing a custom collector or exporter.

Metric names for applications should generally be prefixed by the exporter name, e.g. `haproxy_up`.

Metrics must use base units (e.g. seconds, bytes) and leave converting them to something more readable to graphing tools. No matter what units you end up using, the units in the metric name must match the units in use. Similarly, expose ratios, not percentages. Even better, specify a counter for each of the two components of the ratio.

Metric names should not include the labels that they’re exported with, e.g. `by_type`, as that won’t make sense if the label is aggregated away.

The one exception is when you’re exporting the same data with different labels via multiple metrics, in which case that’s usually the sanest way to distinguish them. For direct instrumentation, this should only come up when exporting a single metric with all the labels would have too high a cardinality.

Prometheus metrics and label names are written in `snake_case`. Converting `camelCase` to `snake_case` is desirable, though doing so automatically doesn’t always produce nice results for things like `myTCPExample` or `isNaN` so sometimes it’s best to leave them as-is.

Exposed metrics should not contain colons, these are reserved for user defined recording rules to use when aggregating.

Only `[a-zA-Z0-9:_]` are valid in metric names.

The `_sum`, `_count`, `_bucket` and `_total` suffixes are used by Summaries, Histograms and Counters. Unless you’re producing one of those, avoid these suffixes.

`_total` is a convention for counters, you should use it if you’re using the COUNTER type.

The `process_` and `scrape_` prefixes are reserved. It’s okay to add your own prefix on to these if they follow matching semantics. For example, Prometheus has `scrape_duration_seconds` for how long a scrape took, it's good practice to also have an exporter-centric metric, e.g. `jmx_scrape_duration_seconds`, saying how long the specific exporter took to do its thing. For process stats where you have access to the PID, both Go and Python offer collectors that’ll handle this for you. A good example of this is the [HAProxy exporter](https://github.com/prometheus/haproxy_exporter).

When you have a successful request count and a failed request count, the best way to expose this is as one metric for total requests and another metric for failed requests. This makes it easy to calculate the failure ratio. Do not use one metric with a failed or success label. Similarly, with hit or miss for caches, it’s better to have one metric for total and another for hits.

Consider the likelihood that someone using monitoring will do a code or web search for the metric name. If the names are very well-established and unlikely to be used outside of the realm of people used to those names, for example SNMP and network engineers, then leaving them as-is may be a good idea. This logic doesn’t apply for all exporters, for example the MySQL exporter metrics may be used by a variety of people, not just DBAs. A `HELP` string with the original name can provide most of the same benefits as using the original names.

### Labels

Read the [general advice](https://prometheus.io/docs/practices/instrumentation/#things-to-watch-out-for) on labels.

Avoid `type` as a label name, it’s too generic and often meaningless. You should also try where possible to avoid names that are likely to clash with target labels, such as `region`, `zone`, `cluster`, `availability_zone`, `az`, `datacenter`, `dc`, `owner`, `customer`, `stage`, `service`, `environment` and `env`. If, however, that’s what the application calls some resource, it’s best not to cause confusion by renaming it.

Avoid the temptation to put things into one metric just because they share a prefix. Unless you’re sure something makes sense as one metric, multiple metrics is safer.

The label `le` has special meaning for Histograms, and `quantile` for Summaries. Avoid these labels generally.

Read/write and send/receive are best as separate metrics, rather than as a label. This is usually because you care about only one of them at a time, and it is easier to use them that way.

The rule of thumb is that one metric should make sense when summed or averaged.  There is one other case that comes up with exporters, and that’s where the data is fundamentally tabular and doing otherwise would require users to do regexes on metric names to be usable. Consider the voltage sensors on your motherboard, while doing math across them is meaningless, it makes sense to have them in one metric rather than having one metric per sensor. All values within a metric should (almost) always have the same unit, for example consider if fan speeds were mixed in with the voltages, and you had no way to automatically separate them.

Don’t do this:

```
my_metric{label="a"} 1
my_metric{label="b"} 6
my_metric{label="total"} 7
```

or this:

```
my_metric{label="a"} 1
my_metric{label="b"} 6
my_metric{} 7
```

The former breaks for people who do a `sum()` over your metric, and the latter breaks sum and is quite difficult to work with. Some client libraries, for example Go, will actively try to stop you doing the latter in a custom collector, and all client libraries should stop you from doing the latter with direct instrumentation. Never do either of these, rely on Prometheus aggregation instead.

If your monitoring exposes a total like this, drop the total. If you have to keep it around for some reason, for example the total includes things not counted individually, use different metric names.

Instrumentation labels should be minimal, every extra label is one more that users need to consider when writing their PromQL. Accordingly, avoid having instrumentation labels which could be removed without affecting the uniqueness of the time series. Additional information around a metric can be added via an info metric, for an example see below how to handle version numbers.

However, there are cases where it is expected that virtually all users of a metric will want the additional information. If so, adding a non-unique label, rather than an info metric, is the right solution. For example the [mysqld_exporter](https://github.com/prometheus/mysqld_exporter)'s `mysqld_perf_schema_events_statements_total`'s `digest` label is a hash of the full query pattern and is sufficient for uniqueness. However, it is of little use without the human readable `digest_text` label, which for long queries will contain only the start of the query pattern and is thus not unique. Thus we end up with both the `digest_text` label for humans and the `digest` label for uniqueness.

### Target labels, not static scraped labels

If you ever find yourself wanting to apply the same label to all of your metrics, stop.

There’s generally two cases where this comes up.

The first is for some label it would be useful to have on the metrics such as the version number of the software. Instead, use the approach described at [https://www.robustperception.io/how-to-have-labels-for-machine-roles/](http://www.robustperception.io/how-to-have-labels-for-machine-roles/).

The second case is when a label is really a target label. These are things like region, cluster names, and so on, that come from your infrastructure setup rather than the application itself. It’s not for an application to say where it fits in your label taxonomy, that’s for the person running the Prometheus server to configure and different people monitoring the same application may give it different names.

Accordingly, these labels belong up in the scrape configs of Prometheus via whatever service discovery you’re using. It’s okay to apply the concept of machine roles here as well, as it’s likely useful information for at least some people scraping it.

### Types

You should try to match up the types of your metrics to Prometheus types. This usually means counters and gauges. The `_count` and `_sum` of summaries are also relatively common, and on occasion you’ll see quantiles. Histograms are rare, if you come across one remember that the exposition format exposes cumulative values.

Often it won’t be obvious what the type of metric is, especially if you’re automatically processing a set of metrics. In general `UNTYPED` is a safe default.

Counters can’t go down, so if you have a counter type coming from another instrumentation system that can be decremented, for example Dropwizard metrics then it's not a counter, it's a gauge. `UNTYPED` is probably the best type to use there, as `GAUGE` would be misleading if it were being used as a counter.

### Help strings

When you’re transforming metrics it’s useful for users to be able to track back to what the original was, and what rules were in play that caused that transformation. Putting in the name of the collector or exporter, the ID of any rule that was applied and the name and details of the original metric into the help string will greatly aid users.

Prometheus doesn’t like one metric having different help strings. If you’re making one metric from many others, choose one of them to put in the help string.

For examples of this, the SNMP exporter uses the OID and the JMX exporter puts in a sample mBean name. The [HAProxy exporter](https://github.com/prometheus/haproxy_exporter) has hand-written strings. The [node exporter](https://github.com/prometheus/node_exporter) also has a wide variety of examples.

### Drop less useful statistics

Some instrumentation systems expose 1m, 5m, 15m rates, average rates since application start (these are called `mean` in Dropwizard metrics for example) in addition to minimums, maximums and standard deviations.

These should all be dropped, as they’re not very useful and add clutter. Prometheus can calculate rates itself, and usually more accurately as the averages exposed are usually exponentially decaying. You don’t know what time the min or max were calculated over, and the standard deviation is statistically useless and you can always expose sum of squares, `_sum` and `_count` if you ever need to calculate it.

Quantiles have related issues, you may choose to drop them or put them in a Summary.

### Dotted strings

Many monitoring systems don’t have labels, instead doing things like `my.class.path.mymetric.labelvalue1.labelvalue2.labelvalue3`.

The [Graphite](https://github.com/prometheus/graphite_exporter) and [StatsD](https://github.com/prometheus/statsd_exporter) exporters share a way of transforming these with a small configuration language. Other exporters should implement the same. The transformation is currently implemented only in Go, and would benefit from being factored out into a separate library.

## Collectors

When implementing the collector for your exporter, you should never use the usual direct instrumentation approach and then update the metrics on each scrape.

Rather create new metrics each time. In Go this is done with [MustNewConstMetric](https://godoc.org/github.com/prometheus/client_golang/prometheus#MustNewConstMetric) in your `Collect()` method. For Python see https://github.com/prometheus/client_python#custom-collectors and for Java generate a `List<MetricFamilySamples>` in your collect method, see [StandardExports.java](https://github.com/prometheus/client_java/blob/master/simpleclient_hotspot/src/main/java/io/prometheus/client/hotspot/StandardExports.java) for an example.

The reason for this is two-fold. Firstly, two scrapes could happen at the same time, and direct instrumentation uses what are effectively file-level global variables, so you’ll get race conditions. Secondly, if a label value disappears, it’ll still be exported.

Instrumenting your exporter itself via direct instrumentation is fine, e.g. total bytes transferred or calls performed by the exporter across all scrapes.  For exporters such as the [blackbox exporter](https://github.com/prometheus/blackbox_exporter) and [SNMP exporter](https://github.com/prometheus/snmp_exporter), which aren’t tied to a single target, these should only be exposed on a vanilla `/metrics` call, not on a scrape of a particular target.

### Metrics about the scrape itself

Sometimes you’d like to export metrics that are about the scrape, like how long it took or how many records you processed.

These should be exposed as gauges as they’re about an event, the scrape, and the metric name prefixed by the exporter name, for example `jmx_scrape_duration_seconds`. Usually the `_exporter` is excluded and if the exporter also makes sense to use as just a collector, then definitely exclude it.

### Machine and process metrics

Many systems, for example Elasticsearch, expose machine metrics such as CPU, memory and filesystem information. As the [node exporter](https://github.com/prometheus/node_exporter) provides these in the Prometheus ecosystem, such metrics should be dropped.

In the Java world, many instrumentation frameworks expose process-level and JVM-level stats such as CPU and GC. The Java client and JMX exporter already include these in the preferred form via [DefaultExports.java](https://github.com/prometheus/client_java/blob/master/simpleclient_hotspot/src/main/java/io/prometheus/client/hotspot/DefaultExports.java), so these should also be dropped.

Similarly with other languages and frameworks.

## Deployment

Each exporter should monitor exactly one instance application, preferably sitting right beside it on the same machine. That means for every HAProxy you run, you run a `haproxy_exporter` process. For every machine with a Mesos worker, you run the [Mesos exporter](https://github.com/mesosphere/mesos_exporter) on it, and another one for the master, if a machine has both.

The theory behind this is that for direct instrumentation this is what you’d be doing, and we’re trying to get as close to that as we can in other layouts.  This means that all service discovery is done in Prometheus, not in exporters.  This also has the benefit that Prometheus has the target information it needs to allow users probe your service with the [blackbox exporter](https://github.com/prometheus/blackbox_exporter).

There are two exceptions:

The first is where running beside the application you are monitoring is completely nonsensical. The SNMP, blackbox and IPMI exporters are the main examples of this. The IPMI and SNMP exporters as the devices are often black boxes that it’s impossible to run code on (though if you could run a node exporter on them instead that’d be better), and the blackbox exporter where you’re monitoring something like a DNS name, where there’s also nothing to run on. In this case, Prometheus should still do service discovery, and pass on the target to be scraped. See the blackbox and SNMP exporters for examples.

Note that it is only currently possible to write this type of exporter with the Go, Python and Java client libraries.

The second exception is where you’re pulling some stats out of a random instance of a system and don’t care which one you’re talking to. Consider a set of MySQL replicas you wanted to run some business queries against the data to then export. Having an exporter that uses your usual load balancing approach to talk to one replica is the sanest approach.

This doesn’t apply when you’re monitoring a system with master-election, in that case you should monitor each instance individually and deal with the "masterness" in Prometheus. This is as there isn’t always exactly one master, and changing what a target is underneath Prometheus’s feet will cause oddities.

### Scheduling

Metrics should only be pulled from the application when Prometheus scrapes them, exporters should not perform scrapes based on their own timers. That is, all scrapes should be synchronous.

Accordingly, you should not set timestamps on the metrics you expose, let Prometheus take care of that. If you think you need timestamps, then you probably need the [Pushgateway](https://prometheus.io/docs/instrumenting/pushing/) instead.

If a metric is particularly expensive to retrieve, i.e. takes more than a minute, it is acceptable to cache it. This should be noted in the `HELP` string.

The default scrape timeout for Prometheus is 10 seconds. If your exporter can be expected to exceed this, you should explicitly call this out in your user documentation.

### Pushes

Some applications and monitoring systems only push metrics, for example StatsD, Graphite and collectd.

There are two considerations here.

Firstly, when do you expire metrics? Collectd and things talking to Graphite both export regularly, and when they stop we want to stop exposing the metrics.  Collectd includes an expiry time so we use that, Graphite doesn’t so it is a flag on the exporter.

StatsD is a bit different, as it is dealing with events rather than metrics. The best model is to run one exporter beside each application and restart them when the application restarts so that the state is cleared.

Secondly, these sort of systems tend to allow your users to send either deltas or raw counters. You should rely on the raw counters as far as possible, as that’s the general Prometheus model.

For service-level metrics, e.g. service-level batch jobs, you should have your exporter push into the Pushgateway and exit after the event rather than handling the state yourself. For instance-level batch metrics, there is no clear pattern yet. The options are either to abuse the node exporter’s textfile collector, rely on in-memory state (probably best if you don’t need to persist over a reboot) or implement similar functionality to the textfile collector.

### Failed scrapes

There are currently two patterns for failed scrapes where the application you’re talking to doesn’t respond or has other problems.

The first is to return a 5xx error.

The second is to have a `myexporter_up`, e.g. `haproxy_up`, variable that has a value of 0 or 1 depending on whether the scrape worked.

The latter is better where there’s still some useful metrics you can get even with a failed scrape, such as the HAProxy exporter providing process stats. The former is a tad easier for users to deal with, as [`up` works in the usual way](https://prometheus.io/docs/concepts/jobs_instances/#automatically-generated-labels-and-time-series), although you can’t distinguish between the exporter being down and the application being down.

### Landing page

It’s nicer for users if visiting `http://yourexporter/` has a simple HTML page with the name of the exporter, and a link to the `/metrics` page.

### Port numbers

A user may have many exporters and Prometheus components on the same machine, so to make that easier each has a unique port number.

https://github.com/prometheus/prometheus/wiki/Default-port-allocations is where we track them, this is publicly editable.

Feel free to grab the next free port number when developing your exporter, preferably before publicly announcing it. If you’re not ready to release yet, putting your username and WIP is fine.

This is a registry to make our users’ lives a little easier, not a commitment to develop particular exporters. For exporters for internal applications we recommend using ports outside of the range of default port allocations.

## Announcing

Once you’re ready to announce your exporter to the world, email the mailing list and send a PR to add it to [the list of available exporters](https://github.com/prometheus/docs/blob/main/content/docs/instrumenting/exporters.md).

# Exposition formats

- [Text-based format ](https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format)

- - [Basic info ](https://prometheus.io/docs/instrumenting/exposition_formats/#basic-info)
  - [Text format details ](https://prometheus.io/docs/instrumenting/exposition_formats/#text-format-details)
  - [Text format example ](https://prometheus.io/docs/instrumenting/exposition_formats/#text-format-example)

- [OpenMetrics Text Format ](https://prometheus.io/docs/instrumenting/exposition_formats/#openmetrics-text-format)

- - [Exemplars (Experimental) ](https://prometheus.io/docs/instrumenting/exposition_formats/#exemplars-experimental)

- [Historical versions ](https://prometheus.io/docs/instrumenting/exposition_formats/#historical-versions)

Metrics can be exposed to Prometheus using a simple [text-based](https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format) exposition format. There are various [client libraries](https://prometheus.io/docs/instrumenting/clientlibs/) that implement this format for you. If your preferred language doesn't have a client library you can [create your own](https://prometheus.io/docs/instrumenting/writing_clientlibs/).

**NOTE:** Some earlier versions of Prometheus supported an exposition format based on [Protocol Buffers](https://developers.google.com/protocol-buffers/) (aka Protobuf) in addition to the current text-based format. As of version 2.0, however, Prometheus no longer supports the Protobuf-based format. You can read about the reasoning behind this change in [this document](https://github.com/OpenObservability/OpenMetrics/blob/main/legacy/markdown/protobuf_vs_text.md). However, beginning with Prometheus v2.40, there is experimental support for native histograms, which – at least in its initial experimental state – utilizes the old Protobuf format (with some newer additions) again. Therefore, a very recent Prometheus server with the experimental native histogram support enabled, will again be able to ingest the Protobuf format. This support is experimental and might get removed again.

## Text-based format

As of Prometheus version 2.0, all processes that expose metrics to Prometheus need to use a text-based format. In this section you can find some [basic information](https://prometheus.io/docs/instrumenting/exposition_formats/#basic-info) about this format as well as a more [detailed breakdown](https://prometheus.io/docs/instrumenting/exposition_formats/#text-format-details) of the format.

### Basic info

| Aspect                               | Description                                                  |
| ------------------------------------ | ------------------------------------------------------------ |
| **Inception**                        | April 2014                                                   |
| **Supported in**                     | Prometheus version `>=0.4.0`                                 |
| **Transmission**                     | HTTP                                                         |
| **Encoding**                         | UTF-8, `\n` line endings                                     |
| **HTTP `Content-Type`**              | `text/plain; version=0.0.4` (A missing `version` value will lead to a fall-back to the most recent text format version.) |
| **Optional HTTP `Content-Encoding`** | `gzip`                                                       |
| **Advantages**                       | Human-readable Easy to assemble, especially for minimalistic cases (no nesting required) Readable line by line (with the exception of type hints and docstrings) |
| **Limitations**                      | Verbose Types and docstrings not integral part of the syntax, meaning little-to-nonexistent metric contract validation Parsing cost |
| **Supported metric primitives**      | Counter Gauge Histogram Summary Untyped                      |

### Text format details

Prometheus' text-based format is line oriented. Lines are separated by a line feed character (`\n`). The last line must end with a line feed character. Empty lines are ignored.

#### Line format

Within a line, tokens can be separated by any number of blanks and/or tabs (and must be separated by at least one if they would otherwise merge with the previous token). Leading and trailing whitespace is ignored.

#### Comments, help text, and type information

Lines with a `#` as the first non-whitespace character are comments. They are ignored unless the first token after `#` is either `HELP` or `TYPE`. Those lines are treated as follows: If the token is `HELP`, at least one more token is expected, which is the metric name. All remaining tokens are considered the docstring for that metric name. `HELP` lines may contain any sequence of UTF-8 characters (after the metric name), but the backslash and the line feed characters have to be escaped as `\\` and `\n`, respectively. Only one `HELP` line may exist for any given metric name.

If the token is `TYPE`, exactly two more tokens are expected. The first is the metric name, and the second is either `counter`, `gauge`, `histogram`, `summary`, or `untyped`, defining the type for the metric of that name. Only one `TYPE` line may exist for a given metric name. The `TYPE` line for a metric name must appear before the first sample is reported for that metric name. If there is no `TYPE` line for a metric name, the type is set to `untyped`.

The remaining lines describe samples (one per line) using the following syntax ([EBNF](https://en.wikipedia.org/wiki/Extended_Backus–Naur_form)):

```
metric_name [
  "{" label_name "=" `"` label_value `"` { "," label_name "=" `"` label_value `"` } [ "," ] "}"
] value [ timestamp ]
```

In the sample syntax:

-  `metric_name` and `label_name` carry the usual Prometheus expression language restrictions.
- `label_value` can be any sequence of UTF-8 characters, but the backslash (`\`), double-quote (`"`), and line feed (`\n`) characters have to be escaped as `\\`, `\"`, and `\n`, respectively.
- `value` is a float represented as required by Go's [`ParseFloat()`](https://golang.org/pkg/strconv/#ParseFloat) function. In addition to standard numerical values, `NaN`, `+Inf`, and `-Inf` are valid values representing not a number, positive infinity, and negative infinity, respectively.
- The `timestamp` is an `int64` (milliseconds since epoch, i.e. 1970-01-01 00:00:00 UTC, excluding leap seconds), represented as required by Go's [`ParseInt()`](https://golang.org/pkg/strconv/#ParseInt) function.

#### Grouping and sorting

All lines for a given metric must be provided as one single group, with the optional `HELP` and `TYPE` lines first (in no particular order). Beyond that, reproducible sorting in repeated expositions is preferred but not required, i.e. do not sort if the computational cost is prohibitive.

Each line must have a unique combination of a metric name and labels. Otherwise, the ingestion behavior is undefined.

#### Histograms and summaries

The `histogram` and `summary` types are difficult to represent in the text format. The following conventions apply:

- The sample sum for a summary or histogram named `x` is given as a separate sample named `x_sum`.
- The sample count for a summary or histogram named `x` is given as a separate sample named `x_count`.
- Each quantile of a summary named `x` is given as a separate sample line with the same name `x` and a label `{quantile="y"}`.
- Each bucket count of a histogram named `x` is given as a separate sample line with the name `x_bucket` and a label `{le="y"}` (where `y` is the upper bound of the bucket).
- A histogram *must* have a bucket with `{le="+Inf"}`. Its value *must* be identical to the value of `x_count`.
- The buckets of a histogram and the quantiles of a summary must  appear in increasing numerical order of their label values (for the `le` or the `quantile` label, respectively).

### Text format example

Below is an example of a full-fledged Prometheus metric exposition, including comments, `HELP` and `TYPE` expressions, a histogram, a summary, character escaping examples, and more.

```
# HELP http_requests_total The total number of HTTP requests.
# TYPE http_requests_total counter
http_requests_total{method="post",code="200"} 1027 1395066363000
http_requests_total{method="post",code="400"}    3 1395066363000

# Escaping in label values:
msdos_file_access_time_seconds{path="C:\\DIR\\FILE.TXT",error="Cannot find file:\n\"FILE.TXT\""} 1.458255915e9

# Minimalistic line:
metric_without_timestamp_and_labels 12.47

# A weird metric from before the epoch:
something_weird{problem="division by zero"} +Inf -3982045

# A histogram, which has a pretty complex representation in the text format:
# HELP http_request_duration_seconds A histogram of the request duration.
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.05"} 24054
http_request_duration_seconds_bucket{le="0.1"} 33444
http_request_duration_seconds_bucket{le="0.2"} 100392
http_request_duration_seconds_bucket{le="0.5"} 129389
http_request_duration_seconds_bucket{le="1"} 133988
http_request_duration_seconds_bucket{le="+Inf"} 144320
http_request_duration_seconds_sum 53423
http_request_duration_seconds_count 144320

# Finally a summary, which has a complex representation, too:
# HELP rpc_duration_seconds A summary of the RPC duration in seconds.
# TYPE rpc_duration_seconds summary
rpc_duration_seconds{quantile="0.01"} 3102
rpc_duration_seconds{quantile="0.05"} 3272
rpc_duration_seconds{quantile="0.5"} 4773
rpc_duration_seconds{quantile="0.9"} 9001
rpc_duration_seconds{quantile="0.99"} 76656
rpc_duration_seconds_sum 1.7560473e+07
rpc_duration_seconds_count 2693
```

## OpenMetrics Text Format

[OpenMetrics](https://github.com/OpenObservability/OpenMetrics) is the an effort to standardize metric wire formatting built off of Prometheus text format. It is possible to scrape targets and it is also available to use for federating metrics since at least v2.23.0.

### Exemplars (Experimental)

Utilizing the OpenMetrics format allows for the exposition and querying of [Exemplars](https://github.com/OpenObservability/OpenMetrics/blob/main/specification/OpenMetrics.md#exemplars). Exemplars provide a point in time snapshot related to a metric set for  an otherwise summarized MetricFamily. Additionally they may have a Trace ID attached to them which when used to together with a tracing system can provide more detailed information related to  the specific service.

To enable this experimental feature you must have at least version v2.26.0 and add `--enable-feature=exemplar-storage` to your arguments.

## Historical versions

For details on historical format versions, see the legacy [Client Data Exposition Format](https://docs.google.com/document/d/1ZjyKiKxZV83VI9ZKAXRGKaUKK2BIWCT7oiGBKDBpjEY/edit?usp=sharing) document.

The current version of the original Protobuf format (with the recent extensions for native histograms) is maintained in the [prometheus/client_model repository](https://github.com/prometheus/client_model).