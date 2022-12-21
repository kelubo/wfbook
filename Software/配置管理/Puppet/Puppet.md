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

