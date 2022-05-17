# iSCSI Service

[TOC]

# 使用 Ceph 编排器管理 iSCSI 网关

​			作为存储管理员，您可以使用 Ceph 编排器部署 iSCSI 网关。iSCSI 网关提供高可用性(HA)iSCSI 目标，将 RADOS 块设备(RBD)镜像导出为 SCSI 磁盘。 	

​			您可以使用放置规范或服务规格（如 YAML 文件）来部署 iSCSI 网关。 	

# 使用命令行界面部署 iSCSI 网关

​				利用 Ceph 编排器，您可以在命令行界面中使用 `ceph orch` 命令来部署 iSCSI 网关。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						创建池： 				

   **语法**

   ​							

   ```none
   ceph osd pool create POOL_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph osd pool create mypool
   ```

3. ​						使用命令行界面部署 iSCSI 网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply iscsi POOLNAME admin admin --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2"
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch apply iscsi mypool admin admin --placement="1 host01"
   ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						列出主机和进程： 				

  **语法**

  ​							

  ```none
  ceph orch ps --daemon_type=DAEMON_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ps --daemon_type=iscsi
  ```



# 使用服务规格部署 iSCSI 网关

​				利用 Ceph 编排器，您可以使用服务规格部署 iSCSI 网关。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
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
   [ceph: root@host01 /]# cd /var/lib/ceph/iscsi/
   ```

   ​						注意：如果目录 'iscsi 不存在，请创建该目录。 				

3. ​						创建 `iscsi.yml` 文件： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 iscsi]# touch iscsi.yml
   ```

4. ​						编辑 `iscsi.yml` 文件，使其包含以下详情： 				

   **语法**

   ​							

   ```none
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
   ```

   **示例**

   ​							

   ```none
   service_type: iscsi
   service_id: iscsi
   placement:
     hosts:
       - host01
   spec:
     pool: mypool
   ```

5. ​						使用服务规格部署 iSCSI 网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply -i FILE_NAME.yml
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 iscsi]# ceph orch apply -i iscsi.yml
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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=iscsi
  ```



# 使用 Ceph 编排器删除 iSCSI 网关

​				您可以使用 `ceph 或ch rm` 命令删除 iSCSI 网关守护进程。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						主机上至少部署了一个 iSCSI 网关守护进程。 				

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
      [ceph: root@host01 /]# ceph orch rm iscsi.iscsi
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



## 部署 iSCSI

To deploy an iSCSI gateway, create a yaml file containing a service specification for iscsi:

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
```

For example:

```yaml
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

The specification can then be applied using:

```
ceph orch apply -i iscsi.yaml
```

See [Placement Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-placement-spec) for details of the placement specification.

