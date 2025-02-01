# TripleO Deployment Guide

​                          

TripleO is a project aimed at installing, upgrading and operating OpenStack clouds using OpenStack’s own cloud facilities as the foundation - building on Nova, Ironic, Neutron and Heat to automate cloud management at datacenter scale.

- Environment Setup
  - [Standalone Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/standalone.html)
  - [Virtual Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/virtual.html)
  - [Baremetal Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html)
- Baremetal Node Configuration
  - [Bare Metal Node States](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html)
  - [Node cleaning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html)
  - [BIOS Settings](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/bios_settings.html)
  - [Node Discovery](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html)
  - [Setting the Root Device for Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/root_device.html)
  - [Introspecting a Single Node](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspect_single_node.html)
  - [Node matching with resource classes and profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html)
  - [Controlling Node Placement and IP Assignment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html)
  - [Ready-state configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ready_state.html)
  - [Accessing Introspection Data](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html)
  - [Use whole disk images for overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/whole_disk_images.html)
  - [Booting in UEFI mode](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html)
  - [Extending overcloud nodes provisioning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html)
  - [Provisioning Baremetal Before Overcloud Deploy](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html)
- Feature Configurations
  - [Configuring API access policies](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/api_policies.html)
  - [Backend Configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/backends.html)
  - [Bare Metal Instances in Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html)
  - [Deploying with Composable Services](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/composable_services.html)
  - [Deploying with Custom Networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html)
  - [Deploying with Custom Roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_roles.html)
  - [Manage Virtual Persistent Memory (vPMEM)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/compute_nvdimm.html)
  - [Deploy an additional nova cell v2](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2.html)
  - [Deploy and Scale Swift in the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_swift.html)
  - [Using Already Deployed Servers](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html)
  - [Deploying DNSaaS (Designate)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/designate.html)
  - [Disable Telemetry](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/disable_telemetry.html)
  - [Distributed Compute Node deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html)
  - [Distributed Multibackend Storage](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html)
  - [Node customization and Third-Party Integration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/extra_config.html)
  - [Tolerate deployment failures](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tolerated_failure.html)
  - [Configuring High Availability](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/high_availability.html)
  - [Configuring Instance High Availability](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/instance_ha.html)
  - [Deploying with IPSec](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ipsec.html)
  - [Keystone Security Compliance](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/keystone_security_compliance.html)
  - [Enable LVM2 filtering on overcloud nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/lvmfilter.html)
  - [Multiple Overclouds from a Single Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html)
  - [Configuring Network Isolation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html)
  - [Configuring Network Isolation in Virtualized Environments](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation_virt.html)
  - [Modifying default node configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_config.html)
  - [Provisioning of node-specific Hieradata](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_specific_hieradata.html)
  - [Deploying Octavia in the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/octavia.html)
  - [Deploying Operational Tools](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ops_tools.html)
  - [Configuring Messaging RPC and Notifications](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/oslo_messaging_config.html)
  - [Deploying with OVS DPDK Support](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ovs_dpdk_config.html)
  - [Deploying with SR-IOV Support](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/sriov_deployment.html)
  - [Deploying with RHSM](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/rhsm.html)
  - [Role-Specific Parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/role_specific_parameters.html)
  - [Deploying Overcloud with L3 routed networking](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html)
  - [Disabling updates to certain nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/server_blacklist.html)
  - [Security Hardening](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html)
  - [Splitting the Overcloud stack into multiple independent Heat stacks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/split_stack.html)
  - [Deploying with SSL](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html)
  - [TLS Introduction](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-introduction.html)
  - [Deploying TLS-everywhere](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html)
  - [Deploying custom tuned profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tuned.html)
  - [(DEPRECATED) Installing a Undercloud Minion](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/undercloud_minion.html)
  - [Deploying with vDPA Support](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html)
  - [Configure node before Network Config](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/pre_network_config.html)
- TripleO OpenStack Deployment
  - [Containers based Undercloud Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/undercloud.html)
  - [Undercloud Installation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_undercloud.html)
  - [Containers based Overcloud Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/overcloud.html)
  - [Basic Deployment (CLI)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_overcloud.html)
- TripleO Deployment Advanced Topics
  - [Integrating 3rd Party Containers in TripleO](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/3rd_party.html)
  - [TripleO config-download User’s Guide: Deploying with Ansible](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/ansible_config_download.html)
  - [Ansible config-download differences](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/ansible_config_download_differences.html)
  - [TripleO Containers Architecture](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/architecture.html)
  - [Building a Single Image](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/build_single_image.html)
  - [Container Image Preparation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/container_image_prepare.html)
  - [Ephemeral Heat](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/ephemeral_heat.html)
  - [(DEPRECATED) Installing the Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/instack_undercloud.html)
  - [Networking Version 2 (Two)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/network_v2.html)
  - [Standalone Containers based Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/standalone.html)
  - [Deploying with Heat Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/template_deploy.html)
  - [Tips and Tricks for containerizing services](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/tips_tricks.html)
  - [Uploading a Single Image](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/upload_single_image.html)
- Post Cloud Deployment
  - [TripleO backup and restore (Undercloud and Overcloud control plane)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/backup_and_restore/00_index.html)
  - [Deleting Overcloud Nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/delete_nodes.html)
  - [Rotation Keystone Fernet Keys from the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/fernet_key_rotation.html)
  - [Scaling overcloud roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/scale_roles.html)
  - [Tempest](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/tempest/index.html)
  - [Updating undercloud user’s ssh key](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/update_undercloud_ssh_keys.html)
  - [Understanding undercloud/standalone stack updates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/updating-stacks-notes.html)
  - [Upgrades](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/upgrade/index.html)
  - [Validations guide](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/validations/index.html)
- Post Cloud Deployment Advanced Topics
  - [Migrating Workloads from an existing OpenStack cloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/migration.html)
  - [Quiescing a CephStorage Node](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/quiesce_cephstorage.html)
  - [Quiescing a Compute Node](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/quiesce_compute.html)
  - [Updating network configuration on the Overcloud after a deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/updating_network_configuration_post_deployment.html)
  - [Import/Export of VM Snapshots](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/vm_snapshot.html)
  - [Pre-caching images on Compute Nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/post_deployment/pre_cache_images.html)
- Troubleshooting
  - [Troubleshooting](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/troubleshooting/troubleshooting.html)
  - [Troubleshooting Image Build](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/troubleshooting/troubleshooting-image-build.html)
  - [Performing Log and Status Capture](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/troubleshooting/troubleshooting-log-and-status-capture.html)
  - [Troubleshooting Node Management Failures](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/troubleshooting/troubleshooting-nodes.html)
  - [Troubleshooting a Failed Overcloud Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/troubleshooting/troubleshooting-overcloud.html)
  - [Debugging TripleO Heat Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/troubleshooting/troubleshooting-tripleo-heat-templates.html)

# Environment Setup

​                                  

TripleO can be used in baremetal as well as in virtual environments. This section contains instructions on how to setup your environments properly.

