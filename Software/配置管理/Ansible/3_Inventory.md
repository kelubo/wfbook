# Inventory

[TOC]

## 概述

Ansible 使用称为 inventory 的列表或一组列表，自动执行基础架构中受控节点或“主机”上的任务。您可以在命令行传递主机名，但大多数 Ansible 用户都会创建 inventory 文件。您的 inventory 定义了您自动化的受控节点，以及组，以便您可以同时在多个主机上运行自动化任务。一旦定义了 inventory ，就可以使用模式选择 Ansible 要运行的主机或组。

Inventory 是 Ansible 部署和配置的受控节点或主机的列表。将管理节点组织在集中的文件中，为 Ansible 提供系统信息和网络位置。使用 inventory 文件，Ansible 可以通过一个命令管理大量主机。 Inventory 还可以减少需要指定的命令行选项的数量，从而帮助您更有效地使用 Ansible 。例如， Inventory 通常包含 SSH 用户，因此在运行 Ansible 命令时不需要包含 `-u` 标志。

最简单的 inventory 是包含主机和组列表的单个文件。此文件的默认位置为 `/etc/ansible/hosts` 。您可以在命令行使用 `-i <path>` 选项或在配置中使用 `inventory` 指定不同的 inventory 文件。

> Note：
>
> Inventory 文件可以是 `INI` 或 `YAML` 格式。

Ansible Inventory plugin 支持多种格式和来源，使您的 inventory 更加灵活和可定制。随着 inventory 的扩展，您可能需要不止一个文件来组织主机和组。以下是 `/etc/ansible/hosts` 文件之外的三个选项：

- 可以创建包含多个 inventory 文件的目录。它们可以使用不同的格式（YAML、INI 等）。
- 可以动态提取 inventory 。例如，您可以使用动态 inventory 插件列出一个或多个云提供商中的资源。
- 可以使用多个 inventory ，包括动态 inventory 和静态文件。

### 常规步骤

1. 创建一个名为 `inventory.yaml` 的新 inventory 文件。

2. 为主机添加新组，然后使用 `ansible_host` 字段指定每个托管节点的 IP 地址或完全限定域名（FQDN）。

   ```yaml
   virtualmachines:
     hosts:
       vm01:
         ansible_host: 192.0.2.50
       vm02:
         ansible_host: 192.0.2.51
       vm03:
         ansible_host: 192.0.2.52
   ```

3. 验证。

   ```bash
   ansible-inventory -i inventory.yaml --list
   ```

4. Ping inventory 中的受管节点。

   ```bash
   ansible virtualmachines -m ping -i inventory.yaml
   ```

   ```json
   vm03 | SUCCESS => {
       "ansible_facts": {
           "discovered_interpreter_python": "/usr/bin/python3"
       },
       "changed": false,
       "ping": "pong"
   }
   vm02 | SUCCESS => {
       "ansible_facts": {
           "discovered_interpreter_python": "/usr/bin/python3"
       },
       "changed": false,
       "ping": "pong"
   }
   vm01 | SUCCESS => {
       "ansible_facts": {
           "discovered_interpreter_python": "/usr/bin/python3"
       },
       "changed": false,
       "ping": "pong"
   }
   ```

### 建立 Inventory 的提示

- 确保组名有意义且唯一。组名也区分大小写。

- Avoid spaces, hyphens, and preceding numbers (use `floor_19`, not `19th_floor`) in group names.避免在组名中使用空格、连字符和前面的数字（使用19楼，而不是19楼）。

- Group hosts in your inventory logically according to their **What**, **Where**, and **When**.根据主机的“内容”、“位置”和“时间”，逻辑上对其进行分组。

  - What

    根据拓扑对主机进行分组，例如：db 、web 、leaf 、spine 。

  - Where

    按地理位置对主机进行分组，例如：数据中心 datacenter 、区域 region 、楼层 floor 、建筑 building 。

  - When

    按阶段对主机进行分组，例如：开发 development 、测试 test 、登台 staging 、生产 production 。

### 使用元组

使用以下语法创建一个元组，以组织 inventory 中的多个组：

```yaml
metagroupname:
  children:
```

