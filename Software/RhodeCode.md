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

​           

