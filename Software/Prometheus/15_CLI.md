# CLI

## prometheus

The Prometheus monitoring server

## Flags

| Flag                                          | Description                                                  | Default                                                   |
| --------------------------------------------- | ------------------------------------------------------------ | --------------------------------------------------------- |
| `-h`, `--help`                                | Show context-sensitive help (also try --help-long and --help-man). |                                                           |
| `--version`                                   | Show application version.                                    |                                                           |
| `--config.file`                               | Prometheus configuration file path.                          | `prometheus.yml`                                          |
| `--web.listen-address`                        | Address to listen on for UI, API, and telemetry.             | `0.0.0.0:9090`                                            |
| `--web.config.file`                           | [EXPERIMENTAL] Path to configuration file that can enable TLS or authentication. |                                                           |
| `--web.read-timeout`                          | Maximum duration before timing out read of the request, and closing idle connections. | `5m`                                                      |
| `--web.max-connections`                       | Maximum number of simultaneous connections.                  | `512`                                                     |
| `--web.external-url`                          | The URL under which Prometheus is externally reachable (for example, if Prometheus is served via a reverse proxy). Used for generating  relative and absolute links back to Prometheus itself. If the URL has a  path portion, it will be used to prefix all HTTP endpoints served by  Prometheus. If omitted, relevant URL components will be derived  automatically. |                                                           |
| `--web.route-prefix`                          | Prefix for the internal routes of web endpoints. Defaults to path of --web.external-url. |                                                           |
| `--web.user-assets`                           | Path to static asset directory, available at /user.          |                                                           |
| `--web.enable-lifecycle`                      | Enable shutdown and reload via HTTP request.                 | `false`                                                   |
| `--web.enable-admin-api`                      | Enable API endpoints for admin control actions.              | `false`                                                   |
| `--web.enable-remote-write-receiver`          | Enable API endpoint accepting remote write requests.         | `false`                                                   |
| `--web.console.templates`                     | Path to the console template directory, available at /consoles. | `consoles`                                                |
| `--web.console.libraries`                     | Path to the console library directory.                       | `console_libraries`                                       |
| `--web.page-title`                            | Document title of Prometheus instance.                       | `Prometheus Time Series Collection and Processing Server` |
| `--web.cors.origin`                           | Regex for CORS origin. It is fully anchored. Example: 'https?://(domain1 | domain2).com'                                             |
| `--storage.tsdb.path`                         | Base path for metrics storage. Use with server mode only.    | `data/`                                                   |
| `--storage.tsdb.retention`                    | [DEPRECATED] How long to retain samples in storage. This flag has  been deprecated, use "storage.tsdb.retention.time" instead. Use with  server mode only. |                                                           |
| `--storage.tsdb.retention.time`               | How long to retain samples in storage. When this flag is set it  overrides "storage.tsdb.retention". If neither this flag nor  "storage.tsdb.retention" nor "storage.tsdb.retention.size" is set, the  retention time defaults to 15d. Units Supported: y, w, d, h, m, s, ms.  Use with server mode only. |                                                           |
| `--storage.tsdb.retention.size`               | Maximum number of bytes that can be stored for blocks. A unit is  required, supported units: B, KB, MB, GB, TB, PB, EB. Ex: "512MB". Based on powers-of-2, so 1KB is 1024B. Use with server mode only. |                                                           |
| `--storage.tsdb.no-lockfile`                  | Do not create lockfile in data directory. Use with server mode only. | `false`                                                   |
| `--storage.tsdb.head-chunks-write-queue-size` | Size of the queue through which head chunks are written to the disk  to be m-mapped, 0 disables the queue completely. Experimental. Use with  server mode only. | `0`                                                       |
| `--storage.agent.path`                        | Base path for metrics storage. Use with agent mode only.     | `data-agent/`                                             |
| `--storage.agent.wal-compression`             | Compress the agent WAL. Use with agent mode only.            | `true`                                                    |
| `--storage.agent.retention.min-time`          | Minimum age samples may be before being considered for deletion when the WAL is truncated Use with agent mode only. |                                                           |
| `--storage.agent.retention.max-time`          | Maximum age samples may be before being forcibly deleted when the WAL is truncated Use with agent mode only. |                                                           |
| `--storage.agent.no-lockfile`                 | Do not create lockfile in data directory. Use with agent mode only. | `false`                                                   |
| `--storage.remote.flush-deadline`             | How long to wait flushing sample on shutdown or config reload. | `1m`                                                      |
| `--storage.remote.read-sample-limit`          | Maximum overall number of samples to return via the remote read  interface, in a single query. 0 means no limit. This limit is ignored  for streamed response types. Use with server mode only. | `5e7`                                                     |
| `--storage.remote.read-concurrent-limit`      | Maximum number of concurrent remote read calls. 0 means no limit. Use with server mode only. | `10`                                                      |
| `--storage.remote.read-max-bytes-in-frame`    | Maximum number of bytes in a single frame for streaming remote read  response types before marshalling. Note that client might have limit on  frame size as well. 1MB as recommended by protobuf by default. Use with  server mode only. | `1048576`                                                 |
| `--rules.alert.for-outage-tolerance`          | Max time to tolerate prometheus outage for restoring "for" state of alert. Use with server mode only. | `1h`                                                      |
| `--rules.alert.for-grace-period`              | Minimum duration between alert and restored "for" state. This is  maintained only for alerts with configured "for" time greater than grace period. Use with server mode only. | `10m`                                                     |
| `--rules.alert.resend-delay`                  | Minimum amount of time to wait before resending an alert to Alertmanager. Use with server mode only. | `1m`                                                      |
| `--alertmanager.notification-queue-capacity`  | The capacity of the queue for pending Alertmanager notifications. Use with server mode only. | `10000`                                                   |
| `--query.lookback-delta`                      | The maximum lookback duration for retrieving metrics during expression evaluations and federation. Use with server mode only. | `5m`                                                      |
| `--query.timeout`                             | Maximum time a query may take before being aborted. Use with server mode only. | `2m`                                                      |
| `--query.max-concurrency`                     | Maximum number of queries executed concurrently. Use with server mode only. | `20`                                                      |
| `--query.max-samples`                         | Maximum number of samples a single query can load into memory. Note  that queries will fail if they try to load more samples than this into  memory, so this also limits the number of samples a query can return.  Use with server mode only. | `50000000`                                                |
| `--enable-feature`                            | Comma separated feature names to enable. Valid options: agent,  exemplar-storage, expand-external-labels, memory-snapshot-on-shutdown,  promql-at-modifier, promql-negative-offset, promql-per-step-stats,  remote-write-receiver (DEPRECATED), extra-scrape-metrics,  new-service-discovery-manager, auto-gomaxprocs, no-default-scrape-port,  native-histograms. See https://prometheus.io/docs/prometheus/latest/feature_flags/ for more details. |                                                           |
| `--log.level`                                 | Only log messages with the given severity or above. One of: [debug, info, warn, error] | `info`                                                    |
| `--log.format`                                | Output format of log messages. One of: [logfmt, json]        | `logfmt`                                                  |