以下 inventory 说明了数据中心的基本结构。此示例 inventory 包含一个包含所有网络设备的 `network` 元组 和包含 `network` 元组及所有 Web 服务器的  `datacenter` 元组。

```yaml
leafs:
  hosts:
    leaf01:
      ansible_host: 192.0.2.100
    leaf02:
      ansible_host: 192.0.2.110

spines:
  hosts:
    spine01:
      ansible_host: 192.0.2.120
    spine02:
      ansible_host: 192.0.2.130

network:
  children:
    leafs:
    spines:

webservers:
  hosts:
    webserver01:
      ansible_host: 192.0.2.140
    webserver02:
      ansible_host: 192.0.2.150

datacenter:
  children:
    network:
    webservers:
```

### 创建变量

变量为托管节点设置值，例如 IP 地址、FQDN 、操作系统和 SSH 用户，因此在运行 Ansible 命令时不需要传递这些值。

变量可以应用于特定主机。

```yaml
webservers:
  hosts:
    webserver01:
      ansible_host: 192.0.2.140
      http_port: 80
    webserver02:
      ansible_host: 192.0.2.150
      http_port: 443
```

变量也可以应用于组中的所有主机。

```yaml
webservers:
  hosts:
    webserver01:
      ansible_host: 192.0.2.140
      http_port: 80
    webserver02:
      ansible_host: 192.0.2.150
      http_port: 443
  vars:
    ansible_user: my_server_user
```

## 基础知识：格式、主机和组

可以使用多种格式之一创建 inventory 文件，具体取决于您拥有的 inventory plugin 。最常见的格式是 INI 和 YAML 。 基本 INI 格式 `/etc/ansible/hosts` 可能如下所示：

```ini
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

括号中的标题是组名，which are used in classifying hosts and deciding what hosts you are controlling at what times and for what purpose.用于对主机进行分类，并决定您在什么时间控制哪些主机以及出于什么目的。组名应遵循与创建有效变量名相同的准则。

这是 YAML 格式的相同基本 inventory 文件：

```yaml
all:
  hosts:
    mail.example.com:
  children:
    webservers:
      hosts:
        foo.example.com:
        bar.example.com:
    dbservers:
      hosts:
        one.example.com:
        two.example.com:
        three.example.com:
```

### 默认组

即使没有在 inventory 文件中定义任何组，Ansible 也会创建两个默认组：`all` 和 `ungrouped` 。 `all` 组包含每个主机。`ungrouped` 组包含除 `all` 外没有属于其他组的主机。每个主机将始终属于至少两个组（`all` 和 `ungrouped` 或 `all` 和其他组）。例如，在上面的基本 inventory 中，主机 `mail.example.com` 属于 `all` 组和 `ungrouped` 组；主机 `two.example.com` 属于 `all` 组和 `dbservers` 组。尽管 `all` 和 `ungrouped` 始终存在，但它们可以是隐式的，不会像 `group_names` 一样出现在组列表中。

### 多个组中的主机

您可以（而且可能会）将每个主机分成多个组。例如，亚特兰大数据中心的生产 Web 服务器可能包含在名为 `[prod]` 、 `[atlanta]` 和 `[webservers]` 的组中。可以创建跟踪以下内容的组：

- What - 应用程序、stack 或微服务（例如，数据库服务器、web 服务器等）。
- Where - A datacenter or region, to talk to local DNS, storage, and so on (for example, east, west).数据中心或区域，用于与本地DNS、存储等（例如，东部、西部）通信。
- When - The development stage, to avoid testing on production resources (for example, prod, test).开发阶段，以避免对生产资源进行测试（例如，生产、测试）。

扩展之前的YAML inventory ，以包括 what 、when 和 where，如下所示：

```yaml
all:
  hosts:
    mail.example.com:
  children:
    webservers:
      hosts:
        foo.example.com:
        bar.example.com:
    dbservers:
      hosts:
        one.example.com:
        two.example.com:
        three.example.com:
    east:
      hosts:
        foo.example.com:
        one.example.com:
        two.example.com:
    west:
      hosts:
        bar.example.com:
        three.example.com:
    prod:
      hosts:
        foo.example.com:
        one.example.com:
        two.example.com:
    test:
      hosts:
        bar.example.com:
        three.example.com:
