 Deployment Recommendations
Important.png
Work in progress
This document is not complete yet. However, if you have any comments, please feel free to discuss.

Some decisions made before FreeIPA is deployed and adopted are very hard to be fixed later, if not impossible. This article therefore digs in the most important decisions needed for a successful deployment.
Contents

    1 Infrastructure
        1.1 DNS
            1.1.1 Domain
            1.1.2 DNS server
        1.2 PKI
        1.3 Replicas
        1.4 Clients
    2 Disaster recovery
    3 Active Directory Integration
    4 Migration
    5 Extending FreeIPA

Infrastructure
DNS

DNS is deliberately listed first as DNS plays an important role in identity management functionality, especially Kerberos.
Domain

FreeIPA should always have own primary domain, e.g. example.com or ipa.example.com which should not be shared with other Kerberos based identity management system as otherwise there will be collisions on Kerberos system level. For example, if both FreeIPA and Active Directory use the same domain, trusts will be never possible, as well as automatic client server discovery via DNS SRV records.
Important.png
Avoid name collisions

We strongly recommend that you do not use a domain name that is not delegated to you, even on a private network. For example, you should not use domain name company.int if you don't have valid delegation for it in public DNS tree.

If this rule is not respected, the domain name will be resolved differently depending on the network configuration. As a result, network resources will become unavailable. Using domain names that are not delegated to you also makes DNSSEC more difficult to deploy and maintain.
For further information about this issue please see the ICANN FAQ on domain name collisions.

Your Kerberos realm should equal to upper-cased FreeIPA's DNS domain. It eases configuration and it is one of requirements for AD trust deployment.

Client machines do not need to be in the same domain as FreeIPA servers. For example, FreeIPA many be a domain ipa.example.com and clients in domain clients.example.com, there just need to be a clear mapping between DNS domain and Kerberos realm. FreeIPA domains have _kerberos TXT DNS record added automatically.
Important.png
Change of realm
It is not possible to change FreeIPA primary domain and realm after installation. Plan carefully. Do not expect move from lab/staging environment to production environment (e.g. change lab.example.com to prod.example.com)
DNS server

FreeIPA domain may be either served from an integrated DNS service or an external name service. A FreeIPA domain delegated to the integrated DNS service is a recommended approach.

When using external name server, identity management functionality or trusts will be possible, however the configuration will be much more difficult and error prone. Full list of benefits of using the integrated DNS service can be found in the DNS article.
PKI

When PKI service is configured, FreeIPA hosts and services may obtain signed certificates from FreeIPA CA. Certificates can then be used for authentication or secure authentication in configured services.

Currently, there are 3 types how FreeIPA can blend in a existent certificate environment:

    No blending - FreeIPA is simply installed with own PKI service and a self-signed CA certificate
    External CA - FreeIPA is installed with own PKI, but it's CA certificate is signed with external certificate authority (Active Directory Certificate Service or other custom Certificate Service). This requires the external CA to allow sub CAs.
    CA-less installation - FreeIPA does not configure own CA, but uses signed host certificates from external CA.

Important.png
Change of certificate subject base
It is not possible to change the certificate subject base of FreeIPA after installation. Plan carefully. The default is O=$REALM
Replicas

FreeIPA runs in a replicated multi-master environment. The number of servers depends on several factors:

    How many entries are in the system?
    How many different geographically dispersed datacenters you have?
    How active are applications and clients regarding authentications and LDAP lookups.

Generally it is recommended to have at least 2-3 replicas in each datacenter. There should be at least one replica in each datacenter with additional FreeIPA services like PKI or DNS if used. Note that it is not recommended to have more than 4 replication agreements per replica. Following example demonstrated the recommended infrastructure:
Deployment example with 16 FreeIPA servers
	
Deployment example with 12 FreeIPA servers
Clients

Every client should have at least 2 DNS servers configured in /etc/resolv.conf for resiliency. Update resolv.conf and DHCPd configuration accordingly.

Enrolling each client using ipa-client-install requires access to port 443 (HTTPS) on IPA master. This is because once enrolled, client uploads own SSH keys and performs few more operations. IPA CLI also uses the same port to communicate to IPA master. Thus, it is required to have access to HTTPS (443) from a client side.
Disaster recovery

Please refer to Backup and Restore article.
Active Directory Integration

In order to be able to configure trusts, DNS needs to be configured properly, FreeIPA must have an own primary DNS domain matching it's Kerberos realm name. DNS domain and realm have to be different from Active Directory DNS domain.

Another important requirement is IPv6 stack. Recommended way for contemporary networking applications is to only open IPv6 sockets for listening because IPv4 and IPv6 share the same port range locally. FreeIPA uses Samba as part of its Active Directory integration and Samba requires enabled IPv6 stack on the machine.

Adding ipv6.disable=1 to the kernel commandline disables the whole IPv6 stack and breaks Samba.

Adding ipv6.disable_ipv6=1 will keep the IPv6 stack functional but will not assign IPv6 addresses to any of your network devices. This is recommeneded approach for cases when you don't use IPv6 networking.

Creating and adding following lines to for example /etc/sysctl.d/ipv6.conf will avoid assigning IPv6 addresses to a specific network interface:

 net.ipv6.conf.all.disable_ipv6 = 1
 # Disabling "all" does not apply to interfaces that are already "up" when sysctl settings are applied. 
 net.ipv6.conf.<interface0>.disable_ipv6 = 1

where interface0 is your specialized interface. Note that all we are requiring is that IPv6 stack is enabled at the kernel level and this is recommended way to develop networking applications for a long time already.
Migration

FreeIPA can already migrate from a general LDAP server or NIS. It cannot, however, automatic migration from a pure Kerberos solution or from other FreeIPA deployment (see tickets #3656 and #4285).
Extending FreeIPA

Both FreeIPA schema, CLI and Web UI can be extended. Directory Server schema needs to be extended manually on one server via LDAP manipulation tools. On the other hand, both CLI and Web UI can be extended with plugins shipped together with vanilla FreeIPA packages. See Documentation for additional resources on how to write the extensions. 