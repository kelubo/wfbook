# Legacy Public Cloud Guides[](https://docs.ansible.com/ansible/latest/scenario_guides/cloud_guides.html#legacy-public-cloud-guides)

The legacy guides in this section may be out of date. They cover  using Ansible with a range of public cloud platforms. They explore  particular use cases in greater depth and provide a more “top-down”  explanation of some basic features.

Guides for using public clouds are moving into collections. We are  migrating these guides into collections. Please update your links for  the following guides:

# Alibaba Cloud Compute Services Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_alicloud.html#alibaba-cloud-compute-services-guide)



## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_alicloud.html#introduction)

Ansible contains several modules for controlling and managing Alibaba Cloud Compute Services (Alicloud).  This guide explains how to use the Alicloud Ansible modules together.

All Alicloud modules require `footmark` - install it on your control machine with `pip install footmark`.

Cloud modules, including Alicloud modules, execute on your local machine (the control machine) with `connection: local`, rather than on remote machines defined in your hosts.

Normally, you’ll use the following pattern for plays that provision Alicloud resources:

```
- hosts: localhost
  connection: local
  vars:
    - ...
  tasks:
    - ...
```



## Authentication[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_alicloud.html#authentication)

You can specify your Alicloud authentication credentials (access key and secret key) by passing them as environment variables or by storing them in a vars file.

To pass authentication credentials as environment variables:

```
export ALICLOUD_ACCESS_KEY='Alicloud123'
export ALICLOUD_SECRET_KEY='AlicloudSecret123'
```

