# 升级 Bareos

[TOC]

## 更新或升级 Bareos 软件之前

我们认为这两种操作通常都是安全的，它们可以不受限制地应用于所有安装。Bareos 项目尽可能避免破坏更改，因此通常现有配置将在不进行更改的情况下与较新的安装一起工作。特别是在更新 Bareos Director（以及相应的 Bareos Storage Daemon）时，建议在继续之前执行一些安全步骤：

- 阅读 Bareos 当前的发行说明，并注意可能影响安装的更改。请特别注意“中断更改”一段，因为它包含有关在升级安装时需要特别注意的更改的信息，因为这些更改可能需要调整配置。

- 将您的操作系统更新到发布者的最新安全级别和修补程序级别。

- 清空正在运行的作业队列。

- 运行 BackupCatalog 或等效的作为最后一个作业（保持最新的数据库转储和配置状态）。

- 停止所有 Bareos 守护进程。

- 如果之前没有做过：

  - 保存实际使用配置的副本。（通常是 `/etc/bareos/` 和 `/etc/bareos-webui/` 。
  - 将数据库内容转储为易于还原的格式。

- 清理工作目录 `/var/lib/bareos`

  - 删除所有旧的崩溃跟踪crash traces  `*.bactrace` 和 `*.traceback` 文件。

  - 删除所有剩余的调试 `*.trace` 文件。

    删除所有未发送的剩余 `*.mail` 。

    删除留下的所有 `*core*` 。

- Rotate log files 如果不使用 logrotate，则旋转日志文件：

  - `/var/log/bareos/bareos.log`
  - `/var/log/bareos/bareos-audit.log`

现在，可以安全地应用更新或升级。

## Updating the configuration files

When updating Bareos through the distribution packaging mechanism, the existing configuration kept as they are.

If you don’t want to modify the behavior, there is normally no need to modify the configuration.

