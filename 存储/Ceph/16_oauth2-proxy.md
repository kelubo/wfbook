# OAuth2 Proxy

[TOC]

## 部署 oauth2-proxy

在从 Squid 开始的 Ceph 发行版中，oauth2-proxy 服务引入了一种高级方法，用于管理 Ceph 应用程序的身份验证和访问控制。此服务与外部身份提供商 (IDP) 集成，通过 OIDC (OpenID Connect) 协议提供安全、灵活的身份验证。oauth2-proxy 充当身份验证网关，确保对 Ceph 应用程序（包括 Ceph 控制面板和监控堆栈）的访问受到严格控制。

要部署 oauth2-proxy 服务，请使用以下命令：

```bash
ceph orch apply oauth2-proxy [--placement ...] ...
```

应用后，cephadm 将重新配置必要的组件以使用 oauth2-proxy 进行身份验证，从而保护对所有 Ceph 应用程序的访问。该服务将处理登录流，将用户重定向到适当的 IDP 进行身份验证，并管理会话令牌以促进无缝用户访问。

## oauth2-proxy 服务的好处

- `增强的安全性`：通过使用 OIDC 协议与外部 IDP 集成来提供强大的身份验证。
- `无缝 SSO`：在所有 Ceph 应用程序中实现无缝单点登录 （SSO），从而改进用户访问控制。
- `集中式身份验证`：集中身份验证管理，降低复杂性并改进对访问的控制。

## 安全增强功能

oauth2-proxy 服务确保对 Ceph 应用程序的所有访问都经过身份验证，从而防止未经授权的用户访问敏感信息。由于它使用了 oauth2-proxy 开源项目，因此该服务可以轻松地与各种[外部 IDP](https://oauth2-proxy.github.io/oauth2-proxy/configuration/providers/) 集成，以提供安全灵活的身份验证机制。

## 高可用性

通常，oauth2-proxy 与 mgmt-gateway 结合使用。oauth2-proxy 服务可以部署为多个无状态实例，mgmt-gateway （nginx reverse-proxy） 使用 round-robin 循环策略处理这些实例之间的负载均衡。由于 oauth2-proxy 与外部身份提供商 （IDP） 集成，因此确保登录的高可用性是在外部管理的，而不是此服务的责任。

## 使用 oauth2-proxy 访问服务

部署 oauth2-proxy 后，访问 Ceph 应用程序需要通过配置的 IDP 进行身份验证。用户将被重定向到 IDP 进行登录，然后返回到请求的应用程序。此设置可确保安全访问，并与 Ceph 管理堆栈无缝集成。

## 服务规范

在部署 oauth2-proxy 服务之前，请记得通过打开 --enable_auth 标志来部署 mgmt-gateway 服务。即：

```bash
ceph orch apply mgmt-gateway --enable_auth=true
```

可以使用规范应用 oauth2-proxy 服务。YAML 中的示例如下：

```yaml
service_type: oauth2-proxy
service_id: auth-proxy
placement:
  label: mgmt
spec:
 https_address: "0.0.0.0:4180"
 provider_display_name: "My OIDC Provider"
 client_id: "your-client-id"
 oidc_issuer_url: "http://192.168.100.1:5556/dex"
 client_secret: "your-client-secret"
 cookie_secret: "your-cookie-secret"
 ssl_certificate: |
   -----BEGIN CERTIFICATE-----
   MIIDtTCCAp2gAwIBAgIYMC4xNzc1NDQxNjEzMzc2MjMyXzxvQ7EcMA0GCSqGSIb3
   DQEBCwUAMG0xCzAJBgNVBAYTAlVTMQ0wCwYDVQQIDARVdGFoMRcwFQYDVQQHDA5T
   [...]
   -----END CERTIFICATE-----
ssl_certificate_key: |
   -----BEGIN PRIVATE KEY-----
   MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5jdYbjtNTAKW4
   /CwQr/7wOiLGzVxChn3mmCIF3DwbL/qvTFTX2d8bDf6LjGwLYloXHscRfxszX/4h
   [...]
   -----END PRIVATE KEY-----
```

特定于 oauth2-proxy 服务的 `spec` 部分的字段如下所述。字段的更详细说明可以在 [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/) 上找到 项目文档。

*class* ceph.deployment.service_spec.OAuth2ProxySpec(*service_type='oauth2-proxy'*, *service_id=None*, *config=None*, *networks=None*, *placement=None*, *https_address=None*, *provider_display_name=None*, *client_id=None*, *client_secret=None*, *oidc_issuer_url=None*, *redirect_url=None*, *cookie_secret=None*, *ssl_certificate=None*, *ssl_certificate_key=None*, *allowlist_domains=None*, *unmanaged=False*, *extra_container_args=None*, *extra_entrypoint_args=None*, *custom_configs=None*)

* client_id

  用于向身份提供商进行身份验证的客户端 ID。

* client_secret

  用于向身份提供商进行身份验证的客户端密钥。

* https_address

  HTTPS 连接的地址，格式为 'host:port' 。

* networks*: List[str]*

  A list of network identities instructing the daemons to only bind on the particular networks in that list. In case the cluster is distributed across multiple networks, you can add multiple networks. See [Networks and Ports](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-networks-ports), [Specifying Networks](https://docs.ceph.com/en/latest/cephadm/services/rgw/#cephadm-rgw-networks) and [Specifying Networks](https://docs.ceph.com/en/latest/cephadm/services/mgr/#cephadm-mgr-networks). 一个网络身份列表，指示守护进程仅绑定 在该列表中的特定网络上。集群分布时 在多个网络中，您可以添加多个网络。看 [网络和端口](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-networks-ports)， [指定网络](https://docs.ceph.com/en/latest/cephadm/services/rgw/#cephadm-rgw-networks)和[指定网络](https://docs.ceph.com/en/latest/cephadm/services/mgr/#cephadm-mgr-networks)。

* oidc_issuer_url

  The URL of the OpenID Connect (OIDC) issuer. OpenID Connect （OIDC） 颁发者的 URL。

* placement*: [PlacementSpec](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#ceph.deployment.service_spec.PlacementSpec)*

  See [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec). 

* provider_display_name

  UI 中身份提供商 (IDP) 的显示名称。

* ssl_certificate

  用于加密通信的多行 SSL 证书。

* ssl_certificate_key

  用于解密通信的多行 SSL 证书私钥。

然后，可以通过运行以下命令来应用规范。一旦可用，cephadm 将自动重新部署 mgmt-gateway 服务，同时调整其配置以将身份验证重定向到新部署的 oauth2-service。

```bash
ceph orch apply -i oauth2-proxy.yaml
```

## 限制

以下是 oauth2-proxy 服务的重要限制的非详尽列表：

- 不支持 oauth2-proxy 本身的高可用性配置。
- 正确配置 IDP 和 OAuth2 参数对于避免身份验证失败至关重要。错误配置可能会导致访问问题。

### 容器镜像

oauth2-proxy 服务将使用的容器镜像可以通过运行以下命令找到：

```bash
ceph config get mgr mgr/cephadm/container_image_oauth2_proxy
```

管理员可以通过更改 `container_image_oauth2_proxy` cephadm module 选项来指定要使用的自定义镜像。如果已经有正在运行的守护程序，还必须重新部署这些守护程序，以便它们使用新映像。

例如：

```bash
ceph config set mgr mgr/cephadm/container_image_oauth2_proxy <new-oauth2-proxy-image>
ceph orch redeploy oauth2-proxy
```