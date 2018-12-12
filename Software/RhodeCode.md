# RhodeCode

##  系统架构

![](/home/wangfei/CVS/Git/wfbook/Image/RhodeCode.png)

## 相关要求

### 1. 数据库

- [MySQL or MariaDB](https://docs.rhodecode.com/RhodeCode-Enterprise/install/using-mysql.html)
- [PostgreSQL](https://docs.rhodecode.com/RhodeCode-Enterprise/install/using-postgresql.html)
- SQLite （不建议）

### 2. 操作系统

#### Linux

- Ubuntu 14.04
- CentOS 6.2 and 7
- Debian 7.8
- RedHat Fedora
- Arch Linux
- SUSE Linux

#### Windows

- Windows Vista Ultimate 64bit
- Windows 7 Ultimate 64bit
- Windows 8 Professional 64bit
- Windows 8.1 Enterprise 64bit
- Windows Server 2008 64bit
- Windows Server 2008-R2 64bit
- Windows Server 2012 64bit

### 3. 浏览器

- Chrome
- Safari
- Firefox
- Internet Explorer 10 & 11

### 4. System Requirements

For example:

> - for team of 1 - 5 active users you can run on 1GB RAM machine with 1CPU
> - above 250 active users, RhodeCode Enterprise needs at least 8GB of memory. Number of CPUs is less important, but recommended to have at least 2-3 CPUs

## 安装

1. 从 [rhodecode.com/download](https://rhodecode.com/download/) 下载最新的 RhodeCode Control installer。

2.  运行 RhodeCode Control installer 并且接受 User Licence ：

```
$ chmod 755 RhodeCode-installer-linux-*
$ ./RhodeCode-installer-linux-*
```

3. 安装一个 VCS Server，配置开机启动。

```
$ rccontrol install VCSServer

Agree to the licence agreement? [y/N]: y
IP to start the server on [127.0.0.1]:
Port for the server to start [10005]:
Creating new instance: vcsserver-1
Installing RhodeCode VCSServer
Configuring RhodeCode VCS Server ...
Supervisord state is: RUNNING
Added process group vcsserver-1
```

4. 安装 RhodeCode Enterprise 或者 RhodeCode Community 。需要确保 Mysql or Postgres 正在运行，且有一个新建的数据库。

```
 $ rccontrol install Community

 or

 $ rccontrol install Enterprise

 Username [admin]: username
 Password (min 6 chars):
 Repeat for confirmation:
 Email: your@mail.com
 Respositories location [/home/brian/repos]:
 IP to start the Enterprise server on [127.0.0.1]:
 Port for the Enterprise server to use [10004]:
 Database type - [s]qlite, [m]ysql, [p]ostresql:
 PostgreSQL selected
 Database host [127.0.0.1]:
 Database port [5432]:
 Database username: db-user-name
 Database password: somepassword
 Database name: example-db-name
```

5. 检查状态。

```
$ rccontrol status

- NAME: enterprise-1
- STATUS: RUNNING
- TYPE: Enterprise
- VERSION: 4.1.0
- URL: http://127.0.0.1:10003

- NAME: vcsserver-1
- STATUS: RUNNING
- TYPE: VCSServer
- VERSION: 4.1.0
- URL: http://127.0.0.1:10001
```

## 配置

### Configuration Files

- `/home/*user*/.rccontrol/*instance-id*/rhodecode.ini`

- `/home/*user*/.rccontrol/*instance-id*/mapping.ini`

- `/home/*user*/.rccontrol/*vcsserver-id*/vcsserver.ini`

- `/home/*user*/.rccontrol/supervisor/supervisord.ini`

- `/home/*user*/.rccontrol.ini`

- `/home/*user*/.rhoderc`

- `/home/*user*/.rccontrol/cache/MANIFEST`

   

1. **rhodecode.ini**

Default location: `/home/*user*/.rccontrol/*instance-id*/rhodecode.ini` This is the main RhodeCode Enterprise configuration file and controls much of its default behaviour. It is also used to configure certain customer settings. Here are some of the most common reasons to make changes to this file.  [Make Database Changes](https://docs.rhodecode.com/RhodeCode-Enterprise/install/database-string.html#config-database) [Set up Email](https://docs.rhodecode.com/RhodeCode-Enterprise/install/setup-email.html#set-up-mail) [Configure Gunicorn Workers](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/tuning-gunicorn.html#increase-gunicorn) [Securing HTTPS Connections](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/sec-x-frame.html#x-frame)  

2. **mapping.ini**

Default location: `/home/*user*/.rccontrol/*instance-id*/mapping.ini` This file is used to control the RhodeCode Enterprise indexer. It comes configured to index your instance. To change the default configuration, see [Advanced Indexing](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/indexing.html#advanced-indexing). 

3. **vcsserver.ini**

Default location: `/home/*user*/.rccontrol/*vcsserver-id*/vcsserver.ini` The VCS Server handles the connection between your repositories and RhodeCode Enterprise. See the [VCS Server Management](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/vcs-server.html#vcs-server) section for configuration options and more detailed information. 

4. **supervisord.ini**

Default location: `/home/*user*/.rccontrol/supervisor/supervisord.ini` RhodeCode Control uses Supervisor to monitor and manage installed instances of RhodeCode Enterprise and the VCS Server. RhodeCode Control will manage this file completely, unless you install RhodeCode Enterprise in self-managed mode. For more information, see the [Supervisor Setup](https://docs.rhodecode.com/RhodeCode-Control/tasks/admin_tasks/supervisor.html#supervisor-setup) section. 

5. **.rccontrol.ini**

Default location: `/home/*user*/.rccontrol.ini` This file contains the instances that RhodeCode Control starts at boot, which is all by default, but for more information, see the [Manually Start At Boot](https://docs.rhodecode.com/RhodeCode-Control/tasks/admin_tasks/supervisor.html#set-start-boot) section. 

6. **.rhoderc**

Default location: `/home/*user*/.rhoderc` This file is used by the RhodeCode Enterprise API when accessing an instance from a remote machine. The API checks this file for connection and authentication details. For more details, see the [Configure the .rhoderc File](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/indexing.html#config-rhoderc) section. 

7. **MANIFEST**

Default location: `/home/*user*/.rccontrol/cache/MANIFEST` RhodeCode Control uses this file to source the latest available builds from the secure RhodeCode download channels. The only reason to mess with this file is if you need to do an offline installation, see the [Offline Installation](https://docs.rhodecode.com/RhodeCode-Control/tasks/offline-installer.html#offline-installer-ref) instructions, otherwise RhodeCode Control will completely manage this file. 

### Log Files

- `/home/*user*/.rccontrol/*instance-id*/enterprise.log`
- `/home/*user*/.rccontrol/*vcsserver-id*/vcsserver.log`
- `/home/*user*/.rccontrol/supervisor/supervisord.log`
- `/tmp/rccontrol.log`
- `/tmp/rhodecode_tools.log`

### Storage Files

- `/home/*user*/.rccontrol/*instance-id*/data/index/*index-file.toc*`
- `/home/*user*/repos/.rc_gist_store`
- `/home/*user*/.rccontrol/*instance-id*/rhodecode.db`
- `/opt/rhodecode/store/*unique-hash*`

### Default Repositories Location

- `/home/*user*/repos`

### Connection Methods

- HTTPS
- SSH
- RhodeCode Enterprise API

### Internationalization Support

Currently available in the following languages, see [Transifex](https://www.transifex.com/projects/p/RhodeCode/) for the latest details. If you want a new language added, please contact us. To configure your language settings, see the [Changing Default Language](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/admin-tricks.html#set-lang) section.

*  Belorussian
*  Chinese
*  French
*  German
*  Italian 
*  Japanese
*  Portuguese
*  Polish
*  Russian
*  Spanish

=======================================================================================

### 1. 配置 Email

默认配置文件

 `/home/user/.rccontrol/instance-id/rhodecode.ini`

```
################################################################################
## Uncomment and replace with the email address which should receive          ##
## any error reports after an application crash                               ##
## Additionally these settings will be used by the RhodeCode mailing system   ##
################################################################################
#email_to = admin@localhost
#app_email_from = rhodecode-noreply@localhost
#email_prefix = [RhodeCode]

#smtp_server = mail.server.com
#smtp_username =
#smtp_password =
#smtp_port =
#smtp_use_tls = false
#smtp_use_ssl = true
```

### 2. 变更 Database

需要更新 database，并且 remap 和 rescan repositories。

1. 修改配置文件 `home/*user*/.rccontrol/*instance-id*/rhodecode.ini`
2. 变更如下：

```
#########################################################
### DB CONFIGS - EACH DB WILL HAVE IT'S OWN CONFIG    ###
#########################################################

# Default SQLite config
sqlalchemy.db1.url = sqlite:////home/brian/.rccontrol/enterprise-1/rhodecode.db

# Use this example for a PostgreSQL
sqlalchemy.db1.url = postgresql://postgres:qwe@localhost/rhodecode

# see sqlalchemy docs for other advanced settings
sqlalchemy.db1.echo = false
sqlalchemy.db1.pool_recycle = 3600
sqlalchemy.db1.convert_unicode = true
```

### 3. Configure Celery(这一玩意不知道干嘛用的，先不管了)

[Celery](http://celeryproject.org/) is an asynchronous task queue. It’s a part of RhodeCode scheduler functionality. [Celery](http://celeryproject.org/) makes certain heavy tasks perform more efficiently. Most important it allows sending notification emails, create repository forks, and import repositories in async way. It is also used for bi-directional repository sync in scheduler.

If you decide to use Celery you also need a working message queue. The recommended and fully supported message broker is [rabbitmq](http://www.rabbitmq.com/).

In order to install and configure Celery, follow these steps:

1. Install RabbitMQ, see the documentation on the Celery website for [rabbitmq installation](http://docs.celeryproject.org/en/latest/getting-started/brokers/rabbitmq.html), or [rabbitmq website installation](http://www.rabbitmq.com/download.html)

1a. As en example configuration after installation, you can run:

```
sudo rabbitmqctl add_user rcuser secret_password
sudo rabbitmqctl add_vhost rhodevhost
sudo rabbitmqctl set_user_tags rcuser rhodecode
sudo rabbitmqctl set_permissions -p rhodevhost rcuser ".*" ".*" ".*"
```

1. Enable celery, and install celery worker process script using the enable-module:

   ```
   rccontrol enable-module celery {instance-id}
   ```

Note

In case when using multiple instances in one or multiple servers it’s highly recommended that celery is running only once, for all servers connected to the same database. Having multiple celery instances running without special reconfiguration could cause scheduler issues.

1. Configure Celery in the `home/*user*/.rccontrol/*instance-id*/rhodecode.ini` file. Set the broker_url as minimal settings required to enable operation. If used our example data from pt 1a, here is how the broker url should look like:

   ```
   celery.broker_url = amqp://rcuser:secret_password@localhost:5672/rhodevhost
   ```

   Full configuration example is below:

   ```
   # Set this section of the ini file to match your Celery installation
   ####################################
   ###        CELERY CONFIG        ####
   ####################################
   
   use_celery = true
   celery.broker_url = amqp://rcuser:secret@localhost:5672/rhodevhost
   
   # maximum tasks to execute before worker restart
   celery.max_tasks_per_child = 100
   
   ## tasks will never be sent to the queue, but executed locally instead.
   celery.task_always_eager = false
   ```

### 4.Migrating repositories

If you have installed RhodeCode Enterprise and have repositories that you wish to migrate into the system, use the following instructions.

1. On the RhodeCode Enterprise interface, check your repository storage location under Admin ‣ Settings ‣ System Info. For example, Storage location: /home/{username}/repos.
2. Copy the repositories that you want RhodeCode Enterprise to manage to this location.
3. Remap and rescan the repositories, see [Remap and Rescan Repositories](https://docs.rhodecode.com/RhodeCode-Enterprise/admin/admin-tricks.html#remap-rescan)

Important

Directories create repository groups inside RhodeCode Enterprise.

Importing adds RhodeCode Enterprise git hooks to your repositories.

You should verify if custom `.hg` or `.hgrc` files inside repositories should be adjusted since RhodeCode Enterprise reads the content of them.

## VCS服务器管理

### VCS服务器选项

以下列表显示rhodecode连接到VCS服务器的可用选项。

/home/user/.rccontrol*instance-ID*/rhodecode.ini/

- vcs.backends <available-vcs-systems>

  默认的是`Hg， Git SVN`是所有可用储存库类型。

- vcs.connection_timeout <seconds>

  默认的是`3600`。

- vcs.server.enable <Boolean>

  启用或禁用VCS服务器。可用选项`true`或`false`。默认的是`true`。

- vcs.server `<host:port>`

  设置主机。主机名或IP地址、端口。

```
##################
### VCS CONFIG ###
##################
# set this line to match your VCS Server
vcs.server = 127.0.0.1:10004
# Set to False to disable the VCS Server
vcs.server.enable = True
vcs.backends = hg, git, svn
vcs.connection_timeout = 3600
```

### VCS Server 版本

An updated version of the VCS Server is released with each RhodeCode Enterprise version. Use the VCS Server number that matches with the RhodeCode Enterprise version to pair the appropriate ones together. For RhodeCode Enterprise versions pre 3.3.0, VCS Server 1.X.Y works with RhodeCode Enterprise 3.X.Y, for example:

- VCS Server 1.0.0 works with RhodeCode Enterprise 3.0.0
- VCS Server 1.2.2 works with RhodeCode Enterprise 3.2.2

For RhodeCode Enterprise versions post 3.3.0, the VCS Server and RhodeCode Enterprise version numbers match, for example:

- VCS Server 4.14.1 works with RhodeCode Enterprise 4.14.1

### VCS Server Memory Optimization

To optimize the VCS server to manage the cache and memory usage efficiently `/home/*user*/.rccontrol/*vcsserver-ID*vcsserver.ini/`

配置完毕，需要VCS服务器重新启动。

```
## cache region for storing repo_objects cache
rc_cache.repo_object.backend = dogpile.cache.rc.memory_lru

## cache auto-expires after N seconds,setting this to 0 disabled cache
rc_cache.repo_object._到期时间 = 300

## max size of LRU,old value will be discarded if the size of cache reaches max_size
## Sets the maximum number of items stored in the cache,before the cache
## starts to be cleared.

## As a general rule of thumb,running this value at 120 resulted in a
## 5GB cache.Running it at 240 resulted in a 9GB cache.Your results
## will differ based on usage patterns and |repo| sizes.

## Tweaking this value to run at a fairly constant memory load on your
## server will help performance.

rc_cache.repo_object.max_size = 120
```

要清除缓存，可以重启该VCS服务器。

使用以下命令，实现VCS服务器重新启动。

```
$ rccontrol status
- NAME: vcsserver-1
- STATUS: RUNNING
  logs:/home/ubuntu/.rccontrolvcsserver-1/vcsserver.log
- VERSION: 4.7.2 VCSServer
- URL: http://127.0.0.1:10008
- CONFIG: /home/ubuntu。//rccontrolvcsserver-1/vcsserver.ini

$ rccontrol restart vcsserver-1
Instance "vcsserver-1" successfully stopped.
Instance "vcsserver-1" successfully started.
```

### VCS服务器的配置

`home/user/.rccontrol/vcsserver-ID/vcsserver.ini`

- host <ip-address>

  设置VCS服务器地址。推荐运行在本地主机，IP地址127.0.0.1

- port <int>

  设定端口号码。

- locale <locale_utf>

  。

- workers <int>

  建议 (2 * NUMBER_OF_CPUS + 1)，建议2CPU = 5 workers

- max_requests <int>

  。

- max_requests_jitter <int>

  。

```
############################################################################# RhodeCode VCSServer with HTTP Backend - configuration                    #
#                                                                          #
############################################################################


[server:main]
## COMMON ##
host = 127.0.0.1
port = 10002

##########################
## GNUICORN WSGI SERVER ##
##########################
## run with gunicorn --log-config vcsserver.ini --paste vcsserver.ini
use = egg:gunicorn#main
## Sets the number of process workers. Recommended
## value is (2 * NUMBER_OF_CPUS + 1), eg 2CPU = 5 workers
workers = 3
## process name
proc_name = rhodecode_vcsserver
## type of worker class, one of sync, gevent
## recommended for bigger setup is using of of other than sync one
worker_class = sync
## The maximum number of simultaneous clients. Valid only for Gevent
#worker_connections = 10
## max number of requests that worker will handle before being gracefully
## restarted, could prevent memory leaks
max_requests = 1000
max_requests_jitter = 30
## amount of time a worker can spend with handling a request before it
## gets killed and restarted. Set to 6hrs
timeout = 21600

[app:main]
use = egg:rhodecode-vcsserver

pyramid.default_locale_name = en
pyramid.includes =

## default locale used by VCS systems
locale = en_US.UTF-8

# cache regions ,please don't change
beaker.cache.regions = repo_object
beaker.cache.repo_object.type = memorylru
beaker.cache.repo_object.max_items = 100
# cache auto-expires after N seconds
beaker.cache.repo_object.expire = 300
beaker.cache.repo_object.enabled = true


################################
### LOGGING CONFIGURATION   ####
################################
[loggers]
keys = root,vcsserver,beaker

[handlers]
keys = console

[formatters]
keys = generic

#############
## LOGERS  ##
#############
[logger_root]
level = NOTSET
handlers = console

[logger_vcsserver]
level = DEBUG
handlers =
qualname = vcsserver
propagate = 1

[logger_beaker]
level = DEBUG
handlers =
qualname = beaker
propagate = 1


##############
## HANDLERS ##
##############

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = DEBUG
formatter = generic

################
## FORMATTERS ##
################

[formatter_generic]
format = %(asctime)s.％(msecs)03d %(levelname)-5.5s [％(name)s] %(message)s
datefmt = %Y-%m-%d%H:%M:%S
```

## Subversion With Write Over HTTP

### 先决条件

- Enable HTTP support inside the admin VCS settings on your RhodeCode Enterprise instance
- You need to install the following tools on the machine that is running an instance of RhodeCode Enterprise: `Apache HTTP Server` and `mod_dav_svn`.

Example installation of required components for Ubuntu platform:

```
$ sudo apt-get install apache2
$ sudo apt-get install libapache2-mod-svn
```

Once installed you need to enable `dav_svn` on Ubuntu:

```
$ sudo a2enmod dav_svn
$ sudo a2enmod headers
$ sudo a2enmod authn_anon
```

Example installation of required components for RedHat/CentOS platform:

```
$ sudo yum install httpd
$ sudo yum install subversion mod_dav_svn
```

Once installed you need to enable `dav_svn` on RedHat/CentOS:

```
sudo vi /etc/httpd/conf.modules.d/10-subversion.conf
## The file should read:

LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule headers_module     modules/mod_headers.so
LoadModule authn_anon_module  modules/mod_authn_anon.so
```

### Configuring Apache Setup

Make sure your Apache instance which runs the mod_dav_svn module is only accessible by RhodeCode Enterprise. Otherwise everyone is able to browse the repositories or run subversion operations (checkout/commit/etc.).

It is also recommended to run apache as the same user as RhodeCode Enterprise, otherwise permission issues could occur. To do this edit the `/etc/apache2/envvars`

> ```
> export APACHE_RUN_USER=rhodecode
> export APACHE_RUN_GROUP=rhodecode
> ```

1. To configure Apache, create and edit a virtual hosts file, for example `/etc/apache2/sites-enabled/default.conf`. Below is an example how to use one with auto-generated config ``mod_dav_svn.conf`` from configured RhodeCode Enterprise instance.

```
<VirtualHost *:8090>
    ServerAdmin rhodecode-admin@localhost
    DocumentRoot /var/www/html
    ErrorLog ${'${APACHE_LOG_DIR}'}/error.log
    CustomLog ${'${APACHE_LOG_DIR}'}/access.log combined
    LogLevel info
    # allows custom host names, prevents 400 errors on checkout
    HttpProtocolOptions Unsafe
    Include /home/user/.rccontrol/enterprise-1/mod_dav_svn.conf
</VirtualHost>
```

1. Go to the Admin ‣ Settings ‣ VCS page, and enable Proxy Subversion HTTP requests, and specify the Subversion HTTP Server URL.

2. Open the RhodeCode Enterprise configuration file, `/home/*user*/.rccontrol/*instance-id*/rhodecode.ini`

3. Add the following configuration option in the `[app:main]` section if you don’t have it yet.

   This enables mapping of the created RhodeCode Enterprise repo groups into special Subversion paths. Each time a new repository group is created, the system will update the template file and create new mapping. Apache web server needs to be reloaded to pick up the changes on this file. To do this, simply configure svn.proxy.reload_cmd inside the .ini file. Example configuration:

```
############################################################
### Subversion proxy support (mod_dav_svn)               ###
### Maps RhodeCode repo groups into SVN paths for Apache ###
############################################################
## Enable or disable the config file generation.
svn.proxy.generate_config = true
## Generate config file with `SVNListParentPath` set to `On`.
svn.proxy.list_parent_path = true
## Set location and file name of generated config file.
svn.proxy.config_file_path = %(here)s/mod_dav_svn.conf
## Used as a prefix to the <Location> block in the generated config file.
## In most cases it should be set to `/`.
svn.proxy.location_root = /
## Command to reload the mod dav svn configuration on change.
## Example: `/etc/init.d/apache2 reload`
svn.proxy.reload_cmd = /etc/init.d/apache2 reload
## If the timeout expires before the reload command finishes, the command will
## be killed. Setting it to zero means no timeout. Defaults to 10 seconds.
#svn.proxy.reload_timeout = 10
```

This would create a special template file called ``mod_dav_svn.conf``. We used that file path in the apache config above inside the Include statement. It’s also possible to manually generate the config from the Admin ‣ Settings ‣ VCS page by clicking a Generate Apache Config button.

1. Now only things left is to enable svn support, and generate the initial configuration.
   - Select Proxy subversion HTTP requests checkbox
   - Enter <http://localhost:8090> into Subversion HTTP Server URL
   - Click the Generate Apache Config button.

This config will be automatically re-generated once an user-groups is added to properly map the additional paths generated.

### Using Subversion

Once Subversion has been enabled on your instance, you can use it with the following examples. For more Subversion information, see the [Subversion Red Book](http://svnbook.red-bean.com/en/1.7/svn-book.html#svn.ref.svn)

```
# To clone a repository
svn checkout http://my-svn-server.example.com/my-svn-repo

# svn commit
svn commit
```

