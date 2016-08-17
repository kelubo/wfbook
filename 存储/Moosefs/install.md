# MooseFS
## 架构
![](../../Image/a/y.png)
![](../../Image/a/z.png)

## 准备工作
### 1. IP
    Master servers : 192.168.1.1
	                 192.168.1.2
    Chunk servers :  192.168.1.101
	                 192.168.1.102
					 192.168.1.103

### 2. DNS
    mfsmaster		IN	A	192.168.1.1		;address of first master server
    mfsmaster		IN	A	192.168.1.2		;address of second master server

### 3. OS
    Ubuntu 10/12/14  
    Debian 5/6/7/8  
    RHEL/CentOS versions 6/7  
    OpenSUSE 12  
    FreeBSD 9.3/10  
    MacOS X 10.9/10.10/10.11  
    Raspberry Pi 3  
    OpenIndiana Hipster
## 安装
### Ubuntu / Debian
Add the key:
    # wget -O - http://ppa.moosefs.com/moosefs.key | apt-key add -

Ubuntu 14.04 LTS Trusty:

    echo "deb http://ppa.moosefs.com/moosefs-3/apt/ubuntu/trusty trusty main" > /etc/apt/sources.list.d/moosefs.list

Debian 8.0 Jessie:

    echo "deb http://ppa.moosefs.com/moosefs-3/apt/debian/jessie jessie main" > /etc/apt/sources.list.d/moosefs.list

升级系统
    # apt-get update

Master Servers:
    # apt-get install moosefs-master
    # apt-get install moosefs-cli
Chunkservers:
    # apt-get install moosefs-chunkserver
Metaloggers:
    # apt-get install moosefs-metalogger
Clients:
    # apt-get install moosefs-client
    # vim /etc/fstab
    mfsmount /mnt/mfs fuse defaults 0 0

### CentOS / Fedora / RHEL
Add the appropriate key to package manager:
    # curl "http://ppa.moosefs.com/RPM-GPG-KEY-MooseFS" > /etc/pki/rpm-gpg/RPM-GPG-KEY-MooseFS

add the repository entry (MooseFS 3.0):

    For EL7 family:
    # curl "http://ppa.moosefs.com/MooseFS-3-el7.repo" > /etc/yum.repos.d/MooseFS.repo
    For EL6 family:
    # curl "http://ppa.moosefs.com/MooseFS-3-el6.repo" > /etc/yum.repos.d/MooseFS.repo

For MoosefS 2.0, use:

    For EL7 family:
    # curl "http://ppa.moosefs.com/MooseFS-2-el7.repo" > /etc/yum.repos.d/MooseFS.repo
    For EL6 family:
    # curl "http://ppa.moosefs.com/MooseFS-2-el6.repo" > /etc/yum.repos.d/MooseFS.repo

Master Server:
    # yum install moosefs-master moosefs-cli moosefs-cgi moosefs-cgiserv
Chunkservers:
    # yum install moosefs-chunkserver
Metaloggers:
    # yum install moosefs-metalogger
Clients:
    # yum install moosefs-client
    # vim /etc/fstab
    mfsmount /mnt/mfs fuse defaults 0 0

启动服务

    manually:
    # mfsmaster start
    # mfschunkserver start

    EL7:
    # systemctl start moosefs-master.service
    # systemctl start moosefs-chunkserver.service
    # systemctl start moosefs-metalogger.service

    EL6:
    # service moosefs-master start
    # service moosefs-chunkserver start
    # service moosefs-metalogger start

### FreeBSD
FreeBSD 9.3 and 10.
create a file moosefs.conf in directory /etc/pkg with following contents:

    For 64-bit FreeBSD 10:
    moosefs: { url: "http://ppa.moosefs.com/moosefs-3/freebsd/10:x86:64", enabled: yes, mirror_type: NONE }
    For 32-bit FreeBSD 10:
    moosefs: { url: "http://ppa.moosefs.com/moosefs-3/freebsd/10:x86:32", enabled: yes, mirror_type: NONE }
    For 64-bit FreeBSD 9:
    moosefs: { url: "http://ppa.moosefs.com/moosefs-3/freebsd/9:x86:64", enabled: yes, mirror_type: NONE }
    For 32-bit FreeBSD 9:
    moosefs: { url: "http://ppa.moosefs.com/moosefs-3/freebsd/9:x86:32", enabled: yes, mirror_type: NONE }

升级：

    # pkg update

Master Server:

    # pkg install moosefs-master
    # pkg install moosefs-cli

Chunkservers:

    # pkg install moosefs-chunkserver

Metaloggers:

    # pkg install moosefs-metalogger

Clients:

    # pkg install moosefs-client
    # vim /etc/fstab
    mfsmount_magic /mnt/mfs moosefs rw,mfsmaster=mfsmaster,mountprog=/usr/local/bin/mfsmount,late 0 0

### Install: Raspberry Pi 3 / Raspbian Jessie

Add the key:

    # wget -O - http://ppa.moosefs.com/apt/moosefs.key | apt-key add -

MooseFS Raspberry Pi 3 repository:

    echo 'deb http://ppa.moosefs.com/rpi2 jessie main' > /etc/apt/sources.list.d/moosefs-rpi2.list

After that do:

    # apt update

Master Servers:

    # apt install moosefs-master
    # apt install moosefs-cli

Chunkservers:

    # apt install moosefs-chunkserver

Metaloggers:

    # apt install moosefs-metalogger

Clients:

    # apt install moosefs-client
    # vim /etc/fstab
    mfsmaster.example.lan: /mnt/mfs moosefs defaults,mfsdelayedinit 0 0





Best practices

(last update: January 13, 2016)

