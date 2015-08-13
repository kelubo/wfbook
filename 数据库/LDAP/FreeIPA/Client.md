 Client

FreeIPA uses standard components and protocols so any LDAP/Kerberos (and even NIS) client can interoperate with FreeIPA Directory Server for basic authentication and user/group enumeration. However additional management functionality can be achieved using the SSSD project. SSSD is a spin-off of the FreeIPA project and has specific support for FreeIPA features with the 'IPA' provider. Additional features made available via SSSD are SUDO integration, HBAC policies, SELinux user mapping, and more. SSSD is configured by default.
Contents

    1 Certificates
    2 Compatibility
        2.1 IPA management tool
    3 Integration

Certificates

When certificates are to be used on a client as well, Certmonger can handle it's automated renewal so that they do not get out of validity range.
Compatibility

FreeIPA client functionality (identity, authentication, policies) is maintained to be both backward and forward compatible. Thus, SSSD in FreeIPA 3.3.5 will be fully functional both with FreeIPA 3.0.0 and FreeIPA 4.0. When connected to the older server, it will of course only provide functionality available on the older server.
IPA management tool

ipa management command (available in freeipa-admintools package) and the FreeIPA API itself only maintains forward compatibility. Therefore, ipa command on FreeIPA 3.0.0 client will be able to control FreeIPA 4.0 but not vice versa. Additionally, client will be able to only run commands and parameters available in the older version. FreeIPA client of the same version as the server need to be used to leverage full FreeIPA management capability.

Every FreeIPA client is built with given API version. When a management command is executed, client sends it's API version together with the command to the server. The server then compares the API version with it's own and if the client is compatible, it executes the command. If not, the command errors out:

$ ipa user-find example
ipa: ERROR: 2.65 client incompatible with 2.49 server at u'https://ipa.example.com/ipa/xml'

Integration

FreeIPA Client integrates with many Linux native services so that administrator can conveniently configure them centrally, on FreeIPA server. The services mostly use SSSD so that they can also benefit from caching and be available when the client is offline.

    automount: server can keep automount maps differentiated by a location. The maps are consumed by client autofs. The integration is configured with a separate installation script - ipa-client-automount which can be run after ipa-client-install.
    SSH: server can keep SSH public keys (training material) that are than used by both sshd and ssh. The integration is configured automatically with ipa-client-install, unless limited with --no-ssh/--no-sshd. DNS SSHFP records for the host are automatically created by ipa-client-install, unless run with --no-dns-sshfp.
    SUDO: server can provide centralized sudoers to all clients (training material. The feature needs to be configured manually in FreeIPA clients older than 4.0 (related ticket). Since FreeIPA 4.0, configuration happens automatically unless unless --no-sudo is passed.
    SELinux user map: server can keep policies to assign different SELinux user roles to users, based on their group or host group (see SELinux user mapping article or training material). The feature is configure automatically with ipa-client-install