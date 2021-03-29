# Bareos WebUI

[TOC]

## System Requirements

- A working Bareos environment
- Bareos Director version and Bareos WebUI version must match
- The Bareos WebUI can be installed on any host. It does not have to be installed on the same as the Bareos Director.
- The default installation uses an Apache webserver with mod-rewrite, mod-php and mod-setenv.
- PHP 5.3.23 or newer, PHP 7 recommended
- On SUSE Linux Enterprise 12 you need the additional SUSE Linux Enterprise Module for Web Scripting 12.

## 安装

```bash
# RHEL, CentOS and Fedora
yum install -y bareos-webui
dnf install bareos-webui

# SUSE Linux Enterprise Server (SLES), openSUSE
zypper install bareos-webui

#Debian, Ubuntu
apt-get install bareos-webui

setsebool -P httpd_can_network_connect on
systemctl start httpd
systemctl enable httpd
```

## Configuration

### 配置(控制台密码)

Use **bconsole** to create a user with name **admin** and password **secret** and permissions defined in `webui-admin (Dir->Profile)`:

```bash
*reload
*configure add console name=admin password=secret profile=webui-admin tlsenable=false
```

**手动配置：**

```bash
cp /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf
 
systemctl restart bareos-dir
```

Login to`http://HOSTNAME/bareos-webui` with username and password as created.

#### Create a restricted consoles

There is not need, that Bareos WebUI itself provide a user management. Instead it uses so named `Console (Dir)` defined in the Bareos Director. You can have multiple consoles with  different names and passwords, sort of like multiple users, each with  different privileges.

At least one `Console (Dir)` is required to use the Bareos WebUI.

