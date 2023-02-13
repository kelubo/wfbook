# RGW

[TOC]

## 概述

Ceph Object Gateway 是一个构建在 librados 之上的对象存储接口，为应用程序提供一个到 Ceph 存储集群的 RESTful 网关。Ceph 对象存储支持两个接口：

1. **S3-compatible**

   Provides object storage functionality with an interface that is compatible with a large subset of the Amazon S3 RESTful API.

   通过与 Amazon S3 RESTful API 的大型子集兼容的接口提供对象存储功能。

2. **Swift-compatible**

   Provides object storage functionality with an interface that is compatible with a large subset of the OpenStack Swift API.

   通过与 OpenStack Swift API 的大型子集兼容的接口提供对象存储功能。

Ceph 对象存储使用 Ceph 对象网关守护程序（radosgw），它是一个 HTTP 服务器，用于与 Ceph 存储集群交互。由于它提供了与 OpenStack Swift 和 Amazon  S3 兼容的接口，Ceph 对象网关有自己的用户管理。Ceph Object Gateway can store data in the same Ceph Storage Cluster used to store data from Ceph File System clients or Ceph Block Device clients. Ceph 对象网关可以在用于存储来自Ceph文件系统客户端或Ceph块设备客户端的数据的同一Ceph存储集群中存储数据。S3 和 Swift API 共享一个公共名称空间，因此您可以使用一个 API 写数据，然后使用另一个 API 检索数据。

 ![](../../Image/d/ditaa-c80628bafff42fe0c3c4475cdc0f216bc8ca813d.png)

## HTTP Frontend

Ceph 对象网关支持两个可配置 rgw 前端的嵌入式 HTTP前端库。 two embedded HTTP frontend libraries that can be configured with `rgw_frontends`. 

### Beast

New in version Mimic.

The `beast` frontend uses the Boost.Beast library for HTTP parsing and the Boost.Asio library for asynchronous network i/o.

beast 前端使用 Boost 。用于HTTP解析和Boost的Beast库。用于异步网络i/o的Asio库。

#### Options

* port 和 ssl_port
  * Description

    设置 ipv4 和 ipv6 侦听端口号。Can be specified multiple times as in `port=80 port=8000`.可以在 port=80 port=8000中多次指定。

  * Type

    整数。

  * Default

    `80`

* endpoint 和 ssl_endpoint
  * Description

    以 `address[:port]` 格式设置侦听地址，其中地址是点十进制形式的IPv4地址字符串，或是用方括号括起来的十六进制表示法的IPv6地址。where the address is an IPv4 address string in dotted decimal form, or an IPv6 address in hexadecimal notation surrounded by square brackets. Specifying a IPv6 endpoint would listen to v6 only. 指定IPv6端点将只侦听v6。The optional port defaults to 80 for `endpoint` and 443 for `ssl_endpoint`. 对于端点，可选端口默认为80，对于ssl端点，默认为443。Can be specified multiple times as in `endpoint=[::1] endpoint=192.168.0.100:8000`.可以在endpoint=[：：1]endpoint=192.168.0.100:8000中多次指定。

  * Type

    整数

  * Default

    None

* ssl_certificate
  * Description

    Path to the SSL certificate file used for SSL-enabled endpoints. If path is prefixed with `config://`, the certificate will be pulled from the ceph monitor `config-key` database.

    用于启用SSL的端点的SSL证书文件的路径。如果路径前缀为config://，则将从ceph监视器配置密钥数据库中提取证书。

  * Type

    String

  * Default

    None

* ssl_private_key
  * Description

    Optional path to the private key file used for SSL-enabled endpoints. If one is not given, the `ssl_certificate` file is used as the private key. If path is prefixed with `config://`, the certificate will be pulled from the ceph monitor `config-key` database.用于启用SSL的端点的私钥文件的可选路径。如果未提供ssl证书文件，则将ssl证书文件用作私钥。如果路径前缀为config://，则将从ceph监视器配置密钥数据库中提取证书。

  * Type

    String

  * Default

    None

* ssl_options
  * Description

    Optional colon separated list of ssl context options: 

    ssl上下文选项的可选冒号分隔列表：

    * `default_workarounds` Implement various bug workarounds. 
    * `no_compression` Disable compression. 
    * `no_sslv2` Disable SSL v2. 
    * `no_sslv3` Disable SSL v3. 
    * `no_tlsv1` Disable TLS v1. 
    * `no_tlsv1_1` Disable TLS v1.1.
    *  `no_tlsv1_2` Disable TLS v1.2. 
    * `single_dh_use` Always create a new key when using tmp_dh parameters.

  * Type

    String

  * Default

    `no_sslv2:no_sslv3:no_tlsv1:no_tlsv1_1`

* ssl_ciphers
  * Description

    Optional list of one or more cipher strings separated by colons. The format of the string is described in openssl’s ciphers(1) manual.由冒号分隔的一个或多个密码字符串的可选列表。字符串的格式在openssl的密码（1）手册中有描述。

  * Type

    String

  * Default

    None

