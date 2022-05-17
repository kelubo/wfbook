# MDS

[TOC]

作为存储管理员，您可以在后端使用 Ceph 编排器和 Cephadm 来部署 MDS 服务。默认情况下，Ceph 文件系统(CephFS)仅使用一个活跃的 MDS 守护进程。但是，具有许多客户端的系统得益于多个活跃的 MDS 守护进程。 	

# 使用命令行界面部署 MDS 服务

​				利用 Ceph 编排器，您可以使用命令行界面 Ceph 文件系统(CephFS)中的 `放置` 规范部署元数据服务器(MDS)服务，需要一个或多个 MDS。 		

注意

​					确保您至少有两个池，一个用于 Ceph 文件系统(CephFS)数据，另一个用于 CephFS 元数据。 			

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

2. ​						使用放置规格部署 MDS 守护进程的方法有两种： 				

**方法 1**

- ​						使用 `ceph fs 卷` 创建 MDS 守护进程。这将创建 CephFS 卷和与 CephFS 关联的池，并在主机上启动 MDS 服务。 				

  **语法**

  ​							

  ```none
  ceph fs volume create FILESYSTEM_NAME --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"
  ```

  注意

  ​							默认情况下，为此命令创建复制池。 					

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph fs volume create test --placement="2 host01 host02"
  ```

**方法 2**

- ​						创建池 CephFS，然后使用放置规范部署 MDS 服务： 				

  1. ​								为 CephFS 创建池： 						

     **语法**

     ​									

     ```none
     ceph osd pool create DATA_POOL
     ceph osd pool create METADATA_POOL
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph osd pool create cephfs_data
     [ceph: root@host01 /]# ceph osd pool create cephfs_metadata
     ```

  2. ​								为数据池和元数据池创建文件系统： 						

     **语法**

     ​									

     ```none
     ceph fs new FILESYSTEM_NAME DATA_POOL_ METADATA_POOL
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph fs new test cephfs_data cephfs_metadata
     ```

  3. ​								使用 `ceph 或ch apply` 命令部署 MDS 服务： 						

     **语法**

     ​									

     ```none
     ceph orch apply mds FILESYSTEM_NAME --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph orch apply mds test --placement="2 host01 host02"
     ```

**验证**

- ​						列出服务： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph orch ls
  ```

- ​						检查 CephFS 状态： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph fs ls
  [ceph: root@host01 /]# ceph fs status
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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=mds
  ```

# 使用服务规格部署 MDS 服务

​				利用 Ceph 编排器，您可以使用服务规格部署 MDS 服务。 		

注意

​					确保您至少有两个池，一个用于 Ceph 文件系统(CephFS)数据，另一个用于 CephFS 元数据。 			

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]#cephadm shell
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
   [ceph: root@host01 mds]# cd /var/lib/ceph/mds/
   ```

   注意

   ​							如果 directory `mds` 不存在，请创建 目录。 					

3. ​						创建 `sds.yml` 文件： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 mds/]# touch mds.yml
   ```

4. ​						编辑 `sds.yml` 文件，使其包含以下详情： 				

   **语法**

   ​							

   ```none
   service_type: mds
   service_id: FILESYSTEM_NAME
   placement:
     hosts:
     - HOST_NAME_1
     - HOST_NAME_2
     - HOST_NAME_3
   ```

   **示例**

   ​							

   ```none
   service_type: mds
   service_id: fs_name
   placement:
     hosts:
     - host01
     - host02
   ```

5. ​						使用服务规格部署 MDS 服务： 				

   **语法**

   ​							

   ```none
   ceph orch apply -i FILE_NAME.yml
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 mds]# ceph orch apply -i mds.yml
   ```

6. ​						部署和运行 MDS 服务后，创建 CephFS： 				

   **语法**

   ​							

   ```none
   ceph fs new CEPHFS_NAME METADATA_POOL DATA_POOL
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph fs new test metadata_pool data_pool
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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=mds
  ```

# 使用 Ceph 编排器移除 MDS 服务

​				您可以使用 `ceph orch rm` 命令删除服务。或者，您可以删除文件系统和关联的池。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						主机上至少部署了一个 MDS 守护进程。 				

**流程**

1. ​						从集群中移除 MDS 守护进程的方法有两种： 				

**方法 1**

- ​						移除 CephFS 卷、关联的池和服务： 				

  1. ​								登录到 Cephadm shell： 						

     **示例**

     ​									

     ```none
     [root@host01 ~]# cephadm shell
     ```

  2. ​								将配置参数 `mon_allow_pool_delete` 设置为 `true` ： 						

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph config set mon mon_allow_pool_delete true
     ```

  3. ​								删除文件系统： 						

     **语法**

     ​									

     ```none
     ceph fs volume rm FILESYSTEM_NAME --yes-i-really-mean-it
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph fs volume rm cephfs-new --yes-i-really-mean-it
     ```

     ​								此命令将删除文件系统、数据和元数据池。它还尝试使用已启用的 `ceph-mgr` Orchestrator 模块来移除 MDS。 						

**方法 2**

- ​						使用 `ceph 或ch rm` 命令从整个集群中删除 MDS 服务： 				

  1. ​								列出服务： 						

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph orch ls
     ```

  2. ​								删除服务 						

     **语法**

     ​									

     ```none
     ceph orch rm SERVICE_NAME
     ```

     **示例**

     ​									

     ```none
     [ceph: root@host01 /]# ceph orch rm mds.test
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



## 部署CephFS

使用 CephFS 文件系统需要一个或多个 MDS 守护进程。如果使用较新的 `ceph fs volume` 接口创建新的文件系统，则会自动创建这些卷。

例如：

```bash
ceph fs volume create <fs_name> --placement="<placement spec>"
```
对于手动部署MDS守护程序，请使用以下规范：

```yaml
service_type: mds
service_id: fs_name
placement:
  count: 3
```

然后可使用以下方法应用本规范：

```bash
ceph orch apply -i mds.yaml
```
