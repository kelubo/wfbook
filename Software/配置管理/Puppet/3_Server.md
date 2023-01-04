# Puppet Server

[TOC]

## 控制服务

Puppet Server 服务名称为 `puppetserver` 。要启动和停止服务，请使用命令：

```bash
service puppetserver restart
service puppetserver status
```

## 运行环境

Puppet Server 由几个相关服务组成。这些服务在它们之间共享状态和路由请求。这些服务使用 Trapperkeeper 服务框架在单个 JVM 进程内运行。

### 嵌入式 Web 服务器

Puppet Server uses a Jetty-based web server embedded in the service's JVM process.使用嵌入服务的 JVM 进程中的基于 Jetty 的 web 服务器。配置和启用 web 服务器不需要额外或唯一的操作。可以在 `webserver.conf` 中修改 web 服务器的设置。如果使用外部 CA 或在非标准端口上运行 Puppet ，则可能需要编辑此文件。

### Puppet API 服务

Puppet Server 提供了 API ，Puppet 代理使用其用来管理节点配置。

### 证书颁发机构服务

Puppet Server 包括一个证书颁发机构 (CA) 服务，该服务：

- 接受来自节点的证书签名请求（CSR）。
- 向节点提供证书和证书吊销列表（CRL）。
- 可选，接受签署或吊销证书的命令。

默认情况下，将禁用通过网络签署和吊销证书。可以使用 `auth.conf` 文件允许特定证书所有者发出命令。

CA 服务使用 `.pem` 文件存储凭据。可以使用 `puppetserver ca` 命令与这些凭据交互，包括列出、签署和吊销证书。

### Admin API 服务

Puppet Server 包含用于触发维护任务的管理 API 。最常见的任务是刷新 Puppet 的环境缓存，这会导致所有 Puppet 代码重新加载，而无需重新启动服务。Consequently, you can deploy new  code to long-timeout environments without executing a full restart of  the service.因此，您可以将新代码部署到长超时环境，而无需执行服务的完全重新启动。

## JRuby 解释器

Puppet Server 的大部分工作是由 JRuby 中运行的 Ruby 代码完成的。JRuby 是在 JVM 上运行的 Ruby 解释器的一个实现。注意，不能使用系统 gem 命令为 Puppet 主服务器安装 Ruby Gem 。相反，Puppet Server 包含一个单独的 puppetserver gem 命令，用于安装 Puppet 扩展可能需要的任何库。

如果您想测试或调试 Puppet Server 使用的代码，可以使用 `puppetserver ruby` 和 `puppetserver irb` 命令在 JRuby 环境中执行 Ruby 代码。

为了处理来自代理节点的并行请求，Puppet Server 维护单独的 JRuby 解释器。这些 JRuby 解释器分别运行 Puppet 的应用程序代码，并在它们之间分发代理请求。您可以在 puppetserver.conf 的 `jruby-puppet` 部分配置 JRuby 解释器。

## 调整指南

可以通过调整 JRuby 配置来最大化 Puppet Server 的性能。

## User

如果您正在运行 Puppet Enterprise：

- Puppet Server user runs as `pe-puppet`.
- You must specify the user in `/etc/sysconfig/pe-puppetserver`.

如果您正在运行 open source Puppet:

- Puppet Server needs to run as the user `puppet`.
- You must specify the user in `/etc/sysconfig/puppetserver`.

该用户必须可读写 Puppet Server 的所有文件和目录。注意，Puppet Server 忽略 `puppet.conf` 中的 `user` 和 `group` 设置。

## 端口

默认情况下，Puppet 的 HTTPS 流量使用端口 8140 。操作系统和防火墙必须允许 Puppet 服务器的 JVM 进程接受端口 8140 上的传入连接。如有必要，可以在 `webserver.conf` 中更改端口。

## 日志

所有 Puppet 服务器的日志记录都通过 JVM  Logback 库进行路由。默认情况下，它会记录到 `/var/log/puppetlabs/puppetserver/puppetserver.log` 。默认日志级别为 “INFO” 。默认情况下，Puppet  Server 不向 `syslog` 发送任何内容。所有日志消息都遵循相同的路径，包括 HTTP 流量、目录编译、证书处理以及 Puppet Server 工作的所有其他部分。

Puppet Server 还依赖 Logback 来管理、旋转和归档服务器日志文件。Logback 在服务器日志超过 200MB 时对其进行存档。此外，当所有服务器日志的总大小超过 1GB 时，Logback 会自动删除最旧的日志。Logback 具有高度可配置性。

Finally, any errors that cause the logging system to die or occur before logging is set up, display in `journalctl`.最后，在日志记录设置之前，任何导致日志记录系统死亡或发生的错误都将显示在journalctl中。

## SSL Termination

默认情况下，Puppet Server 自动处理 SSL termination 。For network configurations that require external SSL termination (e.g.  with a hardware load balancer). 对于需要外部SSL终端的网络配置（例如，使用硬件负载平衡器），需要额外的配置。总之，您必须：

