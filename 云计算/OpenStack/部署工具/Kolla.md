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
