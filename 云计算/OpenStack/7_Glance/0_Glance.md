# 镜像服务 Glance

[TOC]

## 概述

镜像服务 （glance） 使用户能够发现、注册和检索虚拟机镜像。它提供了一个 REST  API，使能够查询虚拟机镜像 metadata 并检索实际镜像。可以将通过镜像服务提供的虚拟机镜像存储在各种位置，从简单的文件系统到对象存储系统（如  OpenStack 对象存储）。

> 重要:
>
> which uploads and stores in a directory on the controller node hosting the Image service. 
>
> 为简单起见，本指南介绍如何配置镜像服务以使用 `file` 后端，上传并存储在托管镜像服务的控制器节点上的目录中。默认情况下，此目录为 `/var/lib/glance/images/` 。
>
> 在继续操作之前，请确保控制器节点在此目录中至少有几 GB 的可用空间。请记住，由于后端通常是控制器节点的本地端 `file` ，因此它通常不适合多节点概览部署。

OpenStack Image 服务是基础架构即服务 （IaaS） 的核心。It accepts API requests for disk or server images, and metadata definitions from end users or OpenStack Compute components.它接受来自最终用户或 OpenStack Compute  组件的磁盘或服务器映像以及元数据定义的 API 请求。它还支持在各种存储库类型（包括 OpenStack 对象存储）上存储磁盘或服务器映像。

A number of periodic processes run on the OpenStack Image service to support caching. Replication services ensure consistency and availability through the cluster. Other periodic processes include auditors, updaters, and reapers.
许多定期进程在 OpenStack Image 服务上运行以支持缓存。复制服务可确保整个群集的一致性和可用性。其他定期流程包括审计员、更新者和收割者。

大量周期性进程运行于 OpenStack 镜像服务上以支持缓存。同步复制（Replication）服务保证集群中的一致性和可用性。其它周期性进程包括 auditors, updaters 和 reapers。

包括以下组件：

