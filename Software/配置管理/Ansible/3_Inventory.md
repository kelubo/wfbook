# Inventory

[TOC]

## 概述

Ansible 使用称为 inventory 的列表或一组列表，自动执行基础架构中受控节点或“主机”上的任务。可以在命令行传递主机名，但大多数 Ansible 用户都会创建 inventory 文件。inventory 定义了自动化的受控节点，以及组，以便可以同时在多个主机上运行自动化任务。一旦定义了 inventory ，就可以使用模式选择 Ansible 要运行的主机或组。

Inventory 是 Ansible 部署和配置的受控节点或主机的列表。将管理节点组织在集中的文件中，为 Ansible 提供系统信息和网络位置。使用 inventory 文件，Ansible 可以通过一个命令管理大量主机。 

Inventory 还可以减少需要指定的命令行选项的数量，从而帮助您更有效地使用 Ansible 。例如， Inventory 通常包含 SSH 用户，因此在运行 Ansible 命令时不需要包含 `-u` 标志。

最简单的 inventory 是包含主机和组列表的单个文件。此文件的默认位置为 `/etc/ansible/hosts` 。您可以在命令行使用 `-i <path>` 选项或在配置中使用 `inventory` 指定不同的 inventory 文件。

> Note：
>
> Inventory 文件可以是 `INI` 或 `YAML` 格式。在大多数情况下，`INI` 文件对于少量托管式节点来说非常简单易读。随着托管式节点数量的增加，以 `YAML` 格式创建清单成为一个明智的选择。

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

- 避免在组名中使用空格、连字符和以数字开头（使用 `floor_19` ，而不是 `19th_floor` ）。

- 根据主机的“内容 What”、“位置 Where”和“时间 When”，逻辑上对其进行分组。

  - What

    根据拓扑对主机进行分组，例如：db 、web 、leaf 、spine 。

  - Where

    按地理位置对主机进行分组，例如：数据中心 datacenter 、区域 region 、楼层 floor 、建筑 building 。

  - When

    按阶段对主机进行分组，例如：开发 development 、测试 test 、暂存 staging 、生产 production 。

### 使用元组

使用以下语法创建一个元组，以组织 inventory 中的多个组：

```yaml
metagroupname:
  children:
```

以下 inventory 说明了数据中心的基本结构。此示例 inventory 包含一个包含所有网络设备的 `network` 元组和包含 `network` 元组及所有 Web 服务器的  `datacenter` 元组。

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

可以（而且可能会）将每个主机分成多个组。例如，亚特兰大数据中心的生产 Web 服务器可能包含在名为 `[prod]` 、 `[atlanta]` 和 `[webservers]` 的组中。可以创建跟踪以下内容的组：

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

通过从命令行提供多个 inventory 参数或通过配置 `ANSIBLE_INVENTORY` ，可以同时针对多个 inventory 源（目录、动态 inventory 脚本或 inventory 插件支持的文件）。This can be useful when you want to target normally separate environments, like staging and production, at the same time for a specific action.当您希望同时针对通常独立的环境（如 staging 和 production ）执行特定操作时，这可能非常有用。

To target two inventory sources from the command line:要从命令行瞄准两个库存源，请执行以下操作：

```bash
ansible-playbook get_logs.yml -i staging -i production
```

## 在目录中组织 inventory

可以在一个目录中合并多个 inventory 源。最简单的版本是包含多个文件的目录，而不是单个 inventory 文件。当一个文件太长时，它很难维护。如果您有多个团队和多个自动化项目，每个团队或项目都有一个 inventory 文件，这样每个人都可以轻松地找到对他们来说重要的主机和组。

还可以在 inventory 目录中组合多个 inventory 源类型。这对于组合静态和动态主机并将它们作为一个资源 inventory 进行管理非常有用。以下 inventory 目录结合了 inventory 插件源、动态 inventory 脚本和带有静态主机的文件：

```bash
inventory/
  openstack.yml          # configure inventory plugin to get hosts from OpenStack cloud
  dynamic-inventory.py   # add additional hosts with dynamic inventory script
  on-prem                # add static hosts and groups
  parent-groups          # add static hosts and groups
```

You can target this inventory directory as follows:您可以将此 inventory 目录作为目标，如下所示：

```bash
ansible-playbook example.yml -i inventory
```

还可以在 `ansible.cfg` 文件中配置 inventory 目录。

### 管理 inventory 加载顺序

Ansible 根据文件名以 ASCII 顺序加载 inventory 源。如果在一个文件或目录中定义父组，在其他文件或目录下定义子组，则必须首先加载定义子组的文件。如果首先加载父组，您将看到错误 `Unable to parse /path/to/source_of_parent_groups as an inventory source` 。

例如，如果您有一个名为 `groups-of-groups` 的文件，该文件定义了一个 `production` 组，并在名为 `on-prem` 的文件中定义了子组，则 Ansible 无法解析该 `production` 组。为了避免此问题，可以通过向文件添加前缀来控制加载顺序：

```bash
inventory/
  01-openstack.yml          # configure inventory plugin to get hosts from OpenStack cloud
  02-dynamic-inventory.py   # add additional hosts with dynamic inventory script
  03-on-prem                # add static hosts and groups
  04-groups-of-groups       # add parent groups
```

## 向 inventory 添加变量

可以在 inventory 中存储与特定主机或组相关的变量值。首先，可以将变量直接添加到主 inventory 文件中的主机和组。

为了简单起见，我们在主 inventory 文件中记录添加变量。但是，在单独的主机和组变量文件中存储变量是描述系统策略的一种更稳健的方法。在主 inventory 文件中设置变量只是一种速记。

## 将变量分配给一台机器：主机变量

您可以很容易地将一个变量分配给一个主机，然后稍后在 playbook 中使用它。您可以直接在 inventory 文件中执行此操作。

在 INI 中：

```ini
[atlanta]
host1 http_port=80 maxRequestsPerChild=808
host2 http_port=303 maxRequestsPerChild=909
```

在 YAML 中：

```yaml
atlanta:
  hosts:
    host1:
      http_port: 80
      maxRequestsPerChild: 808
    host2:
      http_port: 303
      maxRequestsPerChild: 909
```

Unique values like non-standard SSH ports work well as host  variables.非标准 SSH 端口等唯一值与主机变量一样适用。您可以通过在主机名后面添加带有冒号的端口号将它们添加到 Ansible  inventory  中：

```ini
badwolf.example.com:5309
```

连接变量也可以作为主机变量使用：

```ini
[targets]

localhost              ansible_connection=local
other1.example.com     ansible_connection=ssh        ansible_user=myuser
other2.example.com     ansible_connection=ssh        ansible_user=myotheruser
```

> **Note:**
>
> 如果在 SSH 配置文件中列出了非标准 SSH 端口， `openssh` 连接将找到并使用它们，但 `paramiko` 连接不会。

