# Securing Prometheus API and UI endpoints using basic auth

- [Hashing a password ](https://prometheus.io/docs/guides/basic-auth/#hashing-a-password)
- [Creating web.yml ](https://prometheus.io/docs/guides/basic-auth/#creating-web-yml)
- [Launching Prometheus ](https://prometheus.io/docs/guides/basic-auth/#launching-prometheus)
- [Testing ](https://prometheus.io/docs/guides/basic-auth/#testing)
- [Summary ](https://prometheus.io/docs/guides/basic-auth/#summary)

Prometheus supports [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication) (aka "basic auth") for connections to the Prometheus [expression browser](https://prometheus.io/docs/visualization/browser) and [HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api).

**NOTE:** This tutorial covers basic auth connections *to* Prometheus instances. Basic auth is also supported for connections *from* Prometheus instances to [scrape targets](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config).

## Hashing a password

Let's say that you want to require a username and password from all  users accessing the Prometheus instance. For this example, use `admin` as the username and choose any password you'd like.

First, generate a [bcrypt](https://en.wikipedia.org/wiki/Bcrypt) hash of the password. To generate a hashed password, we will use python3-bcrypt.

Let's install it by running `apt install python3-bcrypt`, assuming you are running a debian-like distribution. Other alternatives exist to generate hashed passwords; for testing you can also use [bcrypt generators on the web](https://bcrypt-generator.com/).

Here is a python script which uses python3-bcrypt to prompt for a password and hash it:

```
import getpass
import bcrypt

password = getpass.getpass("password: ")
hashed_password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
print(hashed_password.decode())
```

Save that script as `gen-pass.py` and run it:

```
$ python3 gen-pass.py
```

That should prompt you for a password:

```
password:
$2b$12$hNf2lSsxfm0.i4a.1kVpSOVyBCfIB51VRjgBUyv6kdnyTlgWj81Ay
```

In this example, I used "test" as password.

Save that password somewhere, we will use it in the next steps!

## Creating web.yml

Let's create a web.yml file ([documentation](https://prometheus.io/docs/prometheus/latest/configuration/https/)), with the following content:

```
basic_auth_users:
    admin: $2b$12$hNf2lSsxfm0.i4a.1kVpSOVyBCfIB51VRjgBUyv6kdnyTlgWj81Ay
```

You can validate that file with `promtool check web-config web.yml`

```
$ promtool check web-config web.yml
web.yml SUCCESS
```

You can add multiple users to the file.

## Launching Prometheus

You can launch prometheus with the web configuration file as follows:

```
$ prometheus --web.config.file=web.yml
```

## Testing

You can use cURL to interact with your setup. Try this request:

```
curl --head http://localhost:9090/graph
```

This will return a `401 Unauthorized` response because you've failed to supply a valid username and password.

To successfully access Prometheus endpoints using basic auth, for example the `/metrics` endpoint, supply the proper username using the `-u` flag and supply the password when prompted:

```
curl -u admin http://localhost:9090/metrics
Enter host password for user 'admin':
```

That should return Prometheus metrics output, which should look something like this:

```
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0.0001343
go_gc_duration_seconds{quantile="0.25"} 0.0002032
go_gc_duration_seconds{quantile="0.5"} 0.0004485
...
```

## Summary

In this guide, you stored a username and a hashed password in a `web.yml` file, launched prometheus with the parameter required to use the  credentials in that file to authenticate users accessing Prometheus'  HTTP endpoints.

# Monitoring Docker container metrics using cAdvisor

- [Prometheus configuration ](https://prometheus.io/docs/guides/cadvisor/#prometheus-configuration)
- [Docker Compose configuration ](https://prometheus.io/docs/guides/cadvisor/#docker-compose-configuration)
- [Exploring the cAdvisor web UI ](https://prometheus.io/docs/guides/cadvisor/#exploring-the-cadvisor-web-ui)
- [Exploring metrics in the expression browser ](https://prometheus.io/docs/guides/cadvisor/#exploring-metrics-in-the-expression-browser)
- [Other expressions ](https://prometheus.io/docs/guides/cadvisor/#other-expressions)
- [Summary ](https://prometheus.io/docs/guides/cadvisor/#summary)

[cAdvisor](https://github.com/google/cadvisor) (short for **c**ontainer **Advisor**) analyzes and exposes resource usage and performance data from running  containers. cAdvisor exposes Prometheus metrics out of the box. In this  guide, we will:

- create a local multi-container [Docker Compose](https://docs.docker.com/compose/) installation that includes containers running Prometheus, cAdvisor, and a [Redis](https://redis.io/) server, respectively
- examine some container metrics produced by the Redis container, collected by cAdvisor, and scraped by Prometheus

## Prometheus configuration

First, you'll need to [configure Prometheus](https://prometheus.io/docs/prometheus/latest/configuration/configuration) to scrape metrics from cAdvisor. Create a `prometheus.yml` file and populate it with this configuration:

```
scrape_configs:
- job_name: cadvisor
  scrape_interval: 5s
  static_configs:
  - targets:
    - cadvisor:8080
```

## Docker Compose configuration

Now we'll need to create a Docker Compose [configuration](https://docs.docker.com/compose/compose-file/) that specifies which containers are part of our installation as well as which ports are exposed by each container, which volumes are used, and  so on.

In the same folder where you created the [`prometheus.yml`](https://prometheus.io/docs/guides/cadvisor/#prometheus-configuration) file, create a `docker-compose.yml` file and populate it with this Docker Compose configuration:

```
version: '3.2'
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
    - 9090:9090
    command:
    - --config.file=/etc/prometheus/prometheus.yml
    volumes:
    - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    depends_on:
    - cadvisor
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
    - 8080:8080
    volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:rw
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
    depends_on:
    - redis
  redis:
    image: redis:latest
    container_name: redis
    ports:
    - 6379:6379
```

This configuration instructs Docker Compose to run three services, each of which corresponds to a [Docker](https://docker.com) container:

1. The `prometheus` service uses the local `prometheus.yml` configuration file (imported into the container by the `volumes` parameter).
2. The `cadvisor` service exposes port 8080 (the default port for cAdvisor metrics) and relies on a variety of local volumes (`/`, `/var/run`, etc.).
3. The `redis` service is a standard Redis server. cAdvisor  will gather container metrics from this container automatically, i.e.  without any further configuration.

To run the installation:

```
docker-compose up
```

If Docker Compose successfully starts up all three containers, you should see output like this:

```
prometheus  | level=info ts=2018-07-12T22:02:40.5195272Z caller=main.go:500 msg="Server is ready to receive web requests."
```

You can verify that all three containers are running using the [`ps`](https://docs.docker.com/compose/reference/ps/) command:

```
docker-compose ps
```

Your output will look something like this:

```
   Name                 Command               State           Ports
----------------------------------------------------------------------------
cadvisor     /usr/bin/cadvisor -logtostderr   Up      8080/tcp
prometheus   /bin/prometheus --config.f ...   Up      0.0.0.0:9090->9090/tcp
redis        docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
```

## Exploring the cAdvisor web UI

You can access the cAdvisor [web UI](https://github.com/google/cadvisor/blob/master/docs/web.md) at `http://localhost:8080`. You can explore stats and graphs for specific Docker containers in our installation at `http://localhost:8080/docker/<container>`. Metrics for the Redis container, for example, can be accessed at `http://localhost:8080/docker/redis`, Prometheus at `http://localhost:8080/docker/prometheus`, and so on.

## Exploring metrics in the expression browser

cAdvisor's web UI is a useful interface for exploring the kinds of  things that cAdvisor monitors, but it doesn't provide an interface for  exploring container *metrics*. For that we'll need the Prometheus [expression browser](https://prometheus.io/docs/visualization/browser), which is available at `http://localhost:9090/graph`. You can enter Prometheus expressions into the expression bar, which looks like this:

![Prometheus expression bar](https://prometheus.io/assets/prometheus-expression-bar.png)

Let's start by exploring the `container_start_time_seconds` metric, which records the start time of containers (in seconds). You can select for specific containers by name using the `name="<container_name>"` expression. The container name corresponds to the `container_name` parameter in the Docker Compose configuration. The [`container_start_time_seconds{name="redis"}`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=container_start_time_seconds{name%3D"redis"}&g0.tab=1) expression, for example, shows the start time for the `redis` container.

**NOTE:** A full listing of cAdvisor-gathered container metrics exposed to Prometheus can be found in the [cAdvisor documentation](https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md).

## Other expressions

The table below lists some other example expressions

| Expression                                                   | Description                                                  | For                   |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :-------------------- |
| [`rate(container_cpu_usage_seconds_total{name="redis"}[1m\])`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(container_cpu_usage_seconds_total{name%3D"redis"}[1m])&g0.tab=1) | The [cgroup](https://en.wikipedia.org/wiki/Cgroups)'s CPU usage in the last minute | The `redis` container |
| [`container_memory_usage_bytes{name="redis"}`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=container_memory_usage_bytes{name%3D"redis"}&g0.tab=1) | The cgroup's total memory usage (in bytes)                   | The `redis` container |
| [`rate(container_network_transmit_bytes_total[1m\])`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(container_network_transmit_bytes_total[1m])&g0.tab=1) | Bytes transmitted over the network by the container per second in the last minute | All containers        |
| [`rate(container_network_receive_bytes_total[1m\])`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(container_network_receive_bytes_total[1m])&g0.tab=1) | Bytes received over the network by the container per second in the last minute | All containers        |

## Summary

In this guide, we ran three separate containers in a single  installation using Docker Compose: a Prometheus container scraped  metrics from a cAdvisor container which, in turns, gathered metrics  produced by a Redis container. We then explored a handful of cAdvisor  container metrics using the Prometheus expression browser.

# Use file-based service discovery to discover scrape targets

- [Installing and running the Node Exporter ](https://prometheus.io/docs/guides/file-sd/#installing-and-running-the-node-exporter)
- [Installing, configuring, and running Prometheus ](https://prometheus.io/docs/guides/file-sd/#installing-configuring-and-running-prometheus)
- [Exploring the discovered services' metrics ](https://prometheus.io/docs/guides/file-sd/#exploring-the-discovered-services-metrics)
- [Changing the targets list dynamically ](https://prometheus.io/docs/guides/file-sd/#changing-the-targets-list-dynamically)
- [Summary ](https://prometheus.io/docs/guides/file-sd/#summary)

Prometheus offers a variety of [service discovery options](https://github.com/prometheus/prometheus/tree/main/discovery) for discovering scrape targets, including [Kubernetes](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config), [Consul](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#consul_sd_config), and many others. If you need to use a service discovery system that is  not currently supported, your use case may be best served by Prometheus' [file-based service discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#file_sd_config) mechanism, which enables you to list scrape targets in a JSON file (along with metadata about those targets).

In this guide, we will:

- Install and run a Prometheus [Node Exporter](https://prometheus.io/docs/guides/node-exporter) locally
- Create a `targets.json` file specifying the host and port information for the Node Exporter
- Install and run a Prometheus instance that is configured to discover the Node Exporter using the `targets.json` file

## Installing and running the Node Exporter

See [this section](https://prometheus.io/docs/guides/node-exporter#installing-and-running-the-node-exporter) of the [Monitoring Linux host metrics with the Node Exporter](https://prometheus.io/docs/guides/node-exporter) guide. The Node Exporter runs on port 9100. To ensure that the Node Exporter is exposing metrics:

```
curl http://localhost:9100/metrics
```

The metrics output should look something like this:

```
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0
go_gc_duration_seconds{quantile="0.25"} 0
go_gc_duration_seconds{quantile="0.5"} 0
...
```

## Installing, configuring, and running Prometheus

Like the Node Exporter, Prometheus is a single static binary that you can install via tarball. [Download the latest release](https://prometheus.io/download#prometheus) for your platform and untar it:

```
wget https://github.com/prometheus/prometheus/releases/download/v*/prometheus-*.*-amd64.tar.gz
tar xvf prometheus-*.*-amd64.tar.gz
cd prometheus-*.*
```

The untarred directory contains a `prometheus.yml` configuration file. Replace the current contents of that file with this:

```
scrape_configs:
- job_name: 'node'
  file_sd_configs:
  - files:
    - 'targets.json'
```

This configuration specifies that there is a job called `node` (for the Node Exporter) that retrieves host and port information for Node Exporter instances from a `targets.json` file.

Now create that `targets.json` file and add this content to it:

```
[
  {
    "labels": {
      "job": "node"
    },
    "targets": [
      "localhost:9100"
    ]
  }
]
```

**NOTE:** In this guide we'll work with JSON service  discovery configurations manually for the sake of brevity. In general,  however, we recommend that you use some kind of JSON-generating process  or tool instead.

This configuration specifies that there is a `node` job with one target: `localhost:9100`.

Now you can start up Prometheus:

```
./prometheus
```

If Prometheus has started up successfully, you should see a line like this in the logs:

```
level=info ts=2018-08-13T20:39:24.905651509Z caller=main.go:500 msg="Server is ready to receive web requests."
```

## Exploring the discovered services' metrics

With Prometheus up and running, you can explore metrics exposed by the `node` service using the Prometheus [expression browser](https://prometheus.io/docs/visualization/browser). If you explore the [`up{job="node"}`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=up{job%3D"node"}&g0.tab=1) metric, for example, you can see that the Node Exporter is being appropriately discovered.

## Changing the targets list dynamically

When using Prometheus' file-based service discovery mechanism, the  Prometheus instance will listen for changes to the file and  automatically update the scrape target list, without requiring an  instance restart. To demonstrate this, start up a second Node Exporter  instance on port 9200. First navigate to the directory containing the  Node Exporter binary and run this command in a new terminal window:

```
./node_exporter --web.listen-address=":9200"
```

Now modify the config in `targets.json` by adding an entry for the new Node Exporter:

```
[
  {
    "targets": [
      "localhost:9100"
    ],
    "labels": {
      "job": "node"
    }
  },
  {
    "targets": [
      "localhost:9200"
    ],
    "labels": {
      "job": "node"
    }
  }
]
```

When you save the changes, Prometheus will automatically be notified of the new list of targets. The [`up{job="node"}`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=up{job%3D"node"}&g0.tab=1) metric should display two instances with `instance` labels `localhost:9100` and `localhost:9200`.

## Summary

In this guide, you installed and ran a Prometheus Node Exporter and  configured Prometheus to discover and scrape metrics from the Node  Exporter using file-based service discovery.

# Instrumenting a Go application for Prometheus

- [Installation ](https://prometheus.io/docs/guides/go-application/#installation)
- [How Go exposition works ](https://prometheus.io/docs/guides/go-application/#how-go-exposition-works)
- [Adding your own metrics ](https://prometheus.io/docs/guides/go-application/#adding-your-own-metrics)
- [Other Go client features ](https://prometheus.io/docs/guides/go-application/#other-go-client-features)
- [Summary ](https://prometheus.io/docs/guides/go-application/#summary)

Prometheus has an official [Go client library](https://github.com/prometheus/client_golang) that you can use to instrument Go applications. In this guide, we'll  create a simple Go application that exposes Prometheus metrics via HTTP.

**NOTE:** For comprehensive API documentation, see the [GoDoc](https://godoc.org/github.com/prometheus/client_golang) for Prometheus' various Go libraries.

## Installation

You can install the `prometheus`, `promauto`, and `promhttp` libraries necessary for the guide using [`go get`](https://golang.org/doc/articles/go_command.html):

```
go get github.com/prometheus/client_golang/prometheus
go get github.com/prometheus/client_golang/prometheus/promauto
go get github.com/prometheus/client_golang/prometheus/promhttp
```

## How Go exposition works

To expose Prometheus metrics in a Go application, you need to provide a `/metrics` HTTP endpoint. You can use the [`prometheus/promhttp`](https://godoc.org/github.com/prometheus/client_golang/prometheus/promhttp) library's HTTP [`Handler`](https://godoc.org/github.com/prometheus/client_golang/prometheus/promhttp#Handler) as the handler function.

This minimal application, for example, would expose the default metrics for Go applications via `http://localhost:2112/metrics`:

```
package main

import (
        "net/http"

        "github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
        http.Handle("/metrics", promhttp.Handler())
        http.ListenAndServe(":2112", nil)
}
```

To start the application:

```
go run main.go
```

To access the metrics:

```
curl http://localhost:2112/metrics
```

## Adding your own metrics

The application [above](https://prometheus.io/docs/guides/go-application/#how-go-exposition-works) exposes only the default Go metrics. You can also register your own  custom application-specific metrics. This example application exposes a `myapp_processed_ops_total` [counter](https://prometheus.io/docs/concepts/metric_types/#counter) that counts the number of operations that have been processed thus far. Every 2 seconds, the counter is incremented by one.

```
package main

import (
        "net/http"
        "time"

        "github.com/prometheus/client_golang/prometheus"
        "github.com/prometheus/client_golang/prometheus/promauto"
        "github.com/prometheus/client_golang/prometheus/promhttp"
)

func recordMetrics() {
        go func() {
                for {
                        opsProcessed.Inc()
                        time.Sleep(2 * time.Second)
                }
        }()
}

var (
        opsProcessed = promauto.NewCounter(prometheus.CounterOpts{
                Name: "myapp_processed_ops_total",
                Help: "The total number of processed events",
        })
)

func main() {
        recordMetrics()

        http.Handle("/metrics", promhttp.Handler())
        http.ListenAndServe(":2112", nil)
}
```

To run the application:

```
go run main.go
```

To access the metrics:

```
curl http://localhost:2112/metrics
```

In the metrics output, you'll see the help text, type information, and current value of the `myapp_processed_ops_total` counter:

```
# HELP myapp_processed_ops_total The total number of processed events
# TYPE myapp_processed_ops_total counter
myapp_processed_ops_total 5
```

You can [configure](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) a locally running Prometheus instance to scrape metrics from the application. Here's an example `prometheus.yml` configuration:

```
scrape_configs:
- job_name: myapp
  scrape_interval: 10s
  static_configs:
  - targets:
    - localhost:2112
```

## Other Go client features

In this guide we covered just a small handful of features available  in the Prometheus Go client libraries. You can also expose other metrics types, such as [gauges](https://godoc.org/github.com/prometheus/client_golang/prometheus#Gauge) and [histograms](https://godoc.org/github.com/prometheus/client_golang/prometheus#Histogram), [non-global registries](https://godoc.org/github.com/prometheus/client_golang/prometheus#Registry), functions for [pushing metrics](https://godoc.org/github.com/prometheus/client_golang/prometheus/push) to Prometheus [PushGateways](https://prometheus.io/docs/instrumenting/pushing/), bridging Prometheus and [Graphite](https://godoc.org/github.com/prometheus/client_golang/prometheus/graphite), and more.

## Summary

In this guide, you created two sample Go applications that expose  metrics to Prometheus---one that exposes only the default Go metrics and one that also exposes a custom Prometheus counter---and configured a  Prometheus instance to scrape metrics from those applications.

# Understanding and using the multi-target exporter pattern

- [The multi-target exporter pattern? ](https://prometheus.io/docs/guides/multi-target-exporter/#the-multi-target-exporter-pattern)
- [Running multi-target exporters ](https://prometheus.io/docs/guides/multi-target-exporter/#running-multi-target-exporters)
- [Basic querying of multi-target exporters ](https://prometheus.io/docs/guides/multi-target-exporter/#basic-querying-of-multi-target-exporters)
- [Configuring modules ](https://prometheus.io/docs/guides/multi-target-exporter/#configuring-modules)
- [Querying multi-target exporters with Prometheus ](https://prometheus.io/docs/guides/multi-target-exporter/#querying-multi-target-exporters-with-prometheus)

This guide will introduce you to the multi-target exporter pattern. To achieve this we will:

- describe the multi-target exporter pattern and why it is used,
- run the [blackbox](https://github.com/prometheus/blackbox_exporter) exporter as an example of the pattern,
- configure a custom query module for the blackbox exporter,
- let the blackbox exporter run basic metric queries against the Prometheus [website](https://prometheus.io),
- examine a popular pattern of configuring Prometheus to scrape exporters using relabeling.

## The multi-target exporter pattern?

By multi-target [exporter](https://prometheus.io/docs/instrumenting/exporters/) pattern we refer to a specific design, in which:

- the exporter will get the target’s metrics via a network protocol.
- the exporter does not have to run on the machine the metrics are taken from.
- the exporter gets the targets and a query config string as parameters of Prometheus’ GET request.
- the exporter subsequently starts the scrape after getting Prometheus’ GET requests and once it is done with scraping.
- the exporter can query multiple targets.

This pattern is only used for certain exporters, such as the [blackbox](https://github.com/prometheus/blackbox_exporter) and the [SNMP exporter](https://github.com/prometheus/snmp_exporter).

The reason is that we either can’t run an exporter on the targets,  e.g. network gear speaking SNMP, or that we are explicitly interested in the distance, e.g. latency and reachability of a website from a  specific point outside of our network, a common use case for the [blackbox](https://github.com/prometheus/blackbox_exporter) exporter.

## Running multi-target exporters

Multi-target exporters are flexible regarding their environment and  can be run in many ways. As regular programs, in containers, as  background services, on baremetal, on virtual machines. Because they are queried and do query over network they do need appropriate open ports.  Otherwise they are frugal.

Now let’s try it out for yourself!

Use [Docker](https://www.docker.com/) to start a blackbox  exporter container by running this in a terminal. Depending on your  system configuration you might need to prepend the command with a `sudo`:

```
docker run -p 9115:9115 prom/blackbox-exporter
```

You should see a few log lines and if everything went well the last one should report `msg="Listening on address"` as seen here:

```
level=info ts=2018-10-17T15:41:35.4997596Z caller=main.go:324 msg="Listening on address" address=:9115
```

## Basic querying of multi-target exporters

There are two ways of querying:

1. Querying the exporter itself. It has its own metrics, usually available at `/metrics`.
2. Querying the exporter to scrape another target. Usually available at a "descriptive" endpoint, e.g. `/probe`. This is likely what you are primarily interested in, when using multi-target exporters.

You can manually try the first query type with curl in another terminal or use this [link](http://localhost:9115/metrics):



```
curl 'localhost:9115/metrics'
```

The response should be something like this:

```
# HELP blackbox_exporter_build_info A metric with a constant '1' value labeled by version, revision, branch, and goversion from which blackbox_exporter was built.
# TYPE blackbox_exporter_build_info gauge
blackbox_exporter_build_info{branch="HEAD",goversion="go1.10",revision="4a22506cf0cf139d9b2f9cde099f0012d9fcabde",version="0.12.0"} 1
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0
go_gc_duration_seconds{quantile="0.25"} 0
go_gc_duration_seconds{quantile="0.5"} 0
go_gc_duration_seconds{quantile="0.75"} 0
go_gc_duration_seconds{quantile="1"} 0
go_gc_duration_seconds_sum 0
go_gc_duration_seconds_count 0
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 9

[…]

# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 0.05
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1.048576e+06
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 7
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 7.8848e+06
# HELP process_start_time_seconds Start time of the process since unix epoch in seconds.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1.54115492874e+09
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 1.5609856e+07
```

Those are metrics in the Prometheus [format](https://prometheus.io/docs/instrumenting/exposition_formats/#text-format-example). They come from the exporter’s [instrumentation](https://prometheus.io/docs/practices/instrumentation/) and tell us about the state of the exporter itself while it is running. This is called whitebox monitoring and very useful in daily ops  practice. If you are curious, try out our guide on how to [instrument your own applications](https://prometheus.io/docs/guides/go-application/).

For the second type of querying we need to provide a target and  module as parameters in the HTTP GET Request. The target is a URI or IP  and the module must defined in the exporter’s configuration. The  blackbox exporter container comes with a meaningful default  configuration.
 We will use the target `prometheus.io` and the predefined module `http_2xx`. It tells the exporter to make a GET request like a browser would if you go to `prometheus.io` and to expect a [200 OK](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success) response.

You can now tell your blackbox exporter to query `prometheus.io` in the terminal with curl:

```
curl 'localhost:9115/probe?target=prometheus.io&module=http_2xx'
```

This will return a lot of metrics:

```
# HELP probe_dns_lookup_time_seconds Returns the time taken for probe dns lookup in seconds
# TYPE probe_dns_lookup_time_seconds gauge
probe_dns_lookup_time_seconds 0.061087943
# HELP probe_duration_seconds Returns how long the probe took to complete in seconds
# TYPE probe_duration_seconds gauge
probe_duration_seconds 0.065580871
# HELP probe_failed_due_to_regex Indicates if probe failed due to regex
# TYPE probe_failed_due_to_regex gauge
probe_failed_due_to_regex 0
# HELP probe_http_content_length Length of http content response
# TYPE probe_http_content_length gauge
probe_http_content_length 0
# HELP probe_http_duration_seconds Duration of http request by phase, summed over all redirects
# TYPE probe_http_duration_seconds gauge
probe_http_duration_seconds{phase="connect"} 0
probe_http_duration_seconds{phase="processing"} 0
probe_http_duration_seconds{phase="resolve"} 0.061087943
probe_http_duration_seconds{phase="tls"} 0
probe_http_duration_seconds{phase="transfer"} 0
# HELP probe_http_redirects The number of redirects
# TYPE probe_http_redirects gauge
probe_http_redirects 0
# HELP probe_http_ssl Indicates if SSL was used for the final redirect
# TYPE probe_http_ssl gauge
probe_http_ssl 0
# HELP probe_http_status_code Response HTTP status code
# TYPE probe_http_status_code gauge
probe_http_status_code 0
# HELP probe_http_version Returns the version of HTTP of the probe response
# TYPE probe_http_version gauge
probe_http_version 0
# HELP probe_ip_protocol Specifies whether probe ip protocol is IP4 or IP6
# TYPE probe_ip_protocol gauge
probe_ip_protocol 6
# HELP probe_success Displays whether or not the probe was a success
# TYPE probe_success gauge
probe_success 0
```

Notice that almost all metrics have a value of `0`. The last one reads `probe_success 0`. This means the prober could not successfully reach `prometheus.io`. The reason is hidden in the metric `probe_ip_protocol` with the value `6`. By default the prober uses [IPv6](https://en.wikipedia.org/wiki/IPv6) until told otherwise. But the Docker daemon blocks IPv6 until told  otherwise. Hence our blackbox exporter running in a Docker container  can’t connect via IPv6.

We could now either tell Docker to allow IPv6 or the blackbox  exporter to use IPv4. In the real world both can make sense and as so  often the answer to the question "what is to be done?" is "it depends".  Because this is an exporter guide we will change the exporter and take  the opportunity to configure a custom module.

## Configuring modules

The modules are predefined in a file inside the docker container called `config.yml` which is a copy of [blackbox.yml](https://github.com/prometheus/blackbox_exporter/blob/master/blackbox.yml) in the github repo.

We will copy this file, [adapt](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md) it to our own needs and tell the exporter to use our config file instead of the one included in the container.  

First download the file using curl or your browser:

```
curl -o blackbox.yml https://raw.githubusercontent.com/prometheus/blackbox_exporter/master/blackbox.yml
```

Open it in an editor. The first few lines look like this:

```
modules:
  http_2xx:
    prober: http
  http_post_2xx:
    prober: http
    http:
      method: POST
```

[YAML](https://en.wikipedia.org/wiki/YAML) uses whitespace indentation to express hierarchy, so you can recognise that two `modules` named `http_2xx` and `http_post_2xx` are defined, and that they both have a prober `http` and for one the method value is specifically set to `POST`.
 You will now change the module `http_2xx` by setting the `preferred_ip_protocol` of the prober `http` explicitly to the string `ip4`.

```
modules:
  http_2xx:
    prober: http
    http:
      preferred_ip_protocol: "ip4"
  http_post_2xx:
    prober: http
    http:
      method: POST
```

If you want to know more about the available probers and options check out the [documentation](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md).

Now we need to tell the blackbox exporter to use our freshly changed file. You can do that with the flag `--config.file="blackbox.yml"`. But because we are using Docker, we first must make this file [available](https://docs.docker.com/storage/bind-mounts/) inside the container using the `--mount` command.  

**NOTE:** If you are using macOS you first need to allow the Docker daemon to access the directory in which your `blackbox.yml` is. You can do that by clicking on the little Docker whale in menu bar and then on `Preferences`->`File Sharing`->`+`. Afterwards press `Apply & Restart`.

First you stop the old container by changing into its terminal and press `ctrl+c`. Make sure you are in the directory containing your `blackbox.yml`. Then you run this command. It is long, but we will explain it:



```
docker \
  run -p 9115:9115 \
  --mount type=bind,source="$(pwd)"/blackbox.yml,target=/blackbox.yml,readonly \
  prom/blackbox-exporter \
  --config.file="/blackbox.yml"
```

With this command, you told `docker` to:

1. `run` a container with the port `9115` outside the container mapped to the port `9115` inside of the container.
2. `mount` from your current directory (`$(pwd)` stands for print working directory) the file `blackbox.yml` into `/blackbox.yml` in `readonly` mode.
3. use the image `prom/blackbox-exporter` from [Docker hub](https://hub.docker.com/r/prom/blackbox-exporter/).
4. run the blackbox-exporter with the flag `--config.file` telling it to use `/blackbox.yml` as config file.

If everything is correct, you should see something like this:

```
level=info ts=2018-10-19T12:40:51.650462756Z caller=main.go:213 msg="Starting blackbox_exporter" version="(version=0.12.0, branch=HEAD, revision=4a22506cf0cf139d9b2f9cde099f0012d9fcabde)"
level=info ts=2018-10-19T12:40:51.653357722Z caller=main.go:220 msg="Loaded config file"
level=info ts=2018-10-19T12:40:51.65349635Z caller=main.go:324 msg="Listening on address" address=:9115
```

Now you can try our new IPv4-using module `http_2xx` in a terminal:

```
curl 'localhost:9115/probe?target=prometheus.io&module=http_2xx'
```

Which should return Prometheus metrics like this:

```
# HELP probe_dns_lookup_time_seconds Returns the time taken for probe dns lookup in seconds
# TYPE probe_dns_lookup_time_seconds gauge
probe_dns_lookup_time_seconds 0.02679421
# HELP probe_duration_seconds Returns how long the probe took to complete in seconds
# TYPE probe_duration_seconds gauge
probe_duration_seconds 0.461619124
# HELP probe_failed_due_to_regex Indicates if probe failed due to regex
# TYPE probe_failed_due_to_regex gauge
probe_failed_due_to_regex 0
# HELP probe_http_content_length Length of http content response
# TYPE probe_http_content_length gauge
probe_http_content_length -1
# HELP probe_http_duration_seconds Duration of http request by phase, summed over all redirects
# TYPE probe_http_duration_seconds gauge
probe_http_duration_seconds{phase="connect"} 0.062076202999999996
probe_http_duration_seconds{phase="processing"} 0.23481845699999998
probe_http_duration_seconds{phase="resolve"} 0.029594103
probe_http_duration_seconds{phase="tls"} 0.163420078
probe_http_duration_seconds{phase="transfer"} 0.002243199
# HELP probe_http_redirects The number of redirects
# TYPE probe_http_redirects gauge
probe_http_redirects 1
# HELP probe_http_ssl Indicates if SSL was used for the final redirect
# TYPE probe_http_ssl gauge
probe_http_ssl 1
# HELP probe_http_status_code Response HTTP status code
# TYPE probe_http_status_code gauge
probe_http_status_code 200
# HELP probe_http_uncompressed_body_length Length of uncompressed response body
# TYPE probe_http_uncompressed_body_length gauge
probe_http_uncompressed_body_length 14516
# HELP probe_http_version Returns the version of HTTP of the probe response
# TYPE probe_http_version gauge
probe_http_version 1.1
# HELP probe_ip_protocol Specifies whether probe ip protocol is IP4 or IP6
# TYPE probe_ip_protocol gauge
probe_ip_protocol 4
# HELP probe_ssl_earliest_cert_expiry Returns earliest SSL cert expiry in unixtime
# TYPE probe_ssl_earliest_cert_expiry gauge
probe_ssl_earliest_cert_expiry 1.581897599e+09
# HELP probe_success Displays whether or not the probe was a success
# TYPE probe_success gauge
probe_success 1
# HELP probe_tls_version_info Contains the TLS version used
# TYPE probe_tls_version_info gauge
probe_tls_version_info{version="TLS 1.3"} 1
```

You can see that the probe was successful and get many useful  metrics, like latency by phase, status code, ssl status or certificate  expiry in [Unix time](https://en.wikipedia.org/wiki/Unix_time).
 The blackbox exporter also offers a tiny web interface at [localhost:9115](http://localhost:9115) for you to check out the last few probes, the loaded config and debug information. It even offers a direct link to probe `prometheus.io`. Handy if you are wondering why something does not work.

## Querying multi-target exporters with Prometheus

So far, so good. Congratulate yourself. The blackbox exporter works  and you can manually tell it to query a remote target. You are almost  there. Now you need to tell Prometheus to do the queries for us.  

Below you find a minimal prometheus config. It is telling Prometheus to scrape the exporter itself as we did [before](https://prometheus.io/docs/guides/multi-target-exporter/#query-exporter) using `curl 'localhost:9115/metrics'`:

**NOTE:** If you use Docker for Mac or Docker for Windows, you can’t use `localhost:9115` in the last line, but must use `host.docker.internal:9115`. This has to do with the virtual machines used to implement Docker on  those operating systems. You should not use this in production.

`prometheus.yml` for Linux:

```
global:
  scrape_interval: 5s

scrape_configs:
- job_name: blackbox # To get metrics about the exporter itself
  metrics_path: /metrics
  static_configs:
    - targets:
      - localhost:9115
```

`prometheus.yml` for macOS and Windows:

```
global:
  scrape_interval: 5s

scrape_configs:
- job_name: blackbox # To get metrics about the exporter itself
  metrics_path: /metrics
  static_configs:
    - targets:
      - host.docker.internal:9115
```

Now run a Prometheus container and tell it to mount our config file  from above. Because of the way networking on the host is addressable  from the container you need to use a slightly different command on Linux than on MacOS and Windows.:



Run Prometheus on Linux (don’t use `--network="host"` in production):

```
docker \
  run --network="host"\
  --mount type=bind,source="$(pwd)"/prometheus.yml,target=/prometheus.yml,readonly \
  prom/prometheus \
  --config.file="/prometheus.yml"
```

Run Prometheus on MacOS and Windows:

```
docker \
  run -p 9090:9090 \
  --mount type=bind,source="$(pwd)"/prometheus.yml,target=/prometheus.yml,readonly \
  prom/prometheus \
  --config.file="/prometheus.yml"
```

This command works similarly to [running the blackbox exporter using a config file](https://prometheus.io/docs/guides/multi-target-exporter/#run-exporter).

If everything worked, you should be able to go to [localhost:9090/targets](http://localhost:9090/targets) and see under `blackbox` an endpoint with the state `UP` in green. If you get a red `DOWN` make sure that the blackbox exporter you started [above](https://prometheus.io/docs/guides/multi-target-exporter/#run-exporter) is still running. If you see nothing or a yellow `UNKNOWN` you are really fast and need to give it a few more seconds before reloading your browser’s tab.

To tell Prometheus to query `"localhost:9115/probe?target=prometheus.io&module=http_2xx"` you add another scrape job `blackbox-http` where you set the `metrics_path` to `/probe` and the parameters under `params:` in the Prometheus config file `prometheus.yml`:



```
global:
  scrape_interval: 5s

scrape_configs:
- job_name: blackbox # To get metrics about the exporter itself
  metrics_path: /metrics
  static_configs:
    - targets:
      - localhost:9115   # For Windows and macOS replace with - host.docker.internal:9115

- job_name: blackbox-http # To get metrics about the exporter’s targets
  metrics_path: /probe
  params:
    module: [http_2xx]
    target: [prometheus.io]
  static_configs:
    - targets:
      - localhost:9115   # For Windows and macOS replace with - host.docker.internal:9115
```

After saving the config file switch to the terminal with your Prometheus docker container and stop it by pressing `ctrl+C` and start it again to reload the configuration by using the existing [command](https://prometheus.io/docs/guides/multi-target-exporter/#run-prometheus).

The terminal should return the message `"Server is ready to receive web requests."` and after a few seconds you should start to see colourful graphs in [your Prometheus](http://localhost:9090/graph?g0.range_input=5m&g0.stacked=0&g0.expr=probe_http_duration_seconds&g0.tab=0).

This works, but it has a few disadvantages:

1. The actual targets are up in the param config, which is very unusual and hard to understand later.
2. The `instance` label has the value of the blackbox exporter’s address which is technically true, but not what we are interested in.
3. We can’t see which URL we probed. This is unpractical and will also mix up different metrics into one if we probe several URLs.

To fix this, we will use [relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config). Relabeling is useful here because behind the scenes many things in  Prometheus are configured with internal labels. The details are complicated and out of scope for this guide. Hence we  will limit ourselves to the necessary. But if you want to know more  check out this [talk](https://www.youtube.com/watch?v=b5-SvvZ7AwI). For now it suffices if you understand this:

- All labels starting with `__` are dropped after the scrape. Most internal labels start with `__`.
- You can set internal labels that are called `__param_<name>`. Those set URL parameter with the key `<name>` for the scrape request.
- There is an internal label `__address__` which is set by the `targets` under `static_configs` and whose value is the hostname for the scrape request. By default it is later used to set the value for the label `instance`, which is attached to each metric and tells you where the metrics came from.

Here is the config you will use to do that. Don’t worry if this is a bit much at once, we will go through it step by step:

```
global:
  scrape_interval: 5s

scrape_configs:
- job_name: blackbox # To get metrics about the exporter itself
  metrics_path: /metrics
  static_configs:
    - targets:
      - localhost:9115   # For Windows and macOS replace with - host.docker.internal:9115

- job_name: blackbox-http # To get metrics about the exporter’s targets
  metrics_path: /probe
  params:
    module: [http_2xx]
  static_configs:
    - targets:
      - http://prometheus.io    # Target to probe with http
      - https://prometheus.io   # Target to probe with https
      - http://example.com:8080 # Target to probe with http on port 8080
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: localhost:9115  # The blackbox exporter’s real hostname:port. For Windows and macOS replace with - host.docker.internal:9115
```

So what is new compared to the [last config](https://prometheus.io/docs/guides/multi-target-exporter/#prometheus-config)?

`params` does not include `target` anymore. Instead we add the actual targets under `static configs:` `targets`. We also use several because we can do that now:

```
  params:
    module: [http_2xx]
  static_configs:
    - targets:
      - http://prometheus.io    # Target to probe with http
      - https://prometheus.io   # Target to probe with https
      - http://example.com:8080 # Target to probe with http on port 8080
```

`relabel_configs` contains the new relabeling rules:

```
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
    - source_labels: [__param_target]
      target_label: instance
    - target_label: __address__
      replacement: localhost:9115  # The blackbox exporter’s real hostname:port. For Windows and macOS replace with - host.docker.internal:9115
```

Before applying the relabeling rules, the URI of a request Prometheus would make would look like this: `"http://prometheus.io/probe?module=http_2xx"`. After relabeling it will look like this `"http://localhost:9115/probe?target=http://prometheus.io&module=http_2xx"`.

Now let us explore how each rule does that:

First we take the values from the label `__address__` (which contain the values from `targets`) and write them to a new label `__param_target` which will add a parameter `target` to the Prometheus scrape requests:

```
  relabel_configs:
    - source_labels: [__address__]
      target_label: __param_target
```

After this our imagined Prometheus request URI has now a target parameter: `"http://prometheus.io/probe?target=http://prometheus.io&module=http_2xx"`.

Then we take the values from the label `__param_target` and create a label instance with the values.

```
  relabel_configs:
    - source_labels: [__param_target]
      target_label: instance
```

Our request will not change, but the metrics that come back from our request will now bear a label `instance="http://prometheus.io"`.

After that we write the value `localhost:9115` (the URI of our exporter) to the label `__address__`. This will be used as the hostname and port for the Prometheus scrape  requests. So that it queries the exporter and not the target URI  directly.

```
  relabel_configs:
    - target_label: __address__
      replacement: localhost:9115  # The blackbox exporter’s real hostname:port. For Windows and macOS replace with - host.docker.internal:9115
```

Our request is now `"localhost:9115/probe?target=http://prometheus.io&module=http_2xx"`. This way we can have the actual targets there, get them as `instance` label values while letting Prometheus make a request against the blackbox exporter.

Often people combine these with a specific service discovery. Check out the [configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration) for more information. Using them is no problem, as these write into the `__address__` label just like `targets` defined under `static_configs`.

That is it. Restart the Prometheus docker container and look at your [metrics](http://localhost:9090/graph?g0.range_input=30m&g0.stacked=0&g0.expr=probe_http_duration_seconds&g0.tab=0). Pay attention that you selected the period of time when the metrics were actually collected.

# Summary

In this guide, you learned how the multi-target exporter pattern  works, how to run a blackbox exporter with a customised module, and to  configure Prometheus using relabeling to scrape metrics with prober  labels.

# Monitoring Linux host metrics with the Node Exporter

- [Installing and running the Node Exporter ](https://prometheus.io/docs/guides/node-exporter/#installing-and-running-the-node-exporter)
- [Node Exporter metrics ](https://prometheus.io/docs/guides/node-exporter/#node-exporter-metrics)
- [Configuring your Prometheus instances ](https://prometheus.io/docs/guides/node-exporter/#configuring-your-prometheus-instances)
- [Exploring Node Exporter metrics through the Prometheus expression browser ](https://prometheus.io/docs/guides/node-exporter/#exploring-node-exporter-metrics-through-the-prometheus-expression-browser)

The Prometheus [**Node Exporter**](https://github.com/prometheus/node_exporter) exposes a wide variety of hardware- and kernel-related metrics.

In this guide, you will:

- Start up a Node Exporter on `localhost`
- Start up a Prometheus instance on `localhost` that's configured to scrape metrics from the running Node Exporter

**NOTE:** While the Prometheus Node Exporter is for *nix systems, there is the [Windows exporter](https://github.com/prometheus-community/windows_exporter) for Windows that serves an analogous purpose.

## Installing and running the Node Exporter

The Prometheus Node Exporter is a single static binary that you can install [via tarball](https://prometheus.io/docs/guides/node-exporter/#tarball-installation). Once you've downloaded it from the Prometheus [downloads page](https://prometheus.io/download#node_exporter) extract it, and run it:

```
wget https://github.com/prometheus/node_exporter/releases/download/v*/node_exporter-*.*-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
cd node_exporter-*.*-amd64
./node_exporter
```

You should see output like this indicating that the Node Exporter is now running and exposing metrics on port 9100:

```
INFO[0000] Starting node_exporter (version=0.16.0, branch=HEAD, revision=d42bd70f4363dced6b77d8fc311ea57b63387e4f)  source="node_exporter.go:82"
INFO[0000] Build context (go=go1.9.6, user=root@a67a9bc13a69, date=20180515-15:53:28)  source="node_exporter.go:83"
INFO[0000] Enabled collectors:                           source="node_exporter.go:90"
INFO[0000]  - boottime                                   source="node_exporter.go:97"
...
INFO[0000] Listening on :9100                            source="node_exporter.go:111"
```

## Node Exporter metrics

Once the Node Exporter is installed and running, you can verify that metrics are being exported by cURLing the `/metrics` endpoint:

```
curl http://localhost:9100/metrics
```

You should see output like this:

```
# HELP go_gc_duration_seconds A summary of the GC invocation durations.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 3.8996e-05
go_gc_duration_seconds{quantile="0.25"} 4.5926e-05
go_gc_duration_seconds{quantile="0.5"} 5.846e-05
# etc.
```

Success! The Node Exporter is now exposing metrics that Prometheus  can scrape, including a wide variety of system metrics further down in  the output (prefixed with `node_`). To view those metrics (along with help and type information):

```
curl http://localhost:9100/metrics | grep "node_"
```

## Configuring your Prometheus instances

Your locally running Prometheus instance needs to be properly  configured in order to access Node Exporter metrics. The following [`prometheus.yml`](https://prometheus.io/docs/prometheus/latest/configuration/configuration/) example configuration file will tell the Prometheus instance to scrape, and how frequently, from the Node Exporter via `localhost:9100`:



```
global:
  scrape_interval: 15s

scrape_configs:
- job_name: node
  static_configs:
  - targets: ['localhost:9100']
```

To install Prometheus, [download the latest release](https://prometheus.io/download) for your platform and untar it:

```
wget https://github.com/prometheus/prometheus/releases/download/v*/prometheus-*.*-amd64.tar.gz
tar xvf prometheus-*.*-amd64.tar.gz
cd prometheus-*.*
```

Once Prometheus is installed you can start it up, using the `--config.file` flag to point to the Prometheus configuration that you created [above](https://prometheus.io/docs/guides/node-exporter/#config):

```
./prometheus --config.file=./prometheus.yml
```

## Exploring Node Exporter metrics through the Prometheus expression browser

Now that Prometheus is scraping metrics from a running Node Exporter  instance, you can explore those metrics using the Prometheus UI (aka the [expression browser](https://prometheus.io/docs/visualization/browser)). Navigate to `localhost:9090/graph` in your browser and use the main expression bar at the top of the page  to enter expressions. The expression bar looks like this:

![Prometheus expressions browser](https://prometheus.io/assets/prometheus-expression-bar.png)

Metrics specific to the Node Exporter are prefixed with `node_` and include metrics like `node_cpu_seconds_total` and `node_exporter_build_info`.

Click on the links below to see some example metrics:

| Metric                                                       | Meaning                                                      |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [`rate(node_cpu_seconds_total{mode="system"}[1m\])`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(node_cpu_seconds_total{mode%3D"system"}[1m])&g0.tab=1) | The average amount of CPU time spent in system mode, per second, over the last minute (in seconds) |
| [`node_filesystem_avail_bytes`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=node_filesystem_avail_bytes&g0.tab=1) | The filesystem space available to non-root users (in bytes)  |
| [`rate(node_network_receive_bytes_total[1m\])`](http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(node_network_receive_bytes_total[1m])&g0.tab=1) | The average network traffic received, per second, over the last minute (in bytes) |

# Docker Swarm

- [Docker Swarm service discovery architecture ](https://prometheus.io/docs/guides/dockerswarm/#docker-swarm-service-discovery-architecture)

- [Setting up Prometheus ](https://prometheus.io/docs/guides/dockerswarm/#setting-up-prometheus)

- [Monitoring Docker daemons ](https://prometheus.io/docs/guides/dockerswarm/#monitoring-docker-daemons)

- [Monitoring Containers ](https://prometheus.io/docs/guides/dockerswarm/#monitoring-containers)

- [Discovered labels ](https://prometheus.io/docs/guides/dockerswarm/#discovered-labels)

- - [Scraping metrics via a certain network only ](https://prometheus.io/docs/guides/dockerswarm/#scraping-metrics-via-a-certain-network-only)
  - [Scraping global tasks only ](https://prometheus.io/docs/guides/dockerswarm/#scraping-global-tasks-only)
  - [Adding a docker_node label to the targets ](https://prometheus.io/docs/guides/dockerswarm/#adding-a-docker_node-label-to-the-targets)

- [Connecting to the Docker Swarm ](https://prometheus.io/docs/guides/dockerswarm/#connecting-to-the-docker-swarm)

- [Conclusion ](https://prometheus.io/docs/guides/dockerswarm/#conclusion)

Prometheus can discover targets in a [Docker Swarm](https://docs.docker.com/engine/swarm/) cluster, as of v2.20.0. This guide demonstrates how to use that service discovery mechanism.

## Docker Swarm service discovery architecture

The [Docker Swarm service discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#dockerswarm_sd_config) contains 3 different roles: nodes, services, and tasks.

The first role, **nodes**, represents the hosts that are part of the Swarm. It can be used to automatically monitor the Docker daemons or the Node Exporters who run on the Swarm hosts.

The second role, **tasks**, represents any individual container deployed in the swarm. Each task gets its associated service labels. One service can be backed by one or multiple tasks.

The third one, **services**, will discover the services deployed in the swarm. It will discover the ports exposed by the services. Usually you will want to use the tasks role instead of this one.

Prometheus will only discover tasks and service that expose ports.

**NOTE:** The rest of this post assumes that you have a Swarm running.

## Setting up Prometheus

For this guide, you need to [setup Prometheus](https://prometheus.io/docs/prometheus/latest/getting_started/). We will assume that Prometheus runs on a Docker Swarm manager node and has access to the Docker socket at `/var/run/docker.sock`.

## Monitoring Docker daemons

Let's dive into the service discovery itself.

Docker itself, as a daemon, exposes [metrics](https://docs.docker.com/config/daemon/prometheus/) that can be ingested by a Prometheus server.

You can enable them by editing `/etc/docker/daemon.json` and setting the following properties:

```
{
  "metrics-addr" : "0.0.0.0:9323",
  "experimental" : true
}
```

Instead of `0.0.0.0`, you can set the IP of the Docker Swarm node.

A restart of the daemon is required to take the new configuration into account.

The [Docker documentation](https://docs.docker.com/config/daemon/prometheus/) contains more info about this.

Then, you can configure Prometheus to scrape the Docker daemon, by providing the following `prometheus.yml` file:

```
scrape_configs:
  # Make Prometheus scrape itself for metrics.
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']

  # Create a job for Docker daemons.
  - job_name: 'docker'
    dockerswarm_sd_configs:
      - host: unix:///var/run/docker.sock
        role: nodes
    relabel_configs:
      # Fetch metrics on port 9323.
      - source_labels: [__meta_dockerswarm_node_address]
        target_label: __address__
        replacement: $1:9323
      # Set hostname as instance label
      - source_labels: [__meta_dockerswarm_node_hostname]
        target_label: instance
```

For the nodes role, you can also use the `port` parameter of `dockerswarm_sd_configs`. However, using `relabel_configs` is recommended as it enables Prometheus to reuse the same API calls across identical Docker Swarm configurations.

## Monitoring Containers

Let's now deploy a service in our Swarm. We will deploy [cadvisor](https://github.com/google/cadvisor), which exposes container resources metrics:

```
docker service create --name cadvisor -l prometheus-job=cadvisor \
    --mode=global --publish target=8080,mode=host \
    --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock,ro \
    --mount type=bind,src=/,dst=/rootfs,ro \
    --mount type=bind,src=/var/run,dst=/var/run \
    --mount type=bind,src=/sys,dst=/sys,ro \
    --mount type=bind,src=/var/lib/docker,dst=/var/lib/docker,ro \
    google/cadvisor -docker_only
```

This is a minimal `prometheus.yml` file to monitor it:

```
scrape_configs:
  # Make Prometheus scrape itself for metrics.
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']

  # Create a job for Docker Swarm containers.
  - job_name: 'dockerswarm'
    dockerswarm_sd_configs:
      - host: unix:///var/run/docker.sock
        role: tasks
    relabel_configs:
      # Only keep containers that should be running.
      - source_labels: [__meta_dockerswarm_task_desired_state]
        regex: running
        action: keep
      # Only keep containers that have a `prometheus-job` label.
      - source_labels: [__meta_dockerswarm_service_label_prometheus_job]
        regex: .+
        action: keep
      # Use the prometheus-job Swarm label as Prometheus job label.
      - source_labels: [__meta_dockerswarm_service_label_prometheus_job]
        target_label: job
```

Let's analyze each part of the [relabel configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config).

```
- source_labels: [__meta_dockerswarm_task_desired_state]
  regex: running
  action: keep
```

Docker Swarm exposes the desired [state of the tasks](https://docs.docker.com/engine/swarm/how-swarm-mode-works/swarm-task-states/) over the API. In out example, we only **keep** the targets that should be running. It prevents monitoring tasks that should be shut down.

```
- source_labels: [__meta_dockerswarm_service_label_prometheus_job]
  regex: .+
  action: keep
```

When we deployed our cadvisor, we have added a label `prometheus-job=cadvisor`. As Prometheus fetches the tasks labels, we can instruct it to **only** keep the targets which have a `prometheus-job` label.

```
- source_labels: [__meta_dockerswarm_service_label_prometheus_job]
  target_label: job
```

That last part takes the label `prometheus-job` of the task and turns it into a target label, overwriting the default `dockerswarm` job label that comes from the scrape config.

## Discovered labels

The [Prometheus Documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#dockerswarm_sd_config) contains the full list of labels, but here are other relabel configs that you might find useful.

### Scraping metrics via a certain network only

```
- source_labels: [__meta_dockerswarm_network_name]
  regex: ingress
  action: keep
```

### Scraping global tasks only

Global tasks run on every daemon.

```
- source_labels: [__meta_dockerswarm_service_mode]
  regex: global
  action: keep
- source_labels: [__meta_dockerswarm_task_port_publish_mode]
  regex: host
  action: keep
```

### Adding a docker_node label to the targets

```
- source_labels: [__meta_dockerswarm_node_hostname]
  target_label: docker_node
```

## Connecting to the Docker Swarm

The above `dockerswarm_sd_configs` entries have a field host:

```
host: unix:///var/run/docker.sock
```

That is using the Docker socket. Prometheus offers [additional configuration options](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#dockerswarm_sd_config) to connect to Swarm using HTTP and HTTPS, if you prefer that over the unix socket.

## Conclusion

There are many discovery labels you can play with to better determine which targets to monitor and how, for the tasks, there is more than 25 labels available. Don't hesitate to look at the "Service Discovery" page of your Prometheus server (under the "Status" menu) to see all the discovered labels.

The service discovery makes no assumptions about your Swarm stack, in such a way that given proper configuration, this should be pluggable to any existing stack.

# Using the Prometheus query log

- [Enable the query log ](https://prometheus.io/docs/guides/query-log/#enable-the-query-log)

- - [Logging all the queries to a file ](https://prometheus.io/docs/guides/query-log/#logging-all-the-queries-to-a-file)

- [Verifying if the query log is enabled ](https://prometheus.io/docs/guides/query-log/#verifying-if-the-query-log-is-enabled)

- [Format of the query log ](https://prometheus.io/docs/guides/query-log/#format-of-the-query-log)

- - [API Queries and consoles ](https://prometheus.io/docs/guides/query-log/#api-queries-and-consoles)
  - [Recording rules and alerts ](https://prometheus.io/docs/guides/query-log/#recording-rules-and-alerts)

- [Rotating the query log ](https://prometheus.io/docs/guides/query-log/#rotating-the-query-log)

Prometheus has the ability to log all the queries run by the engine to a log file, as of 2.16.0. This guide demonstrates how to use that log file, which fields it contains, and provides advanced tips about how to operate the log file.

## Enable the query log

The query log can be toggled at runtime. It can therefore be activated when you want to investigate slownesses or high load on your Prometheus instance.

To enable or disable the query log, two steps are needed:

1. Adapt the configuration to add or remove the query log configuration.
2. Reload the Prometheus server configuration.

### Logging all the queries to a file

This example demonstrates how to log all the queries to a file called `/prometheus/query.log`. We will assume that `/prometheus` is the data directory and that Prometheus has write access to it.

First, adapt the `prometheus.yml` configuration file:

```
global:
  scrape_interval:     15s
  evaluation_interval: 15s
  query_log_file: /prometheus/query.log
scrape_configs:
- job_name: 'prometheus'
  static_configs:
  - targets: ['localhost:9090']
```

Then, [reload](https://prometheus.io/docs/prometheus/latest/management_api/#reload) the Prometheus configuration:

```
$ curl -X POST http://127.0.0.1:9090/-/reload
```

Or, if Prometheus is not launched with `--web.enable-lifecycle`, and you're not running on Windows, you can trigger the reload by sending a SIGHUP to the Prometheus process.

The file `/prometheus/query.log` should now exist and all the queries will be logged to that file.

To disable the query log, repeat the operation but remove `query_log_file` from the configuration.

## Verifying if the query log is enabled

Prometheus conveniently exposes metrics that indicates if the query log is enabled and working:

```
# HELP prometheus_engine_query_log_enabled State of the query log.
# TYPE prometheus_engine_query_log_enabled gauge
prometheus_engine_query_log_enabled 0
# HELP prometheus_engine_query_log_failures_total The number of query log failures.
# TYPE prometheus_engine_query_log_failures_total counter
prometheus_engine_query_log_failures_total 0
```

The first metric, `prometheus_engine_query_log_enabled` is set to 1 of the query log is enabled, and 0 otherwise. The second one, `prometheus_engine_query_log_failures_total`, indicates the number of queries that could not be logged.

## Format of the query log

The query log is a JSON-formatted log. Here is an overview of the fields present for a query:

```
{
    "params": {
        "end": "2020-02-08T14:59:50.368Z",
        "query": "up == 0",
        "start": "2020-02-08T13:59:50.368Z",
        "step": 5
    },
    "stats": {
        "timings": {
            "evalTotalTime": 0.000447452,
            "execQueueTime": 7.599e-06,
            "execTotalTime": 0.000461232,
            "innerEvalTime": 0.000427033,
            "queryPreparationTime": 1.4177e-05,
            "resultSortTime": 6.48e-07
        }
    },
    "ts": "2020-02-08T14:59:50.387Z"
}
```

- `params`: The query. The start and end timestamp, the step and the actual query statement.
- `stats`: Statistics. Currently, it contains internal engine timers.
- `ts`: The timestamp when the query ended.

Additionally, depending on what triggered the request, you will have additional fields in the JSON lines.

### API Queries and consoles

HTTP requests contain the client IP, the method, and the path:

```
{
    "httpRequest": {
        "clientIP": "127.0.0.1",
        "method": "GET",
        "path": "/api/v1/query_range"
    }
}
```

The path will contain the web prefix if it is set, and can also point to a console.

The client IP is the network IP address and does not take into consideration the headers like `X-Forwarded-For`. If you wish to log the original caller behind a proxy, you need to do so in the proxy itself.

### Recording rules and alerts

Recording rules and alerts contain a ruleGroup element which contains the path of the file and the name of the group:

```
{
    "ruleGroup": {
        "file": "rules.yml",
        "name": "partners"
    }
}
```

## Rotating the query log

Prometheus will not rotate the query log itself. Instead, you can use external tools to do so.

One of those tools is logrotate. It is enabled by default on most Linux distributions.

Here is an example of file you can add as `/etc/logrotate.d/prometheus`:

```
/prometheus/query.log {
    daily
    rotate 7
    compress
    delaycompress
    postrotate
        killall -HUP prometheus
    endscript
}
```

That will rotate your file daily and keep one week of history.

# Securing Prometheus API and UI endpoints using TLS encryption

- [Pre-requisites ](https://prometheus.io/docs/guides/tls-encryption/#pre-requisites)
- [Prometheus configuration ](https://prometheus.io/docs/guides/tls-encryption/#prometheus-configuration)
- [Testing ](https://prometheus.io/docs/guides/tls-encryption/#testing)

Prometheus supports [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (TLS) encryption for connections to Prometheus instances (i.e. to the expression browser or [HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api)). If you would like to enforce TLS for those connections, you would need to create a specific web configuration file.

**NOTE:** This guide is about TLS connections *to* Prometheus instances. TLS is also supported for connections *from* Prometheus instances to [scrape targets](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#tls_config).

## Pre-requisites

Let's say that you already have a Prometheus instance up and running, and you want to adapt it. We will not cover the initial Prometheus setup in this guide.

Let's say that you want to run a Prometheus instance served with TLS, available at the `example.com` domain (which you own).

Let's also say that you've generated the following using [OpenSSL](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs) or an analogous tool:

- an SSL certificate at `/home/prometheus/certs/example.com/example.com.crt`
- an SSL key at `/home/prometheus/certs/example.com/example.com.key`

You can generate a self-signed certificate and private key using this command:

```
mkdir -p /home/prometheus/certs/example.com && cd /home/prometheus/certs/certs/example.com
openssl req \
  -x509 \
  -newkey rsa:4096 \
  -nodes \
  -keyout example.com.key \
  -out example.com.crt
```

Fill out the appropriate information at the prompts, and make sure to enter `example.com` at the `Common Name` prompt.

## Prometheus configuration

Below is an example [`web-config.yml`](https://prometheus.io/docs/prometheus/latest/configuration/https/) configuration file. With this configuration, Prometheus will serve all its endpoints behind TLS.

```
tls_server_config:
  cert_file: /home/prometheus/certs/example.com/example.com.crt
  key_file: /home/prometheus/certs/example.com/example.com.key
```

To make Prometheus use this config, you will need to call it with the flag `--web.config.file`.

```
prometheus \
  --config.file=/path/to/prometheus.yml \
  --web.config.file=/path/to/web-config.yml \
  --web.external-url=https://example.com/
```

The `--web.external-url=` flag is optional here.

## Testing

If you'd like to test out TLS locally using the `example.com` domain, you can add an entry to your `/etc/hosts` file that re-routes `example.com` to `localhost`:

```
127.0.0.1     example.com
```

You can then use cURL to interact with your local Prometheus setup:

```
curl --cacert /home/prometheus/certs/example.com/example.com.crt \
  https://example.com/api/v1/label/job/values
```

You can connect to the Prometheus server without specifying certs using the `--insecure` or `-k` flag:

```
curl -k https://example.com/api/v1/label/job/values
```