* tcp_nodelay
  * Description

    If set the socket option will disable Nagle’s algorithm on the connection which means that packets will be sent as soon as possible instead of waiting for a full buffer or timeout to occur. 

    * `1` Disable Nagel’s algorithm for all sockets.
    * `0` Keep the default: Nagel’s algorithm enabled.

  * Type

    Integer (0 or 1)

  * Default

    0

* max_connection_backlog
  * Description

    Optional value to define the maximum size for the queue of connections waiting to be accepted. If not configured, the value from `boost::asio::socket_base::max_connections` will be used.

  * Type

    Integer

  * Default

    None

* request_timeout_ms
  * Description

    The amount of time in milliseconds that Beast will wait for more incoming data or outgoing data before giving up. Setting this value to 0 will disable timeout.

  * Type

    Integer

  * Default

    `65000`

* max_header_size
  * Description

    The maximum number of header bytes available for a single request.

  * Type

    Integer

  * Default

    `16384`

  * Maximum

    `65536`

### Generic Options

Some frontend options are generic and supported by all frontends:

* prefix
  * Description

    A prefix string that is inserted into the URI of all requests. For example, a swift-only frontend could supply a uri prefix of `/swift`.

  * Type

    String

  * Default

    None

## Pool Placement and Storage Classes 池放置和存储类

### Placement Targets

New in version Jewel.

