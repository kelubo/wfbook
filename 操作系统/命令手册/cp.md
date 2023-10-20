### `cp` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/03-commands/#cp-command)

The `cp` command copies a file.

```
cp file [file ...] destination
```

Example:

```
$ cp -r /home/rockstar /tmp
```

| Options | Information                                                  |
| ------- | ------------------------------------------------------------ |
| `-i`    | Request confirmation if overwriting (default).               |
| `-f`    | Do not ask for confirmation if overwriting the destination file. |
| `-p`    | Keeps the owner, permissions and timestamp of the copied file. |
| `-r`    | Copies a directory with its files and subdirectories.        |
| `-s`    | Creates a symbolik links rather than copying                 |

```
cp file1 /repexist/file2
```

`file1` is copied to `/repexist` under the name `file2`.

```
$ cp file1 file2
```

`file1` is copied as `file2` to this directory.

```
$ cp file1 /repexist
```

If the destination directory exists, `file1` is copied to `/repexist`.

```
$ cp file1 /wrongrep
```

If the destination directory does not exist, `file1` is copied under the name `wrongrep` to the root directory.