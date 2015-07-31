 PKI

The integrated PKI Service is provided via the Dogtag project. PKI signs and publishes certificates for FreeIPA hosts and services. It also provides CRL and OCSP services for all software validating the published certificate. FreeIPA management framework provides API to request, show and find certificates.

As the certificates used by FreeIPA client hosts and services have limited validity, the infrastructure also needs to handle reliable renewal of the certificates. For that purpose, a Certmonger daemon is running on all clients and handles the renewal in a transparent way for the services using it.
Contents

    1 Blending in PKI infrastructure
        1.1 Chaining with Windows Server 2012
    2 Communication with PKI
    3 Requesting a new certificate
        3.1 Manual certificate requests
        3.2 Automated certificate requests with Certmonger
    4 Documentation
        4.1 Designs
        4.2 HOWTOs

Blending in PKI infrastructure

FreeIPA server PKI can be configured in several configurations to fit into potentially existing PKI infrastructure (related training materials):

    Self-signed: the default option, PKI uses a self-signed CA certificate
    External CA: when --external-ca option is used, ipa-server-install produces a certificate certificate request for it's CA certificate so that it can be properly chained in existing PKI infrastructure.
    CA-less: FreeIPA with CA-less configuration does not set up PKI server at all and only accepts signed certificates for the Web Server and Directory Server components.

Chaining with Windows Server 2012

FreeIPA is capable to chain with external CA authorities, including Windows Server 2012 (and it's other versions). Note that there is an existing issue (Bug 1129558 in FreeIPA 4.0 and older in the certificate request produced by ipa-server-install which causes Windows Server 2012 Certificate Authority UI to reject signing the certificate.

This can be worked around by signing the certificate via command line utility certreq.exe using following command:

certreq.exe -submit -attrib "CertificateTemplate:SubCA" ipa.csr mkad2012-ipa-ca

Communication with PKI

FreeIPA clients and their services are neither expected nor allowed to communicate with PKI directly. They are supposed to utilize the FreeIPA server API instead, using the standard Kerberos authentication. FreeIPA web service then validates the request and passes it to the PKI service, authenticating with an own agent certificate (ipaCert stored in /etc/httpd/alias/)
Requesting a new certificate

Certificate can be requested either manually by a privileged user who is then able to request it for any chosen hostname (cn) or by the host itself, which can request a certificate for it's own hostname, ideally via Certmonger.
Manual certificate requests

On a FreeIPA client, run the following commands to request a new certificate which can then be used by a mod_nss Apache module to secure a HTTPS traffic with a certificate published by FreeIPA CA:

    Create a Kerberos principal for the service that will use/own the certificate:

        # ipa service-add HTTP/`hostname`

    Create NSS certificate database which will hold the certificate

        # mkdir -p /etc/httpd/nssdb; cd /etc/httpd/nssdb
        # certutil -N -d .

    Set correct directory ownership and SELinux context (on platforms running on SELinux):

        # chown :apache *.db && chmod g+rw *.db
        # semanage fcontext -a -t cert_t "/etc/httpd/nssdb(/.*)?"
        # restorecon -FvvR /etc/httpd/nssdb/

    Add FreeIPA CA certificate

        # certutil -A -d . -n 'EXAMPLE.COM IPA CA' -t CT,, -a < /etc/ipa/ca.crt

    Request a signed certificate for the service

        # certutil -R -d . -a -g 2048 -s CN=`hostname`,O=EXAMPLE.COM > web.csr
        # ipa cert-request --principal=HTTP/`hostname` web.csr
        # ipa cert-show $SERIAL_NUMBER --out=web.crt
        # certutil -A -d . -n Server-Cert -t u,u,u -i web.crt

    Optionally show and validate the certificate

        # certutil -L -d . -n Server-Cert
        # certutil -V -u V -d . -n Server-Cert

Obviously, this procedure has a disadvantage of the certificate not being tracked by the Certmonger and thus not being automatically renewed before it's validity ends.
Automated certificate requests with Certmonger

To request a new (HTTP) certificate for a FreeIPA client, the procedure is slightly easier. The biggest benefit is that the certificate is automatically renewed before the validation ends:

    Create a Kerberos principal for the service that will use/own the certificate:

        # ipa service-add HTTP/`hostname`

    Create NSS certificate database which will hold the certificate

        # mkdir -p /etc/httpd/nssdb; cd /etc/httpd/nssdb
        # certutil -N -d .

    In case you created the database with a PIN (asked interactively in the previous step), remember it or store it to text file:

        # echo $PIN > pwdfile.txt
        # chmod o-rwx pwdfile.txt

    Set correct directory ownership and SELinux context (on platforms running on SELinux):

        # chown :apache *.db && chmod g+rw *.db
        # semanage fcontext -a -t cert_t "/etc/httpd/nssdb(/.*)?"
        # restorecon -FvvR /etc/httpd/nssdb/

    Add FreeIPA CA certificate

        # certutil -A -d . -n 'EXAMPLE.COM IPA CA' -t CT,, -a < /etc/ipa/ca.crt

    Request a signed certificate for the service and see the entry in Certmonger. In case you created a NSS database with a PIN (see the step 3.), use -P $PIN or -p /etc/httpd/nssdb/pwdfile.txt option to tell certmonger about it:

        # ipa-getcert request -d /etc/httpd/nssdb -n Server-Cert -K HTTP/`hostname` -N CN=`hostname`,O=EXAMPLE.COM -g 2048 -p /etc/httpd/nssdb/pwdfile.txt

        SAN names: in FreeIPA 4.0 and later, you can add optional SAN DNS names to your request with -D. Note that you need to first create respective host or service objects and configure that given host can manage them with service-add-host or host-add-managedby command. These objects are being verified when FreeIPA cert-req command authorizes the SAN names.
    Check the status of the requested certificate. If request succeeded, it will be in a MONITORING state:

        # ipa-getcert list -d /etc/httpd/nssdb/ -n Server-Cert

    Optionally show and validate the certificate

        # certutil -L -d . -n Server-Cert
        # certutil -V -u V -d . -n Server-Cert

Documentation
Designs

    CA Subsystem Certificate Renewal (introduced in 3.0.0)
    CA Certificate Renewal (introduced in 4.1)
    Searching certificates with cert-find command

HOWTOs

    Recovering from expired CA subsystem certificates in IPA 2.x
    Promoting a self-signed IPA CA
    CA Certificate Renewal
    Promoting a CA to Renewal and CRL Master
    Required updates to PKI after Directory Manager's password change

