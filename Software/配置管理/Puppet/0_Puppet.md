# Puppet

[TOC]

## 概述

https://puppet.com/

Puppet 提供了自动化管理基础设施的工具。Puppet 是一个开源产品，拥有活跃的用户和贡献者社区。可以通过修复 bug 、影响新的功能方向、发布模块以及与社区分享知识和专业知识来参与其中。

用 Ruby 语言开发。使用 Apache 协议。

当使用 Puppet 时，您可以定义要管理的基础架构中系统的所需状态。可以通过使用 Puppet 的领域特定语言（DSL）编写基础结构代码来实现这一点，Puppet 代码可以用于各种设备和操作系统。Puppet 代码是声明性的，这意味着描述了系统的所需状态，而不是达到所需的步骤。然后，Puppet 自动化了使这些系统进入该状态并将其保持在该状态的过程。Puppet 通过 Puppet 主服务器和 Puppet 代理执行此操作。Puppet 主服务器是存储定义所需状态的代码的服务器。Puppet 代理将您的代码转换为命令，然后在您指定的系统上执行它，这就是所谓的Puppet 运行。

下图显示了 Puppet 是如何工作的。

 ![](../../../Image/p/puppet_run.png)

既能以 C/S 的方式运行，也能独立运行。Agent 默认每 30 分钟会与服务器确认一下更新，以确保配置的一致性。

在您的环境中实现 Puppet 这样的声明性配置工具有很多好处——最明显的是一致性和自动化。

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

* puppet server

  Puppet is configured in an agent-server architecture, in  which a primary server node manages the configuration information for a  fleet of agent nodes. Puppet 在代理服务器架构中配置，其中主服务器节点管理代理节点组的配置信息。Puppet Server 服务器充当主服务器节点。Puppet Server 是一个在 Java 虚拟机（JVM）上运行的 Ruby 和 Clojure 应用程序。Puppet Server 运行 Ruby code 来编译 Puppet catalogs 并在几个 JRuby 解释器中提供文件。它还通过 Clojure 提供证书颁发机构。

* agent

  将代码转换为命令，然后在指定的系统上执行。

* puppetdb

  Puppet 生成的所有数据（例如事实、目录、报告）都存储在 PuppetDB 中。

* Facter

  Facter 是 Puppet 的跨平台系统评测库。它发现并报告每个节点的事实，这些事实作为变量在 Puppet 清单中可用。

* 服务和工具

  Puppet 提供了许多核心服务和管理工具，用于管理具有或不具有主 Puppet 服务器的系统，以及编译 Puppet 代理的配置。

* 报告

  Puppet 每次在 Puppet 运行期间应用目录时都会创建一个关于其操作和基础设施的报告。可以创建并使用报告处理器从这些报告中生成有洞察力的信息或警报。

* 

Puppet 在agent-server代理-服务器架构中配置，其中主节点（系统）控制一个或多个受管理代理节点的配置信息。服务器和代理使用 SSL 证书通过 HTTPS 进行通信。Puppet 包含用于管理证书的内置证书颁发机构。Puppet Server 执行主节点的角色，并运行代理来配置自己。

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

## 目录结构

```bash
puppetlabs/
├── code
│   ├── environments
│   │   └── production
│   │       ├── data
│   │       ├── environment.conf
│   │       ├── hiera.yaml
│   │       ├── manifests
│   │       └── modules
│   └── modules
├── puppet
│   ├── devices
│   ├── hiera.yaml
│   ├── puppet.conf
│   └── ssl
│       ├── ca -> /etc/puppetlabs/puppetserver/ca
│       ├── certificate_requests
│       ├── certs
│       │   ├── ca.pem
│       │   └── puppet.vhengdata.com.pem
│       ├── crl.pem
│       ├── private
│       ├── private_keys
│       │   └── puppet.vhengdata.com.pem
│       └── public_keys
│           └── puppet.vhengdata.com.pem
├── puppetserver
│   ├── ca
│   │   ├── ca_crl.pem
│   │   ├── ca_crt.pem
│   │   ├── ca_key.pem
│   │   ├── ca_pub.pem
│   │   ├── infra_crl.pem
│   │   ├── infra_inventory.txt
│   │   ├── infra_serials
│   │   ├── inventory.txt
│   │   ├── requests
│   │   ├── serial
│   │   └── signed
│   │       └── puppet.vhengdata.com.pem
│   ├── conf.d
│   │   ├── auth.conf
│   │   ├── ca.conf
│   │   ├── global.conf
│   │   ├── metrics.conf
│   │   ├── puppetserver.conf
│   │   ├── web-routes.conf
│   │   └── webserver.conf
│   ├── logback.xml
│   ├── request-logging.xml
│   └── services.d
│       └── ca.cfg
└── pxp-agent
    └── modules
```



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

  它类似于标准 INI 文件，具有一些语法扩展名。设置可以进入特定于应用程序的部分，也可以进入影响所有应用程序的 `[main]` 部分。

* environment.conf

  Per-environment 设置。环境是独立的代理节点组。任何环境都可以包含 `environment.conf` 文件。每当主服务器为分配给该环境的节点提供服务时，该文件可以覆盖多个设置。

* fileserver.conf

  为 Puppet 的文件服务器配置自定义静态装载点。如果存在自定义装载点，则 `file` 资源可以使用其 `source` 源属性访问它们。

* puppetdb.conf

  PuppetDB 服务器位置。配置 Puppet 如何连接到一个或多个服务器。仅当您正在使用 PuppetDB 并已将主服务器连接到它时才使用它。

* autosign.conf
  
  Basic certificate autosigning 基本证书自动签名。允许自动签署某些证书请求。它仅在CA主Puppet服务器上有效；不充当 CA 的主服务器不使用 `autosign.conf` 。
  
* csr_attributes.yaml
  
  证书扩展。定义了新证书签名请求（csr）的自定义数据。
  
* custom_trusted_oid_mapping.yaml
  
  Short names for cert extension OID 证书扩展oid的缩写
  
  允许您为证书扩展对象标识符（OID）设置自己的短名称，这可以使 `$trusted` 变量更有用。
  
* device.conf
  
  网络硬件访问。
  `puppet-device` 子命令从主puppet服务器检索目录并将其应用于远程设备。要由 `puppet-device` 子命令管理的设备在 `device.conf` 中配置。
  
* routes.yaml
  
  Advanced plugin routing高级插件路由。覆盖了涉及 indirector termini 的配置设置，并允许比 `puppet.conf` 允许的更详细地设置 termini 。

#### puppet.conf

##### 路径

始终位于 `$confdir/puppet.conf` 。

尽管它的位置可以通过 `config` 进行配置，但只能在命令行上进行。例如：

```bash
puppet agent -t --config ./temporary_config.conf
```

`confdir` 的位置取决于您的操作系统。

##### 示例

Example agent config: 

```ini
[main]
certname = agent01.example.com
server = puppet
runinterval = 1h
```

Example server config:                

```ini
[main]
certname = puppetserver01.example.com
server = puppet
runinterval = 1h
strict_variables = true

[server]
dns_alt_names = primaryserver01,primaryserver01.example.com,puppet,puppet.example.com
reports = puppetdb
storeconfigs_backend = puppetdb
storeconfigs = true
```

##### 格式

The `puppet.conf` file consists of one or more config                sections, each of which can contain any number of settings.

The file can also include comment lines at any point.

puppet.conf文件由一个或多个配置节组成，每个配置节可以包含任意数量的设置。

该文件还可以在任何位置包含注释行。

##### 配置部分

```ini
[main]
    certname = primaryserver01.example.com
```

配置部分是一组设置。它包括：

- 它的名字，用方括号括起来。配置节的 `[name]` 必须在其自己的行上，没有前导空格。
- 任意数量的设置行，可缩进以提高可读性。
- 任意数量的空行或注释行

