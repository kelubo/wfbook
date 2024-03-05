# Nova

[TOC]

## 概述

使用 Nova 计算服务来托管和管理云计算系统。主要模块由 Python 实现。可以在标准硬件上水平大规模扩展。通过 API 服务器控制虚拟机管理程序。支持 KVM 和 Xen 虚拟化技术。

由下列组件所构成：

- `nova-api` 服务

  接收和响应来自最终用户的计算 API 请求。此服务支持 OpenStack Compute API 。它强制执行某些策略并启动大多数业务流程活动，例如运行实例。

- `nova-api-metadata` 服务

  接受来自虚拟机发送的元数据请求。一般在安装 `nova-network` 服务的多主机模式下使用。

- `nova-compute` 服务

  一个守护进程，通过 Hypervior API 来创建和销毁虚拟机实例。例如：

  * KVM / QEMU 的 Libvirt

  * VMware 的 VMwareAPI

  过程相当复杂的。最为基本的，守护进程接收来自队列的动作请求，转换为一系列的系统命令，如启动一个 KVM 实例，然后到数据库中更新它的状态。

- `nova-scheduler` 服务

  接收来自队列的请求，然后决定虚拟机在哪台计算节点上运行。

- `nova-conductor` 模块

  作用于 `nova-compute` 服务与数据库之间，与它们交互、通信，传递信息。排除了由 `nova-compute` 服务对数据库的直接访问。`nova-conductor` 模块可以水平扩展。但是出于安全考虑，不要将它部署在运行 `nova-compute` 服务的主机节点上。

- `nova-novncproxy` 守护进程

  提供一个代理，用于访问正在运行的实例，通过 VNC 协议，支持基于浏览器的 novnc 客户端。

- `nova-spicehtml5proxy` 守护进程

  提供一个代理，用于访问正在运行的实例，通过 SPICE 协议，支持基于浏览器的 HTML5 客户端。

- 队列

  用于在守护进程间传递消息。常见实现有 `RabbitMQ`  、`Apache Qpid` 以及 `ZeroMQ ` 等 AMQP 消息队列。

- SQL数据库

  存储构建时和运行时的状态，为云基础设施，包括有：

  * 可用实例类型

  * 使用中的实例

  * 可用网络

  * 项目

  理论上，Nova 可以支持任何和 SQL-Alchemy 所支持的后端数据库，通常使用 SQLite3 来做测试可开发工作，MySQL 、MariaDB 和 PostgreSQL 作生产环境。          

## 架构

Nova 使用基于消息、无共享、松耦合、无状态的架构。为避免消息阻塞而造成长时间等待响应，Nova 组件采用异步调用的机制，当请求被接收后，响应即被触发，发送回执，而不关注该请求是否被完成。

## 安装

### 控制节点

在安装和配置计算服务之前，必须创建数据库、服务凭据和 API 终结点。

1. 创建 `nova_api` 、 `nova` 和 `nova_cell0` 数据库：

   ```sql
   CREATE DATABASE nova_api;
   CREATE DATABASE nova;
   CREATE DATABASE nova_cell0;
   ```

   对数据库进行正确的授权：

   ```sql
   GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
   GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';
   
   GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
   GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';
   
   GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'NOVA_DBPASS';
   GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'NOVA_DBPASS';
   ```

   用合适的密码代替 `NOVA_DBPASS`。

2. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```bash
   . admin-openrc
   ```

3. 要创建服务证书，完成这些步骤：

   - 创建 `nova` 用户：

     ```bash
     openstack user create --domain default --password-prompt nova
     User Password:
     Repeat User Password:
     +-----------+----------------------------------+
     | Field     | Value                            |
     +-----------+----------------------------------+
     | domain_id | e0353a670a9e496da891347c589539e9 |
     | enabled   | True                             |
     | id        | 8c46e4760902464b889293a74a0c90a8 |
     | name      | nova                             |
     +-----------+----------------------------------+
     ```

