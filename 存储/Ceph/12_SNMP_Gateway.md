# SNMP Gateway 服务

SNMP 仍然是一种广泛使用的协议，用于监控各种软硬件平台上的分布式系统和设备。Ceph 的 SNMP 集成侧重于将警报从 Prometheus  Alertmanager 集群转发到网关守护程序。网关守护程序将警报转换为 SNMP 通知，并将其发送到指定的 SNMP 管理平台。网关守护程序来自 `snmp_notifier` 项目，该项目提供 SNMP V2c 和 V3 支持（身份验证和加密）。

默认情况下，Ceph 的 SNMP 网关服务会部署网关的一个实例。可以通过提供位置信息来增加。但是，请记住，如果启用多个 SNMP 网关守护程序，则 SNMP 管理平台将收到同一事件的多个通知。

## 兼容性

下表显示了网关实现支持的 SNMP 版本

| SNMP 版本     | Supported | Notes                                                        |
| ------------- | --------- | ------------------------------------------------------------ |
| V1            | ❌         | snmp_notifier 不支持。                                       |
| V2c           | ✔         |                                                              |
| V3 authNoPriv | ✔         | 使用 username/password 身份验证，不加密 (NoPriv = no privacy) |
| V3 authPriv   | ✔         | 对 SNMP 管理平台使用带有加密的 username/password 身份验证    |

## 部署 SNMP 网关

Instead, you must create the service using a credentials file (in yaml format), or specify the complete service definition in a yaml file.

SNMP V2c 和 V3 都提供凭据支持。对于 V2c ，this is just the community string这只是社区字符串，但对于 V3 环境，必须提供额外的身份验证信息。部署服务时，命令行不支持这些凭据。相反，必须使用凭据文件（yaml 格式）创建服务，或者在 yaml 文件中指定完整的服务定义。

### 命令格式

```bash
ceph orch apply snmp-gateway <snmp_version:V2c|V3> <destination> [<port:int>] [<engine_id>] [<auth_protocol: MD5|SHA>] [<privacy_protocol:DES|AES>] [<placement>] ...
```

用法说明：

- 必须提供 `--snmp-version` 版本参数。
- `--destination` 参数的格式必须为 `hostname:port`（无默认值）。
- 您可以省略 `--port` 。默认为 9464 。
- `--engine-id` 是设备的唯一标识符（十六进制），仅 SNMP v3 需要。建议值：`8000C53F<fsid>` 。其中 fsid 来自集群，不带 “`-`” 符号。
- 对于 SNMP V3 ， `--auth-protocol` 设置默认为 SHA 。
- 对于 SNMP V3 ，使用加密时，必须定义 `--privacy-protocol` 。
- 必须提供 `-i <filename>` 才能将 secret / password 传递给编排器。

## 部署示例

### SNMP V2c

```bash
ceph orch apply snmp-gateway --port 9464 --snmp_version=V2c --destination=192.168.122.73:162 -i ./snmp_creds.yaml
```

具有包含以下内容的凭证文件：

```yaml
---
snmp_community: public
```

或者，可以为网关创建一个 yaml 定义，并从单个文件中应用它

```yaml
ceph orch apply -i snmp-gateway.yml
```

文件包含以下配置：

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

```bash
ceph orch apply snmp-gateway --snmp-version=V3 --engine-id=800C53F000000 --destination=192.168.122.1:162 -i ./snmpv3_creds.yml
```

凭证文件为：

```yaml
---
snmp_v3_auth_username: myuser
snmp_v3_auth_password: mypassword
```

或作为服务配置文件：

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

定义实现身份验证和隐私（加密）的 SNMP V3 网关服务需要两个附加值

```bash
ceph orch apply snmp-gateway --snmp-version=V3 --engine-id=800C53F000000 --destination=192.168.122.1:162 --privacy-protocol=AES -i ./snmpv3_creds.yml
```

凭证文件为：

```yaml
---
snmp_v3_auth_username: myuser
snmp_v3_auth_password: mypassword
snmp_v3_priv_password: mysecret
```

> **Note：**
>
> 凭据存储在主机上，仅限于 root 用户，并作为环境文件（`--env-file`）传递给 snmp_notifier 程序守护程序，以限制暴露。

## AlertManager 集成

当部署或更新 SNMP 网关服务时，Prometheus Alertmanager 配置会自动更新，以将任何带有 OID 标签的警报转发给 SNMP 网关守护程序进行处理。

## 实施 MIB

To make sense of the SNMP Notification/Trap, you’ll need to apply the MIB to your SNMP management platform. The MIB (CEPH-MIB.txt) can downloaded from the main Ceph [repo](https://github.com/ceph/ceph/tree/master/monitoring/snmp)

要理解 SNMP  Notification / Trap，需要将 MIB 应用于 SNMP 管理平台。MIB（CEPH-MIB.txt）可从 [主 CEPH repo](https://github.com/ceph/ceph/tree/master/monitoring/snmp) 下载。