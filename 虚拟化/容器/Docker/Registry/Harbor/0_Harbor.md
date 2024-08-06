# Harbor

[TOC]

## 概述

Harbor is an open source registry that secures artifacts with  policies and role-based access control, ensures images are scanned and  free from vulnerabilities, and signs images as trusted. Harbor, a CNCF  Graduated project, delivers compliance, performance, and  interoperability to help you consistently and securely manage artifacts  across cloud native compute platforms like Kubernetes and Docker.        
Harbor 是一个开源 registry ，它使用策略和基于角色的访问控制来保护工件，确保图像被扫描且没有漏洞，并将图像签名为受信任的图像。Harbor 是 CNCF  毕业的项目，可提供合规性、性能和互操作性，帮助在云原生计算平台（如 Kubernetes 和 Docker）中一致且安全地管理工件。

Harbor 可以安装在任何 Kubernetes 环境中，也可以安装在支持 Docker 的系统上。

Harbor supports integration with different 3rd-party replication  adapters for replicating data, OIDC adapters for authN/authZ, and  scanner adapters for vulnerability scanning of container images. For  information about the supported adapters, see the  [Harbor Compatibility List](https://goharbor.io/docs/2.11.0/install-config/harbor-compatibility-list/).
Harbor 支持与用于复制数据的不同第三方复制适配器、用于 authN/authZ 的 OIDC 适配器以及用于容器镜像漏洞扫描的扫描器适配器集成。有关受支持的适配器的信息，请参阅 Harbor 兼容性列表。

## 特征

* 安全
  * Security and vulnerability analysis  安全和漏洞分析
  * Content signing and validation        内容签名和验证  
* 管理
  * 多租户
  * 可扩展的 API 和 Web UI
  * 跨多个 registrie（包括 Harbor）进行复制
  * 身份集成和基于角色的访问控制

## 安装

### Harbor 组件

| 组件                      | 版本  |
| ------------------------- | ----- |
| Postgresql                | 14.10 |
| Redis                     | 7.2.2 |
| Beego                     | 2.0.6 |
| Distribution/Distribution | 2.8.3 |
| Helm                      | 2.9.1 |
| Swagger-ui                | 5.9.1 |

### 组件的兼容性

#### Replication Adapters 复制适配器

|                                                              | Registrie                                                    | Pull Mode 拉动模式                                           | Push Mode 推送模式                                           | Proxy Cache                                                  | Introduced in Release 在发布中引入 | Automated Pipeline Covered 覆盖自动化管道                    |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------- | ------------------------------------------------------------ |
| [Harbor](https://goharbor.io/)                               | ![Harbor](https://goharbor.io/docs/2.11.0/img/replication-adapters/harbor-logo.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.8                               | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |
| [distribution](https://github.com/distribution/distribution) | ![distribution](https://goharbor.io/docs/2.11.0/img/replication-adapters/distribution.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.8                               | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |
| [docker hub](https://hub.docker.com/)                        | ![docker hub](https://goharbor.io/docs/2.11.0/img/replication-adapters/docker-hub.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.8                               | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |
| [Huawei SWR](https://www.huaweicloud.com/en-us/product/swr.html) | ![Huawei SWR](https://goharbor.io/docs/2.11.0/img/replication-adapters/hw.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) | V1.8                               | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |
| [GCR](https://cloud.google.com/container-registry/)          | ![GCR](https://goharbor.io/docs/2.11.0/img/replication-adapters/gcr.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.9                               | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |
| [ECR](https://aws.amazon.com/ecr/)                           | ![ECR](https://goharbor.io/docs/2.11.0/img/replication-adapters/ecr.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.9                               | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |
| [ACR](https://azure.microsoft.com/en-us/services/container-registry/) | ![ACR](https://goharbor.io/docs/2.11.0/img/replication-adapters/acr.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.9                               | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |
| [AliCR](https://www.alibabacloud.com/product/container-registry) | ![AliCR](https://goharbor.io/docs/2.11.0/img/replication-adapters/ali-cr.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) | V1.9                               | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |
| [Artifact Hub](https://artifacthub.io/)                      | ![Artifact Hub](https://goharbor.io/docs/2.11.0/img/replication-adapters/artifacthub.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) | V2.2                               | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |
| [Artifactory](https://jfrog.com/artifactory/)                | ![Artifactory](https://goharbor.io/docs/2.11.0/img/replication-adapters/artifactory.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.10                              | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |
| [Quay](https://github.com/quay/quay)                         | ![Quay](https://goharbor.io/docs/2.11.0/img/replication-adapters/quay.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.10                              | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |
| [GitLab Registry](https://docs.gitlab.com/ee/user/packages/container_registry/) | ![GitLab Registry](https://goharbor.io/docs/2.11.0/img/replication-adapters/gitlab.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) | V1.10                              | ![N](https://goharbor.io/docs/2.11.0/img/replication-adapters/no.png) |

- `Pull` mode replicates artifacts from the specified source registries into Harbor.
   `Pull` mode 将指定源注册表中的工件复制到 Harbor 中。

- `Push` mode replicates artifacts from Harbor to the specified target registries.
   `Push` mode 将工件从 Harbor 复制到指定的目标注册表。

- `Proxy Cache` means the replication adapter can be used as a proxy cache registry.
   `Proxy Cache` 表示复制适配器可以用作代理缓存注册表。

  

#### OIDC Adapters OIDC 适配器

|                                                              | OIDC 提供商                                                  | 官方验证                                                     | 最终用户验证                                                 | Verified in Release 已通过发布验证 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------- |
| [Google Identity](https://developers.google.com/identity/protocols/OpenIDConnect) | ![google identity](https://goharbor.io/docs/2.11.0/img/OIDC/google-identity.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | V1.9                               |
| [Dex](https://github.com/dexidp/dex)                         | ![dex](https://goharbor.io/docs/2.11.0/img/OIDC/dex.png)     | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | V1.9                               |
| [Ping Identity](https://www.pingidentity.com)                | ![ping identity](https://goharbor.io/docs/2.11.0/img/OIDC/ping.png) |                                                              | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | V1.9                               |
| [Keycloak](https://www.keycloak.org/)                        | ![Keycloak](https://goharbor.io/docs/2.11.0/img/OIDC/keycloak.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | V1.10                              |
| [Auth0](https://auth0.com/)                                  | ![Auth0](https://goharbor.io/docs/2.11.0/img/OIDC/auth0.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | V1.10                              |

#### Scanner Adapters 扫描仪适配器

|                                                              | Scanners 扫描仪                                              | 供应商                                                       | Evaluated 评价                                               | As Default 默认                                              | Onboard in Release 在发布中加入 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------- |
| [Clair](https://github.com/goharbor/harbor-scanner-clair)    | ![Clair](https://goharbor.io/docs/2.11.0/img/scanners/clair.png) | CentOS                                                       | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | （在 v2.2 中默认删除）                                       | v1.10                           |
| [Anchore](https://github.com/anchore/harbor-scanner-adapter) | ![Anchore](https://goharbor.io/docs/2.11.0/img/scanners/anchore.png) | Anchore                                                      | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v1.10                           |
| [Trivy](https://github.com/aquasecurity/harbor-scanner-trivy) | ![Trivy](https://goharbor.io/docs/2.11.0/img/scanners/trivy.png) | Aqua                                                         | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) | v1.10                           |
| [CSP](https://github.com/aquasecurity/harbor-scanner-aqua)   | ![Aqua](https://goharbor.io/docs/2.11.0/img/scanners/aqua.png) | Aqua                                                         | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v1.10                           |
| [DoSec](https://github.com/dosec-cn/harbor-scanner/blob/master/README_en.md) | ![DoSec](https://goharbor.io/docs/2.11.0/img/scanners/dosec.png) | DoSec                                                        | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v1.10                           |
| [Sysdig Secure](https://github.com/sysdiglabs/harbor-scanner-sysdig-secure) | ![Sysdig](https://goharbor.io/docs/2.11.0/img/scanners/sysdig.png) | Sysdig                                                       | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v2.1.0                          |
| [TensorSecurity](https://github.com/tensorsecurity/harbor-scanner) | <img src="https://goharbor.io/docs/2.11.0/img/scanners/tensorsecurity.png" alt="TensorSecurity" style="zoom: 33%;" /> | TensorSecurity                                               | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v2.2.0                          |
| [ArksecScanner](https://github.com/arksec-cn)                | <img src="https://goharbor.io/docs/2.11.0/img/scanners/arksec.png" alt="Arksec" style="zoom:33%;" /> | Arksec                                                       | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v2.4.0                          |
| [Cyberwatch](https://github.com/Cyberwatch)                  | <img src="https://goharbor.io/docs/2.11.0/img/scanners/cyberwatch.png" alt="Cyberwatch" style="zoom: 25%;" /> | [Cyberwatch](https://cyberwatch.fr/integrate-with-harbor-scans) | ![Y](https://goharbor.io/docs/2.11.0/img/replication-adapters/right.png) |                                                              | v2.8.0                          |

- `Evaluated` means that the scanner implementation has been officially tested and verified.
   `Evaluated` 表示扫描程序实现已经过官方测试和验证。
- `As Default` means that the scanner is provided as a default option and can be  deployed together with the main Harbor components by providing extra  options during installation. You must install other scanners manually.
   `As Default` 表示扫描仪作为默认选项提供，并且可以通过在安装过程中提供额外选项与主要 Harbor 组件一起部署。您必须手动安装其他扫描仪。

### 硬件

下表列出了部署 Harbor 的最低硬件配置和推荐的硬件配置。

| 资源 | 最低  | 推荐   |
| ---- | ----- | ------ |
| CPU  | 2 CPU | 4 CPU  |
| 内存 | 4 GB  | 8 GB   |
| 磁盘 | 40 GB | 160 GB |

### 软件

下表列出了必须在目标主机上安装的软件版本。

| Software 软件  | 版本                                                         | 描述                         |
| -------------- | ------------------------------------------------------------ | ---------------------------- |
| Docker Engine  | 版本 20.10.10-ce+ 或更高版本                                 |                              |
| Docker Compose | docker-compose （v1.18.0+） 或 docker compose v2 （docker-compose-plugin） |                              |
| OpenSSL        | 最新版本是首选                                               | 用于生成 Harbor 的证书和密钥 |

### 网络端口

Harbor 要求在目标主机上打开以下端口：

| 端口 | 协议  | 描述                                                         |
| ---- | ----- | ------------------------------------------------------------ |
| 443  | HTTPS | Harbor 门户和核心 API 接受此端口上的 HTTPS 请求。您可以在配置文件中更改此端口。 |
| 4443 | HTTPS | Connections to the Docker Content Trust service for Harbor. You can change this port in the configuration file. 连接到 Harbor 的 Docker 内容信任服务。您可以在配置文件中更改此端口。 |
| 80   | HTTP  | Harbor 门户和核心 API 接受此端口上的 HTTP 请求。您可以在配置文件中更改此端口。 |

### 下载并解压缩安装程序

可以从官方发布页面下载 Harbor 安装程序。下载联机安装程序或脱机安装程序。

- **Online installer**

  在线安装程序从 Docker Hub 下载 Harbor 镜像。因此，安装程序的尺寸非常小。

- **Offline installer**

  离线安装程序：如果部署 Harbor 的主机没有连接到 Internet，请使用离线安装程序。脱机安装程序包含预构建的映像，因此它比联机安装程序大。

在线和离线安装程序的安装过程几乎相同。

1. Go to the  [Harbor releases page](https://github.com/goharbor/harbor/releases).
   转到 Harbor 版本页面。

2. 下载要安装的版本的在线或离线安装程序。

3. Optionally download the corresponding `*.asc` file to verify that the package is genuine.
   （可选）下载相应的 `*.asc` 文件以验证包是否为正版。

   该 `*.asc` 文件是 OpenPGP 密钥文件。执行以下步骤以验证下载的捆绑包是否为正版。

   1. Obtain the public key for the `*.asc` file.
      获取 `*.asc` 文件的公钥。

      ```sh
      gpg --keyserver hkps://keyserver.ubuntu.com --receive-keys 644FF454C0B4115C
      ```

      You should see the message ` public key "Harbor-sign (The key for signing Harbor build) <jiangd@vmware.com>" imported`
      您应该会看到以下消息 ` public key "Harbor-sign (The key for signing Harbor build) <jiangd@vmware.com>" imported` 

   2. Verify that the package is genuine by running one of the following commands.
      通过运行以下命令之一来验证包是否为正版。

      - Online installer: 在线安装人员：

        ```sh
        gpg -v --keyserver hkps://keyserver.ubuntu.com --verify harbor-online-installer-version.tgz.asc
        ```

      - Offline installer: 离线安装程序：

        ```sh
        gpg -v --keyserver hkps://keyserver.ubuntu.com --verify harbor-offline-installer-version.tgz.asc
        ```

      The `gpg` command verifies that the bundle’s signature matches that of the `*.asc` key file. You should see confirmation that the signature is correct.
      该 `gpg` 命令验证捆绑软件的签名是否与 `*.asc` 密钥文件的签名匹配。您应该会看到签名正确的确认信息。

      ```sh
      gpg: armor header: Version: GnuPG v1
      gpg: assuming signed data in 'harbor-online-installer-v2.0.2.tgz'
      gpg: Signature made Tue Jul 28 09:49:20 2020 UTC
      gpg:                using RSA key 644FF454C0B4115C
      gpg: using pgp trust model
      gpg: Good signature from "Harbor-sign (The key for signing Harbor build) <jiangd@vmware.com>" [unknown]
      gpg: WARNING: This key is not certified with a trusted signature!
      gpg:          There is no indication that the signature belongs to the owner.
      Primary key fingerprint: 7722 D168 DAEC 4578 06C9  6FF9 644F F454 C0B4 115C
      gpg: binary signature, digest algorithm SHA1, key algorithm rsa4096
      ```

4. 用 `tar` 解压安装程序包：

   - Online installer: 

     ```sh
     bash $ tar xzvf harbor-online-installer-version.tgz
     ```

   - Offline installer: 

     ```sh
     bash $ tar xzvf harbor-offline-installer-version.tgz
     ```

### 配置对 Harbor 的 HTTPS 访问

By default, Harbor does not ship with certificates. It is possible to  deploy Harbor without security, so that you can connect to it over HTTP. However, using HTTP is acceptable only in air-gapped test or  development environments that do not have a connection to the external  internet. Using HTTP in environments that are not air-gapped exposes you to man-in-the-middle attacks. In production environments, always use  HTTPS.
默认情况下，Harbor 不附带证书。可以在没有安全性的情况下部署 Harbor，因此您可以通过 HTTP 连接到它。但是，只有在没有连接到外部 Internet  的气隙测试或开发环境中，才可接受使用 HTTP。在没有气隙的环境中使用 HTTP 会使您面临中间人攻击的风险。在生产环境中，请始终使用  HTTPS。

To configure HTTPS, you must create SSL certificates. You can use  certificates that are signed by a trusted third-party CA, or you can use self-signed certificates. This section describes how to use  [OpenSSL](https://www.openssl.org/) to create a CA, and how to use your CA to sign a server certificate and a client certificate. You can use other CA providers, for example  [Let’s Encrypt](https://letsencrypt.org/).
要配置 HTTPS，您必须创建 SSL 证书。您可以使用由受信任的第三方 CA  签名的证书，也可以使用自签名证书。本节介绍如何使用OpenSSL创建CA，以及如何使用CA签署服务器证书和客户端证书。您可以使用其他 CA  提供程序，例如 Let's Encrypt。

The procedures below assume that your Harbor registry’s hostname is `yourdomain.com`, and that its DNS record points to the host on which you are running Harbor.
以下过程假设您的 Harbor 注册表的主机名是 `yourdomain.com` ，并且其 DNS 记录指向您运行 Harbor 的主机。

#### Generate a Certificate Authority Certificate 生成证书颁发机构证书

In a production environment, you should obtain a certificate from a CA. In a test or development environment, you can generate your own CA. To  generate a CA certficate, run the following commands.
在生产环境中，应从 CA 获取证书。在测试或开发环境中，您可以生成自己的 CA。要生成 CA 证书，请运行以下命令。

1. Generate a CA certificate private key.
   生成 CA 证书私钥。

   ```sh
   openssl genrsa -out ca.key 4096
   ```

2. Generate the CA certificate.
   生成 CA 证书。

   Adapt the values in the `-subj` option to reflect your organization. If you use an FQDN to connect your Harbor host, you must specify it as the common name (`CN`) attribute.
   调整 `-subj` 选项中的值以反映您的组织。如果使用 FQDN 连接 Harbor 主机，则必须将其指定为公用名 （ `CN` ） 属性。

   ```sh
   openssl req -x509 -new -nodes -sha512 -days 3650 \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=MyPersonal Root CA" \
    -key ca.key \
    -out ca.crt
   ```

#### Generate a Server Certificate 生成服务器证书

The certificate usually contains a `.crt` file and a `.key` file, for example, `yourdomain.com.crt` and `yourdomain.com.key`.
证书通常包含一个 `.crt` 文件和一个 `.key` 文件，例如， `yourdomain.com.crt` 和 `yourdomain.com.key` 。

1. Generate a private key.
   生成私钥。

   ```sh
   openssl genrsa -out yourdomain.com.key 4096
   ```

2. Generate a certificate signing request (CSR).
   生成证书签名请求 （CSR）。

   Adapt the values in the `-subj` option to reflect your organization. If you use an FQDN to connect your Harbor host, you must specify it as the common name (`CN`) attribute and use it in the key and CSR filenames.
   调整 `-subj` 选项中的值以反映您的组织。如果使用 FQDN 连接 Harbor 主机，则必须将其指定为公用名 （ `CN` ） 属性，并在密钥和 CSR 文件名中使用它。

   ```sh
   openssl req -sha512 -new \
       -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=yourdomain.com" \
       -key yourdomain.com.key \
       -out yourdomain.com.csr
   ```

3. Generate an x509 v3 extension file.
   生成 x509 v3 扩展文件。

   Regardless of whether you’re using either an FQDN or an IP address to connect to  your Harbor host, you must create this file so that you can generate a  certificate for your Harbor host that complies with the Subject  Alternative Name (SAN) and x509 v3 extension requirements. Replace the `DNS` entries to reflect your domain.
   无论是使用 FQDN 还是 IP 地址连接到 Harbor 主机，都必须创建此文件，以便为 Harbor 主机生成符合使用者备用名称 （SAN） 和 x509 v3 扩展要求的证书。替换条目 `DNS` 以反映您的域。

   ```sh
   cat > v3.ext <<-EOF
   authorityKeyIdentifier=keyid,issuer
   basicConstraints=CA:FALSE
   keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
   extendedKeyUsage = serverAuth
   subjectAltName = @alt_names
   
   [alt_names]
   DNS.1=yourdomain.com
   DNS.2=yourdomain
   DNS.3=hostname
   EOF
   ```

4. Use the `v3.ext` file to generate a certificate for your Harbor host.
   使用该文件 `v3.ext` 为您的 Harbor 主机生成证书。

   Replace the `yourdomain.com` in the CSR and CRT file names with the Harbor host name.
   将 CSR 和 CRT 文件名替换为 `yourdomain.com` Harbor 主机名。

   ```sh
   openssl x509 -req -sha512 -days 3650 \
       -extfile v3.ext \
       -CA ca.crt -CAkey ca.key -CAcreateserial \
       -in yourdomain.com.csr \
       -out yourdomain.com.crt
   ```

#### Provide the Certificates to Harbor and Docker 向 Harbor 和 Docker 提供证书

After generating the `ca.crt`, `yourdomain.com.crt`, and `yourdomain.com.key` files, you must provide them to Harbor and to Docker, and reconfigure Harbor to use them.
生成 `ca.crt` 、 `yourdomain.com.crt` 和 `yourdomain.com.key` 文件后，您必须将它们提供给 Harbor 和 Docker，并重新配置 Harbor 以使用它们。

1. Copy the server certificate and key into the certficates folder on your Harbor host.
   将服务器证书和密钥复制到 Harbor 主机上的 certficates 文件夹中。

   ```sh
   cp yourdomain.com.crt /data/cert/
   cp yourdomain.com.key /data/cert/
   ```

2. Convert `yourdomain.com.crt` to `yourdomain.com.cert`, for use by Docker.
   转换为 `yourdomain.com.crt` `yourdomain.com.cert` ，供 Docker 使用。

   The Docker daemon interprets `.crt` files as CA certificates and `.cert` files as client certificates.
   Docker 守护程序将 `.crt` 文件解释为 CA 证书， `.cert` 并将文件解释为客户端证书。

   ```sh
   openssl x509 -inform PEM -in yourdomain.com.crt -out yourdomain.com.cert
   ```

3. Copy the server certificate, key and CA files into the Docker certificates  folder on the Harbor host. You must create the appropriate folders  first.
   将服务器证书、密钥和 CA 文件复制到 Harbor 主机上的 Docker 证书文件夹中。您必须先创建相应的文件夹。

   ```sh
   cp yourdomain.com.cert /etc/docker/certs.d/yourdomain.com/
   cp yourdomain.com.key /etc/docker/certs.d/yourdomain.com/
   cp ca.crt /etc/docker/certs.d/yourdomain.com/
   ```

   If you mapped the default `nginx` port 443 to a different port, create the folder `/etc/docker/certs.d/yourdomain.com:port`, or `/etc/docker/certs.d/harbor_IP:port`.
   如果将默认 `nginx` 端口 443 映射到其他端口，请创建文件夹 `/etc/docker/certs.d/yourdomain.com:port` 或 `/etc/docker/certs.d/harbor_IP:port` 。

4. Restart Docker Engine. 重启 Docker Engine。

   ```sh
   systemctl restart docker
   ```

You might also need to trust the certificate at the OS level. See  [Troubleshooting Harbor Installation](https://goharbor.io/docs/2.11.0/install-config/troubleshoot-installation/#https) for more information.
您可能还需要在操作系统级别信任证书。有关更多信息，请参阅 Harbor 安装疑难解答。

The following example illustrates a configuration that uses custom certificates.
以下示例演示了使用自定义证书的配置。

```fallback
/etc/docker/certs.d/
    └── yourdomain.com:port
       ├── yourdomain.com.cert  <-- Server certificate signed by CA
       ├── yourdomain.com.key   <-- Server key signed by CA
       └── ca.crt               <-- Certificate authority that signed the registry certificate
```

#### Deploy or Reconfigure Harbor 部署或重新配置 Harbor

If you have not yet deployed Harbor, see  [Configure the Harbor YML File](https://goharbor.io/docs/2.11.0/install-config/configure-yml-file/) for information about how to configure Harbor to use the certificates by specifying the `hostname` and `https` attributes in `harbor.yml`.
如果您尚未部署 Harbor，请参阅配置 Harbor YML 文件，了解如何通过在 `hostname` 中指定 和 `https` 属性来配置 Harbor 以使用证书 `harbor.yml` 。

If you already deployed Harbor with HTTP and want to reconfigure it to use HTTPS, perform the following steps.
如果您已经使用 HTTP 部署了 Harbor，并希望将其重新配置为使用 HTTPS，请执行以下步骤。

1. Run the `prepare` script to enable HTTPS.
   运行脚本以 `prepare` 启用 HTTPS。

   Harbor uses an `nginx` instance as a reverse proxy for all services. You use the `prepare` script to configure `nginx` to use HTTPS. The `prepare` is in the Harbor installer bundle, at the same level as the `install.sh` script.
   Harbor 使用实例 `nginx` 作为所有服务的反向代理。您可以使用脚本 `prepare` 配置为 `nginx` 使用 HTTPS。它 `prepare` 位于 Harbor 安装程序捆绑包中，与 `install.sh` 脚本处于同一级别。

   ```sh
   ./prepare
   ```

2. If Harbor is running, stop and remove the existing instance.
   如果 Harbor 正在运行，请停止并删除现有实例。

   Your image data remains in the file system, so no data is lost.
   您的图像数据将保留在文件系统中，因此不会丢失任何数据。

   ```sh
   docker-compose down -v
   ```

3. Restart Harbor: 重启 Harbor：

   ```sh
   docker-compose up -d
   ```

#### Verify the HTTPS Connection 验证 HTTPS 连接

After setting up HTTPS for Harbor, you can verify the HTTPS connection by performing the following steps.
为 Harbor 设置 HTTPS 后，您可以通过执行以下步骤来验证 HTTPS 连接。

- Open a browser and enter https://yourdomain.com. It should display the Harbor interface.
  打开浏览器并输入 https://yourdomain.com。它应该显示 Harbor 界面。

  Some browsers might show a warning stating that the Certificate Authority  (CA) is unknown. This happens when using a self-signed CA that is not  from a trusted third-party CA. You can import the CA to the browser to  remove the warning.
  某些浏览器可能会显示一条警告，指出证书颁发机构 （CA） 未知。当使用不是来自受信任的第三方 CA 的自签名 CA 时，会发生这种情况。您可以将 CA 导入浏览器以删除警告。

- On a machine that runs the Docker daemon, check the `/etc/docker/daemon.json` file to make sure that the `-insecure-registry` option is not set for https://yourdomain.com.
  在运行 Docker 守护程序的计算机上，检查 `/etc/docker/daemon.json` 文件以确保未为 https://yourdomain.com 设置该 `-insecure-registry` 选项。

- Log into Harbor from the Docker client.
  从 Docker 客户端登录 Harbor。

  ```sh
  docker login yourdomain.com
  ```

  If you’ve mapped `nginx` 443 port to a different port,add the port in the `login` command.
  如果已将 `nginx` 443 端口映射到其他端口，请在 `login` 命令中添加该端口。

  ```sh
  docker login yourdomain.com:port
  ```

### 配置 Harbor 组件之间的内部 TLS 通信

By default, The internal communication between Harbor’s component  (harbor-core,harbor-jobservice,proxy,harbor-portal,registry,registryctl,trivy_adapter,chartmuseum) use HTTP protocol which might not be secure enough for some production  environment. Since Harbor v2.0, TLS can be used for this internal  network. In production environments, always use HTTPS is a recommended  best practice.
默认情况下，Harbor  组件（harbor-core、harbor-jobservice、proxy、harbor-portal、registry、registryctl、trivy_adapter、chartmuseum）之间的内部通信使用 HTTP 协议，这对于某些生产环境来说可能不够安全。从 Harbor v2.0 开始，TLS 可以用于这个内部网络。在生产环境中，始终使用  HTTPS 是推荐的最佳做法。

This functionality is introduced via the `internal_tls` in `harbor.yml` file. To enabled internal TLS, set `enabled` to `true` and set the `dir` value to the path of directory that contains the internal cert files.
此功能是通过 `internal_tls` in `harbor.yml` 文件引入的。要启用内部 TLS，请将值设置为 `enabled` 包含内部证书文件的目录路径， `true` 并将其设置为该 `dir` 路径。

All certs can be automatically generated by `prepare` tool.
所有证书都可以通过 `prepare` 工具自动生成。

```bash
docker run -v /:/hostfs goharbor/prepare:<current_harbor_version> gencert -p /path/to/internal/tls/cert
```

User also can provide their own CA to generate the other certs. Just put  certificate and key of the CA on internal tls cert directory and name  them as `harbor_internal_ca.key` and `harbor_internal_ca.crt`. Besides, a user can also provide the certs for all components. However, there are some constraints for the certs:
用户还可以提供自己的 CA 来生成其他证书。只需将 CA 的证书和密钥放在内部 tls 证书目录中，并将它们命名为 `harbor_internal_ca.key` 和 `harbor_internal_ca.crt` 。此外，用户还可以提供所有组件的证书。但是，证书存在一些限制：

- First, all certs must be signed by a single unique CA
  首先，所有证书必须由单个唯一 CA 签名

- Second, the filename of the internal cert and `CN` field on cert file must follow the convention listed below’
  其次，内部证书的文件名和 `CN` 证书文件上的字段必须遵循下面列出的约定。

- Third, because the self signed certificate without SAN was deprecated in  Golang 1.5, you must add the SAN extension to your cert files when  generating certs by yourself or the Harbor instance will not start up  normally. The DNS name in SAN extension should the same as CN field in  the table below. For more information please refer to 

  golang 1.5 release notes

   and 

  this issue

  .

  
  第三，由于 Golang 1.5 中已经弃用了不带 SAN 的自签名证书，因此在自行生成证书时，您必须将 SAN 扩展添加到证书文件中，否则 Harbor 实例将无法正常启动。SAN 扩展中的 DNS 名称应与下表中的 CN 字段相同。更多信息请参考 golang 1.5 发布说明和本期。

  | name 名字                | usage 用法                                                   | CN              |
  | ------------------------ | ------------------------------------------------------------ | --------------- |
  | `harbor_internal_ca.key` | ca’s key file for internal TLS ca 的内部 TLS 密钥文件        | N/A             |
  | `harbor_internal_ca.crt` | ca’s certificate file for internal TLS ca 的内部 TLS 证书文件 | N/A             |
  | `core.key`               | core’s key file 核心的密钥文件                               | N/A             |
  | `core.crt`               | core’s certificate file 核心的证书文件                       | `core`          |
  | `job_service.key`        | job_service’s key file job_service的密钥文件                 | N/A             |
  | `job_service.crt`        | job_service’s certificate file job_service的证书文件         | `jobservice`    |
  | `proxy.key`              | proxy’s key file 代理的密钥文件                              | N/A             |
  | `proxy.crt`              | proxy’s certificate file 代理的证书文件                      | `proxy`         |
  | `portal.key`             | portal’s key file 门户的密钥文件                             | N/A             |
  | `portal.crt`             | portal’s certificate file 门户的证书文件                     | `portal`        |
  | `registry.key`           | registry’s key file 注册表的密钥文件                         | N/A             |
  | `registry.crt`           | registry’s certificate file 注册表的证书文件                 | `registry`      |
  | `registryctl.key`        | registryctl’s key file RegistryCTL 的密钥文件                | N/A             |
  | `registryctl.crt`        | registryctl’s certificate file RegistryCTL 的证书文件        | `registryctl`   |
  | `trivy_adapter.key`      | trivy_adapter.’s key file trivy_adapter.的密钥文件           | N/A             |
  | `trivy_adapter.crt`      | trivy_adapter.’s certificate file trivy_adapter.的证书文件   | `trivy-adapter` |

### 配置 Harbor YML 文件

You set system level parameters for Harbor in the `harbor.yml` file that is contained in the installer package. These parameters take effect when you run the `install.sh` script to install or reconfigure Harbor.
您可以在安装程序包中包含的 `harbor.yml` 文件中为 Harbor 设置系统级参数。当您运行 `install.sh` 脚本以安装或重新配置 Harbor 时，这些参数将生效。

After the initial deployment and after you have started Harbor, you perform additional configuration in the Harbor Web Portal.
在初始部署和启动 Harbor 之后，您可以在 Harbor Web 门户中执行其他配置。

### Required Parameters 必需参数

The table below lists the parameters that must be set when you deploy  Harbor. By default, all of the required parameters are uncommented in  the `harbor.yml` file. The optional parameters are commented with `#`. You do not necessarily need to change the values of the required  parameters from the defaults that are provided, but these parameters  must remain uncommented. At the very least, you must update the `hostname` parameter.
下表列出了部署 Harbor 时必须设置的参数。默认情况下， `harbor.yml` 所有必需的参数在文件中均未注释。可选参数用 `#` 注释。您不一定需要从提供的默认值中更改所需参数的值，但这些参数必须保持未注释状态。至少，您必须更新参数 `hostname` 。

**IMPORTANT**: Harbor does not ship with any certificates. In versions up to and  including 1.9.x, by default Harbor uses HTTP to serve registry requests. This is acceptable only in air-gapped test or development environments. In production environments, always use HTTPS.
重要提示：Harbor 不附带任何证书。在 1.9.x 及之前的版本中，默认情况下，Harbor 使用 HTTP 来处理注册表请求。这仅在气隙测试或开发环境中是可接受的。在生产环境中，请始终使用 HTTPS。

You can use certificates that are signed by a trusted third-party CA, or  you can use self-signed certificates. For information about how to  create a CA, and how to use a CA to sign a server certificate and a  client certificate, see  [Configuring Harbor with HTTPS Access](https://goharbor.io/docs/2.11.0/install-config/configure-https/).
您可以使用由受信任的第三方 CA 签名的证书，也可以使用自签名证书。有关如何创建 CA 以及如何使用 CA 签署服务器证书和客户端证书的信息，请参阅配置 Harbor 以进行 HTTPS 访问。

| Parameter 参数          | Sub-parameters 子参数   | Description and Additional Parameters  描述和其他参数        |
| ----------------------- | ----------------------- | ------------------------------------------------------------ |
| `hostname`              | None 没有               | Specify the IP address or the fully qualified domain name (FQDN) of the target  host on which to deploy Harbor. This is the address at which you access  the Harbor Portal and the registry service. For example, `192.168.1.10` or `reg.yourdomain.com`. The registry service must be accessible to external clients, so do not specify `localhost`, `127.0.0.1`, or `0.0.0.0` as the hostname. 指定要部署 Harbor 的目标主机的 IP 地址或完全限定域名 （FQDN）。这是您访问 Harbor 门户和注册表服务的地址。例如， `192.168.1.10` 或 `reg.yourdomain.com` .注册表服务必须可供外部客户端访问，因此请勿指定 `localhost` 、 `127.0.0.1` 或 作为 `0.0.0.0` 主机名。 |
| `http`                  |                         | Do not use HTTP in production environments. Using HTTP is acceptable only  in air-gapped test or development environments that do not have a  connection to the external internet. Using HTTP in environments that are not air-gapped exposes you to man-in-the-middle attacks. 请勿在生产环境中使用 HTTP。只有在没有连接到外部 Internet 的气隙测试或开发环境中，才可接受使用 HTTP。在没有气隙的环境中使用 HTTP 会使您面临中间人攻击的风险。 |
|                         | `port`                  | Port number for HTTP, for both Harbor portal and Docker commands. The default is 80. HTTP 的端口号，用于 Harbor 门户和 Docker 命令。默认值为 80。 |
| `https`                 |                         | Use HTTPS to access the Harbor Portal and the token/notification service.  Always use HTTPS in production environments and environments that are  not air-gapped.       使用 HTTPS 访问 Harbor 门户和令牌/通知服务。始终在生产环境和无气隙环境中使用 HTTPS。 |
|                         | `port`                  | The port number for HTTPS, for both Harbor portal and Docker commands. The default is 443. HTTPS 的端口号，用于 Harbor 门户和 Docker 命令。默认值为 443。 |
|                         | `certificate`           | The path to the SSL certificate. SSL 证书的路径。            |
|                         | `private_key`           | The path to the SSL key. SSL 密钥的路径。                    |
| `internal_tls`          |                         | Use HTTPS to communicate between harbor components 使用 HTTPS 在 Harbor 组件之间进行通信 |
|                         | `enabled`               | Set this flag to `true` means internal tls is enabled 将此标志设置为 `true` 表示已启用内部 tls |
|                         | `dir`                   | The path to the directory that contains internal certs and keys 包含内部证书和密钥的目录的路径 |
| `harbor_admin_password` | None 没有               | Set an initial password for the Harbor system administrator. This password  is only used on the first time that Harbor starts. On subsequent logins, this setting is ignored and the administrator's password is set in the  Harbor Portal. The default username and password are `admin` and `Harbor12345`. 为 Harbor 系统管理员设置初始密码。此密码仅在 Harbor 首次启动时使用。在后续登录时，此设置将被忽略，并在 Harbor 门户中设置管理员的密码。默认用户名和密码为 `admin` 和 `Harbor12345` 。 |
| `database`              |                         | Use a local PostgreSQL database. You can optionally configure an external  database, in which case you can deactivate this option. 使用本地 PostgreSQL 数据库。您可以选择配置外部数据库，在这种情况下，您可以停用此选项。 |
|                         | `password`              | Set the root password for the local database. You must change this password for production deployments. 设置本地数据库的 root 密码。对于生产部署，您必须更改此密码。 |
|                         | `max_idle_conns`        | The maximum number of connections in the idle connection pool. If it <=0, no idle connections are retained. 空闲连接池中的最大连接数。如果 <=0，则不保留任何空闲连接。 |
|                         | `max_open_conns`        | The maximum number of open connections to the database. If it <= 0, then there is no limit on the number of open connections. 打开的数据库连接的最大数目。如果 <= 0，则对打开的连接数没有限制。 |
|                         | `conn_max_lifetime`     | The maximum amount of time a connection may be reused. If it <= 0, connections are not closed due to a connection's age. 连接可以重复使用的最长时间。如果 <= 0，则不会因连接的年龄而关闭连接。 |
|                         | `conn_max_idle_time`    | The maximum amount of time a connection may be idle. If it <= 0, connections are not closed due to a connection's idle time. 连接可能处于空闲状态的最长时间。如果 <= 0，则不会由于连接的空闲时间而关闭连接。 |
| `data_volume`           | None 没有               | The location on the target host in which to store Harbor's data. This data  remains unchanged even when Harbor's containers are removed and/or  recreated. You can optionally configure external storage, in which case  deactivate this option and enable `storage_service`. The default is `/data`. 目标主机上存储 Harbor 数据的位置。即使 Harbor 的集装箱被移除和/或重新创建，这些数据也保持不变。您可以选择配置外部存储，在这种情况下，请停用此选项并启用 `storage_service` 。缺省值为 `/data` 。 |
| `trivy`                 |                         | Configure Trivy scanner. 配置 Trivy 扫描器。                 |
|                         | `ignore_unfixed`        | Set the flag to `true` to display only fixed vulnerabilities. The default value is `false` 将标志设置为 `true` 仅显示已修复的漏洞。默认值为 `false` |
|                         | `security_check`        | Comma-separated list of what security issues to detect. Possible values are `vuln`, `config` and `secret`. Defaults to `vuln`. 以逗号分隔的要检测的安全问题列表。可能的值为 `vuln` 、 `config` 和 `secret` 。缺省值为 `vuln` . |
|                         | `skip_update`           | You might want to enable this flag in test or CI/CD environments to avoid  GitHub rate limiting issues. If the flag is enabled you have to download the `trivy-offline.tar.gz` archive manually, extract and the `trivy.db` and `metadata.json` files and mount them in the `/home/scanner/.cache/trivy/db/trivy.db` path in container. The default value is `false` 您可能希望在测试或 CI/CD 环境中启用此标志，以避免 GitHub 速率限制问题。如果启用了该标志，则必须手动下载 `trivy-offline.tar.gz` 存档，提取和 `trivy.db` and `metadata.json` 文件，并将它们挂载到容器的路径中 `/home/scanner/.cache/trivy/db/trivy.db` 。默认值为 `false` |
|                         | `insecure`              | Set the flag to `true` to skip verifying registry certificate. The default value is `false` 将标志设置为 `true` 跳过验证注册表证书。默认值为 `false` |
|                         | `github_token`          | Set the GitHub access token to download Trivy DB. Trivy DB is downloaded by Trivy from the GitHub release page. Anonymous downloads from GitHub are subject to the limit of 60 requests per hour. Normally such rate limit  is enough for production operations. If, for any reason, it's not  enough, you could increase the rate limit to 5000 requests per hour by  specifying the GitHub access token. For more details on GitHub rate  limiting please consult https://developer.github.com/v3/#rate-limiting  .You can create a GitHub token by following the instructions in  https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line 设置 GitHub 访问令牌以下载 Trivy DB。Trivy DB 由 Trivy 从 GitHub 发布页面下载。从 GitHub  匿名下载的限制为每小时 60 个请求。通常，这样的速率限制对于生产操作来说已经足够了。如果出于任何原因这还不够，您可以通过指定 GitHub  访问令牌将速率限制增加到每小时 5000 个请求。有关 GitHub 速率限制的更多详细信息，请参阅  https://developer.github.com/v3/#rate-limiting。您可以按照  https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line 中的说明创建 GitHub 令牌 |
| `jobservice`            | `max_job_workers`       | The maximum number of replication workers in the job service. For each  image replication job, a worker synchronizes all tags of a repository to the remote destination. Increasing this number allows more concurrent  replication jobs in the system. However, since each worker consumes a  certain amount of network/CPU/IO resources, set the value of this  attribute based on the hardware resource of the host. The default is 10. 作业服务中复制工作线程的最大数量。对于每个镜像复制作业，工作线程将存储库的所有标签同步到远程目标。增加此数字允许系统中有更多的并发复制作业。但是，由于每个worker消耗一定数量的网络/CPU/IO资源，因此请根据主机的硬件资源设置此属性的值。默认值为 10。 |
| `notification`          | `webhook_job_max_retry` | Set the maximum number of retries for web hook jobs. The default is 10. 设置 Web 挂钩作业的最大重试次数。默认值为 10。 |
| `log`                   |                         | Configure logging. Harbor uses `rsyslog` to collect the logs for each container. 配置日志记录。Harbor 使用“rsyslog”来收集每个容器的日志。 |
|                         | `level`                 | Set the logging level to `debug`, `info`, `warning`, `error`, or `fatal`. The default is `info`. 将日志记录级别设置为 `debug` 、 `info` 、 `warning` 、 `error` 或 `fatal` 。缺省值为 `info` 。 |
|                         | `local`                 | Set the log retention parameters: 设置日志保留参数：          `rotate_count`: Log files are rotated `rotate_count` times before being removed. If count is 0, old versions are removed rather than rotated. The default is 50.  `rotate_count` ：日志文件在被删除之前会轮换 `rotate_count` 几次。如果 count 为 0，则删除旧版本，而不是轮换旧版本。默认值为 50。          `rotate_size`: Log files are rotated only if they grow bigger than `rotate_size` bytes. Use `k` for kilobytes, `M` for megabytes, and `G` for gigabytes.  `100`, `100k`, `100M` and `100G` are all valid values. The default is 200M.  `rotate_size` ：仅当日志文件大于 `rotate_size` 字节数时，才会轮换日志文件。用于 `k` 千字节、 `M` 兆字节和 `G` 千兆字节。 `100` 、 `100k` 、 `100M` 和 `100G` 都是有效值。默认值为 200M。          `location`: Set the directory in which to store the logs. The default is `/var/log/harbor`.  `location` ：设置存储日志的目录。缺省值为 `/var/log/harbor` 。 |
|                         | `external_endpoint`     | Enable this option to forward logs to a syslog server.       启用此选项可将日志转发到 syslog 服务器。        `protocol`: Transport protocol for the syslog server. Default is TCP.  `protocol` ：syslog 服务器的传输协议。默认值为 TCP。        `host`: The URL of the syslog server.  `host` ：syslog 服务器的 URL。        `port`: The port on which the syslog server listens  `port` ：syslog 服务器监听的端口 |
| `proxy`                 |                         | Configure proxies to be used by trivy-adapter, the replication jobservice, and  Harbor. Leave blank if no proxies are required. Some proxies have  whitelist settings, if Trivy is enabled, you need to add the following  urls to the proxy server whitelist: `github.com`, `github-releases.githubusercontent.com`, and `*.s3.amazonaws.com.` 配置 trivy-adapter、复制 jobservice 和 Harbor 要使用的代理。如果不需要代理，则留空。部分代理有白名单设置，如果开启了Trivy，则需要将以下网址添加到代理服务器白名单中： `github.com` 、 `github-releases.githubusercontent.com` 、和 `*.s3.amazonaws.com.` |
|                         | `http_proxy`            | Configure an HTTP proxy, for example,  `http://my.proxy.com:3128`. 配置 HTTP 代理，例如 `http://my.proxy.com:3128` . |
|                         | `https_proxy`           | Configure an HTTPS proxy, for example,  `http://my.proxy.com:3128`. 配置HTTPS代理，例如 `http://my.proxy.com:3128` 。 |
|                         | `no_proxy`              | Configure when not to use a proxy, for example, `127.0.0.1,localhost,core,registry`. 配置何时不使用代理，例如 `127.0.0.1,localhost,core,registry` . |
| `cache`                 |                         | Configure cache layer for your Harbor instance. When enabled, Harbor will cache  some Harbor resources (for example, artifacts, projects, or project  metadata) using Redis, reducing the amount of time and resources used  for repeated requests for the same Harbor resource. It's strongly  recommended that you enable this feature on Harbor instances with high  concurrent pull request rates to improve Harbor's overall performance.  For more details on the cache layer implementation and performance  improvements, see the [Cache Layer wiki page](https://github.com/goharbor/perf/wiki/Cache-layer). 为您的 Harbor 实例配置缓存层。启用后，Harbor 将使用 Redis 缓存一些 Harbor  资源（例如工件、项目或项目元数据），从而减少重复请求同一 Harbor 资源所花费的时间和资源量。强烈建议您在并发拉取请求率较高的 Harbor 实例上启用此功能，以提高 Harbor 的整体性能。有关缓存层实现和性能改进的更多详细信息，请参阅缓存层 Wiki 页面。 |
|                         | `enabled`               | Default is `false`, set to `true` to enable Harbor's cache layer. 默认值为 `false` ，设置为 `true` 启用 Harbor 的缓存层。 |
|                         | `expire_hours`          | Configure the cache expiration limit in hours. Default is 24.  配置缓存过期限制（以小时为单位）。默认值为 24。 |

### Optional Parameters 可选参数

The following table lists the additional, optional parameters that you can  set to configure your Harbor deployment beyond the minimum required  settings. To enable a setting, you must uncomment it in `harbor.yml` by deleting the leading `#` character.
下表列出了您可以设置的其他可选参数，这些参数用于配置 Harbor 部署，超出所需的最低设置。要启用某个设置，您必须 `harbor.yml` 通过删除前导 `#` 字符来取消注释该设置。

| Parameter 参数      | Sub-Parameters 子参数  | Description and Additional Parameters  描述和其他参数        |
| ------------------- | ---------------------- | ------------------------------------------------------------ |
| `external_url`      | None 没有              | Enable this option to use an external proxy. When  enabled, the hostname is no longer used. 启用此选项可使用外部代理。启用后，将不再使用主机名。 |
|                     |                        |                                                              |
| `storage_service`   |                        | By default, Harbor stores images and charts on your local filesystem. In a production environment, you might want to use another storage backend  instead of the local filesystem. The parameters listed below are the  configurations for the registry. See *Configuring Storage Backend* below for more information about how to configure a different backend. 默认情况下，Harbor 会将图像和图表存储在您的本地文件系统上。在生产环境中，您可能希望使用另一个存储后端而不是本地文件系统。下面列出的参数是注册表的配置。有关如何配置不同后端的更多信息，请参阅下面的*配置存储后端*。 |
|                     | `ca_bundle`            | The path to the custom root CA certificate, which is injected into the  trust store of registry and chart repository containers. This is usually needed if internal storage uses a self signed certificate. 自定义根 CA 证书的路径，该证书被注入到注册表和图表存储库容器的信任存储中。如果内部存储使用自签名证书，则通常需要这样做。 |
|                     | `filesystem`           | The default is `filesystem`, but you can set `azure`, `gcs`, `s3`, `swift` and `oss`. For information about how to configure other backends, see [Configuring a Storage Backend](https://goharbor.io/docs/2.11.0/install-config/configure-yml-file/#backend) below. Set `maxthreads` to limit the number of threads to the external provider. The default is 100. 默认值为 `filesystem` ，但您可以设置 `azure` 、 `gcs` 、 `s3` `swift` 和 `oss` 。有关如何配置其他后端的信息，请参阅下面的配置存储后端。设置为 `maxthreads` 限制外部提供程序的线程数。默认值为 100。 |
|                     | `redirect`             | Set `deactivate` to `true` when you want to deactivate registry redirect 设置为 `deactivate`  `true` 当您想要停用注册表重定向时 |
| `external_database` |                        | Configure external database settings, if you deactivate the local database  option. Currently, Harbor only supports PostgreSQL database. You must  create a database for Harbor core. The tables are generated  automatically when Harbor starts up. 如果停用本地数据库选项，请配置外部数据库设置。目前，Harbor 仅支持 PostgreSQL 数据库。您必须为 Harbor 核心创建数据库。这些表是在 Harbor 启动时自动生成的。 |
|                     | `harbor`               | Configure an external database for Harbor data. 为 Harbor 数据配置外部数据库。              `host`: Hostname of the Harbor database.  `host` ：Harbor 数据库的主机名。        `port`: Database port.  `port` ：数据库端口。        `db_name`: Database name.  `db_name` ：数据库名称。        `username`: Username to connect to the core Harbor database.  `username` ：用于连接到核心 Harbor 数据库的用户名。        `password`: Password for the account you set in `username`.  `password` ：您在 中 `username` 设置的帐户的密码。        `ssl_mode`: Enable SSL mode.  `ssl_mode` ：启用 SSL 模式。        `max_idle_conns`: The maximum number of connections in the idle connection pool. If  <=0 no idle connections are retained. The default value is 2.  `max_idle_conns` ：空闲连接池中的最大连接数。如果 <=0，则不保留空闲连接。默认值为 2。        `max_open_conns`: The maximum number of open connections to the database. If <= 0  there is no limit on the number of open connections. The default value  is 0.  `max_open_conns` ：打开的数据库连接的最大数量。如果 <= 0，则对打开的连接数没有限制。默认值为 0。 |
| `external_redis`    |                        | Configure an external Redis instance. 配置外部Redis实例。    |
|                     | `host`                 | redis_host:redis_port of the external Redis instance. If you are using Sentinel mode, this  part should be  host_sentinel1:port_sentinel1,host_sentinel2:port_sentinel2 redis_host：redis_port外部Redis实例。如果您使用的是 Sentinel 模式，则此部分应为 host_sentinel1：port_sentinel1，host_sentinel2：port_sentinel2 |
|                     | `sentinel_master_set`  | Only set this when using Sentinel mode 仅在使用 Sentinel 模式时设置此项 |
|                     | `password`             | Password to connect to the external Redis instance. 连接到外部 Redis 实例的密码。 |
|                     | `registry_db_index`    | Database index for Harbor registry. Harbor 注册表的数据库索引。 |
|                     | `jobservice_db_index`  | Database index for jobservice. jobservice 的数据库索引。     |
|                     | `chartmuseum_db_index` | Database index for Chart museum. Chart 博物馆的数据库索引。  |
|                     | `trivy_db_index`       | Database index for Trivy adapter. Trivy 适配器的数据库索引。 |
| `metric`            |                        | Configure exposing Harbor instance metrics to a specified port and path 配置将 Harbor 实例指标暴露到指定端口和路径 |
|                     | `enabled`              | Enable exposing metrics on your Harbor instance by setting this to `true`. Default is `false` 通过将此项设置为 `true` ，可以在 Harbor 实例上公开指标。默认值为 `false` |
|                     | `port`                 | Port metrics are exposed on. Default is `9090` 端口指标已公开。默认值为 `9090` |
|                     | `path`                 | Path metrics are exposed on. Default is `/metrics` 路径指标已公开。默认值为 `/metrics` |
| `trace`             |                        | Configure exposing Distributed tracing data 配置公开分布式跟踪数据 |
|                     | `enabled`              | Enable exposing tracing on your Harbor instance by setting this to `true`. Default is `false` 通过将此项设置为 `true` ，在您的 Harbor 实例上启用公开跟踪。默认值为 `false` |
|                     | `sample_rate`          | Set the sample rate of tracing. For example, set sample_rate to `1` if you wanna sampling 100% of trace data; set `0.5` if you wanna sampling 50% of trace data, and so forth  设置跟踪的采样率。例如，如果要对跟踪数据进行 100% 的采样，请将 sample_rate `1` 设置为;设置 `0.5` 是否要对 50% 的跟踪数据进行采样，依此类推 |
|                     | `namespace`            | Namespace used to differenciate different harbor services, which will set to attribute with key `service.namespace` Namespace 用于区分不同的 Harbor 服务，将设置为带有 key `service.namespace` 的属性 |
|                     | `attributes`           | The attributes is a key value dict contains user defined customized  attributes used to initialize trace provider, and all of these atributes will added to trace data attributes 是一个键值 dict 包含用户定义的自定义属性，用于初始化跟踪提供程序，所有这些属性都将添加到跟踪数据中 |
|                     | `jaeger`               | `endpoint`: The url of endpoint(for example `http://127.0.0.1:14268/api/traces`). set endpoint means export to jaeger collector via http.  `endpoint` ：端点的 url（例如 `http://127.0.0.1:14268/api/traces` ）。SET ENDPOINT 表示通过 HTTP 导出到 Jaeger Collector。      `username:`: Username used to connect endpoint. Left empty if not needed.  `username:` ：用于连接端点的用户名。如果不需要，请留空。      `password:`: Password used to connect endpoint. Left empty if not needed.  `password:` ：用于连接端点的密码。如果不需要，请留空。      `agent_host`: The host name of jaeger agent. Set agent_host means export data to jaeger agent via udp.   `agent_host` ：jaeger agent 的主机名。Set agent_host 表示通过 udp 将数据导出到 jaeger agent。      `agent_port:`: The port name of jaeger agent.  `agent_port:` ：jaeger agent 的端口名称。 |
|                     | `otel`                 | `endpoint`: The hostname and port for otel compitable backend(for example `127.0.0.1:4318`).  `endpoint` ：otel 兼容后端的主机名和端口（例如 `127.0.0.1:4318` ）。      `url_path:`: The url path of endpoint(for example `127.0.0.1:4318`)   `url_path:` ：endpoint的url路径（例如 `127.0.0.1:4318` ）      `compression:`: If enabling data compression  `compression:` ：如果启用数据压缩      `insecure`: Ignore cert verification for otel backend   `insecure` ：忽略 otel 后端的证书验证      `timeout:`: The timeout of data transfer  `timeout:` ：数据传输超时 |

​                        

​                 The `harbor.yml` file includes options to configure a UAA CA certificate. This authentication mode is not recommended and is not documented.      
该文件 `harbor.yml` 包含用于配置 UAA CA 证书的选项。不建议使用此身份验证模式，并且未记录在案。

### Configuring a Storage Backend 配置存储后端

By default Harbor uses local storage for the registry, but you can optionally configure the `storage_service` setting so that Harbor uses external storage. For information about how to configure the storage backend of a registry for different storage  providers, see the  [Distribution Configuration Reference](https://distribution.github.io/distribution/about/configuration/) in the Distribution Registry (previously Docker Registry)  documentation. For example, if you use Openstack Swift as your storage  backend, the parameters might resemble the following:
默认情况下，Harbor 使用本地存储来存储注册表，但您可以选择配置该 `storage_service` 设置，以便 Harbor 使用外部存储。有关如何为不同的存储提供商配置注册表的存储后端的信息，请参阅 Distribution  Registry（以前称为 Docker Registry）文档中的 Distribution Configuration  Reference。例如，如果您使用 Openstack Swift 作为存储后端，则参数可能类似于以下内容：

```yaml
storage_service:
  ca_bundle:
  swift:
    username: admin
    password: ADMIN_PASS
    authurl: http://keystone_addr:35357/v3/auth
    tenant: admin
    domain: default
    region: regionOne
    container: docker_images
  redirect:
    disabled: false
```

### 运行安装程序脚本

Once you have configured `harbor.yml` copied from `harbor.yml.tmpl` and optionally set up a storage backend, you install and start Harbor by using the `install.sh` script. Note that it might take some time for the online installer to download all of the Harbor images from Docker hub.
配置、 `harbor.yml` 复制 `harbor.yml.tmpl` 并选择性地设置存储后端后，您可以使用脚本 `install.sh` 安装并启动 Harbor。请注意，联机安装程序可能需要一些时间才能从 Docker 中心下载所有 Harbor 映像。

You can install Harbor in different configurations:
你可以用不同的配置安装 Harbor：

- Just Harbor, without Trivy
  只是港口，没有琐事
- Harbor with Trivy 港口与Trivy

### Default installation without Trivy 不带 Trivy 的默认安装

The default Harbor installation does not include Trivy service. Run the following command
默认的 Harbor 安装不包括 Trivy 服务。运行以下命令

```sh
sudo ./install.sh
```

If the installation succeeds, you can open a browser to visit the Harbor interface at `http://reg.yourdomain.com`, changing `reg.yourdomain.com` to the hostname that you configured in `harbor.yml`. If you did not change them in `harbor.yml`, the default administrator username and password are `admin` and `Harbor12345`.
如果安装成功，您可以打开浏览器以访问 Harbor 界面，将其 `http://reg.yourdomain.com` 更改为 `reg.yourdomain.com` 您在 中 `harbor.yml` 配置的主机名。如果未在 中 `harbor.yml` 更改它们，则默认的管理员用户名和密码为 `admin` 和 `Harbor12345` 。

Log in to the admin portal and create a new project, for example, `myproject`. You can then use Docker commands to log in to Harbor, tag images, and push them to Harbor.
登录到管理员门户并创建一个新项目，例如 `myproject` .然后，您可以使用 Docker 命令登录 Harbor，标记镜像，并将它们推送到 Harbor。

```sh
docker login reg.yourdomain.com
docker push reg.yourdomain.com/myproject/myrepo:mytag
```

​                        

- If your installation of Harbor uses HTTPS, you must provide the Harbor certificates to the Docker client. For information, see [Configure HTTPS Access to Harbor](https://goharbor.io/docs/2.11.0/install-config/run-installer-script/configure-https.md#provide-the-certificates-to-harbor-and-docker).
  如果您的 Harbor 安装使用 HTTPS，则必须向 Docker 客户端提供 Harbor 证书。有关信息，请参阅配置对 Harbor 的 HTTPS 访问。
- If your installation of Harbor uses HTTP, you must add the option `--insecure-registry` to your client’s Docker daemon and restart the Docker service. For more information, see [Connecting to Harbor via HTTP](https://goharbor.io/docs/2.11.0/install-config/run-installer-script/#connect-http) below.
  如果您的 Harbor 安装使用 HTTP，则必须将该选项 `--insecure-registry` 添加到客户端的 Docker 守护进程中，并重新启动 Docker 服务。有关更多信息，请参阅下面的通过 HTTP 连接到 Harbor。

### Installation with Trivy 使用 Trivy 安装

To install Harbor with Trivy service, add the `--with-trivy` parameter when you run `install.sh`:
要使用 Trivy 服务安装 Harbor，请在运行时 `install.sh` 添加参数 `--with-trivy` ：

```sh
sudo ./install.sh --with-trivy
```

For more information about Trivy, see the  [Trivy documentation](https://github.com/aquasecurity/trivy). For more information about how to use Trivy in an webproxy environment see  [Configure custom Certification Authorities for trivy](https://goharbor.io/docs/2.11.0/install-config/run-installer-script/administration/vulnerability-scanning/configure-custom-certs.md)
有关 Trivy 的更多信息，请参阅 Trivy 文档。有关如何在 webproxy 环境中使用 Trivy 的更多信息，请参阅为 trivy 配置自定义证书颁发机构

### Connecting to Harbor via HTTP 通过 HTTP 连接到 Harbor

**IMPORTANT:** If your installation of Harbor uses HTTP rather than HTTPS, you must add the option `--insecure-registry` to your client’s Docker daemon. By default, the daemon file is located at `/etc/docker/daemon.json`.
重要提示：如果您的 Harbor 安装使用 HTTP 而不是 HTTPS，则必须将该选项 `--insecure-registry` 添加到客户端的 Docker 守护进程中。默认情况下，守护程序文件位于 `/etc/docker/daemon.json` 。

For example, add the following to your `daemon.json` file:
例如，将以下内容添加到您的 `daemon.json` 文件中：

```
{
"insecure-registries" : ["myregistrydomain.com:5000", "0.0.0.0"]
}
```

After you update `daemon.json`, you must restart both Docker Engine and Harbor.
更新 `daemon.json` 后，必须重新启动 Docker Engine 和 Harbor。

1. Restart Docker Engine. 重启 Docker Engine。

   ```sh
   systemctl restart docker
   ```

2. Stop Harbor. 停下港口。

   ```sh
   docker-compose down -v
   ```

3. Restart Harbor. 重启 Harbor。

   ```sh
   docker-compose up -d
   ```

### 通过 Helm 部署具有高可用性的 Harbor

You can deploy Harbor on Kubernetes via helm to make it highly available.  In this way, if one of the nodes on which Harbor is running becomes  unavailable, users do not experience interruptions of service.
您可以通过 helm 在 Kubernetes 上部署 Harbor，使其具有高可用性。这样，如果运行 Harbor 的其中一个节点不可用，用户就不会遇到服务中断。

#### Prerequisites 先决条件

- Kubernetes cluster 1.10+
  Kubernetes 集群 1.10+
- Helm 2.8.0+ 头盔 2.8.0+
- High available ingress controller (Harbor does not manage the external endpoint)
  高可用性入口控制器（Harbor 不管理外部端点）
- High available PostgreSQL (Harbor does not handle the deployment of HA of database)
  高可用性 PostgreSQL（Harbor 不处理数据库 HA 的部署）
- High available Redis (Harbor does not handle the deployment of HA of Redis)
  高可用 Redis（Harbor 不处理 Redis 的 HA 部署）
- PVC that can be shared across nodes or external object storage
  可以在节点或外部对象存储之间共享的 PVC

#### Architecture 建筑

Most of Harbor’s components are stateless now. So we can simply increase the replica of the pods to make sure the components are distributed to  multiple worker nodes, and leverage the “Service” mechanism of K8S to  ensure the connectivity across pods.
Harbor 的大多数组件现在都是无状态的。因此，我们可以简单地增加 Pod 的副本，以确保组件分布到多个工作节点，并利用 K8S 的“服务”机制来保证 Pod 之间的连通性。

As for storage layer, it is expected that the user provide high available  PostgreSQL, Redis cluster for application data and PVCs or object  storage for storing images and charts.
至于存储层，期望用户提供高可用性的PostgreSQL、Redis集群用于应用程序数据和PVC或对象存储，用于存储图像和图表。



​    ![Harbor High Availability with Helm](https://goharbor.io/docs/2.11.0/img/ha.png)  

#### Download Chart 下载图表

Download Harbor helm chart:
下载Harbor helm chart：

```bash
helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar
```

#### Configuration 配置

Configure the followings items in `values.yaml`, you can also set them as parameters via `--set` flag during running `helm install`:
在其中 `values.yaml` 配置以下项目，您也可以在运行时 `helm install` 通过 `--set` flag 将它们设置为参数：

- **Ingress rule** Configure the `expose.ingress.hosts.core`.
  Ingress 规则配置 `expose.ingress.hosts.core` .

- **External URL** Configure the `externalURL`.
  外部 URL 配置 `externalURL` .

- **External PostgreSQL** Set the `database.type` to `external` and fill the information in `database.external` section.
  外部 PostgreSQL 将 `database.type` 设置为 `external` 并填写 in `database.external` 部分中的信息。

  An empty databases should be created manually for `Harbor core` and configured in the section. Harbor will create tables automatically when starting up.
  应手动创建空数据库， `Harbor core` 并在该部分中进行配置。Harbor 将在启动时自动创建表。

- **External Redis** Set the `redis.type` to `external` and fill the information in `redis.external` section.
  外部 Redis 将 `redis.type` 设置为 `external` 并填写 in `redis.external` 部分中的信息。

  Harbor introduced redis `Sentinel` mode support in 2.1.0. You can enable this by setting `sentinel_master_set` and `host` to `<host_sentinel1>:<port_sentinel1>,<host_sentinel2>:<port_sentinel2>,<host_sentinel3>:<port_sentinel3>`.
  Harbor 在 2.1.0 中引入了 redis `Sentinel` 模式支持。您可以通过将 `sentinel_master_set` 和 `host` 设置为 `<host_sentinel1>:<port_sentinel1>,<host_sentinel2>:<port_sentinel2>,<host_sentinel3>:<port_sentinel3>` 来启用此功能。

  You can also refer to this  [guide](https://community.pivotal.io/s/article/How-to-setup-HAProxy-and-Redis-Sentinel-for-automatic-failover-between-Redis-Master-and-Slave-servers) to setup a HAProxy before the Redis to expose a single entry point.
  您还可以参考本指南，在 Redis 之前设置 HAProxy 以公开单个入口点。

- **Storage** By default, a default `StorageClass` is needed in the K8S cluster to provision volumes to store images, charts and job logs.
  存储 默认情况下，K8S 集群中需要默认 `StorageClass` 配置卷来存储图像、图表和作业日志。

  If you want to specify the `StorageClass`, set `persistence.persistentVolumeClaim.registry.storageClass`, `persistence.persistentVolumeClaim.chartmuseum.storageClass` and `persistence.persistentVolumeClaim.jobservice.storageClass`.
  如果要指定 `StorageClass` 、设置 `persistence.persistentVolumeClaim.registry.storageClass` 和 `persistence.persistentVolumeClaim.chartmuseum.storageClass` `persistence.persistentVolumeClaim.jobservice.storageClass` 。

  If you use `StorageClass`, for both default or specified one, set `persistence.persistentVolumeClaim.registry.accessMode`, `persistence.persistentVolumeClaim.chartmuseum.accessMode` and `persistence.persistentVolumeClaim.jobservice.accessMode` as `ReadWriteMany`, and make sure that the persistent volumes must can be shared cross different nodes.
  如果对默认卷或指定卷都使用 `StorageClass` ，请设置 `persistence.persistentVolumeClaim.registry.accessMode` 、 `persistence.persistentVolumeClaim.chartmuseum.accessMode` 和 `persistence.persistentVolumeClaim.jobservice.accessMode` as `ReadWriteMany` ，并确保持久性卷必须可以在不同节点之间共享。

  You can also use the existing PVCs to store data, set `persistence.persistentVolumeClaim.registry.existingClaim`, `persistence.persistentVolumeClaim.chartmuseum.existingClaim` and `persistence.persistentVolumeClaim.jobservice.existingClaim`.
  您还可以使用现有的 PVC 来存储数据、set `persistence.persistentVolumeClaim.registry.existingClaim` 和 `persistence.persistentVolumeClaim.chartmuseum.existingClaim` `persistence.persistentVolumeClaim.jobservice.existingClaim` 。

  If you have no PVCs that can be shared across nodes, you can use external  object storage to store images and charts and store the job logs in  database. Set the `persistence.imageChartStorage.type` to the value you want to use and fill the corresponding section and set `jobservice.jobLogger` to `database`.
  如果没有可以跨节点共享的PVC，则可以使用外部对象存储来存储图像和图表，并将作业日志存储在数据库中。将 设置为 `persistence.imageChartStorage.type` 您要使用的值并填充相应的部分，然后设置为 `jobservice.jobLogger` `database` 。

- **Replica** Set `portal.replicas`, `core.replicas`, `jobservice.replicas`, `registry.replicas`, `chartmuseum.replicas`, to `n`(`n`>=2).
  副本集 `portal.replicas` 、 `core.replicas` 、 `jobservice.replicas` 、 `registry.replicas` 为 `chartmuseum.replicas` `n` （ `n` >=2）。

#### Installation 安装

Install the Harbor helm chart with a release name `my-release`:
使用版本名称 `my-release` 安装 Harbor helm chart：

Helm 2: 舵手 2：

```bash
helm install --name my-release harbor/
```

Helm 3: 头盔 3：

```bash
helm install my-release harbor/
```

### 疑难解答

## Access Harbor Logs 访问 Harbor 日志

By default, registry data is persisted in the host’s `/data/` directory. This data remains unchanged even when Harbor’s containers are removed and/or recreated, you can edit the `data_volume` in `harbor.yml` file to change this directory.
默认情况下，注册表数据保留在主机 `/data/` 的目录中。即使删除和/或重新创建 Harbor 的容器，此数据也不会更改，您可以编辑 `data_volume` in `harbor.yml` 文件以更改此目录。

In addition, Harbor uses `rsyslog` to collect the logs of each container. By default, these log files are stored in the directory `/var/log/harbor/` on the target host for troubleshooting, also you can change the log directory in `harbor.yml`.
此外，Harbor 还用于 `rsyslog` 收集每个集装箱的日志。默认情况下，这些日志文件存储在目标主机上的目录中 `/var/log/harbor/` 以进行故障排除，您也可以在 中 `harbor.yml` 更改日志目录。

## Harbor Does Not Start or Functions Incorrectly Harbor 无法启动或功能不正确

If Harbor does not start or functions incorrectly, run the following  command to check whether all of Harbor’s containers are in the `Up` state.
如果 Harbor 无法启动或运行不正常，请执行以下命令检查 Harbor 的所有容器是否都处于该 `Up` 状态。

```fallback
sudo docker-compose ps
        Name                     Command               State                    Ports
  -----------------------------------------------------------------------------------------------------------------------------
  harbor-core         /harbor/start.sh                 Up
  harbor-db           /entrypoint.sh postgres          Up      5432/tcp
  harbor-jobservice   /harbor/start.sh                 Up
  harbor-log          /bin/sh -c /usr/local/bin/ ...   Up      127.0.0.1:1514->10514/tcp
  harbor-portal       nginx -g daemon off;             Up      80/tcp
  nginx               nginx -g daemon off;             Up      0.0.0.0:443->443/tcp, 0.0.0.0:4443->4443/tcp, 0.0.0.0:80->80/tcp
  redis               docker-entrypoint.sh redis ...   Up      6379/tcp
  registry            /entrypoint.sh /etc/regist ...   Up      5000/tcp
  registryctl         /harbor/start.sh                 Up
```

If a container is not in the `Up` state, check the log file for that container in `/var/log/harbor`. For example, if the `harbor-core` container is not running, look at the `core.log` log file.
如果容器未处于该 `Up` 状态，请检查 `/var/log/harbor` 中该容器的日志文件。例如，如果 `harbor-core` 容器未运行，请查看 `core.log` 日志文件。

## Using `nginx` or Load Balancing 使用 `nginx` 或负载均衡

If Harbor is running behind an `nginx` proxy or elastic load balancing, open the file `common/config/nginx/nginx.conf` and search for the following line.
如果 Harbor 在 `nginx` 代理或弹性负载均衡后面运行，请打开文件 `common/config/nginx/nginx.conf` 并搜索以下行。

```fallback
proxy_set_header X-Forwarded-Proto $scheme;
```

If the proxy already has similar settings, remove it from the sections `location /`, `location /v2/` and `location /service/` and redeploy Harbor. For instructions about how to redeploy Harbor, see  [Reconfigure Harbor and Manage the Harbor Lifecycle](https://goharbor.io/docs/2.11.0/install-config/reconfigure-manage-lifecycle/).
如果代理已经有类似的设置，请将其从各个部分 `location /` 中删除， `location /v2/` 然后 `location /service/` 重新部署 Harbor。有关如何重新部署 Harbor 的说明，请参阅重新配置 Harbor 和管理 Harbor 生命周期。

## Troubleshoot HTTPS Connections 排查 HTTPS 连接问题

If you use an intermediate certificate from a certificate issuer, merge  the intermediate certificate with your own certificate to create a  certificate bundle. Run the following command.
如果您使用证书颁发者提供的中间证书，请将中间证书与您自己的证书合并以创建证书捆绑包。运行以下命令。

```fallback
cat intermediate-certificate.pem >> yourdomain.com.crt
```

When the Docker daemon runs on certain operating systems, you might need to  trust the certificate at the OS level. For example, run the following  commands.
当 Docker 守护程序在某些操作系统上运行时，您可能需要在操作系统级别信任证书。例如，运行以下命令。

- Ubuntu: 乌班图：

  ```sh
  cp yourdomain.com.crt /usr/local/share/ca-certificates/yourdomain.com.crt 
  update-ca-certificates
  ```

- Red Hat (CentOS etc):
  Red Hat（CentOS等）：

  ```sh
  cp yourdomain.com.crt /etc/pki/ca-trust/source/anchors/yourdomain.com.crt
  update-ca-trust
  ```

## 配置

### 重新配置 Harbor 并管理 Harbor 生命周期

You use `docker-compose` to manage the lifecycle of Harbor. This topic provides some useful  commands. You must run the commands in the directory in which `docker-compose.yml` is located.
 `docker-compose` 用于管理 Harbor 的生命周期。本主题提供了一些有用的命令。您必须在所在的 `docker-compose.yml` 目录中运行命令。

See the  [Docker Compose command-line reference](https://docs.docker.com/compose/reference/) for more information about `docker-compose`.
有关的更多信息 `docker-compose` ，请参阅 Docker Compose 命令行参考。

### 停止 Harbor

To stop Harbor, run the following command.
要停止 Harbor，请运行以下命令。

```sh
sudo docker-compose stop
Stopping nginx              ... done
Stopping harbor-portal      ... done
Stopping harbor-jobservice  ... done
Stopping harbor-core        ... done
Stopping registry           ... done
Stopping redis              ... done
Stopping registryctl        ... done
Stopping harbor-db          ... done
Stopping harbor-log         ... done
```

## Restart Harbor 重启 Harbor

To restart Harbor, run the following command.
要重新启动 Harbor，请运行以下命令。

```sh
sudo docker-compose start
Starting log         ... done
Starting registry    ... done
Starting registryctl ... done
Starting postgresql  ... done
Starting core        ... done
Starting portal      ... done
Starting redis       ... done
Starting jobservice  ... done
Starting proxy       ... done
```

## Reconfigure Harbor 重新配置 Harbor

To reconfigure Harbor, perform the following steps.
要重新配置 Harbor，请执行以下步骤。

1. Stop Harbor. 停下港口。

   ```sh
   sudo docker-compose down -v
   ```

2. Update `harbor.yml`. 更新 `harbor.yml` .

   ```sh
   vim harbor.yml
   ```

3. Run the `prepare` script to populate the configuration.
   运行脚本 `prepare` 以填充配置。

   ```sh
   sudo ./prepare
   ```

   To reconfigure Harbor to install Trivy, include the component in the `prepare` command.
   要重新配置 Harbor 以安装 Trivy，请在命令中 `prepare` 包含该组件。

   ```sh
   sudo ./prepare --with-trivy
   ```

4. Re-create and start the Harbor instance.
   重新创建并启动 Harbor 实例。

   ```sh
   sudo docker-compose up -d
   ```

## Other Commands 其他命令

Remove Harbor’s containers but keep all of the image data and Harbor’s database files in the file system:
删除 Harbor 的容器，但将所有图像数据和 Harbor 的数据库文件保留在文件系统中：

```sh
sudo docker-compose down -v
```

Remove the Harbor database and image data before performing a clean re-installation:
在执行完全重新安装之前，请删除 Harbor 数据库和映像数据：

```sh
rm -r /data/database
rm -r /data/registry
rm -r /data/redis
```

### 自定义 Harbor 令牌服务

By default, Harbor uses its own private key and certificate to  authenticate with Docker clients. This topic describes how to optionally customize your configuration to use your own key and certificate.
默认情况下，Harbor 使用自己的私钥和证书向 Docker 客户端进行身份验证。本主题介绍如何选择性地自定义配置以使用您自己的密钥和证书。

Harbor requires the Docker client to access the Harbor registry with a token. The procedure to generate a token is like  [Distribution Registry v2 authentication](https://github.com/distribution/distribution/blob/main/docs/content/spec/auth/token.md). Firstly, you make a request to the token service for a token. The token is signed by the private key. After that, you make a new request with  the token to the Harbor registry, Harbor registry verifies the token  with the public key in the root cert bundle. Then Harbor registry  authorizes the Docker client to push and pull images.
Harbor 要求 Docker 客户端使用令牌访问 Harbor 注册表。生成令牌的过程类似于 Distribution Registry v2  身份验证。首先，向令牌服务发出令牌请求。令牌由私钥签名。之后，您使用令牌向 Harbor 注册表发出新请求，Harbor  注册表使用根证书包中的公钥验证令牌。然后 Harbor 注册表授权 Docker 客户端推送和拉取镜像。

- If you do not already have a certificate, follow the instructions in  [Generate a Root Certificate](https://goharbor.io/docs/2.11.0/install-config/customize-token-service/#gen-cert) to generate a root certificate by using openSSL.
  如果您还没有证书，请按照生成根证书中的说明使用 openSSL 生成根证书。
- If you already have a certificate, go to  [Provide the Certificate to Harbor](https://goharbor.io/docs/2.11.0/install-config/customize-token-service/#provide-cert).
  如果您已有证书，请转到向 Harbor 提供证书。

## Generate a Root Certificate 生成根证书

1. Generate a private key.
   生成私钥。

   ```sh
   openssl genrsa -out private_key.pem 4096
   ```

2. Generate a certificate. 生成证书。

   ```sh
   openssl req -new -x509 -key private_key.pem -out root.crt -days 3650
   ```

3. Enter information to include in your certificate request.
   输入要包含在证书请求中的信息。

   What you are about to enter is what is called a Distinguished Name or a DN.  There are quite a few fields but you can leave some of them blank. For  some fields there is a default value. If you enter `.`, the field is left blank.
   您将要输入的是所谓的可分辨名称或 DN。有很多字段，但您可以将其中一些留空。对于某些字段，有一个默认值。如果输入 `.` ，则该字段将留空。

   - Country Name (2 letter code) [AU]:
     国家名称（2 个字母代码）[AU]：
   - State or Province Name (full name) [Some-State]:
     省/市/自治区/直辖市/自治区名称（全名）[Some-State]：
   - Locality Name (eg, city) []:
     地点名称（例如，城市）[]：
   - Organization Name (eg, company) [Internet Widgits Pty Ltd]:
     组织名称（例如，公司）[Internet Widgits Pty Ltd]：
   - Organizational Unit Name (eg, section) []:
     组织单位名称（例如，部分）[]：
   - Common Name (eg,  server FQDN or YOUR name) []:
     常用名（例如，服务器 FQDN 或您的姓名）[]：
   - Email Address []: 电子邮件地址 []：

   After you run these commands, the files `private_key.pem` and `root.crt` are created in the current directory.
   运行这些命令后，将在当前目录中创建文件 `private_key.pem` 和 `root.crt` 。

## Provide the Certificate to Harbor 向港口提供证书

See  [Run the Installer Script](https://goharbor.io/docs/2.11.0/install-config/run-installer-script/) or  [Reconfigure Harbor and Manage the Harbor Lifecycle](https://goharbor.io/docs/2.11.0/install-config/reconfigure-manage-lifecycle/) to install or reconfigure Harbor. After you run `./install` or `./prepare`, Harbor generates several configuration files. You need to replace the  original private key and certificate with your own key and certificate.
请参阅运行安装程序脚本或重新配置 Harbor 和管理 Harbor 生命周期以安装或重新配置 Harbor。运行 `./install` or `./prepare` 后，Harbor 会生成多个配置文件。您需要用自己的密钥和证书替换原始私钥和证书。

1. Replace the default key and certificate.
   替换默认密钥和证书。

   Assuming that the new key and certificate are in `/root/cert`, and `/srv/harbor/data` was specified as `data_volume` run the following commands:
   假设新密钥和证书位于 `/root/cert` 中，并且 `/srv/harbor/data` 被指定为 `data_volume` ，请运行以下命令：

   ```sh
   cd config/ui
   cp /root/cert/private_key.pem /srv/harbor/data/secret/core/private_key.pem
   cp /root/cert/root.crt /srv/harbor/data/secret/registry/root.crt
   ```

2. Go back to the `make` directory, and start Harbor by using following command:
   返回到目录 `make` ，并使用以下命令启动 Harbor：

   ```sh
   docker-compose up -d
   ```

3. Push and pull images to and from Harbor to check that your own certificate works.
   将图像推送到Harbor以及从Harbor推送和拉取图像，以检查您自己的证书是否正常工作。

### Harbor 配置

Some Harbor configuration is configured separately from the  [Configure the Harbor YML File](https://goharbor.io/docs/2.11.0/install-config/configure-yml-file/) section. You can change the configuration in the Harbor interface,  through HTTP requests, or using an environment variable. This page  describes the available configuration items, and how to use the  commandline or environment variable to update the configuration.
某些 Harbor 配置与配置 Harbor YML 文件部分分开配置。您可以在 Harbor 接口中、通过 HTTP 请求或使用环境变量来更改配置。本页介绍可用的配置项，以及如何使用命令行或环境变量更新配置。

## Example Configuration Commands for the Commandline 命令行的示例配置命令

**Get the current configuration:
获取当前配置：**

```sh
curl -u "<username>:<password>" -H "Content-Type: application/json" -ki <Harbor Server URL>/api/v2.0/configurations
```

**Update the current configuration:
更新当前配置：**

```sh
curl -X PUT -u "<username>:<password>" -H "Content-Type: application/json" -ki <Harbor Server URL>/api/v2.0/configurations -d'{"<item_name>":"<item_value>"}'
```

**Update Harbor to use LDAP authentication:
更新 Harbor 以使用 LDAP 身份验证：**

Command 命令

```shell
curl -X PUT -u "<username>:<password>" -H "Content-Type: application/json" -ki https://harbor.sample.domain/api/v2.0/configurations -d'{"auth_mode":"ldap_auth"}'
```

Output 输出

```fallback
HTTP/1.1 200 OK
Server: nginx
Date: Wed, 08 May 2019 08:22:02 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 0
Connection: keep-alive
Set-Cookie: sid=a5803a1265e2b095cf65ce1d8bbd79b1; Path=/; HttpOnly
```

**Restrict project creation to Harbor administrators:
将项目创建限制为 Harbor 管理员：**

Command 命令

```shell
curl -X PUT -u "<username>:<password>" -H "Content-Type: application/json" -ki https://harbor.sample.domain/api/v2.0/configurations -d'{"project_creation_restriction":"adminonly"}'
```

Output 输出

```fallback
HTTP/1.1 200 OK
Server: nginx
Date: Wed, 08 May 2019 08:24:32 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 0
Connection: keep-alive
Set-Cookie: sid=b7925eaf7af53bdefb13bdcae201a14a; Path=/; HttpOnly
```

**Update the token expiration time:
更新令牌过期时间：**

Command 命令

```shell
curl -X PUT -u "<username>:<password>" -H "Content-Type: application/json" -ki https://harbor.sample.domain/api/v2.0/configurations -d'{"token_expiration":"300"}'
```

Output 输出

```fallback
HTTP/1.1 200 OK
Server: nginx
Date: Wed, 08 May 2019 08:23:38 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 0
Connection: keep-alive
Set-Cookie: sid=cc1bc93ffa2675253fc62b4bf3d9de0e; Path=/; HttpOnly
```

## Set Configuration Items Using An Environment Variable 使用环境变量设置配置项

Introduced in 2.3.0 is the ability to use an environment variable, `CONFIG_OVERWRITE_JSON`, in the core container to set the configuration. Once the `CONFIG_OVERWRITE_JSON` variable is set, you can only update or remove the configuration by updating the `CONFIG_OVERWRITE_JSON` and restarting the container. You will not be able to update the configuration in the Harbor interface or in the commandline.
在 2.3.0 中引入的是能够在核心容器中使用环境变量 来 `CONFIG_OVERWRITE_JSON` 设置配置。设置变量 `CONFIG_OVERWRITE_JSON` 后，您只能通过更新 `CONFIG_OVERWRITE_JSON` 和重新启动容器来更新或删除配置。您将无法在 Harbor 界面或命令行中更新配置。

**Example CONFIG_OVERWRITE_JSON configuration:
CONFIG_OVERWRITE_JSON配置示例：**

```fallback
CONFIG_OVERWRITE_JSON={"ldap_verify_cert":"false", "auth_mode":"ldap_auth","ldap_base_dn":"dc=example,dc=com", "ldap_search_dn":"cn=admin,dc=example,dc=com","ldap_search_password":"admin","ldap_url":"myldap.example.com", "ldap_scope":2}
```

See the  [Harbor Configuration Items](https://goharbor.io/docs/2.11.0/install-config/configure-system-settings-cli/#harbor-configuration-items) table below for more information about available inputs for `CONFIG_OVERWRITE_JSON`.
有关 的可用输入的更多信息，请参阅下面的 Harbor 配置项表 `CONFIG_OVERWRITE_JSON` 。

​                        

​                 If there is a legacy user in your instance of Harbor, the  authentication mode can’t be changed by the environment variable `CONFIG_OVERWRITE_JSON`.      
如果您的 Harbor 实例中存在旧用户，则环境变量 `CONFIG_OVERWRITE_JSON` 无法更改身份验证模式。

## Harbor Configuration Items Harbor 配置项

| Configure item name 配置项目名称 | Description 描述                                             | Type 类型     | Required 必填                                                | Default Value 默认值         |
| -------------------------------- | ------------------------------------------------------------ | ------------- | ------------------------------------------------------------ | ---------------------------- |
| auth_mode                        | Authentication mode, it can be db_auth, ldap_auth, uaa_auth or oidc_auth 认证方式，可以是db_auth、ldap_auth、uaa_auth或oidc_auth | string 字符串 |                                                              |                              |
| primary_auth_mode                | Set Identity Provider to be the primary auth method 将“身份提供商”设置为主要身份验证方法 | boolean 布尔  | optional 自选                                                | false 假                     |
| ldap_url                         | LDAP URL LDAP 网址                                           | string 字符串 | required 必填                                                |                              |
| ldap_base_dn                     | LDAP base DN LDAP 基本 DN                                    | string 字符串 | required(ldap_auth) 必需（ldap_auth）                        |                              |
| ldap_filter                      | LDAP filter LDAP 过滤器                                      | string 字符串 | optional 自选                                                |                              |
| ldap_scope                       | LDAP search scope, 0-Base Level, 1- One Level, 2-Sub Tree LDAP 搜索范围，0-基本级别，1-1 级别，2-子树 | number 数     | optional 自选                                                | 2-Sub Tree 2-子树            |
| ldap_search_dn                   | LDAP DN to search LDAP users 用于搜索 LDAP 用户的 LDAP DN    | string 字符串 | required(ldap_auth) 必需（ldap_auth）                        |                              |
| ldap_search_password             | LDAP DN’s password LDAP DN 的密码                            | string 字符串 | required(ldap_auth) 必需（ldap_auth）                        |                              |
| ldap_timeout                     | LDAP connection timeout LDAP 连接超时                        | number 数     | optional 自选                                                | 5                            |
| ldap_uid                         | LDAP attribute to indicate the username in Harbor LDAP 属性，用于指示 Harbor 中的用户名 | string 字符串 | optional 自选                                                | cn 快递 之 家                |
| ldap_verify_cert                 | Verify cert when create SSL connection with LDAP server, true or false 使用LDAP服务器创建SSL连接时验证证书，是真是假 | boolean 布尔  | optional 自选                                                | true 真                      |
| ldap_group_admin_dn              | LDAP Group Admin DN LDAP 组管理员 DN                         | string 字符串 | optional 自选                                                |                              |
| ldap_group_attribute_name        | LDAP Group Attribute, the LDAP attribute indicate the groupname in Harbor, it can be gid or cn LDAP组属性，LDAP属性表示Harbor中的组名，可以是gid或cn | string 字符串 | optional 自选                                                | cn 快递 之 家                |
| ldap_group_base_dn               | The Base DN which to search the LDAP groups 要搜索 LDAP 组的基本 DN | string 字符串 | required(ldap_auth and LDAP group) 必需（ldap_auth 和 LDAP 组） |                              |
| ldap_group_search_filter         | The filter to search LDAP groups 用于搜索 LDAP 组的过滤器    | string 字符串 | optional 自选                                                |                              |
| ldap_group_search_scope          | LDAP group search scope, 0-Base Level, 1- One Level, 2-Sub Tree LDAP 组搜索范围，0-基本级别，1-1 级别，2-子树 | number 数     | optional 自选                                                | 2-Sub Tree 2-子树            |
| ldap_group_membership_attribute  | LDAP group membership attribute, to indicate the group membership, it can be memberof, or ismemberof LDAP 组成员身份属性，用于指示组成员身份，它可以是 memberof 或 ismemberof | string 字符串 | optional 自选                                                | memberof 成员                |
| project_creation_restriction     | The option to indicate user can be create object, it can be everyone, adminonly 指示用户的选项可以是创建对象，也可以是所有人，adminonly | string 字符串 | optional 自选                                                | everyone 每个人 都           |
| read_only                        | The option to set repository read only, it can be true or false 设置存储库只读的选项，可以是 true 或 false | boolean 布尔  | optional 自选                                                | false 假                     |
| self_registration                | User can register account in Harbor, it can be true or false 用户可以在Harbor中注册账户，可以是真的，也可以是假的 | boolean 布尔  | optional 自选                                                | true 真                      |
| token_expiration                 | Security token expirtation time in minutes 安全令牌过期时间（以分钟为单位） | number 数     | optional 自选                                                | 30                           |
| uaa_client_id                    | UAA client ID UAA 客户端 ID                                  | string 字符串 | required(uaa_auth) 必需（uaa_auth）                          |                              |
| uaa_client_secret                | UAA certificate UAA证书                                      | string 字符串 | required(uaa_auth) 必需（uaa_auth）                          |                              |
| uaa_endpoint                     | UAA endpoint UAA 端点                                        | string 字符串 | required(uaa_auth) 必需（uaa_auth）                          |                              |
| uaa_verify_cert                  | UAA verify cert, true or false UAA 验证证书，真假            | boolean 布尔  | optional 自选                                                | true 真                      |
| oidc_name                        | Name for OIDC authentication OIDC 身份验证的名称             | string 字符串 | required(oidc_auth) 必需（oidc_auth）                        |                              |
| oidc_endpoint                    | Endpoint for OIDC auth OIDC 身份验证的终端节点               | string 字符串 | required(oidc_auth) 必需（oidc_auth）                        |                              |
| oidc_extra_redirect_parms        | Extra parameters to add when redirect request to OIDC provider 将请求重定向到 OIDC 提供商时要添加的额外参数 | string 字符串 | optional 自选                                                | {}                           |
| oidc_client_id                   | Client id for OIDC auth 用于 OIDC 身份验证的客户端 ID        | string 字符串 | required(oidc_auth) 必需（oidc_auth）                        |                              |
| oidc_client_secret               | Client secret for OIDC auth 用于 OIDC 身份验证的客户端密钥   | string 字符串 | required(oidc_auth) 必需（oidc_auth）                        |                              |
| oidc_groups_claim                | The name of a custom group claim that you have configured in your OIDC provider, that includes the groups to add to Harbor 您在 OIDC 提供商中配置的自定义组声明的名称，其中包括要添加到 Harbor 的组 | string 字符串 | optional 自选                                                |                              |
| oidc_admin_group                 | The name of the admin group, if the ID token of the user shows that he is a member of this group, the user will have admin privilege in Harbor.  Note: You can only set one Admin Group. 管理员组的名称，如果用户的 ID 令牌显示他是该组的成员，则该用户将在 Harbor 中拥有管理员权限。注意：您只能设置一个管理员组。 | string 字符串 | optional 自选                                                |                              |
| oidc_scope                       | Scope for OIDC auth OIDC 身份验证的范围                      | string 字符串 | required(oidc_auth) 必需（oidc_auth）                        |                              |
| oidc_verify_cert                 | Verify certificate for OIDC auth, true or false 验证证书的 OIDC 身份验证，是真是假 | boolean 布尔  | optional 自选                                                | true 真                      |
| oidc_auto_onboard                | Skip the onboarding screen, so user cannot change its username. Username is provided from ID Token, true or false 跳过载入屏幕，因此用户无法更改其用户名。用户名由 ID 令牌提供，true 或 false | boolean 布尔  | optional 自选                                                | false 假                     |
| oidc_user_claim                  | The name of the claim in the ID Token where the username is retrieved from 从中检索用户名的 ID 令牌中的声明名称 | string 字符串 | optional 自选                                                | name 名字                    |
| robot_token_duration             | Robot token expiration time in minutes 机器人令牌过期时间（以分钟为单位） | number 数     | optional 自选                                                | 43200 (30days) 43200（30天） |
| robot_name_prefix                | Prefixed string for each robot account name 每个机器人帐户名称的前缀字符串 | string 字符串 | optional 自选                                                | robot$ 机器人$               |
| audit_log_forward_endpoint       | Forward audit logs to the syslog endpoint, for example: harbor-log:10514 将审计日志转发到 syslog 端点，例如：harbor-log：10514 | string 字符串 | optional 自选                                                |                              |
| skip_audit_log_database          | Skip to log audit log in the database, only available when audit log forward endpoint is configured 跳到数据库中记录审计日志，仅在配置了审计日志转发端点时可用 | boolean 布尔  | optional 自选                                                | false 假                     |
| scanner_skip_update_pulltime     | Vulnerability scanner(e.g. Trivy) will not update the image “last pull time” when the image is scanned 漏洞扫描器（例如Trivy）在扫描图像时不会更新图像的“上次拉取时间” | boolean 布尔  | optional 自选                                                |                              |
| banner_message                   | The banner message for the UI. It is the stringified result of the banner message object UI 的横幅消息。它是横幅消息对象的字符串化结果 | string 字符串 | optional 自选                                                |                              |

​                        

​                 Both booleans and numbers can be enclosed with double quote in the request json, for example: `123`, `"123"`, `"true"` or `true` is OK.      
布尔值和数字都可以在请求 json 中用双引号括起来，例如： `123` 、 `"123"` 、 `"true"` 或 `true` is OK。

## 升级