- [Standalone Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/standalone.html)
- [Virtual Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/virtual.html)
- Baremetal Environment
  - [Minimum System Requirements](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#minimum-system-requirements)
  - [Preparing the Baremetal Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#preparing-the-baremetal-environment)
  - [Networking](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#networking)
  - [Setting Up The Undercloud Machine](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#setting-up-the-undercloud-machine)
  - [Validations](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#validations)
  - [Configuration Files](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#configuration-files)
  - [instackenv.json](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#instackenv-json)
  - [Ironic Hardware Types](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#ironic-hardware-types)

# Standalone Environment

​                                  

TripleO can be used as a standalone environment with all services installed on a single virtual or baremetal machine.

The machine you are deploying on must meet the following minimum specifications:

- 4 core CPU
- 8 GB memory
- 60 GB free disk space

# Virtual Environment

​                                  

TripleO can be used in a virtual environment using virtual machines instead of actual baremetal. However, one baremetal machine is still needed to act as the host for the virtual machines.



 

Warning



Virtual deployments with TripleO are for development and testing purposes only.  This method cannot be used for production-ready deployments.

The tripleo-quickstart project is used for creating virtual environments for use with TripleO. Please see that documentation at https://docs.openstack.org/tripleo-quickstart/

# Baremetal Environment

​                                  

TripleO can be used in an all baremetal environment. One machine will be used for Undercloud, the others will be used for your Overcloud.

## Minimum System Requirements[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#minimum-system-requirements)

To deploy a minimal TripleO cloud with TripleO you need the following baremetal machines:

- 1 Undercloud
- 1 Overcloud Controller
- 1 Overcloud Compute

For each additional Overcloud role, such as Block Storage or Object Storage, you need an additional baremetal machine.

The baremetal machines must meet the following minimum specifications:

- 8 core CPU
- 12 GB memory
- 60 GB free disk space

Larger systems are recommended for production deployments, however.

For instance, the undercloud needs a bit more capacity, especially regarding RAM (minimum of 16G is advised) and is pretty intense for the I/O - fast disks (SSD, SAS) are strongly advised.

Please also note the undercloud needs space in order to store twice the “overcloud-full” image (one time in its glance, one time in /var/lib subdirectories for PXE/TFTP).

TripleO is supporting only the following operating systems:

- RHEL 9 (x86_64)
- CentOS Stream 9 (x86_64)

Please also ensure your node clock is set to UTC in order to prevent any issue when the OS hwclock syncs to the BIOS clock before applying timezone offset, causing files to have a future-dated timestamp.

## Preparing the Baremetal Environment[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#preparing-the-baremetal-environment)

## Networking[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#networking)

The overcloud nodes will be deployed from the undercloud machine and  therefore the machines need to have their network settings modified to  allow for the overcloud nodes to be PXE booted using the undercloud  machine. As such, the setup requires that:

- All overcloud machines in the setup must support IPMI
- A management provisioning network is setup for all of the overcloud machines. One NIC from every machine needs to be in the same broadcast domain of the provisioning network. In the tested environment, this required setting up a new VLAN on the switch. Note that you should use the same NIC on each of the overcloud machines ( for example: use the second NIC on each overcloud machine). This is because during installation we will need to refer to that NIC using a single name across all overcloud machines e.g. em2
- The provisioning network NIC should not be the same NIC that you are using for remote connectivity to the undercloud machine. During the undercloud installation, a openvswitch bridge will be created for Neutron and the provisioning NIC will be bridged to the openvswitch bridge. As such, connectivity would be lost if the provisioning NIC was also used for remote connectivity to the undercloud machine.
- The overcloud machines can PXE boot off the NIC that is on the private VLAN. In the tested environment, this required disabling network booting in the BIOS for all NICs other than the one we wanted to boot and then ensuring that the chosen NIC is at the top of the boot order (ahead of the local hard disk drive and CD/DVD drives).
- For each overcloud machine you have: the MAC address of the NIC that will PXE boot on the provisioning network the IPMI information for the machine (i.e. IP address of the IPMI NIC, IPMI username and password)

Refer to the following diagram for more information

![../_images/TripleO_Network_Diagram_.jpg](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/_images/TripleO_Network_Diagram_.jpg)

## Setting Up The Undercloud Machine[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#setting-up-the-undercloud-machine)

1. Select a machine within the baremetal environment on which to install the undercloud.

2. Install RHEL 9 x86_64 or CentOS Stream 9 x86_64 on this machine.

3. If needed, create a non-root user with sudo access to use for installing the Undercloud:

   ```
   sudo useradd stack
   sudo passwd stack  # specify a password
   echo "stack ALL=(root) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/stack
   sudo chmod 0440 /etc/sudoers.d/stack
   ```

RHEL

If using RHEL, register the Undercloud for package installations/updates.

RHEL Portal Registration

Register the host machine using Subscription Management:

```
sudo subscription-manager register --username="[your username]" --password="[your password]"
# Find this with `subscription-manager list --available`
sudo subscription-manager attach --pool="[pool id]"
# Verify repositories are available
sudo subscription-manager repos --list
# Enable repositories needed
sudo subscription-manager repos \
  --enable=rhel-8-for-x86_64-baseos-eus-rpms \
  --enable=rhel-8-for-x86_64-appstream-eus-rpms \
  --enable=rhel-8-for-x86_64-highavailability-eus-rpms \
  --enable=ansible-2.9-for-rhel-8-x86_64-rpms
```

RHEL Satellite Registration

To register the host machine to a Satellite, the following repos must be synchronized on the Satellite and enabled for registered systems:

```
rhel-8-for-x86_64-baseos-eus-rpms
rhel-8-for-x86_64-appstream-eus-rpms
rhel-8-for-x86_64-highavailability-eus-rpms
ansible-2.9-for-rhel-8-x86_64-rpms
```

See the [Red Hat Satellite User Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/) for how to configure the system to register with a Satellite server. It is suggested to use an activation key that automatically enables the above repos for registered systems.

## Validations[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#validations)

You can run the `prep` validations to verify the hardware. Later in the process, the validations will be run by the undercloud processes. Refer to the Ansible section for running directly the validations over baremetal nodes [validations_no_undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/validations/ansible.html).

## Configuration Files[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#configuration-files)



## instackenv.json[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#instackenv-json)

Create a JSON file describing your Overcloud baremetal nodes, call it `instackenv.json` and place in your home directory. The file should contain a JSON object with the only field `nodes` containing list of node descriptions.

Each node description should contains required fields:

- `pm_type` - driver for Ironic nodes, see [Ironic Hardware Types](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#ironic-hardware-types) for details
- `pm_addr` - node BMC IP address (hypervisor address in case of virtual environment)
- `pm_user`, `pm_password` - node BMC credentials

Some fields are optional if you’re going to use introspection later:

- `ports` - list of baremetal port objects, a map specifying the following keys: address, physical_network (optional) and local_link_connection (optional). Optional for bare metal. Example:

  ```
  "ports": [
      {
          "address": "52:54:00:87:c8:2f",
          "physical_network": "physical-network",
          "local_link_connection": {
              "switch_info": "switch",
              "port_id": "gi1/0/11",
              "switch_id": "a6:18:66:33:cb:48"
          }
      }
  ]
  ```

- `cpu` - number of CPU’s in system

- `arch` - CPU architecture (common values are `i386` and `x86_64`)

- `memory` - memory size in MiB

- `disk` - hard driver size in GiB

It is also possible (but optional) to set Ironic node capabilities directly in the JSON file. This can be useful for assigning node profiles or setting boot options at registration time:

- `capabilities` - Ironic node capabilities.  For example:

  ```
  "capabilities": "profile:compute,boot_option:local"
  ```

There are also two additional and optional fields that can be used to help a user identifying machines inside `instackenv.json` file:

- `name` - name associated to the node, it will appear in the `Name` column while listing nodes
- `_comment` to associate a comment to the node (like position, long description and so on). Note that this field will not be considered by Ironic during the import

Also if you’re working in a diverse environment with multiple architectures and/or platforms within an architecture you may find it necessary to include a platform field:

- `platform` - String paired with images to fine tune image selection

For example:

```
{
    "nodes": [
        {
            "name": "node-a",
            "pm_type": "ipmi",
            "ports": [
                {
                    "address": "fa:16:3e:2a:0e:36",
                    "physical_network": "ctlplane"
                }
            ],
            "cpu": "2",
            "memory": "4096",
            "disk": "40",
            "arch": "x86_64",
            "pm_user": "admin",
            "pm_password": "password",
            "pm_addr": "10.0.0.8",
            "_comment": "Room 1 - Rack A - Unit 22/24"
        },
        {
            "name": "node-b",
            "pm_type": "ipmi",
            "ports": [
                {
                    "address": "fa:16:3e:da:39:c9",
                    "physical_network": "ctlplane"
                }
            ],
            "cpu": "2",
            "memory": "4096",
            "disk": "40",
            "arch": "x86_64",
            "pm_user": "admin",
            "pm_password": "password",
            "pm_addr": "10.0.0.15",
            "_comment": "Room 1 - Rack A - Unit 26/28"
        },
        {
            "name": "node-n",
            "pm_type": "ipmi",
            "ports": [
                {
                    "address": "fa:16:3e:51:9b:68",
                    "physical_network": "leaf1"
                }
            ],
            "cpu": "2",
            "memory": "4096",
            "disk": "40",
            "arch": "x86_64",
            "pm_user": "admin",
            "pm_password": "password",
            "pm_addr": "10.0.0.16",
            "_comment": "Room 1 - Rack B - Unit 10/12"
        }
    ]
}
```



 

Note



You don’t need to create this file, if you plan on using [Node Discovery](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html).

## Ironic Hardware Types[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#ironic-hardware-types)

Ironic *hardware types* provide various level of support for different hardware. Hardware types, introduced in the Ocata cycle, are a new generation of Ironic *drivers*. Previously, the word *drivers* was used to refer to what is now called *classic drivers*. See [Ironic drivers documentation](https://docs.openstack.org/ironic/latest/install/enabling-drivers.html) for a full explanation of similarities and differences between the two types.

Hardware types are enabled in the `undercloud.conf` using the `enabled_hardware_types` configuration option. Classic drivers are enabled using the `enabled_drivers` option. It has been  deprecated since the Queens release and should no longer be used. See the [hardware types migration guide](https://docs.openstack.org/ironic/latest/admin/upgrade-to-hardware-types.html) for information on how to migrate existing nodes.

Both hardware types and classic drivers can be equally used in the `pm_addr` field of the `instackenv.json`.

See https://docs.openstack.org/ironic/latest/admin/drivers.html for the most up-to-date information about Ironic hardware types and hardware interfaces, but note that this page always targets Ironic git master, not the release we use.

### Generic Hardware Types[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#generic-hardware-types)

- This most generic hardware type is [ipmi](https://docs.openstack.org/ironic/latest/admin/drivers/ipmitool.html). It uses the [ipmitool](http://sourceforge.net/projects/ipmitool/) utility to manage a bare metal node, and supports a vast variety of hardware.

  Stable Branch

  This hardware type is supported starting with the Pike release. For older releases use the functionally equivalent `pxe_ipmitool` driver.

  Virtual

  This hardware type can be used for developing and testing TripleO in a [Virtual Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/virtual.html) as well.

- Another generic hardware type is [redfish](https://docs.openstack.org/ironic/latest/admin/drivers/redfish.html). It provides support for the quite new [Redfish standard](https://www.dmtf.org/standards/redfish), which aims to replace IPMI eventually as a generic protocol for managing hardware. In addition to the `pm_*` fields mentioned above, this hardware type also requires setting `pm_system_id` to the full identifier of the node in the controller (e.g. `/redfish/v1/Systems/42`).

  Stable Branch

  Redfish support was introduced in the Pike release.

The following generic hardware types are not enabled by default:

- The [snmp](https://docs.openstack.org/ironic/latest/admin/drivers/snmp.html) hardware type supports controlling PDUs for power management. It requires boot device to be manually configured on the nodes.

- Finally, the `manual-management` hardware type (not enabled by default) skips power and boot device management completely. It requires manual power and boot operations to be done at the right moments, so it’s not recommended for a generic production.

  Stable Branch

  The functional analog of this hardware type before the Queens release was the `fake_pxe` driver.

### Vendor Hardware Types[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#vendor-hardware-types)

TripleO also supports vendor-specific hardware types for some types of hardware:

- [ilo](https://docs.openstack.org/ironic/latest/admin/drivers/ilo.html) targets HPE Proliant Gen 8 and Gen 9 systems.

  Stable Branch

  Use the `pxe_ilo` classic driver before the Queens release.

- [idrac](https://docs.openstack.org/ironic/latest/admin/drivers/idrac.html) targets DELL 12G and newer systems.

  Stable Branch

  Use the `pxe_drac` classic driver before the Queens release.

The following hardware types are supported but not enabled by default:

- [irmc](https://docs.openstack.org/ironic/latest/admin/drivers/irmc.html) targets FUJITSU PRIMERGY servers.
- [cisco-ucs-managed](https://docs.openstack.org/ironic/latest/admin/drivers/ucs.html) targets UCS Manager managed Cisco UCS B/C series servers.
- [cisco-ucs-standalone](https://docs.openstack.org/ironic/latest/admin/drivers/cimc.html) targets standalone Cisco UCS C series servers.



 

Note



Contact a specific vendor team if you have problems with any of these drivers, as the TripleO team often cannot assist with them.

# Baremetal Node Configuration

​                                  

Documentation on how to do advanced configuration of baremetal nodes in TripleO.

- Bare Metal Node States
  - [enroll](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#enroll)
  - [manageable](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#manageable)
  - [available](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#available)
- Node cleaning
  - [Automated cleaning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html#automated-cleaning)
  - [Manual cleaning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html#manual-cleaning)
- BIOS Settings
  - [Apply BIOS settings](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/bios_settings.html#apply-bios-settings)
  - [Reset BIOS settings](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/bios_settings.html#reset-bios-settings)
- Node Discovery
  - Automatic enrollment of new nodes
    - [Configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#configuration)
    - [Basic usage](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#basic-usage)
    - [Using introspection rules](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#using-introspection-rules)
  - [Scanning BMC range](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#scanning-bmc-range)
- Setting the Root Device for Deployment
  - [Setting root device hints automatically](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/root_device.html#setting-root-device-hints-automatically)
  - [Using introspection data to find the root device](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/root_device.html#using-introspection-data-to-find-the-root-device)
- [Introspecting a Single Node](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspect_single_node.html)
- Node matching with resource classes and profiles
  - [Resource class matching](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#resource-class-matching)
  - Advanced profile matching
    - [Manual profile tagging](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#manual-profile-tagging)
    - [Automated profile tagging](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#automated-profile-tagging)
    - [Example of introspection rules](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#example-of-introspection-rules)
    - [Provision with profile matching](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#provision-with-profile-matching)
- Controlling Node Placement and IP Assignment
  - [Assign per-node capabilities](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#assign-per-node-capabilities)
  - [Create an environment file with Scheduler Hints](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#create-an-environment-file-with-scheduler-hints)
  - [Custom Hostnames](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#custom-hostnames)
  - [Predictable IPs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#predictable-ips)
  - [Predictable Virtual IPs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#predictable-virtual-ips)
- Ready-state configuration
  - [Define the target BIOS configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ready_state.html#define-the-target-bios-configuration)
  - [Trigger the ready-state configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ready_state.html#trigger-the-ready-state-configuration)
- Accessing Introspection Data
  - [Accessing raw additional data](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#accessing-raw-additional-data)
  - [Running benchmarks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#running-benchmarks)
  - [Extra data examples](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#extra-data-examples)
- [Use whole disk images for overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/whole_disk_images.html)
- Booting in UEFI mode
  - [Configuring nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html#configuring-nodes)
  - [Introspection](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html#introspection)
  - [Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html#deployment)
- Extending overcloud nodes provisioning
  - Enabling Ansible deploy
    - [Custom ansible playbooks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#custom-ansible-playbooks)
    - [Installing undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#installing-undercloud)
    - [Enabling temporary URLs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#enabling-temporary-urls)
  - [Configuring nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#configuring-nodes)
  - Editing playbooks
    - [Example: kernel arguments](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#example-kernel-arguments)
- Provisioning Baremetal Before Overcloud Deploy
  - [Undercloud Components For Baremetal Provisioning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#undercloud-components-for-baremetal-provisioning)
  - Baremetal Provision Configuration
    - [Role Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#role-properties)
    - Instance and Defaults Properties
      - [Image Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#image-properties)
      - [Networks Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#networks-properties)
      - [Network Config Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#network-config-properties)
      - [Nics Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#nics-properties)
      - [Config Drive](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#config-drive)
  - Ansible Playbooks
    - [Grow volumes playbook](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#grow-volumes-playbook)
    - [Set kernel arguments playbook](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#set-kernel-arguments-playbook)
  - [Deploying the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#deploying-the-overcloud)
  - [Viewing Provisioned Node Details](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#viewing-provisioned-node-details)
  - Scaling the Overcloud
    - [Scaling Up](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#scaling-up)
    - [Scaling Down](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#scaling-down)
    - [Unprovisioning All Nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#unprovisioning-all-nodes)

# Bare Metal Node States

​                                  

This document provides a brief explanation of the bare metal node states that TripleO uses or might use. Please refer to [the Ironic documentation](https://docs.openstack.org/ironic/) for more details.

## enroll[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#enroll)

In a typical Ironic workflow nodes begin their life in a state called `enroll`. Nodes in this state are not available for deployment, nor for most of other actions. Ironic does not touch such nodes in any way.

In the TripleO workflow the nodes start their life in the `manageable` state and only see the `enroll` state if their power management fails to validate:

```
openstack overcloud import instackenv.json
```

Nodes can optionally be introspected in this step by passing the –provide flag which will progress them through the [manageable](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#manageable) state and eventually to the [available](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#available) state ready for deployment.

## manageable[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#manageable)

To make nodes alive an operator uses `manage` provisioning action to move nodes to `manageable` state. During this transition the power and management credentials (IPMI, SSH, etc) are validated to ensure that nodes in `manageable` state are actually manageable by Ironic. This state is still not available for deployment.  With nodes in this state an operator can execute various pre-deployment actions, such as introspection, RAID configuration, etc. So to sum it up, nodes in `manageable` state are being configured before exposing them into the cloud.

The `manage` action can be used to bring nodes from [enroll](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#enroll) to `manageable` or nodes already moved to [available](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#available) state back to `manageable` for configuration:

```
baremetal node manage <NAME OR UUID>
```

## available[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html#available)

The last step before the deployment is to make nodes `available` using the `provide` provisioning action. Such nodes are exposed to nova, and can be deployed to at any moment. No long-running configuration actions should be run in this state.



 

Note



Nodes which failed introspection stay in `manageable` state and must be reintrospected or made `available` manually:

```
baremetal node provide <NAME OR UUID>
```

# Node cleaning

​                                  

In Ironic *cleaning* is a process of preparing a bare metal node for provisioning. There are two types of cleaning: *automated* and *manual*. See [cleaning documentation](https://docs.openstack.org/ironic/latest/admin/cleaning.html) for more details.



 

Warning



It is highly recommended to at least wipe metadata (partitions and partition table(s)) from all disks before deployment.

## Automated cleaning[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html#automated-cleaning)

*Automated cleaning* runs before a node gets to the `available` state (see [Bare Metal Node States](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html) for more information on provisioning states). It happens after the first enrollment and after every unprovisioning.

In the TripleO undercloud automated cleaning is **disabled** by default. Starting with the Ocata release, it can be enabled by setting the following option in your `undercloud.conf`:

```
[DEFAULT]
clean_nodes = True
```

Alternatively, you can use [Manual cleaning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html#manual-cleaning) as described below.

## Manual cleaning[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html#manual-cleaning)

*Manual cleaning* is run on request for nodes in the `manageable` state.

If you have *automated cleaning* disabled, you can use the following procedure to wipe the node’s metadata starting with the Rocky release:

1. If the node is not in the `manageable` state, move it there:

   ```
   baremetal node manage <UUID or name>
   ```

2. Run manual cleaning on a specific node:

   ```
   openstack overcloud node clean <UUID or name>
   ```

   or all manageable nodes:

   ```
   openstack overcloud node clean --all-manageable
   ```

3. Make the node available again:

   ```
   openstack overcloud node provide <UUID or name>
   ```

   or provide all manageable nodes:

   ```
   openstack overcloud node provide --all-manageable
   ```

# BIOS Settings

​                                  

Tripleo can support BIOS configuration for bare metal nodes via node manual [Node cleaning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/cleaning.html). Several commands are added to allow administrator to apply and reset BIOS settings.

## Apply BIOS settings[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/bios_settings.html#apply-bios-settings)

1. To apply given BIOS configuration to all manageable nodes:

   ```
   openstack overcloud node bios configure --configuration <..> --all-manageable
   ```

2. To apply given BIOS configuration to specified nodes:

   ```
   openstack overcloud node bios configure --configuration <..> node_uuid1 node_uuid2 ..
   ```

The configuration parameter passed to above commands must be YAML/JSON string or a file name which contains YAML/JSON string of BIOS settings, for example:

```
{
  "settings": [
    {
      "name": "setting name",
      "value": "setting value"
    },
    {
      "name": "setting name",
      "value": "setting value"
    },
    ..
  ]
}
```

With the parameter `--all-manageable`, the command applies given BIOS settings to all manageable nodes.

With the parameter `node_uuid1 node_uuid2`, the command applies given BIOS settings to nodes which uuid equal to `node_uuid1` and `node_uuid2`.

## Reset BIOS settings[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/bios_settings.html#reset-bios-settings)

1. To reset the BIOS configuration to factory default on specified nodes:

   ```
   openstack overcloud node bios reset --all-manageable
   ```

2. To reset the BIOS configuration on specified nodes:

   ```
   openstack overcloud node bios reset node_uuid1 node_uuid2 ..
   ```

​                      

# Node Discovery

​                                  

As an alternative to creating an inventory file (`instackenv.json`) and enrolling nodes from it, you can discover and enroll the nodes automatically.

TripleO supports two approaches to the discovery process:

- [Automatic enrollment of new nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#automatic-enrollment-of-new-nodes)
- [Scanning BMC range](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#scanning-bmc-range)

## Automatic enrollment of new nodes[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#automatic-enrollment-of-new-nodes)

You can enable **ironic-inspector** to automatically enroll all unknown nodes that boot the introspection ramdisk. See [ironic-inspector discovery documentation](https://docs.openstack.org/ironic-inspector/usage.html#discovery) for more details on the process.

### Configuration[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#configuration)

Set the following in your `undercloud.conf` before installing the undercloud:

```
enable_node_discovery = True
```

Make sure to get (or build) and upload the introspection image, as described in [Basic Deployment (CLI)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_overcloud.html).

### Basic usage[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#basic-usage)

After the discovery is enabled, any node that boots the introspection ramdisk and posts back to **ironic-inspector** will be enrolled in **ironic**. Make sure the nodes are connected to the provisioning network, and default to booting from PXE. Power them on using any available means (e.g. by pushing the power button on them).

New nodes appear in the `enroll` state by default and use the `pxe_ipmitool` driver (configurable via the `discovery_default_driver` option in `undercloud.conf`). You have to set the power credentials for these nodes and make them available. See [Bare Metal Node States](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html) for details.

### Using introspection rules[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#using-introspection-rules)

Alternatively, you can use **ironic-inspector** introspection rules to automatically set the power credentials based on certain properties.

For example, to set the same credentials for all new nodes, you can use the following rules:

```
[
    {
        "description": "Set default IPMI credentials",
        "conditions": [
            {"op": "eq", "field": "data://auto_discovered", "value": true}
        ],
        "actions": [
            {"action": "set-attribute", "path": "driver_info/ipmi_username",
             "value": "admin"},
            {"action": "set-attribute", "path": "driver_info/ipmi_password",
             "value": "paSSw0rd"}
        ]
    }
]
```

To set specific credentials for a certain vendor, use something like:

```
[
    {
        "description": "Set default IPMI credentials",
        "conditions": [
            {"op": "eq", "field": "data://auto_discovered", "value": true},
            {"op": "ne", "field": "data://inventory.system_vendor.manufacturer",
             "value": "Dell Inc."}
        ],
        "actions": [
            {"action": "set-attribute", "path": "driver_info/ipmi_username",
             "value": "admin"},
            {"action": "set-attribute", "path": "driver_info/ipmi_password",
             "value": "paSSw0rd"}
        ]
    },
    {
        "description": "Set the vendor driver for Dell hardware",
        "conditions": [
            {"op": "eq", "field": "data://auto_discovered", "value": true},
            {"op": "eq", "field": "data://inventory.system_vendor.manufacturer",
             "value": "Dell Inc."}
        ],
        "actions": [
            {"action": "set-attribute", "path": "driver", "value": "pxe_drac"},
            {"action": "set-attribute", "path": "driver_info/drac_username",
             "value": "admin"},
            {"action": "set-attribute", "path": "driver_info/drac_password",
             "value": "paSSw0rd"},
            {"action": "set-attribute", "path": "driver_info/drac_address",
             "value": "{data[inventory][bmc_address]}"}
        ]
    }
]
```

The rules should be put to a file and uploaded to **ironic-inspector** before the discovery process:

```
baremetal introspection rule import /path/to/rules.json
```

See [Node matching with resource classes and profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html) for more examples on introspection rules.

## Scanning BMC range[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_discovery.html#scanning-bmc-range)

You can discover new nodes by scanning an IP range for accessible BMCs. You need to provide a set of credentials to try, and optionally a list of ports. Use the following command to run the scan:

```
openstack overcloud node discover --range <RANGE> \
    --credentials <USER1:PASSWORD1> --credentials <USER2:PASSWORD2>
```

Here, `<RANGE>` is an IP range, e.g. `10.0.0.0/24`. Credentials are provided separated by a colon, e.g. `root:calvin`.

With this approach, new nodes end up in `manageable` state, and will already have the deploy properties, such as deploy kernel/ramdisk, assigned.

You can use the same command to introspect the nodes and make them available for deployment:

```
openstack overcloud node discover --range <RANGE> \
    --credentials <USER1:PASSWORD1> --credentials <USER2:PASSWORD2> \
    --introspect --provide
```

The resulting node UUIDs will be printed on the screen.

# Setting the Root Device for Deployment

​                                  



If your hardware has several hard drives, it’s highly recommended that you specify the exact device to be used during introspection and deployment as a root device. This is done by setting a `root_device` property on the node in Ironic. Please refer to the [Ironic root device hints documentation](https://docs.openstack.org/ironic/latest/install/advanced.html#specifying-the-disk-for-deployment-root-device-hints) for more details.

For example:

```
baremetal node set <UUID> --property root_device='{"wwn": "0x4000cca77fc4dba1"}'
```

To remove a hint and fallback to the default behavior:

```
baremetal node unset <UUID> --property root_device
```

Note that the root device hints should be assigned *before* both introspection and deployment. After changing the root device hints you should either re-run introspection or manually fix the `local_gb` property for a node:

```
baremetal node set <UUID> --property local_gb=<NEW VALUE>
```

Where the new value is calculated as a real disk size in GiB minus 1 GiB to account for partitioning (the introspection process does this calculation automatically).

## Setting root device hints automatically[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/root_device.html#setting-root-device-hints-automatically)

Starting with the Newton release it is possible to autogenerate root device hints for all nodes instead of setting them one by one. Pass the `--root-device` argument to the `openstack overcloud node configure` **after a successful introspection**. This argument can accept a device list in the order of preference, for example:

```
openstack overcloud node configure --all-manageable --root-device=sdb,sdc,vda
```

It can also accept one of two strategies: `smallest` will pick the smallest device, `largest` will pick the largest one. By default only disk devices larger than 4 GiB are considered at all, set the `--root-device-minimum-size` argument to change.



 

Note



Subsequent runs of this command on the same set of nodes does nothing, as root device hints are already recorded on nodes and are not overwritten. If you want to change existing root device hints, first remove them manually as described above.



 

Note



This command relies on introspection data, so if you change disk devices on the machines, introspection must be rerun before rerunning this command.

## Using introspection data to find the root device[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/root_device.html#using-introspection-data-to-find-the-root-device)

If you don’t know the information required to make a choice, you can use introspection to figure it out. First start with [Introspect Nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_overcloud.html#introspection) as usual without setting any root device hints. Then use the stored introspection data to list all disk devices:

```
baremetal introspection data save fdf975ae-6bd7-493f-a0b9-a0a4667b8ef3 | jq '.inventory.disks'
```

For **python-ironic-inspector-client** versions older than 1.4.0 you can use the `curl` command instead, see [Accessing Introspection Data](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#introspection-data) for details.

This command will yield output similar to the following (some fields are empty for a virtual node):

```
[
    {
        "size": 11811160064,
        "rotational": true,
        "vendor": "0x1af4",
        "name": "/dev/vda",
        "wwn_vendor_extension": null,
        "wwn_with_extension": null,
        "model": "",
        "wwn": null,
        "serial": null
    },
    {
        "size": 11811160064,
        "rotational": true,
        "vendor": "0x1af4",
        "name": "/dev/vdb",
        "wwn_vendor_extension": null,
        "wwn_with_extension": null,
        "model": "",
        "wwn": null,
        "serial": null
    }
]
```

You can use all these fields, except for `rotational`, for the root device hints. Note that `size` should be converted to GiB and that `name`, `wwn_with_extension` and `wwn_vendor_extension` can only be used starting with the Mitaka release. Also note that the `name` field, while convenient, [may be unreliable and change between boots](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/persistent_naming.html).

Do not forget to re-run the introspection after setting the root device hints.

​                      Introspecting a Single Node

​                                  

In addition to bulk introspection, you can also introspect nodes one by one. When doing so, you must take care to set the correct node states manually. Use `baremetal node show UUID` command to figure out whether nodes are in `manageable` or `available` state. For all nodes in `available` state, start with putting a node to `manageable` state (see [Bare Metal Node States](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_states.html) for details):

```
baremetal node manage <UUID>
```

Then you can run introspection:

```
baremetal introspection start UUID
```

This command won’t poll for the introspection result, use the following command to check the current introspection state:

```
baremetal introspection status UUID
```

Repeat it for every node until you see `True` in the `finished` field. The `error` field will contain an error message if introspection failed, or `None` if introspection succeeded for this node.

Do not forget to make nodes available for deployment afterwards:

```
baremetal node provide <UUID>
```

# Node matching with resource classes and profiles

​                                  

The [Baremetal Provision Configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#baremetal-provision-configuration) describes all of the instance and defaults properties which can be used as selection criteria for which node will be assigned to a provisioned instance. Filtering on the `resource_class` property is recommended for nodes which have special hardware for specific roles. The `profile` property is recommended for other matching requirements such as placing specific roles to groups of nodes, or assigning instances to nodes based on introspection data.

## Resource class matching[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#resource-class-matching)

As an example of matching on special hardware, this shows how to have a custom `Compute` role for PMEM equipped hardware, see [Manage Virtual Persistent Memory (vPMEM)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/compute_nvdimm.html).

By default all nodes are assigned the `resource_class` of `baremetal`. Each node which is PMEM enabled needs to have its `resource_class` changed to `baremetal.PMEM`:

```
baremetal node set <UUID OR NAME> --resource-class baremetal.PMEM
```

Assuming there is a custom role called `ComputePMEM`, the `~/overcloud_baremetal_deploy.yaml` file will match on `baremetal.PMEM` nodes with:

```
- name: ComputePMEM
  count: 3
  defaults:
    resource_class: baremetal.PMEM
```

## Advanced profile matching[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#advanced-profile-matching)

Profile matching allows a user to specify precisely which nodes provision with each role (or instance). Here are additional setup steps to take advantage of the profile matching. In this document `profile` is a capability that is assigned to the ironic node, then matched in the `openstack overcloud node provision` yaml.

After profile is specified in `~/overcloud_baremetal_deploy.yaml`, metalsmith will only deploy it on ironic nodes with the same profile. Deployment will fail if not enough ironic nodes are tagged with a profile.

There are two ways to assign a profile to a node. You can assign it directly or specify one or many suitable profiles for the deployment command to choose from. It can be done either manually or using the introspection rules.

### Manual profile tagging[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#manual-profile-tagging)

To assign a profile to a node directly, issue the following command:

```
baremetal node set <UUID OR NAME> --property capabilities=profile:<PROFILE>
```

To clean all profile information from a node use:

```
baremetal node unset <UUID OR NAME> --property capabilities
```



 

Note



We can not update only a single key from the capabilities dictionary, so if it contained more then just the profile information then this will need to be set for the node.

Also see [instackenv.json](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html#instackenv) for details on how to set profile in the `instackenv.json` file.



### Automated profile tagging[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#automated-profile-tagging)

[Introspection rules](https://docs.openstack.org/ironic-inspector/usage.html#introspection-rules) can be used to conduct automatic profile assignment based on data received from the introspection ramdisk. A set of introspection rules should be created before introspection that either set `profile` or `<PROFILE>_profile` capabilities on a node.

The exact structure of data received from the ramdisk depends on both ramdisk implementation and enabled plugins, and on enabled *ironic-inspector* processing hooks. The most basic properties are `cpus`, `cpu_arch`, `local_gb` and `memory_mb`, which represent CPU number, architecture, local hard drive size in GiB and RAM size in MiB. See [Accessing Introspection Data](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#introspection-data) for more details on what our current ramdisk provides.

Create a JSON file, for example `rules.json`, with the introspection rules to apply (see [Example of introspection rules](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#example-of-introspection-rules)). Before the introspection load this file into *ironic-inspector*:

```
baremetal introspection rule import /path/to/rules.json
```

Then (re)start the introspection. Check assigned profiles using command:

```
baremetal node list -c uuid -c name -c properties
```

If you’ve made a mistake in introspection rules, you can delete them all:

```
baremetal introspection rule purge
```

Then reupload the updated rules file and restart introspection.



 

Note



When you use introspection rules to assign the `profile` capability, it will always override the existing value. On the contrary, `<PROFILE>_profile` capabilities are ignored for nodes with the existing `profile` capability.

### Example of introspection rules[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#example-of-introspection-rules)

Imagine we have the following hardware: with disk sizes > 1 TiB for object storage and with smaller disks for compute and controller nodes. We also need to make sure that no hardware with seriously insufficient properties gets to the fleet at all.

```
[
    {
        "description": "Fail introspection for unexpected nodes",
        "conditions": [
            {"op": "lt", "field": "memory_mb", "value": 4096}
        ],
        "actions": [
            {"action": "fail", "message": "Memory too low, expected at least 4 GiB"}
        ]
    },
    {
        "description": "Assign profile for object storage",
        "conditions": [
            {"op": "ge", "field": "local_gb", "value": 1024}
        ],
        "actions": [
            {"action": "set-capability", "name": "profile", "value": "swift-storage"}
        ]
    },
    {
        "description": "Assign possible profiles for compute and controller",
        "conditions": [
            {"op": "lt", "field": "local_gb", "value": 1024},
            {"op": "ge", "field": "local_gb", "value": 40}
        ],
        "actions": [
            {"action": "set-capability", "name": "compute_profile", "value": "1"},
            {"action": "set-capability", "name": "control_profile", "value": "1"},
            {"action": "set-capability", "name": "profile", "value": null}
        ]
    }
]
```

This example consists of 3 rules:

1. Fail introspection if memory is lower is 4096 MiB. Such rules can be applied to exclude nodes that should not become part of your cloud.
2. Nodes with hard drive size 1 TiB and bigger are assigned the `swift-storage` profile unconditionally.
3. Nodes with hard drive less than 1 TiB but more than 40 GiB can be either compute or control nodes. So we assign two capabilities `compute_profile` and `control_profile`, so that the `openstack overcloud node provision` command can later make the final choice. For that to work, we remove the existing `profile` capability, otherwise it will have priority.
4. Other nodes are not changed.

### Provision with profile matching[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#provision-with-profile-matching)

Assuming nodes have been assigned the profiles `control_profile` and `compute_profile`, the `~/overcloud_baremetal_deploy.yaml` can be modified with the following to match profiles during `openstack overcloud node provision`:

```
- name: Controller
  count: 3
  defaults:
    profile: control_profile
- name: Compute
  count: 100
  defaults:
    profile: compute_profile
```

# Controlling Node Placement and IP Assignment

​                                  

By default, nodes are assigned randomly via the Nova scheduler, either from a generic pool of nodes, or from a subset of nodes identified via specific profiles which are mapped to Nova flavors (See [Baremetal Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/environments/baremetal.html) and [Node matching with resource classes and profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html) for further information).

However in some circumstances, you may wish to control node placement more directly, which is possible by combining the same capabilities mechanism used for per-profile placement with per-node scheduler hints.

## Assign per-node capabilities[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#assign-per-node-capabilities)

The first step is to assign a unique per-node capability which may be matched by the Nova scheduler on deployment.

This can either be done via the nodes json file when registering the nodes, or alternatively via manual adjustment of the node capabilities, e.g:

```
baremetal node set <id> --property capabilities='node:controller-0'
```

This has assigned the capability `node:controller-0` to the node, and this must be repeated (using a unique continuous index, starting from 0) for all nodes.

If this approach is used, all nodes for a given role (e.g Controller, Compute or each of the Storage roles) must be tagged in the same way, or the Nova scheduler will be unable to match the capabilities correctly.



 

Note



Profile matching is redundant when precise node placement is used. To avoid scheduling failures you should use the default “baremetal” flavor for deployment in this case, not the flavors designed for profile matching (“compute”, “control”, etc).

## Create an environment file with Scheduler Hints[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#create-an-environment-file-with-scheduler-hints)

The next step is simply to create a heat environment file, which matches the per-node capabilities created for each node above:

```
parameter_defaults:
    ControllerSchedulerHints:
        'capabilities:node': 'controller-%index%'
```

This is then passed via `-e scheduler_hints_env.yaml` to the overcloud deploy command.

The same approach is possible for each role via these parameters:

- ControllerSchedulerHints
- ComputeSchedulerHints
- BlockStorageSchedulerHints
- ObjectStorageSchedulerHints
- CephStorageSchedulerHints

For custom roles (defined via roles_data.yaml) the parameter will be named RoleNameSchedulerHints, where RoleName is the name specified in roles_data.yaml.



 

Note



Previously the parameter for Compute nodes was named NovaComputeSchedulerHints. If you are updating a deployment which used the old parameter, all values previously passed to NovaComputeSchedulerHints should be passed to ComputeSchedulerHints instead, and NovaComputeSchedulerHints: {} should be explicitly set in parameter_defaults, to ensure that values from the old parameter will not be used anymore.

## Custom Hostnames[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#custom-hostnames)

In combination with the custom placement configuration above, it is also possible to assign a specific baremetal node a custom hostname.  This may be used to denote where a system is located (e.g. rack2-row12), to make the hostname match an inventory identifier, or any other situation where a custom hostname is desired.

To customize node hostnames, the `HostnameMap` parameter can be used.  For example:

```
parameter_defaults:
  HostnameMap:
    overcloud-controller-0: overcloud-controller-prod-123-0
    overcloud-controller-1: overcloud-controller-prod-456-0
    overcloud-controller-2: overcloud-controller-prod-789-0
    overcloud-novacompute-0: overcloud-novacompute-prod-abc-0
```

The environment file containing this configuration would then be passed to the overcloud deploy command using `-e` as with all environment files.

Note that the `HostnameMap` is global to all roles, and is not a top-level Heat template parameter so it must be passed in the `parameter_defaults` section.  The first value in the map (e.g. `overcloud-controller-0`) is the hostname that Heat would assign based on the HostnameFormat parameters. The second value (e.g. `overcloud-controller-prod-123-0`) is the desired custom hostname for that node.



## Predictable IPs[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#predictable-ips)

For further control over the resulting environment, overcloud nodes can be assigned a specific IP on each network as well.  This is done by editing `environments/ips-from-pool-all.yaml` in tripleo-heat-templates. Be sure to make a local copy of `/usr/share/openstack-tripleo-heat-templates` before making changes so the packaged files are not altered, as they will be overwritten if the package is updated.

The parameter_defaults section in `ips-from-pool-all.yaml`, is where the IP addresses are assigned.  Each node type has an associated parameter - ControllerIPs for Controller nodes, ComputeIPs for Compute nodes, etc.  Each parameter is a map of network names to a list of addresses.  Each network type must have at least as many addresses as there will be nodes on that network. The addresses will be assigned in order, so the first node of each type will get the first address in each of the lists, the second node will get the second address in each of the lists, and so on.

For example, if three Ceph storage nodes were being deployed, the CephStorageIPs parameter might look like:

```
CephStorageIPs:
  storage:
  - 172.16.1.100
  - 172.16.1.101
  - 172.16.1.102
  storage_mgmt:
  - 172.16.3.100
  - 172.16.3.101
  - 172.16.3.102
```

The first Ceph node would have two addresses: 172.16.1.100 and 172.16.3.100.  The second would have 172.16.1.101 and 172.16.3.101, and the third would have 172.16.1.102 and 172.16.3.102.  The same pattern applies to the other node types.



 

Important



Even if an overcloud node is deleted, its entry in the IP lists should *not* be removed.  The IP list is based on the underlying Heat indices, which do not change even if nodes are deleted.  To indicate that a given entry in the list is no longer used, the IP value can be replaced with a value such as “DELETED” or “UNUSED”.

In short, entries should never be removed from the IP lists, only changed or added.

To apply this configuration during a deployment, pass the environment file to the deploy command.  For example, if you copied tripleo-heat-templates to ~/my-templates, the extra parameter would look like:

```
-e ~/my-templates/environments/ips-from-pool-all.yaml
```

## Predictable Virtual IPs[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/node_placement.html#predictable-virtual-ips)

You can also assign predictable Virtual IPs (VIPs) for services. To accomplish this, edit the network environment file and add the VIP parameters in the parameter_defaults section, for example:

```
ControlFixedIPs: [{'ip_address':'192.168.201.101'}]
InternalApiVirtualFixedIPs: [{'ip_address':'172.16.0.9'}]
PublicVirtualFixedIPs: [{'ip_address':'10.1.1.9'}]
StorageVirtualFixedIPs: [{'ip_address':'172.16.1.9'}]
StorageMgmtVirtualFixedIPs: [{'ip_address':'172.16.3.9'}]
RedisVirtualFixedIPs: [{'ip_address':'172.16.0.8'}]
```

These IPs MUST come from outside their allocation range to prevent conflicts. Do not use these parameters if deploying with an external load balancer.

# Ready-state configuration

​                                  



 

Note



Ready-state configuration currently works only with Dell DRAC machines.

Ready-state configuration can be used to prepare bare-metal resources for deployment. It includes BIOS configuration based on a predefined profile.

## Define the target BIOS configuration[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ready_state.html#define-the-target-bios-configuration)

To define a BIOS setting, list the name of the setting and its target value for each profile:

```
{
    "compute" :{
        "bios_settings": {"ProcVirtualization": "Enabled"}
    }
}
```

## Trigger the ready-state configuration[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ready_state.html#trigger-the-ready-state-configuration)

Make sure the nodes have profiles assigned as described in [Node matching with resource classes and profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html). Create a JSON file with the target ready-state configuration for each profile. Then trigger the configuration:

```
baremetal configure ready state ready-state.json
```

# Accessing Introspection Data

​                                  



Every introspection run (as described in [Basic Deployment (CLI)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/deployment/install_overcloud.html)) collects a lot of facts about the hardware and puts them as JSON in Swift. Starting with `python-ironic-inspector-client` version 1.4.0 there is a command to retrieve this data:

```
baremetal introspection data save <UUID>
```

You can provide a `--file` argument to save the data in a file instead of displaying it.

If you don’t have a new enough version of `python-ironic-inspector-client`, you can use cURL to access the API:

```
token=$(openstack token issue -f value -c id)
curl -H "X-Auth-Token: $token" http://127.0.0.1:5050/v1/introspection/<UUID>/data
```

## Accessing raw additional data[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#accessing-raw-additional-data)

Extra hardware data can be collected using the [python-hardware](https://github.com/redhat-cip/hardware) library. If you have enabled this, by setting `inspection_extras` to `True` in your `undercloud.conf` (enabled by default starting with the Mitaka release), then even more data is available.

The command above will display it in a structured format under the `extra` key in the resulting JSON object. This format is suitable for using in the **ironic-inspector** introspection rules (see e.g. [Automated profile tagging](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html#auto-profile-tagging)). However, if you want to access it in its original format (list of lists instead of nested objects), you can query Swift for it directly.

The Swift container name is `ironic-inspector`, which can be modified in **/etc/ironic-inspector/inspector.conf**. The Swift object is called `extra_hardware-<UUID>` where `<UUID>` is a node UUID. In the default configuration you have to use the `service` tenant to access this object.

As an example, to download the Swift data for all nodes to a local directory and use that to collect a list of node mac addresses:

```
# You will need the ironic-inspector user password
# from the [swift] section of /etc/ironic-inspector/inspector.conf:
export IRONIC_INSPECTOR_PASSWORD=xxxxxx

# Download the extra introspection data from swift:
for node in $(baremetal node list -f value -c UUID);
  do swift -U service:ironic -K $IRONIC_INSPECTOR_PASSWORD download ironic-inspector extra_hardware-$node;
done

# Use jq to access the local data - for example gather macs:
for f in extra_hardware-*;
  do cat $f | jq -r 'map(select(.[0]=="network" and .[2]=="serial"))';
done
```

## Running benchmarks[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#running-benchmarks)

Benchmarks for CPU, memory and hard drive can be run during the introspection process. However, they are time consuming, and thus are disabled by default. To enable benchmarks set `inspection_runbench` to `true` in the `undercloud.conf` (also requires `inspection_extras` set to `true`), then (re)run `openstack undercloud install`.

## Extra data examples[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/introspection_data.html#extra-data-examples)

Here is an example of CPU extra data, including benchmark results:

```
$ baremetal introspection data save <UUID> | jq '.extra.cpu'
{
    "physical": {
        "number": 1
    },
    "logical": {
        "number": 1,
        "loops_per_sec": 636
    },
    "logical_0": {
        "bandwidth_4K": 3657,
        "bandwidth_1G": 6775,
        "bandwidth_128M": 8353,
        "bandwidth_2G": 7221,
        "loops_per_sec": 612,
        "bogomips": "6983.57",
        "bandwidth_1M": 10781,
        "bandwidth_16M": 9808,
        "bandwidth_1K": 1204,
        "cache_size": "4096KB"
    },
    "physical_0":
    {
        "physid": 400,
        "product": "QEMU Virtual CPU version 2.3.0",
        "enabled_cores": 1,
        "vendor": "Intel Corp.",
        "threads": 1,
        "flags": "fpu fpu_exception wp de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 clflush mmx fxsr sse sse2 syscall nx x86-64 rep_good nopl pni cx16 x2apic hypervisor lahf_lm abm",
        "version": "RHEL 7.2.0 PC (i440FX + PIIX, 1996)",
        "frequency": 2e+09,
        "cores": 1
    }
}
```

Here is an example of disk extra data, including benchmark results:

```
$ baremetal introspection data save <UUID> | jq '.extra.disk'
{
    "logical": {
        "count": 1
    },
    "sda": {
        "SMART/Raw_Read_Error_Rate(1)/value": 100,
        "SMART/Spin_Up_Time(3)/thresh": 0,
        "model": "QEMU HARDDISK",
        "SMART/Power_Cycle_Count(12)/when_failed": "NEVER",
        "SMART/Reallocated_Sector_Ct(5)/worst": 100,
        "SMART/Power_Cycle_Count(12)/raw": 0,
        "standalone_read_1M_KBps": 1222758,
        "SMART/Power_On_Hours(9)/worst": 100,
        "Read Cache Disable": 0,
        "SMART/Power_On_Hours(9)/raw": 1,
        "rotational": 1,
        "SMART/Start_Stop_Count(4)/thresh": 20,
        "SMART/Start_Stop_Count(4)/raw": 100,
        "SMART/Power_Cycle_Count(12)/thresh": 0,
        "standalone_randread_4k_KBps": 52491,
        "physical_block_size": 512,
        "SMART/Reallocated_Sector_Ct(5)/value": 100,
        "SMART/Reallocated_Sector_Ct(5)/when_failed": "NEVER",
        "SMART/Power_Cycle_Count(12)/value": 100,
        "SMART/Spin_Up_Time(3)/when_failed": "NEVER",
        "size": 44,
        "SMART/Power_On_Hours(9)/thresh": 0,
        "id": "ata-QEMU_HARDDISK_QM00005",
        "SMART/Reallocated_Sector_Ct(5)/raw": 0,
        "SMART/Raw_Read_Error_Rate(1)/when_failed": "NEVER",
        "SMART/Airflow_Temperature_Cel(190)/worst": 69,
        "SMART/Airflow_Temperature_Cel(190)/when_failed": "NEVER",
        "SMART/Spin_Up_Time(3)/value": 100,
        "standalone_read_1M_IOps": 1191,
        "SMART/Airflow_Temperature_Cel(190)/thresh": 50,
        "SMART/Power_On_Hours(9)/when_failed": "NEVER",
        "SMART/firmware_version": "2.3.0",
        "optimal_io_size": 0,
        "SMART/Raw_Read_Error_Rate(1)/thresh": 6,
        "SMART/Raw_Read_Error_Rate(1)/raw": 0,
        "SMART/Raw_Read_Error_Rate(1)/worst": 100,
        "SMART/Power_Cycle_Count(12)/worst": 100,
        "standalone_randread_4k_IOps": 13119,
        "rev": 0,
        "SMART/Start_Stop_Count(4)/worst": 100,
        "SMART/Start_Stop_Count(4)/when_failed": "NEVER",
        "SMART/Spin_Up_Time(3)/worst": 100,
        "SMART/Reallocated_Sector_Ct(5)/thresh": 36,
        "SMART/device_model": "QEMU HARDDISK",
        "SMART/Airflow_Temperature_Cel(190)/raw": " 31 (Min/Max 31/31)",
        "SMART/Start_Stop_Count(4)/value": 100,
        "SMART/Spin_Up_Time(3)/raw": 16,
        "Write Cache Enable": 1,
        "vendor": "ATA",
        "SMART/serial_number": "QM00005",
        "SMART/Power_On_Hours(9)/value": 100,
        "SMART/Airflow_Temperature_Cel(190)/value": 69
    }
}
```

​                      

# Use whole disk images for overcloud

​                                  

By default, TripleO **overcloud-full** image is a *partition* image. Such images carry only the root partition contents and no partition table. Alternatively, *whole disk* images can be used, which carry all partitions, a partition table and a boot loader.

Whole disk images can be built with **diskimage-builder** - see [Ironic images documentation](http://docs.openstack.org/project-install-guide/baremetal/draft/configure-integration.html#create-and-add-images-to-the-image-service) for details. Note that this does not affect **ironic-python-agent** images.

Use the following command to treat **overcloud-full** as a whole disk image when uploading images:

```
openstack overcloud image upload --whole-disk
```

In this case only `overcloud-full.qcow2` file is required, `overcloud-full.initrd` and `overcloud-full.vmlinuz` are not used.

# Booting in UEFI mode

​                                  

TripleO supports booting overcloud nodes in [UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) mode instead of the default BIOS mode. This is required to use advanced features like *secure boot* (not covered by this guide), and some hardware may only feature UEFI support.

## Configuring nodes[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html#configuring-nodes)

Depending on the driver, nodes have to be put in the UEFI mode manually or the driver can put them in it. For example, manual configuration is required for `ipmi` (including `pxe_ipmitool`) and `idrac` (including `pxe_drac`) drivers, while `ilo` (including `pxe_ilo`) and `irmc` (starting with the Queens release) drivers can set boot mode automatically.

Independent of the driver, you have to configure the UEFI mode manually, if you want introspection to run in it.

Manual configuration is usually done by entering node’s *system setup* and changing boot setting there.

## Introspection[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html#introspection)

The introspection process is flexible enough to automatically detect the boot mode of the node. The only requirement is iPXE: TripleO currently does not support using PXE with UEFI. Make sure the following options are enabled in your `undercloud.conf` (they are on by default):

```
ipxe_enabled = True
```

Then you can run introspection as usual.

## Deployment[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/uefi_boot.html#deployment)

Starting with the Pike release, the introspection process configures bare metal nodes to run in the same boot mode as it was run in. For example, if introspection was run on nodes in UEFI mode, **ironic-inspector** will configure introspected nodes to deploy in UEFI mode as well.

Here is how the `properties` field looks for nodes configured in BIOS mode:

```
$ baremetal node show <NODE> -f value -c properties
{u'capabilities': u'profile:compute,boot_mode:bios', u'memory_mb': u'6144', u'cpu_arch': u'x86_64', u'local_gb': u'49', u'cpus': u'1'}
```

Note that `boot_mode:bios` capability is set. For a node in UEFI mode, it will look like this:

```
$ baremetal node show <NODE> -f value -c properties
{u'capabilities': u'profile:compute,boot_mode:uefi', u'memory_mb': u'6144', u'cpu_arch': u'x86_64', u'local_gb': u'49', u'cpus': u'1'}
```

You can change the boot mode with the following command (required for UEFI before the Pike release):

```
$ baremetal node set <NODE> --property capabilities=profile:compute,boot_mode:uefi
```



 

Warning



Do not forget to copy all other capabilities, e.g. `profile` and `boot_option` if present.

Finally, you may configure your flavors to explicitly request nodes that boot in UEFI mode, for example:

```
$ openstack flavor set --property capabilities:boot_mode='uefi' compute
```

Then proceed with the deployment as usual.

# Extending overcloud nodes provisioning

​                                  

Starting with the Queens release, the *ansible* deploy interface became available in Ironic. Unlike the default [iSCSI deploy interface](https://docs.openstack.org/ironic/latest/admin/interfaces/deploy.html#iscsi-deploy), it is highly customizable through operator-provided Ansible playbooks. These playbooks will run on the target image when Ironic boots the deploy ramdisk.



 

Note



This feature is not related to the ongoing work of switching overcloud configuration to Ansible.

## Enabling Ansible deploy[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#enabling-ansible-deploy)

The *ansible* deploy interface is enabled by default starting with Queens. However, additional configuration is required when installing an undercloud.

### Custom ansible playbooks[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#custom-ansible-playbooks)

To avoid modifying playbooks, provided by the distribution, you must copy them to a new location that is accessible by Ironic. In this guide it is `/var/lib/ironic`.



 

Note



Use of the `/var/lib` directory is not fully compliant to FHS. We do it because for containerized undercloud this directory is shared between the host and the ironic-conductor container.

1. Set up repositories and install the Ironic common package, if it is not installed yet:

   ```
   sudo yum install -y openstack-ironic-common
   ```

2. Copy the files to the new location (`/var/lib/ironic/playbooks`):

   ```
   sudo cp -R /usr/lib/python2.7/site-packages/ironic/drivers/modules/ansible/playbooks/ \
       /var/lib/ironic
   ```

### Installing undercloud[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#installing-undercloud)

1. Generate an SSH key pair, for example:

   ```
   ssh-keygen -t rsa -b 2048 -f ~/ipa-ssh -N ''
   ```

   

    

   Warning

   

   The private part should not be password-protected or Ironic will not be able to use it.

2. Create a custom hieradata override. Pass the **public** SSH key for the deploy ramdisk to the common PXE parameters, and set the new playbooks path.

   For example, create a file called `ansible-deploy.yaml` with the following content:

   ```
   ironic::drivers::ansible::default_username: 'root'
   ironic::drivers::ansible::default_key_file: '/var/lib/ironic/ipa-ssh'
   ironic::drivers::ansible::playbooks_path: '/var/lib/ironic/playbooks'
   ironic::drivers::pxe::pxe_append_params: 'nofb nomodeset vga=normal selinux=0 sshkey="<INSERT PUBLIC KEY HERE>"'
   ```

3. Link to this file in your `undercloud.conf`:

   ```
   hieradata_override=/home/stack/ansible-deploy.yaml
   ```

4. Deploy or update your undercloud as usual.

5. Move the private key to `/var/lib/ironic` and ensure correct ACLs:

   ```
   sudo mv ~/ipa-ssh /var/lib/ironic
   sudo chown ironic:ironic /var/lib/ironic/ipa-ssh
   sudo chmod 0600 /var/lib/ironic/ipa-ssh
   ```

### Enabling temporary URLs[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#enabling-temporary-urls)

1. First, enable the `admin` user access to other Swift accounts:

   ```
   $ openstack role add --user admin --project service ResellerAdmin
   ```

2. Check if the `service` account has a temporary URL key generated in the Object Store service. Look for `Temp-Url-Key` properties in the output of the following command:

   ```
   $ openstack --os-project-name service object store account show
   +------------+---------------------------------------+
   | Field      | Value                                 |
   +------------+---------------------------------------+
   | Account    | AUTH_97ae97383424400d8ee1a54c3a2c41a0 |
   | Bytes      | 2209530996                            |
   | Containers | 5                                     |
   | Objects    | 42                                    |
   +------------+---------------------------------------+
   ```

3. If the property is not present, generate a value and add it:

   ```
   $ openstack --os-project-name service object store account set \
       --property Temp-URL-Key=$(uuidgen | sha1sum | awk '{print $1}')
   ```

## Configuring nodes[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#configuring-nodes)

Nodes have to be explicitly configured to use the Ansible deploy. For example, to configure all nodes, use:

```
for node in $(baremetal node list -f value -c UUID); do
    baremetal node set $node --deploy-interface ansible
done
```

## Editing playbooks[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#editing-playbooks)

### Example: kernel arguments[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/ansible_deploy_interface.html#example-kernel-arguments)

Let’s modify the playbooks to include additional kernel parameters for some nodes.

1. Update `/var/lib/ironic/playbooks/roles/configure/tasks/grub.yaml` from

   ```
   - name: create grub config
     become: yes
     command: chroot {{ tmp_rootfs_mount }} /bin/sh -c '{{ grub_config_cmd }} -o {{ grub_config_file }}'
   ```

   to

   ```
   - name: append kernel params
     become: yes
     lineinfile:
       dest: "{{ tmp_rootfs_mount }}/etc/default/grub"
       state: present
       line: 'GRUB_CMDLINE_LINUX+=" {{ ironic_extra.kernel_params | default("") }}"'
   - name: create grub config
     become: yes
     command: chroot {{ tmp_rootfs_mount }} /bin/sh -c '{{ grub_config_cmd }} -o {{ grub_config_file }}'
   ```

2. Set the newly introduced `kernel_params` extra variable to the desired kernel parameters. For example, to update only compute nodes use:

   ```
   for node in $(baremetal node list -c Name -f value | grep compute); do
       baremetal node set $node \
           --extra kernel_params='param1=value1 param2=value2'
   done
   ```

# Provisioning Baremetal Before Overcloud Deploy

​                                  



Baremetal provisioning is a feature which interacts directly with the Bare Metal service to provision baremetal before the overcloud is deployed. This adds a new provision step before the overcloud deploy, and the output of the provision is a valid [Using Already Deployed Servers](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html) configuration.

In the Wallaby release the baremetal provisioning was extended to also manage the neutron API resources for [Configuring Network Isolation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html) and [Deploying with Custom Networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html), and apply network configuration on the provisioned nodes using os-net-config.

## Undercloud Components For Baremetal Provisioning[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#undercloud-components-for-baremetal-provisioning)

A new YAML file format is introduced to describe the baremetal required for the deployment, and the new command `openstack overcloud node provision` will consume this YAML and make the specified changes. The provision command interacts with the following undercloud components:

- A baremetal provisioning workflow which consumes the YAML and runs to completion
- The [metalsmith](https://docs.openstack.org/metalsmith/) tool which deploys nodes and associates ports. This tool is responsible for presenting a unified view of provisioned baremetal while interacting with:
  - The Ironic baremetal node API for deploying nodes
  - The Ironic baremetal allocation API which allocates nodes based on the YAML provisioning criteria
  - The Neutron API for managing ports associated with the node’s NICs

In a future release this will become the default way to deploy baremetal, as the Nova compute service and the Glance image service will be switched off on the undercloud.

## Baremetal Provision Configuration[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#baremetal-provision-configuration)

A declarative YAML format specifies what roles will be deployed and the desired baremetal nodes to assign to those roles. Defaults can be relied on so that the simplest configuration is to specify the roles, and the count of baremetal nodes to provision for each role

```
- name: Controller
  count: 3
- name: Compute
  count: 100
```

Often it is desirable to assign specific nodes to specific roles, and this is done with the `instances` property

```
- name: Controller
  count: 3
  instances:
  - hostname: overcloud-controller-0
    name: node00
  - hostname: overcloud-controller-1
    name: node01
  - hostname: overcloud-controller-2
    name: node02
- name: Compute
  count: 100
  instances:
  - hostname: overcloud-novacompute-0
    name: node04
```

Here the instance `name` refers to the logical name of the node, and the `hostname` refers to the generated hostname which is derived from the overcloud stack name, the role, and an incrementing index. In the above example, all of the Controller servers are on predictable nodes, as well as one of the Compute servers. The other 99 Compute servers are on nodes allocated from the pool of available nodes.

The properties in the `instances` entries can also be set in the `defaults` section so that they do not need to be repeated in every entry. For example, the following are equivalent

```
- name: Controller
  count: 3
  instances:
  - hostname: overcloud-controller-0
    name: node00
    image:
      href: overcloud-full-custom
  - hostname: overcloud-controller-1
    name: node01
    image:
      href: overcloud-full-custom
  - hostname: overcloud-controller-2
    name: node02
    image:
      href: overcloud-full-custom

- name: Controller
  count: 3
  defaults:
    image:
      href: overcloud-full-custom
  instances:
  - hostname: overcloud-controller-0
    name: node00
  - hostname: overcloud-controller-1
    name: node01
  - hostname: overcloud-controller-2
    name: node02
```

When using [Configuring Network Isolation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html), [Deploying with Custom Networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html) or a combination of the two the **networks** and **network_configuration** must either be set in the `defaults` for the role or for each specific node (instance). The following example extends the first simple configuration example adding typical TripleO network isolation by setting defaults for each role

```
- name: Controller
  count: 3
  defaults:
    networks:
    - network: ctlplane
      vif: true
    - network: external
      subnet: external_subnet
    - network: internalapi
      subnet: internal_api_subnet01
    - network: storage
      subnet: storage_subnet01
    - network: storagemgmt
      subnet: storage_mgmt_subnet01
    - network: tenant
      subnet: tenant_subnet01
    network_config:
      template: /home/stack/nic-config/controller.j2
      default_route_network:
      - external
- name: Compute
  count: 100
  defaults:
    networks:
    - network: ctlplane
      vif: true
    - network: internalapi
      subnet: internal_api_subnet02
    - network: tenant
      subnet: tenant_subnet02
    - network: storage
      subnet: storage_subnet02
    network_config:
      template: /home/stack/nic-config/compute.j2
```

### Role Properties[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#role-properties)

Each role entry supports the following properties:

- `name`: Mandatory role name
- `hostname_format`: Override the default hostname format for this role. The default format uses the lower case role name, so for the `Controller` role the default format is `%stackname%-controller-%index%`. Only the `Compute` role doesn’t follow the role name rule, the `Compute` default format is `%stackname%-novacompute-%index%`
- `count`: Number of nodes to provision for this role, defaults to 1
- `defaults`: A dict of default values for `instances` entry properties. An `instances` entry property will override a default specified here See [Instance and Defaults Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#instance-defaults-properties) for supported properties
- `instances`: A list of dict for specifying attributes for specific nodes. See [Instance and Defaults Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#instance-defaults-properties) for supported properties. The length of this list must not be greater than `count`
- `ansible_playbooks`: A list of dict for Ansible playbooks and Ansible vars, the playbooks are run against the role instances after node provisioning, prior to the node network configuration. See [Ansible Playbooks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#ansible-playbook-properties) for more details and examples.



### Instance and Defaults Properties[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#instance-and-defaults-properties)

These properties serve three purposes:

- Setting selection criteria when allocating nodes from the pool of available nodes
- Setting attributes on the baremetal node being deployed
- Setting network configuration properties for the deployed nodes

Each `instances` entry and the `defaults` dict support the following properties:

- `capabilities`: Selection criteria to match the node’s capabilities
- `config_drive`: Add data and first-boot commands to the config-drive passed to the node. See [Config Drive](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#config-drive)
- `hostname`: If this complies with the `hostname_format` pattern then other properties will apply to the node allocated to this hostname. Otherwise, this allows a custom hostname to be specified for this node. (Cannot be specified in `defaults`)
- `image`: Image details to deploy with. See [Image Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#image-properties)
- `managed`: Boolean to determine whether the instance is actually provisioned with metalsmith, or should be treated as preprovisioned.
- `name`: The name of a node to deploy this instance on (Cannot be specified in `defaults`)
- `nics`: (**DEPRECATED:** Replaced by `networks` in Wallaby) List of dicts representing requested NICs. See [Nics Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#nics-properties)
- `networks`: List of dicts representing instance networks. See [Networks Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#networks-properties)
- `network_config`: Network configuration details. See [Network Config Properties](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#network-config-properties)
- `profile`: Selection criteria to use [Node matching with resource classes and profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html)
- `provisioned`: Boolean to determine whether this node is provisioned or unprovisioned. Defaults to `true`, `false` is used to unprovision a node. See [Scaling Down](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#scaling-down)
- `resource_class`: Selection criteria to match the node’s resource class, defaults to `baremetal`. See [Node matching with resource classes and profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/profile_matching.html)
- `root_size_gb`: Size of the root partition in GiB, defaults to 49
- `swap_size_mb`: Size of the swap partition in MiB, if needed
- `traits`: A list of traits as selection criteria to match the node’s `traits`



#### Image Properties[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#image-properties)

- `href`: Glance image reference or URL of the root partition or whole disk image. URL schemes supported are `file://`, `http://`, and `https://`. If the value is not a valid URL, it is assumed to be a Glance image reference
- `checksum`: When the `href` is a URL, the `MD5` checksum of the root partition or whole disk image
- `kernel`: Glance image reference or URL of the kernel image (partition images only)
- `ramdisk`: Glance image reference or URL of the ramdisk image (partition images only)



#### Networks Properties[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#networks-properties)

The `instances` `networks` property supports a list of dicts, one dict per network.

- `network`: Neutron network to create the port for this network:
- `fixed_ip`: Specific IP address to use for this network
- `network`: Neutron network to create the port for this network
- `subnet`: Neutron subnet to create the port for this network
- `port`: Existing Neutron port to use instead of creating one
- `vif`: When `true` the network is attached as VIF (virtual-interface) by metalsmith/ironic. When `false` the baremetal provisioning workflow creates the Neutron API resource, but no VIF attachment happens in metalsmith/ironic. (Typically only the provisioning network (`ctlplane`) has this set to `true`.)

By default there is one network representing

```
- network: ctlplane
  vif: true
```

Other valid network entries would be

```
- network: ctlplane
  fixed_ip: 192.168.24.8
  vif: true
- port: overcloud-controller-0-ctlplane
- network: internal_api
  subnet: internal_api_subnet01
```



#### Network Config Properties[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#network-config-properties)

The `network_config` property contains os-net-config related properties.

- `template`: The ansible j2 nic config template to use when applying node network configuration. (default: `templates/net_config_bridge.j2`)
- `physical_bridge_name`:  Name of the OVS bridge to create for accessing external networks. (default: `br-ex`)
- `public_interface_name`: Which interface to add to the public bridge (default: `nic1`)
- `network_config_update`: Whether to apply network configuration changes, on update or not. Boolean value. (default: `false`)
- `net_config_data_lookup`: Per node and/or per node group os-net-config nic mapping config.
- `default_route_network`: The network to use for the default route (default: `ctlplane`)
- `networks_skip_config`: List of networks that should be skipped when configuring node networking
- `dns_search_domains`: A list of DNS search domains to be added (in order) to resolv.conf.
- `bond_interface_ovs_options`: The ovs_options or bonding_options string for the bond interface. Set things like lacp=active and/or bond_mode=balance-slb for OVS bonds or like mode=4 for Linux bonds using this option.



#### Nics Properties[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#nics-properties)

The `instances` `nics` property supports a list of dicts, one dict per NIC.

- `fixed_ip`: Specific IP address to use for this NIC
- `network`: Neutron network to create the port for this NIC
- `subnet`: Neutron subnet to create the port for this NIC
- `port`: Existing Neutron port to use instead of creating one

By default there is one NIC representing

```
- network: ctlplane
```

Other valid NIC entries would be

```
- subnet: ctlplane-subnet
  fixed_ip: 192.168.24.8
- port: overcloud-controller-0-ctlplane
```



#### Config Drive[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#config-drive)

The `instances` `config_drive` property supports two sub-properties:

- `cloud_config`: Dict of cloud-init [cloud-config](https://cloudinit.readthedocs.io/en/latest/topics/examples.html) data for tasks to run on node boot. A task specified in an `instances` `cloud_config` will overwrite a task with the same name in `defaults` `cloud_config`.
- `meta_data`: Extra metadata to include with the config-drive cloud-init metadata. This will be added to the generated metadata `public_keys`, `uuid`, `name`, `hostname`, and `instance-type` which is set to the role name. Cloud-init makes this metadata available as [instance-data](https://cloudinit.readthedocs.io/en/latest/topics/instancedata.html). A key specified in an `instances` `meta_data` entry will overwrite the same key in `defaults` `meta_data`.

Below are some examples of what can be done with `config_drive`.

Run arbitrary scripts on first boot:

```
config_drive:
  cloud_config:
    bootcmd:
      # temporary workaround to allow steering in ConnectX-3 devices
      - echo "options mlx4_core log_num_mgm_entry_size=-1" >> /etc/modprobe.d/mlx4.conf
      - /sbin/dracut --force
```

Enable and configure ntp:

```
config_drive:
  cloud_config:
    enabled: true
    ntp_client: chrony  # Uses cloud-init default chrony configuration
```

Allow root ssh login (for development environments only):

```
config_drive:
  cloud_config:
    ssh_pwauth: true
    disable_root: false
    chpasswd:
      list: |-
        root:sekrit password
      expire: False
```

Use values from custom metadata:

```
config_drive:
  meta_data:
    foo: bar
  cloud_config:
    runcmd:
      - echo The value of foo is `jq .foo < /run/cloud-init/instance-data.json`
```



## Ansible Playbooks[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#ansible-playbooks)

The role `ansible_playbooks` takes a list of playbook definitions, supporting the `playbook` and `extra_vars` sub-properties.

- `playbook`: The path (relative to the roles definition YAML file) to the ansible playbook.
- `extra_vars`: Extra Ansible variables to set when running the playbook.



 

Note



Playbooks only run if ‘–network-config’ is enabled.

Run arbitrary playbooks:

```
ansible_playbooks:
  - playbook: a_playbook.yaml
  - playbook: b_playbook.yaml
```

Run arbitrary playbooks with extra variables defined for one of the playbooks:

```
ansible_playbooks:
  - playbook: a_playbook.yaml
    extra_vars:
      param1: value1
      param2: value2
  - playbook: b_playbook.yaml
```

### Grow volumes playbook[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#grow-volumes-playbook)

After custom playbooks are run, an in-built playbook is run to grow the LVM volumes of any node deployed with the whole-disk overcloud image overcloud-hardened-uefi-full.qcow2. The implicit ansible_playbooks would be:

```
ansible_playbooks:
  - playbook: /usr/share/ansible/tripleo-playbooks/cli-overcloud-node-growvols.yaml
    extra_vars:
      growvols_args: >
        /=8GB
        /tmp=1GB
        /var/log=10GB
        /var/log/audit=2GB
        /home=1GB
        /var=100%
```

Each LVM volume is grown by the amount specified until the disk is 100% allocated, and any remaining space is given to the / volume.  In some cases it may be necessary to specify different growvols_args. For example the ObjectStorage role deploys swift storage which stores state in /srv, so this volume needs the remaining space instead of /var. The playbook can be explicitly written to override the default growvols_args value, for example:

```
ansible_playbooks:
  - playbook: /usr/share/ansible/tripleo-playbooks/cli-overcloud-node-growvols.yaml
    extra_vars:
      growvols_args: >
        /=8GB
        /tmp=1GB
        /var/log=10GB
        /var/log/audit=2GB
        /home=1GB
        /var=1GB
        /srv=100%
```

### Set kernel arguments playbook[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#set-kernel-arguments-playbook)

Features such as DPDK require that kernel arguments are set and the node is rebooted before the network configuration is run. A playbook is provided to allow this. Here it is run with the default variables set:

```
ansible_playbooks:
  - playbook: /usr/share/ansible/tripleo-playbooks/cli-overcloud-node-kernelargs.yaml
    extra_vars:
      kernel_args: ''
      reboot_wait_timeout: 900
      defer_reboot: false
      tuned_profile: 'throughput-performance'
      tuned_isolated_cores: ''
```

Here is an example for a specific DPDK deployment:

```
ansible_playbooks:
  - playbook: /usr/share/ansible/tripleo-playbooks/cli-overcloud-node-kernelargs.yaml
    extra_vars:
      kernel_args: 'default_hugepagesz=1GB hugepagesz=1G hugepages=64 intel_iommu=on iommu=pt'
      tuned_isolated_cores: '1-11,13-23'
      tuned_profile: 'cpu-partitioning'
```



## Deploying the Overcloud[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#deploying-the-overcloud)

This example assumes that the baremetal provision configuration file has the filename `~/overcloud_baremetal_deploy.yaml` and the resulting deployed server environment file is `~/overcloud-baremetal-deployed.yaml`. It also assumes overcloud networks are pre-deployed using the `openstack overcloud network provision` command and the deployed networks environment file is `~/overcloud-networks-deployed.yaml`.

The baremetal nodes are provisioned with the following command:

```
openstack overcloud node provision \
  --stack overcloud \
  --network-config \
  --output ~/overcloud-baremetal-deployed.yaml \
  ~/overcloud_baremetal_deploy.yaml
```



 

Note



Removing the `--network-config` argument will disable the management of non-VIF networks and post node provisioning network configuration with os-net-config via ansible.

The overcloud can then be deployed using the output from the provision command:

```
openstack overcloud deploy \
  -e /usr/share/openstack-tripleo-heat-templates/environments/deployed-server-environment.yaml \
  -e ~/overcloud-networks-deployed.yaml \
  -e ~/templates/vips-deployed-environment.yaml \
  -e ~/overcloud-baremetal-deployed.yaml \
  --deployed-server \
  --disable-validations \ # optional, see note below
  # other CLI arguments
```



 

Note



The validation which is part of openstack overcloud node provision may fail with the default overcloud image unless the Ironic node has more than 4 GB of RAM. For example, a VBMC node provisioned with 4096 MB of memory failed because the image size plus the reserved RAM size were not large enough (Image size: 4340 MiB, Memory size: 3907 MiB).

## Viewing Provisioned Node Details[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#viewing-provisioned-node-details)

The commands `baremetal node list` and `baremetal node show` continue to show the details of all nodes, however there are some new commands which show a further view of the provisioned nodes.

The [metalsmith](https://docs.openstack.org/metalsmith/) tool provides a unified view of provisioned nodes, along with allocations and neutron ports. This is similar to what Nova provides when it is managing baremetal nodes using the Ironic driver. To list all nodes managed by metalsmith, run:

```
metalsmith list
```

The baremetal allocation API keeps an association of nodes to hostnames, which can be seen by running:

```
baremetal allocation list
```

The allocation record UUID will be the same as the Instance UUID for the node which is allocated. The hostname can be seen in the allocation record, but it can also be seen in the `baremetal node show` property `instance_info`, `display_name`.

## Scaling the Overcloud[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#scaling-the-overcloud)

### Scaling Up[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#scaling-up)

To scale up an existing overcloud, edit `~/overcloud_baremetal_deploy.yaml` to increment the `count` in the roles to be scaled up (and add any desired `instances` entries) then repeat the [Deploying the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#deploying-the-overcloud) steps.



### Scaling Down[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#scaling-down)

Scaling down is done with the `openstack overcloud node delete` command but the nodes to delete are not passed as command arguments.

To scale down an existing overcloud edit `~/overcloud_baremetal_deploy.yaml` to decrement the `count` in the roles to be scaled down, and also ensure there is an `instances` entry for each node being unprovisioned which contains the following:

- The `name` of the baremetal node to remove from the overcloud
- The `hostname` which is assigned to that node
- A `provisioned: false` property
- A YAML comment explaining the reason for making the node unprovisioned (optional)

For example the following would remove `overcloud-compute-1`

```
- name: Compute
  count: 1
  instances:
  - hostname: overcloud-compute-0
    name: node10
    # Removed from deployment due to disk failure
    provisioned: false
  - hostname: overcloud-compute-1
    name: node11
```

Then the delete command will be called with `--baremetal-deployment` instead of passing node arguments:

```
openstack overcloud node delete \
--stack overcloud \
--baremetal-deployment ~/overcloud_baremetal_deploy.yaml
```

Before any node is deleted, a list of nodes to delete is displayed with a confirmation prompt.

What to do when scaling back up depends on the situation. If the scale-down was to temporarily remove baremetal which is later restored, then the scale-up can increment the `count` and set `provisioned: true` on nodes which were previously `provisioned: false`. If that baremetal node is not going to be re-used in that role then the `provisioned: false` can remain indefinitely and the scale-up can specify a new `instances` entry, for example

```
- name: Compute
  count: 2
  instances:
  - hostname: overcloud-compute-0
    name: node10
    # Removed from deployment due to disk failure
    provisioned: false
  - hostname: overcloud-compute-1
    name: node11
  - hostname: overcloud-compute-2
    name: node12
```

### Unprovisioning All Nodes[¶](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/provisioning/baremetal_provision.html#unprovisioning-all-nodes)

After `openstack overcloud delete` is called, all of the baremetal nodes can be unprovisioned without needing to edit `~/overcloud_baremetal_deploy.yaml` by running the unprovision command with the `--all` argument:

```
openstack overcloud node unprovision --all \
  --stack overcloud \
  --network-ports \
  ~/overcloud_baremetal_deploy.yaml
```



 

Note



Removing the `--network-ports` argument will disable the management of non-VIF networks, non-VIF ports will _not_ be deleted in that case.

# Feature Configurations

​                                  

Documentation on additional features for TripleO.

- [Configuring API access policies](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/api_policies.html)
- Backend Configuration
  - Deploying Manila in the Overcloud
    - Deploying the Overcloud with the Internal Ceph Backend
      - [Network Isolation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_manila.html#network-isolation)
    - Deploying Manila in the overcloud with CephFS through NFS and a composable network
      - [CephFS with NFS-Ganesha deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_manila.html#cephfs-with-nfs-ganesha-deployment)
      - [Configure the StorageNFS network](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_manila.html#configure-the-storagenfs-network)
    - [Deploying the Overcloud with an External Backend](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_manila.html#deploying-the-overcloud-with-an-external-backend)
    - [Creating the Share](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_manila.html#creating-the-share)
    - [Accessing the Share](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_manila.html#accessing-the-share)
  - Configuring Cinder with a Custom Unmanaged Backend
    - [Adding a custom backend to Cinder](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/cinder_custom_backend.html#adding-a-custom-backend-to-cinder)
  - Configuring Cinder with a NetApp Backend
    - [Deploying the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/cinder_netapp.html#deploying-the-overcloud)
    - [Creating a NetApp Volume](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/cinder_netapp.html#creating-a-netapp-volume)
  - Deploying Ceph with TripleO
    - [Deployed Ceph Workflow](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#deployed-ceph-workflow)
    - [Deployed Ceph Scope](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#deployed-ceph-scope)
    - [Multiple Ceph clusters per deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#multiple-ceph-clusters-per-deployment)
    - [Prerequisite: Ensure the Ceph container is available](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#prerequisite-ensure-the-ceph-container-is-available)
    - [Prerequisite: Ensure the cephadm package is installed](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#prerequisite-ensure-the-cephadm-package-is-installed)
    - [Prerequisite: Ensure Disks are Clean](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#prerequisite-ensure-disks-are-clean)
    - [Deployed Ceph Command Line Interface](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#deployed-ceph-command-line-interface)
    - [Ceph Configuration Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ceph-configuration-options)
    - [Placement Groups (PGs)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#placement-groups-pgs)
    - [Ceph Name Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ceph-name-options)
    - [Ceph Spec Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ceph-spec-options)
    - [Overriding which disks should be OSDs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#overriding-which-disks-should-be-osds)
    - [Service Placement Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#service-placement-options)
    - [Ceph VIP Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ceph-vip-options)
    - [Deploy additional daemons](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#deploy-additional-daemons)
    - [Example: deploy HA Ceph NFS daemon](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#example-deploy-ha-ceph-nfs-daemon)
    - Crush Hierarchy Options
      - [Example: Apply a custom crush hierarchy to the deployed OSDs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#example-apply-a-custom-crush-hierarchy-to-the-deployed-osds)
    - Network Options
      - [Example: Multiple subnets with custom network names](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#example-multiple-subnets-with-custom-network-names)
      - [Example: IPv6](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#example-ipv6)
      - [Example: Directly setting network and ms_bind options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#example-directly-setting-network-and-ms-bind-options)
    - [SSH User Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ssh-user-options)
    - [Container Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#container-options)
    - [NTP configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ntp-configuration)
    - [Creating Pools and CephX keys before overcloud deployment (Optional)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#creating-pools-and-cephx-keys-before-overcloud-deployment-optional)
    - [Environment files to configure Ceph during Overcloud deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#environment-files-to-configure-ceph-during-overcloud-deployment)
    - [Applying Ceph server configuration during overcloud deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#applying-ceph-server-configuration-during-overcloud-deployment)
    - [Applying Ceph client configuration during overcloud deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#applying-ceph-client-configuration-during-overcloud-deployment)
    - [Ceph Pool Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#ceph-pool-options)
    - [Overriding CRUSH rules](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#overriding-crush-rules)
    - [Overriding CephX Keys](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#overriding-cephx-keys)
    - [Add the Ceph Dashboard to a Overcloud deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#add-the-ceph-dashboard-to-a-overcloud-deployment)
    - [Scenario: Deploy Ceph with TripleO and Metalsmith and then Scale Up](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#scenario-deploy-ceph-with-tripleo-and-metalsmith-and-then-scale-up)
    - [Scenario: Scale Down Ceph with TripleO and Metalsmith](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#scenario-scale-down-ceph-with-tripleo-and-metalsmith)
    - [Scenario: Deploy Hyperconverged Ceph](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#scenario-deploy-hyperconverged-ceph)
  - Use an external Ceph cluster with the Overcloud
    - [Deploying Cinder, Glance, Nova, Gnocchi with an external Ceph RBD service](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#deploying-cinder-glance-nova-gnocchi-with-an-external-ceph-rbd-service)
    - [Configuring Ceph Clients for Multiple External Ceph RBD Services](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#configuring-ceph-clients-for-multiple-external-ceph-rbd-services)
    - [Deploying Manila with an External CephFS Service](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#deploying-manila-with-an-external-cephfs-service)
    - [Compatibility Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#compatibility-options)
    - [Deployment of an Overcloud with External Ceph](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#deployment-of-an-overcloud-with-external-ceph)
    - Standalone Ansible Roles for External Ceph
      - [Single Ceph Cluster](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#single-ceph-cluster)
      - [Multiple Ceph Clusters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ceph_external.html#multiple-ceph-clusters)
  - Domain-specific LDAP Backends
    - [Setup](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/domain_specific_ldap_backends.html#setup)
    - [Post-deployment setup](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/domain_specific_ldap_backends.html#post-deployment-setup)
    - [FreeIPA as an LDAP backend](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/domain_specific_ldap_backends.html#freeipa-as-an-ldap-backend)
  - [Use an external Swift Proxy with the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/swift_external.html)
- Bare Metal Instances in Overcloud
  - [Architecture and requirements](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#architecture-and-requirements)
  - [Preparing undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#preparing-undercloud)
  - Configuring and deploying ironic
    - [Essential configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#essential-configuration)
    - [Additional configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#additional-configuration)
    - [Using a Custom Network for Overcloud Provisioning](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#using-a-custom-network-for-overcloud-provisioning)
    - [Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#deployment)
    - [Validation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#validation)
  - Post-deployment configuration
    - [Resource classes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#resource-classes)
    - [Preparing networking](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#preparing-networking)
    - [Networking using a custom network](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#networking-using-a-custom-network)
    - Configuring networks
      - [Configuring networks on deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#configuring-networks-on-deployment)
      - [Configuring networks per node](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#configuring-networks-per-node)
    - [Adding deployment images](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#adding-deployment-images)
    - [Creating flavors](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#creating-flavors)
    - [Creating host aggregates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#creating-host-aggregates)
    - [Creating instance images](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#creating-instance-images)
  - Enrolling nodes
    - [Preparing inventory](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#preparing-inventory)
    - [Enrolling nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#id1)
    - [Populating host aggregates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#populating-host-aggregates)
    - [Checking available resources](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#checking-available-resources)
  - [Booting a bare metal instance](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#booting-a-bare-metal-instance)
  - [Booting a bare metal instance from a cinder volume](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#booting-a-bare-metal-instance-from-a-cinder-volume)
  - Configuring ml2-ansible for multi-tenant networking
    - [ml2-ansible configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#ml2-ansible-configuration)
    - [ml2-ansible example](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/baremetal_overcloud.html#ml2-ansible-example)
- Deploying with Composable Services
  - [Deploying with custom service lists](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/composable_services.html#deploying-with-custom-service-lists)
- Deploying with Custom Networks
  - [Default networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html#default-networks)
  - [Deploying with custom networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html#id1)
  - Network data YAML options
    - [Options for network data YAML subnet definitions](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html#options-for-network-data-yaml-subnet-definitions)
  - [Network Virtual IPs data YAML options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_networks.html#network-virtual-ips-data-yaml-options)
- Deploying with Custom Roles
  - [Provided example roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_roles.html#provided-example-roles)
  - [Deploying with custom roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/custom_roles.html#id1)
- Manage Virtual Persistent Memory (vPMEM)
  - [Prerequisite](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/compute_nvdimm.html#prerequisite)
  - [TripleO vPMEM parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/compute_nvdimm.html#tripleo-vpmem-parameters)
  - [Examples](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/compute_nvdimm.html#examples)
- Deploy an additional nova cell v2
  - Example 1. - Basic Cell Architecture in Train release
    - Extract deployment information from the overcloud stack
      - [Export EndpointMap, HostsEntry, AllNodesConfig, GlobalConfig and passwords information](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#export-endpointmap-hostsentry-allnodesconfig-globalconfig-and-passwords-information)
      - [Create roles file for the cell stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-roles-file-for-the-cell-stack)
      - [Create cell parameter file for additional customization (e.g. cell1/cell1.yaml)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-cell-parameter-file-for-additional-customization-e-g-cell1-cell1-yaml)
      - [Create the network configuration for cellcontroller and add to environment file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-the-network-configuration-for-cellcontroller-and-add-to-environment-file)
    - Deploy the cell
      - [Create new flavor used to tag the cell controller](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-new-flavor-used-to-tag-the-cell-controller)
      - [Run cell deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#run-cell-deployment)
    - [Create the cell and discover compute nodes (ansible playbook)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-the-cell-and-discover-compute-nodes-ansible-playbook)
    - Create the cell and discover compute nodes (manual way)
      - [Add cell information to overcloud controllers](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#add-cell-information-to-overcloud-controllers)
      - [Extract transport_url and database connection](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#extract-transport-url-and-database-connection)
      - [Create the cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-the-cell)
      - [Perform cell host discovery](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#perform-cell-host-discovery)
      - [Create and add the node to an Availability Zone](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_basic.html#create-and-add-the-node-to-an-availability-zone)
  - Example 2. - Split Cell controller/compute Architecture in Train release
    - Extract deployment information from the overcloud stack
      - [Create roles file for the cell stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-roles-file-for-the-cell-stack)
      - [Create cell parameter file for additional customization (e.g. cell1/cell1.yaml)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-cell-parameter-file-for-additional-customization-e-g-cell1-cell1-yaml)
      - [Create the network configuration for cellcontroller and add to environment file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-the-network-configuration-for-cellcontroller-and-add-to-environment-file)
    - Deploy the cell
      - [Create new flavor used to tag the cell controller](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-new-flavor-used-to-tag-the-cell-controller)
      - [Run cell deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#run-cell-deployment)
    - [Create the cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-the-cell)
    - Extract deployment information from the cell controller stack
      - [Export EndpointMap, HostsEntry, AllNodesConfig, GlobalConfig and passwords information](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#export-endpointmap-hostsentry-allnodesconfig-globalconfig-and-passwords-information)
      - [Create cell compute parameter file for additional customization](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-cell-compute-parameter-file-for-additional-customization)
    - Deploy the cell computes
      - [Run cell deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#id1)
      - [Perform cell host discovery](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#perform-cell-host-discovery)
      - [Create and add the node to an Availability Zone](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_advanced.html#create-and-add-the-node-to-an-availability-zone)
  - Example 3. - Advanced example using split cell controller/compute architecture and routed networks in Train release
    - [Used networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#used-networks)
    - [Prepare control plane for cell network routing](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#prepare-control-plane-for-cell-network-routing)
    - [Reuse networks and adding cell subnets](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#reuse-networks-and-adding-cell-subnets)
    - [Export EndpointMap, HostsEntry, AllNodesConfig, GlobalConfig and passwords information](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#export-endpointmap-hostsentry-allnodesconfig-globalconfig-and-passwords-information)
    - [Cell roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#cell-roles)
    - [Create the cell parameter file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#create-the-cell-parameter-file)
    - [Virtual IP addresses](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#virtual-ip-addresses)
    - [Create the network configuration for cellcontroller and add to environment file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#create-the-network-configuration-for-cellcontroller-and-add-to-environment-file)
    - Deploy the cell controllers
      - [Create new flavor used to tag the cell controller](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#create-new-flavor-used-to-tag-the-cell-controller)
      - [Run cell deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#run-cell-deployment)
    - [Create the cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#create-the-cell)
    - [Extract deployment information from the cell controller stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#extract-deployment-information-from-the-cell-controller-stack)
    - [Create cell compute parameter file for additional customization](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#create-cell-compute-parameter-file-for-additional-customization)
    - [Reusing networks from control plane and cell controller stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#reusing-networks-from-control-plane-and-cell-controller-stack)
    - Deploy the cell computes
      - [Run cell deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#id1)
      - [Perform cell host discovery](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#perform-cell-host-discovery)
      - [Create and add the node to an Availability Zone](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_routed.html#create-and-add-the-node-to-an-availability-zone)
  - Additional cell considerations and features
    - Availability Zones (AZ)
      - [Configuring AZs for Nova (compute)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_additional.html#configuring-azs-for-nova-compute)
    - [Routed networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_additional.html#routed-networks)
    - [Reusing networks from an already deployed stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_additional.html#reusing-networks-from-an-already-deployed-stack)
    - [Configuring nova-metadata API per-cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_additional.html#configuring-nova-metadata-api-per-cell)
  - Managing the cell
    - [Add a compute to a cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_manage_cell.html#add-a-compute-to-a-cell)
    - [Delete a compute from a cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_manage_cell.html#delete-a-compute-from-a-cell)
    - [Delete a cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_manage_cell.html#delete-a-cell)
    - [Updating a cell](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_cellv2_manage_cell.html#updating-a-cell)
- Deploy and Scale Swift in the Overcloud
  - [Initial Deploy](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_swift.html#initial-deploy)
  - [Scaling Swift](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_swift.html#scaling-swift)
  - [Viewing the Ring](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deploy_swift.html#viewing-the-ring)
- Using Already Deployed Servers
  - Deployed Server Requirements
    - Networking
      - [Network interfaces](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#network-interfaces)
      - [Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#undercloud)
      - [Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#overcloud)
      - [Testing Connectivity](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#testing-connectivity)
    - [Package repositories](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#package-repositories)
  - Deploying the Overcloud
    - [Provision networks and ports if using Neutron](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#provision-networks-and-ports-if-using-neutron)
    - Deployment Command
      - [With generated baremetal and network environments](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#with-generated-baremetal-and-network-environments)
      - [Without generated environments (no Neutron)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#without-generated-environments-no-neutron)
  - Scaling the Overcloud
    - [Scaling Up](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#scaling-up)
    - [Scaling Down](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#scaling-down)
  - [Deleting the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_server.html#deleting-the-overcloud)
- [Deploying DNSaaS (Designate)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/designate.html)
- Disable Telemetry
  - Deploy your overcloud without Telemetry services
    - [Disabling Notifications](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/disable_telemetry.html#disabling-notifications)
- Distributed Compute Node deployment
  - [Introduction](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#introduction)
  - Supported failure modes and High Availability recommendations
    - [Loss of control plane connectivity](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#loss-of-control-plane-connectivity)
    - [Loss of an edge site](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#loss-of-an-edge-site)
    - [Improving resiliency for N/S and E/W traffic](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#improving-resiliency-for-n-s-and-e-w-traffic)
    - [Network recommendations](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#network-recommendations)
    - [Config-drive/cloud-init details](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#config-drive-cloud-init-details)
    - [IPv6 details](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#ipv6-details)
    - [Storage recommendations](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#storage-recommendations)
  - Deploying DCN
    - Undercloud configuration
      - [Using direct deploy instead of iSCSI](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#using-direct-deploy-instead-of-iscsi)
      - [Configure the Swift temporary URL key](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#configure-the-swift-temporary-url-key)
      - [Configure nodes to use the deploy interface](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#configure-nodes-to-use-the-deploy-interface)
    - [Deploying the control plane](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#deploying-the-control-plane)
    - Deploying a DCN site
      - [Saving configuration from the overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#saving-configuration-from-the-overcloud)
      - [Network resource configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#network-resource-configuration)
      - [DCN related roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#dcn-related-roles)
      - Configuring Availability Zones (AZ)
        - [Configuring AZs for Nova (compute)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#configuring-azs-for-nova-compute)
        - [Configuring AZs for Cinder (storage)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#configuring-azs-for-cinder-storage)
        - [Deploying Ceph with HCI](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#deploying-ceph-with-hci)
        - [Sample environments](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#sample-environments)
    - Example: DCN deployment with pre-provisioned nodes, shared networks, and multiple stacks
      - [Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#undercloud)
      - [Deploy the control-plane stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#deploy-the-control-plane-stack)
      - [Exported configuration from the `control-plane` stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#exported-configuration-from-the-control-plane-stack)
      - [Deploy the central stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#deploy-the-central-stack)
      - [Deploy the edge-0 and edge-1 stacks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#deploy-the-edge-0-and-edge-1-stacks)
  - [Updating DCN](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#updating-dcn)
  - [Running Ansible across multiple DCN stacks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_compute_node.html#running-ansible-across-multiple-dcn-stacks)
- Distributed Multibackend Storage
  - [Features](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#features)
  - [Architecture](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#architecture)
  - [Stacks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#stacks)
  - Ceph Deployment Types
    - [Decide which cephx key will be used to access remote Ceph clusters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#decide-which-cephx-key-will-be-used-to-access-remote-ceph-clusters)
  - Deployment Steps
    - [Create a separate external Cephx key (optional)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#create-a-separate-external-cephx-key-optional)
    - [Create control-plane roles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#create-control-plane-roles)
    - [Deploy the central Ceph cluster](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#deploy-the-central-ceph-cluster)
    - [Deploy the control-plane stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#deploy-the-control-plane-stack)
    - [Extract overcloud control-plane and Ceph configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#extract-overcloud-control-plane-and-ceph-configuration)
    - [Create extra Ceph key for dcn0 (optional)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#create-extra-ceph-key-for-dcn0-optional)
    - [Override Glance defaults for dcn0](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#override-glance-defaults-for-dcn0)
    - [Create DCN roles for dcn0](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#create-dcn-roles-for-dcn0)
    - [Deploy the dcn0 Ceph cluster](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#deploy-the-dcn0-ceph-cluster)
    - [Deploy the dcn0 stack](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#deploy-the-dcn0-stack)
    - [Deploy additional DCN sites](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#deploy-additional-dcn-sites)
    - [Update central site to use additional Ceph clusters as Glance stores](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#update-central-site-to-use-additional-ceph-clusters-as-glance-stores)
  - [DCN using only External Ceph Clusters (optional)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#dcn-using-only-external-ceph-clusters-optional)
  - [Confirm images may be copied between sites](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#confirm-images-may-be-copied-between-sites)
  - [Confirm image-based volumes may be booted as DCN instances](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#confirm-image-based-volumes-may-be-booted-as-dcn-instances)
  - [Confirm image snapshots may be created and copied between sites](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/distributed_multibackend_storage.html#confirm-image-snapshots-may-be-created-and-copied-between-sites)
- Node customization and Third-Party Integration
  - [Firstboot extra configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/extra_config.html#firstboot-extra-configuration)
  - [Per-node extra configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/extra_config.html#per-node-extra-configuration)
  - [Post-Deploy extra configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/extra_config.html#post-deploy-extra-configuration)
- [Tolerate deployment failures](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tolerated_failure.html)
- [Configuring High Availability](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/high_availability.html)
- [Configuring Instance High Availability](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/instance_ha.html)
- Deploying with IPSec
  - [Solution Overview](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ipsec.html#solution-overview)
  - [Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ipsec.html#deployment)
  - [Verification](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ipsec.html#verification)
- [Keystone Security Compliance](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/keystone_security_compliance.html)
- [Enable LVM2 filtering on overcloud nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/lvmfilter.html)
- Multiple Overclouds from a Single Undercloud
  - [Requirements](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html#requirements)
  - [Undercloud Deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html#undercloud-deployment)
  - [First Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html#first-overcloud)
  - [Deploying Additional Overclouds](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html#deploying-additional-overclouds)
  - [Managing Heat Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html#managing-heat-templates)
  - [Using Pre-Provisioned Nodes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/multiple_overclouds.html#using-pre-provisioned-nodes)
- Configuring Network Isolation
  - [Introduction](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#introduction)
  - [Architecture](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#architecture)
  - [Workflow](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#workflow)
  - [Create and Edit network data YAML definition file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#create-and-edit-network-data-yaml-definition-file)
  - [Create the networks, segments and subnet resources on the Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#create-the-networks-segments-and-subnet-resources-on-the-undercloud)
  - [Create and Edit network Virtual IPs YAML definition file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#create-and-edit-network-virtual-ips-yaml-definition-file)
  - [Create the overcloud network Virtual IPs on the Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#create-the-overcloud-network-virtual-ips-on-the-undercloud)
  - [Generate Templates from Jinja2](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#generate-templates-from-jinja2)
  - [Create Network Environment Overrides File](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#create-network-environment-overrides-file)
  - [Configure IP Subnets](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#configure-ip-subnets)
  - [Configure Bonding Options](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#configure-bonding-options)
  - [Creating Custom Interface Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#creating-custom-interface-templates)
  - [Customizing the Interface Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#customizing-the-interface-templates)
  - [Migrating existing Network Interface Configuration Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#migrating-existing-network-interface-configuration-templates)
  - [Updating Existing Network Interface Configuration Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#updating-existing-network-interface-configuration-templates)
  - [Configuring Interfaces](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#configuring-interfaces)
  - [Configuring Routes and Default Routes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#configuring-routes-and-default-routes)
  - [Using a Dedicated Interface For Tenant VLANs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#using-a-dedicated-interface-for-tenant-vlans)
  - [Using the Native VLAN for Floating IPs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#using-the-native-vlan-for-floating-ips)
  - [Using the Native VLAN on a Trunked Interface](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#using-the-native-vlan-on-a-trunked-interface)
  - [Configuring Jumbo Frames](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#configuring-jumbo-frames)
  - [Assigning OpenStack Services to Isolated Networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#assigning-openstack-services-to-isolated-networks)
  - [Deploying the Overcloud With Network Isolation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#deploying-the-overcloud-with-network-isolation)
  - [Creating Floating IP Networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#creating-floating-ip-networks)
  - [Creating Provider Networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation.html#creating-provider-networks)
- Configuring Network Isolation in Virtualized Environments
  - [Introduction](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation_virt.html#introduction)
  - [Create an External VLAN on Your Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation_virt.html#create-an-external-vlan-on-your-undercloud)
  - [Create a Custom Environment File](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation_virt.html#create-a-custom-environment-file)
  - [Modify Your Overcloud Deploy to Enable Network Isolation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/network_isolation_virt.html#modify-your-overcloud-deploy-to-enable-network-isolation)
- Modifying default node configuration
  - [Making ansible variable changes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_config.html#making-ansible-variable-changes)
  - [Making puppet configuration changes](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_config.html#making-puppet-configuration-changes)
- Provisioning of node-specific Hieradata
  - [Collecting the node UUID](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_specific_hieradata.html#collecting-the-node-uuid)
  - [Creating the Heat environment file](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_specific_hieradata.html#creating-the-heat-environment-file)
  - [Generating the Heat environment file for Ceph devices](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_specific_hieradata.html#generating-the-heat-environment-file-for-ceph-devices)
  - [Deploying with NodeDataLookup](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/node_specific_hieradata.html#deploying-with-nodedatalookup)
- Deploying Octavia in the Overcloud
  - [Preparing to deploy](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/octavia.html#preparing-to-deploy)
  - [Configuring the amphora image](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/octavia.html#configuring-the-amphora-image)
  - [Deploying the overcloud with the octavia services](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/octavia.html#deploying-the-overcloud-with-the-octavia-services)
  - [Uploading/Updating the amphora image after deployment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/octavia.html#uploading-updating-the-amphora-image-after-deployment)
- Deploying Operational Tools
  - [Architecture](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ops_tools.html#architecture)
  - [Deploying the Operational Tool Server](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ops_tools.html#deploying-the-operational-tool-server)
  - [Deploying the Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ops_tools.html#deploying-the-undercloud)
  - [Before deploying the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ops_tools.html#before-deploying-the-overcloud)
- Configuring Messaging RPC and Notifications
  - [Standard Deployment of RabbitMQ Server Backend](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/oslo_messaging_config.html#standard-deployment-of-rabbitmq-server-backend)
  - [Deployment of Separate RPC and Notify Messaging Backends](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/oslo_messaging_config.html#deployment-of-separate-rpc-and-notify-messaging-backends)
- Deploying with OVS DPDK Support
  - [Deploy Command](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ovs_dpdk_config.html#deploy-command)
  - [Parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ovs_dpdk_config.html#parameters)
  - [Network Config](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ovs_dpdk_config.html#network-config)
- Deploying with SR-IOV Support
  - [Deploy Command](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/sriov_deployment.html#deploy-command)
  - [Parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/sriov_deployment.html#parameters)
  - [Network Config](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/sriov_deployment.html#network-config)
- Deploying with RHSM
  - [Summary](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/rhsm.html#summary)
  - [Using RHSM](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/rhsm.html#using-rhsm)
  - [Scale-down the Overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/rhsm.html#scale-down-the-overcloud)
  - [Transition from previous method](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/rhsm.html#transition-from-previous-method)
  - [More about the Ansible role](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/rhsm.html#more-about-the-ansible-role)
- [Role-Specific Parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/role_specific_parameters.html)
- Deploying Overcloud with L3 routed networking
  - [Layer 3 routed Requirements](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#layer-3-routed-requirements)
  - [Layer 3 routed Limitations](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#layer-3-routed-limitations)
  - [Create undercloud configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#create-undercloud-configuration)
  - [Install the undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#install-the-undercloud)
  - DHCP relay configuration
    - [Broadcast DHCP relay](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#broadcast-dhcp-relay)
    - [Unicast DHCP relay](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#unicast-dhcp-relay)
    - [DHCP relay configuration (Example)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#dhcp-relay-configuration-example)
  - [Map bare metal node ports to control plane network segments](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#map-bare-metal-node-ports-to-control-plane-network-segments)
  - [Create network data with multi-subnet networks](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#create-network-data-with-multi-subnet-networks)
  - [Create roles specific to each leaf (layer 2 segment)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#create-roles-specific-to-each-leaf-layer-2-segment)
  - [Configure node placement](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#configure-node-placement)
  - [Add role specific configuration to `parameter_defaults`](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#add-role-specific-configuration-to-parameter-defaults)
  - [Network configuration templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#network-configuration-templates)
  - [Virtual IP addresses (VIPs)](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#virtual-ip-addresses-vips)
  - [Deploy the overcloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/routed_spine_leaf_network.html#deploy-the-overcloud)
- Disabling updates to certain nodes
  - Server blacklist
    - [Setting the blacklist](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/server_blacklist.html#setting-the-blacklist)
    - [Clearing the blacklist](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/server_blacklist.html#clearing-the-blacklist)
  - [Skip deploy identifier](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/server_blacklist.html#skip-deploy-identifier)
- Security Hardening
  - [Horizon Password Validation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#horizon-password-validation)
  - Default Security Values in Horizon
    - [Enforce Password Check](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#enforce-password-check)
    - [Disallow Iframe Embed](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#disallow-iframe-embed)
    - [Disable Password Reveal](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#disable-password-reveal)
  - [SSH Banner Text](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#ssh-banner-text)
  - [Audit](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#audit)
  - Firewall Management
    - [VXLAN and nftables](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#vxlan-and-nftables)
  - AIDE - Intrusion Detection
    - [Further AIDE values](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#further-aide-values)
    - [Cron configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#cron-configuration)
    - [AIDE and Upgrades](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#aide-and-upgrades)
  - [SecureTTY](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#securetty)
  - [Keystone CADF auditing](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#keystone-cadf-auditing)
  - [login.defs values](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/security_hardening.html#login-defs-values)
- Splitting the Overcloud stack into multiple independent Heat stacks
  - [split-stack Requirements](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/split_stack.html#split-stack-requirements)
  - Default split-stack deployment
    - [Baremetal Deployment Command](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/split_stack.html#baremetal-deployment-command)
    - [Services Deployment Command](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/split_stack.html#services-deployment-command)
- Deploying with SSL
  - [Undercloud SSL](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html#undercloud-ssl)
  - Overcloud SSL
    - [Certificate and Public VIP Configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html#certificate-and-public-vip-configuration)
    - [Certificate Details](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html#certificate-details)
    - [DNS Endpoint Configuration](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html#dns-endpoint-configuration)
    - [Deploying an SSL Environment](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html#deploying-an-ssl-environment)
    - [Getting the overcloud to trust CAs](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/ssl.html#getting-the-overcloud-to-trust-cas)
- TLS Introduction
  - [Certmonger](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-introduction.html#certmonger)
  - FreeIPA
    - [Installing FreeIPA](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-introduction.html#installing-freeipa)
  - [Novajoin](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-introduction.html#novajoin)
  - [tripleo-ipa](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-introduction.html#tripleo-ipa)
- Deploying TLS-everywhere
  - TLS-everywhere with tripleo-ipa
    - [Configure DNS](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#configure-dns)
    - Configure FreeIPA
      - [Create a FreeIPA role](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#create-a-freeipa-role)
      - [Register the undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#register-the-undercloud)
      - [Create a principal](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#create-a-principal)
    - [Configure the Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#configure-the-undercloud)
    - [Undercloud Install](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#undercloud-install)
    - [Undercloud Verification](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#undercloud-verification)
  - TLS-everywhere with Novajoin
    - [Configure DNS](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#id1)
    - [Add Undercloud as a FreeIPA host](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#add-undercloud-as-a-freeipa-host)
    - [Configure the Undercloud](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#id2)
    - [Undercloud Install](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#id3)
    - [Undercloud Verification](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#id4)
  - Configuring the Overcloud
    - [Set Parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#set-parameters)
    - [Composable Services](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#composable-services)
    - [Novajoin Composable Service](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#novajoin-composable-service)
    - [tripleo-ipa Composable Service](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#tripleo-ipa-composable-service)
    - [Specify Templates](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#specify-templates)
  - [Overcloud Verification](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#overcloud-verification)
  - [Deleting Overclouds](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tls-everywhere.html#deleting-overclouds)
- Deploying custom tuned profiles
  - [Deploying with existing tuned profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tuned.html#deploying-with-existing-tuned-profiles)
  - [Deploying with custom tuned profiles](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/tuned.html#deploying-with-custom-tuned-profiles)
- (DEPRECATED) Installing a Undercloud Minion
  - [Installation Steps](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/undercloud_minion.html#installation-steps)
- Deploying with vDPA Support
  - [Deploy Command](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html#deploy-command)
  - [Parameters](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html#parameters)
  - [Network Config](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html#network-config)
  - [Network and Port Creation](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html#network-and-port-creation)
  - [Scheduling instances](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html#scheduling-instances)
  - [Validations](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/vdpa_deployment.html#validations)
- Configure node before Network Config
  - [Custom Service](https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/pre_network_config.html#custom-service)