To store authentication credentials in a vars_files, encrypt them with [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/vault.html#vault) to keep them secure, then list them:

```
---
alicloud_access_key: "--REMOVED--"
alicloud_secret_key: "--REMOVED--"
```

Note that if you store your credentials in a vars_files, you need to refer to them in each Alicloud module. For example:

```
- ali_instance:
    alicloud_access_key: "{{alicloud_access_key}}"
    alicloud_secret_key: "{{alicloud_secret_key}}"
    image_id: "..."
```



## Provisioning[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_alicloud.html#provisioning)

Alicloud modules create Alicloud ECS instances, disks, virtual  private clouds, virtual switches, security groups and other resources.

You can use the `count` parameter to control the number of resources you create or terminate. For example, if you want exactly 5 instances tagged `NewECS`, set the `count` of instances to 5 and the `count_tag` to `NewECS`, as shown in the last task of the example playbook below. If there are no instances with the tag `NewECS`, the task creates 5 new instances. If there are 2 instances with that tag, the task creates 3 more. If there are 8 instances with that tag, the task terminates 3 of those instances.

If you do not specify a `count_tag`, the task creates the number of instances you specify in `count` with the `instance_name` you provide.

```
# alicloud_setup.yml

- hosts: localhost
  connection: local

  tasks:

    - name: Create VPC
      ali_vpc:
        cidr_block: '{{ cidr_block }}'
        vpc_name: new_vpc
      register: created_vpc

    - name: Create VSwitch
      ali_vswitch:
        alicloud_zone: '{{ alicloud_zone }}'
        cidr_block: '{{ vsw_cidr }}'
        vswitch_name: new_vswitch
        vpc_id: '{{ created_vpc.vpc.id }}'
      register: created_vsw

    - name: Create security group
      ali_security_group:
        name: new_group
        vpc_id: '{{ created_vpc.vpc.id }}'
        rules:
          - proto: tcp
            port_range: 22/22
            cidr_ip: 0.0.0.0/0
            priority: 1
        rules_egress:
          - proto: tcp
            port_range: 80/80
            cidr_ip: 192.168.0.54/32
            priority: 1
      register: created_group

    - name: Create a set of instances
      ali_instance:
         security_groups: '{{ created_group.group_id }}'
         instance_type: ecs.n4.small
         image_id: "{{ ami_id }}"
         instance_name: "My-new-instance"
         instance_tags:
             Name: NewECS
             Version: 0.0.1
         count: 5
         count_tag:
             Name: NewECS
         allocate_public_ip: true
         max_bandwidth_out: 50
         vswitch_id: '{{ created_vsw.vswitch.id}}'
      register: create_instance
```

In the example playbook above, data about the vpc, vswitch, group, and instances created by this playbook are saved in the variables defined by the “register” keyword in each task.

Each Alicloud module offers a variety of parameter options. Not all options are demonstrated in the above example. See each individual module for further details and examples.

# CloudStack Cloud Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#cloudstack-cloud-guide)



## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#introduction)

The purpose of this section is to explain how to put Ansible modules  together to use Ansible in a CloudStack context. You will find more  usage examples in the details section of each module.

Ansible contains a number of extra modules for interacting with  CloudStack based clouds. All modules support check mode, are designed to be idempotent, have been created and tested, and are maintained by the  community.

Note

Some of the modules will require domain admin or root admin privileges.

## Prerequisites[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#prerequisites)

Prerequisites for using the CloudStack modules are minimal. In  addition to Ansible itself, all of the modules require the python  library `cs` https://pypi.org/project/cs/

You’ll need this Python module installed on the execution host, usually your workstation.

```
$ pip install cs
```

Or alternatively starting with Debian 9 and Ubuntu 16.04:

```
$ sudo apt install python-cs
```

Note

cs also includes a command line interface for ad hoc interaction with the CloudStack API, for example `$ cs listVirtualMachines state=Running`.

## Limitations and Known Issues[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#limitations-and-known-issues)

VPC support has been improved since Ansible 2.3 but is still not yet  fully implemented. The community is working on the VPC integration.

## Credentials File[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#credentials-file)

You can pass credentials and the endpoint of your cloud as module  arguments, however in most cases it is a far less work to store your  credentials in the cloudstack.ini file.

The python library cs looks for the credentials file in the following order (last one wins):

- A `.cloudstack.ini` (note the dot) file in the home directory.
- A `CLOUDSTACK_CONFIG` environment variable pointing to an .ini file.
- A `cloudstack.ini` (without the dot) file in the current working directory, same directory as your playbooks are located.

The structure of the ini file must look like this:

```
$ cat $HOME/.cloudstack.ini
[cloudstack]
endpoint = https://cloud.example.com/client/api
key = api key
secret = api secret
timeout = 30
```

Note

The section `[cloudstack]` is the default section. `CLOUDSTACK_REGION` environment variable can be used to define the default section.

New in version 2.4.

The ENV variables support `CLOUDSTACK_*` as written in the documentation of the library `cs`, like `CLOUDSTACK_TIMEOUT`, `CLOUDSTACK_METHOD`, and so on. has been implemented into Ansible. It is even possible to have some incomplete config in your cloudstack.ini:

```
$ cat $HOME/.cloudstack.ini
[cloudstack]
endpoint = https://cloud.example.com/client/api
timeout = 30
```

and fulfill the missing data by either setting ENV variables or tasks params:

```
---
- name: provision our VMs
  hosts: cloud-vm
  tasks:
    - name: ensure VMs are created and running
      delegate_to: localhost
      cs_instance:
        api_key: your api key
        api_secret: your api secret
        ...
```

## Regions[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#regions)

If you use more than one CloudStack region, you can define as many sections as you want and name them as you like, for example:

```
$ cat $HOME/.cloudstack.ini
[exoscale]
endpoint = https://api.exoscale.ch/compute
key = api key
secret = api secret

[example_cloud_one]
endpoint = https://cloud-one.example.com/client/api
key = api key
secret = api secret

[example_cloud_two]
endpoint = https://cloud-two.example.com/client/api
key = api key
secret = api secret
```

Hint

Sections can also be used to for login into the same region using different accounts.

By passing the argument `api_region` with the CloudStack modules, the region wanted will be selected.

```
- name: ensure my ssh public key exists on Exoscale
  cs_sshkeypair:
    name: my-ssh-key
    public_key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
    api_region: exoscale
  delegate_to: localhost
```

Or by looping over a regions list if you want to do the task in every region:

```
- name: ensure my ssh public key exists in all CloudStack regions
  local_action: cs_sshkeypair
    name: my-ssh-key
    public_key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
    api_region: "{{ item }}"
    loop:
      - exoscale
      - example_cloud_one
      - example_cloud_two
```

## Environment Variables[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#environment-variables)

New in version 2.3.

Since Ansible 2.3 it is possible to use environment variables for domain (`CLOUDSTACK_DOMAIN`), account (`CLOUDSTACK_ACCOUNT`), project (`CLOUDSTACK_PROJECT`), VPC (`CLOUDSTACK_VPC`) and zone (`CLOUDSTACK_ZONE`). This simplifies the tasks by not repeating the arguments for every tasks.

Below you see an example how it can be used in combination with Ansible’s block feature:

```
- hosts: cloud-vm
  tasks:
    - block:
        - name: ensure my ssh public key
          cs_sshkeypair:
            name: my-ssh-key
            public_key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"

        - name: ensure my ssh public key
          cs_instance:
              display_name: "{{ inventory_hostname_short }}"
              template: Linux Debian 7 64-bit 20GB Disk
              service_offering: "{{ cs_offering }}"
              ssh_key: my-ssh-key
              state: running

      delegate_to: localhost
      environment:
        CLOUDSTACK_DOMAIN: root/customers
        CLOUDSTACK_PROJECT: web-app
        CLOUDSTACK_ZONE: sf-1
```

Note

You are still able overwrite the environment variables using the module arguments, for example `zone: sf-2`

Note

Unlike `CLOUDSTACK_REGION` these additional environment variables are ignored in the CLI `cs`.

## Use Cases[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#use-cases)

The following should give you some ideas how to use the modules to  provision VMs to the cloud. As always, there isn’t only one way to do  it. But as always: keep it simple for the beginning is always a good  start.

### Use Case: Provisioning in a Advanced Networking CloudStack setup[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#use-case-provisioning-in-a-advanced-networking-cloudstack-setup)

Our CloudStack cloud has an advanced networking setup, we would like  to provision web servers, which get a static NAT and open firewall ports 80 and 443. Further we provision database servers, to which we do not  give any access to. For accessing the VMs by SSH we use a SSH jump host.

This is how our inventory looks like:

```
[cloud-vm:children]
webserver
db-server
jumphost

[webserver]
web-01.example.com  public_ip=198.51.100.20
web-02.example.com  public_ip=198.51.100.21

[db-server]
db-01.example.com
db-02.example.com

[jumphost]
jump.example.com  public_ip=198.51.100.22
```

As you can see, the public IPs for our web servers and jumphost has been assigned as variable `public_ip` directly in the inventory.

The configure the jumphost, web servers and database servers, we use `group_vars`. The `group_vars` directory contains 4 files for configuration of the groups: cloud-vm,  jumphost, webserver and db-server. The cloud-vm is there for specifying  the defaults of our cloud infrastructure.

```
# file: group_vars/cloud-vm
---
cs_offering: Small
cs_firewall: []
```

Our database servers should get more CPU and RAM, so we define to use a `Large` offering for them.

```
# file: group_vars/db-server
---
cs_offering: Large
```

The web servers should get a `Small` offering as we would scale them horizontally, which is also our default offering. We also ensure the known web ports are opened for the world.

```
# file: group_vars/webserver
---
cs_firewall:
  - { port: 80 }
  - { port: 443 }
```

Further we provision a jump host which has only port 22 opened for accessing the VMs from our office IPv4 network.

```
# file: group_vars/jumphost
---
cs_firewall:
  - { port: 22, cidr: "17.17.17.0/24" }
```

Now to the fun part. We create a playbook to create our infrastructure we call it `infra.yml`:

```
# file: infra.yaml
---
- name: provision our VMs
  hosts: cloud-vm
  tasks:
    - name: run all enclosed tasks from localhost
      delegate_to: localhost
      block:
        - name: ensure VMs are created and running
          cs_instance:
            name: "{{ inventory_hostname_short }}"
            template: Linux Debian 7 64-bit 20GB Disk
            service_offering: "{{ cs_offering }}"
            state: running

        - name: ensure firewall ports opened
          cs_firewall:
            ip_address: "{{ public_ip }}"
            port: "{{ item.port }}"
            cidr: "{{ item.cidr | default('0.0.0.0/0') }}"
          loop: "{{ cs_firewall }}"
          when: public_ip is defined

        - name: ensure static NATs
          cs_staticnat: vm="{{ inventory_hostname_short }}" ip_address="{{ public_ip }}"
          when: public_ip is defined
```

In the above play we defined 3 tasks and use the group `cloud-vm` as target to handle all VMs in the cloud but instead SSH to these VMs, we use `delegate_to: localhost` to execute the API calls locally from our workstation.

In the first task, we ensure we have a running VM created with the  Debian template. If the VM is already created but stopped, it would just start it. If you like to change the offering on an existing VM, you  must add `force: yes` to the task, which would stop the VM, change the offering and start the VM again.

In the second task we ensure the ports are opened if we give a public IP to the VM.

In the third task we add static NAT to the VMs having a public IP defined.

Note

The public IP addresses must have been acquired in advance, also see `cs_ip_address`

Note

For some modules, for example `cs_sshkeypair` you usually want this to be executed only once, not for every VM.  Therefore you would make a separate play for it targeting localhost. You find an example in the use cases below.

### Use Case: Provisioning on a Basic Networking CloudStack setup[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_cloudstack.html#use-case-provisioning-on-a-basic-networking-cloudstack-setup)

A basic networking CloudStack setup is slightly different: Every VM  gets a public IP directly assigned and security groups are used for  access restriction policy.

This is how our inventory looks like:

```
[cloud-vm:children]
webserver

[webserver]
web-01.example.com
web-02.example.com
```

The default for your VMs looks like this:

```
# file: group_vars/cloud-vm
---
cs_offering: Small
cs_securitygroups: [ 'default']
```

Our webserver will also be in security group `web`:

```
# file: group_vars/webserver
---
cs_securitygroups: [ 'default', 'web' ]
```

The playbook looks like the following:

```
# file: infra.yaml
---
- name: cloud base setup
  hosts: localhost
  tasks:
  - name: upload ssh public key
    cs_sshkeypair:
      name: defaultkey
      public_key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"

  - name: ensure security groups exist
    cs_securitygroup:
      name: "{{ item }}"
    loop:
      - default
      - web

  - name: add inbound SSH to security group default
    cs_securitygroup_rule:
      security_group: default
      start_port: "{{ item }}"
      end_port: "{{ item }}"
    loop:
      - 22

  - name: add inbound TCP rules to security group web
    cs_securitygroup_rule:
      security_group: web
      start_port: "{{ item }}"
      end_port: "{{ item }}"
    loop:
      - 80
      - 443

- name: install VMs in the cloud
  hosts: cloud-vm
  tasks:
  - delegate_to: localhost
    block:
    - name: create and run VMs on CloudStack
      cs_instance:
        name: "{{ inventory_hostname_short }}"
        template: Linux Debian 7 64-bit 20GB Disk
        service_offering: "{{ cs_offering }}"
        security_groups: "{{ cs_securitygroups }}"
        ssh_key: defaultkey
        state: Running
      register: vm

    - name: show VM IP
      debug: msg="VM {{ inventory_hostname }} {{ vm.default_ip }}"

    - name: assign IP to the inventory
      set_fact: ansible_ssh_host={{ vm.default_ip }}

    - name: waiting for SSH to come up
      wait_for: port=22 host={{ vm.default_ip }} delay=5
```

In the first play we setup the security groups, in the second play  the VMs will created be assigned to these groups. Further you see, that  we assign the public IP returned from the modules to the host inventory. This is needed as we do not know the IPs we will get in advance. In a  next step you would configure the DNS servers with these IPs for  accessing the VMs with their DNS name.

In the last task we wait for SSH to be accessible, so any later play would be able to access the VM by SSH without failure.

# Google Cloud Platform Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#google-cloud-platform-guide)

## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#introduction)

Ansible + Google have been working together on a set of auto-generated Ansible modules designed to consistently and comprehensively cover the entirety of the Google Cloud Platform (GCP).

Ansible contains modules for managing Google Cloud Platform resources, including creating instances, controlling network access, working with persistent disks, managing load balancers, and a lot more.

These new modules can be found under a new consistent name scheme “gcp_*” (Note: gcp_target_proxy and gcp_url_map are legacy modules, despite the “gcp_*” name. Please use gcp_compute_target_proxy and gcp_compute_url_map instead).

Additionally, the gcp_compute inventory plugin can discover all Google Compute Engine (GCE) instances and make them automatically available in your Ansible inventory.

You may see a collection of other GCP modules that do not conform to this naming convention. These are the original modules primarily developed by the Ansible community. You will find some overlapping functionality such as with the “gce” module and the new “gcp_compute_instance” module. Either can be used, but you may experience issues trying to use them together.

While the community GCP modules are not going away, Google is investing effort into the new “gcp_*” modules. Google is committed to ensuring the Ansible community has a great experience with GCP and therefore recommends adopting these new modules if possible.

## Requisites[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#requisites)

The GCP modules require both the `requests` and the `google-auth` libraries to be installed.

```
$ pip install requests google-auth
```

Alternatively for RHEL / CentOS, the `python-requests` package is also available to satisfy `requests` libraries.

```
$ yum install python-requests
```

## Credentials[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#credentials)

It’s easy to create a GCP account with credentials for Ansible. You have multiple options to get your credentials - here are two of the most common options:

- Service Accounts (Recommended): Use JSON service accounts with specific permissions.
- Machine Accounts: Use the permissions associated with the GCP Instance you’re using Ansible on.

For the following examples, we’ll be using service account credentials.

To work with the GCP modules, you’ll first need to get some credentials in the JSON format:

1. [Create a Service Account](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount)
2. [Download JSON credentials](https://support.google.com/cloud/answer/6158849?hl=en&ref_topic=6262490#serviceaccounts)

Once you have your credentials, there are two different ways to provide them to Ansible:

- by specifying them directly as module parameters
- by setting environment variables

### Providing Credentials as Module Parameters[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#providing-credentials-as-module-parameters)

For the GCE modules you can specify the credentials as arguments:

- `auth_kind`: type of authentication being used (choices: machineaccount, serviceaccount, application)
- `service_account_email`: email associated with the project
- `service_account_file`: path to the JSON credentials file
- `project`: id of the project
- `scopes`: The specific scopes that you want the actions to use.

For example, to create a new IP address using the `gcp_compute_address` module, you can use the following configuration:

```
- name: Create IP address
  hosts: localhost
  gather_facts: false

  vars:
    service_account_file: /home/my_account.json
    project: my-project
    auth_kind: serviceaccount
    scopes:
      - https://www.googleapis.com/auth/compute

  tasks:

   - name: Allocate an IP Address
     gcp_compute_address:
         state: present
         name: 'test-address1'
         region: 'us-west1'
         project: "{{ project }}"
         auth_kind: "{{ auth_kind }}"
         service_account_file: "{{ service_account_file }}"
         scopes: "{{ scopes }}"
```

### Providing Credentials as Environment Variables[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#providing-credentials-as-environment-variables)

Set the following environment variables before running Ansible in order to configure your credentials:

```
GCP_AUTH_KIND
GCP_SERVICE_ACCOUNT_EMAIL
GCP_SERVICE_ACCOUNT_FILE
GCP_SCOPES
```

## GCE Dynamic Inventory[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#gce-dynamic-inventory)

The best way to interact with your hosts is to use the gcp_compute  inventory plugin, which dynamically queries GCE and tells Ansible what  nodes can be managed.

To be able to use this GCE dynamic inventory plugin, you need to enable it first by specifying the following in the `ansible.cfg` file:

```
[inventory]
enable_plugins = gcp_compute
```

Then, create a file that ends in `.gcp.yml` in your root directory.

The gcp_compute inventory script takes in the same authentication information as any module.

Here’s an example of a valid inventory file:

```
plugin: gcp_compute
projects:
  - graphite-playground
auth_kind: serviceaccount
service_account_file: /home/alexstephen/my_account.json
```

Executing `ansible-inventory --list -i <filename>.gcp.yml` will create a list of GCP instances that are ready to be configured using Ansible.

### Create an instance[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#create-an-instance)

The full range of GCP modules provide the ability to create a wide variety of GCP resources with the full support of the entire GCP API.

The following playbook creates a GCE Instance. This instance relies on other GCP resources like Disk. By creating other resources separately, we can give as much detail as necessary about how we want to configure the other resources, for example formatting of the Disk. By registering it to a variable, we can simply insert the variable into the instance task. The gcp_compute_instance module will figure out the rest.

```
- name: Create an instance
  hosts: localhost
  gather_facts: false
  vars:
      gcp_project: my-project
      gcp_cred_kind: serviceaccount
      gcp_cred_file: /home/my_account.json
      zone: "us-central1-a"
      region: "us-central1"

  tasks:
   - name: create a disk
     gcp_compute_disk:
         name: 'disk-instance'
         size_gb: 50
         source_image: 'projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts'
         zone: "{{ zone }}"
         project: "{{ gcp_project }}"
         auth_kind: "{{ gcp_cred_kind }}"
         service_account_file: "{{ gcp_cred_file }}"
         scopes:
           - https://www.googleapis.com/auth/compute
         state: present
     register: disk
   - name: create a address
     gcp_compute_address:
         name: 'address-instance'
         region: "{{ region }}"
         project: "{{ gcp_project }}"
         auth_kind: "{{ gcp_cred_kind }}"
         service_account_file: "{{ gcp_cred_file }}"
         scopes:
           - https://www.googleapis.com/auth/compute
         state: present
     register: address
   - name: create a instance
     gcp_compute_instance:
         state: present
         name: test-vm
         machine_type: n1-standard-1
         disks:
           - auto_delete: true
             boot: true
             source: "{{ disk }}"
         network_interfaces:
             - network: null # use default
               access_configs:
                 - name: 'External NAT'
                   nat_ip: "{{ address }}"
                   type: 'ONE_TO_ONE_NAT'
         zone: "{{ zone }}"
         project: "{{ gcp_project }}"
         auth_kind: "{{ gcp_cred_kind }}"
         service_account_file: "{{ gcp_cred_file }}"
         scopes:
           - https://www.googleapis.com/auth/compute
     register: instance

   - name: Wait for SSH to come up
     wait_for: host={{ address.address }} port=22 delay=10 timeout=60

   - name: Add host to groupname
     add_host: hostname={{ address.address }} groupname=new_instances


- name: Manage new instances
  hosts: new_instances
  connection: ssh
  become: True
  roles:
    - base_configuration
    - production_server
```

Note that use of the “add_host” module above creates a temporary,  in-memory group.  This means that a play in the same playbook can then  manage machines in the ‘new_instances’ group, if so desired.  Any sort of arbitrary  configuration is possible at this point.

For more information about Google Cloud, please visit the [Google Cloud website](https://cloud.google.com).

## Migration Guides[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#migration-guides)

### gce.py -> gcp_compute_instance.py[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html#gce-py-gcp-compute-instance-py)

As of Ansible 2.8, we’re encouraging everyone to move from the `gce` module to the `gcp_compute_instance` module. The `gcp_compute_instance` module has better support for all of GCP’s features, fewer dependencies, more flexibility, and better supports GCP’s authentication systems.

The `gcp_compute_instance` module supports all of the features of the `gce` module (and more!). Below is a mapping of `gce` fields over to `gcp_compute_instance` fields.

| gce.py                      | gcp_compute_instance.py                    | Notes                                                        |
| --------------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| state                       | state/status                               | State on gce has multiple values: “present”, “absent”, “stopped”, “started”, “terminated”. State on gcp_compute_instance is used to  describe if the instance exists (present) or does not (absent). Status  is used to describe if the instance is “started”, “stopped” or  “terminated”. |
| image                       | disks[].initialize_params.source_image     | You’ll need to create a single disk using the disks[] parameter and set it to be the boot disk (disks[].boot = true) |
| image_family                | disks[].initialize_params.source_image     | See above.                                                   |
| external_projects           | disks[].initialize_params.source_image     | The name of the source_image will include the name of the project. |
| instance_names              | Use a loop or multiple tasks.              | Using loops is a more Ansible-centric way of creating multiple instances and gives you the most flexibility. |
| service_account_email       | service_accounts[].email                   | This is the service_account email address that you want the  instance to be associated with. It is not the service_account email  address that is used for the credentials necessary to create the  instance. |
| service_account_permissions | service_accounts[].scopes                  | These are the permissions you want to grant to the instance. |
| pem_file                    | Not supported.                             | We recommend using JSON service account credentials instead of PEM files. |
| credentials_file            | service_account_file                       |                                                              |
| project_id                  | project                                    |                                                              |
| name                        | name                                       | This field does not accept an array of names. Use a loop to create multiple instances. |
| num_instances               | Use a loop                                 | For maximum flexibility, we’re encouraging users to use Ansible  features to create multiple instances, rather than letting the module do it for you. |
| network                     | network_interfaces[].network               |                                                              |
| subnetwork                  | network_interfaces[].subnetwork            |                                                              |
| persistent_boot_disk        | disks[].type = ‘PERSISTENT’                |                                                              |
| disks                       | disks[]                                    |                                                              |
| ip_forward                  | can_ip_forward                             |                                                              |
| external_ip                 | network_interfaces[].access_configs.nat_ip | This field takes multiple types of values. You can create an IP address with `gcp_compute_address` and place the name/output of the address here. You can also place the  string value of the IP address’s GCP name or the actual IP address. |
| disks_auto_delete           | disks[].auto_delete                        |                                                              |
| preemptible                 | scheduling.preemptible                     |                                                              |
| disk_size                   | disks[].initialize_params.disk_size_gb     |                                                              |

An example playbook is below:

```
gcp_compute_instance:
    name: "{{ item }}"
    machine_type: n1-standard-1
    ... # any other settings
    zone: us-central1-a
    project: "my-project"
    auth_kind: "service_account_file"
    service_account_file: "~/my_account.json"
    state: present
loop:
  - instance-1
  - instance-2
```

# Microsoft Azure Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#microsoft-azure-guide)

Important

Red Hat Ansible Automation Platform will soon be available on Microsoft Azure. [Sign up to preview the experience](https://www.redhat.com/en/engage/ansible-microsoft-azure-e-202110220735).

Ansible includes a suite of modules for interacting with Azure Resource Manager, giving you the tools to easily create and orchestrate infrastructure on the Microsoft Azure Cloud.

## Requirements[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#requirements)

Using the Azure Resource Manager modules requires having specific Azure SDK modules installed on the host running Ansible.

```
$ pip install 'ansible[azure]'
```

If you are running Ansible from source, you can install the dependencies from the root directory of the Ansible repo.

```
$ pip install .[azure]
```

You can also directly run Ansible in [Azure Cloud Shell](https://shell.azure.com), where Ansible is pre-installed.

## Authenticating with Azure[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#authenticating-with-azure)

Using the Azure Resource Manager modules requires authenticating with the Azure API. You can choose from two authentication strategies:

- Active Directory Username/Password
- Service Principal Credentials

Follow the directions for the strategy you wish to use, then proceed to [Providing Credentials to Azure Modules](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#providing-credentials-to-azure-modules) for instructions on how to actually use the modules and authenticate with the Azure API.

### Using Service Principal[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#using-service-principal)

There is now a detailed official tutorial describing [how to create a service principal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-create-service-principal-portal).

After stepping through the tutorial you will have:

- Your Client ID, which is found in the “client id” box in the “Configure” page of your application in the Azure portal
- Your Secret key, generated when you created the application. You cannot show the key after creation. If you lost the key, you must create a new one in the “Configure” page of your application.
- And finally, a tenant ID. It’s a UUID (for example, ABCDEFGH-1234-ABCD-1234-ABCDEFGHIJKL) pointing to the AD containing your application. You will find it in the URL from within the Azure portal, or in the “view endpoints” of any given URL.

### Using Active Directory Username/Password[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#using-active-directory-username-password)

To create an Active Directory username/password:

- Connect to the Azure Classic Portal with your admin account
- Create a user in your default AAD. You must NOT activate Multi-Factor Authentication
- Go to Settings - Administrators
- Click on Add and enter the email of the new user.
- Check the checkbox of the subscription you want to test with this user.
- Login to Azure Portal with this new user to change the temporary password to a new one. You will not be able to use the temporary password for OAuth login.

### Providing Credentials to Azure Modules[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#providing-credentials-to-azure-modules)

The modules offer several ways to provide your credentials. For a CI/CD tool such as Ansible AWX or Jenkins, you will most likely want to use environment variables. For local development you may wish to store your credentials in a file within your home directory. And of course, you can always pass credentials as parameters to a task within a playbook. The order of precedence is parameters, then environment variables, and finally a file found in your home directory.

#### Using Environment Variables[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#using-environment-variables)

To pass service principal credentials through the environment, define the following variables:

- AZURE_CLIENT_ID
- AZURE_SECRET
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT

To pass Active Directory username/password through the environment, define the following variables:

- AZURE_AD_USER
- AZURE_PASSWORD
- AZURE_SUBSCRIPTION_ID

To pass Active Directory username/password in ADFS through the environment, define the following variables:

- AZURE_AD_USER
- AZURE_PASSWORD
- AZURE_CLIENT_ID
- AZURE_TENANT
- AZURE_ADFS_AUTHORITY_URL

“AZURE_ADFS_AUTHORITY_URL” is optional. It’s necessary only when you have own ADFS authority like https://yourdomain.com/adfs.

#### Storing in a File[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#storing-in-a-file)

When working in a development environment, it may be desirable to store credentials in a file. The modules will look for credentials in `$HOME/.azure/credentials`. This file is an ini style file. It will look as follows:

```
[default]
subscription_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
client_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
secret=xxxxxxxxxxxxxxxxx
tenant=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Note

If your secret values contain non-ASCII characters, you must [URL Encode](https://www.w3schools.com/tags/ref_urlencode.asp) them to avoid login errors.

It is possible to store multiple sets of credentials within the credentials file by creating multiple sections. Each section is considered a profile. The modules look for the [default] profile automatically. Define AZURE_PROFILE in the environment or pass a profile parameter to specify a specific profile.

#### Passing as Parameters[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#passing-as-parameters)

If you wish to pass credentials as parameters to a task, use the following parameters for service principal:

- client_id
- secret
- subscription_id
- tenant

Or, pass the following parameters for Active Directory username/password:

- ad_user
- password
- subscription_id

Or, pass the following parameters for ADFS username/password:

- ad_user
- password
- client_id
- tenant
- adfs_authority_url

“adfs_authority_url” is optional. It’s necessary only when you have own ADFS authority like https://yourdomain.com/adfs.

## Other Cloud Environments[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#other-cloud-environments)

To use an Azure Cloud other than the default public cloud (for  example, Azure China Cloud, Azure US Government Cloud, Azure Stack), pass the “cloud_environment” argument to modules, configure it in a  credential profile, or set the “AZURE_CLOUD_ENVIRONMENT” environment variable. The value is either a cloud name as defined by the Azure Python SDK (for example, “AzureChinaCloud”, “AzureUSGovernment”; defaults to “AzureCloud”) or an Azure metadata  discovery URL (for Azure Stack).

## Creating Virtual Machines[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#creating-virtual-machines)

There are two ways to create a virtual machine, both involving the azure_rm_virtualmachine module. We can either create a storage account, network interface, security group and public IP address and pass the names of these objects to the module as parameters, or we can let the module do the work for us and accept the defaults it chooses.

### Creating Individual Components[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#creating-individual-components)

An Azure module is available to help you create a storage account, virtual network, subnet, network interface, security group and public IP. Here is a full example of creating each of these and passing the names to the `azure.azcollection.azure_rm_virtualmachine` module at the end:

```
- name: Create storage account
  azure.azcollection.azure_rm_storageaccount:
    resource_group: Testing
    name: testaccount001
    account_type: Standard_LRS

- name: Create virtual network
  azure.azcollection.azure_rm_virtualnetwork:
    resource_group: Testing
    name: testvn001
    address_prefixes: "10.10.0.0/16"

- name: Add subnet
  azure.azcollection.azure_rm_subnet:
    resource_group: Testing
    name: subnet001
    address_prefix: "10.10.0.0/24"
    virtual_network: testvn001

- name: Create public ip
  azure.azcollection.azure_rm_publicipaddress:
    resource_group: Testing
    allocation_method: Static
    name: publicip001

- name: Create security group that allows SSH
  azure.azcollection.azure_rm_securitygroup:
    resource_group: Testing
    name: secgroup001
    rules:
      - name: SSH
        protocol: Tcp
        destination_port_range: 22
        access: Allow
        priority: 101
        direction: Inbound

- name: Create NIC
  azure.azcollection.azure_rm_networkinterface:
    resource_group: Testing
    name: testnic001
    virtual_network: testvn001
    subnet: subnet001
    public_ip_name: publicip001
    security_group: secgroup001

- name: Create virtual machine
  azure.azcollection.azure_rm_virtualmachine:
    resource_group: Testing
    name: testvm001
    vm_size: Standard_D1
    storage_account: testaccount001
    storage_container: testvm001
    storage_blob: testvm001.vhd
    admin_username: admin
    admin_password: Password!
    network_interfaces: testnic001
    image:
      offer: CentOS
      publisher: OpenLogic
      sku: '7.1'
      version: latest
```

Each of the Azure modules offers a variety of parameter options. Not all options are demonstrated in the above example. See each individual module for further details and examples.

### Creating a Virtual Machine with Default Options[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#creating-a-virtual-machine-with-default-options)

If you simply want to create a virtual machine without specifying all the details, you can do that as well. The only caveat is that you will need a virtual network with one subnet already in your resource group. Assuming you have a virtual network already with an existing subnet, you can run the following to create a VM:

```
azure.azcollection.azure_rm_virtualmachine:
  resource_group: Testing
  name: testvm10
  vm_size: Standard_D1
  admin_username: chouseknecht
  ssh_password_enabled: false
  ssh_public_keys: "{{ ssh_keys }}"
  image:
    offer: CentOS
    publisher: OpenLogic
    sku: '7.1'
    version: latest
```

### Creating a Virtual Machine in Availability Zones[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#creating-a-virtual-machine-in-availability-zones)

If you want to create a VM in an availability zone, consider the following:

- Both OS disk and data disk must be a ‘managed disk’, not an ‘unmanaged disk’.
- When creating a VM with the `azure.azcollection.azure_rm_virtualmachine` module, you need to explicitly set the `managed_disk_type` parameter to change the OS disk to a managed disk. Otherwise, the OS disk becomes an unmanaged disk.
- When you create a data disk with the `azure.azcollection.azure_rm_manageddisk` module, you need to explicitly specify the `storage_account_type` parameter to make it a managed disk. Otherwise, the data disk will be an unmanaged disk.
- A managed disk does not require a storage account or a storage container, unlike an unmanaged disk. In particular, note that once a VM is created on an unmanaged disk, an unnecessary storage container named “vhds” is automatically created.
- When you create an IP address with the `azure.azcollection.azure_rm_publicipaddress` module, you must set the  `sku` parameter to `standard`. Otherwise, the IP address cannot be used in an availability zone.

## Dynamic Inventory Script[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#dynamic-inventory-script)

If you are not familiar with Ansible’s dynamic inventory scripts, check out [Intro to Dynamic Inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_dynamic_inventory.html#intro-dynamic-inventory).

The Azure Resource Manager inventory script is called  [azure_rm.py](https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/azure_rm.py). It authenticates with the Azure API exactly the same as the Azure modules, which means you will either define the same environment variables described above in [Using Environment Variables](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#using-environment-variables), create a `$HOME/.azure/credentials` file (also described above in [Storing in a File](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#storing-in-a-file)), or pass command line parameters. To see available command line options execute the following:

```
$ wget https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/azure_rm.py
$ ./azure_rm.py --help
```

As with all dynamic inventory scripts, the script can be executed directly, passed as a parameter to the ansible command, or passed directly to ansible-playbook using the -i option. No matter how it is executed the script produces JSON representing all of the hosts found in your Azure subscription. You can narrow this down to just hosts found in a specific set of Azure resource groups, or even down to a specific host.

For a given host, the inventory script provides the following host variables:

```
{
  "ansible_host": "XXX.XXX.XXX.XXX",
  "computer_name": "computer_name2",
  "fqdn": null,
  "id": "/subscriptions/subscription-id/resourceGroups/galaxy-production/providers/Microsoft.Compute/virtualMachines/object-name",
  "image": {
    "offer": "CentOS",
    "publisher": "OpenLogic",
    "sku": "7.1",
    "version": "latest"
  },
  "location": "westus",
  "mac_address": "00-00-5E-00-53-FE",
  "name": "object-name",
  "network_interface": "interface-name",
  "network_interface_id": "/subscriptions/subscription-id/resourceGroups/galaxy-production/providers/Microsoft.Network/networkInterfaces/object-name1",
  "network_security_group": null,
  "network_security_group_id": null,
  "os_disk": {
    "name": "object-name",
    "operating_system_type": "Linux"
  },
  "plan": null,
  "powerstate": "running",
  "private_ip": "172.26.3.6",
  "private_ip_alloc_method": "Static",
  "provisioning_state": "Succeeded",
  "public_ip": "XXX.XXX.XXX.XXX",
  "public_ip_alloc_method": "Static",
  "public_ip_id": "/subscriptions/subscription-id/resourceGroups/galaxy-production/providers/Microsoft.Network/publicIPAddresses/object-name",
  "public_ip_name": "object-name",
  "resource_group": "galaxy-production",
  "security_group": "object-name",
  "security_group_id": "/subscriptions/subscription-id/resourceGroups/galaxy-production/providers/Microsoft.Network/networkSecurityGroups/object-name",
  "tags": {
    "db": "mysql"
  },
  "type": "Microsoft.Compute/virtualMachines",
  "virtual_machine_size": "Standard_DS4"
}
```

### Host Groups[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#host-groups)

By default hosts are grouped by:

- azure (all hosts)
- location name
- resource group name
- security group name
- tag key
- tag key_value
- os_disk operating_system_type (Windows/Linux)

You can control host groupings and host selection by either defining environment variables or creating an azure_rm.ini file in your current working directory.

NOTE: An .ini file will take precedence over environment variables.

NOTE: The name of the .ini file is the basename of the inventory script (in other words, ‘azure_rm’) with a ‘.ini’ extension. This allows you to copy, rename and customize the inventory script and have matching .ini files all in the same directory.

Control grouping using the following variables defined in the environment:

- AZURE_GROUP_BY_RESOURCE_GROUP=yes
- AZURE_GROUP_BY_LOCATION=yes
- AZURE_GROUP_BY_SECURITY_GROUP=yes
- AZURE_GROUP_BY_TAG=yes
- AZURE_GROUP_BY_OS_FAMILY=yes

Select hosts within specific resource groups by assigning a comma separated list to:

- AZURE_RESOURCE_GROUPS=resource_group_a,resource_group_b

Select hosts for specific tag key by assigning a comma separated list of tag keys to:

- AZURE_TAGS=key1,key2,key3

Select hosts for specific locations by assigning a comma separated list of locations to:

- AZURE_LOCATIONS=eastus,eastus2,westus

Or, select hosts for specific tag key:value pairs by assigning a comma separated list key:value pairs to:

- AZURE_TAGS=key1:value1,key2:value2

If you don’t need the powerstate, you can improve performance by turning off powerstate fetching:

- AZURE_INCLUDE_POWERSTATE=no

A sample azure_rm.ini file is included along with the inventory script in [here](https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/azure_rm.ini). An .ini file will contain the following:

```
[azure]
# Control which resource groups are included. By default all resources groups are included.
# Set resource_groups to a comma separated list of resource groups names.
#resource_groups=

# Control which tags are included. Set tags to a comma separated list of keys or key:value pairs
#tags=

# Control which locations are included. Set locations to a comma separated list of locations.
#locations=

# Include powerstate. If you don't need powerstate information, turning it off improves runtime performance.
# Valid values: yes, no, true, false, True, False, 0, 1.
include_powerstate=yes

# Control grouping with the following boolean flags. Valid values: yes, no, true, false, True, False, 0, 1.
group_by_resource_group=yes
group_by_location=yes
group_by_security_group=yes
group_by_tag=yes
group_by_os_family=yes
```

### Examples[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#examples)

Here are some examples using the inventory script:

```
# Download inventory script
$ wget https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/azure_rm.py

# Execute /bin/uname on all instances in the Testing resource group
$ ansible -i azure_rm.py Testing -m shell -a "/bin/uname -a"

# Execute win_ping on all Windows instances
$ ansible -i azure_rm.py windows -m win_ping

# Execute ping on all Linux instances
$ ansible -i azure_rm.py linux -m ping

# Use the inventory script to print instance specific information
$ ./azure_rm.py --host my_instance_host_name --resource-groups=Testing --pretty

# Use the inventory script with ansible-playbook
$ ansible-playbook -i ./azure_rm.py test_playbook.yml
```

Here is a simple playbook to exercise the Azure inventory script:

```
- name: Test the inventory script
  hosts: azure
  connection: local
  gather_facts: false
  tasks:
    - debug:
        msg: "{{ inventory_hostname }} has powerstate {{ powerstate }}"
```

You can execute the playbook with something like:

```
$ ansible-playbook -i ./azure_rm.py test_azure_inventory.yml
```

### Disabling certificate validation on Azure endpoints[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#disabling-certificate-validation-on-azure-endpoints)

When an HTTPS proxy is present, or when using Azure Stack, it may be necessary to disable certificate validation for Azure endpoints in the Azure modules. This is not a recommended security practice, but may be necessary when the system CA store cannot be altered to include the necessary CA certificate. Certificate validation can be controlled by setting the “cert_validation_mode” value in a credential profile, through the “AZURE_CERT_VALIDATION_MODE” environment variable, or by passing the “cert_validation_mode” argument to any Azure module. The default value is “validate”; setting the value to “ignore” will prevent all certificate validation. The module argument takes precedence over a credential profile value, which takes precedence over the environment value.

# Online.net Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_online.html#online-net-guide)

## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_online.html#introduction)

Online is a French hosting company mainly known for providing bare-metal servers named Dedibox. Check it out: https://www.online.net/en

### Dynamic inventory for Online resources[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_online.html#dynamic-inventory-for-online-resources)

Ansible has a dynamic inventory plugin that can list your resources.

1. Create a YAML configuration such as `online_inventory.yml` with this content:

```
plugin: online
```

1. - Set your `ONLINE_TOKEN` environment variable with your token.

     You need to open an account and log into it before you can get a token. You can find your token at the following page: https://console.online.net/en/api/access

2. You can test that your inventory is working by running:

```
$ ansible-inventory -v -i online_inventory.yml --list
```

1. Now you can run your playbook or any other module with this inventory:

```
ansible all -i online_inventory.yml -m ping
sd-96735 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

# Oracle Cloud Infrastructure Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#oracle-cloud-infrastructure-guide)

## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#introduction)

Oracle provides a number of Ansible modules to interact with Oracle  Cloud Infrastructure (OCI). In this guide, we will explain how you can  use these modules to orchestrate, provision and configure your  infrastructure on OCI.

## Requirements[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#requirements)

To use the OCI Ansible modules, you must have the following  prerequisites on your control node, the computer from which Ansible  playbooks are executed.

1. [An Oracle Cloud Infrastructure account.](https://cloud.oracle.com/en_US/tryit)
2. A user created in that account, in a security group with a policy that grants the necessary permissions for working with resources in  those compartments. For guidance, see [How Policies Work](https://docs.cloud.oracle.com/iaas/Content/Identity/Concepts/policies.htm).
3. The necessary credentials and OCID information.

## Installation[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#installation)

1. Install the Oracle Cloud Infrastructure Python SDK ([detailed installation instructions](https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/en/latest/installation.html)):

```
pip install oci
```

1. Install the Ansible OCI Modules in one of two ways:

1. From Galaxy:

```
ansible-galaxy install oracle.oci_ansible_modules
```

1. From GitHub:

```
$ git clone https://github.com/oracle/oci-ansible-modules.git
$ cd oci-ansible-modules
```

Run one of the following commands:

- If Ansible is installed only for your user:

```
$ ./install.py
```

- If Ansible is installed as root:

```
$ sudo ./install.py
```

## Configuration[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#configuration)

When creating and configuring Oracle Cloud Infrastructure resources,  Ansible modules use the authentication information outlined [here](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/sdkconfig.htm). .

## Examples[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#examples)

### Launch a compute instance[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#launch-a-compute-instance)

This [sample launch playbook](https://github.com/oracle/oci-ansible-modules/tree/master/samples/compute/launch_compute_instance) launches a public Compute instance and then accesses the instance from  an Ansible module over an SSH connection. The sample illustrates how to:

- Generate a temporary, host-specific SSH key pair.
- Specify the public key from the key pair for connecting to the instance, and then launch the instance.
- Connect to the newly launched instance using SSH.

### Create and manage Autonomous Data Warehouses[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#create-and-manage-autonomous-data-warehouses)

This [sample warehouse playbook](https://github.com/oracle/oci-ansible-modules/tree/master/samples/database/autonomous_data_warehouse) creates an Autonomous Data Warehouse and manage its lifecycle. The sample shows how to:

- Set up an Autonomous Data Warehouse.
- List all of the Autonomous Data Warehouse instances available in a compartment, filtered by the display name.
- Get the “facts” for a specified Autonomous Data Warehouse.
- Stop and start an Autonomous Data Warehouse instance.
- Delete an Autonomous Data Warehouse instance.

### Create and manage Autonomous Transaction Processing[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_oracle.html#create-and-manage-autonomous-transaction-processing)

This [sample playbook](https://github.com/oracle/oci-ansible-modules/tree/master/samples/database/autonomous_database) creates an Autonomous Transaction Processing database and manage its lifecycle. The sample shows how to:

- Set up an Autonomous Transaction Processing database instance.
- List all of the Autonomous Transaction Processing instances in a compartment, filtered by the display name.
- Get the “facts” for a specified Autonomous Transaction Processing instance.
- Delete an Autonomous Transaction Processing database instance.

You can find more examples here: [Sample Ansible Playbooks](https://docs.cloud.oracle.com/iaas/Content/API/SDKDocs/ansiblesamples.htm).

# Packet.net Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#packet-net-guide)

## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#introduction)

[Packet.net](https://packet.net) is a bare metal infrastructure host that’s supported by Ansible  (>=2.3) through a dynamic inventory script and two cloud modules. The two modules are:

- packet_sshkey: adds a public SSH key from file or value to the  Packet infrastructure. Every subsequently-created device will have this  public key installed in .ssh/authorized_keys.
- packet_device: manages servers on Packet. You can use this module to create, restart and delete devices.

Note, this guide assumes you are familiar with Ansible and how it works. If you’re not, have a look at their [docs](https://docs.ansible.com/ansible/latest/index.html#ansible-documentation) before getting started.

## Requirements[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#requirements)

The Packet modules and inventory script connect to the Packet API using the packet-python package. You can install it with pip:

```
$ pip install packet-python
```

In order to check the state of devices created by Ansible on Packet, it’s a good idea to install one of the [Packet CLI clients](https://www.packet.net/developers/integrations/). Otherwise you can check them through the [Packet portal](https://app.packet.net/portal).

To use the modules and inventory script you’ll need a Packet API token. You can generate an API token through the Packet portal [here](https://app.packet.net/portal#/api-keys). The simplest way to authenticate yourself is to set the Packet API token in an environment variable:

```
$ export PACKET_API_TOKEN=Bfse9F24SFtfs423Gsd3ifGsd43sSdfs
```

If you’re not comfortable exporting your API token, you can pass it as a parameter to the modules.

On Packet, devices and reserved IP addresses belong to [projects](https://www.packet.com/developers/api/#projects). In order to use the packet_device module, you need to specify the UUID  of the project in which you want to create or manage devices. You can  find a project’s UUID in the Packet portal [here](https://app.packet.net/portal#/projects/list/table/) (it’s just under the project table) or through one of the available [CLIs](https://www.packet.net/developers/integrations/).

If you want to use a new SSH key pair in this tutorial, you can generate it to `./id_rsa` and `./id_rsa.pub` as:

```
$ ssh-keygen -t rsa -f ./id_rsa
```

If you want to use an existing key pair, just copy the private and public key over to the playbook directory.

## Device Creation[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#device-creation)

The following code block is a simple playbook that creates one [Type 0](https://www.packet.com/cloud/servers/t1-small/) server (the ‘plan’ parameter). You have to supply ‘plan’ and  ‘operating_system’. ‘location’ defaults to ‘ewr1’ (Parsippany, NJ). You  can find all the possible values for the parameters through a [CLI client](https://www.packet.net/developers/integrations/).

```
# playbook_create.yml

- name: create ubuntu device
  hosts: localhost
  tasks:

  - packet_sshkey:
      key_file: ./id_rsa.pub
      label: tutorial key

  - packet_device:
      project_id: <your_project_id>
      hostnames: myserver
      operating_system: ubuntu_16_04
      plan: baremetal_0
      facility: sjc1
```

After running `ansible-playbook playbook_create.yml`, you should have a server provisioned on Packet. You can verify through a CLI or in the [Packet portal](https://app.packet.net/portal#/projects/list/table).

If you get an error with the message “failed to set machine state  present, error: Error 404: Not Found”, please verify your project UUID.

## Updating Devices[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#updating-devices)

The two parameters used to uniquely identify Packet devices are:  “device_ids” and “hostnames”. Both parameters accept either a single  string (later converted to a one-element list), or a list of strings.

The ‘device_ids’ and ‘hostnames’ parameters are mutually exclusive. The following values are all acceptable:

- device_ids: a27b7a83-fc93-435b-a128-47a5b04f2dcf
- hostnames: mydev1
- device_ids: [a27b7a83-fc93-435b-a128-47a5b04f2dcf, 4887130f-0ccd-49a0-99b0-323c1ceb527b]
- hostnames: [mydev1, mydev2]

In addition, hostnames can contain a special ‘%d’ formatter along  with a ‘count’ parameter that lets you easily expand hostnames that  follow a simple name and number pattern; in other words, `hostnames: "mydev%d", count: 2` will expand to [mydev1, mydev2].

If your playbook acts on existing Packet devices, you can only pass  the ‘hostname’ and ‘device_ids’ parameters. The following playbook shows how you can reboot a specific Packet device by setting the ‘hostname’  parameter:

```
# playbook_reboot.yml

- name: reboot myserver
  hosts: localhost
  tasks:

  - packet_device:
      project_id: <your_project_id>
      hostnames: myserver
      state: rebooted
```

You can also identify specific Packet devices with the ‘device_ids’ parameter. The device’s UUID can be found in the [Packet Portal](https://app.packet.net/portal) or by using a [CLI](https://www.packet.net/developers/integrations/). The following playbook removes a Packet device using the ‘device_ids’ field:

```
# playbook_remove.yml

- name: remove a device
  hosts: localhost
  tasks:

  - packet_device:
      project_id: <your_project_id>
      device_ids: <myserver_device_id>
      state: absent
```

## More Complex Playbooks[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#more-complex-playbooks)

In this example, we’ll create a CoreOS cluster with [user data](https://packet.com/developers/docs/servers/key-features/user-data/).

The CoreOS cluster will use [etcd](https://etcd.io/) for discovery of other servers in the cluster. Before provisioning your servers, you’ll need to generate a discovery token for your cluster:

```
$ curl -w "\n" 'https://discovery.etcd.io/new?size=3'
```

The following playbook will create an SSH key, 3 Packet servers, and  then wait until SSH is ready (or until 5 minutes passed). Make sure to  substitute the discovery token URL in ‘user_data’, and the ‘project_id’  before running `ansible-playbook`. Also, feel free to change ‘plan’ and ‘facility’.

```
# playbook_coreos.yml

- name: Start 3 CoreOS nodes in Packet and wait until SSH is ready
  hosts: localhost
  tasks:

  - packet_sshkey:
      key_file: ./id_rsa.pub
      label: new

  - packet_device:
      hostnames: [coreos-one, coreos-two, coreos-three]
      operating_system: coreos_beta
      plan: baremetal_0
      facility: ewr1
      project_id: <your_project_id>
      wait_for_public_IPv: 4
      user_data: |
        #cloud-config
        coreos:
          etcd2:
            discovery: https://discovery.etcd.io/<token>
            advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
            initial-advertise-peer-urls: http://$private_ipv4:2380
            listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
            listen-peer-urls: http://$private_ipv4:2380
          fleet:
            public-ip: $private_ipv4
          units:
            - name: etcd2.service
              command: start
            - name: fleet.service
              command: start
    register: newhosts

  - name: wait for ssh
    wait_for:
      delay: 1
      host: "{{ item.public_ipv4 }}"
      port: 22
      state: started
      timeout: 500
    loop: "{{ newhosts.results[0].devices }}"
```

As with most Ansible modules, the default states of the Packet  modules are idempotent, meaning the resources in your project will  remain the same after re-runs of a playbook. Thus, we can keep the `packet_sshkey` module call in our playbook. If the public key is already in your Packet account, the call will have no effect.

The second module call provisions 3 Packet Type 0 (specified using  the ‘plan’ parameter) servers in the project identified by the  ‘project_id’ parameter. The servers are all provisioned with CoreOS beta (the ‘operating_system’ parameter) and are customized with cloud-config user data passed to the ‘user_data’ parameter.

The `packet_device` module has a `wait_for_public_IPv` that is used to specify the version of the IP address to wait for (valid values are `4` or `6` for IPv4 or IPv6). If specified, Ansible will wait until the GET API  call for a device contains an Internet-routeable IP address of the  specified version. When referring to an IP address of a created device  in subsequent module calls, it’s wise to use the `wait_for_public_IPv` parameter, or `state: active` in the packet_device module call.

Run the playbook:

```
$ ansible-playbook playbook_coreos.yml
```

Once the playbook quits, your new devices should be reachable through SSH. Try to connect to one and check if etcd has started properly:

```
tomk@work $ ssh -i id_rsa core@$one_of_the_servers_ip
core@coreos-one ~ $ etcdctl cluster-health
```

Once you create a couple of devices, you might appreciate the dynamic inventory script…

## Dynamic Inventory Script[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_packet.html#dynamic-inventory-script)

The dynamic inventory script queries the Packet API for a list of  hosts, and exposes it to Ansible so you can easily identify and act on  Packet devices.

You can find it in Ansible Community General Collection’s git repo at [scripts/inventory/packet_net.py](https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/packet_net.py).

The inventory script is configurable through an [ini file](https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/packet_net.ini).

If you want to use the inventory script, you must first export your Packet API token to a PACKET_API_TOKEN environment variable.

You can either copy the inventory and ini config out from the cloned  git repo, or you can download it to your working directory like so:

```
$ wget https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/packet_net.py
$ chmod +x packet_net.py
$ wget https://raw.githubusercontent.com/ansible-community/contrib-scripts/main/inventory/packet_net.ini
```

In order to understand what the inventory script gives to Ansible you can run:

```
$ ./packet_net.py --list
```

It should print a JSON document looking similar to following trimmed dictionary:

```
{
  "_meta": {
    "hostvars": {
      "147.75.64.169": {
        "packet_billing_cycle": "hourly",
        "packet_created_at": "2017-02-09T17:11:26Z",
        "packet_facility": "ewr1",
        "packet_hostname": "coreos-two",
        "packet_href": "/devices/d0ab8972-54a8-4bff-832b-28549d1bec96",
        "packet_id": "d0ab8972-54a8-4bff-832b-28549d1bec96",
        "packet_locked": false,
        "packet_operating_system": "coreos_beta",
        "packet_plan": "baremetal_0",
        "packet_state": "active",
        "packet_updated_at": "2017-02-09T17:16:35Z",
        "packet_user": "core",
        "packet_userdata": "#cloud-config\ncoreos:\n  etcd2:\n    discovery: https://discovery.etcd.io/e0c8a4a9b8fe61acd51ec599e2a4f68e\n    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001\n    initial-advertise-peer-urls: http://$private_ipv4:2380\n    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001\n    listen-peer-urls: http://$private_ipv4:2380\n  fleet:\n    public-ip: $private_ipv4\n  units:\n    - name: etcd2.service\n      command: start\n    - name: fleet.service\n      command: start"
      }
    }
  },
  "baremetal_0": [
    "147.75.202.255",
    "147.75.202.251",
    "147.75.202.249",
    "147.75.64.129",
    "147.75.192.51",
    "147.75.64.169"
  ],
  "coreos_beta": [
    "147.75.202.255",
    "147.75.202.251",
    "147.75.202.249",
    "147.75.64.129",
    "147.75.192.51",
    "147.75.64.169"
  ],
  "ewr1": [
    "147.75.64.129",
    "147.75.192.51",
    "147.75.64.169"
  ],
  "sjc1": [
    "147.75.202.255",
    "147.75.202.251",
    "147.75.202.249"
  ],
  "coreos-two": [
    "147.75.64.169"
  ],
  "d0ab8972-54a8-4bff-832b-28549d1bec96": [
    "147.75.64.169"
  ]
}
```

In the `['_meta']['hostvars']` key, there is a list of devices (uniquely identified by their public IPv4 address) with their parameters. The other keys under `['_meta']` are lists of devices grouped by some parameter. Here, it is type (all  devices are of type baremetal_0), operating system, and facility (ewr1  and sjc1).

In addition to the parameter groups, there are also one-item groups with the UUID or hostname of the device.

You can now target groups in playbooks! The following playbook will  install a role that supplies resources for an Ansible target into all  devices in the “coreos_beta” group:

```
# playbook_bootstrap.yml

- hosts: coreos_beta
  gather_facts: false
  roles:
    - defunctzombie.coreos-boostrap
```

Don’t forget to supply the dynamic inventory in the `-i` argument!

```
$ ansible-playbook -u core -i packet_net.py playbook_bootstrap.yml
```

If you have any questions or comments let us know! [help@packet.net](mailto:help@packet.net)

# Rackspace Cloud Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#rackspace-cloud-guide)



## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#introduction)

Note

Rackspace functionality in Ansible is not maintained and users should consider the [OpenStack collection](https://galaxy.ansible.com/openstack/cloud) instead.

Ansible contains a number of core modules for interacting with Rackspace Cloud.

The purpose of this section is to explain how to put Ansible modules together (and use inventory scripts) to use Ansible in a Rackspace Cloud context.

Prerequisites for using the rax modules are minimal.  In addition to ansible itself, all of the modules require and are tested against pyrax 1.5 or higher. You’ll need this Python module installed on the execution host.

`pyrax` is not currently available in many operating system package repositories, so you will likely need to install it through pip:

```
$ pip install pyrax
```

Ansible creates an implicit localhost that executes in the same context as the `ansible-playbook` and the other CLI tools. If for any reason you need or want to have it in your inventory you should do something like the following:

```
[localhost]
localhost ansible_connection=local ansible_python_interpreter=/usr/local/bin/python2
```

For more information see [Implicit Localhost](https://docs.ansible.com/ansible/latest/inventory/implicit_localhost.html#implicit-localhost)

In playbook steps, we’ll typically be using the following pattern:

```
- hosts: localhost
  gather_facts: False
  tasks:
```



## Credentials File[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#credentials-file)

The rax.py inventory script and all rax modules support a standard pyrax credentials file that looks like:

```
[rackspace_cloud]
username = myraxusername
api_key = d41d8cd98f00b204e9800998ecf8427e
```

Setting the environment parameter `RAX_CREDS_FILE` to the path of this file will help Ansible find how to load this information.

More information about this credentials file can be found at https://github.com/pycontribs/pyrax/blob/master/docs/getting_started.md#authenticating



### Running from a Python Virtual Environment (Optional)[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#running-from-a-python-virtual-environment-optional)

Most users will not be using virtualenv, but some users, particularly Python developers sometimes like to.

There are special considerations when Ansible is installed to a  Python virtualenv, rather than the default of installing at a global  scope. Ansible assumes, unless otherwise instructed, that the python  binary will live at /usr/bin/python.  This is done through the  interpreter line in modules, however when instructed by setting the  inventory variable ‘ansible_python_interpreter’, Ansible will use this  specified path instead to find Python.  This can be a cause of confusion as one may assume that modules running on ‘localhost’, or perhaps  running through ‘local_action’, are using the virtualenv Python  interpreter.  By setting this line in the inventory, the modules will  execute in the virtualenv interpreter and have available the virtualenv  packages, specifically pyrax. If using virtualenv, you may wish to  modify your localhost inventory definition to find this location as  follows:

```
[localhost]
localhost ansible_connection=local ansible_python_interpreter=/path/to/ansible_venv/bin/python
```

Note

pyrax may be installed in the global Python package scope or in a  virtual environment.  There are no special considerations to keep in  mind when installing pyrax.



## Provisioning[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#provisioning)

Now for the fun parts.

The ‘rax’ module provides the ability to provision instances within  Rackspace Cloud.  Typically the provisioning task will be performed from your Ansible control server (in our example, localhost) against the  Rackspace cloud API.  This is done for several reasons:

> - Avoiding installing the pyrax library on remote nodes
> - No need to encrypt and distribute credentials to remote nodes
> - Speed and simplicity

Note

Authentication with the Rackspace-related modules is handled by either specifying your username and API key as environment variables or passing them as module arguments, or by specifying the location of a credentials file.

Here is a basic example of provisioning an instance in ad hoc mode:

```
$ ansible localhost -m rax -a "name=awx flavor=4 image=ubuntu-1204-lts-precise-pangolin wait=yes"
```

Here’s what it would look like in a playbook, assuming the parameters were defined in variables:

```
tasks:
  - name: Provision a set of instances
    rax:
        name: "{{ rax_name }}"
        flavor: "{{ rax_flavor }}"
        image: "{{ rax_image }}"
        count: "{{ rax_count }}"
        group: "{{ group }}"
        wait: true
    register: rax
    delegate_to: localhost
```

The rax module returns data about the nodes it creates, like IP  addresses, hostnames, and login passwords.  By registering the return  value of the step, it is possible used this data to dynamically add the  resulting hosts to inventory (temporarily, in memory). This facilitates  performing configuration actions on the hosts in a follow-on task.  In  the following example, the servers that were successfully created using  the above task are dynamically added to a group called “raxhosts”, with  each nodes hostname, IP address, and root password being added to the  inventory.

```
- name: Add the instances we created (by public IP) to the group 'raxhosts'
  add_host:
      hostname: "{{ item.name }}"
      ansible_host: "{{ item.rax_accessipv4 }}"
      ansible_password: "{{ item.rax_adminpass }}"
      groups: raxhosts
  loop: "{{ rax.success }}"
  when: rax.action == 'create'
```

With the host group now created, the next play in this playbook could now configure servers belonging to the raxhosts group.

```
- name: Configuration play
  hosts: raxhosts
  user: root
  roles:
    - ntp
    - webserver
```

The method above ties the configuration of a host with the provisioning step.  This isn’t always what you want, and leads us to the next section.



## Host Inventory[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#host-inventory)

Once your nodes are spun up, you’ll probably want to talk to them  again.  The best way to handle this is to use the “rax” inventory  plugin, which dynamically queries Rackspace Cloud and tells Ansible what nodes you have to manage.  You might want to use this even if you are  spinning up cloud instances through other tools, including the Rackspace Cloud user interface. The inventory plugin can be used to group  resources by metadata, region, OS, and so on.  Utilizing metadata is  highly recommended in “rax” and can provide an easy way to sort between  host groups and roles. If you don’t want to use the `rax.py` dynamic inventory script, you could also still choose to manually  manage your INI inventory file, though this is less recommended.

In Ansible it is quite possible to use multiple dynamic inventory  plugins along with INI file data.  Just put them in a common directory  and be sure the scripts are chmod +x, and the INI-based ones are not.



### rax.py[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#rax-py)

To use the Rackspace dynamic inventory script, copy `rax.py` into your inventory directory and make it executable. You can specify a credentials file for `rax.py` utilizing the `RAX_CREDS_FILE` environment variable.

Note

Dynamic inventory scripts (like `rax.py`) are saved in `/usr/share/ansible/inventory` if Ansible has been installed globally.  If installed to a virtualenv, the inventory scripts are installed to `$VIRTUALENV/share/inventory`.

Note

Users of [Red Hat Ansible Automation Platform](https://docs.ansible.com/ansible/latest/reference_appendices/tower.html#ansible-platform) will note that dynamic inventory is natively supported by the  controller in the platform, and all you have to do is associate a group  with your Rackspace Cloud credentials, and it will easily synchronize  without going through these steps:

```
$ RAX_CREDS_FILE=~/.raxpub ansible all -i rax.py -m setup
```

`rax.py` also accepts a `RAX_REGION` environment variable, which can contain an individual region, or a comma separated list of regions.

When using `rax.py`, you will not have a ‘localhost’ defined in the inventory.

As mentioned previously, you will often be running most of these  modules outside of the host loop, and will need ‘localhost’ defined.   The recommended way to do this, would be to create an `inventory` directory, and place both the `rax.py` script and a file containing `localhost` in it.

Executing `ansible` or `ansible-playbook` and specifying the `inventory` directory instead of an individual file, will cause ansible to evaluate each file in that directory for inventory.

Let’s test our inventory script to see if it can talk to Rackspace Cloud.

```
$ RAX_CREDS_FILE=~/.raxpub ansible all -i inventory/ -m setup
```

Assuming things are properly configured, the `rax.py` inventory script will output information similar to the following information, which will be utilized for inventory and variables.

```
{
    "ORD": [
        "test"
    ],
    "_meta": {
        "hostvars": {
            "test": {
                "ansible_host": "198.51.100.1",
                "rax_accessipv4": "198.51.100.1",
                "rax_accessipv6": "2001:DB8::2342",
                "rax_addresses": {
                    "private": [
                        {
                            "addr": "192.0.2.2",
                            "version": 4
                        }
                    ],
                    "public": [
                        {
                            "addr": "198.51.100.1",
                            "version": 4
                        },
                        {
                            "addr": "2001:DB8::2342",
                            "version": 6
                        }
                    ]
                },
                "rax_config_drive": "",
                "rax_created": "2013-11-14T20:48:22Z",
                "rax_flavor": {
                    "id": "performance1-1",
                    "links": [
                        {
                            "href": "https://ord.servers.api.rackspacecloud.com/111111/flavors/performance1-1",
                            "rel": "bookmark"
                        }
                    ]
                },
                "rax_hostid": "e7b6961a9bd943ee82b13816426f1563bfda6846aad84d52af45a4904660cde0",
                "rax_human_id": "test",
                "rax_id": "099a447b-a644-471f-87b9-a7f580eb0c2a",
                "rax_image": {
                    "id": "b211c7bf-b5b4-4ede-a8de-a4368750c653",
                    "links": [
                        {
                            "href": "https://ord.servers.api.rackspacecloud.com/111111/images/b211c7bf-b5b4-4ede-a8de-a4368750c653",
                            "rel": "bookmark"
                        }
                    ]
                },
                "rax_key_name": null,
                "rax_links": [
                    {
                        "href": "https://ord.servers.api.rackspacecloud.com/v2/111111/servers/099a447b-a644-471f-87b9-a7f580eb0c2a",
                        "rel": "self"
                    },
                    {
                        "href": "https://ord.servers.api.rackspacecloud.com/111111/servers/099a447b-a644-471f-87b9-a7f580eb0c2a",
                        "rel": "bookmark"
                    }
                ],
                "rax_metadata": {
                    "foo": "bar"
                },
                "rax_name": "test",
                "rax_name_attr": "name",
                "rax_networks": {
                    "private": [
                        "192.0.2.2"
                    ],
                    "public": [
                        "198.51.100.1",
                        "2001:DB8::2342"
                    ]
                },
                "rax_os-dcf_diskconfig": "AUTO",
                "rax_os-ext-sts_power_state": 1,
                "rax_os-ext-sts_task_state": null,
                "rax_os-ext-sts_vm_state": "active",
                "rax_progress": 100,
                "rax_status": "ACTIVE",
                "rax_tenant_id": "111111",
                "rax_updated": "2013-11-14T20:49:27Z",
                "rax_user_id": "22222"
            }
        }
    }
}
```



### Standard Inventory[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#standard-inventory)

When utilizing a standard ini formatted inventory file (as opposed to the inventory plugin), it may still be advantageous to retrieve  discoverable hostvar information  from the Rackspace API.

This can be achieved with the `rax_facts` module and an inventory file similar to the following:

```
[test_servers]
hostname1 rax_region=ORD
hostname2 rax_region=ORD
- name: Gather info about servers
  hosts: test_servers
  gather_facts: False
  tasks:
    - name: Get facts about servers
      rax_facts:
        credentials: ~/.raxpub
        name: "{{ inventory_hostname }}"
        region: "{{ rax_region }}"
      delegate_to: localhost
    - name: Map some facts
      set_fact:
        ansible_host: "{{ rax_accessipv4 }}"
```

While you don’t need to know how it works, it may be interesting to know what kind of variables are returned.

The `rax_facts` module provides facts as following, which match the `rax.py` inventory script:

```
{
    "ansible_facts": {
        "rax_accessipv4": "198.51.100.1",
        "rax_accessipv6": "2001:DB8::2342",
        "rax_addresses": {
            "private": [
                {
                    "addr": "192.0.2.2",
                    "version": 4
                }
            ],
            "public": [
                {
                    "addr": "198.51.100.1",
                    "version": 4
                },
                {
                    "addr": "2001:DB8::2342",
                    "version": 6
                }
            ]
        },
        "rax_config_drive": "",
        "rax_created": "2013-11-14T20:48:22Z",
        "rax_flavor": {
            "id": "performance1-1",
            "links": [
                {
                    "href": "https://ord.servers.api.rackspacecloud.com/111111/flavors/performance1-1",
                    "rel": "bookmark"
                }
            ]
        },
        "rax_hostid": "e7b6961a9bd943ee82b13816426f1563bfda6846aad84d52af45a4904660cde0",
        "rax_human_id": "test",
        "rax_id": "099a447b-a644-471f-87b9-a7f580eb0c2a",
        "rax_image": {
            "id": "b211c7bf-b5b4-4ede-a8de-a4368750c653",
            "links": [
                {
                    "href": "https://ord.servers.api.rackspacecloud.com/111111/images/b211c7bf-b5b4-4ede-a8de-a4368750c653",
                    "rel": "bookmark"
                }
            ]
        },
        "rax_key_name": null,
        "rax_links": [
            {
                "href": "https://ord.servers.api.rackspacecloud.com/v2/111111/servers/099a447b-a644-471f-87b9-a7f580eb0c2a",
                "rel": "self"
            },
            {
                "href": "https://ord.servers.api.rackspacecloud.com/111111/servers/099a447b-a644-471f-87b9-a7f580eb0c2a",
                "rel": "bookmark"
            }
        ],
        "rax_metadata": {
            "foo": "bar"
        },
        "rax_name": "test",
        "rax_name_attr": "name",
        "rax_networks": {
            "private": [
                "192.0.2.2"
            ],
            "public": [
                "198.51.100.1",
                "2001:DB8::2342"
            ]
        },
        "rax_os-dcf_diskconfig": "AUTO",
        "rax_os-ext-sts_power_state": 1,
        "rax_os-ext-sts_task_state": null,
        "rax_os-ext-sts_vm_state": "active",
        "rax_progress": 100,
        "rax_status": "ACTIVE",
        "rax_tenant_id": "111111",
        "rax_updated": "2013-11-14T20:49:27Z",
        "rax_user_id": "22222"
    },
    "changed": false
}
```

## Use Cases[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#use-cases)

This section covers some additional usage examples built around a specific use case.



### Network and Server[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#network-and-server)

Create an isolated cloud network and build a server

```
- name: Build Servers on an Isolated Network
  hosts: localhost
  gather_facts: False
  tasks:
    - name: Network create request
      rax_network:
        credentials: ~/.raxpub
        label: my-net
        cidr: 192.168.3.0/24
        region: IAD
        state: present
      delegate_to: localhost

    - name: Server create request
      rax:
        credentials: ~/.raxpub
        name: web%04d.example.org
        flavor: 2
        image: ubuntu-1204-lts-precise-pangolin
        disk_config: manual
        networks:
          - public
          - my-net
        region: IAD
        state: present
        count: 5
        exact_count: true
        group: web
        wait: true
        wait_timeout: 360
      register: rax
      delegate_to: localhost
```



### Complete Environment[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#complete-environment)

Build a complete webserver environment with servers, custom networks  and load balancers, install nginx and create a custom index.html

```
---
- name: Build environment
  hosts: localhost
  gather_facts: False
  tasks:
    - name: Load Balancer create request
      rax_clb:
        credentials: ~/.raxpub
        name: my-lb
        port: 80
        protocol: HTTP
        algorithm: ROUND_ROBIN
        type: PUBLIC
        timeout: 30
        region: IAD
        wait: true
        state: present
        meta:
          app: my-cool-app
      register: clb

    - name: Network create request
      rax_network:
        credentials: ~/.raxpub
        label: my-net
        cidr: 192.168.3.0/24
        state: present
        region: IAD
      register: network

    - name: Server create request
      rax:
        credentials: ~/.raxpub
        name: web%04d.example.org
        flavor: performance1-1
        image: ubuntu-1204-lts-precise-pangolin
        disk_config: manual
        networks:
          - public
          - private
          - my-net
        region: IAD
        state: present
        count: 5
        exact_count: true
        group: web
        wait: true
      register: rax

    - name: Add servers to web host group
      add_host:
        hostname: "{{ item.name }}"
        ansible_host: "{{ item.rax_accessipv4 }}"
        ansible_password: "{{ item.rax_adminpass }}"
        ansible_user: root
        groups: web
      loop: "{{ rax.success }}"
      when: rax.action == 'create'

    - name: Add servers to Load balancer
      rax_clb_nodes:
        credentials: ~/.raxpub
        load_balancer_id: "{{ clb.balancer.id }}"
        address: "{{ item.rax_networks.private|first }}"
        port: 80
        condition: enabled
        type: primary
        wait: true
        region: IAD
      loop: "{{ rax.success }}"
      when: rax.action == 'create'

- name: Configure servers
  hosts: web
  handlers:
    - name: restart nginx
      service: name=nginx state=restarted

  tasks:
    - name: Install nginx
      apt: pkg=nginx state=latest update_cache=yes cache_valid_time=86400
      notify:
        - restart nginx

    - name: Ensure nginx starts on boot
      service: name=nginx state=started enabled=yes

    - name: Create custom index.html
      copy: content="{{ inventory_hostname }}" dest=/usr/share/nginx/www/index.html
            owner=root group=root mode=0644
```



### RackConnect and Managed Cloud[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#rackconnect-and-managed-cloud)

When using RackConnect version 2 or Rackspace Managed Cloud there are Rackspace automation tasks that are executed on the servers you create  after they are successfully built. If your automation executes before  the RackConnect or Managed Cloud automation, you can cause failures and  unusable servers.

These examples show creating servers, and ensuring that the Rackspace automation has completed before Ansible continues onwards.

For simplicity, these examples are joined, however both are only  needed when using RackConnect.  When only using Managed Cloud, the  RackConnect portion can be ignored.

The RackConnect portions only apply to RackConnect version 2.



#### Using a Control Machine[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#using-a-control-machine)

```
- name: Create an exact count of servers
  hosts: localhost
  gather_facts: False
  tasks:
    - name: Server build requests
      rax:
        credentials: ~/.raxpub
        name: web%03d.example.org
        flavor: performance1-1
        image: ubuntu-1204-lts-precise-pangolin
        disk_config: manual
        region: DFW
        state: present
        count: 1
        exact_count: true
        group: web
        wait: true
      register: rax

    - name: Add servers to in memory groups
      add_host:
        hostname: "{{ item.name }}"
        ansible_host: "{{ item.rax_accessipv4 }}"
        ansible_password: "{{ item.rax_adminpass }}"
        ansible_user: root
        rax_id: "{{ item.rax_id }}"
        groups: web,new_web
      loop: "{{ rax.success }}"
      when: rax.action == 'create'

- name: Wait for rackconnect and managed cloud automation to complete
  hosts: new_web
  gather_facts: false
  tasks:
    - name: ensure we run all tasks from localhost
      delegate_to: localhost
      block:
        - name: Wait for rackconnnect automation to complete
          rax_facts:
            credentials: ~/.raxpub
            id: "{{ rax_id }}"
            region: DFW
          register: rax_facts
          until: rax_facts.ansible_facts['rax_metadata']['rackconnect_automation_status']|default('') == 'DEPLOYED'
          retries: 30
          delay: 10

        - name: Wait for managed cloud automation to complete
          rax_facts:
            credentials: ~/.raxpub
            id: "{{ rax_id }}"
            region: DFW
          register: rax_facts
          until: rax_facts.ansible_facts['rax_metadata']['rax_service_level_automation']|default('') == 'Complete'
          retries: 30
          delay: 10

- name: Update new_web hosts with IP that RackConnect assigns
  hosts: new_web
  gather_facts: false
  tasks:
    - name: Get facts about servers
      rax_facts:
        name: "{{ inventory_hostname }}"
        region: DFW
      delegate_to: localhost
    - name: Map some facts
      set_fact:
        ansible_host: "{{ rax_accessipv4 }}"

- name: Base Configure Servers
  hosts: web
  roles:
    - role: users

    - role: openssh
      opensshd_PermitRootLogin: "no"

    - role: ntp
```



#### Using Ansible Pull[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#using-ansible-pull)

```
---
- name: Ensure Rackconnect and Managed Cloud Automation is complete
  hosts: all
  tasks:
    - name: ensure we run all tasks from localhost
      delegate_to: localhost
      block:
        - name: Check for completed bootstrap
          stat:
            path: /etc/bootstrap_complete
          register: bootstrap

        - name: Get region
          command: xenstore-read vm-data/provider_data/region
          register: rax_region
          when: bootstrap.stat.exists != True

        - name: Wait for rackconnect automation to complete
          uri:
            url: "https://{{ rax_region.stdout|trim }}.api.rackconnect.rackspace.com/v1/automation_status?format=json"
            return_content: true
          register: automation_status
          when: bootstrap.stat.exists != True
          until: automation_status['automation_status']|default('') == 'DEPLOYED'
          retries: 30
          delay: 10

        - name: Wait for managed cloud automation to complete
          wait_for:
            path: /tmp/rs_managed_cloud_automation_complete
            delay: 10
          when: bootstrap.stat.exists != True

        - name: Set bootstrap completed
          file:
            path: /etc/bootstrap_complete
            state: touch
            owner: root
            group: root
            mode: 0400

- name: Base Configure Servers
  hosts: all
  roles:
    - role: users

    - role: openssh
      opensshd_PermitRootLogin: "no"

    - role: ntp
```



#### Using Ansible Pull with XenStore[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#using-ansible-pull-with-xenstore)

```
---
- name: Ensure Rackconnect and Managed Cloud Automation is complete
  hosts: all
  tasks:
    - name: Check for completed bootstrap
      stat:
        path: /etc/bootstrap_complete
      register: bootstrap

    - name: Wait for rackconnect_automation_status xenstore key to exist
      command: xenstore-exists vm-data/user-metadata/rackconnect_automation_status
      register: rcas_exists
      when: bootstrap.stat.exists != True
      failed_when: rcas_exists.rc|int > 1
      until: rcas_exists.rc|int == 0
      retries: 30
      delay: 10

    - name: Wait for rackconnect automation to complete
      command: xenstore-read vm-data/user-metadata/rackconnect_automation_status
      register: rcas
      when: bootstrap.stat.exists != True
      until: rcas.stdout|replace('"', '') == 'DEPLOYED'
      retries: 30
      delay: 10

    - name: Wait for rax_service_level_automation xenstore key to exist
      command: xenstore-exists vm-data/user-metadata/rax_service_level_automation
      register: rsla_exists
      when: bootstrap.stat.exists != True
      failed_when: rsla_exists.rc|int > 1
      until: rsla_exists.rc|int == 0
      retries: 30
      delay: 10

    - name: Wait for managed cloud automation to complete
      command: xenstore-read vm-data/user-metadata/rackconnect_automation_status
      register: rsla
      when: bootstrap.stat.exists != True
      until: rsla.stdout|replace('"', '') == 'DEPLOYED'
      retries: 30
      delay: 10

    - name: Set bootstrap completed
      file:
        path: /etc/bootstrap_complete
        state: touch
        owner: root
        group: root
        mode: 0400

- name: Base Configure Servers
  hosts: all
  roles:
    - role: users

    - role: openssh
      opensshd_PermitRootLogin: "no"

    - role: ntp
```



## Advanced Usage[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#advanced-usage)



### Autoscaling with AWX or Red Hat Ansible Automation Platform[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#autoscaling-with-awx-or-red-hat-ansible-automation-platform)

The GUI component of [Red Hat Ansible Automation Platform](https://docs.ansible.com/ansible/2.9/reference_appendices/tower.html#ansible-tower) also contains a very nice feature for auto-scaling use cases.  In this  mode, a simple curl script can call a defined URL and the server will “dial out” to the requester and  configure an instance that is spinning up.  This can be a great way to reconfigure ephemeral nodes.  See [the documentation on provisioning callbacks](https://docs.ansible.com/ansible-tower/latest/html/userguide/job_templates.html#provisioning-callbacks) for more details.

A benefit of using the callback approach over pull mode is that job results are still centrally recorded and less information has to be shared with remote hosts.



### Orchestration in the Rackspace Cloud[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_rax.html#orchestration-in-the-rackspace-cloud)

Ansible is a powerful orchestration tool, and rax modules allow you  the opportunity to orchestrate complex tasks, deployments, and  configurations.  The key here is to automate provisioning of  infrastructure, like any other piece of software in an environment.   Complex deployments might have previously required manual manipulation  of load balancers, or manual provisioning of servers.  Utilizing the rax modules included with Ansible, one can make the deployment of  additional nodes contingent on the current number of running nodes, or  the configuration of a clustered application dependent on the number of  nodes with common metadata.  One could automate the following scenarios, for example:

- Servers that are removed from a Cloud Load Balancer one-by-one, updated, verified, and returned to the load balancer pool
- Expansion of an already-online environment, where nodes are provisioned, bootstrapped, configured, and software installed
- A procedure where app log files are uploaded to a central location, like Cloud Files, before a node is decommissioned
- Servers and load balancers that have DNS records created and destroyed on creation and decommissioning, respectively

# Scaleway Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#scaleway-guide)



## Introduction[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#introduction)

[Scaleway](https://scaleway.com) is a cloud provider supported by Ansible, version 2.6 or higher through a dynamic inventory plugin and modules. Those modules are:

- [scaleway_sshkey – Scaleway SSH keys management module](https://docs.ansible.com/ansible/2.9/modules/scaleway_sshkey_module.html#scaleway-sshkey-module): adds a public SSH key from a file or value to the Packet  infrastructure. Every subsequently-created device will have this public  key installed in .ssh/authorized_keys.
- [scaleway_compute – Scaleway compute management module](https://docs.ansible.com/ansible/2.9/modules/scaleway_compute_module.html#scaleway-compute-module): manages servers on Scaleway. You can use this module to create, restart and delete servers.
- [scaleway_volume – Scaleway volumes management module](https://docs.ansible.com/ansible/2.9/modules/scaleway_volume_module.html#scaleway-volume-module): manages volumes on Scaleway.

Note

This guide assumes you are familiar with Ansible and how it works. If you’re not, have a look at [ansible_documentation](https://docs.ansible.com/ansible/7/index.html#ansible-documentation) before getting started.



## Requirements[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#requirements)

The Scaleway modules and inventory script connect to the Scaleway API using [Scaleway REST API](https://developer.scaleway.com). To use the modules and inventory script you’ll need a Scaleway API token. You can generate an API token through the Scaleway console [here](https://cloud.scaleway.com/#/credentials). The simplest way to authenticate yourself is to set the Scaleway API token in an environment variable:

```
$ export SCW_TOKEN=00000000-1111-2222-3333-444444444444
```

If you’re not comfortable exporting your API token, you can pass it as a parameter to the modules using the `api_token` argument.

If you want to use a new SSH key pair in this tutorial, you can generate it to `./id_rsa` and `./id_rsa.pub` as:

```
$ ssh-keygen -t rsa -f ./id_rsa
```

If you want to use an existing key pair, just copy the private and public key over to the playbook directory.



## How to add an SSH key?[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#how-to-add-an-ssh-key)

Connection to Scaleway Compute nodes use Secure Shell. SSH keys are stored at the account level, which means that you can re-use the same SSH key in multiple nodes. The first step to configure Scaleway compute resources is to have at least one SSH key configured.

[scaleway_sshkey – Scaleway SSH keys management module](https://docs.ansible.com/ansible/2.9/modules/scaleway_sshkey_module.html#scaleway-sshkey-module) is a module that manages SSH keys on your Scaleway account. You can add an SSH key to your account by including the following task in a playbook:

```
- name: "Add SSH key"
  scaleway_sshkey:
    ssh_pub_key: "ssh-rsa AAAA..."
    state: "present"
```

The `ssh_pub_key` parameter contains your ssh public key as a string. Here is an example inside a playbook:

```
- name: Test SSH key lifecycle on a Scaleway account
  hosts: localhost
  gather_facts: false
  environment:
    SCW_API_KEY: ""

  tasks:

    - scaleway_sshkey:
        ssh_pub_key: "ssh-rsa AAAAB...424242 developer@example.com"
        state: present
      register: result

    - assert:
        that:
          - result is success and result is changed
```



## How to create a compute instance?[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#how-to-create-a-compute-instance)

Now that we have an SSH key configured, the next step is to spin up a server! [scaleway_compute – Scaleway compute management module](https://docs.ansible.com/ansible/2.9/modules/scaleway_compute_module.html#scaleway-compute-module) is a module that can create, update and delete Scaleway compute instances:

```
- name: Create a server
  scaleway_compute:
    name: foobar
    state: present
    image: 00000000-1111-2222-3333-444444444444
    organization: 00000000-1111-2222-3333-444444444444
    region: ams1
    commercial_type: START1-S
```

Here are the parameter details for the example shown above:

- `name` is the name of the instance (the one that will show up in your web console).
- `image` is the UUID of the system image you would like to use. A list of all images is available for each availability zone.
- `organization` represents the organization that your account is attached to.
- `region` represents the Availability Zone which your instance is in (for this example, par1 and ams1).
- `commercial_type` represents the name of the commercial offers. You can check out the Scaleway pricing page to find which instance is right for you.

Take a look at this short playbook to see a working example using `scaleway_compute`:

```
- name: Test compute instance lifecycle on a Scaleway account
  hosts: localhost
  gather_facts: false
  environment:
    SCW_API_KEY: ""

  tasks:

    - name: Create a server
      register: server_creation_task
      scaleway_compute:
        name: foobar
        state: present
        image: 00000000-1111-2222-3333-444444444444
        organization: 00000000-1111-2222-3333-444444444444
        region: ams1
        commercial_type: START1-S
        wait: true

    - debug: var=server_creation_task

    - assert:
        that:
          - server_creation_task is success
          - server_creation_task is changed

    - name: Run it
      scaleway_compute:
        name: foobar
        state: running
        image: 00000000-1111-2222-3333-444444444444
        organization: 00000000-1111-2222-3333-444444444444
        region: ams1
        commercial_type: START1-S
        wait: true
        tags:
          - web_server
      register: server_run_task

    - debug: var=server_run_task

    - assert:
        that:
          - server_run_task is success
          - server_run_task is changed
```



## Dynamic Inventory Script[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#dynamic-inventory-script)

Ansible ships with [scaleway – Scaleway inventory source](https://docs.ansible.com/ansible/2.9/plugins/inventory/scaleway.html#scaleway-inventory). You can now get a complete inventory of your Scaleway resources through this plugin and filter it on different parameters (`regions` and `tags` are currently supported).

Let’s create an example! Suppose that we want to get all hosts that got the tag web_server. Create a file named `scaleway_inventory.yml` with the following content:

```
plugin: scaleway
regions:
  - ams1
  - par1
tags:
  - web_server
```

This inventory means that we want all hosts that got the tag `web_server` on the zones `ams1` and `par1`. Once you have configured this file, you can get the information using the following command:

```
$ ansible-inventory --list -i scaleway_inventory.yml
```

The output will be:

```
{
    "_meta": {
        "hostvars": {
            "dd8e3ae9-0c7c-459e-bc7b-aba8bfa1bb8d": {
                "ansible_verbosity": 6,
                "arch": "x86_64",
                "commercial_type": "START1-S",
                "hostname": "foobar",
                "ipv4": "192.0.2.1",
                "organization": "00000000-1111-2222-3333-444444444444",
                "state": "running",
                "tags": [
                    "web_server"
                ]
            }
        }
    },
    "all": {
        "children": [
            "ams1",
            "par1",
            "ungrouped",
            "web_server"
        ]
    },
    "ams1": {},
    "par1": {
        "hosts": [
            "dd8e3ae9-0c7c-459e-bc7b-aba8bfa1bb8d"
        ]
    },
    "ungrouped": {},
    "web_server": {
        "hosts": [
            "dd8e3ae9-0c7c-459e-bc7b-aba8bfa1bb8d"
        ]
    }
}
```

As you can see, we get different groups of hosts. `par1` and `ams1` are groups based on location. `web_server` is a group based on a tag.

In case a filter parameter is not defined, the plugin supposes all values possible are wanted. This means that for each tag that exists on your Scaleway compute nodes, a group based on each tag will be created.

## Scaleway S3 object storage[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_scaleway.html#scaleway-s3-object-storage)

[Object Storage](https://www.scaleway.com/object-storage) allows you to store any kind of objects (documents, images, videos, and so on). As the Scaleway API is S3 compatible, Ansible supports it natively through the modules: [s3_bucket – Manage S3 buckets in AWS, DigitalOcean, Ceph, Walrus and FakeS3](https://docs.ansible.com/ansible/2.9/modules/s3_bucket_module.html#s3-bucket-module), [aws_s3 – manage objects in S3](https://docs.ansible.com/ansible/2.9/modules/aws_s3_module.html#aws-s3-module).

You can find many examples in the [scaleway_s3 integration tests](https://github.com/ansible/ansible-legacy-tests/tree/devel/test/legacy/roles/scaleway_s3).

```
- hosts: myserver
  vars:
    scaleway_region: nl-ams
    s3_url: https://s3.nl-ams.scw.cloud
  environment:
    # AWS_ACCESS_KEY matches your scaleway organization id available at https://cloud.scaleway.com/#/account
    AWS_ACCESS_KEY: 00000000-1111-2222-3333-444444444444
    # AWS_SECRET_KEY matches a secret token that you can retrieve at https://cloud.scaleway.com/#/credentials
    AWS_SECRET_KEY: aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
  module_defaults:
    group/aws:
      s3_url: '{{ s3_url }}'
      region: '{{ scaleway_region }}'
  tasks:
   # use a fact instead of a variable, otherwise template is evaluate each time variable is used
    - set_fact:
        bucket_name: "{{ 99999999 | random | to_uuid }}"

    # "requester_pays:" is mandatory because Scaleway doesn't implement related API
    # another way is to use aws_s3 and "mode: create" !
    - s3_bucket:
        name: '{{ bucket_name }}'
        requester_pays:

    - name: Another way to create the bucket
      aws_s3:
        bucket: '{{ bucket_name }}'
        mode: create
        encrypt: false
      register: bucket_creation_check

    - name: add something in the bucket
      aws_s3:
        mode: put
        bucket: '{{ bucket_name }}'
        src: /tmp/test.txt  #  needs to be created before
        object: test.txt
        encrypt: false  # server side encryption must be disabled
```

# Vultr Guide[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#vultr-guide)

Ansible offers a set of modules to interact with [Vultr](https://www.vultr.com) cloud platform.

This set of module forms a framework that allows one to easily manage and orchestrate one’s infrastructure on Vultr cloud platform.

## Requirements[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#requirements)

There is actually no technical requirement; simply an already created Vultr account.

## Configuration[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#configuration)

Vultr modules offer a rather flexible way with regard to configuration.

Configuration is read in that order:

- Environment Variables (eg. `VULTR_API_KEY`, `VULTR_API_TIMEOUT`)
- File specified by environment variable `VULTR_API_CONFIG`
- `vultr.ini` file located in current working directory
- `$HOME/.vultr.ini`

Ini file are structured this way:

```
[default]
key = MY_API_KEY
timeout = 60

[personal_account]
key = MY_PERSONAL_ACCOUNT_API_KEY
timeout = 30
```

If `VULTR_API_ACCOUNT` environment variable or `api_account` module parameter is not specified, modules will look for the section named “default”.

## Authentication[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#authentication)

Before using the Ansible modules to interact with Vultr, you need an API key. If you don’t yet own one, log in to [Vultr](https://www.vultr.com) go to Account, then API, enable API then the API key should show up.

Ensure you allow the usage of the API key from the proper IP addresses.

Refer to the Configuration section to find out where to put this information.

To check that everything is working properly run the following command:

```
> VULTR_API_KEY=XXX ansible -m vultr_account_info localhost
localhost | SUCCESS => {
  "changed": false,
  "vultr_account_info": {
      "balance": -8.9,
      "last_payment_amount": -10.0,
      "last_payment_date": "2018-07-21 11:34:46",
      "pending_charges": 6.0
  },
  "vultr_api": {
      "api_account": "default",
      "api_endpoint": "https://api.vultr.com",
      "api_retries": 5,
      "api_timeout": 60
  }
}
```

If a similar output displays then everything is setup properly, else please ensure the proper `VULTR_API_KEY` has been specified and that Access Controls on Vultr > Account > API page are accurate.

## Usage[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#usage)

Since [Vultr](https://www.vultr.com) offers a public API, the execution of the module to manage the  infrastructure on their platform will happen on localhost. This  translates to:

```
---
- hosts: localhost
  tasks:
    - name: Create a 10G volume
      vultr_block_storage:
        name: my_disk
        size: 10
        region: New Jersey
```

From that point on, only your creativity is the limit. Make sure to read the documentation of the [available modules](https://docs.ansible.com/ansible/latest/modules/list_of_cloud_modules.html#vultr).

## Dynamic Inventory[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#dynamic-inventory)

Ansible provides a dynamic inventory plugin for [Vultr](https://www.vultr.com). The configuration process is exactly the same as for the modules.

To be able to use it you need to enable it first by specifying the following in the `ansible.cfg` file:

```
[inventory]
enable_plugins=vultr
```

And provide a configuration file to be used with the plugin, the minimal configuration file looks like this:

```
---
plugin: vultr
```

To list the available hosts one can simply run:

```
> ansible-inventory -i vultr.yml --list
```

For example, this allows you to take action on nodes grouped by location or OS name:

```
---
- hosts: Amsterdam
  tasks:
    - name: Rebooting the machine
      shell: reboot
      become: True
```

## Integration tests[](https://docs.ansible.com/ansible/latest/scenario_guides/guide_vultr.html#integration-tests)

Ansible includes integration tests for all Vultr modules.

These tests are meant to run against the public Vultr API and that is why they require a valid key to access the API.

Prepare the test setup:

```
$ cd ansible # location the ansible source is
$ source ./hacking/env-setup
```

Set the Vultr API key:

```
$ cd test/integration
$ cp cloud-config-vultr.ini.template cloud-config-vultr.ini
$ vi cloud-config-vultr.ini
```

Run all Vultr tests:

```
$ ansible-test integration cloud/vultr/ -v --diff --allow-unsupported
```

To run a specific test, for example vultr_account_info:

```
$ ansible-test integration cloud/vultr/vultr_account_info -v --diff --allow-unsupported
```