# Kolla

[TOC]

## 概述

Kolla 提供 Docker 容器和 Ansible playbook 来满足 Kolla 的使命。Kolla 的使命是为运营 OpenStack 云提供生产就绪型容器和部署工具。

Kolla 开箱即用，但允许完全定制。这使得经验最少的操作员可以快速部署 OpenStack，并且随着经验的增长，可以修改 OpenStack 配置以满足操作员的确切要求。

## 推荐阅读

在运行 Kolla Ansible 之前，学习 Ansible 和 Docker 的基础知识是有益的。

## 主机要求

主机必须满足以下最低要求：

- 2 个网络接口
- 8GB 主内存
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

   对于 CentOS、RHEL 8 或 openEuler，请运行：

   ```bash
   dnf install git python3-devel libffi-devel gcc openssl-devel python3-libselinux
   ```

   对于 Debian 或 Ubuntu，请运行：

   ```bash
   sudo apt install git python3-dev libffi-dev gcc libssl-dev
   ```

### 使用虚拟环境安装依赖项

如果不在虚拟环境中安装 Kolla Ansible，请跳过此部分。

1. 安装虚拟环境依赖项。

   对于 CentOS、RHEL 8 或 openEuler，您不需要做任何事情。

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

4. 安装 Ansible 。Kolla Ansible 至少需要 Ansible `6` （或 ansible-core `2.14` ） 并支持高达 `7` （或 ansible-core `2.15` ） 。

   ```bash
   pip install 'ansible-core>=2.14,<2.16'
   ```

### 安装不使用虚拟环境的依赖项

如果在虚拟环境中安装 Kolla Ansible，请跳过此部分。

1. 安装 `pip` .

   对于 CentOS、RHEL 或 openEuler，运行：

   ```bash
   sudo dnf install python3-pip
   ```

   对于 Debian 或 Ubuntu，请运行：

   ```bash
   sudo apt install python3-pip
   ```

2. 确保安装了最新版本的 pip：

   ```bash
   sudo pip3 install -U pip
   ```

3. 安装 Ansible。Kolla Ansible 至少需要 Ansible `4` ，并且最多支持 `5` .

   对于 CentOS 或 RHEL，请运行：

   ```bash
   sudo dnf install ansible
   ```

   对于 openEuler，运行：

   ```bash
   sudo pip install ansible
   ```

   对于 Debian 或 Ubuntu，请运行：

   ```bash
   sudo apt install ansible
   ```

   > Note 注意
   >
   > If the installed Ansible version does not meet the requirements, one can use pip: `sudo pip install -U 'ansible>=4,<6'`. Beware system package upgrades might interfere with that so it is recommended to uninstall the system package first. One might be better off with the virtual environment method to avoid this pitfall.
   > 如果安装的 Ansible 版本不符合要求，可以使用 pip： `sudo pip install -U 'ansible>=4,<6'` 。请注意，系统软件包升级可能会干扰这一点，因此建议先卸载系统软件包。最好使用虚拟环境方法来避免这种陷阱。

## 安装 Kolla-ansible

1. 使用 `pip` 安装 kolla-ansible 及其依赖项。

   如果使用虚拟环境：

   ```bash
   pip install git+https://opendev.org/openstack/kolla-ansible@|KOLLA_BRANCH_NAME|
   ```

2. 创建 `/etc/kolla` 目录。

   ```bash
   sudo mkdir -p /etc/kolla
   sudo chown $USER:$USER /etc/kolla
   ```

3. 复制 `globals.yml` 并 `passwords.yml` 复制到 `/etc/kolla` 目录。

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

## Prepare initial configuration[¶](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/quickstart.html#prepare-initial-configuration) 准备初始配置 ¶

### Inventory[¶](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/quickstart.html#inventory) 库存 ¶

The next step is to prepare our inventory file. An inventory is an Ansible file where we specify hosts and the groups that they belong to. We can use this to define node roles and access credentials.
下一步是准备我们的库存文件。清单是一个 Ansible 文件，我们在其中指定主机及其所属的组。我们可以使用它来定义节点角色和访问凭据。

