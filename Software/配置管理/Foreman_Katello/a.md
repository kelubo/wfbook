## Puppet 管理

安装后，Foreman 安装程序将在主机上设置 Puppet  服务器，与 Foreman 完全集成。首先在 Foreman 主机上运行 Puppet agent ，它将向 Foreman 发送第一个 Puppet 报告，自动在 Foreman 的数据库中创建主机。

```bash
puppet agent --test
```

> Puppet 将在第一次显示无法找到节点的警告，这可以忽略。

在 Foreman 中，单击主机选项卡，您的 Foreman 主机将以 “O” 状态显示在列表中。这表明它的状态是正常的，在上一次 Puppet 运行时没有任何更改。

### 下载 Puppet 模块

Next, we’ll install a Puppet module for managing the NTP service from [Puppet Forge](http://forge.puppetlabs.com) to our “production” environment (the default):接下来，我们将安装一个 Puppet 模块，用于管理从 Puppet Forge 到“生产”环境（默认）的 NTP 服务：

```bash
puppet module install puppetlabs/ntp
```

在 Foreman 中，转到 Configure>Classes ，然后单击 Import from hostname（右上角）从 Puppet 服务器读取可用的 Puppet 类并填充 Foreman 的数据库。如果安装正确，“ntp” 类将出现在 Puppet 类列表中。

### Using the Puppet module

Click on the “ntp” class in the list, change to the *Smart Class Parameters* tab and select the *servers* parameter on the left hand side.  Tick the *Override* checkbox so Foreman manages the “servers” parameter of the class and  change the default value if desired, before submitting the page.

- More info: [Parameterized classes documentation](https://theforeman.org/manuals/3.5/index.html#4.2.5ParameterizedClasses)
- Screencast: [Parameterized class support in Foreman](https://www.youtube.com/watch?v=Ksr0tilbmcc)

Change back to the *Hosts* tab and click *Edit* on the Foreman host.  On the *Puppet Classes* tab, expand the *ntp* module and click the + icon to add the *ntp* class to the host, then save the host.

Managed parameters can be overridden when editing an individual host from its *Parameters* tab.

Clicking the *YAML* button when back on the host page will show the *ntp* class and the servers parameter, as passed to Puppet via the ENC (external node classifier) interface.  Re-run `puppet agent --test` on the Foreman host to see the NTP service automatically reconfigured by Puppet and the NTP module.

### Adding more Puppet-managed hosts

Other hosts with Puppet agents installed can use this Puppet server by setting `server = foreman.example.com` in puppet.conf.  Sign their certificates in Foreman by going to *Infrastructure > Smart Proxies > Certificates* or using `puppet cert list` and `puppet cert sign` on the Puppet server.

Puppet classes can be added to host groups in Foreman instead of  individual hosts, enabling a standard configuration of many hosts  simultaneously.  Host groups are typically used to represent server  roles.



## 3.5 Configuration

The following sections detail the configuration steps required to get Foreman working in your environment. Lets get started!

### 3.5.1 Initial Setup

#### Configuration

Foreman configuration is managed from two places; a configuration file *config/settings.yaml* and from the *SETTINGS/Foreman Settings* page. A full description of the configuration options is given at [foreman_configuration](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions)

#### Database

Foreman requires a database of its own to operate - database sharing is unsupported. PostgreSQL is the only database that is considered supported for production use. The installer can set this up for you.

In all cases, please use the *production* settings.

to initialize the database schema and content, run:

```
foreman-rake db:migrate
foreman-rake db:seed
```

For more information please see the database configuration page [here](https://theforeman.org/manuals/3.5/index.html#3.5.3DatabaseSetup)

#### Import Data from Puppet

At this point, you might want to go through the [[FAQ]] to see how can you import your data into Foreman.

#### Start The Web Server

if you installed via rpm, just start the foreman service, or start the builtin web server by typing:

```
RAILS_ENV=production rails server
```

and point your browser to `http://foreman:3000`

#### Getting your Puppet Reports into Foreman

Read [Puppet_Reports](https://theforeman.org/manuals/3.5/index.html#3.5.4PuppetReports) to learn how to get your nodes to report to Foreman.

### 3.5.2 Configuration Options

Configuration is broken into two parts. The */etc/foreman/settings.yaml* file and the *Administer > Settings* page. The configuration file contains a few low-level options that need to be set before Foreman starts but the majority of Foreman  customization is managed from within the web interface on the *Settings* page.

The configuration file can also override those settings specified in  the web interface.  Any settings added in the config file that are  available in the web interface will be made read-only.

#### The config/settings.yaml file

##### YAML start

The first non-comment line of this file must be three dashes.

```
---
```

##### require_ssl

This boolean option configures whether Foreman insists on using only  https/ssl encrypted communication channels in the web interface. This  does not configure the channels used to contact the smart-proxies. Note  that certain operations will still accept a http connection even if this is set, for example, the downloading of a finish script.

```
:require_ssl: true
```

##### support_jsonp

This boolean options configures whether Foreman will provide support  for the JavaScript object notation with padding. When set to *true* then Foreman will allow to pass a callback parameter to the API calls.

```
:support_jsonp: false
```

##### trusted_proxies

This setting configures Rails’ [ActionDispatch::RemoteIp middleware](https://api.rubyonrails.org/classes/ActionDispatch/RemoteIp.html). This is for secure handling of the `X-Forwarded-For` header that HTTP proxies send. Note that some Foreman Proxy features  behave as an HTTP proxy (most notably Templates), but it can also be a  classical reverse proxy such as Apache.

This should list the IP addresses or IP ranges that can send the `X-Fowarded-For` header. Implicitly this means they can spoof the request IP addresses  so only set this if you use a reverse HTTP proxy and on trusted values.  Being too broad can introduce security risks.

If you use a reverse proxy in front of Puma (as the installer does by default), be sure to include localhost IPs.

```
:trusted_proxies:
  - 127.0.0.0/8
  - ::1
```

##### logging

This options contains a hash of parameters that override the current  logging configuration.  It supports any of the options that are in `logging.yaml` (see below), but most usually it’s used to change the log level for debugging.

```
:logging:
  :level: debug
```

##### loggers

This options contains a hash of config options for specific loggers,  which cover parts of Foreman functionality.  It’s usually used to enable additional types of logging.

Available loggers are:

- app - web requests and all general application logs (default: true)
- audit - additional fact import statistics, numbers of facts added/updated/removed (default: true)
- ldap - high level LDAP queries (e.g. find users in group) and LDAP operations performed (default: false)
- permissions - evaluation of user roles, filters and permissions when loading pages (default: false)
- sql - SQL queries made through Rails ActiveRecord, only debug (default: false)

Uncomment or add a :loggers block to enable or disable loggers:

```
:loggers:
  :app:
    :enabled: true
  :ldap:
    :enabled: false
  :permissions:
    :enabled: false
  :sql:
    :enabled: false
```

Some plugins may add their own loggers. See the configuration files  in /etc/foreman/plugins/ which should list possibilities and enable them there.

#### The ‘logging.yaml’ file

This settings file can be found at `/etc/foreman/logging.yaml`, or `config/logging.yaml` on a source installation.  It controls the default logging locations, formatting and log levels per Rails environment.

In a normal installation, only the “production” environment is  relevant - development and test are only used in source installations.   The file has comments for the most common configuration options, which  can be changed here or overridden from the `logging` directive in the main `settings.yaml` config file (see above).

#### The ‘Administer/Settings’ page

##### access_unattended_without_build

When enabled, unattended URLs used to fetch templates for individual  hosts will be accessible irrespective of the host build state. When  disabled, the unattended URLs will only function in build mode to  prevent accidental rebuilding etc. Default: false

##### administrator

When Foreman needs to mail the administrator then this is the email  address that it will contact.  The domain is determined from Facter,  else it will default to the “:domain” setting in  /etc/foreman/settings.yaml. Default: root@<your domain>.

##### always_show_configuration_status

When reporting the configuration status of hosts, usually only hosts  with outdated reports, or a Puppet proxy/master set and no reports will  be considered out of sync. When true, all hosts will be considered out  of sync until a report is received. This setting should be enabled in  environments where Foreman is used for reporting without smart proxies. Default: false

##### authorize_login_delegation

mod_proxy and other load balancers will set a REMOTE_USER environment variable. If this is *true* , your users will be able to login through an external service and  Foreman requests will be authenticated using this REMOTE_USER variable. Default: false

##### authorize_login_delegation_api

Same as above, but this setting allows REMOTE_USER authentication for API calls as well. Default: false

##### authorize_login_delegation_auth_source_user_autocreate

If you have authorize_login_delegation set, new users can be  autocreated through your external authentication mechanism by changing  this to the name of the Auth Source you want to use to auto create  users. Default: ‘’

##### bmc_credentials_accessible

By default, all BMC passwords will be redacted in template and ENC  output, preventing both users from viewing the passwords directly and  also from configuration (or access) in Puppet and other config  management tools using the ENC interface. Foreman will continue to use  the stored password for BMC power operations.

When set to true, all passwords stored on BMC network interfaces will be visible to other users who can view the host via the ENC YAML  preview and accessible through templates, for the purposes of  configuring BMC interfaces automatically.

Note that setting this to false also this requires that `safemode_render` be enabled, else it could be bypassed.

Default: false

##### clean_up_failed_deployment

During host provisioning onto a compute resource using images or  templates and a finish script, this setting controls the behavior of  Foreman when the script fails. When true, the new host and virtual  machine (on the compute resource) will be deleted if the script fails.  When false, the host and virtual machine are left running so the script  can be debugged. Default: true

##### create_new_host_when_facts_are_uploaded

When facts are received from Puppet or other configuration management systems, a corresponding host will be created in Foreman if the  certname or hostname is unknown.  When false, this behavior is disabled  and facts will be discarded from unknown hosts. Default: true See also: create_new_host_when_report_is_uploaded

##### create_new_host_when_report_is_uploaded

If a report is received from Puppet or other configuration management systems, a corresponding host will be created in Foreman if the  hostname is unknown.  When false, this behavior is disabled and reports  will be discarded from unknown hosts. Default: true See also: create_new_host_when_facts_are_uploaded

##### db_pending_seed

When you upgrade Foreman using foreman-installer, the new version may contain some seed data such as operating systems, provisioning  templates, roles and more. It will also update any previous seeded data. If this is true, the next run of the installer will seed this data. If  it is false, the database will not get this seeded data.

Default: true

##### default_locale

Specifies, which language is set for newly created users. This also applies to new users managed via LDAP.

Default: ‘’, but ‘Browser language’ is used for newly created users. This also applies to new users managed via LDAP.

##### default_timezone

Specifies, which timezone is set for newly created users.

Default: ‘’, but ‘Browser timezone’ is used for newly created users.

##### default_location

The name of an location that hosts uploading facts into Foreman will  be assigned to if they are new or missing an location.  This can be used when hosts are created through fact uploads to ensure they’re assigned  to the correct location to prevent resource mismatches.  For inherited  location, the fact should use slash-delimited names, e.g. “USA/New  York”. Default: ‘’, but initialized by the database seed to the initially  seeded location

##### default_organization

The name of an organization that hosts uploading facts into Foreman  will be assigned to if they are new or missing an organization.  This  can be used when hosts are created through fact uploads to ensure  they’re assigned to the correct organization to prevent resource  mismatches.  For inherited organization, the fact should use  slash-delimited names, e.g. “ACME Inc/Engineering”. Default: ‘’, but initialized by the database seed to the initially  seeded organization

##### delivery_method

The method for sending emails from the Foreman instance, either *sendmail* (running the command set by *sendmail_location*) to send mail via the configured local MTA, or *smtp* for direct connection to an outbound SMTP server (given by settings with the *smtp* prefix). Default: sendmail

##### email_reply_address

The return address applied to outgoing emails. Default: Foreman-noreply@<your domain>

##### email_subject_prefix

The subject line prefix for any emails sent by Foreman. Default: [foreman]

##### entries_per_page

The number of entries that will be shown in the web interface for list operations. Default: 20

##### foreman_url

Emails may contain embedded references to Foreman’s web interface.  This option allows the URL prefix to be configured.  The FQDN is  determined from Facter, else it will default to the “:fqdn” setting in  /etc/foreman/settings.yaml. Default: https://FQDN/ or http://FQDN/ (depending on require_ssl) See also: unattended_url

##### global_(PXELinux/PXEGrub/PXEGrub2)

Default PXELinux/PXEGrub/PXEGrub2 template. This template gets  deployed to all configured TFTP servers. For example, this template can  be used to make new hosts in a network boot into [Foreman Discovery](http://theforeman.org/plugins/foreman_discovery/).

- Default: none

##### matchers_inheritance

Matchers used in smart variables or smart class parameters to match  host groups, organizations or locations can be inherited by children too (e.g. a matcher for hostgroup=Base will also apply to Base/Web). Set  this to false to make matchers only match a particular hostgroup,  organization or location and not its children. Default: true

##### host_power_status

Controls whether the power status of hosts is shown on the hosts  list, which may lead to decreased performance, or if the column is  removed. Default: true

##### host_owner

Defines which is the default owner of newly provisioned hosts. It can be either a user or a user group. If unset, the default owner of the  host will be the user who created the host. Default: none

##### idle_timeout

Users that stay idle (no requests sent to Foreman) for more than this number of minutes will be logged out. Default: 60

##### interpolate_erb_in_parameters

If *true*, Foreman variables will be exposed to the ENC. Check [Template Writing](http://projects.theforeman.org/projects/foreman/wiki/TemplateWriting) for a more comprehensive guide on how to create and use these variables in your ERB templates. Default: true

##### ignore_facts_for_operatingsystem

When Foreman receives facts for a host (from any source, Puppet,  Ansible…) it will try to update the operating system to whatever the  incoming facts say. This setting allows you to import all facts but  ignore those related with operating system. If this is set to *true*, Foreman will update the operating system of hosts using these facts. Default: false See also: ignored_facts_for_domain

##### ignore_facts_for_domain

See ignored_facts_for_operatingsystem - this setting is the equivalent for domains. Default: false

##### ignore_puppet_facts_for_provisioning

If this option is set to *true* then Foreman will not update  the IP and MAC addresses stored on a host’s network interfaces with the  values that it receives from facts. It will also include Foreman’s  values for IP and MAC to Puppet in its node/ENC information. Default: false See also: ignored_interface_identifiers

##### ignored_interface_identifiers

When importing facts and updating stored information on network interfaces, any network interface with an identifier (e.g. `eth0`) that matches any of the items in this list will be ignored and not  updated. This can be used to avoid updating special types of interfaces  when Foreman has limited or no understanding of them. The contents are  an array of strings which may contain `*` wildcards to match zero or more characters. Default: `["lo",  "en*v*", "usb*", "vnet*", "macvtap*", ";vdsmdummy;", "veth*", "docker*", "tap*", "qbr*", "qvb*", "qvo*", "qr-*", "qg-*", "vlinuxbr*", "vovsbr*", "br-int", "vif*", "cali*"]` See also: ignore_puppet_facts_for_provisioning

##### libvirt_default_console_access

The IP address that should be used for the console listen address when provisioning new virtual machines via Libvirt. Default: 0.0.0.0

##### location_fact

The name of a fact from hosts reporting into Foreman which gives the  full location name of the host.  This can be used when hosts are created through fact uploads to ensure they’re assigned to the correct location to prevent resource mismatches.  The location of a host will be updated to the value of the fact on every fact upload.  For inherited  locations, the fact should use slash-delimited names, e.g. “USA/New  York”. Default: foreman_location

##### local_boot_(PXELinux/PXEGrub/PXEGrub2)

When creating hosts that use a PXE loader, this will be the default template for local boot.

- Default: none

##### login_delegation_logout_url

If your external authentication system has a logout URL, redirect  your users to it here. This setting can be useful if your users sign in  Foreman through SSO, and you want them to sign out from all services  when they log out Foreman. Default: ‘’

##### login_text

Text to be displayted in the login-page footer. The keyword `$VERSION` is replaced by the current version.

Default: `Version $VERSION`

##### manage_puppetca

If this option is set to *true* then Foreman will manage a host’s Puppet certificate signing. If it is set to *false* then some external mechanism is required to ensure that the host’s certificate request is signed. Default: true

##### name_generator_type

Specifies the method used to generate random hostnames when creating a new host, either *Random-based*, *MAC-based* for bare metal hosts only, or *Off* to disable the function and leave the field blank. Default: *Random-based*

##### oauth_active

Enables OAuth authentication for API requests. Default: false

##### oauth_consumer_key

OAuth consumer key Default: none

##### oauth_consumer_secret

OAuth consumer secret Default: none

##### oauth_map_users

This allows OAuth users to specify which user their requests map to. When this is *false*, OAuth requests will map to admin. Default: true

##### organization_fact

The name of a fact from hosts reporting into Foreman which gives the  full organization name of the host.  This can be used when hosts are  created through fact uploads to ensure they’re assigned to the correct  organization to prevent resource mismatches.  The organization of a host will be updated to the value of the fact on every fact upload.  For  inherited organization, the fact should use slash-delimited names, e.g.  “ACME Inc/Engineering”. Default: foreman_organization

##### outofsync_interval

Duration in minutes after which servers classed as out of sync, if the report origin has not been identified. Default: 30

##### proxy_request_timeout

Timeout in seconds used when making REST requests to a Smart Proxy,  e.g. when importing Puppet classes or creating DHCP records.  May be set to a larger value when certain operations take a long time. Default: 60

##### query_local_nameservers

If *true*, Foreman will query the local DNS. When *false* Foreman will query the SOA/NS authority. Warning! Querying a resolver  can cause Foreman to get false positives when checking presence of DNS  records due to caching. Default: false See also: dns_conflict_timeout

##### restrict_registered_smart_proxies

When set to *true*, services such as Puppet servers (or Salt)  need to have a smart proxy registered with the appropriate feature (e.g. Puppet) to access fact/report importers and ENC output. Default: true

##### root_pass

If a root password is not provided whilst configuring a host or its  host group then this encrypted password is used when building the host. Default: ‘’ (To generate a new one you should use: *openssl passwd -1 “your_password”* )

##### safemode_render

In the default configuration with `safemode_render` set to *true*, access to variables, Foreman internals and any object that is not  whitelisted within Foreman will be denied for system security.

When set to *false*, any object may be accessed by a user with permission to use templating features, either via editing of templates, parameters or smart variables. This permits users full remote code  execution *on the Foreman server*, effectively disabling all authorization if set to *false*. It is strongly recommended for this setting to be *true* in most environments.

Default: true

##### send_welcome_email

New account holders will receive a welcome email when the account is  created if this is enabled, including their username and a link to  Foreman. Default: false

##### sendmail_arguments

Arguments given to the sendmail command when sending emails from Foreman. Default: `-i`

##### sendmail_location

Path to the sendmail binary, or other sendmail-compatible MTA for outbound email. Default: `/usr/sbin/sendmail`

##### smtp_address

Outbound SMTP connections will connect to the SMTP server at this address, either a hostname or IP address. Default: *empty value* (implying localhost)

##### smtp_authentication

Outbound SMTP connections will authenticate to the SMTP server using the protocol specified here, either: *plain* for the PLAIN SMTP mechanism (plain text), *login* for the LOGIN SMTP mechanism (plain text), *cram-md5* for the CRAM-MD5 method (hashed, not plain text), or *none* to disable authentication. See also: *smtp_username*, *smtp_password*. Default: none

##### smtp_domain

Outbound SMTP connections will use this domain to identify during the HELO/EHLO command. Default: *empty value*

##### smtp_enable_starttls_auto

Outbound SMTP connections will automatically switch to TLS mode (via `STARTTLS`) when the capability is advertised by the SMTP server. This implies verification of TLS/SSL certificates by default (see also: *smtp_openssl_verify_mode*). Default: true

##### smtp_openssl_verify_mode

Outbound SMTP connections to a TLS-enabled SMTP server will verify  the remote server certificate according to this setting. Either the  default (usually *peer*), *none* for no verification of the server certificate, or *peer* for explicitly verifying the server certificate. *client_once* and *fail_if_no_peer_cert* have no effect in outbound SMTP connections. Default: Default verification mode (usually *peer*)

##### smtp_password

Outbound SMTP connections with authentication enabled will authenticate with this password (see also: *smtp_username*, *smtp_authentication*). Default: *empty value*

##### smtp_port

Outbound SMTP connections will connect to the SMTP server on this TCP port. Some SMTP servers may prefer port 587 for email submission. Default: 25

##### smtp_username

Outbound SMTP connections with authentication enabled will identify with this username (see also: *smtp_password*, *smtp_authentication*). Default: *empty value*

##### ssl_client_cert_env

Environment variable containing the entire PEM-encoded certificate  from the client.  This environment variable is required when  authenticating using Subject Alternative Names and will be preferred  over `ssl_client_dn_env` if available.  Under Apache HTTP and mod_ssl, `SSLOptions +ExportCertData` sets this environment variable. Default: SSL_CLIENT_CERT See also: ssl_client_dn_env

##### ssl_client_dn_env

Environment variable containing the subject DN from a client SSL certificate.  Under Apache HTTP and mod_ssl, `SSLOptions +StdEnvVars` sets this environment variable. Default: SSL_CLIENT_S_DN See also: ssl_client_cert_env

##### ssl_client_verify_env

Environment variable containing the verification status of a client SSL certificate Default: SSL_CLIENT_VERIFY

##### ssl_ca_file

The SSL Certificate Authority file that Foreman will use when connecting to its smart-proxies. Default: The CA file used by puppet

##### ssl_certificate

The SSL certificate that Foreman will use when connecting to its smart-proxies. Default: The host certificate used by puppet

##### ssl_priv_key

The SSL private key file that Foreman will use when connecting to its smart-proxies. Default: The private key file used by puppet

##### token_duration

Time in minutes installation tokens should be valid for, 0 to disable token generation. Default: 360 (6 hours)

##### trusted_hosts

Other trusted hosts in addition to Smart Proxies allowed to access  fact/report importers and ENC output. i.e:  [puppetserver1.yourdomain.com, puppetserver2.yourdomain.com] Default: []

##### unattended_url

This controls the URL prefix used in provisioning templates such as  TFTP/PXELinux files that refer to the Foreman server.  It is usually  HTTP rather than HTTPS due to lack of installer support for HTTPS.  The  FQDN is determined from Facter, else it will default to the “:fqdn”  setting in /etc/foreman/settings.yaml. Default: http://FQDN/ See also: foreman_url

##### update_environment_from_facts

If Foreman receives an environment fact from one of its hosts and if this option is *true*, it will update the host’s environment with the new value. By default  this is not the case as Foreman should manage the host’s environment. Default: false

##### update_ip_from_built_request

If *true*, Foreman will update the host IP with the IP that  made the ‘build’ request. This request is made at the end of a  provisioning cycle to indicate a host has completed the build. Default: false

##### update_subnets_from_facts

If *true*, fact imports from Puppet and other config  management tools will update the subnet on host network interfaces to  match the IP address given in facts, preventing a mismatch. Default: false

##### use_shortname_for_vms

When false, any hosts created on a compute resource will use the FQDN of the host for the name of the virtual machine.  When set to the true, the short name (i.e. without domain) will be used instead. Default: false

##### use_uuid_for_certificates

When enabled, Foreman will generate UUIDs for each host instead of  using the hostname as the Puppet certname, which is more reliable with  changing hostnames.  Note that when disabling this setting, existing  stored certnames won’t be changed or discarded until new certificates  are requested from a host (i.e. on a rebuild), in order that the  existing certificate remains known to Foreman and can be revoked.

##### websockets_encrypt

When enabled, virtual machine consoles using NoVNC will always be sent over an encrypted WebSocket connection. Requires both `websockets_ssl_cert` and `websockets_ssl_key` to be configured too. Default: true if `require_ssl` is enabled See also: websockets_ssl_cert, websockets_ssl_key

##### websockets_ssl_cert

Path to the SSL certificate that will be used for the WebSockets  server when serving virtual machine consoles.  Should be the same as the SSL certificate used for the Foreman web server (e.g. Apache).

##### websockets_ssl_key

Path to the SSL private key that will be used for the WebSockets  server when serving virtual machine consoles.  Should be the same as the SSL key used for the Foreman web server (e.g. Apache).

### 3.5.3 Database Setup

Foreman is a Rails application. While Rails supports different  databases, Foreman supports only PostgreSQL for production deployments.

The database configuration file can be found at:

```
/etc/foreman/database.yml
```

When using PostgreSQL, you should make sure that the foreman-postgresql package is installed. See [3.3 Install From Packages](https://theforeman.org/manuals/3.5/index.html#3.3InstallFromPackages).

Edit your config/database.yml and modify:

```
production:
  adapter: postgresql
  database: foreman
  username: foreman
  password: password
  host: localhost
```

### 3.5.4 Puppet Reports

Foreman uses a custom puppet reports address (similar to tagmail or  store) which Puppet will use to upload its report into Foreman.  This  enables you to see the reports through the web interface as soon as the  client finishes its run.

#### Configuration

##### Client

Ensure that the puppet clients has the following option in their puppet.conf:

```
report = true
```

Without it, no reports will be sent.

##### Puppet server

First identify the directory containing report processors, e.g.

- AIO installations: /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/reports/
- Fedora: /usr/share/ruby/vendor_ruby/puppet/reports/
- Debian or Ubuntu: /usr/lib/ruby/vendor_ruby/puppet/reports/
- other OSes, look for tagmail.rb in the Puppet installation (`locate tagmail.rb`)

Copy [the report processor source](https://raw.githubusercontent.com/theforeman/puppet-puppetserver_foreman/master/files/report.rb) to this report directory and name it `foreman.rb`.

Create a new configuration file at `/etc/puppetlabs/puppet/foreman.yaml` (Puppet 4 AIO) or `/etc/puppet/foreman.yaml` (non-AIO) containing:

```
---
# Update for your Foreman and Puppet server hostname(s)
:url: "https://foreman.example.com"
:ssl_ca: "/etc/puppetlabs/puppet/ssl/certs/ca.pem"
:ssl_cert: "/etc/puppetlabs/puppet/ssl/certs/puppet.example.com.pem"
:ssl_key: "/etc/puppetlabs/puppet/ssl/private_keys/puppet.example.com.pem"

# Advanced settings
:puppetdir: "/opt/puppetlabs/server/data/puppetserver"
:puppetuser: "puppet"
:facts: true
:timeout: 10
:threads: null
```

Edit the URL field to point to your Foreman instance, and the SSL  fields for the hostname of the Puppet server (which may be the same  host). Paths to Puppet’s SSL certificates will be under  /var/lib/puppet/ssl/ when using Puppet with non-AIO.

Lastly add this report processor to your Puppet server configuration.  In your server puppet.conf under the `[main]` section add:

```
reports=log, foreman
```

and restart your Puppet server.

You should start seeing reports coming in under the reports link.

##### Debugging reports

If reports aren’t showing up in Foreman when an agent is run, there  can be a number of reasons.  First check through the above configuration steps, and then look at these places to narrow down the cause:

1. Puppetserver logs may show an issue either loading or executing  the report processor.  Check syslog (/var/log/messages or syslog) for `puppetserver` messages, or /var/log/puppetlabs/puppetserver/.
2. /var/log/foreman/production.log should show a `POST "/api/reports"` request each time a report is received, and will end in `Completed 201 Created` when successful.  Check for errors within the block of log messages.
3. When viewing reports in Foreman’s UI, be aware that the default  search is for “eventful” reports.  Clear the search (‘x’) to see reports with no changes.

#### Expire reports automatically

You will probably want to delete your reports after some time to limit database growth. To do so, you can set a cronjob:

Available conditions:

- days => number of days to keep reports (defaults to 7)
- status => status of the report (defaults to 0 –> “reports with no errors”)

To expires all reports regardless of their status:

```
foreman-rake reports:expire days=7
```

To expire all non-interesting reports after one day:

```
foreman-rake reports:expire days=1 status=0
```

### 3.5.5 Facts and the ENC

Foreman can act as a classifier to Puppet through the External Nodes  interface. This is a mechanism provided by Puppet to ask for  configuration data from an external service, via a script on the Puppet  server.

The external nodes script we supply also deals with uploading facts  from hosts to Foreman, so we will discuss the two things together.

#### Configuration

##### Puppet server

Download [the ENC script](https://raw.githubusercontent.com/theforeman/puppet-puppetserver_foreman/master/files/enc.rb) to `/etc/puppetlabs/puppet/node.rb` (Puppet AIO) or `/etc/puppet/node.rb` (non-AIO). The name is arbitrary, but must match configuration below, and ensure it’s executable by “puppet” with `chmod +x /etc/puppet/node.rb`.

Unless it already exists from setting up reporting, create a new configuration file at `/etc/puppetlabs/puppet/foreman.yaml` (Puppet AIO) or `/etc/puppet/foreman.yaml` (non-AIO) containing

```
---
# Update for your Foreman and Puppet server hostname(s)
:url: "https://foreman.example.com"
:ssl_ca: "/etc/puppetlabs/puppet/ssl/certs/ca.pem"
:ssl_cert: "/etc/puppetlabs/puppet/ssl/certs/puppet.example.com.pem"
:ssl_key: "/etc/puppetlabs/puppet/ssl/private_keys/puppet.example.com.pem"

# Advanced settings
:puppetdir: "/opt/puppetlabs/server/data/puppetserver"
:puppetuser: "puppet"
:facts: true
:timeout: 10
:threads: null
```

Edit the URL field to point to your Foreman instance, and the SSL  fields for the hostname of the Puppet server (which may be the same  host). Paths to Puppet’s SSL certificates will be under  /var/lib/puppet/ssl/ and puppetdir will be under /var/lib/puppet when  using Puppet with non-AIO. More information on SSL certificates is at [Securing communications with SSL](https://theforeman.org/manuals/3.5/index.html#5.4SecuringCommunicationswithSSL).

Add the following lines to the [master] section of puppet.conf:

```
[master]
  external_nodes = /etc/puppetlabs/puppet/node.rb
  node_terminus  = exec
```

Restart the Puppet server. When the next agent checks in, the script will upload fact data for this host to Foreman, and download the ENC data.

The `--no-environment` option can be optionally specified to stop the ENC from being authoritative about the agent’s Puppet environment.  This can be useful in development setups where the agent may be run against different environments.

##### Client

No agent configuration is necessary to use this functionality.

##### Testing the config

Make sure that the puppet user can execute the ENC script and it works:

```
sudo -u puppet /etc/puppet/node.rb [the name of a node, eg agent.local]
```

should output something like:

```
parameters:
  puppetmaster: puppet
  foreman_env: &id001 production
classes:
  helloworld:
environment: *id001
```

This output should match the information displayed when you click on the YAML button on the Host page in Foreman.

For further information see the [Puppet Labs docs on external nodes](https://puppet.com/docs/puppet/latest/nodes_external.html)

##### Debugging the ENC

1. If Puppet agents receive empty catalogs, check the puppet.conf  master configuration has the ENC script configured.  Also check the  output of the ENC for the hostname logged by Puppet (which may be  different) to see if Foreman is reporting the correct configuration.
2. If the hostname.yaml facts file is missing, this is typically a Puppet misconfiguration.
3. Failures to upload facts or download the ENC data may be a network issue (check the URL and SSL settings) or an error on the Foreman  server.  Check /var/log/foreman/production.log for two requests, `POST "/api/hosts/facts"` and `GET "/node/client.example.com?format=yml"` and for any errors within the block of log messages.

#### Assigning data to hosts through the ENC

Foreman passes all associated parameters, classes,and class parameters, to the Host, including those inherited from host groups, domains, or global settings. See section [Managing Puppet](https://theforeman.org/manuals/3.5/index.html#4.2ManagingPuppet) for more information on assigning configuration to hosts.

#### Creating hosts in Foreman with facts

By default, Foreman adds hosts to its database that it learns about through facts, provided the “create_new_host_when_facts_are_uploaded” setting is enabled.

Locations and organizations can be inferred from the “foreman_location” or “foreman_organization” facts as supplied by the host.  The names of these facts can be changed with the “location_fact” and “organization_fact” settings respectively.  Foreman will update hosts on each fact upload based on the value of these facts.

If these facts aren’t supplied, then the “default_location” and “default_organization” settings can be used to set values globally when a host doesn’t have a location or an organization set.

More information in the [Configuration](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions) section.

#### Pushing facts to Foreman when not using the ENC functionality

There are several options for pushing fact data to Foreman if you are using Foreman for reporting/inventory only.

##### Using node.rb

The ENC script (node.rb) accepts an option to run in ‘batch-mode’. In this mode, the script iterates over the cached fact data stored on the Puppet server, and uploads all of it to Foreman.

Download and configure the node.rb script as above, and then call it like this:

```
sudo -u puppet /etc/puppetlabs/puppet/node.rb --push-facts
```

The following options are available for node.rb’s batch mode:

- `--push-facts` uploads all facts sequentially which have changed since the last run.
- `--push-facts-parallel` uploads all facts in parallel which have changed since the last run.  The number of threads is specified by the :threads setting or the number of processors.
- `--watch-facts` runs in the foreground and upload facts based on inotify events, used in conjunction with either –push-facts option.

##### Direct HTTP upload

Foreman’s fact-upload API endpoint accepts data in pure JSON. You can push data to Foreman as a hash containing:

```
{
  "name": "fqdn-of-host.domain.com",
  "certname": "optional-certname-of-host.domain.com",
  "facts": {
    "fact1": "string",
    "fact2": "true",
    "fact3": "1.2.3.4",
    ...
  }
}
```

The ‘certname’ is optional but will be used to locate the Host in Foreman when supplied. See [the API documentation](https://theforeman.org/api/3.5/apidoc/v2/hosts/facts.html) for more details.

This body can be POSTed to ‘/api/hosts/facts’ using Foreman API v2. See the [node.rb template](https://raw.githubusercontent.com/theforeman/puppet-puppetserver_foreman/master/files/enc.rb) for an example of constructing and sending data in Ruby.

### 3.5.6 CLI

The Command Line Interface is based on the [hammer](https://github.com/theforeman/hammer-cli) framework. The foreman-related commands are defined in plugin `hammer_cli_foreman`

#### Format and locations

Configuration is loaded from a set of directories in this order:

- `./config/hammer/` (config dir in CWD)
- `/etc/hammer/`.
- `~/.hammer/`
- custom location specified on command line - `-c CONF_FILE_PATH`

In each of these directories hammer tries to load `cli_config.yml` and anything in the `cli.modules.d` subdirectory which is the recommended location for configuration of hammer modules.

Later directories and files have precedence if they redefine the same option. Files from cli.modules.d are loaded in alphabetical order.

Hammer uses yaml formatting for its configuration. The config file template is contained in the hammer_cli gem.

```
gem contents hammer_cli|grep cli_config.template.yml
```

and can be copied to one of the locations above and changed as  needed. The packaged version of hammer copies the template to /etc for  you.

#### Plugins

Plugins are disabled by default. You have to edit the config file and enable them manually under `modules` option, as can be seen in the sample config below.

Plugin specific configuration should be nested under plugin’s name.

#### Options

- `:log_dir: <path>` - directory where the logs are stored. The default is `/var/log/hammer/` and the log file is named `hammer.log`
- `:log_level: <level>` - logging level. One of `debug`, `info`, `warning`, `error`, `fatal`
- `:log_owner: <owner>` - logfile owner
- `:log_group: <group>` - logfile group
- `:log_size: 1048576` - size in bytes, when exceeded the log rotates. Default is 1MB
- `:watch_plain: false` - turn on/off syntax highlighting of data being logged in debug mode

#### Sample config

```
:modules:
    - hammer_cli_foreman

:foreman:
    :host: 'https://localhost/'
    :username: 'admin'
    :password: 'changeme'

:log_dir: '/var/log/foreman/'
:log_level: 'debug'
```

## 3.6 Upgrade to 3.5

#### Scope

**These instructions apply to environments not using Katello**

If you’re using the [Katello](https://theforeman.org/plugins/katello) content management plugin scenario, please follow their upgrade instructions (which will also upgrade Foreman).

#### Preparation

**Before updating to 3.5, make sure you have successfully upgraded to 3.4 first.**

Upgrading across more than one version is not supported, so it’s required to upgrade to each intermediate version and follow all upgrade instructions for the previous versions.

Check the list of [Supported Platforms](https://theforeman.org/manuals/3.5/index.html#3.1.1SupportedPlatforms) when planning to upgrade, as these change between releases. If your OS is no longer supported by Foreman, migrate or upgrade the OS (if supported) using a release of Foreman supported by both OS versions before upgrading Foreman.

To provide specific installation instructions, please select your operating system:

#### Step 1 - Backup

It is recommended that you backup your database and modifications to Foreman files(config/settings.yaml, unattended installations etc).  Most upgrades are safe but it never hurts to have a backup just in case.

For more information about how to backup your instance head over to [Backup](https://theforeman.org/manuals/3.5/index.html#5.5.1Backup)

#### Step 2 - Perform the upgrade

Before proceeding, it is necessary to shutdown the Foreman instance.

  *No operating system selected.*

Now it’s time to perform the actual upgrade.

  *No operating system selected.*

#### Step 3 - Post-upgrade steps

##### Step 3 (A) - Database migration and cleanup

Make sure by executing database is migrated. It should produce no errors or output:

```
foreman-rake db:migrate
foreman-rake db:seed
```

You should clear the cache and the existing sessions:

```
foreman-rake tmp:cache:clear
foreman-rake db:sessions:clear
```

##### Optional Step 3 (B) - Reclaim database space

After database migrations, some space can sometimes be reclaimed. It’s a good idea to perform a *full* database vacuum for PostgreSQL rather than relying on the autovacuum feature to claim maximum space possible.

```
su - postgres -c 'vacuumdb --full --dbname=foreman'
```

##### Optional Step 3 (C) - Run foreman-installer

If you used foreman-installer to set up your existing Foreman instance we recommend running it again after upgrading. Note that the installer can modify config files so this may overwrite your custom changes. You can run the installer in noop mode so you can see what would be changed.

To see what would happen

```
foreman-installer --noop --verbose
```

You may see ERRORS such as `/Stage[main]/Foreman_proxy::Register/Foreman_smartproxy[foreman-hostname.domain]:` `Could not evaluate: Connection refused - connect(2)` due to httpd / apache2 service being stopped.  These can be safely ignored.

To apply these changes, run the installer again without options

```
foreman-installer
```

##### Step 4 - Restart

Start the application server. This is redundant if you previously ran `foreman-installer` in step 3B.

  **No operating system selected.**

#### Common issues

See [Troubleshooting](http://projects.theforeman.org/projects/foreman/wiki/Troubleshooting)

# 4. General Foreman

This section covers general information on using Foreman to manage  your infrastructure. It covers the features of the web interface,  managing puppet, provisioning systems and the installation and  configuration of Foreman Smart Proxies.

## 4.1 Web Interface

### 4.1.1 LDAP Authentication

Foreman natively supports LDAP authentication using one or multiple LDAP directories.

#### Setting up

Go to *Administer > LDAP Authentication*, click on *New LDAP Source* and enter the following details about the LDAP server:

- *Name*: an arbitrary name for the directory
- *Server*: the LDAP hostname, e.g. `ldap.example.com`
- *LDAPS*: check this if you want or need to use LDAPS to access the directory
- *Port*: the LDAP port (default is 389, or 636 for LDAPS)
- *Server type*: select the implementation if listed, else choose POSIX

Under the account tab, the details of an account used to read LDAP  entries is required if anonymous binds and reads are disabled.  This  should be a dedicated service account with bind, read and search  permissions on the user and group entries in the directory server.

This may use the variable `$login` which will be replaced by the login of the authenticating user, however this is deprecated and will result in reduced functionality (as it only works at authentication time).

- *Account*: leave this field empty if your LDAP server can be read anonymously, otherwise enter a user name that has read access
- *Account password*: password for the account, if defined above and when not using $login
- *Base DN*: the top level DN of your LDAP directory tree, e.g. `dc=example,dc=com`
- *Group base DN*: the top level DN of your LDAP directory tree that contains groups, e.g. `ou=Groups,dc=example,dc=com`
- *Use netgroups*: switcher that enables using netgroups  instead of standard LDAP group objects, supported only for FreeIPA and  POSIX LDAP server types
- *LDAP filter* (optional): a filter to restrict your LDAP queries, for instance: `(memberOf=cn=foreman-users,ou=Groups,dc=example,dc=com)`. Multiple filters can be combined using the syntax `(& (filter1) (filter2))`.

#### Trusting SSL certificates

When configuring an LDAPS connection, the certificate authority needs to be trusted. When using Active Directory Certificate Services, ensure to export the  Enterprise PKI CA Certificate using the Base-64 encoded X.509 format.

If your LDAP server uses a certificate chain with intermediate CAs,  all of the root and intermediate certificates in the chain must be  trusted.

On Red Hat based OSes:

```
cp example.crt /etc/pki/tls/certs/
ln -s example.crt /etc/pki/tls/certs/$(openssl x509 -noout -hash -in /etc/pki/tls/certs/example.crt).0
```

On Debian or Ubuntu, also ensure the file has a .crt extension:

```
cp example.crt /usr/local/share/ca-certificates/
update-ca-certificates
```

#### On the fly user creation

By checking *Automatically create accounts in Foreman*, any LDAP user will have their Foreman account automatically created the first time they log into Foreman.

You can assign multiple organizations/locations to your LDAP  authentication sources. This will assign users that are automatically  created to the set of organizations/locations associated with the LDAP  authentication source. Please notice this assignment happens only when  users are created automatically via LDAP, and not upon every login.

Changing the organization/location of a LDAP authentication source  will not automatically change these attributes on the users in that  authentication source.

To use this feature, the relevant LDAP attributes must be specified  on the next tab (e.g. firstname, lastname, email), as these will be used to populate the Foreman account.

#### Attribute mappings

Foreman needs to know how to map internal user account attributes to  their LDAP counterparts, such as login, name, and e-mail. Examples for  common directory servers are provided below.

Note that LDAP attribute names are *case sensitive*.

Foreman also has the ability to use a user’s photo stored in LDAP as  their Foreman avatar, by setting the jpegPhoto attribute mapping.

Additional Information:

- [Adding Display Pictures/Avatars to Red Hat IDM/FreeIPA](https://www.dalemacartney.com/2013/12/05/adding-display-picturesavatars-red-hat-idmfreeipa/)
- [Using the jpegPhoto attribute in Active Directory](https://docs.microsoft.com/en-us/archive/blogs/btrst4/using-the-jpegphoto-attribute-in-ad-part-i)

#### Examples

All of the examples below use a dedicated service account called  ‘foreman’.  This should be set up with bind, read and search permissions on the user and group entries and with a strong, random password.

##### Active Directory

Typically either LDAPS on port 636 or LDAP on port 389.

| Setting                 | Value                        |
| ----------------------- | ---------------------------- |
| Account                 | `DOMAIN\foreman`             |
| Base DN                 | `CN=Users,DC=example,DC=COM` |
| Groups base DN          | `CN=Users,DC=example,DC=com` |
| Login name attribute    | `userPrincipalName`          |
| First name attribute    | `givenName`                  |
| Surname attribute       | `sn`                         |
| Email address attribute | `mail`                       |

Note that previously we recommended using sAMAccountName as the login name attribute. It turned out that userPrincipalName is a better choice since it does not contain white spaces that can cause issues on user  creation.

##### FreeIPA

Typically either LDAPS on port 636 or LDAP on port 389.

| Setting                 | Value                                                        |
| ----------------------- | ------------------------------------------------------------ |
| Account                 | uid=foreman,cn=users,cn=accounts,dc=example,dc=com           |
| Base DN                 | `cn=users,cn=accounts,dc=example,dc=com`                     |
| Groups base DN          | `cn=groups,cn=accounts,dc=example,dc=com` or `cn=ng,cn=compat,dc=example,dc=com` if you use netgroups |
| Login name attribute    | `uid`                                                        |
| First name attribute    | `givenName`                                                  |
| Surname attribute       | `sn`                                                         |
| Email address attribute | `mail`                                                       |

##### OpenLDAP

Typically LDAP on port 389 and with anonymous queries (leave Account blank), unless configured otherwise.

| Setting                 | Value                           |
| ----------------------- | ------------------------------- |
| Account                 | `uid=foreman,dc=example,dc=com` |
| Base DN                 | `dc=example,dc=com`             |
| Groups base DN          | `dc=example,dc=com`             |
| Login name attribute    | `uid`                           |
| First name attribute    | `givenName`                     |
| Surname attribute       | `sn`                            |
| Email address attribute | `mail`                          |

#### Linking user groups to LDAP

A Foreman user group can be associated to a group stored in an LDAP  server, so membership of the LDAP group automatically adds a user to the Foreman user group.  User groups can be associated with roles, enabling users to log into Foreman and be automatically granted permissions via  their membership of an LDAP group.  Read more about permissions in the [Roles and Permissions](https://theforeman.org/manuals/3.5/index.html#4.1.2RolesandPermissions) section.

To configure the association, create or edit a user group via *Administer > User groups*.  The group name may be any value (no direct relation to the LDAP group).  Under the *Roles* tab, select roles granting permissions to Foreman, or tick the *Admin* checkbox to enable administrator level access.

On the *External groups* tab, click the *Add external user group* button to open a new form.  In the *Name* field, enter the exact name of the LDAP group (usually the common  name/CN) and select the server from the dropdown list of LDAP  authentication sources.  Click the *Submit* button to save changes.

When a user logs in for the first time (assuming on the fly account  creation), the ldap:refresh_usergroups cronjob runs (every 30 minutes by default) or the *Refresh* button is pressed next to the external user group entry, Foreman will synchronize the group membership from LDAP.

##### Security Disclaimer

Please remember your external user groups will only be refreshed  automatically through the ldap:refresh_usergroups cronjob. There can be a lapse of time cronjob runs, in which if the user groups in LDAP change, the user will be assigned to the wrong external user groups. This  situation can be quickly fixed by manually running `foreman-rake ldap:refresh_usergroups` or by refreshing the external user groups in the UI. Otherwise, the  problem will eventually get fixed when the cronjob runs again.

#### Active Directory password changes

When using Active Directory, please be aware that users will be able  to log in for up to an hour after a password change using the old  password. This is a function of the AD domain controller and not  Foreman.

To change this password expiry period, see [Microsoft KB906305](https://support.microsoft.com/en-us/kb/906305) for the necessary registry change.

#### Brute-force protection

Foreman allows only 30 failed attempts in the last 5 minutes per one  IP address by default. Any subsequent login attempts are not allowed and error message is shown: “Too many tries, please try again in a few  minutes.” If this is triggered by accident, the silent period can be  removed by deleting failed login cache entries:

```
find /usr/share/foreman/tmp/cache -name failed_login\*
```

This will only work when using the file store Rails cache implementation.

#### Troubleshooting

If you want to use on the fly user creation, make sure that Foreman  can fetch from your LDAP all the required information to create a valid  user. For example, on-the-fly user creation won’t work if you don’t have valid email addresses in your directory (you will get an ‘Invalid  username/password’ error message when trying to log in).

### 4.1.2 Roles and Permissions

A user’s access to the features of Foreman are constrained by the **permissions** that they are granted. These permissions are also used to restrict the  set of hosts, host groups and other resources that a user is able to  access and modify.

Note: a user with global admin enabled is not restricted by the  authorization system. This is the default for installations that do not  have :login:true in *config/settings.yml*.

A logged in user will be granted the **Default role**  role plus one or more additional roles. The permissions and filters  associated with these roles are aggregated and determine the final  permission set.

Roles may be administered by users with admin privileges or regular  users with ‘edit_roles’ permission. In order to add new filters and  permissions to a role, regular users must have the ‘create_filters’  permission.

#### Roles

These may be created, deleted and edited on the **Roles** page. Each role will contain permission filters, which define the  actions allowed in a certain resource. Once your role is created, you  can associate it with one or more users and user groups.

There is one built-in system role, ‘Default role’. This is a set of  permissions that every user will be granted, in addition to any other  roles that they have. Foreman provides you with a set of seeded roles.  These roles can be assigned to users but cannot be modified in any way.  They serve as a sane set of defaults and a quick starting point. If you  wish to base your custom role on one of these, you can clone it and  modify the clone.

Roles can be also associated to Locations or Organizations if these  are allowed. Unlike other objects this does not mean that Roles would be only available in a particular scope. Roles are always global for the  entirety of Foreman. The association means that filters of such role are scoped to a particular Organization or Location. Imagine you want to  create a role representing Administrator of Organization A. You can  clone an existing Organization admin role and associate it with  Organization A. If you later assign this role to some users, they will  be granted all admin permissions but only on resources of Organization  A. Note that some resources are not scopeable by Organization and  Locations. Filters for such resources grant permissions globally.

The seeded Organization admin role is similar to the Manager role.  They are both being automatically extended with permissions introduced  in new Foreman versions, as well as permissions introduced by plugins.  The difference is that Organization admin role does not contain  permissions for managing organizations, only for viewing them. Since  organization administrator does not usually need to create or modify  other organizations, the Organization admin role fits better this  scenario.

System admin role is a seeded role with very powerful abilities. The  purpose of this role is to set up environment for others to use. It can  create organizations/locations but does not have access to the resources inside them. System admin can create new users and assign them to  locations/organizations and add roles to the users. System admin can  view and edit settings. But most importantly, users with this role can  even delegate roles that they themselves do not own. Users having this  role can potentially step out of it by creating a new user with  roles/permissions that they do not have as System admin and log in as  the newly created user. Therefore only trusted users should be allowed  to have this role.

#### Filters

Filters are defined within the context of a role, clicking on the  ‘filters and permissions’ link. A filter allows a user to choose a **resource** (Hosts, Host groups, etc…) and the **permissions** that should be granted for that resource. After a filter has been  created, users given a role containing this filter will have the  permissions for the resource specified at the filter.

If the filter is marked as ‘Unlimited?’, the permissions created in  this filter will apply to all objects in the chosen resource. For  instance, if the resource is Host, and the permissions are ‘view’ and  ‘index’, and ‘Unlimited?’ is checked, users that have a role with this  filter will be able to ‘view’ and ‘index’ all hosts in the system.

When ‘Unlimited?’ is unchecked, a text box allowing to define more  granular filtering will be enabled. You can write a search query and  permissions in this filter will be applied to the results of that query  only. An example of a query for the resource Host could be ‘os =  RedHat’. In this case, the permissions in this filter will be applied  only to Hosts whose Operating System is set to Red Hat. You can test  your search queries at the index page of your resource, in this case  that would be ‘/hosts’.

Some example queries for the resource Host:

1. Ownership and domain membership: ‘owner_id = 95 and domain =  localdomain’ -  Will apply permissions to hosts owned by User with id 95 and in the domain ‘localdomain’
2. Compute resource membership: ‘compute_resource = Openstack’ -  Will apply permissions to hosts deployed on compute resource Openstack.
3. Fact filtering: ‘facts.alarmlevel = high’ - Will apply  permissions to hosts with a fact ‘alarmlevel’ with value ‘high’. As a  fact is only generated during a puppet run, this filter will only refer  to machines that have been built and therefore cannot be used to  restrict the creation of machines.

These pools of queries can be combined by adding them together or the filters can be used to restrict the selected resource to a smaller and  smaller subset of the total. Think of them as set operations.

As already mentioned, a Role can be assigned to Organizations and  Locations. In such case, all filters for resources that support such  scoping automatically apply the same Organizations and Locations. If you want to combine filters with different Organizations or Locations  assignments, you can use ‘Override’ check box. When checked you can  override Organizations and Location for a filter. If you uncheck this  field, the filter starts inheriting its role Organizations and Locations after submitting again. If you want to reset all role filters to start  inheriting, you can use ‘Disable all filters overriding’ button on  role’s ‘Filters’ tab.

![Disable all filters override](https://theforeman.org/static/images/screenshots/4.1.2_filters_override.png)

We recommend managing Organizations and Locations association on Role level to keep the setup simple and clear.

Note: If the “Administrator” check box is checked for a user, filtering will not take effect.

#### Permissions

These determine the operations that are allowed to be performed upon  the resources to which they refer. For a few simple items like  bookmarks, this operates as expected - it grants permission for all  bookmarks. But for most resources, such as the hosts a user is able to  operate on, there is an additional layer of security called filtering.

When editing a filter there is a search field at the bottom that  narrows the scope of the permissions granted to a subset of the resource objects. Most permission types support this search field however there  are some exceptions. The permission for creating objects can’t be  limited by a search query because the object does not exist during  creation. Therefore a user is granted the create permission if they are  associated with any filter containing this permission (limited by search or not).

Following table lists some of permissions and their impact:

| Permission                                                   | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ***Permissions for Architectures,  Authentication providers, environments, External variables, Common  parameters, Medias, Models, Operating systems, Partition tables, Puppet  classes and User groups\*** |                                                              |
| view                                                         | The user is allowed to see this type of object when listing them on the index page |
| create                                                       | The user is allowed to create this type of object            |
| edit                                                         | The user is allowed to edit this type of object              |
| destroy                                                      | The user is allowed to destroy this type of object           |
| ***Permissions for Domains\***                               |                                                              |
| view                                                         | The user is allowed to see a list of domains when viewing the index page |
| create                                                       | The user is allowed to create a new domain and will also be able to create domain parameters |
| edit                                                         | The user is allowed to edit a domain and will also be able to  edit a domain's parameters. If they have domain filtering active in  their profile then only these domains will be editable |
| destroy                                                      | The user is allowed to destroy a domain and will also be able  to destroy domain parameters. If they have domain filtering active in  their profile then only these domains will be deletable |
| ***Permissions for Host groups\***                           |                                                              |
| view                                                         | The user is allowed to see a list of host groups when viewing the index page |
| create                                                       | The user is allowed to create a new host group and will also be able to create host group parameters |
| edit                                                         | The user is allowed to edit a host group and will also be able to edit a host group's parameters. If they have host group filtering  active in their profile then only these host groups will be editable |
| destroy                                                      | The user is allowed to destroy a host group and will also be  able to destroy host group parameters. If they have host group filtering active in their profile then only these host groups will be deletable |
| ***Permissions for Hosts\***                                 |                                                              |
| view                                                         | The user is allowed to see a list of hosts when viewing the index page. This list may be constrained by the user's host filters |
| create                                                       | The user is allowed to create a new host. This operation may be constrained by the user's host filters |
| edit                                                         | The user is allowed to edit a host. This operation may be constrained by the user's host filters |
| destroy                                                      | The user is allowed to destroy a host. This operation may be constrained by the user's host filters |
| ***Permissions for Users\***                                 |                                                              |
| view                                                         | The user is allowed to see a list of users when viewing the  index page. A user will always be able to see their own account even if  they do not have this permission |
| create                                                       | The user is allowed to create a new user                     |
| edit                                                         | The user is allowed to edit existing users. A user will always be able to edit their own basic account settings and password |
| destroy                                                      | The user is allowed to delete users from the system          |

### 4.1.3 Trends

Trends and statistics are moved to the separate plugin. See [manual](https://theforeman.org/plugins/foreman_statistics) for the reference.

There is a rake task `foreman-rake purge:trends` for users who are not planning to use trends and statistics anymore and wish to clean up database.

### 4.1.4 Auditing

Foreman supports auditing of almost all changes that happen within  Foreman, from both the UI and from the API. Auditing is done at a user  level, and is thus ineffective if *:login:* is set to *false*, as all audits will be done as the ‘admin’ user.

#### Basic View

Go to the Audit tab to see a view of what has changed. This view can  be filtered by the type of change or by the object that was altered (e.g.  search for a hostname to see all changes relating to that host). You also get  the parent object - so if a parameter was modified, you can see what  host/group that parameter belongs to. The timestamp of the change and  the user who performed it will be listed.

#### Extended Audits for Templates

Template changes also store a diff of the changes, and the ability to roll back to a previous version of the template.

#### Expire old audits automatically

You will probably want to delete your old audits after some time. To achieve this, there is a cronjob. This job invokes  rake task `audits:expire`. There is no default value for number of days to keep because every user has different needs.  However, you can configure an amount of days to keep in Foreman in Settings (`Administer -> Settings -> General (Tab) -> Save audits interval`) to fit to your needs. You can leave value empty to no expire old  audits. Also this task can be invoked manually whenever required.  Invocation can be done by `foreman rake audits:expire`. If the `days` parameter is not provided, the task is trying to take configured value from `Settings`. If this value is also empty, task is closed and no audits are expired.

Available parameters:

- days => number of days to keep audits (defaults to 90)

Examples:

1. Expires all audits older then 7 days

```
foreman-rake audits:expire days=7
```

#### Anonymize old audits

Here, anonymization clears links to user accounts and their IP addresses, but keeps all other audit data in database.

You can anonymize your old audits instead of deleting the audit entries. Use task `foreman-rake audits:anonymize` for this similarly to `audits:expire`.

Example:

1. Anonymizes all audits older then 7 days

```
foreman-rake audits:anonymize days=7
```

#### Organizations and Locations

Audits inherit organizations and locations of resources for which  they have been created. Imagine you have a subnet assigned to  organization A. Whenever you modify this subnet, the audit will be  visible only in organization A. When you later add this subnet to  organization B, new audits will appear in both organizations A and B.  All audits created previously remain untouched. Resources that can’t be  assigned to any organization or location will be always visible in all  organizations and locations, meaning the change has affected all  organizations and locations.

#### Audit history

Audited resources can change in time, e.g. they have new attributes.  Also audit definitions changes, e.g. new association starts to be  tracked in new version of Foreman. All these changes only apply to newly created audits, old audits can’t be updated and will always contain  only data known back in time they were created. Starting with Foreman  1.20, audits are scoped to organizations and locations. All audits  created before are unassigned, meaning only admin can see them.

### 4.1.5 Searching

Each page in Foreman has its own search functionality, which is  centred around the resources that it manages, allowing searching based  on attributes of the resources in the list or resources that they’re  associated to.  The search box also features powerful auto-completion to help build up search queries and free text search on many pages.  The  search functionality can also be used in the API when listing resources, see [Customize JSON Responses](https://theforeman.org/manuals/3.5/index.html#5.1.4CustomizeJSONResponses) for details.

#### General usage

Searching is through “field = value” or free text queries, which can  be combined with logical operators (and, or, not) and parentheses to  handle more complex logic.  To give some examples:

- `name = client.example.com` on the host list would show the host(s) whose hostname is client.example.com
- `hostgroup = "Web servers" and domain != lon.example.com` would show hosts in the Web servers host group, but not in the lon.example.com domain
- `Web servers` would show all hosts with that text anywhere, e.g. as their host group name or in the comment field

The fields available depend on the type of resource that’s being  searched, and the names of the attributes vary depending on the context.  The “name” field on the host groups list is equivalent to the  “hostgroup” field on the hosts list.  Requests to add additional  searchable fields are welcome, and may be filed in the “Search” category [in the bug tracker](https://theforeman.org/contribute.html#Bugreporting).

The search engine is provided by the scoped_search library, which maps search queries directly to SQL queries.  The [Query Language](https://github.com/wvanbergen/scoped_search/wiki/Query-language) documentation provides A more complete specification of the syntax available.

#### Bookmarks

Foreman supports the ability to make search bookmarks, allows users  to quickly jump to predefined search conditions.  Available bookmarks  can be selected from the dropdown menu to the right of the search box,  or managed from *Administer > Bookmarks*.

Some of the bookmarks are provided by default, e.g. to search for active or inactive hosts, or to only view reports with events.

To save a query, Use the dropdown menu to the right of the search box and click “Bookmark this search”.  When saving, the bookmark can be  labeled as public, so all other users are able to see and use it too.

#### Free text search

If you ignore the auto-completer and just enter text in the search  field, Foreman will try searching for that text across multiple fields.

For example, if you just enter `12` in the hosts search box, the results will include all hosts with 12 in  their IP address, MAC address or name.  In general the fields used for  free text search are kept to a minimum for performance and accuracy  reasons.  It’s preferable to search using a specific field, e.g. when  searching for an IP address, use `ip ~ 12` instead of `12`.

#### Searching for present/empty values

The “has” operator matches values that are present, e.g. to search for hosts that are on a compute resource, use `has compute_resource`.

Similarly, this can be negated, so to search for hosts without host groups, you can use `not has hostgroup`.

#### Case sensitivity

When querying using `=` and `!=` operators then exact, case sensitive matches will be returned.  When running `~` (like) and `!~` (unlike) operators, the matching is case insensitive.

#### Quoting

In search queries, white spaces are used as a delimiter. Here are some examples of the way a query will be interpreted:

- `description ~ "created successfully"`: list all notifications that contain “created successfully”
- `description ~ created successfully`: list all notifications that contain “created” and at least one of its text fields contains “successfully”
- `description !~ created successfully`:  list all notifications that doesn’t contain “created” and at least one of its text fields contains “successfully”

In the second and third example, “successfully” is an additional term that is interpreted as a free text search

#### Wildcards (‘_’, ‘%’, ‘*’)

The `~` and `!~` search operators are translated to the `LIKE` and `NOT LIKE` SQL queries respectively, which support two basic wildcards, `_` and `%`.

`_` is a wildcard for a single character replacement. For example, the search `name ~ fo_` will match both “foo” and “for”.

The `%` and `*` wildcard will replace zero or more characters. For example, the search `name ~ corp%` will match both “corp” and “corporation”. The more common ‘*’ wildcard is not a SQL wildcard but may be used instead.

When the `~` or `!~` search is processed, a ‘%’ wildcard is automatically added at the  beginning and end of the value if no wildcard is used, so it will by  default match at any location inside a string.  For example, the search `name ~ foo` is equivalent to `name ~ %foo%` and the search `name ~ foo%` will only match “foo” at the beginning of the value.

#### Date-time search query syntax

Many date and time formats are accepted in search queries.  Here are some examples:

- “30 minutes ago”, “1 hour ago”, “2 hours ago”, Today, Yesterday
- “3 weeks ago”, “1 month ago”, “6 days ago”, “July 10,2011”

The date can have different separators, “10-July-2011” will be  interpreted in the same way as “10/July/2010” or “10 July 2011” Month  names may be the full English name or a three letter abbreviation, e.g.  “Jan” will be interpreted as “January”.  Many other formats are also  acceptable, however it is not recommended to use ambiguous formats such  as “3/4/2011”

The valid date time operators are ‘=’, ‘<’ and ‘>’ which are  interpreted as ‘at’, ‘before’ and ‘after’ respectively. This is how the  search term interpeted:

The right hand part of a date-time condition is parsed and translated into a specific date-time, “30 minutes ago” is translated to “now - 30  minutes”.

- `last_report > "2011-07-01 12:57:18 EDT"` should be read as created after this time
- In the same way, `last_report > "30 minutes ago"` should be read as “created after 30 minutes ago” and not “created more then 30 minutes ago”

A search query like `installed_at = Yesterday` is translated into a period query, it will be translated at runtime to  match a range of date-times. For example, if running on Jan 1, it would  be translated into “(installed_at >= Jan 1,2012 00:00) and  (installed_at < Dec 31,2011 00:00)”.

### 4.1.6 User Management

Foreman is all about hosts and users interacting with these hosts.

#### SSH Keys

Each Foreman user can have multiple SSH keys assigned when editing a  user. These keys alone do not serve any purpose, but are available for  use in provisioning templates and can be accessed via ENC data. They  provide an easy way to manage users and login ssh keys on hosts without  the need for LDAP. If you want users to be able to login to a host using the data provided  in Foreman, you need to include the `create_users` snippet in your provisioning template. There is a [puppet module](https://github.com/ekohl/puppet-foreman_simple_user) available to keep user data in sync with Foreman and your hosts.

## 4.2 Managing Puppet

In this section we’ll look at the various ways we can control and interact with Puppet.

### 4.2.1 Environments

Puppet environments are mapped directly into Foreman. They can be  used at various levels throughout the Foreman interface. Puppet  environments are generally used to separate classes from different types of Host, typically allowing changes to a module to tested in one  environment (e.g. development) before being pushed to another (e.g  production).

#### Defining environments

There are several ways to create Puppet environments within Foreman.

##### Importing from Puppet

Foreman can detect all the environments and classes contained on a  Puppet server, and import them automatically. To do this, go to *Configure > Environments* and click on *Import from <proxy-name>*. Foreman will scan the Puppet server via the Smart Proxy, and display a  confirmation of the detected changes. Select the changes you wish to  apply and confirm.

More information about configuring the Smart Proxy to read environments and Puppet classes is in the [Smart Proxy Puppet](https://theforeman.org/manuals/3.5/index.html#4.3.6Puppet) section.

Note that the Smart Proxy will only detect environments that contain  one or more Puppet classes, so ensure that at least one Puppet module  containing a class has been deployed to the Puppet server.

##### Manual creation

To create an environment by hand, simply go to *Configure > Environments* and click *New Puppet Environment*. Give the new environment a name and save.  Note that if the environment doesn’t exist on the Puppet server and you subsequently run an import  (above), Foreman will prompt for the environment to be deleted.

#### Assigning environments to hosts

This is done from the Host Edit page, on the Host tab. Selecting an  environment will filter the classes visible on the Puppet Classes tab to just the classes in the selected environment.

You can also also mass-assign an environment to a group of hosts -  tick the checkboxes of the required hosts in the Hosts list, and then  select *Change Environment* from the *Select Action* dropdown menu at the top of the page.

#### Environments with host groups

You can assign an environment to a hostgroup as well. This functions  as a form of default - a user creating a new host and selecting the hostgroup will automatically have the environment pre-selected. The user is not  prevented from changing the environment of the new host, it simply saves a few clicks if they are happy with it.

### 4.2.2 Classes

Puppet classes are generally imported from the Puppet server(s) via the Import button on the Puppet Classes page. They can also be created by hand, and manually associated with a set of environments (for filtering purposes).

#### Importing Classes

Go to *Configure > Classes* and click the Import button.  This will not be visible unless you have at least one Puppet server with a puppet-enabled Smart Proxy. Only classes from modules will be  imported, and the Puppet manifests *must* be valid in order for the Smart Proxy to parse them.  Use `puppet parser validate` to test the syntax of Puppet manifests.

More information about configuring the Smart Proxy to read environments and Puppet classes is in the [Smart Proxy Puppet](https://theforeman.org/manuals/3.5/index.html#4.3.7Puppet) section.

##### The “Hosts” Column

Under *Configure > Classes* you will also see a column  called “Hosts”. This column represents the number of hosts the given  module/class has been assigned to. Clicking this figure will list the  hosts.

##### Ignoring classes on import

It’s often to have a module structure like this:

```
$ tree git/
git/
└── manifests
    ├── init.pp
    ├── install.pp
    ├── params.pp
    └── repo.pp
```

In this situation, Foreman would offer to create:

```
git
git::install
git::params
git::repo
```

However, if we know that the subclasses are not intended for direct  consumption, but are only really part of the internal structure of the  module, then we would want to exclude those from the import mechanism,  so that Foreman only offers to import *git*. We can achieve this via the file */usr/share/foreman/config/ignored_environments.yml*.

This file is read during each import, causing Foreman to ignore  changes to the listed environments or Puppet classes that match the  expressions in the file. It will not delete any environments or classes  already in Foreman.

Entire environments can be ignored with this configuration:

```
:ignored:
  - development
  - testenv
```

Classes can be ignored using a set of regular expressions - any class which matches one of them will not be imported. So, for the above  example, we might configure:

```
:filters:
  - !ruby/regexp '/install$/'
  - !ruby/regexp '/params$/'
  - !ruby/regexp '/repo$/'
```

Regular expression features such as negative lookaheads can be used  for more advanced filtering, e.g. to ignore all classes except for those starting with “role::”, the following syntax can be used:

```
:filters:
  - !ruby/regexp '/^(?!role::)/'
```

#### Assigning classes to hosts

To cause Puppet to apply your classes, you will need to assign them to your hosts.  This can be achieved in a number of ways - the best method may vary depending on how many classes you intend to assign and whether any parameters need to be overridden.

##### Individual host assignment

When editing a host, Puppet classes may be assigned directly under the *Puppet Classes* tab.  All classes that are in the Puppet environment selected on the first *Host* tab will be listed.

##### Via a host group

Host groups tend to correspond to an infrastructure role as each host may be assigned to a single host group, and typically inherits most of its Puppet classes in this way.

Puppet classes can be assigned by editing the host group and selecting them on the *Puppet Classes* tab.

Most host group attributes are copied to a host when it is created, however Puppet class associations remain inherited from the host group throughout its lifetime.  Any change to a host group’s assigned Puppet classes or parameters will affect any host with that host group set.

The Puppet environment attribute may be different on the host to the host group, which means that Puppet classes assigned to the host group may not exist in the host’s own Puppet environment.  Any Puppet classes that are inherited from the host group, but do not exist in the host’s environment will be left out when Foreman renders the ENC (YAML) output.  Check under *Configure > Puppet classes* that the classes are available in both the host group and host environments if they differ.

You can also also mass-assign a host group to a number of hosts - tick the checkboxes of the required hosts in the Hosts list, and then select *Change Group* from the *Select Action* dropdown menu at the top of the page.

##### Using config groups

A config group provides a one-step method of associating many Puppet classes to either a host or host group.  Typically this would be used to add a particular application profile or stack in one step.

To create a config group, click on *Configure > Config groups*, click *New Config Group*, enter a name and select the desired Puppet classes.  When editing either a host or host group, the new config group can be added at the top of the *Puppet Classes* tab.

Config groups are not specific to an environment and so only those Puppet classes that are in the host’s environment when rendering the ENC (YAML) will be listed.  Any classes that are not listed in the environment (as per *Configure > Classes*) will be left out.

Note that it isn’t possible to use a smart class parameter override with a config group, as a host may have many config groups with no way to define an order of precedence.  Overrides should be made on a host group, host or other attribute.

##### Checking the results

To see how Foreman is passing the classes to Puppet, go to a Host and click the YAML button. You will be shown the exact YAML data sent to  the Puppet server - the classes will be in the “classes” hash.

### 4.2.3 Parameters

Foreman can pass two types of parameters to Puppet via the ENC ([External Node Classifier](https://docs.puppetlabs.com/guides/external_nodes.html)) interface - global parameters (accessible from any manifest), and class parameters (scoped to a single Puppet class).  These can be added in a  number of ways through Foreman.

Generally speaking, it’s best to use class parameters where possible, as this makes designing, using and sharing Puppet modules and classes  easier.  The class may clearly specify which parameters it expects,  provide sensible defaults and allow users to override them.  Foreman is  also able to import information about class parameters automatically,  making it easier to consume new classes without needing to know and  enter the precise names of global parameters.

#### Types of parameters in Puppet

In Puppet’s DSL, accessing a global parameter or variable is done using `$::example` (preferred) or `$example` for a parameter named “example” in Foreman.  More information about accessing variables is available in the [Puppet Language: Variables](https://docs.puppetlabs.com/puppet/latest/reference/lang_variables.html#syntax) documentation.  When looking at the ENC (YAML) output from Foreman, a global parameter will look like this:

```
parameters:
  example: "foo bar"
```

When using class parameters, a [class will first be defined](https://docs.puppetlabs.com/puppet/latest/reference/lang_classes.html#defining-classes) with a parameter and may be accessed either using the local name or fully-qualified, e.g.

```
class example($setting) {
  notice($setting)
  notice($::example::setting)  # fully-qualified
}
```

When looking at the ENC (YAML) output from Foreman, a class and class parameter will look like this:

```
classes:
  example:
    setting: "foo bar"
```

#### Types of parameters in Foreman

Global parameters in Foreman can be added in the following places:

- Globally, per-resource (e.g. host group, domain) or per-host
- [Smart variables](https://theforeman.org/manuals/3.5/index.html#4.2.4SmartVariables)

Class parameters in Foreman can be set in:

- [Puppet classes, as a smart class parameter](https://theforeman.org/manuals/3.5/index.html#4.2.5ParameterizedClasses)

#### Global parameters

Host inherit their list of global parameters from the following locations, in order of increasing precedence:

- Globally defined parameters, under *Configure > Global parameters*.  These apply to every host.
- Organization-level parameters, under *Administer > Organizations > edit > Parameters*.
- Location-level parameters, under *Administer > Locations > edit > Parameters*.
- Domain-level parameters, under *Infrastructure > Domains > edit > Parameters*.
- Subnet-level parameters, under *Infrastructure > Subnets > edit > Parameters*.
- Operating system-level parameters, under *Hosts > Operating systems > edit > Parameters*.
- Host group-level parameters, under *Configure > Host groups > edit > Parameters*.
- Host parameters, under *Hosts > All hosts > edit > Parameters*.

The final (most specific) level of global parameters applies only to a single host. Edit a Host and switch to the *Parameters* tab, and you will see all of its inherited parameters from the previous levels. You can override any of these previously-defined parameters or  define new ones here.

Global parameters support multiple data types and validation as per  type selected. With types support, searching by parameter value is no  longer allowed.

#### Checking the results

To see how Foreman is passing the parameters to Puppet, go to a Host  and click the YAML button. You will be shown the exact YAML data sent to the Puppet server - the parameters will be in the “parameters” hash.

### 4.2.4 Parameterized Classes

Parameterized class support permits detecting, importing, and  supplying parameters direct to classes which support it, via the ENC.   This requires Puppet 2.6.5 or higher.

#### Setup

By default, parameterized class support is enabled in Foreman.  This can be checked from *Administer > Settings > Puppet* and ensure *Parametrized_Classes_in_ENC* is set to *true*.

![Settings](https://theforeman.org/static/images/screenshots/param_classes/settings.png)

Now you’ll need to import some parameterized classes from your Puppet server. If you don’t have any parameterized classes in your modules dir, the foreman-installer has several, you can download a few modules from the Puppet Forge. Once you have some parameterized modules, import your classes (see [**4.2.2 Classes**](https://theforeman.org/manuals/3.5/index.html#4.2.2Classes))

![Import](https://theforeman.org/static/images/screenshots/param_classes/1.17/import.png)

#### Configure a class

This example will work with the *foreman* class from the installer. Click on the class, and you should get a page with 3 tabs, like so:

![3 Tabs](https://theforeman.org/static/images/screenshots/param_classes/3tabs.png)

The middle tab, “Smart Class Parameter”, is the important one. Click onto that, and you should see something like this:

![Edit](https://theforeman.org/static/images/screenshots/param_classes/1.14/edit.png)

On the left, we have a list of possible parameters that the class  supports. On the right, we have the configuration options for the  parameter selected.

Lets configure the *foreman* class to change the user the foreman processes run as. Select the *user* parameter, at the end of the list. Now lets go through the options:

- Key    

  - This can’t be edited, it’s just for information

- Description    

  - Purely informational textbox for making notes in. Not passed to Puppet, or reused anywhere else

- Puppet Environments    

  - This can’t be edited, it’s just for information

- Override (

  important

  )    

  - If this is unchecked, Foreman will not attempt to control this variable, and it will not be passed to Puppet via the ENC.

- Key type    

  - The type of data we want to pass. Most commonly a string, but  many other data types are supported. There’s no easy way to tell what  type of data Puppet is expecting, so you will need to read through the  code/documentation that comes with a particular module to find out.  Changing the type field requires an appropriately set “Default Value”  field.

- Default Value    

  - This will be imported from Puppet initially, but if Puppet is  using any class inheritance, you’ll get something unhelpful like  “${$foreman::params::user}”. This is because Foreman won’t follow the  inheritance, so you’ll need to set a sensible default value

- Omit    

  - Should the parameter be omitted from the ENC provided to  puppet by default. This is useful if you want to use the puppet default  in most cases, but want to override the value just in certain cases  specified by the matchers.

- Hidden value    

  - Should the values of the smart class parameter be hidden in the UI.

Ok, so let’s configure our *user* parameter. We want to tick Override, set type to “String” and set the default value to “foreman”, like so:

![User Param](https://theforeman.org/static/images/screenshots/param_classes/1.14/user_param.png)

Tip: you can set Override on all  parameters on a class from the Puppet classes list, clicking the  dropdown menu on the right and clicking "Override all parameters".

#### Default value

Most importantly, the *Override* option has to be enabled for  Foreman to control this variable, otherwise it will never be managed and will not appear in the ENC output.

The *Default value* will be supplied in the ENC output and  should be a supported value, such as a string, YAML or JSON structure or use template features (see following sections).  When the *Omit* checkbox is enabled, no default value will be present in the ENC output unless an override matches.  Puppet will instead use the class default  or data binding (Hiera) as usual.

The default will be imported from the Puppet manifest initially, but  if the class uses an inherited params pattern, it may contain an  unhelpful string such as `${$foreman::params::user}`.  Foreman is unable to parse the actual value in this case as it might  change when evaluated.  Change the suggested default to the actual  value, or tick the *Omit* checkbox.

![Omit](https://theforeman.org/static/images/screenshots/param_classes/1.14/omit.png)

#### Setting up matchers

We’ve configured the default, but that’s not very useful. We need to  be able to override the default for hosts or groups of hosts. To do that we need the “Override Value For Specific Hosts” section at the bottom  of the page.

Let’s say that any machine in the “development” Puppet environment  should use a value of “foremandev” instead of “foreman” for the “user”  parameter. Add “environment” to the end of the matchers list, then click the “New Matcher-Value” button, and fill it out like this:

![Matcher](https://theforeman.org/static/images/screenshots/param_classes/1.14/matcher.png)

This is a basic configuration - for more complex examples of using matchers, see the [Smart Matchers](https://theforeman.org/manuals/3.5/index.html#4.2.6SmartMatchers) section.

#### Overriding a parameter for a host

If Foreman manages the value of a class parameter (“override =  true”), it’s also possible to update a host-specific override from the  host itself. That way you don’t have to grant access to the Puppet  Classes page to everyone. From a Host, click Edit, go to the Parameters  tab, and you’ll see the variable, the class-scope, and the current  value. You can then override the value for that host:

![Host Edit](https://theforeman.org/static/images/screenshots/param_classes/1.14/hostedit.png)

If the value is hidden you can click the unhide button to temporarily see the value while you edit. Clicking the button won’t change the  hidden property for the parameter, only show it for editing purpose.

![Hide button](https://theforeman.org/static/images/screenshots/param_classes/1.14/hide_button.png)

If you go back and look at the Puppet class, you’ll see Foreman has added a matcher for that host:

![Host Matcher](https://theforeman.org/static/images/screenshots/param_classes/1.10/hostmatch.png)

The same override button is available on a host group’s *Parameters* tab.  For more complex logic, like matching on facts, use the Puppet Class page.

#### Advanced usage

Smart class parameters are based on the smart matchers technology,  and have a number of advanced features such as validation and multiple  data types. More about these can be found in the [Smart Matchers](https://theforeman.org/manuals/3.5/index.html#4.2.6SmartMatchers) section.

### 4.2.5 Smart Matchers

The smart matching technology underpins smart class parameters, so is described below.  It provides the following features for each  parameter:

1. A default value that can be sent if no specific match is found.
2. An order of precedence for overrides, based on host attributes or facts.
3. A list of overrides (matchers).
4. Specifying a data type, allowing strings, integers and data structures to be passed natively to Puppet.
5. Optional validation of values.
6. Template processing of values for dynamic content.

#### Ordering

Overrides are processed in the order of precedence set in the *Order* field, from most to least specific (first match wins, unless merging is enabled).  This is a list of host attributes and fact names that  overrides will be checked against.  If no override from this list  matches, the default value is used.

Example attributes that may be listed are:

- `fqdn` - host’s FQDN (“host.example.com”)
- `hostgroup` - full name of the host group, including parents (“Europe/Web  servers”). Matchers on host groups can be inherited by their children,  see documentation for `matchers_inheritance` in [configuration options.](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions)
- `os` - name and version of operating system (“RedHat 6.4”)
- `domain` - host’s domain name (“example.com”)
- `location` or `organization` - full name of the location/organization, including parents  (“Company/Subsidiary”). Matchers on location/organization can be  inherited by their children, see documentation for `matchers_inheritance` in [configuration options.](https://theforeman.org/man    uals/3.5/index.html#3.5.2ConfigurationOptions)
- `is_virtual` - a fact [supplied by Facter](https://docs.puppetlabs.com/facter/latest/core_facts.html#isvirtual)

The default order is set under *Administer > Settings > Puppet > Default_variables_Lookup_Path* and is “fqdn”, “hostgroup”, “os”, “domain”.

Note that there’s a name conflict between the “operatingsystem” fact  and Foreman’s attribute “operatingsystem” (same as “os” above), and  Foreman’s attribute will be the one that is used, so will include the  version number.

#### Overrides / matchers

Once defaults have been filled in for your parameter, you can then add criteria to match against - click the *Add Matcher* button under your parameter, and more input fields will appear:

| Attribute type | Should state a name = value relationship that Foreman use to match against the entries in the order list |
| -------------- | ------------------------------------------------------------ |
| Value          | What the parameter should be in the ENC, if this rule is matched |
| Omit           | Instead of providing a value, this parameter will not be  supplied in the ENC output (use to prevent a default value being  returned) - only for smart class parameters |

As an example, let’s say that any machine in the “development” puppet environment should use a value of “foremandev” instead of “foreman” for the “user” parameter. Add “environment” to the end of the matchers  list, then click the *Add Matcher-Value* button, and fill it out like this:

![Matcher](https://theforeman.org/static/images/screenshots/param_classes/1.14/matcher.png)

The match field currently supports string equality only, the values must match exactly.

##### Merging overrides

When the data type is a hash or array, ticking *Merge overrides* will cause values from every override that matches (e.g. an FQDN *and* domain) to be merged together.

Merging is “deep”, so nested hashes and arrays will gain values rather than being overwritten entirely.

The *Merge default* option adds the default value as one of  the values to merge, it will get the least important priority so one of  the other values may overwrite it.

When the data type is an array, the *Avoid duplicates* option will de-duplicate the resulting array.

#### Data types

The type of data we want to pass to Puppet can be set in the *Parameter type* field.  Most commonly a string, but many other data types are supported:

- String - Everything is taken as a string.
- Boolean - Common representation of boolean values are accepted, including true, false, yes, no etc.
- Integer - Integer numbers only, can be negative.
- Real - Accept any numerical input.
- Array - A valid JSON or YAML input, that must evaluate to an array.
- Hash - A valid JSON or YAML input, that must evaluate to an object/map/dict/hash.
- YAML - Any valid YAML input.
- JSON - Any valid JSON input.

There’s no easy way to tell what type of data the Puppet manifest is  expecting, so you will need to read through the code/documentation that  comes with a particular module to find out. Changing the type field  requires an appropriately set “Default Value” field.

##### Complex data

Here’s an example of adding an array parameter. Note the use of YAML in the edit box:

![Array](https://theforeman.org/static/images/screenshots/param_classes/1.14/array.png)

This will be converted to the JSON `["a","b"]` syntax when you save. You can also use hashes in YAML or JSON as data types too.

Note that the JSON hash syntax is not the same as Puppet’s hash syntax: `{"example":"value"}`

#### Input validation

The *Optional input validator* section can be used to restrict the allowed values for the parameter.  It is important to note that the validation applies to changes made from the Host edit page as well as  the Puppet Classes edit page.

The input validation section is hidden by default but can be opened  by clicking on its title. When changing the parameter type this section  will be automatically expanded to change the validations according to  the new type.

| Validator type | A combobox of data types. The type applies to the next field, the validator. |
| -------------- | ------------------------------------------------------------ |
| Validator rule | Used to enforce certain values for the parameter values. See below for examples. |

For example, to restrict the “user” field to either “foreman” or “foremandev”, tick the Required checkbox, and then set:

- Type: List
- Rule: foreman,foremandev

![Validators](https://theforeman.org/static/images/screenshots/param_classes/1.14/validators.png)

##### String validators

At present, the string type cannot be validated - leave the validator field blank, and all strings in the variable will be considered  acceptable

##### Regexp / List validators

By entering a list (comma-separated, no spaces) or a regex (no  delimiter required), the value to be assigned to the parameter will be  checked against this list. If the value does not match the validator,  and error will be raised.

#### Template variables

Because Foreman offers templating capabilities, you can utilise  pre-existing variables, macros and or functions within your  parameterized classes. This is especially useful if you need to send a  string to Puppet, but have a need to embed host specific information  within the string, such as the host’s FQDN.

Let’s look a quick example situation: we need to configure RabbitMQ  and have it use our existing Puppet SSL certs. Using what we’ve learnt  above, we jump into the RabbitMQ class and configure the “ssl cert”  parameter as such:

![Template Variable](https://theforeman.org/static/images/screenshots/param_classes/1.14/template-variable-rabbit-ssl-cert.png)

As you can see we’re utilising a template variable within the  parameter’s string just like we would in a normal template file. The  important part of this string, as we’re sure you’ve gathered, is the  “@host.name” element. This pulls the FQDN from Foreman’s facts and  inserts it into the string.

More information regarding templates can be found [**on the wiki**](http://projects.theforeman.org/projects/foreman/wiki/TemplateWriting). This page also contains the [**pre-existing functions and macros you can use in your templates and parameter classes.**](http://projects.theforeman.org/projects/foreman/wiki/TemplateWriting#Functions-and-macros)

#### Examples

##### Example 1 - Simple change to a single host

All our hosts use *server.foo* for something, except bob.domain.com which uses *server2.bar*:

| Parameter            | target                                                    |
| -------------------- | --------------------------------------------------------- |
| Description          | The target server to talk to                              |
| Default Value        | server.foo                                                |
| Type Validator       | string                                                    |
| Validator Constraint |                                                           |
| Order                | fqdn            hostgroup            os            domain |
| Attribute type       | fqdn = bob.domain.com                                     |
| Value                | server2.bar                                               |

##### Example 2 - Change for a group of hosts (via custom fact) with validation and ordering

Most hosts need to use a port of *80* but all machines with a fact *region* and value *europe* need to use *8080*. To do this, you have to add the factname (in this example *region*) to the searchlist:

| Parameter            | port                                                         |
| -------------------- | ------------------------------------------------------------ |
| Description          | The port to use                                              |
| Default Value        | 80                                                           |
| Type Validator       | list                                                         |
| Validator Constraint | 80,443,8080                                                  |
| Order                | fqdn            region            hostgroup            os            domain |
| Attribute type       | region = europe                                              |
| Value                | 8080                                                         |
| Attribute type       | fqdn = foo.domain                                            |
| Value                | 67                                                           |

Note that all machines will get either 80 or 8080 as required, except foo.domain which will generate an error, since 67 is not in the list  validator. Note also that foo.domain will match before region, since it  is higher in the searchlist. The rule ordering does not matter.

It is also possible to mix conditions, e.g.

| Parameter            | port                                                         |
| -------------------- | ------------------------------------------------------------ |
| Description          | The port to use                                              |
| Default Value        | 80                                                           |
| Type Validator       | list                                                         |
| Validator Constraint | 80,443,8080                                                  |
| Order                | fqdn            region, hostgroup, environment            hostgroup            environment            domain |
| Attribute type       | fqdn = foo.domain                                            |
| Value                | 67                                                           |
| Attribute type       | region, hostgroup, environment = europe, "web servers", production |
| Value                | 8080                                                         |

## 4.3 Smart Proxies

The Smart Proxy is a project which provides a restful API to various sub-systems.

Its goal is to provide an API for a higher level orchestration tools (such as Foreman). The Smart proxy provides an easy way to add or extended existing subsystems and APIs using plugins.

Currently supported (Click on the links below for more details).

- [**DHCP**](https://theforeman.org/manuals/3.5/index.html#4.3.4DHCP) - ISC DHCP and MS DHCP Servers
- [**DNS**](https://theforeman.org/manuals/3.5/index.html#4.3.5DNS) - Bind and MS DNS Servers
- [**Puppet**](https://theforeman.org/manuals/3.5/index.html#4.3.6Puppet) - Puppet server version 5 or 6
- [**Puppet CA**](https://theforeman.org/manuals/3.5/index.html#4.3.7PuppetCA) - Manage certificate signing, cleaning and autosign on a Puppet CA server
- [**Realm**](https://theforeman.org/manuals/3.5/index.html#4.3.8Realm) - Manage host registration to a realm (e.g. FreeIPA)
- [**Templates**](https://theforeman.org/manuals/3.5/index.html#4.3.12Templates) - Proxy template requests from hosts in isolated networks
- [**TFTP**](https://theforeman.org/manuals/3.5/index.html#4.3.9TFTP) - Any UNIX based tftp server

If you require another sub system type or implementation, please add a new feature request or consider writing a plugin.

Once your smart proxy is running, each of the relevant sub systems needs to be configured via the [settings.d/*](https://theforeman.org/manuals/3.5/index.html#4.3.2SmartProxySettings) files in the config directory.

### 4.3.1 Smart Proxy Installation

A smart proxy is an autonomous web-based foreman component that is  placed on a host performing a specific function in the host  commissioning phase. It receives requests from Foreman to perform operations that are  required during the commissioning process and executes them on its behalf. More  details can be found on the [**Foreman Architecture**](https://theforeman.org/manuals/3.5/index.html#ForemanArchitecture) page.

To fully manage the commissioning process then a smart proxy will  have to manipulate these services, DHCP, DNS, Puppet CA, Puppet and  TFTP. These services may exist on separate machines or several of them  may be hosted on the same machine. As each smart proxy instance is  capable of managing all the of these services, there is only need for  one proxy per host. In the special case of a smart proxy managing a Windows DHCP server, the host machine must be running Windows, it does not need to be the  Microsoft DHCP server itself.

#### Packages

RPM and Debian packages are available, see the [Install from Packages](https://theforeman.org/manuals/3.5/index.html#3.3InstallFromPackages) section for configuration and install the `foreman-proxy` package.

#### Source code

You can get the latest stable code from [GitHub](https://github.com/theforeman/smart-proxy) ([via git](git://github.com/theforeman/smart-proxy.git)).

```
git clone git://github.com/theforeman/smart-proxy.git -b 3.5-stable
```

#### System requirements

The smart proxy will run with the following requirements (aside from rubygem dependencies):

- Ruby 2.5, 2.6 or 2.7

#### Windows

The Microsoft smart-proxy installation procedure is very basic  compared to the RPM or APT based solution. You need to run smart-proxy  from the source as well as install Ruby and Ruby DevKit.

1. Run [Ruby Installer](http://rubyinstaller.org/downloads/) and add the matching DevKit to compile native extensions. Make sure to add Ruby to `%PATH%`, you can select this option in the installer

2. Download / clone the [smart proxy repository](https://github.com/theforeman/smart-proxy) to a convenient location (see above, *Source Code*). Make sure to download / checkout the maching branch to your foreman installation

3. Open a command prompt (

   ```plaintext
   cmd.exe
   ```

   ) and run the following commands in order:    

   1. `ruby <devKitRoot>\dk.rb init`
   2. `ruby <devKitRoot>\dk.rb install`
   3. `gem install --no-ri --no-rdoc bundler`
   4. `cd <smart-proxy location>`
   5. `bundle install --without development test krb5 puppet_proxy_legacy bmc libvirt`

##### General configuration

1. Create the SSL certificate and key    

   1. Login to your puppetserver

   2. On the command line, type the following command. Take care not to use an alias nor upper case characters.

      ```
      puppet cert generate new-smart-proxy-FQDN
      ```

   3. Copy the private key, the public certificate and the ca.pem  from /var/lib/puppet/ssl on your puppetserver over to a location  accessible by your new smart proxy, e.g. `<smart-proxy location>\ssl\` (create the directory if necessary - this location will be referred to by the settings.yml in the next step)

2. Copy *settings.yml.example* inside *config* to *settings.yml*

3. At very least, modify the settings for `:bind_host:` and `:log_file:` and SSL, for example:

```
:bind_host: '0.0.0.0'
:log_file: 'C:\smart-proxy.log'

:trusted_hosts: [ foreman.example.com ]

:ssl_certificate: <smart-proxy location>\ssl\host.example.com.pem
:ssl_private_key: <smart-proxy location>\ssl\host.example.com.pem
:ssl_ca_file:     <smart-proxy location>\ssl\ca.pem
```

##### Test and configure smart proxy features

1. Test your configuration by setting `:log_level: DEBUG` and `:log_file: STDOUT` in *config/settings.yml*
2. Open an administrative command prompt and run `bundle exec ruby <smart-proxy location>\bin\smart-proxy`
3. [Configure smart-proxy features like DNS and DHCP](https://theforeman.org/manuals/3.5/index.html#4.3.2SmartProxySettings)
4. Once everything runs well install a Windows service using `ruby extra\register_service.rb` to register the service `Foreman Smart Proxy`. Alternatively, use a third party tool like [NSSM](https://nssm.cc/) to create the service.

**Caveats:** There is an issue with DevKit not finding  any ruby version installed. Check that the DevKit and Ruby Installer are both x32 or x64, otherwise [add the missing versions manually by editing `config.yml`](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit#4-run-installation-scripts).

**Puppet hint:** If you have Puppet installed on the  same host running smart-proxy, you can use Puppet’s Ruby. You only need  DevKit. In this case, just add directory containing `ruby.exe` to your path variable and add it to DevKit settings if necessary by editing DevKit’s `config.yml`. Also, you might want to use Puppet’s host certificates right away for  smart proxy SSL connections. Usually, they can be found in `C:\ProgramData\PuppetLabs\puppet\etc\ssl`. For example:

```
:ssl_certificate: C:\ProgramData\PuppetLabs\puppet\etc\ssl\certs\host.example.com.pem
:ssl_private_key: C:\ProgramData\PuppetLabs\puppet\etc\ssl\private_keys\host.example.com.pem
:ssl_ca_file:     C:\ProgramData\PuppetLabs\puppet\etc\ssl\certs\ca.pem
```

#### Configuration file

Usually can be found at /etc/foreman-proxy/settings.yml or in the config/settings.yml subdirectory. You can use the *settings.yml.example* file inside the *config* directory as a template for your own *settings.yml*.

Configuration of each subsystem is usually in  /etc/foreman-proxy/settings.d/ or in the config/settings.d/  subdirectory.  If you don’t plan to use one of the subsystems, please  disable them in these configuration files. For more information see [**Smartproxy Configuration**](https://theforeman.org/manuals/3.5/index.html#4.3.2SmartProxySettings).

#### Start the daemon

```
bundle exec bin/smart-proxy
```

Or if you installed it via a package simply start the foreman-proxy service.

```
service foreman-proxy start
```

#### Add the Smart Proxy to Foreman

- Go to Foreman, under *Infrastructure > Smart proxies*, click *New Proxy*
- Type in the Name for your Proxy and the URL of your Proxy, with the port used

For example:

- Name: Puppet-Proxy
- URL: http://puppet.your-domain.com:8443

### 4.3.2 Smart Proxy Settings

The main configuration for the core Smart Proxy is held in the */etc/foreman-proxy/settings.yml* or *config/settings.yml* file.  This includes configuration of ports to listen on, SSL and security settings and logging options.

Each of the modules used in the Smart Proxy have their configuration in the */etc/foreman-proxy/settings.d/* or *config/settings.d* directory.  Modules are enabled or disabled inside their respective configuration files with the `:enabled` directive, which determines whether the module is available on HTTP, HTTPS, both or is disabled (see below for more details).

#### YAML start

The first non-comment line of all configuration files must be three dashes.

```
---
```

#### Logging (settings.yml)

The proxy’s output is captured to the **log_file** and may be filtered via the usual Unix syslog levels:

- *WARN*
- *DEBUG*
- *ERROR*
- *FATAL*
- *INFO*
- *UNKNOWN*

See Ruby’s [Logger class](http://www.ruby-doc.org/stdlib/libdoc/logger/rdoc/classes/Logger.html) for details.

```
:log_file: /var/log/foreman-proxy/proxy.log
:log_level: DEBUG
```

The log_file setting may be set to “STDOUT” which causes log messages to be logged to standard output, for capture by the running process  (e.g. systemd with journal).  When log_file is set to “SYSLOG”, all  messages will be sent to syslog.

A limited number of recent log messages are kept in memory using a  ring buffer, which can be exposed in the API and to Foreman by enabling  the [Logs feature](https://theforeman.org/manuals/3.5/index.html#4.3.13Logs).

The number of all log messages is controlled by the `log_buffer` setting, and a second buffer of error messages is controlled by the `log_buffer_errors` setting.  The total of the two will directly affect the maximum amount  of memory used, which is approximately 500kB in the default  configuration of 3,000 recent messages.

```
:log_buffer: 2000
:log_buffer_errors: 1000
```

#### Listening configuration (settings.yaml)

By default the Smart Proxy listens on all interfaces, which can be changed to limit access to a network:

```
# host to bind ports to (possible values: *, localhost, 0.0.0.0)
:bind_host: ['*']
:bind_host: private.example.com
:bind_host: 192.168.1.10
```

The Smart Proxy has a number of different modules which can be  enabled either for HTTP, for HTTPS or for access on both services.  It  is highly recommended to enable most only on HTTPS and only enable  modules on HTTP when required (e.g. templates) or if no SSL is desired.

The two port options control which TCP port(s) the Smart Proxy will  listen on.  At least one must be enabled for the proxy to start.  It is  recommended to only set https_port unless an HTTP-only module is active, which also requires the three ssl_* settings to be set.

```
:http_port: 8000
:https_port: 8443
```

Be careful when enabling http_port, ensure settings.d/ files are enabled only on HTTPS or trusted_hosts is set  appropriately so modules are not exposed without security on HTTP.

Modules are enabled in their per-module configuration file in */etc/foreman-proxy/settings.d/* with the `:enabled` directive, which can be set to:

- `:enabled: false` to disable the module entirely
- `:enabled: http` to listen on HTTP only
- `:enabled: https` to listen on HTTPS only (recommended)
- `:enabled: true` to listen on both HTTP and HTTPS if enabled (not recommended)

#### Security configuration (settings.yml)

The existence of all the three ssl key entries below requires the use of an SSL connection.

**NOTE** that both client certificates need to be signed by the same CA, which must be in the *ssl_ca_file*, in order for this to work see [**SSL**](https://theforeman.org/manuals/3.5/index.html#4.3.10SSL) for more information

```
:ssl_certificate: ssl/certs/fqdn.pem
:ssl_ca_file: ssl/certs/ca.pem
:ssl_private_key: ssl/private_keys/fqdn.key
```

Specific SSL cipher suites can be disabled by using the `:ssl_disabled_ciphers:` option. For more information on which cipher suites are enabled by  default and how to correctly disable specific ones, please see [**SSL cipher suites**](https://theforeman.org/manuals/3.5/index.html#ssl-cipher-suites).

The TLS versions can be disabled if requiring a specific version.  SSLv3, TLS v1.0, and TLS v1.1 are disabled by default, setting the array of `:tls_disabled_versions:` to include `1.2` will disable this version, too.

This is the list of hosts from which the smart proxy will accept  connections.  For HTTPS connections, the name must match the common name (CN) within the subject DN and for HTTP connections, it must match the  hostname from reverse DNS.

```
:trusted_hosts:
  - foreman.prod.domain
  - foreman.dev.domain
```

For HTTPS connections, the name must match the common name (CN)  within the subject DN and for HTTP connections, it must match the  hostname from reverse DNS.  When `:forward_verify` is enabled (default: true) then the reverse lookup is verified against  the forward lookup of the hostname (aka forward-confirmed reverse  DNS/FCrDNS).

Some modules may allow connections from all hosts rather than only  the trusted_hosts list, particularly if they intend to deal with  requests directly from managed hosts rather than only from Foreman.

An empty trusted_hosts list will permit no hosts access:

```
:trusted_hosts: []
```

While if the setting is not specified, any host may make requests to  the smart proxy, which permits management of any enabled modules and  features.

#### Foreman communication (settings.yml)

Some modules make requests *back* to Foreman, e.g. when relaying requests from client hosts.  The following setting changes the destination URL:

```
:foreman_url: https://foreman.example.com
```

And the following settings change the SSL certificates used to  authenticate to Foreman and to verify its certificate.  In a typical  installation, Foreman and the Smart Proxy may both use certificates  signed the same certificate authority, so these default to the values of the ssl_* settings defined above.

```
# SSL settings for client authentication against Foreman. If undefined, the values
# from general SSL options are used instead. Mainly useful when Foreman uses
# different certificates for its web UI and for smart-proxy requests.
:foreman_ssl_ca: /etc/foreman-proxy/ssl/certs/ca.pem
:foreman_ssl_cert: /etc/foreman-proxy/ssl/certs/fqdn.pem
:foreman_ssl_key: /etc/foreman-proxy/ssl/private_keys/fqdn.pem
```

### 4.3.3 BMC

Activate the BMC management module within the Smart Proxy instance.   This allows users to trigger power management commands through the proxy to controlled hosts using IPMI or similar.

```
:enabled: https
:bmc_default_provider: freeipmi
```

Available providers are:

- `freeipmi` - for IPMI control using the freeipmi implementation
- `ipmitool` - using the ipmitool implementation
- `shell` - specialized provider for controlling the proxy server itself (used for Foreman Discovery)
- `ssh` - simple provider via SSH command `shutdown` with limited functionality (poweron does not work)

The credentials and addresses used to control hosts are passed from  Foreman itself by adding a new network interface with the type set to  “BMC” to hosts.

#### 4.3.3.1 SSH BMC

The SSH BMC provider provides a limited level of BMC functionality by running commands over an SSH connection to the host using a trusted SSH key.

It has the following configuration options for authentication, for the remote SSH user and private SSH key:

```
:bmc_ssh_user: root
:bmc_ssh_key: /usr/share/foreman/.ssh/id_rsa
```

The following configuration options control the commands executed by the provider on the remote host:

```
:bmc_ssh_powerstatus: "true"
:bmc_ssh_powercycle: "shutdown -r +1"
:bmc_ssh_poweroff: "shutdown +1"
:bmc_ssh_poweron: "false"
```

No power on support is possible with this provider.

### 4.3.4 DHCP

#### 4.3.4.1 dhcp.yml

Activate the DHCP management module within the Smart Proxy instance.  This is used to query for available IP addresses (looking at existing  leases and reservations), add new and delete existing reservations. It  cannot manage subnet declarations, which should be managed by another  means (e.g. [puppet-dhcp](https://github.com/theforeman/puppet-dhcp)).

The DHCP module is capable of managing the ISC DHCP server, Microsoft Active Directory and Libvirt instances.

Builtin providers are:

- `dhcp_isc` - ISC DHCP server over OMAPI
- `dhcp_libvirt` - dnsmasq DHCP via libvirt API
- `dhcp_native_ms` - Microsoft Active Directory using API

Extra providers are available as plugins and can be installed through packages. See the following pages for more information:

- [List of smart proxy plugins](http://projects.theforeman.org/projects/foreman/wiki/List_of_Smart-Proxy_Plugins)
- [Plugin installation documentation](https://theforeman.org/plugins/)

To enable the DHCP module and enable a provider, `dhcp.yml` must contain:

```
:enabled: https
:use_provider: dhcp_isc
```

For providers from plugins, check the plugin documentation to determine the exact provider name.

The module manages a DHCP server on the local host by default, but  for providers that can be run remotely, the server address can be  changed:

```
:server: 127.0.0.1
```

Note that if the DHCP server is running remotely, some providers  (notably ISC) require that the configuration files must be accessible to the Smart Proxy still. This can be achieved with a network file system, e.g. NFS.

All available subnets will be loaded and can be managed by default,  but this can have a performance penalty. If only some subnets are used,  specify them as follows in `network_address/network_mask` notation:

```
:subnets: [192.168.205.0/255.255.255.128, 192.168.205.128/255.255.255.128]
```

Each provider has its own configuration file in the same directory with its own settings, e.g. `dhcp_isc.yml`. This usually needs additional configuration after changing the `use_provider` setting.

#### dhcp_isc

The dhcp_isc provider uses a combination of the ISC DHCP server OMAPI management interface and parsing of configuration and lease files. This requires it to be run either on the same host as the DHCP server or to  have network filesystem access to these files.

This provider requires the `config` and `leases` settings in the `dhcp_isc.yml` configuration file, which should be set to the location of the DHCP  server config and lease files. On a Red Hat or Fedora server use:

```
:config: /etc/dhcp/dhcpd.conf
:leases: /var/lib/dhcpd/dhcpd.leases
```

On a Debian or Ubuntu DHCP server, use the following values instead:

```
:dhcp_config: /etc/dhcp3/dhcpd.conf
:dhcp_leases: /var/lib/dhcp3/dhcpd.leases
```

The foreman-proxy account must be able to  read both configuration files. In particular, check the permissions on  the parent directory (e.g. /etc/dhcp) permit world read/execute.

If the DHCP server is secured with an “omapi_key”, the following entries must be set with the same values:

```
:key_name: omapi_key
:key_secret: XXXXXXXX
```

If the DHCP server is listening on a non-standard OMAPI port (i.e. not 7911), then change this with:

```
:omapi_port: 7911
```

For DHCP servers running on a different host, change `:server` in the main `dhcp.yml` configuration file.

#### dhcp_native_ms

The native_ms provider manages reservations in Microsoft Active Directory via its native API.

Possible configuration options in `dhcp_native_ms.yml` are:

```
:disable_ddns: true
```

When `disable_ddns` is true (default), dynamic DNS updates will be disabled for all hosts  that the smart proxy creates. This will slightly slow the host creation  process but will ensure that the DHCP server will not create or delete  DNS entries on behalf of these clients. It’s preferable to disable this  feature at the scope level.

#### dhcp_libvirt

Provider that manages reservations and leases via dnsmasq through libvirt API. It uses ruby-libvirt gem to connect to the local or remote instance of libvirt daemon.

Possible configuration options in `dhcp_libvirt.yml` are:

```
# Libvirt network. Only one network is supported.
:network: default

# Libvirt connection. Make sure proxy effective user have permission to connect.
:url: qemu:///system
```

When configuring local or remote connections, make sure the `foreman-proxy` effective user has UNIX permissions to libvirt socket or ssh keys are deployed when using remote connection.

More information about using this provider is in the [Libvirt section](https://theforeman.org/manuals/3.5/index.html#4.3.11Libvirt).

#### 4.3.4.2 ISC DHCP

ISC implementation is based on the OMAPI interface, which means:

- No need for root permissions on your DHCP server
- No need to restart (or “sync”) your DHCP server after every modifications.

##### Configuration

- dhcpd configuration file: ensure you have the following line in your dhcpd.conf file (somewhere in the top first lines): `omapi-port 7911;`
- configure the settings file to point to your dhcpd.conf and  dhcpd.leases files (make sure they are readable by the smart-proxy user)
- make sure the omshell command (/usr/bin/omshell) can be executed by the smart-proxy user.
- make sure that /etc/dhcp and /etc/dhcp/dhcpd.conf has group foreman-proxy

##### Securing the dhcp API

The dhcpd api server will listen to any host. You might need to add a omapi_key to provide basic security.

Example generating a key (on CentOS):

```
yum install bind
dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST omapi_key
cat Komapi_key.+*.private |grep ^Key|cut -d ' ' -f2-
```

1. Edit your “/etc/dhcpd.conf”:

```
omapi-port 7911;
key omapi_key {
algorithm HMAC-MD5;
  secret "XXXXXXXXX"; #<-The output from the generated key above.
};
omapi-key omapi_key;
```

1. Make sure you also add the omapi_key to your proxy’s [dhcp_isc.yml](https://theforeman.org/manuals/3.5/index.html#4.3.4DHCP)
2. Restart the dhcpd and foreman-proxy services

**NOTE**: if you don’t see DHCP in Smart Proxies Features, choose “Refresh features” from drop-down menu.

The next step is to set up appropriate Subnets in Foreman from the settings menu.

##### Sample dhcpd.conf

```
ddns-update-style interim;
ignore client-updates;
authoritative;
allow booting;
allow bootp;

omapi-port 7911;
#Optional key:
key omapi_key {
        algorithm HMAC-MD5;
        secret "2wgoV3yukKdKMkmOzOn/hIsM97QgLTT4CLVzg9Zv0sWOSe1yxPxArmr7a/xb5DOJTm5e/9zGgtzL9FKna0NWis==";
}
omapi-key omapi_key;

subnet 10.1.1.0 netmask 255.255.255.0 {
# --- default gateway
  option routers      10.1.1.254;
  option subnet-mask  255.255.255.0;

  option domain-name    "domain.com";
  option domain-name-servers  10.1.1.1, 8.8.8.8;
  option log-servers    syslog;
  option ntp-servers    ntp;

  range dynamic-bootp 10.1.1.10 10.1.1.250;
  default-lease-time 21600;
  max-lease-time 43200;

}
```

#### 4.3.4.3 MS DHCP

It is required that this procedure is executed as an administrator.

It is not required that the smart proxy be on the same host as the MS DHCP server. The smart proxy just needs to be on a Windows host with  connectivity to the DHCP server. If this is the case, make sure the  smart proxy service runs as a user with sufficient privileges.

**Note:** Refer to the [installation guide](https://theforeman.org/manuals/3.5/index.html#4.3.1SmartProxyInstallation) for general setup.

1. Edit config/settings.d/dhcp.yml so that it looks a bit like this. `:server:` can be left commented out if smart proxy runs on the same host.

   *Sample config/settings.d/dhcp.yml file*

   ```
   ---
   # Can be true, false, or http/https to enable just one of the protocols
   :enabled: https
   :use_provider: dhcp_native_ms
   :server: 10.10.10.1
   ```

2. If needed, you have to create the option 60 on the Windows DHCP (for PXE Boot)

   - Open an administrator command prompt

   - Create the PXE Option using netsh

     ```
     C:\Windows\system32>netsh
     netsh>dhcp
     netsh dhcp> server 10.10.10.1
     netsh dhcp server>add optiondef 60 PXEClient String 0 comment= PXE Support
     ```

### 4.3.5 DNS

#### 4.3.5.1 dns.yml

Activate the DNS management module within the Smart Proxy instance.   This is used to update and remove DNS records from existing DNS zones.

The DNS module can manipulate any DNS server that complies with the  ISC Dynamic DNS Update standard and can therefore be used to manage both Microsoft Active Directory and BIND servers.  Updates can also be made  using GSS-TSIG, see the second section below.  Additional providers are  available for managing libvirt’s embedded DNS server (dnsmasq) and  Microsoft Active Directory using dnscmd, for static DNS records,  avoiding scavenging.

Builtin providers are:

- `dns_nsupdate` - dynamic DNS update using nsupdate
- `dns_nsupdate_gss` - dynamic DNS update with GSS-TSIG
- `dns_libvirt` - dnsmasq DNS via libvirt API
- `dns_dnscmd` - static DNS records in Microsoft Active Directory

Extra providers are available as plugins and can be installed through packages.  See the following pages for more information:

- [List of smart proxy plugins](http://projects.theforeman.org/projects/foreman/wiki/List_of_Smart-Proxy_Plugins)
- [Plugin installation documentation](https://theforeman.org/plugins/)

To enable the DNS module and enable a provider, `dns.yml` must contain:

```
:enabled: https
:use_provider: dns_nsupdate
```

For providers from plugins, check the plugin documentation to determine the exact provider name.

The default TTL of DNS records added by the Smart Proxy is 86400  seconds (one day).  This can be changed with the dns_ttl setting:

```
:dns_ttl: 86400
```

Each provider has its own configuration file in the same directory with its own settings, e.g. `dns_nsupdate.yml`.  This usually needs additional configuration after changing the `use_provider` setting.

#### dns_nsupdate

The dns_nsupdate provider uses the `nsupdate` command to make dynamic updates to the DNS server records. This works on a wide variety of RFC2136-compliant servers.

DNS servers that support Kerberos authentication, e.g. FreeIPA or  Microsoft Active Directory, should use the dns_nsupdate_gss provider  instead.

This provider has the following settings in the `dns_nsupdate.yml` configuration file:

```
#:dns_key: /etc/rndc.key
:dns_server: localhost
```

The **dns_key** specifies a file containing a shared  secret used to generate a signature for the update request (TSIG  record), thus authenticating the smart proxy to the DNS server.

If you use a key file or keytab, make sure that only the foreman-proxy account can read that file.

If neither the **dns_key** or GSS-TSIG is used then the  update request is sent without any signature. Unsigned update requests  are considered insecure. Some DNS servers can be configured to accept  only signed signatures.

The **dns_server** option is used if the Smart Proxy is  not located on the same physical host as the DNS server. If it is not  specified then localhost is presumed.

```
:dns_key: /etc/foreman-proxy/Kapi.+157+47848.private
:dns_server: dnsserver.site.example.com
```

#### dns_nsupdate_gss

For servers that support Kerberos/GSS-TSIG to authenticate DNS  updates, the dns_nsupdate_gss provider should be used. This typically  applies to FreeIPA and Microsoft Active Directory servers. This is  equivalent to the `nsupdate -g` command.

This provider has the following settings in the `dns_nsupdate_gss.yml` configuration file:

```
:dns_tsig_keytab: /usr/share/foreman-proxy/dns.keytab
:dns_tsig_principal: DNS/host.example.com@EXAMPLE.COM
```

See the section on GSS-TSIG DNS below for steps on setting up the requisite accounts and keytabs with both AD and FreeIPA.

The **dns_server** option is used if the Smart Proxy is  not located on the same physical host as the DNS server. If it is not  specified then localhost is presumed.

```
:dns_server: dnsserver.site.example.com
```

#### dns_dnscmd

While the `dns_nsupdate` provider creates dynamic records in Active Directory, the `dns_dnscmd` provider uses the `dnscmd` tool to create static DNS records in AD, which are not affected by  scavenging. This requires that the Smart Proxy is installed on a Windows server with `dnscmd` available.

The **dns_server** option is used if the Smart Proxy is  not located on the same physical host as the DNS server. If it is not  specified then localhost is presumed.

```
:dns_server: dnsserver.site.example.com
```

#### dns_libvirt

Provider that manages reservations and leases via dnsmasq through libvirt API. It uses ruby-libvirt gem to connect to the local or remote instance of libvirt daemon.

Possible configuration options in `dns_libvirt.yml` are:

```
# Libvirt network. Only one network is supported.
:network: default

# Libvirt connection. Make sure proxy effective user have permission to connect.
:url: qemu:///system
```

When configuring local or remote connections, make sure the `foreman-proxy` effective user has UNIX permissions to libvirt socket or ssh keys are deployed when using remote connection.

More information about using this provider is in the [Libvirt section](https://theforeman.org/manuals/3.5/index.html#4.3.11Libvirt).

#### 4.3.5.2 BIND

Bind configuration manipulation is based on nsupdate, which means  that in theory could also be used to manipulate other dns servers which  support nsupdate (such as Microsoft DNS server).

#### Configuration

In order to communicate securely with your dns server, you would need a key which will be used by nsupdate and your named daemon using  ddns-confgen or dnssec-keygen

#### example using ddns-confgen

execute ‘ddns-confgen -k foreman -a hmac-md5’ - this should output something like the following:

```
# To activate this key, place the following in named.conf, and
# in a separate keyfile on the system or systems from which nsupdate
# will be run:
key "foreman" {
        algorithm hmac-md5;
        secret "GGd1oNCxaKsh8HA84sP1Ug==";
};

# Then, in the "zone" statement for each zone you wish to dynamically
# update, place an "update-policy" statement granting update permission
# to this key.  For example, the following statement grants this key
# permission to update any name within the zone:
update-policy {
        grant foreman zonesub ANY;
};

# After the keyfile has been placed, the following command will
# execute nsupdate using this key:
nsupdate -k /path/to/keyfile
```

You should create a new file (such as /etc/rndc.key or other) and store the key “foreman {…} in it. in the proxy Settings file you should point to this file location - make sure that the proxy have read permissions to this file.

In your named file, you could add the update-policy statement or something like this [named example file](http://theforeman.org/projects/smart-proxy/wiki/Named_example_file) if you need more fine grained permissions.

#### 4.3.5.3 GSS-TSIG DNS

Both BIND as configured in FreeIPA and Microsoft AD DNS servers can  accept DNS updates using GSS-TSIG authentication.  This uses Kerberos  principals to authenticate to the DNS server.  Under Microsoft AD, this  is known as “Secure Dynamic Update”.

#### Pre-requisites

- Kerberos principal in the realm/domain that Smart Proxy can use
- Kerberos keytab for the above principal
- Access to add/delete/modify the required zones in Microsoft DNS. Both forward and reverse lookup.

#### Microsoft AD configuration

A user has to be created in Active Directory that will be used by the Smart Proxy, e.g. `foremanproxy`. This will automatically create a service principal, e.g. `foremanproxy@EXAMPLE.COM`.

Test the Kerberos login with that user on the Smart Proxy using kinit:

```
kinit foremanproxy@EXAMPLE.COM
```

This requires that your SRV records in DNS or /etc/krb5.conf file is  setup correctly. By default many systems use DNS to locate the Kerberos  DC. A KDC can also be statically set in this file. There are dozens of  documents on how to do this on the net.

If login works, the keytab file can be created using `ktutil`. First clear the Kerberos ticket cache:

```
kdestroy
```

Now create the keytab file with `ktutil`:

```
ktutil: addent -password -p foremanproxy@EXAMPLE.COM -k 1 -e RC4-HMAC
ktutil: wkt dns.keytab
ktutil: q
```

Once the keytab file has been created, test it using kinit:

```
kinit foremanproxy@EXAMPLE.COM -k -t dns.keytab
```

If this works, clear the Kerberos ticket cache once again using `kdestroy`.

Store the keytab at `/etc/foreman-proxy/dns.keytab`, ensure permissions are 0600 and the owner is `foreman-proxy`. If you are using SELinux, do not forget to update the file context.

The DNS zone `Dynamic Updates` option on the DNS zones can now be set to `Secure Only`.

Restart the smart proxy service. Next, go to Update the configuration in Foreman.

#### FreeIPA configuration

A service principal is required for the Smart Proxy, e.g. `foremanproxy/proxy.example.com@EXAMPLE.COM`.

First of all, create a new principal (FreeIPA service) for Foreman, e.g. `ipa service-add foremanproxy/proxy.example.com@EXAMPLE.COM`.

Then fetch the keytab, e.g. `ipa-getkeytab -p foremanproxy/proxy.example.com@EXAMPLE.COM -s ipa-server.example.com -k /etc/foreman-proxy/dns.keytab`.

Store the keytab at `/etc/foreman-proxy/dns.keytab`, ensure permissions are 0600 and the owner is `foreman-proxy`.

The ACL on updates to the DNS zone then needs to permit the service  principal.  In the FreeIPA web UI, under the DNS zone, go to the  Settings tab, verify that “Dynamic update” for that zone is set to  “True”, and add to the BIND update policy a new grant:

```
grant foremanproxy\047proxy.example.com@EXAMPLE.COM wildcard * ANY;
```

Note the `\047` is written verbatim, and don’t forget the semicolon.  ACLs should be updated for both forward and reverse zones as desired.

#### Proxy configuration

Update the proxy DNS configuration file (`/etc/foreman-proxy/settings.d/dns.yml`) with the following setting:

```
:use_provider: dns_nsupdate_gss
```

And the DNS GSS configuration file (`/etc/foreman-proxy/settings.d/dns_nsupdate_gss.yml`) with:

```
:dns_tsig_keytab: /etc/foreman-proxy/dns.keytab
:dns_tsig_principal: foremanproxy/proxy.example.com@EXAMPLE.COM
```

Ensure the `dns_key` setting is not specified, or is commented out.

Restart the smart proxy service. Next, go to Update the configuration in Foreman.

#### Update the configuration in Foreman

After you have added a DNS smart proxy, you must instruct Foreman to  rescan the configuration on each affected smart proxy by using the  drop-down menu by its name and selecting “Refresh Features”.

Now, you are allowed to enable this in each subnet (reverse lookup of domain) and domain (forward lookup of domain) that you want this smart  proxy to assist. You do this by navigating there and selecting it in the drop-down menu for DNS.

### 4.3.6 Puppet

Activate the Puppet management module within the Smart Proxy instance. This module has two functions:

- Report the Puppet environments and Puppet classes with their  parameters from the Puppetserver. Used when importing classes into  Foreman
- Optionally trigger immediate Puppet runs on clients using one of a number of implementations

It should be activated on Puppetservers that have the environments  and modules available to import data from. This works independently of  the Puppet CA functionality. To use the Puppet run functionality, it  also needs to configured via an implementation listed in the section  below.

To enable this module, make sure these lines are present in `/etc/foreman-proxy/settings.d/puppet.yml`:

```
:enabled: https
```

#### Puppet class/environment imports

Parsing manifests is done by Puppet  itself, which means the manifests must be valid and pass syntax checks,  else they won't show up. Use `puppet parser validate example.pp` to validate the content of a manifest.

To get a list of environments, classes and their parameters, the  proxy queries the Puppetserver on its own API. The URL and settings used for the proxy to Puppetserver API query can be controlled with the  following settings in `/etc/foreman-proxy/settings.d/puppet_proxy_puppet_api.yml`:

```
# URL of the Puppet server itself for API requests
#:puppet_url: https://puppet.example.com:8140
#
# SSL certificates used to access the puppet API
#:puppet_ssl_ca: /etc/puppetlabs/puppet/ssl/certs/ca.pem
#:puppet_ssl_cert: /etc/puppetlabs/puppet/ssl/certs/puppet.example.com.pem
#:puppet_ssl_key: /etc/puppetlabs/puppet/ssl/private_keys/puppet.example.com.pem
#
# Smart Proxy api timeout when Puppet's environment classes api is used and classes cache is disabled
#:api_timeout: 30
```

The Puppetserver has to permit these API queries. The [HOCON-formatted auth.conf style](https://docs.puppet.com/puppetserver/latest/config_file_auth.html) is at /etc/puppetlabs/puppetserver/conf.d/auth.conf and requires these rules:

```
{
    match-request: {
        path: "/puppet/v3/environments"
        type: path
        method: get
    }
    allow: "*"
    sort-order: 500
    name: "puppetlabs environments"
},
{
    match-request: {
    path: "/puppet/v3/environment_classes"
       type: path
       method: get
    }
    allow: "*"
    sort-order: 500
    name: "puppetlabs environment classes"
},
```

### 4.3.7 Puppet CA

Activate the Puppet CA management module within the Smart Proxy  instance.  This is used to manage the autosign configuration and handle  listing, signing and revocation of individual certificates.

Builtin providers are:

- `puppetca_hostname_whitelisting` - direct management of Puppet’s `autosign.conf`
- `puppetca_token_whitelisting` - manage token-based signing of certificate requests

This should only be enabled in the Smart Proxy that is hosted on the  machine responsible for providing certificates to your puppet clients.  On this host enable the feature in `puppetca.yml`:

```
:enabled: https
```

Also choose the provider to use, default should be `puppetca_hostname_whitelisting`:

```
:use_provider: puppetca_hostname_whitelisting
```

Lastly the Puppet version needs to be specified. Since version 6 the `puppetca_http_api` implementation is used while on earlier versions the `puppetca_puppet_cert` implementation is used.

```
:puppet_version: '6.8.0'
```

#### puppetca_hostname_whitelisting

The `puppetca_hostname_whitelisting` provider directly manages Puppet’s `autosign.conf` file. This will create an autosign entry for a host during deployment and remove it when deployment is finished. Furthermore it allows you to manage entries manually using the Foreman WebUI.

The **autosignfile** setting in `puppetca_hostname_whitelisting.yml` is used to find autosign.conf:

```
:autosignfile: /etc/puppetlabs/puppet/autosign.conf
```

The location of the file can be determined with `puppet config print autosign`.

The proxy requires write access to the puppet autosign.conf file,  which is usually owner and group puppet, and has mode 0644 according to  the puppet defaults. Ensure the foreman-proxy user is added to the  puppet group ( e.g. `gpasswd -a foreman-proxy puppet` or `usermod -aG puppet foreman-proxy`)

puppet.conf:

```
[master]
autosign = $confdir/autosign.conf {owner = service, group = service, mode = 664 }
```

#### puppetca_token_whitelisting

The `puppetca_token_whitelisting` provider uses a token-based certificate signing managed by the Smart  Proxy itself and queried by Puppet during Provisioning. This provider adds more security and logging to the autosigning process  but does not allow for manual creation of autosigning entries.

This provider has the following settings in `puppetca_token_whitelisting.yml`:

```
:sign_all: false
:token_ttl: 360
:tokens_file: /var/lib/foreman-proxy/tokens.yml
```

By changing **sign_all** to `true` you will disable token verification and sign all certificate requests. The setting **token_ttl** defines how long a token after creation is valid in minutes. **tokens_file** sets the path to the file used to store  tokens during deployment, the foreman-proxy user requires read and write access to this file.

You can also change the certificate used for encrypting the token file by setting **certificate**. By default it uses the certificate of the Smart Proxy defined in `settings.yml` as **ssl_certificate**.

To integrate this in Puppet the script `puppet_sign.rb` provided by the Smart Proxy has to be used for verfication of the tokens during certificate signing. If installed via package the script should be already located at `/usr/libexec/foreman-proxy/puppet_sign.rb`. For manual installation the script can be found on [Github](https://github.com/theforeman/smart-proxy/blob/develop/extra/puppet_sign.rb). Using the latest version should be fine, if you encounter problems try the one released with your Smart Proxy version. The script has to be executable by the same user running the Puppet server, typically puppet.

After deploying the script the Puppet configuration has to be changed to point the **autosign** setting to the script.

```
[master]
autosign = /usr/libexec/foreman-proxy/puppet_sign.rb
```

#### puppetca_puppet_cert

**Note** this is used in Puppet 5 and earlier as determined by the `puppet_version` setting in `puppetca.yml`.

This implementation is used for managing certificates. It uses the `puppet cert` command and typically requires sudo access for the proxy.

```
:ssldir: /etc/puppetlabs/puppet/ssl
#:puppetca_use_sudo: false
#:sudo_command: /usr/bin/sudo
```

The `ssldir` setting is required and can be determined with `puppet config print ssldir`. Puppet AIO defaults to using `/etc/puppetlabs/puppet/ssl`.

By default sudo is used but can be disabled with `puppetca_use_sudo` setting. The sudo command is dermined via the `PATH` variable or can be explicitly set with the `sudo_command` setting.

For sudo to work correctly, it must be configured to allow `puppet cert` with NOPASSWD and without requiretty. Under a Puppet AIO installation, configuration should be:

```
foreman-proxy ALL = NOPASSWD: /opt/puppetlabs/bin/puppet cert *
Defaults:foreman-proxy !requiretty
```

Under a non-AIO Puppet installation:

```
foreman-proxy ALL = NOPASSWD: /usr/bin/puppet cert *
Defaults:foreman-proxy !requiretty
```

#### puppetca_http_api

**Note** this is used in Puppet 6 and newer as determined by the `puppet_version` setting in `puppetca.yml`.

As the name implies, Puppetserver’s HTTP API is used to manage certificates. In its configuration file `puppetca_http_api.yml` the connection details are configured:

```
:puppet_url: https://puppet.example.com:8140
:puppet_ssl_ca: /etc/puppetlabs/ssl/certs/ca.pem
:puppet_ssl_cert: /etc/puppetlabs/ssl/certs/puppet.example.com.pem
:puppet_ssl_key: /etc/puppetlabs/ssl/private_keys/puppet.example.com.pem
```

The Puppet server does not need to be on the same host, but only the `puppetca_token_whitelisting` provider supports this. Note the Puppetserver also needs to allow access to the Smart Proxy.

### 4.3.8 Realm

#### 4.3.8.1 realm.yml

Activate the realm management module within the Smart Proxy instance.  This manages Kerberos realms or domains, allowing Foreman to add and  remove hosts to enable them to join the realm/domain automatically  during provisioning.

```
:enabled: https
:use_provider: realm_freeipa
```

Builtin providers are:

- `realm_freeipa` -  host object management in FreeIPA

The configuration for each provider should be in its respective file, i.e: `/etc/foreman-proxy/settings.d/realm_freeipa.yml`.

The following settings control authentication of the proxy to the realm for management of hosts. In `realm_freeipa.yml`:

```
# Authentication for Kerberos-based Realms
:keytab_path: /etc/foreman-proxy/freeipa.keytab
:principal: realm-proxy@EXAMPLE.COM
```

#### 4.3.8.2 FreeIPA Realm

The FreeIPA implementation of the realm proxy is able to add a host  entry to FreeIPA, send the hostgroup name, and request a one-time  registration password.

##### Configuration of FreeIPA

In order to create the realm user and keytab to authenticate to FreeIPA, you can use the included `foreman-prepare-realm` tool. Your Smart Proxy must be registered to the FreeIPA realm already, and have the ipa-admintools package installed.

Simply provide a user with admin rights in FreeIPA, and a target user to create.

Do not use 'foreman-proxy' as the username for this -- this is a local user used for running the Smart Proxy service.

```
# foreman-prepare-realm admin realm-proxy
Password for admin@EXAMPLE.COM:
---------------------------------------
Added permission "modify host password"
---------------------------------------
  Permission name: modify host password
  Permissions: write
  Attributes: userpassword
  Type: host
[...]
Keytab successfully retrieved and stored in: freeipa.keytab
Realm Proxy User:    realm-proxy
Realm Proxy Keytab:  /root/freeipa.keytab
```

##### Configuration of Smart Proxy

Copy the freeipa.keytab created above to /etc/foreman-proxy/freeipa.keytab and set the correct permissions:

```
    chown foreman-proxy /etc/foreman-proxy/freeipa.keytab
    chmod 600 /etc/foreman-proxy/freeipa.keytab
```

Then update `settings.d/realm_freeipa.yml` with the relevant settings.

If you’re using FreeIPA to manage DNS records, and want them to be  automatically deleted when the host is deleted in Foreman, set this to  true:

```
:remove_dns: true
```

Finally, trust the IPA Certificate Authority. Ensure you have the most up-to-date version of the `ca-certificates` package installed.

```
cp /etc/ipa/ca.crt /etc/pki/ca-trust/source/anchors/ipa.crt
update-ca-trust enable
update-ca-trust
```

You will need to disable the DNS proxy for hosts that are provisioned with a realm set, as FreeIPA adds the forward record for you. In order  to support adding a reverse lookup record also, you will need to go into the settings for the forward lookup zone on the IPA server and tick `Allow PTR sync`. This will make sure that FreeIPA creates the PTR records for you.

##### Using Automember Rules

FreeIPA supports the ability to setup automember rules based on  attributes of a system.  When using the FreeIPA proxy, the Foreman host  group is available as a parameter in FreeIPA known as `userclass`.  Nested host groups are sent as displayed in the Foreman UI, e.g.  “Parent/Child/Child”.  Note that Foreman does send updates to FreeIPA,  however automember rules are only applied at initial add.  This will be  coming in a [future version of FreeIPA](https://fedorahosted.org/freeipa/ticket/3752).

First, we create a host group in FreeIPA:

```
# ipa hostgroup-add webservers
Description: web servers
----------------------------
Added hostgroup "webservers"
----------------------------
  Host-group: webservers
  Description: web servers
```

Define an automember rule:

```
# ipa automember-add --type=hostgroup webservers
----------------------------------
Added automember rule "webservers"
----------------------------------
Automember Rule: webservers
```

Create an automember condition based on the `userclass` attribute:

```
# ipa automember-add-condition --key=userclass --type=hostgroup --inclusive-regex=^webserver webservers
----------------------------------
Added condition(s) to "webservers"
----------------------------------
  Automember Rule: webservers
  Inclusive Regex: userclass=^webserver
----------------------------
Number of conditions added 1
----------------------------
```

When a machine in Foreman is in the “webservers” host group, it will automatically be added to the FreeIPA “webservers” host group as well.  FreeIPA host groups allow for Host-based access controls (HBAC), sudo policies, etc.

### 4.3.9 TFTP

#### tftp.yml

Activate the TFTP management module within the Smart Proxy instance.  This is designed to manage files on a TFTP server, e.g. bootloaders for OS installation and PXE menu files.

The *tftproot* value is directory into which TFTP files are  copied and then served from. The TFTP daemon will also be expected to  chroot to this location. This component is only supported in a Unix  environment.

```
:enabled: https
:tftproot: /var/lib/tftpboot
:tftp_servername: name of your tftp server (used for next server value in your dhcp reservation) - defaults to the host name of your proxy.
```

The foreman-proxy user must have read/write access to the _tftpboot/pxelinux.cfg_ and _tftpboot/boot_ directories.

#### Unattended installation

An essential first step in netbooting a system is preparing the TFTP  server with the PXE configuration file and boot images.  This document  assumes that you have already configured your DHCP infrastructure,  either via manual configuration or through the DHCP smart proxy.

##### Setting Up the Proxy Server Host

Regardless of the filesystem setup is performed, you must also make  sure you have the wget utility installed and in the default path.  *wget* is used to download OS specific installation when a given host is enabled for the build process.

##### Automatic Setup

Foreman includes a [TFTP server module](https://github.com/theforeman/puppet-foreman_proxy/blob/master/manifests/tftp.pp) that will perform all of the basic setup.  It defaults to TFTP root of */var/lib/tftpboot*, which may change if necessary.  You will still need to provide the  basic TFTP load images in your TFTP root directory.  For vanilla PXE  booting via PXELinux, this includes *pxelinux.0*, *menu.c32*, and *chain.c32*, for PXEGrub this includes *grub2/* and *grub/* subdirectories.

##### Manual Setup

The setup is very simple, and may be performed manually if desired.

1. The TFTP root directory must exist (we will use */var/lib/tftpboot* in this example).

2. Populate 

   /var/lib/tftpboot

    with PXE booting  prerequisites. These can be taken from syslinux (usually in  /usr/share/syslinux on RHEL) . At a minimum, this should include:    

   - *pxelinux.0*
   - *menu.c32*
   - *chain.c32*
   - *ldlinux.c32* if syslinux provides it

3. Populate the following prerequisites when PXE Grub bootloader is  planned. These files can be found in OS distribution repositories,  DVD/CD or packages (e.g. 

   grub2-efi

    on Red Hats which installs into 

   /boot/EFI

   ). Alternatively, these files can be built from modules using 

   grub2-mkimage

    or 

   grub-mkimage

    and signed for SecureBoot support.    

   - */var/lib/tftpboot/grub2* with *grubx64.efi* or *grubia32.efi*
   - */var/lib/tftpboot/grub* with *bootx64.efi* or *bootia32.efi*

4. Create the directory */var/lib/tftpboot/boot* and make it writeable by the foreman proxy user (foreman-proxy, for instance, when installing through a rpm package).

5. Create the directory */var/lib/tftpboot/pxelinux.cfg* and make it writeable by the foreman proxy user (foreman-proxy).

6. Make sure */var/lib/tftpboot/grub* and */var/lib/tftpboot/grub2* are both writeable by the foreman proxy user (foreman-proxy).

7. Verify SELinux labels when using SELinux.

- Note: if CentOS 7 is used, please make sure to edit the URL under  Hosts -> Installation Media, to to exclude the $minor version. For  example: http://mirror.centos.org/centos/$major/os/$arch

##### Setting Up Foreman

In most cases, the default templates should work fine.  You do,  however, need to make sure that a PXELinux or iPXE template is  associated with your hosts.  See [Unattended Installations](http://projects.theforeman.org/projects/foreman/wiki/Unattended_installations) for details.  The template will be used to define the PXE configuration file when a host is enabled for build.

##### Workflow

This is a rough outline of the steps triggered on the TFTP smart proxy host when you click on the “Build” link for a host.

1. Call *mkdir -p /var/lib/tftpboot/pxelinux.cfg* if it does not already exist.
2. Create a host-specific TFTP configuration file in */var/lib/tftpboot/pxelinux.cfg/01-XX-XX-XX-XX-XX-XX*, named based off of the MAC address, using the associated PXE template.
3. Call *mkdir -p /var/lib/tftpboot/boot* if it does not already exist.
4. Download the OS specific kernel and initrd files using wget.    
   1. The download URLs are derived from the installation media path, and OS specific log (see *app/models/redhat.rb* and *debian.rb* in foreman for examples of the gory details).
   2. The *debian.rb* file tries to guess if you want Ubuntu  or Debian, based on the Name you give to your OS in the UI. If the name  does not contain ‘ubuntu’ or ‘debian’, it may default to debian, hence  fail to fetch the kernel/initrd.
   3. cd into /var/lib/tftpboot/boot and check that the filesizes  are not zero. Check /var/log/foreman-proxy/proxy.log for possible  errors.
5. The exact wget command is `wget --no-check-certificate -nv -c <src> -O "<destination>"`
6. At this point, the TFTP state is ready for the installation process.
7. Once the host has completed installation, the OS specific installation script should inform foreman by retrieving the built URL.
8. The host-specific TFTP configuration file is deleted.
9. The kernel and initrd are not deleted, but left in place for  future installs of the same OS and architecture combination.  Please  note that in the unlikely case that these files are modified, the  simplistic freshness check of wget will likely get confused, corrupting  the downloaded versions of the files.  If this happens, you should  simply delete the files and let them be re-downloaded from scratch.

**To make sure that you trigger the above workflow make sure you’ve satisfied these requirements:**

1. at least 1 host is put in build mode
2. the host is using a subnet with a TFTP proxy

##### Limitations

At the moment, the proxy is not able to fetch boot files using NFS. As a workaround, expose your installation medium (or use a public  mirror) over http/ftp to configure one machine with the require boot  files. this would be resolved as part of #992.

#### Global default templates

You can build PXE default on TFTP proxy from Foreman UI from  ‘Provisioning Templates’ page using ‘Build PXE Default’ button. You also have the ability to choose which templates are used for this action.  Foreman exposes the following settings in the ‘Provisioning’ group for  this purpose: Global default PXEGrub template, Global default PXEGrub2  template and Global default PXELinux template. When settings are empty,  Foreman uses default values: PXELinux global default, PXEGrub global  default and PXEGrub2 global default.

### 4.3.10 SSL

The smart proxy can work in SSL mode, where both sides verify and  trust each other.  Requests from Foreman will only be accepted if the  SSL certificate can be verified.  Since proxies abstract a high level of control over your infrastructure, the configuration and security of  keys and certificates is important.

#### Using Puppet CA certificates

Since Foreman integrates with Puppet heavily, it is recommended to  use the Puppet Certificate Authority (CA) to secure proxy access.  See  the *Security Communciations with SSL* section for more advanced installations (multiple or internal CAs).

If the smart proxy host is not managed by Puppet, you will need to  generate a certificate - skip forward to the generate section.

When using Puppet’s certificates, the following lines will be required in puppet.conf to relax permissions to the `puppet` group.  The `foreman` and/or `foreman-proxy` users should then be added to the `puppet` group.

```
[main]
privatekeydir = $ssldir/private_keys { group = service }
hostprivkey = $privatekeydir/$certname.pem { mode = 640 }
```

##### Configuring the proxy

Configure the locations to the SSL files in `/etc/foreman-proxy/settings.yml`, plus the list of trusted Foreman hosts:

```
:ssl_certificate: /etc/puppetlabs/puppet/ssl/certs/FQDN.pem
:ssl_ca_file: /etc/puppetlabs/puppet/ssl/certs/ca.pem
:ssl_private_key: /etc/puppetlabs/puppet/ssl/private_keys/FQDN.pem

:trusted_hosts:
- foreman.corp.com
#- foreman.dev.domain
```

##### SSL cipher suites

By default, the smart proxy permits the following SSL cipher suites:

- ECDHE-RSA-AES128-GCM-SHA256
- ECDHE-RSA-AES256-GCM-SHA384
- AES128-GCM-SHA256
- AES256-GCM-SHA384
- AES128-SHA256
- AES256-SHA256
- AES128-SHA
- AES256-SHA

Please note, the smart proxy uses the OpenSSL suite naming scheme. For more information on suite names please see [the OpenSSL docs](https://www.openssl.org/docs/manmaster/apps/ciphers.html#CIPHER-SUITE-NAMES).

Certain users may require to disable certain cipher suites due to  security policies or newly discovered weaknesses. This can be done by  using the `:ssl_disabled_ciphers:` option in `/etc/foreman-proxy/settings.yml`.  For example:

```
:ssl_disabled_ciphers: ['AES128-SHA','AES256-SHA']
```

##### Generating a certificate

To generate a certificate for a proxy host that isn’t managed by Puppet, do the following:

1. Generate a new certificate on your puppetserver: `puppet cert --generate <proxy-FQDN>`

2. Copy the certificates and key from the puppetserver to the smart proxy in 

   ```plaintext
   /etc/foreman-proxy
   ```

   :    

   - /etc/puppetlabs/puppet/ssl/certs/ca.pem
   - /etc/puppetlabs/puppet/ssl/certs/proxy-FQDN.pem
   - /etc/puppetlabs/puppet/ssl/private_keys/proxy-FQDN.pem

Follow the configuration section above, however use the `/etc/foreman-proxy` paths instead of the Puppet defaults.

##### Configuring Foreman

For Foreman to connect to an SSL-enabled smart proxy, it needs  configuring with SSL certificates in the same way.  If the Foreman  system is managed by Puppet, it will already have these, else  certificates can be generated following the above instructions.

The locations of the certificates are managed in the *Settings* page, under *Provisioning* with the *ssl_ca_file*, *ssl_certificate* and *ssl_priv_key* settings.  By default these will point to the Puppet locations - for  manually generated certificates, or non-standard locations, they may  have to be changed.

Lastly, when adding the smart proxy in Foreman, ensure the URL begins with `https://` rather than `http://`.

### 4.3.11 Libvirt

In this chapter, we will describe how to setup DHCP and DNS for use with the libvirt provider for dnsmasq.

This provider is able to change DHCP and DNS settings in libvirt with dnsmasq. The smart proxy directly connects to the libvirt daemon.

The provider is currently limited by the libvirt API which does not provide PTR records creation via the API itself, but dnsmasq automatically creates PTR record for the first A/AAAA entry. Therefore PTR lookups do work in the network, but it is not being created by Foreman orchestration.

The provider also returns active leases on systems with `ruby-libvirt` gem version 0.6.1 or higher.

#### Configuration of libvirt

Define the TFTP root first. Edit ‘default’ virtual network and add ‘tftp’, ‘bootp’ and ‘domain’ elements.

```
<network>
 <name>default</name>
 <uuid>16b7b280-7462-428c-a65c-5753b84c7545</uuid>
 <forward mode='nat'/>
 <bridge name='virbr0' stp='on' delay='0' />
 <domain name="local.lan"/>
 <dns>
 </dns>
 <mac address='52:54:00:a6:01:5d'/>
 <ip address='192.168.122.1' netmask='255.255.255.0'>
   <tftp root='/var/tftproot' />
   <dhcp>
     <range start='192.168.122.2' end='192.168.122.254' />
     <bootp file='pxelinux.0' />
   </dhcp>
 </ip>
</network>
```

Create a TFTP root directory, make sure it is writeable by the foreman proxy user (`foreman-proxy` for instance) and accessible to the account dnsmasq is running on (in Fedora this is `nobody`), set gid flag for newly copied files and copy necessary files to the new TFTP root directory:

```
mkdir -p /var/tftproot/{boot,pxelinux.cfg}
yum -y install syslinux
cp /usr/share/syslinux/{pxelinux.0,menu.c32,chain.c32} /var/tftproot
chown -R foreman-proxy:nobody /var/tftproot
find /var/tftproot/ -type d | xargs chmod g+s
```

Open up `/etc/libvirt/libvirtd.conf` file and configure `foreman-proxy` user to be able to connect to libvirt daemon:

```
unix_sock_group = "foreman-proxy"
unix_sock_rw_perms = "0770"
```

Alternatively (on development setups), you can turn off authentication:

```
auth_unix_rw = "none"
```

#### Configuration of smart-proxy

Configure the Smart Proxy settings under config/ to:

- enable tftp
- set correct tftp boot and set explicit tftp_servername
- enable dns libvirt provider
- enable dhcp libvirt provider
- default settings for both providers are sufficient (network named `default` on local libvirt daemon instance)

Important configuration values are, in `tftp.yml`:

```
:tftp: true
:tftproot: /var/tftproot
:tftp_servername: 192.168.122.1
```

in `dns.yml`:

```
:enabled: true
:use_provider: dns_libvirt
```

in `dhcp.yml`:

```
:enabled: true
:use_provider: dhcp_libvirt
```

and in `dns_libvirt.yml` and/or `dhcp_libvirt.yml`:

```
:network: default
:url: qemu:///system
```

#### Additional steps

Make sure the DNS server is configured with the foreman instance by setting `/etc/resolv.conf` file or changing this in NetworkManager or dnsmasq configuration. Example:

```
cat /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 192.168.122.1
```

Foreman is now configured for libvirt provisioning, this is the recommended setup for git development checkouts.

### 4.3.12 Templates

In this chapter, we will describe how to setup a Smart Proxy to serve provisioning templates.

The smart proxy is able to proxy template requests from hosts in isolated networks to the Foreman server, when the proxy also handles TFTP.

This feature relies on correctly [configured trusted_proxies](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions) on Foreman.

Generally, you want the templates to be  available on HTTP as well as HTTPS.  When enabling HTTP on your smart  proxy, ensure that other modules' configurations in  /etc/foreman-proxy/settings.d/*.yml are secure by setting :enabled: to  https instead of true.

Ensure the foreman_url in `/etc/foreman-proxy/settings.yaml` points to your Foreman instance, and that your smart proxy is listening on HTTP by uncommenting `http_port`. Now configure `/etc/foreman-proxy/settings.d/templates.yml`:

```
:enabled: true
:template_url: http://smart-proxy.example.com:8000
```

Once you’ve completed the above steps, restart the foreman-proxy service and refresh the features on your Foreman server.

The templates feature is used automatically: any host that uses this  proxy for TFTP will also use the proxy to retrieve its templates.

### 4.3.13 Logs

The smart proxy’s logs module provides an API to retrieve recently  logged messages and information about failed modules.  This will be  displayed in Foreman under the Smart Proxy pages when the module is  enabled.

The module has no configuration options of its own, and is just enabled by configuring `/etc/foreman-proxy/settings.d/logs.yml`:

```
:enabled: https
```

Once enabled, restart the foreman-proxy service and refresh the features on your Foreman server.

The number of logs is controlled by the main smart proxy logging settings, detailed in [Smart Proxy Settings](https://theforeman.org/manuals/3.5/index.html#4.3.2SmartProxySettings).

## 4.4 Provisioning

This chapter details the configuration of the required UI components necessary to provision an OS onto a host.

### 4.4.1 Operating Systems

The Operating Systems page (*Hosts -> Operating Systems*) details the OSs known to Foreman, and is the central point that the other required components tie into.

#### Creating an Operating System

Simply click *New Operating system* on the main page. You will be taken to a screen where you can create the bare essentials of a new  OS. Not everything required for a successful provision is on this page  (yet) - the remaining components will appear for selection as we create  them.

You will need to fill in the first few parts of the form (Name,  Major, Minor, Family, and possibly some family-dependant information).  In the case of OSs like Fedora, it is fine to leave Minor blank.

If the default Partition Tables & Installation media are  suitable, then you can assign them now. If not, return here after each  step in this chapter to assign the newly created objects to your  Operating System

#### Auto-created Operating Systems

Foreman does not come with any Operating Systems by default. However, Foreman will detect the Operating System of any host which reports in  via Puppet - if the OS of that Host is supported, it will be created  (with very basic settings) and assigned to the Host. Thus you may find  some OSs already created for you.

### 4.4.2 Installation Media

The Installation Media represents the web URL from where the  installation packages can be retrieved (i.e. the OS mirror). Some OS  Media is pre-created for you when Foreman is first installed. However,  it is best to edit the media you are going to use and ensure the Family  is set.

#### New Installation Media

If your OS of choice does not have a mirror pre-created for you, click the *New Medium* button to create one. There are a few variables which can be used to pad out the URL. For example:

```
http://mirror.averse.net/centos/$major.$minor/os/$arch
```

Be sure to set the Family for the Media

#### Assign to Operating System

If you have not already done so, return to the Operating System page for your OS and assign the Media to it now.

### 4.4.3 Provisioning Templates

Provisioning Templates are the core of Foreman’s flexibility to  deploy the right code or options to the right OS. There are several  types of template, along with a flexible matching system to deliver  different templates to different Hosts.

Foreman comes with pre-created templates for the more common OSs, but you will need to review these. All these templates are locked by  default, hence they can not be modified. Most of them are customizable  through parameters, but if you need some custom functionality, the  recommended workflow is to clone the template and edit the clone. You  can unlock the pre-created template and edit it directly, but note that  any custom change will be overridden on any Foreman update. If you  believe your change is worthy of inclusion in next Foreman release,  please consider sending a patch to [foreman repository’s templates](https://github.com/theforeman/foreman/tree/develop/app/views/unattended) via the normal [contribution process](https://www.theforeman.org/contribute.html).

#### Template Kinds

There are several template kinds:

- PXELinux, PXEGrub, PXEGrub2  - Deployed to the TFTP server to  ensure the Host boots the correct installer with the correct kernel  options (also referred to as PXE templates)
- Provision - The main unattended installation file; e.g. Kickstart or Preseed
- Finish    - A post-install script used to take custom actions after the main provisioning is complete
- user_data - Similar to a Finish script, this can be assigned to  hosts built on user_data-capable images (e.g. Openstack, EC2, etc)
- Script    - An arbitrary script, not used by default, useful for certain custom tasks
- iPXE      - Used in {g,i}PXE environments in place of PXELinux (do not confuse with PXE templates above)

In practice, most environments only make use of the first 3. The *Create Host* action deploys the PXELinux template to the TFTP server. The PXELinux  template directs the host to retrieve the Provision template. The  Provision template will direct the installer to retrieve and run the  Finish template at the end of the install, and the Finish template will  notify Foreman the build is complete just before reboot.

##### Editing Templates

Unlocked templates can be edited from the *Hosts > Provisioning templates* menu, or from an existing host page under its *Templates* tab (which shows the templates in use).

The templates use the ERB (Embedded Ruby) templating language,  allowing data from the host in Foreman to be added to the template  output and for conditional content. The default templates make heavy use of the ERB feature, adding and changing the template behavior based on  parameters, the operating system, or the networking configuration  assigned to the host.

There are two general types of ERB syntax in templates. The `<%=` prefix outputs the value of the following expression into the rendered template, e.g. to output the hostname:

```
<%= @host.name %>
```

The `<%` prefix without the equals sign (`=`) is a general code block that may contain conditionals, variable  assignments, or loops which are not output when rendered. Comments may  also be in these blocks, prefixed with `#`.

```
<%
a_variable = @host.name
%>
<%= a_variable %>
```

Other examples of ERB syntax are given on the *Help* tab of the template editor, and many more examples are available on the [Template Writing](http://theforeman.org/projects/foreman/wiki/TemplateWriting) wiki page. The *Help* tab also lists available *Global methods (functions)* provided by Foreman such as `foreman_url` (the URL for unattended calls to Foreman), and `template_name`.

The methods available on the provided `@host` variable are limited by default (when `safemode_render` is enabled) to prevent exploitation of Foreman through templates. The  permitted methods on all types of objects can be found in the *Safe mode methods and variables* table under the *Help* tab.

As noted in section [4.1.4 Auditing](https://theforeman.org/manuals/3.5/index.html#4.1.4Auditing), changes to the templates are logged as diffs - you can browse the history of changes to the templates from the *History* tab within the *Edit Template* page. You can also revert changes here.

#### Template Association

When editing a Template, you must assign a list of Operating Systems  which this Template can be used with. Optionally, you can restrict a  template to a list of Hostgroups and/or Environments

When a Host requests a template (e.g. during provisioning), Foreman  will select the best match from the available templates of that type, in the following order:

- Host-group and Environment
- Host-group only
- Environment only
- Operating system default

The final entry, Operating System default, can be set by editing the Operating System page.

##### Associating an Operating System default template

You will need to associate at least one PXE, Provision, and Finish  template to your Operating System, and this must be done in two steps.  First edit each of the templates, switch to the Association tab, and  ensure the appropriate OSs are checked. Then edit the Operating System,  switch to the Templates tab, and choose a default template for each  template kind.

More than one PXE template can be associated. In this case, all  associated PXE templates are deployed to the TFTP server and only one is picked up during provisioning according to the *PXE Loader* setting (see below).

##### Templates Details

For image based installs there are two methods to customize and finish the installation. *Finish templates* and *User Data templates*:

###### Finish Templates

Finish templates are available for all hypervisors that support image based installs where the foreman server can reach the newly installed  machine via ssh and scp. The script generated from the finish template  is copied by the Foreman to the newly installed system via scp using  username and password specified with the image. It is then executed by  connecting again via ssh, making the script executable and either  executing it directly or via sudo if the specified user is not root.  Standard output and standard error are logged to a file in the same  directory named *bootstrap-UUID.log*.

###### User Data Templates

User Data Templates are available for hypervisors that support customization via tools like *cloud-init*. In this case the installed machine does not need be reachable via ssh  by the Foreman server. However, the installed must be able to reach  Foreman or a Smart Proxy with the templates feature via http(s) to  notify the setup has finished.

###### PXE Loader

When creating a new Host, the *PXE Loader* option must be selected in order to pass the correct DHCP filename option to the client. One option out of the following must be chosen:

- PXELinux BIOS (loads `pxelinux.0` filename from TFTP)
- PXELinux UEFI (loads `pxelinux.efi` filename from TFTP)
- PXEGrub UEFI (loads `grub/bootx64.efi` filename from TFTP)
- PXEGrub UEFI SecureBoot (loads `grub/shim.efi` filename from TFTP)
- PXEGrub2 UEFI (loads `grub2/grubx64.efi` filename from TFTP)
- PXEGrub2 UEFI SecureBoot (loads `grub2/shim.efi` filename from TFTP)
- None - no filename passed (e.g. for HTTP booting via iPXE)

Grub filenames are different for each individual architecture associated with the Host:

- `grub/bootia32.efi` (for Intel named "i*86" where * can be any character)
- `grub/bootx64.efi` (for Intel named "x86-64")
- `grub2/grubia32.efi` (for Intel named "i*86" where * can be any character)
- `grub2/grubx64.efi` (for Intel named "x86-64")
- `grub2/grubaa64.efi` (for ARM 64 named either "aa64" or "aarch64")
- `grub2/grubppc64.efi` (for IBM POWER named "ppc64”)
- `grub2/grubppc64le.efi` (for IBM POWER Little Endian named "ppc64le")
- `grub2/grubXYZ.efi` (for arbitrary Architecture named "XYZ")

Foreman installer only installs `pxelinux.0` and `grub2/grubx64.efi` (if grub2 is available). In order to boot systems via other loaders like PXELinux EFI or Grub 1 (legacy), deploy the required bootloader files in the TFTP directory.

Some operating systems use a “shim” loader for SecureBoot (e.g. Red Hat Enterprise Linux and clones). To use SecureBoot with an operating system that does not use a shim chainloader, make a copy of the signed EFI loader named `shim.efi` or make a symlink in order to do secure boot.

### 4.4.4 Partition Tables

Partition templates are a subset of normal Provisioning Templates.  They are handled separately because it is frequently the case that an  admin wants to deploy the same host template (packages, services, etc)  with just a different harddisk layout to account for different servers’  capabilities.

Foreman comes with pre-created templates for common Operating  Systems, but it is good to edit the template, check it’s content and  it’s Family setting. If the Family is wrong, be sure to go back to  Operating Systems and associate it with your Operating System.

#### Per-Host Partition tables

When creating a new Host, you will be given the option to create an  individual partition table. This is essentially a ‘one-off’ partition  table that is stored with the host and used only for that host. It  replaces the choice of Partition Table from the normal list of those  associated with the selected OS.

#### Dynamic Partition tables

Some operating systems allow you to create partition tables via  scripts. At the moment Kickstart and AutoYaST based systems can use this feature. Partition templates starting with `#Dynamic` are interpreted as scripts rather than static partition tables. The  Provisioning Template needs to support this feature (search for `@dynamic`). This enables you to make choices on the fly during provisioning (or re-provisioning).

##### Kickstart Dynamic Partition tables

Kickstart will run dynamic partition tables as a pre-install bash  script using a %pre scriplet. This script needs to create a complete  Kickstart partition table in ‘/tmp/diskpart.cfg’. This partition table  will then be read by anaconda for the installation by using `%include /tmp/diskpart.cfg`.

Example Dynamic Partition table:

```
#Dynamic - this line tells Foreman this is a script rather then a static layout
#This snippets define the swap partition size, it would generate a partition twice the size of the memory if your physical memory is up to 2GB
#or will create a swap partition with your memory size + 2GB.

#get the actual memory installed on the system and divide by 1024 to get it in MB
act_mem=$((`grep MemTotal: /proc/meminfo | sed 's/^MemTotal: *//'|sed 's/ .*//'` / 1024))

#check if the memory is less than 2GB then swap is double the memory else it is memory plus 2 GB
if [ "$act_mem" -gt 2048 ]; then
    vir_mem=$(($act_mem + 2048))
else
    vir_mem=$(($act_mem * 2))
fi

#copy all the HDD partitions to the temp file for execution
cat <<EOF > /tmp/diskpart.cfg
zerombr yes
clearpart --all --initlabel
part swap --size "$vir_mem"
part /boot --fstype ext3 --size 100 --asprimary
part / --fstype ext3 --size 1024 --grow
EOF
```

##### AutoYaST Dynamic Partition tables

AutoYaST will run dynamic partition tables as a pre-install bash script. This script needs to create a AutoYaST XML file in `/tmp/profile/modified.xml`. The modified.xml file will be read by YaST after your script has  finished. An example for getting the same functionality as with  Kickstart would be to create your XML partition table in `/tmp/diskpart.cfg` and sed it together with the original AutoYaST XML like this: `sed '/<\/ntp-client>/ r /tmp/diskpart.cfg' /tmp/profile/autoinst.xml > /tmp/profile/modified.xml`. Inserting after ntp-client section is just a suggestion that uses the  same style the community-templates do. The example uses a simplified  version of the AutoYaST LVM Partition table template.

Example Dynamic Partition table:

```
#Dynamic - this line tells Foreman this is a script rather then a static layout
#This snippets define the swap partition size, it would generate a partition twice the size of the memory if your physical memory is up to 2GB
#or will create a swap partition with your memory size + 2GB.

#get the actual memory installed on the system and divide by 1024 to get it in MB
act_mem=$((`grep MemTotal: /proc/meminfo | sed 's/^MemTotal: *//'|sed 's/ .*//'` / 1024))

#check if the memory is less than 2GB then swap is double the memory else it is memory plus 2 GB
if [ "$act_mem" -gt 2048 ]; then
    vir_mem=$(($act_mem + 2048))
else
    vir_mem=$(($act_mem * 2))
fi

#copy all the HDD partitions to the temp file for execution
cat <<EOF > /tmp/diskpart.cfg
  <partitioning config:type="list">
    <drive>
      <device>/dev/sda</device>
      <initialize config:type="boolean">true</initialize>
      <partitions config:type="list">
        <partition>
          <create config:type="boolean">true</create>
          <filesystem config:type="symbol">ext3</filesystem>
          <format config:type="boolean">true</format>
          <mount>/boot</mount>
          <partition_id config:type="integer">131</partition_id>
          <partition_nr config:type="integer">1</partition_nr>
          <size>1G</size>
          <stripes config:type="integer">1</stripes>
          <stripesize config:type="integer">4</stripesize>
          <subvolumes config:type="list"/>
        </partition>
        <partition>
          <create config:type="boolean">true</create>
          <format config:type="boolean">false</format>
          <lvm_group>vg00</lvm_group>
          <partition_id config:type="integer">142</partition_id>
          <partition_nr config:type="integer">2</partition_nr>
          <size>max</size>
        </partition>
      </partitions>
      <pesize></pesize>
      <type config:type="symbol">CT_DISK</type>
      <use>all</use>
    </drive>
    <drive>
      <device>/dev/vg00</device>
      <initialize config:type="boolean">true</initialize>
      <partitions config:type="list">
        <partition>
          <create config:type="boolean">true</create>
          <filesystem config:type="symbol">ext3</filesystem>
          <format config:type="boolean">true</format>
          <lv_name>root</lv_name>
          <mount>/</mount>
          <size>10G</size>
        </partition>
        <partition>
          <create config:type="boolean">true</create>
          <filesystem config:type="symbol">swap</filesystem>
          <format config:type="boolean">true</format>
          <lv_name>swap</lv_name>
          <mount>swap</mount>
          <size>${vir_mem}M</size>
        </partition>
      </partitions>
      <type config:type="symbol">CT_LVM</type>
      <use>all</use>
    </drive>
  </partitioning>
EOF
sed '/<\/ntp-client>/ r /tmp/diskpart.cfg' /tmp/profile/autoinst.xml > /tmp/profile/modified.xml
```

##### Configuration

A partition table entry represents either

- An explicit layout for the partitions of your hard drive(s). E.G.    

  ```
  zerombr
  clearpart --all --initlabel
  part /boot --fstype ext3 --size=100 --asprimary
  part /     --fstype ext3 --size=1024 --grow
  part swap  --recommended
  ```

- A script to dynamically calculate the desired sizes. E.G.

```
#Dynamic - The below code is to manage the swap size

#get the actual memory installed on the system and divide by 1024 to get it in MB
usable_ram=$((`awk '$1 ~ /^MemTotal/ {printf "%d\n", $2 / 1024}' /proc/meminfo`))

#check if the memory is less than 2GB then swap is double the memory else it is maximum 24 G for really inactive stuff.
if [ "$usable_ram" -le 2048 ]; then
  swap_size=$(($usable_ram * 2))
else
  swap_size=$(($usable_ram + 2048))
fi
if [ $swap_size -gt 24576 ] ; then
  swap_size=24576
fi

#copy all the HDD partitions to the temp file for execution
cat << EOF > /tmp/diskpart.cfg
zerombr
clearpart --all --initlabel
part swap --size 250 --maxsize "$swap_size" --grow
part /boot --fstype ext3 --size 100 --asprimary
part / --fstype ext3 --size 8192 --maxsize 12288 --grow
part /tmp2 --size 250 --fstype ext3 --grow
EOF
```

The inclusion of the keyword string `#Dynamic` at the start of a line lets Foreman know that this is not an explicit disk layout and must treated as a shell script, executed prior to the install process and that the explicit partition table will be found at `/tmp/diskpart.cfg` during the build process.

The dynamic partitioning style is currently only available for the Red Hat family of operating systems, all others must provide an explicit list of partitions and sizes.

You may also associate one or more operating systems with this partition table or alternatively set this up later on the  Operating systems page.

### 4.4.5 Architectures

Architectures are simple objects, usually created by Foreman  automatically when Hosts check in via Puppet. However, none are created  by default, so you may need to create them if you’re not using Foreman  for reporting.

#### Creating a new Architecture

Simply click *New Architecture* to create a new one. This should match the Facter fact *:architecture* e.g. “x86_64”. If you’ve already created some Operating Systems, you  can associate the Architecture with the OS now; if not, the list of  Architectures will be present when you create an OS.

### 4.4.6 Workflow

Foreman performs a number of orchestration steps when performing  unattended installation or provisioning, which vary depending on the  integration options chosen - e.g. use of [compute resources](https://theforeman.org/manuals/3.5/index.html#5.2ComputeResources), configuration management tool and provisioning method (network/PXE/image).

#### 4.4.6.1 Example: PXE booting an instance with Salt configuration

The following example uses:

- Compute resource (oVirt), also applicable to Libvirt and VMware
- Network (PXE) provisioning with DHCP and TFTP orchestration
- DNS orchestration
- Salt configuration management, also applicable to Puppet

![Example A workflow diagram](https://theforeman.org/static/images/diagrams/foreman_workflow_final.jpg)

##### Steps

1. On the New Host page, the default VM configuration is shown and compute profiles can be applied.
2. An unused IP address is requested from the DHCP smart proxy associated with the subnet.
3. The IP address field is filled in on the New Host page.
4. n/a
5. The New Host page is submitted.
6. Foreman contacts the compute resource to create the virtual machine.
7. The compute resource creates a virtual machine on a hypervisor.
8. The VM’s MAC address is returned from the compute resource and stored on the host.
9. A reservation is created on the DHCP smart proxy associated with the subnet.
10. DNS records are set up:    
    1. A forward DNS record is created on the smart proxy associated with the domain.
    2. A reverse DNS record is created on the DNS smart proxy associated with the subnet.
11. A PXELinux menu is created for the host in the TFTP smart proxy associated with the subnet.
12. Foreman contacts the compute resource to power on the VM.
13. The compute resource powers up the virtual machine.
14. The host requests a DHCP lease from the DHCP server.
15. The DHCP lease response is returned with TFTP options (next-server, filename) set.
16. The host requests the bootloader and menu from the TFTP server.
17. The PXELinux menu and OS installer for the host is returned over TFTP.
18. The installer requests the “provision” template/script from Foreman.
19. Foreman renders the template and returns the resulting kickstart/preseed to the host.
20. Autosigning configuration for Salt (or Puppet) is added on the Salt or Puppet CA smart proxy.
21. The installer notifies Foreman of a successful build in the postinstall script.
22. The PXELinux menu is reverted to a “local boot” template.
23. The host requests its configuration from Salt or Puppet.
24. The host receives appropriate configuration using data defined in Foreman.
25. Configuration reports and facts are sent from Salt or Puppet to Foreman and stored.

#### 4.4.6.2 Example: Cloud-based provisioning via cloud-init

This example shows workflow of cloud-based provisioning on IaaS (e.g. OpenStack) via cloud-init which configures Puppet agent to finish off the configuration.

![Cloud-based via cloud-init](https://theforeman.org/static/images/diagrams/cloud_init_workflow.png)

#### 4.4.6.3 Example: Cloud-based provisioning via ssh

This example shows workflow of cloud-based provisioning on IaaS (e.g. OpenStack) via ssh finish template for Puppet agent configuration.

![Cloud-based via ssh](https://theforeman.org/static/images/diagrams/cloud_ssh_workflow.png)

#### 4.4.6.4 Example: Image-based provisioning via ssh

This example shows workflow of image-based provisioning on virtualization (e.g. oVirt, RHEV or VMware via ssh finish template for Puppet agent configuration.

![Image-based via ssh](https://theforeman.org/static/images/diagrams/image_workflow.png)

#### 4.4.6.5 Example: Anaconda PXE-based provisioning

This example shows workflow of PXE booting into Anaconda installer with Puppet agent configuration.

![Anaconda](https://theforeman.org/static/images/diagrams/pxe_workflow.png)

### 4.4.7 Networking

Foreman can store information about the networking setup of a host  that it’s provisioning, which can be used to configure the virtual  machine, assign the correct IP addresses and network resources, then  configure the OS correctly during the provisioning process.

This section details the options available for network interfaces in the *New Host* form and how they’re used.

#### Host interface options

- *Primary:* each host must have a single primary interface,  which is used as the name of the host itself.  This should be considered the main hostname and would usually also carry the default route.
- *Provision:* the interface on which provisioning of the  operating system should be carried out.  This will be used for PXE (if  applicable) with TFTP menus, running SSH finish scripts etc.  This may  be different to the primary interface and should have access to Foreman  and other provisioning systems.
- *Managed:* whether Foreman orchestrates creation of DNS  entries, DHCP reservations and configuration of the interface during  provisioning.  Unmanaged interfaces would be used for informational  purposes only.

A simple, single-homed host would have one network interface with a  DNS name set matching the hostname, then managed, primary and provision  flags all ticked.  This would create one interface with DNS and DHCP  records (if configured) over which the OS would be set up.

A dual or multi-homed host could have one interface with primary  enabled (“host.example.com”) and another network with provision enabled  (“host-build.example.com”).  If both are also managed, Foreman will  create DNS and DHCP records for both, but on the provision interface,  the next-server/filename options for PXE will also be set.  A TFTP  (PXELinux) menu would also be created for the provision interface’s MAC  address so the host can PXE boot on that physical interface, while its  hostname would be assigned from the primary interface.

#### Virtual machines and interfaces

When Foreman deploys a host onto a compute resource, it creates a new interface on the VM for each interface specified when creating the  host.

After creation, Foreman reads back the network information and  matches the created interfaces to the list of interfaces given for the  host and stores the assigned MAC and IP addresses (depending on the  compute resource type) in its database.  It then continues with  orchestration, creating DNS and DHCP records etc. for the addresses  retrieved from the new VM.  Once orchestration of these is complete, it  powers up the VM.

This design alleviates the need to supply MAC addresses for hosts being created on compute resources.

#### Subnet options

Subnets are defined in Foreman under *Infrastructure > Subnets*, and have a few options that affect how hosts are provisioned.

- *IPAM:* DHCP will use a DHCP-enabled smart proxy, checking  for assigned leases and reservations and suggesting a new IP from the  range.  Internal DB will use Foreman’s list of already-assigned IPs and  doesn’t rely on a DHCP smart proxy.  None disables auto-suggestion of IP addresses.
- *Boot mode:* during OS provisioning, the template will  configure the interface with either a static IP address or to use DHCP  depending on the value of this setting.

Various combinations of the *IPAM* and *Boot mode* settings make sense, but the most common are *DHCP (IPAM)* with *DHCP (Boot mode)* and *Internal DB* with *Static*.

#### Use within provisioning templates and Puppet

Provisioning templates (such as kickstart, preseed or finish scripts) can make use of the interfaces data stored in Foreman for the host to  configure the network.

A snippet (“kickstart_networking_setup”) is supplied by default in  Foreman for kickstart-based OSes, which configures all managed network  interfaces after the main OS installation is complete.  This can be used in the %post kickstart section.  No template is currently available for preseed-based OSes ([ticket](https://github.com/theforeman/community-templates/issues/173))

A hash of interfaces data is also made available to Puppet via a  global ENC parameter called “foreman_interfaces”.  This can be used to  fully configure the network from a Puppet run.

### 4.4.8 OS Specific Notes

This chapter contains information about provisioning specific operating systems.

### 4.4.8.1 FreeBSD

As the FreeBSD installer itself does not support a kickstart-like  pulling of a response file, a custom mfsBSD image with zfsinstall is  used. Prebuilt images are available [for download](http://downloads.theforeman.org/FreeBSD/) to be placed into the boot directory of your TFTP server.

However, these images can also be built from scratch as described below:

##### Building an installer image

This is an example how to build an image for FreeBSD 10.2-RELEASE. For other releases, simply replace the version accordingly.

```
# fetch the necessary FreeBSD components
mkdir /tmp/basefiles
cd /tmp/basefiles
fetch ftp://ftp.freebsd.org/FreeBSD/releases/amd64/10.2-RELEASE/base.txz
fetch ftp://ftp.freebsd.org/FreeBSD/releases/amd64/10.2-RELEASE/kernel.txz

# clone the git repository
git clone https://github.com/theforeman/mfsbsd.git
cd mfsbsd

# build the image (you need to be root for this to succeed)
make BASE=/tmp/basefiles RELEASE=10.2-RELEASE ARCH=amd64

# copy the image into the TFTP server directory
cp mfsbsd-10.2-RELEASE-amd64.img /tftpboot/boot/FreeBSD-x86_64-10.2-mfs.img
```

### 4.4.8.2 SLES

The installation media URL has to contain the contents of the first  SLES DVD, it’s easiest to loopback mount the ISO image on a webserver.  For Puppet, the `systemsmanagement:puppet` repository on OBS is used.

##### SLES 11

For Puppet, in addition to `systemsmanagement:puppet` also the `devel:languages:ruby:backports` repository on OBS and the SLES SDK DVD is used. The placeholder in the  AutoYaST SLES template has to be updated with the actual SDK URL.

### 4.4.8.3 Windows

Provisioning Windows is a two step process. The first step, [creating Installation Media](https://github.com/kireevco/wimaging), is not discussed here. It includes getting the WIM files, updates and drivers and boot files ready. The necessary boot files are are later downloaded by automatically by the smart proxy.

##### Tasks break down

- Change / add a new Architecture and OS
- Edit provision templates
- Add installation media
- Edit partition table
- Add parameters
- Link provisioning templates to OS

##### Architecture and OS

In *Hosts > Architectures* add a new architecture:

- Name: `x64`

Add a new OS in *Hosts > Operating systems* if needed. If you already have Windows hosts and with Puppet installed, the correct OS and architecture will have been auto created already. This example covers Windows 8.1 / Windows Server 2012R2.

![Add new OS](https://theforeman.org/static/images/screenshots/4.4.8.3_prov_win_os.png)

- Name: `windows`
- Major: `6`
- Minor: `3`
- OS family: `windows`
- Description: `Windows8`
- Root password hash: `Base64`
- Architectures: `x64`

Take special care to set **Root password hash = `Base64`**. The templates do not render correctly if this is set otherwise. Changing the encoding does not [apply to existing hosts](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions).

*Note:* Foreman’s [Safe Mode](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions) does prevent using the password directly. Thus, the string `AdminPassword` needs to be appended to your password when adding a new host. Eg `P@55w0rd` would become `P@55w0rdAdminPassword`. This can be automated however by replacing the password part with a ruby function and disabling safe mode render.

##### Add provision templates

Head to *Hosts > Provisioning Templates* and edit the templates starting with `WAIK` to meet your needs. Make sure to get the latest version of the WAIK templates from the [community templates project](https://github.com/theforeman/community-templates). Assign each of those templates to your Windows OS (does not apply to snippets). The naming of the templates is a suggestion and up to you. This does **not** apply to snippets! There, the name is important.

*Note:* You can find more info about [Foreman Template Writing in the Wiki](http://projects.theforeman.org/projects/foreman/wiki/TemplateWriting).

##### Required templates

**WAIK Finish**

- Name: `WAIK Finish`
- Kind: Finish

**WAIK unattend.xml**

- Name: `WAIK unattend.xml`
- Kind: Provision

**WAIK peSetup.cmd**

- Name: `WAIK peSetup.cmd`
- Kind: Script

*Note:* To get the download folders nicely, the `wget` commands in this template might need tweaking. This could especially be necessary if you intend to use the `extraFinishCommands` snippet. Eg, `--cut-dirs=3` would cut the first three directories form the download path when saving locally. This way `http://winmirror.domain.com/pub/win81x64/extras/puppet.msi` will be stripped of `pub/win81x64/extras` and download to `puppet.msi`.

**WAIK PXELinux**

- Name: `WAIK PXELinux`
- Kind: PXE Linux

##### Optional templates

**WAIK joinDomain.ps1**

- Name: `WAIK joinDomain.ps1`
- Kind: User Data

**WAIK local users**

- Name: `WAIK local users`
- Kind: Snippet

*Note:* This snippet creates extra users in the unattended stage. This may be very useful for debugging early stages of your deployment; since you can find yourself locked out of the newly provisioned host.

Microsoft does not really care about password security in unattend.xml files; so it does not really matter if you use `<PlainText>true</PlainText>` or not. If you prefer the encoded form, you need to append the string `Password` to your user password and encode it to Base64. The following ruby function is an example, it creates the *encoded* from of `P@55w0rd`:

```
Base64.encode64(Encoding::Converter.new("UTF-8", "UTF-16LE",:undef => nil).convert("P@55w0rd"+"Password")).delete!("\n").chomp
```

**WAIK extraFinishCommands**

- Name: `WAIK extraFinishCommands`
- Kind: Snippet

*Note:* The commands here are executed at the last stage just before finishing host building. Make sure they get executed in a synchronous way (eg. do not run in background like msiexec). Otherwise the following reboot might kill them.

**WAIK OU from host group**

- Name: `WAIK OU from host group`
- Kind: Snippet

*Note:* This snippet may be used to generate the computer OU from the host’s host group and domain.

*Example:* Given a host `example` in domain `ad.corp.com` and in host group `servers/windows/databases`. The snippet generates the OU path: `OU=databases,OU=windows,OU=servers,DC=ad,DC=corp,DC=com`. Optionally, set the host parameter `computerOuSuffix` to add some arbitrary OU at the end.

##### Add installation media

For each of your Windows versions add a new installation medium pointing to the root of the folder containing *boot* and *sources* Eg, `http://winmirror.domain.com/pub/win81x64`. Assign them to your operating system.

##### Modify partition table

The default partition table is a simple `diskpart.exe` script. It will wipe `Disk 0`

##### Define templates

Link all the created templates as well as the installation media and partition table to the OS:

1. Head to your OS, then provisioning
2. Select the template from each kind from the drop down list
3. In partition tables, select `WAIK default`
4. In installation media, check the appropriate installation media added above.

![Link templates to OS](https://theforeman.org/static/images/screenshots/4.4.8.3_prov_win_templates.png)

##### Add Parameters

To render the templates correctly, some parameters need to be added.  They need to be available as global/host parameters. Most of them make  the most sense as parameter on the OS. Most parameters are not required and have defaults. For the most up to date description see the  template itself.

##### Important parameters

**Required**

- `windowsLicenseKey`: Valid Windows license key or generic KMS key
- `windowsLicenseOwner`: Legal owner of the Windows license key
- `wimImageName`: WIM image to install from a multi image install.wim file

*Note:* The correct value for `wimImageName` depends on your *install.wim*. The provisioning *will fail* an incorrect value is supplied for a multi image WIM file and gets silently ignored if the image contains one image only.

**Optional** The following parameters are only applied if they exist. Some, like `domainJoinAccount` and `domainJoinAccountPasswd` require each other.

- `systemLocale`: en-US
- `systemUILanguage`: en-US
- `systemTimeZone`: Pacific Standard Time - see [MS TimeZone Naming](https://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx)
- `localAdminAccountDisabled`: false - will keep the local administrator account disabled (default windows)
- `ntpSever`: time.windows.com,other.time.server - ntp server to use
- `domainJoinAccount`: administrator@domain.com - use this account to join the computer to a domain
- `domainJoinAccountPasswd`: Pa55w@rd - Password for the domain join account
- `computerOU`: OU=Computers,CN=domain,CN=com - Place the computer account in specified Organizational Unit
- `computerOuSuffix`: Used if `computerOU` is not present to generate the computer OU from host group and host domain. `computerOU` takes precedence! Note, the OU must still be manually created in active directory
- `computerDomain`: domain.com - domain to join

##### Troubleshooting

**Templates**

The templates most likely need a lot of testing to work. This is not  covered here; though some hints how to start. You should proceed in this order:

1. **Get your templates to render correctly**. Create random `Bare Metal` host in the desired host group for this purpose and make extensive use of [Foreman’s template preview feature](https://www.youtube.com/watch?v=KQnaRAI8rf4).
2. **Continue tesing with VMs** to test netbooting and basic installation
3. **Debug `peSetup.cmd`** by pausing it at the send (remove the comment from `::PAUSE`). Then, use `Ctrl-C` to cancel the script altogether. This way you can debug the rendered `peSetup.cmd` quite nicely in WinPE (eg, `notepad peSetup.cmd`)
4. The `WAIK Finish` template uses `sDelete.exe` to remove all rendered commands from the provided host. Comment out all `sDelete` commands to debug finish scripts.
5. Use a manual installed host to test rendered snippets like `WAIK extraFinishCommands` directly.
6. **Examine `C:\foreman.log.`** - the output left from the finish script. Also, comment out the clean  up stage in the finish script to examine and test the rendered scripts  directly.

**Netbooting**

Sometimes wimboot seems not to be able to boot our winPE.wim. Symptoms range from black screens to kernel panics (aka *BSOD*). These problems seem to be more likely on older hardware.

In this case a workaround can be to simply use any other bootable  media like USB thumb drives and CD-ROMs. The process is relatively  simple:

1. Use a common tool [Media Creator](http://windows.microsoft.com/en-us/windows-8/create-reset-refresh-media) to create a bootable medium like a USB stick or ISO image. Since we do  not use the image downloaded by the tool, the only important choice is `architecture`.
2. In the image or the USB drive, replace `sources/boot.wim` with the version from the installation media.
3. Boot from the medium.

## 4.5 Command Line Interface

The framework used for implementation of command line client for  foreman provides many features common for modern CLI applications. The  task of managing Foreman from command line is quite complex so the  commands have to be  organized in more levels of subcommands. There is  help available for each level to make it easy to use. Some other  features for greater comfort are option validation, logging and  customizable output formatting.

### 4.5.1 Usage Examples

Basic help and list of supported commands:

```
$ hammer -h
Usage:
    hammer [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    architecture                  Manipulate architectures.
    auth                          Foreman connection login/logout.
    compute-resource              Manipulate compute resources.
    domain                        Manipulate domains.
    environment                   Manipulate environments.
    fact                          Search facts.
    filter                        Manage permission filters.
    global-parameter              Manipulate global parameters.
    host                          Manipulate hosts.
    hostgroup                     Manipulate hostgroups.
    location                      Manipulate locations.
    medium                        Manipulate installation media.
    model                         Manipulate hardware models.
    organization                  Manipulate organizations.
    os                            Manipulate operating system.
    partition-table               Manipulate partition tables.
    proxy                         Manipulate smart proxies.
    puppet-class                  Search puppet modules.
    report                        Browse and read reports.
    role                          Manage user roles.
    sc-param                      Manipulate smart class parameters.
    shell                         Interactive shell
    subnet                        Manipulate subnets.
    template                      Manipulate config templates.
    user                          Manipulate users.
    user-group                    Manage user groups.

Options:
    -v, --verbose                 be verbose
    -c, --config CFG_FILE         path to custom config file
    -u, --username USERNAME       username to access the remote system
    -p, --password PASSWORD       password to access the remote system
    --version                     show version
    --show-ids                    Show ids of associated resources
    --csv                         Output as CSV (same as --adapter=csv)
    --output ADAPTER              Set output format. One of [base, table, silent, csv]
    --csv-separator SEPARATOR     Character to separate the values
    -P, --ask-pass                Ask for password
    --autocomplete LINE           Get list of possible endings
    -h, --help                    print help
```

First level command help:

```
$ hammer architecture -h
Usage:
    hammer architecture [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    list                          List all architectures.
    info                          Show an architecture.
    create                        Create an architecture.
    delete                        Delete an architecture.
    update                        Update an architecture.
    add_operatingsystem           Associate a resource
    remove_operatingsystem        Disassociate a resource

Options:
    -h, --help                    print help
```

Second level command help:

```
$ hammer architecture create -h
Usage:
    hammer architecture create [OPTIONS]

Options:
    --name NAME
    --operatingsystem-ids OPERATINGSYSTEM_IDS
                                  Operatingsystem ID’s
    -h, --help                    print help
```

### 4.5.2 Success Story

There was a set of common commands identified as necessary for basic Foreman management, we called it “success story” and [track](http://projects.theforeman.org/issues/3297) the progress of its implementation. The commands could also serve as a basic hammer cookbook.

The goal is to provision bare metal host on a clean install of Foreman. The following steps are necessary:

- create smart proxy    

  ```
  hammer proxy create --name myproxy --url https://proxy.my.net:8443
  ```

- create architecture    

  ```
  hammer architecture create --name x86_64
  ```

- create new subnet    

  ```
  hammer subnet create --name "My Net" --network "192.168.122.0" --mask "255.255.255.0" --gateway "192.168.122.1" --dns-primary "192.168.122.1"
  ```

- import existing subnet from a proxy

  missing, see [#3355](http://projects.theforeman.org/issues/3355)

- create new domain    

  ```
  hammer domain create --name "my.net" --fullname "My network"
  ```

- associate domain with proxy    

  ```
  hammer domain update --id 1 --dns-id 1
  ```

- associate subnet with domain    

  ```
  hammer subnet update --id 1 --domain-ids 1
  ```

- associate subnet with proxy (DHCP, TFTP, DNS)    

  ```
  hammer subnet update --id 1 --dhcp-id 1 --tftp-id 1 --dns-id 1
  ```

- create new partition table    

  ```
  hammer partition_table create --name "Redhat test" --file /tmp/rh_test.txt
  ```

- create new OS    

  ```
  hammer os create --name RHEL --major 6 --minor 4
  ```

- create new template    

  ```
  hammer template create --name "kickstart mynet" --type provision --file /tmp/ks.txt
  ```

- edit existing pre-defined template    

  ```
  hammer template dump --id 4 > /tmp/ks.txt
    vim /tmp/ks.txt
  hammer template update --id 4 --file /tmp/ks.txt
  ```

- associate applicable OS with pre-defined template    

  ```
  hammer template update --id 1 --operatingsystem-ids 1
  ```

  Listing associated OS’s is still missing - see [#3360](http://projects.theforeman.org/issues/3360)

- associate OS with architecture    

  ```
  hammer os update --id 1 --architecture-ids 1
  ```

- associate OS with part table    

  ```
  hammer os update --id 1 --ptable-ids 1
  ```

- associate OS with install media    

  ```
  hammer os update --id 1 --medium-ids 1
  ```

- associate OS with install provision and pxelinux templates

  Missing, needs investigation, may be related to [#3360](http://projects.theforeman.org/issues/3360)

- create libvirt compute resource    

  ```
  hammer compute_resource create --name libvirt --url "qemu:///system" --provider Libvirt
  ```

- import puppet classes

  missing - see [#3035](http://projects.theforeman.org/issues/3035)

- and finally create a bare metal host entry

  works with some options, needs improvements - see [#3063](http://projects.theforeman.org/issues/3063)

## 4.6 Email Management

Foreman is also able to send out a variety of email notifications  either on an event, or summary messages on a regular schedule.  Plugins  are also able to extend this with their own summaries and notifications.

To send email requires a configured SMTP server or local MTA (e.g. sendmail), which is set up in `Adminster > Settings > Email` as per [Configuration Options](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions).

Scheduled emails are sent through rake tasks (reports:daily,  reports:weekly, reports:monthly) run from cronjobs, which are configured in `/etc/cron.d/foreman`.

### 4.6.1 Email Preferences

#### Users

Email messages are sent to individual users registered to Foreman, to the email address configured on the account if present.  Users can edit the email address by clicking on their name in the top-right hand  corner of the web page and selecting *My account*.

To change which message subscriptions are received by an individual user, the *Mail Preferences* tab under the user account lists all available message types and the  frequency at which each message should be received.  A global checkbox  to disable all email messages from Foreman is also available.

Event-based notifications can either be enabled or disabled, and  these are sent from Foreman at the same time as the event occurring.   Scheduled notifications can be sent either daily, weekly or monthly.

#### Hosts

Notifications relating to hosts can be disabled on a per-host basis, useful when errors are expected.  On the host’s *Additional Information* tab, untick *Enabled* to disable notifications and remove the host from reports.  Enabling  and disabling notifications can also be done from the host list by using the tickboxes and selecting *Enable/Disable Notifications* from the *Select Action* dropdown menu.

Event notifications for a host are sent to the host’s registered owner.  This is selected on the *Additional Information* tab of the host, and may be either an individual user or a user group.  When set to a user group, all group members who are subscribed to the  email type will receive a message.

### 4.6.2 Account Notifications

#### New account welcome email

When the `send_welcome_email` setting is enabled ([Configuration Options](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions)), new account holders will receive an email providing their username and a link to Foreman.

### 4.6.3 Host Notifications

#### Build complete

When a host has completed its build process, either notifying Foreman of completion via a request at the end of its unattended installation  or after Foreman has run a script remotely, this email notification will be sent to owners of the host.

#### Puppet error state

When a Puppet report is received that puts the host into a red error  state, a corresponding email notification is sent to owners of the host.

### 4.6.4 Scheduled Emails

#### Audit summary

A regular summary email of all changes to objects in Foreman that triggered audit events (see [Auditing](https://theforeman.org/manuals/3.5/index.html#4.1.4Auditing)), including the user that made the change, the time of the change and a link to further details.

#### Puppet summary

A regular overview of all hosts that a user has access to, and their  Puppet status.  This includes the number of Puppet events over the  reporting period, such as applied, skipped and failed resources.

## 4.7 Managing Ansible

Please refer to the [foreman_ansible plugin documentation](https://theforeman.org/plugins/foreman_ansible/).

## 4.8 Managing Chef

The `foreman_chef` plugin has been removed.

## 4.9 Managing Salt

Documentation: [Using Salt for Configuration Management](https://docs.theforeman.org/nightly/Managing_Hosts/index-foreman-el.html#Using_Salt_for_Configuration_Management_managing-hosts)

## 4.10 Monitoring

To monitor your infrastructure, host statuses are useful. In Foreman each host has a *global* status that indicates which hosts need attention. Each host also has sub-statuses that represents status of a particular feature. With any change of a sub-status, the global status is recalculated and the result is determined by statuses of all sub-statuses.

### 4.10.1 Global status

The global status represents the overall status of a particular host. The status can have one of three possible values - **OK**, **Warning** or **Error**.

OK means that no errors were reported by any sub-status. It is represented with the color green.

Warning suggests that user should verify the status, while no error was detected, some sub-status raised a warning. A good example would be that there are no Puppet reports for the host even though the host is configured to send Puppet reports. Therefore it is highlighted with the color yellow.

The last possible value is Error which indicates that some sub-status reports a failure. This could for example mean that Puppet run contains some failed resources. Obviously it is something that should be fixed and is user is alerted by the color red.

You can find global status on hosts overview page displayed as a small icon next to host name with corresponding color. Hovering over the icon renders a tooltip with sub-status information to quickly find out more details.

![Global statuses](https://theforeman.org/static/images/screenshots/4.9.1_global_statuses.png)

### 4.10.2 Sub-statuses

A sub-status monitors only a part of host capabilities. Currently Foreman ships only two - **build** and **configuration** sub-statuses. Not all sub-statuses are relevant for all hosts, therefore configuration is only considered if host is using some configuration management system, e.g. has some Puppet proxy associated. Build sub-status is relevant for managed hosts and when Foreman is run in unattended mode.

You can see a global host status with all sub-statuses on the host detail page, in the properties table. Note that there can be more sub-statuses added by plugins.

![All statuses](https://theforeman.org/static/images/screenshots/4.9.2_all_statuses.png)

Each sub-status can define own set of possible values that are mapped to three global status values. Build sub-status has two possible values - **pending** and **built** that are both mapped to global OK value. Configuration status is more complicated and its possible values and mappings are described in table below.

| Status value       | Maps to      | Description                                                  |
| ------------------ | ------------ | ------------------------------------------------------------ |
| ***Error\***       | Error        | Error during configuration, e.g. Puppet run failed to install some package |
| ***Out of sync\*** | Warning      | A configuration report was not received within the expected interval, based on the *outofsync_interval*1 |
| ***No reports\***  | Warning / OK | When there are no reports but the host uses configuration management system (e.g. Puppet proxy is associated) or *always_show_configuration_status* setting is set to true, it maps to Warning. Otherwise it is mapped to OK. |
| ***Active\***      | OK           | During last Puppet run, some resources were applied          |
| ***Pending\***     | OK           | During last Puppet run, some resources would be applied but Puppet was configured to run in noop mode |
| ***No changes\***  | OK           | During last Puppet run, nothing has changed                  |

1 Reports are identified by an origin and can have  different intervals based upon it. For example, reports by Puppet will  have ‘Puppet’ as it’s origin and will have it’s interval set by *puppet_interval*.

### 4.10.3 Searching by statuses

You can search hosts by global status. Some examples can be found below:

- search for all hosts that are OK

  `global_status = ok`

- search for all hosts that deserves some attention

  `global_status = error or global_status = warning`

To search hosts based on configuration status you can search by last report metrics like this:

- find hosts that have at least one pending resource

  `status.pending > 0`

- find hosts that restarted some service during last puppet run

  `status.restarted > 0`

- find hosts that have an interesting last Puppet run (something happened)

  `status.interesting = true`

## 4.11 Reports

Foreman provides reporting capabilities. It uses the same templating engine as for provisioning templates and partition tables. The list of macros that can be used in this context slightly differs as reports are usually rendered for a specific host. Reports do not enforce any output format as the formatting is part of the template itself, the only requirement is, that the resulting output is textual form.

### 4.11.1 Report Templates

You can find existing report templates under *Monitor -> Report Templates*. Foreman comes with few default report templates that are locked. As with other templates, we do not recommend unlocking and modifying them, as they are automatically updated on upgrades. If a change of default template is desired, it’s recommended to clone the template and do adjustments in the clone.

#### Generating

To generate a report out of the report template, find the report template and click the *Generate* button. This will evaluate a template and respond with text file for download. The rendering itself is done in a background process, but it can run for a long time.

There’s a separate permission for generating the report, so only selected users can perform resource heavy operations while another users can prepare the report templates.

##### Scheduling and delivering reports via e-mail

In the form for report generating you can choose a starting time for delayed rendering. There is no way to schedule repetitions, but as the report generating can be started by a *hammer report-template* command, scheduling can be achieved using cron. For these planned reports, as well as for long running reports, it is no longer useful to have the report downloaded by the web browser. In such cases you can choose to get the report delivered via e-mail by simply checking *Send report via e-mail* and filling the e-mail addresses field. Your default e-mail address is prefilled, but you can fill other(s) and send reports for further processing.

### 4.11.2 Macros

For report templates, it’s useful to access more data from database than in regular provisioning templates. Typically it’s needed to load all hosts matching some search query. If safe mode rendering is enabled, access to internal objects is restricted. Foreman provides resource loading macros such as load_hosts. They all have following behaviors and capabilities:

- accepts search keyword to limit what resources should be loaded
- accepts include keyword to specify associated objects that should be eager loaded
- load data in batches
- authorize the resources based on current user permissions

Consider following example:

```
<%- load_hosts(search: 'name ~ example.com').each_record do |host| -%>
<%=   host.name %>,<%= host.mac %>
<%- end -%>
```

It loads all hosts that contains domain example.com in their name. If it’s more than 1,000 hosts, it will trigger separate SQL query for each thousand automatically. Then it iterates over all found hosts and print comma separated pair of host name and MAC address. The query will return only hosts that current user has view_hosts permission for.

For more examples see default report templates.

# 5. Advanced Foreman

## 5.1 API

[API v2](https://theforeman.org/api/3.5/index.html) is the default, stable and recommended version for Foreman 3.5. Foreman 1.22 and above also provides a [GraphQL](https://graphql.org/) API. This API is considered experimental for now. Please test it and  provide feedback, we do not recommend it for production use just yet.

This section documents the JSON API conventions for the Foreman API  v2 and Katello API v2. To explicitly select the API version, see [Section 5.1.6](https://theforeman.org/manuals/3.5/index.html#5.1.6APIVersioning).

### 5.1.1 CRUD Request Examples

The following examples show the basic CRUD operations (Create, Read, Update, Delete) using the JSON API.

 

#### Show a Collection of Objects

Get of a collection of domains: `GET /api/domains`

Send a HTTP **GET** request. No JSON data hash is required.

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" https://foreman.example.com/api/domains
```

This returns a collection JSON response. The format for a collection response is described in [Section 5.1.2](https://theforeman.org/manuals/3.5/index.html#5.1.2JSONResponseFormatforCollections).

 

#### Show a Single Object

Get a single domain: `GET /api/domains/:id` or `GET /api/domains/:name`

Send a HTTP **GET** request with the object’s unique identifier, either `:id` or `:name`. No JSON data hash is required.

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains/42
# or
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains/foo
```

This returns a single object in JSON format. The format for a single object response is described in [Section 5.1.3](https://theforeman.org/manuals/3.5/index.html#5.1.3JSONResponseFormatforSingleObjects).

 

#### Create an Object

Create a new domain: `POST /api/domains`

Send a HTTP **POST** request with a JSON data hash containing the required fields to create the object. In this example, a domain is being created.

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" -H "Content-Type: application/json" \
    -X POST -d '{ "name":"foo.bar.com","fullname":"foo.bar.com description" }' \
    https://foreman.example.com/api/domains
```

This returns the newly created object in JSON format, with the same  attributes as in the show/GET call. The format for a single object  response is described in [Section 5.1.3](https://theforeman.org/manuals/3.5/index.html#5.1.3JSONResponseFormatforSingleObjects).

The HTTP response code of the create call will be 201, if created successfully.

 

#### Update an Object

Update a domain: `PUT /api/domains/:id` or `PUT /api/domains/:name`

Send a HTTP **PUT** request with the object’s unique identifier, either `:id` or `:name`, plus a JSON data hash containing only the data to be updated. In this example, only the domain name is being updated.

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" -H "Content-Type: application/json" \
    -X PUT -d '{ "name": "a new name" }' https://foreman.example.com/api/domains/12
# or
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" -H "Content-Type: application/json" \
    -X PUT -d '{ "name": "a new name" }' https://foreman.example.com/api/domains/foo
```

This returns the newly updated object in JSON format. The format for a single object response is described in [Section 5.1.3](https://theforeman.org/manuals/3.5/index.html#5.1.3JSONResponseFormatforSingleObjects).

 

#### Delete an Object

Delete a domain: `DELETE /api/domains/:id` or `DELETE /api/domains/:name`

Send a HTTP **DELETE** request with the object’s unique identifier, either `:id` or `:name`. No JSON data hash is required.

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" -X DELETE \
    https://foreman.example.com/api/domains/17
# or
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" -X DELETE \
    https://foreman.example.com/api/domains/foo
```

This returns the deleted object in JSON format. The format for a single object response is described in [Section 5.1.3](https://theforeman.org/manuals/3.5/index.html#5.1.3JSONResponseFormatforSingleObjects).

### 5.1.2 JSON Response Format for Collections

Collections are a list of objects (i.e. hosts, domains, etc). The format for a collection JSON response consists of a `results` root node and metadata fields `total, subtotal, page, per_page`. Note: for Katello objects, the metadata includes `limit, offset` instead of `page, per_page`.

Below is an example of the format for a collection JSON response for a list of domains: `GET /api/domains`

```
{
    "total": 3,
    "subtotal": 3,
    "page": 1,
    "per_page": 20,
    "search": null,
    "sort": {
        "by": null,
        "order": null
    },
    "results": [
        {
            "id": 23,
            "name": "qa.lab.example.com",
            "fullname": "QA",
            "dns_id": 10,
            "created_at": "2013-08-13T09:02:31Z",
            "updated_at": "2013-08-13T09:02:31Z"
        },
        {
            "id": 25,
            "name": "sat.lab.example.com",
            "fullname": "SATLAB",
            "dns_id": 8,
            "created_at": "2013-08-13T08:32:48Z",
            "updated_at": "2013-08-14T07:04:03Z"
        },
        {
            "id": 32,
            "name": "hr.lab.example.com",
            "fullname": "HR",
            "dns_id": 8,
            "created_at": "2013-08-16T08:32:48Z",
            "updated_at": "2013-08-16T07:04:03Z"
        }
    ]
}
```

The response metadata fields are described below:

- `total` - total number of objects without any search parameters

- `subtotal` - number of objects returned with given search parameters (if there is no search, then `subtotal` equals `total`)

- `page` (Foreman only) - page number

- `per_page` (Foreman only) - maximum number of objects returned per page

- `limit` - (Katello only) specified number of objects to return in collection response

- `offset` - (Katello only) number of objects skipped before beginning to return collection.

- `search` - search string (based on scoped_scoped syntax)

- ```plaintext
  sort
  ```

  - `by` - the field that the collection is sorted by
  - `order` - sort order, either ASC for ascending or DESC for descending

- `results` - collection of objects. See [Section 5.1.4](https://theforeman.org/manuals/3.5/index.html#5.1.4CustomizeJSONResponses) for how to change the root name from ‘results’ to something else.

### 5.1.3 JSON Response Format for Single Objects

Single object JSON responses are used to show a single object. The object’s unique identifier `:id` or `:name` is required in the **GET** request. Note that `:name` may not always be used as a unique identifier, but `:id` can always be used. The format for a single object JSON response consists of only the object’s attributes. There is **no root node** and **no metadata** by default. See [Section 5.1.4](https://theforeman.org/manuals/3.5/index.html#5.1.4CustomizeJSONResponses) for how to add a root name.

Below is an example of the format for a single object JSON response: `GET /api/domains/23` or `GET /api/domains/qa.lab.example.com`

```
{
    "id": 23,
    "name": "qa.lab.example.com",
    "fullname": "QA",
    "dns_id": 10,
    "created_at": "2013-08-13T09:02:31Z",
    "updated_at": "2013-08-13T09:02:31Z"
}
```

### 5.1.4 Customize JSON Responses

#### Customize Root Node for Collections

The default root node name for collections is `results` but can be changed.

To change the root node name per API request, pass `root_name=` as a URL parameter. See example below:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains?root_name=data
```

 

#### Customize Root Node for Single Object

There is no root node as the default for single object JSON responses, but it can be added.

To change the object’s root node name per API request, pass `object_name=` as a URL parameter. See example below:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains/23?object_name=record
```

 

#### Customize Partial Response Attributes

Currently, there is no option to change or customize which attributes are returned for collections or single objects. In the future,  customized partial responses such as `fields=field1,field2,field3` or `fields=all` may be implemented ([#3019](http://projects.theforeman.org/issues/3019)). Similarly, there is currently no option to specify child nodes in an  API call or to remove child nodes if they are returned by default.

 

#### Custom Number of Objects in Collection Per Response

Foreman paginates all collections in the JSON response. The number of objects returned per request is defined in *Administer > Settings > General > entries_per_page*.  The default is 20.  Thus, if there are 27 objects in a collection, only 20 will be returned for the default page=1.

To view the next page, pass `page=` as a URL parameter. See example below:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains?page=2
```

The example above will show the remaining 7 objects in our example of 27 objects in the collection.

To increase or decrease the number of objects per response, pass `per_page=` as a URL parameter. See example below:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains?per_page=1000
```

This will return all the objects in one request since 27 is less than the `per_page` parameter set to 1000.

 

#### Custom Search of Collections Per Response

Foreman uses the scoped_search library for searching and filtering  which allows all query search parameters to be specified in one string.  The syntax is described in the [Searching](https://theforeman.org/manuals/3.5/index.html#4.1.5Searching) section, and matches exactly the syntax used for the web UI search  boxes.  This allows you use of the auto-completer and to test a query in the UI before reusing it in the API.

To filter results of a collection, pass `search=` as a URL parameter, ensuring that it is fully URL-escaped to prevent  search operators being misinterpreted as URL separators. See example  below:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains?search=name%3Dexample.com
```

The number of objects returned will be shown in the `subtotal` metadata field, and the query string will be shown in the `search` metadata field.

 

#### Custom Sort of Collections Per Response

Custom sort order per collection can be specified by passing `order=` as a URL parameter. See example below:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    https://foreman.example.com/api/domains?order=name+DESC
```

The default sort order is ascending (ASC) if only a field name is passed.  The sort parameters will be shown in `sort` `by` and `order` metadata fields.

### 5.1.5 Nested API routes

The goal is to implement nested routes for all objects as an alternative to filtering collections.

For example, rather then filtering subnets by a specified domain using a search string

```
$ GET /api/subnets?search=name%3Dqa.lab.example.com
```

the alternative nested route below returns the same result as the above.

```
$ GET /api/domains/qa.lab.example.com/subnets
```

All actions will be accessible in the nested route as in the main route.

### 5.1.6 API Versioning

The default API version is v2 for Foreman 3.5, however explicitly  requesting the version is recommended.  Both API v1 and v2 are currently shipped.

There are two methods of selecting an API version:

1. In the **header**, pass `Accept: application/json,version=2`
2. In the **URL**, pass /v2/ such as `GET /api/v2/hosts`

Similarly, v1 can still be used by passing `Accept: application/json,version=1` in the header or `api/v1/` in the URL.

### 5.1.7 Handling Associations

Updating and creating associations are done in a few different ways in the API depending on the type of association.

#### One-to-One and One-to-Many

To update a one-to-one or a one-to-many association, simply set the name or id on the object. For example, to set a host group for a host, simply set the hostgroup_name or hostgroup_id of the host.

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    -H "Content-Type: application/json" -X POST \
    -d '{ "hostgroup_name": "telerin" }' \
    https://foreman.example.com/api/hosts/celeborn.firstage

$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    -H "Content-Type: application/json" -X POST \
    -d '{ "hostgroup_id": 42 }' \
    https://foreman.example.com/api/hosts/celeborn.firstage
```

#### Many-to-One and Many-to-Many

To update an association for an object that contains a collection of other objects, there are a few options. First you can set the names or ids:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    -H "Content-Type: application/json" -X POST \
    -d '{ "host_names": ["enel.first", "celeborni.first", "elwe.first"] }' \
    https://foreman.example.com/api/hostgroups/telerin

$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    -H "Content-Type: application/json" -X POST \
    -d '{ "host_ids": [4, 5, 6] }' \
    https://foreman.example.com/api/hostgroups/telerin
```

This will set the host group’s hosts to enel, celeborn, and elwe (or 4, 5, 6) and only those.

Alternatively, you can pass in a set of objects:

```
$ curl -k -u admin:changeme -H "Accept: version=2,application/json" \
    -H "Content-Type: application/json" -X POST \
    -d '{ "domains": [{ "name": "earendil", "id": 1}, { "name": "turgon", "id": 3 }] }' \
    https://foreman.example.com/api/subnets/iluvatar
```

This would set the domains for the subnet to be earendil and turgon. If another domain for example belonged to the subnet before the request, it would be removed.

### 5.1.8 Authentication

The API requires authentication for all endpoints, typically using  HTTP Basic authentication. Requests with credentials are authenticated  against the users stored in Foreman.

#### HTTP Basic authentication

HTTP Basic authentication (RFC 2617) is supported by a wide range of  API and web clients and works by specifying a Base64-encoded username  and password in an `Authorization` header. For example, these common clients can access the API with the following arguments:

- `curl -u admin:changeme`, or `curl -u admin` (interactive prompt)
- `wget --user=admin --password=changeme`

Every call to the API will require authentication, unless the client  supports sessions (see below). Some clients may also support storing  credentials in `~/.netrc` or similar for more privacy.

No confidentiality is provided with this method, so it is very  important to use HTTPS when connecting to Foreman to prevent the  plain-text credentials from being obtained. (Note that when `require_ssl` is enabled, access to the API will only be allowed over HTTPS.)

#### Session support

When authenticating to the API, a new server-side session will be  created on each request and the response will contain a cookie  containing a session ID. If this cookie is stored by the client, it can  be used on subsequent requests so the credentials are only passed over  the connection once.

A basic authenticated request to the status API returns the following `Set-Cookie` header, containing a `_session_id` cookie:

```
> GET /api/v2/status HTTP/1.1
> Authorization: Basic YWRtaW46Y2hhbmdlbWU=
> Host: foreman.example.com
> Accept: */*

< HTTP/1.1 200 OK
< ...
< Set-Cookie: _session_id=572ca37e8c5845b900cc58d45d6e1e34; path=/; secure; HttpOnly
```

When supplying this on subsequent requests, they will use the same account:

```
> GET /api/v2/status HTTP/1.1
> Host: foreman.example.com
> Accept: */*
> Cookie: _session_id=572ca37e8c5845b900cc58d45d6e1e34

< HTTP/1.1 200 OK
< ...
```

Command-line clients may support cookie jars for automatic storage of cookies, e.g. `curl -c ~/.foreman_cookies -b ~/.foreman_cookies` will automatically store and use cookies.

### 5.1.9 Using OAuth

Alternatively to basic authentication, limited OAuth 1.0 authentication is supported in the API.

#### Configuration of OAuth in Foreman

OAuth must be enabled in Foreman settings. In *Administer > Settings > Authentication*, search for *OAuth active* configuration and set it to *Yes*. Then set *OAuth consumer key* to some string. This will be a token used by all OAuth clients.

If you want all API requests made using OAuth to be authorized as built-in anonymous admin user keep *OAuth map users* set to *No*. If you want to specify the user under which the request is made, change this configuration option to *Yes*. This  allows client to send FOREMAN-USER header with the login of existing Foreman user. Please note that this header is not signed in OAuth request so can be forged. Anyone with valid consumer key can impersonate any Foreman user.

#### Request example

Usually some OAuth client library is used to generate the request. An example of curl command can be found here to better understand how it works

```
$ curl 'https://foreman.example.com/api/architectures' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json,version=2' \
  -H 'FOREMAN-USER: ares' \
  -H 'Authorization: OAuth oauth_version="1.0",oauth_consumer_key="secretkey",oauth_signature_method="hmac-sha1",oauth_timestamp=1321473112,oauth_signature=Il8hR8/ogj/XVuOqMPB9qNjSy6E='
```

In example above we list architectures using OAuth for authentication. We try to do the request under user with login *ares*, if mapping is enabled on Foreman side, the result will only include architectures, that user *ares* can see. Note that we constructed the signature manually, this should change with any oauth_timestamp change. Also it reflects every parameter, HTTP method and URI change. Therefore we recommend using some OAuth client library that will construct all OAuth parameters.

### 5.1.10 Using Apipie-Bindings

The following examples show how to do basic API operations using [apipie-bindings](https://github.com/Apipie/apipie-bindings).

#### Show a Collection of Objects

Get of a collection of domains: `GET /api/domains`

Call the **index** function of the **domains** resource.

```
#!/usr/bin/env ruby

require 'apipie-bindings'

url = 'https://foreman.example.com/'
username = 'admin'
password = 'changeme'
api = ApipieBindings::API.new({:uri => url, :username => username, :password => password, :api_version => '2'})
domains = api.resource(:domains).call(:index)

domains['results'].each do |domain|
  puts domain
end
$ ruby domains.rb
{"fullname"=>"", "dns_id"=>1, "created_at"=>"2016-05-06 08:46:20 UTC", "updated_at"=>"2016-11-24 11:49:06 UTC", "id"=>1, "name"=>"example.com"}
```

#### Show a Single Object

Get a single domain: `GET /api/domains/:id` or `GET /api/domains/:name`

Call the **show** function of the **domains** resource with the object’s unique identifier `:id` or `:name`.

```
#!/usr/bin/env ruby

require 'apipie-bindings'

url = 'https://foreman.example.com/'
username = 'admin'
password = 'changeme'
api = ApipieBindings::API.new({:uri => url, :username => username, :password => password, :api_version => '2'})
puts api.resource(:domains).call(:show, {:id => 1})
puts api.resource(:domains).call(:show, {:id => 'example.com'})
```

#### Create an Object

Create a new domain: `POST /api/domains`

Call the **create** function of the **domains** resource with a JSON data hash containing the required fields to create the object. In this example, a domain is being created.

```
#!/usr/bin/env ruby

require 'apipie-bindings'

url = 'https://foreman.example.com/'
username = 'admin'
password = 'changeme'
api = ApipieBindings::API.new({:uri => url, :username => username, :password => password, :api_version => '2'})
api.resource(:domains).call(:create, {:domain => {:name => "foo.example.com", :fullname => "foo.example.com"}})
```

#### Update an Object

Update a domain: `PUT /api/domains/:id` or `PUT /api/domains/:name`

Call the **update** function of the **domains** resource with the object’s unique identifier, either `:id` or `:name`, plus a JSON data hash containing only the data to be updated. In this example, only the domain name is being updated.

```
#!/usr/bin/env ruby

require 'apipie-bindings'

url = 'https://foreman.example.com/'
username = 'admin'
password = 'changeme'
api = ApipieBindings::API.new({:uri => url, :username => username, :password => password, :api_version => '2'})
api.resource(:domains).call(:update, {:id => 3, :domain => {:name => "foo.example.com", :fullname => "foo.example.com"}})
```

#### Delete an Object

Delete a domain: `DELETE /api/domains/:id` or `DELETE /api/domains/:name`

Call the **destroy** function of the **domains** resource with the object’s unique identifier, either `:id` or `:name`.

```
#!/usr/bin/env ruby

require 'apipie-bindings'

url = 'https://foreman.example.com/'
username = 'admin'
password = 'changeme'
api = ApipieBindings::API.new({:uri => url, :username => username, :password => password, :api_version => '2'})
api.resource(:domains).call(:destroy, {:id => 3})
```

### 5.1.11 Using Graphql

The following examples show how to do basic API operations using [GraphQL](https://graphql.org/).

#### Access the API

The GraphqlAPI is available at `/api/graphql`.

#### Query the API with curl

This command shows how you can query the API with curl.

```
curl -u username:password -X POST -H "Content-Type: application/json" --data '{ "query": "{ domains { nodes {  name } } }" }' https://foreman.example.com/api/graphql
```

#### Show a Collection of Objects

Get of a collection of domains:

Query:

```
{
  domains(search: "name ~ example.com") {
    nodes {
      name
    }
  }
}
```

Result:

```
{
  "data": {
    "domains": {
      "nodes": [
        {
          "name": "example.com"
        }
      ]
    }
  }
}
```

#### Show a Single Object

Get a single domain:

Query:

```
{
  domain(id: "MDE6RG9tYWluLTQ=") {
    name,
    createdAt
  }
}
```

Result:

```
{
  "data": {
    "domain": {
      "name": "example.com",
      "createdAt": "2017-01-18T11:12:52+01:00"
    }
  }
}
```

### 5.1.12 Dynflow scaling

Starting with Foreman 2.0 Foreman uses Dynflow backed by Sidekiq by  default on all supported platforms. This change is described in greater  detail in [Upcoming changes to Dynflow](https://community.theforeman.org/t/upcoming-changes-to-dynflow/14926). The original Dynflow executor service (called `dynflowd`) was replaced by `redis` and a set of `dynflow-sidekiq@*` services. This new deployment model should address issues we have seen  when restarting the Dynflow executor. It also allows us scale more  easily, dedicate workers to specific queues and increase the overall  throughput. The following examples show how to scale Dynflow up in the  new model.

### Clean state

Out of the box, foreman ships with orchestrator and a single worker If you have Katello, you will get an additional worker for processing of the host queue

```
# ls -l /etc/foreman/dynflow/
total 1
-rw-r--r--. 1 root foreman 51 May 14 07:35 orchestrator.yml
-rw-r--r--. 1 root foreman 59 May 14 07:35 worker.yml
```

The orchestrator consumes items only from the `dynflow_orchestrator` queue and has only one thread. This is by design. *Do not change this*

```
# cat /etc/foreman/dynflow/orchestrator.yml
:concurrency: 1
:queues:
  - dynflow_orchestrator
```

The regular worker has 5 threads and consumes items from default and remote_execution queues. It is not recommended to change the configuration for this process either, because the changes would be overwritten by the installer, if run again.

```
# cat /etc/foreman/dynflow/worker.yml
:concurrency: 5
:queues:
  - default
  - remote_execution
```

### Scaling up

Scaling up is pretty straightforward, especially if you want to only scale up what you have Here we use symbolic links to “share” the actual configuration among `worker`, `worker-1` and `worker-2`

```
# cd /etc/foreman/dynflow
# ln -s worker.yml worker-1.yml
# ln -s worker.yml worker-2.yml
```

Check that the symbolic links are pointing to the right files

```
# ls -l /etc/foreman/dynflow/
total 2
-rw-r--r--. 1 root foreman 51 May 14 07:35 orchestrator.yml
lrwxrwxrwx. 1 root root    10 May 14 11:24 worker-1.yml -> worker.yml
lrwxrwxrwx. 1 root root    10 May 14 11:24 worker-2.yml -> worker.yml
-rw-r--r--. 1 root foreman 59 May 14 07:35 worker.yml
```

Now start the newly configured services and check their status

```
# systemctl enable --now dynflow-sidekiq@worker-{1,2}
Created symlink /etc/systemd/system/multi-user.target.wants/dynflow-sidekiq@worker-1.service → /lib/systemd/system/dynflow-sidekiq@.service.
Created symlink /etc/systemd/system/multi-user.target.wants/dynflow-sidekiq@worker-2.service → /lib/systemd/system/dynflow-sidekiq@.service.

# systemctl status dynflow-sidekiq@worker-{1,2}
● dynflow-sidekiq@worker-1.service - Foreman jobs daemon - worker-1 on sidekiq
   Loaded: loaded (/lib/systemd/system/dynflow-sidekiq@.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2020-05-14 11:24:19 UTC; 6s ago
     Docs: https://theforeman.org
 Main PID: 1422 (ruby2.5)
    Tasks: 5 (limit: 38437)
   Memory: 175.9M
   CGroup: /system.slice/system-dynflow\x2dsidekiq.slice/dynflow-sidekiq@worker-1.service
           └─1422 ruby2.5 /usr/share/foreman/vendor/ruby/2.5.0/bin/sidekiq -e production -r /usr/share/foreman/extras/dynflow-sidekiq.rb -C /etc/foreman/dynflow/worker-1.yml

May 14 11:24:19 modest-gator systemd[1]: Started Foreman jobs daemon - worker-1 on sidekiq.
May 14 11:24:21 modest-gator dynflow-sidekiq@worker-1[1422]: 2020-05-14T11:24:21.442Z 1422 TID-gpznscy7m INFO: GitLab reliable fetch activated!
May 14 11:24:21 modest-gator dynflow-sidekiq@worker-1[1422]: 2020-05-14T11:24:21.443Z 1422 TID-gpzo69up6 INFO: Booting Sidekiq 5.2.8 with redis options {:id=>"Sidekiq-server-PID-1422", :url=>"redis://localhost:6379/0"}

● dynflow-sidekiq@worker-2.service - Foreman jobs daemon - worker-2 on sidekiq
   Loaded: loaded (/lib/systemd/system/dynflow-sidekiq@.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2020-05-14 11:24:19 UTC; 6s ago
     Docs: https://theforeman.org
 Main PID: 1423 (ruby2.5)
    Tasks: 5 (limit: 38437)
   Memory: 178.4M
   CGroup: /system.slice/system-dynflow\x2dsidekiq.slice/dynflow-sidekiq@worker-2.service
           └─1423 ruby2.5 /usr/share/foreman/vendor/ruby/2.5.0/bin/sidekiq -e production -r /usr/share/foreman/extras/dynflow-sidekiq.rb -C /etc/foreman/dynflow/worker-2.yml

May 14 11:24:19 modest-gator systemd[1]: Started Foreman jobs daemon - worker-2 on sidekiq.
May 14 11:24:21 modest-gator dynflow-sidekiq@worker-2[1423]: 2020-05-14T11:24:21.448Z 1423 TID-gpcxyxoi7 INFO: GitLab reliable fetch activated!
May 14 11:24:21 modest-gator dynflow-sidekiq@worker-2[1423]: 2020-05-14T11:24:21.449Z 1423 TID-gpcyculz7 INFO: Booting Sidekiq 5.2.8 with redis options {:id=>"Sidekiq-server-PID-1423", :url=>"redis://localhost:6379/0"}
```

### Scaling down

Scaling down is just reverse process, let’s say having `worker`, `worker-1` and `worker-2` was an overkill and we think we would be fine with just `worker` and `worker-1`.

```
# systemctl disable --now dynflow-sidekiq@worker-2
Removed /etc/systemd/system/multi-user.target.wants/dynflow-sidekiq@worker-2.service.

# rm /etc/foreman/dynflow/worker-2.yml
```

### Dedicating a worker to a queue

For this we need to create a new configuration for a worker (or just copy an existing one and change the relevant lines)

Create the configuration file, here we create a worker called `rex` having 5 threads and consuming items from the `remote_execution` queue

```
# cat <<EOF >/etc/foreman/dynflow/rex.yml
:concurrency: 5
:queues:
  - remote_execution
EOF
```

Now let’s start the service and check its status

```
# systemctl start dynflow-sidekiq@rex

# systemctl status dynflow-sidekiq@rex
● dynflow-sidekiq@rex.service - Foreman jobs daemon - rex on sidekiq
   Loaded: loaded (/lib/systemd/system/dynflow-sidekiq@.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2020-05-14 11:32:01 UTC; 3s ago
     Docs: https://theforeman.org
 Main PID: 1785 (ruby2.5)
    Tasks: 5 (limit: 38437)
   Memory: 115.8M
   CGroup: /system.slice/system-dynflow\x2dsidekiq.slice/dynflow-sidekiq@rex.service
           └─1785 ruby2.5 /usr/share/foreman/vendor/ruby/2.5.0/bin/sidekiq -e production -r /usr/share/foreman/extras/dynflow-sidekiq.rb -C /etc/foreman/dynflow/rex.yml

May 14 11:32:01 modest-gator systemd[1]: Started Foreman jobs daemon - rex on sidekiq.
May 14 11:32:02 modest-gator dynflow-sidekiq@rex[1785]: 2020-05-14T11:32:02.789Z 1785 TID-gpaz8n321 INFO: GitLab reliable fetch activated!
May 14 11:32:02 modest-gator dynflow-sidekiq@rex[1785]: 2020-05-14T11:32:02.790Z 1785 TID-gpazi1pg1 INFO: Booting Sidekiq 5.2.8 with redis options {:id=>"Sidekiq-server-PID-1785", :url=>"redis://localhost:6379/0"}
```

### Tuning number of threads per worker

The only thing that needs to be done is changing the number at the `:concurrency:` line and restarting the service. Either open it up in your favourite `$EDITOR` or do it with `sed`.

Here we can see the worker from previous example has 5 threads. `1785` is the process id taken from previous invocation of systemctl status

```
# ps -fp 1785
foreman     1785       1  0 11:32 ?        00:00:14 sidekiq 5.2.8  [0 of 5 busy]
```

Next we change it to 15

```
# sed -i 's/:concurrency: .*/:concurrency: 15/' /etc/foreman/dynflow/rex.yml
```

Restart the service and check its status

```
# systemctl restart dynflow-sidekiq@rex

# systemctl status dynflow-sidekiq@rex
● dynflow-sidekiq@rex.service - Foreman jobs daemon - rex on sidekiq
   Loaded: loaded (/lib/systemd/system/dynflow-sidekiq@.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2020-05-14 11:34:20 UTC; 2s ago
     Docs: https://theforeman.org
 Main PID: 1903 (ruby2.5)
    Tasks: 4 (limit: 38437)
   Memory: 94.4M
   CGroup: /system.slice/system-dynflow\x2dsidekiq.slice/dynflow-sidekiq@rex.service
           └─1903 ruby2.5 /usr/share/foreman/vendor/ruby/2.5.0/bin/sidekiq -e production -r /usr/share/foreman/extras/dynflow-sidekiq.rb -C /etc/foreman/dynflow/rex.yml

May 14 11:34:20 modest-gator systemd[1]: Started Foreman jobs daemon - rex on sidekiq.
May 14 11:34:21 modest-gator dynflow-sidekiq@rex[1903]: 2020-05-14T11:34:21.852Z 1903 TID-gn2jupy2z INFO: GitLab reliable fetch activated!
May 14 11:34:21 modest-gator dynflow-sidekiq@rex[1903]: 2020-05-14T11:34:21.852Z 1903 TID-gn2k8l9cr INFO: Booting Sidekiq 5.2.8 with redis options {:id=>"Sidekiq-server-PID-1903", :url=>"redis://localhost:6379/0"}
```

And finally we can check it has more threads.

```
# ps -fp 1903
UID          PID    PPID  C STIME TTY          TIME CMD
foreman     1903       1  0 11:34 ?        00:00:14 sidekiq 5.2.8  [0 of 15 busy]
```

## 5.2 Compute Resources

Foreman supports creating and managing hosts on a number of  virtualization and cloud services - referred to as “compute resources” - as well as bare metal hosts.

The capabilities vary between implementations, depending on how the  compute resource provider deploys new hosts and what features are  available to manage currently running hosts.  Some providers are able to support unattended installation using PXE, while others are  image-based.  Some providers have graphical consoles that Foreman  interfaces to, and most have power management features.  A summary of  all providers and their support features is given below, and more  detailed sections follow with specific notes.

| Provider                                                     | Package           | Unattended installation | Image-based | Console      | Power management | Networking |
| ------------------------------------------------------------ | ----------------- | ----------------------- | ----------- | ------------ | ---------------- | ---------- |
| [EC2](https://theforeman.org/manuals/3.5/index.html#5.2.3EC2Notes) | foreman-ec2       | no                      | yes         | read-only    | yes              | IPv4       |
| [Google Compute Engine](https://theforeman.org/manuals/3.5/index.html#5.2.4GoogleComputeEngineNotes) | foreman-gce       | no                      | yes         | read-only    | yes              | IPv4       |
| [Libvirt](https://theforeman.org/manuals/3.5/index.html#5.2.5LibvirtNotes) | foreman-libvirt   | yes                     | yes         | VNC or SPICE | yes              | MAC        |
| [OpenStack Nova](https://theforeman.org/manuals/3.5/index.html#5.2.6OpenStackNotes) | foreman-openstack | no                      | yes         | no           | yes              | IPv4       |
| [oVirt / RHEV](https://theforeman.org/manuals/3.5/index.html#5.2.7oVirt/RHEVNotes) | foreman-ovirt     | yes                     | yes         | VNC or SPICE | yes              | MAC        |
| [VMware](https://theforeman.org/manuals/3.5/index.html#5.2.8VMwareNotes) | foreman-vmware    | yes                     | yes         | VNC          | yes              | MAC        |

Support for these features is aimed at being as transparent as  possible, allowing the same configuration to be applied to hosts  irrespective of the provider in use (compute resource or not).  The  selection of compute resource is made when creating a new host and the  host in Foreman’s database remains associated to the VM that’s created,  allowing it to be managed throughout the lifetime of the host.

Networking varies between providers - where “MAC” is specified, the  compute resource provides the MAC address for newly created virtual  machines (layer 2 networking), and IP addresses are assigned in/by  Foreman. Where “IPv4” and/or “IPv6” is specified, the compute resource  assigns an IP address for virtual machine interfaces (layer 3  networking) and the addresses will be stored by Foreman when creating a  host.

### 5.2.1 Using Compute Resources

The following steps describe how to configure a compute resource and provision new hosts on it.

1. Ensure the necessary package for the provider (from the above table) is installed, e.g. `yum -y install foreman-ovirt`.  Restart the Foreman application to complete installation.
2. Add a compute resource under *Infrastructure > Compute Resources > New Compute Resource*.  Select the provider type from the menu and appropriate configuration  options will be displayed.  Check the notes sections below for any  provider-specific setup instructions.
3. Click the *Test Connection* button after entering the configuration.  If no error is displayed, the test was successful.
4. After saving the compute resource, existing virtual machines can be browsed by clicking on the compute resource and the *Virtual Machines* tab.
5. For providers that use images, click on the compute resource, then the *Images* tab, where known images are listed.  To register images that Foreman can use, click *New Image* and enter the details.
6. To provision a new host on this compute resource, from *Hosts*, click *New Host* and select the compute resource from the *Deploy to* menu.

Also note the following features:

1. When viewing a host, power management controls and the console access button are in the top right hand corner of the page.
2. If a host provisioned on a compute resource is deleted, the VM  and associated storage on the compute resource will also be deleted.
3. Users in Foreman can have access restricted to hosts present on  certain compute resources.  For more information, see Filtering in [4.1.2 Roles and Permissions](https://theforeman.org/manuals/3.5/index.html#4.1.2RolesandPermissions).

### 5.2.2 Using Compute Profiles

A compute profile is a way of expressing a set of defaults for VMs created on a specific compute resource that can be mapped to an operator-defined label. This means an administrator can express, for example, what “Small”, Medium” or “Large” means on all of the individual compute resources present for a given installation.

In combination with host groups, this allows a user to completely define a new host from just the *Host* tab of the *New Host* form.

You can find the configuration for compute profiles at *Infrastructure > Compute Profiles*

#### Default Profiles

By default, Foreman comes with 3 predefined profiles; “1-Small”, “2-Medium”, and “3-Large” (the numbers are just to make them sort nicely). They come with no associated configuration for any particular compute resource, and as such, they can be deleted or renamed as required.

![Profile List](https://theforeman.org/static/images/screenshots/compute_profiles/profile-list.png)

#### Assigning information to a Profile

This walkthrough will define what “1-Small” means for a particular installation. It will also assume there are two compute resources; one Libvirt and one EC2 (these make a good example as they are very different).

Start by editing the compute profile, by clicking its name in the profile list. This leads to a list of all your current compute resources. Later, once the configuration is done, this list will also display the current defaults configured for each compute resource.

![Profile Edit](https://theforeman.org/static/images/screenshots/compute_profiles/profile-edit.png)

##### EC2

Clicking on the EC2 resource will bring up a page very similar to the one used when provisioning a single host. Here an administrator can set what “1-Small” means on this specific EC2 resource. For this example, “m1.small” is selected as the size. Defaults can also be specified for the image choice, the security groups, and so on.

![EC2](https://theforeman.org/static/images/screenshots/compute_profiles/ec2.png)

The changes are submitted, and on returning to the profile list, the new EC2 defaults will be shown.

##### Libvirt

In a very similar manner, the Libvirt resource can be clicked upon, and some defaults assigned. For this example, since this is the “1-Small” profile, 1 CPU, 512MB of RAM, a single bridged network device, and a 5GB disk are selected.

![Libvirt](https://theforeman.org/static/images/screenshots/compute_profiles/libvirt.png)

Again, the changes are submitted.

#### Applying a Compute Profile

Now visit *Hosts > New Host*. At first, things look exactly as before, but once a compute resource is selected which has at least one compute profile, a new combo-box will appear. This permits the user to select a profile to apply to this host. For this example, the Libvirt resource is selected, followed by the “1-Small” profile.

![Primary Tab](https://theforeman.org/static/images/screenshots/compute_profiles/host-primary.png)

Once the profile is selected, the *Virtual Machine* tab will automatically update to use the defaults configured in the “1-Small” profile.

![VM Tab](https://theforeman.org/static/images/screenshots/compute_profiles/host-vm.png)

Assuming the defaults are suitable, the host has now been defined solely by selecting a host group and a profile. It’s also possible to associate a profile with a host group in the host group edit page, which will automatically select that profile when the host group is selected.

### 5.2.3 EC2 Notes

- Add a provisioning template of either type 

  finish

   or 

  user_data

   which will be executed on the new image.    

  - ‘finish’ templates complete the provisioning process via SSH - this requires Foreman to be able to reach the IP of the new host, and  that SSH is allowing connections from Foreman. This uses the SSH key  which Foreman uploaded to your compute resource when it was added to  Foreman.
  - ‘user_data’ templates instead provision by cloud-init (or  similar meta-data retrieving scripts). This will not require Foreman to  be able to reach the host, but the host must be able to reach Foreman  (since user_data execution is asynchronous, the host must notify Foreman that the build is complete).

- Ensure AMIs are added under the 

  Images

   tab on the compute resource    

  - Ensure the correct username is set for Foreman to SSH into the image (if using SSH provisioning).
  - Tick the user_data box if the image is capable of using user_data scripts (usually because it has cloud-init installed).

- Enabling *use_uuid_for_certificates* in *Administer > Settings* is recommended for consistent Puppet certificate IDs instead of hostnames.

- VPC subnets and security groups can be selected on the *Network* tab when creating a host.

- The *Managed IP* dropdown menu allows selection between using the public and private IP address for communication from Foreman to the instance.

- Ensure that the selected template is associated to the OS (on the *Associations* tab) and is set as the default for the operating system too.

A finish-based example for configuring EC2 provisioning is given on the Foreman blog: [EC2 provisioning using Foreman](https://theforeman.org/2012/05/ec2-provisioning-using-foreman.html).

### 5.2.4 Google Compute Engine Notes

- Requires client e-mail address of an authorised Google Cloud  Console client ID is entered in the new compute resource screen and its  associated .json private key file is manually transferred to the foreman server.

- The certificate must be stored in a location the foreman user account has permission to read.

- If your server enforces SELinux ensure the context is suitable or relabel it using `restorecon -vv /usr/share/foreman/gce.json`

- Specify the location *on the foreman server* as the certificate path value e.g /usr/share/foreman/gce.json

- Ensure images are associated under the 

  Images

   tab on the compute resource    

  - Ensure the correct username except *root* is set for  Foreman to SSH into the image (if using SSH provisioning). Note that -  For security reasons, Google do not provide the ability to ssh in  directly as root.
  - Tick the user_data box if the image is capable of using user_data scripts (usually because it has cloud-init installed).

- Add a provisioning template either of type 

  finish

   or 

  user_data

   which will be executed on the new image.    

  - ‘finish’ templates complete the provisioning process via SSH - this requires Foreman to be able to reach the IP of the new host, and  that SSH is allowing connections from Foreman. This uses the SSH key  which Foreman uploaded to your compute resource when it was added to  Foreman.
  - ‘user_data’ templates instead provision by cloud-init (or  similar meta-data retrieving scripts). This will not require Foreman to  be able to reach the host, but the host must be able to reach Foreman  (since user_data execution is asynchronous, the host must notify Foreman that the build is complete).

- Enabling *use_uuid_for_certificates* in *Administer > Settings* is recommended for consistent Puppet certificate IDs instead of hostnames.

- The *Associate Ephemeral External IP* checkbox means the public IP address (rather than private IP) will be used for communication with the instance from Foreman.

- Ensure that the selected template is associated to the OS (on the *Associations* tab) and is set as the default for the operating system too.

#### Setting up the cloud project

All Google Compute Engine access is contained within a “project” set up via the Google Developers Console.  Access [the Google Developers Console](https://console.developers.google.com/iam-admin/projects), and click *Create Project*.

![Create Project](https://theforeman.org/static/images/screenshots/gce/new_create_project.png)

By default, your project will have the Compute Engine and App Engine services enabled. Now go to [the Compute Engine API Overiew](https://console.developers.google.com/apis/api/compute_component), and select the Google Compute Engine API.

![Compute Engine API Overiew](https://theforeman.org/static/images/screenshots/gce/enabled_compute_engine_api.png)

Under *APIs & Services > Library*, apply filter *compute* and select *API* then click the *Enable* button.

![API Library](https://theforeman.org/static/images/screenshots/gce/api_library.png)

![Enable API](https://theforeman.org/static/images/screenshots/gce/new_enable_api.png)

Next under *Credentials*, click *Create Credentials > Create service account key* and choose your service account for Compute Engine.

![Credential list](https://theforeman.org/static/images/screenshots/gce/credential_list.png)

![Service account](https://theforeman.org/static/images/screenshots/gce/create_credentials_using_json_format.png)

Click *Generate new JSON key* and save the new .json file.   This should be uploaded to the Foreman server to a location that the  ‘foreman’ user can read, such as `/usr/share/foreman/gce.json`. You don’t need to provide any password to Foreman to use this JSON key.

Change the .json file owner to 'foreman'  and chmod 0600 for security.  If your server uses SELinux ensure the  context is suitable or relabel it using restorecon -vv  /usr/share/foreman/gce.json

#### Adding the compute resource

In Foreman, under *Infrastructure > Compute resources > New compute resource*, select *Google* from the provider dropdown menu and fill in the GCE-specific fields as follows:

- *Google Project ID:* shown on the project overview page in the GCE console, e.g. “nomadic-rite-396”
- *Client Email:* shown on the [*Credentials* page](https://console.developers.google.com/iam-admin/serviceaccounts/) after creating the service account as *Service account ID*, e.g. “543…@developer.gserviceaccount.com”
- *Certificate path:* full path of the .json file stored on the Foreman server, e.g. /usr/share/foreman/gce.json

### 5.2.5 Libvirt Notes

- Currently only supports KVM hypervisors.
- VM consoles will be configured by default to listen on 0.0.0.0, change this via *libvirt_default_console_address* in *Administer > Settings > Provisioning*.
- libvirt’s DNS and DHCP server (dnsmasq) can be disabled and  replaced by BIND and ISC DHCPD (managed by Foreman) by creating a new  virtual network and disabling DHCP support.

#### Connections

To connect to the hypervisor using SSH:

1. Configure SSH keys (ssh-keygen) for the ‘foreman’ user on the  Foreman host to connect fully automatically to the remote hypervisor  host.
2. Change to the ‘foreman’ user, test the connection and ensure the remote host has been trusted.
3. If connecting to the hypervisor as a non-root user, set up  PolicyKit to permit access to libvirt.  Note that different versions of  PolicyKit have different configuration formats.  [1](http://libvirt.org/auth.html#ACL_server_polkit), [2](http://wiki.libvirt.org/page/SSHPolicyKitSetup).
4. Add the compute resource with a URL following one of these examples:    
   - `qemu+ssh://root@hypervisor.example.com/system` to use the remote ‘root’ account
   - `qemu+ssh://hypervisor.example.com/system` to use the remote ‘foreman’ account

The first two steps above can be done with something like:

```
root# mkdir /usr/share/foreman/.ssh
root# chmod 700 /usr/share/foreman/.ssh
root# chown foreman:foreman /usr/share/foreman/.ssh
```

When using distribution packages, the directory should already be created for you so you could skip the above. Although following is necessary:

```
root# su foreman -s /bin/bash
foreman$ ssh-keygen
foreman$ ssh-copy-id root@hostname.com
foreman$ ssh root@hostname.com
exit
```

When using SELinux make sure the directory and the files have correct labels of `ssh_home_t`:

```
ls /usr/share/foreman/.ssh -Zd
drwx------. foreman foreman system_u:object_r:ssh_home_t:s0  /usr/share/foreman/.ssh
ls /usr/share/foreman/.ssh -Z
-rw-------. foreman foreman unconfined_u:object_r:ssh_home_t:s0 id_rsa
-rw-r--r--. foreman foreman unconfined_u:object_r:ssh_home_t:s0 id_rsa.pub
-rw-r--r--. foreman foreman unconfined_u:object_r:ssh_home_t:s0 known_hosts
```

If not, restore the context:

```
restorecon -RvF /usr/share/foreman/.ssh
```

To connect to the hypervisor over TCP without authentication or encryption (not recommended):

1. Set the following options in libvirtd.conf:    
   - `listen_tls = 0`
   - `listen_tcp = 1`
   - `auth_tcp = "none"`
2. Enable libvirtd listening, e.g. set `LIBVIRTD_ARGS="--listen"` in /etc/sysconfig/libvirtd
3. Add the compute resource with a URL following this example:    
   - `qemu+tcp://hypervisor.example.com:16509/system`

If you have difficulty connecting, test access using the virsh  command under the ‘foreman’ account on the Foreman host first, e.g. `virsh -c qemu+ssh://hypervisor.example.com/system list`.

#### Image provisioning

Image based provisioning can be used by provisioning a VM with a  backing image and then running a finish script over SSH, in the same  manner as the EC2 provider.  The type of provisioning method can be  selected under the “Operating system” tab when creating a new host.  To  configure image/template-based provisioning:

- Images refer to backing disks (usually qcow2) - create a disk containing the OS image in the libvirt storage pool.
- Add the image by navigating to the compute resource and clicking *New Image*, enter the full path to the backing image in the *Image path* field.
- Ensure the image is not modified as long as hosts exists that are using it, or they will suffer data corruption.

Two methods to complete provisioning are supported.  Either by SSHing into the newly created VM and running a script:

- The template needs to have a username and password set up for Foreman to SSH in after provisioning and run the finish script.
- This requires some form of DHCP orchestration for SSH access to the newly created host to work.
- A finish template to perform any post-build actions (e.g. setting  up Puppet) must also be associated to the host, usually by changing the  OS default finish template.

Or select the userdata checkbox when adding the image to Foreman, and a cloud-init compatible disk will be attached to the VM containing the  userdata:

- The template will need cloud-init installed and set to run on boot.
- A userdata template to perform any post-build actions (e.g.  setting up Puppet) must also be associated to the host, usually by  associating the `UserData default` template.
- The template will need to “phone home” to mark the host as built.

### 5.2.6 OpenStack Notes

- Supports OpenStack Nova for creating new compute instances.

- Add a provisioning template of either type 

  finish

   or 

  user_data

   which will be executed on the new image.    

  - ‘finish’ templates complete the provisioning process via SSH - this requires Foreman to be able to reach the IP of the new host, and  that SSH is allowing connections from Foreman. This uses the SSH key  which Foreman uploaded to your compute resource when it was added to  Foreman.
  - ‘user_data’ templates instead provision by cloud-init (or  similar meta-data retrieving scripts). This will not require Foreman to  be able to reach the host, but the host must be able to reach Foreman  (since user_data execution is asynchronous, the host must notify Foreman that the build is complete).

- Ensure Glance Images are added under the 

  Images

   tab on the compute resource.    

  - Ensure the correct username is set for Foreman to SSH into the image (if using SSH provisioning).
  - Tick the user_data box if the image is capable of using user_data scripts (usually because it has cloud-init installed).

- Security groups can be selected on the *Virtual Machine* tab when creating a host.

- The *Floating IP Network* dropdown menu allows selection of the network Foreman should request a public IP on. This is required  when using SSH provisioning.

- Ensure that the selected template is associated to the OS (on the *Associations* tab) and is set as the default for the operating system too.

A finish-based example for configuring image-based provisioning is given on the Foreman blog, also applicable to OpenStack: [EC2 provisioning using Foreman](https://theforeman.org/2012/05/ec2-provisioning-using-foreman.html).

### 5.2.7 oVirt / RHEV Notes

- SPICE consoles are displayed using an HTML5 client, so no native XPI extension is necessary.

#### Image provisioning

Image based provisioning can be used by provisioning a VM with a  template and then running a finish script over SSH, in the same manner  as the EC2 provider.  The type of provisioning method can be selected  under the “Operating system” tab when creating a new host.  To configure image/template-based provisioning:

- Images refer to templates and can be added by navigating to the compute resource and clicking *New Image*.
- The template needs to have a username and password set up for Foreman to SSH in after provisioning and run the finish script.
- This requires some form of DHCP orchestration for SSH access to the newly created host to work.
- A finish template to perform any post-build actions (e.g. setting  up Puppet) must also be associated to the host, usually by changing the  OS default finish template.

#### Permissions required

When defining a compute resource you have to provide a user account  used for communication with oVirt. It must have Admin account type  role(s) with following permissions:

- System    
  - Configure System        
    - Login Pemissions
- Network    
  - Configure vNIC Profile        
    - Create
    - Edit Properties
    - Delete
    - Assign vNIC Profile to VM
    - Assign vNIC Profile to Template
- Template    
  - Provisioning Operations        
    - Import/Export
- VM    
  - Provisioning Operations        
    - Create
    - Delete
    - Import/Export
    - Edit Storage
- Disk    
  - Provisioning Operations        
    - Create
  - Disk Profile        
    - Attach Disk Profile

### 5.2.8 VMware Notes

- Only VMware clusters using vSphere are supported, not standalone ESX or ESXi servers ([#1945](http://projects.theforeman.org/issues/1945)).

#### Image provisioning

Image based provisioning can be used by provisioning a new VM from a  template and then running a finish script over SSH, in the same manner  as the EC2 provider.  The type of provisioning method can be selected  under the “Operating system” tab when creating a new host.  To configure image/template-based provisioning:

- Images refer to templates stored in vSphere which will be used as the basis for a new VM.
- Add the image by navigating to the compute resource and clicking *New Image*, enter the relative path and name of the template on the vSphere server, e.g. `My templates/RHEL 6` or `RHEL 6` if it isn’t in a folder.  Do not include the datacenter name.
- The template needs to have a username and password set up for Foreman to SSH in after provisioning and run the finish script.
- This requires some form of DHCP orchestration for SSH access to the newly created host to work.
- A finish template to perform any post-build actions (e.g. setting  up Puppet) must also be associated to the host, usually by changing the  OS default finish template.

#### Image provisioning without SSH

The same process can also be done using a user_data template. To  configure image/template-based provisioning without SSH, make the  following adjustments for the former procedure:

- Browse then to the image to be used for provisioning, and ensure that “User Data” is checked
- Associate a user_data template to the host. The template will use cloud-init syntax.
- Note that the images don’t need cloudinit installed, as the  cloudinit is converted under the hood to a CustomisationSpec object that VMware can process

#### Console access

Consoles are provided using VNC connections from Foreman to the ESX  server, which requires a firewall change to open the respective ports  (TCP 5901 to 5964)

```
ssh root@esx-srv
vi /etc/vmware/firewall/vnc.xml
```

Add the following file content:

```
<ConfigRoot>
<service id='0032'>
 <id>VNC</id>
 <rule id = '0000'>
  <direction>inbound</direction>
  <protocol>tcp</protocol>
  <porttype>dst</porttype>
  <port>
   <begin>5901</begin>
   <end>5964</end>
  </port>
 </rule>
 <enabled>true</enabled>
</service>
</ConfigRoot>
```

Apply and check the firewall rule:

```
esxcli network firewall refresh
esxcli network firewall ruleset list | grep VNC
```

Lastly, make the rule persistent.

With ESX:

```
cp /etc/vmware/firewall/vnc.xml /vmfs/volumes/datastore1/vnc.xml
vi /etc/rc.local
# At end of file :
cp /vmfs/volumes/datastore1/vnc.xml /etc/vmware/firewall/
esxcli network firewall refresh
```

With ESXi:

```
cp /etc/vmware/firewall/vnc.xml /vmfs/volumes/datastore1/vnc.xml
vi /etc/rc.local.d/local.sh
# At end of file, just before exit 0 :
cp /vmfs/volumes/datastore1/vnc.xml /etc/vmware/firewall/
esxcli network firewall refresh
```

If permanent shared storage is available (direct-attach SAN, etc):  rather than doing a file copy on each server, use a symlink instead.   Once it’s changed on the shared storage, run a loop to refresh the  firewall services. The local.sh file still needs to be created.

Example:

```
ln -s /vmfs/volumes/{uuid of shared storage}/firewall.rules/vnc.xml /etc/vmware/firewall/vnc.xml
```

#### Required Permissions

The minimum permissions to properly provision new virtual machines are:

- All Privileges -> Datastore -> Allocate Space
- All Privileges -> Network -> Assign Network
- All Privileges -> Resource -> Assign virtual machine to resource pool
- All Privileges -> Virtual Machine -> Configuration (All)
- All Privileges -> Virtual Machine -> Interaction
- All Privileges -> Virtual Machine -> Inventory
- All Privileges -> Virtual Machine -> Provisioning

#### Notes

- Log in to the VMware vSphere Server that represents the Compute  Resource. Create a role with the above permissions. Add the appropriate  account to the role. To create user accounts, roles or for complete  details on administration of VMware vSphere, please consult your VMware  vSphere Server documentation.
- The account that foreman uses to communicate with VCenter is  assumed to have the ability to traverse the entire inventory in order to locate a given datacenter.  A patch is required to instruct foreman to  navigate directly to the appropriate datacenter to avoid permission  issues ([#5006](http://projects.theforeman.org/issues/5006)).
- Reference in the [VMWare KB 2043564](http://kb.vmware.com/selfservice/microsites/search.do?cmd=displayKC&docType=kc&externalId=2043564&sliceId=1&docTypeID=DT_KB_1_1&dialogID=458724081&stateId=1 0 458722496).
- For debugging purpose, read the [troubleshooting guide about NoVNC](https://theforeman.org/manuals/3.5/index.html#7.1NoVNC).

### 5.2.9 Password Encryption

Compute resource passwords and secrets are stored on the Foreman  database using a secret - the encryption key - and ciphered using  AES-256-CBC. The encryption key can usually be found in `/etc/foreman/encryption_key.rb`, which is symlinked to `/usr/share/foreman/config/initializers/encryption_key.rb`. The value of the ENCRYPTION_KEY variable must be at least 32 bytes long.

If you want to regenerate the key, you can run `foreman-rake security:generate_encryption_key`. Please remember that previously encrypted passwords cannot be decrypted with a different encryption key, so decrypt all passwords before  changing your encryption key.

After you make sure you have a valid encryption key, you can encrypt your Compute Resource secrets in the database by running `foreman-rake db:compute_resources:encrypt`. To unencrypt them, run the task `foreman-rake db:compute_resources:decrypt`.

Keep in mind passwords are encrypted in the Foreman database, but  Foreman will decrypt them and use unencrypted credentials to  authenticate to Compute Resources.

## 5.3 Install Locations

Missing content. Consider contributing, you kind soul! -

## 5.4 Securing Communications with SSL

The Foreman web application needs to communicate securely with  associated smart proxies and Puppet servers, plus users and applications connecting to the web interface.  This section details recommended SSL  configurations.

### 5.4.1 Securing Puppet Server Requests

In a typical ENC-based setup with reporting, Puppet servers require access to Foreman for three tasks:

1. Retrieval of external nodes information (classes, parameters)
2. Uploading of host facts
3. Uploading of host reports

All traffic here is initiated by the Puppet server itself.  Other  traffic from Foreman to the Puppet server for certificate signing etc.  is handled via smart proxies (SSL configuration covered in the next  section).

#### Configuration options

The Foreman interface authorizes access to Puppet server interfaces based on its list of registered smart proxies with the *Puppet* feature, and identifies hosts using client SSL certificates.

Five main settings control the authentication, the first are in Foreman under *Settings*, *Authentication*:

- *require_ssl_smart_proxies* (default: true), requires a  client SSL certificate on the Puppet server requests, and will verify  the CN of the certificate against the smart proxies.  If false, it uses  the reverse DNS of the IP address making the request.
- *restrict_registered_smart_proxies* (default: true), only permits access to hosts that have a registered smart proxy with the *Puppet* feature.
- *trusted_hosts*, a whitelist of hosts that overrides the check for a registered smart proxy

And two in `config/settings.yaml`:

- *login* (default: true), must be enabled to prevent anonymous access to Foreman.
- *require_ssl* (default: false), should be enabled to  require SSL for all communications, which in turn will require client  SSL certificates if *require_ssl_smart_proxies* is also enabled.  If false, host-based access controls will be available for HTTP requests.

#### Enabling full SSL communications

Using Apache HTTP with mod_ssl is recommended.  For simple setups,  the Puppet certificate authority (CA) can be used, with Foreman and  other hosts using certificates generated by `puppet cert`.

1. Set Foreman’s *require_ssl_smart_proxies*, *restrict_registered_smart_proxies* and *require_ssl* to *true*.
2. The mod_ssl configuration must contain:

3. *SSLCACertificateFile* set to the Puppet CA
4. *SSLVerifyClient optional*
5. *SSLOptions +StdEnvVars +ExportCertData*

6. Puppet ENC/report processor configuration (e.g. `/etc/puppetlabs/puppet/foreman.yaml` or `/etc/puppet/foreman.yaml`) should have these settings:

7. *:ssl_ca* set to the Puppet CA
8. *:ssl_cert* set to the Puppet server's certificate
9. *:ssl_key* set to the Puppet server's private key

##### Troubleshooting

Warning messages will be printed to Foreman’s log file (typically `/var/log/foreman/production.log`) when SSL-based authentication fails.

- *No SSL cert with CN supplied* indicates no client SSL  certificate was supplied, or the CN wasn’t present on a certificate.   Check the client script has the certificate and key configured and that  mod_ssl has *SSLVerifyClient* set.
- *SSL cert has not been verified* indicates the client SSL  certificate didn’t validate with the SSL terminator’s certificate  authority.  Check the client SSL certificate is signed by the CA set in  mod_ssl’s *SSLCACertificateFile* and is still valid.  More information might be in error logs.
- *SSL is required* indicates the client is using an HTTP URL instead of HTTPS.
- *No smart proxy server found on $HOST* indicates Foreman  has no smart proxy registered for the source host, add it to the Smart  Proxies page in Foreman.  A common cause of this issue is the hostname  in the URL doesn’t match the hostname seen here in the log file - change the registered proxy URL to match.  If no smart proxy is available or  can be installed, use *trusted_hosts* and add this hostname to the whitelist.

##### Advanced SSL notes

A typical small setup will use a single Puppet CA and certificates it provides for the Foreman host and Puppet server hosts.  In larger  setups with multiple CAs or an internal CA, this will require more  careful configuration to ensure all hosts can trust each other.

- Ensure the Common Name (CN) is present in certificates used by  Foreman (as clients will validate it) and Puppet server clients (used to verify against smart proxies).
- Foreman’s SSL terminator must be able to validate Puppet server client SSL certificates.  In Apache with mod_ssl, the *SSLCACertificateFile* option must point to the CA used to validate clients and *SSLVerifyClient* set to *optional*.
- Environment variables from the SSL terminator are used to get the client certificate and verification status.  mod_ssl’s *SSLOptions +StdEnvVars +ExportCertData* setting enables this.  Variable names are defined by *ssl_client_cert_env*, *ssl_client_dn_env* and *ssl_client_verify_env* settings in Foreman.

#### Reduced security: HTTP host-based authentication

In non-SSL setups, host-based authentication can be performed, so any connection from a host running a puppet smart proxy is able to access  the interfaces.

1. Set *restrict_registered_smart_proxies* to *true*.
2. Set *require_ssl_smart_proxies* and *require_ssl* to *false*.

#### No security: disable authentication

Entirely disabling authentication isn’t recommended, since it can  lead to security exploits through YAML import interfaces and expose  sensitive host information, however it may be useful for  troubleshooting.

1. Set *require_ssl_smart_proxies*, *restrict_registered_smart_proxies* and *require_ssl* to *false*.

### 5.4.2 Securing Smart Proxy Requests

Foreman makes HTTP requests to smart proxies for a variety of  orchestration tasks.  In a production setup, these should use SSL  certificates so the smart proxy can verify the identity of the Foreman  host.

In a simple setup, a single Puppet Certificate Authority (CA) can be  used for authentication between Foreman and proxies.  In more advanced  setups with multiple CAs or an internal CA, the services can be  configured as follows.

#### Proxy configuration options

`/etc/foreman-proxy/settings.yml` contains the locations to the SSL certificates and keys:

```
---
# SSL Setup

# if enabled, all communication would be verified via SSL
# NOTE that both certificates need to be signed by the same CA in order for this to work
# see http://theforeman.org/projects/smart-proxy/wiki/SSL for more information
:ssl_certificate: /etc/puppetlabs/puppet/ssl/certs/FQDN.pem
:ssl_ca_file: /etc/puppetlabs/puppet/ssl/certs/ca.pem
:ssl_private_key: /etc/puppetlabs/puppet/ssl/private_keys/FQDN.pem
```

In this example, the proxy is sharing Puppet’s certificates, but it could equally use its own.

In addition it contains a list of hosts that connections will be accepted from, which should be the host(s) running Foreman:

```
# the hosts which the proxy accepts connections from
# commenting the following lines would mean every verified SSL connection allowed
:trusted_hosts:
- foreman.corp.com
#- foreman.dev.domain
```

##### Configuring Foreman

For Foreman to connect to an SSL-enabled smart proxy, it needs configuring with SSL certificates in the same way.

The locations of the certificates are managed in the *Settings* page, under *Provisioning* - the *ssl_ca_file*, *ssl_certificate* and *ssl_priv_key* settings.  By default these will point to the Puppet locations - for  manually generated certificates, or non-standard locations, they may  have to be changed.

Lastly, when adding the smart proxy in Foreman, ensure the URL begins with `https://` rather than `http://`.

##### Sharing Puppet certificates

If using Puppet’s certificates, the following lines will be required in puppet.conf to relax permissions to the `puppet` group.  The `foreman` and/or `foreman-proxy` users should then be added to the `puppet` group.

```
[main]
privatekeydir = $ssldir/private_keys { group = service }
hostprivkey = $privatekeydir/$certname.pem { mode = 640 }
```

Note that the “service” keyword will be interpreted by Puppet as the “puppet” service group.

## 5.5 Backup, Recovery and Migration

This chapter will provide you with information how to backup and recover your instance. All commands presented here are just examples and should be considered as a template command for your own backup script which differs from one environment to other.

It is possible to perform a *migration* by doing backup one one host and recovery on a different host, but in this case pay attention to different configuration between the two hosts.

This can be applied to the Foreman application itself, but pay attention when migrating smart-proxy and services because things like different IP addresses or hostnames will need manual intervention.

### 5.5.1 Backup

This chapter will provide you with information how to backup a Foreman instance.

#### Database

Run `foreman-rake db:dump`. It will print a message when it finishes with the dump file location relative to the Foreman root.

#### Configuration

On Red Hat compatible systems issue the following command to backup whole /etc directory structure:

```
tar --selinux -czvf etc_foreman_dir.tar.gz /etc/foreman
```

For all other distribution do similar command:

```
tar -czvf etc_foreman_dir.tar.gz /etc/foreman
```

#### Puppet server

On the Puppet server node, issue the following command to backup Puppet certificates on Red Hat compatible systems

```
tar --selinux -czvf var_lib_puppet_dir.tar.gz /etc/puppetlabs/puppet/ssl
```

For all other distribution do similar command:

```
tar -czvf var_lib_puppet_dir.tar.gz /etc/puppetlabs/puppet/ssl
```

Under a Puppet non-AIO installation, back up `/var/lib/puppet/ssl` instead.

#### DHCP, DNS and TFTP services

Depending on used software packages, perform backup of important data and configuration files according to the documentation. For ISC DHCP and DNS software, these are located within /etc and /var directories depending on your distribution as well as TFTP service.

### 5.5.2 Recovery

Recovery process is supposed to be performed on the same host the backup was created on on the same distribution and version.

If you planning to *migrate* Foreman instance, please read remarks in the beginning of this chapter.

Note: Foreman instance must be stopped before proceeding.

#### PostgreSQL

Run `foreman-rake db:import_dump file=/your/db/dump/location`. This will load your dump into the current database for your environment. It will print a message to notify you when it has finished importing the dump.

Remember to stop the Foreman instance and any other process consuming data from the database temporarily during the import and turn it back on after it ends.

#### Configuration

On Red Hat compatible systems issue the following command to restore whole /etc directory structure:

```
tar --selinux -xzvf etc_foreman_dir.tar.gz -C /
```

For all other distribution do similar command:

```
tar -xzvf etc_foreman_dir.tar.gz -C /
```

It is recommended to extract files to an empty directory first and inspect the content before overwriting current files (change -C option to an empty directory).

#### Puppet server

On the Puppet server node, issue the following command to restore Puppet certificates on Red Hat compatible systems

```
tar --selinux -xzvf var_lib_puppet_dir.tar.gz -C /
```

For all other distribution do similar command:

```
tar -xzvf var_lib_puppet_dir.tar.gz -C /
```

It is recommended to inspect the content of the restore first (see above).

#### DHCP, DNS and TFTP services

Depending on used software packages, perform recovery of important data and configuration files according to the documentation. This depends on the software and distribution that is in use.

#### Changing the FQDN

It’s preferable when migrating to keep the FQDN unchanged to reduce the risk of configuration errors from references to the old hostname.

However if the FQDN does change, check and update the following items:

- Foreman settings

  under 

  Administer > Settings

  :    

  - *General > foreman_url* - URL of the Foreman web UI
  - *Provisioning > unattended_url* - URL of the Foreman web API for unattended provisioning
  - *Provisioning > ssl_certificate*, *ssl_priv_key* - paths to SSL certificate and key used for smart proxy communications

- The registered smart proxy URL if installed, edit via *Infrastructure > Smart Proxies*

- Puppet SSL certs: generate new ones with `puppet cert generate NEW_FQDN`

- Apache configs: update `conf.d/*-{foreman,puppet}.conf` with new SSL cert/key filenames, ServerName and VirtualHost IP addresses if applicable

- Smart proxy configuration files in 

  ```plaintext
  /etc/foreman-proxy
  ```

  :    

  - `settings.yml` - update SSL cert/key filenames
  - `settings.d/dns_nsupdate_gss.yml` - update `dns_tsig_principal` if the principal name has changed
  - `settings.d/puppet_proxy_legacy.yml` - update SSL cert/key filenames
  - `settings.d/puppet_proxy_puppet_api.yml` - update SSL cert/key filenames
  - `settings.d/realm.yml` - update `realm_principal` if the principal name has changed
  - `settings.d/templates.yml` - update `template_url` for URL of the Foreman web API

- Puppet servers: URLs and cert/key filenames in `/etc/puppetlabs/puppet/foreman.yaml` or `/etc/puppet/foreman.yaml`

## 5.6 Rails Console

Foreman is a Ruby on Rails application, which provides an interactive console for advanced debugging and troubleshooting tasks.  Using this  allows easy bypass of authorization and security mechanisms, and can  easily lead to loss of data or corruption unless care is taken.

To access the Rails console, choose the method below appropriate to the installation method.

##### RPM and Debian installations

As root, execute:

```
yum install foreman-console
foreman-rake console
```

or to run in sandboxed mode, which rolls back changes on exit, execute:

```
foreman-rake console -- --sandbox
```

##### Source installations

As the user running Foreman and in the source directory, execute:

```
RAILS_ENV=production bundle exec rails c
```

or to run in sandboxed mode, which rolls back changes on exit, execute:

```
RAILS_ENV=production bundle exec rails c --sandbox
```

##### Set up

To assume full admin permissions in order to modify objects, enter in the console:

```
User.current = User.only_admin.visible.first
```



## 5.7 External Authentication

The following tutorial explains how to set up Foreman authentication  against FreeIPA (or Identity Management) server. First part of the  tutorial describes how to configure Foreman machine via Foreman  installer options. The second one shows how to achieve the same result  without using these options.

### 5.7.1 Configuration via Foreman installer

We assume the Foreman machine is FreeIPA-enrolled:

```
ipa-client-install
```

On the FreeIPA server, we create the service. (Please make sure you have obtained Kerberos ticket before this step - for example, by using *kinit*.)

```
ipa service-add HTTP/<the-foreman-fqdn>
```

Then we install Foreman.

```
foreman-installer --foreman-ipa-authentication=true
```

This option can be used for the reconfiguration of existing installation as well.

In case you want to use IPA server’s host-based access control (HBAC) features (make sure *allow_all* rule is disabled), the default PAM service name (which would be matched by HBAC service name) is *foreman*. You can override the default name with:

```
foreman-installer --foreman-ipa-authentication=true --foreman-pam-service=<pam_service_name>
```

For more information about HBAC configuration see section below.

### 5.7.2 HBAC configuration

We suppose that the Foreman machine is FreeIPA-enrolled and `HTTP/<the-foreman-fqdn>` service has been created on FreeIPA server.

At first we create HBAC (host-based access control) service and rule  on the FreeIPA server. In the following examples, we will use the PAM  service name *foreman-prod*.

On the FreeIPA server, we define the HBAC service and rule and link them together:

```
ipa hbacsvc-add foreman-prod
ipa hbacrule-add allow_foreman_prod
ipa hbacrule-add-service allow_foreman_prod --hbacsvcs=foreman-prod
```

Then we add user we wish to have access to the service *foreman-prod*, and the hostname of our Foreman server:

```
ipa hbacrule-add-user allow_foreman_prod --user=<username>
ipa hbacrule-add-host allow_foreman_prod --hosts=<the-foreman-fqdn>
```

Alternatively, host groups and user groups could be added to the *allow_foreman_prod* rule.

At any point of the configuration, we can check the status of the rule:

```
ipa hbacrule-find foreman-prod
ipa hbactest --user=<username> --host=<the-foreman-fqdn> --service=foreman-prod
```

Chances are there will be HBAC rule *allow_all* matching besides our new *allow_foreman_prod* rule. See http://www.freeipa.org/page/Howto/HBAC_and_allow_all for steps to disable the catchall *allow_all* HBAC rule while maintaining the correct operation of your FreeIPA server and enrolled clients. The goal is only *allow_foreman_prod* matching when checked with `ipa hbactest`.

### 5.7.3 Kerberos Single Sign-On

In this part of the tutorial we will show how to set up Foreman authentication manually (without using installer option).

At first we enroll Foreman machine and define `HTTP/<the-foreman-fqdn>` service in the FreeIPA server. Then we define HBAC service and rules  (for more information see the previous section). In the following steps  we will use the HBAC service name *foreman-prod*.

Next step is to define matching PAM service on the Foreman machine. We create file `/etc/pam.d/foreman-prod` with the following content:

```
auth    required   pam_sss.so
account required   pam_sss.so
```

We will also want to enable two SELinux booleans on the Foreman machine:

```
setsebool -P allow_httpd_mod_auth_pam on
setsebool -P httpd_dbus_sssd on
```

Get the keytab for the service and set correct permissions (we assume the FreeIPA server is *ipa.example.com*, adjust to match your setup):

```
kinit admin
ipa-getkeytab -s $(awk '/^server =/ {print $3}' /etc/ipa/default.conf) -k /etc/http.keytab -p HTTP/$( hostname )
chown apache /etc/http.keytab
chmod 600 /etc/http.keytab
```

Install mod_auth_gssapi and mod_authnz_pam:

```
yum install -y mod_auth_gssapi mod_authnz_pam
```

Configure the module to be used by Apache (we assume the realm is *EXAMPLE.COM*, adjust to match your setup):

```
# add to /etc/httpd/conf.d/auth_kerb.conf
LoadModule auth_gssapi_module modules/mod_auth_gssapi.so
LoadModule authnz_pam_module modules/mod_authnz_pam.so
<Location /users/extlogin>
  AuthType GSSAPI
  AuthName "GSSAPI Single Sign On Login"
  GssapiCredStore keytab:/etc/http.keytab
  GssapiSSLonly On
  GssapiLocalName On
  # require valid-user
  require pam-account foreman-prod
  ErrorDocument 401 '<html><meta http-equiv="refresh" content="0; URL=/users/login"><body>Kerberos authentication did not pass.</body></html>'
  # The following is needed as a workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1020087
  ErrorDocument 500 '<html><meta http-equiv="refresh" content="0; URL=/users/login"><body>Kerberos authentication did not pass.</body></html>'
</Location>
```

We tell Foreman that it is OK to trust the authentication done by Apache by adding to `/etc/foreman/settings.yaml` or under *Administer > Settings > Authentication*:

```
:authorize_login_delegation: true
```

We restart Apache:

```
service httpd restart
```

The machine on which you run the browser to access Foreman’s WebUI  needs to be either FreeIPA-enrolled to the FreeIPA server or at least  configured (typically in `/etc/krb5.conf`) to know about the FreeIPA server Kerberos services. The browser needs  to have the Negotiate Authentication enabled; for example in Firefox, in the `about:config` settings, *network.negotiate-auth.trusted-uris* needs to include the Foreman server FQDN or its domain. If you then `kinit` as existing Foreman user to obtain Kerberos ticket-granting ticket,  accessing Foreman’s WebUI should not ask for login/password and should  display the authenticated dashboard directly.

Please note that we use directive `require pam-account foreman-prod` to also check the access against FreeIPA’s HBAC rule. If you do not see Kerberos authentication passing, check that the user is allowed access  in FreeIPA (in the section about HBAC configuration we’ve named the HBAC rule *allow_forman_prod*).

### 5.7.4 PAM Authentication

The FreeIPA server can be used as an authentication provider for  Foreman’s standard logon form. We assume the Foreman machine is already  FreeIPA-enrolled so sssd is configured to be able to facilitate the  authentication, and we have PAM service *foreman-prod* configured.

We will install the necessary Apache modules:

```
yum install -y mod_intercept_form_submit mod_authnz_pam
```

We will then configure Apache to perform PAM authentication (and access control check) using the PAM service *foreman-prod*, for example in configuration file `/etc/httpd/conf.d/intercept_form_submit.conf`:

```
LoadModule intercept_form_submit_module modules/mod_intercept_form_submit.so
LoadModule authnz_pam_module modules/mod_authnz_pam.so
<Location /users/login>
  InterceptFormPAMService foreman-prod
  InterceptFormLogin login[login]
  InterceptFormPassword login[password]
</Location>
```

After restarting Apache with `service httpd restart`, you should be able to log in to Foreman’s WebUI as existing user, using password from the FreeIPA server. Please note that **intercept_form_submit_module** uses **authnz_pam_module** to run not just the authentication, but access check as well. If the  authentication does not pass and you are sure you use the correct  password, check also that the user is allowed access in FreeIPA HBAC  rules.

### 5.7.5 Populate users and attributes

So far we have tried external authentication for existing Foreman users.

However, it is also possible to have the user’s records in Foreman  created automatically, on the fly when they first log in using external  authentication (single sign-on, PAM).

The first step to enable this feature is to add

:authorize_login_delegation_auth_source_user_autocreate: External

to `/etc/foreman/settings.yaml` or under *Administer > Settings > Authentication*.

Since we will want the newly created user records to have valid name and email address, we need to set up **sssd** to provide these attributes and **mod_lookup_identity** to pass them to Foreman. We start by installing the packages:

```
yum install -y sssd-dbus mod_lookup_identity
```

Amend the configuration of sssd in `/etc/sssd/sssd.conf`:

```
# /etc/sssd/sssd.conf, the [domain/...] section, add:
ldap_user_extra_attrs = email:mail, firstname:givenname, lastname:sn

# /etc/sssd/sssd.conf, the [sssd] section, amend the services line to include ifp:
services = nss, pam, ssh, ifp

# /etc/sssd/sssd.conf, add new [ifp] section:
[ifp]
allowed_uids = apache, root
user_attributes = +email, +firstname, +lastname
```

Configure Apache to retrieve these attributes, for example in `/etc/httpd/conf.d/lookup_identity.conf`:

```
LoadModule lookup_identity_module modules/mod_lookup_identity.so
<LocationMatch ^/users/(ext)?login$>
  LookupUserAttr email REMOTE_USER_EMAIL " "
  LookupUserAttr firstname REMOTE_USER_FIRSTNAME
  LookupUserAttr lastname REMOTE_USER_LASTNAME
  LookupUserGroupsIter REMOTE_USER_GROUP
</LocationMatch>
```

Restart both sssd and Apache:

```
service sssd restart
service httpd restart
```

Now when you log in either using Kerberos ticket or using user’s  FreeIPA password (make sure the user has access allowed in FreeIPA HBAC  rule), even if the user did not log in to Foreman before, their record  will be populated with name and email address from the FreeIPA server  (you can check in the top right corner that the full name is there) and  they will also be updated upon every subsequent  externally-authentication logon.

You might notice that the newly created user does not have many  access right. To fully use the central identity provider like FreeIPA,  it can be useful to link group membership of externally-authenticated  Foreman users to the group membership of users in FreeIPA, and then set  Foreman roles to these user groups. That way when a new network  administrator has their record created in FreeIPA with proper user  groups and then logs in to Foreman for the first time, their Foreman  account will automatically get group memberships in Foreman groups,  giving them appropriate roles and access rights.

The prerequisite is obviously to have the user groups and memberships set appropriately for your organization in FreeIPA.

For each FreeIPA user group that should have some semantics in  Foreman, we create new user groups in Foreman, and then use the tab *External groups* and *Add external user group* to add name of the user group in FreeIPA, for Auth source **EXTERNAL**. We can then assign roles to this Foreman user group to match the desired role for users from the given FreeIPA user group.

Upon their first login, externally-authenticated users will get their group membership in Foreman set to match the mapping to FreeIPA groups  and their group membership in FreeIPA. Upon subsequent  externally-authenticated logons, the membership in these mapped groups  will be updated to match the current membership in FreeIPA.

### 5.7.6 Namespace separation

If clear namespace separation of internally and externally  authenticated users is desired, we can distinguish the externally  authenticated (and populated) users by having @REALM part in their user  names.

For the Kerberos authentication, using `KrbLocalUserMapping Off` will keep the REALM part of the logon name:

```
# in /etc/httpd/conf.d/auth_kerb.conf
<Location /users/extlogin>
  AuthType Kerberos
  ...
  KrbLocalUserMapping Off
</Location>
```

For the PAM authentication, using `InterceptFormLoginRealms EXAMPLE.COM` will make the user’s login include this @REALM part (even if the user did not explicitly specify it), thus matching the username seen by Foreman when authenticated via Kerberos ticket:

```
# in /etc/httpd/conf.d/intercept_form_submit.conf
<Location /users/login>
  ...
  InterceptFormLoginRealms EXAMPLE.COM
</Location>
```

With this configuration, the @REALM will be part of the username and it would be clear that **bob** is INTERNAL-authenticated and **bob@EXAMPLE.COM** is different user, EXTERNAL-authenticated. The admin then can manually create another **admin@EXAMPLE.COM** user (with administrator privileges) and even the admin can use Kerberos or PAM authentication in this setup.

### 5.7.7 Single Sign-on for Foreman using OpenID Connect protocol

### Single Sign-on for Foreman using OpenID Connect protocol

An OpenID Provider(OP) implements a Single Sign-on (SSO) using an  OpenID Connect (OIDC) protocol. OIDC verifies the identity of the  End-user depending on the given authentication details. In this example, [Keycloak](https://www.keycloak.org/) is used as the OpenID provider, and Foreman is the Relying Party (RP).

OpenID provider provides an ID Token, encoded in JSON Web Token (JWT) to Foreman.

An example of an encoded JWT ID Token:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

#### Configuring Foreman

As a system administrator, execute the following procedure to configure Foreman.

Prerequisites

- A working installation of Foreman at https://foreman.example.com.
- A working installation of OpenID provider, for example, Keycloak  at https://keycloak.example.com, which uses the OIDC protocol. Ensure  that the Keycloak server is running.
- Ensure that both RP and OpenID provider are using https instead of http. If the certificates or the CA is self-signed, ensure that they  are added to the End-user certificate trust store.

Procedure

1. Install the mod_auth packages:    

   ```
   # yum install mod_auth_openidc keycloak-httpd-client-install -y
   ```

   Note: OIDC support is added to the keycloak-httpd-client-install package with minimum requirement of version 1.x.

2. Register Katello/Foreman as application in the Keycloak:    

   ```
   # export KEYCLOAK_URL=https://keycloak.example.com
   # export KEYCLOAK_REALM=ssl-realm
   # export KEYCLOAK_USER=admin
   # keycloak-httpd-client-install --app-name foreman-openidc --keycloak-server-url $KEYCLOAK_URL --keycloak-admin-username $KEYCLOAK_USER --keycloak-realm $KEYCLOAK_REALM --keycloak-admin-realm master --keycloak-auth-role root-admin -t openidc -l /users/extlogin -d
   ```

   Warning: This feature is not yet supported by foreman-installer.  As a result, re-running the foreman-installer command can purge the  changes in Apache files added by the keycloak-httpd-client-install.

3. Log in to the Foreman admin page and click **Administer** → **Settings** → **Authentication**. ![Foreman UI](https://theforeman.org/Foreman_UI.png)

4. Set **authorize_login_delegation_auth_source_user_autocreate** to **External** to enable auto-creation of users from external OpenID provider.

5. Set the following OIDC parameters:

**OIDC Algorithm**: Algorithm type with which JWT was encoded in the OpenID provider. For example, set this parameter to RS256.

**OIDC Audience**: Name of the OIDC audience used for authentication. In case of Keycloak, it is Client ID.

**OIDC Issuer**: The Issuer (iss) claim identifies the principal that issues the JWT.

**OIDC JWKS URL**: Open JSON Web key Set URL to validate the signature.

![Foreman UI](https://theforeman.org/Foreman_UI_Settings.png)

#### End-user

An end user can perform SSO by the following ways:

- User Interface
- Hammer-CLI

To perform the mentioned ways, ensure that Foreman is configured.

##### User Interface

Procedure

- Log in to the https://foreman.example.com/users/extlogin

Foreman will automatically redirect to Keycloak Sign-in page. If credentials are correct, it redirects to the Foreman dashboard.

##### Hammer-cli

Hammer-cli supports the following methods to obtain ID token and perform authentication:

- Authorization Code Grant Flow
- Password Grant Flow

###### Authorization Code Grant Flow

Authorization Code Flow is a two step process:

- Authorization Code Flow returns an Authorization Code to the client.
- This Code can be exchanged for an access token directly.

Procedure

1. Get the token endpoint and authorization endpoint from the  .well-known/openid-configuration URL of your OpenID provider. For  example in case of Keycloak, get token and authorization endpoint from:  https:///auth/realms//.well-known/openid-configuration

2. Log in to Foreman:

   ```
   hammer auth login oauth --two-factor --oidc-token-endpoint https://keycloak.example.com/token --oidc-authorization-endpoint https://keycloak.example.com/auth --oidc-client-id foreman-client --oidc-redirect-uri urn:ietf:wg:oauth:2.0:oob
   ```

###### Password Grant Flow

The end user provides username and password for authentication and  makes a POST request to the OpenID provider to exchange the password for an access token.

Procedure

1. Get token endpoint from the .well-known/openid-configuration URL  of your OpenID provider. For example in case of Keycloak get token  endpoint from: https:///auth/realms//.well-known/openid-configuration

2. Log in to Foreman:

   ```
   hammer auth login oauth --oidc-token-endpoint https://keycloak.example.com/token --oidc-client-id foreman-client --username myuser --password changeme
   ```

## 5.8 Multiple Foreman instances

The following steps are suggested when configuring multiple Foreman  instances to work together. They will ensure that data, passwords, and  cookies are shared between multiple instances.

`$app_root` is wherever you installed Foreman, usually `/usr/share/foreman`.

### 5.8.1 Sharing the database

All Foreman instances in a cluster/group must point to the same  database. This can be done during the initial installation (through  flags or altering `foreman_installer_answers.yaml`) or by directly altering `/etc/foreman/database.yaml` and pointing the correct environment (usually production) to your Foreman DB, then restarting Foreman.

### 5.8.2 Encrypting passwords

As described in [5.2.10](https://theforeman.org/manuals/3.5/index.html#5.2.10PasswordEncryption), passwords stored locally in Foreman’s DB are encrypted. In order for  multiple Foreman instances to encrypt and decrypt passwords correctly,  they all need to have the same encryption key defined in `/etc/foreman/encryption_key.rb`.

### 5.8.3 Signing cookies

The last file required to make a Foreman cluster work is `$app_root/config/initializers/local_secret_token.rb`, which is used to sign cookies. This should be set the same across all Foreman servers in your cluster. Once you have set `local_secret_token.rb`, restart Foreman and clear Foreman’s cache:

```
systemctl restart foreman
foreman-rake tmp:cache:clear
foreman-rake tmp:sessions:clear
```

Note: Without this change, the user may need to log in multiple times or run in to “Invalid Authenticity Token”/CSRF issues.

### 5.8.4 Other considerations

There are other considerations when creating a cluster:

1. You might want to share a common hostname, which can be set during installation or by modifying your Apache config files.
2. You might want a custom cert to reflect the cluster’s cname, and  you’ll want to make sure your Foreman-related infrastructure is [configured to use SSL](https://theforeman.org/manuals/3.5/index.html#5.4SecuringCommunicationswithSSL).
3. You can use a central memcached instance instead of each Foreman instance’s local cache. Foreman has a [plugin](https://github.com/theforeman/foreman_memcache) you can use.

## 5.9 HTTP(S) Proxy

There are two proxy settings in Foreman to allow HTTP(s) communication through firewalls.

*Global option*

In Administer - Settings - General menu there are two options available for setting outgoing HTTP(s) proxy for all communication (e.g. to Smart Proxies, Compute Resources):

- HTTP(S) proxy - hostname, port and optional credentials in the format of `http://[user:password@]HOST:PORT`
- HTTP(S) proxy except hosts - list of hostnames to exclude separated by commas

Both settings can also be configured via `settings.yaml` file via `:http_proxy:` and `:http_proxy_except_list:` options.

*Infrastructure - HTTP Proxies page*

It is possible to configure multiple HTTP(s) proxies for various Compute Resources. Each individual Compute Resources can be associated with a different proxy. To create proxy URL, visit Infrastructure - HTTP Proxies and then associate the proxy with a Compute Resource.

Currently HTTP Proxies are supported by the following Compute Resources:

- EC2
- Google Compute Engine

*Notes*

Both cases only affect outgoing HTTP(s) connection of the Foreman core application (Ruby on Rails process). There are other plugins and components running on a typical Foreman deployment (e.g. websocket proxy, Pulp, Candlepin) and those services are not affected. Most of them can be configured separately.

# 6. Plugins

Please refer to the [plugins manual](https://theforeman.org/plugins/).

# 7. Troubleshooting

## 7.1 NoVNC

Foreman uses the excellent javascript VNC library [noVNC](https://novnc.com/info.html), which allows clientless VNC within a web browser. When a console is  opened by the user’s web browser, Foreman opens a connection to TCP Port 5910 (and up) on the hypervisor and redirects that itself.

### Requirements

- Recent web browser
- Open network connection from the workstation where the web browser runs on to your Foreman server and from your Foreman server to the  hypervisor on TCP ports 5910 - 5930.

### Encrypted Web Sockets

For VNC only, encrypted connections are the default on new  installations.  If you have an older installation of Foreman, you can  configure encrypted websockets by adding these lines to `/etc/foreman/settings.yml`, and configuring the correct path to the same SSL certificates apache uses:

```
:websockets_encrypt: on
:websockets_ssl_key: /var/lib/puppet/ssl/private_keys/foreman.example.com
:websockets_ssl_cert: /var/lib/puppet/ssl/certs/foreman.example.com
```

### Known issues

- SPICE connections are not encrypted.
- For encrypted connections, you will need to trust the Foreman CA.  This is typically stored in /var/lib/puppet/ssl/certs/ca.pem, you may  wish to copy this to something like /var/www/html/pub/ca.crt so that  users may easily find it.
- Keyboard mappings are currently fixed to English only.
- When using Firefox, if you use Foreman via HTTPS, Firefox might block the connection. To fix it, go to `about:config` and enable `network.websocket.allowInsecureFromHTTPS`.
- When using Chrome, browse to `chrome://flags/` and enable allow-insecure-websocket-from-https-origin.  Recent versions of Chrome (e.g. 44) have removed the flag.  An alternative workaround  is to launch Chrome with a command-line argument like this `$ google-chrome-stable --allow-running-insecure-content &`

### Troubleshooting Steps

- Check for a “websockify.py” process on your Foreman server when opening the console page in Foreman

- If websockify.py is missing, check /var/log/foreman/production.log for stderr output with logging increased to debug

- Look at the last argument of the process command line, it will  have the hypervisor hostname and port - ensure you can resolve and ping  this hostname

- Make sure you access Foreman web UI via FQDN as the certificate does not have shortened hostname.

- Try a telnet/netcat connection from the Foreman host to the hypervisor hostname/port

- The penultimate argument of websockify.py is the listening port number, check if your web client host can telnet to it

- If using Firefox, check the known issues above and set the config appropriately

- The error “WebSock error: [object Event]” can be caused by a self  signed certificate, where the certificate`s algorithm is too weak, e.g.  SHA1. Debugging the issue with the Firefox JavaScript Console will show a  warning similar to 

  “This site makes use of a SHA-1 Certificate; it’s recommended you use certificates with signature algorithms that use  hash functions stronger than SHA-1”

  . See 

  Weak Signature Algorithms

   on Mozilla website.    

  - To solve this issue, use stronger SSL certificates like SHA-2 algorithms instead.
  - Check your current algorithm used for the SSL certificate with openssl and generate a new one if necessary:
  - `# openssl  x509 -in /etc/ssl/certs/foreman.domain.tld.crt -text -noout |grep  Algorithm Signature Algorithm: *sha1WithRSAEncryption*`

## 7.2 Debugging

### Foreman debugging

Edit `/etc/foreman/settings.yaml` and either uncomment or add these lines:

```
:logging:
  :level: debug
```

And reload Foreman:

```
systemctl restart foreman
```

#### Enabling more specific logs

More types of log messages can be enabled from settings.yaml. The following loggers are enabled by default:

- app - web requests and all general application logs
- audit - additional fact import statistics, numbers of facts added/updated/removed
- proxy - logs from reaching out to smart proxies
- notifications - logs from notification handlers
- backgroud - logs from background jobs like RSS or Dynflow
- dynflow - low level logs from dynflow engine
- templates - messages from template renderer
- blob - contents of rendered templates for archival purposes

The following loggers needs to be explicitly enabled:

- ldap - high level LDAP queries (e.g. find users in group) and LDAP operations performed (default: false)
- permissions - evaluation of user roles, filters and permissions when loading pages
- sql - SQL queries made through Rails ActiveRecord, only debug
- telemetry - logs for debugging telemetry messages

Uncomment or add a :loggers block to enable or disable loggers:

```
:loggers:
  :ldap:
    :enabled: true
```

Plugins may add their own logs too, see /etc/foreman/plugins/ for their possible configuration.

Also see [Configuration Options](https://theforeman.org/manuals/3.5/index.html#3.5.2ConfigurationOptions) for more information.

#### Structured logging

Starting from Foreman 1.18, logging stack can be configured to log into system journal:

```
:logging:
  :level: info
  :type: journald
```

On Red Hat compatible systems, journald is running in transient mode  by default and forwards all logs to syslog which means structured  information is dropped after some time (memory buffer only holds few  hours back). To see structured fields:

```
journalctl -fo verbose
```

Here is the list of most important structured fields which can help with debugging:

| Journald name       | JSON name                      | Description                                                  |
| ------------------- | ------------------------------ | ------------------------------------------------------------ |
| USER_LOGIN          | ["mdc"]["user_login"]          | User login name                                              |
| ORG_ID              | ["mdc"]["org_id"]              | Organization database ID                                     |
| LOC_ID              | ["mdc"]["loc_id"]              | Location database ID                                         |
| REMOTE_IP           | ["mdc"]["remote_ip"]           | Remote IP address of a client                                |
| REQUEST             | ["mdc"]["request"]             | Request ID generated by ActionDispatch                       |
| SESSION             | ["mdc"]["session"]             | Random ID generated per session or request for session-less request |
| EXCEPTION_MESSAGE   | ["ndc"]["exception_message"]   | Exception message when error is logged                       |
| EXCEPTION_CLASS     | ["ndc"]["exception_class"]     | Exception Ruby class when error is logged                    |
| EXCEPTION_BACKTRACE | ["ndc"]["exception_backtrace"] | Exception backtrace as a multiline string when error is logged |
| TEMPLATE_NAME       | ["ndc"]["template_name"]       | Template name (blob logger)                                  |
| TEMPLATE_DIGEST     | ["ndc"]["template_digest"]     | Digest (SHA256) of rendered template contents (blob logger)  |
| TEMPLATE_HOST_NAME  | ["ndc"]["template_host_name"]  | Host name for a rendered template if present (blob logger)   |
| TEMPLATE_HOST_ID    | ["ndc"]["template_host_id"]    | Host database ID for a rendered template if present (blob logger) |
| AUDIT_ACTION        | ["ndc"]["audit_action"]        | Action performed (e.g. create/update/delete)                 |
| AUDIT_TYPE          | ["ndc"]["audit"]               | Database model class or type, subject of an audit record (e.g. Hostgroup or Subnet) |
| AUDIT_ID            | ["ndc"]["audit"]               | Record database ID of the audit subject                      |
| AUDIT_ATTRIBUTE     | ["ndc"]["audit"]               | Attribute name or column an action was performed on (e.g. name or description) |

To persist structured fields, enable persistent system journal by creating `/var/log/journal` directory. Alternatively, logging into JSON format can be used with syslog or file appenders for further integration:

```
:logging:
  :level: info
  :type: syslog
  :json_items:
    - logger
    - timestamp
    - level
    - message
    - mdc
    - ndc
  :facility: LOG_LOCAL6
```

Structured fields from Foreman appear under “mdc” and “ndc” elements. The logging stack is able to provide additional context via `json_items` setting:

- logger - the name of the logger that generated the log event.
- timestamp - the timestamp of the log event.
- level - the level of the log event.
- message - the application supplied message associated with the log event.
- file - the file name where the logging request was issued.
- line - the line number where the logging request was issued.
- method - the method name where the logging request was issued.
- hostname - the hostname
- pid - the process ID of the currently running program.
- millis - the number of milliseconds elapsed from the construction of the Layout until creation of the log event.
- thread_id - the object ID of the thread that generated the log event.
- thread - the name of the thread that generated the log event. Name can be specified using Thread.current[:name] notation. Output empty  string if name not specified. This option helps to create more human  readable output for multithread application logs.

#### Syslog facility

By default, syslog facility is set to LOCAL6 (or USER6). This can be changed via:

```
:logging:
  :facility: LOG_LOCAL6
```

To forward logs to separate directory via rsyslog, create file `/etc/rsyslog.d/foreman.conf`:

```
local6.* /var/log/foreman/production.log
```

### Smart proxy debugging

Edit `/etc/foreman-proxy/settings.yml` and change or add :log_level:

```
# WARN, DEBUG, Error, Fatal, INFO, UNKNOWN
:log_level: DEBUG
```

And restart the smart proxy:

```
service foreman-proxy restart
```

Also see [Smart Proxy Settings](https://theforeman.org/manuals/3.5/index.html#4.3.2SmartProxySettings) for more information.

## 7.3 Getting Help

Please check the [Troubleshooting wiki page](http://projects.theforeman.org/projects/1/wiki/Troubleshooting) for solutions to the most common problems.  Otherwise, there are two  primary methods of getting support for the Foreman: IRC and discussion  forums.

### IRC

We work on the [libera.chat](https://libera.chat/) servers. You can get general support in #theforeman, while development chat takes place in #theforeman-dev.

### Discussion Forums

An online discussion forum is available at  https://community.theforeman.org/. Much like IRC, we have discussion  areas for general users (support, Q/A, etc), as well as a discussion  areas for developers, tutorials and release announcements.

- [General Support](https://community.theforeman.org/c/support)
- [Development](https://community.theforeman.org/c/support)
- [Release Announcements](https://community.theforeman.org/c/release-announcements)

### Gathering information

In order to troubleshoot and get relevant data use foreman-debug  which collects information about your OS, Foreman and related  components. If you installed from packages, the command is available to root:

```
# foreman-debug
```

If you installed from git, you can find it in the Foreman directory:

```
# script/foreman-debug
```

If you run it without any options, it will collect data, filter out possible passwords or tokens and create a tarball which can be safely handed over to us.

To upload the tarball to our public server via rsync use:

```
# foreman-debug -u
```

This is a write-only directory (readable only by Foreman core  developers), please note that the rsync transmission is UNENCRYPTED.