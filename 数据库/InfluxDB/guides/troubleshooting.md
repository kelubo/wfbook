---
title: Troubleshooting
---

This page addresses frequent sources of confusion and documents places where InfluxDB behaves in an unexpected way to other database systems. Outstanding issues and bugs which users may run into are also referenced here.

## Time Ranges

### Lower Bound

If you do not specify an explicit lower boundary for the time range of your query InfluxDB will use epoch 0 (1970-01-01T00:00:00Z) as the implicit lower boundary. This frequently causes unexpected results when using a `GROUP BY time` clause. See GitHub Issue [#2702](https://github.com/influxdb/influxdb/issues/2702) for more details. The fix is to specify an explicitly bounded time range containing fewer than 100,000 intervals of the supplied `GROUP BY` length. For example, if the query has `GROUP BY time(10m)` you must ensure the time range contains fewer than 1,000,000 minutes (10 minutes per interval * 100,000 intervals). 

### Upper Bound

If you do not specify an explicit upper boundary for the time range of your query InfluxDB will use `now()` as the implicit upper boundary. To query points in the future, you must explicitly set an upper boundary in the future. For example, `SELECT * FROM foo WHERE time < now() + 1000d`

### Special Times

#### now()

`now()` when used in queries returns the current nanosecond timestamp of the node processing the query. 

#### Oldest/Smallest Timestamp

The smallest valid timestamp is -9023372036854775808, (approximately 1684-01-22T14:50:02Z)

#### Newest/Largest Timestamp

The largest valid timestamp is 9023372036854775807, (approximately 2255-12-09T23:13:56Z)

#### Epoch 0

The timestamp value 0 is epoch (1970-01-01T00:00:00Z). Within InfluxDB, epoch 0 is often used as a `null` timstamp equivalent. If you request a query that has no timestamp to return, such as an aggregation function with an unbounded time range, you will get epoch 0 as the returned timestamp. See GitHub Issue [#3337](https://github.com/influxdb/influxdb/issues/3337) for more information.

#### Line Protocol bug with negative timestamps

InfluxDB does store negative UNIX timestamps but there is currently a bug in the line protocol parser that treats negative timestamps as invalid syntax (GitHub Issue [#3367](https://github.com/influxdb/influxdb/issues/3367).

#### Queries cannot return results that span Epoch 0

Points prior to epoch 0 (1970-01-01T00:00:00Z) are valid and should be written with negative timestamps. However, queries can only return points from before epoch 0 or after epoch 0, not both. A query with a time range that spans epoch 0 will only return partial results. See GitHub Issue [#2703](https://github.com/influxdb/influxdb/issues/2703) for more details.

#### Queries outside the maximum time range silently fail

Queries with a time range that exceeds the minimum or maximum timestamps valid for InfluxDB will currently return no results, rather than an error message. See GitHub Issue [#3369](https://github.com/influxdb/influxdb/issues/3369) for more information.

### Time Precision and trailing zeros

All timestamps are stored in the database as nanosecond values, regardless of the write precision supplied. When returning query results, trailing zeros are silently dropped from timestamps. See GitHub Issue [#2977](https://github.com/influxdb/influxdb/issues/2977) for more information.

### Math on Timestamps

It is not currently possible to execute mathematical operators or functions against timestamp values. All time calculations must be carried out by the client receiving the InfluxDB query results.

## Return Codes

### 2xx Means Understood
An HTTP status code of 204 is returned if InfluxDB could successfully parse the request that was sent. In the case that the request was understood but could not be completed, a 204 is still returned. However, the body of the response will contain an error message specifying what went wrong. A valid parseable query with no matching results will return a 204 with no error message.

### 4xx Means Not Understood
An HTTP status code of 4XX implies that the request that was sent in could not be understood and InfluxDB does not know what was being asked of it. These generally indicate a syntax error with the write or query request. 

### 5xx Means Cluster Not Healthy
An HTTP status code of 5XX implies that the `influxd` process is either down or significantly impaired. Further writes and reads are likely to fail permanently until the node or cluster is returned to health.

## Syntax Pitfalls

#### When writing integer values

When writing a point with an integer value you must add a trailing `i` to the end of the value. This allows influx to infer that an integer type is being written. If no `i` is provided, the value will be written as a float. For example `response_time,host=server1 value=100i` has an integer value of 100, where as `response_time,host=server1 value=100` has a floating point value of 100.

### When to Single-Quote

#### Querying

When querying, you must single-quote all string values. For example, `SELECT ... WHERE tag_key='tag_value'` Unquoted strings will be parsed as identifiers.

When querying, never single-quote identifiers. The will be parsed as strings, not identifiers. Double-quotes are used for identifiers.

See the [query syntax](https://influxdb.com/docs/v0.9/query_language/query_syntax.html) page for more information.

#### Writing

When writing via the line protocol, never use single-quotes. All special characters should be escaped, not quoted. See the [line protocol syntax](https://influxdb.com/docs/v0.9/write_protocols/write_syntax.html) page for more information.

#### Escaping the 'password' string

The `CREATE USER with PASSWORD 'password'` query always requires single-quoting the password string. There is a GitHub Issue [#123](https://github.com/influxdb/influxdb.com/issues/123) open against the documentation repo to determine and document proper escaping within the password string.

### When to Double-Quote

#### Querying

When querying, it is always safe to double-quote identifiers. Identifiers starting with a digit or containing characters other than `[A-z]`, `[0-9]`, or `_` must always be double-quoted. See the [query syntax](https://influxdb.com/docs/v0.9/query_language/query_syntax.html) page for more information.

#### Writing

When writing in the line protocol, never double-quote identifiers. Instead reserved characters should be escaped with backslash: `\`. 

When writing in the line protocol, you must always double-quote field values that are strings. Double-quoting a number or a boolean will store it as a string value for that field. 

See the [line protocol syntax](https://influxdb.com/docs/v0.9/write_protocols/write_syntax.html) page for more information.

### Reserved Words in InfluxQL

Use of any of the [InfluxQL Reserved Words](https://github.com/influxdb/influxdb/blob/master/influxql/INFLUXQL.md#keywords) as Identifiers or Strings will require quoting of the identifier or string in every use. It can lead to non-intuitive errors and is not recommended.

### Querying Booleans

Although the following are all valid syntax for writing boolean values: `t`, `T`, `true`, `True`, `TRUE`, `f`, `F`, `false`, `False`, and `FALSE`, only the full words are valid syntax when using booleans in the `WHERE` clause. When querying, you must use `true`, `True`, `TRUE`, `false`, `False`, or `FALSE`. 

For example, `SELECT ... WHERE tag1=True` will return all points with `tag1` set to TRUE, but `SELECT ... WHERE tag1=T` will return an empty set of points and no error.

### Characters That Complicate Regular Expressions

To keep regular expressions simple avoid using the following in identifiers and strings, if possible:

Backslash: `\`, up-carat: `^`, dollar-sign: `$`

## Architectural Limits

### 100000 Buckets For GROUP BY

When performing a `GROUP BY time`, the maximum number of time intervals that can be returned is 99,999. If the explicit or implicit time range covered by the query is greater than 99,999 times the GROUP BY interval length the query will return no results. 

To avoid this issue, always supply an explicit lower bound for your GROUP BY queries. Otherwise epoch 0 is used as the lower bound, and any GROUP BYinterval shorter than ~4 hours will exceed the maximum number of buckets. 

See GitHub Issue [#2702](https://github.com/influxdb/influxdb/issues/2702) for more information.

### 10000 Point Batches 

Query results will be returned in batches of 10,000 points each unless you explicitly control the return size with the `chunk_size` query string parameter. See GitHub Issue [#3242](https://github.com/influxdb/influxdb/issues/3242) for more information on the challenges this can cause, especially with Grafana visualization.

See GitHub Documentation Issue [#121](https://github.com/influxdb/influxdb.com/issues/121) to track the progress of properly documenting the `chunk_size` query string parameter.

### Signed 64-bit Integers

InfluxDB stores all integers as signed `int64` data types. The minimum and maximum valid values for `int64` are -9023372036854775808 and 9023372036854775807. See [Go builtins](http://golang.org/pkg/builtin/#int64) for more information. 

Values close to but within these limits may lead to unexpected results, as some functions and operators convert the `int64` data type to `float64` during calculation, causing overflow issues. See GitHub Issue [#3130](https://github.com/influxdb/influxdb/issues/3130) for more information.

### 64-bit Floats

InfluxDB stores all floating point values as signed `float64` data types. The largest valid value for `float64` is 1.797693134862315708145274237317043567981e+308. The smallest valid non-zero value for `float64` is 4.940656458412465441765687928682213723651e-324. See the [Go Math](http://golang.org/pkg/math/) description for more information.

### 64 KB Strings

The maximum length for a string in InfluxDB is 64 KB (65,536 bytes). 