```

您可以看到 `one.example.com` 存在于 `dbservers`， `east`  和 `prod` 组中。

### 父 / 子组关系

可以在组之间创建父 / 子关系。父组也称为嵌套组或组组。Parent groups are also known as nested groups or groups of groups.例如，如果您的所有生产主机都已在诸如  `atlanta_prod` 和 `denver_prod` 之类的组中，则可以创建一个包含这些较小组的 `production` 。这种方法减少了维护，因为可以通过编辑子组从父组中添加或删除主机。

要为组创建父 / 子关系：

- 在 INI 格式中，使用 `:children` 后缀。
- 在 YAML 格式中，使用 `children:` 条目。

这是与上面所示相同的 inventory ，简化了 `prod` 组和 `test` 组的父组。两个 inventory 文件提供了相同的结果：

```yaml
all:
  hosts:
    mail.example.com:
  children:
    webservers:
      hosts:
        foo.example.com:
        bar.example.com:
    dbservers:
      hosts:
        one.example.com:
        two.example.com:
        three.example.com:
    east:
      hosts:
        foo.example.com:
        one.example.com:
        two.example.com:
    west:
      hosts:
        bar.example.com:
        three.example.com:
    prod:
      children:
        east:
    test:
      children:
        west:
```

子组有几个属性需要注意：

- 任何属于子组的主机都会自动成为父组的成员。
- 组可以有多个父和子，但不能有循环关系。
- 主机也可以在多个组中，but there will only be **one** instance of a host at runtime.但在运行时只有一个主机实例。Ansible 合并来自多个组的数据。

### 添加范围内主机

If you have a lot of hosts with a similar pattern, 如果您有许多具有类似模式的主机，可以将它们作为一个范围添加，而不是单独列出每个主机名：

在 INI 中：

```ini
[webservers]
www[01:50].example.com
```

在 YAML 中：

```yaml
...
  webservers:
    hosts:
      www[01:50].example.com:
```

You can specify a stride (increments between sequence numbers) when defining a numeric range of hosts:定义主机的数字范围时，可以指定步长（序列号之间的增量）：

在 INI 中：

```ini
[webservers]
www[01:50:2].example.com
```

在 YAML 中：

```yaml
...
  webservers:
    hosts:
      www[01:50:2].example.com:
```

上面的示例将使子域 www01、www03、www05、…、www49 匹配，但不匹配 www00、www02、www50 等，因为步幅（增量）为每步 2 个单位。

对于数字模式，可以根据需要包括或删除前导零。范围包括在内。您还可以定义字母范围：For numeric patterns, leading zeros can be included or removed, as  desired. Ranges are inclusive. You can also define alphabetic ranges:

```ini
[databases]
db-[a:f].example.com
```

## 传递多个 inventory 源

You can target multiple inventory sources (directories, dynamic inventory scripts or files supported by inventory plugins) at the same time by giving multiple inventory parameters from the command line or by configuring [`ANSIBLE_INVENTORY`](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_INVENTORY). This can be useful when you want to target normally separate environments, like staging and production, at the same time for a specific action.

To target two inventory sources from the command line:

```
ansible-playbook get_logs.yml -i staging -i production
```



通过从命令行提供多个库存参数或通过配置ANSIBLE inventory，可以同时针对多个库存源（目录、动态库存脚本或库存插件支持的文件）。当您希望同时针对通常独立的环境（如登台和生产环境）执行特定操作时，这可能非常有用。

要从命令行瞄准两个库存源，请执行以下操作：

ansible playbook get logs.yml-i staging-i production

在目录中组织库存

您可以在一个目录中合并多个库存源。最简单的版本是包含多个文件的目录，而不是单个库存文件。当一个文件太长时，它很难维护。如果您有多个团队和多个自动化项目，每个团队或项目都有一个库存文件，这样每个人都可以轻松地找到对他们来说重要的主机和组。

您还可以在库存目录中组合多个库存源类型。这对于组合静态和动态主机并将它们作为一个资源清册进行管理非常有用。以下清单目录结合了清单插件源、动态清单脚本和带有静态主机的文件：

## [Organizing inventory in a directory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id10)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#organizing-inventory-in-a-directory)

You can consolidate multiple inventory sources in a single directory. The simplest version of this is a directory with multiple files instead of a single inventory file. A single file gets difficult to maintain  when it gets too long. If you have multiple teams and multiple  automation projects, having one inventory file per team or project lets  everyone easily find the hosts and groups that matter to them.

You can also combine multiple inventory source types in an inventory  directory. This can be useful for combining static and dynamic hosts and managing them as one inventory. The following inventory directory combines an inventory plugin source, a dynamic inventory script, and a file with static hosts:

```
inventory/
  openstack.yml          # configure inventory plugin to get hosts from OpenStack cloud
  dynamic-inventory.py   # add additional hosts with dynamic inventory script
  on-prem                # add static hosts and groups
  parent-groups          # add static hosts and groups
