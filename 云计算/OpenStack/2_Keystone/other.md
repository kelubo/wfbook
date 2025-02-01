# Configuring Keystone 配置 Keystone

​                                          

## Identity sources[¶](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#identity-sources) 身份来源 ¶

One of the most impactful decisions you’ll have to make when configuring keystone is deciding how you want keystone to source your identity data. Keystone supports several different choices that will substantially impact how you’ll configure, deploy, and interact with keystone.
在配置 keystone 时，您必须做出的最有影响力的决策之一是决定您希望 keystone 如何获取您的身份数据。Keystone 支持多种不同的选择，这些选择将极大地影响您配置、部署 Keystone 以及与 Keystone 交互的方式。

You can also mix-and-match various sources of identity (see [Domain-specific Configuration](https://docs.openstack.org/keystone/yoga/admin/configuration.html#domain-specific-configuration) for an example). For example, you can store OpenStack service users and their passwords in SQL, manage customers in LDAP, and authenticate employees via SAML federation.
您还可以混合和匹配各种标识源（有关示例，请参阅特定于域的配置）。例如，您可以将 OpenStack 服务用户及其密码存储在 SQL 中，在 LDAP 中管理客户，并通过 SAML 联合对员工进行身份验证。

Summary 总结

| *Feature 特征*                                               | *Status 地位* | **LDAP LDAP协议**                                            | **OAuth v1.0a OAuth v1.0a 版**                               | **OpenID Connect OpenID 连接**                               | **REMOTE_USER**                                              | **SAML v2**                                                  | **SQL**                                                      |
| ------------------------------------------------------------ | ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [**Local authentication 本地身份验证**](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication) | optional 自选 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication_driver_ldap) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication_driver_oauth1) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication_driver_oidc) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication_driver_external) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication_driver_samlv2) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_local_authentication_driver_sql) |
| [**External authentication 外部身份验证**](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication) | optional 自选 | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication_driver_ldap) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication_driver_oauth1) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication_driver_oidc) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication_driver_external) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication_driver_samlv2) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_external_authentication_driver_sql) |
| [**Identity management 身份管理**](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud) | optional 自选 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud_driver_ldap) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud_driver_oauth1) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud_driver_oidc) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud_driver_external) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud_driver_samlv2) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_identity_crud_driver_sql) |
| [**PCI-DSS controls PCI-DSS 控制**](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls) | optional 自选 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls_driver_ldap) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls_driver_oauth1) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls_driver_oidc) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls_driver_external) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls_driver_samlv2) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_pci_controls_driver_sql) |
| [**Auditing 审计**](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing) | optional 自选 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing_driver_ldap) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing_driver_oauth1) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing_driver_oidc) | [`✖`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing_driver_external) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing_driver_samlv2) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/identity-sources.html#operation_auditing_driver_sql) |

Details 详

- Local authentication 本地身份验证

  **Status: optional.  状态：可选。**

  **Notes:** Authenticate with keystone by providing credentials directly to keystone.
  注意：通过直接向 keystone 提供凭据来使用 keystone 进行身份验证。

  **Driver Support: 驱动程序支持：**

  - **LDAP:** `complete` LDAP版本： `complete` 
  - **OAuth v1.0a:** `complete` OAuth v1.0a： `complete` 
  - **OpenID Connect:** `missing`
    OpenID 连接： `missing` 
  - **REMOTE_USER:** `missing` REMOTE_USER： `missing` 
  - **SAML v2:** `missing` SAML v2： `missing` 
  - **SQL:** `complete` SQL格式： `complete` 

  

- External authentication 外部身份验证

  **Status: optional.  状态：可选。**

  **Notes:** Authenticate with keystone by providing credentials to an external system that keystone trusts (as with federation).
  注意：通过向 keystone 信任的外部系统提供凭据（与联合身份验证一样），使用 keystone 进行身份验证。

  **Driver Support: 驱动程序支持：**

  - **LDAP:** `missing` LDAP版本： `missing` 
  - **OAuth v1.0a:** `missing` OAuth v1.0a： `missing` 
  - **OpenID Connect:** `complete`
    OpenID 连接： `complete` 
  - **REMOTE_USER:** `complete` REMOTE_USER： `complete` 
  - **SAML v2:** `complete` SAML v2： `complete` 
  - **SQL:** `missing` SQL格式： `missing` 

  

- Identity management 身份管理

  **Status: optional.  状态：可选。**

  **Notes:** Create, update, enable/disable, and delete users via Keystone’s HTTP API.
  注意：通过 Keystone 的 HTTP API 创建、更新、启用/禁用和删除用户。

  **Driver Support: 驱动程序支持：**

  - **LDAP:** `partial` LDAP版本： `partial` 
  - **OAuth v1.0a:** `complete` OAuth v1.0a： `complete` 
  - **OpenID Connect:** `missing`
    OpenID 连接： `missing` 
  - **REMOTE_USER:** `missing` REMOTE_USER： `missing` 
  - **SAML v2:** `missing` SAML v2： `missing` 
  - **SQL:** `complete` SQL格式： `complete` 

  

- PCI-DSS controls PCI-DSS 控制

  **Status: optional.  状态：可选。**

  **Notes:** Configure keystone to enforce PCI-DSS compliant security controls.
  注意：配置keystone以强制实施符合PCI-DSS的安全控制。

  **Driver Support: 驱动程序支持：**

  - **LDAP:** `partial` LDAP版本： `partial` 
  - **OAuth v1.0a:** `missing` OAuth v1.0a： `missing` 
  - **OpenID Connect:** `missing`
    OpenID 连接： `missing` 
  - **REMOTE_USER:** `partial` REMOTE_USER： `partial` 
  - **SAML v2:** `missing` SAML v2： `missing` 
  - **SQL:** `complete` SQL格式： `complete` 

  

- Auditing 审计

  **Status: optional.  状态：可选。**

  **Notes:** Audit authentication flows using PyCADF.
  注意：使用 PyCADF 审核身份验证流程。

  **Driver Support: 驱动程序支持：**

  - **LDAP:** `complete` LDAP版本： `complete` 
  - **OAuth v1.0a:** `missing` OAuth v1.0a： `missing` 
  - **OpenID Connect:** `complete`
    OpenID 连接： `complete` 
  - **REMOTE_USER:** `missing` REMOTE_USER： `missing` 
  - **SAML v2:** `complete` SAML v2： `complete` 
  - **SQL:** `complete` SQL格式： `complete` 

  

Notes: 笔记：

- **This document is a continuous work in progress
  本文档正在持续进行中**



# Bootstrapping Identity 引导标识

​                                          

After keystone is deployed and configured, it must be pre-populated with some initial data before it can be used. This process is known as bootstrapping and it typically involves creating the system’s first user, project, domain, service, and endpoint, among other things. The goal of bootstrapping is to put enough information into the system such that it can function solely through the API using normal authentication flows. After the first user is created, which must be an administrator, you can use that account to interact with keystone via the API.
部署和配置 keystone  后，必须先用一些初始数据进行预填充，然后才能使用。此过程称为引导，通常涉及创建系统的第一个用户、项目、域、服务和终结点等。引导的目标是将足够的信息放入系统中，以便它可以仅通过使用正常身份验证流程的 API 运行。创建第一个用户（必须是管理员）后，您可以使用该帐户通过 API 与 keystone 进行交互。

Keystone provides two separate ways to bootstrap a deployment. The first is with the `keystone-manage bootstrap` command. This is the preferred and recommended way to bootstrap new installations. The second, and original way of bootstrapping involves configuring a secret and deploying special middleware in front of the identity service. The secret is known as the `ADMIN_TOKEN`. Any requests made to the identity API with the `ADMIN_TOKEN` will completely bypass authentication allowing access to the entire API.
Keystone 提供了两种不同的方法来引导部署。首先是 `keystone-manage bootstrap` 命令。这是引导新安装的首选和推荐方法。第二种也是原始的引导方式涉及配置密钥并在标识服务前面部署特殊的中间件。该密钥称为 `ADMIN_TOKEN` .对身份 API 发出的任何请求 `ADMIN_TOKEN` 都将完全绕过身份验证，从而允许访问整个 API。

## Using the CLI[¶](https://docs.openstack.org/keystone/yoga/admin/bootstrap.html#using-the-cli) 使用 CLI ¶

The process requires access to an environment with keystone binaries installed, typically on the service host.
该过程需要访问安装了梯形二进制文件的环境，通常在服务主机上。

The `keystone-manage bootstrap` command will create a user, project and role, and will assign the newly created role to the newly created user on the newly created project. By default, the names of these new resources will be called `admin`.
该 `keystone-manage bootstrap` 命令将创建用户、项目和角色，并将新创建的角色分配给新创建的项目上的新创建的用户。默认情况下，这些新资源的名称将称为 `admin` 。

The defaults may be overridden by calling `--bootstrap-username`, `--bootstrap-project-name` and `--bootstrap-role-name`. Each of these have an environment variable equivalent: `OS_BOOTSTRAP_USERNAME`, `OS_BOOTSTRAP_PROJECT_NAME` and `OS_BOOTSTRAP_ROLE_NAME`.
可以通过调用 `--bootstrap-username` 和 `--bootstrap-project-name` 来覆盖默认值 `--bootstrap-role-name` 。它们中的每一个都有一个等效的环境变量： `OS_BOOTSTRAP_USERNAME` 、 和 `OS_BOOTSTRAP_PROJECT_NAME` `OS_BOOTSTRAP_ROLE_NAME` 。

A user password must also be supplied. This can be passed in as either `--bootstrap-password`, or set as an environment variable using `OS_BOOTSTRAP_PASSWORD`.
还必须提供用户密码。这可以作为 传入， `--bootstrap-password` 也可以使用 `OS_BOOTSTRAP_PASSWORD` 设置为环境变量。

Optionally, if specified by `--bootstrap-public-url`, `--bootstrap-admin-url` and/or `--bootstrap-internal-url` or the equivalent environment variables, the command will create an identity service with the specified endpoint information. You may also configure the `--bootstrap-region-id` and `--bootstrap-service-name` for the endpoints to your deployment’s requirements.
（可选）如果由 `--bootstrap-public-url` 和 `--bootstrap-admin-url` /或 `--bootstrap-internal-url` 等效环境变量指定，则该命令将使用指定的端点信息创建标识服务。您还可以根据部署的要求为终结点配置 `--bootstrap-region-id` 和 `--bootstrap-service-name` 。



 

Note 注意



We strongly recommend that you configure the identity service and its endpoints while bootstrapping keystone.
强烈建议您在引导 keystone 时配置标识服务及其终结点。

Minimally, keystone can be bootstrapped with:
最低限度，keystone 可以通过以下方式引导：

```
$ keystone-manage bootstrap --bootstrap-password s3cr3t
```

Verbosely, keystone can be bootstrapped with:
详细地说，keystone 可以通过以下方式引导：

```
$ keystone-manage bootstrap \
    --bootstrap-password s3cr3t \
    --bootstrap-username admin \
    --bootstrap-project-name admin \
    --bootstrap-role-name admin \
    --bootstrap-service-name keystone \
    --bootstrap-region-id RegionOne \
    --bootstrap-admin-url http://localhost:5000 \
    --bootstrap-public-url http://localhost:5000 \
    --bootstrap-internal-url http://localhost:5000
```

This will create an `admin` user with the `admin` role on the `admin` project and the system. This allows the user to generate project-scoped and system-scoped tokens which ensures they have full RBAC authorization. The user will have the password specified in the command.  Note that both the user and the project will be created in the `default` domain. By not creating an endpoint in the catalog users will need to provide endpoint overrides to perform additional identity operations.
这将创建一个具有 `admin` 项目和系统 `admin` 角色 `admin` 的用户。这允许用户生成项目范围和系统范围的令牌，从而确保他们具有完整的 RBAC 授权。用户将拥有命令中指定的密码。请注意，用户和项目都将在域中 `default` 创建。如果不在目录中创建端点，用户将需要提供端点覆盖才能执行其他标识操作。

This command will also create `member` and `reader` roles. The `admin` role implies the `member` role and `member` role implies the `reader` role. By default, these three roles are immutable, meaning they are created with the `immutable` resource option and cannot be modified or deleted unless the option is removed. To disable this behavior, add the `--no-immutable-roles` flag.
此命令还将创建 `member` 角色 `reader` 。 `admin` 角色意味着角色， `member`  `member` 角色意味着 `reader` 角色。默认情况下，这三个角色是不可变的，这意味着它们是使用 `immutable` resource 选项创建的，除非删除该选项，否则无法修改或删除。若要禁用此行为，请添加标志 `--no-immutable-roles` 。

By creating an `admin` user and an identity endpoint you may authenticate to keystone and perform identity operations like creating additional services and endpoints using the `admin` user. This will preclude the need to ever use or configure the `admin_token` (described below). It is also, by design, more secure.
通过创建 `admin` 用户和身份终端节点，您可以向 keystone 进行身份验证，并执行身份操作，例如使用用户 `admin` 创建其他服务和终端节点。这将排除使用或配置（ `admin_token` 如下所述）的需要。从设计上讲，它也更安全。

To test a proper configuration, a user can use OpenStackClient CLI:
要测试正确的配置，用户可以使用 OpenStackClient CLI：

```
$ openstack project list --os-username admin --os-project-name admin \
    --os-user-domain-id default --os-project-domain-id default \
    --os-identity-api-version 3 --os-auth-url http://localhost:5000 \
    --os-password s3cr3t
```

## Using a shared secret[¶](https://docs.openstack.org/keystone/yoga/admin/bootstrap.html#using-a-shared-secret) 使用共享密钥 ¶



 

Note 注意



We strongly recommended that you configure the identity service with the `keystone-manage bootstrap` command and not the `ADMIN_TOKEN`. The `ADMIN_TOKEN` can leave your deployment vulnerable by exposing administrator functionality through the API based solely on a single secret. You shouldn’t have to use `ADMIN_TOKEN` at all, unless you have some special case bootstrapping requirements.
强烈建议您使用 `keystone-manage bootstrap` 命令而不是 `ADMIN_TOKEN` .通过 `ADMIN_TOKEN` 仅基于单个机密的 API 公开管理员功能，可能会使部署容易受到攻击。您根本不需要使用 `ADMIN_TOKEN` ，除非您有一些特殊情况的引导要求。

Before you can use the identity API, you need to configure keystone with a shared secret. Requests made with this secret will bypass authentication and grant administrative access to the identity API. The following configuration snippet shows the shared secret as being `ADMIN`:
在使用身份 API 之前，您需要使用共享密钥配置 keystone。使用此密钥发出的请求将绕过身份验证并授予对身份 API 的管理访问权限。以下配置代码片段将共享密钥显示为 `ADMIN` ：

```
[DEFAULT]
admin_token = ADMIN
```

You can use the shared secret, or `admin_token`, to make API request to keystone that bootstrap the rest of the deployment.  You must create a project, user, and role in order to use normal user authentication through the API.
您可以使用共享密钥或 `admin_token` 向引导部署其余部分的 keystone 发出 API 请求。您必须创建项目、用户和角色，才能通过 API 使用普通用户身份验证。

The `admin_token` does not represent a user or explicit authorization of any kind. After bootstrapping, failure to remove this functionality exposes an additional attack vector and security risk.
不 `admin_token` 代表任何类型的用户或显式授权。引导后，如果无法删除此功能，则会暴露出额外的攻击媒介和安全风险。







# Keystone Configuration Keystone 配置

​                                          

Information and recommendations for general configuration of keystone for keystone administrators. See the main [Configuration](https://docs.openstack.org/keystone/yoga/configuration/index.html#keystone-configuration-options) section for complete keystone configuration documentation and sample config files.
有关 Keystone 管理员的 Keystone 常规配置的信息和建议。有关完整的梯形失真配置文档和示例配置文件，请参阅主要的配置部分。

## Troubleshoot the Identity service[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#troubleshoot-the-identity-service) 对 Identity 服务进行故障排除 ¶

To troubleshoot the Identity service, review the logs in the `/var/log/keystone/keystone.log` file.
若要对 Identity 服务进行故障排除，请查看文件中的 `/var/log/keystone/keystone.log` 日志。

Use the `/etc/keystone/logging.conf` file to configure the location of log files.
使用该 `/etc/keystone/logging.conf` 文件可以配置日志文件的位置。



 

Note 注意



The `insecure_debug` flag is unique to the Identity service. If you enable `insecure_debug`, error messages from the API change to return security-sensitive information. For example, the error message on failed authentication includes information on why your authentication failed.
该 `insecure_debug` 标志对于 Identity 服务是唯一的。如果启用 `insecure_debug` ，则来自 API 的错误消息将更改为返回安全敏感信息。例如，身份验证失败时的错误消息包括有关身份验证失败原因的信息。

The logs show the components that have come in to the WSGI request, and ideally show an error that explains why an authorization request failed. If you do not see the request in the logs, run keystone with the `--debug` parameter. Pass the `--debug` parameter before the command parameters.
日志显示已进入 WSGI 请求的组件，理想情况下会显示一个错误，解释授权请求失败的原因。如果在日志中未看到该请求，请使用该 `--debug` 参数运行 keystone。在命令参数之前传递 `--debug` 参数。

## Logging[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#logging) 日志记录 ¶

You configure logging externally to the rest of Identity. The name of the file specifying the logging configuration is set using the `log_config_append` option in the `[DEFAULT]` section of the `/etc/keystone/keystone.conf` file. To route logging through syslog, set `use_syslog=true` in the `[DEFAULT]` section.
您可以在外部配置 Identity 其余部分的日志记录。指定日志记录配置的文件的名称是使用文件部分中的 `log_config_append` 选项设置的 `/etc/keystone/keystone.conf` 。 `[DEFAULT]` 要通过 syslog 路由日志记录，请在 `[DEFAULT]` 该部分中设置 `use_syslog=true` 。

A sample logging configuration file is available with the project in `etc/logging.conf.sample`. Like other OpenStack projects, Identity uses the [Python logging module](https://docs.python.org/library/logging.html), which provides extensive configuration options that let you define the output levels and formats.
项目中 `etc/logging.conf.sample` 提供了一个示例日志记录配置文件。与其他 OpenStack 项目一样，Identity 使用 Python 日志记录模块，该模块提供了广泛的配置选项，可用于定义输出级别和格式。



## Domain-specific configuration[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#domain-specific-configuration) 特定于域的配置 ¶

The Identity service supports domain-specific Identity drivers. The drivers allow a domain to have its own LDAP or SQL back end. By default, domain-specific drivers are disabled.
标识服务支持特定于域的标识驱动程序。驱动程序允许域拥有自己的 LDAP 或 SQL 后端。默认情况下，特定于域的驱动程序处于禁用状态。

Domain-specific Identity configuration options can be stored in domain-specific configuration files, or in the Identity SQL database using API REST calls.
特定于域的标识配置选项可以存储在特定于域的配置文件中，也可以存储在使用 API REST 调用的标识 SQL 数据库中。



 

Note 注意



Storing and managing configuration options in an SQL database is experimental in Kilo, and added to the Identity service in the Liberty release.
在 SQL 数据库中存储和管理配置选项在 Kilo 中是实验性的，并在 Liberty 发行版中添加到 Identity 服务中。



### Enable drivers for domain-specific configuration files[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#enable-drivers-for-domain-specific-configuration-files) 为特定于域的配置文件启用驱动程序 ¶

To enable domain-specific drivers, set these options in the `/etc/keystone/keystone.conf` file:
若要启用特定于域的驱动程序，请在 `/etc/keystone/keystone.conf` 文件中设置以下选项：

```
[identity]
domain_specific_drivers_enabled = True
domain_config_dir = /etc/keystone/domains
```

When you enable domain-specific drivers, Identity looks in the `domain_config_dir` directory for configuration files that are named as `keystone.DOMAIN_NAME.conf`. A domain without a domain-specific configuration file uses options in the primary configuration file.
启用特定于域的驱动程序时，Identity 会在 `domain_config_dir` 目录中查找名为 `keystone.DOMAIN_NAME.conf` 的配置文件。没有特定于域的配置文件的域使用主配置文件中的选项。

### Enable drivers for storing configuration options in SQL database[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#enable-drivers-for-storing-configuration-options-in-sql-database) 启用用于在 SQL 数据库中存储配置选项的驱动程序 ¶

To enable domain-specific drivers, set these options in the `/etc/keystone/keystone.conf` file:
若要启用特定于域的驱动程序，请在 `/etc/keystone/keystone.conf` 文件中设置以下选项：

```
[identity]
domain_specific_drivers_enabled = True
domain_configurations_from_database = True
```

Any domain-specific configuration options specified through the Identity v3 API will override domain-specific configuration files in the `/etc/keystone/domains` directory.
通过 Identity v3 API 指定的任何特定于域的配置选项都将覆盖目录中特定于域的 `/etc/keystone/domains` 配置文件。

Unlike the file-based method of specifying domain-specific configurations, options specified via the Identity API will become active without needing to restart the keystone server. For performance reasons, the current state of configuration options for a domain are cached in the keystone server, and in multi-process and multi-threaded keystone configurations, the new configuration options may not become active until the cache has timed out. The cache settings for domain config options can be adjusted in the general keystone configuration file (option `cache_time` in the `domain_config` group).
与指定特定于域的配置的基于文件的方法不同，通过身份 API 指定的选项将变为活动状态，而无需重新启动 keystone 服务器。出于性能原因，域的配置选项的当前状态缓存在 keystone  服务器中，在多进程和多线程 keystone  配置中，新的配置选项在缓存超时之前可能不会变为活动状态。域配置选项的缓存设置可以在常规梯形失真配置文件（ `domain_config` 组中的选项 `cache_time` ）中进行调整。



 

Note 注意



It is important to notice that when using either of these methods of specifying domain-specific configuration options, the main keystone configuration file is still maintained. Only those options that relate to the Identity driver for users and groups (i.e. specifying whether the driver for this domain is SQL or LDAP, and, if LDAP, the options that define that connection) are supported in a domain-specific manner. Further, when using the configuration options via the Identity API, the driver option must be set to an LDAP driver (attempting to set it to an SQL driver will generate an error when it is subsequently used).
需要注意的是，当使用这些方法中的任何一种来指定特定于域的配置选项时，仍会保留主的 keystone 配置文件。只有那些与用户和组的标识驱动程序相关的选项（即指定此域的驱动程序是 SQL 还是 LDAP，如果是  LDAP，则定义该连接的选项）以特定于域的方式受支持。此外，当通过身份 API 使用配置选项时，驱动程序选项必须设置为 LDAP  驱动程序（尝试将其设置为 SQL 驱动程序将在随后使用时生成错误）。

For existing installations that already use file-based domain-specific configurations who wish to migrate to the SQL-based approach, the `keystone-manage` command can be used to upload all configuration files to the SQL database:
对于已使用基于文件的域特定配置并希望迁移到基于 SQL 的方法的现有安装，可以使用该 `keystone-manage` 命令将所有配置文件上载到 SQL 数据库：

```
$ keystone-manage domain_config_upload --all
```

Once uploaded, these domain-configuration options will be visible via the Identity API as well as applied to the domain-specific drivers. It is also possible to upload individual domain-specific configuration files by specifying the domain name:
上传后，这些域配置选项将通过标识 API 可见，并应用于特定于域的驱动程序。还可以通过指定域名来上传特定于各个域的配置文件：

```
$ keystone-manage domain_config_upload --domain-name DOMAINA
```



 

Note 注意



It is important to notice that by enabling either of the domain-specific configuration methods, the operations of listing all users and listing all groups are not supported, those calls will need either a domain filter to be specified or usage of a domain scoped token.
请务必注意，通过启用任一特定于域的配置方法，不支持列出所有用户和列出所有组的操作，这些调用将需要指定域筛选器或使用域范围的令牌。



 

Note 注意



Keystone does not support moving the contents of a domain (i.e. “its” users and groups) from one backend to another, nor group membership across backend boundaries.
Keystone 不支持将域的内容（即“其”用户和组）从一个后端移动到另一个后端，也不支持跨后端边界的组成员身份。



 

Note 注意



When using the file-based domain-specific configuration method, to delete a domain that uses a domain specific backend, it’s necessary to first disable it, remove its specific configuration file (i.e. its corresponding keystone.<domain_name>.conf) and then restart the Identity server. When managing configuration options via the Identity API, the domain can simply be disabled and deleted via the Identity API; since any domain-specific configuration options will automatically be removed.
使用基于文件的域特定配置方法时，要删除使用域特定后端的域，必须首先禁用它，删除其特定的配置文件（即其相应的基石。conf），然后重新启动 Identity Server。通过 Identity API 管理配置选项时，只需通过 Identity API  禁用和删除域即可;因为任何特定于域的配置选项都将被自动删除。



 

Note 注意



Although keystone supports multiple LDAP backends via the above domain-specific configuration methods, it currently only supports one SQL backend. This could be either the default driver or a single domain-specific backend, perhaps for storing service users in a predominantly LDAP installation.
虽然keystone通过上述域特定的配置方法支持多个LDAP后端，但它目前只支持一个SQL后端。这可以是默认驱动程序，也可以是单个特定于域的后端，可能用于将服务用户存储在主要 LDAP 安装中。



 

Note 注意



Keystone has deprecated the `keystone-manage domain_config_upload` option. The keystone team recommends setting domain config options via the API instead.
Keystone 已弃用该 `keystone-manage domain_config_upload` 选项。keystone 团队建议改为通过 API 设置域配置选项。

Due to the need for user and group IDs to be unique across an OpenStack installation and for keystone to be able to deduce which domain and backend to use from just a user or group ID, it dynamically builds a persistent identity mapping table from a public ID to the actual domain, local ID (within that backend) and entity type. The public ID is automatically generated by keystone when it first encounters the entity. If the local ID of the entity is from a backend that does not guarantee to generate UUIDs, a hash algorithm will generate a public ID for that entity, which is what will be exposed by keystone.
由于用户和组 ID 在 OpenStack 安装中需要是唯一的，并且 keystone 能够仅从用户或组 ID  中推断出要使用的域和后端，因此它会动态构建一个从公共 ID 到实际域、本地 ID（在该后端内）和实体类型的持久身份映射表。公共 ID 由  keystone 在首次遇到实体时自动生成。如果实体的本地 ID 来自不保证生成 UUID 的后端，则哈希算法将为该实体生成一个公共  ID，这就是 keystone 将公开的内容。

The use of a hash will ensure that if the public ID needs to be regenerated then the same public ID will be created. This is useful if you are running multiple keystones and want to ensure the same ID would be generated whichever server you hit.
使用哈希将确保如果需要重新生成公共 ID，则将创建相同的公共 ID。如果您正在运行多个梯形失真，并且希望确保无论您访问哪个服务器都会生成相同的 ID，这将非常有用。



 

Note 注意



In case of the LDAP backend, the names of users and groups are not hashed. As a result, these are length limited to 255 characters. Longer names will result in an error.
对于LDAP后端，用户和组的名称不会被哈希处理。因此，这些字符的长度限制为 255 个字符。较长的名称将导致错误。

While keystone will dynamically maintain the identity mapping, including removing entries when entities are deleted via the keystone, for those entities in backends that are managed outside of keystone (e.g. a read-only LDAP), keystone will not know if entities have been deleted and hence will continue to carry stale identity mappings in its table. While benign, keystone provides an ability for operators to purge the mapping table of such stale entries using the keystone-manage command, for example:
虽然 keystone 将动态维护身份映射，包括在通过 keystone 删除实体时删除条目，但对于在 keystone  外部管理的后端实体（例如只读 LDAP），keystone 将不知道实体是否已被删除，因此将继续在其表中携带过时的身份映射。虽然是良性的，但  keystone 为操作员提供了使用 keystone-manage 命令清除此类过时条目的映射表的功能，例如：

```
$ keystone-manage mapping_purge --domain-name DOMAINA --local-id abc@de.com
```

A typical usage would be for an operator to obtain a list of those entries in an external backend that had been deleted out-of-band to keystone, and then call keystone-manage to purge those entries by specifying the domain and local-id. The type of the entity (i.e. user or group) may also be specified if this is needed to uniquely identify the mapping.
典型的用法是，操作员在外部后端中获取已带外删除到 keystone 的条目的列表，然后调用 keystone-manage 通过指定域和 local-id 来清除这些条目。如果需要唯一标识映射，也可以指定实体的类型（即用户或组）。

Since public IDs can be regenerated **with the correct generator implementation**, if the details of those entries that have been deleted are not available, then it is safe to simply bulk purge identity mappings periodically, for example:
由于可以使用正确的生成器实现重新生成公共 ID，因此，如果已删除的条目的详细信息不可用，则定期批量清除标识映射是安全的，例如：

```
$ keystone-manage mapping_purge --domain-name DOMAINA
```

will purge all the mappings for DOMAINA. The entire mapping table can be purged with the following command:
将清除 DOMAINA 的所有映射。可以使用以下命令清除整个映射表：

```
$ keystone-manage mapping_purge --all
```

Generating public IDs in the first run may take a while, and most probably first API requests to fetch user list will fail by timeout. To prevent this, `mapping_populate` command should be executed. It should be executed right after LDAP has been configured or after `mapping_purge`.
在第一次运行中生成公共 ID 可能需要一段时间，并且很可能第一个 API 请求获取用户列表会因超时而失败。为防止这种情况， `mapping_populate` 应执行命令。它应该在配置 LDAP 之后或之后 `mapping_purge` 立即执行。

```
$ keystone-manage mapping_populate --domain DOMAINA
```

### Public ID Generators[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#public-id-generators) 公共 ID 生成器 ¶

Keystone supports a customizable public ID generator and it is specified in the `[identity_mapping]` section of the configuration file. Keystone provides a sha256 generator as default, which produces regenerable public IDs. The generator algorithm for public IDs is a balance between key size (i.e. the length of the public ID), the probability of collision and, in some circumstances, the security of the public ID. The maximum length of public ID supported by keystone is 64 characters, and the default generator (sha256) uses this full capability. Since the public ID is what is exposed externally by keystone and potentially stored in external systems, some installations may wish to make use of other generator algorithms that have a different trade-off of attributes. A different generator can be installed by configuring the following property:
Keystone 支持可自定义的公共 ID 生成器，并在配置文件 `[identity_mapping]` 的部分中指定。Keystone 默认提供 sha256 生成器，生成可再生的公共 ID。公共 ID 的生成器算法是密钥大小（即公共 ID  的长度）、冲突概率以及在某些情况下公共 ID 的安全性之间的平衡。keystone 支持的公共 ID 的最大长度为 64 个字符，默认生成器  （sha256） 使用此完整功能。由于公共 ID 是由 keystone  在外部公开的，并且可能存储在外部系统中，因此某些安装可能希望使用具有不同属性权衡的其他生成器算法。可以通过配置以下属性来安装其他生成器：

- `generator` - identity mapping generator. Defaults to `sha256` (implemented by [`keystone.identity.id_generators.sha256.Generator`](https://docs.openstack.org/keystone/yoga/api/keystone.identity.id_generators.sha256.html#keystone.identity.id_generators.sha256.Generator))
   `generator` - 身份映射生成器。默认值为 `sha256` （实现者） `keystone.identity.id_generators.sha256.Generator` 



 

Warning 警告



Changing the generator may cause all existing public IDs to be become invalid, so typically the generator selection should be considered immutable for a given installation.
更改生成器可能会导致所有现有的公共 ID 无效，因此通常应将生成器选择视为给定安装的不可变性。

### Migrate domain-specific configuration files to the SQL database[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#migrate-domain-specific-configuration-files-to-the-sql-database) 将特定于域的配置文件迁移到 SQL 数据库 ¶

You can use the `keystone-manage` command to migrate configuration options in domain-specific configuration files to the SQL database:
可以使用以下 `keystone-manage` 命令将特定于域的配置文件中的配置选项迁移到 SQL 数据库：

```
# keystone-manage domain_config_upload --all
```

To upload options from a specific domain-configuration file, specify the domain name:
要从特定域配置文件上传选项，请指定域名：

```
# keystone-manage domain_config_upload --domain-name DOMAIN_NAME
```



## Integrate Identity with LDAP[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#integrate-identity-with-ldap) 将身份与 LDAP 集成 ¶

The OpenStack Identity service supports integration with existing LDAP directories for authentication and authorization services. LDAP back ends require initialization before configuring the OpenStack Identity service to work with it. For more information, see [Setting up LDAP for use with Keystone](https://wiki.openstack.org/wiki/OpenLDAP).
OpenStack Identity 服务支持与现有 LDAP 目录集成，以实现身份验证和授权服务。LDAP 后端需要先初始化，然后才能配置 OpenStack Identity 服务以使用它。有关更多信息，请参阅设置 LDAP 以用于 Keystone。

When the OpenStack Identity service is configured to use LDAP back ends, you can split authentication (using the *identity* feature) and authorization (using the *assignment* feature). OpenStack Identity only supports read-only LDAP integration.
当 OpenStack 身份服务配置为使用 LDAP 后端时，您可以拆分身份验证（使用身份功能）和授权（使用分配功能）。OpenStack Identity 仅支持只读 LDAP 集成。

The *identity* feature enables administrators to manage users and groups by each domain or the OpenStack Identity service entirely.
身份功能使管理员能够按每个域或完全 OpenStack 身份服务管理用户和组。

The *assignment* feature enables administrators to manage project role authorization using the OpenStack Identity service SQL database, while providing user authentication through the LDAP directory.
分配功能使管理员能够使用 OpenStack Identity 服务 SQL 数据库管理项目角色授权，同时通过 LDAP 目录提供用户身份验证。



 

Note 注意



It is possible to isolate identity related information to LDAP in a deployment and keep resource information in a separate datastore. It is not possible to do the opposite, where resource information is stored in LDAP and identity information is stored in SQL. If the resource or assignment back ends are integrated with LDAP, the identity back end must also be integrated with LDAP.
可以在部署中将与身份相关的信息隔离到 LDAP，并将资源信息保存在单独的数据存储中。相反，资源信息存储在 LDAP 中，身份信息存储在 SQL 中，这是不可能的。如果资源或分配后端与 LDAP 集成，则身份后端也必须与 LDAP 集成。

### Identity LDAP server set up[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#identity-ldap-server-set-up) 身份 LDAP 服务器设置 ¶



 

Important 重要



If you are using SELinux (enabled by default on RHEL derivatives), then in order for the OpenStack Identity service to access LDAP servers, you must enable the `authlogin_nsswitch_use_ldap` boolean value for SELinux on the server running the OpenStack Identity service. To enable and make the option persistent across reboots, set the following boolean value as the root user:
如果您使用的是 SELinux（在 RHEL 衍生产品上默认启用），那么为了让 OpenStack Identity 服务访问 LDAP 服务器，您必须在运行 OpenStack Identity 服务的服务器上为 SELinux 启用 `authlogin_nsswitch_use_ldap` 布尔值。要启用该选项并使该选项在重新启动后持续存在，请以 root 用户身份设置以下布尔值：

```
# setsebool -P authlogin_nsswitch_use_ldap on
```

The Identity configuration is split into two separate back ends; identity (back end for users and groups), and assignments (back end for domains, projects, roles, role assignments). To configure Identity, set options in the `/etc/keystone/keystone.conf` file. See [Integrate Identity back end with LDAP](https://docs.openstack.org/keystone/yoga/admin/configuration.html#integrate-identity-back-end-with-ldap) for Identity back end configuration examples. Modify these examples as needed.
Identity 配置分为两个独立的后端;标识（用户和组的后端）和分配（域、项目、角色、角色分配的后端）。要配置 Identity，请在 `/etc/keystone/keystone.conf` 文件中设置选项。有关身份后端配置示例，请参阅将身份后端与 LDAP 集成。根据需要修改这些示例。

**To define the destination LDAP server
定义目标 LDAP 服务器**

Define the destination LDAP server in the `/etc/keystone/keystone.conf` file:
在 `/etc/keystone/keystone.conf` 文件中定义目标 LDAP 服务器：

```
[ldap]
url = ldap://localhost
user = dc=Manager,dc=example,dc=org
password = samplepassword
suffix = dc=example,dc=org
```

Although it’s not recommended (see note below), multiple LDAP servers can be supplied to `url` to provide high-availability support for a single LDAP backend. By default, these will be tried in order of apperance, but an additional option, `randomize_urls` can be set to true, to randomize the list in each process (when it starts). To specify multiple LDAP servers, simply change the `url` option in the `[ldap]` section to be a list, separated by commas:
尽管不建议这样做（请参阅下面的注释），但可以向多个 LDAP 服务器提供多个 LDAP 服务器 `url` ，以便为单个 LDAP 后端提供高可用性支持。默认情况下，这些选项将按外观顺序进行尝试，但 `randomize_urls` 可以将另一个选项设置为 true，以随机化每个进程中的列表（当它启动时）。要指定多个 LDAP 服务器，只需将 `[ldap]` 该部分中的 `url` 选项更改为列表，以逗号分隔：

```
url = "ldap://localhost,ldap://backup.localhost"
randomize_urls = true
```



 

Note 注意



Failover mechanisms in the LDAP backend can cause delays when switching over to the next working LDAP server. Randomizing the order in which the servers are tried only makes the failure behavior not dependent on which of the ordered servers fail. Individual processes can still be delayed or time out, so this doesn’t fix the issue at hand, but only makes the failure mode more gradual. This behavior cannot be easily fixed inside the service, because keystone would have to monitor the status of each LDAP server, which is in fact a task for a load balancer. Because of this, it is recommended to use a load balancer in front of the LDAP servers, which can monitor the state of the cluster and instantly redirect connections to the working LDAP server.
LDAP 后端中的故障转移机制在切换到下一个工作的 LDAP  服务器时可能会导致延迟。随机化尝试服务器的顺序只会使失败行为不依赖于哪个订购的服务器失败。单个进程仍可能延迟或超时，因此这并不能解决手头的问题，而只会使故障模式更加渐进。这种行为在服务中不容易修复，因为 keystone 必须监控每个 LDAP 服务器的状态，这实际上是负载平衡器的任务。因此，建议在 LDAP  服务器前面使用负载平衡器，它可以监控集群的状态并立即将连接重定向到工作 LDAP 服务器。

**Additional LDAP integration settings
其他 LDAP 集成设置**

Set these options in the `/etc/keystone/keystone.conf` file for a single LDAP server, or `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` files for multiple back ends. Example configurations appear below each setting summary:
在 `/etc/keystone/keystone.conf` 文件中为单个 LDAP 服务器设置这些选项，或 `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` 在多个后端的文件中设置这些选项。示例配置显示在每个设置摘要下方：

**Query option 查询选项**

Use `query_scope` to control the scope level of data presented (search only the first level or search an entire sub-tree) through LDAP. 用于 `query_scope` 通过 LDAP 控制所呈现数据的作用域级别（仅搜索第一级或搜索整个子树）。 Use `page_size` to control the maximum results per page. A value of zero disables paging. 用于 `page_size` 控制每页的最大结果数。值为零将禁用分页。 Use `alias_dereferencing` to control the LDAP dereferencing option for queries. 用于 `alias_dereferencing` 控制查询的 LDAP 取消引用选项。

```
[ldap]
query_scope = sub
page_size = 0
alias_dereferencing = default
chase_referrals =
```

**Debug 调试**

Use `debug_level` to set the LDAP debugging level for LDAP calls. A value of zero means that debugging is not enabled.
用于 `debug_level` 设置 LDAP 调用的 LDAP 调试级别。值为零表示未启用调试。

```
[ldap]
debug_level = 4095
```

This setting sets `OPT_DEBUG_LEVEL` in the underlying python library. This field is a bit mask (integer), and the possible flags are documented in the OpenLDAP manpages. Commonly used values include 255 and 4095, with 4095 being more verbose and 0 being disabled. We recommend consulting the documentation for your LDAP back end when using this option.
此设置在基础 python 库中设置 `OPT_DEBUG_LEVEL` 。此字段是一个位掩码（整数），可能的标志记录在 OpenLDAP 手册页中。常用的值包括 255 和 4095，其中 4095 表示更详细，0 表示禁用。我们建议在使用此选项时查阅 LDAP 后端的文档。



 

Warning 警告



Enabling `debug_level` will negatively impact performance.
启用 `debug_level` 将对性能产生负面影响。

**Connection pooling 连接池**

Various LDAP back ends use a common LDAP module to interact with LDAP data. By default, a new connection is established for each LDAP operation. This is expensive when TLS support is enabled, which is a likely configuration in an enterprise setup. Reusing connections from a connection pool drastically reduces overhead of initiating a new connection for every LDAP operation.
各种 LDAP 后端使用通用 LDAP 模块与 LDAP 数据进行交互。默认情况下，会为每个 LDAP 操作建立新连接。启用 TLS 支持时，这很昂贵，这是企业设置中可能出现的配置。重用连接池中的连接可大大减少为每个 LDAP 操作启动新连接的开销。

Use `use_pool` to enable LDAP connection pooling. Configure the connection pool size, maximum retry, reconnect trials, timeout (-1 indicates indefinite wait) and lifetime in seconds.
用于 `use_pool` 启用 LDAP 连接池。配置连接池大小、最大重试次数、重新连接试验次数、超时（-1 表示无限期等待）和生存期（以秒为单位）。

```
[ldap]
use_pool = true
pool_size = 10
pool_retry_max = 3
pool_retry_delay = 0.1
pool_connection_timeout = -1
pool_connection_lifetime = 600
```

**Connection pooling for end user authentication
用于最终用户身份验证的连接池**

LDAP user authentication is performed via an LDAP bind operation. In large deployments, user authentication can use up all available connections in a connection pool. OpenStack Identity provides a separate connection pool specifically for user authentication.
LDAP 用户身份验证是通过 LDAP 绑定操作执行的。在大型部署中，用户身份验证可能会耗尽连接池中的所有可用连接。OpenStack Identity 提供了一个专门用于用户身份验证的单独连接池。

Use `use_auth_pool` to enable LDAP connection pooling for end user authentication. Configure the connection pool size and lifetime in seconds. Both `use_pool` and `use_auth_pool` must be enabled to pool connections for user authentication.
用于 `use_auth_pool` 为最终用户身份验证启用 LDAP 连接池。以秒为单位配置连接池大小和生存期。两者 `use_pool`  `use_auth_pool` 必须启用，才能池化连接以进行用户身份验证。

```
[ldap]
use_auth_pool = false
auth_pool_size = 100
auth_pool_connection_lifetime = 60
```

When you have finished the configuration, restart the OpenStack Identity service.
完成配置后，重新启动 OpenStack Identity 服务。



 

Warning 警告



During the service restart, authentication and authorization are unavailable.
在服务重新启动期间，身份验证和授权不可用。

### Integrate Identity back end with LDAP[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#integrate-identity-back-end-with-ldap) 将身份后端与 LDAP 集成 ¶

The Identity back end contains information for users, groups, and group member lists. Integrating the Identity back end with LDAP allows administrators to use users and groups in LDAP.
标识后端包含有关用户、组和组成员列表的信息。通过将身份后端与 LDAP 集成，管理员可以在 LDAP 中使用用户和组。



 

Important 重要



For OpenStack Identity service to access LDAP servers, you must define the destination LDAP server in the `/etc/keystone/keystone.conf` file. For more information, see [Identity LDAP server set up](https://docs.openstack.org/keystone/yoga/admin/configuration.html#identity-ldap-server-set-up).
要使 OpenStack Identity 服务访问 LDAP 服务器，您必须在 `/etc/keystone/keystone.conf` 文件中定义目标 LDAP 服务器。有关详细信息，请参阅身份 LDAP 服务器设置。

**To integrate one Identity back end with LDAP
将一个身份后端与 LDAP 集成**

1. Enable the LDAP Identity driver in the `/etc/keystone/keystone.conf` file. This allows LDAP as an identity back end:
   在 `/etc/keystone/keystone.conf` 文件中启用 LDAP 身份驱动程序。这允许 LDAP 作为身份后端：

   ```
   [identity]
   #driver = sql
   driver = ldap
   ```

2. Create the organizational units (OU) in the LDAP directory, and define the corresponding location in the `/etc/keystone/keystone.conf` file:
   在 LDAP 目录中创建组织单位 （OU），并在 `/etc/keystone/keystone.conf` 文件中定义相应的位置：

   ```
   [ldap]
   user_tree_dn = ou=Users,dc=example,dc=org
   user_objectclass = inetOrgPerson
   
   group_tree_dn = ou=Groups,dc=example,dc=org
   group_objectclass = groupOfNames
   ```

   

    

   Note 注意

   

   These schema attributes are extensible for compatibility with various schemas. For example, this entry maps to the person attribute in Active Directory:
   这些架构属性是可扩展的，以便与各种架构兼容。例如，此条目映射到 Active Directory 中的 person 属性：

   ```
   user_objectclass = person
   ```

   Restart the OpenStack Identity service.
   重新启动 OpenStack Identity 服务。

   

    

   Warning 警告

   

   During service restart, authentication and authorization are unavailable.
   在服务重新启动期间，身份验证和授权不可用。

**To integrate multiple Identity back ends with LDAP
将多个身份后端与 LDAP 集成**

1. Set the following options in the `/etc/keystone/keystone.conf` file:
   在 `/etc/keystone/keystone.conf` 文件中设置以下选项：

   1. Enable the LDAP driver:
      启用 LDAP 驱动程序：

      ```
      [identity]
      #driver = sql
      driver = ldap
      ```

   2. Enable domain-specific drivers:
      启用特定于域的驱动程序：

      ```
      [identity]
      domain_specific_drivers_enabled = True
      domain_config_dir = /etc/keystone/domains
      ```

2. Restart the OpenStack Identity service.
   重新启动 OpenStack Identity 服务。

   

    

   Warning 警告

   

   During service restart, authentication and authorization are unavailable.
   在服务重新启动期间，身份验证和授权不可用。

3. List the domains using the dashboard, or the OpenStackClient CLI. Refer to the [Command List](https://docs.openstack.org/python-openstackclient/latest/cli/command-list.html) for a list of OpenStackClient commands.
   使用仪表板或 OpenStackClient CLI 列出域。有关 OpenStackClient 命令的列表，请参阅命令列表。

4. Create domains using OpenStack dashboard, or the OpenStackClient CLI.
   使用 OpenStack 仪表板或 OpenStackClient CLI 创建域。

5. For each domain, create a domain-specific configuration file in the `/etc/keystone/domains` directory. Use the file naming convention `keystone.DOMAIN_NAME.conf`, where DOMAIN_NAME is the domain name assigned in the previous step.
   对于每个域，在目录中创建一个特定于域的 `/etc/keystone/domains` 配置文件。使用文件命名约定 `keystone.DOMAIN_NAME.conf` ，其中 DOMAIN_NAME 是在上一步中分配的域名。

   

    

   Note 注意

   

   The options set in the `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` file will override options in the `/etc/keystone/keystone.conf` file.
   文件中设置的 `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` 选项将覆盖文件中的 `/etc/keystone/keystone.conf` 选项。

6. Define the destination LDAP server in the `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` file. For example:
   在 `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` 文件中定义目标 LDAP 服务器。例如：

   ```
   [ldap]
   url = ldap://localhost
   user = dc=Manager,dc=example,dc=org
   password = samplepassword
   suffix = dc=example,dc=org
   ```

7. Create the organizational units (OU) in the LDAP directories, and define their corresponding locations in the `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` file. For example:
   在 LDAP 目录中创建组织单位 （OU），并在 `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` 文件中定义其相应的位置。例如：

   ```
   [ldap]
   user_tree_dn = ou=Users,dc=example,dc=org
   user_objectclass = inetOrgPerson
   
   group_tree_dn = ou=Groups,dc=example,dc=org
   group_objectclass = groupOfNames
   ```

   

    

   Note 注意

   

   These schema attributes are extensible for compatibility with various schemas. For example, this entry maps to the person attribute in Active Directory:
   这些架构属性是可扩展的，以便与各种架构兼容。例如，此条目映射到 Active Directory 中的 person 属性：

   ```
   user_objectclass = person
   ```

8. Restart the OpenStack Identity service.
   重新启动 OpenStack Identity 服务。

   

    

   Warning 警告

   

   During service restart, authentication and authorization are unavailable.
   在服务重新启动期间，身份验证和授权不可用。

**Additional LDAP integration settings
其他 LDAP 集成设置**

Set these options in the `/etc/keystone/keystone.conf` file for a single LDAP server, or `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` files for multiple back ends. Example configurations appear below each setting summary:
在 `/etc/keystone/keystone.conf` 文件中为单个 LDAP 服务器设置这些选项，或 `/etc/keystone/domains/keystone.DOMAIN_NAME.conf` 在多个后端的文件中设置这些选项。示例配置显示在每个设置摘要下方：

- Filters 过滤 器

  Use filters to control the scope of data presented through LDAP. 使用过滤器来控制通过 LDAP 呈现的数据范围。 `[ldap] user_filter = (memberof=cn=openstack-users,ou=workgroups,dc=example,dc=org) group_filter = `

- Identity attribute mapping 标识属性映射

  Mask account status values (include any additional attribute mappings) for compatibility with various directory services. Superfluous accounts are filtered with `user_filter`. 屏蔽帐户状态值（包括任何其他属性映射）以与各种目录服务兼容。多余的帐户使用 `user_filter` 进行过滤。 Setting attribute ignore to list of attributes stripped off on update. 将属性忽略设置为更新时剥离的属性列表。 For example, you can mask Active Directory account status attributes in the `/etc/keystone/keystone.conf` file: 例如，您可以屏蔽文件中的 `/etc/keystone/keystone.conf` Active Directory 帐户状态属性： `[ldap] user_id_attribute      = cn user_name_attribute    = sn user_mail_attribute    = mail user_pass_attribute    = userPassword user_enabled_attribute = userAccountControl user_enabled_mask      = 2 user_enabled_invert    = false user_enabled_default   = 512 user_default_project_id_attribute = user_additional_attribute_mapping = group_id_attribute     = cn group_name_attribute   = ou group_member_attribute = member group_desc_attribute   = description group_additional_attribute_mapping = ` It is possible to model more complex LDAP schemas. For example, in the user object, the objectClass posixAccount from [RFC2307](https://tools.ietf.org/html/rfc2307) is very common. If this is the underlying objectClass, then the `uid` field should probably be `uidNumber` and the `username` field should be either `uid` or `cn`. The following illustrates the configuration: 可以对更复杂的 LDAP 模式进行建模。例如，在用户对象中，来自 RFC2307 的 objectClass posixAccount 非常常见。如果这是基础 objectClass，则该 `uid` 字段可能应该是 `uidNumber` ，并且该 `username` 字段应为 或 `uid` `cn` 。配置说明如下： `[ldap] user_id_attribute = uidNumber user_name_attribute = cn `

- Enabled emulation 启用的仿真

  OpenStack Identity supports emulation for integrating with LDAP servers that do not provide an `enabled` attribute for users. This allows OpenStack Identity to advertise `enabled` attributes when the user entity in LDAP does not. The `user_enabled_emulation` option must be enabled and the `user_enabled_emulation_dn` option must be a valid LDAP group. Users in the group specified by `user_enabled_emulation_dn` will be marked as `enabled`. For example, the following will mark any user who is a member of the `enabled_users` group as enabled: OpenStack Identity 支持仿真，以便与不为用户提供属性的 `enabled` LDAP 服务器集成。这允许 OpenStack Identity 在 LDAP 中的用户实体不通告 `enabled` 属性时发布属性。必须启用该 `user_enabled_emulation` 选项，并且该 `user_enabled_emulation_dn` 选项必须是有效的 LDAP 组。指定的组中的用户 `user_enabled_emulation_dn` 将被标记为 `enabled` 。例如，以下命令会将作为 `enabled_users` 组成员的任何用户标记为已启用： `[ldap] user_enabled_emulation = True user_enabled_emulation_dn = cn=enabled_users,cn=groups,dc=openstack,dc=org ` If the directory server has an enabled attribute, but it is not a boolean type, a mask can be used to convert it. This is useful when the enabled attribute is an integer value. The following configuration highlights the usage: 如果目录服务器具有 enabled 属性，但它不是布尔类型，则可以使用掩码来转换它。当 enabled 属性是整数值时，这很有用。以下配置突出显示了用法： `[ldap] user_enabled_attribute = userAccountControl user_enabled_mask = 2 user_enabled_default = 512 ` In this case, the attribute is an integer and the enabled attribute is listed in bit 1. If the mask configured `user_enabled_mask` is different from 0, it retrieves the attribute from `user_enabled_attribute` and performs an add operation with the `user_enabled_mask`. If the sum of the operation matches the mask, then the account is disabled. 在本例中，该属性为整数，并且 enabled 属性列在位 1 中。如果配置 `user_enabled_mask` 的掩码与 0 不同，则从 `user_enabled_attribute` 中检索属性并使用 执行添加操作 `user_enabled_mask` 。如果操作的总和与掩码匹配，则禁用该帐户。 The value of `user_enabled_attribute` is also saved before applying the add operation in `enabled_nomask`. This is done in case the user needs to be enabled or disabled. Lastly, setting `user_enabled_default` is needed in order to create a default value on the integer attribute (512 = NORMAL ACCOUNT in Active Directory). 在应用 中的 `enabled_nomask` 添加操作之前，也会保存 的 `user_enabled_attribute` 值。这是在需要启用或禁用用户的情况下完成的。最后，需要设置 `user_enabled_default` 才能在整数属性上创建默认值（512 = Active Directory 中的 NORMAL ACCOUNT）。

When you have finished configuration, restart the OpenStack Identity service.
完成配置后，重新启动 OpenStack Identity 服务。



 

Warning 警告



During service restart, authentication and authorization are unavailable.
在服务重新启动期间，身份验证和授权不可用。

### Secure the OpenStack Identity service connection to an LDAP back end[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#secure-the-openstack-identity-service-connection-to-an-ldap-back-end) 保护 OpenStack Identity 服务与 LDAP 后端的连接 ¶

We recommend securing all connections between OpenStack Identity and LDAP. The Identity service supports the use of TLS to encrypt LDAP traffic. Before configuring this, you must first verify where your certificate authority file is located. For more information, see the [OpenStack Security Guide SSL introduction](https://docs.openstack.org/security-guide/secure-communication/introduction-to-ssl-and-tls.html).
我们建议保护 OpenStack Identity 和 LDAP 之间的所有连接。身份服务支持使用 TLS 加密 LDAP 流量。在配置之前，必须首先验证证书颁发机构文件所在的位置。有关更多信息，请参阅《OpenStack 安全指南》SSL 简介。

Once you verify the location of your certificate authority file:
验证证书颁发机构文件的位置后：

**To configure TLS encryption on LDAP traffic
在 LDAP 流量上配置 TLS 加密**

1. Open the `/etc/keystone/keystone.conf` configuration file.
   打开 `/etc/keystone/keystone.conf` 配置文件。

2. Find the `[ldap]` section.
   找到该 `[ldap]` 部分。

3. In the `[ldap]` section, set the `use_tls` configuration key to `True`. Doing so will enable TLS.
   在该 `[ldap]` 部分中，将 `use_tls` 配置键设置为 `True` 。这样做将启用 TLS。

4. Configure the Identity service to use your certificate authorities file. To do so, set the `tls_cacertfile` configuration key in the `ldap` section to the certificate authorities file’s path.
   将 Identity Service 配置为使用证书颁发机构文件。为此，请将 `ldap` 该部分中的 `tls_cacertfile` 配置键设置为证书颁发机构文件的路径。

   

    

   Note 注意

   

   You can also set the `tls_cacertdir` (also in the `ldap` section) to the directory where all certificate authorities files are kept. If both `tls_cacertfile` and `tls_cacertdir` are set, then the latter will be ignored.
   您还可以将 `tls_cacertdir` （也在本节 `ldap` 中）设置为保存所有证书颁发机构文件的目录。如果同时 `tls_cacertfile` 设置了 and `tls_cacertdir` ，则后者将被忽略。

5. Specify what client certificate checks to perform on incoming TLS sessions from the LDAP server. To do so, set the `tls_req_cert` configuration key in the `[ldap]` section to `demand`, `allow`, or `never`:
   指定要对来自 LDAP 服务器的传入 TLS 会话执行哪些客户端证书检查。为此，请将该部分中的 `tls_req_cert` 配置键设置为 `demand` 、 `allow` 或 `never` ： `[ldap]` 

   `demand` - The LDAP server always receives certificate requests. The session terminates if no certificate is provided, or if the certificate provided cannot be verified against the existing certificate authorities file.  `demand` - LDAP 服务器始终接收证书请求。如果未提供证书，或者无法根据现有证书颁发机构文件验证所提供的证书，则会话将终止。 `allow` - The LDAP server always receives certificate requests. The session will proceed as normal even if a certificate is not provided. If a certificate is provided but it cannot be verified against the existing certificate authorities file, the certificate will be ignored and the session will proceed as normal.  `allow` - LDAP 服务器始终接收证书请求。即使未提供证书，会话也将照常进行。如果提供了证书，但无法根据现有证书颁发机构文件进行验证，则将忽略该证书，会话将照常进行。 `never` - A certificate will never be requested.  `never` - 绝不会要求提供证书。

When you have finished configuration, restart the OpenStack Identity service.
完成配置后，重新启动 OpenStack Identity 服务。



 

Note 注意



If you are unable to connect to LDAP via OpenStack Identity, or observe a *SERVER DOWN* error, set the `TLS_CACERT` in `/etc/ldap/ldap.conf` to the same value specified in the `[ldap] tls_certificate` section of `keystone.conf`.
如果无法通过 OpenStack Identity 连接到 LDAP，或者发现 SERVER DOWN 错误，请将 `TLS_CACERT` in `/etc/ldap/ldap.conf` 设置为 中 `[ldap] tls_certificate` 指定的相同值 `keystone.conf` 。

On distributions that include openstack-config, you can configure TLS encryption on LDAP traffic by running the following commands instead.
在包含 openstack-config 的发行版上，您可以通过运行以下命令来配置 LDAP 流量的 TLS 加密。

```
# openstack-config --set /etc/keystone/keystone.conf \
  ldap use_tls True
# openstack-config --set /etc/keystone/keystone.conf \
  ldap tls_cacertfile ``CA_FILE``
# openstack-config --set /etc/keystone/keystone.conf \
  ldap tls_req_cert ``CERT_BEHAVIOR``
```

Where: 哪里：

- `CA_FILE` is the absolute path to the certificate authorities file that should be used to encrypt LDAP traffic.
   `CA_FILE` 是应用于加密 LDAP 流量的证书颁发机构文件的绝对路径。
- `CERT_BEHAVIOR` specifies what client certificate checks to perform on an incoming TLS session from the LDAP server (`demand`, `allow`, or `never`).
   `CERT_BEHAVIOR` 指定要对来自 LDAP 服务器的传入 TLS 会话执行的客户端证书检查（ `demand` 、 `allow` 或 `never` ）。



## Caching layer[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#caching-layer) 缓存层 ¶

OpenStack Identity supports a caching layer that is above the configurable subsystems (for example, token). This gives you the flexibility to setup caching for all or some subsystems. OpenStack Identity uses the [oslo.cache](https://docs.openstack.org/oslo.cache/latest/) library which allows flexible cache back ends. The majority of the caching configuration options are set in the `[cache]` section of the `/etc/keystone/keystone.conf` file. The `enabled` option of the `[cache]` section must be set to `True` in order for any subsystem to cache responses. Each section that has the capability to be cached will have a `caching` boolean value that toggles caching behavior of that particular subsystem.
OpenStack Identity 支持位于可配置子系统之上的缓存层（例如，令牌）。这使您可以灵活地为所有或某些子系统设置缓存。OpenStack Identity 使用 oslo.cache 库，该库允许灵活的缓存后端。大多数缓存配置选项都是在 `/etc/keystone/keystone.conf` 文件 `[cache]` 的部分中设置的。必须将 `[cache]` 该部分的 `enabled` 选项设置为， `True` 以便任何子系统缓存响应。每个具有缓存功能的部分都将具有一个 `caching` 布尔值，用于切换该特定子系统的缓存行为。

So to enable only the token back end caching, set the values as follows:
因此，若要仅启用令牌后端缓存，请按如下方式设置值：

```
[cache]
enabled=true

[catalog]
caching=false

[domain_config]
caching=false

[federation]
caching=false

[resource]
caching=false

[revoke]
caching=false

[role]
caching=false

[token]
caching=true
```



 

Note 注意



Each subsystem is configured to cache by default. However, the global toggle for caching defaults to `False`. A subsystem is only able to cache responses if the global toggle is enabled.
默认情况下，每个子系统都配置为缓存。但是，缓存的全局切换默认为 `False` 。子系统只有在启用全局切换时才能缓存响应。

Current functional back ends are:
当前功能后端包括：

- `dogpile.cache.null`

  A “null” backend that effectively disables all cache operations.(Default) 有效禁用所有缓存操作的“空”后端。（默认）

- `dogpile.cache.memcached`

  Memcached back end using the standard `python-memcached` library. 使用标准 `python-memcached` 库的 Memcached 后端。

- `dogpile.cache.pylibmc`

  Memcached back end using the `pylibmc` library. 使用库的 `pylibmc` Memcached 后端。

- `dogpile.cache.bmemcached`

  Memcached using the `python-binary-memcached` library. 使用 `python-binary-memcached` 库进行 Memcached。

- `dogpile.cache.redis`

  Redis back end. Redis 后端。

- `dogpile.cache.dbm`

  Local DBM file back end. 本地 DBM 文件后端。

- `dogpile.cache.memory`

  In-memory cache, not suitable for use outside of testing as it does not cleanup its internal cache on cache expiration and does not share cache between processes. This means that caching and cache invalidation will not be consistent or reliable. 内存中缓存，不适合在测试之外使用，因为它不会在缓存过期时清理其内部缓存，也不会在进程之间共享缓存。这意味着缓存和缓存失效将不一致或不可靠。

- `dogpile.cache.memory_pickle`

  In-memory cache, but serializes objects with pickle lib. It’s not suitable for use outside of testing. The reason is the same with `dogpile.cache.memory` 内存中缓存，但使用 pickle lib 序列化对象。它不适合在测试之外使用。原因与此 `dogpile.cache.memory` 相同

- `oslo_cache.mongo`

  MongoDB as caching back end. MongoDB 作为缓存后端。

- `oslo_cache.memcache_pool`

  Memcached backend that does connection pooling. 执行连接池的 Memcached 后端。

- `oslo_cache.etcd3gw`

  Uses etcd 3.x for storage. 使用 etcd 3.x 进行存储。

- `oslo_cache.dict`

  A DictCacheBackend based on dictionary, not suitable for use outside of testing as it does not share cache between processes.This means that caching and cache invalidation will not be consistent or reliable. 基于字典的 DictCacheBackend，不适合在测试之外使用，因为它不在进程之间共享缓存。这意味着缓存和缓存失效将不一致或不可靠。

### Caching for tokens and tokens validation[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#caching-for-tokens-and-tokens-validation) 令牌缓存和令牌验证 ¶

The token subsystem is OpenStack Identity’s most heavily used API. As a result, all types of tokens benefit from caching, including Fernet tokens. Although Fernet tokens do not need to be persisted, they should still be cached for optimal token validation performance.
令牌子系统是 OpenStack Identity 使用最频繁的 API。因此，所有类型的代币都受益于缓存，包括 Fernet 代币。尽管 Fernet 令牌不需要持久化，但仍应缓存它们以获得最佳令牌验证性能。

The token system has a separate `cache_time` configuration option, that can be set to a value above or below the global `expiration_time` default, allowing for different caching behavior from the other systems in OpenStack Identity. This option is set in the `[token]` section of the configuration file.
令牌系统有一个单独的 `cache_time` 配置选项，可以将其设置为高于或低于全局 `expiration_time` 默认值的值，从而允许与 OpenStack Identity 中的其他系统不同的缓存行为。此选项在配置文件 `[token]` 的部分中设置。

The token revocation list cache time is handled by the configuration option `revocation_cache_time` in the `[token]` section. The revocation list is refreshed whenever a token is revoked. It typically sees significantly more requests than specific token retrievals or token validation calls.
令牌吊销列表缓存时间由 `[token]` 该部分中的配置选项 `revocation_cache_time` 处理。每当吊销令牌时，吊销列表都会刷新。它通常看到的请求比特定的令牌检索或令牌验证调用多得多。

Here is a list of actions that are affected by the cached time:
以下是受缓存时间影响的操作列表：

- getting a new token 获取新令牌
- revoking tokens 撤销令牌
- validating tokens 验证令牌
- checking v3 tokens 检查 v3 令牌

The delete token API calls invalidate the cache for the tokens being acted upon, as well as invalidating the cache for the revoked token list and the validate/check token calls.
删除令牌 API 调用使正在操作的令牌的缓存失效，并使已吊销的令牌列表和验证/检查令牌调用的缓存失效。

Token caching is configurable independently of the `revocation_list` caching. Lifted expiration checks from the token drivers to the token manager. This ensures that cached tokens will still raise a `TokenNotFound` flag when expired.
令牌缓存可独立于 `revocation_list` 缓存进行配置。已将过期检查从令牌驱动程序提升到令牌管理器。这可确保缓存的令牌在过期时仍会引发标记 `TokenNotFound` 。

For cache consistency, all token IDs are transformed into the short token hash at the provider and token driver level. Some methods have access to the full ID (PKI Tokens), and some methods do not. Cache invalidation is inconsistent without token ID normalization.
为了缓存一致性，所有令牌 ID 都将在提供程序和令牌驱动程序级别转换为短令牌哈希。某些方法可以访问完整 ID（PKI 令牌），而某些方法则不能。如果没有令牌 ID 规范化，缓存失效是不一致的。

### Caching for non-token resources[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#caching-for-non-token-resources) 非令牌资源的缓存 ¶

Various other keystone components have a separate `cache_time` configuration option, that can be set to a value above or below the global `expiration_time` default, allowing for different caching behavior from the other systems in Identity service. This option can be set in various sections (for example, `[role]` and `[resource]`) of the configuration file. The create, update, and delete actions for domains, projects and roles will perform proper invalidations of the cached methods listed above.
其他各种 keystone 组件都有一个单独的 `cache_time` 配置选项，可以将其设置为高于或低于全局 `expiration_time` 默认值的值，从而允许与 Identity Service 中的其他系统不同的缓存行为。可以在配置文件的各个部分（例如和 `[role]` `[resource]` ）中设置此选项。域、项目和角色的创建、更新和删除操作将对上面列出的缓存方法执行适当的失效。

For more information about the different back ends (and configuration options), see:
有关不同后端（和配置选项）的详细信息，请参阅：

- [dogpile.cache.memory](https://dogpilecache.sqlalchemy.org/en/latest/api.html#memory-backends)

- [dogpile.cache.memcached](https://dogpilecache.sqlalchemy.org/en/latest/api.html#memcached-backends)

  

   

  Note 注意

  

  The memory back end is not suitable for use in a production environment.
  内存后端不适合在生产环境中使用。

- [dogpile.cache.redis](https://dogpilecache.sqlalchemy.org/en/latest/api.html#redis-backends)

- [dogpile.cache.dbm](https://dogpilecache.sqlalchemy.org/en/latest/api.html#file-backends)



### Cache invalidation[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#cache-invalidation) 缓存失效 ¶

A common concern with caching is relaying inaccurate information after updating or deleting a resource. Most subsystems within OpenStack Identity invalidate specific cache entries once they have changed. In cases where a specific cache entry cannot be invalidated from the cache, the cache region will be invalidated instead. This invalidates all entries within the cache to prevent returning stale or misleading data. A subsequent request for the resource will be fully processed and cached.
缓存的一个常见问题是在更新或删除资源后中继不准确的信息。OpenStack Identity  中的大多数子系统在更改特定缓存条目后都会失效。如果无法从缓存中使特定缓存条目失效，则缓存区域将失效。这将使缓存中的所有条目无效，以防止返回过时或误导性数据。对资源的后续请求将被完全处理和缓存。



 

Warning 警告



Be aware that if a read-only back end is in use for a particular subsystem, the cache will not immediately reflect changes performed through the back end. Any given change may take up to the `cache_time` (if set in the subsystem section of the configuration) or the global `expiration_time` (set in the `[cache]` section of the configuration) before it is reflected. If this type of delay is an issue, we recommend disabling caching for that particular subsystem.
请注意，如果只读后端用于特定子系统，则缓存不会立即反映通过后端执行的更改。任何给定的更改都可能需要 （ `cache_time` 如果在配置的子系统部分中设置）或全局 `expiration_time` （在配置 `[cache]` 的部分中设置） 才能反映出来。如果这种类型的延迟是一个问题，我们建议禁用该特定子系统的缓存。

### Configure the Memcached back end example[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#configure-the-memcached-back-end-example) 配置 Memcached 后端示例 ¶

The following example shows how to configure the memcached back end:
以下示例演示如何配置 memcached 后端：

```
[cache]

enabled = true
backend = dogpile.cache.memcached
backend_argument = url:127.0.0.1:11211
```

You need to specify the URL to reach the `memcached` instance with the `backend_argument` parameter.
您需要指定 URL 才能使用该 `backend_argument` 参数访问 `memcached` 实例。

### Verbose cache logging[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#verbose-cache-logging) 详细缓存日志记录 ¶

We do not recommend using verbose cache logging by default in production systems since it’s extremely noisy. However, you may need to debug cache issues. One way to see how keystone is interacting with a cache backend is to enhance logging. The following configuration will aggregate oslo and dogpile logs into keystone’s log file with increased verbosity:
默认情况下，我们不建议在生产系统中使用详细缓存日志记录，因为它非常嘈杂。但是，您可能需要调试缓存问题。查看 keystone 如何与缓存后端交互的一种方法是增强日志记录。以下配置会将 oslo 和 dogpile 日志聚合到 keystone  的日志文件中，并增加详细程度：

```
[DEFAULT]
default_log_levels = oslo.cache=DEBUG,dogpile.core.dogpile=DEBUG

[cache]
debug_cache_backend = True
```

These logs will include cache hits and misses, making it easier to diagnose cache configuration and connectivity issues.
这些日志将包括缓存命中和未命中，从而更轻松地诊断缓存配置和连接问题。



## Security compliance and PCI-DSS[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#security-compliance-and-pci-dss) 安全合规性和 PCI-DSS ¶

As of the Newton release, the Identity service contains additional security compliance features, specifically to satisfy Payment Card Industry - Data Security Standard (PCI-DSS) v3.1 requirements. See [Security Hardening PCI-DSS](https://specs.openstack.org/openstack/keystone-specs/specs/keystone/newton/pci-dss.html) for more information on PCI-DSS.
从 Newton 版本开始，Identity 服务包含额外的安全合规性功能，专门用于满足支付卡行业 - 数据安全标准 （PCI-DSS） v3.1 要求。有关 PCI-DSS 的更多信息，请参阅安全加固 PCI-DSS。

Security compliance features are disabled by default and most of the features only apply to the SQL backend for the identity driver. Other identity backends, such as LDAP, should implement their own security controls.
默认情况下，安全合规性功能处于禁用状态，并且大多数功能仅适用于标识驱动程序的 SQL 后端。其他身份后端（如 LDAP）应实现自己的安全控制。

Enable these features by changing the configuration settings under the `[security_compliance]` section in `keystone.conf`.
通过更改 中 `[security_compliance]` `keystone.conf` 部分下的配置设置来启用这些功能。

### Setting an account lockout threshold[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#setting-an-account-lockout-threshold) 设置帐户锁定阈值 ¶

The account lockout feature limits the number of incorrect password attempts. If a user fails to authenticate after the maximum number of attempts, the service disables the user. Users can be re-enabled by explicitly setting the enable user attribute with the update user [v3](https://docs.openstack.org/api-ref/identity/v3/index.html#update-user) API call.
帐户锁定功能限制错误密码尝试的次数。如果用户在最大尝试次数后无法进行身份验证，则服务将禁用该用户。可以通过使用更新用户 v3 API 调用显式设置 enable user 属性来重新启用用户。

You set the maximum number of failed authentication attempts by setting the `lockout_failure_attempts`:
您可以通过设置以下命令来设置最大失败的身份验证尝试次数 `lockout_failure_attempts` ：

```
[security_compliance]
lockout_failure_attempts = 6
```

You set the number of minutes a user would be locked out by setting the `lockout_duration` in seconds:
您可以通过设置以秒 `lockout_duration` 为单位来设置用户被锁定的分钟数：

```
[security_compliance]
lockout_duration = 1800
```

If you do not set the `lockout_duration`, users will be locked out indefinitely until the user is explicitly enabled via the API.
如果不设置 `lockout_duration` ，用户将被无限期锁定，直到通过 API 显式启用用户。

You can ensure specific users are never locked out. This can be useful for service accounts or administrative users. You can do this by setting the user option for [ignore_lockout_failure_attempts](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-lockout-failure-attempts).
您可以确保特定用户永远不会被锁定。这对于服务帐户或管理用户很有用。您可以通过设置 ignore_lockout_failure_attempts 的用户选项来执行此操作。

### Disabling inactive users[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#disabling-inactive-users) 禁用非活动用户 ¶

PCI-DSS 8.1.4 requires that inactive user accounts be removed or disabled within 90 days. You can achieve this by setting the `disable_user_account_days_inactive`:
PCI-DSS 8.1.4 要求在 90 天内删除或禁用非活动用户帐户。您可以通过设置 `disable_user_account_days_inactive` 以下内容来实现此目的：

```
[security_compliance]
disable_user_account_days_inactive = 90
```

This above example means that users that have not authenticated (inactive) for the past 90 days are automatically disabled. Users can be re-enabled by explicitly setting the enable user attribute via the API.
上述示例意味着过去 90 天内未进行身份验证（非活动）的用户将被自动禁用。可以通过 API 显式设置 enable user 属性来重新启用用户。

### Force users to change password upon first use[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#force-users-to-change-password-upon-first-use) 强制用户在首次使用时更改密码 ¶

PCI-DSS 8.2.6 requires users to change their password for first time use and upon an administrative password reset. Within the identity [user API](https://docs.openstack.org/api-ref/identity/v3/index.html#users), create user and update user are considered administrative password changes. Whereas, change password for user is a self-service password change. Once this feature is enabled, new users, and users that have had their password reset, will be required to change their password upon next authentication (first use), before being able to access any services.
PCI-DSS 8.2.6 要求用户在首次使用和管理密码重置时更改其密码。在身份用户 API  中，创建用户和更新用户被视为管理密码更改。而更改用户密码是自助密码更改。启用此功能后，新用户和已重置密码的用户将需要在下次身份验证（首次使用）时更改密码，然后才能访问任何服务。

Prior to enabling this feature, you may want to exempt some users that you do not wish to be required to change their password. You can mark a user as exempt by setting the user options attribute [ignore_change_password_upon_first_use](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-change-password-upon-first-use).
在启用此功能之前，您可能希望免除一些您不希望被要求更改其密码的用户。您可以通过设置用户选项属性ignore_change_password_upon_first_use将用户标记为豁免。



 

Warning 警告



Failure to mark service users as exempt from this requirement will result in your service account passwords becoming expired after being reset.
如果未能将服务用户标记为免于此要求，将导致您的服务帐户密码在重置后过期。

When ready, you can configure it so that users are forced to change their password upon first use by setting `change_password_upon_first_use`:
准备就绪后，您可以对其进行配置，以便用户在首次使用时强制更改其密码，方法是设置 `change_password_upon_first_use` ：

```
[security_compliance]
change_password_upon_first_use = True
```

### Configuring password expiration[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#configuring-password-expiration) 配置密码过期 ¶

Passwords can be configured to expire within a certain number of days by setting the `password_expires_days`:
密码可以配置为在一定天数内过期 `password_expires_days` ，方法是设置：

```
[security_compliance]
password_expires_days = 90
```

Once set, any new password changes have an expiration date based on the date/time of the password change plus the number of days defined here. Existing passwords will not be impacted. If you want existing passwords to have an expiration date, you would need to run a SQL script against the password table in the database to update the expires_at column.
设置后，任何新密码更改的到期日期都基于密码更改的日期/时间加上此处定义的天数。现有密码不会受到影响。如果希望现有密码具有到期日期，则需要对数据库中的密码表运行 SQL 脚本以更新expires_at列。

If there exists a user whose password you do not want to expire, keystone supports setting that via the user option [ignore_password_expiry](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-password-expiry).
如果存在您不希望其密码过期的用户，keystone 支持通过用户选项 ignore_password_expiry 进行设置。

### Configuring password strength requirements[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#configuring-password-strength-requirements) 配置密码强度要求 ¶

You can set password strength requirements, such as requiring numbers in passwords or setting a minimum password length, by adding a regular expression to the `password_regex` setting:
您可以通过向 `password_regex` 设置添加正则表达式来设置密码强度要求，例如要求密码中的数字或设置最小密码长度：

```
[security_compliance]
password_regex = ^(?=.*\d)(?=.*[a-zA-Z]).{7,}$
```

The above example is a regular expression that requires a password to have:
上面的示例是一个正则表达式，需要密码才能具有：

- One (1) letter 一 （1） 封信
- One (1) digit 一 （1） 位数字
- Minimum length of seven (7) characters
  最小长度为七 （7） 个字符

If you do set the `password_regex`, you should provide text that describes your password strength requirements. You can do this by setting the `password_regex_description`:
如果确实设置了 `password_regex` ，则应提供描述密码强度要求的文本。您可以通过设置以下内容 `password_regex_description` 来执行此操作：

```
[security_compliance]
password_regex_description = Passwords must contain at least 1 letter, 1
                             digit, and be a minimum length of 7
                             characters.
```

It is imperative that the `password_regex_description` matches the actual regex. If the `password_regex` and the `password_regex_description` do not match, it will cause user experience to suffer since this description will be returned to users to explain why their requested password was insufficient.
必须与 `password_regex_description` 实际的正则表达式匹配。如果 `password_regex` 和 不 `password_regex_description` 匹配，则会导致用户体验受到影响，因为此描述将返回给用户，以解释为什么他们请求的密码不足。



 

Note 注意



You must ensure the `password_regex_description` accurately and completely describes the `password_regex`. If the two options are out of sync, the help text could inaccurately describe the password requirements being applied to the password. This would lead to a poor user experience.
您必须确保准确、完整地 `password_regex_description` 描述 `password_regex` .如果这两个选项不同步，则帮助文本可能会不准确地描述应用于密码的密码要求。这将导致糟糕的用户体验。

### Requiring a unique password history[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#requiring-a-unique-password-history) 需要唯一的密码历史记录 ¶

The password history requirements controls the number of passwords for a user that must be unique before an old password can be reused. You can enforce this by setting the `unique_last_password_count`:
密码历史记录要求控制用户的密码数，这些密码必须是唯一的，然后才能重复使用旧密码。您可以通过设置以下命令 `unique_last_password_count` 来强制执行此操作：

```
[security_compliance]
unique_last_password_count= 5
```

The above example does not allow a user to create a new password that is the same as any of their last four previous passwords.
上面的示例不允许用户创建与其前四个密码中的任何一个相同的新密码。

Similarly, you can set the number of days that a password must be used before the user can change it by setting the `minimum_password_age`:
同样，您可以通过设置以下命令来设置用户必须使用密码才能更改密码的天数 `minimum_password_age` ：

```
[security_compliance]
minimum_password_age = 1
```

In the above example, once a user changes their password, they would not be able to change it again for one day. This prevents users from changing their passwords immediately in order to wipe out their password history and reuse an old password.
在上面的示例中，一旦用户更改了密码，他们将在一天内无法再次更改密码。这可以防止用户立即更改其密码以清除其密码历史记录并重复使用旧密码。



 

Note 注意



When you set `password_expires_days`, the value for the `minimum_password_age` should be less than the `password_expires_days`. Otherwise, users would not be able to change their passwords before they expire.
设置 `password_expires_days` 时，的 `minimum_password_age` 值应小于 `password_expires_days` 。否则，用户将无法在密码过期之前更改密码。

### Prevent Self-Service Password Changes[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#prevent-self-service-password-changes) 防止自助密码更改 ¶

If there exists a user who should not be able to change her own password via the keystone password change API, keystone supports setting that via the user option [lock_password](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#lock-password).
如果存在无法通过 keystone 密码更改 API 更改自己的密码的用户，keystone 支持通过用户选项lock_password进行设置。

This is typically used in the case where passwords are managed externally to keystone.
这通常用于密码在Keystone外部管理的情况。

## Performance and scaling[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#performance-and-scaling) 性能和扩展 ¶

Before you begin tuning Keystone for performance and scalability, you should first know that Keystone is just a two tier horizontally-scalable web application, and the most effective methods for scaling it are going to be the same as for any other similarly designed web application: give it more processes, more memory, scale horizontally, and load balance the result.
在开始调整 Keystone 的性能和可伸缩性之前，您应该首先知道 Keystone 只是一个两层水平可扩展的 Web 应用程序，并且扩展它的最有效方法将与任何其他类似设计的 Web 应用程序相同：为它提供更多进程、更多内存、水平扩展以及负载均衡结果。

With that said, there are many opportunities for tuning the performance of Keystone, many of which are actually trade-offs between performance and security that you need to judge for yourself, and tune accordingly.
话虽如此，有很多机会可以调整 Keystone 的性能，其中许多实际上是性能和安全性之间的权衡，您需要自己判断并相应地进行调整。

### Keystone configuration options that affect performance[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#keystone-configuration-options-that-affect-performance) 影响性能的 Keystone 配置选项 ¶

These are all of the options in `keystone.conf` that have a direct impact on performance. See the help descriptions for these options for more specific details on how and why you might want to tune these options for yourself.
这些都是对性能有直接影响的选项 `keystone.conf` 。请参阅这些选项的帮助说明，了解有关如何以及为什么需要自行调整这些选项的更多具体详细信息。

- `[DEFAULT] max_project_tree_depth`: Reduce this number to increase performance, increase this number to cater to more complicated hierarchical multitenancy use cases.
   `[DEFAULT] max_project_tree_depth` ：减少此数字以提高性能，增加此数字以满足更复杂的分层多租户用例。
- `[DEFAULT] max_password_length`: Reduce this number to increase performance, increase this number to allow for more secure passwords.
   `[DEFAULT] max_password_length` ：减少此数字以提高性能，增加此数字以允许更安全的密码。
- `[cache] enable`: Enable this option to increase performance, but you also need to configure other options in the `[cache]` section to actually utilize caching.
   `[cache] enable` ：启用此选项可提高性能，但您还需要配置本节 `[cache]` 中的其他选项以实际使用缓存。
- `[token] provider`: All supported token providers have been primarily driven by performance considerations. UUID and Fernet both require online validation (cacheable HTTP calls back to keystone to validate tokens). Fernet has the highest scalability characteristics overall, but requires more work to validate, and therefore enabling caching (`[cache] enable`) is absolutely critical.
   `[token] provider` ：所有受支持的令牌提供程序主要受性能考虑因素驱动。UUID 和 Fernet 都需要在线验证（可缓存的 HTTP 回调 keystone 以验证令牌）。Fernet 总体上具有最高的可伸缩性特征，但需要更多的工作来验证，因此启用缓存 （ `[cache] enable` ） 绝对至关重要。
- `[fernet] max_active_keys`: If you’re using Fernet tokens, decrease this option to improve performance, increase this option to support more advanced key rotation strategies.
   `[fernet] max_active_keys` ：如果您使用的是 Fernet 令牌，请减少此选项以提高性能，增加此选项以支持更高级的密钥轮换策略。

### Keystonemiddleware configuration options that affect performance[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#keystonemiddleware-configuration-options-that-affect-performance) 影响性能的 Keystone中间件配置选项 ¶

This configuration actually lives in the Paste pipelines of services consuming token validation from keystone (i.e.: nova, cinder, swift, etc.).
此配置实际上位于使用来自 keystone 的令牌验证的服务的 Paste 管道中（即：nova、cinder、swift 等）。

- `cache`: When keystone’s auth_token middleware is deployed with a swift cache, use this option to have auth_token middleware share a caching backend with swift. Otherwise, use the `memcached_servers` option instead.
   `cache` ：当 keystone 的 auth_token 中间件使用 swift 缓存部署时，请使用此选项让auth_token中间件与 swift 共享缓存后端。否则，请改用该 `memcached_servers` 选项。
- `memcached_servers`: Set this option to share a cache across `keystonemiddleware.auth_token` processes.
   `memcached_servers` ：设置此选项以跨 `keystonemiddleware.auth_token` 进程共享缓存。
- `token_cache_time`: Increase this option to improve performance, decrease this option to respond to token revocation events more quickly (thereby increasing security).
   `token_cache_time` ：增加此选项以提高性能，减少此选项可更快地响应令牌吊销事件（从而提高安全性）。
- `revocation_cache_time`: Increase this option to improve performance, decrease this option to respond to token revocation events more quickly (thereby increasing security).
   `revocation_cache_time` ：增加此选项以提高性能，减少此选项可更快地响应令牌吊销事件（从而提高安全性）。
- `memcache_security_strategy`: Do not set this option to improve performance, but set it to improve security where you’re sharing memcached with other processes.
   `memcache_security_strategy` ：设置此选项不是为了提高性能，而是为了提高与其他进程共享 memcached 的安全性。
- `include_service_catalog`: Disable this option to improve performance, if the protected service does not require a service catalog.
   `include_service_catalog` ：如果受保护的服务不需要服务目录，则禁用此选项以提高性能。

## URL safe naming of projects and domains[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#url-safe-naming-of-projects-and-domains) 项目和域的 URL 安全命名 ¶

In the future, keystone may offer the ability to identify a project in a hierarchy via a URL style of naming from the root of the hierarchy (for example specifying ‘projectA/projectB/projectC’ as the project name in an authentication request). In order to prepare for this, keystone supports the optional ability to ensure both projects and domains are named without including any of the reserved characters specified in section 2.2 of [rfc3986](http://tools.ietf.org/html/rfc3986).
将来，keystone 可能会提供通过层次结构根目录的 URL  样式命名来标识层次结构中的项目的功能（例如，在身份验证请求中指定“projectA/projectB/projectC”作为项目名称）。为了做好准备，keystone 支持可选功能，以确保项目和域的命名都不包含 rfc3986 第 2.2 节中指定的任何保留字符。

The safety of the names of projects and domains can be controlled via two configuration options:
项目和域名称的安全性可以通过两个配置选项进行控制：

```
[resource]
project_name_url_safe = off
domain_name_url_safe = off
```

When set to `off` (which is the default), no checking is done on the URL safeness of names. When set to `new`, an attempt to create a new project or domain with an unsafe name (or update the name of a project or domain to be unsafe) will cause a status code of 400 (Bad Request) to be returned. Setting the configuration option to `strict` will, in addition to preventing the creation and updating of entities with unsafe names, cause an authentication attempt which specifies a project or domain name that is unsafe to return a status code of 401 (Unauthorized).
设置为 `off` （默认值）时，不会对名称的 URL 安全性进行检查。如果设置为 `new` ，则尝试使用不安全的名称创建新项目或域（或将项目或域的名称更新为不安全）将导致返回状态代码 400（错误请求）。将配置选项设置为 `strict` 除了防止创建和更新具有不安全名称的实体外，还会导致指定不安全的项目或域名的身份验证尝试返回状态代码 401 （Unauthorized） 。

It is recommended that installations take the steps necessary to where they can run with both options set to `strict` as soon as is practical.
建议在可行的情况下尽快将两个选项设置为 `strict` 可以运行的安装步骤。

## Limiting list return size[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#limiting-list-return-size) 限制列表返回大小 ¶

Keystone provides a method of setting a limit to the number of entities returned in a collection, which is useful to prevent overly long response times for list queries that have not specified a sufficiently narrow filter. This limit can be set globally by setting `list_limit` in the default section of `keystone.conf`, with no limit set by default. Individual driver sections may override this global value with a specific limit, for example:
Keystone 提供了一种对集合中返回的实体数设置限制的方法，这对于防止未指定足够窄的筛选器的列表查询的响应时间过长非常有用。可以通过在 的默认部分中设置 `list_limit` 来全局设置此限制 `keystone.conf` ，默认情况下不设置任何限制。单个驱动程序部分可能会使用特定限制覆盖此全局值，例如：

```
[resource]
list_limit = 100
```

If a response to `list_{entity}` call has been truncated, then the response status code will still be 200 (OK), but the `truncated` attribute in the collection will be set to `true`.
如果对 `list_{entity}` 调用的响应已被截断，则响应状态代码仍将为 200 （OK） ，但集合中的 `truncated` 属性将设置为 `true` 。

## Endpoint Filtering[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#endpoint-filtering) 端点过滤 ¶

Endpoint Filtering enables creation of ad-hoc catalogs for each project-scoped token request.
终结点筛选允许为每个项目范围的令牌请求创建临时目录。

Configure the endpoint filter catalog driver in the `[catalog]` section. For example:
在 `[catalog]` 本节中配置终结点筛选器目录驱动程序。例如：

```
[catalog]
driver = catalog_sql
```

In the `[endpoint_filter]` section, set `return_all_endpoints_if_no_filter` to `False` to return an empty catalog if no associations are made. For example:
在该 `[endpoint_filter]` 部分中，设置为 `return_all_endpoints_if_no_filter`  `False` 在未进行关联时返回空目录。例如：

```
[endpoint_filter]
return_all_endpoints_if_no_filter = False
```

See [API Specification for Endpoint Filtering](https://docs.openstack.org/api-ref/identity/v3-ext/#os-ep-filter-api) for the details of API definition.
有关 API 定义的详细信息，请参阅端点过滤的 API 规范。

## Endpoint Policy[¶](https://docs.openstack.org/keystone/yoga/admin/configuration.html#endpoint-policy) 端点策略 ¶

The Endpoint Policy feature provides associations between service endpoints and policies that are already stored in the Identity server and referenced by a policy ID.
终端节点策略功能提供服务终端与策略之间的关联，这些策略已存储在身份服务器中并由策略 ID 引用。

Configure the endpoint policy backend driver in the `[endpoint_policy]` section. For example:
在本节 `[endpoint_policy]` 中配置端点策略后端驱动程序。例如：

```
[endpoint_policy]
driver = sql
```

See [API Specification for Endpoint Policy](https://docs.openstack.org/api-ref/identity/v3-ext/index.html#os-endpoint-policy-api) for the details of API definition.
有关 API 定义的详细信息，请参阅 Endpoint Policy 的 API 规范。





# Case-Insensitivity in keystone keystone 中的不区分大小写

​                                          

Keystone currently handles the case-sensitivity for the naming of each resource a bit differently, depending on the resource itself, and the backend used. For example, depending on whether a user is backed by local SQL or LDAP, the case-sensitivity can be different. When it is case-insensitive, the casing will be preserved. For instance, a project with the name “myProject” will not end up changing to either all lower or upper case.
Keystone 目前对每个资源命名的区分大小写略有不同，具体取决于资源本身和所使用的后端。例如，根据用户是受本地 SQL 还是 LDAP  支持，区分大小写可能会有所不同。当它不区分大小写时，将保留大小写。例如，名称为“myProject”的项目最终不会全部更改为小写或大写。

## Resources in keystone[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#resources-in-keystone) keystone 中的资源 ¶

Below are examples of case-insensitivity in keystone for users, projects, and roles.
下面是用户、项目和角色的 keystone 中不区分大小写的示例。

### Users[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#users) 用户 ¶

If a user with the name “MyUser” already exists, then the following call which creates a new user by the name of “myuser” will return a `409 Conflict`:
如果名称为“MyUser”的用户已存在，则以下名为“myuser”的新用户的调用将返回： `409 Conflict` 

```
POST /v3/users
{
    "user": {
        "name": "myuser"
    }
}
```

### Projects[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#projects) 项目 ¶

If a project with the name “Foobar” already exists, then the following call which creates a new project by the name of “foobar” will return a `409 Conflict`:
如果名称为“Foobar”的项目已存在，则以下创建名为“foobar”的新项目的调用将返回： `409 Conflict` 

```
POST /v3/projects
{
    "project": {
        "name": "foobar"
    }
}
```

#### Project Tags[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#project-tags) 项目标签 ¶

While project names are case-insensitive, project tags are case-sensitive. A tag with the value of `mytag` is different than `MyTag`, and both values can be stored in the same project.
虽然项目名称不区分大小写，但项目标记区分大小写。值为 `mytag` 的标签不同于 `MyTag` ，并且这两个值可以存储在同一个项目中。

### Roles[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#roles) 角色 ¶

Role names are case-insensitive. for example, when keystone bootstraps default roles, it creates “admin”, “member”, and “reader”. If another role, “Member” (note the upper case ‘M’) is created, keystone will return a `409 Conflict` since it considers the name “Member” equivalent to “member”. Note that case is preserved in this event.
角色名称不区分大小写。例如，当 Keystone 引导默认角色时，它会创建“admin”、“member”和“reader”。如果创建了另一个角色“Member”（注意大写字母“M”），keystone 将返回 a `409 Conflict` ，因为它认为名称“Member”等同于“member”。请注意，在此事件中保留大小写。



 

Note 注意



As of the Rocky release, keystone will create three default roles when keystone-manage bootstrap is run: (`admin`, `member`, `reader`). For existing deployments, this can cause issues if an existing role matches one of these roles. Even if the casing is not an exact match (`member` vs `Member`), it will report an error since roles are considered case-insensitive.
从 Rocky 版本开始，keystone 将在运行 keystone-manage 引导程序时创建三个默认角色：（ `admin` ， `member` ， `reader` ）。对于现有部署，如果现有角色与其中一个角色匹配，则可能会导致问题。即使大小写不完全匹配 （ `member` vs `Member` ），它也会报告错误，因为角色被认为不区分大小写。

## Backends[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#backends) 后端 ¶

For each of these examples, we will refer to an existing project with the name “mYpRoJeCt” and user with the name “mYuSeR”. The examples here are exaggerated to help display the case handling for each backend.
对于这些示例中的每一个，我们将引用名为“mYpRoJeCt”的现有项目和名为“mYuSeR”的用户。此处的示例被夸大，以帮助显示每个后端的案例处理。

### MySQL & SQLite[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#mysql-sqlite) MySQL和SQLite ¶

By default, MySQL/SQLite are case-insensitive but case-preserving for varchar. This means that setting a project name of “mYpRoJeCt” will cause attempting to create a new project named “myproject” to fail with keystone returning a `409 Conflict`. However, the original value of “mYpRoJeCt” will still be returned since case is preserved.
默认情况下，MySQL/SQLite 不区分大小写，但对 varchar 保留大小写。这意味着将项目名称设置为“mYpRoJeCt”将导致尝试创建名为“myproject”的新项目失败，keystone 返回 `409 Conflict` .但是，由于保留了大小写，因此仍将返回“mYpRoJeCt”的原始值。

Users will be treated the same, if another user is added with the name “myuser”, keystone will respond with `409 Conflict` since another user with the (same) name exists (“mYuSeR”).
如果添加另一个用户的名称为“myuser”，则 keystone 将响应， `409 Conflict` 因为存在另一个具有（相同）名称的用户（“mYuSeR”）。

### PostgreSQL[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#postgresql) PostgreSQL的 ¶

PostgreSQL is case-sensitive by default, so if a project by the name of “myproject” is created with the existing “mYpRoJeCt”, it will be created successfully.
默认情况下，PostgreSQL 区分大小写，因此，如果使用现有的“mYpRoJeCt”创建名为“myproject”的项目，则将成功创建该项目。

### LDAP[¶](https://docs.openstack.org/keystone/yoga/admin/case-insensitive.html#ldap) LDAP协议 ¶

By default, LDAP DNs are case-insensitive, so the example with users under MySQL will apply here as well.
默认情况下，LDAP DN 不区分大小写，因此 MySQL 下用户的示例也适用于此处。

​                      

# Managing trusts 管理信任

​                                          

A trust is an OpenStack Identity extension that enables delegation and, optionally, impersonation through `keystone`. See the [user guide on using trusts](https://docs.openstack.org/keystone/yoga/user/trusts.html).
信任是一个 OpenStack Identity 扩展，它支持委派，也可以选择通过 `keystone` 进行模拟。请参阅有关使用信任的用户指南。

## Removing Expired Trusts[¶](https://docs.openstack.org/keystone/yoga/admin/manage-trusts.html#removing-expired-trusts) 删除过期的信任 ¶

In the SQL trust stores expired and soft deleted trusts, that are not automatically removed. These trusts can be removed with:
在 SQL 信任存储中，不会自动删除过期和软删除的信任。可以通过以下方式删除这些信任：

```
   $ keystone-manage trust_flush [options]

OPTIONS (optional):

       --project-id <string>:
                   To purge trusts of given project-id.
       --trustor-user-id <string>:
                   To purge trusts of given trustor-id.
       --trustee-user-id <string>:
                   To purge trusts of given trustee-id.
       --date <string>:
                   To purge trusts older than date. If no date is supplied
                   keystone-manage will use the system clock time at runtime.
```

# Keystone tokens Keystone 代币

​                                          

Tokens are used to authenticate and authorize your interactions with OpenStack APIs. Tokens come in many scopes, representing various authorization and sources of identity.
令牌用于验证和授权您与 OpenStack API 的交互。令牌具有多种作用域，表示各种授权和标识源。



## Authorization scopes[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#authorization-scopes) 授权范围 ¶

Tokens are used to relay information about your role assignments. It’s not uncommon for a user to have multiple role assignments, sometimes spanning projects, domains, or the entire system. These are referred to as authorization scopes, where a token has a single scope of operation (e.g., a project, domain, or the system). For example, a token scoped to a project can’t be reused to do something else in a different project.
令牌用于中继有关角色分配的信息。用户具有多个角色分配的情况并不少见，有时跨越项目、域或整个系统。这些称为授权范围，其中令牌具有单个操作范围（例如，项目、域或系统）。例如，作用域为项目的令牌不能重用于在其他项目中执行其他操作。

Each level of authorization scope is useful for certain types of operations in certain OpenStack services, and are not interchangeable.
每个级别的授权范围对于某些 OpenStack 服务中的某些类型的操作都很有用，并且不可互换。

### Unscoped tokens[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#unscoped-tokens) 无作用域令牌 ¶

An unscoped token does not contain a service catalog, roles, or authorization scope (e.g., project, domain, or system attributes within the token). Their primary use case is simply to prove your identity to keystone at a later time (usually to generate scoped tokens), without repeatedly presenting your original credentials.
无作用域令牌不包含服务目录、角色或授权作用域（例如，令牌中的项目、域或系统属性）。他们的主要用例只是在以后向 keystone 证明您的身份（通常用于生成作用域内的令牌），而无需重复提供您的原始凭据。

The following conditions must be met to receive an unscoped token:
必须满足以下条件才能接收无作用域令牌：

- You must not specify an authorization scope in your authentication request (for example, on the command line with arguments such as `--os-project-name` or `--os-domain-id`),
  您不得在身份验证请求中指定授权范围（例如，在命令行上使用 `--os-project-name` 诸如 或 `--os-domain-id` ） 等参数指定授权范围
- Your identity must not have a “default project” associated with it that you also have role assignments, and thus authorization, upon.
  你的标识不得具有与之关联的“默认项目”，而你还具有角色分配，因此也具有授权。

### Project-scoped tokens[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#project-scoped-tokens) 项目范围的令牌 ¶

Projects are containers for resources, like volumes or instances. Project-scoped tokens express your authorization to operate in a specific tenancy of the cloud and are useful for things like spinning up compute resources or carving off block storage. They contain a service catalog, a set of roles, and information about the project.
项目是资源（如卷或实例）的容器。项目范围的令牌表示您有权在云的特定租户中运行，对于启动计算资源或剥离块存储等操作非常有用。它们包含一个服务目录、一组角色和有关项目的信息。

Most end-users need role assignments on projects to consume resources in a deployment.
大多数最终用户需要对项目进行角色分配才能使用部署中的资源。

### Domain-scoped tokens[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#domain-scoped-tokens) 域范围的令牌 ¶

Domains are namespaces for projects, users, and groups. A domain-scoped token expresses your authorization to operate on the contents of a domain or the domain itself.
域是项目、用户和组的命名空间。域范围的令牌表示您有权对域的内容或域本身进行操作。

While some OpenStack services are still adopting the domain concept, domains are fully supported in keystone. This means users with authorization on a domain have the ability to manage things within the domain. For example, a domain administrator can create new users and projects within that domain.
虽然一些OpenStack服务仍在采用域概念，但keystone完全支持域。这意味着在域上具有授权的用户能够管理域内的内容。例如，域管理员可以在该域中创建新用户和项目。

Domain-scoped tokens contain a service catalog, roles, and information about the domain.
域范围的令牌包含服务目录、角色和有关域的信息。

People who need to manage users and projects typically need domain-level access.
需要管理用户和项目的人员通常需要域级访问权限。

### System-scoped tokens[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#system-scoped-tokens) 系统范围的令牌 ¶

Some OpenStack APIs fit nicely within the concept of projects (e.g., creating an instance) or domains (e.g., creating a new user), but there are also APIs that affect the entire deployment system (e.g. modifying endpoints, service management, or listing information about hypervisors). These operations are typically reserved for operators and require system-scoped tokens, which represents the role assignments a user has to operate on the deployment as a whole. The term *system* refers to the deployment system, which is a collection of hardware (e.g., compute nodes) and services (e.g., nova, cinder, neutron, barbican, keystone) that provide Infrastructure-as-a-Service.
一些OpenStack  API非常适合项目（例如，创建实例）或域（例如，创建新用户）的概念，但也有一些API会影响整个部署系统（例如，修改端点，服务管理或列出有关虚拟机管理程序的信息）。这些操作通常保留给操作员，并且需要系统范围的令牌，这表示用户必须对整个部署进行操作的角色分配。术语系统是指部署系统，它是提供基础架构即服务的硬件（例如，计算节点）和服务（例如，nova、cinder、neutron、barbican、keystone）的集合。

System-scoped tokens contain a service catalog, roles, and information about the *system*. System role assignments and system-scoped tokens are typically reserved for operators and cloud administrators.
系统范围的令牌包含服务目录、角色和有关系统的信息。系统角色分配和系统范围的令牌通常保留给操作员和云管理员。

## Token providers[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#token-providers) 代币提供者 ¶

The token type issued by keystone is configurable through the `/etc/keystone/keystone.conf` file. Currently, there are two supported token providers, `fernet` and `jws`.
keystone 颁发的令牌类型可通过 `/etc/keystone/keystone.conf` 文件进行配置。目前，有两个受支持的令牌提供程序， `fernet` 以及 `jws` .

### Fernet tokens[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#fernet-tokens) Fernet 代币 ¶

The fernet token format was introduced in the OpenStack Kilo release and now is the default token provider in Keystone. Unlike the other token types mentioned in this document, fernet tokens do not need to be persisted in a back end. `AES256` encryption is used to protect the information stored in the token and integrity is verified with a `SHA256 HMAC` signature. Only the Identity service should have access to the keys used to encrypt and decrypt fernet tokens. Like UUID tokens, fernet tokens must be passed back to the Identity service in order to validate them. For more information on the fernet token type, see the [Fernet - Frequently Asked Questions](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html).
fernet 代币格式是在 OpenStack Kilo 版本中引入的，现在是 Keystone 中的默认代币提供者。与本文档中提到的其他令牌类型不同，fernet 令牌不需要在后端持久化。 `AES256` 加密用于保护存储在令牌中的信息，并通过 `SHA256 HMAC` 签名验证完整性。只有 Identity 服务才能访问用于加密和解密 fernet 令牌的密钥。与 UUID 令牌一样，fernet  令牌必须传递回 Identity 服务才能验证它们。有关 fernet 令牌类型的更多信息，请参阅 Fernet - 常见问题。

A deployment might consider using the fernet provider as opposed to JWS tokens if they are concerned about public expose of the payload used to build tokens.
如果部署担心用于构建令牌的有效负载的公开公开，则可以考虑使用 fernet 提供程序而不是 JWS 令牌。

### JWS tokens[¶](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#jws-tokens) JWS 代币 ¶

The JSON Web Signature (JWS) token format is a type of JSON Web Token (JWT) and it was implemented in the Stein release. JWS tokens are signed, meaning the information used to build the token ID is not opaque to users and can it can be decoded by anyone. JWS tokens are ephemeral, or non-persistent, which means they won’t bloat the database or require replication across nodes. Since the JWS token provider uses asymmetric keys, the tokens are signed with private keys and validated with public keys. The JWS token provider implementation only supports the `ES256` JSON Web Algorithm (JWA), which is an Elliptic Curve Digital Signature Algorithm (ECDSA) using the P-256 curve and a SHA-256 hash algorithm.
JSON Web 签名 （JWS） 令牌格式是一种 JSON Web 令牌 （JWT），它是在 Stein 版本中实现的。JWS  令牌是经过签名的，这意味着用于构建令牌 ID  的信息对用户来说不是不透明的，任何人都可以解码。JWS令牌是短暂的或非持久的，这意味着它们不会使数据库膨胀或需要跨节点复制。由于 JWS  令牌提供程序使用非对称密钥，因此令牌使用私钥进行签名，并使用公钥进行验证。JWS 令牌提供程序实现仅支持 `ES256` JSON Web 算法 （JWA），这是一种使用 P-256 曲线和 SHA-256 哈希算法的椭圆曲线数字签名算法 （ECDSA）。

A deployment might consider using JWS tokens as opposed to fernet tokens if there are security concerns about sharing symmetric encryption keys across hosts. Note that a major difference between the two providers is that JWS tokens are not opaque and can be decoded by anyone with the token ID. Fernet tokens are opaque in that the token ID is ciphertext. Despite the JWS token payload being readable by anyone, keystone reserves the right to make backwards incompatible changes to the token payload itself, which is not an API contract. We only recommend validating the token against keystone’s authentication API to inspect its associated metadata. We strongly discourage relying on decoded payloads for information about tokens.
如果存在有关在主机之间共享对称加密密钥的安全问题，则部署可能会考虑使用 JWS 令牌而不是 fernet 令牌。请注意，这两个提供程序之间的一个主要区别是 JWS 令牌不是不透明的，并且可以由具有令牌 ID  的任何人解码。 Fernet 令牌是不透明的，因为令牌 ID 是密文。尽管任何人都可以读取 JWS 令牌有效负载，但 keystone  保留对令牌有效负载本身进行向后不兼容更改的权利，这不是 API 合约。我们只建议根据 keystone 的身份验证 API  验证令牌，以检查其关联的元数据。我们强烈建议不要依赖解码的有效负载来获取有关令牌的信息。

More information about JWTs can be found in the [specification](https://tools.ietf.org/html/rfc7519).
有关 JWT 的更多信息，请参阅规范。

Summary 总结

| *Feature 特征*                                               | *Status 地位*    | **Fernet tokens Fernet 代币**                                | **JWS tokens JWS 代币**                                      |
| ------------------------------------------------------------ | ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [**Create unscoped token 创建无作用域令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_unscoped_token) | mandatory 命令的 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_unscoped_token_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_unscoped_token_driver_jws) |
| [**Create system-scoped token 创建系统范围的令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_system_token) | mandatory 命令的 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_system_token_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_system_token_driver_jws) |
| [**Create project-scoped token 创建项目范围的令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_project_scoped_token) | mandatory 命令的 | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_project_scoped_token_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_project_scoped_token_driver_jws) |
| [**Create domain-scoped token 创建域范围的令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_domain_scoped_token) | optional 自选    | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_domain_scoped_token_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_domain_scoped_token_driver_jws) |
| [**Create trust-scoped token 创建信任范围的令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_trust_scoped_token) | optional 自选    | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_trust_scoped_token_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_trust_scoped_token_driver_jws) |
| [**Create a token given an OAuth access token 创建给定 OAuth 访问令牌的令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_token_using_oauth) | optional 自选    | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_token_using_oauth_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_create_token_using_oauth_driver_jws) |
| [**Revoke a token 吊销令牌**](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_revoke_token) | optional 自选    | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_revoke_token_driver_fernet) | [`✔`](https://docs.openstack.org/keystone/yoga/admin/tokens-overview.html#operation_revoke_token_driver_jws) |

Details 详

- Create unscoped token 创建无作用域令牌

  **Status: mandatory.  状态：必填。**

  **CLI commands: CLI 命令：**

  - `openstack --os-username=<username> --os-user-domain-name=<domain> --os-password=<password> token issue`

  

  **Notes:** All token providers must be capable of issuing tokens without an explicit scope of authorization.
  注意：所有令牌提供者都必须能够在没有明确授权范围的情况下颁发令牌。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

- Create system-scoped token
  创建系统范围的令牌

  **Status: mandatory.  状态：必填。**

  **CLI commands: CLI 命令：**

  - `openstack --os-username=<username> --os-user-domain-name=<domain> --os-system-scope all token issue`

  

  **Notes:** All token providers must be capable of issuing system-scoped tokens.
  注意：所有令牌提供程序都必须能够颁发系统范围的令牌。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

- Create project-scoped token
  创建项目范围的令牌

  **Status: mandatory.  状态：必填。**

  **CLI commands: CLI 命令：**

  - `openstack --os-username=<username> --os-user-domain-name=<domain> --os-password=<password> --os-project-name=<project> --os-project-domain-name=<domain> token issue`

  

  **Notes:** All token providers must be capable of issuing project-scoped tokens.
  注意：所有令牌提供程序都必须能够颁发项目范围的令牌。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

- Create domain-scoped token
  创建域范围的令牌

  **Status: optional.  状态：可选。**

  **CLI commands: CLI 命令：**

  - `openstack --os-username=<username> --os-user-domain-name=<domain> --os-password=<password> --os-domain-name=<domain> token issue`

  

  **Notes:** Domain-scoped tokens are not required for all use cases, and for some use cases, projects can be used instead.
  注意：并非所有用例都需要域范围的令牌，对于某些用例，可以改用项目。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

- Create trust-scoped token
  创建信任范围的令牌

  **Status: optional.  状态：可选。**

  **CLI commands: CLI 命令：**

  - `openstack --os-username=<username> --os-user-domain-name=<domain> --os-password=<password> --os-trust-id=<trust> token issue`

  

  **Notes:** Tokens scoped to a trust convey only the user impersonation and project-based authorization attributes included in the delegation.
  注意：限定为信任的令牌仅传达委派中包含的用户模拟和基于项目的授权属性。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

- Create a token given an OAuth access token
  创建给定 OAuth 访问令牌的令牌

  **Status: optional.  状态：可选。**

  **Notes:** OAuth access tokens can be exchanged for keystone tokens.
  注意：OAuth 访问令牌可以交换为基石令牌。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

- Revoke a token 吊销令牌

  **Status: optional.  状态：可选。**

  **CLI commands: CLI 命令：**

  - `openstack token revoke`

  

  **Notes:** Tokens may be individually revoked, such as when a user logs out of Horizon. Under certain circumstances, it’s acceptable for more than just a single token may be revoked as a result of this operation (such as when the revoked token was previously used to create additional tokens).
  注意：令牌可能会单独被撤销，例如当用户注销 Horizon 时。在某些情况下，可以接受的不仅仅是一个令牌可能会因此操作而被吊销（例如，以前使用吊销的令牌创建其他令牌时）。

  **Driver Support: 驱动程序支持：**

  - **Fernet tokens:** `complete` Fernet代币： `complete` 
  - **JWS tokens:** `complete` JWS代币： `complete` 

  

Notes: 笔记：

- **This document is a continuous work in progress
  本文档正在持续进行中**

# Fernet - Frequently Asked Questions Fernet - 常见问题

​                                          

The following questions have been asked periodically since the initial release of the fernet token format in Kilo.
自 Kilo 中首次发布 fernet 代币格式以来，定期提出以下问题。

## What is a fernet token?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#what-is-a-fernet-token) 什么是fernet代币？¶

A fernet token is a bearer token that represents user authentication. Fernet tokens contain a limited amount of identity and authorization data in a [MessagePacked](https://msgpack.org/) payload. The payload is then wrapped as a [Fernet](https://github.com/fernet/spec) message for transport, where Fernet provides the required web safe characteristics for use in URLs and headers. The data inside a fernet token is protected using symmetric encryption keys, or fernet keys.
fernet token 是表示用户身份验证的持有者令牌。Fernet 令牌在 MessagePacked  有效负载中包含有限数量的标识和授权数据。然后，有效负载被包装为用于传输的 Fernet 消息，其中 Fernet 提供用于 URL 和标头所需的 Web 安全特征。fernet 令牌中的数据使用对称加密密钥或 fernet 密钥进行保护。

## What is a fernet key?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#what-is-a-fernet-key) 什么是fernet密钥？¶

A fernet key is used to encrypt and decrypt fernet tokens. Each key is actually composed of two smaller keys: a 128-bit AES encryption key and a 128-bit SHA256 HMAC signing key. The keys are held in a key repository that keystone passes to a library that handles the encryption and decryption of tokens.
fernet 密钥用于加密和解密 fernet 令牌。每个密钥实际上由两个较小的密钥组成：一个 128 位 AES 加密密钥和一个 128 位 SHA256 HMAC 签名密钥。密钥保存在密钥存储库中，keystone 将该存储库传递给处理令牌加密和解密的库。

## What are the different types of keys?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#what-are-the-different-types-of-keys) 密钥有哪些不同类型？¶

A key repository is required by keystone in order to create fernet tokens. These keys are used to encrypt and decrypt the information that makes up the payload of the token. Each key in the repository can have one of three states. The state of the key determines how keystone uses a key with fernet tokens. The different types are as follows:
keystone 需要一个密钥存储库才能创建 fernet 令牌。这些密钥用于加密和解密构成令牌有效负载的信息。存储库中的每个键可以具有以下三种状态之一。密钥的状态决定了 keystone 如何使用带有 fernet 令牌的密钥。不同的类型如下：

- Primary key: 主键：

  There is only ever one primary key in a key repository. The primary key is allowed to encrypt and decrypt tokens. This key is always named as the highest index in the repository. 密钥存储库中只有一个主键。允许主密钥加密和解密令牌。此键始终被命名为存储库中的最高索引。

- Secondary key: 二级键：

  A secondary key was at one point a primary key, but has been demoted in place of another primary key. It is only allowed to decrypt tokens. Since it was the primary at some point in time, its existence in the key repository is justified. Keystone needs to be able to decrypt tokens that were created with old primary keys. 辅助密钥曾经是主密钥，但已被降级以代替另一个主密钥。它只允许解密令牌。由于它在某个时间点是主要的，因此它在密钥存储库中的存在是合理的。Keystone 需要能够解密使用旧主键创建的令牌。

- Staged key: 暂存键：

  The staged key is a special key that shares some similarities with secondary keys. There can only ever be one staged key in a repository and it must exist. Just like secondary keys, staged keys have the ability to decrypt tokens. Unlike secondary keys, staged keys have never been a primary key. In fact, they are opposites since the staged key will always be the next primary key. This helps clarify the name because they are the next key staged to be the primary key. This key is always named as `0` in the key repository. 暂存密钥是一种特殊密钥，它与辅助密钥有一些相似之处。存储库中只能有一个暂存密钥，并且它必须存在。就像辅助密钥一样，暂存密钥具有解密令牌的能力。与辅助键不同，暂存键从来都不是主键。事实上，它们是对立的，因为暂存键将始终是下一个主键。这有助于澄清名称，因为它们是暂存为主键的下一个键。此密钥始终在 `0` 密钥存储库中命名。

## So, how does a staged key help me and why do I care about it?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#so-how-does-a-staged-key-help-me-and-why-do-i-care-about-it) 那么，暂存密钥如何帮助我，我为什么要关心它？¶

The fernet keys have a natural lifecycle. Each key starts as a staged key, is promoted to be the primary key, and then demoted to be a secondary key. New tokens can only be encrypted with a primary key. Secondary and staged keys are never used to encrypt token. The staged key is a special key given the order of events and the attributes of each type of key. The staged key is the only key in the repository that has not had a chance to encrypt any tokens yet, but it is still allowed to decrypt tokens. As an operator, this gives you the chance to perform a key rotation on one keystone node, and distribute the new key set over a span of time. This does not require the distribution to take place in an ultra short period of time. Tokens encrypted with a primary key can be decrypted, and validated, on other nodes where that key is still staged.
fernet  密钥具有自然生命周期。每个密钥都作为暂存密钥开始，提升为主密钥，然后降级为辅助密钥。新令牌只能使用主密钥进行加密。辅助密钥和暂存密钥从不用于加密令牌。暂存密钥是给定事件顺序和每种类型密钥属性的特殊密钥。暂存密钥是存储库中唯一尚未有机会加密任何令牌的密钥，但仍允许解密令牌。作为操作员，这使您有机会在一个密钥失调节点上执行密钥轮换，并在一段时间内分发新密钥集。这不需要在超短的时间内进行分发。使用主密钥加密的令牌可以在仍暂存该密钥的其他节点上进行解密和验证。

## Where do I put my key repository?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#where-do-i-put-my-key-repository) 我应该把我的密钥存储库放在哪里？¶

The key repository is specified using the `key_repository` option in the keystone configuration file. The keystone process should be able to read and write to this location but it should be kept secret otherwise. Currently, keystone only supports file-backed key repositories.
密钥存储库是使用 keystone 配置文件中的 `key_repository` 选项指定的。keystone 进程应该能够读取和写入此位置，但应保密。目前，keystone 仅支持文件支持的密钥存储库。

```
[fernet_tokens]
key_repository = /etc/keystone/fernet-keys/
```

## What is the recommended way to rotate and distribute keys?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#what-is-the-recommended-way-to-rotate-and-distribute-keys) 轮换和分发密钥的推荐方法是什么？¶

The **keystone-manage** command line utility includes a key rotation mechanism. This mechanism will initialize and rotate keys but does not make an effort to distribute keys across keystone nodes. The distribution of keys across a keystone deployment is best handled through configuration management tooling, however ensure that the new primary key is distributed first. Use **keystone-manage fernet_rotate** to rotate the key repository.
keystone-manage  命令行实用程序包括密钥轮换机制。此机制将初始化和轮换密钥，但不会努力在密钥失调节点之间分发密钥。最好通过配置管理工具处理密钥部署中的密钥分发，但请确保首先分发新的主密钥。使用 keystone-manage fernet_rotate轮换密钥存储库。

## Do fernet tokens still expire?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#do-fernet-tokens-still-expire) fernet代币还会过期吗？¶

Yes, fernet tokens can expire just like any other keystone token formats.
是的，fernet 代币可以像任何其他 keystone 代币格式一样过期。

## Why should I choose fernet tokens over UUID tokens?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#why-should-i-choose-fernet-tokens-over-uuid-tokens) 为什么我应该选择fernet代币而不是UUID代币？¶

Even though fernet tokens operate very similarly to UUID tokens, they do not require persistence or leverage the configured token persistence driver in any way. The keystone token database no longer suffers bloat as a side effect of authentication. Pruning expired tokens from the token database is no longer required when using fernet tokens. Because fernet tokens do not require persistence, they do not have to be replicated. As long as each keystone node shares the same key repository, fernet tokens can be created and validated instantly across nodes.
尽管 fernet 代币的操作与 UUID 代币非常相似，但它们不需要持久性或以任何方式利用配置的令牌持久性驱动程序。keystone  令牌数据库不再因身份验证的副作用而膨胀。使用 fernet 令牌时，不再需要从令牌数据库中修剪过期的令牌。因为 fernet  代币不需要持久性，所以不必复制它们。只要每个keystone节点共享相同的密钥存储库，就可以跨节点即时创建和验证fernet令牌。

## Why should I choose fernet tokens over PKI or PKIZ tokens?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#why-should-i-choose-fernet-tokens-over-pki-or-pkiz-tokens) 为什么我应该选择 fernet 代币而不是 PKI 或 PKIZ 代币？¶

The arguments for using fernet over PKI and PKIZ remain the same as UUID, in addition to the fact that fernet tokens are much smaller than PKI and PKIZ tokens. PKI and PKIZ tokens still require persistent storage and can sometimes cause issues due to their size. This issue is mitigated when switching to fernet because fernet tokens are kept under a 250 byte limit. PKI and PKIZ tokens typically exceed 1600 bytes in length. The length of a PKI or PKIZ token is dependent on the size of the deployment. Bigger service catalogs will result in longer token lengths. This pattern does not exist with fernet tokens because the contents of the encrypted payload is kept to a minimum.
在 PKI 和 PKIZ 上使用 fernet 的参数与 UUID 相同，此外 fernet 令牌比 PKI 和 PKIZ 令牌小得多。PKI 和 PKIZ 令牌仍需要持久性存储，有时可能会因其大小而导致问题。切换到 fernet 时，此问题会得到缓解，因为 fernet 令牌保持在  250 字节的限制之下。PKI 和 PKIZ 令牌的长度通常超过 1600 字节。PKI 或 PKIZ  令牌的长度取决于部署的大小。服务目录越大，令牌长度越长。fernet 令牌不存在此模式，因为加密有效负载的内容保持在最低限度。

## Should I rotate and distribute keys from the same keystone node every rotation?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#should-i-rotate-and-distribute-keys-from-the-same-keystone-node-every-rotation) 我是否应该在每次轮换时轮换和分发来自同一梯形节点的密钥？¶

No, but the relationship between rotation and distribution should be lock-step. Once you rotate keys on one keystone node, the key repository from that node should be distributed to the rest of the cluster. Once you confirm that each node has the same key repository state, you could rotate and distribute from any other node in the cluster.
不可以，但轮换和分布之间的关系应该是锁步的。在一个 keystone 节点上轮换密钥后，应将该节点的密钥存储库分发到集群的其余部分。确认每个节点具有相同的密钥存储库状态后，您可以从集群中的任何其他节点轮换和分发。

If the rotation and distribution are not lock-step, a single keystone node in the deployment will create tokens with a primary key that no other node has as a staged key. This will cause tokens generated from one keystone node to fail validation on other keystone nodes.
如果轮换和分发不是锁步，则部署中的单个 Keystone 节点将创建具有其他节点没有的主键作为暂存键的令牌。这将导致从一个 keystone 节点生成的令牌在其他 keystone 节点上的验证失败。

## How do I add new keystone nodes to a deployment?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#how-do-i-add-new-keystone-nodes-to-a-deployment) 如何将新的 keystone 节点添加到部署中？¶

The keys used to create fernet tokens should be treated like super secret configuration files, similar to an SSL secret key. Before a node is allowed to join an existing cluster, issuing and validating tokens, it should have the same key repository as the rest of the nodes in the cluster.
用于创建 fernet 令牌的密钥应被视为超级机密配置文件，类似于 SSL 密钥。在允许节点加入现有集群、颁发和验证令牌之前，它应具有与集群中其余节点相同的密钥存储库。

## How should I approach key distribution?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#how-should-i-approach-key-distribution) 我应该如何处理密钥分发？¶

Remember that key distribution is only required in multi-node keystone deployments. If you only have one keystone node serving requests in your deployment, key distribution is unnecessary.
请记住，只有在多节点梯形校梯部署中才需要密钥分发。如果部署中只有一个 keystone 节点为请求提供服务，则不需要分发密钥。

Key distribution is a problem best approached from the deployment’s current configuration management system. Since not all deployments use the same configuration management systems, it makes sense to explore options around what is already available for managing keys, while keeping the secrecy of the keys in mind. Many configuration management tools can leverage something like `rsync` to manage key distribution.
密钥分发是最好从部署的当前配置管理系统解决的问题。由于并非所有部署都使用相同的配置管理系统，因此有必要围绕已可用于管理密钥的选项进行探索，同时牢记密钥的保密性。许多配置管理工具都可以利用类似 `rsync` 的东西来管理密钥分发。

Key rotation is a single operation that promotes the current staged key to primary, creates a new staged key, and prunes old secondary keys. It is easiest to do this on a single node and verify the rotation took place properly before distributing the key repository to the rest of the cluster. The concept behind the staged key breaks the expectation that key rotation and key distribution have to be done in a single step. With the staged key, we have time to inspect the new key repository before syncing state with the rest of the cluster. Key distribution should be an operation that can run in succession until it succeeds. The following might help illustrate the isolation between key rotation and key distribution.
密钥轮换是将当前暂存密钥提升为主密钥、创建新的暂存密钥并修剪旧辅助密钥的单个操作。最简单的方法是在单个节点上执行此操作，并在将密钥存储库分发到集群的其余部分之前验证轮换是否正确进行。暂存密钥背后的概念打破了密钥轮换和密钥分发必须在单个步骤中完成的期望。使用暂存密钥，我们有时间在与群集的其余部分同步状态之前检查新的密钥存储库。密钥分发应是一个可以连续运行的操作，直到成功。以下内容可能有助于说明密钥轮换和密钥分发之间的隔离。

1. Ensure all keystone nodes in the deployment have the same key repository.
   确保部署中的所有 keystone 节点都具有相同的密钥存储库。
2. Pick a keystone node in the cluster to rotate from.
   在群集中选取要从中轮换的 keystone 节点。
3. Rotate keys. 旋转键。
   1. Was it successful? 成功了吗？
      1. If no, investigate issues with the particular keystone node you rotated keys on. Fernet keys are small and the operation for rotation is trivial. There should not be much room for error in key rotation. It is possible that the user does not have the ability to write new keys to the key repository. Log output from `keystone-manage fernet_rotate` should give more information into specific failures.
         如果没有，请调查轮换密钥的特定梯形图节点的问题。Fernet键很小，旋转操作也很简单。密钥轮换应该不会有太大的错误空间。用户可能无法将新密钥写入密钥存储库。日志 `keystone-manage fernet_rotate` 输出应提供有关特定故障的详细信息。
      2. If yes, you should see a new staged key. The old staged key should be the new primary. Depending on the `max_active_keys` limit you might have secondary keys that were pruned. At this point, the node that you rotated on will be creating fernet tokens with a primary key that all other nodes should have as the staged key. This is why we checked the state of all key repositories in Step one. All other nodes in the cluster should be able to decrypt tokens created with the new primary key. At this point, we are ready to distribute the new key set.
         如果是，您应该会看到一个新的暂存键。旧的暂存键应该是新的主键。根据限制， `max_active_keys` 您可能有被修剪的辅助键。此时，您轮换的节点将创建具有主键的 fernet 令牌，所有其他节点都应将该主键作为暂存键。这就是为什么我们在步骤 1 中检查所有密钥存储库的状态的原因。群集中的所有其他节点都应能够解密使用新主密钥创建的令牌。此时，我们已准备好分发新的密钥集。
4. Distribute the new key repository.
   分发新的密钥存储库。
   1. Was it successful? 成功了吗？
      1. If yes, you should be able to confirm that all nodes in the cluster have the same key repository that was introduced in Step 3.  All nodes in the cluster will be creating tokens with the primary key that was promoted in Step 3. No further action is required until the next schedule key rotation.
         如果是，您应该能够确认集群中的所有节点都具有步骤 3 中引入的相同密钥存储库。集群中的所有节点都将使用步骤 3 中提升的主键创建令牌。在下一次计划密钥轮换之前，无需进一步操作。
      2. If no, try distributing again. Remember that we already rotated the repository and performing another rotation at this point will result in tokens that cannot be validated across certain hosts. Specifically, the hosts that did not get the latest key set. You should be able to distribute keys until it is successful. If certain nodes have issues syncing, it could be permission or network issues and those should be resolved before subsequent rotations.
         如果没有，请尝试再次分发。请记住，我们已经轮换了存储库，此时执行另一次轮换将导致无法在某些主机上验证令牌。具体而言，是未获取最新密钥集的主机。您应该能够分发密钥，直到成功为止。如果某些节点在同步时出现问题，则可能是权限或网络问题，应在后续轮换之前解决这些问题。

## How long should I keep my keys around?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#how-long-should-i-keep-my-keys-around) 我应该把钥匙放在身边多久？¶

The fernet tokens that keystone creates are only secure as the keys creating them. With staged keys the penalty of key rotation is low, allowing you to err on the side of security and rotate weekly, daily, or even hourly.  Ultimately, this should be less time than it takes an attacker to break a `AES256` key and a `SHA256 HMAC`.
keystone 创建的 fernet 令牌仅作为创建它们的密钥是安全的。使用暂存密钥，密钥轮换的惩罚很低，允许您在安全方面犯错，每周、每天甚至每小时轮换一次。归根结底，这应该比攻击者破解 `AES256` 密钥和 `SHA256 HMAC` .

## Is a fernet token still a bearer token?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#is-a-fernet-token-still-a-bearer-token) fernet代币仍然是不记名代币吗？¶

Yes, and they follow exactly the same validation path as UUID tokens, with the exception of being written to, and read from, a back end. If someone compromises your fernet token, they have the power to do all the operations you are allowed to do.
是的，它们遵循与 UUID 令牌完全相同的验证路径，但写入后端和从后端读取除外。如果有人破坏了您的fernet令牌，他们有权执行您被允许执行的所有操作。

## What if I need to revoke all my tokens?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#what-if-i-need-to-revoke-all-my-tokens) 如果我需要撤销所有代币怎么办？¶

To invalidate every token issued from keystone and start fresh, remove the current key repository, create a new key set, and redistribute it to all nodes in the cluster. This will render every token issued from keystone as invalid regardless if the token has actually expired. When a client goes to re-authenticate, the new token will have been created with a new fernet key.
要使从 keystone 颁发的每个令牌失效并重新开始，请删除当前密钥存储库，创建新的密钥集，并将其重新分发到集群中的所有节点。这将使从  keystone 颁发的每个令牌都无效，无论令牌是否实际过期。当客户端重新进行身份验证时，将使用新的 fernet 密钥创建新令牌。

## What can an attacker do if they compromise a fernet key in my deployment?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#what-can-an-attacker-do-if-they-compromise-a-fernet-key-in-my-deployment) 如果攻击者在我的部署中泄露了 fernet 密钥，他们可以采取什么措施？¶

If any key used in the key repository is compromised, an attacker will be able to build their own tokens. If they know the ID of an administrator on a project, they could generate administrator tokens for the project. They will be able to generate their own tokens until the compromised key has been removed from the repository.
如果密钥存储库中使用的任何密钥遭到泄露，攻击者将能够构建自己的令牌。如果他们知道项目管理员的 ID，则可以为项目生成管理员令牌。他们将能够生成自己的令牌，直到从存储库中删除泄露的密钥。

## I rotated keys and now tokens are invalidating early, what did I do?[¶](https://docs.openstack.org/keystone/yoga/admin/fernet-token-faq.html#i-rotated-keys-and-now-tokens-are-invalidating-early-what-did-i-do) 我轮换了密钥，现在令牌提前失效，我做了什么？¶

Using fernet tokens requires some awareness around token expiration and the key lifecycle. You do not want to rotate so often that secondary keys are removed that might still be needed to decrypt unexpired tokens. If this happens, you will not be able to decrypt the token because the key the was used to encrypt it is now gone. Only remove keys that you know are not being used to encrypt or decrypt tokens.
使用 fernet 代币需要对代币过期和密钥生命周期有一定的了解。您不希望过于频繁地轮换，以致删除可能仍需要解密未过期令牌的辅助密钥。如果发生这种情况，您将无法解密令牌，因为用于加密令牌的密钥现已消失。仅删除您知道未用于加密或解密令牌的密钥。

For example, your token is valid for 24 hours and we want to rotate keys every six hours. We will need to make sure tokens that were created at 08:00 AM on Monday are still valid at 07:00 AM on Tuesday, assuming they were not prematurely revoked. To accomplish this, we will want to make sure we set `max_active_keys=6` in our keystone configuration file. This will allow us to hold all keys that might still be required to validate a previous token, but keeps the key repository limited to only the keys that are needed.
例如，您的令牌有效期为 24 小时，我们希望每 6 小时轮换一次密钥。我们需要确保在周一上午 08：00 创建的令牌在周二上午 07：00 仍然有效，前提是它们没有被过早撤销。为了实现这一点，我们需要确保我们在梯形图配置文件中设置 `max_active_keys=6` 。这将允许我们保留验证先前令牌可能仍需要的所有密钥，但将密钥存储库限制为仅所需的密钥。

The number of `max_active_keys` for a deployment can be determined by dividing the token lifetime, in hours, by the frequency of rotation in hours and adding two. Better illustrated as:
可以通过将令牌生存期（以小时为单位）除以轮换频率（以小时为单位）并加 2 来确定部署的数量 `max_active_keys` 。更好的说明如下：

```
token_expiration = 24
rotation_frequency = 6
max_active_keys = (token_expiration / rotation_frequency) + 2
```

The reason for adding two additional keys to the count is to include the staged key and a buffer key.
向计数添加两个附加键的原因是包括暂存键和缓冲区键。



 

Note 注意



If validating expired tokens is needed (for example when services are configured to use ServiceToken auth), the value of `allow_expired_window` option from the `[token]` config section should also be taken into account, so that the formula to calculate the max_active_keys is
如果需要验证过期的令牌（例如，当服务配置为使用 ServiceToken 身份验证时），还应考虑 `[token]` config 部分中的 `allow_expired_window` option 值，以便计算max_active_keys的公式为

max_active_keys = ((token_expiration + allow_expired_window) / rotation_frequency) + 2
max_active_keys = （（token_expiration + allow_expired_window） / rotation_frequency） + 2

This can be shown based on the previous example. We initially setup the key repository at 6:00 AM on Monday, and the initial state looks like:
这可以根据前面的示例进行演示。我们最初在星期一上午 6：00 设置密钥存储库，初始状态如下所示：

```
$ ls -la /etc/keystone/fernet-keys/
drwx------ 2 keystone keystone 4096 .
drwxr-xr-x 3 keystone keystone 4096 ..
-rw------- 1 keystone keystone   44 0    (staged key)
-rw------- 1 keystone keystone   44 1    (primary key)
```

All tokens created after 6:00 AM are encrypted with key `1`. At 12:00 PM we will rotate keys again, resulting in,
在上午 6：00 之后创建的所有令牌都使用密钥 `1` 进行加密。在中午 12：00，我们将再次轮换密钥，结果是，

```
$ ls -la /etc/keystone/fernet-keys/
drwx------ 2 keystone keystone 4096 .
drwxr-xr-x 3 keystone keystone 4096 ..
-rw------- 1 keystone keystone   44 0    (staged key)
-rw------- 1 keystone keystone   44 1    (secondary key)
-rw------- 1 keystone keystone   44 2    (primary key)
```

We are still able to validate tokens created between 6:00 - 11:59 AM because the `1` key still exists as a secondary key. All tokens issued after 12:00 PM will be encrypted with key `2`. At 6:00 PM we do our next rotation, resulting in:
我们仍然能够验证在上午 6：00 - 11：59 之间创建的令牌，因为 `1` 密钥仍作为辅助密钥存在。中午 12：00 之后发行的所有代币都将使用密钥 `2` 加密。下午 6：00，我们进行下一次轮换，结果是：

```
$ ls -la /etc/keystone/fernet-keys/
drwx------ 2 keystone keystone 4096 .
drwxr-xr-x 3 keystone keystone 4096 ..
-rw------- 1 keystone keystone   44 0    (staged key)
-rw------- 1 keystone keystone   44 1    (secondary key)
-rw------- 1 keystone keystone   44 2    (secondary key)
-rw------- 1 keystone keystone   44 3    (primary key)
```

It is still possible to validate tokens issued from 6:00 AM - 5:59 PM because keys `1` and `2` exist as secondary keys. Every token issued until 11:59 PM will be encrypted with key `3`, and at 12:00 AM we do our next rotation:
仍然可以验证从早上 6：00 到下午 5：59 颁发的令牌，因为密钥 `1` 和 `2` 作为辅助密钥存在。晚上 11：59 之前发行的每个代币都将使用密钥 `3` 加密，并在凌晨 12：00 进行下一次轮换：

```
$ ls -la /etc/keystone/fernet-keys/
drwx------ 2 keystone keystone 4096 .
drwxr-xr-x 3 keystone keystone 4096 ..
-rw------- 1 keystone keystone   44 0    (staged key)
-rw------- 1 keystone keystone   44 1    (secondary key)
-rw------- 1 keystone keystone   44 2    (secondary key)
-rw------- 1 keystone keystone   44 3    (secondary key)
-rw------- 1 keystone keystone   44 4    (primary key)
```

Just like before, we can still validate tokens issued from 6:00 AM the previous day until 5:59 AM today because keys `1` - `4` are present. At 6:00 AM, tokens issued from the previous day will start to expire and we do our next scheduled rotation:
就像以前一样，我们仍然可以验证从前一天早上 6：00 到今天凌晨 5：59 发行的令牌，因为密钥 `1` - `4` 存在。早上 6：00，前一天发行的代币将开始过期，我们将进行下一次预定轮换：

```
$ ls -la /etc/keystone/fernet-keys/
drwx------ 2 keystone keystone 4096 .
drwxr-xr-x 3 keystone keystone 4096 ..
-rw------- 1 keystone keystone   44 0    (staged key)
-rw------- 1 keystone keystone   44 1    (secondary key)
-rw------- 1 keystone keystone   44 2    (secondary key)
-rw------- 1 keystone keystone   44 3    (secondary key)
-rw------- 1 keystone keystone   44 4    (secondary key)
-rw------- 1 keystone keystone   44 5    (primary key)
```

Tokens will naturally expire after 6:00 AM, but we will not be able to remove key `1` until the next rotation because it encrypted all tokens from 6:00 AM to 12:00 PM the day before. Once we do our next rotation, which is at 12:00 PM, the `1` key will be pruned from the repository:
代币自然会在早上 6：00 之后过期，但在下一次轮换之前，我们将无法删除密钥 `1` ，因为它在前一天的上午 6：00 到下午 12：00 之间加密了所有代币。一旦我们进行下一次轮换，即中午 12：00， `1` 密钥将从存储库中删除：

```
$ ls -la /etc/keystone/fernet-keys/
drwx------ 2 keystone keystone 4096 .
drwxr-xr-x 3 keystone keystone 4096 ..
-rw------- 1 keystone keystone   44 0    (staged key)
-rw------- 1 keystone keystone   44 2    (secondary key)
-rw------- 1 keystone keystone   44 3    (secondary key)
-rw------- 1 keystone keystone   44 4    (secondary key)
-rw------- 1 keystone keystone   44 5    (secondary key)
-rw------- 1 keystone keystone   44 6    (primary key)
```

If keystone were to receive a token that was created between 6:00 AM and 12:00 PM the day before, encrypted with the `1` key, it would not be valid because it was already expired. This makes it possible for us to remove the `1` key from the repository without negative validation side-effects.
如果 keystone 收到在前一天上午 6：00 到下午 12：00 之间创建的令牌，并使用 `1` 密钥加密，则该令牌将无效，因为它已过期。这使我们能够从存储库中删除 `1` 密钥，而不会产生负面的验证副作用。

# JWS key rotation JWS 密钥轮换

​                                          

The JWS token provider issues tokens using asymmetric signing. This document attempts to describe how to manage key pairs in a deployment of keystone nodes that need to validate tokens issued by one another.
JWS 令牌提供程序使用非对称签名颁发令牌。本文档尝试描述如何在需要验证彼此颁发的令牌的 keystone 节点部署中管理密钥对。

The inherent benefit of using asymmetric keys is that each keystone server generates it’s own key pair. The private key is used to sign tokens. Anyone with access to the public key has the ability to verify the token signature. This is a critical step in validating tokens across a cluster of keystone nodes.
使用非对称密钥的固有好处是，每个 keystone 服务器都会生成自己的密钥对。私钥用于对令牌进行签名。任何有权访问公钥的人都可以验证令牌签名。这是跨 keystone 节点集群验证令牌的关键步骤。

It is necessary for operators to sync public keys across all keystone nodes in the deployment. Each keystone server will need a corresponding public key for every node. This only applies to public keys. Private keys should never leave the server they are generated from.
运营商有必要在部署中的所有Keystone节点之间同步公钥。每个 Keystone 服务器都需要每个节点的相应公钥。这仅适用于公钥。私钥永远不应离开生成它们的服务器。

## Initial setup[¶](https://docs.openstack.org/keystone/yoga/admin/jws-key-rotation.html#initial-setup) 初始设置 ¶

Before a deployment of keystone servers can issue JWT tokens, each server must set `keystone.conf [token] provider = jws`. Additionally, each API server must have its own asymmetric key pair either generated manually or using `keystone-manage create_jws_keypair`. If you’re generating the key pairs manually, they must be usable with the `ES256` JSON Web Algorithm ([JWA](https://tools.ietf.org/html/rfc7518)). It is worth noting that the `keystone-manage create_jws_keypair` command line utility will create an appropriate key pair, but it will not automatically deploy it to the key repository locations defined in `keystone.conf [jwt_tokens]`. It is up to operators to move these files accordingly and resolve possible file name conflicts.
在部署 keystone 服务器可以颁发 JWT 令牌之前，每个服务器必须将 `keystone.conf [token] provider = jws` .此外，每个 API 服务器都必须有自己的非对称密钥对，可以手动生成，也可以使用 `keystone-manage create_jws_keypair` .如果手动生成密钥对，则它们必须可用于 `ES256` JSON Web 算法 （JWA）。值得注意的是， `keystone-manage create_jws_keypair` 命令行实用程序将创建适当的密钥对，但不会自动将其部署到 中 `keystone.conf [jwt_tokens]` 定义的密钥存储库位置。操作员需要相应地移动这些文件并解决可能的文件名冲突。

After generating a key pair, the public key from each API server must be shared with every other API server in the deployment. Ensure the private key used to sign JWS tokens is readable by the process running keystone and available in the `keystone.conf [jwt_tokens] jws_private_key_repository` location. Keystone will automatically use a key named `private.pem` to sign tokens and ignore all other keys in the repository. To validate tokens, keystone will iterate all available public keys in `keystone.conf [jwt_tokens] jws_public_key_repository`.  At a minimum, this repository needs to have the corresponding public key to the `private.pem` key found in `keystone.conf [jwt_tokens] jws_private_key_repository`.
生成密钥对后，必须与部署中的所有其他 API 服务器共享来自每个 API 服务器的公钥。确保用于对 JWS 令牌进行签名的私钥可由运行 keystone 的进程读取，并在该 `keystone.conf [jwt_tokens] jws_private_key_repository` 位置可用。Keystone 将自动使用名为 `private.pem` 对令牌进行签名的密钥，并忽略存储库中的所有其他密钥。为了验证令牌，keystone 将迭代 `keystone.conf [jwt_tokens] jws_public_key_repository` 中所有可用的公钥。至少，此存储库需要具有与 中找到 `keystone.conf [jwt_tokens] jws_private_key_repository` 的 `private.pem` 密钥相对应的公钥。

## Continued operations[¶](https://docs.openstack.org/keystone/yoga/admin/jws-key-rotation.html#continued-operations) 持续运营 ¶

Depending on the security requirements for your deployment, you might need to rotate out an existing key pair. To do so without prematurely invalidating tokens, follow these steps:
根据部署的安全要求，您可能需要轮换现有密钥对。若要在不使令牌过早失效的情况下执行此操作，请按照下列步骤操作：

1. Generate a new asymmetric key pair for a given keystone API server (see `keystone-manage create_jws_keypair` for more details)
   为给定的 keystone API 服务器生成新的非对称密钥对（有关详细信息，请参阅 `keystone-manage create_jws_keypair` ）
2. Copy or sync the newly generated public key to the public key repositories of all other keystone API servers, the public key should be placed in `keystone.conf [jwt_tokens] jws_public_key_repository`
   将新生成的公钥复制或同步到所有其他 keystone API 服务器的公钥存储库中，公钥应放在 `keystone.conf [jwt_tokens] jws_public_key_repository` 
3. Copy the new private key to the private key repository on the API server you’re performing the rotation on and make sure it’s named `private.pem`, at this point the server will start signing tokens with the new private key and all other keystone API servers will be able to validate those tokens since they already have a copy of the public key from step #2
   将新的私钥复制到要执行轮换的 API 服务器上的私钥存储库，并确保它被命名 `private.pem` ，此时服务器将开始使用新的私钥对令牌进行签名，所有其他 keystone API 服务器将能够验证这些令牌，因为它们已经拥有步骤 #2 中的公钥副本
4. At this point, you must wait until the last tokens signed with the old private key have expired before you can remove the old corresponding public keys from each keystone API server, note this should be a minimum of `keystone.conf [token] expiration`
   此时，您必须等到使用旧私钥签名的最后一个令牌过期后，才能从每个 keystone API 服务器中删除旧的对应公钥，请注意，这应该至少为 `keystone.conf [token] expiration` 
5. Once you’re confident all tokens signed with the old private key are expired, it is safe to remove the old corresponding public key from each API server in the deployment, which is important in case the original private key was compromised and prevents attackers from using it craft their own tokens
   一旦确定使用旧私钥签名的所有令牌都已过期，就可以安全地从部署中的每个 API 服务器中删除旧的相应公钥，这对于原始私钥被泄露并防止攻击者使用它来制作自己的令牌非常重要

# Token provider 令牌提供程序

​                                          

OpenStack Identity supports customizable token providers. This is specified in the `[token]` section of the configuration file. The token provider controls the token construction, validation, and revocation operations.
OpenStack Identity 支持可自定义的令牌提供程序。这在配置文件 `[token]` 的部分中指定。令牌提供程序控制令牌构造、验证和吊销操作。

You can register your own token provider by configuring the following property:
您可以通过配置以下属性来注册自己的令牌提供程序：



 

Note 注意



More commonly, you can use this option to change the token provider to one of the ones built in. Alternatively, you can use it to configure your own token provider.
更常见的是，您可以使用此选项将令牌提供程序更改为内置的令牌提供程序之一。或者，您可以使用它来配置自己的令牌提供程序。

- `provider` - token provider driver. Defaults to `fernet`. Implemented by `keystone.token.providers.fernet.Provider`. This is the entry point for the token provider in the `keystone.token.provider` namespace.
   `provider` - 令牌提供程序驱动程序。默认为 `fernet` 。实现者 `keystone.token.providers.fernet.Provider` .这是 `keystone.token.provider` 命名空间中令牌提供程序的入口点。

Below is the detailed list of the token formats supported by keystone.:
以下是keystone支持的令牌格式的详细列表。

- Fernet 费内特

  `fernet` tokens do not need to be persisted at all, but require that you run `keystone-manage fernet_setup` (also see the `keystone-manage fernet_rotate` command).  `fernet` 令牌根本不需要持久化，但需要您运行 `keystone-manage fernet_setup` （另请参阅 `keystone-manage fernet_rotate` 命令）。



 

Warning 警告



Fernet tokens are bearer tokens. They must be protected from unnecessary disclosure to prevent unauthorized access.
Fernet代币是不记名代币。必须保护它们免受不必要的披露，以防止未经授权的访问。

- JWS

  `jws` tokens do not need to be persisted at all, but require that you configure an asymmetric key pair to sign and validate tokens. The key pair can be generated using `keystone-manage create_jws_keypair` or it can be generated out-of-band manually so long as it is compatible with the JWT `ES256` Elliptic Curve Digital Signature Algorithm (ECDSA) using a P-256 curve and a SHA-256 hash algorithm.  `jws` 令牌根本不需要保留，但需要配置非对称密钥对来对令牌进行签名和验证。密钥对 `keystone-manage create_jws_keypair` 可以使用或手动生成，只要它与使用 P-256 曲线和 SHA-256 哈希算法的 JWT `ES256` 椭圆曲线数字签名算法 （ECDSA） 兼容即可。



 

Warning 警告



JWS tokens are bearer tokens. They must be protected from unnecessary disclosure to prevent unauthorized access.
JWS代币是持有者代币。必须保护它们免受不必要的披露，以防止未经授权的访问。

# Default Roles 默认角色

​                                          

## Primer[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#primer) 入门 ¶

Like most OpenStack services, keystone protects its API using role-based access control (RBAC).
与大多数 OpenStack 服务一样，keystone 使用基于角色的访问控制 （RBAC） 来保护其 API。

Users can access different APIs depending on the roles they have on a project, domain, or system, which we refer to as scope.
用户可以根据他们在项目、域或系统上的角色（我们称之为范围）访问不同的 API。

As of the Rocky release, keystone provides three roles called `admin`, `member`, and `reader` by default. Operators can grant these roles to any actor (e.g., group or user) on any scope (e.g., system, domain, or project). If you need a refresher on authorization scopes and token types, please refer to the [token guide](https://docs.openstack.org/keystone/latest/admin/tokens-overview.html#authorization-scopes). The following sections describe how each default role behaves with keystone’s API across different scopes. Additionally, other service developers can use this document as a guide for implementing similar patterns in their services.
从 Rocky 版本开始，keystone 默认提供三个角色，分别称为 `admin` 、 `member` 和 `reader`  。操作员可以将这些角色授予任何范围（例如，系统、域或项目）上的任何参与者（例如，组或用户）。如果需要复习授权范围和令牌类型，请参阅令牌指南。以下部分介绍了每个默认角色在不同范围内如何使用 keystone 的 API。此外，其他服务开发人员可以使用本文档作为在其服务中实现类似模式的指南。

Default roles and behaviors across scopes allow operators to delegate more functionality to their team, auditors, customers, and users without maintaining custom policies.
跨范围的默认角色和行为允许操作员将更多功能委派给他们的团队、审核员、客户和用户，而无需维护自定义策略。

## Roles Definitions[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#roles-definitions) 角色定义 ¶

The default roles provided by keystone, via `keystone-manage boostrap`, are related through role implications. The `admin` role implies the `member` role, and the `member` role implies the `reader` role. These implications mean users with the `admin` role automatically have the `member` and `reader` roles. Additionally, users with the `member` role automatically have the `reader` role. Implying roles reduces role assignments and forms a natural hierarchy between the default roles. It also reduces the complexity of default policies by making check strings short. For example, a policy that requires `reader` can be expressed as:
keystone `keystone-manage boostrap` 通过 提供的默认角色通过角色含义进行关联。 `admin` 角色意味着 `member` 角色， `member` 角色意味着 `reader` 角色。这些含义意味着具有该 `admin` 角色的用户自动具有 `member` and `reader` 角色。此外，具有该 `member` 角色的用户将自动拥有该 `reader` 角色。隐含角色可以减少角色分配，并在默认角色之间形成自然层次结构。它还通过缩短检查字符串来降低默认策略的复杂性。例如，需要 `reader` 的策略可以表示为：

```
"identity:list_foo": "role:reader"
```

Instead of: 而不是：

```
"identity:list_foo": "role:admin or role:member or role:reader"
```

### Reader[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#reader) 阅读器 ¶



 

Warning 警告



While it’s possible to use the `reader` role to perform audits, we highly recommend assessing the viability of using `reader` for auditing from the perspective of the compliance target you’re pursuing.
虽然可以使用该 `reader` 角色来执行审计，但我们强烈建议从你所追求的合规性目标的角度评估用于 `reader` 审计的可行性。

The `reader` role is the least-privileged role within the role hierarchy described here. As such, OpenStack development teams, by default, do not advocate exposing sensitive information to users with the `reader` role, regardless of the scope. We have noted the need for a formal, read-only, role that is useful for inspecting all applicable resources within a particular scope, but it shouldn’t be implemented as the lowest level of authorization. This work will come in a subsequent release where we support an elevated read-only role, that implies `reader`, but also exposes sensitive information, where applicable.
该 `reader` 角色是此处所述的角色层次结构中权限最低的角色。因此，默认情况下，OpenStack 开发团队不主张将敏感信息暴露给具有该 `reader` 角色的用户，无论范围如何。我们注意到需要一个正式的只读角色，该角色可用于检查特定范围内的所有适用资源，但不应将其作为最低授权级别实现。这项工作将在后续版本中提供，其中我们支持提升的只读角色，这意味着 `reader` ，但也公开敏感信息（如果适用）。

This will allow operators to grant third-party auditors a permissive role for viewing sensitive information, specifically for compliance targets that require it.
这将允许运营商授予第三方审计师查看敏感信息的许可角色，特别是对于需要它的合规目标。

The `reader` role provides read-only access to resources within the system, a domain, or a project. Depending on the assignment scope, two users with the `reader` role can expect different API behaviors. For example, a user with the `reader` role on the system can list all projects within the deployment. A user with the `reader` role on a domain can only list projects within their domain.
该 `reader` 角色提供对系统、域或项目中资源的只读访问权限。根据分配范围，具有该 `reader` 角色的两个用户可能会有不同的 API 行为。例如，在系统上具有该 `reader` 角色的用户可以列出部署中的所有项目。在域中具有该 `reader` 角色的用户只能列出其域中的项目。

By analyzing the scope of a role assignment, we increase the re-usability of the `reader` role and provide greater functionality without introducing more roles. For example, to accomplish this without analyzing assignment scope, you would need `system-reader`, `domain-reader`, and `project-reader` roles in addition to custom policies for each service.
通过分析角色分配的范围，我们提高了 `reader` 角色的可重用性，并在不引入更多角色的情况下提供了更强大的功能。例如，若要在不分析分配范围的情况下实现此目的，除了每个服务的自定义策略外，还需要 `system-reader` 、 `domain-reader` 和 `project-reader` 角色。

It’s imperative to note that `reader` is the least authoritative role in the hierarchy because assignments using `admin` or `member` ultimately include the `reader` role. We document this explicitly so that `reader` roles are not overloaded with read-only access to sensitive information. For example, a deployment pursuing a specific compliance target may want to leverage the `reader` role to perform the audit. If the audit requires the auditor to evaluate sensitive information, like license keys or administrative metadata, within a given scope, auditors shouldn’t expect to perform these operations with the `reader` role. We justify this design decision because sensitive information should be explicitly protected, and not implicitly exposed.
必须注意的是，这是 `reader` 层次结构中权威性最低的角色，因为使用 `admin` 或 `member` 最终包含该 `reader` 角色的分配。我们明确记录了这一点， `reader` 以便角色不会因对敏感信息的只读访问权限而过载。例如，追求特定合规性目标的部署可能希望利用该 `reader` 角色来执行审核。如果审核要求审核员在给定范围内评估敏感信息（如许可证密钥或管理元数据），则审核员不应期望使用该 `reader` 角色执行这些操作。我们证明这一设计决策的合理性，因为敏感信息应该受到显式保护，而不是隐式公开。

The `reader` role should be implemented and used from the perspective of least-privilege, which may or may not fulfill your auditing use case.
应从最小权限的角度实现和使用该 `reader` 角色，这可能会也可能不会满足您的审核用例。

### Member[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#member) 成员 ¶

Within keystone, there isn’t a distinct advantage to having the `member` role instead of the `reader` role. The `member` role is more applicable to other services.  The `member` role works nicely for introducing granularity between `admin` and `reader` roles. Other services might write default policies that require the `member` role to create resources, but the `admin` role to delete them. For example, users with `reader` on a project could list instance, users with `member` on a project can list and create instances, and users with `admin` on a project can list, create, and delete instances. Service developers can use the `member` role to provide more flexibility between `admin` and `reader` on different scopes.
在 Keystone 中，拥有 `member` 角色而不是 `reader` 角色并没有明显的优势。该 `member` 角色更适用于其他服务。该 `member` 角色非常适合在 `reader` 角色之间 `admin` 引入粒度。其他服务可能会编写默认策略，这些策略需要 `member` 角色创建资源，但 `admin` 角色需要删除资源。例如，具有 `reader` on 项目的用户可以列出实例，具有 `member` on 项目的用户可以列出和创建实例，具有 `admin` on 项目的用户可以列出、创建和删除实例。服务开发人员可以使用该 `member` 角色在不同范围之间 `admin` 和 `reader` 不同范围上提供更大的灵活性。

### Admin[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#admin) 管理员 ¶

We reserve the `admin` role for the most privileged operations within a given scope. It is important to note that having `admin` on a project, domain, or the system carries separate authorization and are not transitive. For example, users with `admin` on the system should be able to manage every aspect of the deployment because they’re operators. Users with `admin` on a project shouldn’t be able to manage things outside the project because it would violate the tenancy of their role assignment (this doesn’t apply consistently since services are addressing this individually at their own pace).
我们为给定范围内最特权的操作保留 `admin` 角色。需要注意的是，在项目、域或系统上拥有 `admin` 单独的授权，并且不是可传递的。例如，系统 `admin` 上的用户应该能够管理部署的各个方面，因为他们是操作员。参与 `admin` 项目的用户不应能够管理项目外部的内容，因为这会违反其角色分配的租户（这并不一致，因为服务会按照自己的节奏单独解决此问题）。



 

Note 注意



As of the Train release, keystone applies the following personas consistently across its API.
从 Train 版本开始，keystone 在其 API 中一致地应用以下角色。

## System Personas[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#system-personas) 系统角色 ¶

This section describes authorization personas typically used for operators and deployers. You can find all users with system role assignments using the following query:
本部分介绍通常用于操作员和部署人员的授权角色。可以使用以下查询查找具有系统角色分配的所有用户：

```
$ openstack role assignment list --names --system all
+--------+------------------------+------------------------+---------+--------+--------+-----------+
| Role   | User                   | Group                  | Project | Domain | System | Inherited |
+--------+------------------------+------------------------+---------+--------+--------+-----------+
| admin  |                        | system-admins@Default  |         |        | all    | False     |
| admin  | admin@Default          |                        |         |        | all    | False     |
| admin  | operator@Default       |                        |         |        | all    | False     |
| reader |                        | system-support@Default |         |        | all    | False     |
| admin  | operator@Default       |                        |         |        | all    | False     |
| member | system-support@Default |                        |         |        | all    | False     |
+--------+------------------------+------------------------+---------+--------+--------+-----------+
```

### System Administrators[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#system-administrators) 系统管理员 ¶

*System administrators* are allowed to manage every resource in keystone. System administrators are typically operators and cloud administrators. They can control resources that ultimately affect the behavior of the deployment. For example, they can add or remove services and endpoints in the catalog, create new domains, add federated mappings, and clean up stale resources, like a user’s application credentials or trusts.
允许系统管理员管理 keystone 中的每个资源。系统管理员通常是操作员和云管理员。他们可以控制最终影响部署行为的资源。例如，他们可以在目录中添加或删除服务和终结点、创建新域、添加联合映射以及清理过时的资源，例如用户的应用程序凭据或信任。

You can find *system administrators* in your deployment with the following assignments:
您可以在部署中找到具有以下分配的系统管理员：

```
$ openstack role assignment list --names --system all --role admin
+-------+------------------+-----------------------+---------+--------+--------+-----------+
| Role  | User             | Group                 | Project | Domain | System | Inherited |
+-------+------------------+-----------------------+---------+--------+--------+-----------+
| admin |                  | system-admins@Default |         |        | all    | False     |
| admin | admin@Default    |                       |         |        | all    | False     |
| admin | operator@Default |                       |         |        | all    | False     |
+-------+------------------+-----------------------+---------+--------+--------+-----------+
```

### System Members & System Readers[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#system-members-system-readers) 系统成员和系统读取器 ¶

In keystone, *system members* and *system readers* are very similar and have the same authorization. Users with these roles on the system can view all resources within keystone. They can list role assignments, users, projects, and group memberships, among other resources.
在 keystone 中，系统成员和系统读取器非常相似，并且具有相同的授权。在系统上具有这些角色的用户可以查看 keystone 中的所有资源。他们可以列出角色分配、用户、项目和组成员身份以及其他资源。

The *system reader* persona is useful for members of a support team or auditors if the audit doesn’t require access to sensitive information. You can find *system members* and *system readers* in your deployment with the following assignments:
如果审核不需要访问敏感信息，则系统读取器角色对于支持团队成员或审核员很有用。可以通过以下分配在部署中找到系统成员和系统读取者：

```
$ openstack role assignment list --names --system all --role member --role reader
+--------+------------------------+------------------------+---------+--------+--------+-----------+
| Role   | User                   | Group                  | Project | Domain | System | Inherited |
+--------+------------------------+------------------------+---------+--------+--------+-----------+
| reader |                        | system-support@Default |         |        | all    | False     |
| admin  | operator@Default       |                        |         |        | all    | False     |
| member | system-support@Default |                        |         |        | all    | False     |
+--------+------------------------+------------------------+---------+--------+--------+-----------+
```



 

Warning 警告



Filtering system role assignments is currently broken and is being tracked as a [bug](https://bugs.launchpad.net/keystone/+bug/1846817).
筛选系统角色分配当前已损坏，并作为 bug 进行跟踪。

## Domain Personas[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#domain-personas) 域角色 ¶

This section describes authorization personas for people who manage their own domains, which contain projects, users, and groups. You can find all users with role assignments on a specific domain using the following query:
本部分介绍管理自己的域（包含项目、用户和组）的人员的授权角色。可以使用以下查询查找在特定域上具有角色分配的所有用户：

```
$ openstack role assignment list --names --domain foobar
+--------+-----------------+----------------------+---------+--------+--------+-----------+
| Role   | User            | Group                | Project | Domain | System | Inherited |
+--------+-----------------+----------------------+---------+--------+--------+-----------+
| reader | support@Default |                      |         | foobar |        | False     |
| admin  | jsmith@Default  |                      |         | foobar |        | False     |
| admin  |                 | foobar-admins@foobar |         | foobar |        | False     |
| member | jdoe@foobar     |                      |         | foobar |        | False     |
+--------+-----------------+----------------------+---------+--------+--------+-----------+
```

### Domain Administrators[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#domain-administrators) 域管理员 ¶

*Domain administrators* can manage most aspects of the domain or its contents. These users can create new projects and users within their domain. They can inspect the role assignments users have on projects within their domain.
域管理员可以管理域或其内容的大多数方面。这些用户可以在其域中创建新项目和用户。他们可以检查用户对其域内的项目所具有的角色分配。

*Domain administrators* aren’t allowed to access system-specific resources or resources outside their domain. Users that need control over project, group, and user creation are a great fit for *domain administrators*.
不允许域管理员访问特定于系统的资源或其域外的资源。需要控制项目、组和用户创建的用户非常适合域管理员。

You can find *domain administrators* in your deployment with the following role assignment:
可以使用以下角色分配在部署中找到域管理员：You can find domain administrators in your deployment with the following role assignment：

```
$ openstack role assignment list --names --domain foobar --role admin
+-------+----------------+----------------------+---------+--------+--------+-----------+
| Role  | User           | Group                | Project | Domain | System | Inherited |
+-------+----------------+----------------------+---------+--------+--------+-----------+
| admin | jsmith@Default |                      |         | foobar |        | False     |
| admin |                | foobar-admins@foobar |         | foobar |        | False     |
+-------+----------------+----------------------+---------+--------+--------+-----------+
```

### Domain Members & Domain Readers[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#domain-members-domain-readers) 域成员和域读取者 ¶

Domain members and domain readers have the same relationship as system members and system readers. They’re allowed to view resources and information about their domain. They aren’t allowed to access system-specific information or information about projects, groups, and users outside their domain.
域成员和域读取者与系统成员和系统读取者具有相同的关系。他们被允许查看有关其域的资源和信息。他们不得访问特定于系统的信息或有关其域外的项目、组和用户的信息。

The domain member and domain reader use-cases are great for support teams, monitoring the details of an account, or auditing resources within a domain assuming the audit doesn’t validate sensitive information. You can find domain members and domain readers with the following role assignments:
域成员和域读取器用例非常适合支持团队、监视帐户的详细信息或审核域中的资源（假设审核未验证敏感信息）。可以使用以下角色分配查找域成员和域读取者：

```
$ openstack role assignment list --names --role member --domain foobar
+--------+-------------+-------+---------+--------+--------+-----------+
| Role   | User        | Group | Project | Domain | System | Inherited |
+--------+-------------+-------+---------+--------+--------+-----------+
| member | jdoe@foobar |       |         | foobar |        | False     |
+--------+-------------+-------+---------+--------+--------+-----------+
$ openstack role assignment list --names --role reader --domain foobar
+--------+-----------------+-------+---------+--------+--------+-----------+
| Role   | User            | Group | Project | Domain | System | Inherited |
+--------+-----------------+-------+---------+--------+--------+-----------+
| reader | support@Default |       |         | foobar |        | False     |
+--------+-----------------+-------+---------+--------+--------+-----------+
```

## Project Personas[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#project-personas) 项目角色 ¶

This section describes authorization personas for users operating within a project. These personas are commonly used by end users. You can find all users with role assignments on a specific project using the following query:
本节介绍在项目中操作的用户的授权角色。这些角色通常由最终用户使用。可以使用以下查询查找在特定项目上具有角色分配的所有用户：

```
$ openstack role assignment list --names --project production
+--------+----------------+----------------------------+-------------------+--------+--------+-----------+
| Role   | User           | Group                      | Project           | Domain | System | Inherited |
+--------+----------------+----------------------------+-------------------+--------+--------+-----------+
| admin  | jsmith@Default |                            | production@foobar |        |        | False     |
| admin  |                | production-admins@foobar   | production@foobar |        |        | False     |
| member |                | foobar-operators@Default   | production@foobar |        |        | False     |
| reader | alice@Default  |                            | production@foobar |        |        | False     |
| reader |                | production-support@Default | production@foobar |        |        | False     |
+--------+----------------+----------------------------+-------------------+--------+--------+-----------+
```

### Project Administrators[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#project-administrators) 项目管理员 ¶

*Project administrators* can only view and modify data within the project they have authorization on. They’re able to view information about their projects and set tags on their projects. They’re not allowed to view system or domain resources, as that would violate the tenancy of their role assignment. Since the majority of the resources in keystone’s API are system and domain-specific, *project administrators* don’t have much authorization.
项目管理员只能查看和修改他们有权访问的项目中的数据。他们能够查看有关其项目的信息，并在其项目上设置标签。不允许他们查看系统或域资源，因为这会违反其角色分配的租户。由于 keystone API 中的大多数资源都是特定于系统和域的，因此项目管理员没有太多权限。

You can find *project administrators* in your deployment with the following role assignment:
可以在部署中找到具有以下角色分配的项目管理员：

```
$ openstack role assignment list --names --project production --role admin
+-------+----------------+--------------------------+-------------------+--------+--------+-----------+
| Role  | User           | Group                    | Project           | Domain | System | Inherited |
+-------+----------------+--------------------------+-------------------+--------+--------+-----------+
| admin | jsmith@Default |                          | production@foobar |        |        | False     |
| admin |                | production-admins@foobar | production@foobar |        |        | False     |
+-------+----------------+--------------------------+-------------------+--------+--------+-----------+
```

### Project Members & Project Readers[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#project-members-project-readers) 项目成员和项目读者 ¶

*Project members* and *project readers* can discover information about their projects. They can access important information like resource limits for their project, but they’re not allowed to view information outside their project or view system-specific information.
项目成员和项目读者可以发现有关其项目的信息。他们可以访问重要信息，例如项目的资源限制，但不允许他们查看项目外部的信息或查看特定于系统的信息。

You can find *project members* and *project readers* in your deployment with the following role assignments:
可以使用以下角色分配在部署中找到项目成员和项目读取者：

```
$ openstack role assignment list --names --project production --role member
+--------+------+--------------------------+-------------------+--------+--------+-----------+
| Role   | User | Group                    | Project           | Domain | System | Inherited |
+--------+------+--------------------------+-------------------+--------+--------+-----------+
| member |      | foobar-operators@Default | production@foobar |        |        | False     |
+--------+------+--------------------------+-------------------+--------+--------+-----------+
$ openstack role assignment list --names --project production --role reader
+--------+---------------+----------------------------+-------------------+--------+--------+-----------+
| Role   | User          | Group                      | Project           | Domain | System | Inherited |
+--------+---------------+----------------------------+-------------------+--------+--------+-----------+
| reader | alice@Default |                            | production@foobar |        |        | False     |
| reader |               | production-support@Default | production@foobar |        |        | False     |
+--------+---------------+----------------------------+-------------------+--------+--------+-----------+
```

## Writing Policies[¶](https://docs.openstack.org/keystone/yoga/admin/service-api-protection.html#writing-policies) 编写策略 ¶

If the granularity provided above doesn’t meet your specific use-case, you can still override policies and maintain them manually. You can read more about how to do that in oslo.policy usage [documentation](https://docs.openstack.org/oslo.policy/latest/admin/index.html).
如果上面提供的粒度不符合您的特定用例，您仍然可以覆盖策略并手动维护它们。您可以在 oslo.policy 使用文档中阅读有关如何执行此操作的更多信息。

# Unified Limits 统一限制

​                                          



 

Warning 警告



The unified limits API is currently labeled as experimental and can change in backwards incompatible ways. After we get feedback on the intricacies of the API and no longer expect to make API breaking changes, the API will be marked as stable.
统一限制 API 目前被标记为实验性，并且可以以不兼容的方式向后更改。在我们收到有关 API 复杂性的反馈并且不再期望进行 API 中断性更改后，API 将被标记为稳定。

As of the Queens release, keystone has the ability to store and relay information known as a limit. Limits can be used by services to enforce quota on resources across OpenStack. This section describes the basic concepts of limits, how the information can be consumed by services, and how operators can manage resource quota across OpenStack using limits.
从Queens版本开始，keystone能够存储和中继称为限制的信息。服务可以使用限制来对 OpenStack 中的资源强制执行配额。本节介绍限制的基本概念，服务如何使用信息，以及运营商如何使用限制来管理OpenStack中的资源配额。

## What is a limit?[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#what-is-a-limit) 什么是限制？¶

A limit is a threshold for resource management and helps control resource utilization. A process for managing limits allows for reallocation of resources to different users or projects as needs change. Some information needed to establish a limit may include:
限制是资源管理的阈值，有助于控制资源利用率。管理限制的过程允许随着需求的变化将资源重新分配给不同的用户或项目。确定限制所需的一些信息可能包括：

- project_id
- domain_id
- API service type (e.g. compute, network, object-storage)
  API 服务类型（例如计算、网络、对象存储）
- a resource type (e.g. ram_mb, vcpus, security-groups)
  资源类型（例如ram_mb、vcpu 、security-groups）
- a default limit 默认限制
- a project specific limit i.e resource limit
  项目特定限制，即资源限制
- user_id (optional) user_id（可选）
- a region (optional depending on the service)
  区域（可选，具体取决于服务）



 

Note 注意



The default limit of registered limit and the resource limit of project limit now are limited from -1 to 2147483647 (integer). -1 means no limit and 2147483647 is the max value for user to define limits. The length of unified limit’s resource type now is limited from 1 to 255 (string).
注册限制的默认限制和项目限制的资源限制现在限制在 -1 到 2147483647（整数）之间。-1 表示无限制，2147483647 是用户定义限制的最大值。统一限制的资源类型的长度现在限制为 1 到 255（字符串）。

Since keystone is the source of truth for nearly everything in the above list, limits are a natural fit as a keystone resource. Two different limit resources exist in this design. The first is a registered limit and the second is a project limit.
由于 keystone 是上述列表中几乎所有内容的真实来源，因此限制作为 keystone 资源是很自然的。此设计中存在两种不同的极限资源。第一个是注册限制，第二个是项目限制。

### Registered limits[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#registered-limits) 注册限制 ¶

A registered limit accomplishes two important things in order to enforce quota across multi-tenant, distributed systems. First, it establishes resource types and associates them to services. Second, it sets a default resource limit for all projects. The first part maps specific resource types to the services that provide them. For example, a registered limit can map vcpus, to the compute service. The second part sets a default of 20 vcpus per project. This provides all the information needed for basic quota enforcement for any resource provided by a service.
注册限制可以完成两项重要任务，以便在多租户分布式系统中强制实施配额。首先，它建立资源类型并将它们与服务相关联。其次，它为所有项目设置了默认资源限制。第一部分将特定资源类型映射到提供它们的服务。例如，已注册的限制可以将 vcpu 映射到计算服务。第二部分将每个项目的默认值设置为 20 个 vcp。这提供了对服务提供的任何资源实施基本配额所需的所有信息。

### Domain limits[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#domain-limits) 域名限制 ¶

A domain limit is a limit associated to a specific domain and it acts as an override for a registered limit. Similar to registered limits, domain limits require a resource type and a service. Additionally, a registered limit must exist before you can create a domain-specific override. For example, let’s assume a registered limit exists for vcpus provided by the compute service. It wouldn’t be possible to create a domain limit for cores on the compute service. Domain limits can only override limits that have already been registered. In a general sense, registered limits are likely established when a new service or cloud is deployed. Domain limits are used continuously to manage the flow of resource allocation.
域限制是与特定域关联的限制，它充当已注册限制的替代。与注册限制类似，域限制需要资源类型和服务。此外，必须先存在已注册的限制，然后才能创建特定于域的替代。例如，假设计算服务提供的 vcpu  存在已注册的限制。无法为计算服务上的核心创建域限制。域限制只能覆盖已注册的限制。从一般意义上讲，在部署新服务或云时可能会建立已注册的限制。域限制持续用于管理资源分配的流。

Domain limits may affect the limits of projects within the domain. This is particularly important to keep in mind when choosing an enforcement model, documented below.
域限制可能会影响域内项目的限制。在选择强制执行模型时，记住这一点尤为重要，如下所述。

### Project limits[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#project-limits) 项目限制 ¶

Project limits have the same properties as domain limits, but are specific to projects instead of domains. You must register a limit before creating a project-specific override. Just like with domain limits, the flow of resources between related projects may vary depending on the configured enforcement model. The support enforcement models below describe how limit validation and enforcement behave between related projects and domains.
项目限制具有与域限制相同的属性，但特定于项目而不是域。在创建特定于项目的替代之前，必须注册限制。就像域限制一样，相关项目之间的资源流可能因配置的实施模型而异。下面的支持强制模型描述了限制验证和强制在相关项目和域之间的行为方式。

Together, registered limits, domain limits, and project limits give deployments the ability to restrict resources across the deployment by default, while being flexible enough to freely marshal resources across projects.
总之，注册限制、域限制和项目限制使部署能够默认限制整个部署中的资源，同时具有足够的灵活性，可以跨项目自由地封送资源。

## Limits and usage[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#limits-and-usage) 限制和用法 ¶

When we talk about a quota system, we’re really talking about two systems. A system for setting and maintaining limits, the theoretical maximum usage, and a system for enforcing that usage does not exceed limits. While they are coupled, they are distinct.
当我们谈论配额制度时，我们实际上是在谈论两个制度。设置和维护限制、理论最大使用量以及强制使用量不超过限制的系统。虽然它们是耦合的，但它们是不同的。

Up to this point, we’ve established that keystone is the system for maintaining limit information. Keystone’s responsibility is to ensure that any changes to limits are consistent with related limits currently stored in keystone.
到目前为止，我们已经确定 keystone 是维护极限信息的系统。Keystone 的职责是确保对限制的任何更改都与当前存储在 Keystone 中的相关限制一致。

Individual services maintain and enforce usage. Services check enforcement against the current limits at the time a user requests a resource. Usage reflects the actual resource allocation in units to a consumer.
各个服务维护和强制使用。服务在用户请求资源时根据当前限制检查强制执行。使用情况反映了实际分配给使用者的实际资源（以单位为单位）。

Given the above, the following is a possible and legal flow:
鉴于上述情况，以下是可能的合法流程：

- User Jane is in project Foo
  用户 Jane 在项目 Foo 中
- Project Foo has a default CPU limit of 20
  Project Foo 的默认 CPU 限制为 20
- User Jane allocated 18 CPUs in project Foo
  用户 Jane 在项目 Foo 中分配了 18 个 CPU
- Administrator Kelly sets project Foo CPU limit to 10
  管理员 Kelly 将项目 Foo CPU 限制设置为 10
- User Jane can no longer allocate instance resources in project Foo, until she (or others in the project) have deleted at least 9 CPUs to get under the new limit
  用户 Jane 无法再在项目 Foo 中分配实例资源，直到她（或项目中的其他人）删除了至少 9 个 CPU 以达到新的限制

The following would be another permutation:
以下是另一种排列：

- User Jane is in project Foo
  用户 Jane 在项目 Foo 中
- Project Foo has a default CPU limit of 20
  Project Foo 的默认 CPU 限制为 20
- User Jane allocated 20 CPUs in project Foo
  用户 Jane 在项目 Foo 中分配了 20 个 CPU
- User Jane attempts to create another instance, which results in a failed resource request since the request would violate usage based on the current limit of CPUs
  用户 Jane 尝试创建另一个实例，这会导致资源请求失败，因为该请求会违反基于当前 CPU 限制的使用情况
- User Jane requests more resources
  用户 Jane 请求更多资源
- Administrator Kelly adjust the project limit for Foo to be 30 CPUs
  管理员 Kelly 将 Foo 的项目限制调整为 30 个 CPU
- User Jane resends her request for an instance, which succeeds since the usage for project Foo is under the project limit of 30 CPUs
  用户 Jane 重新发送了对实例的请求，该请求成功，因为项目 Foo 的使用量低于 30 个 CPU 的项目限制

This behavior lets administrators set the policy of what the future should be when convenient, and prevent those projects from creating any more resources that would exceed the limits in question. Members of a project can fix this for themselves by bringing down the project usage to where there is now headroom. If they don’t, at some point the administrators can more aggressively delete things themselves.
此行为允许管理员在方便时设置未来应该是什么策略，并防止这些项目创建任何超出相关限制的资源。项目的成员可以通过将项目使用率降低到现在的余量来自行解决此问题。如果他们不这样做，在某些时候，管理员可以更积极地自己删除内容。

## Enforcement models[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#enforcement-models) 强制模型 ¶

Project resources in keystone can be organized in hierarchical structures, where projects can be nested. As a result, resource limits and usage should respect that hierarchy if present. It’s possible to think of different cases where limits or usage assume different characteristics, regardless of the project structure.  For example, if a project’s usage for a particular resource hasn’t been met, should the projects underneath that project assume those limits? Should they not assume those limits? These opinionated models are referred to as enforcement models. This section is dedicated to describing different enforcement models that are implemented.
Keystone  中的项目资源可以按分层结构进行组织，其中项目可以嵌套。因此，资源限制和使用情况应遵循该层次结构（如果存在）。可以考虑不同的情况，其中限制或使用情况具有不同的特征，而不管项目结构如何。例如，如果项目对特定资源的使用量未得到满足，则该项目下的项目是否应该承担这些限制？他们不应该承担这些限制吗？这些固执己见的模型被称为强制模型。本节专门介绍实现的不同强制模型。

It is important to note that enforcement must be consistent across the entire deployment. Grouping certain characteristics into a model makes referring to behaviors consistent across services. Operators should be aware that switching between enforcement models may result in backwards incompatible changes. We recommend extremely careful planning and understanding of various enforcement models if you’re planning on switching from one model to another in a deployment.
请务必注意，在整个部署中强制实施必须保持一致。将某些特征分组到模型中可以使引用的行为在服务之间保持一致。运营商应注意，在强制模型之间切换可能会导致向后不兼容的更改。如果您计划在部署中从一种模型切换到另一种模型，我们建议您非常仔细地规划和了解各种强制模型。

Keystone exposes a `GET /limits/model` endpoint that returns the enforcement model selected by the deployment. This allows limit information to be discoverable and preserves interoperability between OpenStack deployments with different enforcement models.
Keystone 公开一个 `GET /limits/model` 终结点，该终结点返回部署选择的实施模型。这允许限制信息可被发现，并保持具有不同实施模型的OpenStack部署之间的互操作性。

### Flat[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#flat) 扁平 ¶

Flat enforcement ignores all aspects of a project hierarchy. Each project is considered a peer to all other projects. The limits associated to the parents, siblings, or children have no affect on a particular project. This model exercises the most isolation between projects because there are no assumptions between limits, regardless of the hierarchy. Validation of limits via the API will allow operations that might not be considered accepted in other models.
扁平化实施忽略了项目层次结构的所有方面。每个项目都被视为所有其他项目的对等项目。与父母、兄弟姐妹或子女相关的限制对特定项目没有影响。此模型在项目之间执行最大的隔离，因为无论层次结构如何，限制之间都没有假设。通过 API 验证限制将允许在其他模型中可能不被接受的操作。

For example, assume project Charlie is a child of project Beta, which is a child of project Alpha. All projects assume a default limit of 10 cores via a registered limit. The labels in the diagrams below use shorthand notation for limit and usage as l and u, respectively:
例如，假设项目 Charlie 是项目 Beta 的子项目，而项目 Beta 是项目 Alpha 的子项目。所有项目都通过注册限制假定默认限制为 10 个内核。下图中的标签分别使用 limit 和 usage 的速记表示法，分别为 l 和 u：

​                        

Alpha (u=0)

Beta (u=0)

  Charlie (u=0)

Each project may use up to 10 cores because of the registered limit and none of the projects have an override. Using flat enforcement, you’re allowed to `UPDATE LIMIT on Alpha to 20`:
由于已注册的限制，每个项目最多可以使用 10 个内核，并且没有一个项目具有覆盖。使用扁平化强制执行，您可以 `UPDATE LIMIT on Alpha to 20` ：

​                        

Alpha (l=20, u=0)

Beta (u=0)

  Charlie (u=0)

You’re also allowed to `UPDATE LIMIT on Charlie to 30`, even though Charlie is a sub-project of both Beta and Alpha.
你也可以这样做 `UPDATE LIMIT on Charlie to 30` ，尽管查理是 Beta 和 Alpha 的子项目。

​                        

Alpha (l=20, u=0)

Beta (u=0)

  Charlie (l=30, u=0)

This is allowed with flat enforcement because the hierarchy is not taken into consideration during limit validation. Child projects may have a higher limit than a parent project.
这在平面强制中是允许的，因为在限制验证期间不考虑层次结构。子项目的限制可能高于父项目的限制。

Conversely, you can simulate hierarchical enforcement by adjusting limits through the project tree manually. For example, let’s still assume 10 is the default limit imposed by an existing registered limit:
相反，您可以通过项目树手动调整限制来模拟分层强制。例如，我们仍然假设 10 是现有注册限制施加的默认限制：

​                        

Alpha (u=0)

Beta (u=0)

  Charlie (u=0)

You may set a project-specific override to `UPDATE LIMIT on Alpha to 30`:
您可以将特定于项目的覆盖设置为 `UPDATE LIMIT on Alpha to 30` ：

​                        

Alpha (l=30, u=0)

Beta (u=0)

  Charlie (u=0)

Next you can `UPDATE LIMIT on Beta to 20`:
接下来，您可以 `UPDATE LIMIT on Beta to 20` ：

​                        

Alpha (l=30, u=0)

Beta (l=20, u=0)

  Charlie (u=0)

Theoretically, the entire project tree consisting of Alpha, Beta, and Charlie is limited to 60 cores. If you’d like to ensure only 30 cores are used within the entire hierarchy, you can `UPDATE LIMIT on Alpha to 0`:
从理论上讲，由 Alpha、Beta 和 Charlie 组成的整个项目树限制为 60 个内核。如果要确保在整个层次结构中仅使用 30 个内核，可以 `UPDATE LIMIT on Alpha to 0` ：

​                        

Alpha (l=0, u=0)

Beta (l=20, u=0)

  Charlie (u=0)

You should use this model if you:
如果出现以下情况，则应使用此模型：

- Have project hierarchies greater than two levels
  项目层次结构大于两个级别
- Want extremely strict control of project usage and don’t want resource usage to bleed across projects or domains
  希望对项目使用情况进行极其严格的控制，并且不希望资源使用率在项目或域之间流失

#### Advantages[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#advantages) 优势 ¶

- Allows you to model specific and strict limits
  允许您对特定和严格的限制进行建模
- Works with any project hierarchy or depth
  适用于任何项目层次结构或深度
- Usage is only calculated for the project in question
  仅针对相关项目计算使用量

#### Disadvantages[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#disadvantages) 缺点 ¶

- Resources aren’t allowed to flow gracefully between projects in a hierarchy
  不允许资源在层次结构中的项目之间正常流动
- Requires intervention and verification to move resources across projects
  需要干预和验证才能跨项目移动资源
- Project limit validation isn’t performed with respect to other projects or domains
  不对其他项目或域执行项目限制验证

### Strict Two Level[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#strict-two-level) 严格两级 ¶

The `strict_two_level` enforcement model assumes the project hierarchy does not exceed two levels. The top layer can consist of projects or domains. For example, project Alpha can have a sub-project called Beta within this model. Project Beta cannot have a sub-project. The hierarchy is restrained to two layers. Alpha can also be a domain that contains project Beta, but Beta cannot have a sub-project. Regardless of the top layer consisting of projects or domains, the hierarchical depth is limited to two layers.
 `strict_two_level` 实施模型假定项目层次结构不超过两个级别。顶层可以由项目或域组成。例如，项目 Alpha 可以在此模型中具有一个名为 Beta  的子项目。Project Beta 不能有子项目。层次结构被限制为两层。Alpha 也可以是包含项目 Beta 的域，但 Beta  不能有子项目。无论顶层由项目或域组成，层次结构深度都限制为两层。

Resource utilization is allowed to flow between projects in the hierarchy, depending on the limits. This property allows for more flexibility than the `flat` enforcement model. The model is strict in that operators can set limits on parent projects or domains and the limits of the children may never exceed the parent.
允许资源利用率在层次结构中的项目之间流动，具体取决于限制。与强制模型相比， `flat` 此属性具有更大的灵活性。该模型非常严格，因为操作员可以对父项目或域设置限制，并且子项目的限制永远不会超过父项目或域。

For example, assume domain Alpha contains two projects, Beta and Charlie. Projects Beta and Charlie are siblings so the hierarchy maintains a depth of two. A system administrator sets the limit of a resource on Alpha to 20. Both projects Beta and Charlie can consume resources until the total usage of Alpha, Beta, and Charlie reach 20. At that point, no more resources should be allocated to the tree. System administrators can also reserve portions of domain Alpha’s resource in sub-projects directly. Using the previous example, project Beta could have a limit of 12 resources, implicitly leaving 8 resources for Charlie to consume.
例如，假设域 Alpha 包含两个项目：Beta 和 Charlie。项目 Beta 和 Charlie 是同级，因此层次结构的深度为 2。系统管理员将  Alpha 上的资源限制设置为 20。Beta 和 Charlie 这两个项目都可以消耗资源，直到 Alpha、Beta 和 Charlie  的总使用量达到 20。此时，不应再向树分配资源。系统管理员还可以直接在子项目中保留域 Alpha 的部分资源。使用前面的示例，项目 Beta  的资源限制为 12 个，隐式地留下 8 个资源供 Charlie 使用。

The following diagrams illustrate the behaviors described above, using projects named Alpha, Beta, Charlie, and Delta. Assume the resource in question is cores and the default registered limit for cores is 10. Also assume we have the following project hierarchy where Alpha has a limit of 20 cores and its usage is currently 4:
下图使用名为 Alpha、Beta、Charlie 和 Delta 的项目说明了上述行为。假设有问题的资源是内核，并且内核的默认注册限制为 10。此外，假设我们有以下项目层次结构，其中 Alpha 的限制为 20 个核心，其使用量当前为 4：

​                        

Alpha (l=20, u=4)

Beta (u=0)

Charlie (u=0)



Technically, both Beta and Charlie can use up to 8 cores each:
从技术上讲，Beta 和 Charlie 最多可以使用 8 个内核：

​                        

Alpha (l=20, u=4)

Beta (u=8)

Charlie (u=8)



If Alpha attempts to claim two cores the usage check will fail because the service will fetch the hierarchy from keystone using `oslo.limit` and check the usage of each project in the hierarchy to see that the total usage of Alpha, Beta, and Charlie is equal to the limit of the tree, set by Alpha.limit:
如果 Alpha 尝试声明两个内核，则使用情况检查将失败，因为服务将使用 `oslo.limit` 从 keystone 获取层次结构，并检查层次结构中每个项目的使用情况，以查看 Alpha、Beta 和 Charlie 的总使用量是否等于 Alpha.limit 设置的树的限制：

​                        

Alpha (l=20, u=6)

Beta (u=8)

Charlie (u=8)



Despite the usage of the tree being equal to the limit, we can still add children to the tree:
尽管树的使用量等于限制，但我们仍然可以向树添加子项：

​                        

Alpha (l=20, u=4)

Beta (u=8)

Charlie (u=8)

Delta (u=0)



Even though the project can be created, the current usage of cores across the tree prevents Delta from claiming any cores:
即使可以创建项目，树中当前核心的使用情况也会阻止 Delta 声明任何核心：

​                        

Alpha (l=20, u=4)

Beta (u=8)

Charlie (u=8)

Delta (u=2)



Creating a grandchild of project Alpha is forbidden because it violates the two-level hierarchical constraint:
禁止创建项目 Alpha 的孙子，因为它违反了两级层次结构约束：

​                        

Alpha (l=20, u=4)

Beta (u=8)

Charlie (u=8)

Delta (u=0)



This is a fundamental constraint of this design because it provides a very clear escalation path. When a request fails because the tree limit has been exceeded, a user has all the information they need to provide meaningful context in a support ticket (e.g., their project ID and the parent project ID). An administrator should be able to reshuffle usage accordingly. Providing this information in tree structures with more than a depth of two is much harder, but may be implemented with a separate model.
这是此设计的基本约束，因为它提供了非常清晰的升级路径。当请求因超出树限制而失败时，用户将拥有在支持票证中提供有意义的上下文所需的所有信息（例如，其项目 ID 和父项目 ID）。管理员应该能够相应地重新洗牌使用情况。在深度超过 2 的树结构中提供此信息要困难得多，但可以使用单独的模型来实现。

Granting Beta the ability to claim more cores can be done by giving Beta a project-specific override for cores
授予 Beta 要求更多内核的能力可以通过为 Beta 提供特定于项目的内核覆盖来实现

​                        

Alpha (l=20, u=4)

Beta (l=12, u=8)

Charlie (u=8)



Note that regardless of this update, any subsequent requests to claim more cores in the tree will be rejected since the usage is equal to the limit of the Alpha. Beta can claim cores if they are released from Alpha or Charlie:
请注意，无论此更新如何，任何后续要求在树中声明更多内核的请求都将被拒绝，因为使用量等于 Alpha 的限制。如果核心从 Alpha 或 Charlie 释放，Beta 可以声明核心：

​                        

Alpha (l=20, u=2)

Beta (l=12, u=8)

Charlie (u=6)



​                        

Alpha (l=20, u=2)

Beta (l=12, u=12)

Charlie (u=6)



While Charlie is still under its default allocation of 10 cores, it won’t be able to claim any more cores because the total usage of the tree is equal to the limit of Alpha, thus preventing Charlie from reclaiming the cores it had:
虽然 Charlie 仍处于默认分配的 10 个内核之下，但它将无法再要求任何内核，因为树的总使用量等于 Alpha 的限制，从而阻止 Charlie 回收它拥有的核心：

​                        

Alpha (l=20, u=2)

Beta (l=12, u=12)

Charlie (u=8)



Creating or updating a project with a limit that exceeds the limit of Alpha is forbidden. Even though it is possible for the sum of all limits under Alpha to exceed the limit of Alpha, the total usage is capped at Alpha.limit. Allowing children to have explicit overrides greater than the limit of the parent would result in strange user experience and be misleading since the total usage of the tree would be capped at the limit of the parent:
禁止创建或更新限制超过 Alpha 限制的项目。即使 Alpha 下所有限制的总和有可能超过 Alpha 的限制，总使用量的上限为  Alpha.limit。允许子树具有大于父级限制的显式覆盖将导致奇怪的用户体验并具有误导性，因为树的总使用量将限制在父级的限制：

​                        

Alpha (l=20, u=0)

Beta (l=30, u=0)

Charlie (u=0)



​                        

Alpha (l=20, u=0)

Beta (u=0)

Charlie (u=0)

Delta (l=30, u=0)



Finally, let’s still assume the default registered limit for cores is 10, but we’re going to create project Alpha with a limit of 6 cores.
最后，我们仍然假设内核的默认注册限制是 10 个，但我们将创建限制为 6 个内核的项目 Alpha。

​                        

  Alpha (l=6, u=0)

When we create project Beta, which is a child of project Alpha, the limit API ensures that project Beta doesn’t assume the default of 10, despite the registered limit of 10 cores. Instead, the child assumes the parent’s limit since no single child limit should exceed the limit of the parent:
当我们创建项目 Beta（它是项目 Alpha 的子项目）时，限制 API 可确保项目 Beta 不采用默认值 10，尽管已注册的限制为 10 个核心。相反，子项假定父项的限制，因为任何子项的限制都不应超过父项的限制：

​                        

Alpha (l=6, u=0)

Beta (l=6, u=0)



This behavior is consistent regardless of the number of children added under project Alpha.
无论在项目 Alpha 下添加的子项数如何，此行为都是一致的。

​                        

Alpha (l=6, u=0)

Beta (l=6, u=0)

Charlie (l=6, u=0)

Delta (l=6, u=0)



Creating limit overrides while creating projects seems counter-productive given the whole purpose of a registered default, but it also seems unlikely to throttle a parent project by specifying it’s default to be less than a registered default. This behavior maintains consistency with the requirement that the sum of all child limits may exceed the parent limit, but the limit of any one child may not.
考虑到注册默认值的全部目的，在创建项目时创建限制覆盖似乎适得其反，但似乎也不太可能通过指定父项目的默认值小于注册默认值来限制父项目。此行为与以下要求保持一致：所有子项限制的总和可能超过父限制，但任何一个子项的限制不得超过父限制。

You should use this model if you:
如果出现以下情况，则应使用此模型：

- Want resources to flow between projects and domains within a hierarchy
  希望资源在层次结构中的项目和域之间流动
- Don’t have a project depth greater than two levels
  项目深度不大于两个级别
- Are not concerned about usage calculation performance or don’t have project trees that are wide
  不关心使用率计算性能或没有宽的项目树

#### Advantages[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#id1) 优势 ¶

- Allows resources to flow between projects and domains within a strict two-level hierarchy
  允许资源在严格的两级层次结构内在项目和域之间流动
- Limits are validated when they are created and updated
  限制在创建和更新时进行验证

#### Disadvantages[¶](https://docs.openstack.org/keystone/yoga/admin/unified-limits.html#id2) 缺点 ¶

- Project depth cannot exceed two levels
  项目深度不能超过两个级别
- Performance may suffer in wide and flat project hierarchies during usage calculation
  在使用量计算过程中，在宽而扁平的项目层次结构中，性能可能会受到影响

# Resource Options 资源选项

​                                          

A resource option is an attribute that can be optionally set on an entity in keystone. These options are used to control specific features or behaviors within keystone. This allows flexibility on a per-resource basis as opposed to settings a configuration file value that controls a behavior for all resources in a deployment.
资源选项是可以选择性地在 keystone 中的实体上设置的属性。这些选项用于控制 keystone 中的特定功能或行为。这允许在每个资源的基础上实现灵活性，而不是设置一个配置文件值来控制部署中所有资源的行为。

This flexibility can be useful for deployments is setting different authentication requirements for users. For example, operators can use resource options to set the number of failed authentication attempts on a per-user basis as opposed to setting a global value that is applied to all users.
这种灵活性对于为用户设置不同的身份验证要求的部署非常有用。例如，操作员可以使用资源选项来设置每个用户失败的身份验证尝试次数，而不是设置应用于所有用户的全局值。

The purpose of this document is to formally document the supported resource options used in keystone, their intended behavior, and how to use them.
本文档的目的是正式记录 keystone 中使用的受支持资源选项、它们的预期行为以及如何使用它们。

## User Options[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#user-options) 用户选项 ¶

The following options are available on user resources. If left undefined, they are assumed to be false or disabled.
以下选项可用于用户资源。如果未定义，则假定它们为 false 或禁用。

These can be set either in the initial user creation (`POST /v3/users`) or by updating an existing user to include new options (`PATCH /v3/users/{user_id}`):
这些选项可以在初始用户创建时 （ `POST /v3/users` ） 进行设置，也可以通过更新现有用户以包含新选项 （ `PATCH /v3/users/{user_id}` ） 来设置：

```
{
    "user": {
        "options": {
            "ignore_lockout_failure_attempts": true
        }
    }
}
```



 

Note 注意



User options of the `Boolean` type can be set to `True`, `False`, or `None`; if the option is set to `None`, it is removed from the user’s data structure.
该 `Boolean` 类型的用户选项可以设置为 `True` 、 `False` 或 `None` ;如果该选项设置为 `None` ，则会将其从用户的数据结构中删除。



### ignore_user_inactivity[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-user-inactivity)

Type: `Boolean` 类型： `Boolean` 

Opt into ignoring global inactivity lock settings defined in `keystone.conf [security_compliance]` on a per-user basis. Setting this option to `True` will make users not set as disabled even after the globally configured inactivity period is reached.
选择忽略中定义的 `keystone.conf [security_compliance]` 基于每个用户的全局非活动锁定设置。将此选项 `True` 设置为将使用户即使在达到全局配置的非活动期后也不会设置为禁用。

```
{
    "user": {
        "options": {
            "ignore_user_inactivity": true
        }
    }
}
```



 

Note 注意



Setting this option for users which are already disabled will not make them automatically enabled. Such users must be enabled manually after setting this option to True for them.
为已禁用的用户设置此选项不会使其自动启用。将此选项设置为 True 后，必须手动启用此类用户。

See the [security compliance documentation](https://docs.openstack.org/keystone/yoga/admin/security-compliance.html) for more details.
有关详细信息，请参阅安全合规性文档。



### ignore_change_password_upon_first_use[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-change-password-upon-first-use)

Type: `Boolean` 类型： `Boolean` 

Control if a user should be forced to change their password immediately after they log into keystone for the first time. This can be useful for deployments that auto-generate passwords but want to ensure a user picks a new password when they start using the deployment.
控制用户是否应在首次登录 keystone 后立即强制更改其密码。这对于自动生成密码但希望确保用户在开始使用部署时选择新密码的部署非常有用。

```
{
    "user": {
        "options": {
            "ignore_change_password_upon_first_use": true
        }
    }
}
```

See the [security compliance documentation](https://docs.openstack.org/keystone/yoga/admin/configuration.html#security-compliance) for more details.
有关详细信息，请参阅安全合规性文档。



### ignore_password_expiry[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-password-expiry)

Type: `Boolean` 类型： `Boolean` 

Opt into ignoring global password expiration settings defined in `keystone.conf [security_compliance]` on a per-user basis. Setting this option to `True` will allow users to continue using passwords that may be expired according to global configuration values.
选择忽略中定义的 `keystone.conf [security_compliance]` 基于每个用户的全局密码过期设置。将此选项设置为 `True` 将允许用户继续使用根据全局配置值可能已过期的密码。

```
{
    "user": {
        "options": {
            "ignore_password_expiry": true
        }
    }
}
```

See the [security compliance documentation](https://docs.openstack.org/keystone/yoga/admin/configuration.html#security-compliance) for more details.
有关详细信息，请参阅安全合规性文档。



### ignore_lockout_failure_attempts[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#ignore-lockout-failure-attempts)

Type: `Boolean` 类型： `Boolean` 

If `True`, opt into ignoring the number of times a user has authenticated and locking out the user as a result.
如果 `True` ，则选择忽略用户进行身份验证的次数，并因此锁定该用户。

```
{
    "user": {
        "options": {
            "ignore_lockout_failure_attempts": true
        }
    }
}
```

See the [security compliance documentation](https://docs.openstack.org/keystone/yoga/admin/configuration.html#security-compliance) for more details.
有关详细信息，请参阅安全合规性文档。



### lock_password[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#lock-password)

Type: `Boolean` 类型： `Boolean` 

If set to `True`, this option disables the ability for users to change their password through self-service APIs.
如果设置为 `True` ，则此选项将禁止用户通过自助服务 API 更改其密码。

```
{
    "user": {
        "options": {
            "lock_password": true
        }
    }
}
```

See the [security compliance documentation](https://docs.openstack.org/keystone/yoga/admin/configuration.html#security-compliance) for more details.
有关详细信息，请参阅安全合规性文档。



### multi_factor_auth_enabled[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#multi-factor-auth-enabled)

Type: `Boolean` 类型： `Boolean` 

Specify if a user has multi-factor authentication enabled on their account. This will result in different behavior at authentication time and the user may be presented with different authentication requirements based on multi-factor configuration.
指定用户是否在其帐户上启用了多重身份验证。这将导致身份验证时出现不同的行为，并且可能会根据多重配置向用户提供不同的身份验证要求。

```
{
    "user": {
        "options": {
            "multi_factor_auth_enabled": true
        }
    }
}
```

See [Multi-Factor Authentication](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#multi-factor-authentication) for further details.
有关详细信息，请参阅多重身份验证。



### multi_factor_auth_rules[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#multi-factor-auth-rules)

Type: `List of Lists of Strings` 类型： `List of Lists of Strings` 

Define a list of strings that represent the methods required for a user to authenticate.
定义一个字符串列表，这些字符串表示用户进行身份验证所需的方法。

```
{
    "user": {
        "options": {
            "multi_factor_auth_rules": [
                ["password", "totp"],
                ["password", "u2f"]
            ]
        }
    }
}
```

See [Multi-Factor Authentication](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#multi-factor-authentication) for further details.
有关详细信息，请参阅多重身份验证。

## Role Options[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#role-options) 角色选项 ¶

The following options are available on role resources. If left undefined, they are assumed to be false or disabled.
以下选项可用于角色资源。如果未定义，则假定它们为 false 或禁用。

### immutable[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#immutable) 不可变 ¶

Type: `Boolean` 类型： `Boolean` 

Specify whether a role is immutable. An immutable role may not be deleted or modified except to remove the `immutable` option.
指定角色是否不可变。除非删除该 `immutable` 选项，否则不得删除或修改不可变角色。

```
{
    "role": {
        "options": {
            "immutable": true
        }
    }
}
```

## Project Options[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#project-options) 项目选项 ¶

The following options are available on project resources. If left undefined, they are assumed to be false or disabled.
以下选项可用于项目资源。如果未定义，则假定它们为 false 或禁用。

### immutable[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#id8) 不可变 ¶

Type: `Boolean` 类型： `Boolean` 

Specify whether a project is immutable. An immutable project may not be deleted or modified except to remove the `immutable` option.
指定项目是否不可变。除非删除该 `immutable` 选项，否则不得删除或修改不可变项目。

```
{
    "project": {
        "options": {
            "immutable": true
        }
    }
}
```

## Domain Options[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#domain-options) 域名选项 ¶

The following options are available on domain resources. If left undefined, they are assumed to be false or disabled.
以下选项可用于域资源。如果未定义，则假定它们为 false 或禁用。

### immutable[¶](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#id9) 不可变 ¶

Type: `Boolean` 类型： `Boolean` 

Specify whether a domain is immutable. An immutable domain may not be deleted or modified except to remove the `immutable` option.
指定域是否不可变。除非删除选项 `immutable` ，否则不得删除或修改不可变域。

```
{
    "domain": {
        "options": {
            "immutable": true
        }
    }
}
```

# Credential Encryption 凭据加密

​                                          

As of the Newton release, keystone encrypts all credentials stored in the default `sql` backend. Credentials are encrypted with the same mechanism used to encrypt Fernet tokens, `fernet`. Keystone provides only one type of credential encryption but the encryption provider is pluggable in the event you wish to supply a custom implementation.
从 Newton 版本开始，keystone 对默认 `sql` 后端中存储的所有凭据进行加密。凭证使用与加密 Fernet 令牌相同的机制进行加密。 `fernet` Keystone 仅提供一种类型的凭据加密，但如果您希望提供自定义实现，则加密提供程序是可插入的。

This document details how credential encryption works, how to migrate existing credentials in a deployment, and how to manage encryption keys for credentials.
本文档详细介绍了凭据加密的工作原理、如何迁移部署中的现有凭据以及如何管理凭据的加密密钥。

## Configuring credential encryption[¶](https://docs.openstack.org/keystone/yoga/admin/credential-encryption.html#configuring-credential-encryption) 配置凭证加密 ¶

The configuration for credential encryption is straightforward. There are only two configuration options needed:
凭据加密的配置非常简单。只需要两个配置选项：

```
[credential]
provider = fernet
key_repository = /etc/keystone/credential-keys/
```

`[credential] provider` defaults to the only option supplied by keystone, `fernet`. There is no reason to change this option unless you wish to provide a custom credential encryption implementation. The `[credential] key_repository` location is a requirement of using `fernet` but will default to the `/etc/keystone/credential-keys/` directory. Both `[credential] key_repository` and `[fernet_tokens] key_repository` define locations for keys used to encrypt things. One holds the keys to encrypt and decrypt credentials and the other holds keys to encrypt and decrypt tokens. It is imperative that these repositories are managed separately and they must not share keys. Meaning they cannot share the same directory path. The `[credential] key_repository` is only allowed to have three keys. This is not configurable and allows for credentials to be re-encrypted periodically with a new encryption key for the sake of security.
 `[credential] provider` 默认为 Keystone 提供的唯一选项 `fernet` 。除非您希望提供自定义凭据加密实现，否则没有理由更改此选项。该 `[credential] key_repository` 位置是 using `fernet` 的必需条件，但默认为 `/etc/keystone/credential-keys/` 目录。两者都 `[credential] key_repository`  `[fernet_tokens] key_repository` 定义了用于加密事物的密钥的位置。一个持有用于加密和解密凭据的密钥，另一个持有用于加密和解密令牌的密钥。这些存储库必须单独管理，并且它们不得共享密钥。这意味着它们不能共享相同的目录路径。 `[credential] key_repository` 只允许有三个键。这是不可配置的，并且为了安全起见，允许使用新的加密密钥定期重新加密凭据。

## How credential encryption works[¶](https://docs.openstack.org/keystone/yoga/admin/credential-encryption.html#how-credential-encryption-works) 凭证加密的工作原理 ¶

The implementation of this feature did not change any existing credential API contracts. All changes are transparent to the user unless you’re inspecting the credential backend directly.
此功能的实现不会更改任何现有的凭据 API 协定。所有更改对用户都是透明的，除非你直接检查凭据后端。

When creating a credential, keystone will encrypt the `blob` attribute before persisting it to the backend. Keystone will also store a hash of the key that was used to encrypt the information in that credential. Since Fernet is used to encrypt credentials, a key repository consists of multiple keys. Keeping track of which key was used to encrypt each credential is an important part of encryption key management. Why this is important is detailed later in the Encryption key management section.
创建凭证时，keystone 会先对 `blob` 属性进行加密，然后再将其持久化到后端。Keystone 还将存储用于加密该凭据中信息的密钥的哈希值。由于 Fernet  用于加密凭据，因此密钥存储库由多个密钥组成。跟踪用于加密每个凭据的密钥是加密密钥管理的重要组成部分。为什么这很重要，稍后的加密密钥管理部分将详细介绍。

When updating an existing credential’s `blob` attribute, keystone will encrypt the new `blob` and update the key hash.
更新现有凭据的属性时，keystone 将加密新 `blob` 凭据 `blob` 并更新密钥哈希。

When listing or showing credentials, all `blob` attributes are decrypted in the response. Neither the cipher text, nor the hash of the key used to encrypt the `blob` are exposed through the API. Furthermore, the key is only used internally to keystone.
列出或显示凭据时，所有 `blob` 属性都会在响应中解密。密文和用于加密 `blob` 的密钥的哈希都不会通过 API 公开。此外，密钥仅在内部用于梯形失真。

## Encrypting existing credentials[¶](https://docs.openstack.org/keystone/yoga/admin/credential-encryption.html#encrypting-existing-credentials) 加密现有凭据 ¶

When upgrading a Mitaka deployment to Newton, three database migrations will ensure all credentials are encrypted. The process is as follows:
将 Mitaka 部署升级到 Newton 时，三次数据库迁移将确保所有凭据都已加密。具体流程如下：

1. An additive schema change is made to create the new `encrypted_blob` and `key_hash` columns in the existing `credential` table using `keystone-manage db_sync --expand`.
   使用附加架构更改以在现有表中创建新的 `encrypted_blob` 和 `key_hash` 列。 `credential` `keystone-manage db_sync --expand` 
2. A data migration will loop through all existing credentials, encrypt each `blob` and store the result in the new `encrypted_blob` column. The hash of the key used is also written to the `key_hash` column for that specific credential. This step is done using `keystone-manage db_sync --migrate`.
   数据迁移将遍历所有现有凭据，对每个 `blob` 凭据进行加密，并将结果存储在新 `encrypted_blob` 列中。所用密钥的哈希值也会写入该特定凭据的 `key_hash` 列。此步骤是使用 `keystone-manage db_sync --migrate` 完成的。
3. A contractive schema will remove the `blob` column that held the plain text representations of the credential using `keystone-manage db_sync --contract`. This should only be done after all nodes in the deployment are running Newton. If any Mitaka nodes are running after the database is contracted, they won’t be able to read credentials since they are looking for the `blob` column that no longer exists.
   收缩架构将使用 `keystone-manage db_sync --contract` 删除保存凭据的纯文本表示 `blob` 形式的列。只有在部署中的所有节点都运行 Newton 之后，才应执行此操作。如果任何 Mitaka 节点在数据库签约后正在运行，它们将无法读取凭据，因为它们正在寻找不再存在的 `blob` 列。



 

Note 注意



You may also use `keystone-manage db_sync --check` in order to check the current status of your rolling upgrades.
您也可以用于 `keystone-manage db_sync --check` 检查滚动升级的当前状态。

If performing a rolling upgrade, please note that a limited service outage will take affect during this migration. When the migration is in place, credentials will become read-only until the database is contracted. After the contract phase is complete, credentials will be writeable to the backend. A `[credential] key_repository` location must be specified through configuration and bootstrapped with keys using `keystone-manage credential_setup` prior to migrating any existing credentials. If a new key repository isn’t setup using `keystone-manage credential_setup` keystone will assume a null key to encrypt and decrypt credentials until a proper key repository is present. The null key is a key consisting of all null bytes and its only purpose is to ease the upgrade process from Mitaka to Newton. It is highly recommended that the null key isn’t used. It is no more secure than storing credentials in plain text. If the null key is used, you should migrate to a proper key repository using `keystone-manage credential_setup` and `keystone-manage credential_migrate`.
如果执行滚动升级，请注意，在此迁移期间，有限的服务中断将受到影响。迁移到位后，凭据将变为只读，直到签订数据库合同。合同阶段完成后，凭据将可写入后端。在迁移任何现有凭据 `keystone-manage credential_setup` 之前，必须通过配置指定 `[credential] key_repository` 位置并使用密钥引导位置。如果未使用 `keystone-manage credential_setup` keystone  设置新的密钥存储库，则将假定一个空密钥来加密和解密凭据，直到存在正确的密钥存储库。空键是由所有空字节组成的密钥，其唯一目的是简化从 Mitaka 到 Newton 的升级过程。强烈建议不要使用 null 键。它并不比以纯文本形式存储凭据更安全。如果使用 null 密钥，则应使用 `keystone-manage credential_setup` 和 `keystone-manage credential_migrate` 迁移到正确的密钥存储库。

## Encryption key management[¶](https://docs.openstack.org/keystone/yoga/admin/credential-encryption.html#encryption-key-management) 加密密钥管理 ¶

Key management of `[credential] key_repository` is handled with three `keystone-manage` commands:
使用三个 `keystone-manage` 命令处理密钥 `[credential] key_repository` 管理：

1. `keystone-manage credential_setup`
2. `keystone-manage credential_rotate`
3. `keystone-manage credential_migrate`

`keystone-manage credential_setup` will populate `[credential] key_repository` with new encryption keys. This must be done in order for proper credential encryption to work, with the exception of the null key. This step should only be done once.
 `keystone-manage credential_setup` 将 `[credential] key_repository` 填充新的加密密钥。必须执行此操作才能使正确的凭据加密正常工作，但空密钥除外。此步骤只能执行一次。

`keystone-manage credential_rotate` will create and rotate a new encryption key in the `[credential] key_repository`. This will only be done if all credential key hashes match the hash of the current primary key. If any credential has been encrypted with an older key, or secondary key, the rotation will fail. Failing the rotation is necessary to prevent overrotation, which would leave some credentials indecipherable since the key used to encrypt it no longer exists. If this step fails, it is possible to forcibly re-key all credentials using the same primary key with `keystone-manage credential_migrate`.
 `keystone-manage credential_rotate` 将在 `[credential] key_repository`  中创建并轮换新的加密密钥。仅当所有凭证密钥哈希值都与当前主密钥的哈希值匹配时，才会执行此操作。如果任何凭据已使用较旧的密钥或辅助密钥进行加密，则轮换将失败。为了防止过度轮换，必须使轮换失败，这将使某些凭据无法破译，因为用于加密它的密钥不再存在。如果此步骤失败，则可以使用相同的主键强制重新生成所有凭据 `keystone-manage credential_migrate` 的密钥。

`keystone-manage credential_migrate` will check the backend for credentials whose key hash doesn’t match the hash of the current primary key. Any credentials with a key hash mismatching the current primary key will be re-encrypted with the current primary key. The new cipher text and key hash will be updated in the backend.
 `keystone-manage credential_migrate` 将检查后端是否有密钥哈希与当前主密钥的哈希不匹配的凭据。任何密钥哈希与当前主密钥不匹配的凭据都将使用当前主密钥重新加密。新的密文和密钥哈希将在后端更新。

# Health Check 健康检查

​                                          

Health check mechanism allows an operator to configure the endpoint URL that will provide information to a load balancer if the given API endpoint at the node should be available or not.
运行状况检查机制允许操作员配置端点 URL，该端点 URL 将在节点上的给定 API 端点是否可用时向负载均衡器提供信息。

It’s enabled by default in Keystone using the functions from oslo.middleware. And the URL is `/healthcheck`.
默认情况下，它在 Keystone 中使用 oslo.middleware 中的函数启用。URL 是 `/healthcheck` .

For more information and configuration options for the middleware see [oslo.middleware](https://docs.openstack.org/oslo.middleware/latest/reference/healthcheck_plugins.html).
有关中间件的详细信息和配置选项，请参阅 oslo.middleware。

# Keystone Event Notifications Keystone 事件通知

​                                          

Keystone provides notifications about usage data so that 3rd party applications can use the data for billing, monitoring, or quota purposes. This document describes the current inclusions and exclusions for Keystone notifications.
Keystone 提供有关使用情况数据的通知，以便第三方应用程序可以将数据用于计费、监视或配额目的。本文档介绍Keystone通知的当前包含和排除项。

Keystone currently supports two notification formats: a Basic Notification, and a Cloud Auditing Data Federation ([CADF](http://www.dmtf.org/standards/cadf)) Notification. The supported operations between the two types of notification formats are documented below.
Keystone 目前支持两种通知格式：基本通知和云审计数据联合 （CADF） 通知。下面记录了两种类型的通知格式之间支持的操作。

## Common Notification Structure[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#common-notification-structure) 通用通知结构 ¶

Notifications generated by Keystone are generated in JSON format. An external application can format them into ATOM format and publish them as a feed. Currently, all notifications are immediate, meaning they are generated when a specific event happens. Notifications all adhere to a specific top level format:
Keystone 生成的通知以 JSON 格式生成。外部应用程序可以将它们格式化为 ATOM 格式，并将它们作为源发布。目前，所有通知都是即时的，这意味着它们是在特定事件发生时生成的。通知都遵循特定的顶级格式：

```
{
    "event_type": "identity.<resource_type>.<operation>",
    "message_id": "<message_id>",
    "payload": {},
    "priority": "INFO",
    "publisher_id": "identity.<hostname>",
    "timestamp": "<timestamp>"
}
```

Where `<resource_type>` is a Keystone resource, such as user or project, and `<operation>` is a Keystone operation, such as created, deleted.
其中 `<resource_type>` 是 Keystone 资源（例如用户或项目），并且是 `<operation>` Keystone 操作（例如已创建、已删除）。

The key differences between the two notification formats (Basic and CADF), lie within the `payload` portion of the notification.
两种通知格式（Basic 和 CADF）之间的主要区别在于通知 `payload` 的部分。

The `priority` of the notification being sent is not configurable through the Keystone configuration file. This value is defaulted to INFO for all notifications sent in Keystone’s case.
无法通过 Keystone 配置文件配置正在发送 `priority` 的通知。对于在 Keystone 的情况下发送的所有通知，此值默认为 INFO。

## Auditing with CADF[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#auditing-with-cadf) 使用 CADF 进行审计 ¶

Keystone uses the [PyCADF](https://docs.openstack.org/pycadf/latest) library to emit CADF notifications, these events adhere to the DMTF [CADF](http://www.dmtf.org/standards/cadf) specification. This standard provides auditing capabilities for compliance with security, operational, and business processes and supports normalized and categorized event data for federation and aggregation.
Keystone 使用 PyCADF 库发出 CADF 通知，这些事件符合 DMTF CADF 规范。该标准提供审计功能，以符合安全、操作和业务流程，并支持用于联合和聚合的规范化和分类事件数据。

CADF notifications include additional context data around the `resource`, the `action` and the `initiator`.
CADF 通知包括 `resource` 、 `action` 和 周围的其他上下文数据 `initiator` 。

CADF notifications may be emitted by changing the `notification_format` to `cadf` in the configuration file.
CADF 通知可以通过更改配置文件中的 `notification_format` to `cadf` 来发出。

The `payload` portion of a CADF Notification is a CADF `event`, which is represented as a JSON dictionary. For example:
CADF通知 `payload` 的部分是CADF `event` ，它表示为JSON字典。例如：

```
{
    "typeURI": "http://schemas.dmtf.org/cloud/audit/1.0/event",
    "initiator": {
        "typeURI": "service/security/account/user",
        "host": {
            "agent": "curl/7.22.0(x86_64-pc-linux-gnu)",
            "address": "127.0.0.1"
        },
        "id": "<initiator_id>"
    },
    "target": {
        "typeURI": "<target_uri>",
        "id": "openstack:1c2fc591-facb-4479-a327-520dade1ea15"
    },
    "observer": {
        "typeURI": "service/security",
        "id": "openstack:3d4a50a9-2b59-438b-bf19-c231f9c7625a"
    },
    "eventType": "activity",
    "eventTime": "2014-02-14T01:20:47.932842+00:00",
    "action": "<action>",
    "outcome": "success",
    "id": "openstack:f5352d7b-bee6-4c22-8213-450e7b646e9f",
}
```

Where the following are defined:
其中定义了以下内容：

- `<initiator_id>`: ID of the user that performed the operation
   `<initiator_id>` ：执行操作的用户的 ID
- `<target_uri>`: CADF specific target URI, (i.e.:  data/security/project)
   `<target_uri>` ：CADF 特定目标 URI（即：data/security/project）
- `<action>`: The action being performed, typically: `<operation>`. `<resource_type>`
   `<action>` ：正在执行的操作，通常为： `<operation>` 。 `<resource_type>` 



 

Note 注意



The `eventType` property of the CADF payload is different from the `event_type` property of a notifications. The former (`eventType`) is a CADF keyword which designates the type of event that is being measured, this can be: activity, monitor or control. Whereas the latter (`event_type`) is described in previous sections as: identity.<resource_type>.<operation>
CADF 有效负载的 `eventType` 属性与通知的 `event_type` 属性不同。前者 （ `eventType` ） 是一个 CADF 关键字，用于指定正在测量的事件类型，可以是：活动、监视或控制。而后者 （ `event_type` ） 在前面的章节中被描述为：身份。。

Additionally there may be extra keys present depending on the operation being performed, these will be discussed below.
此外，根据正在执行的操作，可能存在额外的密钥，这些密钥将在下面讨论。

### Reason[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#reason) 原因 ¶

There is a specific `reason` object that will be present for the following PCI-DSS related events:
对于以下 PCI-DSS 相关事件，将存在一个特定 `reason` 对象：

| PCI-DSS Section PCI-DSS部分                                  | reasonCode | reasonType                                                   |
| ------------------------------------------------------------ | ---------- | ------------------------------------------------------------ |
| 8.1.6 Limit repeated access attempts by locking out the user after more than X failed attempts. 8.1.6 通过在超过 X 次失败尝试后锁定用户来限制重复访问尝试。 | 401        | Maximum number of <number> login attempts exceeded.  超过最大登录尝试次数。 |
| 8.2.3 Passwords must meet the established criteria. 8.2.3 密码必须符合既定标准。 | 400        | Password does not meet expected requirements: <regex_description> 密码不符合预期要求： |
| 8.2.4 Password must be changed every X days. 8.2.4 密码必须每 X 天更改一次。 | 401        | Password for <user> expired and must be changed 密码已过期，必须更改 |
| 8.2.5 Do not let users reuse the last X passwords. 8.2.5 不要让用户重复使用最后的 X 个密码。 | 400        | Changed password cannot be identical to the last <number> passwords. 更改的密码不能与上次的密码相同。 |
| Other - Prevent passwords from being changed for a minimum of X days. 其他 - 至少在 X 天内阻止更改密码。 | 401        | Cannot change password before minimum age <number> days is met 在达到最低年龄天数之前无法更改密码 |

The reason object will contain the following keys:
reason 对象将包含以下键：

- `reasonType`: Description of the PCI-DSS event
   `reasonType` ：PCI-DSS 事件的说明
- `reasonCode`: HTTP response code for the event
   `reasonCode` ：事件的 HTTP 响应代码

For more information, see [Security compliance and PCI-DSS](https://docs.openstack.org/keystone/yoga/admin/configuration.html#security-compliance) for configuring PCI-DSS in keystone.
有关详细信息，请参阅用于在 keystone 中配置 PCI-DSS 的安全合规性和 PCI-DSS。

### Supported Events[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#supported-events) 支持的事件 ¶

The following table displays the compatibility between resource types and operations.
下表显示了资源类型和操作之间的兼容性。

| Resource Type 资源类型   | Supported Operations 支持的操作       | typeURI 类型URI                                |
| ------------------------ | ------------------------------------- | ---------------------------------------------- |
| group 群                 | create,update,delete 创建、更新、删除 | data/security/group 数据/安全/组               |
| project 项目             | create,update,delete 创建、更新、删除 | data/security/project 数据/安全/项目           |
| role 角色                | create,update,delete 创建、更新、删除 | data/security/role 数据/安全/角色              |
| domain 域                | create,update,delete 创建、更新、删除 | data/security/domain 数据/安全/域              |
| user 用户                | create,update,delete 创建、更新、删除 | data/security/account/user 数据/安全/帐户/用户 |
| trust 信任               | create,delete 创建，删除              | data/security/trust 数据/安全/信任             |
| region 地区              | create,update,delete 创建、更新、删除 | data/security/region 数据/安全/区域            |
| endpoint 端点            | create,update,delete 创建、更新、删除 | data/security/endpoint 数据/安全/端点          |
| service 服务             | create,update,delete 创建、更新、删除 | data/security/service 数据/安全/服务           |
| policy 政策              | create,update,delete 创建、更新、删除 | data/security/policy 数据/安全/策略            |
| role assignment 角色分配 | add,remove 添加，删除                 | data/security/account/user 数据/安全/帐户/用户 |
| None 没有                | authenticate 证实                     | data/security/account/user 数据/安全/帐户/用户 |

### Example Notification - Project Create[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#example-notification-project-create) 通知示例 - 项目创建 ¶

The following is an example of a notification that is sent when a project is created. This example can be applied for any `create`, `update` or `delete` event that is seen in the table above. The `<action>` and `typeURI` fields will be change.
以下是创建项目时发送的通知示例。此示例可应用于上表中显示的任何 `create` 或 `update` `delete` 事件。 `<action>` 和 `typeURI` 字段将更改。

The difference to note is the inclusion of the `resource_info` field which contains the `<resource_id>` that is undergoing the operation. Thus creating a common element between the CADF and Basic notification formats.
需要注意的区别是包含包含 `<resource_id>` 正在进行操作的 `resource_info` 字段。从而在 CADF 和 Basic 通知格式之间创建一个公共元素。

```
{
    "event_type": "identity.project.created",
    "message_id": "0156ee79-b35f-4cef-ac37-d4a85f231c69",
    "payload": {
        "typeURI": "http://schemas.dmtf.org/cloud/audit/1.0/event",
        "initiator": {
            "typeURI": "service/security/account/user",
            "host": {
                "agent": "curl/7.22.0(x86_64-pc-linux-gnu)",
                "address": "127.0.0.1"
            },
            "id": "c9f76d3c31e142af9291de2935bde98a"
        },
        "target": {
            "typeURI": "data/security/project",
            "id": "openstack:1c2fc591-facb-4479-a327-520dade1ea15"
        },
        "observer": {
            "typeURI": "service/security",
            "id": "openstack:3d4a50a9-2b59-438b-bf19-c231f9c7625a"
        },
        "eventType": "activity",
        "eventTime": "2014-02-14T01:20:47.932842+00:00",
        "action": "created.project",
        "outcome": "success",
        "id": "openstack:f5352d7b-bee6-4c22-8213-450e7b646e9f",
        "resource_info": "671da331c47d4e29bb6ea1d270154ec3"
    },
    "priority": "INFO",
    "publisher_id": "identity.host1234",
    "timestamp": "2013-08-29 19:03:45.960280"
}
```

### Example Notification - Authentication[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#example-notification-authentication) 通知示例 - 身份验证 ¶

The following is an example of a notification that is sent when a user authenticates with Keystone.
以下是用户使用 Keystone 进行身份验证时发送的通知示例。

Note that this notification will be emitted if a user successfully authenticates, and when a user fails to authenticate.
请注意，如果用户成功进行身份验证，并且用户无法进行身份验证，则会发出此通知。

```
{
    "event_type": "identity.authenticate",
    "message_id": "1371a590-d5fd-448f-b3bb-a14dead6f4cb",
    "payload": {
        "typeURI": "http://schemas.dmtf.org/cloud/audit/1.0/event",
        "initiator": {
            "typeURI": "service/security/account/user",
            "host": {
                "agent": "curl/7.22.0(x86_64-pc-linux-gnu)",
                "address": "127.0.0.1"
            },
            "id": "c9f76d3c31e142af9291de2935bde98a"
        },
        "target": {
            "typeURI": "service/security/account/user",
            "id": "openstack:1c2fc591-facb-4479-a327-520dade1ea15"
        },
        "observer": {
            "typeURI": "service/security",
            "id": "openstack:3d4a50a9-2b59-438b-bf19-c231f9c7625a"
        },
        "eventType": "activity",
        "eventTime": "2014-02-14T01:20:47.932842+00:00",
        "action": "authenticate",
        "outcome": "success",
        "id": "openstack:f5352d7b-bee6-4c22-8213-450e7b646e9f"
    },
    "priority": "INFO",
    "publisher_id": "identity.host1234",
    "timestamp": "2014-02-14T01:20:47.932842"
}
```

### Example Notification - Federated Authentication[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#example-notification-federated-authentication) 通知示例 - 联合身份验证 ¶

The following is an example of a notification that is sent when a user authenticates with Keystone via Federation.
以下是用户通过联合身份验证向 Keystone 进行身份验证时发送的通知示例。

This example is similar to the one seen above, however the `initiator` portion of the `payload` contains a new `credential` section.
此示例与上面看到的示例类似，但 `initiator` 的部分 `payload` 包含一个新 `credential` 部分。

```
{
    "event_type": "identity.authenticate",
    "message_id": "1371a590-d5fd-448f-b3bb-a14dead6f4cb",
    "payload": {
        "typeURI": "http://schemas.dmtf.org/cloud/audit/1.0/event",
        "initiator": {
            "credential": {
                "type": "http://docs.oasis-open.org/security/saml/v2.0",
                "token": "671da331c47d4e29bb6ea1d270154ec3",
                "identity_provider": "ACME",
                "user": "c9f76d3c31e142af9291de2935bde98a",
                "groups": [
                    "developers"
                ]
            },
            "typeURI": "service/security/account/user",
            "host": {
                "agent": "curl/7.22.0(x86_64-pc-linux-gnu)",
                "address": "127.0.0.1"
            },
            "id": "c9f76d3c31e142af9291de2935bde98a"
        },
        "target": {
            "typeURI": "service/security/account/user",
            "id": "openstack:1c2fc591-facb-4479-a327-520dade1ea15"
        },
        "observer": {
            "typeURI": "service/security",
            "id": "openstack:3d4a50a9-2b59-438b-bf19-c231f9c7625a"
        },
        "eventType": "activity",
        "eventTime": "2014-02-14T01:20:47.932842+00:00",
        "action": "authenticate",
        "outcome": "success",
        "id": "openstack:f5352d7b-bee6-4c22-8213-450e7b646e9f"
    },
    "priority": "INFO",
    "publisher_id": "identity.host1234",
    "timestamp": "2014-02-14T01:20:47.932842"
}
```

### Example Notification - Role Assignment[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#example-notification-role-assignment) 示例通知 - 角色分配 ¶

The following is an example of a notification that is sent when a role is granted or revoked to a project or domain, for a user or group.
以下是为用户或组向项目或域授予或撤消角色时发送的通知示例。

It is important to note that this type of notification has many new keys that convey the necessary information. Expect the following in the `payload`: `role`, `inherited_to_project`, `project` or `domain`, `user` or `group`. With the exception of `inherited_to_project`, each will represent the unique identifier of the resource type.
请务必注意，这种类型的通知具有许多传达必要信息的新键。在 `payload` ： `role` 、 `inherited_to_project` 、 `project` 或 `domain` `user` 中应包含以下内容 `group` 。除 `inherited_to_project` 外，每个都将表示资源类型的唯一标识符。

```
{
    "event_type": "identity.role_assignment.created",
    "message_id": "a5901371-d5fd-b3bb-448f-a14dead6f4cb",
    "payload": {
        "typeURI": "http://schemas.dmtf.org/cloud/audit/1.0/event",
        "initiator": {
            "typeURI": "service/security/account/user",
            "host": {
                "agent": "curl/7.22.0(x86_64-pc-linux-gnu)",
                "address": "127.0.0.1"
            },
            "id": "c9f76d3c31e142af9291de2935bde98a"
        },
        "target": {
            "typeURI": "service/security/account/user",
            "id": "openstack:1c2fc591-facb-4479-a327-520dade1ea15"
        },
        "observer": {
            "typeURI": "service/security",
            "id": "openstack:3d4a50a9-2b59-438b-bf19-c231f9c7625a"
        },
        "eventType": "activity",
        "eventTime": "2014-08-20T01:20:47.932842+00:00",
        "role": "0e6b990380154a2599ce6b6e91548a68",
        "project": "24bdcff1aab8474895dbaac509793de1",
        "inherited_to_projects": false,
        "group": "c1e22dc67cbd469ea0e33bf428fe597a",
        "action": "created.role_assignment",
        "outcome": "success",
        "id": "openstack:f5352d7b-bee6-4c22-8213-450e7b646e9f"
    },
    "priority": "INFO",
    "publisher_id": "identity.host1234",
    "timestamp": "2014-08-20T01:20:47.932842"
}
```

### Example Notification - Expired Password[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#example-notification-expired-password) 通知示例 - 密码过期 ¶

The following is an example of a notification that is sent when a user attempts to authenticate but their password has expired.
以下是当用户尝试进行身份验证但密码已过期时发送的通知示例。

In this example, the `payload` contains a `reason` portion which contains both a `reasonCode` and `reasonType`.
在此示例中，包含 `payload` 同时 `reason` 包含 a `reasonCode` 和 `reasonType` .

```
{
    "priority": "INFO",
    "_unique_id": "222441bdc958423d8af6f28f9c558614",
    "event_type": "identity.authenticate",
    "timestamp": "2016-11-11 18:31:11.290821",
    "publisher_id": "identity.host1234",
    "payload": {
        "typeURI": "http://schemas.dmtf.org/cloud/audit/1.0/event",
        "initiator": {
            "typeURI": "service/security/account/user",
            "host": {
                "address": "127.0.0.1"
            },
            "id": "73a19db6-e26b-5313-a6df-58d297fa652e"
        },
        "target": {
            "typeURI": "service/security/account/user",
            "id": "c23e6cb7-abe0-5e42-b7f7-4c4104ea77b0"
        },
        "observer": {
            "typeURI": "service/security",
            "id": "9bdddeda6a0b451e9e0439646e532afd"
        },
        "eventType": "activity",
        "eventTime": "2016-11-11T18:31:11.156356+0000",
        "reason": {
            "reasonCode": 401,
            "reasonType": "The password is expired and needs to be reset for user: ed1ab0b40f284fb48fea9e25d0d157fc"
        },
        "action": "authenticate",
        "outcome": "failure",
        "id": "78cd795f-5850-532f-9ab1-5adb04e30c0f"
    },
    "message_id": "9a97e9d0-fef1-4852-8e82-bb693358bc46"
}
```

## Basic Notifications[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#basic-notifications) 基本通知 ¶

All basic notifications contain a limited amount of information, specifically, just the resource type, operation, and resource id.
所有基本通知都包含有限数量的信息，具体而言，仅包含资源类型、操作和资源 ID。

The `payload` portion of a Basic Notification is a single key-value pair.
基本通知 `payload` 的部分是单个键值对。

```
{
    "resource_info": <resource_id>
}
```

Where `<resource_id>` is the unique identifier assigned to the `resource_type` that is undergoing the `<operation>`.
其中 `<resource_id>` 分配给正在经历 `<operation>` 的唯一标识符 `resource_type` 。

### Supported Events[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#id1) 支持的事件 ¶

The following table displays the compatibility between resource types and operations.
下表显示了资源类型和操作之间的兼容性。

| Resource Type 资源类型 | Supported Operations 支持的操作       |
| ---------------------- | ------------------------------------- |
| group 群               | create,update,delete 创建、更新、删除 |
| project 项目           | create,update,delete 创建、更新、删除 |
| role 角色              | create,update,delete 创建、更新、删除 |
| domain 域              | create,update,delete 创建、更新、删除 |
| user 用户              | create,update,delete 创建、更新、删除 |
| trust 信任             | create,delete 创建，删除              |
| region 地区            | create,update,delete 创建、更新、删除 |
| endpoint 端点          | create,update,delete 创建、更新、删除 |
| service 服务           | create,update,delete 创建、更新、删除 |
| policy 政策            | create,update,delete 创建、更新、删除 |

Note, `trusts` are an immutable resource, they do not support `update` operations.
请注意， `trusts` 它们是不可变的资源，它们不支持 `update` 操作。

### Example Notification[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#example-notification) 通知示例 ¶

This is an example of a notification sent for a newly created user:
以下是为新创建的用户发送的通知示例：

```
{
    "event_type": "identity.user.created",
    "message_id": "0156ee79-b35f-4cef-ac37-d4a85f231c69",
    "payload": {
        "resource_info": "671da331c47d4e29bb6ea1d270154ec3"
    },
    "priority": "INFO",
    "publisher_id": "identity.host1234",
    "timestamp": "2013-08-29 19:03:45.960280"
}
```

If the operation fails, the notification won’t be sent, and no special error notification will be sent. Information about the error is handled through normal exception paths.
如果操作失败，则不会发送通知，也不会发送任何特殊错误通知。有关错误的信息通过正常的异常路径进行处理。

## Recommendations for consumers[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#recommendations-for-consumers) 给消费者的建议 ¶

One of the most important notifications that Keystone emits is for project deletions (`event_type` = `identity.project.deleted`). This event should indicate to the rest of OpenStack that all resources (such as virtual machines) associated with the project should be deleted.
Keystone 发出的最重要的通知之一是项目删除 （ `event_type` = `identity.project.deleted` ）。此事件应向 OpenStack 的其余部分指示应删除与项目关联的所有资源（例如虚拟机）。

Projects can also have update events (`event_type` = `identity.project.updated`), wherein the project has been disabled. Keystone ensures this has an immediate impact on the accessibility of the project’s resources by revoking tokens with authorization on the project, but should **not** have a direct impact on the projects resources (in other words, virtual machines should **not** be deleted).
项目也可以有更新事件 （ `event_type` = `identity.project.updated` ），其中项目已被禁用。Keystone 通过撤销具有项目授权的令牌来确保这对项目资源的可访问性产生直接影响，但不应对项目资源产生直接影响（换句话说，不应删除虚拟机）。

## Opting out of certain notifications[¶](https://docs.openstack.org/keystone/yoga/admin/event_notifications.html#opting-out-of-certain-notifications) 选择退出某些通知 ¶

There are many notifications that Keystone emits and some deployers may only care about certain events. In Keystone there is a way to opt-out of certain notifications. In `/etc/keystone/keystone.conf` you can set `opt_out` to the event you wish to opt-out of. It is possible to opt-out of multiple events.
Keystone 会发出许多通知，一些部署人员可能只关心某些事件。在 Keystone 中，有一种方法可以选择退出某些通知。在您可以 `/etc/keystone/keystone.conf` 设置为 `opt_out` 您希望选择退出的事件。可以选择退出多个活动。

Example: 例：

```
[DEFAULT]
notification_opt_out = identity.user.created
notification_opt_out = identity.role_assignment.created
notification_opt_out = identity.authenticate.pending
```

This will opt-out notifications for user creation, role assignment creation and successful authentications. For a list of event types that can be used, refer to: [Telemetry Measurements](https://docs.openstack.org/ceilometer/latest/admin/telemetry-measurements.html#openstack-identity).
这将选择退出有关用户创建、角色分配创建和成功身份验证的通知。有关可以使用的事件类型的列表，请参阅：遥测测量。

By default, messages for the following authentication events are suppressed since they are too noisy: `identity.authenticate.success`, `identity.authenticate.pending` and `identity.authenticate.failed`.
默认情况下，以下身份验证事件的消息将被禁止显示， `identity.authenticate.success` 因为它们太嘈杂：、 和 `identity.authenticate.pending` `identity.authenticate.failed` 。



# Multi-Factor Authentication 多重身份验证

​                                          



## Configuring MFA[¶](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#configuring-mfa) 配置 MFA ¶

MFA is configured on a per user basis via the user options [multi_factor_auth_rules](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#multi-factor-auth-rules) and [multi_factor_auth_enabled](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#multi-factor-auth-enabled). Until these are set the user can authenticate with any one of the enabled auth methods.
MFA 通过用户选项 multi_factor_auth_rules 和 multi_factor_auth_enabled 按用户进行配置。在设置这些之前，用户可以使用任何一种已启用的身份验证方法进行身份验证。

### MFA rules[¶](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#mfa-rules) MFA 规则 ¶

The MFA rules allow an admin to force a user to use specific forms of authentication or combinations of forms of authentication to get a token.
MFA 规则允许管理员强制用户使用特定形式的身份验证或身份验证形式的组合来获取令牌。

The rules are specified as follows via the user option [multi_factor_auth_rules](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#multi-factor-auth-rules):
通过用户选项指定规则如下multi_factor_auth_rules：

```
[["password", "totp"], ["password", "custom-auth-method"]]
```

They are a list of lists. The elements of the sub-lists must be strings and are intended to mirror the required authentication method names (e.g. `password`, `totp`, etc) as defined in the `keystone.conf` file in the `[auth] methods` option. Each list of methods specifies a rule.
它们是列表列表。子列表的元素必须是字符串，并且旨在镜像选项中的 `keystone.conf` 文件中定义的所需的身份验证方法名称（例如 `password` 、 `totp` `[auth] methods` 等）。每个方法列表都指定一个规则。

If the auth methods provided by a user match (or exceed) the auth methods in the list, that rule is used. The first rule found (rules will not be processed in a specific order) that matches will be used. If a user has the ruleset defined as `[["password", "totp"]]` the user must provide both password and totp auth methods (and both methods must succeed) to receive a token. However, if a user has a ruleset defined as `[["password"], ["password", "totp"]]` the user may use the `password` method on it’s own but would be required to use both `password` and `totp` if `totp` is specified at all.
如果用户提供的身份验证方法与列表中的身份验证方法匹配（或超过），则使用该规则。找到的第一个规则（规则不会按特定顺序处理）将使用匹配项。如果用户已将规则集定义为 `[["password", "totp"]]` ，则用户必须同时提供密码和 totp 身份验证方法（并且这两种方法都必须成功）才能接收令牌。但是，如果用户定义了规则集，则 `[["password"], ["password", "totp"]]` 用户可以自行使用该 `password` 方法，但需要同时使用这两个 `password` 方法，并且 `totp`  `totp` 如果完全指定了规则集。

Any auth methods that are not defined in `keystone.conf` in the `[auth] methods` option are ignored when the rules are processed. Empty rules are not allowed. If a rule is empty due to no-valid auth methods existing within it, the rule is discarded at authentication time. If there are no rules or no valid rules for the user, authentication occurs in the default manner: any single configured auth method is sufficient to receive a token.
处理规则时，将忽略选项 `keystone.conf` 中 `[auth] methods` 未定义的任何身份验证方法。不允许使用空规则。如果规则由于其中存在无效的身份验证方法而为空，则在身份验证时将丢弃该规则。如果用户没有规则或没有有效规则，则以默认方式进行身份验证：任何单个配置的身份验证方法都足以接收令牌。



 

Note 注意



The `token` auth method typically should not be specified in any MFA Rules. The `token` auth method will include all previous auth methods for the original auth request and will match the appropriate ruleset. This is intentional, as the `token` method is used for rescoping/changing active projects.
 `token` 通常不应在任何 MFA 规则中指定身份验证方法。 `token` auth 方法将包括原始身份验证请求的所有先前身份验证方法，并将与相应的规则集匹配。这是有意为之的，因为该 `token` 方法用于重新调整/更改活动项目。

### Enabling MFA[¶](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#enabling-mfa) 启用 MFA ¶

Before the MFA rules take effect on a user, MFA has to be enabled for that user via the user option [multi_factor_auth_enabled](https://docs.openstack.org/keystone/yoga/admin/resource-options.html#multi-factor-auth-enabled). By default this is unset, and the rules will not take effect until configured.
在 MFA 规则对用户生效之前，必须通过用户选项multi_factor_auth_enabled为该用户启用 MFA。默认情况下，此项处于未设置状态，规则在配置之前不会生效。

In the case a user should be exempt from MFA Rules, regardless if they are set, the User-Option may be set to `False`.
如果用户应免于 MFA 规则，则无论是否设置了这些规则，User-Option 都可以设置为 `False` 。

## Using MFA[¶](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#using-mfa) 使用 MFA ¶

See [Multi-Factor Authentication](https://docs.openstack.org/keystone/yoga/user/multi-factor-authentication.html#multi-factor-authentication-user-guide) in the user guide for some examples.
有关一些示例，请参阅用户指南中的多重身份验证。

## Supported multi-factor authentication methods[¶](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#supported-multi-factor-authentication-methods) 支持的多因素身份验证方法 ¶

TOTP is the only suggested second factor along with password for now, but there are plans to include more in future.
TOTP 是目前唯一建议的第二个因素，但计划在未来包含更多因素。

### TOTP[¶](https://docs.openstack.org/keystone/yoga/admin/multi-factor-authentication.html#totp) TOTP （英语） ¶

This is a simple 6 digit passcode generated by both the server and client from a known shared secret.
这是服务器和客户端从已知共享密钥生成的简单 6 位密码。

This used in a multi-step fashion is the most common 2-factor method used these days.
这是目前最常用的 2 因素方法。

See: [Time-based One-time Password (TOTP)](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#auth-totp)
请参阅：基于时间的一次性密码 （TOTP）

# Time-based One-time Password (TOTP) 基于时间的一次性密码 （TOTP）

​                                          



## Configuring TOTP[¶](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#configuring-totp) 配置 TOTP ¶

TOTP is not enabled in Keystone by default.  To enable it add the `totp` authentication method to the `[auth]` section in `keystone.conf`:
默认情况下，Keystone 中未启用 TOTP。要启用它， `totp` 请将身份验证方法添加到以下 `[auth]` `keystone.conf` 部分：

```
[auth]
methods = external,password,token,oauth1,totp
```

For a user to have access to TOTP, he must have configured TOTP credentials in Keystone and a TOTP device (i.e. [Google Authenticator](http://www.google.com/2step)).
要使用户能够访问 TOTP，他必须在 Keystone 和 TOTP 设备（即 Google 身份验证器）中配置了 TOTP 凭据。

TOTP uses a base32 encoded string for the secret. The secret must be at least 128 bits (16 bytes). The following python code can be used to generate a TOTP secret:
TOTP 对密钥使用 base32 编码的字符串。密钥必须至少为 128 位（16 个字节）。以下 python 代码可用于生成 TOTP 密钥：

```
import base64
message = '1234567890123456'
print base64.b32encode(message).rstrip('=')
```

Example output: 输出示例：

```
GEZDGNBVGY3TQOJQGEZDGNBVGY
```

This generated secret can then be used to add new ‘totp’ credentials to a specific user.
然后，此生成的密钥可用于向特定用户添加新的“totp”凭据。

### Create a TOTP credential[¶](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#create-a-totp-credential) 创建 TOTP 凭证 ¶

Create `totp` credentials for user:
为用户创建 `totp` 凭据：

```
USER_ID=b7793000f8d84c79af4e215e9da78654
SECRET=GEZDGNBVGY3TQOJQGEZDGNBVGY

curl -i \
  -H "Content-Type: application/json" \
  -d '
{
    "credential": {
        "blob": "'$SECRET'",
        "type": "totp",
        "user_id": "'$USER_ID'"
    }
}' \
  http://localhost:5000/v3/credentials ; echo
```

### Google Authenticator[¶](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#id1) 谷歌身份验证器 ¶

On a device install Google Authenticator and inside the app click on ‘Set up account’ and then click on ‘Enter provided key’.  In the input fields enter account name and secret.  Optionally a QR code can be generated programmatically to avoid having to type the information.
在设备上安装 Google Authenticator，然后在应用程序内单击“设置帐户”，然后单击“输入提供的密钥”。在输入字段中，输入帐户名称和密码。（可选）可以通过编程方式生成 QR 码，以避免输入信息。

### QR code[¶](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#qr-code) 二维码 ¶

Create TOTP QR code for device:
为设备创建 TOTP 二维码：

```
import qrcode

secret='GEZDGNBVGY3TQOJQGEZDGNBVGY'
uri = 'otpauth://totp/{name}?secret={secret}&issuer={issuer}'.format(
    name='name',
    secret=secret,
    issuer='Keystone')

img = qrcode.make(uri)
img.save('totp.png')
```

In Google Authenticator app click on ‘Set up account’ and then click on ‘Scan a barcode’, and then scan the ‘totp.png’ image.  This should create a new TOTP entry in the application.
在Google Authenticator应用程序中，单击“设置帐户”，然后单击“扫描条形码”，然后扫描“totp.png”图像。这应该在应用程序中创建一个新的 TOTP 条目。

## Authenticate with TOTP[¶](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#authenticate-with-totp) 使用 TOTP 进行身份验证 ¶

Google Authenticator will generate a 6 digit PIN (passcode) every few seconds. Use the passcode and your user ID to authenticate using the `totp` method.
Google 身份验证器将每隔几秒钟生成一个 6 位数的 PIN（密码）。使用密码和您的用户 ID 通过该 `totp` 方法进行身份验证。

### Tokens[¶](https://docs.openstack.org/keystone/yoga/admin/auth-totp.html#tokens) 代币 ¶

Get a token with default scope (may be unscoped) using totp:
使用 totp 获取具有默认范围（可能未限定范围）的令牌：

```
USER_ID=b7793000f8d84c79af4e215e9da78654
PASSCODE=012345

curl -i \
  -H "Content-Type: application/json" \
  -d '
{ "auth": {
        "identity": {
            "methods": [
                "totp"
            ],
            "totp": {
                "user": {
                    "id": "'$USER_ID'",
                    "passcode": "'$PASSCODE'"
                }
            }
        }
    }
}' \
  http://localhost:5000/v3/auth/tokens ; echo
```

​                      

# Introduction to Keystone Federation Keystone Federation 简介

​                                          



## What is keystone federation?[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#what-is-keystone-federation) 什么是基石联盟？¶

Identity federation is the ability to share identity information across multiple identity management systems. In keystone, this is implemented as an authentication method that allows users to authenticate directly with another identity source and then provides keystone with a set of user attributes. This is useful if your organization already has a primary identity source since it means users don’t need a separate set of credentials for the cloud. It is also useful for connecting multiple clouds together, as we can use a keystone in another cloud as an identity source. Using [LDAP as an identity backend](https://docs.openstack.org/keystone/yoga/admin/configuration.html#integrate-with-ldap) is another way for keystone to obtain identity information from an external source, but it requires keystone to handle passwords directly rather than offloading authentication to the external source.
联合身份验证是在多个身份管理系统之间共享身份信息的能力。在 keystone 中，这是作为身份验证方法实现的，它允许用户直接使用另一个身份源进行身份验证，然后为 keystone  提供一组用户属性。如果您的组织已经具有主要标识源，这将非常有用，因为这意味着用户不需要为云设置一组单独的凭据。它对于将多个云连接在一起也很有用，因为我们可以使用另一个云中的基石作为身份源。使用 LDAP 作为身份后端是 keystone 从外部源获取身份信息的另一种方式，但它需要 keystone  直接处理密码，而不是将身份验证卸载到外部源。

Keystone supports two configuration models for federated identity. The most common configuration is with [keystone as a Service Provider (SP)](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-sp), using an external Identity Provider, such as a Keycloak or Google, as the identity source and authentication method. The second type of configuration is “[Keystone to Keystone](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-idp)”, where two keystones are linked with one acting as the identity source.
Keystone 支持联合身份的两种配置模型。最常见的配置是将 keystone 作为服务提供商 （SP），使用外部身份提供商（如 Keycloak 或  Google）作为身份源和身份验证方法。第二种类型的配置是“Keystone to Keystone”，其中两个 Keystone  链接，其中一个作为标识源。

This document discusses identity federation involving a secondary identity management that acts as the source of truth concerning the users it contains, specifically covering the SAML2.0 and OpenID Connect protocols, although keystone can work with other protocols. A similar concept is [external authentication](https://docs.openstack.org/keystone/yoga/admin/external-authentication.html) whereby keystone is still the source of truth about its users but authentication is handled externally. Yet another closely related topic is [tokenless authentication](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html) which uses some of the same constructs as described here but allows services to validate users without using keystone tokens.
本文档讨论涉及辅助身份管理的身份联合，该身份管理充当有关其所包含用户的事实来源，特别涵盖 SAML2.0 和 OpenID Connect 协议，尽管 keystone 可以与其他协议一起使用。一个类似的概念是外部身份验证，其中  keystone  仍然是有关其用户的真实来源，但身份验证是在外部处理的。另一个密切相关的主题是无令牌身份验证，它使用一些与此处描述的相同的结构，但允许服务在不使用基石令牌的情况下验证用户。

## Glossary[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#glossary) 术语表 ¶

- **Service Provider (SP) 服务提供商 （SP）**

  A Service Provider is the service providing the resource an end-user is requesting. In our case, this is keystone, which provides keystone tokens that we use on other OpenStack services. We do NOT call the other OpenStack services “service providers”. The specific service we care about in this context is the token service, so that is our Service Provider. 服务提供商是提供最终用户请求的资源的服务。在我们的例子中，这是keystone，它提供了我们在其他OpenStack服务上使用的keystone令牌。我们不称其他OpenStack服务为“服务提供商”。在这种情况下，我们关心的具体服务是令牌服务，因此这是我们的服务提供商。

- **Identity Provider (IdP) 身份提供商 （IdP）**

  An Identity Provider is the service that accepts credentials, validates them, and generates a yay/nay response. It returns this response along with some other attributes about the user, such as their username, their display name, and whatever other details it stores and you’ve configured your Service Provider to accept. 身份提供程序是接受凭据、验证凭据并生成 yesy/nay 响应的服务。它返回此响应以及有关用户的其他一些属性，例如用户名、显示名称以及它存储的任何其他详细信息，并且您已将服务提供商配置为接受。

- **Entity ID or Remote ID 实体 ID 或远程 ID**

  An Entity ID or a Remote ID are both names for a unique identifier string for either a Service Provider or an Identity Provider. It usually takes the form of a URN, but the URN does not need to be a resolvable URL. Remote IDs are globally unique. Two Identity Providers cannot be associated with the same remote ID. Keystone uses the remote ID retrieved from the HTTPD environment variables to match the incoming request with a trusted Identity Provider and render the appropriate authorization mapping. 实体 ID 或远程 ID 都是服务提供商或身份提供商的唯一标识符字符串的名称。它通常采用 URN 的形式，但 URN 不需要是可解析的 URL。远程 ID 是全局唯一的。两个身份提供程序不能与同一个远程 ID 关联。Keystone 使用从 HTTPD 环境变量中检索到的远程 ID  将传入请求与受信任的身份提供程序进行匹配，并呈现适当的授权映射。

- **SAML2.0**

  [SAML2.0](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html) is an XML-based federation protocol. It is commonly used in internal-facing organizations, such as a university or business in which IT services are provided to members of the organization. SAML2.0 是一种基于 XML 的联合协议。它通常用于面向内部的组织，例如向组织成员提供 IT 服务的大学或企业。

- **OpenID Connect (OpenIDC) OpenID 连接 （OpenIDC）**

  [OpenID Connect](https://openid.net/connect/) is a JSON-based federation protocol built on OAuth 2.0. It’s used more often by public-facing services like Google. OpenID Connect 是基于 OAuth 2.0 构建的基于 JSON 的联合协议。它更常被 Google 等面向公众的服务使用。

- **Assertion 断言**

  An assertion is a formatted statement from the Identity Provider that asserts that a user is authenticated and provides some attributes about the user. The Identity Provider always signs the assertion and typically encrypts it as well. 断言是来自身份提供程序的格式化语句，用于断言用户已通过身份验证，并提供有关用户的一些属性。身份提供程序始终对断言进行签名，并且通常也会对其进行加密。

- **Single Sign-On (SSO) 单点登录 （SSO）**

  [Single Sign-On](https://en.wikipedia.org/wiki/Single_sign-on) is a mechanism related to identity federation whereby a user may log in to their identity management system and be granted a token or ticket that allows them access to multiple Service Providers. 单点登录是一种与联合身份验证相关的机制，用户可以通过该机制登录其身份管理系统并获得令牌或票证，以允许他们访问多个服务提供商。

## Authentication Flows[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#authentication-flows) 身份验证流程 ¶

Understanding the flow of information as a user moves through the authentication process is key to being able to debug later on.
了解用户在身份验证过程中移动时的信息流是以后能够进行调试的关键。

### Normal keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#normal-keystone) 普通梯形失真 ¶

​                        

User Agent

Keystone

OpenStack

  GET /v3/auth/tokens  Authenticate  Authorize  Scoped token  GET /v2.1/servers

In a normal keystone flow, the user requests a scoped token directly from keystone. Keystone accepts their credentials and checks them against its local storage or against its LDAP backend. Then it checks the scope that the user is requesting, ensuring they have the correct role assignments, and produces a scoped token. The user can use the scoped token to do something else in OpenStack, like request servers, but everything that happens after the token is produced is irrelevant to this discussion.
在正常的 keystone 流中，用户直接从 keystone 请求作用域内的令牌。Keystone 接受其凭据，并根据其本地存储或 LDAP  后端检查它们。然后，它会检查用户请求的范围，确保他们具有正确的角色分配，并生成作用域内的令牌。用户可以使用作用域令牌在 OpenStack  中执行其他操作，例如请求服务器，但生成令牌后发生的所有事情都与此讨论无关。

### SAML2.0[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#id2) SAML2.0 版本 ¶

#### SAML2.0 WebSSO[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#saml2-0-websso)

​                        

User Agent

Service Provider

Identity Provider

  GET /secure  HTTP 302  Location: https://idp/auth?  SAMLRequest=req  GET /auth?SAMLRequest=req  Authenticate  HTTP 200  SAMLResponse in HTML form  POST /assertionconsumerservice  Validate  HTTP 302; Location: /secure  GET /secure

This diagram shows a standard [WebSSO](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0-cd-02.html#5.1.Web Browser SSO Profile|outline) authentication flow, not one involving keystone. WebSSO is one of a few [SAML2.0 profiles](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0-cd-02.html#5.Major Profiles and Federation Use Cases|outline). It is based on the idea that a web browser will be acting as an intermediary and so the flow involves concepts that a browser can understand and act on, like HTTP redirects and HTML forms.
此图显示了标准的 WebSSO 身份验证流，而不是涉及 keystone 的身份验证流。WebSSO 是为数不多的 SAML2.0  配置文件之一。它基于Web浏览器将充当中介的想法，因此该流程涉及浏览器可以理解和操作的概念，例如HTTP重定向和HTML表单。

First, the user uses their web browser to request some secure resource from the Service Provider. The Service Provider detects that the user isn’t authenticated yet, so it generates a SAML Request which it base64 encodes, and then issues an HTTP redirect to the Identity Provider.
首先，用户使用其 Web 浏览器向服务提供商请求一些安全资源。服务提供商检测到用户尚未经过身份验证，因此它会生成一个 SAML 请求，该请求以 base64 编码，然后向身份提供商发出 HTTP 重定向。

The browser follows the redirect and presents the SAML Request to the Identity Provider. The user is prompted to authenticate, probably by filling out a username and password in a login page. The Identity Provider responds with an HTTP success and generates a SAML Response with an HTML form.
浏览器将遵循重定向，并向身份提供商提供 SAML 请求。系统会提示用户进行身份验证，可能是通过在登录页面中填写用户名和密码。身份提供程序以 HTTP 成功响应，并使用 HTML 表单生成 SAML 响应。

The browser automatically POSTs the form back to the Service Provider, which validates the SAML Response. The Service Provider finally issues another redirect back to the original resource the user had requested.
浏览器会自动将表单发回服务提供商，以验证 SAML 响应。服务提供商最终会再次重定向回用户请求的原始资源。

#### SAML2.0 ECP[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#saml2-0-ecp)

​                        

User Agent

Service Provider

Identity Provider

  GET /secure  HTTP 200  SAML Request  POST /auth  SAML Request  Authenticate  HTTP 200  SAMLResponse in SOAP  POST /responseconsumer  Validate  HTTP 200 /secure

[ECP](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0-cd-02.html#5.2.ECP Profile|outline) is another SAML profile. Generally the flow is similar to the WebSSO flow, but it is designed for a client that natively understands SAML, for example the [keystoneauth](https://docs.openstack.org/keystoneauth/latest/) library (and therefore also the [python-openstackclient](https://docs.openstack.org/python-openstackclient/latest/) CLI tool). ECP is slightly different from the browser-based flow and is not supported by all SAML2.0 IdPs, and so getting WebSSO working does not necessarily mean ECP is working correctly, or vice versa. ECP support must often be turned on explicitly in the Identity Provider.
ECP 是另一个 SAML 配置文件。通常，该流类似于 WebSSO 流，但它是为本机理解 SAML 的客户端设计的，例如 keystoneauth  库（因此也是 python-openstackclient CLI 工具）。ECP 与基于浏览器的流程略有不同，并非所有 SAML2.0 IdP 都支持，因此让 WebSSO 正常工作并不一定意味着 ECP 正常工作，反之亦然。ECP 支持通常必须在标识提供者中显式打开。

#### WebSSO with keystone and horizon[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#websso-with-keystone-and-horizon) 具有 keystone 和 horizon 的 WebSSO ¶

​                        

User Agent

Horizon

HTTPD

Keystone

Identity Provider

  POST /auth/login  HTTP 302  Location:  /v3/auth/OS-FEDERATION  /websso/saml2  GET /v3/auth/OS-FEDERATION/websso/saml2  HTTP 302  Location: https://idp/auth?SAMLRequest=req  GET /auth  Authenticate  HTTP 200  SAMLResponse in HTML form  POST /assertionconsumerservice  Validate  HTTP 302  Location: /v3/auth/OS-FEDERATION/websso/saml2  GET /v3/auth/OS-FEDERATION/websso/saml2  Issue token  HTTP 200  HTML form containing unscoped token  POST /auth/websso  successful login

Keystone is not a web front-end, which means horizon needs to handle some parts of being a Service Provider to implement WebSSO.
Keystone 不是 Web 前端，这意味着 horizon 需要处理作为服务提供商的某些部分来实现 WebSSO。

In the diagram above, horizon is added, and keystone and HTTPD are split out from each other to distinguish which parts each are responsible for, though typically both together are referred to as the Service Provider.
在上图中，添加了 horizon，并且 keystone 和 HTTPD 被彼此拆分出来，以区分各自负责的部分，尽管通常两者一起称为服务提供商。

In this model, the user requests to log in to horizon by selecting a federated authentication method from a dropdown menu. Horizon automatically generates a keystone URL based on the Identity Provider and protocol selected and redirects the browser to keystone. That location is equivalent to the /secure resource in the [SAML2.0 WebSSO](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#saml2-0-websso) diagram. The browser follows the redirect, and the HTTPD module detects that the user isn’t logged in yet and issues another redirect to the Identity Provider with a SAML Request. At this point, the flow is the same as in the normal WebSSO model. The user logs into the Identity Provider, a SAML Response is POSTed back to the Service Provider, where the HTTPD module validates the response and issues a redirect back to the location that horizon had originally requested, which is a special federation auth endpoint. At this point keystone is able to grant an unscoped token, which it hands off as another HTML form. The browser will POST that back to horizon, which triggers the normal login process, picking a project to scope to and getting a scoped token from keystone.
在此模型中，用户通过从下拉菜单中选择联合身份验证方法来请求登录 horizon。Horizon 会根据所选的身份提供程序和协议自动生成 keystone URL，并将浏览器重定向到  keystone。该位置等效于 SAML2.0 WebSSO 关系图中的 /secure 资源。浏览器会跟踪重定向，HTTPD  模块检测到用户尚未登录，并使用 SAML 请求向身份提供商发出另一个重定向。此时，流与普通 WebSSO  模型中的流相同。用户登录到身份提供程序后，SAML 响应将 POST 回服务提供商，其中 HTTPD 模块将验证响应并发出重定向回  Horizon 最初请求的位置，该位置是一个特殊的联合身份验证端点。在这一点上，keystone 能够授予一个无作用域的令牌，它作为另一个  HTML 表单交出。浏览器会将其 POST 回 horizon，从而触发正常的登录过程，选择要确定范围的项目并从 keystone  获取范围令牌。

Note that horizon is acting as a middleman, since it knows the endpoint of the secure resource it requests from keystone.
请注意，horizon 充当中间人，因为它知道它从 keystone 请求的安全资源的端点。

#### Keystone to Keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#keystone-to-keystone) Keystone 到 Keystone ¶

​                        

User Agent

Service Provider

Identity Provider

  POST /v3/auth/tokens  Authenticate  HTTP 201  X-Subject-Token: token  POST /v3/auth/OS-FEDERATION/saml2/ecp  HTTP 201  SAMLResponse in SOAP envelope  POST /PAOS-url  Validate  HTTP 302  GET /v3/OS-FED/.../auth  HTTP 201  X-Subject-Token: unscoped toke  n  POST /v3/auth/tokens  (request scoped token)

When keystone is used as an Identity Provider in a Keystone to Keystone configuration, the auth flow is nonstandard. It is similar to an [IdP-initiated auth flow](http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0-cd-02.html#5.1.4.IdP-Initiated SSO:  POST Binding|outline). In this case, the user goes directly to the Identity Provider first before requesting any resource from the Service Provider. The user will get a token from keystone, then use that to request a SAML Response via ECP. When it gets that response back, it POSTs that to the Service Provider, which will grant a token for it.
当 keystone 在 Keystone 到 Keystone 配置中用作身份提供程序时，身份验证流是非标准的。它类似于 IdP  发起的身份验证流。在这种情况下，用户首先直接访问身份提供程序，然后再从服务提供商请求任何资源。用户将从 keystone  获取令牌，然后使用该令牌通过 ECP 请求 SAML 响应。当它收到该响应时，它会将其 POST 给服务提供商，服务提供商将为它授予令牌。

Notice that the Service Provider has to accept data from the Identity Provider and therefore needs to have a way of trusting it. The Identity Provider, on the other hand, never has to accept data from the Service Provider. There is no back and forth, the user simply completes the auth process on one side and presents the result to the other side.
请注意，服务提供商必须接受来自身份提供商的数据，因此需要有一种信任它的方法。另一方面，身份提供程序永远不必接受来自服务提供商的数据。没有来回，用户只需在一侧完成身份验证过程，并将结果呈现给另一侧。

### OpenID Connect[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#id4) OpenID 连接 ¶

#### OpenID Connect Authentication Flow[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#openid-connect-authentication-flow) OpenID Connect 认证流程 ¶

​                        

User Agent

Service Provider

Identity Provider

  GET /secure  HTTP 302  Location: https://idp/auth?  client_id=XXX&redirect_uri=https://sp/secur  e  GET /auth?client_id=XXX&redirect_uri=https://sp/secure  Authenticate  HTTP 302  Location: https://sp/auth?code=XXX  GET /auth?code=XXX  POST https://idp/token  code=XXX&redirect_uri=https://sp/secure  HTTP 200  {"access_code": "XXX",  "id_token": "XXX"}  HTTP 302; Location: /secure  GET /secure

OpenID Connect is different from any SAML2.0 flow because the negotiation is not handled entirely through the client. The Service Provider must make a request directly to the Identity Provider, which means this flow would not be appropriate if the Service Provider and Identity Provider are in segregated networks.
OpenID Connect 与任何 SAML2.0 流都不同，因为协商不是完全通过客户端处理的。服务提供商必须直接向身份提供商发出请求，这意味着如果服务提供商和身份提供商位于隔离网络中，则此流将不合适。

When the user requests a secure resource from the Service Provider, they are redirected to the Identity Provider to log in. The Identity Provider then redirects the user back to the Service Provider using a known redirect URI and providing an authorization code. The Service Provider must then make a back-channel request directly to the Identity Provider using the provided code, and exchange it for an ID token.
当用户从服务提供商请求安全资源时，他们将被重定向到身份提供商进行登录。然后，身份提供程序使用已知的重定向 URI 将用户重定向回服务提供商，并提供授权代码。然后，服务提供商必须使用提供的代码直接向身份提供商发出反向通道请求，并将其交换为 ID 令牌。

#### OpenID Connect with keystone and horizon[¶](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#openid-connect-with-keystone-and-horizon) OpenID Connect 与 keystone 和 horizon ¶

​                        

User Agent

Horizon

HTTPD

Keystone

Identity Provider

  POST /auth/login  HTTP 302  Location:  /v3/auth/OS-FEDERATION  /websso/saml2  GET /v3/auth/OS-FEDERATION/websso/saml2  HTTP 302  Location:  https://idp/auth?  client_id=XXX&  redirect_uri=https://sp/v3/auth/OS-FEDERATION/websso  GET /auth?client_id=XXX&  redirect_uri=https://sp/v3/auth/OS-FEDERATION/websso  Authenticate  HTTP 302  Location: https://sp/v3/auth/OS-FEDERATION/websso  GET /v3/auth/OS-FEDERATION/websso  POST https://idp/token  code=XXX&  redirect_uri=https://sp/v3/auth/OS-FEDERATION/websso  HTTP 200  {"access_code": "XXX",  "id_token": "XXX"}  HTTP 302  Location: /v3/auth/OS-FEDERATION/websso/mapped  GET /v3/auth/OS-FEDERATION/websso/mapped  Issue token  HTTP 200  HTML form containing unscoped token  POST /auth/websso  successful login

From horizon and keystone’s point of view, the authentication flow is the same for OpenID Connect as it is for SAML2.0. It is only the HTTPD OpenIDC module that must handle the flow in accordance with the spec.
从 horizon 和 keystone 的角度来看，OpenID Connect 的身份验证流程与 SAML2.0 的身份验证流程相同。只有 HTTPD OpenIDC 模块必须按照规范处理流程。

# Configuring Keystone for Federation 配置 Keystone 以进行联合

​                                          



## Keystone as a Service Provider (SP)[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-a-service-provider-sp) Keystone 即服务提供商 （SP） ¶



### Prerequisites[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#prerequisites) 先决条件 ¶

If you are not familiar with the idea of federated identity, see the [Introduction to Keystone Federation](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#federation-introduction) first.
如果您不熟悉联合身份的概念，请先参阅 Keystone Federation 简介。

In this section, we will configure keystone as a Service Provider, consuming identity properties issued by an external Identity Provider, such as SAML assertions or OpenID Connect claims. For testing purposes, we recommend using [samltest.id](https://samltest.id)  as a SAML Identity Provider, or Google as an OpenID Connect Identity Provider, and the examples here will references those providers. If you plan to set up [Keystone as an Identity Provider (IdP)](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-an-identity-provider-idp), it is easiest to set up keystone with a dummy SAML provider first and then reconfigure it to point to the keystone Identity Provider later.
在本节中，我们将 keystone 配置为服务提供商，使用外部身份提供商颁发的身份属性，例如 SAML 断言或 OpenID Connect  声明。出于测试目的，我们建议使用 samltest.id 作为 SAML 身份提供商，或使用 Google 作为 OpenID Connect  身份提供商，此处的示例将引用这些提供商。如果您计划将 Keystone 设置为身份提供商 （IdP），最简单的方法是先使用虚拟 SAML  提供商设置 keystone，然后重新配置它以稍后指向 keystone 身份提供商。

The following configuration steps were performed on a machine running Ubuntu 16.04 and Apache 2.4.18.
以下配置步骤是在运行 Ubuntu 16.04 和 Apache 2.4.18 的计算机上执行的。

To enable federation, you’ll need to run keystone behind a web server such as Apache rather than running the WSGI application directly with uWSGI or Gunicorn. See the installation guide for [SUSE](https://docs.openstack.org/keystone/yoga/install/keystone-install-obs.html#suse-configure-apache), [RedHat](https://docs.openstack.org/keystone/yoga/install/keystone-install-rdo.html#redhat-configure-apache) or [Ubuntu](https://docs.openstack.org/keystone/yoga/install/keystone-install-ubuntu.html#ubuntu-configure-apache) to configure the Apache web server for keystone.
要启用联合，你需要在Web服务器（如Apache）后面运行keystone，而不是直接用uWSGI或Gunicorn运行WSGI应用程序。请参阅 SUSE、RedHat 或 Ubuntu 的安装指南，为 keystone 配置 Apache Web 服务器。

Throughout the rest of the guide, you will need to decide on three pieces of information and use them consistently throughout your configuration:
在本指南的其余部分，您需要确定三条信息，并在整个配置中一致地使用它们：

1. The protocol name. This must be a valid keystone auth method and must match one of: `saml2`, `openid`, `mapped` or a [custom auth method](https://docs.openstack.org/keystone/yoga/contributor/auth-plugins.html#auth-plugins) for which you must [register as an external driver](https://docs.openstack.org/keystone/yoga/contributor/developing-drivers.html#developing-drivers).
   协议名称。这必须是有效的梯形校正身份验证方法，并且必须与以下方法之一匹配： `saml2` 、 `openid` 或 `mapped` 必须注册为外部驱动程序的自定义身份验证方法。
2. The identity provider name. This can be arbitrary.
   标识提供者名称。这可以是任意的。
3. The entity ID of the service provider. This should be a URN but need not resolve to anything.
   服务提供商的实体 ID。这应该是一个 URN，但不需要解析到任何内容。

You will also need to decide what HTTPD module to use as a Service Provider. This guide provides examples for `mod_shib` and `mod_auth_mellon` as SAML service providers, and `mod_auth_openidc` as an OpenID Connect Service Provider.
您还需要决定使用哪个 HTTPD 模块作为服务提供商。本指南提供了 `mod_auth_mellon` 作为 SAML 服务提供商以及 `mod_auth_openidc` 作为 OpenID Connect 服务提供商的 `mod_shib` 示例。



 

Note 注意



In this guide, the keystone Service Provider is configured on a host called sp.keystone.example.org listening on the standard HTTPS port. All keystone paths will start with the keystone version prefix, `/v3`. If you have configured keystone to listen on port 5000, or to respond on the path `/identity` (for example), take this into account in your own configuration.
在本指南中，Keystone Service Provider 配置在名为 sp.keystone.example.org 的主机上侦听标准 HTTPS 端口。所有梯形图路径都将以 keystone 版本前缀 `/v3` .如果您已将 keystone 配置为侦听端口 5000 或响应路径 `/identity` （例如），请在您自己的配置中考虑这一点。

### Creating federation resources in keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#creating-federation-resources-in-keystone) 在 keystone 中创建联合资源 ¶

You need to create three resources via the keystone API to identify the Identity Provider to keystone and align remote user attributes with keystone objects:
您需要通过 keystone API 创建三个资源，以标识标识要对 keystone 的标识提供者，并将远程用户属性与 keystone 对象对齐：

- [Create an Identity Provider
  创建身份提供程序](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-an-identity-provider)
- [Create a Mapping 创建映射](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id1)
- [Create a Protocol 创建协议](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-protocol)

See also the [keystone federation API reference](https://docs.openstack.org/api-ref/identity/v3-ext/#os-federation-api).
另请参阅 keystone 联合身份验证 API 参考。

#### Create an Identity Provider[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-an-identity-provider) 创建身份提供商 ¶

Create an Identity Provider object in keystone, which represents the Identity Provider we will use to authenticate end users:
在 keystone 中创建一个身份提供者对象，该对象表示我们将用于对最终用户进行身份验证的身份提供者：

```
$ openstack identity provider create --remote-id https://samltest.id/saml/idp samltest
```

The value for the `remote-id` option is the unique identifier provided by the Identity Provider, called the entity ID or the remote ID. For a SAML Identity Provider, it can found by querying its metadata endpoint:
该 `remote-id` 选项的值是身份提供程序提供的唯一标识符，称为实体 ID 或远程 ID。对于 SAML 身份提供程序，可以通过查询其元数据终结点来找到它：

```
$ curl -s https://samltest.id/saml/idp | grep -o 'entityID=".*"'
entityID="https://samltest.id/saml/idp"
```

For an OpenID Connect IdP, it is the Identity Provider’s Issuer Identifier. A remote ID must be globally unique: two identity providers cannot be associated with the same remote ID. The remote ID will usually appear as a URN but need not be a resolvable URL.
对于 OpenID Connect IdP，它是身份提供商的颁发者标识符。远程 ID 必须是全局唯一的：两个身份提供程序不能与同一个远程 ID 关联。远程 ID 通常显示为 URN，但不一定是可解析的 URL。

The local name, called `samltest` in our example, is decided by you and will be used by the mapping and protocol, and later for authentication.
在我们的示例中调用 `samltest` 的本地名称由您决定，将由映射和协议使用，稍后将用于身份验证。



 

Note 注意



An identity provider keystone object may have multiple `remote-ids` specified, this allows the same *keystone* identity provider resource to be used with multiple external identity providers. For example, an identity provider resource `university-idp`, may have the following `remote_ids`: `['university-x', 'university-y', 'university-z']`. This removes the need to configure N identity providers in keystone.
一个标识提供者 keystone 对象可以指定多个 `remote-ids` ，这允许将同一 keystone 标识提供者资源与多个外部标识提供者一起使用。例如，身份提供程序资源 `university-idp` 可能具有以下内容 `remote_ids` ： `['university-x', 'university-y', 'university-z']` 。这样就无需在 keystone 中配置 N 个身份提供程序。

See also the [API reference on identity providers](https://docs.openstack.org/api-ref/identity/v3-ext/#identity-providers).
另请参阅有关标识提供者的 API 参考。



#### Create a Mapping[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-mapping) 创建映射 ¶

Next, create a mapping. A mapping is a set of rules that link the attributes of a remote user to user properties that keystone understands. It is especially useful for granting remote users authorization to keystone resources, either by associating them with a local keystone group and inheriting its role assignments, or dynamically provisioning projects within keystone based on these rules.
接下来，创建映射。映射是一组规则，用于将远程用户的属性链接到 keystone 理解的用户属性。它对于授予远程用户对 keystone 资源的授权特别有用，方法是将 keystone 资源与本地  keystone 组关联并继承其角色分配，或者根据这些规则在 keystone 中动态预配项目。



 

Note 注意



By default, group memberships that a user gets from a mapping are only valid for the duration of the token. It is possible to persist these groups memberships for a limited period of time. To enable this, either set the `authorization_ttl` attribute of the identity provider, or the ``[federation] default_authorization_ttl` in the keystone.conf file. This value is in minutes, and will result in a lag from when a user is removed from a group in the identity provider, and when that will happen in keystone. Please consider your security requirements carefully.
默认情况下，用户从映射获取的组成员身份仅在令牌的持续时间内有效。可以在有限的时间内保留这些组成员身份。要启用此功能，请在 keystone.conf 文件中设置 `authorization_ttl` attribute of the identity provider, or the ``[federation] default_authorization_ttl` 。此值以分钟为单位，将导致从身份提供程序中的组中删除用户的时间与在 keystone 中发生此事件的时间之间存在滞后。请仔细考虑您的安全要求。

An Identity Provider has exactly one mapping specified per protocol. Mapping objects can be used multiple times by different combinations of Identity Provider and Protocol.
身份提供程序为每个协议指定了一个映射。映射对象可以通过身份提供程序和协议的不同组合多次使用。

As a simple example, create a mapping with a single rule to map all remote users to a local user in a single group in keystone:
举个简单的例子，创建一个带有单个规则的映射，以将所有远程用户映射到 keystone 中单个组中的本地用户：

```
$ cat > rules.json <<EOF
[
    {
        "local": [
            {
                "user": {
                    "name": "{0}"
                },
                "group": {
                    "domain": {
                        "name": "Default"
                    },
                    "name": "federated_users"
                }
            }
        ],
        "remote": [
            {
                "type": "REMOTE_USER"
            }
        ]
    }
]
EOF
$ openstack mapping create --rules rules.json samltest_mapping
```

This mapping rule evaluates the `REMOTE_USER` variable set by the HTTPD auth module and uses it to fill in the name of the local user in keystone. It also ensures all remote users become effective members of the `federated_users` group, thereby inheriting the group’s role assignments.
此映射规则评估 HTTPD auth 模块设置的 `REMOTE_USER` 变量，并使用它来填充 keystone 中本地用户的名称。它还确保所有远程用户都成为 `federated_users` 组的有效成员，从而继承组的角色分配。

In this example, the `federated_users` group must exist in the keystone Identity backend and must have a role assignment on some project, domain, or system in order for federated users to have an authorization in keystone. For example, to create the group:
在此示例中，该 `federated_users` 组必须存在于 keystone 标识后端中，并且必须在某些项目、域或系统上具有角色分配，以便联合用户在 keystone 中拥有授权。例如，要创建组，请执行以下操作：

```
$ openstack group create federated_users
```

Create a project these users should be assigned to:
创建应将这些用户分配到的项目：

```
$ openstack project create federated_project
```

Assign the group a `member` role in the project:
在项目中为组分配 `member` 角色：

```
$ openstack role add --group federated_users --project federated_project member
```

Mappings can be quite complex. A detailed guide can be found on the [Mapping Combinations](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html) page.
映射可能非常复杂。可以在“映射组合”页面上找到详细指南。

See also the [API reference on mapping rules](https://docs.openstack.org/api-ref/identity/v3-ext/#mappings).
另请参阅有关映射规则的 API 参考。

#### Create a Protocol[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-protocol) 创建协议 ¶

Now create a federation protocol. A federation protocol object links the Identity Provider to a mapping.
现在创建一个联合协议。联合协议对象将身份提供程序链接到映射。

You can create a protocol like this:
您可以创建如下协议：

```
$ openstack federation protocol create saml2 \
--mapping samltest_mapping --identity-provider samltest
```

As mentioned in [Prerequisites](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#sp-prerequisites), the name you give the protocol is not arbitrary, it must be a valid auth method.
如先决条件中所述，您为协议指定的名称不是任意的，它必须是有效的身份验证方法。

See also the [API reference for federation protocols](https://docs.openstack.org/api-ref/identity/v3-ext/#protocols).
另请参阅联合协议的 API 参考。

### Configuring an HTTPD auth module[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-an-httpd-auth-module) 配置 HTTPD 认证模块 ¶

This guide currently only includes examples for the Apache web server, but it possible to use SAML, OpenIDC, and other auth modules in other web servers. See the installation guides for running keystone behind Apache for [SUSE](https://docs.openstack.org/keystone/yoga/install/keystone-install-obs.html#suse-configure-apache), [RedHat](https://docs.openstack.org/keystone/yoga/install/keystone-install-rdo.html#redhat-configure-apache) or [Ubuntu](https://docs.openstack.org/keystone/yoga/install/keystone-install-ubuntu.html#ubuntu-configure-apache).
本指南目前仅包括 Apache Web 服务器的示例，但可以在其他 Web 服务器中使用 SAML、OpenIDC 和其他身份验证模块。请参阅安装指南，了解如何在 Apache for SUSE、RedHat 或 Ubuntu 后面运行 keystone。

#### Configure protected endpoints[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-protected-endpoints) 配置受保护的端点 ¶

There is a minimum of one endpoint that must be protected in the VirtualHost configuration for the keystone service:
在 keystone 服务的 VirtualHost 配置中，至少有一个终结点必须受到保护：

```
<Location /v3/OS-FEDERATION/identity_providers/IDENTITYPROVIDER/protocols/PROTOCOL/auth>
  Require valid-user
  AuthType [...]
  ...
</Location>
```

This is the endpoint for federated users to request an unscoped token.
这是联合身份用户请求无作用域令牌的终结点。

If configuring WebSSO, you should also protect one or both of the following endpoints:
如果配置 WebSSO，还应保护以下一个或两个端点：

```
<Location /v3/auth/OS-FEDERATION/websso/PROTOCOL>
  Require valid-user
  AuthType [...]
  ...
</Location>
<Location /v3/auth/OS-FEDERATION/identity_providers/IDENTITYPROVIDER/protocols/PROTOCOL/websso>
  Require valid-user
  AuthType [...]
  ...
</Location>
```

The first example only specifies a protocol, and keystone will use the incoming remote ID to determine the Identity Provider. The second specifies the Identity Provider directly, which must then be supplied to horizon when configuring [horizon for WebSSO](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-horizon-as-a-websso-frontend).
第一个示例仅指定协议，keystone 将使用传入的远程 ID 来确定身份提供程序。第二个直接指定身份提供程序，然后在为 WebSSO 配置 horizon 时必须将其提供给 horizon。

The path must exactly match the path that will be used to access the keystone service. For example, if the identity provider you created in [Create an Identity Provider](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-an-identity-provider) is `samltest` and the protocol you created in [Create a Protocol](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-protocol) is `saml2`, then the Locations will be:
该路径必须与将用于访问 keystone 服务的路径完全匹配。例如，如果在创建身份提供程序中创建的身份提供程序是 `samltest` ，而在创建协议中创建的协议是 `saml2` ，则位置将为：

```
<Location /v3/OS-FEDERATION/identity_providers/samltest/protocols/saml2/auth>
  Require valid-user
  AuthType [...]
  ...
</Location>
<Location /v3/auth/OS-FEDERATION/websso/saml2>
  Require valid-user
  AuthType [...]
  ...
</Location>
<Location /v3/auth/OS-FEDERATION/identity_providers/samltest/protocols/saml2/websso>
  Require valid-user
  AuthType [...]
  ...
</Location>
```

However, if you have configured the keystone service to use a virtual path such as `/identity`, that part of the path should be included:
但是，如果已将 keystone 服务配置为使用虚拟路径，例如 `/identity` ，则应包含该部分路径：

```
<Location /identity/v3/OS-FEDERATION/identity_providers/samltest/protocols/saml2/auth>
  Require valid-user
  AuthType [...]
  ...
</Location>
...
```

#### Configure the auth module[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-the-auth-module) 配置 auth 模块 ¶

If your Identity Provider is a SAML IdP, there are two main Apache modules that can be used as a SAML Service Provider: mod_shib and mod_auth_mellon. For an OpenID Connect Identity Provider, mod_auth_openidc is used. You can also use other auth modules such as kerberos, X.509, or others. Check the documentation for the provider you choose for detailed installation and configuration guidance.
如果您的身份提供商是 SAML IdP，则有两个主要的 Apache 模块可用作 SAML 服务提供商：mod_shib 和 mod_auth_mellon。对于  OpenID Connect 身份提供程序，将使用 mod_auth_openidc。您还可以使用其他身份验证模块，例如  kerberos、X.509 或其他模块。请查看所选提供商的文档，获取详细的安装和配置指南。

Depending on the Service Provider module you’ve chosen, you will need to install the applicable Apache module package and follow additional configuration steps. This guide contains examples for two major federation protocols:
根据您选择的服务提供商模块，您需要安装适用的 Apache 模块包并执行其他配置步骤。本指南包含两种主要联合协议的示例：

- SAML2.0 - see guides for the following implementations:
  SAML2.0 - 请参阅以下实现指南：
  - [Set up mod_shib](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#shibboleth). 设置mod_shib。
  - [Set up mod_auth_mellon](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#mellon). 设置mod_auth_mellon。
- OpenID Connect: [Set up mod_auth_openidc](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#federation-openidc).
  OpenID Connect：设置mod_auth_openidc。



### Configuring Keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-keystone) 配置 Keystone ¶

While the Apache module does the majority of the heavy lifting, minor changes are needed to allow keystone to allow and understand federated authentication.
虽然 Apache 模块完成了大部分繁重的工作，但需要稍作更改才能允许 keystone 允许和理解联合身份验证。

#### Add the Auth Method[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#add-the-auth-method) 添加 auth 方法 ¶

Add the authentication methods to the `[auth]` section in `keystone.conf`. The auth method here must have the same name as the protocol you created in [Create a Protocol](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-protocol). You should also remove `external` as an allowable method.
将身份验证方法添加到 中 `[auth]` `keystone.conf` 的部分。此处的 auth 方法必须与您在创建协议中创建的协议同名。您还应该删除 `external` 作为允许的方法。

```
[auth]
methods = password,token,saml2,openid
```

#### Configure the Remote ID Attribute[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-the-remote-id-attribute) 配置远程 ID 属性 ¶

Keystone is mostly apathetic about what HTTPD auth module you choose to configure for your Service Provider, but must know what header key to look for from the auth module to determine the Identity Provider’s remote ID so it can associate the incoming request with the Identity Provider resource. The key name is decided by the auth module choice:
Keystone 对于您选择为服务提供商配置的 HTTPD 身份验证模块大多无动于衷，但必须知道要从身份验证模块中查找哪个标头密钥，以确定身份提供商的远程 ID，以便它可以将传入请求与身份提供商资源相关联。密钥名称由 auth 模块选择决定：

- For `mod_shib`: use `Shib-Identity-Provider`
  用于 `mod_shib` ： 使用 `Shib-Identity-Provider` 
- For `mod_auth_mellon`: the attribute name is configured with the `MellonIdP` parameter in the VirtualHost configuration, if set to e.g. `IDP` then use `MELLON_IDP`
  对于 `mod_auth_mellon` ：属性名称使用 VirtualHost 配置中的 `MellonIdP` 参数进行配置，如果设置为例如， `IDP` 则使用 `MELLON_IDP` 
- For `mod_auth_openidc`: the attribute name is related to the `OIDCClaimPrefix` parameter in the Apache configuration, if set to e.g. `OIDC-` use `HTTP_OIDC_ISS`
  For `mod_auth_openidc` ：属性名称与 Apache 配置中的 `OIDCClaimPrefix` 参数相关，如果设置为例如 `OIDC-` use `HTTP_OIDC_ISS` 

It is recommended that this option be set on a per-protocol basis by creating a new section named after the protocol:
建议通过创建以协议命名的新部分来按协议设置此选项：

```
[saml2]
remote_id_attribute = Shib-Identity-Provider
[openid]
remote_id_attribute = HTTP_OIDC_ISS
```

Alternatively, a generic option may be set at the `[federation]` level.
或者，可以在级别 `[federation]` 设置通用选项。

```
[federation]
remote_id_attribute = HTTP_OIDC_ISS
```

#### Add a Trusted Dashboard (WebSSO)[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#add-a-trusted-dashboard-websso) 添加可信仪表板 （WebSSO） ¶

If you intend to configure horizon as a WebSSO frontend, you must specify the URLs of trusted horizon servers. This value may be repeated multiple times. This setting ensures that keystone only sends token data back to trusted servers. This is performed as a precaution, specifically to prevent man-in-the-middle (MITM) attacks. The value must exactly match the origin address sent by the horizon server, including any trailing slashes.
如果要将 horizon 配置为 WebSSO 前端，则必须指定受信任的 horizon Server 的 URL。此值可以重复多次。此设置可确保  keystone 仅将令牌数据发送回受信任的服务器。这是作为预防措施执行的，特别是为了防止中间人 （MITM） 攻击。该值必须与 horizon Server 发送的源地址（包括任何尾部斜杠）完全匹配。

```
[federation]
trusted_dashboard = https://horizon1.example.org/auth/websso/
trusted_dashboard = https://horizon2.example.org/auth/websso/
```

#### Add the Callback Template (WebSSO)[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#add-the-callback-template-websso) 添加回调模板 （WebSSO） ¶

If you intend to configure horizon as a WebSSO frontend,  and if not already done for you by your distribution’s keystone package, copy the [sso_callback_template.html](https://opendev.org/openstack/keystone/raw/branch/master/etc/sso_callback_template.html) template into the location specified by the `[federation]/sso_callback_template` option in `keystone.conf`. You can also use this template as an example to create your own custom HTML redirect page.
如果您打算将 horizon 配置为 WebSSO 前端，并且您的发行版的 keystone 软件包尚未为您完成，请将 sso_callback_template.html 模板复制到 中 `[federation]/sso_callback_template` 选项指定 `keystone.conf` 的位置。您还可以使用此模板作为示例来创建自己的自定义 HTML 重定向页面。

Restart the keystone WSGI service or the Apache frontend service after making changes to your keystone configuration.
在对 keystone 配置进行更改后，重新启动 keystone WSGI 服务或 Apache 前端服务。

```
# systemctl restart apache2
```



### Configuring Horizon as a WebSSO Frontend[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-horizon-as-a-websso-frontend) 将 Horizon 配置为 WebSSO 前端 ¶



 

Note 注意



Consult [horizon’s official documentation](https://docs.openstack.org/horizon/latest/configuration/settings.html) for details on configuring horizon.
有关配置 horizon 的详细信息，请参阅 horizon 的官方文档。

Keystone on its own is not capable of supporting a browser-based Single Sign-on authentication flow such as the SAML2.0 WebSSO profile, therefore we must enlist horizon’s assistance. Horizon can be configured to support SSO by enabling it in horizon’s `local_settings.py` configuration file and adding the possible authentication choices that will be presented to the user on the login screen.
Keystone 本身无法支持基于浏览器的单点登录身份验证流程，例如 SAML2.0 WebSSO 配置文件，因此我们必须寻求 horizon 的帮助。可以通过在 horizon 的 `local_settings.py` 配置文件中启用 Horizon 并添加将在登录屏幕上显示给用户的可能身份验证选项，将 Horizon 配置为支持 SSO。

Ensure the WEBSSO_ENABLED option is set to True in horizon’s local_settings.py file, this will provide users with an updated login screen for horizon.
确保在 horizon 的 local_settings.py 文件中将 WEBSSO_ENABLED 选项设置为 True，这将为用户提供更新的 horizon 登录屏幕。

```
WEBSSO_ENABLED = True
```

Configure the options for authenticating that a user may choose from at the login screen. The pairs configured in this list map a user-friendly string to an authentication option, which may be one of:
配置用户可以在登录屏幕上选择的身份验证选项。此列表中配置的对将用户友好的字符串映射到身份验证选项，该选项可能是以下选项之一：

- The string `credentials` which forces horizon to present its own username and password fields that the user will use to authenticate as a local keystone user
  强制 horizon 显示自己的用户名和密码字段的字符串 `credentials` ，用户将使用这些字段作为本地 Keystone 用户进行身份验证
- The name of a protocol that you created in [Create a Protocol](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-protocol), such as `saml2` or `openid`, which will cause horizon to call keystone’s [WebSSO API without an Identity Provider](https://docs.openstack.org/api-ref/identity/v3-ext/index.html#web-single-sign-on-authentication-new-in-version-1-2) to authenticate the user
  您在创建协议中创建的协议的名称，例如 `saml2` 或 `openid` ，这将导致 horizon 在没有身份提供程序的情况下调用 keystone 的 WebSSO API 来对用户进行身份验证
- A string that maps to an Identity Provider and Protocol combination configured in `WEBSSO_IDP_MAPPING` which will cause horizon to call keystone’s [WebSSO API specific to the given Identity Provider](https://docs.openstack.org/api-ref/identity/v3-ext/index.html#web-single-sign-on-authentication-new-in-version-1-3).
  映射到身份提供程序和协议组合的字符串，其中 `WEBSSO_IDP_MAPPING` 配置的字符串将导致 horizon 调用特定于给定身份提供程序的 keystone WebSSO API。

```
WEBSSO_CHOICES = (
    ("credentials", _("Keystone Credentials")),
    ("openid", _("OpenID Connect")),
    ("saml2", _("Security Assertion Markup Language")),
    ("myidp_openid", "Acme Corporation - OpenID Connect"),
    ("myidp_saml2", "Acme Corporation - SAML2")
)

WEBSSO_IDP_MAPPING = {
    "myidp_openid": ("myidp", "openid"),
    "myidp_saml2": ("myidp", "saml2")
}
```

The initial selection of the dropdown menu can also be configured:
还可以配置下拉菜单的初始选择：

```
WEBSSO_INITIAL_CHOICE = "credentials"
```

Remember to restart the web server when finished configuring horizon:
请记住在完成 horizon 配置后重新启动 Web 服务器：

```
# systemctl restart apache2
```

### Authenticating[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#authenticating) 身份验证 ¶

#### Use the CLI to authenticate with a SAML2.0 Identity Provider[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#use-the-cli-to-authenticate-with-a-saml2-0-identity-provider) 使用 CLI 向 SAML2.0 身份提供商进行身份验证 ¶

The `python-openstackclient` can be used to authenticate a federated user in a SAML Identity Provider to keystone.
可用于 `python-openstackclient` 对 SAML 身份提供程序中的联合用户进行身份验证。



 

Note 注意



The SAML Identity Provider must be configured to support the ECP authentication profile.
SAML 身份提供程序必须配置为支持 ECP 身份验证配置文件。

To use the CLI tool, you must have the name of the Identity Provider resource in keystone, the name of the federation protocol configured in keystone, and the ECP endpoint for the Identity Provider. If you are the cloud administrator, the name of the Identity Provider and protocol was configured in [Create an Identity Provider](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-an-identity-provider) and [Create a Protocol](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-protocol) respectively. If you are not the administrator, you must obtain this information from the administrator.
要使用 CLI 工具，您必须在 keystone 中具有身份提供程序资源的名称、在 keystone 中配置的联合协议的名称以及身份提供程序的 ECP 端点。如果您是云管理员，则身份提供程序和协议的名称分别在创建身份提供程序和创建协议中配置。如果您不是管理员，则必须从管理员处获取此信息。

The ECP endpoint for the Identity Provider can be obtained from its metadata without involving an administrator. This endpoint is the `urn:oasis:names:tc:SAML:2.0:bindings:SOAP` binding in the metadata document:
可以从其元数据中获取身份提供程序的 ECP 端点，而无需管理员参与。此终结点是元数据文档中的 `urn:oasis:names:tc:SAML:2.0:bindings:SOAP` 绑定：

```
$ curl -s https://samltest.id/saml/idp | grep urn:oasis:names:tc:SAML:2.0:bindings:SOAP
     <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP" Location="https://samltest.id/idp/profile/SAML2/SOAP/ECP"/>
```

##### Find available scopes[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#find-available-scopes) 查找可用范围 ¶

If you are a new user and are not aware of what resources you have access to, you can use an unscoped query to list the projects or domains you have been granted a role assignment on:
如果你是新用户，并且不知道你有权访问哪些资源，则可以使用无作用域查询来列出你已被授予角色分配的项目或域：

```
export OS_AUTH_TYPE=v3samlpassword
export OS_IDENTITY_PROVIDER=samltest
export OS_IDENTITY_PROVIDER_URL=https://samltest.id/idp/profile/SAML2/SOAP/ECP
export OS_PROTOCOL=saml2
export OS_USERNAME=morty
export OS_PASSWORD=panic
export OS_AUTH_URL=https://sp.keystone.example.org/v3
export OS_IDENTITY_API_VERSION=3
openstack federation project list
openstack federation domain list
```

##### Get a scoped token[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#get-a-scoped-token) 获取作用域内令牌 ¶

If you already know the project, domain or system you wish to scope to, you can directly request a scoped token:
如果已知道要限定范围的项目、域或系统，则可以直接请求限定范围令牌：

```
export OS_AUTH_TYPE=v3samlpassword
export OS_IDENTITY_PROVIDER=samltest
export OS_IDENTITY_PROVIDER_URL=https://samltest.id/idp/profile/SAML2/SOAP/ECP
export OS_PROTOCOL=saml2
export OS_USERNAME=morty
export OS_PASSWORD=panic
export OS_AUTH_URL=https://sp.keystone.example.org/v3
export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_NAME=federated_project
export OS_PROJECT_DOMAIN_NAME=Default
openstack token issue
```

#### Use horizon to authenticate with an external Identity Provider[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#use-horizon-to-authenticate-with-an-external-identity-provider) 使用 horizon 向外部身份提供程序进行身份验证 ¶

When horizon is configured to enable WebSSO, a dropdown menu will appear on the login screen before the user has authenticated. Select an authentication method from the menu to be redirected to your Identity Provider for authentication.
将 horizon 配置为启用 WebSSO 时，在用户进行身份验证之前，登录屏幕上将显示一个下拉菜单。从菜单中选择一种身份验证方法，将其重定向到您的身份提供商进行身份验证。

[![Horizon login screen using external authentication](https://docs.openstack.org/keystone/yoga/_images/horizon-login-sp.png)](https://docs.openstack.org/keystone/yoga/_images/horizon-login-sp.png)



## Keystone as an Identity Provider (IdP)[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-an-identity-provider-idp) Keystone 作为身份提供商 （IdP） ¶

### Prerequisites[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id2) 先决条件 ¶

When keystone is configured as an Identity Provider, it is often referred to as Keystone to Keystone, because it enables federation between multiple OpenStack clouds using the SAML2.0 protocol.
当 keystone 配置为身份提供商时，它通常被称为 Keystone 到 Keystone，因为它支持使用 SAML2.0 协议在多个 OpenStack 云之间联合。

If you are not familiar with the idea of federated identity, see the [introduction](https://docs.openstack.org/keystone/yoga/admin/federation/introduction.html#federation-introduction) first.
如果您不熟悉联合身份的概念，请先查看简介。

When setting up Keystone to Keystone, it is easiest to [configure a keystone Service Provider](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-sp)  first with a sandbox Identity Provider such as [samltest.id](https://samltest.id).
在将 Keystone 设置为 Keystone 时，最简单的方法是先使用沙盒身份提供程序（如 samltest.id）配置 Keystone 服务提供商。

This feature requires installation of the xmlsec1 tool via your distribution packaging system (for instance apt or yum)
此功能需要通过分发打包系统（例如 apt 或 yum）安装 xmlsec1 工具

```
# apt-get install xmlsec1
```



 

Note 注意



In this guide, the keystone Identity Provider is configured on a host called idp.keystone.example.org listening on the standard HTTPS port. All keystone paths will start with the keystone version prefix, `/v3`. If you have configured keystone to listen on port 5000, or to respond on the path `/identity` (for example), take this into account in your own configuration.
在本指南中，Keystone Identity Provider 配置在名为 idp.keystone.example.org 的主机上，该主机正在侦听标准 HTTPS 端口。所有梯形图路径都将以 keystone 版本前缀 `/v3` .如果您已将 keystone 配置为侦听端口 5000 或响应路径 `/identity` （例如），请在您自己的配置中考虑这一点。

### Configuring Metadata[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-metadata) 配置元数据 ¶

Since keystone is acting as a SAML Identity Provider, its metadata must be configured in the `[saml]` section (not to be confused with an optional `[saml2]` section which you may have configured in [Configure the Remote Id Attribute](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-the-remote-id-attribute) while setting up keystone as Service Provider) of `keystone.conf` so that it can served by the [metadata API](https://docs.openstack.org/api-ref/identity/v3-ext/index.html#retrieve-metadata-properties).
由于 keystone 充当 SAML 身份提供程序，因此必须在 的部分中 `[saml]` 配置其元数据（不要与在将 keystone 设置为服务提供商时配置远程 ID 属性中配置的可选 `[saml2]` 部分混淆）， `keystone.conf` 以便元数据 API 可以提供元数据。

The two parameters that **must** be set in order for keystone to generate metadata are `idp_entity_id` and `idp_sso_endpoint`:
keystone 生成元数据必须设置的两个参数是 `idp_entity_id` 和 `idp_sso_endpoint` ：

```
[saml]
idp_entity_id=https://idp.keystone.example.org/v3/OS-FEDERATION/saml2/idp
idp_sso_endpoint=https://idp.keystone.example.org/v3/OS-FEDERATION/saml2/sso
```

`idp_entity_id` sets the Identity Provider entity ID, which is a string of your choosing that uniquely identifies the Identity Provider to any Service Provider.
 `idp_entity_id` 设置身份提供程序实体 ID，这是您选择的字符串，用于将身份提供程序唯一标识为任何服务提供商。

`idp_sso_endpoint` is required to generate valid metadata, but its value is currently not used because keystone as an Identity Provider does not support the SAML2.0 WebSSO auth profile. This may change in the future which is why there is no default value provided and must be set by the operator.
 `idp_sso_endpoint` 需要生成有效的元数据，但当前未使用其值，因为作为身份提供程序的 keystone 不支持 SAML2.0 WebSSO 身份验证配置文件。这将来可能会更改，这就是为什么没有提供默认值并且必须由操作员设置的原因。

For completeness, the following Organization and Contact configuration options should also be updated to reflect your organization and administrator contact details.
为了完整起见，还应更新以下“组织”和“联系人”配置选项，以反映您的组织和管理员联系人详细信息。

```
idp_organization_name=example_company
idp_organization_display_name=Example Corp.
idp_organization_url=example.com
idp_contact_company=example_company
idp_contact_name=John
idp_contact_surname=Smith
idp_contact_email=jsmith@example.com
idp_contact_telephone=555-555-5555
idp_contact_type=technical
```

It is important to take note of the default `certfile` and `keyfile` options, and adjust them if necessary:
请务必注意默认值 `certfile` 和 `keyfile` 选项，并在必要时进行调整：

```
certfile=/etc/keystone/ssl/certs/signing_cert.pem
keyfile=/etc/keystone/ssl/private/signing_key.pem
```

You must generate a PKI key pair and copy the files to these paths. You can use the `openssl` tool to do so. Keystone does not provide a utility for this.
您必须生成 PKI 密钥对并将文件复制到这些路径。您可以使用该 `openssl` 工具来执行此操作。Keystone 没有为此提供实用程序。

Check the `idp_metadata_path` setting and adjust it if necessary:
检查 `idp_metadata_path` 设置并在必要时进行调整：

```
idp_metadata_path=/etc/keystone/saml2_idp_metadata.xml
```

To create metadata for your keystone IdP, run the `keystone-manage` command and redirect the output to a file. For example:
要为 keystone IdP 创建元数据，请运行该 `keystone-manage` 命令并将输出重定向到文件。例如：

```
# keystone-manage saml_idp_metadata > /etc/keystone/saml2_idp_metadata.xml
```

Finally, restart the keystone WSGI service or the web server frontend:
最后，重新启动 keystone WSGI 服务或 Web 服务器前端：

```
# systemctl restart apache2
```

### Creating a Service Provider Resource[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#creating-a-service-provider-resource) 创建服务提供者资源 ¶

Create a Service Provider resource to represent your Service Provider as an object in keystone:
创建一个服务提供程序资源，以在 keystone 中将服务提供程序表示为对象：

```
$ openstack service provider create keystonesp \
--service-provider-url https://sp.keystone.example.org/Shibboleth.sso/SAML2/ECP
--auth-url https://sp.keystone.example.org/v3/OS-FEDERATION/identity_providers/keystoneidp/protocols/saml2/auth
```

The `--auth-url` is the [federated auth endpoint](https://docs.openstack.org/api-ref/identity/v3-ext/index.html#request-an-unscoped-os-federation-token) for a specific Identity Provider and protocol name, here named `keystoneidp` and `saml2`.
是 `--auth-url` 特定身份提供程序和协议名称的联合身份验证端点，此处命名为 `keystoneidp` 和 `saml2` 。

The `--service-provider-url` is the `urn:oasis:names:tc:SAML:2.0:bindings:PAOS` binding for the Assertion Consumer Service of the Service Provider. It can be obtained from the Service Provider metadata:
是 `--service-provider-url` 服务提供商的断言使用者服务的 `urn:oasis:names:tc:SAML:2.0:bindings:PAOS` 绑定。可以从服务提供商元数据中获取它：

```
$ curl -s https://sp.keystone.example.org/Shibboleth.sso/Metadata | grep urn:oasis:names:tc:SAML:2.0:bindings:PAOS
<md:AssertionConsumerService Binding="urn:oasis:names:tc:SAML:2.0:bindings:PAOS" Location="https://sp.keystone.example.org/Shibboleth.sso/SAML2/ECP" index="4"/>
```

### Authenticating[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id4) 身份验证 ¶

#### Use the CLI to authenticate with Keystone-to-Keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#use-the-cli-to-authenticate-with-keystone-to-keystone) 使用 CLI 对 Keystone 到 Keystone 进行身份验证 ¶

Use `python-openstackclient` to authenticate with the IdP and then get a scoped token from the SP.
用于 `python-openstackclient` 向 IdP 进行身份验证，然后从 SP 获取作用域内令牌。

```
export OS_USERNAME=demo
export OS_PASSWORD=nomoresecret
export OS_AUTH_URL=https://idp.keystone.example.org/v3
export OS_IDENTITY_API_VERSION=3
export OS_PROJECT_NAME=federated_project
export OS_PROJECT_DOMAIN_NAME=Default
export OS_SERVICE_PROVIDER=keystonesp
export OS_REMOTE_PROJECT_NAME=federated_project
export OS_REMOTE_PROJECT_DOMAIN_NAME=Default
openstack token issue
```

#### Use Horizon to switch clouds[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#use-horizon-to-switch-clouds) 使用 Horizon 切换云 ¶

No additional configuration is necessary to enable horizon for Keystone to Keystone. Log into the horizon instance for the Identity Provider using your regular local keystone credentials. Once logged in, you will see a Service Provider dropdown menu which you can use to switch your dashboard view to another cloud.
无需其他配置即可为 Keystone 到 Keystone 启用 Horizon。使用常规本地 Keystone 凭证登录到身份提供程序的 horizon 实例。登录后，您将看到一个服务提供商下拉菜单，您可以使用该菜单将仪表板视图切换到另一个云。

[![Horizon dropdown menu for switching between keystone providers](https://docs.openstack.org/keystone/yoga/_images/horizon-login-idp.png)](https://docs.openstack.org/keystone/yoga/_images/horizon-login-idp.png)



## Setting Up OpenID Connect[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#setting-up-openid-connect) 设置 OpenID Connect ¶

See [Keystone as a Service Provider (SP)](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-sp) before proceeding with these OpenIDC-specific instructions.
在继续执行这些特定于 OpenIDC 的说明之前，请参阅 Keystone 即服务提供商 （SP）。

These examples use Google as an OpenID Connect Identity Provider. The Service Provider must be added to the Identity Provider in the [Google API console](https://console.developers.google.com/).
这些示例使用 Google 作为 OpenID Connect 身份提供商。必须在 Google API 控制台中将服务提供商添加到身份提供商中。

### Configuring Apache HTTPD for mod_auth_openidc[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-apache-httpd-for-mod-auth-openidc) 为 mod_auth_openidc 配置 Apache HTTPD ¶



 

Note 注意



You are advised to carefully examine the [mod_auth_openidc documentation](https://github.com/zmartzone/mod_auth_openidc#how-to-use-it).
建议您仔细检查mod_auth_openidc文档。

#### Install the Module[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#install-the-module) 安装模块 ¶

Install the Apache module package. For example, on Ubuntu:
安装 Apache 模块包。例如，在 Ubuntu 上：

```
# apt-get install libapache2-mod-auth-openidc
```

The package and module name will differ between distributions.
包和模块名称因发行版而异。

#### Configure mod_auth_openidc[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-mod-auth-openidc) 配置mod_auth_openidc ¶

In the Apache configuration for the keystone VirtualHost, set the following OIDC options:
在 keystone VirtualHost 的 Apache 配置中，设置以下 OIDC 选项：

```
OIDCClaimPrefix "OIDC-"
OIDCResponseType "id_token"
OIDCScope "openid email profile"
OIDCProviderMetadataURL https://accounts.google.com/.well-known/openid-configuration
OIDCOAuthVerifyJwksUri https://www.googleapis.com/oauth2/v3/certs
OIDCClientID <openid_client_id>
OIDCClientSecret <openid_client_secret>
OIDCCryptoPassphrase <random string>
OIDCRedirectURI https://sp.keystone.example.org/v3/OS-FEDERATION/identity_providers/google/protocols/openid/auth
```

`OIDCScope` is the list of attributes that the user will authorize the Identity Provider to send to the Service Provider. `OIDCClientID` and `OIDCClientSecret` must be generated and obtained from the Identity Provider. `OIDCProviderMetadataURL` is a URL from which the Service Provider will fetch the Identity Provider’s metadata. `OIDCOAuthVerifyJwksUri` is a URL from which the Service Provider will download the public key from the Identity Provider to check if the user’s access token is valid or not, this configuration must be used while using the AuthType `auth-openidc`, when using the AuthType `openid-connect` and the OIDCProviderMetadataURL is configured, this property will not be necessary. `OIDCRedirectURI` is a vanity URL that must point to a protected path that does not have any content, such as an extension of the protected federated auth path.
 `OIDCScope` 是用户将授权身份提供程序发送给服务提供程序的属性列表。 `OIDCClientID` 并且 `OIDCClientSecret` 必须从身份提供程序生成和获取。 `OIDCProviderMetadataURL` 是服务提供商将从中获取身份提供商元数据的 URL。 `OIDCOAuthVerifyJwksUri` 是服务提供商从中下载公钥的 URL，用于检查用户的访问令牌是否有效，使用 AuthType `auth-openidc` 时必须使用此配置，当使用 AuthType `openid-connect` 并配置了 OIDCProviderMetadataURL 时，此属性将不是必需的。 `OIDCRedirectURI` 是一个虚 URL，它必须指向没有任何内容的受保护路径，例如受保护的联合身份验证路径的扩展。



 

Note 注意



If using a mod_wsgi version less than 4.3.0, then the OIDCClaimPrefix must be specified to have only alphanumerics or a dash (“-“). This is because [mod_wsgi blocks headers that do not fit this criteria](http://modwsgi.readthedocs.org/en/latest/release-notes/version-4.3.0.html#bugs-fixed).
如果使用低于 4.3.0 的 mod_wsgi 版本，则必须将 OIDCClaimPrefix 指定为仅具有字母数字或短划线 （“-”）。这是因为mod_wsgi阻止不符合此条件的标头。

#### Configure Protected Endpoints[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id5) 配置受保护的端点 ¶

Configure each protected path to use the `openid-connect` AuthType:
配置每个受保护的路径以使用 `openid-connect` AuthType：

```
<Location /v3/OS-FEDERATION/identity_providers/google/protocols/openid/auth>
    Require valid-user
    AuthType openid-connect
</Location>
```



 

Note 注意



To add support to Bearer Access Token authentication flow that is used by applications that do not adopt the browser flow, such the OpenStack CLI, you will need to change the AuthType from `openid-connect` to `auth-openidc`.
要添加对不采用浏览器流的应用程序（如 OpenStack CLI）使用的持有者访问令牌身份验证流的支持，您需要将 AuthType 从 `openid-connect` 更改为 `auth-openidc` 。

Do the same for the WebSSO auth paths if using horizon:
如果使用 horizon，请对 WebSSO 身份验证路径执行相同的操作：

```
<Location /v3/auth/OS-FEDERATION/websso/openid>
    Require valid-user
    AuthType openid-connect
</Location>
<Location /v3/auth/OS-FEDERATION/identity_providers/google/protocols/openid/websso>
    Require valid-user
    AuthType openid-connect
</Location>
```

Remember to reload Apache after altering the VirtualHost:
请记住在更改 VirtualHost 后重新加载 Apache：

```
# systemctl reload apache2
```



 

Note 注意



When creating [mapping rules](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#create-a-mapping), in keystone, note that the ‘remote’ attributes will be prefixed, with `HTTP_`, so for instance, if you set `OIDCClaimPrefix` to `OIDC-`, then a typical remote value to check for is: `HTTP_OIDC_ISS`.
在 keystone 中创建映射规则时，请注意 'remote' 属性将以 前缀，因此 `HTTP_` ，例如，如果设置为 `OIDCClaimPrefix` `OIDC-` ，则要检查的典型远程值为 ： `HTTP_OIDC_ISS` 。

#### Configuring Multiple Identity Providers[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-multiple-identity-providers) 配置多个身份提供商 ¶

To configure multiples Identity Providers in your environment you will need to set your OIDC options like the following options:
要在您的环境中配置多个身份提供商，您需要设置 OIDC 选项，如下所示：

```
OIDCClaimPrefix "OIDC-"
OIDCResponseType "id_token"
OIDCScope "openid email profile"
OIDCMetadataDir <IDP metadata directory>
OIDCCryptoPassphrase <random string>
OIDCRedirectURI https://sp.keystone.example.org/redirect_uri
OIDCOAuthVerifyCertFiles <kid>#</path/to-cert.pem> <kid2>#</path/to-cert2.pem> <kidN>#</path/to-certN.pem>
```

The `OIDCOAuthVerifyCertFiles` is a tuple separated with space containing the key-id (kid) of the Issuer’s public key and a path to the Issuer certificate. The separator `#` is used to split the (`kid`) and the public certificate address
是一个 `OIDCOAuthVerifyCertFiles` 元组，用空格分隔，其中包含颁发者公钥的 key-id （kid） 和颁发者证书的路径。分隔符 `#` 用于拆分 （ `kid` ） 和公共证书地址

The metadata folder configured in the option `OIDCMetadataDir` must have all your Identity Providers configurations, the name of the files will be the name (with path) of the Issuers like:
该选项 `OIDCMetadataDir` 中配置的元数据文件夹必须具有所有身份提供程序配置，文件的名称将是颁发者的名称（带路径），例如：

```
- <IDP metadata directory>
  |
  - accounts.google.com.client
  |
  - accounts.google.com.conf
  |
  - accounts.google.com.provider
  |
  - keycloak.example.org%2Fauth%2Frealms%2Fidp.client
  |
  - keycloak.example.org%2Fauth%2Frealms%2Fidp.conf
  |
  - keycloak.example.org%2Fauth%2Frealms%2Fidp.provider
```



 

Note 注意



The name of the file must be url-encoded if needed, as the Apache2 mod_auth_openidc will get the raw value from the query parameter `iss` from the http request and check if there is a metadata with this name, as the query parameter is url-encoded, so the metadata file name need to be encoded too. For example, if you have an Issuer with `/` in the URL, then you need to escape it to `%2F` by applying a URL escape in the file name.
如果需要，文件名必须进行 url 编码，因为 Apache2 mod_auth_openidc将从 http 请求的查询参数 `iss` 中获取原始值，并检查是否存在具有此名称的元数据，因为查询参数是 url 编码的，因此元数据文件名也需要编码。例如，如果 URL 中有一个 `/` Issuer，则需要 `%2F` 通过在文件名中应用 URL 转义来转义它。

The content of these files must be a JSON like
这些文件的内容必须是 JSON，例如

`accounts.google.com.client`:

```
{
  "client_id":"<openid_client_id>",
  "client_secret":"<openid_client_secret>"
}
```

The `.client` file handles the SP credentials in the Issuer.
该 `.client` 文件处理颁发者中的 SP 凭据。

`accounts.google.com.conf`:

This file will be a JSON that overrides some of OIDC options. The options that are able to be overridden are listed in the [OpenID Connect Apache2 plugin documentation](https://github.com/zmartzone/mod_auth_openidc/wiki/Multiple-Providers#opclient-configuration).
此文件将是一个 JSON，用于覆盖某些 OIDC 选项。OpenID Connect Apache2 插件文档中列出了能够覆盖的选项。

If you do not want to override the config values, you can leave this file as an empty JSON like `{}`.
如果您不想覆盖配置值，可以将此文件保留为空 JSON，例如 `{}` .

`accounts.google.com.provider`:

This file will contain all specifications about the IdentityProvider. To simplify, you can just use the JSON returned in the `.well-known` endpoint:
此文件将包含有关 IdentityProvider 的所有规范。为简化起见，您可以只使用终结点中返回的 `.well-known` JSON：

```
{
  "issuer": "https://accounts.google.com",
  "authorization_endpoint": "https://accounts.google.com/o/oauth2/v2/auth",
  "token_endpoint": "https://oauth2.googleapis.com/token",
  "userinfo_endpoint": "https://openidconnect.googleapis.com/v1/userinfo",
  "revocation_endpoint": "https://oauth2.googleapis.com/revoke",
  "jwks_uri": "https://www.googleapis.com/oauth2/v3/certs",
  "response_types_supported": [
   "code",
   "token",
   "id_token",
   "code token",
   "code id_token",
   "token id_token",
   "code token id_token",
   "none"
  ],
  "subject_types_supported": [
   "public"
  ],
  "id_token_signing_alg_values_supported": [
   "RS256"
  ],
  "scopes_supported": [
   "openid",
   "email",
   "profile"
  ],
  "token_endpoint_auth_methods_supported": [
   "client_secret_post",
   "client_secret_basic"
  ],
  "claims_supported": [
   "aud",
   "email",
   "email_verified",
   "exp",
   "family_name",
   "given_name",
   "iat",
   "iss",
   "locale",
   "name",
   "picture",
   "sub"
  ],
  "code_challenge_methods_supported": [
   "plain",
   "S256"
  ]
}
```

#### Continue configuring keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#continue-configuring-keystone) 继续配置 keystone ¶

[Continue configuring keystone
继续配置 keystone](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#federation-configuring-keystone)



## Setting Up Mellon[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#setting-up-mellon) 设置 Mellon ¶

See [Keystone as a Service Provider (SP)](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-sp) before proceeding with these Mellon-specific instructions.
在继续执行这些特定于 Mellon 的说明之前，请参阅 Keystone 作为服务提供商 （SP）。

### Configuring Apache HTTPD for mod_auth_mellon[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-apache-httpd-for-mod-auth-mellon) 为 mod_auth_mellon 配置 Apache HTTPD ¶



 

Note 注意



You are advised to carefully examine the [mod_auth_mellon documentation](https://github.com/Uninett/mod_auth_mellon/blob/master/doc/user_guide/mellon_user_guide.adoc#installing-configuring-mellon).
建议您仔细检查mod_auth_mellon文档。

Follow the steps outlined at: Keystone install guide for [SUSE](https://docs.openstack.org/keystone/yoga/install/keystone-install-obs.html#configure-the-apache-http-server), [RedHat](https://docs.openstack.org/keystone/yoga/install/keystone-install-rdo.html#configure-the-apache-http-server) or [Ubuntu](https://docs.openstack.org/keystone/yoga/install/keystone-install-ubuntu.html#configure-the-apache-http-server).
按照 SUSE、RedHat 或 Ubuntu 的 Keystone 安装指南中概述的步骤操作。

#### Install the Module[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id6) 安装模块 ¶

Install the Apache module package. For example, on Ubuntu:
安装 Apache 模块包。例如，在 Ubuntu 上：

```
# apt-get install libapache2-mod-auth-mellon
```

The package and module name will differ between distributions.
包和模块名称因发行版而异。

#### Configure mod_auth_mellon[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-mod-auth-mellon) 配置mod_auth_mellon ¶

Unlike `mod_shib`, all of `mod_auth_mellon`’s configuration is done in Apache, not in a separate config file. Set up the shared settings in a single `<Location>` directive near the top in your keystone VirtualHost file, before your protected endpoints:
与 不同的 `mod_shib` 是，所有的 `mod_auth_mellon` 配置都是在Apache中完成的，而不是在单独的配置文件中完成的。在受保护的终结点之前，在 keystone VirtualHost 文件顶部附近的单个 `<Location>` 指令中设置共享设置：

```
<Location /v3>
    MellonEnable "info"
    MellonSPPrivateKeyFile /etc/apache2/mellon/sp.keystone.example.org.key
    MellonSPCertFile /etc/apache2/mellon/sp.keystone.example.org.cert
    MellonSPMetadataFile /etc/apache2/mellon/sp-metadata.xml
    MellonIdPMetadataFile /etc/apache2/mellon/idp-metadata.xml
    MellonEndpointPath /v3/mellon
    MellonIdP "IDP"
</Location>
```

#### Configure Protected Endpoints[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id7) 配置受保护的端点 ¶

Configure each protected path to use the `Mellon` AuthType:
配置每个受保护的路径以使用 `Mellon` AuthType：

```
<Location /v3/OS-FEDERATION/identity_providers/samltest/protocols/saml2/auth>
   Require valid-user
   AuthType Mellon
   MellonEnable auth
</Location>
```

Do the same for the WebSSO auth paths if using horizon as a single sign-on frontend:
如果将 horizon 用作单点登录前端，请对 WebSSO 身份验证路径执行相同的操作：

```
<Location /v3/auth/OS-FEDERATION/websso/saml2>
   Require valid-user
   AuthType Mellon
   MellonEnable auth
</Location>
<Location /v3/auth/OS-FEDERATION/identity_providers/samltest/protocols/saml2/websso>
   Require valid-user
   AuthType Mellon
   MellonEnable auth
</Location>
```

#### Configure the Mellon Service Provider Metadata[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-the-mellon-service-provider-metadata) 配置 Mellon 服务提供商元数据 ¶

Mellon provides a script called `mellon_create_metadata.sh``_ which generates the values for the config directives ``MellonSPPrivateKeyFile`, `MellonSPCertFile`, and `MellonSPMetadataFile`. Run the script:
Mellon 提供了一个名为 `mellon_create_metadata.sh``_ which generates the values for the config directives ``MellonSPPrivateKeyFile` 、 `MellonSPCertFile` 和 `MellonSPMetadataFile` 的脚本。运行脚本：

```
$ ./mellon_create_metadata.sh \
https://sp.keystone.example.org/mellon \
http://sp.keystone.example.org/v3/OS-FEDERATION/identity_providers/samltest/protocols/saml2/auth/mellon
```

The first parameter is used as the entity ID, a URN of your choosing that must uniquely identify the Service Provider to the Identity Provider. The second parameter is the full URL for the endpoint path corresponding to the parameter `MellonEndpointPath`.
第一个参数用作实体 ID，即您选择的 URN，它必须唯一标识身份提供商的服务提供商。第二个参数是与该参数 `MellonEndpointPath` 对应的端点路径的完整 URL。

After generating the keypair and metadata, copy the files to the locations given by the `MellonSPPrivateKeyFile` and `MellonSPCertFile` settings in your Apache configuration.
生成密钥对和元数据后，将文件复制到 Apache 配置中 `MellonSPPrivateKeyFile` 和 `MellonSPCertFile` 设置给出的位置。

Upload the Service Provider’s Metadata file which you just generated to your Identity Provider. This is the file used as the value of the MellonSPMetadataFile in the config. The IdP may provide a webpage where you can upload the file, or you may be required to submit the file using wget or curl. Please check your IdP documentation for details.
将您刚刚生成的服务提供商的元数据文件上传到您的身份提供商。这是在配置中用作 MellonSPMetadataFile 值的文件。IdP 可能会提供一个网页，您可以在其中上传文件，或者您可能需要使用 wget 或  curl 提交文件。有关详细信息，请查看您的 IdP 文档。

#### Exchange Metadata[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#exchange-metadata) Exchange 元数据 ¶

Fetch your Identity Provider’s Metadata file and copy it to the path specified by the `MellonIdPMetadataFile` setting in your Apache configuration.
获取身份提供程序的元数据文件，并将其复制到 Apache 配置中设置 `MellonIdPMetadataFile` 指定的路径。

```
$ wget -O /etc/apache2/mellon/idp-metadata.xml https://samltest.id/saml/idp
```

Remember to reload Apache after finishing configuring Mellon:
请记住在完成配置 Mellon 后重新加载 Apache：

```
# systemctl reload apache2
```

#### Continue configuring keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id8) 继续配置 keystone ¶

[Continue configuring keystone
继续配置 keystone](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#federation-configuring-keystone)



## Setting up Shibboleth[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#setting-up-shibboleth) 设置 Shibboleth ¶

See [Keystone as a Service Provider (SP)](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#keystone-as-sp) before proceeding with these Shibboleth-specific instructions.
在继续执行这些特定于 Shibboleth 的说明之前，请参阅 Keystone 作为服务提供商 （SP）。



 

Note 注意



The examples below are for Ubuntu 16.04, for which only version 2 of the Shibboleth Service Provider is available. Version 3 is available for other distributions and the configuration should be identical to version 2.
以下示例适用于 Ubuntu 16.04，其中只有 Shibboleth Service Provider 版本 2 可用。版本 3 可用于其他发行版，配置应与版本 2 相同。

### Configuring Apache HTTPD for mod_shib[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-apache-httpd-for-mod-shib) 为 mod_shib 配置 Apache HTTPD ¶



 

Note 注意



You are advised to carefully examine the [mod_shib Apache configuration documentation](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPApacheConfig).
建议您仔细查看 Apache 配置文档mod_shib。

Configure keystone under Apache, following the steps in the install guide for [SUSE](https://docs.openstack.org/keystone/yoga/install/keystone-install-obs.html#configure-the-apache-http-server), [RedHat](https://docs.openstack.org/keystone/yoga/install/keystone-install-rdo.html#configure-the-apache-http-server) or [Ubuntu](https://docs.openstack.org/keystone/yoga/install/keystone-install-ubuntu.html#configure-the-apache-http-server).
按照 SUSE、RedHat 或 Ubuntu 安装指南中的步骤，在 Apache 下配置 keystone。

#### Install the Module[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id12) 安装模块 ¶

Install the Apache module package. For example, on Ubuntu:
安装 Apache 模块包。例如，在 Ubuntu 上：

```
# apt-get install libapache2-mod-shib2
```

The package and module name will differ between distributions.
包和模块名称因发行版而异。

#### Configure Protected Endpoints[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id13) 配置受保护的端点 ¶

In the Apache configuration for the keystone VirtualHost, set an additional `<Location>` which is not part of keystone’s API:
在 keystone VirtualHost 的 Apache 配置中，设置一个不属于 keystone API 的附加 `<Location>` 项：

```
<Location /Shibboleth.sso>
    SetHandler shib
</Location>
```

If you are using `mod_proxy`, for example to proxy requests to the `/identity` path to keystone’s UWSGI service, you must exempt this Shibboleth endpoint from it:
例如，如果使用 `mod_proxy` ，将请求代理到 keystone 的 UWSGI 服务 `/identity` 路径，则必须从中免除此 Shibboleth 端点：

```
Proxypass Shibboleth.sso !
```

Configure each protected path to use the `shibboleth` AuthType:
配置每个受保护的路径以使用 `shibboleth` AuthType：

```
<Location /v3/OS-FEDERATION/identity_providers/samltest/protocols/saml2/auth>
    Require valid-user
    AuthType shibboleth
    ShibRequestSetting requireSession 1
    ShibExportAssertion off
    <IfVersion < 2.4>
        ShibRequireSession On
        ShibRequireAll On
    </IfVersion>
</Location>
```

Do the same for the WebSSO auth paths if using horizon as a single sign-on frontend:
如果将 horizon 用作单点登录前端，请对 WebSSO 身份验证路径执行相同的操作：

```
<Location /v3/auth/OS-FEDERATION/websso/saml2>
    Require valid-user
    AuthType shibboleth
    ShibRequestSetting requireSession 1
    ShibExportAssertion off
    <IfVersion < 2.4>
        ShibRequireSession On
        ShibRequireAll On
    </IfVersion>
</Location>
<Location /v3/auth/OS-FEDERATION/identity_providers/samltest/protocols/saml2/websso>
    Require valid-user
    AuthType shibboleth
    ShibRequestSetting requireSession 1
    ShibExportAssertion off
    <IfVersion < 2.4>
        ShibRequireSession On
        ShibRequireAll On
    </IfVersion>
</Location>
```

Remember to reload Apache after altering the VirtualHost:
请记住在更改 VirtualHost 后重新加载 Apache：

```
# systemctl reload apache2
```

### Configuring mod_shib[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configuring-mod-shib) 配置mod_shib ¶



 

Note 注意



You are advised to examine [Shibboleth Service Provider Configuration documentation](https://wiki.shibboleth.net/confluence/display/SHIB2/Configuration)
建议您查看 Shibboleth 服务提供商配置文档

#### Generate a keypair[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#generate-a-keypair) 生成密钥对 ¶

For all SAML Service Providers, a PKI key pair must be generated and exchanged with the Identity Provider. The `mod_shib` package on the Ubuntu distribution provides a utility to generate the key pair:
对于所有 SAML 服务提供商，必须生成 PKI 密钥对并与身份提供商交换。Ubuntu 发行版上的 `mod_shib` 软件包提供了一个实用程序来生成密钥对：

```
# shib-keygen -y <number of years>
```

which will generate a key pair under `/etc/shibboleth`. In other cases, the package might generate the key pair automatically upon installation.
这将在 下 `/etc/shibboleth` 生成一个密钥对。在其他情况下，软件包可能会在安装时自动生成密钥对。

#### Configure metadata[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-metadata) 配置元数据 ¶

`mod_shib` also has its own configuration file at `/etc/shibboleth/shibboleth2.xml` that must be altered, as well as its own daemon. First, give the Service Provider an entity ID. This is a URN that you choose that must be globally unique to the Identity Provider:
 `mod_shib` 也有它自己的配置文件，必须 `/etc/shibboleth/shibboleth2.xml` 被改变，以及它自己的守护进程。首先，为服务提供商提供实体 ID。这是您选择的 URN，它必须对身份提供商具有全局唯一性：

```
<ApplicationDefaults entityID="https://sp.keystone.example.org/shibboleth"
    REMOTE_USER="eppn persistent-id targeted-id">
```

Depending on your Identity Provider, you may also want to change the REMOTE_USER setting, more on that in a moment.
根据您的身份提供商，您可能还希望更改REMOTE_USER设置，稍后会详细介绍。

Set the entity ID of the Identity Provider (this is the same as the value you provided for `--remote-id` in Identity Provider):
设置身份提供程序的实体 ID（这与您在身份提供程序 `--remote-id` 中提供的值相同）：

```
<SSO entityID="https://samltest.id/saml/idp">
```

Additionally, if you want to enable ECP (required for Keystone-to-Keystone), the SSO tag for this entity must also have the ECP flag set:
此外，如果要启用 ECP（Keystone 到 Keystone 需要），则此实体的 SSO 标记还必须设置 ECP 标志：

```
<SSO entityID="https://samltest.id/saml/idp" ECP="true">
```

Tell Shibboleth where to find the metadata of the Identity Provider. You could either tell it to fetch it from a URI or point it to a local file. For example, pointing to a local file:
告诉 Shibboleth 在哪里可以找到身份提供程序的元数据。您可以告诉它从 URI 获取它或将其指向本地文件。例如，指向本地文件：

```
<MetadataProvider type="XML" file="/etc/shibboleth/samltest-metadata.xml" />
```

or pointing to a remote location:
或指向远程位置：

```
<MetadataProvider type="XML" url="https://samltest.id/saml/idp"
    backingFile="samltest-metadata.xml" />
```

When you are finished configuring `shibboleth2.xml`, restart the `shibd` daemon:
完成配置 `shibboleth2.xml` 后，重新启动 `shibd` 守护程序：

```
# systemctl restart shibd
```

Check the `shibd` logs in `/var/log/shibboleth/shibd.log` and `/var/log/shibboleth/shibd_warn.log` for errors or warnings.
检查 `shibd` 登录 `/var/log/shibboleth/shibd.log` 名以及 `/var/log/shibboleth/shibd_warn.log` 是否有错误或警告。

#### Configure allowed attributes[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#configure-allowed-attributes) 配置允许的属性 ¶



 

Note 注意



For more information see the [attributes documentation](https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPAddAttribute)
有关详细信息，请参阅属性文档

By default, `mod_shib` does not pass all attributes received from the Identity Provider to keystone. If your Identity Provider does not use attributes known to `shibd`, you must configure them. For example, samltest.id uses a custom UID attribute.  It is not discoverable in the Identity Provider metadata, but the attribute name and type is logged in the `mod_shib` logs when an authentication attempt is made. To allow the attribute, add it to `/etc/shibboleth/attribute-map.xml`:
默认情况下， `mod_shib` 不会将从身份提供程序接收的所有属性传递给 keystone。如果您的身份提供程序不使用已知的 `shibd` 属性，则必须对其进行配置。例如，samltest.id 使用自定义 UID 属性。在身份提供程序元数据中无法发现它，但在尝试进行身份验证时，属性名称和类型会记录在日志中 `mod_shib` 。要允许该属性，请将其添加到 `/etc/shibboleth/attribute-map.xml` ：

```
<Attribute name="urn:oid:0.9.2342.19200300.100.1.1" id="uid" />
```

You may also want to use that attribute as a value for the `REMOTE_USER` variable, which will make the `REMOTE_USER` variable usable as a parameter to your mapping rules. To do so, add it to `/etc/shibboleth/shibboleth2.xml`:
您可能还希望将该属性用作 `REMOTE_USER` 变量的值，这将使该 `REMOTE_USER` 变量可用作映射规则的参数。为此，请将其添加到 `/etc/shibboleth/shibboleth2.xml` ：

```
<ApplicationDefaults entityID="https://sp.keystone.example.org/shibboleth"
    REMOTE_USER="uid">
```

Similarly, if using keystone as your Identity Provider, several custom attributes will be needed in `/etc/shibboleth/attribute-map.xml`:
同样，如果使用 keystone 作为身份提供程序，则需要 `/etc/shibboleth/attribute-map.xml` 以下几个自定义属性：

```
<Attribute name="openstack_user" id="openstack_user"/>
<Attribute name="openstack_roles" id="openstack_roles"/>
<Attribute name="openstack_project" id="openstack_project"/>
<Attribute name="openstack_user_domain" id="openstack_user_domain"/>
<Attribute name="openstack_project_domain" id="openstack_project_domain"/>
<Attribute name="openstack_groups" id="openstack_groups"/>
```

And update the `REMOTE_USER` variable in `/etc/shibboleth/shibboleth2.xml` if desired:
如果需要，请更新 `REMOTE_USER` 变量 `/etc/shibboleth/shibboleth2.xml` ：

```
<ApplicationDefaults entityID="https://sp.keystone.example.org/shibboleth"
    REMOTE_USER="openstack_user">
```

Restart the `shibd` daemon after making these changes:
进行以下更改后重新启动 `shibd` 守护程序：

```
# systemctl restart shibd
```

#### Exchange Metadata[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id14) Exchange 元数据 ¶

Once configured, the Service Provider metadata is available to download:
配置完成后，服务提供商元数据可供下载：

```
# wget https://sp.keystone.example.org/Shibboleth.sso/Metadata
```

Upload your Service Provider’s metadata to your Identity Provider. This step depends on your Identity Provider choice and is not covered here. If keystone is your Identity Provider you do not need to upload this file.
将服务提供商的元数据上传到您的身份提供商。此步骤取决于您的身份提供商选择，此处不予介绍。如果 keystone 是您的身份提供商，则无需上传此文件。

#### Continue configuring keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#id15) 继续配置 keystone ¶

[Continue configuring keystone
继续配置 keystone](https://docs.openstack.org/keystone/yoga/admin/federation/configure_federation.html#federation-configuring-keystone)

# Mapping Combinations 映射组合

​                                          

## Description[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#description) 描述 ¶

During the authentication process an identity provider (IdP) will present keystone with a set of user attributes about the user that is authenticating. For example, in the SAML2 flow this comes to keystone in the form of a SAML document.
在身份验证过程中，身份提供商 （IdP） 将提供带有一组有关正在进行身份验证的用户的用户属性的基石。例如，在 SAML2 流程中，它以 SAML 文档的形式出现在 keystone 中。

The attributes are typically processed by third-party software and are presented to keystone as environment variables. The original document from the IdP is generally not available to keystone. This is how the Shibboleth and Mellon implementations work.
这些属性通常由第三方软件处理，并作为环境变量呈现给 keystone。Keystone 通常无法获得 IdP 的原始文档。这就是 Shibboleth 和 Mellon 实现的工作方式。

The mapping format described in this document maps these environment variables to a local keystone user. The mapping may also define group membership for that user and projects the user can access.
本文档中描述的映射格式将这些环境变量映射到本地 keystone 用户。映射还可以定义该用户的组成员身份以及用户可以访问的项目。

An IdP has exactly one mapping specified per protocol. Mappings themselves can be used multiple times by different combinations of IdP and protocol.
IdP 为每个协议指定了一个映射。映射本身可以通过 IdP 和协议的不同组合多次使用。

## Definitions[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#definitions) 定义 ¶

A mapping looks as follows:
映射如下所示：

```
{
    "rules": [
        {
            "local": [
                {
                    <user>
                    [<group>]
                    [<project>]
                }
            ],
            "remote": [
                {
                    <match>
                    [<condition>]
                }
            ]
        }
    ]
}
```

- mapping: a JSON object containing a list of rules.
  mapping：包含规则列表的 JSON 对象。
- rules: a property in the mapping that contains the list of rules.
  rules：映射中包含规则列表的属性。
- rule: a JSON object containing local and remote properties to define the rule. There is no explicit rule property.
  rule：一个 JSON 对象，包含用于定义规则的本地和远程属性。没有显式规则属性。
- local: a JSON object containing information on what local attributes will be mapped. The mapping engine processes this using the context (defined below) and the result is a representation of the user from keystone’s perspective.
  local：一个 JSON 对象，包含有关将映射哪些本地属性的信息。映射引擎使用上下文（定义如下）进行处理，结果是从 keystone 的角度表示用户。
  - <user>: the local user that will be mapped to the federated user.
    ：将映射到联盟用户的本地用户。
  - <group>: (optional) the local groups the federated user will be placed in.
    ：（可选）联盟用户将被放置在的本地组。
  - <projects>: (optional) the local projects mapped to the federated user.
    ：（可选）映射到联合用户的本地项目。
- remote: a JSON object containing information on what remote attributes will be mapped.
  remote：一个 JSON 对象，包含有关将映射哪些远程属性的信息。
  - <match>: a JSON object that tells the mapping engine what federated attribute to make available for substitution in the local object. There can be one or more of these objects in the remote list.
    ：一个 JSON 对象，它告诉映射引擎要在本地对象中提供哪些联合属性以供替换。远程列表中可以有一个或多个这些对象。
  - <condition>: a JSON object containing conditions that allow a rule. There can be zero or more of these objects in the remote list.
    ：包含允许规则的条件的 JSON 对象。远程列表中可以有零个或多个这些对象。
- direct mapping: the mapping engine keeps track of each match and makes them available to the local rule for substitution.
  直接映射：映射引擎跟踪每个匹配项，并将它们提供给本地规则进行替换。
- assertion: data provided to keystone by the IdP to assert facts (name, groups, etc) about the authenticating user. This is an XML document when using the SAML2 protocol.
  断言：IdP 提供给 keystone 的数据，用于断言有关身份验证用户的事实（名称、组等）。这是使用 SAML2 协议时的 XML 文档。
- mapping context: the data, represented as key-value pairs, that is used by the mapping engine to turn the local object into a representation of the user from keystone’s perspective. The mapping context contains the environment of the keystone process and any direct mapping values calculated when processing the remote list.
  映射上下文：映射引擎使用的数据，表示为键值对，从 Keystone 的角度将本地对象转换为用户的表示形式。映射上下文包含梯形失调进程的环境以及处理远程列表时计算的任何直接映射值。

## How Mappings Are Processed[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#how-mappings-are-processed) 如何处理映射 ¶

A mapping is selected by IdP and protocol. Then keystone takes the mapping and processes each rule sequentially stopping after the first matched rule. A rule is matched when all of its conditions are met.
映射由 IdP 和协议选择。然后，keystone 获取映射并按顺序处理每个规则，在第一个匹配的规则之后停止。当规则的所有条件都满足时，规则即为匹配。

First keystone evaluates each condition from the rule’s remote property to see if the rule is a match. If it is a match, keystone saves the data captured by each of the matches from the rule’s remote property in an ordered list. We call these matches direct mappings since they can be used in the next step.
第一个 keystone 从规则的远程属性中评估每个条件，以查看规则是否匹配。如果是匹配项，keystone 会将每个匹配项从规则的远程属性捕获的数据保存在有序列表中。我们称这些匹配为直接映射，因为它们可以在下一步中使用。

After the rule is found using the rule’s conditions and a list of direct mappings is stored, keystone begins processing the rule’s local property. Each object in the local property is collapsed into a single JSON object. For example:
使用规则的条件找到规则并存储直接映射列表后，keystone 将开始处理规则的本地属性。本地属性中的每个对象都折叠到单个 JSON 对象中。例如：

```
{
    "local": [
        {
            "user": {...}
        },
        {
            "projects": [...]
        },
    ]
}
```

becomes: 成为：

```
{
    "local": {
        "user": {...}
        "projects": [...]
    },
}
```

when the same property exists in the local multiple times the first occurrence wins:
当同一属性在本地中多次存在时，第一次出现将获胜：

```
{
    "local": [
        {
            "user": {#first#}
        },
        {
            "projects": [...]
        },
        {
            "user": {#second#}
        },
    ]
}
```

becomes: 成为：

```
{
    "local": {
        "user": {#first#}
        "projects": [...]
    },
}
```

We take this JSON object and then recursively process it in order to apply the direct mappings. This is simply looking for the pattern {#} and substituting it with values from the direct mappings list. The index of the direct mapping starts at zero.
我们获取这个 JSON 对象，然后递归处理它以应用直接映射。这只是查找模式 {#} 并将其替换为直接映射列表中的值。直接映射的索引从零开始。

## Mapping Rules[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#mapping-rules) 映射规则 ¶

### Mapping Engine[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#mapping-engine) 映射引擎 ¶

The mapping engine can be tested before creating a federated setup. It can be tested with the `keystone-manage mapping_engine` command:
在创建联合设置之前，可以测试映射引擎。可以使用以下 `keystone-manage mapping_engine` 命令对其进行测试：

```
$ keystone-manage mapping_engine --rules <file> --input <file>
```



 

Note 注意



Although the rules file is formatted as JSON, the input file of assertion data is formatted as individual lines of key: value pairs, see keystone-manage mapping_engine –help for details.
虽然规则文件的格式为 JSON，但断言数据的输入文件格式为单独的 key： 值对行，有关详细信息，请参见 keystone-manage mapping_engine –help。

### Mapping Conditions[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#mapping-conditions) 映射条件 ¶

Mappings support 5 different types of conditions:
映射支持 5 种不同类型的条件：

`empty`: The rule is matched to all claims containing the remote attribute type. This condition does not need to be specified.
 `empty` ：该规则与包含远程属性类型的所有声明匹配。此条件无需指定。

`any_one_of`: The rule is matched only if any of the specified strings appear in the remote attribute type. Condition result is boolean, not the argument that is passed as input.
 `any_one_of` ：仅当远程属性类型中出现任何指定的字符串时，才匹配规则。条件结果是布尔值，而不是作为输入传递的参数。

`not_any_of`: The rule is not matched if any of the specified strings appear in the remote attribute type. Condition result is boolean, not the argument that is passed as input.
 `not_any_of` ：如果远程属性类型中出现任何指定的字符串，则该规则不匹配。条件结果是布尔值，而不是作为输入传递的参数。

`blacklist`: This rule removes all groups matched from the assertion. It is not intended to be used as a way to prevent users, or groups of users, from accessing the service provider. The output from filtering through a blacklist will be all groups from the assertion that were not listed in the blacklist.
 `blacklist` ：此规则从断言中删除所有匹配的组。它不打算用作阻止用户或用户组访问服务提供商的一种方式。通过黑名单进行筛选的输出将是断言中未在黑名单中列出的所有组。

`whitelist`: This rule explicitly states which groups should be carried over from the assertion. The result is the groups present in the assertion and in the whitelist.
 `whitelist` ：此规则明确说明应从断言中继承哪些组。结果是断言和白名单中存在的组。



 

Note 注意



`empty`, `blacklist` and `whitelist` are the only conditions that can be used in direct mapping ({0}, {1}, etc.)
 `empty` ， `blacklist` 并且是 `whitelist` 可用于直接映射（{0}、{1}等）的唯一条件

Multiple conditions can be combined to create a single rule.
可以将多个条件组合在一起以创建单个规则。

### Mappings Examples[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#mappings-examples) 映射示例 ¶

The following are all examples of mapping rule types.
以下是映射规则类型的所有示例。

#### empty condition[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#empty-condition) 空条件 ¶

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0} {1}",
                        "email": "{2}"
                    },
                    "group": {
                        "name": "{3}",
                        "domain": {
                            "id": "0cd5e9"
                        }
                    }
                }
            ],
            "remote": [
                {
                    "type": "FirstName"
                },
                {
                    "type": "LastName"
                },
                {
                    "type": "Email"
                },
                {
                    "type": "OIDC_GROUPS"
                }
            ]
        }
    ]
}
```



 

Note 注意



The numbers in braces {} are indices, they map in order. For example:
大括号 {} 中的数字是索引，它们按顺序映射。例如：

```
- Mapping to user with the name matching the value in remote attribute FirstName
- Mapping to user with the name matching the value in remote attribute LastName
- Mapping to user with the email matching value in remote attribute Email
- Mapping to a group(s) with the name matching the value(s) in remote attribute OIDC_GROUPS
```



 

Note 注意



If the user id and name are not specified in the mapping, the server tries to directly map `REMOTE_USER` environment variable. If this variable is also unavailable the server returns an HTTP 401 Unauthorized error.
如果映射中未指定用户 ID 和名称，则服务器将尝试直接映射 `REMOTE_USER` 环境变量。如果此变量也不可用，则服务器将返回 HTTP 401 Unauthorized 错误。

Groups can have multiple values. Each value must be separated by a ; Example: OIDC_GROUPS=developers;testers
组可以有多个值。每个值必须用 Example 分隔：OIDC_GROUPS=developers;测试

#### other conditions[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#other-conditions) 其他条件 ¶

In `<other_condition>` shown below, please supply one of the following: `any_one_of`, or `not_any_of`.
如下 `<other_condition>` 所示，请提供以下选项之一： `any_one_of` 或 `not_any_of` 。

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    },
                    "group": {
                        "id": "0cd5e9"
                    }
                }
            ],
            "remote": [
                {
                    "type": "UserName"
                },
                {
                    "type": "HTTP_OIDC_GROUPIDS",
                    "<other_condition>": [
                        "HTTP_OIDC_EMAIL"
                    ]
                }
            ]
        }
    ]
}
```

In `<other_condition>` shown below, please supply one of the following: `blacklist`, or `whitelist`.
如下 `<other_condition>` 所示，请提供以下选项之一： `blacklist` 或 `whitelist` 。

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    }
                },
                {
                    "groups": "{1}",
                    "domain": {
                        "id": "0cd5e9"
                    }
                }
            ],
            "remote": [
                {
                    "type": "UserName"
                },
                {
                    "type": "HTTP_OIDC_GROUPIDS",
                    "<other_condition>": [
                        "me@example.com"
                    ]
                }
            ]
        }
    ]
}
```

In the above example, a whitelist can be used to only map the user into a few of the groups in their `HTTP_OIDC_GROUPIDS` remote attribute:
在上面的示例中，白名单只能用于将用户映射到其 `HTTP_OIDC_GROUPIDS` 远程属性中的几个组：

```
{
    "type": "HTTP_OIDC_GROUPIDS",
    "whitelist": [
        "Developers",
        "OpsTeam"
    ]
}
```

A blacklist can map the user into all groups except those matched:
黑名单可以将用户映射到除匹配的组之外的所有组：

```
{
    "type": "HTTP_OIDC_GROUPIDS",
    "blacklist": [
        "Finance"
    ]
}
```

Regular expressions can be used in any condition for more flexible matches:
正则表达式可以在任何条件下使用，以实现更灵活的匹配：

```
{
    "type": "HTTP_OIDC_GROUPIDS",
    "whitelist": [
        ".*Team$"
    ]
}
```

When mapping into groups, either ids or names can be provided in the local section:
映射到组时，可以在 local 部分中提供 id 或名称：

```
{
    "local": [
        {
            "group": {
                "id":"0cd5e9"
            }
        }
    ]
}
{
    "local": [
        {
            "group": {
                "name": "developer_group",
                "domain": {
                    "id": "abc1234"
                }
            }
        }
    ]
}
{
    "local": [
        {
            "group": {
                "name": "developer_group",
                "domain": {
                    "name": "private_cloud"
                }
            }
        }
    ]
}
```

Users can be mapped to local users that already exist in keystone’s identity backend by setting the `type` attribute of the user to `local` and providing the domain to which the local user belongs:
通过设置用户 `type` 的属性 `local` 并提供本地用户所属的域，可以将用户映射到 keystone 身份后端中已存在的本地用户：

```
{
    "local": [
        {
            "user": {
                "name": "local_user",
                "type": "local",
                "domain": {
                    "name": "local_domain"
                }
            }
        }
    ]
}
```

The user is then treated as existing in the local identity backend, and the server will attempt to fetch user details (id, name, roles, groups) from the identity backend. The local user and domain are not generated dynamically, so if they do not exist in the local identity backend, authentication attempts will result in a 401 Unauthorized error.
然后，用户被视为存在于本地身份后端，服务器将尝试从身份后端获取用户详细信息（ID、名称、角色、组）。本地用户和域不是动态生成的，因此，如果本地身份后端中不存在它们，则身份验证尝试将导致 401 未经授权错误。

If you omit the `type` attribute or set it to `ephemeral` or do not provide a domain, the user is deemed ephemeral and becomes a member of the identity provider’s domain. It will not be looked up in the local keystone backend, so all of its attributes must come from the IdP and the mapping rules.
如果省略该 `type` 属性或将其设置为 `ephemeral` 域或不提供域，则该用户将被视为临时用户，并成为标识提供者域的成员。它不会在本地 keystone 后端中查找，因此它的所有属性都必须来自 IdP 和映射规则。



 

Note 注意



Domain `Federated` is a service domain - it cannot be listed, displayed, added or deleted.  There is no need to perform any operation on it prior to federation configuration.
域 `Federated` 是一个服务域 - 它不能被列出、显示、添加或删除。在联合配置之前，无需对其执行任何操作。

### Output[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#output) 输出 ¶

If a mapping is valid you will receive the following output:
如果映射有效，您将收到以下输出：

```
{
    "group_ids": "[<group-ids>]",
    "user":
        {
            "domain":
                {
                    "id": "Federated" or "<local-domain-id>"
                },
            "type": "ephemeral" or "local",
            "name": "<local-user-name>",
            "id": "<local-user-id>"
        },
    "group_names":
        [
            {
                "domain":
                    {
                        "name": "<domain-name>"
                    },
                "name":
                    {
                        "name": "[<groups-names>]"
                    }
            },
            {
                "domain":
                    {
                        "name": "<domain-name>"
                    },
                "name":
                    {
                        "name": "[<groups-names>]"
                    }
            }
        ]
}
```

If the mapped user is local, mapping engine will discard further group assigning and return set of roles configured for the user.
如果映射的用户是本地用户，则映射引擎将放弃进一步的组分配，并返回为该用户配置的角色集。

### Regular Expressions[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#regular-expressions) 正则表达式 ¶

Regular expressions can be used in a mapping by specifying the `regex` key, and setting it to `true`.
正则表达式可以通过指定 `regex` 键并将其设置为 `true` 来在映射中使用。

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    },
                    "group": {
                        "name": "{1}",
                        "domain": {
                            "id": "abc1234"
                        }
                    }
                },
            ],
            "remote": [
                {
                    "type": "UserName"
                },
                {
                    "type": "HTTP_OIDC_GROUPIDS",
                    "any_one_of": [
                        ".*@yeah.com$"
                    ]
                    "regex": true
                },
                {
                    "type": "HTTP_OIDC_GROUPIDS",
                    "whitelist": [
                        "Project.*$"
                    ],
                    "regex": true
                 }
            ]
        }
    ]
}
```

This allows any user with a claim containing a key with any value in `HTTP_OIDC_GROUPIDS` to be mapped to group with id `0cd5e9`. Additionally, for every value in the `HTTP_OIDC_GROUPIDS` claim matching the string `Project.*`, the user will be assigned to the project with that name.
这允许任何声明包含具有任何值的 `HTTP_OIDC_GROUPIDS` 键的用户映射到 id `0cd5e9` 为 的组。此外，对于 `HTTP_OIDC_GROUPIDS` 声明中与字符串 `Project.*` 匹配的每个值，用户将被分配到具有该名称的项目。

### Condition Combinations[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#condition-combinations) 条件组合 ¶

Combinations of mappings conditions can also be done.
也可以组合映射条件。

`empty`, `any_one_of`, and `not_any_of` can all be used in the same rule, but cannot be repeated within the same condition. `any_one_of` and `not_any_of` are mutually exclusive within a condition’s scope. So are `whitelist` and `blacklist`.
 `empty` 、 `any_one_of` 和 `not_any_of` 都可以在同一规则中使用，但不能在同一条件下重复。 `any_one_of` 并且在 `not_any_of` 条件范围内是互斥的。所以是 `whitelist` 和 `blacklist` .

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    },
                    "group": {
                        "id": "0cd5e9"
                    }
                },
            ],
            "remote": [
                {
                    "type": "UserName"
                },
                {
                    "type": "cn=IBM_Canada_Lab",
                    "not_any_of": [
                        ".*@naww.com$"
                    ],
                    "regex": true
                },
                {
                    "type": "cn=IBM_USA_Lab",
                    "any_one_of": [
                        ".*@yeah.com$"
                    ]
                    "regex": true
                }
            ]
        }
    ]
}
```

As before group names and users can also be provided in the local section.
和以前一样，也可以在本地部分提供组名和用户。

This allows any user with the following claim information to be mapped to group with id 0cd5e9.
这允许将具有以下声明信息的任何用户映射到 ID 为 0cd5e9 的组。

```
{"UserName":"<any_name>@yeah.com"}
{"cn=IBM_USA_Lab":"<any_name>@yeah.com"}
{"cn=IBM_Canada_Lab":"<any_name>@yeah.com"}
```

The following claims will be mapped:
将映射以下声明：

- any claim containing the key UserName.
  包含键 UserName 的任何声明。
- any claim containing key cn=IBM_Canada_Lab that doesn’t have the value <any_name>@naww.com.
  任何包含键 CN=IBM_Canada_Lab 且值不为 @naww.com 的声明。
- any claim containing key cn=IBM_USA_Lab that has value <any_name>@yeah.com.
  包含值为 @yeah.com 的键 CN=IBM_USA_Lab 的任何声明。

### Multiple Rules[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#multiple-rules) 多规则 ¶

Multiple rules can also be utilized in a mapping.
还可以在映射中使用多个规则。

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    },
                    "group": {
                        "name": "non-contractors",
                        "domain": {
                            "id": "abc1234"
                        }
                    }
                }
            ],
            "remote": [
                {
                    "type": "UserName"
                },
                {
                    "type": "orgPersonType",
                    "not_any_of": [
                        "Contractor",
                        "SubContractor"
                    ]
                }
            ]
        },
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    },
                    "group": {
                        "name": "contractors",
                        "domain": {
                            "id": "abc1234"
                        }
                    }
                }
            ],
            "remote": [
                {
                    "type": "UserName"
                },
                {
                    "type": "orgPersonType",
                    "any_one_of": [
                        "Contractor",
                        "SubContractor"
                    ]
                }
            ]
        }
    ]
}
```

The above assigns groups membership basing on `orgPersonType` values:
上面根据 `orgPersonType` 值分配组成员身份：

- neither `Contractor` nor `SubContractor` will belong to the `non-contractors` group.
  既不 `Contractor` 属于也不 `SubContractor` 属于该 `non-contractors` 集团。
- either `Contractor or ``SubContractor` will belong to the `contractors` group.
  任何一个 `Contractor or ``SubContractor` 都将属于该 `contractors` 组。

Rules are additive, so permissions will only be granted for the rules that succeed.  All the remote conditions of a rule must be valid.
规则是累加的，因此只会为成功的规则授予权限。规则的所有远程条件都必须有效。

When using multiple rules you can specify more than one effective user identification, but only the first match will be considered and the others ignored ordered from top to bottom.
使用多个规则时，您可以指定多个有效的用户标识，但仅考虑第一个匹配项，而忽略其他匹配项，按从上到下的顺序排列。

Since rules are additive one can specify one user identification and this will also work. The best practice for multiple rules is to create a rule for just user and another rule for just groups. Below is rules example repeated but with global username mapping.
由于规则是累加的，因此可以指定一个用户标识，这也将起作用。多个规则的最佳做法是仅为用户创建一个规则，为组创建另一个规则。下面是重复但具有全局用户名映射的规则示例。

```
{
    "rules": [{
        "local": [{
            "user": {
                "id": "{0}"
            }
        }],
        "remote": [{
            "type": "UserType"
        }]
    },
    {
        "local": [{
            "group": {
                "name": "non-contractors",
                "domain": {
                    "id": "abc1234"
                }
            }
        }],
        "remote": [{
            "type": "orgPersonType",
            "not_any_of": [
                "Contractor",
                "SubContractor"
            ]
        }]
    },
    {
        "local": [{
            "group": {
                "name": "contractors",
                "domain": {
                    "id": "abc1234"
                }
            }
        }],
        "remote": [{
            "type": "orgPersonType",
            "any_one_of": [
                "Contractor",
                "SubContractor"
            ]
        }]
    }]
 }
```

### Auto-Provisioning[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#auto-provisioning) 自动配置 ¶

The mapping engine has the ability to aid in the auto-provisioning of resources when a federated user authenticates for the first time. This can be achieved using a specific mapping syntax that the mapping engine can parse and ultimately make decisions on.
映射引擎能够在联合身份用户首次进行身份验证时帮助自动预配资源。这可以使用映射引擎可以解析并最终做出决策的特定映射语法来实现。

For example, consider the following mapping:
例如，请考虑以下映射：

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    }
                },
                {
                    "projects": [
                        {
                            "name": "Production",
                            "roles": [
                                {
                                    "name": "reader"
                                }
                            ]
                        },
                        {
                            "name": "Staging",
                            "roles": [
                                {
                                    "name": "member"
                                }
                            ]
                        },
                        {
                            "name": "Project for {0}",
                            "roles": [
                                {
                                    "name": "admin"
                                }
                            ]
                        }
                    ]
                }
            ],
            "remote": [
                {
                    "type": "UserName"
                }
            ]
        }
    ]
}
```

The semantics of the `remote` section have not changed. The difference between this mapping and the other examples is the addition of a `projects` section within the `local` rules. The `projects` list supplies a list of projects that the federated user will be given access to. The projects will be automatically created if they don’t exist when the user authenticated and the mapping engine has applied values from the assertion and mapped them into the `local` rules.
该 `remote` 部分的语义没有改变。此映射与其他示例的区别在于在 `local` 规则中添加了一个 `projects` 部分。该 `projects` 列表提供联盟用户将有权访问的项目列表。如果当用户进行身份验证并且映射引擎应用了断言中的值并将其映射到 `local` 规则中时，这些项目不存在，则会自动创建这些项目。

In the above example, an authenticated federated user will be granted the `reader` role on the `Production` project, `member` role on the `Staging` project, and they will have `admin` role on the `Project for jsmith`.
在上面的示例中，经过身份验证的联合身份用户将被授予 `reader`  `Production` 项目角色、 `member` `Staging` 项目角色，并且他们将拥有 `admin` `Project for jsmith` .

It is important to note the following constraints apply when auto-provisioning:
请务必注意，自动预配时存在以下约束：

- Projects are the only resource that will be created dynamically.
  项目是唯一将动态创建的资源。
- Projects will be created within the domain associated with the Identity Provider.
  项目将在与身份提供程序关联的域中创建。
- The `projects` section of the mapping must also contain a `roles` section.
  映射 `projects` 的截面也必须包含截 `roles` 面。
  - Roles within the project must already exist in the deployment or domain.
    项目中的角色必须已存在于部署或域中。
- Assignments are actually created for the user which is unlike the ephemeral group memberships.
  分配实际上是为用户创建的，这与临时组成员身份不同。

Since the creation of roles typically requires policy changes across other services in the deployment, it is expected that roles are created ahead of time. Federated authentication should also be considered idempotent if the attributes from the SAML assertion have not changed. In the example from above, if the user’s name is still `jsmith`, then no new projects will be created as a result of authentication.
由于创建角色通常需要跨部署中的其他服务更改策略，因此应提前创建角色。如果 SAML 断言中的属性未更改，则联合身份验证也应被视为幂等身份验证。在上面的示例中，如果用户名仍 `jsmith` 为 ，则不会因身份验证而创建新项目。

Mappings can be created that mix `groups` and `projects` within the `local` section. The mapping shown in the example above does not contain a `groups` section in the `local` rules. This will result in the federated user having direct role assignments on the projects in the `projects` list. The following example contains `local` rules comprised of both `projects` and `groups`, which allow for direct role assignments and group memberships.
可以创建混合 `groups` 和 `projects`  `local` 在部分内的映射。上面示例中显示的映射不包含 `local` 规则中的部分 `groups` 。这将导致联合用户对 `projects` 列表中的项目具有直接角色分配。以下示例包含 `local` 由 `projects` 和 `groups` 组成的规则，这些规则允许直接角色分配和组成员身份。

```
{
    "rules": [
        {
            "local": [
                {
                    "user": {
                        "name": "{0}"
                    }
                },
                {
                    "projects": [
                        {
                            "name": "Marketing",
                            "roles": [
                                {
                                    "name": "member"
                                }
                            ]
                        },
                        {
                            "name": "Development project for {0}",
                            "roles": [
                                {
                                    "name": "admin"
                                }
                            ]
                        }
                    ]
                },
                {
                    "group": {
                        "name": "Finance",
                        "domain": {
                            "id": "6fe767"
                        }
                    }
                }
            ],
            "remote": [
                {
                    "type": "UserName"
                }
            ]
        }
    ]
}
```

In the above example, a federated user will receive direct role assignments on the `Marketing` project, as well as a dedicated project specific to the federated user’s name. In addition to that, they will also be placed in the `Finance` group and receive all role assignments that group has on projects and domains.
在上面的示例中，联盟用户将收到 `Marketing` 项目的直接角色分配，以及特定于联盟用户名称的专用项目。除此之外，他们还将被放置在组中 `Finance` ，并接收该组对项目和域的所有角色分配。

### keystone-to-keystone[¶](https://docs.openstack.org/keystone/yoga/admin/federation/mapping_combinations.html#keystone-to-keystone)

keystone-to-keystone federation also utilizes mappings, but has some differences.
Keystone 到 Keystone 联合也使用映射，但存在一些差异。

An attribute file (e.g. `/etc/shibboleth/attribute-map.xml` in a Shibboleth implementation) is used to add attributes to the mapping context. Attributes look as follows:
属性文件（例如在 Shibboleth 实现 `/etc/shibboleth/attribute-map.xml` 中）用于将属性添加到映射上下文中。属性如下所示：

```
<!-- example 1 from a K2k Shibboleth implementation -->
<Attribute name="openstack_user" id="openstack_user"/>
<Attribute name="openstack_user_domain" id="openstack_user_domain"/>
```

The service provider must contain a mapping as shown below. `openstack_user`, and `openstack_user_domain` match to the attribute names we have in the Identity Provider. It will map any user with the name `user1` or `admin` in the `openstack_user` attribute and `openstack_domain` attribute `default` to a group with id `abc1234`.
服务提供商必须包含如下所示的映射。 `openstack_user` ，并与 `openstack_user_domain` 我们在身份提供程序中的属性名称匹配。它会将任何具有名称 `user1` 或 `admin`  `openstack_user` 属性和 `openstack_domain` 属性 `default` 的用户映射到具有 id `abc1234` 的组。

```
{
    "rules": [
        {
            "local": [
                {
                    "group": {
                        "id": "abc1234"
                    }
                }
            ],
            "remote": [
                {
                    "type": "openstack_user",
                    "any_one_of": [
                        "user1",
                        "admin"
                    ]
                },
                {
                    "type":"openstack_user_domain",
                    "any_one_of": [
                        "Default"
                    ]
                }
            ]
        }
    ]
}
```

A keystone user’s groups can also be mapped to groups in the service provider. For example, with the following attributes declared in Shibboleth’s attributes file:
Keystone 用户的组也可以映射到服务提供商中的组。例如，在 Shibboleth 的属性文件中声明以下属性：

```
<!-- example 2 from a K2k Shibboleth implementation -->
<Attribute name="openstack_user" id="openstack_user"/>
<Attribute name="openstack_groups" id="openstack_groups"/>
```

Then the following mapping can be used to map the user’s group membership from the keystone IdP to groups in the keystone SP:
然后，可以使用以下映射将用户的组成员身份从 keystone IdP 映射到 keystone SP 中的组：

```
{
    "rules": [
        {
            "local":
            [
                {
                    "user":
                        {
                            "name": "{0}"
                        }
                },
                {
                    "groups": "{1}"
                }
            ],
            "remote":
            [
                {
                    "type": "openstack_user"
                },
                {
                    "type": "openstack_groups"
                }
            ]
        }
    ]
}
```

`openstack_user`, and `openstack_groups` will be matched by service provider to the attribute names we have in the Identity Provider. It will take the `openstack_user` attribute and finds in the assertion then inserts it directly in the mapping.  The identity provider will set the value of `openstack_groups` by group name and domain name to which the user belongs in the Idp. Suppose the user belongs to ‘group1’ in domain ‘Default’ in the IdP then it will map to a group with the same name and same domain’s name in the SP.
 `openstack_user` ，并由 `openstack_groups` 服务提供商与我们在身份提供商中的属性名称进行匹配。它将获取 `openstack_user` 属性并在断言中找到，然后将其直接插入映射中。身份提供商将按用户在 Idp 中所属的 `openstack_groups` 组名和域名设置值。假设用户属于 IdP 中域“默认”中的“group1”，则它将映射到 SP 中具有相同名称和相同域名称的组。

The possible attributes that can be used in a mapping are openstack_user, openstack_user_domain, openstack_roles, openstack_project, openstack_project_domain and openstack_groups.
映射中可能使用的属性包括 openstack_user、openstack_user_domain、openstack_roles、openstack_project、openstack_project_domain 和 openstack_groups。

# Using external authentication with Keystone 对 Keystone 使用外部身份验证

​                                          

When Keystone is executed in a web server like Apache HTTPD, it is possible to have the web server also handle authentication. This enables support for additional methods of authentication that are not provided by the identity store backend and the authentication plugins that Keystone supports.
当 Keystone 在 Web 服务器（如 Apache HTTPD）中执行时，可以让 Web 服务器也处理身份验证。这样就可以支持身份存储后端和 Keystone 支持的身份验证插件未提供的其他身份验证方法。

Having the web server handle authentication is not exclusive, and both Keystone and the web server can provide different methods of authentication at the same time. For example, the web server can provide support for X.509 or Kerberos authentication, while Keystone provides support for password authentication (with SQL or an identity store as the backend).
让 Web 服务器处理身份验证并不是排他性的，Keystone 和 Web 服务器可以同时提供不同的身份验证方法。例如，Web 服务器可以提供对  X.509 或 Kerberos 身份验证的支持，而 Keystone 则提供对密码身份验证的支持（使用 SQL 或身份存储作为后端）。

When the web server authenticates a user, it sets environment variables, usually `REMOTE_USER`, which can be used in the underlying application. Keystone can be configured to use these environment variables to determine the identity of the user.
当 Web 服务器对用户进行身份验证时，它会设置环境变量，通常是 `REMOTE_USER` ，这些变量可以在底层应用程序中使用。Keystone 可以配置为使用这些环境变量来确定用户的身份。

## Configuration[¶](https://docs.openstack.org/keystone/yoga/admin/external-authentication.html#configuration) 配置 ¶

In order to activate the external authentication mechanism for Identity API v3, the `external` method must be in the list of enabled authentication methods. By default it is enabled, so if you don’t want to use external authentication, remove it from the `methods` option in the `auth` section.
要激活 Identity API v3 的外部身份验证机制，该 `external` 方法必须位于已启用的身份验证方法列表中。默认情况下，它处于启用状态，因此，如果您不想使用外部身份验证，请将其从 `auth` 该部分的 `methods` 选项中删除。

To configure the plugin that should be used set the `external` option again in the `auth` section. There are two external authentication method plugins provided by Keystone:
要配置应使用的插件，请在该 `auth` 部分中再次设置该 `external` 选项。Keystone 提供了两种外部认证方法插件：

- `DefaultDomain`: This plugin won’t take into account the domain information that the external authentication method may pass down to Keystone and will always use the configured default domain. The `REMOTE_USER` variable is the username. This is the default if no plugin is given.
   `DefaultDomain` ：此插件不会考虑外部身份验证方法可能传递给 Keystone 的域信息，并将始终使用配置的默认域。 `REMOTE_USER` 变量是用户名。如果没有提供插件，这是默认设置。
- `Domain`: This plugin expects that the `REMOTE_DOMAIN` variable contains the domain for the user. If this variable is not present, the configured default domain will be used. The `REMOTE_USER` variable is the username.
   `Domain` ：此插件期望 `REMOTE_DOMAIN` 变量包含用户的域。如果此变量不存在，则将使用配置的默认域。 `REMOTE_USER` 变量是用户名。

Caution 谨慎

You should disable the external auth method if you are currently using federation. External auth and federation both use the `REMOTE_USER` variable. Since both the mapped and external plugin are being invoked to validate attributes in the request environment, it can cause conflicts.
如果当前正在使用联合身份验证，则应禁用外部身份验证方法。外部身份验证和联合身份验证都使用该 `REMOTE_USER` 变量。由于同时调用映射插件和外部插件来验证请求环境中的属性，因此可能会导致冲突。

For example, imagine there are two distinct users with the same username foo, one in the Default domain while the other is in the BAR domain. The external Federation modules (i.e. mod_shib) sets the `REMOTE_USER` attribute to foo. The external auth module also tries to set the `REMOTE_USER` attribute to foo for the Default domain. The federated mapping engine maps the incoming identity to foo in the BAR domain. This results in user_id conflict since both are using different user_ids to set foo in the Default domain and the BAR domain.
例如，假设有两个不同的用户具有相同的用户名 foo，一个在默认域中，另一个在 BAR 域中。外部联合模块（即 mod_shib）将 `REMOTE_USER` 属性设置为 foo。外部身份验证模块还会尝试将 `REMOTE_USER` 默认域的属性设置为 foo。联合映射引擎将传入标识映射到 BAR 域中的 foo。这会导致user_id冲突，因为两者都使用不同的user_ids在默认域和 BAR 域中设置 foo。

To disable this, simply remove external from the methods option in keystone.conf:
要禁用此功能，只需从 keystone.conf 的 methods 选项中删除 external：

```
methods = external,password,token,oauth1
```

## Using HTTPD authentication[¶](https://docs.openstack.org/keystone/yoga/admin/external-authentication.html#using-httpd-authentication) 使用 HTTPD 身份验证 ¶

Web servers like Apache HTTP support many methods of authentication. Keystone can profit from this feature and let the authentication be done in the web server, that will pass down the authenticated user to Keystone using the `REMOTE_USER` environment variable. This user must exist in advance in the identity backend to get a token from the controller.
像 Apache HTTP 这样的 Web 服务器支持许多身份验证方法。Keystone 可以从此功能中获益，并允许在 Web 服务器中完成身份验证，这将使用 `REMOTE_USER` 环境变量将经过身份验证的用户传递给 Keystone。此用户必须提前存在于标识后端中，才能从控制器获取令牌。

To use this method, Keystone should be running on HTTPD.
要使用此方法，Keystone 应在 HTTPD 上运行。

### X.509 example[¶](https://docs.openstack.org/keystone/yoga/admin/external-authentication.html#x-509-example) X.509 示例 ¶

The following snippet for the Apache conf will authenticate the user based on a valid X.509 certificate from a known CA:
Apache conf 的以下代码片段将根据来自已知 CA 的有效 X.509 证书对用户进行身份验证：

```
<VirtualHost _default_:5000>
    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/ssl.cert
    SSLCertificateKeyFile /etc/ssl/private/ssl.key

    SSLCACertificatePath /etc/ssl/allowed_cas
    SSLCARevocationPath  /etc/ssl/allowed_cas
    SSLUserName          SSL_CLIENT_S_DN_CN
    SSLVerifyClient      require
    SSLVerifyDepth       10

    (...)
</VirtualHost>
```

​                      

# Configuring Keystone for Tokenless Authorization 配置 Keystone 以实现无令牌授权

​                                          

## Definitions[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#definitions) 定义 ¶

- X.509 Tokenless Authorization: Provides a means to authorize client operations within Keystone by using an X.509 SSL client certificate without having to issue a token.
  X.509 无令牌授权：提供一种使用 X.509 SSL 客户端证书在 Keystone 中授权客户端操作的方法，而无需颁发令牌。

  This feature is designed to reduce the complexity of user token validation in Keystone `auth_token` middleware by eliminating the need for service user token for authentication and authorization. Therefore, there’s no need to having to create and maintain a service user account for the sole purpose of user token validation. Furthermore, this feature improves efficiency by avoiding service user token handling (i.e. request, cache, and renewal). By not having to deal with service user credentials in the configuration files, deployers are relieved of the burden of having to protect the server user passwords throughout the deployment lifecycle. This feature also improve security by using X.509 certificate instead of password for authentication.
  此功能旨在通过消除对服务用户令牌进行身份验证和授权的需求，降低 Keystone `auth_token`  中间件中用户令牌验证的复杂性。因此，无需创建和维护服务用户帐户，其唯一目的是进行用户令牌验证。此外，此功能通过避免服务用户令牌处理（即请求、缓存和续订）来提高效率。由于不必在配置文件中处理服务用户凭据，部署人员可以免除在整个部署生命周期中必须保护服务器用户密码的负担。此功能还通过使用 X.509 证书而不是密码进行身份验证来提高安全性。

  For details, please refer to the specs [Tokenless Authorization with X.509 Client SSL Certificate](https://specs.openstack.org/openstack/keystone-specs/specs/liberty/keystone-tokenless-authz-with-x509-ssl-client-cert.html)
  有关详细信息，请参阅规格 X.509 客户端 SSL 证书的无令牌授权

- Public Key Infrastructure or PKI: a system which utilize public key cryptography to achieve authentication, authorization, confidentiality, integrity, non-repudiation. In this system, the identities are represented by public key certificates. Public key certificate handling is governed by the [X.509](https://en.wikipedia.org/wiki/X.509) standard.
  公钥基础设施或PKI：利用公钥加密来实现身份验证、授权、机密性、完整性、不可否认性的系统。在此系统中，标识由公钥证书表示。公钥证书处理受 X.509 标准的约束。

  See [Public Key Infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) and [X.509](https://en.wikipedia.org/wiki/X.509) for more information.
  有关详细信息，请参阅公钥基础结构和 X.509。

- X.509 Certificate: a time bound digital identity, which is certified or digitally signed by its issuer using cryptographic means as defined by the [X.509](https://en.wikipedia.org/wiki/X.509) standard. It contains information which can be used to uniquely identify its owner. For example, the owner of the certificate is identified by the `Subject` attribute while the issuer is identified by `Issuer` attribute.
  X.509 证书：一种有时限的数字身份，由其颁发者使用 X.509 标准定义的加密方式进行认证或数字签名。它包含可用于唯一标识其所有者的信息。例如，证书的所有者由属性标识， `Subject` 而颁发者由 `Issuer` 属性标识。

  In operation, certificates are usually stored in [Privacy-Enhanced Mail](https://en.wikipedia.org/wiki/Public_key_certificate) (PEM) format.
  在操作中，证书通常以隐私增强邮件 （PEM） 格式存储。

  Here’s an example of what a certificate typically contains:
  下面是证书通常包含的内容的示例：

  ```
  Certificate:
      Data:
          Version: 3 (0x2)
          Serial Number: 4098 (0x1002)
      Signature Algorithm: sha256WithRSAEncryption
          Issuer: DC = com, DC = somedemo, O = openstack, OU = keystone, CN = Intermediate CA
          Validity
              Not Before: Jul  5 18:42:01 2019 GMT
              Not After : Jul  2 18:42:01 2029 GMT
          Subject: DC = com, DC = somedemo, O = Default, OU = keystone, CN = glance
          Subject Public Key Info:
              Public Key Algorithm: rsaEncryption
                  Public-Key: (2048 bit)
                  Modulus:
                      00:cf:35:8b:cd:4f:17:28:38:25:f7:e2:ac:ce:4e:
                      d7:05:74:2f:99:04:f8:c2:13:14:50:18:70:d6:b0:
                      53:62:15:60:59:99:90:47:e2:7e:bf:ca:30:4a:18:
                      f5:b8:29:1e:cc:d4:b8:49:9c:4a:aa:d9:10:b9:d7:
                      9f:55:85:cf:e3:44:d2:3c:95:42:5a:b0:53:3e:49:
                      9d:6b:b2:a0:9f:72:9d:76:96:55:8b:ee:c4:71:46:
                      ab:bd:12:71:42:a0:60:29:7a:66:16:e1:fd:03:17:
                      af:a3:c7:26:c3:c3:8b:a7:f9:c0:22:08:2d:e4:5c:
                      07:e1:44:58:c1:b1:88:ae:45:5e:03:10:bb:b4:c2:
                      42:52:da:4e:b5:1b:d6:6f:49:db:a4:5f:8f:e5:79:
                      9f:73:c2:37:de:99:a7:4d:6f:cb:b5:f9:7e:97:e0:
                      77:c8:40:21:40:ef:ab:d3:55:72:37:6c:28:0f:bd:
                      37:8c:3a:9c:e9:a0:21:6b:63:3f:7a:dd:1b:2c:90:
                      07:37:66:86:66:36:ef:21:bb:43:df:d5:37:a9:fa:
                      4b:74:9a:7c:4b:cd:8b:9d:3b:af:6d:50:fe:c9:0a:
                      25:35:c5:1d:40:35:1d:1f:f9:10:fd:b6:5c:45:11:
                      bb:67:11:81:3f:ed:d6:27:04:98:8f:9e:99:a1:c8:
                      c1:2d
                  Exponent: 65537 (0x10001)
          X509v3 extensions:
              X509v3 Basic Constraints:
                  CA:FALSE
              Netscape Cert Type:
                  SSL Client, S/MIME
              Netscape Comment:
                  OpenSSL Generated Client Certificate
              X509v3 Subject Key Identifier:
                  EE:38:FB:60:65:CD:81:CE:B2:01:E3:A5:99:1B:34:6C:1A:74:97:BB
              X509v3 Authority Key Identifier:
                  keyid:64:17:77:31:00:F2:ED:90:9A:A8:1D:B5:7D:75:06:03:B5:FD:B9:C0
  
              X509v3 Key Usage: critical
                  Digital Signature, Non Repudiation, Key Encipherment
              X509v3 Extended Key Usage:
                  TLS Web Client Authentication, E-mail Protection
      Signature Algorithm: sha256WithRSAEncryption
           82:8b:17:c6:f4:63:eb:8d:69:03:7a:bf:54:7f:37:02:eb:94:
           ef:57:fd:27:8f:f8:67:e9:0e:3b:0a:40:66:11:68:e6:04:1a:
           8a:da:47:ed:83:eb:54:34:3b:5b:70:18:cf:62:e2:6d:7c:74:
           4c:cf:14:b3:a9:70:b2:68:ed:19:19:71:6f:7d:87:22:38:8d:
           83:c6:59:15:74:19:5b:a2:64:6f:b9:9a:81:3d:0a:67:58:d1:
           e2:b2:9b:9b:8f:60:7a:8c:0e:61:d9:d7:04:63:cc:58:af:36:
           a4:61:86:44:1c:64:e2:9b:bd:f3:21:87:dd:18:81:80:af:0f:
           d6:4c:9f:ae:0f:01:e0:0e:38:4d:5d:71:da:0b:11:39:bd:c3:
           5d:0c:db:14:ca:bf:7f:07:37:c9:36:bd:22:a5:73:c6:e1:13:
           53:15:de:ac:4a:4b:dc:48:90:47:06:fa:d4:d2:5d:c6:d2:d4:
           3f:0f:49:0f:27:de:21:b0:bd:a3:92:c3:cb:69:b6:8d:94:e1:
           e3:40:b4:80:c7:e6:e2:df:0a:94:52:d1:16:41:0f:bc:29:a8:
           93:40:1b:77:28:a3:f2:cb:3c:7f:bb:ae:a6:0e:b3:01:78:09:
           d3:2b:cf:2f:47:83:91:36:37:43:34:6e:80:2b:81:10:27:95:
           95:ae:1e:93:42:94:a6:23:b8:07:c0:0f:38:23:70:b0:8e:79:
           14:cd:72:8a:90:bf:77:ad:74:3c:23:9e:67:5d:0e:26:15:6e:
           20:95:6d:d0:89:be:a3:6c:4a:13:1d:39:fb:21:e3:9c:9f:f3:
           ff:15:da:0a:28:29:4e:f4:7f:5e:0f:70:84:80:7c:09:5a:1c:
           f4:ac:c9:1b:9d:38:43:dd:27:00:95:ef:14:a0:57:3e:26:0b:
           d8:bb:40:d6:1f:91:92:f0:4e:5d:93:1c:b7:3d:bd:83:ef:79:
           ee:47:ca:61:04:00:e6:39:05:ab:f0:cd:47:e9:25:c8:3a:4c:
           e5:62:9f:aa:8a:ba:ea:46:10:ef:bd:1e:24:5f:0c:89:8a:21:
           bb:9d:c7:73:0f:b9:b5:72:1f:1f:1b:5b:ff:3a:cb:d8:51:bc:
           bb:9a:40:91:a9:d5:fe:95:ac:73:a5:12:6a:b2:e3:b1:b2:7d:
           bf:e7:db:cd:9f:24:63:6e:27:cf:d8:82:d9:ac:d8:c9:88:ea:
           4f:1c:ae:7d:b7:c7:81:b2:1c:f8:6b:6b:85:3b:f2:14:cb:c7:
           61:81:ad:64:e7:d9:90:a3:ea:69:7e:26:7a:0a:29:7b:1b:2a:
           e0:38:f7:58:d1:90:82:44:01:ab:05:fd:68:0c:ab:9e:c6:94:
           76:34:46:8b:66:bb:02:07
  ```

  See [public key certificate](https://en.wikipedia.org/wiki/Public_key_certificate) for more information.
  有关详细信息，请参阅公钥证书。

- Issuer: the issuer of a X.509 certificate. It is also known as [Certificate Authority (CA)](https://en.wikipedia.org/wiki/Certificate_authority) or Certification Authority. Issuer is typically represented in [RFC 2253](https://tools.ietf.org/html/rfc2253) format. Throughout this document, `issuer`, `issuer DN`, `CA`, and `trusted issuer` are used interchangeably.
  颁发者：X.509 证书的颁发者。它也称为证书颁发机构 （CA） 或证书颁发机构。颁发者通常以 RFC 2253 格式表示。在本文档中， `issuer` 、 、 `issuer DN` `CA` 和 可 `trusted issuer` 互换使用。

### Prerequisites[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#prerequisites) 先决条件 ¶

This feature requires Keystone API proxy SSL terminator to validate the incoming X.509 SSL client certificate and pass the certificate information (i.e. subject DN, issuer DN, etc) to the Keystone application as part of the request environment. At the time of this writing the feature has been tested with either HAProxy or Apache as Keystone API proxy SSL terminator only.
此功能要求 Keystone API 代理 SSL 终结器验证传入的 X.509 SSL 客户端证书，并将证书信息（即使用者 DN、颁发者 DN  等）作为请求环境的一部分传递给 Keystone 应用程序。在撰写本文时，该功能仅使用 HAProxy 或 Apache 作为 Keystone API 代理 SSL 终结器进行了测试。

The rest of this document required readers to familiar with:
本文档的其余部分要求读者熟悉：

- [Public Key Infrastructure (PKI) and certificate management
  公钥基础结构 （PKI） 和证书管理](https://en.wikipedia.org/wiki/Public_key_infrastructure)
- [SSL with client authentication](https://tools.ietf.org/html/rfc5246#section-7.4.6), or commonly known as two-way SSL
  具有客户端身份验证的 SSL，或通常称为双向 SSL
- [Public Key Infrastructure (PKI) and certificate management
  公钥基础结构 （PKI） 和证书管理](https://en.wikipedia.org/wiki/Public_key_infrastructure)
- [Apache SSL configuration
  Apache SSL 配置](https://httpd.apache.org/docs/trunk/mod/mod_ssl.html#ssloptions)
- [HAProxy SSL configuration
  HAProxy SSL 配置](http://cbonte.github.io/haproxy-dconv/1.7/configuration.html#7.3.4)

Configuring this feature requires [OpenSSL Command Line Tool (CLI)](https://www.openssl.org/docs/manmaster/man1/openssl.html). Please refer to the respective OS installation guide on how to install it.
配置此功能需要 OpenSSL 命令行工具 （CLI）。有关如何安装它，请参阅相应的操作系统安装指南。

## Keystone Configuration[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#keystone-configuration) Keystone 配置 ¶

This feature utilizes Keystone federation capability to determine the authorization associated with the incoming X.509 SSL client certificate by mapping the certificate attributes to a Keystone identity. Therefore, the direct issuer or trusted Certification Authority (CA) of the client certificate is the remote Identity Provider (IDP), and the hexadecimal output of the SHA256 hash of the issuer distinguished name (DN) is used as the IDP ID.
此功能利用 Keystone 联合功能，通过将证书属性映射到 Keystone 标识来确定与传入的 X.509 SSL  客户端证书关联的授权。因此，客户端证书的直接颁发者或受信任的证书颁发机构 （CA） 是远程身份提供程序 （IDP），颁发者可分辨名称 （DN） 的 SHA256 哈希的十六进制输出用作 IDP ID。



 

Note 注意



Client certificate issuer DN may be formatted differently depending on the SSL terminator. For example, Apache mod_ssl may use [RFC 2253](https://tools.ietf.org/html/rfc2253) while HAProxy may use the old format. The old format is used by applications that linked with an older version of OpenSSL where the string representation of the distinguished name has not yet become a de facto standard. For more information on the old formation, please see the [nameopt](https://www.openssl.org/docs/manmaster/man1/x509.html) in the OpenSSL CLI manual. Therefore, it is critically important to keep the format consistent throughout the configuration as Keystone does exact string match when comparing certificate attributes.
客户端证书颁发者 DN 的格式可能因 SSL 终止符而异。例如，Apache mod_ssl 可能使用 RFC 2253，而 HAProxy  可能使用旧格式。与旧版本的 OpenSSL  链接的应用程序使用旧格式，其中可分辨名称的字符串表示形式尚未成为事实上的标准。有关旧编队的更多信息，请参阅 OpenSSL CLI 手册中的  nameopt。因此，在整个配置过程中保持格式一致至关重要，因为 Keystone 在比较证书属性时会进行精确的字符串匹配。

### How to obtain trusted issuer DN[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#how-to-obtain-trusted-issuer-dn) 如何获取受信任的颁发者 DN ¶

If SSL terminates at either HAProxy or Apache, the client certificate issuer DN can be obtained by using the OpenSSL CLI.
如果 SSL 在 HAProxy 或 Apache 终止，则可以使用 OpenSSL CLI 获取客户端证书颁发者 DN。

Since version 2.3.11, Apache mod_ssl by default uses [RFC 2253](https://tools.ietf.org/html/rfc2253) when handling certificate distinguished names. However, deployer have the option to use the old format by configuring the [LegacyDNStringFormat](https://httpd.apache.org/docs/trunk/mod/mod_ssl.html#ssloptions) option.
从版本 2.3.11 开始，Apache mod_ssl 在处理证书可分辨名称时默认使用 RFC 2253。但是，部署程序可以通过配置 LegacyDNStringFormat 选项来选择使用旧格式。

HAProxy, on the other hand, only supports the old format.
另一方面，HAProxy 仅支持旧格式。

To obtain issuer DN in RFC 2253 format:
要获取 RFC 2253 格式的颁发者 DN，请执行以下操作：

```
$ openssl x509 -issuer -noout -in client_cert.pem -nameopt rfc2253 | sed 's/^\s*issuer=//'
```

To obtain issuer DN in old format:
要获取旧格式的颁发者 DN，请执行以下操作：

```
$ openssl x509 -issuer -noout -in client_cert.pem -nameopt compat | sed 's/^\s*issuer=//'
```

### How to calculate the IDP ID from trusted issuer DN[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#how-to-calculate-the-idp-id-from-trusted-issuer-dn) 如何从受信任的发行人 DN 计算 IDP ID¶

The hexadecimal output of the SHA256 hash of the trusted issuer DN is being used as the Identity Provider ID in Keystone. It can be obtained using OpenSSL CLI.
受信任颁发者 DN 的 SHA256 哈希的十六进制输出被用作 Keystone 中的身份提供程序 ID。可以使用 OpenSSL CLI 获取它。

To calculate the IDP ID for issuer DN in RFC 2253 format:
要计算 RFC 2253 格式颁发者 DN 的 IDP ID，请执行以下操作：

```
$ openssl x509 -issuer -noout -in client_cert.pem -nameopt rfc2253 | tr -d '\n' | sed 's/^\s*issuer=//' | openssl dgst -sha256 -hex | awk '{print $2}'
```

To calculate the IDP ID for issuer DN in old format:
要以旧格式计算颁发者 DN 的 IDP ID，请执行以下操作：

```
$ openssl x509 -issuer -noout -in client_cert.pem -nameopt compat | tr -d '\n' | sed 's/^\s*issuer=//' | openssl dgst -sha256 -hex | awk '{print $2}'
```

### Keystone Configuration File Changes[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#keystone-configuration-file-changes) Keystone 配置文件变更 ¶

The following options in the `tokenless_auth` section of the Keystone configuration file keystone.conf are used to enable the X.509 tokenless authorization feature:
Keystone 配置文件 keystone.conf `tokenless_auth` 部分中的以下选项用于启用 X.509 无令牌授权功能：

- `trusted_issuer` - A list of trusted issuers for the X.509 SSL client certificates. More specifically the list of trusted issuer DNs mentioned in the [How to obtain trusted issuer DN](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#how-to-obtain-trusted-issuer-dn) section above. The format of the trusted issuer DNs must match exactly with what the SSL terminator passed into the request environment. For example, if SSL terminates in Apache mod_ssl, then the issuer DN should be in RFC 2253 format. Whereas if SSL terminates in HAProxy, then the issuer DN is expected to be in the old format. This is a multi-string list option. The absence of any trusted issuers means the X.509 tokenless authorization feature is effectively disabled.
   `trusted_issuer` - X.509 SSL 客户端证书的受信任颁发者列表。更具体地说，上面的如何获取受信任的颁发者 DN 部分中提到的受信任颁发者 DN  列表。受信任颁发者 DN 的格式必须与 SSL 终结器传递到请求环境中的格式完全匹配。例如，如果 SSL 在 Apache  mod_ssl中终止，则颁发者 DN 应采用 RFC 2253 格式。而如果 SSL 在 HAProxy 中终止，则颁发者 DN  应采用旧格式。这是一个多字符串列表选项。没有任何受信任的颁发者意味着 X.509 无令牌授权功能被有效禁用。
- `protocol` - The protocol name for the X.509 tokenless authorization along with the option issuer_attribute below can look up its corresponding mapping. It defaults to `x509`.
   `protocol` - X.509 无令牌授权的协议名称以及下面的选项issuer_attribute可以查找其相应的映射。默认值为 `x509` 。
- `issuer_attribute` - The issuer attribute that is served as an IdP ID for the X.509 tokenless authorization along with the protocol to look up its corresponding mapping. It is the environment variable in the WSGI environment that references to the Issuer of the client certificate. It defaults to `SSL_CLIENT_I_DN`.
   `issuer_attribute` - 颁发者属性，用作 X.509 无令牌授权的 IdP ID，以及用于查找其相应映射的协议。它是 WSGI 环境中的环境变量，它引用客户端证书的颁发者。默认值为 `SSL_CLIENT_I_DN` 。

This is a sample configuration for two trusted_issuer and a protocol set to `x509`.
这是两个trusted_issuer和一个设置为 `x509` 的协议的示例配置。

```
[tokenless_auth]
trusted_issuer = emailAddress=admin@foosigner.com,CN=Foo Signer,OU=eng,O=abc,L=San Jose,ST=California,C=US
trusted_issuer = emailAddress=admin@openstack.com,CN=OpenStack Cert Signer,OU=keystone,O=openstack,L=Sunnyvale,ST=California,C=US
protocol = x509
```

## Setup Mapping[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#setup-mapping) 设置映射 ¶

Like federation, X.509 tokenless authorization also utilizes the mapping mechanism to formulate an identity. The identity provider must correspond to the issuer of the X.509 SSL client certificate. The protocol for the given identity is `x509` by default, but can be configurable.
与联合身份验证一样，X.509 无令牌授权也利用映射机制来制定身份。身份提供程序必须与 X.509 SSL 客户端证书的颁发者相对应。给定标识的协议是 `x509` 默认的，但可以配置。

### Create an Identity Provider (IDP)[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#create-an-identity-provider-idp) 创建身份提供商 （IDP） ¶

As mentioned, the Identity Provider ID is the hexadecimal output of the SHA256 hash of the issuer distinguished name (DN).
如前所述，标识提供者 ID 是颁发者可分辨名称 （DN） 的 SHA256 哈希的十六进制输出。



 

Note 注意



If there are multiple trusted issuers, there must be multiple IDP created, one for each trusted issuer.
如果有多个受信任的颁发者，则必须创建多个 IDP，每个受信任的颁发者一个。

To create an IDP for a given trusted issuer, follow the instructions in the [How to calculate the IDP ID from trusted issuer DN](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#how-to-calculate-the-idp-id-from-trusted-issuer-dn) section to calculate the IDP ID. Then use OpenStack CLI to create the IDP. i.e.
若要为给定的受信任颁发者创建 IDP，请按照如何从受信任的颁发者 DN 计算 IDP ID 部分中的说明计算 IDP ID。然后使用 OpenStack CLI 创建 IDP。即

```
$ openstack identity provider create --description 'IDP foo' <IDP ID>
```

### Create a Map[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#create-a-map) 创建地图 ¶

A mapping needs to be created to map the `Subject DN` in the client certificate as a user to yield a valid local user if the user’s `type` defined as `local` in the mapping. For example, the client certificate has `Subject DN` as `CN=alex,OU=eng,O=nice-network,L=Sunnyvale, ST=California,C=US`, in the following examples, `user_name` will be mapped to``alex`` and `domain_name` will be mapped to `nice-network`. And it has user’s `type` set to `local`. If user’s `type` is not defined, it defaults to `ephemeral`.
需要创建一个映射，以将客户端证书 `Subject DN` 中的用户映射为用户，以生成有效的本地用户（如果用户在映射 `local` 中 `type` 定义）。例如，在以下示例中，客户端证书的 `Subject DN` as `CN=alex,OU=eng,O=nice-network,L=Sunnyvale, ST=California,C=US` 将映射到 ''alex'' 并将 `domain_name` 映射到 `nice-network` 。 `user_name` 并且它将用户 `type` 设置为 `local` .如果未定义 user's `type` ，则默认为 `ephemeral` 。

Please refer to [mod_ssl](http://httpd.apache.org/docs/current/mod/mod_ssl.html) for the detailed mapping attributes.
有关详细的映射属性，请参阅mod_ssl。

```
[
    {
        "local": [
            {
                "user": {
                    "name": "{0}",
                    "domain": {
                        "name": "{1}"
                    },
                    "type": "local"
                }
            }
        ],
        "remote": [
            {
                "type": "SSL_CLIENT_S_DN_CN",
                "whitelist": ["glance", "nova", "swift", "neutron"]
            },
            {
                 "type": "SSL_CLIENT_S_DN_O",
                 "whitelist": ["Default"]
            }
        ]
    }
]
```

When user’s `type` is not defined or set to `ephemeral`, the mapped user does not have to be a valid local user but the mapping must yield at least one valid local group. For example:
当 user's `type` 未定义或设置为 `ephemeral` 时，映射的用户不必是有效的本地用户，但映射必须至少生成一个有效的本地组。例如：

```
[
    {
        "local": [
            {
                "user": {
                    "name": "{0}",
                    "type": "ephemeral"
                },
                "group": {
                    "domain": {
                        "name": "{1}"
                    },
                    "name": "openstack_services"
                }
            }
        ],
        "remote": [
            {
                "type": "SSL_CLIENT_S_DN_CN",
                "whitelist": ["glance", "nova", "swift", "neutron"]
            },
            {
                 "type": "SSL_CLIENT_S_DN_O",
                 "whitelist": ["Default"]
            }
        ]
    }
]
```



 

Note 注意



The above mapping assume openstack_services group already exist and have the proper role assignments (i.e. allow token validation) If not, it will need to be created.
上面的映射假定openstack_services组已存在，并且具有适当的角色分配（即允许令牌验证） 如果没有，则需要创建它。

To create a mapping using OpenStack CLI, assuming the mapping is saved into a file `x509_tokenless_mapping.json`:
要使用 OpenStack CLI 创建映射，假设映射已保存到文件中 `x509_tokenless_mapping.json` ：

```
$ openstack mapping create --rules x509_tokenless_mapping.json x509_tokenless
```



 

Note 注意



The mapping ID is arbitrary and it can be any string as opposed to IDP ID.
映射 ID 是任意的，它可以是任何字符串，而不是 IDP ID。

### Create a Protocol[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#create-a-protocol) 创建协议 ¶

The name of the protocol must be the same as the one specified by the `protocol` option in `tokenless_auth` section of the Keystone configuration file. The protocol name is user designed and it can be any name as opposed to IDP ID.
协议的名称必须与 Keystone 配置文件部分中的 `protocol`  `tokenless_auth` 选项指定的协议名称相同。协议名称是用户设计的，可以是任何名称，而不是 IDP ID。

A protocol name and an IDP ID will uniquely identify a mapping.
协议名称和 IDP ID 将唯一标识映射。

To create a protocol using OpenStack CLI:
要使用 OpenStack CLI 创建协议，请执行以下操作：

```
$ openstack federation protocol create --identity-provider <IDP ID>
  --mapping x509_tokenless x509
```



 

Note 注意



If there are multiple trusted issuers, there must be multiple protocol created, one for each IDP. All IDP can share a same mapping but the combination of IDP ID and protocol must be unique.
如果有多个受信任的颁发者，则必须创建多个协议，每个 IDP 一个协议。所有 IDP 可以共享相同的映射，但 IDP ID 和协议的组合必须是唯一的。

## SSL Terminator Configuration[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#ssl-terminator-configuration) SSL 终结器配置 ¶

### Apache Configuration[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#apache-configuration) Apache 配置 ¶

If SSL terminates at Apache mod_ssl, Apache must be configured to handle two-way SSL and pass the SSL certificate information to the Keystone application as part of the request environment.
如果 SSL 在 Apache mod_ssl终止，则必须将 Apache 配置为处理双向 SSL，并将 SSL 证书信息作为请求环境的一部分传递给 Keystone 应用程序。

The Client authentication attribute `SSLVerifyClient` should be set as `optional` to allow other token authentication methods and attribute `SSLOptions` needs to set as `+StdEnvVars` to allow certificate attributes to be passed. For example,
客户端身份验证属性 `SSLVerifyClient` 应设置为 `optional` 允许其他令牌身份验证方法，属性 `SSLOptions` 需要设置为 `+StdEnvVars` 允许传递证书属性。例如

```
<VirtualHost *:443>
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    ErrorLog /var/log/apache2/keystone.log
    CustomLog /var/log/apache2/access.log combined
    SSLEngine on
    SSLCertificateFile    /etc/apache2/ssl/apache.cer
    SSLCertificateKeyFile /etc/apache2/ssl/apache.key
    SSLCACertificatePath /etc/apache2/capath
    SSLOptions +StdEnvVars
    SSLVerifyClient optional
</VirtualHost>
```

### HAProxy and Apache Configuration[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#haproxy-and-apache-configuration) HAProxy 和 Apache 配置 ¶

If SSL terminates at HAProxy and Apache is the API proxy for the Keystone application, HAProxy must configured to handle two-way SSL and convey the SSL certificate information via the request headers. Apache in turn will need to bring those request headers into the request environment.
如果 SSL 在 HAProxy 终止，并且 Apache 是 Keystone 应用程序的 API 代理，则 HAProxy 必须配置为处理双向 SSL 并通过请求标头传达 SSL 证书信息。反过来，Apache 需要将这些请求标头引入请求环境。

Here’s an example on how to configure HAProxy to handle two-way SSL and pass the SSL certificate information via the request headers.
下面是一个示例，说明如何配置 HAProxy 以处理双向 SSL 并通过请求标头传递 SSL 证书信息。

```
frontend http-frontend
    mode http
    option forwardfor
    bind 10.1.1.1:5000 ssl crt /etc/keystone/ssl/keystone.pem ca-file /etc/keystone/ssl/ca.pem verify optional

    reqadd X-Forwarded-Proto:\ https if { ssl_fc }
    http-request set-header X-SSL                   %[ssl_fc]
    http-request set-header X-SSL-Client-Verify     %[ssl_c_verify]
    http-request set-header X-SSL-Client-SHA1       %{+Q}[ssl_c_sha1]
    http-request set-header X-SSL-Client-DN         %{+Q}[ssl_c_s_dn]
    http-request set-header X-SSL-Client-CN         %{+Q}[ssl_c_s_dn(cn)]
    http-request set-header X-SSL-Client-O          %{+Q}[ssl_c_s_dn(o)]
    http-request set-header X-SSL-Issuer            %{+Q}[ssl_c_i_dn]
    http-request set-header X-SSL-Issuer-CN         %{+Q}[ssl_c_i_dn(cn)]
```

When the request gets to the Apache Keystone API Proxy, Apache will need to bring those SSL headers into the request environment. Here’s an example on how to configure Apache to achieve that.
当请求到达 Apache Keystone API 代理时，Apache 需要将这些 SSL 标头引入请求环境。下面是一个关于如何配置 Apache 以实现此目的的示例。

```
<VirtualHost 192.168.0.10:5000>
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main

    # Bring the needed SSL certificate attributes from HAProxy into the
    # request environment
    SetEnvIf X-SSL-Issuer "^(.*)$" SSL_CLIENT_I_DN=$0
    SetEnvIf X-SSL-Issuer-CN "^(.*)$" SSL_CLIENT_I_DN_CN=$0
    SetEnvIf X-SSL-Client-CN "^(.*)$" SSL_CLIENT_S_DN_CN=$0
    SetEnvIf X-SSL-Client-O "^(.*)$" SSL_CLIENT_S_DN_O=$0
</VirtualHost>
```

## Setup `auth_token` middleware[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#setup-auth-token-middleware) 设置 `auth_token` 中间件 ¶

In order to use `auth_token` middleware as the service client for X.509 tokenless authorization, both configurable options and scope information will need to be setup.
为了使用 `auth_token` 中间件作为 X.509 无令牌授权的服务客户端，需要设置可配置选项和范围信息。

### Configurable Options[¶](https://docs.openstack.org/keystone/yoga/admin/configure_tokenless_x509.html#configurable-options) 可配置选项 ¶

The following configurable options in `auth_token` middleware should set to the correct values:
中间件中的 `auth_token` 以下可配置选项应设置为正确的值：

- `auth_type` - Must set to `v3tokenlessauth`.
   `auth_type` - 必须设置为 `v3tokenlessauth` 。
- `certfile` - Set to the full path of the certificate file.
   `certfile` - 设置为证书文件的完整路径。
- `keyfile` - Set to the full path of the private key file.
   `keyfile` - 设置为私钥文件的完整路径。
- `cafile` - Set to the full path of the trusted CA certificate file.
   `cafile` - 设置为受信任的 CA 证书文件的完整路径。
- `project_name` or `project_id` - set to the scoped project.
   `project_name` 或 `project_id` - 设置为作用域内的项目。
- `project_domain_name` or `project_domain_id` - if `project_name` is specified.
   `project_domain_name` 或者 `project_domain_id` - 如果 `project_name` 指定。

Here’s an example of `auth_token` middleware configuration using X.509 tokenless authorization for user token validation.
下面是使用 X.509 无令牌授权进行用户令牌验证的 `auth_token` 中间件配置示例。

```
[keystone_authtoken]
memcached_servers = localhost:11211
cafile = /etc/keystone/ca.pem
project_domain_name = Default
project_name = service
auth_url = https://192.168.0.10/identity/v3
auth_type = v3tokenlessauth
certfile = /etc/glance/certs/glance.pem
keyfile = /etc/glance/private/glance_private_key.pem
```

# OAuth1 1.0a OAuth1 1.0a 版本

​                                          

The OAuth 1.0a feature provides the ability for Identity users to delegate roles to third party consumers via the OAuth 1.0a specification.
OAuth 1.0a 功能使 Identity 用户能够通过 OAuth 1.0a 规范将角色委派给第三方使用者。

To enable OAuth1: 要启用 OAuth1，请执行以下操作：

1. Add the oauth1 driver to the `[oauth1]` section in `keystone.conf`. For example:
   将 oauth1 驱动程序添加到 中 `[oauth1]` `keystone.conf` 的部分。例如：

```
[oauth1]
driver = sql
```

1. Add the `oauth1` authentication method to the `[auth]` section in `keystone.conf`:
   将 `oauth1` 身份验证方法添加到以下 `[auth]` `keystone.conf` 部分：

```
[auth]
methods = external,password,token,oauth1
```

1. If deploying under Apache httpd with `mod_wsgi`, set the WSGIPassAuthorization to allow the OAuth Authorization headers to pass through mod_wsgi. For example, add the following to the keystone virtual host file:
   如果在 Apache httpd 下部署，则使用 `mod_wsgi` ，设置 WSGIPassAuthorization 以允许 OAuth Authorization 标头通过mod_wsgi。例如，将以下内容添加到 keystone 虚拟主机文件：

```
WSGIPassAuthorization On
```

See [API Specification for OAuth 1.0a](https://docs.openstack.org/api-ref/identity/v3-ext/index.html#os-oauth1-api) for the details of API definition.
有关 API 定义的详细信息，请参阅 OAuth 1.0a 的 API 规范。

# API Configuration options API 配置选项

​                                          

## Configuration[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#configuration) 配置 ¶

The Identity service is configured in the `/etc/keystone/keystone.conf` file.
身份服务在 `/etc/keystone/keystone.conf` 文件中配置。

The following tables provide a comprehensive list of the Identity service options.
下表提供了 Identity 服务选项的完整列表。

For a sample configuration file, refer to [keystone.conf](https://docs.openstack.org/keystone/yoga/configuration/samples/keystone-conf.html).
有关示例配置文件，请参阅 keystone.conf。



### DEFAULT[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#default) 默认 ¶

- debug[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.debug) 调试 ¶

  Type 类型 boolean 布尔 Default 违约 `False` Mutable 可变 This option can be changed without restarting. 此选项无需重新启动即可更改。  If set to true, the logging level will be set to DEBUG instead of the default INFO level. 如果设置为 true，则日志记录级别将设置为 DEBUG，而不是默认的 INFO 级别。

- log_config_append[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_config_append)

  Type 类型 string 字符串 Default 违约 `<None>` Mutable 可变 This option can be changed without restarting. 此选项无需重新启动即可更改。  The name of a logging configuration file. This file is appended to any  existing logging configuration files. For details about logging  configuration files, see the Python logging module documentation. Note  that when logging configuration files are used then all logging  configuration is set in the configuration file and other logging  configuration options are ignored (for example, log-date-format). 日志记录配置文件的名称。此文件将追加到任何现有的日志记录配置文件中。有关日志记录配置文件的详细信息，请参阅 Python  日志记录模块文档。请注意，使用日志记录配置文件时，将在配置文件中设置所有日志记录配置，并忽略其他日志记录配置选项（例如，log-date-format）。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id1) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 log-config 日志配置 DEFAULT 违约 log_config

- log_date_format[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_date_format)

  Type 类型 string 字符串 Default 违约 `%Y-%m-%d %H:%M:%S`  Defines the format string for %(asctime)s in log records. Default: the value  above . This option is ignored if log_config_append is set. 定义日志记录中 %（asctime）s 的格式字符串。默认值：上面的值。如果设置了此选项log_config_append则忽略此选项。

- log_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_file)

  Type 类型 string 字符串 Default 违约 `<None>`  (Optional) Name of log file to send logging output to. If no default is set,  logging will go to stderr as defined by use_stderr. This option is  ignored if log_config_append is set. （可选）要将日志记录输出发送到的日志文件的名称。如果未设置默认值，则日志记录将转到 use_stderr 定义的 stderr。如果设置了此选项log_config_append则忽略此选项。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id2) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 logfile 日志文件

- log_dir[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_dir)

  Type 类型 string 字符串 Default 违约 `<None>`  (Optional) The base directory used for relative log_file  paths. This option is ignored if log_config_append is set. （可选）用于相对log_file路径的基目录。如果设置了此选项log_config_append则忽略此选项。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id3) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 logdir

- watch_log_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.watch_log_file)

  Type 类型 boolean 布尔 Default 违约 `False`  Uses logging handler designed to watch file system. When log file is moved  or removed this handler will open a new log file with specified path  instantaneously. It makes sense only if log_file option is specified and Linux platform is used. This option is ignored if log_config_append is  set. 使用旨在监视文件系统的日志记录处理程序。移动或删除日志文件时，此处理程序将立即打开具有指定路径的新日志文件。仅当指定log_file选项并使用 Linux 平台时才有意义。如果设置了此选项log_config_append则忽略此选项。

- use_syslog[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.use_syslog)

  Type 类型 boolean 布尔 Default 违约 `False`  Use syslog for logging. Existing syslog format is DEPRECATED and will be  changed later to honor RFC5424. This option is ignored if  log_config_append is set. 使用 syslog 进行日志记录。现有的 syslog 格式已弃用，稍后将进行更改以遵守RFC5424。如果设置了此选项log_config_append则忽略此选项。

- use_journal[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.use_journal)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable journald for logging. If running in a systemd environment you may wish  to enable journal support. Doing so will use the journal native protocol which includes structured metadata in addition to log messages.This  option is ignored if log_config_append is set. 启用 journald 进行日志记录。如果在 systemd 环境中运行，您可能希望启用日志支持。这样做将使用日志本机协议，该协议除了日志消息外，还包括结构化元数据。如果设置了此选项log_config_append则忽略此选项。

- syslog_log_facility[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.syslog_log_facility)

  Type 类型 string 字符串 Default 违约 `LOG_USER`  Syslog facility to receive log lines. This option is ignored if log_config_append is set. 用于接收日志行的 Syslog 工具。如果设置了此选项log_config_append则忽略此选项。

- use_json[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.use_json)

  Type 类型 boolean 布尔 Default 违约 `False`  Use JSON formatting for logging. This option is ignored if log_config_append is set. 使用 JSON 格式进行日志记录。如果设置了此选项log_config_append则忽略此选项。

- use_stderr[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.use_stderr)

  Type 类型 boolean 布尔 Default 违约 `False`  Log output to standard error. This option is ignored if log_config_append is set. 将输出记录为标准错误。如果设置了此选项log_config_append则忽略此选项。

- use_eventlog[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.use_eventlog)

  Type 类型 boolean 布尔 Default 违约 `False`  Log output to Windows Event Log. 将输出记录到 Windows 事件日志。

- log_rotate_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_rotate_interval)

  Type 类型 integer 整数 Default 违约 `1`  The amount of time before the log files are rotated. This option is ignored unless log_rotation_type is set to “interval”. 轮换日志文件之前的时间量。除非log_rotation_type设置为“interval”，否则将忽略此选项。

- log_rotate_interval_type[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_rotate_interval_type)

  Type 类型 string 字符串 Default 违约 `days` Valid Values 有效值 Seconds, Minutes, Hours, Days, Weekday, Midnight 秒、分、时、日、平日、午夜  Rotation interval type. The time of the last file change (or the time when the  service was started) is used when scheduling the next rotation. 轮换间隔类型。在计划下一次轮换时，将使用上次文件更改的时间（或服务启动的时间）。

- max_logfile_count[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.max_logfile_count)

  Type 类型 integer 整数 Default 违约 `30`  Maximum number of rotated log files. 轮换日志文件的最大数量。

- max_logfile_size_mb[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.max_logfile_size_mb)

  Type 类型 integer 整数 Default 违约 `200`  Log file maximum size in MB. This option is ignored if “log_rotation_type” is not set to “size”. 日志文件的最大大小（以 MB 为单位）。如果“log_rotation_type”未设置为“size”，则忽略此选项。

- log_rotation_type[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.log_rotation_type)

  Type 类型 string 字符串 Default 违约 `none` Valid Values 有效值 interval, size, none 间隔、大小、无  Log rotation type. 日志轮换类型。 Possible values 可能的值 interval 间隔Rotate logs at predefined time intervals. 按预定义的时间间隔轮换日志。 size 大小Rotate logs once they reach a predefined size. 一旦日志达到预定义的大小，就轮换日志。 none 没有Do not rotate log files. 不要轮换日志文件。

- logging_context_format_string[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.logging_context_format_string)

  Type 类型 string 字符串 Default 违约 `%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s`  Format string to use for log messages with context. Used by oslo_log.formatters.ContextFormatter 设置字符串格式以用于具有上下文的日志消息。由 oslo_log.formatters.ContextFormatter 使用

- logging_default_format_string[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.logging_default_format_string)

  Type 类型 string 字符串 Default 违约 `%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s`  Format string to use for log messages when context is undefined. Used by oslo_log.formatters.ContextFormatter 在未定义上下文时用于日志消息的格式字符串。由 oslo_log.formatters.ContextFormatter 使用

- logging_debug_format_suffix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.logging_debug_format_suffix)

  Type 类型 string 字符串 Default 违约 `%(funcName)s %(pathname)s:%(lineno)d`  Additional data to append to log message when logging level for the message is  DEBUG. Used by oslo_log.formatters.ContextFormatter 当消息的日志记录级别为 DEBUG 时，要追加到日志消息的其他数据。由 oslo_log.formatters.ContextFormatter 使用

- logging_exception_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.logging_exception_prefix)

  Type 类型 string 字符串 Default 违约 `%(asctime)s.%(msecs)03d %(process)d ERROR %(name)s %(instance)s`  Prefix each line of exception output with this format. Used by oslo_log.formatters.ContextFormatter 在异常输出的每一行前面加上此格式。由 oslo_log.formatters.ContextFormatter 使用

- logging_user_identity_format[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.logging_user_identity_format)

  Type 类型 string 字符串 Default 违约 `%(user)s %(project)s %(domain)s %(user_domain)s %(project_domain)s`  Defines the format string for %(user_identity)s that is used in  logging_context_format_string. Used by  oslo_log.formatters.ContextFormatter 定义 logging_context_format_string 中使用的 %（user_identity）s 的格式字符串。由 oslo_log.formatters.ContextFormatter 使用

- default_log_levels[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.default_log_levels)

  Type 类型 list 列表 Default 违约 `['amqp=WARN', 'amqplib=WARN', 'boto=WARN', 'qpid=WARN', 'sqlalchemy=WARN', 'suds=INFO', 'oslo.messaging=INFO', 'oslo_messaging=INFO', 'iso8601=WARN', 'requests.packages.urllib3.connectionpool=WARN', 'urllib3.connectionpool=WARN', 'websocket=WARN', 'requests.packages.urllib3.util.retry=WARN', 'urllib3.util.retry=WARN', 'keystonemiddleware=WARN', 'routes.middleware=WARN', 'stevedore=WARN', 'taskflow=WARN', 'keystoneauth=WARN', 'oslo.cache=INFO', 'oslo_policy=INFO', 'dogpile.core.dogpile=INFO']`  List of package logging levels in logger=LEVEL pairs. This option is ignored if log_config_append is set. logger=LEVEL 对中的包日志记录级别列表。如果设置了此选项log_config_append则忽略此选项。

- publish_errors[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.publish_errors)

  Type 类型 boolean 布尔 Default 违约 `False`  Enables or disables publication of error events. 启用或禁用错误事件的发布。

- instance_format[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.instance_format)

  Type 类型 string 字符串 Default 违约 `"[instance: %(uuid)s] "`  The format for an instance that is passed with the log message. 与日志消息一起传递的实例的格式。

- instance_uuid_format[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.instance_uuid_format)

  Type 类型 string 字符串 Default 违约 `"[instance: %(uuid)s] "`  The format for an instance UUID that is passed with the log message. 与日志消息一起传递的实例 UUID 的格式。

- rate_limit_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.rate_limit_interval)

  Type 类型 integer 整数 Default 违约 `0`  Interval, number of seconds, of log rate limiting. 对数速率限制的间隔、秒数。

- rate_limit_burst[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.rate_limit_burst)

  Type 类型 integer 整数 Default 违约 `0`  Maximum number of logged messages per rate_limit_interval. 每个rate_limit_interval记录的最大消息数。

- rate_limit_except_level[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.rate_limit_except_level)

  Type 类型 string 字符串 Default 违约 `CRITICAL`  Log level name used by rate limiting: CRITICAL, ERROR, INFO, WARNING, DEBUG or empty string. Logs with level greater or equal to  rate_limit_except_level are not filtered. An empty string means that all levels are filtered. 速率限制使用的日志级别名称：CRITICAL、ERROR、INFO、WARNING、DEBUG 或空字符串。级别大于或等于 rate_limit_except_level 的日志不会被过滤。空字符串表示筛选所有级别。

- fatal_deprecations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.fatal_deprecations)

  Type 类型 boolean 布尔 Default 违约 `False`  Enables or disables fatal status of deprecations. 启用或禁用弃用的致命状态。

- rpc_conn_pool_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.rpc_conn_pool_size)

  Type 类型 integer 整数 Default 违约 `30` Minimum Value 最小值 1  Size of RPC connection pool. RPC 连接池的大小。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id4) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 rpc_conn_pool_size

- conn_pool_min_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.conn_pool_min_size)

  Type 类型 integer 整数 Default 违约 `2`  The pool size limit for connections expiration policy 连接过期策略的池大小限制

- conn_pool_ttl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.conn_pool_ttl)

  Type 类型 integer 整数 Default 违约 `1200`  The time-to-live in sec of idle connections in the pool 池中空闲连接的生存时间（以秒为单位）

- executor_thread_pool_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.executor_thread_pool_size)

  Type 类型 integer 整数 Default 违约 `64`  Size of executor thread pool when executor is threading or eventlet. 当执行程序是线程或 eventlet 时，执行程序线程池的大小。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id5) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 rpc_thread_pool_size

- rpc_response_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.rpc_response_timeout)

  Type 类型 integer 整数 Default 违约 `60`  Seconds to wait for a response from a call. 等待呼叫响应的秒数。

- transport_url[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.transport_url)

  Type 类型 string 字符串 Default 违约 `rabbit://`  The network address and optional user credentials for connecting to the  messaging backend, in URL format. The expected format is: 用于连接到消息传递后端的网络地址和可选用户凭据，采用 URL 格式。预期格式为： driver://[user:pass@]host:port[,[userN:passN@]hostN:portN]/virtual_host?query Example: rabbit://rabbitmq:password@127.0.0.1:5672// 示例：rabbit://rabbitmq:password@127.0.0.1:5672// For full details on the fields in the URL see the documentation of oslo_messaging.TransportURL at https://docs.openstack.org/oslo.messaging/latest/reference/transport.html 有关 URL 中字段的完整详细信息，请参阅 oslo_messaging 文档。位于  https://docs.openstack.org/oslo.messaging/latest/reference/transport.html 的 TransportURL

- control_exchange[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.control_exchange)

  Type 类型 string 字符串 Default 违约 `keystone`  The default exchange under which topics are scoped. May be overridden by an exchange name specified in the transport_url option. 主题范围限定的默认交换。可以被 transport_url 选项中指定的交换名称覆盖。

- rpc_ping_enabled[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.rpc_ping_enabled)

  Type 类型 boolean 布尔 Default 违约 `False`  Add an endpoint to answer to ping calls. Endpoint is named oslo_rpc_server_ping 添加终结点以应答 ping 呼叫。终结点命名为 oslo_rpc_server_ping

- admin_token[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.admin_token)

  Type 类型 string 字符串 Default 违约 `<None>`  Using this feature is *NOT* recommended. Instead, use the keystone-manage bootstrap command. The value of this option is treated as a “shared secret” that  can be used to bootstrap Keystone through the API. This “token” does not represent a user (it has no identity), and carries no explicit  authorization (it effectively bypasses most authorization checks). If  set to None, the value is ignored and the admin_token middleware is effectively disabled. 不建议使用此功能。请改用 keystone-manage 引导程序命令。此选项的值被视为“共享密钥”，可用于通过 API 引导  Keystone。这个“令牌”不代表用户（它没有身份），也没有显式授权（它有效地绕过了大多数授权检查）。如果设置为  None，则忽略该值，并有效禁用admin_token中间件。

- public_endpoint[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.public_endpoint)

  Type 类型 URI Default 违约 `<None>`  The base public endpoint URL for Keystone that is advertised to clients  (NOTE: this does NOT affect how Keystone listens for connections).  Defaults to the base host URL of the request. For example, if keystone  receives a request to http://server:5000/v3/users, then this will option will be automatically treated as http://server:5000. You should only need to set option if either the value of the base URL  contains a path that keystone does not automatically infer (/prefix/v3), or if the endpoint should be found on a different host. 通告给客户端的 Keystone 的基本公共终结点 URL（注意：这不会影响 Keystone 侦听连接的方式）。默认为请求的基本主机 URL。例如，如果  keystone 收到 http://server:5000/v3/users 请求，则此 will 选项将自动被视为  http://server:5000。仅当基 URL 的值包含 keystone 不会自动推断的路径 （/prefix/v3）  时，或者应在其他主机上找到终结点时，才需要设置选项。

- max_project_tree_depth[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.max_project_tree_depth)

  Type 类型 integer 整数 Default 违约 `5`  Maximum depth of the project hierarchy, excluding the project acting as a  domain at the top of the hierarchy. WARNING: Setting it to a large value may adversely impact performance. 项目层次结构的最大深度，不包括充当层次结构顶部域的项目。警告：将其设置为较大的值可能会对性能产生不利影响。

- max_param_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.max_param_size)

  Type 类型 integer 整数 Default 违约 `64`  Limit the sizes of user & project ID/names. 限制用户和项目 ID/名称的大小。

- max_token_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.max_token_size)

  Type 类型 integer 整数 Default 违约 `255`  Similar to [DEFAULT] max_param_size, but provides an exception for token values. With Fernet tokens, this can be set as low as 255. 类似于 [DEFAULT] max_param_size，但为令牌值提供了例外。使用 Fernet 代币，这可以设置为低至 255。

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  The maximum number of entities that will be returned in a collection. This  global limit may be then overridden for a specific driver, by specifying a list_limit in the appropriate section (for example, [assignment]). No limit is set by default. In larger deployments, it is recommended  that you set this to a reasonable number to prevent operations like  listing all users and projects from placing an unnecessary load on the  system. 集合中将返回的最大实体数。然后，可以通过在相应部分中指定list_limit（例如，[assignment]）来覆盖特定驱动程序的此全局限制。默认情况下不设置任何限制。在较大的部署中，建议将此值设置为合理的数字，以防止列出所有用户和项目等操作在系统上施加不必要的负载。

- strict_password_check[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.strict_password_check)

  Type 类型 boolean 布尔 Default 违约 `False`  If set to true, strict password length checking is performed for password  manipulation. If a password exceeds the maximum length, the operation  will fail with an HTTP 403 Forbidden error. If set to false, passwords  are automatically truncated to the maximum length. 如果设置为 true，则对密码操作执行严格的密码长度检查。如果密码超过最大长度，操作将失败，并显示 HTTP 403 禁止访问错误。如果设置为 false，则密码将自动截断为最大长度。

- insecure_debug[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.insecure_debug)

  Type 类型 boolean 布尔 Default 违约 `False`  If set to true, then the server will return information in HTTP responses  that may allow an unauthenticated or authenticated user to get more  information than normal, such as additional details about why  authentication failed. This may be useful for debugging but is insecure. 如果设置为 true，则服务器将在 HTTP 响应中返回信息，这些信息可能允许未经身份验证或经过身份验证的用户获取比正常情况更多的信息，例如有关身份验证失败原因的其他详细信息。这对于调试可能很有用，但不安全。

- default_publisher_id[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.default_publisher_id)

  Type 类型 string 字符串 Default 违约 `<None>`  Default publisher_id for outgoing notifications. If left undefined, Keystone will default to using the server’s host name. 传出通知的默认publisher_id。如果未定义，Keystone 将默认使用服务器的主机名。

- notification_format[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.notification_format)

  Type 类型 string 字符串 Default 违约 `cadf` Valid Values 有效值 basic, cadf 基本型， CADF  Define the notification format for identity service events. A basic notification only has information about the resource being operated on. A cadf notification has the same information, as well as information about the initiator of the event. The cadf option is entirely backwards compatible with the basic option, but is fully CADF-compliant, and is recommended for auditing use cases. 定义标识服务事件的通知格式。基本通知仅包含有关正在操作的资源的信息。cadf 通知具有相同的信息，以及有关事件发起者的信息。cadf 选项与基本选项完全向后兼容，但完全符合 CADF 标准，建议用于审计用例。

- notification_opt_out[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#DEFAULT.notification_opt_out)

  Type 类型 multi-valued 多值 Default 违约 `identity.authenticate.success` Default 违约 `identity.authenticate.pending` Default 违约 `identity.authenticate.failed`  You can reduce the number of notifications keystone emits by explicitly  opting out. Keystone will not emit notifications that match the patterns expressed in this list. Values are expected to be in the form of identity.<resource_type>.<operation>. By default, all notifications related to authentication are  automatically suppressed. This field can be set multiple times in order  to opt-out of multiple notification topics. For example, the following  suppresses notifications describing user creation or successful  authentication events: notification_opt_out=identity.user.create  notification_opt_out=identity.authenticate.success 您可以通过显式选择退出来减少 keystone 发出的通知数量。Keystone  不会发出与此列表中表示的模式匹配的通知。值应采用标识的形式。。。默认情况下，将自动禁止显示与身份验证相关的所有通知。此字段可以多次设置，以便选择退出多个通知主题。例如，以下内容禁止显示描述用户创建或成功身份验证事件的通知：notification_opt_out=identity.user.create notification_opt_out=identity.authenticate.success



### application_credential[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#application-credential)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#application_credential.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the application credential backend driver in the keystone.application_credential namespace.  Keystone only provides a sql driver, so there is no reason to change this unless you are providing a custom entry point. keystone.application_credential 命名空间中应用程序凭据后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此设置。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#application_credential.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for application credential caching. This has no effect unless global caching is enabled. 切换应用程序凭据缓存。除非启用全局缓存，否则这不起作用。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#application_credential.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>`  Time to cache application credential data in seconds. This has no effect unless global caching is enabled. 缓存应用程序凭据数据的时间（以秒为单位）。除非启用全局缓存，否则这不起作用。

- user_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#application_credential.user_limit)

  Type 类型 integer 整数 Default 违约 `-1`  Maximum number of application credentials a user is permitted to create. A  value of -1 means unlimited. If a limit is not set, users are permitted  to create application credentials at will, which could lead to bloat in  the keystone database or open keystone to a DoS attack. 允许用户创建的最大应用程序凭据数。值 -1 表示无限制。如果未设置限制，则允许用户随意创建应用程序凭据，这可能会导致 keystone 数据库膨胀或打开 keystone 攻击。



### assignment[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#assignment) 赋值 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#assignment.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the assignment backend driver (where role assignments are stored) in the keystone.assignment namespace. Only a SQL driver is supplied by keystone itself. Unless you are writing proprietary drivers for keystone, you do not need to set  this option. keystone.assignment 命名空间中分配后端驱动程序（存储角色分配的位置）的入口点。keystone 本身仅提供 SQL 驱动程序。除非您正在为 keystone 编写专有驱动程序，否则不需要设置此选项。

- prohibited_implied_role[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#assignment.prohibited_implied_role)

  Type 类型 list 列表 Default 违约 `['admin']`  A list of role names which are prohibited from being an implied role. 禁止作为隐含角色的角色名称列表。



### auth[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth) 身份验证 ¶

- methods[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.methods) 方法 ¶

  Type 类型 list 列表 Default 违约 `['external', 'password', 'token', 'oauth1', 'mapped', 'application_credential']`  Allowed authentication methods. Note: You should disable the external auth method if you are currently using federation. External auth and  federation both use the REMOTE_USER variable. Since both the mapped and  external plugin are being invoked to validate attributes in the request  environment, it can cause conflicts. 允许的身份验证方法。注意：如果您当前正在使用联合身份验证，则应禁用外部身份验证方法。外部身份验证和联合身份验证都使用 REMOTE_USER 变量。由于同时调用映射插件和外部插件来验证请求环境中的属性，因此可能会导致冲突。

- password[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.password) 密码 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the password auth plugin module in the keystone.auth.password namespace. You do not need to set this unless you are overriding keystone’s own password authentication plugin. keystone.auth.password 命名空间中密码身份验证插件模块的入口点。除非您覆盖 keystone 自己的密码身份验证插件，否则您不需要设置此设置。

- token[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.token) 令牌 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the token auth plugin module in the keystone.auth.token namespace. You do not need to set this unless you are overriding keystone’s own token authentication plugin. keystone.auth.token 命名空间中令牌身份验证插件模块的入口点。除非您覆盖 keystone 自己的令牌身份验证插件，否则您不需要设置此项。

- external[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.external) 外部 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the external (REMOTE_USER) auth plugin module in the keystone.auth.external namespace. Supplied drivers are DefaultDomain and Domain. The default driver is DefaultDomain, which assumes that all users identified by the username specified to keystone in the REMOTE_USER variable exist within the context of the default domain. The Domain option expects an additional environment variable be presented to keystone, REMOTE_DOMAIN, containing the domain name of the REMOTE_USER (if REMOTE_DOMAIN is not set, then the default domain will be used instead). You do not  need to set this unless you are taking advantage of “external  authentication”, where the application server (such as Apache) is  handling authentication instead of keystone. keystone.auth.external 命名空间中外部 （REMOTE_USER） 身份验证插件模块的入口点。提供的驱动程序是 DefaultDomain 和  Domain。默认驱动程序是 DefaultDomain，它假定由 REMOTE_USER 变量中指定为 keystone  的用户名标识的所有用户都存在于默认域的上下文中。“域”选项要求向 keystone  提供一个额外的环境变量，REMOTE_DOMAIN，其中包含REMOTE_USER的域名（如果未设置REMOTE_DOMAIN，则将改用默认域）。除非您利用“外部身份验证”，否则不需要设置此设置，其中应用程序服务器（如 Apache）正在处理身份验证而不是 keystone。

- oauth1[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.oauth1) OAuth1 （英语） ¶

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the OAuth 1.0a auth plugin module in the keystone.auth.oauth1 namespace. You do not need to set this unless you are overriding keystone’s own oauth1 authentication plugin. keystone.auth.oauth1 命名空间中 OAuth 1.0a 身份验证插件模块的入口点。除非您覆盖 keystone 自己的 oauth1 身份验证插件，否则您不需要设置此设置。

- mapped[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.mapped) 映射 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the mapped auth plugin module in the keystone.auth.mapped namespace. You do not need to set this unless you are overriding keystone’s own mapped authentication plugin. keystone.auth.mapped 命名空间中映射的身份验证插件模块的入口点。除非您要覆盖 keystone 自己的映射身份验证插件，否则您不需要设置此设置。

- application_credential[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#auth.application_credential)

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the application_credential auth plugin module in the keystone.auth.application_credential namespace. You do not need to set this unless you are overriding keystone’s own application_credential authentication plugin. keystone.auth.application_credential 命名空间中 application_credential 身份验证插件模块的入口点。除非您覆盖 keystone  自己的application_credential身份验证插件，否则您不需要设置此项。



### cache[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache) 缓存 ¶

- config_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.config_prefix)

  Type 类型 string 字符串 Default 违约 `cache.oslo`  Prefix for building the configuration dictionary for the cache region. This  should not need to be changed unless there is another dogpile.cache  region with the same configuration name. 用于为缓存区域构建配置字典的前缀。除非有另一个具有相同配置名称的 dogpile.cache 区域，否则不需要更改此值。

- expiration_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.expiration_time)

  Type 类型 integer 整数 Default 违约 `600`  Default TTL, in seconds, for any cached item in the dogpile.cache region. This  applies to any cached method that doesn’t have an explicit cache  expiration time defined for it. dogpile.cache 区域中任何缓存项的默认 TTL（以秒为单位）。这适用于未为其定义显式缓存过期时间的任何缓存方法。

- backend[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.backend) 后端 ¶

  Type 类型 string 字符串 Default 违约 `dogpile.cache.null` Valid Values 有效值 oslo_cache.memcache_pool, oslo_cache.dict, oslo_cache.mongo, oslo_cache.etcd3gw,  dogpile.cache.pymemcache, dogpile.cache.memcached,  dogpile.cache.pylibmc, dogpile.cache.bmemcached, dogpile.cache.dbm,  dogpile.cache.redis, dogpile.cache.memory, dogpile.cache.memory_pickle,  dogpile.cache.null oslo_cache.memcache_pool、oslo_cache.dict、oslo_cache.mongo、oslo_cache.etcd3gw、dogpile.cache.pymemcache、dogpile.cache.memcached、dogpile.cache.pylibmc、dogpile.cache.bmemcached、dogpile.cache.dbm、dogpile.cache.redis、dogpile.cache.memory、dogpile.cache.memory_pickle、dogpile.cache.null  Cache backend module. For eventlet-based or environments with hundreds of  threaded servers, Memcache with pooling (oslo_cache.memcache_pool) is  recommended. For environments with less than 100 threaded servers,  Memcached (dogpile.cache.memcached) or Redis (dogpile.cache.redis) is  recommended. Test environments with a single instance of the server can  use the dogpile.cache.memory backend. 缓存后端模块。对于基于 eventlet 或具有数百个线程服务器的环境，建议使用带池化 （oslo_cache.memcache_pool） 的  Memcache。对于线程服务器少于 100 个的环境，建议使用 Memcached （dogpile.cache.memcached） 或  Redis （dogpile.cache.redis）。具有单个服务器实例的测试环境可以使用 dogpile.cache.memory 后端。

- backend_argument[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.backend_argument)

  Type 类型 multi-valued 多值 Default 违约 `''`  Arguments supplied to the backend module. Specify this option once per argument  to be passed to the dogpile.cache backend. Example format:  “<argname>:<value>”. 提供给后端模块的参数。为要传递给 dogpile.cache 后端的每个参数指定一次此选项。示例格式：“：”。

- proxies[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.proxies) 代理 ¶

  Type 类型 list 列表 Default 违约 `[]`  Proxy classes to import that will affect the way the dogpile.cache backend  functions. See the dogpile.cache documentation on  changing-backend-behavior. 要导入的代理类将影响 dogpile.cache 后端的运行方式。请参阅有关 changing-backend-behavior 的 dogpile.cache 文档。

- enabled[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.enabled) 已启用 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Global toggle for caching. 用于缓存的全局切换。

- debug_cache_backend[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.debug_cache_backend)

  Type 类型 boolean 布尔 Default 违约 `False`  Extra debugging from the cache backend (cache keys, get/set/delete/etc  calls). This is only really useful if you need to see the specific  cache-backend get/set/delete calls with the keys/values.  Typically this should be left set to false. 从缓存后端进行额外调试（缓存键、get/set/delete/etc 调用）。仅当您需要查看带有键/值的特定缓存后端 get/set/delete 调用时，这才真正有用。通常，这应设置为 false。

- memcache_servers[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_servers)

  Type 类型 list 列表 Default 违约 `['localhost:11211']`  Memcache servers in the format of “host:port”. (dogpile.cache.memcached and  oslo_cache.memcache_pool backends only). If a given host refer to an  IPv6 or a given domain refer to IPv6 then you should prefix the given  address with the address family (`inet6`) (e.g `inet6[::1]:11211`, `inet6:[fd12:3456:789a:1::1]:11211`, `inet6:[controller-0.internalapi]:11211`). If the address family is not given then default address family used will be `inet` which correspond to IPv4 Memcache 服务器，格式为“host：port”。（仅限 dogpile.cache.memcached 和  oslo_cache.memcache_pool 后端）。如果给定主机引用 IPv6 或给定域引用 IPv6，则应在给定地址前面加上地址族 （ `inet6` ） （例如 `inet6[::1]:11211` ， `inet6:[fd12:3456:789a:1::1]:11211` ， `inet6:[controller-0.internalapi]:11211` ）。如果未给出地址系列，则使用的默认地址系列将与 `inet` IPv4 相对应

- memcache_dead_retry[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_dead_retry)

  Type 类型 integer 整数 Default 违约 `300`  Number of seconds memcached server is considered dead before it is tried  again. (dogpile.cache.memcache and oslo_cache.memcache_pool backends  only). memcached 服务器在重试之前被视为已死的秒数。（仅限 dogpile.cache.memcache 和 oslo_cache.memcache_pool 后端）。

- memcache_socket_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_socket_timeout)

  Type 类型 floating point 浮点 Default 违约 `1.0`  Timeout in seconds for every call to a server. (dogpile.cache.memcache and oslo_cache.memcache_pool backends only). 每次调用服务器的超时时间（以秒为单位）。（仅限 dogpile.cache.memcache 和 oslo_cache.memcache_pool 后端）。

- memcache_pool_maxsize[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_pool_maxsize)

  Type 类型 integer 整数 Default 违约 `10`  Max total number of open connections to every memcached server. (oslo_cache.memcache_pool backend only). 与每个 memcached 服务器的最大打开连接总数。（仅限 oslo_cache.memcache_pool 后端）。

- memcache_pool_unused_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_pool_unused_timeout)

  Type 类型 integer 整数 Default 违约 `60`  Number of seconds a connection to memcached is held unused in the pool before  it is closed. (oslo_cache.memcache_pool backend only). 在池中关闭之前，与 memcached 的连接在池中保持未使用的秒数。（仅限 oslo_cache.memcache_pool 后端）。

- memcache_pool_connection_get_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_pool_connection_get_timeout)

  Type 类型 integer 整数 Default 违约 `10`  Number of seconds that an operation will wait to get a memcache client connection. 操作等待获取 memcache 客户端连接的秒数。

- memcache_pool_flush_on_reconnect[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.memcache_pool_flush_on_reconnect)

  Type 类型 boolean 布尔 Default 违约 `False`  Global toggle if memcache will be flushed on reconnect. (oslo_cache.memcache_pool backend only). 如果 memcache 将在重新连接时刷新，则进行全局切换。（仅限 oslo_cache.memcache_pool 后端）。

- tls_enabled[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.tls_enabled)

  Type 类型 boolean 布尔 Default 违约 `False`  Global toggle for TLS usage when comunicating with the caching servers. 与缓存服务器通信时 TLS 使用的全局切换。

- tls_cafile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.tls_cafile)

  Type 类型 string 字符串 Default 违约 `<None>`  Path to a file of concatenated CA certificates in PEM format necessary to  establish the caching servers’ authenticity. If tls_enabled is False,  this option is ignored. 建立缓存服务器真实性所需的 PEM 格式的级联 CA 证书文件的路径。如果 tls_enabled 为 False，则忽略此选项。

- tls_certfile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.tls_certfile)

  Type 类型 string 字符串 Default 违约 `<None>`  Path to a single file in PEM format containing the client’s certificate as  well as any number of CA certificates needed to establish the  certificate’s authenticity. This file is only required when client side  authentication is necessary. If tls_enabled is False, this option is  ignored. PEM 格式的单个文件的路径，其中包含客户端的证书以及建立证书真实性所需的任意数量的 CA 证书。仅当需要客户端身份验证时，才需要此文件。如果 tls_enabled 为 False，则忽略此选项。

- tls_keyfile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.tls_keyfile)

  Type 类型 string 字符串 Default 违约 `<None>`  Path to a single file containing the client’s private key in. Otherwise the  private key will be taken from the file specified in tls_certfile. If  tls_enabled is False, this option is ignored. 包含客户端私钥的单个文件的路径。否则，将从tls_certfile中指定的文件中获取私钥。如果 tls_enabled 为 False，则忽略此选项。

- tls_allowed_ciphers[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.tls_allowed_ciphers)

  Type 类型 string 字符串 Default 违约 `<None>`  Set the available ciphers for sockets created with the TLS context. It  should be a string in the OpenSSL cipher list format. If not specified,  all OpenSSL enabled ciphers will be available. 为使用 TLS 上下文创建的套接字设置可用密码。它应该是 OpenSSL 密码列表格式的字符串。如果未指定，则所有启用 OpenSSL 的密码都将可用。

- enable_socket_keepalive[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.enable_socket_keepalive)

  Type 类型 boolean 布尔 Default 违约 `False`  Global toggle for the socket keepalive of dogpile’s pymemcache backend dogpile 的 pymemcache 后端的套接字保持活动的全局切换

- socket_keepalive_idle[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.socket_keepalive_idle)

  Type 类型 integer 整数 Default 违约 `1` Minimum Value 最小值 0  The time (in seconds) the connection needs to remain idle before TCP starts sending keepalive probes. Should be a positive integer most greater  than zero. 在 TCP 开始发送 keepalive 探测器之前，连接需要保持空闲的时间（以秒为单位）。应为最大大于零的正整数。

- socket_keepalive_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.socket_keepalive_interval)

  Type 类型 integer 整数 Default 违约 `1` Minimum Value 最小值 0  The time (in seconds) between individual keepalive probes. Should be a positive integer greater than zero. 各个 keepalive 探测器之间的时间（以秒为单位）。应为大于零的正整数。

- socket_keepalive_count[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.socket_keepalive_count)

  Type 类型 integer 整数 Default 违约 `1` Minimum Value 最小值 0  The maximum number of keepalive probes TCP should send before dropping the  connection. Should be a positive integer greater than zero. TCP 在断开连接之前应发送的最大 keepalive 探测器数。应为大于零的正整数。

- enable_retry_client[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.enable_retry_client)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable retry client mechanisms to handle failure. Those mechanisms can be used to wrap all kind of pymemcache clients. The wrapper allows you to  define how many attempts to make and how long to wait between attemots. 启用重试客户端机制以处理故障。这些机制可用于包装所有类型的 pymemcache 客户端。包装器允许您定义要进行多少次尝试以及在 attemot 之间等待多长时间。

- retry_attempts[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.retry_attempts)

  Type 类型 integer 整数 Default 违约 `2` Minimum Value 最小值 1  Number of times to attempt an action before failing. 在失败之前尝试操作的次数。

- retry_delay[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.retry_delay)

  Type 类型 floating point 浮点 Default 违约 `0`  Number of seconds to sleep between each attempt. 每次尝试之间的睡眠秒数。

- hashclient_retry_attempts[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.hashclient_retry_attempts)

  Type 类型 integer 整数 Default 违约 `2` Minimum Value 最小值 1  Amount of times a client should be tried before it is marked dead and removed  from the pool in the HashClient’s internal mechanisms. 在 HashClient 的内部机制中，客户端被标记为死机并从池中删除之前应尝试的次数。

- hashclient_retry_delay[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.hashclient_retry_delay)

  Type 类型 floating point 浮点 Default 违约 `1`  Time in seconds that should pass between retry attempts in the HashClient’s internal mechanisms. 在 HashClient 的内部机制中，重试尝试之间应经过的时间（以秒为单位）。

- dead_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cache.dead_timeout)

  Type 类型 floating point 浮点 Default 违约 `60`  Time in seconds before attempting to add a node back in the pool in the HashClient’s internal mechanisms. 在尝试在 HashClient 的内部机制中将节点添加回池中之前的时间（以秒为单位）。



### catalog[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#catalog) 目录 ¶

- template_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#catalog.template_file)

  Type 类型 string 字符串 Default 违约 `default_catalog.templates`  Absolute path to the file used for the templated catalog backend. This option is only used if the [catalog] driver is set to templated. 用于模板化目录后端的文件的绝对路径。仅当 [catalog] 驱动程序设置为模板化时，才使用此选项。

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#catalog.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the catalog driver in the keystone.catalog namespace. Keystone provides a sql option (which supports basic CRUD operations through SQL), a templated option (which loads the catalog from a templated catalog file on disk), and a endpoint_filter.sql option (which supports arbitrary service catalogs per project). keystone.catalog 命名空间中目录驱动程序的入口点。Keystone 提供了一个 sql 选项（支持通过 SQL 执行基本的 CRUD  操作）、一个模板化选项（从磁盘上的模板化目录文件加载目录）和一个endpoint_filter.sql选项（支持每个项目的任意服务目录）。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#catalog.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for catalog caching. This has no effect unless global caching is  enabled. In a typical deployment, there is no reason to disable this. 切换目录缓存。除非启用全局缓存，否则这不起作用。在典型部署中，没有理由禁用此功能。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#catalog.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>`  Time to cache catalog data (in seconds). This has no effect unless global  and catalog caching are both enabled. Catalog data (services, endpoints, etc.) typically does not change frequently, and so a longer duration  than the global default may be desirable. 缓存目录数据的时间（以秒为单位）。除非同时启用全局缓存和目录缓存，否则这不起作用。目录数据（服务、端点等）通常不会频繁更改，因此可能需要比全局默认值更长的持续时间。

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#catalog.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  Maximum number of entities that will be returned in a catalog collection. There is typically no reason to set this, as it would be unusual for a  deployment to have enough services or endpoints to exceed a reasonable  limit. 将在目录集合中返回的最大实体数。通常没有理由设置此值，因为部署具有足够的服务或终结点以超过合理限制是不寻常的。



### cors[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors)

- allowed_origin[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors.allowed_origin)

  Type 类型 list 列表 Default 违约 `<None>`  Indicate whether this resource may be shared with the domain received in the  requests “origin” header. Format:  “<protocol>://<host>[:<port>]”, no trailing slash.  Example: https://horizon.example.com 指示是否可以与请求“源”标头中接收的域共享此资源。格式：“：//[：]”，无尾斜杠。示例：https://horizon.example.com

- allow_credentials[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors.allow_credentials)

  Type 类型 boolean 布尔 Default 违约 `True`  Indicate that the actual request can include user credentials 指示实际请求可以包含用户凭据

- expose_headers[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors.expose_headers)

  Type 类型 list 列表 Default 违约 `['X-Auth-Token', 'X-Openstack-Request-Id', 'X-Subject-Token', 'Openstack-Auth-Receipt']`  Indicate which headers are safe to expose to the API. Defaults to HTTP Simple Headers. 指示哪些标头可以安全地向 API 公开。默认为 HTTP Simple 标头。

- max_age[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors.max_age)

  Type 类型 integer 整数 Default 违约 `3600`  Maximum cache age of CORS preflight requests. CORS 预检请求的最长缓存期限。

- allow_methods[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors.allow_methods)

  Type 类型 list 列表 Default 违约 `['GET', 'PUT', 'POST', 'DELETE', 'PATCH']`  Indicate which methods can be used during the actual request. 指示在实际请求期间可以使用的方法。

- allow_headers[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#cors.allow_headers)

  Type 类型 list 列表 Default 违约 `['X-Auth-Token', 'X-Openstack-Request-Id', 'X-Subject-Token', 'X-Project-Id', 'X-Project-Name', 'X-Project-Domain-Id', 'X-Project-Domain-Name', 'X-Domain-Id', 'X-Domain-Name', 'Openstack-Auth-Receipt']`  Indicate which header field names may be used during the actual request. 指示在实际请求期间可以使用哪些标头字段名称。



### credential[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential) 凭证 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the credential backend driver in the keystone.credential namespace. Keystone only provides a sql driver, so there’s no reason to change this unless you are providing a custom entry point. keystone.credential 命名空间中凭据后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此设置。

- provider[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.provider) 提供程序 ¶

  Type 类型 string 字符串 Default 违约 `fernet`  Entry point for credential encryption and decryption operations in the keystone.credential.provider namespace. Keystone only provides a fernet driver, so there’s no reason to change this unless you are providing a custom entry point to encrypt and decrypt credentials. keystone.credential.provider 命名空间中凭据加密和解密操作的入口点。Keystone 只提供 fernet 驱动程序，因此没有理由更改此设置，除非您提供自定义入口点来加密和解密凭据。

- key_repository[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.key_repository)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/credential-keys/`  Directory containing Fernet keys used to encrypt and decrypt credentials stored  in the credential backend. Fernet keys used to encrypt credentials have  no relationship to Fernet keys used to encrypt Fernet tokens. Both sets  of keys should be managed separately and require different rotation  policies. Do not share this repository with the repository used to  manage keys for Fernet tokens. 包含用于加密和解密存储在凭据后端中的凭据的 Fernet 密钥的目录。用于加密凭证的 Fernet 密钥与用于加密 Fernet 令牌的 Fernet  密钥没有关系。这两组密钥应单独管理，并且需要不同的轮换策略。不要与用于管理 Fernet 令牌密钥的存储库共享此存储库。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for caching only on retrieval of user credentials. This has no effect unless global caching is enabled. 仅在检索用户凭据时切换为缓存。除非启用全局缓存，否则这不起作用。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>`  Time to cache credential data in seconds. This has no effect unless global caching is enabled. 缓存凭据数据的时间（以秒为单位）。除非启用全局缓存，否则这不起作用。

- auth_ttl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.auth_ttl)

  Type 类型 integer 整数 Default 违约 `15`  The length of time in minutes for which a signed EC2 or S3 token request is valid from the timestamp contained in the token request. 签名的 EC2 或 S3 令牌请求从令牌请求中包含的时间戳开始有效的时间长度（以分钟为单位）。

- user_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#credential.user_limit)

  Type 类型 integer 整数 Default 违约 `-1`  Maximum number of credentials a user is permitted to create. A value of -1  means unlimited. If a limit is not set, users are permitted to create  credentials at will, which could lead to bloat in the keystone database  or open keystone to a DoS attack. 允许用户创建的最大凭据数。值 -1 表示无限制。如果未设置限制，则允许用户随意创建凭据，这可能会导致 keystone 数据库膨胀或打开 keystone 进行 DoS 攻击。



### database[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database) 数据库 ¶

- sqlite_synchronous[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.sqlite_synchronous)

  Type 类型 boolean 布尔 Default 违约 `True`  If True, SQLite uses synchronous mode. 如果为 True，则 SQLite 使用同步模式。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id6) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sqlite_synchronous

- backend[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.backend) 后端 ¶

  Type 类型 string 字符串 Default 违约 `sqlalchemy`  The back end to use for the database. 用于数据库的后端。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id7) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 db_backend

- connection[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.connection) 连接 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  The SQLAlchemy connection string to use to connect to the database. 用于连接到数据库的 SQLAlchemy 连接字符串。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id8) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sql_connection DATABASE 数据库 sql_connection sql connection 连接

- slave_connection[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.slave_connection)

  Type 类型 string 字符串 Default 违约 `<None>`  The SQLAlchemy connection string to use to connect to the slave database. 用于连接到从属数据库的 SQLAlchemy 连接字符串。

- mysql_sql_mode[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.mysql_sql_mode)

  Type 类型 string 字符串 Default 违约 `TRADITIONAL`  The SQL mode to be used for MySQL sessions. This option, including the  default, overrides any server-set SQL mode. To use whatever SQL mode is  set by the server configuration, set this to no value. Example:  mysql_sql_mode= 用于 MySQL 会话的 SQL 模式。此选项（包括默认值）将覆盖任何服务器设置的 SQL 模式。若要使用服务器配置设置的任何 SQL 模式，请将其设置为无值。示例：mysql_sql_mode=

- mysql_enable_ndb[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.mysql_enable_ndb)

  Type 类型 boolean 布尔 Default 违约 `False`  If True, transparently enables support for handling MySQL Cluster (NDB). 如果为 True，则透明地启用对处理 MySQL 集群 （NDB） 的支持。

- connection_recycle_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.connection_recycle_time)

  Type 类型 integer 整数 Default 违约 `3600`  Connections which have been present in the connection pool longer than this number  of seconds will be replaced with a new one the next time they are  checked out from the pool. 连接池中存在的时间超过此秒数的连接将在下次从池中签出时替换为新连接。

- max_pool_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.max_pool_size)

  Type 类型 integer 整数 Default 违约 `5`  Maximum number of SQL connections to keep open in a pool. Setting a value of 0 indicates no limit. 池中要保持打开的最大 SQL 连接数。将值设置为 0 表示没有限制。

- max_retries[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.max_retries)

  Type 类型 integer 整数 Default 违约 `10`  Maximum number of database connection retries during startup. Set to -1 to specify an infinite retry count. 启动期间数据库连接重试的最大次数。设置为 -1 可指定无限重试计数。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id9) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sql_max_retries DATABASE 数据库 sql_max_retries

- retry_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.retry_interval)

  Type 类型 integer 整数 Default 违约 `10`  Interval between retries of opening a SQL connection. 打开 SQL 连接的重试次数间隔。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id10) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sql_retry_interval DATABASE 数据库 reconnect_interval

- max_overflow[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.max_overflow)

  Type 类型 integer 整数 Default 违约 `50`  If set, use this value for max_overflow with SQLAlchemy. 如果设置了此值，则将此值用于 SQLAlchemy 的max_overflow。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id11) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sql_max_overflow DATABASE 数据库 sqlalchemy_max_overflow

- connection_debug[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.connection_debug)

  Type 类型 integer 整数 Default 违约 `0` Minimum Value 最小值 0 Maximum Value 最大值 100  Verbosity of SQL debugging information: 0=None, 100=Everything. SQL 调试信息的详细程度：0=无，100=所有内容。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id12) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sql_connection_debug

- connection_trace[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.connection_trace)

  Type 类型 boolean 布尔 Default 违约 `False`  Add Python stack traces to SQL as comment strings. 将 Python 堆栈跟踪作为注释字符串添加到 SQL。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id13) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 sql_connection_trace

- pool_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.pool_timeout)

  Type 类型 integer 整数 Default 违约 `<None>`  If set, use this value for pool_timeout with SQLAlchemy. 如果设置了此值，则将此值用于 SQLAlchemy 的pool_timeout。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id14) 已弃用的变体 ¶   Group 群 Name 名字  DATABASE 数据库 sqlalchemy_pool_timeout

- use_db_reconnect[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.use_db_reconnect)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable the experimental use of database reconnect on connection lost. 启用在连接丢失时重新连接数据库的实验性使用。

- db_retry_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.db_retry_interval)

  Type 类型 integer 整数 Default 违约 `1`  Seconds between retries of a database transaction. 数据库事务重试之间的秒数。

- db_inc_retry_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.db_inc_retry_interval)

  Type 类型 boolean 布尔 Default 违约 `True`  If True, increases the interval between retries of a database operation up to db_max_retry_interval. 如果为 True，则将数据库操作的重试间隔增加到最多 db_max_retry_interval。

- db_max_retry_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.db_max_retry_interval)

  Type 类型 integer 整数 Default 违约 `10`  If db_inc_retry_interval is set, the maximum seconds between retries of a database operation. 如果设置了 db_inc_retry_interval，则为数据库操作重试之间的最大秒数。

- db_max_retries[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.db_max_retries)

  Type 类型 integer 整数 Default 违约 `20`  Maximum retries in case of connection error or deadlock error before error is  raised. Set to -1 to specify an infinite retry count. 在引发错误之前出现连接错误或死锁错误时的最大重试次数。设置为 -1 可指定无限重试计数。

- connection_parameters[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#database.connection_parameters)

  Type 类型 string 字符串 Default 违约 `''`  Optional URL parameters to append onto the connection URL at connect time; specify as param1=value1&param2=value2&… 可选的 URL 参数，用于在连接时附加到连接 URL;指定为 param1=value1¶m2=value2&...



### domain_config[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#domain-config)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#domain_config.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the domain-specific configuration driver in the keystone.resource.domain_config namespace. Only a sql option is provided by keystone, so there is no reason to set this unless you are providing a custom entry point. keystone.resource.domain_config 命名空间中特定于域的配置驱动程序的入口点。keystone 仅提供 sql 选项，因此除非您提供自定义入口点，否则没有理由设置此选项。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#domain_config.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for caching of the domain-specific configuration backend. This has no  effect unless global caching is enabled. There is normally no reason to  disable this. 切换以缓存特定于域的配置后端。除非启用全局缓存，否则这不起作用。通常没有理由禁用此功能。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#domain_config.cache_time)

  Type 类型 integer 整数 Default 违约 `300`  Time-to-live (TTL, in seconds) to cache domain-specific configuration data. This has no effect unless [domain_config] caching is enabled. 生存时间（TTL，以秒为单位）缓存特定于域的配置数据。除非启用 [domain_config] 缓存，否则这不起作用。



### endpoint_filter[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#endpoint-filter)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#endpoint_filter.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the endpoint filter driver in the keystone.endpoint_filter namespace. Only a sql option is provided by keystone, so there is no reason to set this unless you are providing a custom entry point. keystone.endpoint_filter命名空间中终结点筛选器驱动程序的入口点。keystone 仅提供 sql 选项，因此除非您提供自定义入口点，否则没有理由设置此选项。

- return_all_endpoints_if_no_filter[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#endpoint_filter.return_all_endpoints_if_no_filter)

  Type 类型 boolean 布尔 Default 违约 `True`  This controls keystone’s behavior if the configured endpoint filters do not  result in any endpoints for a user + project pair (and therefore a  potentially empty service catalog). If set to true, keystone will return the entire service catalog. If set to false, keystone will return an  empty service catalog. 如果配置的端点筛选器不会为用户 + 项目对（因此可能为空的服务目录）生成任何端点，这将控制 keystone 的行为。如果设置为 true，keystone 将返回整个服务目录。如果设置为 false，keystone 将返回一个空的服务目录。



### endpoint_policy[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#endpoint-policy)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#endpoint_policy.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the endpoint policy driver in the keystone.endpoint_policy namespace. Only a sql driver is provided by keystone, so there is no reason to set this unless you are providing a custom entry point. keystone.endpoint_policy 命名空间中终结点策略驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由设置此驱动程序。



### eventlet_server[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#eventlet-server)

- public_bind_host[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#eventlet_server.public_bind_host)

  Type 类型 host address 主机地址 Default 违约 `0.0.0.0`  The IP address of the network interface for the public service to listen on. 公共服务要侦听的网络接口的 IP 地址。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id15) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 bind_host DEFAULT 违约 public_bind_host   Warning 警告 This option is deprecated for removal since K. Its value may be silently ignored  in the future. 此选项已弃用，因为 K.它的价值将来可能会被默默地忽略。 Reason 原因 Support for running keystone under eventlet has been removed in the Newton  release. These options remain for backwards compatibility because they  are used for URL substitutions. 在 Newton 版本中，已删除对在 eventlet 下运行 keystone 的支持。这些选项保留为向后兼容性，因为它们用于 URL 替换。

- public_port[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#eventlet_server.public_port)

  Type 类型 port number 端口号 Default 违约 `5000` Minimum Value 最小值 0 Maximum Value 最大值 65535  The port number for the public service to listen on. 要侦听的公共服务的端口号。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id16) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 public_port   Warning 警告 This option is deprecated for removal since K. Its value may be silently ignored  in the future. 此选项已弃用，因为 K.它的价值将来可能会被默默地忽略。 Reason 原因 Support for running keystone under eventlet has been removed in the Newton  release. These options remain for backwards compatibility because they  are used for URL substitutions. 在 Newton 版本中，已删除对在 eventlet 下运行 keystone 的支持。这些选项保留为向后兼容性，因为它们用于 URL 替换。

- admin_bind_host[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#eventlet_server.admin_bind_host)

  Type 类型 host address 主机地址 Default 违约 `0.0.0.0`  The IP address of the network interface for the admin service to listen on. 管理服务要侦听的网络接口的 IP 地址。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id17) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 bind_host DEFAULT 违约 admin_bind_host   Warning 警告 This option is deprecated for removal since K. Its value may be silently ignored  in the future. 此选项已弃用，因为 K.它的价值将来可能会被默默地忽略。 Reason 原因 Support for running keystone under eventlet has been removed in the Newton  release. These options remain for backwards compatibility because they  are used for URL substitutions. 在 Newton 版本中，已删除对在 eventlet 下运行 keystone 的支持。这些选项保留为向后兼容性，因为它们用于 URL 替换。

- admin_port[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#eventlet_server.admin_port)

  Type 类型 port number 端口号 Default 违约 `35357` Minimum Value 最小值 0 Maximum Value 最大值 65535  The port number for the admin service to listen on. 要侦听的管理服务的端口号。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id18) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 admin_port   Warning 警告 This option is deprecated for removal since K. Its value may be silently ignored  in the future. 此选项已弃用，因为 K.它的价值将来可能会被默默地忽略。 Reason 原因 Support for running keystone under eventlet has been removed in the Newton  release. These options remain for backwards compatibility because they  are used for URL substitutions. 在 Newton 版本中，已删除对在 eventlet 下运行 keystone 的支持。这些选项保留为向后兼容性，因为它们用于 URL 替换。



### federation[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation) 联邦 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the federation backend driver in the keystone.federation namespace. Keystone only provides a sql driver, so there is no reason to set this option unless you are providing a custom entry point. keystone.federation 命名空间中联合后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由设置此选项。

- assertion_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.assertion_prefix)

  Type 类型 string 字符串 Default 违约 `''`  Prefix to use when filtering environment variable names for federated  assertions. Matched variables are passed into the federated mapping  engine. 筛选联合断言的环境变量名称时要使用的前缀。匹配的变量将传递到联合映射引擎中。

- remote_id_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.remote_id_attribute)

  Type 类型 string 字符串 Default 违约 `<None>`  Default value for all protocols to be used to obtain the entity ID of the Identity Provider from the environment. For mod_shib, this would be Shib-Identity-Provider. For mod_auth_openidc, this could be HTTP_OIDC_ISS. For mod_auth_mellon, this could be MELLON_IDP. This can be overridden on a per-protocol basis by providing a remote_id_attribute to the federation protocol using the API. 用于从环境中获取身份提供程序的实体 ID 的所有协议的默认值。对于mod_shib，这将是  Shib-Identity-Provider。对于mod_auth_openidc来说，这可能是HTTP_OIDC_ISS。对于mod_auth_mellon来说，这可能是MELLON_IDP。通过使用 API 向联合协议提供remote_id_attribute，可以在每个协议的基础上覆盖此功能。

- federated_domain_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.federated_domain_name)

  Type 类型 string 字符串 Default 违约 `Federated`  An arbitrary domain name that is reserved to allow federated ephemeral  users to have a domain concept. Note that an admin will not be able to  create a domain with this name or update an existing domain to this  name. You are not advised to change this value unless you really have  to. 保留以允许联盟临时用户具有域概念的任意域名。请注意，管理员将无法创建具有此名称的域或将现有域更新为此名称。除非确实有必要，否则不建议您更改此值。  Warning 警告 This option is deprecated for removal since T. Its value may be silently ignored  in the future. 此选项已弃用，因为 T.它的价值将来可能会被默默地忽略。 Reason 原因 This option has been superseded by ephemeral users existing in the domain of their identity provider. 此选项已被其身份提供商域中存在的临时用户所取代。

- trusted_dashboard[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.trusted_dashboard)

  Type 类型 multi-valued 多值 Default 违约 `''`  A list of trusted dashboard hosts. Before accepting a Single Sign-On  request to return a token, the origin host must be a member of this  list. This configuration option may be repeated for multiple values. You must set this in order to use web-based SSO flows. For example:  trusted_dashboard=https://acme.example.com/auth/websso  trusted_dashboard=https://beta.example.com/auth/websso 受信任的仪表板主机列表。在接受单点登录请求以返回令牌之前，源主机必须是此列表的成员。可以对多个值重复此配置选项。您必须设置此项才能使用基于 Web 的 SSO 流。例如：trusted_dashboard=https：//acme.example.com/auth/websso  trusted_dashboard=https：//beta.example.com/auth/websso

- sso_callback_template[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.sso_callback_template)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/sso_callback_template.html`  Absolute path to an HTML file used as a Single Sign-On callback handler. This  page is expected to redirect the user from keystone back to a trusted  dashboard host, by form encoding a token in a POST request. Keystone’s  default value should be sufficient for most deployments. 用作单点登录回调处理程序的 HTML 文件的绝对路径。此页面应通过对 POST 请求中的令牌进行表单编码，将用户从 keystone 重定向回受信任的仪表板主机。Keystone 的默认值对于大多数部署来说应该足够了。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for federation caching. This has no effect unless global caching is  enabled. There is typically no reason to disable this. 切换联合缓存。除非启用全局缓存，否则这不起作用。通常没有理由禁用此功能。

- default_authorization_ttl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#federation.default_authorization_ttl)

  Type 类型 integer 整数 Default 违约 `0`  Default time in minutes for the validity of group memberships carried over from a mapping. Default is 0, which means disabled. 从映射继承的组成员身份的有效性的默认时间（以分钟为单位）。默认值为 0，表示已禁用。



### fernet_receipts[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#fernet-receipts)

- key_repository[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#fernet_receipts.key_repository)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/fernet-keys/`  Directory containing Fernet receipt keys. This directory must exist before using keystone-manage fernet_setup for the first time, must be writable by the user running keystone-manage fernet_setup or keystone-manage fernet_rotate, and of course must be readable by keystone’s server process. The  repository may contain keys in one of three states: a single staged key  (always index 0) used for receipt validation, a single primary key  (always the highest index) used for receipt creation and validation, and any number of secondary keys (all other index values) used for receipt  validation. With multiple keystone nodes, each node must share the same  key repository contents, with the exception of the staged key (index 0). It is safe to run keystone-manage fernet_rotate once on any one node to promote a staged key (index 0) to be the new  primary (incremented from the previous highest index), and produce a new staged key (a new key with index 0); the resulting repository can then  be atomically replicated to other nodes without any risk of race  conditions (for example, it is safe to run keystone-manage fernet_rotate on host A, wait any amount of time, create a tarball of the directory  on host A, unpack it on host B to a temporary location, and atomically  move (mv) the directory into place on host B). Running keystone-manage fernet_rotate *twice* on a key repository without syncing other nodes will result in receipts that can not be validated by all nodes. 包含 Fernet 收据密钥的目录。在首次使用 keystone-manage fernet_setup之前，此目录必须存在，必须由运行  keystone-manage fernet_setup 或 keystone-manage fernet_rotate  的用户写入，当然也必须可由 keystone 的服务器进程读取。存储库可能包含以下三种状态之一的密钥：用于收据验证的单个暂存密钥（始终为索引  0）、用于收据创建和验证的单个主密钥（始终为最高索引）以及用于收据验证的任意数量的辅助密钥（所有其他索引值）。对于多个密钥节点，每个节点必须共享相同的密钥存储库内容，但暂存密钥（索引 0）除外。在任何一个节点上运行一次 keystone-manage fernet_rotate，以将暂存密钥（索引  0）提升为新的主密钥（从之前的最高索引递增），并生成新的暂存密钥（索引为 0  的新密钥）是安全的;然后，可以以原子方式将生成的存储库复制到其他节点，而不会出现任何争用条件的风险（例如，在主机 A 上运行  keystone-manage fernet_rotate，等待任意时间，在主机 A 上创建目录的压缩包，在主机 B  上将其解压缩到临时位置，并以原子方式将目录移动到主机 B 上的位置是安全的。在密钥存储库上运行 keystone-manage  fernet_rotate 两次而不同步其他节点将导致所有节点都无法验证的收据。

- max_active_keys[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#fernet_receipts.max_active_keys)

  Type 类型 integer 整数 Default 违约 `3` Minimum Value 最小值 1  This controls how many keys are held in rotation by keystone-manage fernet_rotate before they are discarded. The default value of 3 means that keystone  will maintain one staged key (always index 0), one primary key (the  highest numerical index), and one secondary key (every other index).  Increasing this value means that additional secondary keys will be kept  in the rotation. 这控制了 keystone-manage fernet_rotate在丢弃密钥之前轮流持有的密钥数量。默认值 3 表示 keystone  将维护一个暂存键（始终索引 0）、一个主键（最高数字索引）和一个辅助键（每隔一个索引）。增加此值意味着在轮换中将保留其他辅助键。



### fernet_tokens[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#fernet-tokens)

- key_repository[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#fernet_tokens.key_repository)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/fernet-keys/`  Directory containing Fernet token keys. This directory must exist before using keystone-manage fernet_setup for the first time, must be writable by the user running keystone-manage fernet_setup or keystone-manage fernet_rotate, and of course must be readable by keystone’s server process. The  repository may contain keys in one of three states: a single staged key  (always index 0) used for token validation, a single primary key (always the highest index) used for token creation and validation, and any  number of secondary keys (all other index values) used for token  validation. With multiple keystone nodes, each node must share the same  key repository contents, with the exception of the staged key (index 0). It is safe to run keystone-manage fernet_rotate once on any one node to promote a staged key (index 0) to be the new  primary (incremented from the previous highest index), and produce a new staged key (a new key with index 0); the resulting repository can then  be atomically replicated to other nodes without any risk of race  conditions (for example, it is safe to run keystone-manage fernet_rotate on host A, wait any amount of time, create a tarball of the directory  on host A, unpack it on host B to a temporary location, and atomically  move (mv) the directory into place on host B). Running keystone-manage fernet_rotate *twice* on a key repository without syncing other nodes will result in tokens that can not be validated by all nodes. 包含 Fernet 令牌密钥的目录。在首次使用 keystone-manage fernet_setup之前，此目录必须存在，必须由运行  keystone-manage fernet_setup 或 keystone-manage fernet_rotate  的用户写入，当然也必须可由 keystone 的服务器进程读取。存储库可能包含以下三种状态之一的密钥：用于令牌验证的单个暂存密钥（始终为索引  0）、用于令牌创建和验证的单个主密钥（始终为最高索引）以及用于令牌验证的任意数量的辅助密钥（所有其他索引值）。对于多个密钥节点，每个节点必须共享相同的密钥存储库内容，但暂存密钥（索引 0）除外。在任何一个节点上运行一次 keystone-manage fernet_rotate，以将暂存密钥（索引  0）提升为新的主密钥（从之前的最高索引递增），并生成新的暂存密钥（索引为 0  的新密钥）是安全的;然后，可以以原子方式将生成的存储库复制到其他节点，而不会出现任何争用条件的风险（例如，在主机 A 上运行  keystone-manage fernet_rotate，等待任意时间，在主机 A 上创建目录的压缩包，在主机 B  上将其解压缩到临时位置，并以原子方式将目录移动到主机 B 上的位置是安全的。在密钥存储库上运行 keystone-manage  fernet_rotate 两次而不同步其他节点将导致令牌无法由所有节点验证。

- max_active_keys[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#fernet_tokens.max_active_keys)

  Type 类型 integer 整数 Default 违约 `3` Minimum Value 最小值 1  This controls how many keys are held in rotation by keystone-manage fernet_rotate before they are discarded. The default value of 3 means that keystone  will maintain one staged key (always index 0), one primary key (the  highest numerical index), and one secondary key (every other index).  Increasing this value means that additional secondary keys will be kept  in the rotation. 这控制了 keystone-manage fernet_rotate在丢弃密钥之前轮流持有的密钥数量。默认值 3 表示 keystone  将维护一个暂存键（始终索引 0）、一个主键（最高数字索引）和一个辅助键（每隔一个索引）。增加此值意味着在轮换中将保留其他辅助键。



### healthcheck[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#healthcheck) 健康检查 ¶

- path[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#healthcheck.path) 路径 ¶

  Type 类型 string 字符串 Default 违约 `/healthcheck`  The path to respond to healtcheck requests on. 响应 healtcheck 请求的路径。  Warning 警告 This option is deprecated for removal. Its value may be silently ignored  in the future. 此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。

- detailed[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#healthcheck.detailed) 详细 ¶

  Type 类型 boolean 布尔 Default 违约 `False`  Show more detailed information as part of the response. Security note:  Enabling this option may expose sensitive details about the service  being monitored. Be sure to verify that it will not violate your  security policies. 在响应中显示更详细的信息。安全说明：启用此选项可能会暴露有关所监视服务的敏感详细信息。请务必验证它不会违反您的安全策略。

- backends[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#healthcheck.backends) 后端 ¶

  Type 类型 list 列表 Default 违约 `[]`  Additional backends that can perform health checks and report that information back as part of a request. 其他后端可以执行运行状况检查，并将该信息作为请求的一部分报告回来。

- disable_by_file_path[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#healthcheck.disable_by_file_path)

  Type 类型 string 字符串 Default 违约 `<None>`  Check the presence of a file to determine if an application is running on a port. Used by DisableByFileHealthcheck plugin. 检查文件是否存在，以确定应用程序是否在端口上运行。由 DisableByFileHealthcheck 插件使用。

- disable_by_file_paths[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#healthcheck.disable_by_file_paths)

  Type 类型 list 列表 Default 违约 `[]`  Check the presence of a file based on a port to determine if an application  is running on a port. Expects a “port:path” list of strings. Used by  DisableByFilesPortsHealthcheck plugin. 根据端口检查文件是否存在，以确定应用程序是否在端口上运行。需要字符串的“port：path”列表。由 DisableByFilesPortsHealthcheck 插件使用。



### identity[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity) 身份 ¶

- default_domain_id[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.default_domain_id)

  Type 类型 string 字符串 Default 违约 `default`  This references the domain to use for all Identity API v2 requests (which  are not aware of domains). A domain with this ID can optionally be  created for you by keystone-manage bootstrap. The domain referenced by this ID cannot be deleted on the v3 API, to  prevent accidentally breaking the v2 API. There is nothing special about this domain, other than the fact that it must exist to order to  maintain support for your v2 clients. There is typically no reason to  change this value. 这将引用要用于所有标识 API v2 请求（不知道域）的域。可以选择通过 keystone-manage 引导程序为您创建具有此 ID 的域。无法在 v3 API  上删除此 ID 引用的域，以防止意外破坏 v2 API。这个域没有什么特别之处，除了它必须存在才能保持对 v2  客户端的支持之外。通常没有理由更改此值。

- domain_specific_drivers_enabled[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.domain_specific_drivers_enabled)

  Type 类型 boolean 布尔 Default 违约 `False`  A subset (or all) of domains can have their own identity driver, each  with their own partial configuration options, stored in either the  resource backend or in a file in a domain configuration directory  (depending on the setting of [identity] domain_configurations_from_database). Only values specific to the domain need to be specified in this manner. This feature is disabled by default, but may be enabled by default in a future release; set to true to enable. 域的子集（或全部）可以有自己的标识驱动程序，每个驱动程序都有自己的部分配置选项，存储在资源后端或域配置目录中的文件中（取决于 [identity] domain_configurations_from_database  的设置）。只有特定于域的值才需要以这种方式指定。默认情况下，此功能处于禁用状态，但在将来的版本中可能会默认启用;设置为 true 可启用。

- domain_configurations_from_database[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.domain_configurations_from_database)

  Type 类型 boolean 布尔 Default 违约 `False`  By default, domain-specific configuration data is read from files in the directory identified by [identity] domain_config_dir. Enabling this configuration option allows you to instead manage  domain-specific configurations through the API, which are then persisted in the backend (typically, a SQL database), rather than using  configuration files on disk. 默认情况下，特定于域的配置数据是从 [identity] domain_config_dir标识的目录中的文件中读取的。启用此配置选项后，可以通过 API 管理特定于域的配置，这些配置随后保留在后端（通常是 SQL 数据库）中，而不是使用磁盘上的配置文件。

- domain_config_dir[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.domain_config_dir)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/domains`  Absolute path where keystone should locate domain-specific [identity] configuration files. This option has no effect unless [identity] domain_specific_drivers_enabled is set to true. There is typically no reason to change this value. keystone 应在其中查找特定于域的 [identity] 配置文件的绝对路径。除非将 [identity] domain_specific_drivers_enabled 设置为 true，否则此选项无效。通常没有理由更改此值。

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the identity backend driver in the keystone.identity namespace. Keystone provides a sql and ldap driver. This option is also used as the default driver selection (along with the other configuration variables in this section) in the event  that [identity] domain_specific_drivers_enabled is enabled, but no applicable domain-specific configuration is defined  for the domain in question. Unless your deployment primarily relies on ldap AND is not using domain-specific configuration, you should typically leave this set to sql. keystone.identity 命名空间中标识后端驱动程序的入口点。Keystone 提供 sql 和 ldap 驱动程序。如果启用了 [identity]  domain_specific_drivers_enabled，但未为相关域定义适用的特定于域的配置，则此选项也用作默认驱动程序选择（以及本节中的其他配置变量）。除非您的部署主要依赖于 ldap 并且不使用特定于域的配置，否则通常应将此设置保留为 sql。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for identity caching. This has no effect unless global caching is enabled. There is typically no reason to disable this. 切换身份缓存。除非启用全局缓存，否则这不起作用。通常没有理由禁用此功能。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.cache_time)

  Type 类型 integer 整数 Default 违约 `600`  Time to cache identity data (in seconds). This has no effect unless global and identity caching are enabled. 缓存身份数据的时间（以秒为单位）。除非启用全局缓存和标识缓存，否则这不起作用。

- max_password_length[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.max_password_length)

  Type 类型 integer 整数 Default 违约 `4096` Maximum Value 最大值 4096  Maximum allowed length for user passwords. Decrease this value to improve  performance. Changing this value does not effect existing passwords.  This value can also be overridden by certain hashing algorithms maximum  allowed length which takes precedence over the configured value.  The  bcrypt max_password_length is 72 bytes. 用户密码允许的最大长度。减小此值以提高性能。更改此值不会影响现有密码。此值也可以被某些哈希算法覆盖，最大允许长度优先于配置的值。bcrypt max_password_length为 72 字节。

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  Maximum number of entities that will be returned in an identity collection. 将在标识集合中返回的最大实体数。

- password_hash_algorithm[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.password_hash_algorithm)

  Type 类型 string 字符串 Default 违约 `bcrypt` Valid Values 有效值 bcrypt, scrypt, pbkdf2_sha512 bcrypt、scrypt pbkdf2_sha512  The password hashing algorithm to use for passwords stored within keystone. 用于存储在 keystone 中的密码的密码哈希算法。

- password_hash_rounds[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.password_hash_rounds)

  Type 类型 integer 整数 Default 违约 `<None>`  This option represents a trade off between security and performance. Higher  values lead to slower performance, but higher security. Changing this  option will only affect newly created passwords as existing password  hashes already have a fixed number of rounds applied, so it is safe to  tune this option in a running cluster.  The default for bcrypt is 12,  must be between 4 and 31, inclusive.  The default for scrypt is 16, must be within range(1,32).  The default for pbkdf_sha512 is 60000, must be within range(1,1<<32)  WARNING: If using scrypt, increasing this value increases BOTH time AND memory requirements to hash a password. 此选项表示安全性和性能之间的权衡。值越高，性能越慢，但安全性越高。更改此选项只会影响新创建的密码，因为现有密码哈希已应用了固定的轮数，因此在正在运行的集群中调整此选项是安全的。bcrypt 的默认值为 12，必须介于 4 和 31 之间（含 4 和 31）。scrypt 的默认值为 16，必须在 range（1,32）  范围内。pbkdf_sha512的默认值为 60000，必须在范围 （1,1<<32） 警告：如果使用  scrypt，增加此值会增加哈希密码的时间和内存要求。

- scrypt_block_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.scrypt_block_size)

  Type 类型 integer 整数 Default 违约 `<None>`  Optional block size to pass to scrypt hash function (the r parameter). Useful for tuning scrypt to optimal performance for your CPU architecture. This option is only used when the password_hash_algorithm option is set to scrypt. Defaults to 8. 传递给 scrypt 哈希函数（r 参数）的可选块大小。用于将 scrypt 调整为 CPU 架构的最佳性能。仅当 password_hash_algorithm 选项设置为 scrypt 时，才使用此选项。默认值为 8。

- scrypt_parallelism[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.scrypt_parallelism)

  Type 类型 integer 整数 Default 违约 `<None>`  Optional parallelism to pass to scrypt hash function (the p parameter). This option is only used when the password_hash_algorithm option is set to scrypt. Defaults to 1. 传递给 scrypt 哈希函数（p 参数）的可选并行性。仅当 password_hash_algorithm 选项设置为 scrypt 时，才使用此选项。默认值为 1。

- salt_bytesize[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity.salt_bytesize)

  Type 类型 integer 整数 Default 违约 `<None>` Minimum Value 最小值 0 Maximum Value 最大值 96  Number of bytes to use in scrypt and pbkfd2_sha512 hashing salt.  Default for  scrypt is 16 bytes. Default for pbkfd2_sha512 is 16 bytes.  Limited to a maximum of 96 bytes due to the size of the column used to store  password hashes. 在 scrypt 和 pbkfd2_sha512 哈希盐中使用的字节数。scrypt 的默认值为 16 个字节。pbkfd2_sha512 的默认值为 16 个字节。由于用于存储密码哈希的列的大小，限制为最大 96 个字节。



### identity_mapping[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity_mapping)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity_mapping.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the identity mapping backend driver in the keystone.identity.id_mapping namespace. Keystone only provides a sql driver, so there is no reason to change this unless you are providing a custom entry point. keystone.identity.id_mapping命名空间中标识映射后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此设置。

- generator[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity_mapping.generator) 生成器 ¶

  Type 类型 string 字符串 Default 违约 `sha256`  Entry point for the public ID generator for user and group entities in the keystone.identity.id_generator namespace. The Keystone identity mapper only supports generators that produce 64 bytes or less. Keystone only provides a sha256 entry point, so there is no reason to change this value unless you’re providing a custom entry point. keystone.identity.id_generator 命名空间中用户和组实体的公共 ID 生成器的入口点。Keystone 身份映射器仅支持生成 64 字节或更少的生成器。Keystone 仅提供 sha256 入口点，因此除非提供自定义入口点，否则没有理由更改此值。

- backward_compatible_ids[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#identity_mapping.backward_compatible_ids)

  Type 类型 boolean 布尔 Default 违约 `True`  The format of user and group IDs changed in Juno for backends that do not  generate UUIDs (for example, LDAP), with keystone providing a hash  mapping to the underlying attribute in LDAP. By default this mapping is  disabled, which ensures that existing IDs will not change. Even when the mapping is enabled by using domain-specific drivers ([identity] domain_specific_drivers_enabled), any users and groups from the default domain being handled by LDAP will still not be mapped to ensure their IDs remain backward compatible.  Setting this value to false will enable the new mapping for all  backends, including the default LDAP driver. It is only guaranteed to be safe to enable this option if you do not already have assignments for  users and groups from the default LDAP domain, and you consider it to be acceptable for Keystone to provide the different IDs to clients than it did previously (existing IDs in the API will suddenly change).  Typically this means that the only time you can set this value to false  is when configuring a fresh installation, although that is the  recommended value. 对于不生成 UUID 的后端（例如，LDAP），Juno 中更改了用户和组 ID 的格式，keystone 提供了到 LDAP  中基础属性的哈希映射。默认情况下，此映射处于禁用状态，可确保现有 ID 不会更改。即使使用特定于域的驱动程序（[identity]  domain_specific_drivers_enabled）启用映射，LDAP 处理的默认域中的任何用户和组仍不会被映射，以确保其 ID  保持向后兼容。将此值设置为 false 将为所有后端（包括默认 LDAP 驱动程序）启用新映射。仅当您还没有为默认 LDAP  域中的用户和组分配数据，并且您认为 Keystone 向客户端提供与以前不同的 ID 是可以接受的（API 中的现有 ID  将突然更改）时，才保证启用此选项是安全的。通常，这意味着只有在配置全新安装时才能将此值设置为 false，尽管这是建议的值。



### jwt_tokens[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#jwt-tokens)

- jws_public_key_repository[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#jwt_tokens.jws_public_key_repository)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/jws-keys/public`  Directory containing public keys for validating JWS token signatures. This  directory must exist in order for keystone’s server process to start. It must also be readable by keystone’s server process. It must contain at  least one public key that corresponds to a private key in keystone.conf [jwt_tokens] jws_private_key_repository. This option is only applicable in deployments issuing JWS tokens and setting keystone.conf [token] provider = jws. 包含用于验证 JWS 令牌签名的公钥的目录。此目录必须存在，keystone 的服务器进程才能启动。它还必须可被 keystone  的服务器进程读取。它必须包含至少一个公钥，该公钥对应于 keystone.conf [jwt_tokens]  jws_private_key_repository中的私钥。此选项仅适用于颁发 JWS 令牌并设置 keystone.conf [token] provider = jws 的部署。

- jws_private_key_repository[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#jwt_tokens.jws_private_key_repository)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/jws-keys/private`  Directory containing private keys for signing JWS tokens. This directory must  exist in order for keystone’s server process to start. It must also be  readable by keystone’s server process. It must contain at least one  private key that corresponds to a public key in keystone.conf [jwt_tokens] jws_public_key_repository. In the event there are multiple private keys in this directory, keystone will use a key named private.pem to sign tokens. In the future, keystone may support the ability to sign tokens with multiple private keys. For now, only a key named private.pem within this directory is required to issue JWS tokens. This option is  only applicable in deployments issuing JWS tokens and setting keystone.conf [token] provider = jws. 包含用于对 JWS 令牌进行签名的私钥的目录。此目录必须存在，keystone 的服务器进程才能启动。它还必须可被 keystone  的服务器进程读取。它必须包含至少一个私钥，该私钥对应于 keystone.conf [jwt_tokens]  jws_public_key_repository中的公钥。如果此目录中有多个私钥，keystone 将使用名为 private.pem  的密钥对令牌进行签名。将来，keystone 可能会支持使用多个私钥对令牌进行签名的能力。目前，只需要此目录中名为 private.pem  的密钥即可颁发 JWS 令牌。此选项仅适用于颁发 JWS 令牌并设置 keystone.conf [token] provider = jws  的部署。



### ldap[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap) LDAP的 ¶

- url[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.url) 网址 ¶

  Type 类型 string 字符串 Default 违约 `ldap://localhost`  URL(s) for connecting to the LDAP server. Multiple LDAP URLs may be specified  as a comma separated string. The first URL to successfully bind is used  for the connection. 用于连接到 LDAP 服务器的 URL。可以将多个 LDAP URL 指定为逗号分隔的字符串。成功绑定的第一个 URL 用于连接。

- randomize_urls[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.randomize_urls)

  Type 类型 boolean 布尔 Default 违约 `False`  Randomize the order of URLs in each keystone process. This makes the failure  behavior more gradual, since if the first server is down, a  process/thread will wait for the specified timeout before attempting a  connection to a server further down the list. This defaults to False,  for backward compatibility. 随机化每个 keystone 进程中 URL 的顺序。这使得失败行为更加渐进，因为如果第一台服务器关闭，进程/线程将等待指定的超时，然后再尝试连接到列表中更下方的服务器。这默认为 False，以实现向后兼容性。

- user[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user) 用户 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  The user name of the administrator bind DN to use when querying the LDAP server, if your LDAP server requires it. 如果 LDAP 服务器需要，则在查询 LDAP 服务器时要使用的管理员绑定 DN 的用户名。

- password[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.password) 密码 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  The password of the administrator bind DN to use when querying the LDAP server, if your LDAP server requires it. 管理员绑定 DN 时要使用的密码（如果 LDAP 服务器需要）。

- suffix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.suffix) 后缀 ¶

  Type 类型 string 字符串 Default 违约 `cn=example,cn=com`  The default LDAP server suffix to use, if a DN is not defined via either [ldap] user_tree_dn or [ldap] group_tree_dn. 如果 DN 不是通过 [ldap] user_tree_dn 或 [ldap] group_tree_dn定义的，则要使用的默认 LDAP 服务器后缀。

- query_scope[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.query_scope)

  Type 类型 string 字符串 Default 违约 `one` Valid Values 有效值 one, sub 一、子  The search scope which defines how deep to search within the search base. A value of one (representing oneLevel or singleLevel) indicates a search of objects immediately below to the base object, but does not include the base object itself. A value of sub (representing subtree or wholeSubtree) indicates a search of both the base object itself and the entire subtree below it. 搜索范围，用于定义在搜索库中搜索的深度。值为 1（表示 oneLevel 或 singleLevel）表示对紧挨着基对象的对象进行搜索，但不包括基对象本身。值 sub（表示子树或 wholeSubtree）表示对基本对象本身及其下的整个子树的搜索。

- page_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.page_size)

  Type 类型 integer 整数 Default 违约 `0` Minimum Value 最小值 0  Defines the maximum number of results per page that keystone should request  from the LDAP server when listing objects. A value of zero (0) disables paging. 定义 keystone 在列出对象时应从 LDAP 服务器请求的每页的最大结果数。值为零 （0） 将禁用分页。

- alias_dereferencing[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.alias_dereferencing)

  Type 类型 string 字符串 Default 违约 `default` Valid Values 有效值 never, searching, always, finding, default 从不、搜索、始终、查找、默认  The LDAP dereferencing option to use for queries involving aliases. A value of default falls back to using default dereferencing behavior configured by your ldap.conf. A value of never prevents aliases from being dereferenced at all. A value of searching dereferences aliases only after name resolution. A value of finding dereferences aliases only during name resolution. A value of always dereferences aliases in all cases. 用于涉及别名的查询的 LDAP 取消引用选项。默认值回退到使用 ldap.conf 配置的缺省取消引用行为。如果值 never  完全阻止取消引用别名。搜索值仅在名称解析后取消引用别名。仅在名称解析期间查找取消引用别名的值。在所有情况下，始终取消引用别名的值。

- debug_level[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.debug_level)

  Type 类型 integer 整数 Default 违约 `<None>` Minimum Value 最小值 -1  Sets the LDAP debugging level for LDAP calls. A value of 0 means that  debugging is not enabled. This value is a bitmask, consult your LDAP  documentation for possible values. 设置 LDAP 调用的 LDAP 调试级别。值为 0 表示未启用调试。此值是位掩码，有关可能的值，请参阅 LDAP 文档。

- chase_referrals[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.chase_referrals)

  Type 类型 boolean 布尔 Default 违约 `<None>`  Sets keystone’s referral chasing behavior across directory partitions. If  left unset, the system’s default behavior will be used. 设置 keystone 在目录分区之间的引用跟踪行为。如果未设置，将使用系统的默认行为。

- user_tree_dn[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_tree_dn)

  Type 类型 string 字符串 Default 违约 `<None>`  The search base to use for users. Defaults to ou=Users with the [ldap] suffix appended to it. 供用户使用的搜索库。默认为 ou=Users，并附加 [ldap] 后缀。

- user_filter[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_filter)

  Type 类型 string 字符串 Default 违约 `<None>`  The LDAP search filter to use for users. 供用户使用的 LDAP 搜索过滤器。

- user_objectclass[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_objectclass)

  Type 类型 string 字符串 Default 违约 `inetOrgPerson`  The LDAP object class to use for users. 要用于用户的 LDAP 对象类。

- user_id_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_id_attribute)

  Type 类型 string 字符串 Default 违约 `cn`  The LDAP attribute mapped to user IDs in keystone. This must NOT be a  multivalued attribute. User IDs are expected to be globally unique  across keystone domains and URL-safe. 映射到 keystone 中的用户 ID 的 LDAP 属性。这不能是多值属性。用户 ID 应在 keystone 域中具有全局唯一性和 URL 安全性。

- user_name_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_name_attribute)

  Type 类型 string 字符串 Default 违约 `sn`  The LDAP attribute mapped to user names in keystone. User names are  expected to be unique only within a keystone domain and are not expected to be URL-safe. 映射到 keystone 中的用户名的 LDAP 属性。用户名应仅在 keystone 域中是唯一的，不应是 URL 安全的。

- user_description_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_description_attribute)

  Type 类型 string 字符串 Default 违约 `description`  The LDAP attribute mapped to user descriptions in keystone. 映射到 keystone 中的用户描述的 LDAP 属性。

- user_mail_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_mail_attribute)

  Type 类型 string 字符串 Default 违约 `mail`  The LDAP attribute mapped to user emails in keystone. 映射到 keystone 中的用户电子邮件的 LDAP 属性。

- user_pass_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_pass_attribute)

  Type 类型 string 字符串 Default 违约 `userPassword`  The LDAP attribute mapped to user passwords in keystone. 映射到 keystone 中的用户密码的 LDAP 属性。

- user_enabled_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_attribute)

  Type 类型 string 字符串 Default 违约 `enabled`  The LDAP attribute mapped to the user enabled attribute in keystone. If setting this option to userAccountControl, then you may be interested in setting [ldap] user_enabled_mask and [ldap] user_enabled_default as well. 映射到 keystone 中的用户启用属性的 LDAP 属性。如果将此选项设置为 userAccountControl，那么您可能还有兴趣设置 [ldap] user_enabled_mask 和 [ldap] user_enabled_default。

- user_enabled_invert[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_invert)

  Type 类型 boolean 布尔 Default 违约 `False`  Logically negate the boolean value of the enabled attribute obtained from the  LDAP server. Some LDAP servers use a boolean lock attribute where “true” means an account is disabled. Setting [ldap] user_enabled_invert = true will allow these lock attributes to be used. This option will have no effect if either the [ldap] user_enabled_mask or [ldap] user_enabled_emulation options are in use. 从逻辑上否定从 LDAP 服务器获取的 enabled 属性的布尔值。某些 LDAP 服务器使用布尔锁属性，其中“true”表示帐户被禁用。设置 [ldap] user_enabled_invert = true 将允许使用这些锁属性。如果正在使用 [ldap] user_enabled_mask 或 [ldap] user_enabled_emulation 选项，则此选项将不起作用。

- user_enabled_mask[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_mask)

  Type 类型 integer 整数 Default 违约 `0` Minimum Value 最小值 0  Bitmask integer to select which bit indicates the enabled value if the LDAP  server represents “enabled” as a bit on an integer rather than as a  discrete boolean. A value of 0 indicates that the mask is not used. If this is not set to 0 the typical value is 2. This is typically used when [ldap] user_enabled_attribute = userAccountControl. Setting this option causes keystone to ignore the value of [ldap] user_enabled_invert. 如果 LDAP 服务器将“enabled”表示为整数上的位而不是离散布尔值，则使用位掩码整数来选择哪个位指示启用值。值为 0  表示未使用掩码。如果未设置为 0，则典型值为 2。这通常在 [ldap] user_enabled_attribute =  userAccountControl 时使用。设置此选项会导致 keystone 忽略 [ldap] user_enabled_invert  的值。

- user_enabled_default[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_default)

  Type 类型 string 字符串 Default 违约 `True`  The default value to enable users. This should match an appropriate integer value if the LDAP server uses non-boolean (bitmask) values to indicate  if a user is enabled or disabled. If this is not set to True, then the typical value is 512. This is typically used when [ldap] user_enabled_attribute = userAccountControl. 用于启用用户的默认值。如果 LDAP 服务器使用非布尔值（位掩码）值来指示用户是启用还是禁用，则这应该与适当的整数值匹配。如果未设置为 True，则典型值为  512。这通常在 [ldap] user_enabled_attribute = userAccountControl 时使用。

- user_attribute_ignore[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_attribute_ignore)

  Type 类型 list 列表 Default 违约 `['default_project_id']`  List of user attributes to ignore on create and update, or whether a  specific user attribute should be filtered for list or show user. 创建和更新时要忽略的用户属性列表，或者是否应针对列表或显示用户筛选特定用户属性。

- user_default_project_id_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_default_project_id_attribute)

  Type 类型 string 字符串 Default 违约 `<None>`  The LDAP attribute mapped to a user’s default_project_id in keystone. This  is most commonly used when keystone has write access to LDAP. 在 keystone 中映射到用户default_project_id的 LDAP 属性。当 keystone 具有对 LDAP 的写入访问权限时，最常使用此方法。

- user_enabled_emulation[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_emulation)

  Type 类型 boolean 布尔 Default 违约 `False`  If enabled, keystone uses an alternative method to determine if a user is  enabled or not by checking if they are a member of the group defined by  the [ldap] user_enabled_emulation_dn option. Enabling this option causes keystone to ignore the value of [ldap] user_enabled_invert. 如果启用，keystone 将使用另一种方法通过检查用户是否是 [ldap] user_enabled_emulation_dn  选项定义的组的成员来确定用户是否已启用。启用此选项会导致 keystone 忽略 [ldap] user_enabled_invert 的值。

- user_enabled_emulation_dn[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_emulation_dn)

  Type 类型 string 字符串 Default 违约 `<None>`  DN of the group entry to hold enabled users when using enabled emulation. Setting this option has no effect unless [ldap] user_enabled_emulation is also enabled. 使用启用的仿真时用于保存已启用用户的组条目的 DN。除非还启用了 [ldap] user_enabled_emulation，否则设置此选项不起作用。

- user_enabled_emulation_use_group_config[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_enabled_emulation_use_group_config)

  Type 类型 boolean 布尔 Default 违约 `False`  Use the [ldap] group_member_attribute and [ldap] group_objectclass settings to determine membership in the emulated enabled group. Enabling this option has no effect unless [ldap] user_enabled_emulation is also enabled. 使用 [ldap] group_member_attribute 和 [ldap] group_objectclass 设置确定模拟启用组中的成员身份。除非同时启用了 [ldap] user_enabled_emulation，否则启用此选项不起作用。

- user_additional_attribute_mapping[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.user_additional_attribute_mapping)

  Type 类型 list 列表 Default 违约 `[]`  A list of LDAP attribute to keystone user attribute pairs used for  mapping additional attributes to users in keystone. The expected format  is <ldap_attr>:<user_attr>, where ldap_attr is the attribute in the LDAP object and user_attr is the attribute which should appear in the identity API. 用于将其他属性映射到 keystone 中的用户的 keystone 用户属性对的 LDAP 属性列表。预期的格式为 ：，其中 ldap_attr 是 LDAP 对象中的属性，user_attr 是应出现在身份 API 中的属性。

- group_tree_dn[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_tree_dn)

  Type 类型 string 字符串 Default 违约 `<None>`  The search base to use for groups. Defaults to ou=UserGroups with the [ldap] suffix appended to it. 用于组的搜索库。默认为 ou=UserGroups，并附加 [ldap] 后缀。

- group_filter[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_filter)

  Type 类型 string 字符串 Default 违约 `<None>`  The LDAP search filter to use for groups. 用于组的 LDAP 搜索过滤器。

- group_objectclass[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_objectclass)

  Type 类型 string 字符串 Default 违约 `groupOfNames`  The LDAP object class to use for groups. If setting this option to posixGroup, you may also be interested in enabling the [ldap] group_members_are_ids option. 要用于组的 LDAP 对象类。如果将此选项设置为 posixGroup，您可能还有兴趣启用 [ldap] group_members_are_ids 选项。

- group_id_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_id_attribute)

  Type 类型 string 字符串 Default 违约 `cn`  The LDAP attribute mapped to group IDs in keystone. This must NOT be a  multivalued attribute. Group IDs are expected to be globally unique  across keystone domains and URL-safe. 映射到 keystone 中的组 ID 的 LDAP 属性。这不能是多值属性。组 ID 应在 keystone 域中具有全局唯一性，并且 URL 安全。

- group_name_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_name_attribute)

  Type 类型 string 字符串 Default 违约 `ou`  The LDAP attribute mapped to group names in keystone. Group names are  expected to be unique only within a keystone domain and are not expected to be URL-safe. 映射到 keystone 中的组名称的 LDAP 属性。组名称应仅在 keystone 域中是唯一的，并且不应是 URL 安全的。

- group_member_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_member_attribute)

  Type 类型 string 字符串 Default 违约 `member`  The LDAP attribute used to indicate that a user is a member of the group. 用于指示用户是组成员的 LDAP 属性。

- group_members_are_ids[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_members_are_ids)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable this option if the members of the group object class are keystone user  IDs rather than LDAP DNs. This is the case when using posixGroup as the group object class in Open Directory. 如果组对象类的成员是梯形用户标识而不是 LDAP DN，请启用此选项。在 Open Directory 中使用 posixGroup 作为组对象类时，就是这种情况。

- group_desc_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_desc_attribute)

  Type 类型 string 字符串 Default 违约 `description`  The LDAP attribute mapped to group descriptions in keystone. 映射到 keystone 中的组描述的 LDAP 属性。

- group_attribute_ignore[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_attribute_ignore)

  Type 类型 list 列表 Default 违约 `[]`  List of group attributes to ignore on create and update. or whether a  specific group attribute should be filtered for list or show group. 创建和更新时要忽略的组属性列表。或者是否应针对 list 或 show group 筛选特定组属性。

- group_additional_attribute_mapping[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_additional_attribute_mapping)

  Type 类型 list 列表 Default 违约 `[]`  A list of LDAP attribute to keystone group attribute pairs used for  mapping additional attributes to groups in keystone. The expected format is <ldap_attr>:<group_attr>, where ldap_attr is the attribute in the LDAP object and group_attr is the attribute which should appear in the identity API. Keystone 组属性对的 LDAP 属性列表，用于将其他属性映射到 keystone 中的组。预期的格式为 ：，其中 ldap_attr 是 LDAP 对象中的属性，group_attr 是应出现在身份 API 中的属性。

- group_ad_nesting[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.group_ad_nesting)

  Type 类型 boolean 布尔 Default 违约 `False`  If enabled, group queries will use Active Directory specific filters for nested groups. 如果启用，组查询将对嵌套组使用特定于 Active Directory 的筛选器。

- tls_cacertfile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.tls_cacertfile)

  Type 类型 string 字符串 Default 违约 `<None>`  An absolute path to a CA certificate file to use when communicating with LDAP servers. This option will take precedence over [ldap] tls_cacertdir, so there is no reason to set both. 与 LDAP 服务器通信时要使用的 CA 证书文件的绝对路径。此选项将优先于 [ldap] tls_cacertdir，因此没有理由同时设置两者。

- tls_cacertdir[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.tls_cacertdir)

  Type 类型 string 字符串 Default 违约 `<None>`  An absolute path to a CA certificate directory to use when communicating  with LDAP servers. There is no reason to set this option if you’ve also  set [ldap] tls_cacertfile. 与 LDAP 服务器通信时要使用的 CA 证书目录的绝对路径。如果您还设置了 [ldap] tls_cacertfile，则没有理由设置此选项。

- use_tls[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.use_tls)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable TLS when communicating with LDAP servers. You should also set the [ldap] tls_cacertfile and [ldap] tls_cacertdir options when using this option. Do not set this option if you are using LDAP over SSL (LDAPS) instead of TLS. 与 LDAP 服务器通信时启用 TLS。使用此选项时，还应设置 [ldap] tls_cacertfile 和 [ldap] tls_cacertdir 选项。如果您使用的是 LDAP over SSL （LDAPS） 而不是 TLS，请不要设置此选项。

- tls_req_cert[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.tls_req_cert)

  Type 类型 string 字符串 Default 违约 `demand` Valid Values 有效值 demand, never, allow 要求、从不、允许  Specifies which checks to perform against client certificates on incoming TLS sessions. If set to demand, then a certificate will always be requested and required from the LDAP server. If set to allow, then a certificate will always be requested but not required from the LDAP server. If set to never, then a certificate will never be requested. 指定要对传入的 TLS 会话的客户端证书执行哪些检查。如果设置为“需求”，则将始终从 LDAP 服务器请求和需要证书。如果设置为允许，则将始终从 LDAP 服务器请求证书，但不是必需的。如果设置为 never，则永远不会请求证书。

- connection_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.connection_timeout)

  Type 类型 integer 整数 Default 违约 `-1` Minimum Value 最小值 -1  The connection timeout to use with the LDAP server. A value of -1 means that connections will never timeout. 用于 LDAP 服务器的连接超时。值 -1 表示连接永远不会超时。

- use_pool[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.use_pool)

  Type 类型 boolean 布尔 Default 违约 `True`  Enable LDAP connection pooling for queries to the LDAP server. There is typically no reason to disable this. 为对 LDAP 服务器的查询启用 LDAP 连接池。通常没有理由禁用此功能。

- pool_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.pool_size)

  Type 类型 integer 整数 Default 违约 `10` Minimum Value 最小值 1  The size of the LDAP connection pool. This option has no effect unless [ldap] use_pool is also enabled. LDAP 连接池的大小。除非还启用了 [ldap] use_pool，否则此选项不起作用。

- pool_retry_max[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.pool_retry_max)

  Type 类型 integer 整数 Default 违约 `3` Minimum Value 最小值 1  The maximum number of times to attempt connecting to the LDAP server before aborting. A value of one makes only one connection attempt. This option has no effect unless [ldap] use_pool is also enabled. 在中止之前尝试连接到 LDAP 服务器的最大次数。值为 1 时，仅进行一次连接尝试。除非还启用了 [ldap] use_pool，否则此选项不起作用。

- pool_retry_delay[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.pool_retry_delay)

  Type 类型 floating point 浮点 Default 违约 `0.1`  The number of seconds to wait before attempting to reconnect to the LDAP server. This option has no effect unless [ldap] use_pool is also enabled. 在尝试重新连接到 LDAP 服务器之前等待的秒数。除非还启用了 [ldap] use_pool，否则此选项不起作用。

- pool_connection_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.pool_connection_timeout)

  Type 类型 integer 整数 Default 违约 `-1` Minimum Value 最小值 -1  The connection timeout to use when pooling LDAP connections. A value of -1 means that connections will never timeout. This option has no effect unless [ldap] use_pool is also enabled. 池化 LDAP 连接时要使用的连接超时。值 -1 表示连接永远不会超时。除非还启用了 [ldap] use_pool，否则此选项不起作用。

- pool_connection_lifetime[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.pool_connection_lifetime)

  Type 类型 integer 整数 Default 违约 `600` Minimum Value 最小值 1  The maximum connection lifetime to the LDAP server in seconds. When this  lifetime is exceeded, the connection will be unbound and removed from  the connection pool. This option has no effect unless [ldap] use_pool is also enabled. LDAP 服务器的最长连接生存期（以秒为单位）。当超过此生存期时，连接将解除绑定并从连接池中删除。除非还启用了 [ldap] use_pool，否则此选项不起作用。

- use_auth_pool[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.use_auth_pool)

  Type 类型 boolean 布尔 Default 违约 `True`  Enable LDAP connection pooling for end user authentication. There is typically no reason to disable this. 为最终用户身份验证启用 LDAP 连接池。通常没有理由禁用此功能。

- auth_pool_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.auth_pool_size)

  Type 类型 integer 整数 Default 违约 `100` Minimum Value 最小值 1  The size of the connection pool to use for end user authentication. This option has no effect unless [ldap] use_auth_pool is also enabled. 用于最终用户身份验证的连接池的大小。除非还启用了 [ldap] use_auth_pool，否则此选项不起作用。

- auth_pool_connection_lifetime[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#ldap.auth_pool_connection_lifetime)

  Type 类型 integer 整数 Default 违约 `60` Minimum Value 最小值 1  The maximum end user authentication connection lifetime to the LDAP server  in seconds. When this lifetime is exceeded, the connection will be  unbound and removed from the connection pool. This option has no effect  unless [ldap] use_auth_pool is also enabled. 最终用户与 LDAP 服务器的最长身份验证连接生存期（以秒为单位）。当超过此生存期时，连接将解除绑定并从连接池中删除。除非还启用了 [ldap] use_auth_pool，否则此选项不起作用。



### memcache[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#memcache) memcache 的 ¶

- dead_retry[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#memcache.dead_retry)

  Type 类型 integer 整数 Default 违约 `300`  Number of seconds memcached server is considered dead before it is tried again. This is used by the key value store system. memcached 服务器在重试之前被视为已死的秒数。这由键值存储系统使用。  Warning 警告 This option is deprecated for removal since Y. Its value may be silently ignored  in the future. 自 Y 起，此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 This option has no effect. Configure `keystone.conf [cache] memcache_dead_retry` option to set the dead_retry of memcached instead. 此选项无效。配置 `keystone.conf [cache] memcache_dead_retry` 选项来设置 memcached 的dead_retry。

- socket_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#memcache.socket_timeout)

  Type 类型 integer 整数 Default 违约 `3`  Timeout in seconds for every call to a server. This is used by the key value store system. 每次调用服务器的超时时间（以秒为单位）。这由键值存储系统使用。  Warning 警告 This option is deprecated for removal since T. Its value may be silently ignored  in the future. 此选项已弃用，因为 T.它的价值将来可能会被默默地忽略。 Reason 原因 This option has no effect. Configure `keystone.conf [cache] memcache_socket_timeout` option to set the socket_timeout of memcached instead. 此选项无效。配置 `keystone.conf [cache] memcache_socket_timeout` 选项来设置 memcached 的socket_timeout。

- pool_maxsize[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#memcache.pool_maxsize)

  Type 类型 integer 整数 Default 违约 `10`  Max total number of open connections to every memcached server. This is used by the key value store system. 与每个 memcached 服务器的最大打开连接总数。这由键值存储系统使用。  Warning 警告 This option is deprecated for removal since Y. Its value may be silently ignored  in the future. 自 Y 起，此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 This option has no effect. Configure `keystone.conf [cache] memcache_pool_maxsize` option to set the pool_maxsize of memcached instead. 此选项无效。配置 `keystone.conf [cache] memcache_pool_maxsize` 选项来设置 memcached 的pool_maxsize。

- pool_unused_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#memcache.pool_unused_timeout)

  Type 类型 integer 整数 Default 违约 `60`  Number of seconds a connection to memcached is held unused in the pool before  it is closed. This is used by the key value store system. 在池中关闭之前，与 memcached 的连接在池中保持未使用的秒数。这由键值存储系统使用。  Warning 警告 This option is deprecated for removal since Y. Its value may be silently ignored  in the future. 自 Y 起，此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 This option has no effect. Configure `keystone.conf [cache] memcache_pool_unused_timeout` option to set the pool_unused_timeout of memcached instead. 此选项无效。配置 `keystone.conf [cache] memcache_pool_unused_timeout` 选项来设置 memcached 的pool_unused_timeout。

- pool_connection_get_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#memcache.pool_connection_get_timeout)

  Type 类型 integer 整数 Default 违约 `10`  Number of seconds that an operation will wait to get a memcache client connection. This is used by the key value store system. 操作等待获取 memcache 客户端连接的秒数。这由键值存储系统使用。  Warning 警告 This option is deprecated for removal since Y. Its value may be silently ignored  in the future. 自 Y 起，此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 This option has no effect. Configure `keystone.conf [cache] memcache_pool_connection_get_timeout` option to set the connection_get_timeout of memcached instead. 此选项无效。配置 `keystone.conf [cache] memcache_pool_connection_get_timeout` 选项来设置 memcached 的connection_get_timeout。



### oauth1[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oauth1) OAuth1 （英语） ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oauth1.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the OAuth backend driver in the keystone.oauth1 namespace. Typically, there is no reason to set this option unless you are providing a custom entry point. keystone.oauth1 命名空间中 OAuth 后端驱动程序的入口点。通常，除非您提供自定义入口点，否则没有理由设置此选项。

- request_token_duration[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oauth1.request_token_duration)

  Type 类型 integer 整数 Default 违约 `28800` Minimum Value 最小值 0  Number of seconds for the OAuth Request Token to remain valid after being  created. This is the amount of time the user has to authorize the token. Setting this option to zero means that request tokens will last  forever. OAuth 请求令牌在创建后保持有效的秒数。这是用户必须授权令牌的时间。将此选项设置为零意味着请求令牌将永远存在。

- access_token_duration[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oauth1.access_token_duration)

  Type 类型 integer 整数 Default 违约 `86400` Minimum Value 最小值 0  Number of seconds for the OAuth Access Token to remain valid after being  created. This is the amount of time the consumer has to interact with  the service provider (which is typically keystone). Setting this option  to zero means that access tokens will last forever. OAuth 访问令牌在创建后保持有效的秒数。这是消费者必须与服务提供商交互的时间（通常是基石）。将此选项设置为零意味着访问令牌将永远存在。



### oslo_messaging_amqp[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo-messaging-amqp)

- container_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.container_name)

  Type 类型 string 字符串 Default 违约 `<None>`  Name for the AMQP container. must be globally unique. Defaults to a generated UUID AMQP 容器的名称。必须是全局唯一的。默认为生成的 UUID Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id19) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 container_name

- idle_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.idle_timeout)

  Type 类型 integer 整数 Default 违约 `0`  Timeout for inactive connections (in seconds) 非活动连接的超时（以秒为单位） Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id20) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 idle_timeout

- trace[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.trace) 跟踪 ¶

  Type 类型 boolean 布尔 Default 违约 `False`  Debug: dump AMQP frames to stdout 调试：将 AMQP 帧转储到 stdout Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id21) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 trace 跟踪

- ssl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.ssl) SSL协议 ¶

  Type 类型 boolean 布尔 Default 违约 `False`  Attempt to connect via SSL. If no other ssl-related parameters are given, it  will use the system’s CA-bundle to verify the server’s certificate. 尝试通过 SSL 进行连接。如果没有给出其他与 ssl 相关的参数，它将使用系统的 CA 捆绑包来验证服务器的证书。

- ssl_ca_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.ssl_ca_file)

  Type 类型 string 字符串 Default 违约 `''`  CA certificate PEM file used to verify the server’s certificate CA 证书 用于验证服务器证书的 PEM 文件 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id22) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 ssl_ca_file

- ssl_cert_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.ssl_cert_file)

  Type 类型 string 字符串 Default 违约 `''`  Self-identifying certificate PEM file for client authentication 用于客户端身份验证的自识别证书 PEM 文件 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id23) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 ssl_cert_file

- ssl_key_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.ssl_key_file)

  Type 类型 string 字符串 Default 违约 `''`  Private key PEM file used to sign ssl_cert_file certificate (optional) 用于签署ssl_cert_file证书的私钥 PEM 文件（可选） Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id24) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 ssl_key_file

- ssl_key_password[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.ssl_key_password)

  Type 类型 string 字符串 Default 违约 `<None>`  Password for decrypting ssl_key_file (if encrypted) 用于解密ssl_key_file的密码（如果已加密） Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id25) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 ssl_key_password

- ssl_verify_vhost[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.ssl_verify_vhost)

  Type 类型 boolean 布尔 Default 违约 `False`  By default SSL checks that the name in the server’s certificate matches  the hostname in the transport_url. In some configurations it may be  preferable to use the virtual hostname instead, for example if the  server uses the Server Name Indication TLS extension (rfc6066) to  provide a certificate per virtual host. Set ssl_verify_vhost to True if  the server’s SSL certificate uses the virtual host name instead of the  DNS name. 默认情况下，SSL 会检查服务器证书中的名称是否与transport_url中的主机名匹配。在某些配置中，最好改用虚拟主机名，例如，如果服务器使用服务器名称指示  TLS 扩展 （rfc6066） 为每个虚拟主机提供证书。如果服务器的 SSL 证书使用虚拟主机名而不是 DNS 名称，则将  ssl_verify_vhost 设置为 True。

- sasl_mechanisms[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.sasl_mechanisms)

  Type 类型 string 字符串 Default 违约 `''`  Space separated list of acceptable SASL mechanisms 可接受的 SASL 机制的空格分隔列表 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id26) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 sasl_mechanisms

- sasl_config_dir[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.sasl_config_dir)

  Type 类型 string 字符串 Default 违约 `''`  Path to directory that contains the SASL configuration 包含 SASL 配置的目录的路径 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id27) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 sasl_config_dir

- sasl_config_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.sasl_config_name)

  Type 类型 string 字符串 Default 违约 `''`  Name of configuration file (without .conf suffix) 配置文件名称（不带 .conf 后缀） Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id28) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 sasl_config_name

- sasl_default_realm[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.sasl_default_realm)

  Type 类型 string 字符串 Default 违约 `''`  SASL realm to use if no realm present in username 如果用户名中不存在领域，则要使用的 SASL 领域

- connection_retry_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.connection_retry_interval)

  Type 类型 integer 整数 Default 违约 `1` Minimum Value 最小值 1  Seconds to pause before attempting to re-connect. 在尝试重新连接之前暂停几秒钟。

- connection_retry_backoff[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.connection_retry_backoff)

  Type 类型 integer 整数 Default 违约 `2` Minimum Value 最小值 0  Increase the connection_retry_interval by this many seconds after each unsuccessful failover attempt. 在每次失败的故障转移尝试后，将connection_retry_interval增加此秒数。

- connection_retry_interval_max[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.connection_retry_interval_max)

  Type 类型 integer 整数 Default 违约 `30` Minimum Value 最小值 1  Maximum limit for connection_retry_interval + connection_retry_backoff connection_retry_interval + connection_retry_backoff 的最大限额

- link_retry_delay[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.link_retry_delay)

  Type 类型 integer 整数 Default 违约 `10` Minimum Value 最小值 1  Time to pause between re-connecting an AMQP 1.0 link that failed due to a recoverable error. 在重新连接由于可恢复错误而失败的 AMQP 1.0 链路之间暂停的时间。

- default_reply_retry[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_reply_retry)

  Type 类型 integer 整数 Default 违约 `0` Minimum Value 最小值 -1  The maximum number of attempts to re-send a reply message which failed due to a recoverable error. 尝试重新发送由于可恢复错误而失败的回复邮件的最大次数。

- default_reply_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_reply_timeout)

  Type 类型 integer 整数 Default 违约 `30` Minimum Value 最小值 5  The deadline for an rpc reply message delivery. rpc 回复消息传递的截止时间。

- default_send_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_send_timeout)

  Type 类型 integer 整数 Default 违约 `30` Minimum Value 最小值 5  The deadline for an rpc cast or call message delivery. Only used when caller does not provide a timeout expiry. rpc 强制转换或调用消息传递的截止时间。仅当调用方未提供超时到期时间时才使用。

- default_notify_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_notify_timeout)

  Type 类型 integer 整数 Default 违约 `30` Minimum Value 最小值 5  The deadline for a sent notification message delivery. Only used when caller does not provide a timeout expiry. 已发送通知消息传递的截止时间。仅当调用方未提供超时到期时间时才使用。

- default_sender_link_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_sender_link_timeout)

  Type 类型 integer 整数 Default 违约 `600` Minimum Value 最小值 1  The duration to schedule a purge of idle sender links. Detach link after expiry. 计划清除空闲发件人链接的持续时间。过期后分离链接。

- addressing_mode[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.addressing_mode)

  Type 类型 string 字符串 Default 违约 `dynamic`  Indicates the addressing mode used by the driver. Permitted values: ‘legacy’   - use legacy non-routable addressing ‘routable’ - use routable addresses ‘dynamic’  - use legacy addresses if the message bus does not support routing otherwise use routable addressing 指示驱动程序使用的寻址模式。允许的值： 'legacy' - 使用传统的不可路由寻址 'routable' - 使用可路由的地址 'dynamic' - 如果消息总线不支持路由，则使用旧地址 否则使用可路由寻址

- pseudo_vhost[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.pseudo_vhost)

  Type 类型 boolean 布尔 Default 违约 `True`  Enable virtual host support for those message buses that do not natively  support virtual hosting (such as qpidd). When set to true the virtual  host name will be added to all message bus addresses, effectively  creating a private ‘subnet’ per virtual host. Set to False if the  message bus supports virtual hosting using the ‘hostname’ field in the  AMQP 1.0 Open performative as the name of the virtual host. 为那些本机不支持虚拟主机的消息总线（如 qpidd）启用虚拟主机支持。当设置为 true  时，虚拟主机名将添加到所有消息总线地址，从而有效地为每个虚拟主机创建一个专用“子网”。如果消息总线支持使用 AMQP 1.0 Open  performative 中的“hostname”字段作为虚拟主机的名称，则设置为 False。

- server_request_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.server_request_prefix)

  Type 类型 string 字符串 Default 违约 `exclusive`  address prefix used when sending to a specific server 发送到特定服务器时使用的地址前缀 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id29) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 server_request_prefix

- broadcast_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.broadcast_prefix)

  Type 类型 string 字符串 Default 违约 `broadcast`  address prefix used when broadcasting to all servers 广播到所有服务器时使用的地址前缀 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id30) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 broadcast_prefix

- group_request_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.group_request_prefix)

  Type 类型 string 字符串 Default 违约 `unicast`  address prefix when sending to any server in group 发送到组中任何服务器时的地址前缀 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id31) 已弃用的变体 ¶   Group 群 Name 名字  amqp1 AMQP1型 group_request_prefix

- rpc_address_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.rpc_address_prefix)

  Type 类型 string 字符串 Default 违约 `openstack.org/om/rpc`  Address prefix for all generated RPC addresses 所有生成的 RPC 地址的地址前缀

- notify_address_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.notify_address_prefix)

  Type 类型 string 字符串 Default 违约 `openstack.org/om/notify`  Address prefix for all generated Notification addresses 所有生成的通知地址的地址前缀

- multicast_address[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.multicast_address)

  Type 类型 string 字符串 Default 违约 `multicast`  Appended to the address prefix when sending a fanout message. Used by the message bus to identify fanout messages. 在发送扇出消息时追加到地址前缀。由消息总线用于标识扇出消息。

- unicast_address[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.unicast_address)

  Type 类型 string 字符串 Default 违约 `unicast`  Appended to the address prefix when sending to a particular RPC/Notification  server. Used by the message bus to identify messages sent to a single  destination. 在发送到特定 RPC/通知服务器时追加到地址前缀。由消息总线用于标识发送到单个目标的消息。

- anycast_address[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.anycast_address)

  Type 类型 string 字符串 Default 违约 `anycast`  Appended to the address prefix when sending to a group of consumers. Used by the message bus to identify messages that should be delivered in a  round-robin fashion across consumers. 在发送给一组使用者时追加到地址前缀。由消息总线用于标识应以循环方式在使用者之间传递的消息。

- default_notification_exchange[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_notification_exchange)

  Type 类型 string 字符串 Default 违约 `<None>`  Exchange name used in notification addresses. Exchange name resolution precedence: Target.exchange if set else default_notification_exchange if set else control_exchange if set else ‘notify’ 通知地址中使用的交换名称。Exchange 名称解析优先级：Target.exchange if set else default_notification_exchange if  set else control_exchange if set else 'notify'

- default_rpc_exchange[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.default_rpc_exchange)

  Type 类型 string 字符串 Default 违约 `<None>`  Exchange name used in RPC addresses. Exchange name resolution precedence: Target.exchange if set else default_rpc_exchange if set else control_exchange if set else ‘rpc’ RPC 地址中使用的交换名称。Exchange 名称解析优先级：Target.exchange if set else default_rpc_exchange if set else control_exchange if set else 'rpc'

- reply_link_credit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.reply_link_credit)

  Type 类型 integer 整数 Default 违约 `200` Minimum Value 最小值 1  Window size for incoming RPC Reply messages. 传入 RPC 回复消息的窗口大小。

- rpc_server_credit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.rpc_server_credit)

  Type 类型 integer 整数 Default 违约 `100` Minimum Value 最小值 1  Window size for incoming RPC Request messages 传入 RPC 请求消息的窗口大小

- notify_server_credit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.notify_server_credit)

  Type 类型 integer 整数 Default 违约 `100` Minimum Value 最小值 1  Window size for incoming Notification messages 传入通知消息的窗口大小

- pre_settled[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_amqp.pre_settled)

  Type 类型 multi-valued 多值 Default 违约 `rpc-cast` Default 违约 `rpc-reply`  Send messages of this type pre-settled. Pre-settled messages will not receive acknowledgement from the peer. Note well: pre-settled messages may be silently discarded if the delivery fails. Permitted values: ‘rpc-call’ - send RPC Calls pre-settled ‘rpc-reply’- send RPC Replies pre-settled ‘rpc-cast’ - Send RPC Casts pre-settled ‘notify’   - Send Notifications pre-settled 发送此类型的预结算消息。预先结算的消息将不会收到来自对等方的确认。请注意：如果投放失败，预结算的消息可能会被静默丢弃。允许的值： 'rpc-call' - 发送预结算的 RPC 调用 'rpc-reply'- 发送预结算的 RPC 回复 'rpc-cast' -  发送预结算的 RPC 强制转换 'notify' - 发送预结算的通知



### oslo_messaging_kafka[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo-messaging-kafka)

- kafka_max_fetch_bytes[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.kafka_max_fetch_bytes)

  Type 类型 integer 整数 Default 违约 `1048576`  Max fetch bytes of Kafka consumer Kafka 使用者的最大提取字节数

- kafka_consumer_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.kafka_consumer_timeout)

  Type 类型 floating point 浮点 Default 违约 `1.0`  Default timeout(s) for Kafka consumers Kafka 使用者的默认超时

- pool_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.pool_size)

  Type 类型 integer 整数 Default 违约 `10`  Pool Size for Kafka Consumers Kafka 使用者的池大小  Warning 警告 This option is deprecated for removal. Its value may be silently ignored  in the future. 此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 Driver no longer uses connection pool. 驱动程序不再使用连接池。

- conn_pool_min_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.conn_pool_min_size)

  Type 类型 integer 整数 Default 违约 `2`  The pool size limit for connections expiration policy 连接过期策略的池大小限制  Warning 警告 This option is deprecated for removal. Its value may be silently ignored  in the future. 此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 Driver no longer uses connection pool. 驱动程序不再使用连接池。

- conn_pool_ttl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.conn_pool_ttl)

  Type 类型 integer 整数 Default 违约 `1200`  The time-to-live in sec of idle connections in the pool 池中空闲连接的生存时间（以秒为单位）  Warning 警告 This option is deprecated for removal. Its value may be silently ignored  in the future. 此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 Driver no longer uses connection pool. 驱动程序不再使用连接池。

- consumer_group[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.consumer_group)

  Type 类型 string 字符串 Default 违约 `oslo_messaging_consumer`  Group id for Kafka consumer. Consumers in one group will coordinate message consumption Kafka 使用者的组 ID。一个组中的使用者将协调消息使用。

- producer_batch_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.producer_batch_timeout)

  Type 类型 floating point 浮点 Default 违约 `0.0`  Upper bound on the delay for KafkaProducer batching in seconds KafkaProducer 批处理延迟的上限（以秒为单位）

- producer_batch_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.producer_batch_size)

  Type 类型 integer 整数 Default 违约 `16384`  Size of batch for the producer async send 生产者异步发送的批处理大小

- compression_codec[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.compression_codec)

  Type 类型 string 字符串 Default 违约 `none` Valid Values 有效值 none, gzip, snappy, lz4, zstd 无、gzip、snappy、lz4、zstd  The compression codec for all data generated by the producer. If not set,  compression will not be used. Note that the allowed values of this  depend on the kafka version 生产者生成的所有数据的压缩编解码器。如果未设置，则不会使用压缩。请注意，允许的值取决于 kafka 版本

- enable_auto_commit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.enable_auto_commit)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable asynchronous consumer commits 启用异步使用者提交

- max_poll_records[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.max_poll_records)

  Type 类型 integer 整数 Default 违约 `500`  The maximum number of records returned in a poll call 轮询调用中返回的最大记录数

- security_protocol[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.security_protocol)

  Type 类型 string 字符串 Default 违约 `PLAINTEXT` Valid Values 有效值 PLAINTEXT, SASL_PLAINTEXT, SSL, SASL_SSL 明文、SASL_PLAINTEXT、SSL SASL_SSL  Protocol used to communicate with brokers 用于与经纪人通信的协议

- sasl_mechanism[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.sasl_mechanism)

  Type 类型 string 字符串 Default 违约 `PLAIN`  Mechanism when security protocol is SASL 安全协议为 SASL 时的机制

- ssl_cafile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.ssl_cafile)

  Type 类型 string 字符串 Default 违约 `''`  CA certificate PEM file used to verify the server certificate CA 证书 用于验证服务器证书的 PEM 文件

- ssl_client_cert_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.ssl_client_cert_file)

  Type 类型 string 字符串 Default 违约 `''`  Client certificate PEM file used for authentication. 用于身份验证的客户端证书 PEM 文件。

- ssl_client_key_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.ssl_client_key_file)

  Type 类型 string 字符串 Default 违约 `''`  Client key PEM file used for authentication. 用于身份验证的客户端密钥 PEM 文件。

- ssl_client_key_password[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_kafka.ssl_client_key_password)

  Type 类型 string 字符串 Default 违约 `''`  Client key password file used for authentication. 用于身份验证的客户端密钥密码文件。



### oslo_messaging_notifications[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo-messaging-notifications)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_notifications.driver) 驱动程序 ¶

  Type 类型 multi-valued 多值 Default 违约 `''`  The Drivers(s) to handle sending notifications. Possible values are messaging, messagingv2, routing, log, test, noop 用于处理发送通知的驱动程序。可能的值为 messaging、messagingv2、routing、log、test、noop Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id32) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 notification_driver

- transport_url[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_notifications.transport_url)

  Type 类型 string 字符串 Default 违约 `<None>`  A URL representing the messaging driver to use for notifications. If not  set, we fall back to the same configuration used for RPC. 表示要用于通知的消息传递驱动程序的 URL。如果未设置，我们将回退到用于 RPC 的相同配置。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id33) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 notification_transport_url

- topics[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_notifications.topics) 主题 ¶

  Type 类型 list 列表 Default 违约 `['notifications']`  AMQP topic used for OpenStack notifications. 用于 OpenStack 通知的 AMQP 主题。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id34) 已弃用的变体 ¶   Group 群 Name 名字  rpc_notifier2 topics 主题 DEFAULT 违约 notification_topics

- retry[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_notifications.retry) 重试 ¶

  Type 类型 integer 整数 Default 违约 `-1`  The maximum number of attempts to re-send a notification message which  failed to be delivered due to a recoverable error. 0 - No retry, -1 -  indefinite 尝试重新发送由于可恢复错误而无法传递的通知消息的最大尝试次数。0 - 不重试，-1 - 无限期



### oslo_messaging_rabbit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo-messaging-rabbit)

- amqp_durable_queues[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.amqp_durable_queues)

  Type 类型 boolean 布尔 Default 违约 `False`  Use durable queues in AMQP. If rabbit_quorum_queue is enabled, queues will be durable and this value will be ignored. 在 AMQP 中使用持久队列。如果启用了rabbit_quorum_queue，队列将是持久的，并且将忽略此值。

- amqp_auto_delete[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.amqp_auto_delete)

  Type 类型 boolean 布尔 Default 违约 `False`  Auto-delete queues in AMQP. AMQP 中的自动删除队列。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id35) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 amqp_auto_delete

- ssl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.ssl) SSL协议 ¶

  Type 类型 boolean 布尔 Default 违约 `False`  Connect over SSL. 通过 SSL 连接。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id36) 已弃用的变体 ¶   Group 群 Name 名字  oslo_messaging_rabbit rabbit_use_ssl

- ssl_version[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.ssl_version)

  Type 类型 string 字符串 Default 违约 `''`  SSL version to use (valid only if SSL enabled). Valid values are TLSv1 and  SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may be available on some  distributions. 要使用的 SSL 版本（仅当启用 SSL 时才有效）。有效值为 TLSv1 和 SSLv23。 SSLv2、SSLv3、TLSv1_1 和 TLSv1_2 可能在某些发行版上可用。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id37) 已弃用的变体 ¶   Group 群 Name 名字  oslo_messaging_rabbit kombu_ssl_version

- ssl_key_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.ssl_key_file)

  Type 类型 string 字符串 Default 违约 `''`  SSL key file (valid only if SSL enabled). SSL 密钥文件（仅当启用 SSL 时才有效）。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id38) 已弃用的变体 ¶   Group 群 Name 名字  oslo_messaging_rabbit kombu_ssl_keyfile

- ssl_cert_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.ssl_cert_file)

  Type 类型 string 字符串 Default 违约 `''`  SSL cert file (valid only if SSL enabled). SSL 证书文件（仅当启用 SSL 时才有效）。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id39) 已弃用的变体 ¶   Group 群 Name 名字  oslo_messaging_rabbit kombu_ssl_certfile

- ssl_ca_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.ssl_ca_file)

  Type 类型 string 字符串 Default 违约 `''`  SSL certification authority file (valid only if SSL enabled). SSL 证书颁发机构文件（仅当启用 SSL 时才有效）。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id40) 已弃用的变体 ¶   Group 群 Name 名字  oslo_messaging_rabbit kombu_ssl_ca_certs

- heartbeat_in_pthread[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.heartbeat_in_pthread)

  Type 类型 boolean 布尔 Default 违约 `True`  Run the health check heartbeat thread through a native python thread by  default. If this option is equal to False then the health check  heartbeat will inherit the execution model from the parent process. For  example if the parent process has monkey patched the stdlib by using  eventlet/greenlet then the heartbeat will be run through a green thread. 默认情况下，通过原生 python 线程运行健康检查心跳线程。如果此选项等于 False，则运行状况检查检测信号将从父进程继承执行模型。例如，如果父进程使用  eventlet/greenlet 对 stdlib 进行了 monkey 修补，则检测信号将通过绿色线程运行。

- kombu_reconnect_delay[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.kombu_reconnect_delay)

  Type 类型 floating point 浮点 Default 违约 `1.0` Minimum Value 最小值 0.0 Maximum Value 最大值 4.5  How long to wait (in seconds) before reconnecting in response to an AMQP consumer cancel notification. 在响应 AMQP 使用者取消通知之前需要等待多长时间（以秒为单位）。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id41) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 kombu_reconnect_delay

- kombu_compression[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.kombu_compression)

  Type 类型 string 字符串 Default 违约 `<None>`  EXPERIMENTAL: Possible values are: gzip, bz2. If not set compression will not be  used. This option may not be available in future versions. 实验性的：可能的值为：gzip、bz2。否则，将不使用压缩。此选项在将来的版本中可能不可用。

- kombu_missing_consumer_retry_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.kombu_missing_consumer_retry_timeout)

  Type 类型 integer 整数 Default 违约 `60`  How long to wait a missing client before abandoning to send it its replies. This value should not be longer than rpc_response_timeout. 在放弃向其发送回复之前，需要等待多长时间才能丢失的客户。此值不应长于 rpc_response_timeout。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id42) 已弃用的变体 ¶   Group 群 Name 名字  oslo_messaging_rabbit kombu_reconnect_timeout

- kombu_failover_strategy[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.kombu_failover_strategy)

  Type 类型 string 字符串 Default 违约 `round-robin` Valid Values 有效值 round-robin, shuffle 循环，随机播放  Determines how the next RabbitMQ node is chosen in case the one we are currently  connected to becomes unavailable. Takes effect only if more than one  RabbitMQ node is provided in config. 确定在我们当前连接到的节点不可用的情况下如何选择下一个 RabbitMQ 节点。仅当 config 中提供了多个 RabbitMQ 节点时才生效。

- rabbit_login_method[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_login_method)

  Type 类型 string 字符串 Default 违约 `AMQPLAIN` Valid Values 有效值 PLAIN, AMQPLAIN, RABBIT-CR-DEMO 普通、AMQPLAIN、RABBIT-CR-DEMO  The RabbitMQ login method. RabbitMQ 登录方法。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id43) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 rabbit_login_method

- rabbit_retry_interval[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_retry_interval)

  Type 类型 integer 整数 Default 违约 `1`  How frequently to retry connecting with RabbitMQ. 重试连接 RabbitMQ 的频率。

- rabbit_retry_backoff[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_retry_backoff)

  Type 类型 integer 整数 Default 违约 `2`  How long to backoff for between retries when connecting to RabbitMQ. 连接到 RabbitMQ 时，两次重试之间要回退多长时间。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id44) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 rabbit_retry_backoff

- rabbit_interval_max[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_interval_max)

  Type 类型 integer 整数 Default 违约 `30`  Maximum interval of RabbitMQ connection retries. Default is 30 seconds. RabbitMQ 连接重试的最大间隔。默认值为 30 秒。

- rabbit_ha_queues[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_ha_queues)

  Type 类型 boolean 布尔 Default 违约 `False`  Try to use HA queues in RabbitMQ (x-ha-policy: all). If you change this  option, you must wipe the RabbitMQ database. In RabbitMQ 3.0, queue  mirroring is no longer controlled by the x-ha-policy argument when  declaring a queue. If you just want to make sure that all queues (except those with auto-generated names) are mirrored across all nodes, run:  “rabbitmqctl set_policy HA ‘^(?!amq.).*’ ‘{“ha-mode”: “all”}’ “ 尝试在 RabbitMQ 中使用 HA 队列 （x-ha-policy： all）。如果更改此选项，则必须擦除 RabbitMQ 数据库。在  RabbitMQ 3.0 中，声明队列时，队列镜像不再受 x-ha-policy  参数控制。如果您只想确保所有队列（具有自动生成名称的队列除外）都镜像到所有节点，请运行：“rabbitmqctl set_policy HA  '^（？！amq.）。*' '{“ha-mode”： “全部”}' ” Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id45) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 rabbit_ha_queues

- rabbit_quorum_queue[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_quorum_queue)

  Type 类型 boolean 布尔 Default 违约 `False`  Use quorum queues in RabbitMQ (x-queue-type: quorum). The quorum queue is a modern queue type for RabbitMQ implementing a durable, replicated FIFO  queue based on the Raft consensus algorithm. It is available as of  RabbitMQ 3.8.0. If set this option will conflict with the HA queues (`rabbit_ha_queues`) aka mirrored queues, in other words the HA queues should be disabled,  quorum queues durable by default so the amqp_durable_queues opion is  ignored when this option enabled. 在 RabbitMQ 中使用仲裁队列 （x-queue-type： quorum）。仲裁队列是 RabbitMQ 的一种现代队列类型，它实现了基于 Raft 共识算法的持久、复制的 FIFO 队列。它从 RabbitMQ 3.8.0 开始可用。如果设置此选项，则该选项将与 HA 队列 （ `rabbit_ha_queues` ） （又名镜像队列）冲突，换句话说，应禁用 HA 队列，默认情况下仲裁队列是持久的，因此在启用此选项时将忽略amqp_durable_queues。

- rabbit_transient_queues_ttl[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_transient_queues_ttl)

  Type 类型 integer 整数 Default 违约 `1800` Minimum Value 最小值 1  Positive integer representing duration in seconds for queue TTL (x-expires).  Queues which are unused for the duration of the TTL are automatically  deleted. The parameter affects only reply and fanout queues. 正整数，表示队列 TTL （x-expires） 的持续时间（以秒为单位）。在 TTL 期间未使用的队列将自动删除。该参数仅影响应答队列和扇出队列。

- rabbit_qos_prefetch_count[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.rabbit_qos_prefetch_count)

  Type 类型 integer 整数 Default 违约 `0`  Specifies the number of messages to prefetch. Setting to zero allows unlimited messages. 指定要预提取的消息数。设置为零允许无限的消息。

- heartbeat_timeout_threshold[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.heartbeat_timeout_threshold)

  Type 类型 integer 整数 Default 违约 `60`  Number of seconds after which the Rabbit broker is considered down if heartbeat’s keep-alive fails (0 disables heartbeat). 如果检测信号的保持活动失败（0 禁用检测信号），则 Rabbit 代理被视为关闭的秒数。

- heartbeat_rate[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.heartbeat_rate)

  Type 类型 integer 整数 Default 违约 `2`  How often times during the heartbeat_timeout_threshold we check the heartbeat.

- direct_mandatory_flag[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.direct_mandatory_flag)

  Type 类型 boolean 布尔 Default 违约 `True`  (DEPRECATED) Enable/Disable the RabbitMQ mandatory flag for direct send. The direct  send is used as reply, so the MessageUndeliverable exception is raised  in case the client queue does not exist.MessageUndeliverable exception  will be used to loop for a timeout to lets a chance to sender to  recover.This flag is deprecated and it will not be possible to  deactivate this functionality anymore （已弃用）启用/禁用直接发送的 RabbitMQ 强制标志。直接发送用作回复，因此在客户端队列不存在的情况下引发 MessageUndeliverable  异常。MessageUndeliverable 异常将用于循环超时，以便发送者有机会恢复。此标志已弃用，无法再停用此功能  Warning 警告 This option is deprecated for removal. Its value may be silently ignored  in the future. 此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。 Reason 原因 Mandatory flag no longer deactivable. 强制标志不再可停用。

- enable_cancel_on_failover[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_messaging_rabbit.enable_cancel_on_failover)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable x-cancel-on-ha-failover flag so that rabbitmq server will cancel and notify consumerswhen queue is down 启用 x-cancel-on-ha-failover 标志，以便 rabbitmq 服务器在队列关闭时取消并通知消费者



### oslo_middleware[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo-middleware)

- max_request_body_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_middleware.max_request_body_size)

  Type 类型 integer 整数 Default 违约 `114688`  The maximum body size for each  request, in bytes. 每个请求的最大正文大小（以字节为单位）。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id46) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 osapi_max_request_body_size DEFAULT 违约 max_request_body_size

- secure_proxy_ssl_header[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_middleware.secure_proxy_ssl_header)

  Type 类型 string 字符串 Default 违约 `X-Forwarded-Proto`  The HTTP Header that will be used to determine what the original request  protocol scheme was, even if it was hidden by a SSL termination proxy. HTTP 标头，用于确定原始请求协议方案是什么，即使它被 SSL 终止代理隐藏。  Warning 警告 This option is deprecated for removal. Its value may be silently ignored  in the future. 此选项已弃用，无法删除。它的价值将来可能会被默默地忽略。

- enable_proxy_headers_parsing[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_middleware.enable_proxy_headers_parsing)

  Type 类型 boolean 布尔 Default 违约 `False`  Whether the application is behind a proxy or not. This determines if the middleware should parse the headers or not. 应用程序是否位于代理后面。这决定了中间件是否应该解析标头。

- http_basic_auth_user_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_middleware.http_basic_auth_user_file)

  Type 类型 string 字符串 Default 违约 `/etc/htpasswd`  HTTP basic auth password file. HTTP 基本身份验证密码文件。



### oslo_policy[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo-policy)

- enforce_scope[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.enforce_scope)

  Type 类型 boolean 布尔 Default 违约 `False`  This option controls whether or not to enforce scope when evaluating policies. If `True`, the scope of the token used in the request is compared to the `scope_types` of the policy being enforced. If the scopes do not match, an `InvalidScope` exception will be raised. If `False`, a message will be logged informing operators that policies are being invoked with mismatching scope. 此选项控制在评估策略时是否强制实施范围。如果 `True` ，则将请求中使用的令牌的范围与 `scope_types` 正在强制执行的策略的范围进行比较。如果范围不匹配，则会引发 `InvalidScope` 异常。如果 `False` ，将记录一条消息，通知操作员正在调用范围不匹配的策略。

- enforce_new_defaults[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.enforce_new_defaults)

  Type 类型 boolean 布尔 Default 违约 `False`  This option controls whether or not to use old deprecated defaults when evaluating policies. If `True`, the old deprecated defaults are not going to be evaluated. This means  if any existing token is allowed for old defaults but is disallowed for  new defaults, it will be disallowed. It is encouraged to enable this  flag along with the `enforce_scope` flag so that you can get the benefits of new defaults and `scope_type` together. If `False`, the deprecated policy check string is logically OR’d with the new  policy check string, allowing for a graceful upgrade experience between  releases with new policies, which is the default behavior. 此选项控制在评估策略时是否使用旧的已弃用默认值。如果 `True` ，则不会评估旧的已弃用默认值。这意味着，如果任何现有令牌被允许用于旧的默认值，但不允许用于新的默认值，则将不允许该令牌。建议将此标志与该标志一起启用， `enforce_scope` 以便您可以 `scope_type` 一起获得新默认值的好处。如果 `False` ，则弃用的策略检查字符串在逻辑上与新策略检查字符串一起 OR'd，从而允许在具有新策略的版本之间提供正常升级体验，这是默认行为。

- policy_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.policy_file)

  Type 类型 string 字符串 Default 违约 `policy.yaml`  The relative or absolute path of a file that maps roles to permissions for a given service. Relative paths must be specified in relation to the  configuration file setting this option. 将角色映射到给定服务的权限的文件的相对路径或绝对路径。必须指定与设置此选项的配置文件相关的相对路径。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id47) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 policy_file

- policy_default_rule[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.policy_default_rule)

  Type 类型 string 字符串 Default 违约 `default`  Default rule. Enforced when a requested rule is not found. 默认规则。在未找到请求的规则时强制执行。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id48) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 policy_default_rule

- policy_dirs[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.policy_dirs)

  Type 类型 multi-valued 多值 Default 违约 `policy.d`  Directories where policy configuration files are stored. They can be relative to  any directory in the search path defined by the config_dir option, or  absolute paths. The file defined by policy_file must exist for these  directories to be searched.  Missing or empty directories are ignored. 存储策略配置文件的目录。它们可以相对于config_dir选项定义的搜索路径中的任何目录，也可以是绝对路径。policy_file定义的文件必须存在，才能搜索这些目录。缺少或空的目录将被忽略。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id49) 已弃用的变体 ¶   Group 群 Name 名字  DEFAULT 违约 policy_dirs

- remote_content_type[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.remote_content_type)

  Type 类型 string 字符串 Default 违约 `application/x-www-form-urlencoded` Valid Values 有效值 application/x-www-form-urlencoded, application/json application/x-www-form-urlencoded， application/json  Content Type to send and receive data for REST based policy check 用于发送和接收数据以进行基于 REST 的策略检查的内容类型

- remote_ssl_verify_server_crt[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.remote_ssl_verify_server_crt)

  Type 类型 boolean 布尔 Default 违约 `False`  server identity verification for REST based policy check 用于基于 REST 的策略检查的服务器身份验证

- remote_ssl_ca_crt_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.remote_ssl_ca_crt_file)

  Type 类型 string 字符串 Default 违约 `<None>`  Absolute path to ca cert file for REST based policy check 用于基于 REST 的策略检查的 ca 证书文件的绝对路径

- remote_ssl_client_crt_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.remote_ssl_client_crt_file)

  Type 类型 string 字符串 Default 违约 `<None>`  Absolute path to client cert for REST based policy check 用于基于 REST 的策略检查的客户端证书的绝对路径

- remote_ssl_client_key_file[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#oslo_policy.remote_ssl_client_key_file)

  Type 类型 string 字符串 Default 违约 `<None>`  Absolute path client key file REST based policy check 基于绝对路径客户端密钥文件REST的策略检查



### policy[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#policy) 策略 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#policy.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the policy backend driver in the keystone.policy namespace. Supplied drivers are rules (which does not support any CRUD operations for the v3 policy API) and sql. Typically, there is no reason to set this option unless you are providing a custom entry point. keystone.policy 命名空间中策略后端驱动程序的入口点。提供的驱动程序是规则（不支持 v3 策略 API 的任何 CRUD 操作）和 sql。通常，除非您提供自定义入口点，否则没有理由设置此选项。

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#policy.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  Maximum number of entities that will be returned in a policy collection. 将在策略集合中返回的最大实体数。



### profiler[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler) 探查器 ¶

- enabled[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.enabled) 已启用 ¶

  Type 类型 boolean 布尔 Default 违约 `False`  Enable the profiling for all services on this node. 为此节点上的所有服务启用性能分析。 Default value is False (fully disable the profiling feature). 默认值为 False（完全禁用分析功能）。 Possible values: 可能的值： True: Enables the feature True：启用该功能 False: Disables the feature. The profiling cannot be started via this project operations. If the profiling is triggered by another project, this project part will be empty. False：关闭该功能。无法通过此项目操作启动分析。如果分析是由另一个项目触发的，则此项目部分将为空。  Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id50) 已弃用的变体 ¶   Group 群 Name 名字  profiler 分析器 profiler_enabled

- trace_sqlalchemy[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.trace_sqlalchemy)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable SQL requests profiling in services. 在服务中启用 SQL 请求分析。 Default value is False (SQL requests won’t be traced). 默认值为 False（不会跟踪 SQL 请求）。 Possible values: 可能的值： True: Enables SQL requests profiling. Each SQL query will be part of the trace and can the be analyzed by how much time was spent for that. True：启用 SQL 请求分析。每个 SQL 查询都将是跟踪的一部分，并且可以通过为此花费的时间进行分析。 False: Disables SQL requests profiling. The spent time is only shown on a higher level of operations. Single SQL queries cannot be analyzed this way. False：禁用 SQL 请求分析。花费的时间仅在更高级别的操作上显示。不能以这种方式分析单个 SQL 查询。

- hmac_keys[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.hmac_keys)

  Type 类型 string 字符串 Default 违约 `SECRET_KEY`  Secret key(s) to use for encrypting context data for performance profiling. 用于加密上下文数据以进行性能分析的密钥。 This string value should have the following format: <key1>[,<key2>,…<keyn>], where each key is some random string. A user who triggers the profiling via the REST API has to set one of these keys in the headers of the REST API call to include profiling results of this node for this particular project. 此字符串值应采用以下格式：[，,...]，其中每个键都是一些随机字符串。通过 REST API 触发分析的用户必须在 REST API 调用的标头中设置其中一个键，以包含此特定项目的此节点的分析结果。 Both “enabled” flag and “hmac_keys” config options should be set to enable profiling. Also, to generate correct profiling information across all services at least one key needs to be consistent between OpenStack projects. This ensures it can be used from client side to generate the trace, containing information from all possible resources. “enabled”标志和“hmac_keys”配置选项都应设置为启用分析。此外，为了在所有服务中生成正确的分析信息，OpenStack项目之间至少需要有一个密钥保持一致。这确保了可以从客户端使用它来生成跟踪，其中包含来自所有可能资源的信息。

- connection_string[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.connection_string)

  Type 类型 string 字符串 Default 违约 `messaging://`  Connection string for a notifier backend. 通知程序后端的连接字符串。 Default value is `messaging://` which sets the notifier to oslo_messaging. 默认值是 `messaging://` 将通知程序设置为 oslo_messaging。 Examples of possible values: 可能的值示例： `messaging://` - use oslo_messaging driver for sending spans.  `messaging://` - 使用oslo_messaging驱动程序发送 span。 `redis://127.0.0.1:6379` - use redis driver for sending spans.  `redis://127.0.0.1:6379` - 使用 Redis 驱动发送 SPAN。 `mongodb://127.0.0.1:27017` - use mongodb driver for sending spans.  `mongodb://127.0.0.1:27017` - 使用 MongoDB 驱动程序发送 span。 `elasticsearch://127.0.0.1:9200` - use elasticsearch driver for sending spans.  `elasticsearch://127.0.0.1:9200` - 使用Elasticsearch驱动发送span。 `jaeger://127.0.0.1:6831` - use jaeger tracing as driver for sending spans.  `jaeger://127.0.0.1:6831` - 使用 Jaeger Tracing 作为发送 span 的驱动程序。

- es_doc_type[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.es_doc_type)

  Type 类型 string 字符串 Default 违约 `notification`  Document type for notification indexing in elasticsearch. Elasticsearch 中用于通知索引的文档类型。

- es_scroll_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.es_scroll_time)

  Type 类型 string 字符串 Default 违约 `2m`  This parameter is a time value parameter (for example: es_scroll_time=2m), indicating for how long the nodes that participate in the search will maintain relevant resources in order to continue and support it. 该参数是一个时间值参数（例如：es_scroll_time=2m），表示参与搜索的节点将维护相关资源多长时间，以便继续和支持它。

- es_scroll_size[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.es_scroll_size)

  Type 类型 integer 整数 Default 违约 `10000`  Elasticsearch splits large requests in batches. This parameter defines maximum size of each batch (for example: es_scroll_size=10000). Elasticsearch 将大型请求分批拆分。此参数定义每个批次的最大大小（例如：es_scroll_size=10000）。

- socket_timeout[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.socket_timeout)

  Type 类型 floating point 浮点 Default 违约 `0.1`  Redissentinel provides a timeout option on the connections. This parameter defines that timeout (for example: socket_timeout=0.1). Redissentinel 在连接上提供超时选项。此参数定义超时（例如：socket_timeout=0.1）。

- sentinel_service_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.sentinel_service_name)

  Type 类型 string 字符串 Default 违约 `mymaster`  Redissentinel uses a service name to identify a master redis service. This parameter defines the name (for example: `sentinal_service_name=mymaster`). Redissentinel 使用服务名称来标识主 redis 服务。此参数定义名称（例如： `sentinal_service_name=mymaster` ）。

- filter_error_trace[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#profiler.filter_error_trace)

  Type 类型 boolean 布尔 Default 违约 `False`  Enable filter traces that contain error/exception to a separated place. 将包含错误/异常的筛选器跟踪启用到一个单独的位置。 Default value is set to False. 默认值设置为 False。 Possible values: 可能的值： True: Enable filter traces that contain error/exception. True：启用包含错误/异常的筛选器跟踪。 False: Disable the filter. False：关闭过滤器。



### receipt[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#receipt) 收据 ¶

- expiration[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#receipt.expiration) 过期 ¶

  Type 类型 integer 整数 Default 违约 `300` Minimum Value 最小值 0 Maximum Value 最大值 86400  The amount of time that a receipt should remain valid (in seconds). This  value should always be very short, as it represents how long a user has  to reattempt auth with the missing auth methods. 收据应保持有效的时间（以秒为单位）。此值应始终非常短，因为它表示用户必须使用缺少的身份验证方法重新尝试身份验证的时间。

- provider[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#receipt.provider) 提供程序 ¶

  Type 类型 string 字符串 Default 违约 `fernet`  Entry point for the receipt provider in the keystone.receipt.provider namespace. The receipt provider controls the receipt construction and validation operations. Keystone includes just the fernet receipt provider for now. fernet receipts do not need to be persisted at all, but require that you run keystone-manage fernet_setup (also see the keystone-manage fernet_rotate command). keystone.receipt.provider 命名空间中收据提供程序的入口点。收据提供程序控制收据构造和验证操作。Keystone 目前仅包括 fernet 收据提供程序。Fernet  收据根本不需要保留，但需要您运行 keystone-manage fernet_setup（另请参阅 keystone-manage  fernet_rotate 命令）。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#receipt.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for caching receipt creation and validation data. This has no effect  unless global caching is enabled, or if cache_on_issue is disabled as we only cache receipts on issue. 切换以缓存收据创建和验证数据。除非启用了全局缓存，或者禁用了全局缓存，否则这不起作用cache_on_issue，因为我们只缓存发出的收据。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#receipt.cache_time)

  Type 类型 integer 整数 Default 违约 `300` Minimum Value 最小值 0  The number of seconds to cache receipt creation and validation data. This has no effect unless both global and [receipt] caching are enabled. 缓存收据创建和验证数据的秒数。除非同时启用全局缓存和 [接收] 缓存，否则这不起作用。

- cache_on_issue[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#receipt.cache_on_issue)

  Type 类型 boolean 布尔 Default 违约 `True`  Enable storing issued receipt data to receipt validation cache so that first  receipt validation doesn’t actually cause full validation cycle. This  option has no effect unless global caching and receipt caching are  enabled. 允许将已发出的收据数据存储到收据验证缓存，以便第一次收据验证实际上不会导致完整的验证周期。除非启用全局缓存和收据缓存，否则此选项无效。



### resource[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource) 资源 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the resource driver in the keystone.resource namespace. Only a sql driver is supplied by keystone. Unless you are writing proprietary drivers for keystone, you do not need to set this option. keystone.resource 命名空间中资源驱动程序的入口点。Keystone 仅提供 sql 驱动程序。除非您正在为 keystone 编写专有驱动程序，否则不需要设置此选项。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for resource caching. This has no effect unless global caching is enabled. 切换资源缓存。除非启用全局缓存，否则这不起作用。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id51) 已弃用的变体 ¶   Group 群 Name 名字  assignment 分配 caching 缓存

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>`  Time to cache resource data in seconds. This has no effect unless global caching is enabled. 缓存资源数据的时间（以秒为单位）。除非启用全局缓存，否则这不起作用。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id52) 已弃用的变体 ¶   Group 群 Name 名字  assignment 分配 cache_time

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  Maximum number of entities that will be returned in a resource collection. 资源集合中将返回的最大实体数。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id53) 已弃用的变体 ¶   Group 群 Name 名字  assignment 分配 list_limit

- admin_project_domain_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.admin_project_domain_name)

  Type 类型 string 字符串 Default 违约 `<None>`  Name of the domain that owns the admin_project_name. If left unset, then there is no admin project. [resource] admin_project_name must also be set to use this option. 拥有admin_project_name的域的名称。如果未设置，则没有管理项目。[资源] 还必须将admin_project_name设置为使用此选项。

- admin_project_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.admin_project_name)

  Type 类型 string 字符串 Default 违约 `<None>`  This is a special project which represents cloud-level administrator  privileges across services. Tokens scoped to this project will contain a true is_admin_project attribute to indicate to policy systems that the role assignments on  that specific project should apply equally across every project. If left unset, then there is no admin project, and thus no explicit means of  cross-project role assignments. [resource] admin_project_domain_name must also be set to use this option. 这是一个特殊的项目，表示跨服务的云级管理员权限。限定为此项目的令牌将包含一个 true is_admin_project  属性，以向策略系统指示该特定项目的角色分配应平等地应用于每个项目。如果未设置，则没有管理项目，因此没有跨项目角色分配的显式方法。还必须将  [resource] admin_project_domain_name设置为使用此选项。

- project_name_url_safe[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.project_name_url_safe)

  Type 类型 string 字符串 Default 违约 `off` Valid Values 有效值 off, new, strict 关闭、新建、严格  This controls whether the names of projects are restricted from containing URL-reserved characters. If set to new, attempts to create or update a project with a URL-unsafe name will fail. If set to strict, attempts to scope a token with a URL-unsafe project name will fail,  thereby forcing all project names to be updated to be URL-safe. 这将控制是否限制项目名称包含 URL 保留字符。如果设置为“新建”，则尝试创建或更新具有 URL 不安全名称的项目将失败。如果设置为 strict，则尝试使用不安全的 URL 项目名称来限定令牌的作用域将失败，从而强制将所有项目名称更新为安全的 URL。

- domain_name_url_safe[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#resource.domain_name_url_safe)

  Type 类型 string 字符串 Default 违约 `off` Valid Values 有效值 off, new, strict 关闭、新建、严格  This controls whether the names of domains are restricted from containing URL-reserved characters. If set to new, attempts to create or update a domain with a URL-unsafe name will fail. If set to strict, attempts to scope a token with a URL-unsafe domain name will fail,  thereby forcing all domain names to be updated to be URL-safe. 这将控制域名称是否被限制为包含 URL 保留字符。如果设置为“新建”，则尝试使用不安全的 URL 名称创建或更新域将失败。如果设置为 strict，则尝试使用 URL 不安全域名来限定令牌的作用域将失败，从而强制将所有域名更新为 URL 安全域名。



### revoke[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#revoke) 撤销 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#revoke.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the token revocation backend driver in the keystone.revoke namespace. Keystone only provides a sql driver, so there is no reason to set this option unless you are providing a custom entry point. keystone.revoke 命名空间中令牌吊销后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由设置此选项。

- expiration_buffer[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#revoke.expiration_buffer)

  Type 类型 integer 整数 Default 违约 `1800` Minimum Value 最小值 0  The number of seconds after a token has expired before a corresponding revocation event may be purged from the backend. 令牌过期后，从后端清除相应吊销事件的秒数。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#revoke.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for revocation event caching. This has no effect unless global caching is enabled. 切换吊销事件缓存。除非启用全局缓存，否则这不起作用。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#revoke.cache_time)

  Type 类型 integer 整数 Default 违约 `3600`  Time to cache the revocation list and the revocation events (in seconds). This has no effect unless global and [revoke] caching are both enabled. 缓存吊销列表和吊销事件的时间（以秒为单位）。除非同时启用全局缓存和 [revoke] 缓存，否则这不起作用。 Deprecated Variations[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#id54) 已弃用的变体 ¶   Group 群 Name 名字  token 令 牌 revocation_cache_time



### role[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#role) 角色 ¶

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#role.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `<None>`  Entry point for the role backend driver in the keystone.role namespace. Keystone only provides a sql driver, so there’s no reason to change this unless you are providing a custom entry point. keystone.role 命名空间中角色后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此设置。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#role.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for role caching. This has no effect unless global caching is enabled.  In a typical deployment, there is no reason to disable this. 切换角色缓存。除非启用全局缓存，否则这不起作用。在典型部署中，没有理由禁用此功能。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#role.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>`  Time to cache role data, in seconds. This has no effect unless both global caching and [role] caching are enabled. 缓存角色数据的时间（以秒为单位）。除非同时启用全局缓存和 [角色] 缓存，否则这不起作用。

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#role.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  Maximum number of entities that will be returned in a role collection. This may be useful to tune if you have a large number of discrete roles in your  deployment. 将在角色集合中返回的最大实体数。如果部署中有大量离散角色，则这对于优化可能很有用。



### saml[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml)

- assertion_expiration_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.assertion_expiration_time)

  Type 类型 integer 整数 Default 违约 `3600`  Determines the lifetime for any SAML assertions generated by keystone, using NotOnOrAfter attributes. 使用 NotOnOrAfter 属性确定 keystone 生成的任何 SAML 断言的生存期。

- xmlsec1_binary[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.xmlsec1_binary)

  Type 类型 string 字符串 Default 违约 `xmlsec1`  Name of, or absolute path to, the binary to be used for XML signing. Although only the XML Security Library (xmlsec1) is supported, it may have a non-standard name or path on your system.  If keystone cannot find the binary itself, you may need to install the  appropriate package, use this option to specify an absolute path, or  adjust keystone’s PATH environment variable. 用于 XML 签名的二进制文件的名称或绝对路径。尽管仅支持 XML 安全库 （xmlsec1），但它在系统上可能具有非标准名称或路径。如果  keystone 找不到二进制文件本身，您可能需要安装相应的软件包，使用此选项指定绝对路径，或调整 keystone 的 PATH 环境变量。

- certfile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.certfile) cert文件 ¶

  Type 类型 string 字符串 Default 违约 `/etc/keystone/ssl/certs/signing_cert.pem`  Absolute path to the public certificate file to use for SAML signing. The value cannot contain a comma (,). 用于 SAML 签名的公共证书文件的绝对路径。该值不能包含逗号 （）。

- keyfile[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.keyfile) 密钥文件 ¶

  Type 类型 string 字符串 Default 违约 `/etc/keystone/ssl/private/signing_key.pem`  Absolute path to the private key file to use for SAML signing. The value cannot contain a comma (,). 用于 SAML 签名的私钥文件的绝对路径。该值不能包含逗号 （）。

- idp_entity_id[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_entity_id)

  Type 类型 URI Default 违约 `<None>`  This is the unique entity identifier of the identity provider (keystone) to  use when generating SAML assertions. This value is required to generate  identity provider metadata and must be a URI (a URL is recommended). For example: https://keystone.example.com/v3/OS-FEDERATION/saml2/idp. 这是生成 SAML 断言时要使用的身份提供程序 （keystone） 的唯一实体标识符。此值是生成标识提供者元数据所必需的，并且必须是 URI（建议使用 URL）。例如：https://keystone.example.com/v3/OS-FEDERATION/saml2/idp。

- idp_sso_endpoint[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_sso_endpoint)

  Type 类型 URI Default 违约 `<None>`  This is the single sign-on (SSO) service location of the identity provider  which accepts HTTP POST requests. A value is required to generate  identity provider metadata. For example: https://keystone.example.com/v3/OS-FEDERATION/saml2/sso. 这是接受 HTTP POST 请求的身份提供程序的单点登录 （SSO） 服务位置。生成标识提供者元数据需要一个值。例如：https://keystone.example.com/v3/OS-FEDERATION/saml2/sso。

- idp_lang[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_lang)

  Type 类型 string 字符串 Default 违约 `en`  This is the language used by the identity provider’s organization. 这是标识提供者的组织使用的语言。

- idp_organization_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_organization_name)

  Type 类型 string 字符串 Default 违约 `SAML Identity Provider`  This is the name of the identity provider’s organization. 这是标识提供者组织的名称。

- idp_organization_display_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_organization_display_name)

  Type 类型 string 字符串 Default 违约 `OpenStack SAML Identity Provider`  This is the name of the identity provider’s organization to be displayed. 这是要显示的身份提供程序组织的名称。

- idp_organization_url[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_organization_url)

  Type 类型 URI Default 违约 `https://example.com/`  This is the URL of the identity provider’s organization. The URL referenced here should be useful to humans. 这是标识提供者组织的 URL。此处引用的 URL 应该对人类有用。

- idp_contact_company[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_contact_company)

  Type 类型 string 字符串 Default 违约 `Example, Inc.`  This is the company name of the identity provider’s contact person. 这是标识提供者联系人的公司名称。

- idp_contact_name[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_contact_name)

  Type 类型 string 字符串 Default 违约 `SAML Identity Provider Support`  This is the given name of the identity provider’s contact person. 这是标识提供者联系人的给定名称。

- idp_contact_surname[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_contact_surname)

  Type 类型 string 字符串 Default 违约 `Support`  This is the surname of the identity provider’s contact person. 这是标识提供者联系人的姓氏。

- idp_contact_email[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_contact_email)

  Type 类型 string 字符串 Default 违约 `support@example.com`  This is the email address of the identity provider’s contact person. 这是标识提供者联系人的电子邮件地址。

- idp_contact_telephone[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_contact_telephone)

  Type 类型 string 字符串 Default 违约 `+1 800 555 0100`  This is the telephone number of the identity provider’s contact person. 这是标识提供者联系人的电话号码。

- idp_contact_type[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_contact_type)

  Type 类型 string 字符串 Default 违约 `other` Valid Values 有效值 technical, support, administrative, billing, other 技术、支持、管理、计费、其他  This is the type of contact that best describes the identity provider’s contact person. 这是最能描述标识提供者的联系人的联系人类型。

- idp_metadata_path[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.idp_metadata_path)

  Type 类型 string 字符串 Default 违约 `/etc/keystone/saml2_idp_metadata.xml`  Absolute path to the identity provider metadata file. This file should be generated with the keystone-manage saml_idp_metadata command. There is typically no reason to change this value. 标识提供者元数据文件的绝对路径。此文件应使用 keystone-manage saml_idp_metadata 命令生成。通常没有理由更改此值。

- relay_state_prefix[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#saml.relay_state_prefix)

  Type 类型 string 字符串 Default 违约 `ss:mem:`  The prefix of the RelayState SAML attribute to use when generating enhanced client and proxy (ECP) assertions. In a typical deployment, there is no reason to change this value. 生成增强型客户端和代理 （ECP） 断言时要使用的 RelayState SAML 属性的前缀。在典型部署中，没有理由更改此值。



### security_compliance[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security-compliance)

- disable_user_account_days_inactive[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.disable_user_account_days_inactive)

  Type 类型 integer 整数 Default 违约 `<None>` Minimum Value 最小值 1  The maximum number of days a user can go without authenticating before  being considered “inactive” and automatically disabled (locked). This  feature is disabled by default; set any value to enable it. This feature depends on the sql backend for the [identity] driver. When a user exceeds this threshold and is considered “inactive”, the user’s enabled attribute in the HTTP API may not match the value of the user’s enabled column in the user table. 用户在被视为“非活动”并自动禁用（锁定）之前可以不进行身份验证的最大天数。默认情况下，此功能处于禁用状态;设置任何值以启用它。此功能取决于 [identity] 驱动程序的 sql 后端。当用户超过此阈值并被视为“非活动”时，用户在 HTTP API 中的 enabled  属性可能与用户表中用户的 enabled 列的值不匹配。

- lockout_failure_attempts[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.lockout_failure_attempts)

  Type 类型 integer 整数 Default 违约 `<None>` Minimum Value 最小值 1  The maximum number of times that a user can fail to authenticate before the user account is locked for the number of seconds specified by [security_compliance] lockout_duration. This feature is disabled by default. If this feature is enabled and [security_compliance] lockout_duration is not set, then users may be locked out indefinitely until the user is explicitly enabled via the API. This feature depends on the sql backend for the [identity] driver. 在用户帐户被锁定之前，用户在 [security_compliance]  lockout_duration指定的秒数内无法进行身份验证的最大次数。默认情况下，此功能处于禁用状态。如果启用此功能且未设置  [security_compliance] lockout_duration，则用户可能会被无限期锁定，直到通过 API  显式启用用户。此功能取决于 [identity] 驱动程序的 sql 后端。

- lockout_duration[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.lockout_duration)

  Type 类型 integer 整数 Default 违约 `1800` Minimum Value 最小值 1  The number of seconds a user account will be locked when the maximum number of failed authentication attempts (as specified by [security_compliance] lockout_failure_attempts) is exceeded. Setting this option will have no effect unless you also set [security_compliance] lockout_failure_attempts to a non-zero value. This feature depends on the sql backend for the [identity] driver. 超过最大失败身份验证尝试次数（由 [security_compliance] lockout_failure_attempts指定）时，用户帐户将被锁定的秒数。除非您还将  [security_compliance] lockout_failure_attempts  设置为非零值，否则设置此选项将不起作用。此功能取决于 [identity] 驱动程序的 sql 后端。

- password_expires_days[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.password_expires_days)

  Type 类型 integer 整数 Default 违约 `<None>` Minimum Value 最小值 1  The number of days for which a password will be considered valid before  requiring it to be changed. This feature is disabled by default. If  enabled, new password changes will have an expiration date, however  existing passwords would not be impacted. This feature depends on the sql backend for the [identity] driver. 在要求更改密码之前，密码将被视为有效的天数。默认情况下，此功能处于禁用状态。如果启用，新密码更改将具有到期日期，但现有密码不会受到影响。此功能取决于 [identity] 驱动程序的 sql 后端。

- unique_last_password_count[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.unique_last_password_count)

  Type 类型 integer 整数 Default 违约 `0` Minimum Value 最小值 0  This controls the number of previous user password iterations to keep in  history, in order to enforce that newly created passwords are unique.  The total number which includes the new password should not be greater  or equal to this value. Setting the value to zero (the default) disables this feature. Thus, to enable this feature, values must be greater than 0. This feature depends on the sql backend for the [identity] driver. 这将控制要保留在历史记录中的先前用户密码迭代的次数，以便强制新创建的密码是唯一的。包含新密码的总数不应大于或等于此值。将该值设置为零（默认值）将禁用此功能。因此，若要启用此功能，值必须大于 0。此功能取决于 [identity] 驱动程序的 sql 后端。

- minimum_password_age[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.minimum_password_age)

  Type 类型 integer 整数 Default 违约 `0` Minimum Value 最小值 0  The number of days that a password must be used before the user can change  it. This prevents users from changing their passwords immediately in  order to wipe out their password history and reuse an old password. This feature does not prevent administrators from manually resetting  passwords. It is disabled by default and allows for immediate password  changes. This feature depends on the sql backend for the [identity] driver. Note: If [security_compliance] password_expires_days is set, then the value for this option should be less than the password_expires_days. 用户必须使用密码才能更改密码的天数。这可以防止用户立即更改其密码以清除其密码历史记录并重复使用旧密码。此功能不会阻止管理员手动重置密码。默认情况下，它处于禁用状态，并允许立即更改密码。此功能取决于 [identity] 驱动程序的 sql 后端。注意：如果设置了 [security_compliance]  password_expires_days，则此选项的值应小于password_expires_days。

- password_regex[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.password_regex)

  Type 类型 string 字符串 Default 违约 `<None>`  The regular expression used to validate password strength requirements. By  default, the regular expression will match any password. The following  is an example of a pattern which requires at least 1 letter, 1 digit,  and have a minimum length of 7 characters: ^(?=.*\d)(?=.*[a-zA-Z]).{7,}$ This feature depends on the sql backend for the [identity] driver. 用于验证密码强度要求的正则表达式。默认情况下，正则表达式将与任何密码匹配。以下是至少需要 1 个字母、1 位数字且最小长度为 7 个字符的模式示例：^（？=.*\d）（？=.*[a-zA-Z]）。{7，}$ 此功能取决于  [identity] 驱动程序的 sql 后端。

- password_regex_description[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.password_regex_description)

  Type 类型 string 字符串 Default 违约 `<None>`  Describe your password regular expression here in language for humans. If a  password fails to match the regular expression, the contents of this  configuration variable will be returned to users to explain why their  requested password was insufficient. 在此处用人类语言描述您的密码正则表达式。如果密码与正则表达式不匹配，则此配置变量的内容将返回给用户，以解释为什么他们请求的密码不足。

- change_password_upon_first_use[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#security_compliance.change_password_upon_first_use)

  Type 类型 boolean 布尔 Default 违约 `False`  Enabling this option requires users to change their password when the user is  created, or upon administrative reset. Before accessing any services,  affected users will have to change their password. To ignore this  requirement for specific users, such as service users, set the options attribute ignore_change_password_upon_first_use to True for the desired user via the update user API. This feature is disabled by default. This feature is only applicable with the sql backend for the [identity] driver. 启用此选项要求用户在创建用户时或在管理重置时更改其密码。在访问任何服务之前，受影响的用户必须更改其密码。要忽略特定用户（如服务用户）的此要求，请通过更新用户 API 将所需用户的 options 属性ignore_change_password_upon_first_use设置为  True。默认情况下，此功能处于禁用状态。此功能仅适用于 [identity] 驱动程序的 sql 后端。



### shadow_users[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#shadow-users)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#shadow_users.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the shadow users backend driver in the keystone.identity.shadow_users namespace. This driver is used for persisting local user references to  externally-managed identities (via federation, LDAP, etc). Keystone only provides a sql driver, so there is no reason to change this option unless you are providing a custom entry point. keystone.identity.shadow_users命名空间中影子用户后端驱动程序的入口点。此驱动程序用于将本地用户对外部托管标识的引用保存（通过联合身份验证、LDAP 等）。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此选项。



### token[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token) 令牌 ¶

- expiration[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.expiration) 过期 ¶

  Type 类型 integer 整数 Default 违约 `3600` Minimum Value 最小值 0 Maximum Value 最大值 9223372036854775807  The amount of time that a token should remain valid (in seconds).  Drastically reducing this value may break “long-running” operations that involve multiple services to coordinate together, and will force users  to authenticate with keystone more frequently. Drastically increasing  this value will increase the number of tokens that will be  simultaneously valid. Keystone tokens are also bearer tokens, so a  shorter duration will also reduce the potential security impact of a  compromised token. 令牌应保持有效的时间（以秒为单位）。大幅降低此值可能会中断涉及多个服务以协调在一起的“长时间运行”操作，并将迫使用户更频繁地使用 keystone 进行身份验证。大幅增加此值将增加同时有效的令牌数量。Keystone  代币也是不记名代币，因此较短的持续时间也将减少受损代币的潜在安全影响。

- provider[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.provider) 提供程序 ¶

  Type 类型 string 字符串 Default 违约 `fernet`  Entry point for the token provider in the keystone.token.provider namespace. The token provider controls the token construction,  validation, and revocation operations. Supported upstream providers are fernet and jws. Neither fernet or jws tokens require persistence and both require additional setup. If using fernet, you’re required to run keystone-manage fernet_setup, which creates symmetric keys used to encrypt tokens. If using jws, you’re required to generate an ECDSA keypair using a SHA-256 hash  algorithm for signing and validating token, which can be done with keystone-manage create_jws_keypair. Note that fernet tokens are encrypted and jws tokens are only signed. Please be sure to consider this if your  deployment has security requirements regarding payload contents used to  generate token IDs. keystone.token.provider 命名空间中令牌提供程序的入口点。令牌提供程序控制令牌构造、验证和吊销操作。支持的上游提供程序是 fernet 和 jws。fernet 和  jws 代币都不需要持久性，都需要额外的设置。如果使用 fernet，则需要运行 keystone-manage  fernet_setup，这将创建用于加密令牌的对称密钥。如果使用 jws，则需要使用 SHA-256 哈希算法生成 ECDSA  密钥对，用于签名和验证令牌，这可以通过 keystone-manage create_jws_keypair 来完成。请注意，fernet  令牌是加密的，jws 令牌仅签名。如果您的部署对用于生成令牌 ID 的有效负载内容有安全要求，请务必考虑这一点。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for caching token creation and validation data. This has no effect unless global caching is enabled. 切换以缓存令牌创建和验证数据。除非启用全局缓存，否则这不起作用。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>` Minimum Value 最小值 0 Maximum Value 最大值 9223372036854775807  The number of seconds to cache token creation and validation data. This has no effect unless both global and [token] caching are enabled. 缓存令牌创建和验证数据的秒数。除非同时启用全局缓存和 [令牌] 缓存，否则这不起作用。

- revoke_by_id[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.revoke_by_id)

  Type 类型 boolean 布尔 Default 违约 `True`  This toggles support for revoking individual tokens by the token identifier  and thus various token enumeration operations (such as listing all  tokens issued to a specific user). These operations are used to  determine the list of tokens to consider revoked. Do not disable this  option if you’re using the kvs [revoke] driver. 这将切换对按令牌标识符吊销单个令牌的支持，从而切换各种令牌枚举操作（例如列出颁发给特定用户的所有令牌）。这些操作用于确定要考虑吊销的令牌列表。如果您使用的是 kvs [revoke] 驱动程序，请不要禁用此选项。

- allow_rescope_scoped_token[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.allow_rescope_scoped_token)

  Type 类型 boolean 布尔 Default 违约 `True`  This toggles whether scoped tokens may be re-scoped to a new project or  domain, thereby preventing users from exchanging a scoped token  (including those with a default project scope) for any other token. This forces users to either authenticate for unscoped tokens (and later  exchange that unscoped token for tokens with a more specific scope) or  to provide their credentials in every request for a scoped token to  avoid re-scoping altogether. 这将切换是否可以将作用域内的令牌重新限定为新项目或域，从而防止用户将作用域内的令牌（包括具有默认项目范围的令牌）交换为任何其他令牌。这会强制用户对无作用域令牌进行身份验证（稍后将无作用域令牌交换为具有更具体作用域的令牌），或者在每个请求作用域内令牌时提供其凭据，以避免完全重新作用域。

- cache_on_issue[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.cache_on_issue)

  Type 类型 boolean 布尔 Default 违约 `True`  Enable storing issued token data to token validation cache so that first token validation doesn’t actually cause full validation cycle. This option  has no effect unless global caching is enabled and will still cache  tokens even if [token] caching = False. 允许将颁发的令牌数据存储到令牌验证缓存，以便第一次令牌验证实际上不会导致完整的验证周期。除非启用了全局缓存，否则此选项不起作用，并且即使 [token] caching = False 仍将缓存令牌。  Warning 警告 This option is deprecated for removal since S. Its value may be silently ignored  in the future. 此选项已弃用，因为 S.它的价值将来可能会被默默地忽略。 Reason 原因 Keystone already exposes a configuration option for caching tokens. Having a  separate configuration option to cache tokens when they are issued is  redundant, unnecessarily complicated, and is misleading if token caching is disabled because tokens will still be pre-cached by default when  they are issued. The ability to pre-cache tokens when they are issued is going to rely exclusively on the `keystone.conf [token] caching` option in the future. Keystone 已经公开了用于缓存令牌的配置选项。在颁发令牌时，使用单独的配置选项来缓存令牌是多余的、不必要的复杂，并且如果禁用令牌缓存会具有误导性，因为默认情况下，令牌在颁发时仍将预先缓存。在发行令牌时预缓存令牌的能力将完全依赖于未来的 `keystone.conf [token] caching` 选项。

- allow_expired_window[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#token.allow_expired_window)

  Type 类型 integer 整数 Default 违约 `172800`  This controls the number of seconds that a token can be retrieved for beyond the built-in expiry time. This allows long running operations to  succeed. Defaults to two days. 这控制在内置到期时间之后可以检索令牌的秒数。这允许长时间运行的操作成功。默认为两天。



### tokenless_auth[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#tokenless-auth)

- trusted_issuer[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#tokenless_auth.trusted_issuer)

  Type 类型 multi-valued 多值 Default 违约 `''`  The list of distinguished names which identify trusted issuers of client  certificates allowed to use X.509 tokenless authorization. If the option is absent then no certificates will be allowed. The format for the  values of a distinguished name (DN) must be separated by a comma and  contain no spaces. Furthermore, because an individual DN may contain  commas, this configuration option may be repeated multiple times to  represent multiple values. For example, keystone.conf would include two  consecutive lines in order to trust two different DNs, such as trusted_issuer = CN=john,OU=keystone,O=openstack and trusted_issuer = CN=mary,OU=eng,O=abc. 可分辨名称列表，用于标识允许使用 X.509 无令牌授权的客户端证书的受信任颁发者。如果该选项不存在，则不允许使用任何证书。可分辨名称 （DN）  值的格式必须用逗号分隔，并且不能包含空格。此外，由于单个 DN  可能包含逗号，因此此配置选项可以重复多次以表示多个值。例如，keystone.conf 将包含两个连续的行，以便信任两个不同的 DN，例如  trusted_issuer = CN=john，OU=keystone，O=openstack 和 trusted_issuer =  CN=mary，OU=eng，O=abc。

- protocol[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#tokenless_auth.protocol) 协议 ¶

  Type 类型 string 字符串 Default 违约 `x509`  The federated protocol ID used to represent X.509 tokenless authorization. This is used in combination with the value of [tokenless_auth] issuer_attribute to find a corresponding federated mapping. In a typical deployment, there is no reason to change this value. 用于表示 X.509 无令牌授权的联合协议 ID。这与 [tokenless_auth] issuer_attribute 的值结合使用，以查找相应的联合映射。在典型部署中，没有理由更改此值。

- issuer_attribute[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#tokenless_auth.issuer_attribute)

  Type 类型 string 字符串 Default 违约 `SSL_CLIENT_I_DN`  The name of the WSGI environment variable used to pass the issuer of the  client certificate to keystone. This attribute is used as an identity  provider ID for the X.509 tokenless authorization along with the  protocol to look up its corresponding mapping. In a typical deployment,  there is no reason to change this value. WSGI 环境变量的名称，用于将客户端证书的颁发者传递给 keystone。此属性用作 X.509 无令牌授权的身份提供程序 ID，以及用于查找其相应映射的协议。在典型部署中，没有理由更改此值。



### totp[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#totp) 托特普 ¶

- included_previous_windows[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#totp.included_previous_windows)

  Type 类型 integer 整数 Default 违约 `1` Minimum Value 最小值 0 Maximum Value 最大值 10  The number of previous windows to check when processing TOTP passcodes. 处理 TOTP 密码时要检查的先前窗口数。



### trust[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#trust) 信任 ¶

- allow_redelegation[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#trust.allow_redelegation)

  Type 类型 boolean 布尔 Default 违约 `False`  Allows authorization to be redelegated from one user to another, effectively chaining trusts together. When disabled, the remaining_uses attribute of a trust is constrained to be zero. 允许将授权从一个用户重新委派给另一个用户，从而有效地将信任链接在一起。禁用后，信任的 remaining_uses 属性被限制为零。

- max_redelegation_count[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#trust.max_redelegation_count)

  Type 类型 integer 整数 Default 违约 `3`  Maximum number of times that authorization can be redelegated from one user to  another in a chain of trusts. This number may be reduced further for a  specific trust. 在信任链中，授权可以从一个用户重新委派给另一个用户的最大次数。对于特定信托，此数字可能会进一步减少。

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#trust.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the trust backend driver in the keystone.trust namespace. Keystone only provides a sql driver, so there is no reason to change this unless you are providing a custom entry point. keystone.trust 命名空间中信任后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此设置。



### unified_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#unified-limit)

- driver[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#unified_limit.driver) 驱动程序 ¶

  Type 类型 string 字符串 Default 违约 `sql`  Entry point for the unified limit backend driver in the keystone.unified_limit namespace. Keystone only provides a sql driver, so there’s no reason to change this unless you are providing a custom entry point. keystone.unified_limit命名空间中统一限制后端驱动程序的入口点。Keystone 仅提供 sql 驱动程序，因此除非您提供自定义入口点，否则没有理由更改此设置。

- caching[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#unified_limit.caching) 缓存 ¶

  Type 类型 boolean 布尔 Default 违约 `True`  Toggle for unified limit caching. This has no effect unless global caching is  enabled. In a typical deployment, there is no reason to disable this. 切换统一限制缓存。除非启用全局缓存，否则这不起作用。在典型部署中，没有理由禁用此功能。

- cache_time[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#unified_limit.cache_time)

  Type 类型 integer 整数 Default 违约 `<None>`  Time to cache unified limit data, in seconds. This has no effect unless both global caching and [unified_limit] caching are enabled. 缓存统一限制数据的时间（以秒为单位）。除非同时启用全局缓存和 [unified_limit] 缓存，否则这不起作用。

- list_limit[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#unified_limit.list_limit)

  Type 类型 integer 整数 Default 违约 `<None>`  Maximum number of entities that will be returned in a unified limit collection. This may be useful to tune if you have a large number of unified limits in your deployment. 将在统一限制集合中返回的最大实体数。如果部署中有大量统一限制，这对于优化可能很有用。

- enforcement_model[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#unified_limit.enforcement_model)

  Type 类型 string 字符串 Default 违约 `flat` Valid Values 有效值 flat, strict_two_level 平坦，strict_two_level  The enforcement model to use when validating limits associated to projects. Enforcement models will behave differently depending on the existing  limits, which may result in backwards incompatible changes if a model is switched in a running deployment. 验证与项目关联的限制时要使用的强制模型。强制模型的行为将根据现有限制而有所不同，如果在正在运行的部署中切换模型，则可能会导致向后不兼容的更改。



### wsgi[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#wsgi)

- debug_middleware[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#wsgi.debug_middleware)

  Type 类型 boolean 布尔 Default 违约 `False`  If set to true, this enables the oslo debug middleware in Keystone. This  Middleware prints a lot of information about the request and the  response. It is useful for getting information about the data on the  wire (decoded) and passed to the WSGI application pipeline. This  middleware has no effect on the “debug” setting in the [DEFAULT] section of the config file or setting Keystone’s log-level to “DEBUG”; it is  specific to debugging the WSGI data as it enters and leaves Keystone  (specific request-related data). This option is used for introspection  on the request and response data between the web server (apache, nginx,  etc) and Keystone.  This middleware is inserted as the first element in  the middleware chain and will show the data closest to the wire.   WARNING: NOT INTENDED FOR USE IN PRODUCTION. THIS MIDDLEWARE CAN AND  WILL EMIT SENSITIVE/PRIVILEGED DATA. 如果设置为 true，这将在 Keystone 中启用 oslo  调试中间件。此中间件打印有关请求和响应的大量信息。它可用于获取有关线路上的数据（解码）并传递到 WSGI  应用程序管道的信息。此中间件对配置文件的 [DEFAULT] 部分中的“debug”设置或将 Keystone  的日志级别设置为“DEBUG”没有影响;它特定于在WSGI数据进入和离开Keystone（特定请求相关数据）时对其进行调试。此选项用于对 Web 服务器（apache、nginx 等）和 Keystone  之间的请求和响应数据进行自检。该中间件作为中间件链中的第一个元素插入，并将显示最接近线路的数据。警告：不适用于生产环境。此中间件可以并且将会发出敏感/特权数据。

## Domain-specific Identity drivers[¶](https://docs.openstack.org/keystone/yoga/configuration/config-options.html#domain-specific-identity-drivers) 特定于域的身份驱动程序 ¶

The Identity service supports domain-specific Identity drivers installed on an SQL or LDAP back end, and supports domain-specific Identity configuration options, which are stored in domain-specific configuration files. See [Domain-specific configuration](https://docs.openstack.org/keystone/yoga/admin/configuration.html#domain-specific-configuration) for more information.
Identity Service 支持安装在 SQL 或 LDAP 后端的特定于域的标识驱动程序，并支持特定于域的标识配置选项，这些选项存储在特定于域的配置文件中。有关详细信息，请参阅特定于域的配置。

# Policy configuration 策略配置

​                                          



 

Warning 警告



JSON formatted policy file is deprecated since Keystone 19.0.0 (Wallaby). This [oslopolicy-convert-json-to-yaml](https://docs.openstack.org/oslo.policy/latest/cli/oslopolicy-convert-json-to-yaml.html) tool will migrate your existing JSON-formatted policy file to YAML in a backward-compatible way.
JSON 格式的策略文件自 Keystone 19.0.0 （Wallaby） 起已弃用。此 oslopolicy-convert-json-to-yaml 工具将以向后兼容的方式将现有的 JSON 格式策略文件迁移到 YAML。

## Configuration[¶](https://docs.openstack.org/keystone/yoga/configuration/policy.html#configuration) 配置 ¶

The following is an overview of all available policies in Keystone.
以下是 Keystone 中所有可用策略的概述。

For a sample configuration file, refer to [policy.yaml](https://docs.openstack.org/keystone/yoga/configuration/samples/policy-yaml.html).
有关示例配置文件，请参阅 policy.yaml。

### keystone[¶](https://docs.openstack.org/keystone/yoga/configuration/policy.html#keystone) 基石 ¶

- `admin_required`

  Default 违约 `role:admin or is_admin:1`  (no description provided) （未提供描述）

- `service_role`

  Default 违约 `role:service`  (no description provided) （未提供描述）

- `service_or_admin`

  Default 违约 `rule:admin_required or rule:service_role`  (no description provided) （未提供描述）

- `owner`

  Default 违约 `user_id:%(user_id)s`  (no description provided) （未提供描述）

- `admin_or_owner`

  Default 违约 `rule:admin_required or rule:owner`  (no description provided) （未提供描述）

- `token_subject`

  Default 违约 `user_id:%(target.token.user_id)s`  (no description provided) （未提供描述）

- `admin_or_token_subject`

  Default 违约 `rule:admin_required or rule:token_subject`  (no description provided) （未提供描述）

- `service_admin_or_token_subject`

  Default 违约 `rule:service_or_admin or rule:token_subject`  (no description provided) （未提供描述）

- `identity:get_access_rule`

  Default 违约 `(role:reader and system_scope:all) or user_id:%(target.user.id)s` Operations 操作 **GET** `/v3/users/{user_id}/access_rules/{access_rule_id}` 获取 `/v3/users/{user_id}/access_rules/{access_rule_id}`  **HEAD** `/v3/users/{user_id}/access_rules/{access_rule_id}` 头 `/v3/users/{user_id}/access_rules/{access_rule_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Show access rule details. 显示访问规则详细信息。

- `identity:list_access_rules`

  Default 违约 `(role:reader and system_scope:all) or user_id:%(target.user.id)s` Operations 操作 **GET** `/v3/users/{user_id}/access_rules` 获取 `/v3/users/{user_id}/access_rules`  **HEAD** `/v3/users/{user_id}/access_rules` 头 `/v3/users/{user_id}/access_rules`   Scope Types 作用域类型 **system 系统** **project 项目**  List access rules for a user. 列出用户的访问规则。

- `identity:delete_access_rule`

  Default 违约 `(role:admin and system_scope:all) or user_id:%(target.user.id)s` Operations 操作 **DELETE** `/v3/users/{user_id}/access_rules/{access_rule_id}` 删除 `/v3/users/{user_id}/access_rules/{access_rule_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Delete an access_rule. 删除access_rule。

- `identity:authorize_request_token`

  Default 违约 `rule:admin_required` Operations 操作 **PUT** `/v3/OS-OAUTH1/authorize/{request_token_id}` 放 `/v3/OS-OAUTH1/authorize/{request_token_id}`   Scope Types 作用域类型 **project 项目**  Authorize OAUTH1 request token. 授权 OAUTH1 请求令牌。

- `identity:get_access_token`

  Default 违约 `rule:admin_required` Operations 操作 **GET** `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}` 获取 `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}`   Scope Types 作用域类型 **project 项目**  Get OAUTH1 access token for user by access token ID. 通过访问令牌 ID 获取用户的 OAUTH1 访问令牌。

- `identity:get_access_token_role`

  Default 违约 `rule:admin_required` Operations 操作 **GET** `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles/{role_id}` 获取 `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles/{role_id}`   Scope Types 作用域类型 **project 项目**  Get role for user OAUTH1 access token. 获取用户 OAUTH1 访问令牌的角色。

- `identity:list_access_tokens`

  Default 违约 `rule:admin_required` Operations 操作 **GET** `/v3/users/{user_id}/OS-OAUTH1/access_tokens` 获取 `/v3/users/{user_id}/OS-OAUTH1/access_tokens`   Scope Types 作用域类型 **project 项目**  List OAUTH1 access tokens for user. 列出用户的 OAUTH1 访问令牌。

- `identity:list_access_token_roles`

  Default 违约 `rule:admin_required` Operations 操作 **GET** `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles` 获取 `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles`   Scope Types 作用域类型 **project 项目**  List OAUTH1 access token roles. 列出 OAUTH1 访问令牌角色。

- `identity:delete_access_token`

  Default 违约 `rule:admin_required` Operations 操作 **DELETE** `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}` 删除 `/v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}`   Scope Types 作用域类型 **project 项目**  Delete OAUTH1 access token. 删除 OAUTH1 访问令牌。

- `identity:get_application_credential`

  Default 违约 `(role:reader and system_scope:all) or rule:owner` Operations 操作 **GET** `/v3/users/{user_id}/application_credentials/{application_credential_id}` 获取 `/v3/users/{user_id}/application_credentials/{application_credential_id}`  **HEAD** `/v3/users/{user_id}/application_credentials/{application_credential_id}` 头 `/v3/users/{user_id}/application_credentials/{application_credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Show application credential details. 显示应用程序凭据详细信息。

- `identity:list_application_credentials`

  Default 违约 `(role:reader and system_scope:all) or rule:owner` Operations 操作 **GET** `/v3/users/{user_id}/application_credentials` 获取 `/v3/users/{user_id}/application_credentials`  **HEAD** `/v3/users/{user_id}/application_credentials` 头 `/v3/users/{user_id}/application_credentials`   Scope Types 作用域类型 **system 系统** **project 项目**  List application credentials for a user. 列出用户的应用程序凭据。

- `identity:create_application_credential`

  Default 违约 `user_id:%(user_id)s` Operations 操作 **POST** `/v3/users/{user_id}/application_credentials` 发布 `/v3/users/{user_id}/application_credentials`   Scope Types 作用域类型 **project 项目**  Create an application credential. 创建应用程序凭据。

- `identity:delete_application_credential`

  Default 违约 `(role:admin and system_scope:all) or rule:owner` Operations 操作 **DELETE** `/v3/users/{user_id}/application_credentials/{application_credential_id}` 删除 `/v3/users/{user_id}/application_credentials/{application_credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Delete an application credential. 删除应用程序凭据。

- `identity:get_auth_catalog`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/auth/catalog` 获取 `/v3/auth/catalog`  **HEAD** `/v3/auth/catalog` 头 `/v3/auth/catalog`   Get service catalog. 获取服务目录。

- `identity:get_auth_projects`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/auth/projects` 获取 `/v3/auth/projects`  **HEAD** `/v3/auth/projects` 头 `/v3/auth/projects`   List all projects a user has access to via role assignments. 列出用户通过角色分配有权访问的所有项目。

- `identity:get_auth_domains`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/auth/domains` 获取 `/v3/auth/domains`  **HEAD** `/v3/auth/domains` 头 `/v3/auth/domains`   List all domains a user has access to via role assignments. 列出用户通过角色分配有权访问的所有域。

- `identity:get_auth_system`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/auth/system` 获取 `/v3/auth/system`  **HEAD** `/v3/auth/system` 头 `/v3/auth/system`   List systems a user has access to via role assignments. 列出用户通过角色分配有权访问的系统。

- `identity:get_consumer`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-OAUTH1/consumers/{consumer_id}` 获取 `/v3/OS-OAUTH1/consumers/{consumer_id}`   Scope Types 作用域类型 **system 系统**  Show OAUTH1 consumer details. 显示 OAUTH1 使用者详细信息。

- `identity:list_consumers`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-OAUTH1/consumers` 获取 `/v3/OS-OAUTH1/consumers`   Scope Types 作用域类型 **system 系统**  List OAUTH1 consumers. 列出 OAUTH1 使用者。

- `identity:create_consumer`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/OS-OAUTH1/consumers` 发布 `/v3/OS-OAUTH1/consumers`   Scope Types 作用域类型 **system 系统**  Create OAUTH1 consumer. 创建 OAUTH1 使用者。

- `identity:update_consumer`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/OS-OAUTH1/consumers/{consumer_id}` 补丁 `/v3/OS-OAUTH1/consumers/{consumer_id}`   Scope Types 作用域类型 **system 系统**  Update OAUTH1 consumer. 更新 OAUTH1 使用者。

- `identity:delete_consumer`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-OAUTH1/consumers/{consumer_id}` 删除 `/v3/OS-OAUTH1/consumers/{consumer_id}`   Scope Types 作用域类型 **system 系统**  Delete OAUTH1 consumer. 删除 OAUTH1 使用者。

- `identity:get_credential`

  Default 违约 `(role:reader and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **GET** `/v3/credentials/{credential_id}` 获取 `/v3/credentials/{credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Show credentials details. 显示凭据详细信息。

- `identity:list_credentials`

  Default 违约 `(role:reader and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **GET** `/v3/credentials` 获取 `/v3/credentials`   Scope Types 作用域类型 **system 系统** **project 项目**  List credentials. 列出凭据。

- `identity:create_credential`

  Default 违约 `(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **POST** `/v3/credentials` 发布 `/v3/credentials`   Scope Types 作用域类型 **system 系统** **project 项目**  Create credential. 创建凭据。

- `identity:update_credential`

  Default 违约 `(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **PATCH** `/v3/credentials/{credential_id}` 补丁 `/v3/credentials/{credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Update credential. 更新凭据。

- `identity:delete_credential`

  Default 违约 `(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **DELETE** `/v3/credentials/{credential_id}` 删除 `/v3/credentials/{credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Delete credential. 删除凭据。

- `identity:get_domain`

  Default 违约 `(role:reader and system_scope:all) or token.domain.id:%(target.domain.id)s or token.project.domain.id:%(target.domain.id)s` Operations 操作 **GET** `/v3/domains/{domain_id}` 获取 `/v3/domains/{domain_id}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Show domain details. 显示域详细信息。

- `identity:list_domains`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/domains` 获取 `/v3/domains`   Scope Types 作用域类型 **system 系统**  List domains. 列出域。

- `identity:create_domain`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/domains` 发布 `/v3/domains`   Scope Types 作用域类型 **system 系统**  Create domain. 创建域。

- `identity:update_domain`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/domains/{domain_id}` 补丁 `/v3/domains/{domain_id}`   Scope Types 作用域类型 **system 系统**  Update domain. 更新域。

- `identity:delete_domain`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/domains/{domain_id}` 删除 `/v3/domains/{domain_id}`   Scope Types 作用域类型 **system 系统**  Delete domain. 删除域。

- `identity:create_domain_config`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/domains/{domain_id}/config` 放 `/v3/domains/{domain_id}/config`   Scope Types 作用域类型 **system 系统**  Create domain configuration. 创建域配置。

- `identity:get_domain_config`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/domains/{domain_id}/config` 获取 `/v3/domains/{domain_id}/config`  **HEAD** `/v3/domains/{domain_id}/config` 头 `/v3/domains/{domain_id}/config`  **GET** `/v3/domains/{domain_id}/config/{group}` 获取 `/v3/domains/{domain_id}/config/{group}`  **HEAD** `/v3/domains/{domain_id}/config/{group}` 头 `/v3/domains/{domain_id}/config/{group}`  **GET** `/v3/domains/{domain_id}/config/{group}/{option}` 获取 `/v3/domains/{domain_id}/config/{group}/{option}`  **HEAD** `/v3/domains/{domain_id}/config/{group}/{option}` 头 `/v3/domains/{domain_id}/config/{group}/{option}`   Scope Types 作用域类型 **system 系统**  Get the entire domain configuration for a domain, an option group within a  domain, or a specific configuration option within a group for a domain. 获取域的整个域配置、域中的选项组或域组中的特定配置选项。

- `identity:get_security_compliance_domain_config`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/domains/{domain_id}/config/security_compliance` 获取 `/v3/domains/{domain_id}/config/security_compliance`  **HEAD** `/v3/domains/{domain_id}/config/security_compliance` 头 `/v3/domains/{domain_id}/config/security_compliance`  **GET** `/v3/domains/{domain_id}/config/security_compliance/{option}` 获取 `/v3/domains/{domain_id}/config/security_compliance/{option}`  **HEAD** `/v3/domains/{domain_id}/config/security_compliance/{option}` 头 `/v3/domains/{domain_id}/config/security_compliance/{option}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Get security compliance domain configuration for either a domain or a specific option in a domain. 获取域或域中特定选项的安全合规性域配置。

- `identity:update_domain_config`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/domains/{domain_id}/config` 补丁 `/v3/domains/{domain_id}/config`  **PATCH** `/v3/domains/{domain_id}/config/{group}` 补丁 `/v3/domains/{domain_id}/config/{group}`  **PATCH** `/v3/domains/{domain_id}/config/{group}/{option}` 补丁 `/v3/domains/{domain_id}/config/{group}/{option}`   Scope Types 作用域类型 **system 系统**  Update domain configuration for either a domain, specific group or a specific option in a group. 更新域、特定组或组中特定选项的域配置。

- `identity:delete_domain_config`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/domains/{domain_id}/config` 删除 `/v3/domains/{domain_id}/config`  **DELETE** `/v3/domains/{domain_id}/config/{group}` 删除 `/v3/domains/{domain_id}/config/{group}`  **DELETE** `/v3/domains/{domain_id}/config/{group}/{option}` 删除 `/v3/domains/{domain_id}/config/{group}/{option}`   Scope Types 作用域类型 **system 系统**  Delete domain configuration for either a domain, specific group or a specific option in a group. 删除域、特定组或组中特定选项的域配置。

- `identity:get_domain_config_default`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/domains/config/default` 获取 `/v3/domains/config/default`  **HEAD** `/v3/domains/config/default` 头 `/v3/domains/config/default`  **GET** `/v3/domains/config/{group}/default` 获取 `/v3/domains/config/{group}/default`  **HEAD** `/v3/domains/config/{group}/default` 头 `/v3/domains/config/{group}/default`  **GET** `/v3/domains/config/{group}/{option}/default` 获取 `/v3/domains/config/{group}/{option}/default`  **HEAD** `/v3/domains/config/{group}/{option}/default` 头 `/v3/domains/config/{group}/{option}/default`   Scope Types 作用域类型 **system 系统**  Get domain configuration default for either a domain, specific group or a specific option in a group. 获取域、特定组或组中特定选项的域配置默认值。

- `identity:ec2_get_credential`

  Default 违约 `(role:reader and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **GET** `/v3/users/{user_id}/credentials/OS-EC2/{credential_id}` 获取 `/v3/users/{user_id}/credentials/OS-EC2/{credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Show ec2 credential details. 显示 ec2 凭证详细信息。

- `identity:ec2_list_credentials`

  Default 违约 `(role:reader and system_scope:all) or rule:owner` Operations 操作 **GET** `/v3/users/{user_id}/credentials/OS-EC2` 获取 `/v3/users/{user_id}/credentials/OS-EC2`   Scope Types 作用域类型 **system 系统** **project 项目**  List ec2 credentials. 列出 ec2 凭证。

- `identity:ec2_create_credential`

  Default 违约 `(role:admin and system_scope:all) or rule:owner` Operations 操作 **POST** `/v3/users/{user_id}/credentials/OS-EC2` 发布 `/v3/users/{user_id}/credentials/OS-EC2`   Scope Types 作用域类型 **system 系统** **project 项目**  Create ec2 credential. 创建 ec2 凭证。

- `identity:ec2_delete_credential`

  Default 违约 `(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s` Operations 操作 **DELETE** `/v3/users/{user_id}/credentials/OS-EC2/{credential_id}` 删除 `/v3/users/{user_id}/credentials/OS-EC2/{credential_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Delete ec2 credential. 删除 ec2 凭证。

- `identity:get_endpoint`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/endpoints/{endpoint_id}` 获取 `/v3/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Show endpoint details. 显示终结点详细信息。

- `identity:list_endpoints`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/endpoints` 获取 `/v3/endpoints`   Scope Types 作用域类型 **system 系统**  List endpoints. 列出终结点。

- `identity:create_endpoint`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/endpoints` 发布 `/v3/endpoints`   Scope Types 作用域类型 **system 系统**  Create endpoint. 创建终结点。

- `identity:update_endpoint`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/endpoints/{endpoint_id}` 补丁 `/v3/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Update endpoint. 更新终结点。

- `identity:delete_endpoint`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/endpoints/{endpoint_id}` 删除 `/v3/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Delete endpoint. 删除终结点。

- `identity:create_endpoint_group`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/OS-EP-FILTER/endpoint_groups` 发布 `/v3/OS-EP-FILTER/endpoint_groups`   Scope Types 作用域类型 **system 系统**  Create endpoint group. 创建终端节点组。

- `identity:list_endpoint_groups`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/endpoint_groups` 获取 `/v3/OS-EP-FILTER/endpoint_groups`   Scope Types 作用域类型 **system 系统**  List endpoint groups. 列出终端节点组。

- `identity:get_endpoint_group`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}` 获取 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`  **HEAD** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}` 头 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`   Scope Types 作用域类型 **system 系统**  Get endpoint group. 获取终结点组。

- `identity:update_endpoint_group`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}` 补丁 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`   Scope Types 作用域类型 **system 系统**  Update endpoint group. 更新终端节点组。

- `identity:delete_endpoint_group`

  Default 违约 `role:admin and system_scope:all` Operations **DELETE** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}` 删除 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}`   Scope Types 作用域类型 **system 系统**  Delete endpoint group. 删除终端节点组。

- `identity:list_projects_associated_with_endpoint_group`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects` 获取 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects`   Scope Types 作用域类型 **system 系统**  List all projects associated with a specific endpoint group. 列出与特定终结点组关联的所有项目。

- `identity:list_endpoints_associated_with_endpoint_group`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints` 获取 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints`   Scope Types 作用域类型 **system 系统**  List all endpoints associated with an endpoint group. 列出与终端节点组关联的所有终端节点。

- `identity:get_endpoint_group_in_project`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}` 获取 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`  **HEAD** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}` 头 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`   Scope Types 作用域类型 **system 系统**  Check if an endpoint group is associated with a project. 检查终端节点组是否与项目关联。

- `identity:list_endpoint_groups_for_project`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/projects/{project_id}/endpoint_groups` 获取 `/v3/OS-EP-FILTER/projects/{project_id}/endpoint_groups`   Scope Types 作用域类型 **system 系统**  List endpoint groups associated with a specific project. 列出与特定项目关联的端点组。

- `identity:add_endpoint_group_to_project`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}` 放 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`   Scope Types 作用域类型 **system 系统**  Allow a project to access an endpoint group. 允许项目访问终端节点组。

- `identity:remove_endpoint_group_from_project`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}` 删除 `/v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}`   Scope Types 作用域类型 **system 系统**  Remove endpoint group from project. 从项目中删除终结点组。

- `identity:check_grant`

  Default 违约 `(role:reader and system_scope:all) or ((role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)) and (domain_id:%(target.role.domain_id)s or None:%(target.role.domain_id)s)` Operations 操作 **HEAD** `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}` 头 `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}`  **GET** `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}` 获取 `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}`  **HEAD** `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}` 头 `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}`  **GET** `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}` 获取 `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}`  **HEAD** `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}` 头 `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}`  **GET** `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}` 获取 `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}`  **HEAD** `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}` 头 `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}`  **GET** `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}` 获取 `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}`  **HEAD** `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 头 `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **GET** `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 获取 `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **HEAD** `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 头 `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`  **GET** `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` **HEAD** `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 头 `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **GET** `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 获取 `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **HEAD** `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 头 `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`  **GET** `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 获取 `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`   Scope Types 作用域类型 **system 系统** **domain 域**  Check a role grant between a target and an actor. A target can be either a  domain or a project. An actor can be either a user or a group. These  terms also apply to the OS-INHERIT APIs, where grants on the target are  inherited to all projects in the subtree, if applicable. 检查目标和参与者之间的角色授予。目标可以是域，也可以是项目。参与者可以是用户，也可以是组。这些术语也适用于 OS-INHERIT API，其中目标的授权将继承到子树中的所有项目（如果适用）。

- `identity:list_grants`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)` Operations 操作 **GET** `/v3/projects/{project_id}/users/{user_id}/roles` 获取 `/v3/projects/{project_id}/users/{user_id}/roles`  **HEAD** `/v3/projects/{project_id}/users/{user_id}/roles` 头 `/v3/projects/{project_id}/users/{user_id}/roles`  **GET** `/v3/projects/{project_id}/groups/{group_id}/roles` 获取 `/v3/projects/{project_id}/groups/{group_id}/roles`  **HEAD** `/v3/projects/{project_id}/groups/{group_id}/roles` 头 `/v3/projects/{project_id}/groups/{group_id}/roles`  **GET** `/v3/domains/{domain_id}/users/{user_id}/roles` 获取 `/v3/domains/{domain_id}/users/{user_id}/roles`  **HEAD** `/v3/domains/{domain_id}/users/{user_id}/roles` 头 `/v3/domains/{domain_id}/users/{user_id}/roles`  **GET** `/v3/domains/{domain_id}/groups/{group_id}/roles` 获取 `/v3/domains/{domain_id}/groups/{group_id}/roles`  **HEAD** `/v3/domains/{domain_id}/groups/{group_id}/roles` 头 `/v3/domains/{domain_id}/groups/{group_id}/roles`  **GET** `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects` 获取 `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects`  **GET** `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects` 获取 `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects`   Scope Types 作用域类型 **system 系统** **domain 域**  List roles granted to an actor on a target. A target can be either a domain  or a project. An actor can be either a user or a group. For the  OS-INHERIT APIs, it is possible to list inherited role grants for actors on domains, where grants are inherited to all projects in the specified domain. 列出授予目标上参与者的角色。目标可以是域，也可以是项目。参与者可以是用户，也可以是组。对于 OS-INHERIT API，可以列出域上参与者的继承角色授权，其中授权将继承到指定域中的所有项目。

- `identity:create_grant`

  Default 违约 `(role:admin and system_scope:all) or ((role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)) and (domain_id:%(target.role.domain_id)s or None:%(target.role.domain_id)s)` Operations 操作 **PUT** `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}` 放 `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}`  **PUT** `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}` 放 `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}`  **PUT** `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}` 放 `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}`  **PUT** `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}` 放 `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}`  **PUT** `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 放 `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **PUT** `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 放 `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`  **PUT** `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 放 `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **PUT** `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 放 `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`   Scope Types 作用域类型 **system 系统** **domain 域**  Create a role grant between a target and an actor. A target can be either a  domain or a project. An actor can be either a user or a group. These  terms also apply to the OS-INHERIT APIs, where grants on the target are  inherited to all projects in the subtree, if applicable. 在目标和参与者之间创建角色授权。目标可以是域，也可以是项目。参与者可以是用户，也可以是组。这些术语也适用于 OS-INHERIT API，其中目标的授权将继承到子树中的所有项目（如果适用）。

- `identity:revoke_grant`

  Default 违约 `(role:admin and system_scope:all) or ((role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)) and (domain_id:%(target.role.domain_id)s or None:%(target.role.domain_id)s)` Operations 操作 **DELETE** `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}` 删除 `/v3/projects/{project_id}/users/{user_id}/roles/{role_id}`  **DELETE** `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}` 删除 `/v3/projects/{project_id}/groups/{group_id}/roles/{role_id}`  **DELETE** `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}` 删除 `/v3/domains/{domain_id}/users/{user_id}/roles/{role_id}`  **DELETE** `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}` 删除 `/v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}`  **DELETE** `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 删除 `/v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **DELETE** `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 删除 `/v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`  **DELETE** `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects` 删除 `/v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects`  **DELETE** `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects` 删除 `/v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects`   Scope Types 作用域类型 **system 系统** **domain 域**  Revoke a role grant between a target and an actor. A target can be either a  domain or a project. An actor can be either a user or a group. These  terms also apply to the OS-INHERIT APIs, where grants on the target are  inherited to all projects in the subtree, if applicable. In that case,  revoking the role grant in the target would remove the logical effect of inheriting it to the target’s projects subtree. 撤消目标和参与者之间的角色授予。目标可以是域，也可以是项目。参与者可以是用户，也可以是组。这些术语也适用于 OS-INHERIT  API，其中目标的授权将继承到子树中的所有项目（如果适用）。在这种情况下，撤消目标中的角色授予将消除将其继承到目标的项目子树的逻辑效果。

- `identity:list_system_grants_for_user`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **[‘HEAD’, ‘GET’]** `/v3/system/users/{user_id}/roles` ['头'， '得到'] `/v3/system/users/{user_id}/roles`   Scope Types 作用域类型 **system 系统**  List all grants a specific user has on the system.

- `identity:check_system_grant_for_user`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **[‘HEAD’, ‘GET’]** `/v3/system/users/{user_id}/roles/{role_id}` ['头'， '得到'] `/v3/system/users/{user_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Check if a user has a role on the system. 检查用户是否在系统上具有角色。

- `identity:create_system_grant_for_user`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **[‘PUT’]** `/v3/system/users/{user_id}/roles/{role_id}` ['放'] `/v3/system/users/{user_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Grant a user a role on the system. 授予用户系统上的角色。

- `identity:revoke_system_grant_for_user`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **[‘DELETE’]** `/v3/system/users/{user_id}/roles/{role_id}` ['删除'] `/v3/system/users/{user_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Remove a role from a user on the system. 从系统上的用户中删除角色。

- `identity:list_system_grants_for_group`

  Default `role:reader and system_scope:all` Operations 操作 **[‘HEAD’, ‘GET’]** `/v3/system/groups/{group_id}/roles` ['头'， '得到'] `/v3/system/groups/{group_id}/roles`   Scope Types 作用域类型 **system 系统**  List all grants a specific group has on the system. 列出特定组在系统上拥有的所有授权。

- `identity:check_system_grant_for_group`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **[‘HEAD’, ‘GET’]** `/v3/system/groups/{group_id}/roles/{role_id}` ['头'， '得到'] `/v3/system/groups/{group_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Check if a group has a role on the system. 检查组是否在系统上具有角色。

- `identity:create_system_grant_for_group`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **[‘PUT’]** `/v3/system/groups/{group_id}/roles/{role_id}` ['放'] `/v3/system/groups/{group_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Grant a group a role on the system. 向组授予系统上的角色。

- `identity:revoke_system_grant_for_group`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **[‘DELETE’]** `/v3/system/groups/{group_id}/roles/{role_id}` ['删除'] `/v3/system/groups/{group_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Remove a role from a group on the system. 从系统上的组中删除角色。

- `identity:get_group`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s)` Operations 操作 **GET** `/v3/groups/{group_id}` 获取 `/v3/groups/{group_id}`  **HEAD** `/v3/groups/{group_id}` 头 `/v3/groups/{group_id}`   Scope Types 作用域类型 **system** **domain 域**  Show group details. 显示组详细信息。

- `identity:list_groups`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s)` Operations 操作 **GET** `/v3/groups` 获取 `/v3/groups`  **HEAD** `/v3/groups` 头 `/v3/groups`   Scope Types 作用域类型 **system 系统** **domain 域**  List groups. 列出组。

- `identity:list_groups_for_user`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.user.domain_id)s) or user_id:%(user_id)s` Operations 操作 **GET** `/v3/users/{user_id}/groups` 获取 `/v3/users/{user_id}/groups`  **HEAD** `/v3/users/{user_id}/groups` 头 `/v3/users/{user_id}/groups`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List groups to which a user belongs. 列出用户所属的组。

- `identity:create_group`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s)` Operations 操作 **POST** `/v3/groups` 发布 `/v3/groups`   Scope Types 作用域类型 **system 系统** **domain 域**  Create group. 创建组。

- `identity:update_group`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s)` Operations 操作 **PATCH** `/v3/groups/{group_id}` 补丁 `/v3/groups/{group_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Update group. 更新组。

- `identity:delete_group`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s)` Operations 操作 **DELETE** `/v3/groups/{group_id}` 删除 `/v3/groups/{group_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Delete group. 删除组。

- `identity:list_users_in_group`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s)` Operations 操作 **GET** `/v3/groups/{group_id}/users` **HEAD** `/v3/groups/{group_id}/users` 头 `/v3/groups/{group_id}/users`   Scope Types 作用域类型 **system 系统** **domain 域**  List members of a specific group. 列出特定组的成员。

- `identity:remove_user_from_group`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.user.domain_id)s)` Operations 操作 **DELETE** `/v3/groups/{group_id}/users/{user_id}` 删除 `/v3/groups/{group_id}/users/{user_id}`   Scope Types **system 系统** **domain 域**  Remove user from group. 从组中删除用户。

- `identity:check_user_in_group`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.user.domain_id)s)` Operations 操作 **HEAD** `/v3/groups/{group_id}/users/{user_id}` 头 `/v3/groups/{group_id}/users/{user_id}`  **GET** `/v3/groups/{group_id}/users/{user_id}` 获取 `/v3/groups/{group_id}/users/{user_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Check whether a user is a member of a group. 检查用户是否为组成员。

- `identity:add_user_to_group`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.user.domain_id)s)` Operations 操作 **PUT** `/v3/groups/{group_id}/users/{user_id}` 放 `/v3/groups/{group_id}/users/{user_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Add user to group. 将用户添加到组。

- `identity:create_identity_provider`

  Default `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/OS-FEDERATION/identity_providers/{idp_id}` 放 `/v3/OS-FEDERATION/identity_providers/{idp_id}`   Scope Types 作用域类型 **system 系统**  Create identity provider. 创建标识提供者。

- `identity:list_identity_providers`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/identity_providers` 获取 `/v3/OS-FEDERATION/identity_providers`  **HEAD** `/v3/OS-FEDERATION/identity_providers` 头 `/v3/OS-FEDERATION/identity_providers`   Scope Types 作用域类型 **system 系统**  List identity providers. 列出标识提供者。

- `identity:get_identity_provider`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/identity_providers/{idp_id}` 获取 `/v3/OS-FEDERATION/identity_providers/{idp_id}`  **HEAD** `/v3/OS-FEDERATION/identity_providers/{idp_id}` 头 `/v3/OS-FEDERATION/identity_providers/{idp_id}`   Scope Types 作用域类型 **system 系统**  Get identity provider. 获取标识提供者。

- `identity:update_identity_provider`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/OS-FEDERATION/identity_providers/{idp_id}` 补丁 `/v3/OS-FEDERATION/identity_providers/{idp_id}`   Scope Types 作用域类型 **system 系统**  Update identity provider. 更新标识提供者。

- `identity:delete_identity_provider`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-FEDERATION/identity_providers/{idp_id}` 删除 `/v3/OS-FEDERATION/identity_providers/{idp_id}`   Scope Types 作用域类型 **system 系统**  Delete identity provider. 删除标识提供者。

- `identity:get_implied_role`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/roles/{prior_role_id}/implies/{implied_role_id}` 获取 `/v3/roles/{prior_role_id}/implies/{implied_role_id}`   Scope Types 作用域类型 **system 系统**  Get information about an association between two roles. When a relationship exists between a prior role and an implied role and the prior role is  assigned to a user, the user also assumes the implied role. 获取有关两个角色之间关联的信息。当先前角色与隐含角色之间存在关系，并且将先前角色分配给用户时，用户也会承担隐含角色。

- `identity:list_implied_roles`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/roles/{prior_role_id}/implies` 获取 `/v3/roles/{prior_role_id}/implies`  **HEAD** `/v3/roles/{prior_role_id}/implies` 头 `/v3/roles/{prior_role_id}/implies`   Scope Types 作用域类型 **system 系统**  List associations between two roles. When a relationship exists between a  prior role and an implied role and the prior role is assigned to a user, the user also assumes the implied role. This will return all the  implied roles that would be assumed by the user who gets the specified  prior role. 列出两个角色之间的关联。当先前角色与隐含角色之间存在关系，并且将先前角色分配给用户时，用户也会承担隐含角色。这将返回所有隐含角色，这些角色将由获取指定先前角色的用户承担。

- `identity:create_implied_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/roles/{prior_role_id}/implies/{implied_role_id}` 放 `/v3/roles/{prior_role_id}/implies/{implied_role_id}`   Scope Types 作用域类型 **system 系统**  Create an association between two roles. When a relationship exists between a  prior role and an implied role and the prior role is assigned to a user, the user also assumes the implied role. 在两个角色之间创建关联。当先前角色与隐含角色之间存在关系，并且将先前角色分配给用户时，用户也会承担隐含角色。

- `identity:delete_implied_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/roles/{prior_role_id}/implies/{implied_role_id}` 删除 `/v3/roles/{prior_role_id}/implies/{implied_role_id}`   Scope Types 作用域类型 **system 系统**  Delete the association between two roles. When a relationship exists between a prior role and an implied role and the prior role is assigned to a  user, the user also assumes the implied role. Removing the association  will cause that effect to be eliminated. 删除两个角色之间的关联。当先前角色与隐含角色之间存在关系，并且将先前角色分配给用户时，用户也会承担隐含角色。删除关联将导致消除该影响。

- `identity:list_role_inference_rules`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/role_inferences` 获取 `/v3/role_inferences`  **HEAD** `/v3/role_inferences` 头 `/v3/role_inferences`   Scope Types 作用域类型 **system 系统**  List all associations between two roles in the system. When a relationship  exists between a prior role and an implied role and the prior role is  assigned to a user, the user also assumes the implied role. 列出系统中两个角色之间的所有关联。当先前角色与隐含角色之间存在关系，并且将先前角色分配给用户时，用户也会承担隐含角色。

- `identity:check_implied_role`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **HEAD** `/v3/roles/{prior_role_id}/implies/{implied_role_id}` 头 `/v3/roles/{prior_role_id}/implies/{implied_role_id}`   Scope Types 作用域类型 **system 系统**  Check an association between two roles. When a relationship exists between a  prior role and an implied role and the prior role is assigned to a user, the user also assumes the implied role. 检查两个角色之间的关联。当先前角色与隐含角色之间存在关系，并且将先前角色分配给用户时，用户也会承担隐含角色。

- `identity:get_limit_model`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/limits/model` 获取 `/v3/limits/model`  **HEAD** `/v3/limits/model` 头 `/v3/limits/model`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Get limit enforcement model. 获取限制强制模型。

- `identity:get_limit`

  Default 违约 `(role:reader and system_scope:all) or (domain_id:%(target.limit.domain.id)s or domain_id:%(target.limit.project.domain_id)s) or (project_id:%(target.limit.project_id)s and not None:%(target.limit.project_id)s)` Operations 操作 **GET** `/v3/limits/{limit_id}` 获取 `/v3/limits/{limit_id}`  **HEAD** `/v3/limits/{limit_id}` 头 `/v3/limits/{limit_id}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Show limit details. 显示限制详细信息。

- `identity:list_limits`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/limits` 获取 `/v3/limits`  **HEAD** `/v3/limits` 头 `/v3/limits`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List limits. 列表限制。

- `identity:create_limits`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/limits` 发布 `/v3/limits`   Scope Types 作用域类型 **system 系统**  Create limits. 创建限制。

- `identity:update_limit`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/limits/{limit_id}` 补丁 `/v3/limits/{limit_id}`   Scope Types 作用域类型 **system 系统**  Update limit. 更新限制。

- `identity:delete_limit`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/limits/{limit_id}` 删除 `/v3/limits/{limit_id}`   Scope Types 作用域类型 **system 系统**  Delete limit. 删除限制。

- `identity:create_mapping`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/OS-FEDERATION/mappings/{mapping_id}` 放 `/v3/OS-FEDERATION/mappings/{mapping_id}`   Scope Types 作用域类型 **system 系统**  Create a new federated mapping containing one or more sets of rules. 创建包含一组或多组规则的新联合映射。

- `identity:get_mapping`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/mappings/{mapping_id}` 获取 `/v3/OS-FEDERATION/mappings/{mapping_id}`  **HEAD** `/v3/OS-FEDERATION/mappings/{mapping_id}` 头 `/v3/OS-FEDERATION/mappings/{mapping_id}`   Scope Types 作用域类型 **system 系统**  Get a federated mapping. 获取联合映射。

- `identity:list_mappings`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/mappings` 获取 `/v3/OS-FEDERATION/mappings`  **HEAD** `/v3/OS-FEDERATION/mappings` 头 `/v3/OS-FEDERATION/mappings`   Scope Types 作用域类型 **system 系统**  List federated mappings. 列出联合映射。

- `identity:delete_mapping`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-FEDERATION/mappings/{mapping_id}` 删除 `/v3/OS-FEDERATION/mappings/{mapping_id}`   Scope Types 作用域类型 **system 系统**  Delete a federated mapping. 删除联合映射。

- `identity:update_mapping`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/OS-FEDERATION/mappings/{mapping_id}` 补丁 `/v3/OS-FEDERATION/mappings/{mapping_id}`   Scope Types 作用域类型 **system 系统**  Update a federated mapping. 更新联合映射。

- `identity:get_policy`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/policies/{policy_id}` 获取 `/v3/policies/{policy_id}`   Scope Types 作用域类型 **system 系统**  Show policy details. 显示策略详细信息。

- `identity:list_policies`

  Default `role:reader and system_scope:all` Operations 操作 **GET** `/v3/policies` 获取 `/v3/policies`   Scope Types 作用域类型 **system 系统**  List policies. 列出策略。

- `identity:create_policy`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/policies` 发布 `/v3/policies`   Scope Types 作用域类型 **system 系统**  Create policy. 创建策略。

- `identity:update_policy`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/policies/{policy_id}` 补丁 `/v3/policies/{policy_id}`   Scope Types 作用域类型 **system 系统**  Update policy. 更新策略。

- `identity:delete_policy`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/policies/{policy_id}` 删除 `/v3/policies/{policy_id}`   Scope Types 作用域类型 **system 系统**  Delete policy. 删除策略。

- `identity:create_policy_association_for_endpoint`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}` 放 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Associate a policy to a specific endpoint. 将策略关联到特定终端节点。

- `identity:check_policy_association_for_endpoint`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}` 获取 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}`  **HEAD** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}` 头 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Check policy association for endpoint. 检查终结点的策略关联。

- `identity:delete_policy_association_for_endpoint`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}` 删除 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Delete policy association for endpoint. 删除终结点的策略关联。

- `identity:create_policy_association_for_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}` 放 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}`   Scope Types 作用域类型 **system 系统**  Associate a policy to a specific service. 将策略关联到特定服务。

- `identity:check_policy_association_for_service`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}` 获取 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}`  **HEAD** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}` 头 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}`   Scope Types 作用域类型 **system 系统**  Check policy association for service. 检查服务的策略关联。

- `identity:delete_policy_association_for_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}` 删除 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}`   Scope Types 作用域类型 **system 系统**  Delete policy association for service. 删除服务的策略关联。

- `identity:create_policy_association_for_region_and_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}` 放 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}`   Scope Types 作用域类型 **system 系统**  Associate a policy to a specific region and service combination. 将策略关联到特定区域和服务组合。

- `identity:check_policy_association_for_region_and_service`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}` 获取 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}`  **HEAD** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}` 头 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}`   Scope Types 作用域类型 **system 系统**  Check policy association for region and service. 检查区域和服务的策略关联。

- `identity:delete_policy_association_for_region_and_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}` 删除 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}`   Scope Types 作用域类型 **system 系统**  Delete policy association for region and service. 删除区域和服务的策略关联。

- `identity:get_policy_for_endpoint`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy` 获取 `/v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy`  **HEAD** `/v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy` 头 `/v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy`   Scope Types 作用域类型 **system 系统**  Get policy for endpoint. 获取终结点的策略。

- `identity:list_endpoints_for_policy`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints` 获取 `/v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints`   Scope Types 作用域类型 **system 系统**  List endpoints for policy. 列出策略的终结点。

- `identity:get_project`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or project_id:%(target.project.id)s` Operations 操作 **GET** `/v3/projects/{project_id}` 获取 `/v3/projects/{project_id}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Show project details. 显示项目详细信息。

- `identity:list_projects`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.domain_id)s)` Operations 操作 **GET** `/v3/projects` 获取 `/v3/projects`   Scope Types 作用域类型 **system 系统** **domain 域**  List projects. 列出项目。

- `identity:list_user_projects`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.user.domain_id)s) or user_id:%(target.user.id)s` Operations 操作 **GET** `/v3/users/{user_id}/projects` 获取 `/v3/users/{user_id}/projects`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List projects for user. 列出用户的项目。

- `identity:create_project`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s)` Operations 操作 **POST** `/v3/projects` 发布 `/v3/projects`   Scope Types **system 系统** **domain 域**  Create project. 创建项目。

- `identity:update_project`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s)` Operations 操作 **PATCH** `/v3/projects/{project_id}` 补丁 `/v3/projects/{project_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Update project. 更新项目。

- `identity:delete_project`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s)` Operations 操作 **DELETE** `/v3/projects/{project_id}` 删除 `/v3/projects/{project_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Delete project.

- `identity:list_project_tags`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or project_id:%(target.project.id)s` Operations 操作 **GET** `/v3/projects/{project_id}/tags` 获取 `/v3/projects/{project_id}/tags`  **HEAD** `/v3/projects/{project_id}/tags` 头 `/v3/projects/{project_id}/tags`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List tags for a project. 列出项目的标签。

- `identity:get_project_tag`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or project_id:%(target.project.id)s` Operations 操作 **GET** `/v3/projects/{project_id}/tags/{value}` 获取 `/v3/projects/{project_id}/tags/{value}`  **HEAD** `/v3/projects/{project_id}/tags/{value}` 头 `/v3/projects/{project_id}/tags/{value}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Check if project contains a tag. 检查项目是否包含标签。

- `identity:update_project_tags`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)` Operations 操作 **PUT** `/v3/projects/{project_id}/tags` 放 `/v3/projects/{project_id}/tags`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Replace all tags on a project with the new set of tags. 将项目上的所有标记替换为一组新的标记。

- `identity:create_project_tag`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)` Operations 操作 **PUT** `/v3/projects/{project_id}/tags/{value}` 放 `/v3/projects/{project_id}/tags/{value}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Add a single tag to a project. 将单个标签添加到项目。

- `identity:delete_project_tags`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)` Operations 操作 **DELETE** `/v3/projects/{project_id}/tags` 删除 `/v3/projects/{project_id}/tags`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Remove all tags from a project. 从项目中删除所有标签。

- `identity:delete_project_tag`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)` Operations 操作 **DELETE** `/v3/projects/{project_id}/tags/{value}` 删除 `/v3/projects/{project_id}/tags/{value}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Delete a specified tag from project. 从项目中删除指定的标签。

- `identity:list_projects_for_endpoint`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/endpoints/{endpoint_id}/projects`  Scope Types 作用域类型 **system 系统**  List projects allowed to access an endpoint. 列出允许访问终结点的项目。

- `identity:add_endpoint_to_project`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}` 放 `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Allow project to access an endpoint. 允许项目访问终结点。

- `identity:check_endpoint_in_project`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}` 获取 `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`  **HEAD** `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}` 头 `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Check if a project is allowed to access an endpoint. 检查是否允许项目访问终结点。

- `identity:list_endpoints_for_project`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-EP-FILTER/projects/{project_id}/endpoints` 获取 `/v3/OS-EP-FILTER/projects/{project_id}/endpoints`   Scope Types 作用域类型 **system 系统**  List the endpoints a project is allowed to access. 列出允许项目访问的终结点。

- `identity:remove_endpoint_from_project`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}` 删除 `/v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}`   Scope Types 作用域类型 **system 系统**  Remove access to an endpoint from a project that has previously been given explicit access. 从以前被授予显式访问权限的项目中删除对终结点的访问权限。

- `identity:create_protocol`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}` 放 `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`   Scope Types 作用域类型 **system 系统**  Create federated protocol. 创建联合协议。

- `identity:update_protocol`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}` 补丁 `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`   Scope Types 作用域类型 **system 系统**  Update federated protocol. 更新联合协议。

- `identity:get_protocol`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}` 获取 `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`   Scope Types 作用域类型 **system 系统**  Get federated protocol. 获取联合协议。

- `identity:list_protocols`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols` 获取 `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols`   Scope Types 作用域类型 **system 系统**  List federated protocols. 列出联合协议。

- `identity:delete_protocol`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}` 删除 `/v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}`   Scope Types 作用域类型 **system 系统**  Delete federated protocol. 删除联合协议。

- `identity:get_region`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/regions/{region_id}` 获取 `/v3/regions/{region_id}`  **HEAD** `/v3/regions/{region_id}` 头 `/v3/regions/{region_id}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Show region details. 显示区域详细信息。

- `identity:list_regions`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/regions` 获取 `/v3/regions`  **HEAD** `/v3/regions` 头 `/v3/regions`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List regions. 列出区域。

- `identity:create_region`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/regions` 发布 `/v3/regions`  **PUT** `/v3/regions/{region_id}` 放 `/v3/regions/{region_id}`   Scope Types 作用域类型 **system 系统**  Create region. 创建区域。

- `identity:update_region`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/regions/{region_id}` 补丁 `/v3/regions/{region_id}`   Scope Types 作用域类型 **system 系统**  Update region. 更新区域。

- `identity:delete_region`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/regions/{region_id}` 删除 `/v3/regions/{region_id}`   Scope Types 作用域类型 **system 系统**  Delete region. 删除区域。

- `identity:get_registered_limit`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/registered_limits/{registered_limit_id}` 获取 `/v3/registered_limits/{registered_limit_id}`  **HEAD** `/v3/registered_limits/{registered_limit_id}` 头 `/v3/registered_limits/{registered_limit_id}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Show registered limit details. 显示已注册的限制详细信息。

- `identity:list_registered_limits`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/registered_limits` 获取 `/v3/registered_limits`  **HEAD** `/v3/registered_limits` 头 `/v3/registered_limits`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List registered limits. 列出已注册的限制。

- `identity:create_registered_limits`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/registered_limits` 发布 `/v3/registered_limits`   Scope Types 作用域类型 **system 系统**  Create registered limits. 创建已注册的限制。

- `identity:update_registered_limit`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/registered_limits/{registered_limit_id}` 补丁 `/v3/registered_limits/{registered_limit_id}`   Scope Types 作用域类型 **system 系统**  Update registered limit. 更新已注册的限制。

- `identity:delete_registered_limit`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/registered_limits/{registered_limit_id}` 删除 `/v3/registered_limits/{registered_limit_id}`   Scope Types 作用域类型 **system 系统**  Delete registered limit. 删除已注册的限制。

- `identity:list_revoke_events`

  Default 违约 `rule:service_or_admin` Operations 操作 **GET** `/v3/OS-REVOKE/events` 获取 `/v3/OS-REVOKE/events`   Scope Types 作用域类型 **system 系统**  List revocation events. 列出吊销事件。

- `identity:get_role`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/roles/{role_id}` 获取 `/v3/roles/{role_id}`  **HEAD** `/v3/roles/{role_id}` 头 `/v3/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Show role details. 显示角色详细信息。

- `identity:list_roles`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/roles` 获取 `/v3/roles`  **HEAD** `/v3/roles` 头 `/v3/roles`   Scope Types 作用域类型 **system 系统**  List roles. 列出角色。

- `identity:create_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/roles` 发布 `/v3/roles`   Scope Types 作用域类型 **system 系统**  Create role. 创建角色。

- `identity:update_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/roles/{role_id}` 补丁 `/v3/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Update role. 更新角色。

- `identity:delete_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/roles/{role_id}` 删除 `/v3/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Delete role. 删除角色。

- `identity:get_domain_role`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/roles/{role_id}` 获取 `/v3/roles/{role_id}`  **HEAD** `/v3/roles/{role_id}` 头 `/v3/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Show domain role. 显示域角色。

- `identity:list_domain_roles`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/roles?domain_id={domain_id}` 获取 `/v3/roles?domain_id={domain_id}`  **HEAD** `/v3/roles?domain_id={domain_id}` 头 `/v3/roles?domain_id={domain_id}`   Scope Types 作用域类型 **system 系统**  List domain roles. 列出域角色。

- `identity:create_domain_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/roles` 发布 `/v3/roles`   Scope Types 作用域类型 **system 系统**  Create domain role. 创建域角色。

- `identity:update_domain_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/roles/{role_id}` 补丁 `/v3/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Update domain role. 更新域角色。

- `identity:delete_domain_role`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/roles/{role_id}` 删除 `/v3/roles/{role_id}`   Scope Types 作用域类型 **system 系统**  Delete domain role. 删除域角色。

- `identity:list_role_assignments`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.domain_id)s)` Operations 操作 **GET** `/v3/role_assignments` 获取 `/v3/role_assignments`  **HEAD** `/v3/role_assignments` 头 `/v3/role_assignments`   Scope Types 作用域类型 **system 系统** **domain 域**  List role assignments. 列出角色分配。

- `identity:list_role_assignments_for_tree`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)` Operations 操作 **GET** `/v3/role_assignments?include_subtree` 获取 `/v3/role_assignments?include_subtree`  **HEAD** `/v3/role_assignments?include_subtree` 头 `/v3/role_assignments?include_subtree`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  List all role assignments for a given tree of hierarchical projects. 列出给定分层项目树的所有角色分配。

- `identity:get_service`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/services/{service_id}` 获取 `/v3/services/{service_id}`   Scope Types 作用域类型 **system 系统**  Show service details. 显示服务详细信息。

- `identity:list_services`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/services` 获取 `/v3/services`   Scope Types 作用域类型 **system 系统**  List services. 列出服务。

- `identity:create_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **POST** `/v3/services` 发布 `/v3/services`   Scope Types 作用域类型 **system 系统**  Create service. 创建服务。

- `identity:update_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/services/{service_id}` 补丁 `/v3/services/{service_id}`   Scope Types 作用域类型 **system 系统**  Update service. 更新服务。

- `identity:delete_service`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/services/{service_id}` 删除 `/v3/services/{service_id}`   Scope Types 作用域类型 **system 系统**  Delete service. 删除服务。

- `identity:create_service_provider`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PUT** `/v3/OS-FEDERATION/service_providers/{service_provider_id}` 放 `/v3/OS-FEDERATION/service_providers/{service_provider_id}`   Scope Types 作用域类型 **system 系统**  Create federated service provider. 创建联合服务提供商。

- `identity:list_service_providers`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/service_providers` 获取 `/v3/OS-FEDERATION/service_providers`  **HEAD** `/v3/OS-FEDERATION/service_providers` 头 `/v3/OS-FEDERATION/service_providers`   Scope Types 作用域类型 **system 系统**  List federated service providers. 列出联合服务提供商。

- `identity:get_service_provider`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-FEDERATION/service_providers/{service_provider_id}` 获取 `/v3/OS-FEDERATION/service_providers/{service_provider_id}`  **HEAD** `/v3/OS-FEDERATION/service_providers/{service_provider_id}` 头 `/v3/OS-FEDERATION/service_providers/{service_provider_id}`   Scope Types 作用域类型 **system 系统**  Get federated service provider. 获取联合服务提供商。

- `identity:update_service_provider`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **PATCH** `/v3/OS-FEDERATION/service_providers/{service_provider_id}` 补丁 `/v3/OS-FEDERATION/service_providers/{service_provider_id}`   Scope Types 作用域类型 **system 系统**  Update federated service provider. 更新联合服务提供商。

- `identity:delete_service_provider`

  Default 违约 `role:admin and system_scope:all` Operations 操作 **DELETE** `/v3/OS-FEDERATION/service_providers/{service_provider_id}` 删除 `/v3/OS-FEDERATION/service_providers/{service_provider_id}`   Scope Types 作用域类型 **system 系统**  Delete federated service provider. 删除联合服务提供商。

- `identity:revocation_list`

  Default 违约 `rule:service_or_admin` Operations 操作 **GET** `/v3/auth/tokens/OS-PKI/revoked` 获取 `/v3/auth/tokens/OS-PKI/revoked`   Scope Types 作用域类型 **system 系统** **project 项目**  List revoked PKI tokens. 列出已吊销的 PKI 令牌。

- `identity:check_token`

  Default 违约 `(role:reader and system_scope:all) or rule:token_subject` Operations 操作 **HEAD** `/v3/auth/tokens` 头 `/v3/auth/tokens`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Check a token. 检查令牌。

- `identity:validate_token`

  Default 违约 `(role:reader and system_scope:all) or rule:service_role or rule:token_subject` Operations 操作 **GET** `/v3/auth/tokens` 获取 `/v3/auth/tokens`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Validate a token. 验证令牌。

- `identity:revoke_token`

  Default 违约 `(role:admin and system_scope:all) or rule:token_subject` Operations 操作 **DELETE** `/v3/auth/tokens` 删除 `/v3/auth/tokens`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Revoke a token. 吊销令牌。

- `identity:create_trust`

  Default 违约 `user_id:%(trust.trustor_user_id)s` Operations 操作 **POST** `/v3/OS-TRUST/trusts` 发布 `/v3/OS-TRUST/trusts`   Scope Types 作用域类型 **project 项目**  Create trust. 建立信任。

- `identity:list_trusts`

  Default 违约 `role:reader and system_scope:all` Operations 操作 **GET** `/v3/OS-TRUST/trusts` 获取 `/v3/OS-TRUST/trusts`  **HEAD** `/v3/OS-TRUST/trusts` 头 `/v3/OS-TRUST/trusts`   Scope Types 作用域类型 **system 系统**  List trusts. 列出信任。

- `identity:list_trusts_for_trustor`

  Default 违约 `role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s` Operations 操作 **GET** `/v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id}` 获取 `/v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id}`  **HEAD** `/v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id}` 头 `/v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  List trusts for trustor. 列出委托人的信任。

- `identity:list_trusts_for_trustee`

  Default 违约 `role:reader and system_scope:all or user_id:%(target.trust.trustee_user_id)s` Operations 操作 **GET** `/v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id}` 获取 `/v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id}`  **HEAD** `/v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id}` 头 `/v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  List trusts for trustee. 列出受托人的信托。

- `identity:list_roles_for_trust`

  Default 违约 `role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s or user_id:%(target.trust.trustee_user_id)s` Operations 操作 **GET** `/v3/OS-TRUST/trusts/{trust_id}/roles` 获取 `/v3/OS-TRUST/trusts/{trust_id}/roles`  **HEAD** `/v3/OS-TRUST/trusts/{trust_id}/roles` 头 `/v3/OS-TRUST/trusts/{trust_id}/roles`   Scope Types 作用域类型 **system 系统** **project 项目**  List roles delegated by a trust. 列出信任委派的角色。

- `identity:get_role_for_trust`

  Default 违约 `role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s or user_id:%(target.trust.trustee_user_id)s` Operations 操作 **GET** `/v3/OS-TRUST/trusts/{trust_id}/roles/{role_id}` 获取 `/v3/OS-TRUST/trusts/{trust_id}/roles/{role_id}`  **HEAD** `/v3/OS-TRUST/trusts/{trust_id}/roles/{role_id}` 头 `/v3/OS-TRUST/trusts/{trust_id}/roles/{role_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Check if trust delegates a particular role. 检查信任是否委派了特定角色。

- `identity:delete_trust`

  Default 违约 `role:admin and system_scope:all or user_id:%(target.trust.trustor_user_id)s` Operations 操作 **DELETE** `/v3/OS-TRUST/trusts/{trust_id}` 删除 `/v3/OS-TRUST/trusts/{trust_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Revoke trust. 撤销信任。

- `identity:get_trust`

  Default 违约 `role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s or user_id:%(target.trust.trustee_user_id)s` Operations 操作 **GET** `/v3/OS-TRUST/trusts/{trust_id}` 获取 `/v3/OS-TRUST/trusts/{trust_id}`  **HEAD** `/v3/OS-TRUST/trusts/{trust_id}` 头 `/v3/OS-TRUST/trusts/{trust_id}`   Scope Types 作用域类型 **system 系统** **project 项目**  Get trust. 获得信任。

- `identity:get_user`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and token.domain.id:%(target.user.domain_id)s) or user_id:%(target.user.id)s` Operations 操作 **GET** `/v3/users/{user_id}` 获取 `/v3/users/{user_id}`  **HEAD** `/v3/users/{user_id}` 头 `/v3/users/{user_id}`   Scope Types 作用域类型 **system 系统** **domain 域** **project 项目**  Show user details. 显示用户详细信息。

- `identity:list_users`

  Default 违约 `(role:reader and system_scope:all) or (role:reader and domain_id:%(target.domain_id)s)` Operations 操作 **GET** `/v3/users` 获取 `/v3/users`  **HEAD** `/v3/users` 头 `/v3/users`   Scope Types 作用域类型 **system 系统** **domain 域**  List users. 列出用户。

- `identity:list_projects_for_user`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `` /v3/auth/projects`` 获取 '' /v3/auth/projects''  List all projects a user has access to via role assignments. 列出用户通过角色分配有权访问的所有项目。

- `identity:list_domains_for_user`

  Default 违约 <empty string> <空字符串> Operations 操作 **GET** `/v3/auth/domains` 获取 `/v3/auth/domains`   List all domains a user has access to via role assignments. 列出用户通过角色分配有权访问的所有域。

- `identity:create_user`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and token.domain.id:%(target.user.domain_id)s)` Operations 操作 **POST** `/v3/users` 发布 `/v3/users`   Scope Types 作用域类型 **system 系统** **domain 域**  Create a user. 创建用户。

- `identity:update_user`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and token.domain.id:%(target.user.domain_id)s)` Operations **PATCH** `/v3/users/{user_id}` 补丁 `/v3/users/{user_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Update a user, including administrative password resets. 更新用户，包括管理密码重置。

- `identity:delete_user`

  Default 违约 `(role:admin and system_scope:all) or (role:admin and token.domain.id:%(target.user.domain_id)s)` Operations 操作 **DELETE** `/v3/users/{user_id}` 删除 `/v3/users/{user_id}`   Scope Types 作用域类型 **system 系统** **domain 域**  Delete a user. 删除用户。



# 示例配置文件

# keystone.conf keystone.conf （英语）

​                                          

Use the `keystone.conf` file to configure most Identity service options. This sample configuration can also be viewed in [raw format](https://docs.openstack.org/keystone/yoga/_static/keystone.conf.sample).
使用该 `keystone.conf` 文件配置大多数 Identity Service 选项。此示例配置也可以以原始格式查看。

```
[DEFAULT]

#
# From keystone
#

# Using this feature is *NOT* recommended. Instead, use the `keystone-manage
# bootstrap` command. The value of this option is treated as a "shared secret"
# that can be used to bootstrap Keystone through the API. This "token" does not
# represent a user (it has no identity), and carries no explicit authorization
# (it effectively bypasses most authorization checks). If set to `None`, the
# value is ignored and the `admin_token` middleware is effectively disabled.
# (string value)
#admin_token = <None>

# The base public endpoint URL for Keystone that is advertised to clients
# (NOTE: this does NOT affect how Keystone listens for connections). Defaults
# to the base host URL of the request. For example, if keystone receives a
# request to `http://server:5000/v3/users`, then this will option will be
# automatically treated as `http://server:5000`. You should only need to set
# option if either the value of the base URL contains a path that keystone does
# not automatically infer (`/prefix/v3`), or if the endpoint should be found on
# a different host. (uri value)
#public_endpoint = <None>

# Maximum depth of the project hierarchy, excluding the project acting as a
# domain at the top of the hierarchy. WARNING: Setting it to a large value may
# adversely impact performance. (integer value)
#max_project_tree_depth = 5

# Limit the sizes of user & project ID/names. (integer value)
#max_param_size = 64

# Similar to `[DEFAULT] max_param_size`, but provides an exception for token
# values. With Fernet tokens, this can be set as low as 255. (integer value)
#max_token_size = 255

# The maximum number of entities that will be returned in a collection. This
# global limit may be then overridden for a specific driver, by specifying a
# list_limit in the appropriate section (for example, `[assignment]`). No limit
# is set by default. In larger deployments, it is recommended that you set this
# to a reasonable number to prevent operations like listing all users and
# projects from placing an unnecessary load on the system. (integer value)
#list_limit = <None>

# If set to true, strict password length checking is performed for password
# manipulation. If a password exceeds the maximum length, the operation will
# fail with an HTTP 403 Forbidden error. If set to false, passwords are
# automatically truncated to the maximum length. (boolean value)
#strict_password_check = false

# If set to true, then the server will return information in HTTP responses
# that may allow an unauthenticated or authenticated user to get more
# information than normal, such as additional details about why authentication
# failed. This may be useful for debugging but is insecure. (boolean value)
#insecure_debug = false

# Default `publisher_id` for outgoing notifications. If left undefined,
# Keystone will default to using the server's host name. (string value)
#default_publisher_id = <None>

# Define the notification format for identity service events. A `basic`
# notification only has information about the resource being operated on. A
# `cadf` notification has the same information, as well as information about
# the initiator of the event. The `cadf` option is entirely backwards
# compatible with the `basic` option, but is fully CADF-compliant, and is
# recommended for auditing use cases. (string value)
# Possible values:
# basic - <No description provided>
# cadf - <No description provided>
#notification_format = cadf

# You can reduce the number of notifications keystone emits by explicitly
# opting out. Keystone will not emit notifications that match the patterns
# expressed in this list. Values are expected to be in the form of
# `identity.<resource_type>.<operation>`. By default, all notifications related
# to authentication are automatically suppressed. This field can be set
# multiple times in order to opt-out of multiple notification topics. For
# example, the following suppresses notifications describing user creation or
# successful authentication events: notification_opt_out=identity.user.create
# notification_opt_out=identity.authenticate.success (multi valued)
#notification_opt_out = identity.authenticate.success
#notification_opt_out = identity.authenticate.pending
#notification_opt_out = identity.authenticate.failed

#
# From oslo.log
#

# If set to true, the logging level will be set to DEBUG instead of the default
# INFO level. (boolean value)
# Note: This option can be changed without restarting.
#debug = false

# The name of a logging configuration file. This file is appended to any
# existing logging configuration files. For details about logging configuration
# files, see the Python logging module documentation. Note that when logging
# configuration files are used then all logging configuration is set in the
# configuration file and other logging configuration options are ignored (for
# example, log-date-format). (string value)
# Note: This option can be changed without restarting.
# Deprecated group/name - [DEFAULT]/log_config
#log_config_append = <None>

# Defines the format string for %%(asctime)s in log records. Default:
# %(default)s . This option is ignored if log_config_append is set. (string
# value)
#log_date_format = %Y-%m-%d %H:%M:%S

# (Optional) Name of log file to send logging output to. If no default is set,
# logging will go to stderr as defined by use_stderr. This option is ignored if
# log_config_append is set. (string value)
# Deprecated group/name - [DEFAULT]/logfile
#log_file = <None>

# (Optional) The base directory used for relative log_file  paths. This option
# is ignored if log_config_append is set. (string value)
# Deprecated group/name - [DEFAULT]/logdir
#log_dir = <None>

# Uses logging handler designed to watch file system. When log file is moved or
# removed this handler will open a new log file with specified path
# instantaneously. It makes sense only if log_file option is specified and
# Linux platform is used. This option is ignored if log_config_append is set.
# (boolean value)
#watch_log_file = false

# Use syslog for logging. Existing syslog format is DEPRECATED and will be
# changed later to honor RFC5424. This option is ignored if log_config_append
# is set. (boolean value)
#use_syslog = false

# Enable journald for logging. If running in a systemd environment you may wish
# to enable journal support. Doing so will use the journal native protocol
# which includes structured metadata in addition to log messages.This option is
# ignored if log_config_append is set. (boolean value)
#use_journal = false

# Syslog facility to receive log lines. This option is ignored if
# log_config_append is set. (string value)
#syslog_log_facility = LOG_USER

# Use JSON formatting for logging. This option is ignored if log_config_append
# is set. (boolean value)
#use_json = false

# Log output to standard error. This option is ignored if log_config_append is
# set. (boolean value)
#use_stderr = false

# Log output to Windows Event Log. (boolean value)
#use_eventlog = false

# The amount of time before the log files are rotated. This option is ignored
# unless log_rotation_type is set to "interval". (integer value)
#log_rotate_interval = 1

# Rotation interval type. The time of the last file change (or the time when
# the service was started) is used when scheduling the next rotation. (string
# value)
# Possible values:
# Seconds - <No description provided>
# Minutes - <No description provided>
# Hours - <No description provided>
# Days - <No description provided>
# Weekday - <No description provided>
# Midnight - <No description provided>
#log_rotate_interval_type = days

# Maximum number of rotated log files. (integer value)
#max_logfile_count = 30

# Log file maximum size in MB. This option is ignored if "log_rotation_type" is
# not set to "size". (integer value)
#max_logfile_size_mb = 200

# Log rotation type. (string value)
# Possible values:
# interval - Rotate logs at predefined time intervals.
# size - Rotate logs once they reach a predefined size.
# none - Do not rotate log files.
#log_rotation_type = none

# Format string to use for log messages with context. Used by
# oslo_log.formatters.ContextFormatter (string value)
#logging_context_format_string = %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s

# Format string to use for log messages when context is undefined. Used by
# oslo_log.formatters.ContextFormatter (string value)
#logging_default_format_string = %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s

# Additional data to append to log message when logging level for the message
# is DEBUG. Used by oslo_log.formatters.ContextFormatter (string value)
#logging_debug_format_suffix = %(funcName)s %(pathname)s:%(lineno)d

# Prefix each line of exception output with this format. Used by
# oslo_log.formatters.ContextFormatter (string value)
#logging_exception_prefix = %(asctime)s.%(msecs)03d %(process)d ERROR %(name)s %(instance)s

# Defines the format string for %(user_identity)s that is used in
# logging_context_format_string. Used by oslo_log.formatters.ContextFormatter
# (string value)
#logging_user_identity_format = %(user)s %(project)s %(domain)s %(user_domain)s %(project_domain)s

# List of package logging levels in logger=LEVEL pairs. This option is ignored
# if log_config_append is set. (list value)
#default_log_levels = amqp=WARN,amqplib=WARN,boto=WARN,qpid=WARN,sqlalchemy=WARN,suds=INFO,oslo.messaging=INFO,oslo_messaging=INFO,iso8601=WARN,requests.packages.urllib3.connectionpool=WARN,urllib3.connectionpool=WARN,websocket=WARN,requests.packages.urllib3.util.retry=WARN,urllib3.util.retry=WARN,keystonemiddleware=WARN,routes.middleware=WARN,stevedore=WARN,taskflow=WARN,keystoneauth=WARN,oslo.cache=INFO,oslo_policy=INFO,dogpile.core.dogpile=INFO

# Enables or disables publication of error events. (boolean value)
#publish_errors = false

# The format for an instance that is passed with the log message. (string
# value)
#instance_format = "[instance: %(uuid)s] "

# The format for an instance UUID that is passed with the log message. (string
# value)
#instance_uuid_format = "[instance: %(uuid)s] "

# Interval, number of seconds, of log rate limiting. (integer value)
#rate_limit_interval = 0

# Maximum number of logged messages per rate_limit_interval. (integer value)
#rate_limit_burst = 0

# Log level name used by rate limiting: CRITICAL, ERROR, INFO, WARNING, DEBUG
# or empty string. Logs with level greater or equal to rate_limit_except_level
# are not filtered. An empty string means that all levels are filtered. (string
# value)
#rate_limit_except_level = CRITICAL

# Enables or disables fatal status of deprecations. (boolean value)
#fatal_deprecations = false

#
# From oslo.messaging
#

# Size of RPC connection pool. (integer value)
# Minimum value: 1
#rpc_conn_pool_size = 30

# The pool size limit for connections expiration policy (integer value)
#conn_pool_min_size = 2

# The time-to-live in sec of idle connections in the pool (integer value)
#conn_pool_ttl = 1200

# Size of executor thread pool when executor is threading or eventlet. (integer
# value)
# Deprecated group/name - [DEFAULT]/rpc_thread_pool_size
#executor_thread_pool_size = 64

# Seconds to wait for a response from a call. (integer value)
#rpc_response_timeout = 60

# The network address and optional user credentials for connecting to the
# messaging backend, in URL format. The expected format is:
#
# driver://[user:pass@]host:port[,[userN:passN@]hostN:portN]/virtual_host?query
#
# Example: rabbit://rabbitmq:password@127.0.0.1:5672//
#
# For full details on the fields in the URL see the documentation of
# oslo_messaging.TransportURL at
# https://docs.openstack.org/oslo.messaging/latest/reference/transport.html
# (string value)
#transport_url = rabbit://

# The default exchange under which topics are scoped. May be overridden by an
# exchange name specified in the transport_url option. (string value)
#control_exchange = keystone

# Add an endpoint to answer to ping calls. Endpoint is named
# oslo_rpc_server_ping (boolean value)
#rpc_ping_enabled = false


[application_credential]

#
# From keystone
#

# Entry point for the application credential backend driver in the
# `keystone.application_credential` namespace.  Keystone only provides a `sql`
# driver, so there is no reason to change this unless you are providing a
# custom entry point. (string value)
#driver = sql

# Toggle for application credential caching. This has no effect unless global
# caching is enabled. (boolean value)
#caching = true

# Time to cache application credential data in seconds. This has no effect
# unless global caching is enabled. (integer value)
#cache_time = <None>

# Maximum number of application credentials a user is permitted to create. A
# value of -1 means unlimited. If a limit is not set, users are permitted to
# create application credentials at will, which could lead to bloat in the
# keystone database or open keystone to a DoS attack. (integer value)
#user_limit = -1


[assignment]

#
# From keystone
#

# Entry point for the assignment backend driver (where role assignments are
# stored) in the `keystone.assignment` namespace. Only a SQL driver is supplied
# by keystone itself. Unless you are writing proprietary drivers for keystone,
# you do not need to set this option. (string value)
#driver = sql

# A list of role names which are prohibited from being an implied role. (list
# value)
#prohibited_implied_role = admin


[auth]

#
# From keystone
#

# Allowed authentication methods. Note: You should disable the `external` auth
# method if you are currently using federation. External auth and federation
# both use the REMOTE_USER variable. Since both the mapped and external plugin
# are being invoked to validate attributes in the request environment, it can
# cause conflicts. (list value)
#methods = external,password,token,oauth1,mapped,application_credential

# Entry point for the password auth plugin module in the
# `keystone.auth.password` namespace. You do not need to set this unless you
# are overriding keystone's own password authentication plugin. (string value)
#password = <None>

# Entry point for the token auth plugin module in the `keystone.auth.token`
# namespace. You do not need to set this unless you are overriding keystone's
# own token authentication plugin. (string value)
#token = <None>

# Entry point for the external (`REMOTE_USER`) auth plugin module in the
# `keystone.auth.external` namespace. Supplied drivers are `DefaultDomain` and
# `Domain`. The default driver is `DefaultDomain`, which assumes that all users
# identified by the username specified to keystone in the `REMOTE_USER`
# variable exist within the context of the default domain. The `Domain` option
# expects an additional environment variable be presented to keystone,
# `REMOTE_DOMAIN`, containing the domain name of the `REMOTE_USER` (if
# `REMOTE_DOMAIN` is not set, then the default domain will be used instead).
# You do not need to set this unless you are taking advantage of "external
# authentication", where the application server (such as Apache) is handling
# authentication instead of keystone. (string value)
#external = <None>

# Entry point for the OAuth 1.0a auth plugin module in the
# `keystone.auth.oauth1` namespace. You do not need to set this unless you are
# overriding keystone's own `oauth1` authentication plugin. (string value)
#oauth1 = <None>

# Entry point for the mapped auth plugin module in the `keystone.auth.mapped`
# namespace. You do not need to set this unless you are overriding keystone's
# own `mapped` authentication plugin. (string value)
#mapped = <None>

# Entry point for the application_credential auth plugin module in the
# `keystone.auth.application_credential` namespace. You do not need to set this
# unless you are overriding keystone's own `application_credential`
# authentication plugin. (string value)
#application_credential = <None>


[cache]

#
# From oslo.cache
#

# Prefix for building the configuration dictionary for the cache region. This
# should not need to be changed unless there is another dogpile.cache region
# with the same configuration name. (string value)
#config_prefix = cache.oslo

# Default TTL, in seconds, for any cached item in the dogpile.cache region.
# This applies to any cached method that doesn't have an explicit cache
# expiration time defined for it. (integer value)
#expiration_time = 600

# Cache backend module. For eventlet-based or environments with hundreds of
# threaded servers, Memcache with pooling (oslo_cache.memcache_pool) is
# recommended. For environments with less than 100 threaded servers, Memcached
# (dogpile.cache.memcached) or Redis (dogpile.cache.redis) is recommended. Test
# environments with a single instance of the server can use the
# dogpile.cache.memory backend. (string value)
# Possible values:
# oslo_cache.memcache_pool - <No description provided>
# oslo_cache.dict - <No description provided>
# oslo_cache.mongo - <No description provided>
# oslo_cache.etcd3gw - <No description provided>
# dogpile.cache.pymemcache - <No description provided>
# dogpile.cache.memcached - <No description provided>
# dogpile.cache.pylibmc - <No description provided>
# dogpile.cache.bmemcached - <No description provided>
# dogpile.cache.dbm - <No description provided>
# dogpile.cache.redis - <No description provided>
# dogpile.cache.memory - <No description provided>
# dogpile.cache.memory_pickle - <No description provided>
# dogpile.cache.null - <No description provided>
#backend = dogpile.cache.null

# Arguments supplied to the backend module. Specify this option once per
# argument to be passed to the dogpile.cache backend. Example format:
# "<argname>:<value>". (multi valued)
#backend_argument =

# Proxy classes to import that will affect the way the dogpile.cache backend
# functions. See the dogpile.cache documentation on changing-backend-behavior.
# (list value)
#proxies =

# Global toggle for caching. (boolean value)
#enabled = true

# Extra debugging from the cache backend (cache keys, get/set/delete/etc
# calls). This is only really useful if you need to see the specific cache-
# backend get/set/delete calls with the keys/values.  Typically this should be
# left set to false. (boolean value)
#debug_cache_backend = false

# Memcache servers in the format of "host:port". (dogpile.cache.memcached and
# oslo_cache.memcache_pool backends only). If a given host refer to an IPv6 or
# a given domain refer to IPv6 then you should prefix the given address with
# the address family (``inet6``) (e.g ``inet6[::1]:11211``,
# ``inet6:[fd12:3456:789a:1::1]:11211``,
# ``inet6:[controller-0.internalapi]:11211``). If the address family is not
# given then default address family used will be ``inet`` which correspond to
# IPv4 (list value)
#memcache_servers = localhost:11211

# Number of seconds memcached server is considered dead before it is tried
# again. (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).
# (integer value)
#memcache_dead_retry = 300

# Timeout in seconds for every call to a server. (dogpile.cache.memcache and
# oslo_cache.memcache_pool backends only). (floating point value)
#memcache_socket_timeout = 1.0

# Max total number of open connections to every memcached server.
# (oslo_cache.memcache_pool backend only). (integer value)
#memcache_pool_maxsize = 10

# Number of seconds a connection to memcached is held unused in the pool before
# it is closed. (oslo_cache.memcache_pool backend only). (integer value)
#memcache_pool_unused_timeout = 60

# Number of seconds that an operation will wait to get a memcache client
# connection. (integer value)
#memcache_pool_connection_get_timeout = 10

# Global toggle if memcache will be flushed on reconnect.
# (oslo_cache.memcache_pool backend only). (boolean value)
#memcache_pool_flush_on_reconnect = false

# Global toggle for TLS usage when comunicating with the caching servers.
# (boolean value)
#tls_enabled = false

# Path to a file of concatenated CA certificates in PEM format necessary to
# establish the caching servers' authenticity. If tls_enabled is False, this
# option is ignored. (string value)
#tls_cafile = <None>

# Path to a single file in PEM format containing the client's certificate as
# well as any number of CA certificates needed to establish the certificate's
# authenticity. This file is only required when client side authentication is
# necessary. If tls_enabled is False, this option is ignored. (string value)
#tls_certfile = <None>

# Path to a single file containing the client's private key in. Otherwise the
# private key will be taken from the file specified in tls_certfile. If
# tls_enabled is False, this option is ignored. (string value)
#tls_keyfile = <None>

# Set the available ciphers for sockets created with the TLS context. It should
# be a string in the OpenSSL cipher list format. If not specified, all OpenSSL
# enabled ciphers will be available. (string value)
#tls_allowed_ciphers = <None>

# Global toggle for the socket keepalive of dogpile's pymemcache backend
# (boolean value)
#enable_socket_keepalive = false

# The time (in seconds) the connection needs to remain idle before TCP starts
# sending keepalive probes. Should be a positive integer most greater than
# zero. (integer value)
# Minimum value: 0
#socket_keepalive_idle = 1

# The time (in seconds) between individual keepalive probes. Should be a
# positive integer greater than zero. (integer value)
# Minimum value: 0
#socket_keepalive_interval = 1

# The maximum number of keepalive probes TCP should send before dropping the
# connection. Should be a positive integer greater than zero. (integer value)
# Minimum value: 0
#socket_keepalive_count = 1

# Enable retry client mechanisms to handle failure. Those mechanisms can be
# used to wrap all kind of pymemcache clients. The wrapper allows you to define
# how many attempts to make and how long to wait between attemots. (boolean
# value)
#enable_retry_client = false

# Number of times to attempt an action before failing. (integer value)
# Minimum value: 1
#retry_attempts = 2

# Number of seconds to sleep between each attempt. (floating point value)
#retry_delay = 0

# Amount of times a client should be tried before it is marked dead and removed
# from the pool in the HashClient's internal mechanisms. (integer value)
# Minimum value: 1
#hashclient_retry_attempts = 2

# Time in seconds that should pass between retry attempts in the HashClient's
# internal mechanisms. (floating point value)
#hashclient_retry_delay = 1

# Time in seconds before attempting to add a node back in the pool in the
# HashClient's internal mechanisms. (floating point value)
#dead_timeout = 60


[catalog]

#
# From keystone
#

# Absolute path to the file used for the templated catalog backend. This option
# is only used if the `[catalog] driver` is set to `templated`. (string value)
#template_file = default_catalog.templates

# Entry point for the catalog driver in the `keystone.catalog` namespace.
# Keystone provides a `sql` option (which supports basic CRUD operations
# through SQL), a `templated` option (which loads the catalog from a templated
# catalog file on disk), and a `endpoint_filter.sql` option (which supports
# arbitrary service catalogs per project). (string value)
#driver = sql

# Toggle for catalog caching. This has no effect unless global caching is
# enabled. In a typical deployment, there is no reason to disable this.
# (boolean value)
#caching = true

# Time to cache catalog data (in seconds). This has no effect unless global and
# catalog caching are both enabled. Catalog data (services, endpoints, etc.)
# typically does not change frequently, and so a longer duration than the
# global default may be desirable. (integer value)
#cache_time = <None>

# Maximum number of entities that will be returned in a catalog collection.
# There is typically no reason to set this, as it would be unusual for a
# deployment to have enough services or endpoints to exceed a reasonable limit.
# (integer value)
#list_limit = <None>


[cors]

#
# From oslo.middleware
#

# Indicate whether this resource may be shared with the domain received in the
# requests "origin" header. Format: "<protocol>://<host>[:<port>]", no trailing
# slash. Example: https://horizon.example.com (list value)
#allowed_origin = <None>

# Indicate that the actual request can include user credentials (boolean value)
#allow_credentials = true

# Indicate which headers are safe to expose to the API. Defaults to HTTP Simple
# Headers. (list value)
#expose_headers = X-Auth-Token,X-Openstack-Request-Id,X-Subject-Token,Openstack-Auth-Receipt

# Maximum cache age of CORS preflight requests. (integer value)
#max_age = 3600

# Indicate which methods can be used during the actual request. (list value)
#allow_methods = GET,PUT,POST,DELETE,PATCH

# Indicate which header field names may be used during the actual request.
# (list value)
#allow_headers = X-Auth-Token,X-Openstack-Request-Id,X-Subject-Token,X-Project-Id,X-Project-Name,X-Project-Domain-Id,X-Project-Domain-Name,X-Domain-Id,X-Domain-Name,Openstack-Auth-Receipt


[credential]

#
# From keystone
#

# Entry point for the credential backend driver in the `keystone.credential`
# namespace. Keystone only provides a `sql` driver, so there's no reason to
# change this unless you are providing a custom entry point. (string value)
#driver = sql

# Entry point for credential encryption and decryption operations in the
# `keystone.credential.provider` namespace. Keystone only provides a `fernet`
# driver, so there's no reason to change this unless you are providing a custom
# entry point to encrypt and decrypt credentials. (string value)
#provider = fernet

# Directory containing Fernet keys used to encrypt and decrypt credentials
# stored in the credential backend. Fernet keys used to encrypt credentials
# have no relationship to Fernet keys used to encrypt Fernet tokens. Both sets
# of keys should be managed separately and require different rotation policies.
# Do not share this repository with the repository used to manage keys for
# Fernet tokens. (string value)
#key_repository = /etc/keystone/credential-keys/

# Toggle for caching only on retrieval of user credentials. This has no effect
# unless global caching is enabled. (boolean value)
#caching = true

# Time to cache credential data in seconds. This has no effect unless global
# caching is enabled. (integer value)
#cache_time = <None>

# The length of time in minutes for which a signed EC2 or S3 token request is
# valid from the timestamp contained in the token request. (integer value)
#auth_ttl = 15

# Maximum number of credentials a user is permitted to create. A value of -1
# means unlimited. If a limit is not set, users are permitted to create
# credentials at will, which could lead to bloat in the keystone database or
# open keystone to a DoS attack. (integer value)
#user_limit = -1


[database]

#
# From oslo.db
#

# If True, SQLite uses synchronous mode. (boolean value)
#sqlite_synchronous = true

# The back end to use for the database. (string value)
# Deprecated group/name - [DEFAULT]/db_backend
#backend = sqlalchemy

# The SQLAlchemy connection string to use to connect to the database. (string
# value)
# Deprecated group/name - [DEFAULT]/sql_connection
# Deprecated group/name - [DATABASE]/sql_connection
# Deprecated group/name - [sql]/connection
#connection = <None>

# The SQLAlchemy connection string to use to connect to the slave database.
# (string value)
#slave_connection = <None>

# The SQL mode to be used for MySQL sessions. This option, including the
# default, overrides any server-set SQL mode. To use whatever SQL mode is set
# by the server configuration, set this to no value. Example: mysql_sql_mode=
# (string value)
#mysql_sql_mode = TRADITIONAL

# If True, transparently enables support for handling MySQL Cluster (NDB).
# (boolean value)
#mysql_enable_ndb = false

# Connections which have been present in the connection pool longer than this
# number of seconds will be replaced with a new one the next time they are
# checked out from the pool. (integer value)
#connection_recycle_time = 3600

# Maximum number of SQL connections to keep open in a pool. Setting a value of
# 0 indicates no limit. (integer value)
#max_pool_size = 5

# Maximum number of database connection retries during startup. Set to -1 to
# specify an infinite retry count. (integer value)
# Deprecated group/name - [DEFAULT]/sql_max_retries
# Deprecated group/name - [DATABASE]/sql_max_retries
#max_retries = 10

# Interval between retries of opening a SQL connection. (integer value)
# Deprecated group/name - [DEFAULT]/sql_retry_interval
# Deprecated group/name - [DATABASE]/reconnect_interval
#retry_interval = 10

# If set, use this value for max_overflow with SQLAlchemy. (integer value)
# Deprecated group/name - [DEFAULT]/sql_max_overflow
# Deprecated group/name - [DATABASE]/sqlalchemy_max_overflow
#max_overflow = 50

# Verbosity of SQL debugging information: 0=None, 100=Everything. (integer
# value)
# Minimum value: 0
# Maximum value: 100
# Deprecated group/name - [DEFAULT]/sql_connection_debug
#connection_debug = 0

# Add Python stack traces to SQL as comment strings. (boolean value)
# Deprecated group/name - [DEFAULT]/sql_connection_trace
#connection_trace = false

# If set, use this value for pool_timeout with SQLAlchemy. (integer value)
# Deprecated group/name - [DATABASE]/sqlalchemy_pool_timeout
#pool_timeout = <None>

# Enable the experimental use of database reconnect on connection lost.
# (boolean value)
#use_db_reconnect = false

# Seconds between retries of a database transaction. (integer value)
#db_retry_interval = 1

# If True, increases the interval between retries of a database operation up to
# db_max_retry_interval. (boolean value)
#db_inc_retry_interval = true

# If db_inc_retry_interval is set, the maximum seconds between retries of a
# database operation. (integer value)
#db_max_retry_interval = 10

# Maximum retries in case of connection error or deadlock error before error is
# raised. Set to -1 to specify an infinite retry count. (integer value)
#db_max_retries = 20

# Optional URL parameters to append onto the connection URL at connect time;
# specify as param1=value1&param2=value2&... (string value)
#connection_parameters =


[domain_config]

#
# From keystone
#

# Entry point for the domain-specific configuration driver in the
# `keystone.resource.domain_config` namespace. Only a `sql` option is provided
# by keystone, so there is no reason to set this unless you are providing a
# custom entry point. (string value)
#driver = sql

# Toggle for caching of the domain-specific configuration backend. This has no
# effect unless global caching is enabled. There is normally no reason to
# disable this. (boolean value)
#caching = true

# Time-to-live (TTL, in seconds) to cache domain-specific configuration data.
# This has no effect unless `[domain_config] caching` is enabled. (integer
# value)
#cache_time = 300


[endpoint_filter]

#
# From keystone
#

# Entry point for the endpoint filter driver in the `keystone.endpoint_filter`
# namespace. Only a `sql` option is provided by keystone, so there is no reason
# to set this unless you are providing a custom entry point. (string value)
#driver = sql

# This controls keystone's behavior if the configured endpoint filters do not
# result in any endpoints for a user + project pair (and therefore a
# potentially empty service catalog). If set to true, keystone will return the
# entire service catalog. If set to false, keystone will return an empty
# service catalog. (boolean value)
#return_all_endpoints_if_no_filter = true


[endpoint_policy]

#
# From keystone
#

# Entry point for the endpoint policy driver in the `keystone.endpoint_policy`
# namespace. Only a `sql` driver is provided by keystone, so there is no reason
# to set this unless you are providing a custom entry point. (string value)
#driver = sql


[eventlet_server]

#
# From keystone
#

# DEPRECATED: The IP address of the network interface for the public service to
# listen on. (host address value)
# Deprecated group/name - [DEFAULT]/bind_host
# Deprecated group/name - [DEFAULT]/public_bind_host
# This option is deprecated for removal since K.
# Its value may be silently ignored in the future.
# Reason: Support for running keystone under eventlet has been removed in the
# Newton release. These options remain for backwards compatibility because they
# are used for URL substitutions.
#public_bind_host = 0.0.0.0

# DEPRECATED: The port number for the public service to listen on. (port value)
# Minimum value: 0
# Maximum value: 65535
# Deprecated group/name - [DEFAULT]/public_port
# This option is deprecated for removal since K.
# Its value may be silently ignored in the future.
# Reason: Support for running keystone under eventlet has been removed in the
# Newton release. These options remain for backwards compatibility because they
# are used for URL substitutions.
#public_port = 5000

# DEPRECATED: The IP address of the network interface for the admin service to
# listen on. (host address value)
# Deprecated group/name - [DEFAULT]/bind_host
# Deprecated group/name - [DEFAULT]/admin_bind_host
# This option is deprecated for removal since K.
# Its value may be silently ignored in the future.
# Reason: Support for running keystone under eventlet has been removed in the
# Newton release. These options remain for backwards compatibility because they
# are used for URL substitutions.
#admin_bind_host = 0.0.0.0

# DEPRECATED: The port number for the admin service to listen on. (port value)
# Minimum value: 0
# Maximum value: 65535
# Deprecated group/name - [DEFAULT]/admin_port
# This option is deprecated for removal since K.
# Its value may be silently ignored in the future.
# Reason: Support for running keystone under eventlet has been removed in the
# Newton release. These options remain for backwards compatibility because they
# are used for URL substitutions.
#admin_port = 35357


[federation]

#
# From keystone
#

# Entry point for the federation backend driver in the `keystone.federation`
# namespace. Keystone only provides a `sql` driver, so there is no reason to
# set this option unless you are providing a custom entry point. (string value)
#driver = sql

# Prefix to use when filtering environment variable names for federated
# assertions. Matched variables are passed into the federated mapping engine.
# (string value)
#assertion_prefix =

# Default value for all protocols to be used to obtain the entity ID of the
# Identity Provider from the environment. For `mod_shib`, this would be `Shib-
# Identity-Provider`. For `mod_auth_openidc`, this could be `HTTP_OIDC_ISS`.
# For `mod_auth_mellon`, this could be `MELLON_IDP`. This can be overridden on
# a per-protocol basis by providing a `remote_id_attribute` to the federation
# protocol using the API. (string value)
#remote_id_attribute = <None>

# DEPRECATED: An arbitrary domain name that is reserved to allow federated
# ephemeral users to have a domain concept. Note that an admin will not be able
# to create a domain with this name or update an existing domain to this name.
# You are not advised to change this value unless you really have to. (string
# value)
# This option is deprecated for removal since T.
# Its value may be silently ignored in the future.
# Reason: This option has been superseded by ephemeral users existing in the
# domain of their identity provider.
#federated_domain_name = Federated

# A list of trusted dashboard hosts. Before accepting a Single Sign-On request
# to return a token, the origin host must be a member of this list. This
# configuration option may be repeated for multiple values. You must set this
# in order to use web-based SSO flows. For example:
# trusted_dashboard=https://acme.example.com/auth/websso
# trusted_dashboard=https://beta.example.com/auth/websso (multi valued)
#trusted_dashboard =

# Absolute path to an HTML file used as a Single Sign-On callback handler. This
# page is expected to redirect the user from keystone back to a trusted
# dashboard host, by form encoding a token in a POST request. Keystone's
# default value should be sufficient for most deployments. (string value)
#sso_callback_template = /etc/keystone/sso_callback_template.html

# Toggle for federation caching. This has no effect unless global caching is
# enabled. There is typically no reason to disable this. (boolean value)
#caching = true

# Default time in minutes for the validity of group memberships carried over
# from a mapping. Default is 0, which means disabled. (integer value)
#default_authorization_ttl = 0


[fernet_receipts]

#
# From keystone
#

# Directory containing Fernet receipt keys. This directory must exist before
# using `keystone-manage fernet_setup` for the first time, must be writable by
# the user running `keystone-manage fernet_setup` or `keystone-manage
# fernet_rotate`, and of course must be readable by keystone's server process.
# The repository may contain keys in one of three states: a single staged key
# (always index 0) used for receipt validation, a single primary key (always
# the highest index) used for receipt creation and validation, and any number
# of secondary keys (all other index values) used for receipt validation. With
# multiple keystone nodes, each node must share the same key repository
# contents, with the exception of the staged key (index 0). It is safe to run
# `keystone-manage fernet_rotate` once on any one node to promote a staged key
# (index 0) to be the new primary (incremented from the previous highest
# index), and produce a new staged key (a new key with index 0); the resulting
# repository can then be atomically replicated to other nodes without any risk
# of race conditions (for example, it is safe to run `keystone-manage
# fernet_rotate` on host A, wait any amount of time, create a tarball of the
# directory on host A, unpack it on host B to a temporary location, and
# atomically move (`mv`) the directory into place on host B). Running
# `keystone-manage fernet_rotate` *twice* on a key repository without syncing
# other nodes will result in receipts that can not be validated by all nodes.
# (string value)
#key_repository = /etc/keystone/fernet-keys/

# This controls how many keys are held in rotation by `keystone-manage
# fernet_rotate` before they are discarded. The default value of 3 means that
# keystone will maintain one staged key (always index 0), one primary key (the
# highest numerical index), and one secondary key (every other index).
# Increasing this value means that additional secondary keys will be kept in
# the rotation. (integer value)
# Minimum value: 1
#max_active_keys = 3


[fernet_tokens]

#
# From keystone
#

# Directory containing Fernet token keys. This directory must exist before
# using `keystone-manage fernet_setup` for the first time, must be writable by
# the user running `keystone-manage fernet_setup` or `keystone-manage
# fernet_rotate`, and of course must be readable by keystone's server process.
# The repository may contain keys in one of three states: a single staged key
# (always index 0) used for token validation, a single primary key (always the
# highest index) used for token creation and validation, and any number of
# secondary keys (all other index values) used for token validation. With
# multiple keystone nodes, each node must share the same key repository
# contents, with the exception of the staged key (index 0). It is safe to run
# `keystone-manage fernet_rotate` once on any one node to promote a staged key
# (index 0) to be the new primary (incremented from the previous highest
# index), and produce a new staged key (a new key with index 0); the resulting
# repository can then be atomically replicated to other nodes without any risk
# of race conditions (for example, it is safe to run `keystone-manage
# fernet_rotate` on host A, wait any amount of time, create a tarball of the
# directory on host A, unpack it on host B to a temporary location, and
# atomically move (`mv`) the directory into place on host B). Running
# `keystone-manage fernet_rotate` *twice* on a key repository without syncing
# other nodes will result in tokens that can not be validated by all nodes.
# (string value)
#key_repository = /etc/keystone/fernet-keys/

# This controls how many keys are held in rotation by `keystone-manage
# fernet_rotate` before they are discarded. The default value of 3 means that
# keystone will maintain one staged key (always index 0), one primary key (the
# highest numerical index), and one secondary key (every other index).
# Increasing this value means that additional secondary keys will be kept in
# the rotation. (integer value)
# Minimum value: 1
#max_active_keys = 3


[healthcheck]

#
# From oslo.middleware
#

# DEPRECATED: The path to respond to healtcheck requests on. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
#path = /healthcheck

# Show more detailed information as part of the response. Security note:
# Enabling this option may expose sensitive details about the service being
# monitored. Be sure to verify that it will not violate your security policies.
# (boolean value)
#detailed = false

# Additional backends that can perform health checks and report that
# information back as part of a request. (list value)
#backends =

# Check the presence of a file to determine if an application is running on a
# port. Used by DisableByFileHealthcheck plugin. (string value)
#disable_by_file_path = <None>

# Check the presence of a file based on a port to determine if an application
# is running on a port. Expects a "port:path" list of strings. Used by
# DisableByFilesPortsHealthcheck plugin. (list value)
#disable_by_file_paths =


[identity]

#
# From keystone
#

# This references the domain to use for all Identity API v2 requests (which are
# not aware of domains). A domain with this ID can optionally be created for
# you by `keystone-manage bootstrap`. The domain referenced by this ID cannot
# be deleted on the v3 API, to prevent accidentally breaking the v2 API. There
# is nothing special about this domain, other than the fact that it must exist
# to order to maintain support for your v2 clients. There is typically no
# reason to change this value. (string value)
#default_domain_id = default

# A subset (or all) of domains can have their own identity driver, each with
# their own partial configuration options, stored in either the resource
# backend or in a file in a domain configuration directory (depending on the
# setting of `[identity] domain_configurations_from_database`). Only values
# specific to the domain need to be specified in this manner. This feature is
# disabled by default, but may be enabled by default in a future release; set
# to true to enable. (boolean value)
#domain_specific_drivers_enabled = false

# By default, domain-specific configuration data is read from files in the
# directory identified by `[identity] domain_config_dir`. Enabling this
# configuration option allows you to instead manage domain-specific
# configurations through the API, which are then persisted in the backend
# (typically, a SQL database), rather than using configuration files on disk.
# (boolean value)
#domain_configurations_from_database = false

# Absolute path where keystone should locate domain-specific `[identity]`
# configuration files. This option has no effect unless `[identity]
# domain_specific_drivers_enabled` is set to true. There is typically no reason
# to change this value. (string value)
#domain_config_dir = /etc/keystone/domains

# Entry point for the identity backend driver in the `keystone.identity`
# namespace. Keystone provides a `sql` and `ldap` driver. This option is also
# used as the default driver selection (along with the other configuration
# variables in this section) in the event that `[identity]
# domain_specific_drivers_enabled` is enabled, but no applicable domain-
# specific configuration is defined for the domain in question. Unless your
# deployment primarily relies on `ldap` AND is not using domain-specific
# configuration, you should typically leave this set to `sql`. (string value)
#driver = sql

# Toggle for identity caching. This has no effect unless global caching is
# enabled. There is typically no reason to disable this. (boolean value)
#caching = true

# Time to cache identity data (in seconds). This has no effect unless global
# and identity caching are enabled. (integer value)
#cache_time = 600

# Maximum allowed length for user passwords. Decrease this value to improve
# performance. Changing this value does not effect existing passwords. This
# value can also be overridden by certain hashing algorithms maximum allowed
# length which takes precedence over the configured value.  The bcrypt
# max_password_length is 72 bytes. (integer value)
# Maximum value: 4096
#max_password_length = 4096

# Maximum number of entities that will be returned in an identity collection.
# (integer value)
#list_limit = <None>

# The password hashing algorithm to use for passwords stored within keystone.
# (string value)
# Possible values:
# bcrypt - <No description provided>
# scrypt - <No description provided>
# pbkdf2_sha512 - <No description provided>
#password_hash_algorithm = bcrypt

# This option represents a trade off between security and performance. Higher
# values lead to slower performance, but higher security. Changing this option
# will only affect newly created passwords as existing password hashes already
# have a fixed number of rounds applied, so it is safe to tune this option in a
# running cluster.  The default for bcrypt is 12, must be between 4 and 31,
# inclusive.  The default for scrypt is 16, must be within `range(1,32)`.  The
# default for pbkdf_sha512 is 60000, must be within `range(1,1<<32)`  WARNING:
# If using scrypt, increasing this value increases BOTH time AND memory
# requirements to hash a password. (integer value)
#password_hash_rounds = <None>

# Optional block size to pass to scrypt hash function (the `r` parameter).
# Useful for tuning scrypt to optimal performance for your CPU architecture.
# This option is only used when the `password_hash_algorithm` option is set to
# `scrypt`. Defaults to 8. (integer value)
#scrypt_block_size = <None>

# Optional parallelism to pass to scrypt hash function (the `p` parameter).
# This option is only used when the `password_hash_algorithm` option is set to
# `scrypt`. Defaults to 1. (integer value)
#scrypt_parallelism = <None>

# Number of bytes to use in scrypt and pbkfd2_sha512 hashing salt.  Default for
# scrypt is 16 bytes. Default for pbkfd2_sha512 is 16 bytes.  Limited to a
# maximum of 96 bytes due to the size of the column used to store password
# hashes. (integer value)
# Minimum value: 0
# Maximum value: 96
#salt_bytesize = <None>


[identity_mapping]

#
# From keystone
#

# Entry point for the identity mapping backend driver in the
# `keystone.identity.id_mapping` namespace. Keystone only provides a `sql`
# driver, so there is no reason to change this unless you are providing a
# custom entry point. (string value)
#driver = sql

# Entry point for the public ID generator for user and group entities in the
# `keystone.identity.id_generator` namespace. The Keystone identity mapper only
# supports generators that produce 64 bytes or less. Keystone only provides a
# `sha256` entry point, so there is no reason to change this value unless
# you're providing a custom entry point. (string value)
#generator = sha256

# The format of user and group IDs changed in Juno for backends that do not
# generate UUIDs (for example, LDAP), with keystone providing a hash mapping to
# the underlying attribute in LDAP. By default this mapping is disabled, which
# ensures that existing IDs will not change. Even when the mapping is enabled
# by using domain-specific drivers (`[identity]
# domain_specific_drivers_enabled`), any users and groups from the default
# domain being handled by LDAP will still not be mapped to ensure their IDs
# remain backward compatible. Setting this value to false will enable the new
# mapping for all backends, including the default LDAP driver. It is only
# guaranteed to be safe to enable this option if you do not already have
# assignments for users and groups from the default LDAP domain, and you
# consider it to be acceptable for Keystone to provide the different IDs to
# clients than it did previously (existing IDs in the API will suddenly
# change). Typically this means that the only time you can set this value to
# false is when configuring a fresh installation, although that is the
# recommended value. (boolean value)
#backward_compatible_ids = true


[jwt_tokens]

#
# From keystone
#

# Directory containing public keys for validating JWS token signatures. This
# directory must exist in order for keystone's server process to start. It must
# also be readable by keystone's server process. It must contain at least one
# public key that corresponds to a private key in `keystone.conf [jwt_tokens]
# jws_private_key_repository`. This option is only applicable in deployments
# issuing JWS tokens and setting `keystone.conf [token] provider = jws`.
# (string value)
#jws_public_key_repository = /etc/keystone/jws-keys/public

# Directory containing private keys for signing JWS tokens. This directory must
# exist in order for keystone's server process to start. It must also be
# readable by keystone's server process. It must contain at least one private
# key that corresponds to a public key in `keystone.conf [jwt_tokens]
# jws_public_key_repository`. In the event there are multiple private keys in
# this directory, keystone will use a key named `private.pem` to sign tokens.
# In the future, keystone may support the ability to sign tokens with multiple
# private keys. For now, only a key named `private.pem` within this directory
# is required to issue JWS tokens. This option is only applicable in
# deployments issuing JWS tokens and setting `keystone.conf [token] provider =
# jws`. (string value)
#jws_private_key_repository = /etc/keystone/jws-keys/private


[ldap]

#
# From keystone
#

# URL(s) for connecting to the LDAP server. Multiple LDAP URLs may be specified
# as a comma separated string. The first URL to successfully bind is used for
# the connection. (string value)
#url = ldap://localhost

# Randomize the order of URLs in each keystone process. This makes the failure
# behavior more gradual, since if the first server is down, a process/thread
# will wait for the specified timeout before attempting a connection to a
# server further down the list. This defaults to False, for backward
# compatibility. (boolean value)
#randomize_urls = false

# The user name of the administrator bind DN to use when querying the LDAP
# server, if your LDAP server requires it. (string value)
#user = <None>

# The password of the administrator bind DN to use when querying the LDAP
# server, if your LDAP server requires it. (string value)
#password = <None>

# The default LDAP server suffix to use, if a DN is not defined via either
# `[ldap] user_tree_dn` or `[ldap] group_tree_dn`. (string value)
#suffix = cn=example,cn=com

# The search scope which defines how deep to search within the search base. A
# value of `one` (representing `oneLevel` or `singleLevel`) indicates a search
# of objects immediately below to the base object, but does not include the
# base object itself. A value of `sub` (representing `subtree` or
# `wholeSubtree`) indicates a search of both the base object itself and the
# entire subtree below it. (string value)
# Possible values:
# one - <No description provided>
# sub - <No description provided>
#query_scope = one

# Defines the maximum number of results per page that keystone should request
# from the LDAP server when listing objects. A value of zero (`0`) disables
# paging. (integer value)
# Minimum value: 0
#page_size = 0

# The LDAP dereferencing option to use for queries involving aliases. A value
# of `default` falls back to using default dereferencing behavior configured by
# your `ldap.conf`. A value of `never` prevents aliases from being dereferenced
# at all. A value of `searching` dereferences aliases only after name
# resolution. A value of `finding` dereferences aliases only during name
# resolution. A value of `always` dereferences aliases in all cases. (string
# value)
# Possible values:
# never - <No description provided>
# searching - <No description provided>
# always - <No description provided>
# finding - <No description provided>
# default - <No description provided>
#alias_dereferencing = default

# Sets the LDAP debugging level for LDAP calls. A value of 0 means that
# debugging is not enabled. This value is a bitmask, consult your LDAP
# documentation for possible values. (integer value)
# Minimum value: -1
#debug_level = <None>

# Sets keystone's referral chasing behavior across directory partitions. If
# left unset, the system's default behavior will be used. (boolean value)
#chase_referrals = <None>

# The search base to use for users. Defaults to `ou=Users` with the `[ldap]
# suffix` appended to it. (string value)
#user_tree_dn = <None>

# The LDAP search filter to use for users. (string value)
#user_filter = <None>

# The LDAP object class to use for users. (string value)
#user_objectclass = inetOrgPerson

# The LDAP attribute mapped to user IDs in keystone. This must NOT be a
# multivalued attribute. User IDs are expected to be globally unique across
# keystone domains and URL-safe. (string value)
#user_id_attribute = cn

# The LDAP attribute mapped to user names in keystone. User names are expected
# to be unique only within a keystone domain and are not expected to be URL-
# safe. (string value)
#user_name_attribute = sn

# The LDAP attribute mapped to user descriptions in keystone. (string value)
#user_description_attribute = description

# The LDAP attribute mapped to user emails in keystone. (string value)
#user_mail_attribute = mail

# The LDAP attribute mapped to user passwords in keystone. (string value)
#user_pass_attribute = userPassword

# The LDAP attribute mapped to the user enabled attribute in keystone. If
# setting this option to `userAccountControl`, then you may be interested in
# setting `[ldap] user_enabled_mask` and `[ldap] user_enabled_default` as well.
# (string value)
#user_enabled_attribute = enabled

# Logically negate the boolean value of the enabled attribute obtained from the
# LDAP server. Some LDAP servers use a boolean lock attribute where "true"
# means an account is disabled. Setting `[ldap] user_enabled_invert = true`
# will allow these lock attributes to be used. This option will have no effect
# if either the `[ldap] user_enabled_mask` or `[ldap] user_enabled_emulation`
# options are in use. (boolean value)
#user_enabled_invert = false

# Bitmask integer to select which bit indicates the enabled value if the LDAP
# server represents "enabled" as a bit on an integer rather than as a discrete
# boolean. A value of `0` indicates that the mask is not used. If this is not
# set to `0` the typical value is `2`. This is typically used when `[ldap]
# user_enabled_attribute = userAccountControl`. Setting this option causes
# keystone to ignore the value of `[ldap] user_enabled_invert`. (integer value)
# Minimum value: 0
#user_enabled_mask = 0

# The default value to enable users. This should match an appropriate integer
# value if the LDAP server uses non-boolean (bitmask) values to indicate if a
# user is enabled or disabled. If this is not set to `True`, then the typical
# value is `512`. This is typically used when `[ldap] user_enabled_attribute =
# userAccountControl`. (string value)
#user_enabled_default = True

# List of user attributes to ignore on create and update, or whether a specific
# user attribute should be filtered for list or show user. (list value)
#user_attribute_ignore = default_project_id

# The LDAP attribute mapped to a user's default_project_id in keystone. This is
# most commonly used when keystone has write access to LDAP. (string value)
#user_default_project_id_attribute = <None>

# If enabled, keystone uses an alternative method to determine if a user is
# enabled or not by checking if they are a member of the group defined by the
# `[ldap] user_enabled_emulation_dn` option. Enabling this option causes
# keystone to ignore the value of `[ldap] user_enabled_invert`. (boolean value)
#user_enabled_emulation = false

# DN of the group entry to hold enabled users when using enabled emulation.
# Setting this option has no effect unless `[ldap] user_enabled_emulation` is
# also enabled. (string value)
#user_enabled_emulation_dn = <None>

# Use the `[ldap] group_member_attribute` and `[ldap] group_objectclass`
# settings to determine membership in the emulated enabled group. Enabling this
# option has no effect unless `[ldap] user_enabled_emulation` is also enabled.
# (boolean value)
#user_enabled_emulation_use_group_config = false

# A list of LDAP attribute to keystone user attribute pairs used for mapping
# additional attributes to users in keystone. The expected format is
# `<ldap_attr>:<user_attr>`, where `ldap_attr` is the attribute in the LDAP
# object and `user_attr` is the attribute which should appear in the identity
# API. (list value)
#user_additional_attribute_mapping =

# The search base to use for groups. Defaults to `ou=UserGroups` with the
# `[ldap] suffix` appended to it. (string value)
#group_tree_dn = <None>

# The LDAP search filter to use for groups. (string value)
#group_filter = <None>

# The LDAP object class to use for groups. If setting this option to
# `posixGroup`, you may also be interested in enabling the `[ldap]
# group_members_are_ids` option. (string value)
#group_objectclass = groupOfNames

# The LDAP attribute mapped to group IDs in keystone. This must NOT be a
# multivalued attribute. Group IDs are expected to be globally unique across
# keystone domains and URL-safe. (string value)
#group_id_attribute = cn

# The LDAP attribute mapped to group names in keystone. Group names are
# expected to be unique only within a keystone domain and are not expected to
# be URL-safe. (string value)
#group_name_attribute = ou

# The LDAP attribute used to indicate that a user is a member of the group.
# (string value)
#group_member_attribute = member

# Enable this option if the members of the group object class are keystone user
# IDs rather than LDAP DNs. This is the case when using `posixGroup` as the
# group object class in Open Directory. (boolean value)
#group_members_are_ids = false

# The LDAP attribute mapped to group descriptions in keystone. (string value)
#group_desc_attribute = description

# List of group attributes to ignore on create and update. or whether a
# specific group attribute should be filtered for list or show group. (list
# value)
#group_attribute_ignore =

# A list of LDAP attribute to keystone group attribute pairs used for mapping
# additional attributes to groups in keystone. The expected format is
# `<ldap_attr>:<group_attr>`, where `ldap_attr` is the attribute in the LDAP
# object and `group_attr` is the attribute which should appear in the identity
# API. (list value)
#group_additional_attribute_mapping =

# If enabled, group queries will use Active Directory specific filters for
# nested groups. (boolean value)
#group_ad_nesting = false

# An absolute path to a CA certificate file to use when communicating with LDAP
# servers. This option will take precedence over `[ldap] tls_cacertdir`, so
# there is no reason to set both. (string value)
#tls_cacertfile = <None>

# An absolute path to a CA certificate directory to use when communicating with
# LDAP servers. There is no reason to set this option if you've also set
# `[ldap] tls_cacertfile`. (string value)
#tls_cacertdir = <None>

# Enable TLS when communicating with LDAP servers. You should also set the
# `[ldap] tls_cacertfile` and `[ldap] tls_cacertdir` options when using this
# option. Do not set this option if you are using LDAP over SSL (LDAPS) instead
# of TLS. (boolean value)
#use_tls = false

# Specifies which checks to perform against client certificates on incoming TLS
# sessions. If set to `demand`, then a certificate will always be requested and
# required from the LDAP server. If set to `allow`, then a certificate will
# always be requested but not required from the LDAP server. If set to `never`,
# then a certificate will never be requested. (string value)
# Possible values:
# demand - <No description provided>
# never - <No description provided>
# allow - <No description provided>
#tls_req_cert = demand

# The connection timeout to use with the LDAP server. A value of `-1` means
# that connections will never timeout. (integer value)
# Minimum value: -1
#connection_timeout = -1

# Enable LDAP connection pooling for queries to the LDAP server. There is
# typically no reason to disable this. (boolean value)
#use_pool = true

# The size of the LDAP connection pool. This option has no effect unless
# `[ldap] use_pool` is also enabled. (integer value)
# Minimum value: 1
#pool_size = 10

# The maximum number of times to attempt connecting to the LDAP server before
# aborting. A value of one makes only one connection attempt. This option has
# no effect unless `[ldap] use_pool` is also enabled. (integer value)
# Minimum value: 1
#pool_retry_max = 3

# The number of seconds to wait before attempting to reconnect to the LDAP
# server. This option has no effect unless `[ldap] use_pool` is also enabled.
# (floating point value)
#pool_retry_delay = 0.1

# The connection timeout to use when pooling LDAP connections. A value of `-1`
# means that connections will never timeout. This option has no effect unless
# `[ldap] use_pool` is also enabled. (integer value)
# Minimum value: -1
#pool_connection_timeout = -1

# The maximum connection lifetime to the LDAP server in seconds. When this
# lifetime is exceeded, the connection will be unbound and removed from the
# connection pool. This option has no effect unless `[ldap] use_pool` is also
# enabled. (integer value)
# Minimum value: 1
#pool_connection_lifetime = 600

# Enable LDAP connection pooling for end user authentication. There is
# typically no reason to disable this. (boolean value)
#use_auth_pool = true

# The size of the connection pool to use for end user authentication. This
# option has no effect unless `[ldap] use_auth_pool` is also enabled. (integer
# value)
# Minimum value: 1
#auth_pool_size = 100

# The maximum end user authentication connection lifetime to the LDAP server in
# seconds. When this lifetime is exceeded, the connection will be unbound and
# removed from the connection pool. This option has no effect unless `[ldap]
# use_auth_pool` is also enabled. (integer value)
# Minimum value: 1
#auth_pool_connection_lifetime = 60


[memcache]

#
# From keystone
#

# DEPRECATED: Number of seconds memcached server is considered dead before it
# is tried again. This is used by the key value store system. (integer value)
# This option is deprecated for removal since Y.
# Its value may be silently ignored in the future.
# Reason: This option has no effect. Configure ``keystone.conf [cache]
# memcache_dead_retry`` option to set the dead_retry of memcached instead.
#dead_retry = 300

# DEPRECATED: Timeout in seconds for every call to a server. This is used by
# the key value store system. (integer value)
# This option is deprecated for removal since T.
# Its value may be silently ignored in the future.
# Reason: This option has no effect. Configure ``keystone.conf [cache]
# memcache_socket_timeout`` option to set the socket_timeout of memcached
# instead.
#socket_timeout = 3

# DEPRECATED: Max total number of open connections to every memcached server.
# This is used by the key value store system. (integer value)
# This option is deprecated for removal since Y.
# Its value may be silently ignored in the future.
# Reason: This option has no effect. Configure ``keystone.conf [cache]
# memcache_pool_maxsize`` option to set the pool_maxsize of memcached instead.
#pool_maxsize = 10

# DEPRECATED: Number of seconds a connection to memcached is held unused in the
# pool before it is closed. This is used by the key value store system.
# (integer value)
# This option is deprecated for removal since Y.
# Its value may be silently ignored in the future.
# Reason: This option has no effect. Configure ``keystone.conf [cache]
# memcache_pool_unused_timeout`` option to set the pool_unused_timeout of
# memcached instead.
#pool_unused_timeout = 60

# DEPRECATED: Number of seconds that an operation will wait to get a memcache
# client connection. This is used by the key value store system. (integer
# value)
# This option is deprecated for removal since Y.
# Its value may be silently ignored in the future.
# Reason: This option has no effect. Configure ``keystone.conf [cache]
# memcache_pool_connection_get_timeout`` option to set the
# connection_get_timeout of memcached instead.
#pool_connection_get_timeout = 10


[oauth1]

#
# From keystone
#

# Entry point for the OAuth backend driver in the `keystone.oauth1` namespace.
# Typically, there is no reason to set this option unless you are providing a
# custom entry point. (string value)
#driver = sql

# Number of seconds for the OAuth Request Token to remain valid after being
# created. This is the amount of time the user has to authorize the token.
# Setting this option to zero means that request tokens will last forever.
# (integer value)
# Minimum value: 0
#request_token_duration = 28800

# Number of seconds for the OAuth Access Token to remain valid after being
# created. This is the amount of time the consumer has to interact with the
# service provider (which is typically keystone). Setting this option to zero
# means that access tokens will last forever. (integer value)
# Minimum value: 0
#access_token_duration = 86400


[oslo_messaging_amqp]

#
# From oslo.messaging
#

# Name for the AMQP container. must be globally unique. Defaults to a generated
# UUID (string value)
#container_name = <None>

# Timeout for inactive connections (in seconds) (integer value)
#idle_timeout = 0

# Debug: dump AMQP frames to stdout (boolean value)
#trace = false

# Attempt to connect via SSL. If no other ssl-related parameters are given, it
# will use the system's CA-bundle to verify the server's certificate. (boolean
# value)
#ssl = false

# CA certificate PEM file used to verify the server's certificate (string
# value)
#ssl_ca_file =

# Self-identifying certificate PEM file for client authentication (string
# value)
#ssl_cert_file =

# Private key PEM file used to sign ssl_cert_file certificate (optional)
# (string value)
#ssl_key_file =

# Password for decrypting ssl_key_file (if encrypted) (string value)
#ssl_key_password = <None>

# By default SSL checks that the name in the server's certificate matches the
# hostname in the transport_url. In some configurations it may be preferable to
# use the virtual hostname instead, for example if the server uses the Server
# Name Indication TLS extension (rfc6066) to provide a certificate per virtual
# host. Set ssl_verify_vhost to True if the server's SSL certificate uses the
# virtual host name instead of the DNS name. (boolean value)
#ssl_verify_vhost = false

# Space separated list of acceptable SASL mechanisms (string value)
#sasl_mechanisms =

# Path to directory that contains the SASL configuration (string value)
#sasl_config_dir =

# Name of configuration file (without .conf suffix) (string value)
#sasl_config_name =

# SASL realm to use if no realm present in username (string value)
#sasl_default_realm =

# Seconds to pause before attempting to re-connect. (integer value)
# Minimum value: 1
#connection_retry_interval = 1

# Increase the connection_retry_interval by this many seconds after each
# unsuccessful failover attempt. (integer value)
# Minimum value: 0
#connection_retry_backoff = 2

# Maximum limit for connection_retry_interval + connection_retry_backoff
# (integer value)
# Minimum value: 1
#connection_retry_interval_max = 30

# Time to pause between re-connecting an AMQP 1.0 link that failed due to a
# recoverable error. (integer value)
# Minimum value: 1
#link_retry_delay = 10

# The maximum number of attempts to re-send a reply message which failed due to
# a recoverable error. (integer value)
# Minimum value: -1
#default_reply_retry = 0

# The deadline for an rpc reply message delivery. (integer value)
# Minimum value: 5
#default_reply_timeout = 30

# The deadline for an rpc cast or call message delivery. Only used when caller
# does not provide a timeout expiry. (integer value)
# Minimum value: 5
#default_send_timeout = 30

# The deadline for a sent notification message delivery. Only used when caller
# does not provide a timeout expiry. (integer value)
# Minimum value: 5
#default_notify_timeout = 30

# The duration to schedule a purge of idle sender links. Detach link after
# expiry. (integer value)
# Minimum value: 1
#default_sender_link_timeout = 600

# Indicates the addressing mode used by the driver.
# Permitted values:
# 'legacy'   - use legacy non-routable addressing
# 'routable' - use routable addresses
# 'dynamic'  - use legacy addresses if the message bus does not support routing
# otherwise use routable addressing (string value)
#addressing_mode = dynamic

# Enable virtual host support for those message buses that do not natively
# support virtual hosting (such as qpidd). When set to true the virtual host
# name will be added to all message bus addresses, effectively creating a
# private 'subnet' per virtual host. Set to False if the message bus supports
# virtual hosting using the 'hostname' field in the AMQP 1.0 Open performative
# as the name of the virtual host. (boolean value)
#pseudo_vhost = true

# address prefix used when sending to a specific server (string value)
#server_request_prefix = exclusive

# address prefix used when broadcasting to all servers (string value)
#broadcast_prefix = broadcast

# address prefix when sending to any server in group (string value)
#group_request_prefix = unicast

# Address prefix for all generated RPC addresses (string value)
#rpc_address_prefix = openstack.org/om/rpc

# Address prefix for all generated Notification addresses (string value)
#notify_address_prefix = openstack.org/om/notify

# Appended to the address prefix when sending a fanout message. Used by the
# message bus to identify fanout messages. (string value)
#multicast_address = multicast

# Appended to the address prefix when sending to a particular RPC/Notification
# server. Used by the message bus to identify messages sent to a single
# destination. (string value)
#unicast_address = unicast

# Appended to the address prefix when sending to a group of consumers. Used by
# the message bus to identify messages that should be delivered in a round-
# robin fashion across consumers. (string value)
#anycast_address = anycast

# Exchange name used in notification addresses.
# Exchange name resolution precedence:
# Target.exchange if set
# else default_notification_exchange if set
# else control_exchange if set
# else 'notify' (string value)
#default_notification_exchange = <None>

# Exchange name used in RPC addresses.
# Exchange name resolution precedence:
# Target.exchange if set
# else default_rpc_exchange if set
# else control_exchange if set
# else 'rpc' (string value)
#default_rpc_exchange = <None>

# Window size for incoming RPC Reply messages. (integer value)
# Minimum value: 1
#reply_link_credit = 200

# Window size for incoming RPC Request messages (integer value)
# Minimum value: 1
#rpc_server_credit = 100

# Window size for incoming Notification messages (integer value)
# Minimum value: 1
#notify_server_credit = 100

# Send messages of this type pre-settled.
# Pre-settled messages will not receive acknowledgement
# from the peer. Note well: pre-settled messages may be
# silently discarded if the delivery fails.
# Permitted values:
# 'rpc-call' - send RPC Calls pre-settled
# 'rpc-reply'- send RPC Replies pre-settled
# 'rpc-cast' - Send RPC Casts pre-settled
# 'notify'   - Send Notifications pre-settled
#  (multi valued)
#pre_settled = rpc-cast
#pre_settled = rpc-reply


[oslo_messaging_kafka]

#
# From oslo.messaging
#

# Max fetch bytes of Kafka consumer (integer value)
#kafka_max_fetch_bytes = 1048576

# Default timeout(s) for Kafka consumers (floating point value)
#kafka_consumer_timeout = 1.0

# DEPRECATED: Pool Size for Kafka Consumers (integer value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Driver no longer uses connection pool.
#pool_size = 10

# DEPRECATED: The pool size limit for connections expiration policy (integer
# value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Driver no longer uses connection pool.
#conn_pool_min_size = 2

# DEPRECATED: The time-to-live in sec of idle connections in the pool (integer
# value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Driver no longer uses connection pool.
#conn_pool_ttl = 1200

# Group id for Kafka consumer. Consumers in one group will coordinate message
# consumption (string value)
#consumer_group = oslo_messaging_consumer

# Upper bound on the delay for KafkaProducer batching in seconds (floating
# point value)
#producer_batch_timeout = 0.0

# Size of batch for the producer async send (integer value)
#producer_batch_size = 16384

# The compression codec for all data generated by the producer. If not set,
# compression will not be used. Note that the allowed values of this depend on
# the kafka version (string value)
# Possible values:
# none - <No description provided>
# gzip - <No description provided>
# snappy - <No description provided>
# lz4 - <No description provided>
# zstd - <No description provided>
#compression_codec = none

# Enable asynchronous consumer commits (boolean value)
#enable_auto_commit = false

# The maximum number of records returned in a poll call (integer value)
#max_poll_records = 500

# Protocol used to communicate with brokers (string value)
# Possible values:
# PLAINTEXT - <No description provided>
# SASL_PLAINTEXT - <No description provided>
# SSL - <No description provided>
# SASL_SSL - <No description provided>
#security_protocol = PLAINTEXT

# Mechanism when security protocol is SASL (string value)
#sasl_mechanism = PLAIN

# CA certificate PEM file used to verify the server certificate (string value)
#ssl_cafile =

# Client certificate PEM file used for authentication. (string value)
#ssl_client_cert_file =

# Client key PEM file used for authentication. (string value)
#ssl_client_key_file =

# Client key password file used for authentication. (string value)
#ssl_client_key_password =


[oslo_messaging_notifications]

#
# From oslo.messaging
#

# The Drivers(s) to handle sending notifications. Possible values are
# messaging, messagingv2, routing, log, test, noop (multi valued)
# Deprecated group/name - [DEFAULT]/notification_driver
#driver =

# A URL representing the messaging driver to use for notifications. If not set,
# we fall back to the same configuration used for RPC. (string value)
# Deprecated group/name - [DEFAULT]/notification_transport_url
#transport_url = <None>

# AMQP topic used for OpenStack notifications. (list value)
# Deprecated group/name - [rpc_notifier2]/topics
# Deprecated group/name - [DEFAULT]/notification_topics
#topics = notifications

# The maximum number of attempts to re-send a notification message which failed
# to be delivered due to a recoverable error. 0 - No retry, -1 - indefinite
# (integer value)
#retry = -1


[oslo_messaging_rabbit]

#
# From oslo.messaging
#

# Use durable queues in AMQP. If rabbit_quorum_queue is enabled, queues will be
# durable and this value will be ignored. (boolean value)
#amqp_durable_queues = false

# Auto-delete queues in AMQP. (boolean value)
#amqp_auto_delete = false

# Connect over SSL. (boolean value)
# Deprecated group/name - [oslo_messaging_rabbit]/rabbit_use_ssl
#ssl = false

# SSL version to use (valid only if SSL enabled). Valid values are TLSv1 and
# SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may be available on some
# distributions. (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_version
#ssl_version =

# SSL key file (valid only if SSL enabled). (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_keyfile
#ssl_key_file =

# SSL cert file (valid only if SSL enabled). (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_certfile
#ssl_cert_file =

# SSL certification authority file (valid only if SSL enabled). (string value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_ssl_ca_certs
#ssl_ca_file =

# Run the health check heartbeat thread through a native python thread by
# default. If this option is equal to False then the health check heartbeat
# will inherit the execution model from the parent process. For example if the
# parent process has monkey patched the stdlib by using eventlet/greenlet then
# the heartbeat will be run through a green thread. (boolean value)
#heartbeat_in_pthread = true

# How long to wait (in seconds) before reconnecting in response to an AMQP
# consumer cancel notification. (floating point value)
# Minimum value: 0.0
# Maximum value: 4.5
#kombu_reconnect_delay = 1.0

# EXPERIMENTAL: Possible values are: gzip, bz2. If not set compression will not
# be used. This option may not be available in future versions. (string value)
#kombu_compression = <None>

# How long to wait a missing client before abandoning to send it its replies.
# This value should not be longer than rpc_response_timeout. (integer value)
# Deprecated group/name - [oslo_messaging_rabbit]/kombu_reconnect_timeout
#kombu_missing_consumer_retry_timeout = 60

# Determines how the next RabbitMQ node is chosen in case the one we are
# currently connected to becomes unavailable. Takes effect only if more than
# one RabbitMQ node is provided in config. (string value)
# Possible values:
# round-robin - <No description provided>
# shuffle - <No description provided>
#kombu_failover_strategy = round-robin

# The RabbitMQ login method. (string value)
# Possible values:
# PLAIN - <No description provided>
# AMQPLAIN - <No description provided>
# RABBIT-CR-DEMO - <No description provided>
#rabbit_login_method = AMQPLAIN

# How frequently to retry connecting with RabbitMQ. (integer value)
#rabbit_retry_interval = 1

# How long to backoff for between retries when connecting to RabbitMQ. (integer
# value)
#rabbit_retry_backoff = 2

# Maximum interval of RabbitMQ connection retries. Default is 30 seconds.
# (integer value)
#rabbit_interval_max = 30

# Try to use HA queues in RabbitMQ (x-ha-policy: all). If you change this
# option, you must wipe the RabbitMQ database. In RabbitMQ 3.0, queue mirroring
# is no longer controlled by the x-ha-policy argument when declaring a queue.
# If you just want to make sure that all queues (except those with auto-
# generated names) are mirrored across all nodes, run: "rabbitmqctl set_policy
# HA '^(?!amq\.).*' '{"ha-mode": "all"}' " (boolean value)
#rabbit_ha_queues = false

# Use quorum queues in RabbitMQ (x-queue-type: quorum). The quorum queue is a
# modern queue type for RabbitMQ implementing a durable, replicated FIFO queue
# based on the Raft consensus algorithm. It is available as of RabbitMQ 3.8.0.
# If set this option will conflict with the HA queues (``rabbit_ha_queues``)
# aka mirrored queues, in other words the HA queues should be disabled, quorum
# queues durable by default so the amqp_durable_queues opion is ignored when
# this option enabled. (boolean value)
#rabbit_quorum_queue = false

# Positive integer representing duration in seconds for queue TTL (x-expires).
# Queues which are unused for the duration of the TTL are automatically
# deleted. The parameter affects only reply and fanout queues. (integer value)
# Minimum value: 1
#rabbit_transient_queues_ttl = 1800

# Specifies the number of messages to prefetch. Setting to zero allows
# unlimited messages. (integer value)
#rabbit_qos_prefetch_count = 0

# Number of seconds after which the Rabbit broker is considered down if
# heartbeat's keep-alive fails (0 disables heartbeat). (integer value)
#heartbeat_timeout_threshold = 60

# How often times during the heartbeat_timeout_threshold we check the
# heartbeat. (integer value)
#heartbeat_rate = 2

# DEPRECATED: (DEPRECATED) Enable/Disable the RabbitMQ mandatory flag for
# direct send. The direct send is used as reply, so the MessageUndeliverable
# exception is raised in case the client queue does not
# exist.MessageUndeliverable exception will be used to loop for a timeout to
# lets a chance to sender to recover.This flag is deprecated and it will not be
# possible to deactivate this functionality anymore (boolean value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
# Reason: Mandatory flag no longer deactivable.
#direct_mandatory_flag = true

# Enable x-cancel-on-ha-failover flag so that rabbitmq server will cancel and
# notify consumerswhen queue is down (boolean value)
#enable_cancel_on_failover = false


[oslo_middleware]

#
# From oslo.middleware
#

# The maximum body size for each  request, in bytes. (integer value)
# Deprecated group/name - [DEFAULT]/osapi_max_request_body_size
# Deprecated group/name - [DEFAULT]/max_request_body_size
#max_request_body_size = 114688

# DEPRECATED: The HTTP Header that will be used to determine what the original
# request protocol scheme was, even if it was hidden by a SSL termination
# proxy. (string value)
# This option is deprecated for removal.
# Its value may be silently ignored in the future.
#secure_proxy_ssl_header = X-Forwarded-Proto

# Whether the application is behind a proxy or not. This determines if the
# middleware should parse the headers or not. (boolean value)
#enable_proxy_headers_parsing = false

# HTTP basic auth password file. (string value)
#http_basic_auth_user_file = /etc/htpasswd


[oslo_policy]

#
# From oslo.policy
#

# This option controls whether or not to enforce scope when evaluating
# policies. If ``True``, the scope of the token used in the request is compared
# to the ``scope_types`` of the policy being enforced. If the scopes do not
# match, an ``InvalidScope`` exception will be raised. If ``False``, a message
# will be logged informing operators that policies are being invoked with
# mismatching scope. (boolean value)
#enforce_scope = false

# This option controls whether or not to use old deprecated defaults when
# evaluating policies. If ``True``, the old deprecated defaults are not going
# to be evaluated. This means if any existing token is allowed for old defaults
# but is disallowed for new defaults, it will be disallowed. It is encouraged
# to enable this flag along with the ``enforce_scope`` flag so that you can get
# the benefits of new defaults and ``scope_type`` together. If ``False``, the
# deprecated policy check string is logically OR'd with the new policy check
# string, allowing for a graceful upgrade experience between releases with new
# policies, which is the default behavior. (boolean value)
#enforce_new_defaults = false

# The relative or absolute path of a file that maps roles to permissions for a
# given service. Relative paths must be specified in relation to the
# configuration file setting this option. (string value)
#policy_file = policy.yaml

# Default rule. Enforced when a requested rule is not found. (string value)
#policy_default_rule = default

# Directories where policy configuration files are stored. They can be relative
# to any directory in the search path defined by the config_dir option, or
# absolute paths. The file defined by policy_file must exist for these
# directories to be searched.  Missing or empty directories are ignored. (multi
# valued)
#policy_dirs = policy.d

# Content Type to send and receive data for REST based policy check (string
# value)
# Possible values:
# application/x-www-form-urlencoded - <No description provided>
# application/json - <No description provided>
#remote_content_type = application/x-www-form-urlencoded

# server identity verification for REST based policy check (boolean value)
#remote_ssl_verify_server_crt = false

# Absolute path to ca cert file for REST based policy check (string value)
#remote_ssl_ca_crt_file = <None>

# Absolute path to client cert for REST based policy check (string value)
#remote_ssl_client_crt_file = <None>

# Absolute path client key file REST based policy check (string value)
#remote_ssl_client_key_file = <None>


[policy]

#
# From keystone
#

# Entry point for the policy backend driver in the `keystone.policy` namespace.
# Supplied drivers are `rules` (which does not support any CRUD operations for
# the v3 policy API) and `sql`. Typically, there is no reason to set this
# option unless you are providing a custom entry point. (string value)
#driver = sql

# Maximum number of entities that will be returned in a policy collection.
# (integer value)
#list_limit = <None>


[profiler]

#
# From osprofiler
#

#
# Enable the profiling for all services on this node.
#
# Default value is False (fully disable the profiling feature).
#
# Possible values:
#
# * True: Enables the feature
# * False: Disables the feature. The profiling cannot be started via this
# project
#   operations. If the profiling is triggered by another project, this project
#   part will be empty.
#  (boolean value)
# Deprecated group/name - [profiler]/profiler_enabled
#enabled = false

#
# Enable SQL requests profiling in services.
#
# Default value is False (SQL requests won't be traced).
#
# Possible values:
#
# * True: Enables SQL requests profiling. Each SQL query will be part of the
#   trace and can the be analyzed by how much time was spent for that.
# * False: Disables SQL requests profiling. The spent time is only shown on a
#   higher level of operations. Single SQL queries cannot be analyzed this way.
#  (boolean value)
#trace_sqlalchemy = false

#
# Secret key(s) to use for encrypting context data for performance profiling.
#
# This string value should have the following format:
# <key1>[,<key2>,...<keyn>],
# where each key is some random string. A user who triggers the profiling via
# the REST API has to set one of these keys in the headers of the REST API call
# to include profiling results of this node for this particular project.
#
# Both "enabled" flag and "hmac_keys" config options should be set to enable
# profiling. Also, to generate correct profiling information across all
# services
# at least one key needs to be consistent between OpenStack projects. This
# ensures it can be used from client side to generate the trace, containing
# information from all possible resources.
#  (string value)
#hmac_keys = SECRET_KEY

#
# Connection string for a notifier backend.
#
# Default value is ``messaging://`` which sets the notifier to oslo_messaging.
#
# Examples of possible values:
#
# * ``messaging://`` - use oslo_messaging driver for sending spans.
# * ``redis://127.0.0.1:6379`` - use redis driver for sending spans.
# * ``mongodb://127.0.0.1:27017`` - use mongodb driver for sending spans.
# * ``elasticsearch://127.0.0.1:9200`` - use elasticsearch driver for sending
#   spans.
# * ``jaeger://127.0.0.1:6831`` - use jaeger tracing as driver for sending
# spans.
#  (string value)
#connection_string = messaging://

#
# Document type for notification indexing in elasticsearch.
#  (string value)
#es_doc_type = notification

#
# This parameter is a time value parameter (for example: es_scroll_time=2m),
# indicating for how long the nodes that participate in the search will
# maintain
# relevant resources in order to continue and support it.
#  (string value)
#es_scroll_time = 2m

#
# Elasticsearch splits large requests in batches. This parameter defines
# maximum size of each batch (for example: es_scroll_size=10000).
#  (integer value)
#es_scroll_size = 10000

#
# Redissentinel provides a timeout option on the connections.
# This parameter defines that timeout (for example: socket_timeout=0.1).
#  (floating point value)
#socket_timeout = 0.1

#
# Redissentinel uses a service name to identify a master redis service.
# This parameter defines the name (for example:
# ``sentinal_service_name=mymaster``).
#  (string value)
#sentinel_service_name = mymaster

#
# Enable filter traces that contain error/exception to a separated place.
#
# Default value is set to False.
#
# Possible values:
#
# * True: Enable filter traces that contain error/exception.
# * False: Disable the filter.
#  (boolean value)
#filter_error_trace = false


[receipt]

#
# From keystone
#

# The amount of time that a receipt should remain valid (in seconds). This
# value should always be very short, as it represents how long a user has to
# reattempt auth with the missing auth methods. (integer value)
# Minimum value: 0
# Maximum value: 86400
#expiration = 300

# Entry point for the receipt provider in the `keystone.receipt.provider`
# namespace. The receipt provider controls the receipt construction and
# validation operations. Keystone includes just the `fernet` receipt provider
# for now. `fernet` receipts do not need to be persisted at all, but require
# that you run `keystone-manage fernet_setup` (also see the `keystone-manage
# fernet_rotate` command). (string value)
#provider = fernet

# Toggle for caching receipt creation and validation data. This has no effect
# unless global caching is enabled, or if cache_on_issue is disabled as we only
# cache receipts on issue. (boolean value)
#caching = true

# The number of seconds to cache receipt creation and validation data. This has
# no effect unless both global and `[receipt] caching` are enabled. (integer
# value)
# Minimum value: 0
#cache_time = 300

# Enable storing issued receipt data to receipt validation cache so that first
# receipt validation doesn't actually cause full validation cycle. This option
# has no effect unless global caching and receipt caching are enabled. (boolean
# value)
#cache_on_issue = true


[resource]

#
# From keystone
#

# Entry point for the resource driver in the `keystone.resource` namespace.
# Only a `sql` driver is supplied by keystone. Unless you are writing
# proprietary drivers for keystone, you do not need to set this option. (string
# value)
#driver = sql

# Toggle for resource caching. This has no effect unless global caching is
# enabled. (boolean value)
# Deprecated group/name - [assignment]/caching
#caching = true

# Time to cache resource data in seconds. This has no effect unless global
# caching is enabled. (integer value)
# Deprecated group/name - [assignment]/cache_time
#cache_time = <None>

# Maximum number of entities that will be returned in a resource collection.
# (integer value)
# Deprecated group/name - [assignment]/list_limit
#list_limit = <None>

# Name of the domain that owns the `admin_project_name`. If left unset, then
# there is no admin project. `[resource] admin_project_name` must also be set
# to use this option. (string value)
#admin_project_domain_name = <None>

# This is a special project which represents cloud-level administrator
# privileges across services. Tokens scoped to this project will contain a true
# `is_admin_project` attribute to indicate to policy systems that the role
# assignments on that specific project should apply equally across every
# project. If left unset, then there is no admin project, and thus no explicit
# means of cross-project role assignments. `[resource]
# admin_project_domain_name` must also be set to use this option. (string
# value)
#admin_project_name = <None>

# This controls whether the names of projects are restricted from containing
# URL-reserved characters. If set to `new`, attempts to create or update a
# project with a URL-unsafe name will fail. If set to `strict`, attempts to
# scope a token with a URL-unsafe project name will fail, thereby forcing all
# project names to be updated to be URL-safe. (string value)
# Possible values:
# off - <No description provided>
# new - <No description provided>
# strict - <No description provided>
#project_name_url_safe = off

# This controls whether the names of domains are restricted from containing
# URL-reserved characters. If set to `new`, attempts to create or update a
# domain with a URL-unsafe name will fail. If set to `strict`, attempts to
# scope a token with a URL-unsafe domain name will fail, thereby forcing all
# domain names to be updated to be URL-safe. (string value)
# Possible values:
# off - <No description provided>
# new - <No description provided>
# strict - <No description provided>
#domain_name_url_safe = off


[revoke]

#
# From keystone
#

# Entry point for the token revocation backend driver in the `keystone.revoke`
# namespace. Keystone only provides a `sql` driver, so there is no reason to
# set this option unless you are providing a custom entry point. (string value)
#driver = sql

# The number of seconds after a token has expired before a corresponding
# revocation event may be purged from the backend. (integer value)
# Minimum value: 0
#expiration_buffer = 1800

# Toggle for revocation event caching. This has no effect unless global caching
# is enabled. (boolean value)
#caching = true

# Time to cache the revocation list and the revocation events (in seconds).
# This has no effect unless global and `[revoke] caching` are both enabled.
# (integer value)
# Deprecated group/name - [token]/revocation_cache_time
#cache_time = 3600


[role]

#
# From keystone
#

# Entry point for the role backend driver in the `keystone.role` namespace.
# Keystone only provides a `sql` driver, so there's no reason to change this
# unless you are providing a custom entry point. (string value)
#driver = <None>

# Toggle for role caching. This has no effect unless global caching is enabled.
# In a typical deployment, there is no reason to disable this. (boolean value)
#caching = true

# Time to cache role data, in seconds. This has no effect unless both global
# caching and `[role] caching` are enabled. (integer value)
#cache_time = <None>

# Maximum number of entities that will be returned in a role collection. This
# may be useful to tune if you have a large number of discrete roles in your
# deployment. (integer value)
#list_limit = <None>


[saml]

#
# From keystone
#

# Determines the lifetime for any SAML assertions generated by keystone, using
# `NotOnOrAfter` attributes. (integer value)
#assertion_expiration_time = 3600

# Name of, or absolute path to, the binary to be used for XML signing. Although
# only the XML Security Library (`xmlsec1`) is supported, it may have a non-
# standard name or path on your system. If keystone cannot find the binary
# itself, you may need to install the appropriate package, use this option to
# specify an absolute path, or adjust keystone's PATH environment variable.
# (string value)
#xmlsec1_binary = xmlsec1

# Absolute path to the public certificate file to use for SAML signing. The
# value cannot contain a comma (`,`). (string value)
#certfile = /etc/keystone/ssl/certs/signing_cert.pem

# Absolute path to the private key file to use for SAML signing. The value
# cannot contain a comma (`,`). (string value)
#keyfile = /etc/keystone/ssl/private/signing_key.pem

# This is the unique entity identifier of the identity provider (keystone) to
# use when generating SAML assertions. This value is required to generate
# identity provider metadata and must be a URI (a URL is recommended). For
# example: `https://keystone.example.com/v3/OS-FEDERATION/saml2/idp`. (uri
# value)
#idp_entity_id = <None>

# This is the single sign-on (SSO) service location of the identity provider
# which accepts HTTP POST requests. A value is required to generate identity
# provider metadata. For example: `https://keystone.example.com/v3/OS-
# FEDERATION/saml2/sso`. (uri value)
#idp_sso_endpoint = <None>

# This is the language used by the identity provider's organization. (string
# value)
#idp_lang = en

# This is the name of the identity provider's organization. (string value)
#idp_organization_name = SAML Identity Provider

# This is the name of the identity provider's organization to be displayed.
# (string value)
#idp_organization_display_name = OpenStack SAML Identity Provider

# This is the URL of the identity provider's organization. The URL referenced
# here should be useful to humans. (uri value)
#idp_organization_url = https://example.com/

# This is the company name of the identity provider's contact person. (string
# value)
#idp_contact_company = Example, Inc.

# This is the given name of the identity provider's contact person. (string
# value)
#idp_contact_name = SAML Identity Provider Support

# This is the surname of the identity provider's contact person. (string value)
#idp_contact_surname = Support

# This is the email address of the identity provider's contact person. (string
# value)
#idp_contact_email = support@example.com

# This is the telephone number of the identity provider's contact person.
# (string value)
#idp_contact_telephone = +1 800 555 0100

# This is the type of contact that best describes the identity provider's
# contact person. (string value)
# Possible values:
# technical - <No description provided>
# support - <No description provided>
# administrative - <No description provided>
# billing - <No description provided>
# other - <No description provided>
#idp_contact_type = other

# Absolute path to the identity provider metadata file. This file should be
# generated with the `keystone-manage saml_idp_metadata` command. There is
# typically no reason to change this value. (string value)
#idp_metadata_path = /etc/keystone/saml2_idp_metadata.xml

# The prefix of the RelayState SAML attribute to use when generating enhanced
# client and proxy (ECP) assertions. In a typical deployment, there is no
# reason to change this value. (string value)
#relay_state_prefix = ss:mem:


[security_compliance]

#
# From keystone
#

# The maximum number of days a user can go without authenticating before being
# considered "inactive" and automatically disabled (locked). This feature is
# disabled by default; set any value to enable it. This feature depends on the
# `sql` backend for the `[identity] driver`. When a user exceeds this threshold
# and is considered "inactive", the user's `enabled` attribute in the HTTP API
# may not match the value of the user's `enabled` column in the user table.
# (integer value)
# Minimum value: 1
#disable_user_account_days_inactive = <None>

# The maximum number of times that a user can fail to authenticate before the
# user account is locked for the number of seconds specified by
# `[security_compliance] lockout_duration`. This feature is disabled by
# default. If this feature is enabled and `[security_compliance]
# lockout_duration` is not set, then users may be locked out indefinitely until
# the user is explicitly enabled via the API. This feature depends on the `sql`
# backend for the `[identity] driver`. (integer value)
# Minimum value: 1
#lockout_failure_attempts = <None>

# The number of seconds a user account will be locked when the maximum number
# of failed authentication attempts (as specified by `[security_compliance]
# lockout_failure_attempts`) is exceeded. Setting this option will have no
# effect unless you also set `[security_compliance] lockout_failure_attempts`
# to a non-zero value. This feature depends on the `sql` backend for the
# `[identity] driver`. (integer value)
# Minimum value: 1
#lockout_duration = 1800

# The number of days for which a password will be considered valid before
# requiring it to be changed. This feature is disabled by default. If enabled,
# new password changes will have an expiration date, however existing passwords
# would not be impacted. This feature depends on the `sql` backend for the
# `[identity] driver`. (integer value)
# Minimum value: 1
#password_expires_days = <None>

# This controls the number of previous user password iterations to keep in
# history, in order to enforce that newly created passwords are unique. The
# total number which includes the new password should not be greater or equal
# to this value. Setting the value to zero (the default) disables this feature.
# Thus, to enable this feature, values must be greater than 0. This feature
# depends on the `sql` backend for the `[identity] driver`. (integer value)
# Minimum value: 0
#unique_last_password_count = 0

# The number of days that a password must be used before the user can change
# it. This prevents users from changing their passwords immediately in order to
# wipe out their password history and reuse an old password. This feature does
# not prevent administrators from manually resetting passwords. It is disabled
# by default and allows for immediate password changes. This feature depends on
# the `sql` backend for the `[identity] driver`. Note: If
# `[security_compliance] password_expires_days` is set, then the value for this
# option should be less than the `password_expires_days`. (integer value)
# Minimum value: 0
#minimum_password_age = 0

# The regular expression used to validate password strength requirements. By
# default, the regular expression will match any password. The following is an
# example of a pattern which requires at least 1 letter, 1 digit, and have a
# minimum length of 7 characters: ^(?=.*\\d)(?=.*[a-zA-Z]).{7,}$ This feature
# depends on the `sql` backend for the `[identity] driver`. (string value)
#password_regex = <None>

# Describe your password regular expression here in language for humans. If a
# password fails to match the regular expression, the contents of this
# configuration variable will be returned to users to explain why their
# requested password was insufficient. (string value)
#password_regex_description = <None>

# Enabling this option requires users to change their password when the user is
# created, or upon administrative reset. Before accessing any services,
# affected users will have to change their password. To ignore this requirement
# for specific users, such as service users, set the `options` attribute
# `ignore_change_password_upon_first_use` to `True` for the desired user via
# the update user API. This feature is disabled by default. This feature is
# only applicable with the `sql` backend for the `[identity] driver`. (boolean
# value)
#change_password_upon_first_use = false


[shadow_users]

#
# From keystone
#

# Entry point for the shadow users backend driver in the
# `keystone.identity.shadow_users` namespace. This driver is used for
# persisting local user references to externally-managed identities (via
# federation, LDAP, etc). Keystone only provides a `sql` driver, so there is no
# reason to change this option unless you are providing a custom entry point.
# (string value)
#driver = sql


[token]

#
# From keystone
#

# The amount of time that a token should remain valid (in seconds). Drastically
# reducing this value may break "long-running" operations that involve multiple
# services to coordinate together, and will force users to authenticate with
# keystone more frequently. Drastically increasing this value will increase the
# number of tokens that will be simultaneously valid. Keystone tokens are also
# bearer tokens, so a shorter duration will also reduce the potential security
# impact of a compromised token. (integer value)
# Minimum value: 0
# Maximum value: 9223372036854775807
#expiration = 3600

# Entry point for the token provider in the `keystone.token.provider`
# namespace. The token provider controls the token construction, validation,
# and revocation operations. Supported upstream providers are `fernet` and
# `jws`. Neither `fernet` or `jws` tokens require persistence and both require
# additional setup. If using `fernet`, you're required to run `keystone-manage
# fernet_setup`, which creates symmetric keys used to encrypt tokens. If using
# `jws`, you're required to generate an ECDSA keypair using a SHA-256 hash
# algorithm for signing and validating token, which can be done with `keystone-
# manage create_jws_keypair`. Note that `fernet` tokens are encrypted and `jws`
# tokens are only signed. Please be sure to consider this if your deployment
# has security requirements regarding payload contents used to generate token
# IDs. (string value)
#provider = fernet

# Toggle for caching token creation and validation data. This has no effect
# unless global caching is enabled. (boolean value)
#caching = true

# The number of seconds to cache token creation and validation data. This has
# no effect unless both global and `[token] caching` are enabled. (integer
# value)
# Minimum value: 0
# Maximum value: 9223372036854775807
#cache_time = <None>

# This toggles support for revoking individual tokens by the token identifier
# and thus various token enumeration operations (such as listing all tokens
# issued to a specific user). These operations are used to determine the list
# of tokens to consider revoked. Do not disable this option if you're using the
# `kvs` `[revoke] driver`. (boolean value)
#revoke_by_id = true

# This toggles whether scoped tokens may be re-scoped to a new project or
# domain, thereby preventing users from exchanging a scoped token (including
# those with a default project scope) for any other token. This forces users to
# either authenticate for unscoped tokens (and later exchange that unscoped
# token for tokens with a more specific scope) or to provide their credentials
# in every request for a scoped token to avoid re-scoping altogether. (boolean
# value)
#allow_rescope_scoped_token = true

# DEPRECATED: Enable storing issued token data to token validation cache so
# that first token validation doesn't actually cause full validation cycle.
# This option has no effect unless global caching is enabled and will still
# cache tokens even if `[token] caching = False`. (boolean value)
# This option is deprecated for removal since S.
# Its value may be silently ignored in the future.
# Reason: Keystone already exposes a configuration option for caching tokens.
# Having a separate configuration option to cache tokens when they are issued
# is redundant, unnecessarily complicated, and is misleading if token caching
# is disabled because tokens will still be pre-cached by default when they are
# issued. The ability to pre-cache tokens when they are issued is going to rely
# exclusively on the ``keystone.conf [token] caching`` option in the future.
#cache_on_issue = true

# This controls the number of seconds that a token can be retrieved for beyond
# the built-in expiry time. This allows long running operations to succeed.
# Defaults to two days. (integer value)
#allow_expired_window = 172800


[tokenless_auth]

#
# From keystone
#

# The list of distinguished names which identify trusted issuers of client
# certificates allowed to use X.509 tokenless authorization. If the option is
# absent then no certificates will be allowed. The format for the values of a
# distinguished name (DN) must be separated by a comma and contain no spaces.
# Furthermore, because an individual DN may contain commas, this configuration
# option may be repeated multiple times to represent multiple values. For
# example, keystone.conf would include two consecutive lines in order to trust
# two different DNs, such as `trusted_issuer = CN=john,OU=keystone,O=openstack`
# and `trusted_issuer = CN=mary,OU=eng,O=abc`. (multi valued)
#trusted_issuer =

# The federated protocol ID used to represent X.509 tokenless authorization.
# This is used in combination with the value of `[tokenless_auth]
# issuer_attribute` to find a corresponding federated mapping. In a typical
# deployment, there is no reason to change this value. (string value)
#protocol = x509

# The name of the WSGI environment variable used to pass the issuer of the
# client certificate to keystone. This attribute is used as an identity
# provider ID for the X.509 tokenless authorization along with the protocol to
# look up its corresponding mapping. In a typical deployment, there is no
# reason to change this value. (string value)
#issuer_attribute = SSL_CLIENT_I_DN


[totp]

#
# From keystone
#

# The number of previous windows to check when processing TOTP passcodes.
# (integer value)
# Minimum value: 0
# Maximum value: 10
#included_previous_windows = 1


[trust]

#
# From keystone
#

# Allows authorization to be redelegated from one user to another, effectively
# chaining trusts together. When disabled, the `remaining_uses` attribute of a
# trust is constrained to be zero. (boolean value)
#allow_redelegation = false

# Maximum number of times that authorization can be redelegated from one user
# to another in a chain of trusts. This number may be reduced further for a
# specific trust. (integer value)
#max_redelegation_count = 3

# Entry point for the trust backend driver in the `keystone.trust` namespace.
# Keystone only provides a `sql` driver, so there is no reason to change this
# unless you are providing a custom entry point. (string value)
#driver = sql


[unified_limit]

#
# From keystone
#

# Entry point for the unified limit backend driver in the
# `keystone.unified_limit` namespace. Keystone only provides a `sql` driver, so
# there's no reason to change this unless you are providing a custom entry
# point. (string value)
#driver = sql

# Toggle for unified limit caching. This has no effect unless global caching is
# enabled. In a typical deployment, there is no reason to disable this.
# (boolean value)
#caching = true

# Time to cache unified limit data, in seconds. This has no effect unless both
# global caching and `[unified_limit] caching` are enabled. (integer value)
#cache_time = <None>

# Maximum number of entities that will be returned in a unified limit
# collection. This may be useful to tune if you have a large number of unified
# limits in your deployment. (integer value)
#list_limit = <None>

# The enforcement model to use when validating limits associated to projects.
# Enforcement models will behave differently depending on the existing limits,
# which may result in backwards incompatible changes if a model is switched in
# a running deployment. (string value)
# Possible values:
# flat - <No description provided>
# strict_two_level - <No description provided>
#enforcement_model = flat


[wsgi]

#
# From keystone
#

# If set to true, this enables the oslo debug middleware in Keystone. This
# Middleware prints a lot of information about the request and the response. It
# is useful for getting information about the data on the wire (decoded) and
# passed to the WSGI application pipeline. This middleware has no effect on the
# "debug" setting in the [DEFAULT] section of the config file or setting
# Keystone's log-level to "DEBUG"; it is specific to debugging the WSGI data as
# it enters and leaves Keystone (specific request-related data). This option is
# used for introspection on the request and response data between the web
# server (apache, nginx, etc) and Keystone.  This middleware is inserted as the
# first element in the middleware chain and will show the data closest to the
# wire.  WARNING: NOT INTENDED FOR USE IN PRODUCTION. THIS MIDDLEWARE CAN AND
# WILL EMIT SENSITIVE/PRIVILEGED DATA. (boolean value)
#debug_middleware = false
```

​                      

# logging.conf

​                                          

You can specify a special logging configuration file in the `keystone.conf` configuration file. For example, `/etc/keystone/logging.conf`.
您可以在 `keystone.conf` 配置文件中指定特殊的日志记录配置文件。例如， `/etc/keystone/logging.conf` .

For details, see the [Python logging module documentation](https://docs.python.org/2/howto/logging.html#configuring-logging).
有关详细信息，请参阅 Python 日志记录模块文档。

```
[loggers]
keys=root,access

[handlers]
keys=production,file,access_file,devel

[formatters]
keys=minimal,normal,debug


###########
# Loggers #
###########

[logger_root]
level=WARNING
handlers=file

[logger_access]
level=INFO
qualname=access
handlers=access_file


################
# Log Handlers #
################

[handler_production]
class=handlers.SysLogHandler
level=ERROR
formatter=normal
args=(('localhost', handlers.SYSLOG_UDP_PORT), handlers.SysLogHandler.LOG_USER)

[handler_file]
class=handlers.WatchedFileHandler
level=WARNING
formatter=normal
args=('error.log',)

[handler_access_file]
class=handlers.WatchedFileHandler
level=INFO
formatter=minimal
args=('access.log',)

[handler_devel]
class=StreamHandler
level=NOTSET
formatter=debug
args=(sys.stdout,)


##################
# Log Formatters #
##################

[formatter_minimal]
format=%(message)s

[formatter_normal]
format=(%(name)s): %(asctime)s %(levelname)s %(message)s

[formatter_debug]
format=(%(name)s): %(asctime)s %(levelname)s %(module)s %(funcName)s %(message)s
```



# policy.yaml

​                                  

Use the `policy.yaml` file to define additional access controls that apply to the Identity service:
使用该 `policy.yaml` 文件定义适用于 Identity 服务的其他访问控制：

```
#"admin_required": "role:admin or is_admin:1"

#"service_role": "role:service"

#"service_or_admin": "rule:admin_required or rule:service_role"

#"owner": "user_id:%(user_id)s"

#"admin_or_owner": "rule:admin_required or rule:owner"

#"token_subject": "user_id:%(target.token.user_id)s"

#"admin_or_token_subject": "rule:admin_required or rule:token_subject"

#"service_admin_or_token_subject": "rule:service_or_admin or rule:token_subject"

# Show access rule details.
# GET  /v3/users/{user_id}/access_rules/{access_rule_id}
# HEAD  /v3/users/{user_id}/access_rules/{access_rule_id}
# Intended scope(s): system, project
#"identity:get_access_rule": "(role:reader and system_scope:all) or user_id:%(target.user.id)s"

# List access rules for a user.
# GET  /v3/users/{user_id}/access_rules
# HEAD  /v3/users/{user_id}/access_rules
# Intended scope(s): system, project
#"identity:list_access_rules": "(role:reader and system_scope:all) or user_id:%(target.user.id)s"

# Delete an access_rule.
# DELETE  /v3/users/{user_id}/access_rules/{access_rule_id}
# Intended scope(s): system, project
#"identity:delete_access_rule": "(role:admin and system_scope:all) or user_id:%(target.user.id)s"

# Authorize OAUTH1 request token.
# PUT  /v3/OS-OAUTH1/authorize/{request_token_id}
# Intended scope(s): project
#"identity:authorize_request_token": "rule:admin_required"

# Get OAUTH1 access token for user by access token ID.
# GET  /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}
# Intended scope(s): project
#"identity:get_access_token": "rule:admin_required"

# Get role for user OAUTH1 access token.
# GET  /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles/{role_id}
# Intended scope(s): project
#"identity:get_access_token_role": "rule:admin_required"

# List OAUTH1 access tokens for user.
# GET  /v3/users/{user_id}/OS-OAUTH1/access_tokens
# Intended scope(s): project
#"identity:list_access_tokens": "rule:admin_required"

# List OAUTH1 access token roles.
# GET  /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}/roles
# Intended scope(s): project
#"identity:list_access_token_roles": "rule:admin_required"

# Delete OAUTH1 access token.
# DELETE  /v3/users/{user_id}/OS-OAUTH1/access_tokens/{access_token_id}
# Intended scope(s): project
#"identity:delete_access_token": "rule:admin_required"

# Show application credential details.
# GET  /v3/users/{user_id}/application_credentials/{application_credential_id}
# HEAD  /v3/users/{user_id}/application_credentials/{application_credential_id}
# Intended scope(s): system, project
#"identity:get_application_credential": "(role:reader and system_scope:all) or rule:owner"

# DEPRECATED
# "identity:get_application_credential":"rule:admin_or_owner" has been
# deprecated since T in favor of
# "identity:get_application_credential":"(role:reader and
# system_scope:all) or rule:owner".
# The application credential API is now aware of system scope and
# default roles.

# List application credentials for a user.
# GET  /v3/users/{user_id}/application_credentials
# HEAD  /v3/users/{user_id}/application_credentials
# Intended scope(s): system, project
#"identity:list_application_credentials": "(role:reader and system_scope:all) or rule:owner"

# DEPRECATED
# "identity:list_application_credentials":"rule:admin_or_owner" has
# been deprecated since T in favor of
# "identity:list_application_credentials":"(role:reader and
# system_scope:all) or rule:owner".
# The application credential API is now aware of system scope and
# default roles.

# Create an application credential.
# POST  /v3/users/{user_id}/application_credentials
# Intended scope(s): project
#"identity:create_application_credential": "user_id:%(user_id)s"

# Delete an application credential.
# DELETE  /v3/users/{user_id}/application_credentials/{application_credential_id}
# Intended scope(s): system, project
#"identity:delete_application_credential": "(role:admin and system_scope:all) or rule:owner"

# DEPRECATED
# "identity:delete_application_credential":"rule:admin_or_owner" has
# been deprecated since T in favor of
# "identity:delete_application_credential":"(role:admin and
# system_scope:all) or rule:owner".
# The application credential API is now aware of system scope and
# default roles.

# Get service catalog.
# GET  /v3/auth/catalog
# HEAD  /v3/auth/catalog
#"identity:get_auth_catalog": ""

# List all projects a user has access to via role assignments.
# GET  /v3/auth/projects
# HEAD  /v3/auth/projects
#"identity:get_auth_projects": ""

# List all domains a user has access to via role assignments.
# GET  /v3/auth/domains
# HEAD  /v3/auth/domains
#"identity:get_auth_domains": ""

# List systems a user has access to via role assignments.
# GET  /v3/auth/system
# HEAD  /v3/auth/system
#"identity:get_auth_system": ""

# Show OAUTH1 consumer details.
# GET  /v3/OS-OAUTH1/consumers/{consumer_id}
# Intended scope(s): system
#"identity:get_consumer": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_consumer":"rule:admin_required" has been deprecated
# since T in favor of "identity:get_consumer":"role:reader and
# system_scope:all".
# The OAUTH1 consumer API is now aware of system scope and default
# roles.

# List OAUTH1 consumers.
# GET  /v3/OS-OAUTH1/consumers
# Intended scope(s): system
#"identity:list_consumers": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_consumers":"rule:admin_required" has been deprecated
# since T in favor of "identity:list_consumers":"role:reader and
# system_scope:all".
# The OAUTH1 consumer API is now aware of system scope and default
# roles.

# Create OAUTH1 consumer.
# POST  /v3/OS-OAUTH1/consumers
# Intended scope(s): system
#"identity:create_consumer": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_consumer":"rule:admin_required" has been deprecated
# since T in favor of "identity:create_consumer":"role:admin and
# system_scope:all".
# The OAUTH1 consumer API is now aware of system scope and default
# roles.

# Update OAUTH1 consumer.
# PATCH  /v3/OS-OAUTH1/consumers/{consumer_id}
# Intended scope(s): system
#"identity:update_consumer": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_consumer":"rule:admin_required" has been deprecated
# since T in favor of "identity:update_consumer":"role:admin and
# system_scope:all".
# The OAUTH1 consumer API is now aware of system scope and default
# roles.

# Delete OAUTH1 consumer.
# DELETE  /v3/OS-OAUTH1/consumers/{consumer_id}
# Intended scope(s): system
#"identity:delete_consumer": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_consumer":"rule:admin_required" has been deprecated
# since T in favor of "identity:delete_consumer":"role:admin and
# system_scope:all".
# The OAUTH1 consumer API is now aware of system scope and default
# roles.

# Show credentials details.
# GET  /v3/credentials/{credential_id}
# Intended scope(s): system, project
#"identity:get_credential": "(role:reader and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:get_credential":"rule:admin_required" has been deprecated
# since S in favor of "identity:get_credential":"(role:reader and
# system_scope:all) or user_id:%(target.credential.user_id)s".
# The credential API is now aware of system scope and default roles.

# List credentials.
# GET  /v3/credentials
# Intended scope(s): system, project
#"identity:list_credentials": "(role:reader and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:list_credentials":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:list_credentials":"(role:reader and system_scope:all) or
# user_id:%(target.credential.user_id)s".
# The credential API is now aware of system scope and default roles.

# Create credential.
# POST  /v3/credentials
# Intended scope(s): system, project
#"identity:create_credential": "(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:create_credential":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:create_credential":"(role:admin and system_scope:all) or
# user_id:%(target.credential.user_id)s".
# The credential API is now aware of system scope and default roles.

# Update credential.
# PATCH  /v3/credentials/{credential_id}
# Intended scope(s): system, project
#"identity:update_credential": "(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:update_credential":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:update_credential":"(role:admin and system_scope:all) or
# user_id:%(target.credential.user_id)s".
# The credential API is now aware of system scope and default roles.

# Delete credential.
# DELETE  /v3/credentials/{credential_id}
# Intended scope(s): system, project
#"identity:delete_credential": "(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:delete_credential":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:delete_credential":"(role:admin and system_scope:all) or
# user_id:%(target.credential.user_id)s".
# The credential API is now aware of system scope and default roles.

# Show domain details.
# GET  /v3/domains/{domain_id}
# Intended scope(s): system, domain, project
#"identity:get_domain": "(role:reader and system_scope:all) or token.domain.id:%(target.domain.id)s or token.project.domain.id:%(target.domain.id)s"

# DEPRECATED
# "identity:get_domain":"rule:admin_required or
# token.project.domain.id:%(target.domain.id)s" has been deprecated
# since S in favor of "identity:get_domain":"(role:reader and
# system_scope:all) or token.domain.id:%(target.domain.id)s or
# token.project.domain.id:%(target.domain.id)s".
# The domain API is now aware of system scope and default roles.

# List domains.
# GET  /v3/domains
# Intended scope(s): system
#"identity:list_domains": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_domains":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_domains":"role:reader and
# system_scope:all".
# The domain API is now aware of system scope and default roles.

# Create domain.
# POST  /v3/domains
# Intended scope(s): system
#"identity:create_domain": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_domain":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_domain":"role:admin and
# system_scope:all".
# The domain API is now aware of system scope and default roles.

# Update domain.
# PATCH  /v3/domains/{domain_id}
# Intended scope(s): system
#"identity:update_domain": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_domain":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_domain":"role:admin and
# system_scope:all".
# The domain API is now aware of system scope and default roles.

# Delete domain.
# DELETE  /v3/domains/{domain_id}
# Intended scope(s): system
#"identity:delete_domain": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_domain":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_domain":"role:admin and
# system_scope:all".
# The domain API is now aware of system scope and default roles.

# Create domain configuration.
# PUT  /v3/domains/{domain_id}/config
# Intended scope(s): system
#"identity:create_domain_config": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_domain_config":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:create_domain_config":"role:admin and system_scope:all".
# The domain config API is now aware of system scope and default
# roles.

# Get the entire domain configuration for a domain, an option group
# within a domain, or a specific configuration option within a group
# for a domain.
# GET  /v3/domains/{domain_id}/config
# HEAD  /v3/domains/{domain_id}/config
# GET  /v3/domains/{domain_id}/config/{group}
# HEAD  /v3/domains/{domain_id}/config/{group}
# GET  /v3/domains/{domain_id}/config/{group}/{option}
# HEAD  /v3/domains/{domain_id}/config/{group}/{option}
# Intended scope(s): system
#"identity:get_domain_config": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_domain_config":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:get_domain_config":"role:reader and system_scope:all".
# The domain config API is now aware of system scope and default
# roles.

# Get security compliance domain configuration for either a domain or
# a specific option in a domain.
# GET  /v3/domains/{domain_id}/config/security_compliance
# HEAD  /v3/domains/{domain_id}/config/security_compliance
# GET  /v3/domains/{domain_id}/config/security_compliance/{option}
# HEAD  /v3/domains/{domain_id}/config/security_compliance/{option}
# Intended scope(s): system, domain, project
#"identity:get_security_compliance_domain_config": ""

# Update domain configuration for either a domain, specific group or a
# specific option in a group.
# PATCH  /v3/domains/{domain_id}/config
# PATCH  /v3/domains/{domain_id}/config/{group}
# PATCH  /v3/domains/{domain_id}/config/{group}/{option}
# Intended scope(s): system
#"identity:update_domain_config": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_domain_config":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:update_domain_config":"role:admin and system_scope:all".
# The domain config API is now aware of system scope and default
# roles.

# Delete domain configuration for either a domain, specific group or a
# specific option in a group.
# DELETE  /v3/domains/{domain_id}/config
# DELETE  /v3/domains/{domain_id}/config/{group}
# DELETE  /v3/domains/{domain_id}/config/{group}/{option}
# Intended scope(s): system
#"identity:delete_domain_config": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_domain_config":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:delete_domain_config":"role:admin and system_scope:all".
# The domain config API is now aware of system scope and default
# roles.

# Get domain configuration default for either a domain, specific group
# or a specific option in a group.
# GET  /v3/domains/config/default
# HEAD  /v3/domains/config/default
# GET  /v3/domains/config/{group}/default
# HEAD  /v3/domains/config/{group}/default
# GET  /v3/domains/config/{group}/{option}/default
# HEAD  /v3/domains/config/{group}/{option}/default
# Intended scope(s): system
#"identity:get_domain_config_default": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_domain_config_default":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:get_domain_config_default":"role:reader and
# system_scope:all".
# The domain config API is now aware of system scope and default
# roles.

# Show ec2 credential details.
# GET  /v3/users/{user_id}/credentials/OS-EC2/{credential_id}
# Intended scope(s): system, project
#"identity:ec2_get_credential": "(role:reader and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:ec2_get_credential":"rule:admin_required or (rule:owner
# and user_id:%(target.credential.user_id)s)" has been deprecated
# since T in favor of "identity:ec2_get_credential":"(role:reader and
# system_scope:all) or user_id:%(target.credential.user_id)s".
# The EC2 credential API is now aware of system scope and default
# roles.

# List ec2 credentials.
# GET  /v3/users/{user_id}/credentials/OS-EC2
# Intended scope(s): system, project
#"identity:ec2_list_credentials": "(role:reader and system_scope:all) or rule:owner"

# DEPRECATED
# "identity:ec2_list_credentials":"rule:admin_or_owner" has been
# deprecated since T in favor of
# "identity:ec2_list_credentials":"(role:reader and system_scope:all)
# or rule:owner".
# The EC2 credential API is now aware of system scope and default
# roles.

# Create ec2 credential.
# POST  /v3/users/{user_id}/credentials/OS-EC2
# Intended scope(s): system, project
#"identity:ec2_create_credential": "(role:admin and system_scope:all) or rule:owner"

# DEPRECATED
# "identity:ec2_create_credential":"rule:admin_or_owner" has been
# deprecated since T in favor of
# "identity:ec2_create_credential":"(role:admin and system_scope:all)
# or rule:owner".
# The EC2 credential API is now aware of system scope and default
# roles.

# Delete ec2 credential.
# DELETE  /v3/users/{user_id}/credentials/OS-EC2/{credential_id}
# Intended scope(s): system, project
#"identity:ec2_delete_credential": "(role:admin and system_scope:all) or user_id:%(target.credential.user_id)s"

# DEPRECATED
# "identity:ec2_delete_credential":"rule:admin_required or (rule:owner
# and user_id:%(target.credential.user_id)s)" has been deprecated
# since T in favor of "identity:ec2_delete_credential":"(role:admin
# and system_scope:all) or user_id:%(target.credential.user_id)s".
# The EC2 credential API is now aware of system scope and default
# roles.

# Show endpoint details.
# GET  /v3/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:get_endpoint": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_endpoint":"rule:admin_required" has been deprecated
# since S in favor of "identity:get_endpoint":"role:reader and
# system_scope:all".
# The endpoint API is now aware of system scope and default roles.

# List endpoints.
# GET  /v3/endpoints
# Intended scope(s): system
#"identity:list_endpoints": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_endpoints":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_endpoints":"role:reader and
# system_scope:all".
# The endpoint API is now aware of system scope and default roles.

# Create endpoint.
# POST  /v3/endpoints
# Intended scope(s): system
#"identity:create_endpoint": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_endpoint":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_endpoint":"role:admin and
# system_scope:all".
# The endpoint API is now aware of system scope and default roles.

# Update endpoint.
# PATCH  /v3/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:update_endpoint": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_endpoint":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_endpoint":"role:admin and
# system_scope:all".
# The endpoint API is now aware of system scope and default roles.

# Delete endpoint.
# DELETE  /v3/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:delete_endpoint": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_endpoint":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_endpoint":"role:admin and
# system_scope:all".
# The endpoint API is now aware of system scope and default roles.

# Create endpoint group.
# POST  /v3/OS-EP-FILTER/endpoint_groups
# Intended scope(s): system
#"identity:create_endpoint_group": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_endpoint_group":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:create_endpoint_group":"role:admin and system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# List endpoint groups.
# GET  /v3/OS-EP-FILTER/endpoint_groups
# Intended scope(s): system
#"identity:list_endpoint_groups": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_endpoint_groups":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_endpoint_groups":"role:reader and system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Get endpoint group.
# GET  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}
# HEAD  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}
# Intended scope(s): system
#"identity:get_endpoint_group": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_endpoint_group":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:get_endpoint_group":"role:reader and system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Update endpoint group.
# PATCH  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}
# Intended scope(s): system
#"identity:update_endpoint_group": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_endpoint_group":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:update_endpoint_group":"role:admin and system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Delete endpoint group.
# DELETE  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}
# Intended scope(s): system
#"identity:delete_endpoint_group": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_endpoint_group":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:delete_endpoint_group":"role:admin and system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# List all projects associated with a specific endpoint group.
# GET  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects
# Intended scope(s): system
#"identity:list_projects_associated_with_endpoint_group": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_projects_associated_with_endpoint_group":"rule:admin_
# required" has been deprecated since T in favor of
# "identity:list_projects_associated_with_endpoint_group":"role:reader
# and system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# List all endpoints associated with an endpoint group.
# GET  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/endpoints
# Intended scope(s): system
#"identity:list_endpoints_associated_with_endpoint_group": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_endpoints_associated_with_endpoint_group":"rule:admin
# _required" has been deprecated since T in favor of "identity:list_en
# dpoints_associated_with_endpoint_group":"role:reader and
# system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Check if an endpoint group is associated with a project.
# GET  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}
# HEAD  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}
# Intended scope(s): system
#"identity:get_endpoint_group_in_project": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_endpoint_group_in_project":"rule:admin_required" has
# been deprecated since T in favor of
# "identity:get_endpoint_group_in_project":"role:reader and
# system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# List endpoint groups associated with a specific project.
# GET  /v3/OS-EP-FILTER/projects/{project_id}/endpoint_groups
# Intended scope(s): system
#"identity:list_endpoint_groups_for_project": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_endpoint_groups_for_project":"rule:admin_required"
# has been deprecated since T in favor of
# "identity:list_endpoint_groups_for_project":"role:reader and
# system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Allow a project to access an endpoint group.
# PUT  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}
# Intended scope(s): system
#"identity:add_endpoint_group_to_project": "role:admin and system_scope:all"

# DEPRECATED
# "identity:add_endpoint_group_to_project":"rule:admin_required" has
# been deprecated since T in favor of
# "identity:add_endpoint_group_to_project":"role:admin and
# system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Remove endpoint group from project.
# DELETE  /v3/OS-EP-FILTER/endpoint_groups/{endpoint_group_id}/projects/{project_id}
# Intended scope(s): system
#"identity:remove_endpoint_group_from_project": "role:admin and system_scope:all"

# DEPRECATED
# "identity:remove_endpoint_group_from_project":"rule:admin_required"
# has been deprecated since T in favor of
# "identity:remove_endpoint_group_from_project":"role:admin and
# system_scope:all".
# The endpoint groups API is now aware of system scope and default
# roles.

# Check a role grant between a target and an actor. A target can be
# either a domain or a project. An actor can be either a user or a
# group. These terms also apply to the OS-INHERIT APIs, where grants
# on the target are inherited to all projects in the subtree, if
# applicable.
# HEAD  /v3/projects/{project_id}/users/{user_id}/roles/{role_id}
# GET  /v3/projects/{project_id}/users/{user_id}/roles/{role_id}
# HEAD  /v3/projects/{project_id}/groups/{group_id}/roles/{role_id}
# GET  /v3/projects/{project_id}/groups/{group_id}/roles/{role_id}
# HEAD  /v3/domains/{domain_id}/users/{user_id}/roles/{role_id}
# GET  /v3/domains/{domain_id}/users/{user_id}/roles/{role_id}
# HEAD  /v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}
# GET  /v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}
# HEAD  /v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# GET  /v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# HEAD  /v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# GET  /v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# HEAD  /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# GET  /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# HEAD  /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# GET  /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# Intended scope(s): system, domain
#"identity:check_grant": "(role:reader and system_scope:all) or ((role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)) and (domain_id:%(target.role.domain_id)s or None:%(target.role.domain_id)s)"

# DEPRECATED
# "identity:check_grant":"rule:admin_required" has been deprecated
# since S in favor of "identity:check_grant":"(role:reader and
# system_scope:all) or ((role:reader and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:reader and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.domain.id)s) or (role:reader and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:reader and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.domain.id)s)) and
# (domain_id:%(target.role.domain_id)s or
# None:%(target.role.domain_id)s)".
# The assignment API is now aware of system scope and default roles.

# List roles granted to an actor on a target. A target can be either a
# domain or a project. An actor can be either a user or a group. For
# the OS-INHERIT APIs, it is possible to list inherited role grants
# for actors on domains, where grants are inherited to all projects in
# the specified domain.
# GET  /v3/projects/{project_id}/users/{user_id}/roles
# HEAD  /v3/projects/{project_id}/users/{user_id}/roles
# GET  /v3/projects/{project_id}/groups/{group_id}/roles
# HEAD  /v3/projects/{project_id}/groups/{group_id}/roles
# GET  /v3/domains/{domain_id}/users/{user_id}/roles
# HEAD  /v3/domains/{domain_id}/users/{user_id}/roles
# GET  /v3/domains/{domain_id}/groups/{group_id}/roles
# HEAD  /v3/domains/{domain_id}/groups/{group_id}/roles
# GET  /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/inherited_to_projects
# GET  /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/inherited_to_projects
# Intended scope(s): system, domain
#"identity:list_grants": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)"

# DEPRECATED
# "identity:list_grants":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_grants":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:reader and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.domain.id)s) or (role:reader and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:reader and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.domain.id)s)".
# The assignment API is now aware of system scope and default roles.

# Create a role grant between a target and an actor. A target can be
# either a domain or a project. An actor can be either a user or a
# group. These terms also apply to the OS-INHERIT APIs, where grants
# on the target are inherited to all projects in the subtree, if
# applicable.
# PUT  /v3/projects/{project_id}/users/{user_id}/roles/{role_id}
# PUT  /v3/projects/{project_id}/groups/{group_id}/roles/{role_id}
# PUT  /v3/domains/{domain_id}/users/{user_id}/roles/{role_id}
# PUT  /v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}
# PUT  /v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# PUT  /v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# PUT  /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# PUT  /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# Intended scope(s): system, domain
#"identity:create_grant": "(role:admin and system_scope:all) or ((role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)) and (domain_id:%(target.role.domain_id)s or None:%(target.role.domain_id)s)"

# DEPRECATED
# "identity:create_grant":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_grant":"(role:admin and
# system_scope:all) or ((role:admin and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:admin and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.domain.id)s) or (role:admin and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:admin and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.domain.id)s)) and
# (domain_id:%(target.role.domain_id)s or
# None:%(target.role.domain_id)s)".
# The assignment API is now aware of system scope and default roles.

# Revoke a role grant between a target and an actor. A target can be
# either a domain or a project. An actor can be either a user or a
# group. These terms also apply to the OS-INHERIT APIs, where grants
# on the target are inherited to all projects in the subtree, if
# applicable. In that case, revoking the role grant in the target
# would remove the logical effect of inheriting it to the target's
# projects subtree.
# DELETE  /v3/projects/{project_id}/users/{user_id}/roles/{role_id}
# DELETE  /v3/projects/{project_id}/groups/{group_id}/roles/{role_id}
# DELETE  /v3/domains/{domain_id}/users/{user_id}/roles/{role_id}
# DELETE  /v3/domains/{domain_id}/groups/{group_id}/roles/{role_id}
# DELETE  /v3/OS-INHERIT/projects/{project_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# DELETE  /v3/OS-INHERIT/projects/{project_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# DELETE  /v3/OS-INHERIT/domains/{domain_id}/users/{user_id}/roles/{role_id}/inherited_to_projects
# DELETE  /v3/OS-INHERIT/domains/{domain_id}/groups/{group_id}/roles/{role_id}/inherited_to_projects
# Intended scope(s): system, domain
#"identity:revoke_grant": "(role:admin and system_scope:all) or ((role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.user.domain_id)s and domain_id:%(target.domain.id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.project.domain_id)s) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.domain.id)s)) and (domain_id:%(target.role.domain_id)s or None:%(target.role.domain_id)s)"

# DEPRECATED
# "identity:revoke_grant":"rule:admin_required" has been deprecated
# since S in favor of "identity:revoke_grant":"(role:admin and
# system_scope:all) or ((role:admin and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:admin and
# domain_id:%(target.user.domain_id)s and
# domain_id:%(target.domain.id)s) or (role:admin and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.project.domain_id)s) or (role:admin and
# domain_id:%(target.group.domain_id)s and
# domain_id:%(target.domain.id)s)) and
# (domain_id:%(target.role.domain_id)s or
# None:%(target.role.domain_id)s)".
# The assignment API is now aware of system scope and default roles.

# List all grants a specific user has on the system.
# ['HEAD', 'GET']  /v3/system/users/{user_id}/roles
# Intended scope(s): system
#"identity:list_system_grants_for_user": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_system_grants_for_user":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:list_system_grants_for_user":"role:reader and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Check if a user has a role on the system.
# ['HEAD', 'GET']  /v3/system/users/{user_id}/roles/{role_id}
# Intended scope(s): system
#"identity:check_system_grant_for_user": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_system_grant_for_user":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:check_system_grant_for_user":"role:reader and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Grant a user a role on the system.
# ['PUT']  /v3/system/users/{user_id}/roles/{role_id}
# Intended scope(s): system
#"identity:create_system_grant_for_user": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_system_grant_for_user":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:create_system_grant_for_user":"role:admin and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Remove a role from a user on the system.
# ['DELETE']  /v3/system/users/{user_id}/roles/{role_id}
# Intended scope(s): system
#"identity:revoke_system_grant_for_user": "role:admin and system_scope:all"

# DEPRECATED
# "identity:revoke_system_grant_for_user":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:revoke_system_grant_for_user":"role:admin and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# List all grants a specific group has on the system.
# ['HEAD', 'GET']  /v3/system/groups/{group_id}/roles
# Intended scope(s): system
#"identity:list_system_grants_for_group": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_system_grants_for_group":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:list_system_grants_for_group":"role:reader and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Check if a group has a role on the system.
# ['HEAD', 'GET']  /v3/system/groups/{group_id}/roles/{role_id}
# Intended scope(s): system
#"identity:check_system_grant_for_group": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_system_grant_for_group":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:check_system_grant_for_group":"role:reader and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Grant a group a role on the system.
# ['PUT']  /v3/system/groups/{group_id}/roles/{role_id}
# Intended scope(s): system
#"identity:create_system_grant_for_group": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_system_grant_for_group":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:create_system_grant_for_group":"role:admin and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Remove a role from a group on the system.
# ['DELETE']  /v3/system/groups/{group_id}/roles/{role_id}
# Intended scope(s): system
#"identity:revoke_system_grant_for_group": "role:admin and system_scope:all"

# DEPRECATED
# "identity:revoke_system_grant_for_group":"rule:admin_required" has
# been deprecated since S in favor of
# "identity:revoke_system_grant_for_group":"role:admin and
# system_scope:all".
# The assignment API is now aware of system scope and default roles.

# Show group details.
# GET  /v3/groups/{group_id}
# HEAD  /v3/groups/{group_id}
# Intended scope(s): system, domain
#"identity:get_group": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s)"

# DEPRECATED
# "identity:get_group":"rule:admin_required" has been deprecated since
# S in favor of "identity:get_group":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.group.domain_id)s)".
# The group API is now aware of system scope and default roles.

# List groups.
# GET  /v3/groups
# HEAD  /v3/groups
# Intended scope(s): system, domain
#"identity:list_groups": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s)"

# DEPRECATED
# "identity:list_groups":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_groups":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.group.domain_id)s)".
# The group API is now aware of system scope and default roles.

# List groups to which a user belongs.
# GET  /v3/users/{user_id}/groups
# HEAD  /v3/users/{user_id}/groups
# Intended scope(s): system, domain, project
#"identity:list_groups_for_user": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.user.domain_id)s) or user_id:%(user_id)s"

# DEPRECATED
# "identity:list_groups_for_user":"rule:admin_or_owner" has been
# deprecated since S in favor of
# "identity:list_groups_for_user":"(role:reader and system_scope:all)
# or (role:reader and domain_id:%(target.user.domain_id)s) or
# user_id:%(user_id)s".
# The group API is now aware of system scope and default roles.

# Create group.
# POST  /v3/groups
# Intended scope(s): system, domain
#"identity:create_group": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s)"

# DEPRECATED
# "identity:create_group":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_group":"(role:admin and
# system_scope:all) or (role:admin and
# domain_id:%(target.group.domain_id)s)".
# The group API is now aware of system scope and default roles.

# Update group.
# PATCH  /v3/groups/{group_id}
# Intended scope(s): system, domain
#"identity:update_group": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s)"

# DEPRECATED
# "identity:update_group":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_group":"(role:admin and
# system_scope:all) or (role:admin and
# domain_id:%(target.group.domain_id)s)".
# The group API is now aware of system scope and default roles.

# Delete group.
# DELETE  /v3/groups/{group_id}
# Intended scope(s): system, domain
#"identity:delete_group": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s)"

# DEPRECATED
# "identity:delete_group":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_group":"(role:admin and
# system_scope:all) or (role:admin and
# domain_id:%(target.group.domain_id)s)".
# The group API is now aware of system scope and default roles.

# List members of a specific group.
# GET  /v3/groups/{group_id}/users
# HEAD  /v3/groups/{group_id}/users
# Intended scope(s): system, domain
#"identity:list_users_in_group": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s)"

# DEPRECATED
# "identity:list_users_in_group":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:list_users_in_group":"(role:reader and system_scope:all)
# or (role:reader and domain_id:%(target.group.domain_id)s)".
# The group API is now aware of system scope and default roles.

# Remove user from group.
# DELETE  /v3/groups/{group_id}/users/{user_id}
# Intended scope(s): system, domain
#"identity:remove_user_from_group": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.user.domain_id)s)"

# DEPRECATED
# "identity:remove_user_from_group":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:remove_user_from_group":"(role:admin and system_scope:all)
# or (role:admin and domain_id:%(target.group.domain_id)s and
# domain_id:%(target.user.domain_id)s)".
# The group API is now aware of system scope and default roles.

# Check whether a user is a member of a group.
# HEAD  /v3/groups/{group_id}/users/{user_id}
# GET  /v3/groups/{group_id}/users/{user_id}
# Intended scope(s): system, domain
#"identity:check_user_in_group": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.group.domain_id)s and domain_id:%(target.user.domain_id)s)"

# DEPRECATED
# "identity:check_user_in_group":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:check_user_in_group":"(role:reader and system_scope:all)
# or (role:reader and domain_id:%(target.group.domain_id)s and
# domain_id:%(target.user.domain_id)s)".
# The group API is now aware of system scope and default roles.

# Add user to group.
# PUT  /v3/groups/{group_id}/users/{user_id}
# Intended scope(s): system, domain
#"identity:add_user_to_group": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.group.domain_id)s and domain_id:%(target.user.domain_id)s)"

# DEPRECATED
# "identity:add_user_to_group":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:add_user_to_group":"(role:admin and system_scope:all) or
# (role:admin and domain_id:%(target.group.domain_id)s and
# domain_id:%(target.user.domain_id)s)".
# The group API is now aware of system scope and default roles.

# Create identity provider.
# PUT  /v3/OS-FEDERATION/identity_providers/{idp_id}
# Intended scope(s): system
#"identity:create_identity_provider": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_identity_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:create_identity_provider":"role:admin and
# system_scope:all".
# The identity provider API is now aware of system scope and default
# roles.

# List identity providers.
# GET  /v3/OS-FEDERATION/identity_providers
# HEAD  /v3/OS-FEDERATION/identity_providers
# Intended scope(s): system
#"identity:list_identity_providers": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_identity_providers":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:list_identity_providers":"role:reader and
# system_scope:all".
# The identity provider API is now aware of system scope and default
# roles.

# Get identity provider.
# GET  /v3/OS-FEDERATION/identity_providers/{idp_id}
# HEAD  /v3/OS-FEDERATION/identity_providers/{idp_id}
# Intended scope(s): system
#"identity:get_identity_provider": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_identity_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:get_identity_provider":"role:reader and system_scope:all".
# The identity provider API is now aware of system scope and default
# roles.

# Update identity provider.
# PATCH  /v3/OS-FEDERATION/identity_providers/{idp_id}
# Intended scope(s): system
#"identity:update_identity_provider": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_identity_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:update_identity_provider":"role:admin and
# system_scope:all".
# The identity provider API is now aware of system scope and default
# roles.

# Delete identity provider.
# DELETE  /v3/OS-FEDERATION/identity_providers/{idp_id}
# Intended scope(s): system
#"identity:delete_identity_provider": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_identity_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:delete_identity_provider":"role:admin and
# system_scope:all".
# The identity provider API is now aware of system scope and default
# roles.

# Get information about an association between two roles. When a
# relationship exists between a prior role and an implied role and the
# prior role is assigned to a user, the user also assumes the implied
# role.
# GET  /v3/roles/{prior_role_id}/implies/{implied_role_id}
# Intended scope(s): system
#"identity:get_implied_role": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_implied_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:get_implied_role":"role:reader and system_scope:all".
# The implied role API is now aware of system scope and default roles.

# List associations between two roles. When a relationship exists
# between a prior role and an implied role and the prior role is
# assigned to a user, the user also assumes the implied role. This
# will return all the implied roles that would be assumed by the user
# who gets the specified prior role.
# GET  /v3/roles/{prior_role_id}/implies
# HEAD  /v3/roles/{prior_role_id}/implies
# Intended scope(s): system
#"identity:list_implied_roles": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_implied_roles":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_implied_roles":"role:reader and system_scope:all".
# The implied role API is now aware of system scope and default roles.

# Create an association between two roles. When a relationship exists
# between a prior role and an implied role and the prior role is
# assigned to a user, the user also assumes the implied role.
# PUT  /v3/roles/{prior_role_id}/implies/{implied_role_id}
# Intended scope(s): system
#"identity:create_implied_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_implied_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:create_implied_role":"role:admin and system_scope:all".
# The implied role API is now aware of system scope and default roles.

# Delete the association between two roles. When a relationship exists
# between a prior role and an implied role and the prior role is
# assigned to a user, the user also assumes the implied role. Removing
# the association will cause that effect to be eliminated.
# DELETE  /v3/roles/{prior_role_id}/implies/{implied_role_id}
# Intended scope(s): system
#"identity:delete_implied_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_implied_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:delete_implied_role":"role:admin and system_scope:all".
# The implied role API is now aware of system scope and default roles.

# List all associations between two roles in the system. When a
# relationship exists between a prior role and an implied role and the
# prior role is assigned to a user, the user also assumes the implied
# role.
# GET  /v3/role_inferences
# HEAD  /v3/role_inferences
# Intended scope(s): system
#"identity:list_role_inference_rules": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_role_inference_rules":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_role_inference_rules":"role:reader and
# system_scope:all".
# The implied role API is now aware of system scope and default roles.

# Check an association between two roles. When a relationship exists
# between a prior role and an implied role and the prior role is
# assigned to a user, the user also assumes the implied role.
# HEAD  /v3/roles/{prior_role_id}/implies/{implied_role_id}
# Intended scope(s): system
#"identity:check_implied_role": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_implied_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:check_implied_role":"role:reader and system_scope:all".
# The implied role API is now aware of system scope and default roles.

# Get limit enforcement model.
# GET  /v3/limits/model
# HEAD  /v3/limits/model
# Intended scope(s): system, domain, project
#"identity:get_limit_model": ""

# Show limit details.
# GET  /v3/limits/{limit_id}
# HEAD  /v3/limits/{limit_id}
# Intended scope(s): system, domain, project
#"identity:get_limit": "(role:reader and system_scope:all) or (domain_id:%(target.limit.domain.id)s or domain_id:%(target.limit.project.domain_id)s) or (project_id:%(target.limit.project_id)s and not None:%(target.limit.project_id)s)"

# List limits.
# GET  /v3/limits
# HEAD  /v3/limits
# Intended scope(s): system, domain, project
#"identity:list_limits": ""

# Create limits.
# POST  /v3/limits
# Intended scope(s): system
#"identity:create_limits": "role:admin and system_scope:all"

# Update limit.
# PATCH  /v3/limits/{limit_id}
# Intended scope(s): system
#"identity:update_limit": "role:admin and system_scope:all"

# Delete limit.
# DELETE  /v3/limits/{limit_id}
# Intended scope(s): system
#"identity:delete_limit": "role:admin and system_scope:all"

# Create a new federated mapping containing one or more sets of rules.
# PUT  /v3/OS-FEDERATION/mappings/{mapping_id}
# Intended scope(s): system
#"identity:create_mapping": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_mapping":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_mapping":"role:admin and
# system_scope:all".
# The federated mapping API is now aware of system scope and default
# roles.

# Get a federated mapping.
# GET  /v3/OS-FEDERATION/mappings/{mapping_id}
# HEAD  /v3/OS-FEDERATION/mappings/{mapping_id}
# Intended scope(s): system
#"identity:get_mapping": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_mapping":"rule:admin_required" has been deprecated
# since S in favor of "identity:get_mapping":"role:reader and
# system_scope:all".
# The federated mapping API is now aware of system scope and default
# roles.

# List federated mappings.
# GET  /v3/OS-FEDERATION/mappings
# HEAD  /v3/OS-FEDERATION/mappings
# Intended scope(s): system
#"identity:list_mappings": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_mappings":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_mappings":"role:reader and
# system_scope:all".
# The federated mapping API is now aware of system scope and default
# roles.

# Delete a federated mapping.
# DELETE  /v3/OS-FEDERATION/mappings/{mapping_id}
# Intended scope(s): system
#"identity:delete_mapping": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_mapping":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_mapping":"role:admin and
# system_scope:all".
# The federated mapping API is now aware of system scope and default
# roles.

# Update a federated mapping.
# PATCH  /v3/OS-FEDERATION/mappings/{mapping_id}
# Intended scope(s): system
#"identity:update_mapping": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_mapping":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_mapping":"role:admin and
# system_scope:all".
# The federated mapping API is now aware of system scope and default
# roles.

# Show policy details.
# GET  /v3/policies/{policy_id}
# Intended scope(s): system
#"identity:get_policy": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_policy":"rule:admin_required" has been deprecated
# since T in favor of "identity:get_policy":"role:reader and
# system_scope:all".
# The policy API is now aware of system scope and default roles.

# List policies.
# GET  /v3/policies
# Intended scope(s): system
#"identity:list_policies": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_policies":"rule:admin_required" has been deprecated
# since T in favor of "identity:list_policies":"role:reader and
# system_scope:all".
# The policy API is now aware of system scope and default roles.

# Create policy.
# POST  /v3/policies
# Intended scope(s): system
#"identity:create_policy": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_policy":"rule:admin_required" has been deprecated
# since T in favor of "identity:create_policy":"role:admin and
# system_scope:all".
# The policy API is now aware of system scope and default roles.

# Update policy.
# PATCH  /v3/policies/{policy_id}
# Intended scope(s): system
#"identity:update_policy": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_policy":"rule:admin_required" has been deprecated
# since T in favor of "identity:update_policy":"role:admin and
# system_scope:all".
# The policy API is now aware of system scope and default roles.

# Delete policy.
# DELETE  /v3/policies/{policy_id}
# Intended scope(s): system
#"identity:delete_policy": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_policy":"rule:admin_required" has been deprecated
# since T in favor of "identity:delete_policy":"role:admin and
# system_scope:all".
# The policy API is now aware of system scope and default roles.

# Associate a policy to a specific endpoint.
# PUT  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:create_policy_association_for_endpoint": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_policy_association_for_endpoint":"rule:admin_requir
# ed" has been deprecated since T in favor of
# "identity:create_policy_association_for_endpoint":"role:admin and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Check policy association for endpoint.
# GET  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}
# HEAD  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:check_policy_association_for_endpoint": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_policy_association_for_endpoint":"rule:admin_require
# d" has been deprecated since T in favor of
# "identity:check_policy_association_for_endpoint":"role:reader and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Delete policy association for endpoint.
# DELETE  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:delete_policy_association_for_endpoint": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_policy_association_for_endpoint":"rule:admin_requir
# ed" has been deprecated since T in favor of
# "identity:delete_policy_association_for_endpoint":"role:admin and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Associate a policy to a specific service.
# PUT  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}
# Intended scope(s): system
#"identity:create_policy_association_for_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_policy_association_for_service":"rule:admin_require
# d" has been deprecated since T in favor of
# "identity:create_policy_association_for_service":"role:admin and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Check policy association for service.
# GET  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}
# HEAD  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}
# Intended scope(s): system
#"identity:check_policy_association_for_service": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_policy_association_for_service":"rule:admin_required
# " has been deprecated since T in favor of
# "identity:check_policy_association_for_service":"role:reader and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Delete policy association for service.
# DELETE  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}
# Intended scope(s): system
#"identity:delete_policy_association_for_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_policy_association_for_service":"rule:admin_require
# d" has been deprecated since T in favor of
# "identity:delete_policy_association_for_service":"role:admin and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Associate a policy to a specific region and service combination.
# PUT  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}
# Intended scope(s): system
#"identity:create_policy_association_for_region_and_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_policy_association_for_region_and_service":"rule:ad
# min_required" has been deprecated since T in favor of "identity:crea
# te_policy_association_for_region_and_service":"role:admin and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Check policy association for region and service.
# GET  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}
# HEAD  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}
# Intended scope(s): system
#"identity:check_policy_association_for_region_and_service": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_policy_association_for_region_and_service":"rule:adm
# in_required" has been deprecated since T in favor of "identity:check
# _policy_association_for_region_and_service":"role:reader and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Delete policy association for region and service.
# DELETE  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/services/{service_id}/regions/{region_id}
# Intended scope(s): system
#"identity:delete_policy_association_for_region_and_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_policy_association_for_region_and_service":"rule:ad
# min_required" has been deprecated since T in favor of "identity:dele
# te_policy_association_for_region_and_service":"role:admin and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Get policy for endpoint.
# GET  /v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy
# HEAD  /v3/endpoints/{endpoint_id}/OS-ENDPOINT-POLICY/policy
# Intended scope(s): system
#"identity:get_policy_for_endpoint": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_policy_for_endpoint":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:get_policy_for_endpoint":"role:reader and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# List endpoints for policy.
# GET  /v3/policies/{policy_id}/OS-ENDPOINT-POLICY/endpoints
# Intended scope(s): system
#"identity:list_endpoints_for_policy": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_endpoints_for_policy":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_endpoints_for_policy":"role:reader and
# system_scope:all".
# The policy association API is now aware of system scope and default
# roles.

# Show project details.
# GET  /v3/projects/{project_id}
# Intended scope(s): system, domain, project
#"identity:get_project": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or project_id:%(target.project.id)s"

# DEPRECATED
# "identity:get_project":"rule:admin_required or
# project_id:%(target.project.id)s" has been deprecated since S in
# favor of "identity:get_project":"(role:reader and system_scope:all)
# or (role:reader and domain_id:%(target.project.domain_id)s) or
# project_id:%(target.project.id)s".
# The project API is now aware of system scope and default roles.

# List projects.
# GET  /v3/projects
# Intended scope(s): system, domain
#"identity:list_projects": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.domain_id)s)"

# DEPRECATED
# "identity:list_projects":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_projects":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.domain_id)s)".
# The project API is now aware of system scope and default roles.

# List projects for user.
# GET  /v3/users/{user_id}/projects
# Intended scope(s): system, domain, project
#"identity:list_user_projects": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.user.domain_id)s) or user_id:%(target.user.id)s"

# DEPRECATED
# "identity:list_user_projects":"rule:admin_or_owner" has been
# deprecated since S in favor of
# "identity:list_user_projects":"(role:reader and system_scope:all) or
# (role:reader and domain_id:%(target.user.domain_id)s) or
# user_id:%(target.user.id)s".
# The project API is now aware of system scope and default roles.

# Create project.
# POST  /v3/projects
# Intended scope(s): system, domain
#"identity:create_project": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s)"

# DEPRECATED
# "identity:create_project":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_project":"(role:admin and
# system_scope:all) or (role:admin and
# domain_id:%(target.project.domain_id)s)".
# The project API is now aware of system scope and default roles.

# Update project.
# PATCH  /v3/projects/{project_id}
# Intended scope(s): system, domain
#"identity:update_project": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s)"

# DEPRECATED
# "identity:update_project":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_project":"(role:admin and
# system_scope:all) or (role:admin and
# domain_id:%(target.project.domain_id)s)".
# The project API is now aware of system scope and default roles.

# Delete project.
# DELETE  /v3/projects/{project_id}
# Intended scope(s): system, domain
#"identity:delete_project": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s)"

# DEPRECATED
# "identity:delete_project":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_project":"(role:admin and
# system_scope:all) or (role:admin and
# domain_id:%(target.project.domain_id)s)".
# The project API is now aware of system scope and default roles.

# List tags for a project.
# GET  /v3/projects/{project_id}/tags
# HEAD  /v3/projects/{project_id}/tags
# Intended scope(s): system, domain, project
#"identity:list_project_tags": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or project_id:%(target.project.id)s"

# DEPRECATED
# "identity:list_project_tags":"rule:admin_required or
# project_id:%(target.project.id)s" has been deprecated since T in
# favor of "identity:list_project_tags":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.project.domain_id)s) or
# project_id:%(target.project.id)s".
# The project API is now aware of system scope and default roles.

# Check if project contains a tag.
# GET  /v3/projects/{project_id}/tags/{value}
# HEAD  /v3/projects/{project_id}/tags/{value}
# Intended scope(s): system, domain, project
#"identity:get_project_tag": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or project_id:%(target.project.id)s"

# DEPRECATED
# "identity:get_project_tag":"rule:admin_required or
# project_id:%(target.project.id)s" has been deprecated since T in
# favor of "identity:get_project_tag":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.project.domain_id)s) or
# project_id:%(target.project.id)s".
# The project API is now aware of system scope and default roles.

# Replace all tags on a project with the new set of tags.
# PUT  /v3/projects/{project_id}/tags
# Intended scope(s): system, domain, project
#"identity:update_project_tags": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)"

# DEPRECATED
# "identity:update_project_tags":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:update_project_tags":"(role:admin and system_scope:all) or
# (role:admin and domain_id:%(target.project.domain_id)s) or
# (role:admin and project_id:%(target.project.id)s)".
# The project API is now aware of system scope and default roles.

# Add a single tag to a project.
# PUT  /v3/projects/{project_id}/tags/{value}
# Intended scope(s): system, domain, project
#"identity:create_project_tag": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)"

# DEPRECATED
# "identity:create_project_tag":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:create_project_tag":"(role:admin and system_scope:all) or
# (role:admin and domain_id:%(target.project.domain_id)s) or
# (role:admin and project_id:%(target.project.id)s)".
# The project API is now aware of system scope and default roles.

# Remove all tags from a project.
# DELETE  /v3/projects/{project_id}/tags
# Intended scope(s): system, domain, project
#"identity:delete_project_tags": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)"

# DEPRECATED
# "identity:delete_project_tags":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:delete_project_tags":"(role:admin and system_scope:all) or
# (role:admin and domain_id:%(target.project.domain_id)s) or
# (role:admin and project_id:%(target.project.id)s)".
# The project API is now aware of system scope and default roles.

# Delete a specified tag from project.
# DELETE  /v3/projects/{project_id}/tags/{value}
# Intended scope(s): system, domain, project
#"identity:delete_project_tag": "(role:admin and system_scope:all) or (role:admin and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)"

# DEPRECATED
# "identity:delete_project_tag":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:delete_project_tag":"(role:admin and system_scope:all) or
# (role:admin and domain_id:%(target.project.domain_id)s) or
# (role:admin and project_id:%(target.project.id)s)".
# The project API is now aware of system scope and default roles.

# List projects allowed to access an endpoint.
# GET  /v3/OS-EP-FILTER/endpoints/{endpoint_id}/projects
# Intended scope(s): system
#"identity:list_projects_for_endpoint": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_projects_for_endpoint":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_projects_for_endpoint":"role:reader and
# system_scope:all".
# As of the Train release, the project endpoint API now understands
# default roles and system-scoped tokens, making the API more granular
# by default without compromising security. The new policy defaults
# account for these changes automatically. Be sure to take these new
# defaults into consideration if you are relying on overrides in your
# deployment for the project endpoint API.

# Allow project to access an endpoint.
# PUT  /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:add_endpoint_to_project": "role:admin and system_scope:all"

# DEPRECATED
# "identity:add_endpoint_to_project":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:add_endpoint_to_project":"role:admin and
# system_scope:all".
# As of the Train release, the project endpoint API now understands
# default roles and system-scoped tokens, making the API more granular
# by default without compromising security. The new policy defaults
# account for these changes automatically. Be sure to take these new
# defaults into consideration if you are relying on overrides in your
# deployment for the project endpoint API.

# Check if a project is allowed to access an endpoint.
# GET  /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}
# HEAD  /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:check_endpoint_in_project": "role:reader and system_scope:all"

# DEPRECATED
# "identity:check_endpoint_in_project":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:check_endpoint_in_project":"role:reader and
# system_scope:all".
# As of the Train release, the project endpoint API now understands
# default roles and system-scoped tokens, making the API more granular
# by default without compromising security. The new policy defaults
# account for these changes automatically. Be sure to take these new
# defaults into consideration if you are relying on overrides in your
# deployment for the project endpoint API.

# List the endpoints a project is allowed to access.
# GET  /v3/OS-EP-FILTER/projects/{project_id}/endpoints
# Intended scope(s): system
#"identity:list_endpoints_for_project": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_endpoints_for_project":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_endpoints_for_project":"role:reader and
# system_scope:all".
# As of the Train release, the project endpoint API now understands
# default roles and system-scoped tokens, making the API more granular
# by default without compromising security. The new policy defaults
# account for these changes automatically. Be sure to take these new
# defaults into consideration if you are relying on overrides in your
# deployment for the project endpoint API.

# Remove access to an endpoint from a project that has previously been
# given explicit access.
# DELETE  /v3/OS-EP-FILTER/projects/{project_id}/endpoints/{endpoint_id}
# Intended scope(s): system
#"identity:remove_endpoint_from_project": "role:admin and system_scope:all"

# DEPRECATED
# "identity:remove_endpoint_from_project":"rule:admin_required" has
# been deprecated since T in favor of
# "identity:remove_endpoint_from_project":"role:admin and
# system_scope:all".
# As of the Train release, the project endpoint API now understands
# default roles and system-scoped tokens, making the API more granular
# by default without compromising security. The new policy defaults
# account for these changes automatically. Be sure to take these new
# defaults into consideration if you are relying on overrides in your
# deployment for the project endpoint API.

# Create federated protocol.
# PUT  /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}
# Intended scope(s): system
#"identity:create_protocol": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_protocol":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_protocol":"role:admin and
# system_scope:all".
# The federated protocol API is now aware of system scope and default
# roles.

# Update federated protocol.
# PATCH  /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}
# Intended scope(s): system
#"identity:update_protocol": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_protocol":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_protocol":"role:admin and
# system_scope:all".
# The federated protocol API is now aware of system scope and default
# roles.

# Get federated protocol.
# GET  /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}
# Intended scope(s): system
#"identity:get_protocol": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_protocol":"rule:admin_required" has been deprecated
# since S in favor of "identity:get_protocol":"role:reader and
# system_scope:all".
# The federated protocol API is now aware of system scope and default
# roles.

# List federated protocols.
# GET  /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols
# Intended scope(s): system
#"identity:list_protocols": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_protocols":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_protocols":"role:reader and
# system_scope:all".
# The federated protocol API is now aware of system scope and default
# roles.

# Delete federated protocol.
# DELETE  /v3/OS-FEDERATION/identity_providers/{idp_id}/protocols/{protocol_id}
# Intended scope(s): system
#"identity:delete_protocol": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_protocol":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_protocol":"role:admin and
# system_scope:all".
# The federated protocol API is now aware of system scope and default
# roles.

# Show region details.
# GET  /v3/regions/{region_id}
# HEAD  /v3/regions/{region_id}
# Intended scope(s): system, domain, project
#"identity:get_region": ""

# List regions.
# GET  /v3/regions
# HEAD  /v3/regions
# Intended scope(s): system, domain, project
#"identity:list_regions": ""

# Create region.
# POST  /v3/regions
# PUT  /v3/regions/{region_id}
# Intended scope(s): system
#"identity:create_region": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_region":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_region":"role:admin and
# system_scope:all".
# The region API is now aware of system scope and default roles.

# Update region.
# PATCH  /v3/regions/{region_id}
# Intended scope(s): system
#"identity:update_region": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_region":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_region":"role:admin and
# system_scope:all".
# The region API is now aware of system scope and default roles.

# Delete region.
# DELETE  /v3/regions/{region_id}
# Intended scope(s): system
#"identity:delete_region": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_region":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_region":"role:admin and
# system_scope:all".
# The region API is now aware of system scope and default roles.

# Show registered limit details.
# GET  /v3/registered_limits/{registered_limit_id}
# HEAD  /v3/registered_limits/{registered_limit_id}
# Intended scope(s): system, domain, project
#"identity:get_registered_limit": ""

# List registered limits.
# GET  /v3/registered_limits
# HEAD  /v3/registered_limits
# Intended scope(s): system, domain, project
#"identity:list_registered_limits": ""

# Create registered limits.
# POST  /v3/registered_limits
# Intended scope(s): system
#"identity:create_registered_limits": "role:admin and system_scope:all"

# Update registered limit.
# PATCH  /v3/registered_limits/{registered_limit_id}
# Intended scope(s): system
#"identity:update_registered_limit": "role:admin and system_scope:all"

# Delete registered limit.
# DELETE  /v3/registered_limits/{registered_limit_id}
# Intended scope(s): system
#"identity:delete_registered_limit": "role:admin and system_scope:all"

# List revocation events.
# GET  /v3/OS-REVOKE/events
# Intended scope(s): system
#"identity:list_revoke_events": "rule:service_or_admin"

# Show role details.
# GET  /v3/roles/{role_id}
# HEAD  /v3/roles/{role_id}
# Intended scope(s): system
#"identity:get_role": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_role":"rule:admin_required" has been deprecated since
# S in favor of "identity:get_role":"role:reader and
# system_scope:all".
# The role API is now aware of system scope and default roles.

# List roles.
# GET  /v3/roles
# HEAD  /v3/roles
# Intended scope(s): system
#"identity:list_roles": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_roles":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_roles":"role:reader and
# system_scope:all".
# The role API is now aware of system scope and default roles.

# Create role.
# POST  /v3/roles
# Intended scope(s): system
#"identity:create_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_role":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_role":"role:admin and
# system_scope:all".
# The role API is now aware of system scope and default roles.

# Update role.
# PATCH  /v3/roles/{role_id}
# Intended scope(s): system
#"identity:update_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_role":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_role":"role:admin and
# system_scope:all".
# The role API is now aware of system scope and default roles.

# Delete role.
# DELETE  /v3/roles/{role_id}
# Intended scope(s): system
#"identity:delete_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_role":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_role":"role:admin and
# system_scope:all".
# The role API is now aware of system scope and default roles.

# Show domain role.
# GET  /v3/roles/{role_id}
# HEAD  /v3/roles/{role_id}
# Intended scope(s): system
#"identity:get_domain_role": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_domain_role":"rule:admin_required" has been deprecated
# since T in favor of "identity:get_domain_role":"role:reader and
# system_scope:all".
# The role API is now aware of system scope and default roles.

# List domain roles.
# GET  /v3/roles?domain_id={domain_id}
# HEAD  /v3/roles?domain_id={domain_id}
# Intended scope(s): system
#"identity:list_domain_roles": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_domain_roles":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:list_domain_roles":"role:reader and system_scope:all".
# The role API is now aware of system scope and default roles.

# Create domain role.
# POST  /v3/roles
# Intended scope(s): system
#"identity:create_domain_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_domain_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:create_domain_role":"role:admin and system_scope:all".
# The role API is now aware of system scope and default roles.

# Update domain role.
# PATCH  /v3/roles/{role_id}
# Intended scope(s): system
#"identity:update_domain_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_domain_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:update_domain_role":"role:admin and system_scope:all".
# The role API is now aware of system scope and default roles.

# Delete domain role.
# DELETE  /v3/roles/{role_id}
# Intended scope(s): system
#"identity:delete_domain_role": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_domain_role":"rule:admin_required" has been
# deprecated since T in favor of
# "identity:delete_domain_role":"role:admin and system_scope:all".
# The role API is now aware of system scope and default roles.

# List role assignments.
# GET  /v3/role_assignments
# HEAD  /v3/role_assignments
# Intended scope(s): system, domain
#"identity:list_role_assignments": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.domain_id)s)"

# DEPRECATED
# "identity:list_role_assignments":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:list_role_assignments":"(role:reader and system_scope:all)
# or (role:reader and domain_id:%(target.domain_id)s)".
# The assignment API is now aware of system scope and default roles.

# List all role assignments for a given tree of hierarchical projects.
# GET  /v3/role_assignments?include_subtree
# HEAD  /v3/role_assignments?include_subtree
# Intended scope(s): system, domain, project
#"identity:list_role_assignments_for_tree": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.project.domain_id)s) or (role:admin and project_id:%(target.project.id)s)"

# DEPRECATED
# "identity:list_role_assignments_for_tree":"rule:admin_required" has
# been deprecated since T in favor of
# "identity:list_role_assignments_for_tree":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.project.domain_id)s) or (role:admin and
# project_id:%(target.project.id)s)".
# The assignment API is now aware of system scope and default roles.

# Show service details.
# GET  /v3/services/{service_id}
# Intended scope(s): system
#"identity:get_service": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_service":"rule:admin_required" has been deprecated
# since S in favor of "identity:get_service":"role:reader and
# system_scope:all".
# The service API is now aware of system scope and default roles.

# List services.
# GET  /v3/services
# Intended scope(s): system
#"identity:list_services": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_services":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_services":"role:reader and
# system_scope:all".
# The service API is now aware of system scope and default roles.

# Create service.
# POST  /v3/services
# Intended scope(s): system
#"identity:create_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_service":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_service":"role:admin and
# system_scope:all".
# The service API is now aware of system scope and default roles.

# Update service.
# PATCH  /v3/services/{service_id}
# Intended scope(s): system
#"identity:update_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_service":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_service":"role:admin and
# system_scope:all".
# The service API is now aware of system scope and default roles.

# Delete service.
# DELETE  /v3/services/{service_id}
# Intended scope(s): system
#"identity:delete_service": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_service":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_service":"role:admin and
# system_scope:all".
# The service API is now aware of system scope and default roles.

# Create federated service provider.
# PUT  /v3/OS-FEDERATION/service_providers/{service_provider_id}
# Intended scope(s): system
#"identity:create_service_provider": "role:admin and system_scope:all"

# DEPRECATED
# "identity:create_service_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:create_service_provider":"role:admin and
# system_scope:all".
# The service provider API is now aware of system scope and default
# roles.

# List federated service providers.
# GET  /v3/OS-FEDERATION/service_providers
# HEAD  /v3/OS-FEDERATION/service_providers
# Intended scope(s): system
#"identity:list_service_providers": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_service_providers":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:list_service_providers":"role:reader and
# system_scope:all".
# The service provider API is now aware of system scope and default
# roles.

# Get federated service provider.
# GET  /v3/OS-FEDERATION/service_providers/{service_provider_id}
# HEAD  /v3/OS-FEDERATION/service_providers/{service_provider_id}
# Intended scope(s): system
#"identity:get_service_provider": "role:reader and system_scope:all"

# DEPRECATED
# "identity:get_service_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:get_service_provider":"role:reader and system_scope:all".
# The service provider API is now aware of system scope and default
# roles.

# Update federated service provider.
# PATCH  /v3/OS-FEDERATION/service_providers/{service_provider_id}
# Intended scope(s): system
#"identity:update_service_provider": "role:admin and system_scope:all"

# DEPRECATED
# "identity:update_service_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:update_service_provider":"role:admin and
# system_scope:all".
# The service provider API is now aware of system scope and default
# roles.

# Delete federated service provider.
# DELETE  /v3/OS-FEDERATION/service_providers/{service_provider_id}
# Intended scope(s): system
#"identity:delete_service_provider": "role:admin and system_scope:all"

# DEPRECATED
# "identity:delete_service_provider":"rule:admin_required" has been
# deprecated since S in favor of
# "identity:delete_service_provider":"role:admin and
# system_scope:all".
# The service provider API is now aware of system scope and default
# roles.

# DEPRECATED
# "identity:revocation_list" has been deprecated since T.
# The identity:revocation_list policy isn't used to protect any APIs
# in keystone now that the revocation list API has been deprecated and
# only returns a 410 or 403 depending on how keystone is configured.
# This policy can be safely removed from policy files.
# List revoked PKI tokens.
# GET  /v3/auth/tokens/OS-PKI/revoked
# Intended scope(s): system, project
#"identity:revocation_list": "rule:service_or_admin"

# Check a token.
# HEAD  /v3/auth/tokens
# Intended scope(s): system, domain, project
#"identity:check_token": "(role:reader and system_scope:all) or rule:token_subject"

# DEPRECATED
# "identity:check_token":"rule:admin_or_token_subject" has been
# deprecated since T in favor of "identity:check_token":"(role:reader
# and system_scope:all) or rule:token_subject".
# The token API is now aware of system scope and default roles.

# Validate a token.
# GET  /v3/auth/tokens
# Intended scope(s): system, domain, project
#"identity:validate_token": "(role:reader and system_scope:all) or rule:service_role or rule:token_subject"

# DEPRECATED
# "identity:validate_token":"rule:service_admin_or_token_subject" has
# been deprecated since T in favor of
# "identity:validate_token":"(role:reader and system_scope:all) or
# rule:service_role or rule:token_subject".
# The token API is now aware of system scope and default roles.

# Revoke a token.
# DELETE  /v3/auth/tokens
# Intended scope(s): system, domain, project
#"identity:revoke_token": "(role:admin and system_scope:all) or rule:token_subject"

# DEPRECATED
# "identity:revoke_token":"rule:admin_or_token_subject" has been
# deprecated since T in favor of "identity:revoke_token":"(role:admin
# and system_scope:all) or rule:token_subject".
# The token API is now aware of system scope and default roles.

# Create trust.
# POST  /v3/OS-TRUST/trusts
# Intended scope(s): project
#"identity:create_trust": "user_id:%(trust.trustor_user_id)s"

# List trusts.
# GET  /v3/OS-TRUST/trusts
# HEAD  /v3/OS-TRUST/trusts
# Intended scope(s): system
#"identity:list_trusts": "role:reader and system_scope:all"

# DEPRECATED
# "identity:list_trusts":"rule:admin_required" has been deprecated
# since T in favor of "identity:list_trusts":"role:reader and
# system_scope:all".
# The trust API is now aware of system scope and default roles.

# List trusts for trustor.
# GET  /v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id}
# HEAD  /v3/OS-TRUST/trusts?trustor_user_id={trustor_user_id}
# Intended scope(s): system, project
#"identity:list_trusts_for_trustor": "role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s"

# List trusts for trustee.
# GET  /v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id}
# HEAD  /v3/OS-TRUST/trusts?trustee_user_id={trustee_user_id}
# Intended scope(s): system, project
#"identity:list_trusts_for_trustee": "role:reader and system_scope:all or user_id:%(target.trust.trustee_user_id)s"

# List roles delegated by a trust.
# GET  /v3/OS-TRUST/trusts/{trust_id}/roles
# HEAD  /v3/OS-TRUST/trusts/{trust_id}/roles
# Intended scope(s): system, project
#"identity:list_roles_for_trust": "role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s or user_id:%(target.trust.trustee_user_id)s"

# DEPRECATED
# "identity:list_roles_for_trust":"user_id:%(target.trust.trustor_user
# _id)s or user_id:%(target.trust.trustee_user_id)s" has been
# deprecated since T in favor of
# "identity:list_roles_for_trust":"role:reader and system_scope:all or
# user_id:%(target.trust.trustor_user_id)s or
# user_id:%(target.trust.trustee_user_id)s".
# The trust API is now aware of system scope and default roles.

# Check if trust delegates a particular role.
# GET  /v3/OS-TRUST/trusts/{trust_id}/roles/{role_id}
# HEAD  /v3/OS-TRUST/trusts/{trust_id}/roles/{role_id}
# Intended scope(s): system, project
#"identity:get_role_for_trust": "role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s or user_id:%(target.trust.trustee_user_id)s"

# DEPRECATED
# "identity:get_role_for_trust":"user_id:%(target.trust.trustor_user_i
# d)s or user_id:%(target.trust.trustee_user_id)s" has been deprecated
# since T in favor of "identity:get_role_for_trust":"role:reader and
# system_scope:all or user_id:%(target.trust.trustor_user_id)s or
# user_id:%(target.trust.trustee_user_id)s".
# The trust API is now aware of system scope and default roles.

# Revoke trust.
# DELETE  /v3/OS-TRUST/trusts/{trust_id}
# Intended scope(s): system, project
#"identity:delete_trust": "role:admin and system_scope:all or user_id:%(target.trust.trustor_user_id)s"

# DEPRECATED
# "identity:delete_trust":"user_id:%(target.trust.trustor_user_id)s"
# has been deprecated since T in favor of
# "identity:delete_trust":"role:admin and system_scope:all or
# user_id:%(target.trust.trustor_user_id)s".
# The trust API is now aware of system scope and default roles.

# Get trust.
# GET  /v3/OS-TRUST/trusts/{trust_id}
# HEAD  /v3/OS-TRUST/trusts/{trust_id}
# Intended scope(s): system, project
#"identity:get_trust": "role:reader and system_scope:all or user_id:%(target.trust.trustor_user_id)s or user_id:%(target.trust.trustee_user_id)s"

# DEPRECATED
# "identity:get_trust":"user_id:%(target.trust.trustor_user_id)s or
# user_id:%(target.trust.trustee_user_id)s" has been deprecated since
# T in favor of "identity:get_trust":"role:reader and system_scope:all
# or user_id:%(target.trust.trustor_user_id)s or
# user_id:%(target.trust.trustee_user_id)s".
# The trust API is now aware of system scope and default roles.

# Show user details.
# GET  /v3/users/{user_id}
# HEAD  /v3/users/{user_id}
# Intended scope(s): system, domain, project
#"identity:get_user": "(role:reader and system_scope:all) or (role:reader and token.domain.id:%(target.user.domain_id)s) or user_id:%(target.user.id)s"

# DEPRECATED
# "identity:get_user":"rule:admin_or_owner" has been deprecated since
# S in favor of "identity:get_user":"(role:reader and
# system_scope:all) or (role:reader and
# token.domain.id:%(target.user.domain_id)s) or
# user_id:%(target.user.id)s".
# The user API is now aware of system scope and default roles.

# List users.
# GET  /v3/users
# HEAD  /v3/users
# Intended scope(s): system, domain
#"identity:list_users": "(role:reader and system_scope:all) or (role:reader and domain_id:%(target.domain_id)s)"

# DEPRECATED
# "identity:list_users":"rule:admin_required" has been deprecated
# since S in favor of "identity:list_users":"(role:reader and
# system_scope:all) or (role:reader and
# domain_id:%(target.domain_id)s)".
# The user API is now aware of system scope and default roles.

# List all projects a user has access to via role assignments.
# GET   /v3/auth/projects
#"identity:list_projects_for_user": ""

# List all domains a user has access to via role assignments.
# GET  /v3/auth/domains
#"identity:list_domains_for_user": ""

# Create a user.
# POST  /v3/users
# Intended scope(s): system, domain
#"identity:create_user": "(role:admin and system_scope:all) or (role:admin and token.domain.id:%(target.user.domain_id)s)"

# DEPRECATED
# "identity:create_user":"rule:admin_required" has been deprecated
# since S in favor of "identity:create_user":"(role:admin and
# system_scope:all) or (role:admin and
# token.domain.id:%(target.user.domain_id)s)".
# The user API is now aware of system scope and default roles.

# Update a user, including administrative password resets.
# PATCH  /v3/users/{user_id}
# Intended scope(s): system, domain
#"identity:update_user": "(role:admin and system_scope:all) or (role:admin and token.domain.id:%(target.user.domain_id)s)"

# DEPRECATED
# "identity:update_user":"rule:admin_required" has been deprecated
# since S in favor of "identity:update_user":"(role:admin and
# system_scope:all) or (role:admin and
# token.domain.id:%(target.user.domain_id)s)".
# The user API is now aware of system scope and default roles.

# Delete a user.
# DELETE  /v3/users/{user_id}
# Intended scope(s): system, domain
#"identity:delete_user": "(role:admin and system_scope:all) or (role:admin and token.domain.id:%(target.user.domain_id)s)"

# DEPRECATED
# "identity:delete_user":"rule:admin_required" has been deprecated
# since S in favor of "identity:delete_user":"(role:admin and
# system_scope:all) or (role:admin and
# token.domain.id:%(target.user.domain_id)s)".
# The user API is now aware of system scope and default roles.
```

​                                                    