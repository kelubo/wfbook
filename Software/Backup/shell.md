# How to back up using shell scripts 如何使用 shell 脚本进行备份

In general, a shell script configures which directories to backup, and passes those directories as arguments to the `tar` utility, which creates an archive file. The archive file can then be  moved or copied to another location. The archive can also be created on a remote file system such as a [Network File System (NFS)](https://ubuntu.com/server/docs/network-file-system-nfs) mount.
通常，shell 脚本会配置要备份的目录，并将这些目录作为参数传递给 `tar` 实用程序，该实用程序将创建归档文件。然后，可以将存档文件移动或复制到其他位置。还可以在远程文件系统（如网络文件系统 （NFS） 挂载）上创建归档文件。

The `tar` utility creates one archive file out of many files or directories. `tar` can also filter the files through compression utilities, thus reducing the size of the archive file.
该 `tar` 实用程序从多个文件或目录中创建一个存档文件。 `tar` 还可以通过压缩实用程序过滤文件，从而减小存档文件的大小。

In this guide, we will walk through how to use a shell script for backing  up files, and how to restore files from the archive we create.
在本指南中，我们将介绍如何使用 shell 脚本备份文件，以及如何从我们创建的存档中恢复文件。

## The shell script shell 脚本

The following shell script uses the basic backup shell script from our Reference section. It uses `tar` to create an archive file on a remotely mounted NFS file system. The  archive filename is determined using additional command line utilities.  For more details about the script, check out the [example Reference page](https://ubuntu.com/server/docs/basic-backup-shell-script).
以下 shell 脚本使用参考部分中的基本备份 shell 脚本。它用于 `tar` 在远程挂载的 NFS 文件系统上创建存档文件。存档文件名是使用其他命令行实用程序确定的。有关脚本的更多详细信息，请查看示例参考页面。

```sh
#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################
    
# What to backup. 
backup_files="/home /var/spool/mail /etc /root /boot /opt"
    
# Where to backup to.
dest="/mnt/backup"
    
# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"
    
# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo
    
# Backup the files using tar.
tar czf $dest/$archive_file $backup_files
    
# Print end status message.
echo
echo "Backup finished"
date
    
# Long listing of files in $dest to check file sizes.
ls -lh $dest
```

## Running the script 运行脚本

### Run from a terminal 从终端运行

The simplest way to use the above backup script is to copy and paste the contents into a file (called `backup.sh`, for example). The file must be made executable:
使用上述备份脚本的最简单方法是将内容复制并粘贴到文件中（例如，称为 `backup.sh` ）。该文件必须可执行：

```bash
chmod u+x backup.sh
```

Then from a terminal prompt, run the following command:
然后，在终端提示符下，运行以下命令：

```bash
sudo ./backup.sh
```

This is a great way to test the script to make sure everything works as expected.
这是测试脚本以确保一切按预期工作的好方法。

### Run with `cron` 运行方式 `cron` 

The `cron` utility can be used to automate use of the script. The `cron` daemon allows scripts, or commands, to be run at a specified time and date.
该 `cron` 实用程序可用于自动使用脚本。 `cron` 守护程序允许在指定的时间和日期运行脚本或命令。

`cron` is configured through entries in a `crontab` file. `crontab` files are separated into fields:
 `cron` 通过 `crontab` 文件中的条目进行配置。 `crontab` 文件分为多个字段：

```console
# m h dom mon dow   command
```

Where: 哪里：

- `m`: The minute the command executes on, between 0 and 59.
   `m` ：命令执行的分钟数，介于 0 和 59 之间。
- `h`: The hour the command executes on, between 0 and 23.
   `h` ：命令执行的时间，介于 0 和 23 之间。
- `dom`: The day of the month the command executes on.
   `dom` ：执行命令的月份中的某一天。
- `mon`: The month the command executes on, between 1 and 12.
   `mon` ：执行命令的月份，介于 1 和 12 之间。
- `dow`: The day of the week the command executes on, between 0 and 7. Sunday may be specified by using 0 or 7, both values are valid.
   `dow` ：执行命令的星期几，介于 0 和 7 之间。可以使用 0 或 7 指定星期日，这两个值都有效。
- `command`: The command to run.
   `command` ：要运行的命令。

To add or change entries in a `crontab` file the `crontab -e` command should be used. Also note the contents of a `crontab` file can be viewed using the `crontab -l` command.
若要在 `crontab` 文件中添加或更改条目，应使用该 `crontab -e` 命令。另请注意，可以使用命令 `crontab -l` 查看 `crontab` 文件的内容。

To run the `backup.sh` script listed above using `cron`, enter the following from a terminal prompt:
要使用 `cron` 运行上面列出的 `backup.sh` 脚本，请在终端提示符下输入以下内容：

```bash
sudo crontab -e
```

> **Note**: 注意：
>  Using sudo with the `crontab -e` command edits the *root* user’s `crontab`. This is necessary if you are backing up directories only the root user has access to.
> 将 sudo 与 `crontab -e` 命令一起使用可编辑 root 用户的 `crontab` .如果要备份只有 root 用户有权访问的目录，则这是必要的。

As an example, if we add the following entry to the `crontab` file:
例如，如果我们将以下条目添加到 `crontab` 文件中：

```bash
# m h dom mon dow   command
0 0 * * * bash /usr/local/bin/backup.sh
```

The `backup.sh` script would be run every day at 12:00 pm.
该 `backup.sh` 脚本将在每天中午 12：00 运行。

> **Note**: 注意：
>  The `backup.sh` script will need to be copied to the `/usr/local/bin/` directory in order for this entry to run properly. The script can  reside anywhere on the file system, simply change the script path  appropriately.
> 需要将 `backup.sh` 脚本复制到目录中 `/usr/local/bin/` ，才能使此条目正常运行。脚本可以驻留在文件系统上的任何位置，只需适当地更改脚本路径即可。

## Restoring from the archive 从存档恢复

Once an archive has been created, it is important to test the archive. The  archive can be tested by listing the files it contains, but the best  test is to **restore** a file from the archive.
创建存档后，测试存档非常重要。可以通过列出存档包含的文件来测试存档，但最好的测试是从存档中还原文件。

- To see a listing of the archive contents, run the following command from a terminal:
  若要查看存档内容的列表，请从终端运行以下命令：

  ```bash
  tar -tzvf /mnt/backup/host-Monday.tgz
  ```

- To restore a file from the archive back to a different directory, enter:
  要将文件从存档还原回其他目录，请输入：

  ```bash
  tar -xzvf /mnt/backup/host-Monday.tgz -C /tmp etc/hosts
  ```

  The `-C` option to `tar` redirects the extracted files to the specified directory. The above example will extract the `/etc/hosts` file to `/tmp/etc/hosts`. `tar` recreates the directory structure that it contains. Also, notice the leading “`/`” is left off the path of the file to restore.
  用于 `tar` 将提取的文件重定向到指定目录的 `-C` 选项。上面的示例会将 `/etc/hosts` 文件解压缩到 `/tmp/etc/hosts` 。 `tar` 重新创建它所包含的目录结构。另外，请注意，前导 “ `/` ” 被排除在要还原的文件的路径之外。

- To restore all files in the archive enter the following:
  要恢复存档中的所有文件，请输入以下命令：

  ```bash
  cd /
  sudo tar -xzvf /mnt/backup/host-Monday.tgz
  ```

  > **Note**: 注意：
  >  This will overwrite the files currently on the file system.
  > 这将覆盖文件系统上的当前文件。

## Further reading 延伸阅读

- For more information on shell scripting see the [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/)
  有关 shell 脚本的更多信息，请参阅高级 Bash 脚本指南
- The [CronHowto Wiki Page](https://help.ubuntu.com/community/CronHowto) contains details on advanced cron options.
  CronHowto Wiki 页面包含有关高级 cron 选项的详细信息。
- See the [GNU tar Manual](http://www.gnu.org/software/tar/manual/index.html) for more tar options.
  参见 GNU tar 手册了解更多 tar 选项。
- The Wikipedia [Backup Rotation Scheme](http://en.wikipedia.org/wiki/Backup_rotation_scheme) article contains information on other backup rotation schemes.
  维基百科备份轮换方案一文包含有关其他备份轮换方案的信息。
- The shell script uses tar to create the archive, but there many other command line utilities that can be used. For example:
  shell 脚本使用 tar 创建存档，但还有许多其他命令行实用程序可以使用。例如：
  - [cpio](http://www.gnu.org/software/cpio/): used to copy files to and from archives.
    CPIO：用于将文件复制到存档或从存档复制文件。
  - [dd](http://www.gnu.org/software/coreutils/): part of the coreutils package. A low level utility that can copy data from one format to another.
    dd：coreutils 包的一部分。一个低级实用程序，可以将数据从一种格式复制到另一种格式。
  - [rsnapshot](http://www.rsnapshot.org/): a file system snapshot utility used to create copies of an entire file system. Also check the [Tools - rsnapshot](https://ubuntu.com/server/docs/how-to-install-and-configure-rsnapshot) for some information.
    rsnapshot：用于创建整个文件系统的副本的文件系统快照实用程序。另请查看 工具 - rsnapshot 以获取一些信息。
  - [rsync](http://manpages.ubuntu.com/manpages/focal/man1/rsync.1.html): a flexible utility used to create incremental copies of files.
    rsync：用于创建文件增量副本的灵活实用程序。

------