```

You can target this inventory directory as follows:

```
ansible-playbook example.yml -i inventory
```

You can also configure the inventory directory in your `ansible.cfg` file. See [Configuring Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html#intro-configuration) for more details.

### [Managing inventory load order](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id11)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#managing-inventory-load-order)

Ansible loads inventory sources in ASCII order according to the  filenames. If you define parent groups in one file or directory and  child groups in other files or directories, the files that define the  child groups must be loaded first. If the parent groups are loaded  first, you will see the error `Unable to parse /path/to/source_of_parent_groups as an inventory source`.

For example, if you have a file called `groups-of-groups` that defines a `production` group with child groups defined in a file called `on-prem`, Ansible cannot parse the `production` group. To avoid this problem, you can control the load order by adding prefixes to the files:

```
inventory/
  01-openstack.yml          # configure inventory plugin to get hosts from OpenStack cloud
  02-dynamic-inventory.py   # add additional hosts with dynamic inventory script
  03-on-prem                # add static hosts and groups
  04-groups-of-groups       # add parent groups
```

You can find examples of how to organize your inventories and group your hosts in [Inventory setup examples](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-setup-examples).



## [Adding variables to inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id12)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#adding-variables-to-inventory)

You can store variable values that relate to a specific host or group in inventory. To start with, you may add variables directly to the  hosts and groups in your main inventory file.

We document adding variables in the main inventory file for  simplicity. However, storing variables in separate host and group  variable files is a more robust approach to describing your system  policy. Setting variables in the main inventory file is only a  shorthand. See [Organizing host and group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#splitting-out-vars) for guidelines on storing variable values in individual files in the ‘host_vars’ directory. See [Organizing host and group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#splitting-out-vars) for details.



## [Assigning a variable to one machine: host variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id13)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#assigning-a-variable-to-one-machine-host-variables)

You can easily assign a variable to a single host, then use it later  in playbooks. You can do this directly in your inventory file.

In INI:

```
[atlanta]
host1 http_port=80 maxRequestsPerChild=808
host2 http_port=303 maxRequestsPerChild=909
```

In YAML:

```
atlanta:
  hosts:
    host1:
      http_port: 80
      maxRequestsPerChild: 808
    host2:
      http_port: 303
      maxRequestsPerChild: 909
```

Unique values like non-standard SSH ports work well as host  variables. You can add them to your Ansible inventory by adding the port number after the hostname with a colon:

```
badwolf.example.com:5309
```

Connection variables also work well as host variables:

```
[targets]

localhost              ansible_connection=local
other1.example.com     ansible_connection=ssh        ansible_user=myuser
other2.example.com     ansible_connection=ssh        ansible_user=myotheruser
```

Note

If you list non-standard SSH ports in your SSH config file, the `openssh` connection will find and use them, but the `paramiko` connection will not.



### [Inventory aliases](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id14)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases)

You can also define aliases in your inventory using host variables:

In INI:

```
jumper ansible_port=5555 ansible_host=192.0.2.50
```

In YAML:

```
...
  hosts:
    jumper:
      ansible_port: 5555
      ansible_host: 192.0.2.50
