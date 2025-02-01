# Generating SSL Keys - Let's Encrypt[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#generating-ssl-keys-lets-encrypt)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#prerequisites)

- Comfort with the command line
- Familiarity with securing web sites with SSL certificates is a plus
- Knowledge of command line text editors (this example uses *vi*)
- An already running web server open to the world on port 80 (http)
- Familiarity with *ssh* (secure shell) and the ability to access your server with *ssh*

# Introduction[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#introduction)

One of the most popular ways to secure a web site, currently, is using Let's Encrypt SSL certificates, which are also free. 

These are actual certificates, not self-signed or snake oil, etc., so they are great for a low-budget security solution. This document will  walk you through the process of installing and using Let's Encrypt  certificates on a Rocky Linux web server.

## Assumptions[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#assumptions)

- All commands assume that you are either the root user or that you have used *sudo* to gain root access.

## Installation[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#installation)

To do the next steps, use *ssh* to log into your server. If your server's fully qualified DNS name was www.myhost.com, then you would use:

```
ssh -l root www.myhost.com
```

Or, if you must access your server as an unprivileged user first. Use your username:

```
ssh -l username www.myhost.com
```

And then:

```
sudo -s
```

You will need your *sudo* user's credentials in this case to gain access to the system as root.

Let's Encrypt uses a package called *certbot* which needs to be installed via a snap package. To install *snapd* on Rocky Linux, you will need to install the EPEL repository if you have not done so already:

```
dnf install epel-release
```

Besides *snapd* you may also need *fuse* and *squashfuse* depending on your system. We also need to make sure that *mod_ssl* is installed. To install them all use:

```
dnf install snapd fuse squashfuse mod_ssl
```

*snapd* requires a bunch of dependencies that will install along with it, so answer yes to the installation prompt.

Once *snapd*  and all of the dependencies are installed, enable the *snapd* service with:

```
systemctl enable --now snapd.socket
```

*certbot* requires classic *snapd* support, so we need to enable that with a symbolic link: 

```
ln -s /var/lib/snapd/snap /snap
```

Before continuing on, we want to make sure that all of the snap packages are up to date. To do this use: 

```
snap install core; snap refresh core
```

If there are any updates, they will install here.

Just in case you got ahead of yourself and installed *certbot* from the RPM (which will not work, by the way), make sure that you remove it with: 

```
dnf remove certbot
```

And finally, it's time to install *certbot* with:

```
snap install --classic certbot
```

This should install *certbot*. The final step is to put the *certbot* command in a path that Rocky Linux can find easily. This is done with another symbolic link:

```
ln -s /snap/bin/certbot /usr/bin/certbot
```

## Getting The Let's Encrypt Certificate[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#getting-the-lets-encrypt-certificate)

There are two ways to retrieve your Let's Encrypt certificate, either using the command to modify the http configuration file for you, or to  just retrieve the certificate. If you are using the procedure for a  multi-site setup suggested for one or more sites in the procedure [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/), then you will only want to retrieve your certificate. 

We are assuming that you **are** using this procedure so we will only retrieve the certificate. If you are running a standalone  web server using the default configuration, you can retrieve the  certificate and modify the configuration file in one step using `certbot --apache`. 

To retrieve the certificate only, use this command:

```
certbot certonly --apache
```

This will generate a set of prompts that you will need to answer. The first is to give an email address for important information:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator apache, Installer apache
Enter email address (used for urgent renewal and security notices)
 (Enter 'c' to cancel): yourusername@youremaildomain.com
```

The next asks you to read and accept the terms of the subscriber  agreement. Once you have read the agreement answer 'Y' to continue:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
agree in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: 
```

The next is a request to share your email with the Electronic Frontier Foundation. Answer 'Y' or 'N' as is your preference:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: 
```

The next prompt asks you which domain you want the certificate for.  It should display a domain in the listing based on your running web  server. If so, enter the number next to the domain that you are getting  the certificate for. In this case there is only one option ('1'):

```
Which names would you like to activate HTTPS for?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: yourdomain.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate numbers separated by commas and/or spaces, or leave input
blank to select all options shown (Enter 'c' to cancel): 
```

If all goes well, you should receive the following message:

```
Requesting a certificate for yourdomain.com
Performing the following challenges:
http-01 challenge for yourdomain.com
Waiting for verification...
Cleaning up challenges
Subscribe to the EFF mailing list (email: yourusername@youremaildomain.com).

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/yourdomain.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/yourdomain.com/privkey.pem
   Your certificate will expire on 2021-07-01. To obtain a new or
   tweaked version of this certificate in the future, simply run
   certbot again. To non-interactively renew *all* of your
   certificates, run "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

