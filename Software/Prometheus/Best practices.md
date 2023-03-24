# Metric and label naming

- [Metric names ](https://prometheus.io/docs/practices/naming/#metric-names)
- [Labels ](https://prometheus.io/docs/practices/naming/#labels)
- [Base units ](https://prometheus.io/docs/practices/naming/#base-units)

The metric and label conventions presented in this document are not required for using Prometheus, but can serve as both a style-guide and a collection of best practices. Individual organizations may want to approach some of these practices, e.g. naming conventions, differently.

## Metric names

A metric name...

- ...must comply with the [data model](https://prometheus.io/docs/concepts/data_model/#metric-names-and-labels) for valid characters.

- ...should have a (single-word) application prefix relevant to the domain the metric belongs to. The prefix is sometimes referred to as 

  ```
  namespace
  ```

   by client libraries. For metrics specific to an application, the prefix is usually the application name itself. Sometimes, however, metrics are more generic, like standardized metrics exported by client libraries. Examples:

  - `**prometheus**_notifications_total` (specific to the Prometheus server)
  - `**process**_cpu_seconds_total` (exported by many client libraries)
  - `**http**_request_duration_seconds` (for all HTTP requests)

- ...must have a single unit (i.e. do not mix seconds with milliseconds, or seconds with bytes).

- ...should use base units (e.g. seconds, bytes, meters - not  milliseconds, megabytes, kilometers). See below for a list of base  units.

- ...should have a suffix describing the unit, in plural form. Note that an accumulating count has 

  ```
  total
  ```

   as a suffix, in addition to the unit if applicable.

  - `http_request_duration_**seconds**`
  - `node_memory_usage_**bytes**`
  - `http_requests_**total**` (for a unit-less accumulating count)
  - `process_cpu_**seconds_total**` (for an accumulating count with unit)
  - `foobar_build**_info**` (for a pseudo-metric that provides [metadata](https://www.robustperception.io/exposing-the-software-version-to-prometheus) about the running binary)
  - `data_pipeline_last_record_processed_**timestamp_seconds**` (for a timestamp that tracks the time of the latest record processed in a data processing pipeline)

- ...should represent the same logical thing-being-measured across all label dimensions.

  - request duration
  - bytes of data transfer
  - instantaneous resource usage as a percentage

As a rule of thumb, either the `sum()` or the `avg()` over all dimensions of a given metric should be meaningful (though not necessarily useful). If it is not meaningful, split the data up into multiple metrics. For example, having the capacity of various queues in one metric is good, while mixing the capacity of a queue with the current number of elements in the queue is not.

## Labels

Use labels to differentiate the characteristics of the thing that is being measured:

- `api_http_requests_total` - differentiate request types: `operation="create|update|delete"`
- `api_request_duration_seconds` - differentiate request stages: `stage="extract|transform|load"`

Do not put the label names in the metric name, as this introduces redundancy and will cause confusion if the respective labels are aggregated away.

**CAUTION:** Remember that every unique combination of key-value label pairs represents a new time series, which can dramatically increase the amount of data stored. Do not use labels to store dimensions with high cardinality (many different label values), such as user IDs, email addresses, or other unbounded sets of values.

## Base units

Prometheus does not have any units hard coded. For better compatibility, base units should be used. The following lists some metrics families with their base unit. The list is not exhaustive.

| Family           | Base unit | Remark                                                       |
| ---------------- | --------- | ------------------------------------------------------------ |
| Time             | seconds   |                                                              |
| Temperature      | celsius   | *celsius* is preferred over *kelvin* for practical reasons. *kelvin* is acceptable as a base unit in special cases like color temperature or where temperature has to be absolute. |
| Length           | meters    |                                                              |
| Bytes            | bytes     |                                                              |
| Bits             | bytes     | To avoid confusion combining different metrics, always use *bytes*, even where *bits* appear more common. |
| Percent          | ratio     | Values are 0–1 (rather than 0–100). `ratio` is only used as a suffix for names like `disk_usage_ratio`. The usual metric name follows the pattern `A_per_B`. |
| Voltage          | volts     |                                                              |
| Electric current | amperes   |                                                              |
| Energy           | joules    |                                                              |
| Power            |           | Prefer exporting a counter of joules, then `rate(joules[5m])` gives you power in Watts. |
| Mass             | grams     | *grams* is preferred over *kilograms* to avoid issues with the *kilo* prefix. |

# Consoles and dashboards

It can be tempting to display as much data as possible on a dashboard, especially when a system like Prometheus offers the ability to have such rich instrumentation of your applications. This can lead to consoles that are impenetrable due to having too much information, that even an expert in the system would have difficulty drawing meaning from.

Instead of trying to represent every piece of data you have, for operational consoles think of what are the most likely failure modes and how you would use the consoles to differentiate them. Take advantage of the structure of your services. For example, if you have a big tree of services in an online-serving system, latency in some lower service is a typical problem. Rather than showing every service's information on a single large dashboard, build separate dashboards for each service that include the latency and errors for each service they talk to. You can then start at the top and work your way down to the problematic service.

We have found the following guidelines very effective:

- Have no more than 5 graphs on a console.
- Have no more than 5 plots (lines) on each graph. You can get away with more if it is a stacked/area graph.
- When using the provided console template examples, avoid more than 20-30 entries in the right-hand-side table.

If you find yourself exceeding these, it could make sense to demote the visibility of less important information, possibly splitting out some subsystems to a new console. For example, you could graph aggregated rather than broken-down data, move it to the right-hand-side table, or even remove data completely if it is rarely useful - you can always look at it in the [expression browser](https://prometheus.io/docs/visualization/browser/)!

Finally, it is difficult for a set of consoles to serve more than one master. What you want to know when oncall (what is broken?) tends to be very different from what you want when developing features (how many people hit corner case X?). In such cases, two separate sets of consoles can be useful.

# Instrumentation

- [How to instrument ](https://prometheus.io/docs/practices/instrumentation/#how-to-instrument)

- - [The three types of services ](https://prometheus.io/docs/practices/instrumentation/#the-three-types-of-services)
  - [Subsystems ](https://prometheus.io/docs/practices/instrumentation/#subsystems)

- [Things to watch out for ](https://prometheus.io/docs/practices/instrumentation/#things-to-watch-out-for)

- - [Use labels ](https://prometheus.io/docs/practices/instrumentation/#use-labels)
  - [Do not overuse labels ](https://prometheus.io/docs/practices/instrumentation/#do-not-overuse-labels)
  - [Counter vs. gauge, summary vs. histogram ](https://prometheus.io/docs/practices/instrumentation/#counter-vs-gauge-summary-vs-histogram)
  - [Timestamps, not time since ](https://prometheus.io/docs/practices/instrumentation/#timestamps-not-time-since)
  - [Inner loops ](https://prometheus.io/docs/practices/instrumentation/#inner-loops)
  - [Avoid missing metrics ](https://prometheus.io/docs/practices/instrumentation/#avoid-missing-metrics)

This page provides an opinionated set of guidelines for instrumenting your code.

## How to instrument

The short answer is to instrument everything. Every library, subsystem and service should have at least a few metrics to give you a rough idea of how it is performing.

Instrumentation should be an integral part of your code. Instantiate the metric classes in the same file you use them. This makes going from alert to console to code easy when you are chasing an error.

### The three types of services

For monitoring purposes, services can generally be broken down into three types: online-serving, offline-processing, and batch jobs. There is overlap between them, but every service tends to fit well into one of these categories.

#### Online-serving systems

An online-serving system is one where a human or another system is expecting an immediate response. For example, most database and HTTP requests fall into this category.

The key metrics in such a system are the number of performed queries, errors, and latency. The number of in-progress requests can also be useful.

For counting failed queries, see section [Failures](https://prometheus.io/docs/practices/instrumentation/#failures) below.

Online-serving systems should be monitored on both the client and server side. If the two sides see different behaviors, that is very useful information for debugging. If a service has many clients, it is not practical for the service to track them individually, so they have to rely on their own stats.

Be consistent in whether you count queries when they start or when they end. When they end is suggested, as it will line up with the error and latency stats, and tends to be easier to code.

#### Offline processing

For offline processing, no one is actively waiting for a response, and batching of work is common. There may also be multiple stages of processing.

For each stage, track the items coming in, how many are in progress, the last time you processed something, and how many items were sent out. If batching, you should also track batches going in and out.

Knowing the last time that a system processed something is useful for detecting if it has stalled, but it is very localised information. A better approach is to send a heartbeat through the system: some dummy item that gets passed all the way through and includes the timestamp when it was inserted. Each stage can export the most recent heartbeat timestamp it has seen, letting you know how long items are taking to propagate through the system. For systems that do not have quiet periods where no processing occurs, an explicit heartbeat may not be needed.

#### Batch jobs

There is a fuzzy line between offline-processing and batch jobs, as offline processing may be done in batch jobs. Batch jobs are distinguished by the fact that they do not run continuously, which makes scraping them difficult.

The key metric of a batch job is the last time it succeeded. It is also useful to track how long each major stage of the job took, the overall runtime and the last time the job completed (successful or failed). These are all gauges, and should be [pushed to a PushGateway](https://prometheus.io/docs/instrumenting/pushing/). There are generally also some overall job-specific statistics that would be useful to track, such as the total number of records processed.

For batch jobs that take more than a few minutes to run, it is useful to also scrape them using pull-based monitoring. This lets you track the same metrics over time as for other types of jobs, such as resource usage and latency when talking to other systems. This can aid debugging if the job starts to get slow.

For batch jobs that run very often (say, more often than every 15 minutes), you should consider converting them into daemons and handling them as offline-processing jobs.

### Subsystems

In addition to the three main types of services, systems have sub-parts that should also be monitored.

#### Libraries

Libraries should provide instrumentation with no additional configuration required by users.

If it is a library used to access some resource outside of the process (for example, network, disk, or IPC), track the overall query count, errors (if errors are possible) and latency at a minimum.

Depending on how heavy the library is, track internal errors and latency within the library itself, and any general statistics you think may be useful.

A library may be used by multiple independent parts of an application against different resources, so take care to distinguish uses with labels where appropriate. For example, a database connection pool should distinguish the databases it is talking to, whereas there is no need to differentiate between users of a DNS client library.

#### Logging

As a general rule, for every line of logging code you should also have a counter that is incremented. If you find an interesting log message, you want to be able to see how often it has been happening and for how long.

If there are multiple closely-related log messages in the same function (for example, different branches of an if or switch statement), it can sometimes make sense to increment a single counter for all of them.

It is also generally useful to export the total number of info/error/warning lines that were logged by the application as a whole, and check for significant differences as part of your release process.

#### Failures

Failures should be handled similarly to logging. Every time there is a failure, a counter should be incremented. Unlike logging, the error may also bubble up to a more general error counter depending on how your code is structured.

When reporting failures, you should generally have some other metric representing the total number of attempts. This makes the failure ratio easy to calculate.

#### Threadpools

For any sort of threadpool, the key metrics are the number of queued requests, the number of threads in use, the total number of threads, the number of tasks processed, and how long they took. It is also useful to track how long things were waiting in the queue.

#### Caches

The key metrics for a cache are total queries, hits, overall latency and then the query count, errors and latency of whatever online-serving system the cache is in front of.

#### Collectors

When implementing a non-trivial custom metrics collector, it is advised to export a gauge for how long the collection took in seconds and another for the number of errors encountered.

This is one of the two cases when it is okay to export a duration as a gauge rather than a summary or a histogram, the other being batch job durations. This is because both represent information about that particular push/scrape, rather than tracking multiple durations over time.

## Things to watch out for

There are some general things to be aware of when doing monitoring, and also Prometheus-specific ones in particular.

### Use labels

Few monitoring systems have the notion of labels and an expression language to take advantage of them, so it takes a bit of getting used to.

When you have multiple metrics that you want to add/average/sum, they should usually be one metric with labels rather than multiple metrics.

For example, rather than `http_responses_500_total` and `http_responses_403_total`, create a single metric called `http_responses_total` with a `code` label for the HTTP response code. You can then process the entire metric as one in rules and graphs.

As a rule of thumb, no part of a metric name should ever be procedurally generated (use labels instead). The one exception is when proxying metrics from another monitoring/instrumentation system.

See also the [naming](https://prometheus.io/docs/practices/naming/) section.

### Do not overuse labels

Each labelset is an additional time series that has RAM, CPU, disk, and network costs. Usually the overhead is negligible, but in scenarios with lots of metrics and hundreds of labelsets across hundreds of servers, this can add up quickly.

As a general guideline, try to keep the cardinality of your metrics below 10, and for metrics that exceed that, aim to limit them to a handful across your whole system. The vast majority of your metrics should have no labels.

If you have a metric that has a cardinality over 100 or the potential to grow that large, investigate alternate solutions such as reducing the number of dimensions or moving the analysis away from monitoring and to a general-purpose processing system.

To give you a better idea of the underlying numbers, let's look at node_exporter. node_exporter exposes metrics for every mounted filesystem. Every node will have in the tens of timeseries for, say, `node_filesystem_avail`. If you have 10,000 nodes, you will end up with roughly 100,000 timeseries for `node_filesystem_avail`, which is fine for Prometheus to handle.

If you were to now add quota per user, you would quickly reach a double digit number of millions with 10,000 users on 10,000 nodes. This is too much for the current implementation of Prometheus. Even with smaller numbers, there's an opportunity cost as you can't have other, potentially more useful metrics on this machine any more.

If you are unsure, start with no labels and add more labels over time as concrete use cases arise.

### Counter vs. gauge, summary vs. histogram

It is important to know which of the four main metric types to use for a given metric.

To pick between counter and gauge, there is a simple rule of thumb: if the value can go down, it is a gauge.

Counters can only go up (and reset, such as when a process restarts). They are useful for accumulating the number of events, or the amount of something at each event. For example, the total number of HTTP requests, or the total number of bytes sent in HTTP requests. Raw counters are rarely useful. Use the `rate()` function to get the per-second rate at which they are increasing.

Gauges can be set, go up, and go down. They are useful for snapshots of state, such as in-progress requests, free/total memory, or temperature. You should never take a `rate()` of a gauge.

Summaries and histograms are more complex metric types discussed in [their own section](https://prometheus.io/docs/practices/histograms/).

### Timestamps, not time since

If you want to track the amount of time since something happened, export the Unix timestamp at which it happened - not the time since it happened.

With the timestamp exported, you can use the expression `time() - my_timestamp_metric` to calculate the time since the event, removing the need for update logic and protecting you against the update logic getting stuck.

### Inner loops

In general, the additional resource cost of instrumentation is far outweighed by the benefits it brings to operations and development.

For code which is performance-critical or called more than 100k times a second inside a given process, you may wish to take some care as to how many metrics you update.

A Java counter takes [12-17ns](https://github.com/prometheus/client_java/blob/master/benchmark/README.md) to increment depending on contention. Other languages will have similar performance. If that amount of time is significant for your inner loop, limit the number of metrics you increment in the inner loop and avoid labels (or cache the result of the label lookup, for example, the return value of `With()` in Go or `labels()` in Java) where possible.

Beware also of metric updates involving time or durations, as getting the time may involve a syscall. As with all matters involving performance-critical code, benchmarks are the best way to determine the impact of any given change.

### Avoid missing metrics

Time series that are not present until something happens are difficult to deal with, as the usual simple operations are no longer sufficient to correctly handle them. To avoid this, export a default value such as `0` for any time series you know may exist in advance.

Most Prometheus client libraries (including Go, Java, and Python) will automatically export a `0` for you for metrics with no labels.

# Histograms and summaries

- [Library support ](https://prometheus.io/docs/practices/histograms/#library-support)
- [Count and sum of observations ](https://prometheus.io/docs/practices/histograms/#count-and-sum-of-observations)
- [Apdex score ](https://prometheus.io/docs/practices/histograms/#apdex-score)
- [Quantiles ](https://prometheus.io/docs/practices/histograms/#quantiles)
- [Errors of quantile estimation ](https://prometheus.io/docs/practices/histograms/#errors-of-quantile-estimation)
- [What can I do if my client library does not support the metric type I need? ](https://prometheus.io/docs/practices/histograms/#what-can-i-do-if-my-client-library-does-not-support-the-metric-type-i-need)

Histograms and summaries are more complex metric types. Not only does a single histogram or summary create a multitude of time series, it is also more difficult to use these metric types correctly. This section helps you to pick and configure the appropriate metric type for your use case.

## Library support

First of all, check the library support for [histograms](https://prometheus.io/docs/concepts/metric_types/#histogram) and [summaries](https://prometheus.io/docs/concepts/metric_types/#summary).

Some libraries support only one of the two types, or they support summaries only in a limited fashion (lacking [quantile calculation](https://prometheus.io/docs/practices/histograms/#quantiles)).

## Count and sum of observations

Histograms and summaries both sample observations, typically request durations or response sizes. They track the number of observations *and* the sum of the observed values, allowing you to calculate the *average* of the observed values. Note that the number of observations (showing up in Prometheus as a time series with a `_count` suffix) is inherently a counter (as described above, it only goes up). The sum of observations (showing up as a time series with a `_sum` suffix) behaves like a counter, too, as long as there are no negative observations. Obviously, request durations or response sizes are never negative. In principle, however, you can use summaries and histograms to observe negative values (e.g. temperatures in centigrade). In that case, the sum of observations can go down, so you cannot apply `rate()` to it anymore. In those rare cases where you need to apply `rate()` and cannot avoid negative observations, you can use two separate summaries, one for positive and one for negative observations (the latter with inverted sign), and combine the results later with suitable PromQL expressions.

To calculate the average request duration during the last 5 minutes from a histogram or summary called `http_request_duration_seconds`, use the following expression:

```
  rate(http_request_duration_seconds_sum[5m])
/
  rate(http_request_duration_seconds_count[5m])
```

## Apdex score

A straight-forward use of histograms (but not summaries) is to count observations falling into particular buckets of observation values.

You might have an SLO to serve 95% of requests within 300ms. In that case, configure a histogram to have a bucket with an upper limit of 0.3 seconds. You can then directly express the relative amount of requests served within 300ms and easily alert if the value drops below 0.95. The following expression calculates it by job for the requests served in the last 5 minutes. The request durations were collected with a histogram called `http_request_duration_seconds`.

```
  sum(rate(http_request_duration_seconds_bucket{le="0.3"}[5m])) by (job)
/
  sum(rate(http_request_duration_seconds_count[5m])) by (job)
```

You can approximate the well-known [Apdex score](https://en.wikipedia.org/wiki/Apdex) in a similar way. Configure a bucket with the target request duration as the upper bound and another bucket with the tolerated request duration (usually 4 times the target request duration) as the upper bound. Example: The target request duration is 300ms. The tolerable request duration is 1.2s. The following expression yields the Apdex score for each job over the last 5 minutes:

```
(
  sum(rate(http_request_duration_seconds_bucket{le="0.3"}[5m])) by (job)
+
  sum(rate(http_request_duration_seconds_bucket{le="1.2"}[5m])) by (job)
) / 2 / sum(rate(http_request_duration_seconds_count[5m])) by (job)
```

Note that we divide the sum of both buckets. The reason is that the histogram buckets are [cumulative](https://en.wikipedia.org/wiki/Histogram#Cumulative_histogram). The `le="0.3"` bucket is also contained in the `le="1.2"` bucket; dividing it by 2 corrects for that.

The calculation does not exactly match the traditional Apdex score, as it includes errors in the satisfied and tolerable parts of the calculation.

## Quantiles

You can use both summaries and histograms to calculate so-called φ-quantiles, where 0 ≤ φ ≤ 1. The φ-quantile is the observation value that ranks at number φ*N among the N observations. Examples for φ-quantiles: The 0.5-quantile is known as the median. The 0.95-quantile is the 95th percentile.

The essential difference between summaries and histograms is that summaries calculate streaming φ-quantiles on the client side and expose them directly, while histograms expose bucketed observation counts and the calculation of quantiles from the buckets of a histogram happens on the server side using the [`histogram_quantile()` function](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile).

The two approaches have a number of different implications:

|                                                              | Histogram                                                    | Summary                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Required configuration                                       | Pick buckets suitable for the expected range of observed values. | Pick desired φ-quantiles and sliding window. Other φ-quantiles and sliding windows cannot be calculated later. |
| Client performance                                           | Observations are very cheap as they only need to increment counters. | Observations are expensive due to the streaming quantile calculation. |
| Server performance                                           | The server has to calculate quantiles. You can use [recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#recording-rules) should the ad-hoc calculation take too long (e.g. in a large dashboard). | Low server-side cost.                                        |
| Number of time series (in addition to the `_sum` and `_count` series) | One time series per configured bucket.                       | One time series per configured quantile.                     |
| Quantile error (see below for details)                       | Error is limited in the dimension of observed values by the width of the relevant bucket. | Error is limited in the dimension of φ by a configurable value. |
| Specification of φ-quantile and sliding time-window          | Ad-hoc with [Prometheus expressions](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile). | Preconfigured by the client.                                 |
| Aggregation                                                  | Ad-hoc with [Prometheus expressions](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile). | In general [not aggregatable](http://latencytipoftheday.blogspot.de/2014/06/latencytipoftheday-you-cant-average.html). |

Note the importance of the last item in the table. Let us return to the SLO of serving 95% of requests within 300ms. This time, you do not want to display the percentage of requests served within 300ms, but instead the 95th percentile, i.e. the request duration within which you have served 95% of requests. To do that, you can either configure a summary with a 0.95-quantile and (for example) a 5-minute decay time, or you configure a histogram with a few buckets around the 300ms mark, e.g. `{le="0.1"}`, `{le="0.2"}`, `{le="0.3"}`, and `{le="0.45"}`. If your service runs replicated with a number of instances, you will collect request durations from every single one of them, and then you want to aggregate everything into an overall 95th percentile. However, aggregating the precomputed quantiles from a summary rarely makes sense. In this particular case, averaging the quantiles yields statistically nonsensical values.

```
avg(http_request_duration_seconds{quantile="0.95"}) // BAD!
```

Using histograms, the aggregation is perfectly possible with the [`histogram_quantile()` function](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile).

```
histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le)) // GOOD.
```

Furthermore, should your SLO change and you now want to plot the 90th percentile, or you want to take into account the last 10 minutes instead of the last 5 minutes, you only have to adjust the expression above and you do not need to reconfigure the clients.

## Errors of quantile estimation

Quantiles, whether calculated client-side or server-side, are estimated. It is important to understand the errors of that estimation.

Continuing the histogram example from above, imagine your usual request durations are almost all very close to 220ms, or in other words, if you could plot the "true" histogram, you would see a very sharp spike at 220ms. In the Prometheus histogram metric as configured above, almost all observations, and therefore also the 95th percentile, will fall into the bucket labeled `{le="0.3"}`, i.e. the bucket from 200ms to 300ms. The histogram implementation guarantees that the true 95th percentile is somewhere between 200ms and 300ms. To return a single value (rather than an interval), it applies linear interpolation, which yields 295ms in this case. The calculated quantile gives you the impression that you are close to breaching the SLO, but in reality, the 95th percentile is a tiny bit above 220ms, a quite comfortable distance to your SLO.

Next step in our thought experiment: A change in backend routing adds a fixed amount of 100ms to all request durations. Now the request duration has its sharp spike at 320ms and almost all observations will fall into the bucket from 300ms to 450ms. The 95th percentile is calculated to be 442.5ms, although the correct value is close to 320ms. While you are only a tiny bit outside of your SLO, the calculated 95th quantile looks much worse.

A summary would have had no problem calculating the correct percentile value in both cases, at least if it uses an appropriate algorithm on the client side (like the [one used by the Go client](http://dimacs.rutgers.edu/~graham/pubs/slides/bquant-long.pdf)). Unfortunately, you cannot use a summary if you need to aggregate the observations from a number of instances.

Luckily, due to your appropriate choice of bucket boundaries, even in this contrived example of very sharp spikes in the distribution of observed values, the histogram was able to identify correctly if you were within or outside of your SLO. Also, the closer the actual value of the quantile is to our SLO (or in other words, the value we are actually most interested in), the more accurate the calculated value becomes.

Let us now modify the experiment once more. In the new setup, the distributions of request durations has a spike at 150ms, but it is not quite as sharp as before and only comprises 90% of the observations. 10% of the observations are evenly spread out in a long tail between 150ms and 450ms. With that distribution, the 95th percentile happens to be exactly at our SLO of 300ms. With the histogram, the calculated value is accurate, as the value of the 95th percentile happens to coincide with one of the bucket boundaries. Even slightly different values would still be accurate as the (contrived) even distribution within the relevant buckets is exactly what the linear interpolation within a bucket assumes.

The error of the quantile reported by a summary gets more interesting now. The error of the quantile in a summary is configured in the dimension of φ. In our case we might have configured 0.95±0.01, i.e. the calculated value will be between the 94th and 96th percentile. The 94th quantile with the distribution described above is 270ms, the 96th quantile is 330ms. The calculated value of the 95th percentile reported by the summary can be anywhere in the interval between 270ms and 330ms, which unfortunately is all the difference between clearly within the SLO vs. clearly outside the SLO.

The bottom line is: If you use a summary, you control the error in the dimension of φ. If you use a histogram, you control the error in the dimension of the observed value (via choosing the appropriate bucket layout). With a broad distribution, small changes in φ result in large deviations in the observed value. With a sharp distribution, a small interval of observed values covers a large interval of φ.

Two rules of thumb:

1. If you need to aggregate, choose histograms.
2. Otherwise, choose a histogram if you have an idea of the range and distribution of values that will be observed. Choose a summary if you need an accurate quantile, no matter what the range and distribution of the values is.

## What can I do if my client library does not support the metric type I need?

Implement it! [Code contributions are welcome](https://prometheus.io/community/). In general, we expect histograms to be more urgently needed than summaries. Histograms are also easier to implement in a client library, so we recommend to implement histograms first, if in doubt.

# Alerting

- [What to alert on ](https://prometheus.io/docs/practices/alerting/#what-to-alert-on)

- - [Online serving systems ](https://prometheus.io/docs/practices/alerting/#online-serving-systems)
  - [Offline processing ](https://prometheus.io/docs/practices/alerting/#offline-processing)
  - [Batch jobs ](https://prometheus.io/docs/practices/alerting/#batch-jobs)
  - [Capacity ](https://prometheus.io/docs/practices/alerting/#capacity)
  - [Metamonitoring ](https://prometheus.io/docs/practices/alerting/#metamonitoring)

We recommend that you read [My Philosophy on Alerting](https://docs.google.com/a/boxever.com/document/d/199PqyG3UsyXlwieHaqbGiWVa8eMWi8zzAn0YfcApr8Q/edit) based on Rob Ewaschuk's observations at Google.

To summarize: keep alerting simple, alert on symptoms, have good consoles to allow pinpointing causes, and avoid having pages where there is nothing to do.

## What to alert on

Aim to have as few alerts as possible, by alerting on symptoms that are associated with end-user pain rather than trying to catch every possible way that pain could be caused. Alerts should link to relevant consoles and make it easy to figure out which component is at fault.

Allow for slack in alerting to accommodate small blips.

### Online serving systems

Typically alert on high latency and error rates as high up in the stack as possible.

Only page on latency at one point in a stack. If a lower-level component is slower than it should be, but the overall user latency is fine, then there is no need to page.

For error rates, page on user-visible errors. If there are errors further down the stack that will cause such a failure, there is no need to page on them separately. However, if some failures are not user-visible, but are otherwise severe enough to require human involvement (for example, you are losing a lot of money), add pages to be sent on those.

You may need alerts for different types of request if they have different characteristics, or problems in a low-traffic type of request would be drowned out by high-traffic requests.

### Offline processing

For offline processing systems, the key metric is how long data takes to get through the system, so page if that gets high enough to cause user impact.

### Batch jobs

For batch jobs it makes sense to page if the batch job has not succeeded recently enough, and this will cause user-visible problems.

This should generally be at least enough time for 2 full runs of the batch job. For a job that runs every 4 hours and takes an hour, 10 hours would be a reasonable threshold. If you cannot withstand a single run failing, run the job more frequently, as a single failure should not require human intervention.

### Capacity

While not a problem causing immediate user impact, being close to capacity often requires human intervention to avoid an outage in the near future.

### Metamonitoring

It is important to have confidence that monitoring is working. Accordingly, have alerts to ensure that Prometheus servers, Alertmanagers, PushGateways, and other monitoring infrastructure are available and running correctly.

As always, if it is possible to alert on symptoms rather than causes, this helps to reduce noise. For example, a blackbox test that alerts are getting from PushGateway to Prometheus to Alertmanager to email is better than individual alerts on each.

Supplementing the whitebox monitoring of Prometheus with external blackbox monitoring can catch problems that are otherwise invisible, and also serves as a fallback in case internal systems completely fail.

# Recording rules

- [Naming and aggregation ](https://prometheus.io/docs/practices/rules/#naming-and-aggregation)
- [Examples ](https://prometheus.io/docs/practices/rules/#examples)

A consistent naming scheme for [recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) makes it easier to interpret the meaning of a rule at a glance. It also avoids mistakes by making incorrect or meaningless calculations stand out.

This page documents how to correctly do aggregation and suggests a naming convention.

## Naming and aggregation

Recording rules should be of the general form `level:metric:operations`. `level` represents the aggregation level and labels of the rule output. `metric` is the metric name and should be unchanged other than stripping `_total` off counters when using `rate()` or `irate()`. `operations` is a list of operations that were applied to the metric, newest operation first.

Keeping the metric name unchanged makes it easy to know what a metric is and easy to find in the codebase.

To keep the operations clean, `_sum` is omitted if there are other operations, as `sum()`. Associative operations can be merged (for example `min_min` is the same as `min`).

If there is no obvious operation to use, use `sum`.  When taking a ratio by doing division, separate the metrics using `_per_` and call the operation `ratio`.

When aggregating up ratios, aggregate up the numerator and denominator separately and then divide. Do not take the average of a ratio or average of an average as that is not statistically valid.

When aggregating up the `_count` and `_sum` of a Summary and dividing to calculate average observation size, treating it as a ratio would be unwieldy. Instead keep the metric name without the `_count` or `_sum` suffix and replace the `rate` in the operation with `mean`. This represents the average observation size over that time period.

Always specify a `without` clause with the labels you are aggregating away. This is to preserve all the other labels such as `job`, which will avoid conflicts and give you more useful metrics and alerts.

## Examples

*Note the indentation style with outdented operators on their own line between two vectors. To make this style possible in Yaml, [block quotes with an indentation indicator](https://yaml.org/spec/1.2/spec.html#style/block/scalar) (e.g. `|2`) are used.*

Aggregating up requests per second that has a `path` label:

```
- record: instance_path:requests:rate5m
  expr: rate(requests_total{job="myjob"}[5m])

- record: path:requests:rate5m
  expr: sum without (instance)(instance_path:requests:rate5m{job="myjob"})
```

Calculating a request failure ratio and aggregating up to the job-level failure ratio:

```
- record: instance_path:request_failures:rate5m
  expr: rate(request_failures_total{job="myjob"}[5m])

- record: instance_path:request_failures_per_requests:ratio_rate5m
  expr: |2
      instance_path:request_failures:rate5m{job="myjob"}
    /
      instance_path:requests:rate5m{job="myjob"}

# Aggregate up numerator and denominator, then divide to get path-level ratio.
- record: path:request_failures_per_requests:ratio_rate5m
  expr: |2
      sum without (instance)(instance_path:request_failures:rate5m{job="myjob"})
    /
      sum without (instance)(instance_path:requests:rate5m{job="myjob"})

# No labels left from instrumentation or distinguishing instances,
# so we use 'job' as the level.
- record: job:request_failures_per_requests:ratio_rate5m
  expr: |2
      sum without (instance, path)(instance_path:request_failures:rate5m{job="myjob"})
    /
      sum without (instance, path)(instance_path:requests:rate5m{job="myjob"})
```

Calculating average latency over a time period from a Summary:

```
- record: instance_path:request_latency_seconds_count:rate5m
  expr: rate(request_latency_seconds_count{job="myjob"}[5m])

- record: instance_path:request_latency_seconds_sum:rate5m
  expr: rate(request_latency_seconds_sum{job="myjob"}[5m])

- record: instance_path:request_latency_seconds:mean5m
  expr: |2
      instance_path:request_latency_seconds_sum:rate5m{job="myjob"}
    /
      instance_path:request_latency_seconds_count:rate5m{job="myjob"}

# Aggregate up numerator and denominator, then divide.
- record: path:request_latency_seconds:mean5m
  expr: |2
      sum without (instance)(instance_path:request_latency_seconds_sum:rate5m{job="myjob"})
    /
      sum without (instance)(instance_path:request_latency_seconds_count:rate5m{job="myjob"})
```

Calculating the average query rate across instances and paths is done using the `avg()` function:

```
- record: job:request_latency_seconds_count:avg_rate5m
  expr: avg without (instance, path)(instance:request_latency_seconds_count:rate5m{job="myjob"})
```

Notice that when aggregating that the labels in the `without` clause are removed from the level of the output metric name compared to the input metric names. When there is no aggregation, the levels always match. If this is not the case a mistake has likely been made in the rules.

# When to use the Pushgateway

- [Should I be using the Pushgateway? ](https://prometheus.io/docs/practices/pushing/#should-i-be-using-the-pushgateway)
- [Alternative strategies ](https://prometheus.io/docs/practices/pushing/#alternative-strategies)

The Pushgateway is an intermediary service which allows you to push metrics from jobs which cannot be scraped. For details, see [Pushing metrics](https://prometheus.io/docs/instrumenting/pushing/).

## Should I be using the Pushgateway?

**We only recommend using the Pushgateway in certain limited cases.** There are several pitfalls when blindly using the Pushgateway instead of Prometheus's usual pull model for general metrics collection:

- When monitoring multiple instances through a single Pushgateway, the Pushgateway becomes both a single point of failure and a potential bottleneck.
- You lose Prometheus's automatic instance health monitoring via the `up` metric (generated on every scrape).
- The Pushgateway never forgets series pushed to it and will expose them to Prometheus forever unless those series are manually deleted via the Pushgateway's API.

The latter point is especially relevant when multiple instances of a job differentiate their metrics in the Pushgateway via an `instance` label or similar. Metrics for an instance will then remain in the Pushgateway even if the originating instance is renamed or removed. This is because the lifecycle of the Pushgateway as a metrics cache is fundamentally separate from the lifecycle of the processes that push metrics to it. Contrast this to Prometheus's usual pull-style monitoring: when an instance disappears (intentional or not), its metrics will automatically disappear along with it. When using the Pushgateway, this is not the case, and you would now have to delete any stale metrics manually or automate this lifecycle synchronization yourself.

**Usually, the only valid use case for the Pushgateway is for capturing the outcome of a service-level batch job**.  A "service-level" batch job is one which is not semantically related to a specific machine or job instance (for example, a batch job that deletes a number of users for an entire service). Such a job's metrics should not include a machine or instance label to decouple the lifecycle of specific machines or instances from the pushed metrics. This decreases the burden for managing stale metrics in the Pushgateway. See also the [best practices for monitoring batch jobs](https://prometheus.io/docs/practices/instrumentation/#batch-jobs).

## Alternative strategies

If an inbound firewall or NAT is preventing you from pulling metrics from targets, consider moving the Prometheus server behind the network barrier as well. We generally recommend running Prometheus servers on the same network as the monitored instances.  Otherwise, consider [PushProx](https://github.com/RobustPerception/PushProx), which allows Prometheus to traverse a firewall or NAT.

For batch jobs that are related to a machine (such as automatic security update cronjobs or configuration management client runs), expose the resulting metrics using the [Node Exporter's](https://github.com/prometheus/node_exporter) [textfile collector](https://github.com/prometheus/node_exporter#textfile-collector) instead of the Pushgateway.

# Remote write tuning

- [Remote write characteristics ](https://prometheus.io/docs/practices/remote_write/#remote-write-characteristics)

- - [Memory usage ](https://prometheus.io/docs/practices/remote_write/#memory-usage)

- [Parameters ](https://prometheus.io/docs/practices/remote_write/#parameters)

- - [ `capacity` ](https://prometheus.io/docs/practices/remote_write/#capacity)
  - [ `max_shards` ](https://prometheus.io/docs/practices/remote_write/#max_shards)
  - [ `min_shards` ](https://prometheus.io/docs/practices/remote_write/#min_shards)
  - [ `max_samples_per_send` ](https://prometheus.io/docs/practices/remote_write/#max_samples_per_send)
  - [ `batch_send_deadline` ](https://prometheus.io/docs/practices/remote_write/#batch_send_deadline)
  - [ `min_backoff` ](https://prometheus.io/docs/practices/remote_write/#min_backoff)
  - [ `max_backoff` ](https://prometheus.io/docs/practices/remote_write/#max_backoff)

Prometheus implements sane defaults for remote write, but many users have different requirements and would like to optimize their remote settings.

This page describes the tuning parameters available via the [remote write configuration.](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write)

## Remote write characteristics

Each remote write destination starts a queue which reads from the write-ahead log (WAL), writes the samples into an in memory queue owned by a shard, which then sends a request to the configured endpoint. The flow of data looks like:

```
      |-->  queue (shard_1)   --> remote endpoint
WAL --|-->  queue (shard_...) --> remote endpoint
      |-->  queue (shard_n)   --> remote endpoint
```

When one shard backs up and fills its queue, Prometheus will block reading from the WAL into any shards. Failures will be retried without loss of data unless the remote endpoint remains down for more than 2 hours. After 2 hours, the WAL will be compacted and data that has not been sent will be lost.

During operation, Prometheus will continuously calculate the optimal number of shards to use based on the incoming sample rate, number of outstanding samples not sent, and time taken to send each sample.

### Memory usage

Using remote write increases the memory footprint of Prometheus. Most users report ~25% increased memory usage, but that number is dependent on the shape of the data. For each series in the WAL, the remote write code caches a mapping of series ID to label values, causing large amounts of series churn to significantly increase memory usage.

In addition to the series cache, each shard and its queue increases memory usage. Shard memory is proportional to the `number of shards * (capacity + max_samples_per_send)`. When tuning, consider reducing `max_shards` alongside increases to `capacity` and `max_samples_per_send` to avoid inadvertently running out of memory. The default values for `capacity: 2500` and `max_samples_per_send: 500` will constrain shard memory usage to less than 500 kB per shard.

## Parameters

All the relevant parameters are found under the `queue_config` section of the remote write configuration.

### `capacity`

Capacity controls how many samples are queued in memory per shard before blocking reading from the WAL. Once the WAL is blocked, samples cannot be appended to any shards and all throughput will cease.

Capacity should be high enough to avoid blocking other shards in most cases, but too much capacity can cause excess memory consumption and longer times to clear queues during resharding. It is recommended to set capacity to 3-10 times `max_samples_per_send`.

### `max_shards`

Max shards configures the maximum number of shards, or parallelism, Prometheus will use for each remote write queue. Prometheus will try not to use too many shards, but if the queue falls behind the remote write component will increase the number of shards up to max shards to increase throughput. Unless remote writing to a very slow endpoint, it is unlikely that `max_shards` should be increased beyond the default. However, it may be necessary to reduce max shards if there is potential to overwhelm the remote endpoint, or to reduce memory usage when data is backed up.

### `min_shards`

Min shards configures the minimum number of shards used by Prometheus, and is the number of shards used when remote write starts. If remote write falls behind, Prometheus will automatically scale up the number of shards so most users do not have to adjust this parameter. However, increasing min shards will allow Prometheus to avoid falling behind at the beginning while calculating the required number of shards.

### `max_samples_per_send`

Max samples per send can be adjusted depending on the backend in use. Many systems work very well by sending more samples per batch without a significant increase in latency. Other backends will have issues if trying to send a large number of samples in each request. The default value is small enough to work for most systems.

### `batch_send_deadline`

Batch send deadline sets the maximum amount of time between sends for a single shard. Even if the queued shards has not reached `max_samples_per_send`, a request will be sent. Batch send deadline can be increased for low volume systems that are not latency sensitive in order to increase request efficiency.

### `min_backoff`

Min backoff controls the minimum amount of time to wait before retrying a failed request. Increasing the backoff spreads out requests when a remote endpoint comes back online. The backoff interval is doubled for each failed requests up to `max_backoff`.

### `max_backoff`

Max backoff controls the maximum amount of time to wait before retrying a failed request.