Lots of people are asking us about technical aspects of setting up MooseFS instances.
In order to answer these questions, we are publishing here a list of best practices and hardware recommendations. Follow these to achieve best reliability of your MooseFS installation.

    Minimum goal set to 2
    Enough space for metadata dumps
    RAID 1 or RAID 1+0 for storing metadata
    Virtual Machines and MooseFS
    JBOD and XFS for Chunkservers
    Network
    overcommit_memory on Master Servers (Linux only)
    Disabled updateDB feature (Linux only)
    Up-to-date operating system
    Hardware recommendation

    Minimum goal set to 2

    In order to keep your data safe, we recommend to set the minimum goal to 2 for the whole MooseFS instance.

    The goal is a number of copies of files' chunks distributed among Chunkservers. It is one of the most crucial aspects of keeping data safe.

    If you have set the goal to 2, in case of a drive or a Chunkserver failure, the missing chunk copy is replicated from another copy to another chunkserver to fulfill the goal, and your data is safe.

    If you have the goal set to 1, in case of such failure, the chunks that existed on a broken disk, are missing, and consequently, files that these chunks belonged to, are also missing. Having goal set to 1 will eventually lead to data loss.

    To set the goal to 2 for the whole instance, run the following command on the server that MooseFS is mounted on (e.g. in /mnt/mfs):
    # mfssetgoal -r 2 /mnt/mfs

    You should also prevent the users from setting goal lower than 2. To do so, edit your /etc/mfs/mfsexports.cfg file on every Master Server and set mingoal appropriately in each export:
    *    /    rw,alldirs,mingoal=2,maproot=0:0

    After modifying /etc/mfs/mfsexports.cfg you need to reload your Master Server(s):
    # mfsmaster reload
    or
    # service moosefs-master reload
    # service moosefs-pro-master reload
    or
    # kill -HUP `pidof mfsmaster`

    For big instances (like 1 PiB or above) we recommend to use minimum goal set to 3, because probability of disk failure in such a big instance is higher.
    Enough space for metadata dumps

    We had a number of support cases raised connected to the metadata loss. Most of them were caused by a lack of free space for /var/lib/mfs directory on Master Servers.

    The free space needed for metadata in /var/lib/mfs can be calculated by the following formula:
        RAM is amount of RAM
        BACK_LOGS is a number of metadata change log files (default is 50 - from /etc/mfs/mfsmaster.cfg)
        BACK_META_KEEP_PREVIOUS is a number of previous metadata files to be kept (default is 1 - also from /etc/mfs/mfsmaster.cfg)

    SPACE = RAM * (BACK_META_KEEP_PREVIOUS + 2) + 1 * (BACK_LOGS + 1) [GiB]

    (If default values from /etc/mfs/mfsmaster.cfg are used, it is RAM * 3 + 51 [GiB])

    The value 1 (before multiplying by BACK_LOGS + 1) is an estimation of size used by one changelog.[number].mfs file. In highly loaded instance it uses a bit less than 1 GB.

    Example:
    If you have 128 GiB of RAM on your Master Server, using the given formula, you should reserve for /var/lib/mfs on Master Server(s):

    128*3 + 51 = 384 + 51 = 435 GiB   minimum.
    RAID 1 or RAID 1+0 for storing metadata

    We recommend to set up a dedicated RAID 1 or RAID 1+0 array for storing metadata dumps and changelogs. Such array should be mounted on /var/lib/mfs directory and should not be smaller than the value calculated in the previous point.

    We do not recommend to store metadata over the network (e.g. SANs, NFSes, etc.).
    Virtual Machines and MooseFS

    For high-performance computing systems, we do not recommend running MooseFS components (especially Master Server(s)) on Virtual Machines.
    JBOD and XFS for Chunkservers

    We recommend to connect to Chunkserver(s) JBODs. Just format the drive as XFS and mount on e.g. /mnt/chunk01, /mnt/chunk02, ... and put these paths into /etc/mfs/mfschunkserver.cfg. That's all.

    We recommend such configuration mainly because of two reasons:

        MooseFS has a mechanism of checking if the hard disk is in a good condition or not. MooseFS can discover broken disks, replicate the data and mark such disks as damaged. The situation is different with RAID: MooseFS algorithms do not work with RAIDs, therefore corrupted RAID arrays may be falsely reported as healthy/ok.

        The other aspect is time of replication. Let's assume you have goal set to 2 for the whole MooseFS instance. If one 2 TiB drive breaks, the replication (from another copy) will last about 40-60 minutes. If one big RAID (e.g. 36 TiB) becomes corrupted, replication can last even for 12-18 hours. Until the replication process is finished, some of your data is in danger, because you have only one valid copy. If another disk or RAID fails during that time, some of your data may be irrevocably lost. So the longer replication period puts your data in greater danger.
    Network

    We recommend to have at least 1 Gbps network. Of course, MooseFS will perform better in 10 Gbps network (in our tests we saturated the 10 Gbps network).

    We recommend to set LACP between two switches and connect each machine to both of them to enable redundancy of your network connection.
    overcommit_memory on Master Servers (Linux only)

    If you have an entry similar to the following one in /var/log/syslog or /var/log/messages:
    fork error (store data in foreground - it will block master for a while)
    you may encounter (or are encountering) problems with your master server, such as timeouts and dropped connections from clients. This happens, because your system does not allow MFS Master process to fork and store its metadata information in background.

    Linux systems use several different algorithms of estimating how much memory a single process needs when it is created. One of these algorithms assumes that if we fork a process, it will need exactly the same amount of memory as its parent. With a process taking 24 GB of memory and total amount of 40 GB (32 GB physical plus 8 GB virtual) and this algorithm, the forking would always be unsuccessful.

    But in reality, the fork commant does not copy the entire memory, only the modified fragments are copied as needed. Since the child process in MFS master only reads this memory and dumps it into a file, it is safe to assume not much of the memory content will change.

    Therefore such "careful" estimating algorithm is not needed. The solution is to switch the estimating algorithm the system uses. It can be done one-time by a root command:
    # echo 1 > /proc/sys/vm/overcommit_memory

    To switch it permanently, so it stays this way even after the system is restarted, you need to put the following line into your /etc/sysctl.conf file:
    vm.overcommit_memory=1

    Disabled updateDB feature (Linux only)

    Updatedb is part of mlocate which is simply an indexing system, that keeps a database listing all the files on your server. This database is used by the locate command to do searches.

    Updatedb is not recommended for network distributed filesystems.

    To disable Updatedb feature for MooseFS, add fuse.mfs to variable PRUNEFS in /etc/updatedb.conf (it should look similar to this):
    PRUNEFS="NFS nfs nfs4 rpc_pipefs afs binfmt_misc proc smbfs autofs iso9660 ncpfs coda devpts ftpfs devfs mfs shfs sysfs cifs lustre tmpfs usbfs udf fuse.glusterfs fuse.sshfs fuse.mfs curlftpfs ecryptfs fusesmb devtmpfs"

    Up-to-date operating system

    We recommend to use up-to-date operating system. It doesn't matter if your OS is Linux, FreeBSD or MacOS X. It needs to be up-to-date. For example, some features added in MooseFS 3.0 will not work with old FUSE version (which is e.g. present on Debian 5).
    Hardware recommendation

    Since MooseFS Master Server is a single-threaded process, we recommend to use modern processors with high clock and low number of cores for Master Servers, e.g.:
        Intel(R) Xeon(R) CPU E5-1630 v3 @ 3.70GHz
        Intel(R) Xeon(R) CPU E5-1620 v2 @ 3.70GHz

    We also recommend to disable hyper-threading CPU feature for Master Servers.

    Minimum recommended and supported HA configuration for MooseFS Pro is 2 Master Servers and 3 Chunkservers. If you have 3 Chunkservers, and one of them goes down, your data is still accessible and is being replicated and system still works. If you have only 2 Chunkservers and one of them goes down, MooseFS waits for it and is not able to perform any operations.

    Minumum number of Chunkservers required to run MooseFS Pro properly is 3.

Core Technology 57 West 57th Street,
New York City,
New York, 100197 Tel: +1 646-416-7918
Fax: +1 646-416-8001
contact@moosefs.com
Contact form:
Name:*
Email:*
Phone:*
Captcha:*
19+19=
* - information required
Comment:




Frequently Asked Questions