## The Site Configuration - https[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#the-site-configuration-https)

Applying the configuration file to our site is slightly different  than if we were using a purchased SSL certificate from another provider. 

The certificate and chain file are included in a single PEM (Privacy  Enhanced Mail) file. This is a common format for all certificate files  now, so even though it has "Mail" in the reference, it is just a type of certificate file. To illustrate the configuration file, we will show it in it's entirety and then describe what is happening:

```
<VirtualHost *:80>
        ServerName www.yourdomain.com 
        ServerAdmin username@rockylinux.org
        Redirect / https://www.yourdomain.com/
</VirtualHost>
<Virtual Host *:443>
        ServerName www.yourdomain.com 
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.yourdomain.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.yourdomain.www/cgi-bin/

    CustomLog "/var/log/httpd/com.yourdomain.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.yourdomain.www-error_log"

        SSLEngine on
        SSLProtocol all -SSLv2 -SSLv3 -TLSv1
        SSLHonorCipherOrder on
        SSLCipherSuite EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384
:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

        SSLCertificateFile /etc/letsencrypt/live/yourdomain.com/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/yourdomain.com/privkey.pem
        SSLCertificateChainFile /etc/letsencrypt/live/yourdomain.com/fullchain.pem

        <Directory /var/www/sub-domains/com.yourdomain.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

Here's what's happening above. You may want to review the [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/) to see the differences in the application of an SSL purchased from another provider and the Let's Encrypt certificate:

- Even though port 80 (standard http) is listening, we are redirecting all traffic to port 443 (https)
- SSLEngine on - simply says to use SSL
- SSLProtocol all -SSLv2 -SSLv3 -TLSv1 - says to use all available  protocols, except those that have been found to have vulnerabilities.  You should research periodically which protocols are currently  acceptable for use.
- SSLHonorCipherOrder on - this deals with the next line that  regarding the cipher suites, and says to deal with them in the order  that they are given. This is another area where you should review the  cipher suites that you want to include periodically
- SSLCertificateFile - this is the PEM file, that contains the site certificate **AND** the intermediate certificate. We still need the  'SSLCertificateChainFile' line in our configuration, but it will simply  specify the same PEM file again.
- SSLCertificateKeyFile - the PEM file for the private key, generated with the *certbot* request.
- SSLCertificateChainFile - the certificate from your certificate  provider, often called the intermediate certificate, in this case  exactly like the 'SSLCertificateFile' location above.

Once you have made all of your changes, simply restart *httpd* and if it starts test your site to make sure you now have a valid  certificate file showing. If so, you are ready to move on to the next  step.

## Automating Let's Encrypt Certificate Renewal[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#automating-lets-encrypt-certificate-renewal)

The beauty of installing *certbot* is that the Let's Encrypt  certificate will be automatically renewed. There is no need to create a  process to do this. We do need to test the renewal with:

```
certbot renew --dry-run
```

When you run this command, you'll get a nice output showing the renewal process:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Processing /etc/letsencrypt/renewal/yourdomain.com.conf
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Cert not due for renewal, but simulating renewal for dry run
Plugins selected: Authenticator apache, Installer apache
Account registered.
Simulating renewal of an existing certificate for yourdomain.com
Performing the following challenges:
http-01 challenge for yourdomain.com
Waiting for verification...
Cleaning up challenges

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
new certificate deployed with reload of apache server; fullchain is
/etc/letsencrypt/live/yourdomain.com/fullchain.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations, all simulated renewals succeeded: 
  /etc/letsencrypt/live/yourdomain.com/fullchain.pem (success)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

The [*certbot* documentation](https://certbot.eff.org/lets-encrypt/centosrhel8-apache.html) tells you in their step number 8, that the automatic renewal process  could be in a couple of different spots, depending on your system. For a Rocky Linux install, you are going to find the process by using:

```
systemctl list-timers
```

Which gives you a list of processes, one of which will be for *certbot*:

```
Sat 2021-04-03 07:12:00 UTC  14h left   n/a                          n/a          snap.certbot.renew.timer     snap.certbot.renew.service
```

# Conclusions[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#conclusions)

Let's Encrypt SSL certificates are yet another option for securing  your web site with an SSL. Once installed, the system provides automatic renewal of certificates and will encrypt traffic to your web site. 

It should be noted that Let's Encrypt certificates are used for  standard DV (Domain Validation) certificates. They cannot be used for OV (Organization Validation) or EV (Extended Validation) certificates. 



# Generating SSL Keys - Let's Encrypt[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#generating-ssl-keys-lets-encrypt)

## Prerequisites & Assumptions[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#prerequisites-assumptions)

- Comfort with the command line
- Familiarity with securing web sites with SSL certificates is a plus
- Knowledge of command line text editors (this example uses *vi*)
- An already running web server open to the world on port 80 (http)
- Familiarity with *ssh* (secure shell) and the ability to access your server with *ssh*
- All commands assume that you are either the root user or that you have used *sudo* to gain root access.

## Introduction[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#introduction)

One of the most popular ways to secure a web site, currently, is using Let's Encrypt SSL certificates, which are also free.

These are actual certificates, not self-signed or snake oil, etc., so they are great for a low-budget security solution. This document will  walk you through the process of installing and using Let's Encrypt  certificates on a Rocky Linux web server.

## Installation[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#installation)

To do the next steps, use *ssh* to log into your server. If your server's fully qualified DNS name was www.myhost.com, then you would use:

```
ssh -l root www.myhost.com
```

Or, if you must access your server as an unprivileged user first. Use your username:

```
ssh -l username www.myhost.com
```

And then:

```
sudo -s
```

You will need your *sudo* user's credentials in this case to gain access to the system as root.

Let's Encrypt uses a package called *certbot* which needs to be installed via the EPEL repositories. Add those first:

```
dnf install epel-release
```

Then, just install the appropriate packages, depending on whether  you're using Apache or Nginx as your web server. For Apache that's:

```
dnf install certbot python3-certbot-apache
```

For Nginx, just change out one... partial word?

```
dnf install certbot python3-certbot-nginx
```

You can always install both server modules if necessary, of course.

Note

An earlier version of this guide required the snap package version of *certbot*, as it was found to be necessary at the time. The RPM versions have been re-tested recently, and are working now. That said, Certbot strongly  recommends the use of the [snap install procedure](https://certbot.eff.org/instructions?ws=apache&os=centosrhel8). Both Rocky Linux 8 and 9 have *certbot* available in the EPEL, so we are showing thatt procedure here. If you  would like to use the procedure recommended by Certbot, just follow that procedure instead.

## Getting The Let's Encrypt Certificate for the Apache Server[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#getting-the-lets-encrypt-certificate-for-the-apache-server)

There are two ways to retrieve your Let's Encrypt certificate, either using the command to modify the http configuration file for you, or to  just retrieve the certificate. If you are using the procedure for a  multi-site setup suggested for one or more sites in the procedure [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/), then you will only want to retrieve your certificate.

We are assuming that you **are** using this procedure so we will only retrieve the certificate. If you are running a standalone  web server using the default configuration, you can retrieve the  certificate and modify the configuration file in one step using:

```
certbot --apache
```

That's really the easiest way to get things done. However, sometimes  you want to take a more manual approach, and just want to grab the  certificate. To retrieve the certificate only, use this command:

```
certbot certonly --apache
```

Both commands will generate a set of prompts that you will need to  answer. The first is to give an email address for important information:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator apache, Installer apache
Enter email address (used for urgent renewal and security notices)
 (Enter 'c' to cancel): yourusername@youremaildomain.com
```

