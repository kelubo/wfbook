 Certmonger
Contents

    1 Introduction
    2 Commands
    3 Common Usage
        3.1 Get a list of currently tracked certificates
            3.1.1 Anatomy of a tracked certificate
            3.1.2 All tracked certificates
            3.1.3 All IPA-issued certificate
        3.2 Request a new certificate
            3.2.1 OpenSSL
            3.2.2 NSS
        3.3 Manually renew a certificate
        3.4 Stop tracking a certificate
    4 External Documentation

Introduction

The certmonger daemon monitors certificates for impending expiration, and can optionally refresh soon-to-be-expired certificates with the help of a CA. If told to, it can drive the entire enrollment process from key generation through enrollment and refresh.

It can work with either flat files, like those used by OpenSSL, or with NSS databases.
Commands

The certmonger command-line too, getcert is a very generic tool that can manage the certificates you are tracking. A superset of this too, ipa-getcert works specifically with an IPA CA. ipa-getcert is equivalent to getcert -c IPA
Common Usage

For the NSS cases this assumes there is no password associated with the NSS database. If there is then the key must be in a file readable by certmonger and passed in using the -p option.
Get a list of currently tracked certificates

The difference between "all" and "IPA-issued" is subtle. An IPA-issued certificate means it was issued using the XML-RPC API provided by IPA. It does not refer to any certificate issued by the IPA CA. There are some certificates, such as some subsystem certificates of the CA itself, than can be tracked by certmonger but are not issued by the XML-RPC API.
Anatomy of a tracked certificate

A typical OpenSSL certificate looks like this:

Request ID '20120912211542':
       status: MONITORING
       stuck: no
       key pair storage: type=FILE,location='/etc/ssl/private.key'
       certificate: type=FILE,location='/etc/ssl/server.crt'
       CA: IPA
       issuer: CN=Certificate Authority,O=EXAMPLE.COM
       subject: CN=edsel.greyoak.com,O=EXAMPLE.COM
       expires: 2014-09-13 21:15:44 UTC
       eku: id-kp-serverAuth,id-kp-clientAuth
       pre-save command: 
       post-save command: 
       track: yes
       auto-renew: yes

You'll need the Request ID when running other certmonger commands.

The status MONITORING means that the certificate is valid and being tracked by certmonger.

The key and certificate values indicate where the OpenSSL private key and certificate are stored in the filesystem.

The CA type is IPA. This was passed in as the -c option of getcert, or automatically set to IPA by ipa-getcert.

The issuer is the subject of the CA that issued the certificate.

The subject is the subject of the certificate in the certificate file.

The expiration date is UTC. By default certmonger will start trying to renew the certificate 28 days before it expires.

eku lists the Enhanced Key Usage (EKU) extensions of the certificate. By default IPA certificates are usable both as server and client certificates.

The pre and post-save commands define commands that are executed before and after the renewal process. This can be used, for example, to restart a service when a certificate is renewed.
All tracked certificates

# getcert list

All IPA-issued certificate

# ipa-getcert list

Request a new certificate

This will generate a new key pair, create a CSR and request a certificate from the IPA server configured in /etc/ipa/default.conf, authenticating using the machine's host service principal in /etc/krb5.keytab.
OpenSSL

#  ipa-getcert request -f /path/to/server.crt -k /path/to/private.key -r

NSS

# ipa-getcert request -d /path/to/database -n 'Test' -r

Manually renew a certificate

If you want to manually renew a certificate prior to its expiration date, run:

# ipa-getcert resubmit -i REQUEST_ID

Stop tracking a certificate

To tell certmonger to forget about a certificate and stop tracking it run:

# ipa-getcert stop-tracking -i REQUEST_ID

This does not touch the certificate or keys, it merely tells certmonger to not track it.
External Documentation

    Certmonger user guide in RHEL documentation