Placement targets control which [Pools](https://docs.ceph.com/en/latest/radosgw/pools) are associated with a particular bucket. A bucket’s placement target is selected on creation, and cannot be modified. The `radosgw-admin bucket stats` command will display its `placement_rule`.

The zonegroup configuration contains a list of placement targets with an initial target named `default-placement`. The zone configuration then maps each zonegroup placement target name onto its local storage. This zone placement information includes the `index_pool` name for the bucket index, the `data_extra_pool` name for metadata about incomplete multipart uploads, and a `data_pool` name for each storage class.

### Storage Classes

New in version Nautilus.

Storage classes are used to customize the placement of object data. S3 Bucket Lifecycle rules can automate the transition of objects between storage classes.

Storage classes are defined in terms of placement targets. Each zonegroup placement target lists its available storage classes with an initial class named `STANDARD`. The zone configuration is responsible for providing a `data_pool` pool name for each of the zonegroup’s storage classes.

### Zonegroup/Zone Configuration

Placement configuration is performed with `radosgw-admin` commands on the zonegroups and zones.

The zonegroup placement configuration can be queried with:

```
$ radosgw-admin zonegroup get
{
    "id": "ab01123f-e0df-4f29-9d71-b44888d67cd5",
    "name": "default",
    "api_name": "default",
    ...
    "placement_targets": [
        {
            "name": "default-placement",
            "tags": [],
            "storage_classes": [
                "STANDARD"
            ]
        }
    ],
    "default_placement": "default-placement",
    ...
}
```

The zone placement configuration can be queried with:

```
$ radosgw-admin zone get
{
    "id": "557cdcee-3aae-4e9e-85c7-2f86f5eddb1f",
    "name": "default",
    "domain_root": "default.rgw.meta:root",
    ...
    "placement_pools": [
        {
            "key": "default-placement",
            "val": {
                "index_pool": "default.rgw.buckets.index",
                "storage_classes": {
                    "STANDARD": {
                        "data_pool": "default.rgw.buckets.data"
                    }
                },
                "data_extra_pool": "default.rgw.buckets.non-ec",
                "index_type": 0
            }
        }
    ],
    ...
}
```

Note

If you have not done any previous [Multisite Configuration](https://docs.ceph.com/en/latest/radosgw/multisite), a `default` zone and zonegroup are created for you, and changes to the zone/zonegroup will not take effect until the Ceph Object Gateways are restarted. If you have created a realm for multisite, the zone/zonegroup changes will take effect once the changes are committed with `radosgw-admin period update --commit`.

#### Adding a Placement Target

To create a new placement target named `temporary`, start by adding it to the zonegroup:

```
$ radosgw-admin zonegroup placement add \
      --rgw-zonegroup default \
      --placement-id temporary
```

Then provide the zone placement info for that target:

```
$ radosgw-admin zone placement add \
      --rgw-zone default \
      --placement-id temporary \
      --data-pool default.rgw.temporary.data \
      --index-pool default.rgw.temporary.index \
      --data-extra-pool default.rgw.temporary.non-ec
```

#### Adding a Storage Class

To add a new storage class named `GLACIER` to the `default-placement` target, start by adding it to the zonegroup:

```
$ radosgw-admin zonegroup placement add \
      --rgw-zonegroup default \
      --placement-id default-placement \
      --storage-class GLACIER
```

Then provide the zone placement info for that storage class:

```
$ radosgw-admin zone placement add \
      --rgw-zone default \
      --placement-id default-placement \
      --storage-class GLACIER \
      --data-pool default.rgw.glacier.data \
      --compression lz4
```

### Customizing Placement

#### Default Placement

By default, new buckets will use the zonegroup’s `default_placement` target. This zonegroup setting can be changed with:

```
$ radosgw-admin zonegroup placement default \
      --rgw-zonegroup default \
      --placement-id new-placement
```

#### User Placement

A Ceph Object Gateway user can override the zonegroup’s default placement target by setting a non-empty `default_placement` field in the user info. Similarly, the `default_storage_class` can override the `STANDARD` storage class applied to objects by default.

```
$ radosgw-admin user info --uid testid
{
    ...
    "default_placement": "",
    "default_storage_class": "",
    "placement_tags": [],
    ...
}
```

If a zonegroup’s placement target contains any `tags`, users will be unable to create buckets with that placement target unless their user info contains at least one matching tag in its `placement_tags` field. This can be useful to restrict access to certain types of storage.

The `radosgw-admin` command can modify these fields directly with:

```
$ radosgw-admin user modify \
      --uid <user-id> \
      --placement-id <default-placement-id> \
      --storage-class <default-storage-class> \
      --tags <tag1,tag2>
```

#### S3 Bucket Placement

When creating a bucket with the S3 protocol, a placement target can be provided as part of the LocationConstraint to override the default placement targets from the user and zonegroup.

Normally, the LocationConstraint must match the zonegroup’s `api_name`:

```
<LocationConstraint>default</LocationConstraint>
```

A custom placement target can be added to the `api_name` following a colon:

```
<LocationConstraint>default:new-placement</LocationConstraint>
```

#### Swift Bucket Placement

When creating a bucket with the Swift protocol, a placement target can be provided in the HTTP header `X-Storage-Policy`:

```
X-Storage-Policy: new-placement
```

### Using Storage Classes

All placement targets have a `STANDARD` storage class which is applied to new objects by default. The user can override this default with its `default_storage_class`.

To create an object in a non-default storage class, provide that storage class name in an HTTP header with the request. The S3 protocol uses the `X-Amz-Storage-Class` header, while the Swift protocol uses the `X-Object-Storage-Class` header.

When using AWS S3 SDKs such as `boto3`, it is important that non-default storage class names match those provided by AWS S3, or else the SDK will drop the request and raise an exception.

S3 Object Lifecycle Management can then be used to move object data between storage classes using `Transition` actions.

## 部署 RGW

Cephadm 将 radosgw 部署为一组守护进程，这些守护进程管理单个集群部署或多站点部署中的特定领域和区域。

请注意，使用 cephadm 时，radosgw 守护程序是通过 MON 配置数据库而不是通过 ceph.conf 或命令行来配置的。如果该配置尚未就绪（通常在 `client.rgw.<realmname>.<zonename>` 部分中），那么 radosgw 守护程序将使用默认设置（例如，绑定到端口80）启动。

要部署一组具有任意服务名称 `name` 的 radosgw 守护程序，请运行以下命令：

```bash
ceph orch apply rgw <name> [ --realm=<realm-name>] [--zone=<zone-name>] --placement="<num-daemons> [<host1> ...]"
```

For example, to deploy 2 rgw daemons serving the *myorg* realm and the *us-east-1* zone on *myhost1* and *myhost2*:例如，要在myhost1和myhost2上部署两个服务于myorg领域和us-east-1区域的rgw守护程序： 

```bash
ceph orch apply rgw --realm=myorg --zone=us-east-1 --placement="2 myhost1 myhost2"
```

Cephadm will wait for a healthy cluster and automatically create the  supplied realm and zone if they do not exist before deploying the rgw  daemon(s)Cephadm将等待运行状况良好的群集，并在部署rgw守护程序之前自动创建所提供的领域和区域（如果它们不存在）

Alternatively, the realm, zonegroup, and zone can be manually created using `radosgw-admin` commands:另外，可以使用radosgw-admin命令手动创建领域，区域组和区域：

```bash
radosgw-admin realm create --rgw-realm=<realm-name> --default
radosgw-admin zonegroup create --rgw-zonegroup=<zonegroup-name>  --master --default
radosgw-admin zone create --rgw-zonegroup=<zonegroup-name> --rgw-zone=<zone-name> --master --default
```

See [Placement Specification](https://docs.ceph.com/docs/master/mgr/orchestrator/#orchestrator-cli-placement-spec) for details of the placement specification.有关放置规范的详细信息，请参见放置规范。



Cephadm 将 radosgw 部署为守护进程的集合，这些守护进程管理单个集群部署或多站点部署中的特定领域和区域。

注意，对于 cephadm，radosgw 守护进程是通过 MON 配置数据库配置的，而不是通过 `ceph.conf` 或命令行。radosgw daemons are configured via the monitor configuration database instead of via a ceph.conf or the command line. 如果该配置尚未到位（通常在 `client.rgw.<something>` 部分），那么 radosgw 守护程序将以默认设置（例如，绑定到端口 80）启动。

要部署一组具有任意服务名称的 radosgw 守护程序，请运行以下命令：

```bash
ceph orch apply rgw <name> [--realm=<realm-name>] [--zone=<zone-name>] --placement="<num-daemons> [<host1> ...]"
```

### 琐碎的设置

例如，要在任意服务 id `foo` 下为单个集群 RGW 部署部署 2 个 RGW 守护进程（默认）：

```bash
ceph orch apply rgw foo
```

### 指定网关

一种常见的情况是有一组标记的主机充当网关，多个 radosgw 实例在连续的端口 8000 和 8001 上运行：

```bash
ceph orch host label add gwhost1 rgw  # the 'rgw' label can be anything
ceph orch host label add gwhost2 rgw
ceph orch apply rgw foo '--placement=label:rgw count-per-host:2' --port=8000
```

### 指定网络

RGW 服务可以使用 yaml 服务规范配置它们绑定到的网络。

```yaml
service_type: rgw
service_name: foo
placement:
  label: rgw
  count-per-host: 2
networks:
- 192.169.142.0/24
spec:
  rgw_frontend_port: 8080
```

### 多站点区域

要在 myhost1 和 myhost2 上部署服务于多站点 `myorg` realm 和 `us-east-1` 区域的 RGW，请执行以下操作：

```bash
ceph orch apply rgw east --realm=myorg --zone=us-east-1 --placement="2 myhost1 myhost2"
```

注意，在多站点情况下，cephadm 只部署守护进程。它不会创建或更新领域或区域配置。要创建新的领域、区域和区域组，可以使用 RGW Module 或手动执行以下操作：

```bash
radosgw-admin realm create --rgw-realm=<realm-name>
radosgw-admin zonegroup create --rgw-zonegroup=<zonegroup-name>  --master
radosgw-admin zone create --rgw-zonegroup=<zonegroup-name> --rgw-zone=<zone-name> --master
radosgw-admin period update --rgw-realm=<realm-name> --commit
```

### 设置 HTTPS

为 RGW 服务启用 HTTPS，请按照以下方案应用规范文件：

```yaml
service_type: rgw
service_id: myrgw
spec:
  rgw_frontend_ssl_certificate: |
    -----BEGIN PRIVATE KEY-----
    V2VyIGRhcyBsaWVzdCBpc3QgZG9vZi4gTG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFt
    ZXQsIGNvbnNldGV0dXIgc2FkaXBzY2luZyBlbGl0ciwgc2VkIGRpYW0gbm9udW15
    IGVpcm1vZCB0ZW1wb3IgaW52aWR1bnQgdXQgbGFib3JlIGV0IGRvbG9yZSBtYWdu
    YSBhbGlxdXlhbSBlcmF0LCBzZWQgZGlhbSB2b2x1cHR1YS4gQXQgdmVybyBlb3Mg
    ZXQgYWNjdXNhbSBldCBqdXN0byBkdW8=
    -----END PRIVATE KEY-----
    -----BEGIN CERTIFICATE-----
    V2VyIGRhcyBsaWVzdCBpc3QgZG9vZi4gTG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFt
    ZXQsIGNvbnNldGV0dXIgc2FkaXBzY2luZyBlbGl0ciwgc2VkIGRpYW0gbm9udW15
    IGVpcm1vZCB0ZW1wb3IgaW52aWR1bnQgdXQgbGFib3JlIGV0IGRvbG9yZSBtYWdu
    YSBhbGlxdXlhbSBlcmF0LCBzZWQgZGlhbSB2b2x1cHR1YS4gQXQgdmVybyBlb3Mg
    ZXQgYWNjdXNhbSBldCBqdXN0byBkdW8=
    -----END CERTIFICATE-----
  ssl: true
```

然后应用此 yaml 文档：

```bash
ceph orch apply -i myrgw.yaml
```

注意， `rgw_frontend_ssl_certificate` 的值是一个文字字符串，由保留换行符的 | 字符表示。is a literal string as indicated by a `|` character preserving newline characters.

### 服务规范

`class ceph.deployment.service_spec.RGWSpec(service_type='rgw', service_id=None, placement=None, rgw_realm=None, rgw_zonegroup=None, rgw_zone=None, rgw_frontend_port=None, rgw_frontend_ssl_certificate=None, rgw_frontend_type=None, unmanaged=False, ssl=False, preview_only=False, config=None, networks=None, subcluster=None, extra_container_args=None, extra_entrypoint_args=None, custom_configs=None, rgw_realm_token=None, update_endpoints=False, zone_endpoints=None)`

配置（多站点）Ceph RGW

```yaml
service_type: rgw
service_id: myrealm.myzone
spec:
    rgw_realm: myrealm
    rgw_zonegroup: myzonegroup
    rgw_zone: myzone
    ssl: true
    rgw_frontend_port: 1234
    rgw_frontend_type: beast
    rgw_frontend_ssl_certificate: ...
```

* rgw_frontend_port*: Optional[int]*

  Port of the RGW daemons

* rgw_frontend_ssl_certificate*: Optional[List[str]]*

  List of SSL certificates

* rgw_frontend_type*: Optional[str]*

  civetweb or beast (default: beast). 

* rgw_realm*: Optional[str]*

  The RGW realm associated with this service. Needs to be manually created  

* rgw_zone*: Optional[str]*

  The RGW zone associated with this service. Needs to be manually created 

* rgw_zonegroup*: Optional[str]*

  The RGW zonegroup associated with this service. Needs to be manually created if the spec is being applied directly to cephdam. In case of rgw module the zonegroup is created automatically.
  
* ssl

  启用 SSL

## 高可用

ingress 服务允许您使用最少的一组配置选项为 RGW 创建高可用性端点。编排器将部署和管理 haproxy 和keepalive 的组合，以在浮动虚拟 IP 上提供负载平衡。

如果 RGW 服务配置为启用SSL，则 ingress 服务将使用 SSL 并在 verify none options in the backend configuration后端配置中验证无选项。信任验证已禁用，因为后端是通过 IP 地址而不是 FQDN 访问的。

![](../../Image/c/ceph_HAProxy_for_RGW.svg)

有 N 个主机部署了入口服务。每个主机都有一个 haproxy 守护程序和一个 keepalive 守护程序。一次只能在其中一台主机上自动配置虚拟 IP。

每个 keepalive 守护程序每隔几秒钟检查同一主机上的 haproxy 守护程序是否正在响应。Keepalived 还将检查 mast Keepalived 守护进程是否运行正常。如果 “master” keepalive 守护程序或活动 haproxy 没有响应，在备份模式下运行的其余 keepalive 后台程序之一将被选为主节点，虚拟 IP 将被移动到该节点。

活动的 haproxy 充当负载平衡器，在所有可用的 RGW 守护进程之间分发所有 RGW 请求。

### 前提条件

一个现有的 RGW 服务。

### 部署

```bash
ceph orch apply -i <ingress_spec_file>
```

### 服务规范

它是一个具有以下属性的 yaml 格式文件：

```yaml
service_type: ingress
service_id: rgw.something    # adjust to match your existing RGW service
placement:
  hosts:
    - host1
    - host2
    - host3
spec:
  backend_service: rgw.something      # adjust to match your existing RGW service
  virtual_ip: <string>/<string>       # ex: 192.168.20.1/24
  frontend_port: <integer>            # ex: 8080
  monitor_port: <integer>             # ex: 1967, used by haproxy for load balancer status
  virtual_interface_networks: [ ... ] # optional: list of CIDR networks
  ssl_cert: |                         # optional: SSL certificate and key
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
```

```yaml
service_type: ingress
service_id: rgw.something    # adjust to match your existing RGW service
placement:
  hosts:
    - host1
    - host2
    - host3
spec:
  backend_service: rgw.something      # adjust to match your existing RGW service
  virtual_ips_list:
  - <string>/<string>                 # ex: 192.168.20.1/24
  - <string>/<string>                 # ex: 192.168.20.2/24
  - <string>/<string>                 # ex: 192.168.20.3/24
  frontend_port: <integer>            # ex: 8080
  monitor_port: <integer>             # ex: 1967, used by haproxy for load balancer status
  virtual_interface_networks: [ ... ] # optional: list of CIDR networks
  ssl_cert: |                         # optional: SSL certificate and key
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----
```

该服务规范的属性为：

- `service_type`

  Mandatory and set to “ingress”

- `service_id`

  The name of the service.  We suggest naming this after the service you are controlling ingress for (e.g., `rgw.foo`).

- `placement hosts`

  The hosts where it is desired to run the HA daemons. An haproxy and a keepalived container will be deployed on these hosts.  These hosts do not need to match the nodes where RGW is deployed.

- `virtual_ip`

  The virtual IP (and network) in CIDR format where the ingress service will be available.

- `virtual_ips_list`

  The virtual IP address in CIDR format where the ingress service will be available. Each virtual IP address will be primary on one node running the ingress service. The number of virtual IP addresses must be less than or equal to the number of ingress nodes.

- `virtual_interface_networks`

  A list of networks to identify which ethernet interface to use for the virtual IP.

- `frontend_port`

  The port used to access the ingress service.

- `ssl_cert`:

  SSL certificate, if SSL is to be enabled. This must contain the both the certificate and private key blocks in .pem format.

### 为虚拟 IP 选择以太网接口

不能简单地提供要在其上配置虚拟 IP 的网络接口的名称，因为接口名称往往会因主机而异（和 / 或重新启动）。相反，cephadm 将根据已配置的其他现有 IP 地址选择接口。

通常，虚拟 IP 将配置在同一子网中具有现有 IP 的第一个网络接口上。例如，如果虚拟 IP 为 192.168.0.80 / 24，eth2 的静态 IP 为 192.168.0.40 / 24，则 cephadm 将使用 eth2 。

在某些情况下，虚拟 IP 可能与现有静态 IP 不属于同一子网。在这种情况下，可以提供与现有 IP 匹配的子网列表，cephadm 会将虚拟 IP 放在第一个要匹配的网络接口上。例如，如果虚拟 IP 为 192.168.0.80 / 24，并且我们希望它与 10.10.0.0 / 16 中的机器静态 IP 位于同一个接口上，则可以使用如下规范：

```yaml
service_type: ingress
service_id: rgw.something
spec:
  virtual_ip: 192.168.0.80/24
  virtual_interface_networks:
    - 10.10.0.0/16
  ...
```

A consequence of this strategy is that you cannot currently configure the virtual IP on an interface that has no existing IP address.  In this situation, we suggest configuring a “dummy” IP address is an unroutable network on the correct interface and reference that dummy network in the networks list.

此策略的结果是，当前无法在没有现有 IP 地址的接口上配置虚拟 IP 。在这种情况下，建议将“虚拟” IP 地址配置为正确接口上的不可路由网络，并在网络列表中引用该虚拟网络。

### 有用的 ingress 提示

- 最好至少有 3 个 RGW 守护进程。
- 建议至少 3 台主机用于 ingress 服务。



 	

# 使用命令行界面部署 Ceph 对象网关

​				使用 Ceph 编排器，您可以在命令行界面中使用 `ceph orch` 命令来部署 Ceph 对象网关 

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						您可以通过三种不同的方式部署 Ceph 对象网关守护进程： 				

**方法 1**

- ​						创建 realm、zone group 和 zone，然后将放置规格与主机名搭配使用： 				

  1. ​								创建一个域： 						

     **语法**

     ​									

     ```none
     radosgw-admin realm create --rgw-realm=REALM_NAME --default
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin realm create --rgw-realm=test_realm --default
     ```

  2. ​								创建区组： 						

     **语法**

     ​									

     ```none
     radosgw-admin zonegroup create --rgw-zonegroup=ZONE_GROUP_NAME  --master --default
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin zonegroup create --rgw-zonegroup=default  --master --default
     ```

  3. ​								创建区： 						

     **语法**

     ​									

     ```none
     radosgw-admin zone create --rgw-zonegroup=ZONE_GROUP_NAME --rgw-zone=ZONE_NAME --master --default
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin zone create --rgw-zonegroup=default --rgw-zone=test_zone --master --default
     ```

  4. ​								提交更改： 						

     **语法**

     ​									

     ```none
     radosgw-admin period update --rgw-realm=REALM_NAME --commit
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# radosgw-admin period update --rgw-realm=test_realm --commit
     ```

  5. ​								运行 `ceph orch apply` 命令： 						

     **语法**

     ​									

     ```none
     ceph orch apply rgw NAME [--realm=REALM_NAME] [--zone=ZONE_NAME] --placement="NUMBER_OF_DAEMONS [HOST_NAME_1 HOST_NAME_2]"
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph orch apply rgw test --realm=test_realm --zone=test_zone --placement="2 host01 host02"
     ```

**方法 2**

- ​						使用任意服务名称为单个集群部署部署两个 Ceph 对象网关守护进程： 				

  **语法**

  ​							

  ```none
  ceph orch apply rgw SERVICE_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch apply rgw foo
  ```

**方法 3**

- ​						在标记的一组主机上使用任意服务名称： 				

  **语法**

  ​							

  ```none
  ceph orch host label add HOST_NAME_1 LABEL_NAME
  ceph orch host label add HOSTNAME_2 LABEL_NAME
  ceph orch apply rgw SERVICE_NAME '--placement=label:_LABEL_NAME_ count-per-host:_NUMBER_OF_DAEMONS_' --port=8000
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch host label add host01 rgw  # the 'rgw' label can be anything
  [ceph: root@host01 /]# ceph orch host label add host02 rgw
  [ceph: root@host01 /]# ceph orch apply rgw foo '--placement=label:rgw count-per-host:2' --port=8000
  ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=rgw
  ```

# 使用服务规格部署 Ceph 对象网关

​				利用 Ceph 编排器，您可以使用服务规格部署 Ceph 对象网关。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						进入以下目录： 				

   **语法**

   ​							

   ```none
   cd /var/lib/ceph/DAEMON_PATH/
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs/]# cd /var/lib/ceph/rgw/
   ```

   ​						如果 `rgw` 目录不存在，请在路径中创建 目录。 				

3. ​						创建 `rgw.yml` 文件： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 rgw]# touch rgw.yml
   ```

4. ​						编辑 `rgw.yml` 文件，使其包含以下详情： 				

   **语法**

   ​							

   ```none
   service_type: rgw
   service_id: REALM_NAME.ZONE_NAME
   placement:
     hosts:
     - HOST_NAME_1
     - HOST_NAME_2
   spec:
     rgw_realm: REALM_NAME
     rgw_zone: ZONE_NAME
   networks:
     -  NETWORK_IP_ADDRESS # RGW service binds to a specific network
   ```

   **示例**

   ​							

   ```none
   service_type: rgw
   service_id: test_realm.test_zone
   placement:
     hosts:
     - host01
     - host02
     - host03
   spec:
     rgw_realm: test_realm
     rgw_zone: test_zone
   networks:
     - 192.169.142.0/24
   ```

5. ​						使用服务规格部署 Ceph 对象网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply -i FILE_NAME.yml
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 rgw]# ceph orch apply -i rgw.yml
   ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=rgw
  ```

# 使用 Ceph 编排器部署多站点 Ceph 对象网关

​				Ceph 编排器支持用于 Ceph 对象网关的多站点配置选项。 		

​				您可以将每个对象网关配置为在主动区域配置中工作，从而允许写入到非主要区域。多站点配置存储在名为 realm 的容器中。 		

​				realm 存储 zone group、区域和一个时间周期。`rgw` 守护进程处理同步消除了对独立同步代理的需求，因此使用主动-主动配置运行。 		

​				您还可以使用命令行界面(CLI)部署多站点区域。 		

注意

​					以下配置假定在地理上至少有两个红帽 Ceph 存储集群。但是，配置也在同一站点工作。 			

**先决条件**

- ​						至少两个正在运行的 Red Hat Ceph Storage 集群 				
- ​						至少两个 Ceph 对象网关实例，每个实例对应一个红帽 Ceph 存储集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						节点或容器添加到存储集群中。 				
- ​						部署所有 Ceph 管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						在 `cephadm` shell 中，配置主区： 				

   1. ​								创建一个域： 						

      **语法**

      ​									

      ```none
      radosgw-admin realm create --rgw-realm=REALM_NAME --default
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin realm create --rgw-realm=test_realm --default
      ```

      ​								如果存储集群只有一个域，则指定 `--default` 标志。 						

   2. ​								创建主要区组： 						

      **语法**

      ​									

      ```none
      radosgw-admin zonegroup create --rgw-zonegroup=ZONE_GROUP_NAME --endpoints=http://RGW_PRIMARY_HOSTNAME:_RGW_PRIMARY_PORT_NUMBER_1_ --master --default
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin zonegroup create --rgw-zonegroup=us --endpoints=http://rgw1:80 --master --default
      ```

   3. ​								创建一个主要区： 						

      **语法**

      ​									

      ```none
      radosgw-admin zone create --rgw-zonegroup=PRIMARY_ZONE_GROUP_NAME --rgw-zone=PRIMARY_ZONE_NAME --endpoints=http://RGW_PRIMARY_HOSTNAME:_RGW_PRIMARY_PORT_NUMBER_1_ --access-key=SYSTEM_ACCESS_KEY --secret=SYSTEM_SECRET_KEY
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin zone create --rgw-zonegroup=us --rgw-zone=us-east-1 --endpoints=http://rgw1:80
      ```

   4. ​								可选：删除默认 zone、zone group 和关联的池： 						

      重要

      ​									如果您使用默认 zone 和 zone group 存储数据，则不要删除默认区域及其池。此外，删除默认 zone group 也会删除系统用户。 							

      **示例**

      ​										

      ```none
      [ceph: root@host01 /]# radosgw-admin zonegroup delete --rgw-zonegroup=default
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.log default.rgw.log --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.meta default.rgw.meta --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.control default.rgw.control --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.data.root default.rgw.data.root --yes-i-really-really-mean-it
      [ceph: root@host01 /]# ceph osd pool rm default.rgw.gc default.rgw.gc --yes-i-really-really-mean-it
      ```

   5. ​								创建系统用户： 						

      **语法**

      ​									

      ```none
      radosgw-admin user create --uid=USER_NAME --display-name="USER_NAME" --access-key=SYSTEM_ACCESS_KEY --secret=SYSTEM_SECRET_KEY --system
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin user create --uid=zone.user --display-name="Zone user" --system
      ```

      ​								记录 `access_key` 和 `secret_key`。 						

   6. ​								在主区中添加 access key 和 system key： 						

      **语法**

      ​									

      ```none
      radosgw-admin zone modify --rgw-zone=PRIMARY_ZONE_NAME --access-key=ACCESS_KEY --secret=SECRET_KEY
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin zone modify --rgw-zone=us-east-1 --access-key=NE48APYCAODEPLKBCZVQ--secret=u24GHQWRE3yxxNBnFBzjM4jn14mFIckQ4EKL6LoW
      ```

   7. ​								提交更改： 						

      **语法**

      ​									

      ```none
      radosgw-admin period update --commit
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# radosgw-admin period update --commit
      ```

   8. ​								在 `cephadm` shell 外部，获取存储集群的 `FSID` 及进程： 						

      **示例**

      ​									

      ```none
      [root@host01 ~]#  systemctl list-units | grep ceph
      ```

   9. ​								启动 Ceph 对象网关守护进程： 						

      **语法**

      ​									

      ```none
      systemctl start ceph-FSID@DAEMON_NAME
      systemctl enable ceph-FSID@DAEMON_NAME
      ```

      **示例**

      ​									

      ```none
      [root@host01 ~]# systemctl start ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-1.host01.ahdtsw.service
      [root@host01 ~]# systemctl enable ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-1.host01.ahdtsw.service
      ```

2. ​						在 Cephadm shell 中，配置 second zone。 				

   1. ​								使用 primary zone 和 primary zone group 的 URL 路径、访问密钥和 secret 密钥，并从主机拉取 realm 配置： 						

      **语法**

      ​									

      ```none
      radosgw-admin period pull --url=URL_TO_PRIMARY_ZONE_GATEWAY --access-key=ACCESS_KEY --secret-key=SECRET_KEY
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# radosgw-admin period pull --url=http://10.74.249.26:80 --access-key=LIPEYZJLTWXRKXS9LPJC --secret-key=IsAje0AVDNXNw48LjMAimpCpI7VaxJYSnfD0FFKQ
      ```

   2. ​								配置 second zone: 						

      **语法**

      ​									

      ```none
      radosgw-admin zone create --rgw-zonegroup=ZONE_GROUP_NAME \
                   --rgw-zone=SECONDARY_ZONE_NAME --endpoints=http://RGW_SECONDARY_HOSTNAME:_RGW_PRIMARY_PORT_NUMBER_1_ \
                   --access-key=SYSTEM_ACCESS_KEY --secret=SYSTEM_SECRET_KEY \
                   --endpoints=http://FQDN:80 \
                   [--read-only]
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# radosgw-admin zone create --rgw-zonegroup=us --rgw-zone=us-east-2 --endpoints=http://rgw2:80 --access-key=LIPEYZJLTWXRKXS9LPJC --secret-key=IsAje0AVDNXNw48LjMAimpCpI7VaxJYSnfD0FFKQ
      ```

   3. ​								可选：删除默认区： 						

      重要

      ​									如果您使用默认 zone 和 zone group 存储数据，则不要删除默认区域及其池。 							

      **示例**

      ​										

      ```none
      [ceph: root@host04 /]# radosgw-admin zone rm --rgw-zone=default
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.log default.rgw.log --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.meta default.rgw.meta --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.control default.rgw.control --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.data.root default.rgw.data.root --yes-i-really-really-mean-it
      [ceph: root@host04 /]# ceph osd pool rm default.rgw.gc default.rgw.gc --yes-i-really-really-mean-it
      ```

   4. ​								更新 Ceph 配置数据库： 						

      **语法**

      ​									

      ```none
      ceph config set _SERVICE_NAME_ rgw_zone _SECONDARY_ZONE_NAME_
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# ceph config set rgw rgw_zone us-east-2
      ```

   5. ​								提交更改： 						

      **语法**

      ​									

      ```none
      radosgw-admin period update --commit
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host04 /]# radosgw-admin period update --commit
      ```

   6. ​								在 Cephadm shell 外，获取存储集群的 FSID 及进程： 						

      **示例**

      ​									

      ```none
      [root@host04 ~]#  systemctl list-units | grep ceph
      ```

   7. ​								启动 Ceph 对象网关守护进程： 						

      **语法**

      ​									

      ```none
      systemctl start ceph-FSID@DAEMON_NAME
      systemctl enable ceph-FSID@DAEMON_NAME
      ```

      **示例**

      ​									

      ```none
      [root@host04 ~]# systemctl start ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-2.host04.ahdtsw.service
      [root@host04 ~]# systemctl enable ceph-62a081a6-88aa-11eb-a367-001a4a000672@rgw.test_realm.us-east-2.host04.ahdtsw.service
      ```

3. ​						可选：使用放置规格部署多站点 Ceph 对象网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply rgw _NAME_ --realm=_REALM_NAME_ --zone=_PRIMARY_ZONE_NAME_ --placement="_NUMBER_OF_DAEMONS_ _HOST_NAME_1_ _HOST_NAME_2_"
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host04 /]# ceph orch apply rgw east --realm=test_realm --zone=us-east-1 --placement="2 host01 host02"
   ```

**验证**

- ​						检查同步状态以验证部署： 				

  **示例**

  ​							

  ```none
  [ceph: root@host04 /]# radosgw-admin sync status
  ```



# 使用 Ceph 编排器移除 Ceph 对象网关

​				您可以使用 `ceph 或ch rm` 命令移除 Ceph 对象网关守护进程。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						主机上至少部署了一个 Ceph 对象网关守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						列出服务： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch ls
   ```

   1. ​								删除服务 						

      **语法**

      ​									

      ```none
      ceph orch rm SERVICE_NAME
      ```

      **示例**

      ​									

      ```none
      [ceph: root@host01 /]# ceph orch rm rgw.test_realm.test_zone_bb
      ```

**验证**

- ​						列出主机、守护进程和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps
  ```



Cephadm 将 radosgw 部署为守护进程的集合，这些守护进程管理单个集群部署或多站点部署中的特定领域和区域。

Note that with cephadm, radosgw daemons are configured via the monitor configuration database instead of via a ceph.conf or the command line.  If that configuration isn’t already in place (usually in the `client.rgw.<something>` section), then the radosgw daemons will start up with default settings .

注意，对于cephadm，radosgw守护进程是通过监视器配置数据库配置的，而不是通过ceph.conf或命令行配置的。如果该配置尚未到位（通常在client.rgw.部分），那么radosgw守护进程将以默认设置启动（例如绑定到端口80）。

使用任意服务名称部署一组 radosgw ，运行以下命令：

```bash
ceph orch apply rgw <name> [--realm=<realm-name>] [--zone=<zone-name>] --placement="<num-daemons> [<host1> ...]"
```
