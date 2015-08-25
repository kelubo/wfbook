LOGO
Installing MooseFS 2.0
Step by Step Tutorial
CORE TECHNOLOGY DEVELOPMENT & Support Team
October 17,2014
?2013-2014
Piotr Robert Konopelko,CORE TECHNOLOGY DEVELOPMENT & Support Team
All rights reserved
Proofread by Agata Kruszona-Zawadzka
Coordination layout by Piotr Robert Konopelko.
Please send corrections to peter@mfs.io.
Contents
1	Introduction
	1.1	Key differences between versions 1.6.2x and 2.0.x
	1.2	Many Master Servers - how does it work?
2	Things to do before installation
	2.1	Configuring Domain Name Service
	2.2	Adding repository
		2.2.1 Repository branches
		2.2.2 Ubuntu/Debian	
		2.2.3 CentOS/Fedora/RHEL
		2.2.4 MacOS X
	2.3 Differences in package names between Pro and CE version
3	MooseFS installation process on dedicated machines
	3.1 Master Server(s) installation
	3.2 MooseFS CGI and CGI server installation
	3.3 MooseFS CLI installation
	3.4 Backup servers (metaloggers) installation
	3.5 Chunk servers installation
	3.6 Users' computers installation
4	Basic MooseFS use
5	Stopping MooseFS
6	Supplement:Setting up DNS server on Debian/Ubuntu
	6.1 Setting up DNS server
	6.2 Setting up revDNS server
Chapter 1
Introduction
Notice:there is one dependency to resolve:users' computers neet FUSE package to mount MooseFS.It can be downloaded
and installed from repositories.
1.1 Key differences between version 1.6.2x and 2.0.x
1.Master host(s) configuration is done solely via DNS - it is no longer possible to list master(s) IP address(es)
in clients' and chunkservers' configuration;default name for master domain is mfsmaster,it can be changed in configuration
files;
2.In Pro version metaloggers become optional,they can be replaced by additional master servers;in CE version it 
is still remommended to set up metaloggers.
3.Mfsmetarestore tool is no longer present in the system;instead,it is enough to start the master process with -a
switch;
4.Configuration files now sit in mfs subdirectory inside the etc directory(this change was introduced in 1.6.27)
1.2Many Master Servers - how does it work?
In previous MooseFS version you had only one master process and any number of metaloggers.
In the event of master failure,system administrator was able to retrieve "metadata" information
from the metalogger and start a new master (on a new machine,if necessary),so the file system was up and running again.
But this was always causing the system to be unavailable to clients for a period of time and required manual work to bring
it back up.
New Pro version introduces many master servers working together in multiple roles.One role is "leader".The leader master
is acting as it used to for the chunkservers and clients.There is never more than one leader in any working system.
The other role is "follower".The follower master is doing what metaloggers used to do - it downloads metadata from the leader
master and keeps it.But unlike a metalogger,if a leader master stops working,a follower master is immediately ready to take
on the role of leader.If the leader master fails,a new candidate for leader is chosen from the followers.The candidate assumes
a role of "elect",that automatically converts to "leader" as soon as more than halt of the chunkservers connect to elect.There
can be more than one follower in the system.
The whole switching operation is almost invisible to the system users,as it usually takes between a couple to a dozen or so 
seconds.When/if the former leader master starts working again ,it assumes the role of follower.If a follower master fails,it 
has no effect on the whole system .If such a master starts working again ,it again assumes the role of follower .
Chapter 2
Things to do before installation
For the sake of this document,it's assumed that your machines have following IP addresses:
Master servers : 192.168.1.1,192.168.1.2
chunk servers :  192.168.1.101,192.168.1.102 and 192.168.1.103
Users' computers (clients):192.168.2.X
2.1 Configuring Domain Name Serveice
Before you start installing MooseFS,you need to have working DNS.It's needed for MooseFS to work properly with several master
Servers ,because DNS can resolve one host name as more than one IP address.
All IPs of machines,which will be master servers,must be included in DNS configuration file and resolved as "mfsmaster" (or any
other selected name),e.g.:
      Listing 2.1:DNS entries
  mfsmaster		IN	A	192.168.1.1		;address of first master server
  mfsmaster		IN	A	192.168.1.2		;address of second master server
More information about configuring DNS server is included in supplement.
2.2 Adding repository
To install MooseFS 2.0 Pro or CE you need to add MooseFS Official Supported Repositories to your system .This process is described
at http://get.moosefs.com (please select your distribution in menu on the left) or in paragraph 2.2 in document named Installing
MooseFS 2.0 Step by Step Tutorial.
At this time there are repositories available for Ubuntu/Debian,RHEL/CentOS/Fedora,FreeBSD and MacOS X.
2.2.1 repository branches
Our repository contains two branches:stable and current.Version from stable branch has been tested both in the production and in 
our test environment.Version from current brach - only in our test environment.MooseFS versions in these branches are upgraded
automatically after finishing the tests.
At the time of writing this guide,stable branch contains version 2.0.39-1 ,and current branch contains version 2.0.40-1.
Stable brach is default and you don't need to make any changes in default URL:
http://ppa.moosefs.com/stable/.
If you want to use current branch ,you just need to replace stable with current after http://ppa.moosefs.com/ and before apt
,yum,freebsd or osx, so URL will look like:
  http://ppa.moosefs.com/current/[rest of url]
