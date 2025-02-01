# touch

The `touch` command changes the timestamp of a file or creates an empty file if the file does not exist.

```
touch [-t date] file
```

Example:

```
$ touch /home/rockstar/myfile
```

| Option    | Information                                                  |
| --------- | ------------------------------------------------------------ |
| `-t date` | Changes the date of last modification of the file with the specified date. |

Date format: `[AAAA]MMJJhhmm[ss]`

!!! Tip The `touch` command is primarily used to create an empty file, but it can be useful for incremental or differential  backups for example. Indeed, the only effect of executing a `touch` on a file will be to force it to be saved during the next backup.