(last update: May 24, 2016)
Table of Contents:

    What average write/read speeds can we expect?
    Does the goal setting influence writing/reading speeds?
    Are concurrent read and write operations supported?
    How much CPU/RAM resources are used?
    Is it possible to add/remove chunkservers and disks on the fly?
    How to mark a disk for removal?
    My experience with clustered filesystems is that metadata operations are quite slow. How did you resolve this problem?
    What does value of directory size mean on MooseFS? It is different than standard Linux ls -l output. Why?
    When I perform df -h on a filesystem the results are different from what I would expect taking into account actual sizes of written files.
    Can I keep source code on MooseFS? Why do small files occupy more space than I would have expected?
    Do Chunkservers and Metadata Server do their own checksumming?
    What resources are required for the Master Server?
    When I delete files or directories, the MooseFS size doesn't change. Why?
    When I added a third server as an extra chunkserver, it looked like the system started replicating data to the 3rd server even though the file goal was still set to 2.
    Is MooseFS 64bit compatible?
    Can I modify the chunk size?
    How do I know if a file has been successfully written to MooseFS
    What are limits in MooseFS (e.g. file size limit, filesystem size limit, max number of files, that can be stored on the filesystem)?
    Can I set up HTTP basic authentication for the mfscgiserv?
    Can I run a mail server application on MooseFS? Mail server is a very busy application with a large number of small files - will I not lose any files?
    Are there any suggestions for the network, MTU or bandwidth?
    Does MooseFS support supplementary groups?
    Does MooseFS support file locking?
    Is it possible to assign IP addresses to chunk servers via DHCP?
    Some of my chunkservers utilize 90% of space while others only 10%. Why does the rebalancing process take so long?
    I have Metalogger running - should I make additional backup of the metadata file on the master server?
    I think one of my disks is slower / damaged. How should I find it?
    How can I find the master server PID?
    Web interface shows there are some copies of chunks with goal 0. What does it mean?
    Is every error message reported by mfsmount a serious problem?
    How do I verify that the MooseFS cluster is online? What happens with mfsmount when the master server goes down?

1. What average write/read speeds can we expect?

Aside from common (for most filesystems) factors like: block size and type of access (sequential or random), in MooseFS the speeds depend also on hardware performance. Main factors are hard drives performance and network capacity and topology (network latency). The better the performance of the hard drives used and the better throughput of the network, the higher performance of the whole system.
2. Does the goal setting influence writing/reading speeds?

Generally speaking, it does not. In case of reading a file, goal higher than one may in some cases help speed up the reading operation, i. e. when two clients access a file with goal two or higher, they may perform the read operation on different copies, thus having all the available throughtput for themselves. But in average the goal setting does not alter the speed of the reading operation in any way.

Similarly, the writing speed is negligibly influenced by the goal setting. Writing with goal higher than two is done chain-like: the client send the data to one chunk server and the chunk server simultaneously reads, writes and sends the data to another chunk server (which may in turn send them to the next one, to fulfill the goal). This way the client's throughtput is not overburdened by sending more than one copy and all copies are written almost simultaneously. Our tests show that writing operation can use all available bandwidth on client's side in 1Gbps network.
3. Are concurrent read and write operations supported?

All read operations are parallel - there is no problem with concurrent reading of the same data by several clients at the same moment. Write operations are parallel, execpt operations on the same chunk (fragment of file), which are synchronized by Master server and therefore need to be sequential.
4. How much CPU/RAM resources are used?

In our environment (ca. 1 PiB total space, 36 million files, 6 million folders distributed on 38 million chunks on 100 machines) the usage of chunkserver CPU (by constant file transfer) is about 15-30% and chunkserver RAM usually consumes in between 100MiB and 1GiB (dependent on amount of chunks on each chunk server). The master server consumes about 50% of modern 3.3 GHz CPU (ca. 5000 file system operations per second, of which ca. 1500 are modifications) and 12GiB RAM. CPU load depends on amount of operations and RAM on the total number of files and folders, not the total size of the files themselves. The RAM usage is proportional to the number of entries in the file system because the master server process keeps the entire metadata in memory for performance. HHD usage on our master server is ca. 22 GB.
5. Is it possible to add/remove chunkservers and disks on the fly?

You can add/remove chunk servers on the fly. But keep in mind that it is not wise to disconnect a chunk server if this server contains the only copy of a chunk in the file system (the CGI monitor will mark these in orange). You can also disconnect (change) an individual hard drive. The scenario for this operation would be:

    Mark the disk(s) for removal (see How to mark a disk for removal?)
    Reload the chunkserver process
    Wait for the replication (there should be no "undergoal" or "missing" chunks marked in yellow, orange or red in CGI monitor)
    Stop the chunkserver process
    Delete entry(ies) of the disconnected disk(s) in mfshdd.cfg
    Stop the chunkserver machine
    Remove hard drive(s)
    Start the machine
    Start the chunkserver process


If you have hotswap disk(s) you should follow these:

    Mark the disk(s) for removal (see How to mark a disk for removal?)
    Reload the chunkserver process
    Wait for the replication (there should be no "undergoal" or "missing" chunks marked in yellow, orange or red in CGI monitor)
    Delete entry(ies) of the disconnected disk(s) in mfshdd.cfg
    Reload the chunkserver process
    Unmount disk(s)
    Remove hard drive(s)

If you follow the above steps, work of client computers won't be interrupted and the whole operation won't be noticed by MooseFS users.
6. How to mark a disk for removal?

When you want to mark a disk for removal from a chunkserver, you need to edit the chunkserver's mfshdd.cfg configuration file and put an asterisk '*' at the start of the line with the disk that is to be removed. For example, in this mfshdd.cfg we have marked "/mnt/hdd" for removal:
/mnt/hda
/mnt/hdb
/mnt/hdc
*/mnt/hdd
/mnt/hde

After changing the mfshdd.cfg you need to reload chunkserver (on Linux Debian/Ubuntu: service moosefs-pro-chunkserver reload).

Once the disk has been marked for removal and the chunkserver process has been restarted, the system will make an appropriate number of copies of the chunks stored on this disk, to maintain the required "goal" number of copies.

Finally, before the disk can be disconnected, you need to confirm there are no "undergoal" chunks on the other disks. This can be done using the CGI Monitor. In the "Info" tab select "Regular chunks state matrix" mode.
7. My experience with clustered filesystems is that metadata operations are quite slow. How did you resolve this problem?

During our research and development we also observed the problem of slow metadata operations. We decided to aleviate some of the speed issues by keeping the file system structure in RAM on the metadata server. This is why metadata server has increased memory requirements. The metadata is frequently flushed out to files on the master server.

Additionally, in CE version the metadata logger server(s) also frequently receive updates to the metadata structure and write these to their file systems.

In Pro version metaloggers are optional, because master followers are keeping synchronised with leader master. They're also saving metadata to the hard disk.
8. What does value of directory size mean on MooseFS? It is different than standard Linux ls -l output. Why?

Folder size has no special meaning in any filesystem, so our development team decided to give there extra information. The number represents total length of all files inside (like in mfsdirinfo -h -l) displayed in exponential notation.

You can "translate" the directory size by the following way:

There are 7 digits: xAAAABB. To translate this notation to number of bytes, use the following expression:

AAAA.BB xBytes

Where x:

    0 =
    1 = kibi
    2 = Mebi
    3 = Gibi
    4 = Tebi

Example:
To translate the following entry:

drwxr-xr-x 164 root root 2010616 May 24 11:47 test
                         xAAAABB

Folder size 2010616 should be read as 106.16 MiB.

When x = 0, the number might be smaller:

Example:
Folder size 10200 means 102 Bytes.
9. When I perform df -h on a filesystem the results are different from what I would expect taking into account actual sizes of written files.

Every chunkserver sends its own disk usage increased by 256MB for each used partition/hdd, and the master sends a sum of these values to the client as total disk usage. If you have 3 chunkservers with 7 hdd each, your disk usage will be increased by 3*7*256MB (about 5GB).

