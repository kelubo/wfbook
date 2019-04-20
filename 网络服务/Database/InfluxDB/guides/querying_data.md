---
title: Querying Data
alias:
  -/docs/v0.9/query_language/querying_data.html
---

The HTTP API is also the primary means for querying data contained within InfluxDB. To perform a query send a `GET` to the endpoint `/query`, set the URL parameter `db` as the target database, and set the URL parameter `q` as your query. An example query, sent to a locally-running InfluxDB server, is shown below.

```sh
curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "q=SELECT value FROM cpu_load_short WHERE region='us-west'"
```

Which returns:

```json
{
    "results": [
        {
            "series": [
                {
                    "name": "cpu_load_short",
                    "tags": {
                        "host": "server01",
                        "region": "us-west"
                    },
                    "columns": [
                        "time",
                        "value"
                    ],
                    "values": [
                        [
                            "2015-01-29T21:51:28.968422294Z",
                            0.64
                        ]
                    ]
                }
            ]
        }
    ]
}
```

In general the response body will be of the following form:

```json
{
    "results": [
        {
            "series": [{}],
            "error": "...."
        }
    ],
    "error": "...."
}
```

There are two top-level keys. `results` is an array of objects, one for each query, each containing the keys for a `series`. Each _row_ contains a data point returned by the query. If there was an error processing the query, the `error` key will be present, and will contain information explaining why the query failed. An example of this type of failure would be a syntax error or illegal operation in the query.

The second top-level key is also named `error`, and is set if the API call failed before InfluxDB could perform any *query* operations. A example of this kind of failure would be invalid authentication credentials.

### Timestamp Format

The format of the returned timestamps complies with RFC3339, and has nanosecond precision. By default, timestamps are returned in RFC3339 UTC, for example `2015-08-04T19:05:14.318570484Z`. The query string parameter `epoch` will cause the timestamps to come back in Unix epoch format.

#### Timestamps can be returned in various different formats

Default UTC:
```sh
curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "q=SELECT value FROM cpu_load_short WHERE region='us-west'"
```

Epoch in Seconds:
```sh
curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "epoch=s" --data-urlencode "q=SELECT value FROM cpu_load_short WHERE region='us-west'"
```

Epoch in Milliseconds:
```sh
curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "epoch=ms" --data-urlencode "q=SELECT value FROM cpu_load_short WHERE region='us-west'"
```

Epoch in Nanoseconds:
```sh
curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "epoch=ns" --data-urlencode "q=SELECT value FROM cpu_load_short WHERE region='us-west'"

curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "epoch=true" --data-urlencode "q=SELECT value FROM cpu_load_short WHERE region='us-west'"
```

### Multiple queries

Multiple queries can be sent to InfluxDB in a single API call. Simply delimit each query using a semicolon, as shown in the example below.

```sh
curl -G 'http://localhost:8086/query' --data-urlencode "db=mydb" --data-urlencode "q=SELECT * FROM cpu_load_short WHERE region=us-west;SELECT * FROM temperature"
```

## Authentication
Authentication is disabled by default. If authentication is enabled, user credentials must be supplied with every query. These can be suppled via the URL parameters `u` and `p`. For example, if the user is "bob" and the password is "mypass", then endpoint URL should take the form `/query?u=bob&p=mypass`.

The credentials may also be passed using _Basic Authentication_. If both types of authentication are present in a request, the URL parameters take precedence.

## Pretty Printing
When working directly with the API it is often convenient to have pretty-printed JSON output. To enable pretty-printed output, append `pretty=true` to the URL. For example:

```sh
curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=mydb" --data-urlencode "q=SELECT * FROM cpu_load_short"
```

Pretty-printed output is useful for debugging or when querying directly using tools like `curl`, etc., It is not recommended for production use as it consumes unnecessary network bandwidth.
