# Oracle® Database

## Installation

11g Release 2 (11.2) for Linux x86-64

### 1. Logging In to the System as root

### 2. install the software from an X Window System workstation, an X  terminal, or a PC or other system with X server software installed

### 3. Checking the Hardware Requirements

​        **Memory Requirements**

​        Minimum: 1 GB of RAM

​        Recommended: 2 GB of RAM or more

​         确认内存空间

​         `# grep MemTotal /proc/meminfo`

​        **swap space**

| Available RAM          | Swap Space Required           |
| ---------------------- | ----------------------------- |
| Between 1 GB and 2 GB  | 1.5 times the size of the RAM |
| Between 2 GB and 16 GB | Equal to the size of the RAM  |
| More than 16 GB        | 16 GB                         |

​          确认swap space

​          `# grep SwapTotal /proc/meminfo`

​         **Automatic Memory Management**

​         the Automatic Memory Management feature requires more shared memory (`/dev/shm)`

​         and file descriptors. The shared memory should be sized to be at least the greater of

​          `MEMORY_MAX_TARGET` and `MEMORY_TARGET` for each Oracle instance on that computer.

​          determine the amount of shared memory available, enter the following command:

​          `# df -h /dev/shm/`

​         **System Architecture**

​          `# uname -m`

​          **Disk Space Requirements**

​          At least 1 GB of disk space in the `/tmp` directory

​          Disk Space for each installation type on Linux  x86-64:

| Installation Type  | Requirement for Software Files (GB) |
| ------------------ | ----------------------------------- |
| Enterprise Edition | 4.7                                 |
| Standard Edition   | 4.6                                 |

| Installation Type  | Requirement for Data Files (GB) |
| ------------------ | ------------------------------- |
| Enterprise Edition | 1.7                             |
| Standard Edition   | 1.5                             |



### 4. Checking the Software Requirements

**Operating System Requirements**

- 11g Release 2 (11.2.0.4), Oracle Linux 7 and RHEL 7
- 11g Release 2 (11.2.0.3), Oracle Linux 6 and RHEL 6
- 11g Release 2 (11.2.0.3), Asianux 4 
- 11g Release 2 (11.2.0.4), SUSE Linux Enterprise Server 12
- 11g Release 2 (11.2.0.4), NeoKylin Linux Advanced Server 6

- Asianux Server 3 SP2
- Asianux Server 4 SP3
- Oracle Linux 4 Update 7
- Oracle Linux 5 Update 2 (with Red Hat Compatible Kernel)
- Oracle Linux 5 Update 5
- Oracle Linux 6
- Oracle Linux 6 (with Red Hat Compatible Kernel)
- Oracle Linux 7
- Oracle Linux 7 (with the Red Hat Compatible Kernel)
- Red Hat Enterprise Linux 4 Update 7
- Red Hat Enterprise Linux 5 Update 2
- Red Hat Enterprise Linux 6
- Red Hat Enterprise Linux 7
- SUSE Linux Enterprise Server 10 SP2
- SUSE Linux Enterprise Server 11
- SUSE Linux Enterprise Server 12 SP1
- NeoKylin Linux Advanced Server 6
- NeoKylin Linux Advanced Server 7

​    distribution and version of Linux installed, enter the following command:

​     `# cat/proc/version`

​	**Kernel Requirements**

- On Oracle Linux 4 and Red Hat Enterprise Linux 4

  2.6.9 or later

- On Oracle Linux 5 Update 2 with Red Hat Compatible Kernel

  2.6.18 or later

- On Oracle Linux 5 Update 5 with Red Hat Compatible Kernel

  2.6.18 or later

- On Oracle Linux 5 Update 5 with Unbreakable Enterprise Kernel

  2.6.32-100.0.19 or later

- On Oracle Linux 6

  2.6.32-100.28.5.el6.x86_64 or later

- On Oracle Linux 6 with Red Hat Compatible Kernel

  2.6.32-71.el6.x86_64 or later

- On Oracle Linux 7

  3.8.13-33.el7uek.x86_64 or later

- On Oracle Linux 7 with Red Hat Compatible Kernel

  3.10.0-54.0.1.el7.x86_64 or later

- On Red Hat Enterprise Linux 5 Update 2

  2.6.18 or later

- On Red Hat Enterprise Linux 5 Update 5

  2.6.18 or later

- On Red Hat Enterprise Linux 6

  2.6.32-71.el6.x86_64 or later

- On Red Hat Enterprise Linux 7

  3.10.0-54.0.1.el7.x86_64 or later

- On Asianux Server 3

  2.6.18 or later

- On Asianux Server 4

  2.6.32-71.el6.x86_64 or later

- On SUSE Linux Enterprise Server 10

  2.6.16.21 or later

- On SUSE Linux Enterprise Server 11

  2.6.27.19 or later

- On SUSE Linux Enterprise Server 12

  3.12.49-11 or later

- On NeoKylin Linux Advanced Server 6

  2.6.32-431.el6.x86_64 or later

- On NeoKylin Linux Advanced Server 7

  3.10.0-327.el7.x86_64 or later

  determine whether the required kernel is installed, enter the following command:

  `# uname -r`

In this example, the output shows the kernel version (`2.6.18`) and errata level (`-128.el5PAE`) on the system.

If the kernel version does not meet the requirement specified earlier  in this section, then contact the operating system vendor for  information about obtaining and installing kernel updates.

​	**Package Requirements**

The following are the list of packages required for Oracle Database 11g Release 2 (11.2):

Note:

- Oracle recommends that you install your Linux operating system with  the default software packages (RPMs), unless you specifically intend to  perform a minimal installation, and follow the directions for performing  such an installation to ensure that you have all required packages for  Oracle software.
- Oracle recommends that you do not customize RPMs during a default  operating system installation. A default installation includes most  required packages, and helps you to limit manual checks of package  dependencies.
- If you did not perform a default Linux installation, you intend to use LDAP, and you want to use the scripts `odisrvreg`, `oidca`, or `schemasync`, then install the Korn shell RPM for your Linux distribution.
- You must install the packages (or later versions) listed in the  following table. Also, ensure that the list of RPMs and all the  prerequisites for these RPMs are installed.
- If you are using Oracle Unbreakable Enterprise Kernel, then all  required kernel packages are installed as part of the Oracle Unbreakable  Enterprise Kernel installation.
- For Orace Linux 6 the Oracle Validated RPM has been replaced by the  Oracle RDBMS Server 11gR2 Pre-install RPM. See the "Completing a Minimal  Linux Installation" section in [Oracle Database Installation Guide](http://www.oracle.com/pls/topic/lookup?ctx=db112&id=GINST).

Note:

- The following or later version of packages for Oracle Linux 4 and Red Hat Enterprise Linux 4 must be installed:

  ```
  binutils-2.15.92.0.2
  compat-libstdc++-33-3.2.3
  compat-libstdc++-33-3.2.3 (32 bit)
  elfutils-libelf-0.97
  elfutils-libelf-devel-0.97
  expat-1.95.7
  gcc-3.4.6
  gcc-c++-3.4.6
  glibc-2.3.4-2.41
  glibc-2.3.4-2.41 (32 bit)
  glibc-common-2.3.4
  glibc-devel-2.3.4
  glibc-headers-2.3.4
  libaio-0.3.105
  libaio-0.3.105 (32 bit)
  libaio-devel-0.3.105
  libaio-devel-0.3.105 (32 bit)
  libgcc-3.4.6
  libgcc-3.4.6 (32-bit)
  libstdc++-3.4.6
  libstdc++-3.4.6 (32 bit)
  libstdc++-devel 3.4.6
  make-3.80
  numactl-0.6.4.x86_64
  pdksh-5.2.14
  sysstat-5.0.5
  ```

- The following or later version of packages for Oracle Linux 5, Red  Hat Enterprise Linux 5, and Asianux Server 3 must be installed:

  ```
  binutils-2.17.50.0.6
  compat-libstdc++-33-3.2.3
  compat-libstdc++-33-3.2.3 (32 bit)
  elfutils-libelf-0.125
  elfutils-libelf-devel-0.125
  gcc-4.1.2
  gcc-c++-4.1.2
  glibc-2.5-24
  glibc-2.5-24 (32 bit)
  glibc-common-2.5
  glibc-devel-2.5
  glibc-devel-2.5 (32 bit)
  glibc-headers-2.5
  ksh-20060214
  libaio-0.3.106
  libaio-0.3.106 (32 bit)
  libaio-devel-0.3.106
  libaio-devel-0.3.106 (32 bit)
  libgcc-4.1.2
  libgcc-4.1.2 (32 bit)
  libstdc++-4.1.2
  libstdc++-4.1.2 (32 bit)
  libstdc++-devel-4.1.2
  make-3.81
  sysstat-7.0.2
  ```

- The following or later version of packages for Oracle Linux 6, Red  Hat Enterprise Linux 6, and Asianux Server 4 must be installed:

  ```
  binutils-2.20.51.0.2-5.11.el6 (x86_64)
  compat-libcap1-1.10-1 (x86_64)
  compat-libstdc++-33-3.2.3-69.el6 (x86_64)
  compat-libstdc++-33-3.2.3-69.el6.i686
  gcc-4.4.4-13.el6 (x86_64)
  gcc-c++-4.4.4-13.el6 (x86_64)
  glibc-2.12-1.7.el6 (i686)
  glibc-2.12-1.7.el6 (x86_64)
  glibc-devel-2.12-1.7.el6 (x86_64)
  glibc-devel-2.12-1.7.el6.i686
  ksh
  libgcc-4.4.4-13.el6 (i686)
  libgcc-4.4.4-13.el6 (x86_64)
  libstdc++-4.4.4-13.el6 (x86_64)
  libstdc++-4.4.4-13.el6.i686
  libstdc++-devel-4.4.4-13.el6 (x86_64)
  libstdc++-devel-4.4.4-13.el6.i686
  libaio-0.3.107-10.el6 (x86_64)
  libaio-0.3.107-10.el6.i686
  libaio-devel-0.3.107-10.el6 (x86_64)
  libaio-devel-0.3.107-10.el6.i686
  make-3.81-19.el6
  sysstat-9.0.4-11.el6 (x86_64)
  ```

- The following or later version of packages for Oracle Linux 7, and Red Hat Enterprise Linux 7 must be installed:

  ```
  binutils-2.23.52.0.1-12.el7.x86_64 
  compat-libcap1-1.10-3.el7.x86_64 
  compat-libstdc++-33-3.2.3-71.el7.i686
  compat-libstdc++-33-3.2.3-71.el7.x86_64
  gcc-4.8.2-3.el7.x86_64 
  gcc-c++-4.8.2-3.el7.x86_64 
  glibc-2.17-36.el7.i686 
  glibc-2.17-36.el7.x86_64 
  glibc-devel-2.17-36.el7.i686 
  glibc-devel-2.17-36.el7.x86_64 
  ksh
  libaio-0.3.109-9.el7.i686 
  libaio-0.3.109-9.el7.x86_64 
  libaio-devel-0.3.109-9.el7.i686 
  libaio-devel-0.3.109-9.el7.x86_64 
  libgcc-4.8.2-3.el7.i686 
  libgcc-4.8.2-3.el7.x86_64 
  libstdc++-4.8.2-3.el7.i686 
  libstdc++-4.8.2-3.el7.x86_64 
  libstdc++-devel-4.8.2-3.el7.i686 
  libstdc++-devel-4.8.2-3.el7.x86_64 
  libXi-1.7.2-1.el7.i686 
  libXi-1.7.2-1.el7.x86_64 
  libXtst-1.2.2-1.el7.i686 
  libXtst-1.2.2-1.el7.x86_64 
  make-3.82-19.el7.x86_64 
  sysstat-10.1.5-1.el7.x86_64
  ```

- The following or later version of packages for SUSE Linux Enterprise Server 10 must be installed:

  ```
  binutils-2.16.91.0.5
  compat-libstdc++-5.0.7
  gcc-4.1.0
  gcc-c++-4.1.2
  glibc-2.4-31.63
  glibc-devel-2.4-31.63
  glibc-devel-32bit-2.4-31.63
  ksh-93r-12.9
  libaio-0.3.104
  libaio-32bit-0.3.104
  libaio-devel-0.3.104
  libaio-devel-32bit-0.3.104
  libelf-0.8.5
  libgcc-4.1.2
  libstdc++-4.1.2
  libstdc++-devel-4.1.2
  make-3.80
  numactl-0.9.6.x86_64
  sysstat-8.0.4
  ```

- The following or later version of packages for SUSE Linux Enterprise Server 11 must be installed:

  ```
  binutils-2.19
  gcc-4.3
  gcc-32bit-4.3
  gcc-c++-4.3
  glibc-2.9
  glibc-32bit-2.9
  glibc-devel-2.9
  glibc-devel-32bit-2.9
  ksh-93t
  libaio-0.3.104
  libaio-32bit-0.3.104
  libaio-devel-0.3.104
  libaio-devel-32bit-0.3.104
  libstdc++33-3.3.3
  libstdc++33-32bit-3.3.3
  libstdc++43-4.3.3_20081022
  libstdc++43-32bit-4.3.3_20081022
  libstdc++43-devel-4.3.3_20081022
  libstdc++43-devel-32bit-4.3.3_20081022
  libgcc43-4.3.3_20081022
  libstdc++-devel-4.3
  make-3.81
  sysstat-8.1.5
  ```

- The following or later version of packages for SUSE Linux Enterprise Server 12: must be installed:

  ```
  binutils-2.25.0-13.1
  gcc-4.8-6.189
  gcc48-4.8.5-24.1
  glibc-2.19-31.9
  glibc-32bit-2.19-31.9
  glibc-devel-2.19-31.9.x86_64
  glibc-devel-32bit-2.19-31.9.x86_64
  libaio1-0.3.109-17.15
  libaio-devel-0.3.109-17.15
  libcap1-1.10-59.61
  libstdc++48-devel-4.8.5-24.1.x86_64
  libstdc++48-devel-32bit-4.8.5-24.1.x86_64
  libstdc++6-5.2.1+r226025-4.1.x86_64
  libstdc++6-32bit-5.2.1+r226025-4.1.x86_64
  libstdc++-devel-4.8-6.189.x86_64
  libstdc++-devel-32bit-4.8-6.189.x86_64
  libgcc_s1-5.2.1+r226025-4.1.x86_64
  libgcc_s1-32bit-5.2.1+r226025-4.1.x86_64
  mksh-50-2.13
  make-4.0-4.1.x86_64
  sysstat-10.2.1-3.1.x86_64
  xorg-x11-driver-video-7.6_1-14.30.x86_64
  xorg-x11-server-7.6_1.15.2-36.21.x86_64
  xorg-x11-essentials-7.6_1-14.17.noarch
  xorg-x11-Xvnc-1.4.3-7.2.x86_64
  xorg-x11-fonts-core-7.6-29.45.noarch
  xorg-x11-7.6_1-14.17.noarch
  xorg-x11-server-extra-7.6_1.15.2-36.21.x86_64
  xorg-x11-libs-7.6-45.14.noarch
  xorg-x11-fonts-7.6-29.45.noarch
  ```

  Note:

   You must download and install patch 18370031. For more information about how to download and install this patch, see: 

  `https://support.oracle.com/`

  [Oracle Database Client Installation Guide for Linux](https://docs.oracle.com/cd/E11882_01/install.112/e24322/toc.htm)

- The following or later version of packages for NeoKylin Linux Advanced Server 6 must be installed:

  ```
  binutils-2.20.51.0.2-5.36.el6 (x86_64) 
  compat-libcap1-1.10-1 (x86_64) 
  compat-libstdc++-33-3.2.3-69.el6 (x86_64) 
  compat-libstdc++-33-3.2.3-69.el6 (i686) 
  gcc-4.4.7-4.el6 (x86_64) 
  gcc-c++-4.4.7-4.el6 (x86_64) 
  glibc-2.12-1.132.el6 (i686) 
  glibc-2.12-1.132.el6 (x86_64) 
  glibc-devel-2.12-1.132.el6 (x86_64) 
  glibc-devel-2.12-1.132.el6 (i686) 
  ksh 
  libgcc-4.4.7-4.el6 (i686) 
  libgcc-4.4.7-4.el6 (x86_64) 
  libstdc++-4.4.7-4.el6 (x86_64) 
  libstdc++-4.4.7-4.el6 (i686) 
  libstdc++-devel-4.4.7-4.el6 (x86_64) 
  libstdc++-devel-4.4.7-4.el6 (i686) 
  libaio-0.3.107-10.el6 (x86_64) 
  libaio-0.3.107-10.el6 (i686) 
  libaio-devel-0.3.107-10.el6 (x86_64) 
  libaio-devel-0.3.107-10.el6 (i686) 
  make-3.81-20.el6
  sysstat-9.0.4-22.el6 (x86_64)
  ```

- The following or later version of packages for NeoKylin Linux Advanced Server 7 must be installed:

  ```
  binutils-2.23.52.0.1-55.el7.x86_64
  compat-libcap1-1.10-7.el7.x86_64
  gcc-4.8.5-4.el7.ns7.01.x86_64
  gcc-c++-4.8.5-4.el7.ns7.01.x86_64
  glibc-2.17-105.el7.ns7.01.i686
  glibc-2.17-105.el7.ns7.01.x86_64
  glibc-devel-2.17-105.el7.ns7.01.i686
  glibc-devel-2.17-105.el7.ns7.01.x86_64
  ksh-20120801-22.el7_1.2.x86_64
  libaio-0.3.109-13.el7.i686
  libaio-0.3.109-13.el7.x86_64
  libaio-devel-0.3.109-13.el7.i686
  libaio-devel-0.3.109-13.el7.x86_64
  libgcc-4.8.5-4.el7.ns7.01.i686
  libgcc-4.8.5-4.el7.ns7.01.x86_64
  libstdc++-4.8.5-4.el7.ns7.01.i686
  libstdc++-4.8.5-4.el7.ns7.01.x86_64
  libstdc++-devel-4.8.5-4.el7.ns7.01.i686
  libstdc++-devel-4.8.5-4.el7.ns7.01.x86_64
  libXi-1.7.4-2.el7.i686
  libXi-1.7.4-2.el7.x86_64
  libXtst-1.2.2-2.1.el7.i686
  libXtst-1.2.2-2.1.el7.x86_64
  make-3.82-21.el7.x86_64
  sysstat-10.1.5-7.el7.x86_64
  ```

  **Compiler Requirements**

Intel C++ Compiler 10.1 or later and the version of GNU C and C++ compilers listed under ["Package Requirements"](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCGJCEA) are supported with these products.

Note:

 Intel Compiler v10.1 can be used only with the standard template libraries of the gcc versions mentioned in the 

Package Requirements

 section, to build Oracle C++ Call Interface (OCCI) applications. 

Oracle XML Developer's Kit is supported with the same compilers as OCCI.

​	**Additional Software Requirements**

Depending on the components you want to use, you must ensure that the following software are installed:

- [Oracle ODBC Drivers](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCFGFBH)
- [Oracle JDBC/OCI Drivers](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCEBIAG)
- [Linux-PAM Library](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#CIHEDCAH)
- [Oracle Messaging Gateway](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCEHEGJ)
- [Programming Languages](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#CHDIJIEG)
- [Browser Requirements](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCEDEEH)



#### 4.5.1 Oracle ODBC Drivers

You should install ODBC Driver Manager for UNIX. You can download and install the Driver Manager from the following URL:

```
http://www.unixodbc.org
```

To use ODBC, you must also install the following additional ODBC RPMs, depending on your operating sytem:

- On Oracle Linux 4 and Red Hat Enterprise Linux 4:
  - `unixODBC-2.2.11 (32-bit)` or later
  - `unixODBC-devel-2.2.11 (64-bit)` or later
  - `unixODBC-2.2.11 (64-bit)` or later
- On Oracle Linux 5, Red Hat Enterprise Linux 5, and Asianux Server 3:
  - `unixODBC-2.2.11 (32-bit)` or later
  - `unixODBC-devel-2.2.11 (64-bit)` or later
  - `unixODBC-2.2.11 (64-bit)` or later
- On Oracle Linux 6, Red Hat Enterprise Linux 6, and Asianux Server 4:
  - `unixODBC-2.2.14-11.el6 (x86_64)` or later
  - `unixODBC-2.2.14-11.el6.i686` or later
  - `unixODBC-devel-2.2.14-11.el6 (x86_64)` or later
  - `unixODBC-devel-2.2.14-11.el6.i686` or later
- On Oracle Linux 7, and Red Hat Enterprise Linux 7:
  - `unixODBC-2.3.1-6.el7.x86_64 or later`
  - `unixODBC-2.3.1-6.el7.i686 or later`
  - `unixODBC-devel-2.3.1-6.el7.x86_64 or later`
  - `unixODBC-devel-2.3.1-6.el7.i686 or later`
- On SUSE 10:
  - `unixODBC-32 bit-2.2.11 (32-bit)` or later
  - `unixODBC-2.2.11 (64-bit)` or later
  - `unixODBC-devel-2.2.11 (64-bit)` or later
- On SUSE 11:
  - `unixODBC-2.2.12` or later
  - `unixODBC-devel-2.2.12` or later
  - `unixODBC-32bit-2.2.12 (32-bit)` or later
- On NeoKylin Linux Advanced Server 6:
  - `unixODBC-2.2.14-12.el6_3.i686` or later
  - `unixODBC-2.2.14-12.el6_3.x86_64` or later
  - `unixODBC-devel-2.2.14-12.el6_3.i686` or later
- On NeoKylin Linux Advanced Server 7:
  - `unixODBC-2.3.1-11.el7.i686` or later
  - `unixODBC-2.3.1-11.el7.x86_64` or later
  - `unixODBC-devel-2.3.1-11.el7.x86_64` or later



#### 4.5.2 Oracle JDBC/OCI Drivers

Use JDK 6 (Java SE Development Kit `1.6.0_21`) or JDK 5 (`1.5.0_24`)  with the JNDI extension with the Oracle Java Database Connectivity and  Oracle Call Interface drivers. However, these are not mandatory for the  database installation. Note that `IBM JDK 1.5` is installed with this release.



#### 4.5.3 Linux-PAM Library

Install the latest Linux-PAM (Pluggable Authentication Modules for  Linux) library to enable the system administrator to choose how  applications authenticate users.



#### 4.5.4 Oracle Messaging Gateway

Oracle Messaging Gateway supports the integration of Oracle Streams Advanced Queuing (AQ) with the following software:

- IBM WebSphere MQ V7.0, client and server:

  ```
  MQSeriesClient
  MQSeriesServer
  MQSeriesRuntime
  ```

- TIBCO Rendezvous 7.3

If you require a CSD for WebSphere MQ, then refer to the IBM website for download and installation information:

```
http://www.ibm.com/
```



#### 4.5.5 Programming Languages

The following products are certified for use with:

- Pro* COBOL

  Micro Focus Server Express 5.1



#### 4.5.6 Browser Requirements

You do not require a web browser to install Oracle Database. However,  browsers are required to access documentation, and if you intend to use  Oracle Enterprise Manager Database Control and Oracle Application  Express. Web browsers must support JavaScript, and the HTML 4.0 and CSS  1.0 standards.

Oracle Enterprise Manager Database Control supports the following browsers:

- Microsoft Internet Explorer 10.0 (supports Oracle Enterprise Manager Database Control 11.2.0.3 and higher)
- Microsoft Internet Explorer 9.0
- Microsoft Internet Explorer 8.0
- Microsoft Internet Explorer 7.0 SP1
- Microsoft Internet Explorer 6.0 SP2
- Firefox 21.0 (supports Oracle Enterprise Manager Database Control 11.2.0.4)
- Firefox 17.0.6 ESR (supports Oracle Enterprise Manager Database Control 11.2.0.4)
- Firefox 3.6
- Firefox 3.5
- Firefox 3.0.7
- Firefox 2.0
- Safari 4.0.x
- Safari 3.2
- Safari 3.1
- Google Chrome 27.0 (supports Oracle Enterprise Manager Database Control 11.2.0.4)
- Google Chrome 4.0
- Google Chrome 3.0
- Netscape Navigator 9.0
- Netscape Navigator 8.1

See Also:

Oracle Application Express Installation Guide

### 5. Creating Required Operating System Groups and Users

- The Oracle Inventory group (typically, `oinstall`)
- The OSDBA group (typically, `dba`)
- The Oracle software owner (typically, `oracle`)
- The OSOPER group (optional. Typically, `oper`)

To determine whether these groups and users exist, and if necessary, to create them, follow these steps:

1. To determine whether the `oinstall` group exists, enter the following command:

   ```
   # more /etc/oraInst.loc
   ```

   If the output of this command shows the `oinstall` group name, then the group exists.

   If the `oraInst.loc` file exists, then the output from this command is similar to the following:

   ```
   inventory_loc=/u01/app/oraInventory
   inst_group=oinstall
   ```

   The `inst_group` parameter shows the name of the Oracle Inventory group, `oinstall`.

2. To determine whether the `dba` group exists, enter the following command:

   ```
   # grep dba /etc/group
   ```

   If the output from this commands shows the `dba` group name, then the group exists.

3. If necessary, enter the following commands to create the `oinstall` and `dba` groups:

   ```
   # /usr/sbin/groupadd oinstall
   # /usr/sbin/groupadd dba
   ```

4. To determine whether the `oracle` user exists and belongs to the correct groups, enter the following command:

   ```
   # id oracle
   ```

   If the `oracle` user exists, then this command  displays information about the groups to which the user belongs. The  output should be similar to the following, indicating that `oinstall` is the primary group and `dba` is a secondary group:

   ```
   uid=440(oracle) gid=200(oinstall) groups=201(dba),202(oper)
   ```

5. If necessary, complete one of the following actions:

   - If the `oracle` user exists, but its primary group is not `oinstall` or it is not a member of the `dba` group, then enter the following command:

     ```
     # /usr/sbin/usermod -g oinstall -G dba oracle
     ```

   - If the `oracle` user does not exist, enter the following command to create it:

     ```
     # /usr/sbin/useradd -g oinstall -G dba oracle
     ```

     This command creates the `oracle` user and specifies `oinstall` as the primary group and `dba` as the secondary group.

6. Enter the following command to set the password of the `oracle` user:

   ```
   # passwd oracle
   ```

### 6 Configuring Kernel Parameters and Resource Limits

Verify that the kernel parameters shown in the following table are  set to values greater than or equal to the minimum value shown. The  procedure following the table describes how to verify and set the  values.

Note:

 The kernel parameter and shell limit values in this section are minimum  values only. For production database systems, Oracle recommends that you  tune these values to optimize the performance of the system. Refer to  your operating system documentation for more information about tuning  kernel parameters.

| Parameter                           | Minimum Value                                                | File                                     |
| ----------------------------------- | ------------------------------------------------------------ | ---------------------------------------- |
| `semmsl` `semmns` `semopm` `semmni` | 250 32000 100 128                                            | `/proc/sys/kernel/sem`                   |
| `shmall`                            | 2097152                                                      | `/proc/sys/kernel/shmall`                |
| `shmmax`                            | Minimum: 536870912 Maximum: A value that is 1 byte less than the physical memory Recommended: More than half the physical memory See My Oracle Support Note 567506.1 for additional information about configuring `shmmax`. | `/proc/sys/kernel/shmmax`                |
| `shmmni`                            | 4096                                                         | `/proc/sys/kernel/shmmni`                |
| `file`-`max`                        | 6815744                                                      | `/proc/sys/fs/file-max`                  |
| `ip_local_port_range`               | Minimum: 9000 Maximum: 65500                                 | `/proc/sys/net/ipv4/ip_local_port_range` |
| `rmem_default`                      | 262144                                                       | `/proc/sys/net/core/rmem_default`        |
| `rmem_max`                          | 4194304                                                      | `/proc/sys/net/core/rmem_max`            |
| `wmem_default`                      | 262144                                                       | `/proc/sys/net/core/wmem_default`        |
| `wmem_max`                          | 1048576                                                      | `/proc/sys/net/core/wmem_max`            |
| `aio-max-nr`                        | 1048576 Note: This value limits concurrent outstanding requests and should be set to avoid I/O subsystem failures. | `/proc/sys/fs/aio-max-nr`                |

Note:

 If the current value of any parameter is higher than the value listed in  this table, then do not change the value of that parameter.

To view the current value specified for these kernel parameters, and to change them if necessary:

- Enter commands similar to the following to view the current values of the kernel parameters:

  Note:

   Make a note of the current values and identify any values that you must change.

  | Parameter                                  | Command                                                      |
  | ------------------------------------------ | ------------------------------------------------------------ |
  | `semmsl`, `semmns`, `semopm`, and `semmni` | `# /sbin/sysctl -a | grep sem` This command displays the value of the semaphore parameters in the order listed. |
  | `shmall`, `shmmax`, and `shmmni`           | `# /sbin/sysctl -a | grep shm`                               |
  | `file-max`                                 | `# /sbin/sysctl -a | grep file-max`                          |
  | `ip_local_port_range`                      | `# /sbin/sysctl -a | grep ip_local_port_range`               |
  | `rmem_default`                             | `# /sbin/sysctl -a | grep rmem_default`                      |
  | `rmem_max`                                 | `# /sbin/sysctl -a | grep rmem_max`                          |
  | `wmem_default`                             | `# /sbin/sysctl -a | grep wmem_default`                      |
  | `wmem_max`                                 | `# /sbin/sysctl -a | grep wmem_max`                          |

- If the value of any kernel parameter is different from the recommended value, then complete the following steps:

  1. Using any text editor, create or edit the `/etc/sysctl.conf` file, and add or edit lines similar to the following:

     Note:

      Include lines only for the kernel parameter values to change. For the semaphore parameters (

     ```
     kernel.sem
     ```

     ),  you must specify all four values. However, if any of the current values  are larger than the minimum value, then specify the larger value.

     ```
     fs.aio-max-nr = 1048576
     fs.file-max = 6815744
     kernel.shmall = 2097152
     kernel.shmmax = 536870912
     kernel.shmmni = 4096
     kernel.sem = 250 32000 100 128
     net.ipv4.ip_local_port_range = 9000 65500
     net.core.rmem_default = 262144
     net.core.rmem_max = 4194304
     net.core.wmem_default = 262144
     net.core.wmem_max = 1048576
     ```

     By specifying the values in the `/etc/sysctl.conf`  file, they persist when you restart the system. However, on SUSE Linux  Enterprise Server systems, enter the following command to ensure that  the system reads the `/etc/sysctl.conf` file when it restarts:

     ```
     # /sbin/chkconfig boot.sysctl on
     ```

  2. Enter the following command to change the current values of the kernel parameters:

     ```
     # /sbin/sysctl -p
     ```

     Review the output from this command to verify that the values are  correct. If the values are incorrect, edit the /etc/sysctl.conf file,  then enter this command again.

  3. Enter the command `/sbin/sysctl -a` to confirm that the values are set correctly.

  4. On SUSE systems only, enter the following command to cause the system to read the `/etc/sysctl.conf` file when it restarts:

     ```
     # /sbin/chkconfig boot.sysctl on
     ```

  5. On SUSE systems only, you must enter the GID of the oinstall group as the value for the parameter `/proc/sys/vm/hugetlb_shm_group`. Doing this grants members of oinstall a group permission to create shared memory segments.

     For example, where the oinstall group GID is 501:

     ```
     # echo 501 > /proc/sys/vm/hugetlb_shm_group
     ```

     After running this command, use `vi` to add the following text to `/etc/sysctl.conf`, and enable the `boot.sysctl` script to run on system restart:

     ```
     vm.hugetlb_shm_group=501
     ```

     Note:

      Only one group can be defined as the 

     ```
     vm.hugetlb_shm_group
     ```

     .

  6. After updating the values of kernel parameters in the `/etc/sysctl.conf` file, either restart the computer, or run the command `sysctl -p` to make the changes in the `/etc/sysctl.conf` file available in the active kernel memory.

Check Resource Limits for the Oracle Software Installation Users

On Oracle Linux systems, Oracle recommends that you install Oracle  Preinstallation RPMs to meet preinstallation requirements like  configuring your operating system to set the resource limits in the `limits.conf` file. Oracle Preinstallation RPM only configures the `limits.conf` file for the `oracle` user. If you are implementing Oracle Grid Infrastructure job role separation, then copy the values from the `oracle` user to the `grid` user in the `limits.conf` file.

For each installation software owner, check the resource limits for installation, using the following recommended ranges:

Table 1 Installation Owner Resource Limit Recommended Ranges

| Resource Shell Limit                           | Resource | Soft Limit        | Hard Limit                              |
| ---------------------------------------------- | -------- | ----------------- | --------------------------------------- |
| Open file descriptors                          | nofile   | at least 1024     | at least 65536                          |
| Number of processes available to a single user | nproc    | at least 2047     | at least 16384                          |
| Size of the stack segment of the process       | stack    | at least 10240 KB | at least 10240 KB, and at most 32768 KB |

To check resource limits:

1. Log in as an installation owner.

2. Check the soft and hard limits for the file descriptor setting. Ensure that the result is in the recommended range. For example:

   ```
   $ ulimit -Sn
   4096
   $ ulimit -Hn
   65536
   ```

3. Check the soft and hard limits for the number of processes available  to a user. Ensure that the result is in the recommended range. For  example:

   ```
   $ ulimit -Su
   2047
   $ ulimit -Hu
   16384
   ```

4. Check the soft limit for the stack setting. Ensure that the result is in the recommended range. For example:

   ```
   $ ulimit -Ss
   10240
   $ ulimit -Hs
   32768
   ```

5. Repeat this procedure for each Oracle software installation owner.

If necessary, update the resource limits in the `/etc/security/limits.conf`  configuration file for the installation owner. However, note that the  configuration file is distribution specific. Contact your system  administrator for distribution specific configuration file information.

 	oracle                soft                     nofile                  1024 

 	oracle                hard          nofile                  65536 

 	oracle                soft                     nproc                 2047 

 	oracle                hard          nproc                 16384 

 	oracle                soft                     stack                  10240 

 	oracle                hard          stack                  32768 

Note:

 If the 

```
grid
```

 or 

```
oracle
```

  users are logged in, then changes in the limits.conf file do not take  effect until you log these users out and log them back in. You must do  this before you use these accounts for installation.

### 7 Creating Required Directories

Create directories with names similar to the following, and specify the correct owner, group, and permissions for them:

- The Oracle base directory
- An optional Oracle data file directory

The Oracle base directory must have 3 GB of free disk space, or 4 GB  of free disk space if you choose not to create a separate Oracle data  file directory.

Note:

 If you do not want to create a separate Oracle data file directory, then  you can install the data files in a subdirectory of the Oracle base  directory. However, this is not recommended for production databases.

To create the Oracle base directory:

1. Enter the following command to display information about all mounted file systems:

   ```
   # df -k
   ```

   This command displays information about all the file systems mounted on the system, including:

   - The physical device name
   - The total amount, used amount, and available amount of disk space
   - The mount point directory for that file system

2. From the display, identify either one or two file systems that meet  the disk space requirements mentioned earlier in this section.

3. Note the name of the mount point directory for each file system that you identified.

4. Enter commands similar to the following to create the recommended  subdirectories in the mount point directory that you identified and set  the appropriate owner, group, and permissions on them:

   ```
   # mkdir -p /mount_point/app/
   # chown -R oracle:oinstall /mount_point/app/
   # chmod -R 775 /mount_point/app/
   ```

   For example:

   ```
   # mkdir -p /u01/app/
   # chown -R oracle:oinstall /u01/app/
   # chmod -R 775 /u01/app/
   ```



## 8 Configuring the oracle User's Environment

You run Oracle Universal Installer from the `oracle` account. However, before you start Oracle Universal Installer, you must configure the environment of the `oracle` user. To configure the environment, you must:

- Set the default file mode creation mask (`umask`) to `022` in the shell startup file.
- Set the `DISPLAY` environment variable.

To set the `oracle` user's environment:

1. Start a new terminal session, for example, an X terminal (`xterm`).

2. Enter the following command to ensure that X Window applications can display on this system:

   ```
   $ xhost fully_qualified_remote_host_name
   ```

   For example:

   ```
   $ xhost somehost.us.example.com
   ```

3. If you are not logged in to the system where you want to install the software, then log in to that system as the `oracle` user.

4. If you are not logged in as the `oracle` user, then switch user to `oracle`:

   ```
   $ su - oracle
   ```

5. To determine the default shell for the `oracle` user, enter the following command:

   ```
   $ echo $SHELL
   ```

6. To run the shell startup script, enter one of the following commands:

   - Bash shell:

     ```
     $ . ./.bash_profile
     ```

   - Bourne or Korn shell:

     ```
     $ . ./.profile
     ```

   - C shell:

     ```
     % source ./.login
     ```

7. If you are not installing the software on the local computer, then run the following command on the remote computer to set the `DISPLAY` variable:

   - Bourne, Bash or Korn shell:

     ```
     $ export DISPLAY=local_host:0.0    
     ```

   - C shell:

     ```
     % setenv DISPLAY local_host:0.0
     ```

   In this example, `local_host` is the host name or IP address of the local computer to use to display Oracle Universal Installer.

   Run the following command on the remote computer to check if the shell and the DISPLAY environmental variable are set correctly:

   ```
   echo $SHELL
   echo $DISPLAY
   ```

   Now to enable X applications, run the following commands on the local computer:

   ```
   $ xhost + fully_qualified_remote_host_name
   ```

   To verify that X applications display is set properly, run a X11 based program that comes with the operating system such as `xclock`:

   ```
   $ xclock
   ```

   In this example, you can find `xclock` at `/usr/X11R6/bin/xclocks`. If the `DISPLAY` variable is set properly, then you can see `xclock` on your computer screen.

   See Also:

    PC-X Server or operating system vendor documents for further assistance

8. If you determined that the `/tmp` directory has less than 1 GB of free disk space, then identify a file system with at least 1 GB of free space and set the `TMP` and `TMPDIR` environment variables to specify a temporary directory on this file system:

   1. To determine the free disk space on each mounted file system use the following command:

      ```
      # df -h /tmp
      ```

   2. If necessary, enter commands similar to the following to create a  temporary directory on the file system that you identified, and set the  appropriate permissions on the directory:

      ```
      $ sudo mkdir /mount_point/tmp
      $ sudo chmod a+wr /mount_point/tmp
      # exit
      ```

   3. Enter commands similar to the following to set the `TMP` and `TMPDIR` environment variables:

      - Bourne, Bash, or Korn shell:

        ```
        $ TMP=/mount_point/tmp
        $ TMPDIR=/mount_point/tmp
        $ export TMP TMPDIR
        ```

      - C shell:

        ```
        % setenv TMP /mount_point/tmp
        % setenv TMPDIR /mount_point/tmp
        ```

9. Enter commands similar to the following to set the `ORACLE_BASE` `and ORACLE_SID` environment variables:

   - Bourne, Bash, or Korn shell:

     ```
     $ ORACLE_BASE=/u01/app/oracle
     $ ORACLE_SID=sales
     $ export ORACLE_BASE ORACLE_SID
     ```

   - C shell:

     ```
     % setenv ORACLE_BASE /u01/app/oracle
     % setenv ORACLE_SID sales
     ```

   In this example, `/u01/app/oracle` is the Oracle base directory that you created or identified earlier and `sales` is the database name (typically no more than five characters).

10. Enter the following commands to ensure that the `ORACLE_HOME` and `TNS_ADMIN` environment variables are not set:

    - Bourne, Bash, or Korn shell:

      ```
      $ unset ORACLE_HOME
      $ unset TNS_ADMIN
      ```

    - C shell:

      ```
      % unsetenv ORACLE_HOME
      % unsetenv TNS_ADMIN
      ```

    Note:

     If the 

    ```
    ORACLE_HOME
    ```

     environment variable is set,  then Oracle Universal Installer uses the value that it specifies as the  default path for the Oracle home directory. However, if you set the 

    ```
    ORACLE_BASE
    ```

     environment variable, then Oracle recommends that you unset the 

    ```
    ORACLE_HOME
    ```

     environment variable and choose the default path suggested by Oracle Universal Installer.



## 9 Mounting the Product Disc

On most Linux systems, the disk mounts automatically when you insert  it into the installation media. If the disk does not mount  automatically, then follow these steps to mount it:

1. Enter a command similar to the following to eject the currently mounted disc, then remove it from the drive:

   - Asianux, Oracle Linux, and Red Hat Enterprise Linux:

     ```
     $ sudo eject /mnt/dvd
     ```

   - SUSE Linux Enterprise Server:

     ```
     # eject /media/dvd
     ```

   In these examples, `/mnt/dvd` and `/media/dvd` are the mount point directories for the disc drive.

2. Insert the DVD into the disc drive.

3. To verify that the disc mounted automatically, enter a command similar to the following:

   - Asianux, Oracle Linux, and Red Hat Enterprise Linux:

     ```
     # ls /mnt/dvd
     ```

   - SUSE Linux Enterprise Server:

     ```
     # ls /media/dvd
     ```

4. If this command fails to display the contents of the disc, then enter a command similar to the following:

   - Asianux, Oracle Linux, and Red Hat Enterprise Linux:

     ```
     # mount -t iso9660 /dev/dvd /mnt/dvd
     ```

   - SUSE Linux Enterprise Server:

     ```
     # mount -t iso9660 /dev/dvd /media/dvd
     ```

   In these examples, `/mnt/dvd` and `/media/dvd` are the mount point directories for the disc drive.



## 10 Installing Oracle Database

After configuring the `oracle` user's environment, start Oracle Universal Installer and install Oracle Database as follows:

1. To start Oracle Universal Installer, enter the following command:

   ```
   $ /mount_point/db/runInstaller
   ```

   If Oracle Universal Installer does not start, then refer to [Oracle Database Installation Guide for Linux](https://docs.oracle.com/cd/E11882_01/install.112/e47689/toc.htm) for information about how to troubleshoot X Window display problems.

2. The following table describes the recommended action for each Oracle  Universal Installer screen. Use the following guidelines to complete the  installation:

   - If you need more assistance, or to choose an option that is not the default, then click Help for additional information.
   - If you encounter errors while installing or linking the software, then refer to Oracle Database Installation Guide for Linux for information about troubleshooting.

   Note:

    If you have completed the tasks listed previously, then you can complete  the installation by choosing the default values on most screens.

   | Screen                        | Recommended Action                                           |
   | ----------------------------- | ------------------------------------------------------------ |
   | Configure Security Updates    | Enter your e-mail address, preferably your My Oracle Support e-mail address or user name in the Email field. You can select the I wish to receive security updates via My Oracle Support check box to receive security updates. Enter your My Oracle Support password in the My Oracle Support Password field. Click Next. |
   | Download Software Updates     | Starting with Oracle Database 11g  Release 2 (11.2.0.2), you can use the Software Updates feature to  dynamically download and apply latest updates. Select one of the  following options and click Next:   Use My Oracle Support credentials for download: Select this option to download and apply the latest software updates. Click Proxy Settings to configure a proxy  for Oracle Universal Installer to use to connect to the Internet.  Provide the proxy server information for your site, along with a user  account that has access to the local area network through which the  server is connecting. Starting with Oracle Database 11g Release 2 (11.2.0.3), you can enter the Proxy Realm information if required. The proxy realm information is case-sensitive. Click Test Connection to ensure that your proxy settings are correctly entered, and the installer can download the updates.   Use pre-downloaded software updates: Select this option to apply previously downloaded software updates.   Skip Software Updates: Select this option if you do not want to apply any updates. |
   | Apply Software Updates        | This screen is  displayed if you select to download the software updates or provide the  pre-downloaded software downloads location. If you selected Use My Oracle Support credentials for download in the previous screen, select Download and apply all updates, and then click Next. If you selected Use pre-downloaded software updates in the previous screen, select Apply all updates, and then click Next. |
   | Select Installation Option    | Select Create and configure a database from the following list of available options, then click Next:   Create and configure a database   Install database software only   Upgrade an existing database |
   | System Class                  | Select Server Class from the following options to install the database, and click Next.   Desktop Class: Choose this option if you are installing on a laptop or desktop class system.   Server Class: Choose this option if you are installing on a server  class system, such as what you would use when deploying Oracle in a  production data center. |
   | Grid Installation Options     | Select Single instance database installation for the type of database installation you want to perform, and click Next.   Single instance database installation: This option installs the database and the listener.   Real Application Clusters database installation: This option installs Oracle Real Application Clusters.   Oracle RAC One Node database installation: This option installs the Oracle RAC One Node database. Note: Oracle RAC One Node is supported only with Oracle Clusterware. |
   | Select Install Type           | Select Typical Install as the installation type from the following options, and click Next:   Typical Install: This installation method is selected by default. It  lets you quickly install Oracle Database using minimal input.   Advanced Install: This installation method enables to perform more complex installations. |
   | Typical Install Configuration | Enter the following information according to your requirements: Oracle base: The Oracle base path appears by default. You can change the path based on your requirement. Software location: In the Software Location  section, accept the default value or enter the Oracle home directory  path in which you want to install Oracle components. The directory path  should not contain spaces. Storage Type: Select File System, or Oracle Automatic Storage Management as the database storage option. Database file location: If you select File System as your storage type, then click Browse and specify a database file location. ASMSNMP Password: If you select Oracle Automatic Storage Management  as your Storage Type, then specify the password for the ASMSNMP user. Database edition: Select the database edition to install. OSDBA Group: The OSDBA group is selected by default. You can also select the OSDBA group from the list. Global database name: Specify the Global Database Name using the following syntax: `database_name.domain ` For example, `sales.us.example.com` Administrative password: Enter the password for the privileged database account. Confirm Password: Reenter, and confirm the password for the privileged database account. Click Next to continue. |
   | Create Inventory              | This screen is displayed only during the first installation of Oracle products on a system. Specify the full path of the Oracle Inventory directory. Ensure that the operating system group selected is `oinstall`. Click Next to continue. |
   | Perform Prerequisite Checks   | Verify that all the prerequisite checks succeed, and then click Next. Oracle Universal Installer checks the system to verify that it is  configured correctly to run Oracle software. If you have completed all  the preinstallation steps in this guide, all the checks should pass. If a check fails, then review the cause of the failure listed for  that check on the screen. If possible, rectify the problem and rerun the  check. Alternatively, if you are satisfied that your system meets the  requirements, then you can select the check box for the failed check to  manually verify the requirement. Note: Oracle recommends that you use  caution in checking the Ignore All option. If you check this option,  then Oracle Universal Installer may not confirm if your system can  install Oracle Database successfully. |
   | Summary                       | Review the information displayed on this screen, and then click Install. Note: Starting with Oracle Database 11g Release 2 (11.2), you can save all the installation steps into a response file by clicking Save Response File. Later, this file can be used for a silent installation. |
   | Install Product               | This screen  states the progress of a database installation. After the database is  installed, you are prompted to execute some root configuration script  for new inventory as the `root` user. Click Next. This screen then displays the status information for the  configuration assistants that configure the software and create a  database. Finally, a message is displayed at the end of Database Configuration Assistant process, and click OK. Execute the `root.sh` script as the `root` user to complete the installation and click OK. |
   | Finish                        | This screen is shown automatically when all the configuration tools are successful. Click Close. |



## 11 Installing Oracle Database Examples

If you plan to use the following products or features, then download  and install the products from the Oracle Database Examples media:

- Oracle JDBC Development Drivers
- Oracle Database Examples
- Various Oracle product demonstrations

For information about installing software and various Oracle product  demonstrations from the Oracle Database Examples media, refer to [Oracle Database Examples Installation Guide](https://docs.oracle.com/cd/E11882_01/install.112/e24501/toc.htm).



## 12 What to Do Next?

To become familiar with this release of Oracle Database, it is recommended that you complete the following tasks:

- Log in to Oracle Enterprise Manager Database Control using a web browser.

  Oracle Enterprise Manager Database Control is a web-based application  that you can use to manage a single Oracle Database installation. The  default URL for Database Control is similar to the following:

  ```
  http://host.domain:1158/em/
  ```

  To log in, use the user name `SYS` and connect as `SYSDBA`. Use the password that you specified for this user during the Oracle Database 11g installation.

- Refer to [Oracle Database Installation Guide for Linux](https://docs.oracle.com/cd/E11882_01/install.112/e47689/toc.htm) for information about required and optional postinstallation tasks, depending on the products to use.

- Refer to [Oracle Database Installation Guide for Linux](https://docs.oracle.com/cd/E11882_01/install.112/e47689/toc.htm) for information about how to use Database Control to learn about the configuration of your installed database.

- To learn more about using Oracle Enterprise Manager Database Control to administer a database, refer to [Oracle Database 2 Day DBA](https://docs.oracle.com/cd/E11882_01/server.112/e10897/toc.htm).

  This guide, designed for new Oracle DBAs, describes how to use  Database Control to manage all aspects of an Oracle Database  installation. It also provides information about how to enable e-mail  notifications and automated backups, which you might not have configured  during the installation.



## 13 Additional Information

This section contains information about the following:

- [Product Licenses](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#CHDIHFAB)
- [Purchasing Licenses and Version Updates](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#CHDBHFFE)
- [Contacting Oracle Support Services](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#CHDCGFIC)
- [Locating Product Documentation](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#CHDFFCCA)

Product Licenses

You are welcome to install and evaluate the products included in this  media pack for 30 days under the terms of the Trial License Agreement.  However, you must purchase a program license if you want to continue  using any product after the 30 day evaluation period. See the following  section for information about purchasing program licenses.

Purchasing Licenses and Version Updates

You can purchase program licenses and updated versions of Oracle products from the Oracle Store website:

```
https://shop.oracle.com
```

Contacting Oracle Support Services

If you have purchased Oracle Product Support, you can call Oracle  Support Services for assistance 24 hours a day, seven days a week. For  information about purchasing Oracle Product Support or contacting Oracle  Support Services, go to the Oracle Support Services website:

```
http://www.oracle.com/us/support/index.html
```

Locating Product Documentation

Product documentation includes information about configuring, using,  or administering Oracle products on any platform. The product  documentation for Oracle Database products is available in both HTML and  PDF formats online:

```
http://docs.oracle.com/
```



## 14 Documentation Accessibility

For information about Oracle's commitment to accessibility, visit the Oracle Accessibility Program website at `http://www.oracle.com/pls/topic/lookup?ctx=acc&id=docacc`.

Access to Oracle Support

Oracle customers that have purchased support have access to  electronic support through My Oracle Support. For information, visit `http://www.oracle.com/pls/topic/lookup?ctx=acc&id=info` or visit `http://www.oracle.com/pls/topic/lookup?ctx=acc&id=trs` if you are hearing impaired.



------

Oracle Database Quick Installation Guide, 11g Release 2 (11.2) for Linux x86-64

E24326-09

Copyright © 2017, Oracle and/or its affiliates. All rights reserved.

This software and related documentation are provided under a license  agreement containing restrictions on use and disclosure and are  protected by intellectual property laws. Except as expressly permitted  in your license agreement or allowed by law, you may not use, copy,  reproduce, translate, broadcast, modify, license, transmit, distribute,  exhibit, perform, publish, or display any part, in any form, or by any  means. Reverse engineering, disassembly, or decompilation of this  software, unless required by law for interoperability, is prohibited.

The information contained herein is subject to change without notice  and is not warranted to be error-free. If you find any errors, please  report them to us in writing.

If this is software or related documentation that is delivered to the  U.S. Government or anyone licensing it on behalf of the U.S.  Government, then the following notice is applicable:

U.S. GOVERNMENT END USERS: Oracle programs, including any operating  system, integrated software, any programs installed on the hardware,  and/or documentation, delivered to U.S. Government end users are  "commercial computer software" pursuant to the applicable Federal  Acquisition Regulation and agency-specific supplemental regulations. As  such, use, duplication, disclosure, modification, and adaptation of the  programs, including any operating system, integrated software, any  programs installed on the hardware, and/or documentation, shall be  subject to license terms and license restrictions applicable to the  programs. No other rights are granted to the U.S. Government.

This software or hardware is developed for general use in a variety  of information management applications. It is not developed or intended  for use in any inherently dangerous applications, including applications  that may create a risk of personal injury. If you use this software or  hardware in dangerous applications, then you shall be responsible to  take all appropriate fail-safe, backup, redundancy, and other measures  to ensure its safe use. Oracle Corporation and its affiliates disclaim  any liability for any damages caused by use of this software or hardware  in dangerous applications.

Oracle and Java are registered trademarks of Oracle and/or its  affiliates. Other names may be trademarks of their respective owners.

Intel and Intel Xeon are trademarks or registered trademarks of Intel  Corporation. All SPARC trademarks are used under license and are  trademarks or registered trademarks of SPARC International, Inc. AMD,  Opteron, the AMD logo, and the AMD Opteron logo are trademarks or  registered trademarks of Advanced Micro Devices. UNIX is a registered  trademark of The Open Group.

This software or hardware and documentation may provide access to or  information about content, products, and services from third parties.  Oracle Corporation and its affiliates are not responsible for and  expressly disclaim all warranties of any kind with respect to  third-party content, products, and services unless otherwise set forth  in an applicable agreement between you and Oracle. Oracle Corporation  and its affiliates will not be responsible for any loss, costs, or  damages incurred due to your access to or use of third-party content,  products, or services, except as set forth in an applicable agreement  between you and Oracle.

Previous Page



Next Page

- ![Choose your language](https://docs.oracle.com/en/dcommon/img/func_worldglobe_16_act.png) 
  - 

- [About Oracle](http://www.oracle.com/corporate/index.html)
- [Contact Us](http://www.oracle.com/us/corporate/contact/index.html)
- [Legal Notices](http://www.oracle.com/us/legal/index.html)
- [Terms of Use](http://www.oracle.com/us/legal/terms/index.html)
- [Your Privacy Rights](http://www.oracle.com/us/legal/privacy/index.html)

[Copyright © 2017, Oracle and/or its affiliates. All rights reserved.](http://www.oracle.com/pls/topic/lookup?ctx=cpyr&id=en)

<iframe id="_atssh700" title="AddThis utility frame" style="height: 1px; width: 1px; position: absolute; top: 0px; z-index: 100000; border: 0px none; left: 0px;" src="https://s7.addthis.com/static/sh.e4e8af4de595fdb10ec1459d.html#rand=0.32524043198483166&amp;iit=1545960830869&amp;tmr=load%3D1545960830799%26core%3D1545960830817%26main%3D1545960830866%26ifr%3D1545960830871&amp;cb=0&amp;cdn=0&amp;md=0&amp;kw=&amp;ab=-&amp;dh=docs.oracle.com&amp;dr=https%3A%2F%2Fdocs.oracle.com%2Fcd%2FE11882_01%2Fnav%2Fportal_11.htm&amp;du=https%3A%2F%2Fdocs.oracle.com%2Fcd%2FE11882_01%2Finstall.112%2Fe24326%2Ftoc.htm&amp;href=https%3A%2F%2Fdocs.oracle.com%2Fcd%2FE11882_01%2Finstall.112%2Fe24326%2Ftoc.htm&amp;dt=Oracle%C2%AE%20Database%20Quick%20Installation%20Guide&amp;dbg=0&amp;cap=tc%3D0%26ab%3D0&amp;inst=1&amp;jsl=1&amp;prod=undefined&amp;lng=en&amp;ogt=&amp;pc=men&amp;pub=ra-552992c80ef99c8d&amp;ssl=1&amp;sid=5c257d7e000de060&amp;srf=0.01&amp;ver=300&amp;xck=0&amp;xtr=0&amp;og=&amp;csi=undefined&amp;rev=v8.3.35-wp&amp;ct=1&amp;xld=1&amp;xd=1"></iframe>