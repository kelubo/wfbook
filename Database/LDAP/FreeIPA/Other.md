
Using smart cards with FreeIPA – Part 1

FreeIPA 4.2 has added some nice new PKI related features. FreeIPA has long included the Dogtag Certificate Authority component, but it has been restricted to issuing certificates that are tied to services that are defined in IPA. The main use for these certificates is for enabling TLS for webservers, mail servers, and other applications. As of the 4.2 release, it is possible to define other certificate profiles which can be used for client certificates that are tied to FreeIPA users. The certificates can then be published in the FreeIPA user entries, which allows consumers of those certificates to look them up to perform client certificate authentication.

The FreeIPA API and the ‘ipa’ command-line utility have also been updated in version 4.2 to allow arbitrary certificates to be added to user entries. This is useful for cases where user certificates (and potentially smart cards) may already have been issued by some Certificate Authority other than your FreeIPA server. By adding these ‘external’ certificates to your user entry, you can allow these certificates to be used to authenticate you to services that trust the associated Certificate Authority and use FreeIPA for user/group lookup.

Along with these recent FreeIPA changes, new functionality has been added to SSSD that allow it to use these certificates when they are available in FreeIPA. In particular, SSSD can now support smart card authentication for local authentication such as system login, su, and sudo. In addition, SSSD makes is possible to use smart cards for ‘ssh’ when using systems that include OpenSSH that has been modified to support certificate authentication such as the one included in modern versions of Fedora, CentOS and Red Hat Enterprise Linux.

SSSD has also updated its InfoPipe responder to allow user entries to be looked up by certificate over D-Bus. This allows for some very powerful capabilities. A good example of how this can be used can be seen in some updates that are being made to the mod_lookup_identity Apache httpd module. This module previously allowed httpd to look up user attributes via SSSD that correspond to the user identified in the REMOTE_USER environment variable, which is set by other httpd authentication modules such as mod_auth_gssapi. The mod_lookup_identity module has some pending patches which allow it to use the new SSSD ability to look a user up by certificate, which then sets REMOTE_USER to the proper attribute from the user entry. This user identifier doesn’t even need to exist in the certificate subject DN, as the lookup is performed by matching the entire cerficiate. This allows web application developers to easily add client certificate authentication with user lookup entirely in the web server for both software certificates and smart cards. The web application simply needs to consume REMOTE_USER and the other environment variables provided by mod_lookup_identity, much like the ManageIQ and Foreman projects currently do to support Kerberos Single-Sign-On with FreeIPA.

With all of these cool new capabilities, you may be wondering how you can provision your own smart cards that can be used with your FreeIPA server. This is the first installment in a multi-part series of blog posts which will show how you can provision and use smart cards with FreeIPA. In this first part, we will cover how you can personalize a blank smart card which can be associated with your FreeIPA user.

Smart card hardware and interoperability can vary widely, even though there standards in this area. The example commands I show may have to be modified to work with your hardware. The hardware I’m using in these examples is as follows:

    HID OmniKey 3121 USB card reader
    Athena ASECard Crypto smart card

This smart card works nicely with OpenSC, which we will be using to provision and use our card.  This will be done using a PKCS#15 utility to personalize the card, then OpenSSL and the OpenSC PKCS#11 lib to perform the other crypto operations such as creation of the certificate signing request.  You will need to install the OpenSC package as well as the OpenSSL PKCS#11 Engine:

[nkinder@localhost ~]$ sudo yum install -y opensc engine_pkcs11

Starting with the card reader plugged into the system and no card inserted, we can verify that the system can see the reader:

[nkinder@localhost ~]$ opensc-tool --list-readers
# Detected readers (pcsc)
Nr.  Card  Features  Name
0    No              OMNIKEY AG CardMan 3121 00 00

If we then insert our blank card, we can see that the reader detects it and can run some commands that identity the card:

[nkinder@localhost ~]$ opensc-tool --list-readers
# Detected readers (pcsc)
Nr.  Card  Features  Name
0    Yes             OMNIKEY AG CardMan 3121 00 00
[nkinder@localhost ~]$ opensc-tool --reader 0 --name
Athena ASEPCOS
[nkinder@localhost ~]$ opensc-tool --reader 0 --atr
3b:d6:18:00:81:b1:80:7d:1f:03:80:51:00:61:10:30:8f

Now that we can see that our reader is communicating with the card, we can personalize it.  To do this, we will use the ‘pkcs15-tool’ utility that is a part of OpenSC.  The PKCS#15 specification defines a standard information format on the card.  The first step in personalization is called initialization, and it consists of setting a security officer PIN, a PIN unlock key (PUK), and a transport key:

[nkinder@localhost ~]$ pkcs15-init --create-pkcs15 --use-default-transport-keys
Using reader with a card: OMNIKEY AG CardMan 3121 00 00
New Security Officer PIN (Optional - press return for no PIN).
Please enter Security Officer PIN: 
Please type again to verify: 
Unblock Code for New User PIN (Optional - press return for no PIN).
Please enter User unblocking PIN (PUK): 
Please type again to verify: 
Transport key (External authentication key #0) required.
Please enter key in hexadecimal notation (e.g. 00:11:22:aa:bb:cc),
or press return to accept default.

To use the default transport keys without being prompted,
specify the --use-default-transport-keys option on the
command line (or -T for short), or press Ctrl-C to abort.
Please enter key [41:53:45:43:41:52:44:2b]:

Now that our basic PKCS#15 structure and security officer PIN is set up, we can create a user PIN that will be used to protect user objects that we store on the card such as our private key.  This is a privileged operation that requires our security officer PIN.  Tokens typically support multiple user PINs, so we need to give our PIN an identifier that we will use when performing further operations on the card.  We will use an id of ’01′:

[nkinder@localhost ~]$ pkcs15-init --store-pin --auth-id 01 --label "Nathan Kinder"
Using reader with a card: OMNIKEY AG CardMan 3121 00 00
New User PIN.
Please enter User PIN: 
Please type again to verify: 
Unblock Code for New User PIN (Optional - press return for no PIN).
Please enter User unblocking PIN (PUK): 
Please type again to verify: 
Security officer PIN [Security Officer PIN] required.
Please enter Security officer PIN [Security Officer PIN]:

Our user PIN is now set up, so we can get on to more exciting things such as generating our private key!  For the purposes of this example, we will just generate a 1024-bit RSA key:

[nkinder@localhost ~]$ pkcs15-init --generate-key rsa/1024 --auth-id 01
Using reader with a card: OMNIKEY AG CardMan 3121 00 00
Security officer PIN [Security Officer PIN] required.
Please enter Security officer PIN [Security Officer PIN]: 
User PIN [Nathan Kinder] required.
Please enter User PIN [Nathan Kinder]:

We can now view some information about our private key, which we will need for later commands that use this key:

[nkinder@localhost ~]$ pkcs15-tool --list-keys
Using reader with a card: OMNIKEY AG CardMan 3121 00 00
Private RSA Key [Private Key]
    Object Flags   : [0x3], private, modifiable
    Usage          : [0x4], sign
    Access Flags   : [0x1D], sensitive, alwaysSensitive, neverExtract, local
    ModLength      : 1024
    Key ref        : 0 (0x0)
    Native         : yes
    Path           : 3f0050150100
    Auth ID        : 01
    ID             : 89015cc53f659f38d8ba2d2646b5b84c4be6820f
    GUID           : {5ce7d06d-d3f7-5e34-d23b-da1019f642a9}

We will now switch to using PKCS#11 and OpenSSL to create our certificate signing request.  PKCS#11 uses a concept of ‘slots’ that contain ‘tokens’.  We first need to find out what slot our card is in so we know how to refer to it later.  We can use ‘pkcs11-tool’ and the OpenSC PKCS#11 module to list the slots as follows:

[nkinder@localhost ~]$ pkcs11-tool --module /usr/lib64/opensc-pkcs11.so --list-slots
Available slots:
Slot 0 (0xffffffffffffffff): Virtual hotplug slot
  (empty)
Slot 1 (0x1): OMNIKEY AG CardMan 3121 00 00
  token label        : OpenSC Card (Nathan Kinder)
  token manufacturer : OpenSC Project
  token model        : PKCS#15
  token flags        : login required, PIN initialized, token initialized
  hardware version   : 0.0
  firmware version   : 0.0
  serial num         : 0C0A548021220815

We can see that slot ’1′ contains our card, and the previous command where we listed our keys shows that our private key as an ID of ’89015cc53f659f38d8ba2d2646b5b84c4be6820f’.  We need to use both of these pieces of information to refer to our private key in the next step, which is generating our certificate signing request.  To do this, we will use the ‘openssl’ utility along with it’s PKCS#11 engine, which will in turn use the OpenSC PKCS#11 module.  We can load the OpenSSL PKCS#11 engine and the OpenSC PKCS#11 module like this:

[nkinder@localhost ~]$ openssl
OpenSSL> engine dynamic -pre SO_PATH:/usr/lib64/openssl/engines/engine_pkcs11.so -pre ID:pkcs11 -pre LIST_ADD:1 -pre LOAD -pre MODULE_PATH:opensc-pkcs11.so
(dynamic) Dynamic engine loading support
[Success]: SO_PATH:/usr/lib64/openssl/engines/engine_pkcs11.so
[Success]: ID:pkcs11
[Success]: LIST_ADD:1
[Success]: LOAD
[Success]: MODULE_PATH:opensc-pkcs11.so
Loaded: (pkcs11) pkcs11 engine
OpenSSL>

We are at the OpenSSL prompt with our PKCS#11 module loaded, so we’re ready to generate the certificate signing request.  This is done by using the ‘req’ command as usual when using OpenSSL, but we have to tell the command to use the PKCS#11 engine and which key to use.  We use the slot number and private key ID we gathered in the previous steps and generate the request:

OpenSSL> req -engine pkcs11 -new -key slot_1-id_89015cc53f659f38d8ba2d2646b5b84c4be6820f -keyform engine -out /home/nkinder/card1.req -text
engine "pkcs11" set.
PKCS#11 token PIN: 
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:Nathan Kinder
Email Address []:nkinder@redhat.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

Our certificate signing request will now exist in the file we specified as the ‘-out’ option:

[nkinder@localhost ~]$ cat /home/nkinder/card1.req 
Certificate Request:
    Data:
        Version: 0 (0x0)
        Subject: C=XX, L=Default City, O=Default Company Ltd, CN=Nathan Kinder/emailAddress=nkinder@redhat.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (1024 bit)
                Modulus:
                    00:c2:a5:78:46:16:03:80:ff:41:86:59:92:2d:15:
                    ae:5b:ba:14:c1:fe:0a:3b:a4:f7:c1:18:24:6f:9f:
                    9d:79:7f:04:2a:80:85:a3:07:91:bb:a9:95:2d:2a:
                    df:01:ca:06:3f:5b:9d:a1:ac:e6:c2:83:1d:e9:c0:
                    d9:98:c8:8e:21:0b:e9:6d:e0:bd:b3:0b:ad:24:01:
                    ba:a7:c0:68:9f:17:4a:93:40:55:aa:10:fc:2e:17:
                    82:f1:25:3f:6b:6b:8d:6e:14:ce:0f:df:47:7f:48:
                    61:62:e5:ef:43:99:f5:7c:00:48:63:d8:54:65:8e:
                    57:bb:66:b0:b3:11:50:e0:55
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha1WithRSAEncryption
         37:6d:c9:32:d2:6c:45:e1:83:48:6c:b8:98:b1:29:ff:df:e5:
         e0:33:15:8f:34:38:d0:00:48:fb:70:44:03:ad:bb:b7:37:c3:
         84:90:91:aa:40:1b:47:61:35:4f:55:ed:84:34:15:20:fd:5d:
         fa:ec:60:2e:9e:b3:9a:23:cd:5d:94:47:56:f5:5f:77:51:9d:
         56:4b:94:a9:d2:a4:5d:83:e4:5c:34:95:23:df:7f:a9:45:58:
         44:1a:0e:87:9d:f4:e9:43:56:c8:38:58:a9:04:ff:7a:fd:28:
         a2:91:dd:16:5e:1d:13:d8:18:4d:9a:53:2b:66:0d:e6:02:be:
         4b:18
-----BEGIN CERTIFICATE REQUEST-----
MIIBvTCCASYCAQAwfTELMAkGA1UEBhMCWFgxFTATBgNVBAcMDERlZmF1bHQgQ2l0
eTEcMBoGA1UECgwTRGVmYXVsdCBDb21wYW55IEx0ZDEWMBQGA1UEAwwNTmF0aGFu
IEtpbmRlcjEhMB8GCSqGSIb3DQEJARYSbmtpbmRlckByZWRoYXQuY29tMIGfMA0G
CSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCpXhGFgOA/0GGWZItFa5buhTB/go7pPfB
GCRvn515fwQqgIWjB5G7qZUtKt8BygY/W52hrObCgx3pwNmYyI4hC+lt4L2zC60k
AbqnwGifF0qTQFWqEPwuF4LxJT9ra41uFM4P30d/SGFi5e9DmfV8AEhj2FRljle7
ZrCzEVDgVQIDAQABoAAwDQYJKoZIhvcNAQEFBQADgYEAN23JMtJsReGDSGy4mLEp
/9/l4DMVjzQ40ABI+3BEA627tzfDhJCRqkAbR2E1T1XthDQVIP1d+uxgLp6zmiPN
XZRHVvVfd1GdVkuUqdKkXYPkXDSVI99/qUVYRBoOh5306UNWyDhYqQT/ev0oopHd
Fl4dE9gYTZpTK2YN5gK+Sxg=
-----END CERTIFICATE REQUEST-----

This can be sent to your certificate authority as usual when requesting a certificate.  When you receive the signed certificate, it can then be loaded onto the card.  You will need to specify which private key this is associated with by specifying the PIN ID and the key ID:

[nkinder@localhost ~]$ pkcs15-init --store-certificate /home/nkinder/card1.pem --auth-id 01 --id 89015cc53f659f38d8ba2d2646b5b84c4be6820f --format pem
Using reader with a card: OMNIKEY AG CardMan 3121 00 00
Security officer PIN [Security Officer PIN] required.
Please enter Security officer PIN [Security Officer PIN]: 
User PIN [Nathan Kinder] required.
Please enter User PIN [Nathan Kinder]:

We can then confirm our certificate is on the card by printing it out:

[nkinder@localhost ~]$ pkcs15-tool --read-certificate 89015cc53f659f38d8ba2d2646b5b84c4be6820f
Using reader with a card: OMNIKEY AG CardMan 3121 00 00
-----BEGIN CERTIFICATE-----
MIIC2zCCAcMCAQwwDQYJKoZIhvcNAQEFBQAwbjELMAkGA1UEBhMCVVMxEzARBgNV
BAgMCkNhbGlmb3JuaWExFjAUBgNVBAcMDU1vdW50YWluIFZpZXcxGDAWBgNVBAoM
D05HS3MgQ2VydCBTaGFjazEYMBYGA1UEAwwPTkdLcyBDZXJ0IFNoYWNrMB4XDTE1
MDczMTAzMDI1NloXDTE2MDczMDAzMDI1NlowfTELMAkGA1UEBhMCWFgxFTATBgNV
BAcMDERlZmF1bHQgQ2l0eTEcMBoGA1UECgwTRGVmYXVsdCBDb21wYW55IEx0ZDEW
MBQGA1UEAwwNTmF0aGFuIEtpbmRlcjEhMB8GCSqGSIb3DQEJARYSbmtpbmRlckBy
ZWRoYXQuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCpXhGFgOA/0GG
WZItFa5buhTB/go7pPfBGCRvn515fwQqgIWjB5G7qZUtKt8BygY/W52hrObCgx3p
wNmYyI4hC+lt4L2zC60kAbqnwGifF0qTQFWqEPwuF4LxJT9ra41uFM4P30d/SGFi
5e9DmfV8AEhj2FRljle7ZrCzEVDgVQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQCO
1kKBM9E+E10vq/aG4GGdpMZj592zuk2Z/VOh8TKx9365bEpcO1szD0Zaoni9roUT
KFERSOQdQ85rDHnTelnhHOU1EI+nz2DOkCjJgG95GRgU3/MsbAOMWONAzD4y1zp8
VDZm0GcqjaP0UrEwqzGnV239/8PvkxUt10woIDLOpPXqgXdaUByCMYKjwSJpKAhH
3e3JE9G+0kVb/9uO19q73q7wN42+dbuUqLytukiXP0cyUo+iraTUk+UwqbP6kfos
ybR2irAiWYcGaxAmGTwjsFHHccFp87t54M9GJtT3bnu1mpoqFgnkASRbkSmPjHSs
amX5j3Jmkno0he8/aR1S
-----END CERTIFICATE-----

Our card is now fully personalized and is ready to be used by any application that supports PKCS#11.

In the next installment, we will show how the certificate authority in FreeIPA can be used to issue the user certificate that you put on your smart card, as well as how you can associate certificates from external certificate authorities with FreeIPA users.

by Nathan Kinder at July 31, 2015 03:33 AM
July 19, 2015
Pavel Reichl
Authenticate against cache in SSSD
What is the problem?

While querying information about users, groups, etc. via commands getent and id, which are internally calling NSS responder, is already optimized by usage of SSSD internal cache, on the contrary, authentication was always performed against server. Authentication against the network many times can cause an excessive application latency. Especially in environments with tens of thousands of users the login process may become inappropriately long when servers are running under high workload (e.g. during classes, when many users log in simultaneously). To handle such situations SSSD now supports cache authentication instead of authenticating directly against network server every time.
Solution

To address this problem new option cached_auth_timeout was introduced. This option specifies time in seconds since last successful on-line authentication for which the user will be authenticated using cached credentials while SSSD is in the on-line mode. By default cached_auth_timeout is set to 0 which implies that this feature is disabled.
In plain English it means that if cached_auth_timeout=900, then after successful on-line authentication all subsequent authentication attempts for next 15 minutes will be served from cache (at least all succesfull attempts; see special cases for details).
Setting the feature

Setting cached authentication is quite easy – just add cached_auth_timeout to the domain section and check that cache_credentials=true is also set in the domain section. Then restart SSSD and the feature should be working.
Example of configuration

[domain/domain.dev]
cache_credentials = True
krb5_store_password_if_offline = True
ipa_domain = domain.dev
id_provider = ipa
auth_provider = ipa
access_provider = ipa
ipa_hostname = client.domain.dev
chpass_provider = ipa
dyndns_update = True
ipa_server = ipa.domain.dev
ldap_tls_cacert = /etc/ipa/ca.crt
realmd_tags = manages-system
default_shell = /bin/bash
use_fully_qualified_names = True
fallback_homedir = /home/%d/%u
cached_auth_timeout = 150

[sssd]
services = nss, sudo, pam, ssh
config_file_version = 2

domains = domain.dev
[nss]
homedir_substring = /home

[pam]
# you might consider to uncomment this option to see more verbose output while authenticating
#pam_verbosity = 2

[sudo]

[autofs]

[ssh]

[pac]

[ifp]


Special cases

There are a few special cases I would like to briefly describe.
Password got changed locally

In this case subsequent login attempt is processed on-line and the new password is accepted while the old one is denied.
Password got change directly on server or via other client then SSSD

The new password is accepted and that logs inform that cached authentication failed and on-line authentication had to be performed (please note that old password would be accepted as the SSSD client has no knowledge that it was changed).
Entered password does not match the cached one

In this case on-line authentication is performed because it cannot be determined whether there was a typo in password or password was changed directly on server. Also checking on-line is a protection against potential password guessing attacks.
SSSD is in off-line mode

If SSSD is in off-line mode, then this feature is not used and SSSD behaves as usual.
Further reading

    SSSD manual pages
    Design page


by preichl at July 19, 2015 09:06 PM
July 17, 2015
Jakub Hrozek
Get rid of manually calling kinit with SSSD’s help

For quite some time, my laptop doesn’t have a UNIX /etc/passwd user for the account I normally use at all. Instead, I’ve used SSSD exclusively, logging in with our Red Hat corporate account. That allows me to use some cool SSSD features, most notably the krb5_store_password_if_offline option.

When that option is enabled and you log in while SSSD is offline (typically when a laptop was just started and is not connected to corporate VPN yet) using your cached password, SSSD stores the password you use to the kernel keyring. Then, when SSSD figures out that the servers are reachable, it attempts to kinit using that password on your behalf.

Because SSSD can detect when you connected to the VPN by listening to libnl events or watching resolv.conf for changes, the routine of connecting to Kerberos simplifies rapidly to:

    open laptop
    login using Kerberos password
    connect to VPN

That’s it. kinit happens on the background and Kerberos ticket is acquired without any user intervention. Now you can just start Firefox and start accessing HTML pages or start Thunderbird and read your mail. No more starting an extra terminal and typing kinit or starting a separate Gnome dialog.

However, until now, this setup required that you also use an account from a centralized store that contains the Kerberos principal as one of its attributes or at least has the same user name as the first part of the Kerberos principal (called primary, up to the ‘@’ sign). And that’s a deal breaker for many people who are used to a certain local user name for ages, irrespective of their company’s Kerberos principal.

SSSD 1.12.5 that was released recently includes a very nice new feature, that allows you to work around that and map a local UNIX user to a particular Kerberos principal. The setup includes a fairly simple sssd.conf file:

 [sssd]
 domains = example.com
 config_file_version = 2

 [domain/example.com]
 id_provider = proxy
 proxy_lib_name = files

 auth_provider = krb5
 krb5_server = kdc.example.com
 krb5_realm = EXAMPLE.COM
 krb5_map_user = jakub:jhrozek
 krb5_store_password_if_offline = True

 cache_credentials = True

All the interesting configuration is in the [domain] section. The identities are read from good old UNIX files by proxying nss_files through SSSD’s proxy provider. Authentication is performed using the krb5 provider, with a KDC server set to kdc.example.com and Kerberos realm EXAMPLE.COM

The krb5_map_user parameter represents new functionality. The parameter takes a form of username:primary and in this particular case maps a UNIX user jakub to a Kerberos principal which would in this case be jhrozek@EXAMPLE.COM.

On Fedora-22, care must be taken that the pam_sss.so module is called in the PAM stack even if pam_unix.so fails as the default behaviour for pam_unix.so is default=die – end the PAM conversation in case the user logging in exists in /etc/passwd and the password is incorrect. Which is our case, we’re logging in with UNIX user, we just want the authentication to be done by pam_sss.so.

Thanks to Sumit Bose who helped me figure out the PAM config, I used the following auth stack successfully:

auth     pam_env.so
auth     [default=2 success=ok] pam_localuser.so
auth     sufficient pam_unix.so nullok try_first_pass
auth     [success=done ignore=ignore default=die] pam_sss.so use_first_pass
auth     requisite pam_succeed_if.so uid >= 1000 quiet_success
auth     sufficient pam_sss.so forward_pass
auth     required pam_deny.so

I also recorded a video shows the feature in action. The first login is with the UNIX password, so the ticket is not automatically acquired and the user must run kinit manually. The next login happens with the Kerberos password while the machine is connected to network, so the ticket is acquired on login. Finally, the last login simulates the case where the machine starts disconnected from the network, then connects. In this case, SSSD acquires the ticket on the background when it detects the networking parameters have changed and the KDC is available.

Nice, right? You can also get the video in a nicer resolution.

The Kerberos authentication provider has more features that can beat using kinit from the command line – automatized ticket renewal might be one of them. Please refer to the sssd-krb5 manual page or share your tips in the comments section!

by jhrozek at July 17, 2015 02:56 PM
June 15, 2015
Rob Crittenden
Ipsilon and IPA

Ipsilon is an IdP that supports SAML 2.0. Here I’ll show how the IPA integration works to use IPA as the source of SSL certificates and how to use IPA as the identity backend to Ipsilon.

I have an existing IPA installation that I’ll use as the IPA master. For Ipsilon I’ve got two Openstack VM (1GB RAM, 10GB disk) running Fedora 22.
Install the IdP

Pick one and this is the IdP.  Install the Ipsilon server packages:

$ sudo dnf install ipsilon ipsilon-infosssd ipsilon-saml2 ipsilon-authgssapi ipsilon-tools-ipa freeipa-client --enablerepo=updates-testing

Enroll the machine as an IPA client:

$ sudo ipa-client-install

Install the Ipsilon IdP:

$ sudo kinit admin
$ sudo ipsilon-server-install --ipa=yes --info-sssd=yes --form=yes

Have IPA issue an SSL certificate for Apache:

$ sudo systemctl start certmonger
$ sudo ipa-getcert request -f /etc/pki/tls/certs/server.pem -k /etc/pki/tls/private/server.key -K HTTP/`hostname`

Configure Apache to use this certificate.

$ sudo  /etc/httpd/conf.d/ssl.conf

Modify SSLCertificateFile and SSLCertificateKeyFile to:

SSLCertificateFile /etc/pki/tls/certs/server.pem
SSLCertificateKeyFile /etc/pki/tls/private/server.key

Restart Apache:

$ sudo systemctl restart httpd

Note: As of today there is an SELinux issue preventing Apache from reading ipsilon.conf. I set it to permissive mode.

Test to see that SSL trust is working and the IdP is serving pages:

$ curl https://`hostname`/idp

Scan the output and you should see a link to /idp/login. If you do then it’s working.

Ok, let’s check it out for real now. Fire up a browser and head to https://idp/

You should see a form login. Login using the IPA admin and password. Woo, integration! If you want to really test it, log out, kinit as admin on the machine you launched the browser from (assuming it is an IPA client) and try again and you should get right in.
Install the Service Provider

Let’s a pause a moment and switch over to your other VM onto which we’ll install the Service Provider (SP). The process is similar.

Install the ipsilon and IPA client packages:

$ sudo dnf install ipsilon-client freeipa-client freeipa-admintools mod_ssl --enablerepo=updates-testing

Enroll as an IPA client:

$ sudo ipa-client-install

Install the Ipsilon SP:

$ sudo ipsilon-client-install --saml-idp-metadata https://ipsilon.example.com/idp/saml2/metadata --saml-auth /secure

Create an SSL certificate for the SP webserver:

$ sudo kinit admin
$ sudo ipa service-add HTTP/`hostname` --force
$ sudo ipa-getcert request -f /etc/pki/tls/certs/server.pem -k /etc/pki/tls/private/server.key -K HTTP/`hostname`

Configure Apache to use this certificate.

$ sudo  /etc/httpd/conf.d/ssl.conf

Modify SSLCertificateFile and SSLCertificateKeyFile to:

SSLCertificateFile /etc/pki/tls/certs/server.pem
SSLCertificateKeyFile /etc/pki/tls/private/server.key

Restart Apache:

$ sudo systemctl restart httpd

Register the SP

Now we need to register the SP with the IdP. To do this bring up your browser window we opened with the IdP and head to Administration -> Identity Providers -> saml2 -> Manage -> Add New

The name is not important, it is just a unique identifier for the IdP to reference the SP. I tend to use the hostname of the SP.

The metadata can be found on the SP in the filesystem in /etc/httpd/saml2/<fqdn>

For the metadata you can either:

    Download the metadata to the machine running the browser, select Browse, find the file and upload it.
    Provide the metadata via a URL (https://sp.example.com/saml2/metadata)
    Copy and paste the metadata

The resulting page is the configuration page for the SP. We can leave the defaults for now.
Configure the SP secure pages

Let’s create some secure content to serve on the SP.

$ sudo vi /var/www/html/secure/index.html

Add some content like:

<html><title>Secure</title>Hello there</html>

Now confirm that it requires authentication:

$ curl https://`hostname`/secure/

You should get back a 303 See Other response.

Now try this in your browser. You should be redirected to the IdP to authentication. Do so using the IPA admin credentials. After authenticating you should be redirected back to /secure on the SP and see the text “Hello there”. Success!
Test Logout

Modify the index.html we just created to include a link to

<a href="/saml2/logout?ReturnTo=https://sp.example.com/logged_out.html">Log out</a>

Create a logout landing point (note it is outside the secured area):

$ sudo vi /var/www/html/logged_out.html

with contents:

<html>
<title>Logout</title>
<p>
Congratulations, you've been logged out!
</p>
<p>
Now try to <a href="/secure/">log back in</a>
</p>
</html>

You can just refresh the secured page and you should have a Log out link.

Click that and you should see a logout message and a link to log back in. If you click that you will be asked to re-authenticate.

For further exercises, stand up another SP. You’ll find that once you authenticate to one SP you are allowed in with no authentication request on the other one. Similarly, logging out of one logs out of all.
Add more users

So far we’ve limited things to only the IPA admin user. Let’s add a regular IPA user and authenticate as them. On either the SP or the IdP run:

$ kinit admin
$ ipa user-add --first=Test --last=User tuser1 --password
Password: 
Enter Password again to verify:
$ kinit tuser1
Password for tuser1@EXAMPLE.COM: 
Password expired.  You must change it now.
Enter new password: 
Enter it again:

Now request /secure/ on the SP again and this time authenticate as tuser1. This will work for any IPA user.
Attribute Data

Ipsilon can configure what user information is visible to a given SP and can optionally rename some attributes (called mapping).

A broad way to see what is available is to use Server-Side Includes. Let’s play.

Enable SSI in Apache by editing /etc/httpd/conf.d/ipsilon-saml.conf and adding Options +Includes to the secure Location and a new output filter. It should look like:

    MellonEnable "auth"
    Header append Cache-Control "no-cache"
    Options +Includes

AddOutputFilter INCLUDES .html

Note that you wouldn’t want to do this in production, we’re just playing here.

Restart apache

$ sudo systemctl restart httpd

Configure your secure index.html to display the environment. Add this to the end of the file, before </html>:

<!--#printenv -->

The output is rather ugly, one very long line of output. We’re interested in those attributes prefixed with MELLON_. In my case it is:

MELLON_NAME_ID=tuser1 MELLON_NAME_ID_0=tuser1 MELLON_surname=User MELLON_surname_0=User MELLON_groups=ipausers MELLON_groups_0=ipausers MELLON_givenname=Test MELLON_givenname_0=Test MELLON_fullname=Test User MELLON_fullname_0=Test User MELLON_email=tuser1@greyoak.com MELLON_email_0=tuser1@greyoak.com MELLON_IDP=https://ipsilon.greyoak.com/idp/saml2/metadata MELLON_IDP_0=https://ipsilon.greyoak.com/idp/saml2/metadata 

When we installed Ipsilon we enabled the SSSD info plugin. This controls what information is retrieved by SSSD from IPA when a user authenticates. Ipsilon is configured to retrieve the LDAP attributes mail, street, locality, postalCode, telephoneNumber, givenname and surname. We don’t see any address information here because we didn’t configure it for the user, let’s do that now.

$ ipa user-mod --street="123 Main" --city=Baltimore --postalcode=21234 tuser1

Log out of the SP and log back in and you should now have MELLON_ variables for street, state and postalcode.

If you’re wondering why there are _0 versions of these as well it is a mechanism to support multi-valued attributes.

by rcritten at June 15, 2015 06:28 PM
June 04, 2015
Red Hat Blog
Identity Management and Two-Factor Authentication Using One-Time Passwords

Two-factor authentication, or 2FA, is not something new. It has existed for quite some time and in different forms. What is a ‘factor’? A factor is something you have, something you know, or something you are. For example, if we combine a PIN that you know, with your fingerprint, we get a 2FA based on biometrics. In practice, biometric solutions are not often used because it’s not especially difficult to steal someone’s fingerprint (…and it is quite hard to revoke or replace your finger). The more practical approach to two-factor authentication is to combine something you know, a PIN or password, with something you have.

Something you have often comes in form of a device. It can be a device that you already have, for example a phone or tablet, or a device that is given to you, for example a smart card or a token. The device-based 2FA comes in two main flavors, namely: certificate based or one-time-password (OTP) based. The certificate based authentication leverages a smart card as a device. A smart card is effectively a password protected memory card with a secret (or secrets) stored on the it. You insert the card into a card reader and use your PIN to unlock the card. The PIN is used to decrypt the card’s contents – allowing client side software (on the computer) to interact with the secret (or secrets) via a specific API.

An alternative to the smart card approach is OTP. This is a random password that is valid for a short period of time (usually 30 or 60 seconds). If you use a hardware token, a special device dedicated to generating the passwords (codes), the device will have a display that would show you a code. It is usually a numeric code of 6 or 8 digits (though different other devices exist). If you prefer to use an existing device (e.g. a phone) you can put an application on it that will generate a one time code for you to use for authentication. Such an application is called a “software token”. There are multiple vendors that build software token applications for mobile devices. The most well known one is Google Authenticator (GA). GA was built using open source and open source authentication standards – making it highly inter-operable and attractive to use. Unfortunately, Google made a decision to close source for Google Authenticator. Red Hat, being an open source company, decided to sponsor an alternative compatible open source implementation called FreeOTP. You can find this app in Apple App Store (here)  and in Google Play (here). What’s nice about FreeOTP being open source is that you have a direct contact to people behind the project. If you see an issue or a problem you can not only write a review but you can go one step further and interact with developers via a project list freeipa-devel@lists.fedorahosted.org and provide feedback as well as propose improvements.

The passwords (codes) that are generated by these tokens are random. But to be able to authenticate – the server should be able to generate the same code and be able to match it. To be able to do so the server, and the token, need to share the following factors:

    they need to support the same algorithm (i.e. the logic of how to generate the codes)
    they need to share the secret that is used as a seed for the random number generation algorithm
    they need to share some other factor that changes all the time… such a factor is usually either UTC time or a count of number of times the token has ever displayed a code

The tokens that use time are, unsurprisingly, called time-based tokens and the tokens that use count are called event-based tokens (because they display a code only when requested).

During the authentication the user combines their PIN (or password) with the code on the token and send it to the server. The server, knowing the PIN, seed, and time (or count) can generate the code it expects and will attempt to match this expected value to the data as entered by the user. As we don’t live in a perfect world… there are times where the count or time gets out of sync. To compensate for such ‘drift’ the server generates more then one code. The number of codes it tries is usually configurable. This is called a token window. The bigger the window – the more codes the server will generate and try. This reduces the security of the solution so defining a wide window is generally a bad security practice. Sometimes the token gets out of sync so much that no codes match. In this case the user needs to re-synchronize the token by providing first the PIN and a code and then another code generated by his or her token. The server, in this case, determines the drift, records it, and factors it in next time the token is used.

An important step in preparing a 2FA solution is the provisioning of the tokens to users. During provisioning, the token seed on both sides is ensured to be the same. Software tokens are provisioned by generating a random code and passing it to the device the token will reside on. The hardware tokens are usually arrive pre-seeded so the seeds come in a data file and need to be loaded into the server. Some hardware tokens can be connected to the server and exchanged with server to establish a shared secret seed.

Identity Management and OTP

Starting with Red Hat Enterprise Linux 7.1 the Identity Management server is capable of performing two-factor authentication. This is the first commercially available domain controller that implements integration of 2FA with Kerberos. What does this mean? Previously, any integration between two-factor authentication and a domain controller required two steps: first, a user authenticated using his or her 2FA and then the user supplied password was used to authenticate and get a Kerberos ticket so that the user could take advantage of SSO between different services in a domain. The weak point of this solution is that there is always a single factor used to get a Kerberos ticket. IdM eliminates this problem by integrating 2FA into its Kerberos and LDAP services. Users can authenticate with two factors and get a Kerberos ticket as a result of such authentication in one step. The same authentication policies apply whether a user authenticates using Kerberos or LDAP.

In fact, IdM implements two variants of 2FA. The first variant leverages both hardware and software tokens managed within the IdM server. A user in IdM, by default, can authenticate using a single factor – their password. Administrators can enable a subset of users for OTP authentication. This means that a user in addition to his or her password would need to enter a token code from a token. Until there are no tokens assigned to the user the user will continue authenticating with their password, but once the user enrolls a hardware token or provisions a software token he or she would be required to provide both a password and a code as displayed on the token. Provisioning of a software token is initiated by a user via a self-service page. There is no limit on how many tokens can be added to the user but users must have at least one token until an administrator flips the switch and disables the OTP authentication requirement for this user. Such an approach allows a simple and smooth transition from a single factor authentication environment to 2FA without any extra overhead for users. In many cases administrators elect to setup self-service portals to allow a simple way to deploy software tokens to mobile devices. The user clicks a button and a QR code with token information is generated and displayed on their screen. This QR code can be scanned by the FreeOTP or GA application on their mobile device. Once scanned, the token will appear on your device. It is not recommended to try to use the same token from different devices as the QR code will not be displayed again. It is easy to delete the token and deploy it again or to add another token for another device.

Rounding out this exploration of 2FA – it is expected that IdM will be deployed in the environments where a 2FA is already provided by other vendors. In this case IdM can take advantage of the existing 2FA solution. All 2FA servers provide a capability to authenticate using the RADIUS protocol. IdM administrators can configure IdM as a client to one or more RADIUS servers. An authentication policy for a user can be set to use a specific RADIUS server. Once the policy is set to use RADIUS for a user, IdM would ignore user passwords or tokens and proxy user credentials to a particular RADIUS server. Once it gets the response from the RADIUS server, if authentication was successful, it will reply to its client with a Kerberos ticket. Otherwise it will deny user access. This proxy approach allows a simple and gradual migration from the 3rd party solution to an IdM based solution. Such migration might be considered because of IdM’s unique Kerberos integration capability and the cost of the solution. 3Rd party solutions are traditionally quite expensive. In case of Red Hat, FreeOTP is a free application and IdM is available free of charge as a part of your Red Hat Enterprise Linux subscription.

Cheers if you’ve read all the way to here – today’s post was a long one.  That said, if there’s something additional you’d like to learn about 2FA, IdM, one-time passwords, or anything else that was covered in this post – as always, don’t hesitate to reach out.

by Dmitri Pal at June 04, 2015 10:15 PM
June 02, 2015
Red Hat Blog
Identity Management and Certificates

Identity Management (IdM) in Red Hat Enterprise Linux includes an optional Certificate Authority (CA) component. This CA is the same CA included with the Red Hat Certificate System (RHCS). If they’re the same, what is the relationship between IdM and RHCS? Is there a secret plan to replace one with another? This post reviews some of the details associated with each of the offerings and explores different use cases – indicating where you might choose to use one solution over the other.

As explained in my previous post, IdM is a component of Red Hat Enterprise Linux; it is included as a part of your subscription. In a nutshell – IdM focuses on managing identities within the enterprise. Currently, as mentioned above, IdM includes a CA component that is derived from the same community project (Dogtag) as is RHCS.

RHCS, on the other hand, is a product (…and is not included as part of your Red Hat Enterprise Linux subscription). RHCS includes all of the components that are available in the Dogtag community project.

As IdM does not include all of the components available in Dogtag, IdM certificate related capabilities are currently limited. While IdM does issue certificates for hosts and services, it does not issue certificates for users, devices or client side certificates for services connecting to other services. Moreover, IdM cannot manage user smart cards or escrow keys. If you are interested in what may be coming (down the road) and/or if you want to help the community to move new features forward – check out www.FreeIPA.org and related the mailing lists.

In theory, IdM will incorporate additional components from the Dogtag project over time. Does this mean that RHCS will become obsolete? Will it essentially be replaced by IdM? The answer is most likely: no, and the main reason is scope. IdM deals with identities related to the enterprise. These identities belong to the same organization (i.e. they share a single namespace). All certificate operations in IdM are generally related to the identities operating within this namespace. In a sense, this is a controlled environment bound to the same Kerberos domain IdM servers.

On the flip side, RHCS is not bound by namespace. One RHCS deployment can issue certificates for users, devices, and services that are completely unrelated to each other. If, for example, you are considering the provision of certificates as a service – RHCS may be a good server to build your solution around. If, for example, you need to issue and manage certificates for entities operating within the enterprise then IdM would likely be a better choice. That said, RHCS could be used to manage enterprise identities if there is a need to issue certificates not only for internal identities but for external identities (e.g. customer / partners) as well.

In many scenarios, it actually might make sense to consider using both RHCS (as a root CA in the enterprise) and IdM (as a subordinate CA for the internal identities).

As can be seen, though there are a number of similarities, the use case for each solution is quite different and thus there is little sense in merging the offerings or eliminating one altogether… at least for now. Looking ahead, there is an option to offer most of the RHCS capabilities including serving different certificates for different purposes as an extension to IdM if we are able to figure out how to control namespaces within IdM. This will be a lot of work… but it is possible… and might be an approach that we would consider down the road.

by Dmitri Pal at June 02, 2015 09:13 PM
June 01, 2015
Red Hat Blog
Identity Management or Red Hat Directory Server – Which One Should I Use?

In the identity management server space Red Hat has two offerings: Identity Management (IdM) in Red Hat Enterprise Linux and Red Hat Directory Server (RHDS). This article is dedicated to helping you understand why there are two solutions and how to chose the best one for your environment.

Before diving in too deep it might be wise to more formally define IdM and RHDS. IdM is a domain controller, its main purpose is to manage identities within the enterprise. It is a component of Red Hat Enterprise Linux and is made available at no extra charge (i.e. it’s included with all Red Hat Enterprise Linux server subscriptions). RHDS, on the other hand, is a fully functional directory server. It is a tool for building your business applications and, unlike IdM, it is its own product and has its own price tag.

You might be asking yourself – can I use a generic directory server like RHDS as a central server for enterprise identities? If yes, would I want to? The answer: yes, you most certainly can use RHDS as a central server for enterprise identities. In fact, this is exactly what many companies have been doing for years (…long before IdM was “born”). That said, IdM has a lot of features and capabilities that are either completely absent in the pure DS solution or require a lot of custom development. This makes IdM interesting but different. Also, IdM is implemented following best practices that have emerged from experience with DS based deployments. Because of this IdM does some things differently as compared to DS based custom solutions. These differences can make moving from a DS solution to an IdM based solution a bit harder even if the benefits of IdM are acknowledged. For deployments that have a directory server and are not ready to change from the DS approach to IdM – RHDS is a good option.

Management of enterprise identities aside, another major area where identity management is of great importance is business applications. For example, let’s pretend your company provides an online service that customers pay for. For applications of this nature you usually need a place to store customer account information and authentication credentials. Traditionally, Directory Servers were the best technology for this task. Choosing RHDS as a back-end for your business application is thus a logical choice.

Could IdM be used in such cases (i.e. for identity management of business applications)? Probably… but maybe not. Business applications usually require a lot of customization of the directory server structure called schema. While changing schema for a DS is normal / fully expected, changing schema for IdM should be done carefully and following the specific rules. Why the caution? The reason is that IdM includes different components that are expected to work together. These components make a series of assumptions about data structures… so changes to IdM schema might inadvertently cause one or more of these components to fail. IdM was built with flexibility in mind and is not totally locked down. One can safely make changes to the IdM schema but only following specific rules as described/outlined in the FreeIPA project.

The considerations above lead to the following summary:

    Use IdM if you want to explore the power of the centralized identity management within your enterprise.
    Use RHDS if you are building a business application and need an LDAP back-end or if you have been using a directory server to manage your enterprise identities and are not yet ready to switch to a different technology.

Stay tuned as I plan to explore certificates in my next entry. Until then – feel free to reach out using the comments section below.

by Dmitri Pal at June 01, 2015 05:25 PM
May 28, 2015
Alexander Bokovoy
Talking to FreeIPA API with sessions and JSON-RPC

Occasionally I see questions on how to drive FreeIPA programmatically. One can use ipa <command> from enrolled IPA clients or go directly to Python API (as /usr/sbin/ipa utility is just a tiny shim over the Python API). However, if you want to drive operations from other frameworks or from non-IPA clients, there is another way and it is actually very simple.

FreeIPA web UI is one example of such use. It is a JavaScript-based application which is downloaded by the browser when visiting IPA web site. The application bootstraps itself and issues JSON-RPC requests to the server. Browser does authentication and caching via cookies.

Surely, we can achieve the same from any other framework. There are two separate stages we’d have to go through to avoid constant re-authentication: . Authenticate against IPA server and remember the cookie for our session . Use cookie with session data while issuing our commands

There are separate authentication end points in IPA, one for Kerberos and another for password-based authentication. Both return a session cookie which we need to store and present to the server. If cookie is invalid, authentication need to be repeated again. This flow is well-known to any web application developer so no surprises here.
FreeIPA RPC expectations

In order to support secure web application development, FreeIPA web API expects web applications set HTTP referer back to the IPA host. Web browsers do this automatically, other frameworks have to provide it explicitly.

For example, with curl you’d need to specify -H referer:https://$IPAHOSTNAME/ipa.
Kerberos authentication

To authenticate with Kerberos, post an authorization request using Negotiate scheme over HTTPS to the end point at https://$IPAHOSTNAME/ipa/session/login_kerberos. You need to have actual credentials in your credentials cache (ccache) prior to sending the request. The way Kerberos authentication is done, one obtains a ticket granting ticket (TGT) first, storing it in a ccache and then an application can request a ticket to a service using existing TGT. A typical non-interactive use is when ccache is initialized with the TGT based on pre-existing key from a service keytab:

$ export KRB5CCNAME=FILE:/path/to/ccache
$ export COOKIEJAR=/path/to/my.cookie
$ export IPAHOSTNAME=ipa-master.example.com
$ kinit -k -t /path/to/service.keytab service/ipa-client.example.com
$ curl -v  \
        -H referer:https://$IPAHOSTNAME/ipa  \
        -c $COOKIEJAR -b $COOKIEJAR \
        --cacert /etc/ipa/ca.crt  \
        --negotiate -u : \
        -X POST \
        https://$IPAHOSTNAME/ipa/session/login_kerberos

If authentication was successful, our $COOKIEJAR file will contain all session cookies returned by FreeIPA web server. We don’t need to authenticate anymore until the session expires. All we need to do is to ensure we pass back the session cookies back to the server.
Password Authentication

Password authentication is more traditional: post over HTTPS a form with username and password fields to the end point at https://$IPAHOSTNAME/ipa/session/login_password. A form has to be setup with appropriate MIME type, application/x-www-form-urlencoded but the rest is plain old HTTPS post.

$ export COOKIEJAR=/path/to/my.cookie
$ export IPAHOSTNAME=ipa-master.example.com
$ s_username=admin s_password=mYSecReT1P2 curl -v  \
        -H referer:https://$IPAHOSTNAME/ipa  \
        -H "Content-Type:application/x-www-form-urlencoded" \
        -H "Accept:text/plain"\
        -c $COOKIEJAR -b $COOKIEJAR \
        --cacert /etc/ipa/ca.crt  \
        --data "user=$s_username&password=$s_password" \
        -X POST \
        https://$IPAHOSTNAME/ipa/session/login_password

If authentication was successful, our $COOKIEJAR file will contain all session cookies returned by FreeIPA web server. We don’t need to authenticate anymore until the session expires. All we need to do is to ensure we pass back the session cookies back to the server.
Sending JSON-RPC request

A session-based request needs to be posted to https://$IPAHOSTNAME/ipa/session/json end point over HTTPS. A content type should set to application/json and HTTP POST method has to be used. There isn’t any difference, again, from a typical JSON-RPC. Session cookies should not be forgotten, of course, or our request will fail spectacular.

FreeIPA JSON-RPC interface is not documented. However, it is easy to discover via existing command line utility, /usr/sbin/ipa by supplying -vv option to it:

$ ipa -vv ping
ipa: INFO: trying https://ipa-master.example.com/ipa/session/json
ipa: INFO: Forwarding 'ping' to json server 'https://ipa-master.example.com/ipa/session/json'
ipa: INFO: Request: {
    "id": 0,
    "method": "ping",
    "params": [
        [],
        {
            "version": "2.117"
        }
    ]
}
ipa: INFO: Response: {
    "error": null,
    "id": 0,
    "principal": "admin@EXAMPLE.COM",
    "result": {
        "summary": "IPA server version 4.1.99.201505121153GITed639c7. API version 2.117"
    },
    "version": "4.1.99.201505121153GITed639c7"
}
-------------------------------------------------------------------
IPA server version 4.1.99.201505121153GITed639c7. API version 2.117
-------------------------------------------------------------------

Each request has a method and parameters, params structure. A method is a command to execute. Commands of /usr/sbin/ipa utility have simple structure of topic-action and methods corresponding for them are topic_action, i.e. dash is replaced by underscore. This is because they map one to one to Python API classes.

Structure of parameters is simple too. params is an array of two elements: . an array of positional arguments, and . a dictionary of options

As can be seen above, ping method does not have positional arguments and IPA command line client always sends own version as an option.

Another example is user-show with --raw option passed:

$ ipa -vv user-show admin --raw
ipa: INFO: trying https://ipa-master.example.com/ipa/session/json
ipa: INFO: Forwarding 'user_show' to json server 'https://ipa-master.example.com/ipa/session/json'
ipa: INFO: Request: {
    "id": 0,
    "method": "user_show",
    "params": [
        [
            "admin"
        ],
        {
            "all": false,
            "no_members": false,
            "raw": true,
            "rights": false,
            "version": "2.117"
        }
    ]
}
[.... lots of output ....]

The resulting entry output is skipped for brevity.
Gathering things together

Finally, a script below combines both password and Kerberos authentication and then sends user_find request to receive list of all users.

# testcurl.sh
s_username=admin
s_password=mYSecReT1P2
IPAHOSTNAME=ipa-master.example.com
COOKIEJAR=my.cookie.jar
#rm -f $COOKIEJAR

klist -s
use_kerberos=$?

if [ ! -f $COOKIEJAR ] ; then
 if [ $use_kerberos -eq 0 ] ; then
        # Login with Kerberos
        curl -v  \
        -H referer:https://$IPAHOSTNAME/ipa  \
        -c $COOKIEJAR -b $COOKIEJAR \
        --cacert /etc/ipa/ca.crt  \
        --negotiate -u : \
        -X POST \
        https://$IPAHOSTNAME/ipa/session/login_kerberos
  else
        # Login with user name and password
        curl -v  \
        -H referer:https://$IPAHOSTNAME/ipa  \
        -H "Content-Type:application/x-www-form-urlencoded" \
        -H "Accept:text/plain"\
        -c $COOKIEJAR -b $COOKIEJAR \
        --cacert /etc/ipa/ca.crt  \
        --data "user=$s_username&password=$s_password" \
        -X POST \
        https://$IPAHOSTNAME/ipa/session/login_password
  fi
fi

# Send user_find method request
curl -v  \
	-H referer:https://$IPAHOSTNAME/ipa  \
        -H "Content-Type:application/json" \
        -H "Accept:applicaton/json"\
        -c $COOKIEJAR -b $COOKIEJAR \
        --cacert /etc/ipa/ca.crt  \
        -d  '{"method":"user_find","params":[[""],{}],"id":0}' \
        -X POST \
        https://$IPAHOSTNAME/ipa/session/json

Using JSON-RPC calls on non-IPA clients

If FreeIPA JSON-RPC API needs to be access from non-enrolled client, there is a bit more work. Kerberos authentication would most likely require properly configured /etc/krb5.conf. Luckily, the configuration can be copied over from existing IPA client and placed somewhere — Kerberos library allows to specify configuration file via KRB5_CONFIG environmental variable. A keytab can be copied over too but make sure to store it securely.

Another thing to copy over to a non-IPA client is a CA root certificate to allow secure HTTPS communication. Other than that, everything stays the same — authenticate first, store session cookies, and re-use them.

May 28, 2015 07:07 PM
May 27, 2015
Red Hat Blog
Direct, or Indirect, that is the Question…

In my last post I reviewed some of my observations from the RSA Security Conference. As mentioned, I enjoyed the opportunity to speak with conference attendees about Red Hat’s Identity Management (IdM) offerings. That said, I was quick to note that whether I’m out-and-about staffing an event or “back home” answering e-mails – one of the most frequently asked questions I receive goes something like this: “…I’m roughly familiar with both direct and indirect integration options… and I’ve read some of the respective ‘pros’ and ‘cons’… but I’m still not sure which approach to use… what should I do?” If you’ve ever asked a similar question – I have some good news – today’s post will help you to determine which option aligns best with your current (and future) needs.

Beyond differences in functionality, there are several factors that might affect your ultimate decision, namely:

    Size of the deployment
    Deployment growth expectations
    Deployment dynamics
    Compliance and policies
    Organizational structure
    Costs

The following recommendations assume that your functional use cases can be addressed by different approaches.  If this is not the case, and you have a feature that is a show stopper, then such a feature would likely eliminate some of the options from consideration.

Size of the Deployment

If you manage just a handful of systems that you need to connect to Active Directory (AD), indirect integration will most likely include some unnecessary overhead. Alternatively, at the other end of the spectrum, if you have many systems, management without central tools will be a challenge. In this latter case, we recommend using the indirect approach (leveraging IdM) as it provides centralized management capabilities for both Linux and UNIX systems.  Generally, we draw the boundary at around 30-50 systems – less than this number and indirect integration is likely not worth it – more than this number and you’ll likely benefit from the centralization of management capabilities.

Deployment Growth Expectations

If you anticipate slow growth of your environment over time then jumping into indirect integration might be premature.  If, on the other hand, you are building / designing for rapid growth, it might make sense to consider indirect integration with IdM from the beginning.

Deployment Dynamics

If you deploy systems rarely and, more often than not, they are bare metal systems, then direct integration might be the simplest and easiest solution.  If, however, your systems are virtual and/or are provisioned on-demand, then (adopting indirect integration and) having a central server that can manage these systems dynamically and “play well” with orchestration tools like Red Hat Satellite is likely your best bet.

Compliance and Policies

Policies tend to always win over other arguments and reasons… so, if your policy says that everything should be integrated into AD… then this is the way to go.  However, it does not necessarily mean that the direct solution is the only solution.  If, for example, you use trusts with IdM, the users accessing Linux systems actually do authenticate against AD.  This means that policies that exist in AD are executed and enforced during authentication.  You can check an audit trail on the AD server to get the proof of the authentication.  This also means that any of the audit software that you may have already invested in is likely still relevant.

Organizational Structure

If there is one team that manages Windows and Linux systems and expertise on the team is diverse then other factors (outside of organizational structure) should shape your choice.  On the other hand, if there are different teams (e.g. one for Windows and one for Linux), then indirect integration likely better aligns with your organizational structure and the respective skill sets of your teams.

Last But Not Least… Costs

Costs usually fall into one or more “buckets”:

    Software costs – costs for the software licenses or subscriptions.  If you go with a third party solution and direct integration, your costs will most likely be high. With indirect integration using IdM your costs will be calculated as a cost of your subscription multiplied by number of IdM servers you plan to deploy (…and will likely be lower).
    Deployment costs – there can be a lot in this bucket. Costs in this category might include: time you spend evaluating an approach, costs associated with the use of third party consultants and/or any other professional services you choose to employ to complete a deployment, training costs you may need for your teams, and (any other) time required to develop the means to deploy your chosen solution in an automated and controlled fashion. These costs are nearly always specific to your environment so it is hard to estimate them… but they can have a significant impact on your decision.
    Cost to use – after the solution is deployed it will (obviously) need to be supported and maintained. You will pay for the solution with time and resources. This means that the efficiency of the chosen solution is an important factor. If an administrator can do twice as many tasks using one approach as he or she could do using the other, there is a clear cost savings right there. Often times deployment can take months… but the solution is used for years. If the solution gives you a convenient way to mange your environment, even if the initial deployment costs might be higher, you might win over time.

In review, there are several factors that may influence your decision to adopt direct or indirect integration. We (at Red Hat) believe that IdM is the way to go as it combines a lot of value with moderate costs. That said, it is always worthwhile for you to decide what is best and most convenient for your own particular environment. If you’re stuck – feel free to reach out using the comments section below or to learn more by visiting freeipa.org.

by Dmitri Pal at May 27, 2015 07:53 PM
May 26, 2015
Red Hat Blog
RSA Security Conference 2015 in Review: Three Observations

As many specialists in the security world know – the RSA Security Conference is one of the biggest security conferences in North America. This year it was once again held in San Francisco at the Moscone Center. Every year the conference gets bigger and bigger, bringing in more and more people and companies from all over the world.

If you attended – you may have noticed that Red Hat had a booth this year. Located in the corner of the main expo floor (not far from some of the “big guys” like: IBM, Microsoft, EMC, CA Technologies, and Oracle) we were in a great location – receiving no shortage of traffic.  In fact, despite staffing the booth with six Red Hatters we didn’t have any “down time” –  everyone seemed to be interested in what Red Hat has to offer in security.

Over the course of the conference I made a few interesting observations…

More than Just Linux

While many conference attendees know about Red Hat in general and Linux in particular – most were not familiar with our whole portfolio of products.  Many perceived Red Hat solely as “the Linux vendor” and nothing more. People at the conference were pleasantly surprised to hear that the Red Hat portfolio includes the whole stack as shown in the picture below:

Security_IdentityBooth Size Does Not Correlate to Quality or Competitiveness of Offering

Many conference attendees were surprised by the small size of our booth. Well, as mentioned above, what they might not have realized is that Red Hat brings the whole stack to the table. It has security and identity management products and projects but they are just a fundamental part of a bigger picture – not something that Red Hat sees as stand-alone products or opportunities to compete with other security vendors.

Actually, what we do is more “matter of fact” security.  Nevertheless, we were proud to answer the question; “Red Hat? So what are you showcasing here?” with a good story about our Identity Management (IdM) offerings (based on the FreeIPA and SSSD open source technologies).

The fact that these security features are delivered as components of Red Hat Enterprise Linux without extra charge was a surprising fact to many. The functionality provided by Identity Management (IdM) is competitive in the market as it combines a whole slew of authentication, authorization, privilege escalation, and single-sign-on capabilities that few other vendors can offer in the operating system.

On one side IdM “speaks” native protocols and acts as a central authority for Linux and UNIX clients.  On the other it is a gateway between Linux/UNIX environments and Windows-based Active Directory-centric parts of the infrastructure. Many attendees, after hearing about our built-in capabilities, found our identity management an attractive, low cost identity management solution.

Interest Unbound

I mentioned the high level of booth traffic we received… this led to us to having many conversations with all kinds of people. At some times all of us were engaged in a conversation at once, and we were frequently involved with more than one person at a time. It was a pleasure to see how the lights were turning on in the eyes of visitors when they realized what kinds of opportunities our Identity Management technologies could bring to their environment; including, but not limited to, streamlining their infrastructure, cutting costs, and making it easier to support compliance.

At the end of the day, the RSA Security Conference 2015 was time well spent. Red Hat received a lot of positive feedback about our software, validated our strategic direction, and established a number of new contacts and partnerships.

I am really looking forward to going again next year.  In the meantime, if you have questions or comments about Red Hat’s IdM offering – don’t hesitate to reach out using the comments section below.

by Dmitri Pal at May 26, 2015 12:30 PM
May 23, 2015
Alexander Bokovoy
SambaXP 2015 travel report

I’ve attended annual SambaXP conference on May 19th-21st. I’ve presented about FreeIPA ID Views and this year we also had quite a few Red Hat’s talks in the program so that organizers even made a ‘Red Hat track’ on the last day, with all speakers in that track coming with a Shadowman.

SambaXP is a conference run by SerNet GmbH in Goettingen, Lower Saxony, Germany. SerNet is one of core contributors to Samba project, organized by, among others, Volker Lendecke who is founder of Samba project along with Andrew Tridgell and Jeremy Allison.

The conference is well attended; Microsoft is both sponsoring and sending participants for last six or more years — including key managers and developers of Windows Server and SMB protocols stack.

The conference itself is spanning two days. However, the day before the official start there are workshops and tutorials. A tutorial by Stefan Kania was dedicated to the Samba 4 migration experience. Tutorials and workshops are paid-for events, as well as the conference itself, but very valuable to all attendees.

This year we had protocols interop event on the ‘minus one’ day where Microsoft team ran a number of detailed presentations about changes in SMB protocol coming with SMB 3.1.1 specification and Windows 10, Windows Server 2016. Enhancements in SMB 3.1.1 clearly point to the direction of running HyperV workloads directly over SMB protocol in the cloud. There are multiple extensions to allow to map HyperV semantics for serving large volumes of VMs off scale out file systems. Another area of improvements in SMB 3.1.1 is related to getting security tightened to the point of forcing pre-authentication integrity. This is a continuation of a more general effort publicized by Microsoft to ‘get rid of passwords’ for Windows 10. More on SMB 3.1.1 extensions can be read in the Jose Barreto’s blog.

Another part of the protocols interop event was familiarizing with Microsoft’s Protocol Test Suite. The suite is available already from MSDN and is important part of validating correctness of implementations because its tests are generated out of the actual specifications. A hint was given on some positive news to be expected in June in time for Interop Plugfest (June 20-25th) in Redmond with regards to the suite itself but already now there is a change as running the Protocol Test Suite does not require having access to Visual Studio anymore.

SMB 3.1.1 pre-authentication integrity makes harder to analyze traffic. Microsoft decided to use ETW tracing facilities available since Windows 7 which produce a log output of the internal SMB code just before encrypting packets and handing them over to NDIS layer. ETW tracing format is then possible to load into Message Analyzer and watch both encrypted and unencrypted content side to side. We’ve been told ETW tracing also contains debugging output from SMB routines otherwise not seen at all. This feature does not require installing additional software and one can run analysis on a different machine than the trace was obtained.

It would be interesting to add support of reading ETW traces to Wireshark. With PCAPNG format its is possible to associate comments and ‘notes’ with the networking packets so having both ETW and NDIS level traces in the same capture is certainly possible.

Continuing Microsoft tune, Tom Talpey, Microsoft’s architect in File Server team, also demonstrated the performance improvements with SMB 3.1.1, storage quality of service additions, and laid out the problem space with newer memory types like persistent and phase memory. For next step of this work at SDC conference in September, Tom promised ‘paradigm changes in the protocol’.

More on SMB 3 and HyperV integration can be found in this post of links by Jose Barreto.

A final note on Microsoft’s take is that they want to outlaw SMB1 protocol. When this finally will happen, is unclear, but there is huge incentive to move away from NTLMSSP variants and anonymous data access. This will in particular affect RHEL 6 after 2016-2018, especially in the area of domain controllers because Windows Server 2016 at some point will move to drop SMB1 communication between the DCs. A more detailed overview of plans is available in this blog post. These changes should not be taken with a light heart — majority of consumer NAS devices use SMB1 protocol and force anonymous access by default.

Jeremy Allison also made a loud rant about how we deliver media from these NAS devices to our screens. All Smart TVs, he said, now run Linux. It means they are SMB clients or can be made so with relative ease. SMB3 as a protocol is perfect on low latency high throughput often needed for streaming media. He wants to work with TV manufacturers and turn DLNA from HTTP to SMB media serving.

The keynote by Marc Muehlfeld (Samba Team) gave us results of a survey of Samba community. The presentation is available at Samba site. More than 50% of respondents run Samba 4.x, with ~38% on Samba 3.6 — the version which is not supported by upstream anymore. About 60% of respondents are planning to migrate to Samba AD in next two years, with 25% are targeting the upcoming half a year, so migration seem to happen naturally. Samba AD is not an easy feat, most of responses mention that majority of issues they experienced are in Authentication (44%), File Serving (30%), and Active Directory backend (28%). While issues is what typically makes us in infrastructure world visible to upper management, it was interesting to see that 15% of respondents never experienced any issues.

One of defining topics for this year SambaXP is cloud. We had two separate talks on SMB in the cloud from Google and SuSE Linux, clear message on cloud readiness of the SMB protocol from Microsoft (they now have a separate implementation of SMB protocol for Azure cloud, tuned for cloud-specific workloads). Majority of talks during the first day were related to clustering and high availability (IBM, Red Hat, Nutanix) as well.

Red Hat’s talks also centered on using libraries provided by Samba project in other solutions. SSSD is building on talloc, tevent, ldb, and tdb as key components on our identity management client-side solution. We also implement various pluggable interfaces to augment what Samba daemons see themselves when interoperating with FreeIPA and SSSD.

Steve French (Primary Data) presented his view on the client side of SMB — he is working on cifs.ko kernel driver but also looking beyond Linux. Apple went with first SMB 3 extensions related to OS X-specific features and Steve is currently designing an equivalent of what we had as UNIX extensions in SMB1 for SMB3. A first rough cut into the client-side code was done during the conference and we identified few handy extensions which would allow to reduce greatly memory consumption and string manipulations in case of both server and client running in UTF-8 environment.

SMB 2 and particularly SMB 3 protocol families are interested in that it is much cleaner spec to start with — there is a number of startups that have their own SMB protocol implementations, all SMB2+ only, without legacy support at all. They may not have all the required features yet but it looks like SMB3 is gaining a good base across cloud/storage startups as a good starting point for a modern performance-oriented networking file and block system, extensible enough to cover specific workloads. This, on the other hand, creates a possibility to fragment the spec and it will be interesting to see if common protocol testing platform will help in keeping protocol forks close to each other.

Aside from talks there were intense development and hacking sessions, often well into after midnight. Many bugs were fixed and some of important long term development branches were reviewed in face to face sessions. Below are few examples relevant to identity management work:

    Our effort to move Samba AD to MIT Kerberos is nearing completion. We are hoping to get it polished in next ~6-8 months but the current patchset is passing all but few tests in the Samba testsuite which is run on every commit to the upstream git tree (~1750 different testing scenarios). There is now a common agreement upstream to move to MIT Kerberos as the primary Kerberos implementation. Both Heimdal and MIT Kerberos will be supported but it seems that Heimdal upstream situation is not that healthy since Apple moved full way with the project.

    We are very close to land initial implementation of cross-forest trusts in Samba AD, sponsored by Red Hat and implemented by SerNet. Some of key interoperability bugs were fixed during the conference sprints and I have now an environment where FreeIPA 4.1 can establish trust to Samba AD. Our long term goal of allowing users to maintain Windows workstations in Samba AD and Linux machines in FreeIPA is on track.

    There is active work on scalability. Volker Lendecke presented his progress of improving the messaging system used by Samba that allows to scale both in number of processes on the single host and with a number of hosts beyond currently supported by CTDB. At the same time, Jakub Hrozek (Red Hat, SSSD) demonstrated some of his findings when trying to move ldb database (key part of SSSD caching system and crucial component of Samba AD DC) to a faster backend based on LMDB from OpenLDAP.

    A new version of patchset to re-target Samba AD to use OpenLDAP was published by Nadezhda Ivanova (Symas). The work has stalled a bit due to other customer-related work by Nadezhda but general work to externalize Samba AD components is moving forward. As usual, projects like this aren’t easy and pretty hard to achieve without being able to dedicate months of sustained attention to details.

    There is a common effort to make predictable and manageable release cycles. While with autobuild we have always buildable and releasable git master tree, it is currently tested only in a single environment. Michael Adam (Red Hat) presented his set of Vagrant-based scripts to quickly test Samba under multiple distributions, increasing developer productivity and test coverage.

I’ve been lucky at finding a reason for a long standing bug in IPv6 support that caused some of gripes in testing FreeIPA as far as two years ago. Samba client libraries support Active Directory Domain Controller’s resolution via CLDAP pings but the code that actually tried to reach multiple servers in order to find the one with right capabilities was not taking into account a case when it is impossible to establish actual connection due to IPv6 routes missing in the environment. DNS might return you IPv6 hosts but opening sockets to them may subtly fail with network being unreachable or blocked at firewall level. Samba client libraries weren’t paying attention to the greater context and the whole CLDAP request processing got aborted even though more possible targets were available to test. The fix is in git master and both stable branches now.

Finally, an SMB 3 panel on the last day demonstrated that Samba is in fairly good shape with regards to SMB 3 implementation and there is a healthy communication with Microsoft on the protocol development. Now that Windows Server release cycle is decoupled from Windows (client) release cycle, there seems to be less pressure from the schedule point of view in avoiding discussion of protocol improvements well in advance — a definite change in behavior over last five years.

Slides and audio recordings of the talks will start appearing on sambaxp.org in upcoming weeks. It was impossible to visit all the talks of three parallel tracks so I’m looking forward to listen to them.

May 23, 2015 08:28 AM
May 04, 2015
Rob Crittenden
How do I promote an IPA replica to a master?

The short answer is: you don’t, it’s already a master!

All IPA servers are masters, and equals. Some are just more equal than others. The distinguishing factors are: which was the first master installed and does this master have a CA?

In any IPA installation you absolutely want > 1 masters running a CA so you don’t have a single point of failure. When installing a new master this is not done automatically. You need to add the --setup-ca flag, or run ipa-ca-install post-install.

The first IPA master installed is distinguished by two tasks it is responsible for: generating the CRL and renewing the CA subsystem certificates. See the IPA wiki for details on how to switch the master responsible for these at https://www.freeipa.org/page/Howto/Promote_CA_to_Renewal_and_CRL_Master