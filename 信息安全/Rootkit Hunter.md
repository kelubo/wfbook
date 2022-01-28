# Rootkit Hunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#rootkit-hunter)

## Prerequisites[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#prerequisites)

- A Rocky Linux Web Server running Apache
- Proficiency with a command-line editor (we are using *vi* in this example)
- A heavy comfort level with issuing commands from the command-line, viewing logs, and other general systems administrator duties
- An understanding of what can trigger a response to changed files on the file system (such as package updates) is helpful
- All commands are run as the root user or sudo

## Introduction[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#introduction)

*rkhunter* (Root Kit Hunter) is a Unix-based tool that scans  for rootkits, backdoors, and possible local exploits. It is a good part  of a hardened web server, and is designed to notify the administrator  quickly when something suspicious happens on the server's file system.

*rkhunter* is just one possible component of a hardened Apache web server setup and can be used with or without other tools. If you'd  like to use this along with other tools for hardening, refer back to the [Apache Hardened Web Server guide](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/).

This document also uses all of the assumptions and conventions  outlined in that original document, so it is a good idea to review it  before continuing.

## Installing rkhunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#installing-rkhunter)

*rkhunter* requires the EPEL (Extra Packages for Enterprise  Linux) repository. So install that repository if you don't have it  installed already:

```
dnf install epel-release
```

Then install *rkhunter*:

```
dnf install rkhunter
```

## Configuring rkhunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#configuring-rkhunter)

The only configuration options that need to be set are those dealing  with mailing reports to the administrator. To modify the configuration  file, run:

```
vi /etc/rkhunter.conf
```

And then search for:

```
#MAIL-ON-WARNING=me@mydomain   root@mydomain
```

Remove the remark here and change the me@mydomain.com to reflect your email address.

Then change the root@mydomain to root@whatever_the_server_name_is.

You may also need to setup [Postfix Email for Reporting](https://docs.rockylinux.org/zh/guides/email/postfix_reporting/) in order to get the email section to work correctly.

## Running rkhunter[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#running-rkhunter)

*rkhunter* can be run by typing it at the command-line. There is a cron job installed for you in `/etc/cron.daily`, but if you want to automate the procedure on a different schedule, look at the [Automating cron jobs guide](https://docs.rockylinux.org/zh/guides/automation/cron_jobs_howto/). 

You'll also need to move the script somewhere other than `/etc/cron.daily`, such as `/usr/local/sbin` and then call it from your custom cron job. The easiest method, of course, is to leave the default cron.daily setup intact.

Before you run allow *rkhunter* to run automatically, run the  command manually with the "--propupd" flag to create the rkhunter.dat  file, and to make sure that your new environment is recognized without  issue:

```
rkhunter --propupd
```

To run *rkhunter* manually:

```
rkhunter --check
```

This will echo back to the screen as the checks are performed, prompting you to `[Press <ENTER> to continue]` after each section.

## Conclusion[¶](https://docs.rockylinux.org/zh/guides/web/apache_hardened_webserver/rkhunter/#conclusion)

*rkhunter* is one part of a hardened server strategy that can  help in monitoring the file system and reporting any issues to the  administrator. It is perhaps one of the easiest hardening tools to  install, configure, and run.