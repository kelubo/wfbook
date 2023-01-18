The guides in this section cover using Ansible with specific network  technologies. They explore particular use cases in greater depth and  provide a more “top-down” explanation of some basic features.

- [Cisco ACI Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html)
- [Cisco Meraki Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html)
- [Infoblox Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html)

To learn more about Network Automation with Ansible, see [Network Getting Started](https://docs.ansible.com/ansible/latest/network/getting_started/index.html#network-getting-started) and [Network Advanced Topics](https://docs.ansible.com/ansible/latest/network/user_guide/index.html#network-advanced).

# Cisco ACI Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#cisco-aci-guide)



## What is Cisco ACI ?[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#what-is-cisco-aci)

### Application Centric Infrastructure (ACI)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#application-centric-infrastructure-aci)

The Cisco Application Centric Infrastructure (ACI) allows application requirements to define the network. This architecture simplifies,  optimizes, and accelerates the entire application deployment life cycle.

### Application Policy Infrastructure Controller (APIC)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#application-policy-infrastructure-controller-apic)

The APIC manages the scalable ACI multi-tenant fabric. The APIC  provides a unified point of automation and management, policy  programming, application deployment, and health monitoring for the  fabric. The APIC, which is implemented as a replicated synchronized  clustered controller, optimizes performance, supports any application  anywhere, and provides unified operation of the physical and virtual  infrastructure.

The APIC enables network administrators to easily define the optimal  network for applications. Data center operators can clearly see how  applications consume network resources, easily isolate and troubleshoot  application and infrastructure problems, and monitor and profile  resource usage patterns.

The Cisco Application Policy Infrastructure Controller (APIC) API  enables applications to directly connect with a secure, shared,  high-performance resource pool that includes network, compute, and  storage capabilities.

### ACI Fabric[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#aci-fabric)

The Cisco Application Centric Infrastructure (ACI) Fabric includes  Cisco Nexus 9000 Series switches with the APIC to run in the leaf/spine  ACI fabric mode. These switches form a “fat-tree” network by connecting  each leaf node to each spine node; all other devices connect to the leaf nodes. The APIC manages the ACI fabric.

The ACI fabric provides consistent low-latency forwarding across  high-bandwidth links (40 Gbps, with a 100-Gbps future capability).  Traffic with the source and destination on the same leaf switch is  handled locally, and all other traffic travels from the ingress leaf to  the egress leaf through a spine switch. Although this architecture  appears as two hops from a physical perspective, it is actually a single Layer 3 hop because the fabric operates as a single Layer 3 switch.

The ACI fabric object-oriented operating system (OS) runs on each  Cisco Nexus 9000 Series node. It enables programming of objects for each configurable element of the system. The ACI fabric OS renders policies  from the APIC into a concrete model that runs in the physical  infrastructure. The concrete model is analogous to compiled software; it is the form of the model that the switch operating system can execute.

All the switch nodes contain a complete copy of the concrete model.  When an administrator creates a policy in the APIC that represents a  configuration, the APIC updates the logical model. The APIC then  performs the intermediate step of creating a fully elaborated policy  that it pushes into all the switch nodes where the concrete model is  updated.

The APIC is responsible for fabric activation, switch firmware  management, network policy configuration, and instantiation. While the  APIC acts as the centralized policy and network management engine for  the fabric, it is completely removed from the data path, including the  forwarding topology. Therefore, the fabric can still forward traffic  even when communication with the APIC is lost.

### More information[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#more-information)

Various resources exist to start learning ACI, here is a list of interesting articles from the community.

- [Adam Raffe: Learning ACI](https://adamraffe.com/learning-aci/)
- [Luca Relandini: ACI for dummies](https://lucarelandini.blogspot.be/2015/03/aci-for-dummies.html)
- [Cisco DevNet Learning Labs about ACI](https://learninglabs.cisco.com/labs/tags/ACI)



## Using the ACI modules[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#using-the-aci-modules)

The Ansible ACI modules provide a user-friendly interface to managing your ACI environment using Ansible playbooks.

For instance ensuring that a specific tenant exists, is done using the following Ansible task using the aci_tenant module:

```
- name: Ensure tenant customer-xyz exists
  aci_tenant:
    host: my-apic-1
    username: admin
    password: my-password

    tenant: customer-xyz
    description: Customer XYZ
    state: present
```

A complete list of existing ACI modules is available on the content tab of the [ACI collection on Ansible Galaxy](https://galaxy.ansible.com/cisco/aci).

If you want to learn how to write your own ACI modules to contribute, look at the [Developing Cisco ACI modules](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general_aci.html#aci-dev-guide) section.

### Querying ACI configuration[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#querying-aci-configuration)

A module can also be used to query a specific object.

```
- name: Query tenant customer-xyz
  aci_tenant:
    host: my-apic-1
    username: admin
    password: my-password

    tenant: customer-xyz
    state: query
  register: my_tenant
```

Or query all objects.

```
- name: Query all tenants
  aci_tenant:
    host: my-apic-1
    username: admin
    password: my-password

    state: query
  register: all_tenants
```

After registering the return values of the aci_tenant task as shown above, you can access all tenant information from variable `all_tenants`.

### Running on the controller locally[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#running-on-the-controller-locally)

As originally designed, Ansible modules are shipped to and run on the remote target(s), however the ACI modules (like most network-related  modules) do not run on the network devices or controller (in this case  the APIC), but they talk directly to the APIC’s REST interface.

For this very reason, the modules need to run on the local Ansible controller (or are delegated to another system that *can* connect to the APIC).

#### Gathering facts[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#gathering-facts)

Because we run the modules on the Ansible controller gathering facts  will not work. That is why when using these ACI modules it is mandatory  to disable facts gathering. You can do this globally in your `ansible.cfg` or by adding `gather_facts: false` to every play.

```
 - name: Another play in my playbook
   hosts: my-apic-1
   gather_facts: false
   tasks:
   - name: Create a tenant
     aci_tenant:
       ...
```

#### Delegating to localhost[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#delegating-to-localhost)

So let us assume we have our target configured in the inventory using the FQDN name as the `ansible_host` value, as shown below.

```
 apics:
   my-apic-1:
     ansible_host: apic01.fqdn.intra
     ansible_user: admin
     ansible_password: my-password
```

One way to set this up is to add to every task the directive: `delegate_to: localhost`.

```
 - name: Query all tenants
   aci_tenant:
     host: '{{ ansible_host }}'
     username: '{{ ansible_user }}'
     password: '{{ ansible_password }}'

     state: query
   delegate_to: localhost
   register: all_tenants
```

If one would forget to add this directive, Ansible will attempt to  connect to the APIC using SSH and attempt to copy the module and run it  remotely. This will fail with a clear error, yet may be confusing to  some.

#### Using the local connection method[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#using-the-local-connection-method)

Another option frequently used, is to tie the `local` connection method to this target so that every subsequent task for this target will use the local connection method (hence run it locally,  rather than use SSH).

In this case the inventory may look like this:

```
 apics:
   my-apic-1:
     ansible_host: apic01.fqdn.intra
     ansible_user: admin
     ansible_password: my-password
     ansible_connection: local
```

But used tasks do not need anything special added.

```
- name: Query all tenants
  aci_tenant:
    host: '{{ ansible_host }}'
    username: '{{ ansible_user }}'
    password: '{{ ansible_password }}'

    state: query
  register: all_tenants
```

Hint

For clarity we have added `delegate_to: localhost` to all the examples in the module documentation. This helps to ensure  first-time users can easily copy&paste parts and make them work with a minimum of effort.

### Common parameters[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#common-parameters)

Every Ansible ACI module accepts the following parameters that influence the module’s communication with the APIC REST API:

> - host
>
>   Hostname or IP address of the APIC.
>
> - port
>
>   Port to use for communication. (Defaults to `443` for HTTPS, and `80` for HTTP)
>
> - username
>
>   User name used to log on to the APIC. (Defaults to `admin`)
>
> - password
>
>   Password for `username` to log on to the APIC, using password-based authentication.
>
> - private_key
>
>   Private key for `username` to log on to APIC, using signature-based authentication. This could either be the raw private key content (include header/footer) or a file that stores the key content. *New in version 2.5*
>
> - certificate_name
>
>   Name of the certificate in the ACI Web GUI. This defaults to either the `username` value or the `private_key` file base name). *New in version 2.5*
>
> - timeout
>
>   Timeout value for socket-level communication.
>
> - use_proxy
>
>   Use system proxy settings. (Defaults to `yes`)
>
> - use_ssl
>
>   Use HTTPS or HTTP for APIC REST communication. (Defaults to `yes`)
>
> - validate_certs
>
>   Validate certificate when using HTTPS communication. (Defaults to `yes`)
>
> - output_level
>
>   Influence the level of detail ACI modules return to the user. (One of `normal`, `info` or `debug`) *New in version 2.5*

### Proxy support[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#proxy-support)

By default, if an environment variable `<protocol>_proxy` is set on the target host, requests will be sent through that proxy.  This behaviour can be overridden by setting a variable for this task  (see [Setting the remote environment](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_environment.html#playbooks-environment)), or by using the `use_proxy` module parameter.

HTTP redirects can redirect from HTTP to HTTPS so ensure that the proxy environment for both protocols is correctly configured.

If proxy support is not needed, but the system may have it configured nevertheless, use the parameter `use_proxy: false` to avoid accidental system proxy usage.

Hint

Selective proxy support using the `no_proxy` environment variable is also supported.

### Return values[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#return-values)

New in version 2.5.

The following values are always returned:

> - current
>
>   The resulting state of the managed object, or results of your query.

The following values are returned when `output_level: info`:

> - previous
>
>   The original state of the managed object (before any change was made).
>
> - proposed
>
>   The proposed config payload, based on user-supplied values.
>
> - sent
>
>   The sent config payload, based on user-supplied values and the existing configuration.

The following values are returned when `output_level: debug` or `ANSIBLE_DEBUG=1`:

> - filter_string
>
>   The filter used for specific APIC queries.
>
> - method
>
>   The HTTP method used for the sent payload. (Either `GET` for queries, `DELETE` or `POST` for changes)
>
> - response
>
>   The HTTP response from the APIC.
>
> - status
>
>   The HTTP status code for the request.
>
> - url
>
>   The url used for the request.

Note

The module return values are documented in detail as part of each module’s documentation.

### More information[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#id1)

Various resources exist to start learn more about ACI programmability, we recommend the following links:

- [Developing Cisco ACI modules](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general_aci.html#aci-dev-guide)
- [Jacob McGill: Automating Cisco ACI with Ansible](https://blogs.cisco.com/developer/automating-cisco-aci-with-ansible-eliminates-repetitive-day-to-day-tasks)
- [Cisco DevNet Learning Labs about ACI and Ansible](https://learninglabs.cisco.com/labs/tags/ACI,Ansible)



## ACI authentication[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#aci-authentication)

### Password-based authentication[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#password-based-authentication)

If you want to log on using a username and password, you can use the following parameters with your ACI modules:

```
username: admin
password: my-password
```

Password-based authentication is very simple to work with, but it is  not the most efficient form of authentication from ACI’s point-of-view  as it requires a separate login-request and an open session to work. To  avoid having your session time-out and requiring another login, you can  use the more efficient Signature-based authentication.

Note

Password-based authentication also may trigger anti-DoS measures in  ACI v3.1+ that causes session throttling and results in HTTP 503 errors  and login failures.

Warning

Never store passwords in plain text.

The “Vault” feature of Ansible allows you to keep sensitive data such as passwords or keys in encrypted files, rather than as plain text in  your playbooks or roles. These vault files can then be distributed or  placed in source control. See [Using encrypted variables and files](https://docs.ansible.com/ansible/latest/vault_guide/vault_using_encrypted_content.html#playbooks-vault) for more information.

### Signature-based authentication using certificates[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#signature-based-authentication-using-certificates)

New in version 2.5.

Using signature-based authentication is more efficient and more reliable than password-based authentication.

#### Generate certificate and private key[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#generate-certificate-and-private-key)

Signature-based authentication requires a (self-signed) X.509  certificate with private key, and a configuration step for your AAA user in ACI. To generate a working X.509 certificate and private key, use  the following procedure:

```
$ openssl req -new -newkey rsa:1024 -days 36500 -nodes -x509 -keyout admin.key -out admin.crt -subj '/CN=Admin/O=Your Company/C=US'
```

#### Configure your local user[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#configure-your-local-user)

Perform the following steps:

- Add the X.509 certificate to your ACI AAA local user at ADMIN » AAA
- Click AAA Authentication
- Check that in the Authentication field the Realm field displays Local
- Expand Security Management » Local Users
- Click the name of the user you want to add a certificate to, in the User Certificates area
- Click the + sign and in the Create X509 Certificate enter a certificate name in the Name field
  - If you use the basename of your private key here, you don’t need to enter `certificate_name` in Ansible
- Copy and paste your X.509 certificate in the Data field.

You can automate this by using the following Ansible task:

```
- name: Ensure we have a certificate installed
  aci_aaa_user_certificate:
    host: my-apic-1
    username: admin
    password: my-password

    aaa_user: admin
    certificate_name: admin
    certificate: "{{ lookup('file', 'pki/admin.crt') }}"  # This will read the certificate data from a local file
```

Note

Signature-based authentication only works with local users.

#### Use signature-based authentication with Ansible[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#use-signature-based-authentication-with-ansible)

You need the following parameters with your ACI module(s) for it to work:

```
 username: admin
 private_key: pki/admin.key
 certificate_name: admin  # This could be left out !
```

or you can use the private key content:

```
 username: admin
 private_key: |
     -----BEGIN PRIVATE KEY-----
     <<your private key content>>
     -----END PRIVATE KEY-----
 certificate_name: admin  # This could be left out !
```

Hint

If you use a certificate name in ACI that matches the private key’s basename, you can leave out the `certificate_name` parameter like the example above.

#### Using Ansible Vault to encrypt the private key[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#using-ansible-vault-to-encrypt-the-private-key)

New in version 2.8.

To start, encrypt the private key and give it a strong password.

```
ansible-vault encrypt admin.key
```

Use a text editor to open the private-key. You should have an encrypted cert now.

```
$ANSIBLE_VAULT;1.1;AES256
56484318584354658465121889743213151843149454864654151618131547984132165489484654
45641818198456456489479874513215489484843614848456466655432455488484654848489498
....
```

Copy and paste the new encrypted cert into your playbook as a new variable.

```
private_key: !vault |
      $ANSIBLE_VAULT;1.1;AES256
      56484318584354658465121889743213151843149454864654151618131547984132165489484654
      45641818198456456489479874513215489484843614848456466655432455488484654848489498
      ....
```

Use the new variable for the private_key:

```
username: admin
private_key: "{{ private_key }}"
certificate_name: admin  # This could be left out !
```

When running the playbook, use “–ask-vault-pass” to decrypt the private key.

```
ansible-playbook site.yaml --ask-vault-pass
```

#### More information[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#id2)

- Detailed information about Signature-based Authentication is available from [Cisco APIC Signature-Based Transactions](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/kb/b_KB_Signature_Based_Transactions.html).
- More information on Ansible Vault can be found on the [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/vault.html#vault) page.



## Using ACI REST with Ansible[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#using-aci-rest-with-ansible)

While already a lot of ACI modules exists in the Ansible  distribution, and the most common actions can be performed with these  existing modules, there’s always something that may not be possible with off-the-shelf modules.

The aci_rest module provides you with direct access to the APIC REST  API and enables you to perform any task not already covered by the  existing modules. This may seem like a complex undertaking, but you can  generate the needed REST payload for any action performed in the ACI web interface effortlessly.

### Built-in idempotency[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#built-in-idempotency)

Because the APIC REST API is intrinsically idempotent and can report  whether a change was made, the aci_rest module automatically inherits  both capabilities and is a first-class solution for automating your ACI  infrastructure. As a result, users that require more powerful low-level  access to their ACI infrastructure don’t have to give up on idempotency  and don’t have to guess whether a change was performed when using the  aci_rest module.

### Using the aci_rest module[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#using-the-aci-rest-module)

The aci_rest module accepts the native XML and JSON payloads, but  additionally accepts inline YAML payload (structured like JSON). The XML payload requires you to use a path ending with `.xml` whereas JSON or YAML require the path to end with `.json`.

When you’re making modifications, you can use the POST or DELETE methods, whereas doing just queries require the GET method.

For instance, if you would like to ensure a specific tenant exists on ACI, these below four examples are functionally identical:

**XML** (Native ACI REST)

```
- aci_rest:
    host: my-apic-1
    private_key: pki/admin.key

    method: post
    path: /api/mo/uni.xml
    content: |
      <fvTenant name="customer-xyz" descr="Customer XYZ"/>
```

**JSON** (Native ACI REST)

```
- aci_rest:
    host: my-apic-1
    private_key: pki/admin.key

    method: post
    path: /api/mo/uni.json
    content:
      {
        "fvTenant": {
          "attributes": {
            "name": "customer-xyz",
            "descr": "Customer XYZ"
          }
        }
      }
```

**YAML** (Ansible-style REST)

```
- aci_rest:
    host: my-apic-1
    private_key: pki/admin.key

    method: post
    path: /api/mo/uni.json
    content:
      fvTenant:
        attributes:
          name: customer-xyz
          descr: Customer XYZ
```

**Ansible task** (Dedicated module)

```
- aci_tenant:
    host: my-apic-1
    private_key: pki/admin.key

    tenant: customer-xyz
    description: Customer XYZ
    state: present
```

Hint

The XML format is more practical when there is a need to template the REST payload (inline), but the YAML format is more convenient for  maintaining your infrastructure-as-code and feels more naturally  integrated with Ansible playbooks. The dedicated modules offer a more  simple, abstracted, but also a more limited experience. Use what feels  best for your use-case.

### More information[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#id3)

Plenty of resources exist to learn about ACI’s APIC REST interface, we recommend the links below:

- [The ACI collection on Ansible Galaxy](https://galaxy.ansible.com/cisco/aci)
- [APIC REST API Configuration Guide](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/2-x/rest_cfg/2_1_x/b_Cisco_APIC_REST_API_Configuration_Guide.html) – Detailed guide on how the APIC REST API is designed and used, incl. many examples
- [APIC Management Information Model reference](https://developer.cisco.com/docs/apic-mim-ref/) – Complete reference of the APIC object model
- [Cisco DevNet Learning Labs about ACI and REST](https://learninglabs.cisco.com/labs/tags/ACI,REST)



## Operational examples[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#operational-examples)

Here is a small overview of useful operational tasks to reuse in your playbooks.

Feel free to contribute more useful snippets.

### Waiting for all controllers to be ready[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#waiting-for-all-controllers-to-be-ready)

You can use the below task after you started to build your APICs and  configured the cluster to wait until all the APICs have come online. It  will wait until the number of controllers equals the number listed in  the `apic` inventory group.

```
- name: Waiting for all controllers to be ready
  aci_rest:
    host: my-apic-1
    private_key: pki/admin.key
    method: get
    path: /api/node/class/topSystem.json?query-target-filter=eq(topSystem.role,"controller")
  register: topsystem
  until: topsystem|success and topsystem.totalCount|int >= groups['apic']|count >= 3
  retries: 20
  delay: 30
```

### Waiting for cluster to be fully-fit[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#waiting-for-cluster-to-be-fully-fit)

The below example waits until the cluster is fully-fit. In this  example you know the number of APICs in the cluster and you verify each  APIC reports a ‘fully-fit’ status.

```
- name: Waiting for cluster to be fully-fit
  aci_rest:
    host: my-apic-1
    private_key: pki/admin.key
    method: get
    path: /api/node/class/infraWiNode.json?query-target-filter=wcard(infraWiNode.dn,"topology/pod-1/node-1/av")
  register: infrawinode
  until: >
    infrawinode|success and
    infrawinode.totalCount|int >= groups['apic']|count >= 3 and
    infrawinode.imdata[0].infraWiNode.attributes.health == 'fully-fit' and
    infrawinode.imdata[1].infraWiNode.attributes.health == 'fully-fit' and
    infrawinode.imdata[2].infraWiNode.attributes.health == 'fully-fit'
  retries: 30
  delay: 30
```



## APIC error messages[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#apic-error-messages)

The following error messages may occur and this section can help you  understand what exactly is going on and how to fix/avoid them.

> - APIC Error 122: unknown managed object class ‘polUni’
>
>   In  case you receive this error while you are certain your aci_rest payload  and object classes are seemingly correct, the issue might be that your  payload is not in fact correct JSON (for example, the sent payload is  using single quotes, rather than double quotes), and as a result the  APIC is not correctly parsing your object classes from the payload. One  way to avoid this is by using a YAML or an XML formatted payload, which  are easier to construct correctly and modify later.
>
> - APIC Error 400: invalid data at line ‘1’. Attributes are missing, tag ‘attributes’ must be specified first, before any other tag
>
>   Although the JSON specification allows unordered elements, the APIC REST API requires that the JSON `attributes` element precede the `children` array or other elements. So you need to ensure that your payload  conforms to this requirement. Sorting your dictionary keys will do the  trick just fine. If you don’t have any attributes, it may be necessary  to add: `attributes: {}` as the APIC does expect the entry to precede any `children`.
>
> - APIC Error 801: property descr of uni/tn-TENANT/ap-AP failed validation for value ‘A “legacy” network’
>
>   Some values in the APIC have strict format-rules to comply to, and the  internal APIC validation check for the provided value failed. In the  above case, the `description` parameter (internally known as `descr`) only accepts values conforming to Regex: `[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]+`, in general it must not include quotes or square brackets.



## Known issues[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#known-issues)

The aci_rest module is a wrapper around the APIC REST API. As a  result any issues related to the APIC will be reflected in the use of  this module.

All below issues either have been reported to the vendor, and most can simply be avoided.

> - Too many consecutive API calls may result in connection throttling
>
>   Starting with ACI v3.1 the APIC will actively throttle password-based  authenticated connection rates over a specific threshold. This is as  part of an anti-DDOS measure but can act up when using Ansible with ACI  using password-based authentication. Currently, one solution is to  increase this threshold within the nginx configuration, but using  signature-based authentication is recommended. **NOTE:** It is advisable to use signature-based  authentication with ACI as it not only prevents connection-throttling,  but also improves general performance when using the ACI modules.
>
> - Specific requests may not reflect changes correctly ([#35401](https://github.com/ansible/ansible/issues/35041))
>
>   There is a known issue where specific requests to the APIC do not properly  reflect changed in the resulting output, even when we request those  changes explicitly from the APIC. In one instance using the path `api/node/mo/uni/infra.xml` fails, where `api/node/mo/uni/infra/.xml` does work correctly. **NOTE:** A workaround is to register the task return values (for example, `register: this`) and influence when the task should report a change by adding: `changed_when: this.imdata != []`.
>
> - Specific requests are known to not be idempotent ([#35050](https://github.com/ansible/ansible/issues/35050))
>
>   The behaviour of the APIC is inconsistent to the use of `status="created"` and `status="deleted"`. The result is that when you use `status="created"` in your payload the resulting tasks are not idempotent and creation  will fail when the object was already created. However this is not the  case with `status="deleted"` where such call to an non-existing object does not cause any failure whatsoever. **NOTE:** A workaround is to avoid using `status="created"` and instead use `status="modified"` when idempotency is essential to your workflow..
>
> - Setting user password is not idempotent ([#35544](https://github.com/ansible/ansible/issues/35544))
>
>   Due to an inconsistency in the APIC REST API, a task that sets the password of a locally-authenticated user is not idempotent. The APIC will  complain with message `Password history check: user dag should not use previous 5 passwords`. **NOTE:** There is no workaround for this issue.



## ACI Ansible community[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aci.html#aci-ansible-community)

If you have specific issues with the ACI modules, or a feature  request, or you like to contribute to the ACI project by proposing  changes or documentation updates, look at the Ansible Community wiki ACI page at: https://github.com/ansible/community/wiki/Network:-ACI

You will find our roadmap, an overview of open ACI issues and  pull-requests, and more information about who we are. If you have an  interest in using ACI with Ansible, feel free to join! We occasionally  meet online (on the #ansible-network chat channel, using Matrix at  ansible.im or using IRC at [irc.libera.chat](https://libera.chat/)) to track progress and prepare for new Ansible releases.

# Cisco Meraki Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#cisco-meraki-guide)

- [What is Cisco Meraki?](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#what-is-cisco-meraki)
  - [MS Switches](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#ms-switches)
  - [MX Firewalls](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#mx-firewalls)
  - [MR Wireless Access Points](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#mr-wireless-access-points)
- [Using the Meraki modules](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#using-the-meraki-modules)
- [Common Parameters](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#common-parameters)
- [Meraki Authentication](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#meraki-authentication)
- [Returned Data Structures](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#returned-data-structures)
- [Handling Returned Data](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#handling-returned-data)
- [Merging Existing and New Data](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#merging-existing-and-new-data)
- [Error Handling](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#error-handling)



## [What is Cisco Meraki?](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id1)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#what-is-cisco-meraki)

Cisco Meraki is an easy-to-use, cloud-based, network infrastructure  platform for enterprise environments. While most network hardware uses  command-line interfaces (CLIs) for configuration, Meraki uses an  easy-to-use Dashboard hosted in the Meraki cloud. No on-premises  management hardware or software is required - only the network  infrastructure to run your business.

### [MS Switches](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id2)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#ms-switches)

Meraki MS switches come in multiple flavors and form factors. Meraki  switches support 10/100/1000/10000 ports, as well as Cisco’s mGig  technology for 2.5/5/10Gbps copper connectivity. 8, 24, and 48 port  flavors are available with PoE (802.3af/802.3at/UPoE) available on many  models.

### [MX Firewalls](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id3)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#mx-firewalls)

Meraki’s MX firewalls support full layer 3-7 deep packet inspection.  MX firewalls are compatible with a variety of VPN technologies including IPSec, SSL VPN, and Meraki’s easy-to-use AutoVPN.

### [MR Wireless Access Points](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id4)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#mr-wireless-access-points)

MR access points are enterprise-class, high-performance access points for the enterprise. MR access points have MIMO technology and  integrated beamforming built-in for high performance applications. BLE  allows for advanced location applications to be developed with no  on-premises analytics platforms.

## [Using the Meraki modules](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id5)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#using-the-meraki-modules)

Meraki modules provide a user-friendly interface to manage your  Meraki environment using Ansible. For example, details about SNMP  settings for a particular organization can be discovered using the  module meraki_snmp <meraki_snmp_module>.

```
- name: Query SNMP settings
  meraki_snmp:
    api_key: abc123
    org_name: AcmeCorp
    state: query
  delegate_to: localhost
```

Information about a particular object can be queried. For example, the meraki_admin <meraki_admin_module> module supports

```
- name: Gather information about Jane Doe
  meraki_admin:
    api_key: abc123
    org_name: AcmeCorp
    state: query
    email: janedoe@email.com
  delegate_to: localhost
```

## [Common Parameters](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id6)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#common-parameters)

All Ansible Meraki modules support the following parameters which  affect communication with the Meraki Dashboard API. Most of these should only be used by Meraki developers and not the general public.

> - host
>
>   Hostname or IP of Meraki Dashboard.
>
> - use_https
>
>   Specifies whether communication should be over HTTPS. (Defaults to `yes`)
>
> - use_proxy
>
>   Whether to use a proxy for any communication.
>
> - validate_certs
>
>   Determine whether certificates should be validated or trusted. (Defaults to `yes`)

These are the common parameters which are used for most every module.

> - org_name
>
>   Name of organization to perform actions in.
>
> - org_id
>
>   ID of organization to perform actions in.
>
> - net_name
>
>   Name of network to perform actions in.
>
> - net_id
>
>   ID of network to perform actions in.
>
> - state
>
>   General specification of what action to take. `query` does lookups. `present` creates or edits. `absent` deletes.

Hint

Use the `org_id` and `net_id` parameters when possible. `org_name` and `net_name` require additional behind-the-scenes API calls to learn the ID values. `org_id` and `net_id` will perform faster.

## [Meraki Authentication](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id7)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#meraki-authentication)

All API access with the Meraki Dashboard requires an API key. An API  key can be generated from the organization’s settings page. Each play in a playbook requires the `api_key` parameter to be specified.

The “Vault” feature of Ansible allows you to keep sensitive data such as passwords or keys in encrypted files, rather than as plain text in  your playbooks or roles. These vault files can then be distributed or  placed in source control. See [Using encrypted variables and files](https://docs.ansible.com/ansible/latest/vault_guide/vault_using_encrypted_content.html#playbooks-vault) for more information.

Meraki’s API returns a 404 error if the API key is not correct. It  does not provide any specific error saying the key is incorrect. If you  receive a 404 error, check the API key first.

## [Returned Data Structures](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id8)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#returned-data-structures)

Meraki and its related Ansible modules return most information in the form of a list. For example, this is returned information by `meraki_admin` querying administrators. It returns a list even though there’s only one.

```
[
    {
        "orgAccess": "full",
        "name": "John Doe",
        "tags": [],
        "networks": [],
        "email": "john@doe.com",
        "id": "12345677890"
    }
]
```

## [Handling Returned Data](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id9)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#handling-returned-data)

Since Meraki’s response data uses lists instead of properly keyed  dictionaries for responses, certain strategies should be used when  querying data for particular information. For many situations, use the `selectattr()` Jinja2 function.

## [Merging Existing and New Data](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id10)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#merging-existing-and-new-data)

Ansible’s Meraki modules do not allow for manipulating data. For  example, you may need to insert a rule in the middle of a firewall  ruleset. Ansible and the Meraki modules lack a way to directly merge to  manipulate data. However, a playlist can use a few tasks to split the  list where you need to insert a rule and then merge them together again  with the new rule added. The steps involved are as follows:

1. - Create blank “front” and “back” lists.

     `vars:  - front_rules: []  - back_rules: [] `

2. - Get existing firewall rules from Meraki and create a new variable.

     `- name: Get firewall rules  meraki_mx_l3_firewall:    auth_key: abc123    org_name: YourOrg    net_name: YourNet    state: query  delegate_to: localhost  register: rules - set_fact:    original_ruleset: '{{rules.data}}' `

3. - Write the new rule. The new rule needs to be in a list so it can be merged with other lists in an upcoming step. The blank - puts the rule in a list so it can be merged.

     `- set_fact:    new_rule:      -        - comment: Block traffic to server          src_cidr: 192.0.1.0/24          src_port: any          dst_cidr: 192.0.1.2/32          dst_port: any          protocol: any          policy: deny `

4. - Split the rules into two lists. This assumes the existing ruleset is 2 rules long.

     `- set_fact:    front_rules: '{{front_rules + [ original_ruleset[:1] ]}}' - set_fact:    back_rules: '{{back_rules + [ original_ruleset[1:] ]}}' `

5. - Merge rules with the new rule in the middle.

     `- set_fact:    new_ruleset: '{{front_rules + new_rule + back_rules}}' `

6. - Upload new ruleset to Meraki.

     `- name: Set two firewall rules  meraki_mx_l3_firewall:    auth_key: abc123    org_name: YourOrg    net_name: YourNet    state: present    rules: '{{ new_ruleset }}'  delegate_to: localhost `

## [Error Handling](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#id11)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_meraki.html#error-handling)

Ansible’s Meraki modules will often fail if improper or incompatible  parameters are specified. However, there will likely be scenarios where  the module accepts the information but the Meraki API rejects the data.  If this happens, the error will be returned in the `body` field for HTTP status of 400 return code.

Meraki’s API returns a 404 error if the API key is not correct. It  does not provide any specific error saying the key is incorrect. If you  receive a 404 error, check the API key first. 404 errors can also occur  if improper object IDs (ex. `org_id`) are specified.

# [Infoblox Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id1)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#infoblox-guide)

Topics

- [Infoblox Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#infoblox-guide)
  - [Prerequisites](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#prerequisites)
  - [Credentials and authenticating](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#credentials-and-authenticating)
  - [NIOS lookup plugins](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#nios-lookup-plugins)
    - [Retrieving all network views](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#retrieving-all-network-views)
    - [Retrieving a host record](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#retrieving-a-host-record)
  - [Use cases with modules](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#use-cases-with-modules)
    - [Configuring an IPv4 network](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#configuring-an-ipv4-network)
    - [Creating a host record](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-host-record)
    - [Creating a forward DNS zone](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-forward-dns-zone)
    - [Creating a reverse DNS zone](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-reverse-dns-zone)
  - [Dynamic inventory script](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#dynamic-inventory-script)

This guide describes how to use Ansible with the Infoblox Network  Identity Operating System (NIOS). With Ansible integration, you can use  Ansible playbooks to automate Infoblox Core Network Services for IP  address management (IPAM), DNS, and inventory tracking.

You can review simple example tasks in the documentation for any of the [NIOS modules](https://docs.ansible.com/ansible/2.9/modules/list_of_net_tools_modules.html#nios-net-tools-modules) or look at the [Use cases with modules](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#use-cases-with-modules) section for more elaborate examples. See the [Infoblox](https://www.infoblox.com/) website for more information on the Infoblox product.

Note

You can retrieve most of the example playbooks used in this guide from the  [network-automation/infoblox_ansible](https://github.com/network-automation/infoblox_ansible) GitHub repository.

## [Prerequisites](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id2)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#prerequisites)

Before using Ansible `nios` modules with Infoblox, you must install the `infoblox-client` on your Ansible control node:

```
$ sudo pip install infoblox-client
```

Note

You need an NIOS account with the WAPI feature enabled to use Ansible with Infoblox.



## [Credentials and authenticating](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id3)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#credentials-and-authenticating)

To use Infoblox `nios` modules in playbooks, you need to configure the credentials to access  your Infoblox system.  The examples in this guide use credentials stored in `<playbookdir>/group_vars/nios.yml`. Replace these values with your Infoblox credentials:

```
---
nios_provider:
  host: 192.0.0.2
  username: admin
  password: ansible
```

## [NIOS lookup plugins](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id4)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#nios-lookup-plugins)

Ansible includes the following lookup plugins for NIOS:

- [nios](https://docs.ansible.com/ansible/2.9/plugins/lookup/nios.html#nios-lookup) Uses the Infoblox WAPI API to fetch NIOS specified objects, for example network views, DNS views, and host records.
- [nios_next_ip](https://docs.ansible.com/ansible/2.9/plugins/lookup/nios_next_ip.html#nios-next-ip-lookup) Provides the next available IP address from a network. You’ll see an example of this in [Creating a host record](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-host-record).
- [nios_next_network](https://docs.ansible.com/ansible/2.9/plugins/lookup/nios_next_network.html#nios-next-network-lookup) - Returns the next available network range for a network-container.

You must run the NIOS lookup plugins locally by specifying `connection: local`. See [lookup plugins](https://docs.ansible.com/ansible/latest/plugins/lookup.html#lookup-plugins) for more detail.

### [Retrieving all network views](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id5)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#retrieving-all-network-views)

To retrieve all network views and save them in a variable, use the [set_fact](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html#set-fact-module) module with the [nios](https://docs.ansible.com/ansible/2.9/plugins/lookup/nios.html#nios-lookup) lookup plugin:

```
---
- hosts: nios
  connection: local
  tasks:
    - name: fetch all networkview objects
      set_fact:
        networkviews: "{{ lookup('nios', 'networkview', provider=nios_provider) }}"

    - name: check the networkviews
      debug:
        var: networkviews
```

### [Retrieving a host record](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id6)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#retrieving-a-host-record)

To retrieve a set of host records, use the `set_fact` module with the `nios` lookup plugin and include a filter for the specific hosts you want to retrieve:

```
---
- hosts: nios
  connection: local
  tasks:
    - name: fetch host leaf01
      set_fact:
         host: "{{ lookup('nios', 'record:host', filter={'name': 'leaf01.ansible.com'}, provider=nios_provider) }}"

    - name: check the leaf01 return variable
      debug:
        var: host

    - name: debug specific variable (ipv4 address)
      debug:
        var: host.ipv4addrs[0].ipv4addr

    - name: fetch host leaf02
      set_fact:
        host: "{{ lookup('nios', 'record:host', filter={'name': 'leaf02.ansible.com'}, provider=nios_provider) }}"

    - name: check the leaf02 return variable
      debug:
        var: host
```

If you run this `get_host_record.yml` playbook, you should see results similar to the following:

```
$ ansible-playbook get_host_record.yml

PLAY [localhost] ***************************************************************************************

TASK [fetch host leaf01] ******************************************************************************
ok: [localhost]

TASK [check the leaf01 return variable] *************************************************************
ok: [localhost] => {
< ...output shortened...>
    "host": {
        "ipv4addrs": [
            {
                "configure_for_dhcp": false,
                "host": "leaf01.ansible.com",
            }
        ],
        "name": "leaf01.ansible.com",
        "view": "default"
    }
}

TASK [debug specific variable (ipv4 address)] ******************************************************
ok: [localhost] => {
    "host.ipv4addrs[0].ipv4addr": "192.168.1.11"
}

TASK [fetch host leaf02] ******************************************************************************
ok: [localhost]

TASK [check the leaf02 return variable] *************************************************************
ok: [localhost] => {
< ...output shortened...>
    "host": {
        "ipv4addrs": [
            {
                "configure_for_dhcp": false,
                "host": "leaf02.example.com",
                "ipv4addr": "192.168.1.12"
            }
        ],
    }
}

PLAY RECAP ******************************************************************************************
localhost                  : ok=5    changed=0    unreachable=0    failed=0
```

The output above shows the host record for `leaf01.ansible.com` and `leaf02.ansible.com` that were retrieved by the `nios` lookup plugin. This playbook saves the information in variables which  you can use in other playbooks. This allows you to use Infoblox as a  single source of truth to gather and use information that changes  dynamically. See [Using Variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#playbooks-variables) for more information on using Ansible variables. See the [nios](https://docs.ansible.com/ansible/2.9/plugins/lookup/nios.html#nios-lookup) examples for more data options that you can retrieve.

You can access these playbooks at [Infoblox lookup playbooks](https://github.com/network-automation/infoblox_ansible/tree/master/lookup_playbooks).

## [Use cases with modules](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id7)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#use-cases-with-modules)

You can use the `nios` modules in tasks to simplify common Infoblox workflows. Be sure to set up your [NIOS credentials](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#nios-credentials) before following these examples.

### [Configuring an IPv4 network](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id8)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#configuring-an-ipv4-network)

To configure an IPv4 network, use the [nios_network](https://docs.ansible.com/ansible/2.9/modules/nios_network_module.html#nios-network-module) module:

```
---
- hosts: nios
  connection: local
  tasks:
    - name: Create a network on the default network view
      nios_network:
        network: 192.168.100.0/24
        comment: sets the IPv4 network
        options:
          - name: domain-name
            value: ansible.com
        state: present
        provider: "{{nios_provider}}"
```

Notice the last parameter, `provider`, uses the variable `nios_provider` defined in the `group_vars/` directory.

### [Creating a host record](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id9)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-host-record)

To create a host record named leaf03.ansible.com on the newly-created IPv4 network:

```
---
- hosts: nios
  connection: local
  tasks:
    - name: configure an IPv4 host record
      nios_host_record:
        name: leaf03.ansible.com
        ipv4addrs:
          - ipv4addr:
              "{{ lookup('nios_next_ip', '192.168.100.0/24', provider=nios_provider)[0] }}"
        state: present
provider: "{{nios_provider}}"
```

Notice the IPv4 address in this example uses the [nios_next_ip](https://docs.ansible.com/ansible/2.9/plugins/lookup/nios_next_ip.html#nios-next-ip-lookup) lookup plugin to find the next available IPv4 address on the network.

### [Creating a forward DNS zone](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id10)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-forward-dns-zone)

To configure a forward DNS zone use, the `nios_zone` module:

```
---
- hosts: nios
  connection: local
  tasks:
    - name: Create a forward DNS zone called ansible-test.com
      nios_zone:
        name: ansible-test.com
        comment: local DNS zone
        state: present
        provider: "{{ nios_provider }}"
```

### [Creating a reverse DNS zone](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id11)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#creating-a-reverse-dns-zone)

To configure a reverse DNS zone:

```
---
- hosts: nios
  connection: local
  tasks:
    - name: configure a reverse mapping zone on the system using IPV6 zone format
      nios_zone:
        name: 100::1/128
        zone_format: IPV6
        state: present
        provider: "{{ nios_provider }}"
```

## [Dynamic inventory script](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#id12)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_infoblox.html#dynamic-inventory-script)

You can use the Infoblox dynamic inventory script to import your  network node inventory with Infoblox NIOS. To gather the inventory from  Infoblox, you need two files:

- [infoblox.yaml](https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/infoblox.yaml) - A file that specifies the NIOS provider arguments and optional filters.
- [infoblox.py](https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/infoblox.py) - The python script that retrieves the NIOS inventory.

Note

Please note that the inventory script only works when Ansible 2.9,  2.10 or 3 have been installed. The inventory script will eventually be  removed from [community.general](https://galaxy.ansible.com/community/general), and will not work if community.general is only installed with ansible-galaxy collection install. Please use the inventory plugin from [infoblox.nios_modules](https://galaxy.ansible.com/infoblox/nios_modules) instead.

To use the Infoblox dynamic inventory script:

1. Download the `infoblox.yaml` file and save it in the `/etc/ansible` directory.
2. Modify the `infoblox.yaml` file with your NIOS credentials.
3. Download the `infoblox.py` file and save it in the `/etc/ansible/hosts` directory.
4. Change the permissions on the `infoblox.py` file to make the file an executable:

```
$ sudo chmod +x /etc/ansible/hosts/infoblox.py
```

You can optionally use `./infoblox.py --list` to test the script. After a few minutes, you should see your Infoblox  inventory in JSON format. You can explicitly use the Infoblox dynamic  inventory script as follows:

```
$ ansible -i infoblox.py all -m ping
```

You can also implicitly use the Infoblox dynamic inventory script by including it in your inventory directory (`etc/ansible/hosts` by default). See [Working with dynamic inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_dynamic_inventory.html#dynamic-inventory) for more details.