The other reason for differences is, when you use disks exclusively for MooseFS on chunkservers df will show correct disk usage, but if you have other data on your MooseFS disks df will count your own files too.

If you want to see the actual space usage of your MooseFS files, use mfsdirinfo command.
10. Can I keep source code on MooseFS? Why do small files occupy more space than I would have expected?

The system was initially designed for keeping large amounts (like several thousands) of very big files (tens of gigabytes) and has a hard-coded chunk size of 64MiB and block size of 64KiB. Using a consistent block size helps improve the networking performance and efficiency, as all nodes in the system are able to work with a single 'bucket' size. That's why even a small file will occupy 64KiB plus additionally 4KiB of checksums and 1KiB for the header.

The issue regarding the occupied space of a small file stored inside a MooseFS chunk is really more significant, but in our opinion it is still negligible. Let's take 25 million files with a goal set to 2. Counting the storage overhead, this could create about 50 million 69 KiB chunks, that may not be completely utilized due to internal fragmentation (wherever the file size was less than the chunk size). So the overall wasted space for the 50 million chunks would be approximately 3.2TiB. By modern standards, this should not be a significant concern. A more typical, medium to large project with 100,000 small files would consume at most 13GiB of extra space due to block size of used file system.

So it is quite reasonable to store source code files on a MooseFS system, either for active use during development or for long term reliable storage or archival purposes.

Perhaps the larger factor to consider is the comfort of developing the code taking into account the performance of a network file system. When using MooseFS (or any other network based file system such as NFS, CIFS) for a project under active development, the network filesystem may not be able to perform file IO operations at the same speed as a directly attached regular hard drive would.

Some modern integrated development environments (IDE), such as Eclipse, make frequent IO requests on several small workspace metadata files. Running Eclipse with the workspace folder on a MooseFS file system (and again, with any other networked file system) will yield slightly slower user interface performance, than running Eclipse with the workspace on a local hard drive.

You may need to evaluate for yourself if using MooseFS for your working copy of active development within an IDE is right for you.

In a different example, using a typical text editor for source code editing and a version control system, such as Subversion, to check out project files into a MooseFS file system, does not typically resulting any performance degradation. The IO overhead of the network file system nature of MooseFS is offset by the larger IO latency of interacting with the remote Subversion repository. And the individual file operations (open, save) do not have any observable latencies when using simple text editors (outside of complicated IDE products).

A more likely situation would be to have the Subversion repository files hosted within a MooseFS file system, where the svnserver or Apache + mod_svn would service requests to the Subversion repository and users would check out working sandboxes onto their local hard drives.
11. Do Chunkservers and Metadata Server do their own checksumming?

Chunk servers do their own checksumming. Overhead is about 4B per a 64KiB block which is 4KiB per a 64MiB chunk.

Metadata servers don't. We thought it would be CPU consuming. We recommend using ECC RAM modules.
12. What resources are required for the Master Server?

The most important factor is RAM of MooseFS Master machine, as the full file system structure is cached in RAM for speed. Besides RAM, MooseFS Master machine needs some space on HDD for main metadata file together with incremental logs.

The size of the metadata file is dependent on the number of files (not on their sizes). The size of incremental logs depends on the number of operations per hour, but length (in hours) of this incremental log is configurable.
13. When I delete files or directories, the MooseFS size doesn't change. Why?

MooseFS does not immediately erase files on deletion, to allow you to revert the delete operation. Deleted files are kept in the trash bin for the configured amount of time before they are deleted.

You can configure for how long files are kept in trash and empty the trash manually (to release the space). There are more details in Reference Guide in section "Operations specific for MooseFS".

In short - the time of storing a deleted file can be verified by the mfsgettrashtime command and changed with mfssettrashtime.
14. When I added a third server as an extra chunkserver, it looked like the system started replicating data to the 3rd server even though the file goal was still set to 2.

Yes. Disk usage balancer uses chunks independently, so one file could be redistributed across all of your chunkservers.
15. Is MooseFS 64bit compatible?

Yes!
16. Can I modify the chunk size?

No. File data is divided into fragments (chunks) with a maximum of 64MiB each. The value of 64 MiB is hard coded into system so you cannot modify its size. We based the chunk size on real-world data and determined it was a very good compromise between number of chunks and speed of rebalancing / updating the filesystem. Of course if a file is smaller than 64 MiB it occupies less space.

In the systems we take care of, several file sizes significantly exceed 100GB with no noticable chunk size penalty.
17. How do I know if a file has been successfully written to MooseFS

Let's briefly discuss the process of writing to the file system and what programming consequences this bears.

In all contemporary filesystems, files are written through a buffer (write cache). As a result, execution of the write command itself only transfers the data to a buffer (cache), with no actual writing taking place. Hence, a confirmed execution of the write command does not mean that the data has been correctly written on a disk. It is only with the invocation and completion of the fsync (or close) command that causes all data kept within the buffers (cache) to get physically written out. If an error occurs while such buffer-kept data is being written, it could cause the fsync (or close) command to return an error response.

The problem is that a vast majority of programmers do not test the close command status (which is generally a very common mistake). Consequently, a program writing data to a disk may "assume" that the data has been written correctly from a success response from the write command, while in actuality, it could have failed during the subsequent close command.

In network filesystems (like MooseFS), due to their nature, the amount of data "left over" in the buffers (cache) on average will be higher than in regular file systems. Therefore the amount of data processed during execution of the close or fsync command is often significant and if an error occurs while the data is being written [from the close or fsync command], this will be returned as an error during the execution of this command. Hence, before executing close, it is recommended (especially when using MooseFS) to perform an fsync operation after writing to a file and then checking the status of the result of the fsync operation. Then, for good measure, also check the return status of close as well.

NOTE! When stdio is used, the fflush function only executes the "write" command, so correct execution of fflush is not sufficient to be sure that all data has been written successfully - you should also check the status of fclose.

The above problem may occur when redirecting a standard output of a program to a file in shell. Bash (and many other programs) do not check the status of the close execution. So the syntax of "application > outcome.txt" type may wrap up successfully in shell, while in fact there has been an error in writing out the "outcome.txt" file. You are strongly advised to avoid using the above shell output redirection syntax when writing to a MooseFS mount point. If necessary, you can create a simple program that reads the standard input and writes everything to a chosen file, where this simple program would correctly employ the appropriate check of the result status from the fsync command. For example, "application | mysaver outcome.txt", where mysaver is the name of your writing program instead of application > outcome.txt.

Please note that the problem discussed above is in no way exceptional and does not stem directly from the characteristics of MooseFS itself. It may affect any system of files - network type systems are simply more prone to such difficulties. Technically speaking, the above recommendations should be followed at all times (also in cases where classic file systems are used).
18. What are limits in MooseFS (e.g. file size limit, filesystem size limit, max number of files, that can be stored on the filesystem)?

    The maximum file size limit in MooseFS is 257 bytes = 128 PiB.
    The maximum filesystem size limit is 264 bytes = 16 EiB = 16 384 PiB
    The maximum number of files, that can be stored on one MooseFS instance is 231 - over 2.1 bln.

19. Can I set up HTTP basic authentication for the mfscgiserv?

