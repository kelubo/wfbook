# iSCSI

[TOC]

## 概述

iSCSI 网关提供高可用性 (HA) iSCSI 目标，将 RADOS 块设备 (RBD) 镜像导出为 SCSI 磁盘。

## 部署 iSCSI

### 使用命令行界面

可以在命令行界面中使用 `ceph orch` 命令来部署 iSCSI 网关。

1. 创建池：

   ```bash
   ceph osd pool create POOL_NAME
   
   ceph osd pool create mypool
   ```

2. 使用命令行界面部署 iSCSI 网关：

   ```bash
   ceph orch apply iscsi POOLNAME admin admin --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2"
   
   ceph orch apply iscsi mypool admin admin --placement="1 host01"
   ```


**验证**

- 列出服务：

  ```bash
ceph orch ls
  ```

- 列出主机和进程：	

  ```bash
  ceph orch ps --daemon_type=DAEMON_NAME
  
  ceph orch ps --daemon_type=iscsi
  ```
### 使用服务规格

1. 创建 `iscsi.yml` 文件：

   ```yaml
   service_type: iscsi
   service_id: iscsi
   placement:
     hosts:
       - host1
       - host2
   spec:
     pool: mypool  # RADOS pool where ceph-iscsi config data is stored.
     trusted_ip_list: "IP_ADDRESS_1,IP_ADDRESS_2"
     api_port: ... # optional
     api_user: ... # optional
     api_password: ... # optional
     api_secure: true/false # optional
     ssl_cert: | # optional
     ...
     ssl_key: | # optional
     ...
   
   # eg
   service_type: iscsi
   service_id: iscsi
   placement:
     hosts:
     - [...]
   spec:
     pool: iscsi_pool
     trusted_ip_list: "IP_ADDRESS_1,IP_ADDRESS_2,IP_ADDRESS_3,..."
     api_user: API_USERNAME
     api_password: API_PASSWORD
     ssl_cert: |
       -----BEGIN CERTIFICATE-----
       MIIDtTCCAp2gAwIBAgIYMC4xNzc1NDQxNjEzMzc2MjMyXzxvQ7EcMA0GCSqGSIb3
       DQEBCwUAMG0xCzAJBgNVBAYTAlVTMQ0wCwYDVQQIDARVdGFoMRcwFQYDVQQHDA5T
       [...]
       -----END CERTIFICATE-----
     ssl_key: |
       -----BEGIN PRIVATE KEY-----
       MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5jdYbjtNTAKW4
       /CwQr/7wOiLGzVxChn3mmCIF3DwbL/qvTFTX2d8bDf6LjGwLYloXHscRfxszX/4h
       [...]
       -----END PRIVATE KEY-----
   ```
   
2. 使用服务规格部署 iSCSI 网关:

   ```bash
   ceph orch apply -i FILE_NAME.yml
   ```

```c++
class ceph.deployment.service_spec.IscsiServiceSpec(service_type='iscsi', service_id=None, pool=None, trusted_ip_list=None, api_port=None, api_user=None, api_password=None, api_secure=None, ssl_cert=None, ssl_key=None, placement=None, unmanaged=False, preview_only=False, config=None, networks=None, extra_container_args=None, custom_configs=None)
```

- api_password

  `iscsi-gateway.cfg` 中定义的 `api_password` 

- api_port

  `iscsi-gateway.cfg` 中定义的 `api_port` 

- api_secure

  `iscsi-gateway.cfg` 中定义的 `api_secure`

- api_user

  `iscsi-gateway.cfg` 中定义的 `api_user`

- networks*: List[str]*

  A list of network identities instructing the daemons to only bind on the particular networks in that list. In case the cluster is distributed across multiple networks, you can add multiple networks. See [Networks and Ports](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-networks-ports), [Specifying Networks](https://docs.ceph.com/en/latest/cephadm/services/rgw/#cephadm-rgw-networks) and [Specifying Networks](https://docs.ceph.com/en/latest/cephadm/services/mgr/#cephadm-mgr-networks). 一个网络身份列表，指示守护进程仅绑定 在该列表中的特定网络上。集群分布时 在多个网络中，您可以添加多个网络。看 [网络和端口](https://docs.ceph.com/en/latest/cephadm/services/monitoring/#cephadm-monitoring-networks-ports)， [指定网络](https://docs.ceph.com/en/latest/cephadm/services/rgw/#cephadm-rgw-networks)和[指定网络](https://docs.ceph.com/en/latest/cephadm/services/mgr/#cephadm-mgr-networks)。

- placement*: [PlacementSpec](https://docs.ceph.com/en/latest/mgr/orchestrator_modules/#ceph.deployment.service_spec.PlacementSpec)*

  See [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec). 请参见[守护程序放置](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec)。

- pool

  RADOS 池，其中存储了 ceph-iscsi 配置数据。

- ssl_cert

  SSL 证书

- ssl_key

  SSL 私钥

- trusted_ip_list

  受信任的 IP 地址列表

## 删除 iSCSI 网关

可以使用 `ceph 或ch rm` 命令删除 iSCSI 网关守护进程。

1. 列出服务：

   ```bash
   ceph orch ls
   ```

2. 删除服务

      ```bash
      ceph orch rm SERVICE_NAME
      
      ceph orch rm iscsi.iscsi
      ```



## 配置 iSCSI client



通过配置 iSCSI Initiator，可以从任何主机使用容器化的 iscsi 服务，该启动器将使用 TCP/IP 向 iSCSI target （网关）发送 SCSI 命令。