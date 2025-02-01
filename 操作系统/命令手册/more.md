### `more` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/03-commands/#more-command)

The `more` command displays the contents of one or more files screen by screen.

```
more file1 [files]
```

Example:

```
$ more /etc/passwd
root:x:0:0:root:/root:/bin/bash
...
```

Using the ENTER key, the move is line by line. Using the SPACE key, the move is page by page. `/text` allows you to search for the occurrence in the file.