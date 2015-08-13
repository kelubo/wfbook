---
title: Administration
aliases:
  - /docs/v0.9/query_language/database_administration.html
---

Full suite of administration commands are available through the query language. The administrative commands allow common database management operations such as

- Create and delete users, including admin users
- Set user passwords
- Create and delete databases
- Grant, alter, and revoke database access privileges
- Create and delete retention policies
- Delete measurements and series
- Create and delete continuous queries

> **Note:** When authentication is enabled, only admin users can execute most of the commands listed on this page. See the documentation on [authentication](authentication.html) and [authorization](authorization.html) for more information.

The commands listed below can be executed by sending the command to the HTTP API `/query` endpoint as the URL parameter `q`. For example, using `curl`,

```sh
curl -G 'http://localhost:8086/query' --data-urlencode "q=CREATE DATABASE mydb"
```

or using the `influx` command line interface,

```sh
influx -username test -password test
> CREATE DATABASE mydb
```

## Identifiers

An identifier is any user defined name or key, e.g. `mydb`.  Identifiers are used to reference databases, retention policies, measurements, and users, as well as tag keys and field keys.

Identifiers may be quoted or unquoted and must follow these rules:

- double quoted identifiers can contain any unicode character other than a new line
- double quoted identifiers can contain escaped `"` characters (i.e., `\"`)
- unquoted identifiers must start with an upper or lowercase ASCII character or "_"
- unquoted identifiers may contain only ASCII letters, decimal digits, and "_"

Throughout this page, identifiers are denoted by a word enclosed in `<>` characters, e.g. `<database>`.  

## Database Management
Databases can be created, dropped, and listed. User privileges are also set on a per-database basis.

### Creating a database
```sql
CREATE DATABASE <database>
```

An error is returned if a database with the same name already exists.

_Example_

```sql
CREATE DATABASE mydb
```
The response returned is:

```json
{"results":[{}]}
```

### Deleting a database
```sql
DROP DATABASE <database>
```

_Example_

```sql
DROP DATABASE mydb
```
The response returned is:

```json
{"results":[{}]}
```

The database must exist or an error is returned.

### Show existing databases
```sql
SHOW DATABASES
```

_Example_

```sql
CREATE DATABASE mydb
SHOW DATABASES
```

The response returned is:

```json
{
    "results":[
        {
            "series": [
                {
                    "columns": [
                        "Name"
                    ],
                    "values": [
                        [
                            "mydb"
                        ]
                    ]
                }
            ]
        }
    ]
}
```

## Retention Policy Management
Retention policies can be created, modified, listed, and deleted. 

### Auto-creation of retention policies
When a database is created, a retention policy named "default", with infinite retention, is automatically created for that database. This may not be desirable for certain deployments, and auto-creation can be disabled via the configuration file.

### Create a retention policy
```sql
CREATE RETENTION POLICY <retentionpolicy>
    ON <database>
    DURATION <duration>
    REPLICATION <n>
    [DEFAULT]
```

_Example_

```sql
CREATE RETENTION POLICY mypolicy
    ON mydb
    DURATION 1d
    REPLICATION 1
    DEFAULT
```
The response returned is:

```json
{"results":[{}]}
```
Durations such as `1h`, `90m`, `12h`, `7d`, and `4w`, are all supported and mean 1 hour, 90 minutes, 12 hours, 7 days, and 4 weeks, respectively. For infinite retention -- meaning the data will never be deleted -- use `INF` for duration. The minimum retention period is 1 hour.

### Show existing retention policies
To show the retention policies on a given database issue the following command:

```sql
SHOW RETENTION POLICIES ON <database>
```

_Example_

```sql
SHOW RETENTION POLICIES ON mydb
```

The response returned is:

```json
{
    "results": [
        {
            "series": [
                {
                    "columns": [
                        "name",
                        "duration",
                        "replicaN",
                        "default"
                    ],
                    "values": [
                        [
                            "mypolicy",
                            "9240h0m0s",
                            1,
                            true
                        ]
                    ]
                }
            ]
        }
    ]
}
```

