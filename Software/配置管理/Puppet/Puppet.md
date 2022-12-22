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

但是，还有几个其他配置文件-如auth.conf和puppetdb.conf。这些文件存在的原因有几个：

主设置仅支持几种类型的值。有些东西没有复杂的数据结构就无法配置，因此需要单独的文件。（授权规则和自定义CSR属性属于此类别。）

Puppet不允许扩展将新设置添加到Puppet.conf中。这意味着一些被认为是主要设置的设置（例如Puppet DB服务器）不能是。



However, there are also several additional                configuration files — such as `auth.conf` and `puppetdb.conf`. These files exist for                several reasons: 

- The main settings support only a                            few types of values. Some things just can’t be configured without                            complex data structures, so they needed separate files. (Authorization                            rules and custom CSR attributes are in this category.)
- ​                            Puppet doesn’t allow extensions to add                            new settings to `puppet.conf`. This means some settings that                            are supposed to be main settings (such as the PuppetDB server) can’t be. 

##                 Puppet Server configuration

​                Puppet Server honors almost all settings in `puppet.conf` and picks them up automatically.                However, for some tasks, such as configuring the webserver or an external                Certificate Authority, there are Puppet Server-specific                configuration files and settings.

For more information, see [                     Puppet Server: Configuration](https://puppet.com/docs/puppet/7/configuration.html).

## Settings are loaded on startup

When a Puppet command or service starts up, it gets                values for all of its settings. Any of these settings can change the way that                command or service behaves.

A command or service reads its settings only one time. If you need to                reconfigured it, you must restart the service or run the command again after                changing the setting.

## Settings on the command line

Settings specified on the command line have top priority and always override                settings from the config file. When a command or service is started, you can                specify any setting as a command line option.

Settings require two hyphens and the name of the setting on the command line:                

```
$ sudo puppet agent --test --noop --certname temporary-name.example.comCopied!
```

## Basic settings

For most settings, you specify the option and follow it with a value. An equals sign                between the two `(=)` is optional, and you can                optionally put values in quotes.

All three of these are equivalent to setting `certname =                    temporary-name.example.com` in `puppet.conf`.

```
--certname=temporary-name.example.comCopied!
--certname temporary-name.example.comCopied!
--certname "temporary-name.example.com"Copied!
```

## Boolean settings

Settings whose only valid values are `true` and `false`, use a                shorter format. Specifying the option alone sets the setting to `true`. Prefixing the option with `no-` sets it to false.

This means: 

- ​                            `--noop` is equivalent to                            setting  `noop =                                true` in `puppet.conf`. 
- ​                            `--no-noop` is equivalent to                                setting `noop =                                false` in `puppet.conf`. 

## Default values

If a setting isn’t specified on the command line or in `puppet.conf`, it falls back to a default value. Default values for all                settings are listed in the configuration reference.

Some default values are based on other settings — when this is the case, the default                is shown using the other setting as a variable (similar to `$ssldir/certs`).

## Configuring locale settings

Puppet supports                locale-specific strings in output, and it detects your locale from your system                configuration. This provides localized strings, report messages, and log messages                for the locale’s language when available.

Upon startup, Puppet looks for                        a set of environment variables on *nix                        systems, or the code page setting on Windows.                        When Puppet finds one that is set, it uses                        that locale whether it is run from the command line or as a service.

For help setting your operating system locale or adding new                        locales, consult its documentation. This section covers setting the locale                        for Puppet services.

### Checking your locale settings on *nix                                and macOS

To check your current locale settings, run the `locale` command. This outputs                                the settings used by your current shell.                                

```
$ locale
LANG="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_ALL=Copied!
```

To see which locales are supported by your                                system, run `locale -a`, which                                outputs a list of available locales. Note that Puppet might not have localized                                strings for every available locale.

To check the current status of environment variables that might conflict                                with or override your locale settings, use the `set` command. For example, this                                command lists the set environment variables and searches for those                                        containing `LANG` or `LC_`:

```
sudo set | egrep 'LANG|LC_'Copied!
```

### Checking your locale settings on Windows

To check your current locale setting, run the `Get-WinSystemLocale` command from PowerShell.

```
PS C:\> Get-WinSystemLocale
LCID             Name             DisplayName
----             ----             -----------
1033             en-US            English (United States)Copied!
```

To                                check your system’s current code page setting, run the `chcp` command.

### Setting your locale on *nix with an                                environment variable

You can use environment variables to set your locale for processes                                started on the command line. For most Linux distributions, set                                        the `LANG` variable                                to your preferred locale, and the `LANGUAGE` variable to an empty string. On                                SLES, also set the `LC_ALL` variable to an empty string.

For example, to set the locale to Japanese for a terminal session on                                SLES:

```
export LANG=ja_JP.UTF-8
export LANGUAGE=''
export LC_ALL=''Copied!
```

To set the locale for the Puppet agent                                service, you can add these `export` statements to:

- `/etc/sysconfig/puppet` on RHEL and its                                                derivatives

- `/etc/default/puppet` on Debian, Ubuntu, and their                                                  derivatives

  After updating the file, restart the Puppet service to apply                                                  the change.

### Setting your locale for the Puppet                                agent service on macOS

To set the locale for the Puppet agent                                service on macOS, update                                        the `LANG` setting                                in the `/Library/LaunchDaemons/com.puppetlabs.puppet.plist` file.                                

```
<dict>
        <key>LANG</key>
        <string>ja_JP.UTF-8</string>
</dict>Copied!
```

After updating the file, restart the Puppet service to apply the                                change.

### Setting your locale on Windows

On Windows, Puppet uses the `LANG` environment variable if it                                is set. If not, it uses the configured region, as set in the                                Administrator tab of the Region control panel.

On Windows 10, you can use PowerShell to set the system                                locale:

```
Set-WinSystemLocale en-USCopied!
```

### Disabling internationalized strings

Use the optional Boolean `disable_i18n` setting to disable the use of                                internationalized strings. You can configure this setting                                        in `puppet.conf`. If set                                        to `true`, Puppet disables localized strings                                in log messages, reports, and parts of the command line interface.                                This can improve performance when using Puppet modules, especially                                        if [environment caching](https://puppet.com/docs/puppet/7/environments_creating.html#environments_creating) is                                disabled, and even if you don’t need localized strings or the                                modules aren’t localized. This setting is `false` by default in open source                                        Puppet.

If you’re experiencing performance issues, configure this setting in                                        the `[server]` section of the primary Puppet server's  `puppet.conf` file. To force                                unlocalized messages, which are in English by default, configure                                this section in a node’s `[main]` or `[user]` sections of `puppet.conf`.

​          

![img](moz-extension://e2e4c729-fe25-403a-a8cb-e6b819e0ad9b/assets/img/T.svg)

​          

Puppet by Perforce gives IT operations teams back their time 

### server

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

## 历史

Luke Kanies

Puppet Labs