```

In this example, running Ansible against the host alias “jumper” will connect to 192.0.2.50 on port 5555. See [behavioral inventory parameters](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#behavioral-parameters) to further customize the connection to hosts.

## [Defining variables in INI format](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id15)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#defining-variables-in-ini-format)

Values passed in the INI format using the `key=value` syntax are interpreted differently depending on where they are declared:

- When declared inline with the host, INI values are interpreted as Python literal structures           (strings, numbers, tuples, lists,  dicts, booleans, None). Host lines accept multiple `key=value` parameters per line. Therefore they need a way to indicate that a space is part of a value rather than a separator. Values that contain  whitespace can be quoted (single or double). See the [Python shlex parsing rules](https://docs.python.org/3/library/shlex.html#parsing-rules) for details.
- When declared in a `:vars` section, INI values are interpreted as strings. For example `var=FALSE` would create a string equal to ‘FALSE’. Unlike host lines, `:vars` sections accept only a single entry per line, so everything after the `=` must be the value for the entry.

If a variable value set in an INI inventory must be a certain type  (for example, a string or a boolean value), always specify the type with a filter in your task. Do not rely on types set in INI inventories when consuming variables.

Consider using YAML format for inventory sources to avoid confusion  on the actual type of a variable. The YAML inventory plugin processes  variable values consistently and correctly.



## [Assigning a variable to many machines: group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id16)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#assigning-a-variable-to-many-machines-group-variables)

If all hosts in a group share a variable value, you can apply that variable to an entire group at once.

In INI:

```
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```

In YAML:

```
atlanta:
  hosts:
    host1:
    host2:
  vars:
    ntp_server: ntp.atlanta.example.com
    proxy: proxy.atlanta.example.com
```

Group variables are a convenient way to apply variables to multiple  hosts at once. Before executing, however, Ansible always flattens  variables, including inventory variables, to the host level. If a host  is a member of multiple groups, Ansible reads variable values from all  of those groups. If you assign different values to the same variable in  different groups, Ansible chooses which value to use based on internal [rules for merging](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-we-merge).



### [Inheriting variable values: group variables for groups of groups](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id17)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inheriting-variable-values-group-variables-for-groups-of-groups)

You can apply variables to parent groups (nested groups or groups of  groups) as well as to child groups. The syntax is the same: `:vars` for INI format and `vars:` for YAML format:

In INI:

```
[atlanta]
host1
host2

[raleigh]
host2
host3

[southeast:children]
atlanta
raleigh

[southeast:vars]
some_server=foo.southeast.example.com
halon_system_timeout=30
self_destruct_countdown=60
escape_pods=2

[usa:children]
southeast
northeast
southwest
northwest
```

In YAML:

```
all:
  children:
    usa:
      children:
        southeast:
          children:
            atlanta:
              hosts:
                host1:
                host2:
            raleigh:
              hosts:
                host2:
                host3:
          vars:
            some_server: foo.southeast.example.com
            halon_system_timeout: 30
            self_destruct_countdown: 60
            escape_pods: 2
        northeast:
        northwest:
        southwest:
