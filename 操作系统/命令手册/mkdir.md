# mkdir

The `mkdir` command creates a directory or directory tree.

```
mkdir [-p] directory [directory] [...]
```

Example:

```
$ mkdir /home/rockstar/work
```

The "rockstar" directory must exist to create the "work" directory. Otherwise, the `-p` option should be used. The `-p` option creates the parent directories if they do not exist.

!!! Danger It is not recommended to use Linux command names as directory or file names.