## promtool

Tooling for the Prometheus monitoring system.

## Flags

| Flag               | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| `-h`, `--help`     | Show context-sensitive help (also try --help-long and --help-man). |
| `--version`        | Show application version.                                    |
| `--experimental`   | Enable experimental commands.                                |
| `--enable-feature` | Comma separated feature names to enable (only PromQL related and no-default-scrape-port). See https://prometheus.io/docs/prometheus/latest/feature_flags/ for the options and more details. |

## Commands

| Command | Description                                                  |
| ------- | ------------------------------------------------------------ |
| help    | Show help.                                                   |
| check   | Check the resources for validity.                            |
| query   | Run query against a Prometheus server.                       |
| debug   | Fetch debug information.                                     |
| push    | Push to a Prometheus server.                                 |
| test    | Unit testing.                                                |
| tsdb    | Run tsdb commands.                                           |
| promql  | PromQL formatting and editing. Requires the --experimental flag. |

### `promtool help`

Show help.

#### Arguments

| Argument | Description           |
| -------- | --------------------- |
| command  | Show help on command. |

### `promtool check`

Check the resources for validity.

#### Flags

| Flag         | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| `--extended` | Print extended information related to the cardinality of the metrics. |

##### `promtool check service-discovery`

Perform service discovery for the given job name and report the results, including relabeling.