```

A child group’s variables will have higher precedence (override) a parent group’s variables.



## [Organizing host and group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id18)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#organizing-host-and-group-variables)

Although you can store variables in the main inventory file, storing  separate host and group variables files may help you organize your  variable values more easily. You can also use lists and hash data in  host and group variables files, which you cannot do in your main  inventory file.

Host and group variable files must use YAML syntax. Valid file  extensions include ‘.yml’, ‘.yaml’, ‘.json’, or no file extension. See [YAML Syntax](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html#yaml-syntax) if you are new to YAML.

Ansible loads host and group variable files by searching paths  relative to the inventory file or the playbook file. If your inventory  file at `/etc/ansible/hosts` contains a host named ‘foosball’ that belongs to two groups, ‘raleigh’  and ‘webservers’, that host will use variables in YAML files at the  following locations:

```
/etc/ansible/group_vars/raleigh # can optionally end in '.yml', '.yaml', or '.json'
/etc/ansible/group_vars/webservers
/etc/ansible/host_vars/foosball
```

For example, if you group hosts in your inventory by datacenter, and  each datacenter uses its own NTP server and database server, you can  create a file called `/etc/ansible/group_vars/raleigh` to store the variables for the `raleigh` group:

```
---
ntp_server: acme.example.org
database_server: storage.example.org
```

You can also create *directories* named after your groups or  hosts. Ansible will read all the files in these directories in  lexicographical order. An example with the ‘raleigh’ group:

```
/etc/ansible/group_vars/raleigh/db_settings
/etc/ansible/group_vars/raleigh/cluster_settings
```

All hosts in the ‘raleigh’ group will have the variables defined in these files available to them. This can be very useful to keep your variables organized when a single file gets too big, or when you want to use [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/vault_using_encrypted_content.html#playbooks-vault) on some group variables.

For `ansible-playbook` you can also add `group_vars/` and `host_vars/` directories to your playbook directory. Other Ansible commands (for example, `ansible`, `ansible-console`, and so on) will only look for `group_vars/` and `host_vars/` in the inventory directory. If you want other commands to load group  and host variables from a playbook directory, you must provide the `--playbook-dir` option on the command line. If you load inventory files from both the playbook directory and the  inventory directory, variables in the playbook directory will override  variables set in the inventory directory.

Keeping your inventory file and variables in a git repo (or other version control) is an excellent way to track changes to your inventory and host variables.



## [How variables are merged](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id19)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-variables-are-merged)

By default variables are merged/flattened to the specific host before a play is run. This keeps Ansible focused on the Host and Task, so  groups don’t really survive outside of inventory and host matching. By  default, Ansible overwrites variables including the ones defined for a  group and/or host (see [DEFAULT_HASH_BEHAVIOUR](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-hash-behaviour)). The order/precedence is (from lowest to highest):

- all group (because it is the ‘parent’ of all other groups)
- parent group
- child group
- host

By default Ansible merges groups at the same parent/child level in  ASCII order, and variables from the last group loaded overwrite  variables from the previous groups. For example, an a_group will be  merged with b_group and b_group vars that match will overwrite the ones  in a_group.

You can change this behavior by setting the group variable `ansible_group_priority` to change the merge order for groups of the same level (after the  parent/child order is resolved). The larger the number, the later it  will be merged, giving it higher priority. This variable defaults to `1` if not set. For example:

```
a_group:
  vars:
    testvar: a
    ansible_group_priority: 10
b_group:
  vars:
    testvar: b
```

In this example, if both groups have the same priority, the result would normally have been `testvar == b`, but since we are giving the `a_group` a higher priority the result will be `testvar == a`.

Note

`ansible_group_priority` can only be set in the inventory source and not in group_vars/, as the variable is used in the loading of group_vars.

### [Managing inventory variable load order](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id20)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#managing-inventory-variable-load-order)

When using multiple inventory sources, keep in mind that any variable conflicts are resolved according to the rules described in [How variables are merged](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-we-merge) and [Variable precedence: Where should I put a variable?](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#ansible-variable-precedence). You can control the merging order of variables in inventory sources to get the variable value you need.

When you pass multiple inventory sources at the command line, Ansible merges variables in the order you pass those parameters. If `[all:vars]` in staging inventory defines `myvar = 1` and production inventory defines `myvar = 2`, then:

- Pass  `-i staging -i production` to run the playbook with `myvar = 2`.
- Pass `-i production -i staging` to run the playbook with `myvar = 1`.

When you put multiple inventory sources in a directory, Ansible  merges them in ASCII order according to the filenames. You can control  the load order by adding prefixes to the files:

```
inventory/
  01-openstack.yml          # configure inventory plugin to get hosts from Openstack cloud
  02-dynamic-inventory.py   # add additional hosts with dynamic inventory script
  03-static-inventory       # add static hosts
  group_vars/
    all.yml                 # assign variables to all hosts
