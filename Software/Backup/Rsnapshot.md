# Rsnapshot

[TOC]

# How to install and configure rsnapshot 如何安装和配置 rsnapshot

[rsnapshot](https://rsnapshot.org/) is an rsync-based filesystem snapshot utility. It can take incremental  backups of local and remote filesystems for any number of machines.  rsnapshot makes extensive use of hard links, so disk space is only used  when absolutely necessary. It leverages the power of rsync to create  scheduled, incremental backups.
rsnapshot 是一个基于 rsync 的文件系统快照实用程序。它可以对任意数量的计算机进行本地和远程文件系统的增量备份。rsnapshot 大量使用硬链接，因此仅在绝对必要时才使用磁盘空间。它利用 rsync 的强大功能来创建定时增量备份。

## Install rsnapshot 安装 rsnapshot

To install `rsnapshot` open a terminal shell and run:
要安装 `rsnapshot` ，请打开终端外壳并运行：

```bash
sudo apt-get install rsnapshot
```

If you want to backup a remote filesystem, the rsnapshot server needs to  be able to access the target machine over SSH without password. For more information on how to enable this please see [OpenSSH documentation](https://ubuntu.com/server/docs/openssh-server). If the backup target is a local filesystem there is no need to set up OpenSSH.
如果要备份远程文件系统，rsnapshot 服务器需要能够在没有密码的情况下通过 SSH 访问目标计算机。有关如何启用此功能的更多信息，请参阅 OpenSSH 文档。如果备份目标是本地文件系统，则无需设置 OpenSSH。

## Configure rsnapshot 配置 rsnapshot

The `rsnapshot` configuration resides in `/etc/rsnapshot.conf`. Below you can find some of the options available there.
配置 `rsnapshot` 位于 `/etc/rsnapshot.conf` 中。您可以在下面找到一些可用的选项。

The root directory where all snapshots will be stored is found at:
存储所有快照的根目录位于：

```auto
snapshot_root       /var/cache/rsnapshot/
```

### Number of backups to keep 要保留的备份数

Since `rsnapshot` uses incremental backups, we can afford to keep older backups for a while before removing them. You set these up under the `BACKUP LEVELS / INTERVALS` section. You can tell `rsnapshot` to retain a specific number of backups of each kind of interval.
由于 `rsnapshot` 使用增量备份，因此我们可以在删除旧备份之前保留一段时间。您可以在该 `BACKUP LEVELS / INTERVALS` 部分下设置这些内容。您可以告诉 `rsnapshot` 保留每种间隔的特定数量的备份。

```auto
retain  daily   6
retain  weekly    7
retain  monthly   4
```

In this example we will keep 6 snapshots of our daily strategy, 7  snapshots of our weekly strategy, and 4 snapshots of our monthly  strategy. These data will guide the rotation made by `rsnapshot`.
在此示例中，我们将保留 6 个每日策略快照、7 个每周策略快照和 4 个月度策略快照。这些数据将指导 进行的 `rsnapshot` 旋转。

### Remote machine access 远程计算机访问

If you are accessing a remote machine over SSH and the port to bind is not the default (port `22`), you need to set the following variable with the port number:
如果要通过 SSH 访问远程计算机，并且要绑定的端口不是默认端口（端口 `22` ），则需要使用端口号设置以下变量：

```auto
ssh_args       -p 22222
```

### What to backup 备份内容

Now the most important part; you need to decide what you would like to backup.
现在是最重要的部分;您需要决定要备份的内容。

If you are backing up locally to the same machine, this is as easy as  specifying the directories that you want to save and following it with `localhost/` which will be a sub-directory in the `snapshot_root` that you set up earlier.
如果要本地备份到同一台计算机，则只需指定要保存的目录，然后跟踪 `localhost/` 该目录，该目录将是您之前设置的 `snapshot_root` 子目录。

```auto
backup  /home/          localhost/
backup  /etc/           localhost/
backup  /usr/local/     localhost/
```

If you are backing up a remote machine you just need to tell `rsnapshot` where the server is and which directories you would like to back up.
如果要备份远程计算机，则只需告诉 `rsnapshot` 服务器的位置以及要备份的目录即可。

```auto
backup root@example.com:/home/ example.com/    +rsync_long_args=--bwlimit=16,exclude=core
backup root@example.com:/etc/  example.com/    exclude=mtab,exclude=core
```

As you can see, you can pass extra rsync parameters (the `+` appends the parameter to the default list – if you remove the `+` sign you override it) and also exclude directories.
如您所见，您可以传递额外的 rsync 参数（将参数 `+` 附加到默认列表 - 如果您删除符号 `+` ，则覆盖它）并且还可以排除目录。

You can check the comments in `/etc/rsnapshot.conf` and the [rsnapshot man page](http://manpages.ubuntu.com/manpages/focal/man1/rsnapshot.1.html) for more options.
您可以查看 rsnapshot 手册页中的 `/etc/rsnapshot.conf` 注释以获取更多选项。

## Test configuration 测试配置

After modifying the configuration file, it is good practice to check if the syntax is OK:
修改配置文件后，最好检查语法是否正常：

```bash
sudo rsnapshot configtest
```

You can also test your backup levels with the following command:
您还可以使用以下命令测试备份级别：

```bash
sudo rsnapshot -t daily
```

If you are happy with the output and want to see it in action you can run:
如果您对输出感到满意并希望看到它的实际效果，您可以运行：

```bash
sudo rsnapshot daily
```

## Scheduling backups 计划备份

With `rsnapshot` working correctly with the current configuration, the only thing left  to do is schedule it to run at certain intervals. We will use cron to  make this happen since `rsnapshot` includes a default cron file in `/etc/cron.d/rsnapshot`. If you open this file there are some entries commented out as reference.
正确使用当前配置后 `rsnapshot` ，唯一要做的就是安排它以特定的时间间隔运行。我们将使用 cron 来实现这一点，因为 `rsnapshot` 中 `/etc/cron.d/rsnapshot` 包含一个默认的 cron 文件。如果打开此文件，则会注释掉一些条目作为参考。

```nohighlight
0 4  * * *           root    /usr/bin/rsnapshot daily
0 3  * * 1           root    /usr/bin/rsnapshot weekly
0 2  1 * *           root    /usr/bin/rsnapshot monthly
```

The settings above added to `/etc/cron.d/rsnapshot` run:
上面添加的设置可以 `/etc/cron.d/rsnapshot` 运行：

- The **daily snapshot** everyday at 4:00 am
  每天凌晨 4：00 的每日快照
- The **weekly snapshot** every Monday at 3:00 am
  每周一凌晨 3：00 的每周快照
- The **monthly snapshot** on the first of every month at 2:00 am
  每月第一天凌晨 2：00 的月度快照

For more information on how to schedule a backup using cron please take a look at the `Executing with cron` section in [Backups - Shell Scripts](https://ubuntu.com/server/docs/how-to-back-up-using-shell-scripts).
有关如何使用 cron 计划备份的详细信息，请查看备份 - Shell 脚本中 `Executing with cron` 的部分。

### Further reading 延伸阅读

- [rsnapshot offical web page
  rsnapshot 官方网页](https://rsnapshot.org/)
- [rsnapshot man page rsnapshot 手册页](http://manpages.ubuntu.com/manpages/focal/man1/rsnapshot.1.html)
- [rsync man page rsync 手册页](http://manpages.ubuntu.com/manpages/focal/man1/rsync.1.html)

*rsnapshot* is a very powerful backup utility that can be  installed on any Linux-based machine. It can either back up a machine  locally, or you can back up multiple machines, say servers for instance, from a single machine. 

rsnapshot uses *rsync* and is written entirely in perl with no library dependencies, so there are no weird requirements to installing  it. In the case of Rocky Linux, you should be able to install rsnapshot  simply by installing the EPEL software repository. 

This documentation covers the installation of rsnapshot on Rocky Linux only.

# Installing Rsnapshot[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#installing-rsnapshot)

All commands shown here are from the command-line on your server or workstation unless otherwise noted.

## Installing The EPEL repository[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#installing-the-epel-repository)

We need the EPEL software repo from Fedora to install rsnapshot. To  install the repository, just use this command, if you haven't already:

```
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```

The repository should now be active.

## Install the Rsnapshot Package[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#install-the-rsnapshot-package)

Next, install rsnapshot itself:

```
sudo dnf install rsnapshot
```

If there are any missing dependencies, those will show up and you simply need to answer the prompt to continue. For example:

```
dnf install rsnapshot
Last metadata expiration check: 0:00:16 ago on Mon Feb 22 00:12:45 2021.
Dependencies resolved.
========================================================================================================================================
 Package                           Architecture                 Version                              Repository                    Size
========================================================================================================================================
Installing:
 rsnapshot                         noarch                       1.4.3-1.el8                          epel                         121 k
Installing dependencies:
 perl-Lchown                       x86_64                       1.01-14.el8                          epel                          18 k
 rsync                             x86_64                       3.1.3-9.el8                          baseos                       404 k

Transaction Summary
========================================================================================================================================
Install  3 Packages

Total download size: 543 k
Installed size: 1.2 M
Is this ok [y/N]: y
```

## Mounting A Drive or Filesystem For Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#mounting-a-drive-or-filesystem-for-backup)

In this step, we show how to mount a hard drive, such as an external  USB hard drive, that will be used to back up your system. This  particular step is only necessary if you are backing up a single machine or server, as seen in our first example below.

1. Plug in the USB drive. 
2. Type `dmesg | grep sd` which should show you the drive should show you the drive you want to use. In this case, it'll be called *sda1*.
    Example: `EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem`.
3. Unfortunately (or fortunately depending on your opinion) most modern Linux desktop operating systems automount the drive if they can. This  means that, depending on various factors, rsnapshot might lose track of  the hard drive. We want the drive to "mount" or make its files available in the same place every time.
    To do that, take the drive information revealed in the dmesg command above and type `mount | grep sda1`, which should show something like this: `/dev/sda1 on /media/username/8ea89e5e-9291-45c1-961d-99c346a2628a`
4. Type `sudo umount /dev/sda1` to unmount your external hard drive.
5. Next, create a new mount point for the backup: `sudo mkdir /mnt/backup`
6. Now mount the drive to your backup folder location: `sudo mount /dev/sda1 /mnt/backup`
7. Now type `mount | grep sda1` again, and you should see something like this: `/dev/sda1 on /mnt/backup type ext2 (rw,relatime)`
8. Next create a directory that must exist for the backup to continue  on the mounted drive. We are using a folder called "storage" for this  example: `sudo mkdir /mnt/backup/storage`

Note that for a single machine, you will have to either repeat the  umount and mount steps each time the drive is plugged in again, or each  time the system reboots, or automate these commands with a script.

We recommend automation. Automation is the sysadmin way.

# Configuring rsnapshot[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#configuring-rsnapshot)

This is the most important step. It's easy to make a mistake when  making changes to the configuration file. The rsnapshot configuration  requires tabs for any separation between elements, and a warning to that effect is at the very top of the configuration file.

A space character will cause the entire configuration—and your  backup—to fail. For instance, near the top of the configuration file is a section for the `# SNAPSHOT ROOT DIRECTORY #`. If you were adding this in from scratch, you would type `snapshot_root` then TAB and then type `/whatever_the_path_to_the_snapshot_root_will_be/` 

The best thing is that the default configuration that comes with  rsnapshot only needs minor changes to make it work for a backup of a  local machine. It's always a good idea, though, to make a backup copy of the configuration file before you start editing:

```
cp /etc/rsnapshot.conf /etc/rsnapshot.conf.bak
```

## Basic Machine or Single Server Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#basic-machine-or-single-server-backup)

In this case, rsnapshot is going to be run locally to back up a  particular machine. In this example, we'll break down the configuration  file, and show you exactly what you need to change.

You will need to use vi (or edit with your favorite editor) to open the */etc/rsnapshot.conf* file.

The first thing to change is the *snapshot_root* setting which by default has this value:

```
snapshot_root   /.snapshots/
```

We need to change this to our mount point that we created above plus the addition of "storage".

```
snapshot_root   /mnt/backup/storage/
```

We also want to tell the backup NOT to run if the drive is not  mounted. To do this, remove the "#" sign (also called a remark, pound  sign, number sign, hash symbol, etc.) next to no_create_root so that it  looks like this:

```
no_create_root 1
```

Next go down to the section titled `# EXTERNAL PROGRAM DEPENDENCIES #` and remove the comment (again, the "#" sign) from this line:

```
#cmd_cp         /usr/bin/cp
```

So that it now reads:

```
cmd_cp         /usr/bin/cp
```

While we do not need cmd_ssh for this particular configuration, we  will need it for our other option below and it doesn't hurt to have it  enabled. So find the line that says:

```
#cmd_ssh        /usr/bin/ssh
```

And remove the "#" sign so that it looks like this:

```
cmd_ssh        /usr/bin/ssh
```

Next we need to skip down to the section titled `#     BACKUP LEVELS / INTERVALS         #`

This has been changed from earlier versions of rsnapshot from `hourly, daily, monthly, yearly` to `alpha, beta, gamma, delta`. Which is a bit confusing. What you need to do is add a remark to any  interval that you won't be using. In the configuration, delta is already remarked out. 

For this example, we aren't going to be running any other increments  other than a nightly backup, so just add a remark to alpha and gamma so  that the configuration looks like this when you are done:

```
#retain  alpha   6
retain  beta    7
#retain  gamma   4
#retain delta   3
```

Now skip down to the logfile line, which by default should read:

```
#logfile        /var/log/rsnapshot
```

And remove the remark so that it is enabled:

```
logfile        /var/log/rsnapshot
```

Finally, skip down to the `### BACKUP POINTS / SCRIPTS ###` section and add any directories that you want to add in the `# LOCALHOST` section, remember to use TAB rather than SPACE between elements!

For now write your changes (`SHIFT :wq!` for vi) and exit the configuration file.

### Checking The Configuration[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#checking-the-configuration)

We want to make sure that we didn't add spaces or any other glaring  errors to our configuration file while we were editing it. To do this,  we run rsnapshot against our configuration with the configtest option: 

`rsnapshot configtest` will show `Syntax OK` if there are no errors in the configuration.

You should get into the habit of running configtest against a  particular configuration. The reason for that will be more evident when  we get into the **Multiple Machine or Multiple Server Backups** section. 

To run configtest against a particular configuration file, run it with the -c option to specify the configuration:

```
rsnapshot -c /etc/rsnapshot.conf configtest
```

### Running The Backup The First Time[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#running-the-backup-the-first-time)

Everything has checked out, so it's time to go ahead and run the  backup for the first time. You can run this in test mode first if you  like, so that you can see what the backup script is going to do. 

Again, to do this you don't necessarily have to specify the  configuration in this case, but you should get into the habit of doing  so:

```
rsnapshot -c /etc/rsnapshot.conf -t beta
```

Which should return something like this, showing you what will happen when the backup is actually run:

```
echo 1441 > /var/run/rsnapshot.pid 
mkdir -m 0755 -p /mnt/backup/storage/beta.0/ 
/usr/bin/rsync -a --delete --numeric-ids --relative --delete-excluded \
    /home/ /mnt/backup/storage/beta.0/localhost/ 
mkdir -m 0755 -p /mnt/backup/storage/beta.0/ 
/usr/bin/rsync -a --delete --numeric-ids --relative --delete-excluded /etc/ \
    /mnt/backup/storage/beta.0/localhost/ 
mkdir -m 0755 -p /mnt/backup/storage/beta.0/ 
/usr/bin/rsync -a --delete --numeric-ids --relative --delete-excluded \
    /usr/local/ /mnt/backup/storage/beta.0/localhost/ 
touch /mnt/backup/storage/beta.0/
```

Once you are satisfied with the test, go ahead and run it manually the first time without the test:

```
rsnapshot -c /etc/rsnapshot.conf beta
```

When the backup finishes, navigate to /mnt/backup and take a look at  the directory structure that was created there. There will be a `storage/beta.0/localhost` directory, followed by the directories that you specified to backup. 

### Further Explanation[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#further-explanation)

Each time the backup is run, it will create a new beta increment,  0-6, or 7 days worth of backups. The newest backup will always be beta.0 where as yesterday's backup will always be beta.1. 

The size of each of these backups will appear to take up the same  amount (or more) of disk space, but this is because of rsnapshot's use  of hard links. To restore files from yesterday's backup, you would  simply copy them back from beta.1's directory structure. 

Each backup is only an incremental backup from the previous run, BUT, because of the use of hard links, each backup directory, contains the  file, or the hard-link to the file in whichever directory it actually  was backed up in. 

So to restore files, you don't have to pick and choose which  directory or increment to restore them from, just what time stamp the  backup should have. It's a great system and uses far less disk space  than many other backup solutions.

### Setting The Backup To Run Automatically[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#setting-the-backup-to-run-automatically)

Once everything has been tested and we know that things will work  without issue, the next step is to set up the crontab for the root user, so that all of this can be done automatically every day:

```
sudo crontab -e
```

If you haven't run this before, choose vim.basic as your editor or your own editor preference when the `Select an editor` line comes up. 

We are going to set our backup to automatically run at 11 PM, so we will add this to the crontab: 

```
## Running the backup at 11 PM
00 23 *  *  *  /usr/bin/rsnapshot -c /etc/rsnapshot.conf beta`
```

## Multiple Machine or Multiple Server Backups[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#multiple-machine-or-multiple-server-backups)

Doing backups of multiple machines from a machine with a RAID array  or large storage capacity, either on premises or from across the  Internet works very well. 

If running these backups from across the Internet, you need to make  sure that both locations have adequate bandwidth for the backups to  occur. You can use rsnapshot to synchronize an on-site server with an  off-site backup array or backup server to improve data redundancy. 

### Assumptions[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#assumptions)

We are assuming that you are running rsnapshot from a machine  remotely, on-premise. This exact configuration can be duplicated, as  indicated above, remotely off-premise as well.

In this case, you will want to install rsnapshot on the machine that is doing all of the backups. We are also assuming

- That the servers you will be backing up to, have a firewall rule that allows the remote machine to SSH into it
- That each server that you will be backing up has a recent version of rsync installed. For Rocky Linux servers, run `dnf install rsync` to update your system's version of rsync.
- That you've either connected to the machine as the root user, or that you have run `sudo -s` to switch to the root user.

### SSH Public / Private Keys[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#ssh-public-private-keys)

For the server that will be running the backups, we need to generate  an SSH key-pair for use during the backups. For our example, we will be  creating RSA keys. 

If you already have a set of keys generated, you can skip this step. You can find out by doing an `ls -al .ssh` and looking for an id_rsa and id_rsa.pub key pair. If none exists use  the following link to set up your keys and the servers that you want to  access:

[SSH Public Private Key Pairs](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/)

### Rsnapshot Configuration[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#rsnapshot-configuration)

The configuration file needs to be just like the one we created for the **Basic Machine or Single Server Backup** above, except that we want to change some of the options.

The snapshot root can be reverted back to the default like so:

```
snapshot_root   /.snapshots/
```

And this line:

```
no_create_root 1
```

... can be commented out again:

```
#no_create_root 1
```

The other difference here is that each machine will have its very own configuration. Once you get used to this, you'll simply copy one of  your existing configuration files over to a new name and then modify it  to fit any additional machines that you want to backup. 

For now, we want to modify the configuration file just like we did  above, and then save it. Then copy that file as a template for our first server:

```
cp /etc/rsnapshot.conf /etc/rsnapshot_web.conf
```

We want to modify the new configuration file and create the log and lockfile with the machine's name:

```
logfile /var/log/rsnapshot_web.log
lockfile        /var/run/rsnapshot_web.pid
```

Next, we want to modify rsnapshot_web.conf so that it includes the  directories we want to back up. The only thing that is different here is the target. 

Here's an example of the web.ourdomain.com configuration:

```
### BACKUP POINTS / SCRIPTS ###
backup  root@web.ourourdomain.com:/etc/     web.ourourdomain.com/
backup  root@web.ourourdomain.com:/var/www/     web.ourourdomain.com/
backup  root@web.ourdomain.com:/usr/local/     web.ourdomain.com/
backup  root@web.ourdomain.com:/home/     web.ourdomain.com/
backup  root@web.ourdomain.com:/root/     web.ourdomain.com/
```

### Checking The Configuration and Running The Initial Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#checking-the-configuration-and-running-the-initial-backup)

Just like before, we can now check the configuration to make sure it is syntactically correct:

```
rsnapshot -c /etc/rsnapshot_web.conf configtest
```

And just like before, we are looking for the `Syntax OK` message. If all is well, we can execute the backup manually:

```
/usr/bin/rsnapshot -c /etc/rsnapshot_web.conf beta
```

Assuming that everything works alright, we can then create the  configuration files for the mail server (rsnapshot_mail.conf) and portal server (rsnapshot_portal.conf), test them, and do a trial backup.

### Automating The Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#automating-the-backup)

Automating backups for the multiple machine/server version is  slightly different. We want to create a bash script to call the backups  in order. When one finishes the next will start. This script will look  something like this and be stored in /usr/local/sbin:

```
vi /usr/local/sbin/backup_all
```

With the content:



```
#!/bin/bash
# script to run rsnapshot backups in succession
/usr/bin/rsnapshot -c /etc/rsnapshot_web.conf beta
/usr/bin/rsnapshot -c /etc/rsnapshot_mail.conf beta
/usr/bin/rsnapshot -c /etc/rsnapshot_portal.conf beta
```

Then we make the script executable:



```
chmod +x /usr/local/sbin/backup_all
```

Then create the crontab for root to run the backup script:

```
chrontab -e
```

And add this line:

```
## Running the backup at 11 PM
00 23 *  *  *  /usr/local/sbin/backup_all
```

### Reporting The Backup Status[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#reporting-the-backup-status)

To make sure that everything is backing up according to plan, you  might want to send the backup log files to your email. If your are  running multiple machine backups using rsnapshot, each log file will  have its own name, which you can then send to your email for review by [Using postfix For Server Process Reporting](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/) procedure.

## Conclusions and Other Resources[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#conclusions-and-other-resources)

Getting the setup right with rsnapshot is a little daunting at first, but can save you loads of time backing up your machines or servers. 

rsnapshot is very powerful, very fast, and very economical on disk  space usage. You can find more information on Rsnapshot, by visiting [rsnapshot.org](https://rsnapshot.org/download.html)

## Introduction[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#introduction)

*rsnapshot* is a very powerful backup utility that can be  installed on any Linux-based machine. It can either back up a machine  locally, or you can back up multiple machines, say servers for instance, from a single machine.

*rsnapshot* uses `rsync` and is written entirely in perl with no library dependencies, so there are no weird requirements  for installation. In the case of Rocky Linux, you should generally be  able to install *rnapshot* by using the EPEL repository. After  the initial release of Rocky Linux 9.0, there was a period of time when  the EPEL did not contain the *rsnapshot* package. That has since  been rectified, but we have included a method of installing from source  just in case this should happen again.

This documentation covers the installation of *rsnapshot* on Rocky Linux only.

EPEL InstallSource Install

## Installing *rsnapshot*[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#installing-rsnapshot)

All commands shown here are called from the command-line on your server or workstation unless otherwise noted.

### Installing The EPEL repository[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#installing-the-epel-repository)

We need the EPEL software repository from Fedora to install *rsnapshot*. To install the repository, just use this command:

```
sudo dnf install epel-release
```

The repository should now be active.

### Install the *rsnapshot* Package[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#install-the-rsnapshot-package)

Next, install *rsnapshot* and some other needed tools, which are probably already installed:

```
sudo dnf install rsnapshot openssh-server rsync
```

If there are any missing dependencies, those will show up and you simply need to answer the prompt to continue. For example:

```
dnf install rsnapshot
Last metadata expiration check: 0:00:16 ago on Mon Feb 22 00:12:45 2021.
Dependencies resolved.
========================================================================================================================================
Package                           Architecture                 Version                              Repository                    Size
========================================================================================================================================
Installing:
rsnapshot                         noarch                       1.4.3-1.el8                          epel                         121 k
Installing dependencies:
perl-Lchown                       x86_64                       1.01-14.el8                          epel                          18 k
rsync                             x86_64                       3.1.3-9.el8                          baseos                       404 k

Transaction Summary
========================================================================================================================================
Install  3 Packages

Total download size: 543 k
Installed size: 1.2 M
Is this ok [y/N]: y
```

## Mounting A Drive or Filesystem For Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#mounting-a-drive-or-filesystem-for-backup)

In this step, we show how to mount a hard drive, such as an external  USB hard drive, that will be used to back up your system. This  particular step is only necessary if you are backing up a single machine or server, as seen in our first example below.

1. Plug in the USB drive.
2. Type `dmesg | grep sd` which should show you the drive you want to use. In this case, it'll be called *sda1*.
    Example: `EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem`.
3. Unfortunately (or fortunately depending on your opinion) most modern Linux desktop operating systems automount the drive if they can. This  means that, depending on various factors, *rsnapshot* might lose track of the hard drive. We want the drive to "mount" or make its files available in the same place every time.
    To do that, take the drive information revealed in the `dmesg` command above and type `mount | grep sda1`, which should show something like this: `/dev/sda1 on /media/username/8ea89e5e-9291-45c1-961d-99c346a2628a`
4. Type `sudo umount /dev/sda1` to unmount your external hard drive.
5. Next, create a new mount point for the backup: `sudo mkdir /mnt/backup`
6. Now mount the drive to your backup folder location: `sudo mount /dev/sda1 /mnt/backup`
7. Now type `mount | grep sda1` again, and you should see something like this: `/dev/sda1 on /mnt/backup type ext2 (rw,relatime)`
8. Next create a directory that must exist for the backup to continue  on the mounted drive. We are using a folder called "storage" for this  example: `sudo mkdir /mnt/backup/storage`

Note that for a single machine, you will have to either repeat the `umount` and `mount` steps each time the drive is plugged in again, or each time the system reboots, or automate these commands with a script.

We recommend automation. Automation is the sysadmin way.

## Configuring rsnapshot[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#configuring-rsnapshot)

This is the most important step. It's easy to make a mistake when making changes to the configuration file. The *rsnapshot* configuration requires tabs for any separation between elements, and a  warning to that effect is at the very top of the configuration file.

A space character will cause the entire configuration—and your  backup—to fail. For instance, near the top of the configuration file is a section for the `# SNAPSHOT ROOT DIRECTORY #`. If you were adding this in from scratch, you would type `snapshot_root` then TAB and then type `/whatever_the_path_to_the_snapshot_root_will_be/`

The best thing is that the default configuration that comes with *rsnapshot* only needs minor changes to make it work for a backup of a local  machine. It's always a good idea, though, to make a backup copy of the  configuration file before you start editing:

```
cp /etc/rsnapshot.conf /etc/rsnapshot.conf.bak
```

## Basic Machine or Single Server Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#basic-machine-or-single-server-backup)

In this case, *rsnapshot* is going to be run locally to back  up a particular machine. In this example, we'll break down the  configuration file, and show you exactly what you need to change.

You will need to use `vi` (or edit with your favorite editor) to open the */etc/rsnapshot.conf* file.

The first thing to change is the *snapshot_root* setting which by default has this value:

```
snapshot_root   /.snapshots/
```

We need to change this to our mount point that we created above plus the addition of "storage".

```
snapshot_root   /mnt/backup/storage/
```

We also want to tell the backup NOT to run if the drive is not  mounted. To do this, remove the "#" sign (also called a remark, pound  sign, number sign, hash symbol, etc.) next to `no_create_root` so that it looks like this:

```
no_create_root 1
```

Next go down to the section titled `# EXTERNAL PROGRAM DEPENDENCIES #` and remove the comment (again, the "#" sign) from this line:

```
#cmd_cp         /usr/bin/cp
```

So that it now reads:

```
cmd_cp         /usr/bin/cp
```

While we do not need `cmd_ssh` for this particular  configuration, we will need it for our other option below and it doesn't hurt to have it enabled. So find the line that says:

```
#cmd_ssh        /usr/bin/ssh
```

And remove the "#" sign so that it looks like this:

```
cmd_ssh        /usr/bin/ssh
```

Next we need to skip down to the section titled `#     BACKUP LEVELS / INTERVALS         #`

This has been changed from earlier versions of *rsnapshot* from `hourly, daily, monthly, yearly` to `alpha, beta, gamma, delta`. Which is a bit confusing. What you need to do is add a remark to any  interval that you won't be using. In the configuration, delta is already remarked out.

For this example, we aren't going to be running any other increments  other than a nightly backup, so just add a remark to alpha and gamma so  that the configuration looks like this when you are done:

```
#retain  alpha   6
retain  beta    7
#retain  gamma   4
#retain delta   3
```

Now skip down to the logfile line, which by default should read:

```
#logfile        /var/log/rsnapshot
```

And remove the remark so that it is enabled:

```
logfile        /var/log/rsnapshot
```

Finally, skip down to the `### BACKUP POINTS / SCRIPTS ###` section and add any directories that you want to add in the `# LOCALHOST` section, remember to use TAB rather than SPACE between elements!

For now write your changes (`SHIFT :wq!` for `vi`) and exit the configuration file.

### Checking The Configuration[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#checking-the-configuration)

We want to make sure that we didn't add spaces or any other glaring  errors to our configuration file while we were editing it. To do this,  we run *rsnapshot* against our configuration with the `configtest` option:

`rsnapshot configtest` will show `Syntax OK` if there are no errors in the configuration.

You should get into the habit of running `configtest` against a particular configuration. The reason for that will be more evident when we get into the **Multiple Machine or Multiple Server Backups** section.

To run `configtest` against a particular configuration file, run it with the -c option to specify the configuration:

```
rsnapshot -c /etc/rsnapshot.conf configtest
```

## Running The Backup The First Time[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#running-the-backup-the-first-time)

Everything has checked out, so it's time to go ahead and run the  backup for the first time. You can run this in test mode first if you  like, so that you can see what the backup script is going to do.

Again, to do this you don't necessarily have to specify the  configuration in this case, but you should get into the habit of doing  so:

```
rsnapshot -c /etc/rsnapshot.conf -t beta
```

Which should return something like this, showing you what will happen when the backup is actually run:

```
echo 1441 > /var/run/rsnapshot.pid
mkdir -m 0755 -p /mnt/backup/storage/beta.0/
/usr/bin/rsync -a --delete --numeric-ids --relative --delete-excluded \
    /home/ /mnt/backup/storage/beta.0/localhost/
mkdir -m 0755 -p /mnt/backup/storage/beta.0/
/usr/bin/rsync -a --delete --numeric-ids --relative --delete-excluded /etc/ \
    /mnt/backup/storage/beta.0/localhost/
mkdir -m 0755 -p /mnt/backup/storage/beta.0/
/usr/bin/rsync -a --delete --numeric-ids --relative --delete-excluded \
    /usr/local/ /mnt/backup/storage/beta.0/localhost/
touch /mnt/backup/storage/beta.0/
```

Once you are satisfied with the test, go ahead and run it manually the first time without the test:

```
rsnapshot -c /etc/rsnapshot.conf beta
```

When the backup finishes, navigate to /mnt/backup and take a look at  the directory structure that was created there. There will be a `storage/beta.0/localhost` directory, followed by the directories that you specified to backup.

### Further Explanation[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#further-explanation)

Each time the backup is run, it will create a new beta increment,  0-6, or 7 days worth of backups. The newest backup will always be beta.0 whereas yesterday's backup will always be beta.1.

The size of each of these backups will appear to take up the same amount (or more) of disk space, but this is because of *rsnapshot's* use of hard links. To restore files from yesterday's backup, you would simply copy them back from beta.1's directory structure.

Each backup is only an incremental backup from the previous run, BUT, because of the use of hard links, each backup directory, contains  either the file or the hard-link to the file in whichever directory it  was actually backed up in.

So to restore files, you don't have to pick and choose which  directory or increment to restore them from, just what time stamp the  backup should have that you are restoring. It's a great system and uses  far less disk space than many other backup solutions.

## Setting The Backup To Run Automatically[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#setting-the-backup-to-run-automatically)

Once everything has been tested and we know that things will work  without issue, the next step is to set up the crontab for the root user, so that all of this can be done automatically every day:

```
sudo crontab -e
```

If you haven't run this before, choose vim.basic as your editor or your own editor preference when the `Select an editor` line comes up.

We are going to set our backup to automatically run at 11 PM, so we will add this to the crontab:

```
## Running the backup at 11 PM
00 23 *  *  *  /usr/bin/rsnapshot -c /etc/rsnapshot.conf beta`
```

## Multiple Machine or Multiple Server Backups[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#multiple-machine-or-multiple-server-backups)

Doing backups of multiple machines from a machine with a RAID array  or large storage capacity, either on premises or from across the  Internet works very well.

If running these backups from across the Internet, you need to make  sure that both locations have adequate bandwidth for the backups to  occur. You can use *rsnapshot* to synchronize an on-site server with an off-site backup array or backup server to improve data redundancy.

## Assumptions[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#assumptions)

We are assuming that you are running *rsnapshot* from a  machine remotely, on-premise. This exact configuration can be  duplicated, as indicated above, remotely off-premise as well.

In this case, you will want to install *rsnapshot* on the machine that is doing all of the backups. We are also assuming:

- That the servers you will be backing up to, have a firewall rule that allows the remote machine to SSH into it
- That each server that you will be backing up has a recent version of `rsync` installed. For Rocky Linux servers, run `dnf install rsync` to update your system's version of `rsync`.
- That you've either connected to the machine as the root user, or that you have run `sudo -s` to switch to the root user.

## SSH Public / Private Keys[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#ssh-public-private-keys)

For the server that will be running the backups, we need to generate  an SSH key-pair for use during the backups. For our example, we will be  creating RSA keys.

If you already have a set of keys generated, you can skip this step. You can find out by doing an `ls -al .ssh` and looking for an `id_rsa` and `id_rsa.pub` key pair. If none exists, use the following link to set up keys for your machine and the server(s) that you want to access:

[SSH Public Private Key Pairs](https://docs.rockylinux.org/zh/guides/security/ssh_public_private_keys/)

## *rsnapshot* Configuration[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#rsnapshot-configuration)

The configuration file needs to be just like the one we created for the **Basic Machine or Single Server Backup** above, except that we want to change some of the options.

The snapshot root can be reverted back to the default like so:

```
snapshot_root   /.snapshots/
```

And this line:

```
no_create_root 1
```

... can be commented out again:

```
#no_create_root 1
```

The other difference here is that each machine will have its very own configuration. Once you get used to this, you'll simply copy one of  your existing configuration files over to a new name and then modify it  to fit any additional machines that you want to backup.

For now, we want to modify the configuration file just like we did  above, and then save it. Then copy that file as a template for our first server:

```
cp /etc/rsnapshot.conf /etc/rsnapshot_web.conf
```

We want to modify the new configuration file and create the log and lockfile with the machine's name:

```
logfile /var/log/rsnapshot_web.log
lockfile        /var/run/rsnapshot_web.pid
```

Next, we want to modify rsnapshot_web.conf so that it includes the  directories we want to back up. The only thing that is different here is the target.

Here's an example of the web.ourdomain.com configuration:

```
### BACKUP POINTS / SCRIPTS ###
backup  root@web.ourourdomain.com:/etc/     web.ourourdomain.com/
backup  root@web.ourourdomain.com:/var/www/     web.ourourdomain.com/
backup  root@web.ourdomain.com:/usr/local/     web.ourdomain.com/
backup  root@web.ourdomain.com:/home/     web.ourdomain.com/
backup  root@web.ourdomain.com:/root/     web.ourdomain.com/
```

### Checking The Configuration and Running The Initial Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#checking-the-configuration-and-running-the-initial-backup)

Just like before, we can now check the configuration to make sure it is syntactically correct:

```
rsnapshot -c /etc/rsnapshot_web.conf configtest
```

And just like before, we are looking for the `Syntax OK` message. If all is well, we can execute the backup manually:

```
/usr/bin/rsnapshot -c /etc/rsnapshot_web.conf beta
```

Assuming that everything works alright, we can then create the  configuration files for the mail server (rsnapshot_mail.conf) and portal server (rsnapshot_portal.conf), test them, and do a trial backup.

## Automating The Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#automating-the-backup)

Automating backups for the multiple machine/server version is  slightly different. We want to create a bash script to call the backups  in order. When one finishes the next will start. This script will look  something like this and be stored in /usr/local/sbin:

```
vi /usr/local/sbin/backup_all
```

With the content:



```
#!/bin/bash/
# script to run rsnapshot backups in succession
/usr/bin/rsnapshot -c /etc/rsnapshot_web.conf beta
/usr/bin/rsnapshot -c /etc/rsnapshot_mail.conf beta
/usr/bin/rsnapshot -c /etc/rsnapshot_portal.conf beta
```

Then we make the script executable:



```
chmod +x /usr/local/sbin/backup_all
```

Then create the crontab for root to run the backup script:

```
crontab -e
```

And add this line:

```
## Running the backup at 11 PM
00 23 *  *  *  /usr/local/sbin/backup_all
```

## Reporting The Backup Status[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#reporting-the-backup-status)

To make sure that everything is backing up according to plan, you  might want to send the backup log files to your email. If your are  running multiple machine backups using *rsnapshot*, each log file will have its own name, which you can then send to your email for review by [Using the postfix For Server Process Reporting](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/) procedure.

## Restoring a Backup[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#restoring-a-backup)

Restoring a backup, either a few files or a complete restore,  involves copying the files you want from the directory with the date  that you want to restore from back to your machine. Simple!

## Conclusions and Other Resources[¶](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/#conclusions-and-other-resources)

Getting the setup right with *rsnapshot* is a little daunting at first, but can save you loads of time backing up your machines or servers.

*rsnapshot* is very powerful, very fast, and very economical on disk space usage. You can find more information on *rsnapshot*, by visiting [rsnapshot.org](https://rsnapshot.org/download.html)