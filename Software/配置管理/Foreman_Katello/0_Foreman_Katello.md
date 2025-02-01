# Foreman & Katello

[TOC]

## 概述

### Foreman

Foreman 是一个开源项目，一个完整的物理和虚拟服务器生命周期管理工具，从供应和配置到编排和监控。配置支持使您可以轻松控制设置新服务器，并使用配置管理（支持 Puppet，Ansible，Chef 和 Salt），可以轻松自动执行重复任务。快速部署应用程序以及主动管理本地或云中的服务器。可以很好地扩展到多个位置（办公室、数据中心等）和多个组织，使您能够在不丢失基础设施真相的情况下实现增长。

Foreman 提供了全面的交互工具，包括 Web 前端，CLI 和 RESTful API，使您能够在坚实的基础上构建更高级别的业务逻辑。它部署在许多组织中，管理从 10 到10，000 台服务器。一些商业产品是基于 Foreman 的。

Foreman installer 是一个 Puppet 模块的集合，为一个完整工作的 Foreman 设置，安装了所需的一切。它使用原生 OS 打包（例如，RPM 和 .deb 软件包），并为完整安装添加必要的配置。

组件包括 Foreman Web UI 、Smart Proxy 智能代理、Puppet 服务器以及可选的 TFTP 、DNS 和 DHCP 服务器。它是可配置的，并且 Puppet 模块可以在 “no-op” 模式下读取或运行，以查看它将进行哪些更改。

#### 高级概述

- 发现、调配和升级整个裸机基础架构。
- 在虚拟化环境中跨私有云和公共云创建和管理实例。
- 通过 PXE、本地介质或从模板、映像安装操作系统。
- 从配置管理软件控制和收集报告。
- 对主机进行分组并批量管理，而不考虑其位置。
- 查看历史更改以进行审核或故障排除。
- 用于 Linux 的 Web 用户界面、JSON REST API 和 CLI 。
- 通过强大的插件架构根据需要进行扩展。

#### 显著特点

**安装和可用性**

- **简单 POC 安装**: With a dedicated  one-command installer with answer file support and automation, Foreman  can be easily evaluated or customized as required.有了一个专用的一个命令安装程序与应答文件支持和自动化，福尔曼可以很容易地评估或定制的要求。
- **Plugin architecture插件架构**：大多数Foreman 功能是作为 Foreman Core 应用程序或 Foreman Proxy 服务的插件提供的。
- **Web 用户界面**：基于现代技术构建的强大 Web UI 。
- **API/CLI**：强大的 API ，整个基础设施可以通过外部工具进行管理。
- **Community powered**：Foreman 附带了许多由社区维护的配置和远程执行模板。

**库存**

- **主机清单**：托管服务器（节点）的清单。
- **Host groups**：Host grouping with common options, parameters and support for field inheritance.具有通用选项、参数和字段继承支持的主机分组。
- **NIC 发现**：Automatic creation of network  interfaces (regular, bond, bridge, VLAN), Operating System and  Architecture (according to facts reported by hosts).自动创建网络接口（常规、bond 、bridge 、VLAN）、操作系统和体系结构（根据主机报告的事实）。
- **Common search常见搜索**：Powerful search across whole application with smart completion.功能强大的搜索功能，在整个应用程序中实现智能完成。
- **书签**：将常用搜索查询保存为书签，以供重复使用。
- **Subnet & Domain inventory子网和域清单**：通过 Foreman Proxy DHCP 和 DNS 模块（包括 VLAN）管理任意数量的网络。
- **IPAM**：Manage DHCP reservations on various  providers like ISC DHCP, MS DHCP or Infoblox, free IP addresses can be  allocated on the fly or via Foreman database.管理各种提供商的DHCP保留，如ISC DHCP，MS DHCP或Infoblox，免费IP地址可以在飞行或通过Foreman数据库分配。
- **DNS和身份管理**：DNS or realm entries can be automatically created for each host in Foreman inventory.DNS或领域条目可以自动为Foreman库存中的每个主机创建。

**资源调配**

- **管理 PXE**：Foreman 提供了对 PXELinux、Grub、Grub 2 和 iPXE 的 PXE 配置的全面管理，以获得最大的网络引导的灵活性。
- **安装操作系统**：通过社区维护的大量模板和代码片段启动各种操作系统的无人值守配置。
- **构建虚拟机**：与 VMWare vCenter 、Red Hat Enterprise Virtualization 、oVirt 或 libvirt 等虚拟机管理程序集成，以便直接从 Foreman UI/API/CLI（从映像或通过 PXE ）创建实例。
- **创建云实例**：直接从 Foreman UI/API/CLI 与 OpenStack、Rackspace、Amazon EC2 或 Google Compute Engine 等云集成。
- **主机网络配置**：为已安装的主机创建网络配置的配置模板，包括 bond 、bridge 和 VLAN trunk 支持。
- **配置管理引导程序**：Template  snippets for bootstrapping initial configuration of configuration  management software.用于引导配置管理软件的初始配置的模板片段，包括使用 CA 签署客户端密钥。
- **IPv6**：Foreman 可以在非配置接口上管理 IPv6 地址（IPv6 上的 PXE 配置正在进行中）
- **模板引擎**：基于 ERB 的操作系统安装方法（Kickstart，Preseed），作业（SSH 脚本，Ansible 作业），分区方案和其他类型的模板。
- **计算资源**：用于与虚拟机管理程序和云基础架构集成的模块或插件。
- **计算配置文件**：跨多个云或虚拟化的通用计算配置文件（例如 xxsmall，large，medium）.