### Inventory 别名

可以使用主机变量在 inventory 中定义别名：

在 INI 中：

```ini
jumper ansible_port=5555 ansible_host=192.0.2.50
```

在 YAML 中：

```yaml
...
  hosts:
    jumper:
      ansible_port: 5555
      ansible_host: 192.0.2.50
```

在本例中，running Ansible against the host alias “jumper” will connect to 192.0.2.50 on port 5555. 对主机别名“跳线”运行Ansible将连接到端口5555上的192.0.2.50。

## 以INI格式定义变量

使用 `key=value` 语法以 INI 格式传递的值会根据声明的位置进行不同的解释：

- 当与主机内联声明时，INI 值被解释为 Python 文本结构（字符串、数字、元组、列表、字典、布尔值、None）。主机行接受每行多个 `key=value` 参数。因此，需要一种方法来指示空格是值的一部分，而不是分隔符。可以引用包含空格的值（单引号或双引号）。
- 在 `:vars` 节中声明时，INI 值将被解释为字符串。例如， `var=FALSE` 将创建一个等于 ‘FALSE’ 的字符串。与主机行不同，`:vars` 部分每行只接受一个条目，因此 `=` 之后的所有内容都必须是条目的值。

如果 INI inventory 中设置的变量值必须是特定类型（例如，字符串或布尔值），请始终在任务中使用筛选器指定类型。使用变量时，不要依赖 INI inventory 中设置的类型。

考虑对  inventory 源使用 YAML 格式，以避免混淆变量的实际类型。YAML inventory plugin 插件始终正确地处理变量值。

## 将变量分配给多台机器：组变量

如果组中的所有主机共享一个变量值，则可以一次性将该变量应用于整个组。

在 INI 中：

```ini
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```

在 YAML 中：

```yaml
atlanta:
  hosts:
    host1:
    host2:
  vars:
    ntp_server: ntp.atlanta.example.com
    proxy: proxy.atlanta.example.com
```

组变量是一次将变量应用于多个主机的方便方法。然而，在执行之前，Ansible 总是将变量（包括 inventory 变量）展平到主机级别。如果主机是多个组的成员，Ansible 将从所有这些组中读取变量值。如果将不同的值分配给不同组中的同一变量，Ansible 将根据内部合并规则选择要使用的值。

### 继承变量值：group variables for groups of groups 组组的组变量

The syntax is the same:for INI format andfor YAML format:

可以将变量应用于父组 (nested groups or groups of  groups) （嵌套组或组组）以及子组。语法相同：INI 格式的 `:vars` 和 YAML 格式的 `vars:`  ：

在 INI 中：

```ini
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

在 YAML 中：

```yaml
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

子组的变量将具有更高的优先级（覆盖）父组的变量。

## 组织主机和组变量

尽管可以将变量存储在主 inventory 文件中，但存储单独的主机和组变量文件可能有助于更轻松地组织变量值。还可以在主机和组变量文件中使用列表和哈希数据，这在主 inventory 文件中是无法做到的。

主机和组变量文件必须使用 YAML 语法。有效的文件扩展名包括 ‘.yml’，‘.yaml’，‘.json’，或无文件扩展名。

Ansible 通过搜索与 inventory 文件或 playbook 文件相关的路径来加载主机和组变量文件。如果位于 `/etc/ansible/hosts` 的 inventory 文件包含一个名为 “foosball” 的主机，该主机属于两个组 “raleigh” 和 “webservers” ，则该主机将在以下位置使用 YAML 文件中的变量：

```bash
/etc/ansible/group_vars/raleigh     # 可以选择以 '.yml'，'.yaml' 或 '.json' 结尾
/etc/ansible/group_vars/webservers
/etc/ansible/host_vars/foosball
```

例如，如果您按数据中心对 inventory 中的主机进行分组，并且每个数据中心都使用自己的 NTP 服务器和数据库服务器，则可以创建名为 `/etc/ansible/group_vars/raleigh` 的文件来存储 `raleigh` 组的变量：

```yaml
---
ntp_server: acme.example.org
database_server: storage.example.org
```

还可以创建以组或主机命名的目录。Ansible 将按字典顺序读取这些目录中的所有文件。“raleigh” 组的示例：

```bash
/etc/ansible/group_vars/raleigh/db_settings
/etc/ansible/group_vars/raleigh/cluster_settings
```

“raleigh” 组中的所有主机都可以使用这些文件中定义的变量。当单个文件太大时，或者当您希望对某些组变量使用 Ansible Vault 时，这对于保持变量的组织非常有用。

对于 `ansible-playbook` ，您还可以将 `group_vars/` 和 `host_vars/` 目录添加到 playbook 目录中。其他 Ansible 命令（例如，`ansible`, `ansible-console` 等）将只在 inventory 目录中查找 `group_vars/` 和 `host_vars/` 。如果希望其他命令从 playbook 目录加载组和主机变量，则必须在命令行上提供 `--playbook-dir` 选项。如果同时从 playbook 目录和 inventory 目录加载 inventory 文件，playbook 目录中的变量将覆盖 inventory 目录中设置的变量。

将 inventory 文件和变量保存在 git repo （或其他版本控制）中是跟踪 inventory 和主机变量变化的一种很好的方法。

## 如何合并变量

默认情况下，在  play  运行之前，将变量合并 / 展平到特定主机。这使 Ansible 专注于主机和任务，因此组在 inventory 和主机匹配之外无法真正生存。默认情况下，Ansible 覆盖变量，包括为组和/或主机定义的变量。顺序/优先级为（从最低到最高）：

- all 组（因为它是所有其他组的“父级”）
- parent group
- child group
- host

默认情况下，Ansible 以 ASCII 顺序合并相同父级/子级的组，最后一个组中的变量将覆盖前一个组的变量。例如，a_group 将与 b_group 合并，匹配的 b_group 变量将覆盖 a_group 中的变量。

可以通过设置组变量 `ansible_group_priority` 来更改相同级别组的合并顺序（在父/子顺序解析后）来更改此行为。数字越大，它将越晚被合并，从而赋予它更高的优先级。如果未设置，此变量默认为 `1` 。例如：

```yaml
a_group:
  vars:
    testvar: a
    ansible_group_priority: 10
b_group:
  vars:
    testvar: b
```

在本例中，如果两个组具有相同的优先级，那么结果通常是 `testvar == b`，但是由于我们给 `a_group` 赋予了更高的优先级，因此结果将是 `testvar == a` 。

> **Note:**
>
> `ansible_group_priority` 只能在 inventory 源中设置，而不能在 group_vars/, 中设置，因为变量用于加载 group_vars 。

### 管理 inventory 变量加载顺序

可以控制 inventory 源中变量的合并顺序，以获得所需的变量值。