- 给 `nova` 用户添加 `admin` 角色：

  ```bash
  openstack role add --project service --user nova admin
  ```

- 创建 `nova` 服务实体：

  ```bash
  openstack service create --name nova --description "OpenStack Compute" compute
  +-------------+----------------------------------+
  | Field       | Value                            |
  +-------------+----------------------------------+
  | description | OpenStack Compute                |
  | enabled     | True                             |
  | id          | 060d59eac51b4594815603d75a00aba2 |
  | name        | nova                             |
  | type        | compute                          |
  +-------------+----------------------------------+
  ```

4. 创建 Compute 服务 API 端点 ：

   ```bash
   openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
   +--------------+-------------------------------------------+
   | Field        | Value                                     |
   +--------------+-------------------------------------------+
   | enabled      | True                                      |
   | id           | 3c1caa473bfe4390a11e7177894bcc7b          |
   | interface    | public                                    |
   | region       | RegionOne                                 |
   | region_id    | RegionOne                                 |
   | service_id   | e702f6f497ed42e6a8ae3ba2e5871c78          |
   | service_name | nova                                      |
   | service_type | compute                                   |
   | url          | http://controller:8774/v2.1               |
   +--------------+-------------------------------------------+
   
   openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
   +--------------+-------------------------------------------+
   | Field        | Value                                     |
   +--------------+-------------------------------------------+
   | enabled      | True                                      |
   | id           | e3c918de680746a586eac1f2d9bc10ab          |
   | interface    | internal                                  |
   | region       | RegionOne                                 |
   | region_id    | RegionOne                                 |
   | service_id   | e702f6f497ed42e6a8ae3ba2e5871c78          |
   | service_name | nova                                      |
   | service_type | compute                                   |
   | url          | http://controller:8774/v2.1               |
   +--------------+-------------------------------------------+
   
   openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1
   +--------------+-------------------------------------------+
   | Field        | Value                                     |
   +--------------+-------------------------------------------+
   | enabled      | True                                      |
   | id           | 38f7af91666a47cfb97b4dc790b94424          |
   | interface    | admin                                     |
   | region       | RegionOne                                 |
   | region_id    | RegionOne                                 |
   | service_id   | e702f6f497ed42e6a8ae3ba2e5871c78          |
   | service_name | nova                                      |
   | service_type | compute                                   |
   | url          | http://controller:8774/v2.1               |
   +--------------+-------------------------------------------+
   ```

5. 安装 Placement 服务并配置用户和端点

6. 安装软件包：

   ```bash
   yum install openstack-nova-api openstack-nova-conductor \
     openstack-nova-console openstack-nova-novncproxy \
     openstack-nova-scheduler
   ```

7. 编辑``/etc/nova/nova.conf``文件并完成下面的操作：

   - 在``[DEFAULT]``部分，只启用计算和元数据API：

     ```ini
     [DEFAULT]
     ...
     enabled_apis = osapi_compute,metadata
     ```

   - 在``[api_database]``和``[database]``部分，配置数据库的连接：

     ```ini
     [api_database]
     ...
     connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api
     
     [database]
     ...
     connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova
     ```

     用你为 Compute 数据库选择的密码来代替 `NOVA_DBPASS`。

   - 在 “[DEFAULT]” 和 “[oslo_messaging_rabbit]”部分，配置 “RabbitMQ” 消息队列访问：

     ```ini
     [DEFAULT]
     ...
     rpc_backend = rabbit
     
     [oslo_messaging_rabbit]
     ...
     rabbit_host = controller
     rabbit_userid = openstack
     rabbit_password = RABBIT_PASS
     ```

     用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   - 在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

     ```ini
     [DEFAULT]
     ...
     auth_strategy = keystone
     
     [keystone_authtoken]
     ...
     auth_uri = http://controller:5000
     auth_url = http://controller:35357
     memcached_servers = controller:11211
     auth_type = password
     project_domain_name = default
     user_domain_name = default
     project_name = service
     username = nova
     password = NOVA_PASS
     ```

     使用你在身份认证服务中设置的``nova`` 用户的密码替换``NOVA_PASS``。

     > 注解
     > 在 `[keystone_authtoken]` 中注释或者删除其他选项。

   - 在 `[DEFAULT` 部分，配置``my_ip`` 来使用控制节点的管理接口的IP 地址。

     ```ini
     [DEFAULT]
       ...
     my_ip = 10.0.0.11
     ```

    在  `[DEFAULT]` 部分，使能 Networking 服务：