Kolla Ansible comes with `all-in-one` and `multinode` example inventory files. The difference between them is that the former is ready for deploying single node OpenStack on localhost. If you need to use separate host or more than one node, edit `multinode` inventory:
Kolla Ansible 附带 `all-in-one` 了 `multinode` 示例清单文件。它们之间的区别在于，前者已经准备好在本地主机上部署单节点 OpenStack。如果需要使用单独的主机或多个节点，请编辑 `multinode` 清单：

1. Edit the first section of `multinode` with connection details of your environment, for example:
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

### Kolla passwords[¶](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/quickstart.html#kolla-passwords) 检查密码 ¶

Passwords used in our deployment are stored in `/etc/kolla/passwords.yml` file. All passwords are blank in this file and have to be filled either manually or by running random password generator:
部署中使用的密码存储在 `/etc/kolla/passwords.yml` 文件中。此文件中的所有密码均为空，必须手动或通过运行随机密码生成器来填写：

For deployment or evaluation, run:
对于部署或评估，请运行：

```
kolla-genpwd
```

For development, run: 对于开发，请运行：

```
cd kolla-ansible/tools
./generate_passwords.py
```

### Kolla globals.yml[¶](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/quickstart.html#kolla-globals-yml) 检查globals.yml ¶

`globals.yml` is the main configuration file for Kolla Ansible. There are a few options that are required to deploy Kolla Ansible:
 `globals.yml` 是 Kolla Ansible 的主要配置文件。部署 Kolla Ansible 需要几个选项：

