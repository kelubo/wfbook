 Directory Server

The FreeIPA Directory Service is built on the 389 DS LDAP server. It is the base stone of the whole Identity Management solution. It serves as a data backend for all identity, authentication (Kerberos) and authorization services and other policies.

The used technology allows FreeIPA to offer a multi-master environment, where administrator can deploy a number of replicating FreeIPA servers, thus distributing the load on Identity Management servers and providing higher redundancy at the same point.
Contents

    1 Data Storage
        1.1 Accessing Data
        1.2 Modifying Data
    2 Server Plugins
    3 Backup and Restore

Data Storage

All FreeIPA identity, policy, configuration or certificates are stored in the Directory Server. FreeIPA objects are stored in one suffix calculated from realm name (e.g. dc=example,dc=com for a realm EXAMPLE.COM), certificates are stored in a second suffix, o=ipaca.
Accessing Data

Access to different parts of the Directory Server tree is protected by DS ACI configuration. Some parts of the tree (like users) can be open anonymously to everyone, others may be open only to authenticated users (like sudo) and other's only to privileged users (like DNS tree). Write access is even more strict, but it can be allowed to FreeIPA users using the permission plugins (run ipa help permission command for more information) which can add DS ACIs allowing that operation in a user'convenient way.
Modifying Data

As Directory Server is communicating with standard LDAPv3 protocol, standard LDAP clients can be used to read all the identity and policy objects. However, adding or modification of directory entries by custom LDAP clients is not recommended as it could lead to incomplete or inconsistent entries in the tree where some expected attribute is in an invalid format or missing at all.

To make the manipulation of the entries easier, the provided CLI and Web UI interfaces provide a supported way of performing the modifications. Run ipa help topics to see the list of supported commands.
Server Plugins

Just a plain data storage is not sufficient for an efficient Identity Management solution. It also needs to provide more advanced functions supporting it's clients, for instance validation for selected attributes, authentication hooks to prevent brute forcing of a user's password, extended operations etc.

FreeIPA configures primarily the following set of plugins (to see all of them, traverse cn=plugins,cn=config in the tree):

    ipa_pwd_extop: Handles password changes, enforces the FreeIPA password policy (ipa help pwpolicy) for new or changed passwords
    IPA Lockout: hooks into authentication to the Directory Server (i.e. LDAP BIND operation) and makes sure nobody is brute forcing the user's password by running too many passwords attempt. If it does, it locks out the user for configured amount of time.
    ipa_enrollment_extop: provides extended operation for enrollment of new clients and creating new client host entry
    Schema Compatibility: publishes an alternate trees containing a computed different view on objects in the DS. For instance, as FreeIPA stores users using RFC 2307bis schema, it publishes alternate tree cn=users,cn=compat,dc=example,dc=com with users in a RFC 2307 schema. It is also used by Trusts feature to allow Active Directory users access legacy system without a recent SSSD version.
    ipa-winsync: enables user synchronization with Active Directory. Note that winsync synchronization is rather obsoleted and Trusts are a preferred way of FreeIPA - Active Directory interoperation
    IPA DNS: makes sure that serial number of modified DNS zones is properly increased, thus enabling DNS zone transfers

Backup and Restore

See a separate Backup and Restore article to read more about backup and restore scenarios and how to approach them.
