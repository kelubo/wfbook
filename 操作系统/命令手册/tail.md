### `tail` command[¶](https://docs.rockylinux.org/zh/books/admin_guide/03-commands/#tail-command)

The `tail` command displays the end of a file.

```
tail [-f] [-n x] file
```

| Option | Observation                               |
| ------ | ----------------------------------------- |
| `-n x` | Displays the last `x` lines of the file   |
| `-f`   | Displays changes to the file in real time |

Example:

```
tail -n 3 /etc/passwd
sshd:x:74:74:Privilege-separeted sshd:/var/empty /sshd:/sbin/nologin
tcpdump::x:72:72::/:/sbin/nologin
user1:x:500:500:grp1:/home/user1:/bin/bash
```

With the `-f` option, the `tail` command does not give back and runs until the user interrupts it with the sequence CTRL + C. This option is very frequently used to track log files (the logs) in real time.

Without the `-n` option, the tail command displays the last 10 lines of the file.