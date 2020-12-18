# Cobbler

[TOC]

Cobbler is a provisioning (installation) and update server. It supports deployments via PXE (network booting), virtualization (Xen, QEMU/KVM, or VMware), and re-installs of existing Linux systems. The latter two features are enabled by usage of ‘Koan’ on the remote system. Update server features include yum mirroring and integration of those mirrors with automated installation files. Cobbler has a command line interface, WebUI, and extensive Python and XML-RPC APIs for integration with external scripts and applications.

## 安装前准备

Cobbler can be a somewhat complex system to get started with, due to the wide variety of technologies it is designed to manage, but it does support a great deal of functionality immediately after installation with little to no customization needed. Before getting started with Cobbler, you should have a good working knowledge of PXE as well as the automated installation methodology of your chosen distribution(s).

### SELinux

Before getting started with Cobbler, it may be convenient to either disable SELinux or set it to “permissive” mode, especially if you are unfamiliar with SELinux troubleshooting or modifying SELinux policy. Cobbler constantly evolves to assist in managing new system technologies, and the policy that ships with your OS can sometimes lag behind the feature-set we provide, resulting in AVC denials that break Cobbler’s functionality.

禁用SELinux

### Firewall

禁用firewalld

## 安装

```bash
# CentOS
yum install cobbler

yum -y install cobbler cobbler-web pykickstart dhcp xinetd 
```

### 启动相关服务

```bash
systemctl enable cobblerd
systemctl start cobblerd
```

### 通过cobbler check 核对当前设置是否有问题

```bash
cobbler check
The following are potential configuration items that you may want to fix:

1 : The 'server' field in /etc/cobbler/settings must be set to something other than localhost, or automatic features will not work. This should be a resolvable hostname or IP for the boot server as reachable by all machines that will use it.
2 : For PXE to be functional, the 'next_server' field in /etc/cobbler/settings must be set to something other than 127.0.0.1, and should match the IP of the boot server on the PXE network.
3 : change 'disable' to 'no' in /etc/xinetd.d/tftp
4 : Some network boot-loaders are missing from /var/lib/cobbler/loaders, you may run 'cobbler get-loaders' to download them, or, if you only want to handle x86/x86_64 netbooting, you may ensure that you have installed a *recent* version of the syslinux package installed and can ignore this message entirely. Files in this directory, should you want to support all architectures, should include pxelinux.0, menu.c32, elilo.efi, and yaboot. The 'cobbler get-loaders' command is the easiest way to resolve these requirements.
5 : enable and start rsyncd.service with systemctl
6 : debmirror package is not installed, it will be required to manage debian deployments and repositories
7 : The default password used by the sample templates for newly installed machines (default_password_crypted in /etc/cobbler/settings) is still set to 'cobbler' and should be changed, try: "openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'" to generate new one
8 : fencing tools were not found, and are required to use the (optional) power management features. install cman or fence-agents to use them
9 : reposync is not installed, install yum-utils or dnf-plugins-core
10 : yumdownloader is not installed, install yum-utils or dnf-plugins-core
11 : ksvalidator was not found, install pykickstart
12 : comment out 'dists' on /etc/debmirror.conf for proper debian support
13 : comment out 'arches' on /etc/debmirror.conf for proper debian support

Restart cobblerd and then run 'cobbler sync' to apply changes.
```

处理方式

```bash
1 : 修改 /etc/cobbler/settings 中 server 为本机 IP
2 : 修改 /etc/cobbler/settings 中 next_server 为本机 IP
3 :
4 : cobbler get-loaders #可能因网络问题失败，多次尝试
5 :
6 : yum install debmirror
7 : openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'
    修改 /etc/cobbler/settings 中 default_password_crypted 的值替换为上方命令的输出结果
8 : yum install fence-agents
9 - 10 : yum install yum-utils
11 : yum install pykickstart
12 : sed -i 's/@dists="sid";/#@dists="sid";/' /etc/debmirror.conf
13 : sed -i 's/@arches="i386";/#@arches="i386";/' /etc/debmirror.conf
```

### Changing Settings

Settings for cobbler/cobblerd are stored in `/etc/cobbler/settings`. 

**Default Encrypted Password**

This setting controls the root password that is set for new systems during the kickstart.

```
default_password_crypted: "$1$bfI7WLZz$PxXetL97LkScqJFxnW7KS1"
```

You should modify this by running the following command and inserting the output into the above string (be sure to save the quote marks):

```
$ openssl passwd -1
```

**Server and Next_Server**

The server option sets the IP that will be used for the address of the cobbler server. ***DO NOT\*** use 0.0.0.0, as it is not the listening address. This should be set to the IP you want hosts that are being built to contact the cobbler server on for such protocols as HTTP and TFTP.

```
# default, localhost
server: 127.0.0.1
```

The next_server option is used for DHCP/PXE as the IP of the TFTP server from which network boot files are downloaded. Usually, this will be the same IP as the server setting.

```
# default, localhost
next_server: 127.0.0.1
```

**DHCP Management and DHCP Server Template**

In order to PXE boot, you need a DHCP server to hand out addresses and direct the booting system to the TFTP server where it can download the network boot files. Cobbler can manage this for you, via the manage_dhcp setting:

```
# default, don't manage
manage_dhcp: 0
```

Change that setting to 1 so cobbler will generate the dhcpd.conf file based on the dhcp.template that is included with cobbler. This template will most likely need to be modified as well, based on your network settings:

```
$ vi /etc/cobbler/dhcp.template
```

For most uses, you’ll only need to modify this block:

```
subnet 192.168.1.0 netmask 255.255.255.0 {
     option routers             192.168.1.1;
     option domain-name-servers 192.168.1.210,192.168.1.211;
     option subnet-mask         255.255.255.0;
     filename                   "/pxelinux.0";
     default-lease-time         2.8.0;
     max-lease-time             43200;
     next-server                $next_server;
}
```

No matter what, make sure you do not modify the “next-server $next_server;” line, as that is how the next_server setting is pulled into the configuration. This file is a cheetah template, so be sure not to modify anything starting after this line:

```
#for dhcp_tag in $dhcp_tags.keys():
```

Completely going through the dhcpd.conf configuration syntax is beyond the scope of this document, but for more information see the man page for more details:

```
$ man dhcpd.conf
```

**Files and Directory Notes**

Cobbler makes heavy use of the `/var` directory. The `/var/www/cobbler/ks_mirror` directory is where all of the distribution and repository files are copied, so you will need 5-10GB of free space per distribution you wish to import.

