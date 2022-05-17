# MDS

[TOC]

## 概述

使用 CephFS 文件系统需要一个或多个 MDS 守护进程。默认情况下，CephFS 仅使用一个活跃的 MDS 守护进程。

## 部署 MDS 服务

**注意：**

确保您至少有两个池，一个用于 CephFS 数据，另一个用于 CephFS 元数据。

### 使用命令行界面

使用放置规格部署 MDS 守护进程的方法有两种： 				

**方法 1**

使用 `ceph fs volume ` 创建 MDS 守护进程。这将创建 CephFS 卷和与 CephFS 关联的池，并在主机上启动 MDS 服务。如果使用较新的 `ceph fs volume` 接口创建新的文件系统，则会自动创建这些卷。

```bash
ceph fs volume create FILESYSTEM_NAME --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"

ceph fs volume create test --placement="2 host01 host02"
```

**注意:**默认情况下，此命令创建复制池。

**方法 2**

创建池 CephFS，然后使用放置规范部署 MDS 服务： 				

1. 为 CephFS 创建池：

   ```bash
   ceph osd pool create DATA_POOL
   ceph osd pool create METADATA_POOL
        
   ceph osd pool create cephfs_data
   ceph osd pool create cephfs_metadata
   ```

  2. 为数据池和元数据池创建文件系统：

     ```bash
     ceph fs new FILESYSTEM_NAME DATA_POOL_ METADATA_POOL
     
     ceph fs new test cephfs_data cephfs_metadata
     ```

  3. 使用 `ceph 或ch apply` 命令部署 MDS 服务：

     ```bash
     ceph orch apply mds FILESYSTEM_NAME --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"
     
     ceph orch apply mds test --placement="2 host01 host02"
     ```


**验证**

- 列出服务：

  ```bash
  ceph orch ls
  ```

- 检查 CephFS 状态：

  ```bash
ceph fs ls
  ceph fs status
  ```
  
- 列出主机、守护进程和进程：

  ```bash
ceph orch ps --daemon_type=DAEMON_NAME
    
  ceph orch ps --daemon_type=mds
  ```

### 使用服务规格

1. 编辑 `sds.yml` 文件，使其包含以下详情：

   ```yaml
   service_type: mds
   service_id: FILESYSTEM_NAME
   placement:
     hosts:
     - HOST_NAME_1
     - HOST_NAME_2
     - HOST_NAME_3
     
   service_type: mds
   service_id: fs_name
   placement:
     hosts:
     - host01
     - host02
     
   service_type: mds
   service_id: fs_name
   placement:
     count: 3
   ```

2. 使用服务规格部署 MDS 服务：

   ```bash
   ceph orch apply -i FILE_NAME.yml
   
   ceph orch apply -i mds.yml
   ```

6. 部署和运行 MDS 服务后，创建 CephFS：

   ```bash
ceph fs new CEPHFS_NAME METADATA_POOL DATA_POOL
   
   ceph fs new test metadata_pool data_pool
   ```

## 移除 MDS 服务

可以使用 `ceph orch rm` 命令删除服务。或者，可以删除文件系统和关联的池。

从集群中移除 MDS 守护进程的方法有两种： 				

**方法 1**

移除 CephFS 卷、关联的池和服务：

1. 将配置参数 `mon_allow_pool_delete` 设置为 `true` ：

   ```bash
   ceph config set mon mon_allow_pool_delete true
   ```

2. 删除文件系统：

   ```none
   ceph fs volume rm FILESYSTEM_NAME --yes-i-really-mean-it
   
   ceph fs volume rm cephfs-new --yes-i-really-mean-it
   ```

   此命令将删除文件系统、数据和元数据池。它还尝试使用已启用的 `ceph-mgr` Orchestrator 模块来移除 MDS。 						

**方法 2**

使用 `ceph 或ch rm` 命令从整个集群中删除 MDS 服务： 				

1. 列出服务：					

   ```none
ceph orch ls
   ```

2. 删除服务:	

   ```none
ceph orch rm SERVICE_NAME
   
   ceph orch rm mds.test
   ```
