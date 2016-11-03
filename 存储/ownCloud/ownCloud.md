# ownCloud

## System Requirements

### Memory
最小128MB，建议最小512MB。

### Recommended Setup

    Ubuntu 16.04
    MySQL/MariaDB
    PHP 5.6 +
    Apache 2.4 with mod_php

### Supported Platforms
Server:

    Debian 7 and 8, SUSE Linux Enterprise Server 12 and 12 SP1,
    Red Hat Enterprise Linux/Centos 6.5 and 7 (7 is 64-bit only),
    Ubuntu 14.04 LTS, 16.04 LTS)

Web server:

    Apache 2.4 with mod_php

Databases:

    MySQL/MariaDB 5.5+; Oracle 11g (ownCloud Enterprise edition only); PostgreSQL

PHP 5.4 + required

Hypervisors:

    Hyper-V, VMware ESX, Xen, KVM

Desktop:

    Windows 7+, Mac OS X 10.7+ (64-bit only), Linux (CentOS 6.5, 7 (7 is 64-bit only),
    Ubuntu 12.04+, Fedora 20+, openSUSE 12.3+, Debian 7 & 8).

Mobile apps:

    iOS 7+, Android 4+

Web browser:

    IE11+ (except Compatibility Mode), Firefox 14+, Chrome 18+, Safari 5+

### Database Requirements for MySQL / MariaDB

    Disabled or BINLOG_FORMAT = MIXED configured Binary Logging
    InnoDB storage engine
    “READ COMMITED” transaction isolation level






## Converting Database Type
setup the new database, here called “new_db_name”. In ownCloud root folder call

php occ db:convert-type [options] type username hostname database

php occ db:convert-type [options] type username hostname database

The Options

    --port="3306" the database port (optional)
    --password="mysql_user_password" password for the new database. If omitted the tool will ask you (optional)
    --clear-schema clear schema (optional)
    --all-apps by default, tables for enabled apps are converted, use to convert also tables of deactivated apps (optional)

Note: The converter searches for apps in your configured app folders and uses the schema definitions in the apps to create the new table. So tables of removed apps will not be converted even with option --all-apps

For example

php occ db:convert-type --all-apps mysql oc_mysql_user 127.0.0.1 new_db_name

To successfully proceed with the conversion, you must type yes when prompted with the question Continue with the conversion?

On success the converter will automatically configure the new database in your ownCloud config config.php.
Unconvertible Tables¶

If you updated your ownCloud installation there might exist old tables, which are not used anymore. The converter will tell you which ones.

The following tables will not be converted:
oc_permissions
...

You can ignore these tables. Here is a list of known old tables:

    oc_calendar_calendars
    oc_calendar_objects
    oc_calendar_share_calendar
    oc_calendar_share_event
    oc_fscache
    oc_log
    oc_media_albums
    oc_media_artists
    oc_media_sessions
    oc_media_songs
    oc_media_users
    oc_permissions
    oc_queuedtasks
    oc_sharing






## 上传文件大小限制

1.ownCloud目录中的文件：.htaccess  


    # cat owncloud/.htaccess
    <IfModule mod_php5.c>
    php_value upload_max_filesize 10240M
    php_value post_max_size 10240M
    php_value memory_limit 10240M

2.PHP的配置文件php.ini


    # cat /usr/local/php/etc/php.ini
    upload_max_filesize = 2M
    post_max_size = 10240M
