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

By default, Puppet's HTTPS traffic uses  port 8140. The OS and firewall must allow Puppet Server's JVM process to accept incoming connections on port 8140. If necessary, you can change the port in `webserver.conf`. See the [Configuration](https://www.puppet.com/docs/puppet/7/server/config_file_webserver.html) page for details.



默认情况下，Puppet的HTTPS流量使用端口8140。操作系统和防火墙必须允许Puppet服务器的JVM进程接受端口8140上的传入连接。如有必要，可以在webserver.conf中更改端口。有关详细信息，请参阅配置页面。

登录中

Puppet Server的所有日志都是ro

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