一旦文件中出现新的配置节 `[name]` ，前一个配置节将关闭，新的配置部分将开始。给定的配置节在文件中只出现一次。

Puppet 使用四个配置部分：

- `main` 是所有命令和服务使用的全局部分。它可以被其他部分覆盖。

- `server` 由主要 Puppet 服务器服务和 Puppet 服务器 ca 命令使用。

  > Important:
  >
  > 除非在特定情况下必须覆盖 `server` 运行模式的设置，否则请确保仅在 `main` 模式中应用设置。例如，当 Puppet Server 配置为使用外部节点分类器时，必须将这些设置添加到 `server` 部分。如果将这些设置添加到 `main` ，then the agent tries and fails to run the server-only script                            /usr/local/bin/puppet_node_classifier during its run.则代理将尝试在运行期间运行仅服务器脚本/usr/local/bin/puppet节点分类器，但失败。

- `agent` 由 Puppet 代理服务使用。

- `user` 由 Puppet apply 命令以及许多不太常见的 Puppet 子命令使用。

Puppet prefers to use settings from one of the three application-specific sections (`server`, `agent`, or `user`). Puppet 更喜欢使用三个应用程序特定部分（服务器、代理或用户）之一的设置。如果在应用程序部分中找不到设置，则使用 `main` 中的值。（如果 `main` 未设置一个，则返回默认值。）

> Note:
>
> Puppet Server 服务器忽略一些配置设置。它接受 `puppet.conf` 中的几乎所有设置，并自动拾取它们。However, some Puppet Server settings differ from a Ruby primary server'ssettings.然而，一些 Puppet Server 设置与 Ruby 主服务器的 `puppet.conf` 设置不同。

##### 注释行

```ini
# This is a comment.
```

注释行以哈希符号（#）开头。它们可以缩进任意数量的前导空格。

不允许使用部分行注释，例如 `report = true # this enables reporting` ， and the intended comment is treated as part  of the value of the setting. To be treated as a comment, 并且预期注释将被视为设置值的一部分。要作为注释处理，哈希符号必须是行上的第一个非空格字符。

##### 设置行

```ini
certname = primaryserver01.example.com
```

一个设置行包括：

- 任意数量的前导空格（可选）。
- 设置的名称。
- 等号 (`=`)，可以选择用任意数量的空格包围。
- 设置的值。

##### 特殊类型的设置值

通常，设置的值是一个单词。但是，下面列出了一些特殊类型的值。

单词列表：某些设置（如报告）可以接受多个值，这些值被指定为逗号分隔的列表（逗号后带有可选空格）。示例：`report = http,puppetdb`

路径：某些设置（如 `environmentpath` ）采用目录列表。目录由系统路径分隔符分隔，在 *nix平 台上是冒号（`:`），在 Windows 上是分号（`;`）。

```bash
# *nix version:
environmentpath = $codedir/special_environments:$codedir/environments
# Windows version:
environmentpath = $codedir/environments;C:\ProgramData\PuppetLabs\code\environmentCopied!
```

路径列表已排序；Puppet 总是先检查第一个目录，如果找不到它需要的内容，就转到其他目录。

文件或目录：使用单个文件或目录（如 `ssldir` ）的设置可以接受可选的权限散列。启动时，Puppet 会对文件或目录强制执行这些权限。

我们不建议您这样做，因为默认设置对大多数用户都很好。但是，如果需要，可以通过在路径后面放置如下哈希来指定权限：   

```bash
ssldir = $vardir/ssl {owner = service, mode = 0771}
```

哈希中允许的键为 `owner` , `group` 和 `mode` 。`owner` 和 `group` 键只有两个有效值：

- `root` — root / Administrator 用户，或拥有文件的组。
- `service` — Puppet 服务运行时拥有文件的用户或组。服务的用户和组由 `user` 和 `group` 设定。在开源版本的 Puppet 主服务器上，这些默认为 `puppet` ；在企业版 Puppet 上，这些默认为 `pe-puppet` 。

##### 在设置中插入变量

设置的值在 `puppet.conf` 中作为变量提供，可以将它们插入到其他设置的值中。要将设置引用为变量，请在其名称前加上美元符号 (`$`) ：

```bash
ssldir = $vardir/ssl
```

并非所有设置都同样有用；例如，在 `basemodulepath` 中插入 `$ssldir` 没有实际意义。建议您仅使用以下变量：

- `$codedir`
- `$confdir`
- `$vardir`

#### environment.conf

##### 路径

每个 `environment.conf` 文件都存储在一个 environment 中。It will be at the top level of its home  environment, next to the `manifests` and `modules` directories.它将位于其主环境的顶层，紧挨着清单和模块目录。

For example, if your environments are in the default directory (), theenvironment’s config file is located at . 

例如，如果您的环境位于默认目录（`$codedir/environments`）中，则 `test` 环境的配置文件位于 `$codedir/environments/test/environment.conf` 。

##### 示例

```bash
# /etc/puppetlabs/code/environments/test/environment.conf

# Puppet Enterprise requires $basemodulepath; see note below under "modulepath".
modulepath = site:dist:modules:$basemodulepath

# Use our custom script to get a git commit for the current state of the code:
config_version = get_environment_commit.sh
```

##### 格式

`environment.conf` 文件使用与 `puppet.conf`  相同的 INI-like  格式，但有一个例外：它不能包含 [`main`] 这样的配置节。`environment.conf` 中的所有设置都必须在任何配置节之外。

##### 值中的相对路径

大多数允许的设置都接受文件路径或路径列表作为其值。

如果这些路径中的任何一个是相对路径（即，它们开头没有前导斜杠或驱动器号），它们将相对于环境的主目录进行解析。

例如，如果在 `test` 环境中设置 `config_version = get_environment_commit.sh` ，Puppet将使用位于 `/etc/puppetlabs/code/environments/test/get_environment_commit.sh` 的文件。

##### Interpolation in values 插值值

`environment.conf` 中的设置可以使用其他设置的值作为变量（例如 `$codedir` ）。此外，`config_version` 设置可以使用特殊的 `$environment` 变量，该变量将替换为活动环境的名称。

插入 `environment.conf` 设置的最有用的变量是：

- `$basemodulepath` — 用于在 `modulepath` 设置中包含默认模块目录。建议 Puppet Enterprise (PE) 用户将其包含在 `modulepath` 的值中，因为 PE 使用  `basemodulepath` 中的模块来配置编排和其他功能。
- `$environment` — 用作 `config_version` 脚本的命令行参数。只能在 `config_version` 设置中插入此变量。
- `$codedir` — 用于查找文件。

##### 允许的设置

`environment.conf` 文件可以覆盖这些设置：

- `modulepath` 

  Puppet 从中加载模块的目录列表。如果未设置此设置，则环境的 `modulepath` 为：`<MODULES DIRECTORY FROM ENVIRONMENT>:$basemodulepath` 。也就是说，Puppet adds the environment’s modules directory to the value of the basemodulepath setting from `puppet.conf`, with the environment’s modules getting priority. Puppet将环境的模块目录添加到Puppet.conf的basemodulepath设置的值中，环境的模块获得优先级。如果模块目录为空或不存在，Puppet 只使用 basemodulepath 目录中的模块。 A directory environment never uses the global `modulepath` from `puppet.conf`.       目录环境从不使用puppet.conf中的全局模块路径。                  

- `manifest`

  主服务器在编译此环境的目录时使用的主清单。这可以是一个文件或一个清单目录，按字母顺序进行评估。将此路径作为一个目录进行管理，如果存在，或者路径以斜线 (`/`) 或点 (`.`) 结尾。如果未设置此设置，Puppet 将使用环境的 `manifests` 目录作为主清单，即使它为空或不存在。A directory environment never uses the global `manifest` from `puppet.conf`.  manifest 目录环境从不使用puppet.conf中的全局清单。           

