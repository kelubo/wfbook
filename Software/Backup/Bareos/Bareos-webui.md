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