当您在命令行传递多个 inventory 源时，Ansible 会按照传递这些参数的顺序合并变量。如果 staging inventory 中的 `[all:vars]` 定义 `myvar = 1` ，而production inventory 定义 `myvar = 2` ，则：

- 传递  `-i staging -i production` 以 `myvar = 2` 运行 playbook 。
- 传递 `-i production -i staging` 以 `myvar = 1`  运行 playbook 。

当将多个 inventory 源放在一个目录中时，Ansible 会根据文件名以 ASCII 顺序合并它们。您可以通过向文件添加前缀来控制加载顺序：

```bash
inventory/
  01-openstack.yml          # configure inventory plugin to get hosts from Openstack cloud
  02-dynamic-inventory.py   # add additional hosts with dynamic inventory script
  03-static-inventory       # add static hosts
  group_vars/
    all.yml                 # assign variables to all hosts
```

如果 `01-openstack.yml` 为组 `all` 定义 `myvar = 1` ， `02-dynamic-inventory.py` 定义 `myvar = 2` ， `03-static-inventory` 定义 `myvar = 3` ，则将在  `myvar = 3` 的情况下运行 playbook 。

## 连接到主机：行为清单参数behavioral inventory parameters

如上所述，设置以下变量控制 Ansible 如何与远程主机交互。

主机连接：

> **Note:**
>
> Ansible does not expose a channel to allow communication between the  user and the ssh process to accept a password manually to decrypt an ssh key when using the ssh connection plugin (which is the default). 
>
> Ansible不公开一个通道，允许用户和ssh进程之间的通信在使用ssh连接插件（默认）时手动接受密码以解密ssh密钥。强烈建议使用 `ssh-agent` 。

- ansible_connection

  到主机的连接类型。可以是 ansible 的任何连接插件的名称。SSH 协议类型为 `smart` ，`ssh` 或 `paramiko` 。默认值为 `smart` 。

General for all connections:所有连接的常规：

- ansible_host

  要连接到的主机的名称，如果与您给它的别名不同。

- ansible_port

  连接端口号，如果不是默认值（ssh 为 22）。

- ansible_user

  连接到主机时要使用的用户名。

- ansible_password

  用于向主机进行身份验证的密码（切勿将此变量存储为纯文本；始终使用 vault 。）

Specific to the SSH connection:特定于SSH连接：

- ansible_ssh_private_key_file

  ssh 使用的私钥文件。如果使用多个密钥并且不想使用 SSH 代理，则非常有用。

- ansible_ssh_common_args

  This setting is always appended to the default command line for **sftp**, **scp**, and **ssh**. Useful to configure a `ProxyCommand` for a certain host (or group).此设置始终附加到sftp、scp 和 ssh 的默认命令行。用于为特定主机（或组）配置 `ProxyCommand` 。

- ansible_sftp_extra_args

  此设置始终附加到默认的 sftp 命令行。

- ansible_scp_extra_args

  此设置始终附加到默认 scp 命令行。

- ansible_ssh_extra_args

  此设置始终附加到默认 ssh 命令行。

- ansible_ssh_pipelining

  确定是否使用 SSH 管道。这可以覆盖 `ansible.cfg` 中的 `pipelining` 设置。

- ansible_ssh_executable (在 2.2 版中添加)

  此设置将覆盖使用系统 ssh 的默认行为。这可以覆盖 `ansible.cfg `中的 `ssh_executable` 设置。

Privilege escalation 权限升级：

- ansible_become

  Equivalent to `ansible_sudo` or `ansible_su`, allows to force privilege escalation等效于ansible sudo或ansible su，允许强制权限升级

- ansible_become_method

  Allows to set privilege escalation method允许设置权限提升方法

- ansible_become_user

  Equivalent to `ansible_sudo_user` or `ansible_su_user`, allows to set the user you become through privilege escalation相当于ansible sudo用户或ansible su用户，允许通过权限升级设置用户

