# Nextcloud

[TOC]

## Prerequisites And Assumptions[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#prerequisites-and-assumptions)

- Server running Rocky Linux (you can install Nextcloud on any Linux  distribution, but this procedure will assume you're using Rocky).
- A high degree of comfort operating from the command line for installation and for configuration.
- Knowledge of a command-line editor. For this example, we are using *vi*, but you can use your favorite editor if you have one.
- While Nextcloud can be installed via a snap application, we will be downloading and installing the .zip file.
- We will be applying concepts from the Apache sites enabled document (linked to later in this document) for directory setup.
- We will also be using the *mariadb-server* hardening procedure (also linked to later) for database setup.
- Throughout this document we will assume that you are root, or that you can be by using *sudo*.
- We are using an example domain of "yourdomain.com" throughout this document.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#introduction)

If you are in charge of a server environment for a large (or even a  small) company, you may be tempted by cloud applications. Doing things  in the cloud can free up your own resources for other things, but there  is a downside to this, and that is the loss of control of your company's data. If the cloud application is compromised, so too may be your  company's data.

Taking the cloud back into your own environment is a way to reclaim  security of your data at the expense of your time and energy. Sometimes, that is a cost worth paying.

Nextcloud offers an open source cloud with security and flexibility  in mind. Note that building a Nextcloud server is a good exercise, even  if in the end you opt to take your cloud off-site. The following  procedure deals with setting up Nextcloud on Rocky Linux.

## Installing And Configuring Repositories[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#installing-and-configuring-repositories)

For this installation, we will require two repositories. We need to  install the EPEL (Extra Packages for Enterprise Linux) and the Remi  Repository for PHP 7.4 (version 7.3 or 7.4 is required and Rocky Linux  provides 7.2.x).

To install the EPEL run:

```
dnf install epel-release
```

And then once installed, run an update to make sure you are at the very latest epel version:

```
dnf update
```

To install the Remi repository run:

```
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
```

Run the following to see a list of php modules that can be enabled:

```
dnf module list php
```

Which should give you output like this:

```
CentOS Linux 8 - AppStream
Name                   Stream                         Profiles                                    Summary                                
php                    7.2 [d]                        common [d], devel, minimal                  PHP scripting language                 
php                    7.3                            common [d], devel, minimal                  PHP scripting language                 
php                    7.4                            common [d], devel, minimal                  PHP scripting language                 

Remi's Modular repository for Enterprise Linux 8 - x86_64
Name                   Stream                         Profiles                                    Summary                                
php                    remi-7.2                       common [d], devel, minimal                  PHP scripting language                 
php                    remi-7.3                       common [d], devel, minimal                  PHP scripting language                 
php                    remi-7.4                       common [d], devel, minimal                  PHP scripting language                 
php                    remi-8.0                       common [d], devel, minimal                  PHP scripting language                 

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

We want to grab the newest PHP that Nextcloud is compatible with,  which at this moment is 7.4, so we will enable that module by doing:

```
dnf module enable php:remi-7.4
```

To see how this changes the output of the module list, run that command again and you will see the "[e]" next to remi-7.4:

```
dnf module list php
```

And the output again is the same except for this line:

```
php                    remi-7.4 [e]                   common [d], devel, minimal                  PHP scripting language
```

## Installing Packages[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#installing-packages)

We need a lot of packages installed. Some of these may already be  installed with your default Rocky Linux installation, but make sure by  running the following command the following:

```
dnf install httpd mariadb-server vim wget zip unzip libxml2  openssl php74-php php74-php-ctype php74-php-curl php74-php-gd  php74-php-iconv php74-php-json php74-php-libxml php74-php-mbstring  php74-php-openssl php74-php-posix php74-php-session php74-php-xml  php74-php-zip php74-php-zlib php74-php-pdo php74-php-mysqlnd  php74-php-intl php74-php-bcmath php74-php-gmp
```

## Configuring Packages And Directories[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-packages-and-directories)

### Configuring apache[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-apache)

Set *apache* to start on boot:

```
systemctl enable httpd
```

As noted earlier, we are using the "Apache Sites Enabled" procedure found [here](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/) to configure Apache. Follow that guide to get the configuration directories setup and the *httpd.conf* file modified and then return to this document for the remaining steps.

#### Create The Configuration[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#create-the-configuration)

For Nextcloud, we will need to create the following configuration file.

```
vi /etc/httpd/sites-available/com.yourdomain.nextcloud
```

Your configuration file should look something like this:

```
<VirtualHost *:80>
  DocumentRoot /var/www/sub-domains/com.yourdomain.nextcloud/html/
  ServerName  nextcloud.yourdomain.com

  <Directory /var/www/sub-domains/com.yourdomain.nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

Once done, save your changes (with `SHIFT:wq!` for *vi*).

Next, create a link to this file in /etc/httpd/sites-enabled:

```
ln -s /etc/httpd/sites-available/com.yourdomain.nextcloud /etc/httpd/sites-enabled/
```

#### Creating The Directory[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#creating-the-directory)

As noted in the configuration above, the *DocumentRoot* needs to be created. This can be done by:

```
mkdir -p /var/www/sub-domains/com.yourdomain.com/html
```

This is where our Nextcloud instance will be installed.

### Configuring PHP[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-php)

Find your timezone. This can be done by:

```
cd /usr/share/zoneinfo
```

If you are in the Central timezone, for instance, you could either  use "US/Central" or "America/Chicago" and either setting would work.  Once you have identified your timezone, the next thing we need to do is  populate the php.ini file with this information.

To do this:

```
vi /etc/opt/remi/php74/php.ini
```

Then find this line:

```
;date.timezone =
```

For our example timezone, we would put in either of the two options:

```
date.timezone = "America/Chicago"
```

OR

```
date.timezone = "US/Central"
```

Note that for the sake of keeping things the same, your timezone in the *php.ini* file should match up to your machine's timezone setting. You can find out what this is set to by doing the following:

```
ls -al /etc/localtime
```

Which should show you something like this, assuming you set your  timezone when you installed Rocky Linux and are living in the Central  time zone:

```
/etc/localtime -> /usr/share/zoneinfo/America/Chicago
```

### Configuring mariadb-server[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-mariadb-server)

Set *mariadb-server* to start on boot:

```
systemctl enable mariadb
```

And then start it:

```
systemctl restart mariadb
```

Again, as indicated earlier, we will be using the setup procedure for hardening *mariadb-server* found [here](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/) for the initial configuration.

## Installing Nextcloud[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#installing-nextcloud)

There are several ways to install Nextcloud which you can review on  the web site under the manual for installation. What we will be using  here is the server install .zip file.

### Get The Nextcloud .zip File And Unzip[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#get-the-nextcloud-zip-file-and-unzip)

The next few steps assume that you are remotely connected to your Nextcloud server via *ssh* with a remote console open:

- Navigate to the [Nextcloud web site](https://nextcloud.com/)
- Let your mouse hover over "Get Nextcloud" which will bring up a drop down menu.
- Click on "Server Packages".
- Right-click on "Download Nextcloud" and copy the link address. (the exact syntax of this is different browser to browser)
- In your remote console on the Nextcloud server, type "wget" and then a space and paste in what you just copied. You should get something  like the following: `wget https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip`
- Once you hit enter, the download of the .zip file will start and will be completed fairly quickly.

Once the download is complete, unzip the nextcloud zip file by using the following:

```
unzip nextcloud-21.0.1.zip
```

### Copying Content And Changing Permissions[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#copying-content-and-changing-permissions)

After completing the unzip step, you should now have a new directory in /root called "nextcloud." Change into this directory:

```
cd nextcloud
```

And either copy or move the content to our *DocumentRoot*:

```
cp -Rf * /var/www/sub-domains/com.yourdomain.nextcloud/html/
```

OR

```
mv * /var/www/sub-domains/com.yourdomain.nextcloud/html/
```

Now that everything is where it should be, the next step is to make sure that apache owns the directory. To do this:

```
chown -Rf apache.apache /var/www/sub-domains/com.yourdomain.nextcloud/html
```

For security reasons, we also want to move the "data" folder from inside to outside of the *DocumentRoot*. Do this with the following command:

```
mv /var/www/sub-domains/com.yourdomain.nextcloud/html/data /var/www/sub-domains/com.yourdomain.nextcloud/
```

### Configuring Nextcloud[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-nextcloud)

Now comes the fun! First, make sure that you have your services  running. If you followed the above steps, they should already be  running. We have had several steps between those initial service starts, so let's go ahead and restart them, just to be sure:

```
plain text systemctl restart httpd systemctl restart mariadb
```

If everything restarts and there are no issues, then you are ready to move on.

To do the initial configuration, we want to actually load the site in a web browser:

```
http://nextcloud.yourdomain.com/
```

And you should see this screen:

![nextcloud login screen](https://docs.rockylinux.org/guides/images/nextcloud_screen.jpg)

There are a couple of things that we want to do differently than the defaults that show up:

- At the top of the web page, where it says "Create an admin account", set the user and password. For the sake of this document, we are  entering "admin" and setting a strong password. Remember to save this  somewhere safe (like a password manager) so that you don't lose it! Even though you have typed into this field, don't hit 'Enter' until we have  done all of the setup fields!
- Under the "Storage & database" section, change the "Data folder" location from the default document root, to where we moved the data  folder earlier: `/var/www/sub-domains/com.yourdomain.nextcloud/data`
- Under the "Configure the database" section, change from "SQLite" to "MySQL/MariaDB" by clicking on that button.
- Type the MariaDB root user and password that you set earlier into the "Database user" and "Database password" fields
- In the "Database name" field, type "nextcloud"
- In the "localhost" field, type "localhost:3306" (3306 is the default *mariadb* connect port)

Now cross your fingers and click "Finish Setup".

The browser window will refresh for a bit and then usually not reload the site. Enter your URL in the browser window again and you should be  confronted with the default first pages. Your administrative user is  already (or should be) logged in at this point, and there are several  informational pages designed to get you up to speed.

The "Dashboard" is what users will see when they first login. The  administrative user can now create other users, install other  applications and many other tasks.

The "Nextcloud Manual.pdf" is the user manual, so that users can get  familiar with what is available. The administrative user should read  through or at least scan the high points of the admin manual [On the Nextcloud web site](https://docs.nextcloud.com/server/21/admin_manual/)

### Next Steps[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#next-steps)

At this point, don't forget that this is a server that you will be  storing company data on. It's important to get it locked down with a  firewall, get the [backups setup](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/), secure the site with an [SSL](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/), and any other duties that are required to keep your data safe.

## Conclusions[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#conclusions)

A decision to take the company cloud in house is one that needs to be evaluated carefully. For those that decide that keeping company data  locally is preferable over an external cloud host, Nextcloud is a good  alternative.

# Cloud Server Using Nextcloud[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#cloud-server-using-nextcloud)

Regarding Rocky Linux 9.x

This procedure should work for Rocky Linux 9.x. The difference is  that you may need to change version references for some of the  repositories to update those to version 9.  If you are using Rocky Linux 9.x, just be aware that this was tested in both 8.6 and 9.0, but  written originally for 8.6.

## Prerequisites And Assumptions[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#prerequisites-and-assumptions)

- Server running Rocky Linux (you can install Nextcloud on any Linux  distribution, but this procedure will assume you're using Rocky).
- A high degree of comfort operating from the command line for installation and for configuration.
- Knowledge of a command-line editor. For this example, we are using *vi*, but you can use your favorite editor if you have one.
- While Nextcloud can be installed via a snap application, we will be documenting just the .zip file installation.
- We will be applying concepts from the Apache "sites enabled" document (linked to down below) for directory setup.
- We will also be using the *mariadb-server* hardening procedure (also linked to later) for database setup.
- Throughout this document we will assume that you are root, or that you can be by using *sudo*.
- We are using an example domain of "yourdomain.com" in the configuration.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#introduction)

If you are in charge of a server environment for a large (or even a  small) company, you may be tempted by cloud applications. Doing things  in the cloud can free up your own resources for other things, but there  is a downside to this, and that is the loss of control of your company's data. If the cloud application is compromised, so too may be your  company's data.

Taking the cloud back into your own environment is a way to reclaim  security of your data at the expense of your time and energy. Sometimes, that is a cost worth paying.

Nextcloud offers an open source cloud with security and flexibility  in mind. Note that building a Nextcloud server is a good exercise, even  if you opt to take your cloud off-site in the end. The following  procedure deals with setting up Nextcloud on Rocky Linux.

## Nextcloud Install[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#nextcloud-install)

### Installing And Configuring Repositories and Modules[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#installing-and-configuring-repositories-and-modules)

For this installation, we will require two repositories. We need to  install the EPEL (Extra Packages for Enterprise Linux), and the Remi  Repository for PHP 8.0 

Note

A minimum PHP version 7.3 or 7.4 is required and the Rocky Linux  version of 7.4 does not contain all of the packages that Nextcloud  needs. We are going to use PHP 8.0 from the Remi repository instead.

To install the EPEL run:

```
dnf install epel-release
```

To install the Remi repository run (note if you are using Rocky Linux 9.x, substitute in 9 next to "release-" below):

```
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
```

Then run `dnf upgrade` again.

Run the following to see a list of php modules that can be enabled:

```
dnf module list php
```

which gives you this output for Rocky Linux 8.x (similar output will show for Rocky Linux 9.x):

```
Rocky Linux 8 - AppStream
Name                    Stream                     Profiles                                     Summary                                 
php                     7.2 [d]                    common [d], devel, minimal                   PHP scripting language                  
php                     7.3                        common [d], devel, minimal                   PHP scripting language                  
php                     7.4                        common [d], devel, minimal                   PHP scripting language               
php                     7.4                        common [d], devel, minimal                   PHP scripting language                  
Remi's Modular repository for Enterprise Linux 8 - x86_64
Name                    Stream                     Profiles                                     Summary                                 
php                     remi-7.2                   common [d], devel, minimal                   PHP scripting language                  
php                     remi-7.3                   common [d], devel, minimal                   PHP scripting language                  
php                     remi-7.4                   common [d], devel, minimal                   PHP scripting language                  
php                     remi-8.0                   common [d], devel, minimal                   PHP scripting language                  
php                     remi-8.1                   common [d], devel, minimal                   PHP scripting language                  
Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
```

We want to grab the newest PHP that Nextcloud is compatible with,  which at this moment is 8.0, so we will enable that module by doing:

```
dnf module enable php:remi-8.0
```

To see how this changes the output of the module list, run the module list command again and you will see the "[e]" next to 8.0:

```
dnf module list php
```

And the output again is the same except for this line:

```
php                    remi-8.0 [e]                   common [d], devel, minimal                  PHP scripting language
```

### Installing Packages[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#installing-packages)

Our example here uses Apache and mariadb, so to install what we need, we simply need to do the following:

```
dnf install httpd mariadb-server vim wget zip unzip libxml2 openssl php80-php php80-php-ctype php80-php-curl php80-php-gd php80-php-iconv php80-php-json php80-php-libxml php80-php-mbstring php80-php-openssl php80-php-posix php80-php-session php80-php-xml php80-php-zip php80-php-zlib php80-php-pdo php80-php-mysqlnd php80-php-intl php80-php-bcmath php80-php-gmp
```

### Configuring[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring)

#### Configuring Apache[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-apache)

Set *apache* to start on boot:

```
systemctl enable httpd
```

Then start it:

```
systemctl start httpd
```

#### Create The Configuration[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#create-the-configuration)

In the "Prerequisites and Assumptions" section, we mentioned that we will be using the [Apache Sites Enabled](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/) procedure for our configuration. Click over to that procedure and set  up the basics there, and then return to this document to continue.

For Nextcloud, we will need to create the following configuration file.

```
vi /etc/httpd/sites-available/com.yourdomain.nextcloud
```

Your configuration file should look something like this:

```
<VirtualHost *:80>
  DocumentRoot /var/www/sub-domains/com.yourdomain.nextcloud/html/
  ServerName  nextcloud.yourdomain.com
  <Directory /var/www/sub-domains/com.yourdomain.nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

Once done, save your changes (with `SHIFT:wq!` for *vi*).

Next, create a link to this file in /etc/httpd/sites-enabled:

```
ln -s /etc/httpd/sites-available/com.yourdomain.nextcloud /etc/httpd/sites-enabled/
```

#### Creating The Directory[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#creating-the-directory)

As noted in the configuration above, the *DocumentRoot* needs to be created. This can be done by:

```
mkdir -p /var/www/sub-domains/com.yourdomain.com/html
```

This is where our Nextcloud instance will be installed.

#### Configuring PHP[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-php)

We need to set the time zone for PHP. To do this, open up php.ini with your text editor of choice:

```
vi /etc/opt/remi/php80/php.ini
```

Then find the line:

```
;date.timezone =
```

We need to remove the remark (;) and set our time zone. For our example time zone, we would put in either:

```
date.timezone = "America/Chicago"
```

OR

```
date.timezone = "US/Central"
```

Then save and exit the php.ini file.

Note that for the sake of keeping things the same, your time zone in the *php.ini* file should match up to your machine's time zone setting. You can find out what this is set to by doing the following:

```
ls -al /etc/localtime
```

Which should show you something like this, assuming you set your time zone when you installed Rocky Linux and are living in the Central time  zone:

```
/etc/localtime -> /usr/share/zoneinfo/America/Chicago
```

#### Configuring mariadb-server[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-mariadb-server)

Set *mariadb-server* to start on boot:

```
systemctl enable mariadb
```

And then start it:

```
systemctl restart mariadb
```

Again, as indicated earlier, we will be using the setup procedure for hardening *mariadb-server* found [here](https://docs.rockylinux.org/zh/guides/database/database_mariadb-server/) for the initial configuration.

### Installing .zip[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#installing-zip)

The next few steps assume that you are remotely connected to your Nextcloud server via *ssh* with a remote console open:

- Navigate to the [Nextcloud web site](https://nextcloud.com/).
- Let your mouse hover over "Get Nextcloud" which will bring up a drop-down menu.
- Click on "Server Packages".
- Right-click on "Download Nextcloud" and copy the link address (the exact syntax of this is different browser to browser).
- In your remote console on the Nextcloud server, type "wget" and then a space and paste in what you just copied. You should get something  like the following: `wget https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip` (note that the version could be different).
- Once you hit enter, the download of the .zip file will start and will be completed fairly quickly.

Once the download is complete, unzip the Nextcloud zip file by using the following:

```
unzip nextcloud-21.0.1.zip
```

### Copying Content And Changing Permissions[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#copying-content-and-changing-permissions)

After completing the unzip step, you should now have a new directory in /root called "nextcloud." Change into this directory:

```
cd nextcloud
```

And either copy or move the content to our *DocumentRoot*:

```
cp -Rf * /var/www/sub-domains/com.yourdomain.nextcloud/html/
```

OR

```
mv * /var/www/sub-domains/com.yourdomain.nextcloud/html/
```

Now that everything is where it should be, the next step is to make sure that apache owns the directory. To do this, run:

```
chown -Rf apache.apache /var/www/sub-domains/com.yourdomain.nextcloud/html
```

For security reasons, we also want to move the "data" folder from inside to outside of the *DocumentRoot*. Do this with the following command:

```
mv /var/www/sub-domains/com.yourdomain.nextcloud/html/data /var/www/sub-domains/com.yourdomain.nextcloud/
```

### Configuring Nextcloud[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#configuring-nextcloud)

Now comes the fun! First, make sure that you have your services  running. If you followed the above steps, they should already be  running. We have had several steps between those initial service starts, so let's go ahead and restart them, just to be sure:

```
systemctl restart httpd
systemctl restart mariadb
```

If everything restarts and there are no issues, then you are ready to move on.

To do the initial configuration, we want to actually load the site in a web browser:

```
http://nextcloud.yourdomain.com/
```

Assuming that you've done everything correctly so far, you should be presented with a Nextcloud setup screen:

![nextcloud login screen](https://docs.rockylinux.org/zh/guides/images/nextcloud_screen.jpg)

There are a couple of things that we want to do differently than the defaults that show up:

- At the top of the web page, where it says "Create an admin account", set the user and password. For the sake of this document, we are  entering "admin" and setting a strong password. Remember to save this  somewhere safe (like a password manager) so that you don't lose it! Even though you have typed into this field, don't hit 'Enter' until we have  done all of the setup fields!
- Under the "Storage & database" section, change the "Data folder" location from the default document root, to where we moved the data  folder earlier: `/var/www/sub-domains/com.yourdomain.nextcloud/data`.
- Under the "Configure the database" section, change from "SQLite" to "MySQL/MariaDB" by clicking on that button.
- Type the MariaDB root user and password that you set earlier into the "Database user" and "Database password" fields.
- In the "Database name" field, type "nextcloud".
- In the "localhost" field, type "localhost:3306" (3306 is the default *mariadb* connect port).

Once you have all this, click `Finish Setup` and you should be up and running.

The browser window will refresh for a bit and then usually not reload the site. Enter your URL in the browser window again and you should be  confronted with the default first pages.

Your administrative user is already (or should be) logged in at this  point, and there are several informational pages designed to get you up  to speed. The "Dashboard" is what users will see when they first login.  The administrative user can now create other users, install other  applications and many other tasks.

The "Nextcloud Manual.pdf" file is the user manual, so that users can get familiar with what is available. The administrative user should  read through or at least scan the high points of the admin manual [On the Nextcloud web site](https://docs.nextcloud.com/server/21/admin_manual/)

## Next Steps[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#next-steps)

At this point, don't forget that this is a server that you will be  storing company data on. It's important to get it locked down with a  firewall, get the [backup set up](https://docs.rockylinux.org/zh/guides/backup/rsnapshot_backup/), secure the site with an [SSL](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/), and any other duties that are required to keep your data safe.

## Conclusions[¶](https://docs.rockylinux.org/zh/guides/cms/cloud_server_using_nextcloud/#conclusions)

A decision to take the company cloud in house is one that needs to be evaluated carefully. For those that decide that keeping company data  locally is preferable over an external cloud host, Nextcloud is a good  alternative.

# Running Nextcloud as a Podman Container on Rocky Linux[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#running-nextcloud-as-a-podman-container-on-rocky-linux)

## Introduction[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#introduction)

This document explains all the required steps needed to build and run a [Nextcloud](https://nextcloud.com) instance as a Podman container on Rocky Linux. What's more, this entire guide was tested on a Raspberry Pi, so it should be compatible with  every Rocky-supported processor architecture.

The procedure is broken down into multiple steps, each with its own shell scripts for automation:

1. Installing the `podman` and `buildah` packages to manage and build our containers, respectively
2. Creating a base image which will be repurposed for all of the containers we'll need
3. Creating a `db-tools` container image with the required shell scripts for building and running your MariaDB database
4. Creating and running MariaDB as a Podman container
5. Creating and running Nextcloud as a Podman container, using the MariaDB Podman container as backend

You could run most of the commands in the guide manually, but setting up a few bash scripts will make your life a lot easier, especially when you want to repeat these steps with different settings, variables, or  container names.

Note for Beginners:

Podman is tool for managing containers, specifically OCI (Open  Containers Initiative) containers. It's designed to be pretty much  Docker-compatible, in that most if not all of the same commands will  work for both tools. If "Docker" means nothing to you—or even if you're  just curious—you can read more about Podman and how it works on [Podman's own website](https://podman.io).

`buildah` is a tool that builds Podman container images based on "DockerFiles".

This guide was designed as an exercise to help people get familiar  with running Podman containers in general, and on Rocky Linux  specifically.

## Prerequisites and Assumptions[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#prerequisites-and-assumptions)

Here's everything you'll need, or need to know, in order to make this guide work:

- Familiarity with the command line, bash scripts, and editing Linux configuration files.
- SSH access if working on a remote machine.
- A command-line based text editor of your choice. We'll be using `vi` for this guide. 
- An internet-connected Rocky Linux machine (again, a Raspberry Pi will work nicely).
- Many of these commands must be run as root, so you'll need a root or sudo-capable user on the machine.
- Familiarity with web servers and MariaDB would definitely help.
- Familiarity with containers and maybe Docker would be a *definite* plus, but is not strictly essential.

## Step 01: Install `podman` and `buildah`[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#step-01-install-podman-and-buildah)

First, make sure your system is up-to-date:

```
dnf update
```

Then you'll want to install the `epel-release` repository for all the extra packages we'll be using.

```
dnf -y install epel-release 
```

Once that's done, you can update again (which sometimes helps) or just go ahead and install the packages we need:

```
dnf -y install podman buildah
```

Once they're installed, run `podman --version` and `buildah --version` to make sure everything is working correctly.

To access Red Hat's registry for downloading container images, you'll need to run:

```
vi /etc/containers/registries.conf
```

Find the section that looks like what you see below. If it's commented out, uncomment it.

```
[registries.insecure]
registries = ['registry.access.redhat.com', 'registry.redhat.io', 'docker.io'] 
insecure = true
```

## Step 02: Create the `base` Container Image[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#step-02-create-the-base-container-image)

In this guide, we're working as the root user, but you can do this in any home directory. Change to the root directory if you're not already  there:

```
cd /root
```

Now make all of the directories you'll need for your various container builds:

```
mkdir base db-tools mariadb nextcloud
```

Now change your working directory to the folder for the base image:

```
cd /root/base
```

And make a file called DockerFile. Yes, Podman uses them too.

```
vi Dockerfile
```

Copy and paste the following text into your brand new DockerFile.

```
FROM rockylinux/rockylinux:latest
ENV container docker
RUN yum -y install epel-release ; yum -y update
RUN dnf module enable -y php:7.4
RUN dnf install -y php
RUN yum install -y bzip2 unzip lsof wget traceroute nmap tcpdump bridge-utils ; yum -y update
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```

Save and close the previous file, and make a new bash script file: 

```
vi build.sh
```

Then paste in this content:

```
#!/bin/bash
clear
buildah rmi `buildah images -q base` ;
buildah bud --no-cache -t base . ;
buildah images -a
```

Now make your build script executable with:

```
chmod +x build.sh
```

And run it:

```
./build.sh
```

Wait until it's done, and move on to the next step.

## Step 03: Create the `db-tools` Container Image[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#step-03-create-the-db-tools-container-image)

For the purposes of this guide, we're keeping the database setup as  simple as we can. You'll want to keep track of the following, and modify them as needed:

- Database name: ncdb
- Database user: nc-user
- Database pass: nc-pass
- Your server IP address (we'll be using an example IP below)

First, change to the folder where you'll be building the db-tools image:

```
cd /root/db-tools
```

Now set up some bash scripts that will be used inside the Podman  container image. First, make the script that will automatically build  your database for you: 

```
vi db-create.sh
```

Now copy and paste the following code into that file, using your favorite text editor:

```
#!/bin/bash
mysql -h 10.1.1.160 -u root -p rockylinux << eof
create database ncdb;
grant all on ncdb.* to 'nc-user'@'10.1.1.160' identified by 'nc-pass';
flush privileges;
eof
```

Save and close, then repeat the steps with the script for deleting databases as needed:

```
vi db-drop.sh
```

Copy and paste this code into the new file:

```
#!/bin/bash
mysql -h 10.1.1.160 -u root -p rockylinux << eof
drop database ncdb;
flush privileges;
eof
```

Lastly, let's setup the DockerFile for the `db-tools` image:

```
vi Dockerfile
```

Copy and paste:

```
FROM localhost/base
RUN yum -y install mysql
WORKDIR /root
COPY db-drop.sh db-drop.sh
COPY db-create.sh db-create.sh
```

And last but not least, create the bash script to build your image on command:

```
vi build.sh
```

The code you'll want:

```
#!/bin/bash
clear
buildah rmi `buildah images -q db-tools` ;
buildah bud --no-cache -t db-tools . ;
buildah images -a
```

Save and close, then make the file executable:

```
chmod +x build.sh
```

And run it:

```
./build.sh
```

## Step 04: Create the MariaDB container image[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#step-04-create-the-mariadb-container-image)

You're getting the hang of the process, right? It's time to build  that actual database container. Change the working directory to `/root/mariadb`:

```
cd /root/mariadb
```

Make a script to (re)build the container whenever you want:

```
vi db-init.sh
```

And here's the code you'll need:

Warning

For the purposes of this guide, the following script will delete all  Podman Volumes. If you have other applications running with their own  volumes, modify/comment the line "podman volume rm --all";

```
#!/bin/bash
clear
echo " "
echo "Deleting existing volumes if any...."
podman volume rm --all ;
echo " "
echo "Starting mariadb container....."
podman run --name mariadb --label mariadb -d --net host -e MYSQL_ROOT_PASSWORD=rockylinux -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v mariadb-data:/var/lib/mysql/data:Z mariadb ;

echo " "
echo "Initializing mariadb (takes 2 minutes)....."
sleep 120 ;

echo " "
echo "Creating ncdb Database for nextcloud ....."
podman run --rm --net host db-tools /root/db-create.sh ;

echo " "
echo "Listing podman volumes...."
podman volume ls
```

Here's where you make a script to reset your database whenever you like:

```
vi db-reset.sh
```

And here's the code:

```
#!/bin/bash
clear
echo " "
echo "Deleting ncdb Database for nextcloud ....."
podman run --rm --net host db-tools /root/db-drop.sh ;

echo " "
echo "Creating ncdb Database for nextcloud ....."
podman run --rm --net host db-tools /root/db-create.sh ;
```

And lastly, here's your build script that'll put the whole mariadb container together:

```
vi build.sh
```

With its code:

```
#!/bin/bash
clear
buildah rmi `buildah images -q mariadb` ;
buildah bud --no-cache -t mariadb . ;
buildah images -a
```

Now just make your DockferFile (`vi Dockerfile`), and paste in the following single line:

```
FROM arm64v8/mariadb
```

Now make your build script executable and run it:

```
chmod +x *.sh

./build.sh
```

## Step 05: Build and Run the Nextcloud Container[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#step-05-build-and-run-the-nextcloud-container)

We're at the final step, and the process pretty much repeats itself. Change to the Nextcloud image directory:

```
cd /root/nextcloud
```

Set up your DockerFile first this time, for variety:

```
vi Dockerfile
```

Note

This next bit assumes ARM architecture (for the Raspberry Pi), so if  you are using another architecture, remember to change this. 

And paste in this bit:

```
FROM arm64v8/nextcloud
```

Npw create your build script:

```
vi build.sh
```

And paste in this code:

```
#!/bin/bash
clear
buildah rmi `buildah images -q nextcloud` ;
buildah bud --no-cache -t nextcloud . ;
buildah images -a
```

Now, we're going to set up a bunch of local folders on the host server (*not* in any Podman container), so that we can rebuild our containers and databases without fear of losing all of our files:

```
mkdir -p /usr/local/nc/nextcloud /usr/local/nc/apps /usr/local/nc/config /usr/local/nc/data
```

Lastly, we're going to create the script that will actually build the Nextcloud container for us:

```
vi run.sh
```

And here's all the code you need for that. Make sure you change the IP address for `MYSQL_HOST` to the docker container that's running your MariaDB instance.

```
#!/bin/bash
clear
echo " "
echo "Starting nextloud container....."
podman run --name nextcloud --net host --privileged -d -p 80:80 \
-e MYSQL_HOST=10.1.1.160 \
-e MYSQL_DATABASE=ncdb \
-e MYSQL_USER=nc-user \
-e MYSQL_PASSWORD=nc-pass \
-e NEXTCLOUD_ADMIN_USER=admin \
-e NEXTCLOUD_ADMIN_PASSWORD=rockylinux \
-e NEXTCLOUD_DATA_DIR=/var/www/html/data \
-e NEXTCLOUD_TRUSTED_DOMAINS=10.1.1.160 \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-v /usr/local/nc/nextcloud:/var/www/html \
-v /usr/local/nc/apps:/var/www/html/custom_apps \
-v /usr/local/nc/config:/var/www/html/config \
-v /usr/local/nc/data:/var/www/html/data \
nextcloud ;
```

Save and close that out, make all of your scripts executable, then run the image building script first: 

```
chmod +x *.sh

./build.sh
```

To make sure all of your images have been built correctly, run `podman images`. You should see a list that looks like this:

```
REPOSITORY                      TAG    IMAGE ID     CREATED      SIZE
localhost/db-tools              latest 8f7ccb04ecab 6 days ago   557 MB
localhost/base                  latest 03ae68ad2271 6 days ago   465 MB
docker.io/arm64v8/mariadb       latest 89a126188478 11 days ago  405 MB
docker.io/arm64v8/nextcloud     latest 579a44c1dc98 3 weeks ago  945 MB
```

If it all looks right, run the final script to get Nextcloud up and going:

```
./run.sh
```

When you run `podman ps -a`, you should see a list of running containers that looks like this:

```
CONTAINER ID IMAGE                              COMMAND              CREATED        STATUS            PORTS    NAMES
9518756a259a docker.io/arm64v8/mariadb:latest   mariadbd             3 minutes  ago Up 3 minutes ago           mariadb
32534e5a5890 docker.io/arm64v8/nextcloud:latest apache2-foregroun... 12 seconds ago Up 12 seconds ago          nextcloud
```

From there, you should be able to point your browser to your server  IP address. If you are following along and have the same IP as our  example, you can substitute that in here (e.g., http://your-server-ip)  and see Nextcloud up and running.

## Conclusion[¶](https://docs.rockylinux.org/guides/containers/podman-nextcloud/#conclusion)

Obviously, this guide would have to be somewhat modified on a  production server, especially if the Nextcloud instance is intended to  be public-facing. Still, that should give you a basic idea of how Podman works, and how you can set it up with scripts and multiple base images  to make rebuilds easier.