```

If `01-openstack.yml` defines `myvar = 1` for the group `all`, `02-dynamic-inventory.py` defines `myvar = 2`, and `03-static-inventory` defines `myvar = 3`, the playbook will be run with `myvar = 3`.

For more details on inventory plugins and dynamic inventory scripts see [Inventory plugins](https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins) and [Working with dynamic inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_dynamic_inventory.html#intro-dynamic-inventory).



## [Connecting to hosts: behavioral inventory parameters](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id21)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters)

As described above, setting the following variables control how Ansible interacts with remote hosts.

Host connection:

Note

Ansible does not expose a channel to allow communication between the  user and the ssh process to accept a password manually to decrypt an ssh key when using the ssh connection plugin (which is the default). The  use of `ssh-agent` is highly recommended.

- ansible_connection

  Connection type to the host. This can be the name of any of ansible’s connection plugins. SSH protocol types are `smart`, `ssh` or `paramiko`.  The default is smart. Non-SSH based types are described in the next section.

General for all connections:

- ansible_host

  The name of the host to connect to, if different from the alias you wish to give to it.

- ansible_port

  The connection port number, if not the default (22 for ssh)

- ansible_user

  The user name to use when connecting to the host

- ansible_password

  The password to use to authenticate to the host (never store this variable in plain text; always use a vault. See [Keep vaulted variables safely visible](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html#tip-for-variables-and-vaults))

Specific to the SSH connection:

- ansible_ssh_private_key_file

  Private key file used by ssh.  Useful if using multiple keys and you don’t want to use SSH agent.

- ansible_ssh_common_args

  This setting is always appended to the default command line for **sftp**, **scp**, and **ssh**. Useful to configure a `ProxyCommand` for a certain host (or group).

- ansible_sftp_extra_args

  This setting is always appended to the default **sftp** command line.

- ansible_scp_extra_args

  This setting is always appended to the default **scp** command line.

- ansible_ssh_extra_args

  This setting is always appended to the default **ssh** command line.

- ansible_ssh_pipelining

  Determines whether or not to use SSH pipelining. This can override the `pipelining` setting in `ansible.cfg`.

- ansible_ssh_executable (added in version 2.2)

  This setting overrides the default behavior to use the system **ssh**. This can override the `ssh_executable` setting in `ansible.cfg`.

Privilege escalation (see [Ansible Privilege Escalation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become) for further details):

- ansible_become

  Equivalent to `ansible_sudo` or `ansible_su`, allows to force privilege escalation

- ansible_become_method

  Allows to set privilege escalation method

- ansible_become_user

  Equivalent to `ansible_sudo_user` or `ansible_su_user`, allows to set the user you become through privilege escalation

- ansible_become_password

  Equivalent to `ansible_sudo_password` or `ansible_su_password`, allows you to set the privilege escalation password (never store this variable in plain text; always use a vault. See [Keep vaulted variables safely visible](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html#tip-for-variables-and-vaults))

- ansible_become_exe

  Equivalent to `ansible_sudo_exe` or `ansible_su_exe`, allows you to set the executable for the escalation method selected

- ansible_become_flags

  Equivalent to `ansible_sudo_flags` or `ansible_su_flags`, allows you to set the flags passed to the selected escalation method. This can be also set globally in `ansible.cfg` in the `sudo_flags` option

Remote host environment parameters:

- ansible_shell_type

  The shell type of the target system. You should not use this setting unless you have set the [ansible_shell_executable](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#ansible-shell-executable) to a non-Bourne (sh) compatible shell.  By default commands are formatted using `sh`-style syntax.  Setting this to `csh` or `fish` will cause commands executed on target systems to follow those shell’s syntax instead.

- ansible_python_interpreter

  The target host python path. This is useful for systems with more than one Python or not located at **/usr/bin/python** such as *BSD, or where **/usr/bin/python** is not a 2.X series Python.  We do not use the **/usr/bin/env** mechanism as that requires the remote user’s path to be set right and also assumes the **python** executable is named python, where the executable might be named something like **python2.6**.

- ansible_*_interpreter

  Works for anything such as ruby or perl and works just like [ansible_python_interpreter](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#ansible-python-interpreter). This replaces shebang of modules which will run on that host.

New in version 2.1.

- ansible_shell_executable

  This sets the shell the ansible controller will use on the target machine, overrides `executable` in `ansible.cfg` which defaults to **/bin/sh**.  You should really only change it if is not possible to use **/bin/sh** (in other words, if **/bin/sh** is not installed on the target machine or cannot be run from sudo.).

Examples from an Ansible-INI host file:

```
some_host         ansible_port=2222     ansible_user=manager
aws_host          ansible_ssh_private_key_file=/home/example/.ssh/aws.pem
freebsd_host      ansible_python_interpreter=/usr/local/bin/python
ruby_module_host  ansible_ruby_interpreter=/usr/bin/ruby.1.9.3
```

### [Non-SSH connection types](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id22)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#non-ssh-connection-types)

As stated in the previous section, Ansible executes playbooks over SSH but it is not limited to this connection type. With the host specific parameter `ansible_connection=<connector>`, the connection type can be changed. The following non-SSH based connectors are available:

**local**

This connector can be used to deploy the playbook to the control machine itself.

**docker**

This connector deploys the playbook directly into Docker containers  using the local Docker client. The following parameters are processed by this connector:

- ansible_host

  The name of the Docker container to connect to.

- ansible_user

  The user name to operate within the container. The user must exist inside the container.

- ansible_become

  If set to `true` the `become_user` will be used to operate within the container.

- ansible_docker_extra_args

  Could be a string with any  additional arguments understood by Docker, which are not command  specific. This parameter is mainly used to configure a remote Docker  daemon to use.

Here is an example of how to instantly deploy to created containers:

```
- name: Create a jenkins container
  community.general.docker_container:
    docker_host: myserver.net:4243
    name: my_jenkins
    image: jenkins