```ini
[DEFAULT]
...
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
```

 


  ```
   
     > 注解
   >
     > 默认情况下，计算服务使用内置的防火墙服务。由于网络服务包含了防火墙服务，你必须使用``nova.virt.firewall.NoopFirewallDriver``防火墙服务来禁用掉计算服务内置的防火墙服务
   
   - 在``[vnc]``部分，配置VNC代理使用控制节点的管理接口IP地址 ：
  
     ```ini
  [vnc]
     ...
  vncserver_listen = $my_ip
     vncserver_proxyclient_address = $my_ip
  ```

- 在 `[glance]` 区域，配置镜像服务 API 的位置：

  ```ini
     [glance]
  ...
     api_servers = http://controller:9292
  ```

   - 在 `[oslo_concurrency]` 部分，配置锁路径：

     ```ini
     [oslo_concurrency]
     ...
     lock_path = /var/lib/nova/tmp
     ```

1. 同步Compute 数据库：

   ```bash
   su -s /bin/sh -c "nova-manage api_db sync" nova
   su -s /bin/sh -c "nova-manage db sync" nova
   ```


8. 启动 Compute 服务并将其设置为随系统启动：

   ```bash
   systemctl enable openstack-nova-api.service \
     openstack-nova-consoleauth.service openstack-nova-scheduler.service \
     openstack-nova-conductor.service openstack-nova-novncproxy.service
   systemctl start openstack-nova-api.service \
     openstack-nova-consoleauth.service openstack-nova-scheduler.service \
     openstack-nova-conductor.service openstack-nova-novncproxy.service
   ```

### 计算节点

计算服务支持多种虚拟化方式来部署 instances 或 VM 。通常采用 KVM 和 Xen 。

计算节点需支持对虚拟化的硬件加速。对于传统的硬件，本配置使用generic qumu的虚拟化方式。

1. 安装软件包：

   ```bash
   yum install openstack-nova-compute
   ```

2. 编辑``/etc/nova/nova.conf``文件并完成下面的操作：

   在``[DEFAULT]`` 和 [oslo_messaging_rabbit]部分，配置``RabbitMQ``消息队列的连接：

   ```ini
   [DEFAULT]
   ...
   rpc_backend = rabbit
   
   [oslo_messaging_rabbit]
   ...
   rabbit_host = controller
   rabbit_userid = openstack
   rabbit_password = RABBIT_PASS
   ```

   用你在 “RabbitMQ” 中为 “openstack” 选择的密码替换 “RABBIT_PASS”。

   在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问：

   ```ini
   [DEFAULT]
   ...
   auth_strategy = keystone
   
   [keystone_authtoken]
   ...
   auth_uri = http://controller:5000
   auth_url = http://controller:35357
   memcached_servers = controller:11211
   auth_type = password
   project_domain_name = default
   user_domain_name = default
   project_name = service
   username = nova
   password = NOVA_PASS
   ```

   使用你在身份认证服务中设置的``nova`` 用户的密码替换``NOVA_PASS``。

   > 注解
   >
   > 在 `[keystone_authtoken]` 中注释或者删除其他选项。

   在 `[DEFAULT]` 部分，配置 `my_ip` 选项：

   ```ini
   [DEFAULT]
   ...
   my_ip = MANAGEMENT_INTERFACE_IP_ADDRESS
   ```

   将其中的 `MANAGEMENT_INTERFACE_IP_ADDRESS` 替换为计算节点上的管理网络接口的 IP 地址，例如 第一个节点 10.0.0.31 。

   在  `[DEFAULT]` 部分，使能 Networking 服务：

   ```ini
   [DEFAULT]
   ...
   use_neutron = True
   firewall_driver = nova.virt.firewall.NoopFirewallDriver
   ```

   > 注解
   > 缺省情况下，Compute 使用内置的防火墙服务。由于 Networking 包含了防火墙服务，所以你必须通过使用 `nova.virt.firewall.NoopFirewallDriver` 来去除 Compute 内置的防火墙服务。

   在``[vnc]``部分，启用并配置远程控制台访问：

   ```ini
   [vnc]
   ...
   enabled = True
   vncserver_listen = 0.0.0.0
   vncserver_proxyclient_address = $my_ip
   novncproxy_base_url = http://controller:6080/vnc_auto.html
   ```

   服务器组件监听所有的 IP 地址，而代理组件仅仅监听计算节点管理网络接口的 IP 地址。基本的 URL 指示您可以使用 web 浏览器访问位于该计算节点上实例的远程控制台的位置。

   > 注解
   > 如你运行浏览器的主机无法解析``controller`` 主机名，你可以将 `controller` 替换为你控制节点管理网络的IP地址。

   在 `[glance]` 区域，配置镜像服务 API 的位置：

   ```ini
   [glance]
   ...
   api_servers = http://controller:9292
   ```

   在 `[oslo_concurrency]` 部分，配置锁路径：

   ```ini
   [oslo_concurrency]
   ...
   lock_path = /var/lib/nova/tmp
   ```

3. 确定您的计算节点是否支持虚拟机的硬件加速。

   ```bash
   egrep -c '(vmx|svm)' /proc/cpuinfo
   ```

   如果这个命令返回了 `one or greater` 的值，那么你的计算节点支持硬件加速且不需要额外的配置。

   如果这个命令返回了 `zero` 值，那么你的计算节点不支持硬件加速。必须配置 `libvirt` 来使用 QEMU 去代替 KVM

   在 `/etc/nova/nova.conf` 文件的  `[libvirt]` 区域做出如下的编辑：

   ```ini
   [libvirt]
   ...
   virt_type = qemu
   ```

4. 启动计算服务及其依赖，并将其配置为随系统自动启动：

   ```bash
   systemctl enable libvirtd.service openstack-nova-compute.service
   systemctl start libvirtd.service openstack-nova-compute.service
   ```

### 验证操作

> 注解
>
> 在控制节点上执行这些命令。

1. 获得 `admin` 凭证来获取只有管理员能执行的命令的访问权限：

   ```bash
   . admin-openrc
   ```

2. 列出服务组件，以验证是否成功启动并注册了每个进程：

   ```bash
   openstack compute service list
   +----+--------------------+------------+----------+---------+-------+----------------------------+
   | Id | Binary             | Host       | Zone     | Status  | State | Updated At                 |
   +----+--------------------+------------+----------+---------+-------+----------------------------+
   |  1 | nova-consoleauth   | controller | internal | enabled | up    | 2016-02-09T23:11:15.000000 |
   |  2 | nova-scheduler     | controller | internal | enabled | up    | 2016-02-09T23:11:15.000000 |
   |  3 | nova-conductor     | controller | internal | enabled | up    | 2016-02-09T23:11:16.000000 |
   |  4 | nova-compute       | compute1   | nova     | enabled | up    | 2016-02-09T23:11:20.000000 |
   +----+--------------------+------------+----------+---------+-------+----------------------------+
   ```

   > 注解

>该输出应该显示三个服务组件在控制节点上启用，一个服务组件在计算节点上启用。