# SNMP Gateway 服务

[SNMP](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol) is still a widely used protocol, to monitor distributed systems and devices across a variety of hardware and software platforms. Ceph’s SNMP integration focuses on forwarding alerts from it’s Prometheus Alertmanager cluster to a gateway daemon. The gateway daemon, transforms the alert into an SNMP Notification and sends it on to a designated SNMP management platform. The gateway daemon is from the [snmp_notifier](https://github.com/maxwo/snmp_notifier) project, which provides SNMP V2c and V3 support (authentication and encryption).

SNMP仍然是一种广泛使用的协议，用于监控各种硬件和软件平台上的分布式系统和设备。Ceph的SNMP集成侧重于将警报从Prometheus  Alertmanager集群转发到网关守护程序。网关守护程序将警报转换为SNMP通知，并将其发送到指定的SNMP管理平台。网关守护程序来自snmp通知程序项目，该项目提供snmp V2c和V3支持（身份验证和加密）。

Ceph’s SNMP gateway service deploys one instance of the gateway by default. You may increase this by providing placement information. However, bear in mind that if you enable multiple SNMP gateway daemons, your SNMP management platform will receive multiple notifications for the same event.

Ceph的SNMP网关服务默认部署网关的一个实例。您可以通过提供位置信息来增加这一点。但是，请记住，如果启用多个SNMP网关守护程序，则SNMP管理平台将收到同一事件的多个通知。

## 兼容性

The table below shows the SNMP versions that are supported by the gateway implementation

下表显示了网关实现支持的SNMP版本

| SNMP Version  | Supported | Notes                                                        |
| ------------- | --------- | ------------------------------------------------------------ |
| V1            | ❌         | Not supported by snmp_notifier                               |
| V2c           | ✔         |                                                              |
| V3 authNoPriv | ✔         | uses username/password authentication, without encryption (NoPriv = no privacy) |
| V3 authPriv   | ✔         | uses username/password authentication with encryption to the SNMP management platform |

## 部署 SNMP Gateway

Both SNMP V2c and V3 provide credentials support. In the case of V2c, this is just the community string - but for V3 environments you must provide additional authentication information. These credentials are not supported on the command line when deploying the service. Instead, you must create the service using a credentials file (in yaml format), or specify the complete service definition in a yaml file.

SNMP V2c和V3都提供凭据支持。对于V2c，这只是社区字符串，但对于V3环境，您必须提供额外的身份验证信息。部署服务时，命令行不支持这些凭据。相反，您必须使用凭据文件（yaml格式）创建服务，或者在yaml文件中指定完整的服务定义。

### Command format

```bash
ceph orch apply snmp-gateway <snmp_version:V2c|V3> <destination> [<port:int>] [<engine_id>] [<auth_protocol: MD5|SHA>] [<privacy_protocol:DES|AES>] [<placement>] ...
```

用法注解

- you must supply the `--snmp-version` parameter
- the `--destination` parameter must be of the format hostname:port (no default)
- you may omit `--port`. It defaults to 9464
- the `--engine-id` is a unique identifier for the device (in hex) and required for SNMP v3 only. Suggested value: 8000C53F<fsid> where the fsid is from your cluster, without the ‘-’ symbols
- for SNMP V3, the `--auth-protocol` setting defaults to **SHA**
- for SNMP V3, with encryption you must define the `--privacy-protocol`
- you **must** provide a -i <filename> to pass the secrets/passwords to the orchestrator
- 必须提供--snmp版本参数
- --destination参数的格式必须为hostname:port（无默认值）您可以省略--port。默认为9464
- --engine-id是设备的唯一标识符（十六进制），仅SNMP v3需要。建议值：8000C53F其中fsid来自集群，不带“-”符号
- 对于SNMP V3，--auth协议设置默认为SHA
- 对于SNMP V3，使用加密，必须定义--隐私协议
- 必须提供-i＜filename＞才能将机密/密码传递给协调器

## 部署示例

### SNMP V2c

Here’s an example for V2c, showing CLI and service based deployments

```bash
ceph orch apply snmp-gateway --port 9464 --snmp_version=V2c --destination=192.168.122.73:162 -i ./snmp_creds.yaml
```

with a credentials file that contains;

```yaml
---
snmp_community: public
```

Alternatively, you can create a yaml definition for the gateway and apply it from a single file

```yaml
ceph orch apply -i snmp-gateway.yml
```

with the file containing the following configuration

```yaml
service_type: snmp-gateway
service_name: snmp-gateway
placement:
  count: 1
spec:
  credentials:
    snmp_community: public
  port: 9464
  snmp_destination: 192.168.122.73:162
  snmp_version: V2c
```

### SNMP V3 (authNoPriv)

Deploying an snmp-gateway service supporting SNMP V3 with authentication only, would look like this;

```bash
ceph orch apply snmp-gateway --snmp-version=V3 --engine-id=800C53F000000 --destination=192.168.122.1:162 -i ./snmpv3_creds.yml
```

with a credentials file as;

```yaml
---
snmp_v3_auth_username: myuser
snmp_v3_auth_password: mypassword
```

or as a service configuration file

```yaml
service_type: snmp-gateway
service_name: snmp-gateway
placement:
  count: 1
spec:
  credentials:
    snmp_v3_auth_password: mypassword
    snmp_v3_auth_username: myuser
  engine_id: 800C53F000000
  port: 9464
  snmp_destination: 192.168.122.1:162
  snmp_version: V3
```

### SNMP V3 (authPriv)

Defining an SNMP V3 gateway service that implements authentication and privacy (encryption), requires two additional values

```basic
ceph orch apply snmp-gateway --snmp-version=V3 --engine-id=800C53F000000 --destination=192.168.122.1:162 --privacy-protocol=AES -i ./snmpv3_creds.yml
```

with a credentials file as;

```yaml
---
snmp_v3_auth_username: myuser
snmp_v3_auth_password: mypassword
snmp_v3_priv_password: mysecret
```

> **Note：**
>
> The credentials are stored on the host, restricted to the root user and passed to the snmp_notifier daemon as an environment file (`--env-file`), to limit exposure.

## AlertManager Integration

When an SNMP gateway service is deployed or updated, the Prometheus  Alertmanager configuration is automatically updated to forward any alert that has an [OID](https://en.wikipedia.org/wiki/Object_identifier) label to the SNMP gateway daemon for processing.

当部署或更新SNMP网关服务时，Prometheus Alertmanager配置会自动更新，以将任何带有OID标签的警报转发给SNMP网关守护程序进行处理。

## 实施 MIB

To make sense of the SNMP Notification/Trap, you’ll need to apply the MIB to your SNMP management platform. The MIB (CEPH-MIB.txt) can downloaded from the main Ceph [repo](https://github.com/ceph/ceph/tree/master/monitoring/snmp)

要理解SNMP通知/陷阱，您需要将MIB应用于SNMP管理平台。MIB（CEPH-MIB.txt）可从主CEPH repo下载