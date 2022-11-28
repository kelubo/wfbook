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
   
   ceph orch apply -i iscsi.yml
   ```

```c++
class ceph.deployment.service_spec.IscsiServiceSpec(service_type='iscsi', service_id=None, pool=None, trusted_ip_list=None, api_port=None, api_user=None, api_password=None, api_secure=None, ssl_cert=None, ssl_key=None, placement=None, unmanaged=False, preview_only=False, config=None, networks=None, extra_container_args=None, custom_configs=None)
```

- api_password

  `api_password` as defined in the `iscsi-gateway.cfg`

- api_port

  `api_port` as defined in the `iscsi-gateway.cfg`

- api_secure

  `api_secure` as defined in the `iscsi-gateway.cfg`

- api_user

  `api_user` as defined in the `iscsi-gateway.cfg`

- pool

  RADOS pool where ceph-iscsi config data is stored.

- ssl_cert

  SSL certificate

- ssl_key

  SSL private key

- trusted_ip_list

  list of trusted IP addresses

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



## Configuring iSCSI client

The containerized iscsi service can be used from any host by [Configuring the iSCSI Initiators](https://docs.ceph.com/en/latest/rbd/iscsi-initiators/#configuring-the-iscsi-initiators), which will use TCP/IP to send SCSI commands to the iSCSI target (gateway).

## 扩展阅读

- Ceph iSCSI Overview: [Ceph iSCSI Gateway](https://docs.ceph.com/en/latest/rbd/iscsi-overview/#ceph-iscsi)