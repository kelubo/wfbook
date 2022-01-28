# DokuWiki
## 需求
    PHP 5.3.4 或更高版本（建议使用 PHP 7+）
    一台 web 服务器（Apache/Nginx/任何其他）
## 安装
1.升级系统

    sudo apt-get update && sudo apt-get upgrade
2.安装 Apache

    apt-get install apache2
3.安装 PHP7 和模块

    apt-get install php7.0-fpm php7.0-cli php-apcu php7.0-gd php7.0-xml php7.0-curl php7.0-json php7.0-mcrypt php7.0-cgi php7.0 libapache2-mod-php7.0

4.下载安装 DokuWiki  
创建一个目录：

    mkdir -p /var/www/thrwiki

进入刚才创建的目录：

    cd /var/www/thrwiki

运行下面的命令来下载最新（稳定）的 DokuWiki：

    wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz

解压 .tgz 文件：

    tar xvf dokuwiki-stable.tgz

更改文件/文件夹权限：

    www-data:www-data -R /var/www/thrwiki
    chmod -R 707 /var/www/thrwiki

为 DokuWiki 配置 Apache

为你的 DokuWiki 创建一个 .conf 文件（我们把它命名为 thrwiki.conf，但是你可以把它命名成任何你想要的），并用你喜欢的文本编辑器打开。我们使用 nano：

    touch /etc/apache2/sites-available/thrwiki.conf
    ln -s /etc/apache2/sites-available/thrwiki.conf /etc/apache2/sites-enabled/thrwiki.conf
    nano /etc/apache2/sites-available/thrwiki.conf

下面是 thrwiki.conf 中的内容：

    <VirtualHost yourServerIP:80>
      ServerAdmin wikiadmin@thishosting.rocks
      DocumentRoot /var/www/thrwiki/
      ServerName wiki.thishosting.rocks
      ServerAlias www.wiki.thishosting.rocks
      <Directory /var/www/thrwiki/>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>
      ErrorLog /var/log/apache2/wiki.thishosting.rocks-error_log
      CustomLog /var/log/apache2/wiki.thishosting.rocks-access_log common
    </VirtualHost>

编辑与你服务器相关的行。将 wikiadmin@thishosting.rocks、wiki.thishosting.rocks 替换成你自己的数据，重启 apache 使更改生效：

    systemctl restart apache2.service

就是这样了。现在已经配置完成了。现在你可以继续通过前端页面 http://wiki.thishosting.rocks/install.php 安装配置 DokuWiki 了。安装完成后，你可以用下面的命令删除 install.php：

    rm -f /var/www/html/thrwiki/install.php





Documentation can take many forms in an organization. Having a  repository that you can reference for that documentation is invaluable. A wiki (which means *quick* in Hawaiian), is a way to keep  documentation, process notes, corporate knowledge bases, and even code  examples, in a centralized location. IT professionals who maintain a  wiki, even secretly, have a built-in insurance policy against forgetting an obscure routine. 

