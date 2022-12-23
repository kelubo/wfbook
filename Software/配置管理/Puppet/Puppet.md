# Puppet

[TOC]

## 概述

https://puppet.com/

Puppet 提供了自动化管理基础设施的工具。Puppet 是一个开源产品，拥有活跃的用户和贡献者社区。可以通过修复 bug 、影响新的功能方向、发布模块以及与社区分享知识和专业知识来参与其中。

用 Ruby 语言开发。

当使用 Puppet 时，您可以定义要管理的基础架构中系统的所需状态。可以通过使用 Puppet 的领域特定语言（DSL）编写基础结构代码来实现这一点，Puppet 代码可以用于各种设备和操作系统。Puppet 代码是声明性的，这意味着描述了系统的所需状态，而不是达到所需的步骤。然后，Puppet 自动化了使这些系统进入该状态并将其保持在该状态的过程。Puppet 通过 Puppet 主服务器和 Puppet 代理执行此操作。Puppet 主服务器是存储定义所需状态的代码的服务器。Puppet 代理将您的代码转换为命令，然后在您指定的系统上执行它，这就是所谓的Puppet 运行。

下图显示了 Puppet 是如何工作的。

 ![](../../../Image/p/puppet_run.png)

在您的环境中实现Puppet这样的声明性配置工具有很多好处——最明显的是一致性和自动化。

- **一致性**

  解决服务器问题是一个耗时且人工密集的过程。如果没有配置管理，you are unable to make assumptions about your infrastructure您就无法对您的基础架构进行假设，例如您使用的是哪种版本的 Apache ，whether your colleague configured the machine to follow all the manual steps correctly.或者您的同事是否将机器配置为正确遵循所有手动步骤。但是当您使用配置管理时，您可以验证 Puppet 是否应用了所需的状态。然后，您可以假设状态已应用，帮助您确定模型失败的原因和不完整的部分，并在过程中节省宝贵的时间。最重要的是，一旦你弄清楚了，你就可以将缺失的部分添加到你的模型中，确保你再也不用处理同样的问题了。

- **自动化**

  当您管理基础架构中的一组服务器时，您希望将它们保持在特定状态。如果您只需要管理 10 台同类服务器，则可以使用脚本或手动进入每台服务器。在这种情况下，像 Puppet 这样的工具可能不会提供太多额外的价值。但是，如果您有 100 或 1000 台服务器、一个混合环境，或者您有计划在未来扩展基础架构，那么很难手动执行此操作。这就是 Puppet 可以帮助您的地方-为您节省时间和金钱，有效地扩展，并安全地做到这一点。

## 关键概念

使用 Puppet 不仅是关于工具，而且是关于不同的文化和工作方式。以下概念和实践是使用 Puppet 并成功使用 Puppet 的关键。

### Infrastructure-as-code 基础设施代码

Puppet 建立在基础设施作为代码的概念之上，这是将基础设施视为代码的做法。这个概念是 DevOps 的基础，DevOps 是将软件开发和操作相结合的实践。将基础设施视为代码意味着系统管理员采用传统上与软件开发人员相关的实践，如版本控制、同行评审、自动化测试和持续交付。这些测试代码的实践正在有效地测试您的基础架构。当您在自动化过程中走得更远时，您可以选择编写自己的单元测试和验收测试，这些测试可以验证您的代码和基础架构的更改是否符合您的预期。

### 幂等性

Puppet 的一个关键特性是幂等性，即重复应用代码以保证系统达到所需状态的能力，同时保证每次都会得到相同的结果。幂等性是 Puppet 持续运行的原因。它确保基础结构的状态始终与所需的状态匹配。如果系统状态与您描述的不同，Puppet 会将其恢复到预期状态。这也意味着，如果您更改了所需的状态，整个基础结构将自动更新以匹配。

### 敏捷方法论

当采用像 Puppet 这样的工具时，您将更成功地使用敏捷的方法——在增量工作单元中工作并重用代码。试图一次做太多是一个常见的陷阱。你对 Puppet 越熟悉，你就越能扩展，你越习惯敏捷方法，你就可以让工作民主化。当您与同事共享共同的方法、共同的管道和共同的语言（Puppet 语言）时，您的组织在快速、安全地部署更改方面会更加高效。

### Git 和版本控制

虽然使用 Puppet 不需要版本控制，但强烈建议您将 Puppe t代码存储在 Git 存储库中。使用它将帮助您的团队获得 DevOps 和敏捷方法的好处

当您在 Git 存储库中开发和存储 Puppet 代码时，您可能会有多个分支-用于开发和测试代码的功能分支和用于发布代码的生产分支。在将功能分支合并到生产分支之前，测试功能分支上的所有代码。这个过程被称为 Git 流，允许您测试、跟踪和共享代码，从而更容易与同事协作。例如，如果您的团队中有人想要更改应用程序的防火墙要求，他们可以创建一个拉取请求，显示他们对现有代码的建议更改，您团队中的每个人都可以在将其推向生产之前对其进行审查。这个过程为可能导致停机的错误留下的空间要小得多。

## Puppet 平台

Puppet 由几个软件包组成。这些统称为 Puppet 平台，这是您用来管理、存储和运行 Puppet 代码的平台。这些软件包包括 `puppetserver`，`puppetdb`，和 `puppet-agent` （其中包括 Facter 和 Hiera ）。

Puppet 在agent-server代理-服务器架构中配置，其中主节点（系统）控制一个或多个受管理代理节点的配置信息。服务器和代理使用 SSL 证书通过 HTTPS 进行通信。Puppet 包含用于管理证书的内置证书颁发机构。Puppet Server 执行主节点的角色，并运行代理来配置自己。

Puppet agent 将代码转换为命令，然后在指定的系统上执行。

Facter 是 Puppet 的库存工具，它收集有关代理节点的信息，如主机名、IP 地址和操作系统。代理将这些事实以称为 manifest 的特殊 Puppet 代码文件的形式发送到主服务器。这是主服务器用来编译目录的信息——一个描述特定代理节点所需状态的 JSON 文档。每个代理请求并接收其自己的目录，然后在其运行的节点上强制执行所需的状态。通过这种方式，Puppet 在整个基础结构中应用更改，确保每个节点都与您用 Puppet 代码定义的状态相匹配。代理将报告发送回主服务器。

您将几乎所有 Puppet 代码（如清单）保存在模块中。每个模块都管理基础结构中的特定任务，例如安装和配置软件。模块包含代码和数据。数据允许您自定义配置。使用名为 Hiera 的工具，您可以将数据与代码分离，并将其放置在集中位置。这允许您specify guardrails 指定护栏并定义已知的参数和变体，以便您的代码完全可测试，并且可以验证参数的所有边缘情况。如果您刚刚加入一个使用 Puppet 的团队，请看看他们如何组织 Hiera 数据。

Puppet 生成的所有数据（例如事实、目录、报告）都存储在 Puppet 数据库（Puppet DB）中。将数据存储在 PuppetDB 中允许 Puppet 更快地工作，并为其他应用程序提供了访问 Puppet 收集数据的 API 。一旦 PuppetDB 充满了您的数据，它将成为基础设施发现、合规性报告、漏洞评估等方面的绝佳工具。您可以使用PuppetDB 查询执行所有这些任务。

下图显示了 Puppet 包组件是如何组合在一起的。![](../../../Image/p/puppet_platform.png)

## Puppet 生态系统

除了 Puppet 配置工具外，还有其他 Puppet 工具和资源可帮助您使用并获得成功。这些构成了 Puppet 生态系统。

### 从 Puppet Forge 安装现有模块

模块管理基础架构中的特定技术，并作为 Puppet 所需状态管理的基本构建块。在 Puppet  Forge 上，有一个模块可以管理基础设施的几乎任何部分。无论您想管理软件包还是修补操作系统，都已经为您设置了一个模块。有关安装说明、用法和代码示例，请参阅每个模块的自述文件。 

当使用 Forge 中的现有模块时，大部分 Puppet 代码都是为您编写的。您只需要安装模块及其依赖项，并编写少量代码（称为概要文件）将其联系在一起。

### 使用 Puppet 开发套件（PDK）开发现有或新模块

可以使用 Puppet 开发工具包（PDK）编写自己的 Puppet 代码和模块，这是一个成功构建、测试和验证模块的框架。请注意，大多数 Puppet 用户根本不必编写完整的 Puppet 代码，如果您愿意，也可以。

### 使用 VSCode 扩展编写 Puppet 代码

Puppet  VSCode 扩展使编写和管理 Puppet 代码更容易，并确保您的代码质量高。它的功能包括 Puppet DSL智能感知、linting 和内置命令。可以在 Windows、Linux 或 mac OS 上使用该扩展。

### 使用 Litmus 进行验收测试 

Litmus 是一个命令行工具，允许您针对各种操作系统和部署场景对 Puppet 模块运行验收测试。验收测试验证您的代码是否符合您的预期。

## 使用用例

Puppet Forge 具有现有的模块和代码示例，可帮助实现以下用例的自动化：

- **Base system configuration.** Including [registry](https://forge.puppet.com/puppetlabs/registry), [NTP](https://forge.puppet.com/puppetlabs/ntp), [firewalls](https://forge.puppet.com/puppetlabs/firewall), [services](https://forge.puppet.com/puppetlabs/service)
- **Manage web servers.** Including [apache](https://forge.puppet.com/puppetlabs/apache), [tomcat](https://forge.puppet.com/puppetlabs/tomcat), [IIS](https://forge.puppet.com/puppetlabs/iis), [nginx](https://forge.puppet.com/puppet/nginx)
- **Manage database systems.** Including [Oracle](https://forge.puppet.com/enterprisemodules/ora_config), [Microsoft SQL Server](https://forge.puppet.com/puppetlabs/sqlserver), [MySQL](https://forge.puppet.com/puppetlabs/mysql), [PostgreSQL](https://forge.puppet.com/puppetlabs/postgresql)
- **Manage middleware/application systems.** Including [Java](https://forge.puppet.com/puppetlabs/java), [WebLogic/Fusion](https://forge.puppet.com/enterprisemodules/wls_config), [IBM MQ](https://forge.puppet.com/enterprisemodules/mq_config), [IBM IIB](https://forge.puppet.com/enterprisemodules/iib_install), [RabbitMQ](https://forge.puppet.com/puppet/rabbitmq), [ActiveMQ](https://forge.puppet.com/puppetlabs/activemq), [Redis](https://forge.puppet.com/puppet/redis), [ElasticSearch](https://forge.puppet.com/elastic/elasticsearch)
- **Source control.** Including [Github](https://forge.puppet.com/enterprisemodules/github_config), [Gitlab](https://forge.puppet.com/puppet/gitlab)
- **Monitoring.** Including [Splunk](https://forge.puppet.com/puppetlabs/splunk_hec), [Nagios](https://forge.puppet.com/herculesteam/augeasproviders_nagios), [Zabbix](https://forge.puppet.com/puppet/zabbix), [Sensu](https://forge.puppet.com/sensu/sensu), [Prometheus](https://forge.puppet.com/puppet/prometheus), [NewRelic](https://forge.puppet.com/claranet/newrelic), [Icinga](https://forge.puppet.com/icinga/icinga2), [SNMP](https://forge.puppet.com/puppet/snmp)
- **Patch management.**                    [OS patching](https://forge.puppet.com/albatrossflavour/os_patching) on Enterprise Linux, Debian,                    SLES, Ubuntu, Windows
- Package management.
  - Linux: Puppet integrates directly with native package managers
  - Windows: Use Puppet to install software directly on Windows, or                            integrate with [Chocolatey](https://forge.puppet.com/puppetlabs/chocolatey)
- **Containers and cloud native.** Including [Docker](https://forge.puppet.com/puppetlabs/docker), [Kubernetes](https://forge.puppet.com/puppetlabs/kubernetes), [Terraform](https://forge.puppet.com/puppetlabs/terraform), [OpenShift](https://forge.puppet.com/openshift/openshift_origin)
- **Networking.** Including [Cisco Catalyst](https://forge.puppet.com/puppetlabs/cisco_ios), [Cisco Nexus](https://forge.puppet.com/puppetlabs/ciscopuppet), [F5](https://forge.puppet.com/f5/f5), [Palo Alto](https://forge.puppet.com/puppetlabs/panos), [Barracuda](https://forge.puppet.com/barracuda/cudawaf)
- **Secrets management.** Including [Hashicorp Vault](https://forge.puppet.com/puppetlabs/vault), [CyberArk Conjur](https://forge.puppet.com/cyberark/conjur), [Azure Key Vault](https://forge.puppet.com/tragiccode/azure_key_vault), [Consul Data](https://forge.puppet.com/ploperations/consul_data/readme)

See each module’s README for installation, usage, and code examples. 

If you don’t see your use case listed above, have a look at the following list to see            what else we might be able to help you with:

- **Continuous integration and delivery of Puppet                        code.**                    Continuous Delivery for Puppet Enterprise (PE) offers a                    prescriptive workflow to test and deploy Puppet                    code across environments. To harness the full power of PE, you need a robust system for testing and                    deploying your Puppet code. Continuous Delivery for PE offers prescriptive, customizable work flows                    and intuitive tools for Puppet code testing,                    deployment, and impact analysis — so you know how code changes will affect your                    infrastructure before you deploy them — helping you ship changes and additions                    with speed and confidence. For more information, see [CD4PE](https://puppet.com/resources/whitepaper/getting-started-continuous-delivery-puppet-enterprise). 
- **Incident remediation.** If you need to minimize the risk of external                    attacks and data breaches by increasing your visibility into the vulnerabilities                    across your infrastructure, take a look at Puppet Remediate. With                        Remediate, you can eliminate the repetitive                    and error-prone steps of manual data handovers between teams. For more                    information, see [Puppet                         Remediate](https://puppet.com/products/puppet-remediate/).
- **Integrate Puppet into your existing                        workflows.** Take a look at our integrations with other technology,                    including [Splunk](https://puppet.com/integrations/splunk/) and [VMware vRA](https://puppet.com/docs/vro/3.x/plugin_for_vmware_vra_user_guide.html). 

## 配置

在名为 `puppet.conf` 的主配置文件中自定义 Puppet 设置。

当 Puppet 文档提到“设置”时，它通常意味着主要设置。这些是配置参考中列出的设置。它们在 `puppet.conf` 中有效，可在命令行上使用。这些设置几乎配置了 Puppet 的所有核心功能。

但是，还有几个其他配置文件-如 `auth.conf` 和 `puppetdb.conf` 。这些文件存在的原因有几个：

- The main settings support only a few types of values. Some things just can’t be configured without complex data structures, so they needed separate files. (Authorization rules and custom CSR attributes are in this category.)

  主设置仅支持几种类型的值。有些东西没有复杂的数据结构就无法配置，因此需要单独的文件。（授权规则和自定义CSR属性属于此类别。）

- Puppet doesn’t allow extensions to add new settings to `puppet.conf`. This means some settings that are supposed to be main settings (such as the PuppetDB server) can’t be. 

  Puppet不允许扩展将新设置添加到Puppet.conf中。这意味着一些被认为是主要设置的设置（例如Puppet DB服务器）不能是。

### 启动时加载设置

当 Puppet 命令或服务启动时，它会获取所有设置的值。任何这些设置都可以更改命令或服务的行为方式。

命令或服务只读取其设置一次。如果需要重新配置，则必须重新启动服务或在更改设置后再次运行命令。

### 命令行中的设置

命令行中指定的设置具有最高优先级，并始终覆盖配置文件中的设置。启动命令或服务时，可以将任何设置指定为命令行选项。

Settings require two hyphens and the name of the setting on the command line:

设置需要两个连字符和命令行上的设置名称：          

```bash
sudo puppet agent --test --noop --certname temporary-name.example.com
```

### 基本设置

对于大多数设置，可以指定选项并在其后面添加一个值。两者之间的等号（=）是可选的，您可以选择将值放在引号中。

这三项都相当于在 `puppet.conf` 中设置 `certname = temporary-name.example.com` 。

```bash
--certname=temporary-name.example.com
--certname temporary-name.example.com
--certname "temporary-name.example.com"
```

### 布尔设置

仅有效值为 `true` 和 `false` 的设置使用较短的格式。仅指定该选项即可将设置设为 `true` 。在选项前面加上 `no-` 将其设置为 `false` 。

这意味着：

- `--noop` 相当于在  `puppet.conf` 中设置  `noop = true` 。 
- `--no-noop` 相当于在  `puppet.conf` 中设置 `noop = false` 。

### 默认值

如果未在命令行或 `puppet.conf` 中指定设置，则该设置将返回默认值。配置参考中列出了所有设置的默认值。

一些默认值基于其他设置 — 在这种情况下，默认值将使用其他设置作为变量显示（类似于 `$ssldir/certs` ）。

### 配置区域设置

Puppet supports locale-specific strings in output.This provides localized strings, report messages, and log messages                for the locale’s language when available.

Puppet 在输出中支持特定于语言环境的字符串，并从系统配置中检测您的语言环境。这将提供本地化字符串、报告消息和区域设置语言的日志消息（如果可用）。

启动后，Puppet 会在 *nix 系统上查找一组环境变量，或在 Windows 上查找代码页设置。当Puppet 找到已设置的语言环境时，无论是从命令行运行还是作为服务运行，它都会使用该语言环境。

#### 检查 *nix 和 macOS 上的区域设置

要检查当前的区域设置，请运行 `locale` 命令。这将输出当前 shell 使用的设置。     

```bash
$ locale
LANG="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL=
```

nd lists the set environment variables and searches for those                                        containingor `LC_`:

要查看系统支持哪些区域设置，请运行 `locale -a` ，它将输出可用区域设置的列表。请注意，Puppet 可能没有针对每个可用区域设置的本地化字符串。

To check the current status of environment variables that might conflict                                with or override your locale settings, 要检查可能与区域设置冲突或覆盖区域设置的环境变量的当前状态，请使用 `set` 命令。例如，此命令列出设置的环境变量，并搜索包含 `LANG` 或 `LC_` 的变量：

```bash
sudo set | egrep 'LANG|LC_'
```

#### 检查  Windows 上的区域设置

要检查当前的区域设置，请从 Power Shell 运行 `Get-WinSystemLocale` 命令。

```bash
PS C:\> Get-WinSystemLocale
LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)
```

To check your system’s current code page setting,要检查系统当前的代码页设置，请运行 `chcp` 命令。

#### 使用环境变量在 *nix 上设置区域设置

You can use environment variables to set your locale for processes                                started on the command line. 可以使用环境变量为在命令行上启动的进程设置区域设置。对于大多数 Linux 发行版，将 `LANG` 变量设置为首选语言环境，将 `LANGUAGE` 变量设置为空字符串。在 SLES 上，还将 `LC_ALL` 变量设置为空字符串。

例如，要将 SLES 上的终端会话的语言环境设置为日语：

```bash
export LANG=ja_JP.UTF-8
export LANGUAGE=''
export LC_ALL=''
```

要设置 Puppet 代理服务的区域设置，可以将这些 `export` 语句添加到：

* RHEL 及其衍生版上的 `/etc/sysconfig/puppet`
* Debian、Ubuntu及其衍生版上的 `/etc/default/puppet` 

更新文件后，重新启动 Puppet 服务以应用更改。

#### 在 macOS 上设置 Puppet 代理服务的区域设置

要在 macOS 上设置 Puppet 代理服务的区域设置，请更新 `/Library/LaunchDaemons/com.puppetlabs.puppet.plist` 文件中的 `LANG` 设置。                       

```html
<dict>
        <key>LANG</key>
        <string>ja_JP.UTF-8</string>
</dict>
```

更新文件后，重新启动 Puppet 服务以应用更改。

#### 在 Windows 上设置区域设置

在 Windows 上，Puppet 使用 `LANG` 环境变量（如果已设置）。如果没有，则使用配置的区域，如“区域”控制面板的“管理员”选项卡中所设置的。

在 Windows 10 上，可以使用 Power Shell 设置系统区域设置：

```bash
Set-WinSystemLocale en-US
```

#### 禁用国际化字符串

Use the optional Boolean `disable_i18n` setting to disable the use of                                internationalized strings. 使用可选的布尔禁用i18n设置来禁用国际化字符串的使用。您可以在 `puppet.conf` 中配置此设置。如果设置为 `true`，Puppet 将禁用日志消息、报告和部分命令行界面中的本地化字符串。这可以提高使用 Puppet 模块时的性能，尤其是在禁用环境缓存的情况下，即使您不需要本地化字符串或模块未本地化。在开源 Puppet 中，此设置默认为 `false`  。

如果遇到性能问题，请在主 Puppet 服务器 `puppet.conf` 文件的 `[server]` 部分配置此设置。要强制取消本地化的消息（默认情况下为英文），请在 `puppet.conf` 的节点的 `[main]` 或 `[user]` 部分中配置此部分。

### 配置文件

可以在名为 `puppet.conf` 的主配置文件中配置 Puppet 设置。对于新设置和需要在具有复杂数据结构的单独文件中的设置，还有几个附加配置文件。

* puppet.conf

  主配置文件。它配置所有 Puppet 命令和服务，包括 Puppet 代理、主要 Puppet 服务器、 Puppet apply 和  `puppetserver ca` 。配置参考中列出的几乎所有设置都可以在 `puppet.conf` 中设置。

* environment.conf

  Per-environment 设置。环境是独立的代理节点组。任何环境都可以包含 `environment.conf` 文件。每当主服务器为分配给该环境的节点提供服务时，该文件可以覆盖多个设置。

* fileserver.conf

  Custom fileserver mount points自定义文件服务器装载点

  fileserver.conf文件为Puppet的文件服务器配置自定义静态装载点。如果存在自定义装载点，则文件资源可以使用其源属性访问它们。The `fileserver.conf` file configures custom static mount points for Puppet’s file server. If custom mount points are present,             `file` resources can         access them with their `source` attributes.

* puppetdb.conf: PuppetDB server locationsPuppet DB服务器位置

  puppetdb.conf文件配置Puppet如何连接到一个或多个服务器。仅当您正在使用Puppet DB并已将主服务器连接到它时才使用它。

* The `puppetdb.conf` file configures how                         Puppet connects to one or more servers.                 It is only used if you are using PuppetDB and have                 connected your primary server to it. 

* autosign.conf: Basic certificate autosigning
  The `autosign.conf` file can allow certain         certificate requests to be automatically signed. It is only valid on the CA primary Puppet server; a primary server not serving as a CA does not             use `autosign.conf`. 

* 基本证书自动签名

  autosign.conf文件允许自动签署某些证书请求。它仅在CA主Puppet服务器上有效；不充当CA的主服务器不使用autosign.conf。

* csr_attributes.yaml: Certificate extensions
  The `csr_attributes.yaml` file defines custom data for new       certificate signing requests (CSRs).

* 证书扩展

  csr-attributes.yaml文件定义了新证书签名请求（csr）的自定义数据。

* custom_trusted_oid_mapping.yaml: Short names for cert extension OIDs
  The `custom_trusted_oid_mapping.yaml` file lets you set your own short     names for certificate extension object identifiers (OIDs), which can make the `$trusted` variable more     useful. 

* 证书扩展oid的缩写

  自定义可信oidmapping.yaml文件允许您为证书扩展对象标识符（oid）设置自己的短名称，这可以使$trusted变量更有用。

* device.conf: Network hardware access
  The `puppet-device` subcommand retrieves         catalogs from the primary Puppet server and applies them to         remote devices. Devices to be managed by the `puppet-device` subcommand are configured in `device.conf`. 

* 网络硬件访问

  puppet-device子命令从主puppet服务器检索目录并将其应用于远程设备。要由木偶设备子命令管理的设备在device.conf中配置。

* routes.yaml: Advanced plugin routing
  The `routes.yaml` file overrides configuration settings involving     indirector termini, and allows termini to be set in greater detail than `puppet.conf` allows.

* 高级插件路由

  routes.yaml文件覆盖了涉及indirector termini的配置设置，并允许比puppet.conf允许的更详细地设置termini。

#### `puppet.conf`

##### Sections

The `puppet.conf` file is Puppet’s main config file. It configures all of the Puppet commands and services, including Puppet agent, the primary Puppet server, Puppet apply, and `puppetserver ca`. Nearly all of the settings listed in the configuration        reference can be set in `puppet.conf`.

It resembles a standard INI file, with a few syntax extensions.            Settings can go into application-specific sections, or into a `[main]` section that affects all            applications.

For a complete list of Puppet's settings, see the [configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html). 

##### Location

The `puppet.conf` file is always located at `$confdir/puppet.conf`.

Although its location is configurable with the `config`                setting, it can be set only on the command line. For example:                

```
puppet agent -t --config ./temporary_config.confCopied!
```

The location of the `confdir` depends on your operating                system. See the [confdir documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for                details.

##### Examples

Example agent config: 

```
[main]
certname = agent01.example.com
server = puppet
runinterval = 1hCopied!
```

Example server config:                

```
[main]
certname = puppetserver01.example.com
server = puppet
runinterval = 1h
strict_variables = true

[server]
dns_alt_names = primaryserver01,primaryserver01.example.com,puppet,puppet.example.com
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = trueCopied!
```

##### Format

The `puppet.conf` file consists of one or more config                sections, each of which can contain any number of settings.

The file can also include comment lines at any point.

##### Config sections

```
[main]
    certname = primaryserver01.example.comCopied!
```

A config section is a group of                settings. It consists of: 

- Its name, enclosed in square brackets. The `[name]` of the config section must be on its own line, with no                        leading space.
- Any number of setting lines, which can be indented for readability.
- Any number of empty lines or comment lines

As soon as a new config section `[name]` appears in the                file, the former config section is closed and the new one begins. A given config                section only occurs one time in the file.

​                Puppet uses four config sections:

- ​                        `main` is the global section used by all                        commands and services. It can be overridden by the other sections.

- ​                        `server` is used by the primary Puppet server service and the Puppet Server                        `ca` command.

  Important: Be sure to apply settings only in `main` unless there is a specific case where you have to                        override a setting for the `server` run mode.                        For example, when Puppet Server is configured to                        use an external node classifier, you must add [these settings](https://www.puppet.com/docs/puppet/7/nodes_external.html#connect_a_new_enc) to the `server` section. If those settings are added to                            `main`, then the agent tries and fails to                        run the server-only script                            /usr/local/bin/puppet_node_classifier during its                        run.

- ​                        `agent` is used by the Puppet agent service.

- ​                        `user` is used by the Puppet apply command, as well as many of the                        less common [Puppet subcommands](https://www.puppet.com/docs/puppet/7/man/overview.html)

Puppet prefers to use settings from one of the three                application-specific sections (`server`, `agent`, or `user`). If it                doesn’t find a setting in the application section, it uses the value from `main`. (If `main` doesn’t                set one, it falls back to the default value.) 

Note:                     Puppet Server ignores some config settings. It honors                    almost all settings in `puppet.conf` and picks                    them up automatically. However, some [                         Puppet Server settings](https://puppet.com/docs/puppetserver/latest/puppet_conf_setting_diffs.html) differ from a Ruby primary server's `puppet.conf` settings.

##### Comment lines

```
# This is a comment.Copied!
```

Comment                lines start with a hash sign (`#`). They can be                indented with any amount of leading space. 

Partial-line comments such as `report = true # this enables                    reporting` are not allowed, and the intended comment is treated as part                of the value of the setting. To be treated as a comment, the hash sign must be the                first non-space character on the line.

##### Setting lines

```
certname = primaryserver01.example.comCopied!
```

A                setting line consists of: 

- Any amount of leading space (optional).
- The name of a setting.
- An equals sign (`=`), which can optionally                            be surrounded by any number of spaces.
- A value for the setting.

##### Special types of values for settings

Generally, the value of a setting is a single word. However, listed below are a few                special types of values.

List of words: Some settings (like reports) can accept multiple values, which are                specified as a comma-separated list (with optional spaces after commas). Example:                    `report = http,puppetdb`            

Paths: Some settings (like `environmentpath`) take a                list of directories. The directories are separated by the system path separator                character, which is colon (`:`) on *nix platforms and semicolon (`;`) on Windows.                

```
# *nix version:
environmentpath = $codedir/special_environments:$codedir/environments
# Windows version:
environmentpath = $codedir/environments;C:\ProgramData\PuppetLabs\code\environmentCopied!
```

Path                lists are ordered;Puppet always checks the first                directory first, then moves on to the others if it doesn’t find what it needs. 

Files or directories: Settings that take a single file or directory (like `ssldir`) can accept an optional hash of permissions. When                starting up, Puppet enforces those permissions on the                file or directory.

We do not recommend you do this because the defaults are good for most users.                However, if you need to, you can specify permissions by putting a hash like this                after the path:                

```
ssldir = $vardir/ssl {owner = service, mode = 0771}Copied!
```

The                allowed keys in the hash are`owner`, `group`, and `mode`. There                are only two valid values for the `owner` and `group` keys: 

- ​                            `root` — the root or Administrator user or                            group owns the file.
- ​                            `service` — the user or group that the Puppet service is running as owns the                            file. The service’s user and group are specified by the `user` and `group` settings. On a primary server running open source                                Puppet, these default to `puppet`; on Puppet Enterprise they default to `pe-puppet`.

##### Interpolating variables in settings

The values of settings are available as variables within `puppet.conf`, and you can insert them into the values of other                settings. To reference a setting as a variable, prefix its name with a dollar sign                    (`$`):                

```
ssldir = $vardir/sslCopied!
```

Not                all settings are equally useful; there’s no real point in interpolating`$ssldir` into `basemodulepath`, for example. We recommend that you use only the                following variables:   

- ​                        `$codedir`                    
- ​                        `$confdir`                    
- ​                        `$vardir`                    

# `environment.conf`:        Per-environment settings

### Sections

[Location](https://www.puppet.com/docs/puppet/7/config_file_environment.html#environment-conf-location)

[Example](https://www.puppet.com/docs/puppet/7/config_file_environment.html#environment-conf-example)

[Format](https://www.puppet.com/docs/puppet/7/config_file_environment.html#environment-conf-format)

[Relative paths in values](https://www.puppet.com/docs/puppet/7/config_file_environment.html#environment-conf-relative-paths-in-values)

[Interpolation in values](https://www.puppet.com/docs/puppet/7/config_file_environment.html#environment-conf-interpolation-in-values)

[ Allowed settings](https://www.puppet.com/docs/puppet/7/config_file_environment.html#environment-conf-allowed-settings)

Environments are isolated groups of agent nodes. Any environment can contain an            `environment.conf` file. This file can override several        settings whenever the primary server is serving nodes assigned to that        environment.

## Location

Each `environment.conf` file is stored in an [environment](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about). It will be at the top level of its home                environment, next to the `manifests` and `modules` directories.

For example, if your environments are in the default directory (`$codedir/environments`), the `test` environment’s config file is located at `$codedir/environments/test/environment.conf`. 

## Example

```
# /etc/puppetlabs/code/environments/test/environment.conf

# Puppet Enterprise requires $basemodulepath; see note below under "modulepath".
modulepath = site:dist:modules:$basemodulepath

# Use our custom script to get a git commit for the current state of the code:
config_version = get_environment_commit.shCopied!
```

## Format

The `environment.conf` file uses the same INI-like                format as `puppet.conf`, with one exception: it cannot                contain config sections like [`main`]. All settings in                    `environment.conf` must be outside any config                section.

## Relative paths in values

Most of the allowed settings accept file paths or lists of                paths as their values.

If any of these paths are relative paths — that is, they                start without a leading slash or drive letter — they are resolved relative                to that environment’s main directory.

For example, if you set `config_version =                    get_environment_commit.sh` in the `test` environment, Puppet uses the file at `/etc/puppetlabs/code/environments/test/get_environment_commit.sh`.

## Interpolation in values

The settings in `environment.conf` can use the values                of other settings as variables (such as `$codedir`). Additionally, the `config_version` setting can use the special `$environment` variable, which gets replaced with the                name of the active environment.

The most useful variables to interpolate into `environment.conf` settings are:

- ​                    `$basemodulepath` — useful for including the                    default module directories in the `modulepath` setting. We recommend Puppet Enterprise (PE) users include this in the value                        of `modulepath`, because PE uses modules in the `basemodulepath` to configure orchestration and                    other features.
- ​                        `$environment` — useful as a command line                        argument to your `config_version` script. You can interpolate this variable                        only in the `config_version` setting.
- ​                        `$codedir` — useful for locating                        files.

##  Allowed settings

The `environment.conf` file can override these                settings: 

- ​                            `modulepath`                        

  ​                            The list of directories Puppet loads                                modules from.                             If this setting isn’t set, the `modulepath` for the environment                                is:`<MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepathCopied!`That                                is, Puppet adds the                                environment’s modules directory to the value of the                                basemodulepath setting from `puppet.conf`, with the environment’s modules getting                                priority. If the modules directory is empty of absent, Puppet only                                uses modules from directories in the basemodulepath. A directory                                environment never uses the global `modulepath` from `puppet.conf`.                         

- ​                            `manifest`                        

  ​                            The main manifest the primary server uses when compiling                                catalogs for this environment. This can be one file or a directory                                of manifests to be evaluated in alphabetical order. Puppet manages this path as a                                directory if one exists or if the path ends with a slash (`/`) or dot (`.`).                            If this setting isn’t set, Puppet uses                                the environment’s `manifests` directory as the main manifest, even if it                                is empty or absent. A directory environment never uses the                                    global `manifest` from `puppet.conf`.                        

- ​                            `config_version`                        

  ​                            A script Puppet can run to determine                                the configuration version.                                                            Puppet automatically adds                                a config version to every catalog it compiles, as well as                                to messages in reports. The version is an arbitrary piece of data                                that can be used to identify catalogs and events.                            You can specify an executable script that determines an environment’s                                config version by setting `config_version` in its environment.conf file. Puppet runs this script when                                compiling a catalog for a node in the environment, and use its                                output as the config version.                                                             Note: If you’re using a system binary like `git rev-parse`, make sure to specify                                    the absolute path to it. If `config_version` is set to a relative path, Puppet looks for the                                    binary in the environment, not in the                                        system’s `PATH`.                                                        If this setting isn’t set, the config version is                                the time at which the catalog was compiled (as the number                                of seconds since January 1, 1970). A directory environment never                                uses the global `config_version` from                                    `puppet.conf`.                         

- `environment_timeout`                        

  ​                            How long the primary server caches the data it loads from an                                environment. If present, this overrides the value of `environment_timeout` from [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html). Unless you have                                a specific reason, we recommend only setting `environment_timeout` globally, in                                puppet.conf. We also don’t recommend using any value other                                    than `0` or `unlimited`.                            For more information about configuring the environment                           timeout, [see the timeout section of the                                     Creating Environments page.](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments_creating)                                                    

# `fileserver.conf`: Custom fileserver mount points

### Sections

[When to use `fileserver.conf` ](https://www.puppet.com/docs/puppet/7/config_file_fileserver.html#when-to-use-fileserver-conf)

[Location](https://www.puppet.com/docs/puppet/7/config_file_fileserver.html#fileserver-conf-location)

[Example](https://www.puppet.com/docs/puppet/7/config_file_fileserver.html#fileserver-conf-example)

[Format](https://www.puppet.com/docs/puppet/7/config_file_fileserver.html#fileserver-conf-format)

The `fileserver.conf` file configures custom static mount points for Puppet’s file server. If custom mount points are present,            `file` resources can        access them with their `source` attributes.

## When to use `fileserver.conf`

This file is necessary only if you are [creating                     custom mount points](https://www.puppet.com/docs/puppet/7/file_serving.html).

Puppet automatically serves files from the `files` directory of every module, and most users find this sufficient.                For more information, see [Modules                     fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals). However, custom mount points are useful for things that you                don’t store in version control with your modules, like very large files and                sensitive credentials.

## Location

The `fileserver.conf` file is located                    at `$confdir/fileserver.conf` by                default. Its location is configurable with the [`fileserverconfig` setting](https://www.puppet.com/docs/puppet/7/configuration.html).

The location of the `confdir` depends on your                operating system. See the [confdir                     documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for details.

## Example

```
# Files in the /path/to/files directory are served
# at puppet:///extra_files/.
[extra_files]
    path /etc/puppetlabs/puppet/extra_filesCopied!
```

This `fileserver.conf` file creates a new                mount point named `extra_files`. Authorization to                    `extra_files` is controlled by Puppet Server. See  [creating custom mount points](https://www.puppet.com/docs/puppet/7/file_serving.html) for more information. 

CAUTION: Always restrict write access to mounted directories. The file                    server follows any symlinks in a file server mount, including links to files                    that agent nodes shouldn’t access (like SSL keys). When following symlinks, the                    file server can access any files readable by Puppet Server’s user account.

## Format

`fileserver.conf` uses a one-off format that                resembles an INI file without the equals `(=)` signs.                It is a series of mount-point stanzas, where each stanza consists of:

- A `[mount_point_name]` surrounded by                        square brackets. This becomes the name used in `puppet:///` URLs for files in this mount point.
- A `path <PATH>` directive,                            where `<PATH>` is an                        absolute path on disk. This is where the mount point’s files are stored.

# `puppetdb.conf`: PuppetDB server                locations

The `puppetdb.conf` file configures how                        Puppet connects to one or more servers.                It is only used if you are using PuppetDB and have                connected your primary server to it.

This configuration file is documented in the PuppetDB docs. See [Configuring a Puppet/PuppetDB connection](https://puppet.com/docs/puppetdb/latest/puppetdb_connection.html)                        for details.

# `autosign.conf`: Basic certificate autosigning  

### Sections

[Location](https://www.puppet.com/docs/puppet/7/config_file_autosign.html#autosign-location)

[Format](https://www.puppet.com/docs/puppet/7/config_file_autosign.html#autosign-format)

The `autosign.conf` file can allow certain        certificate requests to be automatically signed. It is only valid on the CA primary Puppet server; a primary server not serving as a CA does not            use `autosign.conf`.

CAUTION: Because any host can provide any certname when requesting a                certificate, basic autosigning is insecure. Use it only when you fully trust                any computer capable of connecting to the primary server.

Puppet also provides a policy-based autosigning interface            using custom policy executables, which can be more flexible and secure than                the `autosign.conf`  allowlist but more            complex to configure.

For more information, see the documentation about [certificate autosigning](https://www.puppet.com/docs/puppet/7/ssl_certificates.html).

## Location

Puppet looks for `autosign.conf` at `$confdir/autosign.conf` by default. To change this path, configure                the autosign setting in the `[primary                    server]` section of `puppet.conf`.

The default confdir path depends on your operating system.  See                the [confdir                     documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for more information.

Note: The `autosign.conf` file                    must not be executable by the primary server user account. If the `autosign` setting points to an executable file,                        Puppet instead treats it like a custom policy                    executable even if it contains a valid `autosign.conf` allowlist.

## Format

The `autosign.conf` file is a line-separated                list of certnames or domain name globs. Each line represents a node name or group of                node names for which the CA primary server automatically signs certificate requests. 

```
rebuilt.example.com
*.scratch.example.com
*.localCopied!
```

Domain name globs do not function as normal globs: an asterisk can only represent one                or more subdomains at the front of a certname that resembles a fully qualified                domain name (FQDN). If your certnames don’t look like FQDNs, the `autosign.conf` allowlist might not be effective.

Note: The `autosign.conf` file                    can safely be an empty file or not-existent, even if the `autosign` setting is enabled. An empty or                        non-existent `autosign.conf` file is                    an empty allowlist, meaning that Puppet does not                    autosign any requests. If you create `autosign.conf` as a non-executable file and add certnames to                    it, Puppet then automatically uses the file to                    allow incoming requests without needing to modify `puppet.conf`. 

To explicitly disable autosigning,                            set `autosign = false` in                            the `[primary server]` section                        of the CA primary server's `puppet.conf`,                        which disables CA autosigning even if `autosign.conf` or a custom policy executable                    exists.

# `csr_attributes.yaml`: Certificate extensions 

### Sections

[Location](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html#csr-attributes-location)

[Example](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html#csr-attributes-example)

[Format](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html#csr-attributes-format)

[Allowed OIDs for custom attributes](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html#csr-attributes-allowed-oids-custom-attributes)

[Allowed OIDs for extension requests](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html#csr-attributes-allowed-oids-extension-requests)

The `csr_attributes.yaml` file defines custom data for new      certificate signing requests (CSRs).

The `csr_attributes.yam`l file can set: 

- CSR attributes (transient data used for pre-validating               requests)
- Certificate extension requests (permanent data to be embedded in a               signed certificate)

This file is only consulted when a new CSR is created, for example when an agent node is         first attempting to join a Puppet deployment. It cannot         modify existing certificates.

For information about using this file, see [CSR attributes and             certificate extensions](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions).

## Location

The `csr_attributes.yaml` file is located               at `$confdir/csr_attributes.yaml` by default.            Its location is configurable with the `csr_attributes` setting.

The location of the `confdir` depends on your            operating system. See the [confdir documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for details.

## Example

```
---
custom_attributes:
  1.2.840.113549.1.9.7: 342thbjkt82094y0uthhor289jnqthpc2290
extension_requests:
  pp_uuid: ED803750-E3C7-44F5-BB08-41A04433FE2E
  pp_image_name: my_ami_image
  pp_preshared_key: 342thbjkt82094y0uthhor289jnqthpc2290Copied!
```

## Format

The `csr_attributes` file must be a YAML hash            containing one or both of the following keys:

- ​                  `custom_attributes`               
- ​                  `extension_requests`               

The value of each key must also be a hash, where:

- Each key is a valid [object                      identifier (OID)](http://en.wikipedia.org/wiki/Object_identifier). Note that Puppet-specific OIDs can                  optionally be referenced by short name instead of by numeric ID. In the example                     above, `pp_uuid` is a short name for a                  Puppet-specific OID.
- Each value is an object that can be cast to a string. That is, numbers are allowed                  but arrays are not.

## Allowed OIDs for custom attributes

Custom attributes can use any public or site-specific OID, with the exception of            the OIDs used for core X.509 functionality. This means you can’t re-use existing            OIDs for things like subject alternative names.

One useful OID is the “challengePassword” attribute — `1.2.840.113549.1.9.7`. This is a rarely-used corner of X.509 which can be            repurposed to hold a pre-shared key. The benefit of using this instead of an arbitrary            OID is that it appears by name when using OpenSSL to dump the CSR to text; OIDs               that `openssl req` can’t recognize are            displayed as numerical strings.

Also note that the Puppet-specific OIDs listed below can            also be used in CSR attributes.

## Allowed OIDs for extension requests

Extension request OIDs **must** be under the “ppRegCertExt” (`1.3.6.1.4.1.34380.1.1`) or “ppPrivCertExt” (`1.3.6.1.4.1.34380.1.2`) OID arcs.

​            Puppet provides several registered OIDs (under            “ppRegCertExt”) for the most common kinds of extension information, as well as a private            OID range (“ppPrivCertExt”) for site-specific extension information. The benefits of            using the registered OIDs are:

- They can be referenced in `csr_attributes.yaml` using their short names instead of their                  numeric IDs.
- When using Puppet tools to print certificate info,                  they appear using their descriptive names instead of their numeric IDs.

The private range is available for any information you want to embed into a certificate            that isn’t already in wide use elsewhere. It is completely unregulated, and its contents            are expected to be different in every Puppet deployment.

The “ppRegCertExt” OID range contains the following OIDs. 

| Numeric ID               | Short name            | Descriptive name                 |
| ------------------------ | --------------------- | -------------------------------- |
| 1.3.6.1.4.1.34380.1.1.1  | `pp_uuid`             | Puppet node UUID                 |
| 1.3.6.1.4.1.34380.1.1.2  | `pp_instance_id`      | Puppet node instance ID          |
| 1.3.6.1.4.1.34380.1.1.3  | `pp_image_name`       | Puppet node image name           |
| 1.3.6.1.4.1.34380.1.1.4  | `pp_preshared_key`    | Puppet node preshared key        |
| 1.3.6.1.4.1.34380.1.1.5  | `pp_cost_center`      | Puppet node cost center name     |
| 1.3.6.1.4.1.34380.1.1.6  | `pp_product`          | Puppet node product name         |
| 1.3.6.1.4.1.34380.1.1.7  | `pp_project`          | Puppet node project name         |
| 1.3.6.1.4.1.34380.1.1.8  | `pp_application`      | Puppet node application name     |
| 1.3.6.1.4.1.34380.1.1.9  | `pp_service`          | Puppet node service name         |
| 1.3.6.1.4.1.34380.1.1.10 | `pp_employee`         | Puppet node employee name        |
| 1.3.6.1.4.1.34380.1.1.11 | `pp_created_by`       | Puppet node `created_by` tag     |
| 1.3.6.1.4.1.34380.1.1.12 | `pp_environment`      | Puppet node environment name     |
| 1.3.6.1.4.1.34380.1.1.13 | `pp_role`             | Puppet node role name            |
| 1.3.6.1.4.1.34380.1.1.14 | `pp_software_version` | Puppet node software version     |
| 1.3.6.1.4.1.34380.1.1.15 | `pp_department`       | Puppet node department name      |
| 1.3.6.1.4.1.34380.1.1.16 | `pp_cluster`          | Puppet node cluster name         |
| 1.3.6.1.4.1.34380.1.1.17 | `pp_provisioner`      | Puppet node provisioner name     |
| 1.3.6.1.4.1.34380.1.1.18 | `pp_region`           | Puppet node region name          |
| 1.3.6.1.4.1.34380.1.1.19 | `pp_datacenter`       | Puppet node datacenter name      |
| 1.3.6.1.4.1.34380.1.1.20 | `pp_zone`             | Puppet node zone name            |
| 1.3.6.1.4.1.34380.1.1.21 | `pp_network`          | Puppet node network name         |
| 1.3.6.1.4.1.34380.1.1.22 | `pp_securitypolicy`   | Puppet node security policy name |
| 1.3.6.1.4.1.34380.1.1.23 | `pp_cloudplatform`    | Puppet node cloud platform name  |
| 1.3.6.1.4.1.34380.1.1.24 | `pp_apptier`          | Puppet node application tier     |
| 1.3.6.1.4.1.34380.1.1.25 | `pp_hostname`         | Puppet node hostname             |

The “ppAuthCertExt” OID range contains the following OIDs: 

| 1.3.6.1.4.1.34380.1.3.1  | `pp_authorization` | Certificate extension authorization                          |
| ------------------------ | ------------------ | ------------------------------------------------------------ |
| 1.3.6.1.4.1.34380.1.3.13 | `pp_auth_role`     | Puppet node role name for authorization.                           For PE internal use only. |

# `custom_trusted_oid_mapping.yaml`:    Short names for cert extension OIDs

### Sections

[Certificate extensions](https://www.puppet.com/docs/puppet/7/config_file_oid_map.html#custom-trusted-oid-mapping-certificate-extensions)

[Limitations of OID mapping](https://www.puppet.com/docs/puppet/7/config_file_oid_map.html#custom-trusted-oid-mapping-limitations)

[Location](https://www.puppet.com/docs/puppet/7/config_file_oid_map.html#custom-trusted-oid-mapping-location)

[Example](https://www.puppet.com/docs/puppet/7/config_file_oid_map.html#custom-trusted-oid-mapping-example)

[Format](https://www.puppet.com/docs/puppet/7/config_file_oid_map.html#custom-trusted-oid-mapping-format)

The `custom_trusted_oid_mapping.yaml` file lets you set your own short    names for certificate extension object identifiers (OIDs), which can make the `$trusted` variable more    useful.

It is only valid on a primary Puppet server. In Puppet apply, the compiler doesn’t add certificate extensions        to `$trusted.`    

## Certificate extensions

When a node requests a certificate, it can ask the CA to include some additional, permanent        metadata in that cert. Puppet agent uses the `csr_attributes.yaml` file to decide what extensions to request.

If the CA signs a certificate with extensions included, those extensions are available        as trusted facts in the top-scope `$trusted` variable. Your manifests or node classifier can then use those        trusted facts to decide which nodes can receive which configurations.

By default, the [           Puppet-specific registered OIDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions) appear as keys        with convenient short names in the `$trusted[extensions]` hash, and any other OIDs appear as raw numerical IDs.        You can use the `custom_trusted_oid_mapping.yaml` file to map other OIDs to short names, which        replaces the numerical OIDs in `$trusted[extensions]`.

Run `puppetserver ca print` to see changes made in          `custom_trusted_oid_mapping.yaml` immediately without a        restart.

 For more information, see [CSR attributes and certificate extensions](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions), [Trusted           facts](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html), [The `csr_attributes.yaml` file](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html). 

## Limitations of OID mapping

Mapping OIDs in this file **only** affects the keys in the `$trusted[extensions]` hash. It does not affect what an agent        can request in its `csr_attributes.yaml` file —        anything but Puppet-specific registered extensions must still        be numerical OIDs.

After setting custom OID mapping values and restarting puppetserver, you can reference        variables using only the short name.

## Location

The OID mapping file is located at `$confdir/custom_trusted_oid_mapping.yaml` by default. Its location is        configurable with the `trusted_oid_mapping_file` setting.

The location of the `confdir` depends on your        OS. See the [confdir           documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for details.

## Example

```
---
oid_mapping:
  1.3.6.1.4.1.34380.1.2.1.1:
    shortname: 'myshortname'
    longname: 'My Long Name'
  1.3.6.1.4.1.34380.1.2.1.2:
    shortname: 'myothershortname'
    longname: 'My Other Long Name'Copied!
```

## Format

The `custom_trusted_oid_mapping.yaml` must be a        YAML hash containing a single key called `oid_mapping`.

The value of the `oid_mapping` key must be a hash        whose keys are numerical OIDs. The value for each OID must be a hash with two keys:

- ​            `shortname` for the case-sensitive one-word name that            is used in the `$trusted[extensions]` hash.
- ​            `longname` for a more descriptive name (not used            elsewhere).

# `device.conf`: Network hardware access

### Sections

[Location](https://www.puppet.com/docs/puppet/7/config_file_device.html#device-conf-location)

[Format](https://www.puppet.com/docs/puppet/7/config_file_device.html#device-conf-format)

The `puppet-device` subcommand retrieves        catalogs from the primary Puppet server and applies them to        remote devices. Devices to be managed by the `puppet-device` subcommand are configured in `device.conf`.

For more information on Puppet device,            see the [Puppet device                 documentation](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device).

## Location

The `device.conf` file is located                    at `$confdir/device.conf` by default,                and its location is configurable with the deviceconfig setting.

The location of `confdir` depends on your                operating system. See the [confdir documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for details.

## Format

The `device.conf` file is an INI-like file,                with one section per                device:

```
[device001.example.com]
type cisco
url ssh://admin:password@device001.example.com
debugCopied!
```

The section name specifies the `certname` of                the device.

The values for the `type` and `url` properties are specific to each type of                device.

The the optional `debug` property specifies                transport-level debugging, and is limited to telnet and ssh transports.

For Cisco devices, the `url` is in the                following                format:

```
scheme://user:password@hostname/queryCopied!
```

With:

- Scheme: either `ssh` or `telnet`
- user: optional connection username, depending on the device configuration
- password: connection password
- query: optional `?enable= `parameter                        whose value is the enable password

Note: Reserved non-alphanumeric characters in the `url` must be percent-encoded.

# `routes.yaml`: Advanced plugin routing

### Sections

[Location](https://www.puppet.com/docs/puppet/7/config_file_routes.html#routes-yaml-location)

[Example](https://www.puppet.com/docs/puppet/7/config_file_routes.html#routes-yaml-example)

[Format](https://www.puppet.com/docs/puppet/7/config_file_routes.html#routes-yaml-format)

The `routes.yaml` file overrides configuration settings involving    indirector termini, and allows termini to be set in greater detail than `puppet.conf` allows.

The `routes.yaml` file makes it possible to use certain extensions to Puppet, most notably PuppetDB.      Usually you edit this file only to make changes that are explicitly specified by the setup      instructions for an extension you are trying to install.

## Location

The `routes.yaml` file is located at `$confdir/routes.yaml` by default. Its location is configurable        with the `route_file` setting.

The location of the `confdir` depends on your        operating system. See the [confdir documentation](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) for details.

## Example

```
---
server:
  facts:
    terminus: puppetdb
    cache: yamlCopied!
```

## Format

The `routes.yaml` file is a YAML hash.

Each top level key is the name of a run mode (`server`, `agent`, or `user`), and its value is another hash.

Each key of the second-level hash is the name of an indirection, and its value is another        hash.

The only keys allowed in the third-level hash are `terminus` and `cache`. The value of each        of these keys is the name of a valid terminus for the indirection named above.

### 关键配置设置

Puppet 有大约 200 个设置，所有设置都在配置参考中列出。大多数时候，你只与他们中的几十个互动。本页列出了最重要的值。

There are a lot of settings that are rarely useful but                                    still make sense, but there are also at least a hundred that are                                    not configurable at all. 有很多设置很少有用，但仍然有意义，但也有至少100个根本不可配置。This is a Puppet design choice.这是一个 Puppet 设计选择。Because of the way Puppet code is arranged, the settings system is the easiest way to publish global constants that are dynamically initialized on startup.This means a lot of things have been introduced to Puppet as configurable settings regardless of whether they needed to be configurable.由于 Puppet 代码的排列方式，设置系统是发布启动时动态初始化的全局常量的最简单方法。这意味着，无论是否需要配置，Puppet都引入了许多可配置设置。

#### 代理的设置（所有节点）

代理的以下设置大致按重要性顺序列出。其中大部分可以在 `[main]` 或 `[agent]` 部分中，或在命令行中指定。

##### Basics

- `server` — The primary server to request                        configurations from. Defaults to `puppet`. Change it if that’s not your server’s name.
  - ​                                `ca_server` and `report_server` — If you’re using                                multiple Puppet primary servers, you’ll need to centralize the CA.                                One of the ways to do this is by configuring `ca_server` on all agents. See                                    [Scaling Puppet Server with compile                                     servers](https://puppet.com/docs/puppetserver/latest/scaling_puppet_server.html) for more details. The `report_server` setting works the same                                way, although whether you need to use it depends on how you’re                                processing reports.
- `certname` — The node’s certificate name,                        and the unique identifier it uses when requesting catalogs. Defaults to the                        fully qualified domain name. 
  - For best compatibility, limit the value of `certname` to only use lowercase                                    letters, numbers, periods, underscores, and dashes. That is, it                                    matches `/\A[a-z0-9._-]+\Z/`. 
  - The special value `ca` is reserved,                                    and can’t be used as the certname for a normal node. 
- `environment` —                        The environment to request when contacting the primary server.                        It’s only a request, though; the primary server’s [                             ENC](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers) can override this if it chooses.                        Defaults to `production`.
- `sourceaddress` — The address on a                        multihomed host to use for the agent’s communication with the primary                        server.

Note: Although it’s possible to set something other than                    the certname as the node name (using either the `node_name_fact` or `node_name_value` setting), we don’t generally recommend it. It                    allows you to re-use one node certificate for many nodes, but it reduces                    security, makes it harder to reliably identify nodes, and can interfere with                    other features. Setting a non-certname node name is not officially                    supported in Puppet Enterprise.

##### Run behavior

These settings affect the way Puppet applies                catalogs:

- ​                        `noop` — If enabled, the agent won’t make                        any changes to the node. Instead, it looks for changes                        that would be made if the catalog were applied, and report to the                        primary server about what it would have done. This can be overridden                        per-resource with the `noop`                        [                             metaparameter](https://www.puppet.com/docs/puppet/7/metaparameter.html).
- ​                        `priority` — Allows you to make the agent                        share CPU resources so that other applications have access to processing                        power while agent is applying a catalog.
- ​                        `report` — Indicates whether to send                        reports. Defaults to true.
- ​                        `tags` — Lets you limit the Puppet run to include only those resources                        with certain [                             tags](https://www.puppet.com/docs/puppet/7/lang_tags.html).
- ​                        `trace`, `profile`, `graph`,                            and `show_diff` — Tools for                        debugging or learning more about an agent run. Useful when combined with                            the `--test` and `--debug` command options.
- ​                        `usecacheonfailure` — Indicates whether                        to fall back to the last known good catalog if the primary server fails to                        return a good catalog. The default behavior is usually what you want, but                        you might have a reason to disable it.
- ​                        `ignoreschedules` — If you use [                             schedules](https://www.puppet.com/docs/puppet/7/metaparameter.html), this can be useful when doing an                        initial Puppet run to set up new nodes.
- ​                        `prerun_command` and `postrun_command` — Commands to run on either                        side of a Puppet run.
- ​                    `ignore_plugin_errors` — If set to false, the agent aborts the                    run if `pluginsync` fails. Defaults to true.

##### Service behavior

These settings affect the way Puppet agent acts when                running as a long-lived service: 

- ​                        `runinterval` — How often to do a Puppet run, when running as a service.
- ​                        `waitforcert` — Whether to keep trying if                        the agent can’t initially get a certificate. The default behavior is good,                        but you might have a reason to disable it.

##### Useful when running agent from cron

- ​                        `splay` and `splaylimit` — Together, these allow you to spread out                        agent runs. When running the agent as a daemon, the services usually have                        been started far enough out of sync to make this a non-issue, but it’s                        useful with cron agents. For example, if your agent cron job happens on the                        hour, you could set `splay =                            true` and `splaylimit =                            60m` to keep the primary server from getting briefly                        overworked and then left idle for the next 50 minutes.
- ​                        `daemonize` — Whether to daemonize. Set                        this to false when running the agent from cron.
- ​                        `onetime` — Whether to exit after                        finishing the current Puppet run. Set this to                        true when running the agent from cron.

For more information on these settings, see the [configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html).

#### Settings for primary servers

Many of these settings are also important for standalone        Puppet apply nodes, because they act as their own primary server.        These settings go in the `[server]` section, unless you’re using Puppet        apply in production, in which case put them in the `[main]` section instead.

##### Basics

- `dns_alt_names` — A list of hostnames the                        server is allowed to use when acting as a primary server. The hostname your                        agents use in their `server` setting must be                        included in either this setting or the primary server’s `certname` setting. Note that this setting is only                        used when initially generating the primary server’s certificate — if you                        need to change the DNS names, you must: 
  1. Run: `sudo puppetserver ca clean --certname                                        <SERVER'S CERTNAME>`                                
  2. Turn off the Puppet Server                                service.
  3. Run: `sudo puppetserver ca generate                                        --certname <SERVER'S CERTNAME> --subject-alt-names                                        <ALT NAME 1>,<ALT NAME 2>,...`                                
  4. Re-start the Puppet Server service.
- ​                        `environment_timeout` — For better                        performance, you can set this to `unlimited`                        and make refreshing the primary server a part of your standard code                        deployment process. 
- ​                        `environmentpath` — Controls where Puppet finds directory environments. For more                        information on environments, see [                             Creating environments](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments_creating).
- ​                        `basemodulepath` — A list of directories                        containing Puppet modules that can be used in                        all environments. See [                             modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html) for details.
- `reports` — Which report handlers to use. For a                        list of available report handlers, see [                             the report reference](https://www.puppet.com/docs/puppet/7/report.html). You can also [                             write your own report handlers](https://www.puppet.com/docs/puppet/7/reporting_write_processors.html). Note that the                        report handlers might require settings of their own.
- `digest_algorithm` — To accept requests from older                    agents when using a remote filebucket, Puppet Server                    needs to specify `digest_algorithm=md5`.

##### Puppet Server related settings

​                Puppet Server has its own configuration files;                consequently, there are [several settings in `puppet.conf`                     that Puppet Server ignores](https://puppet.com/docs/puppetserver/latest/puppet_conf_setting_diffs.html). 

- ​                        [                             `puppet-admin`                         ](https://puppet.com/docs/puppetserver/latest/config_file_puppetserver.html) — Settings to control which authorized clients can use the                        admin interface.
- ​                        [                             `jruby-puppet `                         ](https://puppet.com/docs/puppetserver/latest/tuning_guide.html) — Provides details on tuning JRuby for better performance.
- ​                        [                             `JAVA_ARGS`                         ](https://puppet.com/docs/puppetserver/latest/install_from_packages.html) — Instructions on tuning the Puppet Server memory allocation.

##### Extensions

These features configure add-ons and optional features: 

- ​                        `node_terminus` and `external_nodes` — The ENC settings. If                        you’re using an [                             ENC](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers), set these to `exec` and the path to your ENC script, respectively.
- ​                        `storeconfigs` and `storeconfigs_backend` — Used for setting up                            PuppetDB. See [the PuppetDB docs for details.](https://puppet.com/docs/puppetdb/latest/connect_puppet_master.html)                    
- ​                        `catalog_terminus` — This can enable the                        optional static compiler. If you have lots of `file` resources in your manifests, the static compiler                        lets you sacrifice some extra CPU work on your primary server to gain faster                        configuration and reduced HTTPS traffic on your agents. See the                             indirection reference for details.

##### CA settings

- ​                        `ca_ttl` — How long newly signed                        certificates are valid. Deprecated.
- ​                        `autosign` — Whether and how to autosign                        certificates. See [                             Autosigning](https://www.puppet.com/docs/puppet/7/ssl_certificates.html) for detailed information.

For more information on these settings, see the [configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html).  

# Adding file server mount points

### Sections

[Mount points in the Puppet URI](https://www.puppet.com/docs/puppet/7/file_serving.html#mount-points-puppet-uri)

[Creating a new mount point in `fileserver.conf` ](https://www.puppet.com/docs/puppet/7/file_serving.html#creating-new-mount-points-fileserver)

[Controlling access to a custom mount point in `auth.conf` ](https://www.puppet.com/docs/puppet/7/file_serving.html#controlling-access-in-auth)

 Puppet Server includes a file server for transferring static file content to agents.      If you need to serve large files that you don't want to store in source control or distribute      with a module, you can make a custom file server mount point and let Puppet serve those files from another directory.

In Puppet code, you can tell the file server is being used when you see            a `file` resource that has            a `source =>         puppet:///...` attribute specified. 

To set up a mount point: 

1. Choose a directory on disk for the mount point, make sure Puppet Server can access it, and add your files to the                  directory. 
2. Edit `fileserver.conf` on your Puppet Server node, so Puppet knows which directory to                  associate with the new mount point. 
3. (Optional) Edit Puppet Server's `auth.conf` to allow access to the new mount point.

 After the mount point is set up, Puppet code can reference the files you added to the         directory at `puppet:///<MOUNT POINT>/<PATH>`.

## Mount points in the Puppet URI

Puppet URIs look like this: `puppet://<SERVER>/<MOUNT               POINT>/<PATH>`. 

The `<SERVER>` is optional, so it common practice to use               `puppet:///` URIs with three slashes. Usually, there is no reason to            specify the server. For Puppet agent,               `<SERVER>` defaults to the value of the server setting. For Puppet apply, `<SERVER>` defaults to            a special mock server with a modules mount point. 

`<MOUNT POINT>` is a unique identifier for some collection of            files. There are different kinds of mount points: 

- Custom mount points correspond to a directory that you specify.
- The `task` mount point works in a similar way to the                        `modules` mount point but for files that live under the                     modules `tasks` directory, rather than the                        `files` directory. 
- The special `modules` mount point serves files from the                        `files` directory of every module. It behaves as if someone                     had copied the `files` directory from every module into one big                     directory, renaming each of them with the name of their module. For example,                     the files in `apache/files/...` are available at                        `puppet:///modules/apache/...`. 
- The special `plugins` mount point serves files from the                        `lib` directory of every module. It behaves as if someone had                     copied the contents of every `lib` directory into one big                     directory, with no additional namespacing. Puppet agent uses this mount point when syncing plugins before a run, but there’s                     no reason to use it in a `file` resource. 
- The special `pluginfacts` mount point serves files from the                        `facts.d` directory of every module to support external                     facts. It behaves like the `plugins` mount point, but with a                     different source directory. 
- The special `locales` mount point serves files from the                        `locales` directory of every module to support automatic                     downloading of module translations to agents. It also behaves like the                        `plugins` mount point, and also has a different source                     directory. 

`<PATH>` is the remainder of the path to the file, starting from            the directory (or imaginary directory) that corresponds to the mount point.

## Creating a new mount point in `fileserver.conf`

The `fileserver.conf` file uses the following syntax to define mount            points:

```
[<NAME OF MOUNT POINT>]
    path <PATH TO DIRECTORY>       Copied!
```

In the following example, a file at               `/etc/puppetlabs/puppet/installer_files/oracle.pkg` would be available            in manifests as            `puppet:///installer_files/oracle.pkg`:

```
[installer_files]
    path /etc/puppetlabs/puppet/installer_files Copied!
```

Make sure that the `puppet` user has the right permissions to access that            directory and its contents. 

CAUTION: Always restrict write access to mounted directories. The file               server follows any symlinks in a file server mount, including links to files that               agent nodes cannot access (such as SSL keys). When following symlinks, the file               server can access any files readable by Puppet Server’s user               account.

## Controlling access to a custom mount point in `auth.conf`

By default, any node with a valid certificate can access the files in your new mount            point. If a node can fetch a catalog, it can fetch files. If the node can’t fetch a            catalog, it can’t fetch files. This is the same behavior as the special               `modules` and `plugins` mount points. If necessary, you            can restrict access to a custom mount point in `auth.conf`.

To add a new auth rule to Puppet Server’s HOCON-format               `auth.conf file`, located at               `/etc/puppetlabs/puppetserver/conf.d/auth.conf`. , you must meet the            following requirements: 

- It must match requests to all four of these prefixes: 
  - ​                           `/puppet/v3/file_metadata/<MOUNT POINT>`                        
  - ​                           `/puppet/v3/file_metadatas/<MOUNT POINT>`                        
  - ​                           `/puppet/v3/file_content/<MOUNT POINT>`                        
  - ​                           `/puppet/v3/file_contents/<MOUNT POINT> `                        
- Its `sort-order` must be lower than 500, so that it overrides                     the default rule for the file server. 

For example:

```
{
    # Allow limited access to files in /etc/puppetlabs/puppet/installer_files:
    match-request: {
        path: "^/puppet/v3/file_(content|metadata)s?/installer_files"
        type: regex
    }
    allow: "*.dev.example.com"
    sort-order: 400
    name: "dev.example.com large installer files"
},Copied!
```

Related topics: [Module fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals), [fileserver.conf: Custom fileserver mount                points](https://www.puppet.com/docs/puppet/7/config_file_fileserver.html), [ Puppet Server                configuration files: puppetserver.conf](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html), [ Puppet Server configuration files:                auth.conf](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html).

# Checking the values of settings

### Sections

[General usage](https://www.puppet.com/docs/puppet/7/config_print.html#settings-general-usage)

[Config sections](https://www.puppet.com/docs/puppet/7/config_print.html#settings-config-sections)

[Environments](https://www.puppet.com/docs/puppet/7/config_print.html#config-print-environments)

[Imitating Puppet server and `puppetserver ca`       ](https://www.puppet.com/docs/puppet/7/config_print.html#imitating-puppet-server)

[Imitating Puppet agent](https://www.puppet.com/docs/puppet/7/config_print.html#imitating-puppet-agent)

[Imitating `puppet apply`       ](https://www.puppet.com/docs/puppet/7/config_print.html#imitating-puppet-apply)

  Puppet settings are highly dynamic, and their values can come  from several different places. To see the actual settings values that a Puppet service uses, run the `puppet config print` command.

## General usage

The `puppet config print` command loads and        evaluates settings, and can imitate any of Puppet’s other        commands and services when doing so. The `--section` and `--environment` options        let you control how settings are loaded; for details, see the sections below on imitating        different services.

Note: To ensure that you’re seeing the values Puppet use when running as a service, be sure to          use sudo or run the command as `root` or `Administrator`. If you            run `puppet config print` as some other user,            Puppet might not use the [system config           file](https://www.puppet.com/docs/puppet/7/dirs_confdir.html).

To see the value of one setting:        

```
sudo puppet config print <SETTING NAME> [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]Copied!
```

This        displays just the value of `<SETTING          NAME>`.

To see the value of multiple settings:        

```
sudo puppet config print <SETTING 1> <SETTING 2> [...] [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]Copied!
```

This          displays `name = value` pairs for all requested        settings.

To see the value of all settings:        

```
sudo puppet config print [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]Copied!
```

This          displays `name = value` pairs for all        settings.

## Config sections

The `--section` option specifies which section of `puppet.conf` to use when finding settings. It is optional, and        defaults to `main`. Valid sections are: 

- ​              `main` (default) — used by all commands and services            
- ​              `server` — used by the primary Puppet server service and the `puppetserver ca` command 
- ​              `agent` — used by the Puppet agent service 
- ​              `user` — used by the Puppet apply command and most other commands 

As usual, the other sections override the `main` section if        they contain a setting; if they don’t, the value from `main`        is used, or a default value if the setting isn’t present there.

## Environments

The `--environment` option specifies which [environment](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about) to use        when finding settings. It is optional and defaults to the value of the `environment` setting in the `user`        section (usually `production`, because it’s rare to specify an        environment in `user`).

You can only specify environments that exist.

This option is primarily useful when looking up settings used by the primary server        service, because it’s rare to use environment config sections for Puppet apply and Puppet        agent.

## Imitating Puppet server and `puppetserver ca`      

To see the settings the Puppet server service and the          `puppetserver ca` command would use:

- Specify `--section server`.
- Use the `--environment` option to specify the environment            you want settings for, or let it default to `production`.
- Remember to use `sudo`.
- If your primary Puppet server is managed as a Rack            application (for example, with Passenger), check the `config.ru` file to make sure it’s using the [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and [vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html) that you expect. If it’s using            non-standard ones, you need to specify them on the command line with the `--confdir` and `--vardir`            options; otherwise you might not see the correct values for settings.

To see the effective [modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html) used in the `dev`        environment:        

```
sudo puppet config print modulepath --section server --environment devCopied!
```

This        returns something        like:

```
/etc/puppetlabs/code/environments/dev/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modulesCopied!
```

To see whether PuppetDB is configured for exported        resources:        

```
sudo puppet config print storeconfigs storeconfigs_backend --section server
Copied!
```

This returns something        like:

```
storeconfigs = true
storeconfigs_backend = puppetdbCopied!
```

## Imitating Puppet agent

To see the settings the Puppet agent service would use: 

- Specify `--section agent`. 
- Remember to use `sudo`. 
- If you are seeing something unexpected, check your Puppet agent init script or cron job to make sure it is              using the standard [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and [vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html), is running as root, and isn’t overriding other              settings with command line options. If it’s doing anything unusual, you might have to              set more options for the `config print` command. 

To see whether the agent is configured to use manifest ordering when applying the        catalog:

```
sudo puppet config print ordering --section agent
Copied!
```

This returns something        like:

```
manifestCopied!
```

## Imitating `puppet apply`      

To see the settings the Puppet apply command would use: 

- Specify `--section` user. 
- Remember to use `sudo`. 
- If you are seeing something unexpected, check the cron job or script that is              responsible for configuring the machine with Puppet              apply. Make sure it is using the standard [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and [vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html), is running as root, and isn’t overriding other              settings with command line options. If it’s doing anything unusual, you might have to              set more options for the `config print` command. 

To see whether Puppet apply is configured to use        reports:

```
sudo puppet config print report reports --section user
Copied!
```

This returns something        like:

```
report = true
reports = store,http
```

# Editing settings on the command line

### Sections

[Usage](https://www.puppet.com/docs/puppet/7/config_set.html#config-set-usage)

[Config sections](https://www.puppet.com/docs/puppet/7/config_set.html#config-set-sections)

[Example](https://www.puppet.com/docs/puppet/7/config_set.html#config-set-examples)

Puppet loads most of its settings from the `puppet.conf` config        file. You can edit this file directly, or you can change individual settings with            the `puppet config            set` command.

Use `puppet                config set` for:

- Fast one-off config changes,
- Scriptable config changes in provisioning                    tools,

If you find yourself changing many settings, edit the `                puppet.conf            ` file instead, or manage it with a template.

## Usage

To assign a new value to a setting,                run:

```
sudo puppet config set <SETTING NAME> <VALUE> --section <CONFIG SECTION>Copied!
```

This declaratively sets the value of `<SETTING                    NAME>` to `<VALUE>` in the specified config section, regardless of whether                the setting already had a value.

## Config sections

The `--section` option specifies                which section of `puppet.conf` to modify. It                is optional, and defaults to `main`. Valid                sections are:

- ​                        `main` (default) — used by all commands                        and services
- ​                        `server` — used by the primary Puppet server service and the `puppetserver ca` command
- ​                        `agent` — used by the Puppet agent service
- ​                        `user` — used by the `puppet apply` command and most other commands

When modifying the [system config file](https://www.puppet.com/docs/puppet/7/dirs_confdir.html), use `sudo` or run the command as `root` or Administrator.

## Example

Consider the following `puppet.conf` file:                

```
[main]
certname = agent01.example.com
server = server.example.com
vardir = /var/opt/lib/pe-puppet

[agent]
report = true
graph = true
pluginsync = true

[server]
dns_alt_names = server,server.example.com,puppet,puppet.example.comCopied!
```

If you run the following commands:                

```
sudo puppet config set reports puppetdb --section server
sudo puppet config set ordering manifestCopied!
```

The `puppet.conf` file now looks like this:                

```
[main]
certname = agent01.example.com
server = server.example.com
vardir = /var/opt/lib/pe-puppet
ordering = manifest

[agent]
report = true
graph = true
pluginsync = true

[server]
dns_alt_names = server,server.example.com,server,server.example.com
reports = puppetdb
```

# Environments

Environments are isolated groups of agent nodes. 

**[About environments](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about)**
An environment is an isolated group of agent nodes that a primary server can serve         with its own main manifest and set of modules. For example, you can  use environments to set         up scratch nodes for testing before  rolling out changes to production, or to divide a site         by types  of hardware.  **[Creating environments](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments_creating)**
An environment is a branch that gets turned into a directory on your primary Puppet server. Environments are turned on by         default. **[Environment isolation](https://www.puppet.com/docs/puppet/7/environment_isolation.html#environment_isolation)**
Environment isolation prevents resource types from leaking         between your various environments.

# About environments

### Sections

[Look up which environment a node is in](https://www.puppet.com/docs/puppet/7/environments_about.html#env_look_up_env)

[Access environment name in manifests](https://www.puppet.com/docs/puppet/7/environments_about.html#env_access_name_in_manifests)

[Environment scenarios](https://www.puppet.com/docs/puppet/7/environments_about.html#env_scenarios)

- [Permanent test environments ](https://www.puppet.com/docs/puppet/7/environments_about.html#permanent-test-environments)
- [Temporary test environments ](https://www.puppet.com/docs/puppet/7/environments_about.html#temporary-test-environments)
- [Divided infrastructure ](https://www.puppet.com/docs/puppet/7/environments_about.html#divided-infrastructure)

[Environments limitations ](https://www.puppet.com/docs/puppet/7/environments_about.html#env_limitations_)

- [Plugins can leak between environments ](https://www.puppet.com/docs/puppet/7/environments_about.html#environments-limitations-plugins-leak)
- [Exported resources can conflict or cross over ](https://www.puppet.com/docs/puppet/7/environments_about.html#environments-limitations-exported-resources)

[Troubleshoot environment leakage](https://www.puppet.com/docs/puppet/7/environments_about.html#env_troubleshoot_leakage)

An environment is an isolated group of agent nodes that a primary server can serve        with its own main manifest and set of modules. For example, you can use environments to set        up scratch nodes for testing before rolling out changes to production, or to divide a site        by types of hardware. 

Related topics: [main manifests](https://www.puppet.com/docs/puppet/7/dirs_manifest.html), [module paths](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html). 

## Look up which environment a node is in

If you need to determine which environment a certain node is part of, look it up        using the `puppet node find` command. 



To look up which environment a node is in, run `puppet                        node find <node>` on the Puppet Server                    host node, replacing `<node>` with the node's                    exact name.

Alternatively, run `puppet node find <node>                        --render_as json | jq .environment` to render the output as JSON and                    return only the environment name. 

Note: The node name must **exactly** match the name in the node's                            certificate, including capitalization. By default, a node's name is its                            fully qualified domain name, but the node's name can be changed by using                            the `certname` and `node_name_value` settings on the node itself.

## Access environment name in manifests

If you want to share code across environments, use the                        `$environment` variable in                your manifests. 

To get the name                                of the current environment: 

1. Use the `$environment` variable, which is set by                                        the primary server. 

## Environment scenarios

The main uses for environments fall into three categories:        permanent test environments, temporary test environments, and divided infrastructure. 

### Permanent test environments 

In a permanent test environment, there is a stable group of test nodes where all                changes must succeed before they can be merged into the production code. The test                nodes are a smaller version of the whole production infrastructure. They are either                short-lived cloud instances or longer-lived virtual machines (VMs) in a private                cloud. These nodes stay in the test environment for their whole lifespan.

### Temporary test environments 

In a temporary test environment, you can test a single change or group of changes by                checking the changes out of version control into the                    `$codedir/environments` directory, where it is detected as a new                environment. A temporary test environment can either have a descriptive name or use                the commit ID from the version that it is based on. Temporary environments are good                for testing individual changes, especially if you need to iterate quickly while                developing them. When you’re done with a temporary environment, you can delete it.                The nodes in a temporary environment are short-lived cloud instances or VMs, which                are destroyed when the environment ends.

### Divided infrastructure 

If parts of your infrastructure are managed by different teams that do not need to                coordinate their code, you can split them into environments.

## Environments limitations 

Environments have limitations, including leakage and        conflicts with exported resources. 

### Plugins can leak between environments 

Environment leakage occurs when different versions of Ruby files, such as resource types, exist in multiple                environments. When these files are loaded on the primary server, the first version                loaded is treated as global. Subsequent requests in other environments get that                first loaded version. Environment leakage does not affect the agent, as agents are                only in one environment at any given time. For more information, see below for                troubleshooting environment leakage. 

### Exported resources can conflict or cross over 

Nodes in one environment can collect resources that were exported from another                environment, which causes problems — either a compilation error due to identically                titled resources, or creation and management of unintended resources. The solution                is to run separate primary servers for each environment if you use exported                resources. 

## Troubleshoot environment leakage

Environment leakage is one of the limitations of        environments. 

Use one of the following methods to avoid                    environmental leakage: 

- For resource types, you                                    can avoid environment leaks with the the `puppet generate                                        types` command as described in environment isolation                                    documentation. This command generates resource type metadata                                    files to ensure that each environment uses the right version of                                    each type.
- This issue occurs only                                    with the `Puppet::Parser::Functions` API. To fix this,                                    rewrite functions with the modern functions API, which is not                                    affected by environment leakage. You can include helper code in                                    the function definition, but if helper code is more complex,                                    package it as a gem and install for all environments.
- Report processors and                                    indirector termini are still affected by this problem, so put                                    them in your global Ruby                                    directories rather than in your environments. If they are in                                    your environments, you must ensure they all have the same                                    content.

# Creating environments

### Sections

[Environment structure](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_structure)

[Environment resources](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_resources)

- [The modulepath ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environment-modulepath)
- [The main manifest ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environment-main-mainfest)
- [Hiera data ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environment-hiera-data)
- [The config version script ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments-config-version-script)
- [The environment.conf file ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environment-conf-file)

[Create an environment](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_create)

[Assign nodes to environments via an ENC](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_assign_nodes_enc)

[Assign nodes to environments via the agent's config file](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_assign_nodes_agents_config_file)

[Global settings for configuring environments](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_global_settings)

- [environmentpath](https://www.puppet.com/docs/puppet/7/environments_creating.html#global-settings-environmentpath)
- [basemodulepath](https://www.puppet.com/docs/puppet/7/environments_creating.html#global-settings-basemodulepath)
- [environment_timeout ](https://www.puppet.com/docs/puppet/7/environments_creating.html#global-settings-environment-timeout)
- [disable_per_environment_manifest ](https://www.puppet.com/docs/puppet/7/environments_creating.html#global-settings-disable-per-environment-manifest)
- [default_manifest ](https://www.puppet.com/docs/puppet/7/environments_creating.html#global-settings-default-manifest)

[Configure the environment timeout setting](https://www.puppet.com/docs/puppet/7/environments_creating.html#env_config_env_timeout)

Expand

An environment is a branch that gets turned into a directory on your primary Puppet server. Environments are turned on by        default.

## Environment structure

The structure of an environment follows several      conventions. 

When you create an environment, you give it the following structure:

- It contains a `modules` directory, which becomes part of the environment’s default               module path.

- It contains a `manifests` directory, which is the environment’s default main               manifest.

- If you are using Puppet 5, it can               optionally contain a `hiera.yaml`               file.

- It can optionally contain an `environment.conf` file, which can locally override configuration               settings, including `modulepath` and                  `manifest`.

  Note: Environment names can contain lowercase                  letters, numbers, and underscores. They must match the following regular                  expression rule: `\A[a-z0-9_]+\Z`. If you are using Puppet 5, remove the `environment_data_provider` setting.

## Environment resources

An environment specifies resources that the primary server uses when compiling        catalogs for agent nodes. The `modulepath`, the main manifest, Hiera data, and the config version script, can all be        specified in `environment.conf`. 

### The modulepath 

The `modulepath` is the list of directories Puppet loads modules from. By default, Puppet loads modules first from the environment’s                directory, and second from the primary server's `puppet.conf` file’s ` basemodulepath`                setting, which can be multiple directories. If the modules directory is empty or                absent, Puppet only uses modules from directories in                the `basemodulepath`.

Related topics: [module path.](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html)            

### The main manifest 

The main manifest is the starting point for compiling a catalog. Unless you say                otherwise in `environment.conf`, an environment uses the global                    `default_manifest` setting to determine its main manifest. The                value of this setting can be an absolute path to a manifest that all environments                share, or a relative path to a file or directory inside each environment.

The default value of `default_manifest` is                    `./manifests` — the environment’s own manifests directory. If the                file or directory specified by `default_manifest` is empty or absent,                    Puppet does not fall back to any other manifest.                Instead, it behaves as if it is using a blank main manifest. If you specify a value                for this setting, the global manifest setting from `puppet.conf` is                not be used by an environment.

Related topics: [main                     manifest,](https://www.puppet.com/docs/puppet/7/dirs_manifest.html)                [environment.conf,](https://www.puppet.com/docs/puppet/7/config_file_environment.html)                [default_manifest                     setting](https://www.puppet.com/docs/puppet/7/configuration.html), [puppet.conf.](https://www.puppet.com/docs/puppet/7/config_file_main.html)            

### Hiera data 

Each environment can use its own Hiera hierarchy and provide its own data.

Related topics: [Hiera config file                 syntax](https://www.puppet.com/docs/puppet/7/hiera_config_yaml_5.html#hiera_config_yaml_5).

### The config version script 

​                Puppet automatically adds a config version to every                catalog it compiles, as well as to messages in reports. The version is an arbitrary                piece of data that can be used to identify catalogs and events. By default, the                config version is the time at which the catalog was compiled (as the number of                seconds since January 1, 1970). 

### The environment.conf file 

An environment can contain an `environment.conf` file,                which can override values for certain settings.

The `environment.conf` file overrides these                settings:

- ​                        `modulepath`                    
- ​                        `manifest`                    
- ​                        `config_version`                    
- ​                        `environment_timeout`                    

Related topics: [environment.conf](https://www.puppet.com/docs/puppet/7/config_file_environment.html)            

## Create an environment

 Create an environment by adding a new directory of configuration data. 

1. ​                Inside your code directory, create a directory called                        environments.            

2. ​                Inside the environments directory, create a directory                    with the name of your new environment using the structure:                        `$codedir/environments/`                            

3. ​                Create a `modules` directory and a `manifests`                    directory. These two directories contain your Puppet code.             

4. Configure a `modulepath`:

   1. ​                        Set `modulepath` in its                                `environment.conf` file . If you set a value for this                            setting, the global `modulepath` setting from                                `puppet.conf` is not used by an environment.                    
   2. ​                        Check the `modulepath` by specifying the environment                            when requesting the setting value:                    

   ```
   $ sudo puppet config print modulepath --section server --environment test /etc/puppetlabs/code/environments/test/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules.Copied!
   ```

   Note: In Puppet Enterprise (PE), every                            environment must include `/opt/puppetlabs/puppet/modules`                            in its `modulepath`, because PE uses modules in that directory to                            configure its own infrastructure.

5. Configure a main manifest:

   1. ​                        Set manifest in its `environment.conf` file. As with the                            global `default_manifest` setting, you can specify a                            relative path (to be resolved within the environment’s directory) or an                            absolute path.                    
   2. ​                        Lock all environments to a single global manifest with the                                `disable_per_environment_manifest` setting —                            preventing any environment setting its own main manifest.                    

6. To specify an executable script that determines an environment’s config                    version:

   1. ​                        Specify a path to the script in the `config_version`                            setting in its `environment.conf` file. Puppet runs this script when compiling a                            catalog for a node in the environment, and uses its output as the config                            version. If you specify a value here, the global                                `config_version` setting from                                `puppet.conf` is not used by an environment.                    

   Note: If you’re using a system binary like git                                `rev-parse`, specify the absolute path to it. If                                `config_version` is set to a relative path, Puppet looks for the binary in the                            environment, not in the system’s PATH.

Results

Example environment.conf file:                

```
# /etc/puppetlabs/code/environments/test/environment.conf

# Puppet Enterprise requires $basemodulepath; see note below under "modulepath".
modulepath = site:dist:modules:$basemodulepath

# Use our custom script to get a git commit for the current state of the code:
config_version = get_environment_commit.shCopied!
```

Related topics: [Deploying environments with r10k](https://puppet.com/docs/pe/2017.3/code_management/r10k_deploy_env.html), [Code Manager control repositories](https://puppet.com/docs/pe/2017.3/code_management/control_repo.html), [disable_per_environment_manifest](https://www.puppet.com/docs/puppet/7/configuration.html)            

## Assign nodes to environments via an ENC

You can assign agent nodes to environments by using an                external node classifier (ENC). By default, all nodes are assigned to a default                environment named production.

The interface                                to set the environment for a node is different for each ENC. Some                                ENCs cannot manage environments. When writing an ENC: 

1. Ensure that the environment key is set in the YAML output that                                        the ENC returns. If the environment key isn’t set in the                                        ENC’s YAML output, the primary server uses the environment                                        requested by the agent. 

Note: The value                                        from the ENC is authoritative, if it exists. If the ENC                                        doesn’t specify an environment, the node’s config value is                                        used.

Related topics: [writing ENCs](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers). 

## Assign nodes to environments via the agent's config file

You can assign agent nodes to environments by using the      agent’s config file. By default, all nodes are assigned to a default environment named      production.

To configure an agent to use an environment:

1. ​            Open the agent's `puppet.conf` file in an editor.         
2. ​            Find the `environment` setting in either the agent or main               section.         
3. ​            Set the value of the `environment` setting to the name of the               environment you want the agent to be assigned to.         

Results

When that node requests a catalog from the primary server, it requests that environment.            If you are using an ENC and it specifies an environment for that node, it overrides            whatever is in the config file.

Note: Nodes cannot be assigned to unconfigured environments. If a node is               assigned to an environment that does not exist — no directory of that name in any of               the environment path directories — the primary server fails to compile its catalog.               The one exception to this is if the default production environment does not exist. In               this case, the agent successfully retrieves an empty catalog.

## Global settings for configuring environments

The settings in the primary server's `puppet.conf` file configure how            Puppet finds and uses environments. 

### environmentpath

The `environmentpath` setting is the list of directories where                    Puppet looks for environments. The default value                for `environmentpath` is `$codedir/environments`. If                you have more than one directory, separate them by colons and put them in order of                precedence. 

In this example, `temp_environments` is searched before                    `environments`:                

```
$codedir/temp_environments:$codedir/environmentsCopied!
```

If environments with the same name exist in both paths, Puppet uses the first environment with that name that                it encounters. 

Put the `environmentpath` setting in the main section of the                    `puppet.conf` file.

### basemodulepath

The `basemodulepath` setting lists directories of global modules that                all environments can access by default. Some modules can be made available to all                environments. The `basemodulepath` setting configures the global                module directories. 

By default, it includes `$codedir/modules` for user-accessible modules                and `/opt/puppetlabs/puppet/modules` for system modules. 

Add additional directories containing global modules by setting your own value for                    `basemodulepath`.

Related topics: [modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html). 

### environment_timeout 

The `environment_timeout` setting sets how often the primary                server refreshes information about environments. It can be overridden                per-environment. 

This setting defaults to 0 (caching disabled), which lowers the performance of your                primary server but makes it easy for new users to deploy updated Puppet code. After your code deployment process is                mature, change this setting to unlimited.

All code in Ruby and Puppet loaded from the environment is cached. Inputs                to compilation (for example, facts and looked up values) and the resulting catalog,                are not cached.

### disable_per_environment_manifest 

The `disable_per_environment_manifest` setting lets you specify                that all environments use a shared main manifest. 

When `disable_per_environment_manifest` is set to true, Puppet uses the same global manifest for every                environment. If an environment specifies a different manifest in                    `environment.conf`, Puppet does                not compile catalogs nodes in that environment, to avoid serving catalogs with                potentially wrong contents. 

If this setting is set to true, the `default_manifest` value must be                an absolute path.

### default_manifest 

The `default_manifest` setting specifies the main                manifest for any environment that doesn’t set a manifest value in                    `environment.conf`. The default value of                    `default_manifest` is `./manifests` — the                environment’s own manifests directory. 

The value of this setting can be:

- An absolute path to one manifest that all environments share.
- A relative path to a file or directory inside each environment’s                        directory.

Related topics: [default_manifest setting](https://www.puppet.com/docs/puppet/7/configuration.html). 

## Configure the environment timeout setting

The `enviroment_timeout` setting determines how often the primary Puppet server caches the data it loads from an environment.        For best performance, change the settings after you have a mature code deployment        process.

1. ​                Set `environment_timeout = unlimited` in `puppet.conf`.            
2. Change your code deployment process to refresh the primary server whenever you                    deploy updated code. For example, set a postrun command in your r10k config or add a step to your continuous                    integration job. 
   - With Puppet Server, refresh                                    environments by calling the `environment-cache`                                    API endpoint. Ensure you have write access to the puppet-admin                                    section of the `puppetserver.conf` file.
   - With a Rack primary server, restart the web server or the                                    application server. Passenger lets you touch a                                        `restart.txt` file to refresh an application                                    without restarting Apache. See the Passenger docs for                                    details.

Results

The `environment-timeout` setting can be overridden per-environment in                    `environment.conf`.

Note: Only use the value 0 or                    unlimited. Most primary servers use a pool of Ruby interpreters, which all have their own cache timers. When these timers are                    out of sync, agents can be served inconsistent catalogs. To avoid that                    inconsistency, refresh the primary server when deploying. 

# Environment isolation

### Sections

[Enable environment isolation with Puppet](https://www.puppet.com/docs/puppet/7/environment_isolation.html#env_isolation_puppet)

[Enable environment isolation with r10k ](https://www.puppet.com/docs/puppet/7/environment_isolation.html#env_isolation_r10k)

[Troubleshoot environment isolation](https://www.puppet.com/docs/puppet/7/environment_isolation.html#env_troubleshoot_isolation)

[The `generate          types` command](https://www.puppet.com/docs/puppet/7/environment_isolation.html#env_generate_types)

Environment isolation prevents resource types from leaking        between your various environments.

If you use multiple environments with Puppet, you might            encounter issues with multiple versions of the same resource type leaking between your            various environments on the primary server. This doesn’t happen with built-in resource            types, but it can happen with any other resource types. 

This problem occurs because Ruby            resource type bindings are global in the Ruby runtime.            The first loaded version of a Ruby resource type takes            priority, and then subsequent requests to compile in other environments get that            first-loaded version. Environment isolation solves this issue by generating and using            metadata that describes the resource type implementation, instead of using the Ruby resource type implementation, when compiling            catalogs.

Note: Other environment isolation problems, such as external helper logic issues or                varying versions of required gems, are not solved by the generated metadata                approach. This fixes only resource type leaking. Resource type leaking is a problem                that affects only primary servers, not agents.

## Enable environment isolation with Puppet

To use environment isolation, generate metadata files that            Puppet can use instead of the default Ruby resource type implementations.

1. ​                On the command line, run `puppet generate types --environment <ENV_NAME>`                    for each of your environments. For example, to generate metadata for your                    production environment, run: `puppet                        generate types --environment production`            
2. ​                Whenever you deploy a new version of Puppet,                    overwrite previously generated metadata by running `puppet generate types --environment <ENV_NAME>                        --force`            

## Enable environment isolation with r10k

To use environment isolation with r10k, generate types for each environment every time r10k deploys new code. 



1. To generate types with r10k, use one of the following methods:
   - Modify your existing r10k hook to run the `generate                              types` command after code deployment.
   - Create and use a script that first runs r10k for an environment, and then runs                              `generate types` as a                           post run command.
2. ​            If you have enabled environment-level purging in r10k, allow the `resource_types` folder so that r10k does not purge it.         

Results

Note: In Puppet Enterprise (PE), environment isolation is provided by Code Manager. Environment isolation is not               supported for r10k with PE.

## Troubleshoot environment isolation

If the `generate            types` command cannot generate certain types, if the type generated has missing        or inaccurate information, or if the generation itself has errors or fails, you get a        catalog compilation error of “type not found”        or “attribute not found.” 

1. To fix catalog compilation errors:
   1. ​                        Ensure that your Puppet resource types are correctly                            implemented. In addition to implementation errors, check for types with                            title patterns that contain a proc or a lambda, as these types cannot be                            generated. Refactor any problem resource types.                    
   2. ​                        Regenerate the metadata by removing the                            environment’s `.resource_types` directory and running the `generate types` command again.                    
   3. ​                        If you continue to get catalog compilation                            errors, disable environment isolation to help you isolate the                            error.                    
2. To disable environment isolation in open source                        Puppet:
   1. ​                        Remove the `generate types` command from any r10k hooks.                    
   2. ​                        Remove the `.resource_types` directory.                    
3. To disable environment isolation in Puppet Enterprise (PE):
   1. ​                        In `/etc/puppetlabs/puppetserver/conf.d/pe-puppet-server.conf`,                            remove the `pre-commit-hook-commands` setting.                    
   2. ​                        In Hiera, set                                `puppet_enterprise::server::puppetserver::pre_commit_hook_commands:                                []`                                            
   3. ​                        On the command line, run `service pe-puppetserver reload`                                            
   4. ​                        Delete the `.resource_types` directories from your staging                            code directory, `/etc/puppetlabs/code-staging`                                            
   5. ​                        Deploy the environments.                    

## The `generate         types` command

When you run the `generate types` command, it scans the entire environment for resource type      implementations, excluding core Puppet resource      types.

The               `generate types` command accepts the            following options:

- `--environment                        <ENV_NAME>`: The environment for which to generate metadata.                     If you do not specify this argument, the metadata is generated for the default                     environment (`production`).
- `--force`:                     Use this flag to overwrite all previously generated metadata.

For each resource type implementation it finds, the command            generates a corresponding metadata file, named after the resource type, in the `<env-root>/.resource_types` directory.            It also syncs the files in the `.resource_types` directory so that:

- Types that have been removed in modules are removed from                        `resource_types`.
- Types that have been added are added to `resource_types`.
- Types that have not changed (based on timestamp) are kept as                     is.
- Types that have changed (based on timestamp) are overwritten                     with freshly generated metadata.

The generated metadata files, which have a `.pp` extension, exist in the code            directory. If you are using Puppet Enterprise with Code Manager and file sync, these files appear in both the            staging and live code directories. The generated files are read-only. Do not delete            them, modify them, or use expressions from them in manifests.

# Directories and files

Puppet consists of a number of directories and files, and        each one has an important role ranging from Puppet code        storage and configuration files to manifests and module paths.



**[Code and data directory (codedir)](https://www.puppet.com/docs/puppet/7/dirs_codedir.html)**
The codedir is the main directory for Puppet code and       data. It is used by the primary Puppet server and Puppet apply, but not by Puppet       agent. It contains environments (which contain your manifests and modules) and a global       modules directory for all environments. **[Config directory (confdir)](https://www.puppet.com/docs/puppet/7/dirs_confdir.html)**
         Puppet’s `confdir` is the main directory for the Puppet configuration. It contains configuration files and the         SSL data. **[Main manifest directory](https://www.puppet.com/docs/puppet/7/dirs_manifest.html)**
Puppet starts                         compiling a catalog either with a single manifest file or with a directory                         of manifests  that are treated like a single file. This starting point is                         called the *main                                     manifest* or *site                                     manifest*. **[The modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html)**
The primary server service and the `puppet       apply` command load most of their content from modules found in one or more       directories. The list of directories where Puppet looks       for modules is called the *modulepath*. The modulepath is set by the current node's       environment. **[SSL directory (ssldir)](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html)**
     Puppet stores its certificate infrastructure in     the SSL directory (ssldir) which has a similar structure on all Puppet nodes, whether they are agent nodes, primary Puppet servers, or the certificate authority (CA)     server. **[Cache directory (vardir)](https://www.puppet.com/docs/puppet/7/dirs_vardir.html)**
As part of its normal operations, Puppet generates data which is stored in a cache directory called     vardir.  You can mine the data in vardir for analysis, or use it to integrate  other tools with       Puppet. 

# Code and data directory (codedir)

### Sections

[Location](https://www.puppet.com/docs/puppet/7/dirs_codedir.html#codedir-location)

[Interpolation of `$codedir`          ](https://www.puppet.com/docs/puppet/7/dirs_codedir.html#codedir-interpolation)

[Contents](https://www.puppet.com/docs/puppet/7/dirs_codedir.html#codedir-contents)

The codedir is the main directory for Puppet code and      data. It is used by the primary Puppet server and Puppet apply, but not by Puppet      agent. It contains environments (which contain your manifests and modules) and a global      modules directory for all environments.

## Location

The codedir is located in one of the following locations: 

- ​                     *nix: `/etc/puppetlabs/code`                  
- ​                     *nix non-root users: `~/.puppetlabs/etc/code`                  
- ​                     Windows: `%PROGRAMDATA%\PuppetLabs\code` (usually `C:\ProgramData\PuppetLabs\code`) 

When Puppet is running as root, as a Windows user with administrator privileges, or as the               `puppet` user, it uses a system-wide codedir. When            running as a non-root user, it uses a codedir in that user's home directory.

When running Puppet commands and services as `root` or `puppet`, use the            system codedir. To use the same codedir as the Puppet            agent, or the primary server, run admin commands such as `puppet module` with `sudo`.

To configure the location of the codedir, set the [                `codedir`             ](https://www.puppet.com/docs/puppet/7/configuration.html) setting in your `puppet.conf` file, such as:            

```
codedir = /etc/puppetlabs/codeCopied!
```

Important:                Puppet Server doesn't use the codedir setting in `puppet.conf`, and instead uses the `                  jruby-puppet.master-code-dir` setting in [                   `puppetserver.conf`                ](https://puppet.com/docs/puppetserver/latest/config_file_puppetserver.html). When using a non-default codedir, you must change both settings.

## Interpolation of `$codedir`         

The value of the codedir is discovered before other settings, so you can refer to it in            other `puppet.conf` settings by using the `$codedir` variable in the value. For example, the               `$codedir` variable is used as part of the value for the               `environmentpath` setting:            

```
[server]
   environmentpath = $codedir/override_environments:$codedir/environmentsCopied!
```

This allows you to avoid absolute paths in your settings and keep your Puppet-related files together.

## Contents

The codedir contains environments, including manifests and modules, and a global modules            directory for all environments.

The code and data directories are: 

- ​                  [                      `environments`                   ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments_creating): Contains alternate versions of the `modules` and `manifests` directories, to                  enable code changes to be tested on smaller sets of nodes before entering                  production. 
- ​                  [                      `modules`                   ](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html): The main directory for modules. 

# Config directory (confdir)

### Sections

[Location](https://www.puppet.com/docs/puppet/7/dirs_confdir.html#confdir-location)

[Interpolation of `$confdir`             ](https://www.puppet.com/docs/puppet/7/dirs_confdir.html#confdir-interpolation)

[Contents](https://www.puppet.com/docs/puppet/7/dirs_confdir.html#confdir-contents)

​        Puppet’s `confdir` is the main directory for the Puppet configuration. It contains configuration files and the        SSL data.

## Location

The confdir is located in one of the following locations: 

- ​                            *nix root users: `/etc/puppetlabs/puppet`                        
- Non-root users: `~/.puppetlabs/etc/puppet`                        
- ​                            Windows: `%PROGRAMDATA%\PuppetLabs\puppet\etc` (usually `C:\ProgramData\PuppetLabs\puppet\etc`) 

When Puppet is running as `root`, a Windows user with administrator                privileges, or the `puppet` user, it uses a                system-wide confdir. When running as a non-root user, it uses a confdir in that                user's home directory. 

When running Puppet commands and services as `root` or `puppet`,                usually you want to use the system codedir. To use the same codedir as the Puppet agent or the primary Puppet server, run admin commands with `sudo`.

Puppet’s confdir can’t be set in the `puppet.conf`,                because Puppet needs the confdir to locate                that config file. Instead, run commands with the `--confdir` parameter to specify the confdir. If `--confdir` isn’t specified when a Puppet application                is started, the command uses the default confdir location.

​                Puppet Server uses the `jruby-puppet.server-conf-dir` setting in [                     `puppetserver.conf`                 ](https://puppet.com/docs/puppetserver/latest/config_file_puppetserver.html) to configure its confdir. If you are using a non-default confdir, you must                specify `--confdir` when you run commands like `puppet module` to ensure they use the same directories as                    Puppet Server.

## Interpolation of `$confdir`            

The value of the confdir is discovered before other settings, so you can                reference it, using the `$confdir` variable,                in the value of any other setting in `puppet.conf`.

If you need to set nonstandard values for some settings, using the `$confdir` variable allows you to avoid absolute paths and                keep your Puppet-related files together.

## Contents

The confdir contains several config files and the SSL data. You can change their                locations, but unless you have a technical reason that prevents it, use the default                structure. Click the links to see documentation for the files and directories in the                codedir. 

On all nodes, agent and primary server, the confdir contains the following                directories and config files: 

- ​                        [`ssl`](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html)                        directory: contains each node’s certificate infrastructure. 
- ​                        [`puppet.conf`](https://www.puppet.com/docs/puppet/7/config_file_main.html): Puppet’s main config file. 
- ​                        [`csr_attributes.yaml`](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html): Optional data to be inserted                        into new certificate requests. 

On primary server nodes, and sometimes standalone nodes that run Puppet apply, the confdir also contains: 

- ​                        [`auth.conf`](https://puppet.com/docs/puppetserver/latest/config_file_auth.html):                        Access control rules for the primary server's network services. 

- ​                        [`fileserver.conf`](https://www.puppet.com/docs/puppet/7/config_file_fileserver.html): Configuration for additional                        fileserver mount points. 

- `hiera.yaml`

  : The global configuration for Hiera data                        lookup. Environments and modules can also have their own 

  ```
  hiera.yaml
  ```

   files. 

  Note:  To provide backward                            compatibility for some existing Puppet 4                            installations, if a `hiera.yaml` file exists in the                            codedir, it takes precedence over `hiera.yaml` in the                            confdir. To ensure that Puppet honors the                            configuration in the confdir, remove any `hiera.yaml`                            file that is present in the codedir.

- ​                        [                                                          `routes.yaml`                         ](https://www.puppet.com/docs/puppet/7/config_file_routes.html): Advanced configuration of indirector behavior. 

On certificate authority servers, the confdir also contains: 

- ​                        [                                                          `autosign.conf`                         ](https://www.puppet.com/docs/puppet/7/config_file_autosign.html): List of pre-approved certificate requests. 

On nodes that are acting as a proxy for configuring network devices, the confdir also                contains: 

- ​                        [`device.conf`](https://www.puppet.com/docs/puppet/7/config_file_device.html): Configuration for network devices                        managed by the `puppet                        device` command. 

# Main manifest directory

### Sections

[Specifying the manifest for Puppet apply](https://www.puppet.com/docs/puppet/7/dirs_manifest.html#specifying-manifest-puppet-apply)

[Specifying the manifest for primary Puppet         server](https://www.puppet.com/docs/puppet/7/dirs_manifest.html#specifying-manifest-puppet-server)

[Manifest directory behavior](https://www.puppet.com/docs/puppet/7/dirs_manifest.html#manifest-directory-behavior)

Puppet starts                        compiling a catalog either with a single manifest file or with a directory                        of manifests that are treated like a single file. This starting point is                        called the *main                                    manifest* or *site                                    manifest*.

For more information about how the site manifest is                                    used in catalog compilation, see [Catalog                                                 compilation](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#subsystem_catalog_compilation).

## Specifying the manifest for Puppet apply

The `puppet apply` command uses the manifest you pass to it        as an argument on the command line:

```
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
Copied!
```

You can pass Puppet apply either a single `.pp` file or a        directory of `.pp` files. Puppet apply uses the manifest you        pass it, not an environment's manifest. 

## Specifying the manifest for primary Puppet        server

The primary Puppet server uses the main manifest set by the        current node's [environment](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about), whether that        manifest is a single file or a directory of `.pp` files. 

 By default, the main manifest for an environment is `<ENVIRONMENTS DIRECTORY>/<ENVIRONMENT>/manifests`, for example          `/etc/puppetlabs/code/environments/production/manifests`.        You can configure the manifest per-environment, and you can also configure the default for        all environments.

To determine its main manifest, an environment uses the `manifest` setting in [`environment.conf`](https://www.puppet.com/docs/puppet/7/config_file_environment.html). This can be        an absolute path or a path relative to the environment’s main directory. 

If the `environment.conf``manifest` setting is absent, it uses the value of [the `default_manifest` setting](https://www.puppet.com/docs/puppet/7/configuration.html) from the `puppet.conf` file. The `default_manifest` setting        defaults to `./manifests`. Similar to the environment's          `manifest` setting, the value of `default_manifest` can be an absolute path or a path relative to the environment’s        main directory.

To force all environments to ignore their own `manifest`        setting and use the `default_manifest` setting instead, set          `disable_per_environment_manifest = true` in `puppet.conf`.

To check which manifest your primary server uses for a given        environment, run:

```
puppet config print manifest --section server --environment <ENVIRONMENT>Copied!
```

For more information, see [Creating           environments](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments_creating), and [Checking values of configuration settings](https://www.puppet.com/docs/puppet/7/config_print.html). 

## Manifest directory behavior

When the main manifest is a directory, Puppet parses every          `.pp` file in the directory in alphabetical order and        evaluates the combined manifest. It descends into all subdirectories of the manifest        directory and loads files in depth-first order. For example, if the manifest directory        contains a directory named `01`, and a file named `02.pp`, it parses the files in `01` before it parses `02.pp`.

Puppet treats the directory as one manifest, so, for        example, a variable assigned in the file `01_all_nodes.pp` is accessible in `node_web01.pp`.

Note: Puppet does not follow symlinks when the `manifest` setting refers to a directory.

# The modulepath

### Sections

[Setting the modulepath and base modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html#setting-modulepath-and-base-modulepath)

[Using the `--modulepath` option with Puppet apply](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html#using-modulepath-option-puppet-apply)

[Absent, duplicate, and conflicting content from modules](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html#absent-duplicate-conflicting-modules)

The primary server service and the `puppet      apply` command load most of their content from modules found in one or more      directories. The list of directories where Puppet looks      for modules is called the *modulepath*. The modulepath is set by the current node's      environment.

The modulepath is an ordered list of directories, with earlier         directories having priority over later ones. Use the system path separator character         to separate the directories in the modulepath list. On *nix systems, use a colon (`:`); on Windows use         a semi-colon (`;`).

For example, on *nix:         

```
/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modulesCopied!
```

​         On Windows:         

```
C:/ProgramData/PuppetLabs/code/environments/production/modules;C:/ProgramData/PuppetLabs/code/modulesCopied!
```

Each directory in the modulepath must contain only valid Puppet modules, and the names of those modules must follow         the modules naming rules. Dashes and periods in module names cause errors. For more         information, see [Modules fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals).

By default, the modulepath is set by the current node's environment in `environment.conf`. For example, using *nix         paths:

```
modulepath = site:dist:modules:$basemodulepathCopied!
```

To         see what the modulepath is for an environment,         run:

```
sudo puppet config print modulepath --section server --environment <ENVIRONMENT_NAME>Copied!
```

For         more information about environments, see [Environments](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about). 

## Setting the modulepath and base modulepath

Each environment sets its full modulepath in the  [                `                   `](https://puppet.com/docs/puppet/5.5/config_file_environment.html)`environment.conf               `             file with the `modulepath` setting.               The `modulepath` setting can only be set               in `environment.conf`. It configures the entire            modulepath for that environment.

The modulepath can include relative paths, such as `./modules` or `./site`. Puppet looks            for these paths inside the environment’s directory.

The default modulepath value for an environment is the            environment’s modules directory, plus the base modulepath. On *nix, this is `./modules:$basemodulepath`.

The **base modulepath** is a list of global module directories            for use with all environments. You can configure it with the `basemodulepath` setting in the `puppet.conf` file, but its default value is probably suitable. The default            on *nix:

```
$codedir/modules:/opt/puppetlabs/puppet/modulesCopied!
```

On               Windows:

```
$codedir\modulesCopied!
```

If you            want an environment to have access to the global module directories,               include `$basemodulepath` in the environment's            modulepath            setting:

```
modulepath = site:dist:modules:$basemodulepathCopied!
```

## Using the `--modulepath` option with Puppet apply

When running  Puppet apply on the command line,            you can optionally specify a modulepath with the `--modulepath` option, which overrides the modulepath from the current            environment.

## Absent, duplicate, and conflicting content from modules

​            Puppet uses modules it finds in every directory in the            modulepath. Directories in the modulepath can be empty or absent. This is not an error;               Puppet does not attempt to load modules from those            directories. If no modules are present across the entire modulepath, or if modules are            present but none of them contains a `lib` directory, the agent logs an error when attempting to sync plugins            from the primary server. This error is benign and doesn't prevent the rest of the            run.

If the modulepath contains multiple modules with the same name, Puppet uses the version            from the directory that comes **earliest** in the modulepath. Modules in            directories earlier in the modulepath override those in later directories.

For most content, this earliest-module-wins behavior is on an               all-or-nothing, **per-module** basis — all of the manifests,            files, and templates in the first-encountered version are available for use,            and none of the content from any subsequent versions is available. This            behavior covers: 

- ​                     Puppet code (from `manifests`). 
- Files (from `files`). 
- Templates (from `templates`). 
- External facts (from `facts.d`). 
- ​                     Ruby plugins synced to agent nodes                        (from `lib`). 

CAUTION:Puppet sometimes displays unexpected behavior               with  Ruby plugins that are loaded directly from               modules. This includes: 

- Plugins used by the primary server (custom resource types, custom                        functions).
- Plugins used by `puppet apply`. 
- Plugins present in the agent’s modulepath (which is usually empty but night                        not be when running an agent on a node that is also a primary server).

In this case, the plugins are handled on a **per-file** basis                  instead of per-module. If a duplicate module in an later directory                  has additional plugin files that don’t exist in the first instance of                  the module, those extra files *are* loaded, and Puppet uses a a mixture of files from both versions                  of the module.

If you refactor a module’s Ruby plugins, and maintain two versions of that module in your modulepath, it can                  have unexpected results.

This is a byproduct of how Ruby works and is not intentional or controllable by                     Puppet; a fix is not expected.

# SSL directory (ssldir)

### Sections

[Location](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html#ssldir-location)

[Contents](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html#ssldir-content)

[The ssldir directory structure](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html#ssldir-structure)

​    Puppet stores its certificate infrastructure in    the SSL directory (ssldir) which has a similar structure on all Puppet nodes, whether they are agent nodes, primary Puppet servers, or the certificate authority (CA)    server.

## Location

By default, the ssldir is a subdirectory of the [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html). 

You can change its location using the `ssldir` setting        in the `puppet.conf` file. See the [Configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html) for more        information. 

Note: The content of the ssldir is generated, grows over time, and          is relatively difficult to replace. Some third-party Puppet          packages for Linux place the ssldir in the cache directory            ([vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html)) instead of the confdir. When a          distro changes the ssldir location, it sets `ssldir` in the `$confdir/puppet.conf` file, usually in the `[main]` section. 

To see the location of the ssldir on one of your nodes, run: `puppet          config print ssldir`      

## Contents

The ssldir contains Puppet certificates, private        keys, certificate signing requests (CSRs), and other cryptographic documents. 

The ssldir on an agent or primary server contains: 

- A private key: `private_keys/<certname>.pem`            
- A signed certificate: `certs/<certname>.pem`            
- A copy of the CA certificate: `certs/ca.pem`            
- A copy of the certificate revocation list (CRL): `crl.pem`            
- A copy of its sent CSR: `certificate_requests/<certname>.pem`            

Tip:  Puppet does not save its public key to disk, because the public key is        derivable from its private key and is contained in its certificate. If you need to extract        the public key, use `$ openssl rsa -in $(puppet config print hostprivkey)          -pubout`      

 If these files don’t exist on a node, it's because they are generated locally or requested        from the CA server.

Agent and primary server credentials are identified by [certname](https://www.puppet.com/docs/puppet/7/configuration.html), so an agent process and a primary server process running on the same        server can use the same credentials.

The ssldir for the Puppet CA, which runs on the CA        server, contains similar credentials: private and public keys, a certificate, and a primary        server copy of the CRL. It maintains a list of all signed certificates in the deployment, a        copy of each signed certificate, and an incrementing serial number for new certificates. To        keep it separated from general Puppet credentials on the same        server, all of the CA’s data is stored in the `ca` subdirectory.

## The ssldir directory structure

All of the files and directories in the `ssldir` directory have corresponding Puppet        settings, which can be used to change their locations. Generally, though, don't change the        default values unless you have a specific problem to work around.

Ensure the permissions mode of the ssldir is 0771. The directory and each file in        it is owned by the user that Puppet runs as: root or        Administrator on agents, and defaulting to `puppet` or `pe-puppet` on a primary        server. Set up automated management for ownership and permissions on the ssldir.

The ssldir has the following structure. See the [Configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html) for details about each `puppet.conf` setting listed: 

- ```
  ca
  ```

   directory (on the CA server only): Contains the files            used by 

  Puppet

  ’s certificate authority. Mode: 0755.            Setting: 

  ```
  cadir
  ```

  . 

  - ​                `ca_crl.pem`: The primary server copy of the                certificate revocation list (CRL) managed by the CA. Mode: 0644.                  Setting: `cacrl`. 

  - ​                `ca_crt.pem`: The CA’s self-signed certificate. This                cannot be used as a primary server or agent certificate; it can only be used to sign                certificates. Mode: 0644. Setting: `cacert`. 

  - ​                `ca_key.pem`: The CA’s private key, and one of the                most security-critical files in the Puppet                certificate infrastructure. Mode: 0640. Setting: `cakey`. 

  - ​                `ca_pub.pem`: The CA’s public key. Mode: 0644.                  Setting: `capub`. 

  - ​                `inventory.txt`: A list of the certificates the CA                signed, along with their serial numbers and validity periods. Mode: 0644.                  Setting: `cert_inventory`. 

  - ```
    requests
    ```

     (directory): Contains the certificate                signing requests (CSRs) that have been received but not yet signed. The CA deletes                CSRs from this directory after signing them. Mode: 0755. Setting: 

    ```
    csrdir
    ```

    . 

    - ​                    `<name>.pem`: CSR files awaiting signing.                  

  - ​                `serial`: A file containing the serial number for the                next certificate the CA signs. This is incremented with each new certificate signed.                Mode: 0644. Setting: `serial`. 

  - ```
    signed
    ```

     (directory): Contains copies of all                certificates the CA has signed. Mode: 0755. Setting: 

    ```
    signeddir
    ```

    . 

    - ​                    `<name>.pem`: Signed certificate files.                  

- ```
  certificate_requests
  ```

   (directory): Contains CSRs            generated by this node in preparation for submission to the CA. CSRs stay in this            directory even after they have been submitted and signed. Mode: 0755.              Setting: 

  ```
  requestdir
  ```

  . 

  - ​                `<certname>.pem`: This node’s CSR. Mode: 0644.                  Setting: `hostcsr`. 

- ```
  certs
  ```

   (directory): Contains signed certificates present            on the node. This includes the node’s own certificate, and a copy of the CA certificate            for validating certificates presented by other nodes. Mode: 0755. Setting: 

  ```
  certdir
  ```

  . 

  - ​                `<certname>.pem`: This node’s certificate. Mode:                0644. Setting: `hostcert`. 
  - ​                `ca.pem`: A local copy of the CA certificate. Mode:                0644. Setting: `localcacert`. 

- ​            `crl.pem`: A copy of the certificate revocation list (CRL)            retrieved from the CA, for use by agents or primary servers. Mode: 0644.              Setting: `hostcrl`. 

- ```
  private
  ```

   (directory): Usually, does not contain any            files. Mode: 0750. Setting: 

  ```
  privatedir
  ```

  . 

  - ​                `password`: The password to a node’s private key.                Usually not present. The conditions in which this file would exist are not defined.                Mode: 0640. Setting: `passfile`. 

- ```
  private_keys
  ```

   (directory): Contains the node's private            key and, on the CA, private keys created by the 

  ```
  puppetserver ca
                generate
  ```

   command. It never contains the private key for the CA certificate.            Mode: 0750. Setting: 

  ```
  privatekeydir
  ```

  . 

  - ​                `<certname>.pem`: This node’s private key. Mode:                0600. Setting: `hostprivkey`. 

- ```
  public_keys
  ```

   (directory): Contains public keys generated            by this node in preparation for generating a CSR. Mode: 0755. Setting: 

  ```
  publickeydir
  ```

  . 

  - ​                `<certname>.pem`: This node’s public key. Mode:                0644. Setting: `hostpubkey`. 

# Cache directory (vardir)

### Sections

[Location](https://www.puppet.com/docs/puppet/7/dirs_vardir.html#vardir-location)

[Interpolation of `$vardir`       ](https://www.puppet.com/docs/puppet/7/dirs_vardir.html#vardir-inerpolation)

[Contents](https://www.puppet.com/docs/puppet/7/dirs_vardir.html#vardir-contents)

As part of its normal operations, Puppet generates data which is stored in a cache directory called    vardir. You can mine the data in vardir for analysis, or use it to integrate other tools with      Puppet. 

## Location

 The cache directory for Puppet Server defaults to `/opt/puppetlabs/server/data/puppetserver`.

The cache directory for the Puppet agent and Puppet apply can be found at one of the following locations: 

- ​              *nix systems: `/opt/puppetlabs/puppet/cache`. 
- Non-root users: `~/.puppetlabs/opt/puppet/cache`. 
- ​              Windows: `%PROGRAMDATA%\PuppetLabs\puppet\cache` (usually `C:\Program Data\PuppetLabs\puppet\cache`). 

When Puppet is running as root, a Windows user with administrator privileges, or the `puppet` user, uses a system-wide cache directory. When running        as a non-root user, it uses a cache directory in the user’s home directory. 

Because you usually run Puppet’s commands and services as root or `puppet`, the system cache directory is what you usually want to        use.  

Important: To use the same directories as the agent or primary server, admin          commands like `puppetserver ca`, must run            with `sudo`.

Note: When the primary server is running as a Rack application, the `config.ru` file must explicitly set `--vardir` to the system cache directory. The            example `config.ru` file provided with the Puppet source does this.

You can specify Puppet’s cache directory on the command line        by using the `--vardir` option, but you can’t set it          in `puppet.conf`. If `--vardir` isn’t specified when a Puppet application is started, it uses the        default cache directory location.

To configure the Puppet Server cache directory, use          the `jruby-puppet.server-var-dir` setting [in `puppetserver.conf`         ](https://puppet.com/docs/puppetserver/latest/config_file_puppetserver.html).

## Interpolation of `$vardir`      

The value of the vardir is discovered before other settings, so you can reference        it using the `$vardir` variable in the value of any other        setting in `puppet.conf` or on the command line.

For example: 

```
[main]
  ssldir = $vardir/sslCopied!
```

If you need to set nonstandard values for some settings, using the `$vardir` variable allows you to avoid absolute paths and keep your Puppet-related files together.

## Contents

The vardir contains several subdirectories. Most of these subdirectories contain a        variable amount of generated data, some contain notable individual files, and some        directories are used only by agent or primary server processes.

To change the locations of specific vardir files and directories, edit the settings          in `puppet.conf`. For more information about each item        below, see the [Configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html). 

| Directory name           | Config setting         | Notes                                                        |
| ------------------------ | ---------------------- | ------------------------------------------------------------ |
| `bucket`                 | `bucketdir`            |                                                              |
| `client_data`            | `client_datadir`       |                                                              |
| `clientbucket`           | `clientbucketdir`      |                                                              |
| `client_yaml`            | `clientyamldir`        |                                                              |
| `devices`                | `devicedir`            |                                                              |
| `lib/facter`             | `factpath`             |                                                              |
| `facts`                  | `factpath`             |                                                              |
| `facts.d`                | `pluginfactdest`       |                                                              |
| `lib`                    | `libdir`, `plugindest` | Puppet uses this as a cache for plugins (custom                  facts, types and providers, functions) synced from a primary server. Do not change                  its contents. If you delete it, the plugins are restored on the next Puppet run. |
| `puppet-module`          | `module_working_dir`   |                                                              |
| `puppet-module/skeleton` | `module_skeleton_dir`  |                                                              |
| `reports`                | `reportdir`            | When the option to store reports is enabled, a primary server stores reports                  received from agents as YAML files in this directory. You can mine these reports                  for analysis. |
| `server_data`            | `serverdatadir`        |                                                              |
| `state`                  | `statedir`             | See table below for more details about the `state` directory contents. |
| `yaml`                   | `yamldir`              |                                                              |

 The `state` directory contains the following files        and directories: 

| File or directory name   | Config setting               | Notes                                                        |
| ------------------------ | ---------------------------- | ------------------------------------------------------------ |
| `agent_catalog_run.lock` | `agent_catalog_run_lockfile` |                                                              |
| `agent_disabled.lock`    | `agent_disabled_lockfile`    |                                                              |
| `classes.txt`            | `classfile`                  | This file is useful for external integration. It lists all of the classes                  assigned to this agent node. |
| `graphs` directory       | `graphdir`                   | When graphing is enabled, agent nodes write a set of `.dot` graph files to this directory. Use these graphs to diagnose                  problems with the catalog application, or visualizing the configuration catalog. |
| `last_run_summary.yaml`  | `lastrunfile`                | This file is stored in a public directory and is visible to external                    monitoring tools — making sure the Puppet agent                    is running every 30 minutes. |
| `last_run_report.yaml`   | `lastrunreport`              |                                                              |
| `resources.txt`          | `resourcefile`               |                                                              |
| `state.yaml`             | `statefile`                  |                                                              |

# Report reference

### Sections

[`http`](https://www.puppet.com/docs/puppet/7/report.html#report-http)

[`log`](https://www.puppet.com/docs/puppet/7/report.html#report-log)

[`store`](https://www.puppet.com/docs/puppet/7/report.html#report-store)

Puppet has a set of built-in report processors, which    you can configure.

By default, after applying a catalog, Puppet generates a        report that includes information about the run: events, log messages, resource statuses,        metrics, and metadata. Each host sends its report as a YAML dump.

The agent sends its report to the primary server for processing, whereas agents running          `puppet apply` process their own reports. Either way, Puppet handles every report with a set of report processors,        which are specified in the `reports` setting in the agent's          `puppet.conf` file.

By default, Puppet uses the `store` report processor. You can enable other report processors or disable        reporting in the `reports` setting.

## `http`

Sends reports via HTTP or HTTPS. This report processor submits reports as POST requests to        the address in the `reporturl` setting. When you specify an        HTTPS URL, the remote server must present a certificate issued by the Puppet CA or the connection fails validation. The body of each        POST request is the YAML dump of a `Puppet::Transaction::Report` object, and the content type is set as `application/x-yaml`. 

## `log`

Sends all received logs to the local log destinations. The usual log        destination is `syslog`.

## `store`

Stores the `yaml` report in the configured          `reportdir`. By default, this is the report processor Puppet uses. These files collect quickly — one every half hour        — so be sure to perform maintenance on them if you use this report. 



### server

Puppet Server 接受 `puppet.conf` 中的几乎所有设置，并自动拾取它们。但是，对于某些任务，例如配置Web服务器或外部证书颁发机构，存在特定于Puppet Server的配置文件和设置。

### agent

#### 配置 `PATH` 以访问 Puppet 命令

Puppet 的命令行界面（CLI）由一个 Puppet 命令和许多子命令组成，例如 `puppet --help` 。

Puppet 命令位于 bin 目录：

* *nix          —  `/opt/puppetlabs/bin/`

* Windows — `C:\Program Files\Puppet Labs\puppet\bin` 

默认情况下，bin 目录不在 PATH 环境变量中。要访问 Puppet 命令，必须将 bin 目录添加到 PATH 中。

##### Linux: source a script for puppet-agent to install

```bash
source /etc/profile.d/puppet-agent.sh
```

##### *nix: Add the Puppet labs bin directory to your PATH

```bash
export PATH=/opt/puppetlabs/bin:$PATH
```

或者，可以在 `.profile` 或 `.bashrc` 配置文件中配置 PATH 。

##### Windows: Add the Puppet labs bin directory to your **PATH**

To run Puppet commands on `Windows`, start a command prompt with administrative                privileges. You can do so by right-clicking the Start Command Prompts with Puppet program and clicking                    Run as administrator. Click Yes if                the system asks for UAC confirmation.

The Puppet agent `.msi` adds the Puppet bin directory to                the system path automatically. If you are not using the Start Command Prompts, you                may need to manually add the bin directory to your PATH using one of the following                commands: 

要在Windows上运行Puppet命令，请使用管理权限启动命令提示符。您可以通过右键单击“使用木偶程序启动命令提示”并单击“以管理员身份运行”来执行此操作。如果系统要求UAC确认，请单击是。

Puppet-agent.msi会自动将Puppet-bin目录添加到系统路径中。如果未使用“开始命令提示”，则可能需要使用以下命令之一手动将bin目录添加到PATH中：

For cmd.exe,                run:

```powershell
set PATH=%PATH%;"C:\Program Files\Puppet Labs\Puppet\bin"
```

For PowerShell,                run:

```powershell
 $env:PATH += ";C:\Program Files\Puppet Labs\Puppet\bin"
```

#### 配置 `server` 设置

`server` 设置是唯一的强制设置，它允许将代理连接到主 Puppet 服务器。

可以使用 `puppet config set` 子命令向代理添加配置，该命令会自动编辑 `puppet.conf` 文件，或者直接编辑 `/etc/puppetlabs/puppet/puppet.conf` 文件。

从以下选项之中选择：

- 在代理节点，执行：

  ```bash
  puppet config set server puppetserver.example.com --section main
  ```

- 手动编辑 `/etc/puppetlabs/puppet/puppet.conf` 或 `C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf` 。

  Note that the location on Windows depends on whether you are running with administrative privileges. If you are not, it will be in home directory, not system location.
  
  请注意，Windows上的位置取决于您是否以管理权限运行。如果没有，它将位于主目录，而不是系统位置。

结果：

此命令添加设置 `server = puppetserver.example.com` 到 puppet.conf 文件中的 `[main]`  部分。

Note that there are other optional settings, for example,                    `serverport`, `ca_server`, `ca_port`, `report_server`, `report_port`, which you might need for more complicated Puppet deployments, such as                when using a CA server and multiple compilers.

请注意，还有其他可选设置，例如，serverport、ca server、ca port、report server、report port，这些设置可能需要用于更复杂的Puppet部署，例如使用ca服务器和多个编译器时。

#### 将代理连接到主服务器并签署证书

添加 `server` 后，须将 Puppet 代理连接到主服务器， so that it will check in at regular intervals to report its state, retrieve its catalog以便它将定期检查以报告其状态、检索其目录，并在需要时更新其配置。

要将代理连接到主服务器，请运行：

```bash
puppet ssl bootstrap
```

> Note:
>
> 对于 Puppet 5 agent，执行 `puppet agent --test` 替代。

将看到如下消息：

```bash
Info: Creating a new RSA SSL key for <agent node>
```

在主服务器节点上，签署证书：

```bash
puppetserver ca sign --certname <name>
```

在代理节点上，再次运行代理：

```bash
puppet ssl bootstrap
```

# Platform components

Puppet is made up of several packages. Together these        are called the Puppet platform, which is what you use to        manage, store and run your Puppet code. These packages        include `puppetserver`, `puppetdb`, and            `puppet-agent` — which includes Facter.

**[Facter](https://www.puppet.com/docs/puppet/7/facter.html)**
Facter is Puppet’s       cross-platform system profiling library. It discovers and reports per-node facts, which are       available in your Puppet manifests as variables.  **[PuppetDB](https://www.puppet.com/docs/puppet/7/puppetdb_overview.html)**
All of the data generated by Puppet (for example facts, catalogs,         reports) is stored in PuppetDB. **[Puppet services and tools](https://www.puppet.com/docs/puppet/7/puppets_services_tools.html)**
Puppet provides a number of core services and         administrative tools to manage systems with or without  a primary Puppet server, and to compile configurations for Puppet agents.  **[Puppet reports](https://www.puppet.com/docs/puppet/7/reporting.html)**
   Puppet creates a report about its actions and your infrastructure   each time it applies a catalog during a Puppet run. You can create   and use report processors to generate insightful information or alerts from those   reports. **[Life cycle of a Puppet run](https://www.puppet.com/docs/puppet/7/details_about_puppets_internals.html)**
Learn the details of Puppet's internals,         including how primary servers and agents communicate via host-verified HTTPS, and about the         process of catalog  compilation. 

# About Puppet Server

### Sections

[Puppet Server releases](https://www.puppet.com/docs/puppet/7/server/about_server.html#puppet-server-releases)

[Controlling the Service](https://www.puppet.com/docs/puppet/7/server/about_server.html#controlling-the-service)

[Puppet Server's Run Environment](https://www.puppet.com/docs/puppet/7/server/about_server.html#puppet-servers-run-environment)

- [Embedded Web Server](https://www.puppet.com/docs/puppet/7/server/about_server.html#embedded-web-server)
- [Puppet API Service](https://www.puppet.com/docs/puppet/7/server/about_server.html#puppet-api-service)
- [Certificate Authority Service](https://www.puppet.com/docs/puppet/7/server/about_server.html#certificate-authority-service)
- [Admin API Service](https://www.puppet.com/docs/puppet/7/server/about_server.html#admin-api-service)

[JRuby Interpreters](https://www.puppet.com/docs/puppet/7/server/about_server.html#jruby-interpreters)

[Tuning Guide](https://www.puppet.com/docs/puppet/7/server/about_server.html#tuning-guide)

[User](https://www.puppet.com/docs/puppet/7/server/about_server.html#user)

[Ports](https://www.puppet.com/docs/puppet/7/server/about_server.html#ports)

[Logging](https://www.puppet.com/docs/puppet/7/server/about_server.html#logging)

[SSL Termination](https://www.puppet.com/docs/puppet/7/server/about_server.html#ssl-termination)

[Configuring Puppet Server](https://www.puppet.com/docs/puppet/7/server/about_server.html#configuring-puppet-server)

Expand

Puppet is configured in an agent-server architecture, in  which a primary server node manages the configuration information for a  fleet of agent nodes. Puppet Server acts as the primary server node. Puppet Server is a Ruby and Clojure application that runs on the Java  Virtual Machine (JVM). Puppet Server runs Ruby code for compiling Puppet catalogs and for serving files in several JRuby interpreters. It also  provides a certificate authority through Clojure.

This page describes the general requirements and the run environment for Puppet Server.

## Puppet Server releases

Puppet Server and Puppet share the same  major release (Puppet Server 6.x and Puppet 6.x). However, they are  versioned separately and might have different minor or patch versions  (Puppet Server 6.5 versus Puppet 6.8). For a list of the maintained versions of Puppet and Puppet Server, visit [Puppet releases and lifecycles](https://puppet.com/docs/puppet/latest/platform_lifecycle.html).

## Controlling the Service

The Puppet Server service name is `puppetserver`. To start and stop the service, use commands such as `service puppetserver restart`, `service puppetserver status` for your OS.

## Puppet Server's Run Environment

Puppet Server consists of several related services. These services share state and route requests among  themselves. The services run inside a single JVM process, using the  Trapperkeeper service framework.

### Embedded Web Server

Puppet Server uses a Jetty-based web server embedded in the service's JVM process. No additional or unique actions are required to configure and enable the web server. You can modify the web server's settings in [`webserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html). You might need to edit this file if you use an external CA or run Puppet on a non-standard port.

### Puppet API Service

Puppet Server provides APIs that are used by the Puppet agent to manage the configuration of your nodes. Visit [Puppet V3 HTTP API](https://www.puppet.com/docs/puppet/7/server/http_api_index.html#puppet-v3-http-api) for more information on the basic APIs.

### Certificate Authority Service

Puppet Server includes a certificate authority (CA) service that:

- Accepts certificate signing requests (CSRs) from nodes.
- Serves certificates and a certificate revocation list (CRL) to nodes.
- Optionally accepts commands to sign or revoke certificates.

Signing and revoking certificates over the network is disabled by default. You can use the `auth.conf` file to allow specific certificate owners the ability to issue commands.

The CA service uses `.pem` files to stores credentials. You can use the `puppetserver ca` command to interact with these credentials, including listing, signing, and revoking certificates. See [CA V1 HTTP API](https://www.puppet.com/docs/puppet/7/server/http_api_index.html#ca-v1-http-api) for more information on these APIs.

### Admin API Service

Puppet Server includes an administrative API for triggering maintenance tasks. The most common task refreshes Puppet’s environment  cache, which causes all of your Puppet code to reload without the  requirement to restart the service. Consequently, you can deploy new  code to long-timeout environments without executing a full restart of  the service.

For API docs, visit:

- [Environment-cache](https://www.puppet.com/docs/puppet/7/server/admin-api/v1/environment-cache.html).
- [JRuby pool](https://www.puppet.com/docs/puppet/7/server/admin-api/v1/jruby-pool.html).

For details about environment caching, visit:

- [About environments](https://puppet.com/docs/puppet/latest/environments_about.html#environments-limitations).

## JRuby Interpreters

Most of Puppet Server's work is done by Ruby code running  in JRuby. JRuby is an implementation of the Ruby interpreter that runs  on the JVM. Note that you can’t use the system gem command to install  Ruby Gems for the Puppet primary server. Instead, Puppet Server includes a separate puppetserver gem command for installing any libraries your  Puppet extensions might require. Visit [Using Ruby Gems](https://www.puppet.com/docs/puppet/7/server/gems.html) for details.

If you want to test or debug code to be used by the Puppet Server, you can use the `puppetserver ruby` and `puppetserver irb` commands to execute Ruby code in a JRuby environment.

To handle parallel requests from agent nodes, Puppet Server maintains separate JRuby interpreters. These JRuby interpreters  individually run Puppet's application code, and distribute agent  requests among them. You can configure the JRuby interpreters in the `jruby-puppet` section of [puppetserver.conf](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html).

## Tuning Guide

You can maximize Puppet Server's performance by tuning your JRuby configuration. To learn more, visit the Puppet Server [Tuning Guide](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html).

## User

If you are running Puppet Enterprise:

- Puppet Server user runs as `pe-puppet`.
- You must specify the user in `/etc/sysconfig/pe-puppetserver`.

If you are running open source Puppet:

- Puppet Server needs to run as the user `puppet`.
- You must specify the user in `/etc/sysconfig/puppetserver`.

All of the Puppet Server's files and directories must be  readable and writable by this user. Note that Puppet Server ignores the `user` and `group` settings from `puppet.conf`.

## Ports

By default, Puppet's HTTPS traffic uses  port 8140. The OS and firewall must allow Puppet Server's JVM process to accept incoming connections on port 8140. If necessary, you can change the port in `webserver.conf`. See the [Configuration](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html) page for details.

## Logging

All of Puppet Server's logging is routed through the JVM [Logback](http://logback.qos.ch/) library. By default, it logs to `/var/log/puppetlabs/puppetserver/puppetserver.log`. The default log level is 'INFO'. By default, Puppet Server sends nothing to `syslog`. All log messages follow the same path, including HTTP traffic, catalog  compilation, certificate processing, and all other parts of Puppet  Server's work.

Puppet Server also relies on Logback to manage, rotate, and archive Server log files. Logback archives Server logs when they exceed 200MB. Also, when the total size of all Server logs exceeds 1GB,  Logback automatically deletes the oldest logs. Logback is heavily  configurable. If you need something more specialized than a unified log  file, it may be possible to obtain. Visit [Configuring Puppet Server](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging) for more details.

Finally, any errors that cause the logging system to die or occur before logging is set up, display in `journalctl`.

## SSL Termination

By default, Puppet Server handles SSL termination  automatically. For network configurations that require external SSL termination (e.g.  with a hardware load balancer), additional configuration is required. See the [External SSL Termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html) page for details. In summary, you must:

- Configure Puppet Server to use HTTP instead of HTTPS.
- Configure Puppet Server to accept SSL information via insecure HTTP headers.
- Secure your network so that Puppet Server **cannot** be directly reached by **any** untrusted clients.
- Configure your SSL terminating proxy to set the following HTTP headers:
  - `X-Client-Verify` (mandatory).
  - `X-Client-DN` (mandatory for client-verified requests).
  - `X-Client-Cert` (optional; required for [trusted facts](https://puppet.com/docs/puppet/latest/lang_facts_and_builtin_vars.html)).

## Configuring Puppet Server

Puppet Server uses a combination of  Puppet's configuration files along with its own separate configuration  files, which are located in the `conf.d` directory. Refer to the [Config directory](https://puppet.com/docs/puppet/latest/dirs_confdir.html) for a list of Puppet's configuration files. For detailed information about Puppet Server settings and the `conf.d` directory, refer to the [Configuring Puppet Server](https://www.puppet.com/docs/puppet/7/server/configuration.html) page.

# Deprecated features

### Sections

[ `certificate-status` settings](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#certificate-status-settings)

- [Now](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#now)
- [In a Future Major Release](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#in-a-future-major-release)
- [Detecting and Updating](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#detecting-and-updating)
- [Context](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#context)

[ `puppet-admin` Settings](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#puppet-admin-settings)

- [Now](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#now-1)
- [In a Future Major Release](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#in-a-future-major-release-1)
- [Detecting and Updating](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#detecting-and-updating-1)
- [Context](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#context-1)

[Puppet's "resource_types" API endpoint](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#puppets-resource-types-api-endpoint)

- [Now](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#now-2)
- [Previously](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#previously)
- [Detecting and Updating](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#detecting-and-updating-2)
- [Context](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#context-2)

[Puppet's node cache terminus](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#puppets-node-cache-terminus)

- [Now](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#now-3)
- [Previously](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#previously-1)
- [Detecting and Updating](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#detecting-and-updating-3)
- [Context](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#context-3)

[JRuby's "compat-version" setting](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#jrubys-compat-version-setting)

- [Now](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#now-4)
- [Previously](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#previously-2)
- [Detecting and Updating](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#detecting-and-updating-4)
- [Context](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html#context-4)

Expand

The following features and configuration settings are deprecated and will be removed in a future major release of Puppet Server.

## `certificate-status` settings

### Now

If the `certificate-authority.certificate-status.authorization-required` setting is `false`, all requests that are successfully validated by SSL (if applicable for the port settings on the server) are permitted to use the [Certificate Status](https://github.com/puppetlabs/puppet/blob/master/api/docs/http_certificate_status.md) HTTP API endpoints.  This includes requests which do not provide an SSL client certificate.

If the `certificate-authority.certificate-status.authorization-required` setting is `true` or not specified and the `puppet-admin.client-whitelist` setting has one or more entries, only the requests whose Common Name in the SSL client certificate subject matches one of the `client-whitelist` entries are permitted to use the certificate status HTTP API endpoints.

For any other configuration, requests are only permitted to access the certificate status HTTP API endpoints if allowed per the rule definitions in the `trapperkeeper-authorization` "auth.conf" file.  See the [puppetserver "auth.conf"](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html) page for more information.

### In a Future Major Release

The `certificate-status` settings will be ignored completely by Puppet Server. Requests made to the `certificate-status` HTTP API will only be allowed per the `trapperkeeper-authorization` "auth.conf" configuration.

### Detecting and Updating

Look at the `certificate-status` settings in your configuration.  If `authorization-required` is set to `false` or `client-whitelist` has one or more entries, these settings would be used to authorize access to the certificate status HTTP API instead of `trapperkeeper-authorization`.

If `authorization-required` is set to `true` or is not specified and if the `client-whitelist` was empty, you could just remove the `certificate-authority` section from your configuration.  The only behavior that would change in Puppet Server from doing this would be that a warning message would no longer be written to the "puppetserver.log" file at startup.

If `authorization-required` is set to `false`, you would need to create a corresponding rule in the `trapperkeeper-authorization` file which would allow unauthenticated client access to the certificate status API.

For example:

```
authorization: {
    version: 1
    rules: [
            {
                match-request: {
                    path: "/certificate_status/"
                    type: path
                    method: [ get, put, delete ]
                }
                allow-unauthenticated: true
                sort-order: 200
                name: "certificate_status"
            },
            {
                match-request: {
                    path: "/certificate_statuses/"
                    type: path
                    method: get
                }
                allow-unauthenticated: true
                sort-order: 200
                name: "certificate_statuses"
            },
            ...
    ]
}Copied!
```

If `authorization-required` is set to `true` or not set but the `client-whitelist` has one or more custom entries in it, you would need to create a corresponding rule in the `trapperkeeper-authorization` "auth.conf" file which would allow only specific clients access to the certificate status API.

For example, the current certificate status configuration could have:

```
certificate-authority:
    certificate-status: {
        client-whitelist: [ admin1, admin2 ]
    }
}Copied!
```

Corresponding `trapperkeeper-authorization` rules could have:

```
authorization: {
    version: 1
    rules: [
            {
                match-request: {
                    path: "/certificate_status/"
                    type: path
                    method: [ get, put, delete ]
                }
                allow: [ admin1, admin2 ]
                sort-order: 200
                name: "certificate_status"
            },
            {
                match-request: {
                    path: "/certificate_statuses/"
                    type: path
                    method: get
                }
                allow: [ admin1, admin2 ]
                sort-order: 200
                name: "certificate_statuses"
            },
            ...
    ]
}Copied!
```

After adding the desired rules to the `trapperkeeper-authorization` "auth.conf" file, remove the `certificate-authority` section from the "puppetserver.conf" file and restart the puppetserver service.

### Context

In previous Puppet Server releases, there was no unified mechanism for controlling access to the various endpoints that Puppet Server hosts.  Puppet Server used core Puppet "auth.conf" to authorize requests handled via Ruby Puppet and custom client whitelists for the CA and Admin endpoints.  The custom client whitelists do not provide granular enough control to meet some use cases.

`trapperkeeper-authorization` unifies authorization configuration across all of these endpoints into a single file and provides more granular control.

## `puppet-admin` Settings

### Now

If the `puppet-admin.authorization-required` setting is `false`, all requests that are successfully validated by SSL (if applicable for the port settings on the server) are permitted to use the `puppet-admin` HTTP API endpoints. This includes requests which do not provide an SSL client certificate.

If the `puppet-admin.authorization-required` setting is `true` or not specified and the `puppet-admin.client-whitelist` setting has one or more entries, only the requests whose Common Name in the SSL client certificate subject matches one of the `client-whitelist` entries are permitted to use the `puppet-admin` HTTP API endpoints.

For any other configuration, requests are only permitted to access the `puppet-admin` HTTP API endpoints if allowed per the rule definitions in the `trapperkeeper-authorization` "auth.conf" file.  See the [puppetserver "auth.conf"](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html) page for more information.

### In a Future Major Release

The `puppet-admin` settings will be ignored completely by Puppet Server. Requests made to the `puppet-admin` HTTP API will only be allowed per the `trapperkeeper-authorization` "auth.conf" configuration.

### Detecting and Updating

Look at the `puppet-admin` settings in your configuration.  If `authorization-required` is set to `false` or `client-whitelist` has one or more entries, these settings would be used to authorize access to the `puppet-admin` HTTP API instead of `trapperkeeper-authorization`.

If `authorization-required` is set to `true` or is not specified and if the `client-whitelist` was empty, you could just remove the `puppet-admin` section from your configuration and restart your puppetserver service in order for Puppet Server to start using the `trapperkeeper-authorization` "auth.conf" file.  The only behavior that would change in Puppet Server from doing this would be that a warning message would no longer be written to the puppetserver.log file.

If `authorization-required` is set to `false`, you would need to create corresponding rules in the `trapperkeeper-authorization` file which would allow unauthenticated client access to the "puppet-admin" API endpoints.

For example:

```
authorization: {
    version: 1
    rules: [
            {
                match-request: {
                    path: "/puppet-admin-api/v1/environment-cache"
                    type: path
                    method: delete
                }
                allow-unauthenticated: true
                sort-order: 200
                name: "environment-cache"
            },
            {
                match-request: {
                    path: "/puppet-admin-api/v1/jruby-pool"
                    type: path
                    method: delete
                }
                allow-unauthenticated: true
                sort-order: 200
                name: "jruby-pool"
            },
            ...
     ]
}Copied!
```

If `authorization-required` is set to `true` or not set but the `client-whitelist` has one or more custom entries in it, you would need to create corresponding rules in the `trapperkeeper-authorization` "auth.conf" file which would allow only specific clients access to the "puppet-admin" API endpoints.

For example, the current "puppet-admin" configuration could have:

```
puppet-admin: {
    client-whitelist: [ admin1, admin2 ]
}Copied!
```

Corresponding `trapperkeeper-authorization` rules could have:

```
authorization: {
    version: 1
    rules: [
            {
                match-request: {
                    path: "/puppet-admin-api/v1/environment-cache"
                    type: path
                    method: delete
                }
                allow: [ admin1, admin2 ]
                sort-order: 200
                name: "environment-cache"
            },
            {
                match-request: {
                    path: "/puppet-admin-api/v1/jruby-pool"
                    type: path
                    method: delete
                }
                allow: [ admin1, admin2 ]
                sort-order: 200
                name: "jruby-pool"
            },
            ...
     ]
}Copied!
```

After adding the desired rules to the `trapperkeeper-authorization` "auth.conf" file, remove the `puppet-admin` section from the "puppetserver.conf" file and restart the puppetserver service.

### Context

In previous Puppet Server releases, there was no unified mechanism for controlling access to the various endpoints that Puppet Server hosts.  Puppet Server used core Puppet "auth.conf" to authorize requests handled by Ruby Puppet and custom client whitelists for the CA and Admin endpoints.  The custom client allowlists do not provide granular enough control to meet some use cases.

`trapperkeeper-authorization` unifies authorization configuration across all of these endpoints into a single file and provides more granular control.

## Puppet's "resource_types" API endpoint

### Now

The `resource_type` and `resource_types` HTTP APIs were removed in Puppet Server 5.0.

### Previously

The [`resource_type` and `resource_types` Puppet HTTP API endpoints](https://github.com/puppetlabs/docs-archive/blob/main/puppet/4.6/http_api/http_resource_type.md) return information about classes, defined types, and node definitions.

The [`environment_classes` HTTP API in Puppet Server](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html) serves as a replacement for the Puppet resource type API for classes.

### Detecting and Updating

If your application calls the `resource_type` or `resource_types` HTTP API endpoints for information about classes, point those calls to the `environment_classes` endpoint. The `environment_classes` endpoint has different features and returns different values than `resource_type`; see the [changes in the environment classes API](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html) for details.

The `environment_classes`  endpoint ignores Puppet's Ruby-based authorization methods and  configuration in favor of Puppet Server's Trapperkeeper authorization.  For more information, see the ["Authorization" section](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html) of the environment classes API documentation.

### Context

Users often rely on the `resource_types` endpoint for lists of classes and associated parameters in an environment. For such requests, the `resource_types` endpoint is inefficient and can trigger problematic events, such as [manifests being parsed during a catalog request](https://tickets.puppetlabs.com/browse/SERVER-1200).

To fulfill these requests more efficiently and safely, Puppet Server 2.3.0 introduced the narrowly defined `environment_classes` endpoint.

## Puppet's node cache terminus

### Now

Puppet 5.0 (and by extension, Puppet Server 5.0) no longer writes node YAML files to its cache by default.

### Previously

Puppet wrote YAML to its node cache.

### Detecting and Updating

To retain the Puppet 4.x behavior, add the [`puppet.conf`](https://www.puppet.com/docs/puppet/7/server/configuration.html) setting `node_cache_terminus = write_only_yaml`. The `write_only_yaml` option is deprecated.

### Context

This cache was used in workflows where  external tooling needs a list of nodes. PuppetDB is the preferred source of node information.

## JRuby's "compat-version" setting

### Now

Puppet Server 5.0 removes the `jruby-puppet.compat-version` setting in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html), and exits the `puppetserver` service with an error if you start the service with that setting.

### Previously

Puppet Server 2.7.x allowed you to set `compat-version` to `1.9` or `2.0` to choose a preferred Ruby interpreter version.

### Detecting and Updating

Launching the `puppetserver` service with this setting enabled will cause it to exit with an error message. The error includes information on [switching from JRuby 1.7.x to JRuby 9k](https://www.puppet.com/docs/puppet/7/server/configuration.html).

For Ruby language 2.x support in Puppet Server, configure  Puppet Server to use JRuby 9k instead of JRuby 1.7.27. See the  "Configuring the JRuby Version" section of [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html) for details.

### Context

Puppet Server 5.0 updated JRuby v1.7 to v1.7.27, which in turn updated the `jruby-openssl` gem to v0.9.19 and `bouncycastle` libraries to v1.55. JRuby 1.7.27 breaks setting `jruby-puppet.compat-version` to `2.0`.

Server 5.0 also added optional, experimental support for JRuby 9k, which includes Ruby 2.x language support.

# Primary server and agent compatibility

Use this table to verify that you're using a compatible version of the agent for          your PE or Puppet server. 

|       | Server                                                       |                                                              |                                                              |
| ----- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Agent | PE 2017.3 through 2018.1                                   Puppet 5.x | PE 2019.1 through 2019.8                                   Puppet 6.x | PE 2021.0 and later                                        Puppet 7.x |
| 5.x   | ✓                                                            | ✓                                                            |                                                              |
| 6.x   |                                                              | ✓                                                            | ✓                                                            |
| 7.x   |                                                              |                                                              | ✓                                                            |

Note:                     Puppet 5.x has reached end of life and is                    not actively developed or tested. We retain agent 5.x compatibility with                    later versions of the server only to enable upgrades. 

# Configuring Puppet Server

### Sections

[Puppet Server and `puppet.conf` settings](https://www.puppet.com/docs/puppet/7/server/configuration.html#puppet-server-and-puppetconf-settings)

[Configuration Files](https://www.puppet.com/docs/puppet/7/server/configuration.html#configuration-files)

[Logging](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging)

- [HTTP Traffic](https://www.puppet.com/docs/puppet/7/server/configuration.html#http-traffic)
- [Authorization](https://www.puppet.com/docs/puppet/7/server/configuration.html#authorization)

[Service Bootstrapping](https://www.puppet.com/docs/puppet/7/server/configuration.html#service-bootstrapping)

[Adding Java JARs](https://www.puppet.com/docs/puppet/7/server/configuration.html#adding-java-jars)

Puppet Server uses a combination of  Puppet's configuration files along with its own configuration files. You can refer to a complete list of Puppet’s configuration files in the [Config directory](https://puppet.com/docs/puppet/7/dirs_confdir.html).

## Puppet Server and `puppet.conf` settings

Puppet Server uses Puppet's configuration files, including most of the settings in `puppet.conf`. However, Puppet Server treats some `puppet.conf` settings differently. You must be aware of these differences. You can  visit a complete list of these differences at Differing behavior in  puppet.conf. Puppet Server automatically loads the `puppet.conf` settings in the configuration file’s main and server sections. Puppet Server uses the values in the `server` section but if they are not present, it uses the values in the `main` section.

Puppet Server honors the following `puppet.conf` settings:

- allow_duplicate_certs
- autosign
- cacert
- cacrl
- cakey
- ca_name
- capub
- ca_ttl
- certdir
- certname
- cert_inventory
- codedir (PE only)
- csrdir
- csr_attributes
- dns_alt_names
- hostcert
- hostcrl
- hostprivkey
- hostpubkey
- keylength
- localcacert
- manage_internal_file_permissions
- privatekeydir
- requestdir
- serial
- signeddir
- ssl_client_header
- ssl_client_verify_header
- trusted_oid_mapping_file

## Configuration Files

Most of Puppet Server's configuration files and settings (with the exception of the [logging config file](https://puppet.com/docs/puppet/7/server/configuration.html#logging)) are in the `conf.d` directory. The `conf.d` directory is located at `/etc/puppetlabs/puppetserver/conf.d` by default. These configuration files are in the HOCON format, which  retains the basic structure of JSON but is more readable. For more  information, visit the [HOCON documentation](https://github.com/lightbend/config/blob/master/HOCON.md).

At startup, Puppet Server reads all the `.conf` files in the `conf.d` directory. You must restart Puppet Server to implement your changes to these files. The `conf.d` directory contains the following files and settings:

- [`global.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_global.html)
- [`webserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html)
- [`web-routes.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_web-routes.html)
- [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html)
- [`auth.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html)
- [`ca.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_ca.html)

**Note**: The `product.conf` file is optional and is not included by default. You can create `product.conf` in the `conf.d` directory to configure product-related settings (such as automatic update checking and analytics data collection).

## Logging

There is a Logback configuration file that controls how Puppet Server logs. Its default location is at `/etc/puppetlabs/puppetserver/logback.xml`. If you want to place it elsewhere, visit the documentation on [`global.conf`](https://www.puppet.com/puppetserver/latest/config_file_global.html).

For additional information on the `logback.xml` file, visit [Logback.xm](https://puppet.com/docs/puppet/7/server/config_file_logbackxml.html) or [Logback documentation](http://logback.qos.ch/manual/configuration.html). For tips on configuring Logstash or outputting logs in JSON, visit [Advanced logging configuration](https://puppet.com/docs/puppet/7/server/config_logging_advanced.html)

### HTTP Traffic

Puppet Server logs HTTP traffic in a format similar to  Apache and to a separate file that isn’t the main log file. By default,  the access log is located at `/var/log/puppetlabs/puppetserver/puppetserver-access.log`.

The following information is logged for each HTTP request by default:

- remote host
- remote log name
- remote user
- date of the logging event
- URL requested
- status code of the request
- response content length
- remote IP address
- local port
- elapsed time to serve the request, in milliseconds

There is a Logback configuration file that controls Puppet Server’s logging behavior. Its default location is at `/etc/puppetlabs/puppetserver/request-logging.xml`. If you want to place it elsewhere, visit the documentation on [`webserver.conf`](https://www.puppet.com/puppetserver/latest/config_file_webserver.html)

### Authorization

To enable additional logging related to `auth.conf`, edit Puppet Server's `logback.xml` file. By default, only a single message is logged when a request is denied.

To enable a one-time logging of the parsed and transformed `auth.conf` file, add the following to Puppet Server's `logback.xml` file:

```
<logger name="puppetlabs.trapperkeeper.services.authorization.authorization-service" level="DEBUG"/>Copied!
```

To enable rule-by-rule logging for each request as it's checked for authorization, add the following to Puppet Server's `logback.xml` file:

```
<logger name="puppetlabs.trapperkeeper.authorization.rules" level="TRACE"/>Copied!
```

## Service Bootstrapping

Puppet Server is built on top of our open-source Clojure application framework, [Trapperkeeper](https://github.com/puppetlabs/trapperkeeper).

One of the features that Trapperkeeper provides is the  ability to enable or disable individual services that an application  provides. In Puppet Server, you can use this feature to enable or  disable the CA service. The CA service is enabled by default, but if  you're running a multi-server environment or using an external CA, you  might want to disable the CA service on some nodes.

The service bootstrap configuration files are in two locations:

- `/etc/puppetlabs/puppetserver/services.d/`: For services that users are expected to manually configure if necessary, such as CA-related services.
- `/opt/puppetlabs/server/apps/puppetserver/config/services.d/`: For services users shouldn’t need to configure.

Any files with a `.cfg` extension in either of these locations are combined to form the final set of services Puppet Server will use.

The CA-related configuration settings are set in `/etc/puppetlabs/puppetserver/services.d/ca.cfg`. If services added in future versions have user-configurable settings,  the configuration files will also be in this directory. When upgrading  Puppet Server with a package manager, it should not overwrite files  already in this directory.

In the `ca.cfg` file, find and modify these lines as directed to enable or disable the service:

```
# To enable the CA service, leave the following line uncommented
puppetlabs.services.ca.certificate-authority-service/certificate-authority-service
# To disable the CA service, comment out the above line and uncomment the line below
#puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-serviceCopied!
```

## Adding Java JARs

Puppet Server can load any provided Java  Jars upon its initial startup. When launched, Puppet Server  automatically loads any JARs placed in `/opt/puppetlabs/server/data/puppetserver/jars` into the `classpath`. JARs placed here are not modified or removed when upgrading Puppet Server.

# auth.conf

### Sections

[HOCON example](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#hocon-example)

[HOCON parameters](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#hocon-parameters)

- [`version`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#version)
- [`allow-header-cert-info`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-header-cert-info)
- [`rules`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#rules)

Puppet Server's `auth.conf` file contains rules for authorizing access to Puppet Server's HTTP API endpoints. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

The rules are defined in a file named `auth.conf`, and Puppet Server applies the settings when a request's endpoint matches a rule.

> **Note:** You can also use the [`puppetlabs-puppet_authorization`](https://forge.puppet.com/puppetlabs/puppet_authorization) module to manage the new `auth.conf` file's authorization rules in the new HOCON format, and the [`puppetlabs-hocon`](https://forge.puppet.com/puppetlabs/hocon) module to use Puppet to manage HOCON-formatted settings in general.

To configure how Puppet Server authenticates requests, use the supported HOCON `auth.conf` file and authorization methods, and see the parameters and rule definitions in the [HOCON Parameters](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#hocon-parameters) section.

You can find the Puppet Server auth.conf file [here](https://github.com/puppetlabs/puppetserver/blob/master/ezbake/config/conf.d/auth.conf).

## HOCON example

Here is an example authorization section using the HOCON configuration format:

```
authorization: {
    version: 1
    rules: [
        {
            match-request: {
                path: "^/my_path/([^/]+)$"
                type: regex
                method: get
            }
            allow: [ node1, node2, node3, {extensions:{ext_shortname1: value1, ext_shortname2: value2}} ]
            sort-order: 1
            name: "user-specific my_path"
        },
        {
            match-request: {
                path: "/my_other_path"
                type: path
            }
            allow-unauthenticated: true
            sort-order: 2
            name: "my_other_path"
        },
    ]
}Copied!
```

For a more detailed example of how to use the HOCON configuration format, see [Configuring The Authorization Service](https://github.com/puppetlabs/trapperkeeper-authorization/blob/master/doc/authorization-config.md).

For descriptions of each setting, see the following sections.

## HOCON parameters

Use the following parameters when writing or migrating custom authorization rules using the new HOCON format.

### `version`

The `version` parameter is required. In this initial release, the only supported value is `1`.

### `allow-header-cert-info`

> **Note:** Puppet Server ignores the setting of the same name in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html) in favor of this setting in the `auth.conf` file.

This optional `authorization` section parameter determines whether to enable [external SSL termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html) on all HTTP endpoints that Puppet Server handles, including the Puppet  API, the certificate authority API, and the Puppet Admin API. It also  controls how Puppet Server derives the user's identity for authorization purposes. The default value is `false`.

If this setting is `true`, Puppet Server ignores any presented certificate and relies completely on header data to authorize requests.

> **Warning!** This is very insecure; **do not enable this parameter** unless you've secured your network to prevent **any** untrusted access to Puppet Server.

You cannot rename any of the `X-Client` headers when this setting is enabled, and you must specify identity through the `X-Client-Verify`, `X-Client-DN`, and `X-Client-Cert` headers.

For more information, see [External SSL Termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#disable-https-for-puppet-server) in the Puppet Server documentation and [Configuring the Authorization Service](https://github.com/puppetlabs/trapperkeeper-authorization/blob/master/doc/authorization-config.md#allow-header-cert-info) in the `trapperkeeper-authorization` documentation.

### `rules`

The required `rules` array of a Puppet Server's HOCON `auth.conf` file determines how Puppet Server responds to a request. Each element  is a map of settings pertaining to a rule, and when Puppet Server  receives a request, it evaluates that request against each rule looking  for a match.

You define each rule by adding parameters to the rule's [`match-request`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#match-request) section. A `rules` array can contain as many rules as you need, each with a single `match-request` section.

If a request matches a rule in a `match-request` section, Puppet Server determines whether to allow or deny the request using the `rules` parameters that follow the rule's `match-request` section:

- At least one of:
  - [`allow`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-allow-unauthenticated-and-deny)
  - [`allow-unauthenticated`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-allow-unauthenticated-and-deny)
  - [`deny`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-allow-unauthenticated-and-deny)
- [`sort-order`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#sort-order) (required)
- [`name`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#name) (required)

If no rule matches, Puppet Server denies the request by default and returns an HTTP 403/Forbidden response.

#### `match-request`

A `match-request` can take the following parameters, some of which are required:

- **`path` and `type` (required):** A `match-request` rule must have a `path` parameter, which returns a match when a request's endpoint URL starts with or contains the `path` parameter's value. The parameter can be a literal string or regular expression as defined in the required `type` parameter.

  ```
  # Regular expression to match a path in a URL.
  path: "^/puppet/v3/report/([^/]+)$"
  type: regex
  
  # Literal string to match the start of a URL's path.
  path: "/puppet/v3/report/"
  type: pathCopied!
  ```

  > **Note:**  While the HOCON format doesn't require you to wrap all string values  with double quotation marks, some special characters commonly used in  regular expressions --- such as `*` --- break HOCON parsing unless the entire value is enclosed in double quotes.

- **`method`:** If a rule contains the optional `method` parameter, Puppet Server applies that rule only to requests that use  its value's listed HTTP methods. This parameter's valid values are `get`, `post`, `put`, `delete`, and `head`, provided either as a single value or array of values.

  ```
  # Use GET and POST.
  method: [get, post]
  
  # Use PUT.
  method: putCopied!
  ```

  > **Note:** While the new HOCON format does not provide a direct equivalent to the [deprecated](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html) `method` parameter's `search` indirector, you can create the equivalent rule by passing GET and POST to `method` and specifying endpoint paths using the `path` parameter.

- **`query-params`:** Use the optional query-params setting to provide the list of query  parameters. Each entry is a hash of the param name followed by a list of its values.

For example, this rule would match a request URL containing the `environment=production` or `environment=test` query parameters:

```
``` hocon
query-params: {
    environment: [ production, test ]
}
```Copied!
```

#### `allow`, `allow-unauthenticated`, and `deny`

After each rule's `match-request` section, it must also have an `allow`, `allow-unauthenticated`, or `deny` parameter. (You can set both `allow` and `deny` parameters for a rule, though Puppet Server always prioritizes `deny` over `allow` when a request matches both.)

If a request matches the rule, Puppet Server checks the request's authenticated "name" (see [`allow-header-cert-info`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-header-cert-info)) against these parameters to determine what to do with the request.

- **`allow-unauthenticated`**: If this Boolean parameter is set to `true`, Puppet Server allows the request --- even if it can't determine an authenticated name. **This is a potentially insecure configuration** --- be careful when enabling it. A rule with this parameter set to `true` can't also contain the `allow` or `deny` parameters.

- **`allow`**: This parameter can take a single string value, an array of string values, a single map value with either an `extensions` or `certname` key, or an array of string and map values.

  The string values can contain:

  - An exact domain name, such as `www.example.com`.
  - A glob of names containing a `*` in the first segment, such as `*.example.com` or simply `*`.
  - A regular expression surrounded by `/` characters, such as `/example/`.
  - A backreference to a regular expression's capture group in the `path` value, if the rule also contains a `type` value of `regex`. For example, if the path for the rule were `"^/example/([^/]+)$"`, you can make a backreference to the first capture group using a value like `$1.domain.org`.

  The map values can contain:

  - An `extensions` key that specifies an array of matching X.509 extensions. Puppet Server authenticates the request only if each key in the map appears in the  request, and each key's value exactly matches.
  - A `certname` key equivalent to a bare string.

  If the request's authenticated name matches the parameter's value, Puppet Server allows it.

> **Note:**  If you are using Puppet Server with the CA disabled, you must use OID  values for the extensions. Puppet Server will not be able to resolve [short names](https://puppet.com/docs/puppet/6.17/ssl_attributes_extensions.html#puppet_registered_ids) in this mode.

- **`deny`**: This parameter can take the same types of values as the `allow` parameter, but refuses the request if the authenticated name matches --- even if the rule contains an `allow` value that also matches.

> Also, in the HOCON Puppet Server authentication method, there is no directly equivalent behavior to the [deprecated](https://www.puppet.com/docs/puppet/7/server/deprecated_features.html) `auth` parameter's `on` value.

#### `sort-order`

After each rule's `match-request` section, the required `sort-order` parameter sets the order in which Puppet Server evaluates the rule by  prioritizing it on a numeric value between 1 and 399 (to be evaluated  before default Puppet rules) or 601 to 998 (to be evaluated after  Puppet), with lower-numbered values evaluated first. Puppet Server  secondarily sorts rules lexicographically by the `name` string value's Unicode code points.

```
sort-order: 1Copied!
```

#### `name`

After each rule's `match-request` section, this required parameter's unique string value identifies the rule to Puppet Server. The `name` value is also written to server logs and error responses returned to unauthorized clients.

```
name: "my path"Copied!
```

> **Note:** If multiple rules have the same `name` value, Puppet Server will fail to launch.

# ca.conf

### Sections

[Signing settings](https://www.puppet.com/docs/puppet/7/server/config_file_ca.html#signing-settings)

[Infrastructure CRL settings](https://www.puppet.com/docs/puppet/7/server/config_file_ca.html#infrastructure-crl-settings)

The `ca.conf` file configures settings for the Puppet Server Certificate Authority (CA) service. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

## Signing settings

The `allow-subject-alt-names` setting in the `certificate-authority` section enables you to sign certificates with subject alternative  names. It is false by default for security reasons but can be enabled if you need to sign certificates with subject alternative names. Be aware  that enabling the setting could allow agent nodes to impersonate other  nodes (including the nodes that already have signed certificates).  Consequently, you must carefully inspect any CSRs with SANs attached. `puppet cert sign` previously allowed this via a flag, but `puppetserver ca sign` requires it to be configured in the config file.

The `allow-authorization-extensions` setting in the `certificate-authority` section also enables you to sign certs with authorization extensions.  It is false by default for security reasons, but can be enabled if you  know you need to sign certificates this way. `puppet cert sign` used to allow this via a flag, but `puppetserver ca sign` requires it to be configued in the config file.

## Infrastructure CRL settings

Puppet Server is able to create a  separate CRL file containing only revocations of Puppet infrastructure  nodes. This behavior is turned off by default. To enable it, set `certificate-authority.enable-infra-crl` to `true`.

# global.conf

### Sections

[Example](https://www.puppet.com/docs/puppet/7/server/config_file_global.html#example)

The `global.conf` file contains global configuration settings for Puppet Server. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

You shouldn't typically need to make changes to this file. However, you can change the `logging-config` path for the logback logging configuration file if necessary. For more information about the logback file, see http://logback.qos.ch/manual/configuration.html.

## Example

```
global: {
    logging-config: /etc/puppetlabs/puppetserver/logback.xml
}
```

# logback.xml

### Sections

[Puppet Server logging](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#puppet-server-logging)

- [Settings](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#settings)

[HTTP request logging](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#http-request-logging)

Puppet Server’s logging is routed through the Java Virtual Machine's [Logback library](http://logback.qos.ch/) and configured in an XML file typically named `logback.xml`.

> **Note:** This document covers  basic, commonly modified options for Puppet Server logs. Logback is a  powerful library with many options. For detailed information on  configuring Logback, see the [Logback Configuration Manual](http://logback.qos.ch/manual/configuration.html).
>
> For advanced logging configuration tips specific to Puppet  Server, such as configuring Logstash or outputting logs in JSON format,  see [Advanced Logging Configuration](https://www.puppet.com/docs/puppet/7/server/config_logging_advanced.html).

## Puppet Server logging

By default, Puppet Server logs messages and errors to `/var/log/puppetlabs/puppetserver/puppetserver.log`. The default log level is ‘INFO’, and Puppet Server sends nothing to `syslog`. You can change Puppet Server's logging behavior by editing `/etc/puppetlabs/puppetserver/logback.xml`, and you can specify a different Logback config file in [`global.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#globalconf).

You can restart the `puppetserver` service for changes to take effect, or enable [configuration scanning](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#scan-and-scanperiod) to allow changes to be recognized at runtime.

Puppet Server also relies on Logback to manage, rotate, and archive Server log files. Logback archives Server logs when they exceed 10MB, and when the total size of all Server logs exceeds 1GB, it  automatically deletes the oldest logs.

### Settings

#### `level`

To modify Puppet Server's logging level, change the `level` attribute of the `root` element. By default, the logging level is set to `info`:

```
<root level="info">Copied!
```

Supported logging levels, in order from most to least information logged, are `trace`, `debug`, `info`, `warn`, and `error`. For instance, to enable debug logging for Puppet Server, change `info` to `debug`:

```
<root level="debug">Copied!
```

Puppet Server profiling data is included at the `debug` logging level.

You can also change the logging level for JRuby logging from its defaults of `error` and `info` by setting the `level` attribute of the `jruby` element. For example, to enable debug logging for JRuby, set the attribute to `debug`:

```
<jruby level="debug">Copied!
```

#### Logging location

You can change the file to which Puppet Server writes its logs in the `appender` section named `F1`. By default, the location is set to `/var/log/puppetlabs/puppetserver/puppetserver.log`:

```
...
    <appender name="F1" class="ch.qos.logback.core.FileAppender">
        <file>/var/log/puppetlabs/puppetserver/puppetserver.log</file>
...Copied!
```

To change this to `/var/log/puppetserver.log`, modify the contents of the `file` element:

```
        <file>/var/log/puppetserver.log</file>Copied!
```

The user account that owns the Puppet Server process must have write permissions to the destination path.

#### `scan` and `scanPeriod`

Logback supports noticing and reloading configuration changes without requiring a restart, a feature Logback calls **scanning**. To enable this, set the `scan` and `scanPeriod` attributes in the `<configuration>` element of `logback.xml`:

```
<configuration scan="true" scanPeriod="60 seconds">Copied!
```

Due to a [bug in Logback](https://tickets.puppetlabs.com/browse/TK-426), the `scanPeriod` must be set to a value; setting only `scan="true"` will not enable configuration scanning. Scanning is enabled by default in the `logback.xml` configuration packaged with Puppet Server.

**Note:** The HTTP request log does not currently support the scan feature. Adding the `scan` or `scanPeriod` settings to `request-logging.xml` will have no effect.

## HTTP request logging

Puppet Server logs HTTP traffic separately, and this logging is configured in a different Logback configuration file located at `/etc/puppetlabs/puppetserver/request-logging.xml`. To specify a different Logback configuration file, change the `access-log-config` setting in Puppet Server's [`webserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html) file.

The HTTP request log uses the same Logback configuration  format and settings as the Puppet Server log. It also lets you configure what it logs using patterns, which follow Logback's [`PatternLayout` format](http://logback.qos.ch/manual/layouts.html#AccessPatternLayout).

# metrics.conf

### Sections

[Settings](https://www.puppet.com/docs/puppet/7/server/config_file_metrics.html#settings)

[Example](https://www.puppet.com/docs/puppet/7/server/config_file_metrics.html#example)

The `metrics.conf` file configures Puppet Server's [metrics services](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html) and [v2 metrics API](https://www.puppet.com/docs/puppet/7/server/metrics-api/v2/metrics_api.html).

## Settings

All settings in the file are contained in a HOCON `metrics` section.

- `server-id`: A unique identifier to be used as part of the namespace for metrics that this server produces.
- `registries`: A section that contains settings to control which metrics are reported, and how they're reported.
  - `<REGISTRY NAME>`: A section named for a registry that contains its settings. In Puppet Server's case, this section should be `puppetserver`.
    - `metrics-allowed`: An array of metrics to report. See the [metrics documentation](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html) for details about individual metrics.
    - `reporters`: Can contain `jmx` and `graphite` sections with a single Boolean `enabled` setting to enable or disable each reporter type.
- `reporters`: Configures reporters that distribute metrics to external services or viewers.
  - `graphite`: Contains settings for the Graphite reporter.
    - `host`: A string containing the Graphite server's hostname or IP address.
    - `port`: Contains the Graphite service's port number.
    - `update-interval-seconds`: Sets the interval on which Puppet Server will send metrics to the Graphite server.

## Example

Puppet Server ships with a default `metrics.conf` file in Puppet Server's `conf.d` directory, similar to the below example with additional comments.

```
metrics: {
    server-id: localhost
    registries: {
        puppetserver: {
            # specify metrics to allow in addition to those in the default list
            #metrics-allowed: ["compiler.compile.production"]

            reporters: {
                jmx: {
                    enabled: true
                }
                # enable or disable Graphite metrics reporter
                #graphite: {
                #    enabled: true
                #}
            }

        }
    }

    reporters: {
        #graphite: {
        #    # graphite host
        #    host: "127.0.0.1"
        #    # graphite metrics port
        #    port: 2003
        #    # how often to send metrics to graphite
        #    update-interval-seconds: 5
        #}
    }
}
```

# product.conf

### Sections

[Settings](https://www.puppet.com/docs/puppet/7/server/config_file_product.html#settings)

- [Example](https://www.puppet.com/docs/puppet/7/server/config_file_product.html#example)

The `product.conf` file contains settings that determine how Puppet Server interacts with  Puppet, Inc., such as automatic update checking and analytics data  collection.

## Settings

The `product.conf` file doesn't exist in a default Puppet Server installation; to configure its settings, you must create it in Puppet Server's `conf.d` directory (located by default at `/etc/puppetlabs/puppetserver/conf.d`). This file is a [HOCON-formatted](https://github.com/typesafehub/config/blob/master/HOCON.md) configuration file with the following settings:

- Settings in the `product` section configure update checking and analytics data collection:

  - `check-for-updates`: If set to `false`, Puppet Server will not automatically check for updates, and will not send analytics data to Puppet.

    If this setting is unspecified (default) or set to `true`, Puppet Server checks for updates upon start or restart, and every 24  hours thereafter, by sending the following data to Puppet:

    - Product name
    - Puppet Server version
    - IP address
    - Data collection timestamp

    Puppet requests this data as one of the many ways we learn  about and work with our community. The more we know about how you use  Puppet, the better we can address your needs. No personally identifiable information is collected, and the data we collect is never used or  shared outside of Puppet.

### Example

```
# Disabling automatic update checks and corresponding analytic data collection

product: {
    check-for-updates: false
}
```

# puppetserver.conf

### Sections

[Settings](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html#settings)

- [Examples](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html#examples)

The `puppetserver.conf` file contains settings for the Puppet Server application. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

## Settings

> **Note:** Under most conditions, you won't change the default settings for `server-conf-dir` or `server-code-dir`. However, if you do, also change the equivalent Puppet settings (`confdir` or `codedir`) to ensure that commands like `puppetserver ca` and `puppet module` use the same directories as Puppet Server. You must also specify the non-default `confdir` when running commands, because that setting must be set before Puppet tries to find its config file.

- The `jruby-puppet` settings configure the interpreter.

  > **Deprecation Note:** Puppet Server 5.0 removed the `compat-version` setting, which is incompatible with JRuby 1.7.27, and the service won't start if `compat-version` is set. Puppet Server 6.0 uses JRuby 9.1 which supports Ruby 2.3.

  - `ruby-load-path`: The location where Puppet Server expects to find Puppet, Facter, and other components.

  - `gem-home`: The location where JRuby looks for gems. It is also used by the `puppetserver gem` command line tool. If nothing is specified, JRuby uses the Puppet default `/opt/puppetlabs/server/data/puppetserver/jruby-gems`.

  - `gem-path`: The complete "GEM_PATH" for jruby.  If set, it should include the `gem-home` directory, as well as any other directories that gems can be loaded  from (including the vendored gems directory for gems that ship with  puppetserver).  The default value is  `["/opt/puppetlabs/server/data/puppetserver/jruby-gems", "/opt/puppetlabs/server/data/puppetserver/vendored-jruby-gems",  "/opt/puppetlabs/puppet/lib/ruby/vendor_gems"]`.

  - `environment-vars:` Optional. A map of environment variables which are made visible to Ruby code running within JRuby, for example, via the Ruby `ENV` class.

    By default, the only environment variables whose values are set into JRuby from the shell are `HOME` and `PATH`.

    The default value for the `GEM_HOME` environment variable in JRuby is set from the value provided for the `jruby-puppet.gem-home` key.

    Any variable set from the map for the `environment-vars` key overrides these defaults. Avoid overriding `HOME`, `PATH`, or `GEM_HOME` here because these values are already configurable via the shell or `jruby-puppet.gem-home`.

  - `server-conf-dir`: Optional. The path to the Puppet [configuration directory](https://puppet.com/docs/puppet/latest/dirs_confdir.html). The default is `/etc/puppetlabs/puppet`.

  - `server-code-dir`: Optional. The path to the Puppet [code directory](https://puppet.com/docs/puppet/latest/dirs_codedir.html). The default is `/etc/puppetlabs/code`.

  - `server-var-dir`: Optional. The path to the Puppet [cache directory](https://puppet.com/docs/puppet/latest/dirs_vardir.html). The default is `/opt/puppetlabs/server/data/puppetserver`.

  - `server-run-dir`: Optional. The path to the run directory, where the service's PID file is stored. The default is `/var/run/puppetlabs/puppetserver`.

  - `server-log-dir`: Optional. The path to the log directory. If nothing is specified, it uses the Puppet default `/var/log/puppetlabs/puppetserver`.

  - `max-active-instances`: Optional. The maximum number of JRuby instances allowed. The default is 'num-cpus - 1', with a minimum value of 1 and a maximum value of 4. In  multithreaded mode, this controls the number of threads allowed to run  concurrently through the single JRuby instance.

  - `max-requests-per-instance`:  Optional. The number of HTTP requests a given JRuby instance will handle in its lifetime. When a JRuby instance reaches this limit, it is  flushed from memory and replaced with a fresh one. The default is 0,  which disables automatic JRuby flushing.

    JRuby flushing can be useful for working around buggy  module code that would otherwise cause memory leaks, but it slightly  reduces performance whenever a new JRuby instance reloads all of the  Puppet Ruby code. If memory leaks from module code are not an issue in  your deployment, the default value of 0 performs best.

  - `multithreaded`: Optional, false by default. Configures Puppet Server to use a single  JRuby instance to process requests that require a JRuby, processing a  number of threads up to `max-active-instances` at a time. Reduces the memory footprint of the server by only requiring a single JRuby.

  > **Note:**  Multithreaded mode is an experimental feature which might experience  breaking changes in future releases. Test the feature in a  non-production environment before enabling it in production.

  - `max-queued-requests`: Optional. The maximum number of requests that may be queued waiting to  borrow a JRuby from the pool. When this limit is exceeded, a 503  "Service Unavailable" response will be returned for all new requests  until the queue drops below the limit. If `max-retry-delay` is set to a positive value, then the 503 responses will include a `Retry-After` header indicating a random sleep time after which the client may retry  the request. The default is 0, which disables the queue limit.

  - `max-retry-delay`: Optional. Sets the upper limit for the random sleep set as a `Retry-After` header on 503 responses returned when `max-queued-requests` is enabled. A value of 0 will cause the `Retry-After` header to be omitted. Default is 1800 seconds which corresponds to the default run interval of the Puppet daemon.

  - `borrow-timeout`: Optional. The timeout in milliseconds, when attempting to borrow an instance from the JRuby pool. The default is 1200000.

  - `environment-class-cache-enabled`: Optional. Used to control whether the master service maintains a cache in conjunction with the use of the [`environment_classes` API](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html).

    If this setting is set to `true`, Puppet Server maintains the cache. It also returns an Etag header for  each GET request to the API. For subsequent GET requests that use the  prior Etag value in an If-None-Match header, when the class information  available for an environment has not changed, Puppet Server returns an  HTTP 304 (Not Modified) response with no body.

    If this setting is set to `false` or is not specified, Puppet Server doesn't maintain a cache, an Etag  header is not returned for GET requests, and the If-None-Match header  for an incoming request is ignored. It therefore parses the latest  available code for an environment from disk on every incoming request.

    For more information, see the [`environment_classes` API documentation](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html).

  - `compile-mode`: The default value depends on JRuby versions, for 1.7 it is `off`, for 9k it is `jit`. Used to control JRuby's "CompileMode", which may improve performance. A value of `jit` enables JRuby's "just-in-time" compilation of Ruby code. A value of `force` causes JRuby to attempt to pre-compile all Ruby code.

  - `profiling-mode`: Optional. Used to enable JRuby's profiler for service startup and set it to one of the supported modes. The default value is `off`, but it can be set to one of `api`, `flat`, `graph`, `html`, `json`, `off`, and `service`. See [ruby-prof](https://github.com/ruby-prof/ruby-prof/blob/master/README.rdoc#reports) for details on what the various modes do.

  - `profiler-output-file`: Optional. Used to set the output file to direct JRuby profiler output.  Should be a fully qualified path writable by the service user. If not  set will default to a random name inside the service working directory.

- The `profiler` settings configure profiling:

  - `enabled`: If this is set to `true`, Puppet Server enables profiling for the Puppet Ruby code. The default is `true`.

- The `versioned-code` settings configure commands required to use [static catalogs](https://puppet.com/docs/puppet/latest/static_catalogs.html):

  - `code-id-command`: the path to an executable script that Puppet Server invokes to generate a `code_id`. When compiling a static catalog, Puppet Server uses the output of this script as the catalog's `code_id`. The `code_id` associates the catalog with the compile-time version of any [file resources](https://www.puppet.com/docs/puppet/7/type.html#file) that has a `source` attribute with a `puppet:///` URI value.
  - `code-content-command` contains the path to an executable script that Puppet Server invokes when an agent makes a [`static_file_content`](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/static_file_content.html) API request for the contents of a [file resource](https://www.puppet.com/docs/puppet/7/type.html#file) that has a `source` attribute with a `puppet:///` URI value.

- The `dropsonde` settings configure whether and how often Puppet Server submits usage telemetry:

  - `enabled`: If this is set to `true`, Puppet Server submits public content usage data to Puppet development. Defaults to `false`.
  - `interval`: how long, in seconds, Puppet Server waits between telemetry submissions if enabled. Defaults to `604800` (one week).

> **Note:** The Puppet Server process must be able to execute the `code-id-command` and `code-content-command` scripts, and the scripts must return valid content to standard output and an error code of 0. For more information, see the [static catalogs](https://puppet.com/docs/puppet/latest/static_catalogs.html) and [`static_file_content` API](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/static_file_content.html) documentation.
>
> If you're using static catalogs, you **must** set and use **both** `code-id-command` and `code-content-command`. If only one of those settings are specified, Puppet Server fails to  start. If neither setting is specified, Puppet Server defaults to  generating catalogs without static features even when an agent requests a static catalog, which the agent will process as a normal catalog.

### Examples

```
# Configuration for the JRuby interpreters.

jruby-puppet: {
    ruby-load-path: [/opt/puppetlabs/puppet/lib/ruby/vendor_ruby]
    gem-home: /opt/puppetlabs/server/data/puppetserver/jruby-gems
    gem-path: [/opt/puppetlabs/server/data/puppetserver/jruby-gems, /opt/puppetlabs/server/data/puppetserver/vendored-jruby-gems]
    environment-vars: { "FOO" : ${FOO}
                        "LANG" : "de_DE.UTF-8" }
    server-conf-dir: /etc/puppetlabs/puppet
    server-code-dir: /etc/puppetlabs/code
    server-var-dir: /opt/puppetlabs/server/data/puppetserver
    server-run-dir: /var/run/puppetlabs/puppetserver
    server-log-dir: /var/log/puppetlabs/puppetserver
    max-active-instances: 1
    max-requests-per-instance: 0
}

# Settings related to HTTP client requests made by Puppet Server.
# These settings only apply to client connections using the Puppet::Network::HttpPool
# classes. Client connections using net/http or net/https directly will not be
# configured with these settings automatically.
http-client: {
    # A list of acceptable protocols for making HTTP requests
    #ssl-protocols: [TLSv1, TLSv1.1, TLSv1.2]

    # A list of acceptable cipher suites for making HTTP requests. For more info on available cipher suites, see:
    # http://docs.oracle.com/javase/7/docs/technotes/guides/security/SunProviders.html#SunJSSEProvider
    #cipher-suites: [TLS_RSA_WITH_AES_256_CBC_SHA256,
    #                TLS_RSA_WITH_AES_256_CBC_SHA,
    #                TLS_RSA_WITH_AES_128_CBC_SHA256,
    #                TLS_RSA_WITH_AES_128_CBC_SHA]

    # The amount of time, in milliseconds, that an outbound HTTP connection
    # will wait for data to be available before closing the socket. If not
    # defined, defaults to 20 minutes. If 0, the timeout is infinite and if
    # negative, the value is undefined by the application and governed by the
    # system default behavior.
    #idle-timeout-milliseconds: 1200000

    # The amount of time, in milliseconds, that an outbound HTTP connection will
    # wait to connect before giving up. Defaults to 2 minutes if not set. If 0,
    # the timeout is infinite and if negative, the value is undefined in the
    # application and governed by the system default behavior.
    #connect-timeout-milliseconds: 120000

    # Whether to enable http-client metrics; defaults to 'true'.
    #metrics-enabled: true
}

# Settings related to profiling the puppet Ruby code.
profiler: {
    enabled: true
}

# Settings related to static catalogs. These paths are examples. There are no default
# scripts provided with Puppet Server, and no default path for the scripts. To use static catalog features, you must set
# the paths and provide your own scripts.
versioned-code: {
    code-id-command: /opt/puppetlabs/server/apps/puppetserver/code-id-command_script.sh
    code-content-command: /opt/puppetlabs/server/apps/puppetserver/code-content-command_script.sh
}
```

# web-routes.conf

### Sections

[Example](https://www.puppet.com/docs/puppet/7/server/config_file_web-routes.html#example)

The `web-routes.conf` file configures the Puppet Server `web-router-service`, which sets mount points for Puppet Server's web applications. You  should not modify these mount points, because Puppet agents rely on  Puppet Server mounting them to specific URLs.

For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html). To configure the `webserver` service, see the [`webserver.conf` documentation](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html).

## Example

Here is an example of a `web-routes.conf` file:

```
# Configure the mount points for the web apps.
web-router-service: {
    # These two should not be modified because the Puppet 4 agent expects them to
    # be mounted at these specific paths.
    "puppetlabs.services.ca.certificate-authority-service/certificate-authority-service": "/puppet-ca"
    "puppetlabs.services.master.master-service/master-service": "/puppet"

    # This controls the mount point for the Puppet administration API.
    "puppetlabs.services.puppet-admin.puppet-admin-service/puppet-admin-service": "/puppet-admin-api"

    # This controls the mount point for the status API
    "puppetlabs.trapperkeeper.services.status.status-service/status-service": "/status"

    # This controls the mount point for the metrics API
    "puppetlabs.trapperkeeper.services.metrics.metrics-service/metrics-webservice": "/metrics"
}
```

# webserver.conf

### Sections

[Examples](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html#examples)

The `webserver.conf` file configures the Puppet Server `webserver` service. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html). To configure the mount points for the Puppet administrative API web applications, see the [`web-routes.conf` documentation](https://www.puppet.com/docs/puppet/7/server/config_file_web-routes.html).

## Examples

The `webserver.conf` file looks something like this:

```
# Configure the webserver.
webserver: {
    # Log webserver access to a specific file.
    access-log-config: /etc/puppetlabs/puppetserver/request-logging.xml
    # Require a valid certificate from the client.
    client-auth: need
    # Listen for HTTPS traffic on all available hostnames.
    ssl-host: 0.0.0.0
    # Listen for HTTPS traffic on port 8140.
    ssl-port: 8140
}Copied!
```

These are the main values for managing a Puppet Server  installation. For further documentation, including a complete list of  available settings and values, see [Configuring the Webserver Service](https://github.com/puppetlabs/trapperkeeper-webserver-jetty9/blob/master/doc/jetty-config.md).

By default, Puppet Server is configured to use the correct  Puppet primary server and certificate authority (CA) certificates. If  you're using an external CA and providing your own certificates and  keys, make sure the SSL-related parameters in `webserver.conf` point to the correct file.

```
webserver: {
    ...
    ssl-cert    : /path/to/server.pem
    ssl-key     : /path/to/server.key
    ssl-ca-cert : /path/to/ca_bundle.pem
    ssl-cert-chain : /path/to/ca_bundle.pem
    ssl-crl-path : /etc/puppetlabs/puppet/ssl/crl.pem
}
```

# Migrating to the HOCON auth.conf format

### Sections

[Managing rules with Puppet modules](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#managing-rules-with-puppet-modules)

[Converting rules directly](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#converting-rules-directly)

- [Unavailable rules, settings, or values](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#unavailable-rules-settings-or-values)
- [Basic HOCON structure](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#basic-hocon-structure)
- [Converting a simple rule](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#converting-a-simple-rule)
- [Converting more complex rules](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#converting-more-complex-rules)

Puppet Server 2.2.0 introduced a significant change in how it manages authentication to API endpoints. The older [Puppet `auth.conf`](https://puppet.com/docs/puppet/latest/config_file_auth.md) file and whitelist-based authorization method were deprecated in the  same release and are now removed in Puppet Server 7. Puppet Server's  current `auth.conf` file format (which is different than the old auth.conf) is illustrated below in examples.

Use the following examples and methods to convert your  authorization rules when upgrading to Puppet Server 2.2.0 and newer. For detailed information about using `auth.conf` rules with Puppet Server, see the [Puppet Server `auth.conf` documentation](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html).

> **Note:** To support both Puppet 3 and Puppet 4 agents connecting to Puppet Server, see [Backward Compatibility with Puppet 3 Agents](https://www.puppet.com/docs/puppet/7/server/compatibility_with_puppet_agent.html).

## Managing rules with Puppet modules

You can reimplement and manage your authorization rules in the new HOCON format and `auth.conf` file by using the [`puppetlabs-puppet_authorization`](https://forge.puppet.com/puppetlabs/puppet_authorization) Puppet module. See the module's documentation for details.

## Converting rules directly

Most of the deprecated authorization rules and settings are available in the new format.

### Unavailable rules, settings, or values

The following rules, settings, and values have no direct  equivalent in the new HOCON format. If you require them, you must  reimplement them differently in the new format.

- **on value of `auth`:** The deprecated `auth` parameter's on value results in a match only when a request provides a  client certificate. There is no equivalent behavior in the HOCON format.
- **`allow_ip` or `deny_ip` parameters**
- **`method` parameter's search indirector:** While there is no direct equivalent to the deprecated search indirector, you can create an equivalent HOCON rule. See [below](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#search-indirector-for-method) for an example.

> **Note:**  Puppet Server considers the state of a request's authentication  differently depending on whether the authorization rules use the older  Puppet `auth.conf` or newer HOCON formats. An authorization rule that uses the deprecated format evaluates the `auth` parameter as part of rule-matching process. A HOCON authorization rule  first determines whether the request matches other parameters of the  rule, and then considers the request's authentication state (using the  rule's `allow`, `deny`, or `allow-authenticated` values) after a successful match only.

### Basic HOCON structure

The HOCON `auth.conf` file has some fundamental structural requirements:

- An [`authorization`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#authorization) section, which contains:
  - A [`version`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#version) setting.
  - A [`rules`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#rules) array of map values, each representing an authorization rule. Each rule must contain:
    - A [`match-request`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#match-request) section.
      - Each `match-request` section must contain at least one [`path`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#path) and [`type`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#type).
    - A numeric [`sort-order`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#sort-order) value.
      - If the value is between 1 and 399, the rule supersedes Puppet Server's default authorization rules.
      - If the value is between 601 and 998, the rule can be overridden by Puppet Server's default authorization rules.
    - A string [`name`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#name) value.
    - At least one of the following:
      - An [`allow` value, a `deny` value, or both](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-allow-unauthenticated-and-deny). The `allow` or `deny` values can contain:
        - A single string, representing the request's  "name" derived from the Common Name (CN) attribute within an X.509  certificate's Subject Distinguished Name (DN). This string can be an  exact name, a glob, or a regular expression.
        - A single map value containing an `extension` key.
        - A single map value containing a `certname` key.
        - An array of values, including string and map values.
      - An [`allow-unauthenticated`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#allow-allow-unauthenticated-and-deny) value, but if present, there cannot also be an `allow` value.

For an full example of a HOCON `auth.conf` file, see the [HOCON `auth.conf` documentation](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#hocon-example).

### Converting a simple rule

Let's convert this simple deprecated `auth.conf` authorization rule:

```
path /puppet/v3/environments
method find
allow *Copied!
```

We'll start with a skeletal, incomplete HOCON `auth.conf` file:

```
authorization: {
    version: 1
    rules: [
        {
            match-request: {
                path:
                type:
            }
            allow:
            sort-order: 1
            name:
        },
    ]
}Copied!
```

Next, let's convert each component of the deprecated rule to the new HOCON format.

1. Add the path to the new rule's [`path`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#match-request) setting in its `match-request` section.

   ```
   ...
           match-request: {
               path: /puppet/v3/environments
               type:
           }
           allow:
           sort-order: 1
           name:
       },
   ...Copied!
   ```

2. Next, add its type to the section's [`type`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#match-request) setting. Because this is a literal string path, the type is `path`.

   ```
   ...
           match-request: {
               path: /puppet/v3/environments
               type: path
           }
           allow:
           sort-order: 1
           name:
       },
   ...Copied!
   ```

3. The legacy rule has a [`method`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#method-1) setting, with an indirector value of `find` that's equivalent to the GET and POST HTTP methods. We can implement these by adding an optional HOCON [`method`](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#match-request) setting in the rule's `match-request` section and specifying GET and POST as an array.

   ```
   ...
           match-request: {
               path: /puppet/v3/environments
               type: path
               method: [get, post]
           }
           allow:
           sort-order: 1
           name:
       },
   ...Copied!
   ```

4. Next, set the [`allow`](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#allow-allow-unauthenticated-and-deny) setting. The legacy rule used a `*` glob, which is also supported in HOCON.

   ```
   ...
           match-request: {
               path: /puppet/v3/environments
               type: path
               method: [get, post]
           }
           allow: "*"
           sort-order: 1
           name:
       },
   ...Copied!
   ```

5. Finally, give the rule a unique [`name`](https://www.puppet.com/docs/puppet/7/server/config_file_auth_migration.html#name) value. Remember that the rule will appear in logs and in the body of error responses to unauthorized clients.

   ```
   ...
           match-request: {
               path: /puppet/v3/environments
               type: path
               method: [get, post]
           }
           allow: "*"
           sort-order: 1
           name: "environments"
       },
   ...Copied!
   ```

Our HOCON `auth.conf` file should now allow all authenticated clients to make GET and POST requests to the `/puppet/v3/environments` endpoint, and should look like this:

```
authorization: {
    version: 1
    rules: [
        {
            match-request: {
                path: /puppet/v3/environments
                type: path
                method: [get, post]
            }
            allow: "*"
            sort-order: 1
            name: "environments"
        },
    ]
}Copied!
```

### Converting more complex rules

#### Paths set by regular expressions

To convert a regular expression path, enclose it in double quotation marks and slash characters (`/`), and set the `type` to regex.

> **Note:**  You must escape regular expressions to conform to HOCON standards, which are the same as JSON's and differ from the deprecated format's regular  expressions. For instance, the digit-matching regular expression `\d` must be escaped with a second backslash, as `\d`.

Deprecated:

```
path ~ ^/puppet/v3/catalog/([^/]+)$Copied!
```

HOCON:

```
authorization: {
    version: 1
    rules: [
        {
        match-request: {
            path: "^/puppet/v3/catalog/([^/]+)$"
            type: regex
...Copied!
```

> **Note:**  You must escape regular expressions to conform to HOCON standards, which are the same as JSON's and differ from the deprecated format's regular  expressions. For instance, the digit-matching regular expression `\d` must be escaped with a second backslash, as `\d`.

Backreferencing works the same way it does in the deprecated format.

Deprecated:

```
path ~ ^/puppet/v3/catalog/([^/]+)$
allow $1Copied!
```

HOCON:

```
authorization: {
    version: 1
    rules: [
        {
        match-request: {
            path: "^/puppet/v3/catalog/([^/]+)$"
            type: regex
        }
        allow: "$1"
...Copied!
```

#### Allowing unauthenticated requests

To have a rule match any request regardless of its  authentication state, including unauthenticated requests, a deprecated  rule would assign the any value to the `auth` parameter. In a HOCON rule, set the `allow-unauthenticated` parameter to true. This overrides the `allow` and `deny` parameters and **is an insecure configuration** that should be used with caution.

Deprecated:

```
auth: anyCopied!
```

HOCON:

```
authorization: {
    version: 1
    rules: [
        {
        match-request: {
            ...
        }
        allow-unauthenticated: true
...Copied!
```

#### Multiple `method` indirectors

If a deprecated rule has multiple `method` indirectors, combine all of the related HTTP methods to the HOCON `method` array.

Deprecated:

```
method find, saveCopied!
```

The deprecated find indirector corresponds to the GET and  POST methods, and the save indirector corresponds to the PUT method. In  the HOCON format, simply combine these methods in an array.

HOCON:

```
authorization: {
    version: 1
    rules: [
        {
        match-request: {
            ...
            method: [get, post, put]
        }
...Copied!
```

#### Environment URL parameters

In deprecated rules, the `environment` parameter adds a comma-separated list of query parameters as a suffix  to the base URL. HOCON rules allow you to pass them as an array `environment` value inside the `query-params` setting. Rules in both the deprecated and HOCON formats match *any* `environment` value.

Deprecated:

```
environment: production,testCopied!
```

HOCON:

```
authorization: {
    version: 1
    rules: [
        {
        match-request: {
            ...
            query-params: {
                environment: [ production, test ]
            }
        }
...Copied!
```

> **Note:** The `query-params` approach above replaces environment-specific rules for both Puppet 3  and Puppet 4. If you're supporting agents running both Puppet 3 and  Puppet 4, see [Backward Compatibility with Puppet 3 Agents](https://www.puppet.com/docs/puppet/7/server/compatibility_with_puppet_agent.html) for more information.

#### Search indirector for `method`

There's no direct equivalent to the search indirector for the deprecated `method` setting. Create the equivalent rule by passing GET and POST to `method` and specifying endpoint paths using the `path` parameter.

Deprecated:

```
path ~ ^/puppet/v3/file_metadata/user_files/
method searchCopied!
```

HOCON:

```
authorization: {
    version: 1
    rules: [
        {
        match-request: {
            path: "^/puppet/v3/file_metadatas?/user_files/"
            type: regex
            method: [get, post]
        }
...
```

# Advanced logging configuration

### Sections

[Configuring Puppet Server for use with Logstash](https://www.puppet.com/docs/puppet/7/server/config_logging_advanced.html#configuring-puppet-server-for-use-with-logstash)

- [Configuring Puppet Server to log to JSON](https://www.puppet.com/docs/puppet/7/server/config_logging_advanced.html#configuring-puppet-server-to-log-to-json)
- [Sending the JSON data to Logstash](https://www.puppet.com/docs/puppet/7/server/config_logging_advanced.html#sending-the-json-data-to-logstash)

Puppet Server uses the [Logback](http://logback.qos.ch/) library to handle all of its logging. Logback configuration settings are stored in the [`logback.xml`](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html) file, which is located at `/etc/puppetlabs/puppetserver/logback.xml` by default.

You can configure Logback to log messages in JSON format,  which makes it easy to send them to other logging backends, such as  Logstash.

## Configuring Puppet Server for use with Logstash

There are a few steps necessary to setup  your Puppet Server logging for use with Logstash. The first step is to  modify your logging configuration so that Puppet Server is logging in a  JSON format. After that, you'll configure an external tool to monitor  these JSON files and send the data to Logstash (or another remote  logging system).

### Configuring Puppet Server to log to JSON

Before you configure Puppet Server to log to JSON, consider the following:

- Do you want to configure Puppet Server to *only* log to JSON, instead of the default plain-text logging? Or do you want to have JSON logging *in addition to* the default plain-text logging?
- Do you want to set up JSON logging *only* for the main Puppet Server logs (`puppetserver.log`), or *also* for the HTTP access logs (`puppetserver-access.log`)?
- What kind of log rotation strategy do you want to use for the new JSON log files?

The following examples show how to configure Logback for:

- logging to both JSON and plain-text
- JSON logging both the main logs and the HTTP access logs
- log rotation on the JSON log files

Adjust the example configuration settings to suit your needs.

> **Note:**  Puppet Server also relies on Logback to manage, rotate, and archive  Server log files. Logback archives Server logs when they exceed 200MB,  and when the total size of all Server logs exceeds 1GB, it automatically deletes the oldest logs.

#### Adding a JSON version of the main Puppet Server logs

Logback writes logs using components called [appenders](http://logback.qos.ch/manual/appenders.html). The example code below uses `RollingFileAppender` to rotate the log files and avoid consuming all of your storage.

1. To configure Puppet Server to log its main logs to a second log file in JSON format, add an appender section like the following  example to your `logback.xml` file, at the same level in the XML as existing appenders. The order of the appenders does not matter.

   ```
   <appender name="JSON" class="ch.qos.logback.core.rolling.RollingFileAppender">
       <file>/var/log/puppetlabs/puppetserver/puppetserver.log.json</file>
   
       <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
           <fileNamePattern>/var/log/puppetlabs/puppetserver/puppetserver.log.json.%d{yyyy-MM-dd}</fileNamePattern>
           <maxHistory>5</maxHistory>
       </rollingPolicy>
   
       <encoder class="net.logstash.logback.encoder.LogstashEncoder"/>
   </appender>Copied!
   ```

2. Activate the appended by adding an `appender-ref` entry to the `<root>` section of `logback.xml`:

   ```
   <root level="info">
       <appender-ref ref="FILE"/>
       <appender-ref ref="JSON"/>
   </root>Copied!
   ```

3. If you decide you want to log *only* the JSON format, comment out the other `appender-ref` entries.

`LogstashEncoder` has many  configuration options, including the ability to modify the list of  fields that you want to include, or give them different field names. For more information, see the [Logstash Logback Encoder Docs](https://github.com/logstash/logstash-logback-encoder/blob/master/README.md#loggingevent-fields).

#### Adding a JSON version of the Puppet Server HTTP Access logs

To add JSON logging for HTTP requests:

1. Add the following Logback appender section to the `request-logging.xml` file:

   ```
   {% raw %}
   <appender name="JSON" class="ch.qos.logback.core.rolling.RollingFileAppender">
       <file>/var/log/puppetlabs/puppetserver/puppetserver-access.log.json</file>
   
       <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
           <fileNamePattern>/var/log/puppetlabs/puppetserver/puppetserver-access.log.json.%d{yyyy-MM-dd}</fileNamePattern>
           <maxHistory>30</maxHistory>
       </rollingPolicy>
   
       <encoder class="net.logstash.logback.encoder.AccessEventCompositeJsonEncoder">
           <providers>
               <version/>
               <pattern>
                   <pattern>
                       {
                         "@timestamp":"%date{yyyy-MM-dd'T'HH:mm:ss.SSSXXX}",
                         "clientip":"%remoteIP",
                         "auth":"%user",
                         "verb":"%requestMethod",
                         "requestprotocol":"%protocol",
                         "rawrequest":"%requestURL",
                         "response":"#asLong{%statusCode}",
                         "bytes":"#asLong{%bytesSent}",
                         "total_service_time":"#asLong{%elapsedTime}",
                         "request":"http://%header{Host}%requestURI",
                         "referrer":"%header{Referer}",
                         "agent":"%header{User-agent}",
   
                         "request.host":"%header{Host}",
                         "request.accept":"%header{Accept}",
                         "request.accept-encoding":"%header{Accept-Encoding}",
                         "request.connection":"%header{Connection}",
   
                         "puppet.client-verify":"%header{X-Client-Verify}",
                         "puppet.client-dn":"%header{X-Client-DN}",
                         "puppet.client-cert":"%header{X-Client-Cert}",
   
                         "response.content-type":"%responseHeader{Content-Type}",
                         "response.content-length":"%responseHeader{Content-Length}",
                         "response.server":"%responseHeader{Server}",
                         "response.connection":"%responseHeader{Connection}"
                       }
                   </pattern>
               </pattern>
           </providers>
       </encoder>
   </appender>
   {% endraw %}Copied!
   ```

2. Add a corresponding `appender-ref` in the `configuration` section:

   ```
   <appender-ref ref="JSON"/>Copied!
   ```

For more information about options available for the `pattern` section, see the [Logback Logstash Encoder Docs](https://github.com/logstash/logstash-logback-encoder/blob/master/README.md#accessevent-fields).

### Sending the JSON data to Logstash

After configuring Puppet Server to log messages in JSON  format, you must also configure it to send the logs to Logstash (or  another external logging system).  There are several different ways to  approach this:

- Configure Logback to send the data to  Logstash directly, from within Puppet Server. See the Logstash-Logback  encoder docs on how to send the logs by [TCP](https://github.com/logstash/logstash-logback-encoder/blob/master/README.md#tcp) or [UDP](https://github.com/logstash/logstash-logback-encoder/blob/master/README.md#udp). Note that TCP comes with the risk of bottlenecking Puppet Server if  your Logstash system is busy, and UDP might silently drop log messages.
- [Filebeat](https://www.elastic.co/products/beats/filebeat) is a tool from Elastic for shipping log data to Logstash.
- [Logstash Forwarder](https://github.com/elastic/logstash-forwarder) is an earlier tool from Elastic with similar capabilities.

# Differing behavior in puppet.conf

### Sections

[Settings that differ](https://www.puppet.com/docs/puppet/7/server/puppet_conf_setting_diffs.html#settings-that-differ)

- [`autoflush`](https://www.puppet.com/docs/puppet/7/configuration.html#autoflush)
- [`bindaddress`](https://www.puppet.com/docs/puppet/7/configuration.html#bindaddress)
- [`ca`](https://www.puppet.com/docs/puppet/7/configuration.html#ca)
- [`ca_ttl`](https://www.puppet.com/docs/puppet/7/configuration.html#cattl)
- [`cacert`](https://www.puppet.com/docs/puppet/7/configuration.html#cacert)
- [`cacrl`](https://www.puppet.com/docs/puppet/7/configuration.html#cacrl)
- [`capass`](https://www.puppet.com/docs/puppet/7/configuration.html#capass)
- [`caprivatedir`](https://www.puppet.com/docs/puppet/7/configuration.html#caprivatedir)
- [`daemonize`](https://www.puppet.com/docs/puppet/7/configuration.html#daemonize)
- [`hostcert`](https://www.puppet.com/docs/puppet/7/configuration.html#hostcert)
- [`hostcrl`](https://www.puppet.com/docs/puppet/7/configuration.html#hostcrl)
- [`hostprivkey`](https://www.puppet.com/docs/puppet/7/configuration.html#hostprivkey)
- [`http_debug`](https://www.puppet.com/docs/puppet/7/configuration.html#httpdebug)
- [`keylength`](https://www.puppet.com/docs/puppet/7/configuration.html#keylength)
- [`localcacert`](https://www.puppet.com/docs/puppet/7/configuration.html#localcacert)
- [`logdir`](https://www.puppet.com/docs/puppet/7/configuration.html#logdir)
- [`masterhttplog`](https://www.puppet.com/docs/puppet/7/configuration.html#masterhttplog)
- [`masterlog`](https://www.puppet.com/docs/puppet/7/configuration.html#masterlog)
- [`masterport`](https://www.puppet.com/docs/puppet/7/configuration.html#masterport)
- [`puppetdlog`](https://www.puppet.com/docs/puppet/7/configuration.html#puppetdlog)
- [`rails_loglevel`](https://www.puppet.com/docs/puppet/7/configuration.html#railsloglevel)
- [`railslog`](https://www.puppet.com/docs/puppet/7/configuration.html#railslog)
- [`ssl_client_header`](https://www.puppet.com/docs/puppet/7/configuration.html#sslclientheader)
- [`ssl_client_verify_header`](https://www.puppet.com/docs/puppet/7/configuration.html#sslclientverifyheader)
- [`ssl_server_ca_auth`](https://www.puppet.com/docs/puppet/7/configuration.html#sslservercaauth)
- [`syslogfacility`](https://www.puppet.com/docs/puppet/7/configuration.html#syslogfacility)
- [`user`](https://www.puppet.com/docs/puppet/7/configuration.html#user)

[HttpPool-Related Server Settings](https://www.puppet.com/docs/puppet/7/server/puppet_conf_setting_diffs.html#httppool-related-server-settings)

- [`configtimeout`](https://www.puppet.com/docs/puppet/7/configuration.html#configtimeout)
- [`http_proxy_host`](https://www.puppet.com/docs/puppet/7/configuration.html#httpproxyhost)
- [`http_proxy_port`](https://www.puppet.com/docs/puppet/7/configuration.html#httpproxyport)

[Overriding Puppet settings in Puppet Server](https://www.puppet.com/docs/puppet/7/server/puppet_conf_setting_diffs.html#overriding-puppet-settings-in-puppet-server)

Expand

Puppet Server honors almost all settings in puppet.conf and should pick them up automatically. For more complete information on puppet.conf settings, see our [Configuration Reference](https://www.puppet.com/docs/puppet/7/configuration.html) page.

## Settings that differ

### [`autoflush`](https://www.puppet.com/docs/puppet/7/configuration.html#autoflush)

Puppet Server does not use this setting. For more information on the logging implementation for Puppet Server, see the [logging configuration section](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging).

### [`bindaddress`](https://www.puppet.com/docs/puppet/7/configuration.html#bindaddress)

Puppet Server does not use this setting. To set the address on which the primary server listens, use either `host` (unencrypted) or `ssl-host` (SSL encrypted) in the [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf) file.

### [`ca`](https://www.puppet.com/docs/puppet/7/configuration.html#ca)

Puppet Server does not use this setting. Instead, Puppet Server acts as a certificate authority based on the certificate authority service configuration in the `ca.cfg` file. See [Service Bootstrapping](https://www.puppet.com/docs/puppet/7/server/configuration.html#service-bootstrapping) for more details.

### [`ca_ttl`](https://www.puppet.com/docs/puppet/7/configuration.html#cattl)

Puppet Server enforces a max ttl of 50 standard years (up to 1576800000 seconds).

### [`cacert`](https://www.puppet.com/docs/puppet/7/configuration.html#cacert)

If you enable Puppet Server's certificate authority service, it uses the `cacert` setting in puppet.conf to determine the location of the CA certificate for such tasks as generating the CA certificate or using the CA to sign client certificates. This is true regardless of the configuration of the `ssl-` settings in [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf).

### [`cacrl`](https://www.puppet.com/docs/puppet/7/configuration.html#cacrl)

If you define `ssl-cert`, `ssl-key`, `ssl-ca-cert`, or `ssl-crl-path` in [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf), Puppet Server uses the file at `ssl-crl-path` as the CRL for authenticating clients via SSL. If at least one of the `ssl-` settings in webserver.conf is set but `ssl-crl-path` is not set, Puppet Server will *not* use a CRL to validate clients via SSL.

If none of the `ssl-` settings in webserver.conf are set, Puppet Server uses the CRL file defined for the `hostcrl` setting---and not the file defined for the `cacrl` setting--in puppet.conf. At start time, Puppet Server copies the file for the `cacrl` setting, if one exists, over to the location in the `hostcrl` setting.

Any CRL file updates from the Puppet Server certificate authority---such as revocations performed via the `certificate_status` HTTP endpoint---use the `cacrl` setting in puppet.conf to determine the location of the CRL. This is true regardless of the `ssl-` settings in webserver.conf.

### [`capass`](https://www.puppet.com/docs/puppet/7/configuration.html#capass)

Puppet Server does not use this setting. Puppet Server's certificate authority does not create a `capass` password file when the CA certificate and key are generated.

### [`caprivatedir`](https://www.puppet.com/docs/puppet/7/configuration.html#caprivatedir)

Puppet Server does not use this setting. Puppet Server's certificate authority does not create this directory.

### [`daemonize`](https://www.puppet.com/docs/puppet/7/configuration.html#daemonize)

Puppet Server does not use this setting.

### [`hostcert`](https://www.puppet.com/docs/puppet/7/configuration.html#hostcert)

If you define `ssl-cert`, `ssl-key`, `ssl-ca-cert`, or `ssl-crl-path` in [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf), Puppet Server presents the file at `ssl-cert` to clients as the server certificate via SSL.

If at least one of the `ssl-` settings in webserver.conf is set but `ssl-cert` is not set, Puppet Server gives an error and shuts down at startup. If none of the `ssl-` settings in webserver.conf are set, Puppet Server uses the file for the `hostcert` setting in puppet.conf as the server certificate during SSL negotiation.

Regardless of the configuration of the `ssl-` "webserver.conf" settings, Puppet Server's certificate authority service, if enabled, uses the `hostcert` "puppet.conf" setting, and not the `ssl-cert` setting, to determine the location of the server host certificate to generate.

### [`hostcrl`](https://www.puppet.com/docs/puppet/7/configuration.html#hostcrl)

If you define `ssl-cert`, `ssl-key`, `ssl-ca-cert`, or `ssl-crl-path` in [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf), Puppet Server uses the file at `ssl-crl-path` as the CRL for authenticating clients via SSL. If at least one of the `ssl-` settings in webserver.conf is set but `ssl-crl-path` is not set, Puppet Server will *not* use a CRL to validate clients via SSL.

If none of the `ssl-` settings in webserver.conf are set, Puppet Server uses the CRL file defined for the `hostcrl` setting---and not the file defined for the `cacrl` setting--in puppet.conf. At start time, Puppet Server copies the file for the `cacrl` setting, if one exists, over to the location in the `hostcrl` setting.

Any CRL file updates from the Puppet Server certificate authority---such as revocations performed via the `certificate_status` HTTP endpoint---use the `cacrl` setting in puppet.conf to determine the location of the CRL. This is true regardless of the `ssl-` settings in webserver.conf.

### [`hostprivkey`](https://www.puppet.com/docs/puppet/7/configuration.html#hostprivkey)

If you define `ssl-cert`, `ssl-key`, `ssl-ca-cert`, or `ssl-crl-path` in [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf), Puppet Server uses the file at `ssl-key` as the server private key during SSL transactions.

If at least one of the `ssl-` settings in webserver.conf is set but `ssl-key` is not, Puppet Server gives an error and shuts down at startup. If none of the `ssl-` settings in webserver.conf are set, Puppet Server uses the file for the `hostprivkey` setting in puppet.conf as the server private key during SSL negotiation.

If you enable the Puppet Server certificate authority service, Puppet Server uses the `hostprivkey` setting in puppet.conf to determine the location of the server host  private key to generate. This is true regardless of the configuration of the `ssl-` settings in webserver.conf.

### [`http_debug`](https://www.puppet.com/docs/puppet/7/configuration.html#httpdebug)

Puppet Server does not use this setting. Debugging for HTTP client code in Puppet Server is controlled through Puppet Server's common logging mechanism. For more information on the logging implementation for Puppet Server, see the [logging configuration section](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging).

### [`keylength`](https://www.puppet.com/docs/puppet/7/configuration.html#keylength)

Puppet Server does not currently use this setting. Puppet Server's certificate authority generates 4096-bit keys in conjunction with any SSL certificates that it generates.

### [`localcacert`](https://www.puppet.com/docs/puppet/7/configuration.html#localcacert)

If you define `ssl-cert`, `ssl-key`, `ssl-ca-cert`, and/or `ssl-crl-path` in [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf), Puppet Server uses the file at `ssl-ca-cert` as the CA cert store for authenticating clients via SSL.

If at least one of the `ssl-` settings in webserver.conf is set but `ssl-ca-cert` is not set, Puppet Server gives an error and shuts down at startup. If none of the `ssl-` settings in webserver.conf is set, Puppet Server uses the CA file defined for the `localcacert` setting in puppet.conf for SSL authentication.

### [`logdir`](https://www.puppet.com/docs/puppet/7/configuration.html#logdir)

Puppet Server does not use this setting. For more information on the logging implementation for Puppet Server, see the [logging configuration section](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging).

### [`masterhttplog`](https://www.puppet.com/docs/puppet/7/configuration.html#masterhttplog)

Puppet Server does not use this setting. You can configure a web server access log via the `access-log-config` setting in the [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf) file.

### [`masterlog`](https://www.puppet.com/docs/puppet/7/configuration.html#masterlog)

Puppet Server does not use this setting. For more information on the logging implementation for Puppet Server, see the [logging configuration section](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging).

### [`masterport`](https://www.puppet.com/docs/puppet/7/configuration.html#masterport)

Puppet Server does not use this setting. To set the port on which the primary server listens, set the `port` (unencrypted) or `ssl-port` (SSL encrypted) setting in the [webserver.conf](https://www.puppet.com/docs/puppet/7/server/configuration.html#webserverconf) file.

### [`puppetdlog`](https://www.puppet.com/docs/puppet/7/configuration.html#puppetdlog)

Puppet Server does not use this setting. For more information on the logging implementation for Puppet Server, see the [logging configuration section](https://www.puppet.com/docs/puppet/7/server/configuration.html#logging).

### [`rails_loglevel`](https://www.puppet.com/docs/puppet/7/configuration.html#railsloglevel)

Puppet Server does not use this setting.

### [`railslog`](https://www.puppet.com/docs/puppet/7/configuration.html#railslog)

Puppet Server does not use this setting.

### [`ssl_client_header`](https://www.puppet.com/docs/puppet/7/configuration.html#sslclientheader)

Puppet Server honors this setting only if the `allow-header-cert-info` setting in the `server.conf` file is set to 'true'. For more information on this setting, see the documentation on [external SSL termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html).

### [`ssl_client_verify_header`](https://www.puppet.com/docs/puppet/7/configuration.html#sslclientverifyheader)

Puppet Server honors this setting only if the `allow-header-cert-info` setting in the `server.conf` file is set to `true`. For more information on this setting, see the documentation on [external SSL termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html).

### [`ssl_server_ca_auth`](https://www.puppet.com/docs/puppet/7/configuration.html#sslservercaauth)

Puppet Server does not use this setting. It only considers the `ssl-ca-cert` setting from the webserver.conf file and the `cacert` setting from the puppet.conf file. See [`cacert`](https://www.puppet.com/docs/puppet/7/server/puppet_conf_setting_diffs.html#cacert) for more information.

### [`syslogfacility`](https://www.puppet.com/docs/puppet/7/configuration.html#syslogfacility)

Puppet Server does not use this setting.

### [`user`](https://www.puppet.com/docs/puppet/7/configuration.html#user)

Puppet Server does not use this setting.

## HttpPool-Related Server Settings

### [`configtimeout`](https://www.puppet.com/docs/puppet/7/configuration.html#configtimeout)

Puppet Server does not currently consider this setting when making HTTP requests. This pertains, for example, to  any requests that the primary server would make to the `reporturl` for the `http` report processor.

### [`http_proxy_host`](https://www.puppet.com/docs/puppet/7/configuration.html#httpproxyhost)

Puppet Server does not currently consider this setting when making HTTP requests. This pertains, for example, to  any requests that the primary server would make to the `reporturl` for the `http` report processor.

### [`http_proxy_port`](https://www.puppet.com/docs/puppet/7/configuration.html#httpproxyport)

Puppet Server does not currently consider this setting when making HTTP requests. This pertains, for example, to  any requests that the primary server would make to the `reporturl` for the `http` report processor.

## Overriding Puppet settings in Puppet Server

Currently, the [`jruby-puppet` section of your `puppetserver.conf` file](https://www.puppet.com/docs/puppet/7/server/configuration.html#puppetserver.conf) contains five settings (`master-conf-dir`, `master-code-dir`, `master-var-dir`, `master-run-dir`, and `master-log-dir`) that allow you to override settings set in your `puppet.conf` file. On installation, these five settings will be set to the proper default values.

While you are free to change these settings at will, please note that any changes made to the `master-conf-dir` and `master-code-dir` settings absolutely MUST be made to the corresponding Puppet settings (`confdir` and `codedir`) as well to ensure that Puppet Server and the Puppet cli tools (such as `puppetserver ca` and `puppet module`) use the same directories. The `master-conf-dir` and `master-code-dir` settings apply to Puppet Server only, and will be ignored by the ruby code that runs when the Puppet CLI tools are run.

For example, say you have the `codedir` setting left unset in your `puppet.conf` file, and you change the `master-code-dir` setting to `/etc/my-puppet-code-dir`. In this case, Puppet Server will read code from `/etc/my-puppet-code-dir`, but the `puppet module` tool will think that your code is stored in `/etc/puppetlabs/code`.

While it is not as critical to keep `master-var-dir`, `master-run-dir`, and `master-log-dir` in sync with the `vardir`, `rundir`, and `logdir` Puppet settings, please note that this applies to these settings as well.

Also, please note that these configuration differences also apply to the interpolation of the `confdir`, `codedir`, `vardir`, `rundir`, and `logdir` settings in your `puppet.conf` file. So, take the above example, wherein you set `master-code-dir` to `/etc/my-puppet-code-dir`. Because the `basemodulepath` setting is by default `$codedir/modules:/opt/puppetlabs/puppet/modules`, then Puppet Server would use `/etc/my-puppet-code-dir/modules:/opt/puppetlabs/puppet/modules` for the value of the `basemodulepath` setting, whereas the `puppet module` tool would use `/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules` for the value of the `basemodulepath` setting.

# Subcommands

### Sections

[ca](https://www.puppet.com/docs/puppet/7/server/subcommands.html#ca)

- [Available actions](https://www.puppet.com/docs/puppet/7/server/subcommands.html#available-actions)
- [Syntax](https://www.puppet.com/docs/puppet/7/server/subcommands.html#syntax)
- [Signing certs with SANs or auth extensions](https://www.puppet.com/docs/puppet/7/server/subcommands.html#signing-certs-with-sans-or-auth-extensions)

[gem](https://www.puppet.com/docs/puppet/7/server/subcommands.html#gem)

[ruby](https://www.puppet.com/docs/puppet/7/server/subcommands.html#ruby)

[irb](https://www.puppet.com/docs/puppet/7/server/subcommands.html#irb)

[foreground](https://www.puppet.com/docs/puppet/7/server/subcommands.html#foreground)

We've provided several CLI commands to help with debugging and exploring Puppet Server. Most of the commands are the same ones you would use in a Ruby environment -- such as `gem`, `ruby`, and `irb` -- except they run against Puppet Server's JRuby installation and gems instead of your system Ruby.

The following subcommands are provided:

- [ca](https://www.puppet.com/docs/puppet/7/server/subcommands.html#ca)
- [gem](https://www.puppet.com/docs/puppet/7/server/subcommands.html#gem)
- [ruby](https://www.puppet.com/docs/puppet/7/server/subcommands.html#ruby)
- [irb](https://www.puppet.com/docs/puppet/7/server/subcommands.html#irb)
- [foreground](https://www.puppet.com/docs/puppet/7/server/subcommands.html#foreground)

The format for each subcommand is:

```
puppetserver <subcommand> [<args>]Copied!
```

When running from source, the format is:

```
lein <subcommand> -c /path/to/puppetserver.conf [--] [<args>]Copied!
```

Note that if you are running from source, you need to separate flag arguments (such as `--version` or `-e`) with `--`, as shown above. Otherwise, those arguments will be applied to Leiningen instead of to Puppet Server. This isn't necessary when running from packages (i.e., `puppetserver <subcommand>`).

## ca

### Available actions

CA subcommand usage: `puppetserver ca <action> [options]`.

The available actions:

- `clean`: clean files from the CA for certificates
- `generate`: create a new certificate signed by the CA
- `setup`: generate a root and intermediate signing CA for Puppet Server
- `import`: import the CA's key, certs, and CRLs
- `list`: list all certificate requests
- `migrate`: migrate the contents of the CA directory from its current location to `/etc/puppetlabs/puppetserver/ca`. Adds a symlink at the old location for backwards compatibility.
- `revoke`: revoke a given certificate
- `sign`: sign a given certificate
  - Use the `--ttl` flag with `sign` subcommand to send the `ttl` to the CA. The signed certificate's `notAfter` value is the current time plus the `ttl`. The values are valid `puppet.conf` `ttl` values, for example, 1y = 1 year, 31d = 31 days.
- `purge`: remove duplicate entries from the CA CRL

**Important:** Most of these actions only work if the `puppetserver` service is running. Exceptions to this requirement are:

- `migrate` and `purge`, which require you to stop the `puppetserver` service.
- `setup` and `import`, which require you to run the actions only once **before** you start your `puppetserver` service, for the very first time.

### Syntax

```
puppetserver ca <action> [options]Copied!
```

Most commands require a target to be specified with the `--certname` flag. For example:

```
puppetserver ca sign --certname cert.example.comCopied!
```

The target is a comma separated list of names that act on multiple certificates at one time.

You can supply a custom configuration file to all subcommands using the `--config` option. This allows you to point the command at a custom `puppet.conf`, instead of the default one.

**Note:** These commands are available in Puppet 5, but in order to use them, you must update Puppet Server’s `auth.conf` to include a rule allowing the primary server’s certname to access the `certificate_status` and `certificate_statuses` endpoints. The same applies to upgrading in open source Puppet: if  you're upgrading from Puppet 5 to Puppet 6 and are not regenerating your CA, you must allow the primary server’s certname. See [Puppet Server Configuration Files: auth.conf](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html) for details on how to use `auth.conf`.

Example:

```
{
    # Allow the CA CLI to access the certificate_status endpoint
    match-request: {
        path: "/puppet-ca/v1/certificate_status"
        type: path
        method: [get, put, delete]
    }
    allow: server.example.com
    sort-order: 500
    name: "puppetlabs cert status"
},Copied!
```

### Signing certs with SANs or auth extensions

With the removal of `puppet cert sign`, it's possible for Puppet Server’s CA API to sign certificates with  subject alternative names or auth extensions, which was previously  completely disallowed. This is disabled by default for security reasons, but you can turn it on by setting `allow-subject-alt-names` or `allow-authorization-extensions` to true in the `certificate-authority` section of Puppet Server’s config (usually located in `ca.conf`). After these have been configured, you can use `puppetserver ca sign --certname <name>` to sign certificates with these additions.

**Note:** For more details about the `ca` subcommand, visit [Puppet Server CA commands](https://www.puppet.com/docs/puppet/7/puppet_server_ca_cli.html).

## gem

Installs and manages gems that are isolated from system  Ruby and are accessible only to Puppet Server. This is a simple wrapper  around the standard Ruby `gem`, so all of the usual arguments and flags should work as expected.

Examples:

```
$ puppetserver gem install pry --no-ri --no-rdocCopied!
$ lein gem -c /path/to/puppetserver.conf -- install pry --no-ri --no-rdocCopied!
```

If needed, you also can use the `JAVA_ARGS_CLI` environment variable to pass along custom arguments to the Java process that the `gem` command is run within.

Example:

```
$ JAVA_ARGS_CLI=-Xmx8g puppetserver gem install pry --no-ri --no-rdocCopied!
```

If you prefer to have the `JAVA_ARGS_CLI` option persist for multiple command executions, you could set the value in the `/etc/sysconfig/puppetserver` or `/etc/default/puppetserver` file, depending upon your OS distribution:

```
JAVA_ARGS_CLI=-Xmx8gCopied!
```

With the value specified in the sysconfig or defaults file, subsequent commands would use the `JAVA_ARGS_CLI` variable automatically:

```
$ puppetserver gem install pry --no-ri --no-rdoc
// Would run 'gem' with a maximum Java heap of 8gCopied!
```

For more information, see [Puppet Server and Gems](https://www.puppet.com/docs/puppet/7/server/gems.html).

## ruby

Runs code in Puppet Server's JRuby interpreter. This is a simple wrapper around the standard Ruby `ruby`, so all of the usual arguments and flags should work as expected.

Useful when experimenting with gems installed via `puppetserver gem` and the Puppet and Puppet Server Ruby source code.

Examples:

```
$ puppetserver ruby -e "require 'puppet'; puts Puppet[:certname]"Copied!
$ lein ruby -c /path/to/puppetserver.conf -- -e "require 'puppet'; puts Puppet[:certname]"Copied!
```

If needed, you also can use the `JAVA_ARGS_CLI` environment variable to pass along custom arguments to the Java process that the `ruby` command is run within.

Example:

```
$ JAVA_ARGS_CLI=-Xmx8g puppetserver ruby -e "require 'puppet'; puts Puppet[:certname]"Copied!
```

If you prefer to have the `JAVA_ARGS_CLI` option persist for multiple command executions, you could set the value in the `/etc/sysconfig/puppetserver` or `/etc/default/puppetserver` file, depending upon your OS distribution:

```
JAVA_ARGS_CLI=-Xmx8gCopied!
```

With the value specified in the sysconfig or defaults file, subsequent commands would use the `JAVA_ARGS_CLI` variable automatically:

```
$ puppetserver ruby -e "require 'puppet'; puts Puppet[:certname]"
// Would run 'ruby' with a maximum Java heap of 8gCopied!
```

## irb

Starts an interactive REPL for the JRuby that Puppet Server uses. This is a simple wrapper around the standard Ruby `irb`, so all of the usual arguments and flags should work as expected.

Like the `ruby` subcommand, this is useful for experimenting in an interactive environment with any installed gems (via `puppetserver gem`) and the Puppet and Puppet Server Ruby source code.

Examples:

```
$ puppetserver irb
irb(main):001:0> require 'puppet'
=> true
irb(main):002:0> puts Puppet[:certname]
centos6-64.localdomain
=> nilCopied!
$ lein irb -c /path/to/puppetserver.conf -- --version
irb 0.9.6(09/06/30)Copied!
```

If needed, you also can use the `JAVA_ARGS_CLI` environment variable to pass along custom arguments to the Java process that the `irb` command is run within.

Example:

```
$ JAVA_ARGS_CLI=-Xmx8g puppetserver irbCopied!
```

If you prefer to have the `JAVA_ARGS_CLI` option persist for multiple command executions, you could set the value in the `/etc/sysconfig/puppetserver` or `/etc/default/puppetserver` file, depending upon your OS distribution:

```
JAVA_ARGS_CLI=-Xmx8gCopied!
```

With the value specified in the sysconfig or defaults file, subsequent commands would use the `JAVA_ARGS_CLI` variable automatically:

```
$ puppetserver irb
// Would run 'irb' with a maximum Java heap of 8gCopied!
```

## foreground

Starts the Puppet Server, but doesn't background it; similar to starting the service and then tailing the log.

Accepts an optional `--debug` argument to raise the logging level to DEBUG.

Examples:

```
$ puppetserver foreground --debug
2014-10-25 18:04:22,158 DEBUG [main] [p.t.logging] Debug logging enabled
2014-10-25 18:04:22,160 DEBUG [main] [p.t.bootstrap] Loading bootstrap config from specified path: '/etc/puppetserver/bootstrap.cfg'
2014-10-25 18:04:26,097 INFO  [main] [p.s.j.jruby-puppet-service] Initializing the JRuby service
2014-10-25 18:04:26,101 INFO  [main] [p.t.s.w.jetty9-service] Initializing web server(s).
2014-10-25 18:04:26,149 DEBUG [clojure-agent-send-pool-0] [p.s.j.jruby-puppet-agents] Init
```

# Using Ruby gems

### Sections

[ `GEM_HOME` values](https://www.puppet.com/docs/puppet/7/server/gems.html#gem-home-values)

- [Gems with packaged versions of Puppet Server](https://www.puppet.com/docs/puppet/7/server/gems.html#gems-with-packaged-versions-of-puppet-server)
- [Gems when running Puppet Server from source](https://www.puppet.com/docs/puppet/7/server/gems.html#gems-when-running-puppet-server-from-source)
- [Gems when running Puppet Server spec tests](https://www.puppet.com/docs/puppet/7/server/gems.html#gems-when-running-puppet-server-spec-tests)

[Installing and removing gems](https://www.puppet.com/docs/puppet/7/server/gems.html#installing-and-removing-gems)

[Installing gems for use with development:](https://www.puppet.com/docs/puppet/7/server/gems.html#installing-gems-for-use-with-development)

[Gems with Native (C) Extensions](https://www.puppet.com/docs/puppet/7/server/gems.html#gems-with-native-c-extensions)

If you have server-side Ruby code in your modules, Puppet Server will run it via JRuby. Generally speaking, this only affects custom parser functions, types, and report processors. For the vast majority of cases this shouldn't pose any problems because JRuby is highly compatible with vanilla Ruby.

Puppet Server will not load gems from user specified `GEM_HOME` and `GEM_PATH` environment variables because `puppetserver` unsets `GEM_PATH` and manages `GEM_HOME`.

> **Note:** Starting with Puppet Server 2.7.1, you can set custom Java arguments for the `puppetserver gem` command via the `JAVA_ARGS_CLI` environment variable, either temporarily on the command line or persistently by adding it to the sysconfig/default file. The `JAVA_ARGS_CLI` environment variable also controls the arguments used when running the `puppetserver ruby` and `puppetserver irb` [subcommands](https://www.puppet.com/docs/puppet/7/server/subcommands.html). See the [Server 2.7.1 release notes](https://docs.puppet.com/puppetserver/2.7/release_notes.html) for details.

## `GEM_HOME` values

### Gems with packaged versions of Puppet Server

The value of `GEM_HOME` when starting the puppetserver process as root using a packaged version of `puppetserver` is:

```
/opt/puppetlabs/puppet/cache/jruby-gemsCopied!
```

This directory does not exist by default.

### Gems when running Puppet Server from source

The value of `GEM_HOME` when starting the puppetserver process from the project root is:

```
./target/jruby-gemsCopied!
```

### Gems when running Puppet Server spec tests

The value of `GEM_HOME` when starting the puppetserver JRuby spec tests using `rake spec` from the project root is:

```
./vendor/test_gemsCopied!
```

This directory is automatically populated by the `rake spec` task if it does not already exist.  The directory may be safely removed and it will be re-populated the next time `rake spec` is run in your working copy.

## Installing and removing gems

We isolate the Ruby load paths that are accessible to Puppet Server's JRuby interpreter, so that it doesn't load any gems or other code that you have installed on your system Ruby. If you want Puppet Server to load additional gems, use the Puppet Server-specific `gem` command to install them:

```
$ sudo puppetserver gem install <GEM NAME> --no-documentCopied!
```

The `puppetserver gem` command is simply a wrapper around the usual Ruby `gem` command, so all of the usual arguments and flags should work as expected. For example, to show your locally installed gems, run:

```
$ puppetserver gem listCopied!
```

Or, if you're running from source:

```
$ lein gem -c ~/.puppetserver/puppetserver.conf listCopied!
```

The `puppetserver gem` command also respects the running user's `~/.gemrc` file, which you can use to configure upstream sources or proxy settings. For example, consider a `.gemrc` file containing:

```
---
:sources: [ 'https://rubygems-mirror.megacorp.com', 'https://rubygems.org' ]
http_proxy: "http://proxy.megacorp.com:8888"Copied!
```

This configures the listed `:sources` as the `puppetserver gem` command's upstream sources, and uses the listed `http_proxy`, which you can confirm:

```
$ puppetserver gem environment | grep proxy
    - "http_proxy" => "http://proxy.megacorp.com:8888"Copied!
```

As with the rest of Puppet Server's configuration, we recommend managing these settings with Puppet. You can manage Puppet Server's gem dependencies with the package provider shipped in [`puppetlabs-puppetserver_gem`](https://forge.puppet.com/puppetlabs/puppetserver_gem) module.

> Note: If you try to load a gem before it's been installed, the agent run will fail with a `LoadError`. If this happens, reload the server after installing the gem to resolve the issue.

## Installing gems for use with development:

When running from source, JRuby uses a `GEM_HOME` of `./target/jruby-gems` relative to the current working directory of the process.  `lein gem` should be used to install gems into this location using jruby.

NOTE: `./target/jruby-gems` is not used when running the JRuby spec tests, gems are instead automatically installed into and loaded from `./vendor/test_gems`. If you need to install a gem for use both during development and testing make sure the gem is available in both directories.

As an example, the following command installs `pry` locally in the project. Note the use of `--` to pass the following command line arguments to the gem script.

```
$ lein gem --config ~/.puppetserver/puppetserver.conf -- install pry \
   --no-document
Fetching: coderay-1.1.0.gem (100%)
Successfully installed coderay-1.1.0
Fetching: slop-3.6.0.gem (100%)
Successfully installed slop-3.6.0
Fetching: method_source-0.8.2.gem (100%)
Successfully installed method_source-0.8.2
Fetching: spoon-0.0.4.gem (100%)
Successfully installed spoon-0.0.4
Fetching: pry-0.10.1-java.gem (100%)
Successfully installed pry-0.10.1-java
5 gems installedCopied!
```

With the gem installed into the project tree `pry` can be invoked from inside Ruby code.  For more detailed information on `pry` see [Puppet Server: Debugging](https://www.puppet.com/docs/puppet/7/server/dev_debugging.html#pry).

## Gems with Native (C) Extensions

If, in your custom parser functions or report processors, you're using Ruby gems that require native (C) extensions, you won't be able to install these gems under JRuby. In many cases, however, there are drop-in replacements implemented in Java. For example, the popular [Nokogiri](http://www.nokogiri.org/) gem for processing XML provides a completely compatible Java implementation that's automatically installed if you run `gem install` via JRuby or Puppet Server, so you shouldn't need to change your code at all.

In other cases, there may be a replacement gem available with a slightly different name; e.g., `jdbc-mysql` instead of `mysql`. The JRuby wiki [C Extension Alternatives](https://github.com/jruby/jruby/wiki/C-Extension-Alternatives) page discusses this issue further.

If you're using a gem that won't run on JRuby and you can't find a suitable replacement, please open a ticket on our [Issue Tracker](https://tickets.puppet.com/browse/SERVER); we're definitely interested in helping provide solutions if there are common gems that are causing trouble for users!

# Intermediate CA

### Sections

[Where to set CA configuration](https://www.puppet.com/docs/puppet/7/server/intermediate_ca.html#where-to-set-ca-configuration)

[Set up Puppet as an intermediate CA with an external root](https://www.puppet.com/docs/puppet/7/server/intermediate_ca.html#set-up-puppet-as-an-intermediate-ca-with-an-external-root)

Puppet Server supports both a simple CA architecture, with a self-signed root cert that is also used as the CA signing cert; and an  intermediate CA architecture, with a self-signed root that issues an  intermediate CA cert used for signing incoming certificate requests. The intermediate CA architecture is preferred, because it is more secure  and makes regenerating certs easier. To generate a default intermediate  CA for Puppet Server, run the `puppetserver ca setup` command before starting your server for the first time.

The following diagram shows the configuration of Puppet's basic certificate infrastructure.


![A diagram showing Puppet's basic certificate infrastructure](https://www.puppet.com/docs/puppet/7/CA_Basic_Foss_server.png)

If you have an external certificate authority, you can create a cert chain from it, and use the `puppetserver ca import` subcommand to install the chain on your server. Puppet agents starting  with Puppet 6 handle an intermediate CA setup out of the box. No need to copy files around by hand or configure CRL checking. Like `setup`, `import` needs to be run before starting your server for the first time.

**Note:** The PE installer uses the `puppetserver ca setup` command to create a root cert and an intermediate signing cert for  Puppet Server. This means that in PE, the default CA is always an  intermediate CA as of PE 2019.0.

**Note:** If for some reason you  cannot use an intermediate CA, in Puppet Server 6 starting the server  will generate a non-intermediate CA the same as it always did before the introduction of these commands. However, we don't recommend this, as  using an intermediate CA provides more security and easier paths for CA  regeneration. It is also the default in PE, and some recommended  workflows may rely on it.

## Where to set CA configuration

All CA configuration takes place in Puppet’s config file. See the [Puppet Configuration Reference](https://www.puppet.com/docs/puppet/7/configuration.html) for details.

## Set up Puppet as an intermediate CA with an external root

Puppet Server needs to present the full certificate chain  to clients so the client can authenticate the server. You construct the  certificate chain by concatenating the CA certificates, starting with  the new intermediate CA certificate and descending to the root CA  certificate.

The following diagram shows the configuration of Puppet's certificate infrastructure with an external root.


![A diagram showing Puppet's certificate infrastructure with an external root](https://www.puppet.com/docs/puppet/7/CA_External_Root_Foss_server.png)

To set up Puppet as an intermediate CA with an external root:

1. Collect the PEM-encoded certificates and  CRLs for your organization's chain of trust, including the root  certificate, any intermediate certificates, and the signing certificate. (The signing certificate might be the root or intermediate  certificate.)

2. Create a private RSA key, with no passphrase, for the Puppet CA.

3. Create a PEM-encoded Puppet CA certificate.

   1. Create a CSR for the Puppet CA.

   2. Generate the Puppet CA certificate by signing the CSR using your external CA.

      Ensure the CA constraint is set to true and the  keyIdentifier is composed of the 160-bit SHA-1 hash of the value of the  bit string subjectPublicKeyfield. See RFC 5280 section 4.2.1.2 for  details.

4. Concatenate all of the certificates into a PEM-encoded  certificate bundle, starting with the Puppet CA cert and ending with  your root certificate.

   ```
   -----BEGIN CERTIFICATE-----
   <Puppet’s CA cert>
   -----END CERTIFICATE-----
   -----BEGIN CERTIFICATE-----
   <Org’s intermediate CA signing cert>
   -----END CERTIFICATE-----
   -----BEGIN CERTIFICATE-----
   <Org’s root CA cert>
   -----END CERTIFICATE-----Copied!
   ```

5. Concatenate all of the CRLs into a PEM-encoded CRL chain,  starting with any optional intermediate CA CRLs and ending with your  root certificate CRL.

   ```
   -----BEGIN X509 CRL-----
   <Puppet’s CA CRL>
   -----END X509 CRL-----
   -----BEGIN X509 CRL-----
   <Org’s intermediate CA CRL>
   -----END X509 CRL-----
   -----BEGIN X509 CRL-----
   <Org’s root CA CRL>
   -----END X509 CRL-----Copied!
   ```

6. Use the `puppetserver ca import` command to trigger the rest of the CA setup:

   ```
   puppetserver ca import --cert-bundle ca-bundle.pem --crl-chain crls.pem --private-key puppet_ca_key.pemCopied!
   ```

7. optional. Validate that the CA is working by running puppet agent -t and verifying your intermediate CA with OpenSSL.

```
openssl x509 -in /etc/puppetlabs/puppet/ssl/ca/signed/<HOSTNAME>.crt 
-text -noout
Certificate:
   Data:
       Version: 3 (0x2)
       Serial Number: 1 (0x1)
   Signature Algorithm: sha256WithRSAEncryption
       Issuer: CN=intermediate-caCopied!
```

**Note**:  If your organization's CRLs require frequent updating, you can use the [`certificate_revocation_list`](https://github.com/puppetlabs/osp-docs/blob/latest-preview/server/http_certificate_revocation_list.md#update-the-crl-with-crl-pem) endpoint to insert updated copies of your CRLs into the trust chain.  The CA updates the matching CRLs saved on disk if the submitted ones  have a higher CRL number than their counterparts. In addition, set  Puppet’s [`crl_refresh_interval`](https://puppet.com/docs/puppet/7/configuration.html#certificate_revocation) on all of your agents to ensure that they download the updated CRLs.

# Autosigning certificate requests

### Sections

[Disabling autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_disable_autosigning)

[Naïve autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_nave_autosigning)

[Basic autosigning (`autosign.conf`)](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_basic_autosigning)

- [Enabling basic autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#enabling-basic-autosigning)
- [Security implications of basic autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#security-implications-basic-autosigning)

[Policy-based autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_policy_based_autosigning)

- [Enabling policy-based autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#enabling-policy-based-autosigning)
- [Custom policy executables](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#custom-policy-executables)
- [Security implications of policy-based autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#secutiry-implications-policy-based-autosigning)
- [Policy executable API](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#policy-executable-api)

Before Puppet agent nodes        can retrieve their configuration catalogs, they require a signed certificate from the local            Puppet certificate authority (CA). When using Puppet’s built-in CA instead of an external CA, agents submit        a certificate signing request (CSR) to the CA to retrieve a signed certificate after it's        available.

By default, these CSRs must be manually signed by an admin user, using            either the `puppetserver                ca` command or the Node requests page in the Puppet Enterprise            console.

Alternatively, to speed up the process of bringing new agent nodes            into the deployment, you can configure the CA to automatically sign certain CSRs.

CAUTION: Autosigning CSRs changes the nature of your                deployment’s security, and you should understand the implications before configuring                it. Each type of autosigning has its own security impact.

## Disabling autosigning

By default, the `autosign` setting in the `[server]` section of the CA’s `puppet.conf` file is set            to `$confdir/autosign.conf`. The basic autosigning functionality is enabled upon        installation. 

Depending on your installation method, there might not be an allowlist            at that location after the Puppet Server is running:

- Open source Puppet: `autosign.conf` doesn’t exist                        by default.
- Monolithic Puppet Enterprise (PE)                        installations: All required services run on one server, and `autosign.conf` exists on the primary server, but by default it's empty                    because the primary server doesn’t need to add other servers to an allowlist.
- Split PE installations: Services like PuppetDB can                        run on different servers, the `autosign.conf` exists on the CA server and                        contains an allowlist of other required hosts.

If the `autosign.conf` file is empty or doesn’t exist, the allowlist is            effectively empty. The CA Puppet primary server doesn’t autosign            any certificates until the the autosign setting’s path is configured, or until            the default `autosign.conf` file is a non-executable allowlist file. This file must            contain correctly formatted content or a custom policy executable that the Puppet user has permission to run.

To explicitly disable autosigning, set `autosign = false` in                the `[server]` section of the CA Puppet            primary server’s `puppet.conf`. This disables CA autosigning even if the `autosign.conf` file or a            custom policy executable exists.

For more information about the `autosign` setting in `puppet.conf`, see the [configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html).

## Naïve autosigning

Naïve autosigning causes the CA to autosign all      CSRs.

To enable naïve autosigning, set `autosign = true` in the `[server]` section of the CA Puppet primary server’s `puppet.conf`.

CAUTION: For security reasons, never use naïve            autosigning in a production deployment. Naïve autosigning is suitable only for            temporary test deployments that are incapable of serving catalogs containing sensitive            information.

## Basic autosigning (`autosign.conf`)

In basic autosigning, the CA uses a config file containing        an allowlist of certificate names and domain name globs. When a CSR arrives, the requested        certificate name is checked against the allowlist file. If the name is present, or covered        by one of the domain name globs, the certificate is autosigned. If not, it's left for a        manual review.

### Enabling basic autosigning

The `autosign.conf` allowlist file’s location                and contents are described in its [documentation](https://www.puppet.com/docs/puppet/7/config_file_autosign.html).

​                Puppet looks for `autosign.conf `at the path configured in the `[autosign setting]` within the `[server]` section of `puppet.conf`. The default path is `$confdir/autosign.conf`, and the default `confdir` path depends on your operating system. For more                information, see the [confdir documentation.](https://www.puppet.com/docs/puppet/7/dirs_confdir.html)            

If the `autosign.conf` file pointed to by                    the `autosign` setting is a file that                the Puppet user can execute, Puppet instead attempts to run it as a custom policy                executable, even if it contains a valid `autosign.conf` allowlist.

Note: In open source Puppet,                        no `autosign.conf` file exists by                    default. In Puppet Enterprise, the file exists by default                    but might be empty. In both cases, the basic autosigning feature is technically                    enabled by default but doesn’t autosign any certificates because the allowlist                    is effectively empty. 

The CA Puppet primary                        server therefore doesn’t autosign any certificates until the `autosign.conf` file contains a properly                        formatted allowlist or is a custom policy executable that the Puppet user has permission to run, or until                            the `autosign` setting is pointed at                        an allowlist file with properly formatted content or a custom policy                        executable that the Puppet user has                        permission to run.

### Security implications of basic autosigning

Basic autosigning is insecure because any host can provide any certname when                requesting a certificate. Use it only when you fully trust any computer capable of                connecting to the Puppet primary server.

With basic autosigning enabled, an attacker who guesses an unused certname allowed                    by `autosign.conf` can obtain a signed                agent certificate from the Puppet primary server. The                attacker could then obtain a configuration catalog, which can contain sensitive                information depending on your deployment’s Puppet                code and node classification.

## Policy-based autosigning

In policy-based autosigning, the CA runs an external        policy executable every time it receives a CSR. This executable examines the CSR and tells        the CA whether the certificate is approved for autosigning. If the executable approves, the        certificate is autosigned; if not, it's left for manual review.

### Enabling policy-based autosigning

To enable policy-based autosigning, set `autosign =                    <policy executable file>` in the `[server]` section of the CA Puppet                primary server’s `puppet.conf`.

The policy executable file must be executable by the same user as the Puppet primary server. If not, it is treated as                a certname allowlist file.

### Custom policy executables

A custom policy executable can be written in any programming language; it just has to                be executable in a *nix-like environment. The Puppet primary server passes it the certname of the                request (as a command line argument) and the PEM-encoded CSR (on stdin), and expects                    a `0` (approved) or non-zero (rejected)                exit code.

After it has the CSR, a policy executable can extract information from it and decide                whether to approve the certificate for autosigning. This is useful when you are                provisioning your nodes and are [embedding additional information in the CSR](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions).

If you aren’t embedding additional data, the CSR contains only the node’s certname                and public key. This can still provide more flexibility and security                    than `autosign.conf`, as the executable can                do things like query your provisioning system, CMDB, or cloud provider to make sure                a node with that name was recently added.

### Security implications of policy-based autosigning

Depending on how you manage the information the policy executable is using,                policy-based autosigning can be fast and extremely secure. 

For example:

- If you embed a unique pre-shared key on each node you provision, and                            provide your policy executable with a database of these keys, your                            autosigning security is as good as your handling of the keys. As long as                            it’s impractical for an attacker to acquire a PSK, it's impractical for                            them to acquire a signed certificate.
- If nodes running on a cloud service embed their instance UUIDs in their                            CSRs, and your executable queries the cloud provider’s API to check that                            a node's UUID exists in your account, your autosigning security is as                            good as the security of the cloud provider’s API. If an attacker can                            impersonate a legit user to the API and get a list of node UUIDs, or if                            they can create a rogue node in your account, they can acquire a signed                            certificate.

When designing your CSR data and signing policy, you must think things through                carefully. If you can arrange reasonable end-to-end security for secret data on your                nodes, you can configure a secure autosigning system.

### Policy executable API

The API for policy executables is as follows.

| Run environment   | The executable runs one time for each incoming                                                CSR.                                                                                                                            It is executed by the Puppet primary server                                                process and runs as the same user as the Puppet primary                                                server.                                                                                                                            The Puppet primary                                                server process is blocked until the executable                                                finishes running. We expect policy executables                                                to finish in a timely fashion; if they do not, it’s                                                possible for them to tie up all available Puppet primary server                                                threads and deny service to other agents. If an                                                executable needs to perform network requests or                                                other potentially expensive operations, the author                                                is in charge of implementing any necessary timeouts,                                                possibly bailing and exiting non-zero in the event                                                of failure. |
| ----------------- | ------------------------------------------------------------ |
| Arguments         | The executable must allow a single command line                                                argument. This argument is the Subject CN (certname)                                                of the incoming CSR.                                                                                                                            No other command line arguments should be                                                provided.                                                                                                                            The Puppet primary                                                server should never fail to provide this                                                argument. |
| Stdin             | The executable receives the entirety of the incoming                                                CSR on its stdin stream. The CSR is encoded in                                                  `pem` format.                                                                                                                            The stdin stream contains nothing but the complete                                                CSR.                                                                                                                            The Puppet primary                                                server should never fail to provide the CSR on                                                stdin. |
| Exit status       | The executable must exit with a status                                                  of `0` if                                                the certificate should be autosigned; it must exit                                                with a non-zero status if it should not be                                                autosigned.                                                                                                                            The Puppet primary                                                server treats all non-zero exit statuses as                                                equivalent. |
| Stdout and stderr | Anything the executable emits on stdout or stderr is                                                copied to the Puppet Server                                                log output at the `debug` log level. Puppet otherwise                                                ignores the executable’s output; only the exit code                                                is considered significant. |

# CSR attributes and certificate extensions

### Sections

[Timing: When data can be added to CSRs and                         certificates](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#add_data_to_csrs_and_certs)

[Data location and format](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#csr_data_location_and_format)

[Custom attributes (transient CSR data)](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#csr_custom_attributes)

- [Default behavior](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#custom-attributes-default-behavior)
- [Configurable behavior](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#custom-attributes-configurable-behavior)
- [Manually checking for custom attributes in CSRs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#manually-checking-custom-attributes-csrs)
- [Recommended OIDs for attributes](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#recommended-oids-custom-attributes)

[Extension requests (permanent certificate data)](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#csr_extension_requests)

- [Default behavior](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#extension-requests-default-behavior)
- [Configurable behavior](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#extension-requests-configurable-behavior)
- [Manually checking for extensions in CSRs and certificates](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#manually-checking-extensions-csrs-certificates)
- [Recommended OIDs for extensions](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#recommended-oids-csr-extensions)
- [ Puppet-specific registered IDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#puppet_registered_ids)

[Cloud provider attributes and extensions population         example](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#aws_attributes_and_extensions)

[Troubleshooting](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#csr_troubleshooting)

- [Recovering from failed data embedding](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#recovering-from-failed-data-embedding)

Expand

When Puppet agent nodes        request their certificates, the certificate signing request (CSR) usually contains only        their certname and the necessary cryptographic information. Agents can also embed additional        data in their CSR, useful for policy-based autosigning and for adding new trusted        facts.

Embedding additional data into CSRs is useful when:

- Large numbers of nodes are regularly                        created and destroyed as part of an elastic scaling system.
- You are willing to build custom                        tooling to make certificate autosigning more secure and useful.

It might also be useful in deployments where Puppet            is used to deploy private keys or other sensitive information, and you want extra            control over nodes that receive this data.

If your deployment doesn’t match one of these descriptions, you might            not need this feature.

## Timing: When data can be added to CSRs and                        certificates



When Puppet agent starts the process of                                    requesting a catalog, it checks whether it has a valid signed                                    certificate. If it does not, it generates a key pair, crafts a                                    CSR, and submits it to the certificate authority (CA) Puppet Server. For detailed information, see [agent/server HTTPS traffic](https://www.puppet.com/docs/puppet/7/subsystem_agent_primary_comm.dita).

For practical purposes, a certificate is locked and                                    immutable as soon as it is signed. For data to persist in the                                    certificate, it has to be added to the CSR before the                                    CA signs the certificate.

This means any desired extra data must be                                                present before Puppet agent attempts to                                    request its catalog for the first time.

Populate any extra data when provisioning the node. If                                    you make an error, see the Troubleshooting section below for                                    information about recovering from failed data                                    embedding.

## Data location and format

Extra data for the CSR is read from the `csr_attributes.yaml` file in Puppet's `confdir`. The location of this file can be changed with the            `csr_attributes`        configuration setting.

The `csr_attributes.yaml` file must contain a YAML hash with one or both of            the following keys: 

- ​                        `custom_attributes`                    
- ​                        `extension_requests`                    

The value of each key must also be a hash, where: 

- Each key is a valid [object identifier (OID)](http://en.wikipedia.org/wiki/Object_identifier) — [                             Puppet-specific OIDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#puppet_registered_ids)can optionally                        be referenced by short name instead of by numeric ID. 
- Each value is an object that can be                        cast to a string — numbers are allowed but arrays are not.

For information about how each hash is used and recommended OIDs for            each hash, see the sections below.

## Custom attributes (transient CSR data)

Custom attributes are pieces of data that        are embedded only in the CSR. The CA can use them when deciding whether to sign the        certificate, but they are discarded after that and aren’t transferred to the final        certificate.

### Default behavior

The `puppetserver ca list` command doesn’t                display custom attributes for pending CSRs, and [basic autosigning (autosign.conf)](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_autosign) doesn’t check them before signing.

### Configurable behavior

If you use [policy-based                     autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_policy_based_autosigning) your policy executable receives the complete CSR in PEM                format. The executable can extract and inspect the custom attributes, and use them                to decide whether to sign the certificate.

The simplest method is to embed a pre-shared key of some kind in the custom                attributes. A policy executable can compare it to a list of known keys and autosign                certificates for any pre-authorized nodes.

A more complex use might be to embed an instance-specific ID and write a policy                executable that can check it against a list of your recently requested instances on                a public cloud, like EC2 or GCE.

### Manually checking for custom attributes in CSRs

You can check for custom attributes by using OpenSSL to dump a CSR in `pem` format to text format, by running this                command:

```
openssl req -noout -text -in <name>.pemCopied!
```

In the output, look for the `Attributes` section which                appears below the `Subject Public Key Info`                block: 

```
Attributes:
    challengePassword        :342thbjkt82094y0uthhor289jnqthpc2290Copied!
```

### Recommended OIDs for attributes

Custom attributes can use any public or site-specific OID, with the exception of                the OIDs used for core X.509 functionality. This means you can’t re-use                existing OIDs for things like subject alternative names.

One useful OID is the `challengePassword` attribute                    — `1.2.840.113549.1.9.7`. This is a                rarely-used corner of X.509 that can easily be repurposed to hold a pre-shared key.                The benefit of using this instead of an arbitrary OID is that it appears by name                when using OpenSSL to dump the CSR to text; OIDs that `openssl req` can’t recognize are displayed as numerical                strings.

You can also use the [                     Puppet-specific OIDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#puppet_registered_ids). 

## Extension requests (permanent certificate data)

Extension requests are pieces of data that are transferred as extensions to the final        certificate, when the CA signs the CSR. They persist as trusted, immutable data, that cannot        be altered after the certificate is signed.

They can also be used by the CA when deciding whether or not to sign            the certificate.

### Default behavior

When signing a certificate, Puppet’s CA tools transfer                any extension requests into the final certificate.

You can access certificate extensions in manifests as `$trusted["extensions"]["<EXTENSION OID>"]`.

Select OIDs in the ppRegCertExt and ppAuthCertExt ranges. See the [Puppet-specific Registered IDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#puppet_registered_ids). By                default, any other OIDs appear as plain dotted numbers, but you can use the `                    custom_trusted_oid_mapping.yaml                ` file to assign short names to any other OIDs you use at your site. If you                do, those OIDs appear in `$trusted` as their short                names, instead of their full numerical OID.

For more information about `$trusted`, see [Facts and built-in variables](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html).

The visibility of extensions is limited:

- The `puppetserver ca                            list` command does not display custom attributes                            for any pending CSRs, and [basic                                 autosigning (`autosign.conf`)](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_autosign) doesn’t                            check them before signing. Either use [policy-based                                 autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_policy_based_autosigning) or inspect CSRs manually with                                the `openssl` command (see                            below).

​                Puppet’s authorization system (`auth.conf`) does not use certificate extensions, but [                     Puppet Server’s authorization system](https://puppet.com/docs/puppetserver/latest/config_file_auth.html), which is                based on `trapperkeeper-authorization`, can use                extensions in the `ppAuthCertExt` OID range, and                requires them for requests to write access rules.

### Configurable behavior

If you use [policy-based autosigning](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_autosign), your                policy executable receives the complete CSR in `pem`                format. The executable can extract and inspect the extension requests, and use them                when deciding whether to sign the certificate.

### Manually checking for extensions in CSRs and certificates

You can check for extension requests in a CSR by running the OpenSSL command to dump                a CSR in `pem` format to text format:

```
openssl req -noout -text -in <name>.pemCopied!
```

In the output, look for a section called `Requested                    Extensions`, which appears below the `Subject                    Public Key Info` and `Attributes`                blocks:

```
Requested Extensions:
    pp_uuid:
    .$ED803750-E3C7-44F5-BB08-41A04433FE2E
    1.3.6.1.4.1.34380.1.1.3:
    ..my_ami_image
    1.3.6.1.4.1.34380.1.1.4:
    .$342thbjkt82094y0uthhor289jnqthpc2290Copied!
```

Note: Every extension is preceded by any combination of two characters                        (`.$` and `..`                    in the example above) that contain ASN.1 encoding information. Because OpenSSL                    is unaware of Puppet’s custom extensions OIDs,                    it’s unable to properly display the values.

Any Puppet-specific OIDs (see below) appear as numeric                strings when using OpenSSL.

You can check for extensions in a signed certificate by running:

```
/opt/puppetlabs/puppet/bin/openssl x509 -noout -text -in $(puppet config print signeddir)/<certname>.pemCopied!
```

In the output, look for the `X509v3 extensions`                section. Any of the Puppet-specific [registered OIDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#puppet_registered_ids) appear as their                descriptive names:

```
X509v3 extensions:
    Netscape Comment:
        Puppet Ruby/OpenSSL Internal Certificate
    X509v3 Subject Key Identifier:
        47:BC:D5:14:33:F2:ED:85:B9:52:FD:A2:EA:E4:CC:00:7F:7F:19:7E
    Puppet Node UUID:
        ED803750-E3C7-44F5-BB08-41A04433FE2E
    X509v3 Extended Key Usage: critical
        TLS Web Server Authentication, TLS Web Client Authentication
    X509v3 Basic Constraints: critical
        CA:FALSE
    Puppet Node Preshared Key:
        342thbjkt82094y0uthhor289jnqthpc2290
    X509v3 Key Usage: critical
        Digital Signature, Key Encipherment
    Puppet Node Image Name:
        my_ami_imageCopied!
```

### Recommended OIDs for extensions

Extension request OIDs must be under the `ppRegCertExt`                    (`1.3.6.1.4.1.34380.1.1`), `ppPrivCertExt` (`1.3.6.1.4.1.34380.1.2`),                or `ppAuthCertExt` (`1.3.6.1.4.1.34380.1.3`) OID arcs.

Puppet provides several registered OIDs (under `ppRegCertExt`) for the most common kinds of extension information, a                private OID range (`ppPrivCertExt`) for site-specific                extension information, and an OID range for safe authorization to Puppet Server (`ppAuthCertExt`).

There are several benefits to using the registered OIDs:

- You can reference them in the `csr_attributes.yaml` file with their short names instead of                            their numeric IDs.
- You can access them in $`trusted[extensions]` with their short names instead of                            their numeric IDs.
- When using Puppet tools to print certificate info, they appear using                            their descriptive names instead of their numeric IDs.

The private range is available for any information you want to embed into a                certificate that isn’t widely used already. It is completely unregulated, and its                contents are expected to be different in every Puppet                deployment.

You can use the [custom_trusted_oid_mapping.yaml](https://www.puppet.com/docs/puppet/7/config_file_oid_map.html) file to set short                names for any private extension OIDs you use. Note that this enables only the short                names in the `$trusted[extensions]` hash.

### Puppet-specific registered IDs



#### `ppRegCertExt`

The `ppRegCertExt` OID range contains the following                OIDs:

| Numeric ID               | Short name            | Descriptive name                                             |
| ------------------------ | --------------------- | ------------------------------------------------------------ |
| 1.3.6.1.4.1.34380.1.1.1  | `pp_uuid`             | Puppet node UUID                                             |
| 1.3.6.1.4.1.34380.1.1.2  | `pp_instance_id`      | Puppet node instance                                    ID   |
| 1.3.6.1.4.1.34380.1.1.3  | `pp_image_name`       | Puppet node image name                                       |
| 1.3.6.1.4.1.34380.1.1.4  | `pp_preshared_key`    | Puppet node preshared                                    key |
| 1.3.6.1.4.1.34380.1.1.5  | `pp_cost_center`      | Puppet node cost center                                    name |
| 1.3.6.1.4.1.34380.1.1.6  | `pp_product`          | Puppet node product                                    name  |
| 1.3.6.1.4.1.34380.1.1.7  | `pp_project`          | Puppet node project                                    name  |
| 1.3.6.1.4.1.34380.1.1.8  | `pp_application`      | Puppet node application                                    name |
| 1.3.6.1.4.1.34380.1.1.9  | `pp_service`          | Puppet node service                                    name  |
| 1.3.6.1.4.1.34380.1.1.10 | `pp_employee`         | Puppet node employee                                    name |
| 1.3.6.1.4.1.34380.1.1.11 | `pp_created_by`       | Puppet node `created_by` tag                                 |
| 1.3.6.1.4.1.34380.1.1.12 | `pp_environment`      | Puppet node environment                                    name |
| 1.3.6.1.4.1.34380.1.1.13 | `pp_role`             | Puppet node role name                                        |
| 1.3.6.1.4.1.34380.1.1.14 | `pp_software_version` | Puppet node software                                    version |
| 1.3.6.1.4.1.34380.1.1.15 | `pp_department`       | Puppet node department                                    name |
| 1.3.6.1.4.1.34380.1.1.16 | `pp_cluster`          | Puppet node cluster                                    name  |
| 1.3.6.1.4.1.34380.1.1.17 | `pp_provisioner`      | Puppet node provisioner                                    name |
| 1.3.6.1.4.1.34380.1.1.18 | `pp_region`           | Puppet node region                                    name   |
| 1.3.6.1.4.1.34380.1.1.19 | `pp_datacenter`       | Puppet node datacenter                                    name |
| 1.3.6.1.4.1.34380.1.1.20 | `pp_zone`             | Puppet node zone name                                        |
| 1.3.6.1.4.1.34380.1.1.21 | `pp_network`          | Puppet node network                                    name  |
| 1.3.6.1.4.1.34380.1.1.22 | `pp_securitypolicy`   | Puppet node security policy                                    name |
| 1.3.6.1.4.1.34380.1.1.23 | `pp_cloudplatform`    | Puppet node cloud platform                                    name |
| 1.3.6.1.4.1.34380.1.1.24 | `pp_apptier`          | Puppet node application                                    tier |
| 1.3.6.1.4.1.34380.1.1.25 | `pp_hostname`         | Puppet node hostname                                         |

#### `ppAuthCertExt`

The `ppAuthCertExt` OID range contains the following OIDs:

| Numeric ID               | Short name         | Descriptive name                                             |
| ------------------------ | ------------------ | ------------------------------------------------------------ |
| 1.3.6.1.4.1.34380.1.3.1  | `pp_authorization` | Certificate extension authorization                          |
| 1.3.6.1.4.1.34380.1.3.13 | `pp_auth_role`     | Puppet node role name for                                    authorization. For PE internal use only. |

## Cloud provider attributes and extensions population        example

To populate the `csr_attributes.yaml` file when you provision a node, use        an automated script such as cloud-init.

For example, when provisioning a new node from the AWS EC2 dashboard, enter the following script into the                Configure Instance Details —>                Advanced Details section:

```
#!/bin/sh
if [ ! -d /etc/puppetlabs/puppet ]; then
   mkdir /etc/puppetlabs/puppet
fi
cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
custom_attributes:
    1.2.840.113549.1.9.7: mySuperAwesomePassword
extension_requests:
    pp_instance_id: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    pp_image_name:  $(curl -s http://169.254.169.254/latest/meta-data/ami-id)
YAMLCopied!
```

This populates the attributes file with the AWS instance ID, image name, and a pre-shared key to use            with policy-based autosigning.

## Troubleshooting



### Recovering from failed data embedding

When testing this feature for the first time, you might not embed the right                information in a CSR, or certificate, and might want to start over for your test                nodes. This is not really a problem after your provisioning system is changed to                populate the data, but it can easily happen when doing things manually.

To start over, do the following.

On the test node: 

- Turn off Puppet agent, if it’s running.                        
- If using Puppet version 6.0.3 or greater,                            run `puppet ssl clean`. If not, delete the                            following files:
  - ​                                    `$ssldir/certificate_requests/<name>.pem`                                
  - ​                                    ` $ssldir/certs/<name>.pem `                                

On the CA primary Puppet server: 

- Check whether a signed certificate exists. Use `puppetserver ca list --all` to see the                            complete list. If it exists, revoke and delete it with `puppetserver ca clean --certname                                <name>`. 

After you’ve done that, you can start over.

# Regenerating certificates in a Puppet deployment

### Sections

[Regenerate the agent certificate of your Puppet primary server and add DNS alt-names or other certificate         extensions](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#regenerate_agent_certs_and_add_dns_alt_names)

[Regenerate the CA and all certificates](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#regenerate_ca_and_all_certificates)

- [Step 1: Clear and regenerate certs on your primary Puppet server](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#clear_regenerate_certs_on_primary_server)
- [Step 2: Clear and regenerate certs for any                                 extension](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#clear_regenerate_certs_for_extensions)
- [Step 3: Clear and regenerate certs for Puppet agents](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#clear_regenerate_certs_for_agents)

In some cases, you might need to regenerate the        certificates and security credentials (private and public keys) that are generated by Puppet’s built-in PKI systems.

For example, you might have a Puppet            primary server you need to move to a different network in your infrastructure, or you might have            experienced a security vulnerability that makes existing credentials untrustworthy.

Tip: There are other, more automated ways of doing this. We recommend using                    Bolt to regenerate certs when needed. See the                    [Bolt documentation](https://puppet.com/docs/bolt/latest/bolt.html) for more information. There is also a                supported [ca_extend](https://forge.puppet.com/modules/puppetlabs/ca_extend) module, which you can use to                extend the expiry date of a certificate authority (CA).

Important: The information on this page describes the                steps for regenerating certs in an open source Puppet                deployment. If you use Puppet Enterprise do not use                the information on this page, as it leaves you with an incomplete replacement and                non-functional deployment. Instead, PE customers                must refer to one of the following pages: 

- ​                            [Regenerating certificatesPE deployments](https://puppet.com/docs/pe/latest/regenerate_certificates.html)                        

| **If your goal is to...**                                    | **Do this...**                                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Regenerate an agent’s certificate                            | [Clear and                                         regenerate certs for Puppet                                         agents](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#clear_regenerate_certs_for_agents) |
| Fix a compromised or damaged certificate                                authority | [Regenerate                                         the CA and all certificates](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#regenerate_ca_and_all_certificates) |
| Completely regenerate all Puppet deployment                                certificates | [Regenerate                                         the CA and all certificates](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#regenerate_ca_and_all_certificates) |
| Add DNS alt-names or other certificate                                extensions to your existing Puppet                                primary server | [Regenerate the agent certificate of your Puppet primary server and add DNS                                     alt-names or other certificates](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#regenerate_agent_certs_and_add_dns_alt_names) |

## Regenerate the agent certificate of your Puppet primary server and add DNS alt-names or other certificate        extensions

This option preserves the primary server/agent relationship and        lets you add DNS alt-names or certificate extensions to your existing primary server.

1.  Revoke the Puppet                    primary server’s certificate and clean the CA files pertaining to it. Note that the                    agents won’t be able to connect to the primary server until all of the following steps                    are finished.

   ```
   puppetserver ca clean --certname <CERTNAME_OF_YOUR_SERVER>Copied!
   ```

2. Remove the agent-specific copy of the public key,                    private key, and certificate-signing request  pertaining to the                    certificate:

   ```
   puppet ssl cleanCopied!
   ```

3. Stop the Puppet                    primary server service:

   ```
   puppet resource service puppetserver ensure=stoppedCopied!
   ```

   Note: The CA and server run in the same                                primary server so this also stops the CA.

4. After you’ve stopped the primary server and CA service,                    create a certificate signed by the CA and add DNS alt names (comma                    separated):

   ```
    puppetserver ca generate --certname <CERTNAME> --subject-alt-names <DNS ALT NAMES> --ca-clientCopied!
   ```

   Note:

   - If you don’t want to add DNS alt names to your primary server, omit                                the `--subject-alt-names <DNS ALT                                    NAMES>` option from the command above.
   - Although this particular use of the `generate`                                command requires you to stop `puppetserver` service,                                all other uses of this command require the service to be                                running.
   - If the tool cannot determine the status of the server, but you know                                the server is offline, you can use the `--force` option to run the command without checking                                server status.

5. Restart the Puppet                    primary server service:

   ```
   puppet resource service puppetserver ensure=runningCopied!
   ```

## Regenerate the CA and all certificates

CAUTION: This process destroys the certificate authority and                    all other certificates. It is meant for use in the event of a total compromise                    of your site, or some other unusual circumstance. If you want to preserve the                    primary server/agent relationship, [regenerate the                         agent certificate of your Puppet                         primary server](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#regenerate_agent_certs_and_add_dns_alt_names). If you just need to replace a few agent certificates, [clear                         and regenerate certs for Puppet                     agents](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#clear_regenerate_certs_for_agents).

### Step 1: Clear and regenerate certs on your primary Puppet server



On the primary server hosting the CA:

1. ​                Back up the [SSL                     directory](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html), which is in `/etc/puppetlabs/puppet/ssl/`. If something goes                    wrong, you can restore this directory so your deployment can stay functional.                    However, if you needed to regenerate your certs for security reasons and                    couldn’t, get some assistance as soon as possible so you can keep your site                    secure.            

2. Stop the agent service:

   ```
   sudo puppet resource service puppet ensure=stopped
   Copied!
   ```

3. Stop the primary server service.

   For Puppet Server, run:                        

   ```
   sudo puppet resource service puppetserver ensure=stoppedCopied!
   ```

4. Delete the SSL directory:

   ```
   sudo rm -r /etc/puppetlabs/puppet/sslCopied!
   ```

5. Regenerate the CA and primary server's cert:

   ```
   sudo puppetserver ca setupCopied!
   ```

   You will see this message: `Notice: Signed                            certificate request for ca`.

6. Start the primary server  service by running: 

   ```
   sudo puppet resource service puppetserver ensure=runningCopied!
   ```

7. Start the Puppet                    agent service by running this command:

   ```
   sudo puppet resource service puppet ensure=running
   Copied!
   ```

Results

At this point: 

- You have a new CA certificate and                            key.
- Your primary server has a certificate from the new CA, and it can field new certificate requests. 
- The primary server  rejects any requests for configuration catalogs from nodes that haven’t                            replaced their certificates. At this point, it is all of them except                            itself. 
- When using any extensions that rely on Puppet certificates, like                                PuppetDB, the primary server won’t be                            able to communicate with them. Consequently, it might not be able to                            serve catalogs, even to agents that do have new certificates. 

### Step 2: Clear and regenerate certs for any                                extension

You might be using an extension, like PuppetDB or MCollective, to enhance Puppet. These extensions probably use certificates from Puppet’s CA in order to communicate securely with the primary Puppet server. For each extension like this, you’ll need to    regenerate the certificates it uses. 

Many tools have scripts or documentation to                                                help you set up SSL, and you can often just re-run                                                the setup instructions.

####         PuppetDB      

We recommend PuppetDB users first follow the instructions in        Step 3: Clear and regenerate certs for agents, below, because PuppetDB re-uses Puppet agents’        certificates. After that, restart the PuppetDB service. See          [Redo SSL setup after changing certificates](https://puppet.com/docs/puppetdb/latest/maintain_and_tune.html) for more information.      

### Step 3: Clear and regenerate certs for Puppet agents

To replace the certs on agents, you’ll need to                                log into each agent node and do the following steps.

1. Stop the agent                                                  service. On *nix:

   ```
   sudo puppet resource service puppet ensure=stoppedCopied!
   ```

   On                                                  Windows, with                                                  Administrator                                                  privileges: 

   ```
   puppet resource service puppet ensure=stoppedCopied!
   ```

2. Locate Puppet’s [SSL                                                   directory](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html) and delete its                                                  contents.

   The SSL directory can be                                                  determined by running `puppet config print                                                  ssldir --section agent`                                                  

3. Restart the                                                  agent service. On *nix:

   ```
   sudo puppet resource service puppet ensure=runningCopied!
   ```

   On                                                  Windows, with                                                  Administrator                                                  privileges:

   ```
   puppet resource service puppet ensure=runningCopied!
   ```

   When the agent starts, it generates keys and requests a new certificate from the CA primary            server.

4. If you are not using autosigning, log in to the CA primary server and sign each agent          node’s certificate request.

   To view pending requests,            run:

   ```
   sudo puppetserver ca listCopied!
   ```

   To sign requests,            run:

   ```
   sudo puppetserver ca sign --certname <NAME>Copied!
   ```

   After an agent node’s new certificate is signed, it's retrieved within a few minutes            and a Puppet run starts.

Results

After you have regenerated all agents’                                                  certificates, everything will be fully functional                                                  under the new CA.

Note: You can                                                  achieve the same results by turning these steps                                                  into Bolt tasks or                                                  plans. See the [Bolt documentation](https://puppet.com/docs/bolt/latest/bolt.html) for                                                  more information.

# External CA

### Sections

[Supported external CA configurations](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#external-ca-supported-configurations)

[Option 1: Puppet Server functioning as an         intermediate CA](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#intermediate_ca)

[Option 2: Single CA](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#single_ca)

- [ Puppet Server    ](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#config_puppet_server)
- [ Puppet agent](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#config_puppet_agent)

[General notes and requirements](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#config_general_notes)

- [PEM encoding of credentials is mandatory](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#PEM-encode-credentials)
- [Normal Puppet certificate requirements still                 apply](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#normal-certificate-requirements)
- [Client DN authentication ](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#client-DN-authentication)
- [Web server configuration](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#web-server-configuration)
- [Restart required ](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#restart)

Expand

This information describes the supported and tested        configurations for external CAs in this version of Puppet. If        you have an external CA use case that isn’t listed here, contact Puppet so we can learn more about it.

## Supported external CA configurations

This version of Puppet                supports some external CA configurations, however not every possible                configuration is supported. 

We fully support the following setup options:

- Single CA which directly issues SSL certificates.
- ​                            Puppet Server functioning as an intermediate                            CA.

Fully supported by Puppet means:

- If issues arise that are considered bugs, we'll fix them as soon as                            possible. 
- If issues arise in any other external CA setup that are                            considered feature requests, we’ll consider whether to expand                            our support.

## Option 1: Puppet Server functioning as an        intermediate CA

​        Puppet Server can operate as an intermediate CA to an external root        CA.

See [Using Puppet Server as an intermediate                 certificate authority](https://puppet.com/docs/puppetserver/latest/intermediate_ca.html).

## Option 2: Single CA

When Puppet uses its        internal CA, it defaults to a single CA configuration. A single externally issued CA can        also be used in a similar manner.


![img](https://www.puppet.com/docs/puppet/7/single_ca.png)

This is an all or nothing configuration rather than a mix-and-match.            When using an external CA, the built-in Puppet CA            service must be disabled and cannot be used to issue SSL certificates.

Note:                 Puppet cannot automatically distribute certificates                in this configuration.

### Puppet Server   



Configure Puppet Server in three steps: 

- Disable the internal CA service.
- Ensure that the certname does not change.
- Put certificates and keys in place on disk.

1. Edit the Puppet Server`/etc/puppetlabs/puppetserver/services.d/ca.cfg` file:

   1. ​                  To disable the internal CA, comment out                        `puppetlabs.services.ca.certificate-authority-service/certificate-authority-service`                     and uncomment                        `puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service`.               

2. Set a static value for the `certname` setting in `puppet.conf`:

   ```
   [server]
   certname = puppetserver.example.com
   Copied!
   ```

   Setting                  a static value prevents any confusion if the machine's hostname changes. The value                  must match the certname you’ll use to issue the server's certificate, and it must                  not be blank.

3. Put the credentials from your external CA on disk in               the correct locations. These locations must match what’s configured in                  your [`webserver.conf`                   file](https://puppet.com/docs/puppetserver/latest/config_file_webserver.html). 

   If you haven’t changed those settings, run the following                  commands to find the default locations. 

   | Credential                                                   | File location                                                |
   | ------------------------------------------------------------ | ------------------------------------------------------------ |
   | Server SSL certificate                                       | `puppet config print hostcert --section                                    server` |
   | Server SSL certificate private                                 key | `puppet config print hostprivkey --section                                    server` |
   | Root CA certificate                                          | `puppet config print localcacert --section                                    server` |
   | Root certificate revocation list                             | `puppet config print hostcrl --section                                    server` |

   If you’ve put the credentials in the correct locations, you                  don't need to change any additional settings.

### Puppet agent

You don’t need to change any settings. Put the external        credentials into the correct filesystem locations. You can run the following commands to        find the appropriate locations.

| Credential                        | File location                                                |
| --------------------------------- | ------------------------------------------------------------ |
| Agent SSL certificate             | `puppet config print hostcert --section                            agent` |
| Agent SSL certificate private key | `puppet config print hostprivkey --section                                agent` |
| Root CA certificate               | `puppet config print localcacert --section                                agent` |
| Root certificate revocation list  | `puppet config print hostcrl --section                            agent` |

## General notes and requirements



### PEM encoding of credentials is mandatory

​                Puppet expects its SSL credentials to be                    in `.pem` format.

### Normal Puppet certificate requirements still                apply

Any Puppet Server certificate must contain the DNS name,                either as the Subject Common Name (CN) or as a Subject Alternative Name (SAN), that                agent nodes use to attempt contact with the server.

### Client DN authentication 

​                Puppet Server is hosted by a Jetty web server; therefore.                For client authentication purposes, Puppet Server can                extract the distinguished name (DN) from a client certificate provided during SSL                negotiation with the Jetty web server.

The use of an `X-Client-DN` request header is supported                for cases where SSL termination of client requests needs to be done on an external                server. See [External SSL Termination with Puppet Server](https://puppet.com/docs/puppetserver/latest/external_ssl_termination.html) for                details.

### Web server configuration

Use the [`webserver.conf`](https://puppet.com/docs/puppetserver/latest/config_file_webserver.html) file for                    Puppet Server to configure Jetty. Several `ssl-` settings can be added to the webserver.conf file to                enable the web server to use the correct SSL configuration:

- ​                        `ssl-cert`: The value of `puppet server --configprint hostcert`. Equivalent                        to the ‘SSLCertificateFile’ Apache config setting.
- ​                        `ssl-key`: The value of `puppet server --configprint hostprivkey`. Equivalent to the                        ‘SSLCertificateKeyFile’ Apache config setting.
- ​                        `ssl-ca-cert`: The value of `puppet server --configprint localcacert`.                        Equivalent to the ‘SSLCACertificateFile’ Apache config setting.
- ​                        `ssl-cert-chain`: Equivalent to the                        ‘SSLCertificateChainFile’ Apache config setting. Optional.
- ​                        `ssl-crl-path`: The path to the CRL file to                        use. Optional.

An example `webserver.conf` file might look something                like this: 

```
webserver: { 
 client-auth : want  
 ssl-host    : 0.0.0.0  
 ssl-port    : 8140  
 ssl-cert    : /path/to/server.pem  
 ssl-key     : /path/to/server.key  
 ssl-ca-cert : /path/to/ca_bundle.pem  
 ssl-cert-chain : /path/to/ca_bundle.pem  
 ssl-crl-path : /etc/puppetlabs/puppet/ssl/crl.pem
}Copied!
```

For more information on these settings, see[Configuring the Web Server Service](https://github.com/puppetlabs/trapperkeeper-webserver-jetty9/blob/master/doc/jetty-config.md). 

### Restart required 

After the above changes are made to Puppet Server’s                configuration files, you’ll have to restart the Puppet Server service for the new settings to take effect.

# External SSL termination

### Sections

[Disable HTTPS for Puppet Server](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#disable-https-for-puppet-server)

[Allow Client Cert Data From HTTP Headers](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#allow-client-cert-data-from-http-headers)

[Reload Puppet Server](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#reload-puppet-server)

[Configure SSL Terminating Proxy to Set HTTP Headers](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#configure-ssl-terminating-proxy-to-set-http-headers)

- [`X-Client-Verify`](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#x-client-verify)
- [`X-Client-DN`](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#x-client-dn)
- [`X-Client-Cert`](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#x-client-cert)

Use the following steps to configure external SSL termination.

## Disable HTTPS for Puppet Server

You'll need to turn off SSL and have Puppet Server use the HTTP protocol instead: remove the `ssl-port` and `ssl-host` settings from the `conf.d/webserver.conf` file and replace them with `port` and `host` settings. See [Configuring the Webserver Service](https://github.com/puppetlabs/trapperkeeper-webserver-jetty9/blob/master/doc/jetty-config.md) for more information on configuring the web server service.

## Allow Client Cert Data From HTTP Headers

When using external SSL termination, Puppet Server expects to receive client certificate information via some HTTP headers.

By default, reading this data from headers is disabled.  To allow Puppet Server to recognize it, you'll need to set `allow-header-cert-info: true` in the `authorization` config section of the `/etc/puppetlabs/puppetserver/conf.d/auth.conf` file.

See [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html) for more information on the `puppetserver.conf` and `auth.conf` files.

Note: This assumes the default behavior of Puppet 5 and greater of using Puppet Server's hocon auth.conf rather Puppet's older ini-style auth.conf.

> **WARNING**: Setting `allow-header-cert-info` to 'true' puts Puppet Server in an incredibly vulnerable state. Take extra caution to ensure it is **absolutely not reachable** by an untrusted network.
>
> With `allow-header-cert-info`  set to 'true', authorization code will use only the client HTTP header  values---not an SSL-layer client certificate---to determine the client  subject name, authentication status, and trusted facts. This is true  even if the web server is hosting an HTTPS connection. This applies to  validation of the client via rules in the [auth.conf](https://puppet.com/docs/puppet/latest/config_file_auth.html) file and any [trusted facts](https://puppet.com/docs/puppet/latest/lang_facts_and_builtin_vars.html#trusted-facts) extracted from certificate extensions.
>
> If the `client-auth` setting in the `webserver` config block is set to `need` or `want`, the Jetty web server will still validate the client certificate against a certificate authority store, but it will only verify the SSL-layer  client certificate---not a certificate in an  `X-Client-Cert` header.

## Reload Puppet Server

You'll need to reload Puppet Server for the configuration changes to take effect.

## Configure SSL Terminating Proxy to Set HTTP Headers

The device that terminates SSL for Puppet Server must  extract information from the client's certificate and insert that  information into three HTTP headers. See the documentation for your SSL  terminator for details.

The headers you'll need to set are `X-Client-Verify`, `X-Client-DN`, and `X-Client-Cert`.

### `X-Client-Verify`

Mandatory. Must be either `SUCCESS` if the certificate was validated, or something else if not. (The convention seems to be to use `NONE` for when a certificate wasn't presented, and `FAILED:reason` for other validation failures.) Puppet Server uses this to authorize requests; only requests with a value of `SUCCESS` will be considered authenticated.

### `X-Client-DN`

Mandatory. Must be the [Subject DN](https://docs.puppet.com/background/ssl/cert_anatomy.html#the-subject-dn-cn-certname-etc) of the agent's certificate, if a certificate was presented. Puppet Server uses this to authorize requests.

### `X-Client-Cert`

Optional. Should contain the client's [PEM-formatted](https://docs.puppet.com/background/ssl/cert_anatomy.html#pem-file) (Base-64) certificate (if a certificate was presented) in a single URI-encoded string. Note that URL encoding is not sufficient; all space characters must be encoded as `%20` and not `+` characters.

> **Note:** Puppet Server only uses the value of this header to extract [trusted facts](https://puppet.com/docs/puppet/latest/lang_facts_and_builtin_vars.html#trusted-facts) from extensions in the client certificate. If you aren't using trusted  facts, you can choose to reduce the size of the request payload by  omitting the `X-Client-Cert` header.

> **Note:** Apache's `mod_proxy` converts line breaks in PEM documents to spaces for some reason, and  Puppet Server can't decode the result. We're tracking this issue as [SERVER-217](https://tickets.puppetlabs.com/browse/SERVER-217).

# Puppet services and tools

Puppet provides a number of core services and        administrative tools to manage systems with or without  a primary Puppet server, and to compile configurations for Puppet agents. 



**[Puppet commands](https://www.puppet.com/docs/puppet/7/services_commands.html#services_commands)**
Puppet’s command line         interface (CLI) consists of a single `puppet` command with many subcommands. **[Running Puppet commands on Windows](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#services_commands_windows)**
         Puppet was originally designed to run on *nix systems, so its commands generally act the way *nix admins expect. Because Windows systems work differently, there are a few extra         things to keep in mind when using Puppet         commands. **[Puppet agent on \*nix systems](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#services_agent_unix)**
Puppet agent is the         application that manages the configurations on your nodes. It requires a Puppet primary server to fetch configuration catalogs         from. **[Puppet agent on Windows](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#services_agent_windows)**
Puppet agent is the application that manages         configurations on your nodes. It requires a Puppet primary         server to fetch configuration catalogs. **[Puppet apply](https://www.puppet.com/docs/puppet/7/services_apply.html#services_apply)**
Puppet apply is an         application that compiles and manages  configurations on nodes. It acts like a self-contained          combination of the Puppet primary server and Puppet agent applications.  **[Puppet device](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device)**
With Puppet device, you can         manage network devices, such as routers,  switches, firewalls, and Internet of Things (IOT)         devices,  without installing a Puppet agent on them. Devices         that cannot run Puppet applications require a Puppet agent to act as a proxy. The proxy manages         certificates,  collects facts, retrieves and applies catalogs, and stores reports on  behalf         of a device.

# Puppet commands

### Sections

[ Puppet agent](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-agent)

[                 Puppet Server             ](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-server)

[ Puppet apply](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-apply)

[ Puppet ssl](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-ssl)

[ Puppet module](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-module)

[ Puppet resource](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-resource)

[ Puppet config](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-config)

[ Puppet parser](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-parser)

[ Puppet help and Puppet man](https://www.puppet.com/docs/puppet/7/services_commands.html#commands-puppet-help)

[Full list of subcommands](https://www.puppet.com/docs/puppet/7/services_commands.html#full-list-subcommands)

Puppet’s command line        interface (CLI) consists of a single `puppet` command with many subcommands.

Puppet Server and Puppet’s companion utilities  [                 Facter             ](https://puppet.com/docs/facter/3.11/index.html) and  [                 Hiera             ](https://www.puppet.com/docs/puppet/7/hiera.html), have their own CLI.

## Puppet agent

Puppet agent is a core service that                manages systems, with the help of a Puppet primary server. It                requests a configuration catalog from a Puppet primary server                server, then ensures that all resources in that catalog are in their desired                state.

For more information, see: 

- ​                            [                                 Overview of Puppet’s architecture ](https://www.puppet.com/docs/puppet/7/architecture.html)                        
- ​                            Puppet                            [ Agent on                                     *nix systems ](https://www.puppet.com/docs/puppet/7/services_agent_unix.html#services_agent_unix)                        
- ​                            Puppet                            [ Agent on                                     Windows systems ](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#services_agent_windows)                        
- ​                            Puppet                            [ Agent’s man page](https://www.puppet.com/docs/puppet/7/man/agent.html)                        

##                 Puppet Server            

Using Puppet code and various other                data sources, Puppet Server compiles configurations for any                number of Puppet agents.

Puppet Server is a core service and has                its own subcommand, `puppetserver`, which isn’t prefaced by the usual `puppet` subcommand.

For more information, see: 

- ​                            [                                 Overview of Puppet’s architecture ](https://www.puppet.com/docs/puppet/7/architecture.html)                        
- ​                            [                                 Puppet Server                             ](https://puppet.com/docs/puppetserver/latest/services_master_puppetserver.html)                        
- ​                            [Puppet Server subcommands                             ](https://puppet.com/docs/puppetserver/latest/subcommands.html)                        

## Puppet apply

Puppet apply is a core command that                manages systems without contacting a Puppet primary                server. Using Puppet modules and various other data                sources, it compiles its own configuration catalog, and then immediately applies the                catalog.

For more information, see: 

- ​                            [                                 Overview of Puppet’s architecture ](https://www.puppet.com/docs/puppet/7/architecture.html)                        
- ​                            [Puppet                                 apply](https://www.puppet.com/docs/puppet/7/services_apply.html#services_apply)                        
- ​                            [Puppet apply’s man page](https://www.puppet.com/docs/puppet/7/man/apply.html)                        

## Puppet ssl

Puppet ssl is a command for                managing SSL keys and certificates for Puppet SSL                clients needing to communicate with your Puppetinfrastructure. 

Puppet ssl usage: `puppet ssl <action> [--certname <name>]`

Possible actions:

- `submit request`: Generate a certificate signing request                            (CSR) and submit it to the CA. If a private and public key pair already                            exist, they are used to generate the CSR. Otherwise, a new key pair is                            generated. If a CSR has already been submitted with the given `certname,`                            then the operation fails.
- `download_cert`: Download a certificate for this host. If                            the current private key matches the downloaded certificate, then the                            certificate is saved and used for subsequent requests. If there is                            already an existing certificate, it is overwritten.
- `verify`: Verify that the private key and                            certificate are present and match. Verify the certificate is issued                            by a trusted CA, and check the revocation status
- `bootstrap`: Perform all of the steps necessary to request and                        download a client certificate. If autosigning is disabled, then puppet will                        wait every `waitforcert`                        seconds for its certificate to be signed. To only attempt once and never                        wait, specify a time of 0. Since `waitforcert` is a Puppet setting, it can be specified as a time                        interval, such as 30s, 5m, 1h.

For more information, see the [SSL man page](https://www.puppet.com/docs/puppet/7/man/ssl.html). 

## Puppet module

Puppet module is a multi-purpose                administrative tool for working with Puppet modules.                It can install and upgrade new modules from the Puppet[ Forge](https://forge.puppetlabs.com/), help generate new modules, and package modules                for public release.

For more information, see: 

- ​                            [                                 Module fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals)                        
- ​                            [                                 Installing modules](https://www.puppet.com/docs/puppet/7/modules_installing.html#modules_installing)                        
- ​                            [                                 Publishing modules on the Puppet Forge ](https://www.puppet.com/docs/puppet/7/modules_publishing.html#modules_publishing)                        
- ​                            Puppet                            [                                 Module’s man page](https://www.puppet.com/docs/puppet/7/man/module.html)                        

## Puppet resource

Puppet resource is an                administrative tool that lets you inspect and manipulate resources on a system. It                can work with any resource type Puppet knows about.                For more information, see Puppet[ Resource’s man page](https://www.puppet.com/docs/puppet/7/man/resource.html).

## Puppet config

Puppet config is an administrative                tool that lets you view and change Puppet                settings.

For more information, see: 

- ​                            [                                 About Puppet’s                                 settings ](https://www.puppet.com/docs/puppet/7/config_about_settings.html#config_about_settings)                        
- ​                            [                                 Checking values of settings](https://www.puppet.com/docs/puppet/7/config_print.html)                        
- ​                            [                                 Editing settings on the command line](https://www.puppet.com/docs/puppet/7/config_set.html)                        
- ​                            [                                 Short list of important settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings)                        
- ​                            Puppet                            [ Config’s man page](https://www.puppet.com/docs/puppet/7/man/config.html)                        

## Puppet parser

Puppet parser lets you validate Puppet code to make sure it contains no syntax                errors. It can be a useful part of your continuous integration toolchain. For more                information, see Puppet[ Parser’s man page](https://www.puppet.com/docs/puppet/7/man/parser.html).

## Puppet help and Puppet man

Puppet help and Puppet man can display online help for Puppet’s other subcommands.

For more information, see: 

- ​                            [Puppet help’s man                                 page ](https://www.puppet.com/docs/puppet/7/man/help.html)                        

## Full list of subcommands

For a full list of Puppet subcommands, see [Puppet’s                     subcommands](https://www.puppet.com/docs/puppet/7/man/overview.html).

# Running Puppet commands on Windows    

### Sections

[Supported commands](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#supported-commands)

[Running Puppet's commands](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#running-commands)

[Running with administrator                 privileges](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#running-administrator-privileges)

[The Puppet Start menu items](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#start_menu_items)

[Configuration settings](https://www.puppet.com/docs/puppet/7/services_commands_windows.html#config_settings)

​        Puppet was originally designed to run on *nix systems, so its commands generally act the way *nix admins expect. Because Windows systems work differently, there are a few extra        things to keep in mind when using Puppet        commands.

## Supported commands

Not all Puppet commands work on Windows. Notably, Windows nodes can’t run the `puppet server` or `puppetserver ca`                commands.

The following commands are designed for use on Windows: 

- ​                        [                                 `puppet                                     agent`                             ](https://www.puppet.com/docs/puppet/7/man/agent.html)                        
- ​                        [                                 `puppet                                     apply`                             ](https://www.puppet.com/docs/puppet/7/man/apply.html)                        
- ​                        [                                 `puppet                                     module`                             ](https://www.puppet.com/docs/puppet/7/man/module.html)                        
- ​                        [                                 `puppet                                     resource`                             ](https://www.puppet.com/docs/puppet/7/man/resource.html)                        
- ​                        [                                 `puppet                                     config`                             ](https://www.puppet.com/docs/puppet/7/man/config.html)                        
- ​                        [                                 `puppet                                     lookup`                             ](https://www.puppet.com/docs/puppet/7/man/lookup.html)                        
- ​                        [                                 `puppet                                     help`                             ](https://www.puppet.com/docs/puppet/7/man/help.html)                        

## Running Puppet's commands

The                installer adds Puppet commands to the PATH. After                installing, you can run them from any command prompt                (cmd.exe) or PowerShell prompt.

Open a new                command prompt after installing. Any processes that were already running before you                ran the installer do not pick up the changed PATH value.

## Running with administrator                privileges

You usually want to run Puppet’s commands with administrator                privileges.

Puppet has two privilege modes: 

- Run with limited privileges, only                            manage certain resource types, and use a user-specific  [                                 `confdir`                             ](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and  [ codedir ](https://www.puppet.com/docs/puppet/7/dirs_codedir.html)                        
- Run with administrator privileges,                            manage the whole system, and use the system  [                                 `confdir`                             ](https://www.puppet.com/docs/puppet/7/dirs_confdir.html)and  [                                 codedir ](https://www.puppet.com/docs/puppet/7/dirs_codedir.html)                        

On *nix systems, Puppet defaults to running with limited privileges,                when not run by `root`, but can have its privileges raised with the                standard sudo command.

​                Windows systems don’t use sudo, so escalating                privileges works differently.

Newer versions of Windows manage security with User Account Control                (UAC), which was added in Windows 2008 and Windows Vista. With UAC, most programs run by                administrators still have limited privileges. To get administrator privileges, the                process has to request those privileges when it starts.

To                run Puppet's commands in adminstrator mode, you must                first start a Powershell command prompt with administrator privileges.

Right-click the Start (or apps screen tile) -> Run as administrator: 
![img](https://www.puppet.com/docs/puppet/7/run_as_admin.png)
            

Click Yes to allow the command prompt to run with elevated privaleges:                    
![img](https://www.puppet.com/docs/puppet/7/uac.png)
            

The title bar on the comand prompt window begins with                    Administrator. This                means Puppet commands that run from that window can                manage the whole system. 
![img](https://www.puppet.com/docs/puppet/7/windows_administrator_prompt.png)
            

## The Puppet Start menu items

​        Puppet’s installer adds a folder of shortcut items to the            Start Menu.

​            
![img](https://www.puppet.com/docs/puppet/7/start_menu.png)
​        

These items aren’t necessary for working with Puppet, because Puppet            agent runs a normal  [Windows service](https://www.puppet.com/docs/puppet/7/services_agent_windows.html#services_agent_windows) and the Puppet commands            work from any command or PowerShell prompt. They’re provided solely as conveniences. 

The Start            menu items do the following: 

- Run Facter                    

  This shortcut requests UAC elevation and, using the CLI,                        runs  [Facter](https://puppet.com/docs/facter/) with administrator privileges. 

- Run Puppet agent

  This shortcut requests UAC elevation and, using the CLI,                        performs a single Puppet agent command with                        administrator privileges.

- Start Command Prompt with Puppet                    

  This shortcut starts a normal command prompt with the                        working directory set to Puppet's program                        directory. The CLI window icon is also set to the Puppet logo. This shortcut was particularly                        useful in previous versions of Puppet, before                            Puppet's commands were added to the PATH                        at installation time.  Note: This                            shortcut does not automatically request UAC elevation; just                            like with a normal command prompt, you'll need to right-click the icon                            and choose Run as                                administrator.                    

## Configuration settings

Configuration settings can be viewed and modified using        the CLI.

To get configuration settings, run: `puppet agent --configprint <SETTING>`

To set configuration settings, run: `puppet config set <SETTING VALUE> --section                <SECTION`>

When running Puppet commands on Windows, note the following:

- The location of `puppet.conf` depends                        on whether the process is running as an administrator or not.
- Specifying file owner, group, or mode                        for file-based settings is not supported on Windows.
- The `puppet.conf` configuration                        file supports Windows-style CRLF line endings                        as well as *nix-style LF line endings. It does                        not support Byte Order Mark (BOM). The file encoding must either be UTF-8 or                        the current Windows encoding, for example,                            Windows-1252 code page.
- Common configuration settings                            are `certname`, `server`, and `runinterval`.
- You must restart the Puppet agent service after making any changes                        to Puppet’s `runinterval` config file                        setting.

# Puppet apply

### Sections

[Supported                 platforms](https://www.puppet.com/docs/puppet/7/services_apply.html#supported-platforms)

[ Puppet apply's run environment](https://www.puppet.com/docs/puppet/7/services_apply.html#puppet_apply_run_env)

- [Main manifest](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-manifest)
- [User](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-user)
- [Network access](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-network-access)
- [Logging](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-logging)
- [Reporting](https://www.puppet.com/docs/puppet/7/services_apply.html#apply-run-environment-reporting)

[Managing systems with Puppet apply](https://www.puppet.com/docs/puppet/7/services_apply.html#manage_systems_with_puppet_apply)

[Configuring Puppet apply](https://www.puppet.com/docs/puppet/7/services_apply.html#configure_puppet_apply)

Puppet apply is an        application that compiles and manages configurations on nodes. It acts like a self-contained        combination of the Puppet primary server and Puppet agent applications. 

For details about invoking the `puppet apply` command, see the [puppet apply man page](https://www.puppet.com/docs/puppet/7/man/apply.html).

## Supported                platforms

Puppet apply                runs similarly on *nix and Windows systems. Not all operating systems can manage                the same resources with Puppet; some resource types                are OS-specific, and others have OS-specific features. For more information, see                    the [resource type reference](https://www.puppet.com/docs/puppet/7/type.html).

## Puppet apply's run environment

Unlike Puppet agent, Puppet apply never runs as a daemon or service. It runs as a        single task in the foreground, which compiles a catalog, applies it, files a report, and        exits.

By default, it never initiates outbound network connections, although it can be            configured to do so, and it never accepts inbound network connections.

### Main manifest

Like the primary                    Puppet server application, Puppet apply uses its [settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings) (such as `basemodulepath`) and the configured [environments](https://www.puppet.com/docs/puppet/7/environments_about.html#environments_about) to locate the Puppet code and configuration data it uses when                compiling a catalog.

The one exception is the [main manifest](https://www.puppet.com/docs/puppet/7/dirs_manifest.html). Puppet apply always requires a single command line                argument, which acts as its main manifest. It ignores the main manifest from                its environment.

Alternatively, you can write a main manifest directly                using the command line, with the `-e` option. For more information, see the [puppet apply man page](https://www.puppet.com/docs/puppet/7/man/apply.html).

### User

​                Puppet apply runs as whichever user executed the Puppet apply command.

To manage a complete                system, run Puppet apply as:

- ​                            `root` on *nix systems.
- Either `LocalService` or a member of                                the `Administrators` group                            on Windows systems.

​                Puppet apply can also run as a non-root user. When                running without root permissions, most of Puppet’s                resource providers cannot use `sudo` to                elevate permissions. This means Puppet can only                manage resources that its user can modify without using `sudo`.

Of the core resource types listed in the [resource type reference](https://www.puppet.com/docs/puppet/7/type.html), the following                are available to non-root agents:

| Resource type        | Details                                                      |
| -------------------- | ------------------------------------------------------------ |
| `augeas`             |                                                              |
| `cron`               | Only non-root cron jobs can be viewed or set.                |
| `exec`               | Cannot run as another user or group.                         |
| `file`               | Only if the non-root user has read/write privileges.         |
| `notify`             |                                                              |
| `schedule`           |                                                              |
| `service`            | For services that don’t require root. You can also use                                        the `start`, `stop`, and `status` attributes to specify                                    how non-root users can control the service. For more                                    information, see tips and examples for the [                                         `service`                                     ](https://www.puppet.com/docs/puppet/7/resources_service.html#resources_service) type. |
| `ssh_authorized_key` |                                                              |
| `ssh_key`            |                                                              |

To install packages into a directory controlled by a non-root user, you can                either use an `exec` to unzip a tarball or                use a recursive `file` resource to copy a                directory into place.

### Network access

By                default, Puppet apply does not communicate over the                network. It uses its local collection of modules for any file sources, and                does not submit reports to a central server.

Depending on your system and the                resources you are managing, it might download packages from your configured package                repositories or access files on UNC shares.

If you have configured                    an [external node classifier (ENC)](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers), your ENC script might                create an outbound HTTP connection. Additionally, if you’ve configured                    the [HTTP report                     processor](https://www.puppet.com/docs/puppet/7/report.html), Puppet agent sends reports via                HTTP or HTTPS.

If you have configured PuppetDB, Puppet apply                creates outbound HTTPS connections to PuppetDB.

### Logging

​                Puppet apply logs directly to the terminal, which is                good for interactive use, but less so when running as a scheduled task or cron job. 

You can adjust how verbose the logs are with the [                     `log_level`](https://www.puppet.com/docs/puppet/7/configuration.html) setting, which defaults to                    `notice`. Setting it to `info` is equivalent to running with the `--verbose` option, and setting it to `debug` is equivalent to `--debug`. You                can also make logs quieter by setting it to `warning`                or lower. 

When started with the `--logdest                syslog` option, Puppet apply logs to the                    *nix syslog service. Your syslog configuration                dictates where these messages are saved, but the default location is `/var/log/messages` on Linux, and `/var/log/system.logon`                Mac OS X.

When started with the `--logdest eventlog` option, it logs to the Windows Event Log. You can view its logs by browsing                the Event Viewer. Click Control Panel                -> System and Security -> Administrative                    Tools -> Event Viewer.

When started                with the `--logdest <FILE>` option, it                logs to the file specified by `<FILE>`.

### Reporting

In addition to                local logging, Puppet apply processes a report using                its configured [report                     handlers](https://www.puppet.com/docs/puppet/7/report.html), like a primary Puppet server                does. Using the [`reports`                 ](https://www.puppet.com/docs/puppet/7/configuration.html) setting, you can enable different reports. For more information, see the                list of available [reports](https://www.puppet.com/docs/puppet/7/report.html). For information about reporting, see the                    [reporting](https://www.puppet.com/docs/puppet/7/reporting_about.html) documentation.

To disable reporting                and avoid taking up disk space with the `store` report handler, you can set [                     `report = false`                 ](https://www.puppet.com/docs/puppet/7/configuration.html) in [puppet.conf](https://www.puppet.com/docs/puppet/7/config_file_main.html).

## Managing systems with Puppet apply

In a typical site, every node periodically does a Puppet run, to revert unwanted changes and to pick up recent        updates.

​            Puppet apply doesn’t run as a service, so you must            manually create a scheduled task or cron job if you want it to run on a regular basis,            instead of using Puppet agent.

On *nix, you can use the `puppet resource` command to            set up a cron job. 

This example runs Puppet one time per            hour, with Puppet Enterprise            paths:

```
sudo puppet resource cron puppet-apply ensure=present user=root minute=60 command='/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/puppet/manifests --logdest syslog'Copied!
```

## Configuring Puppet apply

Configure Puppet apply in            the `puppet.conf`        file, using the `[user]` section, the `[main]` section, or both.

For information on which settings are relevant to `puppet apply`, see [important settings](https://www.puppet.com/docs/puppet/7/config_important_settings.html#config_important_settings).

# Puppet device

### Sections

[The Puppet device model ](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device_model_)

[ Puppet device’s run         environment](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_devices_run_environment)

- [User](https://www.puppet.com/docs/puppet/7/puppet_device.html#device-run-environment-user)
- [Logging ](https://www.puppet.com/docs/puppet/7/puppet_device.html#device-run-environment-logging)
- [Network access](https://www.puppet.com/docs/puppet/7/puppet_device.html#device-run-environment-network-access)

[Installing device modules](https://www.puppet.com/docs/puppet/7/puppet_device.html#installing_device_modules)

[Configuring Puppet device on the         proxy Puppet agent](https://www.puppet.com/docs/puppet/7/puppet_device.html#configuring_puppet_device_on_the_proxy_puppet_agent)

[Classify the proxy Puppet agent for         the device](https://www.puppet.com/docs/puppet/7/puppet_device.html#classify_proxy_puppet_agent)

[Classify the device ](https://www.puppet.com/docs/puppet/7/puppet_device.html#classify_device_to_manage_resources)

[Get and set data using Puppet       device](https://www.puppet.com/docs/puppet/7/puppet_device.html#get_and_set_data_using_puppet_device)

- [ **Get device data with the `resource` parameter**          ](https://www.puppet.com/docs/puppet/7/puppet_device.html#resource-parameter)
- [ **Set device data with the `apply` parameter**          ](https://www.puppet.com/docs/puppet/7/puppet_device.html#apply-parameter)
- [ **View device facts with the `facts` parameter**          ](https://www.puppet.com/docs/puppet/7/puppet_device.html#facts-parameter)

[Managing devices using Puppet     device](https://www.puppet.com/docs/puppet/7/puppet_device.html#managing_devices_using_puppet_device)

- [Example](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet-device-example)

[Automating device management using the puppetlabs device_manager         module](https://www.puppet.com/docs/puppet/7/puppet_device.html#device_manager_module)

[Troubleshooting Puppet         device](https://www.puppet.com/docs/puppet/7/puppet_device.html#puppet_device_troubleshooting)

Expand

With Puppet device, you can        manage network devices, such as routers, switches, firewalls, and Internet of Things (IOT)        devices, without installing a Puppet agent on them. Devices        that cannot run Puppet applications require a Puppet agent to act as a proxy. The proxy manages        certificates, collects facts, retrieves and applies catalogs, and stores reports on behalf        of a device.

​            Puppet device runs on both *nix and Windows. The Puppet device application combines some of the            functionality of the Puppet apply and Puppet resource applications. For details about running            the Puppet device application, see the [                 `puppet device` man                 page](https://www.puppet.com/docs/puppet/7/man/device.html).

Note: If you are writing a module for a remote                resource, we recommend using transports instead of devices. Transports have extended                functionality and can be used with other workflows, such as with [                     Bolt                 ](https://puppet.com/docs/bolt/latest/bolt.html). For more information on transports and how to port your existing code, see                    [Resource API                     Transports](https://www.puppet.com/docs/puppet/7/about_the_resource_api.html#resource_api_transports).

## The Puppet device model 

In a typical deployment model, a Puppet agent is installed on each system managed by Puppet. However, not all systems can have agents installed on        them.

For these devices, you can configure a Puppet agent on            another system which connects to the API or CLI of the device, and acts as a proxy            between the device and the primaryPuppet server.

In the diagram below, Puppet device is on a proxy Puppet agent (agent.example.com) and is being used to            manage an F5 load balancer (f5.example.com) and a Cisco switch (cisco.example.com).

![img](https://www.puppet.com/docs/puppet/7/devices_diagram.png)

## Puppet device’s run        environment

Puppet device runs as a        single process in the foreground that manages devices, rather than as a daemon or service        like a Puppet agent.

### User

The `puppet                    device` command runs with the privileges of the user who runs it. 

Run Puppet device as:

- Root on *nix
- Either LocalService or a member of the                        Administrators group on Windows

### Logging 

By default, Puppet device outputs directly                to the terminal, which is valuable for interactive use. When you run it as a cron                job or scheduled task, use the `logdest` option to direct the output to a file.

On *nix, run Puppet device with the `--logdest syslog` option to log to the *nix syslog service:                

```
puppet device --verbose --logdest syslogCopied!
```

Your syslog configuration determines where these messages are saved, but the default location is                    `/var/log/messages` on Linux, and `/var/log/system.log` on Mac OS X. For                example, to view these logs on Linux,                run:

```
tail /var/log/messagesCopied!
```

On Windows, run Puppet device with the `--logdest eventlog` option, which logs to                the Windows Event Log, for example:                

```
puppet device --verbose --logdest eventlogCopied!
```

To view these logs on Windows, click Control                    Panel → System and                    Security → Administrative Tools → Event Viewer.

To specify a                particular file to send Puppet device log messages                to, use the `--logdest                    <FILE> option`, which logs to the file specified by `<FILE>`, for                example:                

```
puppet device --verbose --logdest /var/log/puppetlabs/puppet/device.log
Copied!
```

You can increase the logging level with the `--debug` and `--verbose` options. 

In addition to local logging, Puppet device submits reports to the                primary Puppet server after each run. These reports                contain standard data from the Puppet run, including                any corrective changes. 

### Network access

Puppet device creates outbound                network connections to the devices it manages. It requires network connectivity to                the devices via their API or CLI. It never accepts inbound network            connections.

## Installing device modules

You need to install the device module for each device you want to manage on the        primary Puppet server.

For example, to install the [f5](https://forge.puppet.com/puppetlabs/f5) and                [cisco_ios](https://github.com/puppetlabs/cisco_ios) device modules on the primary server, run the following            commands:

```
$ sudo puppet module install f5-f5Copied!
$ sudo puppet module install puppetlabs-cisco_iosCopied!
```

## Configuring Puppet device on the        proxy Puppet agent

You can specify multiple devices in `device.conf`, which is configurable with        the `deviceconfig` setting on        the proxy agent. 

For example, to configure an F5 and a Cisco IOS device, add the            following lines to the `device.conf` file:

```
[f5.example.com]
type f5
url https://username:password@f5.example.com

[cisco.example.com]
type cisco_ios
url file:///etc/puppetlabs/puppet/devices/cisco.example.com.yamlCopied!
```

The            string in the square brackets is the device’s certificate name — usually the hostname or            FQDN. The certificate name is how Puppet identifies the            device. 

For the `url`, specify the device’s connection string. The connection string varies            by device module. In the first example above, the F5 device connection credentials are            included in the `url`            `device.conf` file,            because that is how the F5 module stores credentials. However, the Cisco IOS module uses            the Puppet Resource API, which stores that information in            a separate credentials file. So, Cisco IOS devices would also have a `/etc/puppetlabs/puppet/devices/<device cert                name>.conf` file similar to the following content:

```
{
"address": "cisco.example.com"
"port": 22
"username": "username"
"password": "password"
"enable_password": "password"
}
}
Copied!
```

For more information, see `device.conf`. 

## Classify the proxy Puppet agent for        the device

Some device modules require the proxy Puppet agent to be classified with the base class of the        device module to install or configure resources required by the module. Refer to the        specific device module README for details.

To classify proxy Puppet agent:

1. Classify the agent with the base class of the                    device module, for each device it manages in the manifest. For example: 

   ```
   node 'agent.example.com' {
     include cisco_ios
     include f5
   }Copied!
   ```

2. ​                Apply the classification by running `puppet agent -t` on                    the proxy Puppet agent.            

## Classify the device 

Classify the device with resources to manage its  configuration.

The examples below manage DNS settings on an F5 and a Cisco IOS device.   

1. In the `site.pp` manifest, declare DNS resources for the devices. For example:

   ```
   node 'f5.example.com' {
    f5_dns{ '/Common/dns':
     name_servers => ['4.2.2.2.', '8.8.8.8"],
     same     => ['localhost",' example.com'],
    }
   }
   
   node 'cisco.example.com' {
    network_dns { 'default':
     servers => [4.2.2.2', '8.8.8.8'],
     search => ['localhost",'example.com'],
    }
   }
   Copied!
   ```

2. ​    Apply the manifest by running `puppet device -v` on the proxy Puppet agent.   

Results

Note: Resources vary by device module. Refer to the specific device module README for     details. 

## Get and set data using Puppet      device

The traditional Puppet apply      and Puppet resource applications cannot target device      resources: running `puppet resource         --target <DEVICE>` does not return data from the target device. Instead, use         Puppet device to get data from devices, and to set data on      devices. The following are optional parameters. 

### **Get device data with the `resource` parameter**         

Syntax:

```
puppet device --resource <RESOURCE> --target <DEVICE>Copied!
```

Use            the `resource` parameter            to retrieve resources from the target device. For example, to return the DNS values for            example F5 and Cisco IOS            devices:

```
sudo puppet device --resource f5_dns --target f5.example.com
sudo puppet device --resource network_dns --target cisco.example.comCopied!
```

### **Set device data with the `apply` parameter**         

Syntax:

```
puppet device --verbose --apply <FILE> --target <DEVICE>Copied!
```

Use            the `--apply` parameter to            set a local manifest to manage resources on a remote device. For example, to apply a Puppet manifest to the F5 and Cisco devices:            

```
sudo puppet device --verbose --apply manifest.pp --target f5.example.com
sudo puppet device --verbose --apply manifest.pp --target cisco.example.comCopied!
```

### **View device facts with the `facts` parameter**         

Syntax:

```
puppet device --verbose --facts --target <DEVICE>Copied!
```

Use            the `--facts` parameter to            display the facts of a remote target. For example, to display facts on a device:            

```
sudo puppet device --verbose --facts --target f5.example.comCopied!
```

## Managing devices using Puppet    device

Running the `puppet device` or `puppet-device` command (without `--resource` or `--apply` options) tells the proxy agent to retrieve catalogs from the primary server and    apply them to the remote devices listed in the `device.conf` file.

To run Puppet device on demand and for all      of the devices in `device.conf`      , run: 

```
sudo puppet device --verboseCopied!
```

To run Puppet device for only one of the      multiple devices in the `device.conf` file, specify a `--target` option: 

```
$ sudo puppet device -verbose --target f5.example.comCopied!
```

To run Puppet device on a      specific group of devices, as opposed to all devices in the `device.conf` file, create a separate configuration file      containing the devices you want to manage, and specify the file with the `--deviceconfig`      option:

```
$ sudo puppet device --verbose --deviceconfig /path/to/custom-device.confCopied!
```

To set up a cron job to run Puppet device      on a recurring schedule, run: 

```
$ sudo puppet resource cron puppet-device ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet device --verbose --logdest syslog'Copied!
```

### Example

Follow the steps below to run Puppet device in a        production environment, using `cisco_ios` as an example.

1. Install the module on the primary Puppet server: `sudo puppet module install puppetlabs-cisco_ios`.

2. Include the module on the proxy Puppet agent by adding the              following line to the primary server’s `site.pp`              file:

   ```
   include cisco_iosCopied!
   ```

3. Edit `device.conf` on the proxy Puppet agent:              

   ```
   [cisco.example.com]
   type cisco_ios
   url file:///etc/puppetlabs/puppet/devices/cisco.example.com.yamlCopied!
   ```

4. Create the `cisco.example.com` credentials file required by              modules that use the Puppet Resource              API:

   ```
   {
     "address": "cisco.example.com"
     "port": 22
     "username": "username"
     "password": "password"
     "enable_password": "password"
   }Copied!
   ```

5. Request a certificate on the proxy Puppet agent: `sudo puppet device --verbose --waitforcert 0 --target                cisco.example.com`            

6. Sign the certificate on the primary server: `sudo puppetserver ca sign                cisco.example.com`            

7. Run `puppet device` on the proxy Puppet agent to test the credentials: `sudo puppet device --target                cisco.example.com`            

## Automating device management using the puppetlabs device_manager        module

The `puppetlabs-device_manager` module manages the configuration files used by the            Puppet device application, applies the base class of        configured device modules, and provides additional resources for scheduling and        orchestrating Puppet device runs on proxy Puppet agents. 

For more information, see the module [README](https://forge.puppet.com/puppetlabs/device_manager).

## Troubleshooting Puppet        device

These options are useful for troubleshooting Puppet device command results.

| `--debug` or `-d`   | Enables debugging                   |
| ------------------- | ----------------------------------- |
| `--trace` or `-t`   | Enables stack tracing if Ruby fails |
| `--verbose` or `-v` | Enables detailed reporting          |

# Life cycle of a Puppet run

Learn the details of Puppet's internals,        including how primary servers and agents communicate via host-verified HTTPS, and about the        process of catalog compilation. 

**[Agent-server HTTPS communications](https://www.puppet.com/docs/puppet/7/subsystem_agent_primary_comm.html#subsystem_agent_primary_comm)**
The Puppet agent and primary server       communicate via mutually authenticated HTTPS using client certificates. **[Catalog compilation](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#subsystem_catalog_compilation)**
When configuring a node, the agent uses a document called         a catalog, which it downloads from the primary server. For each resource under  management, the         catalog describes its desired state and can  specify ordered dependency         information. **[Static catalogs](https://www.puppet.com/docs/puppet/7/static-catalogs.html)**
A *static* catalog includes additional metadata that identifies the desired         state of a node’s file resources that have `source` attributes pointing to             `puppet:///` locations. This metadata can refer to a specific version of         the file, rather than the latest version, and can confirm that the agent is applying the         appropriate version of the file resource for the  catalog. As most of the metadata is         provided in the catalog, Puppet agents make fewer requests to         the primary server.

# Agent-server HTTPS communications

### Sections

[Persistent HTTP and HTTPS connections and Keep-Alive](https://www.puppet.com/docs/puppet/7/subsystem_agent_primary_comm.html#persistent-http-and-https-connections)

[The process of Agent-side checks and HTTPS requests during a single Puppet run.](https://www.puppet.com/docs/puppet/7/subsystem_agent_primary_comm.html#agent-checks-and-https-requests)

The Puppet agent and primary server      communicate via mutually authenticated HTTPS using client certificates.

Access to each endpoint is controlled by `auth.conf`         settings. For more information, see [Puppet Server configuration files:             auth.conf](https://puppet.com/docs/puppetserver/latest/config_file_auth.html).

## Persistent HTTP and HTTPS connections and Keep-Alive

When acting as an HTTPS client, Puppet reuses connections            by sending `Connection: Keep-Alive` in HTTP requests.            This reduces transport layer security (TLS) overhead, improving performance for runs            with dozens of HTTPS requests.

You can configure the `Keep-Alive` duration using               the `http_keepalive_timeout` setting, but it            must be shorter than the maximum `keepalive` allowed by            the primary server's web server.

Puppet caches HTTP connections and verified HTTPS            connections. If you specify a custom HTTP connection class, Puppet does not cache the connection.

Puppet always requests that a connection is kept open,            but the server can choose to close the connection by sending `Connection: close` in the HTTP response. If that occurs, Puppet does not cache the connection and starts a new            connection for its next request.

For more information about the `http_keepalive_timeout`            setting, see the [Configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html).

For an example of a server disabling persistent connections, see the [Apache documentation on KeepAlive](http://httpd.apache.org/docs/current/mod/core.html#keepalive).

## The process of Agent-side checks and HTTPS requests during a single Puppet run.

1. Check for keys and certificates: 

   1.  The agent downloads the CA (Certification Authority) bundle. 

   2. If certificate revocation is enabled, the agent loads or downloads the                           Certificate Revocation List (CRL) bundle using the previous CA bundle to                           verify the connection. 

   3. The agent loads or generates a private key. If the agent needs a                           certificate, it generates a Certificate Signing Request (CSR), including                           any `dns_alt_names` and `csr_attributes`, and submits the request using                              `PUT                              /puppet-ca/v1/certificate_request/:certname`. 

   4.  The agent attempts to download the signed certificate using 

      ```
      GET /puppet-ca/v1/certificate/:certname
      ```

      . 

      - If there is a conflict that must be resolved on the 

        Puppet

         server, such as cleaning the                                 old CSR or certificate, the agent sleeps for 

        ```
        waitforcert
        ```

         seconds, or exits with 

        ```
        1
        ```

         if waiting is not allowed, such as                                 when running 

        ```
        puppet agent -t
        ```

        . 

        Tip: This can happen if the agent's SSL directory is                                    deleted, as the Puppet server                                    still has the valid, unrevoked certificate.

      - If the downloaded certificate fails verification, such as it does                                 not match its private key, then Puppet discards the certificate. The agent sleeps for `waitforcert` seconds, or exits with                                    `1` if waiting is not allowed,                                 such as when running `puppet agent                                    -t`. 

2. Request a node object and switch environments: 

   - Do a GET request to `/puppet/v3/node/<NAME>` .
     - If the request is successful, read the environment from the node                                    object. If the node object has an environment, use that                                    environment instead of the one in the agent’s config file in all                                    subsequent requests during this run. 
     - If the request is unsuccessful, or if the node object had no                                    environment set, use the environment from the agent’s config                                    file.

3. If `pluginsync` is enabled on the agent, fetch                     plugins from a file server mountpoint that scans the `lib` directory of every module: 

   - Do a GET request to `/puppet/v3/file_metadatas/plugins` with `recurse=true` and `links=manage`. 
   - Check whether any of the discovered plugins need to be downloaded. If                              so, do a GET request to `/puppet/v3/file_content/plugins/<FILE>` for                              each one. 

4. Request catalog while submitting facts: 

   - Do a POST request to `/puppet/v3/catalog/<NAME>`, where the post data is                              all of the node’s facts encoded as JSON. Receive a                              compiled catalog in return.

     Note: Submitting                                 facts isn't logically bound to requesting a catalog. For more                                 information about facts, see [Language: Facts and                                     built-in variables](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html). 

5. Make file source requests while applying the catalog: 

   File resources can specify file contents as either a `content` or `source` attribute. Content attributes go into the catalog, and                     the agent needs no additional data. Source attributes put only references into                     the catalog and might require additional HTTPS requests. 

   - If you are using the normal compiler, then for each file source, the                              agent makes a GET request to `/puppet/v3/file_metadata/<SOMETHING>` and compares                              the metadata to the state of the file on disk. 

     - If it is in sync, it continues on to the next file source.
     - If it is out of sync, it does a GET request to `/puppet/v3/file_content/<SOMETHING>` for                                    the content. 

   - If you are using the static compiler, all file metadata is                              embedded in the catalog. For each file source, the agent compares the                              embedded metadata to the state of the file on disk. 

     - If it is in sync, it continues on to the next file source.

     - If it is out of sync, it does a GET request to` /puppet/v3/file_bucket_file/md5/<CHECKSUM>` for                                    the content. 

       Note: Using a static compiler is more                                       efficient with network traffic than using the normal                                       (dynamic) compiler. Using the dynamic compiler is less                                       efficient during catalog compilation. Large amounts of files,                                       especially recursive directories, amplifies either                                       issue.

6. If `report` is enabled on the agent,                     submit the report: 

   - Do a PUT request to `/puppet/v3/report/<NAME>`. The content of the PUT                              should be a Puppet report object in                              YAML format. 

# Catalog compilation

### Sections

[Agent-provided data](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#agent-provided-data)

[External data](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#external-data)

[Manifests and modules](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#manifests-and-modules)

[The catalog compilation process ](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#catalog-compilation-process)

When configuring a node, the agent uses a document called        a catalog, which it downloads from the primary server. For each resource under management, the        catalog describes its desired state and can specify ordered dependency        information.

​            Puppet manifests are concise because they can express            variation between nodes with conditional logic, templates, and functions. Puppet resolves these on the primary server and gives the agent a            specific catalog.

This allows Puppet to:

- Separate privileges, because each node receives only its own                    resources.
- Reduce the agent’s CPU and memory consumption.
- Simulate changes by running the agent in no-op mode,                    checking the agent's current state and reporting what would have changed without                    making any changes.
- Query PuppetDB for                    information about managed resources on any node.

Note: The `puppet apply` command compiles the catalog on its own node and then                applies it, so it plays the role of both primary server and agent. To compile a catalog on                the primary server for testing, run `puppet catalog                    compile` on the `puppetserver` with access to your environments, modules, manifests, and                    Hiera data.

For more information about PuppetDB queries, see [                 PuppetDB API](https://puppet.com/docs/puppetdb/latest/api/index.html).

Puppet compiles a catalog using three sources of            configuration information: 

- Agent-provided data
- External data
- Manifests and modules, including associated templates and file sources

These sources are used by both agent-server deployments and by stand-alone `puppet apply` nodes. 

## Agent-provided data

When an agent requests a catalog, it sends four pieces of information to the primary                server:

- The node's name, which is almost always the same as the node's certname                        and is embedded in the request URL. For example, `/puppet/v3/catalog/web01.example.com?environment=production`.
- The node's certificate, which contains its certname and sometimes                            additional information that can be used for policy-based autosigning and                            adding new trusted facts. This is the one item not used by `puppet apply`.
- The node's facts.
- The node's requested environment, which is embedded in the request URL.                        For example, `/puppet/v3/catalog/web01.example.com?environment=production`.                        Before requesting a catalog, the agent requests its environment from the                        primary server. If the primary server doesn't provide an environment, the                        environment information in the agent's config file is used.

For more information about additional data in certs see [SSL                     configuration: CSR attributes and certificate extensions](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions)            

## External data

​                Puppet uses two main kinds of external data during                catalog compilation: 

- Data from an external node classifier (ENC) or other node terminus, which is                        available before compilation starts. This data is in the form of a node                        object and can contain any of the following: 
  - Classes
  - Class configuration parameters
  - Top-scope variables for the node
  - Environment information, which overrides the environment information                                in the agent's configuration 
- Data from other sources, which can be invoked by the main manifest or by                        classes or defined types in modules. This kind of data includes: 
  - Exported resources queried from PuppetDB. 
  - The results of functions, which can access data sources including                                    Hiera or an external                                configuration management database.

For more information about ENCs, see [Writing                     external node classifiers](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers)            

## Manifests and modules

Manifests and modules are at the center of a Puppet                deployment, including the main manifest, modules downloaded from the [                     Forge                 ](https://forge.puppet.com/), and modules written specifically for your site. 

For more information about manifests and modules, see [The main manifest                     directory](https://www.puppet.com/docs/puppet/7/dirs_manifest.html) and [Module fundamentals](https://www.puppet.com/docs/puppet/7/modules_fundamentals.html#modules_fundamentals).

## The catalog compilation process 

This simplified description doesn’t delve into the internals of the parser, model,                and the evaluator. Some items are presented out of order for the sake of clarity.                This process begins after the catalog request has been received. 

Note: For practical purposes, treat `puppet apply` nodes                    as a combined agent and primary server.

1. Retrieve the node object. 

   - After the primary server has received the agent-provided                                    information for this request, it asks its configured node                                    terminus for a node object. 
   - By default, the primary server uses the `plain` node terminus, which returns a blank node                                    object. In this case, only manifests and agent-provided                                    information are used in compilation. 
   - The next most common node terminus is the `exec` node terminus, which requests data from an                                    ENC. This can return classes, variables, an environment, or a                                    combination of the three, depending on how the ENC is designed. 
   - You can also write a custom node terminus that retrieves                                    classes, variables, and environments from an external                                    system.

2. Set variables from the node object, from facts, and from the certificate. 

   - All of these variables are available for use by any manifest or                                    template during subsequent stages of compilation. 
   - The node’s facts are set as top-scope variables.
   - The node’s facts are set in the protected `$facts` hash, and certain data from the node’s                                    certificate is set in the protected `$trusted` hash. 
   - Any variables provided by the primary server are set. 

3. Evaluate the main manifest. 

   - ​                                    Puppet parses the main manifest.                                    The node’s environment can specify a main manifest; if it                                    doesn’t, the primary server uses the main manifest from the                                    agent's config file. 

   - If there are node definitions in the manifest, Puppet must find one that matches                                    the node’s name. If at least one node definition is present and                                        Puppet cannot find a match,                                    it fails compilation. 

   - Code outside of node definitions is evaluated. Resources in the                                    code are added to the are added to the node's catalog, and any                                    classes declared in the code are loaded and declared.

     Note: Classes are usually classes are defined in                                        modules, although the main manifest can also contain class                                        definitions.

   - If a matching node definition is found, the code in it is                                    evaluated at node scope, overriding any top-scope variables.                                    Resources in the code are added to the are added to the node's                                    catalog, and any classes declared in the code are loaded and                                    declared.

4. Load and evaluate classes from modules 

   - If classes were declared in the main manifest and their                                        definitions were not present, Puppet loads the manifests                                        containing them from its collection of modules. It follows                                        the normal manifest naming conventions to find the files it                                        should load. The set of locations Puppet loads modules from is                                        called the modulepath. The primary server serves each                                        environment with its own modulepath. When a class is loaded,                                        the Puppet code in it is                                        evaluated, and any resources in it are added to the catalog.                                        If it was declared at node scope, it has access to                                        node-scope variables; otherwise, it has access to only                                        top-scope variables. Classes can also declare other classes;                                        if they do, Puppet loads and                                        evaluates those in the same way. 

5. Evaluate classes from the node object 

   - ​                                        Puppet loads from modules and                                        evaluate any classes that were specified by the node object.                                        Resources from those classes are added to the catalog. If a                                        matching node definition was found when the main manifest                                        was evaluated, these classes are evaluated at node scope,                                        which means that they can access any node-scope variables                                        set by the main manifest. If no node definitions were                                        present in the main manifest, they are evaluated at top                                        scope. 

**Related information**

- [Classifying nodes](https://www.puppet.com/docs/puppet/7/nodes_external.html#writing-node-classifiers)
- [Scope](https://www.puppet.com/docs/puppet/7/lang_scope.html#lang_scope)
- [Node definitions](https://www.puppet.com/docs/puppet/7/lang_node_definitions.html)
- [The modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html)
- [Exported resources](https://www.puppet.com/docs/puppet/7/lang_exported.html)

# Static catalogs 

### Sections

[When to use static catalogs](https://www.puppet.com/docs/puppet/7/static-catalogs.html#when-to-use)

[Static catalog features](https://www.puppet.com/docs/puppet/7/static-catalogs.html#features)

[Configuring `code_id` and the `static_file_content`                 endpoint](https://www.puppet.com/docs/puppet/7/static-catalogs.html#configuring-endpoints)

[Enabling or disabling static catalogs](https://www.puppet.com/docs/puppet/7/static-catalogs.html#enabling-or-disabling)

A *static* catalog includes additional metadata that identifies the desired        state of a node’s file resources that have `source` attributes pointing to            `puppet:///` locations. This metadata can refer to a specific version of        the file, rather than the latest version, and can confirm that the agent is applying the        appropriate version of the file resource for the catalog. As most of the metadata is        provided in the catalog, Puppet agents make fewer requests to        the primary server.

## When to use static catalogs

When a primary server compiles a non-static catalog, the catalog does not specify a                particular version of its file resources. When the agent applies the catalog, it                always retrieves the latest version of that file resource, or uses a previously                retrieved version if it matches the latest version’s contents. Note that this                potential problem affects file resources that use the *source* attribute. File                resources that use the *content* attribute are not affected, and their behavior                does not change in static catalogs.

When a Puppet manifest depends on a file whose                contents change more frequently than the Puppet agent                receives new catalogs — for example, if the agent is caching catalogs or cannot                reach a primary server over the network — a node might apply a version of the                referenced file that does not match the instructions in the catalog.

As a result, the agent’s Puppet runs might produce                different results each time the agent applies the same catalog. This can cause                problems because Puppet expects a catalog to produce                the same results each time it is applied, regardless of any code or file content                updates on the primary server.

Additionally, each time a Puppet agent applies a                non-static cached catalog that contains file resources sourced from                    `puppet:///` locations, the agent requests file metadata from the                primary server, even though nothing changed in the cached catalog. This causes the                primary server to perform unnecessary resource-intensive checksum calculations for                each such file resource.

Static catalogs avoid these problems by including metadata that refers to a specific                version of the resource’s file. This prevents a newer version from being incorrectly                applied, and avoids having the agent request the metadata on each Puppet run.

This type of catalog is called static because it contains all of the                information that an agent needs to determine whether the node’s configuration                matches the instructions and static state of file resources at the point in time                when the catalog was compiled.

## Static catalog features

A static catalog includes file metadata in its own section and associates it with the                catalog's file resources. 

In a non-static catalog, the Puppet agent requests                metadata and content for the file from Puppet Server. The                server generates a checksum for the file and provides that file as it currently                exists on the primary server.

With static catalogs enabled, the primary server generates metadata for each file                resource sourced from a `puppet:///` location and adds it to the                static catalog, and adds a `code_id` to the catalog that associates                such file resources with the version of their files as they exist at compilation                time. For example: 

```
file { '/etc/application/config.conf':
  ensure => file,
  source => 'puppet:///modules/module_name/config.conf'
}Copied!
```

Inlined metadata is part of a `FileMetadata` object in the static                catalog that is divided into two new sections: `metadata` for                metadata associated with individual files, and `recursive_metadata`                for metadata associated with many files. To use the appropriate version of the file                content for the catalog, Puppet Server also adds a                    `code_id` parameter to the catalog. The value of                    `code_id` is a unique string that Puppet Server uses to retrieve the version of file                resources in an environment at the time when the catalog was compiled.

When applying a file resource from a static catalog, an agent first checks the                catalog for that file’s metadata. If it finds some, Puppet uses the metadata to call the                    `static_file_content` API endpoint on Puppet Server and retrieves the file’s contents, also                called the `code_content`. If the catalog does not contain metadata                for the resource, Puppet requests the file resource’s                metadata from the primary server, compares it to the local file if it exists, and                requests the resource’s file from the primary server in its current state — if the                local file doesn’t exist or differs from the primary server's version.

## Configuring `code_id` and the `static_file_content`                endpoint

When requesting the file’s content via the static catalog’s metadata, the Puppet agent passes the file’s path, the catalog’s                    `code_id`, and the requested environment to Puppet Server's `static_file_content` API                endpoint. The endpoint returns the appropriate version of the file’s contents as the                    `code_content`.

If static catalogs are enabled but Puppet Server's static                catalog settings are not configured, the `code_id` parameter defaults                to a null value and the agent uses the `file_content` API endpoint,                which always returns the latest content. To populate the `code_id`                with a more useful identifier and have the agent use the                    `static_file_content` endpoint to retrieve a specific version of                the file’s content, you must specify scripts or commands that provide Puppet with the appropriate results.

Puppet Server locates these commands using the                    `code-id-command` and `code-content-command`                settings in the `puppetserver.conf` file. Puppet Server runs the `code-id-command`                each time it compiles a static catalog, and it runs the                    `code-content-command` each time an agent requests file contents                from the `static_file_content` endpoint.

The Puppet Server process must be able to execute these                scripts. Puppet Server also validates their output and                checks their exit codes. Environment names can contain only alphanumeric characters                and underscores (`_`). The `code_id` can contain only                alphanumeric characters, dashes (`-`), underscores                    (`_`), semicolons (`;`), and colons                    (`:`). If either command returns a non-zero exit code, Puppet Server logs an error and returns the error message                and a 500 response code to the API request.

Puppet Server validates the standard output of each of these                scripts, and if the output’s acceptable, it adds the results to the catalog as their                respective parameters’ values. You can use any versioning or synchronization tools,                as long as you write scripts that produce a valid string for the                    `code_id` and code content using the catalog’s                    `code_id` and file’s environment.

The following examples demonstrate how Puppet Server passes                arguments to the `code-id-command` and                    `code-content-command` scripts and how Puppet Server uses the results to return a specific version                of a file resource.

For files in an environment managed by Git, you would use something like the                following `code-id-command` script, with the environment name passed                in as the first command-line argument:

```
#!/bin/bash
set -e
if [[ -z "$1" ]]; then
  echo Expected an environment >&2
  exit 1
fi
cd /etc/puppetlabs/code/environments/"$1" && git rev-parse HEADCopied!
```

As long as the script’s exit code is zero, Puppet Server                uses the script’s standard output as the catalog’s `code_id`.

With a `code-content-command` script, Puppet Server passes the environment name as the first                command-line argument, the `code_id` as the second argument, and the                path to the file resource from its `content_uri` as the third                argument:

```
#!/bin/bash
set -e
if [[ $# < 3 ]]; then
  echo Expected environment, code-id, file-path >&2
  exit 1
fi
cd /etc/puppetlabs/code/environments/"$1" && git show "$2":"$3"Copied!
```

The script’s standard output becomes the file’s `code_content`,                provided the script returns a non-zero exit code.

## Enabling or disabling static catalogs

The global `static_catalogs` setting is enabled by default. However,                the default configuration does not include the `code-id-command` and                    `code-content-command` scripts or settings needed to produce                static catalogs, and even when configured to produce static catalogs Puppet Server does not inline metadata for all types of                file resources.

Note that Puppet Server does not produce static catalogs for                an agent under the following circumstances:

- If the 

  ```
  static_catalogs
  ```

   setting is false in:

  - The Puppet Server’s                                `puppet.conf` file.
  - The `environment.conf` file for the environment under                            which the agent is requesting a catalog.
  - The agent’s `puppet.conf` file.

- If the Server’s `code-id-command` and                        `code-content-command` settings and scripts are not                    configured, or if the `code-id-command` returns an empty                    string.

Additionally, Puppet Server only inlines metadata for file                resources if **all** of the following conditions are true:

- It contains a `source` parameter with a Puppet URI, such as `source =>                        'puppet:///path/to/file'`.
- It contains a `source` parameter that uses the built-in                        `modules` mount point.
- The file it sources is inside the following glob, relative to the environment’s                    root directory: `*/*/files/**`. For example, Puppet Server inlines metadata into static catalogs for                    file resources sourcing module files located by default in                        `/etc/puppetlabs/code/environments/<ENVIRONMENT>/modules/<MODULE                        NAME>/files/**`.

**Related information**

- [Catalog compilation](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#subsystem_catalog_compilation)
- [Catalog](https://www.puppet.com/docs/puppet/7/http_api/http_catalog.html)
- [File Metadata](https://www.puppet.com/docs/puppet/7/http_api/http_file_metadata.html)
- [File Content](https://www.puppet.com/docs/puppet/7/http_api/http_file_content.html)
- [puppet.conf: The main config file](https://www.puppet.com/docs/puppet/7/config_file_main.html)
- [environment.conf: Per-environment settings](https://www.puppet.com/docs/puppet/7/config_file_environment.html)



## 历史

Luke Kanies

Puppet Labs