If you have installed cobbler onto a system that has very little free space in the partition containing `/var`, please read the [Relocating Your Installation](https://cobbler.readthedocs.io/en/release28/2_installation/relocating your installation.html) section of the manual to learn how you can relocate your installation properly.

## Starting and Enabling the Cobbler Service

Once you have updated your settings, you’re ready to start the service. Fedora now uses systemctl to manage services, but you can still use the regular init script:

```
$ systemctl start cobblerd.service
$ systemctl enable cobblerd.service
$ systemctl status cobblerd.service
```

or

```
$ service cobblerd start
$ chkconfig cobblerd on
$ service cobblerd status
```

If everything has gone well, you should see output from the status command like this:

```
cobblerd.service - Cobbler Helper Daemon
          Loaded: loaded (/lib/systemd/system/cobblerd.service; enabled)
          Active: active (running) since Sun, 17 Jun 2012 13:01:28 -0500; 1min 44s ago
        Main PID: 1234 (cobblerd)
          CGroup: name=systemd:/system/cobblerd.service
                  └ 1234 /usr/bin/python /usr/bin/cobblerd -F
```

## Checking for Problems and Your First Sync

Now that the cobblerd service is up and running, it’s time to check for problems. Cobbler’s check command will make some suggestions, but it is important to remember that *these are mainly only suggestions* and probably aren’t critical for basic functionality. If you are running iptables or SELinux, it is important to review any messages concerning those that check may report.

```
$ cobbler check
The following are potential configuration items that you may want to fix:

1. ....
2. ....

Restart cobblerd and then run 'cobbler sync' to apply changes.
```

If you decide to follow any of the suggestions, such as installing extra packages, making configuration changes, etc., be sure to restart the cobblerd service as it suggests so the changes are applied.

Once you are done reviewing the output of “cobbler check”, it is time to synchronize things for the first time. This is not critical, but a failure to properly sync at this point can reveal a configuration problem.

```
$ cobbler sync
task started: 2012-06-24_224243_sync
task started (id=Sync, time=Sun Jun 24 22:42:43 2012)
running pre-sync triggers
...
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
rendering TFTPD files
generating /etc/xinetd.d/tftp
cleaning link caches
running: find /var/lib/tftpboot/images/.link_cache -maxdepth 1 -type f -links 1 -exec rm -f '{}' ';'
received on stdout:
received on stderr:
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout:
received on stderr:
running: service dhcpd restart
received on stdout:
received on stderr:
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
```

Assuming all went well and no errors were reported, you are ready to move on to the next step.

## Importing Your First Distribution

Cobbler automates adding distributions and profiles via the “cobbler import” command. This command can (usually) automatically detect the type and version of the distribution your importing and create (one or more) profiles with the correct settings for you.

### Download an ISO Image

In order to import a distribution, you will need a DVD ISO for your distribution. **NOTE:** You must use a full DVD, and not a “Live CD” ISO. For this example, we’ll be using the Fedora 28 x86_64 ISO, [available for download here](http://download.fedoraproject.org/pub/fedora/linux/releases/28/Server/x86_64/iso/Fedora-Server-dvd-x86_64-28-1.1.iso).

Once this file is downloaded, mount it somewhere:

```
$ mount -t iso9660 -o loop,ro /path/to/isos/Fedora-Server-dvd-x86_64-28-1.1.iso /mnt
```

### Run the Import

You are now ready to import the distribution. The name and path arguments are the only required options for import:

```
$ cobbler import --name=fedora28 --arch=x86_64 --path=/mnt
```

The –arch option need not be specified, as it will normally be auto-detected. We’re doing so in this example in order to prevent multiple architectures from being found (Fedora ships i386 packages on the full DVD, and cobbler will create both x86_64 and i386 distros by default).

### Listing Objects

If no errors were reported during the import, you can view details about the distros and profiles that were created during the import.

```
$ cobbler distro list
$ cobbler profile list
```

The import command will typically create at least one distro/profile pair, which will have the same name as shown above. In some cases (for instance when a xen-based kernel is found), more than one distro/profile pair will be created.

### Object Details

The report command shows the details of objects in cobbler:

```
$ cobbler distro report --name=fedora28-x86_64
Name                           : fedora28-x86_64
Architecture                   : x86_64
TFTP Boot Files                : {}
Breed                          : redhat
Comment                        :
Fetchable Files                : {}
Initrd                         : /var/www/cobbler/ks_mirror/fedora28-x86_64/images/pxeboot/initrd.img
Kernel                         : /var/www/cobbler/ks_mirror/fedora28-x86_64/images/pxeboot/vmlinuz
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart Metadata             : {'tree': 'http://@@http_server@@/cblr/links/fedora28-x86_64'}
Management Classes             : []
OS Version                     : fedora28
Owners                         : ['admin']
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Template Files                 : {}
```

As you can see above, the import command filled out quite a few fields automatically, such as the breed, OS version, and initrd/kernel file locations. The “Kickstart Metadata” field (–ksmeta internally) is used for miscellaneous variables, and contains the critical “tree” variable. This is used in the kickstart templates to specify the URL where the installation files can be found.

Something else to note: some fields are set to “<<inherit>>”. This means they will use either the default setting (found in the settings file), or (in the case of profiles, sub-profiles, and systems) will use whatever is set in the parent object.

## Creating a System

Now that you have a distro and profile, you can create a system. Profiles can be used to PXE boot, but most of the features in cobbler revolve around system objects. The more information you give about a system, the more cobbler will do automatically for you.

First, we’ll create a system object based on the profile that was created during the import. When creating a system, the name and profile are the only two required fields:

```
$ cobbler system add --name=test --profile=fedora28-x86_64
$ cobbler system list
test
$ cobbler system report --name=test
Name                           : test
TFTP Boot Files                : {}
Comment                        :
Enable gPXE?                   : 0
Fetchable Files                : {}
Gateway                        :
Hostname                       :
Image                          :
IPv6 Autoconfiguration         : False
IPv6 Default Device            :
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart                      : <<inherit>>
Kickstart Metadata             : {}
LDAP Enabled                   : False
LDAP Management Type           : authconfig
Management Classes             : []
Management Parameters          : <<inherit>>
Monit Enabled                  : False
Name Servers                   : []
Name Servers Search Path       : []
Netboot Enabled                : True
Owners                         : ['admin']
Power Management Address       :
Power Management ID            :
Power Management Password      :
Power Management Type          : ipmitool
Power Management Username      :
Profile                        : fedora28-x86_64
Proxy                          : <<inherit>>
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos Enabled                  : False
Server Override                : <<inherit>>
Status                         : production
Template Files                 : {}
Virt Auto Boot                 : <<inherit>>
Virt CPUs                      : <<inherit>>
Virt Disk Driver Type          : <<inherit>>
Virt File Size(GB)             : <<inherit>>
Virt Path                      : <<inherit>>
Virt RAM (MB)                  : <<inherit>>
Virt Type                      : <<inherit>>
```

The primary reason for creating a system object is network configuration. When using profiles, you’re limited to DHCP interfaces, but with systems you can specify many more network configuration options.

So now we’ll setup a single, simple interface in the 192.168.1/24 network:

```
$ cobbler system edit --name=test --interface=eth0 --mac=00:11:22:AA:BB:CC --ip-address=192.168.1.100 --netmask=255.255.255.0 --static=1 --dns-name=test.mydomain.com
```

The default gateway isn’t specified per-NIC, so just add that separately (along with the hostname):

```
$ cobbler system edit --name=test --gateway=192.168.1.1 --hostname=test.mydomain.com
```

The –hostname field corresponds to the local system name and is returned by the “hostname” command. The `--dns-name` (which can be set per-NIC) should correspond to a DNS A-record tied to the IP of that interface. Neither are required, but it is a good practice to specify both. Some advanced features (like configuration management) rely on the `--dns-name` field for system record look-ups.

Whenever a system is edited, cobbler executes what is known as a “lite sync”, which regenerates critical files like the PXE boot file in the TFTP root directory. One thing it will **NOT** do is execute service management actions, like regenerating the dhcpd.conf and restarting the DHCP service. After adding a system with a static interface it is a good idea to execute a full “cobbler sync” to ensure the dhcpd.conf file is rewritten with the correct static lease and the service is bounced.



cobbler is a provisioning (installation) and update server.  It supports deployments via PXE (network booting), virtualization (Xen, QEMU/KVM, or VMware), and re-installs of existing Linux systems. The latter two features are enabled by usage of ‘koan’ on the remote system. Update server features include yum mirroring and integration of those mirrors with automated installation files.  Cobbler has a command line interface, Web UI, and extensive Python and XMLRPC APIs for integration with external scripts and applications.

If you want to explore tools or scripts which are using cobbler please use the GitHub-Topic: https://github.com/topics/cobbler

Here you should find a comprehensive overview about the usage of cobbler.









## 1.2. Changing settings

Before starting the cobblerd service, there are a few things you should modify.

Settings are stored in `/etc/cobbler/settings`. This file is a YAML formatted data file, so be sure to take care when editing this file as an incorrectly formatted file will prevent cobblerd from running.

### 1.2.1. Default encrypted password

This setting controls the root password that is set for new systems during the handsoff installation.

```
default_password_crypted: "$1$bfI7WLZz$PxXetL97LkScqJFxnW7KS1"
```

You should modify this by running the following command and inserting the output into the above string (be sure to save the quote marks):

```
$ openssl passwd -1
```

### 1.2.2. Server and next_server

The `server` option sets the IP that will be used for the address of the cobbler server. **DO NOT** use 0.0.0.0, as it is not the listening address. This should be set to the IP you want hosts that are being built to contact the Cobbler server on for such protocols as HTTP and TFTP.

```
server: 127.0.0.1
```

The `next_server` option is used for DHCP/PXE as the IP of the TFTP server from which network boot files are downloaded. Usually, this will be the same IP as the server setting.

```
next_server: 127.0.0.1
```

## 1.3. DHCP management and DHCP server template

In order to PXE boot, you need a DHCP server to hand out addresses and direct the booting system to the TFTP server where it can download the network boot files. Cobbler can manage this for you, via the `manage_dhcp` setting:

```
manage_dhcp: 0
```

Change that setting to 1 so Cobbler will generate the `dhcpd.conf` file based on the `dhcp.template` that is included with Cobbler. This template will most likely need to be modified as well, based on your network settings:

```
$ vi /etc/cobbler/dhcp.template
```

For most uses, you’ll only need to modify this block:

```
subnet 192.168.1.0 netmask 255.255.255.0 {
    option routers             192.168.1.1;
    option domain-name-servers 192.168.1.210,192.168.1.211;
    option subnet-mask         255.255.255.0;
    filename                   "/pxelinux.0";
    default-lease-time         21600;
    max-lease-time             43200;
    next-server                $next_server;
}
```

No matter what, make sure you do not modify the `next-server $next_server;` line, as that is how the next_server setting is pulled into the configuration. This file is a cheetah template, so be sure not to modify anything starting after this line:

```
#for dhcp_tag in $dhcp_tags.keys():
```

Completely going through the `dhcpd.conf` configuration syntax is beyond the scope of this document, but for more information see the man page for more details:

```
$ man dhcpd.conf
```

## 1.4. Notes on files and directories

Cobbler makes heavy use of the `/var` directory. The `/var/www/cobbler/distro_mirror` directory is where all of the distrubtion and repository files are copied, so you will need 5-10GB of free space per distribution you wish to import.

If you have installed Cobbler onto a system that has very little free space in the partition containing `/var`, please read the [Relocating your installation](https://cobbler.readthedocs.io/en/latest/installation-guide.html#relocating-your-installation) section of the Installation Guide to learn how you can relocate your installation properly.

## 1.5. Starting and enabling the Cobbler service

Once you have updated your settings, you’re ready to start the service:

```
$ systemctl start cobblerd.service
$ systemctl enable cobblerd.service
$ systemctl status cobblerd.service
```

If everything has gone well, you should see output from the status command like this:

```
cobblerd.service - Cobbler Helper Daemon
    Loaded: loaded (/lib/systemd/system/cobblerd.service; enabled)
      Active: active (running) since Sun, 17 Jun 2012 13:01:28 -0500; 1min 44s ago
    Main PID: 1234 (cobblerd)
      CGroup: name=systemd:/system/cobblerd.service
              └ 1234 /usr/bin/python /usr/bin/cobblerd -F
```

## 1.6. Checking for problems and your first sync

Now that the cobblerd service is up and running, it’s time to check for problems. Cobbler’s check command will make some suggestions, but it is important to remember that these are mainly only suggestions and probably aren’t critical for basic functionality. If you are running iptables or SELinux, it is important to review any messages concerning those that check may report.

```
$ cobbler check
The following are potential configuration items that you may want to fix:

1. ....
2. ....
```

Restart cobblerd and then run `cobbler sync` to apply changes.

If you decide to follow any of the suggestions, such as installing extra packages, making configuration changes, etc., be sure to restart the cobblerd service as it suggests so the changes are applied.

Once you are done reviewing the output of `cobbler check`, it is time to synchronize things for the first time. This is not critical, but a failure to properly sync at this point can reveal a configuration problem.

```
$ cobbler sync
task started: 2012-06-24_224243_sync
task started (id=Sync, time=Sun Jun 24 22:42:43 2012)
running pre-sync triggers
...
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
cleaning link caches
running: find /var/lib/tftpboot/images/.link_cache -maxdepth 1 -type f -links 1 -exec rm -f '{}' ';'
received on stdout:
received on stderr:
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout:
received on stderr:
running: service dhcpd restart
received on stdout:
received on stderr:
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
```

Assuming all went well and no errors were reported, you are ready to move on to the next step.

## 1.7. Importing your first distribution

Cobbler automates adding distributions and profiles via the `cobbler import` command. This command can (usually) automatically detect the type and version of the distribution your importing and create (one or more) profiles with the correct settings for you.

### 1.7.1. Download an ISO image

In order to import a distribution, you will need a DVD ISO for your distribution.

**NOTE:** You must use a full DVD, and not a “Live CD” ISO. For this example, we’ll be using the Fedora 17 x86_64 ISO.

Once this file is downloaded, mount it somewhere:

```
$ mount -t iso9660 -o loop,ro /path/to/isos/Fedora-17-x86_64-DVD.iso /mnt
```

### 1.7.2. Run the import

You are now ready to import the distribution. The name and path arguments are the only required options for import:

```
$ cobbler import --name=fedora17 --arch=x86_64 --path=/mnt
```

The `--arch` option need not be specified, as it will normally be auto-detected. We’re doing so in this example in order to prevent multiple architectures from being found.

#### 1.7.2.1. Listing objects

If no errors were reported during the import, you can view details about the distros and profiles that were created during the import.

```
$ cobbler distro list
$ cobbler profile list
```

The import command will typically create at least one distro/profile pair, which will have the same name as shown above. In some cases (for instance when a Xen-based kernel is found), more than one distro/profile pair will be created.

#### 1.7.2.2. Object details

The report command shows the details of objects in cobbler:

```
$ cobbler distro report --name=fedora17-x86_64
Name                            : fedora17-x86_64
Architecture                    : x86_64
TFTP Boot Files                 : {}
Breed                           : redhat
Comment                         :
Fetchable Files                 : {}
Initrd                          : /var/www/cobbler/distro_mirror/fedora17-x86_64/images/pxeboot/initrd.img
Kernel                          : /var/www/cobbler/distro_mirror/fedora17-x86_64/images/pxeboot/vmlinuz
Kernel Options                  : {}
Kernel Options (Post Install)   : {}
Automatic Installation Template Metadata : {'tree': 'http://@@http_server@@/cblr/links/fedora17-x86_64'}
Management Classes              : []
OS Version                      : fedora17
Owners                          : ['admin']
Red Hat Management Key          : <<inherit>>
Red Hat Management Server       : <<inherit>>
Template Files                  : {}
```

As you can see above, the import command filled out quite a few fields automatically, such as the breed, OS version, and initrd/kernel file locations. The “Automatic Installation Template Metadata” field (`--autoinstall_meta` internally) is used for miscellaneous variables, and contains the critical “tree” variable. This is used in the automated installation templates to specify the URL where the installation files can be found.

Something else to note: some fields are set to `<<inherit>>`. This means they will use either the default setting (found in the settings file), or (in the case of profiles, sub-profiles, and systems) will use whatever is set in the parent object.

#### 1.7.2.3. Creating a system

Now that you have a distro and profile, you can create a system. Profiles can be used to PXE boot, but most of the features in cobbler revolve around system objects. The more information you give about a system, the more cobbler will do automatically for you.

First, we’ll create a system object based on the profile that was created during the import. When creating a system, the name and profile are the only two required fields:

```
$ cobbler system add --name=test --profile=fedora17-x86_64
$ cobbler system list
test
$ cobbler system report --name=test
Name                           : test
TFTP Boot Files                : {}
Comment                        :
Enable gPXE?                   : 0
Fetchable Files                : {}
Gateway                        :
Hostname                       :
Image                          :
IPv6 Autoconfiguration         : False
IPv6 Default Device            :
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Automatic Installation Template: <<inherit>>
Automatic Installation Template Metadata: {}
Management Classes             : []
Management Parameters          : <<inherit>>
Name Servers                   : []
Name Servers Search Path       : []
Netboot Enabled                : True
Owners                         : ['admin']
Power Management Address       :
Power Management ID            :
Power Management Password      :
Power Management Type          : ipmitool
Power Management Username      :
Profile                        : fedora17-x86_64
Proxy                          : <<inherit>>
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos Enabled                  : False
Server Override                : <<inherit>>
Status                         : production
Template Files                 : {}
Virt Auto Boot                 : <<inherit>>
Virt CPUs                      : <<inherit>>
Virt Disk Driver Type          : <<inherit>>
Virt File Size(GB)             : <<inherit>>
Virt Path                      : <<inherit>>
Virt RAM (MB)                  : <<inherit>>
Virt Type                      : <<inherit>>
```

The primary reason for creating a system object is network configuration. When using profiles, you’re limited to DHCP interfaces, but with systems you can specify many more network configuration options.

So now we’ll setup a single, simple interface in the `192.168.1/24` network:

```
$ cobbler system edit --name=test --interface=eth0 --mac=00:11:22:AA:BB:CC --ip-address=192.168.1.100 --netmask=255.255.255.0 --static=1 --dns-name=test.mydomain.com
```

The default gateway isn’t specified per-NIC, so just add that separately (along with the hostname):

```
$ cobbler system edit --name=test --gateway=192.168.1.1 --hostname=test.mydomain.com
```

The `--hostname` field corresponds to the local system name and is returned by the `hostname` command. The `--dns-name` (which can be set per-NIC) should correspond to a DNS A-record tied to the IP of that interface. Neither are required, but it is a good practice to specify both. Some advanced features (like configuration management) rely on the `--dns-name` field for system record look-ups.

Whenever a system is edited, cobbler executes what is known as a “lite sync”, which regenerates critical files like the PXE boot file in the TFTP root directory. One thing it will **NOT** do is execute service management actions, like regenerating the `dhcpd.conf` and restarting the DHCP service. After adding a system with a static interface it is a good idea to execute a full `cobbler sync` to ensure the dhcpd.conf file is rewritten with the correct static lease and the service is bounced.

## Install Guide

 Knowledge in apache configuration (setting up ssl, virtual hosts, apache module and wsgi) is needed. Certificates and some server administration knowledge is required too.

Cobbler is available for installation in several different ways, through packaging systems for each distribution or directly from source.

Cobbler has both definite and optional prerequisites, based on the features you’d like to use. This section documents the definite prerequisites for both a basic installation and when building/installing from source.

## 2.1. Prerequisites

### 2.1.1. Packages

Please note that installing any of the packages here via a package manager (such as dnf/yum or apt) can and will require a large number of ancilary packages, which we do not document here. The package definition should automatically pull these packages in and install them along with Cobbler, however it is always best to verify these requirements have been met prior to installing cobbler or any of its components.

First and foremost, Cobbler requires Python. Any 2.x version should work for 2.8.x releases. Since 3.0.0 you will need Python 3. Cobbler also requires the installation of the following packages:

- createrepo
- httpd / apache2
- xorriso
- mod_wsgi / libapache2-mod-wsgi
- mod_ssl / libapache2-mod-ssl
- python-cheetah
- python-netaddr
- python-simplejson
- PyYAML / python-yaml
- rsync
- syslinux
- tftp-server / atftpd
- yum-utils

Cobbler-web only has one other requirement besides Cobbler itself:

- Django / python-django

Koan can be installed apart from Cobbler, and has only the following requirement (besides python itself of course):

- python-simplejson

### 2.1.2. Source

Installation from source requires the following additional software:

- git
- make
- python-devel
- python-cheetah
- openssl

## 2.2. Installation

Cobbler is available for installation for many Linux variants through their native packaging systems. However, the Cobbler project also provides packages for all supported distributions which is the preferred method of installation.

### 2.2.1. Packages

We leave packaging to downstream; this means you have to check the repositories provided by your distribution vendor. However we provide docker files for

- CentOS 7
- CentOS 8
- Debian 10 Buster

which will give you packages which will work better then building from source yourself.

### 2.2.2. Packages from source

For some platforms it’s also possible to build packages directly from the source tree.

## 2.3. RPM

```
$ make rpms
... (lots of output) ...
Wrote: /path/to/cobbler/rpm-build/cobbler-3.0.0-1.fc20.src.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-3.0.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/koan-3.0.0-1.fc20.noarch.rpm
Wrote: /path/to/cobbler/rpm-build/cobbler-web-3.0.0-1.fc20.noarch.rpm
```

As you can see, an RPM is output for each component of Cobbler, as well as a source RPM. This command was run on a system running Fedora 20, hence the fc20 in the RPM name - this will be different based on the distribution you’re running.

## 2.4. DEB

To install Cobbler from source on a Debian-Based system, the following steps need to be made (tested on Debian Buster):

```
$ apt-get -y install make git
$ apt-get -y install python3-yaml python3-cheetah python3-netaddr python3-simplejson
$ apt-get -y install python3-future python3-distro python3-setuptools python3-sphinx python3-coverage
$ apt-get -y install pyflakes3 python3-pycodestyle
$ apt-get -y install apache2 libapache2-mod-wsgi-py3
$ apt-get -y install atftpd
# In case you want cobbler-web
$ apt-get -y install python3-django

$ a2enmod proxy
$ a2enmod proxy_http
$ a2enmod rewrite

$ ln -s /srv/tftp /var/lib/tftpboot

$ systemctl restart apache2
```

Change all `/var/www/cobbler` in `/etc/apache2/conf.d/cobbler.conf` to `/usr/share/cobbler/webroot/` Init script: - add Required-Stop line - path needs to be `/usr/local/...` or fix the install location

### 2.4.1. Source

The latest source code is available through git:

```
$ git clone https://github.com/cobbler/cobbler.git
$ cd cobbler
```

The release30 branch corresponds to the official release version for the 3.0.x series. The master branch is the development series, and always uses an odd number for the minor version (for example, 3.1.0).

When building from source, make sure you have the correct prerequisites. Once they are, you can install Cobbler with the following command:

```
$ make install
```

This command will rewrite all configuration files on your system if you have an existing installation of Cobbler (whether it was installed via packages or from an older source tree). To preserve your existing configuration files, snippets and automatic installation files, run this command:

```
$ make devinstall
```

To install the Cobbler web GUI, use this command:

```
$ make webtest
```

This will do a full install, not just the web GUI. `make webtest` is a wrapper around `make devinstall`, so your configuration files will also be saved when running this command. Be adviced that we don’t copy the service file into the correct directory and that the path to the binary may be wrong depending on the location of the binary on your system. Do this manually and then you should be good to go. The same is valid for the Apache2 webserver config.

Also note that this is not enough to run Cobbler-Web. Cobbler web needs the directories `/usr/share/cobbler/web` with the file `cobbler.wsgi` in it. This is currently a manual step. Also remember to manually enter a value for `SECRET_KEY` in `settings.py` and copy that to above mentioned directory as well as the templates directory.



## 2.5. Relocating your installation

Often folks don’t have a very large `/var` partition, which is what Cobbler uses by default for mirroring install trees and the like.

You’ll notice you can reconfigure the webdir location just by going into `/etc/cobbler/settings`, but it’s not the best way to do things – especially as the packaging process does include some files and directories in the stock path. This means that, for upgrades and the like, you’ll be breaking things somewhat. Rather than attempting to reconfigure Cobbler, your Apache configuration, your file permissions, and your SELinux rules, the recommended course of action is very simple.

1. Copy everything you have already in `/var/www/cobbler` to another location – for instance, `/opt/cobbler_data`
2. Now just create a symlink or bind mount at `/var/www/cobbler` that points to `/opt/cobbler_data`.

Done. You’re up and running.

If you decided to access Cobbler’s data store over NFS (not recommended) you really want to mount NFS on `/var/www/cobbler` with SELinux context passed in as a parameter to mount versus the symlink. You may also have to deal with problems related to rootsquash. However if you are making a mirror of a Cobbler server for a multi-site setup, mounting read only is OK there.

Also Note: `/var/lib/cobbler` can not live on NFS, as this interferes with locking (“flock”) Cobbler does around it’s storage files.



# 3. Cobbler CLI

This page contains a description for commands which can be used from the CLI.

## 3.1. General Principles

This should just be a brief overview. For the detailed explanations please refer to [Readthedocs](https://cobbler.readthedocs.io/).

### 3.1.1. Distros, Profiles and Systems

Cobbler has a system of inheritance when it comes to managing the information you want to apply to a certain system.

### 3.1.2. Images

### 3.1.3. Repositories

### 3.1.4. Management Classes

### 3.1.5. Deleting configuration entries

If you want to remove a specific object, use the remove command with the name that was used to add it.

```
cobbler distro|profile|system|repo|image|mgmtclass|package|file remove --name=string
```

### 3.1.6. Editing

If you want to change a particular setting without doing an `add` again, use the `edit` command, using the same name you gave when you added the item. Anything supplied in the parameter list will overwrite the settings in the existing object, preserving settings not mentioned.

```
cobbler distro|profile|system|repo|image|mgmtclass|package|file edit --name=string [parameterlist]
```

### 3.1.7. Copying

Objects can also be copied:

```
cobbler distro|profile|system|repo|image|mgmtclass|package|file copy --name=oldname --newname=newname
```

### 3.1.8. Renaming

Objects can also be renamed, as long as other objects don’t reference them.

```
cobbler distro|profile|system|repo|image|mgmtclass|package|file rename --name=oldname --newname=newname
```

## 3.2. CLI-Commands

Short Usage: `cobbler command [subcommand] [--arg1=value1] [--arg2=value2]`

Long Usage:

```
cobbler <distro|profile|system|repo|image|mgmtclass|package|file> ... [add|edit|copy|get-autoinstall*|list|remove|rename|report] [options|--help]
cobbler <aclsetup|buildiso|import|list|replicate|report|reposync|sync|validate-autoinstalls|version|signature|get-loaders|hardlink> [options|--help]
```

### 3.2.1. cobbler distro

This first step towards configuring what you want to install is to add a distribution record to cobbler’s configuration.

If there is an rsync mirror, DVD, NFS, or filesystem tree available that you would rather `import` instead, skip down to the documentation about the `import` command. It’s really a lot easier to follow the import workflow – it only requires waiting for the mirror content to be copied and/or scanned. Imported mirrors also save time during install since they don’t have to hit external install sources.

If you want to be explicit with distribution definition, however, here’s how it works:

```
$ cobbler distro add --name=string --kernel=path --initrd=path [--kopts=string] [--kopts-post=string] [--ksmeta=string] [--arch=i386|x86_64|ppc|ppc64] [--breed=redhat|debian|suse] [--template-files=string]
```

| Name                | Description                                                  |
| ------------------- | ------------------------------------------------------------ |
| name                | a string identifying the distribution, this should be something like `rhel6`. |
| kernel              | An absolute filesystem path to a kernel image.               |
| initrd              | An absolute filesystem path to a initrd image.               |
| remote-boot- kernel | A URL pointing to the installation initrd of a distribution. If the bootloader has this support, it will directly download the kernel from this URL, instead of the directory of the tftp client. Note: The kernel (or initrd below) will still be copied into the image directory of the tftp server. The above kernel parameter is still needed (e.g. to build iso images, etc.). The advantage of letting the boot loader retrieve the kernel/initrd directly is the support of changing/updated distributions. E.g. openSUSE Tumbleweed is updated on the fly and if cobbler would copy/cache the kernel/initrd in the tftp directory, you would get a “kernel does not match distribution” (or similar) error when trying to install. |
| remote-boot- initrd | See remote-boot-kernel above.                                |
| kopts               | Sets kernel command-line arguments that the distro, and profiles/systems depending on it, will use. To remove a kernel argument that may be added by a higher cobbler object (or in the global settings), you can prefix it with a `!`. |
|                     | Example: `--kopts="foo=bar baz=3 asdf !gulp"`                |
|                     | This example passes the arguments `foo=bar baz=3 asdf` but will make sure `gulp` is not passed even if it was requested at a level higher up in the cobbler configuration. |
| kopts-post          | This is just like `--kopts`, though it governs kernel options on the installed OS, as opposed to kernel options fed to the installer. The syntax is exactly the same. This requires some special snippets to be found in your automatic installation template in order for this to work. Automatic installation templating is described later on in this document. |
|                     | Example: `noapic`                                            |
| arch                | Sets the architecture for the PXE bootloader and also controls how koan’s `--replace-self` option will operate. |
|                     | The default setting (`standard`) will use `pxelinux`. Set to `ppc` and `ppc64` to use `yaboot`. |
|                     | `x86` and `x86_64` effectively do the same thing as standard. |
|                     | If you perform a `cobbler import`, the arch field will be auto-assigned. |
| ksmeta              | This is an advanced feature that sets automatic installation template variables to substitute, thus enabling those files to be treated as templates. Templates are powered using Cheetah and are described further along in this manpage as well as on the Cobbler Wiki. |
|                     | Example: `--ksmeta="foo=bar baz=3 asdf"`                     |
|                     | See the section on “Kickstart Templating” for further information. |
| breed               | Controls how various physical and virtual parameters, including kernel arguments for automatic installation, are to be treated. Defaults to `redhat`, which is a suitable value for Fedora and CentOS as well. It means anything Red Hat based. |
|                     | There is limited experimental support for specifying “debian”, “ubuntu”, or “suse”, which treats the automatic installation template file as a preseed/autoyast file format and changes the kernel arguments appropriately. Support for other types of distributions is possible in the future. See the Wiki for the latest information about support for these distributions. |
|                     | The file used for the answer file, regardless of the breed setting, is the value used for `--autoinst` when creating the profile. |
| os-version          | Generally this field can be ignored. It is intended to alter some hardware setup for virtualized instances when provisioning guests with koan. The valid options for `--os-version` vary depending on what is specified for `--breed`. If you specify an invalid option, the error message will contain a list of valid os versions that can be used. If you don’t know the os version or it does not appear in the list, omitting this argument or using `other` should be perfectly fine. If you don’t encounter any problems with virtualized instances, this option can be safely ignored. |
| owners              | Users with small sites and a limited number of admins can probably ignore this option.  All cobbler objects (distros, profiles, systems, and repos) can take a –owners parameter to specify what cobbler users can edit particular objects.This only applies to the Cobbler WebUI and XMLRPC interface, not the “cobbler” command line tool run from the shell. Furthermore, this is only respected by the `authz_ownership` module which must be enabled in `/etc/cobbler/modules.conf`. The value for `--owners` is a space separated list of users and groups as specified in `/etc/cobbler/users.conf`. For more information see the users.conf file as well as the Cobbler Wiki. In the default Cobbler configuration, this value is completely ignored, as is `users.conf`. |
| template-files      | This feature allows cobbler to be used as a configuration management system. The argument is a space delimited string of `key=value` pairs. Each key is the path to a template file, each value is the path to install the file on the system. This is described in further detail on the Cobbler Wiki and is implemented using special code in the post install. Koan also can retrieve these files from a cobbler server on demand, effectively allowing cobbler to function as a lightweight templated configuration management system. |

### 3.2.2. cobbler profile

A profile associates a distribution to additional specialized options, such as a installation automation file. Profiles are the core unit of provisioning and at least one profile must exist for every distribution to be provisioned. A profile might represent, for instance, a web server or desktop configuration. In this way, profiles define a role to be performed.

```
$ cobbler profile add --name=string --distro=string [--autoinst=path] [--kopts=string] [--ksmeta=string] [--name-servers=string] [--name-servers-search=string] [--virt-file-size=gigabytes] [--virt-ram=megabytes] [--virt-type=string] [--virt-cpus=integer] [--virt-path=string] [--virt-bridge=string] [--server] [--parent=profile] [--filename=string]
```

Arguments are the same as listed for distributions, save for the removal of “arch” and “breed”, and with the additions listed below:

| Name                                                         | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| name                                                         | A descriptive name. This could be something like `rhel5webservers` or `f9desktops`. |
| distro                                                       | The name of a previously defined cobbler distribution. This value is required. |
| autoinst                                                     | Local filesystem path to a automatic installation file, the file must reside under `/var/lib/cobbler/autoinstall_templates` |
| name-servers                                                 | If your nameservers are not provided by DHCP, you can specify a space separated list of addresses here to configure each of the installed nodes to use them (provided the automatic installation files used are installed on a per-system basis). Users with DHCP setups should not need to use this option. This is available to set in profiles to avoid having to set it repeatedly for each system record. |
| name-servers-search                                          | You can specify a space separated list of domain names to configure each of the installed nodes to use them as domain search path.  This is available to set in profiles to avoid having to set it repeatedly for each system record. |
| virt-file-size                                               | (Virt-only) How large the disk image should be in Gigabytes. The default is 5. This can be a comma separated list (ex: `5,6,7`) to allow for multiple disks of different sizes depending on what is given to `--virt-path`. This should be input as a integer or decimal value without units. |
| virt-ram                                                     | (Virt-only) How many megabytes of RAM to consume. The default is 512 MB. This should be input as an integer without units. |
| virt-type                                                    | (Virt-only) Koan can install images using either Xen paravirt (`xenpv`) or QEMU/KVM (`qemu`). Choose one or the other strings to specify, or values will default to attempting to find a compatible installation type on the client system(“auto”). See the “koan” manpage for more documentation. The default `--virt-type` can be configured in the cobbler settings file such that this parameter does not have to be provided. Other virtualization types are supported, for information on those options (such as VMware), see the Cobbler Wiki. |
| virt-cpus                                                    | (Virt-only) How many virtual CPUs should koan give the virtual machine? The default is 1. This is an integer. |
| virt-path                                                    | (Virt-only) Where to store the virtual image on the host system. Except for advanced cases, this parameter can usually be omitted. For disk images, the value is usually an absolute path to an existing directory with an optional filename component. There is support for specifying partitions `/dev/sda4` or volume groups `VolGroup00`, etc. |
|                                                              | For multiple disks, separate the values with commas such as `VolGroup00,VolGroup00` or `/dev/sda4,/dev/sda5`. Both those examples would create two disks for the VM. |
| virt-bridge                                                  | (Virt-only) This specifies the default bridge to use for all systems defined under this profile. If not specified, it will assume the default value in the cobbler settings file, which as shipped in the RPM is `xenbr0`. If using KVM, this is most likely not correct. You may want to override this setting in the system object. Bridge settings are important as they define how outside networking will reach the guest. For more information on bridge setup, see the Cobbler Wiki, where there is a section describing koan usage. |
| repos                                                        | This is a space delimited list of all the repos (created with `cobbler repo add` and updated with `cobbler reposync`)that this profile can make use of during automated installation. For example, an example might be `--repos="fc6i386updates fc6i386extras"` if the profile wants to access these two mirrors that are already mirrored on the cobbler server. Repo management is described in greater depth later in the manpage. |
| parent                                                       | This is an advanced feature.                                 |
|                                                              | Profiles may inherit from other profiles in lieu of specifying `--distro`. Inherited profiles will override any settings specified in their parent, with the exception of `--ksmeta` (templating) and `--kopts` (kernel options), which will be blended together. |
|                                                              | Example: If profile A has `--kopts="x=7 y=2"`, B inherits from A, and B has `--kopts="x=9 z=2"`, the actual kernel options that will be used for B are `x=9 y=2 z=2`. |
|                                                              | Example: If profile B has `--virt-ram=256` and A has `--virt-ram=512`, profile B will use the value 256. |
|                                                              | Example: If profile A has a `--virt-file-size=5` and B does not specify a size, B will use the value from A. |
| server                                                       | This parameter should be useful only in select circumstances. If machines are on a subnet that cannot access the cobbler server using the name/IP as configured in the cobbler settings file, use this parameter to override that servername. See also `--dhcp-tag` for configuring the next server and DHCP information of the system if you are also usingCobbler to help manage your DHCP configuration. |
| filename            \| This parameter can be used to select the bootloader for network boot. If specified, this must be a path relative to the tftp servers root directory. (e.g. grub/grubx64.efi) For most use cases the default bootloader is correct and this can be omitted |                                                              |

### 3.2.3. cobbler system

System records map a piece of hardware (or a virtual machine) with the cobbler profile to be assigned to run on it. This may be thought of as choosing a role for a specific system.

Note that if provisioning via koan and PXE menus alone, it is not required to create system records in cobbler, though they are useful when system specific customizations are required. One such customization would be defining the MAC address. If there is a specific role intended for a given machine, system records should be created for it.

System commands have a wider variety of control offered over network details. In order to use these to the fullest possible extent, the automatic installation template used by cobbler must contain certain automatic installation snippets (sections of code specifically written for Cobbler to make these values become reality). Compare your automatic installation templates with the stock ones in /var/lib/cobbler/autoinstall_templates if you have upgraded, to make sure you can take advantage of all options to their fullest potential. If you are a new cobbler user, base your automatic installation templates off of these templates.

Read more about networking setup at: [https://cobbler.readthedocs.io/en/release28/4_advanced/advanced%20networking.html](https://cobbler.readthedocs.io/en/release28/4_advanced/advanced networking.html)

Example:

```
$ cobbler system add --name=string --profile=string [--mac=macaddress] [--ip-address=ipaddress] [--hostname=hostname] [--kopts=string] [--ksmeta=string] [--autoinst=path] [--netboot-enabled=Y/N] [--server=string] [--gateway=string] [--dns-name=string] [--static-routes=string] [--power-address=string] [--power-type=string] [--power-user=string] [--power-pass=string] [--power-id=string]
```

Adds a cobbler System to the configuration. Arguments are specified as per “profile add” with the following changes:

| Name                                                         | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| name                                                         | The system name works like the name option for other commands. |
|                                                              | If the name looks like a MAC address or an IP, the name will  implicitly be used for either –mac or –ip of the first interface,  respectively. However, it’s usually better to give a descriptive name –  don’t rely on this behavior. |
|                                                              | A system created with name “default” has special semantics. If a  default system object exists, it sets all undefined systems to PXE to a  specific profile.  Without a “default” system name created, PXE will  fall through to local boot for unconfigured systems. |
|                                                              | When using “default” name, don’t specify any other arguments than –profile … they won’t be used. |
| mac                                                          | Specifying a mac address via –mac allows the system object to boot  directly to a specific profile via PXE, bypassing cobbler’s PXE menu.   If the name of the cobbler system already looks like a mac address, this is inferred from the system name and does not need to be specified. |
|                                                              | MAC addresses have the format AA:BB:CC:DD:EE:FF. It’s highly  recommended to register your MAC-addresses in Cobbler if you’re using  static addressing with multiple interfaces, or if you are using any of  the advanced networking features like bonding, bridges or VLANs. |
|                                                              | Cobbler does contain a feature (enabled in /etc/cobbler/settings)  that can automatically add new system records when it finds profiles  being provisioned on hardware it has seen before.  This may help if you  do not have a report of all the MAC addresses in your datacenter/lab  configuration. |
| ip-address                                                   | If cobbler is configured to generate a DHCP configuration (see  advanced section), use this setting to define a specific IP for this  system in DHCP.  Leaving off this parameter will result in no DHCP  management for this particular system. |
|                                                              | Example: –ip-address=192.168.1.50                            |
|                                                              | If DHCP management is disabled and the interface is labelled –static=1, this setting will be used for static IP configuration. |
|                                                              | Special feature: To control the default PXE behavior for an entire  subnet, this field can also be passed in using CIDR notation.  If –ip is CIDR, do not specify any other arguments other than –name and –profile. |
|                                                              | When using the CIDR notation trick, don’t specify any arguments other than –name and –profile… they won’t be used. |
| dns-name                                                     | If using the DNS management feature (see advanced section – cobbler  supports auto-setup of BIND and dnsmasq), use this to define a hostname  for the system to receive from DNS. |
|                                                              | Example: –dns-name=mycomputer.example.com                    |
|                                                              | This is a per-interface parameter.  If you have multiple interfaces, it may be different for each interface, for example, assume a DMZ /  dual-homed setup. |
| gateway and netmask                                          | If you are using static IP configurations and the interface is flagged –static=1, these will be applied. |
|                                                              | Netmask is a per-interface parameter. Because of the way gateway is  stored on the installed OS, gateway is a global parameter. You may use  –static-routes for per-interface customizations if required. |
| if-gateway                                                   | If you are using static IP configurations and have multiple interfaces, use this to define different gateway for each interface. |
|                                                              | This is a per-interface setting.                             |
| hostname                                                     | This field corresponds to the hostname set in a systems  /etc/sysconfig/network file.  This has no bearing on DNS, even when  manage_dns is enabled.  Use –dns-name instead for that feature. |
|                                                              | This parameter is assigned once per system, it is not a per-interface setting. |
| power-address, power-type, power-user, power-pass, power-id  | Cobbler contains features that enable integration with power  management for easier installation, reinstallation, and management of  machines in a datacenter environment.  These parameters are described  online at [Power Management](https://cobbler.readthedocs.io/en/latest/user-guide.html#power-management). If you have a power-managed datacenter/lab setup, usage of these features may be something you are interested in. |
| static                                                       | Indicates that this interface is statically configured.  Many fields (such as gateway/netmask) will not be used unless this field is  enabled. |
|                                                              | This is a per-interface setting.                             |
| static-routes                                                | This is a space delimited list of ip/mask:gateway routing  information in that format. Most systems will not need this information. |
|                                                              | This is a per-interface setting.                             |
| virt-bridge                                                  | (Virt-only) While –virt-bridge is present in the profile object (see above), here it works on an interface by interfacebasis. For instance  it would be possible to have –virt-bridge0=xenbr0 and  –virt-bridge1=xenbr1. If not specified in cobbler for each interface,  koan will use the value as specified in the profile for each interface,  which may not always be what is intended, but will be sufficient in most cases. |
|                                                              | This is a per-interface setting.                             |
| autoinst                                                     | While it is recommended that the –autoinst parameter is only used  within for the “profile add” command, there are limited scenarios when  an install base switching to cobbler may have legacy automatic  installation files created on aper-system basis (one automatic  installation file for each system, nothing shared) and may not want to  immediately make use of the cobbler templating system. This allows  specifying a automatic installation file for use on a per-system basis.  Creation of a parent profile is still required.  If the automatic  installation file is a filesystem location, it will still be treated as a cobbler template. |
| netboot-enabled                                              | If set false, the system will be provisionable through koan but not  through standard PXE. This will allow the system to fall back to default PXE boot behavior without deleting the cobbler system object. The  default value allows PXE. Cobbler contains a PXE boot loop prevention  feature (pxe_just_once, can be enabled in /etc/cobbler/settings) that  can automatically trip off this value after a system gets done  installing. This can prevent installs from appearing in an endless loop  when the system is set to PXE first in the BIOS order. |
| repos-enabled                                                | If set true, koan can reconfigure repositories after installation.  This is described further on the Cobbler  Wiki,https://github.com/cobbler/cobbler/wiki/Manage-yum-repos. |
| dhcp-tag                                                     | If you are setting up a PXE environment with multiple  subnets/gateways, and are using cobbler to manage a DHCP configuration,  you will probably want to use this option. If not, it can be ignored. |
|                                                              | By default, the dhcp tag for all systems is “default” and means that in the DHCP template files the systems will expand out where  $insert_cobbler_systems_definitions is found in the DHCP template.  However, you may want certain systems to expand out in other places in  the DHCP config file.  Setting –dhcp-tag=subnet2 for instance, will  cause that system to expand out where  $insert_cobbler_system_definitions_subnet2 is found, allowing you to  insert directives to specify different subnets (or other parameters)  before the DHCP configuration entries for those particular systems. |
|                                                              | This is described further on the Cobbler Wiki.               |
| interface                                                    | By default flags like –ip, –mac, –dhcp-tag, –dns-name, –netmask,  –virt-bridge, and –static-routes operate on the first network interface  defined for a system (eth0). However, cobbler supports an arbitrary  number of interfaces. Using–interface=eth1 for instance, will allow  creating and editing of a second interface. |
|                                                              | Interface naming notes:                                      |
|                                                              | Additional interfaces can be specified (for example: eth1, or any  name you like, as long as it does not conflict with any reserved names  such as kernel module names) for use with the edit command. Defining  VLANs this way is also supported, of you want to add VLAN 5 on interface eth0, simply name your interface eth0.5. |
|                                                              | Example:                                                     |
|                                                              | cobbler system edit –name=foo –ip-address=192.168.1.50 –mac=AA:BB:CC:DD:EE:A0 |
|                                                              | cobbler system edit –name=foo –interface=eth0 –ip-address=192.168.1.51 –mac=AA:BB:CC:DD:EE:A1 |
|                                                              | cobbler system report foo                                    |
|                                                              | Interfaces can be deleted using the –delete-interface option. |
|                                                              | Example:                                                     |
|                                                              | cobbler system edit –name=foo –interface=eth2 –delete-interface |
| interface-type, interface-master and bonding-opts/bridge-opts | One of the other advanced networking features supported by Cobbler  is NIC bonding, bridging and BMC. You can use this to bond multiple  physical network interfaces to one single logical interface to reduce  single points of failure in your network, to create bridged interfaces  for things like tunnels and virtual machine networks, or to manage BMC  interface by DHCP. Supported values for the –interface-type parameter  are “bond”, “bond_slave”, “bridge”, “bridge_slave”,”bonded_bridge_slave” and “bmc”.  If one of the “_slave” options is specified, you also need  to define the master-interface for this bond using  –interface-master=INTERFACE. Bonding and bridge options for the  master-interface may be specified using –bonding-opts=”foo=1 bar=2” or  –bridge-opts=”foo=1 bar=2”. |
|                                                              | Example:                                                     |
|                                                              | cobbler system edit –name=foo –interface=eth0 –mac=AA:BB:CC:DD:EE:00 –interface-type=bond_slave –interface-master=bond0 |
|                                                              | cobbler system edit –name=foo –interface=eth1 –mac=AA:BB:CC:DD:EE:01 –interface-type=bond_slave –interface-master=bond0 |
|                                                              | cobbler system edit –name=foo –interface=bond0 –interface-type=bond  –bonding-opts=”mode=active-backup miimon=100” –ip-address=192.168.0.63  –netmask=255.255.255.0 –gateway=192.168.0.1 –static=1 |
|                                                              | More information about networking setup is available at https://github.com/cobbler/cobbler/wiki/Advanced-networking |
|                                                              | To review what networking configuration you have for any object, run “cobbler system report” at any time: |
|                                                              | Example:                                                     |
|                                                              | cobbler system report –name=foo                              |

### 3.2.4. cobbler repo

Repository mirroring allows cobbler to mirror not only install trees (“cobbler import” does this for you) but also optional packages, 3rd party content, and even updates. Mirroring all of this content locally on your network will result in faster, more up-to-date installations and faster updates. If you are only provisioning a home setup, this will probably be overkill, though it can be very useful for larger setups (labs, datacenters, etc).

```
$ cobbler repo add --mirror=url --name=string [--rpmlist=list] [--creatrepo-flags=string] [--keep-updated=Y/N] [--priority=number] [--arch=string] [--mirror-locally=Y/N] [--breed=yum|rsync|rhn]
```

| Name             | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| mirror           | The address of the yum mirror. This can be an `rsync://`-URL, an ssh location, or a `http://` or `ftp://` mirror location. Filesystem paths also work. |
|                  | The mirror address should specify an exact repository to mirror – just one architecture and just one distribution. If you have a separate repo to mirror for a different arch, add that repo separately. |
|                  | Here’s an example of what looks like a good URL:             |
|                  | `rsync://yourmirror.example.com/fedora-linux-core/updates/6/i386` (for rsync protocol) `http://mirrors.kernel.org/fedora/extras/6/i386/` (for http) `user@yourmirror.example.com/fedora-linux-core/updates/6/i386`  (for SSH) |
|                  | Experimental support is also provided for mirroring RHN content when you need a fast local mirror. The mirror syntax for this is `--mirror=rhn://channel-name` and you must have entitlements for this to work. This requires the cobbler server to be installed on RHEL5 or later. You will also need a version of `yum-utils` equal or greater to 1.0.4. |
| name             | This name is used as the save location for the mirror. If the mirror represented, say, Fedora Core 6 i386 updates, a good name would be `fc6i386updates`. Again, be specific. |
|                  | This name corresponds with values given to the `--repos` parameter of `cobbler profile add`. If a profile has a `--repos`-value that matches the name given here, that repo can be automatically set up during provisioning (when supported) and installed systems will also use the boot server as a mirror (unless `yum_post_install_mirror` is disabled in the settings file). By default the provisioning server will act as a mirror to systems it installs, which may not be desirable for laptop configurations, etc. |
|                  | Distros that can make use of yum repositories during automatic installation include FC6 and later, RHEL 5 and later, and derivative distributions. |
|                  | See the documentation on `cobbler profile add` for more information. |
| rpm-list         | By specifying a space-delimited list of package names for `--rpm-list`, one can decide to mirror only a part of a repo (the list of packages given, plus dependencies). This may be helpful in conserving time/space/bandwidth. For instance, when mirroring FC6 Extras, it may be desired to mirror just cobbler and koan, and skip all of the game packages. To do this, use `--rpm-list="cobbler koan"`. |
|                  | This option only works for `http://` and `ftp://` repositories (as it is powered by yumdownloader). It will be ignored for other mirror types, such as local paths and `rsync://` mirrors. |
| createrepo-flags | Specifies optional flags to feed into the createrepo tool, which is called when `cobbler reposync` is run for the given repository. The defaults are `-c cache`. |
| keep-updated     | Specifies that the named repository should not be updated during a normal “cobbler reposync”. The repo may still be updated by name. The repo should be synced at least once before disabling this feature. See “cobbler reposync” below. |
| mirror-locally   | When set to `N`, specifies that this yum repo is to be referenced directly via automatic installation files and not mirrored locally on the cobbler server. Only `http://` and `ftp://` mirror urls are supported when using `--mirror-locally=N`, you cannot use filesystem URLs. |
| priority         | Specifies the priority of the repository (the lower the number, the higher the priority), which applies to installed machines using the repositories that also have the yum priorities plugin installed. The default priority for the plugins 99, as is that of all cobbler mirrored repositories. |
| arch             | Specifies what architecture the repository should use. By default the current system arch (of the server) is used,which may not be desirable. Using this to override the default arch allows mirroring of source repositories(using `--arch=src`). |
| yumopts          | Sets values for additional yum options that the repo should use on installed systems. For instance if a yum plugin takes a certain parameter “alpha” and “beta”, use something like `--yumopts="alpha=2 beta=3"`. |
| breed            | Ordinarily cobbler’s repo system will understand what you mean without supplying this parameter, though you can set it explicitly if needed. |

### 3.2.5. cobbler image

Example:

```
$ cobbler image
```

### 3.2.6. cobbler mgmtclass

Management classes allows cobbler to function as an configuration management system. Cobbler currently supports the following resource types:

1. Packages
2. Files

Resources are executed in the order listed above.

```
$ cobbler mgmtclass add --name=string --comment=string [--packages=list] [--files=list]
```

| Name     | Description                                                  |
| -------- | ------------------------------------------------------------ |
| name     | The name of the mgmtclass. Use this name when adding a management class to a system, profile, or distro. To add a mgmtclass to an existing system use something like (`cobbler system edit --name="madhatter" --mgmt-classes="http mysql"`). |
| comment  | A comment that describes the functions of the management class. |
| packages | Specifies a list of package resources required by the management class. |
| files    | Specifies a list of file resources required by the management class. |

### 3.2.7. cobbler package

Package resources are managed using `cobbler package add`

Actions:

| Name      | Description                    |
| --------- | ------------------------------ |
| install   | Install the package. [Default] |
| uninstall | Uninstall the package.         |

Attributes:

| Name      | Description                                             |
| --------- | ------------------------------------------------------- |
| installer | Which package manager to use, vaild options [rpm\|yum]. |
| version   | Which version of the package to install.                |

Example:

```
$ cobbler package add --name=string --comment=string [--action=install|uninstall] --installer=string [--version=string]
```

### 3.2.8. cobbler file

Actions:

| Name   | Description                |
| ------ | -------------------------- |
| create | Create the file. [Default] |
| remove | Remove the file.           |

Attributes:

| Name     | Description                    |
| -------- | ------------------------------ |
| mode     | Permission mode (as in chmod). |
| group    | The group owner of the file.   |
| user     | The user for the file.         |
| path     | The path for the file.         |
| template | The template for the file.     |

Example:

```
$ cobbler file add --name=string --comment=string [--action=string] --mode=string --group=string --owner=string --path=string [--template=string]
```

### 3.2.9. cobbler aclsetup

Example:

```
$ cobbler aclsetup
```

### 3.2.10. cobbler buildiso

Example:

```
$ cobbler buildiso
```

### 3.2.11. cobbler import

Example:

```
$ cobbler import
```

### 3.2.12. cobbler list

This list all the names grouped by type. Identically to `cobbler report` there are subcommands for most of the other cobbler commands. (Currently: distro, profile, system, repo, image, mgmtclass, package, file)

```
$ cobbler list
```

### 3.2.13. cobbler replicate

Cobbler can replicate configurations from a master cobbler server. Each cobbler server is still expected to have a locally relevant `/etc/cobbler/cobbler.conf` and `modules.conf`, as these files are not synced.

This feature is intended for load-balancing, disaster-recovery, backup, or multiple geography support.

Cobbler can replicate data from a central server.

Objects that need to be replicated should be specified with a pattern, such as `--profiles="webservers* dbservers*"` or `--systems="*.example.org"`. All objects matched by the pattern, and all dependencies of those objects matched by the pattern (recursively) will be transferred from the remote server to the central server. This is to say if you intend to transfer `*.example.org` and the definition of the systems have not changed, but a profile above them has changed, the changes to that profile will also be transferred.

In the case where objects are more recent on the local server, those changes will not be overridden locally.

Common data locations will be rsync’ed from the master server unless `--omit-data` is specified.

To delete objects that are no longer present on the master server, use `--prune`.

**Warning**: This will delete all object types not present on the remote server from the local server, and is recursive. If you use prune, it is best to manage cobbler centrally and not expect changes made on the slave servers to be preserved. It is not currently possible to just prune objects of a specific type.

Example:

```
$ cobbler replicate --master=cobbler.example.org [--distros=pattern] [--profiles=pattern] [--systems=pattern] [--repos-pattern] [--images=pattern] [--prune] [--omit-data]
```

### 3.2.14. cobbler report

This lists all configuration which cobbler can obtain from the saved data. There are also `report` subcommands for most of the other cobbler commands. (Currently: distro, profile, system, repo, image, mgmtclass, package, file)

```
$ cobbler report --name=[object-name]
```

–name=[object-name]

Optional parameter which filters for object with the given name.

### 3.2.15. cobbler reposync

Example:

```
$ cobbler reposync
```

### 3.2.16. cobbler sync

The sync command is very important, though very often unnecessary for most situations. It’s primary purpose is to force a rewrite of all configuration files, distribution files in the TFTP root, and to restart managed services. So why is it unnecessary? Because in most common situations (after an object is edited, for example), Cobbler executes what is known as a “lite sync” which rewrites most critical files.

When is a full sync required? When you are using `manage_dhcpd` (Managing DHCP) with systems that use static leases. In that case, a full sync is required to rewrite the `dhcpd.conf` file and to restart the dhcpd service.

Cobbler sync is used to repair or rebuild the contents `/tftpboot` or `/var/www/cobbler` when something has changed behind the scenes. It brings the filesystem up to date with the configuration as understood by cobbler.

Sync should be run whenever files in `/var/lib/cobbler` are manually edited (which is not recommended except for the settings file) or when making changes to automatic installation files. In practice, this should not happen often, though running sync too many times does not cause any adverse effects.

If using cobbler to manage a DHCP and/or DNS server (see the advanced section of this manpage), sync does need to be run after systems are added to regenerate and reload the DHCP/DNS configurations.

The sync process can also be kicked off from the web interface.

Example:

```
$ cobbler sync
```

### 3.2.17. cobbler validate-autoinstalls

Example:

```
$ cobbler validate-autoinstalls
```

### 3.2.18. cobbler version

Example:

```
$ cobbler version
```

### 3.2.19. cobbler signature

Example:

```
$ cobbler signature
```

### 3.2.20. cobbler get-loaders

Example:

```
$ cobbler get-loaders
```

### 3.2.21. cobbler hardlink

Example:

```
$ cobbler hardlink
```

## 3.3. EXIT_STATUS

cobbler’s command line returns a zero for success and non-zero for failure.

## 3.4. Additional Help

We have a Gitter Channel and you also can ask questions as GitHub-Issues. The IRC Channel on Freenode (#cobbler) is not that active but sometimes there are people who can help you.

The way we would prefer are GitHub-Issues as they are easily searchable.



# 4. Cobblerd

cobbler - a provisioning and update server

## 4.1. Preamble

We will reefer to cobblerd here as “cobbler” because cobblerd is short for cobbler-daemon which is basically the server. The CLI will be referred to as Cobbler-CLI and Koan as Koan.

## 4.2. Description

Cobbler manages provisioning using a tiered concept of Distributions, Profiles, Systems, and (optionally) Images and Repositories.

Distributions contain information about what kernel and initrd are used, plus metadata (required kernel parameters, etc).

Profiles associate a Distribution with an automated installation template file and optionally customize the metadata further.

Systems associate a MAC, IP, and other networking details with a profile and optionally customize the metadata further.

Repositories contain yum mirror information. Using cobbler to mirror repositories is an optional feature, though provisioning and package management share a lot in common.

Images are a catch-all concept for things that do not play nicely in the “distribution” category.  Most users will not need these records initially and these are described later in the document.

The main advantage of cobbler is that it glues together many disjoint technologies and concepts and abstracts the user from the need to understand them. It allows the systems administrator to concentrate on what he needs to do, and not how it is done.

This manpage will focus on the cobbler command line tool for use in configuring cobbler. There is also mention of the Cobbler WebUI which is usable for day-to-day operation of Cobbler once installed/configured. Docs on the API and XMLRPC components are available online at https://cobbler.github.io or https://cobbler.readthedocs.io

Most users will be interested in the Web UI and should set it up, though the command line is needed for initial configuration – in particular `cobbler check` and `cobbler import`, as well as the repo mirroring features. All of these are described later in the documentation.

## 4.3. Setup

After installing, run `cobbler check` to verify that cobbler’s ecosystem is configured correctly. Cobbler check will direct you on how to modify it’s config files using a text editor.

Any problems detected should be corrected, with the potential exception of DHCP related warnings where you will need to use your judgement as to whether they apply to your environment. Run `cobbler sync` after making any changes to the configuration files to ensure those changes are applied to the environment.

It is especially important that the server name field be accurate in `/etc/cobbler/settings`, without this field being correct, automatic installation trees will not be found, and automated installations will fail.

For PXE, if DHCP is to be run from the cobbler server, the DHCP configuration file should be changed as suggested by `cobbler check`. If DHCP is not run locally, the `next-server` field on the DHCP server should at minimum point to the cobbler server’s IP and the filename should be set to `pxelinux.0`. Alternatively, cobbler can also generate your dhcp configuration file if you want to run dhcp locally – this is covered in a later section. If you don’t already have a DHCP setup managed by some other tool, allowing cobbler to manage your DHCP environment will prove to be useful as it can manage DHCP reservations and other data. If you already have a DHCP setup, moving an existing setup to be managed from within cobbler is relatively painless – though usage of the DHCP management feature is entirely optional. If you are not interested in network booting via PXE and just want to use koan to install virtual systems or replace existing ones, DHCP configuration can be totally ignored. Koan also has a live CD (see koan’s manpage) capability that can be used to simulate PXE environments.

## 4.4. Autoinstallation (Autoyast/Kickstart)

For help in building kickstarts, try using the `system-config-kickstart` tool, or install a new system and look at the `/root/anaconda-ks.cfg` file left over from the installer. General kickstart questions can also be asked at [kickstart-list@redhat.com](mailto:kickstart-list%40redhat.com). Cobbler ships some autoinstall templates in /etc/cobbler that may also be helpful.

For AutoYaST guides and help please reefer to [the opensuse project](https://doc.opensuse.org/projects/autoyast/).

Also see the website or documentation for additional documentation, user contributed tips, and so on.

## 4.5. Options

- -B –daemonize

  If you pass no options this is the default one. The Cobbler-Server runs in the background.

- -F –no-daemonize

  The Cobbler-Server runs in the foreground.

- -f –log-file

  Choose a destination for the logfile (currently has no effect).

- -l –log-level

  Choose a loglevel for the application (currently has no effect).

# 5. Cobbler Configuration

There are two main settings files: settings and modules.conf. Both files can be found under `/etc/cobbler/` and both are written in YAML.

## 5.1. settings

### 5.1.1. allow_duplicate_hostnames

if 1, cobbler will allow insertions of system records that duplicate the `--dns-name` information of other system records. In general, this is undesirable and should be left 0.

default: `0`

### 5.1.2. allow_duplicate_ips

if 1, cobbler will allow insertions of system records that duplicate the ip address information of other system records. In general, this is undesirable and should be left 0.

default: `0`

### 5.1.3. allow_duplicate_macs

If 1, cobbler will allow insertions of system records that duplicate the mac address information of other system records. In general, this is undesirable.

default: `0`

### 5.1.4. allow_dynamic_settings

If 1, cobbler will allow settings to be changed dynamically without a restart of the cobblerd daemon. You can only change this variable by manually editing the settings file, and you MUST restart cobblerd after changing it.

default: `0`

### 5.1.5. anamon_enabled

By default, installs are *not* set to send installation logs to the cobbler server. With `anamon_enabled`, automatic installation templates may use the `pre_anamon` snippet to allow remote live monitoring of their installations from the cobbler server. Installation logs will be stored under `/var/log/cobbler/anamon/`.

**Note**: This does allow an xmlrpc call to send logs to this directory, without authentication, so enable only if you are ok with this limitation.

default: `0`

### 5.1.6. authn_pam_service

If using authn_pam in the `modules.conf`, this can be configured to change the PAM service authentication will be tested against.

default: `"login"`

### 5.1.7. auth_token_expiration

How long the authentication token is valid for, in seconds.

default: `3600`

### 5.1.8. autoinstall_snippets_dir

This is a directory of files that cobbler uses to make templating easier. See the Wiki for more information. Changing this directory should not be required.

default: `/var/lib/cobbler/snippets`

### 5.1.9. autoinstall_templates_dir

This is a directory of files that cobbler uses to make templating easier. See the Wiki for more information. Changing this directory should not be required.

default: `/var/lib/cobbler/templates`

### 5.1.10. boot_loader_conf_template_dir

Location of templates used for boot loader config generation.

default: `"/etc/cobbler/boot_loader_conf"`

### 5.1.11. build_reporting_*

Email out a report when cobbler finishes installing a system.

- enabled: set to 1 to turn this feature on
- sender: optional
- email: which addresses to email
- smtp_server: used to specify another server for an MTA
- subject: use the default subject unless overridden

defaults:

```
build_reporting_enabled: 0
build_reporting_sender: ""
build_reporting_email: [ 'root@localhost' ]
build_reporting_smtp_server: "localhost"
build_reporting_subject: ""
build_reporting_ignorelist: [ "" ]
```

### 5.1.12. cheetah_import_whitelist

Cheetah-language autoinstall templates can import Python modules. while this is a useful feature, it is not safe to allow them to import anything they want. This whitelists which modules can be imported through Cheetah. Users can expand this as needed but should never allow modules such as subprocess or those that allow access to the filesystem as Cheetah templates are evaluated by cobblerd as code.

- default:

  “random” “re” “time” “netaddr”

### 5.1.13. createrepo_flags

Default createrepo_flags to use for new repositories. If you have `createrepo >= 0.4.10`, consider `-c cache --update -C`, which can dramatically improve your `cobbler reposync` time. `-s sha` enables working with Fedora repos from F11/F12 from EL-4 or EL-5 without python-hashlib installed (which is not available on EL-4)

default: `"-c cache -s sha"`

### 5.1.14. default_autoinstall

If no autoinstall template is specified to profile add, use this template.

default: `/var/lib/cobbler/autoinstall_templates/default.ks`

### 5.1.15. default_name_*

Configure all installed systems to use these nameservers by default unless defined differently in the profile. For DHCP configurations you probably do /not/ want to supply this.

defaults:

```
default_name_servers: []
default_name_servers_search: []
```

### 5.1.16. default_ownership

if using the `authz_ownership` module (see the Wiki), objects created without specifying an owner are assigned to this owner and/or group. Can be a comma separated list.

- default:

  “admin”

### 5.1.17. default_password_crypted

Cobbler has various sample automatic installation templates stored in `/var/lib/cobbler/autoinstall_templates/`. This controls what install (root) password is set up for those systems that reference this variable. The factory default is “cobbler” and cobbler check will warn if this is not changed. The simplest way to change the password is to run `openssl passwd -1` and put the output between the `""`.

default: `"$1$mF86/UHC$WvcIcX2t6crBz2onWxyac."`

### 5.1.18. default_template_type

The default template type to use in the absence of any other detected template. If you do not specify the template with `#template=<template_type>` on the first line of your templates/snippets, cobbler will assume try to use the following template engine to parse the templates.

Current valid values are: cheetah, jinja2

default: `"cheetah"`

### 5.1.19. default_virt_bridge

For libvirt based installs in koan, if no virt-bridge is specified, which bridge do we try? For EL 4/5 hosts this should be `xenbr0`, for all versions of Fedora, try `virbr0`. This can be overriden on a per-profile basis or at the koan command line though this saves typing to just set it here to the most common option.

default: `xenbr0`

### 5.1.20. default_virt_file_size

Use this as the default disk size for virt guests (GB).

default: `5`

### 5.1.21. default_virt_ram

Use this as the default memory size for virt guests (MB).

default: `512`

### 5.1.22. default_virt_type

If koan is invoked without `--virt-type` and no virt-type is set on the profile/system, what virtualization type should be assumed?

Current valid values are: xenpv, xenfv, qemu, vmware

**NOTE**: this does not change what `virt_type` is chosen by import.

default: `xenpv`

### 5.1.23. enable_gpxe

Enable gPXE booting? Enabling this option will cause cobbler to copy the `undionly.kpxe` file to the tftp root directory, and if a profile/system is configured to boot via gpxe it will chain load off `pxelinux.0`.

default: `0`

### 5.1.24. enable_menu

Controls whether cobbler will add each new profile entry to the default PXE boot menu. This can be over-ridden on a per-profile basis when adding/editing profiles with `--enable-menu=0/1`. Users should ordinarily leave this setting enabled unless they are concerned with accidental reinstalls from users who select an entry at the PXE boot menu. Adding a password to the boot menus templates may also be a good solution to prevent unwanted reinstallations

default: `1`

### 5.1.25. http_port

Change this port if Apache is not running plaintext on port 80. Most people can leave this alone.

default: `80`

### 5.1.26. kernel_options

Kernel options that should be present in every cobbler installation. Kernel options can also be applied at the distro/profile/system level.

default: `{}`

### 5.1.27. ldap_*

Configuration options if using the authn_ldap module. See the Wiki for details. This can be ignored if you are not using LDAP for WebUI/XMLRPC authentication.

defaults:

```
ldap_server: "ldap.example.com"
ldap_base_dn: "DC=example,DC=com"
ldap_port: 389
ldap_tls: 1
ldap_anonymous_bind: 1
ldap_search_bind_dn: ''
ldap_search_passwd: ''
ldap_search_prefix: 'uid='
ldap_tls_cacertfile: ''
ldap_tls_keyfile: ''
ldap_tls_certfile: ''
```

### 5.1.28. mgmt_*

Cobbler has a feature that allows for integration with config management systems such as Puppet. The following parameters work in conjunction with `--mgmt-classes` and are described in further detail at [Configuration Management Integrations](https://cobbler.readthedocs.io/en/latest/user-guide/configuration-management-integrations.html#configuration-management).

```
mgmt_classes: []
mgmt_parameters:
    from_cobbler: 1
```

### 5.1.29. puppet_auto_setup

If enabled, this setting ensures that puppet is installed during machine provision, a client certificate is generated and a certificate signing request is made with the puppet master server.

default: `0`

### 5.1.30. sign_puppet_certs_automatically

When puppet starts on a system after installation it needs to have its certificate signed by the puppet master server. Enabling the following feature will ensure that the puppet server signs the certificate after installation if the puppet master server is running on the same machine as cobbler. This requires `puppet_auto_setup` above to be enabled.

default: `0`

### 5.1.31. puppetca_path

Location of the puppet executable, used for revoking certificates.

default: `"/usr/bin/puppet"`

### 5.1.32. remove_old_puppet_certs_automatically

When a puppet managed machine is reinstalled it is necessary to remove the puppet certificate from the puppet master server before a new certificate is signed (see above). Enabling the following feature will ensure that the certificate for the machine to be installed is removed from the puppet master server if the puppet master server is running on the same machine as cobbler. This requires `puppet_auto_setup` above to be enabled

default: `0`

### 5.1.33. puppet_server

Choose a `--server` argument when running puppetd/puppet agent during autoinstall. This one is commented out by default.

default: `'puppet'`

### 5.1.34. puppet_version

Let cobbler know that you’re using a newer version of puppet. Choose version 3 to use: ‘puppet agent’; version 2 uses status quo: ‘puppetd’. This one is commented out by default.

default: `2`

### 5.1.35. puppet_parameterized_classes

Choose whether to enable puppet parameterized classes or not. Puppet versions prior to 2.6.5 do not support parameters. This one is commented out by default.

default: 1

### 5.1.36. manage_dhcp

Set to 1 to enable Cobbler’s DHCP management features. The choice of DHCP management engine is in `/etc/cobbler/modules.conf`

default: `0`

### 5.1.37. manage_dns

Set to 1 to enable Cobbler’s DNS management features. The choice of DNS management engine is in `/etc/cobbler/modules.conf`

default: `0`

### 5.1.38. bind_chroot_path

Set to path of bind chroot to create bind-chroot compatible bind configuration files. This should be automatically detected.

default: `""`

### 5.1.39. bind_master

Set to the ip address of the master bind DNS server for creating secondary bind configuration files.

default: `127.0.0.1`

### 5.1.40. manage_tftpd

Set to 1 to enable Cobbler’s TFTP management features. the choice of TFTP management engine is in `/etc/cobbler/modules.conf`

default: `1`

### 5.1.41. tftpboot_location

This variable contains the location of the tftpboot directory. If this directory is not present cobbler does not start.

Default: `/srv/tftpboot`

### 5.1.42. manage_rsync

Set to 1 to enable Cobbler’s RSYNC management features.

default: `0`

### 5.1.43. manage_*

If using BIND (named) for DNS management in `/etc/cobbler/modules.conf` and manage_dns is enabled (above), this lists which zones are managed. See [DNS configuration management](https://cobbler.readthedocs.io/en/latest/user-guide.html#dns-management) for more information.

defaults:

```
manage_forward_zones: []
manage_reverse_zones: []
```

### 5.1.44. next_server

If using cobbler with `manage_dhcp`, put the IP address of the cobbler server here so that PXE booting guests can find it. If you do not set this correctly, this will be manifested in TFTP open timeouts.

default: `127.0.0.1`

### 5.1.45. power_management_default_type

Settings for power management features. These settings are optional. See [Power Management](https://cobbler.readthedocs.io/en/latest/user-guide.html#power-management) to learn more.

Choices (refer to codes.py):

- apc_snmp
- bladecenter
- bullpap
- drac
- ether_wake
- ilo
- integrity
- ipmilan
- ipmitool
- lpar
- rsa
- virsh
- wti

default: `ipmitool`

### 5.1.46. pxe_just_once

If this setting is set to 1, cobbler systems that pxe boot will request at the end of their installation to toggle the `--netboot-enabled` record in the cobbler system record. This eliminates the potential for a PXE boot loop if the system is set to PXE first in it’s BIOS order. Enable this if PXE is first in your BIOS boot order, otherwise leave this disabled. See the manpage for `--netboot-enabled`.

default: `1`

### 5.1.47. nopxe_with_triggers

If this setting is set to one, triggers will be executed when systems will request to toggle the `--netboot-enabled` record at the end of their installation.

default: `1`

### 5.1.48. redhat_management_server

This setting is only used by the code that supports using Spacewalk/Satellite authentication within Cobbler Web and Cobbler XMLRPC.

default: `"xmlrpc.rhn.redhat.com"`

### 5.1.49. redhat_management_permissive

If using `authn_spacewalk` in `modules.conf` to let cobbler authenticate against Satellite/Spacewalk’s auth system, by default it will not allow per user access into Cobbler Web and Cobbler XMLRPC. In order to permit this, the following setting must be enabled HOWEVER doing so will permit all Spacewalk/Satellite users of certain types to edit all of cobbler’s configuration. these roles are: `config_admin` and `org_admin`. Users should turn this on only if they want this behavior and do not have a cross-multi-org separation concern. If you have a single org in your satellite, it’s probably safe to turn this on and then you can use CobblerWeb alongside a Satellite install.

default: `0`

### 5.1.50. redhat_management_key

Specify the default Red Hat authorization key to use to register system. If left blank, no registration will be attempted. Similarly you can set the `--redhat-management-key` to blank on any system to keep it from trying to register.

default: `""`

### 5.1.51. register_new_installs

If set to `1`, allows `/usr/bin/cobbler-register` (part of the koan package) to be used to remotely add new cobbler system records to cobbler. This effectively allows for registration of new hardware from system records.

default: `0`

### 5.1.52. reposync_flags

Flags to use for yum’s reposync. If your version of yum reposync does not support `-l`, you may need to remove that option.

default: `"-l -n -d"`

### 5.1.53. restart_*

When DHCP and DNS management are enabled, `cobbler sync` can automatically restart those services to apply changes. The exception for this is if using ISC for DHCP, then omapi eliminates the need for a restart. `omapi`, however, is experimental and not recommended for most configurations. If DHCP and DNS are going to be managed, but hosted on a box that is not on this server, disable restarts here and write some other script to ensure that the config files get copied/rsynced to the destination box. This can be done by modifying the restart services trigger. Note that if `manage_dhcp` and `manage_dns` are disabled, the respective parameter will have no effect. Most users should not need to change this.

defaults:

```
restart_dns: 1
restart_dhcp: 1
```

### 5.1.54. run_install_triggers

Install triggers are scripts in `/var/lib/cobbler/triggers/install` that are triggered in autoinstall pre and post sections. Any executable script in those directories is run. They can be used to send email or perform other actions. They are currently run as root so if you do not need this functionality you can disable it, though this will also disable `cobbler status` which uses a logging trigger to audit install progress.

default: `1`

### 5.1.55. scm_track_*

enables a trigger which version controls all changes to `/var/lib/cobbler` when add, edit, or sync events are performed. This can be used to revert to previous database versions, generate RSS feeds, or for other auditing or backup purposes. Git and Mercurial are currently supported, but Git is the recommend SCM for use with this feature.

default:

```
scm_track_enabled: 0
scm_track_mode: "git"
scm_track_author: "cobbler <cobbler@localhost>"
scm_push_script: "/bin/true"
```

### 5.1.56. server

This is the address of the cobbler server – as it is used by systems during the install process, it must be the address or hostname of the system as those systems can see the server. if you have a server that appears differently to different subnets (dual homed, etc), you need to read the `--server-override` section of the manpage for how that works.

default: `127.0.0.1`

### 5.1.57. client_use_localhost

If set to 1, all commands will be forced to use the localhost address instead of using the above value which can force commands like cobbler sync to open a connection to a remote address if one is in the configuration and would traceback.

default: `0`

### 5.1.58. client_use_https

If set to 1, all commands to the API (not directly to the XMLRPC server) will go over HTTPS instead of plaintext. Be sure to change the `http_port` setting to the correct value for the web server.

default: `0`

### 5.1.59. virt_auto_boot

Should new profiles for virtual machines default to auto booting with the physical host when the physical host reboots? This can be overridden on each profile or system object.

default: `1`

### 5.1.60. webdir

Cobbler’s web directory.  Don’t change this setting – see the Wiki on “relocating your cobbler install” if your /var partition is not large enough.

default: `@@webroot@@/cobbler`

### 5.1.61. webdir_whitelist

Directories that will not get wiped and recreated on a `cobbler sync`.

default:

```
webdir_whitelist:
  - misc
  - web
  - webui
  - localmirror
  - repo_mirror
  - distro_mirror
  - images
  - links
  - pub
  - repo_profile
  - repo_system
  - svc
  - rendered
  - .link_cache
```

### 5.1.62. xmlrpc_port

Cobbler’s public XMLRPC listens on this port. Change this only if absolutely needed, as you’ll have to start supplying a new port option to koan if it is not the default.

default: `25151`

### 5.1.63. yum_post_install_mirror

`cobbler repo add` commands set cobbler up with repository information that can be used during autoinstall and is automatically set up in the cobbler autoinstall templates. By default, these are only available at install time. To make these repositories usable on installed systems (since cobbler makes a very convenient mirror) set this to 1. Most users can safely set this to 1. Users who have a dual homed cobbler server, or are installing laptops that will not always have access to the cobbler server may wish to leave this as 0. In that case, the cobbler mirrored yum repos are still accessible at `http://cobbler.example.org/cblr/repo_mirror` and yum configuration can still be done manually. This is just a shortcut.

default: `1`

### 5.1.64. yum_distro_priority

The default yum priority for all the distros. This is only used if yum-priorities plugin is used. 1 is the maximum value. Tweak with caution.

default: `1`

### 5.1.65. yumdownloader_flags

Flags to use for yumdownloader. Not all versions may support `--resolve`.

default: `"--resolve"`

### 5.1.66. serializer_pretty_json

Sort and indent JSON output to make it more human-readable.

default: `0`

### 5.1.67. replicate_rsync_options

replication rsync options for distros, autoinstalls, snippets set to override default value of `-avzH`

default: `"-avzH"`

### 5.1.68. replicate_repo_rsync_options

Replication rsync options for repos set to override default value of `-avzH`

default: `"-avzH"`

### 5.1.69. always_write_dhcp_entries

Always write DHCP entries, regardless if netboot is enabled.

default: `0`

### 5.1.70. proxy_url_ext:

External proxy - used by: get-loaders, reposync, signature update. Per default commented out.

defaults:

```
http: http://192.168.1.1:8080
https: https://192.168.1.1:8443
```

### 5.1.71. proxy_url_int

Internal proxy - used by systems to reach cobbler for kickstarts.

E.g.: proxy_url_int: `http://10.0.0.1:8080`

default: `""`

### 5.1.72. jinja2_includedir

This is a directory of files that cobbler uses to include files into Jinja2 templates. Per default this settings is commented out.

default: `/var/lib/cobbler/jinja2`

### 5.1.73. include

Include other configuration snippets with this regular expression.

default: `[ "/etc/cobbler/settings.d/*.settings" ]`

## 5.2. modules.conf

If you have own custom modules which are not shipped with Cobbler directly you may have additional sections here.

### 5.2.1. authentication

What users can log into the WebUI and Read-Write XMLRPC?

Choices:

- authn_denyall    – no one (default)
- authn_configfile – use /etc/cobbler/users.digest (for basic setups)
- authn_passthru   – ask Apache to handle it (used for kerberos)
- authn_ldap       – authenticate against LDAP
- authn_spacewalk  – ask Spacewalk/Satellite (experimental)
- authn_pam        – use PAM facilities
- authn_testing    – username/password is always testing/testing (debug)
- (user supplied)  – you may write your own module

WARNING: this is a security setting, do not choose an option blindly.

For more information:

- [Web-Interface](https://cobbler.readthedocs.io/en/latest/user-guide/web-interface.html#web-interface)
- https://cobbler.readthedocs.io/en/release28/5_web-interface/security_overview.html
- https://cobbler.readthedocs.io/en/release28/5_web-interface/web_authentication.html#defer-to-apache-kerberos
- https://cobbler.readthedocs.io/en/release28/5_web-interface/web_authentication.html#ldap

default: `authn_configfile`

### 5.2.2. authorization

Once a user has been cleared by the WebUI/XMLRPC, what can they do?

Choices:

- authz_allowall   – full access for all authenticated users (default)
- authz_ownership  – use users.conf, but add object ownership semantics
- (user supplied)  – you may write your own module

**WARNING**: this is a security setting, do not choose an option blindly. If you want to further restrict cobbler with ACLs for various groups, pick authz_ownership.  authz_allowall does not support ACLs. Configfile does but does not support object ownership which is useful as an additional layer of control.

For more information:

- [Web-Interface](https://cobbler.readthedocs.io/en/latest/user-guide/web-interface.html#web-interface)
- https://cobbler.readthedocs.io/en/release28/5_web-interface/security_overview.html
- https://cobbler.readthedocs.io/en/release28/5_web-interface/web_authentication.html

default: `authz_allowall`

### 5.2.3. dns

Chooses the DNS management engine if manage_dns is enabled in `/etc/cobbler/settings`, which is off by default.

Choices:

- manage_bind    – default, uses BIND/named
- manage_dnsmasq – uses dnsmasq, also must select dnsmasq for dhcp below
- manage_ndjbdns – uses ndjbdns

**NOTE**: More configuration is still required in `/etc/cobbler`

For more information see [DNS configuration management](https://cobbler.readthedocs.io/en/latest/user-guide.html#dns-management).

default: `manage_bind`

### 5.2.4. dhcp

Chooses the DHCP management engine if `manage_dhcp` is enabled in `/etc/cobbler/settings`, which is off by default.

Choices:

- manage_isc     – default, uses ISC dhcpd
- manage_dnsmasq – uses dnsmasq, also must select dnsmasq for dns above

**NOTE**: More configuration is still required in `/etc/cobbler`

For more information see [DHCP Management](https://cobbler.readthedocs.io/en/latest/user-guide.html#dhcp-management).

default: `manage_isc`

### 5.2.5. tftpd

Chooses the TFTP management engine if manage_tftp is enabled in `/etc/cobbler/settings`, which is ON by default.

Choices:

- manage_in_tftpd – default, uses the system’s tftp server
- manage_tftpd_py – uses cobbler’s tftp server

default: `manage_in_tftpd`

​              



![img](https://upload-images.jianshu.io/upload_images/16833175-ce98748f9e689fda.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/500)

u=2309844935,3073463543&fm=26&gp=0.jpg

### 技术原理解析：

> Client向PXE Server上的DHCP发送IP地址请求消息，DHCP检测Client是否合法（主要是检测Client的网卡MAC地址），如果合法则返回Client的IP地址，同时将启动文件pxelinux.0的位置信息一并传送给Client
>  Client向PXE  Server上的TFTP发送获取pxelinux.0请求消息，TFTP接收到消息之后再向Client发送pxelinux.0大小信息，试探Client是否满意，当TFTP收到Client发回的同意大小信息之后，正式向Client发送pxelinux.0
>  Client执行接收到的pxelinux.0文件
>  Client向TFTP  Server发送针对本机的配置信息文件（在TFTP服务的pxelinux.cfg目录下，这是系统菜单文件，格式和isolinux.cfg格式一样，功能也是类似），TFTP将配置文件发回Client，继而Client根据配置文件执行后续操作。
>  Client向TFTP发送Linux内核请求信息，TFTP接收到消息之后将内核文件发送给Client
>  Client向TFTP发送根文件请求信息，TFTP接收到消息之后返回Linux根文件系统
>  Client启动Linux内核
>  Client下载安装源文件，读取自动化安装脚本
>  Cobbler简单介绍：
>  Cobbler是一个Linux服务器快速网络安装的服务，由python开发，小巧轻便（15k行python代码），可以通过PXE的方式来快速安装、重装物理服务器和虚拟机，同时还可以管理DHCP，DNS，TFTP、RSYNC以及yum仓库、构造系统ISO镜像。
>  Cobbler可以使用命令行方式管理，也提供了基于Web的界面管理工具(cobbler-web)，还提供了API接口，可以方便二次开发使用。

### Cobbler工作流程：

> Client裸机配置了从网络启动后，开机后会广播包请求DHCP服务器 （Cobbler server）发送其分配好的一个IP
>  DHCP服务器（Cobbler server）收到请求后发送responese，包括其ip地址
>  Client裸机拿到ip后再向Cobbler server发送请求OS引导文件的请求
>  Cobbler server告诉裸机OS引导文件的名字和TFTP server的ip和port
>  Client裸机通过上面告知的TFTP server地址通信，下载引导文件
>  Client裸机执行执行该引导文件，确定加载信息，选择要安装的OS， 期间会再向cobbler server请求kickstart文件和OS image
>  Cobbler server发送请求的kickstart和OS iamge
>  Client裸机加载kickstart文件
>  Client裸机接收os image，安装该OS image

### Cobbler集成的服务：

> PXE服务支持
>  DHCP服务管理
>  DNS服务管理(可选bind,dnsmasq)
>  电源管理
>  Kickstart服务支持
>  YUM仓库管理
>  TFTP(PXE启动时需要)
>  Apache(提供kickstart的安装源，并提供定制化的kickstart配置)

### Cobbler 设计方式:

> 发行版（distro） ：表示一个操作系统，它承载了内核和initrd的信息，以及内核等其他数据
>  存储库 （repository）：保存了一个yum或者rsync存储库的镜像信息
>  配置文件（profile）：包含了一个发行版（distro），一个kickstart文件以及可能的存储库（repository），还包含了更多的内核参数等其他数据
>  系统（system）：表示要配给的机器，它包含了一个配置文件或一个镜像，还包含了ip和mac地址，电源管理（地址,凭据,类型）以及更为专业的数据信息
>  镜像（image）：可替换一个包含不属于此类别的文件的发行版对象（eg: 无法作为内核和initrd的对象）

以上各个组件中， 发行版，存储库， 配置文件为必须配置项，只有在虚拟环境中，必须要用cobbler来引导虚拟机启动时候，才会用到系统组件但事实上，在生产环境中需要大量的虚拟机实例的话，通常利用openstack等来实现虚拟机节点

### Cobbler配置目录文件说明：

> /etc/cobbler
>  /etc/cobbler/settings     # cobbler 主配置文件
>  /etc/cobbler/iso/          # iso模板配置文件
>  /etc/cobbler/pxe           # pxe模板文件
>  /etc/cobbler/power       # 电源配置文件
>  /etc/cobbler/user.conf    # web服务授权配置文件
>  /etc/cobbler/users.digest      # web访问的用户名密码配置文件
>  /etc/cobbler/dhcp.template    # dhcp服务器的的配置末班
>  /etc/cobbler/dnsmasq.template     # dns服务器的配置模板
>  /etc/cobbler/tftpd.template        # tftp服务的配置模板
>  /etc/cobbler/modules.conf           # 模块的配置文件

#### Cobbler数据目录：

> /var/lib/cobbler/config/           # 用于存放distros，system，profiles 等信 息配置文件
>  /var/lib/cobbler/triggers/        # 用于存放用户定义的cobbler命令
>  /var/lib/cobbler/kickstart/       # 默认存放kickstart文件
>  /var/lib/cobbler/loaders/          # 存放各种引导程序  镜像目录
>  /var/www/cobbler/ks_mirror/     # 导入的发行版系统的所有数据
>  /var/www/cobbler/images/         # 导入发行版的kernel和initrd镜像用于 远程网络启动
>  /var/www/cobbler/repo_mirror/     # yum 仓库存储目录

### Cobbler镜像目录：

> /var/www/cobbler/ks_mirror/         # 导入的发行版系统的所有数据
>  /var/www/cobbler/images/             # 导入发行版的kernel和initrd镜像用于远程网络启动
>  /var/www/cobbler/repo_mirror/      # yum 仓库存储目录
>  Cobbler日志目录：
>  /var/log/cobbler/installing         # 客户端安装日志
>  /var/log/cobbler/cobbler.log       # cobbler日志

#### Cobbler命令介绍：

> cobbler check              # 核对当前设置是否有问题
>  cobbler list                   # 列出所有的cobbler元素
>  cobbler report              # 列出元素的详细信息
>  cobbler sync                 # 同步配置到数据目录,更改配置最好都要执行下
>  cobbler reposync          # 同步yum仓库
>  cobbler distro                # 查看导入的发行版系统信息
>  cobbler system              # 查看添加的系统信息
>  cobbler profile               # 查看配置信息

#### /etc/cobbler/settings中重要的参数设置：

> default_password_crypted: "![1](https://math.jianshu.com/math?formula=1)gEc7ilpP$pg5iSOj/mlxTxEslhRvyp/"
>  manage_dhcp：1
>  manage_tftpd：1
>  pxe_just_once：1
>  next_server：< tftp服务器的 IP 地址>
>  server：<Cobbler服务器IP地址>


# 问题1：

```csharp
[root@cobbler ~]# sed -i 's/^server: 127.0.0.1/server: 10.94.2.240/' /etc/cobbler/settings        # 修改server的ip地址为本机ip
```

# 问题2：

```csharp
[root@cobbler ~]# sed -i 's/^next_server: 127.0.0.1/next_server: 10.94.2.240/' /etc/cobbler/settings           # TFTP Server 的IP地址
```

# 问题3：

```bash
[root@cobbler ~]# vim /etc/xinetd.d/tftp
service tftp
{
socket_type = dgram
protocol = udp
wait = yes
user = root
server = /usr/sbin/in.tftpd
server_args = -s /var/lib/tftpboot
disable = no # 修改为no
per_source = 11
cps = 100 2
flags = IPv4
}
```

# 问题4：

```csharp
[root@cobbler ~]# cobbler get-loaders  # 下载缺失的文件
```

### 报错

![img]()

## 解决办法

vim /etc/cobbler/settings 找到第384行
 384 server: 10.0.0.61  ####改为自己的IP地址

# 问题5：

```csharp
# 添加rsync到自启动并启动rsync
[root@cobbler ~]# systemctl enable rsyncd
Created symlink from /etc/systemd/system/multi-user.target.wants/rsyncd.service to /usr/lib/systemd/system/rsyncd.service.
[root@cobbler ~]# systemctl start rsyncd 
```

# 问题6：

```ruby
[root@cobbler ~]# yum install debmirror -y       #安装debian
[root@cobbler ~]# vim /etc/debmirror.conf
28 #@dists="sid";
30 #@arches="i386";
注释掉这两行，重新check后没有报错了
```

# 问题7：

```bash
# 修改密码为123456 ，salt后面是常用的加密方式加密
[root@localhost ~]# openssl passwd -1 -salt '123456' '123456' 
$1$123456$wOSEtcyiP2N/IfIl15W6Z0
[root@localhost ~]# vim /etc/cobbler/settings     # 修改settings配置文件中下面位置，把新生成的密码加进去
default_password_crypted: "$1$123456$wOSEtcyiP2N/IfIl15W6Z0
```

# 问题8：

```csharp
[root@cobbler ~]# yum install fence-agents -y    # fence设备相关，电源管理模块
```

# 重启cobbler

```css
systemctl restart cobblerd.service
```

# 再次执行cobbler check

```csharp
[root@cobbler ~]# cobbler check
```

- #### 9、dhcp利用cobbler管理

```csharp
[root@cobbler ~]# vim /etc/cobbler/settings      # 修改settings中参数，由cobbler控制dhcp
manage_dhcp: 1
```

![img]()

修改

- #### 10、修改dhcp.templates配置文件（仅列出修改部分）

```csharp
[root@cobbler/var/lib/cobbler/kickstarts]# vim /etc/cobbler/dhcp.template
subnet 10.0.0.0 netmask 255.255.255.0 {                #网段    这个可以是10网段，也可以是172网段
     option routers             10.0.0.1;         #网关
     option domain-name-servers 10.0.0.1;          #MDS 详见：[https://blog.csdn.net/displayMessage/article/details/81133634](https://blog.csdn.net/displayMessage/article/details/81133634)

     option subnet-mask         255.255.255.0;        #子网掩码
     range dynamic-bootp        10.0.0.210 10.0.0.220;           #分配的地址段
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server;         #这个是cobbler配置文件里面的变量
```

- #### 11、重启服务并同步配置，改完dhcp必须要sync同步配置

```csharp
[root@cobbler ~]# systemctl restart cobblerd.service
[root@cobbler ~]# cobbler sync 
```

- #### 12、检查dhcp

```csharp
[root@cobbler ~]# netstat -tulp | grep dhcp
```

- #### 13、现在开始一键装机

- ##### 1、首先挂载镜像

![img]()

image.png



Linux 上是需要挂载光盘，我们进行挂载

```csharp
[root@localhost ~]# mount /dev/cdrom /mnt/
mount: /dev/sr0 is write-protected, mounting read-only
```

- ### 2、制作镜像，用于安装操作系统,使cobbler导入镜像

```csharp
[root@m01 ~]# cobbler import --path=/mnt --name=CentOS7.6
task started: 2019-05-03_134203_import
--path=从哪里导入
--name=名称
--arch=系统位数32 or 64
task started (id=Media import, time=Fri May  3 13:42:03 2019) ######此处需要较长的一个时间
Found a candidate signature: breed=redhat, version=rhel6
Found a matching signature: breed=redhat, version=rhel6
Adding distros from path /var/www/cobbler/ks_mirror/CentOS7.6:
creating new distro: CentOS7.6-x86_64
trying symlink: /var/www/cobbler/ks_mirror/CentOS7.6 -> /var/www/cobbler/links/CentOS7.6-x86_64
creating new profile: CentOS7.6-x86_64
associating repos
checking for rsync repo(s)
checking for rhn repo(s)
checking for yum repo(s)
starting descent into /var/www/cobbler/ks_mirror/CentOS7.6 for CentOS7.6-x86_64
processing repo at : /var/www/cobbler/ks_mirror/CentOS7.6
need to process repo/comps: /var/www/cobbler/ks_mirror/CentOS7.6
looking for /var/www/cobbler/ks_mirror/CentOS7.6/repodata/*comps*.xml
Keeping repodata as-is :/var/www/cobbler/ks_mirror/CentOS7.6/repodata
*** TASK COMPLETE ***
```

- #### 查看cobbler都有哪些命令

```csharp
[root@localhost /]# cobbler profile
usage
=====
cobbler profile add
cobbler profile copy
cobbler profile dumpvars
cobbler profile edit
cobbler profile find
cobbler profile getks
cobbler profile list
cobbler profile remove
cobbler profile rename
cobbler profile report
```

- #### 例如：我们查看当前有几个镜像

```csharp
[root@localhost /]# cobbler profile list
   CentOS-6-x86_64
   CentOS-7-x86_64
```

- #### 3、查看我们系统的详细信息

```csharp
[root@localhost /]# cobbler profile report
Name                           : CentOS-7.1-x86_64
TFTP Boot Files                : {}
Comment                        : 
DHCP Tag                       : default
Distribution                   : CentOS-7.1-x86_64
Enable gPXE?                   : 0
Enable PXE Menu?               : 1
Fetchable Files                : {}
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart                      : /var/lib/cobbler/kickstarts/sample_end.ks
Kickstart Metadata             : {}
Management Classes             : []
Management Parameters          : <<inherit>>
Name Servers                   : []
Name Servers Search Path       : []
Owners                         : ['admin']
Parent Profile                 : 
Internal proxy                 : 
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos                          : []
Server Override                : <<inherit>>
Template Files                 : {}
Virt Auto Boot                 : 1
Virt Bridge                    : xenbr0
Virt CPUs                      : 1
Virt Disk Driver Type          : raw
Virt File Size(GB)             : 5
Virt Path                      : 
Virt RAM (MB)                  : 512
Virt Type                      : kvm
Name                           : CentOS-7-x86_64
TFTP Boot Files                : {}
Comment                        : 
DHCP Tag                       : default
Distribution                   : CentOS-7-x86_64
Enable gPXE?                   : 0
Enable PXE Menu?               : 1
Fetchable Files                : {}
Kernel Options                 : {}
Kernel Options (Post Install)  : {}
Kickstart                      : /var/lib/cobbler/kickstarts/sample_end.ks
Kickstart Metadata             : {}
Management Classes             : []
Management Parameters          : <<inherit>>
Name Servers                   : []
Name Servers Search Path       : []
Owners                         : ['admin']
Parent Profile                 : 
Internal proxy                 : 
Red Hat Management Key         : <<inherit>>
Red Hat Management Server      : <<inherit>>
Repos                          : []
Server Override                : <<inherit>>
Template Files                 : {}
Virt Auto Boot                 : 1
Virt Bridge                    : xenbr0
Virt CPUs                      : 1
Virt Disk Driver Type          : raw
Virt File Size(GB)             : 5
Virt Path                      : 
Virt RAM (MB)                  : 512
Virt Type                      : kvm
```

- #### 4、修改ks的路径，自定义安装后，需要设置的一些东西，例如开启哪些服务，关闭哪些服务。安装什么东西等

我们先上传已经设置好的cfg文件
 为了规范，我们把kickstarts文件放在`/var/lib/cobbler/kickstarts`下面

```csharp
[root@localhost ~]# cd /var/lib/cobbler/kickstarts/`
[root@localhost kickstarts]# rz 
rz waiting to receive.
```

- #### 5、检查一下路径是否正确

```css
[root@localhost kickstarts]# ll
total 60
-rw-r--r-- 1 root root 3704 Aug 24  2016 CentOS-6-x86_64.cfg
-rw-r--r-- 1 root root 1355 Aug 25  2016 CentOS-7-x86_64.cfg
-rw-r--r-- 1 root root  115 Jan 23  2016 default.ks
-rw-r--r-- 1 root root   22 Jan 23  2016 esxi4-ks.cfg
-rw-r--r-- 1 root root   22 Jan 23  2016 esxi5-ks.cfg
drwxr-xr-x 2 root root   54 Aug 23 09:17 install_profiles
-rw-r--r-- 1 root root 1424 Jan 23  2016 legacy.ks
-rw-r--r-- 1 root root  292 Jan 23  2016 pxerescue.ks
-rw-r--r-- 1 root root 2916 Jan 23  2016 sample_autoyast.xml
-rw-r--r-- 1 root root 1825 Jan 23  2016 sample_end.ks
-rw-r--r-- 1 root root    0 Jan 23  2016 sample_esx4.ks
-rw-r--r-- 1 root root  324 Jan 23  2016 sample_esxi4.ks
-rw-r--r-- 1 root root  386 Jan 23  2016 sample_esxi5.ks
-rw-r--r-- 1 root root 1784 Jan 23  2016 sample.ks
-rw-r--r-- 1 root root 3419 Jan 23  2016 sample_old.seed
-rw-r--r-- 1 root root 5879 Jan 23  2016 sample.seed
```

- #### 6、自定义kickstarts文件

我们使用cobbler profile report命令看到Kickstart默认在/var/lib/cobbler/kickstarts/sample_end.ks

- ##### 修改7的kickstarts

```csharp
[root@localhost /]# cobbler profile edit --name=CentOS7.6-x86_64 --kickstart=/var/lib/cobbler/kickstarts/CentOS-7-x86_64.cfg
```

- #### 因为Centos7 默认的网卡不在/etc/init.d/network 所以我们需要修改内核

```csharp
[root@localhost /]# cobbler profile report
```

- ##### 我们查看到这里可以定义内核参数

```csharp
[root@localhost /]# cobbler profile edit --name=CentOS-7-x86_64 --kopts='net.ifnames=0 biosdevname=0'
```

这样我们在安装Centos7的时候就会默认给我们加上这个内核参数

- #### 7、执行cobbler sync会删除原来的文件，相当于从新进行加载

```dart
[root@localhost /]# cobbler sync
task started: 2016-08-24_001542_sync
task started (id=Sync, time=Wed Aug 24 00:15:42 2016)
running pre-sync triggers
cleaning trees
removing: /var/www/cobbler/images/CentOS-7-x86_64
removing: /var/www/cobbler/images/CentOS-7.1-x86_64
removing: /var/lib/tftpboot/pxelinux.cfg/default
removing: /var/lib/tftpboot/grub/images
removing: /var/lib/tftpboot/grub/grub-x86.efi
removing: /var/lib/tftpboot/grub/grub-x86_64.efi
removing: /var/lib/tftpboot/grub/efidefault
removing: /var/lib/tftpboot/images/CentOS-7-x86_64
removing: /var/lib/tftpboot/images/CentOS-7.1-x86_64
removing: /var/lib/tftpboot/s390x/profile_list
copying bootloaders
trying hardlink /var/lib/cobbler/loaders/grub-x86.efi -> /var/lib/tftpboot/grub/grub-x86.efi
trying hardlink /var/lib/cobbler/loaders/grub-x86_64.efi -> /var/lib/tftpboot/grub/grub-x86_64.efi
copying distros to tftpboot
copying files for distro: CentOS-7.1-x86_64
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7.1-x86_64/images/pxeboot/vmlinuz -> /var/lib/tftpboot/images/CentOS-7.1-x86_64/vmlinuz
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7.1-x86_64/images/pxeboot/initrd.img -> /var/lib/tftpboot/images/CentOS-7.1-x86_64/initrd.img
copying files for distro: CentOS-7-x86_64
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7-x86_64/images/pxeboot/vmlinuz -> /var/lib/tftpboot/images/CentOS-7-x86_64/vmlinuz
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7-x86_64/images/pxeboot/initrd.img -> /var/lib/tftpboot/images/CentOS-7-x86_64/initrd.img
copying images
generating PXE configuration files
generating PXE menu structure
copying files for distro: CentOS-7.1-x86_64
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7.1-x86_64/images/pxeboot/vmlinuz -> /var/www/cobbler/images/CentOS-7.1-x86_64/vmlinuz
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7.1-x86_64/images/pxeboot/initrd.img -> /var/www/cobbler/images/CentOS-7.1-x86_64/initrd.img
Writing template files for CentOS-7.1-x86_64
copying files for distro: CentOS-7-x86_64
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7-x86_64/images/pxeboot/vmlinuz -> /var/www/cobbler/images/CentOS-7-x86_64/vmlinuz
trying hardlink /var/www/cobbler/ks_mirror/CentOS-7-x86_64/images/pxeboot/initrd.img -> /var/www/cobbler/images/CentOS-7-x86_64/initrd.img
Writing template files for CentOS-7-x86_64
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
rendering TFTPD files
generating /etc/xinetd.d/tftp
processing boot_files for distro: CentOS-7.1-x86_64
processing boot_files for distro: CentOS-7-x86_64
cleaning link caches
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout:
received on stderr:
running: service dhcpd restart
received on stdout:
received on stderr: Redirecting to /bin/systemctl restart  dhcpd.service
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
```

- #### 8、新建虚拟机进行安装

提示：我们先打开系统日志，因为dhcp默认会将日志显示在/var/log/messages



![img]()

查看DHCP日志



![img]()

查看

- #### 9、我们在新建虚拟机 开机

![img]()

新建虚拟机



![img]()

等

- #### 到了这一步证明你的操作应该该是没有问题了，只需要耐心等待就可以了

- #### 报错

![img]()

报错

- #### 注：这里可能是你的httpd、dhcp、nftp服务没有开，打开再试一次

- #### 耐心等待，如果超时2次需要重新启动，因为开启了dhcp获取到了IP地址，但是无法下载文件 肯定会超时

![img]()

7.png-6.7kB

- #### 鼠标点进去选择刚才咱们配置好的系统，最后只需耐心等待，大功告成了！！！

- #### 10、网页管理cobbler

- #### 首先设置用户名跟密码

```cpp
[root@cobbler/server/tools]#  htdigest /etc/cobbler/users.digest "Cobbler" cobbler
```

![img]()

image.png

- #### 网页输入：[https://10.0.0.65/cobbler_web](https://links.jianshu.com/go?to=https%3A%2F%2F10.0.0.65%2Fcobbler_web)

- #### 报错：

![img]()

报错

- #### 解决方法

因为你的python版本只要高于1.18就会出现这个错误
 所以下就是解决办法

```csharp
[root@cobbler ~]# rpm -qa | grep "python2-django"
python2-django-1.11.20-1.el7.noarch
[root@cobbler ~]# rpm -e --nodeps python2-django-1.11.20-1.el7.noarch
[root@cobbler ~]# yum install python2-pip
[root@cobbler ~]# pip install --upgrade pip
[root@cobbler ~]# pip install Django==1.8.17
```

- #### 重启http

```csharp
[root@cobbler/server/tools]#  systemctl restart httpd
```

- #### 再次访问

![img]()

访问

- #### 这里的用户名是cobbler,密码就是你刚才输入的密码

- #### 我们可以查看profiles，点击Edit可以修改系统的一些选项

![img]()

查看

- #### 在kernel里面可以设置一些内核参数

![im