**服务器发现**

- **主机发现**：从网络或通过本地介质（ USB 记忆棒）引导未知硬件，并让其注册到 Foreman ，以进行自动或按需配置。
- **已发现节点的调配**：通过 WebUI/CLI/API 自动、半自动或全手动配置发现的硬件。

**大型团队支持**

- **主机参数**: 灵活的参数引擎，用于主机和关联对象（子网、域、主机组），具有动态生成的分层 Key/Value 映射（称为智能 Variables/Class 参数）。
- **Foreman proxies**: Components running inside data  centres, subnets or remote sites providing connection to managed nodes  and services using REST HTTPS API.工头代理人：在数据中心、以太网或远程站点内部运行的组件，使用REST HTTPS API提供与托管节点和服务的连接。
- **身份验证**：Username and password authentication with brute-force protection, POSIX LDAP, FreeIPA and MSAD authentication integration.：具有暴力保护的密码和密码身份验证，POSIX LDAP，FreeIPA和MSAD身份验证集成。
- **Authorization**: Fine-grained role-based access controls (RBAC) for users, roles, LDAP mapping授权：针对用户、角色和LDAP映射的细粒度基于角色的访问控制（RBAC）
- **Authorization filters**: Ability to assign authorization permissions to filtered objects (e.g. hostnames starting with ‘test-‘).授权过滤器：能够将授权权限分配给筛选的对象（例如以“test-”开头的主机名）。
- **多租户**：Foreman 中的大多数资源可以分配给组织和位置，作为多个组织或站点的灵活授权机制。
- **Kerberos**：Foreman支持为新主机自动创建 FreeIPA Realm 条目。
- **HTTP 代理**：用于托管节点或 Foreman 本身的某些通信。

**报告和监测**

- **Dashboard**: Fully configurable dashboard with widgets and statistics.完全可配置的仪表板与小部件和统计数据。
- **Facts**: Inventory of facts reported by configuration management agents (Facter, Ansible, Salt grains).事实：配置管理代理（Facter、Ansible、Salt grains）报告的事实清单。
- **Trends**: Track changes in Foreman infrastructure over time, including key Foreman resources or facts.趋势：跟踪领班基础设施随时间的变化，包括关键的领班资源或事实。
- **审计**：Detailed audit trail with per-field granularity and `diff` feature for config templates and reports.：详细的审计跟踪，每个字段的粒度和配置模板和报告的差异功能。
- **Report templates**: Thanks to report templates you  can generate custom text reports based on data that are available in  Foreman. The output can be csv, yaml, json. Templates can contain  additional logic and the report can be customized when it’s generated.
- 报告模板：得益于报告模板，您可以根据Foreman中提供的数据生成自定义文本报告。输出可以是csv，yaml，json。模板可以包含额外的逻辑，并且可以在生成报告时对其进行自定义。


**远程执行（插件）**

- **Job invocations**: Running arbitrary commands or  scripts on remote hosts using different providers, such as SSH or  Ansible. This includes scheduling future runs, recurring execution,  concurrency control, watching the progress and output live.
- 作业调用：在使用不同提供程序（如SSH或Ansible）的远程主机上运行任意命令或脚本。这包括调度未来的运行，重复执行，并发控制，观看进度和实时输出。

**Puppet 集成**

- **Puppet classes**: Ability to import and parse  Puppet source code base and recognize class parameters for deep mapping  integration through the application.
- **Puppet CA**: Integration with puppet CA for automatic, semi-automatic or fully automatic client cert sign process.
- **Puppet ENC**: Puppet node classifier (source of input) for Puppet Master.
- **Configuration reports**: Inventory of reports from configuration management systems with diff feature and runtime statistics and graphs.
- 傀儡职业：能够导入和解析Puppet源代码库，并识别类参数，以便通过应用程序进行深度映射集成。
  Puppet CA：与Puppet CA集成，用于自动，半自动或全自动客户端证书签名过程。
  Puppet ENC：Puppet Master的Puppet节点分类器（输入源）。
  配置报告：来自配置管理系统的报告清单，具有差异功能和运行时统计数据和图表。

**Ansible 集成（插件）**

- **Ansible roles**: Ability to import and parse  Ansible source code for deeper integration. In combination with remote  execution, provides configuration management like user experience with  Ansible. User assign roles to hosts/hostgroups and then enforces the  policy defined by these roles on a host. Every such Ansible run updates  host facts and generates new configuration report. Roles behaviour can  be customized by Foreman parametrization that is passed to the Ansible  inventory.
- **Ansible inventory**: Source inventory for Ansible.
- **Configuration reports**: Inventory of reports from configuration management systems with diff feature and runtime statistics and graphs.
- Ansible角色：能够导入和解析Ansible源代码以进行更深入的集成。与远程执行相结合，提供配置管理，如Ansible的用户体验。用户将角色分配给主机/主机组，然后在主机上强制执行由这些角色定义的策略。每次这样的Ansible运行都会更新主机事实并生成新的配置报告。角色行为可以通过传递到Ansible库存的Foreman参数化进行自定义。
  Ansible库存：Ansible的源库存。
  配置报告：来自配置管理系统的报告清单，具有差异功能和运行时统计数据和图表。