mfscgiserv is a very simple HTTP server written just to run the MooseFS CGI scripts. It does not support any additional features like HTTP authentication. However, the MooseFS CGI scripts may be served from another full-featured HTTP server with CGI support, such as lighttpd or Apache. When using a full-featured HTTP server such as Apache, you may also take advantage of features offered by other modules, such as HTTPS transport. Just place the CGI and its data files (index.html, mfs.cgi, chart.cgi, mfs.css, acidtab.js, logomini.png, err.gif) under chosen DocumentRoot. If you already have an HTTP server instance on a given host, you may optionally create a virtual host to allow access to the MooseFS CGI monitor through a different hostname or port.
20. Can I run a mail server application on MooseFS? Mail server is a very busy application with a large number of small files - will I not lose any files?

You can run a mail server on MooseFS. You won't lose any files under a large system load. When the file system is busy, it will block until its operations are complete, which will just cause the mail server to slow down.
21. Are there any suggestions for the network, MTU or bandwidth?

We recommend using jumbo-frames (MTU=9000). With a greater amount of chunkservers, switches should be connected through optical fiber or use aggregated links.
22. Does MooseFS support supplementary groups?

Yes.
23. Does MooseFS support file locking?

Yes, since MooseFS 3.0.
24. Is it possible to assign IP addresses to chunk servers via DHCP?

Yes, but we highly recommend setting "DHCP reservations" based on MAC addresses.
25. Some of my chunkservers utilize 90% of space while others only 10%. Why does the rebalancing process take so long?

Our experiences from working in a production environment have shown that aggressive replication is not desirable, as it can substantially slow down the whole system. The overall performance of the system is more important than equal utilization of hard drives over all of the chunk servers. By default replication is configured to be a non-aggressive operation. At our environment normally it takes about 1 week for a new chunkserver to get to a standard hdd utilization. Aggressive replication would make the whole system considerably slow for several days.

Replication speeds can be adjusted on master server startup by setting these two options:

    CHUNKS_WRITE_REP_LIMIT
    Maximum number of chunks to replicate to one chunkserver (default is 2,1,1,4).
    One number is equal to four same numbers separated by colons.
        First limit is for endangered chunks (chunks with only one copy)
        Second limit is for undergoal chunks (chunks with number of copies lower than specified goal)
        Third limit is for rebalance between servers with space usage around arithmetic mean
        Fourth limit is for rebalance between other servers (very low or very high space usage)
    Usually first number should be grater than or equal to second, second greater than or equal to third, and fourth greater than or equal to third (1st >= 2nd >= 3rd <= 4th).
    CHUNKS_READ_REP_LIMIT
    Maximum number of chunks to replicate from one chunkserver (default is 10,5,2,5).
    One number is equal to four same numbers separated by colons. Limit groups are the same as in write limit, also relations between numbers should be the same as in write limits (1st >= 2nd >= 3rd <= 4th).

Tuning these in your environment will requires some experiments.

26. I have a Metalogger running - should I make additional backup of the metadata file on the Master Server?

Yes, it is highly recommended to make additional backup of the metadata file. This provides a worst case recovery option if, for some reason, the metalogger data is not useable for restoring the master server (for example the metalogger server is also destroyed).

The master server flushes metadata kept in RAM to the metadata.mfs.back binary file every hour on the hour (xx:00). So a good time to copy the metadata file is every hour on the half hour (30 minutes after the dump). This would limit the amount of data loss to about 1.5h of data. Backing up the file can be done using any conventional method of copying the metadata file - cp, scp, rsync, etc.

After restoring the system based on this backed up metadata file the most recently created files will have been lost. Additionally files, that were appended to, would have their previous size, which they had at the time of the metadata backup. Files that were deleted would exist again. And files that were renamed or moved would be back to their previous names (and locations). But still you would have all of data for the files created in the X past years before the crash occurred.

In MooseFS Pro version, master followers flush metadata from RAM to the hard disk once an hour. The leader master downloads saved metadata from followers once a day.
27. I think one of my disks is slower / damaged. How should I find it?

In the CGI monitor go to the "Disks" tab and choose "switch to hour" in "I/O stats" column and sort the results by "write" in "max time" column. Now look for disks which have a significantly larger write time. You can also sort by the "fsync" column and look at the results. It is a good idea to find individual disks that are operating slower, as they may be a bottleneck to the system.

It might be helpful to create a test operation, that continuously copies some data to create enough load on the system for there to be observable statisics in the CGI monitor. On the "Disks" tab specify units of "minutes" instead of hours for the "I/O stats" column.

Once a "bad" disk has been discovered to replace it follow the usual operation of marking the disk for removal, and waiting until the color changes to indicate that all of the chunks stored on this disk have been replicated to achieve the sufficient goal settings.
28. How can I find the master server PID?

Issue the following command:
# mfsmaster test
29. Web interface shows there are some copies of chunks with goal 0. What does it mean?

This is a way to mark chunks belonging to the non-existing (i.e. deleted) files. Deleting a file is done asynchronously in MooseFS. First, a file is removed from metadata and its chunks are marked as unnecessary (goal=0). Later, the chunks are removed during an "idle" time. This is much more efficient than erasing everything at the exact moment the file was deleted.

Unnecessary chunks may also appear after a recovery of the master server, if they were created shortly before the failure and were not available in the restored metadata file.
30. Is every error message reported by mfsmount a serious problem?

No. mfsmount writes every failure encountered during communication with chunkservers to the syslog. Transient communication problems with the network might cause IO errors to be displayed, but this does not mean data loss or that mfsmount will return an error code to the application. Each operation is retried by the client (mfsmount) several times and only after the number of failures (reported as try counter) reaches a certain limit (typically 30), the error is returned to the application that data was not read/saved.

Of course, it is important to monitor these messages. When messages appear more often from one chunkserver than from the others, it may mean there are issues with this chunkserver - maybe hard drive is broken, maybe network card has some problems - check its charts, hard disk operation times, etc. in the CGI monitor.

Note: XXXXXXXX in examples below means IP address of chunkserver. In mfsmount version < 2.0.42 chunkserver IP is written in hexadecimal format. In mfsmount version >= 2.0.42 IP is "human-readable".


What does
file: NNN, index: NNN, chunk: NNN, version: NNN - writeworker: connection with (XXXXXXXX:PPPP) was timed out (unfinished writes: Y; try counter: Z)
message mean?


This means that Zth try to write the chunk was not successful and writing of Y blocks, sent to the chunkserver, was not confirmed. After reconnecting these blocks would be sent again for saving. The limit of trials is set by default to 30.

This message is for informational purposes and doesn't mean data loss.


What does
file: NNN, index: NNN, chunk: NNN, version: NNN, cs: XXXXXXXX:PPPP - readblock error (try counter: Z)
message mean?


This means that Zth try to read the chunk was not successful and system will try to read the block again. If value of Z equals 1 it is a transitory problem and you should not worry about it. The limit of trials is set by default to 30.
31. How do I verify that the MooseFS cluster is online? What happens with mfsmount when the master server goes down?

When the master server goes down while mfsmount is already running, mfsmount doesn't disconnect the mounted resource, and files awaiting to be saved would stay quite long in the queue while trying to reconnect to the master server. After a specified number of tries they eventually return EIO - "input/output error". On the other hand it is not possible to start mfsmount when the master server is offline.

There are several ways to make sure that the master server is online, we present a few of these below.

Check if you can connect to the TCP port of the master server (e.g. socket connection test).

