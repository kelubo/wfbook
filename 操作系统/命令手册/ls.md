# ls

显示目录与文件信息。

```bash
ls	[选项]...	[文件/目录]...

-a			显示所有的信息，包括隐藏文件与目录。
--color=*	支持颜色输出。默认值是 always（总显示颜色）。
			其他值：never（从不显示颜色）和 auto（自动）
-d			显示目录本身的信息，而非目录下的资料信息。
-h			人性化显示容量，按照习惯的单位显示文件大小。
-i			显示文件的 inode 号。
-l			长格式显示详细信息。
-c			显示文件或目录属性最后修改的时间。
-u			显示文件或目录最后被访问的时间。
-t			以修改时间排序，默认按文件名排序。
```

The `ls` command displays the contents of a directory



Example:

```
$ ls /home
.    ..    rockstar
```

The main options of the `ls` command are:

| Option | Information                                                  |
| ------ | ------------------------------------------------------------ |
| `-a`   | Displays all files, even hidden ones. Hidden files in Linux are those beginning with `.`. |
| `-i`   | Displays inode numbers.                                      |
| `-l`   | The `-l` command displays a vertical list of files with additional information formatted in columns. |

The `ls` command, however, has a lot of options (see `man`):

| Option | Information                                                  |
| ------ | ------------------------------------------------------------ |
| `-d`   | Displays information about a directory instead of listing its contents. |
| `-g`   | Displays UID and GID rather than owner names.                |
| `-h`   | Displays file sizes in the most appropriate format (byte, kilobyte, megabyte, gigabyte, ...). `h` stands for Human Readable. |
| `-s`   | Displays the size in bytes (unless `k` option).              |
| `-A`   | Displays all files in the directory except `.` and `.`.      |
| `-R`   | Displays the contents of subdirectories recursively.         |
| `-F`   | Displays the type of files. Prints a `/` for a directory, `*` for executables, `@` for a symbolic link, and nothing for a text file. |
| `-X`   | Sort files according to their extensions.                    |

- Description of columns:

```
$ ls -lia /home
78489 drwx------ 4 rockstar rockstar 4096 25 oct. 08:10 rockstar
```

| Value           | Information                                                  |
| --------------- | ------------------------------------------------------------ |
| `78489`         | Inode Number.                                                |
| `drwx------`    | File type (`d`) and rights (`rwx------`).                    |
| `4`             | Number of subdirectories (`.` and `..` included). For a file of type physical link: number of physical links. |
| `rockstar`      | For a physical link file: number of physical links.          |
| `rockstar`      | For a file of type physical link: number of physical links.  |
| `4096`          | For a physical link type file: number of physical links.     |
| `25 oct. 08:10` | Last modified date.                                          |
| `rockstar`      | The name of the file (or directory).                         |

!!! Note **Aliases** are frequently positioned in common distributions.

````
This is the case of the alias `ll`:

```
alias ll='ls -l --color=auto'
```
````

The `ls` command has many options and here are some advanced examples of uses:

- List the files in `/etc` in order of last modification:

```
$ ls -ltr /etc
total 1332
-rw-r--r--.  1 root root    662 29 may   2021 logrotate.conf
-rw-r--r--.  1 root root    272 17 may.   2021 mailcap
-rw-------.  1 root root    122 12 may.  2021 securetty
...
-rw-r--r--.  2 root root     85 18 may.  17:04 resolv.conf
-rw-r--r--.  1 root root     44 18 may.  17:04 adjtime
-rw-r--r--.  1 root root    283 18 may.  17:05 mtab
```

- List `/var` files larger than 1 megabyte but less than 1 gigabyte:

```
$ ls -Rlh /var | grep [0-9]M
...
-rw-r--r--. 1 apache apache 1,2M 10 may.  13:02 XB RiyazBdIt.ttf
-rw-r--r--. 1 apache apache 1,2M 10 may.  13:02 XB RiyazBd.ttf
-rw-r--r--. 1 apache apache 1,1M 10 may.  13:02 XB RiyazIt.ttf
...
```

- Show the rights on a folder:

To find out the rights to a folder, in our example `/etc`, the following command would not be appropriate:

```
$ ls -l /etc
total 1332
-rw-r--r--.  1 root root     44 18 nov.  17:04 adjtime
-rw-r--r--.  1 root root   1512 12 janv.  2010 aliases
-rw-r--r--.  1 root root  12288 17 nov.  17:41 aliases.db
drwxr-xr-x.  2 root root   4096 17 nov.  17:48 alternatives
...
```

since the command lists by default the contents of the folder and not the container.

To do this, use the `-d` option:

```
$ ls -ld /etc
drwxr-xr-x. 69 root root 4096 18 nov.  17:05 /etc
```

- List files by size:

```
$ ls -lhS
```

- Display the modification date in "timestamp" format:

```
$ ls -l --time-style="+%Y-%m-%d %m-%d %H:%M" /
total 12378
dr-xr-xr-x. 2 root root 4096 2014-11-23 11-23 03:13 bin
dr-xr-xr-x. 5 root root 1024 2014-11-23 11-23 05:29 boot
```

- Add the *trailing slash* to the end of folders:

By default, the `ls` command does not display the last slash of a folder. In some cases, like for scripts for example, it is useful to display them:

```
$ ls -dF /etc
/etc/
```

- Hide some extensions:

```
$ ls /etc --hide=*.conf
```