###### Flags

| Flag        | Description                             | Default |
| ----------- | --------------------------------------- | ------- |
| `--timeout` | The time to wait for discovery results. | `30s`   |

###### Arguments

| Argument    | Description                           | Required |
| ----------- | ------------------------------------- | -------- |
| config-file | The prometheus config file.           | Yes      |
| job         | The job to run service discovery for. | Yes      |

##### `promtool check config`

Check if the config files are valid or not.

###### Flags

| Flag            | Description                                                  | Default           |
| --------------- | ------------------------------------------------------------ | ----------------- |
| `--syntax-only` | Only check the config file syntax, ignoring file and content validation referenced in the config |                   |
| `--lint`        | Linting checks to apply to the rules specified in the config.  Available options are: all, duplicate-rules, none. Use --lint=none to  disable linting | `duplicate-rules` |
| `--lint-fatal`  | Make lint errors exit with exit code 3.                      | `false`           |
| `--agent`       | Check config file for Prometheus in Agent mode.              |                   |

###### Arguments

| Argument     | Description                | Required |
| ------------ | -------------------------- | -------- |
| config-files | The config files to check. | Yes      |

##### `promtool check web-config`

Check if the web config files are valid or not.

###### Arguments

| Argument         | Description                | Required |
| ---------------- | -------------------------- | -------- |
| web-config-files | The config files to check. | Yes      |

##### `promtool check healthy`

Check if the Prometheus server is healthy.

###### Flags

| Flag                 | Description                                                  | Default                 |
| -------------------- | ------------------------------------------------------------ | ----------------------- |
| `--http.config.file` | HTTP client configuration file for promtool to connect to Prometheus. |                         |
| `--url`              | The URL for the Prometheus server.                           | `http://localhost:9090` |

##### `promtool check ready`

Check if the Prometheus server is ready.

###### Flags

| Flag                 | Description                                                  | Default                 |
| -------------------- | ------------------------------------------------------------ | ----------------------- |
| `--http.config.file` | HTTP client configuration file for promtool to connect to Prometheus. |                         |
| `--url`              | The URL for the Prometheus server.                           | `http://localhost:9090` |

##### `promtool check rules`

Check if the rule files are valid or not.

###### Flags

| Flag           | Description                                                  | Default           |
| -------------- | ------------------------------------------------------------ | ----------------- |
| `--lint`       | Linting checks to apply. Available options are: all, duplicate-rules, none. Use --lint=none to disable linting | `duplicate-rules` |
| `--lint-fatal` | Make lint errors exit with exit code 3.                      | `false`           |

###### Arguments

| Argument   | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| rule-files | The rule files to check, default is read from standard input. |

##### `promtool check metrics`

Pass Prometheus metrics over stdin to lint them for consistency and correctness.

examples:

$ cat metrics.prom | promtool check metrics

$ curl -s http://localhost:9090/metrics | promtool check metrics

### `promtool query`

Run query against a Prometheus server.

#### Flags

| Flag                 | Description                                                  | Default  |
| -------------------- | ------------------------------------------------------------ | -------- |
| `-o`, `--format`     | Output format of the query.                                  | `promql` |
| `--http.config.file` | HTTP client configuration file for promtool to connect to Prometheus. |          |

##### `promtool query instant`

Run instant query.

###### Flags

| Flag     | Description                                        |
| -------- | -------------------------------------------------- |
| `--time` | Query evaluation time (RFC3339 or Unix timestamp). |

###### Arguments

| Argument | Description                 | Required |
| -------- | --------------------------- | -------- |
| server   | Prometheus server to query. | Yes      |
| expr     | PromQL query expression.    | Yes      |

##### `promtool query range`

Run range query.

###### Flags

| Flag       | Description                                         |
| ---------- | --------------------------------------------------- |
| `--header` | Extra headers to send to server.                    |
| `--start`  | Query range start time (RFC3339 or Unix timestamp). |
| `--end`    | Query range end time (RFC3339 or Unix timestamp).   |
| `--step`   | Query step size (duration).                         |

###### Arguments

