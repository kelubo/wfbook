---
title: Data Exploration
aliases:
  - /docs/v0.9/query_language/querying_data.html
---


InfluxDB features an SQL-like query language for querying data and performing aggregations on that data. This section describes the syntax of the query. All queries that return data use the keyword `SELECT`.

The primary mechanism for issuing any of the queries listed below is through the HTTP API. For example, the command `SELECT * FROM cpu` can be executed using `curl` as follows:

```sh
curl -G 'http://localhost:8086/query' --data-urlencode 'db=mydb' --data-urlencode 'q=SELECT * FROM cpu'
```

> **Note:** When querying large amounts of data, a `chunk_size` query parameter should be passed along with the request. By default the chunk size is 10,000.

```sh
curl -G 'http://localhost:8086/query' --data-urlencode 'db=mydb' --date-urlencode 'chunk_size=20000' --data-urlencode 'q=SELECT * FROM cpu'
```

<dt> For more information see [3242](https://github.com/influxdb/influxdb/issues/3242). </dt>

## Quote Usage
*Identifiers* are either unquoted or double quoted. Identifiers are database names, retention policies, measurements, or tag keys. String literals are always single quoted however.

Double quoted identifiers may contain any unicode character except a new line character. Double quoted identifiers can also contain escaped double quote characters (i.e., `\"`).

Unquoted identifiers must start with an upper or lowercase ASCII letter and can only contain ASCII letters, decimal digits, and the "_" or "." characters.

For Example:

To select from a measurement `(client)`:
```sql
SELECT * FROM "(client)"
```

To select for a `cpu` measurement with a tag key of `cpu_1` and tag value of `1`:
```sql
SELECT * FROM cpu
WHERE cpu_1 = '1'
```

To select for a `cpu` measurement with a tag key of `cpu-1` and tag value of `1`:
```sql
SELECT * FROM cpu
WHERE "cpu-1" = '1'
```

## Selecting the Database and Retention Period
When selecting data using the query language, the target database and retention period can optionally be specified. Doing so is known as "fully qualifying" your measurement. A fully-qualified measurement is in the following form:

```
"<database>"."<retention period>".<measurement>
```

So, for example, the following statement:

```sql
SELECT value FROM "mydb"."mypolicy".cpu_load
```

queries for data from the measurement `cpu_load` in the database `mydb`, that has been written to the retention policy `mypolicy`. In the event that the database is not specified, the database is determined by the URL parameter `db`. If the retention period is not specified, the query will use the default retention period for the database.

This feature is particularly useful if you wish to query data from different databases or retention periods, in one single query with multiple statements.

For information on retention policy management see the section on [database administration](/docs/v0.9/administration/administration.html).

## Statements

A query in InfluxDB can have multiple statements separated by semicolons. For example:

```sql
SELECT mean(value) FROM cpu
WHERE time > 12345678s
GROUP BY time(10m);
SELECT value from "hour_summaries".cpu
WHERE time > now() - 7d
```

## Select and Time Ranges

By default, InfluxDB returns data in time-ascending order.

```sql
SELECT value FROM response_times WHERE time > 1434059627s
```

This simple query pulls the values for the `value` column from the `response_times` series.

### How to set query start and end time

If start and end times aren't set they will default to beginning of time until now, respectively.

The column `time` is built in for every time series in the database. You specify the start and end times by setting conditions on the `time` columns in the where clause.

Below are the different formats that can be used to specify start and end times.

#### Date time strings

Date time strings have the format `YYYY-MM-DD HH:MM:SS.mmm` where `mmm` are the milliseconds within the second. For example:

```sql
SELECT value FROM response_times
WHERE time > '2013-08-12 23:32:01.232' AND time < '2013-08-13';
```

The time and date should be wrapped in single quotes. If you only specify the date, the time will be set to `00:00:00`. The `.232` after the hours, minutes, and seconds is optional and specifies the milliseconds.

#### Relative time

You can use `now()` to calculate a timestamp relative to the server's
current timestamp. For example:

```sql
SELECT value FROM response_times
WHERE time > now() - 1h limit 1000;
```

will return up to the first 1000 points starting an hour ago until now.

Other options for how to specify time durations are `u` for microseconds, `s` for seconds, `m` for minutes, `h` for hours, `d` for days and `w` for weeks. If no suffix is given the value is interpreted as microseconds.

#### Absolute time

Specify timestamp in epoch time, which is defined as the number of microseconds that have elapsed since 00:00:00 Coordinated Universal Time (UTC), Thursday, 1 January 1970. Use the same suffixes from the previous section to specify timestamps in other units. For example:

```sql
SELECT value FROM response_times
WHERE time > 1388534400s
```

will return all points that were writtern after `2014-01-01 00:00:00`

## Regular expressions

Regular expressions are surrounded by `/` characters and use Golang's regular expression syntax.  http://golang.org/pkg/regexp/syntax/.

```sql
/us.*/
```

> **NOTE:** Use of regular expressions is explained in the following sections.

## Arithmetic in expressions

Basic arithmetic operations can be performed when querying fields that store floats.

```sql
SELECT value / 2 from cpu_user

SELECT (value * 2) + 4 from cpu_user

SELECT (value + 6) / 10 from cpu_user
```

## Selecting Multiple Series

Select from multiple series by name or by specifying a regex to match against. Here are a few examples.
```sql
SELECT * FROM events, errors;
```

Get the most recent hour of data from the two series, events and errors. Here's a regex example:

```sql
SELECT * FROM /(?i)^stats\./
WHERE time > now() - 1h;
```

Get the last hour of data from every time series that starts with stats. (case insensitive). Another example:

```sql
SELECT * FROM /.*/ limit 1;
```

Return the oldest point from every time series in the database.

```sql
SELECT * FROM "otherDB"../disk.*/ LIMIT 1
```

Return the oldest 5 points from every time series in the database.

```sql
SELECT * FROM "otherDB"../disk.*/ LIMIT 5
```
Return all points of 1 series

```sql
SELECT * FROM "otherDB"../disk.*/ SLIMIT 1
```

Return all points of 5 series

```sql
SELECT * FROM "otherDB"../disk.*/ SLIMIT 5
```

> **Note:** `SLIMIT N` returns all of the points for `N` different series, where as `LIMIT N` returns `N` points from all matching series. The series are ordered by their internal InfluxDB index. Therefore although the results of `SLIMIT` are not intuitive, they are deterministic.

Return the oldest point from the 1h retention policy where the measurement name begins with lowercase disk.

```sql
SELECT * FROM "1h"./disk.*/ LIMIT 1
```

> **NOTE:** Regular expressions cannot be used to specify multiple databases or retention policies. Only measurements.

## Dropping measurements, series, and databases

You can drop individual series within a measurement that match given tags, or you can drop entire measurements. Some examples:

```sql
DROP MEASUREMENT response_times
```

Dropping a series by ID:

```sql
DROP SERIES 1
```

Dropping all series that match given tags:

```sql
DROP SERIES
WHERE host = 'serverA'
```

Dropping all series from a measurement that match a given tag:

```sql
DROP SERIES
FROM cpu
WHERE region = 'uswest'
```

Dropping a database:

```sql
DROP DATABASE mydb
```

## The SHOW Command

Show all databases in the server:

```sql
SHOW DATABASES
```

Show all measurements in the passed in database:

```sql
SHOW MEASUREMENTS
```

Find out what measurements we're taking for redis:

```sql
SHOW MEASUREMENTS WHERE service = 'redis'
```

Show series (unique tag sets) on the cpu measurement:

```sql
SHOW SERIES FROM cpu
```

Show series from cpu for a given host:

```sql
SHOW SERIES FROM cpu WHERE host = 'serverA'
SHOW SERIES FROM cpu WHERE host = 'serverA' OR host = 'serverB'
```

Show all measurements and their series for a given host:

```sql
SHOW SERIES WHERE host = 'serverA'
```

Show what tag keys we have:

```sql
SHOW TAG KEYS
```

Show what tag keys we have for a given measurement:

```sql
SHOW TAG KEYS FROM cpu
```

Show the tag values for a given key across all measurements: 

```sql
SHOW TAG VALUES WITH KEY = host
```

Show the tag values for a given measurement and tag key:

```sql
SHOW TAG VALUES FROM cpu WITH KEY = host
```

## The WHERE Clause

We've already seen the `WHERE` clause for selecting time ranges and a specific point. You can also use it to filter based on given field values, tags, or regexes. Here are some examples of different ways to use `WHERE`.

```sql
SELECT * FROM events
WHERE state = 'NY'

SELECT * FROM log_lines
WHERE line =~ /(?i)error/

SELECT * FROM events
WHERE customer_id = 23
  AND type = 'click'

SELECT * FROM response_times
WHERE value > 500
  AND region='us-west'

SELECT * FROM events
WHERE email !~ /.*gmail.*/

SELECT * FROM events
WHERE signed_in = false

SELECT * FROM events
WHERE (email =~ /.*gmail.*/
  OR email =~ /.*yahoo.*/)
  AND state = 'ny'
```

The WHERE clause supports comparisons against regexes, strings, booleans, floats, integers, and the times listed before. Comparators include `=` equal to, `>` greater than, `<` less than, `<>` not equal to, `=~` matches against, `!~` doesn't match against. You can chain logic together using `AND` and `OR` and you can separate using `(` and `)`

## GROUP BY

The `GROUP BY` clause in InfluxDB is used not only for grouping by given values, but also for grouping by given time buckets. You'll always be pairing this up with [a function](aggregate_functions.html) in the `SELECT` clause and possibly a specific time range in the `WHERE` clause. Here are a few examples to illustrate how `GROUP BY` works.

Count of events in the last hour in 10 minute intervals:

```sql
SELECT count(type) FROM events
WHERE time > now() - 1h
GROUP BY time(10m)
```

Count of each unique type of event in the last hour in 10 minute intervals:

```sql
SELECT count(type) FROM events
WHERE time > now() - 1h
GROUP BY time(10m), type
```

Count of each unique type of event in the last day grouped by host tag:

```sql
SELECT count(type) FROM events
WHERE time > now() - 1d
GROUP BY host
```

Show 95th percentile of response times in the last day in 30 second intervals:

```sql
SELECT percentile(value, 95) FROM response_times
WHERE time > now() - 1d
GROUP BY time(30s)
```

By default functions will output a column that has the same name as the function, e.g. `count` will output a column with the name `count`. In order to change the name of the column an `AS` clause is required. Here is an example to illustrate how aliasing works:

```sql
SELECT count(type) AS number_of_types
WHERE time > now() - 1d
GROUP BY time(10m);
```

The time function takes the time interval which can be in microseconds, seconds, minutes, hours, days or weeks. To specify the units you can use the respective suffix `u`, `s`, `m`, `h`, `d` and `w`.

If you issue a query that has an aggregate function like `count` but don't specify a `GROUP BY time` You will only get a single data point back with the number of count from time zero (00:00:00 UTC, Thursday, 1 January 1970).

If you have a `GROUP BY time` clause you should **always** have a `WHERE` clause that limits the scope of time you are looking at. Unless otherwise specified, `GROUP BY` will use `epoch 0` as the lower bound for the time range which is almost never what is desired.

### Filling intervals with no data

By default, `GROUP BY` intervals that have no data will use `null` as the value, by default, though any numerical value, including negative values, are valid values for `fill`. For example, each of the following queries is valid:

```sql
SELECT COUNT(type) FROM events
WHERE time > now() - 3h
GROUP BY time(1h) fill(0)
```
```sql
SELECT COUNT(type) FROM events
WHERE time > 12345678s
GROUP BY time(1h) fill(-1)
```

There are also special options for `fill`. Those values are `null`, `previous`, and `none`. `null` means null is used as the value for intervals without data. `previous` means the values of the previous window is used, and `none` means that all null values are removed. Examples of each are shown below.

```sql
SELECT COUNT(type) FROM events
WHERE time > now() - 3h
GROUP BY time(1h) fill(null)
```

```sql
SELECT COUNT(type) FROM events
WHERE time > now() - 3h
GROUP BY time(1h) fill(previous)
```

```sql
SELECT COUNT(type) FROM events
WHERE time > now() - 3h
GROUP BY time(1h) fill(none)
```

> **Note:** `fill` must go at the end of the group by clause if there are other arguments:

```sql
SELECT count(type) FROM events
WHERE time > 12345678s
GROUP BY time(1h), type fill(0)
```

## Merging Series

Queries merge series automatically for you on the fly. Remember that a series is a measurement plus its tag set. This means if you do a query like this:

```sql
SELECT mean(value) FROM cpu
WHERE time > now() - 1h
  AND region = 'uswest'
GROUP BY time(1m)
```

All the series under `cpu` that have the tag `region = 'uswest'` will be merged together before computing the mean.

## Limiting results returned

InfluxQL supports two different clauses to limit the results returned. They are currently mutually exclusive, so you may use one OR the other, but not both in the same query.

### Limiting results per series

Adding a `LIMIT n` clause to the end of your query will return the first N points found for each series in the measurement queried. Because `ORDER BY` is not yet functional (see GitHub Issue [#2022](https://github.com/influxdb/influxdb/issues/2022) for more information) the first N points will always be the _oldest_ N points by timestamp.

The following query will return the 10 oldest points from each series in the `cpu` measurement, meaning there will be 10 points returned for each unique tag set in `cpu`:

```sql
SELECT value FROM cpu LIMIT 10
```

> **Note:** If N is greater than the number of points in the series, all points in the series will be returned.

If instead we want the first 10 points from _any_ series in the `cpu` measurement, we should use `SLIMIT` rather than `LIMIT`

### Limiting results per measurement

Adding an `SLIMIT n` clause to the end of your query will return the first N points found in the measurement queried. Because `ORDER BY` is not yet functional (see GitHub Issue [#2022](https://github.com/influxdb/influxdb/issues/2022) for more information) the first N points will always be the _oldest_ N points by timestamp.

The following query will return the 10 oldest points less than an hour old in the `cpu` measurement, regardless of the tag set, meaning there will be at most 10 points returned:

```sql
SELECT value FROM cpu WHERE time > now() - 1h SLIMIT 10
```

> **Note:** If N is greater than the number of points in the measurement, all points in the measurement will be returned.

If instead we want the first 10 points from each series in the `cpu` measurement, we should use `LIMIT` rather than `SLIMIT`


## Querying with an OFFSET

Get the second 10 series from the region:

```sql
SELECT mean(value) FROM cpu
WHERE region = 'uswest'
  AND time > 12345678s
GROUP BY time(5m), *
LIMIT 10
OFFSET 10
```

Get the second 10 series from the region:

```sql
SELECT mean(value) FROM cpu
WHERE app =~ '.*someapp.*'
  AND time > now() - 4h
GROUP BY time(4m), *
LIMIT 10
OFFSET 10
```

## Getting series with special characters

InfluxDB allows you to use any characters in your time series names. However, parsing queries for those series can be tricky. So it's best to wrap your queries for any series that has characters other than letters in double quotes like this:

```sql
SELECT * FROM "series with special characters!"

SELECT * FROM "series with \"double quotes\""
```
