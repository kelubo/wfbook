# Rocks
## 属性
| 名称 | 类型 | 默认值 |
|--|--|--|
| disableServices | string | kudzu canna cWnn FreeWnn kWnn tWnn mDNSResponder |
| Info_CertificateCountry [a] | string |  |
| Info_CertificateLocality [a] | string |  |
| Info_CertificateOrganization [a] | string |  |
| Info_CertificateState [a] | string |  |
| Info_CertificateContact [a] | string |  |
| Info_CertificateLatLong [a] | string |  |
| Info_CertificateName [a] | string |  |
| Info_CertificateURL [a] | string |  |
| Kickstart_DistroDir [a] | string | /export/rocks |
| Kickstart_Keyboard [a] | string | us |
| Kickstart_Lang [a] | string | en_US |
| Kickstart_Langsupport [a] | string | en_US |
| Kickstart_Mutlicast [a] | string | 226.117.172.185 |
| Kickstart_PrivateAddress [a] | string | 10.1.1.1 |
| Kickstart_PrivateBroadcast [a] | string | 10.1.255.255 |
| Kickstart_PrivateDNSDomain [a] | string | local |
| Kickstart_PrivateDNSServers [a] | string | 10.1.1.1 |
| Kickstart_PrivateGateway [a] | string | 10.1.1.1 |
| Kickstart_PrivateHostname [a] | string |  |
| Kickstart_PrivateKickstartBaseDir [a] | string | install |
| Kickstart_PrivateKickstartCGI [a] | string | sbin/kickstart.cgi |
| Kickstart | string |  |
| _PrivateKickstartHost [a] | string | 10.1.1.1 |
| Kickstart_PrivateNTPHost [a] | string | 10.1.1.1 |
| Kickstart_PrivateNetmask [a] | string | 255.255.0.0 |
| Kickstart_PrivateNetmaskCIDR [a] | string | 16 |
| Kickstart_PrivateNetwork [a] | string | 10.1.0.0 |
| Kickstart_PrivatePortableRootPassword [a] | string |  |
| Kickstart_PrivateRootPassword [a] | string |  |
| Kickstart_PrivateSHARootPassword [a] | string |  |
| Kickstart_PrivateSyslogHost [a] | string | 10.1.1.1 |
| Kickstart_PublicAddress [a] | string |  |
| Kickstart_PublicBroadcast [a] | string |  |
| Kickstart_PublicDNSDomain [a] | string |  |
| Kickstart_PublicDNSServers [a] | string |  |
| Kickstart_PublicGateway [a] | string |  |
| Kickstart_PublicHostname [a] | string |  |
| Kickstart_PublicKickstartHost [a] | string |  |
| Kickstart_PublicNTPHost [a] | string |  |
| Kickstart_PublicNetmask [a] | string |  |
| Kickstart_PublicNetmaskCIDR [a] | string |  |
| Kickstart_PublicNetwork [a] | string |  |
| Kickstart_Timezone [a] | string |  |
| airboss [b] | string | specified on boot line |
| arch [c], [b] | string | i386 | x86_64 |
| dhcp_filename [d] | string | pxelinux.0 |
| dhcp_nextserver [d] | string | 10.1.1.1 |
| hostname [e], [b] | string |  |
| kickstartable [d] | bool | TRUE |
| os [c], [b] | string | linux | solaris |
| rack [e], [b] | int |  |
| rank [e], [b] | int |  |
| rocks_version [a] | string | 6.1.1 |
| rsh [f] | bool | FALSE |
| rocks_autogen_user_keys [f] |	bool | FALSE
| ssh_use_dns [a] | bool | TRUE
| x11 [f] | bool | FALSE

Notes:
a. Default value created using rocks add attr name value and affects all hosts.
b. Default value created using rocks add host attr localhost name value and only affects the frontend appliance.
c. Attribute is for internal use only, and should not be altered by the user. Each time a machine installs this attributed is reset to the default value for that machine (depend on kernel booted).
d. Default value created using rocks add appliance attr appliance name value for the frontend and compute appliances.
e. Attribute cannot by modified. This value is not recorded in the cluster database and is only available as an XML entity during installation.
f. Attribute is referenced but not defined so is treated as FALSE.

** Info_Certificate_{*} **

    The attributes are created during frontend installation. The values are taken from user input on the system installation screens. 
**Kickstart_{*}**

    The attributes are created during frontend installation. The values are taken from user input on the system installation screens. All of these attributes are considered internal to Rocks® and should not be modified directly. 
**airboss**

    Specifies the address of the airboss host. This only applies to virtual machines. 
**arch**

    The CPU architecture of the host. This host-specific attribute is set by the installing machine. User changes to this attribute have no affect. 
**dhcp_filename**

    Name of the PXE file retrieved over TFTP at startup. 
**dhcp_nextserver**

    IP address of the server that servers installation profiles (kickstart, jumpstart). In almost all configuration this should be the frontend machine. 
**kickstartable**

    The attribute must be set to TRUE for all appliances, and FALSE (or undefined) for all unmanaged devices (e.g. network switches). 
**os**

    The OS of the host. This host-specific attribute is set by the installing machine. User changes to this attribute have no affect. 
**rsh**

    If TRUE the machine is configured as an RSH client. This is not recommended, and will still require RSH server configuration on the frontend machine. 
**ssh_use_dns**

    Set to FALSE to disable DNS lookups when connecting to nodes in the cluster over SSH. If establishing an ssh connect is slow the cause may be a faulty (or absent) DNS system. Disabling this lookup will speed up connection establishment, but lowers the security of your system. 
**x11**

    If TRUE X11 is configured and the default runlevel is changed from 3 to 5. X11 is always configure on the frontend and this attribute applies only to the other nodes in the cluster. 
## Installation
处理器

    x86 (ia32, AMD Athlon, etc.)
    x86_64 (AMD Opteron and EM64T) 

Networks

    Ethernet 

Note	
Specialized networks and components (e.g., Myrinet, Infiniband, nVidia GPU) are also supported. Hardware requirements and software (Rocks Rolls) can be found on the respective vendor web sites.
### Minimum Hardware Requirements

Frontend Node

    Disk Capacity: 30 GB
    Memory Capacity: 1 GB
    Ethernet: 2 physical ports (e.g., "eth0" and "eth1")
    BIOS Boot Order: CD, Hard Disk 

Compute Node

    Disk Capacity: 30 GB
    Memory Capacity: 1 GB
    Ethernet: 1 physical port (e.g., "eth0")
    BIOS Boot Order: CD, PXE (Network Boot), Hard Disk 

### 硬件架构
![](../Image/cluster.png)