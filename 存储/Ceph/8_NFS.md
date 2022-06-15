# NFS Service

[TOC]

作为存储管理员，您可以使用后端中带有 Cephadm 的 Orchestrator 来部署 NFS-Ganesha 网关。Cephadm 利用预定义的 RADOS 池和可选命名空间部署 NFS Ganesha。 	

> **Note:** 
>
> 只支持 NFSv4 。

The simplest way to manage NFS is via the `ceph nfs cluster ...` commands; see [CephFS & RGW Exports over NFS](https://docs.ceph.com/en/latest/mgr/nfs/#mgr-nfs).  This document covers how to manage the cephadm services directly, which should only be necessary for unusual NFS configurations.

## 部署NFS ganesha

Cephadm deploys NFS Ganesha daemon (or set of daemons).  The configuration for NFS is stored in the `nfs-ganesha` pool and exports are managed via the `ceph nfs export ...` commands and via the dashboard.

To deploy a NFS Ganesha gateway, run the following command:

```
ceph orch apply nfs *<svc_id>* [--port *<port>*] [--placement ...]
```

For example, to deploy NFS with a service id of *foo* on the default port 2049 with the default placement of a single daemon:

```
ceph orch apply nfs foo
```

See [Daemon Placement](https://docs.ceph.com/en/latest/cephadm/services/#orchestrator-cli-placement-spec) for the details of the placement specification.

# 使用 Ceph 编排器创建 NFS-Ganesha 集群

​				您可以使用 Ceph 编排器的 `mgr/nfs` 模块创建 NFS-Ganesha 集群。此模块使用 Cephadm 在后端部署 NFS 集群。 		

​				这会为所有 NFS-Ganesha 守护进程创建一个通用恢复池，基于 `clusterid` 的新用户，以及通用的 NFS-Ganesha 配置 RADOS 对象。 		

​				对于每个守护进程，池中会创建一个新用户和一个通用配置。虽然所有集群在集群名称上都有不同的命名空间，但它们使用相同的恢复池。 		

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

2. ​						启用 `mgr/nfs` 模块： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph mgr module enable nfs
   ```

3. ​						创建集群： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster create CLUSTER_NAME ["HOST_NAME_1_,HOST_NAME_2,HOST_NAME_3"]
   ```

   ​						The *CLUSTER_NAME* 是一个任意字符串，*HOST_NAME_1* 是一个可选字符串，表示主机要部署 NFS-Ganesha 守护进程。 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster create nfsganesha "host01, host02"
   ```

   ​						这会创建一个 NFS_Ganesha 群集 `nfsganesha`，并在 `host01 和 host` `02` 上有一个守护进程。 				

**验证**

- ​						列出集群详情： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster ls
  ```

- ​						显示 NFS-Ganesha 集群信息： 				

  **语法**

  ​							

  ```none
  ceph nfs cluster info CLUSTER_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster info nfsganesha
  ```

# 使用命令行界面部署 NFS-Ganesha 网关

​				您可以在后端将 Ceph 编排器与 Cephadm 搭配使用，以按照放置规范部署 NFS-Ganesha 网关。在这种情形中，您必须创建 RADOS 池，并在部署网关之前创建命名空间。 		

注意

​					红帽支持仅通过 NFS v4.0+ 协议进行 CephFS 导出。 			

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

2. ​						创建 RADOS 池命名空间，并启用应用： 				

   **语法**

   ​							

   ```none
   ceph osd pool create POOL_NAME _
   ceph osd pool application enable POOL_NAME freeform/rgw/rbd/cephfs/nfs
   rbd pool init -p POOL_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph osd pool create nfs-ganesha
   [ceph: root@host01 /]# ceph osd pool application enable nfs-ganesha nfs
   [ceph: root@host01 /]# rbd pool init -p nfs-ganesha
   ```

3. ​						使用命令行界面中的放置规格部署 NFS-Ganesha 网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply nfs SERVICE_ID --pool POOL_NAME --namespace NAMESPACE --placement="NUMBER_OF_DAEMONS HOST_NAME_1 HOST_NAME_2 HOST_NAME_3"
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch apply nfs foo --pool nfs-ganesha --namespace nfs-ns --placement="2 host01 host02"
   ```

   ​						这将通过 `host01 和 host` `02` 上的一个守护进程部署 NFS-Ganesha 群集 `nfsganesha`。 				

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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```

# 使用服务规格部署 NFS-Ganesha 网关

​				您可以在后端将 Ceph 编排器与 Cephadm 搭配使用，以按照服务规格部署 NFS-Ganesha 网关。在这种情形中，您必须创建 RADOS 池，并在部署网关之前创建命名空间。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						创建 RADOS 池、命名空间并启用 RBD： 				

   **语法**

   ​							

   ```none
   ceph osd pool create POOL_NAME _
   ceph osd pool application enable POOL_NAME rbd
   rbd pool init -p POOL_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph osd pool create nfs-ganesha
   [ceph: root@host01 /]#ceph osd pool application enable nfs-ganesha rbd
   [ceph: root@host01 /]#rbd pool init -p nfs-ganesha
   ```

3. ​						进入以下目录： 				

   **语法**

   ​							

   ```none
   cd /var/lib/ceph/DAEMON_PATH/
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs/]# cd /var/lib/ceph/nfs/
   ```

   ​						如果 `nfs` 目录不存在，请在路径中创建目录。 				

4. ​						创建 `nfs.yml` 文件： 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs]# touch nfs.yml
   ```

5. ​						编辑 `nfs.yml` 文件，使其包含以下详情： 				

   **语法**

   ​							

   ```none
   service_type: nfs
   service_id: SERVICE_ID
   placement:
     hosts:
       - HOST_NAME_1
       - HOST_NAME_2
   spec:
     pool: POOL_NAME
     namespace: NAMESPACE
   ```

   **示例**

   ​							

   ```none
   service_type: nfs
   service_id: foo
   placement:
     hosts:
       - host01
       - host02
   spec:
     pool: nfs-ganesha
     namespace: nfs-ns
   ```

6. ​						使用服务规格部署 NFS-Ganesha 网关： 				

   **语法**

   ​							

   ```none
   ceph orch apply -i FILE_NAME.yml
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs]# ceph orch apply -i nfs.yml
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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```



# 使用 Ceph 编排器更新 NFS-Ganesha 集群

​				您可以使用后端中的 Ceph 编排器更改主机上的守护进程放置来更新 NFS-Ganesha 集群。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						更新集群： 				

   **语法**

   ​							

   ```none
   ceph orch apply nfs CLUSTER_NAME ["HOST_NAME_1,HOST_NAME_2,HOST_NAME_3"]
   ```

   ​						The *CLUSTER_NAME* 是一个任意字符串，*HOST_NAME_1* 是一个可选字符串，表示主机更新所部署的 NFS-Ganesha 守护进程。 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch apply nfs nfsganesha "host02"
   ```

   ​						这将更新 `host02` 上的 `nfsganesha` 集群。 				

