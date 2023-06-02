# 安装 389 Directory Server

[TOC]

389 1.1及更高版本被拆分为具有相互依赖性的离散包。安装这些软件包的最好、最简单的方法是使用 yum 。Fedora 软件包可通过 yum 获得。

EPEL 提供了 Enterprise Linux 软件包。

## 安装

### Fedora/EPEL

```bash
yum install [--enablerepo=repo] 389-ds    
```

如果要安装测试包：

```bash
yum install 389-ds [--enablerepo=testingrepo] ...    
```

安装完成后，运行：

```bash
setup-ds-admin.pl    
```

- 运行 /usr/sbin/setup-ds-admin.pl 以设置新的目录服务器和管理服务器。

- Fedora DS 1.0.x 用户可以使用 /usr/sbin/migrate-ds-admin.pl 迁移现有目录和管理服务器数据。

  > NOTE:
  >
  > If you are upgrading from 1.0, DO NOT USE setup-ds-admin.pl - use migrate-ds-admin.pl instead
  >
  > 注意：如果从1.0升级，请不要使用setup-ds-admin.pl，而是使用migrate-ds-admin.php

- Console - the console command is /usr/bin/389-console - startconsole and fedora-idm-console have been removed

  控制台命令为/usr/bin/389控制台-startconsole和fedora idm控制台已被删除

### CentOS Stream 8/9, EL8/EL9 (ds 2.x)

`389-ds-base` 是 AppStream repository 的一部分，可以通过以下命令安装：

```bash
dnf module enable 389-ds
dnf install 389-ds-base
```

`cockpit-389-ds` 未在 AppStream 中分发。提供了两个独立的 copr 库，其中包含 `389-ds-base` 和 `cockpit-389-ds` ：

