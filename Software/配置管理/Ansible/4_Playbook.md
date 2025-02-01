# playbooks

[TOC]

## 概述

Playbook 是 YAML 格式的自动化蓝图，Ansible 使用它来部署和配置 inventory 中的节点。

Ansible Playbook 提供了一个可重复、可重用、简单的配置管理和多机部署系统，非常适合部署复杂的应用程序。如果您需要多次使用 Ansible 执行任务，请编写 Playbook 并将其置于源代码控制之下。Then you can use the playbook to push out new configuration or  confirm the configuration of remote systems. 然后，您可以使用剧本推出新的配置或确认远程系统的配置。

Playbook 可以：

- 声明配置。
- orchestrate steps of any manual ordered process, on multiple sets of machines, in a defined order按照定义的顺序在多台机器上协调任何手动排序过程的步骤
- 同步或异步启动任务。

## 语法

Playbook 以最少语法的 YAML 格式表示。

Playbook 由有序列表中的一个或多个 “play” 组成。The terms ‘playbook’ and ‘play’ are sports analogies.“playbook”和“play”是体育类比。每个 play 都执行 playbook 总体目标的一部分，运行一个或多个任务。每个任务调用一个 Ansible 模块。

## 执行

playbook 从上到下依次运行。在每个 play 中，task 也按从上到下的顺序运行。Playbooks with multiple ‘plays’  can orchestrate multi-machine deployments, running one play on your  webservers, then another play on your database servers, then a third  play on your network infrastructure, and so on.任务具有多个“重头戏”的剧本可以协调多机部署，在Web服务器上运行一个重头戏，然后在数据库服务器上运行另一个重头戏、然后在网络基础设施上运行第三个重头戏，依此类推。每个 play 至少定义了两件事：

- the managed nodes to target, using a [pattern](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html#intro-patterns)使用模式将受控节点作为目标。
- 至少要执行一个任务。

> **Note：**
>
> 在 Ansible 2.10 及更高版本中，建议您在 playbook 中使用完全限定的集合名称，以确保选择了正确的模块，因为多个集合可以包含具有相同名称的模块（例如，`user`）。

在本例中，第一个 play 以web服务器为目标；第二个 play 以数据库服务器为目标。

```yaml
---
- name: Update web servers
  hosts: webservers
  remote_user: root

  tasks:
  - name: Ensure apache is at the latest version
    ansible.builtin.yum:
      name: httpd
      state: latest
  - name: Write the apache config file
    ansible.builtin.template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf

  - name: Update db servers
  	hosts: databases
  	remote_user: root

  tasks:
  - name: Ensure postgresql is at the latest version
    ansible.builtin.yum:
      name: postgresql
      state: latest
  - name: Ensure that postgresql is started
    ansible.builtin.service:
      name: postgresql
      state: started
```

你的 playbook 可以包括不止一个主机行和任务。例如，上面的 playbook 为每个 play 设置了一个 `remote_user` 。这是 SSH 连接的用户帐户。可以在 playbook 、play 或 task 级别添加其他 playbook 关键字，以影响 Ansible 的行为。Playbook 关键字可以控制连接插件、是否使用权限升级、如何处理错误等。To support a variety of environments,  Ansible lets you set many of these parameters as command-line flags, in  your Ansible configuration, or in your inventory. 为了支持各种环境，Ansible 允许您在 Ansible 配置或 inventory 中将这些参数中的许多设置为命令行标志。学习这些数据源的优先规则将有助于您扩展 Ansible 生态系统。

### 任务执行

默认情况下，Ansible 对主机模式匹配的所有机器按顺序执行每个任务，一次一个。每个任务都执行带有特定参数的模块。当一个任务在所有目标机器上执行后，Ansible 将继续执行下一个任务。可以使用策略来更改此默认行为。在每个 play 中，Ansible 对所有主机应用相同的任务指令。如果某个主机上的任务失败，Ansible 会将该主机排除在 playbook 的其余部分之外。

运行 playbook 时，Ansible 会返回有关连接的信息、所有 play 和 task 的 `name` 行、每个 task 在每台机器上是否成功，以及每个 task 是否在每台计算机上进行了更改。At the bottom of the playbook execution, Ansible provides a  summary of the nodes that were targeted and how they performed.在 playbook 执行的底部，Ansible 提供了目标节点的摘要以及它们是如何执行的。 General  failures and fatal “unreachable” communication attempts are kept  separate in the counts.一般故障和致命的“无法到达”通信尝试在计数中分开。



### 期望状态和“幂等性”

大多数 Ansible 模块检查是否已达到所需的最终状态，如果已达到该状态，则退出而不执行任何操作，这样重复任务不会改变最终状态。以这种方式运行的模块通常被称为“幂等”。无论你运行一次还是多次 playbook ，结果都应该是一样的。然而，并不是所有的 playbook 和 module 都是这样的。如果不确定，在生产环境中多次运行它们之前，请在沙盒环境中测试您的 playbook 。

### 运行 playbook

要运行 playbook ，请使用 ansible-playbook 命令。

```bash
ansible-playbook playbook.yml -f 10
```

在运行 playbook 时使用 `--verbose` 标志可以查看成功模块和失败模块的详细输出。

## Ansible-Pull

如果您想反转 Ansible 的体系结构，so that nodes check in to a central location,以便节点检入到中心位置，而不是将配置推给它们，您可以使用 Ansible-Pull 。

`ansible-pull` 是一个小脚本，that will checkout a repo of configuration instructions from git, 它将从git中检出配置指令的repo，然后针对该内容运行 `ansible-playbook` 。

Assuming you load balance your checkout location,假设您的结账位置负载平衡， `ansible-pull` 基本上无限扩展。

运行 `ansible-pull --help` 获取详细信息。

There’s also a [clever playbook](https://github.com/ansible/ansible-examples/blob/master/language_features/ansible_pull.yml) available to configure `ansible-pull` through a crontab from push mode.还有一个聪明的剧本可用于从推送模式配置通过crontab的可靠拉取。

## 验证 playbook

在运行 playbook 之前，可能需要验证 playbook 以捕获语法错误和其他问题。ansible-playbook 命令提供了几个验证选项，包括 `--check`， `--diff`， `--list-hosts`， `--list-tasks` 和 `--syntax-check` 。

### ansible-lint

在执行 playbook 之前，您可以使用 ansible-lint 对 playbook 进行详细的、特定于ansible的反馈。例如，if you run `ansible-lint` on the playbook called `verify-apache.yml` near the top of this page, 如果在该页面顶部附近名为verify-patche.yml的playbook上运行ansible lint，则应得到以下结果：

```bash
ansible-lint verify-apache.yml
[403] Package installs should not use latest
verify-apache.yml:8
Task/Handler: ensure apache is at the latest version
```

[ansible-lint 默认规则](https://docs.ansible.com/ansible-lint/rules/default_rules.html) 页面描述了每个错误。对于 `[403]` ，建议的修复方法是将 playbook 中的 `state: latest` 更改为 `state: present` 。



Playbook 记录并执行 Ansible 的配置、部署和编排功能。它们可以描述您希望远程系统执行的策略，或一般 IT 流程中的一组步骤。

如果 Ansible 模块是您 workshop 的工具，那么 playbook 就是您的指导手册，主机 inventory 就是您的原材料。

At a basic level,在基本级别上，playbook 可用于管理远程计算机的配置和部署。At a more advanced level, 在更高级的级别，they can sequence multi-tier rollouts  involving rolling updates, and can delegate actions to other hosts,  interacting with monitoring servers and load balancers along the way.他们可以对涉及滚动更新的多层部署进行排序，并可以将操作委派给其他主机，同时与监控服务器和负载平衡器进行交互。

Playbook 设计为人类可读，并以基本文本语言开发。有多种方法可以组织 playbook  及其包含的文件。

## 模板 (Jinja2)

Ansible 使用 Jinja2 模板来实现动态表达式以及对变量和 fact 的访问。可以将模板与 template 模块一起使用。例如，可以为配置文件创建模板，然后将该配置文件部署到多个环境，并为每个环境提供正确的数据（IP 地址、主机名、版本）。You can also use templating in playbooks directly, by templating task  names and more. 还可以通过模板化任务名称等直接在剧本中使用模板化。You can use all the [standard filters and tests](https://jinja.palletsprojects.com/en/3.1.x/templates/#builtin-filters) included in Jinja2.可以使用 Jinja2 中包含的所有标准过滤器和测试。 Ansible includes additional specialized filters for selecting and  transforming data, tests for evaluating template expressions, and [Lookup plugins](https://docs.ansible.com/ansible/latest/plugins/lookup.html#lookup-plugins) for retrieving data from external sources such as files, APIs, and databases for use in templating.Ansible 包括用于选择和转换数据的其他专用过滤器、用于评估模板表达式的测试，以及用于从外部源（如文件、API和数据库）检索数据以用于模板化的 Lookup 插件。

All templating happens on the Ansible controller **before** the task is sent and executed on the target machine. 在向目标计算机上发送和执行任务之前，所有模板都在 Ansible 控制器上进行。这种方法最大限度地减少了目标上的软件包要求（仅控制器上需要 jinja2 ）。它还限制了 Ansible 传递到目标机器的数据量。Ansible 解析控制器上的模板，只将每个任务所需的信息传递给目标机器，而不是将控制器上所有数据传递给目标机器并在其上解析。

> **Note：**
>
> template 模块使用的文件和数据必须使用 utf-8 编码。

## 使用筛选器处理数据

过滤器允许您将 JSON 数据转换为 YAML 数据，拆分 URL 以提取主机名，获取字符串的 SHA1 哈希，添加或相乘整数，等等。You can use the Ansible-specific filters  documented here to manipulate your data, or use any of the standard  filters shipped with Jinja2 可以使用此处记录的 Ansible 特定过滤器来处理数据，或使用 Jinja2 附带的任何标准过滤器。还可以使用 Python 方法来转换数据。可以创建自定义的 Ansible 过滤器作为插件，通常欢迎将新的过滤器添加到 Ansible 核心库中，这样每个人都可以使用它们。

Because templating happens on the Ansible controller, 因为模板化发生在 Ansible 控制器上，而不是目标主机上，所以过滤器在控制器上执行并在本地转换数据。

### 处理未定义的变量

过滤器可以通过提供默认值或使某些变量可选来帮助您管理缺失或未定义的变量。如果将 Ansible 配置为忽略大多数未定义的变量，则可以使用 `mandatory` 筛选器将某些变量标记为需要值。

#### 提供默认值

可以使用 Jinja2 “default” 过滤器直接在模板中为变量提供默认值。如果未定义变量，这通常比失败更好：

```jinja2
{{ some_variable | default(5) }}
```

在上面的示例中，如果未定义变量 “some variable” ，Ansible 将使用默认值 5 ，而不是引发 “undefined variable” 错误并失败。如果在角色中工作，还可以添加 `defaults/main.yml` 来定义角色中变量的默认值。

从 2.8 版开始，attempting to access an attribute of an  Undefined value in Jinja will return another Undefined value, rather  than throwing an error immediately. 尝试访问Jinja中未定义值的属性将返回另一个未定义值，而不是立即抛出错误。这意味着，you can now simply  use a default with a value in a nested data structure (in other words, `{{ foo.bar.baz | default('DEFAULT') }}`) when you do not know if the intermediate values are defined.当您不知道是否定义了中间值时，现在可以简单地在嵌套数据结构中使用带有值的默认值（换句话说，｛{foo.bar.baz|default（'default'）｝｝）。

如果要在变量求值为 false 或空字符串时使用默认值，则必须将第二个参数设置为 `true`：

```jinja2
{{ lookup('env', 'MY_USER') | default('admin', true) }}
```

#### 使变量可选

默认情况下，Ansible 需要模板表达式中所有变量的值。但是，可以将特定变量设置为可选的。例如，您可能希望对某些项目使用系统默认值，并控制其他项目的值。要使变量成为可选变量，请将默认值设置为特殊变量 `omit`：

```yaml
- name: Touch files with an optional mode
  ansible.builtin.file:
    dest: "{{ item.path }}"
    state: touch
    mode: "{{ item.mode | default(omit) }}"
  loop:
    - path: /tmp/foo
    - path: /tmp/bar
    - path: /tmp/baz
      mode: "0444"
```

在本例中， `/tmp/foo` 和 `/tmp/bar` 文件的默认模式由系统的 umask 决定。Ansible does not send a value for `mode`.Ansible不发送模式值。只有第三个文件 `/tmp/baz` 接收 mode=0444 选项。

> **Note：**
>
> If you are “chaining” additional filters after the `default(omit)` filter, you should instead do something like this: `"{{ foo | default(None) | some_filter or omit }}"`. In this example, the default `None` (Python null) value will cause the later filters to fail, which will trigger the `or omit` portion of the logic. Using `omit` in this manner is very specific to the later filters you are chaining  though, so be prepared for some trial and error if you do this.
>
> 如果在默认（省略）筛选器之后“链接”其他筛选器，则应改为执行以下操作：“｛｛foo|default（None）| some filter or省略｝｝”。在本例中，默认None（Python  null）值将导致后面的过滤器失败，这将触发逻辑的或省略部分。在这个人身上使用省略

#### 定义强制值

如果将 Ansible 配置为忽略未定义的变量，则可能需要将某些值定义为强制值。默认情况下，如果 playbook 或 command 中的变量未定义，Ansible 将失败。通过将 DEFAULT_UNDEFINED_VAR_BEHAVIOR 设置为`false` ，可以将 Ansible 配置为允许未定义的变量。在这种情况下，您可能需要定义一些变量。您可以通过以下方式执行此操作：

```jinja2
{{ variable | mandatory }}
```

The variable value will be used as is, but the template evaluation will raise an error if it is undefined.

变量值将按原样使用，但如果未定义，模板求值将引发错误。

要求重写变量的一种方便方法是使用undef关键字给它一个未定义的值。这在角色的默认值中很有用。

A convenient way of requiring a variable to be overridden is to give it an undefined value using the `undef` keyword. This can be useful in a role’s defaults.

```yaml
galaxy_url: "https://galaxy.ansible.com"
galaxy_api_key: {{ undef(hint="You must specify your Galaxy API key") }}
```

### Defining different values for true/false/null (ternary)

You can create a test, then define one value to use when the test  returns true and another when the test returns false (new in version  1.9):

为真/假/空（三进制）定义不同的值

您可以创建一个测试，然后定义一个值，当测试返回true时使用，另一个值在测试返回false时使用（1.9版中新增）：

```
{{ (status == 'needs_restart') | ternary('restart', 'continue') }}
```

In addition, you can define a one value to use on true, one value on false and a third value on null (new in version 2.8):

此外，您可以在true上定义一个值，在false上定义一值，在null上定义第三个值（2.8版中新增）：

```
{{ enabled | ternary('no shutdown', 'shutdown', omit) }}
```

### Managing data types

You might need to know, change, or set the data type on a variable.  For example, a registered variable might contain a dictionary when your  next task needs a list, or a user [prompt](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html#playbooks-prompts) might return a string when your playbook needs a boolean value. Use the `type_debug`, `dict2items`, and `items2dict` filters to manage data types. You can also use the data type itself to cast a value as a specific data type.

#### Discovering the data type

New in version 2.3.

If you are unsure of the underlying Python type of a variable, you can use the `type_debug` filter to display it. This is useful in debugging when you need a particular type of variable:

管理数据类型

您可能需要知道、更改或设置变量的数据类型。例如，当您的下一个任务需要列表时，注册变量可能包含字典，或者当您的剧本需要布尔值时，用户提示可能返回字符串。使用类型debug、dict2items和items2dict筛选器来管理数据类型。还可以使用数据类型本身将值转换为特定的数据类型。

发现数据类型

2.3版新增。

如果您不确定变量的基本Python类型，可以使用类型调试筛选器来显示它。当您需要特定类型的变量时，这在调试中非常有用：

```
{{ myvar | type_debug }}
```

You should note that, while this may seem like a useful filter for  checking that you have the right type of data in a variable, you should  often prefer [type tests](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tests.html#type-tests), which will allow you to test for specific data types.

#### Transforming dictionaries into lists

New in version 2.6.

Use the `dict2items` filter to transform a dictionary into a list of items suitable for [looping](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#playbooks-loops):

您应该注意，虽然这似乎是一个检查变量中数据类型是否正确的有用过滤器，但您应该经常选择类型测试，这将允许您测试特定的数据类型。

将字典转换为列表

2.6版新增。

使用dict2items过滤器将字典转换为适合循环的项目列表：

```
{{ dict | dict2items }}
```

Dictionary data (before applying the `dict2items` filter):字典数据（在应用dict2items筛选器之前）：

```
tags:
  Application: payment
  Environment: dev
```

List data (after applying the `dict2items` filter):列表数据（应用dict2items筛选器后）：

```
- key: Application
  value: payment
- key: Environment
  value: dev
```

New in version 2.8.

The `dict2items` filter is the reverse of the `items2dict` filter.

If you want to configure the names of the keys, the `dict2items` filter accepts 2 keyword arguments. Pass the `key_name` and `value_name` arguments to configure the names of the keys in the list output:

2.8版新增。

dict2items过滤器与items2dict过滤器相反。

如果要配置键的名称，dict2items过滤器接受2个关键字参数。传递键名称和值名称参数以配置列表输出中键的名称：

```
{{ files | dict2items(key_name='file', value_name='path') }}
```

Dictionary data (before applying the `dict2items` filter):字典数据（在应用dict2items筛选器之前）：

```
files:
  users: /etc/passwd
  groups: /etc/group
```

List data (after applying the `dict2items` filter):字典数据（在应用dict2items筛选器之前）：

```
- file: users
  path: /etc/passwd
- file: groups
  path: /etc/group
```

#### Transforming lists into dictionaries

New in version 2.7.

Use the `items2dict` filter to transform a list into a dictionary, mapping the content into `key: value` pairs:

将列表转换为字典

2.7版新增。

使用items2dict过滤器将列表转换为字典，将内容映射为键：值对：

```
{{ tags | items2dict }}
```

List data (before applying the `items2dict` filter):列表数据（在应用items2dict过滤器之前）：

```
tags:
  - key: Application
    value: payment
  - key: Environment
    value: dev
```

Dictionary data (after applying the `items2dict` filter):字典数据（应用items2dict过滤器后）：

```
Application: payment
Environment: dev
```

The `items2dict` filter is the reverse of the `dict2items` filter.

Not all lists use `key` to designate keys and `value` to designate values. For example:

items2dict过滤器与dict2items过滤器相反。

并非所有列表都使用键来指定键，使用值来指定值。例如：

```
fruits:
  - fruit: apple
    color: red
  - fruit: pear
    color: yellow
  - fruit: grapefruit
    color: yellow
```

In this example, you must pass the `key_name` and `value_name` arguments to configure the transformation. For example:

在此示例中，必须传递键名称和值名称参数来配置转换。例如：

```
{{ tags | items2dict(key_name='fruit', value_name='color') }}
```

If you do not pass these arguments, or do not pass the correct values for your list, you will see `KeyError: key` or `KeyError: my_typo`.

#### Forcing the data type

You can cast values as certain types. For example, if you expect the input “True” from a [vars_prompt](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html#playbooks-prompts) and you want Ansible to recognize it as a boolean value instead of a string:

如果您没有传递这些参数，或者没有为列表传递正确的值，您将看到Key Error:Key或Key Error:my typ。

强制数据类型

可以将值转换为特定类型。例如，如果您希望从vars提示符中输入“True”，并且希望Ansible将其识别为布尔值而不是字符串：

```
- ansible.builtin.debug:
     msg: test
  when: some_string_value | bool
```

If you want to perform a mathematical comparison on a fact and you  want Ansible to recognize it as an integer instead of a string:

如果您想对一个事实进行数学比较，并且希望Ansible将其识别为整数而不是字符串：

```
- shell: echo "only on Red Hat 6, derivatives, and later"
  when: ansible_facts['os_family'] == "RedHat" and ansible_facts['lsb']['major_release'] | int >= 6
```

New in version 1.6.

### Formatting data: YAML and JSON

You can switch a data structure in a template from or to JSON or YAML format, with options for formatting, indenting, and loading data. The  basic filters are occasionally useful for debugging:

1.6版新增。

格式化数据：YAML和JSON

您可以将模板中的数据结构从JSON或YAML格式切换到JSON或YAML格式，并提供格式化、缩进和加载数据的选项。基本过滤器偶尔对调试有用：

```
{{ some_variable | to_json }}
{{ some_variable | to_yaml }}
```

For human readable output, you can use:

对于可读输出，可以使用：

```
{{ some_variable | to_nice_json }}
{{ some_variable | to_nice_yaml }}
```

You can change the indentation of either format:

您可以更改任一格式的缩进：

```
{{ some_variable | to_nice_json(indent=2) }}
{{ some_variable | to_nice_yaml(indent=8) }}
```

The `to_yaml` and `to_nice_yaml` filters use the [PyYAML library](https://pyyaml.org/) which has a default 80 symbol string length limit. That causes  unexpected line break after 80th symbol (if there is a space after 80th  symbol) To avoid such behavior and generate long lines, use the `width` option. You must use a hardcoded number to define the width, instead of a construction like `float("inf")`, because the filter does not support proxying Python functions. For example:

to yaml和to nice yaml过滤器使用Py  yaml库，该库具有默认的80个符号字符串长度限制。这会导致第80个符号后出现意外的换行符（如果第80个字符后有空格）。要避免这种行为并生成长行，请使用宽度选项。必须使用硬编码数字来定义宽度，而不是像float（“inf”）这样的构造，因为过滤器不支持代理Python函数。例如：

```
{{ some_variable | to_yaml(indent=8, width=1337) }}
{{ some_variable | to_nice_yaml(indent=8, width=1337) }}
```

The filter does support passing through other YAML parameters. For a full list, see the [PyYAML documentation](https://pyyaml.org/wiki/PyYAMLDocumentation) for `dump()`.

If you are reading in some already formatted data:

过滤器支持传递其他YAML参数。有关完整列表，请参阅dump（）的PyYAML文档。

如果您正在读取一些已格式化的数据：

```
{{ some_variable | from_json }}
{{ some_variable | from_yaml }}
```

例如：

```
tasks:
  - name: Register JSON output as a variable
    ansible.builtin.shell: cat /some/path/to/file.json
    register: result

  - name: Set a variable
    ansible.builtin.set_fact:
      myvar: "{{ result.stdout | from_json }}"
```

#### Filter to_json and Unicode support

By default to_json and to_nice_json will convert data received to ASCII, so:

过滤到json和Unicode支持

默认情况下，json和nice json会将接收到的数据转换为ASCII，因此：

```
{{ 'München'| to_json }}
```

将返回：

```
'M\u00fcnchen'
```

To keep Unicode characters, pass the parameter ensure_ascii=False to the filter:要保留Unicode字符，请将参数确保ascii=False传递给筛选器：

```
{{ 'München'| to_json(ensure_ascii=False) }}

'München'
```

New in version 2.7.

To parse multi-document YAML strings, the `from_yaml_all` filter is provided. The `from_yaml_all` filter will return a generator of parsed YAML documents.

for example:

2.7版新增。

为了解析多文档YAML字符串，提供了from YAML all过滤器。from yaml all过滤器将返回一个已解析yaml文档的生成器。

例如：

```
tasks:
  - name: Register a file content as a variable
    ansible.builtin.shell: cat /some/path/to/multidoc-file.yaml
    register: result

  - name: Print the transformed variable
    ansible.builtin.debug:
      msg: '{{ item }}'
    loop: '{{ result.stdout | from_yaml_all | list }}'
```

### Combining and selecting data

You can combine data from multiple sources and types, and select  values from large data structures, giving you precise control over  complex data.

#### Combining items from multiple lists: zip and zip_longest

New in version 2.3.

To get a list combining the elements of other lists use `zip`:

组合和选择数据

您可以组合来自多个源和类型的数据，并从大型数据结构中选择值，从而对复杂数据进行精确控制。

组合多个列表中的项目：zip和zip最长

2.3版新增。

要获得包含其他列表元素的列表，请使用zip：

```
- name: Give me list combo of two lists
  ansible.builtin.debug:
    msg: "{{ [1,2,3,4,5,6] | zip(['a','b','c','d','e','f']) | list }}"

# => [[1, "a"], [2, "b"], [3, "c"], [4, "d"], [5, "e"], [6, "f"]]

- name: Give me shortest combo of two lists
  ansible.builtin.debug:
    msg: "{{ [1,2,3] | zip(['a','b','c','d','e','f']) | list }}"

# => [[1, "a"], [2, "b"], [3, "c"]]
```

To always exhaust all lists use `zip_longest`:

要始终列出所有列表，请使用zip最长：

```
- name: Give me longest combo of three lists , fill with X
  ansible.builtin.debug:
    msg: "{{ [1,2,3] | zip_longest(['a','b','c','d','e','f'], [21, 22, 23], fillvalue='X') | list }}"

# => [[1, "a", 21], [2, "b", 22], [3, "c", 23], ["X", "d", "X"], ["X", "e", "X"], ["X", "f", "X"]]
```

Similarly to the output of the `items2dict` filter mentioned above, these filters can be used to construct a `dict`:

与上面提到的items2dict过滤器的输出类似，这些过滤器可用于构造dict：

```
{{ dict(keys_list | zip(values_list)) }}
```

List data (before applying the `zip` filter):列出数据（在应用zip筛选器之前）：

```
keys_list:
  - one
  - two
values_list:
  - apple
  - orange
```

Dictionary data (after applying the `zip` filter):字典数据（应用zip筛选器后）：

```
one: apple
two: orange
```

#### Combining objects and subelements

New in version 2.7.

The `subelements` filter produces a product of an object and the subelement values of that object, similar to the `subelements` lookup. This lets you specify individual subelements to use in a template. For example, this expression:

组合对象和子元素

2.7版新增。

子元素过滤器生成对象和该对象的子元素值的乘积，类似于子元素查找。这允许您指定要在模板中使用的各个子元素。例如，此表达式：

```
{{ users | subelements('groups', skip_missing=True) }}
```

Data before applying the `subelements` filter:

应用子元素筛选器之前的数据：

```
users:
- name: alice
  authorized:
  - /tmp/alice/onekey.pub
  - /tmp/alice/twokey.pub
  groups:
  - wheel
  - docker
- name: bob
  authorized:
  - /tmp/bob/id_rsa.pub
  groups:
  - docker
```

Data after applying the `subelements` filter:应用子元素筛选器后的数据：

```
-
  - name: alice
    groups:
    - wheel
    - docker
    authorized:
    - /tmp/alice/onekey.pub
    - /tmp/alice/twokey.pub
  - wheel
-
  - name: alice
    groups:
    - wheel
    - docker
    authorized:
    - /tmp/alice/onekey.pub
    - /tmp/alice/twokey.pub
  - docker
-
  - name: bob
    authorized:
    - /tmp/bob/id_rsa.pub
    groups:
    - docker
  - docker
```

You can use the transformed data with `loop` to iterate over the same subelement for multiple objects:

您可以使用带循环的转换数据来迭代多个对象的同一子元素：

```
- name: Set authorized ssh key, extracting just that data from 'users'
  ansible.posix.authorized_key:
    user: "{{ item.0.name }}"
    key: "{{ lookup('file', item.1) }}"
  loop: "{{ users | subelements('authorized') }}"
```

#### Combining hashes/dictionaries

New in version 2.

The `combine` filter allows hashes to be merged. For example, the following would override keys in one hash:

组合哈希/字典

2.0版中的新功能。

组合过滤器允许合并哈希。例如，以下内容将覆盖一个哈希中的键：

```
{{ {'a':1, 'b':2} | combine({'b':3}) }}
```

The resulting hash would be:生成的哈希值为：

```
{'a':1, 'b':3}
```

The filter can also take multiple arguments to merge:过滤器还可以采用多个参数进行合并：

```
{{ a | combine(b, c, d) }}
{{ [a, b, c, d] | combine }}
```

In this case, keys in `d` would override those in `c`, which would override those in `b`, and so on.

The filter also accepts two optional parameters: `recursive` and `list_merge`.

- recursive

  Is a boolean, default to `False`. Should the `combine` recursively merge nested hashes. Note: It does **not** depend on the value of the `hash_behaviour` setting in `ansible.cfg`.

- list_merge

  Is a string, its possible values are `replace` (default), `keep`, `append`, `prepend`, `append_rp` or `prepend_rp`. It modifies the behaviour of `combine` when the hashes to merge contain arrays/lists.

在这种情况下，d中的键将覆盖c中的键，这将覆盖b中的键等等。

过滤器还接受两个可选参数：递归和列表合并。

递归的

是布尔值，默认为False。组合是否应递归合并嵌套哈希。注意：它不取决于ansible.cfg中哈希行为设置的值。

列表合并

是一个字符串，其可能值为replace（默认值）、keep、append、prepend、append rp或prepend rp。当要合并的哈希包含数组/列表时，它会修改组合的行为。

```
default:
  a:
    x: default
    y: default
  b: default
  c: default
patch:
  a:
    y: patch
    z: patch
  b: patch
```

If `recursive=False` (the default), nested hash aren’t merged:如果recursive=False（默认值），则不会合并嵌套哈希：

```
{{ default | combine(patch) }}
```

This would result in:这将导致：

```
a:
  y: patch
  z: patch
b: patch
c: default
```

If `recursive=True`, recurse into nested hash and merge their keys:如果recursive=True，则递归到嵌套哈希并合并其键：

```
{{ default | combine(patch, recursive=True) }}
```

This would result in:这将导致：

```
a:
  x: default
  y: patch
  z: patch
b: patch
c: default
```

If `list_merge='replace'` (the default), arrays from the right hash will “replace” the ones in the left hash:如果列表合并=“替换”（默认值），右侧哈希中的数组将“替换”左侧哈希中的：

```
default:
  a:
    - default
patch:
  a:
    - patch
{{ default | combine(patch) }}
```

This would result in:这将导致：

```
a:
  - patch
```

If `list_merge='keep'`, arrays from the left hash will be kept:如果列表合并='keep'，将保留左侧哈希中的数组：

```
{{ default | combine(patch, list_merge='keep') }}
```

This would result in:这将导致：

```
a:
  - default
```

If `list_merge='append'`, arrays from the right hash will be appended to the ones in the left hash:

如果列表合并=“append”，则右侧哈希中的数组将被附加到左侧哈希中的阵列：

```
{{ default | combine(patch, list_merge='append') }}
```

This would result in:这将导致：

```
a:
  - default
  - patch
```

If `list_merge='prepend'`, arrays from the right hash will be prepended to the ones in the left hash:如果列表合并=“append”，则右侧哈希中的数组将被附加到左侧哈希中的阵列：

```
{{ default | combine(patch, list_merge='prepend') }}
```

This would result in:这将导致：

```
a:
  - patch
  - default
```

If `list_merge='append_rp'`, arrays from the right hash will be appended to the ones in the left  hash. Elements of arrays in the left hash that are also in the  corresponding array of the right hash will be removed (“rp” stands for  “remove present”). Duplicate elements that aren’t in both hashes are  kept:

如果列表合并=“append rp”，则右哈希中的数组将附加到左哈希中的那些数组。左侧哈希中的数组元素也位于右侧哈希的相应数组中，将被移除（“rp”代表“移除当前”）。保留不在两个哈希中的重复元素：

```
default:
  a:
    - 1
    - 1
    - 2
    - 3
patch:
  a:
    - 3
    - 4
    - 5
    - 5
{{ default | combine(patch, list_merge='append_rp') }}
```

This would result in:

```
a:
  - 1
  - 1
  - 2
  - 3
  - 4
  - 5
  - 5
```

If `list_merge='prepend_rp'`, the behavior is similar to the one for `append_rp`, but elements of arrays in the right hash are prepended:如果list merge='preend rp'，则行为与append rp的行为类似，但右哈希中数组的元素是前置的：

```
{{ default | combine(patch, list_merge='prepend_rp') }}
```

This would result in:

```
a:
  - 3
  - 4
  - 5
  - 5
  - 1
  - 1
  - 2
```

`recursive` and `list_merge` can be used together:递归和列表合并可以一起使用：

```
default:
  a:
    a':
      x: default_value
      y: default_value
      list:
        - default_value
  b:
    - 1
    - 1
    - 2
    - 3
patch:
  a:
    a':
      y: patch_value
      z: patch_value
      list:
        - patch_value
  b:
    - 3
    - 4
    - 4
    - key: value
{{ default | combine(patch, recursive=True, list_merge='append_rp') }}
```

This would result in:

```
a:
  a':
    x: default_value
    y: patch_value
    z: patch_value
    list:
      - default_value
      - patch_value
b:
  - 1
  - 1
  - 2
  - 3
  - 4
  - 4
  - key: value
```

#### Selecting values from arrays or hashtables

New in version 2.1.

The extract filter is used to map from a list of indices to a list of values from a container (hash or array):

从数组或哈希表中选择值

2.1版中的新增功能。

提取过滤器用于从索引列表映射到容器（哈希或数组）中的值列表：

```
{{ [0,2] | map('extract', ['x','y','z']) | list }}
{{ ['x','y'] | map('extract', {'x': 42, 'y': 31}) | list }}
```

The results of the above expressions would be:

上述表达式的结果为：

```
['x', 'z']
[42, 31]
```

The filter can take another argument:

过滤器可以采用另一个参数：

```
{{ groups['x'] | map('extract', hostvars, 'ec2_ip_address') | list }}
```

This takes the list of hosts in group ‘x’, looks them up in hostvars, and then looks up the ec2_ip_address of the result. The final result is a list of IP addresses for the hosts in group ‘x’.

The third argument to the filter can also be a list, for a recursive lookup inside the container:\

这将获取组“x”中的主机列表，在hostvars中查找它们，然后查找结果的ec2ip地址。最终结果是组“x”中主机的IP地址列表。

对于容器内的递归查找，过滤器的第三个参数也可以是列表：

```
{{ ['a'] | map('extract', b, ['x','y']) | list }}
```

This would return a list containing the value of b[‘a’][‘x’][‘y’].

#### Combining lists

This set of filters returns a list of combined lists.

##### permutations

To get permutations of a list:

这将返回一个包含b['a']['x']['y']值的列表。

组合列表

这组过滤器返回组合列表的列表。

排列

要获取列表的排列：

```
- name: Give me largest permutations (order matters)
  ansible.builtin.debug:
    msg: "{{ [1,2,3,4,5] | ansible.builtin.permutations | list }}"

- name: Give me permutations of sets of three
  ansible.builtin.debug:
    msg: "{{ [1,2,3,4,5] | ansible.builtin.permutations(3) | list }}"
```

##### combinations

Combinations always require a set size:

组合

组合始终需要设置大小：

```
- name: Give me combinations for sets of two
  ansible.builtin.debug:
    msg: "{{ [1,2,3,4,5] | ansible.builtin.combinations(2) | list }}"
```

Also see the [zip_filter](https://docs.ansible.com/ansible/7/collections/ansible/builtin/zip_filter.html#zip-filter)

##### products

The product filter returns the [cartesian product](https://docs.python.org/3/library/itertools.html#itertools.product) of the input iterables. This is roughly equivalent to nested for-loops in a generator expression.

For example:

另请参见zip过滤器

产品

乘积过滤器返回输入可迭代项的笛卡尔乘积。这大致相当于生成器表达式中嵌套的for循环。

例如：

```
- name: Generate multiple hostnames
  ansible.builtin.debug:
    msg: "{{ ['foo', 'bar'] | product(['com']) | map('join', '.') | join(',') }}"
```

This would result in:

```
{ "msg": "foo.com,bar.com" }
```

#### Selecting JSON data: JSON queries

To select a single element or a data subset from a complex data structure in JSON format (for example, Ansible facts), use the `json_query` filter.  The `json_query` filter lets you query a complex JSON structure and iterate over it using a loop structure.

Note

This filter has migrated to the [community.general](https://galaxy.ansible.com/community/general) collection. Follow the installation instructions to install that collection.

Note

You must manually install the **jmespath** dependency on the Ansible controller before using this filter. This filter is built upon **jmespath**, and you can use the same syntax. For examples, see [jmespath examples](https://jmespath.org/examples.html).

Consider this data structure:

```
{
    "domain_definition": {
        "domain": {
            "cluster": [
                {
                    "name": "cluster1"
                },
                {
                    "name": "cluster2"
                }
            ],
            "server": [
                {
                    "name": "server11",
                    "cluster": "cluster1",
                    "port": "8080"
                },
                {
                    "name": "server12",
                    "cluster": "cluster1",
                    "port": "8090"
                },
                {
                    "name": "server21",
                    "cluster": "cluster2",
                    "port": "9080"
                },
                {
                    "name": "server22",
                    "cluster": "cluster2",
                    "port": "9090"
                }
            ],
            "library": [
                {
                    "name": "lib1",
                    "target": "cluster1"
                },
                {
                    "name": "lib2",
                    "target": "cluster2"
                }
            ]
        }
    }
}
```

To extract all clusters from this structure, you can use the following query:

```
- name: Display all cluster names
  ansible.builtin.debug:
    var: item
  loop: "{{ domain_definition | community.general.json_query('domain.cluster[*].name') }}"
```

To extract all server names:

```
- name: Display all server names
  ansible.builtin.debug:
    var: item
  loop: "{{ domain_definition | community.general.json_query('domain.server[*].name') }}"
```

To extract ports from cluster1:

```
- name: Display all ports from cluster1
  ansible.builtin.debug:
    var: item
  loop: "{{ domain_definition | community.general.json_query(server_name_cluster1_query) }}"
  vars:
    server_name_cluster1_query: "domain.server[?cluster=='cluster1'].port"
```

Note

You can use a variable to make the query more readable.

To print out the ports from cluster1 in a comma separated string:

```
- name: Display all ports from cluster1 as a string
  ansible.builtin.debug:
    msg: "{{ domain_definition | community.general.json_query('domain.server[?cluster==`cluster1`].port') | join(', ') }}"
```

Note

In the example above, quoting literals using backticks avoids escaping quotes and maintains readability.

You can use YAML [single quote escaping](https://yaml.org/spec/current.html#id2534365):

```
- name: Display all ports from cluster1
  ansible.builtin.debug:
    var: item
  loop: "{{ domain_definition | community.general.json_query('domain.server[?cluster==''cluster1''].port') }}"
```

Note

Escaping single quotes within single quotes in YAML is done by doubling the single quote.

To get a hash map with all ports and names of a cluster:

```
- name: Display all server ports and names from cluster1
  ansible.builtin.debug:
    var: item
  loop: "{{ domain_definition | community.general.json_query(server_name_cluster1_query) }}"
  vars:
    server_name_cluster1_query: "domain.server[?cluster=='cluster2'].{name: name, port: port}"
```

To extract ports from all clusters with name starting with ‘server1’:

```
- name: Display all ports from cluster1
  ansible.builtin.debug:
    msg: "{{ domain_definition | to_json | from_json | community.general.json_query(server_name_query) }}"
  vars:
    server_name_query: "domain.server[?starts_with(name,'server1')].port"
```

To extract ports from all clusters with name containing ‘server1’:

```
- name: Display all ports from cluster1
  ansible.builtin.debug:
    msg: "{{ domain_definition | to_json | from_json | community.general.json_query(server_name_query) }}"
  vars:
    server_name_query: "domain.server[?contains(name,'server1')].port"
```

Note

while using `starts_with` and `contains`, you have to use `` to_json | from_json `` filter for correct parsing of data structure.

### Randomizing data

When you need a randomly generated value, use one of these filters.

#### Random MAC addresses

New in version 2.6.

This filter can be used to generate a random MAC address from a string prefix.

Note

This filter has migrated to the [community.general](https://galaxy.ansible.com/community/general) collection. Follow the installation instructions to install that collection.

To get a random MAC address from a string prefix starting with ‘52:54:00’:

```
"{{ '52:54:00' | community.general.random_mac }}"
# => '52:54:00:ef:1c:03'
```

Note that if anything is wrong with the prefix string, the filter will issue an error.

> New in version 2.9.

As of Ansible version 2.9, you can also initialize the random number  generator from a seed to create random-but-idempotent MAC addresses:

```
"{{ '52:54:00' | community.general.random_mac(seed=inventory_hostname) }}"
```

#### Random items or numbers

The `random` filter in Ansible is an extension of the default Jinja2 random filter,  and can be used to return a random item from a sequence of items or to  generate a random number based on a range.

To get a random item from a list:

```
"{{ ['a','b','c'] | random }}"
# => 'c'
```

To get a random number between 0 (inclusive) and a specified integer (exclusive):

```
"{{ 60 | random }} * * * * root /script/from/cron"
# => '21 * * * * root /script/from/cron'
```

To get a random number from 0 to 100 but in steps of 10:

```
{{ 101 | random(step=10) }}
# => 70
```

To get a random number from 1 to 100 but in steps of 10:

```
{{ 101 | random(1, 10) }}
# => 31
{{ 101 | random(start=1, step=10) }}
# => 51
```

You can initialize the random number generator from a seed to create random-but-idempotent numbers:

```
"{{ 60 | random(seed=inventory_hostname) }} * * * * root /script/from/cron"
```

#### Shuffling a list

The `shuffle` filter randomizes an existing list, giving a different order every invocation.

To get a random list from an existing  list:

```
{{ ['a','b','c'] | shuffle }}
# => ['c','a','b']
{{ ['a','b','c'] | shuffle }}
# => ['b','c','a']
```

You can initialize the shuffle generator from a seed to generate a random-but-idempotent order:

```
{{ ['a','b','c'] | shuffle(seed=inventory_hostname) }}
# => ['b','a','c']
```

The shuffle filter returns a list whenever possible. If you use it with a non ‘listable’ item, the filter does nothing.

### Managing list variables

You can search for the minimum or maximum value in a list, or flatten a multi-level list.

To get the minimum value from list of numbers:

```
{{ list1 | min }}
```

New in version 2.11.

To get the minimum value in a list of objects:

```
{{ [{'val': 1}, {'val': 2}] | min(attribute='val') }}
```

To get the maximum value from a list of numbers:

```
{{ [3, 4, 2] | max }}
```

New in version 2.11.

To get the maximum value in a list of objects:

```
{{ [{'val': 1}, {'val': 2}] | max(attribute='val') }}
```

New in version 2.5.

Flatten a list (same thing the flatten lookup does):

```
{{ [3, [4, 2] ] | flatten }}
# => [3, 4, 2]
```

Flatten only the first level of a list (akin to the items lookup):

```
{{ [3, [4, [2]] ] | flatten(levels=1) }}
# => [3, 4, [2]]
```

New in version 2.11.

Preserve nulls in a list, by default flatten removes them. :

```
{{ [3, None, [4, [2]] ] | flatten(levels=1, skip_nulls=False) }}
# => [3, None, 4, [2]]
```

### Selecting from sets or lists (set theory)

You can select or combine items from sets or lists.

New in version 1.4.

To get a unique set from a list:

```
# list1: [1, 2, 5, 1, 3, 4, 10]
{{ list1 | unique }}
# => [1, 2, 5, 3, 4, 10]
```

To get a union of two lists:

```
# list1: [1, 2, 5, 1, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]
{{ list1 | union(list2) }}
# => [1, 2, 5, 1, 3, 4, 10, 11, 99]
```

To get the intersection of 2 lists (unique list of all items in both):

```
# list1: [1, 2, 5, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]
{{ list1 | intersect(list2) }}
# => [1, 2, 5, 3, 4]
```

To get the difference of 2 lists (items in 1 that don’t exist in 2):

```
# list1: [1, 2, 5, 1, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]
{{ list1 | difference(list2) }}
# => [10]
```

To get the symmetric difference of 2 lists (items exclusive to each list):

```
# list1: [1, 2, 5, 1, 3, 4, 10]
# list2: [1, 2, 3, 4, 5, 11, 99]
{{ list1 | symmetric_difference(list2) }}
# => [10, 11, 99]
```

### Calculating numbers (math)

New in version 1.9.

You can calculate logs, powers, and roots of numbers with Ansible  filters. Jinja2 provides other mathematical functions like abs() and  round().

Get the logarithm (default is e):

```
{{ 8 | log }}
# => 2.0794415416798357
```

Get the base 10 logarithm:

```
{{ 8 | log(10) }}
# => 0.9030899869919435
```

Give me the power of 2! (or 5):

```
{{ 8 | pow(5) }}
# => 32768.0
```

Square root, or the 5th:

```
{{ 8 | root }}
# => 2.8284271247461903

{{ 8 | root(5) }}
# => 1.5157165665103982
```

### Managing network interactions

These filters help you with common network tasks.

Note

These filters have migrated to the [ansible.netcommon](https://galaxy.ansible.com/ansible/netcommon) collection. Follow the installation instructions to install that collection.

#### IP address filters

New in version 1.9.

To test if a string is a valid IP address:

```
{{ myvar | ansible.netcommon.ipaddr }}
```

You can also require a specific IP protocol version:

```
{{ myvar | ansible.netcommon.ipv4 }}
{{ myvar | ansible.netcommon.ipv6 }}
```

IP address filter can also be used to extract specific information from an IP address. For example, to get the IP address itself from a CIDR, you can use:

```
{{ '192.0.2.1/24' | ansible.netcommon.ipaddr('address') }}
# => 192.0.2.1
```

More information about `ipaddr` filter and complete usage guide can be found in [ipaddr filter](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters_ipaddr.html#playbooks-filters-ipaddr).

#### Network CLI filters

New in version 2.4.

To convert the output of a network device CLI command into structured JSON output, use the `parse_cli` filter:

```
{{ output | ansible.netcommon.parse_cli('path/to/spec') }}
```

The `parse_cli` filter will load the spec file and pass the command output through it, returning JSON output. The YAML spec file defines how to parse the CLI output.

The spec file should be valid formatted YAML.  It defines how to parse the CLI output and return JSON data.  Below is an example of a valid spec file that will parse the output from the `show vlan` command.

```
---
vars:
  vlan:
    vlan_id: "{{ item.vlan_id }}"
    name: "{{ item.name }}"
    enabled: "{{ item.state != 'act/lshut' }}"
    state: "{{ item.state }}"

keys:
  vlans:
    value: "{{ vlan }}"
    items: "^(?P<vlan_id>\\d+)\\s+(?P<name>\\w+)\\s+(?P<state>active|act/lshut|suspended)"
  state_static:
    value: present
```

The spec file above will return a JSON data structure that is a list of hashes with the parsed VLAN information.

The same command could be parsed into a hash by using the key and values directives.  Here is an example of how to parse the output into a hash value using the same `show vlan` command.

```
---
vars:
  vlan:
    key: "{{ item.vlan_id }}"
    values:
      vlan_id: "{{ item.vlan_id }}"
      name: "{{ item.name }}"
      enabled: "{{ item.state != 'act/lshut' }}"
      state: "{{ item.state }}"

keys:
  vlans:
    value: "{{ vlan }}"
    items: "^(?P<vlan_id>\\d+)\\s+(?P<name>\\w+)\\s+(?P<state>active|act/lshut|suspended)"
  state_static:
    value: present
```

Another common use case for parsing CLI commands is to break a large command into blocks that can be parsed.  This can be done using the `start_block` and `end_block` directives to break the command into blocks that can be parsed.

```
---
vars:
  interface:
    name: "{{ item[0].match[0] }}"
    state: "{{ item[1].state }}"
    mode: "{{ item[2].match[0] }}"

keys:
  interfaces:
    value: "{{ interface }}"
    start_block: "^Ethernet.*$"
    end_block: "^$"
    items:
      - "^(?P<name>Ethernet\\d\\/\\d*)"
      - "admin state is (?P<state>.+),"
      - "Port mode is (.+)"
```

The example above will parse the output of `show interface` into a list of hashes.

The network filters also support parsing the output of a CLI command using the TextFSM library.  To parse the CLI output with TextFSM use the following filter:

```
{{ output.stdout[0] | ansible.netcommon.parse_cli_textfsm('path/to/fsm') }}
```

Use of the TextFSM filter requires the TextFSM library to be installed.

#### Network XML filters

New in version 2.5.

To convert the XML output of a network device command into structured JSON output, use the `parse_xml` filter:

```
{{ output | ansible.netcommon.parse_xml('path/to/spec') }}
```

The `parse_xml` filter will load the spec file and pass the command output through formatted as JSON.

The spec file should be valid formatted YAML. It defines how to parse the XML output and return JSON data.

Below is an example of a valid spec file that will parse the output from the `show vlan | display xml` command.

```
---
vars:
  vlan:
    vlan_id: "{{ item.vlan_id }}"
    name: "{{ item.name }}"
    desc: "{{ item.desc }}"
    enabled: "{{ item.state.get('inactive') != 'inactive' }}"
    state: "{% if item.state.get('inactive') == 'inactive'%} inactive {% else %} active {% endif %}"

keys:
  vlans:
    value: "{{ vlan }}"
    top: configuration/vlans/vlan
    items:
      vlan_id: vlan-id
      name: name
      desc: description
      state: ".[@inactive='inactive']"
```

The spec file above will return a JSON data structure that is a list of hashes with the parsed VLAN information.

The same command could be parsed into a hash by using the key and values directives.  Here is an example of how to parse the output into a hash value using the same `show vlan | display xml` command.

```
---
vars:
  vlan:
    key: "{{ item.vlan_id }}"
    values:
        vlan_id: "{{ item.vlan_id }}"
        name: "{{ item.name }}"
        desc: "{{ item.desc }}"
        enabled: "{{ item.state.get('inactive') != 'inactive' }}"
        state: "{% if item.state.get('inactive') == 'inactive'%} inactive {% else %} active {% endif %}"

keys:
  vlans:
    value: "{{ vlan }}"
    top: configuration/vlans/vlan
    items:
      vlan_id: vlan-id
      name: name
      desc: description
      state: ".[@inactive='inactive']"
```

The value of `top` is the XPath relative to the XML root node. In the example XML output given below, the value of `top` is `configuration/vlans/vlan`, which is an XPath expression relative to the root node (<rpc-reply>). `configuration` in the value of `top` is the outer most container node, and `vlan` is the inner-most container node.

```
items` is a dictionary of key-value pairs that map user-defined names to XPath expressions that select elements. The Xpath expression is relative to the value of the XPath value contained in `top`. For example, the `vlan_id` in the spec file is a user defined name and its value `vlan-id` is the relative to the value of XPath in `top
```

Attributes of XML tags can be extracted using XPath expressions. The value of `state` in the spec is an XPath expression used to get the attributes of the `vlan` tag in output XML.:

```
<rpc-reply>
  <configuration>
    <vlans>
      <vlan inactive="inactive">
       <name>vlan-1</name>
       <vlan-id>200</vlan-id>
       <description>This is vlan-1</description>
      </vlan>
    </vlans>
  </configuration>
</rpc-reply>
```

Note

For more information on supported XPath expressions, see [XPath Support](https://docs.python.org/3/library/xml.etree.elementtree.html#xpath-support).

#### Network VLAN filters

New in version 2.8.

Use the `vlan_parser` filter to transform an unsorted list of VLAN integers into a sorted string list of integers according to IOS-like VLAN list rules. This list has the following properties:

- Vlans are listed in ascending order.
- Three or more consecutive VLANs are listed with a dash.
- The first line of the list can be first_line_len characters long.
- Subsequent list lines can be other_line_len characters.

To sort a VLAN list:

```
{{ [3003, 3004, 3005, 100, 1688, 3002, 3999] | ansible.netcommon.vlan_parser }}
```

This example renders the following sorted list:

```
['100,1688,3002-3005,3999']
```

Another example Jinja template:

```
{% set parsed_vlans = vlans | ansible.netcommon.vlan_parser %}
switchport trunk allowed vlan {{ parsed_vlans[0] }}
{% for i in range (1, parsed_vlans | count) %}
switchport trunk allowed vlan add {{ parsed_vlans[i] }}
{% endfor %}
```

This allows for dynamic generation of VLAN lists on a Cisco IOS  tagged interface. You can store an exhaustive raw list of the exact  VLANs required for an interface and then compare that to the parsed IOS  output that would actually be generated for the configuration.

### Hashing and encrypting strings and passwords

New in version 1.9.

To get the sha1 hash of a string:

```
{{ 'test1' | hash('sha1') }}
# => "b444ac06613fc8d63795be9ad0beaf55011936ac"
```

To get the md5 hash of a string:

```
{{ 'test1' | hash('md5') }}
# => "5a105e8b9d40e1329780d62ea2265d8a"
```

Get a string checksum:

```
{{ 'test2' | checksum }}
# => "109f4b3c50d7b0df729d299bc6f8e9ef9066971f"
```

Other hashes (platform dependent):

```
{{ 'test2' | hash('blowfish') }}
```

To get a sha512 password hash (random salt):

```
{{ 'passwordsaresecret' | password_hash('sha512') }}
# => "$6$UIv3676O/ilZzWEE$ktEfFF19NQPF2zyxqxGkAceTnbEgpEKuGBtk6MlU4v2ZorWaVQUMyurgmHCh2Fr4wpmQ/Y.AlXMJkRnIS4RfH/"
```

To get a sha256 password hash with a specific salt:

```
{{ 'secretpassword' | password_hash('sha256', 'mysecretsalt') }}
# => "$5$mysecretsalt$ReKNyDYjkKNqRVwouShhsEqZ3VOE8eoVO4exihOfvG4"
```

An idempotent method to generate unique hashes per system is to use a salt that is consistent between runs:

```
{{ 'secretpassword' | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }}
# => "$6$43927$lQxPKz2M2X.NWO.gK.t7phLwOKQMcSq72XxDZQ0XzYV6DlL1OD72h417aj16OnHTGxNzhftXJQBcjbunLEepM0"
```

Hash types available depend on the control system running Ansible, ‘hash’ depends on [hashlib](https://docs.python.org/3.8/library/hashlib.html), password_hash depends on [passlib](https://passlib.readthedocs.io/en/stable/lib/passlib.hash.html). The [crypt](https://docs.python.org/3.8/library/crypt.html) is used as a fallback if `passlib` is not installed.

New in version 2.7.

Some hash types allow providing a rounds parameter:

```
{{ 'secretpassword' | password_hash('sha256', 'mysecretsalt', rounds=10000) }}
# => "$5$rounds=10000$mysecretsalt$Tkm80llAxD4YHll6AgNIztKn0vzAACsuuEfYeGP7tm7"
```

The filter password_hash produces different results depending on whether you installed passlib or not.

To ensure idempotency, specify rounds to be neither crypt’s nor passlib’s default, which is 5000 for crypt and a variable value (535000 for sha256, 656000 for sha512) for passlib:

```
{{ 'secretpassword' | password_hash('sha256', 'mysecretsalt', rounds=5001) }}
# => "$5$rounds=5001$mysecretsalt$wXcTWWXbfcR8er5IVf7NuquLvnUA6s8/qdtOhAZ.xN."
```

Hash type ‘blowfish’ (BCrypt) provides the facility to specify the version of the BCrypt algorithm.

```
{{ 'secretpassword' | password_hash('blowfish', '1234567890123456789012', ident='2b') }}
# => "$2b$12$123456789012345678901uuJ4qFdej6xnWjOQT.FStqfdoY8dYUPC"
```

Note

The parameter is only available for [blowfish (BCrypt)](https://passlib.readthedocs.io/en/stable/lib/passlib.hash.bcrypt.html#passlib.hash.bcrypt). Other hash types will simply ignore this parameter. Valid values for this parameter are: [‘2’, ‘2a’, ‘2y’, ‘2b’]

New in version 2.12.

You can also use the Ansible [vault](https://docs.ansible.com/ansible/latest/vault_guide/vault.html#vault) filter to encrypt data:

```
# simply encrypt my key in a vault
vars:
  myvaultedkey: "{{ keyrawdata|vault(passphrase) }}"

- name: save templated vaulted data
  template: src=dump_template_data.j2 dest=/some/key/vault.txt
  vars:
    mysalt: '{{ 2**256|random(seed=inventory_hostname) }}'
    template_data: '{{ secretdata|vault(vaultsecret, salt=mysalt) }}'
```

And then decrypt it using the unvault filter:

```
# simply decrypt my key from a vault
vars:
  mykey: "{{ myvaultedkey|unvault(passphrase) }}"

- name: save templated unvaulted data
  template: src=dump_template_data.j2 dest=/some/key/clear.txt
  vars:
    template_data: '{{ secretdata|unvault(vaultsecret) }}'
```

### Manipulating text

Several filters work with text, including URLs, file names, and path names.

#### Adding comments to files

The `comment` filter lets you create comments in a file from text in a template, with a variety of comment styles. By default Ansible uses `#` to start a comment line and adds a blank comment line above and below your comment text. For example the following:

```
{{ "Plain style (default)" | comment }}
```

produces this output:

```
#
# Plain style (default)
#
```

Ansible offers styles for comments in C (`//...`), C block (`/*...*/`), Erlang (`%...`) and XML (`<!--...-->`):

```
{{ "C style" | comment('c') }}
{{ "C block style" | comment('cblock') }}
{{ "Erlang style" | comment('erlang') }}
{{ "XML style" | comment('xml') }}
```

You can define a custom comment character. This filter:

```
{{ "My Special Case" | comment(decoration="! ") }}
```

produces:

```
!
! My Special Case
!
```

You can fully customize the comment style:

```
{{ "Custom style" | comment('plain', prefix='#######\n#', postfix='#\n#######\n   ###\n    #') }}
```

That creates the following output:

```
#######
#
# Custom style
#
#######
   ###
    #
```

The filter can also be applied to any Ansible variable. For example to make the output of the `ansible_managed` variable more readable, we can change the definition in the `ansible.cfg` file to this:

```
[defaults]

ansible_managed = This file is managed by Ansible.%n
  template: {file}
  date: %Y-%m-%d %H:%M:%S
  user: {uid}
  host: {host}
```

and then use the variable with the comment filter:

```
{{ ansible_managed | comment }}
```

which produces this output:

```
#
# This file is managed by Ansible.
#
# template: /home/ansible/env/dev/ansible_managed/roles/role1/templates/test.j2
# date: 2015-09-10 11:02:58
# user: ansible
# host: myhost
#
```

#### URLEncode Variables

The `urlencode` filter quotes data for use in a URL path or query using UTF-8:

```
{{ 'Trollhättan' | urlencode }}
# => 'Trollh%C3%A4ttan'
```

#### Splitting URLs

New in version 2.4.

The `urlsplit` filter extracts the fragment, hostname, netloc, password, path, port,  query, scheme, and username from an URL. With no arguments, returns a  dictionary of all the fields:

```
{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('hostname') }}
# => 'www.acme.com'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('netloc') }}
# => 'user:password@www.acme.com:9000'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('username') }}
# => 'user'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('password') }}
# => 'password'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('path') }}
# => '/dir/index.html'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('port') }}
# => '9000'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('scheme') }}
# => 'http'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('query') }}
# => 'query=term'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit('fragment') }}
# => 'fragment'

{{ "http://user:password@www.acme.com:9000/dir/index.html?query=term#fragment" | urlsplit }}
# =>
#   {
#       "fragment": "fragment",
#       "hostname": "www.acme.com",
#       "netloc": "user:password@www.acme.com:9000",
#       "password": "password",
#       "path": "/dir/index.html",
#       "port": 9000,
#       "query": "query=term",
#       "scheme": "http",
#       "username": "user"
#   }
```

#### [Searching strings with regular expressions](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#id41)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#searching-strings-with-regular-expressions)

To search in a string or extract parts of a string with a regular expression, use the `regex_search` filter:

```
# Extracts the database name from a string
{{ 'server1/database42' | regex_search('database[0-9]+') }}
# => 'database42'

# Example for a case insensitive search in multiline mode
{{ 'foo\nBAR' | regex_search('^bar', multiline=True, ignorecase=True) }}
# => 'BAR'

# Extracts server and database id from a string
{{ 'server1/database42' | regex_search('server([0-9]+)/database([0-9]+)', '\\1', '\\2') }}
# => ['1', '42']

# Extracts dividend and divisor from a division
{{ '21/42' | regex_search('(?P<dividend>[0-9]+)/(?P<divisor>[0-9]+)', '\\g<dividend>', '\\g<divisor>') }}
# => ['21', '42']
```

The `regex_search` filter returns an empty string if it cannot find a match:

```
{{ 'ansible' | regex_search('foobar') }}
# => ''
```

Note

The `regex_search` filter returns `None` when used in a Jinja expression (for example in conjunction with  operators, other filters, and so on). See the two examples below.

```
{{ 'ansible' | regex_search('foobar') == '' }}
# => False
{{ 'ansible' | regex_search('foobar') is none }}
# => True
```

This is due to historic behavior and the custom re-implementation of some of the Jinja internals in Ansible. Enable the `jinja2_native` setting if you want the `regex_search` filter to always return `None` if it cannot find a match. See [Why does the regex_search filter return None instead of an empty string?](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#jinja2-faqs) for details.

To extract all occurrences of regex matches in a string, use the `regex_findall` filter:

```
# Returns a list of all IPv4 addresses in the string
{{ 'Some DNS servers are 8.8.8.8 and 8.8.4.4' | regex_findall('\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b') }}
# => ['8.8.8.8', '8.8.4.4']

# Returns all lines that end with "ar"
{{ 'CAR\ntar\nfoo\nbar\n' | regex_findall('^.ar$', multiline=True, ignorecase=True) }}
# => ['CAR', 'tar', 'bar']
```

To replace text in a string with regex, use the `regex_replace` filter:

```
# Convert "ansible" to "able"
{{ 'ansible' | regex_replace('^a.*i(.*)$', 'a\\1') }}
# => 'able'

# Convert "foobar" to "bar"
{{ 'foobar' | regex_replace('^f.*o(.*)$', '\\1') }}
# => 'bar'

# Convert "localhost:80" to "localhost, 80" using named groups
{{ 'localhost:80' | regex_replace('^(?P<host>.+):(?P<port>\\d+)$', '\\g<host>, \\g<port>') }}
# => 'localhost, 80'

# Convert "localhost:80" to "localhost"
{{ 'localhost:80' | regex_replace(':80') }}
# => 'localhost'

# Comment all lines that end with "ar"
{{ 'CAR\ntar\nfoo\nbar\n' | regex_replace('^(.ar)$', '#\\1', multiline=True, ignorecase=True) }}
# => '#CAR\n#tar\nfoo\n#bar\n'
```

Note

If you want to match the whole string and you are using `*` make sure to always wraparound your regular expression with the start/end anchors. For example `^(.*)$` will always match only one result, while `(.*)` on some Python versions will match the whole string and an empty string at the end, which means it will make two replacements:

```
# add "https://" prefix to each item in a list
GOOD:
{{ hosts | map('regex_replace', '^(.*)$', 'https://\\1') | list }}
{{ hosts | map('regex_replace', '(.+)', 'https://\\1') | list }}
{{ hosts | map('regex_replace', '^', 'https://') | list }}

BAD:
{{ hosts | map('regex_replace', '(.*)', 'https://\\1') | list }}

# append ':80' to each item in a list
GOOD:
{{ hosts | map('regex_replace', '^(.*)$', '\\1:80') | list }}
{{ hosts | map('regex_replace', '(.+)', '\\1:80') | list }}
{{ hosts | map('regex_replace', '$', ':80') | list }}

BAD:
{{ hosts | map('regex_replace', '(.*)', '\\1:80') | list }}
```

Note

Prior to ansible 2.0, if `regex_replace` filter was used with variables inside YAML arguments (as opposed to  simpler ‘key=value’ arguments), then you needed to escape backreferences (for example, `\\1`) with 4 backslashes (`\\\\`) instead of 2 (`\\`).

New in version 2.0.

To escape special characters within a standard Python regex, use the `regex_escape` filter (using the default `re_type='python'` option):

```
# convert '^f.*o(.*)$' to '\^f\.\*o\(\.\*\)\$'
{{ '^f.*o(.*)$' | regex_escape() }}
```

New in version 2.8.

To escape special characters within a POSIX basic regex, use the `regex_escape` filter with the `re_type='posix_basic'` option:

```
# convert '^f.*o(.*)$' to '\^f\.\*o(\.\*)\$'
{{ '^f.*o(.*)$' | regex_escape('posix_basic') }}
```

#### Managing file names and path names

To get the last name of a file path, like ‘foo.txt’ out of ‘/etc/asdf/foo.txt’:

```
{{ path | basename }}
```

To get the last name of a windows style file path (new in version 2.0):

```
{{ path | win_basename }}
```

To separate the windows drive letter from the rest of a file path (new in version 2.0):

```
{{ path | win_splitdrive }}
```

To get only the windows drive letter:

```
{{ path | win_splitdrive | first }}
```

To get the rest of the path without the drive letter:

```
{{ path | win_splitdrive | last }}
```

To get the directory from a path:

```
{{ path | dirname }}
```

To get the directory from a windows path (new version 2.0):

```
{{ path | win_dirname }}
```

To expand a path containing a tilde (~) character (new in version 1.5):

```
{{ path | expanduser }}
```

To expand a path containing environment variables:

```
{{ path | expandvars }}
```

Note

expandvars expands local variables; using it on remote paths can lead to errors.

New in version 2.6.

To get the real path of a link (new in version 1.8):

```
{{ path | realpath }}
```

To get the relative path of a link, from a start point (new in version 1.7):

```
{{ path | relpath('/etc') }}
```

To get the root and extension of a path or file name (new in version 2.0):

```
# with path == 'nginx.conf' the return would be ('nginx', '.conf')
{{ path | splitext }}
```

The `splitext` filter always returns a pair of strings. The individual components can be accessed by using the `first` and `last` filters:

```
# with path == 'nginx.conf' the return would be 'nginx'
{{ path | splitext | first }}

# with path == 'nginx.conf' the return would be '.conf'
{{ path | splitext | last }}
```

To join one or more path components:

```
{{ ('/etc', path, 'subdir', file) | path_join }}
```

New in version 2.10.

### Manipulating strings

To add quotes for shell usage:

```
- name: Run a shell command
  ansible.builtin.shell: echo {{ string_value | quote }}
```

To concatenate a list into a string:

```
{{ list | join(" ") }}
```

To split a string into a list:

```
{{ csv_string | split(",") }}
```

New in version 2.11.

To work with Base64 encoded strings:

```
{{ encoded | b64decode }}
{{ decoded | string | b64encode }}
```

As of version 2.6, you can define the type of encoding to use, the default is `utf-8`:

```
{{ encoded | b64decode(encoding='utf-16-le') }}
{{ decoded | string | b64encode(encoding='utf-16-le') }}
```

Note

The `string` filter is only required for Python 2 and ensures that text to encode is a unicode string. Without that filter before b64encode the wrong value  will be encoded.

Note

The return value of b64decode is a string.  If you decrypt a binary  blob using b64decode and then try to use it (for example by using [copy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html#copy-module) to write it to a file) you will mostly likely find that your binary has been corrupted.  If you need to take a base64 encoded binary and write  it to disk, it is best to use the system `base64` command with the [shell module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html#shell-module), piping in the encoded data using the `stdin` parameter. For example: `shell: cmd="base64 --decode > myfile.bin" stdin="{{ encoded }}"`

New in version 2.6.

### Managing UUIDs

To create a namespaced UUIDv5:

```
{{ string | to_uuid(namespace='11111111-2222-3333-4444-555555555555') }}
```

New in version 2.10.

To create a namespaced UUIDv5 using the default Ansible namespace ‘361E6D51-FAEC-444A-9079-341386DA8E2E’:

```
{{ string | to_uuid }}
```

New in version 1.9.

To make use of one attribute from each item in a list of complex variables, use the [`Jinja2 map filter`](https://jinja.palletsprojects.com/en/3.1.x/templates/#jinja-filters.map):

```
# get a comma-separated list of the mount points (for example, "/,/mnt/stuff") on a host
{{ ansible_mounts | map(attribute='mount') | join(',') }}
```

### Handling dates and times

To get a date object from a string use the to_datetime filter:

```
# Get total amount of seconds between two dates. Default date format is %Y-%m-%d %H:%M:%S but you can pass your own format
{{ (("2016-08-14 20:00:12" | to_datetime) - ("2015-12-25" | to_datetime('%Y-%m-%d'))).total_seconds()  }}

# Get remaining seconds after delta has been calculated. NOTE: This does NOT convert years, days, hours, and so on to seconds. For that, use total_seconds()
{{ (("2016-08-14 20:00:12" | to_datetime) - ("2016-08-14 18:00:00" | to_datetime)).seconds  }}
# This expression evaluates to "12" and not "132". Delta is 2 hours, 12 seconds

# get amount of days between two dates. This returns only number of days and discards remaining hours, minutes, and seconds
{{ (("2016-08-14 20:00:12" | to_datetime) - ("2015-12-25" | to_datetime('%Y-%m-%d'))).days  }}
```

Note

For a full list of format codes for working with python date format strings, see the [python datetime documentation](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior).

New in version 2.4.

To format a date using a string (like with the shell date command), use the “strftime” filter:

```
# Display year-month-day
{{ '%Y-%m-%d' | strftime }}
# => "2021-03-19"

# Display hour:min:sec
{{ '%H:%M:%S' | strftime }}
# => "21:51:04"

# Use ansible_date_time.epoch fact
{{ '%Y-%m-%d %H:%M:%S' | strftime(ansible_date_time.epoch) }}
# => "2021-03-19 21:54:09"

# Use arbitrary epoch value
{{ '%Y-%m-%d' | strftime(0) }}          # => 1970-01-01
{{ '%Y-%m-%d' | strftime(1441357287) }} # => 2015-09-04
```

New in version 2.13.

strftime takes an optional utc argument, defaulting to False, meaning times are in the local timezone:

```
{{ '%H:%M:%S' | strftime }}           # time now in local timezone
{{ '%H:%M:%S' | strftime(utc=True) }} # time now in UTC
```

Note

To get all string possibilities, check https://docs.python.org/3/library/time.html#time.strftime

### Getting Kubernetes resource names

Note

These filters have migrated to the [kubernetes.core](https://galaxy.ansible.com/kubernetes/core) collection. Follow the installation instructions to install that collection.

Use the “k8s_config_resource_name” filter to obtain the name of a Kubernetes ConfigMap or Secret, including its hash:

```
{{ configmap_resource_definition | kubernetes.core.k8s_config_resource_name }}
```

This can then be used to reference hashes in Pod specifications:

```
my_secret:
  kind: Secret
  metadata:
    name: my_secret_name

deployment_resource:
  kind: Deployment
  spec:
    template:
      spec:
        containers:
        - envFrom:
            - secretRef:
                name: {{ my_secret | kubernetes.core.k8s_config_resource_name }}
```

New in version 2.8.

## Test

[Tests](https://jinja.palletsprojects.com/en/latest/templates/#tests) in Jinja are a way of evaluating template expressions and returning True or False. Jinja ships with many of these. Jinja中的测试是评估模板表达式并返回True或False的一种方法。金贾船上有很多这样的。

The main difference between tests and filters are that Jinja tests  are used for comparisons, whereas filters are used for data  manipulation, and have different applications in jinja. Tests can also  be used in list processing filters, like `map()` and `select()` to choose items in the list.测试和过滤器之间的主要区别在于，Jinja测试用于比较，而过滤器用于数据操作，在Jinja中有不同的应用。测试也可以用于列表处理过滤器，如map（）和select（）来选择列表中的项目。

Like all templating, tests always execute on the Ansible controller, **not** on the target of a task, as they test local data.与所有模板一样，测试总是在Ansible控制器上执行，而不是在任务的目标上执行，因为它们测试本地数据。

In addition to those Jinja2 tests, Ansible supplies a few more and users can easily create their own.

除了这些Jinja2测试，Ansible还提供了一些测试，用户可以轻松创建自己的测试。

### Test syntax

[Test syntax](https://jinja.palletsprojects.com/en/latest/templates/#tests) varies from [filter syntax](https://jinja.palletsprojects.com/en/latest/templates/#filters) (`variable | filter`). Historically Ansible has registered tests as both jinja tests and jinja filters, allowing for them to be referenced using filter syntax.

As of Ansible 2.5, using a jinja test as a filter will generate a  deprecation warning. As of Ansible 2.9+ using jinja test syntax is  required.

The syntax for using a jinja test is as follows

```
variable is test_name
```

Such as

```
result is failed
```

### Testing strings

To match strings against a substring or a regular expression, use the `match`, `search` or `regex` tests

```
vars:
  url: "https://example.com/users/foo/resources/bar"

tasks:
    - debug:
        msg: "matched pattern 1"
      when: url is match("https://example.com/users/.*/resources")

    - debug:
        msg: "matched pattern 2"
      when: url is search("users/.*/resources/.*")

    - debug:
        msg: "matched pattern 3"
      when: url is search("users")

    - debug:
        msg: "matched pattern 4"
      when: url is regex("example\.com/\w+/foo")
```

`match` succeeds if it finds the pattern at the beginning of the string, while `search` succeeds if it finds the pattern anywhere within string. By default, `regex` works like `search`, but `regex` can be configured to perform other tests as well, by passing the `match_type` keyword argument. In particular, `match_type` determines the `re` method that gets used to perform the search. The full list can be found in the relevant Python documentation [here](https://docs.python.org/3/library/re.html#regular-expression-objects).

All of the string tests also take optional `ignorecase` and `multiline` arguments. These correspond to `re.I` and `re.M` from Python’s `re` library, respectively.

### Vault

New in version 2.10.

You can test whether a variable is an inline single vault encrypted value using the `vault_encrypted` test.

```
vars:
  variable: !vault |
    $ANSIBLE_VAULT;1.2;AES256;dev
    61323931353866666336306139373937316366366138656131323863373866376666353364373761
    3539633234313836346435323766306164626134376564330a373530313635343535343133316133
    36643666306434616266376434363239346433643238336464643566386135356334303736353136
    6565633133366366360a326566323363363936613664616364623437336130623133343530333739
    3039

tasks:
  - debug:
      msg: '{{ (variable is vault_encrypted) | ternary("Vault encrypted", "Not vault encrypted") }}'
```

### Testing truthiness

New in version 2.10.

As of Ansible 2.10, you can now perform Python like truthy and falsy checks.

```
- debug:
    msg: "Truthy"
  when: value is truthy
  vars:
    value: "some string"

- debug:
    msg: "Falsy"
  when: value is falsy
  vars:
    value: ""
```

Additionally, the `truthy` and `falsy` tests accept an optional parameter called `convert_bool` that will attempt to convert boolean indicators to actual booleans.

```
- debug:
    msg: "Truthy"
  when: value is truthy(convert_bool=True)
  vars:
    value: "yes"

- debug:
    msg: "Falsy"
  when: value is falsy(convert_bool=True)
  vars:
    value: "off"
```

### Comparing versions

New in version 1.6.

Note

In 2.5 `version_compare` was renamed to `version`

To compare a version number, such as checking if the `ansible_facts['distribution_version']` version is greater than or equal to ‘12.04’, you can use the `version` test.

The `version` test can also be used to evaluate the `ansible_facts['distribution_version']`

```
{{ ansible_facts['distribution_version'] is version('12.04', '>=') }}
```

If `ansible_facts['distribution_version']` is greater than or equal to 12.04, this test returns True, otherwise False.

The `version` test accepts the following operators

```
<, lt, <=, le, >, gt, >=, ge, ==, =, eq, !=, <>, ne
```

This test also accepts a 3rd parameter, `strict` which defines if strict version parsing as defined by `ansible.module_utils.compat.version.StrictVersion` should be used.  The default is `False` (using `ansible.module_utils.compat.version.LooseVersion`), `True` enables strict version parsing

```
{{ sample_version_var is version('1.0', operator='lt', strict=True) }}
```

As of Ansible 2.11 the `version` test accepts a `version_type` parameter which is mutually exclusive with `strict`, and accepts the following values

```
loose, strict, semver, semantic, pep440
```

- `loose`

  This type corresponds to the Python `distutils.version.LooseVersion` class. All version formats are valid for this type. The rules for  comparison are simple and predictable, but may not always give expected  results.

- `strict`

  This type corresponds to the Python `distutils.version.StrictVersion` class. A version number consists of two or three dot-separated numeric  components, with an optional “pre-release” tag on the end. The  pre-release tag consists of a single letter ‘a’ or ‘b’ followed by a  number.  If the numeric components of two version numbers are equal,  then one with a pre-release tag will always be deemed earlier (lesser)  than one without.

- `semver`/`semantic`

  This type implements the [Semantic Version](https://semver.org) scheme for version comparison.

- `pep440`

  This type implements the Python [PEP-440](https://peps.python.org/pep-0440/) versioning rules for version comparison. Added in version 2.14.

Using `version_type` to compare a semantic version would be achieved like the following

```
{{ sample_semver_var is version('2.0.0-rc.1+build.123', 'lt', version_type='semver') }}
```

In Ansible 2.14, the `pep440` option for `version_type` was added, and the rules of this type are defined in [PEP-440](https://peps.python.org/pep-0440/). The following example showcases how this type can differentiate pre-releases as being less than a general release.

```
{{ '2.14.0rc1' is version('2.14.0', 'lt', version_type='pep440') }}
```

When using `version` in a playbook or role, don’t use `{{ }}` as described in the [FAQ](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#when-should-i-use-also-how-to-interpolate-variables-or-dynamic-variable-names)

```
vars:
    my_version: 1.2.3

tasks:
    - debug:
        msg: "my_version is higher than 1.0.0"
      when: my_version is version('1.0.0', '>')
```

### Set theory tests

New in version 2.1.

Note

In 2.5 `issubset` and `issuperset` were renamed to `subset` and `superset`

To see if a list includes or is included by another list, you can use ‘subset’ and ‘superset’

```
vars:
    a: [1,2,3,4,5]
    b: [2,3]
tasks:
    - debug:
        msg: "A includes B"
      when: a is superset(b)

    - debug:
        msg: "B is included in A"
      when: b is subset(a)
```

### Testing if a list contains a value

New in version 2.8.

Ansible includes a `contains` test which operates similarly, but in reverse of the Jinja2 provided `in` test. The `contains` test is designed to work with the `select`, `reject`, `selectattr`, and `rejectattr` filters

```
vars:
  lacp_groups:
    - master: lacp0
      network: 10.65.100.0/24
      gateway: 10.65.100.1
      dns4:
        - 10.65.100.10
        - 10.65.100.11
      interfaces:
        - em1
        - em2

    - master: lacp1
      network: 10.65.120.0/24
      gateway: 10.65.120.1
      dns4:
        - 10.65.100.10
        - 10.65.100.11
      interfaces:
          - em3
          - em4

tasks:
  - debug:
      msg: "{{ (lacp_groups|selectattr('interfaces', 'contains', 'em1')|first).master }}"
```

### Testing if a list value is True

New in version 2.4.

You can use any and all to check if any or all elements in a list are true or not

```
vars:
  mylist:
      - 1
      - "{{ 3 == 3 }}"
      - True
  myotherlist:
      - False
      - True
tasks:

  - debug:
      msg: "all are true!"
    when: mylist is all

  - debug:
      msg: "at least one is true"
    when: myotherlist is any
```

### Testing paths

Note

In 2.5 the following tests were renamed to remove the `is_` prefix

The following tests can provide information about a path on the controller

```
- debug:
    msg: "path is a directory"
  when: mypath is directory

- debug:
    msg: "path is a file"
  when: mypath is file

- debug:
    msg: "path is a symlink"
  when: mypath is link

- debug:
    msg: "path already exists"
  when: mypath is exists

- debug:
    msg: "path is {{ (mypath is abs)|ternary('absolute','relative')}}"

- debug:
    msg: "path is the same file as path2"
  when: mypath is same_file(path2)

- debug:
    msg: "path is a mount"
  when: mypath is mount

- debug:
    msg: "path is a directory"
  when: mypath is directory
  vars:
     mypath: /my/patth

- debug:
    msg: "path is a file"
  when: "'/my/path' is file"
```

### Testing size formats

The `human_readable` and `human_to_bytes` functions let you test your playbooks to make sure you are using the right size format in your tasks, and that you provide Byte format to computers and human-readable format to people.

#### Human readable

Asserts whether the given string is human readable or not.

For example

```
- name: "Human Readable"
  assert:
    that:
      - '"1.00 Bytes" == 1|human_readable'
      - '"1.00 bits" == 1|human_readable(isbits=True)'
      - '"10.00 KB" == 10240|human_readable'
      - '"97.66 MB" == 102400000|human_readable'
      - '"0.10 GB" == 102400000|human_readable(unit="G")'
      - '"0.10 Gb" == 102400000|human_readable(isbits=True, unit="G")'
```

This would result in

```
{ "changed": false, "msg": "All assertions passed" }
```

#### Human to bytes

Returns the given string in the Bytes format.

For example

```
- name: "Human to Bytes"
  assert:
    that:
      - "{{'0'|human_to_bytes}}        == 0"
      - "{{'0.1'|human_to_bytes}}      == 0"
      - "{{'0.9'|human_to_bytes}}      == 1"
      - "{{'1'|human_to_bytes}}        == 1"
      - "{{'10.00 KB'|human_to_bytes}} == 10240"
      - "{{   '11 MB'|human_to_bytes}} == 11534336"
      - "{{  '1.1 GB'|human_to_bytes}} == 1181116006"
      - "{{'10.00 Kb'|human_to_bytes(isbits=True)}} == 10240"
```

This would result in

```
{ "changed": false, "msg": "All assertions passed" }
```

### Testing task results

The following tasks are illustrative of the tests meant to check the status of tasks

```
tasks:

  - shell: /usr/bin/foo
    register: result
    ignore_errors: True

  - debug:
      msg: "it failed"
    when: result is failed

  # in most cases you'll want a handler, but if you want to do something right now, this is nice
  - debug:
      msg: "it changed"
    when: result is changed

  - debug:
      msg: "it succeeded in Ansible >= 2.1"
    when: result is succeeded

  - debug:
      msg: "it succeeded"
    when: result is success

  - debug:
      msg: "it was skipped"
    when: result is skipped
```

Note

From 2.1, you can also use success, failure, change, and skip so that the grammar matches, for those who need to be strict about it.

### Type Tests

When looking to determine types, it may be tempting to use the `type_debug` filter and compare that to the string name of that type, however, you should instead use type test comparisons, such as:

```
tasks:
  - name: "String interpretation"
    vars:
      a_string: "A string"
      a_dictionary: {"a": "dictionary"}
      a_list: ["a", "list"]
    assert:
      that:
      # Note that a string is classed as also being "iterable", "sequence" and "mapping"
      - a_string is string

      # Note that a dictionary is classed as not being a "string", but is "iterable", "sequence" and "mapping"
      - a_dictionary is not string and a_dictionary is mapping

      # Note that a list is classed as not being a "string" or "mapping" but is "iterable" and "sequence"
      - a_list is not string and a_list is not mapping and a_list is iterable

  - name: "Number interpretation"
    vars:
      a_float: 1.01
      a_float_as_string: "1.01"
      an_integer: 1
      an_integer_as_string: "1"
    assert:
      that:
      # Both a_float and an_integer are "number", but each has their own type as well
      - a_float is number and a_float is float
      - an_integer is number and an_integer is integer

      # Both a_float_as_string and an_integer_as_string are not numbers
      - a_float_as_string is not number and a_float_as_string is string
      - an_integer_as_string is not number and a_float_as_string is string

      # a_float or a_float_as_string when cast to a float and then to a string should match the same value cast only to a string
      - a_float | float | string == a_float | string
      - a_float_as_string | float | string == a_float_as_string | string

      # Likewise an_integer and an_integer_as_string when cast to an integer and then to a string should match the same value cast only to an integer
      - an_integer | int | string == an_integer | string
      - an_integer_as_string | int | string == an_integer_as_string | string

      # However, a_float or a_float_as_string cast as an integer and then a string does not match the same value cast to a string
      - a_float | int | string != a_float | string
      - a_float_as_string | int | string != a_float_as_string | string

      # Again, Likewise an_integer and an_integer_as_string cast as a float and then a string does not match the same value cast to a string
      - an_integer | float | string != an_integer | string
      - an_integer_as_string | float | string != an_integer_as_string | string

  - name: "Native Boolean interpretation"
    loop:
    - yes
    - true
    - True
    - TRUE
    - no
    - No
    - NO
    - false
    - False
    - FALSE
    assert:
      that:
      # Note that while other values may be cast to boolean values, these are the only ones which are natively considered boolean
      # Note also that `yes` is the only case sensitive variant of these values.
      - item is boolean
```

## Lookup

Lookup 插件从外部源（如文件、数据库、键/值存储、API和其他服务）检索数据。与所有模板一样，lookup 在Ansible 控制机器上执行和评估。Ansible 使用标准模板系统使 lookup 插件返回的数据可用。lookups were  mostly used indirectly in `with_<lookup>` constructs for looping. 在 Ansible 2.5 之前，查找主要在＜lookup＞构造中间接用于循环。从Ansible  2.5 开始，lookups are used more explicitly as part of Jinja2 expressions fed into the `loop` keyword. lookup 被更明确地用作输入循环关键字的Jinja2表达式的一部分。

### 在变量中使用 lookup

可以使用 lookup 填充变量。Ansible 每次在 task （或 template ）中执行时都会评估该值。

```yaml
vars:
  motd_value: "{{ lookup('file', '/etc/motd') }}"
tasks:
  - debug:
      msg: "motd value is {{ motd_value }}"
```

You may also find lookup plugins in collections. 您还可以在集合中找到查找插件。您可以使用命令 `ansible-doc -l -t lookup` 查看安装在控制机器上的 lookup 插件列表。

## Python3 in templates

Ansible uses Jinja2 to take advantage of Python data types and standard functions in templates and variables. You can use these data types and standard functions to perform a rich set of operations on your data. However, if you use templates, you must be aware of differences between Python versions.

These topics help you design templates that work on both Python2 and  Python3. They might also help if you are upgrading from Python2 to  Python3. Upgrading within Python2 or Python3 does not usually introduce  changes that affect Jinja2 templates.

### Dictionary views

In Python2, the [`dict.keys()`](https://docs.python.org/3/library/stdtypes.html#dict.keys), [`dict.values()`](https://docs.python.org/3/library/stdtypes.html#dict.values), and [`dict.items()`](https://docs.python.org/3/library/stdtypes.html#dict.items) methods return a list.  Jinja2 returns that to Ansible using a string representation that Ansible can turn back into a list.

In Python3, those methods return a [dictionary view](https://docs.python.org/3/library/stdtypes.html#dict-views) object. The string representation that Jinja2 returns for dictionary views cannot be parsed back into a list by Ansible.  It is, however, easy to make this portable by using the [`list`](https://jinja.palletsprojects.com/en/3.1.x/templates/#jinja-filters.list) filter whenever using [`dict.keys()`](https://docs.python.org/3/library/stdtypes.html#dict.keys), [`dict.values()`](https://docs.python.org/3/library/stdtypes.html#dict.values), or [`dict.items()`](https://docs.python.org/3/library/stdtypes.html#dict.items).

```
vars:
  hosts:
    testhost1: 127.0.0.2
    testhost2: 127.0.0.3
tasks:
  - debug:
      msg: '{{ item }}'
    # Only works with Python 2
    #loop: "{{ hosts.keys() }}"
    # Works with both Python 2 and Python 3
    loop: "{{ hosts.keys() | list }}"
```

### dict.iteritems()

Python2 dictionaries have [`iterkeys()`](https://docs.python.org/2/library/stdtypes.html#dict.iterkeys), [`itervalues()`](https://docs.python.org/2/library/stdtypes.html#dict.itervalues), and [`iteritems()`](https://docs.python.org/2/library/stdtypes.html#dict.iteritems) methods.

Python3 dictionaries do not have these methods. Use [`dict.keys()`](https://docs.python.org/3/library/stdtypes.html#dict.keys), [`dict.values()`](https://docs.python.org/3/library/stdtypes.html#dict.values), and [`dict.items()`](https://docs.python.org/3/library/stdtypes.html#dict.items) to make your playbooks and templates compatible with both Python2 and Python3.

```
vars:
  hosts:
    testhost1: 127.0.0.2
    testhost2: 127.0.0.3
tasks:
  - debug:
      msg: '{{ item }}'
    # Only works with Python 2
    #loop: "{{ hosts.iteritems() }}"
    # Works with both Python 2 and Python 3
    loop: "{{ hosts.items() | list }}"
```

## now 函数：获取当前时间

2.8 版本新增。

`now()` Jinja2 function retrieves a Python datetime object or a string representation for the current time.

now（）Jinja2函数检索当前时间的Python datetime对象或字符串表示。

`now()` 函数支持2个参数：

- utc

  指定 `True` 以获取 UTC 的当前时间。默认为 `False` 。

- fmt

  Accepts a [strftime](https://docs.python.org/3/library/datetime.html#strftime-strptime-behavior) string that returns a formatted date time string.
  
  接受返回格式化日期时间字符串的字符串。

## Loop

Ansible offers the `loop`, `with_<lookup>`, and `until` keywords to execute a task multiple times. Examples of commonly-used  loops include changing ownership on several files and/or directories  with the [file module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html#file-module), creating multiple users with the [user module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html#user-module), and repeating a polling step until a certain result is reached.

Note

- We added `loop` in Ansible 2.5. It is not yet a full replacement for `with_<lookup>`, but we recommend it for most use cases.
- We have not deprecated the use of `with_<lookup>` - that syntax will still be valid for the foreseeable future.
- We are looking to improve `loop` syntax - watch this page and the [changelog](https://github.com/ansible/ansible/tree/devel/changelogs) for updates.



Ansible提供了循环，使用＜lookup＞和until关键字多次执行任务。常用循环的示例包括使用文件模块更改多个文件和/或目录的所有权，使用用户模块创建多个用户，以及重复轮询步骤直到达到某个结果。

笔记

我们在Ansible 2.5中添加了循环。它还不是的完全替代品，但我们建议在大多数用例中使用它。

我们没有反对使用＜lookup＞-在可预见的将来，该语法仍然有效。

我们正在寻求改进循环语法-查看此页面和更改日志以获取更新。

### Comparing `loop` and `with_*`

- The `with_<lookup>` keywords rely on [Lookup plugins](https://docs.ansible.com/ansible/latest/plugins/lookup.html#lookup-plugins) - even  `items` is a lookup.
- The `loop` keyword is equivalent to `with_list`, and is the best choice for simple loops.
- The `loop` keyword will not accept a string as input, see [Ensuring list input for loop: using query rather than lookup](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#query-vs-lookup).
- Generally speaking, any use of `with_*` covered in [Migrating from with_X to loop](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#migrating-to-loop) can be updated to use `loop`.
- Be careful when changing `with_items` to `loop`, as `with_items` performed implicit single-level flattening. You may need to use `flatten(1)` with `loop` to match the exact outcome. For example, to get the same output as:

```
with_items:
  - 1
  - [2,3]
  - 4
```

you would need

```
loop: "{{ [1, [2, 3], 4] | flatten(1) }}"
```

- Any `with_*` statement that requires using `lookup` within a loop should not be converted to use the `loop` keyword. For example, instead of doing:

```
loop: "{{ lookup('fileglob', '*.txt', wantlist=True) }}"
```

it’s cleaner to keep

```
with_fileglob: '*.txt'
```

### Standard loops

#### Iterating over a simple list

Repeated tasks can be written as standard loops over a simple list of strings. You can define the list directly in the task.

```
- name: Add several users
  ansible.builtin.user:
    name: "{{ item }}"
    state: present
    groups: "wheel"
  loop:
     - testuser1
     - testuser2
```

You can define the list in a variables file, or in the ‘vars’ section of your play, then refer to the name of the list in the task.

```
loop: "{{ somelist }}"
```

Either of these examples would be the equivalent of

```
- name: Add user testuser1
  ansible.builtin.user:
    name: "testuser1"
    state: present
    groups: "wheel"

- name: Add user testuser2
  ansible.builtin.user:
    name: "testuser2"
    state: present
    groups: "wheel"
```

You can pass a list directly to a parameter for some plugins. Most of the packaging modules, like [yum](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_module.html#yum-module) and [apt](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html#apt-module), have this capability. When available, passing the list to a parameter is better than looping over the task. For example

```
- name: Optimal yum
  ansible.builtin.yum:
    name: "{{ list_of_packages }}"
    state: present

- name: Non-optimal yum, slower and may cause issues with interdependencies
  ansible.builtin.yum:
    name: "{{ item }}"
    state: present
  loop: "{{ list_of_packages }}"
```

Check the [module documentation](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html#modules-by-category) to see if you can pass a list to any particular module’s parameter(s).

#### Iterating over a list of hashes

If you have a list of hashes, you can reference subkeys in a loop. For example:

```
- name: Add several users
  ansible.builtin.user:
    name: "{{ item.name }}"
    state: present
    groups: "{{ item.groups }}"
  loop:
    - { name: 'testuser1', groups: 'wheel' }
    - { name: 'testuser2', groups: 'root' }
```

When combining [conditionals](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#playbooks-conditionals) with a loop, the `when:` statement is processed separately for each item. See [Basic conditionals with when](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#the-when-statement) for examples.

#### Iterating over a dictionary

To loop over a dict, use the  [dict2items](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#dict-filter):

```
- name: Using dict2items
  ansible.builtin.debug:
    msg: "{{ item.key }} - {{ item.value }}"
  loop: "{{ tag_data | dict2items }}"
  vars:
    tag_data:
      Environment: dev
      Application: payment
```

Here, we are iterating over tag_data and printing the key and the value from it.

### Registering variables with a loop

You can register the output of a loop as a variable. For example

```
- name: Register loop output as a variable
  ansible.builtin.shell: "echo {{ item }}"
  loop:
    - "one"
    - "two"
  register: echo
```

When you use `register` with a loop, the data structure placed in the variable will contain a `results` attribute that is a list of all responses from the module. This differs from the data structure returned when using `register` without a loop.

```
{
    "changed": true,
    "msg": "All items completed",
    "results": [
        {
            "changed": true,
            "cmd": "echo \"one\" ",
            "delta": "0:00:00.003110",
            "end": "2013-12-19 12:00:05.187153",
            "invocation": {
                "module_args": "echo \"one\"",
                "module_name": "shell"
            },
            "item": "one",
            "rc": 0,
            "start": "2013-12-19 12:00:05.184043",
            "stderr": "",
            "stdout": "one"
        },
        {
            "changed": true,
            "cmd": "echo \"two\" ",
            "delta": "0:00:00.002920",
            "end": "2013-12-19 12:00:05.245502",
            "invocation": {
                "module_args": "echo \"two\"",
                "module_name": "shell"
            },
            "item": "two",
            "rc": 0,
            "start": "2013-12-19 12:00:05.242582",
            "stderr": "",
            "stdout": "two"
        }
    ]
}
```

Subsequent loops over the registered variable to inspect the results may look like

```
- name: Fail if return code is not 0
  ansible.builtin.fail:
    msg: "The command ({{ item.cmd }}) did not have a 0 return code"
  when: item.rc != 0
  loop: "{{ echo.results }}"
```

During iteration, the result of the current item will be placed in the variable.

```
- name: Place the result of the current item in the variable
  ansible.builtin.shell: echo "{{ item }}"
  loop:
    - one
    - two
  register: echo
  changed_when: echo.stdout != "one"
```

### Complex loops

#### Iterating over nested lists

You can use Jinja2 expressions to iterate over complex lists. For example, a loop can combine nested lists.

```
- name: Give users access to multiple databases
  community.mysql.mysql_user:
    name: "{{ item[0] }}"
    priv: "{{ item[1] }}.*:ALL"
    append_privs: true
    password: "foo"
  loop: "{{ ['alice', 'bob'] | product(['clientdb', 'employeedb', 'providerdb']) | list }}"
```



#### Retrying a task until a condition is met

New in version 1.4.

You can use the `until` keyword to retry a task until a certain condition is met. Here’s an example:

```
- name: Retry a task until a certain condition is met
  ansible.builtin.shell: /usr/bin/foo
  register: result
  until: result.stdout.find("all systems go") != -1
  retries: 5
  delay: 10
```

This task runs up to 5 times with a delay of 10 seconds between each  attempt. If the result of any attempt has “all systems go” in its  stdout, the task succeeds. The default value for “retries” is 3 and  “delay” is 5.

To see the results of individual retries, run the play with `-vv`.

When you run a task with `until` and register the result as a variable, the registered variable will  include a key called “attempts”, which records the number of the retries for the task.

Note

You must set the `until` parameter if you want a task to retry. If `until` is not defined, the value for the `retries` parameter is forced to 1.

#### Looping over inventory

To loop over your inventory, or just a subset of it, you can use a regular `loop` with the `ansible_play_batch` or `groups` variables.

```
- name: Show all the hosts in the inventory
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop: "{{ groups['all'] }}"

- name: Show all the hosts in the current play
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop: "{{ ansible_play_batch }}"
```

There is also a specific lookup plugin `inventory_hostnames` that can be used like this

```
- name: Show all the hosts in the inventory
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop: "{{ query('inventory_hostnames', 'all') }}"

- name: Show all the hosts matching the pattern, ie all but the group www
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop: "{{ query('inventory_hostnames', 'all:!www') }}"
```

More information on the patterns can be found in [Patterns: targeting hosts and groups](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html#intro-patterns).

### Ensuring list input for `loop`: using `query` rather than `lookup`

The `loop` keyword requires a list as input, but the `lookup` keyword returns a string of comma-separated values by default. Ansible 2.5 introduced a new Jinja2 function named [query](https://docs.ansible.com/ansible/latest/plugins/lookup.html#query) that always returns a list, offering a simpler interface and more predictable output from lookup plugins when using the `loop` keyword.

You can force `lookup` to return a list to `loop` by using `wantlist=True`, or you can use `query` instead.

The following two examples do the same thing.

```
loop: "{{ query('inventory_hostnames', 'all') }}"

loop: "{{ lookup('inventory_hostnames', 'all', wantlist=True) }}"
```

### Adding controls to loops

New in version 2.1.

The `loop_control` keyword lets you manage your loops in useful ways.

#### Limiting loop output with `label`

New in version 2.2.

When looping over complex data structures, the console output of your task can be enormous. To limit the displayed output, use the `label` directive with `loop_control`.

```
- name: Create servers
  digital_ocean:
    name: "{{ item.name }}"
    state: present
  loop:
    - name: server1
      disks: 3gb
      ram: 15Gb
      network:
        nic01: 100Gb
        nic02: 10Gb
        ...
  loop_control:
    label: "{{ item.name }}"
```

The output of this task will display just the `name` field for each `item` instead of the entire contents of the multi-line `{{ item }}` variable.

Note

This is for making console output more readable, not protecting sensitive data. If there is sensitive data in `loop`, set `no_log: yes` on the task to prevent disclosure.

#### Pausing within a loop

New in version 2.2.

To control the time (in seconds) between the execution of each item in a task loop, use the `pause` directive with `loop_control`.

```
# main.yml
- name: Create servers, pause 3s before creating next
  community.digitalocean.digital_ocean:
    name: "{{ item }}"
    state: present
  loop:
    - server1
    - server2
  loop_control:
    pause: 3
```

#### Tracking progress through a loop with `index_var`

New in version 2.5.

To keep track of where you are in a loop, use the `index_var` directive with `loop_control`. This directive specifies a variable name to contain the current loop index.

```
- name: Count our fruit
  ansible.builtin.debug:
    msg: "{{ item }} with index {{ my_idx }}"
  loop:
    - apple
    - banana
    - pear
  loop_control:
    index_var: my_idx
```

Note

index_var is 0 indexed.

#### Defining inner and outer variable names with `loop_var`

New in version 2.1.

You can nest two looping tasks using `include_tasks`. However, by default Ansible sets the loop variable `item` for each loop. This means the inner, nested loop will overwrite the value of `item` from the outer loop. You can specify the name of the variable for each loop using `loop_var` with `loop_control`.

```
# main.yml
- include_tasks: inner.yml
  loop:
    - 1
    - 2
    - 3
  loop_control:
    loop_var: outer_item

# inner.yml
- name: Print outer and inner items
  ansible.builtin.debug:
    msg: "outer item={{ outer_item }} inner item={{ item }}"
  loop:
    - a
    - b
    - c
```

Note

If Ansible detects that the current loop is using a variable which  has already been defined, it will raise an error to fail the task.

#### Extended loop variables

New in version 2.8.

As of Ansible 2.8 you can get extended loop information using the `extended` option to loop control. This option will expose the following information.

| Variable                 | Description                                                  |
| ------------------------ | ------------------------------------------------------------ |
| `ansible_loop.allitems`  | The list of all items in the loop                            |
| `ansible_loop.index`     | The current iteration of the loop. (1 indexed)               |
| `ansible_loop.index0`    | The current iteration of the loop. (0 indexed)               |
| `ansible_loop.revindex`  | The number of iterations from the end of the loop (1 indexed) |
| `ansible_loop.revindex0` | The number of iterations from the end of the loop (0 indexed) |
| `ansible_loop.first`     | `True` if first iteration                                    |
| `ansible_loop.last`      | `True` if last iteration                                     |
| `ansible_loop.length`    | The number of items in the loop                              |
| `ansible_loop.previtem`  | The item from the previous iteration of the loop. Undefined during the first iteration. |
| `ansible_loop.nextitem`  | The item from the following iteration of the loop. Undefined during the last iteration. |

```
loop_control:
  extended: true
```

Note

When using `loop_control.extended` more memory will be utilized on the control node. This is a result of `ansible_loop.allitems` containing a reference to the full loop data for every loop. When  serializing the results for display in callback plugins within the main  ansible process, these references may be dereferenced causing memory  usage to increase.

New in version 2.14.

To disable the `ansible_loop.allitems` item, to reduce memory consumption, set `loop_control.extended_allitems: no`.

```
loop_control:
  extended: true
  extended_allitems: false
```

#### Accessing the name of your loop_var

New in version 2.8.

As of Ansible 2.8 you can get the name of the value provided to `loop_control.loop_var` using the `ansible_loop_var` variable

For role authors, writing roles that allow loops, instead of dictating the required `loop_var` value, you can gather the value through the following

```
"{{ lookup('vars', ansible_loop_var) }}"
```

### Migrating from with_X to loop

In most cases, loops work best with the `loop` keyword instead of `with_X` style loops. The `loop` syntax is usually best expressed using filters instead of more complex use of `query` or `lookup`.

These examples show how to convert many common `with_` style loops to `loop` and filters.

#### with_list

`with_list` is directly replaced by `loop`.

```
- name: with_list
  ansible.builtin.debug:
    msg: "{{ item }}"
  with_list:
    - one
    - two

- name: with_list -> loop
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop:
    - one
    - two
```

#### with_items

`with_items` is replaced by `loop` and the `flatten` filter.

```
- name: with_items
  ansible.builtin.debug:
    msg: "{{ item }}"
  with_items: "{{ items }}"

- name: with_items -> loop
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop: "{{ items|flatten(levels=1) }}"
```

#### with_indexed_items

`with_indexed_items` is replaced by `loop`, the `flatten` filter and `loop_control.index_var`.

```
- name: with_indexed_items
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }}"
  with_indexed_items: "{{ items }}"

- name: with_indexed_items -> loop
  ansible.builtin.debug:
    msg: "{{ index }} - {{ item }}"
  loop: "{{ items|flatten(levels=1) }}"
  loop_control:
    index_var: index
```

#### with_flattened

`with_flattened` is replaced by `loop` and the `flatten` filter.

```
- name: with_flattened
  ansible.builtin.debug:
    msg: "{{ item }}"
  with_flattened: "{{ items }}"

- name: with_flattened -> loop
  ansible.builtin.debug:
    msg: "{{ item }}"
  loop: "{{ items|flatten }}"
```

#### with_together

`with_together` is replaced by `loop` and the `zip` filter.

```
- name: with_together
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }}"
  with_together:
    - "{{ list_one }}"
    - "{{ list_two }}"

- name: with_together -> loop
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }}"
  loop: "{{ list_one|zip(list_two)|list }}"
```

Another example with complex data

```
- name: with_together -> loop
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }} - {{ item.2 }}"
  loop: "{{ data[0]|zip(*data[1:])|list }}"
  vars:
    data:
      - ['a', 'b', 'c']
      - ['d', 'e', 'f']
      - ['g', 'h', 'i']
```

#### with_dict

`with_dict` can be substituted by `loop` and either the `dictsort` or `dict2items` filters.

```
- name: with_dict
  ansible.builtin.debug:
    msg: "{{ item.key }} - {{ item.value }}"
  with_dict: "{{ dictionary }}"

- name: with_dict -> loop (option 1)
  ansible.builtin.debug:
    msg: "{{ item.key }} - {{ item.value }}"
  loop: "{{ dictionary|dict2items }}"

- name: with_dict -> loop (option 2)
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }}"
  loop: "{{ dictionary|dictsort }}"
```

#### with_sequence

`with_sequence` is replaced by `loop` and the `range` function, and potentially the `format` filter.

```
- name: with_sequence
  ansible.builtin.debug:
    msg: "{{ item }}"
  with_sequence: start=0 end=4 stride=2 format=testuser%02x

- name: with_sequence -> loop
  ansible.builtin.debug:
    msg: "{{ 'testuser%02x' | format(item) }}"
  loop: "{{ range(0, 4 + 1, 2)|list }}"
```

The range of the loop is exclusive of the end point.

#### with_subelements

`with_subelements` is replaced by `loop` and the `subelements` filter.

```
- name: with_subelements
  ansible.builtin.debug:
    msg: "{{ item.0.name }} - {{ item.1 }}"
  with_subelements:
    - "{{ users }}"
    - mysql.hosts

- name: with_subelements -> loop
  ansible.builtin.debug:
    msg: "{{ item.0.name }} - {{ item.1 }}"
  loop: "{{ users|subelements('mysql.hosts') }}"
```

#### with_nested/with_cartesian

`with_nested` and `with_cartesian` are replaced by loop and the `product` filter.

```
- name: with_nested
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }}"
  with_nested:
    - "{{ list_one }}"
    - "{{ list_two }}"

- name: with_nested -> loop
  ansible.builtin.debug:
    msg: "{{ item.0 }} - {{ item.1 }}"
  loop: "{{ list_one|product(list_two)|list }}"
```

#### with_random_choice

`with_random_choice` is replaced by just use of the `random` filter, without need of `loop`.

```
- name: with_random_choice
  ansible.builtin.debug:
    msg: "{{ item }}"
  with_random_choice: "{{ my_list }}"

- name: with_random_choice -> loop (No loop is needed here)
  ansible.builtin.debug:
    msg: "{{ my_list|random }}"
  tags: random
```

## Controlling where tasks run: delegation and local actions

By default Ansible gathers facts and executes all tasks on the machines that match the `hosts` line of your playbook. This page shows you how to delegate tasks to a  different machine or group, delegate facts to specific machines or  groups, or run an entire playbook locally. Using these approaches, you  can manage inter-related environments precisely and efficiently. For  example, when updating your webservers, you might need to remove them  from a load-balanced pool temporarily. You cannot perform this task on  the webservers themselves. By delegating the task to localhost, you keep all the tasks within the same play.

- [Tasks that cannot be delegated](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#tasks-that-cannot-be-delegated)
- [Delegating tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#delegating-tasks)
- [Delegation and parallel execution](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#delegation-and-parallel-execution)
- [Delegating facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#delegating-facts)
- [Local playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#local-playbooks)

### Tasks that cannot be delegated

Some tasks always execute on the controller. These tasks, including `include`, `add_host`, and `debug`, cannot be delegated.

### Delegating tasks

If you want to perform a task on one host with reference to other hosts, use the `delegate_to` keyword on a task. This is ideal for managing nodes in a load balanced  pool or for controlling outage windows. You can use delegation with the [serial](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#rolling-update-batch-size) keyword to control the number of hosts executing at one time:

```
---
- hosts: webservers
  serial: 5

  tasks:
    - name: Take out of load balancer pool
      ansible.builtin.command: /usr/bin/take_out_of_pool {{ inventory_hostname }}
      delegate_to: 127.0.0.1

    - name: Actual steps would go here
      ansible.builtin.yum:
        name: acme-web-stack
        state: latest

    - name: Add back to load balancer pool
      ansible.builtin.command: /usr/bin/add_back_to_pool {{ inventory_hostname }}
      delegate_to: 127.0.0.1
```

The first and third tasks in this play run on 127.0.0.1, which is the machine running Ansible. There is also a shorthand syntax that you can  use on a per-task basis: `local_action`. Here is the same playbook as above, but using the shorthand syntax for delegating to 127.0.0.1:

```
---
# ...

  tasks:
    - name: Take out of load balancer pool
      local_action: ansible.builtin.command /usr/bin/take_out_of_pool {{ inventory_hostname }}

# ...

    - name: Add back to load balancer pool
      local_action: ansible.builtin.command /usr/bin/add_back_to_pool {{ inventory_hostname }}
```

You can use a local action to call ‘rsync’ to recursively copy files to the managed servers:

```
---
# ...

  tasks:
    - name: Recursively copy files from management server to target
      local_action: ansible.builtin.command rsync -a /path/to/files {{ inventory_hostname }}:/path/to/target/
```

Note that you must have passphrase-less SSH keys or an ssh-agent  configured for this to work, otherwise rsync asks for a passphrase.

To specify more arguments, use the following syntax:

```
---
# ...

  tasks:
    - name: Send summary mail
      local_action:
        module: community.general.mail
        subject: "Summary Mail"
        to: "{{ mail_recipient }}"
        body: "{{ mail_body }}"
      run_once: True
```

Note

- The ansible_host variable and other connection  variables, if present, reflects information about the host a task is  delegated to, not the inventory_hostname.

Warning

Although you can `delegate_to` a host that does not exist in inventory (by adding IP address, DNS name or whatever requirement the connection plugin has), doing so does not  add the host to your inventory and might cause issues. Hosts delegated  to in this way do not inherit variables from the “all” group’, so  variables like connection user and key are missing. If you must `delegate_to` a non-inventory host, use the [add host module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/add_host_module.html#add-host-module).

### Delegation and parallel execution

By default Ansible tasks are executed in parallel. Delegating a task  does not change this and does not handle concurrency issues (multiple  forks writing to the same file). Most commonly, users are affected by this when updating a single file on a single delegated to host for all hosts (using the `copy`, `template`, or `lineinfile` modules, for example). They will still operate in parallel forks (default 5) and overwrite each other.

This can be handled in several ways:

```
- name: "handle concurrency with a loop on the hosts with `run_once: true`"
  lineinfile: "<options here>"
  run_once: true
  loop: '{{ ansible_play_hosts_all }}'
```

By using an intermediate play with  serial: 1 or using  throttle: 1 at task level, for more detail see [Controlling playbook execution: strategies and more](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#playbooks-strategies)

### Delegating facts

Delegating Ansible tasks is like delegating tasks in the real world - your groceries belong to you, even if someone else delivers them to  your home. Similarly, any facts gathered by a delegated task are  assigned by default to the inventory_hostname (the current  host), not to the host which produced the facts (the delegated to host). To assign gathered facts to the delegated host instead of the current  host, set `delegate_facts` to `true`:

```
---
- hosts: app_servers

  tasks:
    - name: Gather facts from db servers
      ansible.builtin.setup:
      delegate_to: "{{ item }}"
      delegate_facts: true
      loop: "{{ groups['dbservers'] }}"
```

This task gathers facts for the machines in the dbservers group and  assigns the facts to those machines, even though the play targets the  app_servers group. This way you can lookup hostvars[‘dbhost1’][‘ansible_default_ipv4’][‘address’] even though dbservers were not part of the play, or left out by using –limit.

### Local playbooks

It may be useful to use a playbook locally on a remote host, rather  than by connecting over SSH.  This can be useful for assuring the  configuration of a system by putting a playbook in a crontab.  This may  also be used to run a playbook inside an OS installer, such as an Anaconda kickstart.

To run an entire playbook locally, just set the `hosts:` line to `hosts: 127.0.0.1` and then run the playbook like so:

```
ansible-playbook playbook.yml --connection=local
```

Alternatively, a local connection can be used in a single playbook play, even if other plays in the playbook use the default remote connection type:

```
---
- hosts: 127.0.0.1
  connection: local
```

Note

If you set the connection to local and there is no  ansible_python_interpreter set, modules will run under /usr/bin/python  and not under {{ ansible_playbook_python }}. Be sure to set  ansible_python_interpreter: “{{ ansible_playbook_python }}” in host_vars/localhost.yml, for example. You can avoid this issue by using `local_action` or `delegate_to: localhost` instead.

## Conditionals

In a playbook, you may want to execute different tasks, or have  different goals, depending on the value of a fact (data about the remote system), a variable, or the result of a previous task. You may want the value of some variables to depend on the value of other variables. Or  you may want to create additional groups of hosts based on whether the  hosts match other criteria. You can do all of these things with  conditionals.

Ansible uses Jinja2 [tests](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tests.html#playbooks-tests) and [filters](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#playbooks-filters) in conditionals. Ansible supports all the standard tests and filters, and adds some unique ones as well.

Note

There are many options to control execution flow in Ansible. You can find more examples of supported conditionals at https://jinja.palletsprojects.com/en/latest/templates/#comparisons.

条件

在剧本中，您可能希望执行不同的任务，或有不同的目标，这取决于事实（有关远程系统的数据）、变量或前一个任务的结果的值。您可能希望某些变量的值依赖于其他变量的值。或者，您可能希望根据主机是否符合其他条件来创建其他主机组。你可以用条件句做所有这些事情。

Ansible在条件语句中使用Jinja2测试和过滤器。Ansible支持所有标准测试和过滤器，并添加了一些独特的测试和过滤器。

- [Basic conditionals with `when`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#basic-conditionals-with-when)
  - [Conditionals based on ansible_facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-based-on-ansible-facts)
  - [Conditions based on registered variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditions-based-on-registered-variables)
  - [Conditionals based on variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-based-on-variables)
  - [Using conditionals in loops](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#using-conditionals-in-loops)
  - [Loading custom facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#loading-custom-facts)
  - [Conditionals with re-use](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-with-re-use)
    - [Conditionals with imports](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-with-imports)
    - [Conditionals with includes](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-with-includes)
    - [Conditionals with roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-with-roles)
  - [Selecting variables, files, or templates based on facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#selecting-variables-files-or-templates-based-on-facts)
    - [Selecting variables files based on facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#selecting-variables-files-based-on-facts)
    - [Selecting files and templates based on facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#selecting-files-and-templates-based-on-facts)
- [Commonly-used facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#commonly-used-facts)
  - [ansible_facts[‘distribution’\]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#ansible-facts-distribution)
  - [ansible_facts[‘distribution_major_version’\]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#ansible-facts-distribution-major-version)
  - [ansible_facts[‘os_family’\]](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#ansible-facts-os-family)

### Basic conditionals with `when`

The simplest conditional statement applies to a single task. Create the task, then add a `when` statement that applies a test. The `when` clause is a raw Jinja2 expression without double curly braces (see [group_by_module](https://docs.ansible.com/ansible/7/collections/ansible/builtin/group_by_module.html#group-by-module)). When you run the task or playbook, Ansible evaluates the test for all  hosts. On any host where the test passes (returns a value of True),  Ansible runs that task. For example, if you are installing mysql on  multiple machines, some of which have SELinux enabled, you might have a  task to configure SELinux to allow mysql to run. You would only want  that task to run on machines that have SELinux enabled:

```
tasks:
  - name: Configure SELinux to start mysql on any port
    ansible.posix.seboolean:
      name: mysql_connect_any
      state: true
      persistent: true
    when: ansible_selinux.status == "enabled"
    # all variables can be used directly in conditionals without double curly braces
```

#### Conditionals based on ansible_facts

Often you want to execute or skip a task based on facts. Facts are  attributes of individual hosts, including IP address, operating system,  the status of a filesystem, and many more. With conditionals based on  facts:

> - You can install a certain package only when the operating system is a particular version.
> - You can skip configuring a firewall on hosts with internal IP addresses.
> - You can perform cleanup tasks only when a filesystem is getting full.

See [Commonly-used facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#commonly-used-facts) for a list of facts that frequently appear in conditional statements.  Not all facts exist for all hosts. For example, the ‘lsb_major_release’  fact used in an example below only exists when the lsb_release package  is installed on the target host. To see what facts are available on your systems, add a debug task to your playbook:

```
- name: Show facts available on the system
  ansible.builtin.debug:
    var: ansible_facts
```

Here is a sample conditional based on a fact:

```
tasks:
  - name: Shut down Debian flavored systems
    ansible.builtin.command: /sbin/shutdown -t now
    when: ansible_facts['os_family'] == "Debian"
```

If you have multiple conditions, you can group them with parentheses:

```
tasks:
  - name: Shut down CentOS 6 and Debian 7 systems
    ansible.builtin.command: /sbin/shutdown -t now
    when: (ansible_facts['distribution'] == "CentOS" and ansible_facts['distribution_major_version'] == "6") or
          (ansible_facts['distribution'] == "Debian" and ansible_facts['distribution_major_version'] == "7")
```

You can use [logical operators](https://jinja.palletsprojects.com/en/latest/templates/#logic) to combine conditions. When you have multiple conditions that all need to be true (that is, a logical `and`), you can specify them as a list:

```
tasks:
  - name: Shut down CentOS 6 systems
    ansible.builtin.command: /sbin/shutdown -t now
    when:
      - ansible_facts['distribution'] == "CentOS"
      - ansible_facts['distribution_major_version'] == "6"
```

If a fact or variable is a string, and you need to run a mathematical comparison on it, use a filter to ensure that Ansible reads the value  as an integer:

```
tasks:
  - ansible.builtin.shell: echo "only on Red Hat 6, derivatives, and later"
    when: ansible_facts['os_family'] == "RedHat" and ansible_facts['lsb']['major_release'] | int >= 6
```

#### Conditions based on registered variables

Often in a playbook you want to execute or skip a task based on the  outcome of an earlier task. For example, you might want to configure a  service after it is upgraded by an earlier task. To create a conditional based on a registered variable:

> 1. Register the outcome of the earlier task as a variable.
> 2. Create a conditional test based on the registered variable.

You create the name of the registered variable using the `register` keyword. A registered variable always contains the status of the task  that created it as well as any output that task generated. You can use  registered variables in templates and action lines as well as in  conditional `when` statements. You can access the string contents of the registered variable using `variable.stdout`. For example:

```
- name: Test play
  hosts: all

  tasks:

      - name: Register a variable
        ansible.builtin.shell: cat /etc/motd
        register: motd_contents

      - name: Use the variable in conditional statement
        ansible.builtin.shell: echo "motd contains the word hi"
        when: motd_contents.stdout.find('hi') != -1
```

You can use registered results in the loop of a task if the variable  is a list. If the variable is not a list, you can convert it into a  list, with either `stdout_lines` or with `variable.stdout.split()`. You can also split the lines by other fields:

```
- name: Registered variable usage as a loop list
  hosts: all
  tasks:

    - name: Retrieve the list of home directories
      ansible.builtin.command: ls /home
      register: home_dirs

    - name: Add home dirs to the backup spooler
      ansible.builtin.file:
        path: /mnt/bkspool/{{ item }}
        src: /home/{{ item }}
        state: link
      loop: "{{ home_dirs.stdout_lines }}"
      # same as loop: "{{ home_dirs.stdout.split() }}"
```

The string content of a registered variable can be empty. If you want to run another task only on hosts where the stdout of your registered  variable is empty, check the registered variable’s string contents for  emptiness:

```
- name: check registered variable for emptiness
  hosts: all

  tasks:

      - name: List contents of directory
        ansible.builtin.command: ls mydir
        register: contents

      - name: Check contents for emptiness
        ansible.builtin.debug:
          msg: "Directory is empty"
        when: contents.stdout == ""
```

Ansible always registers something in a registered variable for every host, even on hosts where a task fails or Ansible skips a task because a condition is not met. To run a follow-up task on these hosts, query the registered variable for `is skipped` (not for “undefined” or “default”). See [Registering variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#registered-variables) for more information. Here are sample conditionals based on the success or failure of a task. Remember to ignore errors if you want Ansible to  continue executing on a host when a failure occurs:

```
tasks:
  - name: Register a variable, ignore errors and continue
    ansible.builtin.command: /bin/false
    register: result
    ignore_errors: true

  - name: Run only if the task that registered the "result" variable fails
    ansible.builtin.command: /bin/something
    when: result is failed

  - name: Run only if the task that registered the "result" variable succeeds
    ansible.builtin.command: /bin/something_else
    when: result is succeeded

  - name: Run only if the task that registered the "result" variable is skipped
    ansible.builtin.command: /bin/still/something_else
    when: result is skipped
```

Note

Older versions of Ansible used `success` and `fail`, but `succeeded` and `failed` use the correct tense. All of these options are now valid.

#### Conditionals based on variables

You can also create conditionals based on variables defined in the  playbooks or inventory. Because conditionals require boolean input (a  test must evaluate as True to trigger the condition), you must apply the `| bool` filter to non boolean variables, such as string variables with content  like ‘yes’, ‘on’, ‘1’, or ‘true’. You can define variables like this:

```
vars:
  epic: true
  monumental: "yes"
```

With the variables above, Ansible would run one of these tasks and skip the other:

```
tasks:
    - name: Run the command if "epic" or "monumental" is true
      ansible.builtin.shell: echo "This certainly is epic!"
      when: epic or monumental | bool

    - name: Run the command if "epic" is false
      ansible.builtin.shell: echo "This certainly isn't epic!"
      when: not epic
```

If a required variable has not been set, you can skip or fail using Jinja2’s defined test. For example:

```
tasks:
    - name: Run the command if "foo" is defined
      ansible.builtin.shell: echo "I've got '{{ foo }}' and am not afraid to use it!"
      when: foo is defined

    - name: Fail if "bar" is undefined
      ansible.builtin.fail: msg="Bailing out. This play requires 'bar'"
      when: bar is undefined
```

This is especially useful in combination with the conditional import of vars files (see below). As the examples show, you do not need to use {{ }} to use variables inside conditionals, as these are already implied.

#### Using conditionals in loops

If you combine a `when` statement with a [loop](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#playbooks-loops), Ansible processes the condition separately for each item. This is by  design, so you can execute the task on some items in the loop and skip  it on other items. For example:

```
tasks:
    - name: Run with items greater than 5
      ansible.builtin.command: echo {{ item }}
      loop: [ 0, 2, 4, 6, 8, 10 ]
      when: item > 5
```

If you need to skip the whole task when the loop variable is undefined, use the |default filter to provide an empty iterator. For example, when looping over a list:

```
- name: Skip the whole task when a loop variable is undefined
  ansible.builtin.command: echo {{ item }}
  loop: "{{ mylist|default([]) }}"
  when: item > 5
```

You can do the same thing when looping over a dict:

```
- name: The same as above using a dict
  ansible.builtin.command: echo {{ item.key }}
  loop: "{{ query('dict', mydict|default({})) }}"
  when: item.value > 5
```

#### Loading custom facts

You can provide your own facts, as described in [Should you develop a module?](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules.html#developing-modules).  To run them, just make a call to your own custom fact gathering module at the top of your list of tasks, and variables returned there will be  accessible to future tasks:

```
tasks:
    - name: Gather site specific fact data
      action: site_facts

    - name: Use a custom fact
      ansible.builtin.command: /usr/bin/thingy
      when: my_custom_fact_just_retrieved_from_the_remote_system == '1234'
```

#### Conditionals with re-use

You can use conditionals with re-usable tasks files, playbooks, or  roles. Ansible executes these conditional statements differently for  dynamic re-use (includes) and for static re-use (imports). See [Re-using Ansible artifacts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#playbooks-reuse) for more information on re-use in Ansible.

##### Conditionals with imports

When you add a conditional to an import statement, Ansible applies  the condition to all tasks within the imported file. This behavior is  the equivalent of [Tag inheritance: adding tags to multiple tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance). Ansible applies the condition to every task, and evaluates each task  separately. For example, if you want to define and then display a  variable that was not previously defined, you might have a playbook  called `main.yml` and a tasks file called `other_tasks.yml`:

```
# all tasks within an imported file inherit the condition from the import statement
# main.yml
- hosts: all
  tasks:
  - import_tasks: other_tasks.yml # note "import"
    when: x is not defined

# other_tasks.yml
- name: Set a variable
  ansible.builtin.set_fact:
    x: foo

- name: Print a variable
  ansible.builtin.debug:
    var: x
```

Ansible expands this at execution time to the equivalent of:

```
- name: Set a variable if not defined
  ansible.builtin.set_fact:
    x: foo
  when: x is not defined
  # this task sets a value for x

- name: Do the task if "x" is not defined
  ansible.builtin.debug:
    var: x
  when: x is not defined
  # Ansible skips this task, because x is now defined
```

If `x` is initially defined, both tasks are skipped as intended. But if `x` is initially undefined, the debug task will be skipped since the  conditional is evaluated for every imported task. The conditional will  evaluate to `true` for the `set_fact` task, which will define the variable and cause the `debug` conditional to evaluate to `false`.

If this is not the behavior you want, use an `include_*` statement to apply a condition only to that statement itself.

```
# using a conditional on include_* only applies to the include task itself
# main.yml
- hosts: all
  tasks:
  - include_tasks: other_tasks.yml # note "include"
    when: x is not defined
```

Now if `x` is initially undefined, the debug task will not be skipped because the  conditional is evaluated at the time of the include and does not apply  to the individual tasks.

You can apply conditions to `import_playbook` as well as to the other `import_*` statements. When you use this approach, Ansible returns a ‘skipped’  message for every task on every host that does not match the criteria,  creating repetitive output. In many cases the [group_by module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_by_module.html#group-by-module) can be a more streamlined way to accomplish the same objective; see [Handling OS and distro differences](https://docs.ansible.com/ansible/latest/tips_tricks/ansible_tips_tricks.html#os-variance).

##### Conditionals with includes

When you use a conditional on an `include_*` statement, the condition is applied only to the include task itself and not to any other tasks within the included file(s). To contrast with  the example used for conditionals on imports above, look at the same  playbook and tasks file, but using an include instead of an import:

```
# Includes let you re-use a file to define a variable when it is not already defined

# main.yml
- include_tasks: other_tasks.yml
  when: x is not defined

# other_tasks.yml
- name: Set a variable
  ansible.builtin.set_fact:
    x: foo

- name: Print a variable
  ansible.builtin.debug:
    var: x
```

Ansible expands this at execution time to the equivalent of:

```
# main.yml
- include_tasks: other_tasks.yml
  when: x is not defined
  # if condition is met, Ansible includes other_tasks.yml

# other_tasks.yml
- name: Set a variable
  ansible.builtin.set_fact:
    x: foo
  # no condition applied to this task, Ansible sets the value of x to foo

- name: Print a variable
  ansible.builtin.debug:
    var: x
  # no condition applied to this task, Ansible prints the debug statement
```

By using `include_tasks` instead of `import_tasks`, both tasks from `other_tasks.yml` will be executed as expected. For more information on the differences between `include` v `import` see [Re-using Ansible artifacts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#playbooks-reuse).

##### Conditionals with roles

There are three ways to apply conditions to roles:

> - Add the same condition or conditions to all tasks in the role by placing your `when` statement under the `roles` keyword. See the example in this section.
> - Add the same condition or conditions to all tasks in the role by placing your `when` statement on a static `import_role` in your playbook.
> - Add a condition or conditions to individual tasks or blocks  within the role itself. This is the only approach that allows you to  select or skip some tasks within the role based on your `when` statement. To select or skip tasks within the role, you must have  conditions set on individual tasks or blocks, use the dynamic `include_role` in your playbook, and add the condition or conditions to the include.  When you use this approach, Ansible applies the condition to the include itself plus any tasks in the role that also have that `when` statement.

When you incorporate a role in your playbook statically with the `roles` keyword, Ansible adds the conditions you define to all the tasks in the role. For example:

```
- hosts: webservers
  roles:
     - role: debian_stock_config
       when: ansible_facts['os_family'] == 'Debian'
```

#### Selecting variables, files, or templates based on facts

Sometimes the facts about a host determine the values you want to use for certain variables or even the file or template you want to select  for that host. For example, the names of packages are different on  CentOS and on Debian. The configuration files for common services are  also different on different OS flavors and versions. To load different  variables file, templates, or other files based on a fact about the  hosts:

> 1. name your vars files, templates, or files to match the Ansible fact that differentiates them
> 2. select the correct vars file, template, or file for each host with a variable based on that Ansible fact

Ansible separates variables from tasks, keeping your playbooks from  turning into arbitrary code with nested conditionals. This approach  results in more streamlined and auditable configuration rules because  there are fewer decision points to track.

##### Selecting variables files based on facts

You can create a playbook that works on multiple platforms and OS  versions with a minimum of syntax by placing your variable values in  vars files and conditionally importing them. If you want to install  Apache on some CentOS and some Debian servers, create variables files  with YAML keys and values. For example:

```
---
# for vars/RedHat.yml
apache: httpd
somethingelse: 42
```

Then import those variables files based on the facts you gather on the hosts in your playbook:

```
---
- hosts: webservers
  remote_user: root
  vars_files:
    - "vars/common.yml"
    - [ "vars/{{ ansible_facts['os_family'] }}.yml", "vars/os_defaults.yml" ]
  tasks:
  - name: Make sure apache is started
    ansible.builtin.service:
      name: '{{ apache }}'
      state: started
```

Ansible gathers facts on the hosts in the webservers group, then  interpolates the variable “ansible_facts[‘os_family’]” into a list of  filenames. If you have hosts with Red Hat operating systems (CentOS, for example), Ansible looks for ‘vars/RedHat.yml’. If that file does not  exist, Ansible attempts to load ‘vars/os_defaults.yml’. For Debian  hosts, Ansible first looks for ‘vars/Debian.yml’, before falling back on ‘vars/os_defaults.yml’. If no files in the list are found, Ansible  raises an error.

##### Selecting files and templates based on facts

You can use the same approach when different OS flavors or versions  require different configuration files or templates. Select the  appropriate file or template based on the variables assigned to each  host. This approach is often much cleaner than putting a lot of  conditionals into a single template to cover multiple OS or package  versions.

For example, you can template out a configuration file that is very different between, say, CentOS and Debian:

```
- name: Template a file
  ansible.builtin.template:
    src: "{{ item }}"
    dest: /etc/myapp/foo.conf
  loop: "{{ query('first_found', { 'files': myfiles, 'paths': mypaths}) }}"
  vars:
    myfiles:
      - "{{ ansible_facts['distribution'] }}.conf"
      -  default.conf
    mypaths: ['search_location_one/somedir/', '/opt/other_location/somedir/']
```

### Commonly-used facts

The following Ansible facts are frequently used in conditionals.

#### ansible_facts[‘distribution’\]

Possible values (sample, not complete list):

```
Alpine
Altlinux
Amazon
Archlinux
ClearLinux
Coreos
CentOS
Debian
Fedora
Gentoo
Mandriva
NA
OpenWrt
OracleLinux
RedHat
Slackware
SLES
SMGL
SUSE
Ubuntu
VMwareESX
```

#### ansible_facts[‘distribution_major_version’\]

The major version of the operating system. For example, the value is 16 for Ubuntu 16.04.

#### ansible_facts[‘os_family’\]

Possible values (sample, not complete list):

```
AIX
Alpine
Altlinux
Archlinux
Darwin
Debian
FreeBSD
Gentoo
HP-UX
Mandrake
RedHat
SGML
Slackware
Solaris
Suse
Windows
```

## Block

Block 创建任务的逻辑组。Block 还提供了处理 task 错误的方法，类似于许多编程语言中的异常处理。

### 使用 Block 对任务分组

All tasks in a block inherit directives applied at the block level. 块中的所有任务都继承在块级别应用的指令。Most of what you can apply to a single task (with the exception of  loops) can be applied at the block level, so blocks make it much easier  to set data or directives common to the tasks. 您可以应用于单个任务的大部分内容（循环除外）都可以应用于块级别，因此块可以更容易地设置任务通用的数据或指令。The directive does not  affect the block itself, it is only inherited by the tasks enclosed by a block.该指令不影响块本身，它只由块所包含的任务继承。a when statement is applied to the tasks within a block, not to the block itself.例如，当语句应用于块内的任务，而不是应用于块本身。

```yaml
 tasks:
   - name: Install, configure, and start Apache
     block:
       - name: Install httpd and memcached
         ansible.builtin.yum:
           name:
           - httpd
           - memcached
           state: present

       - name: Apply the foo config template
         ansible.builtin.template:
           src: templates/src.j2
           dest: /etc/foo.conf

       - name: Start service bar and enable it
         ansible.builtin.service:
           name: bar
           state: started
           enabled: True
     when: ansible_facts['distribution'] == 'CentOS'
     become: true
     become_user: root
     ignore_errors: true
```



在上面的示例中，在 Ansible 运行块中的三个任务之前，将评估 “when” 条件。All three tasks also  inherit the privilege escalation directives, running as the root user.  这三个任务还继承特权升级指令，以root用户身份运行。Finally, `ignore_errors: yes` ensures that Ansible continues to execute the playbook even if some of the tasks fail.最后，忽略错误：true确保Ansible在某些任务失败的情况下继续执行剧本。

自 Ansible 2.3 以来，块的名称已可用。recommend  using names in all tasks, within blocks or elsewhere, for better  visibility into the tasks being executed when you run the playbook.我们建议在块内或其他地方的所有任务中使用名称，以便在运行剧本时更好地了解正在执行的任务。

### 使用 Block 处理错误

You can control how Ansible responds to task errors using blocks with `rescue` and `always` sections.

您可以使用带有救援和始终分段的块来控制Ansible如何响应任务错误。

Rescue blocks specify tasks to run when an earlier task in a block  fails. This approach is similar to exception handling in many  programming languages. Ansible only runs rescue blocks after a task  returns a ‘failed’ state. Bad task definitions and unreachable hosts  will not trigger the rescue block.

救援块指定当块中的早期任务失败时要运行的任务。这种方法类似于许多编程语言中的异常处理。Ansible仅在任务返回“失败”状态后运行救援块。错误的任务定义和无法访问的主机不会触发救援块。

```yaml
 tasks:
 - name: Handle the error
   block:
     - name: Print a message
       ansible.builtin.debug:
         msg: 'I execute normally'

     - name: Force a failure
       ansible.builtin.command: /bin/false

     - name: Never print this
       ansible.builtin.debug:
         msg: 'I never execute, due to the above task failing, :-('
   rescue:
     - name: Print when errors
       ansible.builtin.debug:
         msg: 'I caught an error, can do stuff here to fix it, :-)'
```

You can also add an `always` section to a block. Tasks in the `always` section run no matter what the task status of the previous block is.



Block with always section[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#id3)

```
 - name: Always do X
   block:
     - name: Print a message
       ansible.builtin.debug:
         msg: 'I execute normally'

     - name: Force a failure
       ansible.builtin.command: /bin/false

     - name: Never print this
       ansible.builtin.debug:
         msg: 'I never execute :-('
   always:
     - name: Always do this
       ansible.builtin.debug:
         msg: "This always executes, :-)"
```

Together, these elements offer complex error handling.

Block with all sections[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#id4)

```
- name: Attempt and graceful roll back demo
  block:
    - name: Print a message
      ansible.builtin.debug:
        msg: 'I execute normally'

    - name: Force a failure
      ansible.builtin.command: /bin/false

    - name: Never print this
      ansible.builtin.debug:
        msg: 'I never execute, due to the above task failing, :-('
  rescue:
    - name: Print when errors
      ansible.builtin.debug:
        msg: 'I caught an error'

    - name: Force a failure in middle of recovery! >:-)
      ansible.builtin.command: /bin/false

    - name: Never print this
      ansible.builtin.debug:
        msg: 'I also never execute :-('
  always:
    - name: Always do this
      ansible.builtin.debug:
        msg: "This always executes"
```

The tasks in the `block` execute normally. If any tasks in the block return `failed`, the `rescue` section executes tasks to recover from the error. The `always` section runs regardless of the results of the `block` and `rescue` sections.

If an error occurs in the block and the rescue task succeeds, Ansible reverts the failed status of the original task for the run and  continues to run the play as if the original task had succeeded. The  rescued task is considered successful, and does not trigger `max_fail_percentage` or `any_errors_fatal` configurations. However, Ansible still reports a failure in the playbook statistics.

You can use blocks with `flush_handlers` in a rescue task to ensure that all handlers run even if an error occurs:

Block run handlers in error handling[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#id5)

```
 tasks:
   - name: Attempt and graceful roll back demo
     block:
       - name: Print a message
         ansible.builtin.debug:
           msg: 'I execute normally'
         changed_when: true
         notify: run me even after an error

       - name: Force a failure
         ansible.builtin.command: /bin/false
     rescue:
       - name: Make sure all handlers run
         meta: flush_handlers
 handlers:
    - name: Run me even after an error
      ansible.builtin.debug:
        msg: 'This handler runs even on error'
```

New in version 2.1.

Ansible provides a couple of variables for tasks in the `rescue` portion of a block:

- ansible_failed_task

  The task that returned ‘failed’ and triggered the rescue. For example, to get the name use `ansible_failed_task.name`.

- ansible_failed_result

  The captured return result of the failed task that triggered the rescue. This would equate to having used this var in the `register` keyword.

Note

In `ansible-core` 2.14 or later, both variables are propagated from an inner block to an outer `rescue` portion of a block.

## Handlers: running operations on change

Sometimes you want a task to run only when a change is made on a  machine. For example, you may want to restart a service if a task  updates the configuration of that service, but not if the configuration  is unchanged. Ansible uses handlers to address this use case. Handlers  are tasks that only run when notified.

### Handler example

This playbook, `verify-apache.yml`, contains a single play with a handler.

```
---
- name: Verify apache installation
  hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
    - name: Ensure apache is at the latest version
      ansible.builtin.yum:
        name: httpd
        state: latest

    - name: Write the apache config file
      ansible.builtin.template:
        src: /srv/httpd.j2
        dest: /etc/httpd.conf
      notify:
      - Restart apache

    - name: Ensure apache is running
      ansible.builtin.service:
        name: httpd
        state: started

  handlers:
    - name: Restart apache
      ansible.builtin.service:
        name: httpd
        state: restarted
```

In this example playbook, the Apache server is restarted by the handler after all tasks complete in the play.

### Notifying handlers

Tasks can instruct one or more handlers to execute using the `notify` keyword. The `notify` keyword can be applied to a task and accepts a list of handler names  that  are notified on a task change. Alternately, a string containing a  single handler name can be supplied as well. The following example  demonstrates how multiple handlers can be notified by a single task:

```
tasks:
- name: Template configuration file
  ansible.builtin.template:
    src: template.j2
    dest: /etc/foo.conf
  notify:
    - Restart apache
    - Restart memcached

handlers:
  - name: Restart memcached
    ansible.builtin.service:
      name: memcached
      state: restarted

  - name: Restart apache
    ansible.builtin.service:
      name: apache
      state: restarted
```

In the above example the handlers are executed on task change in the following order: `Restart memcached`, `Restart apache`. Handlers are executed in the order they are defined in the `handlers` section, not in the order listed in the `notify` statement. Notifying the same handler multiple times will result in  executing the handler only once regardless of how many tasks notify it.  For example, if multiple tasks update a configuration file and notify a  handler to restart Apache, Ansible only bounces Apache once to avoid  unnecessary restarts.

### Naming handlers

Handlers must be named in order for tasks to be able to notify them using the `notify` keyword.

Alternately, handlers can utilize the `listen` keyword. Using this handler keyword, handlers can listen on topics that can group multiple handlers as follows:

```
tasks:
  - name: Restart everything
    command: echo "this task will restart the web services"
    notify: "restart web services"

handlers:
  - name: Restart memcached
    service:
      name: memcached
      state: restarted
    listen: "restart web services"

  - name: Restart apache
    service:
      name: apache
      state: restarted
    listen: "restart web services"
```

Notifying the `restart web services` topic results in executing all handlers listening to that topic regardless of how those handlers are named.

This use makes it much easier to trigger multiple handlers. It also  decouples handlers from their names, making it easier to share handlers  among playbooks and roles (especially when using third-party roles from a shared source such as Ansible Galaxy).

Each handler should have a globally unique name. If multiple handlers are defined with the same name, only the last one defined is notified  with `notify`, effectively shadowing all of the previous handlers with the same name.  Alternately handlers sharing the same name can all be notified and  executed if they listen on the same topic by notifying that topic.

There is only one global scope for handlers (handler names and listen topics) regardless of where the handlers are defined. This also  includes handlers defined in roles.

### Controlling when handlers run

By default, handlers run after all the tasks in a particular play  have been completed. Notified handlers are executed automatically after  each of the following sections, in the following order: `pre_tasks`, `roles`/`tasks` and `post_tasks`. This approach is efficient, because the handler only runs once,  regardless of how many tasks notify it. For example, if multiple tasks  update a configuration file and notify a handler to restart Apache,  Ansible only bounces Apache once to avoid unnecessary restarts.

If you need handlers to run before the end of the play, add a task to flush them using the [meta module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/meta_module.html#meta-module), which executes Ansible actions:

```
tasks:
  - name: Some tasks go here
    ansible.builtin.shell: ...

  - name: Flush handlers
    meta: flush_handlers

  - name: Some other tasks
    ansible.builtin.shell: ...
```

The `meta: flush_handlers` task triggers any handlers that have been notified at that point in the play.

Once handlers are executed, either automatically after each mentioned section or manually by the `flush_handlers` meta task, they can be notified and run again in later sections of the play.

### Using variables with handlers

You may want your Ansible handlers to use variables. For example, if  the name of a service varies slightly by distribution, you want your  output to show the exact name of the restarted service for each target  machine. Avoid placing variables in the name of the handler. Since  handler names are templated early on, Ansible may not have a value  available for a handler name like this:

```
handlers:
# This handler name may cause your play to fail!
- name: Restart "{{ web_service_name }}"
```

If the variable used in the handler name is not available, the entire play fails. Changing that variable mid-play **will not** result in newly created handler.

Instead, place variables in the task parameters of your handler. You can load the values using `include_vars` like this:

```
tasks:
  - name: Set host variables based on distribution
    include_vars: "{{ ansible_facts.distribution }}.yml"

handlers:
  - name: Restart web service
    ansible.builtin.service:
      name: "{{ web_service_name | default('httpd') }}"
      state: restarted
```

While handler names can contain a template, `listen` topics cannot.

### Handlers in roles

Handlers from roles are not just contained in their roles but rather  inserted into global scope with all other handlers from a play. As such  they can be used outside of the role they are defined in. It also means  that their name can conflict with handlers from outside the role. To  ensure that a handler from a role is notified as opposed to one from  outside the role with the same name, notify the handler by using its  name in the following form: `role_name : handler_name`.

Handlers notified within the `roles` section are automatically flushed at the end of the `tasks` section, but before any `tasks` handlers.

### Includes and imports in handlers

Notifying a dynamic include such as `include_task` as a handler results in executing all tasks from within the include. It is not possible to notify a handler defined inside a dynamic include.

Having a static include such as `import_task` as a handler results in that handler being effectively rewritten by  handlers from within that import before the play execution. A static  include itself cannot be notified; the tasks from within that include,  on the other hand, can be notified individually.

### Meta tasks as handlers

Since Ansible 2.14 [meta tasks](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/meta_module.html#ansible-collections-ansible-builtin-meta-module) are allowed to be used and notified as handlers. Note that however `flush_handlers` cannot be used as a handler to prevent unexpected behavior.

### Limitations

A handler cannot run `import_role` or `include_role`.

## Error handling in playbooks

When Ansible receives a non-zero return code from a command or a  failure from a module, by default it stops executing on that host and  continues on other hosts. However, in some circumstances you may want  different behavior. Sometimes a non-zero return code indicates success.  Sometimes you want a failure on one host to stop execution on all hosts. Ansible provides tools and settings to handle these situations and help you get the behavior, output, and reporting you want.

### Ignoring failed commands

By default Ansible stops executing tasks on a host when a task fails on that host. You can use `ignore_errors` to continue on in spite of the failure.

```
- name: Do not count this as a failure
  ansible.builtin.command: /bin/false
  ignore_errors: true
```

The `ignore_errors` directive only works when the task is able to run and returns a value  of ‘failed’. It does not make Ansible ignore undefined variable errors,  connection failures, execution issues (for example, missing packages),  or syntax errors.

### Ignoring unreachable host errors

New in version 2.7.

You can ignore a task failure due to the host instance being ‘UNREACHABLE’ with the `ignore_unreachable` keyword. Ansible ignores the task errors, but continues to execute  future tasks against the unreachable host. For example, at the task  level:

```
- name: This executes, fails, and the failure is ignored
  ansible.builtin.command: /bin/true
  ignore_unreachable: true

- name: This executes, fails, and ends the play for this host
  ansible.builtin.command: /bin/true
```

And at the playbook level:

```
- hosts: all
  ignore_unreachable: true
  tasks:
  - name: This executes, fails, and the failure is ignored
    ansible.builtin.command: /bin/true

  - name: This executes, fails, and ends the play for this host
    ansible.builtin.command: /bin/true
    ignore_unreachable: false
```

### Resetting unreachable hosts

If Ansible cannot connect to a host, it marks that host as  ‘UNREACHABLE’ and removes it from the list of active hosts for the run.  You can use meta: clear_host_errors to reactivate all hosts, so subsequent tasks can try to reach them again.

### Handlers and failure

Ansible runs [handlers](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html#handlers) at the end of each play. If a task notifies a handler but another task fails later in the play, by default the handler does *not* run on that host, which may leave the host in an unexpected state. For example, a task could update a configuration file and notify a handler to restart some service. If a task later in the same play fails, the configuration file might be changed but the service will not be restarted.

You can change this behavior with the `--force-handlers` command-line option, by including `force_handlers: True` in a play, or by adding `force_handlers = True` to ansible.cfg. When handlers are forced, Ansible will run all notified handlers on all hosts, even hosts with failed tasks. (Note that certain errors could still prevent the handler from running, such as a host becoming unreachable.)

### Defining failure

Ansible lets you define what “failure” means in each task using the `failed_when` conditional. As with all conditionals in Ansible, lists of multiple `failed_when` conditions are joined with an implicit `and`, meaning the task only fails when *all* conditions are met. If you want to trigger a failure when any of the  conditions is met, you must define the conditions in a string with an  explicit `or` operator.

You may check for failure by searching for a word or phrase in the output of a command

```
- name: Fail task when the command error output prints FAILED
  ansible.builtin.command: /usr/bin/example-command -x -y -z
  register: command_result
  failed_when: "'FAILED' in command_result.stderr"
```

or based on the return code

```
- name: Fail task when both files are identical
  ansible.builtin.raw: diff foo/file1 bar/file2
  register: diff_cmd
  failed_when: diff_cmd.rc == 0 or diff_cmd.rc >= 2
```

You can also combine multiple conditions for failure. This task will fail if both conditions are true:

```
- name: Check if a file exists in temp and fail task if it does
  ansible.builtin.command: ls /tmp/this_should_not_be_here
  register: result
  failed_when:
    - result.rc == 0
    - '"No such" not in result.stdout'
```

If you want the task to fail when only one condition is satisfied, change the `failed_when` definition to

```
failed_when: result.rc == 0 or "No such" not in result.stdout
```

If you have too many conditions to fit neatly into one line, you can split it into a multi-line YAML value with `>`.

```
- name: example of many failed_when conditions with OR
  ansible.builtin.shell: "./myBinary"
  register: ret
  failed_when: >
    ("No such file or directory" in ret.stdout) or
    (ret.stderr != '') or
    (ret.rc == 10)
```

### Defining “changed”

Ansible lets you define when a particular task has “changed” a remote node using the `changed_when` conditional. This lets you determine, based on return codes or output,  whether a change should be reported in Ansible statistics and whether a  handler should be triggered or not. As with all conditionals in Ansible, lists of multiple `changed_when` conditions are joined with an implicit `and`, meaning the task only reports a change when *all* conditions are met. If you want to report a change when any of the  conditions is met, you must define the conditions in a string with an  explicit `or` operator. For example:

```
tasks:

  - name: Report 'changed' when the return code is not equal to 2
    ansible.builtin.shell: /usr/bin/billybass --mode="take me to the river"
    register: bass_result
    changed_when: "bass_result.rc != 2"

  - name: This will never report 'changed' status
    ansible.builtin.shell: wall 'beep'
    changed_when: False
```

You can also combine multiple conditions to override “changed” result.

```
- name: Combine multiple conditions to override 'changed' result
  ansible.builtin.command: /bin/fake_command
  register: result
  ignore_errors: True
  changed_when:
    - '"ERROR" in result.stderr'
    - result.rc == 2
```

Note

Just like `when` these two conditionals do not require templating delimiters (`{{ }}`) as they are implied.

See [Defining failure](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_error_handling.html#controlling-what-defines-failure) for more conditional syntax examples.

### Ensuring success for command and shell

The [command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html#command-module) and [shell](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html#shell-module) modules care about return codes, so if you have a command whose successful exit code is not zero, you can do this:

```
tasks:
  - name: Run this command and ignore the result
    ansible.builtin.shell: /usr/bin/somecommand || /bin/true
```

### Aborting a play on all hosts

Sometimes you want a failure on a single host, or failures on a  certain percentage of hosts, to abort the entire play on all hosts. You  can stop play execution after the first failure happens with `any_errors_fatal`. For finer-grained control, you can use `max_fail_percentage` to abort the run after a given percentage of hosts has failed.

#### Aborting on the first error: any_errors_fatal

If you set `any_errors_fatal` and a task returns an error, Ansible finishes the fatal task on all  hosts in the current batch, then stops executing the play on all hosts.  Subsequent tasks and plays are not executed. You can recover from fatal  errors by adding a [rescue section](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#block-error-handling) to the block. You can set `any_errors_fatal` at the play or block level.

```
- hosts: somehosts
  any_errors_fatal: true
  roles:
    - myrole

- hosts: somehosts
  tasks:
    - block:
        - include_tasks: mytasks.yml
      any_errors_fatal: true
```

You can use this feature when all tasks must be 100% successful to  continue playbook execution. For example, if you run a service on  machines in multiple data centers with load balancers to pass traffic  from users to the service, you want all load balancers to be disabled  before you stop the service for maintenance. To ensure that any failure  in the task that disables the load balancers will stop all other tasks:

```
---
- hosts: load_balancers_dc_a
  any_errors_fatal: true

  tasks:
    - name: Shut down datacenter 'A'
      ansible.builtin.command: /usr/bin/disable-dc

- hosts: frontends_dc_a

  tasks:
    - name: Stop service
      ansible.builtin.command: /usr/bin/stop-software

    - name: Update software
      ansible.builtin.command: /usr/bin/upgrade-software

- hosts: load_balancers_dc_a

  tasks:
    - name: Start datacenter 'A'
      ansible.builtin.command: /usr/bin/enable-dc
```

In this example Ansible starts the software upgrade on the front ends only if all of the load balancers are successfully disabled.

#### Setting a maximum failure percentage

By default, Ansible continues to execute tasks as long as there are  hosts that have not yet failed. In some situations, such as when  executing a rolling update, you may want to abort the play when a  certain threshold of failures has been reached. To achieve this, you can set a maximum failure percentage on a play:

```
---
- hosts: webservers
  max_fail_percentage: 30
  serial: 10
```

The `max_fail_percentage` setting applies to each batch when you use it with [serial](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#rolling-update-batch-size). In the example above, if more than 3 of the 10 servers in the first (or any) batch of servers failed, the rest of the play would be aborted.

Note

The percentage set must be exceeded, not equaled. For example, if  serial were set to 4 and you wanted the task to abort the play when 2 of the systems failed, set the max_fail_percentage at 49 rather than 50.

### Controlling errors in blocks

You can also use blocks to define responses to task errors. This  approach is similar to exception handling in many programming languages. See [Handling errors with blocks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#block-error-handling) for details and examples.

## Setting the remote environment

New in version 1.1.

You can use the `environment` keyword at the play, block, or task level to set an environment  variable for an action on a remote host. With this keyword, you can  enable using a proxy for a task that does http requests, set the  required environment variables for language-specific version managers,  and more.

When you set a value with `environment:` at the play or block level, it is available only to tasks within the play or block that are executed by the same user. The `environment:` keyword does not affect Ansible itself, Ansible configuration settings, the environment for other users, or the execution of other plugins like lookups and filters. Variables set with `environment:` do not automatically become Ansible facts, even when you set them at the play level. You must include an explicit `gather_facts` task in your playbook and set the `environment` keyword on that task to turn these values into Ansible facts.

### Setting the remote environment in a task

You can set the environment directly at the task level.

```
- hosts: all
  remote_user: root

  tasks:

    - name: Install cobbler
      ansible.builtin.package:
        name: cobbler
        state: present
      environment:
        http_proxy: http://proxy.example.com:8080
```

You can re-use environment settings by defining them as variables in  your play and accessing them in a task as you would access any stored  Ansible variable.

```
- hosts: all
  remote_user: root

  # create a variable named "proxy_env" that is a dictionary
  vars:
    proxy_env:
      http_proxy: http://proxy.example.com:8080

  tasks:

    - name: Install cobbler
      ansible.builtin.package:
        name: cobbler
        state: present
      environment: "{{ proxy_env }}"
```

You can store environment settings for re-use in multiple playbooks by defining them in a group_vars file.

```
---
# file: group_vars/boston

ntp_server: ntp.bos.example.com
backup: bak.bos.example.com
proxy_env:
  http_proxy: http://proxy.bos.example.com:8080
  https_proxy: http://proxy.bos.example.com:8080
```

You can set the remote environment at the play level.

```
- hosts: testing

  roles:
     - php
     - nginx

  environment:
    http_proxy: http://proxy.example.com:8080
```

These examples show proxy settings, but you can provide any number of settings this way.

## Working with language-specific version managers

Some language-specific version managers (such as rbenv and nvm)  require you to set environment variables while these tools are in use.  When using these tools manually, you usually source some environment  variables from a script or from lines added to your shell configuration  file. In Ansible, you can do this with the environment keyword at the  play level.

```
---
### A playbook demonstrating a common npm workflow:
# - Check for package.json in the application directory
# - If package.json exists:
#   * Run npm prune
#   * Run npm install

- hosts: application
  become: false

  vars:
    node_app_dir: /var/local/my_node_app

  environment:
    NVM_DIR: /var/local/nvm
    PATH: /var/local/nvm/versions/node/v4.2.1/bin:{{ ansible_env.PATH }}

  tasks:
  - name: Check for package.json
    ansible.builtin.stat:
      path: '{{ node_app_dir }}/package.json'
    register: packagejson

  - name: Run npm prune
    ansible.builtin.command: npm prune
    args:
      chdir: '{{ node_app_dir }}'
    when: packagejson.stat.exists

  - name: Run npm install
    community.general.npm:
      path: '{{ node_app_dir }}'
    when: packagejson.stat.exists
```

Note

The example above uses `ansible_env` as part of the PATH. Basing variables on `ansible_env` is risky. Ansible populates `ansible_env` values by gathering facts, so the value of the variables depends on the remote_user or become_user Ansible used when gathering those facts. If  you change remote_user/become_user the values in `ansible_env` may not be the ones you expect.

Warning

Environment variables are normally passed in clear text (shell plugin dependent) so they are not a recommended way of passing secrets to the  module being executed.

You can also specify the environment at the task level.

```
---
- name: Install ruby 2.3.1
  ansible.builtin.command: rbenv install {{ rbenv_ruby_version }}
  args:
    creates: '{{ rbenv_root }}/versions/{{ rbenv_ruby_version }}/bin/ruby'
  vars:
    rbenv_root: /usr/local/rbenv
    rbenv_ruby_version: 2.3.1
  environment:
    CONFIGURE_OPTS: '--disable-install-doc'
    RBENV_ROOT: '{{ rbenv_root }}'
    PATH: '{{ rbenv_root }}/bin:{{ rbenv_root }}/shims:{{ rbenv_plugins }}/ruby-build/bin:{{ ansible_env.PATH }}'
```

## Re-using Ansible artifacts

You can write a simple playbook in one very large file, and most  users learn the one-file approach first. However, breaking your  automation work up into smaller files is an excellent way to organize  complex sets of tasks and reuse them. Smaller, more distributed  artifacts let you re-use the same variables, tasks, and plays in  multiple playbooks to address different use cases. You can use  distributed artifacts across multiple parent playbooks or even multiple  times within one playbook. For example, you might want to update your  customer database as part of several different playbooks. If you put all the tasks related to updating your database in a tasks file or a role,  you can re-use them in many playbooks while only maintaining them in one place.

### Creating re-usable files and roles

Ansible offers four distributed, re-usable artifacts: variables files, task files, playbooks, and roles.

> - A variables file contains only variables.
> - A task file contains only tasks.
> - A playbook contains at least one play, and may contain variables, tasks, and other content. You can re-use tightly focused playbooks, but you can only re-use them statically, not dynamically.
> - A role contains a set of related tasks, variables, defaults,  handlers, and even modules or other plugins in a defined file-tree.  Unlike variables files, task files, or playbooks, roles can be easily  uploaded and shared through Ansible Galaxy. See [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles) for details about creating and using roles.

New in version 2.4.

### Re-using playbooks

You can incorporate multiple playbooks into a main playbook. However, you can only use imports to re-use playbooks. For example:

```
- import_playbook: webservers.yml
- import_playbook: databases.yml
```

Importing incorporates playbooks in other playbooks statically.  Ansible runs the plays and tasks in each imported playbook in the order  they are listed, just as if they had been defined directly in the main  playbook.

You can select which playbook you want to import at runtime by  defining your imported playbook filename with a variable, then passing  the variable with either `--extra-vars` or the `vars` keyword. For example:

```
- import_playbook: "/path/to/{{ import_from_extra_var }}"
- import_playbook: "{{ import_from_vars }}"
  vars:
    import_from_vars: /path/to/one_playbook.yml
```

If you run this playbook with `ansible-playbook my_playbook -e import_from_extra_var=other_playbook.yml`, Ansible imports both one_playbook.yml and other_playbook.yml.

### When to turn a playbook into a role

For some use cases, simple playbooks work well. However, starting at a certain level of complexity, roles work better than playbooks. A role  lets you store your defaults, handlers, variables, and tasks in separate directories, instead of in a single long document. Roles are easy to  share on Ansible Galaxy. For complex use cases, most users find roles  easier to read, understand, and maintain than all-in-one playbooks.

### Re-using files and roles

Ansible offers two ways to re-use files and roles in a playbook: dynamic and static.

> - For dynamic re-use, add an `include_*` task in the tasks section of a play:
>   - [include_role](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_role_module.html#include-role-module)
>   - [include_tasks](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_tasks_module.html#include-tasks-module)
>   - [include_vars](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_vars_module.html#include-vars-module)
> - For static re-use, add an `import_*` task in the tasks section of a play:
>   - [import_role](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/import_role_module.html#import-role-module)
>   - [import_tasks](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/import_tasks_module.html#import-tasks-module)

Task include and import statements can be used at arbitrary depth.

You can still use the bare [roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#roles-keyword) keyword at the play level to incorporate a role in a playbook statically. However, the bare [include](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_module.html#include-module) keyword, once used for both task files and playbook-level includes, is now deprecated.

#### Includes: dynamic re-use

Including roles, tasks, or variables adds them to a playbook  dynamically. Ansible processes included files and roles as they come up  in a playbook, so included tasks can be affected by the results of  earlier tasks within the top-level playbook. Included roles and tasks  are similar to handlers - they may or may not run, depending on the  results of other tasks in the top-level playbook.

The primary advantage of using `include_*` statements is looping. When a loop is used with an include, the  included tasks or role will be executed once for each item in the loop.

The filenames for included roles, tasks, and vars are templated before inclusion.

You can pass variables into includes. See [Variable precedence: Where should I put a variable?](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#ansible-variable-precedence) for more details on variable inheritance and precedence.

#### Imports: static re-use

Importing roles, tasks, or playbooks adds them to a playbook  statically. Ansible pre-processes imported files and roles before it  runs any tasks in a playbook, so imported content is never affected by  other tasks within the top-level playbook.

The filenames for imported roles and tasks support templating, but  the variables must be available when Ansible is pre-processing the  imports. This can be done with the `vars` keyword or by using `--extra-vars`.

You can pass variables to imports. You must pass variables if you  want to run an imported file more than once in a playbook. For example:

```
tasks:
- import_tasks: wordpress.yml
  vars:
    wp_user: timmy

- import_tasks: wordpress.yml
  vars:
    wp_user: alice

- import_tasks: wordpress.yml
  vars:
    wp_user: bob
```

See [Variable precedence: Where should I put a variable?](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#ansible-variable-precedence) for more details on variable inheritance and precedence.

#### Comparing includes and imports: dynamic and static re-use

Each approach to re-using distributed Ansible artifacts has  advantages and limitations. You may choose dynamic re-use for some  playbooks and static re-use for others. Although you can use both  dynamic and static re-use in a single playbook, it is best to select one approach per playbook. Mixing static and dynamic re-use can introduce  difficult-to-diagnose bugs into your playbooks. This table summarizes  the main differences so you can choose the best approach for each  playbook you create.

|                           | Include_*                               | Import_*                                 |
| ------------------------- | --------------------------------------- | ---------------------------------------- |
| Type of re-use            | Dynamic                                 | Static                                   |
| When processed            | At runtime, when encountered            | Pre-processed during playbook parsing    |
| Task or play              | All includes are tasks                  | `import_playbook` cannot be a task       |
| Task options              | Apply only to include task itself       | Apply to all child tasks in import       |
| Calling from loops        | Executed once for each loop item        | Cannot be used in a loop                 |
| Using `--list-tags`       | Tags within includes not listed         | All tags appear with `--list-tags`       |
| Using `--list-tasks`      | Tasks within includes not listed        | All tasks appear with `--list-tasks`     |
| Notifying handlers        | Cannot trigger handlers within includes | Can trigger individual imported handlers |
| Using `--start-at-task`   | Cannot start at tasks within includes   | Can start at imported tasks              |
| Using inventory variables | Can `include_*: {{ inventory_var }}`    | Cannot `import_*: {{ inventory_var }}`   |
| With playbooks            | No `include_playbook`                   | Can import full playbooks                |
| With variables files      | Can include variables files             | Use `vars_files:` to import variables    |

Note

- There are also big differences in resource consumption and  performance, imports are quite lean and fast, while includes require a  lot of management and accounting.

### Re-using tasks as handlers

You can also use includes and imports in the [Handlers: running operations on change](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_handlers.html#handlers) section of a playbook. For instance, if you want to define how to  restart Apache, you only have to do that once for all of your playbooks. You might make a `restarts.yml` file that looks like:

```
# restarts.yml
- name: Restart apache
  ansible.builtin.service:
    name: apache
    state: restarted

- name: Restart mysql
  ansible.builtin.service:
    name: mysql
    state: restarted
```

You can trigger handlers from either an import or an include, but the procedure is different for each method of re-use. If you include the  file, you must notify the include itself, which triggers all the tasks  in `restarts.yml`. If you import the file, you must notify the individual task(s) within `restarts.yml`. You can mix direct tasks and handlers with included or imported tasks and handlers.

#### Triggering included (dynamic) handlers

Includes are executed at run-time, so the name of the include exists  during play execution, but the included tasks do not exist until the  include itself is triggered. To use the `Restart apache` task with dynamic re-use, refer to the name of the include itself. This approach triggers all tasks in the included file as handlers. For  example, with the task file shown above:

```
- name: Trigger an included (dynamic) handler
  hosts: localhost
  handlers:
    - name: Restart services
      include_tasks: restarts.yml
  tasks:
    - command: "true"
      notify: Restart services
```

#### Triggering imported (static) handlers

Imports are processed before the play begins, so the name of the  import no longer exists during play execution, but the names of the  individual imported tasks do exist. To use the `Restart apache` task with static re-use, refer to the name of each task or tasks within the imported file. For example, with the task file shown above:

```
- name: Trigger an imported (static) handler
  hosts: localhost
  handlers:
    - name: Restart services
      import_tasks: restarts.yml
  tasks:
    - command: "true"
      notify: Restart apache
    - command: "true"
      notify: Restart mysql
```

## Role

let you automatically load related vars, files, tasks,  handlers, and other Ansible artifacts based on a known file structure.  Role 允许您基于已知的文件结构自动加载相关的变量、文件、任务、处理程序和其他 Ansible 工件。将内容按角色分组后，可以轻松地重用它们并与其他用户共享。

### Role 目录结构

Ansible role 具有定义的目录结构，其中包含八个主要标准目录。每个 role 中必须至少包含其中一个目录。可以省略 role 不使用的任何目录。例如：

```bash
# playbooks
site.yml
webservers.yml
fooservers.yml
roles/
    common/               # this hierarchy represents a "role"此层次结构表示“角色”
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted task 文件可以包含较小的文件（如果需要）
        handlers/         #
            main.yml      #  <-- handler 文件
        templates/        #  <-- files for use with the template resource用于模板资源的文件
            ntp.conf.j2   #  <-- 模板以 .j2 结尾
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- 与此 role 关联的变量
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role 此角色的默认较低优先级变量
        meta/             #
            main.yml      #  <-- role 依赖项
        library/          # roles can also include custom modules 可以包括自定义模块
        module_utils/     # roles can also include custom module_utils 可以包括自定义模块utils
        lookup_plugins/   # or other types of plugins, like lookup in this case 或其他类型的插件，如本例中的查找

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```

默认情况下，Ansible 将在 role 内的每个目录中查找 `main.yml` 文件以查找相关内容（也包括 `main.yaml` 和 `main` ）：

- `tasks/main.yml` - role 执行的任务的主列表。
- `handlers/main.yml` - 可以在此 role 内部或外部使用的 handler 。
- `library/my_module.py` - 模块，可以在该角色中使用。
- `defaults/main.yml` - default variables for the role. These variables have the lowest priority of any  variables available, and can be easily overridden by any other variable, including inventory variables.角色的默认变量。这些变量在所有可用变量中具有最低优先级，并且可以被任何其他变量（包括库存变量）轻松覆盖。
- `vars/main.yml` - role 的其他变量。
- `files/main.yml` - files that the role deploys.角色部署的文件。
- `templates/main.yml` - templates that the role deploys.角色部署的模板。
- `meta/main.yml` - metadata for the role, including role dependencies and optional Galaxy metadata such as platforms supported.角色的元数据，包括角色依赖关系和可选的Galaxy元数据，如支持的平台。

可以在某些目录中添加其他 YAML 文件。例如，可以将特定于平台的任务放置在单独的文件中，并在 `tasks/main.yml` 文件中引用它们：

```yaml
# roles/example/tasks/main.yml
- name: Install the correct web server for RHEL
  import_tasks: redhat.yml
  when: ansible_facts['os_family']|lower == 'redhat'

- name: Install the correct web server for Debian
  import_tasks: debian.yml
  when: ansible_facts['os_family']|lower == 'debian'

# roles/example/tasks/redhat.yml
- name: Install web server
  ansible.builtin.yum:
    name: "httpd"
    state: present

# roles/example/tasks/debian.yml
- name: Install web server
  ansible.builtin.apt:
    name: "apache2"
    state: present
```

Roles may also include modules and other plugin types in a directory called `library`. For more information, please refer to [Embedding modules and plugins in roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#embedding-modules-and-plugins-in-roles) below.角色还可以包括名为库的目录中的模块和其他插件类型。有关更多信息，请参阅以下角色中的嵌入模块和插件。

### 存储和查找 role

默认情况下，Ansible 在以下位置查找 role ：

- in collections, if you are using them 在集合中，如果您正在使用它们
- in a directory called `roles/`, relative to the playbook file 在名为roles/的目录中，相对于playbook文件
- in the configured [roles_path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-roles-path). The default search path is `~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles`.在配置的角色路径中。默认搜索路径为~/.ansible/roles:/usr/share/ansible-roles:/etc/ansible/role。
- 在 playbook 文件所在的目录中。

If you store your roles in a different location, set the [roles_path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-roles-path) configuration option so Ansible can find your roles. Checking shared  roles into a single location makes them easier to use in multiple  playbooks. 如果您将角色存储在其他位置，请设置角色路径配置选项，以便Ansible可以找到您的角色。将共享角色检查到一个位置，使其更易于在多个剧本中使用。

或者，可以使用完全限定的路径调用 role ：

```yaml
---
- hosts: webservers
  roles:
    - role: '/path/to/my/roles/common'
```

### 使用 role

可以通过三种方式使用 role ：

- at the play level with the `roles` option: This is the classic way of using roles in a play.在角色选项的游戏层面：这是在剧中使用角色的经典方式。
- at the tasks level with `include_role`: You can reuse roles dynamically anywhere in the `tasks` section of a play using `include_role`.在包含角色的任务级别：您可以使用包含角色在剧中任务部分的任何位置动态重用角色。
- at the tasks level with `import_role`: You can reuse roles statically anywhere in the `tasks` section of a play using `import_role`.在具有导入角色的任务级别：您可以使用导入角色在剧中任务部分的任何位置静态重用角色。

#### 在 play 级别使用 role

The classic (original) way to use roles is with the `roles` option for a given play:

使用角色的经典（原始）方式是为给定的角色选择：

```yaml
---
- hosts: webservers
  roles:
    - common
    - webservers
```

在 play 级别使用 `roles` 选项时，对于每个 role “x”：

- 如果 `roles/x/tasks/main.yml` 存在，Ansible 会将该文件中的 task 添加到 play 中。
- 如果 `roles/x/handlers/main.yml` 存在，Ansible 会将该文件中的 handler 添加到 play 中。
- 如果 `roles/x/vars/main.yml` 存在，Ansible 会将该文件中的变量添加到 play 中。
- 如果 `roles/x/defaults/main.yml` 存在，Ansible 会将该文件中的变量添加到 play 中。
- Ansible adds any role dependencies in that file to the list of roles.如果 `roles/x/meta/main.yml` 存在，Ansible 会将该文件中的任何角色依赖项添加到角色列表中。
- Any copy, script, template or include tasks (in the role) can  reference files in roles/x/{files,templates,tasks}/ (dir depends on  task) without having to path them relatively or absolutely.任何副本、脚本、模板或包含任务（在角色中）都可以引用roles/x/{文件、模板、任务}/（dir取决于任务）中的文件，而无需相对或绝对地对它们进行路径。

当您在 play 级别使用 `roles` 选项时，Ansible 将 role 视为静态导入，并在 playbook 解析期间处理它们。Ansible 按以下顺序执行每个 play ：

- Any `pre_tasks` defined in the play.剧中定义的任何前期任务。
- Any handlers triggered by pre_tasks.由预任务触发的任何处理程序。
- Each role listed in `roles:`, in the order listed. Any role dependencies defined in the role’s `meta/main.yml` run first, subject to tag filtering and conditionals. See [Using role dependencies](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#role-dependencies) for more details.角色中列出的每个角色：，按列出的顺序。在角色的meta/main.yml中定义的任何角色依赖关系都会首先运行，并接受标记筛选和条件。有关详细信息，请参阅使用角色依赖关系。
- Any `tasks` defined in the play.剧中定义的任何任务。
- Any handlers triggered by the roles or tasks.由角色或任务触发的任何处理程序。
- Any `post_tasks` defined in the play.剧中定义的任何后期任务。
- Any handlers triggered by post_tasks.由发布任务触发的任何处理程序。

> Note
>
> If using tags with tasks in a role, be sure to also tag your  pre_tasks, post_tasks, and role dependencies and pass those along as  well, especially if the pre/post tasks and role dependencies are used  for monitoring outage window control or load balancing. See [Tags](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tags) for details on adding and using tags.
>
> 如果将标记用于角色中的任务，请确保还标记您的前任务、后任务和角色依赖关系，并将它们传递出去，尤其是当前/后任务和任务依赖关系用于监视停机窗口控制或负载平衡时。有关添加和使用标记的详细信息，请参见标记。

You can pass other keywords to the `roles` option

可以将其他关键字传递给 `roles` 选项：

```yaml
---
- hosts: webservers
  roles:
    - common
    - role: foo_app_instance
      vars:
        dir: '/opt/a'
        app_port: 5000
      tags: typeA
    - role: foo_app_instance
      vars:
        dir: '/opt/b'
        app_port: 5001
      tags: typeB
```

When you add a tag to the `role` option, Ansible applies the tag to ALL tasks within the role.

When using `vars:` within the `roles:` section of a playbook, the variables are added to the play variables,  making them available to all tasks within the play before and after the  role. This behavior can be changed by [DEFAULT_PRIVATE_ROLE_VARS](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-private-role-vars).

#### Including roles: dynamic reuse

You can reuse roles dynamically anywhere in the `tasks` section of a play using `include_role`. While roles added in a `roles` section run before any other tasks in a play, included roles run in the order they are defined. If there are other tasks before an `include_role` task, the other tasks will run first.

To include a role:

向角色选项添加标记时，Ansible会将标记应用于角色中的所有任务。

在剧本的roles:部分中使用vars:within时，变量被添加到play变量中，使其可用于角色前后的所有任务。此行为可以由DEFAULT PRIVATE ROLE VARS更改。

包括角色：动态重用

您可以使用include角色在剧中任务部分的任何位置动态重用角色。虽然角色部分中添加的角色在剧中的任何其他任务之前运行，但包含的角色按照定义的顺序运行。如果包含角色任务之前还有其他任务，则其他任务将首先运行。

要包含角色：

```
---
- hosts: webservers
  tasks:
    - name: Print a message
      ansible.builtin.debug:
        msg: "this task runs before the example role"

    - name: Include the example role
      include_role:
        name: example

    - name: Print a message
      ansible.builtin.debug:
        msg: "this task runs after the example role"
```

You can pass other keywords, including variables and tags, when including roles:

```
---
- hosts: webservers
  tasks:
    - name: Include the foo_app_instance role
      include_role:
        name: foo_app_instance
      vars:
        dir: '/opt/a'
        app_port: 5000
      tags: typeA
  ...
```

When you add a [tag](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tags) to an `include_role` task, Ansible applies the tag only to the include itself. This means you can pass `--tags` to run only selected tasks from the role, if those tasks themselves have the same tag as the include statement. See [Selectively running tagged tasks in re-usable files](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selective-reuse) for details.

You can conditionally include a role:

```
---
- hosts: webservers
  tasks:
    - name: Include the some_role role
      include_role:
        name: some_role
      when: "ansible_facts['os_family'] == 'RedHat'"
```

#### Importing roles: static reuse

You can reuse roles statically anywhere in the `tasks` section of a play using `import_role`. The behavior is the same as using the `roles` keyword. For example:

```
---
- hosts: webservers
  tasks:
    - name: Print a message
      ansible.builtin.debug:
        msg: "before we run our role"

    - name: Import the example role
      import_role:
        name: example

    - name: Print a message
      ansible.builtin.debug:
        msg: "after we ran our role"
```

You can pass other keywords, including variables and tags, when importing roles:

```
---
- hosts: webservers
  tasks:
    - name: Import the foo_app_instance role
      import_role:
        name: foo_app_instance
      vars:
        dir: '/opt/a'
        app_port: 5000
  ...
```

When you add a tag to an `import_role` statement, Ansible applies the tag to all tasks within the role. See [Tag inheritance: adding tags to multiple tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance) for details.

### Role argument validation

Beginning with version 2.11, you may choose to enable role argument validation based on an argument specification. This specification is defined in the `meta/argument_specs.yml` file (or with the `.yaml` file extension). When this argument specification is defined, a new task is inserted at the beginning of role execution that will validate the parameters supplied for the role against the specification. If the parameters fail validation, the role will fail execution.

Note

Ansible also supports role specifications defined in the role `meta/main.yml` file, as well. However, any role that defines the specs within this file will not work on versions below 2.11. For this reason, we recommend using the `meta/argument_specs.yml` file to maintain backward compatibility.

Note

When role argument validation is used on a role that has defined [dependencies](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#role-dependencies), then validation on those dependencies will run before the dependent role, even if argument validation fails for the dependent role.

#### Specification format

The role argument specification must be defined in a top-level `argument_specs` block within the role `meta/argument_specs.yml` file. All fields are lower-case.

- entry-point-name

  The name of the role entry point. This should be `main` in the case of an unspecified entry point. This will be the base name of the tasks file to execute, with no `.yml` or `.yaml` file extension.  short_description A short, one-line description of the entry point. The `short_description` is displayed by `ansible-doc -t role -l`.  description A longer description that may contain multiple lines.  author Name of the entry point authors. Use a multi-line list if there is more than one author.  options Options are often called “parameters” or “arguments”. This section defines those options. For each role option (argument), you may include:  option-name The name of the option/argument.  description Detailed explanation of what this option does. It should be written in full sentences.  type The data type of the option. See [Argument spec](https://docs.ansible.com/ansible/latest/dev_guide/developing_program_flow_modules.html#argument-spec) for allowed values for `type`. Default is `str`. If an option is of type `list`, `elements` should be specified.  required Only needed if `true`. If missing, the option is not required.  default If `required` is false/missing, `default` may be specified (assumed ‘null’ if missing). Ensure that the default value in the docs matches the default value in the code. The actual default for the role variable will always come from `defaults/main.yml`. The default field must not be listed as part of the description, unless it requires additional information or conditions. If the option is a boolean value, you should use true/false if you want to be compatible with ansible-lint.  choices List of option values. Should be absent if empty.  elements Specifies the data type for list elements when type is `list`.  options If this option takes a dict or list of dicts, you can define the structure here.

#### Sample specification

```
# roles/myapp/meta/argument_specs.yml
---
argument_specs:
  # roles/myapp/tasks/main.yml entry point
  main:
    short_description: The main entry point for the myapp role.
    options:
      myapp_int:
        type: "int"
        required: false
        default: 42
        description: "The integer value, defaulting to 42."

      myapp_str:
        type: "str"
        required: true
        description: "The string value"

  # roles/myapp/tasks/alternate.yml entry point
  alternate:
    short_description: The alternate entry point for the myapp role.
    options:
      myapp_int:
        type: "int"
        required: false
        default: 1024
        description: "The integer value, defaulting to 1024."
```

### Running a role multiple times in one play

Ansible only executes each role once in a play, even if you define it multiple times, unless the parameters defined on the role are different for each definition. For example, Ansible only runs the role `foo` once in a play like this:

```
---
- hosts: webservers
  roles:
    - foo
    - bar
    - foo
```

You have two options to force Ansible to run a role more than once.

#### Passing different parameters

If you pass different parameters in each role definition, Ansible  runs the role more than once. Providing different variable values is not the same as passing different role parameters. You must use the `roles` keyword for this behavior, since `import_role` and `include_role` do not accept role parameters.

This play runs the `foo` role twice:

```
---
- hosts: webservers
  roles:
    - { role: foo, message: "first" }
    - { role: foo, message: "second" }
```

This syntax also runs the `foo` role twice;

```
---
- hosts: webservers
  roles:
    - role: foo
      message: "first"
    - role: foo
      message: "second"
```

In these examples, Ansible runs `foo` twice because each role definition has different parameters.

#### Using `allow_duplicates: true`

Add `allow_duplicates: true` to the `meta/main.yml` file for the role:

```
# playbook.yml
---
- hosts: webservers
  roles:
    - foo
    - foo

# roles/foo/meta/main.yml
---
allow_duplicates: true
```

In this example, Ansible runs `foo` twice because we have explicitly enabled it to do so.

### Using role dependencies

Role dependencies let you automatically pull in other roles when using a role.

Role dependencies are prerequisites, not true dependencies. The roles do not have a parent/child relationship. Ansible loads all listed  roles, runs the roles listed under `dependencies` first, then runs the role that lists them. The play object is the parent of all roles, including roles called by a `dependencies` list.

Role dependencies are stored in the `meta/main.yml` file within the role directory. This file should contain a list of  roles and parameters to insert before the specified role. For example:

```
# roles/myapp/meta/main.yml
---
dependencies:
  - role: common
    vars:
      some_parameter: 3
  - role: apache
    vars:
      apache_port: 80
  - role: postgres
    vars:
      dbname: blarg
      other_parameter: 12
```

Ansible always executes roles listed in `dependencies` before the role that lists them. Ansible executes this pattern recursively when you use the `roles` keyword. For example, if you list role `foo` under `roles:`, role `foo` lists role `bar` under `dependencies` in its meta/main.yml file, and role `bar` lists role `baz` under `dependencies` in its meta/main.yml, Ansible executes `baz`, then `bar`, then `foo`.

#### Running role dependencies multiple times in one play

Ansible treats duplicate role dependencies like duplicate roles listed under `roles:`: Ansible only executes role dependencies once, even if defined multiple  times, unless the parameters, tags, or when clause defined on the role  are different for each definition. If two roles in a play both list a  third role as a dependency, Ansible only runs that role dependency once, unless you pass different parameters, tags, when clause, or use `allow_duplicates: true` in the role you want to run multiple times. See [Galaxy role dependencies](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#galaxy-dependencies) for more details.

Note

Role deduplication does not consult the invocation signature of parent roles. Additionally, when using `vars:` instead of role params, there is a side effect of changing variable scoping. Using `vars:` results in those variables being scoped at the play level. In the below example, using `vars:` would cause `n` to be defined as `4` through the entire play, including roles called before it.

In addition to the above, users should be aware that role de-duplication occurs before variable evaluation. This means that [Lazy Evaluation](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html#term-Lazy-Evaluation) may make seemingly different role invocations equivalently the same, preventing the role from running more than once.

For example, a role named `car` depends on a role named `wheel` as follows:

```
---
dependencies:
  - role: wheel
    n: 1
  - role: wheel
    n: 2
  - role: wheel
    n: 3
  - role: wheel
    n: 4
```

And the `wheel` role depends on two roles: `tire` and `brake`. The `meta/main.yml` for wheel would then contain the following:

```
---
dependencies:
  - role: tire
  - role: brake
```

And the `meta/main.yml` for `tire` and `brake` would contain the following:

```
---
allow_duplicates: true
```

The resulting order of execution would be as follows:

```
tire(n=1)
brake(n=1)
wheel(n=1)
tire(n=2)
brake(n=2)
wheel(n=2)
...
car
```

To use `allow_duplicates: true` with role dependencies, you must specify it for the role listed under `dependencies`, not for the role that lists it. In the example above, `allow_duplicates: true` appears in the `meta/main.yml` of the `tire` and `brake` roles. The `wheel` role does not require `allow_duplicates: true`, because each instance defined by `car` uses different parameter values.

Note

See [Using Variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#playbooks-variables) for details on how Ansible chooses among variable values defined in different places (variable inheritance and scope). Also deduplication happens ONLY at the play level, so multiple plays in the same playbook may rerun the roles.

### Embedding modules and plugins in roles

Note

This applies only to standalone roles. Roles in collections do not support plugin embedding; they must use the collection’s `plugins` structure to distribute plugins.

If you write a custom module (see [Should you develop a module?](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules.html#developing-modules)) or a plugin (see [Developing plugins](https://docs.ansible.com/ansible/latest/dev_guide/developing_plugins.html#developing-plugins)), you might wish to distribute it as part of a role. For example, if you  write a module that helps configure your company’s internal software,  and you want other people in your organization to use this module, but  you do not want to tell everyone how to configure their Ansible library  path, you can include the module in your internal_config role.

To add a module or a plugin to a role: Alongside the ‘tasks’ and ‘handlers’ structure of a role, add a  directory named ‘library’ and then include the module directly inside  the ‘library’ directory.

Assuming you had this:

```
roles/
    my_custom_modules/
        library/
            module1
            module2
```

The module will be usable in the role itself, as well as any roles that are called *after* this role, as follows:

```
---
- hosts: webservers
  roles:
    - my_custom_modules
    - some_other_role_using_my_custom_modules
    - yet_another_role_using_my_custom_modules
```

If necessary, you can also embed a module in a role to modify a  module in Ansible’s core distribution. For example, you can use the  development version of a particular module before it is released in  production releases by copying the module and embedding the copy in a  role. Use this approach with caution, as API signatures may change in  core components, and this workaround is not guaranteed to work.

The same mechanism can be used to embed and distribute plugins in a  role, using the same schema. For example, for a filter plugin:

```
roles/
    my_custom_filter/
        filter_plugins
            filter1
            filter2
```

These filters can then be used in a Jinja template in any role called after ‘my_custom_filter’.

### Sharing roles: Ansible Galaxy

[Ansible Galaxy](https://galaxy.ansible.com) is a free site for finding, downloading, rating, and reviewing all  kinds of community-developed Ansible roles and can be a great way to get a jumpstart on your automation projects.

The client `ansible-galaxy` is included in Ansible. The Galaxy client allows you to download roles  from Ansible Galaxy and provides an excellent default framework for  creating your own roles.

Read the [Ansible Galaxy documentation](https://galaxy.ansible.com/docs/) page for more information. A page that refers back to this one  frequently is the Galaxy Roles document which explains the required  metadata your role needs for use in Galaxy <https://galaxy.ansible.com/docs/contributing/creating_role.html>.

## Module defaults

If you frequently call the same module with the same arguments, it  can be useful to define default arguments for that particular module  using the `module_defaults` keyword.

Here is a basic example:

```
- hosts: localhost
  module_defaults:
    ansible.builtin.file:
      owner: root
      group: root
      mode: 0755
  tasks:
    - name: Create file1
      ansible.builtin.file:
        state: touch
        path: /tmp/file1

    - name: Create file2
      ansible.builtin.file:
        state: touch
        path: /tmp/file2

    - name: Create file3
      ansible.builtin.file:
        state: touch
        path: /tmp/file3
```

The `module_defaults` keyword can be used at the play, block, and task level. Any module  arguments explicitly specified in a task will override any established  default for that module argument.

```
- block:
    - name: Print a message
      ansible.builtin.debug:
        msg: "Different message"
  module_defaults:
    ansible.builtin.debug:
      msg: "Default message"
```

You can remove any previously established defaults for a module by specifying an empty dict.

```
- name: Create file1
  ansible.builtin.file:
    state: touch
    path: /tmp/file1
  module_defaults:
    file: {}
```

Note

Any module defaults set at the play level (and block/task level when using `include_role` or `import_role`) will apply to any roles used, which may cause unexpected behavior in the role.

Here are some more realistic use cases for this feature.

Interacting with an API that requires auth.

```
- hosts: localhost
  module_defaults:
    ansible.builtin.uri:
      force_basic_auth: true
      user: some_user
      password: some_password
  tasks:
    - name: Interact with a web service
      ansible.builtin.uri:
        url: http://some.api.host/v1/whatever1

    - name: Interact with a web service
      ansible.builtin.uri:
        url: http://some.api.host/v1/whatever2

    - name: Interact with a web service
      ansible.builtin.uri:
        url: http://some.api.host/v1/whatever3
```

Setting a default AWS region for specific EC2-related modules.

```
- hosts: localhost
  vars:
    my_region: us-west-2
  module_defaults:
    amazon.aws.ec2:
      region: '{{ my_region }}'
    community.aws.ec2_instance_info:
      region: '{{ my_region }}'
    amazon.aws.ec2_vpc_net_info:
      region: '{{ my_region }}'
```

### Module defaults groups

New in version 2.7.

Ansible 2.7 adds a preview-status feature to group together modules  that share common sets of parameters. This makes it easier to author  playbooks making heavy use of API-based modules such as cloud modules.

| Group   | Purpose               | Ansible Version |
| ------- | --------------------- | --------------- |
| aws     | Amazon Web Services   | 2.7             |
| azure   | Azure                 | 2.7             |
| gcp     | Google Cloud Platform | 2.7             |
| k8s     | Kubernetes            | 2.8             |
| os      | OpenStack             | 2.8             |
| acme    | ACME                  | 2.10            |
| docker* | Docker                | 2.10            |
| ovirt   | oVirt                 | 2.10            |
| vmware  | VMware                | 2.10            |

- The [docker_stack](https://docs.ansible.com/ansible/latest/playbook_guide/docker_stack_module) module is not included in the `docker` defaults group.

Use the groups with `module_defaults` by prefixing the group name with `group/` - for example `group/aws`.

In a playbook, you can set module defaults for whole groups of modules, such as setting a common AWS region.

```
# example_play.yml
- hosts: localhost
  module_defaults:
    group/aws:
      region: us-west-2
  tasks:
  - name: Get info
    aws_s3_bucket_info:

  # now the region is shared between both info modules

  - name: Get info
    ec2_ami_info:
      filters:
        name: 'RHEL*7.5*'
```

In ansible-core 2.12, collections can define their own groups in the `meta/runtime.yml` file. `module_defaults` does not take the `collections` keyword into account, so the fully qualified group name must be used for new groups in `module_defaults`.

Here is an example `runtime.yml` file for a collection and a sample playbook using the group.

```
# collections/ansible_collections/ns/coll/meta/runtime.yml
action_groups:
  groupname:
    - module
    - another.collection.module
- hosts: localhost
  module_defaults:
    group/ns.coll.groupname:
      option_name: option_value
  tasks:
    - ns.coll.module:
    - another.collection.module
```

## Interactive input: prompts

If you want your playbook to prompt the user for certain input, add a ‘vars_prompt’ section. Prompting the user for variables lets you avoid  recording sensitive data like passwords. In addition to security,  prompts support flexibility. For example, if you use one playbook across multiple software releases, you could prompt for the particular release version.

- [Hashing values supplied by `vars_prompt`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html#hashing-values-supplied-by-vars-prompt)
- [Allowing special characters in `vars_prompt` values](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html#allowing-special-characters-in-vars-prompt-values)

Here is a most basic example:

```
---
- hosts: all
  vars_prompt:

    - name: username
      prompt: What is your username?
      private: false

    - name: password
      prompt: What is your password?

  tasks:

    - name: Print a message
      ansible.builtin.debug:
        msg: 'Logging in as {{ username }}'
```

The user input is hidden by default but it can be made visible by setting `private: no`.

Note

Prompts for individual `vars_prompt` variables will be skipped for any variable that is already defined through the command line `--extra-vars` option, or when running from a non-interactive session (such as cron or Ansible AWX). See [Defining variables at runtime](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#passing-variables-on-the-command-line).

If you have a variable that changes infrequently, you can provide a default value that can be overridden.

```
vars_prompt:

  - name: release_version
    prompt: Product release version
    default: "1.0"
```

### Hashing values supplied by `vars_prompt`

You can hash the entered value so you can use it, for instance, with the user module to define a password:

```
vars_prompt:

  - name: my_password2
    prompt: Enter password2
    private: true
    encrypt: sha512_crypt
    confirm: true
    salt_size: 7
```

If you have [Passlib](https://passlib.readthedocs.io/en/stable/) installed, you can use any crypt scheme the library supports:

- *des_crypt* - DES Crypt
- *bsdi_crypt* - BSDi Crypt
- *bigcrypt* - BigCrypt
- *crypt16* - Crypt16
- *md5_crypt* - MD5 Crypt
- *bcrypt* - BCrypt
- *sha1_crypt* - SHA-1 Crypt
- *sun_md5_crypt* - Sun MD5 Crypt
- *sha256_crypt* - SHA-256 Crypt
- *sha512_crypt* - SHA-512 Crypt
- *apr_md5_crypt* - Apache’s MD5-Crypt variant
- *phpass* - PHPass’ Portable Hash
- *pbkdf2_digest* - Generic PBKDF2 Hashes
- *cta_pbkdf2_sha1* - Cryptacular’s PBKDF2 hash
- *dlitz_pbkdf2_sha1* - Dwayne Litzenberger’s PBKDF2 hash
- *scram* - SCRAM Hash
- *bsd_nthash* - FreeBSD’s MCF-compatible nthash encoding

The only parameters accepted are ‘salt’ or ‘salt_size’. You can use your own salt by defining ‘salt’, or have one generated automatically using ‘salt_size’. By default Ansible generates a salt of size 8.

New in version 2.7.

If you do not have Passlib installed, Ansible uses the [crypt](https://docs.python.org/3/library/crypt.html) library as a fallback. Ansible supports at most four crypt schemes,  depending on your platform at most the following crypt schemes are  supported:

- *bcrypt* - BCrypt
- *md5_crypt* - MD5 Crypt
- *sha256_crypt* - SHA-256 Crypt
- *sha512_crypt* - SHA-512 Crypt

New in version 2.8.

### Allowing special characters in `vars_prompt` values

Some special characters, such as `{` and `%` can create templating errors. If you need to accept special characters, use the `unsafe` option:

```
vars_prompt:
  - name: my_password_with_weird_chars
    prompt: Enter password
    unsafe: true
    private: true
```

## Using Variables

Ansible uses variables to manage differences between systems. With  Ansible, you can execute tasks and playbooks on multiple different  systems with a single command. To represent the variations among those  different systems, you can create variables with standard YAML syntax,  including lists and dictionaries. You can define these variables in your playbooks, in your [inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#intro-inventory), in re-usable [files](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#playbooks-reuse) or [roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles), or at the command line. You can also create variables during a playbook run by registering the return value or values of a task as a new  variable.

After you create variables, either by defining them in a file,  passing them at the command line, or registering the return value or  values of a task as a new variable, you can use those variables in  module arguments, in [conditional “when” statements](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#playbooks-conditionals), in [templates](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_templating.html#playbooks-templating), and in [loops](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#playbooks-loops). The [ansible-examples github repository](https://github.com/ansible/ansible-examples) contains many examples of using variables in Ansible.

Once you understand the concepts and examples on this page, read about [Ansible facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#vars-and-facts), which are variables you retrieve from remote systems.

### Creating valid variable names

Not all strings are valid Ansible variable names. A variable name can only include letters, numbers, and underscores. [Python keywords](https://docs.python.org/3/reference/lexical_analysis.html#keywords) or [playbook keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#playbook-keywords) are not valid variable names. A variable name cannot begin with a number.

Variable names can begin with an underscore. In many programming  languages, variables that begin with an underscore are private. This is  not true in Ansible. Variables that begin with an underscore are treated exactly the same as any other variable. Do not rely on this convention  for privacy or security.

This table gives examples of valid and invalid variable names:

| Valid variable names | Not valid                                                    |
| -------------------- | ------------------------------------------------------------ |
| `foo`                | `*foo`, [Python keywords](https://docs.python.org/3/reference/lexical_analysis.html#keywords) such as `async` and `lambda` |
| `foo_env`            | [playbook keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#playbook-keywords) such as `environment` |
| `foo_port`           | `foo-port`, `foo port`, `foo.port`                           |
| `foo5`, `_foo`       | `5foo`, `12`                                                 |

### Simple variables

Simple variables combine a variable name with a single value. You can use this syntax (and the syntax for lists and dictionaries shown below) in a variety of places. For details about setting variables in  inventory, in playbooks, in reusable files, in roles, or at the command  line, see [Where to set variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#setting-variables).

#### Defining simple variables

You can define a simple variable using standard YAML syntax. For example:

```
remote_install_path: /opt/my_app_config
```

#### Referencing simple variables

After you define a variable, use Jinja2 syntax to reference it.  Jinja2 variables use double curly braces. For example, the expression `My amp goes to {{ max_amp_value }}` demonstrates the most basic form of variable substitution. You can use Jinja2 syntax in playbooks. For example:

```
ansible.builtin.template:
  src: foo.cfg.j2
  dest: '{{ remote_install_path }}/foo.cfg'
```

In this example, the variable defines the location of a file, which can vary from one system to another.

Note

Ansible allows Jinja2 loops and conditionals in [templates](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_templating.html#playbooks-templating) but not in playbooks. You cannot create a loop of tasks. Ansible playbooks are pure machine-parseable YAML.

### When to quote variables (a YAML gotcha)

If you start a value with `{{ foo }}`, you must quote the whole expression to create valid YAML syntax. If you do not quote the whole expression, the YAML parser cannot interpret the syntax - it might be a variable or it might be the start of a YAML  dictionary. For guidance on writing YAML, see the [YAML Syntax](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html#yaml-syntax) documentation.

If you use a variable without quotes like this:

```
- hosts: app_servers
  vars:
      app_path: {{ base_path }}/22
```

You will see: `ERROR! Syntax Error while loading YAML.` If you add quotes, Ansible works correctly:

```
- hosts: app_servers
  vars:
       app_path: "{{ base_path }}/22"
```

### Boolean variables

Ansible accepts a broad range of values for boolean variables: `true/false`, `1/0`, `yes/no`, `True/False` and so on. The matching of valid strings is case insensitive. While documentation examples focus on `true/false` to be compatible with `ansible-lint` default settings, you can use any of the following:

| Valid values                                                 | Description   |
| ------------------------------------------------------------ | ------------- |
| `True` , `'true'` , `'t'` , `'yes'` , `'y'` , `'on'` , `'1'` , `1` , `1.0` | Truthy values |
| `False` , `'false'` , `'f'` , `'no'` , `'n'` , `'off'` , `'0'` , `0` , `0.0` | Falsy values  |

### List variables

A list variable combines a variable name with multiple values. The  multiple values can be stored as an itemized list or in square brackets `[]`, separated with commas.

#### Defining variables as lists

You can define variables with multiple values using YAML lists. For example:

```
region:
  - northeast
  - southeast
  - midwest
```

#### Referencing list variables

When you use variables defined as a list (also called an array), you  can use individual, specific fields from that list. The first item in a  list is item 0, the second item is item 1. For example:

```
region: "{{ region[0] }}"
```

The value of this expression would be “northeast”.

### Dictionary variables

A dictionary stores the data in key-value pairs. Usually,  dictionaries are used to store related data, such as the information  contained in an ID or a user profile.

#### Defining variables as key:value dictionaries

You can define more complex variables using YAML dictionaries. A YAML dictionary maps keys to values.  For example:

```
foo:
  field1: one
  field2: two
```

#### Referencing key:value dictionary variables

When you use variables defined as a key:value dictionary (also called a hash), you can use individual, specific fields from that dictionary  using either bracket notation or dot notation:

```
foo['field1']
foo.field1
```

Both of these examples reference the same value (“one”). Bracket  notation always works. Dot notation can cause problems because some keys collide with attributes and methods of python dictionaries. Use bracket notation if you use keys which start and end with two underscores  (which are reserved for special meanings in python) or are any of the  known public attributes:

`add`, `append`, `as_integer_ratio`, `bit_length`, `capitalize`, `center`, `clear`, `conjugate`, `copy`, `count`, `decode`, `denominator`, `difference`, `difference_update`, `discard`, `encode`, `endswith`, `expandtabs`, `extend`, `find`, `format`, `fromhex`, `fromkeys`, `get`, `has_key`, `hex`, `imag`, `index`, `insert`, `intersection`, `intersection_update`, `isalnum`, `isalpha`, `isdecimal`, `isdigit`, `isdisjoint`, `is_integer`, `islower`, `isnumeric`, `isspace`, `issubset`, `issuperset`, `istitle`, `isupper`, `items`, `iteritems`, `iterkeys`, `itervalues`, `join`, `keys`, `ljust`, `lower`, `lstrip`, `numerator`, `partition`, `pop`, `popitem`, `real`, `remove`, `replace`, `reverse`, `rfind`, `rindex`, `rjust`, `rpartition`, `rsplit`, `rstrip`, `setdefault`, `sort`, `split`, `splitlines`, `startswith`, `strip`, `swapcase`, `symmetric_difference`, `symmetric_difference_update`, `title`, `translate`, `union`, `update`, `upper`, `values`, `viewitems`, `viewkeys`, `viewvalues`, `zfill`.

### Registering variables

You can create variables from the output of an Ansible task with the task keyword `register`. You can use registered variables in any later tasks in your play. For example:

```
- hosts: web_servers

  tasks:

     - name: Run a shell command and register its output as a variable
       ansible.builtin.shell: /usr/bin/foo
       register: foo_result
       ignore_errors: true

     - name: Run a shell command using output of the previous task
       ansible.builtin.shell: /usr/bin/bar
       when: foo_result.rc == 5
```

For more examples of using registered variables in conditions on later tasks, see [Conditionals](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#playbooks-conditionals). Registered variables may be simple variables, list variables,  dictionary variables, or complex nested data structures. The  documentation for each module includes a `RETURN` section describing the return values for that module. To see the values for a particular task, run your playbook with `-v`.

Registered variables are stored in memory. You cannot cache  registered variables for use in future playbook runs. Registered  variables are only valid on the host for the rest of the current  playbook run, including subsequent plays within the same playbook run.

Registered variables are host-level variables. When you register a  variable in a task with a loop, the registered variable contains a value for each item in the loop. The data structure placed in the variable  during the loop will contain a `results` attribute, that is a list of all responses from the module. For a more in-depth example of how this works, see the [Loops](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.html#playbooks-loops) section on using register with a loop.

Note

If a task fails or is skipped, Ansible still registers a variable  with a failure or skipped status, unless the task is skipped based on  tags. See [Tags](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tags) for information on adding and using tags.

### Referencing nested variables

Many registered variables (and [facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#vars-and-facts)) are nested YAML or JSON data structures. You cannot access values from these nested data structures with the simple `{{ foo }}` syntax. You must use either bracket notation or dot notation. For  example, to reference an IP address from your facts using the bracket  notation:

```
{{ ansible_facts["eth0"]["ipv4"]["address"] }}
```

To reference an IP address from your facts using the dot notation:

```
{{ ansible_facts.eth0.ipv4.address }}
```

### Transforming variables with Jinja2 filters

Jinja2 filters let you transform the value of a variable within a template expression. For example, the `capitalize` filter capitalizes any value passed to it; the `to_yaml` and `to_json` filters change the format of your variable values. Jinja2 includes many [built-in filters](https://jinja.palletsprojects.com/templates/#builtin-filters) and Ansible supplies many more filters. To find more examples of filters, see [Using filters to manipulate data](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#playbooks-filters).

### Where to set variables

You can define variables in a variety of places, such as in  inventory, in playbooks, in reusable files, in roles, and at the command line. Ansible loads every possible variable it finds, then chooses the  variable to apply based on [variable precedence rules](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#ansible-variable-precedence).

#### Defining variables in inventory

You can define different variables for each individual host, or set  shared variables for a group of hosts in your inventory. For example, if all machines in the `[Boston]` group use ‘boston.ntp.example.com’ as an NTP server, you can set a group variable. The [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#intro-inventory) page has details on setting [host variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#host-variables) and [group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#group-variables) in inventory.

#### Defining variables in a play

You can define variables directly in a playbook play:

```
- hosts: webservers
  vars:
    http_port: 80
```

When you define variables in a play, they are only visible to tasks executed in that play.

#### Defining variables in included files and roles

You can define variables in reusable variables files and/or in  reusable roles. When you define variables in reusable variable files,  the sensitive variables are separated from playbooks. This separation  enables you to store your playbooks in a source control software and  even share the playbooks, without the risk of exposing passwords or  other sensitive and personal data. For information about creating  reusable files and roles, see [Re-using Ansible artifacts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#playbooks-reuse).

This example shows how you can include variables defined in an external file:

```
---

- hosts: all
  remote_user: root
  vars:
    favcolor: blue
  vars_files:
    - /vars/external_vars.yml

  tasks:

  - name: This is just a placeholder
    ansible.builtin.command: /bin/echo foo
```

The contents of each variables file is a simple YAML dictionary. For example:

```
---
# in the above example, this would be vars/external_vars.yml
somevar: somevalue
password: magic
```

Note

You can keep per-host and per-group variables in similar files. To learn about organizing your variables, see [Organizing host and group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#splitting-out-vars).

#### Defining variables at runtime

You can define variables when you run your playbook by passing variables at the command line using the `--extra-vars` (or `-e`) argument. You can also request user input with a `vars_prompt` (see [Interactive input: prompts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html#playbooks-prompts)). When you pass variables at the command line, use a single quoted  string, that contains one or more variables, in one of the formats  below.

##### key=value format

Values passed in using the `key=value` syntax are interpreted as strings. Use the JSON format if you need to  pass non-string values such as Booleans, integers, floats, lists, and so on.

```
ansible-playbook release.yml --extra-vars "version=1.23.45 other_variable=foo"
```

##### JSON string format

```
ansible-playbook release.yml --extra-vars '{"version":"1.23.45","other_variable":"foo"}'
ansible-playbook arcade.yml --extra-vars '{"pacman":"mrs","ghosts":["inky","pinky","clyde","sue"]}'
```

When passing variables with `--extra-vars`, you must escape quotes and other special characters appropriately for  both your markup (for example, JSON), and for your shell:

```
ansible-playbook arcade.yml --extra-vars "{\"name\":\"Conan O\'Brien\"}"
ansible-playbook arcade.yml --extra-vars '{"name":"Conan O'\\\''Brien"}'
ansible-playbook script.yml --extra-vars "{\"dialog\":\"He said \\\"I just can\'t get enough of those single and double-quotes"\!"\\\"\"}"
```

If you have a lot of special characters, use a JSON or YAML file containing the variable definitions.

##### vars from a JSON or YAML file

```
ansible-playbook release.yml --extra-vars "@some_file.json"
```

### Variable precedence: Where should I put a variable?

You can set multiple variables with the same name in many different  places. When you do this, Ansible loads every possible variable it  finds, then chooses the variable to apply based on variable precedence.  In other words, the different variables will override each other in a  certain order.

Teams and projects that agree on guidelines for defining variables  (where to define certain types of variables) usually avoid variable  precedence concerns. We suggest that you define each variable in one  place: figure out where to define a variable, and keep it simple. For  examples, see [Tips on where to set variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#variable-examples).

Some behavioral parameters that you can set in variables you can also set in Ansible configuration, as command-line options, and using  playbook keywords. For example, you can define the user Ansible uses to  connect to remote devices as a variable with `ansible_user`, in a configuration file with `DEFAULT_REMOTE_USER`, as a command-line option with `-u`, and with the playbook keyword `remote_user`. If you define the same parameter in a variable and by another method,  the variable overrides the other setting. This approach allows  host-specific settings to override more general settings. For examples  and more details on the precedence of these various settings, see [Controlling how Ansible behaves: precedence rules](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html#general-precedence-rules).

#### Understanding variable precedence

Ansible does apply variable precedence, and you might have a use for  it. Here is the order of precedence from least to greatest (the last  listed variables override all other variables):

> 1. command line values (for example, `-u my_user`, these are not variables)
> 2. role defaults (defined in role/defaults/main.yml) [1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id14)
> 3. inventory file or script group vars [2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id15)
> 4. inventory group_vars/all [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
> 5. playbook group_vars/all [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
> 6. inventory group_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
> 7. playbook group_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
> 8. inventory file or script host vars [2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id15)
> 9. inventory host_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
> 10. playbook host_vars/* [3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id16)
> 11. host facts / cached set_facts [4](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id17)
> 12. play vars
> 13. play vars_prompt
> 14. play vars_files
> 15. role vars (defined in role/vars/main.yml)
> 16. block vars (only for tasks in block)
> 17. task vars (only for the task)
> 18. include_vars
> 19. set_facts / registered vars
> 20. role (and include_role) params
> 21. include params
> 22. extra vars (for example, `-e "user=my_user"`)(always win precedence)

In general, Ansible gives precedence to variables that were defined  more recently, more actively, and with more explicit scope. Variables in the defaults folder inside a role are easily overridden. Anything in  the vars directory of the role overrides previous versions of that  variable in the namespace. Host and/or inventory variables override role defaults, but explicit includes such as the vars directory or an `include_vars` task override inventory variables.

Ansible merges different variables set in inventory so that more specific settings override more generic settings. For example, `ansible_ssh_user` specified as a group_var is overridden by `ansible_user` specified as a host_var. For details about the precedence of variables set in inventory, see [How variables are merged](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#how-we-merge).

Footnotes

- [1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id4)

  Tasks in each role see their own role’s defaults. Tasks defined outside of a role see the last role’s defaults.

- 2([1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id5),[2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id10))

  Variables defined in inventory file or provided by dynamic inventory.

- 3([1](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id6),[2](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id7),[3](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id8),[4](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id9),[5](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id11),[6](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id12))

  Includes vars added by ‘vars plugins’ as well as host_vars and  group_vars which are added by the default vars plugin shipped with  Ansible.

- [4](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#id13)

  When created with set_facts’s cacheable option, variables have the high precedence in the play, but are the same as a host facts precedence when they come from the cache.

Note

Within any section, redefining a var overrides the previous instance. If multiple groups have the same variable, the last one loaded wins. If you define a variable twice in a play’s `vars:` section, the second one wins.

Note

The previous describes the default config `hash_behaviour=replace`, switch to `merge` to only partially overwrite.

#### Scoping variables

You can decide where to set a variable based on the scope you want that value to have. Ansible has three main scopes:

> - Global: this is set by config, environment variables and the command line
> - Play: each play and contained structures, vars entries (vars; vars_files; vars_prompt), role defaults and vars.
> - Host: variables directly associated to a host, like inventory, include_vars, facts or registered task outputs

Inside a template, you automatically have access to all variables  that are in scope for a host, plus any registered variables, facts, and  magic variables.

#### Tips on where to set variables

You should choose where to define a variable based on the kind of control you might want over values.

Set variables in inventory that deal with geography or behavior.  Since groups are frequently the entity that maps roles onto hosts, you  can often set variables on the group instead of defining them on a role. Remember: child groups override parent groups, and host variables  override group variables. See [Defining variables in inventory](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#define-variables-in-inventory) for details on setting host and group variables.

Set common defaults in a `group_vars/all` file. See [Organizing host and group variables](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#splitting-out-vars) for details on how to organize host and group variables in your  inventory. Group variables are generally placed alongside your inventory file, but they can also be returned by dynamic inventory (see [Working with dynamic inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_dynamic_inventory.html#intro-dynamic-inventory)) or defined in AWX or on [Red Hat Ansible Automation Platform](https://docs.ansible.com/ansible/latest/reference_appendices/tower.html#ansible-platform) from the UI or API:

```
---
# file: /etc/ansible/group_vars/all
# this is the site wide default
ntp_server: default-time.example.com
```

Set location-specific variables in `group_vars/my_location` files. All groups are children of the `all` group, so variables set here override those set in `group_vars/all`:

```
---
# file: /etc/ansible/group_vars/boston
ntp_server: boston-time.example.com
```

If one host used a different NTP server, you could set that in a host_vars file, which would override the group variable:

```
---
# file: /etc/ansible/host_vars/xyz.boston.example.com
ntp_server: override.example.com
```

Set defaults in roles to avoid undefined-variable errors. If you  share your roles, other users can rely on the reasonable defaults you  added in the `roles/x/defaults/main.yml` file, or they can easily override those values in inventory or at the command line. See [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles) for more info. For example:

```
---
# file: roles/x/defaults/main.yml
# if no other value is supplied in inventory or as a parameter, this value will be used
http_port: 80
```

Set variables in roles to ensure a value is used in that role, and is not overridden by inventory variables. If you are not sharing your role with others, you can define app-specific behaviors like ports this way, in `roles/x/vars/main.yml`. If you are sharing roles with others, putting variables here makes them harder to override, although they still can by passing a parameter to  the role or setting a variable with `-e`:

```
---
# file: roles/x/vars/main.yml
# this will absolutely be used in this role
http_port: 80
```

Pass variables as parameters when you call roles for maximum clarity, flexibility, and visibility. This approach overrides any defaults that  exist for a role. For example:

```
roles:
   - role: apache
     vars:
        http_port: 8080
```

When you read this playbook it is clear that you have chosen to set a variable or override a default. You can also pass multiple values,  which allows you to run the same role multiple times. See [Running a role multiple times in one play](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#run-role-twice) for more details. For example:

```
roles:
   - role: app_user
     vars:
        myname: Ian
   - role: app_user
     vars:
       myname: Terry
   - role: app_user
     vars:
       myname: Graham
   - role: app_user
     vars:
       myname: John
```

Variables set in one role are available to later roles. You can set variables in a `roles/common_settings/vars/main.yml` file and use them in other roles and elsewhere in your playbook:

```
roles:
   - role: common_settings
   - role: something
     vars:
       foo: 12
   - role: something_else
```

Note

There are some protections in place to avoid the need to namespace  variables. In this example, variables defined in ‘common_settings’ are available to ‘something’ and ‘something_else’ tasks, but tasks in ‘something’ have  foo set at 12, even if ‘common_settings’ sets foo to 20.

Instead of worrying about variable precedence, we encourage you to  think about how easily or how often you want to override a variable when deciding where to set it. If you are not sure what other variables are  defined, and you need a particular value, use `--extra-vars` (`-e`) to override all other variables.

### Using advanced variable syntax

For information about advanced YAML syntax used to declare variables  and have more control over the data placed in YAML files used by  Ansible, see [Advanced playbook syntax](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_advanced_syntax.html#playbooks-advanced-syntax).

## Discovering variables: facts and magic variables

With Ansible you can retrieve or discover certain variables  containing information about your remote systems or about Ansible  itself. Variables related to remote systems are called facts. With  facts, you can use the behavior or state of one system as configuration  on other systems. For example, you can use the IP address of one system  as a configuration value on another system. Variables related to Ansible are called magic variables.

### [Ansible facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#ansible-facts)

Ansible facts are data related to your remote systems, including  operating systems, IP addresses, attached filesystems, and more. You can access this data in the `ansible_facts` variable. By default, you can also access some Ansible facts as top-level variables with the `ansible_` prefix. You can disable this behavior using the [INJECT_FACTS_AS_VARS](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#inject-facts-as-vars) setting. To see all available facts, add this task to a play:

```
- name: Print all available facts
  ansible.builtin.debug:
    var: ansible_facts
```

To see the ‘raw’ information as gathered, run this command at the command line:

```
ansible <hostname> -m ansible.builtin.setup
```

Facts include a large amount of variable data, which may look like this:

```
{
    "ansible_all_ipv4_addresses": [
        "REDACTED IP ADDRESS"
    ],
    "ansible_all_ipv6_addresses": [
        "REDACTED IPV6 ADDRESS"
    ],
    "ansible_apparmor": {
        "status": "disabled"
    },
    "ansible_architecture": "x86_64",
    "ansible_bios_date": "11/28/2013",
    "ansible_bios_version": "4.1.5",
    "ansible_cmdline": {
        "BOOT_IMAGE": "/boot/vmlinuz-3.10.0-862.14.4.el7.x86_64",
        "console": "ttyS0,115200",
        "no_timer_check": true,
        "nofb": true,
        "nomodeset": true,
        "ro": true,
        "root": "LABEL=cloudimg-rootfs",
        "vga": "normal"
    },
    "ansible_date_time": {
        "date": "2018-10-25",
        "day": "25",
        "epoch": "1540469324",
        "hour": "12",
        "iso8601": "2018-10-25T12:08:44Z",
        "iso8601_basic": "20181025T120844109754",
        "iso8601_basic_short": "20181025T120844",
        "iso8601_micro": "2018-10-25T12:08:44.109968Z",
        "minute": "08",
        "month": "10",
        "second": "44",
        "time": "12:08:44",
        "tz": "UTC",
        "tz_offset": "+0000",
        "weekday": "Thursday",
        "weekday_number": "4",
        "weeknumber": "43",
        "year": "2018"
    },
    "ansible_default_ipv4": {
        "address": "REDACTED",
        "alias": "eth0",
        "broadcast": "REDACTED",
        "gateway": "REDACTED",
        "interface": "eth0",
        "macaddress": "REDACTED",
        "mtu": 1500,
        "netmask": "255.255.255.0",
        "network": "REDACTED",
        "type": "ether"
    },
    "ansible_default_ipv6": {},
    "ansible_device_links": {
        "ids": {},
        "labels": {
            "xvda1": [
                "cloudimg-rootfs"
            ],
            "xvdd": [
                "config-2"
            ]
        },
        "masters": {},
        "uuids": {
            "xvda1": [
                "cac81d61-d0f8-4b47-84aa-b48798239164"
            ],
            "xvdd": [
                "2018-10-25-12-05-57-00"
            ]
        }
    },
    "ansible_devices": {
        "xvda": {
            "holders": [],
            "host": "",
            "links": {
                "ids": [],
                "labels": [],
                "masters": [],
                "uuids": []
            },
            "model": null,
            "partitions": {
                "xvda1": {
                    "holders": [],
                    "links": {
                        "ids": [],
                        "labels": [
                            "cloudimg-rootfs"
                        ],
                        "masters": [],
                        "uuids": [
                            "cac81d61-d0f8-4b47-84aa-b48798239164"
                        ]
                    },
                    "sectors": "83883999",
                    "sectorsize": 512,
                    "size": "40.00 GB",
                    "start": "2048",
                    "uuid": "cac81d61-d0f8-4b47-84aa-b48798239164"
                }
            },
            "removable": "0",
            "rotational": "0",
            "sas_address": null,
            "sas_device_handle": null,
            "scheduler_mode": "deadline",
            "sectors": "83886080",
            "sectorsize": "512",
            "size": "40.00 GB",
            "support_discard": "0",
            "vendor": null,
            "virtual": 1
        },
        "xvdd": {
            "holders": [],
            "host": "",
            "links": {
                "ids": [],
                "labels": [
                    "config-2"
                ],
                "masters": [],
                "uuids": [
                    "2018-10-25-12-05-57-00"
                ]
            },
            "model": null,
            "partitions": {},
            "removable": "0",
            "rotational": "0",
            "sas_address": null,
            "sas_device_handle": null,
            "scheduler_mode": "deadline",
            "sectors": "131072",
            "sectorsize": "512",
            "size": "64.00 MB",
            "support_discard": "0",
            "vendor": null,
            "virtual": 1
        },
        "xvde": {
            "holders": [],
            "host": "",
            "links": {
                "ids": [],
                "labels": [],
                "masters": [],
                "uuids": []
            },
            "model": null,
            "partitions": {
                "xvde1": {
                    "holders": [],
                    "links": {
                        "ids": [],
                        "labels": [],
                        "masters": [],
                        "uuids": []
                    },
                    "sectors": "167770112",
                    "sectorsize": 512,
                    "size": "80.00 GB",
                    "start": "2048",
                    "uuid": null
                }
            },
            "removable": "0",
            "rotational": "0",
            "sas_address": null,
            "sas_device_handle": null,
            "scheduler_mode": "deadline",
            "sectors": "167772160",
            "sectorsize": "512",
            "size": "80.00 GB",
            "support_discard": "0",
            "vendor": null,
            "virtual": 1
        }
    },
    "ansible_distribution": "CentOS",
    "ansible_distribution_file_parsed": true,
    "ansible_distribution_file_path": "/etc/redhat-release",
    "ansible_distribution_file_variety": "RedHat",
    "ansible_distribution_major_version": "7",
    "ansible_distribution_release": "Core",
    "ansible_distribution_version": "7.5.1804",
    "ansible_dns": {
        "nameservers": [
            "127.0.0.1"
        ]
    },
    "ansible_domain": "",
    "ansible_effective_group_id": 1000,
    "ansible_effective_user_id": 1000,
    "ansible_env": {
        "HOME": "/home/zuul",
        "LANG": "en_US.UTF-8",
        "LESSOPEN": "||/usr/bin/lesspipe.sh %s",
        "LOGNAME": "zuul",
        "MAIL": "/var/mail/zuul",
        "PATH": "/usr/local/bin:/usr/bin",
        "PWD": "/home/zuul",
        "SELINUX_LEVEL_REQUESTED": "",
        "SELINUX_ROLE_REQUESTED": "",
        "SELINUX_USE_CURRENT_RANGE": "",
        "SHELL": "/bin/bash",
        "SHLVL": "2",
        "SSH_CLIENT": "REDACTED 55672 22",
        "SSH_CONNECTION": "REDACTED 55672 REDACTED 22",
        "USER": "zuul",
        "XDG_RUNTIME_DIR": "/run/user/1000",
        "XDG_SESSION_ID": "1",
        "_": "/usr/bin/python2"
    },
    "ansible_eth0": {
        "active": true,
        "device": "eth0",
        "ipv4": {
            "address": "REDACTED",
            "broadcast": "REDACTED",
            "netmask": "255.255.255.0",
            "network": "REDACTED"
        },
        "ipv6": [
            {
                "address": "REDACTED",
                "prefix": "64",
                "scope": "link"
            }
        ],
        "macaddress": "REDACTED",
        "module": "xen_netfront",
        "mtu": 1500,
        "pciid": "vif-0",
        "promisc": false,
        "type": "ether"
    },
    "ansible_eth1": {
        "active": true,
        "device": "eth1",
        "ipv4": {
            "address": "REDACTED",
            "broadcast": "REDACTED",
            "netmask": "255.255.224.0",
            "network": "REDACTED"
        },
        "ipv6": [
            {
                "address": "REDACTED",
                "prefix": "64",
                "scope": "link"
            }
        ],
        "macaddress": "REDACTED",
        "module": "xen_netfront",
        "mtu": 1500,
        "pciid": "vif-1",
        "promisc": false,
        "type": "ether"
    },
    "ansible_fips": false,
    "ansible_form_factor": "Other",
    "ansible_fqdn": "centos-7-rax-dfw-0003427354",
    "ansible_hostname": "centos-7-rax-dfw-0003427354",
    "ansible_interfaces": [
        "lo",
        "eth1",
        "eth0"
    ],
    "ansible_is_chroot": false,
    "ansible_kernel": "3.10.0-862.14.4.el7.x86_64",
    "ansible_lo": {
        "active": true,
        "device": "lo",
        "ipv4": {
            "address": "127.0.0.1",
            "broadcast": "host",
            "netmask": "255.0.0.0",
            "network": "127.0.0.0"
        },
        "ipv6": [
            {
                "address": "::1",
                "prefix": "128",
                "scope": "host"
            }
        ],
        "mtu": 65536,
        "promisc": false,
        "type": "loopback"
    },
    "ansible_local": {},
    "ansible_lsb": {
        "codename": "Core",
        "description": "CentOS Linux release 7.5.1804 (Core)",
        "id": "CentOS",
        "major_release": "7",
        "release": "7.5.1804"
    },
    "ansible_machine": "x86_64",
    "ansible_machine_id": "2db133253c984c82aef2fafcce6f2bed",
    "ansible_memfree_mb": 7709,
    "ansible_memory_mb": {
        "nocache": {
            "free": 7804,
            "used": 173
        },
        "real": {
            "free": 7709,
            "total": 7977,
            "used": 268
        },
        "swap": {
            "cached": 0,
            "free": 0,
            "total": 0,
            "used": 0
        }
    },
    "ansible_memtotal_mb": 7977,
    "ansible_mounts": [
        {
            "block_available": 7220998,
            "block_size": 4096,
            "block_total": 9817227,
            "block_used": 2596229,
            "device": "/dev/xvda1",
            "fstype": "ext4",
            "inode_available": 10052341,
            "inode_total": 10419200,
            "inode_used": 366859,
            "mount": "/",
            "options": "rw,seclabel,relatime,data=ordered",
            "size_available": 29577207808,
            "size_total": 40211361792,
            "uuid": "cac81d61-d0f8-4b47-84aa-b48798239164"
        },
        {
            "block_available": 0,
            "block_size": 2048,
            "block_total": 252,
            "block_used": 252,
            "device": "/dev/xvdd",
            "fstype": "iso9660",
            "inode_available": 0,
            "inode_total": 0,
            "inode_used": 0,
            "mount": "/mnt/config",
            "options": "ro,relatime,mode=0700",
            "size_available": 0,
            "size_total": 516096,
            "uuid": "2018-10-25-12-05-57-00"
        }
    ],
    "ansible_nodename": "centos-7-rax-dfw-0003427354",
    "ansible_os_family": "RedHat",
    "ansible_pkg_mgr": "yum",
    "ansible_processor": [
        "0",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "1",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "2",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "3",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "4",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "5",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "6",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz",
        "7",
        "GenuineIntel",
        "Intel(R) Xeon(R) CPU E5-2670 0 @ 2.60GHz"
    ],
    "ansible_processor_cores": 8,
    "ansible_processor_count": 8,
    "ansible_processor_nproc": 8,
    "ansible_processor_threads_per_core": 1,
    "ansible_processor_vcpus": 8,
    "ansible_product_name": "HVM domU",
    "ansible_product_serial": "REDACTED",
    "ansible_product_uuid": "REDACTED",
    "ansible_product_version": "4.1.5",
    "ansible_python": {
        "executable": "/usr/bin/python2",
        "has_sslcontext": true,
        "type": "CPython",
        "version": {
            "major": 2,
            "micro": 5,
            "minor": 7,
            "releaselevel": "final",
            "serial": 0
        },
        "version_info": [
            2,
            7,
            5,
            "final",
            0
        ]
    },
    "ansible_python_version": "2.7.5",
    "ansible_real_group_id": 1000,
    "ansible_real_user_id": 1000,
    "ansible_selinux": {
        "config_mode": "enforcing",
        "mode": "enforcing",
        "policyvers": 31,
        "status": "enabled",
        "type": "targeted"
    },
    "ansible_selinux_python_present": true,
    "ansible_service_mgr": "systemd",
    "ansible_ssh_host_key_ecdsa_public": "REDACTED KEY VALUE",
    "ansible_ssh_host_key_ed25519_public": "REDACTED KEY VALUE",
    "ansible_ssh_host_key_rsa_public": "REDACTED KEY VALUE",
    "ansible_swapfree_mb": 0,
    "ansible_swaptotal_mb": 0,
    "ansible_system": "Linux",
    "ansible_system_capabilities": [
        ""
    ],
    "ansible_system_capabilities_enforced": "True",
    "ansible_system_vendor": "Xen",
    "ansible_uptime_seconds": 151,
    "ansible_user_dir": "/home/zuul",
    "ansible_user_gecos": "",
    "ansible_user_gid": 1000,
    "ansible_user_id": "zuul",
    "ansible_user_shell": "/bin/bash",
    "ansible_user_uid": 1000,
    "ansible_userspace_architecture": "x86_64",
    "ansible_userspace_bits": "64",
    "ansible_virtualization_role": "guest",
    "ansible_virtualization_type": "xen",
    "gather_subset": [
        "all"
    ],
    "module_setup": true
}
```

You can reference the model of the first disk in the facts shown above in a template or playbook as:

```
{{ ansible_facts['devices']['xvda']['model'] }}
```

To reference the system hostname:

```
{{ ansible_facts['nodename'] }}
```

You can use facts in conditionals (see [Conditionals](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#playbooks-conditionals)) and also in templates. You can also use facts to create dynamic groups of hosts that match particular criteria, see the [group_by module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_by_module.html#group-by-module) documentation for details.

Note

Because `ansible_date_time` is created and cached when Ansible gathers facts before each playbook  run, it can get stale with long-running playbooks. If your playbook  takes a long time to run, use the `pipe` filter (for example, `lookup('pipe', 'date +%Y-%m-%d.%H:%M:%S')`) or [now()](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_templating_now.html#templating-now) with a Jinja 2 template instead of `ansible_date_time`.

#### Package requirements for fact gathering](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#package-requirements-for-fact-gathering)

On some distros, you may see missing fact values or facts set to  default values because the packages that support gathering those facts  are not installed by default. You can install the necessary packages on  your remote hosts using the OS package manager. Known dependencies  include:

- Linux Network fact gathering -  Depends on  the `ip` binary, commonly included in the `iproute2` package.

#### Caching facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id5)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#caching-facts)

Like registered variables, facts are stored in memory by default.  However, unlike registered variables, facts can be gathered  independently and cached for repeated use. With cached facts, you can  refer to facts from one system when configuring a second system, even if Ansible executes the current play on the second system first. For  example:

```
{{ hostvars['asdf.example.com']['ansible_facts']['os_family'] }}
```

Caching is controlled by the cache plugins. By default, Ansible uses  the memory cache plugin, which stores facts in memory for the duration  of the current playbook run. To retain Ansible facts for repeated use,  select a different cache plugin. See [Cache plugins](https://docs.ansible.com/ansible/latest/plugins/cache.html#cache-plugins) for details.

Fact caching can improve performance. If you manage thousands of  hosts, you can configure fact caching to run nightly, then manage  configuration on a smaller set of servers periodically throughout the  day. With cached facts, you have access to variables and information  about all hosts even when you are only managing a small number of  servers.

#### Disabling facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id6)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#disabling-facts)

By default, Ansible gathers facts at the beginning of each play. If  you do not need to gather facts (for example, if you know everything  about your systems centrally), you can turn off fact gathering at the  play level to improve scalability. Disabling facts may particularly  improve performance in push mode with very large numbers of systems, or  if you are using Ansible on experimental platforms. To disable fact  gathering:

```
- hosts: whatever
  gather_facts: false
```

#### [Adding custom facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id7)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#adding-custom-facts)

The setup module in Ansible automatically discovers a standard set of facts about each host. If you want to add custom values to your facts,  you can write a custom facts module, set temporary facts with a `ansible.builtin.set_fact` task, or provide permanent custom facts using the facts.d directory.

##### facts.d or local facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id8)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#facts-d-or-local-facts)

New in version 1.3.

You can add static custom facts by adding static files to facts.d, or add dynamic facts by adding executable scripts to facts.d. For example, you can add a list of all users on a host to your facts by creating and running a script in facts.d.

To use facts.d, create an `/etc/ansible/facts.d` directory on the remote host or hosts. If you prefer a different directory, create it and specify it using the `fact_path` play keyword. Add files to the directory to supply your custom facts. All file names must end with `.fact`. The files can be JSON, INI, or executable files returning JSON.

To add static facts, simply add a file with the `.fact` extension. For example, create `/etc/ansible/facts.d/preferences.fact` with this content:

```
[general]
asdf=1
bar=2
```

Note

Make sure the file is not executable as this will break the `ansible.builtin.setup` module.

The next time fact gathering runs, your facts will include a hash variable fact named `general` with `asdf` and `bar` as members. To validate this, run the following:

```
ansible <hostname> -m ansible.builtin.setup -a "filter=ansible_local"
```

And you will see your custom fact added:

```
{
    "ansible_local": {
        "preferences": {
            "general": {
                "asdf" : "1",
                "bar"  : "2"
            }
        }
    }
}
```

The ansible_local namespace separates custom facts created by facts.d from system facts or variables defined elsewhere in the playbook, so  variables will not override each other. You can access this custom fact  in a template or playbook as:

```
{{ ansible_local['preferences']['general']['asdf'] }}
```

Note

The key part in the key=value pairs will be converted into lowercase  inside the ansible_local variable. Using the example above, if the ini  file contained `XYZ=3` in the `[general]` section, then you should expect to access it as: `{{ ansible_local['preferences']['general']['xyz'] }}` and not `{{ ansible_local['preferences']['general']['XYZ'] }}`. This is because Ansible uses Python’s [ConfigParser](https://docs.python.org/3/library/configparser.html) which passes all option names through the [optionxform](https://docs.python.org/3/library/configparser.html#ConfigParser.RawConfigParser.optionxform) method and this method’s default implementation converts option names to lower case.

You can also use facts.d to execute a script on the remote host,  generating dynamic custom facts to the ansible_local namespace. For  example, you can generate a list of all users that exist on a remote  host as a fact about that host. To generate dynamic custom facts using  facts.d:

> 1. Write and test a script to generate the JSON data you want.
> 2. Save the script in your facts.d directory.
> 3. Make sure your script has the `.fact` file extension.
> 4. Make sure your script is executable by the Ansible connection user.
> 5. Gather facts to execute the script and add the JSON output to ansible_local.

By default, fact gathering runs once at the beginning of each play.  If you create a custom fact using facts.d in a playbook, it will be  available in the next play that gathers facts. If you want to use it in  the same play where you created it, you must explicitly re-run the setup module. For example:

```
- hosts: webservers
  tasks:

    - name: Create directory for ansible custom facts
      ansible.builtin.file:
        state: directory
        recurse: true
        path: /etc/ansible/facts.d

    - name: Install custom ipmi fact
      ansible.builtin.copy:
        src: ipmi.fact
        dest: /etc/ansible/facts.d

    - name: Re-read facts after adding custom fact
      ansible.builtin.setup:
        filter: ansible_local
```

If you use this pattern frequently, a custom facts module would be more efficient than facts.d.

### [[Information about Ansible: magic variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id9)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#information-about-ansible-magic-variables)

You can access information about Ansible operations, including the  python version being used, the hosts and groups in inventory, and the  directories for playbooks and roles, using “magic” variables. Like  connection variables, magic variables are [Special Variables](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#special-variables). Magic variable names are reserved - do not set variables with these names. The variable `environment` is also reserved.

The most commonly used magic variables are `hostvars`, `groups`, `group_names`, and `inventory_hostname`. With `hostvars`, you can access variables defined for any host in the play, at any point in a playbook. You can access Ansible facts using the `hostvars` variable too, but only after you have gathered (or cached) facts.  Note that variables defined at play objects are not defined for specific  hosts and therefore are not mapped to hostvars.

If you want to configure your database server using the value of a  ‘fact’ from another node, or the value of an inventory variable assigned to another node, you can use `hostvars` in a template or on an action line:

```
{{ hostvars['test.example.com']['ansible_facts']['distribution'] }}
```

With `groups`, a list of all the groups (and hosts) in the inventory, you can enumerate all hosts within a group. For example:

```
{% for host in groups['app_servers'] %}
   # something that applies to all app servers.
{% endfor %}
```

You can use `groups` and `hostvars` together to find all the IP addresses in a group.

```
{% for host in groups['app_servers'] %}
   {{ hostvars[host]['ansible_facts']['eth0']['ipv4']['address'] }}
{% endfor %}
```

You can use this approach to point a frontend proxy server to all the hosts in your app servers group, to set up the correct firewall rules  between servers, and so on. You must either cache facts or gather facts  for those hosts before the task that fills out the template.

With `group_names`, a list (array) of all the groups the current host is in, you can create templated files that vary based on the group membership (or role) of  the host:

```
{% if 'webserver' in group_names %}
   # some part of a configuration file that only applies to webservers
{% endif %}
```

You can use the magic variable `inventory_hostname`, the name of the host as configured in your inventory, as an alternative to `ansible_hostname` when fact-gathering is disabled. If you have a long FQDN, you can use `inventory_hostname_short`, which contains the part up to the first period, without the rest of the domain.

Other useful magic variables refer to the current play or playbook.  These vars may be useful for filling out templates with multiple  hostnames or for injecting the list into the rules for a load balancer.

`ansible_play_hosts` is the list of all hosts still active in the current play.

`ansible_play_batch` is a list of hostnames that are in scope for the current ‘batch’ of the play.

The batch size is defined by `serial`, when not set it is equivalent to the whole play (making it the same as `ansible_play_hosts`).

`ansible_playbook_python` is the path to the python executable used to invoke the Ansible command line tool.

`inventory_dir` is the pathname of the directory holding Ansible’s inventory host file.

`inventory_file` is the pathname and the filename pointing to the Ansible’s inventory host file.

`playbook_dir` contains the playbook base directory.

`role_path` contains the current role’s pathname and only works inside a role.

`ansible_check_mode` is a boolean, set to `True` if you run Ansible with `--check`.

#### [Ansible version](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#id10)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#ansible-version)

New in version 1.8.

To adapt playbook behavior to different versions of Ansible, you can use the variable `ansible_version`, which has the following structure:

```
{
    "ansible_version": {
        "full": "2.10.1",
        "major": 2,
        "minor": 10,
        "revision": 1,
        "string": "2.10.1"
    }
}
```

## Playbook Example: Continuous Delivery and Rolling Upgrades

### [What is continuous delivery?](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id1)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#what-is-continuous-delivery)

Continuous delivery (CD) means frequently delivering updates to your software application.

The idea is that by updating more often, you do not have to wait for a specific timed period, and your organization gets better at the process of responding to change.

Some Ansible users are deploying updates to their end users on an  hourly or even more frequent basis – sometimes every time there is an approved code change.  To achieve this, you need tools to be able to quickly apply those updates in a zero-downtime way.

This document describes in detail how to achieve this goal, using one of Ansible’s most complete example playbooks as a template: lamp_haproxy. This example uses a lot of Ansible features: roles, templates, and group variables, and it also comes with an orchestration playbook that can do zero-downtime rolling upgrades of the web application stack.

Note

[Click here for the latest playbooks for this example](https://github.com/ansible/ansible-examples/tree/master/lamp_haproxy).

The playbooks deploy Apache, PHP, MySQL, Nagios, and HAProxy to a CentOS-based set of servers.

We’re not going to cover how to run these playbooks here. Read the included README in the github project along with the example for that information. Instead, we’re going to take a close look at every part of the playbook and describe what it does.

### Site deployment](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id2)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#site-deployment)

Let’s start with `site.yml`. This is our site-wide deployment playbook. It can be used to initially deploy the site, as well as push updates to all of the servers:

```
---
# This playbook deploys the whole application stack in this site.

# Apply common configuration to all hosts
- hosts: all

  roles:
  - common

# Configure and deploy database servers.
- hosts: dbservers

  roles:
  - db

# Configure and deploy the web servers. Note that we include two roles
# here, the 'base-apache' role which simply sets up Apache, and 'web'
# which includes our example web application.

- hosts: webservers

  roles:
  - base-apache
  - web

# Configure and deploy the load balancer(s).
- hosts: lbservers

  roles:
  - haproxy

# Configure and deploy the Nagios monitoring node(s).
- hosts: monitoring

  roles:
  - base-apache
  - nagios
```

Note

If you’re not familiar with terms like playbooks and plays, you should review [Working with playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks.html#working-with-playbooks).

In this playbook we have 5 plays. The first one targets `all` hosts and applies the `common` role to all of the hosts. This is for site-wide things like yum repository configuration, firewall configuration, and anything else that needs to apply to all of the  servers.

The next four plays run against specific host groups and apply specific roles to those servers. Along with the roles for Nagios monitoring, the database, and the web application, we’ve implemented a `base-apache` role that installs and configures a basic Apache setup. This is used by both the sample web application and the Nagios hosts.

### [Reusable content: roles](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#reusable-content-roles)

By now you should have a bit of understanding about roles and how they work in Ansible. Roles are a way to organize content: tasks, handlers, templates, and files, into reusable components.

This example has six roles: `common`, `base-apache`, `db`, `haproxy`, `nagios`, and `web`. How you organize your roles is up to you and your application, but most sites will have one or more common roles that are applied to all systems, and then a series of application-specific roles that install and configure particular parts of the site.

Roles can have variables and dependencies, and you can pass in parameters to roles to modify their behavior. You can read more about roles in the [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles) section.

### [Configuration: group variables](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#configuration-group-variables)

Group variables are variables that are applied to groups of servers. They can be used in templates and in playbooks to customize behavior and to provide easily-changed settings and parameters. They are stored in a directory called `group_vars` in the same location as your inventory. Here is lamp_haproxy’s `group_vars/all` file. As you might expect, these variables are applied to all of the machines in your inventory:

```
---
httpd_port: 80
ntpserver: 192.0.2.23
```

This is a YAML file, and you can create lists and dictionaries for more complex variable structures. In this case, we are just setting two variables, one for the port for the web server, and one for the NTP server that our machines should use for time synchronization.

Here’s another group variables file. This is `group_vars/dbservers` which applies to the hosts in the `dbservers` group:

```
---
mysqlservice: mysqld
mysql_port: 3306
dbuser: root
dbname: foodb
upassword: usersecret
```

If you look in the example, there are group variables for the `webservers` group and the `lbservers` group, similarly.

These variables are used in a variety of places. You can use them in playbooks, like this, in `roles/db/tasks/main.yml`:

```
- name: Create Application Database
  mysql_db:
    name: "{{ dbname }}"
    state: present

- name: Create Application DB User
  mysql_user:
    name: "{{ dbuser }}"
    password: "{{ upassword }}"
    priv: "*.*:ALL"
    host: '%'
    state: present
```

You can also use these variables in templates, like this, in `roles/common/templates/ntp.conf.j2`:

```
driftfile /var/lib/ntp/drift

restrict 127.0.0.1
restrict -6 ::1

server {{ ntpserver }}

includefile /etc/ntp/crypto/pw

keys /etc/ntp/keys
```

You can see that the variable substitution syntax of {{ and }} is the same for both templates and variables. The syntax inside the curly braces is Jinja2, and you can do all sorts of operations and apply different filters to the data inside. In templates, you can also use for loops and if statements to handle more complex situations, like this, in `roles/common/templates/iptables.j2`:

```
{% if inventory_hostname in groups['dbservers'] %}
-A INPUT -p tcp  --dport 3306 -j  ACCEPT
{% endif %}
```

This is testing to see if the inventory name of the machine we’re currently operating on (`inventory_hostname`) exists in the inventory group `dbservers`. If so, that machine will get an iptables ACCEPT line for port 3306.

Here’s another example, from the same template:

```
{% for host in groups['monitoring'] %}
-A INPUT -p tcp -s {{ hostvars[host].ansible_default_ipv4.address }} --dport 5666 -j ACCEPT
{% endfor %}
```

This loops over all of the hosts in the group called `monitoring`, and adds an ACCEPT line for each monitoring hosts’ default IPv4 address to the current machine’s  iptables configuration, so that Nagios can monitor those hosts.

You can learn a lot more about Jinja2 and its capabilities [here](https://jinja.palletsprojects.com/), and you can read more about Ansible variables in general in the [Using Variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#playbooks-variables) section.

### [The rolling upgrade](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id5)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#the-rolling-upgrade)

Now you have a fully-deployed site with web servers, a load balancer, and monitoring. How do you update it? This is where Ansible’s orchestration features come into play. While some applications use the  term ‘orchestration’ to mean basic ordering or command-blasting, Ansible refers to orchestration as ‘conducting machines like an orchestra’, and  has a pretty sophisticated engine for it.

Ansible has the capability to do operations on multi-tier  applications in a coordinated way, making it easy to orchestrate a  sophisticated zero-downtime rolling upgrade of our web application. This is implemented in a separate playbook, called `rolling_update.yml`.

Looking at the playbook, you can see it is made up of two plays. The first play is very simple and looks like this:

```
- hosts: monitoring
  tasks: []
```

What’s going on here, and why are there no tasks? You might know that Ansible gathers “facts” from the servers before operating upon them.  These facts are useful for all sorts of things: networking information,  OS/distribution versions, and so on. In our case, we need to know  something about all of the monitoring servers in our environment before  we perform the update, so this simple play forces a fact-gathering step  on our monitoring servers. You will see this pattern sometimes, and it’s a useful trick to know.

The next part is the update play. The first part looks like this:

```
- hosts: webservers
  user: root
  serial: 1
```

This is just a normal play definition, operating on the `webservers` group. The `serial` keyword tells Ansible how many servers to operate on at once. If it’s  not specified, Ansible will parallelize these operations up to the  default “forks” limit specified in the configuration file. But for a  zero-downtime rolling upgrade, you may not want to operate on that many  hosts at once. If you had just a handful of webservers, you may want to  set `serial` to 1, for one host at a time. If you have 100, maybe you could set `serial` to 10, for ten at a time.

Here is the next part of the update play:

```
pre_tasks:
- name: disable nagios alerts for this host webserver service
  nagios:
    action: disable_alerts
    host: "{{ inventory_hostname }}"
    services: webserver
  delegate_to: "{{ item }}"
  loop: "{{ groups.monitoring }}"

- name: disable the server in haproxy
  shell: echo "disable server myapplb/{{ inventory_hostname }}" | socat stdio /var/lib/haproxy/stats
  delegate_to: "{{ item }}"
  loop: "{{ groups.lbservers }}"
```

Note

- The `serial` keyword forces the play to be executed in ‘batches’. Each batch counts  as a full play with a subselection of hosts. This has some consequences on play behavior. For example, if all hosts  in a batch fails, the play fails, which in turn fails the entire run.  You should consider this when combining with `max_fail_percentage`.

The `pre_tasks` keyword just lets you list tasks to run before the roles are called.  This will make more sense in a minute. If you look at the names of these tasks, you can see that we are disabling Nagios alerts and then  removing the webserver that we are currently updating from the HAProxy  load balancing pool.

The `delegate_to` and `loop` arguments, used together, cause Ansible to loop over each monitoring  server and load balancer, and perform that operation (delegate that  operation) on the monitoring or load balancing server, “on behalf” of  the webserver. In programming terms, the outer loop is the list of web  servers, and the inner loop is the list of monitoring servers.

Note that the HAProxy step looks a little complicated.  We’re using  HAProxy in this example because it’s freely available, though if you  have (for instance) an F5 or Netscaler in your infrastructure (or maybe  you have an AWS Elastic IP setup?), you can use Ansible modules  to  communicate with them instead.  You might also wish to use other  monitoring modules instead of nagios, but this just shows the main goal  of the ‘pre tasks’ section – take the server out of monitoring, and take it out of rotation.

The next step simply re-applies the proper roles to the web servers.  This will cause any configuration management declarations in `web` and `base-apache` roles to be applied to the web servers, including an update of the web  application code itself. We don’t have to do it this way–we could  instead just purely update the web application, but this is a good  example of how roles can be used to reuse tasks:

```
roles:
- common
- base-apache
- web
```

Finally, in the `post_tasks` section, we reverse the changes to the Nagios configuration and put the web server back in the load balancing pool:

```
post_tasks:
- name: Enable the server in haproxy
  shell: echo "enable server myapplb/{{ inventory_hostname }}" | socat stdio /var/lib/haproxy/stats
  delegate_to: "{{ item }}"
  loop: "{{ groups.lbservers }}"

- name: re-enable nagios alerts
  nagios:
    action: enable_alerts
    host: "{{ inventory_hostname }}"
    services: webserver
  delegate_to: "{{ item }}"
  loop: "{{ groups.monitoring }}"
```

Again, if you were using a Netscaler or F5 or Elastic Load Balancer,  you would just substitute in the appropriate modules instead.

### [Managing other load balancers](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id6)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#managing-other-load-balancers)

In this example, we use the simple HAProxy load balancer to front-end the web servers. It’s easy to configure and easy to manage. As we have  mentioned, Ansible has support for a variety of other load balancers  like Citrix NetScaler, F5 BigIP, Amazon Elastic Load Balancers, and  more. See the [Working With Modules](https://docs.ansible.com/ansible/6/user_guide/modules.html#working-with-modules) documentation for more information.

For other load balancers, you may need to send shell commands to them (like we do for HAProxy above), or call an API, if your load balancer  exposes one. For the load balancers for which Ansible has modules, you  may want to run them as a `local_action` if they contact an API. You can read more about local actions in the [Controlling where tasks run: delegation and local actions](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#playbooks-delegation) section.  Should you develop anything interesting for some hardware  where there is not a module, it might make for a good contribution!

### [Continuous delivery end-to-end](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#id7)[](https://docs.ansible.com/ansible/latest/playbook_guide/guide_rolling_upgrade.html#continuous-delivery-end-to-end)

Now that you have an automated way to deploy updates to your  application, how do you tie it all together? A lot of organizations use a continuous integration tool like [Jenkins](https://jenkins.io/) or [Atlassian Bamboo](https://www.atlassian.com/software/bamboo) to tie the development, test, release, and deploy steps together. You may also want to use a tool like [Gerrit](https://www.gerritcodereview.com/) to add a code review step to commits to either the application code itself, or to your Ansible playbooks, or both.

Depending on your environment, you might be deploying continuously to a test environment, running an integration test battery against that  environment, and then deploying automatically into production.  Or you  could keep it simple and just use the rolling-update for on-demand  deployment into test or production specifically.  This is all up to you.

For integration with Continuous Integration systems, you can easily trigger playbook runs using the `ansible-playbook` command line tool, or, if you’re using AWX, the `tower-cli` command or the built-in REST API.  (The tower-cli command ‘joblaunch’  will spawn a remote job over the REST API and is pretty slick).

This should give you a good idea of how to structure a multi-tier  application with Ansible, and orchestrate operations upon that app, with the eventual goal of continuous delivery to your customers. You could  extend the idea of the rolling upgrade to lots of different parts of the app; maybe add front-end web servers along with application servers,  for instance, or replace the SQL database with something like MongoDB or Riak. Ansible gives you the capability to easily manage complicated  environments and automate common operations.        

## 执行 playbook

运行复杂的 playbook 需要一些试错，所以了解 Ansible 为确保成功执行而提供的一些功能。You can validate your tasks with “dry run” playbooks, use the  start-at-task and step mode options to efficiently troubleshoot  playbooks. 您可以使用 “dry run” playbook 验证您的任务，使用“开始任务”和“步骤”模式选项来有效地排除剧本的故障。还可以使用 Ansible 调试器在执行期间纠正任务。Ansible also offers flexibility with asynchronous playbook execution and tags that let you run specific parts of your playbook.Ansible 还提供了异步剧本执行和标记的灵活性，允许您运行剧本的特定部分。

### Validating tasks: check mode and diff mode[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#validating-tasks-check-mode-and-diff-mode)

Ansible provides two modes of execution that validate tasks: check  mode and diff mode. These modes can be used separately or together. They are useful when you are creating or editing a playbook or role and you  want to know what it will do. In check mode, Ansible runs without making any changes on remote systems. Modules that support check mode report  the changes they would have made. Modules that do not support check mode report nothing and do nothing. In diff mode, Ansible provides  before-and-after comparisons. Modules that support diff mode display  detailed information. You can combine check mode and diff mode for  detailed validation of your playbook or role.

#### [Using check mode](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#id1)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#using-check-mode)

Check mode is just a simulation. It will not generate output for tasks that use [conditionals based on registered variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#conditionals-registered-vars) (results of prior tasks). However, it is great for validating  configuration management playbooks that run on one node at a time. To  run a playbook in check mode:

```
ansible-playbook foo.yml --check
```

##### [Enforcing or preventing check mode on tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#id2)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#enforcing-or-preventing-check-mode-on-tasks)

New in version 2.2.

If you want certain tasks to run in check mode always, or never, regardless of whether you run the playbook with or without `--check`, you can add the `check_mode` option to those tasks:

> - To force a task to run in check mode, even when the playbook is called without `--check`, set `check_mode: yes`.
> - To force a task to run in normal mode and make changes to the system, even when the playbook is called with `--check`, set `check_mode: no`.

For example:

```
tasks:
  - name: This task will always make changes to the system
    ansible.builtin.command: /something/to/run --even-in-check-mode
    check_mode: false

  - name: This task will never make changes to the system
    ansible.builtin.lineinfile:
      line: "important config"
      dest: /path/to/myconfig.conf
      state: present
    check_mode: true
    register: changes_to_important_config
```

Running single tasks with `check_mode: yes` can be useful for testing Ansible modules, either to test the module  itself or to test the conditions under which a module would make  changes. You can register variables (see [Conditionals](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html#playbooks-conditionals)) on these tasks for even more detail on the potential changes.

Note

Prior to version 2.2 only the equivalent of `check_mode: no` existed. The notation for that was `always_run: yes`.

##### [Skipping tasks or ignoring errors in check mode](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#skipping-tasks-or-ignoring-errors-in-check-mode)

New in version 2.1.

If you want to skip a task or ignore errors on a task when you run Ansible in check mode, you can use a boolean magic variable `ansible_check_mode`, which is set to `True` when Ansible runs in check mode. For example:

```
tasks:

  - name: This task will be skipped in check mode
    ansible.builtin.git:
      repo: ssh://git@github.com/mylogin/hello.git
      dest: /home/mylogin/hello
    when: not ansible_check_mode

  - name: This task will ignore errors in check mode
    ansible.builtin.git:
      repo: ssh://git@github.com/mylogin/hello.git
      dest: /home/mylogin/hello
    ignore_errors: "{{ ansible_check_mode }}"
```

#### [Using diff mode](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#using-diff-mode)

The `--diff` option for ansible-playbook can be used alone or with `--check`. When you run in diff mode, any module that supports diff mode reports the changes made or, if used with `--check`, the changes that would have been made. Diff mode is most common in  modules that manipulate files (for example, the template module) but  other modules might also show ‘before and after’ information (for  example, the user module).

Diff mode produces a large amount of output, so it is best used when checking a single host at a time. For example:

```
ansible-playbook foo.yml --check --diff --limit foo.example.com
```

New in version 2.4.

##### [Enforcing or preventing diff mode on tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#id5)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#enforcing-or-preventing-diff-mode-on-tasks)

Because the `--diff` option can reveal sensitive information, you can disable it for a task by specifying `diff: no`. For example:

```
tasks:
  - name: This task will not report a diff when the file changes
    ansible.builtin.template:
      src: secret.conf.j2
      dest: /etc/secret.conf
      owner: root
      group: root
      mode: '0600'
    diff: false
```

### Understanding privilege escalation: become[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#understanding-privilege-escalation-become)

Ansible uses existing privilege escalation systems to execute tasks  with root privileges or with another user’s permissions. Because this  feature allows you to ‘become’ another user, different from the user  that logged into the machine (remote user), we call it `become`. The `become` keyword uses existing privilege escalation tools like sudo, su, pfexec, doas, pbrun, dzdo, ksu, runas, machinectl and others.

- [Using become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#using-become)
  - [Become directives](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-directives)
  - [Become connection variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-connection-variables)
  - [Become command-line options](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-command-line-options)
- [Risks and limitations of become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#risks-and-limitations-of-become)
  - [Risks of becoming an unprivileged user](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#risks-of-becoming-an-unprivileged-user)
  - [Not supported by all connection plugins](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#not-supported-by-all-connection-plugins)
  - [Only one method may be enabled per host](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#only-one-method-may-be-enabled-per-host)
  - [Privilege escalation must be general](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#privilege-escalation-must-be-general)
  - [May not access environment variables populated by pamd_systemd](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#may-not-access-environment-variables-populated-by-pamd-systemd)
  - [Resolving Temporary File Error Messsages](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#resolving-temporary-file-error-messsages)
- [Become and network automation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-and-network-automation)
  - [Setting enable mode for all tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#setting-enable-mode-for-all-tasks)
    - [Passwords for enable mode](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#passwords-for-enable-mode)
  - [authorize and auth_pass](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#authorize-and-auth-pass)
- [Become and Windows](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-and-windows)
  - [Administrative rights](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#administrative-rights)
  - [Local service accounts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#local-service-accounts)
  - [Become without setting a password](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-without-setting-a-password)
  - [Accounts without a password](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#accounts-without-a-password)
  - [Become flags for Windows](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-flags-for-windows)
  - [Limitations of become on Windows](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#limitations-of-become-on-windows)

## [Using become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id1)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#using-become)

You can control the use of `become` with play or task directives, connection variables, or at the command  line. If you set privilege escalation properties in multiple ways,  review the [general precedence rules](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html#general-precedence-rules) to understand which settings will be used.

A full list of all become plugins that are included in Ansible can be found in the [Plugin List](https://docs.ansible.com/ansible/latest/plugins/become.html#become-plugin-list).

### [Become directives](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id2)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-directives)

You can set the directives that control `become` at the play or task level. You can override these by setting connection variables, which often differ from one host to another. These variables and directives are independent. For example, setting `become_user` does not set `become`.

- become

  set to `yes` to activate privilege escalation.

- become_user

  set to user with desired privileges — the user you become, NOT the user you login as. Does NOT imply `become: yes`, to allow it to be set at host level. Default value is `root`.

- become_method

  (at play or task level) overrides the default method set in ansible.cfg, set to use any of the [Become plugins](https://docs.ansible.com/ansible/latest/plugins/become.html#become-plugins).

- become_flags

  (at play or task level) permit the use of  specific flags for the tasks or role. One common use is to change the  user to nobody when the shell is set to nologin. Added in Ansible 2.2.

For example, to manage a system service (which requires `root` privileges) when connected as a non-`root` user, you can use the default value of `become_user` (`root`):

```
- name: Ensure the httpd service is running
  service:
    name: httpd
    state: started
  become: true
```

To run a command as the `apache` user:

```
- name: Run a command as the apache user
  command: somecommand
  become: true
  become_user: apache
```

To do something as the `nobody` user when the shell is nologin:

```
- name: Run a command as nobody
  command: somecommand
  become: true
  become_method: su
  become_user: nobody
  become_flags: '-s /bin/sh'
```

To specify a password for sudo, run `ansible-playbook` with `--ask-become-pass` (`-K` for short). If you run a playbook utilizing `become` and the playbook seems to hang, most likely it is stuck at the privilege escalation prompt. Stop it with CTRL-c, then execute the playbook with `-K` and the appropriate password.

### [Become connection variables](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-connection-variables)

You can define different `become` options for each managed node or group. You can define these variables in inventory or use them as normal variables.

- ansible_become

  overrides the `become` directive, decides if privilege escalation is used or not.

- ansible_become_method

  which privilege escalation method should be used

- ansible_become_user

  set the user you become through privilege escalation; does not imply `ansible_become: yes`

- ansible_become_password

  set the privilege escalation password. See [Using encrypted variables and files](https://docs.ansible.com/ansible/latest/vault_guide/vault_using_encrypted_content.html#playbooks-vault) for details on how to avoid having secrets in plain text

- ansible_common_remote_group

  determines if Ansible should try to `chgrp` its temporary files to a group if `setfacl` and `chown` both fail. See [Risks of becoming an unprivileged user](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#risks-of-becoming-an-unprivileged-user) for more information. Added in version 2.10.

For example, if you want to run all tasks as `root` on a server named `webserver`, but you can only connect as the `manager` user, you could use an inventory entry like this:

```
webserver ansible_user=manager ansible_become=yes
```

Note

The variables defined above are generic for all become plugins but plugin specific ones can also be set instead. Please see the documentation for each plugin for a list of all options the plugin has and how they can be defined. A full list of become plugins in Ansible can be found at [Become plugins](https://docs.ansible.com/ansible/latest/plugins/become.html#become-plugins).

### [Become command-line options](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-command-line-options)

- --ask-become-pass, -K

  ask for privilege escalation password; does not imply become will be used. Note that this password will be used for all hosts.

- --become, -b

  run operations with become (no password implied)

- --become-method=BECOME_METHOD

  privilege escalation method to use (default=sudo), valid choices: [ sudo | su | pbrun | pfexec | doas | dzdo | ksu | runas | machinectl ]

- --become-user=BECOME_USER

  run operations as this user (default=root), does not imply –become/-b

## [Risks and limitations of become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id5)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#risks-and-limitations-of-become)

Although privilege escalation is mostly intuitive, there are a few limitations on how it works.  Users should be aware of these to avoid surprises.

### [Risks of becoming an unprivileged user](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id6)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#risks-of-becoming-an-unprivileged-user)

Ansible modules are executed on the remote machine by first substituting the parameters into the module file, then copying the file to the remote machine, and finally executing it there.

Everything is fine if the module file is executed without using `become`, when the `become_user` is root, or when the connection to the remote machine is made as root. In these cases Ansible creates the module file with permissions that only allow reading by the user and root, or only allow reading by the unprivileged user being switched to.

However, when both the connection user and the `become_user` are unprivileged, the module file is written as the user that Ansible connects as (the `remote_user`), but the file needs to be readable by the user Ansible is set to `become`. The details of how Ansible solves this can vary based on platform. However, on POSIX systems, Ansible solves this problem in the following way:

First, if **setfacl** is installed and available in the remote `PATH`, and the temporary directory on the remote host is mounted with POSIX.1e filesystem ACL support, Ansible will use POSIX ACLs to share the module file with the second unprivileged user.

Next, if POSIX ACLs are **not** available or **setfacl** could not be run, Ansible will attempt to change ownership of the module file using **chown** for systems which support doing so as an unprivileged user.

New in Ansible 2.11, at this point, Ansible will try **chmod +a** which is a macOS-specific way of setting ACLs on files.

New in Ansible 2.10, if all of the above fails, Ansible will then check the value of the configuration setting `ansible_common_remote_group`. Many systems will allow a given user to change the group ownership of a file to a group the user is in. As a result, if the second unprivileged user (the `become_user`) has a UNIX group in common with the user Ansible is connected as (the `remote_user`), and if `ansible_common_remote_group` is defined to be that group, Ansible can try to change the group ownership of the module file to that group by using **chgrp**, thereby likely making it readable to the `become_user`.

At this point, if `ansible_common_remote_group` was defined and a **chgrp** was attempted and returned successfully, Ansible assumes (but, importantly, does not check) that the new group ownership is enough and does not fall back further. That is, Ansible **does not check** that the `become_user` does in fact share a group with the `remote_user`; so long as the command exits successfully, Ansible considers the result successful and does not proceed to check `allow_world_readable_tmpfiles` per below.

If `ansible_common_remote_group` is **not** set and the chown above it failed, or if `ansible_common_remote_group` *is* set but the **chgrp** (or following group-permissions **chmod**) returned a non-successful exit code, Ansible will lastly check the value of `allow_world_readable_tmpfiles`. If this is set, Ansible will place the module file in a world-readable temporary directory, with world-readable permissions to allow the `become_user` (and incidentally any other user on the system) to read the contents of the file. **If any of the parameters passed to the module are sensitive in nature, and you do not trust the remote machines, then this is a potential security risk.**

Once the module is done executing, Ansible deletes the temporary file.

Several ways exist to avoid the above logic flow entirely:

- Use pipelining.  When pipelining is enabled, Ansible does not save the module to a temporary file on the client.  Instead it pipes the module to the remote python interpreter’s stdin. Pipelining does not work for python modules involving file transfer (for example: [copy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html#copy-module), [fetch](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/fetch_module.html#fetch-module), [template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html#template-module)), or for non-python modules.
- Avoid becoming an unprivileged user.  Temporary files are protected by UNIX file permissions when you `become` root or do not use `become`.  In Ansible 2.1 and above, UNIX file permissions are also secure if you make the connection to the managed machine as root and then use `become` to access an unprivileged account.

Warning

Although the Solaris ZFS filesystem has filesystem ACLs, the ACLs are not POSIX.1e filesystem acls (they are NFSv4 ACLs instead).  Ansible cannot use these ACLs to manage its temp file permissions so you may have to resort to `allow_world_readable_tmpfiles` if the remote machines use ZFS.

Changed in version 2.1.

Ansible makes it hard to unknowingly use `become` insecurely. Starting in Ansible 2.1, Ansible defaults to issuing an error if it cannot execute securely with `become`. If you cannot use pipelining or POSIX ACLs, must connect as an unprivileged user, must use `become` to execute as a different unprivileged user, and decide that your managed nodes are secure enough for the modules you want to run there to be world readable, you can turn on `allow_world_readable_tmpfiles` in the `ansible.cfg` file.  Setting `allow_world_readable_tmpfiles` will change this from an error into a warning and allow the task to run as it did prior to 2.1.

Changed in version 2.10.

Ansible 2.10 introduces the above-mentioned `ansible_common_remote_group` fallback. As mentioned above, if enabled, it is used when `remote_user` and `become_user` are both unprivileged users. Refer to the text above for details on when this fallback happens.

Warning

As mentioned above, if `ansible_common_remote_group` and `allow_world_readable_tmpfiles` are both enabled, it is unlikely that the world-readable fallback will ever trigger, and yet Ansible might still be unable to access the module file. This is because after the group ownership change is successful, Ansible does not fall back any further, and also does not do any check to ensure that the `become_user` is actually a member of the “common group”. This is a design decision made by the fact that doing such a check would require another round-trip connection to the remote machine, which is a time-expensive operation. Ansible does, however, emit a warning in this case.

### [Not supported by all connection plugins](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id7)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#not-supported-by-all-connection-plugins)

Privilege escalation methods must also be supported by the connection plugin used. Most connection plugins will warn if they do not support become. Some will just ignore it as they always run as root (jail, chroot, and so on).

### [Only one method may be enabled per host](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id8)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#only-one-method-may-be-enabled-per-host)

Methods cannot be chained. You cannot use `sudo /bin/su -` to become a user, you need to have privileges to run the command as that user in sudo or be able to su directly to it (the same for pbrun, pfexec or other supported methods).

### [Privilege escalation must be general](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id9)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#privilege-escalation-must-be-general)

You cannot limit privilege escalation permissions to certain commands. Ansible does not always use a specific command to do something but runs modules (code) from a temporary file name which changes every time.  If you have ‘/sbin/service’ or ‘/bin/chmod’ as the allowed commands this will fail with ansible as those paths won’t match with the temporary file that Ansible creates to run the module. If you have security rules that constrain your sudo/pbrun/doas environment to running specific command paths only, use Ansible from a special account that does not have this constraint, or use AWX or the [Red Hat Ansible Automation Platform](https://docs.ansible.com/ansible/latest/reference_appendices/tower.html#ansible-platform) to manage indirect access to SSH credentials.

### [May not access environment variables populated by pamd_systemd](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id10)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#may-not-access-environment-variables-populated-by-pamd-systemd)

For most Linux distributions using `systemd` as their init, the default methods used by `become` do not open a new “session”, in the sense of systemd. Because the `pam_systemd` module will not fully initialize a new session, you might have surprises compared to a normal session opened through ssh: some environment variables set by `pam_systemd`, most notably `XDG_RUNTIME_DIR`, are not populated for the new user and instead inherited or just emptied.

This might cause trouble when trying to invoke systemd commands that depend on `XDG_RUNTIME_DIR` to access the bus:

```
echo $XDG_RUNTIME_DIR
systemctl --user status
Failed to connect to bus: Permission denied
```

To force `become` to open a new systemd session that goes through `pam_systemd`, you can use `become_method: machinectl`.

For more information, see [this systemd issue](https://github.com/systemd/systemd/issues/825#issuecomment-127917622).

### [Resolving Temporary File Error Messsages](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id11)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#resolving-temporary-file-error-messsages)

- Failed to set permissions on the temporary files Ansible needs to create when becoming an unprivileged user”
- This error can be resolved by installing the package that provides the `setfacl` command. (This is frequently the `acl` package but check your OS documentation.)



## [Become and network automation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id12)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-and-network-automation)

As of version 2.6, Ansible supports `become` for privilege escalation (entering `enable` mode or privileged EXEC mode) on all Ansible-maintained network platforms that support `enable` mode. Using `become` replaces the `authorize` and `auth_pass` options in a `provider` dictionary.

You must set the connection type to either `connection: ansible.netcommon.network_cli` or `connection: ansible.netcommon.httpapi` to use `become` for privilege escalation on network devices. Check the [Platform Options](https://docs.ansible.com/ansible/latest/network/user_guide/platform_index.html#platform-options) documentation for details.

You can use escalated privileges on only the specific tasks that need them, on an entire play, or on all plays. Adding `become: yes` and `become_method: enable` instructs Ansible to enter `enable` mode before executing the task, play, or playbook where those parameters are set.

If you see this error message, the task that generated it requires `enable` mode to succeed:

```
Invalid input (privileged mode required)
```

To set `enable` mode for a specific task, add `become` at the task level:

```
- name: Gather facts (eos)
  arista.eos.eos_facts:
    gather_subset:
      - "!hardware"
  become: true
  become_method: enable
```

To set enable mode for all tasks in a single play, add `become` at the play level:

```
- hosts: eos-switches
  become: true
  become_method: enable
  tasks:
    - name: Gather facts (eos)
      arista.eos.eos_facts:
        gather_subset:
          - "!hardware"
```

### [Setting enable mode for all tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id13)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#setting-enable-mode-for-all-tasks)

Often you wish for all tasks in all plays to run using privilege mode, that is best achieved by using `group_vars`:

**group_vars/eos.yml**

```
ansible_connection: ansible.netcommon.network_cli
ansible_network_os: arista.eos.eos
ansible_user: myuser
ansible_become: true
ansible_become_method: enable
```

#### [Passwords for enable mode](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id14)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#passwords-for-enable-mode)

If you need a password to enter `enable` mode, you can specify it in one of two ways:

- providing the [`--ask-become-pass`](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html#cmdoption-ansible-playbook-K) command line option
- setting the `ansible_become_password` connection variable

Warning

As a reminder passwords should never be stored in plain text. For  information on encrypting your passwords and other secrets with Ansible  Vault, see [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/vault.html#vault).

### [authorize and auth_pass](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id15)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#authorize-and-auth-pass)

Ansible still supports `enable` mode with `connection: local` for legacy network playbooks. To enter `enable` mode with `connection: local`, use the module options `authorize` and `auth_pass`:

```
- hosts: eos-switches
  ansible_connection: local
  tasks:
    - name: Gather facts (eos)
      eos_facts:
        gather_subset:
          - "!hardware"
      provider:
        authorize: true
        auth_pass: " {{ secret_auth_pass }}"
```

We recommend updating your playbooks to use `become` for network-device `enable` mode consistently. The use of `authorize` and of `provider` dictionaries will be deprecated in future. Check the [Platform Options](https://docs.ansible.com/ansible/latest/network/user_guide/platform_index.html#platform-options) documentation for details.



## [Become and Windows](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id16)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-and-windows)

Since Ansible 2.3, `become` can be used on Windows hosts through the `runas` method. Become on Windows uses the same inventory setup and invocation arguments as `become` on a non-Windows host, so the setup and variable names are the same as what is defined in this document with the exception of `become_user`. As there is no sensible default for `become_user` on Windows it is required when using `become`. See [ansible.builtin.runas become plugin](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/runas_become.html#ansible-collections-ansible-builtin-runas-become) for details.

While `become` can be used to assume the identity of another user, there are other uses for it with Windows hosts. One important use is to bypass some of the limitations that are imposed when running on WinRM, such as constrained network delegation or accessing forbidden system calls like the WUA API. You can use `become` with the same user as `ansible_user` to bypass these limitations and run commands that are not normally accessible in a WinRM session.

Note

On Windows you cannot connect with an underprivileged account and use become to elevate your rights. Become can only be used if your connection account is already an Administrator of the target host.

### [Administrative rights](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id17)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#administrative-rights)

Many tasks in Windows require administrative privileges to complete. When using the `runas` become method, Ansible will attempt to run the module with the full privileges that are available to the become user. If it fails to elevate the user token, it will continue to use the limited token during execution.

A user must have the `SeDebugPrivilege` to run a become process with elevated privileges. This privilege is assigned to Administrators by default. If the debug privilege is not available, the become process will run with a limited set of privileges and groups.

To determine the type of token that Ansible was able to get, run the following task:

```
- Check my user name
  ansible.windows.win_whoami:
  become: true
```

The output will look something similar to the below:

```
ok: [windows] => {
    "account": {
        "account_name": "vagrant-domain",
        "domain_name": "DOMAIN",
        "sid": "S-1-5-21-3088887838-4058132883-1884671576-1105",
        "type": "User"
    },
    "authentication_package": "Kerberos",
    "changed": false,
    "dns_domain_name": "DOMAIN.LOCAL",
    "groups": [
        {
            "account_name": "Administrators",
            "attributes": [
                "Mandatory",
                "Enabled by default",
                "Enabled",
                "Owner"
            ],
            "domain_name": "BUILTIN",
            "sid": "S-1-5-32-544",
            "type": "Alias"
        },
        {
            "account_name": "INTERACTIVE",
            "attributes": [
                "Mandatory",
                "Enabled by default",
                "Enabled"
            ],
            "domain_name": "NT AUTHORITY",
            "sid": "S-1-5-4",
            "type": "WellKnownGroup"
        },
    ],
    "impersonation_level": "SecurityAnonymous",
    "label": {
        "account_name": "High Mandatory Level",
        "domain_name": "Mandatory Label",
        "sid": "S-1-16-12288",
        "type": "Label"
    },
    "login_domain": "DOMAIN",
    "login_time": "2018-11-18T20:35:01.9696884+00:00",
    "logon_id": 114196830,
    "logon_server": "DC01",
    "logon_type": "Interactive",
    "privileges": {
        "SeBackupPrivilege": "disabled",
        "SeChangeNotifyPrivilege": "enabled-by-default",
        "SeCreateGlobalPrivilege": "enabled-by-default",
        "SeCreatePagefilePrivilege": "disabled",
        "SeCreateSymbolicLinkPrivilege": "disabled",
        "SeDebugPrivilege": "enabled",
        "SeDelegateSessionUserImpersonatePrivilege": "disabled",
        "SeImpersonatePrivilege": "enabled-by-default",
        "SeIncreaseBasePriorityPrivilege": "disabled",
        "SeIncreaseQuotaPrivilege": "disabled",
        "SeIncreaseWorkingSetPrivilege": "disabled",
        "SeLoadDriverPrivilege": "disabled",
        "SeManageVolumePrivilege": "disabled",
        "SeProfileSingleProcessPrivilege": "disabled",
        "SeRemoteShutdownPrivilege": "disabled",
        "SeRestorePrivilege": "disabled",
        "SeSecurityPrivilege": "disabled",
        "SeShutdownPrivilege": "disabled",
        "SeSystemEnvironmentPrivilege": "disabled",
        "SeSystemProfilePrivilege": "disabled",
        "SeSystemtimePrivilege": "disabled",
        "SeTakeOwnershipPrivilege": "disabled",
        "SeTimeZonePrivilege": "disabled",
        "SeUndockPrivilege": "disabled"
    },
    "rights": [
        "SeNetworkLogonRight",
        "SeBatchLogonRight",
        "SeInteractiveLogonRight",
        "SeRemoteInteractiveLogonRight"
    ],
    "token_type": "TokenPrimary",
    "upn": "vagrant-domain@DOMAIN.LOCAL",
    "user_flags": []
}
```

Under the `label` key, the `account_name` entry determines whether the user has Administrative rights. Here are the labels that can be returned and what they represent:

- `Medium`: Ansible failed to get an elevated token and ran under a limited token. Only a subset of the privileges assigned to user are available during the module execution and the user does not have administrative rights.
- `High`: An elevated token was used and all the privileges assigned to the user are available during the module execution.
- `System`: The `NT AUTHORITY\System` account is used and has the highest level of privileges available.

The output will also show the list of privileges that have been granted to the user. When the privilege value is `disabled`, the privilege is assigned to the logon token but has not been enabled. In most scenarios these privileges are automatically enabled when required.

If running on a version of Ansible that is older than 2.5 or the normal `runas` escalation process fails, an elevated token can be retrieved by:

- Set the `become_user` to `System` which has full control over the operating system.

- Grant `SeTcbPrivilege` to the user Ansible connects with on WinRM. `SeTcbPrivilege` is a high-level privilege that grants full control over the operating system. No user is given this privilege by default, and care should be taken if you grant this privilege to a user or group. For more information on this privilege, please see [Act as part of the operating system](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn221957(v=ws.11)). You can use the below task to set this privilege on a Windows host:

  ```
  - name: grant the ansible user the SeTcbPrivilege right
    ansible.windows.win_user_right:
      name: SeTcbPrivilege
      users: '{{ansible_user}}'
      action: add
  ```

- Turn UAC off on the host and reboot before trying to become the user. UAC is a security protocol that is designed to run accounts with the `least privilege` principle. You can turn UAC off by running the following tasks:

  ```
  - name: turn UAC off
    win_regedit:
      path: HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system
      name: EnableLUA
      data: 0
      type: dword
      state: present
    register: uac_result
  
  - name: reboot after disabling UAC
    win_reboot:
    when: uac_result is changed
  ```

Note

Granting the `SeTcbPrivilege` or turning UAC off can cause Windows security vulnerabilities and care should be given if these steps are taken.

### [Local service accounts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id18)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#local-service-accounts)

Prior to Ansible version 2.5, `become` only worked on Windows with a local or domain user account. Local service accounts like `System` or `NetworkService` could not be used as `become_user` in these older versions. This restriction has been lifted since the 2.5 release of Ansible. The three service accounts that can be set under `become_user` are:

- System
- NetworkService
- LocalService

Because local service accounts do not have passwords, the `ansible_become_password` parameter is not required and is ignored if specified.

### [Become without setting a password](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id19)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-without-setting-a-password)

As of Ansible 2.8, `become` can be used to become a Windows local or domain account without requiring a password for that account. For this method to work, the following requirements must be met:

- The connection user has the `SeDebugPrivilege` privilege assigned
- The connection user is part of the `BUILTIN\Administrators` group
- The `become_user` has either the `SeBatchLogonRight` or `SeNetworkLogonRight` user right

Using become without a password is achieved in one of two different methods:

- Duplicating an existing logon session’s token if the account is already logged on
- Using S4U to generate a logon token that is valid on the remote host only

In the first scenario, the become process is spawned from another logon of that user account. This could be an existing RDP logon, console logon, but this is not guaranteed to occur all the time. This is similar to the `Run only when user is logged on` option for a Scheduled Task.

In the case where another logon of the become account does not exist, S4U is used to create a new logon and run the module through that. This is similar to the `Run whether user is logged on or not` with the `Do not store password` option for a Scheduled Task. In this scenario, the become process will not be able to access any network resources like a normal WinRM process.

To make a distinction between using become with no password and becoming an account that has no password make sure to keep `ansible_become_password` as undefined or set `ansible_become_password:`.

Note

Because there are no guarantees an existing token will exist for a user when Ansible runs, there’s a high change the become process will only have access to local resources. Use become with a password if the task needs to access network resources

### [Accounts without a password](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id20)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#accounts-without-a-password)

Warning

As a general security best practice, you should avoid allowing accounts without passwords.

Ansible can be used to become a Windows account that does not have a password (like the `Guest` account). To become an account without a password, set up the variables like normal but set `ansible_become_password: ''`.

Before become can work on an account like this, the local policy [Accounts: Limit local account use of blank passwords to console logon only](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj852174(v=ws.11)) must be disabled. This can either be done through a Group Policy Object (GPO) or with this Ansible task:

```
- name: allow blank password on become
  ansible.windows.win_regedit:
    path: HKLM:\SYSTEM\CurrentControlSet\Control\Lsa
    name: LimitBlankPasswordUse
    data: 0
    type: dword
    state: present
```

Note

This is only for accounts that do not have a password. You still need to set the account’s password under `ansible_become_password` if the become_user has a password.

### [Become flags for Windows](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id21)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become-flags-for-windows)

Ansible 2.5 added the `become_flags` parameter to the `runas` become method. This parameter can be set using the `become_flags` task directive or set in Ansible’s configuration using `ansible_become_flags`. The two valid values that are initially supported for this parameter are `logon_type` and `logon_flags`.

Note

These flags should only be set when becoming a normal user account, not a local service account like LocalSystem.

The key `logon_type` sets the type of logon operation to perform. The value can be set to one of the following:

- `interactive`: The default logon type. The process will be run under a context that is the same as when running a process locally. This bypasses all WinRM restrictions and is the recommended method to use.
- `batch`: Runs the process under a batch context that is similar to a scheduled task with a password set. This should bypass most WinRM restrictions and is useful if the `become_user` is not allowed to log on interactively.
- `new_credentials`: Runs under the same credentials as the calling user, but outbound connections are run under the context of the `become_user` and `become_password`, similar to `runas.exe /netonly`. The `logon_flags` flag should also be set to `netcredentials_only`. Use this flag if the process needs to access a network resource (like an SMB share) using a different set of credentials.
- `network`: Runs the process under a network context without any cached credentials. This results in the same type of logon session as running a normal WinRM process without credential delegation, and operates under the same restrictions.
- `network_cleartext`: Like the `network` logon type, but instead caches the credentials so it can access network resources. This is the same type of logon session as running a normal WinRM process with credential delegation.

For more information, see [dwLogonType](https://docs.microsoft.com/en-gb/windows/desktop/api/winbase/nf-winbase-logonusera).

The `logon_flags` key specifies how Windows will log the user on when creating the new process. The value can be set to none or multiple of the following:

- `with_profile`: The default logon flag set. The process will load the user’s profile in the `HKEY_USERS` registry key to `HKEY_CURRENT_USER`.
- `netcredentials_only`: The process will use the same token as the caller but will use the `become_user` and `become_password` when accessing a remote resource. This is useful in inter-domain scenarios where there is no trust relationship, and should be used with the `new_credentials` `logon_type`.

By default `logon_flags=with_profile` is set, if the profile should not be loaded set `logon_flags=` or if the profile should be loaded with `netcredentials_only`, set `logon_flags=with_profile,netcredentials_only`.

For more information, see [dwLogonFlags](https://docs.microsoft.com/en-gb/windows/desktop/api/winbase/nf-winbase-createprocesswithtokenw).

Here are some examples of how to use `become_flags` with Windows tasks:

```
- name: copy a file from a fileshare with custom credentials
  ansible.windows.win_copy:
    src: \\server\share\data\file.txt
    dest: C:\temp\file.txt
    remote_src: true
  vars:
    ansible_become: true
    ansible_become_method: runas
    ansible_become_user: DOMAIN\user
    ansible_become_password: Password01
    ansible_become_flags: logon_type=new_credentials logon_flags=netcredentials_only

- name: run a command under a batch logon
  ansible.windows.win_whoami:
  become: true
  become_flags: logon_type=batch

- name: run a command and not load the user profile
  ansible.windows.win_whomai:
  become: true
  become_flags: logon_flags=
```

### [Limitations of become on Windows](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#id22)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#limitations-of-become-on-windows)

- Running a task with `async` and `become` on Windows Server 2008, 2008 R2 and Windows 7 only works when using Ansible 2.7 or newer.
- By default, the become user logs on with an interactive session, so it must have the right to do so on the Windows host. If it does not inherit the `SeAllowLogOnLocally` privilege or inherits the `SeDenyLogOnLocally` privilege, the become process will fail. Either add the privilege or set the `logon_type` flag to change the logon type used.
- Prior to Ansible version 2.3, become only worked when `ansible_winrm_transport` was either `basic` or `credssp`. This restriction has been lifted since the 2.4 release of Ansible for all hosts except Windows Server 2008 (non R2 version).
- The Secondary Logon service `seclogon` must be running to use `ansible_become_method: runas`
- The connection user must already be an Administrator on the Windows host to use `runas`. The target become user does not need to be an Administrator though.

### Tags[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tags)

If you have a large playbook, it may be useful to run only specific  parts of it instead of running the entire playbook. You can do this with Ansible tags. Using tags to execute or skip selected tasks is a  two-step process:

> 1. Add tags to your tasks, either individually or with tag inheritance from a block, play, role, or import.
> 2. Select or skip tags when you run your playbook.

- [Adding tags with the tags keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-with-the-tags-keyword)
  - [Adding tags to individual tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-individual-tasks)
  - [Adding tags to includes](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-includes)
  - [Tag inheritance: adding tags to multiple tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance-adding-tags-to-multiple-tasks)
    - [Adding tags to blocks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-blocks)
    - [Adding tags to plays](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-plays)
    - [Adding tags to roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-roles)
    - [Adding tags to imports](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-imports)
    - [Tag inheritance for includes: blocks and the `apply` keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance-for-includes-blocks-and-the-apply-keyword)
- [Special tags: always and never](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#special-tags-always-and-never)
- [Selecting or skipping tags when you run a playbook](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selecting-or-skipping-tags-when-you-run-a-playbook)
  - [Previewing the results of using tags](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#previewing-the-results-of-using-tags)
  - [Selectively running tagged tasks in re-usable files](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selectively-running-tagged-tasks-in-re-usable-files)
  - [Configuring tags globally](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#configuring-tags-globally)

## [Adding tags with the tags keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id2)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-with-the-tags-keyword)

You can add tags to a single task or include. You can also add tags  to multiple tasks by defining them at the level of a block, play, role,  or import. The keyword `tags` addresses all these use cases. The `tags` keyword always defines tags and adds them to tasks; it does not select  or skip tasks for execution. You can only select or skip tasks based on  tags at the command line when you run a playbook. See [Selecting or skipping tags when you run a playbook](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#using-tags) for more details.

### [Adding tags to individual tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-individual-tasks)

At the simplest level, you can apply one or more tags to an  individual task. You can add tags to tasks in playbooks, in task files,  or within a role. Here is an example that tags two tasks with different  tags:

```
tasks:
- name: Install the servers
  ansible.builtin.yum:
    name:
    - httpd
    - memcached
    state: present
  tags:
  - packages
  - webservers

- name: Configure the service
  ansible.builtin.template:
    src: templates/src.j2
    dest: /etc/foo.conf
  tags:
  - configuration
```

You can apply the same tag to more than one individual task. This example tags several tasks with the same tag, “ntp”:

```
---
# file: roles/common/tasks/main.yml

- name: Install ntp
  ansible.builtin.yum:
    name: ntp
    state: present
  tags: ntp

- name: Configure ntp
  ansible.builtin.template:
    src: ntp.conf.j2
    dest: /etc/ntp.conf
  notify:
  - restart ntpd
  tags: ntp

- name: Enable and run ntpd
  ansible.builtin.service:
    name: ntpd
    state: started
    enabled: true
  tags: ntp

- name: Install NFS utils
  ansible.builtin.yum:
    name:
    - nfs-utils
    - nfs-util-lib
    state: present
  tags: filesharing
```

If you ran these four tasks in a playbook with `--tags ntp`, Ansible would run the three tasks tagged `ntp` and skip the one task that does not have that tag.



### [Adding tags to includes](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-includes)

You can apply tags to dynamic includes in a playbook. As with tags on an individual task, tags on an `include_*` task apply only to the include itself, not to any tasks within the included file or role. If you add `mytag` to a dynamic include, then run that playbook with `--tags mytag`, Ansible runs the include itself, runs any tasks within the included file or role tagged with `mytag`, and skips any tasks within the included file or role without that tag. See [Selectively running tagged tasks in re-usable files](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selective-reuse) for more details.

You add tags to includes the same way you add tags to any other task:

```
---
# file: roles/common/tasks/main.yml

- name: Dynamic re-use of database tasks
  include_tasks: db.yml
  tags: db
```

You can add a tag only to the dynamic include of a role. In this example, the `foo` tag will not apply to tasks inside the `bar` role:

```
---
- hosts: webservers
  tasks:
    - name: Include the bar role
      include_role:
        name: bar
      tags:
        - foo
```

With plays, blocks, the `role` keyword, and static imports, Ansible applies tag inheritance, adding  the tags you define to every task inside the play, block, role, or  imported file. However, tag inheritance does *not* apply to dynamic re-use with `include_role` and `include_tasks`. With dynamic re-use (includes), the tags you define apply only to the  include itself. If you need tag inheritance, use a static import. If you cannot use an import because the rest of your playbook uses includes,  see [Tag inheritance for includes: blocks and the apply keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#apply-keyword) for ways to work around this behavior.



### [Tag inheritance: adding tags to multiple tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id5)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance-adding-tags-to-multiple-tasks)

If you want to apply the same tag or tags to multiple tasks without adding a `tags` line to every task, you can define the tags at the level of your play  or block, or when you add a role or import a file. Ansible applies the  tags down the dependency chain to all child tasks. With roles and  imports, Ansible appends the tags set by the `roles` section or import to any tags set on individual tasks or blocks within  the role or imported file. This is called tag inheritance. Tag  inheritance is convenient, because you do not have to tag every task.  However, the tags still apply to the tasks individually.

#### [Adding tags to blocks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id6)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-blocks)

If you want to apply a tag to many, but not all, of the tasks in your play, use a [block](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_blocks.html#playbooks-blocks) and define the tags at that level. For example, we could edit the NTP example shown above to use a block:

```
# myrole/tasks/main.yml
- name: ntp tasks
  tags: ntp
  block:
  - name: Install ntp
    ansible.builtin.yum:
      name: ntp
      state: present

  - name: Configure ntp
    ansible.builtin.template:
      src: ntp.conf.j2
      dest: /etc/ntp.conf
    notify:
    - restart ntpd

  - name: Enable and run ntpd
    ansible.builtin.service:
      name: ntpd
      state: started
      enabled: true

- name: Install NFS utils
  ansible.builtin.yum:
    name:
    - nfs-utils
    - nfs-util-lib
    state: present
  tags: filesharing
```

#### [Adding tags to plays](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id7)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-plays)

If all the tasks in a play should get the same tag, you can add the  tag at the level of the play. For example, if you had a play with only  the NTP tasks, you could tag the entire play:

```
- hosts: all
  tags: ntp
  tasks:
  - name: Install ntp
    ansible.builtin.yum:
      name: ntp
      state: present

  - name: Configure ntp
    ansible.builtin.template:
      src: ntp.conf.j2
      dest: /etc/ntp.conf
    notify:
    - restart ntpd

  - name: Enable and run ntpd
    ansible.builtin.service:
      name: ntpd
      state: started
      enabled: true

- hosts: fileservers
  tags: filesharing
  tasks:
  ...
```

#### [Adding tags to roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id8)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-roles)

There are three ways to add tags to roles:

> 1. Add the same tag or tags to all tasks in the role by setting tags under `roles`. See examples in this section.
> 2. Add the same tag or tags to all tasks in the role by setting tags on a static `import_role` in your playbook. See examples in [Adding tags to imports](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tags-on-imports).
> 3. Add a tag or tags to individual tasks or blocks within the role  itself. This is the only approach that allows you to select or skip some tasks within the role. To select or skip tasks within the role, you  must have tags set on individual tasks or blocks, use the dynamic `include_role` in your playbook, and add the same tag or tags to the include. When you use this approach, and then run your playbook with `--tags foo`, Ansible runs the include itself plus any tasks in the role that also have the tag `foo`. See [Adding tags to includes](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tags-on-includes) for details.

When you incorporate a role in your playbook statically with the `roles` keyword, Ansible adds any tags you define to all the tasks in the role. For example:

```
roles:
  - role: webserver
    vars:
      port: 5000
    tags: [ web, foo ]
```

or:

```
---
- hosts: webservers
  roles:
    - role: foo
      tags:
        - bar
        - baz
    # using YAML shorthand, this is equivalent to:
    # - { role: foo, tags: ["bar", "baz"] }
```



#### [Adding tags to imports](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id9)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#adding-tags-to-imports)

You can also apply a tag or tags to all the tasks imported by the static `import_role` and `import_tasks` statements:

```
---
- hosts: webservers
  tasks:
    - name: Import the foo role
      import_role:
        name: foo
      tags:
        - bar
        - baz

    - name: Import tasks from foo.yml
      import_tasks: foo.yml
      tags: [ web, foo ]
```



#### [Tag inheritance for includes: blocks and the `apply` keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id10)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance-for-includes-blocks-and-the-apply-keyword)

By default, Ansible does not apply [tag inheritance](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#tag-inheritance) to dynamic re-use with `include_role` and `include_tasks`. If you add tags to an include, they apply only to the include itself,  not to any tasks in the included file or role. This allows you to  execute selected tasks within a role or task file - see [Selectively running tagged tasks in re-usable files](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selective-reuse) when you run your playbook.

If you want tag inheritance, you probably want to use imports.  However, using both includes and imports in a single playbook can lead  to difficult-to-diagnose bugs. For this reason, if your playbook uses `include_*` to re-use roles or tasks, and you need tag inheritance on one include, Ansible offers two workarounds. You can use the `apply` keyword:

```
- name: Apply the db tag to the include and to all tasks in db.yaml
  include_tasks:
    file: db.yml
    # adds 'db' tag to tasks within db.yml
    apply:
      tags: db
  # adds 'db' tag to this 'include_tasks' itself
  tags: db
```

Or you can use a block:

```
- block:
   - name: Include tasks from db.yml
     include_tasks: db.yml
  tags: db
```



## [Special tags: always and never](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id11)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#special-tags-always-and-never)

Ansible reserves two tag names for special behavior: always and never. If you assign the `always` tag to a task or play, Ansible will always run that task or play, unless you specifically skip it (`--skip-tags always`).

For example:

```
tasks:
- name: Print a message
  ansible.builtin.debug:
    msg: "Always runs"
  tags:
  - always

- name: Print a message
  ansible.builtin.debug:
    msg: "runs when you use tag1"
  tags:
  - tag1
```

Warning

- Fact gathering is tagged with ‘always’ by default. It is only skipped if you apply a tag and then use a different tag in `--tags` or the same tag in `--skip-tags`.

Warning

- The role argument specification validation task is tagged with ‘always’ by default. This validation will be skipped if you use `--skip-tags always`.

New in version 2.5.

If you assign the `never` tag to a task or play, Ansible will skip that task or play unless you specifically request it (`--tags never`).

For example:

```
tasks:
  - name: Run the rarely-used debug task
    ansible.builtin.debug:
     msg: '{{ showmevar }}'
    tags: [ never, debug ]
```

The rarely-used debug task in the example above only runs when you specifically request the `debug` or `never` tags.



## [Selecting or skipping tags when you run a playbook](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id12)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selecting-or-skipping-tags-when-you-run-a-playbook)

Once you have added tags to your tasks, includes, blocks, plays,  roles, and imports, you can selectively execute or skip tasks based on  their tags when you run [ansible-playbook](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html#ansible-playbook). Ansible runs or skips all tasks with tags that match the tags you pass  at the command line. If you have added a tag at the block or play level, with `roles`, or with an import, that tag applies to every task within the block,  play, role, or imported role or file. If you have a role with lots of  tags and you want to call subsets of the role at different times, either [use it with dynamic includes](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selective-reuse), or split the role into multiple roles.

[ansible-playbook](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html#ansible-playbook) offers five tag-related command-line options:

- `--tags all` - run all tasks, ignore tags (default behavior)
- `--tags [tag1, tag2]` - run only tasks with either the tag `tag1` or the tag `tag2`
- `--skip-tags [tag3, tag4]` - run all tasks except those with either the tag `tag3` or the tag `tag4`
- `--tags tagged` - run only tasks with at least one tag
- `--tags untagged` - run only tasks with no tags

For example, to run only tasks and blocks tagged `configuration` and `packages` in a very long playbook:

```
ansible-playbook example.yml --tags "configuration,packages"
```

To run all tasks except those tagged `packages`:

```
ansible-playbook example.yml --skip-tags "packages"
```

### [Previewing the results of using tags](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id13)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#previewing-the-results-of-using-tags)

When you run a role or playbook, you might not know or remember which tasks have which tags, or which tags exist at all. Ansible offers two  command-line flags for [ansible-playbook](https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html#ansible-playbook) that help you manage tagged playbooks:

- `--list-tags` - generate a list of available tags
- `--list-tasks` - when used with `--tags tagname` or `--skip-tags tagname`, generate a preview of tagged tasks

For example, if you do not know whether the tag for configuration tasks is `config` or `conf` in a playbook, role, or tasks file, you can display all available tags without running any tasks:

```
ansible-playbook example.yml --list-tags
```

If you do not know which tasks have the tags `configuration` and `packages`, you can pass those tags and add `--list-tasks`. Ansible lists the tasks but does not execute any of them.

```
ansible-playbook example.yml --tags "configuration,packages" --list-tasks
```

These command-line flags have one limitation: they cannot show tags or tasks within dynamically included files or roles. See [Comparing includes and imports: dynamic and static re-use](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#dynamic-vs-static) for more information on differences between static imports and dynamic includes.



### [Selectively running tagged tasks in re-usable files](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id14)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#selectively-running-tagged-tasks-in-re-usable-files)

If you have a role or a tasks file with tags defined at the task or  block level, you can selectively run or skip those tagged tasks in a  playbook if you use a dynamic include instead of a static import. You  must use the same tag on the included tasks and on the include statement itself. For example you might create a file with some tagged and some  untagged tasks:

```
# mixed.yml
tasks:
- name: Run the task with no tags
  ansible.builtin.debug:
    msg: this task has no tags

- name: Run the tagged task
  ansible.builtin.debug:
    msg: this task is tagged with mytag
  tags: mytag

- block:
  - name: Run the first block task with mytag
    ...
  - name: Run the second block task with mytag
    ...
  tags:
  - mytag
```

And you might include the tasks file above in a playbook:

```
# myplaybook.yml
- hosts: all
  tasks:
  - name: Run tasks from mixed.yml
    include_tasks:
      name: mixed.yml
    tags: mytag
```

When you run the playbook with `ansible-playbook -i hosts myplaybook.yml --tags "mytag"`, Ansible skips the task with no tags, runs the tagged individual task, and runs the two tasks in the block.

### [Configuring tags globally](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#id15)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#configuring-tags-globally)

If you run or skip certain tags by default, you can use the [TAGS_RUN](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#tags-run) and [TAGS_SKIP](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#tags-skip) options in Ansible configuration to set those defaults.

### Executing playbooks for troubleshooting[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_startnstep.html#executing-playbooks-for-troubleshooting)

When you are testing new plays or debugging playbooks, you may need  to run the same play multiple times. To make this more efficient,  Ansible offers two alternative ways to execute a playbook: start-at-task and step mode.



## start-at-task[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_startnstep.html#start-at-task)

To start executing your playbook at a particular task (usually the task that failed on the previous run), use the `--start-at-task` option.

```
ansible-playbook playbook.yml --start-at-task="install packages"
```

In this example, Ansible starts executing your playbook at a task  named “install packages”. This feature does not work with tasks inside  dynamically re-used roles or tasks (`include_*`), see [Comparing includes and imports: dynamic and static re-use](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#dynamic-vs-static).



## Step mode[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_startnstep.html#step-mode)

To execute a playbook interactively, use `--step`.

```
ansible-playbook playbook.yml --step
```

With this option, Ansible stops on each task, and asks if it should  execute that task. For example, if you have a task called “configure  ssh”, the playbook run will stop and ask.

```
Perform task: configure ssh (y/n/c):
```

Answer “y” to execute the task, answer “n” to skip the task, and  answer “c” to exit step mode, executing all remaining tasks without  asking.

### Debugging tasks[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#debugging-tasks)

Ansible offers a task debugger so you can fix errors during execution instead of editing your playbook and running it again to see if your  change worked. You have access to all of the features of the debugger in the context of the task. You can check or set the value of variables,  update module arguments, and re-run the task with the new variables and  arguments. The debugger lets you resolve the cause of the failure and  continue with playbook execution.

- [Enabling the debugger](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger)
  - [Enabling the debugger with the `debugger` keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger-with-the-debugger-keyword)
    - [Examples of using the `debugger` keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#examples-of-using-the-debugger-keyword)
  - [Enabling the debugger in configuration or an environment variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger-in-configuration-or-an-environment-variable)
  - [Enabling the debugger as a strategy](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger-as-a-strategy)
- [Resolving errors in the debugger](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#resolving-errors-in-the-debugger)
- [Available debug commands](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#available-debug-commands)
  - [Print command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#print-command)
  - [Update args command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-args-command)
  - [Update vars command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-vars-command)
  - [Update task command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-task-command)
  - [Redo command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#redo-command)
  - [Continue command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#continue-command)
  - [Quit command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#quit-command)
- [How the debugger interacts with the free strategy](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#how-the-debugger-interacts-with-the-free-strategy)

## [Enabling the debugger](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id7)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger)

The debugger is not enabled by default. If you want to invoke the debugger during playbook execution, you must enable it first.

Use one of these three methods to enable the debugger:

> - with the debugger keyword
> - in configuration or an environment variable, or
> - as a strategy

### [Enabling the debugger with the `debugger` keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id8)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger-with-the-debugger-keyword)

New in version 2.5.

You can use the `debugger` keyword to enable (or disable) the debugger for a specific play, role,  block, or task. This option is especially useful when developing or  extending playbooks, plays, and roles. You can enable the debugger on  new or updated tasks. If they fail, you can fix the errors efficiently.  The `debugger` keyword accepts five values:

| Value          | Result                                                |
| -------------- | ----------------------------------------------------- |
| always         | Always invoke the debugger, regardless of the outcome |
| never          | Never invoke the debugger, regardless of the outcome  |
| on_failed      | Only invoke the debugger if a task fails              |
| on_unreachable | Only invoke the debugger if a host is unreachable     |
| on_skipped     | Only invoke the debugger if the task is skipped       |

When you use the `debugger` keyword, the value you specify overrides any global configuration to enable or disable the debugger. If you define `debugger` at multiple levels, such as in a role and in a task, Ansible honors the most granular definition. The definition at the play or role level  applies to all blocks and tasks within that play or role, unless they  specify a different value. The definition at the block level overrides  the definition at the play or role level, and applies to all tasks  within that block, unless they specify a different value. The definition at the task level always applies to the task; it overrides the  definitions at the block, play, or role level.

#### [Examples of using the `debugger` keyword](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id9)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#examples-of-using-the-debugger-keyword)

Example of setting the `debugger` keyword on a task:

```
- name: Execute a command
  ansible.builtin.command: "false"
  debugger: on_failed
```

Example of setting the `debugger` keyword on a play:

```
- name: My play
  hosts: all
  debugger: on_skipped
  tasks:
    - name: Execute a command
      ansible.builtin.command: "true"
      when: False
```

Example of setting the `debugger` keyword at multiple levels:

```
- name: Play
  hosts: all
  debugger: never
  tasks:
    - name: Execute a command
      ansible.builtin.command: "false"
      debugger: on_failed
```

In this example, the debugger is set to `never` at the play level and to `on_failed` at the task level. If the task fails, Ansible invokes the debugger,  because the definition on the task overrides the definition on its  parent play.

### [Enabling the debugger in configuration or an environment variable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id10)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger-in-configuration-or-an-environment-variable)

New in version 2.5.

You can enable the task debugger globally with a setting in ansible.cfg or with an environment variable. The only options are `True` or `False`. If you set the configuration option or environment variable to `True`, Ansible runs the debugger on failed tasks by default.

To enable the task debugger from ansible.cfg, add this setting to the defaults section:

```
[defaults]
enable_task_debugger = True
```

To enable the task debugger with an environment variable, pass the variable when you run your playbook:

```
ANSIBLE_ENABLE_TASK_DEBUGGER=True ansible-playbook -i hosts site.yml
```

When you enable the debugger globally, every failed task invokes the  debugger, unless the role, play, block, or task explicitly disables the  debugger. If you need more granular control over what conditions trigger the debugger, use the `debugger` keyword.

### [Enabling the debugger as a strategy](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id11)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#enabling-the-debugger-as-a-strategy)

If you are running legacy playbooks or roles, you may see the debugger enabled as a [strategy](https://docs.ansible.com/ansible/latest/plugins/strategy.html#strategy-plugins). You can do this at the play level, in ansible.cfg, or with the environment variable `ANSIBLE_STRATEGY=debug`. For example:

```
- hosts: test
  strategy: debug
  tasks:
  ...
```

Or in ansible.cfg:

```
[defaults]
strategy = debug
```

Note

This backwards-compatible method, which matches Ansible versions before 2.5, may be removed in a future release.

## [Resolving errors in the debugger](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id12)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#resolving-errors-in-the-debugger)

After Ansible invokes the debugger, you can use the seven [debugger commands](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#available-commands) to resolve the error that Ansible encountered. Consider this example playbook, which defines the `var1` variable but uses the undefined `wrong_var` variable in a task by mistake.

```
- hosts: test
  debugger: on_failed
  gather_facts: false
  vars:
    var1: value1
  tasks:
    - name: Use a wrong variable
      ansible.builtin.ping: data={{ wrong_var }}
```

If you run this playbook, Ansible invokes the debugger when the task  fails. From the debug prompt, you can change the module arguments or the variables and run the task again.

```
PLAY ***************************************************************************

TASK [wrong variable] **********************************************************
fatal: [192.0.2.10]: FAILED! => {"failed": true, "msg": "ERROR! 'wrong_var' is undefined"}
Debugger invoked
[192.0.2.10] TASK: wrong variable (debug)> p result._result
{'failed': True,
 'msg': 'The task includes an option with an undefined variable. The error '
        "was: 'wrong_var' is undefined\n"
        '\n'
        'The error appears to have been in '
        "'playbooks/debugger.yml': line 7, "
        'column 7, but may\n'
        'be elsewhere in the file depending on the exact syntax problem.\n'
        '\n'
        'The offending line appears to be:\n'
        '\n'
        '  tasks:\n'
        '    - name: wrong variable\n'
        '      ^ here\n'}
[192.0.2.10] TASK: wrong variable (debug)> p task.args
{u'data': u'{{ wrong_var }}'}
[192.0.2.10] TASK: wrong variable (debug)> task.args['data'] = '{{ var1 }}'
[192.0.2.10] TASK: wrong variable (debug)> p task.args
{u'data': '{{ var1 }}'}
[192.0.2.10] TASK: wrong variable (debug)> redo
ok: [192.0.2.10]

PLAY RECAP *********************************************************************
192.0.2.10               : ok=1    changed=0    unreachable=0    failed=0
```

Changing the task arguments in the debugger to use `var1` instead of `wrong_var` makes the task run successfully.



## [Available debug commands](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id13)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#available-debug-commands)

You can use these seven commands at the debug prompt:

| Command                    | Shortcut    | Action                                              |
| -------------------------- | ----------- | --------------------------------------------------- |
| print                      | p           | Print information about the task                    |
| task.args[*key*] = *value* | no shortcut | Update module arguments                             |
| task_vars[*key*] = *value* | no shortcut | Update task variables (you must `update_task` next) |
| update_task                | u           | Recreate a task with updated task variables         |
| redo                       | r           | Run the task again                                  |
| continue                   | c           | Continue executing, starting with the next task     |
| quit                       | q           | Quit the debugger                                   |

For more details, see the individual descriptions and examples below.



### [Print command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id14)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#print-command)

`print *task/task.args/task_vars/host/result*` prints information about the task.

```
[192.0.2.10] TASK: install package (debug)> p task
TASK: install package
[192.0.2.10] TASK: install package (debug)> p task.args
{u'name': u'{{ pkg_name }}'}
[192.0.2.10] TASK: install package (debug)> p task_vars
{u'ansible_all_ipv4_addresses': [u'192.0.2.10'],
 u'ansible_architecture': u'x86_64',
 ...
}
[192.0.2.10] TASK: install package (debug)> p task_vars['pkg_name']
u'bash'
[192.0.2.10] TASK: install package (debug)> p host
192.0.2.10
[192.0.2.10] TASK: install package (debug)> p result._result
{'_ansible_no_log': False,
 'changed': False,
 u'failed': True,
 ...
 u'msg': u"No package matching 'not_exist' is available"}
```



### [Update args command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id15)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-args-command)

`task.args[*key*] = *value*` updates a module argument. This sample playbook has an invalid package name.

```
- hosts: test
  strategy: debug
  gather_facts: true
  vars:
    pkg_name: not_exist
  tasks:
    - name: Install a package
      ansible.builtin.apt: name={{ pkg_name }}
```

When you run the playbook, the invalid package name triggers an  error, and Ansible invokes the debugger. You can fix the package name by viewing, then updating the module argument.

```
[192.0.2.10] TASK: install package (debug)> p task.args
{u'name': u'{{ pkg_name }}'}
[192.0.2.10] TASK: install package (debug)> task.args['name'] = 'bash'
[192.0.2.10] TASK: install package (debug)> p task.args
{u'name': 'bash'}
[192.0.2.10] TASK: install package (debug)> redo
```

After you update the module argument, use `redo` to run the task again with the new args.



### [Update vars command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id16)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-vars-command)

`task_vars[*key*] = *value*` updates the `task_vars`. You could fix the playbook above by viewing, then updating the task variables instead of the module args.

```
[192.0.2.10] TASK: install package (debug)> p task_vars['pkg_name']
u'not_exist'
[192.0.2.10] TASK: install package (debug)> task_vars['pkg_name'] = 'bash'
[192.0.2.10] TASK: install package (debug)> p task_vars['pkg_name']
'bash'
[192.0.2.10] TASK: install package (debug)> update_task
[192.0.2.10] TASK: install package (debug)> redo
```

After you update the task variables, you must use `update_task` to load the new variables before using `redo` to run the task again.

Note

In 2.5 this was updated from `vars` to `task_vars` to avoid conflicts with the `vars()` python function.



### [Update task command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id17)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-task-command)

New in version 2.8.

`u` or `update_task` recreates the task from the original task data structure and templates with updated task variables. See the entry [Update vars command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#update-vars-command) for an example of use.



### [Redo command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id18)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#redo-command)

`r` or `redo` runs the task again.



### [Continue command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id19)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#continue-command)

`c` or `continue` continues executing, starting with the next task.



### [Quit command](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id20)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#quit-command)

`q` or `quit` quits the debugger. The playbook execution is aborted.

## [How the debugger interacts with the free strategy](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#id21)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#how-the-debugger-interacts-with-the-free-strategy)

With the default `linear` strategy enabled, Ansible halts execution while the debugger is active, and runs the debugged task immediately after you enter the `redo` command. With the `free` strategy enabled, however, Ansible does not wait for all hosts, and may queue later tasks on one host before a task fails on another host. With the `free` strategy, Ansible does not queue or execute any tasks while the  debugger is active. However, all queued tasks remain in the queue and  run as soon as you exit the debugger. If you use `redo` to reschedule a task from the debugger, other queued tasks may execute  before your rescheduled task. For more information about strategies, see [Controlling playbook execution: strategies and more](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#playbooks-strategies).

### Asynchronous actions and polling[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#asynchronous-actions-and-polling)

By default Ansible runs tasks synchronously, holding the connection  to the remote node open until the action is completed. This means within a playbook, each task blocks the next task by default, meaning  subsequent tasks will not run until the current task completes. This  behavior can create challenges. For example, a task may take longer to  complete than the SSH session allows for, causing a timeout. Or you may  want a long-running process to execute in the background while you  perform other tasks concurrently. Asynchronous mode lets you control how long-running tasks execute.

- [Asynchronous ad hoc tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#asynchronous-ad-hoc-tasks)
- [Asynchronous playbook tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#asynchronous-playbook-tasks)
  - [Avoid connection timeouts: poll > 0](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#avoid-connection-timeouts-poll-0)
  - [Run tasks concurrently: poll = 0](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#run-tasks-concurrently-poll-0)

## [Asynchronous ad hoc tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#id1)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#asynchronous-ad-hoc-tasks)

You can execute long-running operations in the background with [ad hoc tasks](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html#intro-adhoc). For example, to execute `long_running_operation` asynchronously in the background, with a timeout (`-B`) of 3600 seconds, and without polling (`-P`):

```
$ ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"
```

To check on the job status later, use the `async_status` module, passing it the job ID that was returned when you ran the original job in the background:

```
$ ansible web1.example.com -m async_status -a "jid=488359678239.2844"
```

Ansible can also check on the status of your long-running job  automatically with polling. In most cases, Ansible will keep the  connection to your remote node open between polls. To run for 30 minutes and poll for status every 60 seconds:

```
$ ansible all -B 1800 -P 60 -a "/usr/bin/long_running_operation --do-stuff"
```

Poll mode is smart so all jobs will be started before polling begins on any machine. Be sure to use a high enough `--forks` value if you want to get all of your jobs started very quickly. After the time limit (in seconds) runs out (`-B`), the process on the remote nodes will be terminated.

Asynchronous mode is best suited to long-running shell commands or  software upgrades. Running the copy module asynchronously, for example,  does not do a background file transfer.

## [Asynchronous playbook tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#id2)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#asynchronous-playbook-tasks)

[Playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks.html#working-with-playbooks) also support asynchronous mode and polling, with a simplified syntax.  You can use asynchronous mode in playbooks to avoid connection timeouts  or to avoid blocking subsequent tasks. The behavior of asynchronous mode in a playbook depends on the value of poll.

### [Avoid connection timeouts: poll > 0](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#avoid-connection-timeouts-poll-0)

If you want to set a longer timeout limit for a certain task in your playbook, use `async` with `poll` set to a positive value. Ansible will still block the next task in your playbook, waiting until the async task either completes, fails or times out. However, the task will only time out if it exceeds the timeout  limit you set with the `async` parameter.

To avoid timeouts on a task, specify its maximum runtime and how frequently you would like to poll for status:

```
---

- hosts: all
  remote_user: root

  tasks:

  - name: Simulate long running op (15 sec), wait for up to 45 sec, poll every 5 sec
    ansible.builtin.command: /bin/sleep 15
    async: 45
    poll: 5
```

Note

The default poll value is set by the [DEFAULT_POLL_INTERVAL](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-poll-interval) setting. There is no default for the async time limit.  If you leave off the ‘async’ keyword, the task runs synchronously, which is Ansible’s default.

Note

As of Ansible 2.3, async does not support check mode and will fail the task when run in check mode. See [Validating tasks: check mode and diff mode](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html#check-mode-dry) on how to skip a task in check mode.

Note

When an async task completes with polling enabled, the temporary async job cache file (by default in ~/.ansible_async/) is automatically removed.

### [Run tasks concurrently: poll = 0](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html#run-tasks-concurrently-poll-0)

If you want to run multiple tasks in a playbook concurrently, use `async` with `poll` set to 0. When you set `poll: 0`, Ansible starts the task and immediately moves on to the next task  without waiting for a result. Each async task runs until it either  completes, fails or times out (runs longer than its `async` value). The playbook run ends without checking back on async tasks.

To run a playbook task asynchronously:

```
---

- hosts: all
  remote_user: root

  tasks:

  - name: Simulate long running op, allow to run for 45 sec, fire and forget
    ansible.builtin.command: /bin/sleep 15
    async: 45
    poll: 0
```

Note

Do not specify a poll value of 0 with operations that require  exclusive locks (such as yum transactions) if you expect to run other  commands later in the playbook against those same resources.

Note

Using a higher value for `--forks` will result in kicking off asynchronous tasks even faster. This also increases the efficiency of polling.

Note

When running with `poll: 0`, Ansible will not automatically cleanup the async job cache file. You will need to manually clean this up with the [async_status](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/async_status_module.html#async-status-module) module with `mode: cleanup`.

If you need a synchronization point with an async task, you can register it to obtain its job ID and use the [async_status](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/async_status_module.html#async-status-module) module to observe it in a later task. For example:

```
- name: Run an async task
  ansible.builtin.yum:
    name: docker-io
    state: present
  async: 1000
  poll: 0
  register: yum_sleeper

- name: Check on an async task
  async_status:
    jid: "{{ yum_sleeper.ansible_job_id }}"
  register: job_result
  until: job_result.finished
  retries: 100
  delay: 10
```

Note

If the value of `async:` is not high enough, this will cause the “check on it later” task to fail because the temporary status file that the `async_status:` is looking for will not have been written or no longer exist

Note

Asynchronous playbook tasks always return changed. If the task is using a module that requires the user to annotate changes with `changed_when`, `creates`,  and so on, then those should be added to the following `async_status` task.

To run multiple asynchronous tasks while limiting the number of tasks running concurrently:

```
#####################
# main.yml
#####################
- name: Run items asynchronously in batch of two items
  vars:
    sleep_durations:
      - 1
      - 2
      - 3
      - 4
      - 5
    durations: "{{ item }}"
  include_tasks: execute_batch.yml
  loop: "{{ sleep_durations | batch(2) | list }}"

#####################
# execute_batch.yml
#####################
- name: Async sleeping for batched_items
  ansible.builtin.command: sleep {{ async_item }}
  async: 45
  poll: 0
  loop: "{{ durations }}"
  loop_control:
    loop_var: "async_item"
  register: async_results

- name: Check sync status
  async_status:
    jid: "{{ async_result_item.ansible_job_id }}"
  loop: "{{ async_results.results }}"
  loop_control:
    loop_var: "async_result_item"
  register: async_poll_results
  until: async_poll_results.finished
  retries: 30
```

### Controlling playbook execution: strategies and more[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#controlling-playbook-execution-strategies-and-more)

By default, Ansible runs each task on all hosts affected by a play  before starting the next task on any host, using 5 forks. If you want to change this default behavior, you can use a different strategy plugin,  change the number of forks, or apply one of several keywords like `serial`.

- [Selecting a strategy](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#selecting-a-strategy)
- [Setting the number of forks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#setting-the-number-of-forks)
- [Using keywords to control execution](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#using-keywords-to-control-execution)
  - [Setting the batch size with `serial`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#setting-the-batch-size-with-serial)
  - [Restricting execution with `throttle`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#restricting-execution-with-throttle)
  - [Ordering execution based on inventory](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#ordering-execution-based-on-inventory)
  - [Running on a single machine with `run_once`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#running-on-a-single-machine-with-run-once)

## [Selecting a strategy](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id1)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#selecting-a-strategy)

The default behavior described above is the [linear strategy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/linear_strategy.html#linear-strategy). Ansible offers other strategies, including the [debug strategy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_strategy.html#debug-strategy) (see also  [Debugging tasks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_debugger.html#playbook-debugger)) and the [free strategy](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/free_strategy.html#free-strategy), which allows each host to run until the end of the play as fast as it can:

```
- hosts: all
  strategy: free
  tasks:
  # ...
```

You can select a different strategy for each play as shown above, or set your preferred strategy globally in `ansible.cfg`, under the `defaults` stanza:

```
[defaults]
strategy = free
```

All strategies are implemented as [strategy plugins](https://docs.ansible.com/ansible/latest/plugins/strategy.html#strategy-plugins). Please review the documentation for each strategy plugin for details on how it works.

## [Setting the number of forks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id2)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#setting-the-number-of-forks)

If you have the processing power available and want to use more forks, you can set the number in `ansible.cfg`:

```
[defaults]
forks = 30
```

or pass it on the command line: ansible-playbook -f 30 my_playbook.yml.

## [Using keywords to control execution](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id3)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#using-keywords-to-control-execution)

In addition to strategies, several [keywords](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#playbook-keywords) also affect play execution. You can set a number, a percentage, or a  list of numbers of hosts you want to manage at a time with `serial`. Ansible completes the play on the specified number or percentage of  hosts before starting the next batch of hosts. You can restrict the  number of workers allotted to a block or task with `throttle`. You can control how Ansible selects the next host in a group to execute against with `order`. You can run a task on a single host with `run_once`. These keywords are not strategies. They are directives or options applied to a play, block, or task.

Other keywords that affect play execution include `ignore_errors`, `ignore_unreachable`, and `any_errors_fatal`. These options are documented in [Error handling in playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_error_handling.html#playbooks-error-handling).



### [Setting the batch size with `serial`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id4)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#setting-the-batch-size-with-serial)

By default, Ansible runs in parallel against all the hosts in the [pattern](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html#intro-patterns) you set in the `hosts:` field of each play. If you want to manage only a few machines at a  time, for example during a rolling update, you can define how many hosts Ansible should manage at a single time using the `serial` keyword:

```
---
- name: test play
  hosts: webservers
  serial: 3
  gather_facts: False

  tasks:
    - name: first task
      command: hostname
    - name: second task
      command: hostname
```

In the above example, if we had 6 hosts in the group ‘webservers’,  Ansible would execute the play completely (both tasks) on 3 of the hosts before moving on to the next 3 hosts:

```
PLAY [webservers] ****************************************

TASK [first task] ****************************************
changed: [web3]
changed: [web2]
changed: [web1]

TASK [second task] ***************************************
changed: [web1]
changed: [web2]
changed: [web3]

PLAY [webservers] ****************************************

TASK [first task] ****************************************
changed: [web4]
changed: [web5]
changed: [web6]

TASK [second task] ***************************************
changed: [web4]
changed: [web5]
changed: [web6]

PLAY RECAP ***********************************************
web1      : ok=2    changed=2    unreachable=0    failed=0
web2      : ok=2    changed=2    unreachable=0    failed=0
web3      : ok=2    changed=2    unreachable=0    failed=0
web4      : ok=2    changed=2    unreachable=0    failed=0
web5      : ok=2    changed=2    unreachable=0    failed=0
web6      : ok=2    changed=2    unreachable=0    failed=0
```

Note

Setting the batch size with `serial` changes the scope of the Ansible failures to the batch size, not the entire host list. You can use  [ignore_unreachable](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_error_handling.html#ignore-unreachable) or [max_fail_percentage](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_error_handling.html#maximum-failure-percentage) to modify this behavior.

You can also specify a percentage with the `serial` keyword. Ansible applies the percentage to the total number of hosts in a play to determine the number of hosts per pass:

```
---
- name: test play
  hosts: webservers
  serial: "30%"
```

If the number of hosts does not divide equally into the number of  passes, the final pass contains the remainder. In this example, if you  had 20 hosts in the webservers group, the first batch would contain 6  hosts, the second batch would contain 6 hosts, the third batch would  contain 6 hosts, and the last batch would contain 2 hosts.

You can also specify batch sizes as a list. For example:

```
---
- name: test play
  hosts: webservers
  serial:
    - 1
    - 5
    - 10
```

In the above example, the first batch would contain a single host,  the next would contain 5 hosts, and (if there are any hosts left), every following batch would contain either 10 hosts or all the remaining  hosts, if fewer than 10 hosts remained.

You can list multiple batch sizes as percentages:

```
---
- name: test play
  hosts: webservers
  serial:
    - "10%"
    - "20%"
    - "100%"
```

You can also mix and match the values:

```
---
- name: test play
  hosts: webservers
  serial:
    - 1
    - 5
    - "20%"
```

Note

No matter how small the percentage, the number of hosts per pass will always be 1 or greater.

### [Restricting execution with `throttle`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id5)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#restricting-execution-with-throttle)

The `throttle` keyword limits the number of workers for a particular task. It can be set at the block and task level. Use `throttle` to restrict tasks that may be CPU-intensive or interact with a rate-limiting API:

```
tasks:
- command: /path/to/cpu_intensive_command
  throttle: 1
```

If you have already restricted the number of forks or the number of  machines to execute against in parallel, you can reduce the number of  workers with `throttle`, but you cannot increase it. In other words, to have an effect, your `throttle` setting must be lower than your `forks` or `serial` setting if you are using them together.

### [Ordering execution based on inventory](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id6)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#ordering-execution-based-on-inventory)

The `order` keyword controls the order in which hosts are run. Possible values for order are:

- inventory:

  (default) The order provided by the inventory for the selection requested (see note below)

- reverse_inventory:

  The same as above, but reversing the returned list

- sorted:

  Sorted alphabetically sorted by name

- reverse_sorted:

  Sorted by name in reverse alphabetical order

- shuffle:

  Randomly ordered on each run

Note

the ‘inventory’ order does not equate to the order in which  hosts/groups are defined in the inventory source file, but the ‘order in which a selection is returned from the compiled inventory’. This is a  backwards compatible option and while reproducible it is not normally  predictable. Due to the nature of inventory, host patterns, limits,  inventory plugins and the ability to allow multiple sources it is almost impossible to return such an order. For simple cases this might happen  to match the file definition order, but that is not guaranteed.



### [Running on a single machine with `run_once`](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#id7)[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_strategies.html#running-on-a-single-machine-with-run-once)

If you want a task to run only on the first host in your batch of hosts, set `run_once` to true on that task:

```
---
# ...

  tasks:

    # ...

    - command: /opt/application/upgrade_db.py
      run_once: true

    # ...
```

Ansible executes this task on the first host in the current batch and applies all results and facts to all the hosts in the same batch. This  approach is similar to applying a conditional to a task such as:

```
- command: /opt/application/upgrade_db.py
  when: inventory_hostname == webservers[0]
```

However, with `run_once`, the results are applied to all the hosts. To run the task on a specific host, instead of the first host in the batch, delegate the task:

```
- command: /opt/application/upgrade_db.py
  run_once: true
  delegate_to: web01.example.org
```

As always with [delegation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_delegation.html#playbooks-delegation), the action will be executed on the delegated host, but the information is still that of the original host in the task.

Note

When used together with `serial`, tasks marked as `run_once` will be run on one host in *each* serial batch. If the task must run only once regardless of `serial` mode, use `when: inventory_hostname == ansible_play_hosts_all[0]` construct.

Note

Any conditional (in other words, when:) will use the variables of the ‘first host’ to decide if the task runs or not, no other hosts will be tested.

Note

If you want to avoid the default behavior of setting the fact for all hosts, set `delegate_facts: True` for the specific task or block.

## Advanced playbook syntax[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_advanced_syntax.html#advanced-playbook-syntax)

The advanced YAML syntax examples on this page give you more control over the data placed in YAML files used by Ansible. You can find additional information about Python-specific YAML in the official [PyYAML Documentation](https://pyyaml.org/wiki/PyYAMLDocumentation#YAMLtagsandPythontypes).

### Unsafe or raw strings[](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_advanced_syntax.html#unsafe-or-raw-strings)

When handling values returned by lookup plugins, Ansible uses a data type called `unsafe` to block templating. Marking data as unsafe prevents malicious users  from abusing Jinja2 templates to execute arbitrary code on target  machines. The Ansible implementation ensures that unsafe values are  never templated. It is more comprehensive than escaping Jinja2 with `{% raw %} ... {% endraw %}` tags.

You can use the same `unsafe` data type in variables you define, to prevent templating errors and information disclosure. You can mark values supplied by [vars_prompts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html#unsafe-prompts) as unsafe. You can also use `unsafe` in playbooks. The most common use cases include passwords that allow special characters like `{` or `%`, and JSON arguments that look like templates but should not be templated. For example:

```
---
mypassword: !unsafe 234%234{435lkj{{lkjsdf
```

In a playbook:

```
---
hosts: all
vars:
    my_unsafe_variable: !unsafe 'unsafe % value'
tasks:
    ...
```

For complex variables such as hashes or arrays, use `!unsafe` on the individual elements:

```
---
my_unsafe_array:
    - !unsafe 'unsafe element'
    - 'safe element'

my_unsafe_hash:
    unsafe_key: !unsafe 'unsafe value'
```

### YAML anchors and aliases: sharing variable values

[YAML anchors and aliases](https://yaml.org/spec/1.2/spec.html#id2765878) help you define, maintain, and use shared variable values in a flexible way. You define an anchor with `&`, then refer to it using an alias, denoted with `*`. Here’s an example that sets three values with an anchor, uses two of  those values with an alias, and overrides the third value:

```
---
...
vars:
    app1:
        jvm: &jvm_opts
            opts: '-Xms1G -Xmx2G'
            port: 1000
            path: /usr/lib/app1
    app2:
        jvm:
            <<: *jvm_opts
            path: /usr/lib/app2
...
```

Here, `app1` and `app2` share the values for `opts` and `port` using the anchor `&jvm_opts` and the alias `*jvm_opts`. The value for `path` is merged by `<<` or [merge operator](https://yaml.org/type/merge.html).

Anchors and aliases also let you share complex sets of variable  values, including nested variables. If you have one variable value that  includes another variable value, you can define them separately:

```
vars:
  webapp_version: 1.0
  webapp_custom_name: ToDo_App-1.0
```

This is inefficient and, at scale, means more maintenance. To  incorporate the version value in the name, you can use an anchor in `app_version` and an alias in `custom_name`:

```
vars:
  webapp:
      version: &my_version 1.0
      custom_name:
          - "ToDo_App"
          - *my_version
```

Now, you can re-use the value of `app_version` within the value of  `custom_name` and use the output in a template:

```
---
- name: Using values nested inside dictionary
  hosts: localhost
  vars:
    webapp:
        version: &my_version 1.0
        custom_name:
            - "ToDo_App"
            - *my_version
  tasks:
  - name: Using Anchor value
    ansible.builtin.debug:
        msg: My app is called "{{ webapp.custom_name | join('-') }}".
```

You’ve anchored the value of `version` with the `&my_version` anchor, and re-used it with the `*my_version` alias. Anchors and aliases let you access nested values inside dictionaries.

## Manipulating data

In many cases, you need to do some complex operation with your  variables, while Ansible is not recommended as a data  processing/manipulation tool, you can use the existing Jinja2 templating in conjunction with the many added Ansible filters, lookups and tests  to do some very complex transformations.

- Let’s start with a quick definition of each type of plugin:

  lookups: Mainly used to query ‘external data’, in Ansible these were the primary part of loops using the `with_<lookup>` construct, but they can be used independently to return data for  processing. They normally return a list due to their primary function in loops as mentioned previously. Used with the `lookup` or `query` Jinja2 operators. filters: used to change/transform data, used with the `|` Jinja2 operator. tests: used to validate data, used with the `is` Jinja2 operator.

### Loops and list comprehensions

Most programming languages have loops (`for`, `while`, and so on) and list comprehensions to do transformations on lists  including lists of objects. Jinja2 has a few filters that provide this  functionality: `map`, `select`, `reject`, `selectattr`, `rejectattr`.

- map: this is a basic for loop that just allows you to change  every item in a list, using the ‘attribute’ keyword you can do the  transformation based on attributes of the list elements.
- select/reject: this is a for loop with a condition, that allows  you to create a subset of a list that matches (or not) based on the  result of the condition.
- selectattr/rejectattr: very similar to the above but it uses a  specific attribute of the list elements for the conditional statement.

Use a loop to create exponential backoff for retries/until.

```
- name: retry ping 10 times with exponential backoff delay
  ping:
  retries: 10
  delay: '{{item|int}}'
  loop: '{{ range(1, 10)|map("pow", 2) }}'
```

#### Extract keys from a dictionary matching elements from a list

The Python equivalent code would be:

```
chains = [1, 2]
for chain in chains:
    for config in chains_config[chain]['configs']:
        print(config['type'])
```

There are several ways to do it in Ansible, this is just one example:

Way to extract matching keys from a list of dictionaries[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id4)

```
 tasks:
   - name: Show extracted list of keys from a list of dictionaries
     ansible.builtin.debug:
       msg: "{{ chains | map('extract', chains_config) | map(attribute='configs') | flatten | map(attribute='type') | flatten }}"
     vars:
       chains: [1, 2]
       chains_config:
           1:
               foo: bar
               configs:
                   - type: routed
                     version: 0.1
                   - type: bridged
                     version: 0.2
           2:
               foo: baz
               configs:
                   - type: routed
                     version: 1.0
                   - type: bridged
                     version: 1.1
```

Results of debug task, a list with the extracted keys[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id5)

```
   ok: [localhost] => {
       "msg": [
           "routed",
           "bridged",
           "routed",
           "bridged"
       ]
   }
```

Get the unique list of values of a variable that vary per host[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id6)

```
   vars:
       unique_value_list: "{{ groups['all'] | map ('extract', hostvars, 'varname') | list | unique}}"
```

#### Find mount point

In this case, we want to find the mount point for a given path across our machines, since we already collect mount facts, we can use the  following:

Use selectattr to filter mounts into list I can then sort and select the last from[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id7)

```
  - hosts: all
    gather_facts: True
    vars:
       path: /var/lib/cache
    tasks:
    - name: The mount point for {{path}}, found using the Ansible mount facts, [-1] is the same as the 'last' filter
      ansible.builtin.debug:
       msg: "{{(ansible_facts.mounts | selectattr('mount', 'in', path) | list | sort(attribute='mount'))[-1]['mount']}}"
```

#### Omit elements from a list

The special `omit` variable ONLY works with module options, but we can still use it in other ways as an identifier to tailor a list of elements:

Inline list filtering when feeding a module option[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id8)

```
   - name: Enable a list of Windows features, by name
     ansible.builtin.set_fact:
       win_feature_list: "{{ namestuff | reject('equalto', omit) | list }}"
     vars:
       namestuff:
         - "{{ (fs_installed_smb_v1 | default(False)) | ternary(omit, 'FS-SMB1') }}"
         - "foo"
         - "bar"
```

Another way is to avoid adding elements to the list in the first place, so you can just use it directly:

Using set_fact in a loop to increment a list conditionally[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id9)

```
   - name: Build unique list with some items conditionally omitted
     ansible.builtin.set_fact:
        namestuff: ' {{ (namestuff | default([])) | union([item]) }}'
     when: item != omit
     loop:
         - "{{ (fs_installed_smb_v1 | default(False)) | ternary(omit, 'FS-SMB1') }}"
         - "foo"
         - "bar"
```

#### Combine values from same list of dicts

Combining positive and negative filters from examples above, you can  get a ‘value when it exists’ and a ‘fallback’ when it doesn’t.

Use selectattr and rejectattr to get the ansible_host or inventory_hostname as needed[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id10)

```
   - hosts: localhost
     tasks:
       - name: Check hosts in inventory that respond to ssh port
         wait_for:
           host: "{{ item }}"
           port: 22
         loop: '{{ has_ah + no_ah }}'
         vars:
           has_ah: '{{ hostvars|dictsort|selectattr("1.ansible_host", "defined")|map(attribute="1.ansible_host")|list }}'
           no_ah: '{{ hostvars|dictsort|rejectattr("1.ansible_host", "defined")|map(attribute="0")|list }}'
```

#### Custom Fileglob Based on a Variable

This example uses [Python argument list unpacking](https://docs.python.org/3/tutorial/controlflow.html#unpacking-argument-lists) to create a custom list of fileglobs based on a variable.

Using fileglob with a list based on a variable.

```
  - hosts: all
    vars:
      mygroups:
        - prod
        - web
    tasks:
      - name: Copy a glob of files based on a list of groups
        copy:
          src: "{{ item }}"
          dest: "/tmp/{{ item }}"
        loop: '{{ q("fileglob", *globlist) }}'
        vars:
          globlist: '{{ mygroups | map("regex_replace", "^(.*)$", "files/\1/*.conf") | list }}'
```

### Complex Type transformations

Jinja provides filters for simple data type transformations (`int`, `bool`, and so on), but when you want to transform data structures things are  not as easy. You can use loops and list comprehensions as shown above to help, also  other filters and lookups can be chained and used to achieve more  complex transformations.

#### Create dictionary from list

In most languages it is easy to create a dictionary (a.k.a.  map/associative array/hash and so on) from a list of pairs, in Ansible  there are a couple of ways to do it and the best one for you might  depend on the source of your data.

These example produces `{"a": "b", "c": "d"}`

Simple list to dict by assuming the list is [key, value , key, value, …][](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id12)

```
 vars:
     single_list: [ 'a', 'b', 'c', 'd' ]
     mydict: "{{ dict(single_list | slice(2)) }}"
```

It is simpler when we have a list of pairs:[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id13)

```
 vars:
     list_of_pairs: [ ['a', 'b'], ['c', 'd'] ]
     mydict: "{{ dict(list_of_pairs) }}"
```

Both end up being the same thing, with `slice(2)` transforming `single_list` to a `list_of_pairs` generator.

A bit more complex, using `set_fact` and a `loop` to create/update a dictionary with key value pairs from 2 lists:

Using set_fact to create a dictionary from a set of lists[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id14)

```
    - name: Uses 'combine' to update the dictionary and 'zip' to make pairs of both lists
      ansible.builtin.set_fact:
        mydict: "{{ mydict | default({}) | combine({item[0]: item[1]}) }}"
      loop: "{{ (keys | zip(values)) | list }}"
      vars:
        keys:
          - foo
          - var
          - bar
        values:
          - a
          - b
          - c
```

This results in `{"foo": "a", "var": "b", "bar": "c"}`.

You can even combine these simple examples with other filters and  lookups to create a dictionary dynamically by matching patterns to  variable names:

Using ‘vars’ to define dictionary from a set of lists without needing a task[](https://docs.ansible.com/ansible/latest/playbook_guide/complex_data_manipulation.html#id15)

```
   vars:
       xyz_stuff: 1234
       xyz_morestuff: 567
       myvarnames: "{{ q('varnames', '^xyz_') }}"
       mydict: "{{ dict(myvarnames|map('regex_replace', '^xyz_', '')|list | zip(q('vars', *myvarnames))) }}"
```

A quick explanation, since there is a lot to unpack from these two lines:

> - The `varnames` lookup returns a list of variables that match “begin with `xyz_`”.
> - Then feeding the list from the previous step into the `vars` lookup to get the list of values. The `*` is used to ‘dereference the list’ (a pythonism that works in Jinja), otherwise it would take the list as a single argument.
> - Both lists get passed to the `zip` filter to pair them off into a unified list (key, value, key2, value2, …).
> - The dict function then takes this ‘list of pairs’ to create the dictionary.

An example on how to use facts to find a host’s data that meets condition X:

```
vars:
  uptime_of_host_most_recently_rebooted: "{{ansible_play_hosts_all | map('extract', hostvars, 'ansible_uptime_seconds') | sort | first}}"
```

An example to show a host uptime in days/hours/minutes/seconds (assumes facts where gathered).

```
- name: Show the uptime in days/hours/minutes/seconds
  ansible.builtin.debug:
   msg: Uptime {{ now().replace(microsecond=0) - now().fromtimestamp(now(fmt='%s') | int - ansible_uptime_seconds) }}
```