- Image options 图像选项

  User has to specify images that are going to be used for our deployment. In this guide [Quay.io](https://quay.io/organization/openstack.kolla)-provided, pre-built images are going to be used. To learn more about building mechanism, please refer [Building Container Images](https://docs.openstack.org/kolla/yoga/admin/image-building.html).
  用户必须指定将用于部署的映像。在本指南中，Quay.io 将使用预构建的映像。要了解有关构建机制的更多信息，请参阅构建容器镜像。

  Kolla provides choice of several Linux distributions in containers:
  Kolla 在容器中提供了多种 Linux 发行版的选择：

  - CentOS Stream (`centos`)
    CentOS 流 （ `centos` ）
  - Ubuntu (`ubuntu`) Ubuntu的 （ `ubuntu` ）
  - Debian (`debian`) Debian （ `debian` ）
  - RHEL (`rhel`, deprecated)
    RHEL （ `rhel` ， 已弃用）

  For newcomers, we recommend to use CentOS Stream 8 or Ubuntu 20.04.
  对于新手，我们建议使用 CentOS Stream 8 或 Ubuntu 20.04。

  ```
  kolla_base_distro: "centos"
  ```

  Next “type” of installation needs to be configured. Choices are:
  下一个“类型”安装需要配置。选项有：

  - binary 二元的

    using repositories like apt or dnf 使用 apt 或 dnf 等存储库

  - source (default) source（默认）

    using raw source archives, git repositories or local source directory 使用原始源存档、Git 存储库或本地源目录

  

   

  Note 注意

  

  This only affects OpenStack services. Infrastructure services are always “binary”.
  这只会影响 OpenStack 服务。基础结构服务始终是“二进制”的。

  

   

  Note 注意

  

  Source builds are proven to be slightly more reliable than binary.
  源代码构建被证明比二进制版本更可靠。

  ```
  kolla_install_type: "source"
  ```

- Networking 联网

  Kolla Ansible requires a few networking options to be set. We need to set network interfaces used by OpenStack.
  Kolla Ansible 需要设置一些网络选项。我们需要设置 OpenStack 使用的网络接口。

  First interface to set is “network_interface”. This is the default interface for multiple management-type networks.
  要设置的第一个接口是“network_interface”。这是多个管理类型网络的默认接口。

  ```
  network_interface: "eth0"
  ```

  Second interface required is dedicated for Neutron external (or public) networks, can be vlan or flat, depends on how the networks are created. This interface should be active without IP address. If not, instances won’t be able to access to the external networks.
  所需的第二个接口专用于 Neutron 外部（或公共）网络，可以是 vlan 或平面，具体取决于网络的创建方式。此接口应处于活动状态，无需 IP 地址。否则，实例将无法访问外部网络。

  ```
  neutron_external_interface: "eth1"
  ```

  To learn more about network configuration, refer [Network overview](https://docs.openstack.org/kolla-ansible/yoga/admin/production-architecture-guide.html#network-configuration).
  要了解有关网络配置的更多信息，请参阅网络概述。

  Next we need to provide floating IP for management traffic. This IP will be managed by keepalived to provide high availability, and should be set to be *not used* address in management network that is connected to our `network_interface`.
  接下来，我们需要为管理流量提供浮动 IP。此 IP 将由 keepalived 管理以提供高可用性，并且应设置为连接到我们的 `network_interface` .

  ```
  kolla_internal_vip_address: "10.1.0.250"
  ```

- Enable additional services
  启用其他服务

  By default Kolla Ansible provides a bare compute kit, however it does provide support for a vast selection of additional services. To enable them, set `enable_*` to “yes”. For example, to enable Block Storage service:
  默认情况下，Kolla Ansible 提供了一个裸计算套件，但它确实提供了对大量附加服务的支持。若要启用它们，请设置为 `enable_*` “是”。例如，要启用块存储服务，请执行以下操作：

  ```
  enable_cinder: "yes"
  ```

  Kolla now supports many OpenStack services, there is [a list of available services](https://github.com/openstack/kolla-ansible/blob/master/README.rst#openstack-services). For more information about service configuration, Please refer to the [Services Reference Guide](https://docs.openstack.org/kolla-ansible/yoga/reference/index.html).
  Kolla 现在支持许多 OpenStack 服务，有一个可用服务的列表。有关服务配置的更多信息，请参阅服务参考指南。

- Multiple globals files 多个全局变量文件

  For a more granular control, enabling any option from the main `globals.yml` file can now be done using multiple yml files. Simply, create a directory called `globals.d` under `/etc/kolla/` and place all the relevant `*.yml` files in there. The `kolla-ansible` script will, automatically, add all of them as arguments to the `ansible-playbook` command.
  为了进行更精细的控制，现在可以使用多个 yml 文件来启用主 `globals.yml` 文件中的任何选项。简单地说，创建一个名为 `globals.d` under `/etc/kolla/` 的目录，并将所有相关 `*.yml` 文件放在其中。该 `kolla-ansible` 脚本会自动将它们全部作为参数添加到命令中 `ansible-playbook` 。

  An example use case for this would be if an operator wants to enable cinder and all its options, at a later stage than the initial deployment, without tampering with the existing `globals.yml` file. That can be achieved, using a separate `cinder.yml` file, placed under the `/etc/kolla/globals.d/` directory and adding all the relevant options in there.
  这方面的一个示例用例是，如果操作员希望在初始部署之后的阶段启用 cinder 及其所有选项，而不会篡改现有 `globals.yml` 文件。这可以通过使用单独的 `cinder.yml` 文件来实现，该文件放置在 `/etc/kolla/globals.d/` 目录下并在其中添加所有相关选项。

- Virtual environment 虚拟环境

  It is recommended to use a virtual environment to execute tasks on the remote hosts.  This is covered [Virtual Environments](https://docs.openstack.org/kolla-ansible/yoga/user/virtual-environments.html).
  建议使用虚拟环境在远程主机上执行任务。这是虚拟环境所涵盖的。

## Deployment[¶](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/quickstart.html#deployment) 部署 ¶

After configuration is set, we can proceed to the deployment phase. First we need to setup basic host-level dependencies, like docker.
设置配置后，我们可以进入部署阶段。首先，我们需要设置基本的主机级依赖项，例如 docker。

Kolla Ansible provides a playbook that will install all required services in the correct versions.
Kolla Ansible 提供了一个 playbook，它将在正确的版本中安装所有必需的服务。

The following assumes the use of the `multinode` inventory. If using a different inventory, such as `all-in-one`, replace the `-i` argument accordingly.
下面假设使用 `multinode` 清单。如果使用其他清单，例如 `all-in-one` ，请相应地替换 `-i` 参数。

- For deployment or evaluation, run:
  对于部署或评估，请运行：

  1. Bootstrap servers with kolla deploy dependencies:
     具有 kolla 部署依赖项的 Bootstrap 服务器：

     ```
     kolla-ansible -i ./multinode bootstrap-servers
     ```

  2. Do pre-deployment checks for hosts:
     对主机进行部署前检查：

     ```
     kolla-ansible -i ./multinode prechecks
     ```

  3. Finally proceed to actual OpenStack deployment:
     最后，继续进行实际的 OpenStack 部署：

     ```
     kolla-ansible -i ./multinode deploy
     ```

- For development, run: 对于开发，请运行：

  1. Bootstrap servers with kolla deploy dependencies:
     具有 kolla 部署依赖项的 Bootstrap 服务器：

     ```
     cd kolla-ansible/tools
     ./kolla-ansible -i ../../multinode bootstrap-servers
     ```

  2. Do pre-deployment checks for hosts:
     对主机进行部署前检查：

     ```
     ./kolla-ansible -i ../../multinode prechecks
     ```

  3. Finally proceed to actual OpenStack deployment:
     最后，继续进行实际的 OpenStack 部署：

     ```
     ./kolla-ansible -i ../../multinode deploy
     ```

When this playbook finishes, OpenStack should be up, running and functional! If error occurs during execution, refer to [troubleshooting guide](https://docs.openstack.org/kolla-ansible/yoga/user/troubleshooting.html).
当这个剧本完成时，OpenStack应该可以启动、运行和运行了！如果在执行过程中发生错误，请参阅故障排除指南。

## Using OpenStack[¶](https://docs.openstack.org/project-deploy-guide/kolla-ansible/yoga/quickstart.html#using-openstack) 使用 OpenStack ¶

1. Install the OpenStack CLI client:
   安装 OpenStack CLI 客户端：

   ```
   pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/|KOLLA_OPENSTACK_RELEASE|
   ```

2. OpenStack requires an openrc file where credentials for admin user are set. To generate this file:
   OpenStack 需要一个 openrc 文件，其中设置了管理员用户的凭据。要生成此文件，请执行以下操作：

   - For deployment or evaluation, run:
     对于部署或评估，请运行：

     ```
     kolla-ansible post-deploy
     . /etc/kolla/admin-openrc.sh
     ```

   - For development, run: 对于开发，请运行：

     ```
     cd kolla-ansible/tools
     ./kolla-ansible post-deploy
     . /etc/kolla/admin-openrc.sh
     ```

3. Depending on how you installed Kolla Ansible, there is a script that will create example networks, images, and so on.
   根据您安装 Kolla Ansible 的方式，有一个脚本可以创建示例网络、映像等。

   

    

   Warning 警告

   

   You are free to use the following `init-runonce` script for demo purposes but note it does **not** have to be run in order to use your cloud. Depending on your customisations, it may not work, or it may conflict with the resources you want to create. You have been warned.
   您可以自由地将以下 `init-runonce` 脚本用于演示目的，但请注意，不必运行它即可使用您的云。根据您的自定义项，它可能不起作用，或者可能与要创建的资源冲突。你已经被警告了。

   - For deployment or evaluation, run:
     对于部署或评估，请运行：

     If using a virtual environment:
     如果使用虚拟环境：

     ```
     /path/to/venv/share/kolla-ansible/init-runonce
     ```

     If not using a virtual environment:
     如果不使用虚拟环境：

     ```
     /usr/local/share/kolla-ansible/init-runonce
     ```

   - For development, run: 对于开发，请运行：

     ```
     kolla-ansible/tools/init-runonce
     ```