- [`@389ds/389-directory-server`](https://copr.fedorainfracloud.org/coprs/g/389ds/389-directory-server/) - rebuild of 389-ds-base package from the latest of the [currently supported releases](https://fedoraproject.org/wiki/Releases#Current_Supported_Releases) of Fedora.从当前支持的Fedora最新版本重建389 ds基本包。
- [`@389ds/389-directory-server-next`](https://copr.fedorainfracloud.org/coprs/g/389ds/389-directory-server-next/) - rebuild of 389-ds-base package from Fedora Rawhide, bleeding edge development version. **NOT RECOMMENDED** to be used in production, for testing purposes only.从Fedora-Rawhide重建389 ds基本包，出血边缘开发版本。不建议在生产中使用，仅用于测试目的。

```bash
dnf copr enable @389ds/389-directory-server
dnf install 389-ds-base cockpit-389-ds
```

If you’re upgrading from EPEL8 modular packages, enable copr repository and reset the old module:如果您正在从EPEL8模块化软件包升级，请启用copr存储库并重置旧模块：

```bash
dnf copr enable @389ds/389-directory-server
dnf update 389-ds-base cockpit-389-ds
dnf module reset 389-directory-server
```

### Installation of just base DS

Just install the 389-ds-base package.

```
yum install 389-ds-base    
```

Use setup-ds.pl to create an instance of directory server, or use migrate-ds.pl to migrate existing data.

使用setup-ds.pl创建目录服务器的实例，或者使用migrate-ds.pl迁移现有数据。

## 升级

如果您已经安装了 389 DS 1.1 或更高版本，只需使用以下命令升级。

```bash
yum upgrade [--enablerepo=repo] ...    
```

NOTE that this will also upgrade OS packages. See *man yum* to see how to include/exclude packages/repos from the update. NOTE that you must use **upgrade** *not update* in order for the 389 packages to obsolete and replace the fedora ds packages.

注意，这也将升级操作系统包。请参阅man-yum，了解如何在更新中包含/exclude-packages/repos。请注意，必须使用升级而非更新，389个软件包才能过时并替换fedora ds软件包。

如果要安装测试包：

```bash
yum upgrade [--enablerepo=testingrepo] ... [package to update] ....    
```

升级完成后，使用以下命令以更新您的安装。

```bash
setup-ds-admin.pl -u    
```

**You must use setup-ds-admin.pl -u in order to refresh your admin server and console information.**您必须使用setup-ds-admin.pl-u来刷新管理服务器和控制台信息。



## Installation via RPM

**NOTE: This only applies to Fedora DS 1.0.4 or earlier**. This installation method is not supported for Fedora DS 1.1 and later on those platforms that use yum.

Download the file fedora-ds-1.0.4-1.PLATFORM.ARCH.opt.rpm from the [Download](https://directory.fedoraproject.org/docs/389ds/download.html) site, where PLATFORM is one of RHEL3, RHEL4, FC4, FC5, or FC6 (use RHEL4 for FC3, and RHEL3 for FC2), and ARCH is either i386 or x86_64. You can install it with the browser (it may  prompt you to install it when you click on the link) or with the rpm  command like this:

```
rpm -Uvh fedora-ds-1.0.4-1.PLATFORM.ARCH.opt.rpm    
```

After the installation, you must run setup to configure or upgrade  your servers. To run setup, open a command window and do the following:

```
cd /opt/fedora-ds ; ./setup/setup    
```

This will give you several prompts. [Here](https://directory.fedoraproject.org/docs/389ds/legacy/oldsetup.html) are the detailed setup instructions. HINT: If you are evaluating Fedora Directory Server, use a suffix of  dc=example,dc=com during setup. This will allow you to load the example  database files which demonstrate the basic functions of the server as  well as more advanced features such as Roles, Virtual Views, and i18n  handling. You can use the -k argument to setup to save the .inf file for use with subsequent silent installs. This will create a file called  /opt/fedora-ds/setup/install.inf. You can edit this file and use it to  perform a silent install using

```
./setup/setup -s -f /path/to/myinstall.inf    
```

Note: if you are using password syntax checking, you must disable it  to avoid a Constraint Violation error running setup after upgrading:

```
ldapmodify -x -D "cn=directory manager" -w password    
dn: cn=config    
changetype: modify    
replace: passwordCheckSyntax    
passwordCheckSyntax: off    
```

Then, run setup as follows:

```
cd /opt/fedora-ds ; ./setup/setup    
```

Then, if you are using password syntax checking, enable it again:

```
ldapmodify -x -D "cn=directory manager" -w password    
dn: cn=config    
changetype: modify    
replace: passwordCheckSyntax    
passwordCheckSyntax: on    
```

通过RPM安装

注意：这仅适用于Fedora DS 1.0.4或更早版本。Fedora DS 1.1及更高版本在使用百胜的平台上不支持此安装方法。

从下载站点下载文件fedora-ds-1.4-1.PLATFORM.ARCH.opt.rpm，其中PLATFORM是RHEL3、RHEL4、FC4、FC5或FC6之一（对FC3使用RHEL4，对FC2使用RHEL3），ARCH是i386或x86 64。您可以使用浏览器安装它（当您单击链接时，它可能会提示您安装它），也可以使用rpm命令安装，如下所示：

转速-Uvh fedora-ds-10.4-1.平台.ARCH.opt.rpm

安装后，必须运行安装程序来配置或升级服务器。要运行安装程序，请打开命令窗口并执行以下操作：

cd/opt/fedora ds/设置/设置

这将为您提供几个提示。以下是详细的设置说明。提示：如果您正在评估Fedora Directory Server，请在安装过程中使用后缀dc=example，dc=com。这将允许您加载示例数据库文件

### Upgrading from the 7.1 release

**NOTE:** The migrate-ds-admin.pl script in Fedora DS 1.1 and later will migrate everything including the console information. So the steps outlined below should only be used if you are using Fedora DS 1.0.4.

Upgrading from 7.1 to 1.x will break the  console. After doing an upgrade installation (see above), you must do  the following steps in order to use the console:

```
cd /opt/fedora-ds/slapd-yourhost    
./db2ldif -U -s o=netscaperoot -a /tmp/nsroot.ldif    
```

The -U argument is important because you need to disable LDIF line wrapping for parsing purposes. Then, edit /tmp/nsroot. You will need to make the following replacements:

- replace ou=4.0 with ou=1.0
- replace ds71.jar with ds10.jar
- replace admserv70.jar with admserv10.jar

For example, the following sed command:

```
sed -e s/ou=4.0/ou=1.0/g -e s/ds71\\.jar/ds10.jar/g -e s/admserv71\\.jar/admserv10.jar/g /tmp/nsroot.ldif > /tmp/nsrootfixed.ldif    
```

Then, re-import the ldif file - use ldif2db.pl for on-line import:

```
cd /opt/fedora-ds/slapd-yourhost    
./ldif2db.pl -D "cn=directory manager" -w password -s o=netscaperoot -i /tmp/nsrootfixed.ldif    
```

## Installation from a developer build

If you built using the BUILD_RPM=1 flag (see [Building](https://directory.fedoraproject.org/docs/389ds/development/building.html)), you will create the Fedora DS RPM. This gives you the same RPM that is described above. For example, if you used the dsbuild/One Step Build method using

```
make BUILD_RPM=1    
```

you will have the following RPM:

```
dsbuild/ds/ldapserver/work/fedora-ds-1.0.3-1.RHEL4.i386.opt.rpm    
```

This is for RHEL4 x86 32bit. Depending on your platform, you may have Linux instead of RHEL or RHEL3 or RHEL4. But the packages should end in .opt.rpm at any rate. You can install directly from the location:

```
rpm -ivh dsbuild/ds/ldapserver/work/fedora-ds-1.0.3-1.RHEL4.i386.opt.rpm    
```

Then run setup as follows:

```
cd /opt/fedora-ds ; ./setup/setup    
```

[Here](https://directory.fedoraproject.org/docs/389ds/legacy/oldsetup.html) are the detailed setup instructions. HINT: If you are evaluating Fedora Directory Server, use a suffix of  dc=example,dc=com during setup. This will allow you to load the example  database files which demonstrate the basic functions of the server as  well as more advanced features such as Roles, Virtual Views, and i18n  handling. You can use the -k argument to setup to save the .inf file for use with subsequent silent installs. This will create a file called  /opt/fedora-ds/setup/install.inf. You can edit this file and use it to  perform a silent install using

```
./setup/setup -s -f /path/to/myinstall.inf    
```

## Installation via setuputil

There is no “make install” per se. The Directory Server build and  packaging process puts the files in a directory at the same level as the ldapserver build directory. That is, if you have ldap/ldapserver, the  build process will put the installable files in ldap/MM.DD/PLATFORMDIR where MM.DD are the two digit month and day, respectively, and the PLATFORMDIR represents the OS platform. On RHEL4, this looks like the following:

```
 RHEL4_x86_gcc3_DBG.OBJ    
```

For Fedora Core 4, and other Linux platforms, this will look something like this:

```
 Linux2.6_x86_gcc4_DBG.OBJ    
```

So the whole thing would be something like

```
 ldap/11.15/RHEL4_x86_gcc3_DBG.OBJ    
```

You can override this naming convention by specifying the INSTDIR=/full/path definition on the make command line.

In the package directory, either the MM.DD/PLATFORMDIR or overridden with INSTDIR, there will be an executable called “setup”. Just run the program as  “./setup” and follow the prompts to install and set up the directory  server. For example:

```
cd ldap/12.08/RHEL4_x86_gcc3_DBG.OBJ ; ./setup    
```

[Here](https://directory.fedoraproject.org/docs/389ds/legacy/oldsetup.html) are the detailed setup instructions. HINT: If you are evaluating Fedora Directory Server, use a suffix of  dc=example,dc=com during setup. This will allow you to load the example  database files which demonstrate the basic functions of the server as  well as more advanced features such as Roles, Virtual Views, and i18n  handling. You can use the -k argument to setup to save the .inf file for use with subsequent silent installs. This will create a file called  setup/install.inf in your server root directory. You can edit this file  and use it to perform a silent install using

```
./setup -s -f /path/to/myinstall.inf    
```

## Verifying the Installation

To test the basic operation of the server, use the ldapsearch command:

```
/usr/bin/ldapsearch -x [-h <your host>] [-p <your port>] -s base -b "" "objectclass=*"    
```

If you do not have /usr/bin/ldapsearch, try  /usr/lib/mozldap/ldapsearch or /usr/lib64/mozldap/ldapsearch - as above, but omit the -x argument:

```
/usr/lib/mozldap/ldapsearch [-h <your host>] [-p <your port>] -s base -b "" "objectclass=*"    
```

If you are using Fedora DS 1.0.4 or earlier, ldapsearch is bundled with the server in the release directory under shared/bin.

```
cd /opt/fedora-ds/shared/bin    
./ldapsearch [-p <your port>] -s base -b "" "objectclass=*"    
```

(The -p  may be omitted if you are using the standard LDAP port 389). This should produce the contents of the root DSE entry, which lists server vendor, version, supported extensions, controls, and naming contexts.

You can also use the console. You must first set your JAVA_HOME environment variable so that the console can find the java runtime e.g.

```
export JAVA_HOME=/opt/j2sdk_1_4_2_07    
```

or wherever you have installed your jdk. You must also make sure the java command you want to run is in your PATH:

```
export PATH=/opt/j2sdk_1_4_2_07/bin:$PATH    
```

Then

```
/usr/bin/389-console    
```

If you are running Fedora DS 1.0.4 or earlier, do the following instead:

```
 cd /opt/fedora-ds ; ./startconsole    
```

For the admin username and password, provide the values that you  specified during setup. For the admin server url, if the field is blank, just use http://localhost:adminserverport/ where adminserverport is the port number you specified (default 9830)  for the admin server during setup. If you forget what your admin server  port number is, do this:

```
grep \^Listen /etc/dirsrv/admin-serv/console.conf    
```

or on Fedora DS 1.0.4 and earlier:

```
grep \^Listen /opt/fedora-ds/admin-serv/config/console.conf    
```

If you used a suffix of dc=example,dc=com, you can load one of the example database files. Follow the [directions here](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Populating_Directory_Databases.html) for importing from the console or the command line. Here are the files you can use:

- Example.ldif - a simple database to use to test basic server functionality
- Example-roles.ldif - illustrates how Roles work and how to use them
- Example-views.ldif - illustrates how Virtual Views work and how to use them
- European.ldif - shows how the server handles 8bit character sets

## Installing just the core directory server

An instance is one complete set of configuration files and databases  for the Directory Server. It is possible to run multiple instances from  one set of binaries.

Instance creation involves creating a base directory (a file system  directory, not a directory server) that lives under the release  directory, called “slapd-name” where name is usually the hostname, but  it can be whatever is desired. By default, all of the server specific  scripts, configuration files, and database data are placed in  this directory.

Instance creation is performed using the perl script      ds_newinst.pl    . The input to this script is a .inf file, the format  of which is described below. This file lets you set the FQDN, the port to listen on, the default suffix, the directory manager DN and password, and the userid of the server process, as well as several other optional settings.

```
ds_newinst.pl /full/path/to/install.inf    
```

You can find an example .inf file in /usr/share/doc/fedora-ds- (currently 1.1.0). You should make a copy of this file in another directory and edit it to suit your taste.

The script uses the information in the .inf file to create the  initial configuration files, copy in several other configuration files,  create many server administration scripts (e.g. ldif2db, db2ldif, etc.), create the initial database, and create the default suffix, and start  up the server. See below for more information about the .inf  file format.

Once this is done, the script should output a “Success” message if all went well. See [FHS_Packaging](https://directory.fedoraproject.org/docs/389ds/development/fhs-packaging.html) for more information about where the instance specific files are created by ds_newinst.pl.

### inf File Format for core directory server installation

A sample .inf file is listed below

```
[General]    
FullMachineName=   myhost.mydomain.tld    
SuiteSpotUserID=   nobody    
ServerRoot=        /usr/lib/fedora-ds    
[slapd]    
ServerPort=        389    
ServerIdentifier=  myhost    
Suffix=   dc=myhost,dc=mydomain,dc=tld    
RootDN=   cn=Directory Manager    
RootDNPwd=   password    
```

The [General] and [slapd] sections are there for historical reasons and are required.

| Name                                                      | Required?                                                    | Description                                              | Example                                                      |
| --------------------------------------------------------- | ------------------------------------------------------------ | -------------------------------------------------------- | ------------------------------------------------------------ |
| SuiteSpotUserID                                           | required                                                     | the Unix user that the Directory Server will run as      | nobody (possibly ldap)                                       |
| FullMachineName                                           | required                                                     | the fully qualified host and domain name                 | oak.devel.example.com                                        |
| ServerRoot                                                | required                                                     | the base directory where the runtime files are installed | /usr/lib/fedora-ds                                           |
| ConfigDirectoryAdminID                                    | optional                                                     | user ID for console login                                | admin                                                        |
| ConfigDirectoryAdminPwd                                   | optional                                                     | password for ConfigDirectoryAdminID                      | password                                                     |
| ConfigDirectoryLdapURL                                    | optional                                                     | LDAP URL for the Configuration Directory                 |                                                              |
| the suffix is required and will usually be o=NetscapeRoot | [ldap://host.domain.tld:port/o=NetscapeRoot](ldap://host.domain.tld:port/o=NetscapeRoot) |                                                          |                                                              |
| AdminDomain                                               | optional                                                     | the administrative domain this instance will belong to   | devel.example.com                                            |
| UserDirectoryLdapURL                                      | optional                                                     | the user/group directory used by the Console             | [ldap://host.domain.tld:port/dc=devel,dc=example,dc=com](ldap://host.domain.tld:port/dc=devel,dc=example,dc=com) |

| Name                                                 | Required?                  | Description                                                  | Example                    |
| ---------------------------------------------------- | -------------------------- | ------------------------------------------------------------ | -------------------------- |
| ServerPort                                           | required                   | the port number the server will listen to                    | 389                        |
| ServerIdentifier                                     | required                   | the base name of the directory that contains the instance    |                            |
| of this server - will have “slapd-“ added to it      | oak                        |                                                              |                            |
| Suffix                                               | required                   | the primary suffix for this server (more can be added later) | dc=devel,dc=example,dc=com |
| RootDN                                               | required                   | the DN for the Directory Administrator                       | cn=Directory Manager       |
| RootDNPwd                                            | required                   | the password for the RootDN                                  | itsasecret                 |
| InstallLdifFile                                      | optional                   | use this LDIF file to initialize the database                |                            |
| the suffix must be specified in the Suffix directive | /full/path/to/Example.ldif |                                                              |                            |
| SlapdConfigForMC                                     | optional                   | if true (1), configure this new DS instance as a             |                            |
| Configuration Directory Server                       | 1                          |                                                              |                            |
| UseExistingMC                                        | optional                   | if true (1), register this DS with the Configuration DS      | 1                          |
| UseExistingUG                                        | optional                   | if true (1), do not configure this DS as a user/group directory |                            |
| but use the one specified by UserDirectoryLdapURL    | 1                          |                                                              |                            |

## 删除

### 删除实例

First, remove any directory server instances and un-register them from the console. **Make sure you back up your data first**首先，删除所有目录服务器实例，并从控制台中注销它们。确保先备份数据

```bash
ls /etc/dirsrv    
```

This will list your directory server instances. The directory will begin with *slapd-*. A path whose name ends with *.removed* has already been removed. Then, for each instance, run这将列出您的目录服务器实例。目录将以slapd-开头。名称以.removed结尾的路径已被删除。然后，对于每个实例，运行

```bash
ds_removal -s slapd-INSTANCENAME -w admin_password    
```

where slapd-INSTANCENAME is the name of the sub-directory under /etc/dirsrv, and *admin_password* is the password you use with the console.其中slapd INSTANCENAME是/etc/dirsrv下的子目录的名称，admin password是您在控制台中使用的密码。

If you are not using the console, you can use如果您没有使用控制台，您可以使用

```bash
remove-ds.pl -i slapd-INSTANCENAME    
```

to remove instances.以删除实例。

Using ds_removal or remove-ds.pl will remove all of the instance specific files and paths except for the slapd-INSTANCENAME directory, which is just renamed to slapd-INSTANCENAME.removed. If you don’t want to keep any of your configuration or key/cert data, you can erase this directory.使用ds remove或remove-ds.pl将删除除slapd  INSTANCENAME目录之外的所有特定于实例的文件和路径，该目录刚刚重命名为slapd-INSTANCENAME.removed。如果您不想保留任何配置或密钥/证书数据，可以删除此目录。

If you are using the console/admin server, and the machine is the one hosting the configuration directory server (i.e. this is the first  machine you ran setup-ds-admin.pl on), and you just want to wipe out  everything and start over, use *remove-ds-admin.pl*

如果您使用的是console/admin服务器，而该计算机是承载配置目录服务器的计算机（即，这是您运行setup-ds-admin.pl的第一台计算机），并且您只想清除所有内容并重新开始，请使用remove-ds-admin.pl

```bash
remove-ds-admin.pl [-y] [-f]    
```

You must specify -y in order to actually do anything. Use -f to force removal.您必须指定-y才能实际执行任何操作。使用-f强制删除。

### 删除程序包

```bash
yum erase 389-ds-base-libs 389-adminutil idm-console-framework    
```

yum will remove all packages that depend on these packages as well.  389-ds-base-libs is for 389-ds-base and -devel - 389-adminutil will pick up 389-admin and 389-dsgw - idm-console-framework will pick up the  console packages.百胜还将删除所有依赖于这些软件包的软件包。389-ds-base-libs用于389-ds-base，-devel-389 adminutil将获取389 admin，389-dsgw-idm控制台框架将获取控制台包。

### 额外清理

After removing all of the packages, you can do something like this to make sure your system is back to a clean state:删除所有程序包后，您可以执行以下操作以确保系统恢复到干净状态：

```bash
rm -rf /etc/dirsrv /usr/lib*/dirsrv /var/*/dirsrv /etc/sysconfig/dirsrv*    
```