### Modifying a retention policy
To modify a retention policy, issue the following command:

```sql
ALTER RETENTION POLICY <retentionpolicy>
    ON <database>
    [DURATION <duration>]
    [REPLICATION <n>] [DEFAULT]
```

At least 1 of `DURATION`, `REPLICATION`, or the `DEFAULT` flag must be set.

_Example_

```sql
ALTER RETENTION POLICY mypolicy
    ON mydb
    DURATION 2d
```

The response returned is:

```json
{"results":[{}]}
```

### Deleting a retention policy
To delete a retention policy, issue the following command:

```sql
DROP RETENTION POLICY <retentionpolicy> ON <database>
```

The response returned is:

```json
{"results":[{}]}
```


## User Management
Users can be created, modified, listed, and deleted.


### Creating a user
```sql
CREATE USER <username> WITH PASSWORD '<password>'
```

> **Note:** Passwords are [InfluxQL string literals](/docs/v0.9/query_language/spec.html#literals) and must be single quoted. Any single quotes or newlines in the password must be backslashed escaped.

_Example_

```sql
CREATE USER todd WITH PASSWORD 'mypassword'
```

### Changing a user's password
```sql
SET PASSWORD FOR <username> = '<password>'
```

_Example_

```sql
SET PASSWORD FOR todd = 'mynewpassword'
```

### Showing existing users
```sql
SHOW USERS
```

_Example_

```sql
CREATE USER todd WITH PASSWORD 'mypassword'
SHOW USERS
```

The response returned is:

```json
{
    "results": [
        {
            "series": [
                {
                    "columns": [
                        "user",
                        "admin"
                    ],
                    "values": [
                        [
                            "todd",
                            true
                        ]
                    ]
                }
            ]
        }
    ]
}
```

### Deleting a user

```sql
DROP USER <username>
```

_Example_

```sql
DROP USER todd
```

The response returned is:

```json
{"results":[{}]}
```

## Privilege Control
In InfluxDB, privileges are controlled on per-database user. Any given user can have `READ`, `WRITE`, or `ALL` access to an individual database. Until a user is granted privileges on a given database, that user has no access to it whatsoever.

A user can also be granted cluster administration privilege, which overrides any per-database privileges.

### Granting privileges

```sql
GRANT READ|WRITE|ALL
    ON <database>
    TO <user>
```

_Example_

```sql
GRANT READ
    ON mydb
    TO todd
```

The response returned is:

```json
{"results":[{}]}
```

### Revoking privileges

```sql
REVOKE READ|WRITE|ALL
    ON <database>
    FROM <user>
```

> **Note:** If a user with ALL privileges has WRITE privileges revoked, they will be left with READ privileges and vice versa.

_Example_

```sql
REVOKE ALL
    ON mydb
    FROM todd
```

The response returned is:

```json
{"results":[{}]}
```

### Granting cluster administration privileges to new users
```sql
CREATE USER <user>
    WITH PASSWORD <password>
    WITH ALL PRIVILEGES
```

_Example_

```sql
CREATE USER paul
    WITH PASSWORD 'somepassword'
    WITH ALL PRIVILEGES
```

The response returned is:

```json
{"results":[{}]}
```

### Granting cluster administration privileges to existing users
```sql
GRANT ALL PRIVILEGES TO <user>
```

_Example_

```sql
GRANT ALL PRIVILEGES TO todd
```

The response returned is:

```json
{"results":[{}]}
```

### Showing cluster administrators
```sql
SHOW USERS
```

_Example_

```bash
SHOW USERS
```

The response returned is:

```json
{
    "results": [
        {
            "series": [
                {
                    "columns": [
                        "user",
                        "admin"
                    ],
                        "values": [
                        [
                            "paul",
                            true
                        ],
                        [
                            "todd",
                            true
                        ]
                    ]
                }
            ]
        }
    ]
}
```

### Revoke cluster administration privileges

```sql
REVOKE ALL PRIVILEGES FROM <user>
```

_Example_

```sql
REVOKE ALL PRIVILEGES FROM todd
```

The response returned is:

```json
{"results":[{}]}
```