- `config_version` 

  一个 Puppet 可以运行来确定配置版本的脚本。Puppet 会自动为它编译的每个目录以及报告中的消息添加配置版本。版本是一个任意的数据块，可用于标识目录和事件。通过在 environment.conf 文件中设置 `config_version` ，可以指定一个可执行脚本来确定环境的配置版本。Puppet 在为环境中节点编译目录时运行此脚本，并将其输出用作配置版本。

  > Note:
  >
  > 如果您使用的是git-rev-parse这样的系统二进制文件，If you’re using a system binary like `git rev-parse`, 请确保指定它的绝对路径。如果 `config_version` 设置为相对路径，Puppet 会在环境中查找二进制文件，而不是在系统的 `PATH` 中。如果未设置此设置，则配置版本是编译目录的时间（自 1970 年 1 月 1 日以来的秒数）。A directory environment never uses the global `config_version` from `puppet.conf`.  目录环境从不使用puppet.conf中的全局配置版本。

- `environment_timeout` 

  主服务器缓存从环境加载的数据的时间。如果存在，这将覆盖 puppet.conf 中的 `environment_timeout` 值。除非您有特定原因，否则我们建议只在puppet.conf 中全局设置 `environment_timeout` 。我们也不建议使用 `0` 或 `unlimited` 以外的任何值。                                         

#### fileserver.conf

##### 使用 `fileserver.conf`

只有在创建自定义装载点时，此文件才是必需的。

Puppet 自动从每个模块的 `files` 目录中提供文件，大多数用户认为这就足够了。然而，自定义装载点对于那些不存储在模块版本控制中的东西很有用，比如非常大的文件和敏感的凭据。

##### 路径

默认情况下，`fileserver.conf` 文件位于 `$confdir/fileserver.conf` 。其位置可通过 `fileserverconfig` 设置进行配置。

`confdir` 的位置取决于您的操作系统。

##### 示例

```bash
# Files in the /path/to/files directory are served
# at puppet:///extra_files/.
[extra_files]
    path /etc/puppetlabs/puppet/extra_files
```

`fileserver.conf` 文件创建一个名为 `extra_files` 的新装载点。对 `extra_files` 的授权由 Puppet 服务器控制。

> CAUTION: 
>
> 始终限制对已装载目录的写入访问。The file server follows any symlinks in a file server mount, including links to files that agent nodes shouldn’t access (like SSL keys). 文件服务器遵循文件服务器装载中的任何符号链接，包括指向代理节点不应访问的文件的链接（如SSL密钥）。当遵循符号链接时，文件服务器可以访问 Puppet server 用户帐户可读的任何文件。

##### 格式

`fileserver.conf` 使用 a one-off 格式，类似于不带等号 `(=)` 的 INI 文件。 It is a series of mount-point stanzas, where each stanza consists of:这是一系列装入点节，其中每个节包括：

- 由方括号包围的 `[mount_point_name]` 。这将成为此装载点中文件的 `puppet:///` URL中使用的名称。
- 一个 `path <PATH>` 指令，其中 `<PATH>` 是磁盘上的绝对路径。这是装载点文件的存储位置。

#### puppetdb.conf

`puppetdb.conf` 文件配置 Puppet 如何连接到一个或多个服务器。仅当您正在使用 PuppetDB 并已将主服务器连接到它时，才使用它。

该配置文件记录在 PuppetDB 文档中。

#### autosign.conf

> CAUTION:
>
> 由于任何主机在请求证书时都可以提供任何证书名，因此基本的自动签名是不安全的。只有当您完全信任任何能够连接到主服务器的计算机时，才能使用它。

Puppet 还使用自定义策略可执行文件提供了基于策略的自动签名接口，该接口比 `autosign.conf`  更灵活、更安全，但配置起来更复杂。

##### 路径

Puppet 默认在 `$confdir/autosign.conf` 中查找 `autosign.conf` 。要更改此路径，请在 `puppet.conf` 的 `[primary server]` 部分配置自动签名设置。

默认的 confdir 路径取决于您的操作系统。

> Note:
>
> `autosign.conf` 文件不能由主服务器用户帐户执行。如果 `autosign` 设置指向可执行文件，Puppet 会将其视为自定义策略可执行文件（即使它包含有效的 `autosign.conf`  allowlist）。

##### 格式

`autosign.conf` file is a line-separated list of certnames or domain name globs. 每行表示一个节点名或一组节点名，CA 主服务器会自动为其签署证书请求。

```http
rebuilt.example.com
*.scratch.example.com
*.local
```

Domain name globs do not function as normal globs: an asterisk can only represent one                or more subdomains at the front of a certname that resembles a fully qualified                domain name (FQDN). 域名globs不起正常globs的作用：星号只能表示证书名前面的一个或多个子域，该域名类似于完全限定的域名（FQDN）。如果您的证书名看起来不像 FQDN，the `autosign.conf` allowlist might not be effective.autosign.conf allowlist可能无效。

> Note: The `autosign.conf` file                    can safely be an empty file or not-existent, even if the `autosign` setting is enabled. An empty or                        non-existent `autosign.conf` file is                    an empty allowlist, meaning that Puppet does not                    autosign any requests. If you create `autosign.conf` as a non-executable file and add certnames to                    it, Puppet then automatically uses the file to                    allow incoming requests without needing to modify `puppet.conf`. 
>
> 即使启用了自动签名设置，autosign.conf文件也可以是空文件或不存在。空的或不存在的autosign.conf文件是空的allowlist，这意味着Puppet不会对任何请求进行自动签名。如果将autosign.conf创建为不可执行文件并向其中添加证书名，Puppet将自动使用该文件来允许传入请求，而无需修改Puppet.conf。

要显式禁用自动签名，请在 CA 主服务器 `puppet.conf` 的 `[primary server]` 部分设置 `autosign = false` ，即使存在 `autosign.conf` 或自定义策略可执行文件，也会禁用 CA 自动签名

#### csr_attributes.yaml

`csr_attributes.yam` 文件可以设置：

- CSR 属性（用于预验证请求的瞬时数据）
- 证书扩展请求（要嵌入签名证书中的永久数据）

仅当创建新 CSR 时，例如当代理节点首次尝试加入 Puppet 部署时，才会查阅此文件。它无法修改现有证书。

##### 路径

默认情况下，`csr_attributes.yaml` 文件位于 `$confdir/csr_attributes.yaml` 。其位置可通过 `csr_attributes` 设置进行配置。

`confdir` 的位置取决于您的操作系统。

##### 示例

```yaml
---
custom_attributes:
  1.2.840.113549.1.9.7: 342thbjkt82094y0uthhor289jnqthpc2290
extension_requests:
  pp_uuid: ED803750-E3C7-44F5-BB08-41A04433FE2E
  pp_image_name: my_ami_image
  pp_preshared_key: 342thbjkt82094y0uthhor289jnqthpc2290
```

##### 格式

`csr_attributes` 文件必须是包含以下一个或两个键的YAML哈希：

- `custom_attributes`               
- `extension_requests`               

每个键的值也必须是哈希，其中：

- 每个键都是有效的对象标识符（OID）。注意，Puppet-specific OID 可以可选地通过短名称而不是数字 ID 来引用。在上面的示例中，`pp_uuid` 是 Puppet-specific OID 的短名称。
- 每个值都是可以转换为字符串的对象。也就是说，允许数字，但不允许数组。

##### Allowed OIDs for custom attributes 自定义属性允许的OID

自定义属性可以使用任何公共或特定于站点的Custom attributes can use any public or site-specific OID, 用于核心 X.509 功能的 OID 除外。you can’t re-use existing OIDs for things like subject alternative names.这意味着您不能将现有OID用于主题替代名称等内容。