**验证**

- ​						列出集群详情： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster ls
  ```

- ​						显示 NFS-Ganesha 集群信息： 				

  **语法**

  ​							

  ```none
  ceph nfs cluster info CLUSTER_NAME
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster info nfsganesha
  ```

- ​						列出主机、守护进程和进程：+ 				

**语法**

​					

```none
ceph orch ps --daemon_type=DAEMON_NAME
```

​				+ .Example 		

```none
[ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
```



# 使用 Ceph 编排器查看 NFS-Ganesha 集群信息

​				您可以使用 Ceph 编排器查看 NFS-Ganesha 集群的信息。您可以使用其端口、IP 地址以及创建集群的主机名称来获取有关所有 NFS Ganesha 集群或特定集群的信息。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						查看 NFS-Ganesha 集群信息： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster info CLUSTER_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster info nfsganesha
   
   {
       "nfsganesha": [
           {
               "hostname": "host02",
               "ip": [
                   "10.74.251.164"
               ],
               "port": 2049
           }
       ]
   }
   ```



# 使用 Ceph 编排器获取 NFS-Ganesha clutser 日志

​				利用 Ceph 编排器，您可以获取 NFS-Ganesha 集群日志。您需要处于部署该服务的节点。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						Cephadm 安装在部署了 NFS 的节点上。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						以 root 用户身份，获取存储集群的 *FSID* ： 				

   **示例**

   ​							

   ```none
   [root@host03 ~]# cephadm ls
   ```

   ​						复制 *FSID* 和服务的名称。 				

2. ​						获取日志： 				

   **语法**

   ​							

   ```none
   cephadm logs --fsid FSID --name SERVICE_NAME
   ```

   **示例**

   ​							

   ```none
   [root@host03 ~]# cephadm logs --fsid 499829b4-832f-11eb-8d6d-001a4a000635 --name nfs.foo.host03
   ```



# 使用 Ceph 编排器设置自定义 NFS-Ganesha 配置

​				NFS-Ganesha 集群在默认配置块中定义。利用 Ceph 编排器，您可以自定义配置，它们优先于默认配置块。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						以下是 NFS-Ganesha 集群默认配置的示例： 				

   **示例**

   ​							

   ```none
   # {{ cephadm_managed }}
   NFS_CORE_PARAM {
           Enable_NLM = false;
           Enable_RQUOTA = false;
           Protocols = 4;
   }
   
   MDCACHE {
           Dir_Chunk = 0;
   }
   
   EXPORT_DEFAULTS {
           Attr_Expiration_Time = 0;
   }
   
   NFSv4 {
           Delegations = false;
           RecoveryBackend = 'rados_cluster';
           Minor_Versions = 1, 2;
   }
   
   RADOS_KV {
           UserId = "{{ user }}";
           nodeid = "{{ nodeid}}";
           pool = "{{ pool }}";
           namespace = "{{ namespace }}";
   }
   
   RADOS_URLS {
           UserId = "{{ user }}";
           watch_url = "{{ url }}";
   }
   
   RGW {
           cluster = "ceph";
           name = "client.{{ rgw_user }}";
   }
   
   %url    {{ url }}
   ```

3. ​						自定义 NFS-Ganesha 集群配置。以下是自定义配置的两个示例： 				

   - ​								更改日志级别： 						

     **示例**

     ​									

     ```none
     LOG {
      COMPONENTS {
          ALL = FULL_DEBUG;
      }
     }
     ```

   - ​								添加自定义导出块： 						

     1. ​										创建 用户。 								

        注意

        ​											在 FSAL 块中指定的用户应当具有正确的 NFS-Ganesha 守护进程，以访问 Ceph 集群。 									

        **语法**

        ​											

        ```none
        ceph auth get-or-create client.USER_NAME mon 'allow r' osd 'allow rw pool=POOL_NAME namespace=NFS_CLUSTER_NAME, allow rw tag cephfs data=FILE_SYSTEM_NAME' mds 'allow rw path=EXPORT_PATH'
        ```

        **示例**

        ​											

        ```none
        [ceph: root@host01 /]# ceph auth get-or-create client.nfstest1 mon 'allow r' osd 'allow rw pool=nfsganesha namespace=nfs_cluster_name, allow rw tag cephfs data=filesystem_name' mds 'allow rw path=export_path
        ```

     2. ​										进入以下目录： 								

        **语法**

        ​											

        ```none
        cd /var/lib/ceph/DAEMON_PATH/
        ```

        **示例**

        ​											

        ```none
        [ceph: root@host01 /]# cd /var/lib/ceph/nfs/
        ```

        ​										如果 `nfs` 目录不存在，请在路径中创建目录。 								

     3. ​										创建新配置文件： 								

        **语法**

        ​											

        ```none
        touch PATH_TO_CONFIG_FILE
        ```

        **示例**

        ​											

        ```none
        [ceph: root@host01 nfs]#  touch nfs-ganesha.conf
        ```

     4. ​										通过添加自定义导出块来编辑 配置文件。它创建一个导出，它由 Ceph NFS 导出接口管理。 								

        **语法**

        ​											

        ```none
        EXPORT {
          Export_Id = NUMERICAL_ID;
          Transports = TCP;
          Path = PATH_WITHIN_CEPHFS;
          Pseudo = BINDING;
          Protocols = 4;
          Access_Type = PERMISSIONS;
          Attr_Expiration_Time = 0;
          Squash = None;
          FSAL {
            Name = CEPH;
            Filesystem = "FILE_SYSTEM_NAME";
            User_Id = "USER_NAME";
            Secret_Access_Key = "USER_SECRET_KEY";
          }
        }
        ```

        **示例**

        ​											

        ```none
        EXPORT {
          Export_Id = 100;
          Transports = TCP;
          Path = /;
          Pseudo = /ceph/;
          Protocols = 4;
          Access_Type = RW;
          Attr_Expiration_Time = 0;
          Squash = None;
          FSAL {
            Name = CEPH;
            Filesystem = "filesystem name";
            User_Id = "user id";
            Secret_Access_Key = "secret key";
          }
        }
        ```

4. ​						应用集群的新配置： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster config set _CLUSTER_NAME_ -i _PATH_TO_CONFIG_FILE_
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 nfs]# ceph nfs cluster config set nfs-ganesha -i /root/nfs-ganesha.conf
   ```

   ​						这也会重启自定义配置的服务。 				

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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```

