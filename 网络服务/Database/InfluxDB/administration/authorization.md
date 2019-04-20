---
title: Authorization
---

Authorization is set by granting users privileges to access a database or execute administration queries.

Authorization is only enforced when [authentication](authentication.html) is enabled.  When authentication is disabled, all users have all privileges.

## Privilege levels

There are two levels of authorization privileges.

- Administration privileges, allow full access to all databases and administration queries
- Database access privileges, allow read, write, or both read and write access to specific databases

## Administration privileges

Users with administration privileges are known as admin users. Admin users have read and write access for all databases.

Admin users are authorized to execute all of the following administration queries.

- Create and delete users, including admin users
- Set user passwords
- Create and delete databases
- Grant, alter, and revoke database access privileges
- Create and delete retention policies
- Delete measurements and series
- Create and delete continuous queries

The [administration page](administration.html) describes the full syntax of all administration queries.

## Database access privileges

Users may be assigned one of the following three access privileges per database:

- `READ`
- `WRITE`
- `ALL`, grants `READ` and `WRITE`

Admin users have `ALL` privileges for all databases even if they have different privileges set for a particular database.

## Error messages

When auth is enabled, HTTP requests by authenticated users lacking read or write privileges on a database will receive a `HTTP 401 Unauthorized` response.

When auth is disabled, all credentials are silently ignored and all users have all privileges (no authorization is enforced).