To allow a user with name **admin** and password **secret** to access the Bareos Director with permissions defined in the `webui-admin (Dir->Profile)` (see [Configuration of profile resources](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosWebui.html#section-webui-profile)), either

- create a file `/etc/bareos/bareos-dir.d/console/admin.conf` with following content:

  bareos-dir.d/console/admin.conf

  ```bash
  Console {
    Name = "admin"
    Password = "secret"
    Profile = "webui-admin"
    TlsEnable = false
  }
  ```

  To enable this, reload or restart your Bareos Director.

- or use the **bconsole**:

  ```bash
  *configure add console name=admin password=secret profile=webui-admin tlsenable=false
  ```

  If the profile could not be found, reload or restart your Bareos Director.

  TLS-PSK is not available between the Bareos WebUI and the Bareos Director. To enable TLS with certificates, see [Bareos Webui](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#transportencryptionwebuibareosdirchapter).

For details, please read [Console Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceconsole).



#### Configuration of profile resources

The package **bareos-webui** comes with a predefined profile for Bareos WebUI: `webui-admin (Dir->Profile)`.

If your Bareos WebUI is installed on another system than the Bareos  Director, you have to copy the profile to the Bareos Director.

This is the default profile, giving access to all Bareos resources and allowing all commands used by the Bareos WebUI:

bareos-dir.d/profile/webui-admin.conf

```bash
Profile {
  Name = webui-admin
  CommandACL = !.bvfs_clear_cache, !.exit, !.sql, !configure, !create, !delete, !purge, !sqlquery, !umount, !unmount, *all*
  Job ACL = *all*
  Schedule ACL = *all*
  Catalog ACL = *all*
  Pool ACL = *all*
  Storage ACL = *all*
  Client ACL = *all*
  FileSet ACL = *all*
  Where ACL = *all*
  Plugin Options ACL = *all*
}
```

The `Profile (Dir)` itself does not give any access to the Bareos Director, but can be used by `Console (Dir)`, which do give access to the Bareos Director, see [Create a restricted consoles](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosWebui.html#section-webui-console).

For details, please read [Access Control Configuration](https://docs.bareos.org/IntroductionAndTutorial/BareosWebui.html#section-webui-access-control-configuration) and [Profile Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceprofile).



#### SELinux



To use Bareos Director on a system with SELinux enabled, permission must be given to HTTPD to make network connections:

```bash
setsebool -P httpd_can_network_connect on
```



#### Configure your Apache Webserver



The package **bareos-webui** provides a default configuration for Apache. Depending on your distribution, it is installed at `/etc/apache2/conf.d/bareos-webui.conf`, `/etc/httpd/conf.d/bareos-webui.conf` or `/etc/apache2/available-conf/bareos-webui.conf`.

The required Apache modules, **setenv**, **rewrite** and **php** are enabled via package postinstall script. However, after installing the **bareos-webui** package, you need to restart your Apache webserver manually.



#### Configure your /etc/bareos-webui/directors.ini



Configure your directors in `/etc/bareos-webui/directors.ini` to match your settings.

The configuration file `/etc/bareos-webui/directors.ini` should look similar to this:

/etc/bareos-webui/directors.ini

```bash
;
; Bareos WebUI Configuration File
;
; File: /etc/bareos-webui/directors.ini
;

;------------------------------------------------------------------------------
; Section localhost-dir
;------------------------------------------------------------------------------
[localhost-dir]

; Enable or disable section. Possible values are "yes" or "no", the default is "yes".
enabled = "yes"

; Fill in the IP-Address or FQDN of you director.
diraddress = "localhost"

; Default value is 9101
dirport = 9101

; Set catalog to explicit value if you have multiple catalogs
;catalog = "MyCatalog"

; TLS verify peer
; Possible values: true or false
tls_verify_peer = false

; Server can do TLS
; Possible values: true or false
server_can_do_tls = false

; Server requires TLS
; Possible values: true or false
server_requires_tls = false

; Client can do TLS
; Possible values: true or false
client_can_do_tls = false

; Client requires TLS
; Possible value: true or false
client_requires_tls = false

; Path to the certificate authority file
; E.g. ca_file = "/etc/bareos-webui/tls/BareosCA.crt"
;ca_file = ""

; Path to the cert file which needs to contain the client certificate and the key in PEM encoding
; E.g. ca_file = "/etc/bareos-webui/tls/restricted-named-console.pem"
;cert_file = ""

; Passphrase needed to unlock the above cert file if set
;cert_file_passphrase = ""

; Allowed common names
; E.g. allowed_cns = "host1.example.com"
;allowed_cns = ""

;------------------------------------------------------------------------------
; Section another-host-dir
;------------------------------------------------------------------------------
[another-host-dir]
enabled = "no"
diraddress = "192.168.120.1"
dirport = 9101
;catalog = "MyCatalog"
;tls_verify_peer = false
;server_can_do_tls = false
;server_requires_tls = false
;client_can_do_tls = false
;client_requires_tls = false
;ca_file = ""
;cert_file = ""
;cert_file_passphrase = ""
;allowed_cns = ""
```

You can add as many directors as you want, also the same host with a  different name and different catalog, if you have multiple catalogs.

#### Configure your /etc/bareos-webui/configuration.ini

Since *Version >= 16.2.2* you are able to configure some parameters of the Bareos WebUI to your needs.

/etc/bareos-webui/configuration.ini

```bash
;
; Bareos WebUI Configuration File
;
; File: /etc/bareos-webui/configuration.ini
;

;------------------------------------------------------------------------------
; SESSION SETTINGS
;------------------------------------------------------------------------------
;
[session]
; Default: 3600 seconds
timeout=3600

;------------------------------------------------------------------------------
; DASHBOARD SETTINGS
;------------------------------------------------------------------------------
[dashboard]
; Autorefresh Interval
; Default: 60000 milliseconds
autorefresh_interval=60000

;------------------------------------------------------------------------------
; TABLE SETTINGS
;------------------------------------------------------------------------------
[tables]
; Possible values for pagination
; Default: 10,25,50,100
pagination_values=10,25,50,100

; Default number of rows per page
; for possible values see pagination_values
; Default: 25
pagination_default_value=25

; State saving - restore table state on page reload.
; Default: false
save_previous_state=false

;------------------------------------------------------------------------------
; VARIOUS SETTINGS
;------------------------------------------------------------------------------
[autochanger]
; Pooltype for label to use as filter.
; Default: none
labelpooltype=scratch

[restore]
; Restore filetree refresh timeout after n milliseconds
; Default: 120000 milliseconds
filetree_refresh_timeout=120000
```



#### Configure updating the Bvfs cache frequently

The restore module in the Bareos WebUI makes use of the Bvfs API and for example the **.bvfs_update** command to generate or update the Bvfs cache for jobs that are not already in the cache.

In case of larger backup jobs with lots of files that are not already in the cache, this could lead to timeouts while trying to load the filetree in the Bareos WebUI. That is why we highly recommend to update the Bvfs cache frequently.

This can be accomplished by the Run Script directive of a Job Resource.

The following code snippet is an example how to run the cache update process in a RunScript after the catalog backup.

```bash
Job {
  Name = "BackupCatalog"
  Level = Full
  Fileset = "Catalog"
  Schedule = "WeeklyCycleAfterBackup"
  JobDefs = "DefaultJob"
  WriteBootstrap = "|/usr/sbin/bsmtp -h localhost -f "(Bareos) " -s "Bootstrap for Job %j" root@localhost"
  Priority = 100
  run before job = "/usr/lib/bareos/scripts/make_catalog_backup.pl MyCatalog"
  run after job = "/usr/lib/bareos/scripts/delete_catalog_backup"
  Run Script {
    Console = ".bvfs_update"
    RunsWhen = After
    RunsOnClient = No
  }
```

Note

We do not provide a list of Jobs specified in the *JobId* command argument so the cache is computed for all jobs not already in the cache.

As an alternative to the method above the Bvfs cache can be updated  after each job run by using the Run Script directive as well.

```bash
Job {
  Name = "backup-client-01"
  Client = "client-01.example.com"
  JobDefs = "DefaultJob"
  Run Script {
    Console = ".bvfs_update jobid=%i"
    RunsWhen = After
    RunsOnClient = No
  }
}
```

Note

We do provide a specific JobId in the *JobId* command argument in this example. Only the *JobId* given by the placeholder %i will be computed into the cache.

## Upgrade from 18.2.6 to 18.2.7

### Configuration changes

The configuration file `configuration.ini` of the Bareos WebUI shipped with Bareos 18.2.7 introduced a new configuration parameter called `filetree_refresh_timeout`. The default value is 120 seconds if not set explicitly.

The Bareos WebUI triggers a Bvfs cache update automatically if required to be able to display the requested filetree. The configuration parameter has been introduced because in case of larger backup jobs with lots of files which are not already present in the Bvfs cache you could run into timeouts while trying to load the filetree in the restore module of the Bareos WebUI.

If you have trouble with running into timeouts while loading the tree you can adjust the parameter `filetree_refresh_timeout` to your needs. Keep in mind to set the timeout in your Apache or Nginx configuration accordingly to the setting in your `configuration.ini`.

In general we highly recommend updating the Bvfs cache frequently. Please see [Configure updating the Bvfs cache frequently](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosWebui.html#section-updating-bvfs-cache-frequently) for further details on how to accomplish this.

## Upgrade from 15.2 to 16.2

### Console/Profile changes

The Bareos WebUI Director profile shipped with Bareos 15.2 (`webui (Dir->Profile)` in the file `/etc/bareos/bareos-dir.d/webui-profiles.conf`) is not sufficient to use the Bareos WebUI 16.2. This has several reasons:

1. The handling of **Acl`s is more strict in Bareos 16.2 than it  has been in Bareos 15.2. Substring matching is no longer enabled,  therefore you need to change :bcommand:**.bvfs_*` to **.bvfs_.\*** in your `Command ACL (Dir->Profile)` to have a proper regular expression. Otherwise the restore module won’t work any longer, especially the file browser.
2. The Bareos WebUI 16.2 uses following additional commands:
   - .help
   - .schedule
   - .pools
   - import
   - export
   - update
   - release
   - enable
   - disable

If you used an unmodified `/etc/bareos/bareos-dir.d/webui-profiles.conf` file, the easiest way is to overwrite it with the new profile file `/etc/bareos/bareos-dir.d/profile/webui-admin.conf`. The new `webui-admin (Dir->Profile)` allows all commands, except of the dangerous ones, see [Configuration of profile resources](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosWebui.html#section-webui-profile).

### directors.ini

Since *Version >= 16.2.0* it is possible to work with different catalogs. Therefore the catalog  parameter has been introduced. If you don’t set a catalog explicitly the default `MyCatalog (Dir->Catalog)` will be used. Please see [Configure your /etc/bareos-webui/directors.ini](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosWebui.html#section-webui-configuration-files) for more details.

### configuration.ini

Since 16.2 the Bareos WebUI introduced an additional configuration  file besides the directors.ini file named configuration.ini where you  are able to adjust some parameters of the webui to your needs. Please  see [Configure your /etc/bareos-webui/directors.ini](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosWebui.html#section-webui-configuration-files) for more details.

## Additional information

### NGINX



If you prefer to use Bareos WebUI on Nginx with php5-fpm instead of Apache, a basic working configuration could look like this:

bareos-webui on nginx

```
server {

        listen       9100;
        server_name  bareos;
        root         /var/www/bareos-webui/public;

        location / {
                index index.php;
                try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ .php$ {

                include snippets/fastcgi-php.conf;

                # php5-cgi alone:
                # pass the PHP
                # scripts to FastCGI server
                # listening on 127.0.0.1:9000
                #fastcgi_pass 127.0.0.1:9000;

                # php5-fpm:
                fastcgi_pass unix:/var/run/php5-fpm.sock;

                # APPLICATION_ENV:  set to 'development' or 'production'
                #fastcgi_param APPLICATION_ENV development;
                fastcgi_param APPLICATION_ENV production;

        }

}
```

This will make the Bareos WebUI accessible at http://bareos:9100/ (assuming your DNS resolve the hostname **bareos** to the NGINX server).

## Command ACL Requirements

The following tables show which commands are required and optional for each module of the Bareos WebUI.

Optional commands may be denied by [`Command ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_CommandACL) settings to limit specific functionality. If you deny a required command, the module will not work.

Note

The commands **.api**, **.help** and **use** are essential commands and should never be denied by [`Command ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_CommandACL) settings in your `Console (Dir)` or `Profile (Dir)` resources.

| Command  | Client   |
| -------- | -------- |
| disable  | optional |
| enable   | optional |
| list     | required |
| llist    | required |
| status   | optional |
| use      | required |
| version  | required |
| .api     | required |
| .clients | required |
| .help    | required |

| Command | Dashboard |
| ------- | --------- |
| cancel  | optional  |
| list    | required  |
| llist   | required  |
| use     | required  |
| .api    | required  |
| .help   | required  |

| Command | Director |
| ------- | -------- |
| list    | required |
| llist   | required |
| status  | optional |
| use     | required |
| .api    | required |
| .help   | required |

| Command | Fileset  |
| ------- | -------- |
| list    | required |
| llist   | required |
| use     | required |
| .api    | required |
| .help   | required |

| Command   | Job      |
| --------- | -------- |
| cancel    | optional |
| disable   | optional |
| enable    | optional |
| list      | required |
| llist     | required |
| rerun     | optional |
| run       | optional |
| use       | required |
| .api      | required |
| .defaults | required |
| .filesets | required |
| .help     | required |
| .jobs     | required |
| .pools    | required |
| .storages | required |

| Command | Media    |
| ------- | -------- |
| list    | required |
| llist   | required |
| use     | required |
| .api    | required |
| .help   | required |

| Command | Pool     |
| ------- | -------- |
| list    | required |
| llist   | required |
| use     | required |
| .api    | required |
| .help   | required |

| Command          | Restore  |
| ---------------- | -------- |
| list             | required |
| llist            | required |
| restore          | optional |
| use              | required |
| .api             | required |
| .filesets        | required |
| .help            | required |
| .jobs            | required |
| .bvfs_lsdirs     | required |
| .bvfs_lsfiles    | required |
| .bvfs_update     | required |
| .bvfs_get_jobids | required |
| .bvfs_versions   | required |
| .bvfs_restore    | required |

| Command   | Schedule |
| --------- | -------- |
| disable   | optional |
| enable    | optional |
| list      | required |
| llist     | required |
| status    | optional |
| show      | optional |
| use       | required |
| .api      | required |
| .help     | required |
| .schedule | required |

| Command | Storage  |
| ------- | -------- |
| export  | optional |
| import  | optional |
| label   | optional |
| list    | required |
| llist   | required |
| release | optional |
| status  | optional |
| update  | optional |
| use     | required |
| .api    | required |
| .help   | required |
| .pools  | optional |

A complete overview of bconsole command usage in the Bareos WebUI can be found in the Developer Guide chapter “[Command usage in modules and the according ACL requirements](https://docs.bareos.org/DeveloperGuide/Webui.html#section-dev-webui-command-usage-in-modules)”.



## Access Control Configuration

Access Control is configured in `Profile (Dir)`, `Console (Dir)` or `User (Dir)` resources.

Below are some example profile resources that should serve you as guidance to configure access to certain elements of the Bareos WebUI to your needs and use cases.

### Full Access

No restrictions are given by `Profile (Dir)`, everything is allowed. This profile is included in the Bareos WebUI package.

Profile Resource - Administrator Access Example

```
Profile {
   Name = "webui-admin"
   CommandACL = *all*
   JobACL = *all*
   ScheduleACL = *all*
   CatalogACL = *all*
   PoolACL = *all*
   StorageACL = *all*
   ClientACL = *all*
   FilesetACL = *all*
   WhereACL = *all*
}
```

### Limited Access

Users with the following profile example have limited access to various resources but they are allowed to **run**, **rerun** and **cancel** the jobs **backup-bareos-fd** and **backup-example-fd**.

Note

Access to depending resources for the jobs set in the [`Job ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_JobACL) needs also be given by [`Client ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_ClientACL), [`Pool ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_PoolACL), [`Storage ACL (Dir->Profile)`](https://docs.bareos.org/Configuration/Director.html#config-Dir_Profile_StorageACL) and `Fileset ACL (Dir->Profile)` settings.

Users of this profile are also able to do a restore from within the Bareos WebUI by having access to the RestoreFiles job resource, the required Bvfs API commands and the **restore** command itself.

Profile Resource - Limited Access Example

```
Profile {
   Name = "webui-user"
   # Multiple CommandACL directives as given below are concatenated
   CommandACL = .api, .help, use, version, status, show
   CommandACL = list, llist
   CommandACL = run, rerun, cancel, restore
   CommandACL = .clients, .jobs, .filesets, .pools, .storages, .defaults, .schedule
   CommandACL = .bvfs_update, .bvfs_get_jobids, .bvfs_lsdirs, .bvfs_lsfiles
   CommandACL = .bvfs_versions, .bvfs_restore, .bvfs_cleanup
   JobACL = backup-bareos-fd, backup-example-fd, RestoreFiles
   ScheduleACL = WeeklyCycle
   CatalogACL = MyCatalog
   PoolACL = Full, Differential, Incremental
   StorageACL = File
   ClientACL = bareos-fd, example-fd
   FilesetACL = SelfTest, example-fileset
   WhereACL = *all*
}
```

### Read-Only Access

This example profile resource denies access to most of the commands and additionally restricts access to certain other resources like `Job (Dir)`, `Schedule (Dir)`, `Pool (Dir)`, `Storage (Dir)`, `Client (Dir)`, `Fileset (Dir)`, etc.

Users of this profile would not be able to run or restore jobs, execute volume and autochanger related operations, enable or disable resources besides other restrictions.

Profile Resource - Read-Only Access Example 1

```
Profile {
  Name = "webui-user-readonly-example-1"

  # Deny general command access
  CommandACL = !.bvfs_clear_cache, !.exit, !configure, !purge, !prune, !reload
  CommandACL = !create, !update, !delete, !disable, !enable
  CommandACL = !show, !status

  # Deny job related command access
  CommandACL = !run, !rerun, !restore, !cancel

  # Deny autochanger related command access
  CommandACL = !mount, !umount, !unmount, !export, !import, !move, !release, !automount

  # Deny media/volume related command access
  CommandACL = !add, !label, !relabel, !truncate

  # Deny SQL related command access
  CommandACL = !sqlquery, !query, !.sql

  # Deny debugging related command access
  CommandACL = !setdebug, !trace

  # Deny network related command access
  CommandACL = !setbandwidth, !setip, !resolve

  # Allow non-excluded command access
  CommandACL = *all*

  # Allow access to the following job resources
  Job ACL = backup-bareos-fd, RestoreFiles

  # Allow access to the following schedule resources
  Schedule ACL = WeeklyCycle

  # Allow access to the following catalog resources
  Catalog ACL = MyCatalog

  # Deny access to the following pool resources
  Pool ACL = !Scratch

  # Allow access to non-excluded pool resources
  Pool ACL = *all*

  # Allow access to the following storage resources
  Storage ACL = File

  # Allow access to the following client resources
  Client ACL = bareos-fd

  # Allow access to the following filset resources
  FileSet ACL = SelfTest

  # Allow access to restore to any filesystem location
  Where ACL = *all*
}
```

Alternatively the example above can be configured as following if you prefer a shorter version.

Profile Resource - Read-Only Access Example 2

```
Profile {
  Name = "webui-user-readonly-example-2"

  # Allow access to the following commands
  CommandACL = .api, .help, use, version, status
  CommandACL = list, llist
  CommandACL = .clients, .jobs, .filesets, .pools, .storages, .defaults, .schedule
  CommandACL = .bvfs_lsdirs, .bvfs_lsfiles, .bvfs_update, .bvfs_get_jobids, .bvfs_versions, .bvfs_restore

  # Allow access to the following job resources
  Job ACL = backup-bareos-fd, RestoreFiles

  # Allow access to the following schedule resources
  Schedule ACL = WeeklyCycle

  # Allow access to the following catalog resources
  Catalog ACL = MyCatalog

  # Allow access to the following  pool resources
  Pool ACL = Full, Differential, Incremental

  # Allow access to the following storage resources
  Storage ACL = File

  # Allow access to the following client resources
  Client ACL = bareos-fd

  # Allow access to the following filset resources
  FileSet ACL = SelfTest

  # Allow access to restore to any filesystem location
  Where ACL = *all*
}
```

For more details, please read [Profile Resource](https://docs.bareos.org/Configuration/Director.html#directorresourceprofile).



## Restore

By default when running a restore in the Bareos WebUI the most recent version of all files from the available backups will be restored. You  can change this behaviour by selecting the merge strategy and specific  job selections in the fields described below. The Bareos WebUI allows  you to restore multiple files or specific file versions.



### Available restore parameters

[![../_images/bareos-webui-restore-0.png](https://docs.bareos.org/_images/bareos-webui-restore-0.png)](https://docs.bareos.org/_images/bareos-webui-restore-0.png)

Client

> A list of available backup clients.

Backup jobs

> A list of successful backup jobs available for the selected client.

Merge all client filesets

> Determines if all available backup job filesets for the selected  client should be merged into one file tree. This is helpful i.e. if  multiple backup jobs with different filesets are available for the  selected client. When you are just interested in a specific backup job,  disable merging here and make the appropriate selection of a backup job.

Merge all related jobs to last full backup of selected backup job

> By default all most recent versions of a file from your  incremental, differential and full backup jobs will be merged into the  file tree. If this behaviour is not desirable and instead the file tree  should show the contents of a particular backup job, set the value to  “No” here. Select a specific backup job afterwards to browse through the according file tree which has been backed up by that job.

Restore to client

> In case you do not want to restore to the original client, you can select an alternative client here.

Restore job

> Sometimes dedicated restore jobs may be required, which can be selected here.

Replace files on client

> Here you can change the behaviour of how and when files should be replaced on the backup client while restoring.
>
> > - always
> > - never
> > - if file being restored is older than existing file
> > - if file being restored is newer than existing file

Restore location on client

> If you like to restore all files to the original location then enter a single `/` here but keep the settings of “Replace files on client” in mind.
>
> In case you want to use another location, simply enter the path here  where you want to restore to on the selected client, for example `/tmp/bareos-restore/`.

### Restore multiple files

[![../_images/bareos-webui-restore-1.png](https://docs.bareos.org/_images/bareos-webui-restore-1.png)](https://docs.bareos.org/_images/bareos-webui-restore-1.png)

### Restore a specific file version

[![../_images/bareos-webui-restore-2.png](https://docs.bareos.org/_images/bareos-webui-restore-2.png)](https://docs.bareos.org/_images/bareos-webui-restore-2.png)

​              

## Bareos-WebUI

Bareos系统的使用和监控Web用户界面，不直接支持Bareos系统的配置功能。WebUI提供基于浏览器的模拟bconsole，Bareos的配置基本都可使用该bconsole界面来完成。完整的系统管理和配置只能通过系统终端完成。

登陆界面

![在这里插入图片描述](https://img-blog.csdn.net/2018100609584011?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
  WebUI支持多Director和多种语言，包括中文。在示例中只有一个Director（localhost-dir），所以默认选择为localhost-dir，如有多个Director，可以通过下拉菜单选择连接的Director。默认语言为英文，如需要使用中文显示，使用语言下拉菜单选择Chinese。

Bareos的中文支持并不完美，其一是它只支持一种中文，所以现在的翻译是简繁体混杂；二是还有部分没翻译或翻译不精确；三是还有部分代码不支持多语言。

Bareos系统没有设置默认WebUI管理用户，在使用前必须先设置管理用户。
 使用bconsole添加WebUI管理员账号（profile名字为webui-admin，这是系统为WebUI保留的profile名字）。

```
root@bareos:~# bconsole
Connecting to Director localhost:9101
1000 OK: bareos-dir Version: 17.2.4 (21 Sep 2017)
Enter a period to cancel a command.
*
*configure add console name=admin password=pwd111111 profile=webui-admin
Created resource config file "/etc/bareos/bareos-dir.d/console/admin.conf":
Console {
  Name = admin
  Password = pwd111111
  Profile = webui-admin
}
*
12345678910111213
```

主页界面

使用新建账号登陆Bareos系统。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181006165318135?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

首页共分5个显示区域：

**工具/状态栏**
 左边是工具选择，分别是`主页`、`任务`、`客户端`、`时间表`、`存储`和`主控端`，用于选择不同的功能。
 右边显示的是当前连接的`Director`和`当前用户`。

**过去24小时中执行的任务情况**
 显示最近24小时内任务执行的简单统计：
 运行：显示正在运行的任务数。
 等待：显示已经启动但正在等待资源就绪的任务数。
 成功：显示正在运行成功的任务数。
 失败：显示正在运行失败的任务数。

**作业统计**
 显示系统启用后的任务总数、文件总数和数据总量。

**最近执行的作业详情**
 显示每个任务执行的任务详情，每个任务只显示最后一次的详情。

**正在执行的任务**
 显示正在执行的任务。

点击当前用户（`admin`），将出现附加功能下拉菜单：

![img](https://img-blog.csdn.net/20181006191453345?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

`用户手册`：点击打开Bareos用户手册页面。
 `用户论坛`：点击打开Bareos用户论坛页面。
 `问题追踪`：点击打开Bareos问题追踪页面。
 `技术支持`：点击打开Bareos技术支持页面。
 `订阅`：点击打开订阅Bareos付费支持页面。
 `登出`：点击退出Bareos-WebUI。

任务界面

![在这里插入图片描述](https://img-blog.csdn.net/20181006190927596?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

**运行模块**
 功能：通过临时修改现有任务的方式，在指定时间执行备份任务。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181008112401609?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- `作业*`：在下拉菜单中选择一个预定义的任务。
- `客户端`：在下拉菜单中，选择合适的客户机，在这里我们选择了lswin0-01-fd（WIN10客户机）。在任务定义中，客户端是总是bareos-fd，原因是bareos-dir无法启动如果客户机没有运行。
- `文件集`：在下拉菜单中选择一个合适的预定义文件集。
- `存储`：在下拉菜单中选择一个合适的预定义存储类型。
- `池`：在下拉菜单中选择一个合适的预定义存储池。
- `备份级别`：在下拉菜单中选择一个合适的备份级别，只用三种备份级别：Full、Differential和Incremental。
- `类型`：在`运行`界面只能运行备份任务。
- `优先级`：为大于或等于1的整数。数值越大优先级越低，优先级高的任务先于优先级的任务运行。
- `执行时间`：从弹出时间选择对话窗口选择执行时间。如不选择时间，即立刻执行该任务。

所有的修改都是临时性的，不会存入选择的任务中。

**动作模块**
 功能：直接运行任务和禁用/启用任务。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010100322547?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 点击动作栏中的                                    ▶                              \blacktriangleright                  ▶ 可直接运行任务。
- 点击动作栏中的                                    ×                              \times                  × 禁用该任务。
- 点击动作栏中的                                    √                              \surd                  √ 启用该任务。
- 状态栏显示的是现有任务的状态。

**显示模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/2018101010165873?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 点击作业ID栏中的                                    +                              +                  + 显示该任务详情。
- 点击作业ID栏中的数字（ID）显示该任务的执行详情。
- 点击动作栏中的                                    ↻                              \boldsymbol{\circlearrowright}                  ↻ 再次执行该任务。
- 点击动作栏中的                                              ↓                            ‾                                       \boldsymbol{\underline{\downarrow}}                  ↓ 使用该任务的备份恢复文件。

还原界面

![在这里插入图片描述](https://img-blog.csdn.net/20181010155019635?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

功能：从现有备份中恢复文件。

- `客户端`：从下拉菜单中选择备份所属的客户端
- `备份作业`：从下拉菜单中选择需要的备份作业。
- `合并所有客户端文件集`：自动把该客户端该作业和该作业以前的所有备份（含不同作业）集合在一起供恢复文件使用；如选“否”，只从选择的备份中恢复文件。
- `合并所有相关作业`：如选“是”，自动把该客户端该作业和该作业以前的所有同一作业的备份集合在一起供恢复文件使用；如选“否”，只从选择的备份中恢复文件。
- `还原到客户端`：从下拉菜单中选择恢复文件的目标客户端。
- `还原作业`：从下拉菜单中选择预定义的还原作业。
- `替换客户端上的文件`：选择同名文件的覆盖规则。可选规则为：总是、从不、比现有文件旧和比现有文件新。
- `要恢复到客户端的位置`：指定恢复文件的目标路径。
- `文件选择`：点击文件/路径前                                    □                              \Box                  □ 来选择是否要恢复此文件/路径；如选择路径，在该路径下的所有文件都会被恢复。                                                                                 ✓                                                                        \boxed{\color{#00FF00}{\checkmark}}                  ✓ 表示需要恢复的文件/路径，                                   □                              \Box                  □ 表示该文件或路径不需要恢复。

完成设置后，点击                                                  还原                                           \colorbox{#0080ff}{\color{white}{还原}}               还原 键启动恢复任务。

客户端界面

![在这里插入图片描述](https://img-blog.csdn.net/20181010161148306?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 列表所有已定义的客户端。

- 名称栏显示的是所有已定义客户端的名字，点击客户端名字将显示客户端当前的一些情况。
- 版本栏显示客户端FD的版本情况，图标是表示系统类型，数字表示版本号。                                                        17.2.4                                                 \colorbox{#00d000}{\color{white}{17.2.4}}                  17.2.4 表示是最新版本，                                                         17.2.4                                                 \colorbox{#a0a0a0}{\color{white}{17.2.4}}                  17.2.4 表示无法确定是否是最新版本。
- 状态栏显示的是该FD当前的状态，可以是                                                         已启用                                                 \colorbox{#00d000}{\color{white}{已启用}}                  已启用 或                                                         禁用                                                 \colorbox{#d00000}{\color{white}{禁用}}                  禁用。
- 点击动作栏中的                                    ×                              \times                  × 禁用该FD。
- 点击动作栏中的                                    √                              \surd                  √ 启用该FD。
- 点击动作栏中的                                              ↘                            ‾                                       \underline{\boldsymbol{\searrow}}                  ↘ 开始该客户端备份的恢复任务。
- 点击动作栏中的                                    ⨀                              {\boldsymbol{\bigodot}}                  ⨀ 检查FD的当前状态。
- 

时间表（schedule）界面

**显示模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010164448237?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

- 名称栏显示的是所有已定义时间表的名字，点击时间表名字将显示该时间表详细信息。
- 状态栏显示的是该FD当前的状态，可以是                                                         已启用                                                 \colorbox{#00d000}{\color{white}{已启用}}                  已启用 或                                                         禁用                                                 \colorbox{#d00000}{\color{white}{禁用}}                  禁用。
- 点击动作栏中的                                    ×                              \times                  × 禁用该FD。
- 点击动作栏中的                                    √                              \surd                  √ 启用该FD。

**概述模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010164728191?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 显示时间表定义文件。

**调度程序状态模块**
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010164920851?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 显示时间表调度详情。

存储（storage）界面

共有三个显示模块，分别显示设备（device）、池（pool）和卷（volume）的情况。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170117161?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170136222?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170154398?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

主控端（Director）界面

共有三个模块，分别显示状态（status）、信息（message）情况和控制台（bconsole）模拟界面。
 ![在这里插入图片描述](https://img-blog.csdn.net/2018101017080180?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010170817554?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010171033260?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
 模拟bconsole界面的可用性并不是太好，建议在系统终端使用bconsole来配置系统。
 ![在这里插入图片描述](https://img-blog.csdn.net/20181010172119582?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xhb3RvdTE5NjM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)