一个有用的 OID 是 “challengePassword” 属性 — `1.2.840.113549.1.9.7` 。This is a rarely-used corner of X.509 which can be            repurposed to hold a pre-shared key. 这是X.509的一个很少使用的角落，可以重新调整用途以保存预共享密钥。The benefit of using this instead of an arbitrary            OID is that it appears by name when using OpenSSL to dump the CSR to text; OIDs               that `openssl req` can’t recognize are            displayed as numerical strings.使用这个而不是任意OID的好处是，当使用OpenSSL将CSR转储为文本时，它按名称显示；openssl-req无法识别的OID显示为数字字符串。

还要注意，下面列出的 Puppet-specific OID 也可以用于 CSR 属性。









私有范围可用于您想要嵌入到其他地方尚未广泛使用的证书中的任何信息。它是完全不受监管的，预计其内容在每个木偶部署中都会有所不同。

“pp Reg Cert Ext”OID范围包含以下OID。

数字ID短名称描述性名称

##### Allowed OIDs for extension requests 允许的扩展请求OID

Extension request OIDs **must** be under the “ppRegCertExt” (`1.3.6.1.4.1.34380.1.1`) or “ppPrivCertExt” (`1.3.6.1.4.1.34380.1.2`) OID arcs.扩展请求OID必须在“pp Reg Cert Ext”（1.3.6.1.4.1.4380.1.1）或“pp Priv Cert Exte”（1.3.2.4.1.1.4380.1.2）OID弧下。

Puppet provides several registered OIDs (under            “ppRegCertExt”) for the most common kinds of extension information, as well as a private            OID range (“ppPrivCertExt”) for site-specific extension information. The benefits of            using the registered OIDs are:

Puppet为最常见的扩展信息类型提供了几个已注册的OID（在“pp Reg Cert Ext”下），并为特定站点的扩展信息提供了专用OID范围（“pp Priv Cert Exte”）。使用注册OID的好处是：

- They can be referenced in `csr_attributes.yaml` using their short names instead of their                  numeric IDs.
- 可以在csr attributes.yaml中使用它们的短名称而不是数字ID来引用它们。
- 当使用 Puppet 工具打印证书信息时，它们使用描述性名称而不是数字 ID 显示。

The private range is available for any information you want to embed into a certificate            that isn’t already in wide use elsewhere. It is completely unregulated, and its contents            are expected to be different in every Puppet deployment.

The “ppRegCertExt” OID range contains the following OIDs. 

私有范围可用于您想要嵌入到其他地方尚未广泛使用的证书中的任何信息。它是完全不受监管的，预计其内容在每个木偶部署中都会有所不同。

“pp Reg Cert Ext”OID范围包含以下OID。

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

“pp Auth Cert Ext”OID范围包含以下OID：

| 1.3.6.1.4.1.34380.1.3.1  | `pp_authorization` | Certificate extension authorization                          |
| ------------------------ | ------------------ | ------------------------------------------------------------ |
| 1.3.6.1.4.1.34380.1.3.13 | `pp_auth_role`     | Puppet node role name for authorization.                           For PE internal use only. |

#### custom_trusted_oid_mapping.yaml

It is only valid on a primary Puppet server. In Puppet apply, the compiler doesn’t add certificate extensions        to `$trusted.`    

##### 证书扩展

当节点请求证书时，它可以要求 CA 在该证书中包含一些附加的永久元数据。Puppet 代理使用 `csr_attributes.yaml` 文件来决定要请求的扩展名。

If the CA signs a certificate with extensions included, those extensions are available        as trusted facts in the top-scope `$trusted` variable. 如果CA签署了包含扩展名的证书，则这些扩展名在顶级作用域$trusted变量中作为可信事实提供。然后，清单或节点分类器可以使用这些可信事实来决定哪些节点可以接收哪些配置。Your manifests or node classifier can then use those        trusted facts to decide which nodes can receive which configurations.

By default, the [           Puppet-specific registered OIDs](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions) appear as keys        with convenient short names in the `$trusted[extensions]` hash, and any other OIDs appear as raw numerical IDs.        You can use the `custom_trusted_oid_mapping.yaml` file to map other OIDs to short names, which        replaces the numerical OIDs in `$trusted[extensions]`.默认情况下，特定于Puppet的注册OID在$trusted[extensions]哈希中显示为具有方便快捷名称的密钥，而其他OID显示为原始数字ID。您可以使用自定义的trusted-oidmapping.yaml文件将其他oid映射到短名称，这将替换$trusted[extensions]中的数字oid。

