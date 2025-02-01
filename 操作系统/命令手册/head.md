### `head` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/03-commands/#head-command)

The `head` command displays the beginning of a file.

```
head [-n x] file
```

| Option | Observation                             |
| ------ | --------------------------------------- |
| `-n x` | Display the first `x` lines of the file |

By default (without the `-n` option), the `head` command will display the first 10 lines of the file.