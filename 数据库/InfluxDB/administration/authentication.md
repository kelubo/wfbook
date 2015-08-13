---
title: Authentication
aliases:
  - /docs/v0.9/concepts/authentication_and_authorization.html
---

The InfluxDB HTTP API includes simple, built-in authentication based on user credentials. When authentication is enabled and configured, only HTTP requests sent with valid credentials will be executed. See the [Authorization](authorization.html) page for information on granting access privileges.

Authentication is __disabled__ by default. All HTTP requests are executed when authentication is disabled.

_Note: Authentication only occurs at the HTTP request scope. Plugins do not currently have the ability to authenticate requests._

## Setting up authentication

When authentication is enabled, every request must be accompanied by a valid username and the correct password for that username.

If no users exists, InfluxDB will __not__ enforce authentication (see below) until at least one user exists. Once at least one user exists, authentication is enforced.

While there are no users and authentication is not enforced, only the `CREATE USER <user> WITH PASSWORD <password> WITH ALL PRIVILEGES` query can be executed. This is meant to make bootstrapping an authenticated instance easier. Only an [admin user]({{< relref "docs/v0.9/administration/authorization.md#privilege-control" >}}) is allowed to be created when no users exist.

## Enable authentication

To enable authentication, set the `auth-enabled` option to `true` in the `[http]` section of the configuration file (shown below) and restart `influxd`.

```
[http]
  ...
  auth-enabled = true
  ...
```

### Authenticating requests

When authentication is enabled, user credentials must be supplied with every request via one of following two methods:

- _Basic Authentication_, as described in [RFC 2617, Section 2](http://tools.ietf.org/html/rfc2617). (This is the preferred method for providing user credentials.)
- _query parameters in the URL_, with `u` set as the username and `p` set as the password.

If both are present in the same request, user credentials specified in the URL query parameters take precedence over those specified in Basic Auth.

_Example_

Send a request with user credentials via _Basic Authentication_.

```sh
curl -G http://localhost:8086/query -u mydb_username:mydb_password --data-urlencode "q=CREATE DATABASE mydb"
```

Send a request with user credentials via query parameters.

```sh
curl -G http://localhost:8086/query --data-urlencode "u=mydb_username" --data-urlencode "p=mydb_password" --data-urlencode "q=CREATE DATABASE mydb"
```

_Note: The example above will fail if the user is not an admin user. Only admin users are allowed to create databases. See the [authorization page](authorization.html) for information on privileges._ 

User credentials are checked on every request when authentication is enabled. When authentication is disabled, credentials are never checked (and the `p` query parameter is not be redacted in the InfluxDB logs). 

Only requests supplied with valid credentials for an existing user are processed. Requests with invalid credentials are rejected with a HTTP `401 Unauthorized` response. An authenticated request may still fail if the user is not [authorized](authentication.html) to execute the requested operation.

## Error messages

When auth is enabled, all HTTP requests with invalid credentials will receive a `HTTP 401 Unauthorized` response.

## Security in production environments

Authentication and authorization should not be relied upon to prevent access and protect data from malicious actors.  If additional security or compliance features are desired, InfluxDB should be run behind a third-party service.

## Authentication for services

Service endpoints (Graphite, collectd, etc.) are not authenticated.