| Argument | Description                 | Required |
| -------- | --------------------------- | -------- |
| server   | Prometheus server to query. | Yes      |
| expr     | PromQL query expression.    | Yes      |

##### `promtool query series`

Run series query.

###### Flags

| Flag      | Description                                       |
| --------- | ------------------------------------------------- |
| `--match` | Series selector. Can be specified multiple times. |
| `--start` | Start time (RFC3339 or Unix timestamp).           |
| `--end`   | End time (RFC3339 or Unix timestamp).             |

###### Arguments

| Argument | Description                 | Required |
| -------- | --------------------------- | -------- |
| server   | Prometheus server to query. | Yes      |

##### `promtool query labels`

Run labels query.

###### Flags

| Flag      | Description                                       |
| --------- | ------------------------------------------------- |
| `--start` | Start time (RFC3339 or Unix timestamp).           |
| `--end`   | End time (RFC3339 or Unix timestamp).             |
| `--match` | Series selector. Can be specified multiple times. |

###### Arguments

| Argument | Description                             | Required |
| -------- | --------------------------------------- | -------- |
| server   | Prometheus server to query.             | Yes      |
| name     | Label name to provide label values for. | Yes      |

### `promtool debug`

Fetch debug information.

##### `promtool debug pprof`

Fetch profiling debug information.

###### Arguments

| Argument | Description                                | Required |
| -------- | ------------------------------------------ | -------- |
| server   | Prometheus server to get pprof files from. | Yes      |

##### `promtool debug metrics`

Fetch metrics debug information.

###### Arguments

| Argument | Description                            | Required |
| -------- | -------------------------------------- | -------- |
| server   | Prometheus server to get metrics from. | Yes      |

##### `promtool debug all`

Fetch all debug information.

###### Arguments

| Argument | Description                                          | Required |
| -------- | ---------------------------------------------------- | -------- |
| server   | Prometheus server to get all debug information from. | Yes      |

### `promtool push`

Push to a Prometheus server.

#### Flags

| Flag                 | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| `--http.config.file` | HTTP client configuration file for promtool to connect to Prometheus. |

##### `promtool push metrics`

Push metrics to a prometheus remote write (for testing purpose only).

###### Flags

| Flag        | Description                                                  | Default        |
| ----------- | ------------------------------------------------------------ | -------------- |
| `--label`   | Label to attach to metrics. Can be specified multiple times. | `job=promtool` |
| `--timeout` | The time to wait for pushing metrics.                        | `30s`          |
| `--header`  | Prometheus remote write header.                              |                |

###### Arguments

| Argument         | Description                                                  | Required |
| ---------------- | ------------------------------------------------------------ | -------- |
| remote-write-url | Prometheus remote write url to push metrics.                 | Yes      |
| metric-files     | The metric files to push, default is read from standard input. |          |

### `promtool test`

Unit testing.

##### `promtool test rules`

Unit tests for rules.

###### Arguments

| Argument       | Description         | Required |
| -------------- | ------------------- | -------- |
| test-rule-file | The unit test file. | Yes      |

### `promtool tsdb`

Run tsdb commands.

##### `promtool tsdb bench`

Run benchmarks.

##### `promtool tsdb bench write`

Run a write performance benchmark.

###### Flags

| Flag        | Description                    | Default    |
| ----------- | ------------------------------ | ---------- |
| `--out`     | Set the output path.           | `benchout` |
| `--metrics` | Number of metrics to read.     | `10000`    |
| `--scrapes` | Number of scrapes to simulate. | `3000`     |

###### Arguments

| Argument | Description                                                  | Default                              |
| -------- | ------------------------------------------------------------ | ------------------------------------ |
| file     | Input file with samples data, default is (../../tsdb/testdata/20kseries.json). | `../../tsdb/testdata/20kseries.json` |

##### `promtool tsdb analyze`

Analyze churn, label pair cardinality and compaction efficiency.

###### Flags

| Flag         | Description                          | Default |
| ------------ | ------------------------------------ | ------- |
| `--limit`    | How many items to show in each list. | `20`    |
| `--extended` | Run extended analysis.               |         |

###### Arguments

| Argument | Description                                   | Default |
| -------- | --------------------------------------------- | ------- |
| db path  | Database path (default is data/).             | `data/` |
| block id | Block to analyze (default is the last block). |         |

