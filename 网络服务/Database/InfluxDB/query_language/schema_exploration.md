---
title: Schema Exploration
---

There are various ways to learn about the data contained within an InfluxDB system.

The primary mechanism for issuing any of the commands listed below is through the HTTP API. For example, the command `SHOW MEASUREMENTS` can be executed using `curl` as follows:

```sh
curl -G 'http://localhost:8086/query?db=mydb' --data-urlencode "q=SHOW MEASUREMENTS"
```

## Show Measurements
`SHOW MEASUREMENTS` shows all Measurements in the system.

_Example_

```sql
SHOW MEASUREMENTS
```

In the example response shown below, the system contains two measurements -- `cpu` and `network`. The first has a tag key `host`, and the second has two tags keys, `host` and `region`.

```json
{
    "results": [
        {
            "series": [
                {
                    "name": "measurements",
                    "columns": [
                        "name"
                    ],
                    "values": [
                        [
                            "cpu"
                        ],
                        [
                            "network"
                        ]
                    ]
                }
            ]
        }
    ]
}
```

You can also filter by tag key values with a `WHERE` clause. The following example shows all measurements that have a tag key/value pair of `service` and `redis`:

```sql
SHOW MEASUREMENTS
WHERE service = 'redis'
```

## Show Series
`SHOW SERIES` is somewhat similar to `SHOW MEASUREMENTS`, but also shows the distinct key-value pairs each tag key has within the system.

_Example_

```sql
SHOW SERIES
```

In the example response shown below, the system also contains two measurements, but note how the unique tag-key pairs are now shown.

```json
{
    "results": [
        {
            "series": [
                {
                    "name": "cpu",
                    "columns": [
                        "host"
                    ],
                    "values": [
                        [
                            "server01"
                        ]
                    ]
                },
                {
                    "name": "network",
                    "columns": [
                        "host",
                        "region"
                    ],
                    "values": [
                        [
                            "server01",
                            "us-west"
                        ],
                        [
                            "server01",
                            "us-east"
                        ]
                    ]
                }
            ]
        }
    ]
}
```

Or you can show the series for a specific measurement:

```sql
SHOW SERIES
FROM cpu_load
```

And you can further filter `SHOW SERIES` with a `WHERE` clause like you can with `SHOW MEASUREMENTS`

```sql
SHOW SERIES
FROM cpu_load
WHERE region = 'uswest'
```

## Show Tag Keys
`SHOW TAG KEYS` shows the unique tag keys associated with each measurement.

_Example_

```sql
SHOW TAG KEYS
```

An example response is shown below.

```json
{
    "results": [
        {
            "series": [
                {
                    "name": "cpu",
                    "columns": [
                        "tagKey"
                    ],
                    "values": [
                        [
                            "host"
                        ]
                    ]
                },
                {
                    "name": "network",
                    "columns": [
                        "tagKey"
                    ],
                    "values": [
                        [
                            "host"
                        ],
                        [
                            "region"
                        ]
                    ]
                }
            ]
        }
    ]
}
```

The query can include a condition, so only certain tag keys are shown.

```sql
SHOW TAG KEYS FROM network
```

In this case the response is:

```json
{
    "results": [
        {
            "series": [
                {
                    "name": "network",
                    "columns": [
                        "tagKey"
                    ],
                    "values": [
                        [
                            "host"
                        ],
                        [
                            "region"
                        ]
                    ]
                }
            ]
        }
    ]
}
```
## Show Tag Values
`SHOW TAG VALUES` shows the unique set of tag values for each measurement, for a given tag key.

_Example_

```sql
SHOW TAG VALUES WITH KEY=host
```

> **Note:** `host` is **not** quoted.

which results in the following response:

```json
{
    "results": [
        {
            "series": [
                {
                    "name": "cpu",
                    "columns": [
                        "tagValue"
                    ],
                    "values": [
                        [
                            "server01"
                        ]
                    ]
                },
                {
                    "name": "network",
                    "columns": [
                        "tagValue"
                    ],
                    "values": [
                        [
                            "server01"
                        ]
                    ]
                }
            ]
        }
    ]
}
```

And you can filter the tag values shown to only those associated with a specific measurement:

```sql
SHOW TAG VALUES
FROM cpu_load
WITH KEY=host
```
