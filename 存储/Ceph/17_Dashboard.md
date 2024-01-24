# Ceph Dashboard

[TOC]

## 概述

Ceph Dashboard 是一个内置的基于 Web 的 Ceph 管理和监控应用程序，可以通过它检查和管理集群，以及视觉化与其相关的信息和性能统计信息。它被实现为 Ceph Manager Daemon 模块。

Ceph Luminous 附带的原始 Ceph Dashboard 最初是一个简单的只读视图，可以查看 Ceph 集群的运行时信息和性能数据。它使用了一个非常简单的架构来实现最初的目标。然而，人们对更丰富的基于 Web 的管理功能的需求越来越大，以便喜欢 WebUI 而不是 CLI 的用户更容易地管理 Ceph 。

新的 Ceph Dashboard 模块为 Ceph Manager 添加了基于 Web 的监控和管理功能。这个新模块的架构和功能源自 openATTIC Ceph 管理和监控工具。开发工作由 SUSE 的 openATTIC 团队积极推动，并得到了包括 Red Hat 在内的公司和 Ceph 社区成员的支持。

Dashboard 模块的后端代码使用 CherryPy 框架并实现了自定义 REST API 。WebUI 实现基于 Angular / TypeScript ，包括原始 Dashboard 的功能和最初为 openATTIC 独立版本开发的新功能。Ceph Dashboard 模块作为一个应用程序实现，通过 `ceph-mgr` 托管的 Web 服务器提供信息和统计数据的图形表示。

## 功能

Dashboard 提供以下功能：

- **多用户和角色管理** ：Dashboard 支持多个具有不同权限（角色）的用户帐户。用户帐户和角色可以通过命令行和 WebUI 进行管理。Dashboard 支持多种方法来增强密码安全性。可以配置密码复杂性规则，要求用户在第一次登录后或在可配置的时间段后更改其密码。
- **单点登录(SSO)** ：Dashboard 支持使用 SAML 2.0 协议通过外部身份提供者进行身份验证。 
- **SSL / TLS 支持** ：Web 浏览器与 Dashboard 之间的所有 HTTP 通信均通过 SSL 保护。可以使用内置命令创建自签名证书，但也可以导入由 CA 签名和颁发的自定义证书。
- **审计** ：Dashboard 后端可以配置为在 Ceph 审计日志中记录所有 `PUT` 、 `POST` 和 `DELETE` API 请求。
- **国际化 (I18N)**：可以在运行时选择 Dashboard 文本使用的语言。

Ceph Dashboard 提供以下监控和管理功能：

- **集群整体健康状况** ：显示性能和容量指标以及群集状态。
- **嵌入式 Grafana Dashboard** ：Ceph Dashboard Grafana 仪表板可能嵌入到外部应用程序和网页中，以提供有关 Prometheus 模块收集的信息和性能指标。
- **集群日志** ：显示群集的事件和审核日志文件的最新更新。日志条目可以按优先级、日期或关键字过滤。
- **Hosts**: 显示所有群集主机及其存储驱动器的列表，其中正在运行的服务以及安装的 Ceph 版本。
- **性能计数器**: Display detailed service-specific statistics for each running service.显示每个正在运行的服务的详细服务特定统计信息。
- **Monitors**: List all Mons, their quorum status, and open sessions.列出所有Mons、其法定人数状态和打开的会话。
- **监测**: Enable creation, re-creation, editing, and expiration of Prometheus’ silences, list the alerting configuration and all configured and firing alerts. Show notifications for firing alerts.启用Prometheus静默的创建、重新创建、编辑和到期，列出警报配置以及所有已配置和正在触发的警报。显示触发警报的通知。

- **配置编辑器**: 显示所有可用的配置选项，它们的描述，类型，默认值和当前设置的值。这些也可以编辑。
- **池**: 列出 Ceph 池及其详细信息（例如，应用程序、pg 自动缩放、放置组、复制大小、EC 配置文件、CRUSH 规则、配额等）
- **OSD**: List OSDs, their status and usage statistics as well as detailed information like attributes (OSD map), metadata, performance counters and usage histograms for read/write operations. Mark OSDs up/down/out, purge and reweight OSDs, perform scrub operations, modify various scrub-related configuration options, select profiles to adjust the level of backfilling activity.列出 OSD、其状态和使用统计信息以及详细信息，如属性（OSD映射）、元数据、性能计数器和读/写操作的使用直方图。将OSD标记为向上/向下/向外，清除OSD并重新调整其重量，执行清理操作，修改各种与清理相关的配置选项，选择配置文件以调整清理活动的级别。列出与 OSD 关联的所有驱动器。设置和更改 OSD 的设备类别，按设备类别显示和排序 OSD 。在新驱动器和主机上部署 OSD 。
- **驱动器管理**: 列出 orchestrator 已知的所有主机。列出连接到主机的所有驱动器及其属性。Display drive health predictions and SMART data. 显示驱动器运行状况预测和 SMART 数据。Blink enclosure LEDs.外壳指示灯闪烁。
- **iSCSI**: 列出运行 TCMU runner 服务的所有主机，显示所有镜像及其性能特征（读/写操作、流量）。创建、修改和删除 iSCSI target（通过 `ceph-iscsi` ）。显示 iSCSI 网关状态和有关活动 initiator 的信息。
- **RBD**: 列出所有 RBD image 及其属性（大小，对象，功能）。创建、复制、修改和删除 RBD image（包括快照）和管理 RBD 命名空间。在全局、每个池或每个 image 级别上定义各种 I/O 或带宽限制设置。创建、删除和回滚所选 image 的快照，保护/取消保护这些快照以防修改。复制或克隆快照，flatten cloned images展平克隆的映像。
- **RBD 镜像**: 启用和配置 RBD 镜像到远程 Ceph 服务器。列出活动的守护进程及其状态、池和 RBD image ，包括同步进度。
- **CephFS**: 列出活动文件系统客户端和关联池，包括使用统计信息。Evict active CephFS clients驱逐活动CephFS客户端。管理 CephFS 配额和快照。浏览 CephFS 目录结构。
- **对象网关**: 列出所有活动的对象网关及其性能计数器。显示和管理（添加/编辑/删除）对象网关用户及其详细信息（例如配额）以及用户的 bucket 及其详细信息（例如放置目标、所有者、配额、版本控制、多因素身份验证）。有关配置说明，请参见启用对象网关管理前端。
- **NFS**: 通过 NFS Ganesha 管理 CephFS 文件系统和 RGW S3 存储桶的 NFS 导出。
- **Ceph Manager Modules**: 启用和禁用 Ceph Manager 模块，管理模块特定的配置设置。

### Overview of the Dashboard Landing Page[](https://docs.ceph.com/en/latest/mgr/dashboard/#overview-of-the-dashboard-landing-page)

Displays overall cluster status, performance, and capacity metrics. Shows instant feedback for changes in the cluster and provides easy access to subpages of the dashboard.



#### Status[](https://docs.ceph.com/en/latest/mgr/dashboard/#status)

