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
   touch iscsi.yml
   
   service_type: iscsi
   service_id: iscsi
   placement:
     hosts:
       - HOST_NAME_1
       - HOST_NAME_2
   spec:
     pool: POOL_NAME  # RADOS pool where ceph-iscsi config data is stored.
     trusted_ip_list: "IP_ADDRESS_1,IP_ADDRESS_2" # optional
     api_port: ... # optional
     api_user: API_USERNAME # optional
     api_password: API_PASSWORD # optional
     api_secure: true/false # optional
     ssl_cert: | # optional
     ...
     ssl_key: | # optional
     ...
   
   # eg_1
   service_type: iscsi
   service_id: iscsi
   placement:
     hosts:
       - host01
   spec:
     pool: mypool
     
   # eg_2
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
     api_secure: true
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