- ​						验证自定义配置： 				

  **语法**

  ​							

  ```none
  ./bin/rados -p POOL_NAME -N CLUSTER_NAME get userconf-nfs.CLUSTER_NAME -
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ./bin/rados -p nfs-ganesha -N nfsganesha get userconf-nfs.nfsganesha -
  ```

**其它资源**

- ​						如需更多信息，*请参阅红帽 Ceph 存储操作指南* [*中的使用 Ceph 编排器重置自定义 NFS-Ganesha 配置*](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html-single/operations_guide/#resetting-custom-nfs-ganesha-configuration-using-the-ceph-orchestrator_ops) 一节。 				

​                    [           Previous         ](https://access.redhat.com/documentation/zh-cn/red_hat_ceph_storage/5/html/operations_guide/fetching-the-nfs-ganesha-cluster-logs-using-the-ceph-orchestrator_ops)                                [           Next         ](https://access.redhat.com/documentation/zh-cn/red_hat_ceph_storage/5/html/operations_guide/resetting-custom-nfs-ganesha-configuration-using-the-ceph-orchestrator_ops)            



# 使用 Ceph 编排器重置自定义 NFS-Ganesha 配置

​				利用 Ceph 编排器，您可以将用户定义的配置重置为默认配置。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块部署的 NFS-Ganesha。 				
- ​						自定义 NFS 集群配置已设置 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						重置 NFS_Ganesha 配置： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster config reset CLUSTER_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster config reset nfsganesha
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
  [ceph: root@host01 /]# ceph orch ps --daemon_type=nfs
  ```

- ​						验证自定义配置是否已删除： 				

  **语法**

  ​							

  ```none
  ./bin/rados -p POOL_NAME -N CLUSTER_NAME get userconf-nfs.CLUSTER_NAME -
  ```

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ./bin/rados -p nfs-ganesha -N nfsganesha get userconf-nfs.nfsganesha -
  ```

**其它资源**

- ​						如需更多信息 [*，\*请参阅红帽 Ceph 存储操作指南\* 中的使用 Ceph 编排器创建 NFS-Ganesha 集群*](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html-single/operations_guide/#creating-the-nfs-ganesha-cluster-using-the-ceph-orchestrator_ops) 章节。 				
- ​						如需更多信息，*请参阅红帽 Ceph 存储操作指南* [*中的使用 Ceph 编排器设置自定义 NFS-Ganesha 配置*](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html-single/operations_guide/#setting-custom-nfs-ganesha-configuration-using-the-ceph-orchestrator_ops) 一节。 				



# 使用 Ceph 编排器删除 NFS-Ganesha 集群

​				您可以在后端将 Ceph 编排器与 Cephadm 搭配使用，以删除 NFS-Ganesha 集群。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						主机添加到集群中。 				
- ​						部署所有管理器、监控器和 OSD 守护进程。 				
- ​						使用 `mgr/nfs` 模块创建的 NFS-Ganesha 群集. 				

**流程**

1. ​						登录到 Cephadm shell： 				

   **示例**

   ​							

   ```none
   [root@host01 ~]# cephadm shell
   ```

2. ​						删除集群： 				

   **语法**

   ​							

   ```none
   ceph nfs cluster delete CLUSTER_NAME
   ```

   ​						The *CLUSTER_NAME* 是一个任意字符串。 				

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph nfs cluster delete nfsganesha
   NFS Cluster Deleted Successfully
   ```

**验证**

- ​						列出集群详情： 				

  **示例**

  ​							

  ```none
  [ceph: root@host01 /]# ceph nfs cluster ls
  ```



# 使用 Ceph 编排器删除 NFS-Ganesha 网关

​				您可以使用 `ceph 或ch rm` 命令删除 NFS-Ganesha 网关。 		

**先决条件**

- ​						一个正在运行的 Red Hat Ceph Storage 集群。 				
- ​						所有节点的根级别访问权限。 				
- ​						主机添加到集群中。 				
- ​						主机上至少部署了一个 NFS-Ganesha 网关。 				

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

3. ​						删除服务 				

   **语法**

   ​							

   ```none
   ceph orch rm SERVICE_NAME
   ```

   **示例**

   ​							

   ```none
   [ceph: root@host01 /]# ceph orch rm nfs.foo
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





Cephadm deploys NFS Ganesha using a pre-defined RADOS *pool* and optional *namespace*

To deploy a NFS Ganesha gateway, run the following command:

```
ceph orch apply nfs *<svc_id>* *<pool>* *<namespace>* --placement="*<num-daemons>* [*<host1>* ...]"
```

For example, to deploy NFS with a service id of *foo*, that will use the RADOS pool *nfs-ganesha* and namespace *nfs-ns*:

```
ceph orch apply nfs foo nfs-ganesha nfs-ns
```

Note

Create the *nfs-ganesha* pool first if it doesn’t exist.

See [Placement Specification](https://docs.ceph.com/en/latest/cephadm/service-management/#orchestrator-cli-placement-spec) for details of the placement specification.

## Service Specification

Alternatively, an NFS service can also be applied using a YAML specification.

```yaml
service_type: nfs
service_id: mynfs
placement:
  hosts:
    - host1
    - host2
spec:
  port: 12345
```

In this example, we run the server on the non-default `port` of 12345 (instead of the default 2049) on `host1` and `host2`.

The specification can then be applied by running the following command:

```bash
ceph orch apply -i nfs.yaml
```

## High-availability NFS

Deploying an *ingress* service for an existing *nfs* service will provide:

- a stable, virtual IP that can be used to access the NFS server
- fail-over between hosts if there is a host failure
- load distribution across multiple NFS gateways (although this is rarely necessary)

Ingress for NFS can be deployed for an existing NFS service (`nfs.mynfs` in this example) with the following specification:

```
service_type: ingress
service_id: nfs.mynfs
placement:
  count: 2
spec:
  backend_service: nfs.mynfs
  frontend_port: 2049
  monitor_port: 9000
  virtual_ip: 10.0.0.123/24
```

A few notes:

> - The *virtual_ip* must include a CIDR prefix length, as in the example above.  The virtual IP will normally be configured on the first identified network interface that has an existing IP in the same subnet.  You can also specify a *virtual_interface_networks* property to match against IPs in other networks; see [Selecting ethernet interfaces for the virtual IP](https://docs.ceph.com/en/latest/cephadm/services/rgw/#ingress-virtual-ip) for more information.
>
> - The *monitor_port* is used to access the haproxy load status page.  The user is `admin` by default, but can be modified by via an *admin* property in the spec.  If a password is not specified via a *password* property in the spec, the auto-generated password can be found with:
>
>   ```
>   ceph config-key get mgr/cephadm/ingress.*{svc_id}*/monitor_password
>   ```
>
>   For example:
>
>   ```
>   ceph config-key get mgr/cephadm/ingress.nfs.myfoo/monitor_password
>   ```
>
> - The backend service (`nfs.mynfs` in this example) should include a *port* property that is not 2049 to avoid conflicting with the ingress service, which could be placed on the same host(s).

## Further Reading

- CephFS: [NFS](https://docs.ceph.com/en/latest/cephfs/nfs/#cephfs-nfs)
- MGR: [CephFS & RGW Exports over NFS](https://docs.ceph.com/en/latest/mgr/nfs/#mgr-nfs)

# NFS[](https://docs.ceph.com/en/latest/cephfs/nfs/#nfs)

CephFS namespaces can be exported over NFS protocol using the [NFS-Ganesha NFS server](https://github.com/nfs-ganesha/nfs-ganesha/wiki).  This document provides information on configuring NFS-Ganesha clusters manually.  The simplest and preferred way of managing NFS-Ganesha clusters and CephFS exports is using `ceph nfs ...` commands. See [CephFS & RGW Exports over NFS](https://docs.ceph.com/en/latest/mgr/nfs/) for more details. As the deployment is done using cephadm or rook.

## Requirements[](https://docs.ceph.com/en/latest/cephfs/nfs/#requirements)

- Ceph file system
- `libcephfs2`, `nfs-ganesha` and `nfs-ganesha-ceph` packages on NFS server host machine.
- NFS-Ganesha server host connected to the Ceph public network

Note

It is recommended to use 3.5 or later stable version of NFS-Ganesha packages with pacific (16.2.x) or later stable version of Ceph packages.

## Configuring NFS-Ganesha to export CephFS[](https://docs.ceph.com/en/latest/cephfs/nfs/#configuring-nfs-ganesha-to-export-cephfs)

NFS-Ganesha provides a File System Abstraction Layer (FSAL) to plug in different storage backends. [FSAL_CEPH](https://github.com/nfs-ganesha/nfs-ganesha/tree/next/src/FSAL/FSAL_CEPH) is the plugin FSAL for CephFS. For each NFS-Ganesha export, [FSAL_CEPH](https://github.com/nfs-ganesha/nfs-ganesha/tree/next/src/FSAL/FSAL_CEPH) uses a libcephfs client to mount the CephFS path that NFS-Ganesha exports.

Setting up NFS-Ganesha with CephFS, involves setting up NFS-Ganesha’s and Ceph’s configuration file and CephX access credentials for the Ceph clients created by NFS-Ganesha to access CephFS.

### NFS-Ganesha configuration[](https://docs.ceph.com/en/latest/cephfs/nfs/#nfs-ganesha-configuration)

Here’s a [sample ganesha.conf](https://github.com/nfs-ganesha/nfs-ganesha/blob/next/src/config_samples/ceph.conf) configured with [FSAL_CEPH](https://github.com/nfs-ganesha/nfs-ganesha/tree/next/src/FSAL/FSAL_CEPH). It is suitable for a standalone NFS-Ganesha server, or an active/passive configuration of NFS-Ganesha servers, to be managed by some sort of clustering software (e.g., Pacemaker). Important details about the options are added as comments in the sample conf. There are options to do the following:

- minimize Ganesha caching wherever possible since the libcephfs clients (of [FSAL_CEPH](https://github.com/nfs-ganesha/nfs-ganesha/tree/next/src/FSAL/FSAL_CEPH)) also cache aggressively
- read from Ganesha config files stored in RADOS objects
- store client recovery data in RADOS OMAP key-value interface
- mandate NFSv4.1+ access
- enable read delegations (need at least v13.0.1 `libcephfs2` package and v2.6.0 stable `nfs-ganesha` and `nfs-ganesha-ceph` packages)

### Configuration for libcephfs clients[](https://docs.ceph.com/en/latest/cephfs/nfs/#configuration-for-libcephfs-clients)

`ceph.conf` for libcephfs clients includes a `[client]` section with `mon_host` option set to let the clients connect to the Ceph cluster’s monitors, usually generated via `ceph config generate-minimal-conf`. For example:

```
[client]
        mon host = [v2:192.168.1.7:3300,v1:192.168.1.7:6789], [v2:192.168.1.8:3300,v1:192.168.1.8:6789], [v2:192.168.1.9:3300,v1:192.168.1.9:6789]
```

## Mount using NFSv4 clients[](https://docs.ceph.com/en/latest/cephfs/nfs/#mount-using-nfsv4-clients)

It is preferred to mount the NFS-Ganesha exports using NFSv4.1+ protocols to get the benefit of sessions.

Conventions for mounting NFS resources are platform-specific. The following conventions work on Linux and some Unix platforms:

```
mount -t nfs -o nfsvers=4.1,proto=tcp <ganesha-host-name>:<ganesha-pseudo-path> <mount-point>
```