However, in some rare cases, configuration changes are required. These cases are described in the [Release Notes](https://docs.bareos.org/Appendix/ReleaseNotes.html#releasenotes).

With Bareos version 16.2.4 the default configuration uses the [Subdirectory Configuration Scheme](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-subdirectoryconfigurationscheme). This scheme offers various improvements. However, if your are updating  from earlier versions, your existing single configuration files (`/etc/bareos/bareos-*.conf`) stay in place and are contentiously used by Bareos. The new default configuration resource files will also be installed (`/etc/bareos/bareos-*.d/*/*.conf`). However, they will only be used, when the legacy configuration file does not exist.

See [Updates from Bareos < 16.2.4](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-updatetoconfigurationsubdirectories) for details and how to migrate to [Subdirectory Configuration Scheme](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-subdirectoryconfigurationscheme).

## Updating the database scheme

Sometimes improvements in Bareos make it necessary to update the database scheme.

Warning

If the Bareos catalog database does not have the current schema, the Bareos Director refuses to start.

Detailed information can then be found in the log file `/var/log/bareos/bareos.log`.

Take a look into the [Release Notes](https://docs.bareos.org/Appendix/ReleaseNotes.html#releasenotes) to see which Bareos updates do require a database scheme update.

Warning

Especially the upgrade to Bareos >= 17.2.0 restructures the **File** database table. In larger installations this is very time consuming (up to several hours or days) and temporarily doubles the amount of  required database disk space.

### Debian based Linux Distributions

Since Bareos *Version >= 14.2.0* the Debian (and Ubuntu) based packages support the **dbconfig-common** mechanism to create and update the Bareos database. If this is properly configured, the database schema will be automatically adapted by the  Bareos packages.

Warning

When using the PostgreSQL backend and updating to Bareos < 14.2.3, it is necessary to manually grant database permissions,  normally by using the following command:

```
 su - postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

For details see [dbconfig-common (Debian)](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#section-dbconfig).

If you disabled the usage of **dbconfig-common**, follow the instructions for [Other Platforms](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-updatedatabaseotherdistributions).



### Other Platforms

This has to be done as database administrator. On most platforms  Bareos knows only about the credentials to access the Bareos database,  but not about the database administrator to modify the database schema.

The task of updating the database schema is done by the script **/usr/lib/bareos/scripts/update_bareos_tables**.

However, this script requires administration access to the database.  Depending on your distribution and your database, this requires  different preparations. More details can be found in chapter [Catalog Maintenance](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#catmaintenancechapter).

> Warning
>
> If you’re updating to Bareos <= 13.2.3 and have  configured the Bareos database during install using Bareos environment  variables (`db_name`, `db_user` or `db_password`, see [Catalog Maintenance](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#catmaintenancechapter)), make sure to have these variables defined in the same way when calling  the update and grant scripts. Newer versions of Bareos read these  variables from the Director configuration file configFileDirUnix.  However, make sure that the user running the database scripts has read  access to this file (or set the environment variables). The **postgres** user normally does not have the required permissions.

#### PostgreSQL

If your are using PostgreSQL and your PostgreSQL administrator is **postgres** (default), use following commands:

Update PostgreSQL database schema

```
su postgres -c /usr/lib/bareos/scripts/update_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

The **grant_bareos_privileges** command is required, if new databases tables are introduced. It does not hurt to run it multiple times.

After this, restart the Bareos Director and verify it starts without problems.

#### MySQL/MariaDB

Make sure, that **root** has direct access to the local MySQL server. Check if the command **mysql** without parameter connects to the database. If not, you may be required to adapt your local MySQL configuration file `~/.my.cnf`. It should look similar to this:

MySQL credentials file .my.cnf

```
[client]
host=localhost
user=root
password=<input>YourPasswordForAccessingMysqlAsRoot</input>
```

If you are able to connect via the **mysql** to the database, run the following script from the Unix prompt:

Update MySQL database schema

```
/usr/lib/bareos/scripts/update_bareos_tables
```

Currently on MySQL is it not necessary to run **grant_bareos_privileges**, because access to the database is already given using wildcards.

After this, restart the Bareos Director and verify it starts without problems.







### Debian based Linux Distributions

Since Bareos *Version >= 14.2.0* the Debian (and Ubuntu) based packages support the **dbconfig-common** mechanism to create and update the Bareos database. If this is properly configured, the database schema will be automatically adapted by the  Bareos packages.

Warning

When using the PostgreSQL backend and updating to Bareos < 14.2.3, it is necessary to manually grant database permissions,  normally by using the following command:

```
 su - postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

For details see [dbconfig-common (Debian)](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#section-dbconfig).

If you disabled the usage of **dbconfig-common**, follow the instructions for [Other Platforms](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-updatedatabaseotherdistributions).



### Other Platforms

This has to be done as database administrator. On most platforms  Bareos knows only about the credentials to access the Bareos database,  but not about the database administrator to modify the database schema.

The task of updating the database schema is done by the script **/usr/lib/bareos/scripts/update_bareos_tables**.

However, this script requires administration access to the database.  Depending on your distribution and your database, this requires  different preparations. More details can be found in chapter [Catalog Maintenance](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#catmaintenancechapter).

> Warning
>
> If you’re updating to Bareos <= 13.2.3 and have  configured the Bareos database during install using Bareos environment  variables (`db_name`, `db_user` or `db_password`, see [Catalog Maintenance](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#catmaintenancechapter)), make sure to have these variables defined in the same way when calling  the update and grant scripts. Newer versions of Bareos read these  variables from the Director configuration file configFileDirUnix.  However, make sure that the user running the database scripts has read  access to this file (or set the environment variables). The **postgres** user normally does not have the required permissions.

#### PostgreSQL

If your are using PostgreSQL and your PostgreSQL administrator is **postgres** (default), use following commands:

Update PostgreSQL database schema

```
su postgres -c /usr/lib/bareos/scripts/update_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

The **grant_bareos_privileges** command is required, if new databases tables are introduced. It does not hurt to run it multiple times.

After this, restart the Bareos Director and verify it starts without problems.

#### MySQL/MariaDB

Make sure, that **root** has direct access to the local MySQL server. Check if the command **mysql** without parameter connects to the database. If not, you may be required to adapt your local MySQL configuration file `~/.my.cnf`. It should look similar to this:

MySQL credentials file .my.cnf

```
[client]
host=localhost
user=root
password=<input>YourPasswordForAccessingMysqlAsRoot</input>
```

If you are able to connect via the **mysql** to the database, run the following script from the Unix prompt:

Update MySQL database schema

```
/usr/lib/bareos/scripts/update_bareos_tables
```

Currently on MySQL is it not necessary to run **grant_bareos_privileges**, because access to the database is already given using wildcards.

After this, restart the Bareos Director and verify it starts without problems.





Note

When you change the repository and refresh it, it is likely to have a new signing key. You will have to accept it.

new gpg key detection on EL 8 (dnf/yum)[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id1)

```
   Backup Archiving Recovery Open Sourced (EL_8)                    1.6 MB/s | 1.6 kB     00:00
   Importing GPG key 0xC9FED482:
   Userid     : "Bareos 21 Signing Key <signing@bareos.com>"
   Fingerprint: 91DA 1DC3 564A E20A 76C4 CA88 E019 57D6 C9FE D482
   From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-bareos-release-21
   Is this ok [y/N]: y
```

new gpg key detection on SUSE (zypper)[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id2)

```
   Forcing raw metadata refresh
   New repository or package signing key received:
   Repository:       bareos
   Key Fingerprint:  91DA 1DC3 564A E20A 76C4 CA88 E019 57D6 C9FE D482
   Key Name:         Bareos 21 Signing Key <signing@bareos.com>
   Key Algorithm:    RSA 4096
   Key Created:      Mon Dec 20 10:04:50 2021
   Key Expires:      (does not expire)
   Rpm Name:         gpg-pubkey-c9fed482-61c05542

      Note: Signing data enables the recipient to verify that no modifications occurred after the data
      were signed. Accepting data with no, wrong or unknown signature can lead to a corrupted system
      and in extreme cases even to a system compromise.

      Note: A GPG pubkey is clearly identified by its fingerprint. Do not rely on the key's name. If
      you are not sure whether the presented key is authentic, ask the repository provider or check
      their web site. Many providers maintain a web page showing the fingerprints of the GPG keys they
      are using.

   Do you want to reject the key, trust temporarily, or trust always? [r/t/a/?] (r): a
```



## Updating from community to subscription binaries[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#updating-from-community-to-subscription-binaries)

To update the installed community packages (https://download.bareos.org) to Bareos Subscription packages, you will have to point to the subscription repositories located at https://download.bareos.com/.

Once you received your download.bareos.com portal/repository credentials, you can refer to the following section [Decide about the Bareos release to use](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-addsoftwarerepository) for complete instructions how-to use the `add_bareos_repositories.sh` helper.

Choose the same operating system and Bareos major version you are already using.

Read the [Bareos current release notes](https://docs.bareos.org/Appendix/ReleaseNotes.html#bareos-current-releasenotes) to check all fixes that have been made.

Proceed to the next section, to install last minor bugfix release on your systems.



## Updating Bareos to the lastest minor or bugfix release[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#updating-bareos-to-the-lastest-minor-or-bugfix-release)

In most cases, a Bareos update is simply done by a package update of the distribution.

Note

Please before processing, apply steps in [Before updating or upgrading Bareos software](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-updateupgradepreamble)

In this section, we explain how to update your Bareos major version to the latest minor or bugfix release.

For upgrading to a new major version see [Update Bareos to a new major release](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-upgrademajor).

Note

You can install directly the latest Major,Minor,Bugfix release available. So updating from 21.0.0 directly to 21.1.5 is not a problem.

Example how to update from 21.0.0 to 21.1.5.



Shell example command to update Bareos on on EL 8[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id3)

```
dnf upgrade --repo=bareos --refresh
   Backup Archiving Recovery Open Sourced (EL_8)            .5 kB/s | 833  B     00:00
   Dependencies resolved.
   ===================================================================================
   Package                         Architecture     Version         Repository   Size
   ===================================================================================
   Upgrading:
   bareos                          x86_64           21.1.5-3.el8    bareos      7.4 k
   bareos-bconsole                 x86_64           21.1.5-3.el8    bareos       37 k
   bareos-client                   x86_64           21.1.5-3.el8    bareos      7.5 k
   bareos-common                   x86_64           21.1.5-3.el8    bareos      764 k
   bareos-database-common          x86_64           21.1.5-3.el8    bareos       87 k
   bareos-database-postgresql      x86_64           21.1.5-3.el8    bareos       42 k
   bareos-database-tools           x86_64           21.1.5-3.el8    bareos      107 k
   bareos-director                 x86_64           21.1.5-3.el8    bareos      425 k
   bareos-filedaemon               x86_64           21.1.5-3.el8    bareos      120 k
   bareos-storage                  x86_64           21.1.5-3.el8    bareos       97 k
   bareos-tools                    x86_64           21.1.5-3.el8    bareos       52 k

   Transaction Summary
   ===================================================================================
   Upgrade  11 Packages

   Total download size: 1.7 M
   Is this ok [y/N]: y
```



Shell example command to update Bareos on SLES / openSUSE[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id4)

```
zypper refresh --force bareos
zypper -v update --repo=bareos
   Verbosity: 2
   Initializing Target
   Checking whether to refresh metadata for bareos
   Retrieving: repomd.xml ..........................................[done (3.0 KiB/s)]
   Retrieving: media ......................................................[not found]
   Retrieving: repomd.xml.asc ..................................................[done]
   Retrieving: repomd.xml.key ..................................................[done]
   Retrieving: repomd.xml ......................................................[done]
   Repository:       bareos
   Key Fingerprint:  91DA 1DC3 564A E20A 76C4 CA88 E019 57D6 C9FE D482
   Key Name:         Bareos 21 Signing Key <signing@bareos.com>
   Key Algorithm:    RSA 4096
   Key Created:      Mon Dec 20 10:04:50 2021
   Key Expires:      (does not expire)
   Rpm Name:         gpg-pubkey-c9fed482-61c05542
   Retrieving: 7c2078b9b802f0f5c4edb818e870be0084ae132b4a5f21111617582fd927a65f-primary.xml.gz ...[done]
   Retrieving repository 'bareos' metadata .....................................[done]
   Building repository 'bareos' cache ..........................................[done]
   Loading repository data...
   Reading installed packages...
   Force resolution: No

   The following 10 packages are going to be upgraded:
   bareos                      21.0.0-4 -> 21.1.5-3
   bareos-bconsole             21.0.0-4 -> 21.1.5-3
   bareos-client               21.0.0-4 -> 21.1.5-3
   bareos-common               21.0.0-4 -> 21.1.5-3
   bareos-database-common      21.0.0-4 -> 21.1.5-3
   bareos-database-postgresql  21.0.0-4 -> 21.1.5-3
   bareos-database-tools       21.0.0-4 -> 21.1.5-3
   bareos-director             21.0.0-4 -> 21.1.5-3
   bareos-filedaemon           21.0.0-4 -> 21.1.5-3
   bareos-storage              21.0.0-4 -> 21.1.5-3

   10 packages to upgrade.
   Overall download size: 1.5 MiB.
   Already cached: 0 B.
   After the operation, additional 59.6 KiB will be used.
   Continue? [y/n/v/...? shows all options] (y): y
```



Shell example command to update Bareos on Debian[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id5)

```
apt update
   Hit:1 http://deb.debian.org/debian bullseye InRelease
   Hit:2 http://deb.debian.org/debian-security bullseye-security InRelease
   Hit:3 http://deb.debian.org/debian bullseye-updates InRelease
   Get:4 https://download.bareos.com/bareos/release/21/Debian_11  InRelease [1861 B]
   Get:5 https://download.bareos.com/bareos/release/21/Debian_11  Sources [5660 B]
   Get:6 https://download.bareos.com/bareos/release/21/Debian_11  Packages [36.0 kB]
   Fetched 43.5 kB in 1s (42.3 kB/s)
   Reading package lists... Done
   Building dependency tree... Done
   Reading state information... Done
   15 packages can be upgraded. Run 'apt list --upgradable' to see them.
apt upgrade
   Reading package lists... Done
   Building dependency tree... Done
   Reading state information... Done
   Calculating upgrade... Done
   The following packages will be upgraded:
   bareos bareos-bconsole bareos-client bareos-common bareos-database-common
   bareos-database-postgresql bareos-database-tools bareos-director bareos-filedaemon
   bareos-storage bareos-tools libgssapi-krb5-2 libk5crypto3 libkrb5-3
   libkrb5support0
   15 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
   Need to get 2557 kB of archives.
   After this operation, 114 kB of additional disk space will be used.
   Do you want to continue? [Y/n] Y
```



Shell example command to update Bareos on FreeBSD[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id6)

```
pkg update --repository Bareos
pkg upgrade --repository Bareos
   Updating Bareos repository catalogue...
   Bareos repository is up to date.
   All repositories are up to date.
   Checking for upgrades (8 candidates): 100%
   Processing candidates (8 candidates): 100%
   The following 8 package(s) will be affected (of 0 checked):
   Installed packages to be UPGRADED:
         bareos.com-bconsole: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-common: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-database-common: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-database-postgresql: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-database-tools: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-director: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-filedaemon: 21.0.0 -> 21.1.5 [Bareos]
         bareos.com-storage: 21.0.0 -> 21.1.5 [Bareos]
   Number of packages to be upgraded: 8
   1 MiB to be downloaded.
   Proceed with this action? [y/N]: y
```



### Post update checks[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#post-update-checks)

After the update, it is recommended to check if any new  warnings are raised when starting the daemon, mostly deprecated  configuration directives. Bareos will mark configuration directives at least for one major release as deprecated, before removing them.

To do so you can use the -t flag:

Shell example to check the Bareos configuration[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id7)

```
su - bareos -s /bin/sh -c "bareos-dir -t"
su - bareos -s /bin/sh -c "bareos-sd -t"
bareos-fd -t
There are configuration warnings:
   * using deprecated keyword PidDirectory on line 19 of file /etc/bareos/bareos-fd.d/client/myself.conf
```

The same warnings are also shown on a regular start of the daemons.

Depending of the operating system and its configuration, you will have to restart the daemons. Use your operating system command to do so.

Shell command to restart all bareos daemon with systemd on Linux[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id8)

```
systemctl restart bareos-director bareos-storage bareos-filedaemon
systemctl status bareos-director bareos-storage bareos-filedaemon
```

Shell command to restart all bareos daemon with service on FreeBSD[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id9)

```
service bareos-dir restart
service bareos-fd restart
service bareos-sd restart
```



## Upgrading Bareos to a new major release[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#upgrading-bareos-to-a-new-major-release)

In most cases, a Bareos major upgrade can be achieve by:

- Add new major repository (subscription only)
- Package upgrade of the distribution.
- Database schema upgrade with helper scripts (if schema was changed).
- Configuration review to cleanup deprecated or removed parameters.
- Review of home made scripts and manage their adaptation in case of changes.

It is generally sufficient to upgrade directly to the latest release, without having to install any intermediate releases. However, it is required to read the release notes of all intermediate releases.

One exception is when using a MySQL Bareos catalog, which have been removed with Bareos *Version >= 21.0.0*. Therefore you first have to upgrade to Bareos 20 and migrate the MySQL into a PostgreSQL Bareos Catalog, see [Migrate a Bareos Catalog from MySQL to PostgreSQL](https://docs.bareos.org/Appendix/Howtos.html#section-migrationmysqltopostgresql).

### Prepare the upgrade[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#prepare-the-upgrade)

If you not have already done those steps, please refer to instructions in [Before updating or upgrading Bareos software](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-updateupgradepreamble).

Warning

If you use any third party plugins, you should check and test their functionalities with the new major version beforehand.



### Upgrade the Bareos download repositories[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#upgrade-the-bareos-download-repositories)

This does only apply for subscription repositories (https://download.bareos.com/bareos/release/). The community repository (https://download.bareos.org/current) will always contain the latest build of the most recent stable branch.

- First remove the existing Bareos repository definitions, by  either removing the definition file(s) or by using your package manager.
- Point your browser to the new Bareos major version for your operating system on the download server.
- Open or save the helper script `add_bareos_repositories.sh`.
  - You can refer to the following section [Decide about the Bareos release to use](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareos.html#section-addsoftwarerepository) for complete instructions how to use the `add_bareos_repositories.sh` helper.
- Transfer the file to your Bareos server, and execute it as **root**. This will create (or depending on your OS update) the Bareos repository information.

Shell command to upgrade the Bareos repository[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id10)

```
sh add_bareos_repositories.sh
```

You  should be able now to proceed the appropriate commands to refresh the  packages list and upgrade the package to the newer version.

Note

You can refer to section [Updating Bareos to the lastest minor or bugfix release](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-updateminorbugfix) for commands example.



### Updating the configuration files[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#updating-the-configuration-files)

When updating Bareos through the distribution packaging mechanism, the existing configuration files are kept as they are.

However, configuration files installed by Bareos packages that have been manually removed by the user will get reinstalled by the package, see [Resource file conventions](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-configurationresourcefileconventions).

If you don’t want to modify the behavior, there is normally no need to modify the configuration.

However, in some rare cases, configuration changes are required. These cases are described in the [Release Notes](https://docs.bareos.org/Appendix/ReleaseNotes.html#releasenotes).

With Bareos version >= 16.2.4 the default configuration uses the [Subdirectory Configuration Scheme](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-subdirectoryconfigurationscheme). This scheme offers various improvements. However, if your are updating  from earlier versions, your existing single configuration files (`/etc/bareos/bareos-*.conf`) stay in place and are contentiously used by Bareos. The new default configuration resource files will also be installed (`/etc/bareos/bareos-*.d/*/*.conf`). However, they will only be used, when the legacy configuration file does not exist.

See [Updates from Bareos < 16.2.4](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-updatetoconfigurationsubdirectories) for details and how to migrate to [Subdirectory Configuration Scheme](https://docs.bareos.org/Configuration/CustomizingTheConfiguration.html#section-subdirectoryconfigurationscheme).



### Updating the database scheme[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#updating-the-database-scheme)

Sometimes improvements in Bareos make it necessary to update the database scheme.

Warning

If the Bareos catalog database does not have the current schema, the Bareos Director refuses to start.

Shell example of bareos-dir failing to start due to lack of database schema update[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id11)

```
su - bareos -s /bin/sh -c "bareos-dir -t"
bareos-dir: dird/check_catalog.cc:64-0 Could not open Catalog "MyCatalog", database "bareos".
bareos-dir: dird/check_catalog.cc:71-0 Version error for database "bareos". Wanted 2210, got 2192
bareos-dir ERROR TERMINATION
Please correct the configuration in /etc/bareos/bareos-dir.d/*/*.conf
```

Detailed information can then be found in the log file `/var/log/bareos/bareos.log`.

Take a look into the [Release Notes](https://docs.bareos.org/Appendix/ReleaseNotes.html#releasenotes) to see which Bareos updates do require a database scheme update.

Warning

Especially the upgrade to Bareos >= 17.2.0 restructures the **File** database table. In larger installations this is very time consuming (up to several hours or days) and temporarily doubles the amount of required database disk space.



#### Debian based Linux Distributions[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#debian-based-linux-distributions)

Since Bareos *Version >= 14.2.0* the Debian (and Ubuntu) based packages support the **dbconfig-common** mechanism to create and update the Bareos database. If this is properly configured, the database schema will be automatically adapted by the  Bareos packages.

For details see [dbconfig-common (Debian)](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#section-dbconfig).

If you disabled the usage of **dbconfig-common**, follow the instructions for [Other Platforms](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#section-updatedatabaseotherplatforms).



#### Other Platforms[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#other-platforms)

This has to be done as database administrator. On most platforms Bareos knows only about the credentials to access the  Bareos database, but not about the database administrator credentials to modify the database schema.

The task of updating the database schema is done by the scripts **/usr/lib/bareos/scripts/update_bareos_tables** and **/usr/lib/bareos/scripts/grant_bareos_privileges**.

However, this script requires administration access to the database.  Depending on your distribution, this requires different preparations.

More details can be found in chapter [Catalog Maintenance](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#catmaintenancechapter).

Update PostgreSQL database schema on most Linux distribution[](https://docs.bareos.org/IntroductionAndTutorial/UpdatingBareos.html#id12)

```
su postgres -c /usr/lib/bareos/scripts/update_bareos_tables
su postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges
```

The **grant_bareos_privileges** command is required, if new databases tables are introduced. It does not hurt to run it multiple times.

After this, restart the Bareos Director and verify it starts without problems.