- **Cluster Status**: Displays overall cluster health. In case of any error it displays a short description of the error and provides a link to the logs.
- **Hosts**: Displays the total number of hosts associated to the cluster and links to a subpage that lists and describes each.
- **Monitors**: Displays mons and their quorum status and open sessions.  Links to a subpage that lists and describes each.
- **OSDs**: Displays object storage daemons (ceph-osds) and the numbers of OSDs running (up), in service (in), and out of the cluster (out). Provides links to subpages providing a list of all OSDs and related management actions.
- **Managers**: Displays active and standby Ceph Manager daemons (ceph-mgr).
- **Object Gateway**: Displays active object gateways (RGWs) and provides links to subpages that list all object gateway daemons.
- **Metadata Servers**: Displays active and standby CephFS metadata service daemons (ceph-mds).
- **iSCSI Gateways**: Display iSCSI gateways available, active (up), and inactive (down). Provides a link to a subpage showing a list of all iSCSI Gateways.



#### Capacity[](https://docs.ceph.com/en/latest/mgr/dashboard/#capacity)

- **Raw Capacity**: Displays the capacity used out of the total physical capacity provided by storage nodes (OSDs).
- **Objects**: Displays the number and status of RADOS objects including the percentages of healthy, misplaced, degraded, and unfound objects.
- **PG Status**: Displays the total number of placement groups and their status, including the percentage clean, working, warning, and unknown.
- **Pools**: Displays pools and links to a subpage listing details.
- **PGs per OSD**: Displays the number of placement groups assigned to object storage daemons.



#### Performance[](https://docs.ceph.com/en/latest/mgr/dashboard/#performance)

- **Client READ/Write**: Displays an overview of client input and output operations.
- **Client Throughput**: Displays the data transfer rates to and from Ceph clients.
- **Recovery throughput**: Displays rate of cluster healing and balancing operations.
- **Scrubbing**: Displays light and deep scrub status.

### Supported Browsers[](https://docs.ceph.com/en/latest/mgr/dashboard/#supported-browsers)

Ceph Dashboard is primarily tested and developed using the following web browsers:

| Browser                                                      | Versions                |
| ------------------------------------------------------------ | ----------------------- |
| [Chrome](https://www.google.com/chrome/) and [Chromium](https://www.chromium.org/) based browsers | latest 2 major versions |
| [Firefox](https://www.mozilla.org/firefox/)                  | latest 2 major versions |
| [Firefox ESR](https://www.mozilla.org/firefox/enterprise/)   | latest major version    |

While Ceph Dashboard might work in older browsers, we cannot guarantee compatibility and recommend keeping your browser up to date.

## Enabling[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling)

If you have installed `ceph-mgr-dashboard` from distribution packages, the package management system should take care of installing all required dependencies.

If you’re building Ceph from source and want to start the dashboard from your development environment, please see the files `README.rst` and `HACKING.rst` in the source directory `src/pybind/mgr/dashboard`.

Within a running Ceph cluster, the Ceph Dashboard is enabled with:

```
ceph mgr module enable dashboard
```

## Configuration[](https://docs.ceph.com/en/latest/mgr/dashboard/#configuration)



### SSL/TLS Support[](https://docs.ceph.com/en/latest/mgr/dashboard/#ssl-tls-support)

All HTTP connections to the dashboard are secured with SSL/TLS by default.

To get the dashboard up and running quickly, you can generate and install a self-signed certificate:

```
ceph dashboard create-self-signed-cert
```

Note that most web browsers will complain about self-signed certificates and require explicit confirmation before establishing a secure connection to the dashboard.

To properly secure a deployment and to remove the warning, a certificate that is issued by a certificate authority (CA) should be used.

For example, a key pair can be generated with a command similar to:

```
openssl req -new -nodes -x509 \
-subj "/O=IT/CN=ceph-mgr-dashboard" -days 3650 \
-keyout dashboard.key -out dashboard.crt -extensions v3_ca
```

The `dashboard.crt` file should then be signed by a CA. Once that is done, you can enable it for Ceph manager instances by running the following commands:

```
ceph dashboard set-ssl-certificate -i dashboard.crt
ceph dashboard set-ssl-certificate-key -i dashboard.key
```

If unique certificates are desired for each manager instance, the name of the instance can be included as follows (where `$name` is the name of the `ceph-mgr` instance, usually the hostname):

```
ceph dashboard set-ssl-certificate $name -i dashboard.crt
ceph dashboard set-ssl-certificate-key $name -i dashboard.key
```

SSL can also be disabled by setting this configuration value:

```
ceph config set mgr mgr/dashboard/ssl false
```

This might be useful if the dashboard will be running behind a proxy which does not support SSL for its upstream servers or other situations where SSL is not wanted or required. See [Proxy Configuration](https://docs.ceph.com/en/latest/mgr/dashboard/#dashboard-proxy-configuration) for more details.

Warning

Use caution when disabling SSL as usernames and passwords will be sent to the dashboard unencrypted.

Note

You must restart Ceph manager processes after changing the SSL certificate and key. This can be accomplished by either running `ceph mgr fail mgr` or by disabling and re-enabling the dashboard module (which also triggers the manager to respawn itself):

```
ceph mgr module disable dashboard
ceph mgr module enable dashboard
```



### Host Name and Port[](https://docs.ceph.com/en/latest/mgr/dashboard/#host-name-and-port)

Like most web applications, the dashboard binds to a TCP/IP address and TCP port.

By default, the `ceph-mgr` daemon hosting the dashboard (i.e., the currently active manager) will bind to TCP port 8443 or 8080 when SSL is disabled.

If no specific address has been configured, the web app will bind to `::`, which corresponds to all available IPv4 and IPv6 addresses.

These defaults can be changed via the configuration key facility on a cluster-wide level (so they apply to all manager instances) as follows:

```
ceph config set mgr mgr/dashboard/server_addr $IP
ceph config set mgr mgr/dashboard/server_port $PORT
ceph config set mgr mgr/dashboard/ssl_server_port $PORT
```

Since each `ceph-mgr` hosts its own instance of the dashboard, it may be necessary to configure them separately. The IP address and port for a specific manager instance can be changed with the following commands:

```
ceph config set mgr mgr/dashboard/$name/server_addr $IP
ceph config set mgr mgr/dashboard/$name/server_port $PORT
ceph config set mgr mgr/dashboard/$name/ssl_server_port $PORT
```

Replace `$name` with the ID of the ceph-mgr instance hosting the dashboard.

Note

The command `ceph mgr services` will show you all endpoints that are currently configured. Look for the `dashboard` key to obtain the URL for accessing the dashboard.

### Username and Password[](https://docs.ceph.com/en/latest/mgr/dashboard/#username-and-password)

In order to be able to log in, you need to create a user account and associate it with at least one role. We provide a set of predefined *system roles* that you can use. For more details please refer to the [User and Role Management](https://docs.ceph.com/en/latest/mgr/dashboard/#user-and-role-management) section.

To create a user with the administrator role you can use the following commands:

```
ceph dashboard ac-user-create <username> -i <file-containing-password> administrator
```

### Account Lock-out[](https://docs.ceph.com/en/latest/mgr/dashboard/#account-lock-out)

It disables a user account if a user repeatedly enters the wrong credentials for multiple times. It is enabled by default to prevent brute-force or dictionary attacks. The user can get or set the default number of lock-out attempts using these commands respectively:

```
ceph dashboard get-account-lockout-attempts
ceph dashboard set-account-lockout-attempts <value:int>
```

Warning

This feature can be disabled by setting the default number of lock-out attempts to 0. However, by disabling this feature, the account is more vulnerable to brute-force or dictionary based attacks. This can be disabled by:

```
ceph dashboard set-account-lockout-attempts 0
```

### Enable a Locked User[](https://docs.ceph.com/en/latest/mgr/dashboard/#enable-a-locked-user)

If a user account is disabled as a result of multiple invalid login attempts, then it needs to be manually enabled by the administrator. This can be done by the following command:

```
ceph dashboard ac-user-enable <username>
```

### Accessing the Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#accessing-the-dashboard)

You can now access the dashboard using your (JavaScript-enabled) web browser, by pointing it to any of the host names or IP addresses and the selected TCP port where a manager instance is running: e.g., `http(s)://<$IP>:<$PORT>/`.

The dashboard page displays and requests a previously defined username and password.



### Enabling the Object Gateway Management Frontend[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling-the-object-gateway-management-frontend)

When RGW is deployed with cephadm, the RGW credentials used by the dashboard will be automatically configured. You can also manually force the credentials to be set up with:

```
ceph dashboard set-rgw-credentials
```

This will create an RGW user with uid `dashboard` for each realm in the system.

If you’ve configured a custom ‘admin’ resource in your RGW admin API, you should set it here also:

```
ceph dashboard set-rgw-api-admin-resource <admin_resource>
```

If you are using a self-signed certificate in your Object Gateway setup, you should disable certificate verification in the dashboard to avoid refused connections, e.g. caused by certificates signed by unknown CA or not matching the host name:

```
ceph dashboard set-rgw-api-ssl-verify False
```

If the Object Gateway takes too long to process requests and the dashboard runs into timeouts, you can set the timeout value to your needs:

```
ceph dashboard set-rest-requests-timeout <seconds>
```

The default value is 45 seconds.



### Enabling iSCSI Management[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling-iscsi-management)

The Ceph Dashboard can manage iSCSI targets using the REST API provided by the `rbd-target-api` service of the [Ceph iSCSI Gateway](https://docs.ceph.com/en/latest/rbd/iscsi-overview/#ceph-iscsi). Please make sure that it is installed and enabled on the iSCSI gateways.

Note

The iSCSI management functionality of Ceph Dashboard depends on the latest version 3 of the [ceph-iscsi](https://github.com/ceph/ceph-iscsi) project. Make sure that your operating system provides the correct version, otherwise the dashboard will not enable the management features.

If the `ceph-iscsi` REST API is configured in HTTPS mode and its using a self-signed certificate, you need to configure the dashboard to avoid SSL certificate verification when accessing ceph-iscsi API.

To disable API SSL verification run the following command:

```
ceph dashboard set-iscsi-api-ssl-verification false
```

The available iSCSI gateways must be defined using the following commands:

```
ceph dashboard iscsi-gateway-list
# Gateway URL format for a new gateway: <scheme>://<username>:<password>@<host>[:port]
ceph dashboard iscsi-gateway-add -i <file-containing-gateway-url> [<gateway_name>]
ceph dashboard iscsi-gateway-rm <gateway_name>
```



### Enabling the Embedding of Grafana Dashboards[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling-the-embedding-of-grafana-dashboards)

[Grafana](https://grafana.com/) pulls data from [Prometheus](https://prometheus.io/). Although Grafana can use other data sources, the Grafana dashboards we provide contain queries that are specific to Prometheus. Our Grafana dashboards therefore require Prometheus as the data source. The Ceph [Prometheus Module](https://docs.ceph.com/en/latest/mgr/prometheus/#mgr-prometheus) module exports its data in the Prometheus exposition format. These Grafana dashboards rely on metric names from the Prometheus module and [Node exporter](https://prometheus.io/docs/guides/node-exporter/). The Node exporter is a separate application that provides machine metrics.

Note

Prometheus’ security model presumes that untrusted users have access to the Prometheus HTTP endpoint and logs. Untrusted users have access to all the (meta)data Prometheus collects that is contained in the database, plus a variety of operational and debugging information.

However, Prometheus’ HTTP API is limited to read-only operations. Configurations can *not* be changed using the API and secrets are not exposed. Moreover, Prometheus has some built-in measures to mitigate the impact of denial of service attacks.

Please see Prometheus’ Security model <https://prometheus.io/docs/operating/security/> for more detailed information.

#### Installation and Configuration using cephadm[](https://docs.ceph.com/en/latest/mgr/dashboard/#installation-and-configuration-using-cephadm)

Grafana and Prometheus can be installed using [Cephadm](https://docs.ceph.com/en/latest/cephadm/#cephadm). They will automatically be configured by `cephadm`. Please see [Monitoring Services](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#mgr-cephadm-monitoring) documentation for more details on how to use `cephadm` for installing and configuring Prometheus and Grafana.

#### Manual Installation and Configuration[](https://docs.ceph.com/en/latest/mgr/dashboard/#manual-installation-and-configuration)

The following process describes how to configure Grafana and Prometheus manually. After you have installed Prometheus, Grafana, and the Node exporter on appropriate hosts, proceed with the following steps.

1. Enable the Ceph Exporter which comes as Ceph Manager module by running:

   ```
   ceph mgr module enable prometheus
   ```

   More details can be found in the documentation of the [Prometheus Module](https://docs.ceph.com/en/latest/mgr/prometheus/#mgr-prometheus).

2. Add the corresponding scrape configuration to Prometheus. This may look like:

   ```
   global:
     scrape_interval: 5s
   
   scrape_configs:
     - job_name: 'prometheus'
       static_configs:
         - targets: ['localhost:9090']
     - job_name: 'ceph'
       static_configs:
         - targets: ['localhost:9283']
     - job_name: 'node-exporter'
       static_configs:
         - targets: ['localhost:9100']
   ```

   Note

   Please note that in the above example, Prometheus is configured to scrape data from itself (port 9090), the Ceph manager module prometheus (port 9283), which exports Ceph internal data, and the Node Exporter (port 9100), which provides OS and hardware metrics for each host.

   Depending on your configuration, you may need to change the hostname in or add additional configuration entries for the Node Exporter. It is unlikely that you will need to change the default TCP ports.

   Moreover, you don’t *need* to have more than one target for Ceph specific data, provided by the prometheus mgr module. But it is recommended to configure Prometheus to scrape Ceph specific data from all existing Ceph managers. This enables a built-in high availability mechanism, so that services run on a manager host will be restarted automatically on a different manager host if one Ceph Manager goes down.

3. Add Prometheus as data source to Grafana [using the Grafana Web UI](https://grafana.com/docs/grafana/latest/features/datasources/add-a-data-source/).

   Important

   The data source must be named “Dashboard1”.

4. Install the vonage-status-panel and grafana-piechart-panel plugins using:

   ```
   grafana-cli plugins install vonage-status-panel
   grafana-cli plugins install grafana-piechart-panel
   ```

5. Add Dashboards to Grafana:

   Dashboards can be added to Grafana by importing dashboard JSON files. Use the following command to download the JSON files:

   ```
   wget https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/<Dashboard-name>.json
   ```

   You can find various dashboard JSON files [here](https://github.com/ceph/ceph/tree/main/monitoring/ceph-mixin/dashboards_out).

   For Example, for ceph-cluster overview you can use:

   ```
   wget https://raw.githubusercontent.com/ceph/ceph/main/monitoring/ceph-mixin/dashboards_out/ceph-cluster.json
   ```

   You may also author your own dashboards.

6. Configure anonymous mode in `/etc/grafana/grafana.ini`:

   ```
   [auth.anonymous]
   enabled = true
   org_name = Main Org.
   org_role = Viewer
   ```

   In newer versions of Grafana (starting with 6.2.0-beta1) a new setting named `allow_embedding` has been introduced. This setting must be explicitly set to `true` for the Grafana integration in Ceph Dashboard to work, as the default is `false`.

   ```
   [security]
   allow_embedding = true
   ```

#### Enabling RBD-Image monitoring[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling-rbd-image-monitoring)

Monitoring of RBD images is disabled by default, as it can significantly impact performance. For more information please see [Ceph Health Checks](https://docs.ceph.com/en/latest/mgr/prometheus/#prometheus-rbd-io-statistics). When disabled, the overview and details dashboards will be empty in Grafana and metrics will not be visible in Prometheus.

#### Configuring Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#configuring-dashboard)

After you have set up Grafana and Prometheus, you will need to configure the connection information that the Ceph Dashboard will use to access Grafana.

You need to tell the dashboard on which URL the Grafana instance is running/deployed:

```
ceph dashboard set-grafana-api-url <grafana-server-url>  # default: ''
```

The format of url is : <protocol>:<IP-address>:<port>

Note

The Ceph Dashboard embeds Grafana dashboards via `iframe` HTML elements. If Grafana is configured without SSL/TLS support, most browsers will block the embedding of insecure content if SSL support is enabled for the dashboard (which is the default). If you can’t see the embedded Grafana dashboards after enabling them as outlined above, check your browser’s documentation on how to unblock mixed content. Alternatively, consider enabling SSL/TLS support in Grafana.

If you are using a self-signed certificate for Grafana, disable certificate verification in the dashboard to avoid refused connections, which can be a result of certificates signed by an unknown CA or that do not match the host name:

```
ceph dashboard set-grafana-api-ssl-verify False
```

You can also access Grafana directly to monitor your cluster.

Note

Ceph Dashboard configuration information can also be unset. For example, to clear the Grafana API URL we configured above:

```
ceph dashboard reset-grafana-api-url
```

#### Alternative URL for Browsers[](https://docs.ceph.com/en/latest/mgr/dashboard/#alternative-url-for-browsers)

The Ceph Dashboard backend requires the Grafana URL to be able to verify the existence of Grafana Dashboards before the frontend even loads them. Due to the nature of how Grafana is implemented in Ceph Dashboard, this means that two working connections are required in order to be able to see Grafana graphs in Ceph Dashboard:

- The backend (Ceph Mgr module) needs to verify the existence of the requested graph. If this request succeeds, it lets the frontend know that it can safely access Grafana.
- The frontend then requests the Grafana graphs directly from the user’s browser using an iframe. The Grafana instance is accessed directly without any detour through Ceph Dashboard.

Now, it might be the case that your environment makes it difficult for the user’s browser to directly access the URL configured in Ceph Dashboard. To solve this issue, a separate URL can be configured which will solely be used to tell the frontend (the user’s browser) which URL it should use to access Grafana. This setting won’t ever be changed automatically, unlike the GRAFANA_API_URL which is set by [Cephadm](https://docs.ceph.com/en/latest/cephadm/#cephadm) (only if cephadm is used to deploy monitoring services).

To change the URL that is returned to the frontend issue the following command:

```
ceph dashboard set-grafana-frontend-api-url <grafana-server-url>
```

If no value is set for that option, it will simply fall back to the value of the GRAFANA_API_URL option. If set, it will instruct the browser to use this URL to access Grafana.



### Enabling Single Sign-On (SSO)[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling-single-sign-on-sso)

The Ceph Dashboard supports external authentication of users via the [SAML 2.0](https://en.wikipedia.org/wiki/SAML_2.0) protocol. You need to first create user accounts and associate them with desired roles, as authorization is performed by the Dashboard. However, the authentication process can be performed by an existing Identity Provider (IdP).

Note

Ceph Dashboard SSO support relies on onelogin’s [python-saml](https://pypi.org/project/python-saml/) library. Please ensure that this library is installed on your system, either by using your distribution’s package management or via Python’s pip installer.

To configure SSO on Ceph Dashboard, you should use the following command:

```
ceph dashboard sso setup saml2 <ceph_dashboard_base_url> <idp_metadata> {<idp_username_attribute>} {<idp_entity_id>} {<sp_x_509_cert>} {<sp_private_key>}
```

Parameters:

- **<ceph_dashboard_base_url>**: Base URL where Ceph Dashboard is accessible (e.g., https://cephdashboard.local)
- **<idp_metadata>**: URL to remote (http://, https://) or local (file://) path or content of the IdP metadata XML (e.g., https://myidp/metadata, file:///home/myuser/metadata.xml).
- **<idp_username_attribute>** *(optional)*: Attribute that should be used to get the username from the authentication response. Defaults to uid.
- **<idp_entity_id>** *(optional)*: Use this when more than one entity id exists on the IdP metadata.
- **<sp_x_509_cert> / <sp_private_key>** *(optional)*: File path of the certificate that should be used by Ceph Dashboard  (Service Provider) for signing and encryption (these file paths should  be accessible from the active ceph-mgr instance).

Note

The issuer value of SAML requests will follow this pattern:  **<ceph_dashboard_base_url>**/auth/saml2/metadata

To display the current SAML 2.0 configuration, use the following command:

```
ceph dashboard sso show saml2
```

Note

For more information about onelogin_settings, please check the [onelogin documentation](https://github.com/onelogin/python-saml).

To disable SSO:

```
ceph dashboard sso disable
```

To check if SSO is enabled:

```
ceph dashboard sso status
```

To enable SSO:

```
ceph dashboard sso enable saml2
```



### Enabling Prometheus Alerting[](https://docs.ceph.com/en/latest/mgr/dashboard/#enabling-prometheus-alerting)

To use Prometheus for alerting you must define [alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules). These are managed by the [Alertmanager](https://prometheus.io/docs/alerting/alertmanager). If you are not yet using the Alertmanager, [install it](https://github.com/prometheus/alertmanager#install) as it receives and manages alerts from Prometheus.

Alertmanager capabilities can be consumed by the dashboard in three different ways:

1. Use the notification receiver of the dashboard.
2. Use the Prometheus Alertmanager API.
3. Use both sources simultaneously.

All three methods notify you about alerts. You won’t be notified twice if you use both sources, but you need to consume at least the Alertmanager API in order to manage silences.

1. Use the notification receiver of the dashboard

> This allows you to get notifications as [configured](https://prometheus.io/docs/alerting/configuration/) from the Alertmanager. You will get notified inside the dashboard once a notification is send out, but you are not able to manage alerts.
>
> Add the dashboard receiver and the new route to your Alertmanager configuration. This should look like:
>
> ```
> route:
>   receiver: 'ceph-dashboard'
> ...
> receivers:
>   - name: 'ceph-dashboard'
>     webhook_configs:
>     - url: '<url-to-dashboard>/api/prometheus_receiver'
> ```
>
> Ensure that the Alertmanager considers your SSL certificate in terms of the dashboard as valid. For more information about the correct configuration checkout the [ documentation](https://prometheus.io/docs/alerting/configuration/#).

1. Use the API of Prometheus and the Alertmanager

> This allows you to manage alerts and silences and will enable the “Active Alerts”, “All Alerts” as well as the “Silences” tabs in the “Monitoring” section of the “Cluster” menu entry.
>
> Alerts can be sorted by name, job, severity, state and start time. Unfortunately it’s not possible to know when an alert was sent out through a notification by the Alertmanager based on your configuration, that’s why the dashboard will notify the user on any visible change to an alert and will notify the changed alert.
>
> Silences can be sorted by id, creator, status, start, updated and end time. Silences can be created in various ways, it’s also possible to expire them.
>
> 1. Create from scratch
> 2. Based on a selected alert
> 3. Recreate from expired silence
> 4. Update a silence (which will recreate and expire it (default Alertmanager behaviour))
>
> To use it, specify the host and port of the Alertmanager server:
>
> ```
> ceph dashboard set-alertmanager-api-host <alertmanager-host:port>  # default: ''
> ```
>
> For example:
>
> ```
> ceph dashboard set-alertmanager-api-host 'http://localhost:9093'
> ```
>
> To be able to see all configured alerts, you will need to configure the URL to the Prometheus API. Using this API, the UI will also help you in verifying that a new silence will match a corresponding alert.
>
> ```
> ceph dashboard set-prometheus-api-host <prometheus-host:port>  # default: ''
> ```
>
> For example:
>
> ```
> ceph dashboard set-prometheus-api-host 'http://localhost:9090'
> ```
>
> After setting up the hosts, refresh your browser’s dashboard window or tab.

1. Use both methods

> The behaviors of both methods are configured in a way that they should not disturb each other, through annoying duplicated notifications may pop up.

If you are using a self-signed certificate in your Prometheus or your Alertmanager setup, you should disable certificate verification in the dashboard to avoid refused connections caused by certificates signed by an unknown CA or that do not match the host name.

- For Prometheus:

```
ceph dashboard set-prometheus-api-ssl-verify False
```

- For Alertmanager:

```
ceph dashboard set-alertmanager-api-ssl-verify False
```



## User and Role Management[](https://docs.ceph.com/en/latest/mgr/dashboard/#user-and-role-management)

### Password Policy[](https://docs.ceph.com/en/latest/mgr/dashboard/#password-policy)

By default the password policy feature is enabled, which includes the following checks:

- Is the password longer than N characters?
- Are the old and new password the same?

The password policy feature can be switched on or off completely:

```
ceph dashboard set-pwd-policy-enabled <true|false>
```

The following individual checks can also be switched on or off:

```
ceph dashboard set-pwd-policy-check-length-enabled <true|false>
ceph dashboard set-pwd-policy-check-oldpwd-enabled <true|false>
ceph dashboard set-pwd-policy-check-username-enabled <true|false>
ceph dashboard set-pwd-policy-check-exclusion-list-enabled <true|false>
ceph dashboard set-pwd-policy-check-complexity-enabled <true|false>
ceph dashboard set-pwd-policy-check-sequential-chars-enabled <true|false>
ceph dashboard set-pwd-policy-check-repetitive-chars-enabled <true|false>
```

Additionally the following options are available to configure password policy.

- Minimum password length (defaults to 8):

```
ceph dashboard set-pwd-policy-min-length <N>
```

- Minimum password complexity (defaults to 10):

  ```
  ceph dashboard set-pwd-policy-min-complexity <N>
  ```

  Password complexity is calculated by classifying each character in the password. The complexity count starts by 0. A character is rated by the following rules in the given order.

  - Increase by 1 if the character is a digit.
  - Increase by 1 if the character is a lower case ASCII character.
  - Increase by 2 if the character is an upper case ASCII character.
  - Increase by 3 if the character is a special character like `!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~`.
  - Increase by 5 if the character has not been classified by one of the previous rules.

- A list of comma separated words that are not allowed to be used in a password:

  ```
  ceph dashboard set-pwd-policy-exclusion-list <word>[,...]
  ```

### User Accounts[](https://docs.ceph.com/en/latest/mgr/dashboard/#user-accounts)

The Ceph Dashboard supports multiple user accounts. Each user account consists of a username, a password (stored in encrypted form using `bcrypt`), an optional name, and an optional email address.

If a new user is created via the Web UI, it is possible to set an option that the user must assign a new password when they log in for the first time.

User accounts are stored in the monitors’ configuration database, and are available to all `ceph-mgr` instances.

We provide a set of CLI commands to manage user accounts:

- *Show User(s)*:

  ```
  ceph dashboard ac-user-show [<username>]
  ```

- *Create User*:

  ```
  ceph dashboard ac-user-create [--enabled] [--force-password] [--pwd_update_required] <username> -i <file-containing-password> [<rolename>] [<name>] [<email>] [<pwd_expiration_date>]
  ```

  To bypass password policy checks use the force-password option. Add the option pwd_update_required so that a newly created user has to change their password after the first login.

- *Delete User*:

  ```
  ceph dashboard ac-user-delete <username>
  ```

- *Change Password*:

  ```
  ceph dashboard ac-user-set-password [--force-password] <username> -i <file-containing-password>
  ```

- *Change Password Hash*:

  ```
  ceph dashboard ac-user-set-password-hash <username> -i <file-containing-password-hash>
  ```

  The hash must be a bcrypt hash and salt, e.g. `$2b$12$Pt3Vq/rDt2y9glTPSV.VFegiLkQeIpddtkhoFetNApYmIJOY8gau2`. This can be used to import users from an external database.

- *Modify User (name, and email)*:

  ```
  ceph dashboard ac-user-set-info <username> <name> <email>
  ```

- *Disable User*:

  ```
  ceph dashboard ac-user-disable <username>
  ```

- *Enable User*:

  ```
  ceph dashboard ac-user-enable <username>
  ```

### User Roles and Permissions[](https://docs.ceph.com/en/latest/mgr/dashboard/#user-roles-and-permissions)

User accounts are associated with a set of roles that define which dashboard functionality can be accessed.

The Dashboard functionality/modules are grouped within a *security scope*. Security scopes are predefined and static. The current available security scopes are:

- **hosts**: includes all features related to the `Hosts` menu entry.
- **config-opt**: includes all features related to management of Ceph configuration options.
- **pool**: includes all features related to pool management.
- **osd**: includes all features related to OSD management.
- **monitor**: includes all features related to monitor management.
- **rbd-image**: includes all features related to RBD image management.
- **rbd-mirroring**: includes all features related to RBD mirroring management.
- **iscsi**: includes all features related to iSCSI management.
- **rgw**: includes all features related to RADOS Gateway (RGW) management.
- **cephfs**: includes all features related to CephFS management.
- **nfs-ganesha**: includes all features related to NFS Ganesha management.
- **manager**: include all features related to Ceph Manager management.
- **log**: include all features related to Ceph logs management.
- **grafana**: include all features related to Grafana proxy.
- **prometheus**: include all features related to Prometheus alert management.
- **dashboard-settings**: allows to change dashboard settings.

A *role* specifies a set of mappings between a *security scope* and a set of *permissions*. There are four types of permissions:

- **read**
- **create**
- **update**
- **delete**

See below for an example of a role specification, in the form of a Python dictionary:

```
# example of a role
{
  'role': 'my_new_role',
  'description': 'My new role',
  'scopes_permissions': {
    'pool': ['read', 'create'],
    'rbd-image': ['read', 'create', 'update', 'delete']
  }
}
```

The above role dictates that a user has *read* and *create* permissions for features related to pool management, and has full permissions for features related to RBD image management.

The Dashboard provides a set of predefined roles that we call *system roles*, which can be used right away by a fresh Ceph Dashboard installation.

The list of system roles are:

- **administrator**: allows full permissions for all security scopes.
- **read-only**: allows *read* permission for all security scopes except dashboard settings.
- **block-manager**: allows full permissions for *rbd-image*, *rbd-mirroring*, and *iscsi* scopes.
- **rgw-manager**: allows full permissions for the *rgw* scope
- **cluster-manager**: allows full permissions for the *hosts*, *osd*, *monitor*, *manager*, and *config-opt* scopes.
- **pool-manager**: allows full permissions for the *pool* scope.
- **cephfs-manager**: allows full permissions for the *cephfs* scope.

The list of available roles can be retrieved with the following command:

```
ceph dashboard ac-role-show [<rolename>]
```

You can also use the CLI to create new roles. The available commands are the following:

- *Create Role*:

  ```
  ceph dashboard ac-role-create <rolename> [<description>]
  ```

- *Delete Role*:

  ```
  ceph dashboard ac-role-delete <rolename>
  ```

- *Add Scope Permissions to Role*:

  ```
  ceph dashboard ac-role-add-scope-perms <rolename> <scopename> <permission> [<permission>...]
  ```

- *Delete Scope Permission from Role*:

  ```
  ceph dashboard ac-role-del-scope-perms <rolename> <scopename>
  ```

To assign roles to users, the following commands are available:

- *Set User Roles*:

  ```
  ceph dashboard ac-user-set-roles <username> <rolename> [<rolename>...]
  ```

- *Add Roles To User*:

  ```
  ceph dashboard ac-user-add-roles <username> <rolename> [<rolename>...]
  ```

- *Delete Roles from User*:

  ```
  ceph dashboard ac-user-del-roles <username> <rolename> [<rolename>...]
  ```

### Example of User and Custom Role Creation[](https://docs.ceph.com/en/latest/mgr/dashboard/#example-of-user-and-custom-role-creation)

In this section we show a complete example of the commands that create a user account that can manage RBD images, view and create Ceph pools, and has read-only access to other scopes.

1. *Create the user*:

   ```
   ceph dashboard ac-user-create bob -i <file-containing-password>
   ```

2. *Create role and specify scope permissions*:

   ```
   ceph dashboard ac-role-create rbd/pool-manager
   ceph dashboard ac-role-add-scope-perms rbd/pool-manager rbd-image read create update delete
   ceph dashboard ac-role-add-scope-perms rbd/pool-manager pool read create
   ```

3. *Associate roles to user*:

   ```
   ceph dashboard ac-user-set-roles bob rbd/pool-manager read-only
   ```



## Proxy Configuration[](https://docs.ceph.com/en/latest/mgr/dashboard/#proxy-configuration)

In a Ceph cluster with multiple `ceph-mgr` instances, only the dashboard running on the currently active `ceph-mgr` daemon will serve incoming requests. Connections to the dashboard’s TCP port on standby `ceph-mgr` instances will receive an HTTP redirect (303) to the active manager’s dashboard URL. This enables you to point your browser to any `ceph-mgr` instance in order to access the dashboard.

If you want to establish a fixed URL to reach the dashboard or if you don’t want to allow direct connections to the manager nodes, you could set up a proxy that automatically forwards incoming requests to the active `ceph-mgr` instance.

### Configuring a URL Prefix[](https://docs.ceph.com/en/latest/mgr/dashboard/#configuring-a-url-prefix)

If you are accessing the dashboard via a reverse proxy, you may wish to service it under a URL prefix. To get the dashboard to use hyperlinks that include your prefix, you can set the `url_prefix` setting:

```
ceph config set mgr mgr/dashboard/url_prefix $PREFIX
```

so you can access the dashboard at `http://$IP:$PORT/$PREFIX/`.

### Disable the redirection[](https://docs.ceph.com/en/latest/mgr/dashboard/#disable-the-redirection)

If the dashboard is behind a load-balancing proxy like [HAProxy](https://www.haproxy.org/) you might want to disable redirection to prevent situations in which internal (unresolvable) URLs are published to the frontend client. Use the following command to get the dashboard to respond with an HTTP error (500 by default) instead of redirecting to the active dashboard:

```
ceph config set mgr mgr/dashboard/standby_behaviour "error"
```

To reset the setting to default redirection, use the following command:

```
ceph config set mgr mgr/dashboard/standby_behaviour "redirect"
```

### Configure the error status code[](https://docs.ceph.com/en/latest/mgr/dashboard/#configure-the-error-status-code)

When redirection is disabled, you may want to customize the HTTP status code of standby dashboards. To do so you need to run the command:

```
ceph config set mgr mgr/dashboard/standby_error_status_code 503
```

### Resolve IP address to hostname before redirect[](https://docs.ceph.com/en/latest/mgr/dashboard/#resolve-ip-address-to-hostname-before-redirect)

The redirect from a standby to the active dashboard is done via the IP address. This is done because resolving IP addresses to hostnames can be error prone in containerized environments. It is also the reason why the option is disabled by default. However, in some situations it might be helpful to redirect via the hostname. For example if the configured TLS certificate matches only the hostnames. To activate the redirection via the hostname run the following command:

```
$ ceph config set mgr mgr/dashboard/redirect_resolve_ip_addr True
```

You can disable it again by:

```
$ ceph config set mgr mgr/dashboard/redirect_resolve_ip_addr False
```

### HAProxy example configuration[](https://docs.ceph.com/en/latest/mgr/dashboard/#haproxy-example-configuration)

Below you will find an example configuration for SSL/TLS passthrough using [HAProxy](https://www.haproxy.org/).

Please note that this configuration works under the following conditions. If the dashboard fails over, the front-end client might receive a HTTP redirect (303) response and will be redirected to an unresolvable host. This happens when failover occurs between two HAProxy health checks. In this situation the previously active dashboard node will now respond with a 303 which points to the new active node. To prevent that situation you should consider disabling redirection on standby nodes.

```
defaults
  log global
  option log-health-checks
  timeout connect 5s
  timeout client 50s
  timeout server 450s

frontend dashboard_front
  mode http
  bind *:80
  option httplog
  redirect scheme https code 301 if !{ ssl_fc }

frontend dashboard_front_ssl
  mode tcp
  bind *:443
  option tcplog
  default_backend dashboard_back_ssl

backend dashboard_back_ssl
  mode tcp
  option httpchk GET /
  http-check expect status 200
  server x <HOST>:<PORT> ssl check verify none
  server y <HOST>:<PORT> ssl check verify none
  server z <HOST>:<PORT> ssl check verify none
```



## Auditing API Requests[](https://docs.ceph.com/en/latest/mgr/dashboard/#auditing-api-requests)

The REST API can log PUT, POST and DELETE requests to the Ceph audit log. This feature is disabled by default, but can be enabled with the following command:

```
ceph dashboard set-audit-api-enabled <true|false>
```

If enabled, the following parameters are logged per each request:

- from - The origin of the request, e.g. https://[::1]:44410
- path - The REST API path, e.g. /api/auth
- method - e.g. PUT, POST or DELETE
- user - The name of the user, otherwise ‘None’

The logging of the request payload (the arguments and their values) is enabled by default. Execute the following command to disable this behaviour:

```
ceph dashboard set-audit-api-log-payload <true|false>
```

A log entry may look like this:

```
2018-10-22 15:27:01.302514 mgr.x [INF] [DASHBOARD] from='https://[::ffff:127.0.0.1]:37022' path='/api/rgw/user/klaus' method='PUT' user='admin' params='{"max_buckets": "1000", "display_name": "Klaus Mustermann", "uid": "klaus", "suspended": "0", "email": "klaus.mustermann@ceph.com"}'
```



## NFS-Ganesha Management[](https://docs.ceph.com/en/latest/mgr/dashboard/#nfs-ganesha-management)

The dashboard requires enabling the NFS module which will be used to manage NFS clusters and NFS exports. For more information check [CephFS & RGW Exports over NFS](https://docs.ceph.com/en/latest/mgr/nfs/#mgr-nfs).

## Plug-ins[](https://docs.ceph.com/en/latest/mgr/dashboard/#plug-ins)

Plug-ins extend the functionality of the Ceph Dashboard in a modular and loosely coupled fashion.



### Feature Toggles[](https://docs.ceph.com/en/latest/mgr/dashboard/#feature-toggles)

This plug-in allows to enable or disable some features from the Ceph Dashboard on-demand. When a feature becomes disabled:

- Its front-end elements (web pages, menu entries, charts, etc.) will become hidden.
- Its associated REST API endpoints will reject any further requests (404, Not Found Error).

The main purpose of this plug-in is to allow ad-hoc customizations of the workflows exposed by the dashboard. Additionally, it could allow for dynamically enabling experimental features with minimal configuration burden and no service impact.

The list of features that can be enabled/disabled is:

- - **Block (RBD)**:

    Image Management: `rbd` Mirroring: `mirroring` iSCSI: `iscsi`

- **Filesystem (Cephfs)**: `cephfs`

- **Objects (RGW)**: `rgw` (including daemon, user and bucket management).

- **NFS**: `nfs-ganesha` exports.

By default all features come enabled.

To retrieve a list of features and their current statuses:

```
ceph dashboard feature status
Feature 'cephfs': 'enabled'
Feature 'iscsi': 'enabled'
Feature 'mirroring': 'enabled'
Feature 'rbd': 'enabled'
Feature 'rgw': 'enabled'
Feature 'nfs': 'enabled'
```

To enable or disable the status of a single or multiple features:

```
ceph dashboard feature disable iscsi mirroring
Feature 'iscsi': disabled
Feature 'mirroring': disabled
```

After a feature status has changed, the API REST endpoints immediately respond to that change, while for the front-end UI elements, it may take up to 20 seconds to reflect it.



### Debug[](https://docs.ceph.com/en/latest/mgr/dashboard/#debug)

This plugin allows to customize the behaviour of the dashboard according to the debug mode. It can be enabled, disabled or checked with the following command:

```
ceph dashboard debug status
Debug: 'disabled'
ceph dashboard debug enable
Debug: 'enabled'
ceph dashboard debug disable
Debug: 'disabled'
```

By default, it’s disabled. This is the recommended setting for production deployments. If required, debug mode can be enabled without need of restarting. Currently, disabled debug mode equals to CherryPy `production` environment, while when enabled, it uses `test_suite` defaults (please refer to [CherryPy Environments](https://docs.cherrypy.org/en/latest/config.html#environments) for more details).

It also adds request uuid (`unique_id`) to Cherrypy on versions that don’t support this. It additionally prints the `unique_id` to error responses and log messages.



### Message of the day (MOTD)[](https://docs.ceph.com/en/latest/mgr/dashboard/#message-of-the-day-motd)

Displays a configured message of the day at the top of the Ceph Dashboard.

The importance of a MOTD can be configured by its severity, which is info, warning or danger. The MOTD can expire after a given time, this means it will not be displayed in the UI anymore. Use the following syntax to specify the expiration time: Ns|m|h|d|w for seconds, minutes, hours, days and weeks. If the MOTD should expire after 2 hours, use 2h or 5w for 5 weeks. Use 0 to configure a MOTD that does not expire.

To configure a MOTD, run the following command:

```
ceph dashboard motd set <severity:info|warning|danger> <expires> <message>
```

To show the configured MOTD:

```
ceph dashboard motd get
```

To clear the configured MOTD run:

```
ceph dashboard motd clear
```

A MOTD with a info or warning severity can be closed by the user. The info MOTD is not displayed anymore until the local storage cookies are cleared or a new MOTD with a different severity is displayed. A MOTD with a ‘warning’ severity will be displayed again in a new session.

## Troubleshooting the Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#troubleshooting-the-dashboard)

### Locating the Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#locating-the-dashboard)

If you are unsure of the location of the Ceph Dashboard, run the following command:

```
ceph mgr services | jq .dashboard
"https://host:port"
```

The command returns the URL where the Ceph Dashboard is located: `https://<host>:<port>/`

Note

Many Ceph tools return results in JSON format. We suggest that you install the [jq](https://stedolan.github.io/jq) command-line utility to facilitate working with JSON data.

### Accessing the Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#id2)

If you are unable to access the Ceph Dashboard, run the following commands:

1. Verify the Ceph Dashboard module is enabled:

   ```
   ceph mgr module ls | jq .enabled_modules
   ```

   Ensure the Ceph Dashboard module is listed in the return value of the command. Example snipped output from the command above:

   ```
   [
     "dashboard",
     "iostat",
     "restful"
   ]
   ```

2. If it is not listed, activate the module with the following command:

   ```
   ceph mgr module enable dashboard
   ```

3. Check the Ceph Dashboard and/or `ceph-mgr` log files for any errors.

   - Check if `ceph-mgr` log messages are written to a file by:

     ```
     ceph config get mgr log_to_file
     ```

     ```
     true
     ```

   - Get the location of the log file (it’s `/var/log/ceph/<cluster-name>-<daemon-name>.log` by default):

     ```
     ceph config get mgr log_file
     ```

     ```
     /var/log/ceph/$cluster-$name.log
     ```

4. Ensure the SSL/TSL support is configured properly:

   - Check if the SSL/TSL support is enabled:

     ```
     ceph config get mgr mgr/dashboard/ssl
     ```

   - If the command returns `true`, verify a certificate exists by:

     ```
     ceph config-key get mgr/dashboard/crt
     ```

     and:

     ```
     ceph config-key get mgr/dashboard/key
     ```

   - If it doesn’t return `true`, run the following command to generate a self-signed certificate or follow the instructions outlined in [SSL/TLS Support](https://docs.ceph.com/en/latest/mgr/dashboard/#dashboard-ssl-tls-support):

     ```
     ceph dashboard create-self-signed-cert
     ```

### Trouble Logging into the Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#trouble-logging-into-the-dashboard)

If you are unable to log into the Ceph Dashboard and you receive the following error, run through the procedural checks below:

![../../_images/invalid-credentials.png](https://docs.ceph.com/en/latest/_images/invalid-credentials.png)

1. Check that your user credentials are correct. If you are seeing the notification message above when trying to log into the Ceph Dashboard, it is likely you are using the wrong credentials. Double check your username and password, and ensure that your keyboard’s caps lock is not enabled by accident.

2. If your user credentials are correct, but you are experiencing the same error, check that the user account exists:

   ```
   ceph dashboard ac-user-show <username>
   ```

   This command returns your user data. If the user does not exist, it will print:

   ```
   Error ENOENT: User <username> does not exist
   ```

3. Check if the user is enabled:

   ```
   ceph dashboard ac-user-show <username> | jq .enabled
   ```

   ```
   true
   ```

   Check if `enabled` is set to `true` for your user. If not the user is not enabled, run:

   ```
   ceph dashboard ac-user-enable <username>
   ```

Please see [User and Role Management](https://docs.ceph.com/en/latest/mgr/dashboard/#dashboard-user-role-management) for more information.

### A Dashboard Feature is Not Working[](https://docs.ceph.com/en/latest/mgr/dashboard/#a-dashboard-feature-is-not-working)

When an error occurs on the backend, you will usually receive an error notification on the frontend. Run through the following scenarios to debug.

1. Check the Ceph Dashboard and `ceph-mgr` logfile(s) for any errors. These can found by searching for keywords, such as *500 Internal Server Error*, followed by `traceback`. The end of a traceback contains more details about what exact error occurred.
2. Check your web browser’s JavaScript Console for any errors.

### Ceph Dashboard Logs[](https://docs.ceph.com/en/latest/mgr/dashboard/#ceph-dashboard-logs)

#### Dashboard Debug Flag[](https://docs.ceph.com/en/latest/mgr/dashboard/#dashboard-debug-flag)

With this flag enabled, error traceback is included in backend responses.

To enable this flag via the Ceph Dashboard, navigate from *Cluster* to *Manager modules*. Select *Dashboard module* and click the edit button. Click the *debug* checkbox and update.

To enable it via the CLI, run the following command:

```
ceph dashboard debug enable
```

#### Setting Logging Level of Dashboard Module[](https://docs.ceph.com/en/latest/mgr/dashboard/#setting-logging-level-of-dashboard-module)

Setting the logging level to debug makes the log more verbose and helpful for debugging.

1. Increase the logging level of manager daemons:

   ```
   ceph tell mgr config set debug_mgr 20
   ```

2. Adjust the logging level of the Ceph Dashboard module via the Dashboard or CLI:

   - Navigate from *Cluster* to *Manager modules*. Select *Dashboard module* and click the edit button. Modify the `log_level` configuration.

   - To adjust it via the CLI, run the following command:

     ```
     bin/ceph config set mgr mgr/dashboard/log_level debug
     ```

\3. High log levels can result in considerable log volume, which can easily fill up your filesystem. Set a calendar reminder for an hour, a day, or a week in the future to revert this temporary logging increase.  This looks something like this:

> ```
> ceph config log
> ...
> --- 11 --- 2020-11-07 11:11:11.960659 --- mgr.x/dashboard/log_level = debug ---
> ...
> ceph config reset 11
> ```



#### Enable Centralized Logging in Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#enable-centralized-logging-in-dashboard)

To learn more about centralized logging, see [Centralized Logging in Ceph](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-centralized-logs)

1. Create the Loki service on any particular host using “Create Services” option.

2. Similarly create the Promtail service which will be by default deployed on all the running hosts.

3. To see debug-level messages as well as info-level events, run the following command via CLI:

   ```
   ceph config set mgr mgr/cephadm/log_to_cluster_level debug
   ```

4. To enable logging to files, run the following commands via CLI:

   ```
   ceph config set global log_to_file true
   ceph config set global mon_cluster_log_to_file true
   ```

5. Click on the Daemon Logs tab under Cluster -> Logs.

6. You can find some pre-defined labels there on clicking the Log browser button such as filename, job etc that can help you query the logs at one go.

7. You can query the logs with LogQL for advanced search and perform some calculations as well - https://grafana.com/docs/loki/latest/logql/.

#### Reporting issues from Dashboard[](https://docs.ceph.com/en/latest/mgr/dashboard/#reporting-issues-from-dashboard)

Ceph-Dashboard provides two ways to create an issue in the Ceph Issue Tracker, either using the Ceph command line interface or by using the Ceph Dashboard user interface.

To create an issue in the Ceph Issue Tracker, a user needs to have an account on the issue tracker. Under the `my account` tab in the Ceph Issue Tracker, the user can see their API access key. This key is used for authentication when creating a new issue. To store the Ceph API access key, in the CLI run:

```
``ceph dashboard set-issue-tracker-api-key -i <file-containing-key>``
```

Then on successful update, you can create an issue using:

```
``ceph dashboard create issue <project> <tracker_type> <subject> <description>``
```

The available projects to create an issue on are: #. dashboard #. block #. object #. file_system #. ceph_manager #. orchestrator #. ceph_volume #. core_ceph

The available tracker types are: #. bug #. feature

The subject and description are then set by the user.

The user can also create an issue using the Dashboard user interface. The settings icon drop down menu on the top right of the navigation bar has the option to `Raise an issue`. On clicking it, a modal dialog opens that has the option to select the project and tracker from their respective drop down menus. The subject and multiline description are added by the user. The user can then submit the issue.

​        