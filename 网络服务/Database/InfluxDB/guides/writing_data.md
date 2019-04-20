---
title: Writing Data
aliases:
  - /docs/v0.9/concepts/reading_and_writing_data.html
---

There are many ways to write data into InfluxDB including the built-in HTTP API, client libraries, and integrations with external data sources such as Collectd.

## Writing data using the HTTP API
The HTTP API is the primary means of putting data into InfluxDB. To write data simply send a `POST` to the endpoint `/write`. The destination database must be specified as a query parameter and the body of the POST must contain the retention policy and time-series data you wish to store. An example request sent to InfluxDB running on localhost, which writes a single point, is shown below.

```sh
# Create your new database, this only needs to be done once.
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE mydb"

# Write a point to your new database.
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'
```

The actual point represents a combination of elements which follow the line protocol format, which has the following structure.



the short-term CPU-load _cpu_load_short_ (called a measurement) on host _server01_ (called a tag) in a region _us-west_ (another tag) with a value (called a field). A measurement name is required. Strictly speaking _tags_ are optional but most series include tags to differentiate data sources. The `timestamp` is also optional. If you do not specify a timestamp the server's local timestamp will be used.


In the example above. the destination database is `mydb` and the retention policy `default`. A retention policy describes how long data is kept. A retention policy named `default` with an infinite retention time is created automatically for every new database. When writing points, the database query parameter (`db`) must be specified in the request body and must already exist. The retention policy query parameter (`rp`) is optional, but if specified, the retention policy must already exist. If `rp` is not specified, the default retention policy for the given database is used. The automatically created `default` retention policy is the default retention policy for all new databases.


### Schemaless Design
InfluxDB is schemaless so the series and columns (fields and tags) get created on the fly. You can add columns to existing series without penalty. Tag keys, tag values, and field keys are always strings, but field values may be integers, floats, strings, or booleans. If you attempt to write data with a different type than previously used (for example writing a string to a tag that previously accepted integers), InfluxDB will reject the data.

### Writing multiple points
As you can see in the example below, you can post multiple points to multiple series at the same time by separating each point with a new line. Batching points in this manner will result in much higher performance.

```sh
curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64
cpu_load_short,host=server02,region=us-west value=0.55 1422568543702900257
cpu_load_short,direction=in,host=server01,region=us-west value=23422.0 1422568543702900257'
```

### Tags
Each point can have a set of key-value pairs associated with it. Both keys and values must be strings. Tags allow data to be easily and efficient queried, including or excluding data that matches a set of keys with particular values.

### Fields

Each point can have a set of key-value pairs associated with it. The keys must be strings; values can be a float, integer, boolean, or string. Once a field key is set its type cannot be changed.

> **Note:** To write a field value as an integer, a trailing `i` must be added when the point is being inserted. For example the point `cpu,host=server1 value=10i` has an integer value of 10, where as the point `cpu,host=server1 value=10` has a floating point value of 10.

### Time format
The following time format is accepted:

_Epoch and Precision_

Timestamps can be supplied as an integer value at the end of the line. The precision is configurable per-request by including a `precision` url parameter. If no precision is specified, the line protocol will default to nanosecond precision. For example to set the time in seconds, use the following request.

```sh
curl -i -XPOST 'http://localhost:8086/write?db=mydb&precision=s' --data-binary 'temperature,machine=unit42,type=assembly external=25,internal=37 1434059627'
```

`n`, `u`, `ms`, `s`, `m`, and `h` are all supported and represent nanoseconds, microseconds, milliseconds, seconds, minutes, and hours, respectively.

### Response
Once a configurable number of servers have acknowledged the write, the node that initially received the write responds with `HTTP 204 NO CONTENT`.

#### Errors
If an error was encountered while processing the data, InfluxDB will respond with either a `HTTP 400 Bad Request` or, in certain cases, with `HTTP 200 OK`. The former is returned if the request could not be understood. In the latter, InfluxDB could understand the request, but processing cannot be completed. In this case a JSON response is included in the body of the response with additional error information.

For example, issuing a bad query such as:

```sh
curl -G http://localhost:8086/query --data-urlencode "db=foo" --data-urlencode "q=show"
```

will result in `HTTP 400 Bad Request` with the the following JSON in the body of the response:

```json
{"error":"error parsing query: found EOF, expected SERIES, CONTINUOUS, MEASUREMENTS, TAG, FIELD, RETENTION at line 1, char 6"}
```
