 Quick Start Guide
Contents

    1 Getting started with IPA
    2 Preparing a Platform
        2.1 Static Hostname
        2.2 DNS Rules
    3 Select FreeIPA version
    4 Installing FreeIPA server
        4.1 Administrative users in FreeIPA
        4.2 Help system in FreeIPA
        4.3 Adding your first user
        4.4 Web User Interface

Getting started with IPA

If you are not a Linux professional installing and configuring a server and especially a security one might be a challenge. The following document is an attempt to help those who are not familiar with Linux and want to give IPA a try.
Preparing a Platform

The main assumption is that you have a computer or a VM with a supported platform. Currently, we support Fedora and Red Hat Enterprise Linux. As FreeIPA requires a lot of new packages (LDAP, DNS or PKI servers and others), we recommend that FreeIPA is tried first on a VM, which can be then easily decommissioned after the test.

Before FreeIPA can be installed, make sure that FreeIPA prerequisites are fulfilled, namely a static hostname or sane DNS resolution.
Static Hostname

Kerberos authentication relies on a static hostname, if the hostname changes, Kerberos authentication may break. Thus, the testing machine should not use dynamically configured hostname from DHCP, but rather a static one configured in /etc/hostname
DNS Rules

A properly configured DNS is the cornerstone of a working FreeIPA system. Without a properly working DNS configuration Kerberos and SSL won't work as expected, or at all.
Important.png
DNS domain cannot be changed after installation. Make sure you read and understand all caveats before you proceeding with the installation.

The IPA installer is quite picky about the DNS configuration. The following checks are done by installer:

    The hostname cannot be localhost or localhost6.
    The hostname must be fully-qualified (ipa.example.com)
    The hostname must be resolvable.
    The reverse of address that it resolves to must match the hostname.

Note.png
DNS Caching
A typical resolver looks in /etc/hosts first and DNS second. If nscd is running this may add an interesting twist as it caches lookups. The IPA installer doesn't kill nscd until the installation process has started so beware of cached entries if you try tweaking /etc/hosts (killing nscd is recommended if you do).

The rule about /etc/hosts is that the fully-qualified name must come first. It should look like:

10.0.0.1       ipa.example.com ipa

Select FreeIPA version

It is important to realize what version of the FreeIPA you are planning to install. There are two options:

    Standard FreeIPA version distributed with the OS: this is the safest option, contains a tested FreeIPA version. It may just not contain the latest bits.
    Bleeding Edge repo: daily build repository from our git containing the latest bits. Great for testing the upcoming features. Just note, this version is not tested and there may be dragons!
    Public Demo: the quickest way to get the look and feel of FreeIPA is to look at it's public demo!
    Docker container: quick and easy way to test the FreeIPA server in an isolated Docker container without need to create virtual machines.

Installing FreeIPA server

When all OS is ready and all prerequisites are met, let's try out FreeIPA!

    Install FreeIPA server. From root terminal, run:

        # yum install freeipa-server
        Note that the installed package just contains all the bits that FreeIPA uses, it does not configured the actual server.

    Configure a FreeIPA server.

        The command can take command arguments or can be run in the interactive mode. You can get more details with man ipa-server-install. To start the interactive installation, run:
        # ipa-server-install
        The command will at first gather all required information and then configure all required services.

Administrative users in FreeIPA

To be able to perform any administrative task you need to authenticate to the server. During the configuration step you have been prompted to create two users. The first one Directory Manager is the superuser that needs to be used to perform rare low level tasks. For the normal administrative activity an administrative account admin has been created.

To authenticate as the admin, just run:

$ kinit admin
Password for admin@EXAMPLE.COM:

You will be prompted for the password. Use the password that you specified during the configuration step for the admin user. As a result of this operation you acquire Kerberos ticket (more info).
Help system in FreeIPA

You can use the ticket acquired as a result of the operation described above to perform different administrative tasks. The first task that we will do is add a user via command line. To do that we will first inspect the command line interface by reading man pages of the ipa command:

$ man ipa

One of the core features of IPA is its extensibility and pluggability. This means that new functionality can be added later on top of the existing, already running server. This also means that the help system i.e. man pages should be pluggable and extensible. To accommodate this requirement the ipa has a help system beyond man pages that allows addition of the information. To get more information, run:

    $ ipa help topics to get a list of help topics
    $ ipa help <topic> to print help for chosen topic
    $ ipa help <command> to dive into the details of the command or topic

Adding your first user

Run ipa help user to see help on the user operations. Keep in mind that the password management is a separate step and operation so after a user is created the password for him should be set using ipa passwd command otherwise the newly created user would not be able to authenticate.

To create a user run

ipa user-add

command with or without additional parameters. If you omit any of the required parameters or all of them the interface will prompt you for the information.

After adding user add a password for him:

ipa passwd <user>

This will create a password, but it will be a temporary one. The one that you need to change on the first authentication. This is done on purpose so that administrator can reset a password for a user but would not be able to take advantage of that knowledge since user would has to change the password on the first login.

You can now authenticate as the new user with

kinit <user>

command. This will prompt you for a password and the immediately request a password change.
Web User Interface

Next step is to try the web UI. Make sure that your administrative ticket is valid by running

kinit admin

command. Run firefox in the same command window. It will start an instance of the firefox. In the address bar type the name of the FreeIPA server machine (e.g. ipa.example.com).

As the first step the FreeIPA server via browser will ask you to accept a certificate for a secure SSL communication between your client (browser) and the server (ipa). Follow the prompts and accept the exception. Be sure that imported certificate is comes from FreeIPA server and not from attacker!

When certificate is accepted, Web UI will most likely detect that it does not have any Kerberos credentials available and will show up user and password login screen. To properly configure the browser, you can follow a link on the log in screen to run the configuration tool. 