##### `promtool tsdb list`

List tsdb blocks.

###### Flags

| Flag                     | Description                  |
| ------------------------ | ---------------------------- |
| `-r`, `--human-readable` | Print human readable values. |

###### Arguments

| Argument | Description                       | Default |
| -------- | --------------------------------- | ------- |
| db path  | Database path (default is data/). | `data/` |

##### `promtool tsdb dump`

Dump samples from a TSDB.

###### Flags

| Flag         | Description                | Default                 |
| ------------ | -------------------------- | ----------------------- |
| `--min-time` | Minimum timestamp to dump. | `-9223372036854775808`  |
| `--max-time` | Maximum timestamp to dump. | `9223372036854775807`   |
| `--match`    | Series selector.           | `{__name__=~'(?s:.*)'}` |

###### Arguments

| Argument | Description                       | Default |
| -------- | --------------------------------- | ------- |
| db path  | Database path (default is data/). | `data/` |

##### `promtool tsdb create-blocks-from`

[Experimental] Import samples from input and produce TSDB blocks. Please refer to the storage docs for more details.

###### Flags

| Flag                     | Description                  |
| ------------------------ | ---------------------------- |
| `-r`, `--human-readable` | Print human readable values. |
| `-q`, `--quiet`          | Do not print created blocks. |

##### `promtool tsdb create-blocks-from openmetrics`

Import samples from OpenMetrics input and produce TSDB blocks. Please refer to the storage docs for more details.

###### Arguments

| Argument         | Description                            | Default | Required |
| ---------------- | -------------------------------------- | ------- | -------- |
| input file       | OpenMetrics file to read samples from. |         | Yes      |
| output directory | Output directory for generated blocks. | `data/` |          |

##### `promtool tsdb create-blocks-from rules`

Create blocks of data for new recording rules.

###### Flags

| Flag                 | Description                                                  | Default                 |
| -------------------- | ------------------------------------------------------------ | ----------------------- |
| `--http.config.file` | HTTP client configuration file for promtool to connect to Prometheus. |                         |
| `--url`              | The URL for the Prometheus API with the data where the rule will be backfilled from. | `http://localhost:9090` |
| `--start`            | The time to start backfilling the new rule from. Must be a RFC3339 formatted date or Unix timestamp. Required. |                         |
| `--end`              | If an end time is provided, all recording rules in the rule files  provided will be backfilled to the end time. Default will backfill up to 3 hours ago. Must be a RFC3339 formatted date or Unix timestamp. |                         |
| `--output-dir`       | Output directory for generated blocks.                       | `data/`                 |
| `--eval-interval`    | How frequently to evaluate rules when backfilling if a value is not set in the recording rule files. | `60s`                   |

###### Arguments

| Argument   | Description                                                  | Required |
| ---------- | ------------------------------------------------------------ | -------- |
| rule-files | A list of one or more files containing recording rules to be  backfilled. All recording rules listed in the files will be backfilled.  Alerting rules are not evaluated. | Yes      |

### `promtool promql`

PromQL formatting and editing. Requires the `--experimental` flag.

##### `promtool promql format`

Format PromQL query to pretty printed form.

###### Arguments

| Argument | Description   | Required |
| -------- | ------------- | -------- |
| query    | PromQL query. | Yes      |

##### `promtool promql label-matchers`

Edit label matchers contained within an existing PromQL query.

##### `promtool promql label-matchers set`

Set a label matcher in the query.

###### Flags

| Flag           | Description                       | Default |
| -------------- | --------------------------------- | ------- |
| `-t`, `--type` | Type of the label matcher to set. | `=`     |

###### Arguments

| Argument | Description                        | Required |
| -------- | ---------------------------------- | -------- |
| query    | PromQL query.                      | Yes      |
| name     | Name of the label matcher to set.  | Yes      |
| value    | Value of the label matcher to set. | Yes      |

##### `promtool promql label-matchers delete`

Delete a label from the query.

###### Arguments

| Argument | Description                  | Required |
| -------- | ---------------------------- | -------- |
| query    | PromQL query.                | Yes      |
| name     | Name of the label to delete. | Yes      |