DokuWiki is a mature, fast, wiki that runs without a database, has  built in security features, and is relatively easy to deploy. For more  information on what DokuWiki can do, check out their [web page](https://www.dokuwiki.org/dokuwiki). 

DokuWiki is just one of many wiki's available, though it's a pretty  good one. One big pro is that DokuWiki is relatively lightweight and can run on a server that is already running other services, provided you  have space and memory available.

# Installation[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#installation)

## Installing Dependencies[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#installing-dependencies)

The minimum PHP version for DokuWiki is now 7.2, which is exactly  what Rocky Linux 8 comes with. We are specifying packages here that may  already be installed:

```
dnf install tar wget httpd php php-gd php-xml php-json php-mbstring
```

You will see a list of additional dependencies that will be installed and this prompt:

```
Is this ok [y/N]:
```

Go ahead and answer with "y" and hit 'Enter' to install.

## Create Directories And Modify Configuration[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#create-directories-and-modify-configuration)

### Apache Configuration[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#apache-configuration)

If you have read through the [Apache Sites Enabled](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/) procedure, you know that we need to create a few directories. We will start with the *httpd* configuration directory additions:

```
mkdir -p /etc/httpd/{sites-available,sites-enabled}
```

We need to edit the httpd.conf file:

```
vi /etc/httpd/conf/httpd.conf
```

And add this to the very bottom of the file:

```
Include /etc/httpd/sites-enabled
```

Create the site configuration file in sites-available:

```
vi /etc/httpd/sites-available/com.yourdomain.wiki-doc
```

That configuration file should look something like this:

```
<VirtualHost *>
    ServerName    wiki-doc.yourdomain.com
    DocumentRoot  /var/www/sub-domains/com.yourdomain.wiki-doc/html

    <Directory ~ "/var/www/sub-domains/com.yourdomain.wiki-doc/html/(bin/|conf/|data/|inc/)">
        <IfModule mod_authz_core.c>
                AllowOverride All
            Require all denied
        </IfModule>
        <IfModule !mod_authz_core.c>
            Order allow,deny
            Deny from all
        </IfModule>
    </Directory>

    ErrorLog   /var/log/httpd/wiki-doc.yourdomain.com_error.log
    CustomLog  /var/log/httpd/wiki-doc.yourdomain_access.log combined
</VirtualHost>
```

Note that the "AllowOverride All" above, allows the .htaccess (directory specific security) file to work.

Go ahead an link the configuration file into sites-enabled, but don't start web services as yet:

```
ln -s /etc/httpd/sites-available/com.yourdomain.wiki-doc /etc/httpd/sites-enabled/
```

### Apache DocumentRoot[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#apache-documentroot)

We also need to create our *DocumentRoot*. To do this:

```
mkdir -p /var/www/sub-domains/com.yourdomain.wiki-doc/html
```

## Installing DokuWiki[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#installing-dokuwiki)

In your server, change to the root directory.

```
cd /root
```

Now that we have our environment ready to go, let's  get the latest stable version of DokuWiki. You can find this by going to [the download page](https://download.dokuwiki.org/) and on the left-hand side of the page under "Version" you will see "Stable (Recommended) (direct link)." 

Right-click on the "(direct link)" portion of this and copy the link  address. In the console of your DokuWiki server, type "wget" and a space and then paste in your copied link in the terminal. You should get  something like this:

```
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
```

Before we decompress the archive, take a look at the contents using `tar ztf` to see the contents of the archive:

```
tar ztv dokuwiki-stable.tgz
```

Notice the named dated directory ahead of all the other files that looks something like this?



```
... (more above)
dokuwiki-2020-07-29/inc/lang/fr/resetpwd.txt
dokuwiki-2020-07-29/inc/lang/fr/draft.txt
dokuwiki-2020-07-29/inc/lang/fr/recent.txt
... (more below)
```

We don't want that leading named directory when we decompress the  archive, so we are going to use some options with tar to exclude it. The first option is the "--strip-components=1" which removes that leading  directory. 



The second option is the "-C" option, and that tells tar where we  want the archive to be decompressed to. So decompress the archive with  this command:

```
tar xzf dokuwiki-stable.tgz  --strip-components=1 -C /var/www/sub-domains/com.yourdomain.wiki-doc/html/
```

Once we have executed this command, all of DokuWiki should be in our *DocumentRoot*.

We need to make a copy of the *.htaccess.dist* file that came with DokuWiki and keep the old one there too, in case we need to revert to the original in the future. 

In the process, we will be changing the name of this file to simply *.htaccess* which is what *apache* will be looking for. To do this:

```
cp /var/www/sub-domains/com.yourdomain.wiki-doc/html/.htaccess{.dist,}
```

Now we need to change ownership of the new directory and its files to the *apache* user and group:

```
chown -Rf apache.apache /var/www/sub-domains/com.yourdomain.wiki-doc/html
```

## Setting Up DNS Or /etc/hosts[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#setting-up-dns-or-etchosts)

Before you'll be able to access the DokuWiki interface, you'll need  to set name resolution for this site. For testing purposes, you can use  your */etc/hosts* file. 

In this example, let's assume that DokuWiki will be running on a  private IPv4 address of 10.56.233.179. Let's also assume that you are  modifying the */etc/hosts* file on a Linux workstation. To do this, run:

```
sudo vi /etc/hosts
```

And then modify your hosts file to look something like this (note the IP address above in the below example):

```
127.0.0.1   localhost
127.0.1.1   myworkstation-home
10.56.233.179   wiki-doc.yourdomain.com     wiki-doc

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Once you have finished testing and are ready to take things live for  everyone, you will need to add this host to a DNS server. You could do  this by using a [Private DNS Server](https://docs.rockylinux.org/zh/guides/dns/private_dns_server_using_bind/), or a public-facing DNS server.

## Starting httpd[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#starting-httpd)

Before we start *httpd* let's test to make sure that our configuration is OK:

```
httpd -t
```

You should get:

```
Syntax OK
```

If so, you should be ready to start *httpd* and then finish the setup. Let's start by enabling *httpd* to start on boot:

```
systemctl enable httpd
```

And then start it:

```
systemctl start httpd
```

## Testing DokuWiki[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#testing-dokuwiki)

Now that our host name is set for testing and the web service has  been started, the next step is to open up a web browser and type this in the address bar:

```
http://wiki-doc/install.php
```

OR

```
http://wiki-doc.yourdomain.com/install.php
```

Either should work if you set your hosts file as above. This will  bring you to the setup screen so that you can finish the setup:

- In the "Wiki Name" field, type the name for our wiki. Example "Technical Documentation"
- In the "Superuser" field, type the administrative username. Example "admin"
- In the "Real name" field, type the real name for the administrative user.
- In the "E-Mail" field, type the email address of the administrative user.
- In the "Password" field, type the secure password for the administrative user.
- In the "once again" field, re-type that same password.
- In the "Initial ACL Policy" drop down, choose the option that works best for your environment.
- Choose the appropriate check box for the license you want to put your content under.
- Leave checked or uncheck the "Once a month, send anonymous usage data to the DokuWiki developers" checkbox
- Click the "Save" button

Your wiki is now ready for you to add content.

# Securing DokuWiki[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#securing-dokuwiki)

Besides the ACL policy that you just created, consider:

## Your Firewall[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#your-firewall)

Before you call everything done, you need to think about security.  First, you should be running a firewall on the server. We will assume  that you are using *iptables* and have [Enabled *iptables*](https://docs.rockylinux.org/zh/guides/security/enabling_iptables_firewall/), but if you want to use *firewalld* instead, simply modify your *firewalld* rules accordingly. 

Instead of everyone having access to the wiki, we are going to assume that anyone on the 10.0.0.0/8 network is on your private Local Area  Network, and that those are the only people who need access to the site. A simple *iptables* firewall script for this is down below. 

Please note that you may need other rules for other services on this  server, and that this example only takes into account the web services.

First, modify or create the */etc/firewall.conf* file:

```
vi /etc/firewall.conf
#IPTABLES=/usr/sbin/iptables

#  Unless specified, the defaults for OUTPUT is ACCEPT
#    The default for FORWARD and INPUT is DROP
#
echo "   clearing any existing rules and setting default policy.."
iptables -F INPUT
iptables -P INPUT DROP
# web ports
iptables -A INPUT -p tcp -m tcp -s 10.0.0.0/8 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -s 10.0.0.0/8 --dport 443 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable

/usr/sbin/service iptables save
```

Once the script is created, make sure it is executable:

```
chmod +x /etc/firewall.conf
```

Then execute the script:

```
/etc/firewall.conf
```

This will execute the rules and save them so that they will be reloaded on the next start of *iptables* or on boot.

## SSL[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#ssl)

For the best security, you should consider using an SSL so that all  web traffic is encrypted. You can purchase an SSL from an SSL provider  or use [Let's Encrypt](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/)

# Conclusion[¶](https://docs.rockylinux.org/zh/guides/cms/dokuwiki_server/#conclusion)

Whether you need to document processes, company policies, program  code, or something else, a wiki is a great way to get that done.  DokuWiki is a product that is secure, flexible, easy to use, relatively  easy to install and deploy, and is a stable project that has been around for many years.  