**Compliance management (plugin)**

- **Compliance management**: Define a compliance policy using OpenSCAP standards and tooling, and then enforce it in  infrastructure. Supports existing XCCDF profiles and tailoring of them  according to user needs.

- 合规管理（插件）

      合规管理：使用OpenSCAP标准和工具定义遵从性策略，然后在基础设施中实施。支持现有的XCCDF配置文件，并根据用户需求对其进行裁剪。

**内容管理（插件）**

- **Yum, deb, and Puppet Repositories**: Create,  organize, and manage local yum, deb, and puppet repositories. Sync  remote repositories or upload content directly to build a library of  content that serves as the basis for building custom builds of your  content.Yum、Deb和Puppet存储库：创建、组织和管理本地yum、deb和puppet仓库。同步远程存储库或直接上传内容，以构建内容库，作为构建内容的自定义构建的基础。
- **Content snapshots**: Take your local content and  filter out packages, errata and puppet modules to create custom builds  into units called Content Views. Make your custom builds available to  your hosts by moving it through environment paths that mimic traditional development workflows (Dev → QE → Stage → Production).内容快照：获取您的本地内容并过滤掉包、勘误表和傀儡模块，以创建自定义构建到称为内容视图的单元中。通过模拟传统开发工作流（Dev → QE → Stage → Production）的环境路径移动自定义构建，使其可用于主机。
- **Package and Errata Updates**: Use your locally managed content to install package and errata updates to a host or group of hosts.软件包和勘误表更新：使用本地管理的内容将软件包和勘误表更新安装到主机或主机组。
- **Host collections**: A mechanism to statically group multiple Content Hosts. This enables administrators to group Content  Hosts based on the needs of their organization. For example, Content  Hosts could be grouped by function, department or business unit.主机集合：一种静态分组多个内容队列的机制。这使管理员能够根据其组织的需要对内容管理进行分组。例如，内容管理可以按职能、部门或业务单位分组。
- **Standard Operating Environment**: Create and maintain a Standard Operating Environment (SOE).标准操作环境：创建和维护标准操作环境（SOE）。

已知以下操作系统可以从 Foreman 成功安装：

![](../../../Image/r/Redhat.png) Red Hat Enterprise Linux ![img](https://theforeman.org/static/images/os/Centos.png) CentOS ![img](https://theforeman.org/static/images/os/Fedora.png) Fedora ![img](https://theforeman.org/static/images/os/Ubuntu.png) Ubuntu ![img](https://theforeman.org/static/images/os/Debian.png) Debian ![img](https://theforeman.org/static/images/os/Solaris.png) Solaris 8, 10

![img](https://theforeman.org/static/images/os/Suse.png) OpenSUSE ![img](https://theforeman.org/static/images/os/Suse.png) SLES ![img](https://theforeman.org/static/images/os/Oracle.png) Oracle Linux ![img](https://theforeman.org/static/images/os/CoreOS.png) CoreOS ![img](https://theforeman.org/static/images/os/FreeBSD.png) FreeBSD ![img](https://theforeman.org/static/images/os/Junos.png) Junos

Foreman can provision on bare metal as well as the following cloud providers:Foreman可以在裸机上以及以下云提供商上进行配置：

![img](https://theforeman.org/static/images/clouds/amazonaws.png) Amazon EC2  ![img](https://theforeman.org/static/images/clouds/google-compute-engine.png) Google Compute Engine ![img](https://theforeman.org/static/images/clouds/libvirt.png) Libvirt  ![img](https://theforeman.org/static/images/clouds/openstack.png) OpenStack ![img](https://theforeman.org/static/images/clouds/ovirt.png) oVirt and RHEV  ![img](https://theforeman.org/static/images/clouds/rackspace.png) Rackspace ![img](https://theforeman.org/static/images/clouds/vsphere.png) VMware



### Katello

## Architecture

Foreman 安装将始终包含一个中央 Foreman 实例，负责提供基于 Web 的 GUI 、节点配置、初始主机配置文件等。但是，如果Foreman 安装支持无人值守安装，则需要执行其他操作以完全自动化此过程。Smart Proxy 管理远程服务，通常与所有 Foreman 安装一起安装，以管理 TFTP 、DHCP 、DNS 、Puppet 、Puppet CA 、Ansible 和 Salt 。

## Smart-Proxy

Smart-Proxy 位于执行特定功能的机器上或附近，帮助 Foreman 协调调试新主机的过程。将 Smart Proxy 放置在实际服务上或接近实际服务也有助于减少大型分布式组织中的延迟。

 ![](../../../Image/f/foreman_architecture.png)

#### 