Run `puppetserver ca print` to see changes made in          `custom_trusted_oid_mapping.yaml` immediately without a        restart.立即运行puppetserver ca print，查看自定义受信任oid mapping.yaml中所做的更改，无需重新启动。

 For more information, see [CSR attributes and certificate extensions](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions), [Trusted           facts](https://www.puppet.com/docs/puppet/7/lang_facts_and_builtin_vars.html), [The `csr_attributes.yaml` file](https://www.puppet.com/docs/puppet/7/config_file_csr_attributes.html). 

##### Limitations of OID mapping OID映射的限制

Mapping OIDs in this file **only** affects the keys in the `$trusted[extensions]` hash. It does not affect what an agent        can request in its `csr_attributes.yaml` file —        anything but Puppet-specific registered extensions must still        be numerical OIDs.

After setting custom OID mapping values and restarting puppetserver, you can reference        variables using only the short name.

映射此文件中的OID仅影响$trusted[extensions]哈希中的密钥。它不会影响代理可以在其csr attributes.yaml文件中请求什么-除了Puppet特定的注册扩展名之外，其他任何内容都必须是数字OID。

设置自定义OID映射值并重新启动puppetserver后，您可以仅使用短名称引用变量。

##### 路径

The OID mapping file is located at `$confdir/custom_trusted_oid_mapping.yaml` by default. Its location is        configurable with the `trusted_oid_mapping_file` setting.

The location of the `confdir` depends on your        OS. 

默认情况下，OID映射文件位于$confdir/custom trusted OID mapping.yaml。其位置可通过受信任的oid映射文件设置进行配置。

confdir的位置取决于您的操作系统。

##### 示例

```yaml
---
oid_mapping:
  1.3.6.1.4.1.34380.1.2.1.1:
    shortname: 'myshortname'
    longname: 'My Long Name'
  1.3.6.1.4.1.34380.1.2.1.2:
    shortname: 'myothershortname'
    longname: 'My Other Long Name'
```

##### 格式

The `custom_trusted_oid_mapping.yaml` must be a        YAML hash containing a single key called `oid_mapping`.自定义受信任的oid-mapping.yaml必须是一个yaml散列，其中包含一个称为oid-mapping的密钥。

The value of the `oid_mapping` key must be a hash        whose keys are numerical OIDs. The value for each OID must be a hash with two keys:

oid映射键的值必须是其键为数字oid的哈希。每个OID的值必须是具有两个键的哈希：

- `shortname` for the case-sensitive one-word name that            is used in the `$trusted[extensions]` hash.
- `longname` for a more descriptive name (not used            elsewhere).



$trusted[extensions]哈希中使用的区分大小写的单字名的缩写。

longname表示更具描述性的名称（其他地方不使用）。

#### device.conf





##### 路径

默认情况下， `device.conf` 文件位于 `$confdir/device.conf` ，其位置可通过 deviceconfig 设置进行配置。

`confdir` 的位置取决于您的操作系统。

##### 格式

`device.conf` 文件是一个类似 INI 的文件，每个设备有一个节：

```ini
[device001.example.com]
type cisco
url ssh://admin:password@device001.example.com
debug
```

The section name specifies the `certname` of                the device.节名指定设备的证书名。

The values for the `type` and `url` properties are specific to each type of                device.类型和url属性的值特定于每种类型的设备。

The the optional `debug` property specifies                transport-level debugging, and is limited to telnet and ssh transports.可选的debug属性指定传输级调试，并且仅限于telnet和ssh传输。

对于Cisco设备， `url` 的格式如下：

```ini
scheme://user:password@hostname/query
```

具有：

- Scheme: either `ssh` or `telnet`   方案：ssh或telnet
- user: optional connection username, depending on the device configuration user：可选连接用户名，取决于设备配置
- password: connection password  密码：连接密码
- query: optional `?enable= `parameter                        whose value is the enable password  查询：可选？enable=值为启用密码的参数

Note: Reserved non-alphanumeric characters in the `url` must be percent-encoded.  注意：`url` 中保留的非字母数字字符必须以百分比编码。

#### routes.yaml

The `routes.yaml` file makes it possible to use certain extensions to Puppet, most notably PuppetDB.      Usually you edit this file only to make changes that are explicitly specified by the setup      instructions for an extension you are trying to install.routes.yaml文件可以使用Puppet的某些扩展名，尤其是Puppet DB。通常，编辑此文件只是为了进行由尝试安装的扩展的安装说明明确指定的更改。

##### 路径

默认情况下， `routes.yaml` 文件位于 `$confdir/routes.yaml` 。其位置可通过 `route_file` 设置进行配置。

`confdir` 的位置取决于您的操作系统。

##### 示例

```yaml
---
server:
  facts:
    terminus: puppetdb
    cache: yaml
```

##### 格式

`routes.yaml` 文件是一个 YAML 散列。

Each top level key is the name of a run mode (`server`, `agent`, or `user`), and its value is another hash.每个顶级密钥是运行模式（服务器、代理或用户）的名称，其值是另一个哈希值。

Each key of the second-level hash is the name of an indirection, and its value is another        hash.第二级哈希的每个键都是间接寻址的名称，其值是另一个哈希。

The only keys allowed in the third-level hash are `terminus` and `cache`. The value of each        of these keys is the name of a valid terminus for the indirection named above.第三级哈希中允许的唯一键是terminal和cache。这些键中的每个键的值都是上述间接寻址的有效终点的名称。

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

### 添加文件服务器装载点

Puppet Server 包括一个文件服务器，用于将静态文件内容传输到代理。如果您需要提供不希望存储在源代码管理中或与模块一起分发的大型文件，可以创建一个自定义文件服务器装载点，让 Puppet 从另一个目录提供这些文件。

In Puppet code, you can tell the file server is being used when you see            a `file` resource that has            a `source =>         puppet:///...` attribute specified. 在 Puppet 代码中，当您看到一个具有源代码=>的文件资源时，您可以知道正在使用文件服务器puppet:///...指定的属性。

要设置装载点，请执行以下操作：

1. 在磁盘上为装载点选择一个目录，确保 Puppet Server 可以访问它，并将文件添加到该目录。
2. 在 Puppet Server 节点上编辑 `fileserver.conf`  ，以便 Puppet 知道要与新装载点关联的目录。
3. (可选）编辑 Puppet Server 的 `auth.conf` 以允许访问新的装载点。

 After the mount point is set up, Puppet code can reference the files you added to the         directory at `puppet:///<MOUNT POINT>/<PATH>`.

安装点设置后，Puppet代码可以引用您添加到Puppet:///＜mount point＞/＜PATH＞目录中的文件。

#### Puppet URI 中的装入点

Puppet URI 看起来像这样： `puppet://<SERVER>/<MOUNT POINT>/<PATH>` 。

The `<SERVER>` is optional, so it common practice to use               `puppet:///` URIs with three slashes. Usually, there is no reason to            specify the server. For Puppet agent,               `<SERVER>` defaults to the value of the server setting. For Puppet apply, `<SERVER>` defaults to            a special mock server with a modules mount point. 是可选的，因此通常使用带有三个斜杠的puppet:///URI。通常，没有理由指定服务器。对于Puppet代理，默认为服务器设置的值。对于Puppet apply，默认为具有模块装载点的特殊模拟服务器。

`<MOUNT POINT>` 是某些文件集合的唯一标识符。有不同种类的装载点：

- Custom mount points correspond to a directory that you specify.自定义装载点对应于您指定的目录。
- The `task` mount point works in a similar way to the                        `modules` mount point but for files that live under the                     modules `tasks` directory, rather than the                        `files` directory. 任务装载点的工作方式与模块装载点类似，但适用于位于模块任务目录而不是文件目录下的文件。
- The special `modules` mount point serves files from the                        `files` directory of every module. It behaves as if someone                     had copied the `files` directory from every module into one big                     directory, renaming each of them with the name of their module. For example,                     the files in `apache/files/...` are available at                        `puppet:///modules/apache/...`. 特殊模块装载点为每个模块的文件目录中的文件提供服务。它的行为就像有人将文件目录从每个模块复制到一个大目录中，并用模块的名称重命名每个模块。例如，apache/files/中的文件。。。可在puppet:///modules/apache/....
- The special `plugins` mount point serves files from the                        `lib` directory of every module. It behaves as if someone had                     copied the contents of every `lib` directory into one big                     directory, with no additional namespacing. Puppet agent uses this mount point when syncing plugins before a run, but there’s                     no reason to use it in a `file` resource. 特殊的插件安装点为每个模块的lib目录中的文件提供服务。它的行为就像有人将每个lib目录的内容复制到一个大目录中，没有额外的命名空间。Puppet代理在运行前同步插件时使用此装载点，但没有理由在文件资源中使用它。
- The special `pluginfacts` mount point serves files from the                        `facts.d` directory of every module to support external                     facts. It behaves like the `plugins` mount point, but with a                     different source directory. 特殊的pluginfacts装载点为每个模块的facts.d目录中的文件提供服务，以支持外部事实。它的行为类似于插件装载点，但具有不同的源目录。
- The special `locales` mount point serves files from the                        `locales` directory of every module to support automatic                     downloading of module translations to agents. It also behaves like the                        `plugins` mount point, and also has a different source                     directory. 特殊的locales装载点为每个模块的locales目录中的文件提供服务，以支持将模块翻译自动下载到代理。它的行为也类似于插件安装点，并且具有不同的源目录。

`<PATH>` is the remainder of the path to the file, starting from            the directory (or imaginary directory) that corresponds to the mount point.

＜PATH＞是文件路径的剩余部分，从对应于装载点的目录（或虚拟目录）开始。

#### 在 `fileserver.conf` 中创建新的装载点

`fileserver.conf` 文件使用以下语法定义装载点：

```ini
[<NAME OF MOUNT POINT>]
    path <PATH TO DIRECTORY>
```

In the following example, a file at               `/etc/puppetlabs/puppet/installer_files/oracle.pkg` would be available            in manifests as            `puppet:///installer_files/oracle.pkg`:在下面的示例中，/etc/puppetlabs/puppet/installer-files/oracle.pkg文件可以在清单中找到puppet:///installer文件/oracle.pkg：

```ini
[installer_files]
    path /etc/puppetlabs/puppet/installer_files
```

Make sure that the `puppet` user has the right permissions to access that            directory and its contents. 确保木偶用户具有访问该目录及其内容的权限。

CAUTION: Always restrict write access to mounted directories. The file               server follows any symlinks in a file server mount, including links to files that               agent nodes cannot access (such as SSL keys). When following symlinks, the file               server can access any files readable by Puppet Server’s user               account.

注意：始终限制对已装载目录的写入访问。文件服务器遵循文件服务器装载中的任何符号链接，包括指向代理节点无法访问的文件的链接（如SSL密钥）。当遵循符号链接时，文件服务器可以访问Puppet server用户帐户可读的任何文件。

#### Controlling access to a custom mount point in `auth.conf ` 控制对auth.conf中自定义装载点的访问

By default, any node with a valid certificate can access the files in your new mount            point. If a node can fetch a catalog, it can fetch files. If the node can’t fetch a            catalog, it can’t fetch files. This is the same behavior as the special               `modules` and `plugins` mount points. If necessary, you            can restrict access to a custom mount point in `auth.conf`.默认情况下，任何具有有效证书的节点都可以访问新装载点中的文件。如果节点可以获取目录，则可以获取文件。如果节点无法获取目录，则无法获取文件。这与特殊模块和插件安装点的行为相同。如有必要，可以限制对auth.conf中自定义装载点的访问。

To add a new auth rule to Puppet Server’s HOCON-format               `auth.conf file`, located at               `/etc/puppetlabs/puppetserver/conf.d/auth.conf`. , you must meet the            following requirements: 要向Puppet Server的HOCON格式auth.conf文件（位于/etc/puppetlabs/puppetserver/conf.d/auth.conf）添加新的身份验证规则，必须满足以下要求：

- It must match requests to all four of these prefixes: 它必须将请求与以下四个前缀匹配：
  - `/puppet/v3/file_metadata/<MOUNT POINT>`                        
  - `/puppet/v3/file_metadatas/<MOUNT POINT>`                        
  - `/puppet/v3/file_content/<MOUNT POINT>`                        
  - `/puppet/v3/file_contents/<MOUNT POINT> `                        
- Its `sort-order` must be lower than 500, so that it overrides                     the default rule for the file server. 其排序顺序必须低于500，以便覆盖文件服务器的默认规则。

例如：

```ini
{
    # Allow limited access to files in /etc/puppetlabs/puppet/installer_files:
    match-request: {
        path: "^/puppet/v3/file_(content|metadata)s?/installer_files"
        type: regex
    }
    allow: "*.dev.example.com"
    sort-order: 400
    name: "dev.example.com large installer files"
},
```

### 检查设置值

Puppet 设置是高度动态的，其值可以来自几个不同的地方。要查看 Puppet 服务使用的实际设置值，请运行 `puppet config print` 命令。

#### 一般用途

`puppet config print` 命令加载和评估设置，并可以在执行此操作时模仿 Puppet 的任何其他命令和服务。`--section` 和 `--environment` 选项允许您控制如何加载设置。

注意：为了确保您看到 Puppet 作为服务运行时使用的值，请确保使用 sudo 或以 root / Administrator 身份运行命令。如果您以其他用户的身份运行 `puppet config print` ，Puppet 可能不会使用系统配置文件。

要查看一个设置的值： 

```bash
sudo puppet config print <SETTING NAME> [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]
```

This        displays just the value of `<SETTING          NAME>`.

要查看多个设置的值：

```bash
sudo puppet config print <SETTING 1> <SETTING 2> [...] [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]
```

This          displays `name = value` pairs for all requested        settings.这将显示所有请求设置的名称=值对。

要查看所有设置的值：  

```bash
sudo puppet config print [--section <CONFIG SECTION>] [--environment <ENVIRONMENT>]
```

This          displays `name = value` pairs for all        settings.

这将显示所有设置的名称=值对。   

#### 配置部分

The `--section` option specifies which section of `puppet.conf` to use when finding settings. It is optional, and        defaults to `main`. Valid sections are: --section选项指定查找设置时要使用puppet.conf的哪个部分。它是可选的，默认为main。有效部分包括：

- ​              `main` (default) — used by all commands and services            main（默认）-由所有命令和服务使用
- ​              `server` — used by the primary Puppet server service and the `puppetserver ca` command 服务器-由主要木偶服务器服务和木偶服务器ca命令使用
- ​              `agent` — used by the Puppet agent service 代理-由木偶代理服务使用
- ​              `user` — used by the Puppet apply command and most other commands user-由Puppet apply命令和大多数其他命令使用

通常，如果其他部分包含设置，则会覆盖 `main` 部分；如果没有，则使用 `main` 的值，或者如没有设置，使用默认值。

#### 环境

`--environment` 选项指定查找设置时要使用的环境。它是可选的，默认为 `user` 部分中 `environment` 设置的值（通常是 `production`，因为很少在 `user` 中指定环境）。

只能指定存在的环境。

This option is primarily useful when looking up settings used by the primary server        service, because it’s rare to use environment config sections for Puppet apply and Puppet        agent.该选项在查找主服务器服务使用的设置时非常有用，因为很少使用Puppet应用和Puppet代理的环境配置部分。

#### Imitating Puppet server and `puppetserver ca`       模仿木偶服务器和木偶服务器ca

To see the settings the Puppet server service and the          `puppetserver ca` command would use:要查看设置，木偶服务器服务和木偶服务器ca命令将使用：

- 指定 `--section server` 。
- 使用 `--environment` 选项指定要设置的环境，或将其默认为`production`环境。
- 记住使用 `sudo` 。
- If your primary Puppet server is managed as a Rack            application (for example, with Passenger), check the `config.ru` file to make sure it’s using the [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and [vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html) that you expect. If it’s using            non-standard ones, you need to specify them on the command line with the `--confdir` and `--vardir`            options; otherwise you might not see the correct values for settings.
- 如果您的主要Puppet服务器作为Rack应用程序进行管理（例如，使用Passenger），请检查config.ru文件，以确保它使用了您期望的confdir和vardir。如果它使用非标准的，则需要在命令行上使用--confdir和--vardir选项指定它们；否则您可能看不到正确的设置值。

To see the effective [modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html) used in the `dev`        environment:        要查看开发环境中使用的有效模块路径，请执行以下操作：

```bash
sudo puppet config print modulepath --section server --environment dev
```

This        returns something        like:这将返回如下内容：

```bash
/etc/puppetlabs/code/environments/dev/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules
```

To see whether PuppetDB is configured for exported        resources:        要查看是否为导出的资源配置了Puppet DB：

```bash
sudo puppet config print storeconfigs storeconfigs_backend --section server
```

This returns something        like:这将返回如下内容：

```bash
storeconfigs = true
storeconfigs_backend = puppetdb
```

#### Imitating Puppet agent模仿木偶代理

To see the settings the Puppet agent service would use: 要查看木偶代理服务将使用的设置：

- 指定 `--section agent` 。
- 记住使用 `sudo` 。
- If you are seeing something unexpected, check your Puppet agent init script or cron job to make sure it is              using the standard [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and [vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html), is running as root, and isn’t overriding other              settings with command line options. If it’s doing anything unusual, you might have to              set more options for the `config print` command. 如果您看到意外情况，请检查Puppet代理init脚本或cron作业，以确保它使用标准的confdir和vardir，以root身份运行，并且没有使用命令行选项覆盖其他设置。如果它有任何异常，您可能需要为config print命令设置更多选项。

To see whether the agent is configured to use manifest ordering when applying the        catalog:要查看代理是否配置为在应用目录时使用清单排序，请执行以下操作：

```bash
sudo puppet config print ordering --section agent
```

这将返回如下内容：

```bash
manifest
```

#### Imitating `puppet apply`      模仿木偶应用

To see the settings the Puppet apply command would use: 要查看设置，木偶应用命令将使用：

- 指定 `--section` user. 
- 记住使用 `sudo` 。
- If you are seeing something unexpected, check the cron job or script that is              responsible for configuring the machine with Puppet              apply. Make sure it is using the standard [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html) and [vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html), is running as root, and isn’t overriding other              settings with command line options. If it’s doing anything unusual, you might have to              set more options for the `config print` command. 如果您看到意外情况，请检查负责使用Puppet-apply配置机器的cron作业或脚本。确保它使用标准的confdir和vardir，以root身份运行，并且没有使用命令行选项覆盖其他设置。如果它有任何异常，您可能需要为config print命令设置更多选项。

To see whether Puppet apply is configured to use        reports:要查看Puppet apply是否配置为使用报告：

```bash
sudo puppet config print report reports --section user
```

这将返回如下内容：

```bash
report = true
reports = store,http
```

### 在命令行上编辑设置

Puppet loads most of its settings from the `puppet.conf` config        file. You can edit this file directly, or you can change individual settings with            the `puppet config            set` command.Puppet从Puppet.conf配置文件加载其大部分设置。您可以直接编辑此文件，也可以使用木偶配置集命令更改单个设置。

Use `puppet                config set` for:使用木偶配置集：

- Fast one-off config changes,快速一次性配置更改，
- Scriptable config changes in provisioning                    tools,供应工具中的脚本化配置更改，

If you find yourself changing many settings, edit the `                puppet.conf            ` file instead, or manage it with a template.如果您发现自己更改了许多设置，请改为编辑puppet.conf文件，或使用模板管理它。

#### 用法

To assign a new value to a setting,                run:要为设置指定新值，请运行：

```bash
sudo puppet config set <SETTING NAME> <VALUE> --section <CONFIG SECTION>
```

This declaratively sets the value of `<SETTING                    NAME>` to `<VALUE>` in the specified config section, regardless of whether                the setting already had a value.这将在指定的配置部分中声明性地将＜SETTING NAME＞的值设置为＜value＞，而不管该设置是否已有值。

#### 配置部分

The `--section` option specifies                which section of `puppet.conf` to modify. It                is optional, and defaults to `main`. Valid                sections are:--section选项指定要修改puppet.conf的哪个部分。它是可选的，默认为main。有效部分包括：

- ​                        `main` (default) — used by all commands                        and services  main（默认）-由所有命令和服务使用
- ​                        `server` — used by the primary Puppet server service and the `puppetserver ca` command   服务器-由主要木偶服务器服务和木偶服务器ca命令使用
- ​                        `agent` — used by the Puppet agent service   代理-由木偶代理服务使用
- ​                        `user` — used by the `puppet apply` command and most other commands   user-由木偶应用命令和大多数其他命令使用

When modifying the [system config file](https://www.puppet.com/docs/puppet/7/dirs_confdir.html), use `sudo` or run the command as `root` or Administrator.修改系统配置文件时，请使用sudo或以root或Administrator身份运行命令。 

#### 示例

Consider the following `puppet.conf` file:                考虑以下puppet.conf文件：

```ini
[main]
certname = agent01.example.com
server = server.example.com
vardir = /var/opt/lib/pe-puppet

[agent]
report = true
graph = true
pluginsync = true

[server]
dns_alt_names = server,server.example.com,puppet,puppet.example.com
```

如果运行以下命令：

```bash
sudo puppet config set reports puppetdb --section server
sudo puppet config set ordering manifest
```

The `puppet.conf` file now looks like this:                

```ini
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

### 目录和文件

Puppet 由许多目录和文件组成，and        each one has an important role ranging from Puppet code        storage and configuration files to manifests and module paths.每个目录和文件都具有重要的作用，从Puppet代码存储和配置文件到清单和模块路径。

* Code and data directory (codedir)](https://www.puppet.com/docs/puppet/7/dirs_codedir.html)**
  The codedir is the main directory for Puppet code and       data. It is used by the primary Puppet server and Puppet apply, but not by Puppet       agent. It contains environments (which contain your manifests and modules) and a global       modules directory for all environments.
*  **[Config directory (confdir)](https://www.puppet.com/docs/puppet/7/dirs_confdir.html)**
           Puppet’s `confdir` is the main directory for the Puppet configuration. It contains configuration files and the         SSL data.
*  **[Main manifest directory](https://www.puppet.com/docs/puppet/7/dirs_manifest.html)**
  Puppet starts                         compiling a catalog either with a single manifest file or with a directory                         of manifests  that are treated like a single file. This starting point is                         called the *main                                     manifest* or *site                                     manifest*.
*  **[The modulepath](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html)**
  The primary server service and the `puppet       apply` command load most of their content from modules found in one or more       directories. The list of directories where Puppet looks       for modules is called the *modulepath*. The modulepath is set by the current node's       environment. 
* **[SSL directory (ssldir)](https://www.puppet.com/docs/puppet/7/dirs_ssldir.html)**
       Puppet stores its certificate infrastructure in     the SSL directory (ssldir) which has a similar structure on all Puppet nodes, whether they are agent nodes, primary Puppet servers, or the certificate authority (CA)     server.
*  **[Cache directory (vardir)](https://www.puppet.com/docs/puppet/7/dirs_vardir.html)**
  As part of its normal operations, Puppet generates data which is stored in a cache directory called     vardir.  You can mine the data in vardir for analysis, or use it to integrate  other tools with       Puppet. 

代码和数据目录（codedir）

codedir是Puppet代码和数据的主目录。它由主要木偶服务器和木偶应用程序使用，但不由木偶代理使用。它包含环境（包含清单和模块）和所有环境的全局模块目录。

配置目录（confdir）

Puppet的confdir是Puppet配置的主目录。它包含配置文件和SSL数据。

主清单目录

Puppet开始编译目录，要么使用单个清单文件，要么使用一个清单目录，这些清单被视为单个文件。此起点称为主清单或站点清单。

模块路径

主服务器服务和傀儡应用命令从一个或多个目录中找到的模块加载其大部分内容。Puppet查找模块的目录列表称为模块路径。模块路径由当前节点的环境设置。

SSL目录（ssldir）

Puppet将其证书基础结构存储在SSL目录（ssldir）中，该目录在所有Puppet节点上具有类似的结构，无论它们是代理节点、主要Puppet服务器还是证书颁发机构（CA）服务器。

缓存目录（vardir）

作为其正常操作的一部分，Puppet生成存储在名为vardir的缓存目录中的数据。您可以在vardir中挖掘数据进行分析，或使用它将其他工具与Puppet集成。

#### 代码和数据目录 (codedir)

codedir 是 Puppet 代码和数据的主目录。它由主要 Puppet 服务器和 Puppet apply 使用，但不由 Puppet 代理使用。它包含环境（包含清单和模块）和所有环境的全局模块目录。

##### 路径

codedir 位于以下位置之一：

- *nix: `/etc/puppetlabs/code`                  
- *nix non-root users: `~/.puppetlabs/etc/code`                  
- Windows: `%PROGRAMDATA%\PuppetLabs\code` (通常是 `C:\ProgramData\PuppetLabs\code`) 

当 Puppet 以 root 用户、具有管理员权限的 Windows 用户或 Puppet 用户身份运行时，它使用系统范围的 codedir 。当作为非 root 用户运行时，它使用该用户主目录中的 codedir 。

当以 root 或 Puppet 身份运行 Puppet 命令和服务时，请使用系统 codedir 。要使用与 Puppet 代理或主服务器相同的 codedir ，请使用 sudo 运行诸如 `puppet module` 之类的管理命令。  

要配置 codedir 的位置，请在 `puppet.conf` 文件中设置 codedir 设置，例如：   

```bash
codedir = /etc/puppetlabs/code
```

Important:                Puppet Server doesn't use the codedir setting in `puppet.conf`, and instead uses the `                  jruby-puppet.master-code-dir` setting in [                   `puppetserver.conf`                ](https://puppet.com/docs/puppetserver/latest/config_file_puppetserver.html). When using a non-default codedir, you must change both settings.

重要提示：Puppet Server不使用Puppet.conf中的codedir设置，而是使用puppetserver.conf中的jruby-Puppet.master-code-dir设置。使用非默认codedir时，必须同时更改这两个设置。

##### Interpolation of `$codedir`         $codedir的插值

The value of the codedir is discovered before other settings, so you can refer to it in            other `puppet.conf` settings by using the `$codedir` variable in the value. For example, the               `$codedir` variable is used as part of the value for the               `environmentpath` setting:            codedir的值是在其他设置之前发现的，因此您可以通过在值中使用$codedir变量在其他puppet.conf设置中引用它。例如，$codedir变量用作environmentpath设置值的一部分：

```bash
[server]
   environmentpath = $codedir/override_environments:$codedir/environments
```

This allows you to avoid absolute paths in your settings and keep your Puppet-related files together.这允许您避免设置中的绝对路径，并将与木偶相关的文件保存在一起。

##### 目录

codedir 包含环境，包括清单和模块，以及所有环境的全局模块目录。

代码和数据目录包括：

- ​                  [                      `environments`                   ](https://www.puppet.com/docs/puppet/7/environments_creating.html#environments_creating): Contains alternate versions of the `modules` and `manifests` directories, to                  enable code changes to be tested on smaller sets of nodes before entering                  production. 环境：包含模块和清单目录的替代版本，以使代码更改在进入生产之前能够在较小的节点集上进行测试。
- ​                  [                      `modules`                   ](https://www.puppet.com/docs/puppet/7/dirs_modulepath.html): The main directory for modules. modules：模块的主目录。

#### Config directory (confdir)

​        Puppet’s `confdir` is the main directory for the Puppet configuration. It contains configuration files and the        SSL data.

##### Location

The confdir is located in one of the following locations: 

- ​                            *nix root users: `/etc/puppetlabs/puppet`                        
- Non-root users: `~/.puppetlabs/etc/puppet`                        
- ​                            Windows: `%PROGRAMDATA%\PuppetLabs\puppet\etc` (usually `C:\ProgramData\PuppetLabs\puppet\etc`) 

When Puppet is running as `root`, a Windows user with administrator                privileges, or the `puppet` user, it uses a                system-wide confdir. When running as a non-root user, it uses a confdir in that                user's home directory. 

When running Puppet commands and services as `root` or `puppet`,                usually you want to use the system codedir. To use the same codedir as the Puppet agent or the primary Puppet server, run admin commands with `sudo`.

Puppet’s confdir can’t be set in the `puppet.conf`,                because Puppet needs the confdir to locate                that config file. Instead, run commands with the `--confdir` parameter to specify the confdir. If `--confdir` isn’t specified when a Puppet application                is started, the command uses the default confdir location.

​                Puppet Server uses the `jruby-puppet.server-conf-dir` setting in [                     `puppetserver.conf`                 ](https://puppet.com/docs/puppetserver/latest/config_file_puppetserver.html) to configure its confdir. If you are using a non-default confdir, you must                specify `--confdir` when you run commands like `puppet module` to ensure they use the same directories as                    Puppet Server.

##### Interpolation of `$confdir`            

The value of the confdir is discovered before other settings, so you can                reference it, using the `$confdir` variable,                in the value of any other setting in `puppet.conf`.

If you need to set nonstandard values for some settings, using the `$confdir` variable allows you to avoid absolute paths and                keep your Puppet-related files together.

##### Contents

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

#### Main manifest directory

Puppet starts                        compiling a catalog either with a single manifest file or with a directory                        of manifests that are treated like a single file. This starting point is                        called the *main                                    manifest* or *site                                    manifest*.

For more information about how the site manifest is                                    used in catalog compilation, see [Catalog                                                 compilation](https://www.puppet.com/docs/puppet/7/subsystem_catalog_compilation.html#subsystem_catalog_compilation).

##### Specifying the manifest for Puppet apply

The `puppet apply` command uses the manifest you pass to it        as an argument on the command line:

```
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
Copied!
```

You can pass Puppet apply either a single `.pp` file or a        directory of `.pp` files. Puppet apply uses the manifest you        pass it, not an environment's manifest. 

##### Specifying the manifest for primary Puppet        server

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

##### Manifest directory behavior

When the main manifest is a directory, Puppet parses every          `.pp` file in the directory in alphabetical order and        evaluates the combined manifest. It descends into all subdirectories of the manifest        directory and loads files in depth-first order. For example, if the manifest directory        contains a directory named `01`, and a file named `02.pp`, it parses the files in `01` before it parses `02.pp`.

Puppet treats the directory as one manifest, so, for        example, a variable assigned in the file `01_all_nodes.pp` is accessible in `node_web01.pp`.

Note: Puppet does not follow symlinks when the `manifest` setting refers to a directory.

#### The modulepath

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

##### Setting the modulepath and base modulepath

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

##### Using the `--modulepath` option with Puppet apply

When running  Puppet apply on the command line,            you can optionally specify a modulepath with the `--modulepath` option, which overrides the modulepath from the current            environment.

##### Absent, duplicate, and conflicting content from modules

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

#### SSL directory (ssldir)

​    Puppet stores its certificate infrastructure in    the SSL directory (ssldir) which has a similar structure on all Puppet nodes, whether they are agent nodes, primary Puppet servers, or the certificate authority (CA)    server.

##### Location

By default, the ssldir is a subdirectory of the [confdir](https://www.puppet.com/docs/puppet/7/dirs_confdir.html). 

You can change its location using the `ssldir` setting        in the `puppet.conf` file. See the [Configuration reference](https://www.puppet.com/docs/puppet/7/configuration.html) for more        information. 

Note: The content of the ssldir is generated, grows over time, and          is relatively difficult to replace. Some third-party Puppet          packages for Linux place the ssldir in the cache directory            ([vardir](https://www.puppet.com/docs/puppet/7/dirs_vardir.html)) instead of the confdir. When a          distro changes the ssldir location, it sets `ssldir` in the `$confdir/puppet.conf` file, usually in the `[main]` section. 

To see the location of the ssldir on one of your nodes, run: `puppet          config print ssldir`      

##### Contents

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

##### The ssldir directory structure

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

#### Cache directory (vardir)

As part of its normal operations, Puppet generates data which is stored in a cache directory called    vardir. You can mine the data in vardir for analysis, or use it to integrate other tools with      Puppet. 

##### Location

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

##### Interpolation of `$vardir`      

The value of the vardir is discovered before other settings, so you can reference        it using the `$vardir` variable in the value of any other        setting in `puppet.conf` or on the command line.

For example: 

```
[main]
  ssldir = $vardir/sslCopied!
```

If you need to set nonstandard values for some settings, using the `$vardir` variable allows you to avoid absolute paths and keep your Puppet-related files together.

##### Contents

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

### Report 参考

Puppet 有一组内置的报告处理器，您可以对其进行配置。

默认情况下，在应用目录后，Puppet 会生成一个报告，其中包含有关运行的信息：事件、日志消息、资源状态、度量和元数据。每个主机都将其报告作为 YAML 转储发送。

代理将其报告发送到主服务器进行处理，而运行 `puppet apply` 的代理则处理自己的报告。无论哪种方式，Puppet 都使用一组报告处理器处理每个报告，      这些处理器在代理的 `puppet.conf` 中的 `reports` 设置中指定。

默认情况下，Puppet 使用 `store` 报告处理器。您可以在 `reports` 设置中启用其他报告处理器或禁用报告。

#### http

Sends reports via HTTP or HTTPS. This report processor submits reports as POST requests to        the address in the `reporturl` setting. When you specify an        HTTPS URL, the remote server must present a certificate issued by the Puppet CA or the connection fails validation. The body of each        POST request is the YAML dump of a `Puppet::Transaction::Report` object, and the content type is set as `application/x-yaml`. 

通过HTTP或HTTPS发送报告。此报告处理器将报告作为POST请求提交到reporturl设置中的地址。指定HTTPS URL时，远程服务器必须提供Puppet  CA颁发的证书，否则连接验证失败。每个POST请求的主体是Puppet:：Transaction:：Report对象的YAML转储，内容类型设置为application/x-jaml。

#### log

Sends all received logs to the local log destinations. The usual log        destination is `syslog`.

将所有接收到的日志发送到本地日志目标。通常的日志目标是syslog。

#### store

Stores the `yaml` report in the configured          `reportdir`. By default, this is the report processor Puppet uses. These files collect quickly — one every half hour        — so be sure to perform maintenance on them if you use this report. 

将yaml报告存储在配置的reportdir中。默认情况下，这是Puppet使用的报告处理器。这些文件收集速度很快-每半小时收集一次-因此，如果使用此报告，请务必对其进行维护。

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

Puppet 由 Luke Kanies 和他的公司 Puppet Labs 开发，于 2005 年正式面世。