The next asks you to read and accept the terms of the subscriber  agreement. Once you have read the agreement answer 'Y' to continue:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
agree in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o:
```

The next is a request to share your email with the Electronic Frontier Foundation. Answer 'Y' or 'N' as is your preference:

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o:
```

The next prompt asks you which domain you want the certificate for.  It should display a domain in the listing based on your running web  server. If so, enter the number next to the domain that you are getting  the certificate for. In this case there is only one option ('1'):

```
Which names would you like to activate HTTPS for?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
1: yourdomain.com
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Select the appropriate numbers separated by commas and/or spaces, or leave input
blank to select all options shown (Enter 'c' to cancel):
```

If all goes well, you should receive the following message:

```
Requesting a certificate for yourdomain.com
Performing the following challenges:
http-01 challenge for yourdomain.com
Waiting for verification...
Cleaning up challenges
Subscribe to the EFF mailing list (email: yourusername@youremaildomain.com).

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/yourdomain.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/yourdomain.com/privkey.pem
   Your certificate will expire on 2021-07-01. To obtain a new or
   tweaked version of this certificate in the future, simply run
   certbot again. To non-interactively renew *all* of your
   certificates, run "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

## The Site Configuration - https[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#the-site-configuration-https)

Applying the configuration file to our site is slightly different  than if we were using a purchased SSL certificate from another provider  (and if we didn't let *certbot* do it automatically).

The certificate and chain file are included in a single PEM (Privacy  Enhanced Mail) file. This is a common format for all certificate files  now, so even though it has "Mail" in the reference, it is just a type of certificate file. To illustrate the configuration file, we will show it in it's entirety and then describe what is happening:

```
<VirtualHost *:80>
        ServerName www.yourdomain.com
        ServerAdmin username@rockylinux.org
        Redirect / https://www.yourdomain.com/
