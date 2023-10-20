### `rm` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/03-commands/#rm-command)

The `rm` command deletes a file or directory.

```
rm [-f] [-r] file [file] [...]
```

!!! Danger Any deletion of a file or directory is final.

| Options | Information                              |
| ------- | ---------------------------------------- |
| `-f`    | Do not ask for confirmation of deletion. |
| `-i`    | Requires confirmation of deletion.       |
| `-r`    | Recursively deletes subdirectories.      |

!!! Note The `rm` command itself does not ask for confirmation when deleting files. However, with a RedHat/Rocky distribution, `rm` does ask for confirmation of deletion because the `rm` command is an `alias` of the `rm -i` command. Don't be surprised if on another distribution, like Debian for example, you don't get a confirmation request.

Deleting a folder with the `rm` command, whether the folder is empty or not, will require the `-r` option to be added.

The end of the options is signaled to the shell by a double dash `--`.

In the example:

```
$ >-hard-hard # To create an empty file called -hard-hard
hard-hard
[CTRL+C] To interrupt the creation of the file
$ rm -f -- -hard-hard
```

The hard-hard file name starts with a `-`. Without the use of the `--` the shell would have interpreted the `-d` in `-hard-hard` as an option.