In order to assure that a MooseFS resource is mounted it is enough to check the inode number - MooseFS root will always have inode equal to 1. For example if we have MooseFS installation in /mnt/mfs then stat /mnt/mfs command (in Linux) will show:

$ stat /mnt/mfs
File: `/mnt/mfs'
Size: xxxxxx Blocks: xxx IO Block: 4096 directory
Device: 13h/19d Inode: 1 Links: xx
(...)

Additionaly mfsmount creates a virtual hidden file .stats in the root mounted folder. For example, to get the statistics of mfsmount when MooseFS is mounted we can cat this .stats file, eg.:


$ cat /mnt/mfs/.stats
fuse_ops.statfs: 241
fuse_ops.access: 0
fuse_ops.lookup-cached: 707553
fuse_ops.lookup: 603335
fuse_ops.getattr-cached: 24927
fuse_ops.getattr: 687750
fuse_ops.setattr: 24018
fuse_ops.mknod: 0
fuse_ops.unlink: 23083
fuse_ops.mkdir: 4
fuse_ops.rmdir: 1
fuse_ops.symlink: 3
fuse_ops.readlink: 454
fuse_ops.rename: 269
(...)

If you want to be sure that master server properly responds you need to try to read the goal of any object, e.g. of the root folder:

$ mfsgetgoal /mnt/mfs
/mnt/mfs: 2

If you get a proper goal of the root folder, you can be sure that the master server is up and running.
Core Technology 57 West 57th Street,
New York City,
New York, 100197 Tel: +1 646-416-7918
Fax: +1 646-416-8001
contact@moosefs.com
Contact form:
Name:*
Email:*
Phone:*
Captcha:*
3+10=
* - information required
Comment:

http://192.168.1.1:9425





4.1 管理命令

设置副本 的份数，推荐3份
/usr/local/mfs/bin/mfssetgoal -r 3 /mnt/mfs

查看某文件
/usr/local/mfs/bin/mfsgetgoal  /mnt/mfs

查看目录信息
/usr/local/mfs/bin/mfsdirinfo -H /mnt/mfs



5. 性能测试

5.1 mfs

1. 大文件(block=1M  byte)
dd if=/dev/zero of=1.img bs=1M count=5000
5242880000 bytes (5.2 GB) copied, 48.8481 seconds, 107 MB/s

2. 小文件( 50 byte * 100w个 * 1 client )    ( 1000 * 1000  )  写入
real    83m41.343s
user    4m17.993s
sys    16m58.939s
列表
time find ./ -type f | nl | tail
999999  ./0/1
1000000 ./0/0
real    0m39.418s
user    0m0.721s
sys    0m0.225s
删除
time rm -fr *
real    6m35.273s
user    0m0.394s
sys    0m23.546s

3. 小文件( 1K byte * 100w个 * 100 client )    { 1000 * 1000 )  
写入（100client）
time ../../p_touch_file.sh
real    22m51.159s
user    4m42.850s
sys    18m41.437s
列表（1client）
time find ./ | nl | tail
real    0m35.910s
user    0m0.628s
sys    0m0.204s
删除（1client）
time rm -fr *
real    6m36.530s
user    0m0.697s
sys    0m21.682s

4. 小文件（1k byte* 100w个 * 200 client）  { 1000 * 1000 )  
time ../../p_touch_file.sh
real    27m56.656s
user    5m12.195s
sys    20m52.079s


5. 小文件（1k byte* 100w个 * 1000 client）  { 1000 * 1000 )
写入
time ../../p_touch_file.sh
real    30m30.336s
user    5m6.607s
sys    21m




5.2 本地磁盘
1. 大文件(block=1M  byte)
dd if=/dev/zero of=1.img bs=1M count=5000
5242880000 bytes (5.2 GB) copied, 58.7371 seconds, 89.3 MB/s


2. 小文件(50 byte * 100w个 * 1 client)    { 1000 * 1000  ）
写入
time ../touch_file.sh
real  17m47.746s
user 4m54.068s
sys  12m54.425s
列表
time find ./ -type f | nl | tail
1000000 ./875/582
1000001 ./875/875
real 0m9.120s
user 0m1.102s
sys 0m0.726s
删除
time rm -fr *
real 0m37.201s
user 0m0.432s
sys 0m15.268s

5.3 基准测试(第一次)
5.3.1  随机读
random_read_performance.jpg

5.3.2  随机写
random_wirte_performance.jpg

5.3.3 顺序读
read_performance.jpg
5.3.4  顺序写
write_performance.jpg


5.4 基准测试（第2次）
5.4.1 随机读
2_random_write_performance.jpg



性能测试模型2 （感谢 qq群战友 痞子白 提供）
两个Client同时dd测试
数据块1M 文件大小20G
Client1 写：68.4MB/s  读：25.3MB/s
Client2 写：67.5MB/s  读：24.7MB/s
总吞吐：写：135.9MB/s 读：50.0MB/s

写命令：dd if=/dev/zero of=/mfs/test.1 bs=1M count=20000
读命令：dd if=/mfs/test.1 of=/dev/null bs=1M


8. 附录
8.1  1000 * 1000 * 1 client 脚本
#!/bin/bash
for ((i=0;i<1000;i++))
do
    mkdir ${i}
    cd ${i}
    for ((j=0;j<1000;j++))
      do
        cp /mnt/test ${j}
      done
      cd ..
done
8.2  1000  * 1000  *  （ 100，200 ,1000 client )  脚本
#!/bin/bash
declare -f make_1000_dir_file
cd `pwd`
function make_1000_dir_file {
    start=${1}
    stop=${2}
    for ((i=${start};i<${stop};i++))
    do
        mkdir ${i}
        for ((j=0;j<1000;j++))
        do
            cp /mnt/test ${i}/${j}
        done
    done
}
i=1
while [ ${i} -le 1000 ]
do
    ((n=${i}+1))
    make_1000_dir_file ${i} $ &
    ((i=${i}+1))
done
wait

9. 实际操作案例
9.1 默认的垃圾回收时间是86400，存在一种可能性是垃圾还没回收完，你的存储容量就暴掉了。（案例提供者shinelian）

方案1：设置垃圾回收时间，积极监控存储容量。
           经过测试，把垃圾回收时间设置300秒，完全可以正确回收容量。

方案2：手动周期性去删除metamfs里的trash目录下的文件（健壮性还有待测试，反正删除后容量是回收了，不晓得有没有什么后遗症。）
           经过测试，貌似没后遗症，有后遗症的同学请在qq群里面联系我。


9.2    mfs 1.6.x的User Guides和FAQ，并和灵犀沟通对文档中不理解的地方，就理解不一致的地方达成一致。MFS1.6.x比1.5.x中有以下的变化：(特别感谢qq群内网友 流云风 和 灵犀 )
     （1）修复1.5.x中在大批量操作时打开文件过多的bug。这个错误也在我们此次测试的时候遇到，报的错误说是打开的文件过多，造成chunker server的链接错误。虽然后来的测试中一直想模拟出来这个问题，但是一直无法模拟出来。在1.6.x中解决此问题，就解决了很大的问题。

      （2）新增加了masterlogger服务器。这是在1.5.x中所没有的，就是做了master服务器的冗余，进一步的加强的master服务器的稳定性。在mfs体系中master是要求最稳定以及性能要求最高的，因此务必保证master的稳定。

      （3）修改1.5.x中存在的对于坏块的修复功能。在mfs1.5.x中遇到chunker坏块校验，错误比较多的是很往往导致master将出现坏块的chunker自动的剔除出去的情况，此次增加了对坏块的修复功能，很方便的进行修复，简化对坏块的处理功能。

      （4）对metadata和changelog的新认识。之前认为changelog记录的是文件的操作，定期的像数据库的日志一样归档到metadata中。发现上面的理解存在误区，真正的是changelog中记录了对文件的操作，metadata记录文件的大小和位置。因此metadata是比较重要的，在进行修复的过程中是采用metadata和最后一次的changelog进行修复的。

      （5）MFS文档中明确指出对于内存和磁盘大小的要求。【In our environment (ca. 500 TiB, 25 million files, 2 million folders distributed on 26 million chunks on 70 machines) the usage of chunkserver CPU (by constant file transfer) is about 15-20% and chunkserver RAM usually consumes about 100MiB (independent of amount of data).
The master server consumes about 30% of CPU (ca. 1500 operations per second) and 8GiB RAM. CPU load depends on amount of operations and RAM on number of files and folders.】

      （6）指出了在测试的过程中多个chunker并不影响写的速度，但是能加快读的速度。在原来的基础上增加一个chunker时，数据会自动同步到新增的chunker上以达到数据的平衡和均衡。

9.3 mfs1.5.x 数据恢复实例 （案例分享 ： QQ群战友 Xufeng）
            其实很简单，就是mfsrestore, 然后启动服务的时候，并有任何提示信息，进程启不来,其实是配置文件放PID的目录会被删掉，重建这个目录，然后赋予权限就可以了,我已经做过1.5到1.6的升级，还可以.
            详情见 Xufeng blog http://snipt.net/iamacnhero/tag/moosefs


11  web gui 监控

01_info.png


02_servers.png

03_disks.png


04_exports.png


05_mounts.png


06_operations.png


07_master_charts.png


08_server_charts.png

    gui_info.jpg (143.72 KB, 下载次数: 168)

    gui_info.jpg

    gui_most.jpg (209.36 KB, 下载次数: 164)

    gui_most.jpg

    gui_master_info.jpg (212.79 KB, 下载次数: 178)

    gui_master_info.jpg

    gui_server.jpg (223.96 KB, 下载次数: 165)

    gui_server.jpg

General:
Removed duplicate source files.
移除了复制源文件
Strip whitespace at the end of configuration file lines.
配置文件行的末尾将为空白
Chunkserver:
Chunkserver
Rewritten in multi-threaded model.
重写了多线成模式
Added periodical chunk testing functionality (HDD_TEST_FREQ option).
增加了定期chunk测试功能（HDD_TEST_FREQ选项）
New -v option (prints version and exits).
新的-v选项（显示版本）

Master:
Added "noowner" objects flag (causes objects to belong to current user).
增加了"noowner"对象标记（可以使对象属于当前用户）
Maintaining `mfsdirinfo` data online, so it doesn't need to be calculated on every request.
保持‘mfsdirinfo’数据在线，这样就不需要求每一个请求都进行运算。
Filesystem access authorization system (NFS-like mfsexports.cfg file, REJECT_OLD_CLIENTS option) with ro/rw, maproot, mapall and password functionality.
文件系统访问认证系统（类似于NFS的mfsexports.cfg文件，REJECT_OLD_CLIENTS选项），有ro/rw, maproot, mapall及密码功能
New -v option (prints version and exits).
新的-v选项（显示版本）

Mount:
Rewritten options parsing in mount-like way, making possible to use standard FUSE mount utilities (see mfsmount( manual for new syntax). Note: old syntax is no longer accepted and mountpoint is mandatory now (there is no default).
重写选项将采用类似于挂载的解析方式，使用标准的FUSE挂载工具集将成为可能（参见新的mfsmount(语法手册）。注：旧的语法现在将不再被支持，而设置挂载点则是必须的。（非默认选项）
Updated for FUSE 2.6+.
升级到FUSE 2.6版本以上
Added password, file data cache, attribute cache and entry cache options. By default attribute cache and directory entry cache are enabled, file data cache and file entry cache are disabled.
增加了密码，文件数据缓存，属性缓存及目录项选项。默认情况下，属性缓存及目录项缓存是开启的，而文件数据缓存和文件项输入缓存则是关闭的
opendir() no longer reads directory contents- it's done on first readdir() now; fixes "rm -r" on recent Linux/glibc/coreutils combo.
opendir()函数将不再读取目录内容-读取目录内容现在将由readdir()函数完成；修复了当前Linux/glibc/coreutils组合中的‘rm -r’命令
Fixed mtime setting just before close() (by flushing file on mtime change); fixes mtime preserving on "cp -p".
修复了在close()前的mtime设置（在mtime变化的时候刷新文件）
Added statistics accessible through MFSROOT/.stats pseudo-file.
增加了表示访问吞吐量的统计伪文件MFSROOT/.stats
Changed master access method for mfstools (direct .master pseudo-file replaced by .masterinfo redirection); fixes possible mfstools race condition and allows to use mfstools on read-only filesystem.
对于mfstools改变了主要的访问路径（直接）

Tools:
Units cleanup in values display (exact values, IEC-60027/binary prefixes, SI/decimal prefixes); new options: -n, -h, -H and MFSHRFORMAT environment variable - refer to mfstools( manual for details).
在单元值显示方面进行一致化（确切值，IEC-60027/二进制前缀， SI/十进制前缀）；新的选项：-n,-h,-H以及可变的MFSHRFORMAT环境----详细参见mfstools(手册
mfsrgetgoal, mfsrsetgoal, mfsrgettrashtime, mfsrsettrashtime have been deprecated in favour of new "-r" option for mfsgetgoal, mfssetgoal, mfsgettrashtime, mfssettrashtime tools.
我们推荐使用带新的“-r”选项的mfsgetgoal, mfssetgoal, mfsgettrashtime, mfssettrashtime工具，而不推荐mfsrgetgoal, mfsrsetgoal, mfsrgettrashtime, mfsrsettrashtime工具。（注意前后命令是不一样的，看起来很类似）
mfssnapshot utility replaced by mfsappendchunks (direct descendant of old utility) and mfsmakesnapshot (which creates "real" recursive snapshots and behaves similar to "cp -r".
mfssnapshot工具集取代了mfsappendchunks（老工具集的后续版本）和mfsmakesnapshot（该工具能够创建“真”的递归快照，这个动作类似于执行“cp -r”）工具
New mfsfilerepair utility, which allows partial recovery of file with some missing or broken chunks.
新的mfs文件修复工具集，该工具允许对部分丢失及损坏块的文件进行恢复
CGI scripts:
First public version of CGI scripts allowing to monitor MFS installation from WWW browser.
第一个允许从WWW浏览器监控MFS安装的CGI脚本发布版本


13. mfs官方FAQ（TC版）
What average write/read speeds can we expect?
The raw reading / writing speed obviously depends mainly on the performance of the used hard disk drives and the network capacity and its topology and varies from installation to installation. The better performance of hard drives used and better throughput of the net, the higher performance of the whole system.

In our in-house commodity servers (which additionally make lots of extra calculations) and simple gigabyte Ethernet network on a petabyte-class installation
on Linux (Debian) with goal=2 we have write speeds of about 20-30 MiB/s and reads of 30-50MiB/s. For smaller blocks the write speed decreases, but reading is not much affected.

Similar FreeBSD based network has got a bit better writes and worse reads, giving overall a slightly better performance.

Does the goal setting influence writing/reading speeds?
Generally speaking,
it doesn’t. The goal setting can influence the reading speed only under certain conditions. For example, reading the same file at the same time by more than one client would be faster when the file has goal set to 2 and not goal=1.

But the situation in the real world when several computers read the same file at the same moment is very rare; therefore, the goal setting has rather little influence on the reading speeds.

Similarly, the writing speed is not much affected by the goal setting.


How well concurrent read operations are supported?
All read processes are parallel - there is no problem with concurrent reading of the same data by several clients at the same moment.

How much CPU/RAM resources are used?
In our environment (ca. 500 TiB, 25 million files, 2 million folders distributed on 26 million chunks on 70 machines) the usage of chunkserver CPU (by constant file transfer) is about 15-20% and chunkserver RAM usually consumes about 100MiB (independent of amount of data).
The master server consumes about 30% of CPU (ca. 1500 operations per second) and 8GiB RAM. CPU load depends on amount of operations and RAM on number of files and folders.

Is it possible to add/remove chunkservers and disks on fly?
You can add / remove chunkservers on the fly. But mind that it is not wise to disconnect a chunkserver if there exists a chunk with only one copy (marked in orange in the CGI monitor).
You can also disconnect (change) an individual hard drive. The scenario for this operation would be:


    Mark the disk(s) for removal
    Restart the chunkserver process
    Wait for the replication (there should be no “undergoal” or “missing” chunks marked in yellow, orange or red in CGI monitor)
    Stop the chunkserver process
    Delete entry(ies) of the disconnected disk(s) in 'mfshdd.cfg'
    Stop the chunkserver machine
    Remove hard drive(s)
    Start the machine
    Start the chunkserver process


If you have hotswap disk(s) after step 5 you should follow these:

    Unmount disk(s)
    Remove hard drive(s)
    Start the chunkserver process


If you follow the above steps work of client computers would be not interrupted and the whole operation would not be noticed by MooseFS users.

My experience with clustered filesystems is that metadata operations are quite slow. How did you resolve this problem?
We have noticed the problem with slow metadata operations and we decided to cache file system structure in RAM in the metadata server. This is why metadata server has increased memory requirements.


When doing df -h on a filesystem the results are different from what I would expect taking into account actual sizes of written files.
Every chunkserver sends its own disk usage increased by 256MB for each used partition/hdd, and a sum of these master sends to the client as total disk usage. If you have 3 chunkservers with 7 hdd each, your disk usage will be increased by 3*7*256MB (about 5GB). Of course it's not important in real life, when you have for example 150TB of hdd space.

There is one other thing. If you use disks exclusively for MooseFS on chunkservers df will show correct disk usage, but if you have other data on your MooseFS disks df will count your own files too.

If you want to see usage of your MooseFS files use 'mfsdirinfo' command.


Do chunkservers and metadata server do their own checksumming?
Yes there is checksumming done by the system itself. We thought it would be CPU consuming but it is not really. Overhead is about 4B per a 64KiB block which is 4KiB per a 64MiB chunk (per goal).

What sort of sizing is required for the Master  server?
The most important factor is RAM of mfsmaster machine, as the full file system structure is cached in RAM for speed. Besides RAM mfsmaster machine needs some space on HDD for main metadata file together with incremental logs.

The size of the metadata file is dependent on the number of files (not on their sizes). The size of incremental logs depends on the number of operations per hour, but length (in hours) of this incremental log is configurable.

1 million files takes approximately 300 MiB of RAM. Installation of 25 million files requires about 8GiB of RAM and 25GiB space on HDD.


When I delete files or directories the MooseFS size doesn’t change. Why?
MooseFS is not erasing files immediately to let you revert the delete operation.

You can configure for how long files are kept in trash and empty the trash manually (to release the space). There are more details here:
http://moosefs.com/pages/userguides.html#2[MB1] in section "Operations specific for MooseFS".

In short - the time of storing a deleted file can be verified by the mfsgettrashtime command and changed with mfssettrashtime.


When I added a third server as an extra chunkserver it looked like it started replicating data to the 3rd server even though the file goal was still set to 2.
Yes. Disk usage ballancer uses chunks independently, so one file could be redistributed across all of your chunkservers.

Is MooseFS 64bit compatible?Yes!

Can I modify the chunk size?
File data is divided into fragments (chunks) with a maximum of 64MiB each. The value of 64 MiB is hard coded into system so you cannot modify its size. We based the chunk size on real-world data and it was a very good compromise between number of chunks and speed of rebalancing / updating the filesystem. Of course if a file is smaller than 64 MiB it occupies less space.

Please note systems we take care of enjoy files of size well exceeding 100GB and there is no chunk size penalty noticeable.

How do I know if a file has been successfully written in MooseFS?
First off, let's briefly discuss the way the writing process is done in file systems and what programming consequences this bears. Basically, files are written through a buffer (write cache) in all contemporary file systems. As a result, execution of the "write" command itself only transfers the data to a buffer (cache), with no actual writing taking place. Hence, a confirmed execution of the "write" command does not mean that the data has been correctly written on a disc. It is only with the correct performance of the "fsync" (or "close" command that all data kept in buffers (cache) gets physically written. If an error occurs while such buffer-kept data is being written, it could return an incorrect status for the "fsync" (or even "close", not only "write" command.
The problem is that a vast majority of programmers do not test the "close" command status (which is generally a mistake, though a very common one). Consequently, a program writing data on a disc may "assume" that the data has been written correctly, while it has actually failed.
As far as MooseFS is concerned – first, its write buffers are larger than in classic file systems (an issue of efficiency); second, write errors may be more frequent than in case of a classic hard drive (the network nature of MooseFS provokes some additional error-inducing situations). As a consequence, the amount of data processed during execution of the "close" command is often significant and if an error occurs while the data is being written, this will be returned in no other way than as an error in execution of the "close" command only.
Hence, before executing "close", it is recommended (especially when using MooseFS) to perform "fsync" after writing in a file and then check the status of "fsync" and – just in case – the status of "close" as well.
NOTE! When "stdio" is used, the "fflush" function only executes the "write" command, so correct execution of "fflush" is not enough grounds to be sure that all data has been written successfully – you should also check the status of "fclose".
One frequent situation in which the above problem may occur is redirecting a standard output of a program to a file in "shell". Bash (and many other programs) does not check the status of "close" execution and so the syntax of the "application > outcome.txt" type may wrap up successfully in "shell", while in fact there has been an error in writing the "outcome.txt" file. You are strongly advised to avoid using the above syntax. If necessary, you can create a simple program reading the standard input and writing everything to a chosen file (but with an appropriate check with the "fsync" command) and then use "application | mysaver outcome.txt", where "mysaver" is the name of your writing program instead of "application > outcome.txt".
Please note that the problem discussed above is in no way exceptional and does not stem directly from the characteristics of MooseFS itself. It may affect any system of files – only that network type systems are more prone to such difficulties. Technically speaking, the above recommendations should be followed at all times (also in case of classic file systems).
