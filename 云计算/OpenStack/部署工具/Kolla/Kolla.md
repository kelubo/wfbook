# Kolla

[TOC]

## 概述

Kolla 提供 Docker 容器和 Ansible playbook 来满足 Kolla 的使命。Kolla 的使命是为运营 OpenStack 云提供生产就绪型容器和部署工具。

Kolla 开箱即用，但允许完全定制。这使得经验最少的操作员可以快速部署 OpenStack，并且随着经验的增长，可以修改 OpenStack 配置以满足操作员的确切要求。

Kayobe 是 Kolla 的一个子项目，它使用 Kolla Ansible 和 Bifrost 将 OpenStack 控制平面部署到裸机上。

## 推荐阅读

在运行 Kolla Ansible 之前，学习 Ansible 和 Docker 的基础知识是有益的。

## 主机要求

主机必须满足以下最低要求：

- 2 个网络接口
- 8GB 内存
- 40GB 磁盘空间

See the [support matrix](https://docs.openstack.org/kolla-ansible/yoga/user/support-matrix) for details of supported host Operating Systems. Kolla Ansible supports the default Python 3.x versions provided by the supported Operating Systems. For more information see [tested runtimes](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/|TESTED_RUNTIMES_GOVERNANCE_URL|).
有关支持的主机操作系统的详细信息，请参阅支持矩阵。Kolla Ansible 支持受支持的操作系统提供的默认 Python 3.x 版本。有关详细信息，请参阅经过测试的运行时。

python 3.9

## 安装依赖

通常，在本节中使用系统包管理器的命令必须以 root 权限运行。

It is generally recommended to use a virtual environment to install Kolla Ansible and its dependencies, to avoid conflicts with the system site packages. Note that this is independent from the use of a virtual environment for remote execution, which is described in [Virtual Environments](https://docs.openstack.org/kolla-ansible/yoga/user/virtual-environments.html).
通常建议使用虚拟环境来安装 Kolla Ansible 及其依赖项，以避免与系统站点包发生冲突。请注意，这与使用虚拟环境进行远程执行无关，虚拟环境中对此进行了介绍。

1. 对于 Debian 或 Ubuntu，请更新软件包索引。

   ```bash
   sudo apt update
   ```

2. Install Python build dependencies:
   安装 Python 生成依赖项：

   对于 CentOS、Rocky 或 openEuler，请运行：

   ```bash
   dnf install git python3-devel libffi-devel gcc openssl-devel python3-libselinux
   ```

   对于 Debian 或 Ubuntu，请运行：

   ```bash
   sudo apt install git python3-dev libffi-dev gcc libssl-dev
   ```

### 安装虚拟环境的依赖项

1. 安装虚拟环境依赖项。

   对于 CentOS 、Rocky 或 openEuler，您不需要做任何事情。

   对于 Debian 或 Ubuntu，请运行：

   ```bash
   sudo apt install python3-venv
   ```

2. 创建一个虚拟环境并激活它：

   ```bash
   python3 -m venv /path/to/venv
   source /path/to/venv/bin/activate
   ```

   The virtual environment should be activated before running any commands that depend on packages installed in it.
   在运行依赖于其中安装的软件包的任何命令之前，应激活虚拟环境。

3. 确保安装了最新版本的 pip：

   ```bash
   pip install -U pip
   ```

4. 安装 Ansible 。Kolla Ansible 至少需要 Ansible `8` （或 ansible-core `2.15` ） 并支持高达 `9` （或 ansible-core `2.16` ） 。

   ```bash
   pip install 'ansible-core>=2.15,<2.16.99'
   ```

## 安装 Kolla-ansible

1. 使用 `pip` 安装 kolla-ansible 及其依赖项。

   ```bash
   pip install git+https://opendev.org/openstack/kolla-ansible@master
   ```
   
2. 创建 `/etc/kolla` 目录。

   ```bash
   sudo mkdir -p /etc/kolla
   sudo chown $USER:$USER /etc/kolla
   ```

3. 复制 `globals.yml` 和 `passwords.yml` 到 `/etc/kolla` 目录。

   ```bash
   cp -r /path/to/venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
   ```

4. 将 `all-in-one` 和 `multinode` inventory 文件复制到当前目录。

   ```bash
   cp /path/to/venv/share/kolla-ansible/ansible/inventory/* .
   ```

## 安装 Ansible Galaxy 依赖

```bash
kolla-ansible install-deps
```

## 准备初始配置

### Inventory 库存

下一步是准备 Inventory 文件，是一个 Ansible 文件。在其中指定主机及其所属的组。可以使用它来定义节点角色和访问凭据。

Kolla Ansible 附带了 `all-in-one` 和 `multinode` 示例清单文件。它们之间的区别在于，前者已经准备好在本地主机上部署单节点 OpenStack。如果需要使用多个节点，请编辑 `multinode` 清单：

1. Edit the first section of `multinode` with connection details of your environment,
   编辑 `multinode` 环境的连接详细信息的第一部分，例如：

   ```
   [control]
   10.0.0.[10:12] ansible_user=ubuntu ansible_password=foobar ansible_become=true
   # Ansible supports syntax like [10:12] - that means 10, 11 and 12.
   # Become clause means "use sudo".
   
   [network:children]
   control
   # when you specify group_name:children, it will use contents of group specified.
   
   [compute]
   10.0.0.[13:14] ansible_user=ubuntu ansible_password=foobar ansible_become=true
   
   [monitoring]
   10.0.0.10
   # This group is for monitoring node.
   # Fill it with one of the controllers' IP address or some others.
   
   [storage:children]
   compute
   
   [deployment]
   localhost       ansible_connection=local become=true
   # use localhost and sudo
   ```

   To learn more about inventory files, check [Ansible documentation](http://docs.ansible.com/ansible/latest/intro_inventory.html).
   要了解有关清单文件的更多信息，请查看 Ansible 文档。

2. Check whether the configuration of inventory is correct or not, run:
   检查库存配置是否正确，运行：

   ```
   ansible -i multinode all -m ping
   ```

   

    

   Note 注意

   

   Distributions might not come with Python pre-installed. That will cause errors in the `ping` module. To quickly install Python with Ansible you can run: for Debian or Ubuntu: `ansible -i multinode all -m raw -a "apt -y install python3"`, and for CentOS, RHEL or openEuler: `ansible -i multinode all -m raw -a "dnf -y install python3"`.
   发行版可能未预装 Python。这将导致 `ping` 模块中出现错误。要使用 Ansible 快速安装 Python，您可以运行： 对于 Debian 或 Ubuntu： `ansible -i multinode all -m raw -a "apt -y install python3"` ，对于 CentOS、RHEL 或 openEuler： `ansible -i multinode all -m raw -a "dnf -y install python3"` 。

### Kolla 密码

部署中使用的密码存储在 `/etc/kolla/passwords.yml` 文件中。此文件中的所有密码均为空，必须手动或通过运行随机密码生成器来填写：

```bash
kolla-genpwd
```

### Kolla globals.yml

`globals.yml` 是 Kolla Ansible 的主要配置文件，默认存储在 `/etc/kolla/` 中。部署 Kolla Ansible 需要几个选项：

- Image 选项

  用户必须指定将用于部署的映像。在本指南中，将使用 Quay.io 提供的预构建的映像。
  
  Kolla 在容器中提供了多种 Linux 发行版的选择：
  
  - CentOS Stream (`centos`)
  - Debian (`debian`)
  - Rocky (`rocky`)
  - Ubuntu (`ubuntu`）
  
  对于新手，建议使用 Rocky Linux 9 或 Ubuntu 22.04。
  
  ```yaml
  kolla_base_distro: "rocky"
  ```
  
- AArch64 选项

  Kolla 为 x86-64 和 aarch64 架构提供映像。它们不是“多架构”，因此 aarch64 的用户需要定义 “openstack_tag_suffix” 设置：

  ```yaml
  openstack_tag_suffix: "-aarch64"
  ```

  这样，将使用为 aarch64 架构构建的映像。

- 网络

  Kolla Ansible 需要设置一些网络选项。需要设置 OpenStack 使用的网络接口。

  要设置的第一个接口是 “network_interface” 。这是多个管理类型网络的默认接口。

  ```yaml
  network_interface: "eth0"
  ```

  Second interface required is dedicated for Neutron external (or public) networks, can be vlan or flat, depends on how the networks are created. 
  所需的第二个接口专用于 Neutron 外部（或公共）网络，可以是 vlan 或 flat ，具体取决于网络的创建方式。此接口应处于活动状态，无需 IP 地址。否则，实例将无法访问外部网络。

  ```yaml
  neutron_external_interface: "eth1"
  ```

  接下来，我们需要为管理流量提供浮动 IP (floating IP)。此 IP 将由 keepalived 管理以提供高可用性，and should be set to be *not used* address in management network that is connected to our `network_interface`. 并且应设置为连接到我们的 `network_interface` .If you use an existing OpenStack installation for your deployment, make sure the IP is allowed in the configuration of your VM.如果将现有的 OpenStack 安装用于部署，请确保在 VM 的配置中允许使用 IP。
  
  ```yaml
  kolla_internal_vip_address: "10.1.0.250"
  ```
  
- 启用其他服务

  Kolla Ansible provides a bare compute kit, however it does provide support for a vast selection of additional services.
  默认情况下，Kolla Ansible 提供了一个裸计算套件，但它确实提供了对大量附加服务的支持。若要启用它们，请设置为 `enable_*`  为 “ `yes` ” 。

- Multiple globals files 多个全局变量文件

  For a more granular control, enabling any option from the main `globals.yml` file can now be done using multiple yml files. Simply, create a directory called `globals.d` under `/etc/kolla/` and place all the relevant `*.yml` files in there. The `kolla-ansible` script will, automatically, add all of them as arguments to the `ansible-playbook` command.
  为了进行更精细的控制，现在可以使用多个 yml 文件来启用主 `globals.yml` 文件中的任何选项。简单地说，创建一个名为 `globals.d` under `/etc/kolla/` 的目录，并将所有相关 `*.yml` 文件放在其中。该 `kolla-ansible` 脚本会自动将它们全部作为参数添加到命令中 `ansible-playbook` 。

  An example use case for this would be if an operator wants to enable cinder and all its options, at a later stage than the initial deployment, without tampering with the existing `globals.yml` file. That can be achieved, using a separate `cinder.yml` file, placed under the `/etc/kolla/globals.d/` directory and adding all the relevant options in there.
  这方面的一个示例用例是，如果操作员希望在初始部署之后的阶段启用 cinder 及其所有选项，而不会篡改现有 `globals.yml` 文件。这可以通过使用单独的 `cinder.yml` 文件来实现，该文件放置在 `/etc/kolla/globals.d/` 目录下并在其中添加所有相关选项。

- 虚拟环境

  建议使用虚拟环境在远程主机上执行任务。

## 部署

设置配置后，可进入部署阶段。首先，需要设置基本的主机级依赖项，例如 docker。

Kolla Ansible 提供了一个 playbook ，它将按照正确版本安装所有的必需服务。

下面假设使用 `all-in-one` 清单。如果使用其他清单，例如 `multinode` ，请相应地替换 `-i` 参数。

1. Bootstrap servers with kolla deploy dependencies:
   具有 kolla 部署依赖项的 Bootstrap 服务器：

   ```bash
   kolla-ansible -i ./all-in-one bootstrap-servers
   ```

2. 对主机进行部署前检查：
   
   ```bash
   kolla-ansible -i ./all-in-one prechecks
   ```
   
3. 最后，继续进行实际的 OpenStack 部署：
   
   ```bash
   kolla-ansible -i ./all-in-one deploy
   ```

当这个 playbook 完成时，OpenStack should be up, running and functional! OpenStack 应该可以启动、运行和运行了！如果在执行过程中发生错误，请参阅故障排除指南。

## 使用 OpenStack

1. 安装 OpenStack CLI 客户端：
   
   ```bash
   pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master
   ```
   
2. OpenStack 需要一个 clouds.yaml 文件，其中设置了管理员用户的凭据。要生成此文件，请执行以下操作：
   
   ```bash
   kolla-ansible post-deploy
   ```

   > 注意：
   >
   > 该文件将在  `/etc/kolla/clouds.yaml`  中生成，可以通过将其复制到 `/etc/openstack` 或 `~/.config/openstack` 或通过设置 `OS_CLIENT_CONFIG_FILE` 环境变量来使用它。
   
3. 根据您安装 Kolla Ansible 的方式，有一个脚本可以创建示例网络、映像等。
   
   > 警告
   >
   > You are free to use the following `init-runonce` script for demo purposes but note it does **not** have to be run in order to use your cloud. Depending on your customisations, it may not work, or it may conflict with the resources you want to create. You have been warned.
   > 您可以自由地将以下 `init-runonce` 脚本用于演示目的，但请注意，不必运行它即可使用您的云。根据您的自定义项，它可能不起作用，或者可能与要创建的资源冲突。你已经被警告了。

   ```bash
   /path/to/venv/share/kolla-ansible/init-runonce
   ```



This page discusses how to add and remove nodes from an existing cluster. The procedure differs depending on the type of nodes being added or removed, which services are running, and how they are configured. Here we will consider two types of nodes - controllers and compute nodes. Other types of nodes will need consideration.
本页讨论如何在现有集群中添加和删除节点。该过程因添加或删除的节点类型、正在运行的服务以及它们的配置方式而异。在这里，我们将考虑两种类型的节点 - 控制器和计算节点。其他类型的节点将需要考虑。

Any procedure being used should be tested before being applied in a production environment.
在生产环境中应用之前，应先测试正在使用的任何过程。

## Adding new hosts 添加新主机 ¶



### Adding new controllers 添加新控制器 ¶

The [bootstrap-servers command](https://docs.openstack.org/kolla-ansible/latest/reference/deployment-and-bootstrapping/bootstrap-servers.html) can be used to prepare the new hosts that are being added to the system.  It adds an entry to `/etc/hosts` for the new hosts, and some services, such as RabbitMQ, require entries to exist for all controllers on every controller. If using a `--limit` argument, ensure that all controllers are included, e.g. via `--limit control`. Be aware of the [potential issues](https://docs.openstack.org/kolla-ansible/latest/reference/deployment-and-bootstrapping/bootstrap-servers.html#rebootstrapping) with running `bootstrap-servers` on an existing system.
bootstrap-servers 命令可用于准备要添加到系统中的新主机。它 `/etc/hosts` 为新主机添加一个条目，并且某些服务（如 RabbitMQ）要求每个控制器上的所有控制器都存在条目。如果使用 `--limit` 参数，请确保包含所有控制器，例如通过 `--limit control` .请注意在现有系统上运行 `bootstrap-servers` 的潜在问题。

```
kolla-ansible -i <inventory> bootstrap-servers [ --limit <limit> ]
```

Pull down container images to the new hosts. The `--limit` argument may be used and only needs to include the new hosts.
将容器映像下拉到新主机。可以使用该 `--limit` 参数，并且只需要包含新主机。

```
kolla-ansible -i <inventory> pull [ --limit <limit> ]
```

Deploy containers to the new hosts. If using a `--limit` argument, ensure that all controllers are included, e.g. via `--limit control`.
将容器部署到新主机。如果使用 `--limit` 参数，请确保包含所有控制器，例如通过 `--limit control` .

```
kolla-ansible -i <inventory> deploy [ --limit <limit> ]
```

The new controllers are now deployed. It is recommended to perform testing of the control plane at this point to verify that the new controllers are functioning correctly.
现在已部署新控制器。建议此时对控制平面进行测试，以验证新控制器是否正常工作。

Some resources may not be automatically balanced onto the new controllers. It may be helpful to manually rebalance these resources onto the new controllers. Examples include networks hosted by Neutron DHCP agent, and routers hosted by Neutron L3 agent. The [removing-existing-controllers](https://docs.openstack.org/kolla-ansible/latest/user/adding-and-removing-hosts.html#removing-existing-controllers) section provides an example of how to do this.
某些资源可能不会自动平衡到新控制器上。手动将这些资源重新平衡到新控制器上可能会有所帮助。示例包括由 Neutron DHCP 代理托管的网络和由 Neutron L3  代理托管的路由器。removing-existing-controllers 部分提供了如何执行此操作的示例。



### Adding new compute nodes 添加新的计算节点 ¶

The [bootstrap-servers command](https://docs.openstack.org/kolla-ansible/latest/reference/deployment-and-bootstrapping/bootstrap-servers.html), can be used to prepare the new hosts that are being added to the system.  Be aware of the [potential issues](https://docs.openstack.org/kolla-ansible/latest/reference/deployment-and-bootstrapping/bootstrap-servers.html#rebootstrapping) with running `bootstrap-servers` on an existing system.
bootstrap-servers 命令可用于准备要添加到系统中的新主机。请注意在现有系统上运行 `bootstrap-servers` 的潜在问题。

```
kolla-ansible -i <inventory> bootstrap-servers [ --limit <limit> ]
```

Pull down container images to the new hosts. The `--limit` argument may be used and only needs to include the new hosts.
将容器映像下拉到新主机。可以使用该 `--limit` 参数，并且只需要包含新主机。

```
kolla-ansible -i <inventory> pull [ --limit <limit> ]
```

Deploy containers on the new hosts. The `--limit` argument may be used and only needs to include the new hosts.
在新主机上部署容器。可以使用该 `--limit` 参数，并且只需要包含新主机。

```
kolla-ansible -i <inventory> deploy [ --limit <limit> ]
```

The new compute nodes are now deployed. It is recommended to perform testing of the compute nodes at this point to verify that they are functioning correctly.
现在已部署新的计算节点。建议此时对计算节点执行测试，以验证它们是否正常运行。

Server instances are not automatically balanced onto the new compute nodes. It may be helpful to live migrate some server instances onto the new hosts.
服务器实例不会自动平衡到新的计算节点上。将某些服务器实例实时迁移到新主机上可能会有所帮助。

```
openstack server migrate <server> --live-migration --host <target host> --os-compute-api-version 2.30
```

Alternatively, a service such as [Watcher](https://docs.openstack.org/watcher/latest//) may be used to do this automatically.
或者，可以使用 Watcher 等服务自动执行此操作。

## Removing existing hosts 删除现有主机 ¶



### Removing existing controllers 删除现有控制器 ¶

When removing controllers or other hosts running clustered services, consider whether enough hosts remain in the cluster to form a quorum. For example, in a system with 3 controllers, only one should be removed at a time. Consider also the effect this will have on redundancy.
删除运行群集服务的控制器或其他主机时，请考虑群集中是否保留了足够的主机以形成仲裁。例如，在具有 3 个控制器的系统中，一次只能删除一个控制器。还要考虑这将对冗余产生的影响。

Before removing existing controllers from a cluster, it is recommended to move resources they are hosting. Here we will cover networks hosted by Neutron DHCP agent and routers hosted by Neutron L3 agent. Other actions may be necessary, depending on your environment and configuration.
在从集群中删除现有控制器之前，建议移动它们托管的资源。在这里，我们将介绍由 Neutron DHCP 代理托管的网络和由 Neutron L3 代理托管的路由器。可能需要执行其他操作，具体取决于您的环境和配置。

For each host being removed, find Neutron routers on that host and move them. Disable the L3 agent. For example:
对于要删除的每个主机，找到该主机上的 Neutron 路由器并移动它们。禁用 L3 代理。例如：

```
l3_id=$(openstack network agent list --host <host> --agent-type l3 -f value -c ID)
target_l3_id=$(openstack network agent list --host <target host> --agent-type l3 -f value -c ID)
openstack router list --agent $l3_id -f value -c ID | while read router; do
  openstack network agent remove router $l3_id $router --l3
  openstack network agent add router $target_l3_id $router --l3
done
openstack network agent set $l3_id --disable
```

Repeat for DHCP agents:
对 DHCP 代理重复上述步骤：

```
dhcp_id=$(openstack network agent list --host <host> --agent-type dhcp -f value -c ID)
target_dhcp_id=$(openstack network agent list --host <target host> --agent-type dhcp -f value -c ID)
openstack network list --agent $dhcp_id -f value -c ID | while read network; do
  openstack network agent remove network $dhcp_id $network --dhcp
  openstack network agent add network $target_dhcp_id $network --dhcp
done
```

Stop all services running on the hosts being removed:
停止在要删除的主机上运行的所有服务：

```
kolla-ansible -i <inventory> stop --yes-i-really-really-mean-it [ --limit <limit> ]
```

Remove the hosts from the Ansible inventory.
从 Ansible 清单中删除主机。

Reconfigure the remaining controllers to update the membership of clusters such as MariaDB and RabbitMQ. Use a suitable limit, such as `--limit control`.
重新配置其余控制器以更新集群（如 MariaDB 和 RabbitMQ）的成员身份。使用合适的限制，例如 `--limit control` 。

```
kolla-ansible -i <inventory> deploy [ --limit <limit> ]
```

Perform testing to verify that the remaining cluster hosts are operating correctly.
执行测试以验证其余群集主机是否正常运行。

For each host, clean up its services:
对于每个主机，清理其服务：

```
openstack network agent list --host <host> -f value -c ID | while read id; do
  openstack network agent delete $id
done

openstack compute service list --os-compute-api-version 2.53 --host <host> -f value -c ID | while read id; do
  openstack compute service delete --os-compute-api-version 2.53 $id
done
```

If the node is also running the `etcd` service, set `etcd_remove_deleted_members: "yes"` in `globals.yml` to automatically remove nodes from the `etcd` cluster that have been removed from the inventory.
如果节点也在运行服务 `etcd` ，请设置为 `etcd_remove_deleted_members: "yes"`  `globals.yml` 自动从 `etcd` 群集中删除已从清单中删除的节点。

Alternatively the `etcd` members can be removed manually with `etcdctl`. For more details, please consult the `runtime reconfiguration` documentation section for the version of etcd in operation.
或者，可以使用 `etcdctl` 手动删除 `etcd` 成员。有关更多详细信息，请参阅 `runtime reconfiguration` 文档部分以了解正在运行的 etcd 版本。



### Removing existing compute nodes 删除现有计算节点 ¶

When removing compute nodes from a system, consider whether there is capacity to host the running workload on the remaining compute nodes. Include overhead for failures that may occur.
从系统中删除计算节点时，请考虑是否有容量在其余计算节点上托管正在运行的工作负载。包括可能发生的故障的开销。

Before removing compute nodes from a system, it is recommended to migrate or destroy any instances that they are hosting.
在从系统中删除计算节点之前，建议迁移或销毁它们托管的任何实例。

For each host, disable the compute service to ensure that no new instances are scheduled to it.
对于每个主机，禁用计算服务以确保不会为其计划新实例。

```
openstack compute service set <host> nova-compute --disable
```

If possible, live migrate instances to another host.
如果可能，请将实例实时迁移到另一台主机。

```
openstack server list --all-projects --host <host> -f value -c ID | while read server; do
  openstack server migrate --live-migration $server
done
```

Verify that the migrations were successful.
验证迁移是否成功。

Stop all services running on the hosts being removed:
停止在要删除的主机上运行的所有服务：

```
kolla-ansible -i <inventory> stop --yes-i-really-really-mean-it [ --limit <limit> ]
```

Remove the hosts from the Ansible inventory.
从 Ansible 清单中删除主机。

Perform testing to verify that the remaining cluster hosts are operating correctly.
执行测试以验证其余群集主机是否正常运行。

For each host, clean up its services:
对于每个主机，清理其服务：

```
openstack network agent list --host <host> -f value -c ID | while read id; do
  openstack network agent delete $id
done

openstack compute service list --os-compute-api-version 2.53 --host <host> -f value -c ID | while read id; do
  openstack compute service delete --os-compute-api-version 2.53 $id
done
```



## Tools versioning 工具版本控制

Kolla and Kolla Ansible use the `x.y.z` [semver](https://semver.org/) nomenclature for naming versions, with major version increasing with each new series, e.g., Wallaby. The tools are designed to, respectively, build and deploy Docker images of OpenStack services of that series. Users are advised to run the latest version of tools for the series they target, preferably by installing directly from the relevant branch of the Git repository, e.g.:
Kolla 和 Kolla Ansible 使用 `x.y.z` semver 命名法来命名版本，主要版本随着每个新系列的增加而增加，例如 Wallaby。这些工具分别用于构建和部署该系列OpenStack服务的Docker映像。建议用户运行其目标系列的最新版本的工具，最好直接从 Git 存储库的相关分支安装，例如：

```
pip3 install --upgrade git+https://opendev.org/openstack/kolla-ansible@master
```

## Version of deployed images 已部署镜像的版本

By default, Kolla Ansible will deploy or upgrade using the series name embedded in the internal config (`openstack_release`) and it is not recommended to tweak this unless using a local registry and a custom versioning policy, e.g., when users want to control when services are upgraded and to which version, possibly on a per-service basis (but this is an advanced use case scenario).
默认情况下，Kolla Ansible 将使用内部配置 （ `openstack_release` ） 中嵌入的系列名称进行部署或升级，除非使用本地注册表和自定义版本控制策略，例如，当用户想要控制服务何时升级以及升级到哪个版本时，可能基于每个服务（但这是一个高级用例场景）。

## Upgrade procedure 升级过程



 

Note 注意



This procedure is for upgrading from series to series, not for doing updates within a series. Inside a series, it is usually sufficient to just update the `kolla-ansible` package, rebuild (if needed) and pull the images, and run `kolla-ansible deploy` again. Please follow release notes to check if there are any issues to be aware of.
此过程用于从一个系列升级到另一个系列，而不是用于在系列中进行更新。在一个系列中，通常只需更新 `kolla-ansible` 包、重建（如果需要）并拉取映像，然后再次运行 `kolla-ansible deploy` 就足够了。请按照发行说明检查是否有任何需要注意的问题。



 

Note 注意



If you have set `enable_cells` to `yes` then you should read the upgrade notes in the [Nova cells guide](https://docs.openstack.org/kolla-ansible/latest/reference/compute/nova-cells-guide.html#nova-cells-upgrade).
如果您已设置为 `enable_cells`  `yes` ，则应阅读 Nova 单元指南中的升级说明。

Kolla’s strategy for upgrades is to never make a mess and to follow consistent patterns during deployment such that upgrades from one environment to the next are simple to automate.
Kolla 的升级策略是绝不弄乱，并在部署过程中遵循一致的模式，以便从一个环境升级到另一个环境易于自动化。

Kolla Ansible implements a single command operation for upgrading an existing deployment.
Kolla Ansible 实现单个命令操作来升级现有部署。

### Limitations and Recommendations 限制与建议



 

Warning 警告



Please notice that using the ansible `--limit` option is not recommended. The reason is, that there are known bugs with it, e.g. when [upgrading parts of nova.](https://bugs.launchpad.net/kolla-ansible/+bug/2054348) We accept bug reports for this and try to fix issues when they are known. The core problem is how the `register:` keyword works and how it interacts with the `--limit` option. You can find more information in the above bug report.
请注意，不建议使用 ansible `--limit` 选项。原因是，它存在已知的错误，例如在升级 nova 的某些部分时。我们接受这方面的错误报告，并在已知问题时尝试修复。核心问题是 `register:` 关键字如何工作以及它如何与 `--limit` 选项交互。您可以在上面的错误报告中找到更多信息。



 

Note 注意



Please note that when the `use_preconfigured_databases` flag is set to `"yes"`, you need to have the `log_bin_trust_function_creators` set to `1` by your database administrator before performing the upgrade.
请注意，当 `use_preconfigured_databases` 标志设置为 `"yes"` 时，您需要在执行升级之前 `1` 由数据库管理员 `log_bin_trust_function_creators` 将其设置为。



 

Note 注意



If you have separate keys for nova and cinder, please be sure to set `ceph_nova_keyring: ceph.client.nova.keyring` and `ceph_nova_user: nova` in `/etc/kolla/globals.yml`
如果您有单独的 nova 和 cinder 键，请务必设置 `ceph_nova_keyring: ceph.client.nova.keyring` 并 `ceph_nova_user: nova` 进入 `/etc/kolla/globals.yml` 

### Ubuntu Jammy 22.04

The Zed release adds support for Ubuntu Jammy 22.04 as a host operating system. Ubuntu Jammy 22.04 support was also added to the Yoga stable release. Ubuntu Focal 20.04 users upgrading from Yoga can thus directly upgrade to Ubuntu Jammy 22.04 on the host and then upgrade to the Zed release.
Zed 版本增加了对 Ubuntu Jammy 22.04 作为主机操作系统的支持。Ubuntu Jammy 22.04 支持也添加到了 Yoga  稳定版本中。因此，从 Yoga 升级的 Ubuntu Focal 20.04 用户可以直接在主机上升级到 Ubuntu Jammy  22.04，然后升级到 Zed 版本。

### CentOS Stream 8

The Wallaby release adds support for CentOS Stream 8 as a host operating system. CentOS Stream 8 support will also be added to a Victoria stable release. CentOS Linux users upgrading from Victoria should first migrate hosts and container images from CentOS Linux to CentOS Stream before upgrading to Wallaby.
Wallaby 发行增加了对 CentOS Stream 8 作为主机操作系统的支持。CentOS Stream 8 的支持也将加入到维多利亚稳定版中。从  Victoria 升级的 CentOS Linux 用户应先将主机和容器镜像从 CentOS Linux 迁移到 CentOS  Stream，然后再升级到 Wallaby。

### Preparation (the foreword) 准备（前言） ¶

Before preparing the upgrade plan and making any decisions, please read the [release notes](https://docs.openstack.org/releasenotes/kolla-ansible/index.html) for the series you are targeting, especially the Upgrade notes that we publish for your convenience and awareness.
在准备升级计划和做出任何决定之前，请阅读您所针对的系列的发行说明，尤其是我们发布的升级说明，以便您方便和了解。

Before you begin, **make a backup of your config**. On the operator/deployment node, copy the contents of the config directory (`/etc/kolla` by default) to a backup place (or use versioning tools, like git, to keep previous versions of config in a safe place).
在开始之前，请备份您的配置。在 operator/deployment 节点上，将 config 目录的内容（ `/etc/kolla` 默认情况下）复制到备份位置（或使用版本控制工具（如 git）将以前版本的 config 保存在安全位置）。

### Preparation (the real deal) 准备工作（真正的交易） ¶

First, upgrade the `kolla-ansible` package:
首先，升级 `kolla-ansible` 软件包：

```
pip3 install --upgrade git+https://opendev.org/openstack/kolla-ansible@master
```



 

Note 注意



If you are running from Git repository, then just checkout the desired branch and run `pip3 install --upgrade` with the repository directory.
如果您从 Git 存储库运行，则只需签出所需的分支并使用存储库目录运行 `pip3 install --upgrade` 即可。

If performing a skip-level (SLURP) upgrade, update `ansible` or `ansible-core` to a version supported by the release you’re upgrading to.
如果执行跳级 （SLURP） 升级、更新 `ansible` 或 `ansible-core` 升级到的版本支持的版本。

```
pip3 install --upgrade 'ansible-core>=2.15,<2.16.99'
```

If upgrading to a Yoga release or later, install or upgrade Ansible Galaxy dependencies:
如果升级到 Yoga 版本或更高版本，请安装或升级 Ansible Galaxy 依赖项：

```
kolla-ansible install-deps
```

The inventory file for the deployment should be updated, as the newer sample inventory files may have updated layout or other relevant changes. The `diff` tool (or similar) is your friend in this task. If using a virtual environment, the sample inventories are in `/path/to/venv/share/kolla-ansible/ansible/inventory/`, else they are most likely in `/usr/local/share/kolla-ansible/ansible/inventory/`.
应更新部署的清单文件，因为较新的示例清单文件可能具有更新的布局或其他相关更改。该 `diff` 工具（或类似工具）是您在此任务中的朋友。如果使用虚拟环境，则样本清单位于 `/path/to/venv/share/kolla-ansible/ansible/inventory/` 中，否则它们很可能位于 `/usr/local/share/kolla-ansible/ansible/inventory/` 中。

Other files which may need manual updating are:
其他可能需要手动更新的文件包括：

- `/etc/kolla/globals.yml`
- `/etc/kolla/passwords.yml`

For `globals.yml`, it is best to follow the release notes (mentioned above). For `passwords.yml`, one needs to use `kolla-mergepwd` and `kolla-genpwd` tools.
对于 `globals.yml` ，最好遵循发行说明（如上所述）。对于 `passwords.yml` ，需要使用 `kolla-mergepwd` 和 `kolla-genpwd` 工具。

`kolla-mergepwd --old OLD_PASSWDS --new NEW_PASSWDS --final FINAL_PASSWDS` is used to merge passwords from old installation with newly generated passwords. The workflow is:
 `kolla-mergepwd --old OLD_PASSWDS --new NEW_PASSWDS --final FINAL_PASSWDS` 用于将旧安装中的密码与新生成的密码合并。工作流程为：

1. Save old passwords from `/etc/kolla/passwords.yml` into `passwords.yml.old`.
   将旧密码保存到 `/etc/kolla/passwords.yml` `passwords.yml.old` .
2. Generate new passwords via `kolla-genpwd` as `passwords.yml.new`.
   通过 `kolla-genpwd` as `passwords.yml.new` 生成新密码。
3. Merge `passwords.yml.old` and `passwords.yml.new` into `/etc/kolla/passwords.yml`.
   合并 `passwords.yml.old` 并 `passwords.yml.new` 进入 `/etc/kolla/passwords.yml` .

For example: 例如：

```
cp /etc/kolla/passwords.yml passwords.yml.old
cp kolla-ansible/etc/kolla/passwords.yml passwords.yml.new
kolla-genpwd -p passwords.yml.new
kolla-mergepwd --old passwords.yml.old --new passwords.yml.new --final /etc/kolla/passwords.yml
```



 

Note 注意



`kolla-mergepwd`, by default, keeps old, unused passwords intact. To alter this behavior, and remove such entries, use the `--clean` argument when invoking `kolla-mergepwd`.
 `kolla-mergepwd` ，默认情况下，将保留旧的、未使用的密码不变。若要更改此行为并删除此类条目，请在调用时使用参数 `--clean` `kolla-mergepwd` 。

Run the command below to pull the new images on target hosts:
运行以下命令以在目标主机上拉取新映像：

```
kolla-ansible pull
```

It is also recommended to run prechecks to identify potential configuration issues:
还建议运行预检查以识别潜在的配置问题：

```
kolla-ansible prechecks
```

At a convenient time, the upgrade can now be run.
在方便的时候，现在可以运行升级。

### Perform the Upgrade 执行升级 ¶

To perform the upgrade:
要执行升级，请执行以下操作：

```
kolla-ansible upgrade
```

After this command is complete, the containers will have been recreated from the new images and all database schema upgrades and similar actions performed for you.
完成此命令后，将从新映像重新创建容器，并为您执行所有数据库架构升级和类似操作。

### Cleanup the Keystone admin port (Zed only) 清理 Keystone 管理端口（仅限 Zed） ¶

The Keystone admin port is no longer used in Zed. The admin interface points to the common port. However, during upgrade, the port is preserved for intermediate compatibility. To clean up the port, it is necessary to run the `deploy` action for Keystone. Additionally, the generated `admin-openrc.sh` file may need regeneration as it used the admin port:
Zed 中不再使用 Keystone 管理端口。管理界面指向公共端口。但是，在升级过程中，将保留该端口以实现中间兼容性。若要清理端口，必须运行 Keystone `deploy` 的操作。此外，生成 `admin-openrc.sh` 的文件可能需要重新生成，因为它使用了管理端口：

```
kolla-ansible deploy --tags keystone
kolla-ansible post-deploy
```

After these commands are complete, there are no leftovers of the admin port.
完成这些命令后，管理端口就没有剩余部分。

## Tips and Tricks 技巧和窍门

### Kolla Ansible CLI 查看 Ansible CLI

When running the `kolla-ansible` CLI, additional arguments may be passed to `ansible-playbook` via the `EXTRA_OPTS` environment variable.
运行 CLI `kolla-ansible` 时，可以通过 `EXTRA_OPTS` 环境变量传递其他 `ansible-playbook` 参数。

`kolla-ansible -i INVENTORY deploy` is used to deploy and start all Kolla containers.
 `kolla-ansible -i INVENTORY deploy` 用于部署和启动所有 Kolla 容器。

`kolla-ansible -i INVENTORY destroy` is used to clean up containers and volumes in the cluster.
 `kolla-ansible -i INVENTORY destroy` 用于清理集群中的容器和卷。

`kolla-ansible -i INVENTORY mariadb_recovery` is used to recover a completely stopped mariadb cluster.
 `kolla-ansible -i INVENTORY mariadb_recovery` 用于恢复完全停止的 MariaDB 集群。

`kolla-ansible -i INVENTORY prechecks` is used to check if all requirements are meet before deploy for each of the OpenStack services.
 `kolla-ansible -i INVENTORY prechecks` 用于在为每个 OpenStack 服务部署之前检查是否满足所有要求。

`kolla-ansible -i INVENTORY post-deploy` is used to do post deploy on deploy node to get the admin openrc file.
 `kolla-ansible -i INVENTORY post-deploy` 用于在部署节点上执行后部署以获取管理 OpenRC 文件。

`kolla-ansible -i INVENTORY pull` is used to pull all images for containers.
 `kolla-ansible -i INVENTORY pull` 用于拉取容器的所有映像。

`kolla-ansible -i INVENTORY reconfigure` is used to reconfigure OpenStack service.
 `kolla-ansible -i INVENTORY reconfigure` 用于重新配置 OpenStack 服务。

`kolla-ansible -i INVENTORY upgrade` is used to upgrades existing OpenStack Environment.
 `kolla-ansible -i INVENTORY upgrade` 用于升级现有的 OpenStack 环境。

`kolla-ansible -i INVENTORY stop` is used to stop running containers.
 `kolla-ansible -i INVENTORY stop` 用于停止运行容器。

`kolla-ansible -i INVENTORY deploy-containers` is used to check and if necessary update containers, without generating configuration.
 `kolla-ansible -i INVENTORY deploy-containers` 用于检查并在必要时更新容器，而无需生成配置。

`kolla-ansible -i INVENTORY prune-images` is used to prune orphaned Docker images on hosts.
 `kolla-ansible -i INVENTORY prune-images` 用于修剪主机上的孤立 Docker 映像。

`kolla-ansible -i INVENTORY genconfig` is used to generate configuration files for enabled OpenStack services, without then restarting the containers so it is not applied right away.
 `kolla-ansible -i INVENTORY genconfig` 用于为已启用的 OpenStack 服务生成配置文件，而无需重新启动容器，因此不会立即应用。

`kolla-ansible -i INVENTORY1 -i INVENTORY2 ...` Multiple inventories can be specified by passing the `--inventory` or `-i` command line option multiple times. This can be useful to share configuration between multiple environments. Any common configuration can be set in `INVENTORY1` and `INVENTORY2` can be used to set environment specific details.
 `kolla-ansible -i INVENTORY1 -i INVENTORY2 ...` 可以通过多次传递 `--inventory` or `-i` 命令行选项来指定多个清单。这对于在多个环境之间共享配置非常有用。可以在中 `INVENTORY1` 设置任何通用配置，并 `INVENTORY2` 可用于设置特定于环境的详细信息。

`kolla-ansible -i INVENTORY gather-facts` is used to gather Ansible facts, for example to populate a fact cache.
 `kolla-ansible -i INVENTORY gather-facts` 用于收集 Ansible 事实，例如填充事实缓存。

### Using Hashicorp Vault for password storage 使用 Hashicorp Vault 进行密码存储

Hashicorp Vault can be used as an alternative to Ansible Vault for storing passwords generated by Kolla Ansible. To use Hashicorp Vault as the secrets store you will first need to generate the passwords, and then you can save them into an existing KV using the following command:
Hashicorp Vault 可用作 Ansible Vault 的替代方案，用于存储由 Kolla Ansible 生成的密码。要使用 Hashicorp Vault 作为密钥存储，您首先需要生成密码，然后可以使用以下命令将它们保存到现有的 KV 中：

```
kolla-writepwd \
--passwords /etc/kolla/passwords.yml \
--vault-addr <VAULT_ADDRESS> \
--vault-token <VAULT_TOKEN>
```



 

Note 注意



For a full list of `kolla-writepwd` arguments, use the `--help` argument when invoking `kolla-writepwd`.
有关参数的完整 `kolla-writepwd` 列表，请在调用时使用该 `--help` 参数 `kolla-writepwd` 。

To read passwords from Hashicorp Vault and generate a passwords.yml:
要从 Hashicorp Vault 读取密码并生成passwords.yml：

```
mv kolla-ansible/etc/kolla/passwords.yml /etc/kolla/passwords.yml
kolla-readpwd \
--passwords /etc/kolla/passwords.yml \
--vault-addr <VAULT_ADDRESS> \
--vault-token <VAULT_TOKEN>
```

### Tools 工具

Kolla ships with several utilities intended to facilitate ease of operation.
Kolla 附带了多个实用程序，旨在促进操作的便利性。

`tools/cleanup-containers` is used to remove deployed containers from the system. This can be useful when you want to do a new clean deployment. It will preserve the registry and the locally built images in the registry, but will remove all running Kolla containers from the local Docker daemon. It also removes the named volumes.
 `tools/cleanup-containers` 用于从系统中删除已部署的容器。当您想要执行新的干净部署时，这可能很有用。它将保留注册表和注册表中本地构建的映像，但会从本地 Docker 守护程序中删除所有正在运行的 Kolla 容器。它还会删除命名卷。

`tools/cleanup-host` is used to remove remnants of network changes triggered on the Docker host when the neutron-agents containers are launched. This can be useful when you want to do a new clean deployment, particularly one changing the network topology.
 `tools/cleanup-host` 用于删除启动 neutron-agents 容器时在 Docker 主机上触发的网络更改的残余。当您想要执行新的干净部署时，特别是更改网络拓扑的部署时，这可能很有用。

`tools/cleanup-images --all` is used to remove all Docker images built by Kolla from the local Docker cache.
 `tools/cleanup-images --all` 用于从本地 Docker 缓存中删除 Kolla 构建的所有 Docker 映像。