- glance-api

  接收镜像 API 的调用，诸如镜像发现、恢复、存储。

  > Note 注意
  >
  > An OpenStack Community Goal in the Pike release was [Control Plane API endpoints deployment via WSGI](https://governance.openstack.org/tc/goals/pike/deploy-api-in-wsgi.html).  As currently constituted, however, glance-api is **not suitable** to be run in such a configuration.  Instead we recommend that Glance be run in the traditional manner as a standalone server.  See the “Known Issues” section of the [Glance Release Notes](https://docs.openstack.org/releasenotes/glance/index.html) for the Pike and Queens releases for more information.
  > Pike 版本中的 OpenStack 社区目标是通过 WSGI 部署控制平面 API 端点。然而，按照目前的构成，glance-api  不适合在这样的配置中运行。相反，我们建议以 Glance 作为独立服务器以传统方式运行。有关详细信息，请参阅 Pike 和 Queens 版本的 Glance 发行说明的“已知问题”部分。

- 数据库

  存放镜像元数据，可以依据个人喜好选择数据库，多数的部署使用 MySQL 或 SQLite 。

- 镜像文件的存储仓库

  支持多种存储库类型，包括普通文件系统（或挂载在 glance-api 控制器节点上的任何文件系统）、对象存储、RADOS 块设备、VMware 数据存储和 HTTP。请注意，某些存储库仅支持只读使用。

- 元数据定义服务

  A common API for vendors, admins, services, and users to meaningfully define their own custom metadata. This metadata can be used on different types of resources like images, artifacts, volumes, flavors, and aggregates. A definition includes the new property’s key, description, constraints, and the resource types which it can be associated with.
  供应商、管理员、服务和用户的通用 API，用于有意义地定义自己的自定义元数据。此元数据可用于不同类型的资源，例如映像、项目、卷、特定实例和聚合。定义包括新属性的键、说明、约束以及可以与之关联的资源类型。

  通用的 API，是用于为厂商，管理员，服务，以及用户自定义元数据。这种元数据可用于不同的资源，例如镜像，工件，卷，配额以及集合。一个定义包括了新属性的键，描述，约束以及可以与之关联的资源的类型。



## About Glance 关于 Glance ¶

The Image service (glance) project provides a service where users can upload and discover data assets that are meant to be used with other services. This currently includes *images* and *metadata definitions*.
影像服务 （glance） 项目提供了一项服务，用户可以在其中上传和发现要与其他服务一起使用的数据资产。这目前包括图像和元数据定义。

### Images 图片 ¶

Glance image services include discovering, registering, and retrieving virtual machine (VM) images. Glance has a RESTful API that allows querying of VM image metadata as well as retrieval of the actual image.
Glance 映像服务包括发现、注册和检索虚拟机 （VM） 映像。Glance 有一个 RESTful API，允许查询 VM 映像元数据以及检索实际映像。



 

Note 注意



The Images API v1, DEPRECATED in the Newton release, has been removed.
在 Newton 版本中已弃用的映像 API v1 已被删除。

VM images made available through Glance can be stored in a variety of locations from simple filesystems to object-storage systems like the OpenStack Swift project.
通过 Glance 提供的虚拟机映像可以存储在各种位置，从简单的文件系统到对象存储系统（如 OpenStack Swift 项目）。

### Metadata Definitions 元数据定义 ¶

Glance hosts a *metadefs* catalog.  This provides the OpenStack community with a way to programmatically determine various metadata key names and valid values that can be applied to OpenStack resources.
Glance 托管一个 metadefs 目录。这为 OpenStack 社区提供了一种以编程方式确定可应用于 OpenStack 资源的各种元数据键名和有效值的方法。

Note that what we’re talking about here is simply a *catalog*; the keys and values don’t actually do anything unless they are applied to individual OpenStack resources using the APIs or client tools provided by the services responsible for those resources.
请注意，我们在这里谈论的只是一个目录;键和值实际上不会执行任何操作，除非它们使用负责这些资源的服务提供的 API 或客户端工具应用于单个 OpenStack 资源。

It’s also worth noting that there is no special relationship between the Image Service and the Metadefs Service.  If you want to apply the keys and values defined in the Metadefs Service to images, you must use the Image Service API or client tools just as you would for any other OpenStack service.
还值得注意的是，Image Service 和 Metadefs Service 之间没有特殊关系。如果要将 Metadefs 服务中定义的键和值应用于图像，则必须像使用任何其他 OpenStack 服务一样使用图像服务 API 或客户端工具。

### Design Principles 设计原则 ¶

Glance, as with all OpenStack projects, is written with the following design guidelines in mind:
与所有 OpenStack 项目一样，Glance 在编写时考虑了以下设计准则：

- **Component based architecture**: Quickly add new behaviors
  基于组件的架构：快速添加新行为
- **Highly available**: Scale to very serious workloads
  高可用性：扩展到非常严重的工作负载
- **Fault tolerant**: Isolated processes avoid cascading failures
  容错：隔离进程避免级联故障
- **Recoverable**: Failures should be easy to diagnose, debug, and rectify
  可恢复：故障应易于诊断、调试和纠正
- **Open standards**: Be a reference implementation for a community-driven api
  开放标准：成为社区驱动 API 的参考实现

## 安装和配置

这个配置将镜像保存在本地文件系统中。

安装和配置镜像服务之前，必须创建创建一个数据库、服务凭证和API端点。

1. 创建 `glance` 数据库：

   ```mysql
   CREATE DATABASE glance;
   
   GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
   GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
   
   # MySQL 上述命令改为
   create user 'glance'@'localhost' IDENTIFIED BY 'GLANCE_DBPASS';
   create user 'glance'@'%' IDENTIFIED BY 'GLANCE_DBPASS';
   GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' with grant option;
   GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' with grant option;
   flush privileges;
   ```

   用一个合适的密码替换 `GLANCE_DBPASS`。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```bash
   . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建 `glance` 用户：

     ```bash
     openstack user create --domain default --password-prompt glance
     User Password:
     Repeat User Password:
     +---------------------+----------------------------------+
     | Field               | Value                            |
     +---------------------+----------------------------------+
     | domain_id           | default                          |
     | enabled             | True                             |
     | id                  | 3f4e777c4062483ab8d9edd7dff829df |
     | name                | glance                           |
     | options             | {}                               |
     | password_expires_at | None                             |
     +---------------------+----------------------------------+
     ```

   - 添加 `admin` 角色到 `glance` 用户和 `service` 项目上。

     ```bash
     openstack role add --project service --user glance admin
     ```

   - 创建 `glance` 服务实体：

     ```bash
     openstack service create --name glance --description "OpenStack Image" image
     +-------------+----------------------------------+
     | Field       | Value                            |
     +-------------+----------------------------------+
     | description | OpenStack Image                  |
     | enabled     | True                             |
     | id          | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
     | name        | glance                           |
     | type        | image                            |
     +-------------+----------------------------------+
     ```

4. 创建镜像服务的 API 端点：

   ```bash
   openstack endpoint create --region RegionOne image public http://controller:9292
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 340be3625e9b4239a6415d034e98aace |
   | interface    | public                           |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
   | service_name | glance                           |
   | service_type | image                            |
   | url          | http://controller:9292           |
   +--------------+----------------------------------+
   
   openstack endpoint create --region RegionOne image internal http://controller:9292
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | a6e4b153c2ae4c919eccfdbb7dceb5d2 |
   | interface    | internal                         |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
   | service_name | glance                           |
   | service_type | image                            |
   | url          | http://controller:9292           |
   +--------------+----------------------------------+
   
   openstack endpoint create --region RegionOne image admin http://controller:9292
   +--------------+----------------------------------+
   | Field        | Value                            |
   +--------------+----------------------------------+
   | enabled      | True                             |
   | id           | 0c37ed58103f4300a84ff125a539032d |
   | interface    | admin                            |
   | region       | RegionOne                        |
   | region_id    | RegionOne                        |
   | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
   | service_name | glance                           |
   | service_type | image                            |
   | url          | http://controller:9292           |
   +--------------+----------------------------------+
   ```

5. 注册配额限制（可选）：

   If you decide to use per-tenant quotas in Glance, you must register the limits in Keystone first:
   如果您决定在 Glance 中使用每租户配额，则必须先在 Keystone 中注册限制：

   ```bash
   openstack --os-cloud devstack-system-admin registered limit create \
     --service glance --default-limit 1000 --region RegionOne image_size_total
   
   +---------------+----------------------------------+
   | Field         | Value                            |
   +---------------+----------------------------------+
   | default_limit | 1000                             |
   | description   | None                             |
   | id            | 9cedfc5de80345a9b13ed00c2b5460f2 |
   | region_id     | RegionOne                        |
   | resource_name | image_size_total                 |
   | service_id    | e38c84a2487f49fd9864193bdc8a3174 |
   +---------------+----------------------------------+
   
   $ openstack --os-cloud devstack-system-admin registered limit create \
     --service glance --default-limit 1000 --region RegionOne image_stage_total
   
   +---------------+----------------------------------+
   | Field         | Value                            |
   +---------------+----------------------------------+
   | default_limit | 1000                             |
   | description   | None                             |
   | id            | 5a68712b6ba6496d823d0c66e5e860b9 |
   | region_id     | RegionOne                        |
   | resource_name | image_stage_total                |
   | service_id    | e38c84a2487f49fd9864193bdc8a3174 |
   +---------------+----------------------------------+
   
   $ openstack --os-cloud devstack-system-admin registered limit create \
     --service glance --default-limit 100 --region RegionOne image_count_total
   
   +---------------+----------------------------------+
   | Field         | Value                            |
   +---------------+----------------------------------+
   | default_limit | 100                              |
   | description   | None                             |
   | id            | beb91b043296499f8e6268f29d8b2749 |
   | region_id     | RegionOne                        |
   | resource_name | image_count_total                |
   | service_id    | e38c84a2487f49fd9864193bdc8a3174 |
   +---------------+----------------------------------+
   
   $ openstack --os-cloud devstack-system-admin registered limit create \
     --service glance --default-limit 100 --region RegionOne image_count_uploading
   
   +---------------+----------------------------------+
   | Field         | Value                            |
   +---------------+----------------------------------+
   | default_limit | 100                              |
   | description   | None                             |
   | id            | fc29649c047a45bf9bc03ec4a7bcb8af |
   | region_id     | RegionOne                        |
   | resource_name | image_count_uploading            |
   | service_id    | e38c84a2487f49fd9864193bdc8a3174 |
   +---------------+----------------------------------+
   ```

   Be sure to also set `use_keystone_quotas=True` in your `glance-api.conf` file.
   请务必在您的 `glance-api.conf` 文件中进行设置 `use_keystone_quotas=True` 。

6. 安装软件包：

   > Note 注意
   >
   > Default configuration files vary by distribution. You might need to add these sections and options rather than modifying existing sections and options. Also, an ellipsis (`...`) in the configuration snippets indicates potential default configuration options that you should retain.
   > 默认配置文件因发行版而异。您可能需要添加这些部分和选项，而不是修改现有部分和选项。此外，配置代码段中的省略号 （ `...` ） 表示应保留的潜在默认配置选项。
   >
   > Starting with the Newton release, SUSE OpenStack packages are shipping with the upstream default configuration files. For example `/etc/glance/glance-api.conf`, with customizations in `/etc/glance/glance-api.conf.d/`. While the following instructions modify the default configuration files, adding new files in `/etc/glance/glance-api.conf.d` achieves the same result.
   > 从 Newton 发行版开始，SUSE OpenStack 软件包随上游默认配置文件一起提供。例如 `/etc/glance/glance-api.conf` ，在 中 `/etc/glance/glance-api.conf.d/` 进行自定义。虽然以下说明修改了默认配置文件，但在 中 `/etc/glance/glance-api.conf.d` 添加新文件会获得相同的结果。

   ```bash
   # Ubuntu
   apt install glance
   
   # SUSE
   zypper install openstack-glance openstack-glance-api
   
   # RHEL CentOS
   yum install openstack-glance
   ```

7. 编辑文件 `/etc/glance/glance-api.conf` 并完成如下动作：

   - 在 `[database]` 部分，配置数据库访问：

     ```ini
     [database]
     ...
     connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance
     ```

     将``GLANCE_DBPASS`` 替换为你为镜像服务选择的密码。

   - 在 `[keystone_authtoken]` 和 `[paste_deploy]` 部分，配置认证服务访问：

     ```ini
     [keystone_authtoken]
     # ...
     www_authenticate_uri = http://controller:5000
     auth_url = http://controller:5000
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = Default
     user_domain_name = Default
     project_name = service
     username = glance
     password = GLANCE_PASS
     
     [paste_deploy]
     # ...
     flavor = keystone
     ```

     将 `GLANCE_PASS` 替换为你为认证服务中你为 `glance` 用户选择的密码。

     > 注解：
     >
     > 在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[glance_store]` 部分，配置本地文件系统存储和镜像文件位置：

     ```ini
     [glance_store]
     # ...
     stores = file,http
     default_store = file
     filesystem_store_datadir = /var/lib/glance/images/
     ```

   - 在本节 `[oslo_limit]` 中，配置对 keystone 的访问：

     ```ini
     [oslo_limit]
     auth_url = http://controller:5000
     auth_type = password
     user_domain_id = default
     username = MY_SERVICE
     system_scope = all
     password = MY_PASSWORD
     endpoint_id = ENDPOINT_ID
     region_name = RegionOne
     ```

     Make sure that the MY_SERVICE account has reader access to system-scope resources (like limits):
     确保 MY_SERVICE 帐户具有对系统范围资源（如限制）的读取者访问权限：

     ```bash
     openstack role add --user MY_SERVICE --user-domain Default --system all reader
     ```

   - In the `[DEFAULT]` section, optionally enable per-tenant quotas:
     在该部分中，可以选择启用每个租户的配额：In the `[DEFAULT]` section， optionally enable per-tenant quotas：

     ```ini
     [DEFAULT]
     use_keystone_quotas = True
     ```

     Note that you must have created the registered limits as described above if this is enabled.
     请注意，如果启用此功能，则必须已按上述方式创建已注册的限制。

8. 写入镜像服务数据库：

   ```bash
   su -s /bin/sh -c "glance-manage db_sync" glance
   ```

9. 启动镜像服务、配置他们随机启动：

   ```bash
   systemctl enable openstack-glance-api.service
   systemctl start openstack-glance-api.service
   ```

### 验证操作

使用 CirrOS 对镜像服务进行验证，CirrOS 是一个小型的 Linux 镜像可以用来帮助进行部署测试。

> 注解:
>
> 在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```bash
   . admin-openrc
   ```

2. 下载源镜像：

   ```bash
   wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
   ```

3. 使用 [*QCOW2*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-qemu-copy-on-write-2-qcow2) 磁盘格式， [*bare*](https://docs.openstack.org/mitaka/zh_CN/install-guide-rdo/common/glossary.html#term-bare) 容器格式上传镜像到镜像服务并设置公共可见，这样所有的项目都可以访问它：

   ```bash
   glance image-create --name "cirros" \
     --file cirros-0.4.0-x86_64-disk.img \
     --disk-format qcow2 --container-format bare \
     --visibility=public
   
   +------------------+------------------------------------------------------+
   | Field            | Value                                                |
   +------------------+------------------------------------------------------+
   | checksum         | 133eae9fb1c98f45894a4e60d8736619                     |
   | container_format | bare                                                 |
   | created_at       | 2015-03-26T16:52:10Z                                 |
   | disk_format      | qcow2                                                |
   | file             | /v2/images/cc5c6982-4910-471e-b864-1098015901b5/file |
   | id               | cc5c6982-4910-471e-b864-1098015901b5                 |
   | min_disk         | 0                                                    |
   | min_ram          | 0                                                    |
   | name             | cirros                                               |
   | owner            | ae7a98326b9c455588edd2656d723b9d                     |
   | protected        | False                                                |
   | schema           | /v2/schemas/image                                    |
   | size             | 13200896                                             |
   | status           | active                                               |
   | tags             |                                                      |
   | updated_at       | 2015-03-26T16:52:10Z                                 |
   | virtual_size     | None                                                 |
   | visibility       | public                                               |
   +------------------+------------------------------------------------------+
   ```

4. 确认镜像的上传并验证属性：

   ```bash
   glance image-list
   
   +--------------------------------------+--------+--------+
   | ID                                   | Name   | Status |
   +--------------------------------------+--------+--------+
   | 38047887-61a7-41ea-9b49-27987d5e8bb9 | cirros | active |
   +--------------------------------------+--------+--------+
   ```