- ansible_become_password

  Equivalent to `ansible_sudo_password` or `ansible_su_password`, allows you to set the privilege escalation password (never store this variable in plain text; always use a vault. See [Keep vaulted variables safely visible](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html#tip-for-variables-and-vaults))相当于ansible sudo密码或ansible su密码，允许您设置权限升级密码（切勿以纯文本存储此变量；始终使用vault。请参阅保持vault中的变量安全可见）

- ansible_become_exe

  Equivalent to `ansible_sudo_exe` or `ansible_su_exe`, allows you to set the executable for the escalation method selected等效于ansible sudo exe或ansible su exe，允许您设置所选升级方法的可执行文件

- ansible_become_flags

  Equivalent to `ansible_sudo_flags` or `ansible_su_flags`, allows you to set the flags passed to the selected escalation method. This can be also set globally in `ansible.cfg` in the `sudo_flags` option等效于ansible sudo标志或ansible su标志，允许您设置传递给所选升级方法的标志。这也可以在ansible.cfg的sudo标志选项中全局设置

远程主机环境参数：

- ansible_shell_type

  The shell type of the target system. You should not use this setting unless you have set the [ansible_shell_executable](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#ansible-shell-executable) to a non-Bourne (sh) compatible shell.  By default commands are formatted using `sh`-style syntax.  Setting this to `csh` or `fish` will cause commands executed on target systems to follow those shell’s syntax instead.目标系统的外壳类型。除非已将ansible shell可执行文件设置为非Bourne（sh）兼容的shell，否则不应使用此设置。默认情况下，命令使用sh样式语法格式化。将其设置为csh或fish将导致在目标系统上执行的命令遵循这些shell的语法。

- ansible_python_interpreter

  The target host python path. This is useful for systems with more than one Python or not located at **/usr/bin/python** such as *BSD, or where **/usr/bin/python** is not a 2.X series Python.  We do not use the **/usr/bin/env** mechanism as that requires the remote user’s path to be set right and also assumes the **python** executable is named python, where the executable might be named something like **python2.6**.*

  目标主机python路径。这对于具有多个Python或不位于/usr/bin/Python（如*BSD）或/usr/bin/pthon不是2.X系列Python的系统非常有用。我们不使用/usr/bin/env机制，因为这需要正确设置远程用户的路径，并且还假设python可执行文件名为python，其中可执行文件的名称可能类似于python2.6。

- ansible_*_interpreter

  Works for anything such as ruby or perl and works just like [ansible_python_interpreter](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#ansible-python-interpreter). This replaces shebang of modules which will run on that host.
  
  适用于ruby或perl等任何东西，工作方式与可编译的python解释器类似。这将替换将在该主机上运行的模块的shebang。

2.1 版中的新增功能：

- ansible_shell_executable

  This sets the shell the ansible controller will use on the target machine, overrides `executable` in `ansible.cfg` which defaults to **/bin/sh**.  You should really only change it if is not possible to use **/bin/sh** (in other words, if **/bin/sh** is not installed on the target machine or cannot be run from sudo.).
  
  这将设置ansible控制器将在目标计算机上使用的shell，覆盖ansible.cfg中的可执行文件，该文件默认为/bin/sh。如果无法使用/bin/sh（换句话说，如果/bin/sh未安装在目标计算机上或无法从sudo运行），则应该真正更改它。

Ansible INI 主机文件示例：

```ini
some_host         ansible_port=2222     ansible_user=manager
aws_host          ansible_ssh_private_key_file=/home/example/.ssh/aws.pem
freebsd_host      ansible_python_interpreter=/usr/local/bin/python
ruby_module_host  ansible_ruby_interpreter=/usr/bin/ruby.1.9.3
```

### 非 SSH 连接类型

Ansible 通过 SSH 执行 playbook ，但不限于这种连接类型。使用特定于主机的参数 `ansible_connection=<connector>` ，可以更改连接类型。以下非基于 SSH 的连接器可用：

**local**

This connector can be used to deploy the playbook to the control machine itself.此连接器可用于将剧本部署到控制机器本身。

**docker**

This connector deploys the playbook directly into Docker containers  using the local Docker client. The following parameters are processed by this connector:该连接器使用本地Docker客户端将playbook直接部署到Docker容器中。此连接器处理以下参数：

- ansible_host

  The name of the Docker container to connect to.要连接到的Docker容器的名称。

- ansible_user

  The user name to operate within the container. The user must exist inside the container.要在容器中操作的用户名。用户必须存在于容器内。

- ansible_become

  If set to `true` the `become_user` will be used to operate within the container.如果设置为true，将使用begin用户在容器内操作。

- ansible_docker_extra_args

  Could be a string with any  additional arguments understood by Docker, which are not command  specific. This parameter is mainly used to configure a remote Docker  daemon to use.可以是一个字符串，其中包含Docker可以理解的任何其他参数，这些参数不是特定于命令的。此参数主要用于配置要使用的远程Docker守护进程。

Here is an example of how to instantly deploy to created containers:

下面是如何立即部署到创建的容器的示例：

```yaml
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

## Inventory 设置示例

### 示例：每个环境一个 inventory

如果您需要管理多个环境，有时明智的做法是每个 inventory 只定义单个环境的主机。这样，例如，当您实际想要更新一些 “staging” 服务器时，很难意外更改 “test” 环境中节点的状态。

对于上述示例，您可以有一个 `inventory_test` 文件：

```ini
[dbservers]
db01.test.example.com
db02.test.example.com

[appservers]
app01.test.example.com
app02.test.example.com
app03.test.example.com
```

该文件仅包含属于 “test” 环境的主机。在另一个名为 `inventory_staging` 的文件中定义 “staging” 机器：

```ini
[dbservers]
db01.staging.example.com
db02.staging.example.com

[appservers]
app01.staging.example.com
app02.staging.example.com
app03.staging.example.com
```

要将名为 `site.yml` 的 playbook 应用于 test 环境中的所有应用服务器，请使用以下命令：

```bash
ansible-playbook -i inventory_test -l appservers site.yml
```

### 示例：按功能分组

使用组来集群具有相同功能的主机。例如，这允许您在仅影响数据库服务器的 playbook 或 role 中定义防火墙规则：

```yaml
- hosts: dbservers
  tasks:
  - name: Allow access from 10.0.0.1
    ansible.builtin.iptables:
      chain: INPUT
      jump: ACCEPT
      source: 10.0.0.1
```

### 示例：按位置分组

其他任务可能集中在某个主机所在的位置。假设 `db01.test.example.com` 和 `app01.test.example.com` 位于 DC1 中，而 `db02.test.example.com` 位于 DC2 中：

```ini
[dc1]
db01.test.example.com
app01.test.example.com

[dc2]
db02.test.example.com
```

实际上，您甚至可能会混合所有这些设置，因为您可能需要在某一天更新特定数据中心中的所有节点，而在另一天更新所有应用程序服务器，无论其位置如何。

## 使用动态 inventory

如果您的 Ansible inventory 随时间波动，主机响应业务需求而启动和关闭，那么静态 inventory 解决方案将无法满足您的需求。可能需要从多个来源跟踪主机：云提供商、LDAP、Cobbler 或企业 CMDB 系统。

Ansible 通过动态外部 inventory 系统集成了所有这些选项。Ansible 支持两种连接外部 inventory 的方式： inventory 插件和 inventory 脚本。

Inventory 插件利用 Ansible 核心代码的最新更新。我们建议使用插件而不是脚本来进行动态 inventory 。可以编写自己的插件来连接到其他动态 inventory 源。

仍然可以使用 inventory 脚本。When we implemented inventory plugins, we ensured backwards compatibility through the script inventory plugin. 当我们实现 inventory 插件时，我们通过脚本 inventory 插件确保了向后兼容性。下面的示例说明了如何使用 inventory 脚本。

如果您喜欢使用 GUI 处理动态 inventory ，AWX 或 Red Hat Ansible Automation  Platform 上的 inventory 数据库将与所有动态 inventory 源同步，提供对结果的 web 和 REST 访问，并提供图形 inventory 编辑器。使用所有主机的数据库记录，您可以关联过去的事件历史记录，并查看哪些主机在其上一次运行时发生了故障。

### 脚本示例：Cobbler

Ansible 与 Cobbler 无缝集成，Cobbler 是一个 Linux 安装服务器，最初由 Michael De Haan 编写，现在由为 Ansible 工作的 James Cammarata 领导。

虽然 Cobbler 主要用于启动 OS 安装和管理 DHCP 与 DNS，但它有一个通用层，可以表示多个配置管理系统的数据（甚至同时），并充当“轻量级 CMDB ”。

要将 Ansible inventory 绑定到 Cobbler ，请将此脚本复制到 `/etc/ansible` 中并执行 `chmod +x` 操作。在使用 Ansible 的任何时候都可以运行 `cobblerd` ，并使用 `-i` 命令行选项（例如， `-i /etc/ansible/cobbler.py`）使用 Cobbler 的 XMLRPC API 与 Cobbler 通信。

```python
# 官方的链接失效。
```

在 `/etc/ansible` 中添加一个 `cobbler.ini` 文件，以便 ansible 知道 Cobbler 服务器在哪里，并可以使用一些缓存改进。例如：

```ini
[cobbler]

# Set Cobbler's hostname or IP address
host = http://127.0.0.1/cobbler_api

# API calls to Cobbler can be slow. For this reason, we cache the results of an API
# call. Set this to the path you want cache files to be written to. Two files
# will be written to this directory:
#   - ansible-cobbler.cache
#   - ansible-cobbler.index

cache_path = /tmp

# The number of seconds a cache file is considered valid. After this many
# seconds, a new API call will be made, and the cache file will be updated.

cache_max_age = 900
```

首先直接运行 `/etc/ansible/cobbler.py` 来测试脚本。您应该看到一些 JSON 数据输出，但它可能还没有任何内容。

让我们来探索一下它的作用。在 Cobbler 中，假设如下情景：

```bash
cobbler profile add --name=webserver --distro=CentOS6-x86_64
cobbler profile edit --name=webserver --mgmt-classes="webserver" --ksmeta="a=2 b=3"
cobbler system edit --name=foo --dns-name="foo.example.com" --mgmt-classes="atlanta" --ksmeta="c=4"
cobbler system edit --name=bar --dns-name="bar.example.com" --mgmt-classes="atlanta" --ksmeta="c=5"
```

In the example above, the system ‘foo.example.com’ is addressable by  ansible directly, but is also addressable when using the group names  ‘webserver’ or ‘atlanta’. Since Ansible uses SSH, it contacts system foo over ‘foo.example.com’, only, never just ‘foo’. Similarly, if you tried “ansible foo”, it would not find the system… but “ansible ‘foo*’” would do, because the system DNS name starts with ‘foo’.

在上面的示例中，系统“foo.example.com”可由ansible直接寻址，但在使用组名“webserver”或“atlanta”时也可寻址。由于Ansible使用SSH，所以它只通过“foo.example.com”联系系统foo，而不仅仅是“foo”。类似地，如果您尝试“ansible foo”，它不会找到系统……但“ansible'foo*'”会找到，因为系统DNS名称以'foo'开头。

The script provides more than host and group info. In addition, as a  bonus, when the ‘setup’ module is run (which happens automatically when  using playbooks), the variables ‘a’, ‘b’, and ‘c’ will all be  auto-populated in the templates:

该脚本提供的不仅仅是主机和组信息。此外，作为奖励，当“设置”模块运行时（使用剧本时自动发生），变量“a”、“b”和“c”都将自动填充到模板中：

```yaml
# file: /srv/motd.j2
Welcome, I am templated with a value of a={{ a }}, b={{ b }}, and c={{ c }}
```

可以这样执行：

```bash
ansible webserver -m setup
ansible webserver -m template -a "src=/tmp/motd.j2 dest=/etc/motd"
```

> **Note：**
>
> The name ‘webserver’ came from Cobbler, as did the variables for the config file.  You can still pass in your own variables like normal in Ansible, but variables from the external inventory script will override any that have the same name.名称“webserver”来自Cobbler，配置文件的变量也是如此。您仍然可以像Ansible中的普通一样传递自己的变量，但外部库存脚本中的变量将覆盖任何同名的变量。

So, with the template above (`motd.j2`), this results in the following data being written to `/etc/motd` for system ‘foo’:

因此，使用上面的模板（motd.j2），这将导致以下数据被写入/etc/motd，用于系统“foo”：

```
Welcome, I am templated with a value of a=2, b=3, and c=4
```

And on system ‘bar’ (bar.example.com):在系统“bar”（bar.example.com）上：

```
Welcome, I am templated with a value of a=2, b=3, and c=5
```

And technically, though there is no major good reason to do it, this also works:从技术上讲，虽然没有什么好的理由这样做，但这也是可行的：

```
ansible webserver -m ansible.builtin.shell -a "echo {{ a }}"
```

So, in other words, you can use those variables in arguments/actions as well.因此，换句话说，您也可以在参数/操作中使用这些变量。

### 脚本示例：OpenStack

If you use an OpenStack-based cloud, instead of manually maintaining your own inventory file, you can use the `openstack_inventory.py` dynamic inventory to pull information about your compute instances directly from OpenStack.如果使用基于openstack的云，而不是手动维护自己的库存文件，则可以使用openstackinventory.py动态库存直接从openstack获取有关计算实例的信息。

可以在[此处](https://raw.githubusercontent.com/openstack/ansible-collections-openstack/master/scripts/inventory/openstack_inventory.py)下载最新版本的 OpenStack inventory 脚本。

```

```

You can use the inventory script explicitly (by passing the -i openstack_inventory.py argument to Ansible) or implicitly (by placing the script at /etc/ansible/hosts).

您可以显式（通过向Ansible传递-i openstack inventory.py参数）或隐式（通过将脚本放置在/etc/Ansible/hosts）使用清单脚本。

#### 显式使用 OpenStack inventory 脚本

下载最新版本的 OpenStack 动态 inventory 脚本并使其可执行。

```bash
wget https://raw.githubusercontent.com/openstack/ansible-collections-openstack/master/scripts/inventory/openstack_inventory.py
chmod +x openstack_inventory.py
```

> **Note：**
>
> 不要将其命名为 openstack.py 。此名称将与从 openstacksdk 导入的内容冲突。

Source an OpenStack RC file:

```
source openstack.rc
```

> Note

An OpenStack RC file contains the environment variables required by  the client tools to establish a connection with the cloud provider, such as the authentication URL, user name, password and region name. For  more information on how to download, create or source an OpenStack RC  file, please refer to [Set environment variables using the OpenStack RC file](https://docs.openstack.org/user-guide/common/cli_set_environment_variables_using_openstack_rc.html).

Open Stack RC文件包含客户端工具与云提供商建立连接所需的环境变量，例如身份验证URL、用户名、密码和地区名称。有关如何下载、创建或源代码化Open Stack RC文件的更多信息，请参阅使用Open Stack RC文件设置环境变量。

You can confirm the file has been successfully sourced by running a simple command, such as nova list and ensuring it returns no errors.您可以通过运行一个简单的命令（如nova list）并确保它没有返回任何错误，来确认文件已被成功获取。

Note

The OpenStack command line clients are required to run the nova list command. For more information on how to install them, please refer to [Install the OpenStack command-line clients](https://docs.openstack.org/user-guide/common/cli_install_openstack_command_line_clients.html).Open Stack命令行客户端需要运行nova list命令。有关如何安装它们的更多信息，请参阅安装开放堆栈命令行客户端。

您可以手动测试 OpenStack 动态 inventory 脚本，以确认其工作正常：

```bash
./openstack_inventory.py --list
```

过了一会儿，您应该会看到一些 JSON 输出，其中包含有关计算实例的信息。

一旦确认动态 inventory 脚本按预期工作，就可以告诉 Ansible 将 openstack_inventory.py 脚本用作 inventory 文件，如下所示：

```bash
ansible -i openstack_inventory.py all -m ansible.builtin.ping
```

#### 隐式使用 OpenStack inventory 脚本

下载最新版本的 OpenStack 动态 inventory 脚本，使其可执行并将其复制到 /etc/ansible/hosts ：

```bash
wget https://raw.githubusercontent.com/openstack/ansible-collections-openstack/master/scripts/inventory/openstack_inventory.py
chmod +x openstack_inventory.py
sudo cp openstack_inventory.py /etc/ansible/hosts
```

下载示例配置文件，根据需要进行修改，然后将其复制到/etc/ansible/openstack.yml：

```bash
wget https://raw.githubusercontent.com/openstack/ansible-collections-openstack/master/scripts/inventory/openstack.yml
vi openstack.yml
sudo cp openstack.yml /etc/ansible/
```

您可以手动测试 OpenStack 动态 inventory 脚本，以确认其工作正常：

```bash
/etc/ansible/hosts --list
```

过了一会儿，您应该会看到一些 JSON 输出，其中包含有关计算实例的信息

#### 刷新缓存

请注意，OpenStack 动态 inventory 脚本将缓存结果以避免重复的 API 调用。要显式清除缓存，可以使用 `--refresh` 参数运行 openstackinventory.py（或hosts）脚本：

```bash
./openstack_inventory.py --refresh --list
```

### 其他 inventory 脚本

In Ansible 2.10 and later, inventory scripts moved to their associated collections. Many are now in the [community.general scripts/inventory directory](https://github.com/ansible-collections/community.general/tree/main/scripts/inventory). We recommend you use [Inventory plugins](https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins) instead.

在Ansible 2.10及更高版本中，库存脚本移动到其关联的集合。许多现在都在community.generalscripts/inventory目录中。我们建议您改用库存插件。

### 使用 inventory 目录和多个 inventory 源

If the location given to `-i` in Ansible is a directory (or as so configured in `ansible.cfg`), Ansible can use multiple inventory sources at the same time.  When doing so, it is possible to mix both dynamic and statically managed inventory sources in the same ansible run. Instant hybrid cloud!

如果Ansible中给-i的位置是一个目录（或在Ansible.cfg中如此配置），Ansible可以同时使用多个库存源。这样做时，可以在同一个可靠的运行中混合动态和静态管理的库存源。即时混合云！

In an inventory directory, executable files are treated as dynamic  inventory sources and most other files as static sources. Files which  end with any of the following are ignored:

在资源清册目录中，可执行文件被视为动态资源清册源，而大多数其他文件则被视为静态源。将忽略以以下任一项结尾的文件：

```bash
~, .orig, .bak, .ini, .cfg, .retry, .pyc, .pyo
```

You can replace this list with your own selection by configuring an `inventory_ignore_extensions` list in `ansible.cfg`, or setting the [`ANSIBLE_INVENTORY_IGNORE`](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_INVENTORY_IGNORE) environment variable. The value in either case must be a comma-separated list of patterns, as shown above.您可以通过在ansible.cfg中配置库存忽略扩展列表或设置ansible inventory ignore环境变量，用自己的选择替换此列表。两种情况下的值都必须是以逗号分隔的模式列表，如上所示。

Any `group_vars` and `host_vars` subdirectories in an inventory directory are interpreted as expected,  making inventory directories a powerful way to organize different sets  of configurations. See [Passing multiple inventory sources](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#using-multiple-inventory-sources) for more information.库存目录中的任何组变量和主机变量子目录都会按预期进行解释，从而使库存目录成为组织不同配置集的强大方式。有关详细信息，请参阅传递多个库存源。

### Static groups of dynamic groups 动态组的静态组

When defining groups of groups in the static inventory file, the child groups must also be defined in the static inventory file, otherwise ansible returns an error. If you want to define a static group of dynamic child groups, define the dynamic groups as empty in the static inventory file. 

在静态库存文件中定义组时，还必须在静态库存中定义子组，否则ansible将返回错误。如果要定义动态子组的静态组，请在静态库存文件中将动态组定义为空。例如：

```ini
[tag_Name_staging_foo]

[tag_Name_staging_bar]

[staging:children]
tag_Name_staging_foo
tag_Name_staging_bar
```

## Patterns: targeting hosts and groups模式：以主机和组为目标

When you execute Ansible through an ad hoc command or by running a  playbook, you must choose which managed nodes or groups you want to  execute against. Patterns let you run commands and playbooks against specific hosts  and/or groups in your inventory. An Ansible pattern can refer to a single host, an IP address, an  inventory group, a set of groups, or all hosts in your inventory. Patterns are highly flexible - you can exclude or require subsets of  hosts, use wildcards or regular expressions, and more. Ansible executes on all inventory hosts included in the pattern.

当您通过临时命令或运行剧本来执行Ansible时，必须选择要对哪些托管节点或组执行。模式允许您针对库存中的特定主机和/或组运行命令和脚本。Ansible模式可以指单个主机、IP地址、资源清册组、一组组或资源清册中的所有主机。模式非常灵活——您可以排除或要求主机的子集，使用通配符或正则表达式等。Ansible在模式中包含的所有库存主机上执行。

### 使用模式

You use a pattern almost any time you execute an ad hoc command or a playbook. The pattern is the only element of an [ad hoc command](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html#intro-adhoc) that has no flag. It is usually the second element:几乎在执行临时命令或剧本时都会使用模式。模式是临时命令中唯一没有标志的元素。它通常是第二个元素：

```bash
ansible <pattern> -m <module_name> -a "<module options>"
```

例如：

```bash
ansible webservers -m service -a "name=httpd state=restarted"
```

In a playbook the pattern is the content of the `hosts:` line for each play:在剧本中，模式是主持人的内容：每场戏的台词：

```yaml
- name: <play_name>
  hosts: <pattern>
```

例如：

```yaml
- name: restart webservers
  hosts: webservers
```

Since you often want to run a command or playbook against multiple  hosts at once, patterns often refer to inventory groups. Both the ad hoc command and the playbook above will execute against all machines in the `webservers` group.

由于您通常希望同时对多个主机运行一个命令或剧本，因此模式通常指库存组。上面的即席命令和剧本都将针对Web服务器组中的所有计算机执行。

### 常见模式

此表列出了针对 inventory 主机和组的常见模式。

| Description            | Pattern(s)                   | Targets                                             |
| ---------------------- | ---------------------------- | --------------------------------------------------- |
| All hosts              | all (or *)                   |                                                     |
| One host               | host1                        |                                                     |
| Multiple hosts         | host1:host2 (or host1,host2) |                                                     |
| One group              | webservers                   |                                                     |
| Multiple groups        | webservers:dbservers         | all hosts in webservers plus all hosts in dbservers |
| Excluding groups       | webservers:!atlanta          | all hosts in webservers except those in atlanta     |
| Intersection of groups | webservers:&staging          | any hosts in webservers that are also in staging    |

Note

You can use either a comma (`,`) or a colon (`:`) to separate a list of hosts. The comma is preferred when dealing with ranges and IPv6 addresses.可以使用逗号（，）或冒号（：）分隔主机列表。在处理范围和IPv6地址时，首选逗号。

Once you know the basic patterns, you can combine them. This example:

一旦知道了基本模式，就可以将它们组合起来。此示例：

```ini
webservers:dbservers:&staging:!phoenix
```

targets all machines in the groups ‘webservers’ and ‘dbservers’ that are also in the group ‘staging’, except any machines in the group ‘phoenix’.目标是组“webservers”和“dbservers”中也在组“staging”中的所有计算机，但组“phoenix”中的任何计算机除外。

You can use wildcard patterns with FQDNs or IP addresses, as long as  the hosts are named in your inventory by FQDN or IP address:您可以将通配符模式与FQDN或IP地址一起使用，只要主机在资源清册中按FQDN或IP名称即可：

```ini
192.0.*
*.example.com
*.com
```

You can mix wildcard patterns and groups at the same time:您可以同时混合通配符模式和组：

```ini
one*.com:dbservers
```

### 模式的限制

Patterns depend on inventory. If a host or group is not listed in  your inventory, you cannot use a pattern to target it. If your pattern  includes an IP address or hostname that does not appear in your  inventory, you will see an error like this:模式取决于库存。如果资源清册中未列出主机或组，则无法使用模式将其作为目标。如果您的模式中包含的IP地址或主机名未显示在资源清册中，则会出现如下错误：

```
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: Could not match supplied host pattern, ignoring: *.not_in_inventory.com
```

Your pattern must match your inventory syntax. If you define a host as an [alias](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases):您的模式必须与库存语法匹配。如果将主机定义为别名：

```
atlanta:
  host1:
    http_port: 80
    maxRequestsPerChild: 808
    host: 127.0.0.2
```

you must use the alias in your pattern. In the example above, you must use `host1` in your pattern. If you use the IP address, you will once again get the error:必须在模式中使用别名。在上面的示例中，必须在模式中使用host1。如果使用IP地址，将再次出现错误：

```
[WARNING]: Could not match supplied host pattern, ignoring: 127.0.0.2
```

### Pattern processing order

The processing is a bit special and happens in the following order:处理过程有点特殊，按以下顺序进行：

1. `:` and `,`
2. `&`
3. `!`

This positioning only accounts for processing order inside each operation: `a:b:&c:!d:!e == &c:a:!d:b:!e == !d:a:!e:&c:b`

此定位仅说明每个操作中的处理顺序：

所有这些都会导致以下结果：

Host in/is (a or b) AND host in/is all(c) AND host NOT in/is all(d, e).

Now `a:b:!e:!d:&c` is a slight change as the `!e` gets processed before the `!d`, though  this doesn’t make much of a difference:

Host in/is (a or b) AND host in/is all(c) AND host NOT in/is all(e, d).



主机在/中是（a或b），主机在/是所有（c），主机不在/是全部（d，e）。

现在a：b：！e： ！d： &c与！e在！d、 尽管这没有多大区别：

主机在/中是（a或b），主机在/是所有（c），主机不在/是全部（e，d）。Pattern processing order

### 高级模式选项

The common patterns described above will meet most of your needs, but Ansible offers several other ways to define the hosts and groups you  want to target.上面描述的常见模式将满足您的大多数需求，但Ansible提供了几种其他方法来定义您想要的主机和组。

#### 在模式中使用变量

You can use variables to enable passing group specifiers via the `-e` argument to ansible-playbook:您可以使用变量来启用通过-e参数将组说明符传递给ansible playbook：

```yaml
webservers:!{{ excluded }}:&{{ required }}
```

#### Using group position in patterns在模式中使用组位置

You can define a host or subset of hosts by its position in a group. For example, given the following group:您可以通过主机在组中的位置来定义主机或主机子集。例如，给定以下组：

```ini
[webservers]
cobweb
webbing
weber
```

you can use subscripts to select individual hosts or ranges within the webservers group:您可以使用下标选择Web服务器组中的各个主机或范围：

```ini
webservers[0]       # == cobweb
webservers[-1]      # == weber
webservers[0:2]     # == webservers[0],webservers[1]
                    # == cobweb,webbing
webservers[1:]      # == webbing,weber
webservers[:3]      # == cobweb,webbing,weber
```

#### 在模式中使用正则表达式

You can specify a pattern as a regular expression by starting the pattern with `~`:可以将模式指定为正则表达式，方法是以~开头：

```ini
~(web|db).*\.example\.com
```

### Patterns and ad-hoc commands 模式和特殊命令

You can change the behavior of the patterns defined in ad-hoc commands using command-line options. You can also limit the hosts you target on a particular run with the `--limit` flag.

您可以使用命令行选项更改在ad-hoc命令中定义的模式的行为。您还可以使用--limit标志限制特定运行中的目标主机。

- 仅限一台主机

```bash
$ ansible all -m [module] -a "[module options]" --limit "host1"
```

- 限制为多个主机

```bash
$ ansible all -m [module] -a "[module options]" --limit "host1,host2"
```

- Negated limit. Note that single quotes MUST be used to prevent bash interpolation.负极限。注意，必须使用单引号来防止bash插值。

```bash
$ ansible all -m [module] -a "[module options]" --limit 'all:!host1'
```

- Limit to host group限制到主机组

```bash
$ ansible all -m [module] -a "[module options]" --limit 'group1'
```

### Patterns and ansible-playbook flags模式和可解释的剧本标志

You can change the behavior of the patterns defined in playbooks  using command-line options. For example, you can run a playbook that  defines `hosts: all` on a single host by specifying `-i 127.0.0.2,` (note the trailing comma). This works even if the host you target is  not defined in your inventory, but this method will NOT read your  inventory for variables tied to this host and any variables required by  the playbook will need to be specified manually at the command line. You can also limit the hosts you target on a particular run with the `--limit` flag, which will reference your inventory:

您可以使用命令行选项更改剧本中定义的模式的行为。例如，您可以通过指定-i  127.0.0.2（注意后面的逗号）来运行一个定义hosts:all的playbook。即使您的目标主机未在清单中定义，此方法也能正常工作，但此方法不会读取与此主机相关的变量的清单，并且需要在命令行手动指定剧本所需的任何变量。您还可以使用--limit标志限制特定运行中的目标主机，该标志将引用您的资源清册：

```bash
ansible-playbook site.yml --limit datacenter2
```

Finally, you can use `--limit` to read the list of hosts from a file by prefixing the file name with `@`:最后，您可以使用--limit从文件中读取主机列表，方法是在文件名前面加上@：

```bash
ansible-playbook site.yml --limit @retry_hosts.txt
```

If [RETRY_FILES_ENABLED](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#retry-files-enabled) is set to `True`, a `.retry` file will be created after the `ansible-playbook` run containing a list of failed hosts from all plays. This file is overwritten each time `ansible-playbook` finishes running.

如果RETRY FILES ENABLED设置为True，则在运行包含所有播放中失败主机列表的可复制playbook后，将创建.RETRY文件。每次ansible playbook完成运行时，都会覆盖此文件。

```bash
ansible-playbook site.yml --limit @site.retry
```

To apply your knowledge of patterns with Ansible commands and playbooks, read [Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html#intro-adhoc) and [Ansible playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html#playbooks-intro).

要将您的模式知识应用于Ansible命令和剧本，请阅读ad-hoc命令和Ansible剧本简介。

## Connection methods and details连接方法和细节

This section shows you how to expand and refine the connection methods Ansible uses for your inventory.本节向您展示如何扩展和优化Ansible用于库存的连接方法。

### ControlPersist and paramiko控制Persist和paramiko

By default, Ansible uses native OpenSSH, because it supports ControlPersist (a performance feature), Kerberos, and options in `~/.ssh/config` such as Jump Host setup. If your control machine uses an older version  of OpenSSH that does not support ControlPersist, Ansible will fallback  to a Python implementation of OpenSSH called ‘paramiko’.

默认情况下，Ansible使用本机OpenSSH，因为它支持ControlPersist（一种性能特性）、Kerberos和~/.SSH/config中的选项，如JumpHost设置。如果您的控制计算机使用不支持control Persist的旧版本的Open SSH，Ansible将回退到名为“paramiko”的Open SSH的Python实现。

### Setting a remote user设置远程用户

By default, Ansible connects to all remote devices with the user name you are using on the control node. If that user name does not exist on a remote device, you can set a different user name for the connection. If you just need to do some tasks as a different user, look at [Understanding privilege escalation: become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become). You can set the connection user in a playbook:默认情况下，Ansible使用您在控制节点上使用的用户名连接到所有远程设备。如果远程设备上不存在该用户名，则可以为连接设置其他用户名。如果您只需要作为不同的用户执行一些任务，请查看了解权限升级：成为。您可以在剧本中设置连接用户：

```yaml
---
- name: update webservers
  hosts: webservers
  remote_user: admin

  tasks:
  - name: thing to do first in this playbook
  . . .
```

as a host variable in inventory:作为库存中的主机变量：

```yaml
other1.example.com     ansible_connection=ssh        ansible_user=myuser
other2.example.com     ansible_connection=ssh        ansible_user=myotheruser
```

or as a group variable in inventory:或作为库存中的组变量：

```yaml
cloud:
  hosts:
    cloud1: my_backup.cloud.com
    cloud2: my_backup2.cloud.com
  vars:
    ansible_user: admin
```

### 设置 SSH 密钥

By default, Ansible assumes you are using SSH keys to connect to  remote machines.  SSH keys are encouraged, but you can use password  authentication if needed with the `--ask-pass` option. If you need to provide a password for [privilege escalation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become) (sudo, pbrun, and so on), use `--ask-become-pass`.

默认情况下，Ansible假设您使用SSH密钥连接到远程计算机。鼓励使用SSH密钥，但如果需要，可以使用--ask-pass选项进行密码验证。如果您需要为权限升级提供密码（sudo、pbrun等），请使用--ask成为pass。

Note

Ansible does not expose a channel to allow communication between the  user and the ssh process to accept a password manually to decrypt an ssh key when using the ssh connection plugin (which is the default). The  use of `ssh-agent` is highly recommended.

Ansible不公开一个通道，允许用户和ssh进程之间的通信在使用ssh连接插件（默认）时手动接受密码以解密ssh密钥。强烈建议使用ssh代理。

To set up SSH agent to avoid retyping passwords, you can do:要设置SSH代理以避免重新键入密码，可以执行以下操作：

```bash
$ ssh-agent bash
$ ssh-add ~/.ssh/id_rsa
```

Depending on your setup, you may wish to use Ansible’s `--private-key` command line option to specify a pem file instead.  You can also add the private key file:根据您的设置，您可能希望使用Ansible的--private key命令行选项来指定pem文件。您还可以添加私钥文件：

```bash
$ ssh-agent bash
$ ssh-add ~/.ssh/keypair.pem
```

Another way to add private key files without using ssh-agent is using `ansible_ssh_private_key_file` in an inventory file as explained here:  [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#intro-inventory).

在不使用ssh代理的情况下添加私钥文件的另一种方法是在清单文件中使用可解析的ssh私钥文件，如下所述：如何构建清单。

### 在本地主机上运行

You can run commands against the control node by using “localhost” or “127.0.0.1” for the server name:您可以使用“localhost”或“127.0.0.1”作为服务器名称，对控制节点运行命令：

```bash
$ ansible localhost -m ping -e 'ansible_python_interpreter="/usr/bin/env python"'
```

You can specify localhost explicitly by adding this to your inventory file:通过将localhost添加到库存文件中，可以显式指定localhost：

```bash
localhost ansible_connection=local ansible_python_interpreter="/usr/bin/env python"
```

### Managing host key checking管理主机密钥检查

Ansible enables host key checking by default. Checking host keys  guards against server spoofing and man-in-the-middle attacks, but it  does require some maintenance.Ansible默认启用主机密钥检查。检查主机密钥可以防止服务器欺骗和中间人攻击，但确实需要一些维护。

If a host is reinstalled and has a different key in ‘known_hosts’,  this will result in an error message until corrected.  If a new host is  not in ‘known_hosts’ your control node may prompt for confirmation of  the key, which results in an interactive experience if using Ansible,  from say, cron. You might not want this.如果重新安装了主机，并且在“已知主机”中具有不同的密钥，则在更正之前，这将导致错误消息。如果新主机不在“已知主机”中，则控制节点可能会提示确认密钥，如果使用Ansible，例如cron，则会产生交互体验。你可能不想要这个。

If you understand the implications and wish to disable this behavior, you can do so by editing `/etc/ansible/ansible.cfg` or `~/.ansible.cfg`:如果您了解其中的含义并希望禁用此行为，可以通过编辑/etc/ansible/ansible.cfg或~/.ansiblecfg来实现：

```ini
[defaults]
host_key_checking = False
```

Alternatively this can be set by the [`ANSIBLE_HOST_KEY_CHECKING`](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_HOST_KEY_CHECKING) environment variable:或者，这可以通过ANSIBLE HOST KEY CHECKING环境变量设置：

```bash
$ export ANSIBLE_HOST_KEY_CHECKING=False
```

Also note that host key checking in paramiko mode is reasonably slow, therefore switching to ‘ssh’ is also recommended when using this  feature.还要注意，在paramiko模式下检查主机密钥相当慢，因此在使用此功能时也建议切换到“ssh”。

### 其他连接方式

Ansible can use a variety of connection methods beyond SSH. You can  select any connection plugin, including managing things locally and  managing chroot, lxc, and jail containers. A mode called ‘ansible-pull’ can also invert the system and have systems ‘phone home’ via scheduled git checkouts to pull configuration  directives from a central repository.

Ansible可以使用SSH之外的多种连接方法。您可以选择任何连接插件，包括本地管理和管理chroot、lxc和监狱容器。一种称为“ansible pull”的模式也可以反转系统，并通过计划的git签出将系统“呼叫总部”，以从中央存储库中提取配置指令。

## 验证

```bash
ansible-inventory -i inventory.ini --list
```