- name: Add the container to inventory
  ansible.builtin.add_host:
    name: my_jenkins
    ansible_connection: docker
    ansible_docker_extra_args: "--tlsverify --tlscacert=/path/to/ca.pem --tlscert=/path/to/client-cert.pem --tlskey=/path/to/client-key.pem -H=tcp://myserver.net:4243"
    ansible_user: jenkins
  changed_when: false

- name: Create a directory for ssh keys
  delegate_to: my_jenkins
  ansible.builtin.file:
    path: "/var/jenkins_home/.ssh/jupiter"
    state: directory
```

For a full list with available plugins and examples, see [Plugin list](https://docs.ansible.com/ansible/latest/plugins/connection.html#connection-plugin-list).

Note

If you’re reading the docs from the beginning, this may be the first  example you’ve seen of an Ansible playbook. This is not an inventory  file. Playbooks will be covered in great detail later in the docs.



## [Inventory setup examples](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id23)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-setup-examples)

See also [Sample Ansible setup](https://docs.ansible.com/ansible/latest/tips_tricks/sample_setup.html#sample-setup), which shows inventory along with playbooks and other Ansible artifacts.



### [Example: One inventory per environment](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id24)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#example-one-inventory-per-environment)

If you need to manage multiple environments it’s sometimes prudent to have only hosts of a single environment defined per inventory. This way, it is harder to, for instance, accidentally change the state of nodes inside the “test” environment when you actually wanted to update some “staging” servers.

For the example mentioned above you could have an `inventory_test` file:

```
[dbservers]
db01.test.example.com
db02.test.example.com

[appservers]
app01.test.example.com
app02.test.example.com
app03.test.example.com
```

That file only includes hosts that are part of the “test” environment. Define the “staging” machines in another file called `inventory_staging`:

```
[dbservers]
db01.staging.example.com
db02.staging.example.com

[appservers]
app01.staging.example.com
app02.staging.example.com
app03.staging.example.com
```

To apply a playbook called `site.yml` to all the app servers in the test environment, use the following command:

```
ansible-playbook -i inventory_test -l appservers site.yml
```



### [Example: Group by function](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id25)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#example-group-by-function)

In the previous section you already saw an example for using groups in order to cluster hosts that have the same function. This allows you, for instance, to define firewall rules inside a playbook or role affecting only database servers:

```
- hosts: dbservers
  tasks:
  - name: Allow access from 10.0.0.1
    ansible.builtin.iptables:
      chain: INPUT
      jump: ACCEPT
      source: 10.0.0.1
```



### [Example: Group by location](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#id26)[](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#example-group-by-location)

Other tasks might be focused on where a certain host is located. Let’s say that `db01.test.example.com` and `app01.test.example.com` are located in DC1 while `db02.test.example.com` is in DC2:

```
[dc1]
db01.test.example.com
app01.test.example.com

[dc2]
db02.test.example.com
```

In practice, you might even end up mixing all these setups as you might need to, on one day, update all nodes in a specific data center while, on another day, update all the application servers no matter their location.