</VirtualHost>
<Virtual Host *:443>
        ServerName www.yourdomain.com
        ServerAdmin username@rockylinux.org
        DocumentRoot /var/www/sub-domains/com.yourdomain.www/html
        DirectoryIndex index.php index.htm index.html
        Alias /icons/ /var/www/icons/
        # ScriptAlias /cgi-bin/ /var/www/sub-domains/com.yourdomain.www/cgi-bin/

    CustomLog "/var/log/httpd/com.yourdomain.www-access_log" combined
    ErrorLog  "/var/log/httpd/com.yourdomain.www-error_log"

        SSLEngine on
        SSLProtocol all -SSLv2 -SSLv3 -TLSv1
        SSLHonorCipherOrder on
        SSLCipherSuite EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384
:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS

        SSLCertificateFile /etc/letsencrypt/live/yourdomain.com/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/yourdomain.com/privkey.pem
        SSLCertificateChainFile /etc/letsencrypt/live/yourdomain.com/fullchain.pem

        <Directory /var/www/sub-domains/com.yourdomain.www/html>
                Options -ExecCGI -Indexes
                AllowOverride None

                Order deny,allow
                Deny from all
                Allow from all

                Satisfy all
        </Directory>
</VirtualHost>
```

Here's what's happening above. You may want to review the [Apache Web Server Multi-Site Setup](https://docs.rockylinux.org/zh/guides/web/apache-sites-enabled/) to see the differences in the application of an SSL purchased from another provider and the Let's Encrypt certificate:

- Even though port 80 (standard http) is listening, we are redirecting all traffic to port 443 (https)
- SSLEngine on - simply says to use SSL
- SSLProtocol all -SSLv2 -SSLv3 -TLSv1 - says to use all available  protocols, except those that have been found to have vulnerabilities.  You should research periodically which protocols are currently  acceptable for use.
- SSLHonorCipherOrder on - this deals with the next line regarding the cipher suites, and says to deal with them in the order that they are  given. This is another area where you should review the cipher suites  that you want to include periodically
- SSLCertificateFile - this is the PEM file, that contains the site certificate **AND** the intermediate certificate. We still need the  'SSLCertificateChainFile' line in our configuration, but it will simply  specify the same PEM file again.
- SSLCertificateKeyFile - the PEM file for the private key, generated with the *certbot* request.
- SSLCertificateChainFile - the certificate from your certificate  provider, often called the intermediate certificate, in this case  exactly like the 'SSLCertificateFile' location above.

Once you have made all of your changes, simply restart *httpd* and if it starts test your site to make sure you now have a valid  certificate file showing. If so, you are ready to move on to the next  step: automation.

## Using *certbot* With Nginx[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#using-certbot-with-nginx)

A quick note: using *certbot* with Nginx is pretty much the same as with Apache. Here's the short, short version of the guide:

Run this command to get started:

```
certbot --nginx
```

You'll be asked a couple of questions as shown above, including your  email address, and which site you want to get a certificate for.  Assuming you have at least one site configured (with a domain name  pointing at the server), you'll see a list like this:

```
1. yourwebsite.com
2. subdomain.yourwebsite.com
```

If you have more than one site, just press the number that corresponds to the site you want a certificate for.

The rest of the text you'll see is awful similar to what's above. The results will be a bit different, of course. If you have a dead-simple  Nginx configuration file that looks like this:

```
server {
    server_name yourwebsite.com;

    listen 80;
    listen [::]:80;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```

After *certbot* gets through with it, it'll look like a bit this:

```
server {
    server_name  yourwebsite.com;

    listen 443 ssl; # managed by Certbot
    listen [::]:443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/yourwebsite.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/yourwebsite.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}

server {
    if ($host = yourwebsite.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  listen 80;
  listen [::]:80;
  server_name yourwebsite.com;
    return 404; # managed by Certbot
}
```

Depending on a couple of things (for example, if you're using Nginx  as a reverse proxy), you may need to dive into the new configuration  file to fix up a few things that *certbot* won't handle perfectly on its own.

Or write your own configuration file the hard way.

## Automating Let's Encrypt Certificate Renewal[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#automating-lets-encrypt-certificate-renewal)

The beauty of installing *certbot* is that the Let's Encrypt  certificate will be automatically renewed. There is no need to create a  process to do this. We do need to test the renewal with:

```
certbot renew --dry-run
```

When you run this command, you'll get a nice output showing the renewal process:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Processing /etc/letsencrypt/renewal/yourdomain.com.conf
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Cert not due for renewal, but simulating renewal for dry run
Plugins selected: Authenticator apache, Installer apache
Account registered.
Simulating renewal of an existing certificate for yourdomain.com
Performing the following challenges:
http-01 challenge for yourdomain.com
Waiting for verification...
Cleaning up challenges

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
new certificate deployed with reload of apache server; fullchain is
/etc/letsencrypt/live/yourdomain.com/fullchain.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations, all simulated renewals succeeded:
  /etc/letsencrypt/live/yourdomain.com/fullchain.pem (success)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

The command to renew *certbot* can be found using one of the following methods:

- By listing the contents of `/etc/crontab/`
- By listing the contents of `/etc/cron.*/*`
- By running `systemctl list-timers`

In this example, we are using the last option and we can see that *certbot* exists and that it was installed with the `snap` procedure:

```
sudo systemctl list-timers
Sat 2021-04-03 07:12:00 UTC  14h left   n/a                          n/a          snap.certbot.renew.timer     snap.certbot.renew.service
```

## Conclusions[¶](https://docs.rockylinux.org/zh/guides/security/generating_ssl_keys_lets_encrypt/#conclusions)

Let's Encrypt SSL certificates are yet another option for securing  your web site with an SSL. Once installed, the system provides automatic renewal of certificates and will encrypt traffic to your web site.

It should be noted that Let's Encrypt certificates are used for  standard DV (Domain Validation) certificates. They cannot be used for OV (Organization Validation) or EV (Extended Validation) certificates.



# 生成 SSL 密钥[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#ssl)

# 准备工作[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_1)

- 一个工作站和一台运行 Rocky Linux 的服务器。
- 在要生成私钥和 CSR 的机器上以及最终安装密钥和证书的服务器上安装 *OpenSSL*。
- 能够轻松地从命令行运行命令。
- 有关 SSL 和 OpenSSL 命令的知识。

# 简介[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_2)

如今，每个网站都应使用 SSL（安全套接字协议层）证书运行。本文将指导您生成网站私钥，然后从中生成用于购买新证书的 CSR（证书签名请求）。

## 生成私钥[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_3)

对于新手而言，SSL 私钥可以有不同的大小（以位为单位），其大小决定了破解的难易程度。

截至 2021 年，推荐的网站私钥大小仍为 2048 位。您可以使用更多位的密钥，但是将密钥大小从 2048 位增加一倍至 4096 位只会使安全性提高约 16%，但需要更多空间以存储密钥，并且在处理密钥时会导致 CPU 负载增高。

密钥位数过多不会获得任何显著的安全性，反而降低网站性能。 目前采用的密钥大小为 2048，始终关注当前推荐的密钥大小。

首先，请确保工作站和服务器上都安装了 OpenSSL：

```
dnf install openssl
```

如果未安装，则系统将安装它以及所有需要的依赖项。

示例使用的域是 ourownwiki.com。注意，您需要提前购买和注册域名。您可以通过多个“注册商”购买域名。

如果您没有运行自己的 DNS（域名系统），您可以使用 DNS 托管提供类似功能。DNS 将您的命名域转换为 Internet 可以理解的数字（IP地址、IPv4 或 IPv6）。这些 IP 地址将是网站的实际托管位置。

使用 openssl 生成密钥：

```
openssl genrsa -des3 -out ourownwiki.com.key.pass 2048
```

注意，将密钥命名为 .pass 扩展名。这是因为一旦执行此命令，它就会要求您输入密码。输入一个您可以记住的简单密码，因为我们稍后就会移除这个密码：

```
Enter pass phrase for ourownwiki.com.key.pass:
Verifying - Enter pass phrase for ourownwiki.com.key.pass:
```

接下来，移除该密码。这样做的原因是，如果不移除它，则每次 Web 服务器重新启动并加载密钥时，都需要输入该密码。

您可能不准备输入它，或者更糟的是，可能根本没有一个控制台可以输入它。现在将其移除以避免这些情况：

```
openssl rsa -in ourownwiki.com.key.pass -out ourownwiki.com.key
```

这将再次请求该密码从密钥中移除密码：

```
Enter pass phrase for ourownwiki.com.key.pass:
```

现在您已经第三次输入了密码，它已经从密钥文件中删除并另存为 ourownwiki.com.key。

## 生成 CSR[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#csr)

接下来，需要生成将用于购买证书的 CSR（证书签名请求）。

在生成 CSR 的过程中，系统将提示您输入一些信息。这些是证书的 X.509 属性。

其中一个提示是“公用名”。注意，此字段必须填写受 SSL 保护的服务器的完全限定域名。如果要保护的网站是 https://www.ourownwiki.com，然后在此提示下输入 www.ourownwiki.com：

```
openssl req -new -key ourownwiki.com.key -out ourownwiki.com.csr
```

它将产生以下对话：

`Country Name (2 letter code) [XX]:` 输入站点所在的国家/地区码（两个字符），例如“US”。 `State or Province Name (full name) []:` 输入所在州或省的全名，例如“Nebraska”。 `Locality Name (eg, city) [Default City]:` 输入所在城市的全名，例如“Omaha”。 `Organization Name (eg, company) [Default Company Ltd]:` 如果需要，您可以输入此域所属的组织，或者只需按“Enter”键即可跳过。 `Organizational Unit Name (eg, section) []:` 这将描述您的域所属的组织部门。同样，您只需按“Enter”键即可跳过。 `Common Name (eg, your name or your server's hostname) []:` 此处必须输入站点主机名，例如“www.ourownwiki.com”。 `Email Address []:` 此字段是可选的，您可以填写，也可以按“Enter”键跳过。

接下来，将要求您输入额外的属性，在以下两个属性中按“Enter”键跳过：

```
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

现在，您应该已经生成了 CSR。

## 购买证书[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_4)

每个证书供应商的流程基本相同。您购买 SSL 和期限（1 年或 2 年等）。然后提交 CSR。为此，您需要使用 `more` 命令，然后复制 CSR 文件的内容。

```
more ourownwiki.com.csr
```

它将显示以下内容：

```
-----BEGIN CERTIFICATE REQUEST-----
MIICrTCCAZUCAQAwaDELMAkGA1UEBhMCVVMxETAPBgNVBAgMCE5lYnJhc2thMQ4w
DAYDVQQHDAVPbWFoYTEcMBoGA1UECgwTRGVmYXVsdCBDb21wYW55IEx0ZDEYMBYG
A1UEAwwPd3d3Lm91cndpa2kuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzwN02erkv9JDhpR8NsJ9eNSm/bLW/jNsZxlxOS3BSOOfQDdUkX0rAt4G
nFyBAHRAyxyRvxag13O1rVdKtxUv96E+v76KaEBtXTIZOEZgV1visZoih6U44xGr
wcrNnotMB5F/T92zYsK2+GG8F1p9zA8UxO5VrKRL7RL3DtcUwJ8GSbuudAnBhueT
nLlPk2LB6g6jCaYbSF7RcK9OL304varo6Uk0zSFprrg/Cze8lxNAxbFzfhOBIsTo
PafcA1E8f6y522L9Vaen21XsHyUuZBpooopNqXsG62dcpLy7sOXeBnta4LbHsTLb
hOmLrK8RummygUB8NKErpXz3RCEn6wIDAQABoAAwDQYJKoZIhvcNAQELBQADggEB
ABMLz/omVg8BbbKYNZRevsSZ80leyV8TXpmP+KaSAWhMcGm/bzx8aVAyqOMLR+rC
V7B68BqOdBtkj9g3u8IerKNRwv00pu2O/LOsOznphFrRQUaarQwAvKQKaNEG/UPL
gArmKdlDilXBcUFaC2WxBWgxXI6tsE40v4y1zJNZSWsCbjZj4Xj41SB7FemB4SAR
RhuaGAOwZnzJBjX60OVzDCZHsfokNobHiAZhRWldVNct0jfFmoRXb4EvWVcbLHnS
E5feDUgu+YQ6ThliTrj2VJRLOAv0Qsum5Yl1uF+FZF9x6/nU/SurUhoSYHQ6Co93
HFOltYOnfvz6tOEP39T/wMo=
-----END CERTIFICATE REQUEST-----
```

您需要复制所有内容，包括“BEGIN CERTIFICATE REQUEST”和“END CERTIFICATE REQUEST”行。 然后将它们粘贴到您购买证书的网站上的 CSR 字段中。

在颁发证书之前，您可能必须执行其他验证步骤，具体取决于域的所有权，所使用的注册商等。颁发时，它应与提供者提供的中间证书一起颁发，您还将在配置中使用该证书。

# 总结[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_5)

生成用于购买网站证书的所有位和片段并不是非常困难，可以由系统管理员或网站管理员执行上述过程以完成该任务。

# 生成 SSL 密钥[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#ssl)

# 准备工作[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_1)

- 一个工作站和一台运行 Rocky Linux 的服务器。
- 在要生成私钥和 CSR 的机器上以及最终安装密钥和证书的服务器上安装 *OpenSSL*。
- 能够轻松地从命令行运行命令。
- 有关 SSL 和 OpenSSL 命令的知识。

# 简介[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_2)

如今，每个网站都应使用 SSL（安全套接字协议层）证书运行。本文将指导您生成网站私钥，然后从中生成用于购买新证书的 CSR（证书签名请求）。

## 生成私钥[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_3)

对于新手而言，SSL 私钥可以有不同的大小（以位为单位），其大小决定了破解的难易程度。

截至 2021 年，推荐的网站私钥大小仍为 2048 位。您可以使用更多位的密钥，但是将密钥大小从 2048 位增加一倍至 4096 位只会使安全性提高约 16%，但需要更多空间以存储密钥，并且在处理密钥时会导致 CPU 负载增高。

密钥位数过多不会获得任何显著的安全性，反而降低网站性能。 目前采用的密钥大小为 2048，始终关注当前推荐的密钥大小。

首先，请确保工作站和服务器上都安装了 OpenSSL：

```
dnf install openssl
```

如果未安装，则系统将安装它以及所有需要的依赖项。

示例使用的域是 ourownwiki.com。注意，您需要提前购买和注册域名。您可以通过多个“注册商”购买域名。

如果您没有运行自己的 DNS（域名系统），您可以使用 DNS 托管提供类似功能。DNS 将您的命名域转换为 Internet 可以理解的数字（IP地址、IPv4 或 IPv6）。这些 IP 地址将是网站的实际托管位置。

使用 openssl 生成密钥：

```
openssl genrsa -des3 -out ourownwiki.com.key.pass 2048
```

注意，将密钥命名为 .pass 扩展名。这是因为一旦执行此命令，它就会要求您输入密码。输入一个您可以记住的简单密码，因为我们稍后就会移除这个密码：

```
Enter pass phrase for ourownwiki.com.key.pass:
Verifying - Enter pass phrase for ourownwiki.com.key.pass:
```

接下来，移除该密码。这样做的原因是，如果不移除它，则每次 Web 服务器重新启动并加载密钥时，都需要输入该密码。

您可能不准备输入它，或者更糟的是，可能根本没有一个控制台可以输入它。现在将其移除以避免这些情况：

```
openssl rsa -in ourownwiki.com.key.pass -out ourownwiki.com.key
```

这将再次请求该密码从密钥中移除密码：

```
Enter pass phrase for ourownwiki.com.key.pass:
```

现在您已经第三次输入了密码，它已经从密钥文件中删除并另存为 ourownwiki.com.key。

## 生成 CSR[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#csr)

接下来，需要生成将用于购买证书的 CSR（证书签名请求）。

在生成 CSR 的过程中，系统将提示您输入一些信息。这些是证书的 X.509 属性。

其中一个提示是“公用名”。注意，此字段必须填写受 SSL 保护的服务器的完全限定域名。如果要保护的网站是 https://www.ourownwiki.com，然后在此提示下输入 www.ourownwiki.com：

```
openssl req -new -key ourownwiki.com.key -out ourownwiki.com.csr
```

它将产生以下对话：

`Country Name (2 letter code) [XX]:` 输入站点所在的国家/地区码（两个字符），例如“US”。 `State or Province Name (full name) []:` 输入所在州或省的全名，例如“Nebraska”。 `Locality Name (eg, city) [Default City]:` 输入所在城市的全名，例如“Omaha”。 `Organization Name (eg, company) [Default Company Ltd]:` 如果需要，您可以输入此域所属的组织，或者只需按“Enter”键即可跳过。 `Organizational Unit Name (eg, section) []:` 这将描述您的域所属的组织部门。同样，您只需按“Enter”键即可跳过。 `Common Name (eg, your name or your server's hostname) []:` 此处必须输入站点主机名，例如“www.ourownwiki.com”。 `Email Address []:` 此字段是可选的，您可以填写，也可以按“Enter”键跳过。

接下来，将要求您输入额外的属性，在以下两个属性中按“Enter”键跳过：

```
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

现在，您应该已经生成了 CSR。

## 购买证书[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_4)

每个证书供应商的流程基本相同。您购买 SSL 和期限（1 年或 2 年等）。然后提交 CSR。为此，您需要使用 `more` 命令，然后复制 CSR 文件的内容。

```
more ourownwiki.com.csr
```

它将显示以下内容：

```
-----BEGIN CERTIFICATE REQUEST-----
MIICrTCCAZUCAQAwaDELMAkGA1UEBhMCVVMxETAPBgNVBAgMCE5lYnJhc2thMQ4w
DAYDVQQHDAVPbWFoYTEcMBoGA1UECgwTRGVmYXVsdCBDb21wYW55IEx0ZDEYMBYG
A1UEAwwPd3d3Lm91cndpa2kuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzwN02erkv9JDhpR8NsJ9eNSm/bLW/jNsZxlxOS3BSOOfQDdUkX0rAt4G
nFyBAHRAyxyRvxag13O1rVdKtxUv96E+v76KaEBtXTIZOEZgV1visZoih6U44xGr
wcrNnotMB5F/T92zYsK2+GG8F1p9zA8UxO5VrKRL7RL3DtcUwJ8GSbuudAnBhueT
nLlPk2LB6g6jCaYbSF7RcK9OL304varo6Uk0zSFprrg/Cze8lxNAxbFzfhOBIsTo
PafcA1E8f6y522L9Vaen21XsHyUuZBpooopNqXsG62dcpLy7sOXeBnta4LbHsTLb
hOmLrK8RummygUB8NKErpXz3RCEn6wIDAQABoAAwDQYJKoZIhvcNAQELBQADggEB
ABMLz/omVg8BbbKYNZRevsSZ80leyV8TXpmP+KaSAWhMcGm/bzx8aVAyqOMLR+rC
V7B68BqOdBtkj9g3u8IerKNRwv00pu2O/LOsOznphFrRQUaarQwAvKQKaNEG/UPL
gArmKdlDilXBcUFaC2WxBWgxXI6tsE40v4y1zJNZSWsCbjZj4Xj41SB7FemB4SAR
RhuaGAOwZnzJBjX60OVzDCZHsfokNobHiAZhRWldVNct0jfFmoRXb4EvWVcbLHnS
E5feDUgu+YQ6ThliTrj2VJRLOAv0Qsum5Yl1uF+FZF9x6/nU/SurUhoSYHQ6Co93
HFOltYOnfvz6tOEP39T/wMo=
-----END CERTIFICATE REQUEST-----
```

您需要复制所有内容，包括“BEGIN CERTIFICATE REQUEST”和“END CERTIFICATE REQUEST”行。 然后将它们粘贴到您购买证书的网站上的 CSR 字段中。

在颁发证书之前，您可能必须执行其他验证步骤，具体取决于域的所有权，所使用的注册商等。颁发时，它应与提供者提供的中间证书一起颁发，您还将在配置中使用该证书。

# 总结[¶](https://docs.rockylinux.org/zh/guides/security/ssl_keys_https/#_5)

生成用于购买网站证书的所有位和片段并不是非常困难，可以由系统管理员或网站管理员执行上述过程以完成该任务。

------

​            最后更新:      2021年10月12日            