- Configure Puppet Server to use HTTP instead of HTTPS.将Puppet Server配置为使用HTTP而不是HTTPS。
- Configure Puppet Server to accept SSL information via insecure HTTP headers.配置Puppet Server以通过不安全的HTTP头接受SSL信息。
- Secure your network so that Puppet Server **cannot** be directly reached by **any** untrusted clients.保护您的网络，使任何不受信任的客户端都无法直接访问木偶服务器。
- Configure your SSL terminating proxy to set the following HTTP headers:配置SSL终止代理以设置以下HTTP标头：
  - `X-Client-Verify` (mandatory).X-Client-Verify（强制）。
  - `X-Client-DN` (mandatory for client-verified requests).X-Client-DN（客户端验证请求必须填写）。
  - `X-Client-Cert` (optional; required for [trusted facts](https://puppet.com/docs/puppet/latest/lang_facts_and_builtin_vars.html)).X-Client-Cert（可选；可信事实需要）。

## Deprecated features

以下功能和配置设置已弃用，并将在 Puppet Server 的未来主要版本中删除。

### `certificate-status` 设置

#### 现在

如果 `certificate-authority.certificate-status.authorization-required` 设置为 `false` ，all requests that are successfully validated by SSL (if applicable for the port settings on the server) are permitted to use the [Certificate Status](https://github.com/puppetlabs/puppet/blob/master/api/docs/http_certificate_status.md) HTTP API endpoints.  则允许通过SSL成功验证的所有请求（如果适用于服务器上的端口设置）使用证书状态HTTP API端点。这包括不提供 SSL 客户端证书的请求。

如果 `certificate-authority.certificate-status.authorization-required` 设置为 `true` 或未指定，并且 `puppet-admin.client-whitelist` 设置具有一个或多个条目，only the requests whose Common Name in the SSL client certificate subject matches one of the `client-whitelist` entries are permitted to use the certificate status HTTP API endpoints.则仅允许SSL客户端证书主题中的公共名称与其中一个客户端白名单条目匹配的请求使用证书状态HTTP API端点。

For any other configuration, requests are only permitted to access the certificate status HTTP API endpoints if allowed per the rule definitions in the `trapperkeeper-authorization` "auth.conf" file.  对于任何其他配置，如果trapperkeeper授权“auth.conf”文件中的规则定义允许，则只允许请求访问证书状态HTTP API端点。

#### 在未来的主要版本中

Puppet 服务器将完全忽略 `certificate-status` 设置。Requests made to the `certificate-status` HTTP API will only be allowed per the `trapperkeeper-authorization` "auth.conf" configuration.根据trapperkeeper授权“auth.conf”配置，只允许对证书状态HTTP API进行请求。

#### 检测和更新

Look at the `certificate-status` settings in your configuration.  If `authorization-required` is set to `false` or `client-whitelist` has one or more entries, these settings would be used to authorize access to the certificate status HTTP API instead of `trapperkeeper-authorization`.查看配置中的证书状态设置。如果所需的授权设置为false或客户端白名单有一个或多个条目，则这些设置将用于授权访问证书状态HTTP API，而不是trapperkeeper授权。

If `authorization-required` is set to `true` or is not specified and if the `client-whitelist` was empty, you could just remove the `certificate-authority` section from your configuration.  The only behavior that would change in Puppet Server from doing this would be that a warning message would no longer be written to the "puppetserver.log" file at startup.如果所需授权设置为true或未指定，并且客户端白名单为空，则可以从配置中删除证书颁发机构部分。在puppetserver中，唯一会改变的行为是在启动时不再将警告消息写入“puppetserver.log”文件。

If `authorization-required` is set to `false`, you would need to create a corresponding rule in the `trapperkeeper-authorization` file which would allow unauthenticated client access to the certificate status API.如果所需授权设置为false，则需要在trapperkeeper授权文件中创建相应的规则，以允许未经身份验证的客户端访问证书状态API。

例如：

```json
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
}
```

If `authorization-required` is set to `true` or not set but the `client-whitelist` has one or more custom entries in it, you would need to create a corresponding rule in the `trapperkeeper-authorization` "auth.conf" file which would allow only specific clients access to the certificate status API.如果所需授权设置为true或未设置，但客户端白名单中有一个或多个自定义条目，则需要在trapperkeeper授权“auth.conf”文件中创建相应的规则，该规则仅允许特定客户端访问证书状态API。

For example, the current certificate status configuration could have:例如，当前证书状态配置可能具有：

```
certificate-authority:
    certificate-status: {
        client-whitelist: [ admin1, admin2 ]
    }
}Copied!
```

Corresponding `trapperkeeper-authorization` rules could have:相应的trapperkeeper授权规则可能具有：

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

After adding the desired rules to the `trapperkeeper-authorization` "auth.conf" file, remove the `certificate-authority` section from the "puppetserver.conf" file and restart the puppetserver service.将所需的规则添加到trapperkeeper授权“auth.conf”文件后，从“puppe”中删除证书颁发机构部分

#### Context

In previous Puppet Server releases, there was no unified mechanism for controlling access to the various endpoints that Puppet Server hosts.  Puppet Server used core Puppet "auth.conf" to authorize requests handled via Ruby Puppet and custom client whitelists for the CA and Admin endpoints.  The custom client whitelists do not provide granular enough control to meet some use cases.在以前的PuppetServer版本中，没有统一的机制来控制对PuppetServerhost的各种端点的访问。Puppet服务器使用核心Puppet“auth.conf”来授权通过Ruby Puppet和CA和Admin端点的自定义客户端白名单处理的请求。自定义客户端白名单没有提供足够的粒度控制来满足某些用例。

`trapperkeeper-authorization` unifies authorization configuration across all of these endpoints into a single file and provides more granular control.

trapperkeeper授权将所有这些端点的授权配置统一到一个文件中，并提供更细粒度的控制。

### `puppet-admin` 设置

#### Now

If the `puppet-admin.authorization-required` setting is `false`, all requests that are successfully validated by SSL (if applicable for the port settings on the server) are permitted to use the `puppet-admin` HTTP API endpoints. This includes requests which do not provide an SSL client certificate.

If the `puppet-admin.authorization-required` setting is `true` or not specified and the `puppet-admin.client-whitelist` setting has one or more entries, only the requests whose Common Name in the SSL client certificate subject matches one of the `client-whitelist` entries are permitted to use the `puppet-admin` HTTP API endpoints.

For any other configuration, requests are only permitted to access the `puppet-admin` HTTP API endpoints if allowed per the rule definitions in the `trapperkeeper-authorization` "auth.conf" file.  See the [puppetserver "auth.conf"](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html) page for more information.

#### In a Future Major Release

The `puppet-admin` settings will be ignored completely by Puppet Server. Requests made to the `puppet-admin` HTTP API will only be allowed per the `trapperkeeper-authorization` "auth.conf" configuration.

#### Detecting and Updating

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

#### Context

In previous Puppet Server releases, there was no unified mechanism for controlling access to the various endpoints that Puppet Server hosts.  Puppet Server used core Puppet "auth.conf" to authorize requests handled by Ruby Puppet and custom client whitelists for the CA and Admin endpoints.  The custom client allowlists do not provide granular enough control to meet some use cases.

`trapperkeeper-authorization` unifies authorization configuration across all of these endpoints into a single file and provides more granular control.

### Puppet's "resource_types" API endpoint

#### Now

The `resource_type` and `resource_types` HTTP APIs were removed in Puppet Server 5.0.

#### Previously

The [`resource_type` and `resource_types` Puppet HTTP API endpoints](https://github.com/puppetlabs/docs-archive/blob/main/puppet/4.6/http_api/http_resource_type.md) return information about classes, defined types, and node definitions.

The [`environment_classes` HTTP API in Puppet Server](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html) serves as a replacement for the Puppet resource type API for classes.

#### Detecting and Updating

If your application calls the `resource_type` or `resource_types` HTTP API endpoints for information about classes, point those calls to the `environment_classes` endpoint. The `environment_classes` endpoint has different features and returns different values than `resource_type`; see the [changes in the environment classes API](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html) for details.

The `environment_classes`  endpoint ignores Puppet's Ruby-based authorization methods and  configuration in favor of Puppet Server's Trapperkeeper authorization.  For more information, see the ["Authorization" section](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html) of the environment classes API documentation.

#### Context

Users often rely on the `resource_types` endpoint for lists of classes and associated parameters in an environment. For such requests, the `resource_types` endpoint is inefficient and can trigger problematic events, such as [manifests being parsed during a catalog request](https://tickets.puppetlabs.com/browse/SERVER-1200).

To fulfill these requests more efficiently and safely, Puppet Server 2.3.0 introduced the narrowly defined `environment_classes` endpoint.

### Puppet's node cache terminus

#### Now

Puppet 5.0 (and by extension, Puppet Server 5.0) no longer writes node YAML files to its cache by default.

#### Previously

Puppet wrote YAML to its node cache.

#### Detecting and Updating

To retain the Puppet 4.x behavior, add the [`puppet.conf`](https://www.puppet.com/docs/puppet/7/server/configuration.html) setting `node_cache_terminus = write_only_yaml`. The `write_only_yaml` option is deprecated.

#### Context

This cache was used in workflows where  external tooling needs a list of nodes. PuppetDB is the preferred source of node information.

### JRuby's "compat-version" setting

#### Now

Puppet Server 5.0 removes the `jruby-puppet.compat-version` setting in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html), and exits the `puppetserver` service with an error if you start the service with that setting.

#### Previously

Puppet Server 2.7.x allowed you to set `compat-version` to `1.9` or `2.0` to choose a preferred Ruby interpreter version.

#### Detecting and Updating

Launching the `puppetserver` service with this setting enabled will cause it to exit with an error message. The error includes information on [switching from JRuby 1.7.x to JRuby 9k](https://www.puppet.com/docs/puppet/7/server/configuration.html).

For Ruby language 2.x support in Puppet Server, configure  Puppet Server to use JRuby 9k instead of JRuby 1.7.27. See the  "Configuring the JRuby Version" section of [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html) for details.

#### Context

Puppet Server 5.0 updated JRuby v1.7 to v1.7.27, which in turn updated the `jruby-openssl` gem to v0.9.19 and `bouncycastle` libraries to v1.55. JRuby 1.7.27 breaks setting `jruby-puppet.compat-version` to `2.0`.

Server 5.0 also added optional, experimental support for JRuby 9k, which includes Ruby 2.x language support.

## 主服务器和代理兼容性

使用此表验证您是否为 PE 或 Puppet 服务器使用了兼容版本的代理。

| Agent | Server                                                       |                                                              |                                                              |
| ----- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
|       | PE 2017.3 through 2018.1                                   Puppet 5.x | PE 2019.1 through 2019.8                                   Puppet 6.x | PE 2021.0 and later                                        Puppet 7.x |
| 5.x   | ✓                                                            | ✓                                                            |                                                              |
| 6.x   |                                                              | ✓                                                            | ✓                                                            |
| 7.x   |                                                              |                                                              | ✓                                                            |

> 注意：
>
> Puppet 5.x 已经到了生命的尽头，没有积极开发或测试。我们保留代理 5.x 与服务器的更高版本的兼容性，只是为了实现升级。

## 配置 Puppet 服务器

Puppet Server uses a combination of  Puppet's configuration files along with its own separate configuration  files, which are located in the `conf.d` directory. Puppet Server 使用 Puppet 的配置文件以及位于 conf.d 目录中的单独配置文件的组合。

### puppet.conf 设置

Puppet Server 使用 Puppet 的配置文件，包括 `puppet.conf` 中的大多数设置。Puppet Server treats some `puppet.conf` settings differently. 但是，Puppet服务器对一些Puppet..conf设置的处理方式不同。你必须意识到这些差异。You can  visit a complete list of these differences at Differing behavior in  puppet.conf. 您可以在puppet.conf中的Differencing behavior访问这些差异的完整列表。puppet  Server 会自动加载配置文件 `puppet.conf` 的 main 和 Server 部分中的设置。Puppet Server 使用 `server` 部分中的值，但如果它们不存在，则使用 `main` 部分中的数值。

Puppet 服务器接受以下 `puppet.conf` 设置：

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

### 配置文件

Puppet Server 的大部分配置文件和设置（日志配置文件除外）都在 `conf.d` 目录中。默认情况下， `conf.d` 目录位于 `/etc/puppetlabs/puppetserver/conf.d` 中。这些配置文件采用 HOCON 格式，保留了 JSON 的基本结构，但可读性更强。

启动时，Puppet Server 读取 `conf.d` 目录中的所有 `.conf` 文件。必须重新启动 Puppet Server 才能实现对这些文件的更改。`conf.d` 目录包含以下文件和设置：

* auth.conf
* ca.conf
* global.conf
* logback.xml
* metrics.conf
* product.conf
* puppetserver.conf
* web-routes.conf
* webserver.conf

**Note**: `product.conf` 文件是可选的，默认情况下不包含。可以在 `conf.d` 目录中创建 `product.conf` 文件，以配置与产品相关的设置（例如自动更新检查和分析数据收集）。

#### auth.conf

Puppet Server's `auth.conf` file contains rules for authorizing access to Puppet Server's HTTP API endpoints. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

The rules are defined in a file named `auth.conf`, and Puppet Server applies the settings when a request's endpoint matches a rule.

> **Note:** You can also use the [`puppetlabs-puppet_authorization`](https://forge.puppet.com/puppetlabs/puppet_authorization) module to manage the new `auth.conf` file's authorization rules in the new HOCON format, and the [`puppetlabs-hocon`](https://forge.puppet.com/puppetlabs/hocon) module to use Puppet to manage HOCON-formatted settings in general.

To configure how Puppet Server authenticates requests, use the supported HOCON `auth.conf` file and authorization methods, and see the parameters and rule definitions in the [HOCON Parameters](https://www.puppet.com/docs/puppet/7/server/config_file_auth.html#hocon-parameters) section.

You can find the Puppet Server auth.conf file [here](https://github.com/puppetlabs/puppetserver/blob/master/ezbake/config/conf.d/auth.conf).

##### HOCON example

Here is an example authorization section using the HOCON configuration format:

```json
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
}
```

For a more detailed example of how to use the HOCON configuration format, see [Configuring The Authorization Service](https://github.com/puppetlabs/trapperkeeper-authorization/blob/master/doc/authorization-config.md).

For descriptions of each setting, see the following sections.

##### HOCON parameters

Use the following parameters when writing or migrating custom authorization rules using the new HOCON format.

###### `version`

The `version` parameter is required. In this initial release, the only supported value is `1`.

###### `allow-header-cert-info`

> **Note:** Puppet Server ignores the setting of the same name in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html) in favor of this setting in the `auth.conf` file.

This optional `authorization` section parameter determines whether to enable [external SSL termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html) on all HTTP endpoints that Puppet Server handles, including the Puppet  API, the certificate authority API, and the Puppet Admin API. It also  controls how Puppet Server derives the user's identity for authorization purposes. The default value is `false`.

If this setting is `true`, Puppet Server ignores any presented certificate and relies completely on header data to authorize requests.

> **Warning!** This is very insecure; **do not enable this parameter** unless you've secured your network to prevent **any** untrusted access to Puppet Server.

You cannot rename any of the `X-Client` headers when this setting is enabled, and you must specify identity through the `X-Client-Verify`, `X-Client-DN`, and `X-Client-Cert` headers.

For more information, see [External SSL Termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html#disable-https-for-puppet-server) in the Puppet Server documentation and [Configuring the Authorization Service](https://github.com/puppetlabs/trapperkeeper-authorization/blob/master/doc/authorization-config.md#allow-header-cert-info) in the `trapperkeeper-authorization` documentation.

###### `rules`

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

###### `match-request`

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

###### `allow`, `allow-unauthenticated`, and `deny`

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

###### `sort-order`

After each rule's `match-request` section, the required `sort-order` parameter sets the order in which Puppet Server evaluates the rule by  prioritizing it on a numeric value between 1 and 399 (to be evaluated  before default Puppet rules) or 601 to 998 (to be evaluated after  Puppet), with lower-numbered values evaluated first. Puppet Server  secondarily sorts rules lexicographically by the `name` string value's Unicode code points.

```
sort-order: 1Copied!
```

###### `name`

After each rule's `match-request` section, this required parameter's unique string value identifies the rule to Puppet Server. The `name` value is also written to server logs and error responses returned to unauthorized clients.

```
name: "my path"Copied!
```

> **Note:** If multiple rules have the same `name` value, Puppet Server will fail to launch.

#### ca.conf

The `ca.conf` file configures settings for the Puppet Server Certificate Authority (CA) service. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

##### Signing settings

The `allow-subject-alt-names` setting in the `certificate-authority` section enables you to sign certificates with subject alternative  names. It is false by default for security reasons but can be enabled if you need to sign certificates with subject alternative names. Be aware  that enabling the setting could allow agent nodes to impersonate other  nodes (including the nodes that already have signed certificates).  Consequently, you must carefully inspect any CSRs with SANs attached. `puppet cert sign` previously allowed this via a flag, but `puppetserver ca sign` requires it to be configured in the config file.

The `allow-authorization-extensions` setting in the `certificate-authority` section also enables you to sign certs with authorization extensions.  It is false by default for security reasons, but can be enabled if you  know you need to sign certificates this way. `puppet cert sign` used to allow this via a flag, but `puppetserver ca sign` requires it to be configued in the config file.

##### Infrastructure CRL settings

Puppet Server is able to create a  separate CRL file containing only revocations of Puppet infrastructure  nodes. This behavior is turned off by default. To enable it, set `certificate-authority.enable-infra-crl` to `true`.

#### global.conf

The `global.conf` file contains global configuration settings for Puppet Server. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

You shouldn't typically need to make changes to this file. However, you can change the `logging-config` path for the logback logging configuration file if necessary. For more information about the logback file, see http://logback.qos.ch/manual/configuration.html.

```
global: {
    logging-config: /etc/puppetlabs/puppetserver/logback.xml
}
```

#### logback.xml

Puppet Server’s logging is routed through the Java Virtual Machine's [Logback library](http://logback.qos.ch/) and configured in an XML file typically named `logback.xml`.

> **Note:** This document covers  basic, commonly modified options for Puppet Server logs. Logback is a  powerful library with many options. For detailed information on  configuring Logback, see the [Logback Configuration Manual](http://logback.qos.ch/manual/configuration.html).
>
> For advanced logging configuration tips specific to Puppet  Server, such as configuring Logstash or outputting logs in JSON format,  see [Advanced Logging Configuration](https://www.puppet.com/docs/puppet/7/server/config_logging_advanced.html).

##### Puppet Server logging

By default, Puppet Server logs messages and errors to `/var/log/puppetlabs/puppetserver/puppetserver.log`. The default log level is ‘INFO’, and Puppet Server sends nothing to `syslog`. You can change Puppet Server's logging behavior by editing `/etc/puppetlabs/puppetserver/logback.xml`, and you can specify a different Logback config file in [`global.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#globalconf).

You can restart the `puppetserver` service for changes to take effect, or enable [configuration scanning](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html#scan-and-scanperiod) to allow changes to be recognized at runtime.

Puppet Server also relies on Logback to manage, rotate, and archive Server log files. Logback archives Server logs when they exceed 10MB, and when the total size of all Server logs exceeds 1GB, it  automatically deletes the oldest logs.

###### Settings

`level`

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

###### Logging location

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

`scan` and `scanPeriod`

Logback supports noticing and reloading configuration changes without requiring a restart, a feature Logback calls **scanning**. To enable this, set the `scan` and `scanPeriod` attributes in the `<configuration>` element of `logback.xml`:

```
<configuration scan="true" scanPeriod="60 seconds">Copied!
```

Due to a [bug in Logback](https://tickets.puppetlabs.com/browse/TK-426), the `scanPeriod` must be set to a value; setting only `scan="true"` will not enable configuration scanning. Scanning is enabled by default in the `logback.xml` configuration packaged with Puppet Server.

**Note:** The HTTP request log does not currently support the scan feature. Adding the `scan` or `scanPeriod` settings to `request-logging.xml` will have no effect.

##### HTTP request logging

Puppet Server logs HTTP traffic separately, and this logging is configured in a different Logback configuration file located at `/etc/puppetlabs/puppetserver/request-logging.xml`. To specify a different Logback configuration file, change the `access-log-config` setting in Puppet Server's [`webserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html) file.

The HTTP request log uses the same Logback configuration  format and settings as the Puppet Server log. It also lets you configure what it logs using patterns, which follow Logback's [`PatternLayout` format](http://logback.qos.ch/manual/layouts.html#AccessPatternLayout).

#### metrics.conf

The `metrics.conf` file configures Puppet Server's [metrics services](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html) and [v2 metrics API](https://www.puppet.com/docs/puppet/7/server/metrics-api/v2/metrics_api.html).

##### Settings

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

##### Example

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

#### product.conf

The `product.conf` file contains settings that determine how Puppet Server interacts with  Puppet, Inc., such as automatic update checking and analytics data  collection.

##### Settings

The `product.conf` file doesn't exist in a default Puppet Server installation; to configure its settings, you must create it in Puppet Server's `conf.d` directory (located by default at `/etc/puppetlabs/puppetserver/conf.d`). This file is a [HOCON-formatted](https://github.com/typesafehub/config/blob/master/HOCON.md) configuration file with the following settings:

- Settings in the `product` section configure update checking and analytics data collection:

  - `check-for-updates`: If set to `false`, Puppet Server will not automatically check for updates, and will not send analytics data to Puppet.

    If this setting is unspecified (default) or set to `true`, Puppet Server checks for updates upon start or restart, and every 24  hours thereafter, by sending the following data to Puppet:

    - Product name
    - Puppet Server version
    - IP address
    - Data collection timestamp

    Puppet requests this data as one of the many ways we learn  about and work with our community. The more we know about how you use  Puppet, the better we can address your needs. No personally identifiable information is collected, and the data we collect is never used or  shared outside of Puppet.

##### Example

```
# Disabling automatic update checks and corresponding analytic data collection

product: {
    check-for-updates: false
}
```

#### puppetserver.conf

The `puppetserver.conf` file contains settings for the Puppet Server application. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html).

##### Settings

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

##### Examples

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

#### web-routes.conf

The `web-routes.conf` file configures the Puppet Server `web-router-service`, which sets mount points for Puppet Server's web applications. You  should not modify these mount points, because Puppet agents rely on  Puppet Server mounting them to specific URLs.

For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html). To configure the `webserver` service, see the [`webserver.conf` documentation](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html).

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

#### webserver.conf

The `webserver.conf` file configures the Puppet Server `webserver` service. For an overview, see [Puppet Server Configuration](https://www.puppet.com/docs/puppet/7/server/configuration.html). To configure the mount points for the Puppet administrative API web applications, see the [`web-routes.conf` documentation](https://www.puppet.com/docs/puppet/7/server/config_file_web-routes.html).



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

### 日志

有一个 Logback 配置文件，用于控制 Puppet Server 的日志记录方式。它的默认位置位于 `/etc/puppetlabs/puppetserver/logback.xml` 。

#### HTTP 流量

Puppet Server 以类似于 Apache 的格式将 HTTP 流量记录到一个单独的文件中，该文件不是主日志文件。默认情况下，访问日志位于 `/var/log/puppetlabs/puppetserver/puppetserver-access.log` 。

默认情况下，为每个 HTTP 请求记录以下信息：

- remote host远程主机
- remote log name远程日志名称
- remote user远程用户
- date of the logging event日志记录事件的日期
- URL requested请求的URL
- status code of the request请求的状态代码
- response content length响应内容长度
- remote IP address远程IP地址
- local port本地端口
- elapsed time to serve the request, in milliseconds服务请求所用的时间（毫秒）

有一个 Logback 配置文件控制 Puppet Server 的日志记录行为。其默认位置位于 `/etc/puppetlabs/puppetserver/request-logging.xml` 。

#### 认证

要启用与 `auth.conf` 相关的其他日志记录，编辑 Puppet Server 的 `logback.xml` 文件。默认情况下，当请求被拒绝时，只记录一条消息。

To enable a one-time logging of the parsed and transformed `auth.conf` file, add the following to Puppet Server's `logback.xml` file:要启用解析和转换的auth.conf文件的一次性日志记录，请将以下内容添加到Puppet Server的logback.xml文件中：

```xml
<logger name="puppetlabs.trapperkeeper.services.authorization.authorization-service" level="DEBUG"/>
```

To enable rule-by-rule logging for each request as it's checked for authorization, add the following to Puppet Server's `logback.xml` file:要在检查授权时为每个请求启用逐规则日志记录，请将以下内容添加到Puppet Server的logback.xml文件中：

```xml
<logger name="puppetlabs.trapperkeeper.authorization.rules" level="TRACE"/>
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
   {% endraw %}
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

### Service Bootstrapping服务引导

Puppet Server 构建在开源的 Clojure 应用程序框架 Trapperkeeper 之上。

One of the features that Trapperkeeper provides is the  ability to enable or disable individual services that an application  provides. Trapperkeeper 提供的功能之一是启用或禁用应用程序提供的单个服务的能力。在 Puppet Server 中，您可以使用此功能启用或禁用 CA 服务。默认情况下会启用 CA 服务，但如果您正在运行多服务器环境或使用外部 CA，则可能需要在某些节点上禁用 CA 服务。

The service bootstrap configuration files are in two locations:服务引导配置文件位于两个位置：

- `/etc/puppetlabs/puppetserver/services.d/`: For services that users are expected to manually configure if necessary, such as CA-related services.用于用户需要手动配置的服务，如CA相关服务。
- `/opt/puppetlabs/server/apps/puppetserver/config/services.d/`: For services users shouldn’t need to configure.对于服务，用户不需要进行配置。

Any files with a `.cfg` extension in either of these locations are combined to form the final set of services Puppet Server will use.这些位置中任何一个扩展名为.cfg的文件都将被合并，以形成PuppetServer将使用的最终服务集。

The CA-related configuration settings are set in `/etc/puppetlabs/puppetserver/services.d/ca.cfg`. If services added in future versions have user-configurable settings,  the configuration files will also be in this directory. When upgrading  Puppet Server with a package manager, it should not overwrite files  already in this directory.CA 相关的配置设置设置在/etc/puppetlabs/puppetserver/services.d/CA.cfg中。如果在未来版本中添加的服务具有用户可配置的设置，则配置文件也将在此目录中。使用包管理器升级Puppet Server时，它不应覆盖此目录中已存在的文件。

在 `ca.cfg` 文件中，find and modify these lines as directed to enable or disable the service:按照指示查找并修改这些行以启用或禁用服务：

```bash
# To enable the CA service, leave the following line uncommented
puppetlabs.services.ca.certificate-authority-service/certificate-authority-service
# To disable the CA service, comment out the above line and uncomment the line below
#puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service
```

### 添加 Java JAR

Puppet Server 可以在其初始启动时加载任何提供的 Java  jar 。启动后，Puppet Server 会自动将 `/opt/puppetlabs/server/data/puppetserver/jars` 中的任何 JAR 加载到 `classpath` 中。升级 Puppet 服务器时，此处放置的 JAR 不会被修改或删除。

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
2014-10-25 18:04:26,149 DEBUG [clojure-agent-send-pool-0] [p.s.j.jruby-puppet-agents] Initializing JRubyPuppet instances with the following settings:
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

# Infrastructure certificate revocation list (CRL)

The Puppet Server CA can create a CRL that contains only  revocations of those nodes that agents are expected to talk to during  normal operations, for example, compilers or hosts that agents connect  to as part of agent-side functions. Puppet Server CA can distribute that CRL to agents, rather than the CRL it maintains with all node  revocations.

To create a smaller CRL, manage the content of the file at `$cadir/infra_inventory.txt`. Provide a newline-separated list of the certnames. When revoked, they  are added to the Infra CRL. The certnames must match existing  certificates issued and maintained by the Puppet Server CA. Setting the  value `certificate-authority.enable-infra-crl` to `true` causes Puppet Server to update both its Full CRL and its Infra CRL with the certs that match those certnames when revoked. When agents first  check in, they receive a CRL that includes only the revocations of  certnames listed in the `infra_inventory.txt`.

The infrastructure certificate revocation list is disabled by default in open source Puppet. To toggle it, update `enable-infra-crl` in the `certificate-authority` section of `puppetserver.conf`.

This feature is disabled by default because the definition  of what constitutes an "infrastructure" node is site-specific and sites  with a standard, single primary server configuration have no need for  the additional work. After having enabled the feature, if you want to go back, remove the explicit setting and reload Puppet Server to turn the  default off; then, when agents first check, they receive the Full CRL as before (including any infrastructure nodes that were revoked while the  feature was enabled).

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

# Monitoring Puppet Server metrics

### Sections

[Getting started with Graphite](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#getting-started-with-graphite)

- [Using the `grafanadash` module to quickly set up a Graphite demo server](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#using-the-grafanadash-module-to-quickly-set-up-a-graphite-demo-server)
- [Enabling Puppet Server's Graphite support](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#enabling-puppet-servers-graphite-support)
- [Using the sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#using-the-sample-grafana-dashboard)
- [Example Grafana dashboard excerpt](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#example-grafana-dashboard-excerpt)

[Available Graphite metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#available-graphite-metrics)

- [Statistical metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#statistical-metrics)
- [Counters only](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#counters-only)
- [Other metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#other-metrics)
- [Modifying Puppet Server's exported metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#modifying-puppet-servers-exported-metrics)

Puppet Server tracks several advanced performance and health metrics, all of which take advantage of the [metrics API](https://www.puppet.com/docs/puppet/7/server/metrics-api/v1/metrics_api.html). You can track these metrics using:

- Customizable, networked [Graphite and Grafana instances](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#getting-started-with-graphite)
- [HTTP client metrics](https://www.puppet.com/docs/puppet/7/server/http_client_metrics.html)
- [Metrics API](https://www.puppet.com/docs/puppet/7/server/metrics-api/v1/metrics_api.html) endpoints

To visualize Puppet Server metrics, either:

- Use the [puppet-operational-dashboards module](https://forge.puppet.com/modules/puppetlabs/puppet_operational_dashboards).
- Export them to a Graphite installation. The [grafanadash](https://forge.puppet.com/puppetlabs/grafanadash) module helps you set up a Graphite instance, configure Puppet Server  for exporting to it, and visualize the output with Grafana. You can  later integrate this with your Graphite installation. For more  information, see Getting started with Graphite below.

The `puppet-operational-dashboards` module is recommended for FOSS users, because it is an easier way to save and visualize Puppet Server metrics. The `grafanadash` module is still useful for users exporting to their existing Graphite installation.

> **Note:** The `grafanadash` and `puppet-graphite` modules referenced in this document are *not* Puppet-supported modules. They are provided as testing and demonstration purposes *only*.

## Getting started with Graphite

[Graphite](https://graphiteapp.org) is a third-party monitoring application that stores real-time metrics  and provides customizable ways to view them. Puppet Server can export  many metrics to Graphite, and exports a set of metrics by default that  is designed to be immediately useful to Puppet administrators.

> **Note:** A Graphite setup is deeply customizable and can report many Puppet Server metrics on demand. However, it requires considerable configuration and  additional server resources. To retrieve metrics through HTTP requests,  see the metrics API.

To start using Graphite with Puppet Server, you must:

- [Install and configure a Graphite server](https://graphite.readthedocs.io/en/latest/install.html).
- [Enable Puppet Server's Graphite support](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#enabling-puppet-servers-graphite-support).

[Grafana](http://grafana.org) provides a web-based customizable dashboard that's compatible with Graphite, and the [`grafanadash`](https://forge.puppet.com/cprice404/grafanadash) module installs and configures it by default.

### Using the `grafanadash` module to quickly set up a Graphite demo server

The [`grafanadash`](https://forge.puppet.com/cprice404/grafanadash) Puppet module quickly installs and configures a basic test instance of [Graphite](https://graphiteapp.org) with the [Grafana](http://grafana.org) extension. When installed on a dedicated Puppet agent, this module  provides a quick demonstration of how Graphite and Grafana can consume  and display Puppet Server metrics.

> **WARNING:** The `grafanadash` module is *not* a Puppet-supported module. It is designed for testing and demonstration purposes *only*, and tested against CentOS 6 only.
>
> Also, install this module on a dedicated agent *only*. Do **not** install it on the node running Puppet Server, because the module makes  security policy changes that are inappropriate for a Puppet primary  server:
>
> - SELinux can cause issues with Graphite and  Grafana, so the module temporarily disables SELinux. If you reboot the  machine after using the module to install Graphite, you must disable  SELinux again and restart the Apache service to use Graphite and  Grafana.
> - The module disables the `iptables` firewall and enables cross-origin resource sharing on Apache, which are potential security risks.

#### Installing the `grafanadash` Puppet module

Install the `grafanadash` Puppet module on a *nix agent. The module's `grafanadash::dev` class installs and configures a Graphite server, the Grafana extension, and a default dashboard.

1. [Install a *nix Puppet agent](https://puppet.com/docs/puppet/latest/install_linux.html) to serve as the Graphite server.
2. As root on the Puppet agent node, run `puppet module install puppetlabs-grafanadash`.
3. As root on the Puppet agent node, run `puppet apply -e 'include grafanadash::dev'`.

#### Running Grafana

Grafana runs as a web dashboard, and the `grafanadash` module configures it to use port 10000 by default. To view Puppet  metrics in Grafana, you must create a metrics dashboard, or edit and  import a JSON-based dashboard that includes Puppet metrics, such as the [sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/sample-puppetserver-metrics-dashboard.json) that we provide.

1. In a web browser on a computer that can reach the Puppet agent node running Grafana, navigate to `http://<AGENT'S HOSTNAME>:10000`.

   There, you'll see a test screen that indicates whether Grafana can successfully connect to your Graphite server.

   If Grafana is configured to use a hostname that the computer on which the browser is running cannot resolve, click **view details** and then the **Requests** tab to determine the hostname Grafana is trying to use. Next, add the IP address and hostname to the computer's `/etc/hosts` file on Linux or OS X, or `C:\Windows\system32\drivers\etc\hosts` file on Windows.

2. Download and edit our [sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/sample-puppetserver-metrics-dashboard.json), `sample_metrics_dashboard.json`.

   a.  Open the `sample_metrics_dashboard.json` file in a text editor on the same computer you're using to access Grafana.

   b.  Throughout the file, replace our sample hostname of `server.example.com` with your Puppet Server's hostname. (**Note:** This value **must** be used as the `metrics_server_id` setting, as configured below.)

   c.  Save the file.

3. In the Grafana UI, click **search** (the folder icon), then **Import**, then **Browse**.

4. Navigate to and select the edited JSON file.

This loads a dashboard with nine graphs that display  various metrics exported from the Puppet Server to the Graphite server.  (For details, see [Using the Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#using-the-sample-grafana-dashboard).) However, these graphs will remain empty until you enable Puppet Server's Graphite metrics.

> Note: If you want to integrate Puppet Server's Grafana exporting with your own infrastructure, use the `grafanadash` module. If you want visualization of metrics, use the `puppetlabs-puppet_operational_dashboards` module.

### Enabling Puppet Server's Graphite support

Configure Puppet Server's [`metrics.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_metrics.html) file to enable and use the Graphite server.

1. Set the `enabled` parameter to true in `metrics.registries.puppetserver.reporters.graphite`:

   ```
    metrics: {
       server-id: localhost
       registries: {
           puppetserver: {
               ...
               reporters: {
                   ...
                   # enable or disable Graphite metrics reporter
                   graphite: {
                       enabled: true
                   }
               }
           }
       }
   }Copied!
   ```

2. Configure the Graphite host settings in `metrics.reporters.graphite`:

   - **host:** The Graphite host's IP address as a string.
   - **port:** The Graphite host's port number.
   - **update-interval-seconds:** How frequently Puppet Server should send metrics to Graphite.

3. Verify that `metrics.registries.puppetserver.reporters.jmx.enabled` is not set to false. Its default setting is true.

> **Tip:** In the Grafana UI, choose an appropriate time window from the drop-down menu.

### Using the sample Grafana dashboard

The [sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/sample-puppetserver-metrics-dashboard.json) provides what we think is an interesting starting point. You can click on the title of any graph, and then click **edit** to tweak the graphs as you see fit.

- **Active requests:** This graph serves as a "health check" for the Puppet Server. It shows a flat line that represents the number of CPUs you have in your system, a metric that indicates the total number of HTTP requests actively being  processed by the server at any moment in time, and a rolling average of  the number of active requests. If the number of requests being processed exceeds the number of CPUs for any significant length of time, your  server might be receiving more requests than it can efficiently process.

- **Request durations:** This graph breaks down the average response times for different types  of requests made by Puppet agents. This indicates how expensive catalog  and report requests are compared to the other types of requests. It also provides a way to see changes in catalog compilation times when you  modify your Puppet code. A sharp curve upward for all of the types of  requests indicates an overloaded server, and they should trend downward  after reducing the load on the server.

- **Request ratios:** This graph shows how many requests of each type that Puppet Server has  handled. Under normal circumstances, you should see about the same  number of catalog, node, or report requests, because these all happen  one time per agent run. The number of file and file metadata requests  correlate to how many remote file resources are in the agents' catalogs.

- **Communications with PuppetDB:** This graph tracks the amount of time it takes Puppet Server to send  data and requests for common operations to, and receive responses from,  PuppetDB.

- **JRubies**: This graph tracks  how many JRubies are in use, how many are free, the mean number of free  JRubies, and the mean number of requested JRubies.

  If the number of free JRubies is often less than one, or  the mean number of free JRubies is less than one, Puppet Server is  requesting and consuming more JRubies than are available. This overload  reduces Puppet Server's performance. While this might simply be a  symptom of an under-resourced server, it can also be caused by poorly  optimized Puppet code or bottlenecks in the server's communications with PuppetDB if it is in use.

  If catalog compilation times have increased but PuppetDB  performance remains the same, examine your Puppet code for potentially  unoptimized code. If PuppetDB communication times have increased, tune  PuppetDB for better performance or allocate more resources to it.

  If neither catalog compilation nor PuppetDB communication  times are degraded, the Puppet Server process might be under-resourced  on your server. If you have available CPU time and memory, [increase the number of JRuby instances](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html) to allow it to allocate more JRubies. Otherwise, consider adding  additional compilers to distribute the catalog compilation load.

- **JRuby Timers**: This graph tracks several JRuby pool metrics.

  - The borrow time represents the mean amount of time that Puppet Server uses ("borrows") each JRuby from the pool.
  - The wait time represents the total amount of time that Puppet Server waits for a free JRuby instance.
  - The lock held time represents the amount of  time that Puppet Server holds a lock on the pool, during which JRubies  cannot be borrowed.
  - The lock wait time represents the amount of time that Puppet Server waits to acquire a lock on the pool.

  These metrics help identify sources of potential JRuby allocation bottlenecks.

- **Memory Usage**: This graph tracks how much heap and non-heap memory that Puppet Server uses.

- **Compilation:** This graph breaks catalog compilation down into various phases to show how expensive each phase is.

### Example Grafana dashboard excerpt

The following example shows only the `targets` parameter of a dashboard to demonstrate the full names of Puppet's  exported Graphite metrics (assuming the Puppet Server instance has a  domain of `server.example.com`) and a way to add targets directly to an exported Grafana dashboard's JSON content.

```
"panels": [
    {
        "span": 4,
        "editable": true,
        "type": "graphite",

...

        "targets": [
            {
                "target": "alias(puppetlabs.server.example.com.num-cpus,'num cpus')"
            },
            {
                "target": "alias(puppetlabs.server.example.com.http.active-requests.count,'active requests')"
            },
            {
                "target": "alias(puppetlabs.server.example.com.http.active-histo.mean,'average')"
            }
        ],
        "aliasColors": {},
        "aliasYAxis": {},
        "title": "Active Requests"
    }
]Copied!
```

See the [sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/sample-puppetserver-metrics-dashboard.json) for a detailed example of how a Grafana dashboard accesses these exported Graphite metrics.

## Available Graphite metrics

The following HTTP and Puppet profiler metrics are  available from the Puppet Server and can be added to your metrics  reporting. Each metric is prefixed with `puppetlabs.<SERVER-HOSTNAME>`; for instance, the Grafana dashboard file refers to the `num-cpus` metric as `puppetlabs.<SERVER-HOSTNAME>.num-cpus`.

Additionally, metrics might be suffixed by fields, such as `count` or `mean`, that return more specific data points. For instance, the `puppetlabs.<SERVER-HOSTNAME>.compiler.mean` metric returns only the mean length of time it takes Puppet Server to compile a catalog.

To aid with reference, metrics in the list below are segmented into three groups:

- **Statistical metrics:** Metrics that have all eight of these statistical analysis fields, in addition to the top-level metric:
  - `max`: Its maximum measured value.
  - `min`: Its minimum measured value.
  - `mean`: Its mean, or average, value.
  - `stddev`: Its standard deviation from the mean.
  - `count`: An incremental counter.
  - `p50`: The value of its 50th percentile, or median.
  - `p75`: The value of its 75th percentile.
  - `p95`: The value of its 95th percentile.
- **Counters only:** Metrics that only count a value, or only have a `count` field.
- **Other:** Metrics that have unique sets of available fields.

> **Note:** Puppet Server can  export many, many metrics -- so many that enabling all of them at large  installations can overwhelm Grafana servers. To avoid this, Puppet  Server exports only a subset of its available metrics by default. This  default set is designed to report the most relevant metrics for  administrators monitoring performance and stability.
>
> To add to the default list of exported metrics, see [Modifying Puppet Server's exported metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#modifying-puppet-servers-exported-metrics).

Puppet Server exports each metric in the lists below by default.

### Statistical metrics

#### Compiler metrics

- `puppetlabs.<SERVER-HOSTNAME>.compiler`: The time spent compiling catalogs. This metric represents the sum of the `compiler.compile`, `static_compile`, `find_facts`, and `find_node` fields.

  - `puppetlabs.<SERVER-HOSTNAME>.compiler.compile`: The total time spent compiling dynamic (non-static) catalogs.

    To measure specific nodes and environments, see [Modifying Puppet Server's exported metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#modifying-puppet-servers-exported-metrics).

  - `puppetlabs.<SERVER-HOSTNAME>.compiler.find_facts`: The time spent parsing facts.

  - `puppetlabs.<SERVER-HOSTNAME>.compiler.find_node`: The time spent retrieving node data. If the Node Classifier (or another ENC) is configured, this includes the time spent communicating with it.

  - `puppetlabs.<SERVER-HOSTNAME>.compiler.static_compile`: The time spent compiling [static catalogs](https://puppet.com/docs/puppet/latest/static_catalogs.html).

  - `puppetlabs.<SERVER-HOSTNAME>.compiler.static_compile_inlining`: The time spent inlining metadata for static catalogs.

  - `puppetlabs.<SERVER-HOSTNAME>.compiler.static_compile_postprocessing`: The time spent post-processing static catalogs.

#### Function metrics

- `puppetlabs.<SERVER-HOSTNAME>.functions`: The amount of time during catalog compilation spent in function calls. The `functions` metric can also report any of the [statistical metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html#available-graphite-metrics) fields for a single function by specifying the function name as a field.

  For example, to report the mean time spent in a function call during catalog compilation, use `puppetlabs.<SERVER-HOSTNAME>.functions.<FUNCTION-NAME>.mean`.

#### HTTP metrics

- `puppetlabs.<SERVER-HOSTNAME>.http.active-histo`: A histogram of active HTTP requests over time.
- `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-catalog-/*/-requests`: The time Puppet Server has spent handling catalog requests, including time spent waiting for an available JRuby instance.
- `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-environment_classes-/*/-requests`: The time spent handling requests to the [`environment_classes` API endpoint](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/environment_classes.html), which the Node Classifier uses to refresh classes.
- `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-environments-requests`: The time spent handling requests to the [`environments` API endpoint](https://www.puppet.com/docs/puppet/7/http_api/http_environments.html) requests.
- The following metrics measure the time spent handling file-related API endpoints:
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_bucket_file-/*/-requests`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_content-/*/-requests`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_metadata-/*/-requests`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_metadatas-/*/-requests`
- `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-node-/*/-requests`: The time spent handling node requests, which are sent to the Node  Classifier. A bottleneck here might indicate an issue with the Node  Classifier or PuppetDB.
- `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-report-/*/-requests`: The time spent handling report requests. A bottleneck here might indicate an issue with PuppetDB.
- `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-static_file_content-/*/-requests`: The time spent handling requests to the [`static_file_content` API endpoint](https://www.puppet.com/docs/puppet/7/server/puppet-api/v3/static_file_content.html) used by Direct Puppet with file sync.

#### JRuby metrics

Puppet Server uses an embedded JRuby interpreter to execute Ruby code. By default, JRuby spawns parallel instances known as JRubies to execute Ruby code, which occurs during most Puppet Server  activities. When `multithreaded` is set to `true`, a single JRuby is used instead to process a limited number of threads  in parallel. For each of these metrics, they refer to JRuby instances by default and JRuby threads in multithreaded mode.

See [Tuning JRuby on Puppet Server](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html) for details on adjusting JRuby settings.

- `puppetlabs.<SERVER-HOSTNAME>.jruby.borrow-timer`: The time spent with a borrowed JRuby.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.free-jrubies-histo`: A histogram of free JRubies over time. This metric's average value should greater than 1; if it isn't, [more JRubies](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html) or another compile primary server might be needed to keep up with requests.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.lock-held-timer`: The time spent holding the JRuby lock.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.lock-wait-timer`: The time spent waiting to acquire the JRuby lock.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.requested-jrubies-histo`: A histogram of requested JRubies over time. This increases as the number of free JRubies, or the `free-jrubies-histo` metric, decreases, which can suggest that the server's capacity is being depleted.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.wait-timer`: The time spent waiting to borrow a JRuby.

#### PuppetDB metrics

The following metrics measure the time that Puppet Server spends sending or receiving data from PuppetDB.

- `puppetlabs.<SERVER-HOSTNAME>.puppetdb.catalog.save`
- `puppetlabs.<SERVER-HOSTNAME>.puppetdb.command.submit`
- `puppetlabs.<SERVER-HOSTNAME>.puppetdb.facts.find`
- `puppetlabs.<SERVER-HOSTNAME>.puppetdb.facts.search`
- `puppetlabs.<SERVER-HOSTNAME>.puppetdb.report.process`
- `puppetlabs.<SERVER-HOSTNAME>.puppetdb.resource.search`

### Counters only

#### HTTP metrics

- `puppetlabs.<SERVER-HOSTNAME>.http.active-requests`: The number of active HTTP requests.
- The following counter metrics report the percentage of each HTTP API endpoint's share of total handled HTTP requests.
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-catalog-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-environment-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-environment_classes-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-environments-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_bucket_file-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_content-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_metadata-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-file_metadatas-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-node-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-report-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-resource_type-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-resource_types-/*/-percentage`
  - `puppetlabs.<SERVER-HOSTNAME>.http.puppet-v3-static_file_content-/*/-percentage`
- `puppetlabs.<SERVER-HOSTNAME>.http.total-requests`: The total requests handled by Puppet Server.

#### JRuby metrics

> **Note:** In multithreaded mode, each of these refers to JRuby threads instead of separate JRuby instances.

- `puppetlabs.<SERVER-HOSTNAME>.jruby.borrow-count`: The number of successfully borrowed JRubies.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.borrow-retry-count`: The number of attempts to borrow a JRuby that must be retried.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.borrow-timeout-count`: The number of attempts to borrow a JRuby that resulted in a timeout.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.request-count`: The number of requested JRubies.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.return-count`: The number of JRubies successfully returned to the pool.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.num-free-jrubies`: The number of free JRuby instances. If this number is often 0, more  requests are coming in than the server has available JRuby instances. To alleviate this, increase the number of JRuby instances on the Server or add additional compile servers.
- `puppetlabs.<SERVER-HOSTNAME>.jruby.num-jrubies`: The total number of JRuby instances on the server, governed by the `max-active-instances` setting. See [Tuning JRuby on Puppet Server](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html) for details.

### Other metrics

These metrics measure raw resource availability and capacity.

- `puppetlabs.<SERVER-HOSTNAME>.num-cpus`: The number of available CPUs on the server.
- `puppetlabs.<SERV+
- ER-HOSTNAME>.uptime`: The Puppet Server process's uptime.
- Total, heap, and non-heap memory that's committed (`committed`), initialized (`init`), and used (`used`), and the maximum amount of memory that can be used (`max`).
  - `puppetlabs.<SERVER-HOSTNAME>.memory.total.committed`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.total.init`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.total.used`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.total.max`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.heap.committed`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.heap.init`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.heap.used`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.heap.max`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.non-heap.committed`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.non-heap.init`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.non-heap.used`
  - `puppetlabs.<SERVER-HOSTNAME>.memory.non-heap.max`

For details about HTTP client metrics, which measure performance of Puppet Server's requests to other services, see [their documentation](https://www.puppet.com/docs/puppet/7/server/http_client_metrics.html).

### Modifying Puppet Server's exported metrics

In addition to the above default metrics, you can also export metrics measuring specific environments and nodes.

The `metrics.registries.puppetserver.metrics-allowed` parameter in [`metrics.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_metrics.html) takes an array of strings representing the metrics you want to enable.

Omit the `puppetlabs.<SERVER-HOSTNAME>` prefix and field suffixes (such as `.count` or `.mean`) from metrics when adding them to this class. Instead, suffix the environment or node name as a field to the metric.

For example, to track the compilation time for the `production` environment, add `compiler.compile.production` to the `metrics-allowed` list. To track only the `my.node.localdomain` node in the `production` environment, add `compiler.compile.production.my.node.localdomain` to the `metrics-allowed` list.

Optional metrics include:

- `compiler.compile.<ENVIRONMENT>` and `compiler.compile.<ENVIRONMENT>.<NODE-NAME>`, and all statistical fields suffixed to these (such as `compiler.compile.<ENVIRONMENT>.mean`).
- `compiler.compile.evaluate_resources.<RESOURCE>`: Time spent evaluating a specific resource during catalog compilation.

# HTTP Client Metrics

### Sections

[Determining metrics IDs](https://www.puppet.com/docs/puppet/7/server/http_client_metrics.html#determining-metrics-ids)

[Configuring](https://www.puppet.com/docs/puppet/7/server/http_client_metrics.html#configuring)

[Example metrics output](https://www.puppet.com/docs/puppet/7/server/http_client_metrics.html#example-metrics-output)

HTTP client metrics available in Puppet  Server 5 allows users to measure how long it takes for Puppet Server to  make requests to and receive responses from other services, such as  PuppetDB.

## Determining metrics IDs

All of these metrics are of the form `puppetlabs.<SERVER ID>.http-client.experimental.with-metric-id.<METRIC ID>.full-response`.

> **Note:** The `<METRIC ID>` describes what the metric measures. A metric ID is represented in the [status endpoint](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) as an array of strings, and in the metric itself the strings are joined together with periods. For instance, the metric ID of `[puppetdb resource search]` is `puppetdb.resource.search`, so the full metric name would be `puppetlabs.<server-id>.http-client.experimental.with-metric-id.puppetdb.resource.search.full-response`.

You can configure PuppetDB to be a backend for [configuration files](https://puppet.com/docs/puppetdb/latest/connect_puppet_master.html#step-2-edit-configuration-files) (through the `storeconfigs` setting), and you can configure Puppet Server to send reports to an  external report processing service. If you configure either of these,  then during the course of handling a Puppet agent run, Puppet Server  makes several calls to external services to retrieve or store  information.

- During handling of a `/puppet/v3/node` request, Puppet Server issues:
  - a `facts find` request to PuppetDB for facts about the node, if they aren't yet cached (typically the first time it requests facts for the node). **Metric ID:** `[puppetdb facts find]`.
- During handling of a `/puppet/v3/catalog` request, Puppet Server issues several requests:
  - a PuppetDB `replace facts` request, to replace the facts for the agent in PuppetDB with the facts it received from the agent. **Metric ID:** `[puppetdb, command, replace_facts]`.
  - a PuppetDB `resource search` request, to search for resources if exported resources are used. **Metric ID:** `[puppetdb, resource, search]`.
  - a PuppetDB `query` request, if the `puppetdb_query` function is used in Puppet code. **Metric ID:** `[puppetdb, query]`.
  - a PuppetDB `replace catalog` request, to replace the catalog for the agent in PuppetDB with the newly compiled catalog. **Metric ID:** `[puppetdb, command, replace_catalog]`.
- During handling of a `/puppet/v3/report` request, Puppet Server issues:
  - a PuppetDB `store report` request, to store the submitted report. **Metric ID:** `[puppetdb command store_report]`.
  - a request to the configured `reports_url` to store the report, if the HTTP report processor is enabled. **Metric ID:** `[puppetdb report http]`.

## Configuring

HTTP client metrics are enabled by default, but can be disabled by setting `metrics-enabled` to `false` in the `http-client` section of [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html).

These metrics also depend on the `server-id` setting in the `metrics` section of `puppetserver.conf`. This defaults to `localhost`, and while `localhost` can collect metrics, change this setting to something unique to avoid  metric naming collisions when exporting metrics to an external tool,  such as Graphite.

This data is all available via the [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) endpoint, at `https://<SERVER HOSTNAME>:8140/status/v1/services/master?level=debug`. Puppet Server 5.0 adds a `http-client-metrics` keyword in the map. If metrics are not enabled, or if Puppet Server has not issued any requests yet, then this array will be empty, like so: `"http-client-metrics": []`.

In the [sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/sample-puppetserver-metrics-dashboard.json), the `External HTTP Communications` graph visualizes all of these metrics, and the tooltip describes each of them.

## Example metrics output

```
"http-client-metrics": [
  {
    "aggregate": 407,
    "count": 1,
    "mean": 407,
    "metric-id": [
      "puppetdb",
      "facts",
      "find"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppetdb.facts.find.full-response"
  },
  {
    "aggregate": 66,
    "count": 1,
    "mean": 66,
    "metric-id": [
      "puppetdb",
      "command",
      "replace_facts"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppetdb.command.replace_facts.full-response"
  },
  {
    "aggregate": 60,
    "count": 2,
    "mean": 30,
    "metric-id": [
      "puppetdb",
      "resource",
      "search"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppetdb.resource.search.full-response"
  },
  {
    "aggregate": 53,
    "count": 1,
    "mean": 53,
    "metric-id": [
      "puppetdb",
      "query"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppetdb.query.full-response"
  },
  {
    "aggregate": 22,
    "count": 1,
    "mean": 22,
    "metric-id": [
      "puppetdb",
      "command",
      "store_report"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppetdb.command.store_report.full-response"
  },
  {
    "aggregate": 16,
    "count": 1,
    "mean": 16,
    "metric-id": [
      "puppetdb",
      "command",
      "replace_catalog"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppetdb.command.replace_catalog.full-response"
  },
  {
    "aggregate": 2,
    "count": 1,
    "mean": 2,
    "metric-id": [
      "puppet",
      "report",
      "http"
    ],
    "metric-name": "puppetlabs.localhost.http-client.experimental.with-metric-id.puppet.report.http.full-response"
  }
],
```

# Tuning guide

### Sections

[Puppet Server and JRuby](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#puppet-server-and-jruby)

- [Number of JRubies](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#number-of-jrubies)
- [JVM Heap Size](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#jvm-heap-size)
- [Tying Together `max-active-instances` and Heap Size](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#tying-together-max-active-instances-and-heap-size)
- [Potential JAVA ARGS settings](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#potential-java-args-settings)
- [The `environment_timeout` setting](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#the-environment-timeout-setting)

Puppet Server provides many configuration options that can be used to tune the server for maximum performance and hardware resource utilization. In this guide, we'll highlight some of the most important settings that you can use to get the best performance in your environment.

## Puppet Server and JRuby

Before you begin tuning your configuration, it's helpful to have a little bit of context on how Puppet Server uses JRuby to handle incoming HTTP requests from your Puppet agents.

When Puppet Server starts up, it creates a pool of JRuby interpreters to use as workers when it needs need to execute some of the Puppet Ruby code. You can think of these almost as individual Ruby "virtual machines" that are controlled by Puppet Server; it's not entirely dissimilar to the way that Passenger spawns several Ruby processes to hand off work to.

Puppet Server isolates these JRuby instances so that they will only be allowed to handle one request at a time. This ensures that we don't encounter any concurrency issues, because the Ruby code is not thread-safe. When an HTTP request comes in to Puppet Server, and it determines that some Ruby code will need to be executed in order to handle the request, Puppet Server "borrows" a JRuby instance from the pool, uses it to do the work, and then "returns" it to the pool.  If there are no JRuby instances available in the pool at the time a request comes in (presumably because all of the JRuby instances are already in use handling other requests), Puppet Server will block the request until one becomes available.

(In the future, this approach will allow us to do some really powerful things such as creating multiple pools of JRubies and isolating each of your Puppet environments to a single pool, to ensure that there is no pollution from one Puppet environment to the next.)

This brings us to the two most important settings that you can use to tune your Puppet Server.

### Number of JRubies

The most important setting that you can use to improve the throughput of your Puppet Server installation is the [`max-active-instances`](https://www.puppet.com/docs/puppet/7/server/configuration.html) setting, which you set in [puppetserver.conf](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html#settings). The value of this setting is used by Puppet Server to determine how many JRuby instances to create when the server starts up.

From a practical perspective, this setting basically controls how many Puppet agent runs Puppet Server can handle concurrently. The minimum value you can get away with here is `1`, and if your installation is small enough that you're unlikely to ever have more than one Puppet agent checking in with the server at exactly the same time, this is totally sufficient.

However, if you specify a value of `1` for this setting, and then you have two Puppet agent runs hitting the server at the same time, the requests  being made by the second agent will be effectively blocked until the  server has finished handling all of the requests from the first agent.  In other words, one of Puppet Server's threads will have "borrowed" the  single JRuby instance from the pool to handle the requests from the  first agent, and only when those requests are completed will it return  the JRuby instance to the pool. At that point, the next thread can "borrow" the JRuby  instance to use to handle the requests from the second agent.

Assuming you have more than one CPU core in your machine, this situation means that you won't be getting the maximum possible throughput from your Puppet Server installation. Increasing the value from `1` to `2` would mean that Puppet Server could now use a second CPU core to handle the requests from a second Puppet agent simultaneously.

It follows, then, that the maximum sensible value to use for this setting will be roughly the number of CPU cores you have in your server. Setting the value to something much higher than that won't improve performance, because even if there are extra JRuby instances available in the pool to do work, they won't be able to actually do any work if all of the CPU cores are already busy using JRuby instances to handle incoming agent requests.

(There are some exceptions to this rule. For example, if  you have report processors that make a network connection as part of the processing of a report, and if there is a chance that the network operation is slow and will block on I/O for some period of time, then it might make sense to have more JRuby instances than the number of cores. The JVM is smart enough to suspend the thread that is handling  those kinds of requests and use the CPUs for other work, assuming there  are still JRuby instances available in the pool. In a case like this you might want to set `max-active-instances` to a value higher than the number of CPUs.)

At this point you may be wondering, "What's the downside to just setting `max-active-instances` to a really high value?" The answer to this question, in a nutshell, is "memory usage". This brings us to the other extremely important setting to consider for Puppet Server.

### JVM Heap Size

The JVM's "max heap size" controls the maximum amount of  (heap memory that the JVM process is allowed to request from the  operating system. You can set this value via the `-Xmx` command-line argument at JVM startup. (In the case of Puppet Server, you'll find this setting in the "defaults" file for Puppet Server for your operating system; this will generally be something like `/etc/sysconfig/puppetserver` or `/etc/defaults/puppetserver`.)

**Note**: The vast majority of the memory footprint of a JVM process can usually be accounted for by the heap size. However, there is some amount of non-heap memory that will always be used, and for programs that call out to native code at all, there may be a bit more. Generally speaking, the resident memory usage of a JVM process shouldn't exceed the max heap size by more than 256MB or so, but exceeding the max heap size by some amount is normal.

> **Upgrade note:** If you modified the defaults file in Puppet Server 2.4.x or earlier, then lost those modifications or see `Service ':PoolManagerService' not found` warnings after upgrading to Puppet Server 2.5, be aware that the  package might have attempted to overwrite the file during the upgrade.  See the [Puppet Server 2.5 release notes](https://docs.puppet.com/puppetserver/2.5/release_notes.html) for details.

If your application's memory usage approaches this value,  the JVM will try to get more aggressive with garbage collection to free up memory. In  certain situations, you may see increased CPU activity related to this garbage  collection. If the JVM is unable to recover enough memory to keep the  application running smoothly, you will eventually encounter an `OutOfMemoryError`, and the process will shut down.

For Puppet Server, we also use a JVM argument, `-XX:HeapDumpOnOutOfMemoryError`, to cause the JVM to dump an `.hprof` file to disk. This is basically a memory snapshot at the point in time where the error occurred; it can be loaded into various profiling tools to get a better understanding of where the memory was being used.

(Note that there is another setting, "min heap size", that is controlled via the -Xms setting; [Oracle recommends](https://www.oracle.com/java/technologies/tuning-garbage-collection-v50-java-virtual-machine.html#0.0.0.-Total-Heap-Coutline) setting this value to the same value that you use for -Xmx.)

The most important factor when determining the max heap size for Puppet Server is the value of `max-active-instances`. Each JRuby instance needs to load up a copy of the Puppet Ruby code, and then needs some amount of memory overhead for all of the garbage that gets generated during a Puppet catalog compilation. Also, the memory requirements will vary based on how many Puppet modules you have in your module path, how much Hiera data you have, etc. At this time we estimate that a reasonable ballpark figure is about 512MB of RAM per JRuby instance, but that can vary depending on some characteristics of your Puppet codebase. For example, if you have a really high number of modules or a great deal of Hiera data, you might find that you need more than 512MB per JRuby instance.

You'll also want to allocate a little extra heap to be used by the rest of the things going on in Puppet Server: the web server, etc. So, a good rule of thumb might be 512MB + (max-active-instances * 512MB).

We're working on some optimizations for really small installations (for testing, demos, etc.). Puppet Server should run fine with a value of 1 for `max-active-instances` and a heap size of 512MB, and we might be able to improve that further in the future.

### Tying Together `max-active-instances` and Heap Size

We're still gathering data on what the best default settings are, to try to provide an out-of-the-box configuration that works well in most environments. In versions prior to 1.0.8 in the 1.x series (compatible with Puppet 3.x), and prior to 2.1.0 in the 2.x series (compatible with Puppet 4.x), the default value is `num-cpus + 2`.  This value will be far too high if you're running on a system with a large number of CPU cores.

As of Puppet Server 1.0.8 and 2.1.0, if you don't provide an explicit value for this setting, we'll default to `num-cpus - 1`, with a minimum value of `1` and a maximum value of `4`. The maximum value of `4` is probably too low for production environments with beefy hardware and a high number of Puppet agents checking in, but our current thinking is that it's better to ship with a default setting that is too low and allow you to tune up, than to ship with a default setting that is too high and causes you to run into `OutOfMemory` errors. In general, it's recommended that you explicitly set this value to something that you think is reasonable in your environment. To encourage this, we log a warning message at startup if you haven't provided an explicit value.

### Potential JAVA ARGS settings

If you’re working outside of lab environment, increase `ReservedCodeCacheSize` to `512m` under normal load. If you’re working with 6-12 JRuby instances (or a `max-requests-per-instance` value significantly less than 100k), run with a `ReservedCodeCache` of 1G. Twelve or more JRuby instances in a single server might require 2G or more.

Similar caveats regarding scaling `ReservedCodeCacheSize` might apply if users are managing `MaxMetaspace`.

### The `environment_timeout` setting

By default, Puppet does not cache environments, which means the `environment_timeout` setting defaults to `0`. This allows you to update code without any extra steps, but it lowers the performance of Puppet Server.

In a production environment, we recommend either:

- Setting the value to `unlimited` and refreshing Puppet Server as part of your code deployment process.
- Setting the value to a number that keeps  your most actively used environments cached, but allows testing  environments to fall out of the cache and reduce memory usage. For  example, a value of 3 minutes (3m).

# Applying metrics to improve performance

### Sections

[Measuring capacity with JRubies](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics_performance.html#measuring-capacity-with-jrubies)

- [Request-handling capacity](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics_performance.html#request-handling-capacity)
- [HTTP request delays](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics_performance.html#http-request-delays)
- [Memory leaks and usage](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics_performance.html#memory-leaks-and-usage)

Puppet Server produces [several types of metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html) that administrators can use to identify performance bottlenecks or  capacity issues. Interpreting this data is largely up to you and depends on many factors unique to your installation and usage, but there are  some common trends in metrics that you can use to make Puppet Server  function better.

> **Note:** This document assumes that you are already familiar with Puppet Server's [metrics tools](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html), which report on relevant information, and its [tuning guide](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html), which provides instructions for modifying relevant settings. To put it  another way, this guide attempts to explain questions about "why" Puppet Server performs the way it does for you, while your servers are the  "who", Server [metrics](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html) help you track down exactly "what" is affecting performance, and the [tuning guide](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html) explains "how" you can improve performance.
>
> **If you're using Puppet Enterprise (PE),** consult its documentation instead of this guide for PE-specific requirements, settings, and instructions:
>
> - [Large environment installations (LEI)](https://puppet.com/docs/pe/latest/installing/hardware_requirements.html#large-environment-hardware-requirements)
> - [Compilers](https://puppet.com/docs/pe/latest/installing_compilers.html)
> - [Load balancing](https://puppet.com/docs/pe/latest/installing_compilers.html#using-load-balancers-with-compilers)
> - [High availability](https://puppet.com/docs/pe/latest/high_availability/high_availability_overview.html)

## Measuring capacity with JRubies

Puppet Server uses JRuby, which rations server resources in the form of JRuby instances in default mode, and JRuby threads in  multithreaded mode. Puppet Server consumes these as it handles requests. A simple way of explaining Puppet Server performance is to remember  that your Server infrastructure must be capable of providing enough  JRuby instances or threads for the amount of activity it handles.  Anything that reduces or limits your server's capacity to produce  JRubies also degrades Puppet Server's performance.

Several factors can limit your Server infrastructure's ability to produce JRubies.

### Request-handling capacity

> **Note:**  These guidelines for interpreting metrics generally apply to both  default and multithreaded mode. However, threads are much cheaper in  terms of system resources, since they do not need to duplicate all of  Puppet's runtime, so you may have more vertical scalability in  multithreaded mode.

If your free JRubies are 0 or fewer, your server is  receiving more requests for JRubies than it can provide, which means it  must queue those requests to wait until resources are available. Puppet  Server performs best when the average number of free JRubies is above 1, which means Server always has enough resources to immediately handle  incoming requests.

There are two indicators in Puppet Server's metrics that can help you identify a request-handling capacity issue:

- **Average JRuby Wait Time:** This refers to the amount of time Puppet Server has to wait for an  available JRuby to become available, and increases when each JRuby is  held for a longer period of time, which reduces the overall number of  free JRubies and forces new requests to wait longer for available  resources.
- **Average JRuby Borrow Time:** This refers to the amount of time that Puppet Server "holds" a JRuby as a resource for a request, and increases because of other factors on the server.

If wait time increases but borrow time stays the same, your Server infrastructure might be serving too many agents. This indicates  that Server can easily handle requests but is receiving too many at one  time to keep up.

If both wait and borrow times are increasing, something  else on your server is causing requests to take longer to process. The  longer borrow times suggest that Puppet Server is struggling more than  before to process requests, which has a cascading effect on wait times.  Correlate borrow time increases with other events whenever possible to  isolate what activities might cause them, such as a Puppet code change.

If you are setting up Puppet Server for the first time,  start by increasing your Server infrastructure's capacity through  additional JRubies (if your server has spare CPU and memory resources)  or compilers until you have more than 0 free JRubies, and your average  number of free JRubies are at least 1. After your system can handle its  request volume, you can start looking into more specific performance  improvements.

#### Adding more JRubies

If you must add JRubies, remember that Puppet Server is  tuned by default to use one fewer than your total number of CPUs, with a maximum of 4 CPUs, for the number of available JRubies. You can change  this by setting `max-active-instances` in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html), under the `jruby-puppet` section. In the default mode, increasing `max-active-instances` creates whole independent JRuby instances. In multithreaded mode, this  setting instead controls the number of threads that the single JRuby  instance will process concurrently, and therefore has different scaling  characteristics. Tuning recommendations for this mode are under  development, see [SERVER-2823](https://tickets.puppetlabs.com/browse/SERVER-2823).

When running in the default mode, follow these guidelines for allocating resources when adding JRubies:

Each JRuby also has a certain amount of persistent memory  overhead required in order to load both Puppet's Ruby code and your  Puppet code. In other words, your available memory sets a baseline limit to how much Puppet code you can process. Catalog compilation can  consume more memory, and Puppet Server's total memory usage depends on  the number of agents being served, how frequently those agents check in, how many resources are being managed on each agent, and the complexity  of the manifests and modules in use.

With the `jruby-puppet.compile-mode` setting in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html) set to `off`, a JRuby requires at least 40MB of memory under JRuby 1.7 and at least  60MB under JRuby9k in order to compile a nearly empty catalog. This  includes memory for the scripting container, Puppet's Ruby code and  additional memory overhead.

For real-world catalogs, you can generally add an absolute  minimum of 15MB for each additional JRuby. We calculated this amount by  comparing a minimal catalog compilation to compiling a catalog for a [basic role](https://github.com/puppetlabs/puppetlabs-puppetserver_perf_control/blob/production/site/role/manifests/by_size/small.pp) that installs Tomcat and Postgres servers.

Your Puppet-managed infrastructure is probably larger and  more complex than that test scenario, and every complication adds more  to each additional JRuby's memory requirements. (For instance, we  recommend assuming that Puppet Server will use [at least 512MB per JRuby](https://puppet.com/docs/pe/latest/configuring/config_puppetserver.html) while under load.) You can calculate a similar value unique to your infrastructure by measuring `puppetserver` memory usage during your infrastructure's catalog compilations and  comparing it to compiling a minimal catalog for a similar number of  nodes.

The `jruby-metrics` section of the [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) endpoint also lists the `requested-instances`, which shows what requests have come in that are waiting to borrow a  JRuby instance. This part of the status endpoint lists the lock's  status, how many times it has been requested, and how long it has been  held for. If it is currently being held and has been held for a while,  you might see requests starting to stack up in the `requested-instances` section.

#### Adding compilers

If you don't have the additional capacity on your primary server to add more JRubies, you'll want to add another  compiler to your Server infrastructure. See [Scaling Puppet Server with compile servers](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html).

### HTTP request delays

If JRuby metrics appear to be stable, performance issues  might originate from lag in server requests, which also have a cascading effect on other metrics. HTTP metrics in the [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html), and the requests graph in the [Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/puppet_server_metrics.html), can help you determine when and where request times have increased.

HTTP metrics include the total time for the server to  handle the request, including waiting for a JRuby instance to become  available. When JRuby borrow time increases, wait time also increases,  so when borrow time for *one* type of request increases, wait times for *all* requests increases.

Catalog compilation, which is graphed on the [sample Grafana dashboard](https://www.puppet.com/docs/puppet/7/server/sample-puppetserver-metrics-dashboard.json), most commonly increases request times, because there are many points of potential failure or delay in a catalog compilation. Several things  could cause catalog compilation lengthen JRuby borrow times.

- A Puppet code change, such as a faulty or  complex new function. The Grafana dashboard should show if functions  start taking significantly longer, and the experimental dashboard and [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) endpoint also list the lengthiest function calls (showing the top 10  and top 40, respectively) based on aggregate execution times.
- Adding many file resources at one time.

In cases like these, there might be more efficient ways to  author your Puppet code, you might be extending Puppet to the point  where you need to add JRubies or compilers even if you aren't adding  more agents.

Slowdowns in PuppetDB can also cause catalog compilations to take more time: if you use exported resources or the `puppetdb_query` function and PuppetDB has a problem, catalog compilation times will increase.

Puppet Server also sends agents' facts and the compiled catalog to PuppetDB during catalog compilation. The [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) for the master service reports metrics for these operations under [`http-client-metrics`](https://www.puppet.com/docs/puppet/7/server/http_client_metrics.html), and in the Grafana dashboard in the "External HTTP Communications" graph.

Puppet Server also requests facts as HTTP requests while  handling a node request, and submits reports via HTTP requests while  handling of a report request. If you have an HTTP report processor set  up, the Grafana dashboard shows metrics for `Http report processor,` as does the [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) endpoint under `http-client-metrics` in the master service, for metric ID `['puppet', 'report', 'http']`. Delays in the report processor are passed on to Puppet Server.

### Memory leaks and usage

A memory leak or increased memory pressure can stress  Puppet Server's available resources. In this case, the Java VM will  spend more time doing garbage collection, causing the GC time and GC CPU % metrics to increase. These metrics are available from the [status API](https://www.puppet.com/docs/puppet/7/server/status-api/v1/services.html) endpoint, as well as in the mbeans metrics available from both the [`/metrics/v1/mbeans`](https://www.puppet.com/docs/puppet/7/server/metrics-api/v1/metrics_api.html) or [`/metrics/v2/`](https://www.puppet.com/docs/puppet/7/server/metrics-api/v2/metrics_api.html) endpoints.

If you can't identify the source of a memory leak, setting the `max-requests-per-instance` setting in [`puppetserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html) to something other than the default of 0 limits the number of requests a JRuby handles during its lifetime and enables automatic JRuby flushing. Enabling this setting reduces overall performance, but if you enable it and no longer see signs of persistent memory leaks, check your module  code for inefficiencies or memory-consuming bugs.

> **Note:** In multithreaded mode, the `max-requests-per-instance` setting refers to the sum total number of requests processed by the  single JRuby instance, across all of its threads. While that single  JRuby is being flushed, all requests will suspend until the instance  becomes available again.

# Submitting usage telemetry

### Sections

[Configuring dropsonde in puppetserver.conf](https://www.puppet.com/docs/puppet/7/server/puppet_server_usage_telemetry.html#configuring-dropsonde-in-puppetserverconf)

[Dropsonde terminal commands](https://www.puppet.com/docs/puppet/7/server/puppet_server_usage_telemetry.html#dropsonde-terminal-commands)

If enabled, Puppet Server's dropsonde tool collects usage  data for public Forge content and submits collected information to  Puppet development. This data helps Puppet development to prioritize  more useful module work and to improve Forge search quality.

All data collected is fully aggregated before anyone can  access it. After aggregation, it is available publicly for the benefit  of the Puppet community. You can access public data at Puppet's [BigQuery public database](https://console.cloud.google.com/bigquery?p=dataops-puppet-public-data&d=community&t=forge_modules&page=table).

You can configure dropsonde to enable or disable certain  metrics according to your organization's policies or preferences. For  more information on how to do this, visit [dropsonde's documentation](https://github.com/puppetlabs/dropsonde).

## Configuring dropsonde in puppetserver.conf

Find the following section in your [puppetserver.conf](https://www.puppet.com/docs/puppet/7/server/config_file_puppetserver.html) file. If the section is not present, you may add it manually:

```
# settings related to submitting module metrics via Dropsonde
dropsonde: {
     #enabled: false
	
    # How long, in seconds, to wait between dropsonde submissions
    # Defaults to one week.
    # interval: 604800
}Copied!
```

To enable telemetry collection, uncomment the `enabled` setting and update it to `true`.

The `interval` setting defines how long, in seconds, Puppet Server waits between telemetry submissions if enabled. The default is `604800` (one week).

## Dropsonde terminal commands

The terminal command `puppetserver dropsonde list` lists all the loaded metrics plugins and describes what they do.

To see exactly what data is collected in a readable format, run `puppetserver dropsonde preview` in the terminal.

> **Note:** use `--format=json` if you want to use this data for your own tooling.

For more information on installating and configuring dropsonde, visit [its documentation](https://github.com/puppetlabs/dropsonde).

# Scaling Puppet Server

### Sections

[Planning your load-balancing strategy](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#planning-your-load-balancing-strategy)

- [Using round-robin DNS](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#using-round-robin-dns)
- [Using a hardware load balancer](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#using-a-hardware-load-balancer)
- [Using DNS `SRV` Records](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#using-dns-srv-records)

[Centralizing the Certificate Authority](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#centralizing-the-certificate-authority)

- [Directing individual agents to a central CA](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#directing-individual-agents-to-a-central-ca)
- [Pointing DNS `SRV` records at a central CA](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#pointing-dns-srv-records-at-a-central-ca)

[Creating and configuring compilers](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#creating-and-configuring-compilers)

[Centralizing reports, inventory service, and catalog searching (storeconfigs)](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#centralizing-reports-inventory-service-and-catalog-searching-storeconfigs)

[Keeping manifests and modules synchronized across compilers](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#keeping-manifests-and-modules-synchronized-across-compilers)

[Implementing load distribution](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#implementing-load-distribution)

Expand

To scale Puppet Server for many thousands of nodes, you'll  need to add more Puppet Server instances dedicated to catalog  compilation. These Servers are known as **compilers**, and are simply additional load-balanced Puppet Servers that receive  catalog requests from agents and synchronize the results with each  other.

> **If you're using Puppet Enterprise (PE),** consult its documentation instead of this guide for PE-specific requirements, settings, and instructions:
>
> -  [Large environment installations (LEI)](https://puppet.com/docs/pe/latest/hardware_requirements.html#hardware_requirements_large)
> -  [Installing compilers](https://puppet.com/docs/pe/latest/installing_compilers.html)
> -  [High availability](https://puppet.com/docs/pe/latest/high_availability_overview.html)
> -  [Code Manager](https://puppet.com/docs/pe/latest/code_mgr_how_it_works.html#how_code_manager_works)

## Planning your load-balancing strategy

The rest of your configuration depends on how you plan on distributing the agent load. Determine what your  deployment will look like before you add any compilers, but **implement load balancing as the last step** only after you have the infrastructure in place to support it.

### Using round-robin DNS

Leave all of your agents pointed at the same Puppet Server  hostname, then configure your site's DNS to arbitrarily route all  requests directed at that hostname to the pool of available servers.

For instance, if all of your agent nodes are configured with `server = puppet.example.com`, configure a DNS name such as:

```
# IP address of server 1:
puppet.example.com. IN A 192.0.2.50
# IP address of server 2:
puppet.example.com. IN A 198.51.100.215Copied!
```

For this option, configure your servers with `dns_alt_names` before their certificate request is made.

### Using a hardware load balancer

You can also use a hardware load balancer or a  load-balancing proxy webserver to redirect requests more intelligently.  Depending on your configuration (for instance, SSL using either raw TCP  proxying or acting as its own SSL endpoint), you might also need to use  other procedures in this document.

Configuring a load balancer depends on the product, and is beyond the scope of this document.

### Using DNS `SRV` Records

You can use DNS `SRV` records to assign a pool of Puppet Servers for agents to communicate with. This requires a DNS service capable of `SRV` records, which includes all major DNS software.

> **Note:**  This method makes a large number of DNS requests. Request timeouts are  completely under the DNS server's control and agents cannot cancel  requests early. SRV records don't interact well with static servers set  in the config file. Please keep these potential pitfalls in mind when  configuring your DNS!

Configure each of your agents with a `srv_domain` instead of a `server` in `puppet.conf`:

```
[main]
use_srv_records = true
srv_domain = example.comCopied!
```

Agents will then lookup a `SRV` record at `_x-puppet._tcp.example.com` when they need to talk to a Puppet server.

```
# Equal-weight load balancing between server-a and server-b:
_x-puppet._tcp.example.com. IN SRV 0 5 8140 server-a.example.com.
_x-puppet._tcp.example.com. IN SRV 0 5 8140 server-b.example.com.Copied!
```

You can also implement more complex configurations. For instance, if all devices in site A are configured with a `srv_domain` of `site-a.example.com`, and all nodes in site B are configured to `site-b.example.com`, you can configure them to prefer a server in the local site but fail over to the remote site:

```
# Site A has two servers - server-1 is beefier, give it 75% of the load:
_x-puppet._tcp.site-a.example.com. IN SRV 0 75 8140 server-1.site-a.example.com.
_x-puppet._tcp.site-a.example.com. IN SRV 0 25 8140 server-2.site-a.example.com.
_x-puppet._tcp.site-a.example.com. IN SRV 1 5 8140 server.site-b.example.com.

# For site B, prefer the local server unless it's down, then fail back to site A
_x-puppet._tcp.site-b.example.com. IN SRV 0 5 8140 server.site-b.example.com.
_x-puppet._tcp.site-b.example.com. IN SRV 1 75 8140 server-1.site-a.example.com.
_x-puppet._tcp.site-b.example.com. IN SRV 1 25 8140 server-2.site-a.example.com.Copied!
```

## Centralizing the Certificate Authority

Additional Puppet Servers should only share the burden of  compiling and serving catalogs, which is why they're typically referred  to as "compilers". Any certificate authority functions should be  delegated to a single server.

Before you centralize this functionality, ensure that the  single server that you want to use as the central CA is reachable at a  unique hostname other than (or in addition to) `puppet`. Next, point all agent requests to the centralized CA server, either by configuring each agent or through DNS `SRV` records.

### Directing individual agents to a central CA

On every agent, set the [`ca_server`](https://www.puppet.com/docs/puppet/7/configuration.html#caserver) setting in [`puppet.conf`](https://puppet.com/docs/puppet/latest/config_file_main.html) (in the `[main]` configuration block) to the hostname of the server acting as the  certificate authority. If you have a large number of existing nodes, it  is easiest to do this by managing `puppet.conf` with a Puppet module and a template.

> **Note:** Set this setting *before* provisioning new nodes, or they won't be able to complete their initial agent run.

### Pointing DNS `SRV` records at a central CA

If you [use `SRV` records for agents](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#using-dns-srv-records), you can use the `_x-puppet-ca._tcp.$srv_domain` DNS name to point clients to one specific CA server, while the `_x-puppet._tcp.$srv_domain` DNS name handles most of their requests to servers and can point to a set of compilers.

## Creating and configuring compilers

To add a compiler to your deployment, begin by [installing and configuring Puppet Server](https://www.puppet.com/docs/puppet/7/server/install_from_packages.html) on it.

Before running `puppet agent` or starting Puppet Server on the new server:

1. In the compiler's [`puppet.conf`](https://puppet.com/docs/puppet/latest/config_file_main.html), in the `[main]` configuration block, set the [`ca_server`](https://www.puppet.com/docs/puppet/7/configuration.html#caserver) setting to the hostname of the server acting as the certificate authority.

2. In the compiler's [`webserver.conf`](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html) file, add and set the following SSL settings:

   - ssl-cert
   - ssl-key
   - ssl-ca-cert
   - ssl-crl-path

3. [Disable Puppet Server's certificate authority services](https://www.puppet.com/docs/puppet/7/server/configuration.html#service-bootstrapping).

   If you're using the [individual agent configuration method of CA centralization](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#directing-individual-agents-to-a-central-ca), set `ca_server` in `puppet.conf` to the hostname of your CA server in the `[main]` config block. If an `ssldir` is configured, make sure it's configured in the `[main]` block only.

4. If you're using the [DNS round robin method](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#using-round-robin-dns) of agent load balancing, or a [load balancer](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#using-a-load-balancer) in TCP proxying mode, provide compilers with certificates using DNS Subject Alternative Names.

   Configure `dns_alt_names` in the `[main]` block of `puppet.conf` to cover every DNS name that might be used by an agent to access this server.

   ```
   dns_alt_names = puppet,puppet.example.com,puppet.site-a.example.comCopied!
   ```

   If the agent has been run or the server started and already created a certificate, remove it by running `sudo puppet ssl clean`. If an agent has requested a certificate from the server, delete it there to re-issue a new one with the alt names: `puppetserver ca clean server-2.example.com`.

5. Request a new certificate by running `puppet agent --test --waitforcert 10`.

6. Log into the CA server and run `puppetserver ca sign server-2.example.com`.

## Centralizing reports, inventory service, and catalog searching (storeconfigs)

If you use an HTTP report processor, point your server and  all of your Puppet compilers at the same shared report server in order  to see all of your agents' reports.

If you use the inventory service or exported resources, use PuppetDB and point your server and all of your Puppet compilers at a  shared PuppetDB instance. A reasonably robust PuppetDB server can handle many Puppet compilers and many thousands of agents.

See the [PuppetDB documentation](https://puppet.com/docs/puppetdb/latest/) for instructions on deploying a PuppetDB server, then configure every  Puppet compiler to use it. Note that every Puppet primary server and  compiler must have its own [allowlist entry](https://puppet.com/docs/puppetdb/latest/configure.html#certificate-allowlist) if you're using HTTPS certificates for authorization.

## Keeping manifests and modules synchronized across compilers

You must ensure that all Puppet compilers have identical copies of your manifests, modules, and [external node classifier](https://puppet.com/docs/puppet/latest/nodes_external.html) data. Examples include:

- Using a version control system such as [r10k](https://github.com/puppetlabs/r10k), Git, Mercurial, or Subversion to manage and sync your manifests, modules, and other data.
- Running an out-of-band `rsync` task via `cron`.
- Configuring `puppet agent` on each compiler to point to a designated model Puppet Server, then use Puppet itself to distribute the modules.

## Implementing load distribution

Now that your other compilers are ready, you can implement your [agent load-balancing strategy](https://www.puppet.com/docs/puppet/7/server/scaling_puppet_server.html#planning-your-load-balancing-strategy).

# Restarting Puppet Server"

### Sections

[Restarting Puppet Server to pick up changes](https://www.puppet.com/docs/puppet/7/server/restarting.html#restarting-puppet-server-to-pick-up-changes)

- [Changes applied after a JRuby pool flush, HUP signal, service reload, or full Server restart](https://www.puppet.com/docs/puppet/7/server/restarting.html#changes-applied-after-a-jruby-pool-flush-hup-signal-service-reload-or-full-server-restart)
- [Changes applied after a HUP signal, service reload, or full Server restart](https://www.puppet.com/docs/puppet/7/server/restarting.html#changes-applied-after-a-hup-signal-service-reload-or-full-server-restart)
- [Changes that require a full Server restart](https://www.puppet.com/docs/puppet/7/server/restarting.html#changes-that-require-a-full-server-restart)

Starting in version 2.3.0, you can restart Puppet Server by sending a hangup signal, also known as a [HUP signal or SIGHUP](https://en.wikipedia.org/wiki/SIGHUP), to the running Puppet Server process. The HUP signal stops Puppet  Server and reloads it gracefully, without terminating the JVM process.  This is generally *much* faster than completely  stopping and restarting the process. This allows you to quickly load  changes in Puppet Server, including configuration changes.

There are several ways to send a HUP signal to the Puppet Server process, but the most straightforward is to run the following [`kill`](http://linux.die.net/man/1/kill) command:

```
kill -HUP `pgrep -f puppet-server`Copied!
```

Starting in version 2.7.0, you can also reload Puppet  Server by running the "reload" action via the operating system's service framework. This is analogous to sending a hangup signal but with the  benefit of having the "reload" command pause until the server has been  completely reloaded, similar to how the "restart" command pauses until  the service process has been fully restarted. Advantages to using the  "reload" action as opposed to just sending a HUP signal include:

1. Unlike with the HUP signal approach, you do not have to determine the process ID of the puppetserver process to be reloaded.
2. When using the HUP signal with an automated  script (or Puppet code), it is possible that any additional commands in  the script might behave improperly if performed while the server is  still reloading. With the "reload" command, though, the server should be up and using its latest configuration before any subsequent script  commands are performed.
3. Even if the server fails to reload and shuts down --- for example, due to a configuration error --- the `kill -HUP` command might still return a 0 (success) exit code. With the "reload"  command, however, any configuration change which causes the server to  shut down will produce a non-0 (failure) exit code. The "reload"  command, therefore, would allow you to more reliably determine if the  server failed to reload properly.

Use the following commands to perform the "reload" action for Puppet Server.

All current OS distributions:

```
service puppetserver reloadCopied!
```

OS distributions which use sysvinit-style scripts:

```
/etc/init.d/puppetserver reloadCopied!
```

OS distributions which use systemd service configurations:

```
systemctl reload puppetserverCopied!
```

> **Note:** If you're using Puppet Enterprise (PE), you can reload the server from the command line by running `service pe-puppetserver reload`. However if you need to change a setting, do so in console or with  Heira, and then the agent will reload the server when it applies the  change. For more information, see [Configuring and tuning Puppet Server](https://puppet.com/docs/pe/latest/config_puppetserver.html#configuring_and_tuning_puppet_server).

## Restarting Puppet Server to pick up changes

There are three ways to trigger your Puppet Server environment to refresh and pick up changes you've made. A request to the [HTTP Admin API to flush the JRuby pool](https://www.puppet.com/docs/puppet/7/server/admin-api/v1/jruby-pool.html) is the quickest, but picks up only certain types of changes. A HUP  signal or service reload is also quick, and applies additional changes.  Other changes require a full Puppet Server restart.

> **Note:** Changes to Puppet Server's [logging configuration in `logback.xml`](https://www.puppet.com/docs/puppet/7/server/config_file_logbackxml.html) don't require a server restart. Puppet Server recognizes and applies  them automatically, though it can take a minute or so for this to  happen. However, you can restart the service to force it to recognize  those changes.

### Changes applied after a JRuby pool flush, HUP signal, service reload, or full Server restart

- Changes to your `hiera.yaml` file to change your [Hiera](https://puppet.com/docs/puppet/latest/hiera_intro.html) configuration.
- [Installation or removal of gems](https://www.puppet.com/docs/puppet/7/server/gems.html) for Puppet Server by `puppetserver gem`.
- Changes to the Ruby code for Puppet's [core dependencies](https://puppet.com/docs/puppet/latest/platform_lifecycle.html), such as Puppet, Facter, and Hiera.
- Changes to Puppet modules in an [environment](https://puppet.com/docs/puppet/latest/environments_about.html) where you've enabled [environment caching](https://www.puppet.com/docs/puppet/7/configuration.html#environmenttimeout). You can also achieve this by making a request to the [Admin API endpoint for flushing the environment cache](https://www.puppet.com/docs/puppet/7/server/admin-api/v1/environment-cache.html).
- Changes to the CA CRL file.  For example, a `puppetserver ca clean`

### Changes applied after a HUP signal, service reload, or full Server restart

- Changes to Puppet Server [configuration files](https://www.puppet.com/docs/puppet/7/server/configuration.html) in its `conf.d` directory.
- Changes to the CA CRL file.  For example, a `puppetserver ca clean`

### Changes that require a full Server restart

- Changes to JVM arguments, such as [heap size settings](https://www.puppet.com/docs/puppet/7/server/tuning_guide.html#jvm-heap-size), that are typically configured in your `/etc/sysconfig/puppetserver` or `/etc/default/puppetserver` file.
- Changes to [`ca.cfg`](https://www.puppet.com/docs/puppet/7/server/configuration.html#service-bootstrapping) to enable or disable Puppet Server's certificate authority (CA) service.

For these types of changes, you must restart the process by using the operating system's service framework, for example, by using  the `systemctl` or `service` commands.

> Note: To ensure that the Puppet Server is running in a platform agnostic way, use the `puppet resource service puppetserver ensure=running` command. This command is equivalent to `systemctl start puppetserver` on systems that support it. For more information on the resource command and managing a server’s desired state, see [Man Page: puppet resource](https://www.puppet.com/docs/puppet/7/man/resource.html) and [Resource Type: service](https://www.puppet.com/docs/puppet/7/types/service.html).

# Certificate authority and SSL

### Sections

[What's changed in Puppet 6](https://www.puppet.com/docs/puppet/7/ssl_certificates.html#whats-changed)

​        Puppet can use its built-in certificate authority (CA) and        public key infrastructure (PKI) tools or use an existing external CA for all of its secure        socket layer (SSL) communications. 

​            Puppet uses certificates to verify the the identity of            nodes. These certificates are issued by the certificate authority (CA) service of a Puppet primary server. When a node checks into the Puppet v for the first time, it requests a            certificate. The Puppet primary server examines this request, and            if it seems safe, creates a certificate for the node. When the agent node picks up this            certificate, it knows it can trust the Puppet primary server, and            it can now identify itself later when requesting a catalog.

After installing the Puppet Server, before            starting it for the first time, use the `puppetserver ca setup` command to create a default            intermediate CA. For more complex use cases, see the Intermediate and External CA            documentation.

Note: For backward compatibility, starting Puppet Server before running `puppetserver ca setup` creates the old                single-cert CA. This configuration is not recommended, so if you are using Puppet 6, use the setup command instead.

​            Puppet provides two command line tools for performing SSL            tasks: 

- ​                    `                        puppetserver                            ca                    ` signs certificate requests and revokes certificates.
- ​                    `                        puppet                            ssl                    ` performs agent-side tasks, such as submitting a certificate request or                    downloading a node certificate. 

## What's changed in Puppet 6

​                Puppet 6 removes the `puppet                    cert` command and its associated certificate-related faces. In Puppet 6 you must use the new subcommands listed                above instead.

​                Puppet 6 also introduces full support for [intermediate CAs](https://puppet.com/docs/puppetserver/latest/intermediate_ca.html), the recommended architecture. This                requires changes on both the server and the agent, so using it requires both the                server and the agent to be updated to Puppet 6.

**[Puppet Server CA commands](https://www.puppet.com/docs/puppet/7/puppet_server_ca_cli.html)**
     Puppet Server has a `puppetserver ca`     command that performs certificate authority (CA) tasks like signing and revoking certificates.     Most of its actions are performed by  making HTTP requests to Puppet Server’s CA API, specifically the `certificate_status` endpoint. You must have Puppet Server     running in order to sign or revoke certificates. **[Intermediate CA](https://www.puppet.com/docs/puppet/7/server/intermediate_ca.html)**
  **[Autosigning certificate requests](https://www.puppet.com/docs/puppet/7/ssl_autosign.html#ssl_autosign)**
Before Puppet agent nodes         can retrieve their configuration catalogs, they require a signed certificate from the local             Puppet certificate authority (CA). When using Puppet’s built-in CA instead of an external CA, agents submit         a  certificate signing request (CSR) to the CA to retrieve a signed  certificate after it's         available. **[CSR attributes and certificate extensions](https://www.puppet.com/docs/puppet/7/ssl_attributes_extensions.html#ssl_attributes_extensions)**
When Puppet agent nodes         request their certificates, the certificate signing request (CSR) usually contains only         their certname and the  necessary cryptographic information. Agents can also embed additional         data in their CSR, useful for policy-based autosigning and for  adding new trusted         facts. **[Regenerating certificates in a Puppet deployment](https://www.puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#ssl_regenerate_certificates)**
In some cases, you might need to regenerate the         certificates and  security credentials (private and public keys) that are generated by Puppet’s built-in PKI systems. **[External CA](https://www.puppet.com/docs/puppet/7/config_ssl_external_ca.html#config_ssl_external_ca)**
This information describes the supported and tested         configurations for external CAs in this version of Puppet. If         you have an external CA use case that isn’t listed here, contact Puppet so we can learn more about it. **[External SSL termination](https://www.puppet.com/docs/puppet/7/server/external_ssl_termination.html)**

# Puppet Server CA commands

### Sections

[CA subcommands](https://www.puppet.com/docs/puppet/7/puppet_server_ca_cli.html#ca-subcommands)

[API authentication](https://www.puppet.com/docs/puppet/7/puppet_server_ca_cli.html#api-authentication)

[Upgrading](https://www.puppet.com/docs/puppet/7/puppet_server_ca_cli.html#upgrade)

[Signing certificates with subject alternative names or auth extensions](https://www.puppet.com/docs/puppet/7/puppet_server_ca_cli.html#sign-certificates)

​    Puppet Server has a `puppetserver ca`    command that performs certificate authority (CA) tasks like signing and revoking certificates.    Most of its actions are performed by making HTTP requests to Puppet Server’s CA API, specifically the `certificate_status` endpoint. You must have Puppet Server    running in order to sign or revoke certificates.

## CA subcommands

If you have yet to review the actions for the `puppetserver ca` command,        visit [Subcommands](https://puppet.com/docs/puppet/7/server/subcommands.html). Some actions have additional options. Run `puppetserver ca help` for details.

The `puppetserver-ca` CLI tool is shipped as a gem alongside Puppet Server. You can update the gem between releases for bug fixes        and improvements. To update the gem, run:

```
/opt/puppetlabs/puppet/bin/gem install -i /opt/puppetlabs/puppet/lib/ruby/vendor_gems puppetserver-caCopied!
```

## API authentication

Access to the `certificate_status` API endpoint is tightly        restricted for security purposes because the endpoint lets you sign or revoke certificates.        To access the `certificate_status` and `certificate_statuses` endpoints, you must add a special extension to each        endpoint's allowlist in the `auth.conf` entries. If other CSRs        request this extension, Puppet Server refuses to sign them because        the extension is reserved (even if `allow-authorization-extensions` is set to `true`).

If you need a certificate with this extension, you can generate it offline by doing the        following:

1. Stop 

   Puppet Server

   .

   Note:

   - Although this particular use of the `generate` command requires you                to stop `puppetserver` service, all other uses of this command                require the service to be running.
   - If the tool cannot determine the status of the server, but you know the server is                offline, you can use the `--force` option to run the                command without checking server status.

2. Run `puppetserver ca generate --ca-client --certname <name>`

API authentication is required for regenerating the primary server's certificate. For        details on certificate regeneration, visit [Regenerating certificates in a Puppet         deployment](https://puppet.com/docs/puppet/7/ssl_regenerate_certificates.html#ssl_regenerate_certificates).

## Upgrading

To use the Puppet CA commands, you must update Puppet Server's          `auth.conf` to include a rule that allows the primary server's certname to        access the `certificate_status` and `certicate_statuses`        endpoints.

The following example displays how to allow the CA commands to access the `certificate_status` endpoint:

```
{
  match-request: {
 path: "/puppet-ca/v1/certificate_status"  
     type: path        
     method: [get, put, delete]    
   }    
   allow: primaryserver.example.com  
   sort-order: 500    
   name: "puppetlabs cert status"
},
Copied!
```

For more information about upgrading your `auth.conf` file, visit            `auth.conf`.

## Signing certificates with subject alternative names or auth extensions

Puppet Server's CA API can sign certificates with subject        alternative names (SANs) or auth extensions. These options are disabled by default for        security purposes. To enable these options, in the `certificate-authority` section of Puppet Server's        configuration (usually located in `ca.conf`), set `allow-subject-alt-names` or `allow-authorization-extensions` to `true`. After configuration,        you can use `puppetserver ca sign --certname <name>` to        sign certificates with these additions.

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